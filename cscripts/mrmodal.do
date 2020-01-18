* mrmodal cscript
* 2jun2017

cscript mrivests adofiles mrivests

use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear

** error messages

** estimation examples
** ldlc

gen byte sel1 = 1 if ldlcp2 < 1e-8
count if sel1 == 1
gen double BetaYG = chdbeta
gen double BetaXG = ldlcbeta
gen double seBetaYG = chdse
gen double seBetaXG = ldlcse

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel1==1, seed(12345)
assert abs(_b[beta] - .4917353) < 1e-7

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel1==1, seed(12345) level(90)

mrmodal

mrmodal, level(90)

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel1==1, phi(.5)
assert abs(_b[beta] - .4218667) < 1e-7

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel1==1, phi(.25)
assert abs(_b[beta] - .4198713) < 1e-7

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel1==1, weighted
assert abs(_b[beta] - .4789702) < 1e-7

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel1==1, phi(.5) weighted
assert abs(_b[beta] -.4906313) < 1e-7

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel1==1, phi(.25) weighted
assert abs(_b[beta] - .5820001) < 1e-7

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel1==1, nome
assert abs(_b[beta] - .4917353) < 1e-7

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel1==1, phi(.5) nome
assert abs(_b[beta] -.4218667) < 1e-7

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel1==1, phi(.25) nome
assert abs(_b[beta] - .4198713) < 1e-7

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel1==1, weighted nome
assert abs(_b[beta] - .4789702) < 1e-7

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel1==1, weighted nome phi(.5)
assert abs(_b[beta] - .4906313) < 1e-7

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel1==1, weighted nome phi(.25)
assert abs(_b[beta] - .5820001) < 1e-7

** hdlc example

gen byte sel2 = 1 if hdlcp2 < 1e-8
count if sel2 == 1
cap noi drop BetaYG
cap noi drop seBetaYG
cap noi drop BetaXG
cap noi drop seBetaXG
gen double BetaYG = chdbeta
gen double BetaXG = hdlcbeta
gen double seBetaYG = chdse
gen double seBetaXG = hdlcse

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel2==1, seed(12345)
assert abs(_b[beta] - -.13406091) < 1e-8

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel2==1, phi(.5) seed(12345)
assert abs(_b[beta] - -.174225711) < 1e-8

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel2==1, phi(.25) seed(12345)
assert abs(_b[beta] - -.253856075) < 1e-8

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel2==1, seed(12345) weighted 
assert abs(_b[beta] - -.02957998) < 1e-8

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel2==1, phi(.5) seed(12345) weighted 
assert abs(_b[beta] - -.002889325) < 1e-8

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel2==1, phi(.25) seed(12345) weighted 
assert abs(_b[beta] - -.020577298) < 1e-8

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel2==1, seed(12345) nome
assert abs(_b[beta] - -.13406091) < 1e-8

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel2==1, phi(.5) seed(12345) nome
assert abs(_b[beta] - -.174225711) < 1e-8

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel2==1, phi(.25) seed(12345) nome
assert abs(_b[beta] - -.253856075) < 1e-8

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel2==1, seed(12345) weighted nome
assert abs(_b[beta] - -.02957998) < 1e-8

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel2==1, phi(.5) seed(12345) nome weighted 
assert abs(_b[beta] - -.002889325) < 1e-8

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel2==1, phi(.25) seed(12345) nome weighted 
assert abs(_b[beta] - -.020577298) < 1e-8

** tg example

gen byte sel3 = 1 if tgp2 < 1e-8
count if sel3 == 1
cap noi drop BetaYG
cap noi drop seBetaYG
cap noi drop BetaXG
cap noi drop seBetaXG
gen double BetaYG = chdbeta
gen double BetaXG = tgbeta
gen double seBetaYG = chdse
gen double seBetaXG = tgse

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel3==1, seed(12345)
assert abs(_b[beta] - .6835468) < 1e-8

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel3==1, phi(.5) seed(12345)
assert abs(_b[beta] - .8170654) < 1e-7

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel3==1, phi(.25) seed(12345)
assert abs(_b[beta] - .8749913) < 1e-2

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel3==1, seed(12345) weighted 
assert abs(_b[beta] - .5396388) < 1e-4

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel3==1, phi(.5) seed(12345) weighted 
assert abs(_b[beta] - .5788325) < 1e-6

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel3==1, phi(.25) seed(12345) weighted 
assert abs(_b[beta] - .5472065) < 1e-6

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel3==1, seed(12345) nome
assert abs(_b[beta] - .6835468) < 1e-8

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel3==1, phi(.5) seed(12345) nome
assert abs(_b[beta] - .8170654) < 1e-7

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel3==1, phi(.25) seed(12345) nome
assert abs(_b[beta] - .8479913) < 1e-1

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel3==1, seed(12345) weighted nome
assert abs(_b[beta] - .5499179) < 1e-7

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel3==1, phi(.5) seed(12345) nome weighted 
assert abs(_b[beta] - .5788325) < 1e-7

mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel3==1, phi(.25) seed(12345) nome weighted 
assert abs(_b[beta] - .5472065) < 1e-7

** nosave option
mata mata clear
mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel3==1, phi(.5) seed(12345) weighted
mata mata desc

mata mata clear
mrmodal BetaYG seBetaYG BetaXG seBetaXG if sel3==1, phi(.5) seed(12345) nosave weighted
cap noi mata mrmodal_densityiv
assert _rc == 3499
cap noi mata mrmodal_g
assert _rc == 3499
