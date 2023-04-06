//
//  Created by Cristiano Calicchia on 17/03/23.
//

import SwiftUI
import Combine

struct DashboardView: View {
	
	init(viewModel: DashboardViewModel) {
		self.viewModel = viewModel
	}
	
	@ObservedObject var viewModel: DashboardViewModel
	@State var searchText: String = ""

	var body: some View {
		ZStack {
			
			Rectangle()
				.fill(appBackground)
				.edgesIgnoringSafeArea(.all)

			ScrollView {
				VStack(alignment: .center) {
					HStack {
						Spacer()
						
						Text("Beers")
							.font(.title).bold()
						
						Spacer()
						
						Button {
							Task {
								await viewModel.getData()
							}
						} label: {
							Image(systemName: "arrow.clockwise")
								.font(.title2.bold())
						}
					}
					.padding(.horizontal)
					
					SearchBar(text: $searchText)
						.padding(.horizontal)
					
					if viewModel.isLoading {
						ShimmerGMBNRowView()
					} else {
						ForEach(Array(viewModel.beers.filter({ searchText == "" ? true : ($0.name.lowercased().contains(searchText.lowercased()) || $0.description.lowercased().contains(searchText.lowercased())) }).enumerated()), id: \.offset) { _,beer in
							BeerRow(beer: beer)
								.onNavigation { viewModel.open(beer) }
								.padding(.horizontal)
								.padding(.bottom, 4)
						}
					}
				}
			}
		}
		.onAppear {
			viewModel.onAppear()
		}
		.alert(isPresented: $viewModel.networkErrorAlert) {
			Alert(title: Text("Error"), message: Text(viewModel.apiError?.errorDescription ?? "Generic Error"), dismissButton: .default(Text("Try again!")) {
				Task {
					await viewModel.getData()
				}
			})
		}
		.navigationBarHidden(true)
	}
}

struct BeerRow : View {

	var beer: Beer

	var body: some View {

		ZStack {
			RoundedRectangle(cornerRadius: 16).fill(secondaryBackgroundColor)
			
			HStack {
				if let url = URL(string: beer.image_url) {
					Image(systemName: "placeholder image")
						.data(url: url)
						.aspectRatio(contentMode: .fit)
						.frame(height: 50)
				}
				VStack {
					Text(beer.name)
						.font(.headline.bold())
						.foregroundColor(customAccentColor)
					Text(beer.description)
						.font(.caption.bold())
						.foregroundColor(customAccentColor)
					HStack {
						Text("ABV: \(getAbv(abv: beer.abv))")
						Text("IBU: \(getIbu(ibu: beer.ibu))")
					}
					.font(.headline.bold())
					.foregroundColor(customAccentColor)
				}
				Spacer()
			}
			.padding(8)
		}
		.cornerRadius(6)
	}
	
	func getAbv(abv: Double?) -> String {
		guard let abv = abv else {
			return "N/A"
		}
		
		return String(abv)
	}
	
	func getIbu(ibu: Double?) -> String {
		guard let ibu = ibu else {
			return "N/A"
		}
		
		return String(ibu)
	}

}

//MARK: Shimmer

struct ShimmerGMBNRowView: View {
	
	@ViewBuilder
	private var shimmerRow: some View {
		ShimmerView()
			.frame(height:200)
			.padding(.horizontal)
			.padding(.bottom, 4)
	}
	
	var body: some View {
	
		ScrollView {
			
			ForEach(1..<20) {_ in
				shimmerRow
			}
			
		}
		
	}
}

//struct ContentView_Preview: PreviewProvider {
//	static var previews: some View {
//		CountriesView(viewModel: CountriesViewModel(dataProvider: DataProvider()))
//	}
//}
