#!/bin/bash

# Check if EPEL 9 is enabled and enable it if not
if ! dnf repolist enabled | grep -q "codeready-builder-for-rhel-9"; then
	echo "EPEL 9 repo is not enabled. Enabling it now."
	sudo subscription-manager repos --enable codeready-builder-for-rhel-9
else
	echo "EPEL 9 repo is already enabled."
fi

# Install dnf-plugins-core to get dnf config-manager
if ! dnf list installed dnf-plugins-core | grep -q "dnf-plugins-core"; then
	echo "Installing dnf-plugins-core..."
	sudo dnf install --assumeyes dnf-plugins-core
else
	echo "dnf-plugins-core is already installed"
fi

# Enable EPEL 9 repository
if ! dnf repolist enabled | grep -q "epel"; then
	echo "EPEL repository is not enabled. Enabling it now."
	sudo dnf config-manager --assumeyes --add-repo=https://dl.fedoraproject.org/pub/epel/9/Everything/x86_64
	sudo dnf config-manager --assumeyes --enable epel
else
	echo "EPEL repository is already enabled."
fi

# Install Ansible
if ! command -v ansible-playbook &>/dev/null; then
	echo "Installing Ansible..."
	sudo dnf install --assumeyes ansible
else
	echo "Ansible already installed"
fi
# Run Ansible playbook
echo "Running Ansible playbook..."
ansible-playbook -i inventory/hosts.yaml roles/site.yaml --ask-become-pass
