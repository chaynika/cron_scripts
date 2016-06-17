#!/bin/bash

USER=root
PASSWORD=$1
DBNAME=MSO_DB
TABLES="CHANNELS CITIES"
OUTPUT_DIR="/usr/amagi/db_dumps"
FILE_PREFIX=${DBNAME}
FILE_EXT='.sql'
FILE_NAME=${FILE_PREFIX}${FILE_EXT}
SQL_HOST_SERVER=$2
PASSWORD_LOCAL=$3

if [ $# -ne 3 ]
then
	echo "Usage: <file_name> <db_password_for_sql_host_root> <sql_host_name> <local_mysql_db_password>"
	exit 1
fi

mkdir -p ${OUTPUT_DIR}
mysqldump -u$USER -p$PASSWORD -h ${SQL_HOST_SERVER} ${DBNAME} > ${OUTPUT_DIR}/${FILE_NAME}
mysql -uroot -p${PASSWORD_LOCAL} ${DBNAME} < ${OUTPUT_DIR}/${FILE_NAME}

mysql -uroot -p${PASSWORD_LOCAL} ${DBNAME} -e "update HEADEND_CHANNEL_DART_ACCESS set IP_ADDRESS='0.0.0.0', LOCAL_IP_ADDRESS ='0.0.0.0';"

mysql -uroot -p${PASSWORD_LOCAL} ${DBNAME} -e "UPDATE users set email = concat('test+', email);"


for table in $tables 
do      
        filename=${table}.sql
        mysqldump -uroot -p${PASSWORD_LOCAL} $DBNAME $table > ${OUTPUT_DIR}/$filename
        if [[ $? -ne 0 ]]
        then    
                echo "$db $table dump unsuccessful"
        else    
                echo "$db $tabe dump successful"
        fi      
done

pushd ${OUTPUT_DIR}
#rm ${FILE_NAME}
popd

exit 0
