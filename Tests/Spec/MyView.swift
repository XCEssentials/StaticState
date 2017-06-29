import Foundation

import XCEStaticState

//===

final
class MyView: Stateful
{
    var state: Any?
}

//=== States

extension MyView
{
    struct Normal: State
    {
        typealias Owner = MyView
    }
    
    //===
    
    struct Disabled: State
    {
        typealias Owner = MyView
        
        var opacity: Float
    }
    
    //===
    
    struct Highlighted: State
    {
        typealias Owner = MyView
        
        let color: Int
    }
}
