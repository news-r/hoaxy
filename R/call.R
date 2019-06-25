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
#' @export
hx_tweets <- function(ids){
  assert_that(!missing(ids), msg = "Missing ids")
  ids <- .build_ids(ids)
  tweets <- .call_api(ids = ids, endpoint = "tweets")
  .parse(tweets, "tweets")
}

#' Edges
#'
#' Return diffusion network (retweets, quotes, and optionally mentions). 
#' The direction of an edge indicates the flow of the claim. For a retweet, 
#' it goes from the original poster to the retweeter. For a mention, it 
#' goes from the account that is mentioning to the account that is mentioned.
#'
#' @param ids A list or vector of article ids to query, see \code{\link{hx_articles}}.
#' @param nodes_limit Network size limit by number of nodes. Default 1000. 
#' When nodes of network exceeds this parameter, a k-core algorithm is used to remove 
#' the least degree nodes and the associated edges.
#' @param include_user_mentions Whether to return user mentions.
#'
#' @examples
#' \dontrun{
#' articles <- hx_articles("pizzagate")
#' network <- hx_edges(articles$id[1:5])
#' }
#'
#' @export
hx_edges <- function(ids, nodes_limit = 1000, include_user_mentions = FALSE){
  assert_that(!missing(ids), msg = "Missing ids")
  ids <- .build_ids(ids)
  edges <- .call_api(ids = ids, nodes_limit = nodes_limit, include_user_mentions = include_user_mentions, endpoint = "network")
  edges <- .parse(edges, "edges")
  structure(edges, class = c(class(edges), "hoaxy_edges"))
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
#' @export
hx_timeline <- function(ids, resolution = c("D", "M", "W", "H")){
  assert_that(!missing(ids), msg = "Missing ids")
  ids <- .build_ids(ids)
  tl <- .call_api(ids = ids, resolution = match.arg(resolution), endpoint = "timeline")
  .parse_timeline(tl)
}

#' Spreaders
#'
#' Return top 20 most active user for the last 30 days.
#'
#' @param upper_day When calculating the most active users, we consider a 30 days window. 
#' The right bound controls the position of the window and it is called \code{upper_day}, 
#' e.g., if \code{upper_day} is set to \code{2016-12-01}, then the window ranges between 
#' \code{2016-11-01} and \code{2016-12-01}. Input format is \code{yyyy-mm-dd}, and the 
#' default value is the date of yesterday. Note that the endpoint does not accept any 
#' input more recent than the date of yesterday. Also currently the minimal upper_day value is \code{2016-12-12}.
#' @param most_recent When set to \code{TRUE}, return most recent available top spreaders, if there is no top spreaders for \code{upper_day}.
#'
#' @examples
#' \dontrun{
#' hx_spreaders()
#' }
#'
#' @export
hx_spreaders <- function(upper_day = NULL, most_recent = FALSE){
  users <- .call_api(upper_day = upper_day, most_recent = most_recent, endpoint = "top-users")
  .parse(users, "spreaders")
}

#' Top Articles
#'
#' Return top 20 most active user for the last 30 days.
#'
#' @param upper_day When calculating the most active users, we consider a 30 days window. 
#' The right bound controls the position of the window and it is called \code{upper_day}, 
#' e.g., if \code{upper_day} is set to \code{2016-12-01}, then the window ranges between 
#' \code{2016-11-01} and \code{2016-12-01}. Input format is \code{yyyy-mm-dd}, and the 
#' default value is the date of yesterday. Note that the endpoint does not accept any 
#' input more recent than the date of yesterday. Also currently the minimal upper_day value is \code{2016-12-12}.
#' @param most_recent When set to \code{TRUE}, return most recent available top spreaders, if there is no top spreaders for \code{upper_day}.
#' @param exclude_tags Use double quote around excluded tags to make sure the URL encoding works on Mashape. 
#' This parameter controls the filtering of the returned results by excluded tags. 
#' The tags could be either in format of a list of strings, e.g., \code{list("fake", "satire")}. 
#' In the latter case, the first element in the tuple indicates the name of the source that tagged the website. 
#' Please refer to the Hoaxy FAQ for sources.
#' 
#' @examples
#' \dontrun{
#' hx_top_articles()
#' }
#'
#' @export
hx_top_articles <- function(upper_day = NULL, most_recent = FALSE, exclude_tags = NULL){
  if(!is.null(exclude_tags)) exclude_tags <- .build_ids(exclude_tags)
  articles <- .call_api(upper_day = upper_day, most_recent = most_recent, exclude_tags = exclude_tags, endpoint = "top-articles")
  .parse(articles, "articles")
}

#' Top Articles
#'
#' Return top 20 most active user for the last 30 days.
#'
#' @param past_hours Hours from "now" (\code{Sys.time()}), you are suggested to start this number from 2 as servers are not real time.
#' @param domains Return articles restrained to these domains. Default is None, return all available articles. 
#' If \code{fact_checking}, return only fact checking articles. If \code{claim}, return only claim articles. 
#' If \code{fake}, return articles from sites marking as fake by our configuration. You can also input a domain list. 
#' 
#' @examples
#' \dontrun{
#' hx_latest_articles()
#' }
#'
#' @export
hx_latest_articles <- function(past_hours = 2, domains = NULL){
  if(!is.null(domains)) domains <- .build_ids(domains)
  latest <- .call_api(past_hours = past_hours, domains = domains, endpoint = "latest-articles")
  .parse_latest(latest)
}