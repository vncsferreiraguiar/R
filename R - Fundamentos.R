#Loops 

#Exemplo For 

for (i in seq(12)){
  print(i)
}

#Exemplo While
i <- 0 

while(i <=10){
  print(i)
  i = i+1
}

#Exemplo If
x = 10 
if (x>0){
  print("Número Positivo")
}

#exemplo 2
nota = 4
if(nota>= 7) {
  print("Aprovado")
}else if (nota> 5 && nota <7){
  print("Recuperação")
} else {
  print("Reprovado")
}


#Criando Funções 

par.impar <- function(num){
  if((num %% 2)== 0){
    return("Par")
  }else
    return("Ímpar")
}

#Usando a Função
num = 3
par.impar(num)


#Apply 

x <- seq(1:9)
matriz <- matrix(x,ncol=3)
matriz

result1 <- apply(matriz,1,sum)
result1


result2 <- apply(matriz,2,sum)
result2

#Sapplay (para vetores e listas)

numeros.p <- c(2,4,6,8,10,12)
numeros.i <- c(1,3,5,7,9,11)

numeros <- list(numeros.p, numeros.i)

numeros

?iris

lapply(numeros, mean)

sapply(numeros, mean)


#Graficos 
?mtcars
carros <- mtcars[,c(1,2,9)]

head(carros)

hist(carros$mpg)


plot(carros$mpg, carros$cyl)

library(ggplot2)

ggplot(carros, aes(am)) +
  geom_bar()

#Unidade 3
#Join
#install.packages("dplyr")
library(dplyr)

df1 <- data.frame(Produto = c(1,2,3,5), Preco = c(15,10,25,20))
head(df1)

df2 <- data.frame(Produto = c(1,2,3,4), Nome = c("A","B","C","D"))
head(df2)

#Resultado da junção df1 + df2 usando left join
df3 <- left_join(df1,df2,"Produto")
head(df3)

#Resultado da junção df1 + df2 usando right join
df4 <- right_join(df1,df2, "Produto")
head(df4)

#Resultado da junção df1 + df2 usando inner join
df5 <- inner_join(df1, df2, "Produto")
head(df5)

#_______________
head(iris)
#Visualizando o tipo dos dados com glimpse
glimpse(iris)

#Filter - filtrando os dados - apenas versicolor
versicolor <- filter(iris, Species == "versicolor")
versicolor
dim(versicolor)

#Slice - Selecionando algumas linhas especificas
slice(iris, 5:10)

#Select - selecionando algumas colunas
select(iris, 2:4)

#Selecionando todas as colunas exceto Sepal width
select(iris, -Sepal.Width)

#Criando uma nova coluna com base em colunas existentes (Sepal.Length + Sepal.Width)
iris2 <- mutate(iris, nova.coluna = Sepal.Length + Sepal.Width)
iris2[,c("Sepal.Length", "Sepal.Width", "nova.coluna")]


#Arrange - ordenar os dados
?arrange

select(iris, Sepal.Length) %>%
  arrange(Sepal.Length)


#Group by
?group_by

# Agrupando os dados - Tamanho médio da sépala por espécie
iris %>% group_by(Species) %>%
  summarise(mean(Sepal.Length))

#Tidyr
install.packages("tidyr")
library(tidyr)

#Quantidade de vendas por ano e produto


#Dataframe - Quantidade de Produtos por Ano
dfDate <- data.frame(Produto = c('A','B','C'),
                     A.2015 = c(10,12,20),
                     A.2016 = c(20,25,35),
                     A.2017 = c(15,20,30)
)

head(dfDate)

#Utilizando a função gather para mudar o formato da tabela
?gather

dfDate2 <- gather(dfDate, "Ano", "Quantidade", 2:4)
head(dfDate2)

#install.packages("dplyr")
library(dplyr)

?separate

#Criando uma nova coluna para separar os dados
dfDate3 <- separate(dfDate2, Ano, c("A", "Ano"))
dfDate3

#Removendo a coluna 
dfDate3 <- dfDate3[-2]
dfDate3

#Acrescentando uma coluna Mês
dfDate3$Mes <- c('01','02','03')

dfDate3

#Fazendo a união da coluna Ano e Mês
?unite

#Criando a coluna Data para receber Mês e Ano - separado por /
dfDate4 <- dfDate3 %>%
  unite(Data, Mes, Ano, sep = '/')

head(dfDate4)

?iris



