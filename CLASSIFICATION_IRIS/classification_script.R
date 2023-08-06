## CLASSIFICATION DES IRIS INSEE GPSEA
## 12/12/22

## ----- MOTIVATIONS (expliquer l'intérêt d'une telle analyse)
## Les méthodes de classification permettent de regrouper
##+ les individus ou les variables, selon leur ressemblance.
## Quand on s'intéresse à la méthode CAH (classification ascendante hiérarchique)
##+ on effectue un regroupement par individus. Les groupes issus de 
##+ la classification seront homogènes à l'intérieur et
##+ hétérogène à l'extérieur.
## Il est intéressant de faire des regroupement thématiques

## ----- OBJECTIFS
# - réaliser une classification des IRIS de GPSEA selon des variables socio-démo,
# - voir comment sont construites les classes ;
# - injecter les données dans GEO ou dans un document de présentation ;

## Les données qu'on va utiliser :
## - revenus disponible median à l'échelle IRIS ;
## - le loyer au m² par commune ;
## - nb d'emploi par IRIS ;

## ----- SCRIPT ET ANALYSE DE DONNEES

## ---- CHARGEMENT DES DONNEES ET DESCRIPTION
## source de la donnée : https://www.insee.fr/fr/statistiques/6049648
## éléments de documentation : https://www.insee.fr/fr/metadonnees/definition/c1523



## définir l'espace de travail :
setwd("C:\\Users\\will\\Documents\\GitHub\\PROJETS_PERSO\\CLASSIFICATION_IRIS")
getwd()

## ----- PREPROCESSING

## charger les jeux de données
## remarque : les données sont une extraction depuis Calc des iris commençant
##+ par 94
iris_2019 <- read.table(".\\DONNEES\\iris_94_2019.csv",
				sep=",", header=TRUE, dec=".", encoding="utf-8")
head(iris_2019) ## afficher les 5 premières lignes (1 à 5).

## remarque : R commence ses lignes/colonnes à 1
## remarque : ne pas confondre avec les langages informatiques type py
##+ ou encore FME qui comptent à partir de 0.

## Nettoyage des données
## Quelles sont les variables que l'on conserve ?
## Pour identifier les variables à conserver, il faut connaître leur signification
## On se reporte donc au dictionnaire des variables fournis lors du téléchargement.

## Que cherche-t-on ?
## Les données IRIS fournies concernent les revenus disponibles.
## les variables sélectionnées : IRIS, DISP_TP6019, DISP_MED19, DISP_GI19, DISP_PACT19
## Ainsi, l'idée est de savoir comment est-ce que les IRIS se regroupent 
##+ en fonction des richesses disponibles.

## Créer un df des colonnes qui nous intéressent :
subd <- data.frame(IRIS=iris_2019$IRIS, 
			TXPAUV60=iris_2019$DISP_TP6019, 
			REVDISPMED=iris_2019$DISP_MED19, 
			GINI=iris_2019$DISP_GI19, 
			PARTREVACT=iris_2019$DISP_PACT19)
## Qu'est-ce qu'un DF ? Pourquoi un DF ?
## subd est un df qui est stocké dans R.
## Il n'est pas stocké en dur dans la machine.

## Verif
head(subd)
dim(subd)
summary(subd) ## résumé statistique
## Qu'est-ce qu'un résumé statistique ?
## En quoi est-ce qu'il est intéressant ?
## - on peut checker le type des variables
## - permet une première comparaison rapide quand plusieurs variables comparables
## - informe sur la distribution des variables
## Une meilleure représentation de la disitrbution des variables :
hist(subd$TXPAUV60) ## la fonction hist()
## Qu'est-ce qu'un histogram ? (intérêts, forces, constructions)
boxplot(subd$TXPAUV60)
## Qu'est-ce qu'un boxplot ? (intérêts, forces, constructions)
## - constructions :
## - outliers : quelles informations ? Quels comportements à adopter ?

## remarques sur les graphiques produits :
## - dans R les graphiques sont exportables.
## - dans R les graphiques ne sont pas gardés.
## - dans RStudio (IDE R) il est possible de garder en mémoire plusieurs graphiques
## - dans RStudio, les graphiques sont déformés.
## - le langage possède des bibliothèques pour embellir les graphiques
##+ notamment ggplot2 qui est souvent cité.

## A propos de la forme des distributions ...
## Possibilité d'ajouter la moyenne et la médiane sur les graphiques ?
## Quelles informations supplémentaires ?

## regarder les corrélations entre les variables
## définir la notion de corrélation
cor(subd[,2:5], use = "complete.obs") ## ne pas tenir compte des na
## les valeurs ici sont données à titre indicatif !
## Les coefficients de corrélations doivent être significatifs avant de 
##+ parler concrètement de corrélation entre une ou plusieurs variables.
## mais ça nous donne déjà quelques éléments de réflexion.

## Nous allons regrouper des variables
## Or celles-ci doivent pouvoir être comparées
## Les variables sont dans des unités différentes
##+ alors il faut s'affranchir des unités
##+ dans ce cas, on utilise une opération : centrer-réduire
## En R, on utilise la fonction scale() (rBase)
## row.names : définir une colonne comme id
## data.frame n'est pas une méthode de data !
subd_2 <- data.frame( CODE_IRIS=subd$IRIS, TXPAUV60=scale(subd$TXPAUV60), 
		REVDISPMED=scale(subd$REVDISPMED),
		GINI=scale(subd$GINI), PARTREVACT=scale(subd$PARTREVACT) )
head(subd_2)

## On a "fini" la préparation des données
##+ et l'analyse descriptive "basique".
## On peut passer à la classification


## ---- TRAITEMENTS
## La classification ascendante hiérarchique (CAH) - plus de précisions :

## calcul de distance entre les variables :
dist(head(subd_2))
## La distance calculée est la distance euclidienne.
## On peut afficher les résultats sous forme de matrix (tableau 2D)
as.matrix(round(dist(subd_2),2))

## le calcul des distances nous donne un premier aperçu des possibles
##+ groupe que l'on pourrait former
## Le jeu de données étant assez conséquent, on ne prendra pas le temps
##+ de le faire totalement.
## Cette opération se fait visuellement, pour commencer à imaginer
##+ des cas possibles et confronter les résultats aux connaissances
##+ acquises
## Calcul de toutes les distances euclidiennes :
DDist <- dist(subd_2, method = "euclidean")
DDist
## Quelles sont les valeurs min et max ?
range(DDist)

## classification avec hclust() :
hc <- hclust(DDist)
hc

x11() ## fenêtre graphique, pas obligatoire de l'appeler.
plot(hc) ## plot() est une fonction générique de représentation graphique

## le graphique représenté ici est un dendrogram
## c'est un arbre qui va indiquer les groupes
## il n'y a pas de méthode spécifique de sélection
## on fait le choix en fonction des besoins
## Mais, plus un groupe est petit, et plus il sera homogène
## Plus un groupe est grand, plus il sera hétérogène

## Découpage en 7, 10, 15 classes:
Clusters <- cutree(hc, k=15) 
Clusters 

## Puis ajouter à un df :
MM3 <- cbind(subd_2, Clust = Clusters) ## cbind() pour coller des colonnes
head(MM3)

## ---- RESULTATS
## export des résultats
install.packages("openxlsx") ## installer un package, une seule fois
library(openxlsx) ## charger un package
write.xlsx(x = MM3, file = ".\\RESULTATS\\iris_2019_CAH_15cls.xlsx") ## écrire un package
