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

  

}
