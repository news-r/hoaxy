
.onAttach <- function(...) {

  key <- Sys.getenv("RAPIDAPI_API_KEY")

  msg <- "No API key found, see `hoaxy_key`"
  if(nchar(key) > 1) msg <- "API key loaded!"

  packageStartupMessage(msg)

}