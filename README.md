# Container Image - Ubuntu22 Ansible Test

Ubuntu 22.04 container image for testing Ansible roles, playbooks and
collections.

The main idea is to use it in combination with
[Molecule](https://github.com/ansible-community/molecule).

[![Build & Publish](https://github.com/projectpotos/container-ubuntu22-ansible-test/actions/workflows/build-publish.yml/badge.svg)](https://github.com/projectpotos/container-ubuntu22-ansible-test/actions/workflows/build-publish.yml)

## Customizations

The following customizations are added on top of the Ubuntu22 base image:

* Setup systemd, its volumes and execute it at start
* Setup python for Ansible

## Usage

Run the container as follows:

```sh
podman run \
  --tty \
  --privileged \
  --volume /sys/fs/cgroup:/sys/fs/cgroup:ro \
  ghcr.io/projectpotos/ubuntu22-ansible-test
```

All available tags can be found in the
[registry](https://github.com/projectpotos/container-ubuntu22-ansible-test/pkgs/container/ubuntu22-ansible-test).
The `latest` tag is updated on a weekly basis each Friday.

## License

See [LICENSE](./LICENSE)
