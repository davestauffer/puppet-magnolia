# Class: magnolia:::install
# ===========================
#
# Uses Puppet::Archive to install one of two Magnolia CMS bundles with the 
# travel demo and Apache Tomcat included.
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
    
      archive { $magnolia::magnolia_filename:
        path            => "/tmp/${magnolia::magnolia_filename}",
        source          => $magnolia::magnolia_download_url,
        extract         => true,
        extract_command => 'tar xfz %s --strip-components=1',
        extract_path    => $magnolia::cms_dir,
        creates         => "${magnolia::cms_dir}/LICENSE.txt",
        cleanup         => true,
        user            => $magnolia::magnolia_user,
        group           => $magnolia::magnolia_group,
        username        => $magnolia::nexus_user,
        password        => $magnolia::nexus_password,
        require         => File[$magnolia::cms_dir],
      }

      file { "${magnolia::cms_dir}/${magnolia::tomcat_bin}/setenv.sh":
          ensure  => file,
          content => template('magnolia/setenv.sh.erb'),
          require => Archive[$magnolia::magnolia_filename],
      }

      file { "${magnolia::cms_dir}/${magnolia::tomcat_conf}/context.xml":
          ensure  => file,
          content => template('magnolia/context.xml.erb'),
          require => Archive[$magnolia::magnolia_filename],
      }
}