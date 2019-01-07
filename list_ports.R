list_ports = function () {
  sList <- ""
  .Tcl("package require platform")
  tk_platform <- tclvalue(.Tcl("lindex [split [platform::generic] -] 0"))
  if (.Platform$OS.type == "windows") {
    .Tcl("package require registry")
    regpath <- paste("HKEY_LOCAL_MACHINE", "HARDWARE", "DEVICEMAP", 
                     "SERIALCOMM", sep = "\\\\")
    ser_devs <- tclvalue(.Tcl(paste("registry values", regpath)))
    ser_devs <- strsplit(ser_devs, " ")[[1]]
    sList <- sapply(ser_devs, function(val) tclvalue(.Tcl(paste("registry get", 
                                                                regpath, val))))
    attr(sList, "names") <- NULL
  }
  if (.Platform$OS.type == "unix") {
    sList <- dir("/dev/", pattern = "tty[0SU.'ACM''USB']")
    if (tk_platform != "macosx") {
      w <- options(warn = -1)$warn
      p <- system("find /sys/ -iname tty\\* 2>/dev/null", 
                  intern = T)
      options(warn = w)
      p <- p[grep("pnp", p)]
      p <- lapply(strsplit(p, "/"), tail, 1)
      if (length(p[[1]]) == 0) 
        p <- 0
      else p <- unlist(p)
      p <- p[!duplicated(p)]
      if (sum(p %in% sList) > 0) 
        sList <- sList[sList %in% p]
    }
    message("Hint: On unix-systems the port list might be incomplete!")
  }
  if (length(sList) == 0) 
    sList <- ""
  return(sList[order(sList)])
}