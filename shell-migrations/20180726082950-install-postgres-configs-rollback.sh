rm pg_hba.conf 
rm pg_ident.conf 
rm postgresql.conf 

mv pg_hba.conf.orig pg_hba.conf
mv pg_ident.conf.orig pg_ident.conf
mv postgresql.conf.orig postgresql.conf

pg_ctl -D $(psql -Xtc 'show data_directory') stop 