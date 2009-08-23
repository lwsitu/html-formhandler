package HTML::FormHandler::Field::Submit;

use Moose;
extends 'HTML::FormHandler::Field';

=head1 NAME

HTML::FormHandler::Field::Submit - submit field

=head1 SYNOPSIS

Use this field to declare a submit field in your form.

   has_field 'submit' => ( type => 'Submit', value => 'Save' );

It will be used by L<HTML::FormHandler::Render::Simple> to construct
a form with C<< $form->render >>.

Uses the 'submit' widget.

=cut

has 'has_static_value' => ( is => 'ro', default => 1 );
has 'value' => (
   is        => 'ro',
   predicate => 'has_value',
   default   => 'Save',
   init_arg  => 'value',
);
has 'result' => ( isa => 'HTML::FormHandler::Field::Result', is => 'ro',
   builder => 'build_result',
   predicate => 'has_result',
   handles => [ '_set_input', '_clear_input', 'has_input',
#                '_set_value', '_clear_value', 'has_value',
#                'errors', 'push_errors', 'num_errors', 'has_errors', 'clear_errors', 'validated',
              ],
);
sub _result_from_object {  }
sub _result_from_fields {  }
sub _result_from_input {  }
sub build_result
{
   my $self = shift;
   return HTML::FormHandler::Field::Result->new( name => $self->name, 
      field_def => $self );
}

has '+widget'    => ( default => 'submit' );
has '+writeonly' => ( default => 1 );
has '+noupdate'  => ( default => 1 );

sub validate_field { }

sub clear_value { }

__PACKAGE__->meta->make_immutable;
no Moose;
1;
