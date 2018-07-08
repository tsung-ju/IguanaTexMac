# IguanaTexMac

This is very experimental. Use at your own risk!

## Download
https://github.com/ray851107/IguanaTexMac/releases

## Prerequisites
* PowerPoint 2016 Insider Builds
* MacTeX

## Install
There are 3 files to install:
* `IguanaTex.scpt`
  * an AppleScript file for bypassing some restrictions of Office 2016
  * (see https://msdn.microsoft.com/en-us/vba/vba-office-mac)
* `libIguanaTexHelper.dylib`
  * library for creating native text views
* `IguanaTexMac.ppam`
  * the main plugin file

1. install AppleScript (IguanaTex.scpt)
```bash
mkdir -p '~/Library/Application Scripts/com.microsoft.Powerpoint'
cp ./IguanaTex.scpt '~/Library/Application Scripts/com.microsoft.Powerpoint/IguanaTex.scpt'
```
2. install IguanaTexHelper (libIguanaTexHelper.dylib)
```
sudo mkdir -p '/Library/Application Support/Microsoft/Office365/User Content.localized/Add-Ins.localized'
sudo cp ./libIguanaTexHelper.dylib '/Library/Application Support/Microsoft/Office365/User Content.localized/Add-Ins.localized/libIguanaTexHelper.dylib'
```
3. start PowerPoint, Tools > PowerPoint Add-ins... > '+' , select IguanaTexMac.ppam


Original README
===============

# IguanaTex

(C) Jonathan Le Roux and Zvika Ben-Haim
Website: http://www.jonathanleroux.org/software/iguanatex/

IguanaTex is a PowerPoint add-in which allows you to insert LaTeX equations into your PowerPoint presentation on Windows. It is distributed completely for free, along with its source code.

This repository hosts the source code in a form that can be easily tracked, shared and discussed.

For those interested in using IguanaTex, please download the add-in as a .ppam or .pptm file from http://www.jonathanleroux.org/software/iguanatex/.
