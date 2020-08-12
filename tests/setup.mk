# test setup file ('include' this from each test makefile)
SHELL := bash

# path of makefile that included this one (used for test headers)
ME := $(firstword $(MAKEFILE_LIST))
MYDIR := $(shell cd "$$(dirname "$(ME)")" && pwd)
MYPARENT := $(shell cd "$(MYDIR)/.." && pwd)

# so that tests can find the executable that is in the parent dir
PATH := $(MYPARENT):$(PATH)
export PATH

# where to find test data
TESTDATADIR := $(shell cd "$(MYDIR)/data" 2>/dev/null && pwd)

BLD := $(shell tput bold)
UL  := $(shell tput sgr 0 1)
RED := $(shell tput setaf 1)
GRN := $(shell tput setaf 2)
YEL := $(shell tput setaf 3)
BLU := $(shell tput setaf 4)
MAG := $(shell tput setaf 5)
RST := $(shell tput sgr0)
ifeq ($(findstring UTF,$(LANG)),UTF)
NOK := $(RED)$(BLD)✘$(RST)
OK  := $(GRN)$(BLD)✔︎$(RST)
else
NOK := $(RED)$(BLD)not ok$(RST)
OK  := $(GRN)$(BLD)ok$(RST)
endif
ERR := $(RED)$(BLD)ERROR$(RST)
WRN := $(YEL)$(BLD)WARNING$(RST)
FIN := $(GRN)$(BLD)DONE!$(RST)

define FAIL =
{ echo -e "  $(NOK) - $$(tr _- ' ' <<<"$@")?" >&2; exit 1; }
endef

define PASS =
echo -e "  $(OK) - $$(tr _- " " <<<"$@")?" >&2
endef

define HEADER =
if [[ -n "$(1)" ]]; then echo -e "\n  $(UL)$(BLD)== $(1) ==$(RST)\n"; fi
endef

define FOOTER =
if [[ -n "$(1)" ]]; then echo -e "\n  $(1)\n"; else echo; fi
endef

# generic warning/error/completioin functions you can use inside recipes
define WARN =
{ echo -e "$(WRN): $(1) " >&2; }
endef

define BAIL =
{ echo -e "\n$(ERR): $(1) \n" >&2; exit 1; }
endef

define DONE =
echo -e "\n$(FIN) $(1) \n"
endef

