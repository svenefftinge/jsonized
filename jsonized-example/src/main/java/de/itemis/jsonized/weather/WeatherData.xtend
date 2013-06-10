package de.itemis.jsonized.weather

import com.google.gson.JsonObject
import com.google.gson.JsonParser
import de.itemis.jsonized.Jsonized
import java.io.InputStreamReader
import java.net.URL

@Jsonized('
{ 
   "data":{
      "nearest_area":[
         {
            "distance_miles":"24.4",
            "latitude":"45.000",
            "longitude":"-1.500"
         }
      ],
      "request":[
         {
            "query":"Lat 45.00 and Lon -2.00",
            "type":"LatLon"
         }
      ],
      "weather":[
         {
            "date":"2013-04-20",
            "hourly":[
               {
                  "cloudcover":"0",
                  "humidity":"76",
                  "precipMM":"0.0",
                  "pressure":"1031",
                  "sigHeight_m":"2.0",
                  "swellDir":"280",
                  "swellHeight_m":"1.9",
                  "swellPeriod_secs":"10.9",
                  "tempC":"11",
                  "tempF":"52",
                  "time":"0",
                  "visibility":"10",
                  "waterTemp_C":"13",
                  "waterTemp_F":"55",
                  "weatherCode":"113",
                  "weatherIconUrl":[
                     {
                        "value":"http://www.worldweatheronline.com/images/wsymbols01_png_64/wsymbol_0001_sunny.png"
                     }
                  ],
                  "winddir16Point":"N",
                  "winddirDegree":"8",
                  "windspeedKmph":"29",
                  "windspeedMiles":"18"
               }
            ],
            "maxtempC":"15",
            "mintempC":"9"
         }
      ]
   }
}
')
class WeatherData {
	
	@Property String latitude
	@Property String longitude
	@Property LocationData locationData
	
	new(String latitude, String longitude) {
		val in = new URL('''http://api.worldweatheronline.com/free/v1/marine.ashx?q=«latitude»%2C«longitude»&format=json&key=6s7x3qqc2cjm2xbcq3psrd45''').openStream;
		try {
			this.delegate = new JsonParser().parse(new InputStreamReader(in)) as JsonObject
		} finally {
			in.close
		}
		this.latitude = latitude
		this.longitude = longitude
		this.locationData = new LocationData(latitude, longitude)
	}
	 
	def getWeather() {
		data.weathers.head
	}
}