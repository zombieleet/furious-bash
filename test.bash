source ./testify.bash
source ./furious.sh






seqLoop() {
    for i in `seq 1 1000`;do
	echo $i;
    done    
    
}
cstyleLoop() {
    for ((i=0;i<=1000;i=i+1)) {
	    echo $i;
	}
	
}
builtinLoop() {
    
    for i in {1..1000};do
	echo $i
    done
}

cc() {
    for i ;do
	echo $i
    done
}


builtinList() {
    for i in *;do
	echo $i
    done
}

lsStyle() {
    for i in $(ls);do
	echo $i
    done
}


bMark add seqLoop "seq"
bMark add cstyleLoop "cstyle"
bMark add builtinLoop "builtin"

bMark run
bMark complete cc
printf "slowest  "
bMark pluck slowest

printf "fastest "
bMark pluck fastest

bMark unset

bMark add builtinList "builtin"
bMark add lsStyle "lsstyle"

bMark run

bMark complete cc

printf "slowest  "
bMark pluck slowest

printf "fastest  "
bMark pluck fastest

#assert expect "$(bMark pluck 'fastest')" "lsstyle" "Test for Fastest Runner" "This should fail"
#assert expect "$(bMark pluck 'fastest')" "builtin" "Test for Fastest Runner" "This test should pass"

#assert done
