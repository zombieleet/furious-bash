#/usr/bin/env bash
#set -x

bMark() {
    local subComm=$1
    
    declare -gA temp_array;
    declare -gA BENCHMARKS

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
	run)
	    local OLDIFS="${IFS}"
	    
	    for getFunc in ${!BENCHMARKS[@]};do
		
		local __timeTaken=$(time ( ${BENCHMARKS[$getFunc]} ) 2>&1 1>/dev/null);
		
		IFS="\n"
		
		local timeTaken=$(sed -n '/real/s/real\s\+//p' <<<"${__timeTaken}");
		
		temp_array["${getFunc}"]="${BENCHMARKS[$getFunc]}(${getFunc}) ${timeTaken}"

		IFS=${OLDIFS}
	    done
	    
	    declare -g __RUN=1;
	    
	    ;;
	
	complete)


	    (( ! __RUN )) && {
		printf "You have to call the run subcommand before calling ${subComm}\n"
		return 1;
	    }

	    
	    local timeTaken;
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
	    
	    
	    $executeFunction "${temp_array[@]}"
	    return 0;
	    ;;
	pluck)

	    
	    (( ! __RUN )) && {
		printf "You have to call the run subcommand before calling ${subComm}\n"
		return 1;
	    }
	    
	    local extractType="${2}"
	    
	    shift
	    
	    [[ ! ${#} -eq 1 ]] && {
		printf "invalid number of arguments\n"
		return 1;
	    }
	    
	    case $extractType in
		fastest)
		    local pushTimeRun
		    
		    for i in "${temp_array[@]}";do
			local timeRun=${i} ; timeRun="${i##*)}"; timeRun="${timeRun//[ ms]/}"
			pushTimeRun+=( ${timeRun} );
		    done


		    local result;
		    
		    for i in "${pushTimeRun[@]}";do
			echo -e "\n\n$i -- master\n\n"
			for j in "${pushTimeRun[@]}";do
			    echo "$j -- slave"
			    sleep 2
			    local __bcResult=$( bc <<<"${i} <= ${j}" );
			    (( __bcResult )) && {
				for x in "${temp_array[@]}";do
				    timeRun=${x} ; timeRun="${i##*)}"
				    
				    if [[ ${i} =~ ${timeRun} ]];then
					
					local nameOfRunner="${x}"
					
					nameOfRunner="${nameOfRunner%%)*}"; nameOfRunner="${nameOfRunner##*(}"
					
					timeRun="${x##*)}"
					
					#result="${timeRun} ${nameOfRunner}"
					result="${nameOfRunner}"
				    fi
				done
			    }
			done

		    done

		    echo $result
		    
		;;
		slowest)
		;;
		*)
		    printf "Invalid type to extract options allowed are [fastest | slowest]\n"
	    esac
	    ;;
    esac
}



a() {
    for i in `seq 1 1000`;do
	echo $i;
    done    

}
c() {

    for i in {1..1000};do
	echo $i
    done
}
d() {
    for ((i=0;i<=1000;i=i+1)) {
	    echo $i;
	}
}
cc() {
    for i ;do
	echo $i
    done
}

bMark add c 'seq'
bMark add d 'c'
bMark add a 'builtin'

bMark run
bMark complete cc

bMark pluck 'fastest'

