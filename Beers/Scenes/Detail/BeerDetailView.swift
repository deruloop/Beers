//
//  Created by Cristiano Calicchia on 17/03/23.
//

import SwiftUI

struct BeerDetailView: View {
	
	@ObservedObject var viewModel: BeerDetailViewModel
	
	var body: some View {
		
		ZStack(alignment: .top) {
			Rectangle()
				.fill(appBackground)
				.edgesIgnoringSafeArea(.all)

			ScrollView {
				VStack(alignment: .center, spacing: 6) {
					if let url = URL(string: viewModel.beer.image_url) {
						Image(systemName: "placeholder image")
							.data(url: url)
							.aspectRatio(contentMode: .fit)
							.frame(height: 140)
					}
					Text(viewModel.beer.description)
						.font(.body)
						.multilineTextAlignment(.center)
					
					Text("First Brewed")
						.font(.headline)
					Text(viewModel.beer.first_brewed)
						.font(.body)
					
					Text("Brewers Tips")
						.font(.headline)
					Text(viewModel.beer.brewers_tips)
						.font(.body)
						.multilineTextAlignment(.center)
					
					Text("Food Pairing")
						.font(.headline)
					ForEach(Array(viewModel.beer.food_pairing.enumerated()), id: \.offset) { _,food_pairing in
						Text(food_pairing)
							.font(.body)
					}
					
				}
				.padding(.horizontal)
			}
			.foregroundColor(customAccentColor)
		}
		.onAppear {
			viewModel.onAppear()
			let appearance = UINavigationBarAppearance()
				appearance.configureWithTransparentBackground()
				appearance.backgroundColor = navBarColor.withAlphaComponent(0.65)
				UINavigationBar.appearance().standardAppearance = appearance
		}
		.alert(isPresented: $viewModel.networkErrorAlert) {
			Alert(title: Text("Error"), message: Text(viewModel.apiError?.errorDescription ?? "Generic Error"), dismissButton: .default(Text("Ok")) {
			})
		}
		.navigationTitle(Text(viewModel.beer.name))
	}
}
