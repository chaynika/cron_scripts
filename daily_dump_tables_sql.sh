#!/bin/sh

USER=root
PASSWORD=$1
SQL_HOST_SERVER=$2
OUTPUT_DIR="/usr/amagi/db_dumps"

if [ $# -ne 2 ]
then
	echo "Usage: <file_name> <db_password_for_sql_host_root> <sql_host_name>"
	exit 1
fi

mkdir -p ${OUTPUT_DIR}
for db in $DBNAMES
do
	if [ $db = "MSO_DB" ]
	then
		tables="CHANNELS CITIES"
	else
		tables="WINDOWS ATS_ROTATE_PLANS ATS_CAMPAIGNS ATS_CAPTIONS ATS_CAPTION_RATES FILLER_CAPTIONS RO_CAMPAIGN_DETAILS RO_SPOT_DETAILS EXPECTED_PLAYED_TIMES RO_SIGNATURE_CAPTIONS AD_PLAY_STATUSES"
	fi

	echo $tables

	for table in $tables
	do
		filename=${table}.sql
		mysqldump -u$USER -p$PASSWORD -h ${SQL_HOST_SERVER} $db $table > ${OUTPUT_DIR}/$filename
		if [[ $? -ne 0 ]]
		then
			echo "$db $table dump unsuccessful"
		else
			echo "$db $tabe dump successful"
		fi
	done
done
