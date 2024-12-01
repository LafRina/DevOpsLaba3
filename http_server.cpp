#include <stdio.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <string.h>
#include <sys/types.h>
#include <vector>
#include <cmath>
#include <algorithm>
#include <chrono>
#include "Func.h"

#define PORT 8081

char HTTP_200HEADER[] = "HTTP/1.1 200 Ok\r\n";
char HTTP_404HEADER[] = "HTTP/1.1 404 Not Found\r\n";

void sendGETresponse(int fd, char* strResponse, const std::vector<double>& values);

int CreateHTTPserver() {
    int serverSocket, clientSocket;
    struct sockaddr_in address;
    int addrlen = sizeof(address);

    if ((serverSocket = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
        perror("Socket creation failed");
        exit(EXIT_FAILURE);
    }

    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);

    if (bind(serverSocket, (struct sockaddr*)&address, sizeof(address)) < 0) {
        perror("Socket bind failed");
        close(serverSocket);
        exit(EXIT_FAILURE);
    }

    if (listen(serverSocket, 10) < 0) {
        perror("Socket listen failed");
        close(serverSocket);
        exit(EXIT_FAILURE);
    }

    printf("+++++++ Server is running on port %d +++++++\n", PORT);

    while (1) {
        printf("\n+++++++ Waiting for a new connection ++++++++\n\n");

        if ((clientSocket = accept(serverSocket, (struct sockaddr*)&address, (socklen_t*)&addrlen)) < 0) {
            perror("Error accept()");
            continue;
        }

        char buffer[30000] = {0};
        int bytesRead = read(clientSocket, buffer, 30000);
        if (bytesRead <= 0) {
            printf("Error reading request\n");
            close(clientSocket);
            continue;
        }

        printf("Client message:\n%s\n", buffer);

        // Parse request method
        char method[10] = {0};
        sscanf(buffer, "%s", method);

        if (strcmp(method, "GET") == 0) {
            char response[500] = {0};
            std::vector<double> values;
	    FuncA func;

            // Compute cosine values with simulated load
            auto start = std::chrono::high_resolution_clock::now();
            
	    for (double i=1.0; i<100.0; i+=0.1){
		    func.compute(i, 100);
	    }
	    for (int i = 0; i < 500; ++i) {
       		 std::sort(values.begin(), values.end());
       		 std::reverse(values.begin(), values.end());
	    }
            auto end = std::chrono::high_resolution_clock::now();

            auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();

            sprintf(response, "%sContent-Type: text/plain\r\n\r\nComputed and sorted %zu elements in %lld ms\n", HTTP_200HEADER, values.size(), duration);

            sendGETresponse(clientSocket, response, values);
        } else {
            char response[500] = {0};
            sprintf(response, "%s\r\nInvalid request\n", HTTP_404HEADER);
            write(clientSocket, response, strlen(response));
        }

        close(clientSocket);
    }

    close(serverSocket);
    return 0;
}

void sendGETresponse(int fd, char* strResponse, const std::vector<double>& values) {
    write(fd, strResponse, strlen(strResponse));

    char valueBuffer[50];
    for (const auto& value : values) {
        sprintf(valueBuffer, "%f\n", value);
        write(fd, valueBuffer, strlen(valueBuffer));
    }

    printf("Response sent\n");
}

int main() {
    return CreateHTTPserver();
}

