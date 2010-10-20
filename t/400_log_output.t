use Test::More;
use Test::Output;

use strict;
use warnings;

plan tests => 3;

for (qw/FATAL ERROR INFO WARN DEBUG TRACE/) {
  $ENV{ "LOG_$_" } = 0;
}

$ENV{ "LOG_TRACE" } = 1;

use_ok ("Amphibic::Log");

my $log = Amphibic::Log->new (name => "test");

isa_ok ($log,"Amphibic::Log");

stderr_is (sub { $log->debug ("42") },"[test debug] 42\n","Prints to STDERR");
