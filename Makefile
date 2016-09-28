specs=ln_fast_core.txt ln_latency_core.txt
specdeps=ln_core.txt pipeliner.py
vs=$(specs:.txt=.v)
gvs=$(specs:.txt=.gv)
svgs=$(specs:.txt=.svg)
pngs=$(specs:.txt=.png)
targets=README.md $(vs) $(gvs) $(svgs) $(pngs)

all: $(targets)

README.md: README.md.m4 ln_fast_core.v
	m4 < $< > $@

clean:
	rm -f $(targets)

%.v: %.txt $(specdeps)
	./pipeliner.py verilog $< > $@

%.gv: %.txt $(specdeps)
	./pipeliner.py graphviz $< > $@

%.svg: %.gv
	dot -Tsvg < $< > $@

%.png: %.gv
	dot -Tpng < $< > $@
