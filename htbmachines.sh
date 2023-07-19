#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
  tput cnorm &&  exit 1
}

#Ctrl+c
trap ctrl_c INT

#Variables Globales
main_url="https://htbmachines.github.io/bundle.js"


function helpPanel(){
  echo -e "\n${yellowColour}[+]${endColour}${greyColour} Uso:${endColour}\n"
  echo -e "\t${purpleColour}u)${endColour}${greyColour} Descargar o actualizar archivos necesarios${endColour}"
  echo -e "\t${purpleColour}m)${endColour}${greyColour} Buscar por un nombre de maquina${endColour}"
  echo -e "\t${purpleColour}i)${endColour}${greyColour} Buscar por direccion ip${endColour}"
  echo -e "\t${purpleColour}d)${endColour}${greyColour} Buscar por la dificultad de la mÃ¡quina${endColour}"
  echo -e "\t${purpleColour}o)${endColour}${greyColour} Buscar por el sistema operativo de la mÃ¡quina${endColour}"
  echo -e "\t${purpleColour}s)${endColour}${greyColour} Buscar por skill${endColour}"
  echo -e "\t${purpleColour}y)${endColour}${greyColour} Obtener link de la resoluciÃ³n de la mÃ¡quina en Youtube${endColour}"
  echo -e "\t${purpleColour}h)${endColour}${greyColour} Mostrar este panel de ayuda${endColour}\n"
}


function updateFiles(){
  if [ ! -f bundle.js ]; then 
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Descargando los archivos necesarios...${endColour}\n"
    tput civis 
    curl -s $main_url > bundle.js
    js-beautify bundle.js | sponge bundle.js
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Todos los archivos han sido descargados${endColour}\n"
    tput cnorm
  else
    tput civis
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Comprobando si hay actualizaciones pendientes...${endColour}"
    curl -s $main_url > bundle_tmp.js
    js-beautify bundle_tmp.js | sponge bundle_tmp.js

    md5_temp_value=$(md5sum bundle_tmp.js | awk '{print $1}')
    md5_original_value=$(md5sum bundle.js | awk '{print $1}')

    if [ "$md5_temp_value" == "$md5_original_value" ]; then
      echo -e "\n${yellowColour}[+]${endColour}${grayColour} No se han detectado actualizaciones pendientes, lo tienes todo al dÃ­a :)${endColour}"
      rm bundle_tmp.js
    else
      echo -e "\n${yellowColour}[+]${endColour}${grayColour} Se han encontrado actualizaciones disponibles...${endColour}"
      sleep 1
      rm bundle.js && mv bundle_tmp.js bundle.js
      echo -e "\n${yellowColour}[+]${endColour}${grayColour} Los archivos se han actualizado${endColour}"
      
    fi
    tput cnorm
  fi

}

function searchMachine() {
  machineName="$1"

  machineName_checker="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | sed 's/^ *//' | tr -d "\" " | tr -d ",")"

  if [ "$machineName_checker" ]; then 
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Listando las propiedades de la maquina${endColour} ${blueColour}$machineName${endColour}\n"
    cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | sed 's/^ *//' | tr -d "\" " | tr -d ","  
  else
    echo -e "\n${redColour}[!] La mÃ¡quina que proporcionaste no existe${endColour}\n"
  fi

}

function searchIP() {
  ipAddress="$1"

  machineName="$(cat bundle.js | grep "ip: \"$ipAddress\"" -B 3 | grep "name: " | awk 'NF{print $NF}' | tr -d "\"" | tr -d ",")"

  if [ "$machineName" ]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} La mÃ¡quina correspondiente a la IP ${endColour}${blueColour}$ipAddress${endColour} es ${purpleColour}$machineName${endColour}\n"
  else
    echo -e "\n${redColour}[!] La ip que proporcionaste no existe${endColour}\n"
  fi

}

function getYoutubeLink(){
  
  machineName="$1"

  linkYoutube="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | sed 's/^ *//' | tr -d "\" " | tr -d "," | grep youtube | sed 's/:/ /' | awk 'NF{print $NF}')"

  if [ "$linkYoutube" ]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} La resoluciÃ³n para esta mÃ¡quina estÃ¡ en el siguiente enlace: ${blueColour}$linkYoutube${endColour}\n"
  else
    echo -e "\n${redColour}[!] La mÃ¡quina que proporcionaste no existe${endColour}\n"
  fi
}

function getMachineDifficulty(){
  
  difficulty="$1"

  result_checker="$(cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"

  if [ "$result_checker" ];  then
    echo -e "\n${yellowColour}[+]${endColour}${grayColoyr} Representando las mÃ¡quinas que poseen un nivel de dificultad ${endColour}${blueColour}$difficulty${endColour}${grayColour}:${endColour}\n"
    cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
  else 
    echo -e "\n${redColour}[!] La dificultad que proporcionaste no existe${endColour}\n"
  fi
}

function getOSMachines(){

  os="$1"

  os_check="$(cat bundle.js | grep "so: \"$os\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"

  if [ "$os_check" ]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Mostrando las mÃ¡quinas cuyo sistema operativo es ${endColour}${blueColour}$os${endColour}${grayColour}:${endColour}\n"
    cat bundle.js | grep "so: \"$os\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
  else
    echo -e "\n${redColour}[!] El sistema operativo indicado no existe${endColour}\n"
  fi
}

function getOSDifficultyMachines(){

  difficulty=$1
  os=$2

  result_checker="$(cat bundle.js | grep "so: \"$os\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
)"
  if [ "$result_checker" ]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Listando mÃ¡quinas con dificultad ${endColour}${blueColour}$difficulty${endColour}${grayColour} que tengan sistema operativo ${endColour}${purpleColour}$os${endColour}${grayColour} :${endColour}\n"
    cat bundle.js | grep "so: \"$os\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
  else
    echo -e "\n ${redColour}[!] La dificultad o sistema operativo ingresado es incorrecto${endColour}\n"
  fi

}

function getSkillMachines(){
  
  skill="$1"
  result_checker="$(cat bundle.js | grep "skills: " -B 6 | grep "$skill" -i -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"

  if [ "$result_checker" ]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Se muestran a continuaciÃ³n las maquinas que requieren la skill ${endColour}${blueColour}$skill${endColour}${grayColour}:${endColour}\n"
    cat bundle.js | grep "skills: " -B 6 | grep "$skill" -i -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
  else
    echo -e "\n${redColour}[!] La skill indicada no existe${endColour}\n"
  fi


}

#Indicadores
declare -i parameter_counter=0

declare -i arg_difficulty=0
declare -i arg_os=0

while getopts "m:ui:y:d:o:s:h" arg; do
  case $arg in
    m) machineName="$OPTARG"; let parameter_counter+=1;;
    u) let parameter_counter+=2;;
    i) ipAddress="$OPTARG"; let parameter_counter+=3;;
    y) machineName="$OPTARG"; let parameter_counter+=4;;
    d) difficulty="$OPTARG"; arg_difficulty=1 ; let parameter_counter+=5;;
    o) os="$OPTARG"; arg_os=1 ; let parameter_counter+=6;;
    s) skill="$OPTARG"; let parameter_counter+=7;;
    h) ;;
  esac
done

if [ $parameter_counter -eq 1 ]; then
  searchMachine $machineName
elif [ $parameter_counter -eq 2 ]; then
  updateFiles
elif [ $parameter_counter -eq 3 ]; then
  searchIP $ipAddress
elif [ $parameter_counter -eq 4 ]; then
  getYoutubeLink $machineName
elif [ $parameter_counter -eq 5 ]; then
  getMachineDifficulty $difficulty
elif [ $parameter_counter -eq 6 ]; then
  getOSMachines $os
elif [ $arg_difficulty -eq 1 ] && [ $arg_os -eq 1 ]; then
  getOSDifficultyMachines $difficulty $os
elif [ $parameter_counter -eq 7 ]; then
  getSkillMachines "$skill"
else
  helpPanel
fi
