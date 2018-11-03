#!/bin/sh

until createuser homeassistant;
do
    sleep 1
done;

cd /var/lib/postgresql/data
while [ ! -f postgresql.conf ];
do
    sleep 1;
done;

mv pg_hba.conf pg_hba.conf.orig
mv pg_ident.conf pg_ident.conf.orig
mv postgresql.conf postgresql.conf.orig
ln -s ../pg_ident.conf .
ln -s ../postgresql.conf .
ln -s ../pg_hba.conf .

force_reboot=1
export force_reboot