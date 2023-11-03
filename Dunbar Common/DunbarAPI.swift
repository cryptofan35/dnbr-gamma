//
//  DunbarAPI.swift
//  iOS Keyboard
//
//  Created by George Birch on 8/12/23.
//

import Foundation
import OSLog

public protocol DunbarAPI {
    
    func signIn(googleToken: String) async throws -> String
    func getEvents(dnbrToken: String) async throws -> [EventData]
    
}

//TODO: update calls to be to main dnbr server not dev for release
public class DunbarBackendAPI: DunbarAPI {
    
    let urlSession = URLSession.shared
    let logger = Logger(subsystem: "com.withdunbar.iOS-Keyboard", category: "DunbarAPIService")
    
    public init() {}
    
    #if DEBUG
    func createEvent(name: String, dnbrToken: String) async throws {
        let body = EventCreationData(name: name)
        let headers = [("Authorization", "session \(dnbrToken)")]
        let response: EventCreationResponse = try await callAPI(urlString: "https://dev.dnbr.to/api/v1/event/new", httpMethod: "POST", headers: headers, body: body)
        print(response.data.id)
        let touchResponse: TouchResponse = try await callAPI(urlString: "https://dev.dnbr.to/api/v1/event/\(response.data.id)/touch", httpMethod: "POST", headers: headers, body: TouchResponseData())
        print(touchResponse.success)
    }
    #endif
    
    public func signIn(googleToken: String) async throws -> String {
        let body = LoginData(provider: "google", idToken: googleToken)
        let response: LoginResponse = try await callAPI(urlString: "https://dev.dnbr.to/user/login", httpMethod: "POST", body: body)
        return response.token
    }
    
    public func getEvents(dnbrToken: String) async throws -> [EventData] {
        var eventDatas = [EventData]()
        var hasMore = true
        var page = 0
        while hasMore {
            //TODO: update to correct endpoint. correct one doesn't seem to be working atm
//            let urlString = "https://dev.dnbr.to/api/v1/events?mode=recent?page=\(page)"
            let urlString = "https://dev.dnbr.to/api/v1/events?page=\(page)"
            let headers = [("Authorization", "Session \(dnbrToken)")]
            let response: EventResponse = try await callAPI(urlString: urlString, httpMethod: "GET", headers: headers)
            eventDatas += response.data.events
            hasMore = response.data.hasMore
            page = response.data.page + 1
        }
        return eventDatas
    }
    
    private func callAPI<T: Decodable>(urlString: String, httpMethod: String, headers: [(String, String)]? = nil, body: Encodable? = nil) async throws -> T {
        guard let url = URL(string: urlString) else { throw DunbarAPIError.URLGenerationError }
        
        //TODO: maybe change cacheing policy
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let headers = headers {
            headers.forEach { request.setValue($0.1, forHTTPHeaderField: $0.0) }
        }
        
        if let body = body {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
            let jsonData = try jsonEncoder.encode(body)
            request.httpBody = jsonData
        }
        
        let (data, urlResponse) = try await urlSession.data(for: request)
        logger.debug("Raw HTTP response: \(String(data: data, encoding: .utf8) ?? "invalid utf8")")
        guard let urlResponse = urlResponse as? HTTPURLResponse, 200 == urlResponse.statusCode else { throw DunbarAPIError.HTTPBadRequestError }
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let jsonResponse = try jsonDecoder.decode(T.self, from: data)
        return jsonResponse
    }
    
}

struct TouchResponse: Decodable {
    let success: Bool
    let data: TouchResponseData
}

struct TouchResponseData: Codable {}

struct EventCreationResponse: Decodable {
    let success: Bool
    let data: EventCreationResponseData
}

struct EventCreationResponseData: Decodable {
    let id: String
    let sheetUrl: String
    let eventName: String
    let secretKey: String
}

struct EventCreationData: Encodable {
    let name: String?
}

struct EventResponse: Decodable {
    let success: Bool
    let data: EventResponseData
}

struct EventResponseData: Decodable {
    let events: [EventData]
    let hasMore: Bool
    let page: Int
}

public struct EventData: Decodable {
    public let id: String
    public let title: String
    public let startTime: String?
    public let endTime: String?
    public let startDate: String
    public let endDate: String
    public let timezone: String?
    public let location: String?
    public let locationUrl: String?
    public let addToGcalUrl: String
    public let eventUrl: String
    public let description: String?
    public let timeLines: [String]
    let image: ImageData?
}
    
struct ImageData: Decodable {
    let url: String
    let width: Int
    let height: Int
        
    let gifUrl: String
    let isGif: Bool
        
    let thumbnailUrl: String
    let blurhash: String
        
    let ogImageUrl: String
    let ogImageWidth: Int
    let ogImageHeight: Int
}

// TODO: update naming so that "Data" isn't used for inputs and outputs to the API
struct LoginData: Encodable {
    let provider: String
    let idToken: String
    let client = "ios"
}

struct LoginResponse: Decodable {
    let success: Bool
    let token: String
}

enum DunbarAPIError: Error {
    case URLGenerationError
    case HTTPBadRequestError
}
