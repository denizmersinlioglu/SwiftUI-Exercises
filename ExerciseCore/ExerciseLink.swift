//
//  ExerciseLink.swift
//  ExerciseCore
//
//  Created by Deniz Mersinlioğlu on 30.05.2021.
//

import SwiftUI

// MARK: - ExerciseLink

public struct ExerciseLink<Content>: View where Content: View {
	// MARK: Properties

	let title: String
	let content: Content

	// MARK: Life Cycle

	public init(title: String, @ViewBuilder _ content: () -> Content) {
		self.title = title
		self.content = content()
	}

	// MARK: Render

	public var body: some View {
		NavigationLink(
			destination: content,
			label: { Text(title) }
		)
	}
}

// MARK: - ExerciseLink_Previews

struct ExerciseLink_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			List {
				ExerciseLink(title: "Awesome 🚀") { EmptyView() }
				ExerciseLink(title: "Cool 🏄🏻‍♂️") { EmptyView() }
				ExerciseLink(title: "Nice 👍🏻") { EmptyView() }
			}.navigationTitle("Exercises")
		}
	}
}
