
use strict;
use warnings;



use ExtUtils::MakeMaker 6.31;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'Update GitHub repo info on release',
  'AUTHOR' => 'Alessandro Ghedini <alexbio@cpan.org>',
  'BUILD_REQUIRES' => {
    'Test::More' => '0'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.31'
  },
  'DISTNAME' => 'Dist-Zilla-Plugin-GithubUpdate',
  'EXE_FILES' => [],
  'LICENSE' => 'perl',
  'NAME' => 'Dist::Zilla::Plugin::GithubUpdate',
  'PREREQ_PM' => {
    'Dist::Zilla::Role::Releaser' => '0',
    'LWP::UserAgent' => '0',
    'Moose' => '0'
  },
  'VERSION' => '0.03',
  'test' => {
    'TESTS' => 't/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



