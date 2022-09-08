# Library bindings for Smalltalk 

Available libraries:
 - ZLib

Supported Operating systems:
 - Windows
 - Linux

Supported Smalltalk dialects:
 - Pharo

## Installation in Pharo

### ZLib

```Smalltalk
Metacello new
    baseline: 'CApi';
    repository: 'github://lifeware-sa/C-API';
    load: 'ZLib'.
```

### All libraries

```Smalltalk
Metacello new
    baseline: 'CApi';
    repository: 'github://lifeware-sa/C-API';
    load.
```

## Troubleshooting

### Primitive failed when calling a library

Probably the binaries (.dll or .so.1 files) are missing.

After loading code with Metacello, they are automatically extracted. But if you move the image to another folder or computer, you'll need to extract the binaries again by evaluating

```Smalltalk
Dll ensureDlls
```

### Message was sent to nil

Probably a subclass of PH_lib isn't initialized.

After loading code with Metacello, they are automatically initialized, to initialize them manually, evaluate

```Smalltalk
PH_lib initializeCurrentLibs
```
