#!/bin/bash

while read -r b; do

    BIN=$(basename $b)
    DIR=$(dirname $b)
    WRAPPER=${BIN%.bin}
    mv $DIR/$WRAPPER $b 
    echo '#!/bin/bash' >  $DIR/$WRAPPER
    echo DIR=$PWD/$DIR >> $DIR/$WRAPPER
    echo BIN=$BIN >>      $DIR/$WRAPPER

    cat bin_wrapper_template >> $DIR/$WRAPPER
done < bin_list.txt 
