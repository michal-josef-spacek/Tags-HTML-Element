use strict;
use warnings;

use Data::HTML::Element::Textarea;
use English;
use Error::Pure::Utils qw(clean);
use Tags::HTML::Element::Textarea;
use Test::More 'tests' => 5;
use Test::NoWarnings;
use Tags::Output::Structure;

# Test.
my $tags = Tags::Output::Structure->new;
my $obj = Tags::HTML::Element::Textarea->new(
	'tags' => $tags,
);
my $textarea = Data::HTML::Element::Textarea->new;
$obj->init($textarea);
$obj->process;
my $ret_ar = $tags->flush(1);
is_deeply(
	$ret_ar,
	[
		['b', 'textarea'],
		['e', 'textarea'],
	],
	'Input HTML code (textarea).',
);

# Test.
$tags = Tags::Output::Structure->new;
$obj = Tags::HTML::Element::Textarea->new(
	'tags' => $tags,
);
$textarea = Data::HTML::Element::Textarea->new(
	'autofocus' => 1,
	'disabled' => 1,
	'readonly' => 1,
	'required' => 1,
);
$obj->init($textarea);
$obj->process;
$ret_ar = $tags->flush(1);
is_deeply(
	$ret_ar,
	[
		['b', 'textarea'],
		['a', 'autofocus', 'autofocus'],
		['a', 'readonly', 'readonly'],
		['a', 'disabled', 'disabled'],
		['a', 'required', 'required'],
		['e', 'textarea'],
	],
	'Input HTML code (textarea with boolean values).',
);

# Test.
$tags = Tags::Output::Structure->new;
$obj = Tags::HTML::Element::Textarea->new(
	'tags' => $tags,
);
$textarea = Data::HTML::Element::Textarea->new(
	'cols' => 2,
	'css_class' => 'foo',
	'form' => 'form-id',
	'id' => 'textarea-id',
	'name' => 'textarea-name',
	'placeholder' => 'Fill value',
	'rows' => 5,
	'value' => 'textarea value',
);
$obj->init($textarea);
$obj->process;
$ret_ar = $tags->flush(1);
is_deeply(
	$ret_ar,
	[
		['b', 'textarea'],
		['a', 'class', 'foo'],
		['a', 'id', 'textarea-id'],
		['a', 'name', 'textarea-name'],
		['a', 'placeholder', 'Fill value'],
		['a', 'cols', 2],
		['a', 'rows', 5],
		['a', 'form', 'form-id'],
		['d', 'textarea value'],
		['e', 'textarea'],
	],
	'Input HTML code (textarea with attributes and value).',
);

# Test.
$obj = Tags::HTML::Element::Textarea->new;
eval {
	$obj->process;
};
is($EVAL_ERROR, "Parameter 'tags' isn't defined.\n", "Parameter 'tags' isn't defined.");
clean();
