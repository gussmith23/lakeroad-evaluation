Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:12:02 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing_summary -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//no-matches.futil-vanilla-timing-summary-place.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
      2.884        0.000                      0                  806        0.049        0.000                      0                  806        2.225        0.000                       0                   628  


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
clk                 2.884        0.000                      0                  806        0.049        0.000                      0                  806        2.225        0.000                       0                   628  


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

Setup :            0  Failing Endpoints,  Worst Slack        2.884ns,  Total Violation        0.000ns
Hold  :            0  Failing Endpoints,  Worst Slack        0.049ns,  Total Violation        0.000ns
PW    :            0  Failing Endpoints,  Worst Slack        2.225ns,  Total Violation        0.000ns
---------------------------------------------------------------------------------------------------


Max Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             2.884ns  (required time - arrival time)
  Source:                 tcam/pd81/out_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            tcam/ce10/len/out_reg[4]/CE
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        2.026ns  (logic 0.476ns (23.495%)  route 1.550ns (76.505%))
  Logic Levels:           4  (LUT3=1 LUT4=1 LUT6=2)
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
                         net (fo=627, unset)          0.037     0.037    tcam/pd81/clk
    SLICE_X28Y49         FDRE                                         r  tcam/pd81/out_reg[0]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X28Y49         FDRE (Prop_BFF_SLICEM_C_Q)
                                                      0.095     0.132 f  tcam/pd81/out_reg[0]/Q
                         net (fo=9, estimated)        0.357     0.489    tcam/pd81/pd81_out
    SLICE_X21Y49         LUT4 (Prop_C6LUT_SLICEL_I0_O)
                                                      0.148     0.637 f  tcam/pd81/done_i_4__0/O
                         net (fo=1, estimated)        0.163     0.800    tcam/fsm32/out_reg[0]_18
    SLICE_X21Y50         LUT6 (Prop_F6LUT_SLICEL_I1_O)
                                                      0.114     0.914 f  tcam/fsm32/done_i_2__40/O
                         net (fo=57, estimated)       0.444     1.358    tcam/fsm32/out_reg[0]_3
    SLICE_X23Y40         LUT3 (Prop_D5LUT_SLICEL_I0_O)
                                                      0.080     1.438 r  tcam/fsm32/out[4]_i_3__11/O
                         net (fo=6, estimated)        0.263     1.701    tcam/ce10/fsm/invoke47_go_in
    SLICE_X22Y41         LUT6 (Prop_F6LUT_SLICEL_I2_O)
                                                      0.039     1.740 r  tcam/ce10/fsm/out[4]_i_1__11/O
                         net (fo=4, estimated)        0.323     2.063    tcam/ce10/len/E[0]
    SLICE_X23Y43         FDRE                                         r  tcam/ce10/len/out_reg[4]/CE
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=627, unset)          0.024     5.024    tcam/ce10/len/clk
    SLICE_X23Y43         FDRE                                         r  tcam/ce10/len/out_reg[4]/C
                         clock pessimism              0.000     5.024    
                         clock uncertainty           -0.035     4.989    
    SLICE_X23Y43         FDRE (Setup_DFF2_SLICEL_C_CE)
                                                     -0.042     4.947    tcam/ce10/len/out_reg[4]
  -------------------------------------------------------------------
                         required time                          4.947    
                         arrival time                          -2.063    
  -------------------------------------------------------------------
                         slack                                  2.884    





Min Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             0.049ns  (arrival time - required time)
  Source:                 tcam/zero_index/out_reg[4]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            tcam/zero_index/out_reg[4]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Hold (Min at Fast Process Corner)
  Requirement:            0.000ns  (clk rise@0.000ns - clk rise@0.000ns)
  Data Path Delay:        0.101ns  (logic 0.062ns (61.386%)  route 0.039ns (38.614%))
  Logic Levels:           1  (LUT6=1)
  Clock Path Skew:        0.006ns (DCD - SCD - CPR)
    Destination Clock Delay (DCD):    0.018ns
    Source Clock Delay      (SCD):    0.012ns
    Clock Pessimism Removal (CPR):    -0.000ns

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=627, unset)          0.012     0.012    tcam/zero_index/clk
    SLICE_X22Y53         FDRE                                         r  tcam/zero_index/out_reg[4]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X22Y53         FDRE (Prop_BFF_SLICEL_C_Q)
                                                      0.039     0.051 r  tcam/zero_index/out_reg[4]/Q
                         net (fo=2, estimated)        0.024     0.075    tcam/zero_index/zero_index_out[0]
    SLICE_X22Y53         LUT6 (Prop_B6LUT_SLICEL_I5_O)
                                                      0.023     0.098 r  tcam/zero_index/out[4]_i_1/O
                         net (fo=1, routed)           0.015     0.113    tcam/zero_index/out[4]_i_1_n_0
    SLICE_X22Y53         FDRE                                         r  tcam/zero_index/out_reg[4]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=627, unset)          0.018     0.018    tcam/zero_index/clk
    SLICE_X22Y53         FDRE                                         r  tcam/zero_index/out_reg[4]/C
                         clock pessimism              0.000     0.018    
    SLICE_X22Y53         FDRE (Hold_BFF_SLICEL_C_D)
                                                      0.046     0.064    tcam/zero_index/out_reg[4]
  -------------------------------------------------------------------
                         required time                         -0.064    
                         arrival time                           0.113    
  -------------------------------------------------------------------
                         slack                                  0.049    





Pulse Width Checks
--------------------------------------------------------------------------------------
Clock Name:         clk
Waveform(ns):       { 0.000 2.500 }
Period(ns):         5.000
Sources:            { clk }

Check Type        Corner  Lib Pin  Reference Pin  Required(ns)  Actual(ns)  Slack(ns)  Location      Pin
Min Period        n/a     FDRE/C   n/a            0.550         5.000       4.450      SLICE_X22Y55  fsm/out_reg[0]/C
Low Pulse Width   Slow    FDRE/C   n/a            0.275         2.500       2.225      SLICE_X22Y55  fsm/out_reg[0]/C
High Pulse Width  Slow    FDRE/C   n/a            0.275         2.500       2.225      SLICE_X22Y55  fsm/out_reg[0]/C



