//
//  Created by Cristiano Calicchia on 17/03/23.
//

import Foundation
import SwiftUI

struct HomeCoordinatorView: View {
	
	@ObservedObject var coordinator: HomeCoordinator
	
	var body: some View {
		NavigationView {
			DashboardView(viewModel: coordinator.viewModel)
				.navigation(item: $coordinator.beerDetailViewModel) { viewModel in
					videoDetailView(viewModel)
				}
		}.accentColor(customAccentColor)
	}
	
	@ViewBuilder
	private func videoDetailView(_ viewModel: BeerDetailViewModel) -> some View {
		BeerDetailView(
			viewModel: viewModel
		)
	}
}
