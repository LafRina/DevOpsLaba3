#!/bin/bash

# Структура для зберігання контейнерів та їх налаштувань
declare -A containers_config=(
    [srv1]="0"
    [srv2]="1"
    [srv3]="2"
)

# Функція для отримання CPU використання для конкретного контейнера
fetch_cpu_usage() {
    docker stats --no-stream --format "{{.Name}} {{.CPUPerc}}" | grep "$1" | awk '{print $2}' | tr -d '%'
}

# Функція для перевірки, чи контейнер існує
check_container_exists() {
    docker ps --format "{{.Names}}" | grep -q "$1"
}

# Функція для запуску нового контейнера
initialize_container() {
    local container_name=$1
    local cpu_core=$2
    
    # Якщо контейнер існує, видалити його
    if check_container_exists "$container_name"; then
        echo "$(date '+%Y-%m-%d %H:%M:%S'): $container_name already exists. Removing..."
        docker rm -f "$container_name"
    fi

    # Запуск нового контейнера
    echo "$(date '+%Y-%m-%d %H:%M:%S'): Starting container $container_name on CPU core #$cpu_core"
    docker run --name "$container_name" --cpuset-cpus="$cpu_core" --network bridge -d skhtskiryna/my-http-server
}

# Функція для оновлення всіх контейнерів, якщо є новий образ
update_all_containers() {
    local new_image=$(docker pull skhtskiryna/my-http-server | grep "Downloaded newer image")
    
    if [ -n "$new_image" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S'): New image found, updating containers..."
        
        for container in "${!containers_config[@]}"; do
            if check_container_exists "$container"; then
                # Перезапуск контейнера з новим образом
                restart_container "$container"
            fi
        done
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S'): No new image found."
    fi
}

# Перезапуск контейнера з новим образом
restart_container() {
    local container_name=$1
    local cpu_core="${containers_config[$container_name]}"
    
    # Створюємо новий контейнер
    local new_container_name="${container_name}_new"
    initialize_container "$new_container_name" "$cpu_core"
    
    # Зупиняємо та видаляємо старий контейнер
    docker kill "$container_name"
    docker rm "$container_name"
    
    # Перейменовуємо новий контейнер
    docker rename "$new_container_name" "$container_name"
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $container_name has been updated."
}

# Функція для моніторингу і керування контейнерами
monitor_and_manage_containers() {
    while true; do
        # Перевірка контейнера srv1
        monitor_container "srv1"
        
        # Перевірка контейнера srv2
        monitor_container "srv2"
        
        # Перевірка контейнера srv3
        monitor_container "srv3"
        
        # Оновлення контейнерів, якщо є нові образи
        update_all_containers
        
        # Затримка між циклами
        sleep 10
    done
}

# Функція для моніторингу конкретного контейнера
monitor_container() {
    local container_name=$1
    local cpu_usage
    cpu_usage=$(fetch_cpu_usage "$container_name")
    # Перевірка на бездіяльність контейнера
    if (( $(echo "$cpu_usage < 1.0" | bc -l) )); then
        echo "$(date '+%Y-%m-%d %H:%M:%S'): $container_name is idle, stopping..."
        docker kill "$container_name"
        docker rm "$container_name"
    fi


    # Якщо контейнер не працює, запускаємо його
    if ! check_container_exists "$container_name"; then
        echo "$(date '+%Y-%m-%d %H:%M:%S'): $container_name is not running, starting..."
        initialize_container "$container_name" "${containers_config[$container_name]}"
        return
    fi

    # Якщо контейнер зайнятий, запускаємо наступний
    if (( $(echo "$cpu_usage > 45.0" | bc -l) )); then
        echo "$(date '+%Y-%m-%d %H:%M:%S'): $container_name is busy. Starting next container..."
        start_next_container "$container_name"
    fi

}

# Запуск наступного контейнера, якщо попередній зайнятий
start_next_container() {
    local container_name=$1
    case $container_name in
        "srv1") 
            if ! check_container_exists "srv2"; then
                initialize_container "srv2" "${containers_config["srv2"]}"
            fi
            ;;
        "srv2")
            if ! check_container_exists "srv3"; then
                initialize_container "srv3" "${containers_config["srv3"]}"
            fi
            ;;
        *)
            echo "$(date '+%Y-%m-%d %H:%M:%S'): No next container to start."
            ;;
    esac
}

# Запуск основної функції керування контейнерами
monitor_and_manage_containers

