# Kubernetes config

## Environment

- PORT_EXPOSED=55555
- ADDR_TO=localhost
- PORT_TO=3000
- ADDR_TUNNEL=wallet.hostname.or.ip
- ADDR_TUNNEL_SSH_PORT=7022
- REMOTE_USER=root
- PROXY_MODE=false

Expose `PORT_EXPOSED` in the workload and create a service (i.e. `wallet.tunnel`) to access it.

if `PROXY_MODE` is `true`, the tunnel image will create a socks5 proxy in the exposed port. `ADDR_TO` and `PORT_TO` are ignored in this mode.

## Secrets

- `/root/.ssh/id_rsa`: private key authorized in wallet server
- `/root/.ssh/known_hosts`: values retrieved for the wallet using `ssh-keyscan -p $ADDR_TUNNEL_SSH_PORT -H $ADDR_TUNNEL`

---

# Original MD

# ssh-tunnel
Local port forwarding with SSH.
Access a service on private.server.tld:port through an ssh connection between your local/docker server and public.server.tld.

# Requirements
You need to set up passwordless ssh access to your public.server.tld

# Usage
Create a folder on your local/docker server (i.e. /some/local/folder) containing 2 files:
- /some/local/folder/config
- /some/local/folder/private_key (the one used for passwordless access)

Format for /some/local/folder/config 
```
Host public.server.tld
    User sshusername
    HostName public.server.tld
    IdentityFile /root/.ssh/private_key  # (leave /root/.ssh/ as is)
    StrictHostKeyChecking no
    Port 22
```
Launch the container:
```
docker run -d -p 3306:3306 \
	-e PORT_EXPOSED=3306 \
	-e PORT_TO=3306 \
	-e ADDR_TO=private.mysql.server.tld \
	-e ADDR_TUNNEL=public.server.tld \
	-v /some/local/folder:/root/.ssh \
	--name ssh.tunnel \
	ndiazg/ssh-tunnel:latest
```
Now you can access the private service on the chosen port of your local/docker server

```
mysql -u mysqlusername -p -h local.server.tld -P 3306
```

### Tip
Connect and alias your tunnel along with other containers in the same network. 
```
docker network connect --alias some.endpoint somenetwork ssh.tunnel
```
Now your other containers can reach the remote/restricted service at some.endpoint
