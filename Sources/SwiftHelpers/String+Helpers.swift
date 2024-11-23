import Foundation

public extension String {
    var isValidEmail: Bool {
        let emailRegex = #/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/#
        return self.wholeMatch(of: emailRegex) != nil
    }

    var isValidPassword: Bool {
        let passwordRegex = #/^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/#
        return self.wholeMatch(of: passwordRegex) != nil
    }
}
