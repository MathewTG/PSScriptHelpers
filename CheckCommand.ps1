<#
.SYNOPSIS

Retrieves the Parameter Sets associated with a command. And also check for Parameters.

.DESCRIPTION

Retrieves the Parameter Sets associated with a command.
Optionally list all parameters in a particular Parameter Set.
Optionally list the parameter sets in which a particualr parameter occurs.


.PARAMETER command

The command for which the parameter sets needs to be displayed and check for parameters.

.PARAMETER parameter

The name of the parameter which will be searched for, inside all the parameter sets.

.PARAMETER parameter_set

The name of the parameter set whose list of parameters will be displayed.

.EXAMPLE

Display all the Parameter Sets of the command 'Get-Process'

Command-Help -command "Get-Process"

.EXAMPLE 

Display all the Parameter Sets of the command 'Get-Process'. And check for the parameter named "Name" in all parameter sets

Command-Help -command "Get-Process" -parameter "Name"

.EXAMPLE 

Display all the Parameter Sets of the command 'Get-Process'. And list all the parameters inside the parameter set "InputObject"

Command-Help -command "Get-Process" -parameter_set "InputObject"

.NOTES

Helps to find out details about a particular cmdlet
#>
Function Command-Help
{
    [CmdletBinding()]
    param 
    (
        [Parameter (Mandatory = $true,
                    ValueFromPipeline = $false,
                    HelpMessage = "Command to Check")]
        [System.String]
        $command,

        [Parameter (Mandatory = $false,
                    ValueFromPipeline = $true,
                    HelpMessage = "Parameter to check")]
        [System.String]
        $parameter,

        [Parameter (Mandatory = $false,
                    ValueFromPipeline = $false,
                    HelpMessage = "Parameter set whose parameters are to be listed")]
        [System.String]
        $parameter_set
    )
    Write-Host ("`nInput Command :  {0}`n" -f $command)

    # Retrive the command object to be checked
    $command_obj = Get-Command -Name $command
    Write-Host ("Parameter Sets:{0}" -f ($command_obj.ParameterSets | ft | Out-String))

    # Enumerate the Parameter Sets of the command
    $param_set = $command_obj.ParameterSets

    # Flag
    $found = $false

    # If the user wants to check for a parameter inside all parameter sets
    if ($PSBoundParameters.ContainsKey('parameter'))
    {
        Write-Host ("Checking for parameter '{0}'" -f $parameter)

        # Array to store the selected Parameter Sets
        $sel_param_set = @()       
        
        # Iterating through each Parameter set
        foreach ($set in $param_set)
        {
            # Iterating through each parameter
            foreach ($param in $set.Parameters)
            {
                # If the given parameter name matches any of the parameters in the Parameter Set
                if ($parameter -eq $param.Name)
                {
                    $sel_param_set += $set
                    $found = $true
                }
            }
        }
        if ($found -eq $false)
        {
            Write-Error ("`nParameter '{0}' was not found inside any of the parameter sets of '{1}'" -f $parameter, $command) -ErrorAction Continue
        }
        else
        {
            # Display the Parameter Sets under which the input parameter was found
            Write-Host ("`nParameter '{0}' was found inside the following parameter sets`n {1}" -f $parameter, ($sel_param_set | ft | Out-String)) -ForegroundColor Green
            $found = $false
        }
    }

    # If the user wants to list all the Parameters in a particular parameter set
    if ($PSBoundParameters.ContainsKey('parameter_set'))
    {
        # Iterating through each set
        foreach ($set in $param_set)
        {
            if ($parameter_set -eq $set.Name)
            {
                $found = $true
                Write-Host ("`nParameter Set '{0}' was found inside the command '{1}'." -f $parameter_set,$command) -ForegroundColor Green

                # Display the list of Parameters
                Write-Host ("`nList of Parameters:{0}" -f ($set.Parameters | Select "Name","IsMandatory","ParameterType" | ft | Out-String))
            }
        }

        if ($found -eq $false)
        {
            Write-Error ("`nParameter Set '{0}' was not found inside the command '{1}'." -f $parameter_set,$command)
        }
        else
        {
            # Just in case
            $found = $false
        }
    }
}
# SIG # Begin signature block
# MIIFbQYJKoZIhvcNAQcCoIIFXjCCBVoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU9MQvCFGLYILjmZOMq0dYHkjl
# Rk2gggMIMIIDBDCCAeygAwIBAgIQWvil9pYnBqpGPyKzyTVJYjANBgkqhkiG9w0B
# AQsFADAaMRgwFgYDVQQDDA9Qb3dlclNoZWxsIFVzZXIwHhcNMTgxMjA1MTQwNzEw
# WhcNMTkxMjA1MTQyNzEwWjAaMRgwFgYDVQQDDA9Qb3dlclNoZWxsIFVzZXIwggEi
# MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDk5J4JokxGLh3cFdGDud7qd4lx
# O5B9R8o71Khof6VoZUjB/5HW0RQ66a2rXCfk+6efLgX5GgafZXe3zqRTdgmBrjD0
# bAokEeJ6XLW+Bt72bhFiMnlVDXit69NHiP7q29v/h4iakMLH+IvQJGRZ0ErvyVWi
# WuvAZWr0YK4qS+GY2wqlUoXR0GB6GuRbSp3X046d2WAAZedeCQgBA3beRv4NggvT
# errgGTZeT7OpCV/4V7RqsosNrvuB4oissSoGyUcPL122lU45OECkYwC+q+bTA77z
# vgoBLr51n1PKJwP/kKavwZvDpniHxFNys2OZymt01Wkgbg6yivEoSjNx557lAgMB
# AAGjRjBEMA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAKBggrBgEFBQcDAzAdBgNV
# HQ4EFgQUee2xmTN3hblKPKm8UiwRJ+QcDEwwDQYJKoZIhvcNAQELBQADggEBAAWI
# o12NRKuEt2j55Nj9x+4gTgvbEPkaeVPuwcPecB6iOcrk8HKuy8LznPH9oPwRzSoD
# Ief05QADGsHha5kz9JWwbY0Rp5pdZsXb+rdj3JfieqJN/7SfbhvOU42uXioedtqV
# aLJziFF6u3yHi38ps6ZwtlDmJ9Jf6U34MxM+VMkn+hnMVwA0kK+42thEA/p4m9pA
# oa5XX1Lk4Usrb/KEXPtoAkCOJkkquwIIyltmMaZ6dh42l8UT0BokUkgIEg9A9OK5
# tyBSAz4Rq+8Vy6vgWW+9BiBkbqCQKSkyGlsMHdycUKLH7Q8sfA8UYG7P6TeyCPJG
# 3zSQEO3X0tHWGQPS5D0xggHPMIIBywIBATAuMBoxGDAWBgNVBAMMD1Bvd2VyU2hl
# bGwgVXNlcgIQWvil9pYnBqpGPyKzyTVJYjAJBgUrDgMCGgUAoHgwGAYKKwYBBAGC
# NwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUdjCc7Clt
# dkrFLjzTKDQ04jvU9ycwDQYJKoZIhvcNAQEBBQAEggEAX9Uv0AmitCTm34/KcB+D
# sm0vFW5ET+1vxdHDok/hRsRFUJ/iPTCUQ9qJeL9242x4X0FB88igRUe8TC+HXU1O
# BuIk4D3AoL598L+rBunaX4KsP3jqwfEZWUwFIkncMDd7nDkAVrP98VUiOSFaUOeu
# 3fIYeXhKUO2+xPZ0HuFGZg6v7XqqwpMJjkGu1Av5wEZ3a1ynm7YKaEzSJEHqVYRX
# c74RBskKMhZ7XmYoo4kpae5x/zoWw5F9UYlEJZWAf95lzr7MmVI0kvtpIgvAyfds
# 3SApxkafXpEvaTUtcEThdcNBMooZSs7Q3IC96BiH+0tB1mQve50qkBDdF3LDiWHa
# Cw==
# SIG # End signature block
