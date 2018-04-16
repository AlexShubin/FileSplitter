//
//  Copyright © 2018 Alex Shubin. All rights reserved.
//

import Foundation

extension Array {
    func splitted(chunksCount: Int) -> [SubSequence] {
        guard chunksCount > 1, count > 1 else {
            return [ArraySlice(self)]
        }
        let chunkSize = count / chunksCount + (count % chunksCount > 0 ? 1 : 0)
        return stride(from: 0, to: count, by: chunkSize).map {
            self[$0..<Swift.min($0 + chunkSize, count)]
        }
    }
}
