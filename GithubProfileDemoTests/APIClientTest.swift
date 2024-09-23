//
//  APIClientTest.swift
//  GithubProfileDemoTests
//
//  Created by Kazu on 24/9/24.
//
import Foundation
import XCTest

class APIClientTests: XCTestCase {
    var apiClient: URLSessionAPIClient<MockEndpoint>!
    var mockSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        apiClient = URLSessionAPIClient<MockEndpoint>(urlSession: mockSession)
    }
    
    override func tearDown() {
        apiClient = nil
        mockSession = nil
        super.tearDown()
    }
    
    func testRequest_SuccessfulResponse() async {
        let expectedData = "{\"name\": \"Phu Phan\"}".data(using: .utf8)!
        mockSession.data = expectedData
        mockSession.response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
        
        do {
            let result: MockResponseModel = try await apiClient.request(MockEndpoint.example)
            
            XCTAssertEqual(result.name, "Phu Phan")
        } catch {
            XCTFail("Error occured! \(error)")
        }
        
    }
    
    func testRequest_500to600ServerError() async {
        mockSession.response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                               statusCode: 500,
                                               httpVersion: nil,
                                               headerFields: nil)
        
        do {
            let _: MockResponseModel = try await apiClient.request(MockEndpoint.example)
            XCTFail("Expected server error, but request succeeded")
        } catch APIError.serverError {
            // Success
        } catch {
            XCTFail("Expected server error, but got \(error)")
        }
    }
    
    func testRequestHandlesClientError() async {
        mockSession.response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                               statusCode: 404,
                                               httpVersion: nil,
                                               headerFields: nil)
        
        do {
            let _: MockResponseModel = try await apiClient.request(MockEndpoint.example)
            XCTFail("Expected server error, but request succeeded")
        } catch APIError.clientError(let message) {
            XCTAssertEqual(message, "Invalid URL")
        } catch {
            XCTFail("Expected server error, but got \(error)")
        }
    }
}
