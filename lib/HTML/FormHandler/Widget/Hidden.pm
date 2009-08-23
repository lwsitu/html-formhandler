package HTML::FormHandler::Widget::Hidden;

use Moose::Role;

sub render
{
   my ( $self, $result ) = @_;

   $result || = $self->result;
   my $output = '<input type="hidden" name="';
   $output .= $self->html_name . '"';
   $output .= ' id="' . $self->id . '"';
   $output .= ' value="' . $result->fif . '" />';
   return $output;
}

1;
