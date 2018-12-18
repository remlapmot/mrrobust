*! version 0.1.0 18dec2018 Tom Palmer
program mrdeps
version 9.0
capture noisily {
	ssc install addplot
	ssc install kdens
	ssc install moremata
	ssc install heterogi
	ssc install metan
	net install grc1leg, from(http://www.stata.com/users/vwiggins)
}

end
exit