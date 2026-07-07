; p-field docs
; p1 = instrument id ("sine_osc")
; p2 = onset in seconds
; p3 = duration in seconds
; p4 = frequency in Hz (default 200)
; p5 = amplitude (0-1, default 0.5)
; p6 = pan (0=left, 1=right, default 0.5)
; p7 = attack percent (0-1, default 0.5)

instr sine_osc

  iNumPFields = pcount()

  ifreq       = (iNumPFields >= 4 ? p4 : 200)
  iamp        = (iNumPFields >= 5 ? p5 : 0.5)
  ispaz       = (iNumPFields >= 6 ? p6 : 0.5)
  iattackPerc = (iNumPFields >= 7 ? p7 : 0.5)

  ispaz = limit(ispaz, 0, 1)
  iattackPerc = limit(iattackPerc, 0, 1)

  iMinSeg = 0.00015
  iBodyDur = max(p3 - iMinSeg, iMinSeg)

  if (p3 <= iMinSeg * 2) then
    iattackTime  = p3 * 0.5
    ireleaseTime = p3 * 0.5
    isustainTime = max(p3 - iMinSeg, 0)
  else
    iattackTime  = (iattackPerc * iBodyDur) + iMinSeg
    ireleaseTime = max(p3 - iattackTime, iMinSeg)
    isustainTime = iBodyDur
  endif

  kenv2 linseg 0, iattackTime, 1, ireleaseTime, 0
  kserv linseg 1, isustainTime, 1, iMinSeg, 0
  kinviluppo = kenv2 * kserv

  aosc oscili iamp, ifreq

  kleft  = kinviluppo * (1 - ispaz)
  kright = kinviluppo * ispaz

  outs aosc * kleft, aosc * kright

endin
