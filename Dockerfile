
FROM debian
RUN apt update && apt install -y default-jre wget
RUN wget https://archive.apache.org/dist/maven/maven-3/3.9.10/binaries/apache-maven-3.9.10-bin.tar.gz
RUN mkdir -p /usr/local/apache-maven
RUN tar -xvf apache-maven-3.9.10-bin.tar.gz -C /usr/local/apache-maven/
ENV M2_HOME=/usr/local/apache-maven/apache-maven-3.9.10
ENV M2=$M2_HOME/bin 
ENV MAVEN_OPTS="-Xms256m -Xmx512m"
ENV PATH=$M2:$PATH
COPY . /code
WORKDIR /code
RUN script/prepare.sh

CMD [ "script/ib1-registry", "production", "registry/root"]
