#!/bin/sh


check_root () {
    if [ $(whoami) != "root" ]; then
        echo "Need to be root. Aborting..."
        return 1
    fi
}


check_battery_temperature () {
    if ( ! which acpi > /dev/null ); then
        echo "acpi is not installed."
        return 1
    fi

    local safety_margin=10

    local battery_temp=$(acpi -t | grep "degrees C" | cut -d " " -f 4)
    local battery_critical_temp=$(acpi -V | grep "switches to mode critical at temperature" | \
        sed -e "s/.* switches to mode critical at temperature \(.*\) degrees C/\1/g")
    if [ ! -z ${battery_temp} ] && [ ! -z ${battery_critical_temp} ]; then
        if [ $(echo "${battery_temp} >= ${battery_critical_temp} - ${safety_margin}" | bc) -eq 1 ]; then
            echo "Detected high temperature at battery. (safety margin = ${safety_margin} degrees C)"
            echo "Printing output of command [acpi -V]:"
            echo "$(acpi -V)"
            echo "--------------------------------------------------"
        fi
    fi
}


check_cpu_temperature () {
    if ( ! which sensors > /dev/null ); then
        echo "sensors is not installed."
        return 1
    fi

    local safety_margin=10

    for core_id in $(sensors | grep "Core" | sed -e "s/Core \(.*\):.*/\1/g"); do
        local core_info=$(sensors | grep "Core ${core_id}")
        local cpu_current_temp=$(echo ${core_info} | \
            sed -e "s/Core .*:.*+\(.*\)°C *(high = +\(.*\)°C, crit = +\(.*\)°C)/\1/g")
        local cpu_high_temp=$(echo ${core_info} | \
            sed -e "s/Core .*:.*+\(.*\)°C *(high = +\(.*\)°C, crit = +\(.*\)°C)/\2/g")
        local cpu_critical_temp=$(echo ${core_info} | \
            sed -e "s/Core .*:.*+\(.*\)°C *(high = +\(.*\)°C, crit = +\(.*\)°C)/\3/g")
        if [ $(echo "${cpu_current_temp} >= ${cpu_high_temp} - ${safety_margin}" | bc) -eq 1 ]; then
            local flag=1
            break
        fi
    done
    if [ ! -z ${flag} ]; then
        echo "Detected high temperature at CPU. (safety margin = ${safety_margin} degrees C)"
        echo "Printing output of command [sensors]:"
        echo "$(sensors)"
        echo "--------------------------------------------------"
    fi
}


check_hdd_temperature () {
    if ( ! which hddtemp > /dev/null ); then
        echo "hddtemp is not installed."
        return 1
    fi
    if ( ! which nkf > /dev/null ); then
        echo "nkf is not installed."
        return 1
    fi

    local hdd_critical_temp=60
    local safety_margin=10

    for disk in $(ls /dev/sd?); do
        local hdd_temp=$(hddtemp -n -q ${disk})
        if [ $(echo "${hdd_temp} >= ${hdd_critical_temp} - ${safety_margin}" | bc) -eq 1 ]; then
            echo "Detected high temperature at HDD/SSD. (safety margin = ${safety_margin} degrees C)"
            echo "Printing output of command [hddtemp ${disk} | nkf -e]:"
            echo "$(hddtemp ${disk} | nkf -e)"
            echo "--------------------------------------------------"
        fi
    done
}


check_gpu_temperature () {
    if ( ! which nvidia-smi > /dev/null ); then
        echo "nvidia-smi is not installed."
        return 1
    fi

    local safety_margin=10

    for gpu_id in $(nvidia-smi -L | sed -e "s/GPU \(.\): .*/\1/g"); do
        local gpu_temp=$(nvidia-smi -i ${gpu_id} \
                                    --query-gpu=temperature.gpu \
                                    --format=csv,noheader)
        local gpu_slowdown_temp=$(nvidia-smi -i ${gpu_id} -q -d temperature | \
            grep "GPU Slowdown Temp" | sed -e "s/.*GPU Slowdown Temp.* : \(.*\) C/\1/g")
        if [ $(echo "${gpu_temp} >= ${gpu_slowdown_temp} - ${safety_margin}" | bc) -eq 1 ]; then
            echo "Detected high temperature at GPU. (safety margin = ${safety_margin} degrees C)"
            echo "Printing output of command [nvidia-smi -i ${gpu_id} -q -d temperature]:"
            echo "$(nvidia-smi -i ${gpu_id} -q -d temperature)"
            echo "--------------------------------------------------"
        fi
    done
}


check_temperature () {
    check_root
    if [ $? -eq 0 ]; then
        check_battery_temperature
        check_cpu_temperature
        check_hdd_temperature
        check_gpu_temperature
    fi
}


warn_high_temperature () {
    local result_file=/tmp/check_temperature_result.txt
    check_temperature > ${result_file}
    if [ $(cat ${result_file} | wc -l) -ne 0 ]; then
        cat -v ${result_file} | mail -r $1 \
                                     -s "[$(hostname)] High temperature warning" \
                                     $2
    fi
}
