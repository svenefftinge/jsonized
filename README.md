JSONized
========

A simple statically-typed way to access JSON Data from Java.

#### Step 1: Find some JSON Data

Let’s take data from Yahoo as an example. The data contains the most popular new album releases. Here's the first album:

```json
{
 "query": {
  "count": 24,
  "created": "2013-03-21T20:13:42Z",
  "lang": "en-US",
  "results": {
   "Release": [
    {
     "UPC": "602527291567",
     "explicit": "0",
     "flags": "2",
     "id": "218641405",
     "label": "Streamline/Interscope/Kon Live",
     "rating": "-1",
     "releaseDate": "2009-11-23T08:00:00Z",
     "releaseYear": "2009",
     "rights": "160",
     "title": "The Fame Monster",
     "typeID": "2",
     "url": "http://new.music.yahoo.com/lady-gaga/albums/fame-monster--218641405",
     "Artist": {
      "catzillaID": "0",
      "flags": "115202",
      "hotzillaID": "1810013384",
      "id": "58959115",
      "name": "Lady Gaga",
      "rating": "-1",
      "trackCount": "172",
      "url": "http://new.music.yahoo.com/lady-gaga/",
      "website": "http://www.ladygaga.com/"
     },
     "ItemInfo": {
      "ChartPosition": {
       "last": "1",
       "this": "1"
      }
     }
    },
.... 
}
```

#### Step 2: Copy the example data into an @Jsonized annotation:

Jsonized makes use of Xtend's active annotations, which is a compile-time macros system.
The @Jsonized annotation will generate Java classes with the respective accessor methods for the given JSON example.

```xtend
@Jsonized('{
 "query": {
  "count": 24,
  "created": "2013-03-21T20:13:42Z",
  "lang": "en-US",
  "results": {
   "Release": [
    {
     "UPC": "602527291567",
     "explicit": "0",
     "flags": "2",
     "id": "218641405",
     "label": "Streamline/Interscope/Kon Live",
     "rating": "-1",
     "releaseDate": "2009-11-23T08:00:00Z",
     "releaseYear": "2009",
     "rights": "160",
     "title": "The Fame Monster",
     "typeID": "2",
     "url": "http://new.music.yahoo.com/lady-gaga/albums/fame-monster--218641405",
     "Artist": {
      "catzillaID": "0",
      "flags": "115202",
      "hotzillaID": "1810013384",
      "id": "58959115",
      "name": "Lady Gaga",
      "rating": "-1",
      "trackCount": "172",
      "url": "http://new.music.yahoo.com/lady-gaga/",
      "website": "http://www.ladygaga.com/"
     },
     "ItemInfo": {
      "ChartPosition": {
       "last": "1",
       "now": "1"
      }
     }
    }]
   }
  }
}')
class MusicReleases {
  // empty
}
```

#### Step 3: Enjoy statically-typed accessor methods!

Now from Java (or Xtend) you can simply work with the Json Data in a statically typed way.
And it's just a super thin layer so you have full access to the underlying JsonObject if you want to go more dynamic.

Have fun!


