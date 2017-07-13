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
file located in this directory (accessible at
`https://github.com/jcu-eresearch/shared-salt-states/blob/master/shibboleth/providers.yaml`_).
This currently supports AAF and Tuakiri and their test federations.  If
``providers`` is not specified, AAF production will be configured as the sole
provider.

If ``certificate`` and ``key`` are omitted from the Pillar, the Salt state
will automatically create one for you within ``/etc/shibboleth/sp-cert.pem``
and ``/etc/shibboleth/sp-key.pem`` respectively.  The state will not
regenerate a certificate and key if they already exist but similarly, if
either of these files is missing, they will be recreated.  In short, this is a
safe for deployment to production as files will not be overwritten, but
provides flexibility to keep a consistent copy on the Salt master for use in
development to avoid regeneration (and thus Service Provider (SP)
re-registration with your federation registry).

Federation registry settings
----------------------------

When using this set of Salt states with one federation, the default SP
configuration given to you by your federation registry should be sufficient to
see your service configured correctly.

In the case of use with multiple federations, you'll need to modify your SP's
settings in the given federation registry accordingly.  Specifically, the only
setting that will need to be modified or added to is your SAML Discovery
Endpoints.  For each federation, these Salt states will create a discovery URL
like so::

    https://example.org/Shibboleth.sso/ds-aaf-test

or, more generally::

    https://example.org/Shibboleth.sso/ds-[provider-id]

where ``[provider-id]`` is the identifier of the provider from
``providers.yaml`` that you specified in your pillar, as mentioned above.  One
URL will be available for each federation.  You can test these URLs by loading
them in your browser -- you'll be directed to the given federation to log in.
In the case of AAF of Tuakiri, you'll be presented with a Where Are You From
(WAYF) page to select an institution.
