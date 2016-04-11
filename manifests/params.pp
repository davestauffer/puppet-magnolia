# Class: magnolia:::params
# ===========================
#
# Parameters for Magnolia CMS.
#
# Parameters
# ----------
#
# Variables
# ----------
# bundle_format - setting to zip or tar.gz based on OS
# demo - setting demo in file path/name
# magnolia_filename - setting up downloaded file name based on your parameters
# magnolia_download_url - building up download url based on your parameters 
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

  # set download file compression format
  if $::operatingsystem == 'windows' {
    $bundle_format = 'zip'
  }
  else {
    $bundle_format = 'tar.gz'
  }

  # set demo in file name
  if $is_demo == true {
    $demo = '-demo'
  }

  # Magnolia Download URL
  case $license_type {
    'enterprise': {
      case $bundle {
        'tomcat': {
          $magnolia_filename     = "magnolia-enterprise-${edition}${demo}-bundle-${magnolia_version}-tomcat-bundle.${bundle_format}"
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
      case $bundle {
        'tomcat': {
          $magnolia_filename     = "magnolia-community-demo-bundle-${magnolia_version}-tomcat-bundle.${bundle_format}"
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

}
