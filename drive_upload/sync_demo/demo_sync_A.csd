<CsoundSynthesizer>
<CsOptions>

</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1
gkTS_amplitude init 1.
#include "/Users/master/Documents/GitHub/temporal-system/instruments/click.orc"
#include "/Users/master/Documents/GitHub/temporal-system/instruments/sine_osc.orc"
</CsInstruments>
<CsScore>
f 1 0 16384 10 1
i "sine_osc" 0. 0.5 440. 0.65
i "sine_osc" 2. 0.5 523.2511306011972 0.65
i "sine_osc" 4. 0.666666666666667 659.2551138257398 0.8
i "sine_osc" 4.666666666666667 0.666666666666667 783.9908719634985 0.65
i "sine_osc" 5.333333333333334 0.6666666666666661 987.7666025122483 0.65
e
</CsScore>
</CsoundSynthesizer>