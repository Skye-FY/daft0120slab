
#Data Pipeline
# import libraries
import pymysql
import pandas as pd
from sqlalchemy import create_engine

# Acquisition of Source Data
def acqData(data_sc):
    path = data_sc
    df = pd.read_csv(path)
    return df.head()

# Wrangling
def getInsight(datafrm):
    print('Shape:\n', datafrm.shape, '\n\n\nData Type:\n',datafrm.dtypes, '\n\n\nFind Null Data:\n', datafrm.isnull().sum())
    for i in datafrm.columns:
        print(datafrm[i].value_counts())
def normalize(datafrm):
    for i in datafrm.columns:
        if (datafrm[i].dtypes == 'target dtype to be changed') is True:
            datafrm[i] = datafrm[i].astype('desired dtype') 
    drop_col = ['desired cols to be dropped']
    d = datafrm(columns = drop_col)
    def normal(x):
        if 'China' in x:
            x = 'Mainland China'
            return x
        elif 'Hong Kong' in x:
            x = 'Hong Kong, China'
            return x
        elif 'Taiwan' in x:
            x = 'Taiwan, China'
            return x
        elif 'Macau' in x:
            x = 'Macau, China'
            return x
        else:
            return x

    d['desired col to normalize'] = list(map(normal, d['desired col to normalize']))
    print(d.head())
    return df


def checkNull(datafrm):
    print(datafrm.isna())
    null_df = datafrm[(datafrm['col'].isnull() == True)]
    not_null_df = datafrm[(datafrm['col'].isnull() == False)]
    print(null_df.head(), not_null_df.head())
    return null_df, not_null_df

# Analysis
def toSQL(datafrm, sqldb):
    egn = 'mysql+pymysql://root:mshhgz999@localhost/' + str(sqldb)
    engine = create_engine(egn)
    datafrm.to_sql(str(sqldb), con = engine, if_exists='replace', index=False)

    
    
def frmSQLtoPd(sqldb,query):
    connection = pymysql.connect(user='root',
                         password='mshhgz999',
                         db = str(sqldb),
                         charset='utf8mb4',
                         cursorclass=pymysql.cursors.DictCursor)
    cursor = connection.cursor()
    cursor.execute(query)
    x = cursor.fetchall()
    df = pd.DataFrame(x)
    cursor.close()
    print(df.head())
    return df

# Reporting
def plt(df):
    return df.plot(kind = 'bar', stacked = 'True', figsize = (25, 20))
# tbcompleted
