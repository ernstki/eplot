# test: does the '--notitle' option work?

# provides ANSI colors, ME, MYDIR, MYPARENT, TESTDATADIR, and test functions
include setup.mk

DATA1 := $(TESTDATADIR)/data1
DATA2 := $(TESTDATADIR)/data2

# test target names should be in the form of a question, like 'does-it-work'
notitle-tests: \
	header \
	sanity-check-test-data-files-present \
	sanity-check-plot-contains-filename-for-single-plot \
	sanity-check-plot-contains-filename-for-mulfrmul-plot \
	does-notitle-option-work-for-single-plot \
	does-notitle-option-work-for-mulfrmul-plot \
	does-title-option-override-notitle-for-single-plot \
	does-title-option-override-notitle-for-mulfrmul-plot \
	footer

header:
	@$(call HEADER,$(ME))

sanity-check-test-data-files-present:
	@test -f "$(DATA1)" -a -r "$(DATA1)" || $(FAIL)
	@test -f "$(DATA2)" -a -r "$(DATA2)" || $(FAIL)

# filename SHOULD show up as plot title without '--notitle' option
sanity-check-plot-contains-filename-for-single-plot:
	@eplot --dumb "$(DATA1)" 2>/dev/null \
		| head -5 \
		| grep -q data1 || $(FAIL)

# filenames SHOULD show up in plot title without '--notitle' option
sanity-check-plot-contains-filename-for-mulfrmul-plot:
	@eplot --dumb --mulfrmul "$(DATA1)" "$(DATA2)" 2>/dev/null \
		| head -5 \
		| grep -C2 data1 \
		| grep -q data2 || $(FAIL)

# title should NOT contain the filename 'data1'
does-notitle-option-work-for-single-plot:
	@eplot --dumb --notitle "$(DATA1)" 2>/dev/null \
		| head -5 \
		| grep -q data1 && $(FAIL) || true
	@$(PASS)

# title should NOT contain 'data1' OR 'data2'
does-notitle-option-work-for-mulfrmul-plot:
	@eplot --dumb --mulfrmul --notitle "$(DATA1)" "$(DATA2)" 2>/dev/null \
		| head -5 \
		| grep -q 'data[12]' && $(FAIL) || true
	@$(PASS)

does-title-option-override-notitle-for-single-plot:
	@eplot --dumb --notitle -t "series 1" "$(DATA1)" 2>/dev/null \
		| head -5 \
		| grep -q "series 1" || $(FAIL)
	@$(PASS)

does-title-option-override-notitle-for-mulfrmul-plot:
	@eplot --dumb --mulfrmul --notitle -t "series 1@series 2" "$(DATA1)" \
		   "$(DATA2)" 2>/dev/null \
		| head -5 \
		| grep -C2 "series 1" \
		| grep -q "series 2" || $(FAIL)
	@$(PASS)

footer:
	@$(call FOOTER,Finished testing '--notitle' option.)
	
