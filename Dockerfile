FROM postgres
#RUN createuser homeassistant
#ENV POSTGRES_INITDB_ARGS=--auth-host=cert
#COPY pg_hba.conf /var/lib/postgresql/data/pg_hba.conf
#ARG userid
ENV SSL_CERT_FILE /run/secrets/ha_db_cert
ENV SSL_KEY_FILE /run/secrets/ha_db_key
ENV SSL_CA_FILE /run/secrets/ca
ENV POSTGRES_DB homeassistant
#RUN useradd --no-create-home --user-group --shell /bin/bash --uid $userid $username 
#RUN usermod -u $userid postgres

COPY postgres-image/docker-entrypoint.sh /usr/local/bin/
COPY data /var/lib/postgresql
COPY dogfish/dogfish /usr/bin/
COPY shell-migrations/ /shell-migrations/
RUN chown -R postgres:postgres /var/lib/postgresql/*
VOLUME /var/lib/postgresql/data

# Add dogfish.
COPY dogfish/ /usr/share/dogfish
COPY shell-migrations/ /usr/share/dogfish/shell-migrations
RUN ln -s /usr/share/dogfish/dogfish /usr/bin/dogfish
RUN mkdir /var/lib/dogfish 
RUN touch /var/lib/postgresql/data/migrations.log && ln -s /var/lib/postgresql/data/migrations.log /var/lib/dogfish/migrations.log
RUN chown -R postgres:postgres /var/lib/dogfish/ 

# Set up the CMD and pre/post hooks.
COPY go-init /bin/go-init
COPY entrypoint.sh /usr/bin/entrypoint.sh
COPY exitpoint.sh /usr/bin/exitpoint.sh
ENTRYPOINT ["go-init"]
CMD ["-pre", "entrypoint.sh", "-main", "docker-entrypoint.sh postgres", "-post", "exitpoint.sh"]
