Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:27:42 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing_summary -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//inlining.futil-vanilla-timing-summary-opt.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Timing Summary Report

------------------------------------------------------------------------------------------------
| Timer Settings
| --------------
------------------------------------------------------------------------------------------------

  Enable Multi Corner Analysis               :  Yes
  Enable Pessimism Removal                   :  Yes
  Pessimism Removal Resolution               :  Nearest Common Node
  Enable Input Delay Default Clock           :  No
  Enable Preset / Clear Arcs                 :  No
  Disable Flight Delays                      :  No
  Ignore I/O Paths                           :  No
  Timing Early Launch at Borrowing Latches   :  No
  Borrow Time for Max Delay Exceptions       :  Yes
  Merge Timing Exceptions                    :  Yes

  Corner  Analyze    Analyze    
  Name    Max Paths  Min Paths  
  ------  ---------  ---------  
  Slow    Yes        Yes        
  Fast    Yes        Yes        


------------------------------------------------------------------------------------------------
| Report Methodology
| ------------------
------------------------------------------------------------------------------------------------

No report available as report_methodology has not been run prior. Run report_methodology on the current design for the summary of methodology violations.



check_timing report

Table of Contents
-----------------
1. checking no_clock (0)
2. checking constant_clock (0)
3. checking pulse_width_clock (0)
4. checking unconstrained_internal_endpoints (0)
5. checking no_input_delay (131)
6. checking no_output_delay (44)
7. checking multiple_clock (0)
8. checking generated_clocks (0)
9. checking loops (0)
10. checking partial_input_delay (0)
11. checking partial_output_delay (0)
12. checking latch_loops (0)

1. checking no_clock (0)
------------------------
 There are 0 register/latch pins with no clock.


2. checking constant_clock (0)
------------------------------
 There are 0 register/latch pins with constant_clock.


3. checking pulse_width_clock (0)
---------------------------------
 There are 0 register/latch pins which need pulse_width check


4. checking unconstrained_internal_endpoints (0)
------------------------------------------------
 There are 0 pins that are not constrained for maximum delay.

 There are 0 pins that are not constrained for maximum delay due to constant clock.


5. checking no_input_delay (131)
--------------------------------
 There are 131 input ports with no input delay specified. (HIGH)

 There are 0 input ports with no input delay but user has a false path constraint.


6. checking no_output_delay (44)
--------------------------------
 There are 44 ports with no output delay specified. (HIGH)

 There are 0 ports with no output delay but user has a false path constraint

 There are 0 ports with no output delay but with a timing clock defined on it or propagating through it


7. checking multiple_clock (0)
------------------------------
 There are 0 register/latch pins with multiple clocks.


8. checking generated_clocks (0)
--------------------------------
 There are 0 generated clocks that are not connected to a clock source.


9. checking loops (0)
---------------------
 There are 0 combinational loops in the design.


10. checking partial_input_delay (0)
------------------------------------
 There are 0 input ports with partial input delay specified.


11. checking partial_output_delay (0)
-------------------------------------
 There are 0 ports with partial output delay specified.


12. checking latch_loops (0)
----------------------------
 There are 0 combinational latch loops in the design through latch input



------------------------------------------------------------------------------------------------
| Design Timing Summary
| ---------------------
------------------------------------------------------------------------------------------------

    WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints     WPWS(ns)     TPWS(ns)  TPWS Failing Endpoints  TPWS Total Endpoints  
    -------      -------  ---------------------  -------------------      -------      -------  ---------------------  -------------------     --------     --------  ----------------------  --------------------  
     -0.312      -12.174                     56                  973        0.077        0.000                      0                  973        2.225        0.000                       0                   570  


Timing constraints are not met.


------------------------------------------------------------------------------------------------
| Clock Summary
| -------------
------------------------------------------------------------------------------------------------

Clock  Waveform(ns)         Period(ns)      Frequency(MHz)
-----  ------------         ----------      --------------
clk    {0.000 2.500}        5.000           200.000         


------------------------------------------------------------------------------------------------
| Intra Clock Table
| -----------------
------------------------------------------------------------------------------------------------

Clock             WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints     WPWS(ns)     TPWS(ns)  TPWS Failing Endpoints  TPWS Total Endpoints  
-----             -------      -------  ---------------------  -------------------      -------      -------  ---------------------  -------------------     --------     --------  ----------------------  --------------------  
clk                -0.312      -12.174                     56                  973        0.077        0.000                      0                  973        2.225        0.000                       0                   570  


------------------------------------------------------------------------------------------------
| Inter Clock Table
| -----------------
------------------------------------------------------------------------------------------------

From Clock    To Clock          WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints  
----------    --------          -------      -------  ---------------------  -------------------      -------      -------  ---------------------  -------------------  


------------------------------------------------------------------------------------------------
| Other Path Groups Table
| -----------------------
------------------------------------------------------------------------------------------------

Path Group    From Clock    To Clock          WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints  
----------    ----------    --------          -------      -------  ---------------------  -------------------      -------      -------  ---------------------  -------------------  


------------------------------------------------------------------------------------------------
| Timing Details
| --------------
------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------
From Clock:  clk
  To Clock:  clk

Setup :           56  Failing Endpoints,  Worst Slack       -0.312ns,  Total Violation      -12.174ns
Hold  :            0  Failing Endpoints,  Worst Slack        0.077ns,  Total Violation        0.000ns
PW    :            0  Failing Endpoints,  Worst Slack        2.225ns,  Total Violation        0.000ns
---------------------------------------------------------------------------------------------------


Max Delay Paths
--------------------------------------------------------------------------------------
Slack (VIOLATED) :        -0.312ns  (required time - arrival time)
  Source:                 fsm2/out_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            mul_out/out_reg[31]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        5.304ns  (logic 3.776ns (71.192%)  route 1.528ns (28.808%))
  Logic Levels:           15  (CARRY8=2 DSP_A_B_DATA=1 DSP_ALU=2 DSP_M_DATA=1 DSP_MULTIPLIER=1 DSP_OUTPUT=2 DSP_PREADD_DATA=1 LUT2=1 LUT3=1 LUT4=1 LUT6=2)
  Clock Uncertainty:      0.035ns  ((TSJ^2 + TIJ^2)^1/2 + DJ) / 2 + PE
    Total System Jitter     (TSJ):    0.071ns
    Total Input Jitter      (TIJ):    0.000ns
    Discrete Jitter          (DJ):    0.000ns
    Phase Error              (PE):    0.000ns

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=569, unset)          0.000     0.000    fsm2/clk
                         FDRE                                         r  fsm2/out_reg[0]/C
  -------------------------------------------------------------------    -------------------
                         FDRE (Prop_FDRE_C_Q)         0.093     0.093 f  fsm2/out_reg[0]/Q
                         net (fo=19, unplaced)        0.225     0.318    fsm2/fsm2_out[0]
                         LUT6 (Prop_LUT6_I0_O)        0.179     0.497 f  fsm2/out[1]_i_3/O
                         net (fo=7, unplaced)         0.235     0.732    fsm1/out_reg[0]_4
                         LUT4 (Prop_LUT4_I3_O)        0.085     0.817 r  fsm1/out[31]_i_3/O
                         net (fo=9, unplaced)         0.190     1.007    mul_out/out_reg[31]_0
                         LUT6 (Prop_LUT6_I2_O)        0.100     1.107 f  mul_out/out[31]_i_1__2/O
                         net (fo=127, unplaced)       0.301     1.408    left_1_0/do_mul_go_in
                         LUT2 (Prop_LUT2_I1_O)        0.085     1.493 f  left_1_0/out_i_1__10/O
                         net (fo=2, unplaced)         0.257     1.750    mult0/out__0/B[16]
                         DSP_A_B_DATA (Prop_DSP_A_B_DATA_B[16]_B2_DATA[16])
                                                      0.195     1.945 r  mult0/out__0/DSP_A_B_DATA_INST/B2_DATA[16]
                         net (fo=1, unplaced)         0.000     1.945    mult0/out__0/DSP_A_B_DATA.B2_DATA<16>
                         DSP_PREADD_DATA (Prop_DSP_PREADD_DATA_B2_DATA[16]_B2B1[16])
                                                      0.092     2.037 r  mult0/out__0/DSP_PREADD_DATA_INST/B2B1[16]
                         net (fo=1, unplaced)         0.000     2.037    mult0/out__0/DSP_PREADD_DATA.B2B1<16>
                         DSP_MULTIPLIER (Prop_DSP_MULTIPLIER_B2B1[16]_U[43])
                                                      0.737     2.774 f  mult0/out__0/DSP_MULTIPLIER_INST/U[43]
                         net (fo=1, unplaced)         0.000     2.774    mult0/out__0/DSP_MULTIPLIER.U<43>
                         DSP_M_DATA (Prop_DSP_M_DATA_U[43]_U_DATA[43])
                                                      0.059     2.833 r  mult0/out__0/DSP_M_DATA_INST/U_DATA[43]
                         net (fo=1, unplaced)         0.000     2.833    mult0/out__0/DSP_M_DATA.U_DATA<43>
                         DSP_ALU (Prop_DSP_ALU_U_DATA[43]_ALU_OUT[47])
                                                      0.699     3.532 f  mult0/out__0/DSP_ALU_INST/ALU_OUT[47]
                         net (fo=1, unplaced)         0.000     3.532    mult0/out__0/DSP_ALU.ALU_OUT<47>
                         DSP_OUTPUT (Prop_DSP_OUTPUT_ALU_OUT[47]_PCOUT[47])
                                                      0.159     3.691 r  mult0/out__0/DSP_OUTPUT_INST/PCOUT[47]
                         net (fo=1, unplaced)         0.016     3.707    mult0/out__0__0/PCIN[47]
                         DSP_ALU (Prop_DSP_ALU_PCIN[47]_ALU_OUT[0])
                                                      0.698     4.405 f  mult0/out__0__0/DSP_ALU_INST/ALU_OUT[0]
                         net (fo=1, unplaced)         0.000     4.405    mult0/out__0__0/DSP_ALU.ALU_OUT<0>
                         DSP_OUTPUT (Prop_DSP_OUTPUT_ALU_OUT[0]_P[0])
                                                      0.141     4.546 r  mult0/out__0__0/DSP_OUTPUT_INST/P[0]
                         net (fo=1, unplaced)         0.241     4.787    mult0/out__0__0_n_105
                         LUT3 (Prop_LUT3_I1_O)        0.063     4.850 r  mult0/out[23]_i_15/O
                         net (fo=1, unplaced)         0.025     4.875    mult0/out[23]_i_15_n_0
                         CARRY8 (Prop_CARRY8_S[1]_CO[7])
                                                      0.245     5.120 r  mult0/out_reg[23]_i_1/CO[7]
                         net (fo=1, unplaced)         0.007     5.127    mult0/out_reg[23]_i_1_n_0
                         CARRY8 (Prop_CARRY8_CI_O[7])
                                                      0.146     5.273 r  mult0/out_reg[31]_i_2/O[7]
                         net (fo=1, unplaced)         0.031     5.304    mul_out/out[15]
                         FDRE                                         r  mul_out/out_reg[31]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=569, unset)          0.000     5.000    mul_out/clk
                         FDRE                                         r  mul_out/out_reg[31]/C
                         clock pessimism              0.000     5.000    
                         clock uncertainty           -0.035     4.965    
                         FDRE (Setup_FDRE_C_D)        0.027     4.992    mul_out/out_reg[31]
  -------------------------------------------------------------------
                         required time                          4.992    
                         arrival time                          -5.304    
  -------------------------------------------------------------------
                         slack                                 -0.312    





Min Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             0.077ns  (arrival time - required time)
  Source:                 t1_idx/out_reg[1]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            t1_idx/out_reg[1]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Hold (Min at Fast Process Corner)
  Requirement:            0.000ns  (clk rise@0.000ns - clk rise@0.000ns)
  Data Path Delay:        0.123ns  (logic 0.061ns (49.593%)  route 0.062ns (50.407%))
  Logic Levels:           1  (LUT3=1)

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=569, unset)          0.000     0.000    t1_idx/clk
                         FDRE                                         r  t1_idx/out_reg[1]/C
  -------------------------------------------------------------------    -------------------
                         FDRE (Prop_FDRE_C_Q)         0.038     0.038 r  t1_idx/out_reg[1]/Q
                         net (fo=2, unplaced)         0.046     0.084    t1_idx/t1_idx_out[1]
                         LUT3 (Prop_LUT3_I1_O)        0.023     0.107 r  t1_idx/out[1]_i_2__1/O
                         net (fo=1, unplaced)         0.016     0.123    t1_idx/t1_idx_in[1]
                         FDRE                                         r  t1_idx/out_reg[1]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=569, unset)          0.000     0.000    t1_idx/clk
                         FDRE                                         r  t1_idx/out_reg[1]/C
                         clock pessimism              0.000     0.000    
                         FDRE (Hold_FDRE_C_D)         0.046     0.046    t1_idx/out_reg[1]
  -------------------------------------------------------------------
                         required time                         -0.046    
                         arrival time                           0.123    
  -------------------------------------------------------------------
                         slack                                  0.077    





Pulse Width Checks
--------------------------------------------------------------------------------------
Clock Name:         clk
Waveform(ns):       { 0.000 2.500 }
Period(ns):         5.000
Sources:            { clk }

Check Type        Corner  Lib Pin  Reference Pin  Required(ns)  Actual(ns)  Slack(ns)  Location  Pin
Min Period        n/a     FDRE/C   n/a            0.550         5.000       4.450                acc/done_reg/C
Low Pulse Width   Slow    FDRE/C   n/a            0.275         2.500       2.225                acc/done_reg/C
High Pulse Width  Slow    FDRE/C   n/a            0.275         2.500       2.225                acc/done_reg/C



