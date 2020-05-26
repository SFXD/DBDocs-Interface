<#
    A Utility script that handles the Project creation for the DBDocs integration
    Done by Geoffrey Bessereau, 2020-05-18
    Declare Utility functions.
    Stuff that didn't go elsewhere.
#>

function Get-ObjectName {
    param (
        [Parameter(mandatory=$true)]
        [string]$filename,
        [boolean]$RemoveSuffix = $False
    )
    If ($RemoveSuffix){
        return $_.Name.Replace(".object","").Replace("__c","")
    } else {
        return $filename.Replace(".object","")
    }
}

function Trim-SalesforceCustomSuffix {
    param (
        [Parameter(mandatory=$true)]
        [string]$Name
    )
    return $Name.Replace("__c","")
}

function Print-DBDocsProject {
    param (
        [Parameter(mandatory=$true)]
        [Project]$Project
    )
    <#
        output the project in file format
        this piece of code is horrible don't @ me
        # Write-Host($proj.Tables | Select-Object *)
    #>

    # Create Project Definition
    $PrintVar = "Project `"" + $Project.Name + "`" {`n`tdatabase_type: '" + $Project.DatabaseType + "'`n`tnote:'''" + $Project.Description + "`t'''`n}`n`n"

    # Create Table Definition
    ForEach ($Table in $Project.Tables){
        $PrintVar += "Table " + $Table.Name + " {`n`t"
        ForEach($Field in $Table.Fields){
            $PrintVar += $Field.Name + " " + $Field.Type
            If($Field.Reference -OR $Field.Default -OR $Field.Description -OR $Field.Flags){
                $PrintVar += " ["
                If($Field.Reference){
                    $PrintVar += "ref:> " + $Field.Reference + ".id" + ", "
                }
                If($Field.Default){
                    $PrintVar += "default: `"" + $Field.Default + "`"" + ", "
                }
                If($Field.Description){
                    $PrintVar += "note: `"" + $Field.Description + "`"" + ", "
                }
                If($Field.Flags){
                    $PrintVar += "" + $Field.Flags + "" + ", "
                }
                While ( $PrintVar.Substring($PrintVar.Length -2) -eq ", ") {$PrintVar = $PrintVar.Substring(0,$PrintVar.Length -2) }
                $PrintVar += "]"
            }
            $PrintVar += "`n`t"
        }

        If($Table.Description){
            $PrintVar += "note: `""+ $Table.Description +"`"`n`t"
        }
        $PrintVar += "}`n`n"
    }

    # Create Enums Definition
    ForEach ($Enum in $Project.Enums){
        $PrintVar += "Enum " + $Enum.Name + " {`n`t"
        ForEach($Value in $Enum.PicklistValues){
            $PrintVar += '"' + $Value.Name +'"'
            $PrintVar += "`n`t"
        }
        $PrintVar += "}`n`n"
    }

    $outfilename = $Project.Name
    [System.IO.File]::WriteAllLines(".\Output\$outfilename.dbml", $PrintVar, $Utf8NoBomEncoding)


}