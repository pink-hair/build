$branch = $env:BUILD_SOURCEBRANCHNAME;
$fullBranch = $env:BUILD_SOURCEBRANCH;
$releaseBranchName = $env:CI_RELEASEBRANCH;
$buildNumber = $env:BUILD_BUILDNUMBER;
Write-Warning "Branch $branch";
Write-Warning "FullBranch $fullBranch";
Write-Warning "releaseBranchName $releaseBranchName";
Write-Warning "buildNumber $buildNumber";

$tail = "";
if($fullBranch.StartsWith("refs/pull"))
{
    $prid = $env:SYSTEM_PULLREQUEST_PULLREQUESTID;
    $tail = "-pr$($prid.ToString())";
}
else
{
    if($branch.ToUpperInvariant() -eq $releaseBranchName.ToUpperInvariant())
    {
         $tail = "";
    }
    else
    {
        $compoundBranchName = [System.Text.RegularExpressions.Regex]::Replace($branch, "[^A-Za-z0-9]", "").ToLowerInvariant();

        Write-Warning "CompoundBranchName $compoundBranchName";
        [int]$take = 0;
        if($compoundBranchName.Length -gt 17)
        {
            $take = 17;
        }
        else
        {
            $take = $compoundBranchName.Length;
        }

        Write-Warning "Take $take";

        $subTail = $compoundBranchName.Substring(0, $take);

        Write-Warning "Subtail $subTail";
        $tail = "-ci$($subTail)";
    }
}

$build = "$($buildNumber)$($tail)";
Write-Warning "Build - $build";
Write-Host "##vso[task.setvariable variable=CI.NugetBuildNumber]$build";