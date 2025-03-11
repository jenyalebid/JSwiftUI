//
//  Animation.Swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 1/23/25.
//

import SwiftUI

public extension Animation {
    
    func repeat(while condition: @escaping @autoclosure () -> Bool, autoreverses: Bool) -> Animation {
        if condition() {
            return self.repeatForever(autoreverses: autoreverses)
        } else {
            return self
        }
    }
}
