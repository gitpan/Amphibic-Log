package Amphibic::Log;
BEGIN {
  $Amphibic::Log::VERSION = '0.01';
}

# ABSTRACT: Because logging should be fun

use Moose;

use Amphibic::Log::Entry;

has 'name' => (
  is       => 'ro',
  isa      => 'Str',
  required => 1,
);

my %levels = (
  fatal => 1,
  error => 2,
  warn  => 3,
  info  => 4,
  debug => 5,
  trace => 6,
);

my $log_level = $levels{ $ENV{ LOG_LEVEL } || '' } || 0;
  
unless ($log_level > 0) {
  foreach my $level (keys %levels) {
    if ($ENV{ 'LOG_' . uc ($level) }) {
      $log_level = $levels{ $level } if $levels{ $level } > $log_level;
    }
  }
}
  
foreach my $level (qw/trace debug info warn error fatal/) {
  if ($levels{ $level } <= $log_level) {
    __PACKAGE__->meta->add_method ($level,sub {
        my ($self,$message) = @_;

        my %args = (
          facility   => $self->name,
          level      => $level,
          message    => $message,
        );
        
        return $self->_dispatch (Amphibic::Log::Entry->new (\%args))
      });
      
    __PACKAGE__->meta->add_method ("is_$level",sub { 1 });
  } else {
    __PACKAGE__->meta->add_method ($level,sub {});
    
    __PACKAGE__->meta->add_method ("is_$level",sub { 0 });
  }
}

sub _dispatch {
  my ($self,$entry) = @_;

  print STDERR $entry->as_string . "\n";  
  
  return;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 NAME

Amphibic::Log - Because logging should be fun

=head1 VERSION

version 0.01

=head1 SYNOPSIS

  # In webapp.pl
  
  my $logger = Amphibic::Log->new (name => "webapp");
  
  $logger->info ("Authentication failure");
  
  # In a shell far, far away
  
  $ export LOG_TRACE=1
  $ perl webapp.pl

=head1 DESCRIPTION

Logging should be a simple thing that everyone do. Yet, few modules if
any actually do logging. And many that actually do logging has
invented their own logging scheme. The problem isn't dependencies on
other modules, but the fact that most logging modules get some
fundamental assumptions about where they will be used wrong. This is my
attempt at making logging easy and not something to be avoided, even
when faced with real world situations like time constraints and lack
of planning.

=head1 LOG LEVELS

This module is hardcoded with six fairly standard logging levels, namely
"fatal", "error", "warn", "info", "debug", and "trace". This module
behaves so that enabling a given level in the list above also enables
every level before it. Ie, if you enable "trace", you also enable every
single other level.

=head1 DESTINATIONS

At the moment, only logging to STDERR is supported. Yes, this is going
to change, I just want to focus on getting other things right first
before adding support for more destinations.

=head1 ENABLING LOGGING

To enable logging of all messages:

  export LOG_TRACE=1

Or if you are not using bash, use the equivalent command for setting an
environment variable in your shell. To enable a given level, set the
environment variable LOG_E<lt>levelE<gt> to a true value.

=head1 ATTRIBUTES

=head2 name

Identify the component name the log messages are coming from. This
should be a simple identifier; If the logging entity was L<DBIx::Class>
then the identifier should probably be something like "dbic".

=head1 METHODS

=head2 is_E<lt>levelE<gt>

  # $log->is_debug;
  
Returns a true value if the current logging level is at least at this
level. The purpose of these methods is usually so the programmer can
avoid running things like expensive debugging routines if it isn't
necessary.

=head2 E<lt>levelE<gt>

  # $log->debug ($message);

Sends $message to the underlying transports.

=head1 SEE ALSO

=over 4

=item L<Log::Contextual>

=back

=head1 BUGS

Most software has bugs. This module probably isn't an exception. 
If you find a bug please either email me, or add the bug to cpan-RT.

=head1 AUTHOR

  Anders Nor Berle <berle@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Anders Nor Berle.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut