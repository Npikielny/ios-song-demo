//
//  CreateSong.swift
//  
//
//  Created by Noah Pikielny on 3/20/22.
//

import FluentKit

struct CreateSong: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Song.schema)
            .id()
            .field("title", .string, .required)
            .field("artist", .string, .required)
            .field("length", .int, .required)
            .field("timeStamp", .datetime, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Song.schema).delete()
    }
}
