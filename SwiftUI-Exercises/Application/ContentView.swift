//
//  ContentView.swift
//  SwiftUI-Exercises
//
//  Created by Deniz Mersinlioğlu on 29.05.2021.
//

import SwiftUI
import UpdateViewExercise
import EnvironmentExercise

struct ContentView: View {
    var body: some View {
        EnvironmentExercise()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        UpdateViewExercise()
        EnvironmentExercise()
    }
}
