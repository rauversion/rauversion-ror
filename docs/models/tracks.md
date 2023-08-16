# Track Model Documentation

## Overview

The Track model is a central component of our application, responsible for managing and storing all the information related to a music track. This includes details about the track itself, its associated playlists, likes, comments, listening events, purchased items, and attachments.

## Features

### Track Details

Each track has a title, which is used to generate a friendly ID, or slug, for the track. This slug is used in the track's URL, making it more human-readable and SEO-friendly.

### Associations

The Track model has associations with several other models:

- `User`: Each track belongs to a user, who is considered the track's author or uploader.
- `TrackComments`: Tracks have many track comments, allowing users to comment on the track.
- `TrackPlaylists`: Tracks have many track playlists, which are essentially join records between tracks and playlists.
- `Playlists`: Through track playlists, tracks have many playlists. This allows a track to be included in multiple playlists.
- `ListeningEvents`: Tracks have many listening events, which are records of users listening to the track.
- `Reposts`: Tracks have many reposts, allowing users to share the track with their followers.
- `PurchasedItems`: Tracks have many purchased items, which are records of users purchasing the track.
- `Likes`: Tracks have many likes, allowing users to express their enjoyment of the track.
- `Comments`: Tracks have many comments, allowing users to discuss the track.

### Attachments

Tracks have several attachments:

- `Cover`: The cover image for the track.
- `Audio`: The audio file of the track.
- `MP3_Audio`: The MP3 version of the audio file.
- `Zip`: A ZIP file containing the track and any additional files.

### Scopes

The Track model includes several scopes for querying tracks based on their attributes:

- `Published`: Returns all tracks that are not private.
- `Latests`: Returns all tracks, ordered by their ID in descending order.

## Conclusion

The Track model is a robust and flexible component of our application, providing a wide range of features for managing music tracks. Whether you're uploading a track, adding it to a playlist, or interacting with it through likes and comments, the Track model has you covered.