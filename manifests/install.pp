# Class: magnolia:::install
# ===========================
#
# Uses Puppet::Archive to install one of two Magnolia CMS bundles with the travel demo and
# Apache Tomcat included.
#
# Parameters
# ----------
#
# 
# Variables
# ----------
#
# 
#
# Examples
# --------
#
# @example
#    class { 'magnolia':
#      
#    }
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
class magnolia::install inherits magnolia {
	include '::archive'

	$server_package = "magnolia-${magnolia::edition}-demo-bundle-${magnolia::version-tomcat-bundle.${magnolia::format}",

	case $magnolia::deploy_module {
    'staging': {
      require staging
      staging::file { $server_package:
        source  => "${magnolia::download_url}/${server_package}",
        timeout => 1800,
      } ->
      staging::extract { $server_package:
        target  => $magnolia::installdir,
        strip   => 1,
        user    => $magnolia::user,
        group   => $magnolia::group,
        notify  => Exec["chown_${jira::installdir}"],
        require => [
          File[$magnolia::installdir],
          User[$magnolia::user],
          File[$magnolia::installdir] ],
      }
    }
    'archive': {
      archive { "/tmp/${server_package}":
        ensure          => present,
        extract         => true,
        extract_command => 'uzip',
        extract_path    => $magnolia::installdir,
        source          => "${magnolia::download_url}/${server_package}",
        cleanup         => true,
        user            => $magnolia::user,
        group           => $magnolia::group,
        require         => [
          File[$magnolia::installdir],
          User[$magnolia::user],
        ],
      }
    }
    default: {
      fail('deploy_module parameter must equal "archive" or staging""')
    }
  }
 }
