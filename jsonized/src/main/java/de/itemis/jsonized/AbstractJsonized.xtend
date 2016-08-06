package de.itemis.jsonized

import com.google.gson.JsonArray
import com.google.gson.JsonElement
import com.google.gson.JsonNull
import com.google.gson.JsonObject
import com.google.gson.JsonPrimitive
import com.google.gson.internal.Streams
import com.google.gson.stream.JsonWriter
import java.io.StringWriter
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

abstract class AbstractJsonized {

    @Accessors protected JsonObject delegate = new JsonObject

    /**
	 * wraps a JsonElement into the container type
	 */
    def protected Object wrap(JsonElement element, Class<?> containerType) {
        switch element {
            JsonPrimitive: {
                if (element.boolean)
                    element.asBoolean
                else if (element.isNumber)
                    try {
                        Long.parseLong(element.asString)
                        element.asNumber.longValue as Long
                    } catch(NumberFormatException e) {
                        element.asNumber.doubleValue as Double
                    }
                else if (element.string)
                    element.asString
            }
            JsonArray: {
                element.map[wrap(it, containerType)].toList
            }
            JsonObject: {
                val jsonized = containerType.newInstance as AbstractJsonized
                jsonized.delegate = element
                return jsonized
            }
            default:
                null
        }
    }

    /**
	 * @return creates a JsonElement from the given object.
	 */
    def protected JsonElement unWrap(Object element, Class<?> containerType) {
        switch element {
            Boolean:
                new JsonPrimitive(element)
            Number:
                new JsonPrimitive(element)
            String:
                new JsonPrimitive(element)
            AbstractJsonized:
                element.delegate
            List<?>: {
                val result = new JsonArray
                element.forEach [
                    result.add(unWrap(it, containerType))
                ]
                result
            }
            default:
                JsonNull.INSTANCE
        }
    }

    override toString() {
        val stringWriter = new StringWriter()
        val jsonWriter = new JsonWriter(stringWriter) => [
            lenient = true
            indent = '  '
        ]
        Streams::write(delegate, jsonWriter)
        return stringWriter.toString()
    }

}
