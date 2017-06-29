FROM debian:stretch
MAINTAINER finlay@dragonfly.co.nz

RUN sed -i 's/deb\./ftp.nz./' /etc/apt/sources.list

RUN apt-get update \ 
	&& apt-get install -y --no-install-recommends \
		ed less locales vim-tiny wget ca-certificates fonts-texgyre \
	&& rm -rf /var/lib/apt/lists/*

RUN echo "en_NZ.UTF-8 UTF-8" >> /etc/locale.gen \
	&& locale-gen en_NZ.utf8 \
	&& /usr/sbin/update-locale LANG=en_NZ.UTF-8

ENV LC_ALL en_NZ.UTF-8
ENV LANG en_NZ.UTF-8

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
          curl gnupg dirmngr \
    && rm -rf /var/lib/apt/lists/*

RUN echo "deb http://cran.stat.auckland.ac.nz/bin/linux/debian stretch-cran34/" >> /etc/apt/sources.list.d/cran3.list
RUN apt-key adv --keyserver keys.gnupg.net --recv-key E19F5F87128899B192B1A2C2AD5F960A256A04AF

ENV R_BASE_VERSION 3.4.0

RUN apt-get update \
	&& apt-get install -y \
        r-base=${R_BASE_VERSION}* \
        r-base-dev=${R_BASE_VERSION}* \
        r-recommended=${R_BASE_VERSION}* \
        && echo 'options(repos = c(CRAN = "https://cran.stat.auckland.ac.nz/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site \
	&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir /shapes
RUN cd /shapes && curl http://naciscdn.org/naturalearth/110m/physical/ne_110m_land.zip -o temp.zip && unzip temp.zip && rm temp.zip

RUN apt-get update

RUN Rscript -e "install.packages('ggplot2')"
RUN apt-get install -y libgdal-dev
RUN Rscript -e "install.packages('rgdal')"
RUN Rscript -e "install.packages('rgeos')"

RUN rm -rf /var/lib/apt/lists/*

