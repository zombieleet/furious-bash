source ./testify.bash
source ./furious.bash

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


furious add seqLoop "seq"
furious add cstyleLoop "cstyle"
furious add builtinLoop "builtin"

furious run
# furious complete cc
printf "slowest  "
furious pluck slowest

printf "fastest "
furious pluck fastest

assert expect "$(furious pluck 'fastest')" "builtin" "Test for Fastest Runner" "This test should pass"
assert expect "$(furious pluck 'slowest')" "cstyle" "Test for Slowest Runner" "This test should pass"

furious unset

furious add builtinList "builtin"
furious add lsStyle "lsstyle"

furious run

# furious complete cc

printf "slowest  "
furious pluck slowest

printf "fastest  "
furious pluck fastest

assert expect "$(furious pluck 'fastest')" "builtin" "Test for Fastest Runner" "This should pass"
assert expect "$(furious pluck 'slowest')" "lsstyle" "Test for Slowest Runner" "This should pass"

assert done
