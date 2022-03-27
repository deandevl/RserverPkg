#' Function provides an http server that connects R language resources with javascript applications.
#'
#' @description The package is based on \href{https://cran.r-project.org/web/packages/httpuv/index.html}{httpuv::}.
#'  It is designed to host static resources such as html, javascript, css, etc along with specific route requests
#'  to perform various R based actions or respond with JSON formatted content.  The server is designed to work in a local
#'  host environment as part of an html/javascript project that needs a link to R language capabilities and its
#'  associated packages. As per the \code{httpuv::} documentation, the server can be stopped by calling
#'  \code{httpuv::stopServer(server=name_of_server)}. Also to list the current running server(s) call \code{httpuv::listServers()}.
#'
#' @param index_path A string that defines the full directory path to an \code{index.html} file defining the server's
#'   root path (i.e. "\"). The root html file is assumed to be named "index.html".
#' @param port An integer that defines the port number for the server. The default is 8080.
#' @param static_paths A named list where the string name references the web route (e.g. a web path "/assets", "/styles", "/html")
#'  and the corresponding string value references a \strong{full} static directory path. The server will host static
#'  resources (css, html, etc) in these directories.
#' @param routes A named list where the string name references specific web routes and the value references an R callback function
#'  that optionally returns a JSON formatted string for the response body. The callback should have a list argument where it will receive
#'  information on the request including the request method, body, type, and query string upon which it can act on.
#'
#' @import httpuv
#' @import jsonlite
#'
#' @return A \code{httpuv::WebServer}
#'
#' @author Rick Dean
#'
#' @export
create_server <- function(
  index_path = NULL,
  port = 8080,
  static_paths = NULL,
  routes = NULL
){

  index_file_path <- NULL
  index_raw_html <- NULL
  if(!is.null(index_path)){
    index_file_path <- paste0(index_path, "/index.html")
    index_raw_html <- paste(readLines(index_file_path), collapse = "\n")
  }else {
    stop("An index.html path has not been defined.")
  }

  static_paths_lst <- NULL
  if(!is.null(static_paths)){
    static_paths_lst <- list()
    static_routes <- names(static_paths)
    for(route in static_routes){
      static_paths_lst[[route]] = httpuv::staticPath(static_paths[[route]], indexhtml = FALSE)
    }
  }

  app <- list(
    call = function(req){
      req_path <- req$PATH_INFO
      if(req_path == "/"){
        return(
          list(
            status = 200L,
            headers = list("Content-Type" = "text/html"),
            body = index_raw_html
          )
        )
      }else if(!is.null(routes) & req_path %in% names(routes)) {
        req_lst <- list(
          path = req$PATH_INFO,
          method = req$REQUEST_METHOD,
          content_type = req$CONTENT_TYPE,
          body = paste0(req$rook.input$read_lines(),collapse = ""),
          query_string = req$QUERY_STRING
        )
        # body <- routes[[path]](req_lst)

        return(
          list(
            status = 200L,
            headers = list(
              'Content-Type' = 'text/plain',
              'Access-Control-Allow-Origin' = '*'
            ),
            body = routes[[req_path]](req_lst)
          )
        )
      }else {
        return (
          list(
            status = 404L,
            headers = list(
              "Content-Type" = "text/plain"
            ),
            body = "404 Not Found\n"
          )
        )
      }
    },
    staticPaths = static_paths_lst
  )

  return(httpuv::startServer(host = "127.0.0.1", port = port, app = app))
}

