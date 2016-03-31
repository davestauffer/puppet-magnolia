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
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
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
  $edition             = 'enterprise-pro',
  $version             = '5.4.5',
  $format              = 'zip',
  $user                = 'root',
  $group               = 'root',
  $install_path        = "/opt/magnolia-enterprise-${magnolia::version}"

  # Download Settings
  $download_site       = 'https://nexus.magnolia-cms.com/content/repositories',

  # Persistence Settings

  # Manage service
  $service_manage      = true,
  $service_ensure      = running,
  $service_enable      = true,
  $service_notify      = undef,
  $service_subscribe   = undef,

}
