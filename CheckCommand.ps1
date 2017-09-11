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