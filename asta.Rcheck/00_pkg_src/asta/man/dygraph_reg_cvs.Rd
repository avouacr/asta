% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fct_dygraph_reg_cvs.R
\name{dygraph_reg_cvs}
\alias{dygraph_reg_cvs}
\title{dygraph_reg_cvs}
\usage{
dygraph_reg_cvs(x, x_cvs)
}
\arguments{
\item{x}{une série temporelle}

\item{x_cvs}{la même série temporelle désaisonnalisée}
}
\value{
un graphique de type dygraph
}
\description{
Fonction qui renvoie deux séries sur un dygraph
}
\examples{
x <- airpass
y <- log(airpass)  
ycvs <- cvs_reg_desais(y)
xcvs <- exp(ycvs)
dygraph_reg_cvs(x,xcvs)
}
