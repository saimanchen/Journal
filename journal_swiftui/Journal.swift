import Foundation

class Journal: ObservableObject {
    @Published private var entries = [JournalEntry]()
    
    func addEntry(entry: JournalEntry) {
        entries.append(entry)
    }
    
    func removeEntryAt(index: Int) {
        entries.remove(at: index)
    }
    
    func getEntryAt(index: Int) -> JournalEntry? {
        return entries[index]
    }
    
    func getEntryByTitle(title: String) -> JournalEntry? {
        for entry in entries {
            if entry.title == title {
                return entry
            }
        }
        return nil
    }
    
    func getAllEntries() -> [JournalEntry] {
        return entries
    }
}
