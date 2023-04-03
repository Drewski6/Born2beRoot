#!/bin/bash

TIME_SINCE_BOOT_M=$(uptime -s | awk -F: '{print $2}')
TIME_SINCE_BOOT_S=$(uptime -s | awk -F: '{print $3}')

sleep $(bc <<< $TIME_SINCE_BOOT_M%10*60+$TIME_SINCE_BOOT_S)
