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
    
    func testDirect()
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
    
    func testHelpers()
    {
        RXC.isNil("Current state is undefined, we start clean") {
            
            aView.state
        }
        
        //===
        
        aView.set(MyView.Normal())
        
        //===
        
        RXC.isTrue("Current state (via property) is now 'Normal'"){
            
            aView.state is MyView.Normal
        }
        
        //===

        RXC.isTrue("'func currentState()' returns the same type as 'var state'") {
            
            type(of: aView.currentState()) == type(of: aView.state)
        }
        
        //===
        
        RXC.isTrue("Current state (via func) is now 'Normal'"){
            
            aView.currentState() is MyView.Normal
        }
        
        //===
        
        let normal: MyView.Normal? = try? aView.currentState()
        
        RXC.isNotNil("Current state is now 'Normal' (inferred)"){
            
            normal
        }
        
        //===
        
        aView.set(MyView.Disabled(opacity: 0.3))
        
        //===
        
        RXC.isTrue("Current state is now 'Disabled'"){
            
            aView.currentState() is MyView.Disabled
        }
        
        //===
        
        let updatedOpacity: Float = 0.5
        
        try? aView.update(MyView.Disabled.self) {
            
            $0.opacity = updatedOpacity
        }
        
        //===
        
        let disabled =
        
        RXC.value("Current state is still 'Disabled'"){
            
            aView.currentState() as? MyView.Disabled
        }
        
        //===
        
        RXC.isTrue("Disabled opacity is now updated") {
            
            disabled?.opacity == updatedOpacity
        }
        
        //===
        
        aView.resetCurrentState()
        
        //===
        
        RXC.isNil("Current state has been reset and is 'nil' now") {
            
            aView.currentState()
        }
    }
}
