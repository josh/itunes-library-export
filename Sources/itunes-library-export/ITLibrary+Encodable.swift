import iTunesLibrary

extension ITLibrary: Encodable {
  enum CodingKeys: String, PropertyListCodingKey {
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

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(apiMajorVersion, forKey: .apiMajorVersion)
    try container.encode(apiMinorVersion, forKey: .apiMinorVersion)
    try container.encode(applicationVersion, forKey: .applicationVersion)
    try container.encode(features.rawValue, forKey: .features)
    try container.encode(shouldShowContentRating, forKey: .shouldShowContentRating)
    try container.encodeIfPresent(musicFolderLocation, forKey: .musicFolderLocation)
    try container.encodeIfPresent(mediaFolderLocation, forKey: .mediaFolderLocation)

    var tracksContainer = container.nestedContainer(
      keyedBy: TrackIDCodingKey.self, forKey: .tracks
    )

    for item in allMediaItems {
      try tracksContainer.encode(item, forKey: TrackIDCodingKey(intValue: item.trackID))
    }

    try container.encode(allPlaylists, forKey: .playlists)
  }
}

extension ITLibMediaItem: Encodable {
  enum CodingKeys: String, PropertyListCodingKey {
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

  var trackID: Int { localID(forPersistentID: persistentID) }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(trackID, forKey: .trackID)
    try container.encode(
      String(persistentID.uintValue, radix: 16, uppercase: true),
      forKey: .persistentID
    )

    try container.encodeUnlessEmpty(title, forKey: .title)
    try container.encodeUnlessEmpty(sortTitle, forKey: .sortTitle)
    try container.encodeUnlessEmpty(artist?.name, forKey: .artist)
    try container.encodeUnlessEmpty(artist?.sortName, forKey: .sortArtist)
    try container.encodeUnlessEmpty(album.title, forKey: .album)
    try container.encodeUnlessEmpty(album.sortTitle, forKey: .sortAlbum)
    try container.encodeUnlessEmpty(album.albumArtist, forKey: .albumArtist)
    try container.encodeUnlessEmpty(
      album.sortAlbumArtist, forKey: .sortAlbumArtist
    )
    try container.encodeIfNonZero(album.discNumber, forKey: .discNumber)
    try container.encodeIfNonZero(album.discCount, forKey: .discCount)
    try container.encodeIfNonZero(album.trackCount, forKey: .trackCount)
    try container.encodeUnlessEmpty(composer, forKey: .composer)
    try container.encodeUnlessEmpty(sortComposer, forKey: .sortComposer)

    try container.encodeUnlessEmpty(genre, forKey: .genre)
    try container.encodeUnlessEmpty(kind, forKey: .kind)
    try container.encodeIfNonZero(totalTime, forKey: .totalTime)
    try container.encodeIfNonZero(trackNumber, forKey: .trackNumber)
    try container.encode(hasArtworkAvailable ? 1 : 0, forKey: .artworkCount)

    try container.encodeIfTrue(isPurchased, forKey: .isPurchased)
    try container.encodeUnlessEmpty(contentRating, forKey: .contentRating)
    try container.encodeUnlessEmpty(description, forKey: .description)
    try container.encodeUnlessEmpty(comments, forKey: .comments)
    try container.encodeIfPresent(releaseDate, forKey: .releaseDate)
    try container.encode(year, forKey: .year)
    try container.encodeIfPresent(addedDate, forKey: .addedDate)
    try container.encodeIfPresent(modifiedDate, forKey: .modifiedDate)
    try container.encodeIfNonZero(playCount, forKey: .playCount)
    try container.encodeIfPresent(lastPlayedDate, forKey: .lastPlayedDate)
    try container.encodeIfNonZero(startTime, forKey: .startTime)
    try container.encodeIfNonZero(stopTime, forKey: .stopTime)

    try container.encodeIfNonZero(fileSize, forKey: .fileSize)
    try container.encodeIfNonZero(bitrate, forKey: .bitrate)
    try container.encodeIfNonZero(sampleRate, forKey: .sampleRate)
    try container.encodeIfNonZero(beatsPerMinute, forKey: .beatsPerMinute)
    try container.encodeIfNonZero(volumeAdjustment, forKey: .volumeAdjustment)
    try container.encodeIfNonZero(
      volumeNormalizationEnergy, forKey: .volumeNormalizationEnergy
    )

    try container.encodeIfTrue(isVideo, forKey: .isVideo)
    try container.encodeUnlessEmpty(videoInfo?.series, forKey: .series)
    try container.encodeUnlessEmpty(videoInfo?.sortSeries, forKey: .sortSeries)
    try container.encodeIfNonZero(videoInfo?.season, forKey: .season)
    try container.encodeIfTrue(videoInfo?.isHD, forKey: .isHD)
    try container.encodeUnlessEmpty(videoInfo?.episode, forKey: .episode)
    try container.encodeIfNonZero(videoInfo?.episodeOrder, forKey: .episodeOrder)

    switch mediaKind {
    case .kindMovie:
      try container.encode(true, forKey: .movie)
    case .kindMusicVideo:
      try container.encode(true, forKey: .musicVideo)
    case .kindTVShow:
      try container.encode(true, forKey: .tvShow)
    default:
      ()
    }

    switch locationType {
    case .file:
      try container.encode("File", forKey: .locationType)
    case .remote:
      try container.encode("Remote", forKey: .locationType)
    case .URL:
      try container.encode("URL", forKey: .locationType)
    default:
      ()
    }
  }
}

extension ITLibPlaylist: Encodable {
  enum CodingKeys: String, PropertyListCodingKey {
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

  enum ItemCodingKeys: String, PropertyListCodingKey {
    case trackID

    var plistValue: String {
      switch self {
      case .trackID: return "Track ID"
      }
    }
  }

  var playlistID: Int { localID(forPersistentID: persistentID) }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(playlistID, forKey: .playlistID)
    try container.encodeUnlessEmpty(name, forKey: .name)
    try container.encode(
      String(persistentID.uintValue, radix: 16, uppercase: true),
      forKey: .playlistPersistentID
    )
    try container.encodeIfNonZero(
      distinguishedKind.rawValue, forKey: .distinguishedKind
    )
    try container.encodeIfTrue(isMaster, forKey: .isMaster)
    try container.encodeIfTrue(isVisible, forKey: .isVisible)

    var itemsContainer = container.nestedUnkeyedContainer(forKey: .items)
    for item in items {
      var itemContainer = itemsContainer.nestedContainer(
        keyedBy: ItemCodingKeys.self)
      try itemContainer.encode(item.trackID, forKey: .trackID)
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
