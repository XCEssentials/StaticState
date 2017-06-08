import XCTest

@testable
import XCEStaticState

import XCETesting

//===

class Main: XCTestCase
{
    let aView = MyView()
    
    //===
    
    override
    func setUp()
    {
        super.setUp()
        
        //===
        
        aView.state = nil
    }
    
    override
    func tearDown()
    {
        aView.state = nil
        
        //===
        
        super.tearDown()
    }
    
    func testOne()
    {
        RXC.isNil("Current state is undefined, we start clean") {
            
            aView.state
        }
        
        //===
        
        aView.state = MyView.Disabled(opacity: 0.3)
        aView.state = MyView.Normal()
        
        //===
        
        RXC.isTrue("Current state became Normal") {
            
            aView.state is MyView.Normal
        }
        
        //===
        
        // applying twice same state to check update block execution
        
        let latestHighlightedColor = 2
        
        aView.state = MyView.Highlighted(color: 1)
        aView.state = MyView.Highlighted(color: latestHighlightedColor)
        
        //===
        
        let highlighted =
        
        RXC.value("Current state became Highlighted") {
            
            aView.state as? MyView.Highlighted
        }
        
        RXC.isTrue("Current state holds latest assigned value") {
            
            highlighted?.color == latestHighlightedColor
        }
    }
}
