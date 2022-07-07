Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 02:32:55 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing_summary -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//pipelined-mac.futil-ultrascale-timing-summary-route.v
| Design            : main
| Device            : xczu3eg-sbva484
| Speed File        : -1  PRODUCTION 1.29 08-03-2020
| Temperature Grade : E
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
5. checking no_input_delay (67)
6. checking no_output_delay (42)
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


5. checking no_input_delay (67)
-------------------------------
 There are 67 input ports with no input delay specified. (HIGH)

 There are 0 input ports with no input delay but user has a false path constraint.


6. checking no_output_delay (42)
--------------------------------
 There are 42 ports with no output delay specified. (HIGH)

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
      2.152        0.000                      0                  459        0.045        0.000                      0                  459        2.225        0.000                       0                   181  


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
clk                 2.152        0.000                      0                  459        0.045        0.000                      0                  459        2.225        0.000                       0                   181  


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

Setup :            0  Failing Endpoints,  Worst Slack        2.152ns,  Total Violation        0.000ns
Hold  :            0  Failing Endpoints,  Worst Slack        0.045ns,  Total Violation        0.000ns
PW    :            0  Failing Endpoints,  Worst Slack        2.225ns,  Total Violation        0.000ns
---------------------------------------------------------------------------------------------------


Max Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             2.152ns  (required time - arrival time)
  Source:                 fsm/out_reg[2]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            mac/pipe2/out_reg[31]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        2.828ns  (logic 1.164ns (41.160%)  route 1.664ns (58.840%))
  Logic Levels:           8  (CARRY8=4 LUT2=1 LUT4=1 LUT6=2)
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
                         net (fo=196, unset)          0.037     0.037    fsm/clk
    SLICE_X16Y11         FDRE                                         r  fsm/out_reg[2]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X16Y11         FDRE (Prop_CFF_SLICEM_C_Q)
                                                      0.095     0.132 f  fsm/out_reg[2]/Q
                         net (fo=19, routed)          0.306     0.438    fsm/out_reg[2]_1[2]
    SLICE_X18Y11         LUT4 (Prop_D5LUT_SLICEL_I0_O)
                                                      0.193     0.631 r  fsm/done_buf[0]_i_2/O
                         net (fo=15, routed)          0.287     0.918    mac/fsm0/out_reg[31]_0
    SLICE_X17Y12         LUT6 (Prop_E6LUT_SLICEL_I5_O)
                                                      0.148     1.066 r  mac/fsm0/out[31]_i_1__0/O
                         net (fo=65, routed)          0.597     1.663    mac/fsm0/stage2_go_in
    SLICE_X20Y3          LUT2 (Prop_D5LUT_SLICEM_I0_O)
                                                      0.167     1.830 r  mac/fsm0/D_LUT_3_i_1/O
                         net (fo=2, routed)           0.349     2.179    mac/add/_impl/D_LUT_3/I0
    SLICE_X23Y3          LUT6 (Prop_D6LUT_SLICEL_I0_O)
                                                      0.174     2.353 r  mac/add/_impl/D_LUT_3/LUT6/O
                         net (fo=1, routed)           0.010     2.363    mac/add/_impl/luts_O6_1[3]
    SLICE_X23Y3          CARRY8 (Prop_CARRY8_SLICEL_S[3]_CO[7])
                                                      0.195     2.558 r  mac/add/_impl/carry_8/CO[7]
                         net (fo=1, routed)           0.028     2.586    mac/add/_impl/co_3[7]
    SLICE_X23Y4          CARRY8 (Prop_CARRY8_SLICEL_CI_CO[7])
                                                      0.023     2.609 r  mac/add/_impl/carry_17/CO[7]
                         net (fo=1, routed)           0.028     2.637    mac/add/_impl/co_7[7]
    SLICE_X23Y5          CARRY8 (Prop_CARRY8_SLICEL_CI_CO[7])
                                                      0.023     2.660 r  mac/add/_impl/carry_26/CO[7]
                         net (fo=1, routed)           0.028     2.688    mac/add/_impl/co_11[7]
    SLICE_X23Y6          CARRY8 (Prop_CARRY8_SLICEL_CI_O[7])
                                                      0.146     2.834 r  mac/add/_impl/carry_35/O[7]
                         net (fo=1, routed)           0.031     2.865    mac/pipe2/D[31]
    SLICE_X23Y6          FDRE                                         r  mac/pipe2/out_reg[31]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=196, unset)          0.025     5.025    mac/pipe2/clk
    SLICE_X23Y6          FDRE                                         r  mac/pipe2/out_reg[31]/C
                         clock pessimism              0.000     5.025    
                         clock uncertainty           -0.035     4.990    
    SLICE_X23Y6          FDRE (Setup_HFF_SLICEL_C_D)
                                                      0.027     5.017    mac/pipe2/out_reg[31]
  -------------------------------------------------------------------
                         required time                          5.017    
                         arrival time                          -2.865    
  -------------------------------------------------------------------
                         slack                                  2.152    





Min Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             0.045ns  (arrival time - required time)
  Source:                 mac/fsm2/out_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            mac/fsm2/out_reg[1]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Hold (Min at Fast Process Corner)
  Requirement:            0.000ns  (clk rise@0.000ns - clk rise@0.000ns)
  Data Path Delay:        0.097ns  (logic 0.053ns (54.639%)  route 0.044ns (45.361%))
  Logic Levels:           1  (LUT6=1)
  Clock Path Skew:        0.006ns (DCD - SCD - CPR)
    Destination Clock Delay (DCD):    0.018ns
    Source Clock Delay      (SCD):    0.012ns
    Clock Pessimism Removal (CPR):    -0.000ns

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=196, unset)          0.012     0.012    mac/fsm2/clk
    SLICE_X17Y14         FDRE                                         r  mac/fsm2/out_reg[0]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X17Y14         FDRE (Prop_CFF_SLICEL_C_Q)
                                                      0.039     0.051 r  mac/fsm2/out_reg[0]/Q
                         net (fo=5, routed)           0.028     0.079    mac/fsm2/fsm2_out[0]
    SLICE_X17Y14         LUT6 (Prop_D6LUT_SLICEL_I4_O)
                                                      0.014     0.093 r  mac/fsm2/out[1]_i_2__1/O
                         net (fo=1, routed)           0.016     0.109    mac/fsm2/fsm2_in[1]
    SLICE_X17Y14         FDRE                                         r  mac/fsm2/out_reg[1]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=196, unset)          0.018     0.018    mac/fsm2/clk
    SLICE_X17Y14         FDRE                                         r  mac/fsm2/out_reg[1]/C
                         clock pessimism              0.000     0.018    
    SLICE_X17Y14         FDRE (Hold_DFF_SLICEL_C_D)
                                                      0.046     0.064    mac/fsm2/out_reg[1]
  -------------------------------------------------------------------
                         required time                         -0.064    
                         arrival time                           0.109    
  -------------------------------------------------------------------
                         slack                                  0.045    





Pulse Width Checks
--------------------------------------------------------------------------------------
Clock Name:         clk
Waveform(ns):       { 0.000 2.500 }
Period(ns):         5.000
Sources:            { clk }

Check Type        Corner  Lib Pin         Reference Pin  Required(ns)  Actual(ns)  Slack(ns)  Location      Pin
Min Period        n/a     DSP_OUTPUT/CLK  n/a            0.750         5.000       4.250      DSP48E2_X1Y2  mac/mult_pipe/comp/out0__0/DSP_OUTPUT_INST/CLK
Low Pulse Width   Slow    FDRE/C          n/a            0.275         2.500       2.225      SLICE_X16Y10  comb_reg/done_reg/C
High Pulse Width  Slow    FDRE/C          n/a            0.275         2.500       2.225      SLICE_X16Y10  comb_reg/done_reg/C



