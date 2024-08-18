# Taskserver Docker

This is my personal [Taskserver](https://github.com/GothenburgBitFactory/taskserver) docker config.

> [!CAUTION]
> Taskserver is only compatible with Taskwarrior 2.x and is no longer being actively developed.

## Setup

- rename the `vars.example` to `vars` and change the config (default config will not work; see [Taskserver setup docs](https://github.com/GothenburgBitFactory/guides/blob/master/taskserver-setup/taskserver-setup.pdf)):

```shell
mv vars.example vars
vim vars.example
```

- build the docker image:

```shell
./scripts/build.sh
```

- start the docker container:

```
./scripts/start.sh
```

## Add User

- execute `add-user.sh` script and enter your username:

```shell
./scripts/add-user.sh
Please enter your username: USERNAME
New user key: YOUR-USER-KEY
Created user 'USERNAME' for organization 'Public'
** Note: You may use '--sec-param High' instead of '--bits 4096'
Generating a 4096 bit RSA private key...
Generating a signed certificate...
```
> [!IMPORTANT]
> note down `YOUR-USER-KEY` from the command output for later use 

- this will generate a `USERNAME.cert.pem` and a `USERNAME.key.pem` file in the `/var/taskd/pki/` folder
- copy the generated files along with the server certificate to your host machine:

```shell
docker cp taskserver:/var/taskd/pki/USERNAME.key.pem .
docker cp taskserver:/var/taskd/pki/USERNAME.cert.pem .
docker cp taskserver:/var/taskd/pki/ca.cert.pem .
```

- then put them into taskwarrior data folder (usually `.task`):

```shell
cp USERNAME.key.pem .task/
cp USERNAME.cert.pem .task/
cp ca.cert.pem .task/
```

- configure the paths to the `.pem` files:

```shell
task config taskd.certificate -- ~/.task/USERNAME.cert.pem
task config taskd.key -- ~/.task/USERNAME.key.pem
task config taskd.ca -- ~/.task/ca.cert.pem
```

- configure the server name:

```shell
task config taskd.server -- YOUR-SERVER-NAME:53589
```

- configure your user credentials:

```shell
task config taskd.credentials -- Public/USERNAME/YOUR-USER-KEY
```

- then sync the tasks for the first time:

```shell
task sync init
```

- `task sync init` should only be used for the first sync opteration, after that, simply use `task sync`
