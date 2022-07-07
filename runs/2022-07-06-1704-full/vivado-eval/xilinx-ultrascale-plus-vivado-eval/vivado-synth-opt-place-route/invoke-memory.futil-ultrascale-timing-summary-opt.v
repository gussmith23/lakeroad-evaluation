Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version      : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date              : Thu Jul  7 03:19:07 2022
| Host              : boba running 64-bit Ubuntu 20.04.3 LTS
| Command           : report_timing_summary -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//invoke-memory.futil-ultrascale-timing-summary-opt.v
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
5. checking no_input_delay (3)
6. checking no_output_delay (40)
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


6. checking no_output_delay (40)
--------------------------------
 There are 40 ports with no output delay specified. (HIGH)

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
      3.654        0.000                      0                   15        0.088        0.000                      0                   15        2.225        0.000                       0                     9  


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
clk                 3.654        0.000                      0                   15        0.088        0.000                      0                   15        2.225        0.000                       0                     9  


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

Setup :            0  Failing Endpoints,  Worst Slack        3.654ns,  Total Violation        0.000ns
Hold  :            0  Failing Endpoints,  Worst Slack        0.088ns,  Total Violation        0.000ns
PW    :            0  Failing Endpoints,  Worst Slack        2.225ns,  Total Violation        0.000ns
---------------------------------------------------------------------------------------------------


Max Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             3.654ns  (required time - arrival time)
  Source:                 copy0/comb_reg/done_reg/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            copy0/comb_reg/out_reg[0]/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            5.000ns  (clk rise@5.000ns - clk rise@0.000ns)
  Data Path Delay:        1.338ns  (logic 0.611ns (45.665%)  route 0.727ns (54.335%))
  Logic Levels:           4  (CARRY8=1 LUT3=1 LUT5=1 LUT6=1)
  Clock Uncertainty:      0.035ns  ((TSJ^2 + TIJ^2)^1/2 + DJ) / 2 + PE
    Total System Jitter     (TSJ):    0.071ns
    Total Input Jitter      (TIJ):    0.000ns
    Discrete Jitter          (DJ):    0.000ns
    Phase Error              (PE):    0.000ns

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=8, unset)            0.000     0.000    copy0/comb_reg/clk
                         FDRE                                         r  copy0/comb_reg/done_reg/C
  -------------------------------------------------------------------    -------------------
                         FDRE (Prop_FDRE_C_Q)         0.093     0.093 r  copy0/comb_reg/done_reg/Q
                         net (fo=7, unplaced)         0.202     0.295    copy0/fsm/comb_reg_done
                         LUT6 (Prop_LUT6_I0_O)        0.179     0.474 f  copy0/fsm/A_LUT_0_i_1__0/O
                         net (fo=2, unplaced)         0.156     0.630    copy0/lt/_impl/A_LUT_0/I0
                         LUT5 (Prop_LUT5_I0_O)        0.122     0.752 r  copy0/lt/_impl/A_LUT_0/LUT5/O
                         net (fo=1, unplaced)         0.287     1.039    copy0/lt/_impl/luts_O5_0[0]
                         CARRY8 (Prop_CARRY8_DI[0]_CO[7])
                                                      0.177     1.216 r  copy0/lt/_impl/carry_8/CO[7]
                         net (fo=1, unplaced)         0.024     1.240    copy0/lt/_impl/lt_out
                         LUT3 (Prop_LUT3_I0_O)        0.040     1.280 r  copy0/lt/_impl/out[0]_i_1__0/O
                         net (fo=1, unplaced)         0.058     1.338    copy0/comb_reg/out_reg[0]_0
                         FDRE                                         r  copy0/comb_reg/out_reg[0]/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        5.000     5.000 r  
                                                      0.000     5.000 r  clk (IN)
                         net (fo=8, unset)            0.000     5.000    copy0/comb_reg/clk
                         FDRE                                         r  copy0/comb_reg/out_reg[0]/C
                         clock pessimism              0.000     5.000    
                         clock uncertainty           -0.035     4.965    
                         FDRE (Setup_FDRE_C_D)        0.027     4.992    copy0/comb_reg/out_reg[0]
  -------------------------------------------------------------------
                         required time                          4.992    
                         arrival time                          -1.338    
  -------------------------------------------------------------------
                         slack                                  3.654    





Min Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             0.088ns  (arrival time - required time)
  Source:                 copy0/N/done_reg/C
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Destination:            copy0/N/done_reg/D
                            (rising edge-triggered cell FDRE clocked by clk  {rise@0.000ns fall@2.500ns period=5.000ns})
  Path Group:             clk
  Path Type:              Hold (Min at Fast Process Corner)
  Requirement:            0.000ns  (clk rise@0.000ns - clk rise@0.000ns)
  Data Path Delay:        0.134ns  (logic 0.061ns (45.522%)  route 0.073ns (54.478%))
  Logic Levels:           1  (LUT5=1)

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=8, unset)            0.000     0.000    copy0/N/clk
                         FDRE                                         r  copy0/N/done_reg/C
  -------------------------------------------------------------------    -------------------
                         FDRE (Prop_FDRE_C_Q)         0.038     0.038 f  copy0/N/done_reg/Q
                         net (fo=8, unplaced)         0.057     0.095    copy0/fsm/N_done
                         LUT5 (Prop_LUT5_I3_O)        0.023     0.118 r  copy0/fsm/A_LUT_0_i_2/O
                         net (fo=6, unplaced)         0.016     0.134    copy0/N/E[0]
                         FDRE                                         r  copy0/N/done_reg/D
  -------------------------------------------------------------------    -------------------

                         (clock clk rise edge)        0.000     0.000 r  
                                                      0.000     0.000 r  clk (IN)
                         net (fo=8, unset)            0.000     0.000    copy0/N/clk
                         FDRE                                         r  copy0/N/done_reg/C
                         clock pessimism              0.000     0.000    
                         FDRE (Hold_FDRE_C_D)         0.046     0.046    copy0/N/done_reg
  -------------------------------------------------------------------
                         required time                         -0.046    
                         arrival time                           0.134    
  -------------------------------------------------------------------
                         slack                                  0.088    





Pulse Width Checks
--------------------------------------------------------------------------------------
Clock Name:         clk
Waveform(ns):       { 0.000 2.500 }
Period(ns):         5.000
Sources:            { clk }

Check Type        Corner  Lib Pin  Reference Pin  Required(ns)  Actual(ns)  Slack(ns)  Location  Pin
Min Period        n/a     FDRE/C   n/a            0.550         5.000       4.450                copy0/N/done_reg/C
Low Pulse Width   Slow    FDRE/C   n/a            0.275         2.500       2.225                copy0/N/done_reg/C
High Pulse Width  Slow    FDRE/C   n/a            0.275         2.500       2.225                copy0/N/done_reg/C



