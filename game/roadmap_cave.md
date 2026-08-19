# Roadmap — Blood Moon

## Phase 1 — Terminer la boucle fondamentale du joueur

**Objectif :** le joueur peut explorer `Cave`, subir des dégâts, mourir et reprendre sa progression.

### Mort et réapparition

* [x] Définir clairement l'état `mort` du joueur
* [x] Déclencher la mort lorsque les PV atteignent 0
* [x] Empêcher le joueur d'effectuer ses actions normales pendant sa mort
* [~] Déclencher la rencontre avec La Mort (placeholder pour dialogue UI)
* [x] Permettre à l'interaction avec La Mort de se terminer
* [x] Restaurer le joueur à sa position de mort
* [x] Restaurer le joueur dans un état jouable
* [x] Vérifier qu'une seconde mort fonctionne correctement
* [x] Vérifier qu'une mort sur un piège ne provoque pas plusieurs dégâts/morts consécutifs
* [x] Modifier la teinte de l'écran lorsque le joueur atteint 1 PV

**Jalon :**

> Le joueur peut mourir, rencontrer La Mort, revenir à la vie et continuer à jouer.

---

## Phase 2 — Combats de `Cave`

**Objectif :** le système de combat existe réellement dans le niveau d'introduction.

### Combat du joueur

* [x] Définir le fonctionnement d'une attaque du joueur
* [~] Permettre à une attaque d'infliger des dégâts (selon certaines frames de l'attaque)
* [x] Gérer la mort d'un ennemi
* [x] Vérifier les interactions joueur/ennemi
* [x] Tester plusieurs ennemis simultanément

### Ennemi de base

* [x] Créer un ennemi générique simple
* [x] Lui permettre de se déplacer dans sa zone
* [x] Détecter le joueur comme intrus
* [x] Attaquer le joueur
* [x] Recevoir des dégâts
* [x] Mourir
* [ ] Réapparaître après avoir quitté/rechargé la zone si c'est le comportement retenu

### `Cave`

* [x] Placer les premiers ennemis
* [x] Définir leurs emplacements
* [x] Ajouter les ennemis servant de barrières de progression
* [x] Tester les différents chemins possibles

**Jalon :**

> `Cave` possède un véritable danger et le joueur peut combattre ou éviter les ennemis.

---

## Phase 3 — Interaction et progression de `Cave`

**Objectif :** le niveau commence réellement à présenter le gameplay voulu.

### Interaction

* [x] Définir le fonctionnement général de l'interaction
* [x] Permettre au joueur de récupérer un objet
* [x] Permettre au joueur d'interagir avec un PNJ
* [x] Vérifier que le système peut accueillir d'autres interactions

### Épée

* [x] Transformer la récupération de l'épée en interaction fonctionnelle
* [x] Ajouter l'épée à la progression du joueur
* [x] Permettre son utilisation
* [x] Utiliser l'épée pour ouvrir le premier passage

### Première progression

* [x] Définir le parcours principal de `Cave`
* [x] Identifier les zones optionnelles
* [x] Identifier les zones nécessitant une capacité future
* [ ] Vérifier que le joueur comprend suffisamment où progresser

**Jalon :**

> Un joueur qui ne connaît pas le projet peut commencer `Cave`, récupérer son épée et progresser naturellement.

---

## Phase 4 — Collectibles et contenu secondaire de `Cave`

**Objectif :** commencer à faire de `Cave` un vrai niveau, pas seulement un prototype technique.

### Collectibles

* [x] Définir le fonctionnement générique d'un collectible
* [ ] Faire persister un collectible récupéré
* [ ] Ajouter les premiers collectibles de `Cave`
* [ ] Empêcher leur récupération multiple
* [ ] Ajouter leur affichage dans l'inventaire si nécessaire

### Monstres / butins

* [ ] Définir le fonctionnement d'un butin
* [ ] Ajouter les premiers butins cachés
* [ ] Vérifier leur persistance

### Carte

* [ ] Définir quelles zones sont révélées
* [ ] Révéler progressivement la carte de `Cave`
* [ ] Afficher la position du joueur

> Les marqueurs restent **hors de la roadmap principale pour l'instant**.

---

## Phase 5 — Énigmes de `Cave`

**Objectif :** intégrer la composante puzzle du jeu.

Pour l'instant, on ne définit volontairement **aucun type d'énigme précis**.

* [ ] Définir les contraintes d'une énigme de `Cave`
* [ ] Concevoir la première énigme
* [ ] Implémenter la mécanique nécessaire
* [ ] Relier sa résolution à la progression du niveau
* [ ] Ajouter les éventuelles énigmes secondaires
* [ ] Tester qu'elles peuvent être résolues sans état impossible

**Jalon :**

> `Cave` contient au moins une véritable situation d'exploration/réflexion correspondant à l'identité du jeu.

---

## Phase 6 — Progression par capacités

**Objectif :** préparer la raison pour laquelle le joueur reviendra dans `Cave`.

Pour `Cave`, on n'implémente pas encore toutes les capacités.

On prépare simplement leur utilisation.

* [ ] Identifier les zones de `Cave` bloquées par une capacité
* [ ] Définir les capacités nécessaires à ces zones
* [ ] Ajouter les premiers verrous de progression
* [ ] Vérifier qu'ils sont clairement identifiables
* [ ] Vérifier qu'une nouvelle capacité permet effectivement de revenir explorer `Cave`

Les systèmes de **double-saut, wall-jump et dash** seront développés lorsqu'ils deviendront nécessaires dans la progression globale.

---

## Phase 7 — Contenu narratif de `Cave`

**Objectif :** faire de `Cave` un niveau du jeu et non plus un bac à sable technique.

* [ ] Intégrer le PNJ d'introduction
* [ ] Implémenter son interaction
* [ ] Définir les dialogues nécessaires à `Cave`
* [ ] Ajouter les éventuelles interactions secondaires
* [ ] Intégrer les événements narratifs du niveau
* [ ] Vérifier leur persistance
* [ ] Vérifier les conséquences sur les dialogues

On ne construit **pas encore le système narratif universel définitif** ici.

On implémente ce dont `Cave` a besoin, puis on généralise ce qui mérite réellement de l'être.

C'est exactement dans l'esprit de tes règles d'architecture.

---

## Phase 8 — Finalisation de `Cave`

À ce stade, `Cave` devrait posséder :

* [ ] déplacement
* [ ] saut
* [ ] combat
* [ ] ennemis
* [ ] dégâts
* [ ] mort
* [ ] La Mort
* [ ] réapparition
* [ ] interactions
* [ ] progression
* [ ] énigmes
* [ ] collectibles
* [ ] carte
* [ ] PNJ
* [ ] contenu narratif
* [ ] zones bloquées par les futures capacités

Il restera alors :

### Assets

* [ ] Remplacer les placeholders nécessaires
* [ ] Intégrer les textures finales disponibles
* [ ] Intégrer les éléments graphiques manquants

### Audio

* [ ] Ajouter les musiques nécessaires
* [ ] Ajouter les effets sonores nécessaires

### Tests

* [ ] Tester le parcours principal complet
* [ ] Tester tous les chemins secondaires
* [ ] Tester les morts à différents endroits
* [ ] Tester les réapparitions
* [ ] Tester les collectibles
* [ ] Tester les portes/murs persistants
* [ ] Tester les ennemis
* [ ] Tester les énigmes
* [ ] Tester les zones bloquées
* [ ] Tester les interactions
* [ ] Corriger les bugs trouvés
* [ ] Faire une dernière partie complète de `Cave`
