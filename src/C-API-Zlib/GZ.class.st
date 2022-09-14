Class {
	#name : #GZ,
	#superclass : #'C_AbstractApi',
	#instVars : [
		'compressed',
		'uncompressed',
		'filename'
	],
	#category : #'C-API-Zlib'
}

{ #category : #utilities }
GZ class >> basicGunzip: aByteArray [
	^self new setCompressed: aByteArray
]

{ #category : #'instance creation' }
GZ class >> checkHeader: stream [
	| flags headerLength filename |
	(stream next: 2) = self  magic
		ifFalse: [self error: 'Not a GZipped stream'].
	stream next = self deflated
		ifFalse: [self error: 'Bad compression method'].
	flags := stream next.
	(flags anyMask: self encryptFlag)
		ifTrue: [self error: 'Cannot decompress encrypted stream'].
	(flags anyMask: self reservedFlags)
		ifTrue: [self error: 'Cannot decompress stream with unknown flags'].	"Ignore stamp, extra flags, OS type"
	stream
		next: 4;
		next;
		next.
	headerLength := 10.
	(flags anyMask: self continueFlag)
		ifTrue: 
			["Number of multi-part archive - ignored"
			stream next: 2.
			headerLength := headerLength + 2].
	(flags anyMask: self extraField)
		ifTrue: 
			["Extra fields - ignored"
			| length |
			length := (self next: 2) fromTwoBytes.
			headerLength := headerLength + 2.
			1 to: length do: [:i | stream next].
			headerLength := headerLength + length].
	(flags anyMask: self nameFlag)
		ifTrue: 
			[| byte nameStream |
			nameStream := String new writeStream.
			
			[headerLength := headerLength + 1.
			byte := stream next.
			byte = 0]
					whileFalse: [nameStream nextPut: byte asCharacter].
			filename := nameStream contents].
	(flags anyMask: self commentFlag)
		ifTrue: 
			["Comment - ignored"
			
			[headerLength := headerLength + 1.
			stream next = 0] whileFalse].
	^headerLength -> filename
]

{ #category : #constants }
GZ class >> commentFlag [
	^16
]

{ #category : #constants }
GZ class >> continueFlag [
	^2
]

{ #category : #utilities }
GZ class >> deflate: aByteArray on: aStream [
	| crc32 |
	crc32 := ZlibStreamer new
				compress: aByteArray
				firstIndex: 1
				byteLength: aByteArray size
				level: ZlibStreamer zDefaultCompression
				forGzip: false
				on: aStream.
	nil assert: crc32 isNil
]

{ #category : #constants }
GZ class >> deflated [
	^8
]

{ #category : #constants }
GZ class >> encryptFlag [
	^32
]

{ #category : #constants }
GZ class >> extraField [
	^4
]

{ #category : #utilities }
GZ class >> gunzip: aByteArray [
	^(self basicGunzip: aByteArray) uncompressed
]

{ #category : #utilities }
GZ class >> gunzip: aByteArray on: aStream [
	| headerSize |
	headerSize := (self checkHeader: aByteArray readStream) key.
	ZlibStreamer new
		uncompress: aByteArray
		firstIndex: headerSize + 1
		byteLength: aByteArray size - 8 - headerSize
		forGzip: true
		on: aStream
]

{ #category : #utilities }
GZ class >> gunzipNew: aByteArray [
	| headerSize aStream bytes readStream size filename header |
	readStream := aByteArray readStream.
	header := self checkHeader: readStream.
	headerSize := header key.
	filename := header value.
	readStream position: aByteArray size - 4.
	size := (readStream next: 4) fromFourBytes.
	bytes := ByteArray new: size.
	aStream := bytes writeStream.
	ZlibStreamer new
		uncompress: aByteArray
		firstIndex: headerSize + 1
		byteLength: aByteArray size - 8 - headerSize
		forGzip: true
		on: aStream.
	^(aStream contentsSize = bytes size
		ifTrue: [bytes]
		ifFalse: [aStream contents]) -> filename
]

{ #category : #utilities }
GZ class >> gzip: aByteArray [
	^self gzip: aByteArray filename: ''
]

{ #category : #utilities }
GZ class >> gzip: aByteArray filename: aString [
	^(self new setUncompressed: aByteArray filename: aString) compressed	"asByteArray"
]

{ #category : #utilities }
GZ class >> gzip: aByteArray on: aStream [
	| crc32 |
	self writeHeaderOn: aStream filename: ''.
	crc32 := ZlibStreamer new
				compress: aByteArray
				firstIndex: 1
				byteLength: aByteArray size
				level: ZlibStreamer zDefaultCompression
				forGzip: true
				on: aStream.
	nil assert: crc32 notNil.
	self
		writeHeaderOn: aStream
		crc32: crc32
		size: aByteArray size
]

{ #category : #utilities }
GZ class >> inflate: aByteArray on: aStream [
	ZlibStreamer new
		uncompress: aByteArray
		firstIndex: 1
		byteLength: aByteArray size
		forGzip: false
		on: aStream
]

{ #category : #constants }
GZ class >> magic [
	^#[31 139]
]

{ #category : #constants }
GZ class >> nameFlag [
	^8
]

{ #category : #constants }
GZ class >> noExtraFlags [
	^0
]

{ #category : #constants }
GZ class >> noFlags [
	^0
]

{ #category : #constants }
GZ class >> reservedFlags [
	^192
]

{ #category : #constants }
GZ class >> unknownOsType [
	^255
]

{ #category : #private }
GZ class >> writeHeaderOn: stream crc32: crc size: size [
	stream
		nextPutAll: crc asFourBytes;
		nextPutAll: size asFourBytes
]

{ #category : #private }
GZ class >> writeHeaderOn: stream filename: aString [
	| flags fName |
	flags := self noFlags.
	fName := #[].
	aString notEmpty
		ifTrue: 
			[flags := flags bitOr: self nameFlag.
			fName := aString asByteArray , #[0]].
	stream
		nextPutAll: self magic;
		nextPut: self deflated;
		nextPut: flags;
		nextPutAll: 0 asFourBytes;
		nextPut: self noExtraFlags;
		nextPut: self unknownOsType;
		nextPutAll: fName
]

{ #category : #accessing }
GZ >> compressed [
	^compressed
]

{ #category : #accessing }
GZ >> filename [
	^filename
]

{ #category : #private }
GZ >> setCompressed: aByteArray [
	| stream compressedData headerSize header crc size |
	compressed := aByteArray.
	stream := aByteArray readStream.
	header := self class checkHeader: stream.
	headerSize := header key.
	filename := header value.
	compressedData := aByteArray copyFrom: headerSize + 1
				to: aByteArray size - 8.
	stream skip: compressedData size.
	crc := (stream next: 4) fromFourBytes.
	size := (stream next: 4) fromFourBytes.
	uncompressed := Zlib new uncompressForGzip: compressedData.
	(Zlib new crc32: uncompressed) = crc
		ifFalse: [^self error: 'CRC check failed'].
	uncompressed size = size ifFalse: [^self error: 'Wrong expected size']
]

{ #category : #private }
GZ >> setUncompressed: aByteArray filename: aString [
	| stream compressedData |
	filename := aString.
	compressedData := Zlib new compressForGzip: aByteArray.
	compressed := ByteArray new: compressedData size + 18
						+ (aString notEmpty ifTrue: [aString size + 1] ifFalse: [0]).
	stream := compressed writeStream.
	self class writeHeaderOn: stream filename: aString.
	stream nextPutAll: compressedData.
	self class
		writeHeaderOn: stream
		crc32: (Zlib new crc32: aByteArray)
		size: aByteArray size.
	stream contentsSize = compressed size
		ifFalse: [compressed := stream contents]
]

{ #category : #accessing }
GZ >> uncompressed [
	^uncompressed
]
