package Tags::HTML::Element::Form;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Data::HTML::Element::Button;
use Data::HTML::Element::Form;
use Error::Pure qw(err);
use List::Util qw(first);
use Scalar::Util qw(blessed);
use Tags::HTML::Element::Button;
use Tags::HTML::Element::Input;
use Tags::HTML::Element::Select;
use Tags::HTML::Element::Textarea;

our $VERSION = 0.03;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['background_color', 'form', 'submit'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	# Background color.
	$self->{'background_color'} = '#f2f2f2';

	# Form.
	$self->{'form'} = Data::HTML::Element::Form->new(
		'css_class' => 'form',
	);

	# Submit.
	$self->{'submit'} = Data::HTML::Element::Button->new(
		'data' => [
			['d', 'Save'],
		],
		'data_type' => 'tags',
		'type' => 'submit',
	);

	# Process params.
	set_params($self, @{$object_params_ar});

	# Check form.
	if (! defined $self->{'form'}) {
		err "Parameter 'form' is required.";
	}
	if (! blessed($self->{'form'})
		|| ! $self->{'form'}->isa('Data::HTML::Element::Form')) {

		err "Parameter 'form' must be a 'Data::HTML::Element::Form' instance.";
	}
	if (! defined $self->{'form'}->{'css_class'}) {
		err "Parameter 'form' must define 'css_class' parameter.";
	}

	# Check submit.
	if (! defined $self->{'submit'}) {
		err "Parameter 'submit' is required.";
	}
	if (! blessed($self->{'submit'})
		|| (! $self->{'submit'}->isa('Data::HTML::Element::Input')
		&& ! $self->{'submit'}->isa('Data::HTML::Element::Button'))) {

		err "Parameter 'submit' must be a 'Data::HTML::Element::Input' instance.";
	}
	if ($self->{'submit'}->type ne 'submit') {
		err "Parameter 'submit' instance has bad type.";
	}

	# Object.
	return $self;
}

sub _cleanup {
	my $self = shift;

	$self->{'_fields'} = [];
	$self->{'_tags_fields'} = [];
	delete $self->{'_tags_submit_field'};

	return;
}

sub _init {
	my ($self, @fields) = @_;

	my %common = (
		'css' => $self->{'css'},
		'tags' => $self->{'tags'},
	);
	$self->{'_tags_fields'} = [];

	# Check fields.
	foreach my $field (@fields) {
		if (! defined $field
			|| ! blessed($field)
			|| (! $field->isa('Data::HTML::Element::Input')
			&& ! $field->isa('Data::HTML::Element::Select')
			&& ! $field->isa('Data::HTML::Element::Textarea'))) {

			err "Form item must be a 'Data::HTML::Element::Input', ".
				"'Data::HTML::Element::Textarea' or 'Data::HTML::Element::Select' instance.";
		}

		if ($field->isa('Data::HTML::Element::Input')) {
			my $tags_input = Tags::HTML::Element::Input->new(%common);
			$tags_input->init($field);
			push @{$self->{'_tags_fields'}}, $tags_input;
		} elsif ($field->isa('Data::HTML::Element::Select')) {
			my $tags_select = Tags::HTML::Element::Select->new(%common);
			$tags_select->init($field);
			push @{$self->{'_tags_fields'}}, $tags_select;
		} elsif ($field->isa('Data::HTML::Element::Textarea')) {
			my $tags_textarea = Tags::HTML::Element::Textarea->new(%common);
			$tags_textarea->init($field);
			push @{$self->{'_tags_fields'}}, $tags_textarea;
		}
	}

	if ($self->{'submit'}->isa('Data::HTML::Element::Input')) {
		$self->{'_tags_submit_field'} = Tags::HTML::Element::Input->new(%common);
	} else {
		$self->{'_tags_submit_field'} = Tags::HTML::Element::Button->new(%common);
	}
	$self->{'_tags_submit_field'}->init($self->{'submit'});

	$self->{'_fields'} = \@fields;

	return;
}

# Process 'Tags'.
sub _process {
	my $self = shift;

	if (! exists $self->{'_fields'}) {
		return;
	}

	$self->{'tags'}->put(
		['b', 'form'],
		defined $self->{'form'}->css_class ? (
			['a', 'class', $self->{'form'}->css_class],
		) : (),
		defined $self->{'form'}->action ? (
			['a', 'action', $self->{'form'}->action],
		) : (),
		['a', 'method', $self->{'form'}->method],

		defined $self->{'form'}->{'label'} ? (
			['b', 'fieldset'],
			['b', 'legend'],
			['d', $self->{'form'}->{'label'}],
			['e', 'legend'],
		) : (),
	);

	if (@{$self->{'_fields'}}) {
		$self->{'tags'}->put(
			['b', 'p'],
		);
	}

	my $i = 0;
	foreach my $field (@{$self->{'_fields'}}) {
		$self->{'tags'}->put(
			defined $field->label ? (
				['b', 'label'],
				$field->id ? (
					['a', 'for', $field->id],
				) : (),
				['d', $field->label],
				$field->required ? (
					['b', 'span'],
					['a', 'class', $self->{'form'}->css_class.'-required'],
					['d', '*'],
					['e', 'span'],
				) : (),
				['e', 'label'],
			) : (),
		);
		$self->{'_tags_fields'}->[$i]->process;
		$i++;
	}

	if (@{$self->{'_fields'}}) {
		$self->{'tags'}->put(
			['e', 'p'],
		);
	}

	$self->{'tags'}->put(
		['b', 'p'],
	);
	$self->{'_tags_submit_field'}->process;
	$self->{'tags'}->put(
		['e', 'p'],

		defined $self->{'form'}->{'label'} ? (
			['e', 'fieldset'],
		) : (),
		['e', 'form'],
	);

	return;
}

sub _process_css {
	my $self = shift;

	$self->{'css'}->put(
		['s', '.'.$self->{'form'}->css_class],
		['d', 'border-radius', '5px'],
		['d', 'background-color', $self->{'background_color'}],
		['d', 'padding', '20px'],
		['e'],

		['s', '.'.$self->{'form'}->css_class.' fieldset'],
		['d', 'padding', '20px'],
		['d', 'border-radius', '15px'],
		['e'],

		['s', '.'.$self->{'form'}->css_class.' legend'],
		['d', 'padding-left', '10px'],
		['d', 'padding-right', '10px'],
		['e'],

		['s', '.'.$self->{'form'}->css_class.'-required'],
		['d', 'color', 'red'],
		['e'],
	);

	# TODO Different objects and different CSS?
	my $type_hr;
	foreach my $tags_field (@{$self->{'_tags_fields'}},
		@{$self->{'_tags_submit_fields'}}) {

		if (! exists $type_hr->{ref $tags_field}) {
			$type_hr->{ref $tags_field} = 1;
			$tags_field->process_css;
		}
	}
	$self->{'_tags_submit_field'}->process_css;

	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tags::HTML::Element::Form - Tags helper for HTML form element.

=head1 SYNOPSIS

 use Tags::HTML::Element::Form;

 my $obj = Tags::HTML::Element::Form->new(%params);
 $obj->cleanup;
 $obj->init(@fields);
 $obj->process;
 $obj->process_css;

=head1 METHODS

=head2 C<new>

 my $obj = Tags::HTML::Element::Form->new(%params);

Constructor.

=over 8

=item * C<background_color>

Form background color.

Default value is '#f2f2f2'.

=item * C<css>

'L<CSS::Struct::Output>' object for L</process_css> processing.

Default value is undef.

=item * C<button>

L<Tags::HTML::Element::Button> instance to process button.

Default value is L<Tags::HTML::Element::Button> object with 'tags' and 'css' parameter
inherited with main object.

=item * C<form>

Data object for form.

Could be a 'L<Data::HTML::Element::Form>' instance.

Default value is instance with 'form' css class.

=item * C<input>

L<Tags::HTML::Element::Input> instance to process inputs.

Default value is L<Tags::HTML::Element::Input> object with 'tags' and 'css' parameter
inherited with main object.

=item * C<select>

L<Tags::HTML::Element::Select> instance to process select elements.

Default value is L<Tags::HTML::Element::Select> object with 'tags' and 'css' parameter
inherited with main object.

=item * C<submit>

Data object for submit.

Could be a 'L<Data::HTML::Element::Form::Input>' or 'L<Data::HTML::Element::Button>' instance.

Default value is instance with 'Save' submit value.

=item * C<tags>

'L<Tags::Output>' object for L</process> processing.

Default value is undef.

=item * C<textarea>

L<Tags::HTML::Element::Textarea> instance to process textarea elements.

Default value is L<Tags::HTML::Element::Textarea> object with 'tags' and 'css' parameter
inherited with main object.

=back

=head2 C<init>

 $obj->init(@fields);

Initialize L<Tags> structure for fields defined in C<@fields>.

Accepted items in C<@fields> are objects:

=over

=item * L<Data::HTML::Element::Input>

=item * L<Data::HTML::Element::Select>

=item * L<Data::HTML::Element::Textarea>

=back

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
         Parameter 'button' must be a 'Tags::HTML::Element::Button' instance.
         Parameter 'form' is required.
         Parameter 'form' must be a 'Data::HTML::Element::Form' instance.
         Parameter 'form' must define 'css_class' parameter.
         Parameter 'input' must be a 'Tags::HTML::Element::Input' instance.
         Parameter 'select' must be a 'Tags::HTML::Element::Select' instance.
         Parameter 'submit' instance has bad type.
         Parameter 'submit' is required.
         Parameter 'submit' must be a 'Data::HTML::Element::Input' instance.
         Parameter 'textarea' must be a 'Tags::HTML::Element::Textarea' instance.

 process():
         From Tags::HTML::process():
                 Parameter 'tags' isn't defined.
         Form item must be a 'Data::HTML::Element::Input' instance.

 process_css():
         From Tags::HTML::process_css():
                 Parameter 'css' isn't defined.

=head1 EXAMPLE

=for comment filename=default_form.pl

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

=head1 DEPENDENCIES

L<Class::Utils>,
L<Data::HTML::Element::Button>,
L<Data::HTML::Element::Form>,
L<Error::Pure>,
L<List::Util>,
L<Scalar::Util>,
L<Tags::HTML>,
L<Tags::HTML::Element::Input>,
L<Tags::HTML::Element::Select>.

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
