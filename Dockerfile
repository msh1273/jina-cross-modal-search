FROM jinaai/jina:2.0.8-perf

RUN apt-get -y update && apt-get install -y git wget gcc unzip libmagic1

WORKDIR /workspace
COPY ./requirements.txt requirements.txt

RUN pip3 install torch==1.9.0+cpu -f https://download.pytorch.org/whl/torch_stable.html
# install the third-party requirements

RUN pip install git+https://github.com/openai/CLIP.git click && pip uninstall -y jina && pip install -r requirements.txt && pip uninstall -y dataclasses && python -c "import clip; clip.load('ViT-B/32')"

COPY . /workspace

ENV JINA_IMAGE_ENCODER='yaml/clip/hub-image-encoder.yml'
ENV JINA_TEXT_ENCODER='yaml/clip/hub-text-encoder.yml'
ENV JINA_SHARDS='2'

RUN rm -rf workspace && python app.py -t index -n 20000

EXPOSE 45678

ENTRYPOINT ["python", "app.py", "-t", "query_restful"]