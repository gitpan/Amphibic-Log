package Amphibic::Log::Transport::STDERR;

use Moose;

with qw/
  Amphibic::Log::Transport
  /;

sub dispatch {
  my ($self,$entry) = @_;
  
  print STDERR $entry->as_string . "\n";
  
  return;
}

__PACKAGE__->meta->make_immutable;

1;
