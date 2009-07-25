use 5.010_000;
use strict;
use warnings;
use utf8;

use File::Slurp;
use FindBin;
use Parse::AccessLogEntry;
use YAML::Syck;

my $setting = LoadFile($FindBin::RealBin . '/../etc/settings.yml');

my $except_agents = '(?:'
                  . ( join '|', @{ $setting->{except_agents} } )
                  . ')';
my $except_agents_pattern = qr{$except_agents};
my $parser = Parse::AccessLogEntry->new;
my $lines  = read_file(
    $FindBin::RealBin . '/../log/' . $setting->{local_file},
    array_ref => 1,
);

LINE:
foreach my $line (@$lines) {
    chomp $line;
    next LINE
        unless $line;

    my $column = $parser->parse($line);
    next LINE
        if $column->{agent} =~ $except_agents_pattern
        || $column->{host} eq $setting->{my_host};

    delete @{$column}{qw(bytes date diffgmt proto user)};
    print Dump $column;
}
