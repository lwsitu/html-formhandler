use MooseX::Declare;

namespace HTML::FormHandler::Reflector;

=head1 NAME

HTML::FormHandler::Reflector::TypeMap::Default

=head1 SYNOPSIS

Like L<HTML::FormHandler::Reflector::TypeMap>,
'extra_subtype_entries' match all subtypes in the L<Moose::Util::TypeConstraint>
type hierarchy. 'extra_entries' will do an exact match on the type.

  my $typemap = HTML::FormHandler::Reflector::TypeMap::Default->new(
      extra_entries => [...], extra_subtype_entries => [...] ); 

Supplies only 'Item' => 'Text' mapping by default.

=cut


class ::TypeMap::Default
  extends ::TypeMap {
    use MooseX::Types::Moose qw(Item ArrayRef);
    use aliased 'HTML::FormHandler::Reflector::TypeMap::Entry', 'TypeMapEntry';

    has extra_entries => (
        is      => 'ro',
        isa     => ArrayRef[TypeMapEntry],
        builder => '_build_extra_entries',
    );

    has extra_subtype_entries => (
        is      => 'ro',
        isa     => ArrayRef[TypeMapEntry],
        builder => '_build_extra_subtype_entries',
    );

    method _build_extra_entries { [] }
    method _build_extra_subtype_entries { [] }

    method _build_subtype_entries {
        return [
            TypeMapEntry->new({
                type_constraint => Item,
                data            => sub { (type => 'Text') },
            }),
            @{ $self->extra_entries },
        ];
    }

    method _build_subtype_entries {
        return [@{ $self->extra_subtype_entries }];
    }
}
