$tags = @"
3.12-curl
3.12-curl-git
3.12-curl-git-jq
3.12-curl-git-jq-ssh
"@

$semverRegex = '\b^v?\d+\.\d+(\.\d+)?\b'
$distroRegex = '\balpine\b'
$VARIANTS = @(
    $tags -split "`n" | % {
        $split = $_ -split '-'
        $components = @(
            for ($i = 0; $i -lt $split.Count; $i++) {
                $c = [ordered]@{
                    name = $split[$i]
                    isPackageVersion = if ($i -eq 0 -and $split[$i] -match $semverRegex) { $true } else { $false }
                    isDistro = if ($split[$i] -match $distroRegex) { $true } else { $false }
                    version = ''
                }
                if ($i+1 -le $split.Count -and $split[$i+1] -match $semverRegex) {
                    $c['version'] = $split[$i+1]
                    $i++
                }
                $c
            }
        )

        @{
            # Metadata object
            _metadata = @{
                distro = 'alpine'
                distro_version = '3.12'
                platforms = 'linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64,linux/s390x'
                components = $components
                base_tag = & {
                    @(
                        $toolComponents = @(
                            $components | ? { ! $_['isPackageVersion'] -and ! $_['isDistro'] }
                        )
                        if ($toolComponents.Count -ge 2) {
                            $components | ? { $_['isPackageVersion'] } | % { $_['name'] }
                            $toolComponents[0..($toolComponents.Count - 2)] | % { $_['name'] }
                            $components | ? { $_['isDistro'] } | % {
                                $_['name']
                                $_['version']
                            }
                        }
                    ) -join '-'
                }
            }
            # Docker image tag. E.g. '3.8-curl'
            tag = $_
            tag_as_latest = $false
        }
    }
)

# Docker image variants' definitions (shared)
$VARIANTS_SHARED = @{
    buildContextFiles = @{
        templates = @{
            'Dockerfile' = @{
                common = $true
                includeHeader = $false
                includeFooter = $false
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
        }
    }
}

# $VARIANTS | % {
#     $_
#     $_['_metadata']
#     # $_['_metadata']['base_tag']
# }
