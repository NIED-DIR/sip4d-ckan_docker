FROM ckan/ckan-base:2.9.7

# Set up environment variables
ENV APP_DIR=/srv/app
ENV TZ=Asia/Tokyo
RUN echo ${TZ} > /etc/timezone

# Make sure both files are not exactly the same
RUN if ! [ /usr/share/zoneinfo/${TZ} -ef /etc/localtime ]; then \
        cp /usr/share/zoneinfo/${TZ} /etc/localtime ;\
    fi ;

# cron 
RUN apk add dcron
COPY setup/cron_ckan /etc/crontabs/ckan

# ckan.iniファイルの更新
COPY setup/ckan.ini ${APP_DIR}/ckan.ini
RUN chown ckan ${APP_DIR}/ckan.ini && \
    chmod 644 ${APP_DIR}/ckan.ini

#「組織」を「データフォルダ」に変更する
# Organizations=組織の日本語訳では誤解がうまれやすいのでSIP4D-CKANではデータフォルダと訳す
RUN cp ${APP_DIR}/src/ckan/ckan/i18n/ja/LC_MESSAGES/ckan.po ${APP_DIR}/src/ckan/ckan/i18n/ja/LC_MESSAGES/ckan.po.org
RUN sed -i -e "s/組織/データフォルダ/" ${APP_DIR}/src/ckan/ckan/i18n/ja/LC_MESSAGES/ckan.po
RUN cd ${APP_DIR}/src/ckan && \
    python3 setup.py compile_catalog -f --locale ja && \
    python3 setup.py develop

### Harvester ###
RUN pip3 install -e 'git+https://github.com/ckan/ckanext-harvest.git@v1.5.3#egg=ckanext-harvest' && \
    pip3 install -r ${APP_DIR}/src/ckanext-harvest/pip-requirements.txt
COPY setup/ckan_harvesting.conf /etc/supervisord.d/ckan_harvesting.conf


### Spatial ###
ENV PROJ_DIR=/usr
RUN apk add gcc g++ proj proj-util proj-dev geos-dev
RUN pip3 install -e 'git+https://github.com/ckan/ckanext-spatial.git@v2.0.0#egg=ckanext-spatial' && \
    pip3 install -r ${APP_DIR}/src/ckanext-spatial/requirements.txt

### sip4d ###
RUN pip3 install -e 'git+https://github.com/NIED-DIR/ckanext-sip4d.git#egg=ckanext-sip4d' && \
    pip3 install -r ${APP_DIR}/src/ckanext-sip4d/requirements.txt

COPY docker-entrypoint.d/* /docker-entrypoint.d/