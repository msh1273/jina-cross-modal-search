FROM jinaai/jina:2.0.8-perf

RUN apt-get -y update && apt-get install -y git wget gcc unzip libmagic1

COPY . /workspace
WORKDIR /workspace

# install the third-party requirements
RUN pip install -r requirements.txt

RUN rm -rf workspace && python app.py -t index --data_set=f8k

EXPOSE 45678

ENTRYPOINT ["python", "app.py", "-t", "query_restful"]