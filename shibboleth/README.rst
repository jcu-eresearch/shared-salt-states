About this state
================

.. note::

   This state can be refactored into a Salt formula if interest in
   co-developing the code exists.  Get in touch if this is something you're
   interested in!

This state does a number of things for automating Shibboleth deployment:

* Configures the Shibboleth package repository
* Installs Shibboleth SP
* Ensures Shibboleth service is installed, running, and starts at boot
* Installs customised configuration for Shibboleth (shibboleth2.xml and
  attribute-map.xml) based on the Salt pillar config you provide.
* Downloads the specified federation's certificates
* Installs the missing Shibboleth logo
* Installs a SP certificate and key, if configured; or else generates a pair
  for you.
* Configures Shibboleth to work with multiple federations, if so desired,
  including AAF for Australia and Tuakiri for New Zealand.

To-do
-----

* Flexible attribute-map configuration. Currently this provides a fixed
  default matching core AAF attributes.
* Move this state out to be a Salt formula.


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
     providers:
       - aaf
       - aaf-test
       - tuakiri
       - tuakiri-test
     user: shibd [optional]
     group: shibd [optional]
     certificate: ... [a precomputed full certificate; optional]
     key: ... [a precomputed full key; optional]

and these should be placed into your pillar data. For a worked example, see
https://github.com/espaces/espaces-deployment/blob/master/salt/roots/pillar/base.sls#L40
.

Providers are the top-level identifiers specified in the ``providers.yaml``
file located in this directory.  This currently supports AAF and Tuakiri and
their test federations.  If ``providers`` is not specified, AAF production
will be configured.
