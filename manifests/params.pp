# Class: magnolia:::params
# ===========================
#
# Parameters for Magnolia CMS.
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
  $license_type          = 'enterprise'
  $edition               = 'pro'
  $magnolia_version      = '5.4.3'
  $is_demo               = true
  $bundle                = 'tomcat'
  $database              = 'postgresql'
  $cms_dir               = '/opt/magnolia-cms'
  $has_data_dir          = true
  $data_dir              = '/opt/magnolia-data'

  $service_file_location = '/etc/init.d/magnolia'
  $service_file_template = 'magnolia/magnolia.service.erb'

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
