# Import necessary modules
Import-Module -Name ActiveDirectory

# Define a function to find "Generic All" users
function Find-GenericAllUsers {
    try {
        # Use the Get-ADUser cmdlet to get a list of all users
        $users = Get-ADUser -Filter *
        # Filter the list of users to get only those that have the "Generic All" permission
        $generic_all_users = $users | Where-Object {
            $permissions = Get-ADPermission -Identity $_.DistinguishedName
            $permissions | Where-Object {
                ($_.User -eq "NT AUTHORITY\SELF") -and
                ($_.ExtendedRights -eq "All Extended Rights")
            }
        }
        # Return the list of "Generic All" users
        return $generic_all_users
    }
    catch {
        # If an error occurs, print the error message and exit the script
        Write-Error $_
        exit 1
    }
}

# Main function
function Main {
    # Find "Generic All" users
    $generic_all_users = Find-GenericAllUsers
    # Print the results
    if ($generic_all_users) {
        $generic_all_users | ForEach-Object {
            Write-Output "Found 'Generic All' user: $($_.SamAccountName)"
        }
    }
    else {
        Write-Output "No 'Generic All' users were found."
    }
}

# Call the main function
Main
