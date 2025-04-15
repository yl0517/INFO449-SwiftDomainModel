import XCTest
@testable import DomainModel

class JobTests: XCTestCase {
  
    func testCreateSalaryJob() {
        let job = Job(title: "Guest Lecturer", type: Job.JobType.Salary(1000))
        XCTAssert(job.calculateIncome(50) == 1000)
        XCTAssert(job.calculateIncome(100) == 1000)
        // Salary jobs pay the same no matter how many hours you work
    }

    func testCreateHourlyJob() {
        let job = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
        XCTAssert(job.calculateIncome(10) == 150)
        XCTAssert(job.calculateIncome(20) == 300)
    }

    func testSalariedRaise() {
        let job = Job(title: "Guest Lecturer", type: Job.JobType.Salary(1000))
        XCTAssert(job.calculateIncome(50) == 1000)

        job.raise(byAmount: 1000)
        XCTAssert(job.calculateIncome(50) == 2000)

        job.raise(byPercent: 0.1)
        XCTAssert(job.calculateIncome(50) == 2200)
    }

    func testHourlyRaise() {
        let job = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
        XCTAssert(job.calculateIncome(10) == 150)

        job.raise(byAmount: 1.0)
        XCTAssert(job.calculateIncome(10) == 160)

        job.raise(byPercent: 1.0) // Nice raise, bruh
        XCTAssert(job.calculateIncome(10) == 320)
    }
    
    // My Tests
    func testJobNegativeHourlyRate() {
        let job = Job(title: "Test Job", type: Job.JobType.Hourly(-20.0))
        XCTAssert(job.calculateIncome(10) < 0)
    }
    
    func testJobNegativeRaiseAmount() {
        let job = Job(title: "Test Job", type: Job.JobType.Salary(1000))
        let originalIncome = job.calculateIncome(50)
        job.raise(byAmount: -100)
        XCTAssertEqual(job.calculateIncome(50), originalIncome)
    }
    
    func testJobNegativeRaisePercentage() {
        let job = Job(title: "Test Job", type: Job.JobType.Hourly(15.0))
        let originalIncome = job.calculateIncome(10)
        job.raise(byPercent: -0.1)
        XCTAssertEqual(job.calculateIncome(10), originalIncome)
    }
  
    static var allTests = [
        ("testCreateSalaryJob", testCreateSalaryJob),
        ("testCreateHourlyJob", testCreateHourlyJob),
        ("testSalariedRaise", testSalariedRaise),
        ("testHourlyRaise", testHourlyRaise),
        
        // My Tests
        ("testJobNegativeHourlyRate", testJobNegativeHourlyRate),
        ("testJobNegativeRaiseAmount", testJobNegativeRaiseAmount),
        ("testJobNegativeRaisePercentage", testJobNegativeRaisePercentage),
    ]
}
