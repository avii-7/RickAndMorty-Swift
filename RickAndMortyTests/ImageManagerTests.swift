//
//  ImageManagerTests.swift
//  RickAndMortyTests
//
//  Created by Arun Kumar on 26/02/25.
//

import XCTest
@testable import RickAndMorty

final class ImageManagerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() async throws {
        let sut = RMImageManager.shared
        let key = "Sample Data"
        let sampleData = key.data(using: .utf8)!
        
        sut.setCache(sampleData, for: key)
        
        Task {
            if let result = sut.getCache(for: key) {
                print(String(data: result as Data, encoding: .utf8)!, "-----------")
            }
            else {
                print("Nothing-------")
            }
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
