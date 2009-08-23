package HTML::FormHandler::Widget::RadioGroup;

use Moose::Role;
with 'HTML::FormHandler::Widget::Field';

sub render
{
   my ( $self, $result ) = @_;

   $result ||= $self->result;
   my $output = " <br />";
   my $index  = 0;
   foreach my $option ( $self->options ) {
      $output .= '<input type="radio" value="' . $option->{value} . '"';
      $output .= ' name="' . $self->html_name . '" id="' . $self->id . ".$index\"";
      $output .= ' checked="checked"' if $option->{value} eq $self->fif($result);
      $output .= ' />';
      $output .= $option->{label} . '<br />';
      $index++;
   }
   return $self->render_field($result, $output);
}

1;
