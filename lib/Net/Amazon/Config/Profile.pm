use strict;
use warnings;

package Net::Amazon::Config::Profile;
# ABSTRACT: Amazon credentials for given profile
# VERSION

use Params::Validate ();

my @attributes;

BEGIN {
    @attributes = qw(
      profile_name
      access_key_id
      secret_access_key
      certificate_file
      private_key_file
      ec2_keypair_name
      ec2_keypair_file
      cf_keypair_id
      cf_private_key_file
      aws_account_id
      canonical_user_id
    );
}

use Object::Tiny @attributes;

sub new {
    my ( $class, $first, @rest ) = @_;
    my @args = ref $first eq 'ARRAY' ? (@$first) : ( $first, @rest );
    my %args = Params::Validate::validate( @args, { map { $_ => 0 } @attributes } );
    return bless \%args, $class;
}

1;

__END__

=begin wikidoc

= DESCRIPTION

This module defines a simple object representing a 'profile' of
Amazon Web Services credentials and associated information.

= USAGE

A profile object is created by [Net::Amazon::Config] based on information
in a configuration file.  The object has the following read-only accessors:

* profile_name -- as provided in the configuration file
* access_key_id -- identifier for REST requests
* secret_access_key -- used to sign REST requests
* certificate_file -- path to a file containing identifier for SOAP requests
* private_key_file -- path to a file containing the key used to sign SOAP requests
* ec2_keypair_name -- the name used to identify a keypair when launching an EC2 instance
* ec2_keypair_file -- the private key file used by ssh to connect to an EC2 instance
* cf_keypair_id -- identifier for CloudFront requests
* cf_private_key_file -- path to a file containing the key use to sign CloudFront requests
* aws_account_id -- identifier to share resources (except S3) 
* canonical_user_id -- identifier to share resources (S3 only)

If an attribute is not set in the configuration file, the accessor will
return undef.

= SEE ALSO

* [Net::Amazon::Config]

=end wikidoc

=cut

