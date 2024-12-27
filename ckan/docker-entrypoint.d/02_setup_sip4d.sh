#!/bin/sh

# CKANの設定
ckan config-tool $CKAN_INI "ckan.site_title = SIP4D-CKAN"
# ユーザを作成できないようにする
ckan config-tool $CKAN_INI "ckan.auth.create_user_via_api = false"
ckan config-tool $CKAN_INI "ckan.auth.create_user_via_web = false"

# デフォルト言語の設定
ckan config-tool $CKAN_INI "ckan.locale_default = ja"
ckan config-tool $CKAN_INI "ckan.locale_order = ja en"
ckan config-tool $CKAN_INI "ckan.locales_offered = ja en"
ckan config-tool $CKAN_INI "ckan.locales_filtered_out = en_GB"

# ckanext-spatialの設定
ckan config-tool $CKAN_INI "ckan.spatial.srid = 4326"
ckan config-tool $CKAN_INI "ckan.spatial.default_map_extent = 123.135,23.24,157.76,51.51"
ckan config-tool $CKAN_INI "ckanext.spatial.search_backend = solr"
ckan config-tool $CKAN_INI "ckanext.spatial.common_map.type = custom"
ckan config-tool $CKAN_INI "ckanext.spatial.common_map.custom.url = https://cyberjapandata.gsi.go.jp/xyz/std/{z}/{x}/{y}.png"
ckan config-tool $CKAN_INI "ckanext.spatial.common_map.attribution = Map tiles by <a href=\"https://www.gsi.go.jp\" target=\"_blank\">GSI</a>"

# ckanext-sip4dの設定
ckan config-tool $CKAN_INI "ckanext.sip4d.guests_ban = true"
ckan config-tool $CKAN_INI "ckanext.sip4d.site_title = SIP4D-CKAN"
ckan config-tool $CKAN_INI "ckanext.sip4d.logo_width_percent = 55"
ckan config-tool $CKAN_INI "ckanext.sip4d.show_search_div_flag = true"
ckan config-tool $CKAN_INI "ckanext.sip4d.search_item_list = title:タイトル notes:説明 author:著作者 tags:タグ disaster_name:災害名 res_format:データ形式 code:情報種別コード"
ckan config-tool $CKAN_INI "ckanext.sip4d.pass_phrase = sip4d-ckan"