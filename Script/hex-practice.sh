#!/bin/bash
# Describe :
#	16进制加减法练习
# History  :
#	2017/03/15	V0.1.0	Simon<xshumeng@gmail.com>
#	2017/03/19	V0.1.0  Simon<xshumeng@gmail.com>

# 1. 环境变量设置
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export PATH

# 2. 全局变量设置
weight_down=1
weight_up=16
bits=1

# 3. 输出帮助信息
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

# 4. 重置练习数字位数
function cweight()
{
    read -p "请输入练习数字的位数：" bit
    [[ ! $bit =~ [0-9] ]] && (echo "请输入数字";cweight;)
    bits=$bit
    weight_up=$((`echo "16^$bit" | bc` - 1))
    weight_down=$((`echo "16^$((bit - 1))" | bc` - 1))
}

# 5. 主循环
function while_done()
{
    while true; do
	read -p "请输入操作选择(eg.?): " input

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

# 6. 产生随机数
function rand()
{
    min=$1
    max=$(($2-$min+1))
    num=$(cat /dev/urandom | head -n 10 | cksum | awk -F ' ' '{print $1}')
    echo $[$num%$max+$min]
}

# 7. 产生操作数符号
function symb()
{
    [[ $(rand 0 1) == 1 ]] && echo "-" || echo "+"
}

# 8. 开始练习循环
function start()
{
    while true; do
	[[ $(rand 0 1) == 1 ]] && rnd3="+" || rnd3="-"
	rnd1=`rand $weight_down $weight_up`
	rnd2=`rand $weight_down $weight_up`
	hex1=`echo "ibase=10;obase=16;$((rnd1 - 1))" | bc`
	hex2=`echo "ibase=10;obase=16;$((rnd2 - 1))" | bc`
	res=`echo "$((rnd1 - 1))$rnd3$((rnd2 - 1))" | bc`
	read -p "$hex1 $rnd3 $hex2 = " ires
	[[ "$ires" = "q" ]] && break
	iresd=`echo "obase=10;ibase=16;$ires" | bc`
	sureres=`echo "obase=16;ibase=10;$res" | bc`
	[[ $iresd == $res ]] && echo -e "\033[32m你答对了：$sureres\033[0m" || echo -e "\033[31m正确答案：$sureres\033[0m"
    done
}

# 9. 开始主循环
while_done

# 10. 正常退出
exit 0
