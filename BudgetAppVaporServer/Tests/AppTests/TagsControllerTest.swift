//
//  TagsControllerTest.swift
//
//
//  Created by Evan Webb on 3/21/24.
//

import Foundation

@testable import App
import XCTVapor

final class TagsControllerTest: XCTestCase {
    func testHelloWorld() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try await configure(app)
        
        // TODO: figure out how to create a user and create fake data
        
        try app.test(.GET, "tags", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "Hello, world!")
        })
    }
}
