# Data Sience Projects (Masters of Business Administration at FIAP)

## 1) Machine Learning Projects:

### 1.1) Feature Engineering:
#### 1.1.1- Feature Scaling:
Kaggle Housing dataset. This project focuses on a pipeline that utilizes Gradient Descent (SGD Regression) and Linear Regression, with or without feature scaling, to compare the results.

#### 1.1.2- Dimensionality Reduction:
Kaggle Breast Cancer dataset. This project focuses on comparing prediction results with or without dimensionality reduction, utilizing Principal Component Analysis (PCA) in conjunction with the Random Forest model.

#### 1.1.3- Feature Extraction, Store e Selection: 
  
  First, the cellphone dataset from Kaggle was used to explain three important aspects for better selection, which are:
    
  a) Univariate Selection - a type of selection using a statistical metric (such as Chi-square, R2 score, recall, f1);
    
  b) Through Importance - meaning, I examine the attributes with the highest importance scores; and
    
  c) Correlation Matrix, Heatmap, or Covariance Matrix: a graph where we observe density and select those attributes with the highest correlation.

  Second, the Kaggle SpamCollection dataset was used to illustrate feature extraction in the context of text data. Techniques such as TfIdf Vectorizer and Linear SVC models were employed.

#### 1.1.4- Backward and Forward Feature Selection:
Boston Housing Dataset. Utilizing the Sequential Feature Selector to select backward and forward features and compare the results.

### 1.2) Machine Learning itself:
#### 1.2.1- Supervised Learning Techniques:
Initially, utilizing KNN (K-Nearest Neighbors) and SVM (Support Vector Machine) techniques with the R programming language on the Kaggle Adult dataset. This involves comparing the results using these techniques, both with and without cross-validation.
    
Subsequently, applying Penalized Regression in R on the Kaggle Train dataset. This phase involves comparing results after using models such as Lasso Regression (L1 regularization) and Ridge Regression (L2 regularization).

Finally, the Naive Bayes approach, specifically the Categorical Naive Bayes model, is implemented in Python on the Kaggle Adult dataset. This involves an extensive exploratory analysis, followed by the application of this supervised classification technique. 

#### 1.2.2- Unsupervised Learning Techniques:
Initially, engaging in Cluster Analysis and Data Summarization using the R programming language on the Kaggle Olympics Running Events dataset.

Subsequently, applying Association Rule Learning in R on the Kaggle Groceries dataset, utilizing the Apriori algorithm.


## 2) Deep Learning Projects:

### 2.1) Convolutional Neural Networks:
Utilizing the CNN model for image recognition and classification.

### 2.2) Self Organizing Map (SOM):
This is a type of traditional neural network, distinct from deep learning, and categorized under unsupervised learning. It is employed here for processing and reconstructing images.

### 2.3) Generative Adversarial Network (GAN):
GAN is trained using the MNIST dataset to create new images of handwritten digits, representing numbers from one to nine.

### 2.4) Transfer Learning:
Employing the Transfer Learning approach for the recognition and classification of images, specifically those of dogs and cats.


## 3) Natural Language Processing (NLP):

### 3.1) Text Processing:

Initially, the Gensim library's Word2Vec technique is employed to produce word embeddings. These are dense vector representations of words, where similar words have corresponding similar representations, effectively capturing the semantic meaning of words.

Subsequently, the Bag of Words (BoW) method is utilized, particularly in document classification. This approach focuses solely on the occurrence of words within a document.

Following this, text mining tools such as NLTK and Spacy are applied for tasks like tokenization and lemmatization, which are crucial in text processing.

Next, the TfIdf-Vectorizer is used as a tool to evaluate the significance of words in a document, within a collection of documents. Here, it's specifically applied to classify emails as spam or non-spam.

Finally, a Word Cloud representation is created for text data, where the size of each word indicates its frequency or importance. Additionally, the Net Promoter Score (NPS) is utilized to gauge customer loyalty and satisfaction. By highlighting the most frequently mentioned words in customer responses, we gain valuable insights into overall customer sentiment.

### 3.2) Image Processing:

Processed using Computer Vision: image recognition and image generation.

### 3.3) Audio Processing:

Processing audio signals using the Librosa library in Python.

### 3.4) Geospatial Processing:

Handled with Geographic Information Systems (GIS) and other geospatial data processing techniques. These are used for mapping, spatial analysis, and understanding geographic relationships in data.

## 4) DATA SCIENCE MBA FINAL PROJECT:

### Transforming Customer Insights into Action: Our Journey with Petz S.A.

In a world where understanding customer sentiment is key to business success, our team embarked on an ambitious project with Petz S.A., Brazil’s growing pet market leader. Our goal? To harness the power of data and machine learning to provide deep insights into customer experiences and preferences.

#### - The Challenge:
The pet industry in Brazil has shown remarkable growth, with Petz S.A. at the forefront. In this rapidly evolving landscape, understanding customer sentiment and journey became vital. We aimed to develop a model that could prioritize customer perspectives, derived from public domains like social media and review sites, and correlate them with sales volume and customer loyalty.

#### - Our Approach:
We dove into the world of sentiment analysis, employing techniques to extract subjective information from web-based natural language texts. Our focus was on Twitter, where personal opinions about Petz S.A. flourish. By mining these tweets, we aimed to gain insights that could shape Petz’s marketing strategies and product offerings.

#### - Technologies and Tools:

Our journey involved a suite of advanced technologies:

#### Python Libraries:
For data selection, preprocessing, transformation, analysis and evaluation.

#### Twitter API:
To collect relevant tweets about Petz S.A.

#### Machine Learning Models:
Results comparison based on Naive Bayes, Random Forest, Support Vector Classifier, Logistic Regression, Decision Tree, K-Nearest Neighboors (KNN), XGBoost and AdaBoost, for sentiment classification.

#### Deep Learning Techniques:
From SimpleRNN, passing through LSTM and reaching BERT, for more nuanced sentiment and subject matter analysis.

#### DataOps and MLOps Architectures:
To manage integrated code, data, and models for streamlined development, testing, and implementation.

#### Data Visualization:
Using Power BI for powerful analytics and insights.

#### - Outcomes and Benefits:
Despite challenges like subjectivity and informal language, our model is set to revolutionize how Petz S.A. understands its customers. From customizing marketing strategies to identifying gaps in products and services, our solution offers Petz a competitive edge through actionable market insights.

#### - Conclusion:
Our project with Petz S.A. is more than just data analysis — it’s about bringing customer voices directly to the decision-making table. By leveraging cutting-edge machine and deep learning techniques, we’ve opened new avenues for Petz to connect with their clientele on a deeper level.

### Medium Link: https://medium.com/@jllcen2011/data-science-mba-final-project-81b3b07ef34f
