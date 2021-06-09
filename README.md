# itunes-library-export

A command line tool to export, [the now deprecated](https://www.theverge.com/2019/10/7/20903391/apple-macos-catalina-itunes-dj-software-breaks-xml-file-support-removal-update), iTunes Library XML files.

## Usage

Generate the XML Plist format.

```
$ itunes-library-export > "~/Music/iTunes/iTunes Music Library.xml"
```

Alternatively, JSON can also be outputed.

```
$ itunes-library-export --format json > "~/Music/iTunes/iTunes Music Library.json"
```

## Installation

Install with Homebrew.

```
$ brew install josh/tap/itunes-library-export
```

Build from source.

```
$ git clone https://github.com/josh/itunes-library-export
$ cd itunes-library-export
$ swift build -c release
$ cp -f .build/release/itunes-library-export /usr/local/bin/itunes-library-export
```
