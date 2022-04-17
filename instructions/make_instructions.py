#!/usr/bin/env python3

from os import path as osp

ops = {
    'add': '+',
    'and': '&',
    'concat': None,
    'divs': '/',
    'divu': '/',
    'extract': None,
    'icmp': None,
    'mods': '%',
    'modu': '%',
    'mul': '*',
    'mux': None,
    'or': '|',
    'parity': None,
    'replicate': None,
    'shl': '<<',
    'shrs': '>>',
    'shru': '>>',
    'sub': '-',
    'xor': '^'
}

signedness = {
    'add': None,
    'and': None,
    'concat': None,
    'divs': 'signed',
    'divu': 'unsigned',
    'extract': None,
    'icmp': None,
    'mods': 'signed',
    'modu': 'unsigned',
    'mul': None,
    'mux': None,
    'or': None,
    'parity': None,
    'replicate': None,
    'shl': None,
    'shrs': 'signed',
    'shru': 'unsigned',
    'sub': None,
    'xor': None
}

for op, sym in ops.items():
    print(f"[+] Visiting {op}")
    if sym is None: 
        print(f"[!!!] Skipping operator {op}: no specified implementation")
        continue
    sign = signedness[op]

    if sign is None:
        sign = ''
    for size in (8, 16):
        print(f"    [+] Size {size}")
        signed_msg = f'with {sign.upper()} inputs' if len(sign) > 0 else ''
        print(f"        -> Creating module for operation {op.upper()} {signed_msg}")
        program = f'''module example(input {sign}[{size-1}:0] a, input {sign}[{size-1}:0] b, output {sign}[{size-1}:0] out);
  assign out = a {sym} b;
endmodule
'''
        filename = f'{op}{size}.sv'
        with open(osp.join('src', filename), 'w+') as f:
            f.write(program)
        print(f"        -> Wrote module to {osp.join('src', filename)}")