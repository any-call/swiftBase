//
//  httpClientTests.swift
//  swiftBase
//
//  Created by jinguihua on 2026/1/6.
//

import XCTest
@testable import swiftBase

final class httpClientTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetNodeList() async throws {
        struct Node : Codable{
            let id :Int64
            let name :String
            let create_time : Int64
            let update_time :Int64
        }
        
        do{
            let list:[Node]? = try await myNet.getJson(
                url: "https://badu.com/admin/api/ios/node",
                 inParam: nil,
                 timeout: 30
            )
            
            if let list { //可选要解包
                for item in list {
                    print(item)
                }
            }else {
                print("error")
            }
        }catch{
            print("网络出错了",error)
        }
       
    }

}
