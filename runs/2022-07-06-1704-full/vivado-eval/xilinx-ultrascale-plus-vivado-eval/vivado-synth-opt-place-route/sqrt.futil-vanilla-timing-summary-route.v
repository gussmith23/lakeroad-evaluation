Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:59:54 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing_summary -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//sqrt.futil-vanilla-timing-summary-route.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
5. checking no_input_delay (35)
6. checking no_output_delay (34)
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


5. checking no_input_delay (35)
-------------------------------
 There are 35 input ports with no input delay specified. (HIGH)

 There are 0 input ports with no input delay but user has a false path constraint.


6. checking no_output_delay (34)
--------------------------------
 There are 34 ports with no output delay specified. (HIGH)

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
      3.148        0.000                      0                  271        0.026        0.000                      0                  271        2.225        0.000                       0                   169  


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
clk                 3.148        0.000                      0                  271        0.026        0.000                      0                  271        2.225        0.000                       0                   169  


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

Setup :            0  Failing Endpoints,  Worst Slack        3.148ns,  Total Violation        0.000ns
Hold  :            0  Failing Endpoints,  Worst Slack        0.026ns,  Total Violation        0.000ns
PW    :            0  Failing Endpoints,  Worst Slack        2.225ns,  Total Violation        0.000ns
---------------------------------------------------------------------------------------------------


Max Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             3.148ns  (required time - arrival time)
  Source:                 s/comp/quotient_reg[23]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            s/comp/acc_reg[16]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        1.834ns  (logic 0.761ns (41.494%)  route 1.073ns (58.506%))
  Logic Levels:           4  (CARRY8=2 LUT2=1 LUT4=1)
  Clock Path Skew:        -0.010ns (DCD - SCD + CPR)
    Destination Clock Delay (DCD):    0.026ns = ( 5.026 - 5.000 ) 
    Source Clock Delay      (SCD):    0.036ns
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
                         net (fo=168, unset)          0.036     0.036    s/comp/clk
    SLICE_X26Y106        FDRE                                         r  s/comp/quotient_reg[23]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X26Y106        FDRE (Prop_EFF_SLICEL_C_Q)
                                                      0.096     0.132 r  s/comp/quotient_reg[23]/Q
                         net (fo=3, routed)           0.373     0.505    s/comp/quotient[23]
    SLICE_X25Y105        LUT2 (Prop_A6LUT_SLICEL_I1_O)
                                                      0.178     0.683 r  s/comp/quotient_next1_carry_i_8__0/O
                         net (fo=1, routed)           0.011     0.694    s/comp/quotient_next1_carry_i_8__0_n_0
    SLICE_X25Y105        CARRY8 (Prop_CARRY8_SLICEL_S[0]_CO[7])
                                                      0.238     0.932 r  s/comp/quotient_next1_carry__2/CO[7]
                         net (fo=1, routed)           0.028     0.960    s/comp/quotient_next1_carry__2_n_0
    SLICE_X25Y106        CARRY8 (Prop_CARRY8_SLICEL_CI_O[0])
                                                      0.072     1.032 r  s/comp/quotient_next1_carry__3/O[0]
                         net (fo=33, routed)          0.583     1.615    s/comp/p_0_in
    SLICE_X24Y103        LUT4 (Prop_F6LUT_SLICEM_I3_O)
                                                      0.177     1.792 r  s/comp/acc[16]_i_1/O
                         net (fo=1, routed)           0.078     1.870    s/comp/acc[16]_i_1_n_0
    SLICE_X24Y103        FDRE                                         r  s/comp/acc_reg[16]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=168, unset)          0.026     5.026    s/comp/clk
    SLICE_X24Y103        FDRE                                         r  s/comp/acc_reg[16]/C
                         clock pessimism              0.000     5.026    
                         clock uncertainty           -0.035     4.991    
    SLICE_X24Y103        FDRE (Setup_FFF_SLICEM_C_D)
                                                      0.027     5.018    s/comp/acc_reg[16]
  -------------------------------------------------------------------
                         required time                          5.018    
                         arrival time                          -1.870    
  -------------------------------------------------------------------
                         slack                                  3.148    





Min Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             0.026ns  (arrival time - required time)
  Source:                 s/comp/quotient_reg[8]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            s/comp/quotient_reg[9]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Hold (Min at Fast Process Corner)
  Requirement:            0.000ns  (clk rise@0.000ns - clk rise@0.000ns)
  Data Path Delay:        0.079ns  (logic 0.039ns (49.367%)  route 0.040ns (50.633%))
  Logic Levels:           0  
  Clock Path Skew:        0.006ns (DCD - SCD - CPR)
    Destination Clock Delay (DCD):    0.019ns
    Source Clock Delay      (SCD):    0.013ns
    Clock Pessimism Removal (CPR):    -0.000ns

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=168, unset)          0.013     0.013    s/comp/clk
    SLICE_X26Y103        FDRE                                         r  s/comp/quotient_reg[8]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X26Y103        FDRE (Prop_HFF_SLICEL_C_Q)
                                                      0.039     0.052 r  s/comp/quotient_reg[8]/Q
                         net (fo=3, routed)           0.040     0.092    s/comp/quotient[8]
    SLICE_X26Y103        FDRE                                         r  s/comp/quotient_reg[9]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=168, unset)          0.019     0.019    s/comp/clk
    SLICE_X26Y103        FDRE                                         r  s/comp/quotient_reg[9]/C
                         clock pessimism              0.000     0.019    
    SLICE_X26Y103        FDRE (Hold_HFF2_SLICEL_C_D)
                                                      0.047     0.066    s/comp/quotient_reg[9]
  -------------------------------------------------------------------
                         required time                         -0.066    
                         arrival time                           0.092    
  -------------------------------------------------------------------
                         slack                                  0.026    





Pulse Width Checks
--------------------------------------------------------------------------------------
Clock Name:         clk
Waveform(ns):       { 0.000 2.500 }
Period(ns):         5.000
Sources:            { clk }

Check Type        Corner  Lib Pin  Reference Pin  Required(ns)  Actual(ns)  Slack(ns)  Location       Pin
Min Period        n/a     FDRE/C   n/a            0.550         5.000       4.450      SLICE_X27Y106  fsm/out_reg[0]/C
Low Pulse Width   Slow    FDRE/C   n/a            0.275         2.500       2.225      SLICE_X27Y106  fsm/out_reg[0]/C
High Pulse Width  Slow    FDRE/C   n/a            0.275         2.500       2.225      SLICE_X27Y106  fsm/out_reg[0]/C



