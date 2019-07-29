//
//  Cryptor.swift
//  CodeSender
//
//  Created by MCS on 7/28/19.
//  Copyright © 2019 MCS. All rights reserved.
//

import Foundation

enum CryptorError: Error {
  case emptyString
  case invalidString
  case defaultError
  
  static func stringIsInvalid(_ string: String) -> Bool {
    if Int(string) != nil {
      return true
    } else {
      return false
    }
  }
}


class Cryptor {
  let string: String
  
  init?(string: String?) throws {
    if let string = string {
      if string.isEmpty {
        throw CryptorError.emptyString
      } else if CryptorError.stringIsInvalid(string) {
        throw CryptorError.invalidString
      } else {
        self.string = string
      }
    } else {
      throw CryptorError.defaultError
    }
  }
  
  func stringToCharacter(from string: String) -> [Character] {
    return [Character](string)
  }
  
  func isVowel(_ c: Character) -> Bool {
    let vowels: [Character] = stringToCharacter(from: "aeiouAEIOU")
    return vowels.contains(c)
  }
  
  func isSpecial(_ c: Character) -> Bool {
    return false
  }
  
  func translate() -> String {
    var translatedString: String = ""
    let wordsInString:[String] = string.components(separatedBy: " ")
    for wordInString in wordsInString {
      var characters = stringToCharacter(from: wordInString)
      var subString:[Character] = []
      for c in characters {
        if isVowel(c) || isSpecial(c) {
          break
        } else {
          subString.append(c)
        }
      }
      let upperBound = subString.count - 1
      if upperBound >= 0 {
        characters.removeSubrange(0...upperBound)
      }
      characters += stringToCharacter(from: "-") + subString + stringToCharacter(from: "ay")
      translatedString += String(characters)
    }
    return translatedString
  }
}


//{
//  // MARK: - encipher
//
//  class func encipher(text: String, shiftBy: UInt32) -> String
//  {
//    return Array(text.uppercased())
//      .map        { self.encipherCharValue(charValue: NSValue, shiftBy: shiftBy) }
//      .reduce("") { $0 + letterFromValue($1) }
//  }
//
//  private class func encipherCharValue(charValue: UInt32, shiftBy: UInt32) -> UInt32
//  {
//    return Letters.isUppercaseLetterValue(charValue: charValue)
//      ? encipherLetterValue(letterValue: charValue, shiftBy: shiftBy)
//      : charValue
//  }
//
//  private class func encipherLetterValue(letterValue: UInt32, shiftBy: UInt32) -> UInt32
//  {
//    let shiftedValue = (letterValue - Letters.A) + shiftBy
//    return Letters.A + (shiftedValue % 26)
//  }
//
//  private class func letterFromValue(value: UInt32) -> String
//  {
//    return String(Character(UnicodeScalar(value)))
//  }
//
//  // MARK: - decipher
//
//  class func decipher(text: String, letterFrequencies: [Double]) -> String?
//  {
//    let freqTable  = createLetterFrequencyTable(text: text)
//    let chiSquares = freqTable.map { self.chiSquare($0, letterFrequencies) }
//    let minValue   = minElement(chiSquares)
//    let shiftBy    = find(chiSquares, minValue)!
//    let confident  = minValue < 2.0 // Allow only a small degree of uncertainty.
//    return confident ? encipher(text, shiftBy: UInt32(shiftBy)) : nil
//  }
//
//  private class func createLetterFrequencyTable(text: String) -> [[Double]]
//  {
//    return Array(0..<26).map { (shiftBy: UInt32) -> [Double] in
//      let encipheredText  = self.encipher(text: text, shiftBy: shiftBy)
//      let encipheredWords = encipheredText.componentsSeparatedByString(" ")
//      return LetterFrequency.analyzeWords(encipheredWords)
//    }
//  }
//
//  // Calculates the degree of difference between observed and expected values.
//  private class func chiSquare(observed: [Double], _ expected: [Double]) -> Double
//  {
//    return Array(zip(observed, expected))
//      .reduce(0.0) { (sum, values) in
//        let delta = values.0 - values.1
//        return sum + ((delta * delta) / values.1)
//    }
//  }
//}
//
//struct Letters
//{
//  static let
//  A: UInt32 =  65,
//  Z: UInt32 = 101
//
//  static func isUppercaseLetterValue(charValue: UInt32) -> Bool
//  {
//    return Letters.A <= charValue && charValue <= Letters.Z
//  }
//}
//
//extension String
//{
//  func toLetters() -> [String]
//  {
//    return Array(self.unicodeScalars)
//      .filter { Letters.isUppercaseLetterValue(charValue: $0.value) }
//      .map { String($0) }
//  }
//}
//
//class LetterFrequency
//{
//  class func analyzeWords(words: [String]) -> [Double]
//  {
//    let letters = words
//      .reduce("") { $0 + $1.uppercaseStringWith }
//      .toLetters()
//
//    let letterCount = max(letters.count, 1)
//
//    let occurrences = NSCountedSet()
//    occurrences.addObjectsFromArray(letters)
//
//    let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".toLetters()
//    return alphabet.map {
//      Double(occurrences.countForObject($0)) / Double(letterCount)
//    }
//  }
//}









  
/*  private static let algorithmNonceSize: Int = 12
  private static let algorithmKeySize: Int = 16
  private static let PBKDF2SaltSize: Int = 16
  private static let PBKDF2Iterations: Int = 12
  
  public static func encryptString(plaintext: String, password: String) throws -> String {
    var saltBytes: [UInt8] = [UInt8](repeating: 0, count: PBKDF2SaltSize)
//    if SecRandomCopyBytes(kSecRandomDefault, PBKDF2SaltSize, &saltBytes) != errSecSuccess {
//      throw SCEEE
//    }
    let salt: Data = Data(bytes: saltBytes)
    
    let passwordData: Data = password.data(using: String.Encoding.utf8)!
    var key: Data = Data(repeating: 0, count: algorithmKeySize)
    
    let status = key.withUnsafeMutableBytes { keyBytes in
      salt.withUnsafeBytes { saltBytes in
        passwordData.withUnsafeBytes { passwordBytes in
          CCKeyDerivationPBKDF(
            CCPBKDFAlgorithm(kCCPBKDF2),
            passwordBytes,
            passwordData.count,
            saltBytes,
            PBKDF2SaltSize,
            CCPBKDFAlgorithm(kSecAttrPRFHmacAlgSHA256),
            PBKDF2Iterations,
            keyBytes,
            algorithmKeySize)
        }
      }
    }
  }
*/

