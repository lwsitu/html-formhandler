package HTML::FormHandler::Widget::NoRender;

use Moose::Role;

sub render { '' }

no Moose::Role;
1;
