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

This Puppet module installs and configures Magnolia CMS as well as creates services to manage the applications state.

## Setup

### What magnolia affects

* Supports installation and configuration on Ubuntu 14.04
* Installs Oracle Java 8 using webupd8team apt repository
* Sets limits.conf for higher open files handles on 
* Installs Magnolia CMS bundle with an embedded Tomcat server
* Configures Magnolia CMS
* Configures the embedded Tomcat server

### Setup Requirements

* Requires Puppet v4.3.2

### Beginning with magnolia

You should download this module to your puppet master from the puppetforge using the puppet module command

## Usage

This section is where you describe how to customize, configure, and do the
fancy stuff with your module here. It's especially helpful if you include usage
examples and code samples for doing things with your module.

## Reference

Here, include a complete list of your module's classes, types, providers,
facts, along with the parameters for each. Users refer to this section (thus
the name "Reference") to find specific details; most users don't read it per
se.

## Limitations

This is where you list OS compatibility, version compatibility, etc. If there
are Known Issues, you might want to include them under their own heading here.

## Development

Since your module is awesome, other users will want to play with it. Let them
know what the ground rules for contributing are.

## Release Notes/Contributors/Etc. **Optional**

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You can also add any additional sections you feel
are necessary or important to include here. Please use the `## ` header.
