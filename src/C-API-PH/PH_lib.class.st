Class {
	#name : #'PH_lib',
	#superclass : #Object,
	#classInstVars : [
		'default'
	],
	#category : #'C-API-PH'
}

{ #category : #C }
PH_lib class >> asCString: aByteString [
	| cString |
	cString := self gcMalloc: 1 + aByteString size.
	self
		copy: cString
		at: 0
		from: aByteString
		size: aByteString size
		startingAt: 1.
	cString byteAt: 1 + aByteString size put: 0.
	^cString
]

{ #category : #C }
PH_lib class >> byteStringCopy: cBuffer to: aString [
	self
		copy: cBuffer
		at: 0
		to: aString
		size: aString size
		startingAt: 1
]

{ #category : #C }
PH_lib class >> copy: cBuffer at: offset from: byteData size: dataSize startingAt: startIndex [
	| p ba |
	p := offset = 0 ifTrue: [cBuffer] ifFalse: [cBuffer + offset].
	ba := startIndex = 1
				ifTrue: [byteData]
				ifFalse: [byteData copyFrom: startIndex to: startIndex + dataSize - 1].
	LibC memCopy: ba to: p size: dataSize
]

{ #category : #C }
PH_lib class >> copy: cBuffer at: offset to: byteData size: dataSize startingAt: startIndex [
	| p ba |
	p := offset = 0 ifTrue: [cBuffer] ifFalse: [cBuffer + offset].
	ba := startIndex = 1 ifTrue: [byteData] ifFalse: [ByteArray new: dataSize].
	LibC memCopy: p to: ba size: dataSize.
	startIndex = 1
		ifFalse: 
			[byteData
				replaceFrom: startIndex
				to: startIndex + dataSize - 1
				with: ba
				startingAt: 1]
]

{ #category : #accessing }
PH_lib class >> currentLibs [
	| collection |
	collection := OrderedCollection new.
	collection
		add: PH_libcrypto_1_1_0h;
		add: PH_JVM_Bridge_1_5;
		add: AbstractZlib platformClass;
		add: Sys platformClass;
		add: PH_WindowsKernel.
	^collection reject: [:each | each isNil]
]

{ #category : #C }
PH_lib class >> default [
	^default
]

{ #category : #C }
PH_lib class >> doubleByteStringCopy: cBuffer to: aString [
	self
		copy: cBuffer
		at: 0
		to: aString
		size: 2 * aString size
		startingAt: 1
]

{ #category : #C }
PH_lib class >> gcMalloc: sizeInteger [
	^ExternalAddress gcallocate: sizeInteger
]

{ #category : #'class initialization' }
PH_lib class >> initialize [
	default := self new
]

{ #category : #accessing }
PH_lib class >> initializeCurrentLibs [
	self currentLibs do: [:lib | lib initialize]
]

{ #category : #C }
PH_lib class >> isNull: cPointer [
	^cPointer isNull
]

{ #category : #C }
PH_lib class >> pointerSize [
	^Smalltalk vm wordSize
]

{ #category : #C }
PH_lib class >> pointerToString: cPointer [
	"Pharo directly converts a char * into a ByteString.
	Indeed, cPointer is a misnomer."
	^cPointer
]

{ #category : #C }
PH_lib class >> quadByteStringCopy: cBuffer to: aString [
	self
		copy: cBuffer
		at: 0
		to: aString
		size: 4 * aString size
		startingAt: 1
]

{ #category : #C }
PH_lib class >> stringCopy: cBuffer from: aString bytesPerChar: bytesPerChar [
	self
		copy: cBuffer
		at: 0
		from: aString
		size: aString size * bytesPerChar
		startingAt: 1
]
