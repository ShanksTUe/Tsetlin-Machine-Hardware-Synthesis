#!/bin/bash

# Compile the Verilog files
iverilog -o tmpipe TM_Classifier.v TM_pipeline.v compare_states.v ta_state_counter.v xin_rom.v ta_rom_1.v ta_rom_2.v ta_rom_3.v ta_rom_4.v ta_rom_5.v ta_rom_6.v ta_rom_7.v ta_rom_8.v ta_rom_9.v ta_rom_10.v clause_output.v clause_counter.v class_sum.v class_sum_th.v clause_out_regbank.v testbench.v TM_controller.v

# Execute the compiled simulation
vvp tmpipe