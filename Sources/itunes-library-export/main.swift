import Darwin
import Foundation

let commandName = "itunes-library-export"

enum Format: String {
    case plist
    case json
    case xml
}

var format: Format = .xml

for (index, argument) in CommandLine.arguments.enumerated() {
    guard argument.hasPrefix("-") else { continue }

    switch argument {
    case "-h", "--help":
        let message = """
        USAGE: \(commandName) [--format <format>]

        OPTIONS:
          -f, --format <format>   The output format. (default: xml)
          -h, --help              Show help information.

        """
        print(message)
        exit(0)
    case "-f", "--format":
        let rawValue = CommandLine.arguments[index + 1]
        if let value = Format(rawValue: rawValue) {
            format = value
        } else {
            let message = """
            Error: The value '\(rawValue)' is invalid for '--format <format>'
            Help:  --format <format>  The output format.
            Usage: \(commandName) [--format <format>]
              See '\(commandName) --help' for more information.

            """
            fputs(message, stderr)
            exit(1)
        }

    default:
        let message = """
        Error: Unknown option '\(argument)'
        Usage: \(commandName) [--format <format>]
          See '\(commandName) --help' for more information.

        """
        fputs(message, stderr)
        exit(1)
    }
}

switch format {
case .plist:
    let encoder = PropertyListEncoder()
    encoder.outputFormat = .binary
    usePlistCodingKeys = true
    let data = try encoder.encode(EncodableLibrary())
    FileHandle.standardOutput.write(data)
case .xml:
    let encoder = PropertyListEncoder()
    encoder.outputFormat = .xml
    usePlistCodingKeys = true
    let data = try encoder.encode(EncodableLibrary())
    FileHandle.standardOutput.write(data)
case .json:
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    let data = try encoder.encode(EncodableLibrary())
    FileHandle.standardOutput.write(data)
}
