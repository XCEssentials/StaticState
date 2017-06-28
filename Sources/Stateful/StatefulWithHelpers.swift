import Foundation

/**
 Provides access to `state` property via functions.
 */
public
protocol StatefulWithHelpers: Stateful { }

//===

public
extension StatefulWithHelpers
{
    /**
     Allows to set current state to `newState`.
     
     Use as follows:
     
     ```swift
     class MyView: UIView, StatefulWithHelpers
     {
         struct Disabled: State
         {
             var opacity: Float
         }
         
         var state: State?
     }
     
     let aView = MyView()
     
     aView.set(MyView.Disabled(opacity: 0.3))
     ```
     
     - Parameter newState: An instance of type that conforms to `State` protocol, or `nil`. This value will be set as new current state.
     */
    func set<Input: State>(_ newState: Input?)
    {
        state = newState
    }
    
    /**
     Provides read-only access to the `state` property value from `Stateful` protocol.
     
     Use as follows:
     
     ```swift
     class MyView: UIView, StatefulWithHelpers { var state: State? }
     
     let aView = MyView()
     
     let current = aView.currentState()
     ```
     
     - Returns: Current state as instance of `State` without conversion to a specific state type, if it's set, or `nil` otherwise.
     */
    func currentState() -> State?
    {
        return state
    }
    
    /**
     Allows to check if current state is of expected type or not. The `ExpectedState` return type will be inferred from context.
     
     Use as follows:
     
     ```swift
     class MyView: UIView, StatefulWithHelpers
     {
         struct Normal: State { }
         
         var state: State?
     }
     
     let aView = MyView()
     
     if
        let n: MyView.Normal = try? aView.currentState()
     {
        //...
     }
     ```
     
     - Throws: `Errors.WrongState` if current state is NOT of type `ExpectedState`.
     
     - Returns: Current state as instance of `ExpectedState` type.
     */
    func currentState<ExpectedState: State>() throws -> ExpectedState
    {
        if
            let result = state as? ExpectedState
        {
            return result
        }
        else
        {
            throw Errors.WrongState()
        }
    }
    
    /**
     Allows to mutate current state, if it's of expected type.
     
     Use as follows:
     
     ```swift
     class MyView: UIView, StatefulWithHelpers
     {
        struct Disabled: State
        {
            var opacity: Float
         }
         
         var state: State?
     }
     
     let aView = MyView()
     
     try? aView.update(MyView.Disabled.self){
     
        $0.opacity += 0.1
     }
     ```
     
     - Parameter expected: Expected current state type.
     - Parameter mutation: Closure that will be used to mutate current state.
     
     - Throws: `Errors.WrongState` if current state is NOT of `expected` type.
     */
    func update<ExpectedState: State>(
        _ expected: ExpectedState.Type,
        mutation: (inout ExpectedState) -> Void
        ) throws
    {
        if
            var result = state as? ExpectedState
        {
            mutation(&result)
            state = result
        }
        else
        {
            throw Errors.WrongState()
        }
    }
    
    /**
     Sets current state to `nil`.
     */
    func resetCurrentState()
    {
        return state = nil
    }
}
