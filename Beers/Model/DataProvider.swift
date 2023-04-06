//
//  Created by Cristiano Calicchia on 17/03/23.
//

import Foundation
import Combine

protocol DataProviderProtocol {
	func fetchBeers() async throws -> Beers
}

protocol CallServiceCompliant: AnyObject {
	func fetch<T: Decodable>(url: URL) -> AnyPublisher<T, APIError>
}

public class DataProvider : DataProviderProtocol {
	let communicationManager : CommunicationManagerProtocol
	private var cancellables = Set<AnyCancellable>()
	
	init(communicationManager: CommunicationManagerProtocol) {
		self.communicationManager = communicationManager
	}
	
	func fetchBeers() async throws -> Beers {
		
		try await withCheckedThrowingContinuation { continuation in
			
			var components = URLComponents()
			components.scheme = "https"
			components.host = "api.punkapi.com"
			components.path = "/v2/beers"
//			components.queryItems = [
//				URLQueryItem(name: "example", value: "example")
//			]
			
			if let url = components.url {
				communicationManager.fetch(url: url)
					.sink(receiveCompletion: { completion in
						switch completion {
						case .finished:
							break
						case .failure(let error):
							continuation.resume(throwing: error)
						}
					}, receiveValue: { (beers: Beers) in
						continuation.resume(returning: beers)
					})
					.store(in: &cancellables)
			}
			
		}
		
	}
	
}
