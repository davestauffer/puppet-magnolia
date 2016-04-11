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
# license_type = community or enterprise  
# edition = community, standard or pro
# mgnolia_version = ex. 5.4.5
# is_demo = include the travel demo, true or false
# bundle = empty, webapp or tomcat
# database = use database for persistence.  default is derby, also supports postgresql
# cms_dir = name of the directory mangolia should be installed to (rather than /magnolia-enterprise-5.4.3)
# has_data_dir = false by default.  Set to true if you want to configure repository outside of the war file
# data_dir = directory location of repository and other files if has_data_dir is true, unused if false
# user = user magnolia install path is owned by
# group = group magnolia install path is grouped by
# nexus_user = username for logging into magnolia nexus repository (configure on puppet master so we don't see this in code)
# nexus_password = password for logging into magnolia nexus repository (configure on puppet master so we don't see this in code)
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
#      nexus_user     => 'yourname'
#      nexus_password => 'yourpassword'
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
  $license_type          = 'enterprise',
  $edition               = 'pro',
  $magnolia_version      = '5.4.3',
  $is_demo               = true,
  $bundle                = 'tomcat',
  $database              = 'postgresql',
  $cms_dir               = '/opt/magnolia-cms',
  $has_data_dir          = true,
  $data_dir              = '/opt/magnolia-data',
  $user                  = 'root',
  $group                 = 'root',
  $nexus_user            = undef,
  $nexus_password        = undef,

  # Tomcat Settings
  $tomcat_bin            = "$magnolia::params::cms_dir/apache-tomcat-7.0.64/bin",
  
  # Manage service
  $service_file_location = '/etc/init.d/magnolia'
  $service_file_template = 'magnolia/magnolia.service.erb'
  $service_manage        = true,
  $service_ensure        = running,
  $service_enable        = true,
  $service_notify        = undef,
  $service_subscribe     = undef,

) inherits magnolia::params {

  # Validate parameters
  validate_re($license_type, ['^enterprise','^community'], 'The Magnolia $license_type parameter must be "enterprise" or "community".')
  validate_re($edition, ['^community','^standard','^pro'], 'The Magnolia $edition parameter must be "community", "standard" or "pro".')
  validate_re($database, ['^derby','^postgresql'], 'The Magnolia $database parameter must be "derby" or "postgresql".')

  include java
  include limits
  include archive

  anchor { 'magnolia::start': } ->
    class { '::magnolia::config': } ->
    class { '::magnolia::install': } ->
    class { '::magnolia::service': } ->
  anchor { 'magnolia::end': }

}
