#!/bin/bash

# Function to check if a command exists
command_exists() {
	command -v "$1" &>/dev/null
}

# Check if the script is running on a Red Hat-based system
if command_exists dnf; then
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
	if ! command_exists ansible-playbook; then
		echo "Installing Ansible..."
		sudo dnf install --assumeyes ansible
	else
		echo "Ansible already installed"
	fi
else
	# Check if the script is running on an Ubuntu-based system
	if command_exists apt; then
		# Install software-properties-common to get add-apt-repository
		if ! dpkg -l | grep -q "software-properties-common"; then
			# Update package list
			echo "Updating package list..."
			sudo apt update
			echo "Installing software-properties-common..."
			sudo apt install -y software-properties-common
		else
			echo "software-properties-common is already installed"
		fi

		# Enable universe repository
		if ! grep -q "^deb .*\buniverse\b" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
			echo "Enabling universe repository..."
			sudo add-apt-repository universe
			sudo apt update
		else
			echo "Universe repository is already enabled."
		fi

		# Install Ansible
		if ! command_exists ansible-playbook; then
			echo "Installing Ansible..."
			sudo apt install -y ansible
		else
			echo "Ansible already installed"
		fi
	else
		echo "Unsupported package manager. This script only supports dnf and apt."
		exit 1
	fi
fi

# Run Ansible playbook
echo "Running Ansible playbook..."
ansible-playbook -i inventory/hosts.yaml roles/site.yaml --ask-become-pass
