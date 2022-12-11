#Run as current user
#Enables dark mode system wide
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize\ -Name SystemUsesLightTheme -Value 0 -Force
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize\ -Name AppsUseLightTheme -Value 0 -Force
