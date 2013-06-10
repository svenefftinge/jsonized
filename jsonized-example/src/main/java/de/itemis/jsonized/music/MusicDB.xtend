package de.itemis.jsonized.music

import com.google.common.base.Charsets
import com.google.common.io.Files
import com.google.gson.JsonObject
import com.google.gson.JsonParser
import de.itemis.jsonized.Jsonized
import java.io.File

@Jsonized('
	{
		"Track" : [
			{
				"Album" : "Demo Stuff",
				"Album Artist" : "John Frusciante",
				"Artist" : "John Frusciante",
				"Bit Rate" : 160,
				"Date Added" : "2010-07-08T11:12:23Z",
				"Date Modified" : "2010-07-08T11:13:31Z",
				"Genre" : "Alternative",
				"Name" : "Howhigh",
				"Normalization" : 2715,
				"Persistent ID" : "FF4360DE8CA67940",
				"Play Count" : 1,
				"Play Date" : 3411402363,
				"Play Date UTC" : "2012-02-06T18:46:03Z",
				"Sample Rate" : 44100,
				"Size" : 1284723,
				"Total Time" : 64182,
				"Track ID" : 1523,
				"Track Number" : 18,
				"Track Type" : "Remote",
				"Year" : 2000
			}
		]
	}')
class MusicDB {
	new(){}
	new (String path) {
		val file = new File(path)
		val reader = Files.newReader(file, Charsets.UTF_8)
		try {
			val rootElement = new JsonParser().parse(reader)
			delegate = rootElement as JsonObject
		} finally {
			reader?.close
		}
	}
}
