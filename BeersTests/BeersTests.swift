//
//  Created by Cristiano Calicchia on 31/01/23.
//

import XCTest
import Combine
@testable import Beers

final class BeersTests: XCTestCase {
	
	func testFetchVideosService_KO() async throws {
		do {
			let sut = DataProvider(communicationManager: CommunicationManagerMock(success: false))
			try await sut.fetchBeers()
		} catch {
			let error = error as? APIError
			XCTAssertTrue(error == .apiError(reason: "Unknown error"))
		}
	}
	
	func testFetchVideosService_OK() async throws {
		do {
			var beers : Beers? = nil
			let sut = DataProvider(communicationManager: CommunicationManagerMock(success: true))
			beers = try await sut.fetchBeers()
			XCTAssertTrue(beers != nil)
		} catch {
			XCTAssertTrue(false)
		}
	}

}

class CommunicationManagerMock : CommunicationManagerProtocol {
	let success: Bool
	
	init(success: Bool) {
		self.success = success
	}
	
	func fetch<T>(url: URL) -> AnyPublisher<T, APIError> where T : Decodable {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		
		return fetch(url: url)
			.decode(type: T.self, decoder: decoder)
			.mapError { error in
				if let error = error as? DecodingError {
					var errorToReport = error.localizedDescription
					switch error {
					case .dataCorrupted(let context):
						let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
						errorToReport = "\(context.debugDescription) - (\(details))"
					case .keyNotFound(let key, let context):
						let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
						errorToReport = "\(context.debugDescription) (key: \(key), \(details))"
					case .typeMismatch(let type, let context), .valueNotFound(let type, let context):
						let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
						errorToReport = "\(context.debugDescription) (type: \(type), \(details))"
					@unknown default:
						break
					}
					return APIError.parserError(reason: errorToReport)
				}  else {
					return APIError.apiError(reason: error.localizedDescription)
				}
			}
			.eraseToAnyPublisher()
	}
	
	func fetch(url: URL) -> AnyPublisher<Data, APIError> {
		let request = URLRequest(url: url)

		return URLSession.DataTaskPublisher(request: request, session: .shared)
			.tryMap { data, response in
				if !self.success {
					throw APIError.unknown
				}
				return data
			}
			.mapError { error in
				if let error = error as? APIError {
					return error
				} else {
					return APIError.apiError(reason: error.localizedDescription)
				}
			}
			.eraseToAnyPublisher()
	}
	
}
