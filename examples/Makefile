pipeliner=../pipeliner.py
specs=ln_fast_core.txt ln_latency_core.txt ln_custom_core.txt
specdeps=ln_core.txt $(pipeliner)
vs=$(specs:.txt=.v)
gvs=$(specs:.txt=.gv)
svgs=$(specs:.txt=.svg)
pngs=$(specs:.txt=.png)
targets=$(vs) $(gvs) $(svgs) $(pngs)

all: $(targets)

clean:
	rm -f $(targets)

%.v: %.txt $(specdeps)
	$(pipeliner) verilog $< > $@

%.gv: %.txt $(specdeps)
	$(pipeliner) graphviz $< > $@

%.svg: %.gv
	dot -Tsvg < $< > $@

%.png: %.gv
	dot -Tpng < $< > $@
