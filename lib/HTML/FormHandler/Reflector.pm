package HTML::FormHandler::Reflector;

use Moose;
use MooseX::Types::Moose qw/Object Str/;
use HTML::FormHandler::Reflector::Types qw/FieldBuilder/;
use aliased 'HTML::FormHandler::Reflector::Meta::Attribute::NoField';
use aliased 'HTML::FormHandler::Reflector::Meta::Attribute::Field';
use aliased 'HTML::FormHandler::Reflector::FieldBuilder::Default', 'DefaultFieldBuilder';

use namespace::autoclean;

=head1 NAME

HTML::FormHandler::Reflector

=head1 SYNOPSIS

This package will introspect Moose classes to automatically create the fields
in a L<HTML::FormHandler> form.

  package Foo;
  use Moose;
  use MooseX::Types::Moose qw/Str Num/;
  use namespace::autoclean;

  # does not create field because it has no writer
  has bar => (is => 'ro', isa => Str);
  # creates field because 'rw'
  has baz => (is => 'rw', isa => Num);

  # does not create field because of NoField trait
  has corge => (
      traits   => [qw(FormHandler::NoField)],
      is       => 'rw',
      init_arg => undef,
      lazy     => 1,
      default  => sub { shift->bar },
  );

  # 'FormHandler::Field' trait allows declaring field attributes
  # with 'form' hashref
  has fred => (
      traits   => [qw(FormHandler::Field)],
      is       => 'rw',
      isa      => Str,
      required => 1,
      form     => {
          label => 'Grault',
          type  => 'TextArea',
      },
  );

Create a reflector on the class in a FormHandler form, and
reflect the class's attributes:

   package FooForm;
   use Moose;
   use HTML::FormHandler::Reflector;
   use HTML::FormHandler::Moose;

   extends 'HTML::FormHandler';


   my $reflector = HTML::FormHandler::Reflector->new({
       metaclass    => Foo->meta,
       target_class => __PACKAGE__,
   });

   $reflector->reflect;

   has_field submit => (type => 'Submit');

The form created this way will have three active fields: baz, fred,
and submit.

=head1 DESCRIPTION

=head1 Default FieldBuilder

L<HTML::FormHandler::Reflector::FieldBuilder::Default> provides a set of 
L<HTML::FormHandler::Reflector::FieldBuilder::Entry> classes that use various methods
to create the desired FormHandler fields. Currently it uses SkipField,
NameFromAttribute, TypeFromConstraint, ValidateWithConstraint, and
OptionsFromTrait manipulations.

Using the SkipField entry built by the default FieldBuilder, active fields
will not be created when:

  Attribute is read only
  Attribute does HTML::FormHandler::NoField trait
  Attribute name starts with an underscore

The TypeFromConstraint entry will build fields with the default type (Text) unless 
the Field type is specified in the 'form' hash (without a more specific TypeMap). 

The ValidateWithConstraint entry causes the Moose type of the attribute ('isa') to
be pulled into the created fields using the 'apply' syntax. An attribute with the 
Str type will have the equivalent of: C<< apply => [Str] >>.

OptionsFromTrait will pull the options for a Select field from the method specified
on the attribute with 'options_reader'.

The FieldBuilder entry RequiredFromAttribute will mark fields 'required' if the 
attribute is 'required', but is not installed into the default FieldBuilder.

=head2 Customizing the FieldBuilder

You can create your own TypeMap entries and pass them into the default Typemap,
or create your own TypeMap and pass it into the default FieldBuilder.

=cut

has metaclass => (
    is       => 'ro',
    isa      => Object,
    required => 1,
);

has target_class => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

has target_metaclass => (
    is      => 'ro',
    isa     => Object,
    lazy    => 1,
    builder => '_build_target_metaclass',
);

has field_builder => (
    is      => 'ro',
    isa     => FieldBuilder,
    default => sub { DefaultFieldBuilder->new },
);

sub _build_target_metaclass {
    my ($self) = @_;

    my $meta = Class::MOP::class_of($self->target_class);
    return $meta if $meta;

    $meta = Moose::Meta::Class->create(
        $self->target_class => (
            superclasses => ['HTML::FormHandler'],
            methods      => {
                meta => sub { $meta },
            },
        ),
    );

    $meta = Moose::Util::MetaRole::apply_metaclass_roles(
        for_class       => $meta,
        metaclass_roles => ['HTML::FormHandler::Meta::Role'],
    );

    return $meta;
}

sub reflect {
    my ($self) = @_;
    my $target = $self->target_metaclass;

    # XXX: at some point we probably want to reflect a form instance out of a
    # metaclass, but most of the logic is the same really, so for now we just
    # rely on the formhandler metaclass trait to be there
    $target->add_to_field_list($_)
        for $self->reflect_class($self->metaclass);

    return $target;
}

sub reflect_class {
    my ($self, $metaclass) = @_;

    return map {
        $self->reflect_attribute($_)
    } sort { # XXX: i suppose fields might want to decide on their order themself, probably using the
             # Form trait and either some numeric order, or something like "after $that field". we
             # quite possibly also want to accept a custom sort function as well.
        $a->has_insertion_order && $b->has_insertion_order ? $a->insertion_order <=> $b->insertion_order
      : $a->has_insertion_order                            ? -1
      : $b->has_insertion_order                            ?  1
      :                                                       0
    } $metaclass->get_all_attributes;
}

sub reflect_attribute {
    my ($self, $attr) = @_;
    return $self->field_builder->resolve($attr);
}

__PACKAGE__->meta->make_immutable;

1;
