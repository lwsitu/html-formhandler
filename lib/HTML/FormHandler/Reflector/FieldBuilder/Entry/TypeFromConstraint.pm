use MooseX::Declare;

namespace HTML::FormHandler::Reflector::FieldBuilder;

=head1 NAME

HTML::FormHandler::Reflector::FieldBuilder::Entry::TypeFromConstraint

=head1 SYNOPSIS

Uses typemap to translate from Moose type to FormHandler field type.

=cut

class ::Entry::TypeFromConstraint
  with ::Entry {
    use HTML::FormHandler::Reflector::Types qw(TypeMap);

    has typemap => (
        is  => 'ro',
        isa => TypeMap,
    );

    method match ($attr) {
        $attr->has_type_constraint && $self->typemap->has_entry_for($attr->type_constraint)
    }

    method apply ($attr) {
        $self->typemap->resolve($attr->type_constraint)->($attr);
    }
}
