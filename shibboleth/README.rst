About this state
================

This state does a number of things for automating Shibboleth deployment:

* Configures the Shibboleth package repository
* Installs Shibboleth SP
* Ensures Shibboleth service is installed, running, and starts at boot
* Installs standardised configuration for Shibboleth (shibboleth2.xml and
  attribute-map.xml).
* Downloads the AAF federation metadata
* Installs the missing Shibboleth logo
* Installs a SP certificate and key, if configured; or else generates a pair
  for you.

To-do
-----

* Flexible attribute-map configuration. Currently this provides a fixed
  default matching core AAF attributes.


Usage
-----

To use this state, include it in another of yours, or else call it
manually.

::

   include:
      - jcu.shibboleth


If you're taking a walk on the wild side and want to integrate Shibboleth
with your Nginx instance, you use use the ``.fastcgi`` state to configure
a full Nginx instance with FastCGI authorizer support, install the
Shibboleth FastCGI version, configure authorizer and responder applications
and wire it all together.  Use this instead of the include above::

   include:
      - jcu.shibboleth.fastcgi


Configuration
-------------

The state uses sensible defaults such that you need only a little pillar
configuration to make things happen.  Configuration options are like this::

shibboleth:
   host: sp.example.org
   entityID: https://sp.example.org/shibboleth
   user: shibd [optional]
   group: shibd [optional]
   certificate: ... [a precomputed full certificate; optional]
   key: ... [a precomputed full key; optional]

and these should be placed into your pillar data. For a worked example, see
https://github.com/espaces/espaces-deployment/blob/master/salt/roots/pillar/base.sls#L40
.


