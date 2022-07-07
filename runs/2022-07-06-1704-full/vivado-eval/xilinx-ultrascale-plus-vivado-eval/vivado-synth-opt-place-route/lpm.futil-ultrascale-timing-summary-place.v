Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:10:06 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing_summary -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//lpm.futil-ultrascale-timing-summary-place.v
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
5. checking no_input_delay (3)
6. checking no_output_delay (7)
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


5. checking no_input_delay (3)
------------------------------
 There are 3 input ports with no input delay specified. (HIGH)

 There are 0 input ports with no input delay but user has a false path constraint.


6. checking no_output_delay (7)
-------------------------------
 There are 7 ports with no output delay specified. (HIGH)

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
      0.521        0.000                      0                 1696        0.057        0.000                      0                 1696        2.225        0.000                       0                  1077  


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
clk                 0.521        0.000                      0                 1696        0.057        0.000                      0                 1696        2.225        0.000                       0                  1077  


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

Setup :            0  Failing Endpoints,  Worst Slack        0.521ns,  Total Violation        0.000ns
Hold  :            0  Failing Endpoints,  Worst Slack        0.057ns,  Total Violation        0.000ns
PW    :            0  Failing Endpoints,  Worst Slack        2.225ns,  Total Violation        0.000ns
---------------------------------------------------------------------------------------------------


Max Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             0.521ns  (required time - arrival time)
  Source:                 tcam/pd55/out_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            tcam/me7/r/out_reg[0]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        4.458ns  (logic 1.526ns (34.231%)  route 2.932ns (65.769%))
  Logic Levels:           15  (CARRY8=5 LUT4=3 LUT5=5 LUT6=2)
  Clock Path Skew:        -0.013ns (DCD - SCD + CPR)
    Destination Clock Delay (DCD):    0.024ns = ( 5.024 - 5.000 ) 
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
                         net (fo=1076, unset)         0.037     0.037    tcam/pd55/clk
    SLICE_X24Y71         FDRE                                         r  tcam/pd55/out_reg[0]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X24Y71         FDRE (Prop_DFF_SLICEM_C_Q)
                                                      0.096     0.133 r  tcam/pd55/out_reg[0]/Q
                         net (fo=31, estimated)       0.401     0.534    tcam/pd55/pd55_out
    SLICE_X23Y61         LUT4 (Prop_A6LUT_SLICEL_I0_O)
                                                      0.115     0.649 r  tcam/pd55/A_LUT_0_i_12__0/O
                         net (fo=1, estimated)        0.061     0.710    tcam/pd36/A_LUT_0_i_4__63
    SLICE_X23Y60         LUT5 (Prop_H6LUT_SLICEL_I4_O)
                                                      0.040     0.750 r  tcam/pd36/A_LUT_0_i_7__0/O
                         net (fo=1, estimated)        0.103     0.853    tcam/pd61/out_reg[0]_1
    SLICE_X23Y61         LUT4 (Prop_E6LUT_SLICEL_I1_O)
                                                      0.100     0.953 r  tcam/pd61/A_LUT_0_i_4__63/O
                         net (fo=78, estimated)       0.249     1.202    tcam/fsm32/par0_done_in
    SLICE_X26Y61         LUT5 (Prop_A5LUT_SLICEL_I0_O)
                                                      0.085     1.287 f  tcam/fsm32/A_LUT_0_i_5__4/O
                         net (fo=94, estimated)       0.526     1.813    tcam/l7/out_reg[0]_8_alias
    SLICE_X17Y58         LUT4 (Prop_C6LUT_SLICEL_I3_O)
                                                      0.063     1.876 f  tcam/l7/D_LUT_3_i_1__13/O
                         net (fo=2, estimated)        0.267     2.143    tcam/me7/sub/_impl/D_LUT_3/I1
    SLICE_X18Y58         LUT5 (Prop_D5LUT_SLICEL_I1_O)
                                                      0.164     2.307 r  tcam/me7/sub/_impl/D_LUT_3/LUT5/O
                         net (fo=1, routed)           0.000     2.307    tcam/me7/sub/_impl/luts_O5_0[3]
    SLICE_X18Y58         CARRY8 (Prop_CARRY8_SLICEL_DI[3]_O[4])
                                                      0.177     2.484 r  tcam/me7/sub/_impl/carry_8/O[4]
                         net (fo=23, estimated)       0.405     2.889    tcam/me7/sub/_impl/sub_out[4]
    SLICE_X20Y55         LUT5 (Prop_C5LUT_SLICEM_I4_O)
                                                      0.084     2.973 r  tcam/me7/sub/_impl/D_LUT_3_i_3__6/O
                         net (fo=8, estimated)        0.341     3.314    tcam/me7/sub/_impl/D_LUT_3_i_3__6_n_0
    SLICE_X18Y55         LUT6 (Prop_B6LUT_SLICEL_I0_O)
                                                      0.115     3.429 r  tcam/me7/sub/_impl/F_LUT_5_i_1__6/O
                         net (fo=2, estimated)        0.186     3.615    tcam/me7/eq/_impl/F_LUT_5/I0
    SLICE_X19Y55         LUT6 (Prop_F6LUT_SLICEM_I0_O)
                                                      0.177     3.792 r  tcam/me7/eq/_impl/F_LUT_5/LUT6/O
                         net (fo=1, routed)           0.024     3.816    tcam/me7/eq/_impl/luts_O6_1[5]
    SLICE_X19Y55         CARRY8 (Prop_CARRY8_SLICEM_S[5]_CO[7])
                                                      0.202     4.018 r  tcam/me7/eq/_impl/carry_8/CO[7]
                         net (fo=1, estimated)        0.028     4.046    tcam/me7/eq/_impl/co_3[7]
    SLICE_X19Y56         CARRY8 (Prop_CARRY8_SLICEM_CI_CO[7])
                                                      0.023     4.069 r  tcam/me7/eq/_impl/carry_17/CO[7]
                         net (fo=1, estimated)        0.028     4.097    tcam/me7/eq/_impl/co_7[7]
    SLICE_X19Y57         CARRY8 (Prop_CARRY8_SLICEM_CI_CO[7])
                                                      0.023     4.120 r  tcam/me7/eq/_impl/carry_26/CO[7]
                         net (fo=1, estimated)        0.028     4.148    tcam/me7/eq/_impl/co_11[7]
    SLICE_X19Y58         CARRY8 (Prop_CARRY8_SLICEM_CI_CO[7])
                                                      0.023     4.171 r  tcam/me7/eq/_impl/carry_35/CO[7]
                         net (fo=1, estimated)        0.227     4.398    tcam/me7/r/out_reg[0]_1
    SLICE_X18Y59         LUT5 (Prop_A6LUT_SLICEL_I0_O)
                                                      0.039     4.437 r  tcam/me7/r/out[0]_i_1__6/O
                         net (fo=1, routed)           0.058     4.495    tcam/me7/r/out[0]_i_1__6_n_0
    SLICE_X18Y59         FDRE                                         r  tcam/me7/r/out_reg[0]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=1076, unset)         0.024     5.024    tcam/me7/r/clk
    SLICE_X18Y59         FDRE                                         r  tcam/me7/r/out_reg[0]/C
                         clock pessimism              0.000     5.024    
                         clock uncertainty           -0.035     4.989    
    SLICE_X18Y59         FDRE (Setup_AFF_SLICEL_C_D)
                                                      0.027     5.016    tcam/me7/r/out_reg[0]
  -------------------------------------------------------------------
                         required time                          5.016    
                         arrival time                          -4.495    
  -------------------------------------------------------------------
                         slack                                  0.521    





Min Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             0.057ns  (arrival time - required time)
  Source:                 tcam/fsm22/out_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            tcam/fsm22/out_reg[1]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Hold (Min at Fast Process Corner)
  Requirement:            0.000ns  (clk rise@0.000ns - clk rise@0.000ns)
  Data Path Delay:        0.109ns  (logic 0.061ns (55.963%)  route 0.048ns (44.037%))
  Logic Levels:           1  (LUT6=1)
  Clock Path Skew:        0.006ns (DCD - SCD - CPR)
    Destination Clock Delay (DCD):    0.019ns
    Source Clock Delay      (SCD):    0.013ns
    Clock Pessimism Removal (CPR):    -0.000ns

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=1076, unset)         0.013     0.013    tcam/fsm22/clk
    SLICE_X36Y60         FDRE                                         r  tcam/fsm22/out_reg[0]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X36Y60         FDRE (Prop_HFF_SLICEL_C_Q)
                                                      0.039     0.052 r  tcam/fsm22/out_reg[0]/Q
                         net (fo=5, estimated)        0.032     0.084    tcam/fsm22/fsm22_out[0]
    SLICE_X36Y60         LUT6 (Prop_G6LUT_SLICEL_I5_O)
                                                      0.022     0.106 r  tcam/fsm22/out[1]_i_2__29/O
                         net (fo=1, routed)           0.016     0.122    tcam/fsm22/fsm22_in[1]
    SLICE_X36Y60         FDRE                                         r  tcam/fsm22/out_reg[1]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=1076, unset)         0.019     0.019    tcam/fsm22/clk
    SLICE_X36Y60         FDRE                                         r  tcam/fsm22/out_reg[1]/C
                         clock pessimism              0.000     0.019    
    SLICE_X36Y60         FDRE (Hold_GFF_SLICEL_C_D)
                                                      0.046     0.065    tcam/fsm22/out_reg[1]
  -------------------------------------------------------------------
                         required time                         -0.065    
                         arrival time                           0.122    
  -------------------------------------------------------------------
                         slack                                  0.057    





Pulse Width Checks
--------------------------------------------------------------------------------------
Clock Name:         clk
Waveform(ns):       { 0.000 2.500 }
Period(ns):         5.000
Sources:            { clk }

Check Type        Corner  Lib Pin  Reference Pin  Required(ns)  Actual(ns)  Slack(ns)  Location      Pin
Min Period        n/a     FDRE/C   n/a            0.550         5.000       4.450      SLICE_X28Y57  fsm/out_reg[0]/C
Low Pulse Width   Slow    FDRE/C   n/a            0.275         2.500       2.225      SLICE_X28Y57  fsm/out_reg[0]/C
High Pulse Width  Slow    FDRE/C   n/a            0.275         2.500       2.225      SLICE_X28Y57  fsm/out_reg[0]/C



