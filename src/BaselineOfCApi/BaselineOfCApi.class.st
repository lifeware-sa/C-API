Class {
	#name : #BaselineOfCApi,
	#superclass : #BaselineOf,
	#category : #BaselineOfCApi
}

{ #category : #baselines }
BaselineOfCApi >> baseline: spec [
	<baseline>
	spec for: #common
		do: 
			[spec postLoadDoIt: #postload:package:.
			spec baseline: 'LwCompatibilityLayer'
				with: 
					[spec
						loads: #('LwTestCase' 'PlatformSpecific' 'SystemInterface' 'XFilename' 'Transcript' 'Timestamp' 'PackedString' 'NByteArray' 'Random');
						repository: 'github://lifeware-sa/LwCompatibilityLayer/src'].
			spec
				package: 'C-API-Common' with: [spec requires: #('LwCompatibilityLayer')];
				package: 'C-API-PH' with: [spec requires: #('C-API-Common')];
				package: 'C-API-Zlib' with: [spec requires: #('C-API-PH')];
				package: 'C-API-Zlib-Tests' with: [spec requires: #('C-API-Zlib')].
			spec
				group: 'ZLib-Core' with: #('C-API-Zlib');
				group: 'ZLib-Tests' with: #('ZLib-Core' 'C-API-Zlib-Tests')]
]

{ #category : #baselines }
BaselineOfCApi >> postload: loader package: packageSpec [

	Dll ensureDlls.
	PH_lib initializeCurrentLibs
]
