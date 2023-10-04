## MODULES 
import os
import sys

###################################################################################################
## LISTER LES FICHIERS ET REPERTOIRES D'UN REPERTOIRE                                            ##
###################################################################################################

## Spécifiez le chemin du répertoire à lister
path = "/chemin/vers/le/repertoire"

def AfficherFicEtRepertoires(p) :
    """
    Fonction qui affiche les fichiers et les répertoires dans le chemin spécifié p.
    p : le chemin du répertoire que l'on souhaite parcourir.
    """
    # Utilisez la fonction listdir pour obtenir la liste des fichiers et répertoires
    contents = os.listdir(p)

    # Parcourez la liste pour afficher les noms
    for item in contents:
        print(item)


###################################################################################################
## PARCOURIR RECURSIVEMENT UN REPERTOIRE                                                         ##
###################################################################################################

## OBJECTIF :
## - Créer une structure de code de base dans lequel on peut ajouter diverses fonctions tels 
##+ que le dézippage, l'extraction etc

## Indiquer chemin du répertoire :
chemin_racine = r"C:\Users\will\Documents\GitHub\MES_PROJETS\DVF_IDF"

def AfficherFicEtRepertoiresRecursifs(p) :
    ## Utiliser os.walk pour parcourir récursivement

    ## Parcourir le répertoire indiqué au-dessus avec os.walk :
    for dossier_actuel, sous_dossiers, fichiers in os.walk(p):
        ## Pour chaque fichier trouvé dans le répertoire ...
        for fichier in fichiers:
            ## ... joindre son nom avec le chemin.
            chemin_fichier_complet = os.path.join(dossier_actuel, fichier)
            ## Afficher le résultat
            print(chemin_fichier_complet)



def ma_fonction(arg1, arg2):
    """Fonction de test pour sys et l'utilisation des paramètres"""
    # Votre code ici
    print(f"Argument 1 : {arg1}")
    print(f"Argument 2 : {arg2}")

###################################################################################################
## EXECUTION                                                                                     ##
###################################################################################################


if __name__ == "__main__":
    ## Récupérer les arguments de la ligne de commande
    arg1 = sys.argv[1]

    # Appelez la fonction avec les arguments
    AfficherFicEtRepertoires(arg1)
