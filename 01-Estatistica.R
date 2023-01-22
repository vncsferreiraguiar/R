#Estátistica Básica 

#Parte 1 - Medidas de Posição 

#Definindo a pasta de trabalho 
setwd("C:/Users/User/Documents/Exercicios_PBI/DataScienceAcademy/Cap12")
getwd()

#Carregando o dataset
vendas <- read.csv("Vendas.csv", fileEncoding = "windows-1252")

#Resumo do Dataset

View(vendas)
str(vendas)
summary(vendas$Valor)
summary(vendas$Custo)

#mean 
mean(vendas$Valor)
mean(vendas$Custo)

#media ponderada
weighted.mean(vendas$Valor, w = vendas$Custo)

#Mediana
median(vendas$Valor)
median(vendas$Custo)

#Moda
moda <- function(v) {
  valor_unico <- unique(v)
  valor_unico[which.max(tabulate(match(v, valor_unico)))]
}

#Obtendo a moda 
resultado <- moda(vendas$Valor)
print(resultado)

#Criando gráfico de média de valor por estado com ggplot2
install.packages("ggplot2")
library(ggplot2)

#Cria gráfico
ggplot(vendas)+
  stat_summary(aes(x= Estado,
                   y= Valor),
               fun = mean,
               geom = "bar", 
               fill = "lightgreen", 
               col= "grey50") + 
  labs(title = "Média de Valor por Estado")

#Parte 2 - Medidas de Dispersao

#Variancia
var(vendas$Valor)

#Desvio Padrao
sd(vendas$Valor)

#Parte 3 - Medidas de Posição Relativa

#Resumo de dados
head(vendas)
tail(vendas)
View(vendas)

#Medidas de Tendencia Central
summary(vendas$Valor)
summary(vendas[c('Valor','Custo')])

#Explorando Variaveis Numericas
mean(vendas$Valor)
median(vendas$Valor)
quantile(vendas$Valor)
quantile(vendas$Valor, probs = c(0.01, 0.99))
quantile(vendas$Valor, seq(from=0, to=1, by=0.20))
IQR(vendas$Valor) #Diferença entre Q3 e Q1 
range(vendas$Valor) #Valor minimo e maximo
diff(range(vendas$Valor)) # diferença minimo e maximo
