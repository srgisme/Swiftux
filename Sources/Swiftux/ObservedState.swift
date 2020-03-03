//
//  ObservedState.swift
//  
//
//  Created by Scott Gorden on 2/17/20.
//

import Foundation
import Combine

public class ObservedState<RootState: StateType & Equatable, Substate: StateType & Equatable>: ObservableObject, ActionDispatchable {

    @Published public private(set) var state: Substate
    private var cancellable: AnyCancellable?
    private var _dispatch: (ActionType) -> Void

    public init(_ keyPathToSubstate: KeyPath<RootState, Substate>, on store: Store<RootState>) {
        self.state = store.state[keyPath: keyPathToSubstate]
        self._dispatch = { [weak store] in store?.dispatch($0)}
        self.cancellable = store.$state
            .map { $0[keyPath: keyPathToSubstate] }
            .removeDuplicates()
            .assign(to: \.state, on: self)
    }

    public func dispatch(_ action: ActionType) {
        { [weak self] in self?._dispatch(action) }()
    }

    deinit {
        cancellable?.cancel()
    }

}
