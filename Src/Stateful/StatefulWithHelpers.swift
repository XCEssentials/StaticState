import Foundation

//===

public
protocol StatefulWithHelpers: Stateful { }

//===

public
extension StatefulWithHelpers
{
    func currentState() -> State?
    {
        return state
    }
    
    //===
    
    func at<Input: State>(
        _: Input.Type
        ) throws -> Input
    {
        if
            let result = state as? Input
        {
            return result
        }
        else
        {
            throw Errors.WrongState()
        }
    }
    
    //===
    
    func update<Input: State>(
        _: Input.Type,
        mutation: (inout Input) -> Void
        ) throws
    {
        if
            var result = state as? Input
        {
            mutation(&result)
            state = result
        }
        else
        {
            throw Errors.WrongState()
        }
    }
    
    //===
    
    func set<Input: State>(
        _ newState: Input?
        )
    {
        state = newState
    }
    
    //===
    
    func resetCurrentState()
    {
        return state = nil
    }
}
