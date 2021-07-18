shared-salt-states
==================

A spot to place common Salt state files (and their associated pillars).

For now, all salt states expect the OS to be CentOS. If it becomes appropriate
to expand this to other OSs, grains should be used to switch on the current OS.

Instructions
------------

* These Salt states require a minimum version of ``v3001``.

* States will typically be kept in lock-step with the latest appropriate
  version of Salt, as and when Salt versions are released (and our code is
  updated accordingly).  You can find versions with compatibility for older
  versions of Salt in the Git history.

* Clone this repo into your ``salt/roots/salt`` folder::

      git submodule add https://github.com/jcu-eresearch/shared-salt-states.git salt/roots/salt/jcu

* You may wish to configure your submodule to point to the SSH push URL for
  the repository.

Using "standalone"
------------------

It is possible to use any of the given shared Salt states in a *standalone*
manner on a given machine you're using.  The repo located at
https://github.com/jcu-eresearch/shared-salt-states-standalone features a
minimalistic Salt configuration and how to quickly get started.

Testing
-------

To test the operation of the shared Salt states, do the following::

    docker-compose run centos-8 bash
    cd /app/.setup/
    ./highstate.sh

Modify the ``top.sls`` file and add the states you wish to test. You may need
to add additional dummy configuration to the `pillar/base.sls` file to ensure
your salt-call execution succeeds; refer to the individual states themselves
for setup details.

Todo
----

* Change all absolute includes to relative once Salt 2015.8 gets released
  (see https://github.com/saltstack/salt/pull/25578)
* SSH configuration for port 8822 only, password auth off
* Support IP tables via state, stop multiple iptables entries being added into
  /etc/sysconfig/iptables
