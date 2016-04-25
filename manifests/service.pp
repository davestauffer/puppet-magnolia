# Class: magnolia::service
# ===========================
#
# Service for managing Magnolia CMS.
#
# Parameters
# ----------
#
# Variables
# ----------
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
# Copyright 2016 Your name here, unless otherwise noted.
#
class magnolia::service (

  $service_file_location  = $magnolia::service_file_location,
  $service_file_template  = $magnolia::service_file_template,

) inherits magnolia {

  validate_bool($magnolia::service_manage)

  file { $service_file_location:
    content => template($service_file_template),
    mode    => '0755',
  }

  if $magnolia::service_manage {

    validate_string($magnolia::service_ensure)
    validate_bool($magnolia::service_enable)

    service { 'magnolia':
      ensure    => $magnolia::service_ensure,
      enable    => $magnolia::service_enable,
      require   => File[$service_file_location],
      notify    => $magnolia::service_notify,
      subscribe => $magnolia::service_subscribe,
    }
  }
}
