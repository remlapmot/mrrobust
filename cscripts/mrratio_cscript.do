* mrratio cscript
* 6jun2017

cscript mrratio adofiles mrratio

// basic call
mrratio 1 .5 1 .25
eret list
assert _b[beta] == 1
assert abs(_se[beta] - .559017) < 1e-6
assert e(fiellerres) == .

// test replay
mrratio
assert _b[beta] == 1
assert abs(_se[beta] - .559017) < 1e-6
assert e(level) == 95

mrratio, level(90)

mrratio 1 .5 1 .25, eform
mrratio
mrratio, eform

mrratio 1 .5 1 .25, eform level(90)
mrratio, eform
mrratio, eform level(90)

// fieller
mrratio 1 .5 1 .25, fieller
eret list
assert e(fiellerres) == 1
assert _b[beta] == 1
assert abs(e(lowerci) - .019969) < 1e-6
assert abs(e(upperci) - 2.611925) < 1e-6

mrratio

rcof "noi mrratio, level(90)" == 198

mrratio 1 .5 1 .25, fieller eform
assert e(fiellerres) == 1
assert _b[beta] == 1
assert abs(e(lowerci) - .019969) < 1e-6
assert abs(e(upperci) - 2.611925) < 1e-6

mrratio 1 .5 1 .25, fieller level(90)
assert e(level) == 90

// nome
mrratio 1 .5 1 .25, nome
assert e(fiellerres) == .
assert _b[beta] == 1
assert _se[beta] == .5
mrratio
mrratio, level(90)
mrratio 1 .5 1 .25, nome eform

rcof "noi mrratio 1 .5 1 .25, nome fieller" == 198

// fiellerres = 2
mrratio 1 .0007 2000 10000, fieller
assert e(fiellerres) == 2
assert abs(e(lowerci) - -.0000568) < 1e-7
assert abs(e(upperci) - .0000462) < 1e-7
mrratio

mrratio 1 .0007 2000 10000, fieller eform
assert e(fiellerres) == 2

// fiellerres = 3
mrratio .0007 10000 2000 10000, fieller
assert e(fiellerres) == 3
assert _b[beta] == 3.5e-7
mrratio

// allow 3 inputs but require nome
mrratio 1 .5 1, nome
assert _b[beta] == 1

rcof "noi mrratio 1 .5 1" == 198
