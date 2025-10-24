# Banking Customer Segmentation using Unsupervised Learning

## Project Overview

This project applies unsupervised learning techniques to the **Bank Marketing dataset** from the UCI Machine Learning Repository. The goal is to identify distinct customer segments based on socio-demographic and financial features. This approach helps in uncovering hidden patterns that can inform targeted marketing strategies. The methods applied include **Principal Component Analysis (PCA)** for dimensionality reduction and **K-Means**, **Hierarchical Clustering**, and **Gaussian Mixture Models (GMM)** for clustering.

## Key Techniques and Algorithms

### 1. **Principal Component Analysis (PCA)**
   PCA is used to reduce the dimensionality of the dataset while retaining the most important variance. This is necessary due to the large number of features, especially after one-hot encoding categorical variables. We retained the first 30 principal components, which together explain around 90% of the data’s variance, making the dataset more manageable for clustering.

### 2. **K-Means Clustering**
   K-Means clustering is a popular unsupervised machine learning algorithm that partitions the data into `k` clusters by minimizing the variance within each cluster. In this project, the optimal number of clusters (`k=3`) was determined using the elbow method, which identifies the point at which increasing the number of clusters no longer results in significant improvements.

### 3. **Hierarchical Clustering**
   Hierarchical clustering builds a tree-like structure (dendrogram) that shows how the data points are merged step-by-step into clusters. This method doesn’t require us to predefine the number of clusters, which makes it useful for exploratory analysis. A visual inspection of the dendrogram helped confirm the 3 clusters identified by K-Means.

### 4. **Gaussian Mixture Models (GMM)**
   GMM is a probabilistic model that assumes the data points are generated from a mixture of several Gaussian distributions. It allows for soft clustering, meaning each data point can belong to multiple clusters with different probabilities. GMM was used to confirm the presence of 3 clusters and to provide a more nuanced view of the customer segmentation.

## Steps to Reproduce

1. **Data Preprocessing**:
   - Loaded the dataset and removed the target variable (`y`) as we’re working with unsupervised learning.
   - Encoded categorical variables (e.g., job, education) using one-hot encoding.
   - Standardized numerical features to ensure fair contribution from each variable in clustering.

2. **Dimensionality Reduction**:
   - Applied PCA to reduce the feature space to 30 principal components, which captured approximately 90% of the variance in the dataset.

3. **Clustering**:
   - **K-Means**: Performed K-Means clustering with `k=3` clusters, based on the elbow method.
   - **Hierarchical Clustering**: Used the Ward’s method for hierarchical clustering and visualized the results using a dendrogram.
   - **Gaussian Mixture Models (GMM)**: Fitted GMM to the data to provide probabilistic cluster assignments.

4. **Cluster Profiling**:
   - After clustering, the profiles of the clusters were analyzed based on job types, education levels, marital status, and other features. This helped in understanding the customer segments.

## Results

- **K-Means Clustering**: The algorithm successfully identified three clusters. The analysis revealed that customers in each cluster had distinct socio-demographic and financial characteristics, such as differences in loan usage, education levels, and job types.
  
- **Hierarchical Clustering**: The dendrogram provided a clear view of how the clusters related to one another. It confirmed the K-Means results and showed how customers merged into groups based on their similarity.

- **Gaussian Mixture Models (GMM)**: GMM revealed that the clusters overlapped to some extent, allowing for more flexibility in assigning customers to multiple clusters with varying probabilities.

## Cluster Insights

### Cluster 1: 
- **Demographics**: Primarily blue-collar workers, with a higher percentage of secondary education.
- **Financial Behavior**: High demand for housing loans, moderate personal loan usage.
- **Recommendation**: Target with affordable housing loan products and credit-building tools.

### Cluster 2:
- **Demographics**: A mix of professionals (e.g., management, technicians), with tertiary education being more common.
- **Financial Behavior**: Moderate use of loans, balanced financial behavior.
- **Recommendation**: Offer bundled savings and investment products, along with flexible loan options.

### Cluster 3:
- **Demographics**: Mostly high-level management, with a higher concentration of tertiary education.
- **Financial Behavior**: Lower loan usage, higher financial stability.
- **Recommendation**: Offer premium financial services, wealth management, and retirement planning.

## Conclusion

This project demonstrates how unsupervised learning can help uncover hidden patterns in customer data. By using **PCA** for dimensionality reduction and **K-Means**, **Hierarchical Clustering**, and **GMM** for clustering, we successfully identified three distinct customer segments. These insights are crucial for designing targeted marketing strategies, such as offering specific loan products or investment strategies tailored to each cluster's financial behaviors and socio-demographic characteristics.


## Contact

If you have any questions or would like to get in touch, feel free to reach out:

**Kasra Ghasemipoo**  
University degli Studi di Milano  
Email: [kghasemipoo@gmail.com](mailto:kghasemipoo@gmail.com)  
Student Email: [kasra.ghasemipoo@studenti.unimi.it](mailto:kasra.ghasemipoo@studenti.unimi.it)  
LinkedIn: [www.linkedin.com/in/kasra-ghasemipoo](www.linkedin.com/in/kasra-ghasemipoo)

