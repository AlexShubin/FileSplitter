//
//  Copyright © 2018 Alex Shubin. All rights reserved.
//

public enum Result<T, E: Error> {
    case success(T)
    case error(E)
}
