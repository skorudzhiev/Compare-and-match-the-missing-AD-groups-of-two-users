### Compare the AD Groups

Function Compare-ADGroup {

Param ($testUser, $targetUser)

$result = @()

$a = (Get-ADUser $testUser -Properties memberof).memberof | sort

$b = (Get-ADUser $targetUser -Properties memberof).memberof | sort
 

$filter = ($a | %{ "^" + $_ + "$"}) -join "|"

$b | %{

$obj = new-object System.Object

$obj | Add-Member -type NoteProperty -name GroupCN -Value $_

if ($_ -match $filter) {

$obj | Add-Member -type NoteProperty -name IsMember -Value "True"}

else{$obj | Add-Member -type NoteProperty -name IsMember -Value "False"}

$result += $obj

}

return $result

}

### Add the missing groups from the refferent user

Compare-ADGroup -testUser testuserf -targetUser xkostoale |?{$_.IsMember -eq "false"} | %{Add-ADGroupMember $_.GroupCN -Members }
