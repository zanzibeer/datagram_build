FROM maven:3.6.3-openjdk-8-slim as builder
VOLUME /kaniko/workspace /kaniko/workspace/datagram
RUN apt-get update && apt-get install -y git \
  && git clone https://github.com/neoflex-consulting/datagram.git -b frontend /kaniko/workspace/datagram \
  && cd /kaniko/workspace/datagram && pwd \
  && mvn -q clean install

FROM maven:3.6.3-openjdk-8-slim

ENV MAVEN_HOME=/usr/share/maven
ENV MEM_MAX=8g
ENV TENEO_URL jdbc:postgresql://hivemetastore:5432/teneo
ENV TENEO_USER postgres
ENV TENEO_PASSWORD new_password
ENV DATAGRAM_HOME /opt/datagram
ENV DEPLOY_DIR $DATAGRAM_HOME/mspace
ENV VERSION spark3-2.0.0-SNAPSHOT
ENV SERVER_PORT 8089
ENV MAVEN_REPO=/root/.m2/repository
ENV MAVEN_CACHE=/opt/maven-cache

COPY --from=builder /datagram/mserver/target/mserver-$VERSION.jar /opt/datagram/mserver.jar
COPY --from=builder /datagram/spark2lib/target/ru.neoflex.meta.etl2.spark.spark2lib-$VERSION.jar ${MAVEN_CACHE}/ru/neoflex/meta/etl2/ru.neoflex.meta.etl2.spark.spark2lib/$VERSION/ru.neoflex.meta.etl2.spark.spark2lib-$VERSION.jar
COPY --from=builder /datagram/runtime/target/ru.neoflex.meta.etl.spark.runtime-$VERSION.jar ${MAVEN_CACHE}/ru/neoflex/meta/etl/ru.neoflex.meta.etl.spark.runtime/$VERSION/ru.neoflex.meta.etl.spark.runtime-$VERSION.jar
COPY --from=builder /datagram/spark2lib/.flattened-pom.xml ${MAVEN_CACHE}/ru/neoflex/meta/etl2/ru.neoflex.meta.etl2.spark.spark2lib/$VERSION/ru.neoflex.meta.etl2.spark.spark2lib-$VERSION.pom
COPY --from=builder /datagram/runtime/.flattened-pom.xml ${MAVEN_CACHE}/ru/neoflex/meta/etl/ru.neoflex.meta.etl.spark.runtime/$VERSION/ru.neoflex.meta.etl.spark.runtime-$VERSION.pom
COPY --from=builder /datagram/.flattened-pom.xml ${MAVEN_CACHE}/ru/neoflex/parent/$VERSION/parent-$VERSION.pom
COPY ./application.properties $DATAGRAM_HOME/application.properties
COPY ./ldap.properties $DATAGRAM_HOME/ldap.properties
COPY ./entrypoint.sh $DATAGRAM_HOME/entrypoint.sh
COPY ./cmd.sh $DATAGRAM_HOME/cmd.sh
COPY ./mspace $DEPLOY_DIR

WORKDIR $DATAGRAM_HOME
RUN chmod +x ./entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
CMD ["./cmd.sh"]
