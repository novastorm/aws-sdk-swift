//
//  Serializer.swift
//  AWSSDKSwift
//
//  Created by Yuki Takei on 2017/03/29.
//
//

import Foundation

public enum DictionaryKeyStyle {
    case camel
    case pascal
    
    public var isCamelCase: Bool {
        switch self {
        case .camel:
            return true
        default:
            return false
        }
    }
}

func unwrap(any: Any) -> Any? {
    let mi = Mirror(reflecting: any)
    if mi.displayStyle != .optional {
        return any
    }
    if mi.children.count == 0 { return nil }
    let (_, some) = mi.children.first!
    return some
}

public protocol DictionarySerializable {}

public protocol XMLNodeSerializable {}

extension Collection where Iterator.Element == DictionarySerializable {
    public func serialize(keyStyle: DictionaryKeyStyle = .camel) throws -> [[String: Any]] {
        return try self.map({ try $0.serializeToDictionary(keyStyle: keyStyle) })
    }
}

public typealias XMLAttribute = [String: [String: String]] // ["elementName": ["key": "value", ...]]

private let undictionarizableKeys: [String] = [
    "queryParams",
    "headerParams",
    "pathParams",
    "_payload"
]

extension XMLNodeSerializable {
    public func serializeToXMLNode(attributes: XMLAttribute = [:]) throws -> XMLNode {
        let mirror = Mirror.init(reflecting: self)
        let name = "\(mirror.subjectType)"
        let xmlNode = XMLNode(elementName: name.upperFirst())
        if let attr = attributes.filter({ $0.key == name }).first {
            xmlNode.attributes = attr.value
        }
        
        for el in mirror.children {
            guard let label = el.label?.upperFirst() else {
                continue
            }
            
            if undictionarizableKeys.contains(label) { continue }
            
            guard let value = unwrap(any: el.value) else {
                continue
            }
            let node = XMLNode(elementName: label)
            switch value {
            case let v as XMLNodeSerializable:
                let cNode = try v.serializeToXMLNode()
                node.children.append(contentsOf: cNode.children)
                
            case let v as [XMLNodeSerializable]:
                for vv in v {
                    let cNode = try vv.serializeToXMLNode()
                    node.children.append(contentsOf: cNode.children)
                }
                
            default:
                switch value {
                case let v as [Any]:
                    for vv in v {
                        node.values.append("\(vv)")
                    }
                    
                case let v as [AnyHashable: Any]:
                    for (key, value) in v {
                        let cNode = XMLNode(elementName: "\(key)")
                        cNode.values.append("\(value)")
                        node.children.append(cNode)
                    }
                default:
                    node.values.append("\(value)")
                }
            }
            
            xmlNode.children.append(node)
        }
        
        return xmlNode
    }
}

extension DictionarySerializable {
    public func serializeToDictionary(keyStyle: DictionaryKeyStyle = .camel) throws -> [String: Any] {
        let mirror = Mirror.init(reflecting: self)
        var serialized: [String: Any] = [:]
        
        for el in mirror.children {
            guard let label = el.label else {
                continue
            }
            
            let key = keyStyle.isCamelCase ? label.upperFirst() : label
            
            guard let value = unwrap(any: el.value) else {
                continue
            }
            
            switch value {
            case let v as DictionarySerializable:
                serialized[key] = try v.serializeToDictionary(keyStyle: keyStyle)
                
            case let v as [DictionarySerializable]:
                serialized[key] = try v.serialize(keyStyle: keyStyle)
                
            case let v as [AnyHashable: DictionarySerializable]:
                var dict: [String: Any] = [:]
                for (key, value) in v {
                    dict["\(key)"] = try value.serializeToDictionary(keyStyle: keyStyle)
                }
                serialized[key] = dict
                
            case _ as NSNull:
                break
                
            default:
                serialized[key] = value
            }
        }
        return serialized
    }
}
