<CsoundSynthesizer>
<CsOptions>

</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1
#include "/Users/master/Documents/GitHub/temporal-system/instruments/click.orc"
#include "/Users/master/Documents/GitHub/temporal-system/instruments/sine_osc.orc"
</CsInstruments>
<CsScore>
f 1 0 16384 10 1
i "click" 0. 0.125 1760. 0.9 0.5
i "click" 0.5 0.125 1100. 0.45 0.5
i "click" 1. 0.125 1100. 0.45 0.5
i "click" 1.5 0.125 1100. 0.45 0.5
i "click" 2. 0.125 1760. 0.9 0.5
i "click" 2.5 0.125 1100. 0.45 0.5
i "click" 3. 0.125 1100. 0.45 0.5
i "click" 3.5 0.125 1100. 0.45 0.5
i "click" 4. 0.25 1760. 0.9 0.5
i "click" 5. 0.25 1100. 0.45 0.5
i "click" 6. 0.25 1100. 0.45 0.5
e
</CsScore>
</CsoundSynthesizer>