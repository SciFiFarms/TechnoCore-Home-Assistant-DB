FROM postgres:10.6

#ENV SSL_CERT_FILE /run/secrets/cert_bundle
#ENV SSL_KEY_FILE /run/secrets/key
#ENV SSL_CA_FILE /run/secrets/ca
ENV POSTGRES_DB home_assistant

COPY data /var/lib/postgresql
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
CMD ["-main", "/usr/bin/entrypoint.sh docker-entrypoint.sh postgres", "-post", "exitpoint.sh"]
