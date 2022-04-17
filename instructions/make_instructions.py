#!/usr/bin/env python3

from os import path as osp

ops = {
    'add': '+',
    'and': '&',
    'concat': None,
    'divs': None,
    'divu': None,
    'extract': None,
    'icmp': None,
    'mods': None,
    'modu': None,
    'mul': '*',
    'mux': None,
    'or': '|',
    'parity': None,
    'replicate': None,
    'shl': '<<',
    'shrs': None,
    'shru': None,
    'sub': '-',
    'xor': None
}

for op, sym in ops.items():
    if sym is None: 
        print(f"Skipping operator {op}")
        continue
    for size in (8, 16):
        program = f'''module example(input [{size-1}:0] a, input [{size-1}:0] b, output [{size-1}:0] out);
  assign out = a {sym} b;
endmodule
'''
        filename = f'{op}{size}.sv'
        with open(osp.join('src', filename), 'w+') as f:
            f.write(program)