import numpy as np
import pandas as pd
import json

aidPerCountry = pd.read_excel("./aid/aid_from_sida.xlsx")
aidPerCountry = aidPerCountry[['recipient-country', 'sector',
                               'transaction-value-sek', 'recipient-country-code']]
aidPerCountry.columns = ["country", "sector",
                         "aid_received_sek", "country_code"]
aidPerCountry = aidPerCountry.groupby(['country', "country_code", 'sector'])[
    'aid_received_sek'].sum()

aidPerCountry = aidPerCountry.to_frame()
aidPerCountry.reset_index(inplace=True)

json_file = {"countries": []}
json_file
pRow = ""
# print(aidPerCountry)
countryIndex = -1
sectorIndex = 0
for index, row in aidPerCountry.iterrows():
    if row['country'] != pRow:
        json_file['countries'].append(
            {row['country']: {"sectors": [{row['sector']: row['aid_received_sek']}]}})
        countryIndex = countryIndex+1
        sectorIndex = 0
    else:

        # print(json_file['countries'][countryIndex["sectors"]])
        json_file['countries'][countryIndex][row['country']]["sectors"].append(
            {row['sector']: row['aid_received_sek']})

    pRow = row['country']

# print(json_file['countries'][0])
# print(json_file)
with open('sector-per-country.json', 'w') as outfile:
    json.dump(json_file, outfile)
