import ArgumentParser
import Foundation

struct iTunesLibraryExport: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "itunes-library-export")

    enum Format: String, ExpressibleByArgument {
        case plist
        case json
        case xml
    }

    @Option(name: [.short, .long], help: "The output format.")
    var format: Format = .xml

    func run() throws {
        var data: Data
        switch format {
        case .plist:
            let encoder = PropertyListEncoder()
            encoder.outputFormat = .binary
            usePlistCodingKeys = true
            data = try encoder.encode(EncodableLibrary())
        case .xml:
            let encoder = PropertyListEncoder()
            encoder.outputFormat = .xml
            usePlistCodingKeys = true
            data = try encoder.encode(EncodableLibrary())
        case .json:
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            data = try encoder.encode(EncodableLibrary())
        }
        FileHandle.standardOutput.write(data)
    }
}

iTunesLibraryExport.main()
