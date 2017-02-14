#/usr/bin/env bash
#set -x
declare -A BENCHMARKS


    

time=$(which time)
[[ $status -gt 0 ]] && {
    printf "this program depends on the GNU/Linux time command"
    exit 1;
}
bMark() {
    local subComm=$1

    

    case $subComm in
	add)
	    local addedFunction=$2
	    local nameOfBenchMark=$3
	    
	    shift #remove the first argument which is subComm
	    
	    [[ ! ${#} -eq 2 ]] && {
		printf "invalid number of arguments"
		return 1;
	    }
	    
	    BENCHMARKS[$nameOfBenchMark]+="${addedFunction}"

	;;
	complete)
	    local executeFunction=$2
	    shift
	    
	    [[ ! ${#} -eq 1 ]] && {
		printf "invalid number of arguments"
		return 1;
	    }
	    
	    declare -F $executeFunction &>/dev/null
	    local status=$?

	    (( status != 0 )) && {

	    	printf "${executeFunction} has not been declared"
		return 1;
	    }
	    
	    for getFunc in ${!BENCHMARKS[@]};do
		$time "%C ${BENCHMARKS[$getFunc]}"
	    done
	    
	    #$executeFunction BENCHMARKS
	    #return 0;
	    ;;
	pluck)

	    ;;
    esac
}



a() {
    echo "hi"
}
c() {
    echo "Hello world"
}
d() {
    echo "montegro"
}
bMark add a 'recurse'
bMark add c 'tco'
bMark add d 'nontco'

bMark complete a
