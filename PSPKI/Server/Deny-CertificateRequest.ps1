function Deny-CertificateRequest {
<#
.ExternalHelp PSPKI.Help.xml
#>
[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[ValidateScript({
			if ($_.GetType().FullName -eq "PKI.CertificateServices.DB.RequestRow") {$true} else {$false}
		})]$Request
	)
	process {
		$CertAdmin = New-Object -ComObject CertificateAuthority.Admin
		try {
			$hresult = $CertAdmin.DenyRequest($Request.ConfigString,$Request.RequestID)
			if ($hresult -eq 0) {
				Write-Host "Successfully denied request with ID = $($Request.RequestID)"
			} else {
				Write-Warning "The request's with ID = $($Request.RequestID) current status does not allow this operation."
			}
		} finally {[void][Runtime.InteropServices.Marshal]::ReleaseComObject($CertAdmin)}
	}
}