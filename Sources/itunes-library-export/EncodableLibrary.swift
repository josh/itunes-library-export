import iTunesLibrary

struct EncodableLibrary: Encodable {
    func encode(to encoder: Encoder) throws {
        let library = try ITLibrary(apiVersion: "1.1")

        var libraryContainer = encoder.container(keyedBy: LibraryCodingKeys.self)

        try libraryContainer.encode(library.apiMajorVersion, forKey: .apiMajorVersion)
        try libraryContainer.encode(library.apiMinorVersion, forKey: .apiMinorVersion)
        try libraryContainer.encode(library.applicationVersion, forKey: .applicationVersion)
        try libraryContainer.encode(library.features.rawValue, forKey: .features)
        try libraryContainer.encode(library.shouldShowContentRating, forKey: .shouldShowContentRating)
        try libraryContainer.encodeIfPresent(library.musicFolderLocation, forKey: .musicFolderLocation)
        try libraryContainer.encodeIfPresent(library.mediaFolderLocation, forKey: .mediaFolderLocation)

        var tracksContainer = libraryContainer.nestedContainer(
            keyedBy: TrackIDCodingKey.self, forKey: .tracks
        )

        for item in library.allMediaItems {
            let trackID = localID(forPersistentID: item.persistentID)
            var trackContainer = tracksContainer.nestedContainer(
                keyedBy: TrackCodingKeys.self, forKey: TrackIDCodingKey(intValue: trackID)
            )

            try trackContainer.encode(trackID, forKey: .trackID)
            try trackContainer.encode(
                String(item.persistentID.uintValue, radix: 16, uppercase: true),
                forKey: .persistentID
            )

            try trackContainer.encodeUnlessEmpty(item.title, forKey: .title)
            try trackContainer.encodeUnlessEmpty(item.sortTitle, forKey: .sortTitle)
            try trackContainer.encodeUnlessEmpty(item.artist?.name, forKey: .artist)
            try trackContainer.encodeUnlessEmpty(item.artist?.sortName, forKey: .sortArtist)
            try trackContainer.encodeUnlessEmpty(item.album.title, forKey: .album)
            try trackContainer.encodeUnlessEmpty(item.album.sortTitle, forKey: .sortAlbum)
            try trackContainer.encodeUnlessEmpty(item.album.albumArtist, forKey: .albumArtist)
            try trackContainer.encodeUnlessEmpty(
                item.album.sortAlbumArtist, forKey: .sortAlbumArtist
            )
            try trackContainer.encodeIfNonZero(item.album.discNumber, forKey: .discNumber)
            try trackContainer.encodeIfNonZero(item.album.discCount, forKey: .discCount)
            try trackContainer.encodeIfNonZero(item.album.trackCount, forKey: .trackCount)
            try trackContainer.encodeUnlessEmpty(item.composer, forKey: .composer)
            try trackContainer.encodeUnlessEmpty(item.sortComposer, forKey: .sortComposer)

            try trackContainer.encodeUnlessEmpty(item.genre, forKey: .genre)
            try trackContainer.encodeUnlessEmpty(item.kind, forKey: .kind)
            try trackContainer.encodeIfNonZero(item.totalTime, forKey: .totalTime)
            try trackContainer.encodeIfNonZero(item.trackNumber, forKey: .trackNumber)
            try trackContainer.encode(item.hasArtworkAvailable ? 1 : 0, forKey: .artworkCount)

            try trackContainer.encodeIfTrue(item.isPurchased, forKey: .isPurchased)
            try trackContainer.encodeUnlessEmpty(item.contentRating, forKey: .contentRating)
            try trackContainer.encodeUnlessEmpty(item.description, forKey: .description)
            try trackContainer.encodeUnlessEmpty(item.comments, forKey: .comments)
            try trackContainer.encodeIfPresent(item.releaseDate, forKey: .releaseDate)
            try trackContainer.encode(item.year, forKey: .year)
            try trackContainer.encodeIfPresent(item.addedDate, forKey: .addedDate)
            try trackContainer.encodeIfPresent(item.modifiedDate, forKey: .modifiedDate)
            try trackContainer.encodeIfNonZero(item.playCount, forKey: .playCount)
            try trackContainer.encodeIfPresent(item.lastPlayedDate, forKey: .lastPlayedDate)
            try trackContainer.encodeIfNonZero(item.startTime, forKey: .startTime)
            try trackContainer.encodeIfNonZero(item.stopTime, forKey: .stopTime)

            try trackContainer.encodeIfNonZero(item.fileSize, forKey: .fileSize)
            try trackContainer.encodeIfNonZero(item.bitrate, forKey: .bitrate)
            try trackContainer.encodeIfNonZero(item.sampleRate, forKey: .sampleRate)
            try trackContainer.encodeIfNonZero(item.beatsPerMinute, forKey: .beatsPerMinute)
            try trackContainer.encodeIfNonZero(item.volumeAdjustment, forKey: .volumeAdjustment)
            try trackContainer.encodeIfNonZero(
                item.volumeNormalizationEnergy, forKey: .volumeNormalizationEnergy
            )

            try trackContainer.encodeIfTrue(item.isVideo, forKey: .isVideo)
            try trackContainer.encodeUnlessEmpty(item.videoInfo?.series, forKey: .series)
            try trackContainer.encodeUnlessEmpty(item.videoInfo?.sortSeries, forKey: .sortSeries)
            try trackContainer.encodeIfNonZero(item.videoInfo?.season, forKey: .season)
            try trackContainer.encodeIfTrue(item.videoInfo?.isHD, forKey: .isHD)
            try trackContainer.encodeUnlessEmpty(item.videoInfo?.episode, forKey: .episode)
            try trackContainer.encodeIfNonZero(item.videoInfo?.episodeOrder, forKey: .episodeOrder)

            switch item.mediaKind {
            case .kindMovie:
                try trackContainer.encode(true, forKey: .movie)
            case .kindMusicVideo:
                try trackContainer.encode(true, forKey: .musicVideo)
            case .kindTVShow:
                try trackContainer.encode(true, forKey: .tvShow)
            default:
                ()
            }

            switch item.locationType {
            case .file:
                try trackContainer.encode("File", forKey: .locationType)
            case .remote:
                try trackContainer.encode("Remote", forKey: .locationType)
            case .URL:
                try trackContainer.encode("URL", forKey: .locationType)
            default:
                ()
            }
        }

        var playslistsContainer = libraryContainer.nestedUnkeyedContainer(forKey: .playlists)

        for playlist in library.allPlaylists {
            let playlistID = localID(forPersistentID: playlist.persistentID)
            var playlistContainer = playslistsContainer.nestedContainer(keyedBy: PlaylistCodingKeys.self)

            try playlistContainer.encode(playlistID, forKey: .playlistID)
            try playlistContainer.encodeUnlessEmpty(playlist.name, forKey: .name)
            try playlistContainer.encode(
                String(playlist.persistentID.uintValue, radix: 16, uppercase: true),
                forKey: .playlistPersistentID
            )
            try playlistContainer.encodeIfNonZero(
                playlist.distinguishedKind.rawValue, forKey: .distinguishedKind
            )
            try playlistContainer.encodeIfTrue(playlist.isMaster, forKey: .isMaster)
            try playlistContainer.encodeIfTrue(playlist.isVisible, forKey: .isVisible)

            var playlistItemsContainer = playlistContainer.nestedUnkeyedContainer(forKey: .items)
            for item in playlist.items {
                var playlistItemContainer = playlistItemsContainer.nestedContainer(
                    keyedBy: PlaylistItemCodingKeys.self)

                let trackID = localID(forPersistentID: item.persistentID)
                try playlistItemContainer.encode(trackID, forKey: .trackID)
            }
        }
    }
}

var usePlistCodingKeys = false

protocol PropertyListCodingKey: CodingKey {
    var rawValue: String { get }
    var plistValue: String { get }
}

extension PropertyListCodingKey {
    var stringValue: String {
        usePlistCodingKeys ? plistValue : rawValue
    }
}

enum LibraryCodingKeys: String, PropertyListCodingKey {
    case apiMajorVersion
    case apiMinorVersion
    case applicationVersion
    case date
    case features
    case shouldShowContentRating
    case musicFolderLocation
    case mediaFolderLocation
    case libraryPersistentID
    case tracks
    case playlists

    var plistValue: String {
        switch self {
        case .apiMajorVersion: return "Major Version"
        case .apiMinorVersion: return "Minor Version"
        case .applicationVersion: return "Application Version"
        case .date: return "Date"
        case .features: return "Features"
        case .shouldShowContentRating: return "Show Content Ratings"
        case .musicFolderLocation: return "Music Folder"
        case .mediaFolderLocation: return "Media Folder"
        case .libraryPersistentID: return "Library Persistent ID"
        case .tracks: return "Tracks"
        case .playlists: return "Playlists"
        }
    }
}

struct TrackIDCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init(stringValue: String) {
        self.stringValue = stringValue
    }

    init(intValue: Int) {
        self.intValue = intValue
        stringValue = "\(intValue)"
    }
}

enum TrackCodingKeys: String, PropertyListCodingKey {
    case trackID
    case persistentID

    case title
    case sortTitle
    case composer
    case sortComposer
    case startTime
    case stopTime
    case genre
    case kind
    case totalTime
    case trackNumber
    case description
    case contentRating
    case addedDate
    case modifiedDate
    case bitrate
    case sampleRate
    case beatsPerMinute
    case playCount
    case lastPlayedDate
    case locationType
    case artworkCount
    case comments
    case isPurchased
    case releaseDate
    case year
    case skipCount
    case skipDate
    case volumeAdjustment
    case volumeNormalizationEnergy
    case fileSize

    case artist
    case sortArtist

    case album
    case sortAlbum
    case trackCount
    case discNumber
    case discCount
    case albumArtist
    case sortAlbumArtist

    case isVideo
    case series
    case sortSeries
    case season
    case isHD
    case episode
    case episodeOrder

    case movie
    case musicVideo
    case tvShow

    var plistValue: String {
        switch self {
        case .addedDate: return "Date Added"
        case .album: return "Album"
        case .albumArtist: return "Album Artist"
        case .artist: return "Artist"
        case .artworkCount: return "Artwork Count"
        case .beatsPerMinute: return "BPM"
        case .bitrate: return "Bit Rate"
        case .comments: return "Comments"
        case .composer: return "Composer"
        case .contentRating: return "Content Rating"
        case .description: return "Description"
        case .discCount: return "Disc Count"
        case .discNumber: return "Disc Number"
        case .episode: return "Episode"
        case .episodeOrder: return "Episode Order"
        case .fileSize: return "Size"
        case .genre: return "Genre"
        case .isHD: return "HD"
        case .isPurchased: return "Purchased"
        case .isVideo: return "Has Video"
        case .kind: return "Kind"
        case .lastPlayedDate: return "Play Date UTC"
        case .locationType: return "Track Type"
        case .modifiedDate: return "Date Modified"
        case .movie: return "Movie"
        case .musicVideo: return "Music Video"
        case .persistentID: return "Persistent ID"
        case .playCount: return "Play Count"
        case .releaseDate: return "Release Date"
        case .sampleRate: return "Sample Rate"
        case .season: return "Season"
        case .series: return "Series"
        case .skipCount: return "Skip Count"
        case .skipDate: return "Skip Date"
        case .sortAlbum: return "Sort Album"
        case .sortAlbumArtist: return "Sort Album Artist"
        case .sortArtist: return "Sort Artist"
        case .sortComposer: return "Sort Composer"
        case .sortSeries: return "Sort Series"
        case .sortTitle: return "Sort Name"
        case .startTime: return "Start Time"
        case .stopTime: return "Stop Time"
        case .title: return "Name"
        case .totalTime: return "Total Time"
        case .trackCount: return "Track Count"
        case .trackID: return "Track ID"
        case .trackNumber: return "Track Number"
        case .tvShow: return "TV Show"
        case .volumeAdjustment: return "Volume Adjustment"
        case .volumeNormalizationEnergy: return "Normalization"
        case .year: return "Year"
        }
    }
}

enum PlaylistCodingKeys: String, PropertyListCodingKey {
    case name
    case playlistID
    case playlistPersistentID
    case distinguishedKind
    case isMaster
    case isVisible
    case items

    var plistValue: String {
        switch self {
        case .name: return "Name"
        case .playlistID: return "Playlist ID"
        case .playlistPersistentID: return "Playlist Persistent ID"
        case .distinguishedKind: return "Distinguished Kind"
        case .isMaster: return "Master"
        case .isVisible: return "Visible"
        case .items: return "Playlist Items"
        }
    }
}

enum PlaylistItemCodingKeys: String, PropertyListCodingKey {
    case trackID

    var plistValue: String {
        switch self {
        case .trackID: return "Track ID"
        }
    }
}

var lastLocalID = 0
var persistentToLocal: [NSNumber: Int] = [:]

func localID(forPersistentID persistentID: NSNumber) -> Int {
    if let id = persistentToLocal[persistentID] {
        return id
    } else {
        lastLocalID += 1
        persistentToLocal[persistentID] = lastLocalID
        return lastLocalID
    }
}

extension KeyedEncodingContainer {
    mutating func encodeUnlessEmpty(_ value: String?, forKey key: KeyedEncodingContainer<K>.Key)
        throws
    {
        guard let value = value else { return }
        guard !value.isEmpty else { return }
        try encode(value, forKey: key)
    }

    mutating func encodeIfNonZero<T: BinaryInteger & Encodable>(
        _ value: T?, forKey key: KeyedEncodingContainer<K>.Key
    ) throws {
        guard let value = value else { return }
        guard value > 0 else { return }
        try encode(value, forKey: key)
    }

    mutating func encodeIfTrue(_ value: Bool?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        guard let value = value else { return }
        guard value == true else { return }
        try encode(true, forKey: key)
    }
}
