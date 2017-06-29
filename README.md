[![GitHub tag](https://img.shields.io/github/tag/XCEssentials/StaticState.svg)](https://github.com/XCEssentials/StaticState/releases)
[![CocoaPods](https://img.shields.io/cocoapods/v/XCEStaticState.svg)](https://cocoapods.org/?q=XCEStaticState)
[![CocoaPods](https://img.shields.io/cocoapods/p/XCEStaticState.svg)](https://cocoapods.org/?q=XCEStaticState)
[![license](https://img.shields.io/github/license/XCEssentials/StaticState.svg)](https://opensource.org/licenses/MIT)

# Introduction
Turn any object into a discrete system where each state is a static data container.



# How to install

The recommended way is to install using [CocoaPods](https://cocoapods.org/?q=XCEStaticState):

```ruby
pod 'XCEStaticState', '~> 1.1'
```



# How it works

This library allows to turn any object into [discrete system](https://en.wikipedia.org/wiki/Discrete_system) by defining a number of distinct states for any object and then set any of these states as current state of the object. Same state can be re-set multiple times without any limitations.



# How to use

A typical use case for this library is to store different set of internal data (and provide access to diffrent functionality, incapsulated in state types) at different points of time as well as indicating current internal state of a given object. Any object can only be in one particular state at any point of time, or current state might be undefined.



## State

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
    struct Normal: State
    {
    	typealias Owner = MyView
    }
    
    struct Disabled: State
    {
	    typealias Owner = MyView
	    
        var opacity: Float
    }
    
    struct Highlighted: State
    {
    	typealias Owner = MyView
    
        let color: Int
    }
}
```



## Stateful

Any object for which we want to track its current state should be of type that conforms to `Stateful` protocol. That protocol only requires to declare one var property `state` where current state supposed to be stored:

```swift
var state: Any?
```

Let's update the initial class declaration:

```swift
class MyView: Stateful
{
	var state: Any?
}
```

We can set current state as follows:

```swift
let aView = MyView()

aView.state = MyView.Disabled(opacity: 0.3)
aView.state = MyView.Normal()
aView.state = MyView.Highlighted(color: 1)
// 'aView.state' is now 'Highlighted' with 'color' equal to '1'
```

Note, that in the beginning the `state` property is `nil` until you set a value explicitly; after this it holds assigned value indefinitely until you assign another value, `nil` or the object itself is deallocated.

```swift
var aView = MyView()

aView.state = MyView.Normal()
// 'aView.state' is now 'Normal'

aView = MyView() // released previosly created object of type 'MyView'
// 'aView.state' is now 'nil'

aView.state = MyView.Disabled(opacity: 0.3)
// 'aView.state' is now 'Disabled' with 'opacity' equal to '0.3'
```



## Helper functions

Moreover, `Stateful` protocol provides provides several functions that allow to dial with state solely via functions.

```swift
let aView = MyView()

aView.set(MyView.Normal())
// current state of 'aView' object is now 'Normal'

aView.set(MyView.Disabled(opacity: 0.3))
// current state of 'aView' object is now 'Disabled' with 'opacity' equal to '0.3'

try? aView.update(MyView.Disabled.self){ $0.opacity += 0.2 }
// current state of 'aView' object is now 'Disabled' with 'opacity' equal to '0.5'

if
	let d = try? aView.currentState() as? MyView.Disabled
{
	// 'd' now holds an instace of 'Disabled' type with 'opacity' equal to '0.5'
}

aView.resetCurrentState()
// current state of 'aView' object is now 'nil'
```

