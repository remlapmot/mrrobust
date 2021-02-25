*! version 0.1.0 18dec2018 Tom Palmer
program mrdeps
version 9.0
foreach prog in addplot kdens moremata heterogi metan {
	cap noi ssc install `prog'
	if _rc == 602 {
		di as txt "Installing the latest version of `prog'"
		ssc install `prog', replace
	}
}

cap noi net install grc1leg, from(http://www.stata.com/users/vwiggins)

end
exit
