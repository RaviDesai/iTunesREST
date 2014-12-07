//
//  ContentTests.swift
//  iTunesREST
//
//  Created by Ravi Desai on 12/2/14.
//  Copyright (c) 2014 RSD. All rights reserved.
//

import Cocoa
import XCTest
import iTunesREST

class ContentTests: XCTestCase {

    func testConvertToJSON() {
        var record = Content(wrapper: ContentWrapper.Track, kind: ContentKind.Song, artistId: 1, collectionId: 1, trackId: 1, artistName: "Pink Floyd", collectionName: "The Endless River", trackName: "Allons-y", collectionCensoredName: "The Endless River", trackCensoredName: "Alons-y", artistViewURL: NSURL(string: "http://www.pinkfloyd.com/")!, collectionViewURL: NSURL(string: "http://www.pinkfloyd.com/TheEndlessRiver/")!, trackViewURL: NSURL(string: "http://www.pinkfloyd.com/TheEndlessRiver/Allons-y/")!, previewURL: NSURL(string: "http://www.pinkfloyd.com/TheEndlessRiver/Allons-y/Preview"), artworkURL60: nil, artworkURL100: nil, collectionPrice: 19.99, trackPrice: 1.99, collectionExplicitness: ContentExplicitness.NotExplicit, trackExplicitness: ContentExplicitness.NotExplicit, discCount: 3, trackCount: 10, discNumber: 2, trackNumber: 5, trackTimeMillis: 3*60*1000, country: "USA", currency: "USD", primaryGenreName: "Rock", releaseDate: toDateFromString("yyyy-MM-dd'T'HH:mm:ssX", "2014-10-04 05:00:00 +0500")!)
        
        
        var elem = record.convertToJSON()
        XCTAssertTrue(elem["artistId"] != nil)
        var artistId = elem["artistId"] as Int
        XCTAssertEqual(artistId, 1)
        var collectionName = elem["collectionName"] as String
        XCTAssertEqual(collectionName, "The Endless River")
        var releaseDate = elem["releaseDate"] as String
        XCTAssertEqual(releaseDate, "2014-10-04T00:00:00Z")
    }
    
    func testCreateFromJSON() {
        var jsonPayload = "{\"wrapperType\":\"track\", \"kind\":\"song\", \"artistId\":487143, \"collectionId\":919600058, \"trackId\":919600089, \"artistName\":\"Pink Floyd\", \"collectionName\":\"The Endless River\", \"trackName\":\"Side 3, pt. 2: On Noodle Street\", \"collectionCensoredName\":\"The Endless River\", \"trackCensoredName\":\"Side 3, pt. 2: On Noodle Street\", \"artistViewUrl\":\"https://itunes.apple.com/us/artist/pink-floyd/id487143?uo=4\", \"collectionViewUrl\":\"https://itunes.apple.com/us/album/side-3-pt.-2-on-noodle-street/id919600058?i=919600089&uo=4\", \"trackViewUrl\":\"https://itunes.apple.com/us/album/side-3-pt.-2-on-noodle-street/id919600058?i=919600089&uo=4\", \"previewUrl\":\"http://a1433.phobos.apple.com/us/r1000/059/Music1/v4/ed/a6/f4/eda6f4f7-dc39-2512-516e-8c12f3bd768f/mzaf_5215809693376416325.plus.aac.p.m4a\", \"artworkUrl30\":\"http://a4.mzstatic.com/us/r30/Music1/v4/63/32/f8/6332f811-527a-0ec3-e3d8-dc1a997b0e3c/dj.jzdkxzku.30x30-50.jpg\", \"artworkUrl60\":\"http://a1.mzstatic.com/us/r30/Music1/v4/63/32/f8/6332f811-527a-0ec3-e3d8-dc1a997b0e3c/dj.jzdkxzku.60x60-50.jpg\", \"artworkUrl100\":\"http://a3.mzstatic.com/us/r30/Music1/v4/63/32/f8/6332f811-527a-0ec3-e3d8-dc1a997b0e3c/dj.jzdkxzku.100x100-75.jpg\", \"collectionPrice\":14.99, \"trackPrice\":1.29, \"releaseDate\":\"2014-11-10T08:00:00Z\", \"collectionExplicitness\":\"notExplicit\", \"trackExplicitness\":\"notExplicit\", \"discCount\":1, \"discNumber\":1, \"trackCount\":18, \"trackNumber\":9, \"trackTimeMillis\":102213, \"country\":\"USA\", \"currency\":\"USD\", \"primaryGenreName\":\"Rock\", \"radioStationUrl\":\"https://itunes.apple.com/station/idra.919600089\"}"
        
        var data = jsonPayload.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        var jsonErrorOptional: NSError?
        var jsonOptional: JSON? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(0), error: &jsonErrorOptional)
        
        XCTAssertTrue(jsonErrorOptional == nil)
        XCTAssertTrue(jsonOptional != nil)
        var jsonDict = asDictionary(jsonOptional!)
        XCTAssertTrue(jsonDict != nil)
        
        var contentOptional = Content.createFromJSON(jsonDict!)
        XCTAssert(contentOptional != nil)
        var content = contentOptional!
        XCTAssertEqual(content.Wrapper, ContentWrapper.Track)
        XCTAssertEqual(content.Kind, ContentKind.Song)
        XCTAssertEqual(content.ArtistId, 487143)
        XCTAssertEqual(content.CollectionId, 919600058)
        XCTAssertEqual(content.TrackId, 919600089)
        XCTAssertEqual(content.ArtistName, "Pink Floyd")
        XCTAssertEqual(content.CollectionName, "The Endless River")
        XCTAssertEqual(content.TrackName, "Side 3, pt. 2: On Noodle Street")
        XCTAssertEqual(content.CollectionCensoredName, "The Endless River")
        XCTAssertEqual(content.TrackCensoredName, "Side 3, pt. 2: On Noodle Street")
        XCTAssertTrue(content.ArtistViewURL.absoluteString == .Some("https://itunes.apple.com/us/artist/pink-floyd/id487143?uo=4"))
        XCTAssertTrue(content.CollectionViewURL.absoluteString == .Some("https://itunes.apple.com/us/album/side-3-pt.-2-on-noodle-street/id919600058?i=919600089&uo=4"))
        XCTAssertTrue(content.TrackViewURL.absoluteString == .Some("https://itunes.apple.com/us/album/side-3-pt.-2-on-noodle-street/id919600058?i=919600089&uo=4"))
        XCTAssertTrue(content.PreviewURL?.absoluteString == .Some("http://a1433.phobos.apple.com/us/r1000/059/Music1/v4/ed/a6/f4/eda6f4f7-dc39-2512-516e-8c12f3bd768f/mzaf_5215809693376416325.plus.aac.p.m4a"))
        XCTAssertTrue(content.ArtworkURL60?.absoluteString == .Some("http://a1.mzstatic.com/us/r30/Music1/v4/63/32/f8/6332f811-527a-0ec3-e3d8-dc1a997b0e3c/dj.jzdkxzku.60x60-50.jpg"))
        XCTAssertTrue(content.ArtworkURL100?.absoluteString == .Some("http://a3.mzstatic.com/us/r30/Music1/v4/63/32/f8/6332f811-527a-0ec3-e3d8-dc1a997b0e3c/dj.jzdkxzku.100x100-75.jpg"))
        XCTAssertEqualWithAccuracy(content.CollectionPrice, 14.99, 0.01)
        XCTAssertEqualWithAccuracy(content.TrackPrice, 1.29, 0.01)
        XCTAssertEqual(content.ReleaseDate, toDateFromString("yyyy-MM-dd'T'HH:mm:ssX", "2014-11-10T08:00:00Z")!)
        XCTAssertEqual(content.CollectionExplicitness, ContentExplicitness.NotExplicit)
        XCTAssertEqual(content.TrackExplicitness, ContentExplicitness.NotExplicit)
        XCTAssertEqual(content.DiscCount, 1)
        XCTAssertEqual(content.DiscNumber, 1)
        XCTAssertEqual(content.TrackCount, 18)
        XCTAssertEqual(content.TrackNumber, 9)
        XCTAssertTrue(content.TrackTimeMillis == .Some(102213))
        XCTAssertEqual(content.Country, "USA")
        XCTAssertEqual(content.Currency, "USD")
        XCTAssertEqual(content.PrimaryGenreName, "Rock")
    }
}
