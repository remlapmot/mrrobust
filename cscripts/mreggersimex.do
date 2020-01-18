* cscript for mreggersimex
* 23jul2017

cscript mreggersimex adofiles mreggersimex mreggersimexonce

use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear

gen byte sel1 = (ldlcp2 < 1e-8)

mreggersimex chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, ///
        gxse(ldlcse) seed(12345)

mreggersimex chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, ///
        gxse(ldlcse) seed(12345) simreps(20) reps(3)

mreggersimex chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, ///
        gxse(ldlcse) seed(12345) simreps(10)

mreggersimex chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, ///
        gxse(ldlcse) seed(12345) simreps(10) nodraw noboot
mreggersimex

mreggersimex chdbeta ldlcbeta [aw=1/chdse^2] if sel1==1, ///
        gxse(ldlcse) seed(12345) simreps(10) nodraw
