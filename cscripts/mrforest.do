* mrforest cscript
* 16jun2017

cscript mrforest adofiles mrforest

about

use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear

gen byte sel1 = (ldlcp2 < 1e-8)

mrforest chdbeta chdse ldlcbeta ldlcse in 1/10, ivid(rsid) 

mrforest chdbeta chdse ldlcbeta ldlcse

mrforest chdbeta chdse ldlcbeta ldlcse if sel1==1, ivid(rsid)

mrforest chdbeta chdse ldlcbeta ldlcse in 1/10, ivid(rsid) nostats

mrforest chdbeta chdse ldlcbeta ldlcse in 1/45, ivid(rsid) nostats

mrforest chdbeta chdse ldlcbeta ldlcse in 1/45, ivid(rsid)

mrforest chdbeta chdse ldlcbeta ldlcse if sel1==1, ivid(rsid) nostats

mrforest chdbeta chdse ldlcbeta ldlcse in 1/10, ivid(rsid) modelsonly

mrforest chdbeta chdse ldlcbeta ldlcse in 1/10, ivid(rsid) ///
        modelsonly modelslabel(" ")

mrforest chdbeta chdse ldlcbeta ldlcse in 1/10, ivid(rsid) ///
        modelsonly modelslabel(" ") models(4)

mrforest chdbeta chdse ldlcbeta ldlcse in 1/10, ivid(rsid) ///
        modelsonly modelslabel(" ") models(4) nostats

// change Genotypes Summary labels
mrforest chdbeta chdse ldlcbeta ldlcse in 1/10, ivid(rsid) ///
        ividlabel("Instruments") modelslabel("All instruments")

mrforest chdbeta chdse ldlcbeta ldlcse in 1/10, ivid(rsid) ///
        ividlabel(Instruments) modelslabel(All instruments)

mrforest chdbeta chdse ldlcbeta ldlcse in 1/10, ivid(rsid) ///
        ividlabel("Instruments") models(0)      

mrforest chdbeta chdse ldlcbeta ldlcse in 1/10, ivid(rsid) ///
        ividlabel(Instruments) models(0)      

mrforest chdbeta chdse ldlcbeta ldlcse in 1/10, ivid(rsid) nonote

// check making horizontal bars grey (as per MR-Base) - metan has bugs
mrforest chdbeta chdse ldlcbeta ldlcse in 1/10, ivid(rsid) ///
        ciopt(lc(gray)) pointopt(mc(gray))

// change estimate label
mrforest chdbeta chdse ldlcbeta ldlcse in 1/10, ivid(rsid) effect(IV est)

mrforest chdbeta chdse ldlcbeta ldlcse if sel1==1, ivid(rsid) ///
        note("I{sub:GX}{sup:2}=90%", size(vsmall))

mrforest chdbeta chdse ldlcbeta ldlcse in 1/10, ivid(rsid) ///
        note("{it:I{sub:GX}{sup:2}}=90%", size(vsmall))

mrforest chdbeta chdse ldlcbeta ldlcse in 1/10, ivid(rsid) level(90)

mrforest chdbeta chdse ldlcbeta ldlcse in 1/10, zcis ivid(rsid)

mrforest chdbeta chdse ldlcbeta ldlcse in 1/10, eform ivid(rsid)

mrforest chdbeta chdse ldlcbeta ldlcse in 1/10, ivid(rsid) gsort(unsorted)

mrforest chdbeta chdse ldlcbeta ldlcse in 1/10, ivid(rsid) gsort(descending)

mrforest chdbeta chdse ldlcbeta ldlcse in 1/10

mrforest chdbeta chdse ldlcbeta ldlcse in 1/10, ivid(rsid) ///
        models(0)

mrforest chdbeta chdse ldlcbeta ldlcse in 1/10, ivid(rsid) ///
        models(1)

mrforest chdbeta chdse ldlcbeta ldlcse in 1/10, ivid(rsid) ///
        models(2)

mrforest chdbeta chdse ldlcbeta ldlcse in 1/10, ivid(rsid) ///
        models(3)    
        
mrforest chdbeta chdse ldlcbeta ldlcse in 1/10, ivid(rsid) ///
        models(4)

rcof "noi mrforest chdbeta chdse ldlcbeta ldlcse in 1/10, ivid(rsid) models(5)" == 198

mrforest chdbeta chdse ldlcbeta ldlcse in 1/10, ivid(rsid) ///
        xlabel(-3,-2,-1,0,1,2,3)

mrforest chdbeta chdse ldlcbeta ldlcse if sel1==1, ivid(rsid)

mrforest chdbeta chdse ldlcbeta ldlcse if sel1==1, ivid(rsid) nofe

mrforest chdbeta chdse ldlcbeta ldlcse if sel1==1, ivid(rsid) ivwopts(fe)

rcof "noi mrforest chdbeta chdse ldlcbeta ldlcse if sel1==1, ivid(rsid) ivwopts(fe) nofe" ///
        == 198
