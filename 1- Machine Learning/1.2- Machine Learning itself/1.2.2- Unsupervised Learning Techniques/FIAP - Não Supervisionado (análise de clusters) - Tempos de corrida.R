df <- read.table("https://pages.stat.wisc.edu/~rich/JWMULT06dat/T1-9.dat",
                 sep = "\t", row.names=1)

colnames(df) <- c("p100ms", "p200ms", "p400ms", "p800ms",
                  "p1500ms", "p3000ms", "pmaratm" )

str(df)
#já consigo perceber que todas as variáveis são numéricas.

summary(df)
#é possível ver alguns outliers. Mas vamos usar o boxplot pra ver melhor
#não vejo dados faltantes

attach(df)
boxplot(p100ms)
boxplot(p200ms)
boxplot(p400ms)
boxplot(p800ms)
boxplot(p1500ms)
boxplot(p3000ms)
boxplot(pmaratm)

#então é possivel ver que temos outlier. Mas tem que ter atenção
#pq só há 54 observações. Se eu excluir uns 5, estarei excluindo quase 10% do
#dataset
#A professora decidiu por excluir somente observações da variavel
#maratona que estejam acima de 180minutos

df2 <- subset(df, pmaratm <180, select = c(p100ms,p200ms,
                                           p400ms,p800ms,p1500ms,
                                           p3000ms,pmaratm))

#partindo para análise da correlação entre as variáveis
matcor <- round(cor(df2),2)
print(matcor, digits = 2)
#Dá pra perceber que os tempos terão correlação mais próxima daqueles
#tempos de corridas com modalidade mais próxima.
#olhando por outro prisma:
library(corrplot)
corrplot::corrplot(matcor, type = "lower", method = "number", col = "black",
                   order = "hclust")

#outro jeito
library(reshape2)
library(ggplot2)

melted_matcor <- melt(matcor)
ggplot(data = melted_matcor, aes(x=Var1, y=Var2, fill=value)) + 
  geom_tile()

#agora, padronizaremos as variáveis
df3 <- scale(df2)
summary(df3)

#agora partiremos para a clusterização (2tipos: hierarquico
#e nao hierarquico). Como não tenho ideia da quantidade de cluster
#que eu preciso, a técnica dendograma vai me ajudar a chegar nisso.
#então, começaremos com o hierarquico:

hierarquico_cluster <- hclust(dist(df3), method = "ward.D2") #aqui ele vai
#mostrar, através de um cálculo de distância, como que os países estão
#próximos uns dos outros. É uma distância multivariada, ou seja, levando
#em conta as 7 variáveis.

d <- dist(df3, method = "euclidean") #colocar essas distâncias em matrizes

plot(hierarquico_cluster, ylab = "distancia", cex = 0.6) #fazer um plot
#disso (um dendograma). Aqui é feita a clusterização, onde cada chave
#são grupos formados. Então, esse dendograma vai mostrar quantas possibilidades
#de grupos podem ser formados.


groups <- cutree(hierarquico_cluster, k=4) #cut tree into 4 clusters
#draw dendogram with red borders around the 4 clusters
rect.hclust(hierarquico_cluster, k=4, border = "red")

groups <- cutree(hierarquico_cluster, k=5) #cut tree into 5 clusters
#draw dendogram with blue borders around the 5 clusters
rect.hclust(hierarquico_cluster, k=5, border = "blue")

# com isso, é possível perceber que dependendo do meu objetivo, eu
#escolho a quantidade de grupos que quero formar em termos de
#distância.

#outros métodos que podem ser usados são: ward, single, complete,
#average, mcquitty, median ou centroid.
#A definição de qual método usar varia com o objetivo do estudo e com
#o tipo de matriz de distância usada

#agora, partindo para o não hierárquico:
#O método de elbow faz uma simulação de várias quantidades de cluster
#para eu selecionar qual a melhor quantidade de cluster. Usaremos, o 
#K-means para fazer o método não hierárquico.

wss <- (nrow(df3)-1)*sum(apply(df3, 1, var))
for(i in 1:10) wss[i] <- sum(kmeans(df3, iter.max=100, #pedi até 10 clusters
                                    center=i)$withinss)
plot(1:10, wss, type = "b", xlab = "Number of Clusters",
     ylab = "within groups sum of squares")

#Com isso, se percebe que de 1 pra 2 clusters, há grande impacto sobre a
#homogeneidade dos grupos. E de 2 pra 4 há menos, mas ainda há. Mas depois, o impacto
#passa a ser cada vez menor. Então, 4 clusters parece de bom tamanho, pois
#não perderemos tanto em desempenho. Mas é claro que isso vai depender do 
#objetivos do estudo.

#Gerando a quantidade de clusters com kmeans
set.seed(1234)
output_cluster <- kmeans(df3, 4, iter = 100)
output_cluster
#com isso, é possível ver o agrupamento em 4 de países por conta das suas médias.
#O grupo com as medias mais negativas, nesse caso, é o com os menores tempos, logo,
#mais rápidos. É possível ler a quantidade de países por grupo também.

#Se eu quiser pegar só a quantidade de países em cada cluster
segmento <- output_cluster$cluster
table(segmento)

#se eu quiser pegar só as características de cada cluster
centros <- output_cluster$centers
centros

#Quantas rodadas até chegar nos clusters
qtd_iter <- output_cluster$iter
qtd_iter

#Mostrando resultados
aggregate(df3, by=list(segmento), FUN = mean)

#Mostrando resultados em gráficos
library(cluster)
clusplot(df3, output_cluster$cluster, color= TRUE, shade = TRUE, labels = 2,
        lineas = 0, cex = 0.75)

#junta os arquivos em colunas
matriz <- cbind(df3, segmento)
