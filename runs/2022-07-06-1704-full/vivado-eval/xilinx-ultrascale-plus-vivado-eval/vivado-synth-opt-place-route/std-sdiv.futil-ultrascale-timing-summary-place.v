Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:55:46 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing_summary -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//std-sdiv.futil-ultrascale-timing-summary-place.v
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
      2.479        0.000                      0                  723        0.022        0.000                      0                  723        2.225        0.000                       0                   333  


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
clk                 2.479        0.000                      0                  723        0.022        0.000                      0                  723        2.225        0.000                       0                   333  


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

Setup :            0  Failing Endpoints,  Worst Slack        2.479ns,  Total Violation        0.000ns
Hold  :            0  Failing Endpoints,  Worst Slack        0.022ns,  Total Violation        0.000ns
PW    :            0  Failing Endpoints,  Worst Slack        2.225ns,  Total Violation        0.000ns
---------------------------------------------------------------------------------------------------


Max Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             2.479ns  (required time - arrival time)
  Source:                 fsm/out_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            div/comp/dividend_reg[31]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        2.502ns  (logic 1.085ns (43.365%)  route 1.417ns (56.635%))
  Logic Levels:           7  (CARRY8=4 LUT4=2 LUT6=1)
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
                         net (fo=332, unset)          0.037     0.037    fsm/clk
    SLICE_X31Y71         FDRE                                         r  fsm/out_reg[0]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X31Y71         FDRE (Prop_BFF_SLICEM_C_Q)
                                                      0.095     0.132 f  fsm/out_reg[0]/Q
                         net (fo=96, estimated)       0.504     0.636    fsm/fsm_out[0]
    SLICE_X33Y80         LUT6 (Prop_D6LUT_SLICEL_I2_O)
                                                      0.116     0.752 r  fsm/done_i_23/O
                         net (fo=1, estimated)        0.278     1.030    fsm/done_i_23_n_0
    SLICE_X33Y75         CARRY8 (Prop_CARRY8_SLICEL_S[0]_CO[7])
                                                      0.238     1.268 r  fsm/done_reg_i_11/CO[7]
                         net (fo=1, estimated)        0.028     1.296    fsm/done_reg_i_11_n_0
    SLICE_X33Y76         CARRY8 (Prop_CARRY8_SLICEL_CI_O[7])
                                                      0.146     1.442 r  fsm/dividend_reg[23]_i_26/O[7]
                         net (fo=2, estimated)        0.210     1.652    comb_reg0/left_abs0[15]
    SLICE_X33Y80         LUT4 (Prop_F6LUT_SLICEL_I0_O)
                                                      0.039     1.691 r  comb_reg0/dividend[23]_i_25/O
                         net (fo=1, estimated)        0.324     2.015    div/comp/left_abs[15]
    SLICE_X31Y78         LUT4 (Prop_A6LUT_SLICEM_I1_O)
                                                      0.064     2.079 r  div/comp/dividend[23]_i_17/O
                         net (fo=1, routed)           0.014     2.093    fsm/dividend_reg[23][0]
    SLICE_X31Y78         CARRY8 (Prop_CARRY8_SLICEM_S[0]_CO[7])
                                                      0.241     2.334 r  fsm/dividend_reg[23]_i_1/CO[7]
                         net (fo=1, estimated)        0.028     2.362    fsm/dividend_reg[23]_i_1_n_0
    SLICE_X31Y79         CARRY8 (Prop_CARRY8_SLICEM_CI_O[7])
                                                      0.146     2.508 r  fsm/dividend_reg[31]_i_2/O[7]
                         net (fo=1, routed)           0.031     2.539    div/comp/dividend_reg[31]_1[31]
    SLICE_X31Y79         FDRE                                         r  div/comp/dividend_reg[31]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=332, unset)          0.026     5.026    div/comp/clk
    SLICE_X31Y79         FDRE                                         r  div/comp/dividend_reg[31]/C
                         clock pessimism              0.000     5.026    
                         clock uncertainty           -0.035     4.991    
    SLICE_X31Y79         FDRE (Setup_HFF_SLICEM_C_D)
                                                      0.027     5.018    div/comp/dividend_reg[31]
  -------------------------------------------------------------------
                         required time                          5.018    
                         arrival time                          -2.539    
  -------------------------------------------------------------------
                         slack                                  2.479    





Min Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             0.022ns  (arrival time - required time)
  Source:                 div/comp/quotient_msk_reg[22]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            div/comp/quotient_msk_reg[21]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Hold (Min at Fast Process Corner)
  Requirement:            0.000ns  (clk rise@0.000ns - clk rise@0.000ns)
  Data Path Delay:        0.075ns  (logic 0.039ns (52.000%)  route 0.036ns (48.000%))
  Logic Levels:           0  
  Clock Path Skew:        0.006ns (DCD - SCD - CPR)
    Destination Clock Delay (DCD):    0.018ns
    Source Clock Delay      (SCD):    0.012ns
    Clock Pessimism Removal (CPR):    -0.000ns

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=332, unset)          0.012     0.012    div/comp/clk
    SLICE_X38Y76         FDRE                                         r  div/comp/quotient_msk_reg[22]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X38Y76         FDRE (Prop_DFF_SLICEL_C_Q)
                                                      0.039     0.051 r  div/comp/quotient_msk_reg[22]/Q
                         net (fo=3, estimated)        0.036     0.087    div/comp/quotient_msk[22]
    SLICE_X38Y76         FDRE                                         r  div/comp/quotient_msk_reg[21]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=332, unset)          0.018     0.018    div/comp/clk
    SLICE_X38Y76         FDRE                                         r  div/comp/quotient_msk_reg[21]/C
                         clock pessimism              0.000     0.018    
    SLICE_X38Y76         FDRE (Hold_CFF2_SLICEL_C_D)
                                                      0.047     0.065    div/comp/quotient_msk_reg[21]
  -------------------------------------------------------------------
                         required time                         -0.065    
                         arrival time                           0.087    
  -------------------------------------------------------------------
                         slack                                  0.022    





Pulse Width Checks
--------------------------------------------------------------------------------------
Clock Name:         clk
Waveform(ns):       { 0.000 2.500 }
Period(ns):         5.000
Sources:            { clk }

Check Type        Corner  Lib Pin  Reference Pin  Required(ns)  Actual(ns)  Slack(ns)  Location      Pin
Min Period        n/a     FDRE/C   n/a            0.550         5.000       4.450      SLICE_X31Y71  comb_reg/done_reg/C
Low Pulse Width   Slow    FDRE/C   n/a            0.275         2.500       2.225      SLICE_X31Y71  comb_reg/done_reg/C
High Pulse Width  Slow    FDRE/C   n/a            0.275         2.500       2.225      SLICE_X31Y71  comb_reg/done_reg/C



