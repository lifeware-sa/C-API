Class {
	#name : #AbstractZlibTest,
	#superclass : #LwTestCase,
	#category : #'C-API-Zlib'
}

{ #category : #utilities }
AbstractZlibTest >> arraySize [
	^12345
]

{ #category : #utilities }
AbstractZlibTest >> digits [
	| digits |
	digits := ByteArray new: self arraySize.
	1 to: self arraySize do: [:each | digits at: each put: each \\ 256].
	^digits
]

{ #category : #utilities }
AbstractZlibTest >> doCompressTest: aByteArray [
	| result |
	result := self zlibClass new
				uncompress: (self zlibClass new compress: aByteArray).
	self assert: aByteArray = result
]

{ #category : #utilities }
AbstractZlibTest >> doCompressTestForGzip: aByteArray [
	| result |
	result := self zlibClass new
				uncompressForGzip: (self zlibClass new compressForGzip: aByteArray).
	self assert: aByteArray = result
]

{ #category : #utilities }
AbstractZlibTest >> inferno [
	^'nel mezzo del cammin di nostra vita...' asByteArray
]

{ #category : #private }
AbstractZlibTest >> random [
	| digits random |
	random := XRandom new.
	digits := ByteArray new: self arraySize.
	1 to: self arraySize
		do: [:each | digits at: each put: (random next * 255) floor].
	^digits
]

{ #category : #run }
AbstractZlibTest >> testCompress [
	| original inflated |
	original := ByteArray new: 1000000.
	inflated := self zlibClass new
				uncompress: (self zlibClass new compress: original).
	self assert: original = inflated
]

{ #category : #run }
AbstractZlibTest >> testCompressForGzip [
	| original |
	original := ByteArray new: 1000000.
	self doCompressTestForGzip: original
]

{ #category : #run }
AbstractZlibTest >> testCompressForGzipSecureRandom [
	| original inflated |
	original := SecureRandom nextInto: (ByteArray new: 100000).
	inflated := self zlibClass new
				uncompressForGzip: (self zlibClass new compressForGzip: original).
	self assert: original = inflated
]

{ #category : #run }
AbstractZlibTest >> testCompressSecureRandom [
	| original inflated |
	original := SecureRandom nextInto: (ByteArray new: 100000).
	inflated := self zlibClass new
				uncompress: (self zlibClass new compress: original).
	self assert: original = inflated
]

{ #category : #run }
AbstractZlibTest >> testDigits [
	self doCompressTest: self digits
]

{ #category : #run }
AbstractZlibTest >> testDigitsForGzip [
	self doCompressTestForGzip: self digits
]

{ #category : #run }
AbstractZlibTest >> testEmpty [
	self doCompressTest: #[]
]

{ #category : #run }
AbstractZlibTest >> testEmptyForGzip [
	self doCompressTest: #[]
]

{ #category : #run }
AbstractZlibTest >> testInferno [
	self doCompressTest: self inferno
]

{ #category : #run }
AbstractZlibTest >> testInfernoForGzip [
	self doCompressTestForGzip: self inferno
]

{ #category : #run }
AbstractZlibTest >> testRandom [
	self doCompressTest: self random
]

{ #category : #run }
AbstractZlibTest >> testRandomForGzip [
	self doCompressTestForGzip: self random
]

{ #category : #run }
AbstractZlibTest >> testZeroes [
	self doCompressTest: self zeroes
]

{ #category : #run }
AbstractZlibTest >> testZeroesForGzip [
	self doCompressTestForGzip: self zeroes
]

{ #category : #utilities }
AbstractZlibTest >> zeroes [
	^ByteArray new: self arraySize
]

{ #category : #utilities }
AbstractZlibTest >> zlibClass [
	^self subclassResponsibility
]
