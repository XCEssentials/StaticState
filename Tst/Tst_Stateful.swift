import XCTest

@testable
import XCEStaticState

import XCETesting

//===

class Tst_Stateful: XCTestCase
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
    
    //===
    
    func testStartClean()
    {
        RXC.isNil("Current state is undefined, we start clean.") {
            
            aView.state
        }
    }
    
    //===
    
    func testAssignAndHoldLatestAssignedValue()
    {
        aView.state = MyView.Disabled(opacity: 0.3)
        aView.state = MyView.Normal()
        
        //===
        
        RXC.isTrue("Current state became 'Normal'.") {
            
            aView.state is MyView.Normal
        }
    }
    
    //===
    
    func testAssignTwiceDifferentInstancesOfSameState()
    {
        let latestHighlightedColor = 2
        
        aView.state = MyView.Highlighted(color: 1)
        aView.state = MyView.Highlighted(color: latestHighlightedColor)
        
        //===
        
        let highlighted =
            
        RXC.value("Current state became 'Highlighted'.") {
            
            aView.state as? MyView.Highlighted
        }
        
        //===
        
        RXC.isTrue("Current state holds latest assigned value.") {
            
            highlighted?.color == latestHighlightedColor
        }
    }
}
