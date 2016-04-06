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
    
      archive { $::magnolia_filename:
        path         => "/tmp/${magnolia::magnolia_filename}",
        source       => $magnolia::magnolia_download_url,
        extract      => true,
        extract_path => $magnolia::install_dir,
        creates      => "${magnolia::install_dir}/LICENSE.txt",
        cleanup      => true,
        user         => $magnolia::user,
        group        => $magnolia::group,
        username     => 'your user name here',
        password     => 'your password here',
        require      => File[$magnolia::install_dir],
      }
}