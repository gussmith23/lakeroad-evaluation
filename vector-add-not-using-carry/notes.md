# Case Study: Vector Add Doesn't Instantiate CARRY8 without Registers Present

This is an example that Luis developed.

When we synthsize a behavioral vector add without registers with Vivado, there's no carry chain.
When we synthesize the same implementation with a register on the output, there's a carry chain.

We're trying the same thing using Lakeroad's add module, rather than beh

One argument is, why *wouldn't* you put down a register?
In the world where you are synthesizing instructions individually, you don't want to have to think about registers and timing. So this argument this doesn't work!

Behavioral with registers on the inputs: uses twice the number of registers, but no carry chain!
Register retiming here would push the registers to the output, which, inadvertently makes the tool use a carry as well.

We're seeing weird behavior when there's registers on the inputs. The logic time is 0, but the util report says there's LUTs. **It seems like Vivado only returns times to the last register, if there's a register in the design. If there's no register, it returns the path delay through the whole design.** So if there are registers on the input, it measures the delay from the input to the registers, but not through the logic after the registers.
