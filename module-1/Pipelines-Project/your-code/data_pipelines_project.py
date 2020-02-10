
#Data Pipeline
# import libraries
import pymysql
import pandas as pd
from sqlalchemy import create_engine
import matplotlib.pyplot as plt 
# %matplotlib inline 

# Acquisition of Source Data
def accquire():
    path = '/Users/sfy/Documents/Ironhack/daft0120slab/module-1/Pipelines-Project/data/novel-corona-virus-2019-dataset/2019_nCoV_data.csv'
    pd.set_option('display.max_columns', None)

    CoV_2019 = pd.read_csv(path)
    print(CoV_2019.head())
    return CoV_2019

# Wrangling
def wrangle(CoV_2019):
    for i in CoV_2019.columns:
        if (CoV_2019[i].dtypes == float) is True:
            CoV_2019[i] = CoV_2019[i].astype(int) 
    drop_col = ['Sno','Last Update']
    d = CoV_2019.drop(columns = drop_col)
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

    d['Country'] = list(map(normal, d['Country']))
    d = d.rename(columns = {'Province/State':'Province'})
    cov_full = d
    return cov_full

# Analysis
def analyze(cov_full):
    engine = create_engine('mysql+pymysql://root:mshhgz999@localhost/cov_2019')
    cov_full.to_sql('full_data', con = engine, if_exists='replace', index=False)
    import pymysql.cursors  
    connection = pymysql.connect(user='root',
                             password='mshhgz999',
                             db = 'cov_2019',
                             charset='utf8mb4',
                             cursorclass=pymysql.cursors.DictCursor)

    q1 = '''
    SELECT * 
    FROM cov_2019.full_data
    WHERE Country NOT LIKE '%China' 
    '''

    cursor = connection.cursor()
    cursor.execute(q1)

    x = cursor.fetchall()
    d_nonchn = pd.DataFrame(x)
    cursor.close()
    d_nonchn.to_sql('non_chn', con = engine, if_exists='replace', index=False)
    print(d_nonchn.head())

    connection = pymysql.connect(user='root',
                            password='mshhgz999',
                            db = 'cov_2019',
                            charset='utf8mb4',
                            cursorclass=pymysql.cursors.DictCursor)
    q2 = '''
    SELECT * 
    FROM cov_2019.full_data
    WHERE Country LIKE '%China' 
    '''

    cursor = connection.cursor()
    cursor.execute(q2)

    x = cursor.fetchall()
    d_chn = pd.DataFrame(x)
    cursor.close()
    d_chn.to_sql('chn', con = engine, if_exists = 'replace', index = False)
    print(d_chn.head())

    connection = pymysql.connect(user='root',
                                password='mshhgz999',
                                db = 'cov_2019',
                                charset='utf8mb4',
                                cursorclass=pymysql.cursors.DictCursor)
    q7 = '''
    SELECT
        Province,
        SUM(Confirmed) AS 'Total_Confirmed',
        SUM(Deaths) AS 'Total_Deaths',
        SUM(Recovered) AS 'Total_Recovered',
        CEILING(SUM(Deaths) / SUM(Confirmed) * 100) AS 'Death_Rate(%)',
        CEILING(SUM(Recovered) / SUM(Confirmed) * 100) AS 'Recover_Rate(%)'
    FROM cov_2019.chn
    WHERE Confirmed > 0
    GROUP BY Province
    ORDER BY 
        Total_Confirmed DESC, 
        Total_Deaths DESC, 
        Total_Recovered DESC
    '''

    cursor = connection.cursor()
    cursor.execute(q7)

    x = cursor.fetchall()
    d_chP_r = pd.DataFrame(x)
    try:
        d_chP_r[d_chP_r.columns[1:]] = d_chP_r[d_chP_r.columns[1:]].astype(int)
    except TypeError:
        print('Value cannot be converted.')
    cursor.close()
    print(d_chP_r.head())

    connection = pymysql.connect(user='root',
                                password='mshhgz999',
                                db = 'cov_2019',
                                charset='utf8mb4',
                                cursorclass=pymysql.cursors.DictCursor)
    q8 = '''
    SELECT
        Country,
        Province AS 'State',
        SUM(Confirmed) AS 'Total_Confirmed',
        SUM(Deaths) AS 'Total_Deaths',
        SUM(Recovered) AS 'Total_Recovered',
        CEILING(SUM(Deaths) / SUM(Confirmed) * 100) AS 'Death_Rate(%)',
        CEILING(SUM(Recovered) / SUM(Confirmed) * 100) AS 'Recover_Rate(%)'
    FROM cov_2019.non_chn
    WHERE Confirmed > 0
    GROUP BY 
        Country,
        Province
    ORDER BY 
        Total_Confirmed DESC, 
        Total_Deaths DESC, 
        Total_Recovered DESC
    '''

    cursor = connection.cursor()
    cursor.execute(q8)

    x = cursor.fetchall()
    d_NChS_r = pd.DataFrame(x)
    try:
        d_NChS_r[d_NChS_r.columns[1:]] = d_NChS_r[d_NChS_r.columns[1:]].astype(int)
    except TypeError:
        print('Value cannot be converted.')
    cursor.close()
    print(d_NChS_r.head())
    return d_nonchn, d_chn, d_chP_r, d_NChS_r

# Visualize

def visualize(d_nonchn, d_chn, d_chP_r, d_NChS_r):
    timelineCh = d_chn.groupby('Date').agg('sum').plot.line(figsize = (20,15))
    timelineNCh = d_nonchn.groupby('Date').agg('sum').plot.line(figsize = (20,15))
    detailCh = d_chP_r.plot(x = 'Province', kind = 'bar', stacked = 'True', figsize = (25, 20))
    d_NChS_r[['Total_Confirmed', 'Total_Deaths','Total_Recovered','Death_Rate(%)', 'Recover_Rate(%)']] = d_NChS_r[['Total_Confirmed', 'Total_Deaths','Total_Recovered','Death_Rate(%)', 'Recover_Rate(%)']].astype(int)
    detailNCh = d_NChS_r.plot(x = 'Country', kind = 'bar', stacked = 'True', figsize = (15, 20))
    return timelineCh, timelineNCh, detailCh, detailNCh

# Save Output

def save_viz(timelineNCh, timelineCh , detailCh, detailNCh):
    timelineCh = timelineCh.get_figure()
    timelineCh.savefig('timelineCh.png')
    timelineNCh = timelineNCh.get_figure()
    timelineNCh.savefig('timelineNCh.png')
    detailCh = detailCh.get_figure()
    detailCh.savefig('detailCh.png')
    detailNCh = detailNCh.get_figure()
    detailNCh.savefig('detailNCh.png')

if __name__ == '__main__':
    CoV_2019 = accquire()
    cov_full = wrangle(CoV_2019)
    result0, result1, result2, result3 = analyze(cov_full)
    visual0, visual1, visual2, visual3 = visualize(result0, result1, result2, result3)
    save_viz(visual0, visual1, visual2, visual3)