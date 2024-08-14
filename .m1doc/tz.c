#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <unistd.h>
#include <time.h>

void display_current_timezone() {
    struct timeval tv;
    struct timezone tz;

    // 获取当前时间和时区
    if (gettimeofday(&tv, &tz) != 0) {
        perror("gettimeofday");
        exit(1);
    }

    // 显示当前时区编号
    int current_offset = -(tz.tz_minuteswest / 60);
    printf("Current Timezone: UTC%+d\n", current_offset);
}

void usage(const char *progname) {
    printf("Usage: %s <timezone offset>\n", progname);
    printf("       <timezone offset>: integer between -12 and +12\n");
}

int main(int argc, char *argv[]) {
    if (argc == 1) {
        // 不带参数时显示当前时区和用法
        display_current_timezone();
        usage(argv[0]);
        return 0;
    }

    if (argc != 2) {
        fprintf(stderr, "Error: Invalid number of arguments.\n");
        usage(argv[0]);
        return 1;
    }

    int offset = -atoi(argv[1]);

    // 检查 offset 是否在有效范围内
    if (offset < -12 || offset > 12) {
        fprintf(stderr, "Error: timezone offset must be between -12 and +12\n");
        return 1;
    }

    // 初始化 struct timezone 结构
    struct timezone tz;
    tz.tz_minuteswest = offset * 60;  // 转换小时偏移为分钟
    tz.tz_dsttime = 0;  // 不使用夏令时

    // 设置时区
    if (settimeofday(NULL, &tz) != 0) {
        perror("settimeofday");
        return 1;
    }

    printf("Timezone set to UTC%+d\n", offset);
    return 0;
}

