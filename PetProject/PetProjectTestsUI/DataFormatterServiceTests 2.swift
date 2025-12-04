import XCTest
@testable import PetProject
import Foundation

final class DateFormatterServiceTestsTwo: XCTestCase {

    // MARK: - Temperature
    func testFormattedTemperatureCelsius() throws {
        // 6°C should remain around 6 with °C unit
        let result = DateFormatterService.formattedTemperature(6, unit: .celsius)
        XCTAssertTrue(result.contains("°C"))
        // Extract number and verify it's 6 (allows locales with grouping/spacing by stripping non-digits)
        let digits = result.compactMap { $0.isNumber ? $0 : nil }
        let numberString = String(digits)
        XCTAssertEqual(Double(numberString), 6)
    }

    func testFormattedTemperatureFahrenheit() throws {
        // 6°C -> 42.8°F ≈ 43°F with 0 fraction digits
        let result = DateFormatterService.formattedTemperature(6, unit: .fahrenheit)
        XCTAssertTrue(result.contains("°F"))
        let digits = result.compactMap { $0.isNumber ? $0 : nil }
        let numberString = String(digits)
        let value = try XCTUnwrap(Int(numberString))
        XCTAssertEqual(value, 43)
    }

    // MARK: - Wind speed
    func testFormattedWindSpeedMetersPerSecond() throws {
        // 36 km/h ≈ 10 m/s
        let result = DateFormatterService.formattedWindSpeed(36, unit: .metersPerSecond)
        XCTAssertTrue(result.contains("m/s"))
        let digits = result.compactMap { $0.isNumber ? $0 : nil }
        let numberString = String(digits)
        let value = try XCTUnwrap(Int(numberString))
        XCTAssertEqual(value, 10)
    }

    func testFormattedWindSpeedKilometersPerHour() throws {
        let result = DateFormatterService.formattedWindSpeed(36, unit: .kilometersPerHour)
        XCTAssertTrue(result.contains("km"))
        let digits = result.compactMap { $0.isNumber ? $0 : nil }
        let numberString = String(digits)
        let value = try XCTUnwrap(Int(numberString))
        XCTAssertEqual(value, 36)
    }

    // MARK: - Date parsing and formatting
    func testFormattedHourParses() throws {
        let input = "2025-11-26T00:00"
        let output = DateFormatterService.formatedHour(from: input)
        // We cannot force time zone here; assert it looks like HH:mm and is two digits hour and minute
        XCTAssertEqual(output.count, 5)
        XCTAssertTrue(output.contains(":"))
    }

    func testFormattedDateParses() throws {
        let input = "2025-11-26T00:00"
        let output = DateFormatterService.formatedDate(from: input)
        // Expect the year 2025 appears or a shortened year '25' depending on locale
        XCTAssertTrue(output.contains("2025") || output.contains("25"))
    }

    // MARK: - Interval formatting
    func testIntervalFormattingTwoHoursFifteenMinutes() throws {
        // Build deterministic dates
        var components = DateComponents()
        components.year = 2025
        components.month = 11
        components.day = 26
        components.hour = 0
        components.minute = 0
        components.timeZone = TimeZone(secondsFromGMT: 0)
        let calendar = Calendar(identifier: .gregorian)
        let start = try XCTUnwrap(calendar.date(from: components))
        let end = start.addingTimeInterval(2 * 3600 + 15 * 60)

        let result = try XCTUnwrap(DateFormatterService.timeIntervalString(from: start, to: end))
        // Locale dependent full units; assert both hour and minute words are present via digits
        let digits = result.compactMap { $0.isNumber ? $0 : nil }
        let numberString = String(digits)
        // Expect to find 2 and 15 in order; a simple check is that concatenated digits equal 215
        let expected = "215"
        XCTAssertEqual(numberString, expected)
    }
}
