<#
    A Utility script that handles the Project creation for the DBDocs integration
    Done by Geoffrey Bessereau, 2020-05-18
    Declare Object classes.
    Used to declare how DBML expects the data to be formatted.
#>

Class PicklistValue {
    [string]$Name
    PicklistValue(){ $this.Name = "Test"}
    PicklistValue(
        [string]$n
    ){
        $this.Name = $n
    }
}

Class Picklist {
    [String]$Name
    [PicklistValue[]]$PicklistValues
    Picklist(){}
    Picklist(
        [String]$n,
        [PicklistValue[]]$pvl
    ){
        $this.Name = $n
        $this.PicklistValues = $pvl
    }
}

Class Field {
    [String]$Name
    [String]$Type
    [String]$Reference
    [String]$Default
    [String]$Description
    [String]$Flags
    Field(){}
    Field(
        [String]$n,
        [String]$t,
        [String]$r,
        [String]$df,
        [String]$ds,
        [String]$fl
    ){
        $this.Name = $n
        $this.Type = $t
        $this.Reference = $r
        $this.Default = $df
        $this.Description = $ds
        $this.Flags = $fl
    }
}

Class Table {
    [String]$Name
    [Field[]]$Fields
    [String]$Description
    Table(){}
    Table(
        [String]$n
    ){
        $this.Name = $n
    }
}


Class Project {
    [String]$Name
    [String]$Description
    [String]$DatabaseType
    [Table[]]$Tables
    [Picklist[]]$Enums
    Project(){}
    Project(
        [String]$n,
        [String]$ds,
        [String]$db
    ){
        $this.Name = $n
        $this.Description = $ds
        $this.DatabaseType = $db
    }
}