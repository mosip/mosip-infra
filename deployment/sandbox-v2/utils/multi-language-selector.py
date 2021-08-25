import os
import pandas as pd

lang_list = ['hin', 'tam', 'fra']
mandatory_lang= 'tam'
pattern = '|'.join(lang_list)
input_path='/home/mosipuser/mosip-infra/deployment/sandbox-v2/tmp/mosip-data/data-dml/mosip_master/dml/'  #User Defined
folder_path='/home/mosipuser/mosip-infra/deployment/sandbox-v2/tmp/mosip-data/data-dml/mosip_master/dml-old/'

filelist=[]
lang_code=[]

os.rename(input_path, folder_path)
os.mkdir(input_path)

for x in os.listdir(folder_path):
    if x.endswith(".csv"):
        filelist.append(x)

for x in range(len(filelist)):
    df = pd.read_csv(folder_path+filelist[x], dtype = str)
    df2 = pd.read_csv(folder_path+filelist[x], dtype = str)
    df.columns = df.columns.str.lower()
    df2.columns = df2.columns.str.lower()

    if 'lang_code' in df:
        if df['lang_code'].str.contains(mandatory_lang).any():
            print('Column Present and value present: ' + filelist[x])
            result_df = df[df['lang_code'].str.contains(pattern)]
            result_df.to_csv(input_path+filelist[x], index=False)
        else:
            print('Column presrent but value not present: '+ filelist[x])
            df['lang_code']= df['lang_code'].str.replace('[a-z][a-z][a-z]', mandatory_lang, regex=True)
            df.to_csv(input_path+filelist[x], index=False)
    else:
        print('column not present: '+ filelist[x])
        df2.to_csv(input_path+filelist[x], index=False)
