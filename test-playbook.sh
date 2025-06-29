#!/usr/bin/env bash

ansible-playbook -i inventory/hosts.yaml roles/site.yaml --ask-become-pass --check
