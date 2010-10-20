use Amphibic::Log;

use strict;
use warnings;

package Foo;

my $log = Amphibic::Log->new (log_caller => 1);

$log->debug ("hello world");

