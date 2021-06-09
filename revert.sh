#!/bin/bash

# Script to revert changes made by deploy script.


helpFunction()
{
   echo ""
   echo "Usage: $0 -d run_date"
   echo -e "\t-d date of first run (MM_DD_YYYY)"
   exit 1 # Exit script after printing help
}

while getopts "p:d:i:" opt
do
   case "$opt" in
      d ) run_date="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$run_date" ]; then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

if [[ ! $run_date =~ ^[0-9]{2}_[0-9]{2}_[0-9]{4}$ ]]; then
  echo "Date $1 is in an invalid format (not MM-DD-YYYY)"
  exit
fi

echo "Reverting files to _$run_date version"

cp /edx/app/edxapp/edx-platform/lms/djangoapps/email_marketing/signals.py_${run_date} /edx/app/edxapp/edx-platform/lms/djangoapps/email_marketing/signals.py
rm /edx/app/edxapp/edx-platform/lms/djangoapps/email_marketing/signals.pyc

cp /edx/app/edxapp/edx-platform/openedx/core/djangoapps/lang_pref/middleware.py_${run_date} /edx/app/edxapp/edx-platform/openedx/core/djangoapps/lang_pref/middleware.py
rm /edx/app/edxapp/edx-platform/openedx/core/djangoapps/lang_pref/middleware.pyc

cp /edx/app/edxapp/edx-platform/openedx/core/djangoapps/lang_pref/views.py_${run_date} /app/edxapp/edx-platform/openedx/core/djangoapps/lang_pref/views.py
rm /edx/app/edxapp/edx-platform/openedx/core/djangoapps/lang_pref/views.pyc

cp /edx/app/edxapp/edx-platform/openedx/core/djangoapps/user_authn/views/auto_auth.py_${run_date} /edx/app/edxapp/edx-platform/openedx/core/djangoapps/user_authn/views/auto_auth.py
rm /edx/app/edxapp/edx-platform/openedx/core/djangoapps/user_authn/views/auto_auth.pyc

cp /edx/app/edxapp/edx-platform/lms/envs/common.py_${run_date} /edx/app/edxapp/edx-platform/lms/envs/common.py
rm /edx/app/edxapp/edx-platform/lms/envs/common.pyc

cp /edx/app/edxapp/lms.env.json_${run_date} /edx/app/edxapp/lms.env.json


