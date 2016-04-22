# Class: magnolia
# ===========================
#
# This class will install either the Magnolia Community Edition or Enterprise
# Pro edition bundle which includes the demo travel project and embedded Apache
# Tomcat using the Puppet::Archive module to download the bundle zip file.
# Puppet::Staging is currently included in case Archive does not work.
#
# Parameters
# ----------
#
# nexus_user: required, username for logging into magnolia nexus repository
#   (configure on puppet master so we don't see this in code).
# nexus_password: required, password for logging into magnolia nexus repository
#   (configure on puppet master so we don't see this in code).
# license_type: optional, set to community or enterprise (default).
# edition: optional, set to community, standard or pro (default).
# magnolia_version: optional set to a valid version availble in nexus ex. 5.4.3.
# is_demo: optional, includes the travel demo, true (default) or false.
# bundle: optional, what type of bundle do you want to download empty, webapp or
#   tomcat (default).
# database: optional, database for persistence. Derby (default) or postgresql.
# cms_dir: optional, name of the directory mangolia should be installed to 
#   (rather than /magnolia-enterprise-5.4.3).
# has_data_dir: optional, false by default.  Set to true if you want to
#   configure the magnolia repository outside of the war file.
# data_dir: optional, directory location of repository and other files if
#   has_data_dir is true, unused if false,
# magnolia_user: optional, user magnolia install path is owned by.
# magnolia_group: optional, group magnolia install path is grouped by.
# deploy_user: optional, user you deploy application updates with
#   (such as a jenkins user), related to has_data_dir.
# deploy_group: optional, group you deploy application updates with (such as a
#   jenkins group), relatedto has_data_dir.
# tomcat_bin: optional, bin directory where the magnolia_control.sh is located.
# tomcat_timezone: optional, sets a java timezone in setenv.sh
#    ex. 'America/New_York'.
# tomcat_max_heap: optional, sets max heap -Xmx in setenv.sh ex. '1536M'.
# tomcat_min_heap: optional, sets min heap -Xms in setenv.sh ex. '1024M'.
# tomcat_max_perm: optional, sets -XX:MaxPermSize in setenv.sh ex. '256m'.
# tomcat_context_env: optional, sets a parameter in the tomcat context.xml file
# used to configure magnolia based on the environment  ex. 'production'.
# service_manage: optional, set to false by default.  if set to true, you should
#   configure the service file location and template.
# service_file_location: optional, location for service script, default
#   set for ubuntu to /etc/init.d/magnolia.
# service_file_template: optional, location of the puppet erb file.
#
# Variables 
# ---------- 
# demo: set to '-demo' in download url if you want the demo included.
# magnolia_file_name: builds the name of the file you download from magnolia 
#   based on license_type, edition, demo, version & bundle format 
# magnolia_download_url: builds the download url based on the
#   magnolia_file_name, edition, demo, version and license type
# tomcat_service_dir: combines the cms_dir and tomcat_bin to create a location
#  for the service to call the magnolia_control.sh script
#
# Examples
# --------
#
# Installs version 5.4.3 of the magnolia enterprise pro bundled with tomcat and
# the travel demo into a generic directory called /opt/magnolia-cms.  The
# repository is stored inside the tomcat webapps directory and Magnolia will run
# as root. A service will be created and set to running.
#
# @example    
#   class { 'magnolia':
#     nexus_user     => 'yourname'
#     nexus_password => 'yourpassword'
#   }
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
  $nexus_user,
  $nexus_password,
  $license_type          = 'enterprise',
  $edition               = 'pro',
  $magnolia_version      = '5.4.3',
  $is_demo               = true,
  $bundle                = 'tomcat',
  $database              = 'derby',
  $cms_dir               = '/opt/magnolia-cms',
  $has_data_dir          = false,
  $data_dir              = undef,
  $magnolia_user         = 'root',
  $magnolia_group        = 'root',
  $deploy_user           = undef,
  $deploy_group          = undef,

  # Tomcat Settings
  $tomcat_bin            = '/apache-tomcat-7.0.64/bin',
  $tomcat_conf           = '/apache-tomcat-7.0.64/conf',
  $tomcat_timezone       = 'America/New_York',
  $tomcat_max_heap       = '1536M',
  $tomcat_min_heap       = '1024M',
  $tomcat_max_perm       = '256m',
  $tomcat_context_env    = 'production',

  # Database Settings
  $author_db_name        = undef,
  $public_db_name        = undef,
  
  # Manage service
  $service_file_location = '/etc/init.d/magnolia',
  $service_file_template = 'magnolia/magnolia.service.erb',
  $service_manage        = true,
  $service_ensure        = running,
  $service_enable        = true,
  $service_notify        = undef,
  $service_subscribe     = undef,

) inherits magnolia::params {

  include java
  include limits
  include archive

  # Validate parameters
  validate_re($license_type, ['^enterprise','^community'], 'The Magnolia $license_type parameter must be "enterprise" or "community".')
  validate_re($edition, ['^community','^standard','^pro'], 'The Magnolia $edition parameter must be "community", "standard" or "pro".')
  validate_re($database, ['^derby','^postgresql'], 'The Magnolia $database parameter must be "derby" or "postgresql".')
  validate_re($bundle, ['^tomcat','^webapp','^empty'], 'The Magnolia $bundle parameter must be "tomcat", "webapp" or "empty".')
  validate_bool($is_demo, 'The is_demo parameter must be either true or false')
  validate_bool($has_data_dir, 'The has_data_dir parameter must be either true or false')
  validate_absolute_path($cms_dir, 'The cms_dir parameter should be an absolute path')
  validate_absolute_path($data_dir, ' The data_dir should be an absolute path')
  validate_absolute_path($service_file_location, 'The service_file_location should be an absolute path')

  # set demo in file name
  if $magnolia::is_demo == true {
    $demo = '-demo'
  }

  # Magnolia Download URL
  case $license_type {
    'enterprise': {
      case $bundle {
        'tomcat': {
          $magnolia_filename     = "magnolia-enterprise-${edition}${demo}-bundle-${magnolia_version}-tomcat-bundle.${magnolia::params::bundle_format}"
          $magnolia_download_url = "https://nexus.magnolia-cms.com/content/repositories/magnolia.enterprise.releases/info/magnolia/eebundle/magnolia-enterprise-${edition}${demo}-bundle/${magnolia_version}/${magnolia_filename}"
        }
        'webapp':{
          $magnolia_filename     = "magnolia-enterprise-${edition}${demo}-webapp-${magnolia_version}.war"
          $magnolia_download_url = "https://nexus.magnolia-cms.com/content/repositories/magnolia.enterprise.releases/info/magnolia/eebundle/magnolia-enterprise-${edition}${demo}-webapp/${magnolia_version}/${magnolia_filename}"
        }
        default: {
          fail("Magnolia bundle must be either tomcat or webapp, you entered: ${bundle}")
        }
      }
    }
    'community':{
      case $magnolia::bundle {
        'tomcat': {
          $magnolia_filename     = "magnolia-community-demo-bundle-${magnolia_version}-tomcat-bundle.${magnolia::params::bundle_format}"
          $magnolia_download_url = "https://nexus.magnolia-cms.com/content/repositories/magnolia.public.releases/info/magnolia/bundle/magnolia-community-demo-bundle/${magnolia_version}/${magnolia_filename}"
        }
        'webapp':{
          $magnolia_filename     = "magnolia-community${demo}-webapp-${magnolia_version}.war"
          $magnolia_download_url = "https://nexus.magnolia-cms.com/content/repositories/magnolia.public.releases/info/magnolia/bundle/magnolia-community${demo}-webapp/${magnolia_version}/${magnolia_filename}"
        }
        'empty':{
          $magnolia_filename     = "magnolia-empty-webapp-${magnolia_version}.war"
          $magnolia_download_url = "https://nexus.magnolia-cms.com/content/repositories/magnolia.public.releases/info/magnolia/magnolia-empty-webapp/${magnolia_version}/magnolia-empty-webapp-${magnolia_version}.war"
        }
        default: {
          fail("Magnolia bundle must be either tomcat, webapp or empty, you entered: ${bundle}")
        }
      }
      
    }
    default: {
      fail ("license_type must be either community or enterprise you entered: ${license_type}")
    }
  }

  # Set Tomcat bin directory for service
  $tomcat_service_dir            = "${cms_dir}${tomcat_bin}"

  anchor { 'magnolia::start': } ->
    class { '::magnolia::config': } ->
    class { '::magnolia::install': } ->
    class { '::magnolia::service': } ->
  anchor { 'magnolia::end': }

}
