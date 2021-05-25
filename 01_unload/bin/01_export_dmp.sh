#! /bin/bash
#+-----------------------------------------------------------------------------+#
#+01, use to export data from oracle database via datapump.                    +#
#+02, edit config file in ../cfg/ directroy.                                   +#
#+03, change log at the end of program.                                        +#
#+04, build by Chewie#12610 in May/12/2019.                                    +#
#+-----------------------------------------------------------------------------+#

#----------------------------------start----------------------------------------#
echo "**************************************************************************"
echo "[`date '+%Y/%m/%d %H:%M:%S'`] start to export via datapump <<<<<<<<<<<<<<<\
<<<<<<<<<<<<<<<"

#define global variables
cfgName='../cfg/02_expdp.cfg';
tableNumbers=0
declare -r path=`pwd`
declare -r startTime=`date '+%s'`
declare -r dirName="mydir_`date '+%s'`";
declare -r jobName="myjob_`date '+%s'`";


#initialize
rm -rf ${path%/*}/dmp
mkdir ${path%/*}/dmp
chmod 777 ${path%/*}/dmp


#get config values
if [ ! -n "${1}" ];then
    echo "using default config file '../cfg/02_expdp.cfg'";
else
    echo "config file is ${1}";
    cfgName=${1};
fi

get_value()
{
    value=`grep ${1} ${cfgName} -A1 | tail -1`;
    echo ${value};
}

declare -r ip=$(get_value "\[ip\]");
declare -r port=$(get_value "\[port\]");
declare -r serviceName=$(get_value "\[serviceName\]");
declare -r oracleUser=$(get_value "\[oracleUser\]");
declare -r oraclePassword=$(get_value "\[oraclePassword\]");
declare -r dsn="${oracleUser}/${oraclePassword}@${ip}:${port}/${serviceName}";
declare -r process=$(get_value "\[process\]");
declare -r parallel=$(get_value "\[parallel\]");
declare -r content=$(get_value "\[content\]");


#----------------------------start multi processes------------------------------#
trap "exec 1000>&-;exec 1000<&-;exit 0" 2
Pfifo="/tmp/$$.fifo";
mkfifo ${Pfifo};
exec 1000<>${Pfifo};
rm -f ${Pfifo};

for((i=0; i<${process}; i++))
do
    echo;
done >&1000;


#-------------------------------export all tables-------------------------------#
startline=`grep "\[tableList\]" ${cfgName} -n | awk -F ":" '{print $1}'`;
((startline++));
endline=`grep "\[tableListEnd\]" ${cfgName} -n | awk -F ":" '{print $1}'`;
((endline--))

sqlplus ${dsn} <<input > /dev/null
create directory ${dirName} as '${path%/*}/dmp';
input
#---------------incase oracle user didnt have crate directory privalige---------#
#sqlplus '/ as sysdba' <<input
#create directory ${dirName} as '${path%/*}/dmp';
#grant read, write on directory ${dirName} to ${oracleUser};
#input


for i in `sed -n "${startline},${endline}p" ${cfgName}`
do
    read -u1000;
    tableName[${tableNumbers}]=${i%%|*};

    {
        `expdp ${dsn} \
        tables=${tableName[${tableNumbers}]} \
        dumpfile=${tableName[${tableNumbers}]}.dmp \
        logfile=${tableName[${tableNumbers}]}.log \
        directory=${dirName} \
        job_name="${jobName}_${tableName[${tableNumbers}]}" \
        parallel=${parallel} \
        content=${content} > /dev/null` && \
        {echo "${tableName[${tableNumbers}]} done"} || \
        {echo "${tableName[${tableNumbers}]} error"};

        sleep 1;

        echo >&1000;
    }& 

    ((tableNumbers++))
done;

wait;

exec 1000>&-;

#for ((i = `expr ${startline} + 1`; i < ${endline}; i++))
#do
#
#    ((tableNumbers++));
#    
#    tableName=`sed -n ${i}p ${cfgName} | awk -F "|" '{print $1}'`;
#
#    echo "---------------------------split line---------------------------------"
#    echo "(`date '+%Y/%m/%d %H:%M:%S'`) ${tableName} start (<_<)";
#    expdp ${dsn} \
#    tables=${tableName} \
#    dumpfile=${tableName}.dmp \
#    logfile=${tableName}.log \
#    directory=${dirName} \
#    job_name=${jobName} \
#    parallel=${parallel} \
#    content=${content}> /dev/null;
#    #######echo commands##########
#    #echo "
#    #expdp ${dsn} \
#    #tables=${tableName} \
#    #dumpfile=${tableName}.dmp \
#    #logfile=${tableName}.log \
#    #directory=${dirName} \
#    #job_name=${jobName} \
#    #parallel=${parallel}";
#    #content=${content}
#    echo "(`date '+%Y/%m/%d %H:%M:%S'`) ${tableName} finished,\
#    ${tableNumbers} tables already done (>_>)";
#
#done;


#sqlplus '/ as sysdba' <<input
sqlplus ${dsn} <<input > /dev/null
drop directory ${dirName};
input

#-------------------------------calculate runtime-------------------------------#
declare -r endTime=`date '+%s'`;
declare -r runTime=`expr ${endTime} - ${startTime}`;
declare -r hours=`expr ${runTime} / 3600`;
declare -r minutes=`expr ${runTime} % 3600 / 60`;
declare -r seconds=`expr ${runTime} % 3600 % 60`;
echo "it tooks ${hours} hours ${minutes} minutes ${seconds} seconds *.*";


#-----------------------------------finished------------------------------------#
echo "[`date '+%Y/%m/%d %H:%M:%S'`] export all ${tableNumbers} tables finished >\
>>>>>>>>>>>>>>>>>>>>>>>>>";
echo "*************************************************************************";

#+---------------------------------chagne log----------------------------------+#
#+01, May/12/2019, built.                                                      +#
#+02, May/13/2019, add caculate runtime block.                                 +#
#+03, May/13/2019, add parallel parameters.                                    +#
#+-----------------------------------------------------------------------------+#
