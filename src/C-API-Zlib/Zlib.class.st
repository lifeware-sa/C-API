Class {
	#name : #Zlib,
	#superclass : #AbstractZlib,
	#instVars : [
		'chunks',
		'destBytes'
	],
	#category : #'C-API-Zlib'
}

{ #category : #compressing }
Zlib >> compress: aByteArray [
	^self compress: aByteArray forGzip: false
]

{ #category : #compressing }
Zlib >> compress: aByteArray firstIndex: firstInteger byteLength: lengthInteger level: levelInteger forGzip: aBoolean [
	chunks := OrderedCollection new.
	self
		doCompress: aByteArray
		firstIndex: firstInteger
		byteLength: lengthInteger
		level: levelInteger
		forGzip: aBoolean.
	^destBytes
]

{ #category : #compressing }
Zlib >> compress: aByteArray firstIndex: firstInteger byteLength: lengthInteger level: levelInteger on: aStream [
	| bytes |
	bytes := self
				compress: aByteArray
				firstIndex: firstInteger
				byteLength: lengthInteger
				level: levelInteger
				forGzip: false.
	self writeInteger: bytes size on: aStream.
	aStream nextPutAll: bytes
]

{ #category : #compressing }
Zlib >> compress: aByteArray forGzip: aBoolean [
	^self
		compress: aByteArray
		firstIndex: 1
		byteLength: aByteArray size
		level: self class zDefaultCompression
		forGzip: aBoolean
]

{ #category : #compressing }
Zlib >> compressForGzip: aByteArray [
	^self compress: aByteArray forGzip: true
]

{ #category : #private }
Zlib >> copyChunks [
	| size |
	size := self totalOut.
	destBytes := ByteArray new: size.
	chunks inject: 1
		into: 
			[:sum :each |
			destBytes
				replaceFrom: sum
				to: sum + each size - 1
				with: each
				startingAt: 1.
			sum + each size]
]

{ #category : #private }
Zlib >> copyOutBuffer [
	| bytes |
	bytes := self privateCopyOutBuffer.
	chunks add: bytes
]

{ #category : #utilities }
Zlib >> readIntegerFrom: aStream [
	| i shift byte |
	i := 0.
	shift := 0.
	
	[byte := aStream next.
	byte < 16r80] whileTrue: 
				[i := i bitOr: (byte bitShift: shift).
				shift := shift + 7].
	^i bitOr: ((byte bitAnd: 16r7f) bitShift: shift)
]

{ #category : #uncompressing }
Zlib >> uncompress: aByteArray [
	^self uncompress: aByteArray forGzip: false
]

{ #category : #uncompressing }
Zlib >> uncompress: aByteArray firstIndex: firstInteger byteLength: lengthInteger forGzip: aBoolean [
	chunks := OrderedCollection new.
	self
		doUncompress: aByteArray
		firstIndex: firstInteger
		byteLength: lengthInteger
		forGzip: aBoolean.
	^destBytes
]

{ #category : #uncompressing }
Zlib >> uncompress: aByteArray forGzip: aBoolean [
	^self
		uncompress: aByteArray
		firstIndex: 1
		byteLength: aByteArray size
		forGzip: aBoolean
]

{ #category : #uncompressing }
Zlib >> uncompressForGzip: aByteArray [
	^self uncompress: aByteArray forGzip: true
]

{ #category : #uncompressing }
Zlib >> uncompressFrom: aStream [
	| size bytes |
	size := self readIntegerFrom: aStream.
	bytes := aStream next: size.
	^self
		uncompress: bytes
		firstIndex: 1
		byteLength: size
		forGzip: false
]

{ #category : #utilities }
Zlib >> writeInteger: anInteger on: aStream [
	| i |
	i := anInteger.
	[i >= 16r80] whileTrue: 
			[aStream nextPut: (i bitAnd: 16r7f).
			i := i bitShift: -7].
	aStream nextPut: (i bitOr: 16r80)
]
