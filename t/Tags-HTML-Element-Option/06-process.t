use strict;
use warnings;

use Data::HTML::Element::Option;
use English;
use Error::Pure::Utils qw(clean);
use Tags::HTML::Element::Option;
use Test::More 'tests' => 3;
use Test::NoWarnings;
use Tags::Output::Raw;

# Test.
my $tags = Tags::Output::Raw->new;
my $option = Data::HTML::Element::Option->new;
my $obj = Tags::HTML::Element::Option->new(
	'tags' => $tags,
);
$obj->init($option);
$obj->process;
my $ret = $tags->flush(1);
my $right_ret = <<'END';
<option></option>
END
chomp $right_ret;
is($ret, $right_ret, "Option defaults.");

# Test.
$obj = Tags::HTML::Element::Option->new;
eval {
	$obj->process;
};
is($EVAL_ERROR, "Parameter 'tags' isn't defined.\n", "Parameter 'tags' isn't defined.");
clean();

