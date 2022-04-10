# RserverPkg
An R package based on the httpuv package for hosting javascript, html, css, etc. resources in a localhost environment (i.e. 127.0.0.1).  The purpose is to provide a barebones  server to perform R related data science and send the results to a html/javascript visualization such as [d3](https://d3js.org/).  

Two demonstrations are provided. The first is a simple demonstration where a csv flights file is requested and read using [data.table](https://rdatatable.gitlab.io/data.table/). The response is a json formatted string of the data frame's variable names displayed on an html page.

The second demonstrates how the httpuv based R server wrangles the same csv flights file to show a [d3](https://github.com/d3/d3) based histogram of arrival delays for various carriers. Along with d3, the server hosts a concise, neat index.html bundle using [Parcel](https://parceljs.org/).
