import Foundation

import XCEStaticState

//===

final
class MyView: StatefulWithHelpers
{
    var state: State?
}

//=== States

extension MyView
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
