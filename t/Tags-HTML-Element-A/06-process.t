use strict;
use warnings;

use Data::HTML::Element::A;
use English;
use Error::Pure::Utils qw(clean);
use Tags::HTML::Element::A;
use Tags::Output::Raw;
use Test::More 'tests' => 7;
use Test::NoWarnings;

# Test.
my $tags = Tags::Output::Raw->new;
my $obj = Tags::HTML::Element::A->new(
	'tags' => $tags,
);
my $anchor = Data::HTML::Element::A->new;
$obj->init($anchor);
$obj->process;
my $ret = $tags->flush(1);
my $right_ret = <<'END';
<a></a>
END
chomp $right_ret;
is($ret, $right_ret, "A defaults.");

# Test.
$tags = Tags::Output::Raw->new;
$obj = Tags::HTML::Element::A->new(
	'tags' => $tags,
);
$anchor = Data::HTML::Element::A->new(
	'css_class' => 'foo',
	'data' => ['Link'],
	'id' => 'one',
	'target' => '_blank',
);
$obj->init($anchor);
$obj->process;
$ret = $tags->flush(1);
$right_ret = <<'END';
<a class="foo" id="one" target="_blank">Link</a>
END
chomp $right_ret;
is($ret, $right_ret, "A with CSS class, id and target.");

# Test.
$tags = Tags::Output::Raw->new;
$obj = Tags::HTML::Element::A->new(
	'tags' => $tags,
);
$anchor = Data::HTML::Element::A->new(
	'data' => ['Link'],
	'url' => 'https://example.com',
);
$obj->init($anchor);
$obj->process;
$ret = $tags->flush(1);
$right_ret = <<'END';
<a href="https://example.com">Link</a>
END
chomp $right_ret;
is($ret, $right_ret, "A with href and content.");

# Test.
$tags = Tags::Output::Raw->new;
$obj = Tags::HTML::Element::A->new(
	'tags' => $tags,
);
$anchor = Data::HTML::Element::A->new(
	'data' => [['b', 'span'], ['d', 'Link'], ['e', 'span']],
	'data_type' => 'tags',
	'url' => 'https://example.com',
);
$obj->init($anchor);
$obj->process;
$ret = $tags->flush(1);
$right_ret = <<'END';
<a href="https://example.com"><span>Link</span></a>
END
chomp $right_ret;
is($ret, $right_ret, "A with href and Tags content.");

# Test.
$tags = Tags::Output::Raw->new;
$obj = Tags::HTML::Element::A->new(
	'tags' => $tags,
);
$obj->process;
$ret = $tags->flush(1);
$right_ret = '';
is($ret, $right_ret, "Without initialization.");

# Test.
$obj = Tags::HTML::Element::A->new;
eval {
	$obj->process;
};
is($EVAL_ERROR, "Parameter 'tags' isn't defined.\n", "Parameter 'tags' isn't defined.");
clean();
