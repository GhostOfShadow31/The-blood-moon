# The Blood Moon

Projet de jeu narratif développé avec Godot.

---

## Structure du projet

Le projet est organisé en deux parties principales à la racine :

### `game/`

Contient tout ce qui concerne le jeu en lui-même :

* `scenes/` : scènes Godot (niveau, UI, menus…)
* `scripts/` : scripts du gameplay
* `shaders/` : shaders graphiques
* `data/` : données diverses du jeu
* `project.godot` : fichier principal du projet Godot
* `icon.svg` : icône du projet
* `README.md`, `License.md`, `Architecture.md` : documentation du jeu

C’est le cœur jouable du projet.

---

### `lore/`

Contient l’univers narratif et la documentation du monde :

* `00_bible.md` : base de l’univers
* `01_civilisations/` : description des civilisations
* `02_apostle/` : éléments liés aux figures centrales
* `decisions_canon.md` : décisions officielles du lore
* `inbox/` : idées et éléments en cours de tri
* `README.md` : documentation du lore

C’est toute la partie écriture et worldbuilding.

---

## Philosophie du projet

* Séparation claire entre **gameplay** et **univers narratif**
* Le dossier `game/` reste technique et orienté production
* Le dossier `lore/` sert de base de référence créative

---

## Lancer le projet

Ouvrir simplement le projet Godot :

```bash
cd game
godot project.godot
```

---

## Notes

* Le projet utilise Godot Engine
* Le lore est conçu pour évoluer indépendamment du gameplay
