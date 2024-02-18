//
//  RMLocationHelperTests.swift
//  RickAndMortyTests
//
//  Created by Arun on 18/02/24.
//

import XCTest
@testable import RickAndMorty

final class RMLocationHelperTests: XCTestCase {

    var locations: [RMLocation]!
    var residents: [RMCharacter]!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        locations = [.init(id: 1, name: "", type: "", dimension: "", residents: .init(), url: .empty, created: .empty)]
        residents = []
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        locations = []
        residents = []
    }
    
    func testLocationCellViewModelsCount() {
        let result = RMLocationHelper.createCellViewModels(from: locations)
        XCTAssertEqual(result.count, locations.count)
    }
}
