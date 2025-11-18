//
//  TCATests.swift
//  TCATests
//
//  Created by user on 18.11.2025.
//

//import Testing
//
//struct TCATests {
//
//    @Test func example() async throws {
//        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
//    }
//
//}

import ComposableArchitecture
import XCTest
@testable import TCA

@MainActor
final class CounterFeatureTests: XCTestCase {
    func testCounter() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        
        await store.send(.incrementButtonTapped) { state in
            state.count = 1
        }
        
        await store.send(.incrementButtonTapped) {
            $0.count = 2
        }
        await store.send(.decrementButtonTapped) {
            $0.count = 1
        }
    }
    
    func testCounter2() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        
        await store.send(.decrementButtonTapped) { state in
            state.count = -1
        }
        
        await store.send(.incrementButtonTapped) {
            $0.count = 0
        }
        await store.send(.decrementButtonTapped) {
            $0.count = -1
        }
    }
    
    func testTimer() async {
        let testClock = TestClock()
        
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: { clock in
            clock.continuousClock = testClock
        }
        
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = true
        }
        
        await testClock.advance(by: .seconds(1))
        await store.receive(\.timerTick) {
            $0.count = 1
        }
        
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = false
        }
    }
    
    func testCatFact() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: { myText in
            myText.textFact.fetch = { " good text"}
        }
        
        await store.send(.factButtonTapped) {
            $0.isLoading = true
        }
        
        await store.receive(\.factResponse, timeout: .seconds(1)) {
            $0.isLoading = false
            $0.fact = " good text"
            
        }
    }
    
}
