# Makefile for eplot
#
# ANSI colors defined here
include tests/setup.mk

TESTDIR := $(shell cd tests && pwd)
TESTS := $(shell cd "$(TESTDIR)" && \ls test*.mk)
SCRIPTS := eplot ec

define dir-in-path =
$(shell echo '$(PATH)' | tr : \\n | grep -Eqx '$(1)/?' && echo 1)
endef

# find an acceptable place to install that's in the users PATH
ifeq ($(call dir-in-path,$(HOME)/bin),1)
	USERBIN := $(HOME)/bin
else ifeq ($(call dir-in-path,$(HOME)/.local/bin),1)
	USERBIN := $(HOME)/.local/bin
else
	USERBIN :=
endif

help:
	@echo; \
	echo "  $(UL)$(BLD)$(BLU)Makefile targets$(RST)"; \
	echo; \
	echo "    $(BLD)make help$(RST)                 - this help"; \
	echo; \
	echo "    $(BLD)make install$(RST)              - install scripts into user 'bin' directory"; \
	echo; \
	echo "    $(BLD)make install PREFIX=$(MAG)path$(RST)  - install scripts into '$(BLD)$(MAG)path$(RST)/bin' instead"; \
	echo; \
	echo "    $(BLD)make test$(RST)                 - run automated tests"; \
	echo; \
	echo "    $(BLD)make newtest$(RST)              - make a new test harness"; \
	echo; \

install:
ifneq ($(PREFIX),)
	install $(SCRIPTS) "$(PREFIX)/bin"
else ifneq ($(USERBIN),)
	install $(SCRIPTS) "$(USERBIN)"
else
	@echo
	@$(call WARN,Could not find acceptable path for automatic installation.)
	exit 1
endif

test: tests
tests: preflight-checks
	@cd "$(TESTDIR)" && { $(foreach test,$(TESTS),make -f $(test);) }

newtest:
	@cd "$(TESTDIR)" && make -f newtest.mk

preflight-checks:
	@cd "$(TESTDIR)" && make -f preflight.mk

