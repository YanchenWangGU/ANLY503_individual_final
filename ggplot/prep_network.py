import pandas as pd 
from sklearn import linear_model
import statsmodels.api as sm
import plotly.plotly as py
import plotly.graph_objs as go
from sklearn.preprocessing import MinMaxScaler
import numpy as np

df = pd.read_csv('ev_ownership_by_state_long.csv')
df = df[df['year']==2018]
df1 = pd.read_csv('income.csv')
df = pd.merge(df,df1, on = 'state')
df1 = pd.read_csv('gas_price.csv')
df = pd.merge(df,df1, on = 'state')
df1 = pd.read_csv('pop_density.csv')
df = pd.merge(df,df1, on = 'state')
df1 = pd.read_csv('us_pop.csv')
df = pd.merge(df,df1, on = 'state')

df2 = pd.read_csv('charging_sta_count.csv')
df3 = pd.read_csv('state_ab.csv')
df4 = pd.merge(df2,df3, left_on = 'State', right_on = 'Abbreviation')
df4 = df4.drop(columns=['State_x', 'Abbreviation'])
df4= df4.rename(index=str, columns={"State_y": "state"})
df5 = pd.read_csv('us_pop.csv')
df5 = pd.merge(df4,df5,on = 'state')
df5['sta_density'] = (df5['sta_count']*1000)/df5['pop']
df5 = df5[['state','sta_density']]
df = pd.merge(df,df5, on = 'state')

df = df.drop(columns = ['year'])
dftemp = pd.DataFrame()
dftemp['state'] = df.state
for i in df.drop('state', axis=1).columns:
    max_v = df[i].max()
    min_v = df[i].min()
    dftemp[i] = (df[i] - min_v) / (max_v - min_v)

result = []
for index, row in dftemp.iterrows():
    to_add = []
    for j in df.drop('state', axis=1).columns:
        to_add.append(row[j])
    result.append(to_add)
print(result)

cos_sim_list = []
sim_index_list = []
def dot(A,B): 
    return (sum(a*b for a,b in zip(A,B)))
def cosine_similarity(a,b):
    return dot(a,b) / ( (dot(a,a) **.5) * (dot(b,b) ** .5) )

vec_index = 0
for i in result:
    cos_sim_list = []
    for j in result:
        cos_sim_list.append(cosine_similarity(i,j))
    cos_sim_list = np.array(cos_sim_list)
    choices = cos_sim_list.argsort()[-21:][::-1][1:21]
#    same = generate_same_state_index(vec_index)
    record =[]
    for choice in choices:
#        if choice not in same:
        record.append(choice)
        if len(record)==3:
            break
    sim_index_list.append(record)
    vec_index+=1

col_edgelist = ['SourceNmae','TargetName','SourceID','TargetID','CosSim']
edgelist = pd.DataFrame(columns = col_edgelist)
edgelist

source_index = 0
for indexes in sim_index_list:
    for target_index in indexes:
        
        source_name = str(dftemp.iloc[source_index]['state'])
        target_name = str(dftemp.iloc[target_index]['state'])
        
        cos_sim = cosine_similarity(result[source_index],result[target_index])
        
        record = [source_name,target_name,source_index,target_index,cos_sim]

        edgelist.loc[len(edgelist)] = record
        
    #print(source_index)
    source_index+=1

edgelist.to_csv('edgelist.csv', index=False)

roundvec = [[np.round(float(i), 2) for i in nested] for nested in result]
col_nodelist = ['ID','NodeName','Rate','Vectors']
nodelist = pd.DataFrame(columns = col_nodelist)
nodelist.ID = list(range(50))
nodelist.NodeName = dftemp['state'].tolist()
nodelist.Rate = dftemp['share'].tolist()
nodelist.Vectors = roundvec
nodelist.to_csv('nodelist.csv',index = False)