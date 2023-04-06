//
//  Created by Cristiano Calicchia on 17/03/23.
//

import Foundation

typealias Beers = [Beer]

struct Beer: Codable {
	var id: Int
	var name: String
	var image_url: String
	var description: String
	var abv: Double?
	var ibu: Double?
	var first_brewed: String
	var food_pairing: [String]
	var brewers_tips: String
}
