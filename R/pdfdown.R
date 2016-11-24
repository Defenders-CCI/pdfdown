#' pdfdown: A package to simplify portable Document Format (PDF) file downloads
#'
#' pdfdown provides one primary function, \link{download_pdf}, and a small
#' number of exported helper functions that might be useful in other contexts.
#'
#' @details Scraping PDFs from the web can run into little hitches that make
#' writing a scraper annoying. This simplifies PDF scraping by creating a
#' dedicated function and support functions to, e.g., test for PDFness. Ensures
#' URL encoding, handles missing URLs gracefully. The filename is the basename
#' of the URL with " " replaced with "_". \link{download_pdf} includes the
#' \code{pause} parameter to limit the rate at which requests hit the hosting
#' servers.
#'
#' @docType package
#' @name pdfdown
NULL