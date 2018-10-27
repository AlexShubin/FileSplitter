//
//  Copyright © 2018 Alex Shubin. All rights reserved.
//

import Foundation

enum FileSplitterError: String, Error {
    case readFileError
    case writeFileError
}

struct FileSplitter {
    
    func split(flieUrl: URL,
               chunksCount: Int,
               completion: @escaping ((Result<Void, FileSplitterError>) -> Void)) {
        
        guard let fileData = try? String(contentsOfFile: flieUrl.path, encoding: .utf8) else {
            DispatchQueue.main.async {
                completion(.error(.readFileError))
            }
            return
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
                DispatchQueue.main.async {
                    completion(.error(.writeFileError))
                }
                return
            }
        }
        DispatchQueue.main.async {
            completion(.success(()))
        }
    }
}
