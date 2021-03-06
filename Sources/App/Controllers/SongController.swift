//
//  SongController.swift
//  
//
//  Created by Noah Pikielny on 3/20/22.
//

import Fluent
import Vapor

struct SongController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let songs = routes.grouped("songs")
        songs.get("all", use: getAll)
        songs.get(":songID", use: get)
        
        songs.post(use: create)
        songs.post("populate", use: populate)
        
        songs.put(":songID", use: update)
        
        songs.delete(":songID", use: delete)
    }
    
    func getAll(req: Request) -> EventLoopFuture<[Song]> {
        Song.query(on: req.db).all()
    }
    
    func get(req: Request) throws  -> EventLoopFuture<Song> {
        guard let id: UUID = req.parameters.get("songID") else { throw RouteError.notFound }
        return Song.find(id, on: req.db)
            .unwrap(or: RouteError.notFound)
    }
    
    func create(req: Request) throws -> EventLoopFuture<Song> {
        guard let song = try? req.content.decode(Song.self) else { throw RouteError.unsupportedMediaType }
        guard let _ = song.artist, let _ = song.title, let _ = song.length else { throw RouteError.partialInformation("Route requires, artist, title, and length") }
        return song.save(on: req.db).transform(to: song)
    }
    
    func populate(req: Request) -> EventLoopFuture<HTTPResponseStatus> {
        let pursuitOfHappiness = Song(title: "Pursuit of Happiness", artist: "Kid Cudi", length: 3*60+47)
        let chineseNewYear = Song(title: "Chinese New Year", artist: "SALES", length: 2 * 60 + 40)
        let whiteFerrari = Song(title: "White Ferrari", artist: "Frank Ocean", length: 4 * 60 + 8)
        let aaronSong = Song(title: "Aaron's Song", artist: "Aaron", length: 0)
        let celesteSong = Song(title: "Idk", artist: "Celeste", length: 3)
        
        return [chineseNewYear, whiteFerrari, aaronSong, celesteSong].reduce(pursuitOfHappiness.save(on: req.db)) { result, next in
            result.transform(to: next.save(on: req.db))
        }.transform(to: HTTPResponseStatus.ok)
    }
    
    func update(req: Request) throws -> EventLoopFuture<Song> {
        guard let songInformation = try? req.content.decode(Song.self) else { throw RouteError.unsupportedMediaType }
        guard let id: UUID = req.parameters.get("songID"),
              let artist = songInformation.artist,
              let title = songInformation.title,
              let length: Int = songInformation.length else {
                  throw RouteError.partialInformation("Requires artist: <String>, title: <String>, and length: <Int>")
              }
                
        return Song.query(on: req.db)
            .filter(\.$id == id)
            .filter(\.$artist == artist)
            .first()
            .unwrap(or: RouteError.notFound)
            .flatMap { song in
                song.title = title
                song.length = length
                return song.update(on: req.db).transform(to: song)
            }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<Song> {
        guard let songInformation = try? req.content.decode(Song.self) else { throw RouteError.unsupportedMediaType }
        guard let id: UUID = req.parameters.get("songID"),
              let artist = songInformation.artist else {
                  throw RouteError.partialInformation("Requires artist: <String>")
              }
        
        return Song.query(on: req.db)
            .filter(\.$id == id)
            .filter(\.$artist == artist)
            .first()
            .unwrap(or: RouteError.notFound)
            .flatMap { song in
                song.delete(on: req.db).transform(to: song)
            }
    }
    
}
