Class {
	#name : #ZlibTest,
	#superclass : #AbstractZlibTest,
	#category : #'C-API-Zlib-Tests'
}

{ #category : #run }
ZlibTest >> testAdler32 [
	self assert: (Zlib new adler32: (ByteArray new: 10000)) = 655360001
]

{ #category : #run }
ZlibTest >> testCompressForGzipSecureRandom [
	| original inflated |
	original := SecureRandom nextInto: (ByteArray new: 100000).
	inflated := self zlibClass new
				uncompressForGzip: (self zlibClass new compressForGzip: original).
	self assert: original = inflated
]

{ #category : #run }
ZlibTest >> testCompressSecureRandom [
	| original inflated |
	original := SecureRandom nextInto: (ByteArray new: 100000).
	inflated := self zlibClass new
				uncompress: (self zlibClass new compress: original).
	self assert: original = inflated
]

{ #category : #run }
ZlibTest >> testCrc32 [
	self assert: (Zlib new crc32: (ByteArray new: 10000)) = 1295764014
]

{ #category : #run }
ZlibTest >> testStream [
	| inBytes ws |
	inBytes := self digits.
	ws := ByteArray new writeStream.
	Zlib new
		compress: inBytes
		firstIndex: 1
		byteLength: inBytes size
		level: 9
		on: ws.
	self assert: inBytes = (Zlib new uncompressFrom: ws contents readStream)
]

{ #category : #utilities }
ZlibTest >> zlibClass [
	^Zlib
]
