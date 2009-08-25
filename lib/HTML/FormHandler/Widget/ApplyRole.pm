package HTML::FormHandler::Widget::ApplyRole;

use Moose::Role;

sub apply_widget_role
{
   my ( $self, $target,  $widget_name, $dir ) = @_;

   my $widget_name_space = $self->widget_name_space;
   $dir =  $dir ? '::' . $dir . '::' : '::';
   my @name_spaces;
   push @name_spaces, ref $widget_name_space ? 
        @{$widget_name_space} : $widget_name_space if $widget_name_space;
   push @name_spaces, 'HTML::FormHandler::Widget';
   my $meta;
   foreach my $ns ( @name_spaces ) {
      my $render_role = $ns . $dir .  $self->widget_class($widget_name);
      $meta = Class::MOP::load_class($render_role);
      if( ref $meta eq 'Moose::Meta::Role' )
      {
         $target->meta->make_mutable;                      
         $render_role->meta->apply($target);
         $target->meta->make_immutable;
         last;
      }
   }

}

# this is for compatibility with widget names like 'radio_group'
# RadioGroup, Textarea, etc. also work
sub widget_class
{
   my ( $self, $widget ) = @_;
   return unless $widget;
   $widget =~ s/^(\w{1})/\u$1/g;
   $widget =~ s/_(\w{1})/\u$1/g;
   return $widget;
}

1;
