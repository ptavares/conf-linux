#!/bin/bash

function init {
    if [ -z /sbin/mount.jmtpfs ]; then
        sudo ln -s /usr/bin/jmtpfs /sbin/mount.jmtpfs
    fi
    if [ ! -d ${HOME}/mtp/ ]; then
        mkdir ${HOME}/mtp
    fi
}

case $1 in
    mount)
        init
        if [ "$(ls -A ${HOME}/mtp)" ]; then
            echo "already mount"
        else
            jmtpfs ${HOME}/mtp/
        fi
        ;;
    umount)
        if [ -d ${HOME}/mtp/ ] && [ "$(ls -A ${HOME}/mtp)" ]; then
            sudo umount ${HOME}/mtp/
        else
            echo "already umount"
            if [ -d ${HOME}/mtp/ ]; then
                rm -Rf ${HOME}/mtp/
            fi
        fi
        ;;
    *)
        echo "$0 [mount|umount]"
        ;;
esac
