import SwiftUI

// MARK: ContentView
struct ContentView: View {
    @StateObject var databaseConnection = DatabaseConnection()
    @State var showPopup = false
    
    var body: some View {
        ZStack {
            if databaseConnection.userLoggedIn {
                MainContentView(databaseConnection: databaseConnection, showPopup: $showPopup)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("Journal")
                    .toolbar {
                        ToolbarItem(placement: .automatic, content: {
                            Text("+")
                                .font(.system(size: 32))
                                .onTapGesture {
                                    withAnimation {
                                        showPopup = true
                                    }
                                }
                        })
                    }
            } else {
                LoginView(databaseConnection: databaseConnection)
            }
        }
    }
}

// MARK: MainContentView
struct MainContentView: View {
    @ObservedObject var databaseConnection: DatabaseConnection
    @Binding var showPopup: Bool
    
    var body: some View {
        ZStack {
            if let userDocument = databaseConnection.userDocument {
                List() {
                    ForEach(userDocument.entries) {
                        entry in
                        
                        Text(entry.title)
                    }
                }
            }
            if showPopup {
                PopUpView(databaseConnection: databaseConnection, showPopUp: $showPopup)
            }
        }
    }
}

// MARK: LoginView
struct LoginView: View {
    @ObservedObject var databaseConnection: DatabaseConnection
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    
    var body: some View {
        VStack {
            Text("Login").font(.largeTitle)
            VStack(alignment: .leading) {
                Text("Email")
                TextField("", text: $email)
                    .textFieldStyle(.roundedBorder)
                Text("Password")
                SecureField("", text: $password)
                    .textFieldStyle(.roundedBorder)
            }.padding()
            HStack {
                Button(action: {
                    if email != "" || password != "" {
                        databaseConnection.loginUser(email: email, password: password)
                    }
                }, label: {
                    Text("Login")
                        .frame(width: 150)
                        .padding()
                        .background(.gray)
                        .foregroundColor(.black)
                        .cornerRadius(3)
                })
                NavigationLink(destination: RegisterView(
                    databaseConnection: databaseConnection), label: {
                        Text("Register")
                            .frame(width: 150)
                            .padding()
                            .background(.gray)
                            .foregroundColor(.black)
                            .cornerRadius(3)
                    })
            }
        }
    }
}

// MARK: RegisterView
struct RegisterView: View {
    @ObservedObject var databaseConnection: DatabaseConnection
    
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    var body: some View {
        VStack {
            Text("Register").font(.largeTitle)
            VStack(alignment: .leading) {
                Text("Email")
                TextField("", text: $email)
                    .textFieldStyle(.roundedBorder)
                Text("Password")
                SecureField("", text: $password)
                    .textFieldStyle(.roundedBorder)
                Text("Confirm password")
                SecureField("", text: $confirmPassword)
                    .textFieldStyle(.roundedBorder)
            }.padding()
            
            Button(action: {
                if email != "" && password == confirmPassword {
                    databaseConnection.registerUser(email: email, password: password)
                }
            }, label: {
                Text("Register")
                    .frame(width: 200)
                    .padding()
                    .background(.gray)
                    .foregroundColor(.black)
                    .cornerRadius(3)
            })
        }
    }
}

// MARK: PopupView
struct PopUpView: View {
    @ObservedObject var databaseConnection: DatabaseConnection
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
                Text("Content")
                
                TextEditor(text: $content)
                    .frame(
                        width: UIScreen.main.bounds.width * 0.80,
                        height: UIScreen.main.bounds.height * 0.40
                    )
                    .cornerRadius(4)
            }
            
            Spacer()
            HStack {
                Button(action: {
                    withAnimation(.default) {
                        isAnimated.toggle()
                        if title == "" || content == "" {
                            return
                        }
                        databaseConnection.addEntryToDatabase(entry: JournalEntry(title: title, content: content, date: Date()))
                        
                        showPopUp = false
                    }
                }, label: {
                    Text("Save")
                })
                .frame(width: 150, height: 40)
                .background(.gray)
                .foregroundColor(.white)
                .cornerRadius(3)

                Button(action: {
                    withAnimation() {
                        isAnimated.toggle()
                        showPopUp = false
                    }
                }, label: {
                    Text("Cancel")
                })
                .frame(width: 80, height: 40)
                .background(.white)
                .foregroundColor(.gray)
                .cornerRadius(3)
            }
            
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

// MARK: Preview
struct ContentView_Previews: PreviewProvider {
    @Binding var showPopUp: Bool
    static var previews: some View {
        MainContentView(databaseConnection: DatabaseConnection(), showPopup: .constant(true))
    }
}
