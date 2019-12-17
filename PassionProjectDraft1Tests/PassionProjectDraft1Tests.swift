//
//  PassionProjectDraft1Tests.swift
//  PassionProjectDraft1Tests
//
//  Created by Krystal Campbell on 11/22/19.
//  Copyright © 2019 Krystal Campbell. All rights reserved.
//

import XCTest
@testable import PassionProjectDraft1

class PassionProjectDraft1Tests: XCTestCase {

    override func setUp() {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    private func getSignData() -> Data {
        guard let pathToData = Bundle.main.path(forResource: "austell", ofType: "json")
            else {
                fatalError("austell.json file not found")
        }
        let url = URL(fileURLWithPath: pathToData)
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch let jsonError {
            fatalError("could not find file: \(jsonError)")
        }
    }
    
    private func getSignData2() -> Data {
           guard let pathToData = Bundle.main.path(forResource: "austell2", ofType: "json")
               else {
                   fatalError("austell.json file not found")
           }
           let url = URL(fileURLWithPath: pathToData)
           do {
               let data = try Data(contentsOf: url)
               return data
           } catch let jsonError {
               fatalError("could not find file: \(jsonError)")
           }
       }
       
    func testSignDataLoad(){
        let signs = Geometry.getStreetSigns()
        XCTAssert(signs.features.count > 0, "where is the data")
       }
  
    func testSignDataLoad2(){
          let signs = Geometry.getStreetSigns()
          XCTAssert(signs.features.count > 0, "where is the data")
         }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
