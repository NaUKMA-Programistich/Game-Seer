import SwiftUI
import PhotosUI

struct ChooserGameScreen: View {
    @State private var pickedImage: PhotosPickerItem?
    @State private var chooserImage: Data?
    @State private var isGetInfoOpen: Bool = false

    var body: some View {
        NavigationStack{
            
   
        VStack {
            ProgramLabel()
            Spacer()
            ImageView()
            Spacer()
            HStack {
                Spacer()
                PhotoPickerView()
                Spacer()
                GetInfoButton()
                    .navigationDestination(isPresented: $isGetInfoOpen){
                        InfoGameScreen(image: chooserImage)
                    }
                Spacer()
            }
        }
        .onChange(of: pickedImage) { image in
            Task {
                guard let data = try? await pickedImage?.loadTransferable(type: Data.self) else { return }
                chooserImage = data
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.green]), startPoint: .top, endPoint: .bottom))
        }
        
    }

    @ViewBuilder
    func ImageView() -> some View {
        if let image = chooserImage, let uiImage = UIImage(data: image) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .overlay(
                    Rectangle()
                    .stroke(Color.white, lineWidth: 4)
                )
        }
        else {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250, alignment: .center)
        }
            
    }
    
    @ViewBuilder
    func ProgramLabel() -> some View {
        Text("Game Seer")
            .font(.title)
            .bold()
            .padding()
            .foregroundColor(Color.white)
    }
    
    
    @ViewBuilder
    func PhotoPickerView() -> some View {
        PhotosPicker(selection: $pickedImage, matching: .images) {
            Label("Choose ", systemImage: "photo")
        }
        .foregroundColor(Color.white)
        .padding()
        .background(Color.blue)
        .cornerRadius(12)
    }

    @ViewBuilder
    func GetInfoButton() -> some View {
        Button
        {
            isGetInfoOpen = true
        } label:{
            Image(systemName: "eye")
            Text("Predict")
        }
        .foregroundColor(Color.white)
        .padding()
        .background(Color.blue)
        .opacity(pickedImage == nil ? 0.7 : 1)
        .disabled(pickedImage == nil)
        .cornerRadius(12)
        
    }
}

struct ChooserGameScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChooserGameScreen()
    }
}
