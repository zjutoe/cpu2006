
#dinero_param="-l1-isize 8k -l1-dsize 8k -l1-ibsize 16 -l1-dbsize 16 -l1-iassoc 2 -l1-dassoc 2 -l1-irepl l -l1-drepl l -l1-ifetch d -l1-dfetch d -l1-dwalloc a -l1-dwback a -flushcount 10k -stat-idcombine -informat d"
#dinero="/home/toe/bin/dineroIV"

# luajit /home/toe/bin/mrb_share_L1.lua -c4 -s50 -d64 < $LOGDIR/pipe  | \
#     tee >(grep ^1 | cut -d' ' -f2- | $dinero $dinero_param > $LOGDIR/cpu1.dinero)  \
#     >(grep ^2 | cut -d' ' -f2- | $dinero $dinero_param > $LOGDIR/cpu2.dinero) \
#     >(grep ^3 | cut -d' ' -f2- | $dinero $dinero_param > $LOGDIR/cpu3.dinero) \
#     >(grep ^4 | cut -d' ' -f2- | $dinero $dinero_param > $LOGDIR/cpu4.dinero) \
#     >(grep -v \# | cut -d' ' -f2- | $dinero $dinero_param > $LOGDIR/cpu0.dinero) &

[ -e $LOGDIR/pipe ] || mkfifo $LOGDIR/pipe

LACKEY_LOG=$LOGDIR/pipe
META_ROB_LOG="$LOGDIR/meta_rob".log
OOO_LOG="$LOGDIR/ooo".log
MEM_REF_LOG="$LOGDIR/mtrace".log

LUA_PATH="/home/toe/bin/?.lua;;"

luajit ~/bin/meta_rob.lua -c4 -s50 -d64 -q300000 < $LACKEY_LOG > $META_ROB_LOG &

valgrind --log-file=$LACKEY_LOG --tool=lackey --trace-mem=yes --trace-superblocks=yes --detailed-counts=yes $DIR/$BIN $@  

luajit ~/bin/ooo.lua $META_ROB_LOG > $OOO_LOG
luajit ~/bin/mtrace.lua $META_ROB_LOG >$MEM_REF_LOG
