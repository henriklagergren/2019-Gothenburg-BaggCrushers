import numpy as np
import pandas as pd

print("hello_world")

test = 7

aidPerCountry = pd.read_excel("./aid/aid_from_sida.xlsx")

aidPerCountry = aidPerCountry[['recipient-country','transaction-value-sek']]
print(aidPerCountry.groupby('recipient-country') ['transaction-value-sek'].sum())
