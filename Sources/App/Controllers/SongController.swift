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
        
        songs.put(":songID", use: update)
        
        songs.delete(":songID", use: delete)
    }
    
    func getAll(req: Request) -> EventLoopFuture<[Song]> {
        Song.query(on: req.db).all()
    }
    
    func get(req: Request) throws  -> EventLoopFuture<Song> {
        guard let id: UUID = req.parameters.get("songID") else {
            throw Abort(.partialContent)
        }
        return Song.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    func create(req: Request) throws -> EventLoopFuture<Song> {
        let song = try req.content.decode(Song.self)
        return song.save(on: req.db).transform(to: song)
    }
    
    func update(req: Request) throws -> EventLoopFuture<Song> {
        guard let songInformation = try? req.content.decode(Song.self) else { throw Abort(.unprocessableEntity) }
        guard let id: UUID = req.parameters.get("songID"),
              let artist = songInformation.artist,
              let title = req.parameters.get("title"),
              let length: Int = req.parameters.get("length") else { throw Abort(.partialContent) }
                
        return Song.query(on: req.db)
            .filter(\.$id == id)
            .filter(\.$artist == artist)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { song in
                song.title = title
                song.length = length
                return song.update(on: req.db).transform(to: song)
            }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<Song> {
        guard let songInformation = try? req.content.decode(Song.self) else { throw Abort(.unprocessableEntity) }
        guard let id: UUID = req.parameters.get("songID"),
              let artist = songInformation.artist else { throw Abort(.partialContent) }
        
        return Song.query(on: req.db)
            .filter(\.$id == id)
            .filter(\.$artist == artist)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { song in
                song.delete(on: req.db).transform(to: song)
            }
    }
    
}
