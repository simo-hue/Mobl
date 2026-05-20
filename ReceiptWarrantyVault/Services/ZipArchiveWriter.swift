import Foundation

struct ZipArchiveWriter {
    struct Entry {
        let path: String
        let data: Data
    }

    func write(entries: [Entry], to destinationURL: URL) throws {
        var archive = Data()
        var centralDirectory = Data()
        var localHeaderOffsets: [UInt32] = []

        for entry in entries {
            let nameData = Data(entry.path.utf8)
            let crc = CRC32.checksum(entry.data)
            let offset = UInt32(archive.count)
            localHeaderOffsets.append(offset)

            archive.appendUInt32LE(0x04034b50)
            archive.appendUInt16LE(20)
            archive.appendUInt16LE(0)
            archive.appendUInt16LE(0)
            archive.appendUInt16LE(0)
            archive.appendUInt16LE(0)
            archive.appendUInt32LE(crc)
            archive.appendUInt32LE(UInt32(entry.data.count))
            archive.appendUInt32LE(UInt32(entry.data.count))
            archive.appendUInt16LE(UInt16(nameData.count))
            archive.appendUInt16LE(0)
            archive.append(nameData)
            archive.append(entry.data)
        }

        for (index, entry) in entries.enumerated() {
            let nameData = Data(entry.path.utf8)
            let crc = CRC32.checksum(entry.data)

            centralDirectory.appendUInt32LE(0x02014b50)
            centralDirectory.appendUInt16LE(20)
            centralDirectory.appendUInt16LE(20)
            centralDirectory.appendUInt16LE(0)
            centralDirectory.appendUInt16LE(0)
            centralDirectory.appendUInt16LE(0)
            centralDirectory.appendUInt16LE(0)
            centralDirectory.appendUInt32LE(crc)
            centralDirectory.appendUInt32LE(UInt32(entry.data.count))
            centralDirectory.appendUInt32LE(UInt32(entry.data.count))
            centralDirectory.appendUInt16LE(UInt16(nameData.count))
            centralDirectory.appendUInt16LE(0)
            centralDirectory.appendUInt16LE(0)
            centralDirectory.appendUInt16LE(0)
            centralDirectory.appendUInt16LE(0)
            centralDirectory.appendUInt32LE(0)
            centralDirectory.appendUInt32LE(localHeaderOffsets[index])
            centralDirectory.append(nameData)
        }

        let centralDirectoryOffset = UInt32(archive.count)
        let centralDirectorySize = UInt32(centralDirectory.count)
        archive.append(centralDirectory)

        archive.appendUInt32LE(0x06054b50)
        archive.appendUInt16LE(0)
        archive.appendUInt16LE(0)
        archive.appendUInt16LE(UInt16(entries.count))
        archive.appendUInt16LE(UInt16(entries.count))
        archive.appendUInt32LE(centralDirectorySize)
        archive.appendUInt32LE(centralDirectoryOffset)
        archive.appendUInt16LE(0)

        try archive.write(to: destinationURL, options: [.atomic])
    }
}

private enum CRC32 {
    static func checksum(_ data: Data) -> UInt32 {
        var crc: UInt32 = 0xffffffff

        for byte in data {
            var current = (crc ^ UInt32(byte)) & 0xff
            for _ in 0..<8 {
                if current & 1 == 1 {
                    current = (current >> 1) ^ 0xedb88320
                } else {
                    current >>= 1
                }
            }
            crc = (crc >> 8) ^ current
        }

        return crc ^ 0xffffffff
    }
}

private extension Data {
    mutating func appendUInt16LE(_ value: UInt16) {
        var littleEndian = value.littleEndian
        Swift.withUnsafeBytes(of: &littleEndian) { append(contentsOf: $0) }
    }

    mutating func appendUInt32LE(_ value: UInt32) {
        var littleEndian = value.littleEndian
        Swift.withUnsafeBytes(of: &littleEndian) { append(contentsOf: $0) }
    }
}
