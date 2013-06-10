package de.itemis.jsonized.music

import com.google.common.collect.HashMultiset
import com.google.common.collect.Multiset
import java.util.Set
import org.junit.Test

import static org.junit.Assert.*

import static extension com.google.common.collect.Multimaps.*

class Puzzlers {
	val static tracks = new MusicDB("db.json").tracks

	/**
	 * List the number of tracks per decade
	 */
	@Test def void numberOfTracksPerDecade() {

		val tracksPerDecade = tracks.index [
			if (year != null)
				year.toString.substring(0, 3) + '0'
			else
				'undefinded'
		].asMap

		val decadeToTrackCount = tracksPerDecade.mapValues[size].entrySet.sortBy[key]

		'''
			{
				«FOR it : decadeToTrackCount»
					"«key»" : «value»
				«ENDFOR»
			}
		''' -> '''
			{
				"1960" : 32
				"1970" : 119
				"1980" : 44
				"1990" : 304
				"2000" : 1920
				"2010" : 798
				"undefinded" : 579
			}
		'''
	}

	@Test def void computeTotalPlayCount() {

		// tracks.map[ playCount ].reduce[a , b| a + b]
		assertEquals('total number of songs played', 17972, -1)
	}

	@Test def void findRockArtistWithLongestTrack() {

		// 'The Mystic Valley Band' == tracks.filter [ genre == 'Rock' ].sortBy [ totalTime ].last.artist
		val String artist = ''
		assertEquals(22, artist.length)
	}

	@Test def void daysListeningToMusic() {

		// time listened to last track in db in minutes
		// tracks.map [ playCount * totalTime ].last / (1000 * 60)
		assertEquals('time listened to last track in db in minutes', 37, 0)

		// tracks.map [ playCount * totalTime ].reduce [ a, b | a + b ] / (1000 * 60 * 60 * 24)
		assertEquals('total number of days listened to music', -1, -1)
	}

	/* The artist with the largest number of songs longer than 10 minutes */
	@Test def void findLongPerformer() {

		//		val longSong = 10.minutes
		//		println(tracks.filter[ totalTime > longSong ].index[artist].asMap.entrySet.sortBy[ value.size ].last.key) 
		assertEquals('number of songs longer than 10 minutes', 15, -1)
		assertEquals('???', /* artist's name */ '???')
	}

	@Test def void findArtistWithMostTracks() {
		val artists = newMultiset

		//		tracks.forEach [
		//			artists.add(artist)
		//		]
		//		val artistsWithMostTracks = artists.entrySet.sortBy [ count ].reverseView.take(10)
		// as one-liner
		// tracks.fold(newMultiset) [ result, it | result += artist ].entrySet.sortBy[count].reverseView.take(10)
		val artistsWithMostTracks = artists.entrySet
		'''
			{
				«FOR it : artistsWithMostTracks»
					"«element»" : «count»
				«ENDFOR»
			}
		''' -> '''
			{
				"Deep Purple" : 149,
				"Beck" : 105,
				"John Frusciante" : 82,
				"Elbow" : 57,
				"Steely Dan" : 57,
				"Motorpsycho" : 55,
				"Radiohead" : 54,
				"The Decemberists" : 49,
				"Andrew Bird" : 46,
				"P.J. Harvey" : 46
			}
		'''
	}

	@Test def void findSecondMostPlayedArtist() {
		assertEquals('played songs of most played artist', 1289, -1)

		//		val artistToPlayCount = tracks.fold(newMultiset) [ set, track | set.add(track.artist, playCount) return set ]
		//		artistToPlayCount.entrySet.sortBy [ count ].reverseView.drop(1).head.element
		assertEquals('second most played artist', '???', '???')
	}

	/***************** Library Methods ******************/
	/**
	 * Creates a new {@link Multiset}. In constrast to a plain {@link Set} 
	 * a multiset can contain more than one entry for a given key. It allows to query for the
	 * number of entries per key, so it's quite similar to a {@code Map<String, Integer>}.
	 */
	protected def Multiset<String> newMultiset() {
		HashMultiset::create
	}

	/**
	 * Returns the number of milliseconds for a given number of minutes.
	 */
	protected def minutes(int minutes) {
		minutes * 60 * 1000
	}

	/**
	 * Operator for simple template expression comparison. Meant to be used like this :
	 * <pre>
	 *   '''
	 * 		«sayHello()»
	 *   ''' -> '''
	 * 		Hello World
	 *   '''
	 * </pre>
	 */
	protected def void operator_mappedTo(CharSequence from, CharSequence to) {
		assertEquals(to.toString, from.toString)
	}
}