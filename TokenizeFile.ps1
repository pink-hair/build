Param(
    [string]$fileName,
    [string]$token,
    [string]$replacementValue
)

$content = get-content $fileName;

$builder = new-object System.Text.StringBuilder;

for($i = 0; $i -lt $content.Length; $i++)
{
    $line = $content[$i];
    $index = $line.IndexOf($token);
    if($index -ne  -1)
    {
        Write-Warning("Token '$token' Found at line $i at character $index");
    }    

    $newLine = $line.Replace($token, $replacementValue);
    [void]$builder.AppendLine($line);
}

$builder.ToString() | out-file $fileName -force;