## How to DSC

You can use DSC configurations 
* in VM custom script extension
* in Azure Automation Account


| file     | description    |
| -------- | -------------- |
| foo.ps1  | configuration file<br />contains one or more DSC configurations |
| foo.zip  | zipped configuration file for use in VM custom script extension<br />should contain only foo.ps1 (only one .ps1 file is allowed in VM custom script extension)  |
| foo.mof  | compiled configuration<br />compilation is done by VM custom script extension or by Azure Automation Account  |