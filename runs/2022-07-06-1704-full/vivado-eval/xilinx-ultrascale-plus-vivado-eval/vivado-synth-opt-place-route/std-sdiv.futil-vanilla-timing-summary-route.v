Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:54:31 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing_summary -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//std-sdiv.futil-vanilla-timing-summary-route.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
      2.367        0.000                      0                  723        0.042        0.000                      0                  723        2.225        0.000                       0                   333  


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
clk                 2.367        0.000                      0                  723        0.042        0.000                      0                  723        2.225        0.000                       0                   333  


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

Setup :            0  Failing Endpoints,  Worst Slack        2.367ns,  Total Violation        0.000ns
Hold  :            0  Failing Endpoints,  Worst Slack        0.042ns,  Total Violation        0.000ns
PW    :            0  Failing Endpoints,  Worst Slack        2.225ns,  Total Violation        0.000ns
---------------------------------------------------------------------------------------------------


Max Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             2.367ns  (required time - arrival time)
  Source:                 div/comp/done_reg/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            div/comp/dividend_reg[31]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        2.615ns  (logic 1.205ns (46.080%)  route 1.410ns (53.920%))
  Logic Levels:           8  (CARRY8=5 LUT4=2 LUT6=1)
  Clock Path Skew:        -0.010ns (DCD - SCD + CPR)
    Destination Clock Delay (DCD):    0.025ns = ( 5.025 - 5.000 ) 
    Source Clock Delay      (SCD):    0.035ns
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
                         net (fo=332, unset)          0.035     0.035    div/comp/clk
    SLICE_X21Y91         FDRE                                         r  div/comp/done_reg/C
  -------------------------------------------------------------------    -------------------
    SLICE_X21Y91         FDRE (Prop_CFF_SLICEL_C_Q)
                                                      0.097     0.132 r  div/comp/done_reg/Q
                         net (fo=70, routed)          0.240     0.372    fsm/div_done
    SLICE_X22Y89         LUT6 (Prop_H6LUT_SLICEL_I0_O)
                                                      0.179     0.551 r  fsm/dividend[15]_i_35/O
                         net (fo=1, routed)           0.463     1.014    fsm/dividend[15]_i_35_n_0
    SLICE_X22Y90         CARRY8 (Prop_CARRY8_SLICEL_S[0]_CO[7])
                                                      0.238     1.252 r  fsm/dividend_reg[15]_i_26/CO[7]
                         net (fo=1, routed)           0.028     1.280    fsm/dividend_reg[15]_i_26_n_0
    SLICE_X22Y91         CARRY8 (Prop_CARRY8_SLICEL_CI_O[1])
                                                      0.097     1.377 r  fsm/dividend_reg[23]_i_26/O[1]
                         net (fo=2, routed)           0.354     1.731    comb_reg0/left_abs0[9]
    SLICE_X23Y89         LUT4 (Prop_H6LUT_SLICEL_I0_O)
                                                      0.116     1.847 r  comb_reg0/dividend[15]_i_23/O
                         net (fo=1, routed)           0.227     2.074    div/comp/left_abs[9]
    SLICE_X23Y93         LUT4 (Prop_C6LUT_SLICEL_I1_O)
                                                      0.113     2.187 r  div/comp/dividend[15]_i_15/O
                         net (fo=1, routed)           0.011     2.198    fsm/dividend_reg[15][2]
    SLICE_X23Y93         CARRY8 (Prop_CARRY8_SLICEL_S[2]_CO[7])
                                                      0.196     2.394 r  fsm/dividend_reg[15]_i_1/CO[7]
                         net (fo=1, routed)           0.028     2.422    fsm/dividend_reg[15]_i_1_n_0
    SLICE_X23Y94         CARRY8 (Prop_CARRY8_SLICEL_CI_CO[7])
                                                      0.023     2.445 r  fsm/dividend_reg[23]_i_1/CO[7]
                         net (fo=1, routed)           0.028     2.473    fsm/dividend_reg[23]_i_1_n_0
    SLICE_X23Y95         CARRY8 (Prop_CARRY8_SLICEL_CI_O[7])
                                                      0.146     2.619 r  fsm/dividend_reg[31]_i_2/O[7]
                         net (fo=1, routed)           0.031     2.650    div/comp/dividend_reg[31]_1[31]
    SLICE_X23Y95         FDRE                                         r  div/comp/dividend_reg[31]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=332, unset)          0.025     5.025    div/comp/clk
    SLICE_X23Y95         FDRE                                         r  div/comp/dividend_reg[31]/C
                         clock pessimism              0.000     5.025    
                         clock uncertainty           -0.035     4.990    
    SLICE_X23Y95         FDRE (Setup_HFF_SLICEL_C_D)
                                                      0.027     5.017    div/comp/dividend_reg[31]
  -------------------------------------------------------------------
                         required time                          5.017    
                         arrival time                          -2.650    
  -------------------------------------------------------------------
                         slack                                  2.367    





Min Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             0.042ns  (arrival time - required time)
  Source:                 div/comp/divisor_reg[25]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            div/comp/divisor_reg[24]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Hold (Min at Fast Process Corner)
  Requirement:            0.000ns  (clk rise@0.000ns - clk rise@0.000ns)
  Data Path Delay:        0.095ns  (logic 0.060ns (63.158%)  route 0.035ns (36.842%))
  Logic Levels:           1  (LUT2=1)
  Clock Path Skew:        0.006ns (DCD - SCD - CPR)
    Destination Clock Delay (DCD):    0.018ns
    Source Clock Delay      (SCD):    0.012ns
    Clock Pessimism Removal (CPR):    -0.000ns

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=332, unset)          0.012     0.012    div/comp/clk
    SLICE_X22Y95         FDRE                                         r  div/comp/divisor_reg[25]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X22Y95         FDRE (Prop_AFF_SLICEL_C_Q)
                                                      0.039     0.051 r  div/comp/divisor_reg[25]/Q
                         net (fo=5, routed)           0.028     0.079    div/comp/Q[25]
    SLICE_X22Y95         LUT2 (Prop_B5LUT_SLICEL_I0_O)
                                                      0.021     0.100 r  div/comp/divisor[24]_i_1/O
                         net (fo=1, routed)           0.007     0.107    div/comp/divisor[24]_i_1_n_0
    SLICE_X22Y95         FDRE                                         r  div/comp/divisor_reg[24]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=332, unset)          0.018     0.018    div/comp/clk
    SLICE_X22Y95         FDRE                                         r  div/comp/divisor_reg[24]/C
                         clock pessimism              0.000     0.018    
    SLICE_X22Y95         FDRE (Hold_BFF2_SLICEL_C_D)
                                                      0.047     0.065    div/comp/divisor_reg[24]
  -------------------------------------------------------------------
                         required time                         -0.065    
                         arrival time                           0.107    
  -------------------------------------------------------------------
                         slack                                  0.042    





Pulse Width Checks
--------------------------------------------------------------------------------------
Clock Name:         clk
Waveform(ns):       { 0.000 2.500 }
Period(ns):         5.000
Sources:            { clk }

Check Type        Corner  Lib Pin  Reference Pin  Required(ns)  Actual(ns)  Slack(ns)  Location      Pin
Min Period        n/a     FDRE/C   n/a            0.550         5.000       4.450      SLICE_X24Y88  comb_reg/done_reg/C
Low Pulse Width   Slow    FDRE/C   n/a            0.275         2.500       2.225      SLICE_X24Y88  comb_reg/done_reg/C
High Pulse Width  Slow    FDRE/C   n/a            0.275         2.500       2.225      SLICE_X24Y88  comb_reg/done_reg/C



