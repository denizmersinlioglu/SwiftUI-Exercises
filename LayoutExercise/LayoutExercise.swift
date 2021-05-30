//
//  LayoutExercise.swift
//  LayoutExercise
//
//  Created by Deniz Mersinlioğlu on 30.05.2021.
//

import SwiftUI

// MARK: - MeasureBehavior

struct MeasureBehavior<Content>: View where Content: View {
	// MARK: Properties

	@State private var width: CGFloat = 100
	@State private var height: CGFloat = 100
	var content: Content

	// MARK: Render

	var body: some View {
		VStack {
			content
				.border(Color.gray)
				.frame(width: width, height: height)
			Slider(value: $width, in: 0 ... 500)
			Slider(value: $height, in: 0 ... 200)
		}
	}
}

// MARK: - LayoutExercise

public struct LayoutExercise: View {
	// MARK: Life Cycle

	public init() {}

	// MARK: Render

	public var body: some View {
		MeasureBehavior(content: Text("Hello world"))
			.padding()
	}
}

// MARK: - LayoutExercise_Previews

struct LayoutExercise_Previews: PreviewProvider {
	static var previews: some View {
		LayoutExercise()
	}
}
