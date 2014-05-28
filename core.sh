
dinero_param="-l1-isize 8k -l1-dsize 8k -l1-ibsize 16 -l1-dbsize 16 -l1-iassoc 2 -l1-dassoc 2 -l1-irepl l -l1-drepl l -l1-ifetch d -l1-dfetch d -l1-dwalloc a -l1-dwback a -flushcount 10k -stat-idcombine -informat d"
dinero="/home/toe/bin/dineroIV"

luajit /home/toe/bin/mrb_share_L1.lua -c4 -s50 -d64 < $LOGDIR/pipe  | \
    tee >(grep ^1 | cut -d' ' -f2- | $dinero $dinero_param > $LOGDIR/cpu1.dinero)  \
    >(grep ^2 | cut -d' ' -f2- | $dinero $dinero_param > $LOGDIR/cpu2.dinero) \
    >(grep ^3 | cut -d' ' -f2- | $dinero $dinero_param > $LOGDIR/cpu3.dinero) \
    >(grep ^4 | cut -d' ' -f2- | $dinero $dinero_param > $LOGDIR/cpu4.dinero) \
    >(grep -v \# | cut -d' ' -f2- | $dinero $dinero_param > $LOGDIR/cpu0.dinero) &

valgrind --tool=lackey --log-file=$LOGDIR/pipe --trace-mem=yes --trace-superblocks=yes $DIR/$BIN $@  

