Class {
	#name : #BaselineOfCApi,
	#superclass : #BaselineOf,
	#category : #BaselineOfCApi
}

{ #category : #baselines }
BaselineOfCApi >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec postLoadDoIt: #postload:package:.

		spec baseline: 'LwCompatibilityLayer' with: [ 
			spec
				loads: #( 'PersistentObject' 'LwTestCase' 'PlatformSpecific'
					   'SystemInterface' 'XFilename' 'Transcript' 'Timestamp'
					   'PackedString' 'NByteArray' );
				repository: 'github://lifeware-sa/LwCompatibilityLayer:bubu/src' ].

		spec
			package: 'C-API-Common'
			with: [ spec requires: #( 'LwCompatibilityLayer' ) ];
			package: 'C-API-PH'
			with: [ spec requires: #( 'LwCompatibilityLayer'
					   'C-API-Common' ) ];
			package: 'C-API-Zlib' with: [ 
				spec requires:
						#( 'LwCompatibilityLayer' 'C-API-Common' 'C-API-PH' ) ].

		spec group: 'ZLib' with: #( 'C-API-Zlib' ) ]
]

{ #category : #baselines }
BaselineOfCApi >> postload: loader package: packageSpec [

	Dll ensureDlls.
	PH_lib initializeCurrentLibs
]
