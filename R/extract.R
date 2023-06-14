#' Extract Specific Body Elements
#'
#' @param doc_list List. Output from [wu_read].
#' @param element Character. The elements you want to return.
#'
#' @return A list with an element for each instance of the desired element.
#'
#' @examples
#' path <- system.file("examples/simple.docx", package = "wordup")
#' body_list <- wu_read(path)
#' p_list <- wu_body(body_list, "p")
#' str(p_list, give.attr = FALSE, max.level = 1)
#'
#' @export
wu_body <- function(doc_list, element = c("p", "tbl")) {

  # TODO: input checks
  # TODO: should this just become part of the wu_p function?

  element <- match.arg(element)
  doc_body <- doc_list[["document"]][["body"]]
  doc_body[grep(paste0("^", element, "$"), names(doc_body))]

}

#' Extract All 'p' Body Text and Style to a Dataframe
#'
#' @param body_list List. Output from [wu_body].
#'
#' @return A data.frame with a row per 'p' element and columns with text and
#'     possibly style information.
#'
#' @examples
#' path <- system.file("examples/simple.docx", package = "wordup")
#' body_list <- wu_read(path)
#' p_list <- wu_body(body_list, "p")
#' head(wu_p(p_list))
#'
#' @export
wu_p <- function(body_list) {

  # TODO: input checks
  # TODO: should the wu_body element extraction code be integrated here?
  # TODO: iterate over all the p elements

  p_content <- vector("list", length = length(body_list))
  for (i in seq(body_list)) {

    p_text  <- body_list[[i]][["r"]][["t"]][[1]]
    p_style <- attr(body_list[[i]][["pPr"]][["pStyle"]], "val")
    has_p_style <- !is.null(p_style)
    # TODO: hyperlinks and other styling

    p_info <- data.frame(text = p_text, style = NA_character_)
    if (has_p_style) {
      p_info[["style"]] <- p_style
    }
    p_content[[i]] <- p_info

  }

  do.call("rbind", p_content)

}






