package de.itemis.jsonized

import org.eclipse.xtend.lib.macro.AbstractClassProcessor
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.RegisterGlobalsContext
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.ClassDeclaration
import org.eclipse.xtend.lib.macro.declaration.MutableClassDeclaration

import com.google.gson.JsonElement
import static extension de.itemis.jsonized.JsonObjectEntry.*

/**
 * Structure by example.
 * 
 * You have a JSON snippet - I build your classes.
 */
@Active(JsonizedProcessor)
annotation Jsonized {
	/**
	 * A sample json snippet.
	 */
	String value
}

class JsonizedProcessor extends AbstractClassProcessor {

	/**
	 * Called first. Only register any new types you want to generate here.
	 */
	override doRegisterGlobals(ClassDeclaration annotatedClass, RegisterGlobalsContext context) {
		// visit the whole JSON tree and register any nested classes
		registerClassNamesRecursively(annotatedClass.jsonEntries, context)
	}

	private def void registerClassNamesRecursively(Iterable<JsonObjectEntry> json, RegisterGlobalsContext context) {
		for (jsonEntry : json) {
			if (jsonEntry.isJsonObject) {
				context.registerClass(jsonEntry.className)
				
				registerClassNamesRecursively(jsonEntry.childEntries, context)
			}
		}
	}

	/**
	 * Called secondly. Modify the types.
	 */
	override doTransform(MutableClassDeclaration annotatedClass, extension TransformationContext context) {
		enhanceClassesRecursively(annotatedClass, annotatedClass.jsonEntries, context)
		annotatedClass.addConstructor [
			addParameter('delegate', newTypeReference(JsonElement))
			body = ['''setDelegate((com.google.gson.JsonObject)delegate);''']
		]
	}
	
	def void enhanceClassesRecursively(MutableClassDeclaration clazz, Iterable<? extends JsonObjectEntry> entries, extension TransformationContext context) {
		// set the super class
		clazz.extendedClass = newTypeReference(AbstractJsonized)
		
		// add accessors for the entries
		for (entry : entries) {
			val type = entry.getComponentType(context)
			val realType = if(entry.isArray) getList(type) else type
			
			clazz.addMethod("get" + entry.propertyName.toFirstUpper) [
				returnType = realType
				body = ['''
					return («realType») wrap(_delegate.get("«entry.key»"), «toJavaCode(type)».class);
				''']
			]
			
			clazz.addMethod("set" + entry.propertyName.toFirstUpper) [
				addParameter(entry.propertyName, realType)
				returnType = primitiveVoid
				body = ['''
					_delegate.add("«entry.key»", unWrap(«entry.propertyName», «toJavaCode(type)».class));
				''']
			]
			
			// if it's a JSON Object call enhanceClass recursively
			if (entry.isJsonObject)
				enhanceClassesRecursively(findClass(entry.className), entry.childEntries, context)
		}
	}

}
