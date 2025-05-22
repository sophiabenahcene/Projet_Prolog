**Projet Prolog – Jeu Flaunt et Q‑Learning**

## Description

Ce dépôt contient une implémentation en Prolog d’un agent capable de jouer au jeu « Flaunt », un jeu de stratégie imaginé par Douglas Hofstadter. Contrairement à une stratégie fixe, notre programme intègre un algorithme de Q‑learning, ce qui lui permet :

* d’apprendre et de s’adapter dynamiquement au comportement de son adversaire ;
* d’améliorer ses performances au fil des parties grâce à la mise à jour de sa Q‑table ;
* de conserver une phase d’exploration contrôlée (ε‑greedy) pour découvrir de nouvelles stratégies.

Ce projet a été réalisé dans le cadre d’un cours de L2 MIASHS (Université Grenoble Alpes) par :

* **Sophia Benahcene**
* **Maëlle Guilbert**

> *« Ce projet a été un véritable déclic : comprendre et implémenter l’apprentissage par renforcement m’a confirmé ma vocation pour l’intelligence artificielle. »*

## Structure du dépôt

```
├── code/                     # Contient les fichiers Prolog
│   ├── agent_flaunt.pl      # Prédicat principal joue/3 et prédicats Nash et Q‑learning
│   ├── nash_strategy.pl     # Implémentation de l’équilibre de Nash (stratégie mixte)
│   ├── q_learning.pl        # Implémentation des prédicats dynamiques et apprentissage
│   └── utils.pl             # Prédicats utilitaires (calcul de score, historique, etc.)
├── tests/                    # Scénarios et script de tournoi
│   ├── tournament_manager.pl
│   └── sample_matches.pl
└── README.md                 # Ce fichier
```

## Installation

1. Installer [SWI‑Prolog](https://www.swi-prolog.org/) (version recommandée : >= 8.4).
2. Cloner ce dépôt :

   ```bash
   git clone https://github.com/votre‑repo/flaunt‑prolog.git
   cd flaunt-prolog
   ```

## Utilisation

Lancement du tournoi :

```bash
swipl -s code/agent_flaunt.pl tests/tournament_manager.pl
```

Les matchs s’enchaînent automatiquement entre plusieurs stratégies (aléatoire, tit-for-tat, Nash, Q‑learning, etc.). Les scores sont affichés à l’écran.

### Exécuter une partie isolée

```prolog
?- consult(code/agent_flaunt.pl).
?- joue(notre_nom, [], Coup).
```

Le prédicat `joue/3` prend  :

* le nom de l’équipe (atom),
* la liste des coups précédents sous la forme `[[MonCoup, CoupAdversaire] | Reste]`,
* une variable libre qui sera instanciée à un entier 1..5.

## Fonctionnalités

1. **Stratégie Nash** : implémentée en stratégie mixte, calculée a priori puis jouée via un tirage pondéré.
2. **Q‑Learning** : apprentissage en temps réel avec :

   * table Q dynamique (`q_value/3`),
   * gestion de l’historique et extraction d’états (3 derniers coups adverses),
   * mise à jour des Q‑values (`ajuster_q/4`),
   * stratégie ε‑greedy (exploration/exploitation).
3. **Prédicats défensifs** : reconnaissance de patterns adverses (tit-for-tat, répétitions) pour contrer les stratégies de base.

## Paramètres et hyperparamètres

| Paramètre              | Valeur par défaut | Rôle                                          |
| ---------------------- | ----------------- | --------------------------------------------- |
| `alpha(0.1)`           | 0.1               | Taux d’apprentissage                          |
| `gamma(0.9)`           | 0.9               | Facteur de réduction des récompenses futures  |
| `epsilon(1.0)`         | 1.0               | Probabilité initiale d’exploration            |
| `epsilon_min(0.05)`    | 0.05              | Seuil minimal pour epsilon                    |
| `epsilon_reduc(0.995)` | 0.995             | Facteur de réduction de epsilon à chaque tour |

Ces valeurs peuvent être ajustées en modifiant `q_learning.pl`.

## Contributions

Suggestions, rapports de bugs ou améliorations sont les bienvenus ! Veuillez ouvrir une issue ou proposer un pull request.

