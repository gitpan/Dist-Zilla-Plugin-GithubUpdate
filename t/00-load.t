#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Dist::Zilla::Plugin::GithubUpdate' ) || print "Bail out!
";

}

diag( "Testing Dist::Zilla::Plugin::GithubUpdate $Dist::Zilla::Plugin::GithubUpdate::VERSION, Perl $], $^X" );
