package HTML::FormHandler::Widget::Hidden;

use Moose::Role;
#with 'HTML::FormHandler::Widget::Wrapper::Div';

sub render
{
   my ( $self, $result ) = @_;

   $result ||= $self->result;
   my $output = "\n";
   $output .= '<input type="hidden" name="';
   $output .= $self->html_name . '"';
   $output .= ' id="' . $self->id . '"';
   $output .= ' value="' . $self->fif($result) . '" />';
   $output .= "\n";

   return $output;
}

1;
