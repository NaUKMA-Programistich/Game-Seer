
import SwiftUI

struct InfoGameScreen: View {
    let image: Data?
    
    @State private var game: Game?
    private let service: GamesService = .shared

    var body: some View {
        if game == nil {
            LoadingView()
                .onAppear(perform: processGames)
        }
        else {
            ScrollView {
                GameView(game: game!)
            }
        }
    }

    @ViewBuilder
    func GameView(game: Game) -> some View {
        VStack {
            Image(uiImage: UIImage(data: image ?? Data()) ?? UIImage())
                .resizable()
                .scaledToFit()
            HStack {
                Text(game.name)
                Spacer()
                Text(game.percentage)
            }
            .padding()
            Text(game.description)
            Divider()
        }
        .padding([.horizontal], 8)

    }

    @ViewBuilder
    func LoadingView() -> some View {
        ProgressView()
    }


    private func processGames() {
        service.processImage(image: image) { self.game = $0 }
    }
}

struct InfoGameScreen_Previews: PreviewProvider {
    static var previews: some View {
        InfoGameScreen(image: Data())
    }
}
