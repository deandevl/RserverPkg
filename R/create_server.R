#' Function provides an http server that connects R language resources with javascript applications.
#'
#' @description The package is based on \href{https://cran.r-project.org/web/packages/httpuv/index.html}{httpuv::}.
#'  It is designed to host static resources such as html, javascript, css, etc along with specific route requests
#'  to perform various R based actions or respond with various content(i.g. JSON strings, images, etc).  The server
#'  is designed to work in a local host environment (i.e. url = 127.0.0.1) as part of an html/javascript project that
#'  needs a link to R language capabilities and its associated packages. As per the \code{httpuv::} documentation, the
#'  server can be stopped by calling \code{httpuv::stopServer(server=name_of_server)}. Also to list the current running
#'  server(s) call \code{httpuv::listServers()}.
#'
#' @param index_path A string that defines the full directory path to an \code{index.html} file defining the server's
#'   root path (i.e. "\"). The root html file is assumed to be named "index.html".
#' @param port An integer that defines the port number for the server. The default is 8080.
#' @param routes A vector of \code{RserverPkg::Route} objects that define the request paths that the server will respond to.
#'   Each \code{RserverPkg::Route} object should define the path, callback function that optionally returns content, and the
#'   content's MIME content type. The callback function can be defined to receive a \code{RserverPkg::Request} object argument.
#' @param static_paths A named list that defines the locations of static resources (.css, .html, .js files) for hosting by the
#'   server. The list name is the web path (e.g. "/content") and the value is the full directory path to the resources
#'   (e.g. F:/web_server/content).
#'
#' @import httpuv
#'
#' @return A \code{httpuv::WebServer}
#'
#' @author Rick Dean
#'
#' @export
create_server <- function(
  index_path = NULL,
  port = 8080,
  routes = NULL,
  static_paths = NULL
){
  static_path_lst <- NULL
  if(!is.null(index_path)) {
    static_path_lst <- list(
      "/" = httpuv::staticPath(index_path, indexhtml = TRUE, fallthrough = TRUE)
    )
  }else {
    stop("An index.html path has not been defined.")
  }

  if(!is.null(static_paths)){
    web_path_names <- names(static_paths)
    for(path in web_path_names){
      static_path_lst[[path]] = httpuv::staticPath(static_paths[[path]], indexhtml = FALSE)
    }
  }

  routes_lst <- list()
  if(!is.null(routes)){
    for(route in routes){
      routes_lst[[route$path]] <- list("handler" = route$handler, "content_type" = route$content_type)
    }
  }

  app <- list(
    call = function(req){
      req_path <- req$PATH_INFO

      if(!is.null(routes) & req_path %in% names(routes_lst)) {
        query_final_lst <- list()

        if(nchar(req$QUERY_STRING) > 1){
          query_str <- substring(req$QUERY_STRING,2)
          query_lst <- strsplit(query_str, "&", fixed = TRUE)[[1]]

          for(i in seq_along(query_lst)){
            parts <- strsplit(query_lst[[i]], "=", fixed = TRUE)[[1]]
            query_final_lst[parts[[1]]] <- parts[[2]]
          }
        }

        request_info <- RserverPkg::Request$new(
          path = req$PATH_INFO,
          method = req$REQUEST_METHOD,
          content_type = req$CONTENT_TYPE,
          body = paste0(req$rook.input$read_lines(),collapse = ""),
          query_list = query_final_lst
        )
        route <- routes_lst[[req_path]]

        return(
          list(
            status = 200L,
            headers = list(
              'Content-Type' = route$content_type
            ),
            body = route$handler(request_info)
          )
        )
      }else {
        return (
          list(
            status = 404L,
            headers = list(
              "Content-Type" = "text/plain"
            ),
            body = paste0("404 Not Found: ", req_path)
          )
        )
      }
    },
    staticPaths = static_path_lst
  )

  print(paste0("Server is listening on port ", port))

  return(httpuv::startServer(host = "127.0.0.1", port = port, app = app))
}

