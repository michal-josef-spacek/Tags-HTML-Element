use strict;
use warnings;

use CSS::Struct::Output::Structure;
use Data::HTML::Element::Form;
use English;
use Error::Pure::Utils qw(clean);
use Tags::HTML::Element::Form;
use Test::More 'tests' => 4;
use Test::NoWarnings;

# Test.
my $css = CSS::Struct::Output::Structure->new;
my $obj = Tags::HTML::Element::Form->new(
	'css' => $css,
);
my $form = Data::HTML::Element::Form->new(
	'css_class' => 'form',
);
$obj->init($form);
$obj->process_css;
my $ret_ar = $css->flush(1);
is_deeply(
	$ret_ar,
	[
		['s', '.form'],
		['d', 'border-radius', '5px'],
		['d', 'background-color', '#f2f2f2'],
		['d', 'padding', '20px'],
		['e'],

		['s', '.form fieldset'],
		['d', 'padding', '20px'],
		['d', 'border-radius', '15px'],
		['e'],

		['s', '.form legend'],
		['d', 'padding-left', '10px'],
		['d', 'padding-right', '10px'],
		['e'],
	],
	'Form CSS code.',
);

# Test.
$css = CSS::Struct::Output::Structure->new;
$obj = Tags::HTML::Element::Form->new(
	'css' => $css,
);
$obj->process_css;
$ret_ar = $css->flush(1);
is_deeply(
	$ret_ar,
	[],
	'Form CSS code (nothing, without init).',
);

# Test.
$obj = Tags::HTML::Element::Form->new;
eval {
	$obj->process_css;
};
is($EVAL_ERROR, "Parameter 'css' isn't defined.\n",
	"Parameter 'css' isn't defined.");
clean();
