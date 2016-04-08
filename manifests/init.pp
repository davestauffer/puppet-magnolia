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
# magnolia.properties
# magnolia.home = Root of the webapp's deployment directory.  Optional, default is ${magnolia.app.rootdir}
# magnolia.repositories.config = Location of repository config file.  Required, default is WEB-INF/config/default/repositories.xml
# magnolia.repositories.home = Repository home directory.  Optional, default is ${magnolia.home}/repositories
# magnolia.repositories.jackrabbit.config = Location of Jackrabbit file.  Optional, default is WEB-INF/config/repo-conf/jackrabbit-bundle-derby-search.xml
# magnolia.logs.dir = Directory where logs are written.  Optional, default is ${magnolia.home}/logs
# magnolia.cache.startdir = Directory used for cached pages.  Required, default is ${magnolia.home}/cache
# magnolia.upload.tmpdir = Temporary directory for uploaded files.  Required, default is ${magnolia.home}/tmp
# magnolia.logs.dir = Directory where logs are written.  Optional, default is ${magnolia.home}/logs
# magnolia.utf8.enabled = Activate UTF-8 support for pages.  Optional, default is false
# magnolia.develop = Disables the cache for resources.  To force on-the-fly Sass compiling.  Optional, default is false
# magnolia.update.auto = Set to true if bootstrapping and update should be performed automatically after installation.  Optional, default is false
# magnolia.author.key.location = Location of private and public keys used for activation.  Optional, default is ${magnolia.home}/WEB-INF/config/default/magnolia-activation-keypair.properties
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
  $demo                  = $magnolia::params::demo,
  $bundle                = $magnolia::params::bundle,
  $user                  = 'root',
  $group                 = 'root',
  $install_dir           = '/opt',

  # Magnolia Properies
  $magnolia_home                            = '\${magnolia.app.rootdir}',
  $magnolia_resources_dir                   = '\${magnolia.home}',
  $magnolia_repositories_config             = 'WEB-INF/config/default/repositories.xml',
  $magnolia_repositories_home               = '\${magnolia.home}/repositories',
  $magnolia_repositories_jackrabbit_config  = 'WEB-INF/config/repo-conf/jackrabbit-bundle-derby-search.xml',
  $magnolia_logs_dir                        = '\${magnolia.home}/logs',
  $magnolia_cache_startdir                  = '\${magnolia.home}/cache',
  $magnolia_upload_tmpdir                   = '\${magnolia.home}/tmp',
  $magnolia_utf8_enabled                    = false,
  $magnolia_develop                         = $magnolia::params::magnolia_develop,
  $magnolia_update_auto                     = $magnolia::params::magnolia_update_auto,
  $magnolia_author_key_location             = '\${magnolia.home}/WEB-INF/config/default/magnolia-activation-keypair.properties',
  

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
