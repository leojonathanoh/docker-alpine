@"
FROM $( $VARIANT['_metadata']['distro'] ):$( $VARIANT['_metadata']['distro_version'] )


"@

$VARIANT['_metadata']['components'] | % {
    $component = $_

    switch( $_['name'] ) {

        'curl' {
        @"
RUN apk add --no-cache curl


"@
        }

        'git' {
        @"
RUN apk add --no-cache git


"@
        }

        'iptables' {
        @"
RUN apk add --no-cache iptables


"@
        }

        'jq' {
        @"
RUN apk add --no-cache jq


"@
        }

        'mysqlclient' {
        @"
RUN apk add --no-cache mysql-client


"@
        }

        'openssl' {
        @"
RUN apk add --no-cache openssl


"@
        }

        'rsync' {
        @"
RUN apk add --no-cache rsync


"@
        }

        'ssh' {
        @"
RUN apk add --no-cache openssh


"@
        }
    }
}
