* mrmodalplot example
* 2aug2017

cd C:\Users\palmertm\Documents\all\work\mregger\code

use dodata, clear

gen byte sel1 = (ldlcp2 < 1e-8)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1


* Simple mode estimator
mata mata clear
mata mata desc
discard
mrmodal chdbeta chdse ldlcbeta ldlcse if sel1==1, seed(12345)
mata mata desc

mata mata clear
mata mata desc
discard
mrmodal chdbeta chdse ldlcbeta ldlcse if sel1==1, seed(12345) nosave
mata mata desc


discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, seed(12345)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, seed(12345) reps(100)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, seed(12345) phi(1)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, seed(12345) phi(.5 1)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, seed(12345) phi(1 1.5 2 2.5)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, seed(12345) phi(1) lc(gs0)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ///
        seed(12345) lc(gs10 gs5 gs0)
        
discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ///
        seed(12345) lc(gs10 gs5 gs0) lp(solid dash longdash)
 
discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, ///
        seed(12345) lc(gs10 gs5 gs0) lp(solid dash longdash) lw(vthin thin thick)
        
discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, seed(12345) phi(1) lp(dash)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, seed(12345) phi(1) lw(vthick)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, seed(12345) phi(1) ///
        lc(gs0) lw(vthick) lp(dash)


* Weighted mode estimator
discard
mrmodal chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted seed(12345)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted seed(12345)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted seed(12345) phi(1)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted seed(12345) phi(.5 1)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted seed(12345) phi(1 1.5 2 2.5)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted seed(12345) phi(1) lc(gs0)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted seed(12345) phi(1) lp(dash)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted seed(12345) phi(1) lw(vthick)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted seed(12345) phi(1) ///
        lc(gs0) lw(vthick) lp(dash)


* Simple mode estimator with NOME assumption
mrmodal chdbeta chdse ldlcbeta ldlcse if sel1==1, nome

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome seed(12345)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome seed(12345) phi(1)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome seed(12345) phi(.5 1)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome seed(12345) phi(1 1.5 2 2.5)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome seed(12345) phi(1) lc(gs0)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome seed(12345) phi(1) lp(dash)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome seed(12345) phi(1) lw(vthick)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome seed(12345) phi(1) ///
        lc(gs0) lw(vthick) lp(dash)


* Weighted mode estimator with NOME assumption
mrmodal chdbeta chdse ldlcbeta ldlcse if sel1==1, weighted nome

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome weighted seed(12345)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome weighted seed(12345) phi(1)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome weighted seed(12345) phi(.5 1)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome weighted seed(12345) phi(1 1.5 2 2.5)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome weighted seed(12345) phi(1) lc(gs0)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome weighted seed(12345) phi(1) lp(dash)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome weighted seed(12345) phi(1) lw(vthick)

discard
mrmodalplot chdbeta chdse ldlcbeta ldlcse if sel1==1, nome weighted seed(12345) phi(1) ///
        lc(gs0) lw(vthick) lp(dash)
