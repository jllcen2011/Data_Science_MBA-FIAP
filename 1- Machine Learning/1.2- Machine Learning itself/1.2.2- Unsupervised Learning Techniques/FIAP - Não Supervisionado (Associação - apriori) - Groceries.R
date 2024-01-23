install.packages("arules")
install.packages("arulesNBMiner")
install.packages("arulesViz")
library(arules)
library(arulesViz)

#esse é o pacote para acessar o dataset
#essa é uma base do tipo transactions. Quando precisar utilizar uma base para análise
#específico do aprioli, é necessário ter essa base transaction, em que cada linha
#é um cliente e aí vai ter toda a sequência de compras dele.
library(datasets)
#carregando o dataset
data("Groceries")
summary(Groceries)
#é uma base com 9835 linhas, 169 variáveis (possibilidades de compra que realizaram).
#Por isso a tecnica utilizada é o não supervisionado, pois nao tenho nenhuma variavel,
#nenhum padrão que eu já vou definir. Vamos deixar que essas amostras me tragam
#as associações, qu evai ser pela forma como as pessoas compram no dia a dia nessa
#loja. É possível ver os itens comprados mais frequentemente, separados por grupos.
#Mostra também quantas vezes cada um dos 32 produtos foi comprado. Mostram as estatísticas
#do n° de compras por pessoa, com uma média de 3, mínimo de 1 e máximo de 32.

#Dando uma olhada na primeira linhad a base de dados
inspect(Groceries[1])
LIST(Groceries)[1]
itemFrequencyPlot(Groceries, topN = 25, type = 'absolute')
# esse é a análise em absoluto, mas talvez seja melhor olhar em percentual do total, pois
#estou falando de uma amostra e não de toda a população.
library("RColorBrewer")
arules::itemFrequencyPlot(Groceries, topN=25, col = brewer.pal(8, "Pastel2"),
                          main = "gráfico de frequência relativa do item",
                          type = "relative", ylab = "Frequência do item (relativa)")


#a função apriori() executa um algoritmo para a criação das regras de associação
#sobre uma amostra. Sempre há um conjunto de parametrizações predefinidos de origem,
#entretanto, é possível adaptar o nível de detalhes que se pretende analisar.
#O parâmetro support é um parâmetro que mede qual o percentual que encontro na minha base
#entre dois produtos. Então, eu tenho associações mais usuais ou mais raras. Quanto menor
#isso menos acontece na base de dados. Na função definida, só vão ser considerados os casos
#em que reflete no mínimo 0,5% de informações sobre o total da amostra
#O parâmetro confiança é a probabilidade ou a segurança que tenho na minha análise de que X e Y
#caminhem juntos. Ou seja, tendo comprado o produto X, qual a confiança que eu tenho ao propor
#o produto Y. Já o Minlen é quantas associações de produtos que eu quero. No caso, escolhi no
#mínimo 2 a 2, que é o mínimo.
rules = apriori(Groceries, parameter = list(support = 0.005, confidence = 0.25, minlen = 2))
summary(rules)

#como foram criadas 662 regras de associações, eu vou selecionar só algumas pra poder olhar.
#Serão aquelas regras com maior lift.
options(digits = 2)
inspect(head(sort(rules, by = "lift"), 15))
#Então, do maior pro menor peso (lift), eu tenho que {citrus fruit, other vegetables, whole milk} têm
#maior força de associação com os root vegetables, por exemplo.
#agora olhando não mais por lift, mas por confidence:
inspect(head(sort(rules, by = "confidence"), 15))
# Nesse caso, a maior confiança está na associação de {tropical fruit, root vegetables, yogurt} com
# whole milk

#as colunas lhs (valor X) e rhs (valor Y) sao as associações criadas e analisadas pelo
#algoritmo apriori().

#Sobre a coluna de support, é demonstrada a frequência de acontecimentos
#de associações (count) sbre o total de registros da amostra. Ou seja, A associação
#{citrus fruit, other vegetables, whole milk} com {root vegetables} está presente em 0.58%
#da amostra. E ela possui o maior Lift (4.1). Uma maior taxa no support significa uma
#maior clareza dos resultados, devido às repetições dessa associação no nosso dataset.

#Sobre a coluna Confidence, temos a probabilidade de termos aquela associação para cada regra
#criada, com base na frequência de acontecimentos de um caso Y acontecer quando X também existir.
#Então, quando organizamos por confiança, temos que quando aparece {tropical fruit,
#root vegetables, yogurt}, há uma probabilidade de 70% de que o {whole milk} irá aparecer
#em 0.57% da amostra.

#Quanto ao lift, ele serve pra medir o quão frequente lhs e rhs ocorrem juntos quando
#comparado se fossem estatisticamente independentes. Quando o valor é superior a 1,
#significa que lhs e rhs são correlacionados, ou seja, a existência de X implica 
#necessariamente a existência de Y.

#A coluna count diz quantas vezes aquela associação ocorreu.

#Se eu quiser olhar graficamente essas métricas:
library(RColorBrewer)
plot(rules, control = list(col = brewer.pal(9, "Spectral")), main = "", jitter=0)

#O Lift é o grau de associação entre os produtos, quanto mais forte, mais é
#associado, ou seja, é comprado muito junto.
#O support me diz a frequência com que aquela associação acontece.
#E a confiança, o grau de confiança que esses produtos têm ao serem
#comprados juntos.

#Com isso, quando um cliente enche o carrinho com os produtos X,Y,Z, 
#eu consigo saber qual eu devo propor a ele, pois terei como base a
#associação feita quando outros clientes fizeram compras parecidas.
