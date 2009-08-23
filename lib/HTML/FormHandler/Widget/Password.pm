package HTML::FormHandler::Widget::Password;

use Moose::Role;

sub render
{
   my ( $self, $result ) = @_;

   $result ||= $self->result;
   my $output = '<input type="password" name="';
   $output .= $self->html_name . '"';
   $output .= ' id="' . $self->id . '"';
   $output .= ' size="' . $self->size . '"' if $self->size;
   $output .= ' maxlength="' . $self->maxlength . '"' if $self->maxlength;
   $output .= ' value="' . $result->fif . '" />';
   return $output;
}

no Moose::Role;
1;
