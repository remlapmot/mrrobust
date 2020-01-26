*! version 0.1.0 26jan2020 Tom Palmer
program mrbase
version 9
syntax [anything(everything)] [, ///
    status(string) ///
    associations(string) ///
    phewas(string) ///
    tophits(string) ///
    ld(string) ///
    gwasinfo(string) ///
    variants(string) ///
    batches(string) ] 

local mrbaseapi "http://gwas-api.mrcieu.ac.uk"

// dependency: ssc install jsonio

if "`status'" != "" {
    // GET /status
    preserve
    drop _all
    jsonio kv, file("http://gwas-api.mrcieu.ac.uk/status")
    list , clean noobs fast
    restore
}

if "`associations'" != "" {
    // POST /associations

    // GET /associations/{id}/{variant}
    preserve
    drop _all
    jsonio kv, file("http://gwas-api.mrcieu.ac.uk/associations")
    list, clean noobs fast
    restore
}

if "`phewas'" != "" {
    // POST /phewas 

    // GET /phewas/{variant}/{pval}
    preserve
    drop _all
    jsonio kv, file("http://gwas-api.mrcieu.ac.uk/phewas/rs53576/1e-3")
    list, clean noobs fast
    restore
}

if "`tophits'" != "" {
    // POST /tophits

}

if "`ld'" != "" {
    // POST /ld/clump

    // POST /ld/matrix
}

if "`gwasinfo'" != "" {
    // POST /gwasinfo

    // GET /gwasinfo

    // GET/gwasinfo/{id}

}

if "`variants'" != "" {
    // POST /variants/chrpos

    // GET /variants/chrpos/{chrpos}

    // GET /variants/gene/{gene}

    // POST /variants/rsid

    // GET /variants/rsid/{rsid}

}

if "`batches'" != "" {
    // GET /batches

}

end
exit