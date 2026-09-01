# The Blood Moon

**The Blood Moon** est un projet de jeu narratif développé avec Godot.

Le dépôt contient à la fois le projet du jeu et les ressources nécessaires à la conception de son univers narratif.

## Prérequis

* **Godot 4.6.3.stable.official [7d41c59c4]**
* **Git**

Aucune dépendance ni aucun plugin supplémentaire n'est nécessaire.

## Récupérer le projet

Cloner le dépôt Git :

```bash
git clone <URL_DU_DEPOT>
cd <DOSSIER_DU_PROJET>
```

Le projet Godot se trouve dans le répertoire `game/`.

## Lancer le projet

Le projet se lance depuis l'éditeur Godot.

Ouvrir Godot, puis importer le projet situé à l'emplacement suivant :

```text
game/project.godot
```

Une fois le projet ouvert, il peut être lancé directement depuis l'éditeur.

> Le projet n'est actuellement pas prévu pour être lancé directement depuis la ligne de commande.

## Développement

Pour travailler sur le jeu, se placer dans le répertoire `game/` :

```bash
cd game
```

Ce répertoire contient le projet Godot et constitue l'environnement de développement du jeu.

La documentation spécifique au développement du jeu est disponible dans [`game/README.md`](game/README.md).

## Organisation du dépôt

Le dépôt est principalement divisé en deux parties :

* **`game/`** — projet Godot et ressources nécessaires au développement du jeu ;
* **`lore/`** — documentation narrative et worldbuilding de l'univers.

Chaque partie possède son propre README pour sa documentation détaillée :

* [`game/README.md`](game/README.md)
* [`lore/README.md`](lore/README.md)

Cette séparation permet de maintenir indépendamment la partie **technique** du projet et sa partie **narrative**.

## Philosophie du projet

The Blood Moon sépare volontairement le développement du jeu et la conception de son univers.

Le répertoire `game/` est orienté vers la production et le développement technique du jeu.

Le répertoire `lore/` constitue la base de référence pour l'univers narratif et peut évoluer indépendamment de l'implémentation du jeu.

## Statut

Projet indépendant en développement.

La structure et le contenu du projet sont susceptibles d'évoluer.

# Droits d'auteur

© 2026 GhostOfShadow31 & Severinvlm. Tous droits réservés.

Ce jeu est une œuvre collaborative créée conjointement par les auteurs mentionnés ci-dessus.

Le code source est mis à disposition du public à des fins de consultation uniquement. Aucune autorisation n'est accordée pour copier, modifier, distribuer, sous-licencier ou utiliser le code source ou le jeu sans l'autorisation préalable des deux détenteurs des droits d'auteur.
