//
//  Created by Cristiano Calicchia on 17/03/23.
//

import Foundation
import SwiftUI

class HomeCoordinator: ObservableObject, Identifiable {

	@Published var viewModel: DashboardViewModel!
	@Published var beerDetailViewModel: BeerDetailViewModel?
	
	private let dataProvider: DataProvider
	
	init(title: String,
		 dataProvider: DataProvider) {
		self.dataProvider = dataProvider
		
		self.viewModel = .init(
			title: title,
			dataProvider: dataProvider,
			coordinator: self
		)
	}

	func open(_ beer: Beer) {
		self.beerDetailViewModel = .init(coordinator: self, beer: beer, dataProvider: dataProvider)
	}
	
	func close() {
		self.beerDetailViewModel = nil
	}
	
}
