#:!/bin/sh

#
#   For getting git status & git branch info in all sub-directory which has git repo 
#                   By OuyangSheng (sheng_ouy@hotmail.com)
#                     2018.04.19
#


GIT_CMD=$1
CMD="branch status branch_status"
basepath=$(cd `dirname $0`; pwd) 

#handle the input command
if [ -z $GIT_CMD ]; then 
    echo "which git cmd : status,branch,diff,checkout,reset. "
    select cmd in ${CMD}
    do
        GIT_CMD=$cmd
        break
    done
else
    case $GIT_CMD in
    br) GIT_CMD=branch ;;
    st) GIT_CMD=status ;;
    a) GIT_CMD=branch_status ;;
    *) echo "Only support 3 commands:br,st,a"
        echo "*****br-->git branch*****"
        echo "*****st-->git status*****"
        echo "*****a-->git branch && git status*****"
        exit 0 ;;
    esac

fi

#search all directories with .git
find android/ -maxdepth 2 -type d -a -name .git > 1.log
find lichee/ -maxdepth 2 -type d -a -name .git >> 1.log


# print all git info to 2.log
if [ -e "2.log" ]; then 
    rm 2.log
fi

while read line
do
    #echo $line
    cd ${line%.*}

    echo ${line%.*} >> $basepath/2.log
   
    if [ $GIT_CMD == "branch_status" ]; then
        git branch >> $basepath/2.log
        git status >> $basepath/2.log
    else
        git $GIT_CMD >> $basepath/2.log
    fi

    cd - > /dev/null

done < 1.log

# analyze the info in 2.log  

sed -i '/^$/d' 2.log
sed -i '/^On*/d' 2.log
sed -i '/^nothing*/d' 2.log
sed -i '/git/d' 2.log

#old_IFS=$IFS
#IFS=;

while read line
do
    if [[ $line =~ ^android ]]; then
        echo -e "\033[34;1m"$line" \033[0m"
    elif [[ $line =~ ^lichee ]]; then
        echo -e "\033[34;1m"$line" \033[0m"
    else
        echo "$line"

    fi

done < 2.log

#IFS=old_IFS

rm 2.log 1.log

