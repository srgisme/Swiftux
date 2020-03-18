//
//  Store.swift
//  
//
//  Created by Scott Gorden on 2/1/20.
//

import Foundation
import Combine

/// Your application should have only one `Store`. You can not subclass it, but it is generic over any app state type you want. Since the `Store` is an `ObservableObject`, any `View`s with an `@ObservedObject` property of this type will automatically be updated any time the `state` changes. If you want to prevent child `View`s from being updated upon `state` changes, wrap the parent `View` in an `EquatableView` (you can use the `equatable()` modifier on the parent as well).
final public class Store<S: StateType>: ObservableObject {

    @Published public private(set) var state: S
    let middleware: [Middleware]
    let reducer: Reducer<S>
    /// This subject is used to diapatch actions to the `Store`. To do that, call its `send()` method and pass the `ActionType` you would like to dispatch. When this happens, the store determines the last action exiting the `Middleware` chain and passes it to the `Reducer`. The `Reducer` uses this action and the current app state to produce a new app state for the `Store`. If a `Middleware` returns `nil`, the action is dropped, movement through the `Middleware` chain is halted, and a new state is not reduced.
    public let dispatcher = PassthroughSubject<ActionType, Never>()
    private var dispatcherCancellable: AnyCancellable?

    public init(initialState: S, reducer: @escaping Reducer<S>, middleware: [Middleware]) {
        self.state = initialState
        self.reducer = reducer
        self.middleware = middleware
        self.dispatcherCancellable = dispatcher
            .receive(on: DispatchQueue.main)
            .compactMap { action in
                let dispatch: (ActionType) -> Void = { [weak self] in self?.dispatcher.send($0) }
                let currentStateAfterDispatching: (ActionType?) -> AnyPublisher<StateType, Never>? = { [weak self] newAction in

                    guard let self = self else { return nil }

                    let getStatePublisher = Just(self.state)
                        .map { $0 as StateType }
                        .eraseToAnyPublisher()

                    guard let newAction = newAction else {
                        return getStatePublisher
                    }

                    let currentState = self.$state
                        .dropFirst()
                        .flatMap { Just($0) }
                        .map { $0 as StateType }
                        .eraseToAnyPublisher()

                    defer {
                        self.dispatcher.send(newAction)
                    }

                    return currentState
                }

                return middleware.execute(action: action, dispatch: dispatch, currentStateAfterDispatching: currentStateAfterDispatching)
            }
            .map { reducer($0, self.state) }
            .assign(to: \.state, on: self)
    }

}
