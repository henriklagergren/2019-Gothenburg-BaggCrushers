import numpy as np
import pandas as pd
import json
print("hello_world")

test = 7

aidPerCountry = pd.read_excel("./aid/aid_from_sida.xlsx")

aidPerCountry = aidPerCountry[['recipient-country','transaction-value-sek', 'recipient-country-code']]
aidPerCountry.columns = ["country","aid_received_sek","country_code"]
aidPerCountry = aidPerCountry.groupby(['country',"country_code"])['aid_received_sek'].sum()
aidPerCountry = aidPerCountry.to_frame()
aidPerCountry.reset_index(inplace=True)
corruptionPerCountry = pd.read_excel("./corruption/2018_CPI_FullDataSet.xlsx")

corruptionPerCountry = corruptionPerCountry[['Country','CPI Score 2018']]
corruptionPerCountry.columns = ["country","CPI"]
#print(corruptionPerCountry)
#print(aidPerCountry)
#aidPerCountry['country_code'] = aidPerCountry['country_code'].astype(str)
#print(aidPerCountry.applymap(type))

result = corruptionPerCountry.merge(aidPerCountry, on="country", how='outer')

#result = aidPerCountry.join(corruptionPerCountry, on="Country")
#result = result.to_json(orient='table')

Export = result.to_json (r'.\WithNullValues.json', orient="table")
resultNoNull = result.dropna()
Export = resultNoNull.to_json(r'.\WithoutNullValues.json', orient="table")
print(resultNoNull)
print(result)

#with open('result.json','w') as outfile:
    #json.dump(result, outfile)
