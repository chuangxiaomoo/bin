# CROSS_COMPILE=arm_v5t_le-
CC := $(CROSS_COMPILE)gcc
XX := $(CROSS_COMPILE)g++

SRCS := $(wildcard *.c)
OBJS := $(SRCS:%.c=%)

CPPSRCS := $(wildcard *.cpp)
CPPOBJS := $(CPPSRCS:%.cpp=%.opp)

INCLUDE := -I. 
CFLAGS 	:= -g -Wall
CPPFLAGS:= -g
LDFLAGS := -lrt -lpthread

all: $(OBJS) $(CPPOBJS)


run r:
	./dzh2_blk_parser

clean c:
	rm -f a.out $(OBJS) $(OBJS:%=%.o)

%.o:%.c
	@echo "----------compile $@------"
	$(CC) -o $@ $< $(CFLAGS) $(INCLUDE)

%.i:%.c
	@echo "----------compile $@------"
	$(CC) -o $@ -E $< $(CFLAGS) $(INCLUDE)

%.opp:%.cpp
	@echo "----------compile $@------"
	$(XX) -o $@ $< $(CFLAGS) $(INCLUDE)

.PHONY: all a clean c run r

