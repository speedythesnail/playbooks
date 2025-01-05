# Ansible Playbooks

Welcome to my Ansible Playbooks repository!

This repository contains various playbooks to automate your IT tasks.

## Getting Started

To quickly download, extract, and run the playbooks, you can use the following one-time setup command.

### One-time Setup

Copy and paste the following command into your terminal to automatically download the repository as a zip file to a temporary directory, extract it, and run the `playbook.sh` script:

```sh
tmp_dir=$(mktemp -d) && \
curl -L https://github.com/speedythesnail/playbooks/archive/refs/heads/main.zip -o "${tmp_dir}/playbooks.zip" && \
unzip "${tmp_dir}/playbooks.zip" -d "${tmp_dir}" && \
bash "${tmp_dir}/playbooks-main/playbook.sh"

```
