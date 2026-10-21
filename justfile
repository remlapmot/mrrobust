dev:
    stata-mp "do developer"
render: uninstall
    quarto render site
    rm -r docs/*
    mv site/_site/* docs/
[working-directory('cscripts')]
test: uninstall
    stata-mp -b "do master"

uninstall:
    #!/usr/bin/env bash
    # mrrobust may be installed multiple times. `ado uninstall mrrobust` fails with
    # r(111) ("matches more than one package") when there are duplicates, and each
    # uninstall renumbers the remaining packages, so we re-query `ado dir mrrobust`
    # and remove one [#] at a time until none remain. The iteration cap is just a
    # safety stop against an unexpected non-terminating loop.
    for _ in $(seq 1 100); do
        n=$(printf 'ado dir mrrobust\n' | stata-mp -q | grep -oE '\[[0-9]+\]' | head -1)
        [ -z "$n" ] && break
        printf 'ado uninstall %s\n' "$n" | stata-mp -q
    done
    echo "Remaining mrrobust packages (should be none):"
    printf 'ado dir mrrobust\n' | stata-mp -q

install: uninstall
    printf 'net install mmrobust, from("https://raw.githubusercontent.com/remlapmot/mrrobust/master/") replace\nado dir mrrobust\n' | stata-mp -q
