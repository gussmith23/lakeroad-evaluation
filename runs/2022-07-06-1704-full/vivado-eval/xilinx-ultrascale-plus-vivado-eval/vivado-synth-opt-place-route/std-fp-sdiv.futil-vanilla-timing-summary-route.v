Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:36:34 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing_summary -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//std-fp-sdiv.futil-vanilla-timing-summary-route.v
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
5. checking no_input_delay (68)
6. checking no_output_delay (79)
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


5. checking no_input_delay (68)
-------------------------------
 There are 68 input ports with no input delay specified. (HIGH)

 There are 0 input ports with no input delay but user has a false path constraint.


6. checking no_output_delay (79)
--------------------------------
 There are 79 ports with no output delay specified. (HIGH)

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
      1.406        0.000                      0                  420        0.043        0.000                      0                  420        2.225        0.000                       0                   245  


All user specified timing constraints are met.


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
clk                 1.406        0.000                      0                  420        0.043        0.000                      0                  420        2.225        0.000                       0                   245  


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

Setup :            0  Failing Endpoints,  Worst Slack        1.406ns,  Total Violation        0.000ns
Hold  :            0  Failing Endpoints,  Worst Slack        0.043ns,  Total Violation        0.000ns
PW    :            0  Failing Endpoints,  Worst Slack        2.225ns,  Total Violation        0.000ns
---------------------------------------------------------------------------------------------------


Max Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             1.406ns  (required time - arrival time)
  Source:                 fsm/out_reg[2]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            div/comp/out_remainder_reg[13]/CE
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        3.504ns  (logic 0.972ns (27.740%)  route 2.532ns (72.260%))
  Logic Levels:           8  (CARRY8=4 LUT4=3 LUT6=1)
  Clock Path Skew:        -0.012ns (DCD - SCD + CPR)
    Destination Clock Delay (DCD):    0.025ns = ( 5.025 - 5.000 ) 
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
                         net (fo=244, unset)          0.037     0.037    fsm/clk
    SLICE_X29Y81         FDRE                                         r  fsm/out_reg[2]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X29Y81         FDRE (Prop_CFF2_SLICEM_C_Q)
                                                      0.094     0.131 r  fsm/out_reg[2]/Q
                         net (fo=88, routed)          0.703     0.834    fsm/fsm_out[2]
    SLICE_X21Y77         LUT6 (Prop_H6LUT_SLICEL_I3_O)
                                                      0.064     0.898 r  fsm/right_save[8]_i_11/O
                         net (fo=1, routed)           0.268     1.166    fsm/right_save[8]_i_11_n_0
    SLICE_X21Y78         CARRY8 (Prop_CARRY8_SLICEL_S[0]_CO[7])
                                                      0.238     1.404 r  fsm/right_save_reg[8]_i_2/CO[7]
                         net (fo=1, routed)           0.028     1.432    fsm/right_save_reg[8]_i_2_n_0
    SLICE_X21Y79         CARRY8 (Prop_CARRY8_SLICEL_CI_CO[7])
                                                      0.023     1.455 r  fsm/right_save_reg[16]_i_2/CO[7]
                         net (fo=1, routed)           0.028     1.483    fsm/right_save_reg[16]_i_2_n_0
    SLICE_X21Y80         CARRY8 (Prop_CARRY8_SLICEL_CI_O[0])
                                                      0.072     1.555 f  fsm/right_save_reg[24]_i_2/O[0]
                         net (fo=5, routed)           0.275     1.830    comb_reg1/right_abs0[16]
    SLICE_X24Y81         LUT4 (Prop_D5LUT_SLICEM_I0_O)
                                                      0.120     1.950 f  comb_reg1/right_save[17]_i_1/O
                         net (fo=3, routed)           0.174     2.124    div/comp/D[17]
    SLICE_X24Y82         LUT4 (Prop_F6LUT_SLICEM_I1_O)
                                                      0.148     2.272 r  div/comp/i__carry__0_i_8/O
                         net (fo=1, routed)           0.257     2.529    div/comp/i__carry__0_i_8_n_0
    SLICE_X23Y82         CARRY8 (Prop_CARRY8_SLICEL_DI[0]_CO[7])
                                                      0.174     2.703 r  div/comp/out_remainder0_inferred__0/i__carry__0/CO[7]
                         net (fo=1, routed)           0.355     3.058    div/comp/out_remainder0_inferred__0/i__carry__0_n_0
    SLICE_X28Y79         LUT4 (Prop_E6LUT_SLICEM_I1_O)
                                                      0.039     3.097 r  div/comp/out_remainder[31]_i_1/O
                         net (fo=32, routed)          0.444     3.541    div/comp/out_remainder[31]_i_1_n_0
    SLICE_X27Y76         FDRE                                         r  div/comp/out_remainder_reg[13]/CE
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=244, unset)          0.025     5.025    div/comp/clk
    SLICE_X27Y76         FDRE                                         r  div/comp/out_remainder_reg[13]/C
                         clock pessimism              0.000     5.025    
                         clock uncertainty           -0.035     4.990    
    SLICE_X27Y76         FDRE (Setup_HFF_SLICEL_C_CE)
                                                     -0.043     4.947    div/comp/out_remainder_reg[13]
  -------------------------------------------------------------------
                         required time                          4.947    
                         arrival time                          -3.541    
  -------------------------------------------------------------------
                         slack                                  1.406    





Min Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             0.043ns  (arrival time - required time)
  Source:                 div/comp/acc_reg[3]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            div/comp/acc_reg[4]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Hold (Min at Fast Process Corner)
  Requirement:            0.000ns  (clk rise@0.000ns - clk rise@0.000ns)
  Data Path Delay:        0.096ns  (logic 0.059ns (61.458%)  route 0.037ns (38.542%))
  Logic Levels:           1  (LUT3=1)
  Clock Path Skew:        0.006ns (DCD - SCD - CPR)
    Destination Clock Delay (DCD):    0.018ns
    Source Clock Delay      (SCD):    0.012ns
    Clock Pessimism Removal (CPR):    -0.000ns

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=244, unset)          0.012     0.012    div/comp/clk
    SLICE_X22Y77         FDRE                                         r  div/comp/acc_reg[3]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X22Y77         FDRE (Prop_AFF_SLICEL_C_Q)
                                                      0.039     0.051 r  div/comp/acc_reg[3]/Q
                         net (fo=5, routed)           0.030     0.081    div/comp/acc_reg[31]_0[3]
    SLICE_X22Y77         LUT3 (Prop_A5LUT_SLICEL_I0_O)
                                                      0.020     0.101 r  div/comp/acc[4]_i_1/O
                         net (fo=1, routed)           0.007     0.108    div/comp/acc[4]_i_1_n_0
    SLICE_X22Y77         FDRE                                         r  div/comp/acc_reg[4]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=244, unset)          0.018     0.018    div/comp/clk
    SLICE_X22Y77         FDRE                                         r  div/comp/acc_reg[4]/C
                         clock pessimism              0.000     0.018    
    SLICE_X22Y77         FDRE (Hold_AFF2_SLICEL_C_D)
                                                      0.047     0.065    div/comp/acc_reg[4]
  -------------------------------------------------------------------
                         required time                         -0.065    
                         arrival time                           0.108    
  -------------------------------------------------------------------
                         slack                                  0.043    





Pulse Width Checks
--------------------------------------------------------------------------------------
Clock Name:         clk
Waveform(ns):       { 0.000 2.500 }
Period(ns):         5.000
Sources:            { clk }

Check Type        Corner  Lib Pin  Reference Pin  Required(ns)  Actual(ns)  Slack(ns)  Location      Pin
Min Period        n/a     FDRE/C   n/a            0.550         5.000       4.450      SLICE_X29Y81  comb_reg/done_reg/C
Low Pulse Width   Slow    FDRE/C   n/a            0.275         2.500       2.225      SLICE_X29Y81  comb_reg/done_reg/C
High Pulse Width  Slow    FDRE/C   n/a            0.275         2.500       2.225      SLICE_X29Y81  comb_reg/done_reg/C



