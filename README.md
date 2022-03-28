# ios-course-songServer

A simple server in Swift (Fluent & Vapor) for use in AppDev's Intro to iOS Course

## Endpoints

All endpoints use the following `Song` model:
```
{
    id: <UUID?>,
    title: <String?>,
    artist: <String?>
    length: <Int?>
    timeStamp: <Date?>
}
```

Both id and timeStamp are fully managed by the backend.

### Status Codes
200: Success

400: Partial Information – The route was not supplied with enough information (whether parameters or body)

400: Unsupported Media Type – Unable to convert request body into a Song. This usually arises from having no body.

401: Unauthorized

### GET /
Return Type: `String`
Requirements: None
Returns "It works!".

### GET /hello/
Return Type: `String`
Requirements: None
Returns "Hello, world".

### GET /songs/all/
Return Type: `[Song]`
Requirements: None
Returns a list of all songs stored in the database

### GET /songs/{songId}/
Return Type: `Song`
Requirements: 
    - parameter: songId
Returns a song if there is a song in the database where `song.id == songId`

### POST /songs/
Return Type: `Song`
Requirements:
    - body: artist, title, length
Returns the new song

### PUT /songs/{songId}/
Return Type: `Song`
Requirements: 
    - parameters: songId
    - body: artist, title, length
Returns the updated song

### POST /songs/populate/
Return Type: `HTTPResponseStatus`
Requirements: None
Returns: a success code

### DELETE /songs/{songId}/
Return Type: `Song`

