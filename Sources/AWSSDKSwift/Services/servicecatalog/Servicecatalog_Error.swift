// THIS FILE IS AUTOMATICALLY GENERATED by https://github.com/noppoMan/aws-sdk-swift/blob/master/Sources/CodeGenerator/main.swift. DO NOT EDIT.

import AWSSDKSwiftCore

/// Error enum for Servicecatalog
public enum ServicecatalogError: AWSErrorType {
    case resourceNotFoundException(message: String?)
    case limitExceededException(message: String?)
    case invalidParametersException(message: String?)
    case tagOptionNotMigratedException(message: String?)
    case duplicateResourceException(message: String?)
    case resourceInUseException(message: String?)
    case invalidStateException(message: String?)
}

extension ServicecatalogError {
    public init?(errorCode: String, message: String?){
        var errorCode = errorCode
        if let index = errorCode.index(of: "#") {
            errorCode = String(errorCode[errorCode.index(index, offsetBy: 1)...])
        }
        switch errorCode {
        case "ResourceNotFoundException":
            self = .resourceNotFoundException(message: message)
        case "LimitExceededException":
            self = .limitExceededException(message: message)
        case "InvalidParametersException":
            self = .invalidParametersException(message: message)
        case "TagOptionNotMigratedException":
            self = .tagOptionNotMigratedException(message: message)
        case "DuplicateResourceException":
            self = .duplicateResourceException(message: message)
        case "ResourceInUseException":
            self = .resourceInUseException(message: message)
        case "InvalidStateException":
            self = .invalidStateException(message: message)
        default:
            return nil
        }
    }
}