import XCTest
@testable import DomainModel

class PersonTests: XCTestCase {

    func testPerson() {
        let ted = Person(firstName: "Ted", lastName: "Neward", age: 45)
        XCTAssert(ted.toString() == "[Person: firstName:Ted lastName:Neward age:45 job:nil spouse:nil]")
    }

    func testAgeRestrictions() {
        let matt = Person(firstName: "Matthew", lastName: "Neward", age: 15)

        matt.job = Job(title: "Burger-Flipper", type: Job.JobType.Hourly(5.5))
        XCTAssert(matt.job == nil)

        matt.spouse = Person(firstName: "Bambi", lastName: "Jones", age: 42)
        XCTAssert(matt.spouse == nil)
    }

    func testAdultAgeRestrictions() {
        let mike = Person(firstName: "Michael", lastName: "Neward", age: 22)

        mike.job = Job(title: "Burger-Flipper", type: Job.JobType.Hourly(5.5))
        XCTAssert(mike.job != nil)

        mike.spouse = Person(firstName: "Bambi", lastName: "Jones", age: 42)
        XCTAssert(mike.spouse != nil)
    }
    
    // My Tests
    func testPersonWithNegativeAge() {
        let person = Person(firstName: "Test", lastName: "User", age: -5)
        XCTAssertEqual(person.age, -5)
    }

    func testUnderageJobAssignment() {
        let child = Person(firstName: "Kid", lastName: "User", age: 10)
        child.job = Job(title: "Impossible Job", type: Job.JobType.Hourly(10.0))
        XCTAssertNil(child.job)
    }

    func testUnderageSpouseAssignment() {
        let teen = Person(firstName: "Teen", lastName: "User", age: 17)
        teen.spouse = Person(firstName: "Partner", lastName: "User", age: 20)
        XCTAssertNil(teen.spouse)
    }

    static var allTests = [
        ("testPerson", testPerson),
        ("testAgeRestrictions", testAgeRestrictions),
        ("testAdultAgeRestrictions", testAdultAgeRestrictions),
        
        // My Tests
        ("testPersonWithNegativeAge", testPersonWithNegativeAge),
        ("testUnderageJobAssignment", testUnderageJobAssignment),
        ("testUnderageSpouseAssignment", testUnderageSpouseAssignment),
    ]
}

class FamilyTests : XCTestCase {
  
    func testFamily() {
        let ted = Person(firstName: "Ted", lastName: "Neward", age: 45)
        ted.job = Job(title: "Gues Lecturer", type: Job.JobType.Salary(1000))

        let charlotte = Person(firstName: "Charlotte", lastName: "Neward", age: 45)

        let family = Family(spouse1: ted, spouse2: charlotte)

        let familyIncome = family.householdIncome()
        XCTAssert(familyIncome == 1000)
    }

    func testFamilyWithKids() {
        let ted = Person(firstName: "Ted", lastName: "Neward", age: 45)
        ted.job = Job(title: "Gues Lecturer", type: Job.JobType.Salary(1000))

        let charlotte = Person(firstName: "Charlotte", lastName: "Neward", age: 45)

        let family = Family(spouse1: ted, spouse2: charlotte)

        let mike = Person(firstName: "Mike", lastName: "Neward", age: 22)
        mike.job = Job(title: "Burger-Flipper", type: Job.JobType.Hourly(5.5))

        let matt = Person(firstName: "Matt", lastName: "Neward", age: 16)
        let _ = family.haveChild(mike)
        let _ = family.haveChild(matt)

        let familyIncome = family.householdIncome()
        XCTAssert(familyIncome == 12000)
    }
    
    // My Tests
    func testFamilyCannotHaveChildWhenSpousesUnder21() {
        let youngSpouse1 = Person(firstName: "Young1", lastName: "Family", age: 20)
        let youngSpouse2 = Person(firstName: "Young2", lastName: "Family", age: 20)
        let family = Family(spouse1: youngSpouse1, spouse2: youngSpouse2)
        let child = Person(firstName: "Child", lastName: "Family", age: 0)
        let result = family.haveChild(child)
        XCTAssertFalse(result)
        XCTAssertFalse(family.members.contains(where: { $0.firstName == "Child" }))
    }
    
    func testFamilyHouseholdIncomeIgnoresMembersWithoutJob() {
        let spouse1 = Person(firstName: "Adult", lastName: "Family", age: 30)
        spouse1.job = Job(title: "Working", type: Job.JobType.Salary(2000))
        let spouse2 = Person(firstName: "Adult2", lastName: "Family", age: 30)
        let family = Family(spouse1: spouse1, spouse2: spouse2)
        let child = Person(firstName: "Child", lastName: "Family", age: 5)
        _ = family.haveChild(child)
        let income = family.householdIncome()
        XCTAssertEqual(income, 2000)
    }
    
    func testFamilyCanHaveChildWithAnAdultSpouse() {
        let spouse1 = Person(firstName: "Adult", lastName: "Family", age: 25)
        let spouse2 = Person(firstName: "Adult2", lastName: "Family", age: 25)
        let family = Family(spouse1: spouse1, spouse2: spouse2)
        let child = Person(firstName: "Child", lastName: "Family", age: 0)
        let result = family.haveChild(child)
        XCTAssertTrue(result)
        XCTAssertTrue(family.members.contains(where: { $0.firstName == "Child" }))
    }
  
    static var allTests = [
        ("testFamily", testFamily),
        ("testFamilyWithKids", testFamilyWithKids),
        
        // My Tests
        ("testFamilyCannotHaveChildWhenSpousesUnder21", testFamilyCannotHaveChildWhenSpousesUnder21),
        ("testFamilyHouseholdIncomeIgnoresMembersWithoutJob", testFamilyHouseholdIncomeIgnoresMembersWithoutJob),
        ("testFamilyCanHaveChildWithAnAdultSpouse", testFamilyCanHaveChildWithAnAdultSpouse),
        
    ]
}
