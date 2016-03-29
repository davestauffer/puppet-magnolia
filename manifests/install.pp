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

    $filename = "magnolia-${magnolia::edition}-demo-bundle-${magnolia::version}-tomcat-bundle.${magnolia::format}"
    $download_path = "magnolia.enterprise.releases/info/magnolia/eebundle/magnolia-${edition}-demo-bundle/${version}"
    $install_path = "/opt/magnolia-enterprise-${magnolia::version}"


    file { $install_path:
       ensure => directory,
       owner  => $magnolia::user,
       group  => $magnolia::group,
       mode   => '0755',
    }

   case $magnolia::deploy_module {
    'archive': {
      archive { $filename:
        path            => "/tmp/${filename}",
        source          => "${magnolia::download_site}/$download_path/${filename}",
        extract         => true,
        extract_path    => '/opt',
        creates         => "${install_path}/LICENSE.txt",
        cleanup         => true,
        user            => $magnolia::user,
        group           => $magnolia::group,
        username        => 'ssalvatore',
        password        => 'ZLnb8iO4fr',
        require         => File[$install_path],
      }
    }
    default: {
      fail('deploy_module parameter must equal "archive" or staging""')
    }
  }
 }
       