package de.itemis.jsonized

import com.google.common.base.CaseFormat
import com.google.gson.JsonArray
import com.google.gson.JsonElement
import com.google.gson.JsonObject
import com.google.gson.JsonParser
import com.google.gson.JsonPrimitive
import java.io.InputStreamReader
import java.net.URL
import java.util.Map
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.ClassDeclaration
import org.eclipse.xtend.lib.macro.declaration.CompilationUnit
import org.eclipse.xtend.lib.macro.declaration.TypeReference

@Data class JsonObjectEntry {
	
	/**
	 * Parses the value of the first annotation as JSON and turns it into an iterable of JsonObjectEntries.
	 */
	def static Iterable<JsonObjectEntry> getJsonEntries(ClassDeclaration clazz) {
		val string = clazz.annotations.head.getValue('value').toString
		if (!string.trim.startsWith("{")) {
			val in = new URL(string).openStream;
			try {
				val jsonElement = new JsonParser().parse(new InputStreamReader(in))
				val jsonObject = if (jsonElement.jsonArray) {
						jsonElement.asJsonArray.get(0) as JsonObject
					} else {
						jsonElement.asJsonObject
					}
				return jsonObject.getEntries(clazz.compilationUnit)
			} finally {
				in.close
			}
		}
		return (new JsonParser().parse(string) as JsonObject).getEntries(clazz.compilationUnit)
	}
	
	/**
	 * @return an iterable of JsonObjectEntries
	 */
	private static def Iterable<JsonObjectEntry> getEntries(JsonElement e, CompilationUnit unit) {
		switch e {
			JsonObject : {
				e.entrySet.map[new JsonObjectEntry(unit, it)]
			}
			default : #[]
		}
	}
	
	CompilationUnit unit
	Map$Entry<String, JsonElement> entry
	
	/**
	 * @return the entry key, i.e. the Json name
	 */
	def String getKey() {
		return entry.key
	}
	
	/**
	 * @return the value of this entry
	 */
	def JsonElement getValue() {
		return entry.value
	}
	
	/**
	 * @return whether this entry contains an array
	 */
	def boolean isArray() {
		entry.value instanceof JsonArray
	}
	
	/**
	 * @return whether this entry contains a nested JsonObject (directly or indirectly through a JsonArray)
	 */
	def boolean isJsonObject() {
		return getJSONObject != null
	}
	
	private def getJSONObject() {
		var value = entry.value
		if (isArray)
			value = (value as JsonArray).head
		if (value instanceof JsonObject) {
			return value
		}
		return null
	}
	
	/**
	 * @return the property name. It's the JSON entry key turned into a Java identifer.
	 */
	def getPropertyName() {
		val result = CaseFormat::UPPER_UNDERSCORE.to(CaseFormat::LOWER_CAMEL, entry.key.replace(' ', '_'))
		if (isArray)
			return result + 's'
		return if (result=='class') {
			'clazz'
		} else {
			result
		}
	}
	
	/**
	 * @return the fully qualified class name to use if this is entry contains a JsonObject
	 */
	def getClassName() {
		if (isJsonObject) {
			val simpleName = CaseFormat::UPPER_UNDERSCORE.to(CaseFormat::UPPER_CAMEL, entry.key.replace(' ', '_'))
			return if (unit.packageName!= null) 
						unit.packageName+"."+simpleName
					else
						simpleName
		}
		return null
	}
	
	/**
	 * @return the component type, i.e. the type of the value or the type of the first entry if value is a JsonArray 
	 */
	def TypeReference getComponentType(extension TransformationContext ctx) {
		val v = if (entry.value instanceof JsonArray) {
			(entry.value as JsonArray).head
		} else {
			entry.value
		}
		switch v {
			JsonPrimitive: {
				if (v.isBoolean)
					primitiveBoolean
				else if (v.isNumber)
					newTypeReference(Long)
				else if (v.isString)
					string
			}
			JsonObject: {
				findClass(className).newTypeReference
			}
		}
	}
	
	/**
	 * @return the JsonObjectEntrys or <code>null</code> if the value is not a JsonObject
	 */
	def Iterable<JsonObjectEntry> getChildEntries() {
		if (isJsonObject) {
			return getEntries(getJSONObject, unit)
		}
		return #[]
	}

}