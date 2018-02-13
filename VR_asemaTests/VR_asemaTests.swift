//
//  VR_asemaTests.swift
//  VR_asemaTests
//
//  Created by Matti Saarela on 07/02/2018.
//  Copyright © 2018 Matti Saarela. All rights reserved.
//

import XCTest
@testable import VR_asema

class VR_asemaTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testScandiConversion() {
        let VC = StationListViewController()
        let withoutScandi = "RHE" //Testi ilman ääkkösiä
        let withScandi = "ÖKY" //Testi ääkkösillä
        let onlyScandi = "ÄÖÄ" //Testi pelkillä ääkkösillä
        let special = "ÖLDFS" //Testi pidemmällä stringillä
        XCTAssertEqual(VC.urlConvertScandi(string: withoutScandi), "RHE")
        XCTAssertEqual(VC.urlConvertScandi(string: withScandi), "%C3%96KY")
        XCTAssertEqual(VC.urlConvertScandi(string: onlyScandi), "%C3%84%C3%96%C3%84")
        XCTAssertEqual(VC.urlConvertScandi(string: special), "%C3%96LDFS")
    }
    
    
    
}
