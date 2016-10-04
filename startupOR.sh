#!/bin/bash 

#OpenResty启动脚本,支持-p -s 选项
if [ $# == 0 ] 
then
    echo "Use default startup:"
    /opt/openresty/nginx/sbin/nginx -p /opt/openresty/nginx/conf
    exit 0
fi

for arg in $*
do
    if [ $arg == "-p" ]
    then
        p_flag="true"
        continue
    elif [ $arg == "-s" ] 
    then
        s_flag="true"
        continue
    elif [ $arg == "-h" ]
    then
       /opt/openresty/nginx/sbin/nginx $arg
        exit 0
    fi

    if [ $s_flag == "true" ]
    then
        arg1="-s "${arg}
        s_flag="false"
    elif [ $p_flag == "true" ]
    then
        arg2="-p "${arg}
        p_flag="false" 
    fi 
done

if [ -z "$arg1" ] && [ -z "$arg2" ]
then
    /opt/openresty/nginx/sbin/nginx
elif [ -z "$arg1" ]
then
    /opt/openresty/nginx/sbin/nginx $arg2
elif [ -z "$arg2" ]
then
    /opt/openresty/nginx/sbin/nginx $arg1
else
    /opt/openresty/nginx/sbin/nginx $arg1 $arg2
fi 

    

