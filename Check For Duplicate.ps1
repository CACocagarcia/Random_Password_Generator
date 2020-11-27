<#
    Created by: Carlos Coca
    Date: 11/02/2020
    Modified: 11/09/2020
#>


#-------------------------------------------------------------------------------------------------------------------------------------------------------
# Get all exisiting SamAccountName from AD ---- This is an Object[]
$currentUsernames = Get-ADUser -Filter * -SearchBase "ou=Aegis, dc=aegislabs1, dc=local" -SearchScope Subtree | Select SamAccountName

# Initializing Empty String to Append Current Users ---- It will turn into an array further down in the code
$cuArray = ""

# Iterate over $currentUsers and append to $cuArray
For ($i = 0 ; $i -le $currentUsernames.Length ; $i++){
    
    # Append to empty String each object element which is a hashtabel @{SamAccountName=Username}
    $cuArray = $cuArray + $currentUsernames[$i] 
}

# Redeclare the String Array to output as a single String
$cuArray = $cuArray | Out-String

# Partition the String to only have left the SamAccountName. The result will be an Object[]
$cuArray = $cuArray -split "@{SamAccountName="
$cuArray = $cuArray -split "}"
$cuArray = $cuArray.Split('',[System.StringSplitOptions]::RemoveEmptyEntries)

# Change data-type from Object[] to String[]
[string[]]$cuArray = $cuArray
#-------------------------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------------------------------

$mdxUsers = Get-ADUser -Filter * -SearchBase "OU=MDX,OU=Laboratory Operations,OU=Aegis,DC=Aegislabs1,DC=local" -SearchScope Subtree -Properties Surname, GivenName, DisplayName | Select Surname, GivenName, DisplayName | Export-Csv  -NoTypeInformation

$mdxCSVFile = Import-Csv -Path 

$surnameArray = @()
$GivenNameArray = @()
$DisplayNameArray = @()

ForEach ($mdxInformation in $mdxCSVFile){
    $Surname = $mdxInformation.Surname
    $GivenName = $mdxInformation.GivenName
    $DisplayName = $mdxInformation.DisplayName

    $surnameArray = $surnameArray + $Surname
    $GivenNameArray = $GivenNameArray + $GivenName
    $DisplayNameArray = $DisplayNameArray + $DisplayName
}

Remove-Item -Path 

$newMDXcsvFile = Import-Csv -Path 

ForEach($newInformation in $newMDXcsvFile){
    $newSamAccountName = $newInformation.SamAccountName
    $newSurname = $newInformation.Surname
    $newGivenName = $newInformation.GivenName

    $newDisplayName = "$newGivenName $newSurname"

    $x = 1

    While ($newSamAccountName -in $cuArray){
        
        $x += 1

        $NSANLength = $newSamAccountName.Length - 1
        $NSurLength = $newSurname.Length - 1

        if (($newSamAccountName[$NSANLength] -eq "1") -or ($newSamAccountName[$NSANLength] -eq "2") -or ($newSamAccountName[$NSANLength] -eq "3") -or ($newSamAccountName[$NSANLength] -eq "4") -or ($newSamAccountName[$NSANLength] -eq "5") -or ($newSamAccountName[$NSANLength] -eq "6") -or ($newSamAccountName[$NSANLength] -eq "7") -or ($newSamAccountName[$NSANLength] -eq "8") -or ($newSamAccountName[$NSANLength] -eq "9")){
            
            $newSamAccountName = $newSamAccountName.Remove($NSANLength)
            $newSamAccountName = $newSamAccountName + $x

            if ($newDisplayName -in $DisplayNameArray){
                
                $newSurname = $newSurname.Remove($newSurname.Length - 1)
                $newSurname = $newSurname + $x
                $newDisplayName = "$newGivenName $newSurname"
            }

        } else {
            $newSamAccountName = $newSamAccountName + $x

            if ($newDisplayName -in $DisplayNameArray){
                
                $newSurname = $newSurname + $x
                $newDisplayName = "$newGivenName $newSurname"
            }
        }    
    }

    $cuArray = $cuArray + $newSamAccountName
    $surnameArray = $surnameArray + $newSurname
    $GivenNameArray = $GivenNameArray + $newGivenName
    $DisplayNameArray = $DisplayNameArray + $newDisplayName

    echo "$newSamAccountName -- $newDisplayName"
} 

