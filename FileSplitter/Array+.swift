//
//  Copyright © 2018 Alex Shubin. All rights reserved.
//

import Foundation

extension Array {
    func chunked(by chunksCount: Int) -> [ArraySlice<Element>] {
        assert(chunksCount > 1)
        let chunkSize = count / chunksCount + count % chunksCount
        return stride(from: 0, to: count, by: chunkSize).map {
            self[$0..<Swift.min($0 + chunkSize, self.count)]
        }
    }
}
