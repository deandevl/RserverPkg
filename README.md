# RserverPkg
An R package based on the httpuv package for hosting javascript, html, css, etc. resources in a localhost environment.  The purpose is to provide a barebones  server to perform R related data science and send the results to a html/javascript visualization such as [d3](https://d3js.org/).  

A simple demonstration of the package is provided where a csv file is requested and read using [data.table](https://rdatatable.gitlab.io/data.table/). The response is a json formatted string of variable names displayed on an html page.
