import XCTest

@testable
import XCEStaticState

import XCETesting

//===

class Tst_StatefulWithHelpers: XCTestCase
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
    
    func testInferredCurrentState()
    {
        aView.set(MyView.Normal())
        
        //===
        
        let normal: MyView.Normal? = try? aView.currentState()
        
        RXC.isNotNil("Current state is 'Normal' (inferred)."){
            
            normal
        }
    }
    
    //===
    
    func testUpdateCurrentState()
    {
        aView.set(MyView.Disabled(opacity: 0.3))
        
        //===
        
        let updatedOpacity: Float = 0.5
        
        try? aView.update { (disabled: inout MyView.Disabled) in
            
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
