//
//  CryptoSwift
//
//  Copyright (C) 2014-2017 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
//  This software is provided 'as-is', without any express or implied warranty.
//
//  In no event will the authors be held liable for any damages arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
//
//  - The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation is required.
//  - Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
//  - This notice may not be removed or altered from any source or binary distribution.
//

 protocol CipherModeWorker {
    var cipherOperation: CipherOperationOnBlock { get }

    // Additional space needed when incrementally process data
    // eg. for GCM combined mode
    var additionalBufferSize: Int { get }

    mutating func encrypt(block plaintext: ArraySlice<UInt8>) -> Array<UInt8>
    mutating func decrypt(block ciphertext: ArraySlice<UInt8>) -> Array<UInt8>
}

/// Block workers use `BlockEncryptor`
 protocol BlockModeWorker: CipherModeWorker {
    var blockSize: Int { get }
}

 protocol CounterModeWorker: CipherModeWorker {
    associatedtype Counter
    var counter: Counter { get set }
}

 protocol SeekableModeWorker: CipherModeWorker {
    mutating func seek(to position: Int) throws
}

/// Stream workers use `StreamEncryptor`
 protocol StreamModeWorker: CipherModeWorker {
}

 protocol FinalizingEncryptModeWorker: CipherModeWorker {
    // Any final calculations, eg. calculate tag
    // Called after the last block is encrypted
    mutating func finalize(encrypt ciphertext: ArraySlice<UInt8>) throws -> ArraySlice<UInt8>
}

 protocol FinalizingDecryptModeWorker: CipherModeWorker {
    // Called before decryption, hence input is ciphertext.
    // ciphertext is either a last block, or a tag (for stream workers)
    @discardableResult
    mutating func willDecryptLast(bytes ciphertext: ArraySlice<UInt8>) throws -> ArraySlice<UInt8>
    // Called after decryption, hence input is ciphertext
    mutating func didDecryptLast(bytes plaintext: ArraySlice<UInt8>) throws -> ArraySlice<UInt8>
    // Any final calculations, eg. calculate tag
    // Called after the last block is encrypted
    mutating func finalize(decrypt plaintext: ArraySlice<UInt8>) throws -> ArraySlice<UInt8>
}
