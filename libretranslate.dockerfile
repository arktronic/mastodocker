# This is an arm64-compatible Dockerfile for LibreTranslate (should work with amd64, too)

FROM python:3.10-bullseye

ARG GIT_CHECKOUT=main
ENV PYTHONUNBUFFERED=1
WORKDIR /root

RUN git clone https://github.com/aboSamoor/pycld2.git \
 && cd pycld2 \
 && git checkout 2a1959c5c4ab2b99f9221dc5e51e65f77e2459ca \
 && pip install .

RUN git clone https://github.com/LibreTranslate/LibreTranslate.git libretranslate \
 && cd libretranslate \
 && git checkout $GIT_CHECKOUT \
 && sed -i "/pycld2==0.41/d" requirements.txt \
 && pip install . \
 && pip cache purge \
 && python install_models.py

EXPOSE 5000

CMD ["libretranslate", "--host", "0.0.0.0"]
