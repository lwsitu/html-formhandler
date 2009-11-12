use MooseX::Declare;

=head1 NAME

HTML::FormHandler::Reflector::FieldBuilder::Entry::RequiredFromAttribute

=head1 SYNOPSIS

Sets the field to required if the attribute is required

=cut

namespace HTML::FormHandler::Reflector::FieldBuilder;

class ::Entry::RequiredFromAttribute
  with ::Entry {
    method match ($attr) { 1 }
    method apply ($attr) { (required => $attr->is_required) }
}
