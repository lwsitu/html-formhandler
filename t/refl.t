use strict;
use warnings;
use Test::More;

{
    package Foo;
    use Moose;
    use MooseX::Types::Moose qw/Str Num/;
    use namespace::autoclean;

    has foo => (is => 'rw', isa => Str);
    has bar => (is => 'ro', isa => Str);
    has baz => (is => 'rw', isa => Num);
    has bax => (is => 'rw', isa => 'Bool');

    __PACKAGE__->meta->make_immutable;
}

{
    package FooForm;
    use Moose;
    use HTML::FormHandler::Reflector;
    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler';

    my $reflector = HTML::FormHandler::Reflector->new({
        metaclass    => Foo->meta,
        target_class => __PACKAGE__,
    });

    $reflector->reflect;

    has_field submit => (type => 'Submit');

    __PACKAGE__->meta->make_immutable;
}

my $form = FooForm->new;
isa_ok($form, 'HTML::FormHandler');

my @fields = $form->fields;
is_deeply(
    [sort map { $_->name } grep { !$_->inactive } @fields],
    [qw/bax baz foo submit/],
    'form has fields for every attribute',
);

is_deeply(
    [sort map { $_->name } @fields],
    [qw/bar bax baz foo submit/],
    'form has fields for every attribute',
);

$form = HTML::FormHandler->new( reflect_class => 'Foo',
  field_list => [ submit => { type => 'Submit'} ]);
isa_ok($form, 'HTML::FormHandler');
ok( $form->field('bax'), 'bax field exists' );

@fields = $form->fields;
is_deeply(
    [sort map { $_->name } grep { !$_->inactive } @fields],
    [qw/bax baz foo submit/],
    'form has fields for every attribute',
);

done_testing;
