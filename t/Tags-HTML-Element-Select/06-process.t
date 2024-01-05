use strict;
use warnings;

use Data::HTML::Element::Select;
use English;
use Error::Pure::Utils qw(clean);
use Tags::HTML::Element::Select;
use Test::MockObject;
use Test::More 'tests' => 6;
use Test::NoWarnings;
use Tags::Output::Raw;

# Test.
my $obj = Tags::HTML::Element::Select->new;
eval {
	$obj->process;
};
is($EVAL_ERROR, "Parameter 'tags' isn't defined.\n", "Parameter 'tags' isn't defined.");
clean();

# Test.
$obj = Tags::HTML::Element::Select->new(
	'tags' => Tags::Output::Raw->new,
);
eval {
	$obj->process;
};
is($EVAL_ERROR, "Select object must be a 'Data::HTML::Element::Select' instance.\n",
	"Select object must be a 'Data::HTML::Element::Select' instance.");
clean();

# Test.
$obj = Tags::HTML::Element::Select->new(
	'tags' => Tags::Output::Raw->new,
);
eval {
	$obj->process(Test::MockObject->new);
};
is($EVAL_ERROR, "Select object must be a 'Data::HTML::Element::Select' instance.\n",
	"Select object must be a 'Data::HTML::Element::Select' instance.");
clean();

# Test.
$obj = Tags::HTML::Element::Select->new(
	'tags' => Tags::Output::Raw->new,
);
eval {
	$obj->process('bad');
};
is($EVAL_ERROR, "Select object must be a 'Data::HTML::Element::Select' instance.\n",
	"Select object must be a 'Data::HTML::Element::Select' instance.");
clean();

# Test.
my $tags = Tags::Output::Raw->new;
my $select = Data::HTML::Element::Select->new;
$obj = Tags::HTML::Element::Select->new(
	'tags' => $tags,
);
$obj->process($select);
my $ret = $tags->flush(1);
my $right_ret = <<'END';
<select></select>
END
chomp $right_ret;
is($ret, $right_ret, "Select defaults.");
