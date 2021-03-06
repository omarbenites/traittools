% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/traitformat_excel.R
\name{col_validation_trait}
\alias{col_validation_trait}
\title{Create conditional trait format into Fieldbook Spreadseet (Excel)}
\usage{
col_validation_trait(file, fbsheet, trait, trait_dict)
}
\arguments{
\item{file}{The name of the file which contains your data fieldbook data. It must be an .xlsx file}

\item{fbsheet}{The name of the fieldbook sheet into the excel file.}

\item{trait}{The abbreviation(s) of the trait(s) used in fieldbooks.}

\item{trait_dict}{The trait dictionary on crop ontology format.
(paint with colours) the trait column to identify out of range values.}
}
\value{
An excel file with conditional format according trait conditions
}
\description{
This function highlight all the values which are out of range in a fieldbook spreadsheet
}
