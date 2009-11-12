use MooseX::Declare;

namespace HTML::FormHandler::Reflector::FieldBuilder;

=head1 NAME

HTML::FormHandler::Reflector::FieldBuilder::Entry::OptionsFromTrait

=head1 SYNOPSIS

Applies 'option_reader'

=cut

class ::Entry::OptionsFromTrait
  with ::Entry {
    use MooseX::Types::Moose qw(RoleName Str);

    has trait => (
        is  => 'ro',
        isa => RoleName,
    );

    has option_reader => (
        is  => 'ro',
        isa => Str,
    );

    method match ($attr) { $attr->does($self->trait) }
    method apply ($attr) { %{ $attr->${ \$self->option_reader } || {} } }
}
