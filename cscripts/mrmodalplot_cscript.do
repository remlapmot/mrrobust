* mrmodalplot example
* 2aug2017

cscript mrmodalplot adofiles mrmodalplot

use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear

gen byte sel1 = (ldlcp2 < 1e-8)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1

* Simple mode estimator
mrmodal chdbeta chdse ldlcbeta ldlcse if sel1==1, seed(12345)

mrmodal chdbeta chdse ldlcbeta ldlcse if sel1==1, seed(12345) nosave

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, seed(12345)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, seed(12345) reps(100)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, seed(12345) phi(1)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, seed(12345) phi(.5 1)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, seed(12345) phi(1 1.5 2 2.5)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, seed(12345) phi(1) lc(gs0)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ///
        seed(12345) lc(gs10 gs5 gs0)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ///
        seed(12345) lc(gs10 gs5 gs0) lp(solid dash longdash)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ///
        seed(12345) lc(gs10 gs5 gs0) lp(solid dash longdash) lw(vthin thin thick)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, seed(12345) phi(1) lp(dash)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, seed(12345) phi(1) lw(vthick)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, seed(12345) phi(1) ///
        lc(gs0) lw(vthick) lp(dash)

* Weighted mode estimator
mrmodal chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted seed(12345)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted seed(12345)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted seed(12345) phi(1)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted seed(12345) phi(.5 1)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted seed(12345) phi(1 1.5 2 2.5)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted seed(12345) phi(1) lc(gs0)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted seed(12345) phi(1) lp(dash)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted seed(12345) phi(1) lw(vthick)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted seed(12345) phi(1) ///
        lc(gs0) lw(vthick) lp(dash)

* Simple mode estimator with NOME assumption
mrmodal chdbeta chdse ldlcbeta ldlcse if sel1==1, nome

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome seed(12345)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome seed(12345) phi(1)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome seed(12345) phi(.5 1)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome seed(12345) phi(1 1.5 2 2.5)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome seed(12345) phi(1) lc(gs0)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome seed(12345) phi(1) lp(dash)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome seed(12345) phi(1) lw(vthick)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome seed(12345) phi(1) ///
        lc(gs0) lw(vthick) lp(dash)

* Weighted mode estimator with NOME assumption
mrmodal chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted nome

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome weighted seed(12345)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome weighted seed(12345) phi(1)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome weighted seed(12345) phi(.5 1)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome weighted seed(12345) phi(1 1.5 2 2.5)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome weighted seed(12345) phi(1) lc(gs0)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome weighted seed(12345) phi(1) lp(dash)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome weighted seed(12345) phi(1) lw(vthick)

mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome weighted seed(12345) phi(1) ///
        lc(gs0) lw(vthick) lp(dash)
