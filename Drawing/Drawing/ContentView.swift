//
//  ContentView.swift
//  Drawing
//
//  Created by Enzo Herrera on 9/8/21.
//

import SwiftUI

//struct Flower: Shape {
//	// How much to move this petal away from the center
//	var petalOffset: Double = -20
//
//	// How wide to make each petal
//	var petalWidth: Double = 100
//
//	func path(in rect: CGRect) -> Path {
//		// The path that will hold all petals
//		var path = Path()
//
//		// Count from 0 up to pi * 2, moving up pi / 8 each time
//		for number in stride(from: 0, to: CGFloat.pi * 2, by: CGFloat.pi / 8) {
//			// rotate the petal by the current value of our loop
//			let rotation = CGAffineTransform(rotationAngle: number)
//
//			// move the petal to be at the center of our view
//			let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))
//
//			// create a path for this petal using our properties plus a fixed Y and height
//			let originalPetal = Path(ellipseIn: CGRect(x: CGFloat(petalOffset), y: 0, width: CGFloat(petalWidth), height: rect.width / 2))
//
//			// apply our rotation/position transformation to the petal
//			let rotatedPetal = originalPetal.applying(position)
//
//			// add it to our main path
//			path.addPath(rotatedPetal)
//		}
//
//		// now send the main path back
//		return path
//	}
//}

//struct ColorCyclingCircle: View {
//	var amount = 0.0
//	var steps = 100
//
//	var body: some View {
//		ZStack {
//			ForEach(0..<steps) { value in
//				Circle()
//					.inset(by: CGFloat(value))
//					.strokeBorder(LinearGradient(gradient: Gradient(colors: [
//						self.color(for: value, brightness: 1),
//						self.color(for: value, brightness: 0.5)
//					]), startPoint: .top, endPoint: .bottom), lineWidth: 2)
//			}
//		}
//		.drawingGroup()
//	}
//
//	func color(for value: Int, brightness: Double) -> Color {
//		var targetHue = Double(value) / Double(self.steps) + self.amount
//
//		if targetHue > 1 {
//			targetHue -= 1
//		}
//
//		return Color(hue: targetHue, saturation: 1, brightness: brightness)
//	}
//}

//struct Trapezoid: Shape {
//	var insetAmount: CGFloat
//
//	var animatableData: CGFloat {
//		get { insetAmount }
//		set { self.insetAmount = newValue }
//	}
//
//	func path(in rect: CGRect) -> Path {
//		var path = Path()
//
//		path.move(to: CGPoint(x: 0, y: rect.maxY))
//		path.addLine(to: CGPoint(x: insetAmount, y: rect.minY))
//		path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
//		path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
//		path.addLine(to: CGPoint(x: 0, y: rect.maxY))
//
//		return path
//   }
//}

//struct Checkerboard: Shape {
//	var rows: Int
//	var columns: Int
//
//
//
//
//	public var animatableData: AnimatablePair<Double, Double> {
//		get {
//		   AnimatablePair(Double(rows), Double(columns))
//		}
//
//		set {
//			self.rows = Int(newValue.first)
//			self.columns = Int(newValue.second)
//		}
//	}
//
//	func path(in rect: CGRect) -> Path {
//		var path = Path()
//
//		// figure out how big each row/column needs to be
//		let rowSize = rect.height / CGFloat(rows)
//		let columnSize = rect.width / CGFloat(columns)
//
//		// loop over all rows and columns, making alternating squares colored
//		for row in 0..<rows {
//			for column in 0..<columns {
//				if (row + column).isMultiple(of: 2) {
//					// this square should be colored; add a rectangle here
//					let startX = columnSize * CGFloat(column)
//					let startY = rowSize * CGFloat(row)
//
//					let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)
//					path.addRect(rect)
//				}
//			}
//		}
//
//		return path
//	}
//}

//struct Spirograph: Shape {
//	let innerRadius: Int
//	let outerRadius: Int
//	let distance: Int
//	let amount: CGFloat
//}
//
//func gcd(_ a: Int, _ b: Int) -> Int {
//	var a = a
//	var b = b
//
//	while b != 0 {
//		let temp = b
//		b = a % b
//		a = temp
//	}
//
//	return a
//}

//struct Arrow: Shape {
//	func path(in rect: CGRect) -> Path {
//		var path = Path()
//
//		path.move(to: CGPoint(x: rect.midX, y: rect.minY))
//		path.addLine(to: CGPoint(x: rect.minX + 100, y: rect.maxY - 150))
//		path.addLine(to: CGPoint(x: rect.maxX - 100, y: rect.maxY - 150))
//		path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
//
//		path.move(to: CGPoint(x: rect.midX, y: rect.maxY - 150))
//		path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
//
//		return path
//	}
//}

struct ColorCyclingRectangle: View {
	var amount = 0.0
	var steps: Double

	var body: some View {
		ZStack {
			ForEach(0..<Int(steps)) { value in
				Rectangle()
					.inset(by: CGFloat(value))
					.strokeBorder(LinearGradient(gradient: Gradient(colors: [
						self.color(for: value, brightness: 1),
						self.color(for: value, brightness: 0.5)
					]), startPoint: .top, endPoint: .bottom), lineWidth: 2)
			}
		}
		.drawingGroup()
	}

	func color(for value: Int, brightness: Double) -> Color {
		var targetHue = Double(value) / Double(self.steps) + self.amount

		if targetHue > 1 {
			targetHue -= 1
		}

		return Color(hue: targetHue, saturation: 1, brightness: brightness)
	}
}

struct ContentView: View {

	@State var gradientSteps: Double = 100

	var body: some View {
		VStack {
			ColorCyclingRectangle(steps: gradientSteps)
				.frame(width: 500, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
			Slider(value: $gradientSteps, in: 100...500) {
				Text("Pick you size")
			}

		}

	}


	struct ContentView_Previews: PreviewProvider {
		static var previews: some View {
			ContentView()
		}
	}
}

