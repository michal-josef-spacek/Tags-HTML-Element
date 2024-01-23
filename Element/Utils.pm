package Tags::HTML::Element::Utils;

use base qw(Exporter);
use strict;
use warnings;

use Readonly;

Readonly::Array our @EXPORT_OK => qw(tags_boolean tags_data tags_value);

our $VERSION = 0.03;

sub tags_boolean {
	my ($self, $element, $method) = @_;

	if ($element->$method) {
		return (['a', $method, $method]);
	}

	return ();
}

sub tags_data {
	my ($self, $object) = @_;

	# Plain content.
	if ($object->data_type eq 'plain') {
		$self->{'tags'}->put(
			map { (['d', $_]) } @{$object->data},
		);

	# Tags content.
	} elsif ($object->data_type eq 'tags') {
		$self->{'tags'}->put(@{$object->data});

	# Callback.
	} else {
		foreach my $cb (@{$object->data}) {
			$cb->($self);
		}
	}

	return;
}

sub tags_value {
	my ($self, $element, $method, $method_rewrite) = @_;

	if (defined $element->$method) {
		return ([
			'a',
			defined $method_rewrite ? $method_rewrite : $method,
			$element->$method,
		]);
	}

	return ();
}

1;

__END__
