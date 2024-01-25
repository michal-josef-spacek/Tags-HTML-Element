use strict;
use warnings;

use Test::NoWarnings;
use Test::Pod::Coverage 'tests' => 2;

# Test.
pod_coverage_ok('Tags::HTML::Element::Form::Items', 'Tags::HTML::Element::Form::Items is covered.');
