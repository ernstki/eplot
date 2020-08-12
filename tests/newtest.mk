# create a new test harness from 'template.m4'
include setup.mk

TEMPLATE := template.m4

# if TESTNAME is not provided as an argument, prompt for it
ifeq ($(TESTNAME),)
	TESTNAME := $(shell \
		read -ep $$'\n$(BLD)Name of test (phrased as a question):$(RST) '; \
		echo $$REPLY | tr ' ' - | tr -dc -- '-_A-Za-z0-9' \
	)
endif

# if TESTNAME is not provided as an argument, derive from TESTNAME
ifeq ($(TESTFILE),)
	TESTFILE := test-$(TESTNAME).mk
endif

# if TESTDESC is not provided as an argument, prompt for it; derive a default
# from TESTNAME (replacing dashes with spaces)
ifeq ($(TESTDESC),)
	# h/t: https://www.cmcrossroads.com/article/gnu-make-escaping-walk-wild-side
	space :=
	space +=
	TESTDESC := $(shell \
		read -ei "$(subst -,$(space),$(TESTNAME))?" \
			-p $$'\n$(BLD)Test description (optional):$(RST) '; \
		echo $$REPLY \
	)
endif

newtest:
	@echo
	@test ! -f "$(TESTFILE)" || $(call BAIL,a test with that name already exists!)
	m4 -D TESTDESC="$(TESTDESC)" -D TESTNAME="$(TESTNAME)" "$(TEMPLATE)" \
		> "$(TESTFILE)"
	@$${EDITOR:-nano} "$(TESTFILE)"
	@$(call DONE,Created new test harness '$(TESTFILE)'.)
