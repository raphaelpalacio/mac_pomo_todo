import SwiftUI

struct CalendarView: View {
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    private let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: geometry.size.height * 0.02) {
                // Month and Year header
                HStack {
                    Button(action: previousMonth) {
                        Image(systemName: "chevron.left")
                            .imageScale(.large)
                    }
                    .padding()
                    
                    Text(dateFormatter.string(from: currentMonth))
                        .font(.system(size: min(geometry.size.width * 0.05, 30)))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                    
                    Button(action: nextMonth) {
                        Image(systemName: "chevron.right")
                            .imageScale(.large)
                    }
                    .padding()
                }
                .padding(.horizontal)
                
                // Days of week header
                HStack(spacing: 0) {
                    ForEach(daysOfWeek, id: \.self) { day in
                        Text(day)
                            .font(.system(size: min(geometry.size.width * 0.03, 16)))
                            .frame(width: geometry.size.width / 7)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Calendar grid
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7),
                    spacing: min(geometry.size.height * 0.01, 10)
                ) {
                    ForEach(daysInMonth(), id: \.self) { date in
                        if let date = date {
                            DayView(
                                date: date,
                                isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                                size: geometry.size
                            ) {
                                selectedDate = date
                            }
                        } else {
                            Color.clear
                                .frame(
                                    width: geometry.size.width / 7,
                                    height: min(geometry.size.width / 7, geometry.size.height / 8)
                                )
                        }
                    }
                }
                .padding(.horizontal, geometry.size.width * 0.02)
                
                Spacer()
            }
            .padding(.vertical, geometry.size.height * 0.02)
        }
    }
    
    private func daysInMonth() -> [Date?] {
        var days: [Date?] = []
        
        let range = calendar.range(of: .day, in: .month, for: currentMonth)!
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        // Add empty days for the first week
        for _ in 1..<firstWeekday {
            days.append(nil)
        }
        
        // Add all days of the month
        for day in 1...range.count {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func previousMonth() {
        if let newDate = calendar.date(byAdding: .month, value: -1, to: currentMonth) {
            currentMonth = newDate
        }
    }
    
    private func nextMonth() {
        if let newDate = calendar.date(byAdding: .month, value: 1, to: currentMonth) {
            currentMonth = newDate
        }
    }
}

#Preview {
    CalendarView()
        .frame(width: 800, height: 600)
} 