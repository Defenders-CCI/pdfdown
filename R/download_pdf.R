#' Download a PDF from a URL
#'
#' Simple function to download a PDF, robustly.
#'
#' @details Scraping PDFs from the web can run into little hitches that make
#' writing a scraper annoying. This simplifies PDF scraping by creating a
#' dedicated function and support functions to, e.g., test for PDFness. Ensures
#' URL encoding, handles missing URLs gracefully. The filename is the basename
#' of the URL with " " replaced with "_". Includes the \code{pause} parameter
#' to limit the rate at which requests hit the hosting servers.
#'
#' TODO: Have the overwrite check work on the MD5 hash of files in the download
#' \code{sudb} rather than relying on file names.
#'
#' @param url A URL from ECOS to download a document
#' @param subd Subdirectory to which the document will be downloaded
#' @param quiet Suppress a message about which URL is being processed
#' @param overwrite Overwrite an existing file of the same name
#' @param pause Whether to pause for 0.5-3 seconds during scraping
#' @return A data.frame with url, destination, success, pdfCheck
#' @importFrom httr http_error GET write_disk
#' @export
#' @examples
#' \dontrun{
#' result <- download_pdf("https://goo.gl/I3P3A3", "~/Downloads")
#' }
download_pdf <- function(url, subd, quiet = FALSE,
                         overwrite = FALSE, pause = TRUE) {
  if(!quiet) message(paste("Processing:", url))
  dest <- make_pdf_dest(url, subd)
  url <- URLencode(url)
  if(!file_check(dest) & !overwrite) {
    if(pause == TRUE) Sys.sleep(runif(1, 0.5, 3))
    if(class(try(httr::http_error(url), silent = TRUE)) != "try-error") {
      res <- try(httr::GET(url, httr::write_disk(dest, overwrite = TRUE)))
      if(class(res) == "try-error") { # Try once more
        res <- try(httr::GET(url, httr::write_disk(dest, overwrite = TRUE)))
        if(class(res) == "try-error" | res$all_headers[[1]]$status != 200) {
          return(data.frame(url = url,
                            dest = NA,
                            success = "Failed",
                            pdfCheck = NA,
                            stringsAsFactors = FALSE))
        }
      }
      pdfCheck <- is_pdf(dest)
      return(data.frame(url = url,
                        dest = dest,
                        success = "Success",
                        pdfCheck = pdfCheck,
                        stringsAsFactors = FALSE))
    } else {
      return(data.frame(url = url,
                        dest = NA,
                        success = "Failed",
                        pdfCheck = NA,
                        stringsAsFactors = FALSE))
    }
  } else {
    pdfCheck <- is_pdf(dest)
    return(data.frame(url = url,
                      dest = dest,
                      success = "Pre-exist",
                      pdfCheck = pdfCheck,
                      stringsAsFactors = FALSE))
  }
}

#' Construct a path to download a PDF
#'
#' @details Creates the directory to which the PDF will be downloaded if it
#' doesn't yet exist and returns the download path. The filename of the download
#' is based on the URL, but spaces " " are replaced with underscores "_", and
#' the ".pdf" prefix is appended if not present.
#'
#' @param url The URL from which to download a PDF document
#' @param subd The subdirectory in which the download will be written
#' @return The file path where the download will be written
#' @export
make_pdf_dest <- function(url, subd = "") {
  fname <- basename(url)
  outf <- ifelse(grepl(fname, pattern = "pdf$"), fname, paste0(fname, ".pdf"))
  outf <- gsub(outf, pattern = " ", replacement = "_")
  if(!dir.exists(subd)) dir.create(subd, recursive = TRUE)
  dest <- file.path(subd, outf)
  return(dest)
}

#' Check if file exists and if so, if it is really a PDF
#'
#' @param f File to check
#' @return TRUE if file exists and is PDF, else FALSE
#' @export
file_check <- function(f) {
  if(file.exists(f)) {
    if(is_pdf(f)) {
      return(TRUE)
    }
    return(FALSE)
  }
  return(FALSE)
}

#' Test if a file is a pdf
#'
#' @details All PDFs should have an dictionary that contains information about
#' the key metadata about the document. This function uses
#' \link[pdftools]{pdf_info} to check if the downloaded file is, in fact, a PDF
#' because too often we get, e.g., an HTML status 404 download instead of the
#' desired PDF.
#'
#' @param f Path to a file to test
#' @return TRUE if pdftools::pdf_info thinks it's a PDF, else FALSE
#' @importFrom pdftools pdf_info
#' @export
is_pdf <- function(f) {
  if(file.exists(f)) {
    res <- suppressMessages(try(pdftools::pdf_info(f),
                                silent = TRUE))
    if(class(res) != "try-error") return(TRUE)
    return(FALSE)
  }
  return(FALSE)
}
