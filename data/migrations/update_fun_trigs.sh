#!/bin/bash

migration_dir=${0%/*}

# next run functions and triggers, bailing if either of these fail, as they
# are required by later steps.
psql --set ON_ERROR_STOP=1 -f "${migration_dir}/../functions.sql" $*
if [ $? -ne 0 ]; then echo "Installing new functions failed.">&2; exit 1; fi
python ${migration_dir}/create-sql-functions.py | psql --set ON_ERROR_STOP=1 $*
if [ $? -ne 0 ]; then echo "Installing generated functions failed.">&2; exit 1; fi
psql --set ON_ERROR_STOP=1 -f "${migration_dir}/../triggers.sql" $*
if [ $? -ne 0 ]; then echo "Installing new triggers failed.">&2; exit 1; fi