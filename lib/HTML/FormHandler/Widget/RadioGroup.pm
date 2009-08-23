package HTML::FormHandler::Widget::RadioGroup;

use Moose::Role;

sub render
{
   my ( $self, $result ) = @_;

   $result ||= $self->result;
   my $output = " <br />";
   my $index  = 0;
   foreach my $option ( $self->options ) {
      $output .= '<input type="radio" value="' . $option->{value} . '"';
      $output .= ' name="' . $self->html_name . '" id="' . $self->id . ".$index\"";
      $output .= ' checked="checked"' if $option->{value} eq $result->fif;
      $output .= ' />';
      $output .= $option->{label} . '<br />';
      $index++;
   }
   return $output;
}

1;
