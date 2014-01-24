// FILE *f_stdo = NULL;
// f_stdo = fopen("/tmp/stdo", "w");
// p_2_stdo("foot");

#define p_2_stdo(fmt, args...) do { \
            fprintf(f_stdo, "mooQ %s|%d|\n", __FILE__, __LINE__); \
            fprintf(f_stdo, fmt, ##args);   \
            fflush(f_stdo); \
} while(0)

extern FILE* f_stdo;
