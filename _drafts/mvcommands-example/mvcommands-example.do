capture log close
log using "mvcommands-example", smcl replace
//_1
use https://raw.github.com/remlapmot/mrrobust/master/dodata, clear
//_2
gen byte sel1 = (ldlcp2 < 1e-8)
//_3
mrmvivw chdbeta ldlcbeta hdlcbeta [aw=1/(chdse^2)] if sel1==1
//_4
mrmvivw chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1
//_5
mrmvivw chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, ///
gxse(ldlcse hdlcse tgse)
//_6
mrmvegger chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1
//_7
mrmvegger chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, ///
orient(2)
//_8
mrmvegger chdbeta ldlcbeta hdlcbeta tgbeta [aw=1/(chdse^2)] if sel1==1, ///
orient(3)
//_^
log close
