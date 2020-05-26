<#
    A Utility script that handles the Project creation for the DBDocs integration
    Done by Geoffrey Bessereau, 2020-05-18
#>

# Declare paths and variables, import modules
$root = $PSScriptRoot
$configdir = "$root\Config"
$vars = Get-Content -Path $configdir\vars.json | ConvertFrom-Json
[String]$notes = Get-Content -Path $vars.'project-description-path' -Raw
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False

# Import Modules
Import-Module .\Utils\DBDocs-Classes.ps1
Import-Module .\Utils\DBDocs-ClassFunctions.ps1
Import-Module .\Utils\DBDocs-UtilityFunctions.ps1
Import-Module .\Utils\Utils-SFDX.ps1


# Main Function
If( -NOT ".\sfdx\manifest\package.xml"){
    Write-Host "You need a package.xml in .\sfdx\manifest to use this tool." -BackgroundColor Red
    Write-Host "Use https://packagebuilder.herokuapp.com if you are unsure how to proceed." -BackgroundColor Red
    Write-Host "This tool will now exit." -BackgroundColor Red
} Else {
    If($vars.'sfdx-pull' -eq "true"){
        try{
            GET-SFDX-DATA -OrgAlias $vars.'sfdx-alias'
        } catch {
            Write-Host "You need SFDX-CLI installed - you can do so via https://developer.salesforce.com/tools/sfdxcli." -BackgroundColor Red
            Write-Host "You also need to run force:auth:web:login -a youralias." -BackgroundColor Red
            Write-Host "Refer to the documentation if needed https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_force_auth.htm#cli_reference_force_auth." -BackgroundColor Red
            exit 0
        }
    }
    $proj = Create-Project -dbdocsname $vars."project-name" -dbdocsnotes $notes -dbdocsdbtype $vars."project-database" -path $vars."path"
    Print-DBDocsProject($proj)
}