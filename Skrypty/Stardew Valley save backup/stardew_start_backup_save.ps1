# .Net methods for hiding/showing the console in the background
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
function Hide-Console
{
    $consolePtr = [Console.Window]::GetConsoleWindow()
    #0 hide
    [Console.Window]::ShowWindow($consolePtr, 0)
}
Hide-Console


$p = Get-ChildItem C:\Users\KaeM\AppData\Roaming\StardewValley\Saves\Pieszczoszka_210107802\Pieszczoszka_210107802 
$wrt = $p.LastWriteTime

$sw = 1

& 'C:\GOG Games\Stardew Valley\Stardew Valley.exe'

function make_backup {
    Copy-Item C:\Users\KaeM\AppData\Roaming\StardewValley\Saves\Pieszczoszka_210107802* C:\Users\KaeM\AppData\Roaming\StardewValley\Saves\Backups -Recurse -force #lokalizacja save gry
    [string]$data = get-date -format yyyy-MM-dd_HH-mm-ss
    Compress-Archive -Path C:\Users\KaeM\AppData\Roaming\StardewValley\Saves\Backups\Pieszczoszka_210107802 -CompressionLevel Optimal -DestinationPath C:\Users\KaeM\AppData\Roaming\StardewValley\Saves\Backups\"backup_"$data.zip -force #lokalizacja kopii save i docelowa archiwum
    Remove-Item C:\Users\KaeM\AppData\Roaming\StardewValley\Saves\Backups\Pieszczoszka_210107802* -Recurse -force
    "backuped with name: backup_$data.zip"
}

function old_save_delete {

    $list = Get-ChildItem C:\Users\KaeM\AppData\Roaming\StardewValley\Saves\Backups -recurse -include *.zip, *backup*
    $size_list = ($list).count
        if($size_list -gt 10){
             for($i = 0; $i -lt $size_list-28; $i+=1){
                Remove-Item $list[$i]
            }
    }
}

while($sw){

    $p = Get-ChildItem C:\Users\KaeM\AppData\Roaming\StardewValley\Saves\Pieszczoszka_210107802\Pieszczoszka_210107802   #plik save zdefiniować 
    if (!($wrt -eq $p.LastWriteTime)) {make_backup}
    #old_save_delete
    [string]$sw = Get-Process | select-string -pattern "Stardew Valley" #proces ggry wpisać
    if(!$sw){"script terminated, game process ended";break}
    $wrt = $p.LastWriteTime
    sleep -Seconds 2 #czas pauzy miedzy sprawdzeniami

}
