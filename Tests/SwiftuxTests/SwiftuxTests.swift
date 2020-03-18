import XCTest
@testable import Swiftux

final class SwiftuxTests: XCTestCase {

    func testIncreaseCount() {
        let store = Store(initialState: MockAppState(), reducer: appReducer, middleware: [])
        validate(count: 1, afterDispatching: .increase(delta: 1), to: store)
    }

    func testDecreaseCount() {
        let store = Store(initialState: MockAppState(), reducer: appReducer, middleware: [])
        validate(count: -1, afterDispatching: .decrease(delta: 1), to: store)
    }

    func testDispatchingMiddleware() {
        let store = Store(initialState: MockAppState(), reducer: appReducer, middleware: [MockDispatchingMiddleware()])
        validate(count: 0, afterDispatching: .increase(delta: 1), to: store)
    }

    func testGetCurrentStateInMiddleware() {
        let finalCount = 3
        let store = Store(initialState: MockAppState(), reducer: appReducer, middleware: [CurrentStateMiddleware(finalCount: finalCount)])
        let expectation = XCTestExpectation()
        let _ = store.$state
            .collect()
            .sink { collectedStates in
                XCTAssertEqual(collectedStates.map { $0.counterState.count }, [0, 1, 0, finalCount])
                expectation.fulfill()
            }
    }

    private func validate(count: Int, afterDispatching counterAction: AppAction.CounterAction, to store: Store<MockAppState>) {
        let expectation = XCTestExpectation()
        let _ = store.$state
            .dropFirst()
            .sink { state in
                XCTAssertEqual(store.state.counterState.count, count)
                expectation.fulfill()
            }
        store.dispatcher.send(counterAction)
    }

    // TODO: Add asynchronous middleware test

    static var allTests = [
        ("testIncreaseCount", testIncreaseCount),
        ("testDecreaseCount", testDecreaseCount),
        ("testDispatchingMiddleware", testDispatchingMiddleware)
    ]

}
