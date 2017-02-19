#/usr/bin/env bash
#set -x

extract() {

    local op="${1}"
    local pushTimeRun

    for i in "${temp_array[@]}";do
	local timeRun=${i} ; timeRun="${i##*)}"; timeRun="${timeRun//[ ms]/}"
	pushTimeRun+=( ${timeRun} );
    done


    local result;

    for i in "${pushTimeRun[@]}";do

	for j in "${pushTimeRun[@]}";do

	    [[ $i == $j ]] && continue ;

	    local __bcResult=$( bc <<<"${i} $op ${j}" );

	    (( __bcResult )) && {


		[[ ! -z  "${res}" ]] && {

		    local __test=$(bc <<<"${res} $op= ${i}")

		    (( __test )) && {
			break;
		    }
		}

		local res="$i"

		for x in "${temp_array[@]}";do

		    timeRun=${x} ; timeRun="${timeRun##*)}" ; timeRun="${timeRun//[ms]/}"

		    local __final=$( bc <<<"${res} == ${timeRun}" )

		    (( __final )) && {

			local nameOfRunner="${x}"

			nameOfRunner="${nameOfRunner%%)*}"; nameOfRunner="${nameOfRunner##*(}"

			timeRun="${x##*)}"

			#result="${timeRun} ${nameOfRunner}"
			result="${nameOfRunner}"
		    }
		done



	    } || {
		break;
	    }
	done

    done

    echo $result
    #echo $res

}


furious() {
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
		    extract "<"
		;;
		slowest)
		    extract ">"
		;;

		*)
		    printf "Invalid type to extract options allowed are [fastest | slowest]\n"
	    esac
	    ;;
	\unset)
	    unset BENCHMARKS
	    unset temp_array
	    ;;
    esac
}