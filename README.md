[![GitHub tag](https://img.shields.io/github/tag/XCEssentials/StaticState.svg)](https://github.com/XCEssentials/StaticState/releases)
[![CocoaPods](https://img.shields.io/cocoapods/v/XCEStaticState.svg)](https://cocoapods.org/?q=XCEStaticState)
[![CocoaPods](https://img.shields.io/cocoapods/p/XCEStaticState.svg)](https://cocoapods.org/?q=XCEStaticState)
[![license](https://img.shields.io/github/license/XCEssentials/StaticState.svg)](https://opensource.org/licenses/MIT)

## Introduction
Turn any object into a discrete system where each state is a static data container.



## How to install

The recommended way is to install using [CocoaPods](https://cocoapods.org/?q=XCEStaticState).



## How it works

This library allows to turn any object into [discrete system](https://en.wikipedia.org/wiki/Discrete_system) by defining a number of distinct states for any object and then set any of these states as current state of the object. Same state can be re-set multiple times without any limitations.



## How to use

A typical use case for this library is to store different set of internal data at different points of time as well as indicating current internal state of a given object. Any object can only be in one particular state at any point of time, or current state might be undefined.



### State

Let's say we have class `MyView`...

```swift
class MyView
{
	// class definition goes here...
}
```

... and it can only be in 3 different states: `Normal`, `Disabled` or `Highlighted`. Every state must be declared as an instantiatable type that conforms to `State` protocol. For the sake of simplicity, lets assume that `Normal` contains no extra data, `Disabled` holds opacity amount and `Highlighted` contains `color` value which is just a number that represents a code for color.

```swift
extension MyView
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
```



### Stateful

The object which internal state we want to track must conform to `Stateful` protocol. This protocol does not require to implement anything, but gives exclusive access to special dynamic property:

```swift
var state: State?
```

Later we can set current state as follows:

```swift
extension MyView: Stateful { }
// ...
let aView = MyView()
// ...
aView.state = MyView.Disabled(opacity: 0.3)
aView.state = MyView.Normal()
aView.state = MyView.Highlighted(color: 1)
// 'aView.state' is now 'Highlighted' with 'color' equal to '1'
```

Note, that in the beginning `aView.state` is `nil` until you set a value explicitly first time. After you assign a value, it holds it automatically until you assign another value, `nil` or the `aView` object is deallocated.

```swift
var aView = MyView()
// ...
aView.state = MyView.Normal()
// 'aView.state' is now 'Normal'
// ...
aView = MyView() // released previosly created object
// 'aView.state' is now 'nil'
aView.state = MyView.Disabled(opacity: 0.3)
// 'aView.state' is now 'Disabled' with 'opacity' equal to '0.3'
```



### StatefulWithHelpers

`StatefulWithHelpers` protocol inherits from `Stateful` and allows to deal with `state` property solely via functions:

- `func currentState() -> State?` returns current state, if set, or `nil` otherwise;
- `func at<Input: State>(_: Input.Type ) throws -> Input` returns current state, if it is an instance of type `Input`, or throws `Errors.WrongState` otherwise;
- `func update<Input: State>(_: Input.Type, mutation: (inout Input) -> Void throws` allows to mutate current state (by calling the mutation closure and passing there current state as input parameter), or throws `Errors.WrongState` otherwise;
- `func set<Input: State>(_ newState: Input?)` updates current state with `newState`;
- `func resetCurrentState()` sets current state to `nil`.

```swift
extension MyView: StatefulWithHelpers { }
// ...
let aView = MyView()
// ...
aView.set(MyView.Normal())
// 'aView.currentState()' now returns 'Normal'
aView.set(MyView.Highlighted(color: 1))
// 'aView.currentState()' now returns 'Highlighted' with 'color' equal to '1'
let h = try! aView.at(MyView.Highlighted.self)
try? aView.update(MyView.Highlighted.self) { $0.color = h.color + 1 }
// 'aView.currentState()' now returns 'Highlighted' with 'color' equal to '2'
```

