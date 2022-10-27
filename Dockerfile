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

COPY ./datagram/mserver/target/mserver-$VERSION.jar /opt/datagram/mserver.jar
COPY ./datagram/spark2lib/target/ru.neoflex.meta.etl2.spark.spark2lib-$VERSION.jar ${MAVEN_CACHE}/ru/neoflex/meta/etl2/ru.neoflex.meta.etl2.spark.spark2lib/$VERSION/ru.neoflex.meta.etl2.spark.spark2lib-$VERSION.jar
COPY ./datagram/runtime/target/ru.neoflex.meta.etl.spark.runtime-$VERSION.jar ${MAVEN_CACHE}/ru/neoflex/meta/etl/ru.neoflex.meta.etl.spark.runtime/$VERSION/ru.neoflex.meta.etl.spark.runtime-$VERSION.jar
COPY ./datagram/spark2lib/.flattened-pom.xml ${MAVEN_CACHE}/ru/neoflex/meta/etl2/ru.neoflex.meta.etl2.spark.spark2lib/$VERSION/ru.neoflex.meta.etl2.spark.spark2lib-$VERSION.pom
COPY ./datagram/runtime/.flattened-pom.xml ${MAVEN_CACHE}/ru/neoflex/meta/etl/ru.neoflex.meta.etl.spark.runtime/$VERSION/ru.neoflex.meta.etl.spark.runtime-$VERSION.pom
COPY ./datagram/.flattened-pom.xml ${MAVEN_CACHE}/ru/neoflex/parent/$VERSION/parent-$VERSION.pom
COPY ./datagram_build/application.properties $DATAGRAM_HOME/application.properties
COPY ./datagram_build/ldap.properties $DATAGRAM_HOME/ldap.properties
COPY ./datagram_build/entrypoint.sh $DATAGRAM_HOME/entrypoint.sh
COPY ./datagram_build/cmd.sh $DATAGRAM_HOME/cmd.sh
COPY ./datagram_build/mspace $DEPLOY_DIR

WORKDIR $DATAGRAM_HOME
RUN chmod +x ./entrypoint.sh
RUN chmod +x ./cmd.sh
ENTRYPOINT ["./entrypoint.sh"]
CMD ["./cmd.sh"]
