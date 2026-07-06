<CsoundSynthesizer>
<CsOptions>

</CsOptions>
<CsInstruments>
#include "/Users/master/Documents/GitHub/temporal-system/instruments/click.orc"
#include "/Users/master/Documents/GitHub/temporal-system/instruments/sine_osc.orc"
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1
</CsInstruments>
<CsScore>
f 1 0 16384 10 1
i "sine_osc" 0. 0.5 220. 0.35
i "sine_osc" 0.5 0.5 330.00857764287997 0.35
i "sine_osc" 1. 0.5 440. 0.5
i "sine_osc" 1.5 0.5 549.9003445007195 0.5
i "sine_osc" 2. 1. 660.0171552857599 0.65
i "sine_osc" 3. 1. 770.0774353757841 0.65
i "sine_osc" 4. 1.5 880. 0.8
i "sine_osc" 5.5 1.5 990.0514665261522 0.8
e
</CsScore>
</CsoundSynthesizer>