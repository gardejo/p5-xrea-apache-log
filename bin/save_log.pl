use 5.010_000;
use strict;
use warnings;
use utf8;

use FindBin;
use WWW::Mechanize;
use YAML::Syck;

my $setting = LoadFile($FindBin::RealBin . '/../etc/settings.yml');

my $uri = 'http://www.' . $setting->{server} .'/jp/admin.cgi'
        . '?logsavenow=1'
        . '&domainname=' . $setting->{domain}
        . '&id='         . $setting->{username}
        . '&pass='       . $setting->{password};    # passwordに非ず
my $response = WWW::Mechanize->new->get($uri);
die
    if ! $response->is_success
    || $response->decoded_content !~ m{正常に送信されました};

1;
