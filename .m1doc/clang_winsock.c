/*
 * gcc -o znc client.c -L"D:\Mingw\lib" -lws2_32
 **/
#include <stdio.h>
#include <winsock.h>

int main(int argc, char *argv[])
{
    if (argc != 4) {
        printf("Usage: ip port token\n");
        return -1;
    }

    // create tcp socket
    WSADATA wsaData;
    WSAStartup(MAKEWORD(2, 2), &wsaData);

    unsigned short port = (unsigned short)atoi(argv[2]);    // 服务器的端口号
    char *server_ip = argv[1];       // 服务器ip地址

    int sockfd;
    sockfd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if(sockfd < 0) {
        perror("Can't create TCP socket\n");
        exit(-1);
    }
    
    struct sockaddr_in server_addr;
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = inet_addr(server_ip);
    server_addr.sin_port = htons(port);
    
    int err_log = connect(sockfd, (struct sockaddr*)&server_addr, sizeof(server_addr));      // 主动连接服务器
    if(err_log != 0)
    {
        perror("connect");
        closesocket(sockfd);
        exit(-1);
    }

    send(sockfd, argv[3], strlen(argv[3]), 0);

    closesocket(sockfd);
    
    return 0;
}

