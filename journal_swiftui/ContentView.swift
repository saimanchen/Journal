import SwiftUI

struct ContentView: View {
    @StateObject var journal = Journal()
    @State var showPopUp: Bool = false
    
    var body: some View {
        ZStack {
            MainContentView(journal: journal, showPopUp: $showPopUp)
            
            if showPopUp {
                PopUpView(journal: journal, showPopUp: $showPopUp)
            }
           
        }
    }
}


struct MainContentView: View {
    @ObservedObject var journal: Journal
    @Binding var showPopUp: Bool
    @State var isAnimated: Bool = false
    
    var body: some View {
        VStack {
            Text("My Journal")
                .font(.title)
                .bold()
                .opacity(showPopUp ? 0 : 1)
            List() {
                ForEach(journal.getAllEntries()) {
                    entry in
                    
                    Text(entry.title)
                }
            }.listStyle(.plain)
            Button("Add Entry") {
                withAnimation(.default) {
                    isAnimated.toggle()
                    showPopUp = true
                }
            }
            .padding()
            .frame(width: 200, height: 50, alignment: .center)
            .background(.brown)
            .foregroundColor(.white)
            .cornerRadius(7)
            .opacity(showPopUp ? 0 : 1)
            
            Spacer()
        }
    }
}

struct PopUpView: View {
    @ObservedObject var journal: Journal
    @Binding var showPopUp: Bool
    @State var title = ""
    @State var content = ""
    @State var isAnimated: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            Text("Add Entry")
                .font(.title)
                .bold()
            Spacer()
            VStack (alignment: .leading) {
                Text("Title")
                TextField("", text: $title)
                    .frame(
                        width: UIScreen.main.bounds.width * 0.80
                    )
                    .textFieldStyle(.roundedBorder)
                    .foregroundColor(.brown)
                Text("Content")
                
                TextEditor(text: $content)
                    .frame(
                        width: UIScreen.main.bounds.width * 0.80,
                        height: UIScreen.main.bounds.height * 0.40
                    )
                    .cornerRadius(4)
                    .foregroundColor(.brown)
            }
            
            Spacer()
            
            Button(action: {
                withAnimation(.default) {
                    isAnimated.toggle()
                    if title == "" || content == "" {
                                       return
                                   }
                                   
                    journal.addEntry(entry: JournalEntry(title: title, content: content, date: Date()))
                                   
                    showPopUp = false
                }
               
            }, label: {
                Text("Save")
            }).padding().background(.white).foregroundColor(.brown).cornerRadius(7)
            
            Button(action: {
                withAnimation() {
                    isAnimated.toggle()
                    showPopUp = false
                }
                
            }, label: {
                Text("Cancel")
            })
            
            Spacer()
        }
        .frame(
            width: UIScreen.main.bounds.width * 0.9,
            height: UIScreen.main.bounds.height * 0.8,
            alignment: .center)
        .background(.ultraThinMaterial)
        .foregroundColor(.black)
        .cornerRadius(7)
        .transition(.scale)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
