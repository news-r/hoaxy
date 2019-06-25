#' Setup
#' 
#' Setup your session, all subsequent calls will be done using the API key.
#'
#' @param key Your API key, freely available at \url{https://rapidapi.com/}.
#' 
#' @note You can specify \code{RAPIDAPI_API_KEY} as environment variable, likely in your \code{.Renviron} file.
#' 
#' @examples
#' \dontrun{
#' newsapi_key("xXXxxXxXxXXx")  
#' }
#' 
#' @import sigmajs
#' @import purrr
#' @import httr
#' @import assertthat
#' 
#' @export
hoaxy_key <- function(key){
  assert_that(!missing(key), msg = "Missing key")
  Sys.setenv(RAPIDAPI_API_KEY = key)
}