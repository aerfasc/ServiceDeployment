#! /bin/bash
# Filename   : fpm_tools.sh
# Auth      : aerfaChen
# Create    : 2021/10/13
# Version   : 1.0

# Description:  install packaging tools;  Support CentOS 7

export PATH=$PATH:/usr/local/ruby/bin/


fun_get_fpm(){
    #
    which fpm |xargs echo "fpm_status: "
    if [ ! $(which fpm )  ]; then

    # not found fpm, install fpm

        yum-config-manager --enable ol7_optional_latest > /dev/null 2>&1 
        yum install -y rpm-build squashfs-tools  zlib-devel openssl-devel gcc gcc-c++ make wget > /dev/null 2>&1 

        # download ruby : --no-check-certificate : https://cache.ruby-china.com/pub/ruby/ruby-2.3.8.tar.gz

        wget --no-check-certificate https://cache.ruby-china.com/pub/ruby/ruby-2.3.8.tar.gz -O /opt/ruby-2.3.8.tar.gz \
        && cd /opt && tar -xf ruby-2.3.8.tar.gz \
        && cd ruby-2.3.8 \
        && ./configure --prefix=/usr/local/ruby > /dev/null \
        && make -j$(grep "cpu cores" /proc/cpuinfo| uniq |awk '{print $NF}') > /dev/null \
        && make install 
    else
        exit 1
    fi
    
        # rely: zlib
        cd /opt/ruby-2.3.8/ext/zlib \
        && /usr/local/ruby/bin/ruby extconf.rb > /dev/null \
        && make -j$(grep "cpu cores" /proc/cpuinfo| uniq |awk '{print $NF}') > /dev/null \
        && make install

        # reyl openssl

        cd /opt/ruby-2.3.8/ext/openssl \
        && /usr/local/ruby/bin/ruby extconf.rb > /dev/null \
        && sed -i '15 i top_srcdir = ../..' Makefile \
        && make -j$(grep "cpu cores" /proc/cpuinfo| uniq |awk '{print $NF}') > /dev/null \
        && make install

        # install fpm

        /usr/local/ruby/bin/gem install fpm  > /dev/null

        # fpm version
        
        echo fpmVersion: 
        /usr/local/ruby/bin/fpm --version

}

fun_get_fpm




