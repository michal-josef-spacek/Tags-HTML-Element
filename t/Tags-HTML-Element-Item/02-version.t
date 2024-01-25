use strict;
use warnings;

use Tags::HTML::Element::Item;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Tags::HTML::Element::Item::VERSION, 0.03, 'Version.');
