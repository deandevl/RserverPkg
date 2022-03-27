library(httpuv)
library(data.table)
library(here)
library(jsonlite)
library(RserverPkg)

current_dir <- here()
index_path <- paste0(current_dir, "/demos/flight_server/www")
static_paths <- paste0(current_dir, "/demos/flight_server/www")
flights_file_path <- paste0(current_dir, "/demos/flight_server/flights/flights14.csv")

flight_column_names_fun <- function(req_info){
  flights_df <- data.table::fread(flights_file_path)
  flights_cols <- names(flights_df)
  return(jsonlite::toJSON(list("columnNames" = flights_cols)))
}

routes <- list("/flight_columns" = flight_column_names_fun)

flight_server <- RserverPkg::create_server(
  index_path = index_path,
  static_paths = static_paths,
  routes = routes
)

httpuv::listServers()

httpuv::stopServer(server = flight_server)
