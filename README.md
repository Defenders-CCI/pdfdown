# pdfdown

An R package to simplify Portable Document Format (PDF) file downloads.

----

Scraping PDFs from the web can run into little hitches that make writing a 
scraper annoying. This simplifies PDF scraping by creating a dedicated function 
and support functions to, e.g., test for PDFness. Ensures URL encoding, handles 
missing URLs gracefully. The main function, `download_pdf`, includes the
`pause` parameter (random 0-3s) to limit the rate at which requests hit the 
host server. We mostly use this to facilitate scraping U.S. Government documents 
that are only available as PDFs.

## Installation

Use [devtools](https://github.com/hadley/devtools) to install `pdfdown`:

```r
devtools::install_github("Defenders-ESC/pdfdown")
```

## Usage

Get the [five-year review](https://www.fws.gov/endangered/what-we-do/pdf/5-yr_review_factsheet.pdf) for the [Pecos puzzle sunflower](https://ecos.fws.gov/ecp0/profile/speciesProfile?spcode=Q0YJ):

```r
url <- "https://ecos.fws.gov/docs/five_year_review/doc4599.pdf"
helpar5y <- download_pdf(url, "~/Downloads/doc4599.pdf")
```

## Help

Find a bug or have a question? Submit an issue on [GitHub](https://github.com/Defenders-ESC/pdfdown/issues)! Alternatively, 
[get in touch](mailto:esa@defenders.org).

## Contributing

Want to add features or fix a bug? Fork [the repo](https://github.com/Defenders-ESC/pdfdown) and submit a pull request! Thanks!

