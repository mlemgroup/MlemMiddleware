//
//  URLQueryItemEncoder.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2025-02-20.
//

import Foundation

internal struct URLQueryItemEncoder {
    static func encode<T: Encodable>(_ value: T) throws -> [URLQueryItem] {
        let encoder = InternalURLQueryItemEncoder()
        try value.encode(to: encoder)
        return encoder.queryParams
    }
}

internal protocol URLQueryItemEncodable {
    func encodeInQueryItemFormat() -> String?
}

internal enum URLQueryItemEncoderError: Error {
    case nestedContainersUnsupported
    case singleValueContainerUnsupported
    case unkeyedContainerUnsupported
}

private class InternalURLQueryItemEncoder: Encoder {
    var queryParams: [URLQueryItem] = .init()

    // This is just for conformance to Encoder. This never gets modified because we
    // disallow nested containers
    let codingPath: [CodingKey] = []
    
    // Just for conformance; unused
    let userInfo: [CodingUserInfoKey: Any] = [:]

    func singleValueContainer() -> SingleValueEncodingContainer {
        // This value throws an error as soon as you try to encode with it
        SingleValueContainer(encoder: self)
    }

    func unkeyedContainer() -> UnkeyedEncodingContainer {
        // This value throws an error as soon as you try to encode with it
        UnkeyedContainer(encoder: self)
    }

    func container<Key: CodingKey>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> {
        KeyedEncodingContainer(KeyedContainer<Key>(encoder: self))
    }
}

private class KeyedContainer<K: CodingKey>: KeyedEncodingContainerProtocol {
    var encoder: InternalURLQueryItemEncoder

    init(encoder: InternalURLQueryItemEncoder) {
        self.encoder = encoder
    }

    var codingPath: [CodingKey] = []

    func encodeNil(forKey key: K) throws {}

    func encode<T: Encodable>(_ value: T, forKey key: K) throws {
        if let valueString = self.convertValueToString(value) {
            let key = key.stringValue.camelToSnakeCase()
            encoder.queryParams.append(.init(name: key, value: valueString))
        } else {
            throw URLQueryItemEncoderError.nestedContainersUnsupported
        }
    }
    
    func convertValueToString<T: Encodable>(_ value: T) -> String? {
        if let value = value as? String {
            value
        } else if let value = value as? Int {
            String(value)
        } else if let value = value as? Double {
            String(value)
        } else if let value = value as? Bool {
            value ? "true" : "false"
        } else if let value = value as? any RawRepresentable<String> {
            value.rawValue
        } else if let value = value as? any RawRepresentable<Int> {
            String(value.rawValue)
        } else if let value = value as? any URLQueryItemEncodable {
            value.encodeInQueryItemFormat()
        } else {
            nil
        }
    }

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: K) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
        assertionFailure("We should throw an error *before* this gets called")
        return KeyedEncodingContainer(KeyedContainer<NestedKey>(encoder: encoder))
    }

    func nestedUnkeyedContainer(forKey key: K) -> UnkeyedEncodingContainer {
        assertionFailure("We should throw an error *before* this gets called")
        return UnkeyedContainer(encoder: encoder)
    }

    func superEncoder() -> Encoder { encoder }
    func superEncoder(forKey key: K) -> Encoder { encoder }
}

// This simply throws an error as soon as you try to encode with it.
private class SingleValueContainer: SingleValueEncodingContainer {
    let encoder: InternalURLQueryItemEncoder
    let codingPath: [CodingKey] = []

    init(encoder: InternalURLQueryItemEncoder) {
        self.encoder = encoder
    }

    func encodeNil() throws {}

    func encode<T: Encodable>(_ value: T) throws {
        throw URLQueryItemEncoderError.singleValueContainerUnsupported
    }
}

// This simply throws an error as soon as you try to encode with it.
private class UnkeyedContainer: UnkeyedEncodingContainer {
    let encoder: InternalURLQueryItemEncoder
    let codingPath: [any CodingKey] = []
    let count: Int = 0
    
    init(encoder: InternalURLQueryItemEncoder) {
        self.encoder = encoder
    }
    
    func encodeNil() throws {}
    
    func encode<T: Encodable>(_ value: T) throws { throw URLQueryItemEncoderError.unkeyedContainerUnsupported }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        assertionFailure("We should throw an error *before* this gets called")
        return KeyedEncodingContainer(KeyedContainer(encoder: encoder))
    }
    
    func nestedUnkeyedContainer() -> any UnkeyedEncodingContainer {
        assertionFailure("We should throw an error *before* this gets called")
        return UnkeyedContainer(encoder: encoder)
    }
    
    func superEncoder() -> any Encoder { encoder }
}

private extension String {
    func camelToSnakeCase() -> String {
        self.replacing(/([a-z])([A-Z])/) { "\($0.output.1)_\($0.output.2)"
        }.lowercased()
    }
}
