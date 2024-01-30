
<!-- README.md is generated from README.Rmd. Please edit that file -->

# {wordup}

<!-- badges: start -->

[![Project Status: Concept – Minimal or no implementation has been done
yet, or the repository is only intended to be a limited example, demo,
or
proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
[![R-CMD-check](https://github.com/matt-dray/wordup/workflows/R-CMD-check/badge.svg)](https://github.com/matt-dray/wordup/actions)
[![Blog
post](https://img.shields.io/badge/rostrum.blog-post-008900?labelColor=000000&logo=data%3Aimage%2Fgif%3Bbase64%2CR0lGODlhEAAQAPEAAAAAABWCBAAAAAAAACH5BAlkAAIAIf8LTkVUU0NBUEUyLjADAQAAACwAAAAAEAAQAAAC55QkISIiEoQQQgghRBBCiCAIgiAIgiAIQiAIgSAIgiAIQiAIgRAEQiAQBAQCgUAQEAQEgYAgIAgIBAKBQBAQCAKBQEAgCAgEAoFAIAgEBAKBIBAQCAQCgUAgEAgCgUBAICAgICAgIBAgEBAgEBAgEBAgECAgICAgECAQIBAQIBAgECAgICAgICAgECAQECAQICAgICAgICAgEBAgEBAgEBAgICAgICAgECAQIBAQIBAgECAgICAgIBAgECAQECAQIBAgICAgIBAgIBAgEBAgECAgECAgICAgICAgECAgECAgQIAAAQIKAAAh%2BQQJZAACACwAAAAAEAAQAAAC55QkIiESIoQQQgghhAhCBCEIgiAIgiAIQiAIgSAIgiAIQiAIgRAEQiAQBAQCgUAQEAQEgYAgIAgIBAKBQBAQCAKBQEAgCAgEAoFAIAgEBAKBIBAQCAQCgUAgEAgCgUBAICAgICAgIBAgEBAgEBAgEBAgECAgICAgECAQIBAQIBAgECAgICAgICAgECAQECAQICAgICAgICAgEBAgEBAgEBAgICAgICAgECAQIBAQIBAgECAgICAgIBAgECAQECAQIBAgICAgIBAgIBAgEBAgECAgECAgICAgICAgECAgECAgQIAAAQIKAAA7)](https://www.rostrum.blog/2023/06/21/wordup-tables/)
<!-- badges: end -->

## Purpose

Convert a Microsoft Word document (docx) to [Govspeak
Markdown](https://www.gov.uk/guidance/how-to-publish-on-gov-uk/markdown),
which is the format required to publish on
[GOV.UK](https://www.gov.uk/).

This package is a personal project for learning purposes. It may never
be finished and has no guarantees.

You may also be interested in [a demo Shinylive app](https://matt-dray.github.io/govspeakify-tables/) for [converting tables to Govspeak format](https://www.rostrum.blog/posts/2023-10-08-govspeakify-tables/).

## Motivation and scope

Producers of [statistical
publications](https://www.gov.uk/search/research-and-statistics?content_store_document_type=statistics_published&order=updated-newest)
might draft their reports in docx format. Publishers need to convert
these to Govspeak Markdown so they can be uploaded to the Government’s
publishing platform. This can be time consuming to do manually and there
is potential for error. There’s a [Govspeak converter
tool](https://govspeak-preview.publishing.service.gov.uk/), but there’s
some missing functionality, such as handling images and tables.

## Installation

The package is available from GitHub. It isn’t stable.

``` r
install.packages("remotes")  # if not yet installed
remotes::install_github("matt-dray/wordup")
```

Here’s the list structure of an example `word/document.xml` from an
unzipped docx file.

``` r
library(wordup)
path <- system.file("examples/simple.docx", package = "wordup")
body_list <- wu_read(path)
str(body_list, give.attr = FALSE, max.level = 3)
# List of 1
#  $ document:List of 1
#   ..$ body:List of 15
#   .. ..$ p     :List of 2
#   .. ..$ p     :List of 3
#   .. ..$ p     :List of 5
#   .. ..$ p     :List of 3
#   .. ..$ p     :List of 1
#   .. ..$ p     :List of 2
#   .. ..$ p     :List of 2
#   .. ..$ p     :List of 3
#   .. ..$ p     :List of 1
#   .. ..$ tbl   :List of 5
#   .. ..$ p     :List of 3
#   .. ..$ p     :List of 4
#   .. ..$ p     :List of 1
#   .. ..$ p     :List of 1
#   .. ..$ sectPr:List of 4
```

We can delve into this structure to retrieve text, etc.

``` r
body_list$document$body[[5]]
# $r
# $r$t
# $r$t[[1]]
# [1] "This is some more text. This time with bullets:"
# 
# 
# 
# attr(,"paraId")
# [1] "2460A889"
# attr(,"textId")
# [1] "3361B78B"
# attr(,"rsidR")
# [1] "007D458C"
# attr(,"rsidRDefault")
# [1] "007D458C"
```

Hopefully {wordup} will get functions to grab text and styles, apply
Govspeak styling and then output a Markdown file. It could also convert
images to SVG and insert anchor links for them.

## Related

There are existing packages that can convert [R
Markdown](https://rmarkdown.rstudio.com/) to Govspeak:

- [{govspeaker}](https://github.com/best-practice-and-impact/govspeakr)
  (archived)
- [{mojgovspeak}](https://github.com/moj-analytical-services/mojspeakr)
- [{rgovspeak}](https://github.com/Defra-Data-Science-Centre-of-Excellence/rgovspeak)

For handling Word documents in R:

- [{officer}](https://davidgohel.github.io/officer/) can read a Word
  document to a tidy table
- [{docxtractr}](https://github.com/hrbrmstr/docxtractr) can extract
  tables, comments and other things
