
# {wordup}

<!-- badges: start -->
[![Project Status: Concept – Minimal or no implementation has been done yet, or the repository is only intended to be a limited example, demo, or proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
<!-- badges: end -->

## Purpose

Convert a Microsoft Word document (docx) to [Govspeak Markdown](https://www.gov.uk/guidance/how-to-publish-on-gov-uk/markdown), which is the format required to publish on [GOV.UK](https://www.gov.uk/).

This package is a personal project for learning purposes. It may never be finished and has no guarantees.

## Motivation and scope

Producers of [statistical publications](https://www.gov.uk/search/research-and-statistics?content_store_document_type=statistics_published&order=updated-newest) might draft their reports in docx format. Publishers need to convert these to Govspeak Markdown so they can be uploaded to the Government's publishing platform. This can be time consuming to do manually and there is potential for error. There's a [Govspeak converter tool](https://govspeak-preview.publishing.service.gov.uk/), but there's some missing functionality.

## Related

There are existing packages that can convert [R Markdown](https://rmarkdown.rstudio.com/) to Govspeak: 
* [{govspeaker}](https://github.com/best-practice-and-impact/govspeakr) (archived)
* [{mojgovspeak}](https://github.com/moj-analytical-services/mojspeakr)
* [{rgovspeak}](https://github.com/Defra-Data-Science-Centre-of-Excellence/rgovspeak)

For handling Word documents in R:

* [{officer}](https://davidgohel.github.io/officer/) can read a Word document to a tidy table
* [{docxtractr}](https://github.com/hrbrmstr/docxtractr) can extract tables, comments and other things
