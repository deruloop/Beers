//
//  Created by Cristiano Calicchia on 12/12/22.
//

import Foundation
import SwiftUI

private struct GradientConstants {
	static let color0 = Color(red: 210/255, green: 210/255, blue: 210/255)
	static let color1 = Color(red: 255/255, green: 255/255, blue: 255/255)
}

public var appBackground: LinearGradient {
	return LinearGradient(
		gradient: Gradient(colors: [GradientConstants.color0, GradientConstants.color1]),
		startPoint: .init(x: 0.50, y: 0.00),
		endPoint: .init(x: 0.50, y: 1.00)
	)
}

public var customAccentColor: Color {
	return Color(UIColor(red: 0/255, green: 0/255, blue: 0/255 , alpha: 1))
}

public var secondaryBackgroundColor: Color {
	return Color(UIColor(red: 180/255, green: 180/255, blue: 180/255 , alpha: 1))
}

public var navBarColor: UIColor {
	return UIColor(red: 180/255, green: 180/255, blue: 180/255 , alpha: 1)
}
