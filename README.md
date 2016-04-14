# magnolia

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with magnolia](#setup)
    * [What magnolia affects](#what-magnolia-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with magnolia](#beginning-with-magnolia)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This Puppet module downloads and installs Magnolia CMS as well as creates a service to manage the applications state.

## Setup

### What magnolia affects

* Downloads Magnolia CMS from their nexus repository
* Supports installation on Ubuntu 14.04
* Supports Community and Enterprise downloads, with or without the Travel Demo App and embedded Tomcat
* Installs Oracle Java 8 using webupd8team apt repository
* Sets limits.conf for higher open files handles on Ubuntu
* Optionally allows you to install PostgreSQL for persistence
* Optionally allows you to create a repository directory outside of the war file, including a directory for backups and software builds

### Setup Requirements

* Requires Puppet v4.3.2

### Beginning with magnolia

You should download this module to your puppet master from the puppetforge using the puppet module command.  If you would like to use PostgreSQL for 
persistence you should download the puppet-postgresql module also.

## Usage

Default Install:

The default install will give you Magolia version 5.4.3 Enterprise Pro bundled with Tomcat and the Travel Demo.
It will install into a generic directory called /opt/magnolia-cms.  The Magnolia repository will stored inside the Tomcat 'webapps'
directory and Magnolia will run as the root user. A service will be created and set to running.  The only parameters you need to configure 
are your credentials to login to the Magnolia Nexux repository.

class { 'magnolia':
      nexus_user     => 'yourname'
      nexus_password => 'yourpassword'      
}

PostgreSQL and External Repo dir:

A more complex example showing you different download options and setup options.  This will download the Magnolia Enterprise Standard version 5.4.5.  It will not include the Travel Demo application but does include the bundled Tomcat server.  It will create PostgreSQL databases called magnolia_public and magnolia_author owned by the postgres user.  It will also create a directory in /opt/magnolia-data where your respository can be stored as well as creating a backups and builds directory.  The builds directory will be owned and grouped by the 'jenkins' user because you automate your deployments.

class { 'magnolia':
      license_type      => 'enterprise'
      edition           => 'standard'
      magnolia_version  => '5.4.5'
      is_demo           => false
      bundle            => 'tomcat'
      database          => 'postgresql'
      cms_dir           => '/opt/magnolia'
      has_data_dir      => true
      data_dir          => '/opt/magnolia-data'
      nexus_user        => 'yourname'
      nexus_password    => 'yourpassword'
      deploy_user       => 'jenkins'
      deploy_group      => 'jenkins'      
}



## Reference



## Limitations

This module is currently limited to installing Magnolia from their Nexus repository on Ubuntu 14.04.  
It may work on other platforms but hasn't been tested.
It does not 'configure' Magnolia (such as the magnolia.properties file).  You should 
probably be building your magnolia war file with any customized magnolia.properties and 
jackrabbit configuration built-in and then deploying it.  The data dir is configuration is simply 
a convenience.  This module also defaults to creating two databases named magnolia_public
and magnolia_author for postgresql.  You can obviously customize this module to change 
the database names or only create one or the other (features coming soon!).  It also 
assumes for future development sake that you would use 'zip' on Windows and a native 
decompression tool like 'gunzip' on unix.  Therefore all non-windows systems assume a 
download file format of 'tar.gz'.

## Development



## Release Notes/Contributors/Etc. **Optional**


