use Test::More;

use strict;
use warnings;

plan tests => 8;

for (qw/FATAL ERROR INFO WARN DEBUG TRACE/) {
  $ENV{ "LOG_$_" } = 0;
}

$ENV{ "LOG_FATAL" } = 1;

use_ok ("Amphibic::Log");

my $log = Amphibic::Log->new (name => "test");

isa_ok ($log,"Amphibic::Log");

ok ($log->is_fatal,"is_fatal is true");

for (qw/error info warn debug trace/) {
  my $method = "is_$_";
  
  ok (! $log->$method,"is_$_ is false");
}
