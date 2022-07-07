Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:10:20 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing_summary -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//lpm.futil-ultrascale-timing-summary-route.v
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
      0.471        0.000                      0                 1696        0.044        0.000                      0                 1696        2.225        0.000                       0                  1077  


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
clk                 0.471        0.000                      0                 1696        0.044        0.000                      0                 1696        2.225        0.000                       0                  1077  


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

Setup :            0  Failing Endpoints,  Worst Slack        0.471ns,  Total Violation        0.000ns
Hold  :            0  Failing Endpoints,  Worst Slack        0.044ns,  Total Violation        0.000ns
PW    :            0  Failing Endpoints,  Worst Slack        2.225ns,  Total Violation        0.000ns
---------------------------------------------------------------------------------------------------


Max Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             0.471ns  (required time - arrival time)
  Source:                 tcam/pd52/out_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            tcam/me31/r/out_reg[0]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        4.508ns  (logic 1.746ns (38.731%)  route 2.762ns (61.269%))
  Logic Levels:           15  (CARRY8=5 LUT4=3 LUT5=4 LUT6=3)
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
                         net (fo=1076, unset)         0.037     0.037    tcam/pd52/clk
    SLICE_X28Y67         FDRE                                         r  tcam/pd52/out_reg[0]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X28Y67         FDRE (Prop_AFF_SLICEM_C_Q)
                                                      0.093     0.130 f  tcam/pd52/out_reg[0]/Q
                         net (fo=31, routed)          0.185     0.315    tcam/pd51/pd52_out
    SLICE_X27Y66         LUT4 (Prop_A6LUT_SLICEL_I1_O)
                                                      0.149     0.464 r  tcam/pd51/A_LUT_0_i_13__0/O
                         net (fo=1, routed)           0.167     0.631    tcam/pd50/A_LUT_0_i_4__63
    SLICE_X27Y61         LUT5 (Prop_H6LUT_SLICEL_I4_O)
                                                      0.040     0.671 r  tcam/pd50/A_LUT_0_i_8/O
                         net (fo=1, routed)           0.170     0.841    tcam/pd61/out_reg[0]_2
    SLICE_X23Y61         LUT4 (Prop_E6LUT_SLICEL_I2_O)
                                                      0.064     0.905 f  tcam/pd61/A_LUT_0_i_4__63/O
                         net (fo=78, routed)          0.362     1.267    tcam/fsm32/par0_done_in
    SLICE_X24Y53         LUT5 (Prop_G6LUT_SLICEM_I0_O)
                                                      0.039     1.306 r  tcam/fsm32/A_LUT_0_i_3__55/O
                         net (fo=77, routed)          0.462     1.768    tcam/l31/out_reg[0]_6_alias
    SLICE_X26Y42         LUT4 (Prop_H6LUT_SLICEL_I3_O)
                                                      0.100     1.868 r  tcam/l31/B_LUT_1_i_1__61/O
                         net (fo=2, routed)           0.223     2.091    tcam/me31/sub/_impl/B_LUT_1/I1
    SLICE_X26Y40         LUT6 (Prop_B6LUT_SLICEL_I1_O)
                                                      0.149     2.240 r  tcam/me31/sub/_impl/B_LUT_1/LUT6/O
                         net (fo=1, routed)           0.010     2.250    tcam/me31/sub/_impl/luts_O6_1[1]
    SLICE_X26Y40         CARRY8 (Prop_CARRY8_SLICEL_S[1]_O[4])
                                                      0.250     2.500 r  tcam/me31/sub/_impl/carry_8/O[4]
                         net (fo=23, routed)          0.261     2.761    tcam/me31/sub/_impl/sub_out[4]
    SLICE_X26Y35         LUT5 (Prop_D5LUT_SLICEL_I4_O)
                                                      0.164     2.925 r  tcam/me31/sub/_impl/D_LUT_3_i_3__30/O
                         net (fo=8, routed)           0.346     3.271    tcam/me31/sub/_impl/D_LUT_3_i_3__30_n_0
    SLICE_X25Y31         LUT6 (Prop_H6LUT_SLICEL_I1_O)
                                                      0.179     3.450 r  tcam/me31/sub/_impl/D_LUT_3_i_1__62/O
                         net (fo=2, routed)           0.251     3.701    tcam/me31/eq/_impl/D_LUT_3/I0
    SLICE_X24Y30         LUT6 (Prop_D6LUT_SLICEM_I0_O)
                                                      0.174     3.875 r  tcam/me31/eq/_impl/D_LUT_3/LUT6/O
                         net (fo=1, routed)           0.026     3.901    tcam/me31/eq/_impl/luts_O6_1[3]
    SLICE_X24Y30         CARRY8 (Prop_CARRY8_SLICEM_S[3]_CO[7])
                                                      0.206     4.107 r  tcam/me31/eq/_impl/carry_8/CO[7]
                         net (fo=1, routed)           0.028     4.135    tcam/me31/eq/_impl/co_3[7]
    SLICE_X24Y31         CARRY8 (Prop_CARRY8_SLICEM_CI_CO[7])
                                                      0.023     4.158 r  tcam/me31/eq/_impl/carry_17/CO[7]
                         net (fo=1, routed)           0.028     4.186    tcam/me31/eq/_impl/co_7[7]
    SLICE_X24Y32         CARRY8 (Prop_CARRY8_SLICEM_CI_CO[7])
                                                      0.023     4.209 r  tcam/me31/eq/_impl/carry_26/CO[7]
                         net (fo=1, routed)           0.028     4.237    tcam/me31/eq/_impl/co_11[7]
    SLICE_X24Y33         CARRY8 (Prop_CARRY8_SLICEM_CI_CO[7])
                                                      0.030     4.267 r  tcam/me31/eq/_impl/carry_35/CO[7]
                         net (fo=1, routed)           0.157     4.424    tcam/me31/r/out_reg[0]_1
    SLICE_X25Y33         LUT5 (Prop_D6LUT_SLICEL_I0_O)
                                                      0.063     4.487 r  tcam/me31/r/out[0]_i_1__30/O
                         net (fo=1, routed)           0.058     4.545    tcam/me31/r/out[0]_i_1__30_n_0
    SLICE_X25Y33         FDRE                                         r  tcam/me31/r/out_reg[0]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=1076, unset)         0.024     5.024    tcam/me31/r/clk
    SLICE_X25Y33         FDRE                                         r  tcam/me31/r/out_reg[0]/C
                         clock pessimism              0.000     5.024    
                         clock uncertainty           -0.035     4.989    
    SLICE_X25Y33         FDRE (Setup_DFF_SLICEL_C_D)
                                                      0.027     5.016    tcam/me31/r/out_reg[0]
  -------------------------------------------------------------------
                         required time                          5.016    
                         arrival time                          -4.545    
  -------------------------------------------------------------------
                         slack                                  0.471    





Min Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             0.044ns  (arrival time - required time)
  Source:                 tcam/ce16/pd0/out_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            tcam/ce16/pd0/out_reg[0]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Hold (Min at Fast Process Corner)
  Requirement:            0.000ns  (clk rise@0.000ns - clk rise@0.000ns)
  Data Path Delay:        0.096ns  (logic 0.054ns (56.250%)  route 0.042ns (43.750%))
  Logic Levels:           1  (LUT6=1)
  Clock Path Skew:        0.006ns (DCD - SCD - CPR)
    Destination Clock Delay (DCD):    0.018ns
    Source Clock Delay      (SCD):    0.012ns
    Clock Pessimism Removal (CPR):    -0.000ns

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=1076, unset)         0.012     0.012    tcam/ce16/pd0/clk
    SLICE_X30Y81         FDRE                                         r  tcam/ce16/pd0/out_reg[0]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X30Y81         FDRE (Prop_BFF_SLICEL_C_Q)
                                                      0.039     0.051 r  tcam/ce16/pd0/out_reg[0]/Q
                         net (fo=5, routed)           0.027     0.078    tcam/ce16/fsm0/pd0_out
    SLICE_X30Y81         LUT6 (Prop_B6LUT_SLICEL_I4_O)
                                                      0.015     0.093 r  tcam/ce16/fsm0/out[0]_i_1__174/O
                         net (fo=1, routed)           0.015     0.108    tcam/ce16/pd0/out_reg[0]_0
    SLICE_X30Y81         FDRE                                         r  tcam/ce16/pd0/out_reg[0]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=1076, unset)         0.018     0.018    tcam/ce16/pd0/clk
    SLICE_X30Y81         FDRE                                         r  tcam/ce16/pd0/out_reg[0]/C
                         clock pessimism              0.000     0.018    
    SLICE_X30Y81         FDRE (Hold_BFF_SLICEL_C_D)
                                                      0.046     0.064    tcam/ce16/pd0/out_reg[0]
  -------------------------------------------------------------------
                         required time                         -0.064    
                         arrival time                           0.108    
  -------------------------------------------------------------------
                         slack                                  0.044    





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



