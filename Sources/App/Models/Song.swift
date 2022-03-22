//
//  Song.swift
//  
//
//  Created by Noah Pikielny on 3/20/22.
//

import Fluent
import Vapor

final class Song: Model, Content {
    static var schema = "songs"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String?
    
    @Field(key: "artist")
    var artist: String?
    
    @Field(key: "length")
    var length: Int?
    
    @Timestamp(key: "timeStamp", on: .create, format: .default)
    var timeStamp: Date?
    
    init() {}
    
    init(id: UUID? = nil, title: String, artist: String, length: Int, timeStamp: Date? = nil) {
        self.id = id
        self.title = title
        self.artist = artist
        self.length = length
        self.timeStamp = timeStamp
    }
}
