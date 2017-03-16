#!/bin/bash
# Describe :
#	16进制加减法练习
# History  :
#	2017/03/15	V0.1.0	Simon<xshumeng@gmail.com>

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export PATH

weight_down=1
weight_up=16
bits=1

function help()
{
    format="%-5s%-4s%-s\n"
    printf $format "帮助："
    printf $format "" "?" "帮助信息"
    printf $format "" "s" "开始练习"
    printf $format "" "q" "退出程序"
    printf $format "" "c" "重置练习数字位数"
    printf $format "" "p" "查看当前练习的数字位数"
}

function cweight()
{
    read -p "请输入练习数字的位数：" bit
    [[ ! $bit =~ [0-9] ]] && (echo "请输入数字";cweight;)
    bits=$bit
    weight_up=$((`echo "16^$bit" | bc` - 1))
    weight_down=$((`echo "16^$((bit - 1))" | bc` - 1))
}

function while_done()
{
    while true; do
	read -p "请输入操作起始符号(eg.?): " input

	case $input in
	    "?")
		help
		;;
	    "c")
		cweight
		;;
	    "q")
		exit 0
		;;
	    "p")
		echo "当前练习的是$bits位的十六进制加减法"
		;;
	    "s")
		echo "开始练习..."
		start
		;;
	    "")
		help
		;;
	esac
    done
}



function rand()
{
    min=$1
    max=$(($2-$min+1))
    num=$(cat /dev/urandom | head -n 10 | cksum | awk -F ' ' '{print $1}')
    echo $[$num%$max+$min]
}

function symb()
{
    [[ $(rand 0 1) == 1 ]] && echo "-" || echo "+"
}

function start()
{
    while true; do
	rnd1=`rand $weight_down $weight_up`
	rnd2=`rand $weight_down $weight_up`
	hex1=`echo "ibase=10;obase=16;$((rnd1 - 1))" | bc`
	echo -n "计算数式：$hex1 "
	[[ $(rand 0 1) == 1 ]] && rnd3="+" || rnd3="-"
	echo -n "$rnd3 "
	hex2=`echo "ibase=10;obase=16;$((rnd2 - 1))" | bc`
	echo -n "$hex2 = "
	# printf "%$((bits+2))s %-2s%-$((bits+1))s=" $hex1 $rnd3 $hex2
	res=`echo "$((rnd1 - 1))$rnd3$((rnd2 - 1))" | bc`
	read ires
	[[ "$ires" = "q" ]] && break
	iresd=`echo "obase=10;ibase=16;$ires" | bc`
	sureres=`echo "obase=16;ibase=10;$res" | bc`
	[[ $iresd == $res ]] && echo "你答对了：$sureres" || echo "正确答案：$sureres"
    done
}

while_done

exit 0
