#! /bin/bash
################################## info #######################################
#1, use for unload table from oracle database tables into files               #
#2, for now its just use for get vccmd and mmlcmd tables.                     #
#3, work with config files in furture, change log at end of file.             #
#4, build by Chewie, Apr/20/2019.                                             #
###############################################################################

echo "[`date '+%Y/%m%d %H:%M:%S'`] unload start <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"

dsn="10.17.85.21:1521/rec18c"
sql="\"select a.* from vccmd a\""
sql2="\"select a.* from mmlcmd a\""
data="\"../data/vccmd.txt\""
data2="\"../data/mmlcmd.txt\""
log="\"../log/vccmd.log\""
log2="\"../log/mmlcmd.log\""
field="\"|\""

if [ ! -d "../data" ]; then
    mkdir ../data
else
    rm -r ../data
    mkdir ../data
fi

if [ ! -d "../log/" ]; then
    mkdir ../log
else
    rm -r ../log
    mkdir ../log
fi

cmd="sqluldr2 cc/cc@${dsn} query=${sql} file=${data} field=${field} log=${log}"
cmd2="sqluldr2 cc/cc@${dsn} query=${sql2} file=${data2} field=${field} log=${log2}"
#echo ${cmd} | sh
echo ${cmd} | awk '{run=$0;system(run)}' &
echo ${cmd2} | awk '{run=$0;system(run)}' &

wait

echo "[`date '+%Y/%m/%d %H:%M:%S'`] unload finished >>>>>>>>>>>>>>>>>>>>>>>>>>"

############################## chage log ######################################
#1,Apr/20/2019, build.                                                        #
###############################################################################
