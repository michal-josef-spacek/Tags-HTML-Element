use strict;
use warnings;

use Tags::HTML::Element::Select;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
my $obj = Tags::HTML::Element::Select->new;
my $ret = $obj->init;
is($ret, undef, 'Init returns undef.');
