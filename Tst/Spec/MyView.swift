import Foundation

import XCEStaticState

//===

final
class MyView { }

//=== States

extension MyView: StatefulWithHelpers
{
    struct Normal: State { }
    
    //===
    
    struct Disabled: State
    {
        var opacity: Float
    }
    
    //===
    
    struct Highlighted: State
    {
        let color: Int
    }
}
