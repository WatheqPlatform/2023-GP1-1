#!/usr/bin/env python 

import sys
import json
import nltk
import re
from nltk.corpus import stopwords
from nltk.stem import PorterStemmer
from nltk.tokenize import word_tokenize
from nltk.stem import WordNetLemmatizer

# Download NLTK resources separately
nltk.download('punkt')
nltk.download('stopwords')
nltk.download('wordnet')

# Fix typo in stopwords variable
additional_stopwords = {'skill', 'skills', 'love', 'like', 'ability', 'good', 'excellent', 'knowledge', 'work', 'proficiency', 'great', 'strong'}
stopwords = set(stopwords.words('english')).union(additional_stopwords)

cv_data = json.loads(sys.argv[1])
offer_data = json.loads(sys.argv[2])

def preprocess_text(text): 
    # Tokenization and convert to lower case
    tokens = word_tokenize(text.lower()) 

    # Remove non-alphabetic characters from each word
    tokens = [''.join(filter(str.isalpha, word)) for word in tokens]
    tokens = [token.replace("-", " ") for token in tokens]
    tokens = [re.sub(r'[^a-zA-Z\s]', '', token) for token in tokens if re.sub(r'[^a-zA-Z\s]', '', token)]
    tokens = [re.split(r'\s+', token) for token in tokens]
    tokens = [item for sublist in tokens for item in sublist]
    
    # Remove stopwords
    tokens = [word for word in tokens if word not in stopwords]
    
    # Delete repeated tokens
    tokens = list(dict.fromkeys(tokens))

    # Porter Stemming
    porter = PorterStemmer()
    stemmed_tokens = [porter.stem(word) for word in tokens]

    # Lemmatization
    lemmatizer = WordNetLemmatizer()
    lemmatized_tokens = [lemmatizer.lemmatize(word) for word in stemmed_tokens]

    # Returns string of tokens
    return ' '.join(lemmatized_tokens)

def preprocess(data):
    for record in data:
        if 'JobTitle' in record and record['JobTitle']:
            record['JobTitle'] = preprocess_text(record['JobTitle'])
        elif 'Field' in record and record['Field']:
            record['Field'] = preprocess_text(record['Field'])
        elif 'skills' in record and record['skills']:  
            record['skills'] = preprocess_text(record['skills'])  
    return data

processed_cv_data = preprocess(cv_data)
processed_offer_data = preprocess(offer_data)

# Print the result in JSON format
print(json.dumps([processed_cv_data, processed_offer_data]))
