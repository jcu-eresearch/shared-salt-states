shared-salt-states
==================

A spot to place common salt state files (and their associated pillars).

For now, all salt states expect the OS to be CentOS. If it becomes appropriate
to expand this to other OSs, grains should be used to switch on the current OS.


Instructions
------------

These instructions are fairly limited for now.

* Clone this repo into your ``salt/roots/salt`` folder::

      git submodule add https://github.com/jcu-eresearch/shared-salt-states.git salt/roots/salt/jcu

* You may wish to configure your submodule to point to the SSH push URL for the
  repository.


Todo
----

* Configure yum priorities for any custom packages being installed (Shibboleth,
  Nginx,  Supervisor) At present, installation isn't explicitly pinned to
  install from our repositories.
* Custom repository configuration prevents installation via Salt for our custom
  packages of Shibboleth, Nginx and Supervisor. These need to be manually
  installed until we can update to Salt 2014.1.0 (which is also borked for
  iptables configuration).
