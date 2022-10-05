import Foundation

struct JournalEntry: Identifiable {
    var id = UUID()
    var title: String
    var content: String
    var date: Date
}
