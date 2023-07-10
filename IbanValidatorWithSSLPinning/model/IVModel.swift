//
//  IVModel.swift
//  IbanValidatorWithSSLPinning
//
//  Created by Stebin Joy on 07/07/23.
//

import Foundation


struct IVModel : Codable {
    let valid : Bool
    let iban : String?
    let ibanData : IbanData?
    let bankData : BankData?
    let countryIbanExample : String?

    enum CodingKeys: String, CodingKey {

        case valid = "valid"
        case iban = "iban"
        case ibanData = "iban_data"
        case bankData = "bank_data"
        case countryIbanExample = "country_iban_example"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        valid = try values.decode(Bool.self, forKey: .valid)
        iban = try values.decodeIfPresent(String.self, forKey: .iban)
        ibanData = try values.decodeIfPresent(IbanData.self, forKey: .ibanData)
        bankData = try values.decodeIfPresent(BankData.self, forKey: .bankData)
        countryIbanExample = try values.decodeIfPresent(String.self, forKey: .countryIbanExample)
    }

}



struct BankData : Codable {
    let bankCode : String?
    let name : String?
    let zip : String?
    let city : String?
    let bic : String?

    enum CodingKeys: String, CodingKey {

        case bankCode = "bank_code"
        case name = "name"
        case zip = "zip"
        case city = "city"
        case bic = "bic"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bankCode = try values.decodeIfPresent(String.self, forKey: .bankCode)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        zip = try values.decodeIfPresent(String.self, forKey: .zip)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        bic = try values.decodeIfPresent(String.self, forKey: .bic)
    }

}


struct IbanData : Codable {
    let country : String?
    let countryCode : String?
    let sepaCountry : Bool?
    let checksum : String?
    let bBAN : String?
    let bankCode : String?
    let accountNumber : String?
    let branch : String?
    let nationalChecksum : String?
    let countryIbanFormatAsSwift : String?
    let countryIbanFormatAsRegex : String?

    enum CodingKeys: String, CodingKey {

        case country = "country"
        case countryCode = "country_code"
        case sepaCountry = "sepa_country"
        case checksum = "checksum"
        case bBAN = "BBAN"
        case bankCode = "bank_code"
        case accountNumber = "account_number"
        case branch = "branch"
        case nationalChecksum = "national_checksum"
        case countryIbanFormatAsSwift = "country_iban_format_as_swift"
        case countryIbanFormatAsRegex = "country_iban_format_as_regex"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        countryCode = try values.decodeIfPresent(String.self, forKey: .countryCode)
        sepaCountry = try values.decodeIfPresent(Bool.self, forKey: .sepaCountry)
        checksum = try values.decodeIfPresent(String.self, forKey: .checksum)
        bBAN = try values.decodeIfPresent(String.self, forKey: .bBAN)
        bankCode = try values.decodeIfPresent(String.self, forKey: .bankCode)
        accountNumber = try values.decodeIfPresent(String.self, forKey: .accountNumber)
        branch = try values.decodeIfPresent(String.self, forKey: .branch)
        nationalChecksum = try values.decodeIfPresent(String.self, forKey: .nationalChecksum)
        countryIbanFormatAsSwift = try values.decodeIfPresent(String.self, forKey: .countryIbanFormatAsSwift)
        countryIbanFormatAsRegex = try values.decodeIfPresent(String.self, forKey: .countryIbanFormatAsRegex)
    }

}



// MARK: - List All Currency Model

struct AllCurrency: Codable {
    let base : String?
    let date : String?
    let rates : [String: Double]
    let success : Bool?
}


// MARK: - Currency Convert
struct ConvertInfo: Codable {
    let date: String
    let info: Info
    let query: Query
    let result: Double
    let success: Bool
}

// MARK: - Info
struct Info: Codable {
    let rate: Double
    let timestamp: Int
}

// MARK: - Query
struct Query: Codable {
    let amount: Int
    let from, to: String
}
