# Outline SDK (Beta)

[![Build Status](https://github.com/Jigsaw-Code/outline-sdk/actions/workflows/test.yml/badge.svg)](https://github.com/Jigsaw-Code/outline-sdk/actions/workflows/test.yml?query=branch%3Amain)
[![Go Report Card](https://goreportcard.com/badge/github.com/Jigsaw-Code/outline-sdk)](https://goreportcard.com/report/github.com/Jigsaw-Code/outline-sdk)
[![Go Reference](https://pkg.go.dev/badge/github.com/Jigsaw-Code/outline-sdk.svg)](https://pkg.go.dev/github.com/Jigsaw-Code/outline-sdk)

<p align="center">
<img src="https://github.com/Jigsaw-Code/outline-brand/blob/main/assets/powered_by_outline/color/logo.png?raw=true" width=400pt />
</p>

> ⚠️ **Warning**: This code is in early stages and is not guaranteed to be stable. If you are
> interested in integrating with it, we'd love your [feedback](https://github.com/Jigsaw-Code/outline-sdk/issues/new).

The Outline SDK allows you to:

- Create tools to protect against network-level interference.
- Add network-level interference protection to existing apps, such as content or communication apps.

## Advantages

| Multi-Platform | Proven Technology | Composable |
|:-:|:-:|:-:|
| Supports Android, iOS, Windows, macOS and Linux. | Field-tested in the Outline Client and Server, helping millions to access the internet under harsh conditions. | Designed for modularity and reuse, allowing you to craft custom transports. |

### Bypass DNS-based Blocking

We are working on a [new DNS library](https://github.com/Jigsaw-Code/outline-sdk/pull/141) that will let people bypass DNS-based blocking by using alternative
resolvers and ports, and encrypted DNS (DNS-over-HTTPS and DNS-over-TLS).

### Bypass SNI-based Blocking

The Outline SDK offers several strategies for evading SNI-based blocking:

At the TCP layer:

- TCP stream fragmentation with [transport/split](https://pkg.go.dev/github.com/Jigsaw-Code/outline-sdk/transport/split)
- TLS record fragmentation with [transport/tlsfrag](https://pkg.go.dev/github.com/Jigsaw-Code/outline-sdk/transport/tlsfrag)

At the application layer:

- Domain-fronting and SNI hiding with [transport/tls](https://pkg.go.dev/github.com/Jigsaw-Code/outline-sdk/transport/tls)

### Tunnel Connections over a Proxy

The Outline SDK offers two protocols to create connections over proxies:

- Shadowsocks, available in [transport/shadowsocks](https://pkg.go.dev/github.com/Jigsaw-Code/outline-sdk/transport/shadowsocks).
  Easily create servers in the cloud using the [Outline Manager](https://getoutline.org/get-started/#step-1).
- SOCKS5, available in [transport/socks5](https://pkg.go.dev/github.com/Jigsaw-Code/outline-sdk/transport/socks5). You can leverage a [local SOCKS5 proxy that tunnels connections over SSH](https://www.digitalocean.com/community/tutorials/how-to-route-web-traffic-securely-without-a-vpn-using-a-socks-tunnel).

### Build a VPN

Use the [network](https://pkg.go.dev/github.com/Jigsaw-Code/outline-sdk/network) package to create TUN-based VPNs using transport-layer proxies (often called "tun2socks").


## Add the SDK to Your App

Choose from one of the following methods to integrate the Outline SDK into your project:

- **Generated Mobile Library**: For Android, iOS, and macOS apps. Uses [`gomobile bind`](https://pkg.go.dev/golang.org/x/mobile/cmd/gomobile) to generate Java and Objective-C bindings.
- **Side Service**: For desktop and Android apps. Runs a standalone Go binary that your application communicates with (not available on iOS due to subprocess limitations).
- **Go Library**: Directly import the SDK into your Go application. [API Reference](https://pkg.go.dev/github.com/Jigsaw-Code/outline-sdk).
- **Generated C Library**: Generate C bindings using [`go build`](https://pkg.go.dev/cmd/go#hdr-Build_modes).

The Outline Client uses a **generated mobile library** on Android, iOS and macOS (based on Cordova) and a **side service** on Windows and Linux (based on Electron).

Below we provide more details on each integration approach. For more details about setting up and using Outline SDK features, see the [Discussions tab](https://github.com/Jigsaw-Code/outline-sdk/discussions).

### Generated Mobile Library

To integrate the SDK into a mobile app, follow these steps:

1. **Create a Go library**: Create a Go package that wraps the SDK functionalities you need.
1. **Generate mobile library**: Use [`gomobile bind`](https://pkg.go.dev/golang.org/x/mobile/cmd/gomobile) to generate Android Archives (AAR) and Apple Frameworks with Java and Objective-C bindings.
    - Android examples: [Outline Android Archive](https://github.com/Jigsaw-Code/outline-go-tun2socks/blob/dada2652ae2c6205f2daa3f88c805bbd6b28a713/Makefile#L27), [Intra Android Archive](https://github.com/Jigsaw-Code/outline-go-tun2socks/blob/dada2652ae2c6205f2daa3f88c805bbd6b28a713/Makefile#L21).
    - Apple examples: [Outline iOS Framework](https://github.com/Jigsaw-Code/outline-go-tun2socks/blob/dada2652ae2c6205f2daa3f88c805bbd6b28a713/Makefile#L30), [Outline macOS Framework](https://github.com/Jigsaw-Code/outline-go-tun2socks/blob/dada2652ae2c6205f2daa3f88c805bbd6b28a713/Makefile#L36).
1. **Integrate into your app**: Add the generated library to your app. For more details, see Go Mobile's [SDK applications and generating bindings](https://github.com/golang/go/wiki/Mobile#sdk-applications-and-generating-bindings).

> **Note**: You must use `gomobile bind` on the package you create, not directly on the SDK packages.

An easy way to integrate with the SDK in a mobile app is by using the [`x/mobileproxy` library](./x/mobileproxy/) 
to run a local web proxy that you can use to configure your app's networking libraries.

### Side Service

To integrate the SDK as a side service, follow these steps:

1. **Define IPC mechanism**: Choose an inter-process communication (IPC) mechanism (for example, sockets, standard I/O).
1. **Build the service**: Create a Go binary that includes the server-side of the IPC and used the SDK.
    - Examples: [Outline Electron backend code](https://github.com/Jigsaw-Code/outline-go-tun2socks/blob/master/outline/electron/main.go), [Outline Windows Client backend build](https://github.com/Jigsaw-Code/outline-go-tun2socks/blob/dada2652ae2c6205f2daa3f88c805bbd6b28a713/Makefile#L67), [Outline Linux Client backend build](https://github.com/Jigsaw-Code/outline-go-tun2socks/blob/dada2652ae2c6205f2daa3f88c805bbd6b28a713/Makefile#L56).
1. **Bundle the service**: Include the Go binary in your application bundle.
    - Examples: [Outline Windows Client](https://github.com/Jigsaw-Code/outline-client/blob/b06819922037230ee3ba9471097c40793af819e8/src/electron/electron-builder.json#L21), [Outline Linux Client](https://github.com/Jigsaw-Code/outline-client/blob/b06819922037230ee3ba9471097c40793af819e8/src/electron/electron-builder.json#L10)
1. **Start the service**: Launch the Go binary as a subprocess from your application.
    - Example: [Outline Electron Clients](https://github.com/Jigsaw-Code/outline-client/blob/b06819922037230ee3ba9471097c40793af819e8/src/electron/go_vpn_tunnel.ts#L227)
1. **Service Calls**: Add code to your app for communication with the service.


### Go Library

To integrate the Outline SDK as a Go library, you can directly import it into your Go application. See the [API Reference](https://pkg.go.dev/github.com/Jigsaw-Code/outline-sdk) for what's available.

This approach is suitable for both command-line and GUI-based applications. You can build GUI-based applications in Go with frameworks like [Wails](https://wails.io/), [Fyne.io](https://fyne.io/), [Qt for Go](https://therecipe.github.io/qt/), or [Go Mobile app](https://pkg.go.dev/golang.org/x/mobile/app).

For examples, see [x/examples](./x/examples/).

### Generated C Library

This approach is suited for applications that require C bindings. It is similar to the Generated Mobile Library approach, where you need to first create a Go library to generate bindings for.

Steps:

1. **Create a Go library**: Create a Go package that wraps the SDK functionalities you need. Functions to be exported must be marked with `//export`, as described in the [cgo documentation](https://pkg.go.dev/cmd/cgo#hdr-C_references_to_Go).
1. **Generate C library**: Use `go build` with the [appropriate `-buildmode` flag](https://pkg.go.dev/cmd/go#hdr-Build_modes). Anternatively, you can use [SWIG](https://swig.org/Doc4.1/Go.html#Go).
1. **Integrate into your app**: Add the generated C library to your application, according to your build system.

You can find detailed steps at the tutorial [Go for beginners: Getting started](https://github.com/Jigsaw-Code/outline-sdk/discussions/67).


## Command-line Tools

The Outline SDK has several command-line utilities that illustrate the usage of the SDK, but are also valuable for debugging and trying the different strategies without having to build an app.

They all take a `-transport` flag with a config that specifies what transport should be used to establish connections.
The config format can be found in [x/config](https://pkg.go.dev/github.com/Jigsaw-Code/outline-sdk/x/config).


### DNS Query

The [`resolve` tool](https://pkg.go.dev/github.com/Jigsaw-Code/outline-sdk/x/examples/resolve) resolves a domain name, similar to `dig`:

```console
$ go run github.com/Jigsaw-Code/outline-sdk/x/examples/resolve@latest -type A -transport "tls" -resolver 8.8.8.8:853 -tcp getoutline.org.
216.239.34.21
216.239.32.21
216.239.38.21
216.239.36.21
```


### HTTP Fetch

The [`fetch` tool](https://pkg.go.dev/github.com/Jigsaw-Code/outline-sdk/x/examples/fetch) fetches
a URL, similar to `curl`. The example below would bypass blocking of `meduza.io` in Russia:

```console
$ go run github.com/Jigsaw-Code/outline-sdk/x/examples/fetch@latest -transport "tlsfrag:1" -method HEAD -v -address "cloudflare.net" https://meduza.io/ 
[DEBUG] 2023/12/28 18:44:56.490836 main.go:105: Cf-Ray: [83cdac8ecdccc40e-EWR]
[DEBUG] 2023/12/28 18:44:56.491231 main.go:105: Alt-Svc: [h3=":443"; ma=86400]
[DEBUG] 2023/12/28 18:44:56.491237 main.go:105: Date: [Thu, 28 Dec 2023 23:44:56 GMT]
[DEBUG] 2023/12/28 18:44:56.491241 main.go:105: Connection: [keep-alive]
[DEBUG] 2023/12/28 18:44:56.491247 main.go:105: Strict-Transport-Security: [max-age=31536000; includeSubDomains; preload]
[DEBUG] 2023/12/28 18:44:56.491251 main.go:105: Cache-Control: [max-age=0 no-cache, no-store]
[DEBUG] 2023/12/28 18:44:56.491257 main.go:105: X-Content-Type-Options: [nosniff]
[DEBUG] 2023/12/28 18:44:56.491262 main.go:105: Server: [cloudflare]
[DEBUG] 2023/12/28 18:44:56.491266 main.go:105: Content-Type: [text/html; charset=utf-8]
[DEBUG] 2023/12/28 18:44:56.491270 main.go:105: Expires: [Thu, 28 Dec 2023 23:44:56 GMT]
[DEBUG] 2023/12/28 18:44:56.491273 main.go:105: Cf-Cache-Status: [DYNAMIC]
```

### Local Proxy Forwarder

The [`http2transport` tool](https://pkg.go.dev/github.com/Jigsaw-Code/outline-sdk/x/examples/http2transport) runs a local proxy that creates connections according to the transport. It's effectively a circumvention tool.

The example below is analogous to the previous fetch example.

Start the local proxy:

```console
$ go run github.com/Jigsaw-Code/outline-sdk/x/examples/http2transport@latest -transport "tlsfrag:1" -localAddr localhost:8080
2023/12/28 18:50:48 Proxy listening on 127.0.0.1:8080
```

Using the proxy with `curl`:

```console
$ curl -p -x http://localhost:8080 --connect-to ::cloudflare.net: https://meduza.io --head
HTTP/1.1 200 Connection established

HTTP/2 200 
date: Thu, 28 Dec 2023 23:51:01 GMT
content-type: text/html; charset=utf-8
strict-transport-security: max-age=31536000; includeSubDomains; preload
expires: Thu, 28 Dec 2023 23:51:01 GMT
cache-control: max-age=0
cache-control: no-cache, no-store
cf-cache-status: DYNAMIC
x-content-type-options: nosniff
server: cloudflare
cf-ray: 83cdb579bbec4376-EWR
alt-svc: h3=":443"; ma=86400
```

### Proxy Connectivity Test

The [`test-connectivity` tool](https://pkg.go.dev/github.com/Jigsaw-Code/outline-sdk/x/examples/test-connectivity) is useful to test connectivity to a proxy. It uses DNS resolutions over TCP and UDP using the transport to test if there is stream and datagram connectivity.

```console
$ go run github.com/Jigsaw-Code/outline-sdk/x/examples/test-connectivity@latest -transport "$OUTLINE_KEY" && echo success || echo failure
{"resolver":"8.8.8.8:53","proto":"tcp","time":"2023-12-28T23:57:45Z","duration_ms":39,"error":null}
{"resolver":"8.8.8.8:53","proto":"udp","time":"2023-12-28T23:57:45Z","duration_ms":17,"error":null}
{"resolver":"[2001:4860:4860::8888]:53","proto":"tcp","time":"2023-12-28T23:57:45Z","duration_ms":31,"error":null}
{"resolver":"[2001:4860:4860::8888]:53","proto":"udp","time":"2023-12-28T23:57:45Z","duration_ms":16,"error":null}
success
```
