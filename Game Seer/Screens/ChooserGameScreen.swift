import SwiftUI
import PhotosUI

struct ChooserGameScreen: View {
    @State private var pickedImage: PhotosPickerItem?
    @State private var chooserImage: Data?
    @State private var isGetInfoOpen: Bool = false
    @State private var shouldPresentPhotoPicker = false
    @State private var shouldPresentActionChooser = false
    @State private var shouldPresentCamera = false

    var body: some View {
        NavigationStack{
            
   
        VStack {
            ProgramLabel()
            Spacer()
            ImageView()
            Spacer()
            HStack {
                Spacer()
                PhotoPickerButton()
                Spacer()
                GetInfoButton()
                    .navigationDestination(isPresented: $isGetInfoOpen){
                        InfoGameScreen(image: chooserImage)
                    }
                Spacer()
            }
        }
//        .onChange(of: pickedImage) { image in
//            Task {
//                guard let data = try? await pickedImage?.loadTransferable(type: Data.self) else { return }
//                chooserImage = data
//            }
//        }
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
    func PhotoPickerButton() -> some View{
        Button{
           shouldPresentActionChooser = true
        }label: {
            Image(systemName: "photo")
            Text("Choose ")
        }
        .foregroundColor(Color.white)
        .padding()
        .background(Color.blue)
        .cornerRadius(12)
        .sheet(isPresented: $shouldPresentPhotoPicker) {
            PhPickerView(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary,
                            image: self.$chooserImage,
                            isPresented: self.$shouldPresentPhotoPicker)
        }.actionSheet(isPresented: $shouldPresentActionChooser) { () -> ActionSheet in
            ActionSheet(title: Text("Choose mode"), message: Text("Camera or library"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                self.shouldPresentPhotoPicker = true
                self.shouldPresentCamera = true
            }), ActionSheet.Button.default(Text("Photo Library"), action: {
                self.shouldPresentPhotoPicker = true
                self.shouldPresentCamera = false
            }), ActionSheet.Button.cancel()])
        }
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
        .opacity(chooserImage == nil ? 0.7 : 1)
        .disabled(chooserImage == nil)
        .cornerRadius(12)
        
    }
}

struct ChooserGameScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChooserGameScreen()
    }
}
