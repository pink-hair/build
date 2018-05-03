Param(
    [string]$fileName,
    [string]$token,
    [string]$replacementValue
)

$content = get-content $fileName;

$builder = new-object System.Text.StringBuilder;

foreach($line in $content)
{
    $newLine = $line.Replace($token, $replacementValue);
    [void]$builder.AppendLine($line);
}

$builder.ToString() | out-file $fileName -force;