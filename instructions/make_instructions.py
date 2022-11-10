#!/usr/bin/env python3

from os import path as osp

# Generates a generator that returns a binary op applied to two args.
f = lambda op_str: f"a {op_str} b"
ops = {
    "and": f("&"),
    "or": f("|"),
    "not": "~a",
    "xor": f("^"),
    "add": f("+"),
    "sub": f("-"),
    "sadd": f("+"),
    "ssub": f("-"),
    # "concat": None,
    #"divs": f("/"),
    #"divu": f("/"),
    # "extract": None,
    # "icmp": None,
    "eq": f("=="),
    "neq": f("!="),
    "uge": f(">="),
    "ugt": f(">"),
    "ule": f("<="),
    "ult": f("<"),
    "sgt": f(">"),
    "slt": f("<"),
    # "mods": f("%"),
    # "modu": f("%"),
    "mul": f("*"),
    "mux": "s ? a : b",
    # "parity": None,
    # "replicate": None,
    # "shl": f("<<"),
    # "shrs": f(">>"),
    # "shru": f(">>"),
}

signedness = {
    "sadd": "signed",
    "ssub": "signed",
    "not": None,
    "add": None,
    "and": None,
    "concat": None,
    "divs": "signed",
    "divu": "unsigned",
    "extract": None,
    "icmp": None,
    "mods": "signed",
    "modu": "unsigned",
    "mul": None,
    "mux": None,
    "or": None,
    "parity": None,
    "replicate": None,
    "shl": None,
    "shrs": "signed",
    "shru": "unsigned",
    "sub": None,
    "xor": None,
    "eq": None,
    "neq": None,
    "uge": "unsigned",
    "ugt": "unsigned",
    "ule": "unsigned",
    "ult": "unsigned",
    "sgt": "signed",
    "slt": "signed",
    "mul": None,
    "mux": None,
}

make_binary_inputs = (
    lambda sign, size: f"input {sign}[{size-1}:0] a, input {sign}[{size-1}:0] b,"
)
inputs = {
    "sadd": make_binary_inputs,
    "ssub": make_binary_inputs,
    "and": make_binary_inputs,
    "or": make_binary_inputs,
    "not": lambda sign, size: f"input {sign}[{size-1}:0] a,",
    "xor": make_binary_inputs,
    "add": make_binary_inputs,
    "sub": make_binary_inputs,
    "divs": make_binary_inputs,
    "divu": make_binary_inputs,
    "eq": make_binary_inputs,
    "neq": make_binary_inputs,
    "uge": make_binary_inputs,
    "ugt": make_binary_inputs,
    "ule": make_binary_inputs,
    "ult": make_binary_inputs,
    "mul": make_binary_inputs,
    "mux": lambda sign, size: f"input s, input {sign}[{size-1}:0] a, input {sign}[{size-1}:0] b,",
}

make_output = lambda sign, size: f"output {sign}[{size-1}:0] out"
outputs = {
    "sadd": make_output,
    "ssub": make_output,
    "and": make_output,
    "or": make_output,
    "not": make_output,
    "xor": make_output,
    "add": make_output,
    "sub": make_output,
    "divs": make_output,
    "divu": make_output,
    "eq": lambda sign, _: f"output {sign} out",
    "neq": lambda sign, _: f"output {sign} out",
    "uge": lambda sign, _: f"output {sign} out",
    "ugt": lambda sign, _: f"output {sign} out",
    "ule": lambda sign, _: f"output {sign} out",
    "ult": lambda sign, _: f"output {sign} out",
    "mul": make_output,
    "mux": make_output,
}

arity = {
    "sadd": 2,
    "ssub": 2,
    "and": 2,
    "or": 2,
    "not": 1,
    "xor": 2,
    "add": 2,
    "sub": 2,
    "divs": 2,
    "divu": 2,
    "eq": 2,
    "neq": 2,
    "uge": 2,
    "ugt": 2,
    "ule": 2,
    "ult": 2,
    "mul": 2,
    "mux": 3,
}

for op, op_expr in ops.items():
    print(f"[+] Visiting {op}")
    sign = signedness[op]

    if sign is None:
        sign = ""
    for size in (1, 2, 3, 4, 5, 6, 7, 8, 16, 32, 64):
        print(f"    [+] Size {size}")
        signed_msg = f"with {sign.upper()} inputs" if len(sign) > 0 else ""
        print(f"        -> Creating module for operation {op.upper()} {signed_msg}")
        modname = f"{op}{size}_{arity[op]}"
        program = f"""module {modname}({inputs[op](sign,size)} {outputs[op](sign,size)});
  assign out = {op_expr};
endmodule
"""
        filename = f"{modname}.sv"
        with open(osp.join("src", filename), "w+") as f:
            f.write(program)
        print(f"        -> Wrote module to {osp.join('src', filename)}")
