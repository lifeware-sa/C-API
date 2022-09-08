Class {
	#name : #Dll,
	#superclass : #Object,
	#category : #'C-API-Common'
}

{ #category : #'resource management' }
Dll class >> alreadyInstalled: aPath [
	nil
		transcript: '[' , CSTimestamp systemNow displayString , ']: ' , '"'
				, aPath asString , '" is already installed.'
]

{ #category : #accessing }
Dll class >> bytes [
	^self forLinux: 
			[self is64Bit ifTrue: [self bytes7_64_linux] ifFalse: [self bytes7_linux]]
		forWindows: [self is64Bit ifTrue: [self bytes7_64] ifFalse: [self bytes7]]
]

{ #category : #accessing }
Dll class >> bytes7 [
	self subclassResponsibility
]

{ #category : #accessing }
Dll class >> bytes7_64 [
	self subclassResponsibility
]

{ #category : #accessing }
Dll class >> bytes7_64_linux [
	self subclassResponsibility
]

{ #category : #accessing }
Dll class >> bytes7_linux [
	self subclassResponsibility
]

{ #category : #'resource management' }
Dll class >> createLib: aLibClass [
	| filename |
	filename := aLibClass libPathName.
	aLibClass libDirectoryPath makeDeepDirectory.
	nil xtranscript: '**** Save as "' , filename , '"'.
	aLibClass bytes saveAs: filename
]

{ #category : #accessing }
Dll class >> currentDlls [
	| collection |
	collection := OrderedCollection new.
	collection
		add: Dll_libcrypto_1_1_0h;
		add: Dll_JVM_Bridge_1_5;
		add: Dll_zlib1_1_2_11.
	self forLinux: []
		forWindows: 
			[collection
				add: Dll_msvcr100;
				add: Dll_msvcp120;
				add: Dll_msvcr120].
	^collection reject: [:each | each isNil]
]

{ #category : #'resource management' }
Dll class >> ensureDlls [
	Dll currentDlls do: [:each | self ensureLib: each]
]

{ #category : #'resource management' }
Dll class >> ensureLib: libClass [
	libClass hasSameInfos
		ifTrue: [self alreadyInstalled: libClass libPath]
		ifFalse: [self createLib: libClass]
]

{ #category : #converting }
Dll class >> fromHexString: aString [
	| ba |
	aString size \\ 2 = 0 ifFalse: [self error: 'odd length'].
	ba := ByteArray new: aString size // 2.
	2 to: aString size
		by: 2
		do: 
			[:i |
			| hi lo |
			hi := (aString at: i - 1) digitValue.
			(hi between: 0 and: 15) ifFalse: [self error: 'illegal hex digit'].
			lo := (aString at: i) digitValue.
			(lo between: 0 and: 15) ifFalse: [self error: 'illegal hex digit'].
			ba at: i // 2 put: ((hi bitShift: 4) bitOr: lo)].
	^ba
]

{ #category : #'resource management' }
Dll class >> hasSameInfos [
	^self infos = self libInfos
]

{ #category : #accessing }
Dll class >> infos [
	^self
		fromHexString: (self forLinux: 
					[self is64Bit ifTrue: [self infos7_64_linux] ifFalse: [self infos7_linux]]
				forWindows: [self is64Bit ifTrue: [self infos7_64] ifFalse: [self infos7]])
]

{ #category : #accessing }
Dll class >> infos7 [
	self subclassResponsibility
]

{ #category : #accessing }
Dll class >> infos7_64 [
	self subclassResponsibility
]

{ #category : #accessing }
Dll class >> infos7_64_linux [
	self subclassResponsibility
]

{ #category : #accessing }
Dll class >> infos7_linux [
	self subclassResponsibility
]

{ #category : #accessing }
Dll class >> is64Bit [
	^ObjectMemoryInterface is64Bit
]

{ #category : #accessing }
Dll class >> libDirectoryPath [
	^XFilename installBaseFolder
]

{ #category : #accessing }
Dll class >> libFilename [
	^self libName
]

{ #category : #accessing }
Dll class >> libInfos [
	"Returns SHA-256 of library or of empty ByteArray if library is missing"
	| bytes |
	bytes := [self libPathName asXFilename binaryContents]
				on: FileDoesNotExistException
				do: [:ex | ByteArray new].
	^self sha256: bytes
]

{ #category : #accessing }
Dll class >> libName [
	self subclassResponsibility
]

{ #category : #accessing }
Dll class >> libPath [
	^self libDirectoryPath \ self libFilename
]

{ #category : #accessing }
Dll class >> libPathName [
	^self libPath asString
]

{ #category : #accessing }
Dll class >> sha256: aBytes [
	^SHA256 hashMessage: aBytes
]
