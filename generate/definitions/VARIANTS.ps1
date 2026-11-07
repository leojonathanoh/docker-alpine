$global:VERSIONS = @( Get-Content $PSScriptRoot/versions.json -Encoding utf8 -raw | ConvertFrom-Json )

# Docker image variants' definitions
$local:VARIANTS_MATRIX = @(
    foreach ($v in $global:VERSIONS.alpine.versions) {
        $v = [version]$v
        @{
            distro = 'alpine'
            distro_version = "$( $v.Major ).$( $v.Minor )"
            subvariants = @(
                @{ components = @( 'curl', 'git', 'jq', 'ssh' ); tag_as_latest = if ($v -eq $global:VERSIONS.alpine.versions[0]) { $true } else { $false } }
                if ( $v -ge [version]'3.20' ) {
                    @{ components = @( 'apprise', 'curl', 'git', 'jq', 'ssh' ) }
                }
                @{ components = @( 'curl', 'mysqlclient', 'openssl' ) }
                if ( $v -ge [version]'3.20' ) {
                    @{ components = @( 'apprise', 'curl', 'mysqlclient', 'openssl' ) }
                }
                @{ components = @( 'pingme' ) }
                @{ components = @( 'iptables' ) }
                @{ components = @( 'rsync' ) }
                if ( [version]$v -ge [version]'3.15' ) {
                    # Add yq variants for alpine:3.15 and above
                    @{ components = @( 'yq' ) }
                }
            )
        }
    }
)

$VARIANTS = @(
    foreach ($variant in $VARIANTS_MATRIX){
        foreach ($subVariant in $variant['subvariants']) {
            @{
                # Metadata object
                _metadata = @{
                    distro = $variant['distro']
                    distro_version = $variant['distro_version']
                    platforms = & {
                        if ($variant -in @( '3.3', '3.4', '3.5' ) ) {
                            'linux/amd64'
                        }elseif ( $subVariant['components'] -contains 'pingme') {
                            'linux/386,linux/amd64,linux/arm/v7,linux/arm64'
                        }else {
                            'linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64,linux/s390x'
                        }
                    }
                    components = $subVariant['components']
                    job_group_key = $variant['distro_version']
                }
                # Docker image tag. E.g. '3.8-curl'
                tag = @(
                        $variant['distro_version']
                        $subVariant['components'] | ? { $_ }
                ) -join '-'
                tag_as_latest = if ( $subVariant.Contains('tag_as_latest') ) {
                                    $subVariant['tag_as_latest']
                                } else {
                                    $false
                                }
            }
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
