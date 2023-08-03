#!/usr/bin/env bash

DATE=`date +%F_%H.%M`
DIR="/opt/backup"
a=(db1 db2 db3)

for DB in ${a[@]} 
do 
    pg_dump -U postgres -v -w $DB | gzip > $DIR/$DB'_'$DATE.gz  &>$DIR/$DB'_'$DATE.log
    find $DIR -ctime +30 | xargs rm -rf
done
