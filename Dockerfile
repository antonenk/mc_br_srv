FROM debian:12.6 AS build

ARG VERSION=1.20.62.01

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --yes --no-install-recommends install unzip libcurl4

WORKDIR /app

#ADD https://minecraft.azureedge.net/bin-linux/bedrock-server-$VERSION.zip /opt/minecraft/bedrock-server.zip
ADD bedrock-server-$VERSION.zip /app/bedrock-server.zip

RUN unzip bedrock-server.zip

RUN rm bedrock_server_symbols.debug

RUN rm allowlist.json permissions.json server.properties

RUN for F in development_behavior_packs development_resource_packs development_skin_packs minecraftpe premium_cache treatments worlds world_templates \
    Dedicated_Server.txt allowlist.json packet-statistics.txt permissions.json server.properties valid_known_packs.json; do ln -s /storage/$F /app/$F; done

#RUN ldd /usr/lib/x86_64-linux-gnu/libcurl.so.4



FROM gcr.io/distroless/cc-debian12:nonroot

WORKDIR /app

EXPOSE 19132/udp

ENV LD_LIBRARY_PATH=.

COPY --from=build /app /app

COPY --from=build /usr/lib/x86_64-linux-gnu/libcurl.so.4     /usr/lib/x86_64-linux-gnu/libcurl.so.4
COPY --from=build /lib/x86_64-linux-gnu/libbrotlicommon.so.1 /lib/x86_64-linux-gnu/libbrotlicommon.so.1
COPY --from=build /lib/x86_64-linux-gnu/libbrotlidec.so.1    /lib/x86_64-linux-gnu/libbrotlidec.so.1
COPY --from=build /lib/x86_64-linux-gnu/libcom_err.so.2      /lib/x86_64-linux-gnu/libcom_err.so.2
COPY --from=build /lib/x86_64-linux-gnu/libcrypto.so.3       /lib/x86_64-linux-gnu/libcrypto.so.3
COPY --from=build /lib/x86_64-linux-gnu/libdl.so.2           /lib/x86_64-linux-gnu/libdl.so.2
COPY --from=build /lib/x86_64-linux-gnu/libffi.so.8          /lib/x86_64-linux-gnu/libffi.so.8
COPY --from=build /lib/x86_64-linux-gnu/libgcrypt.so.20      /lib/x86_64-linux-gnu/libgcrypt.so.20
COPY --from=build /lib/x86_64-linux-gnu/libgmp.so.10         /lib/x86_64-linux-gnu/libgmp.so.10
COPY --from=build /lib/x86_64-linux-gnu/libgnutls.so.30      /lib/x86_64-linux-gnu/libgnutls.so.30
COPY --from=build /lib/x86_64-linux-gnu/libgpg-error.so.0    /lib/x86_64-linux-gnu/libgpg-error.so.0
COPY --from=build /lib/x86_64-linux-gnu/libgssapi_krb5.so.2  /lib/x86_64-linux-gnu/libgssapi_krb5.so.2
COPY --from=build /lib/x86_64-linux-gnu/libhogweed.so.6      /lib/x86_64-linux-gnu/libhogweed.so.6
COPY --from=build /lib/x86_64-linux-gnu/libidn2.so.0         /lib/x86_64-linux-gnu/libidn2.so.0
COPY --from=build /lib/x86_64-linux-gnu/libk5crypto.so.3     /lib/x86_64-linux-gnu/libk5crypto.so.3
COPY --from=build /lib/x86_64-linux-gnu/libkeyutils.so.1     /lib/x86_64-linux-gnu/libkeyutils.so.1
COPY --from=build /lib/x86_64-linux-gnu/libkrb5.so.3         /lib/x86_64-linux-gnu/libkrb5.so.3
COPY --from=build /lib/x86_64-linux-gnu/libkrb5support.so.0  /lib/x86_64-linux-gnu/libkrb5support.so.0
COPY --from=build /lib/x86_64-linux-gnu/liblber-2.5.so.0     /lib/x86_64-linux-gnu/liblber-2.5.so.0
COPY --from=build /lib/x86_64-linux-gnu/libldap-2.5.so.0     /lib/x86_64-linux-gnu/libldap-2.5.so.0
COPY --from=build /lib/x86_64-linux-gnu/libnettle.so.8       /lib/x86_64-linux-gnu/libnettle.so.8
COPY --from=build /lib/x86_64-linux-gnu/libnghttp2.so.14     /lib/x86_64-linux-gnu/libnghttp2.so.14
COPY --from=build /lib/x86_64-linux-gnu/libp11-kit.so.0      /lib/x86_64-linux-gnu/libp11-kit.so.0
COPY --from=build /lib/x86_64-linux-gnu/libpsl.so.5          /lib/x86_64-linux-gnu/libpsl.so.5
COPY --from=build /lib/x86_64-linux-gnu/librtmp.so.1         /lib/x86_64-linux-gnu/librtmp.so.1
COPY --from=build /lib/x86_64-linux-gnu/libsasl2.so.2        /lib/x86_64-linux-gnu/libsasl2.so.2
COPY --from=build /lib/x86_64-linux-gnu/libssh2.so.1         /lib/x86_64-linux-gnu/libssh2.so.1
COPY --from=build /lib/x86_64-linux-gnu/libssl.so.3          /lib/x86_64-linux-gnu/libssl.so.3
COPY --from=build /lib/x86_64-linux-gnu/libtasn1.so.6        /lib/x86_64-linux-gnu/libtasn1.so.6
COPY --from=build /lib/x86_64-linux-gnu/libunistring.so.2    /lib/x86_64-linux-gnu/libunistring.so.2
COPY --from=build /lib/x86_64-linux-gnu/libz.so.1            /lib/x86_64-linux-gnu/libz.so.1
COPY --from=build /lib/x86_64-linux-gnu/libzstd.so.1         /lib/x86_64-linux-gnu/libzstd.so.1

CMD ["/app/bedrock_server"]
