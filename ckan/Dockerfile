FROM ckan/ckan-base:2.11
USER root
RUN apt-get update && apt-get install -y rsyslog supervisor cron
RUN sed -i '/imklog/s/^/#/' /etc/rsyslog.conf
RUN echo $TZ > /etc/timezone
# Copy custom initialization scripts
COPY --chown=ckan-sys:ckan-sys docker-entrypoint.d/* /docker-entrypoint.d/
COPY --chown=ckan-sys:ckan-sys setup/start_ckan.sh.override ${APP_DIR}/start_ckan.sh
COPY --chown=ckan-sys:ckan-sys setup/ckan_harvesting.conf /etc/supervisor/conf.d/ckan_harvesting.conf
#ハーベスターを5分ごとに実行するように設定
RUN echo "*/5 * * * * ckan --config=/srv/app/ckan.ini harvester run" > /var/spool/cron/crontabs/root
RUN chown root:crontab /var/spool/cron/crontabs/root
RUN chmod 600 /var/spool/cron/crontabs/root

### Harvester ###
RUN pip3 install -e 'git+https://github.com/ckan/ckanext-harvest.git@v1.6.0#egg=ckanext-harvest' && \
    pip3 install -r ${APP_DIR}/src/ckanext-harvest/pip-requirements.txt

### Spatial ###
RUN pip3 install -e 'git+https://github.com/ckan/ckanext-spatial.git@v2.2.0#egg=ckanext-spatial' && \
    pip3 install -r ${APP_DIR}/src/ckanext-spatial/requirements.txt

### SIP4D ###
RUN pip3 install -e 'git+https://github.com/NIED-DIR/ckanext-sip4d.git@v1.1#egg=ckanext-sip4d' && \
    pip3 install -r ${APP_DIR}/src/ckanext-sip4d/requirements.txt

COPY --chown=ckan-sys:ckan-sys patches ${APP_DIR}/patches

#USER ckan

RUN for d in $APP_DIR/patches/*; do \
        if [ -d $d ]; then \
            for f in `ls $d/*.patch | sort -g`; do \
                cd $SRC_DIR/`basename "$d"` && echo "$0: Applying patch $f to $SRC_DIR/`basename $d`"; patch -p1 < "$f" ; \
            done ; \
        fi ; \
    done
