# Case Study: Vector Add Doesn't Instantiate CARRY8 without Registers Present

This is an example that Luis developed.

When we synthsize a behavioral vector add without registers with Vivado, there's no carry chain.
When we synthesize the same implementation with a register on the output, there's a carry chain.

We're trying the same thing using Lakeroad's add module, rather than beh

One argument is, why *wouldn't* you put down a register?
In the world where you are synthesizing instructions individually, you don't want to have to think about registers and timing. So this argument this doesn't work!
