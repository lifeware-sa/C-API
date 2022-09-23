Class {
	#name : #GZTestCase,
	#superclass : #LwTestCase,
	#category : #'C-API-Zlib-Tests'
}

{ #category : #run }
GZTestCase >> testBadCompressionMethod [
	| variant |
	variant := self xpCompressed.
	variant at: 3 put: 0.
	self shouldRaiseError: [GZ gunzip: variant]
		description: 'Bad compression method'
]

{ #category : #run }
GZTestCase >> testEncryption [
	| variant |
	variant := self xpCompressed.
	variant at: 4 put: GZ encryptFlag.
	self shouldRaiseError: [GZ gunzip: variant]
		description: 'Cannot decompress encrypted stream'
]

{ #category : #run }
GZTestCase >> testFilename [
	| aString compressed |
	aString := 'pippo'.
	compressed := GZ gzip: self xpUncompressed filename: aString.
	self assert: (GZ basicGunzip: compressed) filename = aString
]

{ #category : #run }
GZTestCase >> testGUnzip [
	self assert: self xpUncompressed = (GZ gunzip: self xpCompressed)
]

{ #category : #run }
GZTestCase >> testGUnzipToStream [
	| stream |
	stream := ByteArray new writeStream.
	(GZ gunzip: self xpCompressed on: stream).
	self assert: self xpUncompressed = stream contents
]

{ #category : #run }
GZTestCase >> testGZip [
	self assert: (GZ gzip: self xpUncompressed) = self xpCompressed
]

{ #category : #run }
GZTestCase >> testGZipToStream [
	| stream |
	stream := ByteArray new writeStream.
	GZ gzip: self xpUncompressed on: stream.
	self assert: stream contents = self xpCompressed
]

{ #category : #run }
GZTestCase >> testMagic [
	| variant |
	variant := self xpCompressed.
	variant at: 1 put: 0.
	self shouldRaiseError: [GZ gunzip: variant]
		description: 'Not a GZipped stream'
]

{ #category : #run }
GZTestCase >> testReserved [
	| variant |
	variant := self xpCompressed.
	variant at: 4 put: GZ reservedFlags.
	self shouldRaiseError: [GZ gunzip: variant]
		description: 'Cannot decompress stream with unknown flags'
]

{ #category : #'expected results' }
GZTestCase >> xpCompressed [
	^#[31 139 8 0 0 0 0 0 0 255 203 75 205 81 200 77 173 170 202 87 72 1 178 146 19 115 115 51 243 20 82 50 21 242 242 139 75 138 18 21 202 50 75 18 245 244 244 0 162 81 225 19 38 0 0 0] 
		copy
]

{ #category : #'expected results' }
GZTestCase >> xpUncompressed [
	^'nel mezzo del cammin di nostra vita...' asByteArray
]
