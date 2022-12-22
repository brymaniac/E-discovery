$UserCredential = Get-Credential
$c.Username
$c.Password
Connect-ExchangeOnline -UserPrincipalName $c.Username
Connect-IPPSSession -UserPrincipalName $c.Username
Add-Type -assembly System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationFramework
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ="Compliance Search"
$main_form.Width = 600
$main_form.Height = 400
$main_form.AutoSize = $true
$LabelCase = New-Object System.Windows.Forms.Label
$LabelCase.AutoSize = $true
$LabelCase.Location = New-Object System.Drawing.Size(50,77)
$LabelCase.Text = "Case Name"
$LabelCase.font = "Microsoft Sans Serif,10"
$main_form.Controls.Add($LabelCase)
$TextBoxCase = New-Object System.Windows.Forms.TextBox
$TextBoxCase.Location = New-Object System.Drawing.Size(130,77)
$TextBoxCase.width = 200
$TextBoxCase.height = 200
$main_form.Controls.Add($TextBoxCase)
$TextBoxParameters = New-Object System.Windows.Forms.TextBox
$TextBoxParameters.Location = New-Object System.Drawing.Size(130,117)
$TextBoxParameters.width = 200
$TextBoxParameters.height = 200
$TextBoxParameters.Multiline = $true
$main_form.Controls.Add($TextBoxParameters)
$LabelQuery = New-Object System.Windows.Forms.Label
$LabelQuery.AutoSize = $true
$LabelQuery.Location = New-Object System.Drawing.Size(17,117)
$LabelQuery.Text = "Quey Parameters"
$LabelQuery.font = "Microsoft Sans Serif,10"
$main_form.Controls.Add($LabelQuery)
$LabelLocation = New-Object System.Windows.Forms.Label
$LabelLocation.AutoSize = $true
$LabelLocation.Location = New-Object System.Drawing.Size(5,97)
$LabelLocation.Text = "Exchange Location"
$LabelLocation.font = "Microsoft Sans Serif,10"
$main_form.Controls.Add($LabelLocation)
$TextBoxLocation = New-Object System.Windows.Forms.TextBox
$TextBoxLocation.Location = New-Object System.Drawing.Size(130,97)
$TextBoxLocation.width = 200
$TextBoxLocation.height = 200
$main_form.Controls.Add($TextBoxLocation)
$Button = New-Object System.Windows.Forms.Button
$Button.Location = New-Object System.Drawing.Size(400,75)
$Button.Size = New-Object System.Drawing.Size(120,23)
$Button.Text = "Run E-Discovery"
$main_form.Controls.Add($Button)
$Button.Add_Click(
    {
        $x = $textBoxCase.text
        $y = $TextBoxLocation.text
        $z = $TextBoxParameters.text
        Start-Transcript -Path C:\Temp\Content.log -Append
        $msgBoxInput = [System.Windows.MessageBox]::Show( "Do you want to proceed with a Compliance Search?", " Removal Confirmation", "YesNoCancel", "Warning" )
        switch  ($msgBoxInput) 
            {
                'Yes' 
                    {
                    $msgBoxInput = [System.Windows.MessageBox]::Show( "Is the Mailbox Inactive?", " Removal Confirmation", "YesNoCancel", "Warning" )
                    switch  ($msgBoxInput) 
                        {
                        'Yes'
                            {
                                New-ComplianceCase -Name "$x"
                                New-ComplianceSearch -Case "$x" -Name "$x" -ExchangeLocation "$y" -ContentMatchQuery "'$z'" -AllowNotFoundExchangeLocationsEnabled $true
                                [System.Windows.MessageBox]::Show( "Compliance Search: $x has been created with the following parameters: '$z' and consists of the following mailboxes: $y")
                                Write-Host "Compliance Search: $x has been created with the following parameters: '$z' and consists of the following mailboxes: $y " -ForegroundColor Green
                            }
                        'No' 
                            {
                                New-ComplianceSearch -Name "$x" -ExchangeLocation "$y" -ContentMatchQuery "'$z'" -AllowNotFoundExchangeLocationsEnabled $false
                                [System.Windows.MessageBox]::Show( "Compliance Search $x has been created with the following parameters: '$z' and consists of the following mailboxes: $y")
                                Write-Host "Compliance Search $x has been created with the following parameters: '$z' and consists of the following mailboxes: $y" -ForegroundColor Green
                                Stop-Transcript 
                                $main_form.Close()
                        }
                        }
                'No'
                        {
                        "Command Failed"
                        Stop-Transcript
                        $main_form.Close()
                        }
                    }
    }
}
                )
$main_form.ShowDialog()