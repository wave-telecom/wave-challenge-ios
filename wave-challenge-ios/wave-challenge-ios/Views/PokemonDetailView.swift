import SwiftUI

struct PokemonDetailView: View {
    @StateObject private var viewModel: PokemonDetailViewModel

    init(viewModel: PokemonDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    private var imagePlaceholder: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.2))
            .overlay {
                ProgressView()
            }
    }

    var body: some View {
        content
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                viewModel.loadIfNeeded()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Loading details...")
        case .error(let message):
            ErrorStateView(message: message, retryTitle: "Tentar novamente") {
                viewModel.retry()
            }
            .padding()
        case .success(let details):
            Group {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        AsyncImage(url: details.imageURL) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                            case .failure(_):
                                imagePlaceholder
                            case .empty:
                                imagePlaceholder
                            @unknown default:
                                imagePlaceholder
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 180)

                        Text(details.name)
                            .font(.title2.bold())

                        Text(details.typesText)
                        Text(details.abilitiesText)
                        Text(details.statsText)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                }
            }
        }
    }
}
