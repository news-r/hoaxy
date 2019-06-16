BASE_URL <- "https://api-hoaxy.p.rapidapi.com"

.get_key <- function() {
  key <- Sys.getenv("RAPIDAPI_API_KEY")
  assert_that(nchar(key) > 0, msg = "Missing key")
  return(key)
}

.headers <- function(){
  httr::add_headers(
    `X-RapidAPI-Host` = "api-hoaxy.p.rapidapi.com",
    `X-RapidAPI-Key` = .get_key()
  )
}

.call_api <- function(..., endpoint) {
  url <- parse_url(BASE_URL)
  url$path <- endpoint
  url$query <- list(...)
  url <- build_url(url)
  response <- GET(url, .headers())
  stop_for_status(response)
  content(response)
}

.parse <- function(content, field){
  content[[field]] %>% 
    map_dfr(tibble::as_tibble)
}

.build_ids <- function(ids){
  ids <- unlist(ids) %>% 
    unname() %>% 
    paste0(collapse = ",") 
  
  paste0("[", ids, "]")
}

.parse_timeline <- function(tl){
  tl <- tl[["timeline"]]
  n <- names(tl)

  tl[[1]]$type <- n[[1]]
  tl[[2]]$type <- n[[2]]

  tl %>% map(
    function(x){
      map(x, unlist)
    }
  ) %>% 
  map_dfr(tibble::as_tibble)
}

.parse_latest <- function(articles){
  articles[["articles"]] %>% 
    map_dfr(function(x){
      x$site_tags <- list(x$site_tags)
      tibble::as_tibble(x)
    })
}