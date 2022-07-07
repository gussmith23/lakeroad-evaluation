Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:04:54 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing_summary -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//invoke-with.futil-vanilla-timing-summary-route.v
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


5. checking no_input_delay (3)
------------------------------
 There are 3 input ports with no input delay specified. (HIGH)

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
      2.221        0.000                      0                  153        0.080        0.000                      0                  153        2.225        0.000                       0                    26  


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
clk                 2.221        0.000                      0                  153        0.080        0.000                      0                  153        2.225        0.000                       0                    26  


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

Setup :            0  Failing Endpoints,  Worst Slack        2.221ns,  Total Violation        0.000ns
Hold  :            0  Failing Endpoints,  Worst Slack        0.080ns,  Total Violation        0.000ns
PW    :            0  Failing Endpoints,  Worst Slack        2.225ns,  Total Violation        0.000ns
---------------------------------------------------------------------------------------------------


Max Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             2.221ns  (required time - arrival time)
  Source:                 m/comp/out0__0/DSP_A_B_DATA_INST/CLK
                            (rising edge-triggered cell DSP_A_B_DATA clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            m/comp/out_tmp_reg/DSP_OUTPUT_INST/ALU_OUT[0]
                            (rising edge-triggered cell DSP_OUTPUT clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        2.723ns  (logic 2.707ns (99.412%)  route 0.016ns (0.588%))
  Logic Levels:           6  (DSP_ALU=2 DSP_M_DATA=1 DSP_MULTIPLIER=1 DSP_OUTPUT=1 DSP_PREADD_DATA=1)
  Clock Path Skew:        -0.031ns (DCD - SCD + CPR)
    Destination Clock Delay (DCD):    0.044ns = ( 5.044 - 5.000 ) 
    Source Clock Delay      (SCD):    0.075ns
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
                         net (fo=41, unset)           0.075     0.075    m/comp/out0__0/CLK
    DSP48E2_X2Y46        DSP_A_B_DATA                                 r  m/comp/out0__0/DSP_A_B_DATA_INST/CLK
  -------------------------------------------------------------------    -------------------
    DSP48E2_X2Y46        DSP_A_B_DATA (Prop_DSP_A_B_DATA_DSP48E2_CLK_B2_DATA[17])
                                                      0.263     0.338 r  m/comp/out0__0/DSP_A_B_DATA_INST/B2_DATA[17]
                         net (fo=1, routed)           0.000     0.338    m/comp/out0__0/DSP_A_B_DATA.B2_DATA<17>
    DSP48E2_X2Y46        DSP_PREADD_DATA (Prop_DSP_PREADD_DATA_DSP48E2_B2_DATA[17]_B2B1[17])
                                                      0.092     0.430 r  m/comp/out0__0/DSP_PREADD_DATA_INST/B2B1[17]
                         net (fo=1, routed)           0.000     0.430    m/comp/out0__0/DSP_PREADD_DATA.B2B1<17>
    DSP48E2_X2Y46        DSP_MULTIPLIER (Prop_DSP_MULTIPLIER_DSP48E2_B2B1[17]_U[43])
                                                      0.737     1.167 f  m/comp/out0__0/DSP_MULTIPLIER_INST/U[43]
                         net (fo=1, routed)           0.000     1.167    m/comp/out0__0/DSP_MULTIPLIER.U<43>
    DSP48E2_X2Y46        DSP_M_DATA (Prop_DSP_M_DATA_DSP48E2_U[43]_U_DATA[43])
                                                      0.059     1.226 r  m/comp/out0__0/DSP_M_DATA_INST/U_DATA[43]
                         net (fo=1, routed)           0.000     1.226    m/comp/out0__0/DSP_M_DATA.U_DATA<43>
    DSP48E2_X2Y46        DSP_ALU (Prop_DSP_ALU_DSP48E2_U_DATA[43]_ALU_OUT[47])
                                                      0.699     1.925 f  m/comp/out0__0/DSP_ALU_INST/ALU_OUT[47]
                         net (fo=1, routed)           0.000     1.925    m/comp/out0__0/DSP_ALU.ALU_OUT<47>
    DSP48E2_X2Y46        DSP_OUTPUT (Prop_DSP_OUTPUT_DSP48E2_ALU_OUT[47]_PCOUT[47])
                                                      0.159     2.084 r  m/comp/out0__0/DSP_OUTPUT_INST/PCOUT[47]
                         net (fo=1, routed)           0.016     2.100    m/comp/out_tmp_reg/PCIN[47]
    DSP48E2_X2Y47        DSP_ALU (Prop_DSP_ALU_DSP48E2_PCIN[47]_ALU_OUT[0])
                                                      0.698     2.798 r  m/comp/out_tmp_reg/DSP_ALU_INST/ALU_OUT[0]
                         net (fo=1, routed)           0.000     2.798    m/comp/out_tmp_reg/DSP_ALU.ALU_OUT<0>
    DSP48E2_X2Y47        DSP_OUTPUT                                   r  m/comp/out_tmp_reg/DSP_OUTPUT_INST/ALU_OUT[0]
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=41, unset)           0.044     5.044    m/comp/out_tmp_reg/CLK
    DSP48E2_X2Y47        DSP_OUTPUT                                   r  m/comp/out_tmp_reg/DSP_OUTPUT_INST/CLK
                         clock pessimism              0.000     5.044    
                         clock uncertainty           -0.035     5.009    
    DSP48E2_X2Y47        DSP_OUTPUT (Setup_DSP_OUTPUT_DSP48E2_CLK_ALU_OUT[0])
                                                      0.010     5.019    m/comp/out_tmp_reg/DSP_OUTPUT_INST
  -------------------------------------------------------------------
                         required time                          5.019    
                         arrival time                          -2.798    
  -------------------------------------------------------------------
                         slack                                  2.221    





Min Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             0.080ns  (arrival time - required time)
  Source:                 m/comp/done_buf_reg[0]/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            m/comp/done_buf_reg[1]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Hold (Min at Fast Process Corner)
  Requirement:            0.000ns  (clk rise@0.000ns - clk rise@0.000ns)
  Data Path Delay:        0.133ns  (logic 0.039ns (29.323%)  route 0.094ns (70.677%))
  Logic Levels:           0  
  Clock Path Skew:        0.007ns (DCD - SCD - CPR)
    Destination Clock Delay (DCD):    0.019ns
    Source Clock Delay      (SCD):    0.012ns
    Clock Pessimism Removal (CPR):    -0.000ns

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=41, unset)           0.012     0.012    m/comp/clk
    SLICE_X27Y118        FDRE                                         r  m/comp/done_buf_reg[0]/C
  -------------------------------------------------------------------    -------------------
    SLICE_X27Y118        FDRE (Prop_DFF_SLICEL_C_Q)
                                                      0.039     0.051 r  m/comp/done_buf_reg[0]/Q
                         net (fo=2, routed)           0.094     0.145    m/comp/done_buf_reg_n_0_[0]
    SLICE_X27Y118        FDRE                                         r  m/comp/done_buf_reg[1]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=41, unset)           0.019     0.019    m/comp/clk
    SLICE_X27Y118        FDRE                                         r  m/comp/done_buf_reg[1]/C
                         clock pessimism              0.000     0.019    
    SLICE_X27Y118        FDRE (Hold_EFF_SLICEL_C_D)
                                                      0.046     0.065    m/comp/done_buf_reg[1]
  -------------------------------------------------------------------
                         required time                         -0.065    
                         arrival time                           0.145    
  -------------------------------------------------------------------
                         slack                                  0.080    





Pulse Width Checks
--------------------------------------------------------------------------------------
Clock Name:         clk
Waveform(ns):       { 0.000 2.500 }
Period(ns):         5.000
Sources:            { clk }

Check Type        Corner  Lib Pin         Reference Pin  Required(ns)  Actual(ns)  Slack(ns)  Location       Pin
Min Period        n/a     DSP_OUTPUT/CLK  n/a            0.750         5.000       4.250      DSP48E2_X2Y48  m/comp/out0/DSP_OUTPUT_INST/CLK
Low Pulse Width   Slow    FDRE/C          n/a            0.275         2.500       2.225      SLICE_X26Y117  comb_reg/done_reg/C
High Pulse Width  Slow    FDRE/C          n/a            0.275         2.500       2.225      SLICE_X26Y117  comb_reg/done_reg/C



