//
//  Copyright © 2018 Alex Shubin. All rights reserved.
//

import Foundation

protocol FileSplitterType {
    func split(flieUrl: URL, chunksCount: Int) -> Result<Void, FileSplitterError>
}

enum FileSplitterError: String, Error {
    case readFileError, writeFileError
}

struct FileSplitter: FileSplitterType {
    func split(flieUrl: URL, chunksCount: Int) -> Result<Void, FileSplitterError> {
        guard let fileData = try? String(contentsOfFile: flieUrl.path, encoding: .utf8) else {
            return .failure(.readFileError)
        }
        let fileStrings = fileData.components(separatedBy: .newlines).filter { !$0.isEmpty }
        let stringsToWrite = fileStrings.splitted(chunksCount: chunksCount).map {
            $0.joined(separator: "\n")
        }
        let dirPath = flieUrl.deletingLastPathComponent()
        let fileName = flieUrl.deletingPathExtension().lastPathComponent
        let fileExt = flieUrl.pathExtension
        for (i, str) in stringsToWrite.enumerated() {
            let newFile = dirPath
                .appendingPathComponent("\(fileName)_\(i+1)")
                .appendingPathExtension(fileExt)
            do {
                try str.write(to: newFile, atomically: true, encoding: .utf8)
            } catch {
                return .failure(.writeFileError)
            }
        }
        return .success(())
    }
}
