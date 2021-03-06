package TestConfig;
use Moose;
use File::Spec;
extends 'Config::GitLike';

has 'tmpdir' => (
    is => 'rw',
    required => 1,
    isa => 'Str',
);

# override these methods so:
# (1) test cases don't need to chdir into the tmp directory in order to work correctly
# (2) we don't try loading configs from the user's home directory or the system
# /etc during tests, which could (a) cause tests to break and (b) change things on
# the user's system during tests
# (3) files in the test directory are not hidden (for easier debugging)

sub dir_file {
    my $self = shift;
    my $dirs = (File::Spec->splitpath( $self->tmpdir, 1 ))[1];
    return File::Spec->catfile($dirs, $self->confname);
}

sub user_file {
    my $self = shift;

    return File::Spec->catfile(
        ( File::Spec->splitpath( $self->tmpdir, 1 ) )[1],
        'home', $self->confname );
}

sub global_file {
    my $self = shift;

    return File::Spec->catfile(
        ( File::Spec->splitpath( $self->tmpdir, 1 ) )[1],
        'etc', $self->confname );
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

