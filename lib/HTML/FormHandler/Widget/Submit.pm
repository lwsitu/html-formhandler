package HTML::FormHandler::Widget::Submit;

use Moose::Role;

sub render
{
   my ( $self, $result ) = @_;

   $result ||= $self->result;
   my $output = '<input type="submit" name="';
   $output .= $self->html_name . '"';
   $output .= ' id="' . $self->id . '"';
   $output .= ' value="' . $self->value . '" />';
   return $output;
}

1;
