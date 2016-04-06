# Class: magnolia:::params
# ===========================
#
# Parameters for Magnolia CMS.
#
# Parameters
# ----------
#
# Document parameters here.
#
# license_type = community or enterprise  
# edition = community, standard or pro
# mgnolia_version = ex. 5.4.5
# demo = -demo or undef (make sure to include the '-' before demo)
# bundle = empty, webapp or tomcat
# bundle_format = zip or tar.gz (only for bundled tomcat)
# user = user magnolia install path is owned by
# group = group magnolia install path is grouped by
# install_dir = root directory where magnolia is to be installed
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
class magnolia::params {

  # Magnolia Install Parameters
  $license_type        = 'enterprise',
  $edition             = 'pro',
  $magnolia_version    = '5.4.3',
  $demo                = undef,
  $bundle              = 'tomcat',
  $bundle_format       = 'tar.gz',
  $user                = 'root',
  $group               = 'root',
  $install_dir         = '/opt',

  # Magnolia Download URL
  case $license_type {
    'enterprise': {
      case $bundle {
        'tomcat': {
          magnolia_filename     = "magnolia-enterprise-${edition}${demo}-bundle-${magnolia_version}-tomcat-bundle.${bundle_format}"
          magnolia_download_url = "https://nexus.magnolia-cms.com/content/repositories/magnolia.enterprise.releases/info/magnolia/eebundle/magnolia-enterprise-${edition}${demo}-bundle/${magnolia_version}/${magnolia_filename}"
        }
        'webapp':{
          magnolia_filename     = "magnolia-enterprise-${edition}${demo}-webapp-${magnolia_version}.war"
          magnolia_download_url = "https://nexus.magnolia-cms.com/content/repositories/magnolia.enterprise.releases/info/magnolia/eebundle/magnolia-enterprise-${edition}${demo}-webapp/${magnolia_version}/${magnolia_filename}"
        }
        default: {
          fail("Magnolia bundle must be either tomcat or webapp, you entered: ${bundle}")
        }
      }
    }
    'community':{
      case $bundle {
        'tomcat': {
          magnolia_filename     = "magnolia-community-demo-bundle-${magnolia_version}-tomcat-bundle.${bundle_format}"
          magnolia_download_url = "https://nexus.magnolia-cms.com/content/repositories/magnolia.public.releases/info/magnolia/bundle/magnolia-community-demo-bundle/${magnolia_version}/${magnolia_filename}"
        }
        'webapp':{
          magnolia_filename     = "magnolia-community${demo}-webapp-${magnolia_version}.war"
          magnolia_download_url = "https://nexus.magnolia-cms.com/content/repositories/magnolia.public.releases/info/magnolia/bundle/magnolia-community${demo}-webapp/${magnolia_version}/${magnolia_filename}"
        }
        'empty':{
          magnolia_filename     = "magnolia-empty-webapp-${magnolia_version}.war"
          magnolia_download_url = "https://nexus.magnolia-cms.com/content/repositories/magnolia.public.releases/info/magnolia/magnolia-empty-webapp/${magnolia_version}/magnolia-empty-webapp-${magnolia_version}.war"
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

  # Persistence Settings

  # Manage Magnolia Service
  #$service_manage      = true,
  #$service_ensure      = running,
  #$service_enable      = true,
  #$service_notify      = undef,
  #$service_subscribe   = undef

}
