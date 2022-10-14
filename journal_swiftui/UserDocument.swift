import Foundation
import FirebaseFirestoreSwift

struct UserDocument: Codable, Identifiable {
    @DocumentID var id: String?
    var entries: [JournalEntry]
}

struct JournalEntry: Codable, Identifiable {
    var id = UUID()
    var title: String
    var content: String
    var date: Date
}
