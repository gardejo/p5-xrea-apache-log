use 5.010_000;
use strict;
use warnings;
use utf8;

use FindBin;
use DateTime;
use Net::FTP;
use YAML::Syck;

my $setting = LoadFile($FindBin::RealBin . '/../etc/settings.yml');
my $today   = DateTime->today;

my $ftp = Net::FTP->new($setting->{domain});
$ftp->login($setting->{username}, $setting->{password})
    or die 'Cannot login ', $ftp->message;
$ftp->cwd($setting->{log_directory})
    or die 'Cannot change working directory ', $ftp->message;
$ftp->get(
    $setting->{domain} . '.' . $today->ymd('-') . '.log'
        => $FindBin::RealBin . '/../log/' .$setting->{local_file}
) or die 'get failed ', $ftp->message;

1;
