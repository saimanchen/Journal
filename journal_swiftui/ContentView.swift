import SwiftUI

struct ContentView: View {
    @StateObject var journal = Journal()
    
    var body: some View {
        ZStack {
            MainContentView(journal: journal)
            PopUpView()
        }
    }
}


struct MainContentView: View {
    @ObservedObject var journal: Journal
    
    var body: some View {
        VStack {
            Text("My Journal")
                .font(.title)
                .bold()
            List() {
                ForEach(journal.getAllEntries()) {
                    entry in
                    
                    Text(entry.title)
                }
            }
            Button(action: {
                print("button is pressed")
            }, label: {
                Text("Add")
                    .bold()
            })
            .padding()
            .frame(width: 200, height: 50, alignment: .center)
            .background(.black)
            .foregroundColor(.white)
            .cornerRadius(7)
            
            Spacer()
        }
    }
}

struct PopUpView: View {
    @State var title = ""
    @State var content = ""
    
    var body: some View {
        VStack {
            Text("Add Entry")
                .font(.title)
                .bold()
            
            VStack (alignment: .leading) {
                Text("Title")
                TextField("Title", text: $title)
                    .frame(
                        width: UIScreen.main.bounds.width * 0.65
                    )
                    .textFieldStyle(.roundedBorder)
                Text("Content")
                TextField("Content", text: $content)
                    .frame(
                        width: UIScreen.main.bounds.width * 0.65
                    )
                    .textFieldStyle(.roundedBorder)
            }
            
        }
        .frame(
            width: UIScreen.main.bounds.width * 0.8,
            height: UIScreen.main.bounds.height * 0.5,
            alignment: .center)
        .background(.brown)
        .foregroundColor(.white)
        .cornerRadius(7)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
