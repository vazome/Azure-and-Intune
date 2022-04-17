$ExitCode = 0
$ProfilePath = "C:\ProgramData\Cisco\Cisco AnyConnect Secure Mobility Client\Profile\Profile.xml"

#In this case we are checking whether script is invoked under local non domain user, if so we can get domain user value from registry
if ([System.Security.Principal.WindowsIdentity]::GetCurrent().Name -notlike "DOMAIN\*" ) {
    $registry = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Enrollments"

    $findUPN = foreach ($a in $registry) {
    $a.Property | Select-Object @{name="Value";expression={$_}}, @{name="Data";expression={$a.GetValue($_)}}}

    $ADUser = $findUPN | Where-Object {$_.Value -eq "UPN" -and $_.Data -like "*@*domain.com*"} | Select-Object -ExpandProperty Data
    $ADUser = $ADUser -replace "@.+", "" #for simple searches it's common to use .Replace("@foo.bar.bruh", "")

    $ADUser
    echo "Local user, AD join"

}
else {
	#else, our user is domain user, meaning it we can get username as is
    $ADUser = [Environment]::UserName
    $ADUser
    echo "AD user, AD join"
}

$ServerName = "foo.bar.com"
$GroupName = "AUTH-NOTIFICATION"
$ProfileName = "ORG VPN"

$DefaultTemp = '<?xml version="1.0" encoding="UTF-8"?>
<AnyConnectProfile xmlns="http://schemas.xmlsoap.org/encoding/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://schemas.xmlsoap.org/encoding/ AnyConnectProfile.xsd">
	<ClientInitialization>
		<UseStartBeforeLogon UserControllable="true">false</UseStartBeforeLogon>
		<AutomaticCertSelection UserControllable="true">false</AutomaticCertSelection>
		<ShowPreConnectMessage>false</ShowPreConnectMessage>
		<CertificateStore>All</CertificateStore>
		<CertificateStoreOverride>false</CertificateStoreOverride>
		<ProxySettings>Native</ProxySettings>
		<AllowLocalProxyConnections>true</AllowLocalProxyConnections>
		<AuthenticationTimeout>12</AuthenticationTimeout>
		<AutoConnectOnStart UserControllable="true">false</AutoConnectOnStart>
		<MinimizeOnConnect UserControllable="true">true</MinimizeOnConnect>
		<LocalLanAccess UserControllable="true">false</LocalLanAccess>
		<ClearSmartcardPin UserControllable="true">true</ClearSmartcardPin>
		<IPProtocolSupport>IPv4,IPv6</IPProtocolSupport>
		<AutoReconnect UserControllable="false">true
			<AutoReconnectBehavior UserControllable="false">DisconnectOnSuspend</AutoReconnectBehavior>
		</AutoReconnect>
		<AutoUpdate UserControllable="false">true</AutoUpdate>
		<RSASecurIDIntegration UserControllable="false">Automatic</RSASecurIDIntegration>
		<WindowsLogonEnforcement>SingleLocalLogon</WindowsLogonEnforcement>
		<WindowsVPNEstablishment>LocalUsersOnly</WindowsVPNEstablishment>
		<AutomaticVPNPolicy>false</AutomaticVPNPolicy>
		<PPPExclusion UserControllable="false">Disable
			<PPPExclusionServerIP UserControllable="false"></PPPExclusionServerIP>
		</PPPExclusion>
		<EnableScripting UserControllable="false">false</EnableScripting>
		<EnableAutomaticServerSelection UserControllable="false">false
			<AutoServerSelectionImprovement>20</AutoServerSelectionImprovement>
			<AutoServerSelectionSuspendTime>4</AutoServerSelectionSuspendTime>
		</EnableAutomaticServerSelection>
		<RetainVpnOnLogoff>false
		</RetainVpnOnLogoff>
	</ClientInitialization>
	'
$CustomTemplate = "<ServerList>
		<HostEntry>
			<HostName>$ProfileName</HostName>
			<HostAddress>$ServerName</HostAddress>
		</HostEntry>
	</ServerList>
</AnyConnectProfile>"

$Template = $DefaultTemp + $CustomTemplate

$Preferences = '<?xml version="1.0" encoding="UTF-8"?>
' + "<AnyConnectPreferences>
<DefaultUser>$ADUser</DefaultUser>
<DefaultSecondUser></DefaultSecondUser>
<ClientCertificateThumbprint></ClientCertificateThumbprint>
<MultipleClientCertificateThumbprints></MultipleClientCertificateThumbprints>
<ServerCertificateThumbprint></ServerCertificateThumbprint>
<DefaultHostName>$ProfileName</DefaultHostName>
<DefaultHostAddress>$ServerName</DefaultHostAddress>
<DefaultGroup>$GroupName</DefaultGroup>
<ProxyHost></ProxyHost>
<ProxyPort></ProxyPort>
<SDITokenType>none</SDITokenType>
<ControllablePreferences></ControllablePreferences>
</AnyConnectPreferences>"

New-Item -ItemType Directory -Force -Path "$env:LOCALAPPDATA\Cisco\Cisco AnyConnect Secure Mobility Client"
Set-Content -Path "$env:LOCALAPPDATA\Cisco\Cisco AnyConnect Secure Mobility Client\preferences.xml" -Value $Preferences
#What is '$?':it means if last command is true then ...
Set-Content -Path $ProfilePath -Value $Template -Force -ErrorVariable ErrorTemplate -ErrorAction SilentlyContinue
if ($?) {
	Write-Output -Verbose "Done"
}
else
{
    # start logging to TEMP in file "scriptname".log
    Start-Transcript -Path "$env:TEMP\$($(Split-Path $PSCommandPath -Leaf).ToLower().Replace(".ps1",".log"))" | Out-Null

	Set-Content -Path $ProfilePath -Value $Template -Force -ErrorVariable ErrorTemplate -ErrorAction SilentlyContinue
	if ($ErrorTemplate) {
		#Informing intune with actual status
		Write-Error -Message "Couldn't create VPN profile" -Category OperationStopped
		$ExitCode = 2
		}
    Stop-Transcript | Out-Null
}
echo "Script deployed" | Set-Content -Path "C:\Users\Public\Documents\ScriptWorked.txt" -Force
exit $ExitCode
