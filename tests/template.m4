dnl -- an M4 template for creating new tests harnesses
dnl
dnl -- h/t: https://mbreen.com/m4.html#toc9
`#' test: TESTDESC

# provides ANSI colors, ME, MYDIR, MYPARENT, TESTDATADIR, and test functions
include setup.mk

# test target names should be in the form of a question, like 'does-it-work'
tests: \
	header \
	TESTNAME-check-one \
	TESTNAME-check-two \
	footer

header:
	@$(call HEADER,$(ME))

TESTNAME-check-one:
	@test -f "$(TESTDATADIR)/nosuchfile" || $(FAIL)
	@$(PASS)

TESTNAME-check-two:
	@false || $(FAIL)
	@$(PASS)

footer:
	@$(call FOOTER)
