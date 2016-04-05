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

  case $::operatingsystem {
      'Ubuntu': {
        include apt

        class{'java':
          repository            => 'webupd8team',
          distribution          => 'oracle',
          release               => 'java8',
          accept_oracle_license => true,
        }
        
        package { 'unzip':
          ensure => installed,
        }

       }
      default: {
        fail("Unsupported operatingsystem: ${::operatingsystem}")
       }
    } 

  file { $install_dir:
    ensure => directory,
    owner  => $magnolia::user,
    group  => $magnolia::group,
    mode   => '0755',
  }

}
