# Déterminants de l'Investissement des Firmes Américaines (1935–1954)

> Réplication et analyse du modèle de Grunfeld (1958) par économétrie des données de panel — MCO poolé, effets fixes, effets aléatoires, et tests de spécification.

---

## Aperçu du projet

Ce projet reproduit et étend l'analyse empirique de **Grunfeld (1958)** sur les déterminants de l'investissement brut de 10 firmes industrielles américaines sur la période 1935–1954.

**Question de recherche :** Dans quelle mesure la valeur de marché (`value`) et le stock de capital existant (`capital`) expliquent-ils l'investissement brut (`inv`) des firmes, en tenant compte de l'hétérogénéité individuelle ?

**Approche :** Comparaison de quatre estimateurs de panel (MCO poolé, Between, Effets Fixes Within, Effets Aléatoires MCG) et sélection du modèle optimal via une batterie de tests de spécification.

---

## Modèle

$$\text{INV}_{it} = \alpha_i + \beta_1 \text{VALUE}_{it} + \beta_2 \text{CAPITAL}_{it} + \varepsilon_{it}$$

| Symbole | Description |
|---------|-------------|
| $\text{INV}_{it}$ | Investissement brut de la firme $i$ à l'année $t$ (en millions $) |
| $\text{VALUE}_{it}$ | Valeur de marché de la firme (en millions $) |
| $\text{CAPITAL}_{it}$ | Stock de capital net en début de période (en millions $) |
| $\alpha_i$ | Effet individuel (fixe ou aléatoire selon la spécification) |

---

## Données

| Caractéristique | Valeur |
|----------------|--------|
| Source | `Grunfeld` dataset — package R `plm` |
| Firmes ($N$) | 10 |
| Années ($T$) | 20 (1935–1954) |
| Observations | 200 |
| Type de panel | Équilibré |

---

## Résultats

### Estimations

| Modèle | $\hat{\beta}_{\text{value}}$ | $\hat{\beta}_{\text{capital}}$ | $R^2$ |
|--------|------------------------------|--------------------------------|-------|
| MCO Poolé | 0.1156*** | 0.2307*** | 0.812 |
| Between | 0.1346** | 0.0320 | 0.858 |
| Effets Fixes (Within) | 0.1101*** | 0.3101*** | 0.767 |
| **Effets Aléatoires (MCG)** | **0.1098\*\*\*** | **0.3081\*\*\*** | **0.770** |

*Seuils de significativité : \*\*\* p<0.001 ; \*\* p<0.01 ; \* p<0.05*

### Tests de spécification

| Test | Statistique | p-value | Décision |
|------|-------------|---------|----------|
| F-test Fisher (FE vs Pooled) | F(9, 188) = 49.18 | < 2.2e-16 | MCO poolé rejeté |
| LM Honda (RE vs Pooled) | z = 28.25 | < 2.2e-16 | Effets aléatoires présents |
| Hausman (FE vs RE) | χ²(2) = 2.33 | 0.312 | **RE optimal** |

➡️ **Conclusion :** Le modèle à effets aléatoires estimé par MCG est la spécification retenue. La part de variance attribuée aux effets individuels est de **71.8 %** (θ = 0.86).

---

## Structure du dépôt

```
grunfeld-panel/
├── README.md               # Ce fichier
├── .gitignore              # Fichiers à exclure
├── LICENSE                 # Licence MIT
│
├── data/
│   └── README.md           # Description des données (chargées via plm)
│
├── scripts/
│   └── grunfeld_analysis.R # Script R complet (estimation + tests)
│
├── output/
│   └── README.md           # Description des sorties générées
│
└── report/
    └── Grunflield.docx     # Rapport académique complet
```

---

## Reproduire l'analyse

### Prérequis

- **R** ≥ 4.0.0
- Package `plm` (Panel Linear Models)

```r
install.packages("plm")
```

### Exécution

```r
source("scripts/grunfeld_analysis.R")
```

Le script charge automatiquement les données depuis le package `plm`, estime les quatre modèles, et produit les trois tests de spécification.

---

## Interprétation des coefficients (modèle RE)

- Une hausse de **1 M$** de la valeur de marché → investissement supplémentaire de **+0.110 M$** (*ceteris paribus*)
- Une hausse de **1 M$** du stock de capital → investissement supplémentaire de **+0.308 M$** (*ceteris paribus*)
- Les deux effets sont stables entre le modèle Within et le modèle RE, attestant la **robustesse** des estimations

---

## Référence

> Grunfeld, Y. (1958). *The Determinants of Corporate Investment*. Unpublished PhD dissertation, University of Chicago.

---

## Auteur

Projet réalisé dans le cadre d'un cours d'**économétrie des données de panel** (Master 1 Économétrie et Data Science).

---

## Licence

Ce projet est distribué sous licence [MIT](LICENSE).
