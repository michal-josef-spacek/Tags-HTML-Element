package Tags::HTML::Element::Form::Items;

use base qw(Tags::HTML);
use strict;
use warnings;

use Data::HTML::Element::Form;
use Tags::HTML::Element::Form;
use Tags::HTML::Element::Item;

our $VERSION = 0.03;

sub _cleanup {
	my $self = shift;

	delete $self->{'_tags_form'};
	delete $self->{'_tags_item'};

	return;
}

sub _init {
	my ($self, @items) = @_;

	if (! @items) {
		return;
	}

	my %p = (
		'css' => $self->{'css'},
		'tags' => $self->{'tags'},
	);

	$self->{'_tags_item'} = Tags::HTML::Element::Item->new(%p);
	$self->{'_tags_item'}->init(@items);

	$self->{'_tags_item'}->process_css;
	my $form = Data::HTML::Element::Form->new(
		'css_class' => 'form',
		'data_type' => 'cb',
		'data' => [sub {
			$self->{'_tags_item'}->process_css;
			$self->{'_tags_item'}->process;
		}],
	);

	$self->{'_tags_form'} = Tags::HTML::Element::Form->new(%p);
	$self->{'_tags_form'}->init($form);

	return;
}

# Process 'Tags'.
sub _process {
	my $self = shift;

	if (! exists $self->{'_tags_item'}) {
		return;
	}

	$self->{'_tags_form'}->process;

	return;
}

sub _process_css {
	my $self = shift;

	if (! exists $self->{'_tags_item'}) {
		return;
	}

	$self->{'_tags_form'}->process_css;

	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tags::HTML::Element::Form::Items - Tags helper for HTML form element with Items.

=head1 SYNOPSIS

 use Tags::HTML::Element::Form;

 my $obj = Tags::HTML::Element::Form::Items->new(%params);
 $obj->cleanup;
 $obj->init(@items);
 $obj->prepare;
 $obj->process;
 $obj->process_css;

=head1 METHODS

=head2 C<new>

 my $obj = Tags::HTML::Element::Form::Items->new(%params);

Constructor.

=over 8

=item * C<css>

'L<CSS::Struct::Output>' object for L</process_css> processing.

Default value is undef.

=item * C<tags>

'L<Tags::Output>' object for L</process> processing.

Default value is undef.

=back

=head2 C<init>

 $obj->init(@items);

Initialize L<Tags> structure for fields defined in C<@items>.

Accepted items in C<@items> are objects:

=over

=item * L<Data::HTML::Element::A>

=item * L<Data::HTML::Element::Button>

=item * L<Data::HTML::Element::Input>

=item * L<Data::HTML::Element::Select>

=item * L<Data::HTML::Element::Textarea>

=back

Returns undef.

=head2 C<prepare>

 $obj->prepare;

Process initialization before page run.

Do nothing in this object.

Returns undef.

=head2 C<process>

 $obj->process;

Process L<Tags> structure to output.

Returns undef.

=head2 C<process_css>

 $obj->process_css;

Process L<CSS::Struct> structure for output.

Returns undef.

=head1 ERRORS

 new():
         From Class::Utils::set_params():
                 Unknown parameter '%s'.
         From Tags::HTML::new():
                 Parameter 'css' must be a 'CSS::Struct::Output::*' class.
                 Parameter 'tags' must be a 'Tags::Output::*' class.

 init():
         From Tags::HTML::init():
                 Form object must be a 'Data::HTML::Element::Form' instance.

 process():
         From Tags::HTML::process():
                 Parameter 'tags' isn't defined.

 process_css():
         From Tags::HTML::process_css():
                 Parameter 'css' isn't defined.

=head1 EXAMPLE

=for comment filename=form_items.pl

 use strict;
 use warnings;

 use CSS::Struct::Output::Indent;
 use Data::HTML::Element::Button;
 use Data::HTML::Element::Input;
 use Tags::HTML::Element::Form::Items;
 use Tags::Output::Indent;

 # Object.
 my $css = CSS::Struct::Output::Indent->new;
 my $tags = Tags::Output::Indent->new;
 my $obj = Tags::HTML::Element::Form::Items->new(
         'css' => $css,
         'tags' => $tags,
 );

 my $input = Data::HTML::Element::Input->new(
         'css_class' => 'input',
         'id' => 'one',
         'label' => 'Input field',
 );

 my $submit = Data::HTML::Element::Button->new(
         'css_class' => 'submit',
         'data' => ['Save'],
         'type' => 'submit',
 );

 # Initialize.
 $obj->init($input, $submit);

 # Process form.
 $obj->process;
 $obj->process_css;

 # Print out.
 print $tags->flush;
 print "\n\n";
 print $css->flush;

 # Output:
 # TODO

=head1 DEPENDENCIES

L<Class::Utils>,
L<Error::Pure>,
L<Scalar::Util>,
L<Tags::HTML>,
L<Tags::HTML::Element::Utils>.

=head1 REPOSITORY

L<https://github.com/michal-josef-spacek/Tags-HTML-Element>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© 2022-2024 Michal Josef Špaček

BSD 2-Clause License

=head1 VERSION

0.03

=cut
