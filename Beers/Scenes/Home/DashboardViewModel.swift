//
//  Created by Cristiano Calicchia on 17/03/23.
//

import Foundation

extension Identifiable where ID: Hashable {
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}

public class DashboardViewModel : ObservableObject {
	
	@Published var title: String
	@Published var beers: Beers = []
	@Published var networkErrorAlert: Bool = false
	@Published var isLoading: Bool = false
	@Published var isLoadingMore: Bool = false
	var apiError: APIError? = nil
	private unowned let coordinator: HomeCoordinator
	
	private var dataProvider: DataProvider
	
	init(title: String, dataProvider: DataProvider, coordinator: HomeCoordinator) {
		self.title = title
		self.dataProvider = dataProvider
		self.coordinator = coordinator
	}
	
	func open(_ beer: Beer) {
		self.coordinator.open(beer)
	}
	
	@MainActor
	func loadNextPage() async {
		isLoadingMore = true
		let beers = await fetchBeers()
		self.beers = self.beers + beers
		isLoadingMore = false
	}
	
	func fetchBeers() async -> Beers {
		
		var beers : Beers = []
		
		do {
			beers = try await dataProvider.fetchBeers()
			
		} catch {
			apiError = error as? APIError
			Task {
				await MainActor.run {
					networkErrorAlert.toggle()
				}
			}
		}
		
		return beers
	}
	
	@MainActor
	func getData() async {
		isLoading = true
		self.beers = await fetchBeers()
		isLoading = false
	}
	
	// MARK: - entrypoint
	func onAppear() {
		
		Task {
			await getData()
		}
		
	}
	
}
