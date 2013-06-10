package de.itemis.jsonized.weather

import java.io.File
import java.io.FileOutputStream

class WeatherReport {
	
	def static void main(String[] args) {
		val latitude = "54.41"
		val longitude = "10.23"
		val data = new WeatherData(latitude, longitude)
		new FileOutputStream(new File("weather.html")) => [
			write(
				new WeatherReport().generateReport(data).toString.bytes
			)
			close
		]
	}
	
	def generateReport(WeatherData data) '''
		<html>
		  <head>
		    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
		    <script type="text/javascript">
		      google.load("visualization", "1", {packages:["corechart"]});
		      google.setOnLoadCallback(drawChart);
		      function drawChart() {
		        var data = google.visualization.arrayToDataTable([
		        ['Time', 'Wind (kmh)', 'Temp (C)', 'Water Temp (C)','Swell (m)']
		        «FOR it : data.weather.hourlys»
		          ,['«time»',«windspeedkmph»,«tempc»,«watertempC»,«swellheightM»]
		        «ENDFOR»
		        ]);
		
		        var options = {
		          title: 'Weather'
		        };
		
		        var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
		        chart.draw(data, options);
		      }
		    </script>
		  </head>
		  <body>
		  	<div style="width: 900px; height: 500px;">
				<img style="float:right;" src="http://maps.googleapis.com/maps/api/staticmap?center=«data.latitude»,«data.longitude»&zoom=11&size=200x200&sensor=false">
				<h1>Weather in Laboe on «data.weather.date»</h1>
			  	<i>«data.locationData.displayName»</i>
			  	<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
			    <div id="chart_div" style="width: 900px; height: 500px;"></div>
		  	</div>
		  </body>
		</html>
	'''
	
}