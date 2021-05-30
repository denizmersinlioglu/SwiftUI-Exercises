//
//  LayoutExercise.swift
//  LayoutExercise
//
//  Created by Deniz Mersinlioğlu on 30.05.2021.
//

import ExerciseCore
import SwiftUI

// MARK: - MeasureBehavior

struct MeasureBehavior<Content>: View where Content: View {

	// MARK: Properties

	@State private var width: CGFloat = 100
	@State private var height: CGFloat = 100
	var content: Content

	// MARK: Life Cycle

	init(@ViewBuilder _ content: () -> Content) {
		self.content = content()
	}

	// MARK: Render

	var body: some View {
		VStack {
			content
				.border(Color.gray)
				.frame(width: width, height: height)
				.border(Color.red)
			Slider(value: $width, in: 0 ... 500)
			Slider(value: $height, in: 0 ... 200)
		}.padding()
	}
}

// MARK: - Triangle

struct Triangle: View {

	// MARK: Render

	// When one the proposed size is nil, Path will use default value 10
	var body: some View {
		Path { p in
			p.move(to: CGPoint(x: 50, y: 0))
			p.addLines([
				CGPoint(x: 100, y: 75),
				CGPoint(x: 0, y: 75),
				CGPoint(x: 50, y: 0)
			])
		}
	}
}

// MARK: - LayoutExercise

public struct LayoutExercise: View {

	// MARK: Life Cycle

	public init() {}

	// MARK: Render

	public var body: some View {
		List {
			ExerciseLink(title: "Triangle") {
				// Path will use all of the proposed size
				MeasureBehavior { Triangle() }
			}
			ExerciseLink(title: "Text") {
				// Text will use its ideal size inside of proposed size
				MeasureBehavior { Text("Hello world") }
			}
		}.navigationTitle("Layout Exercises")
	}
}

// MARK: - LayoutExercise_Previews

struct LayoutExercise_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			LayoutExercise()
		}
	}
}
