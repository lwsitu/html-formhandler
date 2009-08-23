package HTML::FormHandler::Widget::Compound;

use Moose::Role;
with 'HTML::FormHandler::Widget::Field';

sub render
{
   my ( $self, $result ) = @_;

   $result ||= $self->result;
   my $output = '';
   foreach my $subfield ( $self->sorted_fields ) {
      my $subresult = $result->field($subfield->name);
      next unless $subresult;
      $output .= $subfield->render($subresult);
   }
   return $self->render_field($result, $output);
}

1;
