Class {
	#name : #AbstractZlib,
	#superclass : #Object,
	#instVars : [
		'library',
		'strm',
		'forGzip',
		'level',
		'inBuffer',
		'outBuffer',
		'zResult',
		'currentLength',
		'sourceBytes',
		'currentIndex',
		'zlibVersion'
	],
	#category : #'C-API-Zlib'
}

{ #category : #constants }
AbstractZlib class >> adler32InitSum [
	^1
]

{ #category : #constants }
AbstractZlib class >> bufferSize [
	"64 Ki
	64 bitShift: 10"
	^65536
]

{ #category : #constants }
AbstractZlib class >> crc32InitSum [
	^0
]

{ #category : #utilities }
AbstractZlib class >> library [
	^self platformClass default
]

{ #category : #utilities }
AbstractZlib class >> maxCompressedSize: anInteger [ 
	^anInteger + ((anInteger + 999) // 1000) + 12
]

{ #category : #utilities }
AbstractZlib class >> platformClass [
	^self forLinux: [PH_zlib1_1_2_11_linux] forWindows: [PH_zlib1_1_2_11]
]

{ #category : #utilities }
AbstractZlib class >> version [
	"self version"
	^self platformClass pointerToString: self library zlibVersion
]

{ #category : #constants }
AbstractZlib class >> zBestCompression [
	^9
]

{ #category : #constants }
AbstractZlib class >> zBestSpeed [
	^1
]

{ #category : #constants }
AbstractZlib class >> zBufError [
	^-5
]

{ #category : #constants }
AbstractZlib class >> zDefaultCompression [
	^-1
]

{ #category : #constants }
AbstractZlib class >> zDefaultStrategy [
	^0
]

{ #category : #constants }
AbstractZlib class >> zDefaultWindowBits [
	^15
]

{ #category : #constants }
AbstractZlib class >> zDeflated [
	^8
]

{ #category : #constants }
AbstractZlib class >> zFinish [
	^4
]

{ #category : #constants }
AbstractZlib class >> zMemLevel [
	^8
]

{ #category : #constants }
AbstractZlib class >> zNoCompression [
	^0
]

{ #category : #constants }
AbstractZlib class >> zNoFlush [
	^0
]

{ #category : #constants }
AbstractZlib class >> zOK [
	^0
]

{ #category : #constants }
AbstractZlib class >> zStreamEnd [
	^1
]

{ #category : #constants }
AbstractZlib class >> zSyncFlush [
	^2
]

{ #category : #checksum }
AbstractZlib >> adler32: aByteArray [ 
	^self 
		checksum: aByteArray
		firstIndex: 1
		byteLength: aByteArray size
		currentSum: self class adler32InitSum
		isAdler32: true
]

{ #category : #'basic functions' }
AbstractZlib >> availIn [
	^library avail_in: strm
]

{ #category : #'basic functions' }
AbstractZlib >> availIn: anInteger [
	library avail_in: strm _: anInteger
]

{ #category : #'basic functions' }
AbstractZlib >> availOut [
	^library avail_out: strm
]

{ #category : #'basic functions' }
AbstractZlib >> availOut: anInteger [
	library avail_out: strm _: anInteger
]

{ #category : #private }
AbstractZlib >> checksum: aByteArray firstIndex: firstInteger byteLength: lengthInteger currentSum: sumInteger isAdler32: aBoolean [
	| afterIndex index sum |
	self initChecksum.
	afterIndex := firstInteger + lengthInteger.
	index := firstInteger.
	sum := sumInteger.
	[index < afterIndex] whileTrue: 
			[| byteLength |
			byteLength := self class bufferSize min: afterIndex - index.
			sum := self
						checksumBlock: aByteArray
						firstIndex: index
						byteLength: byteLength
						currentSum: sum
						isAdler32: aBoolean.
			index := index + byteLength].
	^sum
]

{ #category : #private }
AbstractZlib >> checksumBlock: aByteArray firstIndex: firstInteger byteLength: lengthInteger currentSum: sumInteger isAdler32: aBoolean [
	self platformClass
		copy: inBuffer
		at: 0
		from: aByteArray
		size: lengthInteger
		startingAt: firstInteger.
	^aBoolean
		ifTrue: [library adler32: sumInteger _: inBuffer _: lengthInteger]
		ifFalse: [library crc32: sumInteger _: inBuffer _: lengthInteger]
]

{ #category : #private }
AbstractZlib >> checkZResult: aBoolean [
	aBoolean ifTrue: [^self].
	self
		error: 'Error on zlib function: ' , zResult displayString , ' ['
				, (self errorMessage) , ']'
]

{ #category : #private }
AbstractZlib >> checkZResultOK [
	^self checkZResult: self isZResultOK
]

{ #category : #private }
AbstractZlib >> checkZResultOKOrStreamEnd [
	^self checkZResult: self isZResultOKOrStreamEnd
]

{ #category : #private }
AbstractZlib >> checkZResultOKOrStreamEndOrBufError [
	^self checkZResult: self isZResultOKOrStreamEndOrBufError
]

{ #category : #private }
AbstractZlib >> copyChunks [
	self subclassResponsibility
]

{ #category : #private }
AbstractZlib >> copyOutBuffer [
	self subclassResponsibility
]

{ #category : #checksum }
AbstractZlib >> crc32: aByteArray [ 
	^self 
		checksum: aByteArray
		firstIndex: 1
		byteLength: aByteArray size
		currentSum: self class crc32InitSum
		isAdler32: false
]

{ #category : #checksum }
AbstractZlib >> crc32onFilename: aFilename [
	| stream |
	stream := aFilename asXFilename binaryReadStream.
	^[self crc32onStream: stream] ensure: [stream close]
]

{ #category : #checksum }
AbstractZlib >> crc32onStream: aStream [
	| buffer sum |
	self initChecksum.
	buffer := ByteArray new: self class bufferSize.
	sum := self class crc32InitSum.
	[aStream atEnd] whileFalse: 
			[| byteLength |
			byteLength := aStream
						nextBytes: buffer
						from: 1
						length: buffer size.
			sum := self
						checksumBlock: buffer
						firstIndex: 1
						byteLength: byteLength
						currentSum: sum
						isAdler32: false].
	^sum
]

{ #category : #'basic functions' }
AbstractZlib >> deflate: anInteger [
	zResult := library deflate: strm _: anInteger
]

{ #category : #private }
AbstractZlib >> deflateClose [
	self flateClose: [:flush | self deflate: flush]
]

{ #category : #'basic functions' }
AbstractZlib >> deflateEnd [
	zResult := library deflateEnd: strm
]

{ #category : #'basic functions' }
AbstractZlib >> deflateInit [
	^forGzip
		ifFalse: [self deflateInitForZlib]
		ifTrue: [self deflateInitForGzip]
]

{ #category : #'basic functions' }
AbstractZlib >> deflateInitForGzip [
	zResult := library
				deflateInit2_: strm
				_: level
				_: self class zDeflated
				_: self class zDefaultWindowBits negated
				_: self class zMemLevel
				_: self class zDefaultStrategy
				_: zlibVersion
				_: self platformClass stream_size
]

{ #category : #'basic functions' }
AbstractZlib >> deflateInitForZlib [
	zResult := library
				deflateInit_: strm
				_: level
				_: zlibVersion
				_: self platformClass stream_size
]

{ #category : #private }
AbstractZlib >> deflateUpdate [
	[self isFlateDone] whileFalse: 
			[self ensureBuffers.
			self deflate: self class zNoFlush.
			self checkZResultOK]
]

{ #category : #private }
AbstractZlib >> doCompress [
	
	[self deflateInit.
	self checkZResultOK.
	self deflateUpdate.
	self deflateClose]
			ensure: 
				[self deflateEnd.
				self checkZResultOK]
]

{ #category : #compressing }
AbstractZlib >> doCompress: aByteArray firstIndex: firstInteger byteLength: lengthInteger level: levelInteger forGzip: aBoolean [
	self
		initFlate;
		setSource: aByteArray
			firstIndex: firstInteger
			byteLength: lengthInteger
			level: levelInteger
			forGzip: aBoolean.
	self doCompress
]

{ #category : #private }
AbstractZlib >> doUncompress [
	
	[self inflateInit.
	self checkZResultOK.
	self inflateUpdate.
	self inflateClose]
			ensure: 
				[self inflateEnd.
				self checkZResultOK]
]

{ #category : #uncompressing }
AbstractZlib >> doUncompress: aByteArray firstIndex: firstInteger byteLength: lengthInteger forGzip: aBoolean [
	self
		initFlate;
		setSource: aByteArray
			firstIndex: firstInteger
			byteLength: lengthInteger
			level: 0
			forGzip: aBoolean.
	self doUncompress
]

{ #category : #private }
AbstractZlib >> emptyOutBuffer: aByteArray firstIndex: firstInteger byteLength: lengthInteger [
	self platformClass
		copy: outBuffer
		at: 0
		to: aByteArray
		size: lengthInteger
		startingAt: firstInteger.
	self nextOutAvailOut
]

{ #category : #private }
AbstractZlib >> ensureBuffers [
	self ensureInBuffer.
	self ensureOutBuffer
]

{ #category : #private }
AbstractZlib >> ensureInBuffer [
	| size |
	(self isInBufferEmpty and: [currentLength > 0]) ifFalse: [^self].
	size := currentLength min: self class bufferSize.
	self fillInBuffer: sourceBytes firstIndex: currentIndex byteLength: size.
	currentIndex := currentIndex + size.
	currentLength := currentLength - size
]

{ #category : #private }
AbstractZlib >> ensureOutBuffer [
	self isOutBufferEmpty ifFalse: [^self].
	self copyOutBuffer
]

{ #category : #private }
AbstractZlib >> errorMessage [
	^library msgAsString: strm
]

{ #category : #private }
AbstractZlib >> fillInBuffer: aByteArray firstIndex: firstInteger byteLength: lengthInteger [
	self platformClass
		copy: inBuffer
		at: 0
		from: aByteArray
		size: lengthInteger
		startingAt: firstInteger.
	self nextInAvailIn: lengthInteger
]

{ #category : #private }
AbstractZlib >> flateClose: aBlock [ 
	[self isFlateCloseDone] whileFalse: 
			[self ensureBuffers.
			aBlock value: self class zFinish.
			self checkZResultOKOrStreamEndOrBufError].
	self copyOutBuffer.
	self copyChunks
]

{ #category : #'basic functions' }
AbstractZlib >> inflate: anInteger [
	zResult := library inflate: strm _: anInteger
]

{ #category : #private }
AbstractZlib >> inflateClose [
	self flateClose: [:flush | self inflate: flush]
]

{ #category : #'basic functions' }
AbstractZlib >> inflateEnd [
	zResult := library inflateEnd: strm
]

{ #category : #'basic functions' }
AbstractZlib >> inflateInit [
	^forGzip 
		ifFalse: [self inflateInitForZlib]
		ifTrue: [self inflateInitForGzip]
]

{ #category : #'basic functions' }
AbstractZlib >> inflateInitForGzip [
	zResult := library
				inflateInit2_: strm
				_: self class zDefaultWindowBits negated
				_: zlibVersion
				_: self platformClass stream_size
]

{ #category : #'basic functions' }
AbstractZlib >> inflateInitForZlib [
	zResult := library
				inflateInit_: strm
				_: zlibVersion
				_: self platformClass stream_size
]

{ #category : #private }
AbstractZlib >> inflateStep [
	self ensureBuffers.
	self inflate: self class zSyncFlush.
	^self checkZResultOKOrStreamEnd
]

{ #category : #private }
AbstractZlib >> inflateUpdate [
	self inflateStep.
	[self isFlateDone] whileFalse: [self inflateStep]
]

{ #category : #private }
AbstractZlib >> initChecksum [
	library := self class library.
	inBuffer := self platformClass gcMalloc: self class bufferSize
]

{ #category : #private }
AbstractZlib >> initFlate [
	library := self class library.
	zlibVersion := library zlibVersion.
	strm := self platformClass gcMallocStrm.
	inBuffer := self platformClass gcMalloc: self class bufferSize.
	outBuffer := self platformClass gcMalloc: self class bufferSize.
	self
		strmInit;
		nextInAvailIn: 0;
		nextOutAvailOut
]

{ #category : #private }
AbstractZlib >> isFlateCloseDone [
	^zResult = self class zStreamEnd 
		or: [forGzip and: [zResult = self class zBufError]]
]

{ #category : #private }
AbstractZlib >> isFlateDone [
	^(currentLength isZero
		and: [self isInBufferEmpty and: [self isOutBufferEmpty not]])
			or: [self isZResultStreamEnd]
]

{ #category : #private }
AbstractZlib >> isInBufferEmpty [
	^self availIn isZero
]

{ #category : #private }
AbstractZlib >> isOutBufferEmpty [
	^self availOut isZero
]

{ #category : #private }
AbstractZlib >> isZResultOK [
	^zResult = self class zOK
]

{ #category : #private }
AbstractZlib >> isZResultOKOrStreamEnd [
	^self isZResultOK or: [self isZResultStreamEnd]
]

{ #category : #private }
AbstractZlib >> isZResultOKOrStreamEndOrBufError [
	^self isZResultOKOrStreamEnd 
		or: [forGzip and: [zResult = self class zBufError]]
]

{ #category : #private }
AbstractZlib >> isZResultStreamEnd [
	^zResult = self class zStreamEnd
]

{ #category : #'basic functions' }
AbstractZlib >> nextIn: in [
	library next_in: strm _: in
]

{ #category : #private }
AbstractZlib >> nextInAvailIn: lengthInteger [ 
	self
		nextIn: inBuffer;
		availIn: lengthInteger
]

{ #category : #'basic functions' }
AbstractZlib >> nextOut: out [
	library next_out: strm _: out
]

{ #category : #private }
AbstractZlib >> nextOutAvailOut [
	self
		nextOut: outBuffer;
		availOut: self class bufferSize
]

{ #category : #private }
AbstractZlib >> platformClass [
	^self class platformClass
]

{ #category : #private }
AbstractZlib >> privateCopyOutBuffer [
	| size bytes |
	size := self class bufferSize - self availOut.
	bytes := ByteArray new: size.
	self emptyOutBuffer: bytes firstIndex: 1 byteLength: size.
	^bytes
]

{ #category : #private }
AbstractZlib >> setSource: aByteArray firstIndex: firstInteger byteLength: lengthInteger level: levelInteger forGzip: aBoolean [
	((aByteArray isKindOf: SystemPrimitives doubleByteStringClass)
		or: [aByteArray isKindOf: SystemPrimitives quadByteStringClass])
			ifTrue: 
				[self
					error: 'trying to compress a multi bytes character collection. Not a good idea!'].
	sourceBytes := aByteArray.
	currentIndex := firstInteger.
	currentLength := lengthInteger.
	level := levelInteger.
	forGzip := aBoolean
]

{ #category : #'basic functions' }
AbstractZlib >> strmInit [
	library strmInit: strm
]

{ #category : #'basic functions' }
AbstractZlib >> totalIn [
	^library total_in: strm
]

{ #category : #'basic functions' }
AbstractZlib >> totalOut [
	^library total_out: strm
]
