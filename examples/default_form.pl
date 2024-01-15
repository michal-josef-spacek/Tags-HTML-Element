#!/usr/bin/env perl

use strict;
use warnings;

use CSS::Struct::Output::Indent;
use Tags::HTML::Element::Form;
use Tags::Output::Indent;

# Object.
my $css = CSS::Struct::Output::Indent->new;
my $tags = Tags::Output::Indent->new;
my $obj = Tags::HTML::Element::Form->new(
        'css' => $css,
        'tags' => $tags,
);

# Initialize.
$obj->init;

# Process form.
$obj->process;
$obj->process_css;

# Print out.
print $tags->flush;
print "\n\n";
print $css->flush;

# Output:
# <form class="form" method="GET">
#   <p>
#     <button type="submit">
#       Save
#     </button>
#   </p>
# </form>
# 
# .form {
#         border-radius: 5px;
#         background-color: #f2f2f2;
#         padding: 20px;
# }
# .form fieldset {
#         padding: 20px;
#         border-radius: 15px;
# }
# .form legend {
#         padding-left: 10px;
#         padding-right: 10px;
# }
# .form-required {
#         color: red;
# }
# button {
#         width: 100%;
#         background-color: #4CAF50;
#         color: white;
#         padding: 14px 20px;
#         margin: 8px 0;
#         border: none;
#         border-radius: 4px;
#         cursor: pointer;
# }
# button:hover {
#         background-color: #45a049;
# }