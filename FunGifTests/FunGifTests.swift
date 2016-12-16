//
//  FunGifTests.swift
//  FunGifTests
//
//  Created by Marshall Yang on 2016/10/7.
//  Copyright © 2016年 Marshall Yang. All rights reserved.
//

import XCTest

class FunGifTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let fonts = UIFont.familyNames
        for font in fonts {
            if font.contains("Ameri") {
                let fonts2 = UIFont.fontNames(forFamilyName: font)
                print(fonts2)
            }
        }
        
        
    }
    
    func testPlist() {
        let path = Bundle.main.path(forResource: "Categories", ofType: "plist")
        let data = NSMutableDictionary(contentsOfFile: path!)
        print(data)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
