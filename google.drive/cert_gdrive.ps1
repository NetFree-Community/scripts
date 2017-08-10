

echo "Download Cert ... "
$cert = (New-Object Net.WebClient).DownloadString("http://netfree.link/netfree-ca.crt")


if($cert.indexOf("BEGIN CERTIFICATE") -eq -1){
    echo "invalid cert !"
	exit
}

$cafile = [Environment]::GetFolderPath('LocalApplicationData') + "\Google\Drive\user_default\cacerts"

if(-Not (Test-Path $cafile)){
    echo "ca file doesn't exist! `nstart google sync"
	exit
}

$cacerts = [IO.File]::ReadAllText($cafile)

if( $cacerts.indexOf($cert) -eq -1){
	$attReadOnly = [System.IO.FileAttributes]::ReadOnly
	
	$prop = Get-ItemProperty -Path $cafile
  
	if(($prop.Attributes -band $attReadOnly) -eq $attReadOnly){
		$prop.Attributes = $prop.Attributes -bxor $attReadOnly
	}
	
	$cert = "`n`n#NetFree Cert`n" + $cert
	
	Add-Content $cafile $cert
	# set ReadOnly
	$prop.Attributes = $prop.Attributes -bor $attReadOnly
	
	echo "done install !!!"
}else{
	echo "Early installed"
}

Read-Host "Press any key to exit..."
