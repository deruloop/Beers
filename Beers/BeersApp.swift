//
//  Created by Cristiano Calicchia on 17/03/23.
//

import SwiftUI

@main
struct BeersApp: App {
   
	@StateObject var coordinator = HomeCoordinator(title: "Beers", dataProvider: DataProvider(communicationManager: CommunicationManager()))

	var body: some Scene {
		WindowGroup {
			HomeCoordinatorView(coordinator: coordinator)
		}
	}

	
}
