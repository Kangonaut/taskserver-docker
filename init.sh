#!/bin/bash

if [[ ! -f "$TASKDDATA/ca.cert.pem" ]]
then
  echo "running initial setup ..."

  # init server config
  taskd init

  # copy pki directory
  cp -r /root/taskd-1.1.0/pki $TASKDDATA

  # generate certificates
  cd $TASKDDATA/pki
  ./generate

  ls -la
  cat client.cert.pem

  # copy certificates
  cp client.cert.pem $TASKDDATA
  cp client.key.pem $TASKDDATA
  cp server.cert.pem $TASKDDATA
  cp server.key.pem $TASKDDATA
  cp server.crl.pem $TASKDDATA
  cp ca.cert.pem $TASKDDATA

  # add certificates to config
  taskd config --force client.cert $TASKDDATA/client.cert.pem
  taskd config --force client.key $TASKDDATA/client.key.pem
  taskd config --force server.cert $TASKDDATA/server.cert.pem
  taskd config --force server.key $TASKDDATA/server.key.pem
  taskd config --force server.crl $TASKDDATA/server.crl.pem
  taskd config --force ca.cert $TASKDDATA/ca.cert.pem

  # server config
  cd $TASKDDATA
  taskd config --force log $PWD/taskd.log
  taskd config --force pid.file $PWD/taskd.pid
  taskd config --force server 0.0.0.0:53589

  # verify config
  taskd config

  # create organization
  taskd add org Public
else
  echo "server already configured; skipping initial setup"
fi
