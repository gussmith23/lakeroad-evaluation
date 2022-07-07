Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:13:41 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing_summary -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//no-matches.futil-ultrascale-timing-summary-opt.v
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
      1.086        0.000                      0                 1607        0.078        0.000                      0                 1607        2.225        0.000                       0                  1027  


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
clk                 1.086        0.000                      0                 1607        0.078        0.000                      0                 1607        2.225        0.000                       0                  1027  


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

Setup :            0  Failing Endpoints,  Worst Slack        1.086ns,  Total Violation        0.000ns
Hold  :            0  Failing Endpoints,  Worst Slack        0.078ns,  Total Violation        0.000ns
PW    :            0  Failing Endpoints,  Worst Slack        2.225ns,  Total Violation        0.000ns
---------------------------------------------------------------------------------------------------


Max Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             1.086ns  (required time - arrival time)
  Source:                 tcam/pd37/out_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            tcam/me15/r/out_reg[0]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        3.906ns  (logic 1.268ns (32.463%)  route 2.638ns (67.537%))
  Logic Levels:           15  (CARRY8=5 LUT4=3 LUT5=6 LUT6=1)
  Clock Uncertainty:      0.035ns  ((TSJ^2 + TIJ^2)^1/2 + DJ) / 2 + PE
    Total System Jitter     (TSJ):    0.071ns
    Total Input Jitter      (TIJ):    0.000ns
    Discrete Jitter          (DJ):    0.000ns
    Phase Error              (PE):    0.000ns

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=1026, unset)         0.000     0.000    tcam/pd37/clk
                         FDRE                                         r  tcam/pd37/out_reg[0]/C
  -------------------------------------------------------------------    -------------------
                         FDRE (Prop_FDRE_C_Q)         0.093     0.093 r  tcam/pd37/out_reg[0]/Q
                         net (fo=12, unplaced)        0.145     0.238    tcam/pd37/pd37_out
                         LUT4 (Prop_LUT4_I0_O)        0.116     0.354 f  tcam/pd37/A_LUT_0_i_11__0/O
                         net (fo=1, unplaced)         0.210     0.564    tcam/pd49/A_LUT_0_i_4__31_0
                         LUT5 (Prop_LUT5_I4_O)        0.040     0.604 f  tcam/pd49/A_LUT_0_i_6__0/O
                         net (fo=1, unplaced)         0.161     0.765    tcam/pd49/A_LUT_0_i_6__0_n_0
                         LUT4 (Prop_LUT4_I0_O)        0.116     0.881 r  tcam/pd49/A_LUT_0_i_4__31/O
                         net (fo=69, unplaced)        0.287     1.168    tcam/fsm32/A_LUT_0
                         LUT5 (Prop_LUT5_I0_O)        0.040     1.208 r  tcam/fsm32/A_LUT_0_i_5__0/O
                         net (fo=78, unplaced)        0.290     1.498    tcam/fsm32/out_reg[3]_6
                         LUT4 (Prop_LUT4_I0_O)        0.085     1.583 f  tcam/fsm32/C_LUT_2_i_1__29/O
                         net (fo=2, unplaced)         0.210     1.793    tcam/me15/sub/_impl/C_LUT_2/I1
                         LUT5 (Prop_LUT5_I1_O)        0.084     1.877 r  tcam/me15/sub/_impl/C_LUT_2/LUT5/O
                         net (fo=1, unplaced)         0.280     2.157    tcam/me15/sub/_impl/luts_O5_0[2]
                         CARRY8 (Prop_CARRY8_DI[2]_O[4])
                                                      0.189     2.346 r  tcam/me15/sub/_impl/carry_8/O[4]
                         net (fo=38, unplaced)        0.273     2.619    tcam/me15/sub/_impl/out0[0]
                         LUT5 (Prop_LUT5_I1_O)        0.085     2.704 r  tcam/me15/sub/_impl/B_LUT_1_i_4__4/O
                         net (fo=7, unplaced)         0.235     2.939    tcam/me15/sub/_impl/B_LUT_1_i_4__4_n_0
                         LUT6 (Prop_LUT6_I2_O)        0.040     2.979 r  tcam/me15/sub/_impl/B_LUT_1_i_2__14/O
                         net (fo=2, unplaced)         0.210     3.189    tcam/me15/eq/_impl/B_LUT_1/I1
                         LUT5 (Prop_LUT5_I1_O)        0.089     3.278 r  tcam/me15/eq/_impl/B_LUT_1/LUT5/O
                         net (fo=1, unplaced)         0.234     3.512    tcam/me15/eq/_impl/luts_O5_0[1]
                         CARRY8 (Prop_CARRY8_DI[1]_CO[7])
                                                      0.161     3.673 r  tcam/me15/eq/_impl/carry_8/CO[7]
                         net (fo=1, unplaced)         0.007     3.680    tcam/me15/eq/_impl/co_3[7]
                         CARRY8 (Prop_CARRY8_CI_CO[7])
                                                      0.030     3.710 r  tcam/me15/eq/_impl/carry_17/CO[7]
                         net (fo=1, unplaced)         0.007     3.717    tcam/me15/eq/_impl/co_7[7]
                         CARRY8 (Prop_CARRY8_CI_CO[7])
                                                      0.030     3.747 r  tcam/me15/eq/_impl/carry_26/CO[7]
                         net (fo=1, unplaced)         0.007     3.754    tcam/me15/eq/_impl/co_11[7]
                         CARRY8 (Prop_CARRY8_CI_CO[7])
                                                      0.030     3.784 r  tcam/me15/eq/_impl/carry_35/CO[7]
                         net (fo=1, unplaced)         0.024     3.808    tcam/me15/r/out0
                         LUT5 (Prop_LUT5_I0_O)        0.040     3.848 r  tcam/me15/r/out[0]_i_1__14/O
                         net (fo=1, unplaced)         0.058     3.906    tcam/me15/r/out[0]_i_1__14_n_0
                         FDRE                                         r  tcam/me15/r/out_reg[0]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=1026, unset)         0.000     5.000    tcam/me15/r/clk
                         FDRE                                         r  tcam/me15/r/out_reg[0]/C
                         clock pessimism              0.000     5.000    
                         clock uncertainty           -0.035     4.965    
                         FDRE (Setup_FDRE_C_D)        0.027     4.992    tcam/me15/r/out_reg[0]
  -------------------------------------------------------------------
                         required time                          4.992    
                         arrival time                          -3.906    
  -------------------------------------------------------------------
                         slack                                  1.086    





Min Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             0.078ns  (arrival time - required time)
  Source:                 tcam/comb_reg20/out_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            tcam/fsm19/out_reg[1]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Hold (Min at Fast Process Corner)
  Requirement:            0.000ns  (clk rise@0.000ns - clk rise@0.000ns)
  Data Path Delay:        0.124ns  (logic 0.062ns (50.000%)  route 0.062ns (50.000%))
  Logic Levels:           1  (LUT6=1)

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=1026, unset)         0.000     0.000    tcam/comb_reg20/clk
                         FDRE                                         r  tcam/comb_reg20/out_reg[0]/C
  -------------------------------------------------------------------    -------------------
                         FDRE (Prop_FDRE_C_Q)         0.039     0.039 f  tcam/comb_reg20/out_reg[0]/Q
                         net (fo=2, unplaced)         0.046     0.085    tcam/fsm19/comb_reg20_out
                         LUT6 (Prop_LUT6_I5_O)        0.023     0.108 r  tcam/fsm19/out[1]_i_2__10/O
                         net (fo=1, unplaced)         0.016     0.124    tcam/fsm19/fsm19_in[1]
                         FDRE                                         r  tcam/fsm19/out_reg[1]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=1026, unset)         0.000     0.000    tcam/fsm19/clk
                         FDRE                                         r  tcam/fsm19/out_reg[1]/C
                         clock pessimism              0.000     0.000    
                         FDRE (Hold_FDRE_C_D)         0.046     0.046    tcam/fsm19/out_reg[1]
  -------------------------------------------------------------------
                         required time                         -0.046    
                         arrival time                           0.124    
  -------------------------------------------------------------------
                         slack                                  0.078    





Pulse Width Checks
--------------------------------------------------------------------------------------
Clock Name:         clk
Waveform(ns):       { 0.000 2.500 }
Period(ns):         5.000
Sources:            { clk }

Check Type        Corner  Lib Pin  Reference Pin  Required(ns)  Actual(ns)  Slack(ns)  Location  Pin
Min Period        n/a     FDRE/C   n/a            0.550         5.000       4.450                fsm/out_reg[0]/C
Low Pulse Width   Slow    FDRE/C   n/a            0.275         2.500       2.225                fsm/out_reg[0]/C
High Pulse Width  Slow    FDRE/C   n/a            0.275         2.500       2.225                fsm/out_reg[0]/C



