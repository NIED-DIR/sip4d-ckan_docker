FROM ckan/ckan-base:2.11.1
USER root
RUN apt-get update && apt-get install -y supervisor
RUN echo $TZ > /etc/timezone
# Copy custom initialization scripts
COPY --chown=ckan-sys:ckan-sys docker-entrypoint.d/* /docker-entrypoint.d/
COPY --chown=ckan-sys:ckan-sys setup/start_ckan.sh.override ${APP_DIR}/start_ckan.sh
COPY --chown=ckan-sys:ckan-sys setup/ckan_harvesting.conf /etc/supervisor/conf.d/ckan_harvesting.conf
# ハーベスターを5分ごとに実行する(ckan_harvest_run.shはsupervisorで実行される)
COPY --chown=ckan:ckan-sys setup/ckan_harvester_run.sh ${APP_DIR}/ckan_harvester_run.sh

### Harvester ###
RUN pip3 install -e 'git+https://github.com/ckan/ckanext-harvest.git@v1.6.0#egg=ckanext-harvest' && \
    pip3 install -r ${APP_DIR}/src/ckanext-harvest/pip-requirements.txt

### Spatial ###
RUN pip3 install -e 'git+https://github.com/ckan/ckanext-spatial.git@v2.2.0#egg=ckanext-spatial' && \
    pip3 install -r ${APP_DIR}/src/ckanext-spatial/requirements.txt

### SIP4D ###
RUN pip3 install -e 'git+https://github.com/NIED-DIR/ckanext-sip4d.git@v1.1#egg=ckanext-sip4d' && \
    pip3 install -r ${APP_DIR}/src/ckanext-sip4d/requirements.txt

    #「組織」を「データフォルダ」に変更する
# Organizations=組織の日本語訳では誤解がうまれやすいのでSIP4D-CKANではデータフォルダと訳す
RUN cp ${APP_DIR}/src/ckan/ckan/i18n/ja/LC_MESSAGES/ckan.po ${APP_DIR}/src/ckan/ckan/i18n/ja/LC_MESSAGES/ckan.po.org
RUN sed -i -e "s/組織/データフォルダ/" ${APP_DIR}/src/ckan/ckan/i18n/ja/LC_MESSAGES/ckan.po
RUN cd ${APP_DIR}/src/ckan && \
    python3 setup.py compile_catalog -f --locale ja && \
    python3 setup.py develop

COPY --chown=ckan-sys:ckan-sys patches ${APP_DIR}/patches

#USER ckan  # supervisor起動のためコメントアウト　supervisorの起動はstart_ckan.sh.overrideで定義

RUN for d in $APP_DIR/patches/*; do \
        if [ -d $d ]; then \
            for f in `ls $d/*.patch | sort -g`; do \
                cd $SRC_DIR/`basename "$d"` && echo "$0: Applying patch $f to $SRC_DIR/`basename $d`"; patch -p1 < "$f" ; \
            done ; \
        fi ; \
    done
