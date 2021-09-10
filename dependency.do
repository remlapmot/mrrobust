* dependencies for mrrobust package; for github package
* Tom Palmer, 2018-12-21

foreach prog in addplot kdens moremata heterogi metan {
	cap noi ssc install `prog'
	if _rc == 602 {
		di as txt "Installing the latest version of `prog'"
		ssc install `prog', replace
	}
}

net install grc1leg, from(https://www.stata.com/users/vwiggins)
