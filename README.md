# RserverPkg
An R package based on the httpuv package for hosting javascript, html, css, etc. resources in a localhost environment (i.e. 127.0.0.1).  The purpose is to provide a barebones  server to perform R related data science and send the results to a html/javascript visualization such as [d3](https://d3js.org/).  

Two demonstrations are provided. The first is a simple demonstration where a csv flights file is requested and read using [data.table](https://rdatatable.gitlab.io/data.table/). The response is a json formatted string of the data frame's variable names displayed on an html page. To start the server  (named flight_server)--- in an R console run: 

```
RserverPkg/demos/flight_server/flight_server.R
```

The server will start with a short message saying that it is listening on port 8080.  From any browser enter the address 127.0.0.1:8080 to see the hosted index.html. Click the button to start a javascript GET Fetch request for the variable names of the csv file.

The second demonstrates how the httpuv based R server wrangles the same csv flights file to show a [d3](https://github.com/d3/d3) based histogram of arrival delays for various carriers. Along with d3, the server hosts a concise, neat index.html bundle using [Parcel](https://parceljs.org/). To start the server (named airline_server) --- in an R console run:

```
RserverPkg/demos/airline_server_d3/airline_server.R
```

Again, from any browser enter the address 127.0.0.1:8080 to see the hosted index.html. You can select and compare the histograms of two separate carriers as to their arrival delays. You can also adjust the maximum/minimum extent of the arrival times as well as the number of bins for the histogram.

To list the current running servers enter:

```
httpuv::listServers()
```

To stop the current running server enter the following:

```
httpuv::stopServer(server = "name of the server")
```

