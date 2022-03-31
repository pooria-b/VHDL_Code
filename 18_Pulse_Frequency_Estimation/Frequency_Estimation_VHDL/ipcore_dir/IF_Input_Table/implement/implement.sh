
 
 
 



 

#!/bin/sh

# Clean up the results directory
rm -rf results
mkdir results

#Synthesize the Wrapper Files

echo 'Synthesizing example design with XST';
xst -ifn xst.scr
cp IF_Input_Table_exdes.ngc ./results/


# Copy the netlist generated by Coregen
echo 'Copying files from the netlist directory to the results directory'
cp ../../IF_Input_Table.ngc results/

#  Copy the constraints files generated by Coregen
echo 'Copying files from constraints directory to results directory'
cp ../example_design/IF_Input_Table_exdes.ucf results/

cd results

echo 'Running ngdbuild'
ngdbuild -p xc6vlx130t-ff1156-1 IF_Input_Table_exdes

echo 'Running map'
map IF_Input_Table_exdes -o mapped.ncd -pr i

echo 'Running par'
par mapped.ncd routed.ncd

echo 'Running trce'
trce -e 10 routed.ncd mapped.pcf -o routed

echo 'Running design through bitgen'
bitgen -w routed

echo 'Running netgen to create gate level VHDL model'
netgen -ofmt vhdl -sim -tm IF_Input_Table_exdes -pcf mapped.pcf -w routed.ncd routed.vhd