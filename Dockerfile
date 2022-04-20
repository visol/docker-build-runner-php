FROM php:8.1.5-cli
MAINTAINER Jonas Renggli <jonas.renggli@visol.ch>

RUN apt-get update \
    && apt-get full-upgrade -y \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y \
        git \
        wget \
        unzip \
        p7zip-full \
        rsync \
        openssh-client \
        gnupg \
    && rm -rf /var/lib/apt/lists/*
RUN apt-key adv --refresh-keys --keyserver keyserver.ubuntu.com

# soap
RUN buildRequirements="libxml2-dev" \
    && apt-get update && apt-get install -y ${buildRequirements} \
    && docker-php-ext-install soap \
    && apt-get purge -y ${buildRequirements} \
    && rm -rf /var/lib/apt/lists/*

# gd
RUN buildRequirements="libpng-dev libjpeg-dev libfreetype6-dev" \
    && apt-get update && apt-get install -y ${buildRequirements} \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include \
    && docker-php-ext-install gd \
    && rm -rf /var/lib/apt/lists/*

# intl
RUN buildRequirements="libicu-dev g++" \
    && apt-get update && apt-get install -y ${buildRequirements} \
    && docker-php-ext-install intl \
    && apt-get purge -y ${buildRequirements} \
    && runtimeRequirements="libicu63" \
    && apt-get install -y --auto-remove ${runtimeRequirements} \
    && rm -rf /var/lib/apt/lists/*

# zip
RUN buildRequirements="zlib1g-dev libzip-dev" \
    && apt-get update && apt-get install -y ${buildRequirements} \
    && docker-php-ext-install zip \
    && apt-get purge -y ${buildRequirements} \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://raw.githubusercontent.com/composer/getcomposer.org/76a7060ccb93902cd7576b67264ad91c8a2700e2/web/installer -O - -q | php -- --filename=composer --install-dir=/usr/bin

RUN mkdir /tmp/ec &&\
    wget -O /tmp/ec/ec-linux-amd64.tar.gz https://github.com/editorconfig-checker/editorconfig-checker/releases/download/2.3.5/ec-linux-amd64.tar.gz &&\
    tar -xvzf /tmp/ec/ec-linux-amd64.tar.gz &&\
    mv bin/ec-linux-amd64 /usr/bin/ec &&\
    rm -rf /tmp/ec

RUN echo 'export PATH=~/.composer/vendor/bin:$PATH' >> ~/.bashrc
RUN composer global require "squizlabs/php_codesniffer=*"

# node.js, npm
RUN apt-get update \
    && apt-get install -y \
        gnupg \
    && rm -rf /var/lib/apt/lists/* \
    && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get update \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y yarn \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g grunt-cli bower

RUN apt-get update \
    && apt-get install -y \
        ruby \
        ruby-dev \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y \
        automake \
        libtool \
    && rm -rf /var/lib/apt/lists/* \
    && gem install compass

RUN apt-get update \
    && apt-get install -y \
        build-essential \
        g++ \
    && rm -rf /var/lib/apt/lists/*

