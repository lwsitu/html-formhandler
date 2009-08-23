package HTML::FormHandler::Widget::Field;

use Moose::Role;

has 'auto_fieldset' => ( isa => 'Bool', is => 'rw', default => 1 );

sub render_label
{
   my $self = shift;
   return '<label class="label" for="' . $self->id . '">' . $self->label . ': </label>';
}

sub render_class
{
   my ( $self, $result ) = @_;

   $result ||= $self->result;
   my $class = '';
   if ( $self->css_class || $result->has_errors ) {
      $class .= ' class="';
      $class .= $self->css_class . ' ' if $self->css_class;
      $class .= ' error"' if $result->has_errors;
   }
   return $class;
}


sub render_field
{
   my ( $self, $result, $rendered_widget ) = @_;

   my $class = $self->render_class( $result );
   my $output = qq{\n<div$class>};
   if ( $self->widget eq 'compound' ) {
      $output .= '<fieldset class="' . $self->html_name . '">';
      $output .= '<legend>' . $self->label . '</legend>';
   }
   elsif ( !$self->has_flag('no_render_label') ) {
      $output .= $self->render_label;
   }
   $output .= $rendered_widget;
   $output .= qq{\n<span class="error_message">$_</span>} for $self->errors;
   if ( $self->widget eq 'compound' ) {
      $output .= '</fieldset>';
   }
   $output .= "</div>\n";
   return $output;
}

1;
