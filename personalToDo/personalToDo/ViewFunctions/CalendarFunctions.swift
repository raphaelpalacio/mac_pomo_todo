import SwiftUI

struct DayView: View {
    let date: Date
    let isSelected: Bool
    let size: CGSize
    let action: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: action) {
            Text("\(calendar.component(.day, from: date))")
                .font(.system(size: min(size.width * 0.03, 20)))
                .frame(
                    width: size.width / 7,
                    height: min(size.width / 7, size.height / 8)
                )
                .background(isSelected ? Color.accentColor : Color.clear)
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
} 