use strict;
use warnings;

use Data::HTML::Element::A;
use English;
use Error::Pure::Utils qw(clean);
use Tags::HTML::Element::A;
use Test::MockObject;
use Test::More 'tests' => 5;
use Test::NoWarnings;

# Test.
my $obj = Tags::HTML::Element::A->new;
my $anchor = Data::HTML::Element::A->new;
my $ret = $obj->init($anchor);
is($ret, undef, 'Init returns undef.');

# Test.
$obj = Tags::HTML::Element::A->new;
eval {
	$obj->init;
};
is($EVAL_ERROR, "Anchor object must be a 'Data::HTML::Element::A' instance.\n",
	"Anchor object must be a 'Data::HTML::Element::A' instance.");
clean();

# Test.
$obj = Tags::HTML::Element::A->new;
eval {
	$obj->init(Test::MockObject->new);
};
is($EVAL_ERROR, "Anchor object must be a 'Data::HTML::Element::A' instance.\n",
	"Anchor object must be a 'Data::HTML::Element::A' instance.");
clean();

# Test.
$obj = Tags::HTML::Element::A->new;
eval {
	$obj->init('bad');
};
is($EVAL_ERROR, "Anchor object must be a 'Data::HTML::Element::A' instance.\n",
	"Anchor object must be a 'Data::HTML::Element::A' instance.");
clean();
