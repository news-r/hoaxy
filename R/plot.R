#' @export
plot.hoaxy_edges <- function(x, ...) {
  
  nodes_from <- x %>% 
    dplyr::select(id = from_user_id, name = from_user_screen_name)

  nodes_to <- x %>% 
    dplyr::select(id = to_user_id, name = to_user_screen_name)

  nodes <- dplyr::bind_rows(nodes_from, nodes_to) %>% 
    dplyr::mutate(n_tweets = 1) %>% 
    dplyr::group_by(id, name) %>% 
    dplyr::summarize(n_tweets = sum(n_tweets)) %>% 
    dplyr::ungroup()
  
  x$edge_id <- 1:nrow(x)

  sigmajs() %>% 
    sg_nodes(nodes, id, label = name, size = n_tweets) %>% 
    sg_edges(x, id = edge_id, source = from_user_id, target = to_user_id) %>% 
    sg_scale_color(c("#247BA0", "#70C1B3", "#B2DBBF")) %>% 
    sg_layout() %>% 
    sg_settings(
      labelThreshold = 1000,
      edgeColor = "default",
      defaultEdgeColor = "#d3d3d3"
    )
}

globalVariables(
  c(
    "from_user_id",
    "from_user_screen_name",
    "to_user_id",
    "to_user_screen_name",
    "id",
    "name",
    "n_tweets",
    "edge_id"
  )
)