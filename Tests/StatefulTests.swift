import XCTest

@testable
import XCEStaticState

import XCETesting

//===

class StatefulTests: XCTestCase
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
    
    //===
    
    func testSetNewState()
    {
        aView.set(MyView.Normal())
        
        //===
        
        RXC.isTrue("'func set(...)' seems to be working as expected."){
            
            aView.state is MyView.Normal
        }
    }
    
    //===
    
    func testCurrentStateViaFunc()
    {
        RXC.isNil("Current state is undefined, we start clean.") {
            
            aView.currentState()
        }
        
        //===
        
        aView.set(MyView.Normal())
        
        //===
        
        RXC.isTrue("Current state is 'Normal'."){
            
            aView.currentState() is MyView.Normal
        }
        
        RXC.isTrue("'func currentState()' returns the same type as 'var state'.") {
            
            type(of: aView.state) == type(of: aView.currentState())
        }
    }
    
    //===
    
    func testUpdateWithStateAsFunctionParameter()
    {
        aView.set(MyView.Disabled(opacity: 0.3))
        
        //===
        
        let updatedOpacity: Float = 0.5
        
        try? aView.update(MyView.Disabled.self) {
            
            $0.opacity = updatedOpacity
        }
        
        //===
        
        let disabled =
            
        RXC.value("Current state is 'Disabled'."){
            
            aView.currentState() as? MyView.Disabled
        }
        
        //===
        
        RXC.isTrue("Current state stores updated opacity value.") {
            
            disabled?.opacity == updatedOpacity
        }
    }
    
    //===
    
    func testUpdateWithStateAsClosureParameter()
    {
        aView.set(MyView.Disabled(opacity: 0.3))
        
        //===
        
        let updatedOpacity: Float = 0.5
        
        try? aView.update{ (disabled: inout MyView.Disabled) in
            
            disabled.opacity = updatedOpacity
        }
        
        //===
        
        let disabled =
            
        RXC.value("Current state is 'Disabled'."){
            
            aView.currentState() as? MyView.Disabled
        }
        
        //===
        
        RXC.isTrue("Current state stores updated opacity value.") {
            
            disabled?.opacity == updatedOpacity
        }
    }
    
    //===
    
    func testResetCurrentState()
    {
        aView.set(MyView.Normal())
        
        //===
        
        aView.resetCurrentState()
        
        //===
        
        RXC.isNil("Current state has been successfully reset.") {
            
            aView.currentState()
        }
    }
}
