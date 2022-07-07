Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:30:04 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing_summary -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//inlining.futil-ultrascale-timing-summary-place.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
     -0.139       -1.267                     19                  973        0.027        0.000                      0                  973        2.225        0.000                       0                   570  


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
clk                -0.139       -1.267                     19                  973        0.027        0.000                      0                  973        2.225        0.000                       0                   570  


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

Setup :           19  Failing Endpoints,  Worst Slack       -0.139ns,  Total Violation       -1.267ns
Hold  :            0  Failing Endpoints,  Worst Slack        0.027ns,  Total Violation        0.000ns
PW    :            0  Failing Endpoints,  Worst Slack        2.225ns,  Total Violation        0.000ns
---------------------------------------------------------------------------------------------------


Max Delay Paths
--------------------------------------------------------------------------------------
Slack (VIOLATED) :        -0.139ns  (required time - arrival time)
  Source:                 fsm2/out_reg[3]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            mul_out1/out_reg[31]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        5.120ns  (logic 3.620ns (70.703%)  route 1.500ns (29.297%))
  Logic Levels:           15  (CARRY8=2 DSP_A_B_DATA=1 DSP_ALU=2 DSP_M_DATA=1 DSP_MULTIPLIER=1 DSP_OUTPUT=2 DSP_PREADD_DATA=1 LUT2=1 LUT3=1 LUT4=1 LUT6=2)
  Clock Path Skew:        -0.011ns (DCD - SCD + CPR)
    Destination Clock Delay (DCD):    0.026ns = ( 5.026 - 5.000 ) 
    Source Clock Delay      (SCD):    0.037ns
    Clock Pessimism Removal (CPR):    0.000ns
  Clock Uncertainty:      0.035ns  ((TSJ^2 + TIJ^2)^1/2 + DJ) / 2 + PE
    Total System Jitter     (TSJ):    0.071ns
    Total Input Jitter      (TIJ):    0.000ns
    Discrete Jitter          (DJ):    0.000ns
    Phase Error              (PE):    0.000ns

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=569, unset)          0.037     0.037    fsm2/clk
    SLICE_X24Y82         FDRE                                         r  fsm2/out_reg[3]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X24Y82         FDRE (Prop_HFF2_SLICEM_C_Q)
                                                      0.095     0.132 r  fsm2/out_reg[3]/Q
                         net (fo=32, estimated)       0.193     0.325    fsm2/fsm2_out[3]
    SLICE_X23Y82         LUT6 (Prop_B6LUT_SLICEL_I0_O)
                                                      0.177     0.502 r  fsm2/out[1]_i_5__0/O
                         net (fo=7, estimated)        0.134     0.636    fsm0/out_reg[0]_4
    SLICE_X24Y82         LUT4 (Prop_E6LUT_SLICEM_I2_O)
                                                      0.039     0.675 r  fsm0/out[31]_i_3__2/O
                         net (fo=7, estimated)        0.129     0.804    mul_out1/out_reg[31]_2
    SLICE_X25Y82         LUT6 (Prop_A6LUT_SLICEL_I5_O)
                                                      0.039     0.843 f  mul_out1/out[31]_i_1__4/O
                         net (fo=127, estimated)      0.314     1.157    left_0_1/do_mul1_go_in
    SLICE_X27Y85         LUT2 (Prop_B6LUT_SLICEL_I1_O)
                                                      0.040     1.197 f  left_0_1/out_i_1__7/O
                         net (fo=2, estimated)        0.212     1.409    mult01/out__0/B[16]
    DSP48E2_X2Y35        DSP_A_B_DATA (Prop_DSP_A_B_DATA_DSP48E2_B[16]_B2_DATA[16])
                                                      0.195     1.604 r  mult01/out__0/DSP_A_B_DATA_INST/B2_DATA[16]
                         net (fo=1, routed)           0.000     1.604    mult01/out__0/DSP_A_B_DATA.B2_DATA<16>
    DSP48E2_X2Y35        DSP_PREADD_DATA (Prop_DSP_PREADD_DATA_DSP48E2_B2_DATA[16]_B2B1[16])
                                                      0.092     1.696 r  mult01/out__0/DSP_PREADD_DATA_INST/B2B1[16]
                         net (fo=1, routed)           0.000     1.696    mult01/out__0/DSP_PREADD_DATA.B2B1<16>
    DSP48E2_X2Y35        DSP_MULTIPLIER (Prop_DSP_MULTIPLIER_DSP48E2_B2B1[16]_U[43])
                                                      0.737     2.433 f  mult01/out__0/DSP_MULTIPLIER_INST/U[43]
                         net (fo=1, routed)           0.000     2.433    mult01/out__0/DSP_MULTIPLIER.U<43>
    DSP48E2_X2Y35        DSP_M_DATA (Prop_DSP_M_DATA_DSP48E2_U[43]_U_DATA[43])
                                                      0.059     2.492 r  mult01/out__0/DSP_M_DATA_INST/U_DATA[43]
                         net (fo=1, routed)           0.000     2.492    mult01/out__0/DSP_M_DATA.U_DATA<43>
    DSP48E2_X2Y35        DSP_ALU (Prop_DSP_ALU_DSP48E2_U_DATA[43]_ALU_OUT[47])
                                                      0.699     3.191 f  mult01/out__0/DSP_ALU_INST/ALU_OUT[47]
                         net (fo=1, routed)           0.000     3.191    mult01/out__0/DSP_ALU.ALU_OUT<47>
    DSP48E2_X2Y35        DSP_OUTPUT (Prop_DSP_OUTPUT_DSP48E2_ALU_OUT[47]_PCOUT[47])
                                                      0.159     3.350 r  mult01/out__0/DSP_OUTPUT_INST/PCOUT[47]
                         net (fo=1, estimated)        0.080     3.430    mult01/out__0__0/PCIN[47]
    DSP48E2_X2Y36        DSP_ALU (Prop_DSP_ALU_DSP48E2_PCIN[47]_ALU_OUT[2])
                                                      0.698     4.128 f  mult01/out__0__0/DSP_ALU_INST/ALU_OUT[2]
                         net (fo=1, routed)           0.000     4.128    mult01/out__0__0/DSP_ALU.ALU_OUT<2>
    DSP48E2_X2Y36        DSP_OUTPUT (Prop_DSP_OUTPUT_DSP48E2_ALU_OUT[2]_P[2])
                                                      0.141     4.269 r  mult01/out__0__0/DSP_OUTPUT_INST/P[2]
                         net (fo=1, estimated)        0.321     4.590    mult01/out__0__0_n_103
    SLICE_X29Y89         LUT3 (Prop_D6LUT_SLICEM_I1_O)
                                                      0.098     4.688 r  mult01/out[23]_i_13__1/O
                         net (fo=1, routed)           0.026     4.714    mult01/out[23]_i_13__1_n_0
    SLICE_X29Y89         CARRY8 (Prop_CARRY8_SLICEM_S[3]_CO[7])
                                                      0.206     4.920 r  mult01/out_reg[23]_i_1__1/CO[7]
                         net (fo=1, estimated)        0.060     4.980    mult01/out_reg[23]_i_1__1_n_0
    SLICE_X29Y90         CARRY8 (Prop_CARRY8_SLICEM_CI_O[7])
                                                      0.146     5.126 r  mult01/out_reg[31]_i_2__1/O[7]
                         net (fo=1, routed)           0.031     5.157    mul_out1/out[15]
    SLICE_X29Y90         FDRE                                         r  mul_out1/out_reg[31]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=569, unset)          0.026     5.026    mul_out1/clk
    SLICE_X29Y90         FDRE                                         r  mul_out1/out_reg[31]/C
                         clock pessimism              0.000     5.026    
                         clock uncertainty           -0.035     4.991    
    SLICE_X29Y90         FDRE (Setup_HFF_SLICEM_C_D)
                                                      0.027     5.018    mul_out1/out_reg[31]
  -------------------------------------------------------------------
                         required time                          5.018    
                         arrival time                          -5.157    
  -------------------------------------------------------------------
                         slack                                 -0.139    





Min Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             0.027ns  (arrival time - required time)
  Source:                 top_0_0/out_reg[29]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            top_1_0/out_reg[29]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Hold (Min at Fast Process Corner)
  Requirement:            0.000ns  (clk rise@0.000ns - clk rise@0.000ns)
  Data Path Delay:        0.080ns  (logic 0.037ns (46.250%)  route 0.043ns (53.750%))
  Logic Levels:           0  
  Clock Path Skew:        0.006ns (DCD - SCD - CPR)
    Destination Clock Delay (DCD):    0.019ns
    Source Clock Delay      (SCD):    0.013ns
    Clock Pessimism Removal (CPR):    -0.000ns

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=569, unset)          0.013     0.013    top_0_0/clk
    SLICE_X19Y80         FDRE                                         r  top_0_0/out_reg[29]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X19Y80         FDRE (Prop_FFF_SLICEM_C_Q)
                                                      0.037     0.050 r  top_0_0/out_reg[29]/Q
                         net (fo=2, estimated)        0.043     0.093    top_1_0/D[29]
    SLICE_X19Y80         FDRE                                         r  top_1_0/out_reg[29]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=569, unset)          0.019     0.019    top_1_0/clk
    SLICE_X19Y80         FDRE                                         r  top_1_0/out_reg[29]/C
                         clock pessimism              0.000     0.019    
    SLICE_X19Y80         FDRE (Hold_EFF2_SLICEM_C_D)
                                                      0.047     0.066    top_1_0/out_reg[29]
  -------------------------------------------------------------------
                         required time                         -0.066    
                         arrival time                           0.093    
  -------------------------------------------------------------------
                         slack                                  0.027    





Pulse Width Checks
--------------------------------------------------------------------------------------
Clock Name:         clk
Waveform(ns):       { 0.000 2.500 }
Period(ns):         5.000
Sources:            { clk }

Check Type        Corner  Lib Pin  Reference Pin  Required(ns)  Actual(ns)  Slack(ns)  Location      Pin
Min Period        n/a     FDRE/C   n/a            0.550         5.000       4.450      SLICE_X24Y78  acc/done_reg/C
Low Pulse Width   Slow    FDRE/C   n/a            0.275         2.500       2.225      SLICE_X24Y78  acc/done_reg/C
High Pulse Width  Slow    FDRE/C   n/a            0.275         2.500       2.225      SLICE_X24Y78  acc/done_reg/C



