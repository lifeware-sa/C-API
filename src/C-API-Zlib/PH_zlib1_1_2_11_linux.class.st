Class {
	#name : #'PH_zlib1_1_2_11_linux',
	#superclass : #'PH_zlib1_1_2_11',
	#category : #'C-API-Zlib'
}

{ #category : #private }
PH_zlib1_1_2_11_linux class >> stream_size_64 [
	"On a 64 bit Pharo/Linux platform:
sizeof(z_stream): 112

offsetof(z_stream, next_in): 0
offsetof(z_stream, avail_in): 8
offsetof(z_stream, total_in): 16
offsetof(z_stream, next_out): 24
offsetof(z_stream, avail_out): 32
offsetof(z_stream, total_out): 40
offsetof(z_stream, msg): 48
offsetof(z_stream, state): 56
offsetof(z_stream, zalloc): 64
offsetof(z_stream, zfree): 72
offsetof(z_stream, opaque): 80
offsetof(z_stream, data_type): 88
offsetof(z_stream, adler): 96
offsetof(z_stream, reserved): 104"
	^ 112
]

{ #category : #private }
PH_zlib1_1_2_11_linux >> avail_out_ix [
	"offsetof(struct z_stream_s, avail_out) + 1"
	^ObjectMemoryInterface is64Bit ifTrue: [33] ifFalse: [17]
]

{ #category : #private }
PH_zlib1_1_2_11_linux >> msg_ix [
	"offsetof(struct z_stream_s, msg) + 1"
	^ObjectMemoryInterface is64Bit ifTrue: [49] ifFalse: [25]
]

{ #category : #private }
PH_zlib1_1_2_11_linux >> next_out_ix [
	"offsetof(struct z_stream_s, next_out) + 1"
	^ObjectMemoryInterface is64Bit ifTrue: [25] ifFalse: [13]
]

{ #category : #private }
PH_zlib1_1_2_11_linux >> opaque_ix [
	"offsetof(struct z_stream_s, opaque) + 1"
	^ObjectMemoryInterface is64Bit ifTrue: [81] ifFalse: [41]
]

{ #category : #private }
PH_zlib1_1_2_11_linux >> total_in_ix [
	"offsetof(struct z_stream_s, total_in) + 1"
	^ObjectMemoryInterface is64Bit ifTrue: [17] ifFalse: [9]
]

{ #category : #private }
PH_zlib1_1_2_11_linux >> total_out_ix [
	"offsetof(struct z_stream_s, total_out) + 1"
	^ObjectMemoryInterface is64Bit ifTrue: [41] ifFalse: [21]
]

{ #category : #private }
PH_zlib1_1_2_11_linux >> zalloc_ix [
	"offsetof(struct z_stream_s, zalloc) + 1"
	^ObjectMemoryInterface is64Bit ifTrue: [65] ifFalse: [33]
]

{ #category : #private }
PH_zlib1_1_2_11_linux >> zfree_ix [
	"offsetof(struct z_stream_s, zfree) + 1"
	^ObjectMemoryInterface is64Bit ifTrue: [73] ifFalse: [37]
]
