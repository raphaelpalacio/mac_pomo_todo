import SwiftUI

struct TasksView: View {
    @State private var tasks: [Task] = []
    @State private var showingNewTaskSheet = false
    @State private var newTaskTitle = ""
    @State private var newTaskDueDate: Date = Date()
    @State private var newTaskNotes = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Tasks")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: { showingNewTaskSheet = true }) {
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.large)
                }
            }
            .padding()
            
            // Tasks List
            List {
                ForEach($tasks) { $task in
                    TaskRow(task: $task)
                }
                .onDelete(perform: deleteTasks)
            }
        }
        .sheet(isPresented: $showingNewTaskSheet) {
            NavigationView {
                VStack(spacing: 24) {
                    Text("New Task")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                    
                    Form {
                        Section {
                            TextField("Task Title", text: $newTaskTitle)
                                .textFieldStyle(.roundedBorder)
                                .font(.title3)
                                .padding(.vertical, 8)
                        } header: {
                            Text("Title")
                                .font(.headline)
                        }
                        
                        Section {
                            DatePicker("Select Date", selection: $newTaskDueDate, displayedComponents: [.date])
                                .datePickerStyle(.graphical)
                        } header: {
                            Text("Due Date")
                                .font(.headline)
                        }
                        
                        Section {
                            TextField("Add any additional notes here...", text: $newTaskNotes, axis: .vertical)
                                .textFieldStyle(.roundedBorder)
                                .frame(height: 100)
                                .font(.body)
                        } header: {
                            Text("Notes")
                                .font(.headline)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    
                    HStack(spacing: 20) {
                        Button("Cancel") {
                            showingNewTaskSheet = false
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        
                        Button("Add Task") {
                            addTask()
                            showingNewTaskSheet = false
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .disabled(newTaskTitle.isEmpty)
                    }
                    .padding(.bottom, 20)
                }
                .frame(minWidth: 400, minHeight: 600)
                .padding()
            }
        }
    }
    
    private func addTask() {
        let task = Task(
            title: newTaskTitle,
            isCompleted: false,
            dueDate: newTaskDueDate,
            notes: newTaskNotes.isEmpty ? nil : newTaskNotes
        )
        tasks.append(task)
        newTaskTitle = ""
        newTaskNotes = ""
        newTaskDueDate = Date()
    }
    
    private func deleteTasks(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
}

#Preview {
    TasksView()
} 