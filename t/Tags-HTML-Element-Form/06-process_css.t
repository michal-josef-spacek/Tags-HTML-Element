use strict;
use warnings;

use CSS::Struct::Output::Structure;
use English;
use Error::Pure::Utils qw(clean);
use Tags::HTML::Element::Form;
use Test::More 'tests' => 3;
use Test::NoWarnings;

# Test.
my $css = CSS::Struct::Output::Structure->new;
my $obj = Tags::HTML::Element::Form->new(
	'css' => $css,
);
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

		['s', '.form-required'],
		['d', 'color', 'red'],
		['e'],

		['s', 'button'],
		['d', 'width', '100%'],
		['d', 'background-color', '#4CAF50'],
		['d', 'color', 'white'],
		['d', 'padding', '14px 20px'],
		['d', 'margin', '8px 0'],
		['d', 'border', 'none'],
		['d', 'border-radius', '4px'],
		['d', 'cursor', 'pointer'],
		['e'],

		['s', 'button:hover'],
		['d', 'background-color', '#45a049'],
		['e'],
	],
	'Form CSS code (stub).',
);

# Test.
$obj = Tags::HTML::Element::Form->new;
eval {
	$obj->process_css;
};
is($EVAL_ERROR, "Parameter 'css' isn't defined.\n",
	"Parameter 'css' isn't defined.");
clean();
