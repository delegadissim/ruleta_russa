#!/bin/bash
function animacio(){
    frames=$(cat frames/frames.txt 2>/dev/null)
    clear
    for (( i=0; i<=$frames; i++))
    do
        formated=$(printf "%04d.jpg" $i)
        jp2a --invert frames/$formated 2>/dev/null
        sleep $((1/30))
    done
    sleep .3
    clear
}


function introduccio(){
    echo -e "¿Quants aneu a jugar?"
    read nombre
    declare -a -g noms=()
    for (( i=0; i<nombre; i++))
    do
        echo -e "\nIntrodueix el nom del jugador $i" 
        read nom
        noms[$i]=$nom 
    done
    clear

}

function imprimir_noms(){
    for (( i=0; i<${#noms[@]}; i++))
    do
        echo ${noms[$i]}
    done
}

function set_up_game(){
    echo "Cuantes forats per possar bales té la pistola?"
    declare -ig nombre_bales=0
    read nombre_bales
    declare -ig bala_mortal=$(($RANDOM%$nombre_bales))
    declare -ig pos_bala=$(($RANDOM%$nombre_bales))
    declare -ig torn=$(($RANDOM%${#noms[@]}))
    echo "Escomençarà a jugar ${noms[$torn]}"
}

function disparar(){
    clear
    echo "Es el torn de: ${noms[$torn]}"
    sleep 1.5
    animacio 
    if [[ $pos_bala -eq $bala_mortal ]]; then
        echo "${noms[$torn]} ha MORT"
        sleep 2.3
        exit 0
    else
        echo "${noms[$torn]} VIU"
        ((pos_bala++))
        ((torn++))
        if [[ $pos_bala -eq $nombre_bales ]]; then
            pos_bala=0
        fi
        if [[ $torn -eq ${#noms[@]} ]]; then
            torn=0
        fi
    read 
    fi
}

function debug_var(){
    echo "Nombre de bales: $nombre_bales"
    echo "La bala mortal es: $bala_mortal"
    echo "Posició actual de la bala: $pos_bala"
    echo "Li toca a $torn que es ${noms[$torn]}"
}

################
#####MAIN#######
################

introduccio
set_up_game
while true
do
    disparar
done
