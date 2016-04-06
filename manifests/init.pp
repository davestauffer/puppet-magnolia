# Class: magnolia
# ===========================
#
# This class will install either the Magnolia Community Edition or Enterprise Pro edition bundle
# which includes the demo travel project and embedded Apache Tomcat using the Puppet::Archive
# module to download the bundle zip file.  Puppet::Staging is currently included in case Archive
# does not work.
#
# Parameters
# ----------
#
# $edition is either magnolia 'community' or 'enterprise-pro'
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
class magnolia (


  # Magnolia Install Parameters
  $license_type          = $magnolia::params::license_type,
  $edition               = $magnolia::params::edition,
  $magnolia_version      = $magnolia::params::version,
  $user                  = $magnolia::params::user,
  $group                 = $magnolia::params::group,
  $install_dir           = $magnolia::params::install_dir,

  # Download Settings
  $magnolia_download_url = $magnolia::params::magnolia_download_url,

  # Persistence Settings

  # Manage service
  $service_manage        = $magnolia::params::service_manage,
  $service_ensure        = $magnolia::params::service_ensure,
  $service_enable        = $magnolia::params::service_enable,
  $service_notify        = $magnolia::params::service_notify,
  $service_subscribe     = $magnolia::params::service_subscribe,


) inherits magnolia::params {

  include java
  include limits
  include archive

  anchor { 'magnolia::start': } ->
    class { '::magnolia::config': } ->
    class { '::magnolia::install': } ->
  anchor { 'magnolia::end': }

}
