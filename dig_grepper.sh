#!/bin/bash

#HELP-USAGE
if [ $# -eq 0 ]; then
    echo -e "\n\e[1;31mDebe proporcionar un argumento.\e[m"
    echo -e "\e[0;35mEjemplo:\e[m \t \e[0;32m$0\e[m macrosoft.com"
    echo -e "\e[0;35mEjemplo:\e[m \t \e[0;32m$0\e[m 192.168.16.170"
    echo -e "\n\e[1;31mTambién se pueden pasar todas a la vez.\e[m"
    echo -e "\e[0;35mEjemplo:\e[m \t \e[0;32m$0\e[m intertime.com macrosoft.com 192.168.16.170"
    echo -e "\n\e[1;31mPara especificar el servidor DNS preferido para la prueba añade \e[1;33m'@IP'\e[m\e[m como primer argumento."
    echo -e "\e[0;35mEjemplo:\e[m \t \e[0;32m$0\e[m \e[1;33m@192.168.16.150\e[m canariassport.com 192.168.16.170\n"
    echo -e "\e[1;31mTambién puedes utilizar varios DNS colocandolos delante de cada IP"
    echo -e "\e[0;35mEjemplo:\e[m \t \e[0;32m$0\e[m \e[1;33m@192.168.16.150\e[m canariassport.com 192.168.16.170 \e[1;33m@8.8.8.8\e[m canariassport.com\n"
    exit 1
fi

function error_message {
        echo -e "\e[1;37;41m[X]\e[m $1\n"
}

function check_message {
        echo -e "\n\e[1;32;40m[✓]\e[m $1\n"
}

function info_message {
        echo -e "\n\e[1;36;40m[*]\e[m $1\n"
}
#For that loops through all args
for arg in "$@"; do
        #IF DNS isnt defined, set a new DNS variable with the content of the DNS file taken by default in dig
        if [[ -z $DNS ]];then
               DNS=$(cat /etc/resolv.conf | grep "nameserver" | awk -F " " '{print $2}')
        fi
        #If $arg start with "@" set new DNS if not, DNS remains NULL
        if [[ $arg =~ ^@ ]]; then
                DNS=$arg
                check_message "Se ha definido $(echo $DNS | sed 's/@//g') como DNS "
        #If arg follows the regular expression number(dot)number(dot)number(dot)number means we have an IP
        elif [[ $arg =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
                info_message "Respuesta de $arg $(echo '<--' $DNS)"
                #Make a Dig on the target IP | take the next 100 lines after ";; ANSWER" section
                #If we find results in the grep, do again the dig, but this time
                #We split and organice the whole output
                #If it doenst work, print an error message
                dig $DNS -x $arg | grep -A100 -q ';; ANSWER' && dig $DNS -x $arg        |  \
                         awk '/;; ANSWER/{f=1;next} /;;/{f=0} f'                        |  \
                         awk -F " " '{print $1 "\t" $3 "\t" $4 "\t" $5}'                |  \
                         sed 's/^/\t- /'                                                || \
                         error_message "No se pudo obtener respuesta de $arg"
                echo ""
        #If arg follows the regular expression CARACTERS(dot)CARACTERS, we have a website
        elif [[ $arg =~ ^.*\.[^.]{2,10}+$ ]]; then
                info_message "Respuesta de $arg $(echo '<--' $DNS)"
                dig $DNS $arg | grep -A100 -q ';; ANSWER' && dig $DNS $arg              |  \
                         awk '/;; ANSWER/{f=1;next} /;;/{f=0} f'                        |  \
                         awk -F " " '{print $1 "\t" $3 "\t" $4 "\t" $5}'                |  \
                         sed 's/^/\t- /'                                                || \
                         error_message "No se pudo obtener respuesta de $arg"
        #If we have none of these, do nothing but print an error message
        else
                error_message "$arg no es ni una dirección válida."
        fi
done
