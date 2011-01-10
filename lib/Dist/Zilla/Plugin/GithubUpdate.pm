package Dist::Zilla::Plugin::GithubUpdate;
BEGIN {
  $Dist::Zilla::Plugin::GithubUpdate::VERSION = '0.02';
}

use Moose;
use LWP::UserAgent;

use warnings;
use strict;

with 'Dist::Zilla::Role::Releaser';

has login => (
	is      => 'ro',
	isa     => 'Str',
);

has token => (
	is   	=> 'ro',
	isa  	=> 'Str',
);

has cpan => (
	is   	=> 'ro',
	isa  	=> 'Bool',
	default => 1
);

=head1 NAME

Dist::Zilla::Plugin::GithubUpdate - Update GitHub repo info on release

=head1 VERSION

version 0.02

=head1 SYNOPSIS

In your F<dist.ini>:

    [GithubUpdate]
    login  = LoginName
    token  = GitHubToken
    cpan = 1

=head1 DESCRIPTION

This Dist::Zilla plugin updates the information of the GitHub repository
when C<dzil release> is run.

=cut

sub release {
	my $self 	= shift;
	my ($opts) 	= @_;
	my $base_url	= 'https://github.com/api/v2/json';
	my $repo_name 	= $self -> zilla -> name;
	my ($login, $token);

	if ($self -> login) {
		$login = $self -> login;
	} else {
		$login = `git config github.user`;
	}

	if ($self -> token) {
		$token = $self -> token;
	} else {
		$token = `git config github.token`;
	}

	chomp $login; chomp $token;

	$self -> log("Updating GitHub repository info");

	if (!$login || !$token) {
		$self -> log("Err: Provide valid GitHub login values");
		return;
	}

	my $browser = LWP::UserAgent -> new;

	my %params = (
		'login'			=> $login,
		'token'			=> $token,
		'values[description]'	=> $self -> zilla -> abstract,
	);

	if ($self -> cpan == 1) {
		$params{'values[homepage]'} = "http://search.cpan.org/dist/$repo_name/";
	}


	my $url 	= "$base_url/repos/show/$login/$repo_name";
	my $response 	= $browser -> post($url, [%params]) -> as_string;
	my $status  	= (split / /,(split /\n/, $response)[0])[1];

	if ($status == 401) {
		$self -> log("Err: Not authorized");
	}
}

=head1 ATTRIBUTES

=over

=item C<login>

The GitHub login name. If not provided, will be used the value of
C<github.user> from the Git configuration, to set it, type:

    $ git config --global github.user LoginName

=item C<token>

The GitHub API token for the user. If not provided, will be used the
value of C<github.token> from the Git configuration, to set it, type:

    $ git config --global github.token GitHubToken

=item C<cpan>

If set to '1' (default), the GitHub homepage field will be set to the
CPAN page of the module.

=back

=head1 AUTHOR

Alessandro Ghedini <alexbio@cpan.org>

=head1 BUGS

Please report any bugs or feature requests at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Dist-Zilla-Plugin-GithubUpdate>.
I will be notified, and then you'll automatically be notified of progress
on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Dist::Zilla::Plugin::GithubUpdate

You can also look for information at:

=over 4

=item * GitHub page

L<http://github.com/AlexBio/Dist-Zilla-Plugin-GithubUpdate>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Dist-Zilla-Plugin-GithubUpdate>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Dist-Zilla-Plugin-GithubUpdate>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Dist-Zilla-Plugin-GithubUpdate>

=item * Search CPAN

L<http://search.cpan.org/dist/Dist-Zilla-Plugin-GithubUpdate/>

=back

=head1 SEE ALSO


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Alessandro Ghedini.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of Dist::Zilla::Plugin::GithubUpdate