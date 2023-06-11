
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.green]), startPoint: .top, endPoint: .bottom))
        }
    }

    @ViewBuilder
    func GameView(game: Game) -> some View {
        VStack {
            Image(uiImage: UIImage(data: image ?? Data()) ?? UIImage())
                .resizable()
                .scaledToFit()
                .overlay(
                    Rectangle()
                    .stroke(Color.white, lineWidth: 4)
                )
            HStack {
                Text(game.name)
                Spacer()
                Text(game.percentage)
            }
            .foregroundColor(Color.black)
            Divider()
            InfoBlock(title: "Description:", textInfo: game.description)
            TitleText(text: "Supported platforms:")
            ForEach(Array(game.platforms.keys), id: \.self ) { key in
                if(game.platforms[key] == true){
                    HStack{
                        Text(key)
                            .font(.body)
                            .foregroundColor(Color.black)
                        Spacer()
                    }
                }
            }
            Divider()
            InfoBlock(title: "Supported languages:", textInfo: game.languages)
            TitleText(text: "For more info visit:")
            GameLinkView(linkName: "Steam store page", id: game.id)
        }
        .padding()

    }
    
    @ViewBuilder
    func InfoBlock(title: String, textInfo: String) -> some View{
        VStack{
            TitleText(text: title)
            HStack{
                Text(textInfo)
                    .font(.body)
                    .foregroundColor(Color.black)
                Spacer()
            }
            Divider()
        }
    }

    @ViewBuilder
    func LoadingView() -> some View {
        ProgressView()
    }
    
    @ViewBuilder
    func GameLinkView(linkName: String, id:Int) -> some View{
        HStack {
            if let url = URL(string: "https://store.steampowered.com/app/\(id)") {
                Link(linkName, destination: url)
                    .font(.body)
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    func TitleText(text: String) -> some View{
        HStack{
            Text(text)
                .font(.title2)
                .foregroundColor(Color.black)
            Spacer()
        }
    }


    private func processGames() {
        service.processImage(image: image) {self.game = $0 }
    }
}

struct InfoGameScreen_Previews: PreviewProvider {
    static var previews: some View {
        InfoGameScreen(image: Data())
    }
}
