import SwiftUI

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

#Preview {
    HabitsView()
}