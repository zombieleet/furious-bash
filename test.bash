source ../assert-unit/testify.bash
source benchmark.sh



#bMark add seqLoop "seq"
#bMark add cstyleLoop "cstyle"
#bMark add builtinLoop "builtin"

bMark add builtinList "builtin"
bMark add lsStyle "lsstyle"

bMark run
bMark complete cc

assert expect "$(bMark pluck 'fastest')" "lsstyle" "Test for Fastest Runner" "This should pass"
