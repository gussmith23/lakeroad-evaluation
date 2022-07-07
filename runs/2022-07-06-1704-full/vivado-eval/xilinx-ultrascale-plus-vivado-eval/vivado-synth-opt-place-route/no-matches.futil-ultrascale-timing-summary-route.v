Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:14:13 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing_summary -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//no-matches.futil-ultrascale-timing-summary-route.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
      0.507        0.000                      0                 1607        0.042        0.000                      0                 1607        2.225        0.000                       0                  1027  


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
clk                 0.507        0.000                      0                 1607        0.042        0.000                      0                 1607        2.225        0.000                       0                  1027  


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

Setup :            0  Failing Endpoints,  Worst Slack        0.507ns,  Total Violation        0.000ns
Hold  :            0  Failing Endpoints,  Worst Slack        0.042ns,  Total Violation        0.000ns
PW    :            0  Failing Endpoints,  Worst Slack        2.225ns,  Total Violation        0.000ns
---------------------------------------------------------------------------------------------------


Max Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             0.507ns  (required time - arrival time)
  Source:                 tcam/pd43/out_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            tcam/me18/r/out_reg[0]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        4.473ns  (logic 1.635ns (36.553%)  route 2.838ns (63.447%))
  Logic Levels:           14  (CARRY8=4 LUT4=3 LUT5=3 LUT6=4)
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
                         net (fo=1026, unset)         0.037     0.037    tcam/pd43/clk
    SLICE_X29Y123        FDRE                                         r  tcam/pd43/out_reg[0]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X29Y123        FDRE (Prop_CFF_SLICEM_C_Q)
                                                      0.095     0.132 f  tcam/pd43/out_reg[0]/Q
                         net (fo=10, routed)          0.332     0.464    tcam/pd52/pd43_out
    SLICE_X29Y112        LUT4 (Prop_B6LUT_SLICEM_I2_O)
                                                      0.116     0.580 r  tcam/pd52/A_LUT_0_i_12/O
                         net (fo=1, routed)           0.254     0.834    tcam/pd33/A_LUT_0_i_4__31
    SLICE_X28Y106        LUT5 (Prop_C6LUT_SLICEM_I4_O)
                                                      0.038     0.872 f  tcam/pd33/A_LUT_0_i_7__0/O
                         net (fo=1, routed)           0.171     1.043    tcam/pd49/out_reg[0]_1
    SLICE_X24Y106        LUT4 (Prop_B6LUT_SLICEM_I1_O)
                                                      0.116     1.159 f  tcam/pd49/A_LUT_0_i_4__31/O
                         net (fo=69, routed)          0.137     1.296    tcam/fsm32/A_LUT_0
    SLICE_X25Y106        LUT5 (Prop_C5LUT_SLICEL_I0_O)
                                                      0.083     1.379 f  tcam/fsm32/A_LUT_0_i_3__18/O
                         net (fo=70, routed)          0.702     2.081    tcam/fsm32/out_reg[3]_8
    SLICE_X17Y92         LUT4 (Prop_D6LUT_SLICEL_I0_O)
                                                      0.039     2.120 r  tcam/fsm32/B_LUT_1_i_1__35/O
                         net (fo=2, routed)           0.162     2.282    tcam/me18/sub/_impl/B_LUT_1/I1
    SLICE_X17Y91         LUT6 (Prop_B6LUT_SLICEL_I1_O)
                                                      0.149     2.431 r  tcam/me18/sub/_impl/B_LUT_1/LUT6/O
                         net (fo=1, routed)           0.010     2.441    tcam/me18/sub/_impl/luts_O6_1[1]
    SLICE_X17Y91         CARRY8 (Prop_CARRY8_SLICEL_S[1]_O[4])
                                                      0.250     2.691 f  tcam/me18/sub/_impl/carry_8/O[4]
                         net (fo=19, routed)          0.282     2.973    tcam/fsm33/B_LUT_1_16[0]
    SLICE_X16Y87         LUT6 (Prop_E6LUT_SLICEM_I4_O)
                                                      0.063     3.036 f  tcam/fsm33/B_LUT_1_i_2__17/O
                         net (fo=7, routed)           0.194     3.230    tcam/me18/sub/_impl/B_LUT_1_0
    SLICE_X16Y84         LUT6 (Prop_E6LUT_SLICEM_I4_O)
                                                      0.148     3.378 f  tcam/me18/sub/_impl/D_LUT_12_i_1__17/O
                         net (fo=2, routed)           0.226     3.604    tcam/me18/eq/_impl/D_LUT_12/I0
    SLICE_X17Y85         LUT6 (Prop_D6LUT_SLICEL_I0_O)
                                                      0.174     3.778 r  tcam/me18/eq/_impl/D_LUT_12/LUT6/O
                         net (fo=1, routed)           0.010     3.788    tcam/me18/eq/_impl/luts_O6_5[3]
    SLICE_X17Y85         CARRY8 (Prop_CARRY8_SLICEL_S[3]_CO[7])
                                                      0.195     3.983 r  tcam/me18/eq/_impl/carry_17/CO[7]
                         net (fo=1, routed)           0.028     4.011    tcam/me18/eq/_impl/co_7[7]
    SLICE_X17Y86         CARRY8 (Prop_CARRY8_SLICEL_CI_CO[7])
                                                      0.023     4.034 r  tcam/me18/eq/_impl/carry_26/CO[7]
                         net (fo=1, routed)           0.028     4.062    tcam/me18/eq/_impl/co_11[7]
    SLICE_X17Y87         CARRY8 (Prop_CARRY8_SLICEL_CI_CO[7])
                                                      0.030     4.092 r  tcam/me18/eq/_impl/carry_35/CO[7]
                         net (fo=1, routed)           0.242     4.334    tcam/me18/r/out0
    SLICE_X17Y90         LUT5 (Prop_H6LUT_SLICEL_I0_O)
                                                      0.116     4.450 r  tcam/me18/r/out[0]_i_1__17/O
                         net (fo=1, routed)           0.060     4.510    tcam/me18/r/out[0]_i_1__17_n_0
    SLICE_X17Y90         FDRE                                         r  tcam/me18/r/out_reg[0]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=1026, unset)         0.025     5.025    tcam/me18/r/clk
    SLICE_X17Y90         FDRE                                         r  tcam/me18/r/out_reg[0]/C
                         clock pessimism              0.000     5.025    
                         clock uncertainty           -0.035     4.990    
    SLICE_X17Y90         FDRE (Setup_HFF_SLICEL_C_D)
                                                      0.027     5.017    tcam/me18/r/out_reg[0]
  -------------------------------------------------------------------
                         required time                          5.017    
                         arrival time                          -4.510    
  -------------------------------------------------------------------
                         slack                                  0.507    





Min Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             0.042ns  (arrival time - required time)
  Source:                 tcam/fsm15/out_reg[1]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            tcam/fsm15/out_reg[1]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Hold (Min at Fast Process Corner)
  Requirement:            0.000ns  (clk rise@0.000ns - clk rise@0.000ns)
  Data Path Delay:        0.094ns  (logic 0.054ns (57.447%)  route 0.040ns (42.553%))
  Logic Levels:           1  (LUT6=1)
  Clock Path Skew:        0.006ns (DCD - SCD - CPR)
    Destination Clock Delay (DCD):    0.018ns
    Source Clock Delay      (SCD):    0.012ns
    Clock Pessimism Removal (CPR):    -0.000ns

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=1026, unset)         0.012     0.012    tcam/fsm15/clk
    SLICE_X21Y83         FDRE                                         r  tcam/fsm15/out_reg[1]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X21Y83         FDRE (Prop_BFF_SLICEL_C_Q)
                                                      0.039     0.051 f  tcam/fsm15/out_reg[1]/Q
                         net (fo=7, routed)           0.025     0.076    tcam/fsm15/fsm15_out[1]
    SLICE_X21Y83         LUT6 (Prop_B6LUT_SLICEL_I4_O)
                                                      0.015     0.091 r  tcam/fsm15/out[1]_i_2__14/O
                         net (fo=1, routed)           0.015     0.106    tcam/fsm15/fsm15_in[1]
    SLICE_X21Y83         FDRE                                         r  tcam/fsm15/out_reg[1]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=1026, unset)         0.018     0.018    tcam/fsm15/clk
    SLICE_X21Y83         FDRE                                         r  tcam/fsm15/out_reg[1]/C
                         clock pessimism              0.000     0.018    
    SLICE_X21Y83         FDRE (Hold_BFF_SLICEL_C_D)
                                                      0.046     0.064    tcam/fsm15/out_reg[1]
  -------------------------------------------------------------------
                         required time                         -0.064    
                         arrival time                           0.106    
  -------------------------------------------------------------------
                         slack                                  0.042    





Pulse Width Checks
--------------------------------------------------------------------------------------
Clock Name:         clk
Waveform(ns):       { 0.000 2.500 }
Period(ns):         5.000
Sources:            { clk }

Check Type        Corner  Lib Pin  Reference Pin  Required(ns)  Actual(ns)  Slack(ns)  Location      Pin
Min Period        n/a     FDRE/C   n/a            0.550         5.000       4.450      SLICE_X26Y95  fsm/out_reg[0]/C
Low Pulse Width   Slow    FDRE/C   n/a            0.275         2.500       2.225      SLICE_X26Y95  fsm/out_reg[0]/C
High Pulse Width  Slow    FDRE/C   n/a            0.275         2.500       2.225      SLICE_X26Y95  fsm/out_reg[0]/C



