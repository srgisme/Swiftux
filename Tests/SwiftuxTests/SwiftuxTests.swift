import XCTest
@testable import Swiftux

final class SwiftuxTests: XCTestCase {

    func testIncreaseCount() {
        let store = Store(initialState: MockAppState(), reducer: appReducer, middleware: [])
        store.dispatch(AppAction.CounterAction.increase(delta: 1))
        XCTAssertEqual(store.state.value.counterState.count, 1)
    }

    func testDecreaseCount() {
        let store = Store(initialState: MockAppState(), reducer: appReducer, middleware: [])
        store.dispatch(AppAction.CounterAction.decrease(delta: 1))
        XCTAssertEqual(store.state.value.counterState.count, -1)
    }

    func testDispatchingMiddleware() {
        let store = Store(initialState: MockAppState(), reducer: appReducer, middleware: [MockDispatchingMiddleware()])
        store.dispatch(AppAction.CounterAction.increase(delta: 1))
        XCTAssertEqual(store.state.value.counterState.count, 0)
    }

    func testObservedState() {
        let store = Store(initialState: MockAppState(), reducer: appReducer, middleware: [])
        let observedCounterState = ObservedState(\.counterState, on: store)
        store.dispatch(AppAction.CounterAction.increase(delta: 1))
        XCTAssertEqual(store.state.value.counterState, observedCounterState.value)
    }

    // TODO: Add asynchronous middleware test

    static var allTests = [
        ("testIncreaseCount", testIncreaseCount),
        ("testDecreaseCount", testDecreaseCount),
        ("testDispatchingMiddleware", testDispatchingMiddleware)
    ]

}
