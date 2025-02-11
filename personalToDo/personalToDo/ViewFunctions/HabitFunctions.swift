import SwiftUI

struct Habit: Identifiable {
    let id = UUID()
    var name: String
    var targetDays: Int
    var completedDates: Set<Date>
    var startDate: Date
    
    var currentStreak: Int {
        var streak = 0
        let calendar = Calendar.current
        var currentDate = calendar.startOfDay(for: Date())
        
        while completedDates.contains(currentDate) {
            streak += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDate) else { break }
            currentDate = previousDay
        }
        
        return streak
    }
}

struct HabitCard: View {
    @Binding var habit: Habit
    private let calendar = Calendar.current
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(habit.name)
                .font(.headline)
            
            Text("Target: \(habit.targetDays) days")
                .foregroundColor(.secondary)
            
            Text("Current Streak: \(habit.currentStreak) days")
                .foregroundColor(.secondary)
            
            // Weekly Progress
            HStack(spacing: 8) {
                ForEach(-6...0, id: \.self) { dayOffset in
                    let date = calendar.date(byAdding: .day, value: dayOffset, to: Date()) ?? Date()
                    DayCircle(
                        date: date,
                        isCompleted: habit.completedDates.contains(calendar.startOfDay(for: date)),
                        action: {
                            toggleCompletion(for: date)
                        }
                    )
                }
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func toggleCompletion(for date: Date) {
        let startOfDay = calendar.startOfDay(for: date)
        if habit.completedDates.contains(startOfDay) {
            habit.completedDates.remove(startOfDay)
        } else {
            habit.completedDates.insert(startOfDay)
        }
    }
}

struct DayCircle: View {
    let date: Date
    let isCompleted: Bool
    let action: () -> Void
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: action) {
            VStack {
                Text("\(calendar.component(.day, from: date))")
                    .font(.caption2)
                Circle()
                    .fill(isCompleted ? Color.green : Color.clear)
                    .overlay(Circle().stroke(Color.green, lineWidth: 1))
                    .frame(width: 20, height: 20)
            }
        }
        .buttonStyle(.plain)
    }
} 