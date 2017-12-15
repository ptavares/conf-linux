#!/bin/bash

function full {
    echo "Make a full bakcup..."
    dar -v -c "/keybase/private/ptavares/00_BAKCUP/full_backup" -R "/home/ptavares" -w -s 734003200 -y -P Musique -P Téléchargements -P Vidéos -P VirtualBoxVMs -X
}

function diff {
    echo "Make a diff bakcup..."
    dar -v -c  "/keybase/private/ptavares/00_BAKCUP/diff_backup_`date -I`" -R "/home/ptavares" -A "/keybase/private/ptavares/00_BAKCUP/full_backup" -w -s 734003200 -y -P Musique -P Téléchargements -P Vidéos -P VirtualBoxVMs -X
}


case $1 in
    full)
        full
        ;;
    diff)
        diff
        ;;
    *)
        echo "$0 [full|diff]"
        ;;
esac
