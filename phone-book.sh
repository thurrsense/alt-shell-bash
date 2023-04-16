#!/bin/bash

dir="$(pwd)"
data="${dir}/data.txt"
comm=$1

function data_check {
	if [ ! -f "${data}" ]; then
		touch "${data}"
	fi
}

function check_num {
	if [[ !($1 =~ ^8\ \([1-9][0-9]{2}\)\ [0-9]{3}\-[0-9]{2}\-[0-9]{2}$) ]]; then
		echo "[-] Error: incorrect number."
		exit 1
	fi
}


function check_name {
	if [[ !($1 =~ ^[А-Яа-яA-Za-z]+\ [А-Яа-яA-Za-z]+$) ]]; then
		echo "[-] Error: incorrect name format."
		exit 1
	fi
}

function search_record {
	if [[ $1 =~ ^8\ \([1-9][0-9]{2}\)\ [0-9]{3}\-[0-9]{2}\-[0-9]{2}$ ]]; then
		check_num "$1"
	else
		check_name "$1"
	fi
	var=`sed -n "/$1/p" "${data}"`
	if [ -n "${var}" ]; then
		echo "Founded data:"
		echo -n "${var}"
		echo
	else
		echo "No matches for arg: $1" 
	fi
}

function new_record {
	check_name "$1"
	check_num "$2"
	var=`sed -n "/$2/p" "${data}"`
	if [ -n "${var}" ]; then
		echo "[-] Error: number already exists: $1"
		exit 1
	else
		echo "$1:$2" >> "${data}"
		exit 0
	fi
}

function delete_record {
	if [[ $1 =~ ^8\ \([1-9][0-9]{2}\)\ [0-9]{3}\-[0-9]{2}\-[0-9]{2}$ ]]; then
		check_num "$1"
	else
		check_name "$1"
	fi
	var=`sed -n "/$1/p" "${data}"`
	if [ -n "${var}" ]; then
		sed -i "/${var}/d" "${data}"
	else
		echo "[-] Error: no matches for: $1"
		exit 1
	fi
}

case "${comm}" in
	"new")
		data_check
		if [[ $# -ne 3 ]]; then 
			echo "[-] Error: a lot of args or miss. Use 'help'."
			exit 1
		fi
		new_record "$2" "$3"
		exit 0
		;;
	"search")
		data_check
		if [[ $# -ne 2 ]]; then
			echo "[-] Error: a lot of args or miss. Use 'help'."
			exit 1
		fi
		search_record "$2"
		exit 0
		;;		
	"delete")
		data_check
		if [[ $# -ne 2 ]]; then
			echo "[-] Error: a lot of args or miss. Use 'help'."		
			exit 1		
		fi
		delete_record "$2"
		exit 0
		;;
	"list")
		data_check
		if [[ $# -ne 1 ]]; then 
			echo "[-] Error: a lot of args or miss. Use 'help'."
			exit 1		
		fi
		sort "${data}"
		exit 0
		;;
	"help")
		if [[ $# -ne 1 ]]; then 
			echo "[-] Error: not recognized argument after 'help'."			
			exit 1
		fi
		cat << EOF
Пример использования:
    ./phone-book.sh команда [аргументы]
Доступные команды:
    new    <имя> <номер>    Добавление записи в телефонную книгу
    search <имя-или-номер>  Поиск записей в телефонной книге
    list                    Просмотр всех записей
    delete <имя-или-номер>  Удаление записи
    help                    Показ этой справки
EOF
		exit 0
		;;
	*)
		data_check
		echo "[-] Error: Unrecognized operation. Use 'help' to view available operations."
		exit 1
		;;
esac


