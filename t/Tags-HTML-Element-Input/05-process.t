use strict;
use warnings;

use Data::HTML::Element::Input;
use English;
use Error::Pure::Utils qw(clean);
use Tags::HTML::Element::Input;
use Tags::Output::Structure;
use Test::More 'tests' => 6;
use Test::NoWarnings;

# Test.
my $tags = Tags::Output::Structure->new;
my $obj = Tags::HTML::Element::Input->new(
	'tags' => $tags,
);
my $input = Data::HTML::Element::Input->new(
	'value' => 'Custom save',
	'type' => 'submit',
);
$obj->init($input);
$obj->process;
my $ret_ar = $tags->flush(1);
is_deeply(
	$ret_ar,
	[
		['b', 'input'],
		['a', 'type', 'submit'],
		['a', 'value', 'Custom save'],
		['e', 'input'],
	],
	'Input HTML code (submit button).',
);

# Test
$tags = Tags::Output::Structure->new;
$obj = Tags::HTML::Element::Input->new(
	'tags' => $tags,
);
$input = Data::HTML::Element::Input->new(
	'checked' => 0,
	'type' => 'checkbox',
);
$obj->init($input);
$obj->process;
$ret_ar = $tags->flush(1);
is_deeply(
	$ret_ar,
	[
		['b', 'input'],
		['a', 'type', 'checkbox'],
		['e', 'input'],
	],
	'Input HTML code (checkbox).',
);

# Test
$tags = Tags::Output::Structure->new;
$obj = Tags::HTML::Element::Input->new(
	'tags' => $tags,
);
$input = Data::HTML::Element::Input->new(
	'checked' => 0,
	'label' => 'Input',
	'required' => 1,
	'type' => 'checkbox',
);
$obj->init($input);
$obj->process;
$ret_ar = $tags->flush(1);
is_deeply(
	$ret_ar,
	[
		['b', 'label'],
		['d', 'Input'],
		['b', 'span'],
		['a', 'class', 'required'],
		['d', '*'],
		['e', 'span'],
		['e', 'label'],
		['b', 'input'],
		['a', 'type', 'checkbox'],
		['e', 'input'],
	],
	'Input HTML code (required checkbox with label).',
);

# Test
$tags = Tags::Output::Structure->new;
$obj = Tags::HTML::Element::Input->new(
	'tags' => $tags,
);
$input = Data::HTML::Element::Input->new(
	'type' => 'number',
	'step' => 0.000001,
	'min' => 0,
	'max' => 1,
);
$obj->init($input);
$obj->process;
$ret_ar = $tags->flush(1);
is_deeply(
	$ret_ar,
	[
		['b', 'input'],
		['a', 'type', 'number'],
		['a', 'min', 0],
		['a', 'max', 1],
		# In string version is 1e-06, on Windows 1e-006
		['a', 'step', 0.000001],
		['e', 'input'],
	],
	'Input HTML code (number with min, max and step).',
);

# Test.
$obj = Tags::HTML::Element::Input->new;
eval {
	$obj->process;
};
is($EVAL_ERROR, "Parameter 'tags' isn't defined.\n",
	"Parameter 'tags' isn't defined.");
clean();
