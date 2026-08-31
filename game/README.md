# The Blood Moon — Game

Ce répertoire contient le projet Godot de **The Blood Moon**.

Il constitue l'environnement de développement du jeu. Pour les informations générales sur le projet, consulter le [README principal](../README.md).

## Prérequis

* **Godot 4.6.3.stable.official [7d41c59c4]**

Aucune dépendance ni aucun plugin supplémentaire n'est nécessaire.

## Ouvrir le projet

Depuis Godot, importer le fichier :

```text
project.godot
```

Le projet peut ensuite être lancé directement depuis l'éditeur Godot.

## Développement

Le développement du jeu se fait entièrement dans ce répertoire.

L'organisation du projet est susceptible d'évoluer au cours du développement. Lorsqu'une modification importante de l'architecture intervient, le fichier [`Architecture.md`](Architecture.md) doit être mis à jour afin de conserver une documentation cohérente du projet.

## Organisation

```text
game/
├── assets/          # Ressources graphiques et autres ressources du jeu
├── data/            # Données utilisées par le jeu
├── game/            # Éléments internes du jeu
├── shaders/         # Shaders
├── Architecture.md  # Documentation de l'architecture du projet
├── icon.svg         # Icône du projet
├── License.md       # Informations relatives aux licences utilisées
├── project.godot    # Fichier principal du projet Godot
└── README.md        # Documentation du projet
```

Les fichiers de travail temporaires et les documents de suivi du développement ne sont pas nécessairement représentés dans cette arborescence.

## Architecture

Le fichier [`Architecture.md`](Architecture.md) constitue la référence concernant l'organisation et l'architecture technique du projet.

Il doit être consulté avant d'effectuer des modifications importantes à la structure du projet et mis à jour lorsque celle-ci évolue de manière significative.

## Documentation

* [Architecture](Architecture.md) — organisation et architecture technique du projet.
* [README principal](../README.md) — présentation générale du projet et informations pour démarrer.
* [Documentation du lore](../lore/README.md) — univers narratif et worldbuilding.

## Statut

Le projet est en développement.

L'organisation actuelle du projet n'est pas définitive et peut évoluer en fonction des besoins du développement.
