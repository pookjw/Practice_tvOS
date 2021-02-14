//
//  Movie.swift
//  TopShelfExtension
//
//  Created by Jinwoo Kim on 2/14/21.
//

import Foundation

struct Movie: Codable {
    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case title
        case releaseDate = "releasedAt"
        case summary
        case genre
        case duration
        case mediaFormats
        case featuredActors
        case featuredDirectors
        case imageName
        case previewVideoName
    }
    
    enum MediaFormat: String, Codable {
        case videoResolutionHD = "hd"
        case videoResolution4K = "4k"
        case videoColorSpaceHDR = "hdr"
        case videoColorSpaceDolbyVision = "dolby-vision"
        case audioDolbyAtmos = "dolby-atmos"
        case audioTranscriptionClosedCaptioning = "cc"
        case audioTranscriptionSDH = "sdh"
        case audioDescription = "ad"
    }
    
    var identifier: String
    var title: String
    var releaseDate: Date
    var summary: String
    var genre: String
    var duration: TimeInterval
    var mediaFormats: Set<MediaFormat>?
    var featuredActors: [String]?
    var featuredDirectors: [String]?
    var imageName: String
    var previewVideoName: String
    
    func imageURL(withScale scale: Int) -> URL? {
        precondition(scale > 0)
        return Bundle.main.url(forResource: imageName, withExtension: "jpg")
    }
    
    var previewVideoURL: URL? {
        return Bundle.main.url(forResource: previewVideoName, withExtension: "mp4")
    }
}
