#! /bin/bash
################################## info #######################################
#1, use for unload table from oracle database tables into files               #
#2, for now its just use for get vccmd and mmlcmd tables.                     #
#3, work with config files in furture, change log at end of file.             #
#4, build by Chewie, Apr/20/2019.                                             #
###############################################################################

echo "[`date '+%Y/%m%d %H:%M:%S'`] unload start <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"

dbip=`grep "\[ip\]" ../cfg/01_unload.cfg -a1 | tail -1`
dbport=`grep "\[port\]" ../cfg/01_unload.cfg -a1 | tail -1`
dbsid=`grep "\[serviceName\]" ../cfg/01_unload.cfg -a1 | tail -1`
dbusr=`grep "\[oracleUser\]" ../cfg/01_unload.cfg -a1 | tail -1`
dbpwd=`grep "\[oraclePassword\]" ../cfg/01_unload.cfg -a1 | tail -1`
splitField=`grep "\[splitField\]" ../cfg/01_unload.cfg -a1 | tail -1`
dsn="${dbip}:${dbport}/${dbsid}"
echo ${splitField}
echo ${dsn}
#dsn="127.0.0.0:49161/xe"
#sql="\"select a.* from table1 a\""
#sql2="\"select a.* from table2 a\""
#data="\"../data/table1.txt\""
#data2="\"../data/table2.txt\""
#log="\"../log/table1.log\""
#log2="\"../log/table2.log\""
#field="\"|\""
#
#if [ ! -d "../data" ]; then
#    mkdir ../data
#else
#    rm -r ../data
#    mkdir ../data
#fi
#
#if [ ! -d "../log/" ]; then
#    mkdir ../log
#else
#    rm -r ../log
#    mkdir ../log
#fi
#
#cmd="sqluldr2 zhuyu/zhuyu@${dsn} query=${sql} file=${data} field=${field} log=${log}"
#cmd2="sqluldr2 zhuyu/zhuyu@${dsn} query=${sql2} file=${data2} field=${field} log=${log2}"
##echo ${cmd} | sh
#echo ${cmd} | awk '{run=$0;system(run)}' &
#echo ${cmd2} | awk '{run=$0;system(run)}' &
#
#wait
#
#echo "[`date '+%Y/%m/%d %H:%M:%S'`] unload finished >>>>>>>>>>>>>>>>>>>>>>>>>>"
#
############################### chage log ######################################
##1,Apr/20/2019, build.                                                        #
################################################################################
