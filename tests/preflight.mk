# checks to make sure test data is in place and Gnuplot is available

# provides ANSI colors, ME, MYDIR, MYPARENT, TESTDATADIR, and test functions
include setup.mk

preflight-checks: \
	header \
	are-we-using-THIS-eplot \
	does-test-data-dir-exist \
	does-test-data-dir-contain-test-data \
	is-Gnuplot-is-available-in-search-path \
	footer

header:
	@$(call HEADER,$(ME))

are-we-using-THIS-eplot:
	@which eplot | grep -Eqx '$(MYPARENT)/eplot' || $(FAIL)
	@$(PASS)

does-test-data-dir-exist:
	@test -d "$(TESTDATADIR)" -a -r "$(TESTDATADIR)" || $(FAIL)
	@$(PASS)

does-test-data-dir-contain-test-data:
	@cd "$(TESTDATADIR)" && ls data* &>/dev/null || $(FAIL)
	@$(PASS)

is-Gnuplot-is-available-in-search-path:
	@[[ $$(type -t gnuplot) == file ]] || $(FAIL)
	@$(PASS)

footer:
	@$(call FOOTER)
