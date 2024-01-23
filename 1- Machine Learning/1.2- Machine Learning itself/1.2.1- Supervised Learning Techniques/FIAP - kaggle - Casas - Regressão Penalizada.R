# É uma base de dados em que estou buscando explicar a variável target Preço das casas.
# Portanto, por se tratar de variável target, usarei técnicas supervisionadas e, por se
#tratar de uma variável quantitativa, usarei técnicas preditivas (regressão), ao invés
#de usar técnicas de classificação.

df <- read.csv("C:/Users/jllce/Downloads/train.csv", row.names = 1,
               stringsAsFactors = TRUE)

#Explorando o dataset
str(df)
summary(df)

#Explorando a variável target
hist(df$SalePrice)
#Percebe-se que há muitos dados que fogem do padrão (outliers)
boxplot(df$SalePrice, main="range = 1.5")
boxplot(df$SalePrice, range=3, main="range = 3")
#Portanto, podemos excluir os outliers ou então fazer uma transformação (log,
#raíz quadrada, alguma coisa pra deixá-los mais lineares)
df$log_SalePrice <- log(df$SalePrice)
#histograma bem menos assimétrico
hist(df$log_SalePrice)
summary(df$log_SalePrice)
par(mfrow=c(1,2))
#boxplot bem mais simétrico
boxplot(df$SalePrice, range=3,main="range = 3")
boxplot(df$log_SalePrice, range=3, main="range = 3")
par(mfrow=c(1,1))

#Avaliando agora a target em relação a algumas variaveis preditoras quantitativas
plot(x=df$LotArea, y=df$log_SalePrice,
     main = "Gráfico de dispersão",
     xlab="LotArea",
     ylab="Log SalePrice")
plot(x=df$GarageArea, y=df$log_SalePrice,
     main = "Gráfico de dispersão",
     xlab="GarageArea",
     ylab="Log SalePrice")

#Avaliando agora a target em relação a algumas variáveis preditoras qualitativas
#Como são variaveis categoricas, eu tenho que criar variaveis dummies.
#A professora optou por seguir em frente só com as numéricas. Mas caso fosse
#usar qualitativas, era só criar dummies
boxplot(df$log_SalePrice~df$GarageFinish, main="GarageFinish", col=c("gray"))

#Criando um novo DataFrame selecionando só as numéricas:
var_num <- sapply(df,is.numeric)
df_num <- df[,var_num]
str(df_num)
summary(df_num)

#Agora é hora de tratar as variáveis que possuem NA's no summary
#Eu posso estimar esses valores faltantes utilizando, p.ex. a técnica KNN ou
#se vou apenas excluir esses NA ou nem utilizar essa variável que possui NA.
#Com relação àquelas variáveis que são categóricas mas são codificadas como
#variáveis numéricas (Sexo, sendo o masculino 1 e o feminino 2, p.ex.), nesse
#momento a professora vai excluí-las, não tratando nesse momento delas.
#*nao concordei muito com as exclusões dela não, mas simbora
library(dplyr)
df_num_filter <- select(df_num,-c(SalePrice, MSSubClass, LotFrontage,
                                  MiscVal, MoSold, YrSold, MasVnrArea,
                                  GarageYrBlt))
summary(df_num_filter)

#análise de correlação entre as variáveis quantitativas restantes
matcor <- cor(df_num_filter)
print(matcor, digits=2)
library(corrplot)
corrplot::corrplot(matcor, method="circle", order="hclust", tl.cex = 0.6)

#A partir disso, posso explorar alguns gráficos de plot para ir analisando.
#Exemplo:
plot(x=df_num_filter$OverallQual, y=df_num_filter$log_SalePrice)
plot(x=df_num_filter$GarageCars, y=df_num_filter$log_SalePrice)
plot(x=df_num_filter$GrLivArea, y=df_num_filter$log_SalePrice)

#Após avaliar geral, devemos excluir outras variaveis redundantes ou que
#tenham pouca informação e outras que deveriam ser transformadas em dummies
#devido a alta quantidade de zeros em seu conteúdo
df_num_filter <- select(df_num_filter, -c(BsmtFinSF1,
                                          BsmtFinSF2,
                                          BsmtUnfSF,
                                          OpenPorchSF,
                                          EnclosedPorch,
                                          X3SsnPorch,
                                          ScreenPorch,
                                          OverallQual,
                                          OverallCond,
                                          X1stFlrSF,
                                          X2ndFlrSF,
                                          GarageCars,
                                          PoolArea,
                                          LowQualFinSF,
                                          BsmtHalfBath,
                                          KitchenAbvGr,
                                          YearBuilt))
summary(df_num_filter)
#Depois, para formar uma base final, vamos excluir alguns outliers das
#variáveis LotArea, GarageArea e GrLivArea
df_final <- subset(df_num_filter,df_num_filter$LotArea<50000 &
                     df_num_filter$GarageArea<1200 &
                     df_num_filter$GrLivArea<4000)
#Um detalhe com relação ao ano de reforma do imóvel é que transformaremos
#para um período a partir da data de reforma. Então, não teremos mais
#o ano da reforma, mas há quanto tempo foi feita a reforma a partir
#do imóvel reformado mais recentemente
summary(df_final$YearRemodAdd)
df_final$YearRemodAdd <- max(df_final$YearRemodAdd) - df_final$YearRemodAdd
summary(df_final$YearRemodAdd)
matcor <- cor(df_final)
corrplot::corrplot(matcor, method="circle", order="hclust", tl.cex = 0.6)


#Agora será utilizada a técnica de Regressão Penalizada. As outras técnicas tendem
# a trazer ruídos por conta de muitas variáveis correlacionadas. A penalizada tende
#a resolver isso através dos hiperparâmetros que cria.

#separando o dataset em treino (70%) e teste (30%) (uma divisão aleatoria)
set.seed(1)
train_obs <- sample(nrow(df_final), 0.7*nrow(df_final))

#separando as variáveis preditoras e a target (separando independentes da dependente)

X <- df_final[train_obs,]
X <- X[,-which(names(X) %in% (c("log_SalePrice")))]
Y <- df_final$log_SalePrice[train_obs]

data_train <- cbind(Y,X)

#agora preparando a base de testes
X_test <- df_final[-train_obs,]
X_test <- X_test[,-which(names(X_test) %in% (c("log_SalePrice")))]
Y_test <- df_final$log_SalePrice[-train_obs]

data_test <- cbind(Y_test,X_test)

#Agora será feito um pré-processamento dos dados, em que será feita a padronização das
#variáveis quantitativas. Caso haja alguma variável dummy, esta deverá ser colocada de
#lado até que a padronização seja feita nas outras. Depois de feita, aí posso retornar
#com a variável dummy pro dataframe

library(caret)
summary(data_train)
#usando o pacote caret pra padronização das variáveis
scale_variables <- preProcess(data_train, method = c("center", "scale"))
#padronizando a base de treino
data_train_final <- predict(scale_variables, data_train)
summary(data_train_final)

#rodando a regressão linear na base padronizada
#pedindo o LM da variável Y usando todas as variáveis
modelo_01 <- lm(Y~.,data_train_final)
summary(modelo_01)
#Com isso, é possível perceber algumas variáveis que não são significativas.
#Bedroom, TotRms e Wooddeck
#Utilizando o stepwise que selecionará as variáveis
modelo_02 <- step(modelo_01, direction = "both")
summary(modelo_02)
#E percebe-se que as menos significativas são apenas Bedroom e Wooddeck
#Então, tivemos o modelo01 (de regressão) que estimou o valor do imovel
#entrando todas as variaveis que selecionei; e o modelo02 foi selecionando
#as variáveis.


#Comparando a acurácia dos 2 modelos, ou seja, aplicando-os na base teste:
#Padronizando minha base teste, igual foi feito para a base treino
names(data_test)[1] <- "Y" 
data_test_final <- predict(scale_variables, data_test)
names(data_test_final)[1] <- "Y_teste"
summary(data_test_final)

#aplicando os modelos:
predicao_modelo_01 <- predict(modelo_01, select(data_test_final,-Y_teste))
#cálculo do RMSE para a comparação com o outro modelo
install.packages("hydroGOF")
library(hydroGOF)
rmseModelo01 <- rmse(data_test_final$Y_teste, predicao_modelo_01)
rmseModelo01

#aplicando agora o modelo02:
predicao_modelo_02 <- predict(modelo_02, select(data_test_final,-Y_teste))
#cálculo do RMSE para a comparação com o outro modelo
rmseModelo02 <- rmse(data_test_final$Y_teste, predicao_modelo_02)
rmseModelo02
#A comparação que foi feita na verdade é com relação ao Erro Quadrático Médio
#ou seja, quanto menor o erro, melhor. No caso, o modelo02 é ligeiramente melhor

#Agora vamos a etapa de utilizar as Regressões Penalizadas:
#Vamos usar outros pacotes para isso.
install.packages("glmnet")
library(glmnet)

Y <- data_train_final[,1]   #Matriz de resposta
X <- data_train_final[,-1]  #Matriz das preditoras (sem intercepto). Peguei todas menos a
                            #primeira variável

#as regressoes penalizadas vao precisar estimar os hiperparametros que ajudam a melhorar
#a qualidade do meu modelo. Então, será utilizado um cross validation, que é criar umas
#amostras (no caso serão 10), pra ele testar qual hiperparametro que melhor ajusta os
#dados, cruzando as variáveis. 

set.seed(1234)
#Aqui estou criando as amostras, usando a técnica de reamostragem (para evitar sobreajuste)
control <- trainControl(method = "cv",
                        number = 10,
                        savePredictions = TRUE)

library(reshape)
library(reshape2)
library(e1071)
#Agora vem a etapa em que faço a primeira regressão penalizada (Regressão Ridge), que
#vai responder a pergunta: Será que eh possivel eu ter o hiperparametro de forma
#que ele melhore o erro quadrático médio do meu modelo? A técnica vai suavizar cada
#coeficiente para melhorar o EQM.

#para a Ridge, o alpha é igual a 0 e o lambda eh o parametro de penalidade
fit_ridge <- train(x = X,
                   y = Y,
                   method = "glmnet",
                   trControl = control,
                   metric = "RMSE",
                   tuneGrid = expand.grid(alpha = 0,
                                          lambda = seq(0, 1, by = 0.005)))

plot(fit_ridge, xvar = "lambda", label = TRUE)
#logo, ele foi testando vários alphas (hiperparametros). E agora quero saber, qual foi
#o hiperparametro que melhor ajustou meu modelo
lam_opt_ridge <- fit_ridge$finalModel$tuneValue$lambda
lam_opt_ridge
#Então, o 0.065 foi o hiperparâmetro ótimo, que melhor ajustou meu modelo
install.packages("latticeExtra")
library(latticeExtra)
plot(fit_ridge) + latticeExtra::layer(panel.abline(v = lam_opt_ridge, lty = 2))
#então é possível ver no gráfico o momento que o 0.065 corta a curva e a partir dele
#só temos a subida do erro quadratico medio.

#logo, vamos achar os coeficientes para esse lambda ótimo
round(coef(fit_ridge$finalModel, fit_ridge$bestTune$lambda), digits = 10)
#comparando esse "modelo03" com o modelo 01
summary(modelo_01)

#vamos ver se ficou melhor mesmo:
predicaoridge1 <- predict(fit_ridge, select(data_test_final, -Y_teste))
rmseridge1 <- rmse(data_test_final$Y_teste, predicaoridge1)
rmseridge1 #acabou diminuindo o erro


#segunda técnica de regressão penalizada (LASSO), alem de suavizar o erro, pode optar
# por zerar alguma variável que entenda não ser útil pro modelo
# para a regressao LASSO, o alpha é o 1.

fit_lasso <- train(x = X,
                   y = Y,
                   method = "glmnet",
                   trControl = control,
                   metric = "RMSE",
                   tuneGrid = expand.grid(alpha = 1,
                                          lambda = seq(0.005, 1, by = 0.05)))
plot(fit_lasso, xvar = "lambda", label = TRUE)

lam_opt_lasso <- fit_lasso$finalModel$tuneValue$lambda
lam_opt_lasso
#então, podemos ver qual o melhor ponto de corte = 0.005
plot(fit_lasso) + latticeExtra::layer(panel.abline(v = lam_opt_lasso, lty = 2))
#coeficientes para o lambda ótimo (zerou o totrmsabvgrd)
round(coef(fit_lasso$finalModel, fit_lasso$bestTune$lambda), digits = 10)
#achando o EQM
predicaolasso1 <- predict(fit_lasso, select(data_test_final, -Y_teste))
rmselasso1 <- rmse(data_test_final$Y_teste, predicaolasso1)
rmselasso1 #acabou diminuindo o erro



#Comparando os 3:

rmseModelo01
rmseModelo02
rmseridge1
rmselasso1