README.md: README.md.m4
	cd examples && $(MAKE)
	m4 < $< > $@

clean:
	rm -f *.md
	cd examples && $(MAKE) $@
