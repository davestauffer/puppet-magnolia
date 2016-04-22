# Class: magnolia:::config
# ===========================
#
# Configures Magnolia CMS.
#
# Parameters
# ----------
#
# Variables
# ----------
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

    file { "${magnolia::data_dir}/backups":
      ensure  => directory,
      require => File[$magnolia::data_dir],
      owner   => $magnolia::magnolia_user,
      group   => $magnolia::magnolia_group,
      mode    => '0755',
    }

    if $magnolia::deploy_user == undef {
      file { "${magnolia::data_dir}/builds":
        ensure  => directory,
        require => File[$magnaolia::data_dir],
        owner   => $magnolia::magnolia_user,
        group   => $magnolia::magnolia_group,
        mode    => '0755',
      }
    } else {
      file { "${magnolia::data_dir}/builds":
        ensure  => directory,
        require => [
          File[$magnolia::data_dir],
          User[$magnolia::deploy_user],
        ],
        owner   => $magnolia::deploy_user,
        group   => $magnolia::deploy_group,
        mode    => '0755',
      }
      user { $magnolia::deploy_user:
        ensure  => present,
        comment => 'magnolia deploy user',
        home    => "/home/${magnolia::deploy_user}",
        shell   => '/bin/bash',
      }
    }

    
  }

  case $magnolia::database {
    'postgresql': {
      if $magnolia::magnolia_author != undef {
        postgresql::server::database { $magnolia::magnolia_author: }
      }
      if $magnolia::magnolia_public != undef {
        postgresql::server::database { $magnolia::magnolia_public: }
      }
    }
    default: {
      fail("Magnolia database must be either postgresql or derby, you entered: ${magnolia::database}")
    }
  }
}
