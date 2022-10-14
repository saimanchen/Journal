import Foundation
import Firebase

class DatabaseConnection: ObservableObject {
    private var db = Firestore.firestore()
    
    @Published var userLoggedIn = false
    @Published var currentUser: User?
    @Published var userDocument: UserDocument?
    
    // nil as long as user is logged out
    var userDocumentListener: ListenerRegistration?
    
    init() {
        // to see if user is logged in or not
        do {
            try Auth.auth().signOut()
        } catch {
            print("logged out")
        }
        
        Auth.auth().addStateDidChangeListener {
            auth, user in
            
            if let user = user {
                self.userLoggedIn = true
                self.currentUser = user
                self.listenToDatabase()
                
            } else {
                self.userLoggedIn = false
                self.currentUser = nil
                self.stopListenToDatabase()
            }
        }
    }
    
    func registerUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) {
            authDataResult, error in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let authDataResult = authDataResult {
                let newUserDocument = UserDocument(id: authDataResult.user.uid, entries: [])
                
                do {
                    _ = try self.db.collection("userData")
                        .document(authDataResult.user.uid)
                        .setData(from: newUserDocument)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func loginUser(email:String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) {
            result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    func stopListenToDatabase() {
        if let userDocumentListener = userDocumentListener {
            userDocumentListener.remove()
        }
    }
    
    func listenToDatabase() {
        if let currentUser = currentUser {
            userDocumentListener = self.db
                .collection("userData")
                .document(currentUser.uid)
                .addSnapshotListener {
                snapshot, error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    guard let snapshot = snapshot else { return }
                    
                    let result = Result {
                        try snapshot.data(as: UserDocument.self)
                    }
                    
                    switch result {
                    case .success(let userData):
                        self.userDocument = userData
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                        break
                    }
            }
        }
    }
    
    func addEntryToDatabase(entry: JournalEntry) {
        // NOTES TO MYSELF
        // FieldValue.arrayUnion([Firestore.Encoder().encode(entry)])])
        // to append a custom object to firebase
        
        // db.collection("userData").document(currentUser.uid) -> get document in our collection, that has the same name as the user ID

        // updateData -> update value of a field and vi write a dictionary, where we get a specific fieldname
        
        if let currentUser = currentUser {
            do {
                try db.collection("userData")
                    .document(currentUser.uid)
                    .updateData(["entries": FieldValue.arrayUnion([Firestore.Encoder().encode(entry)])])
            } catch {
                print("Tystnad")
            }
        }
    }
}
