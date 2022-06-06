# RserverPkg
An R package based on the httpuv package for hosting javascript, html, css, etc. resources in a localhost environment (i.e. 127.0.0.1).  The purpose is to provide a barebones  server to perform R related data science and send the results to popular html/javascript visualizations such as [d3](https://d3js.org/) and [Vue framework](https://vuejs.org/).  

Three demonstrations are provided. The first is a simple demonstration where a csv flights file is requested and read using [data.table](https://rdatatable.gitlab.io/data.table/). The response is a json formatted string of the data frame's variable (column) names displayed on an html page. To start the server  (named flight_server)--- in an R console run: 

```
RserverPkg/demos/flight_server/flight_server.R
```

The server will start with a short message saying that it is listening on port 8080.  From any browser enter the address 127.0.0.1:8080 to see the hosted index.html. Click the button to start a javascript GET Fetch request for the variable names of the csv file.

The second demonstrates how the httpuv based R server wrangles the same csv flights file to show a [d3](https://github.com/d3/d3) based histogram of arrival delays for various carriers. Along with d3, the server hosts a concise, neat `index.html` in the `prod` directory using the [Parcel](https://parceljs.org/) bundler. To start the server (named `airline_server`) --- in an R console run:

```
RserverPkg/demos/airline_server_d3/airline_server.R
```

Again, from any browser enter the address 127.0.0.1:8080 to see the hosted index.html. You can select and compare the histograms of two separate carriers as to their arrival delays. You can also adjust the maximum/minimum extent of the arrival times as well as the number of bins for the histogram.

The third demonstrates how the httpuv based R server responds to a specific http address without an index.html being hosted.  To start the server (named `say_hello_server`) - - in an R console run:

```
RserverPkg/demos/no_html/say_hello_server.R
```

From any browser enter the address 127.0.0.1:5555/say_hello?name=Rick. The server will respond to the request with "Hello Rick" in the browser.

### Additional Points:

The `Server.R` file implements an httpuv type server in the form of an [R6](https://r6.r-lib.org/) class that encapsulates object-oriented programming.  Its class constructor provides arguments for setting the index.html path, port number, routes, and static paths to be hosted.  In addition there are public methods for starting, stopping, and listing the current running servers.  The demo folders illustrate various ways of configuring the `Server` class. 

