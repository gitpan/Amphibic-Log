package # Hide from PAUSE
  Amphibic::Log::Entry;

use Moose;

has 'facility' => (
  is       => 'ro',
  isa      => 'Str',
  required => 1,
);

has 'level' => (
  is       => 'ro',
  isa      => 'Str',
  required => 1,
);

has 'message' => (
  is       => 'ro',
  isa      => 'Str',
  required => 1,
);

sub as_string {
  my ($self) = @_;
  
  my $string = '['
    . $self->level
    . '] '
    . $self->message;

  return $string;
}

__PACKAGE__->meta->meta_immutable;

1;
