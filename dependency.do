* dependencies for mrrobust package; for github package
* Tom Palmer, 2018-12-21

ssc install addplot
ssc install kdens
cap noi ssc install moremata
if _rc == 602 {
    di as txt "Installing the latest version of moremata"
    ssc install moremata, replace
}
ssc install heterogi
ssc install metan
net install grc1leg, from(http://www.stata.com/users/vwiggins)
