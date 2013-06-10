package de.itemis.jsonized.weather

import com.google.gson.JsonParser
import de.itemis.jsonized.Jsonized
import java.io.InputStreamReader
import java.net.URL

@Jsonized('http://open.mapquestapi.com/nominatim/v1/search?q=54.467,10.4&format=json')
class LocationData {
	@Property String latitude
	@Property String longitude
	
	new(String latitude, String longitude) {
		val in = new URL('''http://open.mapquestapi.com/nominatim/v1/search?q=«latitude»,«longitude»&format=json''').openStream;
		try {
			this.delegate = new JsonParser().parse(new InputStreamReader(in)).asJsonArray.get(0).asJsonObject
		} finally {
			in.close
		}
		this.latitude = latitude
		this.longitude = longitude
	}
}