#! /usr/bin/make
# .a 与 .tar 没有区别

DANA_PLUS := lib/libdana_video_plus.a

all: $(COBJS) $(CPPOBJS) $(DANA_PLUS)
	$(CC) -g -Wall -shared -o $(DANA_SO) $^ -lpthread -lm

static: $(COBJS) $(CPPOBJS) 
	mkdir -p ./tmp; cd ./tmp; rm -rf *; $(AR) x ../$(DANA_PLUS)
	$(AR) -cr libdanale.a $^ tmp/*

