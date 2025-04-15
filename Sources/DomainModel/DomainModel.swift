struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount: Int
    var currency: String
    private let validCurrencies = ["USD", "EUR", "GBP", "CAN"]
    private let conversionRates: [String: Double] = ["USD": 1.0, "EUR": 1.5, "GBP": 0.5, "CAN": 1.25]
    
    init(amount: Int, currency: String) {
            self.amount = amount
            if !validCurrencies.contains(currency) {
                self.currency = ""
            } else {
                self.currency = currency
            }
        }
    
    func convert(_ currency : String) -> Money {
        if !validCurrencies.contains(currency) {
            fatalError("Invalid currency")
        }
        
        var converted = (Double(self.amount)/conversionRates[self.currency]!) * conversionRates[currency]!
        converted.round()
        return Money(amount: Int(converted), currency: currency)
    }
    
    func add(_ other: Money) -> Money {
        let convertedSelf = self.convert(other.currency)
                return Money(amount: convertedSelf.amount + other.amount, currency: other.currency)
    }
    
    func subtract(_ other: Money) -> Money {
        let convertedSelf = self.convert(other.currency)
                return Money(amount: convertedSelf.amount - other.amount, currency: other.currency)
    }
}

////////////////////////////////////
// Job

public class Job {
    var title: String
    var type: JobType
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    func calculateIncome(_ hours: Int) -> Int {
        switch self.type {
        case .Hourly(let rate):
            return Int(rate * Double(hours))
        case .Salary(let annual):
            return Int(annual)
        }
    }
    
    func raise(byAmount amount: Double) {
        if amount > 0 {
            switch self.type {
            case .Hourly(let rate):
                self.type = .Hourly(rate + amount)
            case .Salary(let annual):
                self.type = .Salary(annual + UInt(amount))
            }
        }
    }
    
    func raise(byPercent percentage: Double) {
        if percentage > 0 {
            switch self.type {
            case .Hourly(let rate):
                self.type = .Hourly(rate * (1 + percentage))
            case .Salary(let annual):
                let updated = Double(annual) * (1 + percentage)
                self.type = .Salary(UInt(updated.rounded()))
            }
        }
    }
}

//////////////////////////////////////
//// Person

public class Person {
    var firstName: String
    var lastName: String
    var age: Int
    
    private var _job: Job? = nil
    public var job: Job? {
        get {
            return _job
        }
        set {
            if age >= 16 {
                _job = newValue
            } else {
                _job = nil
            }
        }
    }
    
    private var _spouse: Person? = nil
    public var spouse: Person? {
        get {
            return _spouse
        }
        set {
            if age >= 18 {
                _spouse = newValue
            } else {
                _spouse = nil
            }
        }
    }
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    func toString() -> String {
        let jobStr: String
        if let job = job {
            switch job.type {
            case .Hourly(let rate):
                jobStr = "Hourly(\(Int(rate)))"
            case .Salary(let annual):
                jobStr = "Salary(\(annual))"
            }
        } else {
            jobStr = "nil"
        }

        let spouseStr = spouse?.firstName ?? "nil"
        
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(jobStr) spouse:\(spouseStr)]"
    }
}

//////////////////////////////////////
//// Family

public class Family {
    var members: [Person] = []
    
    init(spouse1: Person, spouse2: Person) {
        if spouse1.spouse == nil && spouse2.spouse == nil {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
        }
        members.append(spouse1)
        members.append(spouse2)
    }
    
    func haveChild(_ child: Person) -> Bool {
        if members.count >= 2 {
            let spouse1 = members[0]
            let spouse2 = members[1]
            if spouse1.age > 21 || spouse2.age > 21 {
                members.append(child)
                return true
            }
        }
        return false
    }
    
    func householdIncome() -> Int {
        return members.reduce(0) { total, person in
            if let job = person.job {
                return total + job.calculateIncome(2000)
            } else {
                return total
            }
        }
    }
}
