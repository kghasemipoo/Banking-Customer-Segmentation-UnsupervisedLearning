# Load libraries
library(tidyverse)
library(cluster)
library(factoextra)
library(FactoMineR)
library(readr)
library(fastDummies)
library(ggplot2)
library(plotly)
library(mclust)

# Load data
bank_data <- read_csv("C:/Users/PaNa/Desktop/unsup_project/bank.csv")
head(bank_data)
str(bank_data)
summary(bank_data)
sum(is.na(bank_data))

# Drop target column
bank_data <- bank_data %>% select(-y)

# Convert strings to factors, then create dummy variables
bank_data <- bank_data %>% mutate_if(is.character, as.factor)
bank_data_dummy <- bank_data %>%
  fastDummies::dummy_cols(remove_first_dummy = TRUE) %>%
  select(-where(is.factor))

# Standardize
bank_data_scaled <- scale(bank_data_dummy)

# PCA
pca_result <- prcomp(bank_data_scaled, center = FALSE, scale. = FALSE)

# Take 30 components
pca_scores <- pca_result$x
pca_scores_30 <- pca_scores[, 1:30]
dim(pca_scores_30)

# Elbow method
set.seed(123)
wss <- vector()
for (k in 1:10) {
  kmeans_result <- kmeans(pca_scores_30, centers = k, nstart = 25)
  wss[k] <- kmeans_result$tot.withinss
}
elbow_df <- data.frame(k = 1:10, wss = wss)
ggplot(elbow_df, aes(x = k, y = wss)) +
  geom_point(size = 3, color = "steelblue") +
  geom_line(color = "steelblue", linewidth = 1) +
  scale_x_continuous(breaks = 1:10) +
  labs(title = "Elbow Method", x = "k", y = "WSS") +
  theme_minimal(base_size = 14)

# Final K-Means
k_best <- 3
set.seed(123)
kmeans_final <- kmeans(pca_scores_30, centers = k_best, nstart = 25)

# Visualize PCA in 3D
pca_3d <- as.data.frame(pca_scores_30[, 1:3])
colnames(pca_3d) <- c("PC1", "PC2", "PC3")
pca_3d$cluster <- as.factor(kmeans_final$cluster)
plot_ly(pca_3d, x = ~PC1, y = ~PC2, z = ~PC3, color = ~cluster, colors = "Set2",
        type = "scatter3d", mode = "markers",
        marker = list(size = 4, opacity = 1, line = list(width = 0.5, color = 'black'))) %>%
  layout(scene = list(xaxis = list(title = "PC1"),
                      yaxis = list(title = "PC2"),
                      zaxis = list(title = "PC3")),
         title = list(text = "3D PCA Cluster Plot"))

# Cluster visualization (2D)
fviz_cluster(kmeans_final, data = pca_scores_30,
             ellipse.type = "euclid", palette = "jco", ggtheme = theme_minimal())

# Add cluster labels
bank_original <- as.data.frame(bank_data_dummy)
bank_original$cluster <- as.factor(kmeans_final$cluster)

# Cluster profiling
bank_original %>%
  group_by(cluster) %>%
  summarise(across(where(is.numeric), list(mean = mean), .names = "mean_{col}"))

bank_original %>%
  group_by(cluster) %>%
  summarise(across(starts_with("job_"), mean)) %>%
  mutate(across(starts_with("job_"), ~round(. * 100, 1)))

bank_original %>%
  group_by(cluster) %>%
  summarise(across(starts_with("education_"), mean)) %>%
  mutate(across(starts_with("education_"), ~round(. * 100, 1)))

bank_original %>%
  group_by(cluster) %>%
  summarise(across(starts_with("marital_"), mean)) %>%
  mutate(across(starts_with("marital_"), ~round(. * 100, 1)))

bank_original %>%
  group_by(cluster) %>%
  summarise(across(starts_with("loan_"), mean)) %>%
  mutate(across(starts_with("loan_"), ~round(. * 100, 1)))

bank_original %>%
  group_by(cluster) %>%
  summarise(across(starts_with("housing_"), mean)) %>%
  mutate(across(starts_with("housing_"), ~round(. * 100, 1)))

# ─── Hierarchical Clustering ───
dist_pca <- dist(pca_scores_30)
hc_result <- hclust(dist_pca, method = "ward.D2")
plot(hc_result, labels = FALSE, hang = -1, main = "Hierarchical Dendrogram")

# Try with 3000-sample
set.seed(123)
sample_indices <- sample(1:nrow(pca_scores_30), 3000)
pca_scores_sampled <- pca_scores_30[sample_indices, ]
dist_pca_sampled <- dist(pca_scores_sampled)
hc_result <- hclust(dist_pca_sampled, method = "ward.D2")
plot(hc_result, labels = FALSE, hang = -1, main = "Dendrogram (3000 Sampled)")

hc_clusters <- cutree(hc_result, k = 3)
pca_sampled_df <- as.data.frame(pca_scores_sampled)
pca_sampled_df$hc_cluster <- as.factor(hc_clusters)

# Visualize
fviz_cluster(list(data = pca_sampled_df[,1:30], cluster = hc_clusters),
             ellipse.type = "euclid", geom = "point",
             palette = "jco", ggtheme = theme_minimal(),
             main = "Hierarchical Clusters")

# Profile clusters
bank_hc_sample <- bank_original[sample_indices, ]
bank_hc_sample$hc_cluster <- as.factor(hc_clusters)

bank_hc_sample %>%
  group_by(hc_cluster) %>%
  summarise(count = n(),
            avg_age = round(mean(age), 1),
            avg_balance = round(mean(balance), 1),
            avg_duration = round(mean(duration), 1),
            loan_yes_pct = round(mean(loan_yes) * 100, 1),
            housing_yes_pct = round(mean(housing_yes) * 100, 1))

bank_hc_sample %>%
  group_by(hc_cluster) %>%
  summarise(across(starts_with("job_"), mean)) %>%
  mutate(across(starts_with("job_"), ~ round(. * 100, 1)))

bank_hc_sample %>%
  group_by(hc_cluster) %>%
  summarise(across(starts_with("education_"), mean)) %>%
  mutate(across(starts_with("education_"), ~ round(. * 100, 1)))

bank_hc_sample %>%
  group_by(hc_cluster) %>%
  summarise(across(starts_with("marital_"), mean)) %>%
  mutate(across(starts_with("marital_"), ~ round(. * 100, 1)))

# ─── Cluster Count Comparison ───
table(bank_original$cluster)          # K-means
table(pca_sampled_df$hc_cluster)      # Hierarchical

# ─── Gaussian Mixture Models (GMM) ───
gmm_result <- Mclust(pca_scores_30)
plot(gmm_result, what = "BIC")
gmm_clusters <- gmm_result$classification
bank_original$gmm_cluster <- as.factor(gmm_clusters)

fviz_cluster(list(data = pca_scores_30, cluster = gmm_clusters),
             ellipse.type = "norm", palette = "jco",
             ggtheme = theme_minimal(),
             main = "GMM Clusters")

# Force GMM to 3 clusters
gmm_result_3 <- Mclust(pca_scores_30, G = 3)
gmm_clusters_3 <- gmm_result_3$classification
bank_original$gmm_cluster_3 <- as.factor(gmm_clusters_3)

fviz_cluster(list(data = pca_scores_30, cluster = gmm_clusters_3),
             ellipse.type = "norm", palette = "jco",
             ggtheme = theme_minimal(),
             main = "GMM (3 clusters)")

# Summary of GMM results
table(bank_original$gmm_cluster)

bank_original %>%
  group_by(gmm_cluster) %>%
  summarise(avg_age = mean(age),
            avg_balance = mean(balance),
            loan_rate = mean(loan_yes),
            housing_rate = mean(housing_yes))

bank_original$gmm_cluster <- as.factor(gmm_result_3$classification)

bank_original %>%
  group_by(gmm_cluster) %>%
  summarise(avg_age = round(mean(age), 1),
            avg_balance = round(mean(balance), 1),
            loan_rate = round(mean(loan_yes) * 100, 1),
            housing_rate = round(mean(housing_yes) * 100, 1))
