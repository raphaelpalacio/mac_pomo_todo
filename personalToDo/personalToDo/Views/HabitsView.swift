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

struct HabitsView: View {
    @State private var habits: [Habit] = []
    @State private var showingNewHabitSheet = false
    @State private var newHabitName = ""
    @State private var newHabitTargetDays = 1
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Habits")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: { showingNewHabitSheet = true }) {
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.large)
                }
            }
            .padding()
            
            // Habits Grid
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 300, maximum: 400), spacing: 16)
                ], spacing: 16) {
                    ForEach($habits) { $habit in
                        HabitCard(habit: $habit)
                    }
                }
                .padding()
            }
        }
        .sheet(isPresented: $showingNewHabitSheet) {
            NavigationView {
                VStack(spacing: 24) {
                    Text("New Habit")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                    
                    Form {
                        Section {
                            TextField("Habit Name", text: $newHabitName)
                                .textFieldStyle(.roundedBorder)
                                .font(.title3)
                                .padding(.vertical, 8)
                        } header: {
                            Text("Name")
                                .font(.headline)
                        }
                        
                        Section {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Target Days: \(newHabitTargetDays)")
                                    .font(.headline)
                                
                                Slider(value: .init(
                                    get: { Double(newHabitTargetDays) },
                                    set: { newHabitTargetDays = Int($0) }
                                ), in: 1...365, step: 1)
                                
                                Text("How many days would you like to maintain this habit?")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 8)
                        } header: {
                            Text("Goal")
                                .font(.headline)
                        }
                        
                        Section {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Tips for building habits:")
                                    .font(.headline)
                                
                                Text("• Start small and be consistent")
                                Text("• Track your progress daily")
                                Text("• Celebrate small wins")
                                Text("• Focus on one habit at a time")
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    
                    HStack(spacing: 20) {
                        Button("Cancel") {
                            showingNewHabitSheet = false
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        
                        Button("Create Habit") {
                            addHabit()
                            showingNewHabitSheet = false
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .disabled(newHabitName.isEmpty)
                    }
                    .padding(.bottom, 20)
                }
                .frame(minWidth: 400, minHeight: 600)
                .padding()
            }
        }
    }
    
    private func addHabit() {
        let habit = Habit(
            name: newHabitName,
            targetDays: newHabitTargetDays,
            completedDates: [],
            startDate: Date()
        )
        habits.append(habit)
        newHabitName = ""
        newHabitTargetDays = 1
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