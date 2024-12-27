FROM ckan/ckan-base:2.9

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
#ハーベスターを5分ごとに実行するように設定
RUN echo "*/5 * * * * ckan -c /srv/app/ckan.ini harvester run" > /etc/crontabs/ckan

#「組織」を「データフォルダ」に変更する
# Organizations=組織の日本語訳では誤解がうまれやすいのでSIP4D-CKANではデータフォルダと訳す
RUN cp ${APP_DIR}/src/ckan/ckan/i18n/ja/LC_MESSAGES/ckan.po ${APP_DIR}/src/ckan/ckan/i18n/ja/LC_MESSAGES/ckan.po.org
RUN sed -i -e "s/組織/データフォルダ/" ${APP_DIR}/src/ckan/ckan/i18n/ja/LC_MESSAGES/ckan.po
RUN cd ${APP_DIR}/src/ckan && \
    python3 setup.py compile_catalog -f --locale ja && \
    python3 setup.py develop

### Harvester ###
RUN pip3 install -e 'git+https://github.com/ckan/ckanext-harvest.git@v1.5.6#egg=ckanext-harvest' && \
    pip3 install -r ${APP_DIR}/src/ckanext-harvest/pip-requirements.txt
COPY setup/ckan_harvesting.conf /etc/supervisord.d/ckan_harvesting.conf

#pyprojをインストールする(pyprojの3.xはproj9.0以上なのでprojをソースからインストール)
RUN apk add gcc g++ cmake geos-dev sqlite sqlite-dev curl-dev
ENV SQLITE3_VERSION=3.36.0
#libTiffをソースからインストールする（projに必要）
WORKDIR /root
RUN wget https://download.osgeo.org/libtiff/tiff-4.5.1.tar.gz &&\
    tar zxvf tiff-4.5.1.tar.gz
WORKDIR /root/tiff-4.5.1
RUN ./configure &&\
    make &&\ 
    make install
#projをソースからインストールする（9.0.0以上が必要）
WORKDIR /root
RUN wget https://download.osgeo.org/proj/proj-9.2.1.tar.gz &&\
    tar zxvf proj-9.2.1.tar.gz
WORKDIR /root/proj-9.2.1/build
RUN cmake .. &&\
    cmake --build . &&\
    cmake --build . --target install
ENV PROJ_DIR=/usr/local
#pyprojをGithubからインストールする
WORKDIR ${APP_DIR}
RUN pip install git+https://github.com/pyproj4/pyproj.git@3.6.1

### Spatial ###
RUN pip3 install -e 'git+https://github.com/ckan/ckanext-spatial.git@v2.0.0#egg=ckanext-spatial'
#pyprojのインストールでエラーが出るので、ckanext-spatialに入っているrequirements.txtを使わずにインストールする
COPY setup/spatial-requirements.txt ${APP_DIR}/src/ckanext-spatial/requirements.txt
RUN pip3 install -r ${APP_DIR}/src/ckanext-spatial/requirements.txt

### sip4d ###
RUN pip3 install -e 'git+https://github.com/NIED-DIR/ckanext-sip4d.git@v1.1#egg=ckanext-sip4d'
RUN pip3 install -r ${APP_DIR}/src/ckanext-sip4d/requirements.txt

COPY docker-entrypoint.d/* /docker-entrypoint.d/