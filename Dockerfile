FROM rocker/verse
RUN R -e "install.packages(\"tidyverse\")"
RUN R -e "install.packages(\"matlab\")"
RUN R -e "install.packages(\"deSolve\")"
RUN R -e "install.packages(\"reticulate\")"
RUN apt update && apt-get install -y nodejs
RUN apt update && apt-get install -y python3-pip
RUN pip3 install --pre --user hy
RUN pip3 install sklearn jupyter jupyterlab
RUN R -e "install.packages(\"Rcpp\")"
RUN R -e "install.packages(\"rdist\")"
RUN R -e "install.packages(\"pgirmess\")"
RUN R -e "install.packages(\"gbm\")"
RUN R -e "install.packages(\"pROC\")"
RUN R -e "install.packages(\"MASS\")"
RUN R -e "install.packages(\"stats\")"
RUN R -e "install.packages(\"flextable\")"
RUN R -e "install.packages(\"gtsummary\")"
RUN R -e "install.packages(\"webshot\")"
RUN R -e "webshot::install_phantomjs(force = TRUE)"
RUN R -e "install.packages(\"caret\")"
RUN R -e "install.packages(\"e1071\")"
RUN R -e "install.packages(\"randomForest\")"
RUN R -e "install.packages(\"shiny\")"
RUN R -e "install.packages(\"PhantomJS\")"

