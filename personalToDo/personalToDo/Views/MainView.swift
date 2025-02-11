import SwiftUI

struct MainView: View {
    @State private var selectedTab: Tab = .calendar
    
    enum Tab {
        case calendar
        case tasks
        case habits
        case settings
    }
    
    var body: some View {
        NavigationSplitView {
            Sidebar(selectedTab: $selectedTab)
        } detail: {
            switch selectedTab {
            case .calendar:
                CalendarView()
            case .tasks:
                TasksView()
            case .habits:
                HabitsView()
            case .settings:
                SettingsView()
            }
        }
    }
}

struct Sidebar: View {
    @Binding var selectedTab: MainView.Tab
    
    var body: some View {
        List(selection: $selectedTab) {
            NavigationLink(value: MainView.Tab.calendar) {
                Label("Calendar", systemImage: "calendar")
            }
            
            NavigationLink(value: MainView.Tab.tasks) {
                Label("Tasks", systemImage: "checklist")
            }
            
            NavigationLink(value: MainView.Tab.habits) {
                Label("Habits", systemImage: "chart.bar.fill")
            }
            
            NavigationLink(value: MainView.Tab.settings) {
                Label("Settings", systemImage: "gear")
            }
        }
        .listStyle(.sidebar)
    }
} 