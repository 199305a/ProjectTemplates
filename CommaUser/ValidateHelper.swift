/*
 * author levi
 * "Hello Swift, Goodbye Obj-C."
 * Converted by 'objc2swift'
 */

import UIKit

class ValidateHelper: NSObject {
    
    class func validateMobile(_ mobile: String?) -> Bool {
        guard let mobile = mobile else {
            return false
        }
        let phoneRegex = "^(((1[3|4|5|6|7|8|9]{1}[0-9]{1}))[0-9]{8})$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        let result = phoneTest.evaluate(with: mobile)
        return result
    }
    
    class func validateCaptcha(_ code: String?) -> Bool {
        guard let code = code else {
            return false
        }
        let regex = "^[0-9]{6}"
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        let result = test.evaluate(with: code)
        return result
    }
    
    
    class func validateEmail(_ email: String?) -> Bool {
        guard let email = email else {
            return false
        }
        let emailRegex = "[A-Z0-9a-z.%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    class func validName(_ name: String?) -> Bool {
        guard let name = name else {
            return false
        }
        let regex = "^[\u{4e00}-\u{9fa5}A-Za-z0-9_]{1,15}$"
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        let result = test.evaluate(with: name)
        return result
    }
    
    
    class func validDate(_ date: String?) -> Bool {
        guard let date = date else {
            return false
        }
        let regex = "(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)"
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        let result = test.evaluate(with: date)
        return result
    }
    
}
