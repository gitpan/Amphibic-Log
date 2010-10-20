use Test::More;

use strict;
use warnings;

plan tests => 3;

use_ok ("Amphibic::Log::Entry");

my $entry = Amphibic::Log::Entry->new (
  facility => "test",
  level    => "debug",
  message  => "test message",
);

isa_ok ($entry,"Amphibic::Log::Entry");

is ($entry->as_string,"[test debug] test message","as_string");
