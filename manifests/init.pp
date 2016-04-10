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
# edition is either magnolia 'community' or 'enterprise-pro'
# install_dir = root directory where magnolia is to be installed
# user = user magnolia install path is owned by
# group = group magnolia install path is grouped by
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
  $magnolia_download_url = $magnolia::params::magnolia_download_url,
  $is_demo               = $magnolia::params::is_demo,
  $demo                  = $magnolia::params::demo,
  $bundle                = $magnolia::params::bundle,
  $cms_dir               = $magnolia::params::cms_dir,
  $has_data_dir          = $magnolia::params::has_data_dir,
  $data_dir              = $magnolia::params::data_dir,
  $user                  = 'root',
  $group                 = 'root',
  

  # Persistence Settings

  # Manage service
  $service_manage        = true,
  $service_ensure        = running,
  $service_enable        = true,
  $service_notify        = undef,
  $service_subscribe     = undef,

) inherits magnolia::params {

  include java
  include limits
  include archive

  anchor { 'magnolia::start': } ->
    class { '::magnolia::config': } ->
    class { '::magnolia::install': } ->
    class { '::magnolia::service': } ->
  anchor { 'magnolia::end': }

}
