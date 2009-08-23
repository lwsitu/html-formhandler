package HTML::FormHandler::Widget::Checkbox;

use Moose::Role;

sub render
{
   my ( $self, $result ) = @_;

   $result ||= $self->result;
   my $self = $result->self;
   my $fif = $result->fif;
   my $output = '<input type="checkbox" name="';
   $output .=
      $self->html_name . '" id="' . $self->id . '" value="' . $self->checkbox_value . '"';
   $output .= ' checked="checked"' if $fif eq $self->checkbox_value;
   $output .= ' />';
   return $output;
}

1;
