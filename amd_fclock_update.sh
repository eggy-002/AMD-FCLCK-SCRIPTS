#!/usr/bin/env bash

x=0

for (( c=0; c<$(gpu-detect listjson | jq 'length'); c++ ))
	do i=$c;
	if [ "$(gpu-detect listjson | jq '.['$i'] | .brand')" != '"amd"' ];
	then
		if [ "$(gpu-detect listjson | jq '.['$i'] | .subvendor')" != '"Advanced Micro Devices, Inc. [AMD/ATI]"' ];
		then
			echo "$(gpu-detect listjson | jq '.['$i'] | .name')";
			echo "GPU $x is not AMD, incrementing counter";
			((x+=1));
		fi
	fi
done

echo "Searching for AMD cards"

for (( c=0; c<$(gpu-detect listjson | jq 'length'); c++ ))
	do i=$c;
	if [ "$(gpu-detect listjson | jq '.['$i'] | .brand')" == '"amd"' ];
	then
		if [ "$(gpu-detect listjson | jq '.['$i'] | .name')" == '"Radeon RX 6800"' ];
		then
			echo "GPU $x is RX 6800";
			upp -p /sys/class/drm/card$x/device/pp_table set smc_pptable/FreqTableFclk/0=1550 --write;
			((x+=1));
		else
			echo "$(gpu-detect listjson | jq '.['$i'] | .name')";
			echo "GPU $x is not RX 6800, incrementing counter";
			((x+=1));
		fi
	fi
done