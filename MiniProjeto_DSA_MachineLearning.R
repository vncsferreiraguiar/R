#
#
#                       Mini_projeto 3
# Prevendo a Inadimplência de Clientes com Machine Learning e Power BI
#----------------------------------------------------------

#Definindo a Pasta de Trabalho
setwd("C:/Users/User/Documents/Exercicios_PBI/DataScienceAcademy/Cap15")
getwd()


#Instalando os pacotes para o projeto
#obs: a instalação precisa ser feita apenas uma vez
#install.packages("Amelia")
#install.packages("caret")
#install.packages("ggplot2")
#install.packages("dplyr")
#install.packages("reshape")
#install.packages("randomForest")
#install.packages("e1071")

#carregando os pacotes
library(Amelia)
library(ggplot2)
library(caret)
library(dplyr)
library(reshape)
library(randomForest)
library(e1071)

#Carregando o dataset
#Fonte: https://archive.ics.uci.edu/ml/datasets/default+of+credit+card+clients]
dados_clientes <-read.csv("dados/dataset.csv")

#Visualizar os dados
View(dados_clientes)
str(dados_clientes)

############# Analise Exploratória, Limpeza e Transformação ##################

#Removendo a primeira coluna ID
dados_clientes$ID <- NULL

#Renomeando a Coluna de Classe
colnames(dados_clientes)
colnames(dados_clientes)[24] <- "inadimplente"

#Verificando valores ausentes e removendo do dataset
sapply(dados_clientes, function(x) sum(is.na(x)))
?missmap
missmap(dados_clientes, main ="Valores Missing Observados")
dados_clientes<- na.omit(dados_clientes)

#Convertendo as variaveis atributos para fatores (Variaveis categorias)

colnames(dados_clientes)
colnames(dados_clientes)[2] <- "Genero"
colnames(dados_clientes)[3] <- "Educacao"
colnames(dados_clientes)[4] <- "Estado_Civil"
colnames(dados_clientes)[5]<- "Idade"

#Genero
#*Pacote "Base" faz parte da linguaguem R,  não precisa instalar nenhum pacote adicional para usar os_
#Metodos contidos nela. 

dados_clientes$Genero <- cut(dados_clientes$Genero, 
                            c(0,1,2), 
                            labels = c("Masculino", 
                                        "Feminino"))
View(dados_clientes)
str(dados_clientes$Genero)
summary(dados_clientes$Genero)

#Educacao

dados_clientes$Educacao <- cut(dados_clientes$Educacao, 
                               c(0,1,2,3,4), 
                               labels = c("Pos Graduado", "Graduado", 
                                          "Ensino Medio", "Outros"))

View(dados_clientes$Educacao)
str(dados_clientes$Educacao)
summary(dados_clientes$Educacao)

#Estado_civil 
View(dados_clientes$Estado_Civil)
str(dados_clientes$Estado_Civil)
summary(dados_clientes$Estado_Civil)

dados_clientes$Estado_Civil <- cut(dados_clientes$Estado_Civil, 
                                   c(-1,0,1,2,3), 
                                   labels = c("Desconhecido",
                                              "Casado",
                                              "Solteiro", 
                                              "Outros"))

View(dados_clientes)
str(dados_clientes$Estado_Civil)
summary(dados_clientes$Estado_Civil)

#Faixa_Etaria

View(dados_clientes)
str(dados_clientes$Idade)
summary(dados_clientes$Idade)

dados_clientes$Idade <- cut(dados_clientes$Idade, 
                            c(0, 30, 50, 100), 
                            labels = c("Jovem", "Adulto", "Idoso"))
View(dados_clientes)
str(dados_clientes$Idade)
summary(dados_clientes$Idade)

#Convertendo a variavel que indica pagamentos para o tipo fator
dados_clientes$PAY_0 <- as.factor(dados_clientes$PAY_0)
dados_clientes$PAY_2 <- as.factor(dados_clientes$PAY_2)
dados_clientes$PAY_3 <- as.factor(dados_clientes$PAY_3)
dados_clientes$PAY_4 <- as.factor(dados_clientes$PAY_4)
dados_clientes$PAY_5 <- as.factor(dados_clientes$PAY_5)
dados_clientes$PAY_6 <- as.factor(dados_clientes$PAY_6)

#dataset após as conversões
str(dados_clientes)
sapply(dados_clientes, function(x) sum(is.na(x)))
missmap(dados_clientes, main = "Valores Missing Observados")
dados_clientes <- na.omit(dados_clientes)
missmap(dados_clientes, main = "Valores Missing Observados")
dim(dados_clientes)

#Alterando a Variavel Dependente para o Tipo Fator
dados_clientes$inadimplente <- as.factor(dados_clientes$inadimplente)
str(dados_clientes$inadimplente)
View(dados_clientes)

#Avaliando Total de Inadimplentes vs Não-Inadimplentes
table(dados_clientes$inadimplente)

#Vejamos as porcentagens entre as classes 

prop.table(table(dados_clientes$inadimplente))

#Plot da distribuição usando Plot2

qplot(inadimplente, data = dados_clientes, geom = "bar") +
    theme(axis.text.x = element_text(angle = 90, hjust = 1))

#set Seed

set.seed(12345)

#Amostragem estratificada
#Seleciona as linhas de acordo com a variavel inadimplente como strata

indice <- createDataPartition(dados_clientes$inadimplente, p = 0.75, list = FALSE)
dim(indice)
View(indice)

#Definimos os dados de treinamento como subconjunto do conjunto de dados Original
#com números de indice de linha (conforme identificado acima) e todas as colunas 

dados_treino <- dados_clientes[indice,]
View(dados_treino)
table(dados_treino$inadimplente)

#Veja as Porcentagens de cada classe 
prop.table(table(dados_treino$inadimplente))

#Número de Registros no dataset de treinamento
dim(dados_treino)

#Comparamos as porcentagens entre as classes de treinamento e dados Originais
Compara_dados <- cbind(prop.table(table(dados_treino$inadimplente)), 
                       prop.table(table(dados_clientes$inadimplente)))

colnames(Compara_dados) <- c("Treinamento", "Original")
Compara_dados

#Mel Data - Converte colunas em linhas
 
melt_compara_dados <- melt(Compara_dados)
melt_compara_dados

ggplot(melt_compara_dados, aes(x = X1, y  = value)) +
  geom_bar(aes(fill = X2), stat = "identity", position = "dodge") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# TUdo o que não está no dataset de treinamento está no dataset de teste. Observe o sinal
# (-) menos, com ele segregamos aqueles dados que não estão presentes em dados_treino.
dados_teste <- dados_clientes[-indice,]
dim(dados_teste)
dim(dados_treino)

############# Modelo de Machine Learning #############


modelo_V1 <- randomForest(inadimplente ~., data = dados_treino)
modelo_V1

#Avaliando o modelo 
plot(modelo_V1)

#Previsões com dados de teste
previsoes_v1 <- predict(modelo_V1, dados_teste)

#Confusion Matrix 
#"caret::" é usado para referencia qual pacote da função, pois esta função
#existe em mais de um pacote. 

cm_v1 <- caret::confusionMatrix(previsoes_v1, dados_teste$inadimplente, positive = "1")
cm_v1

#Calculando Precision, Recall e F1-escore, métricas de avaliação do modelo preditivo
y <- dados_teste$inadimplente
y_pred_v1 <- previsoes_v1

precision <- posPredValue(y_pred_v1, y)
precision

recall <- sensitivity(y_pred_v1, y)
recall

F1 <- (2* precision*recall)/ (precision + recall)
F1

#Balanceamento de Classe
#install.packages("performanceEstimation")
library(performanceEstimation)

#Aplicando o SMOTE - SMOTE: Synthetic Minority Over-sampling Technique
# https://arxiv.org/pdf/1106.1813.pdf
table(dados_treino$inadimplente)
prop.table(table(dados_treino$inadimplente))
set.seed(9560)
dados_treino_bal <- smote(inadimplente ~ ., data  = dados_treino)                         
table(dados_treino_bal$inadimplente)
prop.table(table(dados_treino_bal$inadimplente))

# Construindo a segunda versão do modelo
modelo_v2 <- randomForest(inadimplente ~ ., data = dados_treino_bal)
modelo_v2

# Avaliando o modelo
plot(modelo_v2)

# Previsões com dados de teste
previsoes_v2 <- predict(modelo_v2, dados_teste)

# Confusion Matrix
?caret::confusionMatrix
cm_v2 <- caret::confusionMatrix(previsoes_v2, dados_teste$inadimplente, positive = "1")
cm_v2

# Calculando Precision, Recall e F1-Score, métricas de avaliação do modelo preditivo
y <- dados_teste$inadimplente
y_pred_v2 <- previsoes_v2

precision <- posPredValue(y_pred_v2, y)
precision

recall <- sensitivity(y_pred_v2, y)
recall

F1 <- (2 * precision * recall) / (precision + recall)
F1

# Importância das variáveis preditoras para as previsões
View(dados_treino_bal)
varImpPlot(modelo_v2)

# Obtendo as variáveis mais importantes
imp_var <- importance(modelo_v2)
varImportance <- data.frame(Variables = row.names(imp_var), 
                            Importance = round(imp_var[ ,'MeanDecreaseGini'],2))

# Criando o rank de variáveis baseado na importância
rankImportance <- varImportance %>% 
  mutate(Rank = paste0('#', dense_rank(desc(Importance))))

# Usando ggplot2 para visualizar a importância relativa das variáveis
ggplot(rankImportance, 
       aes(x = reorder(Variables, Importance), 
           y = Importance, 
           fill = Importance)) + 
  geom_bar(stat='identity') + 
  geom_text(aes(x = Variables, y = 0.5, label = Rank), 
            hjust = 0, 
            vjust = 0.55, 
            size = 4, 
            colour = 'red') +
  labs(x = 'Variables') +
  coord_flip() 

# Construindo a terceira versão do modelo apenas com as variáveis mais importantes
colnames(dados_treino_bal)
modelo_v3 <- randomForest(inadimplente ~ PAY_0 + PAY_2 + PAY_3 + PAY_AMT1 + PAY_AMT2 + PAY_5 + BILL_AMT1, 
                          data = dados_treino_bal)
modelo_v3

# Avaliando o modelo
plot(modelo_v3)

# Previsões com dados de teste
previsoes_v3 <- predict(modelo_v3, dados_teste)

# Confusion Matrix
?caret::confusionMatrix
cm_v3 <- caret::confusionMatrix(previsoes_v3, dados_teste$inadimplente, positive = "1")
cm_v3

# Calculando Precision, Recall e F1-Score, métricas de avaliação do modelo preditivo
y <- dados_teste$inadimplente
y_pred_v3 <- previsoes_v3

precision <- posPredValue(y_pred_v3, y)
precision

recall <- sensitivity(y_pred_v3, y)
recall

F1 <- (2 * precision * recall) / (precision + recall)
F1

# Salvando o modelo em disco
saveRDS(modelo_v3, file = "modelo/modelo_v3.rds")

# Carregando o modelo
modelo_final <- readRDS("modelo/modelo_v3.rds")

# Previsões com novos dados de 3 clientes

# Dados dos clientes
PAY_0 <- c(0, 0, 0) 
PAY_2 <- c(0, 0, 0) 
PAY_3 <- c(1, 0, 0) 
PAY_AMT1 <- c(1100, 1000, 1200) 
PAY_AMT2 <- c(1500, 1300, 1150) 
PAY_5 <- c(0, 0, 0) 
BILL_AMT1 <- c(350, 420, 280) 

# Concatena em um dataframe
novos_clientes <- data.frame(PAY_0, PAY_2, PAY_3, PAY_AMT1, PAY_AMT2, PAY_5, BILL_AMT1)
View(novos_clientes)

# Previsões
previsoes_novos_clientes <- predict(modelo_final, novos_clientes)

# Checando os tipos de dados
str(dados_treino_bal)
str(novos_clientes)

# Convertendo os tipos de dados
novos_clientes$PAY_0 <- factor(novos_clientes$PAY_0, levels = levels(dados_treino_bal$PAY_0))
novos_clientes$PAY_2 <- factor(novos_clientes$PAY_2, levels = levels(dados_treino_bal$PAY_2))
novos_clientes$PAY_3 <- factor(novos_clientes$PAY_3, levels = levels(dados_treino_bal$PAY_3))
novos_clientes$PAY_5 <- factor(novos_clientes$PAY_5, levels = levels(dados_treino_bal$PAY_5))
str(novos_clientes)

# Previsões
previsoes_novos_clientes <- predict(modelo_final, novos_clientes)
data.frame(previsoes_novos_clientes)
View(previsoes_novos_clientes)

# Fim

#Projeto DataScienceAcademy  
#Fonte de Dados:
# https://www.datascienceacademy.com.br/
