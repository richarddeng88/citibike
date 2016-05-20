import pandas as pd
import googlemaps
from datetime import datetime
import numpy

gmaps = googlemaps.Client(key='AIzaSyDTV6vS1GeEk_pR5ocM_ClRgOSBc1my4oo')

### Geocoding an address
##a = gmaps.geocode('1600 Amphitheatre Parkway, Mountain View, CA')
##len(a) # a is a list ,only one
##for d in a:
##    print(d['geometry'])
##
##for d in a:
##    print(d['address_components'])

    
# Look up an address with reverse geocoding
df = pd.read_csv('C:\Users\Richard\Desktop\Rcourse\citibike\station_for_map.csv')
main_df = pd.DataFrame(columns=('index','boro'))


for a in df['index']:
        print('ready to work on ', a)
        lati = df['latitude'][df['index']==a]
        longi = df['longitude'][df['index']==a]
        info = gmaps.reverse_geocode((float(lati),float(longi)))
##        len(info) # b is a list ,including 9 components
        boro = info[0]['address_components'][3]['short_name']
        print boro
        s = pd.Series([a,boro],index=['index','boro'])
        main_df = main_df.append(s,ignore_index=True)

final_df = pd.merge(df,main_df,on=['index'])
final_df.to_csv('C:\Users\Richard\Desktop\Rcourse\citibike\station_for_map.csv')
