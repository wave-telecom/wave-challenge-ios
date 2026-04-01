import SwiftUI

struct PokemonListView: View {
    @ObservedObject var viewModel: PokemonListViewModel

    var body: some View {
        content
            .task {
                viewModel.loadIfNeeded()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Loading pokemon...")
        case .error(let message):
            ErrorStateView(message: message, retryTitle: "Tentar novamente") {
                viewModel.retry()
            }
            .padding()
        case .success(let items):
            List(items) { item in
                NavigationLink(value: item.id) {
                    PokemonRowView(item: item)
                }
            }
            .navigationDestination(for: String.self) { name in
                PokemonDetailView(viewModel: AppContainer.shared.makePokemonDetailViewModel(name: name))
            }
        }
    }
}

private struct PokemonRowView: View {
    let item: PokemonListItem

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: item.spriteURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure(_):
                    placeholder
                case .empty:
                    placeholder
                @unknown default:
                    placeholder
                }
            }
            .frame(width: 64, height: 64)

            Text(item.name)
                .font(.body)
        }
    }

    private var placeholder: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.2))
            .overlay {
                ProgressView()
            }
    }
}
