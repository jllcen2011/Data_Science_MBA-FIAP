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
boxplot(p100ms, range = 3)
boxplot(p200ms, range = 3)
boxplot(p400ms, range = 3)
boxplot(p800ms, range = 3)
boxplot(p1500ms, range = 3)
boxplot(p3000ms, range = 3)
boxplot(pmaratm, range = 3)

#então é possivel ver que temos outlier. Mas tem que ter atenção
#pq só há 54 observações. Se eu excluir uns 5, estarei excluindo quase 10% do
#dataset
#A professora decidiu por excluir somente observações da variavel
#maratona que estejam acima de 180minutos. É possível perceber que as 3 obs
#acima de 180minutos compreendem não só os 2 outliers da pmaratm, mas tbm
#os outliers das provas de 1500 e 3000m. Logo, as 3 variáveis perdem os 
#outliers.
#É claro, cabe salientar que o range=3 permite que não vejamos os outliers
#que haveria quando o range=default. O range=3 é bastante aceitável pra
#pegar realmente aqueles pontos que se destacam.

df2 <- subset(df, pmaratm <180, select = c(p100ms,p200ms,
                                           p400ms,p800ms,p1500ms,
                                           p3000ms,pmaratm))
summary(df2)
#partindo para análise da correlação entre as variáveis
library(lattice)
library(ggplot2)

panel.cor<- function(x, y, digits=2, prefix="", cex.cor,
                     ...) {
  usr <- par("usr")
  on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))                  
  r <- cor(x, y, use = "pairwise.complete.obs")                 
  txt <- format(c(r, 0.123456789), digits = digits) [1]
  txt <- paste (prefix, txt, sep="")
  if (missing(cex.cor))
    cex <- 0.5/strwidth(txt)
  #abs(r)é para que na saída as correlações fiquem proporcionais
  text(0.5, 0.5, txt, cex = cex * abs(r))
}

panel.hist <- function(x, ...) {
              usr <- par("usr")
              on.exit(par(usr))
              par(usr = c(usr[1:2], 0, 1.5))
              h <- hist(x, plot=FALSE)
              breaks <- h$breaks
              nB <- length(breaks)
              y <- h$counts
              y <- y/max(y)
              rect(breaks[-nB], 0, breaks[-1], y, col = "red", border = "white", ...)
}

pairs(df2, lower.panel = panel.smooth, upper.panel = panel.cor, diag.panel = panel.hist)

#excelente gráfico mostrando histograma na diagonal principal, as correlações na 
#parte superior e dispersão na inferior.
#Dá pra perceber que os tempos terão correlação mais próxima daqueles
#tempos de corridas com modalidade mais próxima.


#agora, padronizaremos as variáveis
df3 <- scale(df2)
summary(df3)

#agora partiremos pra sumarização. Existem diversas técnicas: componentes principais,
#análise fatorial, etc.

#componentes principais

pca_cor <- prcomp(df3, scale. = TRUE, center = TRUE)
summary(pca_cor)

#Aqui, como eu tinha 7 variáveis, ele criou pra mim 7 componentes principais.
#Eles se originam de uma combinação linear das 7 variáveis, de forma que no
#primeiro componente concentra-se a maior variabilidade dos meus dados.
#É possível ver que o desvio padrão vai diminuindo do PC1 até o PC7. Mas
#nele se tem a explicação da maior porção dos dados (76%). Já o segundo, tem 
# quase 14%, o terceiro 3,3%, e por aí vai. Logo, se pegar apenas os 2
#primeiros compoenentes, teremos praticamente a explicação de 90% dos dados.
#Portanto, essa técnica sumariza os dados, de modo que todos somados equivalham
#aos 7, mas os 2 primeiros já concentram muito bem os dados.

#apenas por curiosidade, se eu somar todos os quadrados dos desvios padrões, eu
#alcanço o número 7. (o quadrado do desvio padrão é igual a variância)
sum(pca_cor$sdev^2)

#Olhando isso graficamente:
plot(1:ncol(df3), pca_cor$sdev^2, type = "b", xlab = "Componente",
     ylab = "Variância", pch = 20, cex.axis = 0.8, cex.lab = 0.8)
#É possível ver que o PC1 me mostra uma variância enorme. Cai bastante em
#quando vai pro 2, depois pro 3, e depois a variância varia minimamente a
#medida que avançamos nos componentes.

library(factoextra) #pra criar alguns gráficos
fviz_eig(pca_cor) #aqui mostra em termos percentuais. Como visto, o PC1
                  #explica 76%, e o 2, 14%.

#Voltando ao objetivo, eu quero criar uma sumarização dos records, 
#um ranking de países. Mas quero não usar só 1 variável, mas as 7. Ou seja,
#Um ranking em relação às 7 variáveis, não um ranking pra cada variável.

summary(pca_cor)$rotation
#Eu consigo ver o peso de cada uma das variáveis em cada componente. É
#basicamente o coeficiente angular. Ex.: PC1 = -0.36*p100ms -0.37*p200ms ...

#Mostrando como ficam os 7 componentes para cada observação, ou seja, para
#cada país.
summary(pca_cor)$x

# Olhando graficamente, temos um biplot mostrando o PC1 e o PC2.
fviz_pca_biplot(pca_cor, repel=TRUE,
                col.var = "#2E9FDF",  #cor das variáveis
                col.ind = "#696969")  #cor dos automóveis
#A professora falou que no caso do componente 1, a importância das variáveis está
#entre -4 e -2. No caso do componente 2, a importância das variáveis (vai
#de -2 a 2 : basicamente no positivo tem-se as curtas distancias e
#no negativo, as longas distâncias)


#como o PC1 é de longe o mais importante, vou usar ele pra fazer meu ranking.
pca_cor <- prcomp(df3, scale = TRUE, center = TRUE, retx = TRUE)
#vou pedir somente o primeiro componente
IndicadorPerf <- pca_cor$x[,1]
hist(IndicadorPerf)

#agora vou colocar em ordem os países com melhores indicadores.
names(IndicadorPerf) <- row.names(df3)
ordem <- order(IndicadorPerf, decreasing = TRUE)
barplot(IndicadorPerf[ordem], ylab = "IndicadorPerf", las=2)
box()

#agora dando uma olhadinha nos países:
df4 <- cbind(df3, IndicadorPerf) #dataframe padronizado e com o indicador

df5 <- cbind(df2, IndicadorPerf) #dataframe sem padronização e com o indicador

#esteticamente, seria melhor normalizar o indicador para que ele não fique mostrando
#valores negativos. É a NORMATIZAÇÃO (valor - valor mínimo)/(amplitude)

df5$Ind_Perf <- ((IndicadorPerf - min(IndicadorPerf))/
  (max(IndicadorPerf) - min(IndicadorPerf)))*100

hist(df5$Ind_Perf)

