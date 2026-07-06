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
i "sine_osc" 0. 4. 440. 0.65 0.5
e
</CsScore>
</CsoundSynthesizer>