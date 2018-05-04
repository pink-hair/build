$branch = $env:BUILD_SOURCEBRANCHNAME;
$fullBranch = $env:BUILD_SOURCEBRANCH;
$releaseBranchName = $env:CI_RELEASEBRANCH;
$buildNumber = $env:BUILD_BUILDNUMBER;
Write-Warning "Branch $branch";
Write-Warning "FullBranch $fullBranch";
Write-Warning "releaseBranchName $releaseBranchName";
Write-Warning "buildNumber $buildNumber";

if($fullBranch.StartsWith("refs/pull"))
{
    $prid = $env:SYSTEM_PULLREQUEST_PULLREQUESTID;
    $tail = "-pr$($prid.ToString())";
}
else
{
    if($branch.ToUpperInvariant -eq $releaseBranchName.ToUpperInvariant())
    {
         $tail = "";
    }
    else
    {
        $compoundBranchName = [System.Text.RegularExpressions.Regex]::Replace($branch, "[^A-Za-z0-9]", "").ToLowerInvariant();

        Write-Warning "CompoundBranchName $compoundBranchName";
        [int]$take = 0;
        if($compoundBranchName.Length -ge 17)
        {
            $take = 17;
        }
        else
        {
            $take = $compoundBranchName.Length;
        }

        $subTail = $compoundBranchName.Substring($take);
        $tail = "-ci$subTail";
    }
}

$build = "$buildNumber$tail"
Write-Host "##vso[task.setvariable variable=CI.NugetBuildNumber]$build";