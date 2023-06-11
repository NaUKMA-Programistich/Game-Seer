
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
            .background(Color(red: 235/255, green: 230/255, blue: 224/255))
        }
    }

    @ViewBuilder
    func GameView(game: Game) -> some View {
        VStack {
            HStack{
                Spacer()
                Text(game.name)
                    .font(.title)
                    .bold()
                    .foregroundColor(Color.black)
                Spacer()
            }
            Image(uiImage: UIImage(data: image ?? Data()) ?? UIImage())
                .resizable()
                .scaledToFit()
                .overlay(
                    Rectangle()
                    .stroke(Color.white, lineWidth: 4)
                )
            HStack {
                Text("Confidence percentage: \(game.percentage)")
                    .font(.body)
                Spacer()
                
            }
            .foregroundColor(Color.black)
            DividerWithCustomVerticalPaddings(value: 8)
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
            DividerWithCustomVerticalPaddings(value: 8)
            InfoBlock(title: "Supported languages:", textInfo: game.languages)
            GameLinkView(linkName: "For more info visit steam store page", id: game.id)
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
            DividerWithCustomVerticalPaddings(value: 8)
        }
    }

    @ViewBuilder
    func LoadingView() -> some View {
        ProgressView()
    }
    
    @ViewBuilder
    func DividerWithCustomVerticalPaddings(value: CGFloat) -> some View{
        Divider()
            .padding([.vertical], value)
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
