VCS=/proj/cadtools/bin/vcs
SRC=../../rtl/fifo.v ../../rtl/fifo_wrapper.v ../../rtl/mai.v test_mai.v
TGT=simv
VERICOM=/proj/cadtools/bin/vericom
VERDI=/proj/cadtools/bin/verdi
TAB_FILE=/proj/cadsim/simtools/simtools2.linux/pli64_rh4/dummytbv.tab
PLI_FILE=/proj/cadsim/simtools/simtools2.linux/pli64_rh4/dummytbv_vcs.a
VERDI_TAB=/proj/caeeda/NOVAS/VERDI/201001/share/PLI/vcs_latest/LINUX/verdi.tab
VERDI_PLI=/proj/caeeda/NOVAS/VERDI/201001/share/PLI/vcs_latest/LINUX/pli.a

FLAGS= -P $(VERDI_TAB) $(VERDI_PLI) -unit_timescale=1ps/1ps 
all:simv

$(TGT): $(SRC) 
	rm out -rf
	mkdir out
	$(VCS) -sverilog $(FLAGS) $^ +define+DUMPFSDB  -sgq int
run:
	/proj/caeeda/SYNOPSYS/bin/simv -sgq int
seewave:
	$(VERDI) -f run.f -top test -ssf ./out/mai.fsdb -sgq int -background
clean:
	rm simv; rm csrc -rf; rm *.daidir -rf; rm out -rf; rm verdiLog -rf; rm vcs.log; rm novas.*; rm ucli.key
