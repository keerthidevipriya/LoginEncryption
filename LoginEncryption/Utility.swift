//
//  Utility.swift
//  LoginEncryption
//
//  Created by Keerthi Devipriya(kdp) on 11/12/23.
//

import Foundation
import RNCryptor

let encryptionKEY = "$3N2@C7@pXp"

class Utility {
    class func encryptData(_ pswd: String, completion: (String) -> Void) {
        let encryptedPasswordText =  self.encrypt(plainText: pswd, password: encryptionKEY)
        completion(encryptedPasswordText)
    }
    
    class func decryptData(_ encryptedPasswordText: String) -> String {
        let decryptedPswd = self.decrypt(encryptedText: encryptedPasswordText, password: encryptionKEY)
        return decryptedPswd
    }
    
    class func encrypt(plainText: String, password: String) -> String {
        guard let data: Data = plainText.data(using: .utf8) else { return String() }
        let encryptedData = RNCryptor.encrypt(data: data, withPassword: encryptionKEY)
        let encryptedString : String = encryptedData.base64EncodedString() // getting base64encoded string of encrypted data.
        return encryptedString
    }
    
    class func decrypt(encryptedText : String, password: String) -> String {
        do  {
            let data: Data = Data(base64Encoded: encryptedText)! // Just get data from encrypted base64Encoded string.
            let decryptedData = try RNCryptor.decrypt(data: data, withPassword: password)
            let decryptedString = String(data: decryptedData, encoding: .utf8) // Getting original string, using same .utf8 encoding option,which we used for encryption.
            return decryptedString ?? ""
        }
        catch {
            return "FAILED"
        }
    }
}
