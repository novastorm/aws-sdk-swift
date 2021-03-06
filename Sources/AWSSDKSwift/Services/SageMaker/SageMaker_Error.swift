// THIS FILE IS AUTOMATICALLY GENERATED by https://github.com/noppoMan/aws-sdk-swift/blob/master/Sources/CodeGenerator/main.swift. DO NOT EDIT.

import AWSSDKSwiftCore

/// Error enum for SageMaker
public enum SageMakerErrorType: AWSErrorType {
    case resourceLimitExceeded(message: String?)
    case resourceNotFound(message: String?)
    case resourceInUse(message: String?)
}

extension SageMakerErrorType {
    public init?(errorCode: String, message: String?){
        var errorCode = errorCode
        if let index = errorCode.index(of: "#") {
            errorCode = String(errorCode[errorCode.index(index, offsetBy: 1)...])
        }
        switch errorCode {
        case "ResourceLimitExceeded":
            self = .resourceLimitExceeded(message: message)
        case "ResourceNotFound":
            self = .resourceNotFound(message: message)
        case "ResourceInUse":
            self = .resourceInUse(message: message)
        default:
            return nil
        }
    }
}