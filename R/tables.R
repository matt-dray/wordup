#' Convert a Copy-Pasted Word Table to Govspeak
#'
#' Provide a copied table from a Word document and be returned a Govspeak
#' Markdown version of it. Some post-editing may be necessary for more complex
#' tables.
#'
#' @param pasted_table Character. A single string that contains the content of
#'     a table copy and pasted from a Word document.
#' @param guess_types Logical. Should data types be guessed for each column
#'     based on their content? Defaults to `TRUE`. If `FALSE`, all columns will
#'     be returned as character type.
#' @param ignore_regex Character. A regular expression of strings to ignore
#'     when trying to guess column types.
#' @param has_row_titles Logical. Should the first column be treated as though
#'     it contains titles for each row? Defaults to `FALSE`. If `TRUE`, the
#'     first column will be marked-up as bold.
#' @param totals_rows Integer. A vector of indices to identify rows that
#'     contain totals. These will marked up as bold.
#' @param to_clipboard Logical. Should the output be copied to your clipboard?
#'     Defaults to `TRUE`.
#'
#' @return Character. A string that contains Govspeak Markdown that represents
#'     the copy-pasted table.
#'
#' @examples
#' pasted_table <- c("Column 1	Column 2	Column 3	Column 4	Column 5
#' X	100	1,000	1%	15
#' Y	200	2,000	2%	12
#' Z	300	3,000	3%	[c]")
#'
#' convert_table_to_md(pasted_table, to_clipboard = FALSE)
#'
#' @export
convert_table_to_md <- function(
    pasted_table = clipr::read_clip_tbl(),  # TODO: read off the clipboard with clipr::read_clip?
    guess_types = TRUE,
    ignore_regex = ",|%|\\[c\\]",
    has_row_titles = FALSE,
    totals_rows = NULL,
    to_clipboard = TRUE
) {

  guess_types_is_lgl <- inherits(guess_types, "logical")
  has_row_titles_is_lgl <- inherits(has_row_titles, "logical")
  clipboard_is_lgl <- inherits(to_clipboard, "logical")

  if (!guess_types_is_lgl | !guess_types_is_lgl | !clipboard_is_lgl) {
    cli::cli_abort(
      c(
        "Logical input was expected to arguments 'guess_types', 'has_row_titles' and 'clipboard'.",
        "i" = "Provide either TRUE or FALSE to these arguments.",
        "x" = "You provided {guess_types} to 'guess_types', {has_row_titles} to 'has_row_titles' and {clipboard} to 'clipboard'."
      )
    )
  }

  if (!is.null(totals_rows)) {

    totals_rows_is_num <- inherits(totals_rows, "integer")

    if (!totals_rows_is_num) {
      cli::cli_abort(
        c(
          "Argument 'totals_rows' must be of class integer",
          "i" = "Provide a vector of integers (whole numbers) to this argument, or leave empty.",
          "x" = "You provided an object of class {class(totals_rows)} to 'totals_rows'."
        )
      )
    }

  }

  # TODO: how check pasted_table input? basic check for \t and \n?

  rows <- strsplit(pasted_table, "\n")[[1]]
  cells <- lapply(rows, \(x) trimws(strsplit(x, "\t")[[1]]))
  dat <- do.call("rbind", cells[-1]) |> as.data.frame()
  names(dat) <- cells[[1]]

  if (!guess_types) {
    dat <- rbind(rep("-------", length(dat)), dat)
  }

  if (guess_types) {

    are_cols_num <- lapply(dat, \(x) gsub(ignore_regex, "", x)) |>
      utils::type.convert(as.is = TRUE) |>
      lapply(is.numeric)

    for (i in seq_along(are_cols_num)) {

      if (are_cols_num[[i]]) {
        are_cols_num[[i]] <- "------:"
      } else {
        are_cols_num[[i]] <- "-------"
      }

    }

    dat <- rbind(are_cols_num, dat)

  }

  # TODO: logic for has_row_titles
  # TODO: logic for totals_rows

  # Rearrange into vector for printing and copying
  vec <- character(length = nrow(dat) + 1)
  for (row in 1:nrow(dat)) {
    row_pasted <- paste0("|", paste0(dat[row, ], collapse = "|"), "|\n")
    vec[row + 1] <- row_pasted
  }
  vec[1] <- paste0("|", paste0(names(dat), collapse = "|"), "|\n")

  # Print to console
  cat(vec, sep = "")

  # Optionally copy to clipboard
  if (to_clipboard) {
    clipr::write_clip(vec, return_new = TRUE, breaks = "")
    message("The output table has been written to the clipboard.")
  }

  return(invisible(vec))

}
