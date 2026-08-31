# Roadmap — UI & systèmes transversaux

## Phase UI-1 — Fondations de l'interface

**Objectif :** disposer d'une structure UI propre sur laquelle les autres éléments pourront être ajoutés.

* [x] Définir la responsabilité de `UI` dans `GameRoot`
* [x] Définir comment l'UI communique avec le joueur et les autres systèmes
* [x] Créer la structure de base de l'interface
* [x] Définir la gestion des écrans ouverts/fermés
* [x] Permettre d'ouvrir/fermer une interface avec une touche
* [ ] Gérer correctement la pause du gameplay lorsqu'un écran le nécessite
* [ ] Vérifier que l'UI reste indépendante du niveau actuellement chargé

**Jalon :**

> `GameRoot` possède une UI fonctionnelle capable d'afficher plusieurs interfaces sans que chaque niveau ait à gérer directement l'UI.

---

## Phase UI-2 — Persistance des données

C'est probablement **la première vraie fondation transversale** dont tu as besoin.

L'objectif n'est pas encore de faire le système de sauvegarde complet.

Il faut d'abord répondre à :

> **Comment un système conserve-t-il une information pendant toute la partie ?**

* [x] Définir ce qu'est une donnée persistante
* [x] Définir où sont stockées les données persistantes
* [x] Définir comment un système enregistre une modification
* [x] Définir comment un système récupère une donnée
* [x] Définir comment identifier les éléments persistants
* [x] Tester la persistance d'une donnée simple
* [x] Tester la persistance d'un collectible récupéré
* [x] Tester la persistance d'une porte/mur ouvert

**Jalon :**

> Un système peut dire « cet élément a déjà été récupéré/ouvert » et retrouver cette information plus tard pendant la partie.

### Important

Je séparerais volontairement :

**Persistance en mémoire**

> l'information reste pendant la session.

et :

**Sauvegarde sur disque**

> l'information survit à la fermeture du jeu.

Tu as besoin de la première **avant** de pouvoir proprement construire la seconde.

---

## Phase UI-3 — Inventaire

**Objectif :** disposer d'un système d'inventaire suffisamment simple pour les besoins actuels.

Pour l'instant, ton inventaire contient principalement :

* [ ] consommables
* [ ] collectibles

Les capacités restent séparées.

* [x] Définir ce qu'est un objet dans le jeu
* [x] Définir les catégories d'objets
* [x] Définir les données minimales d'un objet
* [x] Créer le système permettant de posséder un objet
* [x] Gérer les quantités pour les objets empilables
* [x] Ajouter un objet à l'inventaire
* [x] Consommer un objet
* [x] Empêcher la récupération multiple d'un collectible
* [x] Faire persister l'inventaire pendant la partie

**Jalon :**

> Le joueur peut récupérer un objet, le posséder, le consommer si nécessaire et retrouver correctement son état.

---

## Phase UI-4 — Affichage de l'inventaire

Maintenant seulement, on construit l'interface.

* [ ] Créer l'écran d'inventaire
* [ ] Afficher les objets possédés
* [ ] Afficher leur quantité
* [ ] Sélectionner un objet
* [ ] Afficher les informations de l'objet sélectionné
* [ ] Utiliser un consommable depuis l'inventaire
* [ ] Fermer l'inventaire et reprendre le jeu
* [ ] Vérifier que l'affichage reflète immédiatement les changements de l'inventaire

**Jalon :**

> Le joueur peut ouvrir son inventaire, voir ce qu'il possède et utiliser un consommable.

---

## Phase UI-5 — Barre de vie

Celle-ci est volontairement petite.

* [ ] Définir les informations que l'UI reçoit du joueur
* [ ] Afficher les PV actuels
* [ ] Afficher les PV maximum
* [ ] Mettre à jour l'affichage après des dégâts
* [ ] Mettre à jour l'affichage après une récupération
* [ ] Masquer ou adapter l'affichage pendant la mort si nécessaire

**Jalon :**

> Le joueur sait toujours quel est son état de santé.

---

## Phase UI-6 — Dialogues

Ici, on commence à toucher à quelque chose de beaucoup plus important pour ton jeu.

Je ne chercherais surtout pas à faire immédiatement **le système narratif définitif**.

On commence par le minimum permettant de faire fonctionner `Cave`.

* [ ] Définir les données nécessaires à un dialogue
* [ ] Afficher le texte d'un PNJ
* [ ] Permettre de passer au texte suivant
* [ ] Afficher plusieurs choix
* [ ] Permettre au joueur de sélectionner un choix
* [ ] Déterminer le résultat d'un choix
* [ ] Fermer correctement le dialogue
* [ ] Bloquer les actions normales du joueur pendant le dialogue
* [ ] Reprendre le gameplay après le dialogue
* [ ] Tester un dialogue linéaire
* [ ] Tester un dialogue avec choix
* [ ] Tester un dialogue dépendant d'un état du jeu

**Jalon :**

> Un PNJ peut avoir une conversation avec le joueur et ses dialogues peuvent dépendre de l'état du jeu.

---

## Phase UI-7 — Objectif

Tu as dit que l'interface devait afficher un objectif.

Je le garderais extrêmement simple pour l'instant.

* [ ] Définir ce qu'est un objectif
* [ ] Afficher l'objectif actuel
* [ ] Modifier l'objectif
* [ ] Masquer l'objectif lorsqu'il n'est plus pertinent
* [ ] Vérifier que l'objectif peut être modifié par la progression narrative

**Jalon :**

> Le joueur sait ce qu'il est actuellement censé chercher ou accomplir.

---

## Phase UI-8 — Carte

La carte est importante pour un Metroidvania, mais **pas nécessaire pour débloquer immédiatement le reste de** **`Cave`**.

Je la mettrais donc après inventaire/dialogues.

* [x] Créer l'écran de carte
* [x] Afficher les zones découvertes
* [x] Masquer les zones inconnues
* [x] Afficher la position du joueur
* [x] Mettre à jour la carte lors de l'exploration
* [x] Faire persister les zones découvertes
* [ ] Permettre de naviguer dans la carte

### Facultatif

* [ ] Ajouter des marqueurs personnalisés
* [ ] Permettre de supprimer/modifier les marqueurs

---

## Phase UI-9 — Menu principal et pause

Une fois les systèmes précédents fonctionnels :

* [ ] Créer le menu de pause
* [ ] Accéder à l'inventaire
* [ ] Accéder à la carte
* [ ] Accéder aux autres écrans nécessaires
* [ ] Reprendre la partie
* [ ] Ajouter les options nécessaires
* [ ] Préparer l'accès à la sauvegarde

---

## Phase UI-10 — Sauvegarde

**Je la place volontairement assez tard.**

Parce que maintenant que nous savons que ton jeu doit restaurer :

> position + progression narrative + portes + collectibles + capacités + inventaire + carte + événements...

on a intérêt à avoir déjà construit plusieurs de ces systèmes avant de décider précisément comment sérialiser leur état.

* [ ] Définir les données à sauvegarder
* [ ] Définir le format de sauvegarde
* [ ] Faire enregistrer les données persistantes
* [ ] Sauvegarder la position du joueur
* [ ] Sauvegarder la progression narrative
* [ ] Sauvegarder l'inventaire
* [ ] Sauvegarder les capacités
* [ ] Sauvegarder les collectibles
* [ ] Sauvegarder les éléments persistants du monde
* [ ] Sauvegarder la carte découverte
* [ ] Charger une sauvegarde
* [ ] Restaurer correctement l'état du monde
* [ ] Tester une sauvegarde puis fermeture complète du jeu
* [ ] Tester la reprise de partie

### Facultatif

* [ ] Sauvegarde automatique
* [ ] Plusieurs slots

**Jalon majeur :**

> Quitter le jeu puis reprendre une partie restaure correctement son état.
