shared-salt-states
==================

A spot to place common salt state files (and their associated pillars).

For now, all salt states expect the OS to be CentOS. If it becomes appropriate
to expand this to other OSs, grains should be used to switch on the current OS.


Instructions
------------

* These Salt states require a minimum version of ``v2015.2.0rc1``.

* States will typically be kept in lock-step with the latest appropriate
  version of Salt, as and when Salt versions are released (and our code is
  updated accordingly).

* Clone this repo into your ``salt/roots/salt`` folder::

      git submodule add https://github.com/jcu-eresearch/shared-salt-states.git salt/roots/salt/jcu

* You may wish to configure your submodule to point to the SSH push URL for the
  repository.

Using "standalone"
------------------

It is possible to use any of the given shared Salt states in a 'stand 
alone' manner on a given machine you're using.  The repo
located at https://github.com/jcu-eresearch/shared-salt-states-standalone
features a minimalistic Salt configuration and how to quickly get started. 


Todo
----

* Change all absolute includes to relative once Salt 2015.8 gets released
  (see https://github.com/saltstack/salt/pull/25578)
* SSH configuration for port 8822 only, password auth off
* Upgrade to support RHEL 7
* Support IP tables via state, stop multiple iptables entries being added into
  /etc/sysconfig/iptables
