Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version : Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
| Date         : Thu Jul  7 03:08:07 2022
| Host         : boba running 64-bit Ubuntu 20.04.3 LTS
| Command      : report_utilization -force -file runs/2022-07-06-1704-full/vivado-eval/xilinx-ultrascale-plus-vivado-eval//vivado-synth-opt-place-route//lpm.futil-vanilla-util-route.v
| Design       : main
| Device       : xczu3eg-sbva484-1-e
| Speed File   : -1
| Design State : Routed
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Utilization Design Information

Table of Contents
-----------------
1. CLB Logic
1.1 Summary of Registers by Type
2. CLB Logic Distribution
3. BLOCKRAM
4. ARITHMETIC
5. I/O
6. CLOCK
7. ADVANCED
8. CONFIGURATION
9. Primitives
10. Black Boxes
11. Instantiated Netlists

1. CLB Logic
------------

+-------------------------+------+-------+------------+-----------+-------+
|        Site Type        | Used | Fixed | Prohibited | Available | Util% |
+-------------------------+------+-------+------------+-----------+-------+
| CLB LUTs                |  856 |     0 |          0 |     70560 |  1.21 |
|   LUT as Logic          |  856 |     0 |          0 |     70560 |  1.21 |
|   LUT as Memory         |    0 |     0 |          0 |     28800 |  0.00 |
| CLB Registers           |  654 |     0 |          0 |    141120 |  0.46 |
|   Register as Flip Flop |  654 |     0 |          0 |    141120 |  0.46 |
|   Register as Latch     |    0 |     0 |          0 |    141120 |  0.00 |
| CARRY8                  |    4 |     0 |          0 |      8820 |  0.05 |
| F7 Muxes                |    0 |     0 |          0 |     35280 |  0.00 |
| F8 Muxes                |    0 |     0 |          0 |     17640 |  0.00 |
| F9 Muxes                |    0 |     0 |          0 |      8820 |  0.00 |
+-------------------------+------+-------+------------+-----------+-------+


1.1 Summary of Registers by Type
--------------------------------

+-------+--------------+-------------+--------------+
| Total | Clock Enable | Synchronous | Asynchronous |
+-------+--------------+-------------+--------------+
| 0     |            _ |           - |            - |
| 0     |            _ |           - |          Set |
| 0     |            _ |           - |        Reset |
| 0     |            _ |         Set |            - |
| 0     |            _ |       Reset |            - |
| 0     |          Yes |           - |            - |
| 0     |          Yes |           - |          Set |
| 0     |          Yes |           - |        Reset |
| 0     |          Yes |         Set |            - |
| 654   |          Yes |       Reset |            - |
+-------+--------------+-------------+--------------+


2. CLB Logic Distribution
-------------------------

+--------------------------------------------+------+-------+------------+-----------+-------+
|                  Site Type                 | Used | Fixed | Prohibited | Available | Util% |
+--------------------------------------------+------+-------+------------+-----------+-------+
| CLB                                        |  161 |     0 |          0 |      8820 |  1.83 |
|   CLBL                                     |   97 |     0 |            |           |       |
|   CLBM                                     |   64 |     0 |            |           |       |
| LUT as Logic                               |  856 |     0 |          0 |     70560 |  1.21 |
|   using O5 output only                     |   30 |       |            |           |       |
|   using O6 output only                     |  639 |       |            |           |       |
|   using O5 and O6                          |  187 |       |            |           |       |
| LUT as Memory                              |    0 |     0 |          0 |     28800 |  0.00 |
|   LUT as Distributed RAM                   |    0 |     0 |            |           |       |
|   LUT as Shift Register                    |    0 |     0 |            |           |       |
| CLB Registers                              |  654 |     0 |          0 |    141120 |  0.46 |
|   Register driven from within the CLB      |  590 |       |            |           |       |
|   Register driven from outside the CLB     |   64 |       |            |           |       |
|     LUT in front of the register is unused |   47 |       |            |           |       |
|     LUT in front of the register is used   |   17 |       |            |           |       |
| Unique Control Sets                        |   76 |       |          0 |     17640 |  0.43 |
+--------------------------------------------+------+-------+------------+-----------+-------+
* * Note: Available Control Sets calculated as Slices * 2, Review the Control Sets Report for more information regarding control sets.


3. BLOCKRAM
-----------

+----------------+------+-------+------------+-----------+-------+
|    Site Type   | Used | Fixed | Prohibited | Available | Util% |
+----------------+------+-------+------------+-----------+-------+
| Block RAM Tile |    0 |     0 |          0 |       216 |  0.00 |
|   RAMB36/FIFO* |    0 |     0 |          0 |       216 |  0.00 |
|   RAMB18       |    0 |     0 |          0 |       432 |  0.00 |
+----------------+------+-------+------------+-----------+-------+
* Note: Each Block RAM Tile only has one FIFO logic available and therefore can accommodate only one FIFO36E2 or one FIFO18E2. However, if a FIFO18E2 occupies a Block RAM Tile, that tile can still accommodate a RAMB18E2


4. ARITHMETIC
-------------

+-----------+------+-------+------------+-----------+-------+
| Site Type | Used | Fixed | Prohibited | Available | Util% |
+-----------+------+-------+------------+-----------+-------+
| DSPs      |    0 |     0 |          0 |       360 |  0.00 |
+-----------+------+-------+------------+-----------+-------+


5. I/O
------

+------------------+------+-------+------------+-----------+-------+
|     Site Type    | Used | Fixed | Prohibited | Available | Util% |
+------------------+------+-------+------------+-----------+-------+
| Bonded IOB       |    0 |     0 |          0 |        82 |  0.00 |
| HPIOB_M          |    0 |     0 |          0 |        26 |  0.00 |
| HPIOB_S          |    0 |     0 |          0 |        26 |  0.00 |
| HDIOB_M          |    0 |     0 |          0 |        12 |  0.00 |
| HDIOB_S          |    0 |     0 |          0 |        12 |  0.00 |
| HPIOB_SNGL       |    0 |     0 |          0 |         6 |  0.00 |
| HPIOBDIFFINBUF   |    0 |     0 |          0 |        72 |  0.00 |
| HPIOBDIFFOUTBUF  |    0 |     0 |          0 |        72 |  0.00 |
| HDIOBDIFFINBUF   |    0 |     0 |          0 |        48 |  0.00 |
| BITSLICE_CONTROL |    0 |     0 |          0 |        24 |  0.00 |
| BITSLICE_RX_TX   |    0 |     0 |          0 |       936 |  0.00 |
| BITSLICE_TX      |    0 |     0 |          0 |        24 |  0.00 |
| RIU_OR           |    0 |     0 |          0 |        12 |  0.00 |
+------------------+------+-------+------------+-----------+-------+


6. CLOCK
--------

+----------------------+------+-------+------------+-----------+-------+
|       Site Type      | Used | Fixed | Prohibited | Available | Util% |
+----------------------+------+-------+------------+-----------+-------+
| GLOBAL CLOCK BUFFERs |    0 |     0 |          0 |       196 |  0.00 |
|   BUFGCE             |    0 |     0 |          0 |        88 |  0.00 |
|   BUFGCE_DIV         |    0 |     0 |          0 |        12 |  0.00 |
|   BUFG_PS            |    0 |     0 |          0 |        72 |  0.00 |
|   BUFGCTRL*          |    0 |     0 |          0 |        24 |  0.00 |
| PLL                  |    0 |     0 |          0 |         6 |  0.00 |
| MMCM                 |    0 |     0 |          0 |         3 |  0.00 |
+----------------------+------+-------+------------+-----------+-------+
* Note: Each used BUFGCTRL counts as two GLOBAL CLOCK BUFFERs. This table does not include global clocking resources, only buffer cell usage. See the Clock Utilization Report (report_clock_utilization) for detailed accounting of global clocking resource availability.


7. ADVANCED
-----------

+-----------+------+-------+------------+-----------+-------+
| Site Type | Used | Fixed | Prohibited | Available | Util% |
+-----------+------+-------+------------+-----------+-------+
| PS8       |    0 |     0 |          0 |         1 |  0.00 |
| SYSMONE4  |    0 |     0 |          0 |         1 |  0.00 |
+-----------+------+-------+------------+-----------+-------+


8. CONFIGURATION
----------------

+-------------+------+-------+------------+-----------+-------+
|  Site Type  | Used | Fixed | Prohibited | Available | Util% |
+-------------+------+-------+------------+-----------+-------+
| BSCANE2     |    0 |     0 |          0 |         4 |  0.00 |
| DNA_PORTE2  |    0 |     0 |          0 |         1 |  0.00 |
| EFUSE_USR   |    0 |     0 |          0 |         1 |  0.00 |
| FRAME_ECCE4 |    0 |     0 |          0 |         1 |  0.00 |
| ICAPE3      |    0 |     0 |          0 |         2 |  0.00 |
| MASTER_JTAG |    0 |     0 |          0 |         1 |  0.00 |
| STARTUPE3   |    0 |     0 |          0 |         1 |  0.00 |
+-------------+------+-------+------------+-----------+-------+


9. Primitives
-------------

+----------+------+---------------------+
| Ref Name | Used | Functional Category |
+----------+------+---------------------+
| FDRE     |  654 |            Register |
| LUT6     |  324 |                 CLB |
| LUT5     |  281 |                 CLB |
| LUT4     |  257 |                 CLB |
| LUT3     |  136 |                 CLB |
| LUT2     |   45 |                 CLB |
| CARRY8   |    4 |                 CLB |
+----------+------+---------------------+


10. Black Boxes
---------------

+----------+------+
| Ref Name | Used |
+----------+------+


11. Instantiated Netlists
-------------------------

+----------+------+
| Ref Name | Used |
+----------+------+


