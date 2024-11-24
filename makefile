OUT     = trip8
INSTALL = /usr/bin/$(OUT)
SRC     = $(wildcard src/*.c)
DEPS    = $(wildcard src/*.h)
OBJ     = $(addsuffix .o,$(subst src/,bin/,$(basename $(SRC))))

CFLAGS = -pedantic -Wpedantic -Wshadow -Wvla -Wuninitialized -Wundef -Wno-deprecated-declarations \
         -Wall -Wextra -std=c99

LDFLAGS = -lm $(shell sdl2-config --cflags --libs)

OS ?= $(shell uname -s)
ifneq ($(OS),Darwin)
	CFLAGS += -D_POSIX_C_SOURCE -D_XOPEN_SOURCE
endif

.PHONY: debug release clean install uninstall all

debug: CFLAGS += -Werror -DDEBUG -g -Og -fsanitize=address
debug: $(OUT)

release: CFLAGS += -DRELEASE -g0 -O2
release: $(OUT)

$(OUT): bin $(OBJ) $(SRC)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(OUT) $(OBJ)

bin/%.o: src/%.c $(DEPS)
	$(CC) -c $< $(CFLAGS) -o $@

bin:
	mkdir -p bin

install: $(OUT)
	cp $(OUT) $(INSTALL)

uninstall: $(INSTALL)
	rm $(INSTALL)

clean: bin
	rm -r bin/*
	rm $(OUT)

all:
	@echo build, install, uninstall, clean
