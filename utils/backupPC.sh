#!/bin/bash
KEYBASE_PRIVATE_DIR=/keybase/private/${USER}

function full {
    echo "Make a full bakcup..."
    dar -v -c "${KEYBASE_PRIVATE_DIR}/00_BAKCUP/full_backup" -R "${HOME}" -w -s 4734003200 -y -P Musique -P Téléchargements -P Vidéos -P VirtualBoxVMs -X
}

function diff {
    echo "Make a diff bakcup..."
    dar -v -c  "${KEYBASE_PRIVATE_DIR}/00_BAKCUP/diff_backup_`date -I`" -R "${HOME}" -A "${KEYBASE_PRIVATE_DIR}/00_BAKCUP/full_backup" -w -s 4734003200 -y -P Musique -P Téléchargements -P Vidéos -P VirtualBoxVMs -X
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
