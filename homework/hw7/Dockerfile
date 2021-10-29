FROM rocker/verse
RUN R -e "install.packages(\"tidyverse\")"
RUN R -e "install.packages(\"deSolve\")"
RUN R -e "install.packages(\"reticulate\")"
RUN apt update && apt-get install -y nodejs
RUN apt update && apt-get install -y python3-pip
RUN pip3 install --pre --user hy
RUN pip3 install sklearn
RUN R -e "install.packages(\"Rcpp\")"
