FROM demisto/python3-deb:3.8.5.10844

RUN apt-get update && apt-get install -y \
  python3-dev curl unzip libglib2.0 libnss3 libx11-6 libgconf-2-4 libfontconfig1 \
  chromium firefox-esr

RUN pip3 install virtualenv
RUN useradd -ms /bin/bash seleniumpy

USER seleniumpy
WORKDIR /home/seleniumpy

ENV VIRTUAL_ENV=/home/seleniumpy/venv
RUN virtualenv -p python3 $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Default locations to download Firefox and Chrome drivers
ARG geckodriver=https://github.com/mozilla/geckodriver/releases/download/v0.27.0/geckodriver-v0.27.0-linux64.tar.gz
ARG chromedriver=https://chromedriver.storage.googleapis.com/83.0.4103.39/chromedriver_linux64.zip

RUN curl ${geckodriver} -L --output geckodriver.tar.gz && tar -xzvf geckodriver.tar.gz && rm geckodriver.tar.gz
RUN curl ${chromedriver} -L --output chromedriver.zip && unzip chromedriver.zip && rm chromedriver.zip