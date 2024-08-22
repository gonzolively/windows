# Add required assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Form logic
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Totally Working (v0.6.0)'
$form.Size = New-Object System.Drawing.Size(400,400)
$form.StartPosition = 'CenterScreen'

# Minutes label
$minutesLabel = New-Object System.Windows.Forms.Label
$minutesLabel.Location = New-Object System.Drawing.Point(10,20)
$minutesLabel.Size = New-Object System.Drawing.Size(380,20)
$minutesLabel.Text = 'How many minutes would you like to keep the computer active?'
$form.Controls.Add($minutesLabel)

# Minutes box
$minutesBox = New-Object System.Windows.Forms.TextBox
$minutesBox.Location = New-Object System.Drawing.Point(10,50)
$minutesBox.Size = New-Object System.Drawing.Size(100,20)
$form.Controls.Add($minutesBox)

# Action label
$actionLabel = New-Object System.Windows.Forms.Label
$actionLabel.Location = New-Object System.Drawing.Point(10,80)
$actionLabel.Size = New-Object System.Drawing.Size(380,20)
$actionLabel.Text = 'After the active time ends, your computer will:'
$form.Controls.Add($actionLabel)

# Action dropdown
$actionDropDown = New-Object System.Windows.Forms.ComboBox
$actionDropDown.Location = New-Object System.Drawing.Point(10,110)
$actionDropDown.Size = New-Object System.Drawing.Size(200,20)
$actionDropDown.Items.AddRange(@('Do nothing', 'Hibernate', 'Sleep', 'Lock', 'Power off'))
$form.Controls.Add($actionDropDown)

# Output window
$outputBox = New-Object System.Windows.Forms.TextBox
$outputBox.Location = New-Object System.Drawing.Point(10,150)
$outputBox.Size = New-Object System.Drawing.Size(360,160)
$outputBox.Multiline = $true
$outputBox.ScrollBars = 'Vertical'
$outputBox.ReadOnly = $true
$form.Controls.Add($outputBox)

# Run button
$runButton = New-Object System.Windows.Forms.Button
$runButton.Location = New-Object System.Drawing.Point(10,330)
$runButton.Size = New-Object System.Drawing.Size(75,23)
$runButton.Text = 'Run'

# Run button action
$runButton.Add_Click({
    $minutes = $minutesBox.Text
    $action = $actionDropDown.SelectedItem
    $outputBox.Clear()

    $time = Get-Date
    $newtime = ($time.AddMinutes($minutes))
    $newtimetostring = $newtime.ToString("HH:mm:ss")

    $outputBox.AppendText("Current time is $($time.ToString('HH:mm:ss'))`r`n")
    $outputBox.AppendText("Computer will stay active until $newtimetostring`r`n")
    
    if ($action -ne 'Do nothing') {
        $outputBox.AppendText("and then $action.`r`n")
    }

    $outputBox.AppendText("`r`nKeeping computer active...`r`n")
    $form.Refresh()

    $wshShell = New-Object -ComObject Wscript.Shell
    for ($i = 0; $i -lt [int]$minutes; $i++) {
        Start-Sleep -Seconds 60
        $wshShell.SendKeys("{SCROLLLOCK}")
        $outputBox.AppendText(".")
        $form.Refresh()
    }

    $outputBox.AppendText("`r`nFinished keeping computer active.`r`n")

    switch ($action) {
        'Lock' { 
            $outputBox.AppendText("Locking workstation...`r`n")
            $signature = @"
            [DllImport("user32.dll", SetLastError = true)]
            public static extern bool LockWorkStation();
"@
            $LockWorkStation = Add-Type -memberDefinition $signature -name "Win32LockWorkStation" -namespace Win32Functions -passthru
            $LockWorkStation::LockWorkStation() | Out-Null
        }
        'Sleep' {
            $outputBox.AppendText("Putting computer to sleep...`r`n")
            powercfg.exe /hibernate off | Out-Null
            &"$env:SystemRoot\System32\rundll32.exe" powrprof.dll,SetSuspendState Standby
        }
        'Power off' {
            $outputBox.AppendText("Powering off computer...`r`n")
            powercfg.exe /hibernate off | Out-Null
            Stop-Computer -Force
        }
        'Hibernate' {
            $outputBox.AppendText("Hibernating computer...`r`n")
            powercfg.exe /hibernate on | Out-Null
            &"$env:SystemRoot\System32\rundll32.exe" powrprof.dll,SetSuspendState Hibernate
        }
    }

    $outputBox.AppendText("Script completed successfully.`r`n")
})

# Extra form control options
$form.Controls.Add($runButton)
$form.Topmost = $true
$form.ShowDialog()