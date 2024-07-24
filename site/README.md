# mrrobust website

This is a Quarto website.

Install quarto from <https://quarto.org/docs/get-started/>.

Then install the Stata dependencies in Stata with

```sh
do ../developer.do
```

In R the **Statamarkdown** package (from CRAN) and the development version of **knitr** (> 1.42) is required.

To preview the site as it's built run (from the top level of the repo, i.e., the directory above)

```sh
quarto preview site
```

To build the site run

```sh
quarto render site
```
