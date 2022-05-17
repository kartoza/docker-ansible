# Ansible controller in docker

Run an Ansible controller in a docker container (should work on Windows).

Build image

```
docker build . -t ansible
```

Run container

```bash
docker run -dt -v $PWD/ansible:/ansible \
           -v ~/.ssh:/root/.ssh:ro \
           -e ANSIBLE_CONFIG=/ansible/ansible.cfg \
           --restart=unless-stopped \
           --name ansible ansible
```

```powershell
docker run -dt -v $PWD/ansible:/ansible `
           -v $env:USERPROFILE/.ssh:/root/win-ssh:ro `
           -e ANSIBLE_CONFIG=/ansible/ansible.cfg `
           --restart=unless-stopped `
           --name ansible ansible
```

Execute command

```
docker exec -it ansible <command>
```

## Notes

For the sake of simplicity, you could alias `docker exec -it ansible ansible` (with arguments) as `ansible` (and repeat for ansible-playbook/ ansible-doc) to run it within docker as if it was available on the local host.

You can also tail the logs in the background container with `docker logs --follow ansible`.

The `data` directory is basically for an expected root `/data` mount on the controller which can be used for syncing back data with commands (e.g. file backups, .kube/config files) and will be the expected setup used with [default playbook](https://github.com/zacharlie/playbooks) definitions and structures.

Remember to specify the `ansible_ssh_pass` value where appropriate (you should pw protect your private keys). Some examples are provided in the sample inventory file.

## Example commands

Interactive shell

```
docker exec -it ansible /bin/bash
```

List hosts in webservers group

```
docker exec -it ansible ansible webservers --list-hosts
```

Ping all hosts

```
docker exec -it ansible ansible all -m ping
```

List modules

```
docker exec -it ansible ansible-doc -l
```

Run playbook on example server with the iamgroot user and the -k option to allow specifying a password

```
docker exec -it ansible ansible-playbook playbook.yaml -l example -u iamgroot -k
```

Run ping on all servers with the iamgroot user and prompt for interactive ssh key password specification (use `-–ask-pass` for playbooks and `--ask-become-pass` to ask for the sudo password)

```
docker exec -it ansible ansible all -u iamgroot --ask-pass -m ping
```

The default playbook is extended from a Digital Ocean guide to [configure new Ubuntu 20.04 instances](https://www.digitalocean.com/community/tutorials/how-to-use-ansible-to-automate-initial-server-setup-on-ubuntu-20-04) using ansible.

Community playbooks on [Ansible Galaxy](https://galaxy.ansible.com/.)

## FAQ

Mounting ssh keys with docker for Windows (and various other systems) may result in [permissions errors](https://github.com/moby/moby/issues/27685), so it's best to just copy the relevant key files and change their permissions within the container.

```
docker exec -it ansible mkdir /root/.ssh
docker exec -it ansible cp /root/win-ssh/id_ed25519 /root/.ssh/id_ed25519
docker exec -it ansible chmod 400 /root/.ssh/id_ed25519
```

This would likely have to be repeated every time the container starts. Yay for windows file permissions.

The docker-init.sh has been made to handle this a little more gracefully.

## Warning

For convenience this config sets `host_key_checking = False` by default, which is a security risk. Removing this setting requires additional maintenance steps but is generally recommended:

https://docs.ansible.com/ansible/latest/user_guide/connection_details.html#managing-host-key-checking

This will eat your homework.
