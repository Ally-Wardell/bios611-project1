
FROM rocker/verse
RUN R -e "install.packages(\"tidyverse\")"
RUN R -e "install.packages(\"matlab\")"
RUN R -e "install.packages(\"deSolve\")"
RUN R -e "install.packages(\"reticulate\")"
RUN apt update && apt-get install -y nodejs
RUN apt update && apt-get install -y python3-pip
RUN pip3 install --pre --user hy
RUN pip3 install sklearn
RUN pip3 install jupyter jupyterlab
RUN R -e "install.packages(\"Rcpp\")"
RUN R -e "install.packages(\"rdist\")"
RUN R -e "install.packages(\"pgirmess\")"
RUN R -e "install.packages(\"gbm\")"
RUN R -e "install.packages(\"pROC\")"
RUN R -e "install.packages(\"MASS\")"
RUN R -e "install.packages(\"stats\")"



FROM rocker/verse
RUN R -e "install.packages(\"tidyverse\")"
RUN R -e "install.packages(\"matlab\")"
RUN R -e "install.packages(\"deSolve\")"
RUN R -e "install.packages(\"reticulate\")"
RUN apt update && apt-get install -y nodejs
RUN apt update && apt-get install -y python3-pip
RUN pip3 install --pre --user hy
RUN pip3 install sklearn
RUN R -e "install.packages(\"Rcpp\")"
RUN R -e "install.packages(\"rdist\")"
RUN R -e "install.packages(\"fields\")"
RUN R -e "install.packages(\"ggrepel\")"


