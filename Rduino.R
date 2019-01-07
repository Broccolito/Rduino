#https://www.mathworks.com/help/supportpkg/arduinoio/setup-and-configuration.html
#Try to create a R interface that has the basic functionality that MATLAB provides

if(!require("rstudioapi")){
  install.packages("rstudioapi")
  library("rstudioapi")
}
if(!require("reticulate")){
  install.packages("reticulate")
  library("reticulate")
}
if(!require("serial")){
  install.packages("serial")
  library("serial")
}

get_directory = function(){
  args <- commandArgs(trailingOnly = FALSE)
  file <- "--file="
  rstudio <- "RStudio"

  match <- grep(rstudio, args)
  if(length(match) > 0){
    return(dirname(rstudioapi::getSourceEditorContext()$path))
  }else{
    match <- grep(file, args)
    if (length(match) > 0) {
      return(dirname(normalizePath(sub(file, "", args[match]))))
    }else{
      return(dirname(normalizePath(sys.frames()[[1]]$ofile)))
    }
  }
}

#Convert to serial connector
connect_to = function(port){
  converter$Arduino(port)
}

#Get the home path of the directory
#It is just a d
home_path = get_directory()

converter = import_from_path("pyfirmata", path = home_path)

#List all availeble ports
#Usually Arduino ports are the ones appear later.
available_ports = listPorts()

tryCatch({
  connect_to(available_ports[length(available_ports)])
}, error = function(e){
  print("Check your Connection...")
})


