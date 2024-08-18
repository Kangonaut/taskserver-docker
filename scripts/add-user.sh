#!/bin/bash

# get user's name
read -p "Please enter your username: " username

# generate certificate and key
printf "\"taskd add user 'Public' '%s' && cd /var/taskd/pki && ./generate.client %s\"" $username $username | xargs docker exec -t taskserver /bin/bash -c 

