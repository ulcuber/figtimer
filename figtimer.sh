#!/bin/bash

clear
echo "figTimer" | figlet

format_time() {
    local tt=$1
    local t_ms=$(expr $tt % 100)
    tt=$(expr $tt / 100)
    local t_s=$(expr $tt % 60)
    tt=$(expr $tt / 60)

    # output times
    if [ $tt -eq 0 ]; then
        printf "%02d.%02d\n" $t_s $t_ms
    else
        printf "%02d:%02d.%02d\n" $tt $t_s $t_ms
    fi
}

sum=0
square_sum=0
count=0
best=4294967296
worst=0

while [ 1 ]; do
    key="k"
    while :; do
        printf "\nHit space to start the timer..."
        read -n1 -r -p "" key
        if [ "$key" = '' ]; then
            ts=$(date +%s%N)
            break
        else
            if [ "$key" = 'q' ]; then
                echo "uit"
                exit 0
            fi
        fi
    done

    clear && echo "running" | figlet -W

    read -n1 -r -p "" key
    duration=$((($(date +%s%N) - $ts) / 10000000))
    clear

    sum=$(($sum + $duration))
    count=$(($count + 1))
    mean=$(($sum / $count))

    delta=$(($mean - $duration))
    square_sum=$(($square_sum + $delta * $delta))
    variance=$(($square_sum / $count))
    deviation=$(bc <<<"scale=0; sqrt($variance)")

    if [[ $duration -lt $best ]]; then
        best=$duration
    fi
    if [[ $duration -gt $worst ]]; then
        worst=$duration
    fi
    if [[ $count > 2 ]]; then
        avg=$((($sum - $best - $worst) / ($count - 2)))
    fi

    if [ "$alltimes" == "" ]; then
        delimeter=""
    else
        delimeter=", "
    fi

    currenttime=$(format_time $duration)

    alltimes=$alltimes$delimeter$currenttime

    printf $currenttime | figlet -W
    printf "[$alltimes] ($count) \n\n"
    printf "Best: $(format_time $best)  "
    printf "Worst: $(format_time $worst) \n"
    if [[ -n $avg ]]; then
        printf "Avg: $(format_time $avg)  "
    fi
    printf "Mean: $(format_time $mean)  "
    printf "Standard deviation: $(format_time $deviation) \n"
done
