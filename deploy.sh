#!/bin/bash

# Script to manually deploy code fix for Chrome v91 issue in edX.
# https://github.com/edx/edx-platform/pull/23671
# https://ibleducation.atlassian.net/browse/CISCOV3-121?focusedCommentId=16652

while true; do
    read -p "Do you wish to run this program?" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

today=$(date +'%m_%d_%Y')

echo "Processing signals.py"
cp /edx/app/edxapp/edx-platform/lms/djangoapps/email_marketing/signals.py /edx/app/edxapp/edx-platform/lms/djangoapps/email_marketing/signals.py_${today}
cp signals.py /edx/app/edxapp/edx-platform/lms/djangoapps/email_marketing/signals.py
rm /edx/app/edxapp/edx-platform/lms/djangoapps/email_marketing/signals.pyc
echo "Done with signals.py"

echo "Processing middleware.py"
cp /edx/app/edxapp/edx-platform/openedx/core/djangoapps/lang_pref/middleware.py /edx/app/edxapp/edx-platform/openedx/core/djangoapps/lang_pref/middleware.py_${today}
cp middleware.py /edx/app/edxapp/edx-platform/openedx/core/djangoapps/lang_pref/middleware.py
rm /edx/app/edxapp/edx-platform/openedx/core/djangoapps/lang_pref/middleware.pyc
echo "Done with middleware.py"

echo "Processing views.py"
cp /edx/app/edxapp/edx-platform/openedx/core/djangoapps/lang_pref/views.py /edx/app/edxapp/edx-platform/openedx/core/djangoapps/lang_pref/views.py_${today}
cp views.py /edx/app/edxapp/edx-platform/openedx/core/djangoapps/lang_pref/views.py
rm /edx/app/edxapp/edx-platform/openedx/core/djangoapps/lang_pref/views.pyc
echo "Done with views.py"

echo "Processing auto_auth.py"
cp /edx/app/edxapp/edx-platform/openedx/core/djangoapps/user_authn/views/auto_auth.py /edx/app/edxapp/edx-platform/openedx/core/djangoapps/user_authn/views/auto_auth.py_${today}
cp auto_auth.py /edx/app/edxapp/edx-platform/openedx/core/djangoapps/user_authn/views/auto_auth.py
rm /edx/app/edxapp/edx-platform/openedx/core/djangoapps/user_authn/views/auto_auth.pyc
echo "Done with auto_auth.py"

echo "Processing common.py"
src=/edx/app/edxapp/edx-platform/lms/envs/common.py
dest=/edx/app/edxapp/edx-platform/lms/envs/common.py_${today}
cp $src $dest

if (( $(grep -c "SESSION_SERIALIZER" $src) )); then
	sed -i "/SESSION_SERIALIZER/a DCS_SESSION_COOKIE_SAMESITE_FORCE_ALL = True" $src
	sed -i "/SESSION_SERIALIZER/a DCS_SESSION_COOKIE_SAMESITE = 'None'" $src
fi

rm /edx/app/edxapp/edx-platform/lms/envs/common.pyc
echo "Done with common.py"

echo "Processing lms.env.json"
src=/edx/app/edxapp/lms.env.json
dest=/edx/app/edxapp/lms.env.json_${today}
cp $src $dest

if (( $(grep -c "DATA_DIR" $src) )); then
	sed -i '/DATA_DIR/a  \  \  "DCS_SESSION_COOKIE_SAMESITE_FORCE_ALL": true,' $src
	sed -i '/DATA_DIR/a  \  \  "DCS_SESSION_COOKIE_SAMESITE": "None",' $src
fi
echo "Done with lms.env.json"