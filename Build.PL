# Copyright (c) 2010 by David Golden. All rights reserved.
# Licensed under Apache License, Version 2.0 (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License was distributed with this file or you may obtain a 
# copy of the License from http://www.apache.org/licenses/LICENSE-2.0

use strict;
use lib 'inc';
eval "require Pod::WikiDoc";
my $class = $@ ? "Module::Build" : "Module::Build::WikiDoc";
eval "require $class";
my $build = $class->new( 
    module_name => 'Net::Amazon::Config',
    dist_author => 'David Golden <dagolden@cpan.org>',
    license => 'apache',
    create_readme => 1,
    create_makefile_pl  => 'traditional',
    requires => {
        'perl' => 0, # not specified
        'Carp' => 0,
        'Config::Tiny' => 2.12,
        'constant' => 1, # 1.00 in perl 5.00504; 1.02 in perl 5.006002; 1.17 in perl 5.008009; 1.18 is new
        'Object::Tiny' => 1.06,
        'Params::Validate' => 0.91,
        'Path::Class' => 0.17,
    },
    build_requires => {
        'File::Find' => 0,
        'File::Spec' => 3.31,
        'Test::More' => 0.88,
    },
    meta_add            => { 
        no_index => { 
            directory => [ qw/ examples inc t xt /],
        },
        resources => {
          repository => "http://github.com/dagolden/Net-Amazon-Config/", 
          bugtracker => "http://rt.cpan.org/NoAuth/Bugs.html?Dist=Net-Amazon-Config",
        },
    },
);
$build->create_build_script;

