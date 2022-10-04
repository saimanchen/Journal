import SwiftUI

struct ContentView: View {
    var journal = Journal()
    
    var body: some View {
        ZStack {
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
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
