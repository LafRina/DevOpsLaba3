#!/bin/bash

IMAGE_NAME="lafenko/http-server-project"

# Функція для запуску контейнера
start_container() {
    local container_name=$1
    local cpu_core=$2
    if [ ! "$(docker ps -a --format '{{.Names}}' | grep -w "$container_name")" ]; then
        echo "Starting container $container_name on CPU core $cpu_core..."
        docker run --name "$container_name" --cpuset-cpus="$cpu_core" --network bridge -d "$IMAGE_NAME"
    else
        echo "Container $container_name already exists. Stopping and removing..."
        cleanup_container "$container_name"
        docker run --name "$container_name" --cpuset-cpus="$cpu_core" --network bridge -d "$IMAGE_NAME"
    fi
}

# Функція для перевірки активності контейнера
is_container_busy() {
    local container_name=$1
    local cpu_usage
    cpu_usage=$(docker stats --no-stream --format "{{.CPUPerc}}" "$container_name" | tr -d '%')
    (( $(echo "$cpu_usage > 10.0" | bc -l) )) && echo "busy" || echo "idle"

}

# Функція для перевірки часу бездіяльності контейнера
check_idle_time() {
    local container_name=$1
    container_last_activity=$(docker inspect --format '{{.State.StartedAt}}' $container_name)
    current_time=$(date --utc +%Y-%m-%dT%H:%M:%SZ)
    time_diff=$(( $(date -d "$current_time" +%s) - $(date -d "$container_last_activity" +%s) ))

    echo $time_diff
}

# Функція для зупинки і видалення контейнера
cleanup_container() {
    local container=$1
    if docker ps -a --format '{{.Names}}' | grep -q "^$container$"; then
        echo "Stopping and removing container $container..."
        docker stop $container
        docker rm $container
    fi
}

# Оновлення контейнера
update_container() {
    local container=$1
    echo "Checking for updates for container $container..."
    local_image=$(docker images -q lafenko/http-server-project:latest)
    remote_image=$(docker pull lafenko/http-server-project:latest | grep "Digest" | awk '{print $2}')
    
    if [[ "$local_image" != "$remote_image" ]]; then
        echo "New image detected. Updating container $container..."
        cleanup_container "$container"
        docker run -d --cpuset-cpus=0 --name "$container" lafenko/http-server-project:latest
    else
        echo "Container $container is already up to date."
    fi
}

# Запуск контейнера srv1
start_container srv1 0

# Логіка для запуску контейнерів srv2 і srv3
while true; do
    echo "Checking srv1..."
    if [[ $(is_container_busy "srv1") == "idle" ]] && [[ $(check_idle_time "srv1") -gt 120 ]]; then
        start_container srv2 1
    fi

    echo "Checking srv2..."
    if [[ $(is_container_busy "srv2") == "idle" ]] && [[ $(check_idle_time "srv2") -gt 120 ]]; then
        start_container srv3 2
    fi

    echo "Checking srv3..."
    if [[ $(check_idle_time "srv3") -gt 120 ]]; then
        echo "srv3 has been idle for more than 2 minutes. Exiting container..."
        cleanup_container "srv3"
    fi

    echo "Checking for updates..."
    update_container srv1
    update_container srv2
    update_container srv3

    sleep 120
done
