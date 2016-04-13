# Class: magnolia:::config
# ===========================
#
# Configures Magnolia CMS.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Authors
# -------
#
# Dave Stauffer <davetst@gmail.com>
#
# Copyright
# ---------
#
# Copyright 2016 Dave Stauffer, unless otherwise noted.
#
class magnolia::config inherits magnolia {

  limits::fragment {
    "root/soft/nofile":
    value => "10000";
    "root/hard/nofile":
    value => "50000";
  }

  file { $magnolia::cms_dir:
    ensure => directory,
    owner  => $magnolia::magnolia_user,
    group  => $magnolia::magnolia_group,
    mode   => '0755',
  }

  if $magnolia::has_data_dir == true {
    file { $magnolia::data_dir:
      ensure => directory,
      owner  => $magnolia::magnolia_user,
      group  => $magnolia::magnolia_group,
      mode   => '0755',
    }

    file { "${magnolia::data_dir}/builds":
      ensure  => directory,
      require => File[$magnaolia::data_dir],
      owner   => $magnolia::deploy_user,
      group   => $magnolia::deploy_group,
      mode    => '0755',
    }

    file { "${magnolia::data_dir}/backups":
      ensure  => directory,
      require => File[$magnolia::data_dir],
      owner   => $magnolia::magnolia_user,
      group   => $magnolia::magnolia_group,
      mode    => '0755',
    }
  }

  case $magnolia::database {
    'postgresql': {
      postgresql::server::database { 'magnolia_author': }
      postgresql::server::database { 'magnolia_public': }
    }
    default: {
      fail("Magnolia database must be either postgresql or derby, you entered: ${magnolia::database}")
    }
  }
}
