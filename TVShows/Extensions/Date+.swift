import Foundation

extension Date {
    init?(_ dateString: String, dateFormat: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        guard let date = dateFormatter.date(from: dateString) else { return nil }
        self = date
    }

    func localizedDateString() -> String {
        var dateFormatStyle = Date.FormatStyle()
        dateFormatStyle.capitalizationContext = .beginningOfSentence
        dateFormatStyle = dateFormatStyle.day().month(.abbreviated).year()
        return formatted(dateFormatStyle)
    }
}
