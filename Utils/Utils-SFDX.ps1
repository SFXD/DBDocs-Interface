<#
    A Utility script that handles the SFDX pull and cleanup for the DBDocs integration
    Done by Geoffrey Bessereau, 2020-05-18
#>


function GET-SFDX-DATA {
    param(
        [String]$OrgAlias
    )
    sfdx force:mdapi:retrieve -r ".\sfdx\metadata" -u $OrgAlias -k .\sfdx\manifest\package.xml
    Expand-Archive .\sfdx\metadata\unpackaged.zip .\sfdx\
    Remove-Item .\sfdx\objects\ -Recurse -ErrorAction 'silentlycontinue'
    Move-Item .\sfdx\unpackaged\objects\ .\sfdx\objects\ -Force
    Remove-Item .\sfdx\metadata\ -Recurse
    Remove-Item .\sfdx\unpackaged -Recurse
}