//
//  AppFeatureTests.swift
//  TCA
//
//  Created by user on 18.11.2025.
//

import ComposableArchitecture
import XCTest
@testable import TCA

@MainActor
final class AppFeatureTests: XCTestCase {
    func testIncrementFirstTab() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        
        await store.send(\.tab1.incrementButtonTapped) {
            $0.tab1.count = 1
        }
    }
}
