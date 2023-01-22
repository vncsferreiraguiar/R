#Exercicio - Notas 

#Definindo a pasta de trabalho 
setwd("C:/Users/User/Documents/Exercicios_PBI/DataScienceAcademy/Cap12/Exercicio")
getwd()

#Carregando Dataset 
notas <- read.csv("notas.csv", fileEncoding = "windows-1252")

#Questão 1
#Resumo dos Dados

View(notas)
str(notas)
summary(notas)

#Questão 2
#Média por Turma
MediaA <- mean(notas$TurmaA)
MediaB <- mean(notas$TurmaB)


print(MediaA)
print(MediaB)

#Questão 3 
#Maior Variabilidade nas notas

#Desvio padrao
dpA <- sd(notas$TurmaA)
dpB <- sd(notas$TurmaB)

#Justificativa da resposta: 
#A turmaA possuí Desvio padrão maior em relação a TurmaB, sendo possível aferir que a
#Variabilidade das notas é maior na TurmaA. 

#Questão4 
#Coeficiente de Variação 
#Demonstra a variabilidade dos dados em termos percentuais. 
#TurmaA
cvA<- dpA / MediaA * 100
print(cvA)

#TurmaB 
cvB <- dpB/MediaB * 100
print(cvB)

#Questão 5 
#Qual nota apareceu mais vezes ? 
#Moda

#Turma A e B 
moda <- function(n) {
  valor_unico <- unique(n)
  valor_unico[which.max(tabulate(match(n, valor_unico)))]
}

#Obtendo a moda TurmaA
modaA <- moda(notas$TurmaA)
ModaB <- moda(notas$TurmaB)

