#!/bin/bash

# to build geodjango-base-v1.0.box
vagrant up
rm -f geodjango-base-v1.0.box
vagrant package --output geodjango-base-v1.0.box

# to install locally:
# vagrant box add geodjango-base-v1.0 geodjango-base-v1.0.box
