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


	# Magnolia Settings
	$edition             = 'enterprise-pro',
	$version             = '5.4.5',
	$format              = 'zip',
	$user                = 'root',
	$group               = 'root',

	# Download Settings
	$download_site          = 'https://nexus.magnolia-cms.com/content/repositories',

	# Choose whether to use puppet-staging, or puppet-archive
	$deploy_module = 'archive',

	# Database Settings

	# Postgresql Settings

	# Manage service
	$service_manage = true,
	$service_ensure = running,
	$service_enable = true,
	$service_notify = undef,
	$service_subscribe = undef,


)
{

	include java
	include limits
	include apt
	include archive

	case $::operatingsystem {
    'Ubuntu': {
      package { 'unzip':
    	ensure => installed,
      }
    }
    default: {
      fail("Unsupported operatingsystem: ${::operatingsystem}")
     }
  }

    

	anchor { 'magnolia::start': } ->
	class { '::magnolia::install': } ->
	anchor { 'magnolia::end': }

}
