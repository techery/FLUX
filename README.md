# FLUX

[![CI Status](http://img.shields.io/travis/techery/FLUX.svg?style=flat)](https://travis-ci.org/techery/FLUX)
[![Coverage Status](https://coveralls.io/repos/github/techery/FLUX/badge.svg)](https://coveralls.io/github/techery/FLUX)
[![Version](https://img.shields.io/cocoapods/v/FLUX.svg?style=flat)](http://cocoapods.org/pods/FLUX)
[![License](https://img.shields.io/cocoapods/l/FLUX.svg?style=flat)](http://cocoapods.org/pods/FLUX)
[![Platform](https://img.shields.io/cocoapods/p/FLUX.svg?style=flat)](http://cocoapods.org/pods/FLUX)

[FLUX](https://facebook.github.io/flux/) is an architecture pattern initially designed by Facebook.

## Overview

Initially FLUX was made to store mainly UI state and work tightly with ReactJS framework which allows to re-render view according to state changes.

In iOS development we are tightly bound to UIKit framework that makes it much harder to use FLUX as it was initially intended. Approach that we recommend is to use FLUX as denormalized and non-relational storage for domain objects and application state.

## Features

* Unidirectional data flow
* Lightweight and testable domain layer
* Asynchronous execution
* Extendable via middlewares

## Documentation

We use [Jazzy](https://github.com/realm/jazzy) to autogenerate documentation for FLUX.

You can find documentation inside `docs` folder of the working copy.

## Requirements

* XCode 7+
* iOS 8+

## Installation

FLUX is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "FLUX"
```

## Author

* [Alexey Fayzullov](https://github.com/fuzza)
* [Sergey Zenchenko](https://github.com/sergeyzenchenko)

## License

FLUX is available under the MIT license. See the LICENSE file for more info.
