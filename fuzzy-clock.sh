#!/usr/bin/env bash

### Ориентировъчен часовник ###

# Час и минути в цифри. Ако часът е преполовен,
# добави единица за изчисляване на оставащото
# време до кръгъл час.
min=$(date +%-M) 
if [[ $min -ge 38 ]]; then 
	hr=$(($(date +%l) + 1)) 
else
	hr=$(date +%l | sed 's/ //g') 
fi
	

# Преобразуване цифрите на кръглия час в думи.
case $hr in
	1|13) hr="един" ;;
	2) hr="два" ;;
	3) hr="три" ;;
	4) hr="четири" ;;
	5) hr="пет" ;;
	6) hr="шес" ;;
	7) hr="седем" ;;
	8) hr="осем" ;;
	9) hr="девет" ;;
	10) hr="десет" ;;
	11) hr="единайсе" ;;
	12) hr="дванайсе" ;;
esac

# Преобразуване и на минутите в думи.
if [[ $min -ge 58 || $min -le 3 ]]; then
	min=" часът"
elif [[ $min -ge 3 && $min -le 7 ]]; then
	min=" и пет"
elif [[ $min -ge 8 && $min -le 12 ]]; then
	min=" и десет"
elif [[ $min -ge 13 && $min -le 17 ]]; then
	min=" и петнайсе"
elif [[ $min -ge 18 && $min -le 22 ]]; then
	min=" и двайсе"
elif [[ $min -ge 23 && $min -le 27 ]]; then
	min=" и двайс'пет"
elif [[ $min -ge 28 && $min -le 32 ]]; then
	min=" и половина"
elif [[ $min -ge 33 && $min -le 37 ]]; then
	min=" и трийс'пет"
elif [[ $min -ge 38 && $min -le 42 ]]; then
	min=" без двайсе"
elif [[ $min -ge 43 && $min -le 47 ]]; then
	min=" без петнайсе"
elif [[ $min -ge 48 && $min -le 52 ]]; then
	min=" без десет"
elif [[ $min -ge 53 && $min -le 57 ]]; then
	min=" без пет"
fi

# Покажи времето.
echo -n $hr $min
