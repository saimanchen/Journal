import Foundation

struct JournalEntry: Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var date: Date
}
