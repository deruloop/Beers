//
//  Created by Cristiano Calicchia on 17/03/23.
//

import Foundation

public class BeerDetailViewModel : ObservableObject, Identifiable {
	
	@Published var beer: Beer
	@Published var networkErrorAlert: Bool = false
	var apiError: APIError? = nil
	private unowned let coordinator: HomeCoordinator
	
	private var dataProvider: DataProvider
	
	init(coordinator: HomeCoordinator, beer: Beer, dataProvider: DataProvider) {
		self.coordinator = coordinator
		self.beer = beer
		self.dataProvider = dataProvider
	}

	func close() {
		self.coordinator.close()
	}

	// MARK: - entrypoint
	func onAppear() {

	}
	
}
