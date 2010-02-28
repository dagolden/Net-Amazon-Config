# Copyright (c) 2010 by David Golden. All rights reserved.
# Licensed under Apache License, Version 2.0 (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License was distributed with this file or you may obtain a 
# copy of the License from http://www.apache.org/licenses/LICENSE-2.0

package Net::Amazon::Config::Profile;
use strict;
use warnings;
use Params::Validate ();

our $VERSION = '0.001';
$VERSION = eval $VERSION; ## no critic

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
  my ($class, $first, @rest) = @_;
  my @args = ref $first eq 'ARRAY' ? (@$first) : ($first,@rest);
  my %args = Params::Validate::validate(@args, { map { $_ => 0 } @attributes });
  return bless \%args, $class;
}

1;

__END__

=begin wikidoc

= NAME

Net::Amazon::Config::Profile - Amazon credentials for given profile

= VERSION

This documentation describes version %%VERSION%%.

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

= BUGS

Please report any bugs or feature requests using the CPAN Request Tracker  
web interface at [http://rt.cpan.org/Dist/Display.html?Queue=Net-Amazon-Config]

When submitting a bug or request, please include a test-file or a patch to an
existing test-file that illustrates the bug or desired feature.

= SEE ALSO

* [Net::Amazon::Config]

= AUTHOR

David A. Golden (DAGOLDEN)

= COPYRIGHT AND LICENSE

Copyright (c) 2010 by David A. Golden. All rights reserved.

Licensed under Apache License, Version 2.0 (the "License").
You may not use this file except in compliance with the License.
A copy of the License was distributed with this file or you may obtain a 
copy of the License from http://www.apache.org/licenses/LICENSE-2.0

Files produced as output though the use of this software, shall not be
considered Derivative Works, but shall be considered the original work of the
Licensor.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=end wikidoc

=cut

