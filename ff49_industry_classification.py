# -*- coding: utf-8 -*-
"""
Created on Mon Mar 13 18:41:51 2017

@author: charlesmartineau

Parsing the Fama-French 49 Industry classification txt into a simple
Pandas DataFrame for easy merging with CRSP / Compustat data.

The original txt file is from French's website:
http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/
Data_Library/det_49_ind_port.html

The code may not be the "sexiest" one but it is efficient and simple.

"""

import pandas as pd

# laod the Fama-French 49 industry classification txt
with open('/Users/.../'
          'Siccodes49.txt') as f:
    content = f.readlines()
# remove whitespace characters like `\n` at the end of each line
ff49 = [x.strip() for x in content] 

classification = []
sic1 = []
sic2 = []
for l in ff49:
    # if list in empty - skip
    if not l:
        continue 
    # if not empty, break line by space
    l = l.split()
    if 1<= len(l[0]) <= 2:
        class_ = l[0]  # assign the ff49 industry classification
        continue
    if '-' in l[0]:
        classification.append(class_)  # append lass classfication
        sic1.append(l[0][:4])
        sic2.append(l[0][5:])

df = pd.DataFrame(data={'ff49': classification,
                        'sic1': sic1,
                        'sic2': sic2})

# export the dataframe to csv
df.to_csv('/Users/.../'
          'Siccodes49.csv', index=0)