% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/call.R
\name{hx_edges}
\alias{hx_edges}
\title{Edges}
\usage{
hx_edges(ids, nodes_limit = 1000, include_user_mentions = FALSE)
}
\arguments{
\item{ids}{A list or vector of article ids to query, see \code{\link{hx_articles}}.}

\item{nodes_limit}{Network size limit by number of nodes. Default 1000. 
When nodes of network exceeds this parameter, a k-core algorithm is used to remove 
the least degree nodes and the associated edges.}

\item{include_user_mentions}{Whether to return user mentions.}
}
\description{
Return diffusion network (retweets, quotes, and optionally mentions). 
The direction of an edge indicates the flow of the claim. For a retweet, 
it goes from the original poster to the retweeter. For a mention, it 
goes from the account that is mentioning to the account that is mentioned.
}
\examples{
\dontrun{
articles <- hx_articles("pizzagate")
network <- hx_edges(articles$id[1:5])
}

}
