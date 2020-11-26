Function RandomPassword{
    # Strings to be used to generate the random password

    $UpperCase = "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"
    $LowerCase = "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"
    $aCharacter = "!","@","#","$","&","*"
    $aNumber = "1","2","3","4","5","6","7","8","9","0"

    # Random how many of each
    $randLetter = Get-Random -Minimum 10 -Maximum 26
    $randCharacter = Get-Random -Minimum 1 -Maximum 6
    $randNumber = Get-Random -Minimum 1 -Maximum 10
    $randPass = Get-Random -Min 16 -Maximum 22

    # Random Choose of each
    $UpperString = Get-Random -Count $randLetter -InputObject $UpperCase
    $LowerString = Get-Random -Count $randLetter -InputObject $LowerCase
    $CharacterString = Get-Random -Count $randCharacter -InputObject $aCharacter
    $NumberString = Get-Random -Count $randNumber -InputObject $aNumber

    # Random Password Generator
    $RandPassword = Get-Random -Count $randPass -InputObject ($UpperString+$CharacterString+$LowerString+$NumberString)
    $RawPass = $RandPassword -join("")

    $secPw = ConvertTo-SecureString -String $RawPass -AsPlainText -Force

    $marshal = [Runtime.InteropServices.Marshal]
    $var2 = $marshal::PtrToStringAuto($marshal::SecureStringToBSTR($secPw))

    return $var2

    #echo $randPass
    #echo $RawPass
    #echo $secPw
}

RandomPassword
