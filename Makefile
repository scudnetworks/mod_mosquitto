# Makefile for building the mod_mosquitto FreeSWITCH module

# Customise these as appropriate
MODNAME = mod_mosquitto.so
MODOBJ = mod_mosquitto.o \
mosquitto_cli.o \
mosquitto_config.o \
mosquitto_events.o \
mosquitto_utils.o \
mosquitto_mosq.o
MODCFLAGS = -Wall -Werror
MODLDFLAGS =

CC = gcc
CFLAGS = -fPIC -g -ggdb -I/usr/include `pkg-config --cflags freeswitch` $(MODCFLAGS) -std=c11 -O2
LDFLAGS = `pkg-config --libs freeswitch` -lmosquitto -lssl -lcrypto -lpthread -lrt $(MODLDFLAGS)

.PHONY: all
all: $(MODNAME)

$(MODNAME): $(MODOBJ)
	@$(CC) -shared -o $@ $(MODOBJ) $(LDFLAGS)

.c.o:
	@$(CC) $(CFLAGS) -o $@ -c $<

.PHONY: clean
clean:
	rm -f $(MODNAME) $(MODOBJ)

.PHONY: install
install: $(MODNAME)
	install -d $(DESTDIR)/usr/lib/freeswitch/mod
	install $(MODNAME) $(DESTDIR)/usr/lib/freeswitch/mod
	install -d $(DESTDIR)/etc/freeswitch/autoload_configs
	install autoload_configs/mosquitto.conf.xml $(DESTDIR)/etc/freeswitch/autoload_configs/

.PHONY: release
release: $(MODNAME)
	distribution/make-deb.sh
