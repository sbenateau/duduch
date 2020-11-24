# But

Offrir tout notre amour à docteur duduch

# Installation

Ce dépot peut être installé de différentes façon

1.  Cloner le dépot sur son ordinateur

Dans le terminal de Rstudio ou un terminal:

``` bash
git clone https://github.com/sbenateau/duduch.git
```

2.  Le télécharger

# Utilisation

Ces applications nécessitent d’avoir installé le package `shiny` dans R.
Vous pouvez lancer une application en lancant la commande pointant vers
le dossier dans lequel est défini le modèle.

```r
library(shiny)
# Lancer l'application de "remerciements" de duduch 
runApp("~/my/path/to/the/repo/Docteur_Duduch/ui.R")
```

Cette commande va déployer l’application localement dans Rstudio ou un
navigateur web si vous utilisez un autre IDE.

