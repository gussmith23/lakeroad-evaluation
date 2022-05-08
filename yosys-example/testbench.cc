#include "Vexample.h"
#include "verilated.h"
int main(int argc, char **argv, char **env)
{
  VerilatedContext *contextp = new VerilatedContext;
  contextp->commandArgs(argc, argv);
  Vexample *top = new Vexample{contextp};

  top->a = 0;
  top->b = 0;
  top->eval();
  printf("%d & %d == %d\n", top->a, top->b, top->out);
  assert(top->out == 0);
  top->a = 0;
  top->b = 1;
  top->eval();
  printf("%d & %d == %d\n", top->a, top->b, top->out);
  assert(top->out == 0);
  top->a = 1;
  top->b = 0;
  top->eval();
  printf("%d & %d == %d\n", top->a, top->b, top->out);
  assert(top->out == 0);
  top->a = 1;
  top->b = 1;
  top->eval();
  printf("%d & %d == %d\n", top->a, top->b, top->out);
  assert(top->out == 1);

  delete top;
  delete contextp;
  return 0;
}
