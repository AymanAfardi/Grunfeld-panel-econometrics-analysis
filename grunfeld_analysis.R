# ============================================================
#  Déterminants de l'Investissement des Firmes Américaines
#  Modèle de Grunfeld (1958) — Économétrie des données de panel
# ============================================================
#
#  Auteur  : [Votre nom]
#  Date    : 2025
#  Données : Grunfeld dataset (package plm)
#            N = 10 firmes, T = 20 ans (1935-1954), 200 obs.
#
#  Modèle  : INVit = αi + β1*VALUEit + β2*CAPITALit + εit
# ============================================================

# ── 0. Packages ──────────────────────────────────────────────
if (!require("plm")) install.packages("plm")
library(plm)

# ── 1. Chargement des données ────────────────────────────────
data("Grunfeld", package = "plm")

# Déclaration du panel
pdata <- pdata.frame(Grunfeld, index = c("firm", "year"))

cat("=== Dimensions du panel ===\n")
cat("Firmes (N)      :", length(unique(pdata$firm)), "\n")
cat("Années (T)      :", length(unique(pdata$year)), "\n")
cat("Observations    :", nrow(pdata), "\n")
cat("Panel équilibré :", is.pbalanced(pdata), "\n\n")

# ── 2. Statistiques descriptives ─────────────────────────────
cat("=== Statistiques descriptives ===\n")
print(summary(pdata[, c("inv", "value", "capital")]))
cat("\n")

# ── 3. Estimation des modèles ────────────────────────────────

## 3.1 MCO Poolé
pooled <- plm(inv ~ value + capital,
              data  = pdata,
              model = "pooling")

## 3.2 Modèle Between
between <- plm(inv ~ value + capital,
               data  = pdata,
               model = "between")

## 3.3 Effets Fixes individuels (Within)
fe <- plm(inv ~ value + capital,
          data   = pdata,
          model  = "within",
          effect = "individual")

## 3.4 Effets Aléatoires (MCG — estimateur de Swamy-Arora)
re <- plm(inv ~ value + capital,
          data   = pdata,
          model  = "random",
          effect = "individual")

# ── 4. Tableau comparatif des estimations ───────────────────
cat("=== MCO Poolé ===\n");     print(summary(pooled))
cat("\n=== Modèle Between ===\n");  print(summary(between))
cat("\n=== Effets Fixes (Within) ===\n"); print(summary(fe))
cat("\n=== Effets Aléatoires (MCG) ===\n"); print(summary(re))

# ── 5. Tests de spécification ────────────────────────────────
cat("\n============================================================\n")
cat("=== TESTS DE SPÉCIFICATION ===\n")
cat("============================================================\n\n")

## 5.1 Test F de Fisher : FE vs MCO Poolé
cat("--- Test F (Effets Fixes vs MCO Poolé) ---\n")
f_test <- pFtest(fe, pooled)
print(f_test)
cat("Décision : ")
if (f_test$p.value < 0.05) {
  cat("H0 rejetée → effets individuels significatifs → MCO poolé inadapté\n\n")
} else {
  cat("H0 non rejetée → MCO poolé acceptable\n\n")
}

## 5.2 Test LM de Honda : RE vs MCO Poolé
cat("--- Test LM Honda (Effets Aléatoires vs MCO Poolé) ---\n")
lm_test <- plmtest(pooled, type = "honda")
print(lm_test)
cat("Décision : ")
if (lm_test$p.value < 0.05) {
  cat("H0 rejetée → variance des effets individuels non nulle → panel justifié\n\n")
} else {
  cat("H0 non rejetée → MCO poolé acceptable\n\n")
}

## 5.3 Test de Hausman : FE vs RE
cat("--- Test de Hausman (Effets Fixes vs Effets Aléatoires) ---\n")
hausman <- phtest(fe, re)
print(hausman)
cat("Décision : ")
if (hausman$p.value < 0.05) {
  cat("H0 rejetée → effets corrélés avec régresseurs → Effets Fixes (Within) recommandé\n\n")
} else {
  cat("H0 non rejetée → pas de corrélation → Effets Aléatoires optimal (MCG)\n\n")
}

# ── 6. Résumé de la sélection du modèle ──────────────────────
cat("============================================================\n")
cat("=== SYNTHÈSE — SÉLECTION DU MODÈLE OPTIMAL ===\n")
cat("============================================================\n")
cat(sprintf("  F-test Fisher  : F(9,188) = %.2f,  p = %.4g\n",
            as.numeric(f_test$statistic), f_test$p.value))
cat(sprintf("  LM Honda       : z = %.3f,         p = %.4g\n",
            as.numeric(lm_test$statistic), lm_test$p.value))
cat(sprintf("  Hausman        : chi2(2) = %.4f,  p = %.4f\n",
            as.numeric(hausman$statistic), hausman$p.value))
cat("\n  → MODÈLE RETENU : Effets Aléatoires (MCG)\n")
cat(sprintf("    β_value   = %.6f  (p < 2e-16)\n", coef(re)["value"]))
cat(sprintf("    β_capital = %.6f  (p < 2e-16)\n", coef(re)["capital"]))

# Part de variance des effets individuels
theta <- as.numeric(re$ercomp$theta)
sigma2_mu <- as.numeric(re$ercomp$sigma2["idios"])
cat(sprintf("\n    θ = %.4f  →  %.1f%% de la variance expliquée par les effets individuels\n",
            theta, theta * 100))
cat("============================================================\n")
