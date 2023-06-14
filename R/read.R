#' Read a Word File to a List
#'
#' Unzips a docx file, reads the XML from `/word/document.xml` and converts it
#' to a list object for further processing.
#'
#' @param docx_path Character. A path to a docx file.
#'
#' @return A nested list.
#'
#' @examples
#' path <- system.file("examples/simple.docx", package = "wordup")
#' body_list <- wu_read(path)
#' str(body_list, give.attr = FALSE, max.level = 3)
#'
#' @export
wu_read <- function(docx_path) {

  is_chr <- inherits(docx_path, "character")
  is_len_1 <- length(docx_path) == 1
  is_empty <- nchar(docx_path) == 0

  if (!is_chr | !is_len_1 | is_empty) {
    cli::cli_abort(
      c(
        "The path is not a single value of character type.",
        "i" = "Provide a single character path to a docx file.",
        "x" = "You provided a {class(docx_path)} object of length {length(docx_path)}."
      )
    )
  }

  docx_fs <- fs::as_fs_path(docx_path)
  docx_exists <- fs::file_exists(docx_fs)

  if (!docx_exists) {
    cli::cli_abort(
      c(
        "The file path can't be found.",
        "i" = "Check the filepath and try again.",
        "x" = "You provided path {docx_fs}."
      )
    )
  }

  temp <- tempdir()
  utils::unzip(zipfile = docx_fs, exdir = temp)
  doc_xml <- xml2::read_xml(file.path(temp, "word", "document.xml"))
  unlink(temp)
  doc_list <- xml2::as_list(doc_xml)
  doc_list

}
