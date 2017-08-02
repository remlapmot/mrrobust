* mrivests testcode
* 10jun2017

cscript

which mrivests

cd C:\Users\palmertm\Documents\all\work\mregger\code

use https://raw.github.com/remlapmot/mrmedian/master/dodata, clear

gen byte sel1 = (ldlcp2 < 1e-8)

cap noi drop ivest
cap noi drop ivse
cap noi drop ivcilow
cap noi drop ivciupp
mrivests chdbeta chdse ldlcbeta ldlcse if sel1==1, generate(ivest ivse)
list chdbeta ldlcbeta ivest ivse if sel1 == 1 
assert abs(ivest[1] - .36363636) < 1e-8
assert abs(ivse[1] - .41620702) < 1e-8
assert abs(ivest[184] - -.12597403) < 1e-8
assert abs(ivse[184] - .66640612) < 1e-8
gen double ivcilow = ivest - 1.96*ivse
gen double ivciupp = ivest + 1.96*ivse
di ivcilow[1], ivciupp[1]

cap noi drop ivest
cap noi drop ivse
qui gen double ivest = 100
qui gen double ivse = 10
mrivests chdbeta chdse ldlcbeta ldlcse if sel1==1, generate(ivest ivse, replace)
assert abs(ivest[1] - .36363636) < 1e-8
assert abs(ivse[1] - .41620702) < 1e-8
assert abs(ivest[184] - -.12597403) < 1e-8
assert abs(ivse[184] - .66640612) < 1e-8

cap noi drop ivest
cap noi drop ivse
cap noi drop ivcilow
cap noi drop ivciupp
rcof "noi mrivests chdbeta chdse ldlcbeta ldlcse if sel1==1, generate(ivest ivse thr)" == 198
rcof "noi mrivests chdbeta chdse ldlcbeta ldlcse if sel1==1, generate(ivest)" == 198
rcof "noi mrivests chdbeta chdse ldlcbeta if sel1==1, generate(ivest ivcilow ivciupp) fieller" == 198

cap noi drop ivest
cap noi drop ivse
qui gen double ivest = 100
qui gen double ivse = 10
mrivests chdbeta chdse ldlcbeta ldlcse if sel1==1, generate(ivest ivse, replace) nome
assert abs(ivest[1] - .36363636) < 1e-8
assert abs(ivse[1] - .41421333) < 1e-8
assert abs(ivest[184] - -.12597403) < 1e-8
assert abs(ivse[184] - .66611182) < 1e-8

cap noi drop ivest
cap noi drop ivcilow
cap noi drop ivciupp
mrivests chdbeta chdse ldlcbeta ldlcse if sel1==1, generate(ivest ivcilow ivciupp) fieller
assert abs(ivcilow[1] - -.45429758) < 1e-8
assert abs(ivciupp[1] - 1.2183172) < 1e-7
