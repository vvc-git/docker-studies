
# ! O FROM define a imagem base. Então, somente o que for especificado no último FROM será a imagem base para a imagem final.
# Pegar a imagem do maven  e trazendo para o container
FROM  maven:3.8.4-jdk-8 AS build

# Copia tudo o que está em /src para o container
COPY /src /app/src
COPY pom.xml /app

# Muda para o diretorio /app
WORKDIR /app

# Roda o comando para compilar
# * O mvn é uma ferramenta para automação de compilação
# * Comando 'clean' limpa tudo o que está em target (Pasta onde fica os arquivos de configuração)
# * Comando 'install' compila o projeto. Ele que gera o .jar
RUN mvn clean install

# Pegar APENAS a imagem do JRE (Deixando a imagem final mais leve)
# * JDK = Desenvolve e compila (inclui o JRE).
# * JRE = Roda o arquivo compilado (executa o bytecode).
# ! Cria um novo estágio que não tem acesso ao que foi compilado anteriormente
FROM openjdk:8-jre-alpine

# Copia os arquivos compila
# * Flag '--from=build' permite pegar o compilado que foi gerado no estágio anterior
COPY --from=build /app/target/spring-boot-2-hello-world-1.0.2-SNAPSHOT.jar /app/app.jar

WORKDIR /app

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]