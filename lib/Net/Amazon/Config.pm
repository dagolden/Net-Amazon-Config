use strict;
use warnings;

package Net::Amazon::Config;
# ABSTRACT: Manage Amazon Web Services credentials
# VERSION

use Carp ();
use Config::Tiny 2.12 ();
use Net::Amazon::Config::Profile ();
use Params::Validate 0.91 ();
use Path::Class 0.17 ();
use Object::Tiny 1.06 qw(
  config_dir
  config_file
  config_path
);

use constant IS_WIN32 => $^O eq 'MSWin32';

sub _default_dir {
  my $base = Path::Class::dir(IS_WIN32 ? $ENV{USERPROFILE} : $ENV{HOME});
  return $base->subdir('.amazon')->absolute->stringify;
}

sub new {
  my $class = shift;
  my %args = Params::Validate::validate( @_, {
    config_dir => {
      default => $ENV{NET_AMAZON_CONFIG_DIR} || _default_dir,
    },
    config_file => {
      default => $ENV{NET_AMAZON_CONFIG} || 'profiles.conf',
    }
  });

  if ( Path::Class::file($args{config_file})->is_absolute ) {
    $args{config_path} = $args{config_file};
  }
  else {
    $args{config_path} = 
      Path::Class::dir($args{config_dir})->file($args{config_file});
  }
  
  unless ( -r $args{config_path} ) {
    die "Could not find readable file $args{config_path}";
  }

  return bless \%args, $class;
}

sub get_profile {
  my ($self, $profile_name) = @_; 
  my $config = Config::Tiny->read( $self->config_path );
  
  $profile_name = $config->{_}{default} unless defined $profile_name;
  my $params = $config->{$profile_name}
    or return;

  $params->{profile_name} = $profile_name;
  my $profile = eval { Net::Amazon::Config::Profile->new( $params ) };
  if ($@) {
    Carp::croak "Invalid profile: $@";
  }
  return $profile;
}

1;

__END__

=begin wikidoc

= SYNOPSIS

== Example

    use Net::Amazon::Config;
    
    # default location and profile
    my $profile = Net::Amazon::Config->new->get_profile;

    # use access key ID and secret access key with S3 
    use Net::Amazon::S3;
    my $s3 = Net::Amazon::S3->new(
      aws_access_key_id     => $profile->access_key_id,
      aws_secret_access_key => $profile->secret_access_key,
    );
    
== Config Format

  default = johndoe
  [johndoe]
  access_key_id = XXXXXXXXXXXXXXXXXXXX
  secret_access_key = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  certificate_file = my-cert.pem
  private_key_file = my-key.pem
  ec2_keypair_name = my-ec2-keypair
  ec2_keypair_file = ec2-private-key.pem
  aws_account_id = 0123-4567-8901
  canonical_user_id = <64-character string>
  
= DESCRIPTION

This module lets you keep Amazon Web Services credentials in a
configuration file for use with different tools that need them.

= USAGE

== new() 

  my $config = Net::Amazon::Config->new( %params );

Valid {%params} entries include:

* config_dir -- directory containing the config file
(and the default location for other files named in the config file).  
Defaults to {$HOME/.amazon}
* config_file -- defaults to {profiles.conf}

Returns an object or undef if no config file can be found.

== config_path()

  my $path = $config->config_path;

Returns the absolute path to the configuration file.

== get_profile()

  my $profile = $config->get_profile( $name );

If {$name} is omitted or undefined, returns the profile named in the
top-level key {default} in the config file. If the profile does not
exist, get profile returns undef or an empty list.

= ENVIRONMENT

* NET_AMAZON_CONFIG -- absolute path to config file or file name relative
to the configuration directory
* NET_AMAZON_CONFIG_DIR -- configuration directory 

= SEE ALSO

* About AWS Security Credentials: http://tinyurl.com/yh93cjg

=end wikidoc

=cut

