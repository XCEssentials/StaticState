import Foundation

import XCEStaticState

//===

final
class MyView { }

//=== States

extension MyView: Stateful
{
    struct Normal: State { }
    
    //===
    
    struct Disabled: State
    {
        let opacity: Float
    }
    
    //===
    
    struct Highlighted: State
    {
        let color: Int
    }
}
