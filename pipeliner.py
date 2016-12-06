#!/usr/bin/env python

import sys
import re

class Op:
    def __init__(self, name, cycles, fmt, width=None):
        self.name = name
        self.cycles = cycles
        self.fmt = fmt
        self.width = width

class Inst:
    start = None

    def __init__(self, op, output, inputs):
        self.op = op
        self.output = output
        self.inputs = inputs

class Val:
    lastused = None
    deps = []

    def __init__(self, name, width, ready=None):
        self.name = name
        self.width = width # often None
        self.ready = ready

class Pipeline:
    name = None
    clock = None
    rst_n = None
    ops = {}
    inputs = []
    outputs = []
    vals = {}
    consts = {}
    insts = []
    ports = []
    port_widths = {}

    def __init__(self, fname):
        self.add_file(fname)
        self.process()

    def add_file(self, fname):
        with open(fname, 'r') as f:
            for line in f:
                l = line.strip()
                t = line.strip().split('\t')
                if l == '' or t[0].startswith('#'): # comment
                    continue
                self.add(t)

    def add(self, t):
        if t[0] == 'mod': # module name
            if self.name is not None:
                raise Exception('duplicate name: '+t[1])
            self.name = t[1]
        elif t[0] == 'clk': # clock
            if self.clock is not None:
                raise Exception('2nd clock: '+t[1])
            self.clock = t[1]
            self.ports.append(t[1])
            self.port_widths[t[1]] = None
        elif t[0] == 'rst_n': # active-low synchronous reset
            self.rst_n = t[1]
            self.ports.append(t[1])
            self.port_widths[t[1]] = None
        elif t[0] == 'const': # constant
            # const   name   32'hdeadbeef
            if t[1] in self.consts:
                raise Exception('duplicate constant: '+t[1])
            self.consts[t[1]] = t[2]
        elif t[0] == 'in': # inputs
            if t[1] in self.ports:
                raise Exception('duplicate port: '+t[1])
            self.inputs.append(t[1])
            self.ports.append(t[1])
            self.port_widths[t[1]] = t[2] if len(t) >= 3 else None
        elif t[0] == 'out': # outputs
            if t[1] in self.ports:
                raise Exception('duplicate port: '+t[1])
            self.outputs.append(t[1])
            self.ports.append(t[1])
            self.port_widths[t[1]] = t[2] if len(t) >= 3 else None
        elif t[0] == 'def': # definition
            # def   name   cycles   fmt %str   outwidth
            if t[1] in self.ops:
                raise Exception('duplicate definition: '+t[1])
            self.ops[t[1]] = Op(t[1], int(t[2]), t[3], t[4] if len(t) >= 5 else None)
        elif t[0] == 'inst': # instance
            # inst   name   output   input1   input2 ...
            if t[1] not in self.ops:
                raise Exception('undefined op: '+t[1])
            self.insts.append(Inst(self.ops[t[1]], t[2], t[3:]))
        elif t[0] == 'inc': # include other file
            self.add_file(t[1])
        else:
            raise Exception('invalid token: '+t[0])

    def process(self):
        # ensure module has name and clock
        if self.name is None:
            raise Exception('module has no name')
        if self.clock is None:
            raise Exception('module has no clock')

        # mark inputs as ready from beginning
        for name in self.inputs:
            if name in self.vals:
                raise Exception('duplicate input: '+name)
            self.vals[name] = Val(name, self.port_widths[name], ready=0)
            #print 'input %s, ready at %s'%(name, repr(self.vals[name].ready))

        # enumerate op result vals
        for inst in self.insts:
            if inst.output in self.vals:
                raise Exception('output conflict: '+inst.output)
            self.vals[inst.output] = Val(inst.output, inst.op.width)

        # ensure all op inputs exist
        for inst in self.insts:
            for INP in inst.inputs:
                if INP not in self.vals.keys() + self.consts.keys():
                    raise Exception('undefined intermediate: '+INP)

        # ensure all outputs exist
        for output in self.outputs:
            if output not in self.vals.keys() + self.consts.keys():
                raise Exception('undefined output: '+output)

        # ensure all values (including module inputs and constants) go somewhere
        allinputs = [val for inst in self.insts for val in inst.inputs] + self.outputs
        for val in self.vals.keys() + self.consts.keys():
            if val not in allinputs:
                raise Exception('unused value: '+val)

        # calculate timings
        toplace = list(self.insts)
        # dumb O(n!) algorithm:
        while toplace:
            #print '%d left to place'%(len(toplace))
            for inst in toplace:
                readies = [0 if INP in self.consts else self.vals[INP].ready for INP in inst.inputs]
                #print '%s has %s ready for %s'%(inst.output, repr(readies), repr(inst.inputs))
                if None not in readies:
                    toplace.remove(inst)
                    inst.start = max(readies)
                    #print '%s starting at %d; ready=%s'%(INP, inst.start, repr(self.vals[inst.output].ready))
                    self.vals[inst.output].ready = inst.start + inst.op.cycles
                    for INP in inst.inputs:
                        if INP in self.vals:
                            self.vals[INP].lastused = inst.start
        self.cycles = max(self.vals[output].ready for output in self.outputs)

        # outputs lastused at end
        for val in self.vals.itervalues():
            if val.lastused is None:
                val.lastused = self.cycles

    def lifetimes(self):
        times = [(val.name, val.ready, val.lastused) for val in self.vals.itervalues()]
        return '\n'.join('%s %d:%d'%x for x in times)

    def graphviz(self):
        nodes = ['\t"%s" [label="%s"]'%(c, '`%s\n%s'%(c, self.consts[c])) for c in self.consts]
        nodes += ['\t"%s output" [label="%s"]'%(output, output) for output in self.outputs]
        nodes += ['\t"%s" [label="%s"]'%(inst.output, '%s\n%s\n(%d-%d)'%(inst.output, inst.op.name, inst.start, self.vals[inst.output].ready)) for inst in self.insts]
        def delay(src, dst):
            if src in self.consts:
                return 0
            return dst.start - self.vals[src].ready
        intermediates = [(src, dst.output, delay(src, dst)) for dst in self.insts for src in dst.inputs]
        outputs = [(out, out+' output', self.cycles - self.vals[out].ready) for out in self.outputs]
        edges = ['\t"%s" -> "%s"'%(src, dst)+(' [label="%d-cycle\\ndelay", color=red]'%(delay) if delay else '')+';' for src,dst,delay in intermediates + outputs]
        return 'digraph {\n'+'\n'.join(nodes)+'\n'+'\n'.join(edges)+'\n}\n'

    def width(self, name):
        if name in self.port_widths:
            w = self.port_widths[name]
        else:
            w = self.vals[name].width

        if w is not None:
            return w
        return ''

    def verilog(self):
        # info
        info = '// %d-cycle %s'%(self.cycles, self.name)

        # constants
        consts = ['`define %s %s'%(x, self.consts[x]) for x in self.consts]

        # module with ports
        # defaulting to 'input' because clk is not in inputs to avoid it becoming a valid input
        ports = ['%s %s %s'%('output' if x in self.outputs else 'input', self.width(x), x) for x in self.ports]
        module = 'module %s('%(self.name)+', '.join(ports)+');'

        # pipeline registers
        vals = []
        allbumps = []
        for val in self.vals.itervalues():
            bumps = []
            width = self.width(val.name)
            vals.append('wire %s %s_%d;'%(width, val.name, val.ready))
            regs = ['%s_%d'%(val.name, i) for i in xrange(val.ready+1, val.lastused+1)]
            if regs:
                vals.append('reg %s %s;'%(width, ', '.join(regs)))
            for i in xrange(val.ready+1, val.lastused+1):
                bumps.append(('%s_%d'%(val.name, i), '%s_%d'%(val.name, i-1)))
            allbumps.append(bumps)

        # connect ports
        assigns = []
        for INP in self.inputs:
            assigns.append('assign %s_0 = %s;'%(INP, INP));
        for output in self.outputs:
            assigns.append('assign %s = %s_%d;'%(output, output, self.cycles));

        # instances
        insts = []
        for inst in self.insts:
            input_a = ['`%s'%(x) if x in self.consts else '%s_%d'%(x, inst.start) for x in inst.inputs]
            inputs = ', '.join(input_a)
            output = '%s_%d'%(inst.output, inst.start + inst.op.cycles)
            insts.append(inst.op.fmt.format(inst='u%d'%(len(insts)), output=output, inputs=inputs, input_a=input_a))

        # giant synchronous advancement
        advance = ['always @(posedge %s) begin'%(self.clock)]
        if self.rst_n is not None:
            advance.append('\tif (~%s) begin'%self.rst_n)
            for bumps in filter(lambda x: x, allbumps):
                advance.append('\t\t'+' '.join('%s <= 0;'%(x[0]) for x in bumps))
            advance.append('\tend else begin')
        for bumps in filter(lambda x: x, allbumps):
            advance.append('\t\t'+' '.join('%s <= %s;'%x for x in bumps))
        if self.rst_n is not None:
            advance.append('\tend')
        advance.append('end')

        return '\n\n'.join(['\n'.join(x) for x in [[info], consts, [module], vals, assigns, insts, advance, ['endmodule','']]])

def usage():
    sys.stderr.write('Usage: %s pipeline_description_file [lifetimes|graphviz|verilog]\n'%(sys.argv[0]))
    sys.exit(1)

p = Pipeline(sys.argv[2])
if sys.argv[1] == 'lifetimes':
    print p.lifetimes()
elif sys.argv[1] == 'graphviz':
    print p.graphviz()
elif sys.argv[1] == 'verilog':
    print p.verilog()
else:
    usage()
