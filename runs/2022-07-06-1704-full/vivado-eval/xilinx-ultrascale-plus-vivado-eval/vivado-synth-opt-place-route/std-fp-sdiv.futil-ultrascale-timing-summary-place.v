Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:37:49 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing_summary -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//std-fp-sdiv.futil-ultrascale-timing-summary-place.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
      1.392        0.000                      0                  420        0.041        0.000                      0                  420        2.225        0.000                       0                   245  


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
clk                 1.392        0.000                      0                  420        0.041        0.000                      0                  420        2.225        0.000                       0                   245  


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

Setup :            0  Failing Endpoints,  Worst Slack        1.392ns,  Total Violation        0.000ns
Hold  :            0  Failing Endpoints,  Worst Slack        0.041ns,  Total Violation        0.000ns
PW    :            0  Failing Endpoints,  Worst Slack        2.225ns,  Total Violation        0.000ns
---------------------------------------------------------------------------------------------------


Max Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             1.392ns  (required time - arrival time)
  Source:                 fsm/out_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            div/comp/out_remainder_reg[24]/CE
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        3.519ns  (logic 0.901ns (25.604%)  route 2.618ns (74.396%))
  Logic Levels:           8  (CARRY8=4 LUT4=3 LUT6=1)
  Clock Path Skew:        -0.011ns (DCD - SCD + CPR)
    Destination Clock Delay (DCD):    0.025ns = ( 5.025 - 5.000 ) 
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
                         net (fo=244, unset)          0.036     0.036    fsm/clk
    SLICE_X15Y43         FDRE                                         r  fsm/out_reg[0]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X15Y43         FDRE (Prop_FFF_SLICEL_C_Q)
                                                      0.096     0.132 f  fsm/out_reg[0]/Q
                         net (fo=96, estimated)       0.544     0.676    fsm/fsm_out[0]
    SLICE_X19Y34         LUT6 (Prop_H6LUT_SLICEM_I2_O)
                                                      0.117     0.793 r  fsm/right_save[8]_i_11/O
                         net (fo=1, estimated)        0.258     1.051    fsm/right_save[8]_i_11_n_0
    SLICE_X18Y34         CARRY8 (Prop_CARRY8_SLICEL_S[0]_CO[7])
                                                      0.238     1.289 r  fsm/right_save_reg[8]_i_2/CO[7]
                         net (fo=1, estimated)        0.028     1.317    fsm/right_save_reg[8]_i_2_n_0
    SLICE_X18Y35         CARRY8 (Prop_CARRY8_SLICEL_CI_CO[7])
                                                      0.023     1.340 r  fsm/right_save_reg[16]_i_2/CO[7]
                         net (fo=1, estimated)        0.028     1.368    fsm/right_save_reg[16]_i_2_n_0
    SLICE_X18Y36         CARRY8 (Prop_CARRY8_SLICEL_CI_O[2])
                                                      0.086     1.454 f  fsm/right_save_reg[24]_i_2/O[2]
                         net (fo=5, estimated)        0.419     1.873    comb_reg1/right_abs0[18]
    SLICE_X15Y40         LUT4 (Prop_B5LUT_SLICEL_I0_O)
                                                      0.089     1.962 f  comb_reg1/right_save[19]_i_1/O
                         net (fo=3, estimated)        0.272     2.234    div/comp/D[19]
    SLICE_X15Y40         LUT4 (Prop_G6LUT_SLICEL_I1_O)
                                                      0.063     2.297 r  div/comp/i__carry__0_i_7/O
                         net (fo=1, estimated)        0.245     2.542    div/comp/i__carry__0_i_7_n_0
    SLICE_X17Y40         CARRY8 (Prop_CARRY8_SLICEL_DI[1]_CO[7])
                                                      0.150     2.692 r  div/comp/out_remainder0_inferred__0/i__carry__0/CO[7]
                         net (fo=1, estimated)        0.380     3.072    div/comp/out_remainder0_inferred__0/i__carry__0_n_0
    SLICE_X19Y37         LUT4 (Prop_E6LUT_SLICEM_I1_O)
                                                      0.039     3.111 r  div/comp/out_remainder[31]_i_1/O
                         net (fo=32, estimated)       0.444     3.555    div/comp/out_remainder[31]_i_1_n_0
    SLICE_X22Y41         FDRE                                         r  div/comp/out_remainder_reg[24]/CE
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=244, unset)          0.025     5.025    div/comp/clk
    SLICE_X22Y41         FDRE                                         r  div/comp/out_remainder_reg[24]/C
                         clock pessimism              0.000     5.025    
                         clock uncertainty           -0.035     4.990    
    SLICE_X22Y41         FDRE (Setup_HFF_SLICEL_C_CE)
                                                     -0.043     4.947    div/comp/out_remainder_reg[24]
  -------------------------------------------------------------------
                         required time                          4.947    
                         arrival time                          -3.555    
  -------------------------------------------------------------------
                         slack                                  1.392    





Min Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             0.041ns  (arrival time - required time)
  Source:                 div/comp/quotient_reg[23]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            div/comp/out_quotient_reg[24]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Hold (Min at Fast Process Corner)
  Requirement:            0.000ns  (clk rise@0.000ns - clk rise@0.000ns)
  Data Path Delay:        0.094ns  (logic 0.039ns (41.489%)  route 0.055ns (58.511%))
  Logic Levels:           0  
  Clock Path Skew:        0.006ns (DCD - SCD - CPR)
    Destination Clock Delay (DCD):    0.019ns
    Source Clock Delay      (SCD):    0.013ns
    Clock Pessimism Removal (CPR):    -0.000ns

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=244, unset)          0.013     0.013    div/comp/clk
    SLICE_X22Y40         FDRE                                         r  div/comp/quotient_reg[23]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X22Y40         FDRE (Prop_HFF_SLICEL_C_Q)
                                                      0.039     0.052 r  div/comp/quotient_reg[23]/Q
                         net (fo=2, estimated)        0.055     0.107    div/comp/quotient_next[24]
    SLICE_X23Y40         FDRE                                         r  div/comp/out_quotient_reg[24]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=244, unset)          0.019     0.019    div/comp/clk
    SLICE_X23Y40         FDRE                                         r  div/comp/out_quotient_reg[24]/C
                         clock pessimism              0.000     0.019    
    SLICE_X23Y40         FDRE (Hold_FFF2_SLICEL_C_D)
                                                      0.047     0.066    div/comp/out_quotient_reg[24]
  -------------------------------------------------------------------
                         required time                         -0.066    
                         arrival time                           0.107    
  -------------------------------------------------------------------
                         slack                                  0.041    





Pulse Width Checks
--------------------------------------------------------------------------------------
Clock Name:         clk
Waveform(ns):       { 0.000 2.500 }
Period(ns):         5.000
Sources:            { clk }

Check Type        Corner  Lib Pin  Reference Pin  Required(ns)  Actual(ns)  Slack(ns)  Location      Pin
Min Period        n/a     FDRE/C   n/a            0.550         5.000       4.450      SLICE_X15Y43  comb_reg/done_reg/C
Low Pulse Width   Slow    FDRE/C   n/a            0.275         2.500       2.225      SLICE_X15Y43  comb_reg/done_reg/C
High Pulse Width  Slow    FDRE/C   n/a            0.275         2.500       2.225      SLICE_X15Y43  comb_reg/done_reg/C



