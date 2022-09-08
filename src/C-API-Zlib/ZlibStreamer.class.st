Class {
	#name : #ZlibStreamer,
	#superclass : #AbstractZlib,
	#instVars : [
		'stream',
		'crc32'
	],
	#category : #'C-API-Zlib'
}

{ #category : #private }
ZlibStreamer >> compress: aByteArray firstIndex: firstInteger byteLength: lengthInteger level: levelInteger forGzip: aBoolean on: aStream [
	stream := aStream.
	crc32 := aBoolean ifTrue: [self class crc32InitSum] ifFalse: [].
	self
		doCompress: aByteArray
		firstIndex: firstInteger
		byteLength: lengthInteger
		level: levelInteger
		forGzip: aBoolean.
	^crc32
]

{ #category : #private }
ZlibStreamer >> compress: aByteArray firstIndex: firstInteger byteLength: lengthInteger level: levelInteger on: aStream [
	^self
		compress: aByteArray
		firstIndex: firstInteger
		byteLength: lengthInteger
		level: levelInteger
		forGzip: false
		on: aStream
]

{ #category : #private }
ZlibStreamer >> copyChunks [
]

{ #category : #private }
ZlibStreamer >> copyOutBuffer [
	| bytes |
	bytes := self privateCopyOutBuffer.
	stream nextPutAll: bytes
]

{ #category : #private }
ZlibStreamer >> ensureInBuffer [
	| size |
	(self isInBufferEmpty and: [currentLength > 0]) ifFalse: [^self].
	size := currentLength min: self class bufferSize.
	self fillInBuffer: sourceBytes firstIndex: currentIndex byteLength: size.
	crc32
		ifNotNil: 
			[crc32 := self
						checksumBlock: sourceBytes
						firstIndex: currentIndex
						byteLength: size
						currentSum: crc32
						isAdler32: false].
	currentIndex := currentIndex + size.
	currentLength := currentLength - size
]

{ #category : #private }
ZlibStreamer >> uncompress: aByteArray firstIndex: firstInteger byteLength: lengthInteger forGzip: aBoolean on: aStream [
	stream := aStream.
	self
		doUncompress: aByteArray
		firstIndex: firstInteger
		byteLength: lengthInteger
		forGzip: aBoolean
]

{ #category : #private }
ZlibStreamer >> uncompress: aByteArray forGzip: aBoolean on: aStream [
	self
		uncompress: aByteArray
		firstIndex: 1
		byteLength: aByteArray size
		forGzip: aBoolean
		on: aStream
]

{ #category : #private }
ZlibStreamer >> uncompress: aByteArray on: aStream [
	self uncompress: aByteArray forGzip: false on: aStream
]
