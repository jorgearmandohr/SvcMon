#
# test web service availability
# set service url to test in service.xml file 
#

# Set-ExecutionPolicy -ExecutionPolicy Unrestricted

try
{
	[xml]$serviceDefinition = Get-Content service.xml
	foreach($item in $serviceDefinition.webService.spec)
	{
		Write-Host "testing " $item.name $item.url;
		ConnectUrl $item.url $item.user $item.password $item.domain #-url $item.url -user $item.user -passwd $item.password -domain $item.domain
	}
}
catch
{
	Write-Host "error"
}

Function ConnectUrl($url, $user, $passwd, $domain)
{
	$request = [Net.HttpWebRequest]::Create($url)
		If($user)
		{
			$request.Credentials = new-object System.Net.NetworkCredential($user, $passwd, $domain)
		}
		Else
		{
			$request.Credentials = [System.Net.CredentialCache]::DefaultCredentials
		}
	try
	{
		$response = [Net.HttpWebResponse]$request.GetResponse()
		Write-Host "Ok"
		$request.Abort()
	}
	catch
	{
		Write-Host "Fail"
	}
}
