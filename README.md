# Library bindings for Smalltalk 

[![GitHub Workflow Status][github_action_b]][github_action_url]
[![Coverage Status][coverage_status_b]][coverage_status_url]
[![License][license_b]][license_url]

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
    load: 'ZLib-Core'.
```

### All libraries + test cases

```Smalltalk
Metacello new
    baseline: 'CApi';
    repository: 'github://lifeware-sa/C-API';
    load.
```

## C-API as a dependency

If you wish to set a dependency to C-API in your application, you simply need to add the following in your baseline:

```Smalltalk
spec
    baseline: 'CApi'
    with: [ spec repository: 'github://lifeware-sa/C-API/src' ].
```

To depend on a partial version of C-API, you may use:

```Smalltalk
spec baseline: 'CApi' with: [
    spec
        loads: #( 'ZLib-Core' );
        repository: 'github://lifeware-sa/C-API/src' ].
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

[github_action_b]: https://img.shields.io/github/workflow/status/lifeware-sa/C-API/smalltalkCI/master
[github_action_url]: https://github.com/lifeware-sa/C-API/actions
[coverage_status_b]: https://coveralls.io/repos/github/lifeware-sa/C-API/badge.svg?branch=master
[coverage_status_url]: https://coveralls.io/github/lifeware-sa/C-API?branch=master
[license_b]: https://img.shields.io/github/license/lifeware-sa/C-API
[license_url]: LICENSE
