SwiftState [![Circle CI](https://circleci.com/gh/ReactKit/SwiftState/tree/swift%2F2.0.svg?style=svg)](https://circleci.com/gh/ReactKit/SwiftState/tree/swift%2F2.0)
==========

Elegant state machine for Swift.

![SwiftState](Screenshots/logo.png)


## Example

```swift
enum MyState: StateType {
    case State0, State1, State2
    case AnyState   // create case=Any

    init(nilLiteral: Void) {
        self = AnyState
    }
}
```

```swift
let machine = StateMachine<MyState, MyEvent>(state: .State0) { machine in

    machine.addRoute(.State0 => .State1)
    machine.addRoute(nil => .State2) { context in print("Any => 2, msg=\(context.userInfo)") }
    machine.addRoute(.State2 => nil) { context in print("2 => Any, msg=\(context.userInfo)") }

    // add handler (handlerContext = (event, transition, order, userInfo))
    machine.addHandler(.State0 => .State1) { context in
        print("0 => 1")
    }

    // add errorHandler
    machine.addErrorHandler { (event, transition, order, userInfo) in
        print("[ERROR] \(transition.fromState) => \(transition.toState)")
    }
}

// tryState 0 => 1 => 2 => 1 => 0
machine <- .State1
machine <- (.State2, "Hello")
machine <- (.State1, "Bye")
machine <- .State0  // fail: no 1 => 0

print("machine.state = \(machine.state)")
```

This will print:

```swift
0 => 1
Any => 2, msg=Hello
2 => Any, msg=Bye
[ERROR] 1 => 0
machine.state = 1
```

### Transition by Event

Use `<-!` operator to try transition by `Event` rather than specifying target `State` ([Test Case](https://github.com/ReactKit/SwiftState/blob/6858f8f49087c4b8b30bd980cfc81e8e74205718/SwiftStateTests/StateMachineEventTests.swift#L54-L76)).

```swift
let machine = StateMachine<MyState, MyEvent>(state: .State0) { machine in
        
    // add 0 => 1 => 2
    machine.addRouteEvent(.Event0, transitions: [
        .State0 => .State1,
        .State1 => .State2,
    ])
}
   
// tryEvent
machine <-! .Event0
XCTAssertEqual(machine.state, MyState.State1)

// tryEvent
machine <-! .Event0
XCTAssertEqual(machine.state, MyState.State2)

// tryEvent
let success = machine <-! .Event0
XCTAssertEqual(machine.state, MyState.State2)
XCTAssertFalse(success, "Event0 doesn't have 2 => Any")
```

For more examples, please see XCTest cases.


## Features

- Easy Swift syntax
    - Transition: `.State0 => .State1`, `[.State0, .State1] => .State2`
    - Try transition: `machine <- .State1`
    - Try transition + messaging: `machine <- (.State1, "GoGoGo")`
    - Try event: `machine <-! .Event1`
- Highly flexible transition routing
    - using Condition
    - using AnyState (`nil` state)
    - or both (blacklisting): `nil => nil` + condition
- Success/Error/Entry/Exit handlers with `order: UInt8` (no before/after handler stuff)
- Removable routes and handlers
- Chaining: `.State0 => .State1 => .State2`
- Event: `machine.addRouteEvent("WakeUp", transitions); machine <-! "WakeUp"`
- Hierarchical State Machine: [#10](https://github.com/ReactKit/SwiftState/pull/10)

## Terms

Term      | Class                         | Description
--------- | ----------------------------- | ------------------------------------------
State     | `StateType` (protocol)        | Mostly enum, describing each state e.g. `.State0`.
Event     | `StateEventType` (protocol)   | Name for route-group. Transition can be fired via `Event` instead of explicitly targeting next `State`.
Machine   | `StateMachine`                | State transition manager which can register `Route` and `Handler` separately for variety of transitions.
Transition   | `StateTransition`          | `From-` and `to-` states represented as `.State1 => .State2`. If `nil` is used for either state, it will be represented as `.AnyState`.
Route     | `StateRoute`                  | `Transition` + `Condition`.
Condition | `Transition -> Bool`          | Closure for validating transition. If condition returns `false`, transition will fail and associated handlers will not be invoked.
Handler   | `HandlerContext -> Void`      | Transition callback invoked after state has been changed.
Chain     | `StateTransitionChain`        | Group of continuous routes represented as `.State1 => .State2 => .State3`


## Related Articles

1. [Swiftで有限オートマトン(ステートマシン)を作る - Qiita](http://qiita.com/inamiy/items/cd218144c90926f9a134) (Japanese)
2. [Swift+有限オートマトンでPromiseを拡張する - Qiita](http://qiita.com/inamiy/items/d3579b55a3ecc28dde63) (Japanese)


## Licence

[MIT](https://github.com/ReactKit/SwiftState/blob/master/LICENSE)
