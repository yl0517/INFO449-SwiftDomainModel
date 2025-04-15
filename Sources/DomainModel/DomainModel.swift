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
//
//public class Job {
//    public enum JobType {
//        case Hourly(Double)
//        case Salary(UInt)
//    }
//}
//
//////////////////////////////////////
//// Person
////
//public class Person {
//}
//
//////////////////////////////////////
//// Family
////
//public class Family {
//}
