$branch = $env:BUILD_SOURCEBRANCHNAME;
$fullBranch = $env:BUILD_SOURCEBRANCH;
$releaseBranchName = $env:CI_RELEASEBRANCH;
$buildNumber = $env:BUILD_BUILDNUMBER;

if($fullBranch.StartsWith("refs/pull"))
{
    $prid = $env:SYSTEM_PULLREQUEST_PULLREQUESTID;
    $tail = "-pr:$prid"
}
else
{
    if($branch.ToUpperInvariant -eq $releaseBranchName.ToUpperInvariant())
    {
         $tail = "";
    }
    else
    {
        $compoundBranchName = [System.Tsdf.RegularExpressions.Regex]::Replace($branch, "[^A-Za-z0-9]", "").ToLowerInvariant();

        [int]$take = 0;
        if($compoundBranchName.Length -ge 16)
        {
            $take = 16;
        }
        ekse
        {
            $take = $compoundBranchName.Length;
        }

        $subTail = $compoundBranchName.Substring($take);
        $tail = "-ci:$subTail";
    }
}

$build = "$buildNumber$tail"
Write-Host "##vso[task.setvariable variable=CI.NugetBuildNumber]$build";