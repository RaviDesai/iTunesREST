//
//  Content.swift
//  iTunesREST
//
//  Created by Ravi Desai on 12/2/14.
//  Copyright (c) 2014 RSD. All rights reserved.
//

import Foundation

public enum ContentWrapper : String {
    case Track = "track"
    case Collection = "collection"
    case Artist = "artist"
}

public enum ContentKind : String {
    case Book = "book"
    case Album = "album"
    case CoachedAudio = "coached-audio"
    case FeatureMovie = "feature-movie"
    case InteractiveBooklet = "interactive-booklet"
    case MusicVideo = "music-video"
    case PDF = "pdf"
    case Podcast = "podcast"
    case PodcastEpisode = "podcast-episode"
    case SoftwarePackage = "software-package"
    case Song = "song"
    case TVEpisode = "tv-episode"
    case Artist = "artist"
}

public enum ContentExplicitness : String {
    case Explicit = "explicit"
    case Cleaned = "cleaned"
    case NotExplicit = "notExplicit"
}

func asContentWrapper(object: JSON) -> ContentWrapper? {
    if let str = object as? String {
        return ContentWrapper(rawValue: str)
    }
    return nil
}

func asContentKind(object: JSON) -> ContentKind? {
    if let str = object as? String {
        return ContentKind(rawValue: str)
    }
    return nil
}

func asContentExplicitness(object: JSON) -> ContentExplicitness? {
    if let str = object as? String {
        return ContentExplicitness(rawValue: str)
    }
    return nil
}

public struct Content {
    public var Wrapper : ContentWrapper
    public var Kind : ContentKind
    public var ArtistId : Int
    public var CollectionId : Int
    public var TrackId : Int
    public var ArtistName : String
    public var CollectionName : String
    public var TrackName : String
    public var CollectionCensoredName : String
    public var TrackCensoredName : String
    public var ArtistViewURL : NSURL
    public var CollectionViewURL : NSURL
    public var TrackViewURL : NSURL
    public var PreviewURL : NSURL?
    public var ArtworkURL60 : NSURL?
    public var ArtworkURL100 : NSURL?
    public var CollectionPrice : Double
    public var TrackPrice : Double
    public var CollectionExplicitness : ContentExplicitness
    public var TrackExplicitness : ContentExplicitness
    public var DiscCount : Int
    public var TrackCount : Int
    public var DiscNumber : Int
    public var TrackNumber : Int
    public var TrackTimeMillis : Int?
    public var Country : String
    public var Currency : String
    public var PrimaryGenreName : String
    public var ReleaseDate : NSDate
    
    public init(wrapper: ContentWrapper, kind: ContentKind, artistId: Int, collectionId: Int, trackId: Int, artistName: String, collectionName: String, trackName: String, collectionCensoredName: String, trackCensoredName: String, artistViewURL: NSURL, collectionViewURL: NSURL, trackViewURL: NSURL, previewURL: NSURL?, artworkURL60: NSURL?, artworkURL100: NSURL?, collectionPrice: Double, trackPrice: Double, collectionExplicitness: ContentExplicitness, trackExplicitness: ContentExplicitness, discCount: Int, trackCount: Int, discNumber: Int, trackNumber: Int, trackTimeMillis: Int?, country: String, currency: String, primaryGenreName: String, releaseDate: NSDate) {
        self.Wrapper = wrapper
        self.Kind = kind
        self.ArtistId = artistId
        self.CollectionId = collectionId
        self.TrackId = trackId
        self.ArtistName = artistName
        self.CollectionName = collectionName
        self.TrackName = trackName
        self.CollectionCensoredName = collectionCensoredName
        self.TrackCensoredName = trackCensoredName
        self.ArtistViewURL = artistViewURL
        self.CollectionViewURL = collectionViewURL
        self.TrackViewURL = trackViewURL
        self.PreviewURL = previewURL
        self.ArtworkURL60 = artworkURL60
        self.ArtworkURL100 = artworkURL100
        self.CollectionPrice = collectionPrice
        self.TrackPrice = trackPrice
        self.CollectionExplicitness = collectionExplicitness
        self.TrackExplicitness = trackExplicitness
        self.DiscCount = discCount
        self.TrackCount = trackCount
        self.DiscNumber = discNumber
        self.TrackNumber = trackNumber
        self.TrackTimeMillis = trackTimeMillis
        self.Country = country
        self.Currency = currency
        self.PrimaryGenreName = primaryGenreName
        self.ReleaseDate = releaseDate
    }
    
    public static func create(wrapper: ContentWrapper)(kind: ContentKind)(artistId: Int)(collectionId: Int)
        (trackId: Int)(artistName: String)(collectionName: String)(trackName: String)(collectionCensoredName: String)(trackCensoredName: String)(artistViewURL: NSURL)(collectionViewURL: NSURL)(trackViewURL: NSURL)(previewURL: NSURL?)(artworkURL60: NSURL?)(artworkURL100: NSURL?)(collectionPrice: Double)(trackPrice: Double)(collectionExplicitness: ContentExplicitness)(trackExplicitness: ContentExplicitness)(discCount: Int)(trackCount: Int)(discNumber:Int)(trackNumber: Int)(trackTimeMillis: Int?)(country: String)(currency: String)(primaryGenreName: String)(releaseDate: NSDate) -> Content {
            return Content(wrapper: wrapper, kind: kind, artistId: artistId, collectionId: collectionId, trackId: trackId, artistName: artistName, collectionName: collectionName, trackName: trackName, collectionCensoredName: collectionCensoredName, trackCensoredName: trackCensoredName, artistViewURL: artistViewURL, collectionViewURL: collectionViewURL, trackViewURL: trackViewURL, previewURL: previewURL, artworkURL60: artworkURL60, artworkURL100: artworkURL100, collectionPrice: collectionPrice, trackPrice: trackPrice, collectionExplicitness: collectionExplicitness, trackExplicitness: trackExplicitness, discCount: discCount, trackCount: trackCount, discNumber: discNumber, trackNumber: trackNumber, trackTimeMillis: trackTimeMillis, country: country, currency: currency, primaryGenreName: primaryGenreName, releaseDate: releaseDate)
    }

    public static func createFromJSON(json: JSON) -> Content? {
        if let record = json as? JSONDictionary {
            return Content.create
                <*> record["wrapperType"] >>- asContentWrapper
                <*> record["kind"] >>- asContentKind
                <*> record["artistId"] >>- asInt
                <*> record["collectionId"] >>- asInt
                <*> record["trackId"] >>- asInt
                <*> record["artistName"] >>- asString
                <*> record["collectionName"] >>- asString
                <*> record["trackName"] >>- asString
                <*> record["collectionCensoredName"] >>- asString
                <*> record["trackCensoredName"] >>- asString
                <*> record["artistViewUrl"] >>- asUrl
                <*> record["collectionViewUrl"] >>- asUrl
                <*> record["trackViewUrl"] >>- asUrl
                <**> record["previewUrl"] >>- asUrl
                <**> record["artworkUrl60"] >>- asUrl
                <**> record["artworkUrl100"] >>- asUrl
                <*> record["collectionPrice"] >>- asDouble
                <*> record["trackPrice"] >>- asDouble
                <*> record["collectionExplicitness"] >>- asContentExplicitness
                <*> record["trackExplicitness"] >>- asContentExplicitness
                <*> record["discCount"] >>- asInt
                <*> record["trackCount"] >>- asInt
                <*> record["discNumber"] >>- asInt
                <*> record["trackNumber"] >>- asInt
                <**> record["trackTimeMillis"] >>- asInt
                <*> record["country"] >>- asString
                <*> record["currency"] >>- asString
                <*> record["primaryGenreName"] >>- asString
                <*> record["releaseDate"] >>- asDate("yyyy-MM-dd'T'HH:mm:ssX")
        }
        return nil
    }

    public static func createFromJSONArray(json: JSONArray) -> [Content] {
        return json.map {
            Content.createFromJSON($0)
        }.filter{
            $0 != nil
        }.map{
            $0!
        }
    }

}

