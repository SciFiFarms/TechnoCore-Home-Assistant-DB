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
RUN chown -R postgres:postgres /shell-migrations
VOLUME /var/lib/postgresql/data
VOLUME /shell-migrations/logs
