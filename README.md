# Projet Japonais

Application de bureau en Java pour accompagner l'apprentissage du japonais : exercices de kana, thème et version sur des listes de mots, bibliothèque de vocabulaire et suivi de la maîtrise de chaque mot.

> **État :** Sprint 1 en cours (exercice de kana).

## Sommaire

1. [Fonctionnalités](#fonctionnalités)
2. [Technologies](#technologies)
3. [Architecture](#architecture)
4. [Installation et lancement](#installation-et-lancement)
5. [Règles métier](#règles-métier)
6. [Conventions de code](#conventions-de-code)
7. [Règles Git](#règles-git)
8. [Definition of Done](#definition-of-done)
9. [Équipe](#équipe)

## Fonctionnalités

| # | User story | Priorité | État |
|---|---|---|---|
| US1 | Un kana s'affiche, je réponds en romaji | 1 | 🔨 Sprint 1 |
| US2 | Choisir hiragana/katakana, avec ou sans accents, avec ou sans combinaisons | 1 | 🔨 Sprint 1 |
| US3 | Répondre en écrit ou en QCM (3 ou 5 choix) | 1 | ⏸️ Bonus Sprint 1 |
| US4 | Ajouter, modifier, supprimer un mot | 2 | 📋 À faire |
| US5 | Créer des listes et y ranger des mots | 2 | 📋 À faire |
| US6 | Exercice de thème (français → japonais) | 3 | 📋 À faire |
| US7 | Exercice de version (japonais → français) | 4 | 📋 À faire |
| US8 | Bibliothèque consultable en romaji, kana ou français | 5 | 📋 À faire |
| US9 | Niveau de maîtrise de chaque mot et de chaque kana | 6 | 📋 À faire |
| US10 | Liste « Erreurs » automatique | 6 | 📋 À faire |

Le détail de chaque story (critères d'acceptation) est dans les issues GitHub.

## Technologies

| Élément | Choix | Raison |
|---|---|---|
| Langage | Java | Langage maîtrisé par l'équipe ; l'approche objet colle au domaine |
| Base de données | SQLite (via JDBC) | Base embarquée dans un simple fichier : pas de serveur, gratuite, adaptée à une appli perso |
| Interface graphique | JavaFX | Plus récent et meilleur rendu |
| Plateforme | Ordinateur | Une version téléphone est possible plus tard |

## Architecture

Architecture **MVC**, avec une couche **DAO** pour isoler l'accès à la base.

```
src/
├── model/        classes métier (Kana, ExerciceKana, ParametresExercice…)
├── dao/          accès à SQLite (KanaDAO…)
├── view/         écrans
└── controller/   lien entre les écrans et le métier
lib/              pilote JDBC SQLite
sql/              script de création et d'insertion des données
test/             tests unitaires
res/              Ressources non codé (Diagrammes, Schema...)
```

Règles de dépendance :

- **`model`** ne contient **ni SQL ni affichage**. Les classes métier sont testables seules et réutilisables sur une autre plateforme.
- **`dao`** contient **tout** le SQL. Changer de base ne doit toucher que ce package.
- **`view`** n'appelle jamais la base directement : elle passe par `controller`.

Le travail est découpé en **tranches verticales** : chaque tâche livre une fonctionnalité qui traverse les couches nécessaires, et non une couche entière.

## Installation et lancement

### Prérequis

- le JAR sqlite-jdbc-3.46.1.3.jar dans lib/ 
- sqlite3 pour créer la base à partir du script.
- Le pilote JDBC SQLite dans `lib/`

### Base de données

La base n'est **pas versionnée**. On versionne le script SQL, et chacun crée sa base en local à partir de `sql/` :

```bash
sqlite3 japonais.db < sql/creation.sql
```

### Compilation

*À compléter après le choix de la bibliothèque graphique (T5).*

## Règles métier

### Kana

- Tables de départ : hiragana et katakana, avec accents (dakuten, handakuten) et combinaisons.
- **Un kana peut avoir plusieurs romaji.** Toutes les romanisations courantes sont acceptées : *shi/si*, *tsu/tu*, *chi/ti*, *fu/hu*, *ji/zi*, *ji/di* (ぢ), *zu/du* (づ), *o/wo* (を), et leurs équivalents dans les combinaisons (*sha/sya*, *cha/tya*, *ja/jya/zya*…).
- La casse et les espaces autour de la réponse sont ignorés.
- Les exercices de kana ne se font que dans un sens : un kana s'affiche, on répond en romaji.

### Mots

- Un mot peut avoir **plusieurs traductions**.
- Le kanji est facultatif ; s'il est absent, on affiche les kana.
- Un kanji seul et un mot composé sont deux mots différents.
- Quand une question a plusieurs champs, la réponse n'est juste que si **tous** les champs sont justes.
- Les réponses en japonais se saisissent avec le clavier japonais du système.

### Niveaux de maîtrise

Calculés sur les **10 dernières réponses**, avec un minimum de 5 essais :

| Niveau | Règle |
|---|---|
| ⚪ Nouveau | moins de 5 essais |
| 🔴 À revoir | moins de 50 % de bonnes réponses |
| 🟡 En cours | de 50 à 79 % |
| 🟢 Maîtrisé | 80 % ou plus |

Ne compter que les dernières réponses permet à un mot maîtrisé de redescendre si on l'oublie.

## Conventions de code

- **Langue :** noms de classes, méthodes, variables et commentaires en français, sans accents dans le code (`ParametresExercice`, `verifierReponse`).
- **Nommage :**
  - classes en `PascalCase` : `ExerciceKana`
  - méthodes et variables en `camelCase` : `getRomajis()`
  - constantes en `MAJUSCULES` : `NB_ESSAIS_MIN`
  - classes d'accès aux données suffixées par `DAO` : `KanaDAO`
- **Objet :** attributs `private`, accès par des méthodes. Une classe a une seule responsabilité.
- **Javadoc :** obligatoire sur les classes et les méthodes **publiques** (description, `@param`, `@return`, `@throws`). Pas besoin sur chaque variable privée.
- **Lambdas :** autorisées, notamment pour les écouteurs de l'interface graphique.
- **Pas de valeurs magiques :** les nombres qui ont un sens métier (10 réponses, 5 essais, 80 %) sont des constantes nommées.

## Règles Git

On suit **GitHub Flow**.

1. **`main` est protégée** : pas de push direct, et elle compile toujours.
2. **Une tâche = une issue = une branche**, nommée d'après son type et son numéro de tâche :
   - `feature/T4-kana-dao`
   - `fix/T7-score-negatif`
   - `docs/T1-readme`
3. **Commits petits**, avec un préfixe et un verbe à l'impératif :
   - `feat: ajoute la classe KanaDAO`
   - `fix: corrige le calcul du score`
   - `docs: complète le README`
   - `test: ajoute les tests de ExerciceKana`
   - `refactor: simplifie le tirage des kana`
4. **Avant d'ouvrir une pull request**, récupérer `main` et régler les conflits chez soi.
5. **La pull request** indique ce qui a été fait, comment le tester, et `Closes #<numéro>`. Elle est relue par un autre dev.
6. **Après la fusion**, supprimer la branche.
7. **`.gitignore`** : fichiers compilés, fichiers d'IDE et fichier `.db`.

Si une information nécessaire n'est écrite nulle part (signature d'une méthode, format d'une donnée), on **ne l'invente pas** : on la demande dans une issue.

## Definition of Done

**Une tâche est terminée quand :**

- [ ] le code compile et l'appli se lance ;
- [ ] les classes métier touchées ont des tests unitaires qui passent ;
- [ ] les classes et méthodes publiques ont leur Javadoc ;
- [ ] le code respecte les conventions de ce README ;
- [ ] une pull request a été relue par un autre dev ;
- [ ] la branche est fusionnée dans `main`, qui compile toujours ;
- [ ] le ticket est en « Terminé », avec le temps passé noté.

**Une user story est terminée quand** toutes ses tâches le sont, que ses critères d'acceptation sont vérifiés et que le PO l'a validée.

## Équipe

| Membre | Rôle |
|---|---|
| Frieren | Développeur |
| Nobara | Développeur |
| Mob | Développeur |

Méthode : **Scrum**, avec des sprints de 3 semaines.
