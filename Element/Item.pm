package Tags::HTML::Element::Item;

use base qw(Tags::HTML);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;

Readonly::Hash our %MAPPING => (
	'Data::HTML::Element::A' => 'Tags::HTML::Element::A',
	'Data::HTML::Element::Button' => 'Tags::HTML::Element::Button',
	'Data::HTML::Element::Input' => 'Tags::HTML::Element::Input',
	'Data::HTML::Element::Option' => 'Tags::HTML::Element::Option',
	'Data::HTML::Element::Select' => 'Tags::HTML::Element::Select',
	'Data::HTML::Element::Textarea' => 'Tags::HTML::Element::Textarea',
);

our $VERSION = 0.03;

sub _cleanup {
	my $self = shift;

	delete $self->{'_items'};

	return;
}

sub _init {
	my ($self, @items) = @_;

	if (! @items) {
		return;
	}

	$self->{'_items'} = [];
	foreach my $item (@items) {
		my $ref = ref $item;
		if (exists $MAPPING{$ref}) {
			eval "require $MAPPING{$ref}";
			my $tags = $MAPPING{$ref}->new(
				'css' => $self->{'css'},
				'tags' => $self->{'tags'},
			);
			$tags->init($item);
			push @{$self->{'_items'}}, $tags;
		} else {
			err "Form item doesn't supported.";
		}
	}

	return;
}

# Process 'Tags'.
sub _process {
	my $self = shift;

	if (! exists $self->{'_items'}) {
		return;
	}

	foreach my $item (@{$self->{'_items'}}) {
		$item->process;
	}

	return;
}

sub _process_css {
	my $self = shift;

	if (! exists $self->{'_items'}) {
		return;
	}

	foreach my $item (@{$self->{'_items'}}) {
		$item->process_css;
	}

	return;
}

1;

__END__
