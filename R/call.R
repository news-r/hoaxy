#' Articles
#'
#' Return fake news matching query.
#'
#' @param q Keywords to search in Lucene query syntax is supported, e.g., \code{+title:Trump}. 
#' Available field names are \code{title}, \code{meta}, \code{content}, \code{canonical_url} and \code{date_published}. 
#' The field date_published is saved as text \code{yyyy-mm-ddThh:mm:ss}, you can use a termrangefilter on this field, 
#' e.g., the string \code{'pizzagate AND date_published:[2016-10-28 TO 2016-12-04]'} will query documents with any 
#' fields contain pizzagate and the date_published is between \code{2016-10-28} to \code{2016-12-04}. 
#' @param sort_by Choices are \code{relevant} \code{recent}. Specify how to sort the result, by the most relevant or recent
#'
#'
#' @examples
#' \dontrun{
#' articles <- hx_articles("pizzagate")
#' }
#'
#' @rdname count
#' @export
hx_articles <- function(q, sort_by = c("recent", "relevant")){
  assert_that(!missing(q), msg = "Missing q")
  content <- .call_api(query = q, use_lucene_syntax = TRUE, sort_by = match.arg(sort_by), endpoint = "articles")
  .parse(content, "articles")
}

#' Tweets
#'
#' Return tweets on specific fake articles.
#'
#' @param ids A list or vector of article ids to query, see \code{\link{hx_articles}}.
#'
#' @examples
#' \dontrun{
#' articles <- hx_articles("pizzagate")
#' tweets <- hx_tweets(articles$id[1:5])
#' }
#'
#' @rdname count
#' @export
hx_tweets <- function(ids){
  assert_that(!missing(ids), msg = "Missing ids")
  ids <- .build_ids(ids)
  tweets <- .call_api(ids = ids, endpoint = "tweets")
  .parse(tweets, "tweets")
}

#' Edges
#'
#' Returns edges of tweets surrounding given articles.
#'
#' @param ids A list or vector of article ids to query, see \code{\link{hx_articles}}.
#' @param nodes_limit Network size limit by number of nodes. Default 1000. 
#' When nodes of network exceeds this parameter, a k-core algorithm is used to remove 
#' the least degree nodes and the associated edges.
#'
#'
#' @examples
#' \dontrun{
#' articles <- hx_articles("pizzagate")
#' network <- hx_edges(articles$id[1:5])
#' }
#'
#' @rdname count
#' @export
hx_edges <- function(ids, nodes_limit = 1000, include_user_mentions = FALSE){
  assert_that(!missing(ids), msg = "Missing ids")
  ids <- .build_ids(ids)
  edges <- .call_api(ids = ids, nodes_limit = nodes_limit, include_user_mentions = include_user_mentions, endpoint = "network")
  .parse(edges, "edges")
}

#' Timeline
#'
#' Return timeline of tweets on given articles.
#'
#' @param ids A list or vector of article ids to query, see \code{\link{hx_articles}}.
#' @param resolution The resolution of timeline. \code{H}: hour, \code{D}: day, \code{W}: week, \code{M}: month.
#'
#' @examples
#' \dontrun{
#' articles <- hx_articles("pizzagate")
#' tl <- hx_timeline(articles$id[1:5])
#' }
#'
#' @rdname count
#' @export
hx_timeline <- function(ids, resolution = c("D", "M", "W", "H")){
  assert_that(!missing(ids), msg = "Missing ids")
  ids <- .build_ids(ids)
  tl <- .call_api(ids = ids, resolution = match.arg(resolution), endpoint = "timeline")
  .parse_timeline(tl)
}

