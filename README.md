# Furious

### Furious is a bash script that benchmarks bunch of functions, and gives you the ability to be able to extract the fastest or slowest function


# Usage

furious supports the following subcommands

1. add
2. run
3. complete
4. pluck
5. unset

### add

The add subcommand supports two argument.The first argument is a function name ( if the function have argument wrap the first argument in double quotes, if an argument to that function contains space wrap it in single quote), the second argument is the name of the function ( just say tag ), it is important you specify that argument


**example**

```bash

    function love() {
        printf "love???"
    }

```
`furious add love "whatIsLove"`


### run

The run subcommand should be called after you are done adding functions to benchmark,
if this subcommand is not called, you will not be able to use the ***complete*** and ***pluck*** subcommand,


`furious run`

### complete

This subcommand takes just a single argument, which is a function name, behind the scene **furious* passes just a single argument to it, which is an array of the test result

```bash

    function outputAll() {
        for i ;do
            echo "$i"
        done
    }

```

`furious complete outputAll`


### pluck

This subcommand takes a single argument, which is either ***fastest*** or ***slowest***

***fastest***  when you passin fastest as an argument to pluck, it extracts the tagname of the fastest function

***slowest** when you passin slowest as an argument to pluck, it extracts the tagname of the slowest function

`furious pluck fastest`

`furious pluck slowest`


### unset

This subcommand removes the previously added function, this subcommand is useful if you want to do multiple benchmark of several function without a particular group of function affecting another group




# Usage-2

clone the repo
>> git clone https://github.com/zombieleet/furious-bash.git


after cloning this repo with  ***Furious*** in the script that contains the functions you want to test

```bash

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
    #furious complete cc
    printf "\n\nslowest  "
    furious pluck slowest

    printf "\n\nfastest "
    furious pluck fastest

    furious unset

    furious add builtinList "builtin"
    furious add lsStyle "lsstyle"

    furious run

    #furious complete cc

    printf "\n\nslowest  "
    furious pluck slowest

    printf "\n\nfastest  "
    furious pluck fastest


```

notice what happens after we called `furious unset`






***unit testing makes it cooler***

```bash

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
    furious complete cc
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

    furious complete cc

    printf "slowest  "
    furious pluck slowest

    printf "fastest  "
    furious pluck fastest

    assert expect "$(furious pluck 'fastest')" "builtin" "Test for Fastest Runner" "This should pass"
    assert expect "$(furious pluck 'slowest')" "lsstyle" "Test for Slowest Runner" "This should pass"

    assert done



```

# License

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
