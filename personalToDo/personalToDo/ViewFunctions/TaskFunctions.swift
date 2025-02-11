import SwiftUI

struct Task: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool
    var dueDate: Date?
    var notes: String?
}

struct TaskRow: View {
    @Binding var task: Task
    
    var body: some View {
        HStack {
            Button(action: { task.isCompleted.toggle() }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .strikethrough(task.isCompleted)
                    .foregroundColor(task.isCompleted ? .gray : .primary)
                
                if let dueDate = task.dueDate {
                    Text(dueDate.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if let notes = task.notes {
                    Text(notes)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
        }
        .padding(.vertical, 4)
    }
} 