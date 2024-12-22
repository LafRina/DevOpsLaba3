#!/bin/bash

# URL сервера, до якого виконуються запити
SERVER_URL="http://localhost/compute"

# Кількість потоків (асинхронних процесів)
THREAD_COUNT=3

# Функція для виконання запитів
send_request() {
  while true; do
    # Виконання HTTP-запиту
    echo "Sending request to $SERVER_URL from process $$"
    curl -s -o /dev/null -w "%{http_code}\n" $SERVER_URL
    # Випадкова затримка між 5 і 10 секундами
    sleep $((RANDOM % 6 + 5))
  done
}

# Запуск THREAD_COUNT процесів
for ((i=1; i<=THREAD_COUNT; i++)); do
  send_request &
done

# Очікування завершення всіх фонових процесів (фактично нескінченно)
wait

