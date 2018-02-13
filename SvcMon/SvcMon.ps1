#
# test web service availability
# set service url to test in service.xml file 
#

# Set-ExecutionPolicy -ExecutionPolicy Unrestricted

Function ConnectUrl([string]$url, [string]$user, [string]$passwd, [string]$domain)
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
		If($cert)
		{
			
		}
		Else
		{
		}
	
	try
	{
		$response = [Net.HttpWebResponse]$request.GetResponse()
		$request.Abort()
		return "Ok"
		
	}
	catch [Exception]
	{
		 echo $_.Exception.GetType().FullName, $_.Exception.Message
		return "Fail"
	}
}

try
{
	[xml]$serviceDefinition = Get-Content service.xml
	foreach($item in $serviceDefinition.webService.spec)
	{
		Write-Host "testing " $item.name $item.url;		
		$responseResult = ConnectUrl $item.url $item.user $item.password $item.domain;
		Write-Host $responseResult #-url $item.url -user $item.user -passwd $item.password -domain $item.domain
	}
}
catch [Exception]
{
	 echo $_.Exception.GetType().FullName, $_.Exception.Message
	Write-Host "Error"
}

