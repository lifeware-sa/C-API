Class {
	#name : #'PH_zlib1_1_2_11',
	#superclass : #'PH_lib',
	#category : #'C-API-Zlib'
}

{ #category : #accessing }
PH_zlib1_1_2_11 class >> dllClass [
	^Dll_zlib1_1_2_11
]

{ #category : #accessing }
PH_zlib1_1_2_11 class >> gcMallocStrm [
	^self gcMalloc: self stream_size
]

{ #category : #testing }
PH_zlib1_1_2_11 class >> isOpenSourceClass [
	^true
]

{ #category : #accessing }
PH_zlib1_1_2_11 class >> libName [
	^self dllClass libName
]

{ #category : #accessing }
PH_zlib1_1_2_11 class >> stream_size [
	^ObjectMemoryInterface is64Bit
		ifTrue: [self stream_size_64]
		ifFalse: [self stream_size_32]
]

{ #category : #private }
PH_zlib1_1_2_11 class >> stream_size_32 [
	"On a 32 bit Pharo/Win platform:
sizeof(z_stream): 56

offsetof(z_stream, next_in): 0
offsetof(z_stream, avail_in): 4
offsetof(z_stream, total_in): 8
offsetof(z_stream, next_out): 12
offsetof(z_stream, avail_out): 16
offsetof(z_stream, total_out): 20
offsetof(z_stream, msg): 24
offsetof(z_stream, state): 28
offsetof(z_stream, zalloc): 32
offsetof(z_stream, zfree): 36
offsetof(z_stream, opaque): 40
offsetof(z_stream, data_type): 44
offsetof(z_stream, adler): 48
offsetof(z_stream, reserved): 52"
	^56
]

{ #category : #private }
PH_zlib1_1_2_11 class >> stream_size_64 [
	"On a 64 bit Pharo/Win platform:
sizeof(z_stream): 88

offsetof(z_stream, next_in): 0
offsetof(z_stream, avail_in): 8
offsetof(z_stream, total_in): 12
offsetof(z_stream, next_out): 16
offsetof(z_stream, avail_out): 24
offsetof(z_stream, total_out): 28
offsetof(z_stream, msg): 32
offsetof(z_stream, state): 40
offsetof(z_stream, zalloc): 48
offsetof(z_stream, zfree): 56
offsetof(z_stream, opaque): 64
offsetof(z_stream, data_type): 72
offsetof(z_stream, adler): 76
offsetof(z_stream, reserved): 80"
	^ 88.
]

{ #category : #procedures }
PH_zlib1_1_2_11 >> adler32: adler _: buf _: len [
	^self
		ffiCall: #(#ulong #adler32 #(#ulong #adler #, #void #* #buf #, #ulong #len))
		module: self libName
]

{ #category : #'basic api' }
PH_zlib1_1_2_11 >> avail_in: strm [
	^strm unsignedLongAt: self avail_in_ix
]

{ #category : #'basic api' }
PH_zlib1_1_2_11 >> avail_in: strm _: anInteger [
	strm unsignedLongAt: self avail_in_ix put: anInteger
]

{ #category : #private }
PH_zlib1_1_2_11 >> avail_in_ix [
	"offsetof(struct z_stream_s, avail_in) + 1"
	^ObjectMemoryInterface is64Bit ifTrue: [9] ifFalse: [5]
]

{ #category : #'basic api' }
PH_zlib1_1_2_11 >> avail_out: strm [
	^strm unsignedLongAt: self avail_out_ix
]

{ #category : #'basic api' }
PH_zlib1_1_2_11 >> avail_out: strm _: anInteger [
	strm unsignedLongAt: self avail_out_ix put: anInteger
]

{ #category : #private }
PH_zlib1_1_2_11 >> avail_out_ix [
	"offsetof(struct z_stream_s, avail_out) + 1"
	^ObjectMemoryInterface is64Bit ifTrue: [25] ifFalse: [17]
]

{ #category : #procedures }
PH_zlib1_1_2_11 >> crc32: crc _: buf _: len [
	^self
		ffiCall: #(#ulong #crc32 #(#ulong #crc #, #void #* #buf #, #ulong #len))
		module: self libName
]

{ #category : #procedures }
PH_zlib1_1_2_11 >> deflate: strm _: flush [
	^self ffiCall: #(#int #deflate #(#void #* #strm #, #int #flush))
		module: self libName
]

{ #category : #procedures }
PH_zlib1_1_2_11 >> deflateEnd: strm [
	^self ffiCall: #(#int #deflateEnd #(#void #* #strm)) module: self libName
]

{ #category : #procedures }
PH_zlib1_1_2_11 >> deflateInit2_: strm _: level _: method _: windowBits _: memLevel _: strategy _: version _: stream_size [
	^self
		ffiCall: #(#int #deflateInit2_ #(#void #* #strm #, #int #level #, #int #method #, #int #windowBits #, #int #memLevel #, #int #strategy #, #void #* #version #, #int #stream_size))
		module: self libName
]

{ #category : #procedures }
PH_zlib1_1_2_11 >> deflateInit_: strm _: level _: version _: stream_size [
	^self
		ffiCall: #(#int #deflateInit_ #(#void #* #strm #, #int #level #, #void #* #version #, #int #stream_size))
		module: self libName
]

{ #category : #procedures }
PH_zlib1_1_2_11 >> inflate: strm _: flush [
	^self ffiCall: #(#int #inflate #(#void #* #strm #, #int #flush))
		module: self libName
]

{ #category : #procedures }
PH_zlib1_1_2_11 >> inflateEnd: strm [
	^self ffiCall: #(#int #inflateEnd #(#void #* #strm)) module: self libName
]

{ #category : #procedures }
PH_zlib1_1_2_11 >> inflateInit2_: strm _: windowBits _: version _: stream_size [
	^self
		ffiCall: #(#int #inflateInit2_ #(#void #* #strm #, #int #windowBits #, #void #* #version #, #int #stream_size))
		module: self libName
]

{ #category : #procedures }
PH_zlib1_1_2_11 >> inflateInit_: strm _: version _: stream_size [
	^self
		ffiCall: #(#int #inflateInit_ #(#void #* #strm #, #void #* #version #, #int #stream_size))
		module: self libName
]

{ #category : #accessing }
PH_zlib1_1_2_11 >> libName [
	^self class libName
]

{ #category : #'basic api' }
PH_zlib1_1_2_11 >> msgAsString: strm [
	^(strm pointerAt: self msg_ix) fromCString
]

{ #category : #private }
PH_zlib1_1_2_11 >> msg_ix [
	"offsetof(struct z_stream_s, msg) + 1"
	^ObjectMemoryInterface is64Bit ifTrue: [33] ifFalse: [25]
]

{ #category : #'basic api' }
PH_zlib1_1_2_11 >> next_in: strm _: inBuffer [
	strm pointerAt: self next_in_ix put: inBuffer
]

{ #category : #private }
PH_zlib1_1_2_11 >> next_in_ix [
	"offsetof(struct z_stream_s, next_in) + 1"
	^1
]

{ #category : #'basic api' }
PH_zlib1_1_2_11 >> next_out: strm _: outBuffer [
	strm pointerAt: self next_out_ix put: outBuffer
]

{ #category : #private }
PH_zlib1_1_2_11 >> next_out_ix [
	"offsetof(struct z_stream_s, next_out) + 1"
	^ObjectMemoryInterface is64Bit ifTrue: [17] ifFalse: [13]
]

{ #category : #private }
PH_zlib1_1_2_11 >> opaque_ix [
	"offsetof(struct z_stream_s, opaque) + 1"
	^ObjectMemoryInterface is64Bit ifTrue: [65] ifFalse: [41]
]

{ #category : #'basic api' }
PH_zlib1_1_2_11 >> strmInit: strm [
	| null |
	null := ExternalAddress null.
	strm
		pointerAt: self zalloc_ix put: null;
		pointerAt: self zfree_ix put: null;
		pointerAt: self opaque_ix put: null
]

{ #category : #'basic api' }
PH_zlib1_1_2_11 >> total_in: strm [
	^strm unsignedLongLongAt: self total_in_ix
]

{ #category : #private }
PH_zlib1_1_2_11 >> total_in_ix [
	"offsetof(struct z_stream_s, total_in) + 1"
	^ObjectMemoryInterface is64Bit ifTrue: [13] ifFalse: [9]
]

{ #category : #'basic api' }
PH_zlib1_1_2_11 >> total_out: strm [
	^strm unsignedLongLongAt: self total_out_ix
]

{ #category : #private }
PH_zlib1_1_2_11 >> total_out_ix [
	"offsetof(struct z_stream_s, total_out) + 1"
	^ObjectMemoryInterface is64Bit ifTrue: [29] ifFalse: [21]
]

{ #category : #private }
PH_zlib1_1_2_11 >> zalloc_ix [
	"offsetof(struct z_stream_s, zalloc) + 1"
	^ObjectMemoryInterface is64Bit ifTrue: [49] ifFalse: [33]
]

{ #category : #private }
PH_zlib1_1_2_11 >> zfree_ix [
	"offsetof(struct z_stream_s, zfree) + 1"
	^ObjectMemoryInterface is64Bit ifTrue: [57] ifFalse: [37]
]

{ #category : #procedures }
PH_zlib1_1_2_11 >> zlibVersion [
	^self ffiCall: #(#void #* #zlibVersion #(#void)) module: self libName
]
