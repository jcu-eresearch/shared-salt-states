shared-salt-states
==================

A spot to place common salt state files (and their associated pillars)

For now, all salt states expect the OS to be CentOS. If it becomes appropriate
to expand this to other OSs, grains should be used to switch on the current OS.

Instructions
-------------

These instructions are fairly limited for now.

1. clone this repo into your salt/roots/salt folder as jcu. e.g:

		git submodule add git@github.com:jcu-eresearch/shared-salt-states.git salt/roots/salt/jcu
