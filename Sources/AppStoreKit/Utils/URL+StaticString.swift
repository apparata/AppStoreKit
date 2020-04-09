//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

extension URL {
    init(validString: StaticString) {
        self.init(string: validString.description)!
    }
}
