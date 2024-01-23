df <- read.csv("C:/Users/jllce/Downloads/adult.csv", stringsAsFactors = TRUE)

#verificando os nomes, e formatos das variáveis e qtd de observações.
str(df)

#O income é a target.
#Selecionando atributos de interesse: não entendi o que a professora fez, só vou selecionar
#as variáveis que ela selecionou.
df2 <- subset(df, select = c(income, age, educational.num, gender, relationship,
                            hours.per.week, occupation, capital.gain, capital.loss))
str(df2)
summary(df2)
#das variáveis que restaram, tem-se que verificar se as numéricas são efetivamente quanti-
#tativas ou se são categóricas numéricas. E com relação às quanlitativas, verificar se há
#muitas categorias ou não. Por último, verificar variáveis com dados faltantes/outliers

sapply(df2, function(x)all(is.na(x)))
#aparentemente, não há dados missing. Porém, já consegui ver que há observações com "?"
#Partiremos para uma análise de uma variável de cada vez

#Income:
table(df$income)
prop.table(table(df$income))
#Então, 76% das observações são de income menor que 50k.

#Age:
#Usando gráficos para verificar alguma relação com a target (no boxplot).
par(mfrow=c(1,2))
hist(df2$age, main='Distribuição da variável "idade"')
boxplot(df2$age~df2$income, range = 3, main='Avaliação da variável "idade"',
        col=c("gray","darkgreen"), cex=0.5)
par(mfrow=c(1,1))
#não foi verificado outlier. Eh possivel perceber alguma relação de quanto maior a 
#idade, mais chances do income ser maior que 50k.


#educação do indivíduo: Relação crescente, quanto maior o tempo de estudo, mais 
#chances de ser maior que 50k.É possível ver isso na proporção do verde, que vai aumentando
#em relação ao cinza.
plot(as.factor(df2$educational.num), df2$income, ylab="income", xlab="estudo",
     col=c("darkgreen", "gray"), cex=0.4)

#como há muitas categorias, temos que agrupar para melhorar. É possível perceber
#que, por exemplo, dá pra agrupar do 0a8, que estão muito próximos.

df2$educational.num2 <- cut(df2$educational.num, breaks=c(0,8,9,10,12,16), 
                           labels=c("Até 12th", "High-School", "Some-College",
                                    "Assoc", "Especialista"))
plot(as.factor(df2$educational.num2), df2$income, ylab="Income", xlab="Estudo",
     col=c("darkgreen", "gray"), cex=0.5)

#Como a técnica que vamos utilizar para essa análise tem problemas com variáveis
#categóricas, vamos ter que transformar todas em variáveis dummies. No caso, 
#como a grande proporção está no "Especialista", vamos dizer que se o num for >=13,
#teremos 1, caso contrário, 0.

df2$edu_Especialista <- ifelse(df$educational.num >= 13, 1, 0)
plot(as.factor(df2$edu_Especialista), df2$income, ylab="Income", xlab="Estudo",
     col=c("darkgreen", "gray"), cex=0.5)


#Agora olhando para o gênero:
plot(as.factor(df2$gender), df2$income, ylab="Income", xlab="Gender",
     col=c("darkgreen", "gray"), cex=0.5)
#Como tambem se trata de uma variável quantitativa, tenho que transformar pra dummy
df2$sex_masc <- ifelse(df2$gender == "Male", 1, 0)


#Agora, relationship:
plot(as.factor(df2$relationship), df2$income, ylab="Income", xlab="Relationship",
     col=c("darkgreen", "gray"), cex=0.5)
#dá pra transformar para "se casado 1, caso contrário, 0"
df2$relationship_casado <- ifelse(df$relationship == "Husband" | df$relationship == "Wife", 1, 0)
plot(as.factor(df2$relationship_casado), df2$income, ylab="Income", xlab="Relationship_casado",
     col=c("darkgreen", "gray"), cex=0.5)


#Agora, relationship:
plot(as.factor(df2$occupation), df2$income, ylab="Income", xlab="Occupation",
     col=c("darkgreen", "gray"), cex=0.5)
summary(df2$occupation)
#dá pra transformar alguns principais em 1 e o restante em 0"
df2$occupation_treated <- ifelse(as.character(df2$occupation) == "Exec-managerial" |
                                   as.character(df2$occupation) == "Prof-specialty" |
                                   as.character(df2$occupation) == "Tech-support" |
                                   as.character(df2$occupation) == "Protective-serv" |
                                   as.character(df2$occupation) == "Armed-Forces" |
                                   as.character(df2$occupation) == "Sales", 1, 0)
plot(as.factor(df2$occupation_treated), df2$income, ylab="Income", xlab="Occupation_treated",
     col=c("darkgreen", "gray"),cex=0.5)


#Agora, quantidade de horas trabalhadas semanalmente
#É numérica, portanto, vou olhar da mesma forma que olhei a "Age"
par(mfrow=c(1,2))
hist(df2$hours.per.week, cex=0.4)
boxplot(df2$hours.per.week~df2$income, range=3, cex=0.4)
#Então, eh possivel destacarmos 3 posições (quem trabalha acima de 40h, 40h
#e abaixo de 40h)
df2$horas_trab <- cut(df2$hours.per.week, breaks = c(0,39,40,100),
                      labels = c("Até 40h", "40h", "Mais de 40h"))
plot(as.factor(df2$horas_trab), df2$income, ylab="Income", xlab="horas_trab",
     col=c("darkgreen", "gray"),cex=0.5)
#portanto, como o "ate 40h" eh inexpressivo, vale a pena criar uma dummy
#dizendo que 1 é mais de 40h e 0 é até 40h inclusive.
df2$horas_trab_maior40hs <- ifelse(df2$horas_trab == "Mais de 40h", 1, 0)


#variável ganho de capital:
hist((df2$capital.gain), cex=0.5)
boxplot(df2$capital.gain~df2$income, range=3, col=c("blue", "red"),cex=0.4)
#É possível perceber que a grande parte não tem ganho de capital, mas há aqueles que têm.
#o mesmo vale para o capital_loss
hist((df2$capital.loss), cex=0.5)
boxplot(df2$capital.loss~df2$income, range=3, col=c("blue", "red"),cex=0.4)
#para isso, transformamos para 1, se ganhou ou perdeu, e 0 se não.

df2$cat_cap.gain <- ifelse(df2$capital.gain >= 1, 1, 0)
df2$cat_cap.loss <- ifelse(df2$capital.loss >= 1, 1, 0)


plot(as.factor(df2$cat_cap.gain), df2$income, ylab="Income", xlab="gain",
     col=c("darkgreen", "gray"),cex=0.5)
plot(as.factor(df2$cat_cap.loss), df2$income, ylab="Income", xlab="loss",
     col=c("darkgreen", "gray"),cex=0.5)
#ela enxergou, através do table, que essas eram variaveis muito pequenas.
#daí, ela vai cruzar essas variáveis e vai criar uma só dizendo 1 se eu ganhei,
#0, se perdi.
table(df2$cat_cap.gain, df2$cat_cap.loss) #diante desse table, vemos que dá pra juntar
                                          #o 1,0 e o 0,1, pra rivalizar com o 0,0 (o 1,1
                                          #é nulo)

df2$cap.gain_loss <- df2$cat_cap.gain*10 + df2$cat_cap.loss

plot(as.factor(df2$cap.gain_loss), df2$income, ylab="Income", 
     xlab="gain_loss (1=perda, 10=ganho)", col=c("darkgreen", "gray"),cex=0.5)

df2$cap.gain_loss <- ifelse(as.numeric(df2$cap.gain_loss) >= 1, 1, 0)

plot(as.factor(df2$cap.gain_loss), df2$income, ylab="Income", 
     xlab="gain_loss_final", col=c("darkgreen", "gray"),cex=0.5)

#avaliando agora a estrutura do df2
str(df2)
#agora, vamos filtrar as variáveis que já estão preparadas para a análise
df3 <- subset(df2, select=c(income, age, sex_masc, edu_Especialista,
                            relationship_casado, occupation_treated,
                            horas_trab_maior40hs, cap.gain_loss))
str(df3)
summary(df3)
#É possível perceber que a variável Age é a única diferente das outras, que são 
#dummies. Portanto, tenho que padronizar ela. (eu tentaria normalizar, pra ficar
#entre 0e1 e não destoar das outras. Porém, a melhor solução seria padronizar geral
#pra mim)

df3[,2:2] <- scale(df3[,2:2])
summary(df3)


#Agora eh a etapa de construir o modelo
#Criar amostra de treino e teste

#install.packages("caTools")
library(caTools)
#gerando um número aleatório
set.seed(21)
split <- sample.split(df3$income, SplitRatio = 0.7)
train_adult <- subset(df3, split == TRUE)
test_adult <- subset(df3, split == FALSE)


#Técnica de Discriminação (Supervisionada): KNN (K-Nearest Neighbors)
library(class)

#previsão KNN - selecionarei os 5 vizinhos mais proximos
previsao_knn <- knn(train_adult[,-1], test_adult[,-1], cl=train_adult$income, k=5)
nn_base_previsao = data.frame(previsao_knn)


#avaliar o desempenho do modelo
library(caret)
MC_knn = table(previsao_knn, test_adult$income, deparse.level = 2)
#Matriz de confusão: modelo knn com o k obtido por validação cruzada

confusionMatrix(MC_knn, positive = ">50K" )
#é importante olhar a acurácia, sensitividade e especificidade. A especificidade e
#acurácia estão ótimas, porém, a sensitividade não é tão boa. Significa que preciso
#melhorar.

#agora, como o k=5 me deu 83% de acurácia, será que isso pode melhorar se o k for outro?
#Para isso, utilizaremos o método da validação cruzada.

TrainClasse = train_adult[,1]

knnFit1 <- train(train_adult[,2:8], TrainClasse, method = "knn",
                 tuneLength = 20, #mostrar k valores
                 trControl = trainControl(method = "cv"))
#agora esse knnFit1 vai verificar a acurácia para diferentes valores de k
#Ele separa a amostra em várias amostras com reposição e vai simulando vários tipos de k
#Aquele resultado de k que melhor ajusta o modelo é o 31, e é dito ao final
knnFit1 

#olhando visualmente:
plot(knnFit1, xlab = "Número de K vizinhos", main = "Acurácia", type = "b", col = "black",
     lwd = 1.8, pch = "o")

#agora, utilizando o resultado do cross validation
#amostra de validação
knn_pred = predict(knnFit1, newdata = test_adult[,2:8])
MC_knn_CV = table(knn_pred, test_adult$income, deparse.level = 2)
confusionMatrix(MC_knn_CV, positive = ">50K")
