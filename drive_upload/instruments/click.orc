; p-field docs
; p1 = instrument id ("click")
; p2 = onset in seconds
; p3 = duration in seconds
; p4 = frequency in Hz
; p5 = amplitude (0-1)
; p6 = pan (0=left, 1=right)

instr click
  aenv linsegr 0, 0.002, 1, 0.015, 0
  aout oscil p5 * aenv, p4, 1
  outs aout * (1 - p6), aout * p6
endin
