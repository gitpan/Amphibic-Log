package # Hide from PAUSE
  Amphibic::Log::Entry;
BEGIN {
  $Amphibic::Log::Entry::VERSION = '0.01';
}

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
    . $self->facility
    . ' '
    . $self->level
    . '] '
    . $self->message;

  return $string;
}

__PACKAGE__->meta->make_immutable;

1;
