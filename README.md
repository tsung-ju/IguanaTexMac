NOTE: This repository is for the deprecated macOS port of IguanaTex.
Support for macOS has been merged back into [the original IguanaTex](https://github.com/Jonathan-LeRoux/IguanaTex) since version 1.60,
along with some additional features such as vector graphics, resizable input window, keyboard shortcuts, and support for M1 macs.

# IguanaTexMac

This is very experimental. Use at your own risk!

## Known Issues
* Vector graphics are not supported
  * PowerPoint for Mac does not yet support converting emf images into shapes
  * See https://powerpoint.uservoice.com/forums/288925/suggestions/34217164
* The input window is not resizable
* Using IguanaTexMac on the Apple silicon based version of PowerPoint results in the programm crashing
  * Running PowerPoint with the setting “Open using Rosetta.” works (only relevant for Apple silicon based Macs)

## Prerequisites
* PowerPoint for Mac. Supported versions:
  * PowerPoint 2016 (Version 16.16.7 190210 or later)
  * PowerPoint 2019
* MacTeX

## Install

### Method 1: Install with [Homebrew](https://brew.sh)

```bash
brew tap tsung-ju/iguanatexmac
brew install --cask --no-quarantine iguanatexmac
```

To uninstall:

```bash
brew uninstall --cask iguanatexmac
brew untap tsung-ju/iguanatexmac
# Restart PowerPoint for the changes to take effect
```

### Method 2: Install Manually

1. [Dowload the "prebuilt files" zip from the latest release](https://github.com/tsung-ju/IguanaTexMac/releases)

There are 3 files to install:
* `IguanaTex.scpt`
  * An AppleScript file for bypassing the sandbox introduced in Office 2016
  * See https://msdn.microsoft.com/en-us/vba/vba-office-mac
* `libIguanaTexHelper.dylib`
  * Library for creating native text views
  * The source code is included in the git repo, under the "IguanaTexHelper/" directory.
* `IguanaTexMac.ppam`
  * The main plugin file

2. Install `IguanaTex.scpt`
```bash
mkdir -p ~/Library/Application\ Scripts/com.microsoft.Powerpoint
cp ./IguanaTex.scpt ~/Library/Application\ Scripts/com.microsoft.Powerpoint/IguanaTex.scpt
```

3. Install `libIguanaTexHelper.dylib`
```bash
sudo mkdir -p '/Library/Application Support/Microsoft/Office365/User Content.localized/Add-Ins.localized'
sudo cp ./libIguanaTexHelper.dylib '/Library/Application Support/Microsoft/Office365/User Content.localized/Add-Ins.localized/libIguanaTexHelper.dylib'
```

4. Start PowerPoint. From the menu bar, select Tools > PowerPoint Add-ins... > '+' , and choose `IguanaTexMac.ppam`


Original README
===============

# IguanaTex

(C) Jonathan Le Roux and Zvika Ben-Haim
Website: http://www.jonathanleroux.org/software/iguanatex/

IguanaTex is a PowerPoint add-in which allows you to insert LaTeX equations into your PowerPoint presentation on Windows. It is distributed completely for free, along with its source code.

This repository hosts the source code in a form that can be easily tracked, shared and discussed.

For those interested in using IguanaTex, please download the add-in as a .ppam or .pptm file from http://www.jonathanleroux.org/software/iguanatex/.
