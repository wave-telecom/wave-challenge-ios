//
//  ContentView.swift
//  wave-challenge-ios
//
//  Created by Natalia Piva Vilela on 31/03/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: PokemonListViewModel

    init(viewModel: PokemonListViewModel = AppContainer.shared.makePokemonListViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            PokemonListView(viewModel: viewModel)
                .navigationTitle("Pokedex")
        }
    }
}

#Preview {
    ContentView()
}
