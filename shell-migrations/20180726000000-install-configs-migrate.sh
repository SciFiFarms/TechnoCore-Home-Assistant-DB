#!/bin/sh

until pg_isready -q
do
    echo "Waiting for server to come up."
    sleep 5
done

cd /var/lib/postgresql/data
mv pg_hba.conf pg_hba.conf.orig
mv pg_ident.conf pg_ident.conf.orig
mv postgresql.conf postgresql.conf.orig
ln -s ../pg_ident.conf .
ln -s ../postgresql.conf .
ln -s ../pg_hba.conf .

# Allow enough time for the DB to be created. 
sleep 15

force_reboot=1
export force_reboot
