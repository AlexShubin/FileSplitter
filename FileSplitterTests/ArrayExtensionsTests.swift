//
//  Copyright © 2018 Alex Shubin. All rights reserved.
//

import XCTest
@testable import FileSplitter

class ArrayExtensionsTests: XCTestCase {
    
    func testArraySplitter() {
        XCTAssertEqual([11].splitted(chunksCount: 2),
                       [ArraySlice([11])])
        
        XCTAssertEqual([11,2].splitted(chunksCount: 3),
                       [ArraySlice([11]), ArraySlice([2])])
        
        XCTAssertEqual([1,2,3,4,5,6,7].splitted(chunksCount: 2),
                       [ArraySlice([1,2,3,4]), ArraySlice([5,6,7])])
        
        XCTAssertEqual([1,2,3,4,5,6,7].splitted(chunksCount: 3),
                       [ArraySlice([1,2,3]), ArraySlice([4,5,6]), ArraySlice([7])])
        
        XCTAssertEqual([1,2,3,4,5,6,7,8].splitted(chunksCount: 2),
                       [ArraySlice([1,2,3,4]), ArraySlice([5,6,7,8])])
        
        XCTAssertEqual([1,2,3,4,5,6,7,8].splitted(chunksCount: 3),
                       [ArraySlice([1,2,3]), ArraySlice([4,5,6]), ArraySlice([7,8])])
    }
}
