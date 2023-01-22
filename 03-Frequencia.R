# Parte 04 - Tabela de Frequencia 

#Definindo a pasta de Trabalho 
setwd("C:/Users/User/Documents/Exercicios_PBI/DataScienceAcademy/Cap12")
getwd()

#Carregando Dados

dados <- read.table("Usuarios.csv", 
                    dec = ".",
                    sep = ",", 
                    h = T, #h = header e T = True 
                    fileEncoding = "windows-1252")

#Visualizando dados
View(dados)
names(dados)
str(dados)
summary(dados$salario)
summary(dados$grau_instrucao)
mean(dados$salario) #media
mean(dados$grau_instrucao) 

#Tabela de Frequencia Absoluta
freq <- table(dados$grau_instrucao)
View(freq)

#Tabela de Frequencia Relativa (Percentual)
freq_rel <- prop.table(freq)
View(freq_rel)

#Porcentagem 
p_freq_rel <- 100 * prop.table(freq)
View(p_freq_rel)

#Adiciona Totais
freq <- c(freq, sum(freq))
View(freq)
names(freq)[4] <- "Total"
View(freq)

#Total Final com todos os valores
freq_rel <- c(freq_rel, sum(freq_rel))
p_freq_rel <- c(p_freq_rel, sum(p_freq_rel))

#Tabela Final com todos os vetores

tabela_final <- cbind(freq, 
                      freq_rel<- round(freq_rel, digits=2), #Arredondamento 
                      p_freq_rel<- round(p_freq_rel, digits=2)) #Arredondamento
  
View(tabela_final)
  

