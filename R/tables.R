#' Convert a Copy-Pasted Word Table to Govspeak
#'
#' Provide a copied table from a Word document and be returned a Govspeak
#' Markdown version of it. Some post-editing may be necessary for more complex
#' tables.
#'
#' @param word_table Character. A table copy-pasted from a Microsoft Word
#'     document. If `NULL` (default) the table will be read from the clipboard
#'     so that you don't have to paste it.
#' @param guess_types Logical. Should data types be guessed for each column
#'     based on their content? Defaults to `TRUE`. If `FALSE`, all columns will
#'     be returned as character type.
#' @param ignore_regex Character. A regular expression of strings to ignore
#'     when trying to guess column types. See details.
#' @param has_row_titles Logical. Should the first column be treated as though
#'     it contains titles for each row? Defaults to `FALSE`. If `TRUE`, the
#'     first column will be marked-up as bold.
#' @param totals_rows Integer. A vector of indices to identify rows that
#'     contain totals. These will marked up as bold.
#' @param to_clipboard Logical. Should the output be copied to your clipboard?
#'     Defaults to `TRUE`.
#'
#' @details
#' If `guess_types` is `TRUE`, then [utils::type.convert()] is used to coerce
#' each column to the appropriate data type. For example, a column containing
#' numbers will be coerced to `numeric`. This will fail if the numbers in a
#' given column are formatted to contain non-numeric characters, like '1,234'
#' (comma) or '10%' (percentage symbol). Use `ignore_regex` so that the process
#' of guessing the data types will ignore these characters.
#'
#' @return Character. A string that contains Govspeak Markdown that represents
#'     the copy-pasted table.
#'
#' @examples
#' word_table <- c(
#'   "Column 1	Column 2	Column 3	Column 4	Column 5
#'   X	100	1,000	1%	15
#'   Y	200	2,000	2%	12
#'   Z	300	3,000	3%	[c]"
#' )
#'
#' convert_table_to_md(word_table, to_clipboard = FALSE)
#'
#' @export
convert_table_to_md <- function(
    word_table = NULL,
    guess_types = TRUE,
    ignore_regex = ",|%|\\[.\\]",
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

  # TODO: how check word_table input? basic check for \t and \n?

  if (is.null(word_table)) {
    rows <- clipr::read_clip()
  }

  if (!is.null(word_table)) {
    rows <- strsplit(word_table, "\n")[[1]]
  }

  cells <- lapply(rows, \(x) trimws(strsplit(x, "\t")[[1]]))
  dat <- do.call("rbind", cells[-1]) |> as.data.frame()
  names(dat) <- cells[[1]]

  if (!is.null(totals_rows)) {
    for (row in totals_rows) {
      dat[row, ] <- paste0("**", dat[row, ], "**")
    }
  }

  if (has_row_titles) {
    dat[[1]] <- paste("#", dat[[1]])
  }

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

  # Rearrange into vector for printing and copying
  vec <- character(length = nrow(dat) + 1)
  for (row in 1:nrow(dat)) {
    row_pasted <- paste0("| ", paste0(dat[row, ], collapse = " | "), " |\n")
    vec[row + 1] <- row_pasted
  }
  vec[1] <- paste0("| ", paste0(names(dat), collapse = " | "), " |\n")

  # Print to console
  cat(vec, sep = "")

  # Optionally copy to clipboard
  if (to_clipboard) {
    clipr::write_clip(vec, return_new = TRUE, breaks = "")
    message("The output table has been written to the clipboard.")
  }

  return(invisible(vec))

}
