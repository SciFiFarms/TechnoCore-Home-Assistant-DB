#!/bin/sh

cd /var/lib/postgresql/data
while [ ! -f pg_hba.conf ];
do
    echo "Waiting for postgresq.conf"
    sleep 1
done

# This allows postgres' initialization to execute first. Then this migration gets applied.
sleep 5

mv pg_hba.conf pg_hba.conf.orig
mv pg_ident.conf pg_ident.conf.orig
mv postgresql.conf postgresql.conf.orig
ln -s ../pg_ident.conf .
ln -s ../postgresql.conf .
ln -s ../pg_hba.conf .

force_reboot=1
export force_reboot
