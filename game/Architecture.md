# Architecture du projet

Ce document décrit l'organisation actuelle du projet **The Blood Moon**.

L'architecture est susceptible d'évoluer au cours du développement. Ce document doit être mis à jour lorsque des changements importants sont apportés à l'organisation du projet.

## Arborescence générale

```text
game/
├── assets/
├── data/
├── game/
└── shaders/
```

Les fichiers de configuration et de documentation du projet (`project.godot`, `README.md`, `Architecture.md`, etc.) se trouvent directement à la racine du projet Godot.

---

## `assets/`

Contient les ressources utilisées par le jeu.

```text
assets/
├── fonts/
├── sprites/
├── textures/
└── ui/
```

### `assets/fonts/`

Contient les polices utilisées par le jeu.

### `assets/sprites/`

Contient les sprites et ressources graphiques associées aux éléments du jeu.

### `assets/textures/`

Contient les textures utilisées par le jeu.

### `assets/ui/`

Contient les ressources graphiques propres à l'interface utilisateur.

---

## `data/`

Contient les données utilisées par le jeu.

Ce répertoire est actuellement peu structuré et pourra être organisé davantage lorsque les besoins du projet évolueront.

---

## `game/`

Contient les principaux éléments fonctionnels du jeu.

```text
game/
├── core/
├── entities/
├── levels/
├── objects/
├── player/
├── ressources/
├── systems/
└── ui/
```

L'organisation de ce répertoire repose principalement sur le rôle des éléments dans le fonctionnement du jeu plutôt que sur leur type de fichier.

### `game/core/`

Contient les éléments fondamentaux et transversaux du jeu, utilisés par plusieurs parties du projet.

### `game/entities/`

Contient les entités du jeu.

### `game/levels/`

Contient les éléments liés aux niveaux et à leur fonctionnement.

### `game/objects/`

Contient les objets présents dans le monde du jeu.

### `game/player/`

Contient les éléments propres au joueur et à son fonctionnement.

### `game/ressources/`

Contient les ressources internes utilisées par les systèmes du jeu.

### `game/systems/`

Contient les systèmes qui assurent des fonctionnalités générales du jeu.

### `game/ui/`

Contient les éléments liés à l'interface utilisateur et à son fonctionnement.

---

## `shaders/`

Contient les shaders utilisés pour les effets graphiques du jeu.

---

## Principes d'organisation

L'organisation du projet privilégie une séparation par **domaine fonctionnel**.

Les ressources visuelles et autres fichiers utilisés par plusieurs parties du jeu sont regroupés dans `assets/`, tandis que les éléments qui constituent directement le fonctionnement du jeu sont organisés dans `game/`.

Cette séparation permet notamment de distinguer :

* les **ressources** utilisées par le jeu ;
* les **données** du jeu ;
* la **logique et les fonctionnalités** du jeu ;
* les **effets graphiques**.

L'organisation actuelle n'est pas considérée comme définitive. Les répertoires peuvent être réorganisés lorsqu'une évolution du projet le justifie.

## Mise à jour de l'architecture

Lorsqu'une modification importante est apportée à la structure du projet, ce document doit être vérifié et mis à jour si nécessaire.

L'objectif est de conserver une représentation suffisamment fidèle de l'architecture actuelle pour permettre à toute personne travaillant sur le projet de comprendre rapidement où placer ou rechercher un nouvel élément.
