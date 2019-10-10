
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: VirtualWANAsAServiceManagementClient
## version: 2019-07-01
## termsOfService: (not provided)
## license: (not provided)
## 
## REST API for Azure VirtualWAN As a Service.
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_573666 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573666](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573666): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "network-virtualWan"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_P2sVpnGatewaysList_573888 = ref object of OpenApiRestCall_573666
proc url_P2sVpnGatewaysList_573890(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/p2svpnGateways")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_P2sVpnGatewaysList_573889(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists all the P2SVpnGateways in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574050 = path.getOrDefault("subscriptionId")
  valid_574050 = validateParameter(valid_574050, JString, required = true,
                                 default = nil)
  if valid_574050 != nil:
    section.add "subscriptionId", valid_574050
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574051 = query.getOrDefault("api-version")
  valid_574051 = validateParameter(valid_574051, JString, required = true,
                                 default = nil)
  if valid_574051 != nil:
    section.add "api-version", valid_574051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574078: Call_P2sVpnGatewaysList_573888; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the P2SVpnGateways in a subscription.
  ## 
  let valid = call_574078.validator(path, query, header, formData, body)
  let scheme = call_574078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574078.url(scheme.get, call_574078.host, call_574078.base,
                         call_574078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574078, url, valid)

proc call*(call_574149: Call_P2sVpnGatewaysList_573888; apiVersion: string;
          subscriptionId: string): Recallable =
  ## p2sVpnGatewaysList
  ## Lists all the P2SVpnGateways in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574150 = newJObject()
  var query_574152 = newJObject()
  add(query_574152, "api-version", newJString(apiVersion))
  add(path_574150, "subscriptionId", newJString(subscriptionId))
  result = call_574149.call(path_574150, query_574152, nil, nil, nil)

var p2sVpnGatewaysList* = Call_P2sVpnGatewaysList_573888(
    name: "p2sVpnGatewaysList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/p2svpnGateways",
    validator: validate_P2sVpnGatewaysList_573889, base: "",
    url: url_P2sVpnGatewaysList_573890, schemes: {Scheme.Https})
type
  Call_VirtualHubsList_574191 = ref object of OpenApiRestCall_573666
proc url_VirtualHubsList_574193(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/virtualHubs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualHubsList_574192(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Lists all the VirtualHubs in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574194 = path.getOrDefault("subscriptionId")
  valid_574194 = validateParameter(valid_574194, JString, required = true,
                                 default = nil)
  if valid_574194 != nil:
    section.add "subscriptionId", valid_574194
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574195 = query.getOrDefault("api-version")
  valid_574195 = validateParameter(valid_574195, JString, required = true,
                                 default = nil)
  if valid_574195 != nil:
    section.add "api-version", valid_574195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574196: Call_VirtualHubsList_574191; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VirtualHubs in a subscription.
  ## 
  let valid = call_574196.validator(path, query, header, formData, body)
  let scheme = call_574196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574196.url(scheme.get, call_574196.host, call_574196.base,
                         call_574196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574196, url, valid)

proc call*(call_574197: Call_VirtualHubsList_574191; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualHubsList
  ## Lists all the VirtualHubs in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574198 = newJObject()
  var query_574199 = newJObject()
  add(query_574199, "api-version", newJString(apiVersion))
  add(path_574198, "subscriptionId", newJString(subscriptionId))
  result = call_574197.call(path_574198, query_574199, nil, nil, nil)

var virtualHubsList* = Call_VirtualHubsList_574191(name: "virtualHubsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/virtualHubs",
    validator: validate_VirtualHubsList_574192, base: "", url: url_VirtualHubsList_574193,
    schemes: {Scheme.Https})
type
  Call_VirtualWansList_574200 = ref object of OpenApiRestCall_573666
proc url_VirtualWansList_574202(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/virtualWans")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualWansList_574201(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Lists all the VirtualWANs in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574203 = path.getOrDefault("subscriptionId")
  valid_574203 = validateParameter(valid_574203, JString, required = true,
                                 default = nil)
  if valid_574203 != nil:
    section.add "subscriptionId", valid_574203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574204 = query.getOrDefault("api-version")
  valid_574204 = validateParameter(valid_574204, JString, required = true,
                                 default = nil)
  if valid_574204 != nil:
    section.add "api-version", valid_574204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574205: Call_VirtualWansList_574200; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VirtualWANs in a subscription.
  ## 
  let valid = call_574205.validator(path, query, header, formData, body)
  let scheme = call_574205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574205.url(scheme.get, call_574205.host, call_574205.base,
                         call_574205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574205, url, valid)

proc call*(call_574206: Call_VirtualWansList_574200; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualWansList
  ## Lists all the VirtualWANs in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574207 = newJObject()
  var query_574208 = newJObject()
  add(query_574208, "api-version", newJString(apiVersion))
  add(path_574207, "subscriptionId", newJString(subscriptionId))
  result = call_574206.call(path_574207, query_574208, nil, nil, nil)

var virtualWansList* = Call_VirtualWansList_574200(name: "virtualWansList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/virtualWans",
    validator: validate_VirtualWansList_574201, base: "", url: url_VirtualWansList_574202,
    schemes: {Scheme.Https})
type
  Call_VpnGatewaysList_574209 = ref object of OpenApiRestCall_573666
proc url_VpnGatewaysList_574211(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/vpnGateways")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VpnGatewaysList_574210(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Lists all the VpnGateways in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574212 = path.getOrDefault("subscriptionId")
  valid_574212 = validateParameter(valid_574212, JString, required = true,
                                 default = nil)
  if valid_574212 != nil:
    section.add "subscriptionId", valid_574212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574213 = query.getOrDefault("api-version")
  valid_574213 = validateParameter(valid_574213, JString, required = true,
                                 default = nil)
  if valid_574213 != nil:
    section.add "api-version", valid_574213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574214: Call_VpnGatewaysList_574209; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VpnGateways in a subscription.
  ## 
  let valid = call_574214.validator(path, query, header, formData, body)
  let scheme = call_574214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574214.url(scheme.get, call_574214.host, call_574214.base,
                         call_574214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574214, url, valid)

proc call*(call_574215: Call_VpnGatewaysList_574209; apiVersion: string;
          subscriptionId: string): Recallable =
  ## vpnGatewaysList
  ## Lists all the VpnGateways in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574216 = newJObject()
  var query_574217 = newJObject()
  add(query_574217, "api-version", newJString(apiVersion))
  add(path_574216, "subscriptionId", newJString(subscriptionId))
  result = call_574215.call(path_574216, query_574217, nil, nil, nil)

var vpnGatewaysList* = Call_VpnGatewaysList_574209(name: "vpnGatewaysList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/vpnGateways",
    validator: validate_VpnGatewaysList_574210, base: "", url: url_VpnGatewaysList_574211,
    schemes: {Scheme.Https})
type
  Call_VpnSitesList_574218 = ref object of OpenApiRestCall_573666
proc url_VpnSitesList_574220(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/vpnSites")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VpnSitesList_574219(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the VpnSites in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574221 = path.getOrDefault("subscriptionId")
  valid_574221 = validateParameter(valid_574221, JString, required = true,
                                 default = nil)
  if valid_574221 != nil:
    section.add "subscriptionId", valid_574221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574222 = query.getOrDefault("api-version")
  valid_574222 = validateParameter(valid_574222, JString, required = true,
                                 default = nil)
  if valid_574222 != nil:
    section.add "api-version", valid_574222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574223: Call_VpnSitesList_574218; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VpnSites in a subscription.
  ## 
  let valid = call_574223.validator(path, query, header, formData, body)
  let scheme = call_574223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574223.url(scheme.get, call_574223.host, call_574223.base,
                         call_574223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574223, url, valid)

proc call*(call_574224: Call_VpnSitesList_574218; apiVersion: string;
          subscriptionId: string): Recallable =
  ## vpnSitesList
  ## Lists all the VpnSites in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574225 = newJObject()
  var query_574226 = newJObject()
  add(query_574226, "api-version", newJString(apiVersion))
  add(path_574225, "subscriptionId", newJString(subscriptionId))
  result = call_574224.call(path_574225, query_574226, nil, nil, nil)

var vpnSitesList* = Call_VpnSitesList_574218(name: "vpnSitesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/vpnSites",
    validator: validate_VpnSitesList_574219, base: "", url: url_VpnSitesList_574220,
    schemes: {Scheme.Https})
type
  Call_P2sVpnGatewaysListByResourceGroup_574227 = ref object of OpenApiRestCall_573666
proc url_P2sVpnGatewaysListByResourceGroup_574229(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/p2svpnGateways")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_P2sVpnGatewaysListByResourceGroup_574228(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the P2SVpnGateways in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the P2SVpnGateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574230 = path.getOrDefault("resourceGroupName")
  valid_574230 = validateParameter(valid_574230, JString, required = true,
                                 default = nil)
  if valid_574230 != nil:
    section.add "resourceGroupName", valid_574230
  var valid_574231 = path.getOrDefault("subscriptionId")
  valid_574231 = validateParameter(valid_574231, JString, required = true,
                                 default = nil)
  if valid_574231 != nil:
    section.add "subscriptionId", valid_574231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574232 = query.getOrDefault("api-version")
  valid_574232 = validateParameter(valid_574232, JString, required = true,
                                 default = nil)
  if valid_574232 != nil:
    section.add "api-version", valid_574232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574233: Call_P2sVpnGatewaysListByResourceGroup_574227;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the P2SVpnGateways in a resource group.
  ## 
  let valid = call_574233.validator(path, query, header, formData, body)
  let scheme = call_574233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574233.url(scheme.get, call_574233.host, call_574233.base,
                         call_574233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574233, url, valid)

proc call*(call_574234: Call_P2sVpnGatewaysListByResourceGroup_574227;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## p2sVpnGatewaysListByResourceGroup
  ## Lists all the P2SVpnGateways in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the P2SVpnGateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574235 = newJObject()
  var query_574236 = newJObject()
  add(path_574235, "resourceGroupName", newJString(resourceGroupName))
  add(query_574236, "api-version", newJString(apiVersion))
  add(path_574235, "subscriptionId", newJString(subscriptionId))
  result = call_574234.call(path_574235, query_574236, nil, nil, nil)

var p2sVpnGatewaysListByResourceGroup* = Call_P2sVpnGatewaysListByResourceGroup_574227(
    name: "p2sVpnGatewaysListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/p2svpnGateways",
    validator: validate_P2sVpnGatewaysListByResourceGroup_574228, base: "",
    url: url_P2sVpnGatewaysListByResourceGroup_574229, schemes: {Scheme.Https})
type
  Call_P2sVpnGatewaysCreateOrUpdate_574248 = ref object of OpenApiRestCall_573666
proc url_P2sVpnGatewaysCreateOrUpdate_574250(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "gatewayName" in path, "`gatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/p2svpnGateways/"),
               (kind: VariableSegment, value: "gatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_P2sVpnGatewaysCreateOrUpdate_574249(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a virtual wan p2s vpn gateway if it doesn't exist else updates the existing gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the P2SVpnGateway.
  ##   gatewayName: JString (required)
  ##              : The name of the gateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574277 = path.getOrDefault("resourceGroupName")
  valid_574277 = validateParameter(valid_574277, JString, required = true,
                                 default = nil)
  if valid_574277 != nil:
    section.add "resourceGroupName", valid_574277
  var valid_574278 = path.getOrDefault("gatewayName")
  valid_574278 = validateParameter(valid_574278, JString, required = true,
                                 default = nil)
  if valid_574278 != nil:
    section.add "gatewayName", valid_574278
  var valid_574279 = path.getOrDefault("subscriptionId")
  valid_574279 = validateParameter(valid_574279, JString, required = true,
                                 default = nil)
  if valid_574279 != nil:
    section.add "subscriptionId", valid_574279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574280 = query.getOrDefault("api-version")
  valid_574280 = validateParameter(valid_574280, JString, required = true,
                                 default = nil)
  if valid_574280 != nil:
    section.add "api-version", valid_574280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   p2SVpnGatewayParameters: JObject (required)
  ##                          : Parameters supplied to create or Update a virtual wan p2s vpn gateway.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574282: Call_P2sVpnGatewaysCreateOrUpdate_574248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a virtual wan p2s vpn gateway if it doesn't exist else updates the existing gateway.
  ## 
  let valid = call_574282.validator(path, query, header, formData, body)
  let scheme = call_574282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574282.url(scheme.get, call_574282.host, call_574282.base,
                         call_574282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574282, url, valid)

proc call*(call_574283: Call_P2sVpnGatewaysCreateOrUpdate_574248;
          resourceGroupName: string; apiVersion: string; gatewayName: string;
          subscriptionId: string; p2SVpnGatewayParameters: JsonNode): Recallable =
  ## p2sVpnGatewaysCreateOrUpdate
  ## Creates a virtual wan p2s vpn gateway if it doesn't exist else updates the existing gateway.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the P2SVpnGateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   gatewayName: string (required)
  ##              : The name of the gateway.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   p2SVpnGatewayParameters: JObject (required)
  ##                          : Parameters supplied to create or Update a virtual wan p2s vpn gateway.
  var path_574284 = newJObject()
  var query_574285 = newJObject()
  var body_574286 = newJObject()
  add(path_574284, "resourceGroupName", newJString(resourceGroupName))
  add(query_574285, "api-version", newJString(apiVersion))
  add(path_574284, "gatewayName", newJString(gatewayName))
  add(path_574284, "subscriptionId", newJString(subscriptionId))
  if p2SVpnGatewayParameters != nil:
    body_574286 = p2SVpnGatewayParameters
  result = call_574283.call(path_574284, query_574285, nil, nil, body_574286)

var p2sVpnGatewaysCreateOrUpdate* = Call_P2sVpnGatewaysCreateOrUpdate_574248(
    name: "p2sVpnGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/p2svpnGateways/{gatewayName}",
    validator: validate_P2sVpnGatewaysCreateOrUpdate_574249, base: "",
    url: url_P2sVpnGatewaysCreateOrUpdate_574250, schemes: {Scheme.Https})
type
  Call_P2sVpnGatewaysGet_574237 = ref object of OpenApiRestCall_573666
proc url_P2sVpnGatewaysGet_574239(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "gatewayName" in path, "`gatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/p2svpnGateways/"),
               (kind: VariableSegment, value: "gatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_P2sVpnGatewaysGet_574238(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Retrieves the details of a virtual wan p2s vpn gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the P2SVpnGateway.
  ##   gatewayName: JString (required)
  ##              : The name of the gateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574240 = path.getOrDefault("resourceGroupName")
  valid_574240 = validateParameter(valid_574240, JString, required = true,
                                 default = nil)
  if valid_574240 != nil:
    section.add "resourceGroupName", valid_574240
  var valid_574241 = path.getOrDefault("gatewayName")
  valid_574241 = validateParameter(valid_574241, JString, required = true,
                                 default = nil)
  if valid_574241 != nil:
    section.add "gatewayName", valid_574241
  var valid_574242 = path.getOrDefault("subscriptionId")
  valid_574242 = validateParameter(valid_574242, JString, required = true,
                                 default = nil)
  if valid_574242 != nil:
    section.add "subscriptionId", valid_574242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574243 = query.getOrDefault("api-version")
  valid_574243 = validateParameter(valid_574243, JString, required = true,
                                 default = nil)
  if valid_574243 != nil:
    section.add "api-version", valid_574243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574244: Call_P2sVpnGatewaysGet_574237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a virtual wan p2s vpn gateway.
  ## 
  let valid = call_574244.validator(path, query, header, formData, body)
  let scheme = call_574244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574244.url(scheme.get, call_574244.host, call_574244.base,
                         call_574244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574244, url, valid)

proc call*(call_574245: Call_P2sVpnGatewaysGet_574237; resourceGroupName: string;
          apiVersion: string; gatewayName: string; subscriptionId: string): Recallable =
  ## p2sVpnGatewaysGet
  ## Retrieves the details of a virtual wan p2s vpn gateway.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the P2SVpnGateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   gatewayName: string (required)
  ##              : The name of the gateway.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574246 = newJObject()
  var query_574247 = newJObject()
  add(path_574246, "resourceGroupName", newJString(resourceGroupName))
  add(query_574247, "api-version", newJString(apiVersion))
  add(path_574246, "gatewayName", newJString(gatewayName))
  add(path_574246, "subscriptionId", newJString(subscriptionId))
  result = call_574245.call(path_574246, query_574247, nil, nil, nil)

var p2sVpnGatewaysGet* = Call_P2sVpnGatewaysGet_574237(name: "p2sVpnGatewaysGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/p2svpnGateways/{gatewayName}",
    validator: validate_P2sVpnGatewaysGet_574238, base: "",
    url: url_P2sVpnGatewaysGet_574239, schemes: {Scheme.Https})
type
  Call_P2sVpnGatewaysUpdateTags_574298 = ref object of OpenApiRestCall_573666
proc url_P2sVpnGatewaysUpdateTags_574300(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "gatewayName" in path, "`gatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/p2svpnGateways/"),
               (kind: VariableSegment, value: "gatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_P2sVpnGatewaysUpdateTags_574299(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates virtual wan p2s vpn gateway tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the P2SVpnGateway.
  ##   gatewayName: JString (required)
  ##              : The name of the gateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574301 = path.getOrDefault("resourceGroupName")
  valid_574301 = validateParameter(valid_574301, JString, required = true,
                                 default = nil)
  if valid_574301 != nil:
    section.add "resourceGroupName", valid_574301
  var valid_574302 = path.getOrDefault("gatewayName")
  valid_574302 = validateParameter(valid_574302, JString, required = true,
                                 default = nil)
  if valid_574302 != nil:
    section.add "gatewayName", valid_574302
  var valid_574303 = path.getOrDefault("subscriptionId")
  valid_574303 = validateParameter(valid_574303, JString, required = true,
                                 default = nil)
  if valid_574303 != nil:
    section.add "subscriptionId", valid_574303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574304 = query.getOrDefault("api-version")
  valid_574304 = validateParameter(valid_574304, JString, required = true,
                                 default = nil)
  if valid_574304 != nil:
    section.add "api-version", valid_574304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   p2SVpnGatewayParameters: JObject (required)
  ##                          : Parameters supplied to update a virtual wan p2s vpn gateway tags.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574306: Call_P2sVpnGatewaysUpdateTags_574298; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates virtual wan p2s vpn gateway tags.
  ## 
  let valid = call_574306.validator(path, query, header, formData, body)
  let scheme = call_574306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574306.url(scheme.get, call_574306.host, call_574306.base,
                         call_574306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574306, url, valid)

proc call*(call_574307: Call_P2sVpnGatewaysUpdateTags_574298;
          resourceGroupName: string; apiVersion: string; gatewayName: string;
          subscriptionId: string; p2SVpnGatewayParameters: JsonNode): Recallable =
  ## p2sVpnGatewaysUpdateTags
  ## Updates virtual wan p2s vpn gateway tags.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the P2SVpnGateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   gatewayName: string (required)
  ##              : The name of the gateway.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   p2SVpnGatewayParameters: JObject (required)
  ##                          : Parameters supplied to update a virtual wan p2s vpn gateway tags.
  var path_574308 = newJObject()
  var query_574309 = newJObject()
  var body_574310 = newJObject()
  add(path_574308, "resourceGroupName", newJString(resourceGroupName))
  add(query_574309, "api-version", newJString(apiVersion))
  add(path_574308, "gatewayName", newJString(gatewayName))
  add(path_574308, "subscriptionId", newJString(subscriptionId))
  if p2SVpnGatewayParameters != nil:
    body_574310 = p2SVpnGatewayParameters
  result = call_574307.call(path_574308, query_574309, nil, nil, body_574310)

var p2sVpnGatewaysUpdateTags* = Call_P2sVpnGatewaysUpdateTags_574298(
    name: "p2sVpnGatewaysUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/p2svpnGateways/{gatewayName}",
    validator: validate_P2sVpnGatewaysUpdateTags_574299, base: "",
    url: url_P2sVpnGatewaysUpdateTags_574300, schemes: {Scheme.Https})
type
  Call_P2sVpnGatewaysDelete_574287 = ref object of OpenApiRestCall_573666
proc url_P2sVpnGatewaysDelete_574289(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "gatewayName" in path, "`gatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/p2svpnGateways/"),
               (kind: VariableSegment, value: "gatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_P2sVpnGatewaysDelete_574288(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a virtual wan p2s vpn gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the P2SVpnGateway.
  ##   gatewayName: JString (required)
  ##              : The name of the gateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574290 = path.getOrDefault("resourceGroupName")
  valid_574290 = validateParameter(valid_574290, JString, required = true,
                                 default = nil)
  if valid_574290 != nil:
    section.add "resourceGroupName", valid_574290
  var valid_574291 = path.getOrDefault("gatewayName")
  valid_574291 = validateParameter(valid_574291, JString, required = true,
                                 default = nil)
  if valid_574291 != nil:
    section.add "gatewayName", valid_574291
  var valid_574292 = path.getOrDefault("subscriptionId")
  valid_574292 = validateParameter(valid_574292, JString, required = true,
                                 default = nil)
  if valid_574292 != nil:
    section.add "subscriptionId", valid_574292
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574293 = query.getOrDefault("api-version")
  valid_574293 = validateParameter(valid_574293, JString, required = true,
                                 default = nil)
  if valid_574293 != nil:
    section.add "api-version", valid_574293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574294: Call_P2sVpnGatewaysDelete_574287; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a virtual wan p2s vpn gateway.
  ## 
  let valid = call_574294.validator(path, query, header, formData, body)
  let scheme = call_574294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574294.url(scheme.get, call_574294.host, call_574294.base,
                         call_574294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574294, url, valid)

proc call*(call_574295: Call_P2sVpnGatewaysDelete_574287;
          resourceGroupName: string; apiVersion: string; gatewayName: string;
          subscriptionId: string): Recallable =
  ## p2sVpnGatewaysDelete
  ## Deletes a virtual wan p2s vpn gateway.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the P2SVpnGateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   gatewayName: string (required)
  ##              : The name of the gateway.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574296 = newJObject()
  var query_574297 = newJObject()
  add(path_574296, "resourceGroupName", newJString(resourceGroupName))
  add(query_574297, "api-version", newJString(apiVersion))
  add(path_574296, "gatewayName", newJString(gatewayName))
  add(path_574296, "subscriptionId", newJString(subscriptionId))
  result = call_574295.call(path_574296, query_574297, nil, nil, nil)

var p2sVpnGatewaysDelete* = Call_P2sVpnGatewaysDelete_574287(
    name: "p2sVpnGatewaysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/p2svpnGateways/{gatewayName}",
    validator: validate_P2sVpnGatewaysDelete_574288, base: "",
    url: url_P2sVpnGatewaysDelete_574289, schemes: {Scheme.Https})
type
  Call_P2sVpnGatewaysGenerateVpnProfile_574311 = ref object of OpenApiRestCall_573666
proc url_P2sVpnGatewaysGenerateVpnProfile_574313(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "gatewayName" in path, "`gatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/p2svpnGateways/"),
               (kind: VariableSegment, value: "gatewayName"),
               (kind: ConstantSegment, value: "/generatevpnprofile")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_P2sVpnGatewaysGenerateVpnProfile_574312(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates VPN profile for P2S client of the P2SVpnGateway in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   gatewayName: JString (required)
  ##              : The name of the P2SVpnGateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574314 = path.getOrDefault("resourceGroupName")
  valid_574314 = validateParameter(valid_574314, JString, required = true,
                                 default = nil)
  if valid_574314 != nil:
    section.add "resourceGroupName", valid_574314
  var valid_574315 = path.getOrDefault("gatewayName")
  valid_574315 = validateParameter(valid_574315, JString, required = true,
                                 default = nil)
  if valid_574315 != nil:
    section.add "gatewayName", valid_574315
  var valid_574316 = path.getOrDefault("subscriptionId")
  valid_574316 = validateParameter(valid_574316, JString, required = true,
                                 default = nil)
  if valid_574316 != nil:
    section.add "subscriptionId", valid_574316
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574317 = query.getOrDefault("api-version")
  valid_574317 = validateParameter(valid_574317, JString, required = true,
                                 default = nil)
  if valid_574317 != nil:
    section.add "api-version", valid_574317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the generate P2SVpnGateway VPN client package operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574319: Call_P2sVpnGatewaysGenerateVpnProfile_574311;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates VPN profile for P2S client of the P2SVpnGateway in the specified resource group.
  ## 
  let valid = call_574319.validator(path, query, header, formData, body)
  let scheme = call_574319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574319.url(scheme.get, call_574319.host, call_574319.base,
                         call_574319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574319, url, valid)

proc call*(call_574320: Call_P2sVpnGatewaysGenerateVpnProfile_574311;
          resourceGroupName: string; apiVersion: string; gatewayName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## p2sVpnGatewaysGenerateVpnProfile
  ## Generates VPN profile for P2S client of the P2SVpnGateway in the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   gatewayName: string (required)
  ##              : The name of the P2SVpnGateway.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the generate P2SVpnGateway VPN client package operation.
  var path_574321 = newJObject()
  var query_574322 = newJObject()
  var body_574323 = newJObject()
  add(path_574321, "resourceGroupName", newJString(resourceGroupName))
  add(query_574322, "api-version", newJString(apiVersion))
  add(path_574321, "gatewayName", newJString(gatewayName))
  add(path_574321, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574323 = parameters
  result = call_574320.call(path_574321, query_574322, nil, nil, body_574323)

var p2sVpnGatewaysGenerateVpnProfile* = Call_P2sVpnGatewaysGenerateVpnProfile_574311(
    name: "p2sVpnGatewaysGenerateVpnProfile", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/p2svpnGateways/{gatewayName}/generatevpnprofile",
    validator: validate_P2sVpnGatewaysGenerateVpnProfile_574312, base: "",
    url: url_P2sVpnGatewaysGenerateVpnProfile_574313, schemes: {Scheme.Https})
type
  Call_P2sVpnGatewaysGetP2sVpnConnectionHealth_574324 = ref object of OpenApiRestCall_573666
proc url_P2sVpnGatewaysGetP2sVpnConnectionHealth_574326(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "gatewayName" in path, "`gatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/p2svpnGateways/"),
               (kind: VariableSegment, value: "gatewayName"),
               (kind: ConstantSegment, value: "/getP2sVpnConnectionHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_P2sVpnGatewaysGetP2sVpnConnectionHealth_574325(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the connection health of P2S clients of the virtual wan P2SVpnGateway in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   gatewayName: JString (required)
  ##              : The name of the P2SVpnGateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574327 = path.getOrDefault("resourceGroupName")
  valid_574327 = validateParameter(valid_574327, JString, required = true,
                                 default = nil)
  if valid_574327 != nil:
    section.add "resourceGroupName", valid_574327
  var valid_574328 = path.getOrDefault("gatewayName")
  valid_574328 = validateParameter(valid_574328, JString, required = true,
                                 default = nil)
  if valid_574328 != nil:
    section.add "gatewayName", valid_574328
  var valid_574329 = path.getOrDefault("subscriptionId")
  valid_574329 = validateParameter(valid_574329, JString, required = true,
                                 default = nil)
  if valid_574329 != nil:
    section.add "subscriptionId", valid_574329
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574330 = query.getOrDefault("api-version")
  valid_574330 = validateParameter(valid_574330, JString, required = true,
                                 default = nil)
  if valid_574330 != nil:
    section.add "api-version", valid_574330
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574331: Call_P2sVpnGatewaysGetP2sVpnConnectionHealth_574324;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the connection health of P2S clients of the virtual wan P2SVpnGateway in the specified resource group.
  ## 
  let valid = call_574331.validator(path, query, header, formData, body)
  let scheme = call_574331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574331.url(scheme.get, call_574331.host, call_574331.base,
                         call_574331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574331, url, valid)

proc call*(call_574332: Call_P2sVpnGatewaysGetP2sVpnConnectionHealth_574324;
          resourceGroupName: string; apiVersion: string; gatewayName: string;
          subscriptionId: string): Recallable =
  ## p2sVpnGatewaysGetP2sVpnConnectionHealth
  ## Gets the connection health of P2S clients of the virtual wan P2SVpnGateway in the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   gatewayName: string (required)
  ##              : The name of the P2SVpnGateway.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574333 = newJObject()
  var query_574334 = newJObject()
  add(path_574333, "resourceGroupName", newJString(resourceGroupName))
  add(query_574334, "api-version", newJString(apiVersion))
  add(path_574333, "gatewayName", newJString(gatewayName))
  add(path_574333, "subscriptionId", newJString(subscriptionId))
  result = call_574332.call(path_574333, query_574334, nil, nil, nil)

var p2sVpnGatewaysGetP2sVpnConnectionHealth* = Call_P2sVpnGatewaysGetP2sVpnConnectionHealth_574324(
    name: "p2sVpnGatewaysGetP2sVpnConnectionHealth", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/p2svpnGateways/{gatewayName}/getP2sVpnConnectionHealth",
    validator: validate_P2sVpnGatewaysGetP2sVpnConnectionHealth_574325, base: "",
    url: url_P2sVpnGatewaysGetP2sVpnConnectionHealth_574326,
    schemes: {Scheme.Https})
type
  Call_VirtualHubsListByResourceGroup_574335 = ref object of OpenApiRestCall_573666
proc url_VirtualHubsListByResourceGroup_574337(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/virtualHubs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualHubsListByResourceGroup_574336(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the VirtualHubs in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VirtualHub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574338 = path.getOrDefault("resourceGroupName")
  valid_574338 = validateParameter(valid_574338, JString, required = true,
                                 default = nil)
  if valid_574338 != nil:
    section.add "resourceGroupName", valid_574338
  var valid_574339 = path.getOrDefault("subscriptionId")
  valid_574339 = validateParameter(valid_574339, JString, required = true,
                                 default = nil)
  if valid_574339 != nil:
    section.add "subscriptionId", valid_574339
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574340 = query.getOrDefault("api-version")
  valid_574340 = validateParameter(valid_574340, JString, required = true,
                                 default = nil)
  if valid_574340 != nil:
    section.add "api-version", valid_574340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574341: Call_VirtualHubsListByResourceGroup_574335; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VirtualHubs in a resource group.
  ## 
  let valid = call_574341.validator(path, query, header, formData, body)
  let scheme = call_574341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574341.url(scheme.get, call_574341.host, call_574341.base,
                         call_574341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574341, url, valid)

proc call*(call_574342: Call_VirtualHubsListByResourceGroup_574335;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualHubsListByResourceGroup
  ## Lists all the VirtualHubs in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualHub.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574343 = newJObject()
  var query_574344 = newJObject()
  add(path_574343, "resourceGroupName", newJString(resourceGroupName))
  add(query_574344, "api-version", newJString(apiVersion))
  add(path_574343, "subscriptionId", newJString(subscriptionId))
  result = call_574342.call(path_574343, query_574344, nil, nil, nil)

var virtualHubsListByResourceGroup* = Call_VirtualHubsListByResourceGroup_574335(
    name: "virtualHubsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs",
    validator: validate_VirtualHubsListByResourceGroup_574336, base: "",
    url: url_VirtualHubsListByResourceGroup_574337, schemes: {Scheme.Https})
type
  Call_VirtualHubsCreateOrUpdate_574356 = ref object of OpenApiRestCall_573666
proc url_VirtualHubsCreateOrUpdate_574358(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualHubName" in path, "`virtualHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/virtualHubs/"),
               (kind: VariableSegment, value: "virtualHubName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualHubsCreateOrUpdate_574357(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a VirtualHub resource if it doesn't exist else updates the existing VirtualHub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VirtualHub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualHubName: JString (required)
  ##                 : The name of the VirtualHub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574359 = path.getOrDefault("resourceGroupName")
  valid_574359 = validateParameter(valid_574359, JString, required = true,
                                 default = nil)
  if valid_574359 != nil:
    section.add "resourceGroupName", valid_574359
  var valid_574360 = path.getOrDefault("subscriptionId")
  valid_574360 = validateParameter(valid_574360, JString, required = true,
                                 default = nil)
  if valid_574360 != nil:
    section.add "subscriptionId", valid_574360
  var valid_574361 = path.getOrDefault("virtualHubName")
  valid_574361 = validateParameter(valid_574361, JString, required = true,
                                 default = nil)
  if valid_574361 != nil:
    section.add "virtualHubName", valid_574361
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574362 = query.getOrDefault("api-version")
  valid_574362 = validateParameter(valid_574362, JString, required = true,
                                 default = nil)
  if valid_574362 != nil:
    section.add "api-version", valid_574362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   virtualHubParameters: JObject (required)
  ##                       : Parameters supplied to create or update VirtualHub.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574364: Call_VirtualHubsCreateOrUpdate_574356; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a VirtualHub resource if it doesn't exist else updates the existing VirtualHub.
  ## 
  let valid = call_574364.validator(path, query, header, formData, body)
  let scheme = call_574364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574364.url(scheme.get, call_574364.host, call_574364.base,
                         call_574364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574364, url, valid)

proc call*(call_574365: Call_VirtualHubsCreateOrUpdate_574356;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualHubName: string; virtualHubParameters: JsonNode): Recallable =
  ## virtualHubsCreateOrUpdate
  ## Creates a VirtualHub resource if it doesn't exist else updates the existing VirtualHub.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualHub.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualHubName: string (required)
  ##                 : The name of the VirtualHub.
  ##   virtualHubParameters: JObject (required)
  ##                       : Parameters supplied to create or update VirtualHub.
  var path_574366 = newJObject()
  var query_574367 = newJObject()
  var body_574368 = newJObject()
  add(path_574366, "resourceGroupName", newJString(resourceGroupName))
  add(query_574367, "api-version", newJString(apiVersion))
  add(path_574366, "subscriptionId", newJString(subscriptionId))
  add(path_574366, "virtualHubName", newJString(virtualHubName))
  if virtualHubParameters != nil:
    body_574368 = virtualHubParameters
  result = call_574365.call(path_574366, query_574367, nil, nil, body_574368)

var virtualHubsCreateOrUpdate* = Call_VirtualHubsCreateOrUpdate_574356(
    name: "virtualHubsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}",
    validator: validate_VirtualHubsCreateOrUpdate_574357, base: "",
    url: url_VirtualHubsCreateOrUpdate_574358, schemes: {Scheme.Https})
type
  Call_VirtualHubsGet_574345 = ref object of OpenApiRestCall_573666
proc url_VirtualHubsGet_574347(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualHubName" in path, "`virtualHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/virtualHubs/"),
               (kind: VariableSegment, value: "virtualHubName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualHubsGet_574346(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Retrieves the details of a VirtualHub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VirtualHub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualHubName: JString (required)
  ##                 : The name of the VirtualHub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574348 = path.getOrDefault("resourceGroupName")
  valid_574348 = validateParameter(valid_574348, JString, required = true,
                                 default = nil)
  if valid_574348 != nil:
    section.add "resourceGroupName", valid_574348
  var valid_574349 = path.getOrDefault("subscriptionId")
  valid_574349 = validateParameter(valid_574349, JString, required = true,
                                 default = nil)
  if valid_574349 != nil:
    section.add "subscriptionId", valid_574349
  var valid_574350 = path.getOrDefault("virtualHubName")
  valid_574350 = validateParameter(valid_574350, JString, required = true,
                                 default = nil)
  if valid_574350 != nil:
    section.add "virtualHubName", valid_574350
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574351 = query.getOrDefault("api-version")
  valid_574351 = validateParameter(valid_574351, JString, required = true,
                                 default = nil)
  if valid_574351 != nil:
    section.add "api-version", valid_574351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574352: Call_VirtualHubsGet_574345; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a VirtualHub.
  ## 
  let valid = call_574352.validator(path, query, header, formData, body)
  let scheme = call_574352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574352.url(scheme.get, call_574352.host, call_574352.base,
                         call_574352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574352, url, valid)

proc call*(call_574353: Call_VirtualHubsGet_574345; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; virtualHubName: string): Recallable =
  ## virtualHubsGet
  ## Retrieves the details of a VirtualHub.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualHub.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualHubName: string (required)
  ##                 : The name of the VirtualHub.
  var path_574354 = newJObject()
  var query_574355 = newJObject()
  add(path_574354, "resourceGroupName", newJString(resourceGroupName))
  add(query_574355, "api-version", newJString(apiVersion))
  add(path_574354, "subscriptionId", newJString(subscriptionId))
  add(path_574354, "virtualHubName", newJString(virtualHubName))
  result = call_574353.call(path_574354, query_574355, nil, nil, nil)

var virtualHubsGet* = Call_VirtualHubsGet_574345(name: "virtualHubsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}",
    validator: validate_VirtualHubsGet_574346, base: "", url: url_VirtualHubsGet_574347,
    schemes: {Scheme.Https})
type
  Call_VirtualHubsUpdateTags_574380 = ref object of OpenApiRestCall_573666
proc url_VirtualHubsUpdateTags_574382(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualHubName" in path, "`virtualHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/virtualHubs/"),
               (kind: VariableSegment, value: "virtualHubName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualHubsUpdateTags_574381(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates VirtualHub tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VirtualHub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualHubName: JString (required)
  ##                 : The name of the VirtualHub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574383 = path.getOrDefault("resourceGroupName")
  valid_574383 = validateParameter(valid_574383, JString, required = true,
                                 default = nil)
  if valid_574383 != nil:
    section.add "resourceGroupName", valid_574383
  var valid_574384 = path.getOrDefault("subscriptionId")
  valid_574384 = validateParameter(valid_574384, JString, required = true,
                                 default = nil)
  if valid_574384 != nil:
    section.add "subscriptionId", valid_574384
  var valid_574385 = path.getOrDefault("virtualHubName")
  valid_574385 = validateParameter(valid_574385, JString, required = true,
                                 default = nil)
  if valid_574385 != nil:
    section.add "virtualHubName", valid_574385
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574386 = query.getOrDefault("api-version")
  valid_574386 = validateParameter(valid_574386, JString, required = true,
                                 default = nil)
  if valid_574386 != nil:
    section.add "api-version", valid_574386
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   virtualHubParameters: JObject (required)
  ##                       : Parameters supplied to update VirtualHub tags.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574388: Call_VirtualHubsUpdateTags_574380; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates VirtualHub tags.
  ## 
  let valid = call_574388.validator(path, query, header, formData, body)
  let scheme = call_574388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574388.url(scheme.get, call_574388.host, call_574388.base,
                         call_574388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574388, url, valid)

proc call*(call_574389: Call_VirtualHubsUpdateTags_574380;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualHubName: string; virtualHubParameters: JsonNode): Recallable =
  ## virtualHubsUpdateTags
  ## Updates VirtualHub tags.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualHub.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualHubName: string (required)
  ##                 : The name of the VirtualHub.
  ##   virtualHubParameters: JObject (required)
  ##                       : Parameters supplied to update VirtualHub tags.
  var path_574390 = newJObject()
  var query_574391 = newJObject()
  var body_574392 = newJObject()
  add(path_574390, "resourceGroupName", newJString(resourceGroupName))
  add(query_574391, "api-version", newJString(apiVersion))
  add(path_574390, "subscriptionId", newJString(subscriptionId))
  add(path_574390, "virtualHubName", newJString(virtualHubName))
  if virtualHubParameters != nil:
    body_574392 = virtualHubParameters
  result = call_574389.call(path_574390, query_574391, nil, nil, body_574392)

var virtualHubsUpdateTags* = Call_VirtualHubsUpdateTags_574380(
    name: "virtualHubsUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}",
    validator: validate_VirtualHubsUpdateTags_574381, base: "",
    url: url_VirtualHubsUpdateTags_574382, schemes: {Scheme.Https})
type
  Call_VirtualHubsDelete_574369 = ref object of OpenApiRestCall_573666
proc url_VirtualHubsDelete_574371(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualHubName" in path, "`virtualHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/virtualHubs/"),
               (kind: VariableSegment, value: "virtualHubName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualHubsDelete_574370(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes a VirtualHub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VirtualHub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualHubName: JString (required)
  ##                 : The name of the VirtualHub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574372 = path.getOrDefault("resourceGroupName")
  valid_574372 = validateParameter(valid_574372, JString, required = true,
                                 default = nil)
  if valid_574372 != nil:
    section.add "resourceGroupName", valid_574372
  var valid_574373 = path.getOrDefault("subscriptionId")
  valid_574373 = validateParameter(valid_574373, JString, required = true,
                                 default = nil)
  if valid_574373 != nil:
    section.add "subscriptionId", valid_574373
  var valid_574374 = path.getOrDefault("virtualHubName")
  valid_574374 = validateParameter(valid_574374, JString, required = true,
                                 default = nil)
  if valid_574374 != nil:
    section.add "virtualHubName", valid_574374
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574375 = query.getOrDefault("api-version")
  valid_574375 = validateParameter(valid_574375, JString, required = true,
                                 default = nil)
  if valid_574375 != nil:
    section.add "api-version", valid_574375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574376: Call_VirtualHubsDelete_574369; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a VirtualHub.
  ## 
  let valid = call_574376.validator(path, query, header, formData, body)
  let scheme = call_574376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574376.url(scheme.get, call_574376.host, call_574376.base,
                         call_574376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574376, url, valid)

proc call*(call_574377: Call_VirtualHubsDelete_574369; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; virtualHubName: string): Recallable =
  ## virtualHubsDelete
  ## Deletes a VirtualHub.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualHub.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualHubName: string (required)
  ##                 : The name of the VirtualHub.
  var path_574378 = newJObject()
  var query_574379 = newJObject()
  add(path_574378, "resourceGroupName", newJString(resourceGroupName))
  add(query_574379, "api-version", newJString(apiVersion))
  add(path_574378, "subscriptionId", newJString(subscriptionId))
  add(path_574378, "virtualHubName", newJString(virtualHubName))
  result = call_574377.call(path_574378, query_574379, nil, nil, nil)

var virtualHubsDelete* = Call_VirtualHubsDelete_574369(name: "virtualHubsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}",
    validator: validate_VirtualHubsDelete_574370, base: "",
    url: url_VirtualHubsDelete_574371, schemes: {Scheme.Https})
type
  Call_HubVirtualNetworkConnectionsList_574393 = ref object of OpenApiRestCall_573666
proc url_HubVirtualNetworkConnectionsList_574395(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualHubName" in path, "`virtualHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/virtualHubs/"),
               (kind: VariableSegment, value: "virtualHubName"),
               (kind: ConstantSegment, value: "/hubVirtualNetworkConnections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HubVirtualNetworkConnectionsList_574394(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the details of all HubVirtualNetworkConnections.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VirtualHub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualHubName: JString (required)
  ##                 : The name of the VirtualHub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574396 = path.getOrDefault("resourceGroupName")
  valid_574396 = validateParameter(valid_574396, JString, required = true,
                                 default = nil)
  if valid_574396 != nil:
    section.add "resourceGroupName", valid_574396
  var valid_574397 = path.getOrDefault("subscriptionId")
  valid_574397 = validateParameter(valid_574397, JString, required = true,
                                 default = nil)
  if valid_574397 != nil:
    section.add "subscriptionId", valid_574397
  var valid_574398 = path.getOrDefault("virtualHubName")
  valid_574398 = validateParameter(valid_574398, JString, required = true,
                                 default = nil)
  if valid_574398 != nil:
    section.add "virtualHubName", valid_574398
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574399 = query.getOrDefault("api-version")
  valid_574399 = validateParameter(valid_574399, JString, required = true,
                                 default = nil)
  if valid_574399 != nil:
    section.add "api-version", valid_574399
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574400: Call_HubVirtualNetworkConnectionsList_574393;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the details of all HubVirtualNetworkConnections.
  ## 
  let valid = call_574400.validator(path, query, header, formData, body)
  let scheme = call_574400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574400.url(scheme.get, call_574400.host, call_574400.base,
                         call_574400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574400, url, valid)

proc call*(call_574401: Call_HubVirtualNetworkConnectionsList_574393;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualHubName: string): Recallable =
  ## hubVirtualNetworkConnectionsList
  ## Retrieves the details of all HubVirtualNetworkConnections.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualHub.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualHubName: string (required)
  ##                 : The name of the VirtualHub.
  var path_574402 = newJObject()
  var query_574403 = newJObject()
  add(path_574402, "resourceGroupName", newJString(resourceGroupName))
  add(query_574403, "api-version", newJString(apiVersion))
  add(path_574402, "subscriptionId", newJString(subscriptionId))
  add(path_574402, "virtualHubName", newJString(virtualHubName))
  result = call_574401.call(path_574402, query_574403, nil, nil, nil)

var hubVirtualNetworkConnectionsList* = Call_HubVirtualNetworkConnectionsList_574393(
    name: "hubVirtualNetworkConnectionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}/hubVirtualNetworkConnections",
    validator: validate_HubVirtualNetworkConnectionsList_574394, base: "",
    url: url_HubVirtualNetworkConnectionsList_574395, schemes: {Scheme.Https})
type
  Call_HubVirtualNetworkConnectionsGet_574404 = ref object of OpenApiRestCall_573666
proc url_HubVirtualNetworkConnectionsGet_574406(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualHubName" in path, "`virtualHubName` is a required path parameter"
  assert "connectionName" in path, "`connectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/virtualHubs/"),
               (kind: VariableSegment, value: "virtualHubName"), (
        kind: ConstantSegment, value: "/hubVirtualNetworkConnections/"),
               (kind: VariableSegment, value: "connectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HubVirtualNetworkConnectionsGet_574405(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the details of a HubVirtualNetworkConnection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VirtualHub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualHubName: JString (required)
  ##                 : The name of the VirtualHub.
  ##   connectionName: JString (required)
  ##                 : The name of the vpn connection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574407 = path.getOrDefault("resourceGroupName")
  valid_574407 = validateParameter(valid_574407, JString, required = true,
                                 default = nil)
  if valid_574407 != nil:
    section.add "resourceGroupName", valid_574407
  var valid_574408 = path.getOrDefault("subscriptionId")
  valid_574408 = validateParameter(valid_574408, JString, required = true,
                                 default = nil)
  if valid_574408 != nil:
    section.add "subscriptionId", valid_574408
  var valid_574409 = path.getOrDefault("virtualHubName")
  valid_574409 = validateParameter(valid_574409, JString, required = true,
                                 default = nil)
  if valid_574409 != nil:
    section.add "virtualHubName", valid_574409
  var valid_574410 = path.getOrDefault("connectionName")
  valid_574410 = validateParameter(valid_574410, JString, required = true,
                                 default = nil)
  if valid_574410 != nil:
    section.add "connectionName", valid_574410
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574411 = query.getOrDefault("api-version")
  valid_574411 = validateParameter(valid_574411, JString, required = true,
                                 default = nil)
  if valid_574411 != nil:
    section.add "api-version", valid_574411
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574412: Call_HubVirtualNetworkConnectionsGet_574404;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the details of a HubVirtualNetworkConnection.
  ## 
  let valid = call_574412.validator(path, query, header, formData, body)
  let scheme = call_574412.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574412.url(scheme.get, call_574412.host, call_574412.base,
                         call_574412.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574412, url, valid)

proc call*(call_574413: Call_HubVirtualNetworkConnectionsGet_574404;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualHubName: string; connectionName: string): Recallable =
  ## hubVirtualNetworkConnectionsGet
  ## Retrieves the details of a HubVirtualNetworkConnection.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualHub.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualHubName: string (required)
  ##                 : The name of the VirtualHub.
  ##   connectionName: string (required)
  ##                 : The name of the vpn connection.
  var path_574414 = newJObject()
  var query_574415 = newJObject()
  add(path_574414, "resourceGroupName", newJString(resourceGroupName))
  add(query_574415, "api-version", newJString(apiVersion))
  add(path_574414, "subscriptionId", newJString(subscriptionId))
  add(path_574414, "virtualHubName", newJString(virtualHubName))
  add(path_574414, "connectionName", newJString(connectionName))
  result = call_574413.call(path_574414, query_574415, nil, nil, nil)

var hubVirtualNetworkConnectionsGet* = Call_HubVirtualNetworkConnectionsGet_574404(
    name: "hubVirtualNetworkConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}/hubVirtualNetworkConnections/{connectionName}",
    validator: validate_HubVirtualNetworkConnectionsGet_574405, base: "",
    url: url_HubVirtualNetworkConnectionsGet_574406, schemes: {Scheme.Https})
type
  Call_VirtualWansListByResourceGroup_574416 = ref object of OpenApiRestCall_573666
proc url_VirtualWansListByResourceGroup_574418(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/virtualWans")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualWansListByResourceGroup_574417(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the VirtualWANs in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VirtualWan.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574419 = path.getOrDefault("resourceGroupName")
  valid_574419 = validateParameter(valid_574419, JString, required = true,
                                 default = nil)
  if valid_574419 != nil:
    section.add "resourceGroupName", valid_574419
  var valid_574420 = path.getOrDefault("subscriptionId")
  valid_574420 = validateParameter(valid_574420, JString, required = true,
                                 default = nil)
  if valid_574420 != nil:
    section.add "subscriptionId", valid_574420
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574421 = query.getOrDefault("api-version")
  valid_574421 = validateParameter(valid_574421, JString, required = true,
                                 default = nil)
  if valid_574421 != nil:
    section.add "api-version", valid_574421
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574422: Call_VirtualWansListByResourceGroup_574416; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VirtualWANs in a resource group.
  ## 
  let valid = call_574422.validator(path, query, header, formData, body)
  let scheme = call_574422.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574422.url(scheme.get, call_574422.host, call_574422.base,
                         call_574422.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574422, url, valid)

proc call*(call_574423: Call_VirtualWansListByResourceGroup_574416;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualWansListByResourceGroup
  ## Lists all the VirtualWANs in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualWan.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574424 = newJObject()
  var query_574425 = newJObject()
  add(path_574424, "resourceGroupName", newJString(resourceGroupName))
  add(query_574425, "api-version", newJString(apiVersion))
  add(path_574424, "subscriptionId", newJString(subscriptionId))
  result = call_574423.call(path_574424, query_574425, nil, nil, nil)

var virtualWansListByResourceGroup* = Call_VirtualWansListByResourceGroup_574416(
    name: "virtualWansListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans",
    validator: validate_VirtualWansListByResourceGroup_574417, base: "",
    url: url_VirtualWansListByResourceGroup_574418, schemes: {Scheme.Https})
type
  Call_VirtualWansCreateOrUpdate_574437 = ref object of OpenApiRestCall_573666
proc url_VirtualWansCreateOrUpdate_574439(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "VirtualWANName" in path, "`VirtualWANName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/virtualWans/"),
               (kind: VariableSegment, value: "VirtualWANName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualWansCreateOrUpdate_574438(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a VirtualWAN resource if it doesn't exist else updates the existing VirtualWAN.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VirtualWan.
  ##   VirtualWANName: JString (required)
  ##                 : The name of the VirtualWAN being created or updated.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574440 = path.getOrDefault("resourceGroupName")
  valid_574440 = validateParameter(valid_574440, JString, required = true,
                                 default = nil)
  if valid_574440 != nil:
    section.add "resourceGroupName", valid_574440
  var valid_574441 = path.getOrDefault("VirtualWANName")
  valid_574441 = validateParameter(valid_574441, JString, required = true,
                                 default = nil)
  if valid_574441 != nil:
    section.add "VirtualWANName", valid_574441
  var valid_574442 = path.getOrDefault("subscriptionId")
  valid_574442 = validateParameter(valid_574442, JString, required = true,
                                 default = nil)
  if valid_574442 != nil:
    section.add "subscriptionId", valid_574442
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574443 = query.getOrDefault("api-version")
  valid_574443 = validateParameter(valid_574443, JString, required = true,
                                 default = nil)
  if valid_574443 != nil:
    section.add "api-version", valid_574443
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   WANParameters: JObject (required)
  ##                : Parameters supplied to create or update VirtualWAN.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574445: Call_VirtualWansCreateOrUpdate_574437; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a VirtualWAN resource if it doesn't exist else updates the existing VirtualWAN.
  ## 
  let valid = call_574445.validator(path, query, header, formData, body)
  let scheme = call_574445.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574445.url(scheme.get, call_574445.host, call_574445.base,
                         call_574445.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574445, url, valid)

proc call*(call_574446: Call_VirtualWansCreateOrUpdate_574437;
          resourceGroupName: string; VirtualWANName: string; apiVersion: string;
          subscriptionId: string; WANParameters: JsonNode): Recallable =
  ## virtualWansCreateOrUpdate
  ## Creates a VirtualWAN resource if it doesn't exist else updates the existing VirtualWAN.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualWan.
  ##   VirtualWANName: string (required)
  ##                 : The name of the VirtualWAN being created or updated.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   WANParameters: JObject (required)
  ##                : Parameters supplied to create or update VirtualWAN.
  var path_574447 = newJObject()
  var query_574448 = newJObject()
  var body_574449 = newJObject()
  add(path_574447, "resourceGroupName", newJString(resourceGroupName))
  add(path_574447, "VirtualWANName", newJString(VirtualWANName))
  add(query_574448, "api-version", newJString(apiVersion))
  add(path_574447, "subscriptionId", newJString(subscriptionId))
  if WANParameters != nil:
    body_574449 = WANParameters
  result = call_574446.call(path_574447, query_574448, nil, nil, body_574449)

var virtualWansCreateOrUpdate* = Call_VirtualWansCreateOrUpdate_574437(
    name: "virtualWansCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{VirtualWANName}",
    validator: validate_VirtualWansCreateOrUpdate_574438, base: "",
    url: url_VirtualWansCreateOrUpdate_574439, schemes: {Scheme.Https})
type
  Call_VirtualWansGet_574426 = ref object of OpenApiRestCall_573666
proc url_VirtualWansGet_574428(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "VirtualWANName" in path, "`VirtualWANName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/virtualWans/"),
               (kind: VariableSegment, value: "VirtualWANName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualWansGet_574427(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Retrieves the details of a VirtualWAN.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VirtualWan.
  ##   VirtualWANName: JString (required)
  ##                 : The name of the VirtualWAN being retrieved.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574429 = path.getOrDefault("resourceGroupName")
  valid_574429 = validateParameter(valid_574429, JString, required = true,
                                 default = nil)
  if valid_574429 != nil:
    section.add "resourceGroupName", valid_574429
  var valid_574430 = path.getOrDefault("VirtualWANName")
  valid_574430 = validateParameter(valid_574430, JString, required = true,
                                 default = nil)
  if valid_574430 != nil:
    section.add "VirtualWANName", valid_574430
  var valid_574431 = path.getOrDefault("subscriptionId")
  valid_574431 = validateParameter(valid_574431, JString, required = true,
                                 default = nil)
  if valid_574431 != nil:
    section.add "subscriptionId", valid_574431
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574432 = query.getOrDefault("api-version")
  valid_574432 = validateParameter(valid_574432, JString, required = true,
                                 default = nil)
  if valid_574432 != nil:
    section.add "api-version", valid_574432
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574433: Call_VirtualWansGet_574426; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a VirtualWAN.
  ## 
  let valid = call_574433.validator(path, query, header, formData, body)
  let scheme = call_574433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574433.url(scheme.get, call_574433.host, call_574433.base,
                         call_574433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574433, url, valid)

proc call*(call_574434: Call_VirtualWansGet_574426; resourceGroupName: string;
          VirtualWANName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualWansGet
  ## Retrieves the details of a VirtualWAN.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualWan.
  ##   VirtualWANName: string (required)
  ##                 : The name of the VirtualWAN being retrieved.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574435 = newJObject()
  var query_574436 = newJObject()
  add(path_574435, "resourceGroupName", newJString(resourceGroupName))
  add(path_574435, "VirtualWANName", newJString(VirtualWANName))
  add(query_574436, "api-version", newJString(apiVersion))
  add(path_574435, "subscriptionId", newJString(subscriptionId))
  result = call_574434.call(path_574435, query_574436, nil, nil, nil)

var virtualWansGet* = Call_VirtualWansGet_574426(name: "virtualWansGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{VirtualWANName}",
    validator: validate_VirtualWansGet_574427, base: "", url: url_VirtualWansGet_574428,
    schemes: {Scheme.Https})
type
  Call_VirtualWansUpdateTags_574461 = ref object of OpenApiRestCall_573666
proc url_VirtualWansUpdateTags_574463(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "VirtualWANName" in path, "`VirtualWANName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/virtualWans/"),
               (kind: VariableSegment, value: "VirtualWANName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualWansUpdateTags_574462(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a VirtualWAN tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VirtualWan.
  ##   VirtualWANName: JString (required)
  ##                 : The name of the VirtualWAN being updated.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574464 = path.getOrDefault("resourceGroupName")
  valid_574464 = validateParameter(valid_574464, JString, required = true,
                                 default = nil)
  if valid_574464 != nil:
    section.add "resourceGroupName", valid_574464
  var valid_574465 = path.getOrDefault("VirtualWANName")
  valid_574465 = validateParameter(valid_574465, JString, required = true,
                                 default = nil)
  if valid_574465 != nil:
    section.add "VirtualWANName", valid_574465
  var valid_574466 = path.getOrDefault("subscriptionId")
  valid_574466 = validateParameter(valid_574466, JString, required = true,
                                 default = nil)
  if valid_574466 != nil:
    section.add "subscriptionId", valid_574466
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574467 = query.getOrDefault("api-version")
  valid_574467 = validateParameter(valid_574467, JString, required = true,
                                 default = nil)
  if valid_574467 != nil:
    section.add "api-version", valid_574467
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   WANParameters: JObject (required)
  ##                : Parameters supplied to Update VirtualWAN tags.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574469: Call_VirtualWansUpdateTags_574461; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a VirtualWAN tags.
  ## 
  let valid = call_574469.validator(path, query, header, formData, body)
  let scheme = call_574469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574469.url(scheme.get, call_574469.host, call_574469.base,
                         call_574469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574469, url, valid)

proc call*(call_574470: Call_VirtualWansUpdateTags_574461;
          resourceGroupName: string; VirtualWANName: string; apiVersion: string;
          subscriptionId: string; WANParameters: JsonNode): Recallable =
  ## virtualWansUpdateTags
  ## Updates a VirtualWAN tags.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualWan.
  ##   VirtualWANName: string (required)
  ##                 : The name of the VirtualWAN being updated.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   WANParameters: JObject (required)
  ##                : Parameters supplied to Update VirtualWAN tags.
  var path_574471 = newJObject()
  var query_574472 = newJObject()
  var body_574473 = newJObject()
  add(path_574471, "resourceGroupName", newJString(resourceGroupName))
  add(path_574471, "VirtualWANName", newJString(VirtualWANName))
  add(query_574472, "api-version", newJString(apiVersion))
  add(path_574471, "subscriptionId", newJString(subscriptionId))
  if WANParameters != nil:
    body_574473 = WANParameters
  result = call_574470.call(path_574471, query_574472, nil, nil, body_574473)

var virtualWansUpdateTags* = Call_VirtualWansUpdateTags_574461(
    name: "virtualWansUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{VirtualWANName}",
    validator: validate_VirtualWansUpdateTags_574462, base: "",
    url: url_VirtualWansUpdateTags_574463, schemes: {Scheme.Https})
type
  Call_VirtualWansDelete_574450 = ref object of OpenApiRestCall_573666
proc url_VirtualWansDelete_574452(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "VirtualWANName" in path, "`VirtualWANName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/virtualWans/"),
               (kind: VariableSegment, value: "VirtualWANName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualWansDelete_574451(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes a VirtualWAN.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VirtualWan.
  ##   VirtualWANName: JString (required)
  ##                 : The name of the VirtualWAN being deleted.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574453 = path.getOrDefault("resourceGroupName")
  valid_574453 = validateParameter(valid_574453, JString, required = true,
                                 default = nil)
  if valid_574453 != nil:
    section.add "resourceGroupName", valid_574453
  var valid_574454 = path.getOrDefault("VirtualWANName")
  valid_574454 = validateParameter(valid_574454, JString, required = true,
                                 default = nil)
  if valid_574454 != nil:
    section.add "VirtualWANName", valid_574454
  var valid_574455 = path.getOrDefault("subscriptionId")
  valid_574455 = validateParameter(valid_574455, JString, required = true,
                                 default = nil)
  if valid_574455 != nil:
    section.add "subscriptionId", valid_574455
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574456 = query.getOrDefault("api-version")
  valid_574456 = validateParameter(valid_574456, JString, required = true,
                                 default = nil)
  if valid_574456 != nil:
    section.add "api-version", valid_574456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574457: Call_VirtualWansDelete_574450; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a VirtualWAN.
  ## 
  let valid = call_574457.validator(path, query, header, formData, body)
  let scheme = call_574457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574457.url(scheme.get, call_574457.host, call_574457.base,
                         call_574457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574457, url, valid)

proc call*(call_574458: Call_VirtualWansDelete_574450; resourceGroupName: string;
          VirtualWANName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualWansDelete
  ## Deletes a VirtualWAN.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualWan.
  ##   VirtualWANName: string (required)
  ##                 : The name of the VirtualWAN being deleted.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574459 = newJObject()
  var query_574460 = newJObject()
  add(path_574459, "resourceGroupName", newJString(resourceGroupName))
  add(path_574459, "VirtualWANName", newJString(VirtualWANName))
  add(query_574460, "api-version", newJString(apiVersion))
  add(path_574459, "subscriptionId", newJString(subscriptionId))
  result = call_574458.call(path_574459, query_574460, nil, nil, nil)

var virtualWansDelete* = Call_VirtualWansDelete_574450(name: "virtualWansDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{VirtualWANName}",
    validator: validate_VirtualWansDelete_574451, base: "",
    url: url_VirtualWansDelete_574452, schemes: {Scheme.Https})
type
  Call_SupportedSecurityProviders_574474 = ref object of OpenApiRestCall_573666
proc url_SupportedSecurityProviders_574476(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualWANName" in path, "`virtualWANName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/virtualWans/"),
               (kind: VariableSegment, value: "virtualWANName"),
               (kind: ConstantSegment, value: "/supportedSecurityProviders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SupportedSecurityProviders_574475(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gives the supported security providers for the virtual wan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualWANName: JString (required)
  ##                 : The name of the VirtualWAN for which supported security providers are needed.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574477 = path.getOrDefault("resourceGroupName")
  valid_574477 = validateParameter(valid_574477, JString, required = true,
                                 default = nil)
  if valid_574477 != nil:
    section.add "resourceGroupName", valid_574477
  var valid_574478 = path.getOrDefault("subscriptionId")
  valid_574478 = validateParameter(valid_574478, JString, required = true,
                                 default = nil)
  if valid_574478 != nil:
    section.add "subscriptionId", valid_574478
  var valid_574479 = path.getOrDefault("virtualWANName")
  valid_574479 = validateParameter(valid_574479, JString, required = true,
                                 default = nil)
  if valid_574479 != nil:
    section.add "virtualWANName", valid_574479
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574480 = query.getOrDefault("api-version")
  valid_574480 = validateParameter(valid_574480, JString, required = true,
                                 default = nil)
  if valid_574480 != nil:
    section.add "api-version", valid_574480
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574481: Call_SupportedSecurityProviders_574474; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gives the supported security providers for the virtual wan.
  ## 
  let valid = call_574481.validator(path, query, header, formData, body)
  let scheme = call_574481.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574481.url(scheme.get, call_574481.host, call_574481.base,
                         call_574481.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574481, url, valid)

proc call*(call_574482: Call_SupportedSecurityProviders_574474;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualWANName: string): Recallable =
  ## supportedSecurityProviders
  ## Gives the supported security providers for the virtual wan.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualWANName: string (required)
  ##                 : The name of the VirtualWAN for which supported security providers are needed.
  var path_574483 = newJObject()
  var query_574484 = newJObject()
  add(path_574483, "resourceGroupName", newJString(resourceGroupName))
  add(query_574484, "api-version", newJString(apiVersion))
  add(path_574483, "subscriptionId", newJString(subscriptionId))
  add(path_574483, "virtualWANName", newJString(virtualWANName))
  result = call_574482.call(path_574483, query_574484, nil, nil, nil)

var supportedSecurityProviders* = Call_SupportedSecurityProviders_574474(
    name: "supportedSecurityProviders", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{virtualWANName}/supportedSecurityProviders",
    validator: validate_SupportedSecurityProviders_574475, base: "",
    url: url_SupportedSecurityProviders_574476, schemes: {Scheme.Https})
type
  Call_VpnSitesConfigurationDownload_574485 = ref object of OpenApiRestCall_573666
proc url_VpnSitesConfigurationDownload_574487(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualWANName" in path, "`virtualWANName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/virtualWans/"),
               (kind: VariableSegment, value: "virtualWANName"),
               (kind: ConstantSegment, value: "/vpnConfiguration")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VpnSitesConfigurationDownload_574486(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gives the sas-url to download the configurations for vpn-sites in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualWANName: JString (required)
  ##                 : The name of the VirtualWAN for which configuration of all vpn-sites is needed.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574488 = path.getOrDefault("resourceGroupName")
  valid_574488 = validateParameter(valid_574488, JString, required = true,
                                 default = nil)
  if valid_574488 != nil:
    section.add "resourceGroupName", valid_574488
  var valid_574489 = path.getOrDefault("subscriptionId")
  valid_574489 = validateParameter(valid_574489, JString, required = true,
                                 default = nil)
  if valid_574489 != nil:
    section.add "subscriptionId", valid_574489
  var valid_574490 = path.getOrDefault("virtualWANName")
  valid_574490 = validateParameter(valid_574490, JString, required = true,
                                 default = nil)
  if valid_574490 != nil:
    section.add "virtualWANName", valid_574490
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574491 = query.getOrDefault("api-version")
  valid_574491 = validateParameter(valid_574491, JString, required = true,
                                 default = nil)
  if valid_574491 != nil:
    section.add "api-version", valid_574491
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   request: JObject (required)
  ##          : Parameters supplied to download vpn-sites configuration.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574493: Call_VpnSitesConfigurationDownload_574485; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gives the sas-url to download the configurations for vpn-sites in a resource group.
  ## 
  let valid = call_574493.validator(path, query, header, formData, body)
  let scheme = call_574493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574493.url(scheme.get, call_574493.host, call_574493.base,
                         call_574493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574493, url, valid)

proc call*(call_574494: Call_VpnSitesConfigurationDownload_574485;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          request: JsonNode; virtualWANName: string): Recallable =
  ## vpnSitesConfigurationDownload
  ## Gives the sas-url to download the configurations for vpn-sites in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   request: JObject (required)
  ##          : Parameters supplied to download vpn-sites configuration.
  ##   virtualWANName: string (required)
  ##                 : The name of the VirtualWAN for which configuration of all vpn-sites is needed.
  var path_574495 = newJObject()
  var query_574496 = newJObject()
  var body_574497 = newJObject()
  add(path_574495, "resourceGroupName", newJString(resourceGroupName))
  add(query_574496, "api-version", newJString(apiVersion))
  add(path_574495, "subscriptionId", newJString(subscriptionId))
  if request != nil:
    body_574497 = request
  add(path_574495, "virtualWANName", newJString(virtualWANName))
  result = call_574494.call(path_574495, query_574496, nil, nil, body_574497)

var vpnSitesConfigurationDownload* = Call_VpnSitesConfigurationDownload_574485(
    name: "vpnSitesConfigurationDownload", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{virtualWANName}/vpnConfiguration",
    validator: validate_VpnSitesConfigurationDownload_574486, base: "",
    url: url_VpnSitesConfigurationDownload_574487, schemes: {Scheme.Https})
type
  Call_P2sVpnServerConfigurationsListByVirtualWan_574498 = ref object of OpenApiRestCall_573666
proc url_P2sVpnServerConfigurationsListByVirtualWan_574500(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualWanName" in path, "`virtualWanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/virtualWans/"),
               (kind: VariableSegment, value: "virtualWanName"),
               (kind: ConstantSegment, value: "/p2sVpnServerConfigurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_P2sVpnServerConfigurationsListByVirtualWan_574499(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all P2SVpnServerConfigurations for a particular VirtualWan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VirtualWan.
  ##   virtualWanName: JString (required)
  ##                 : The name of the VirtualWan.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574501 = path.getOrDefault("resourceGroupName")
  valid_574501 = validateParameter(valid_574501, JString, required = true,
                                 default = nil)
  if valid_574501 != nil:
    section.add "resourceGroupName", valid_574501
  var valid_574502 = path.getOrDefault("virtualWanName")
  valid_574502 = validateParameter(valid_574502, JString, required = true,
                                 default = nil)
  if valid_574502 != nil:
    section.add "virtualWanName", valid_574502
  var valid_574503 = path.getOrDefault("subscriptionId")
  valid_574503 = validateParameter(valid_574503, JString, required = true,
                                 default = nil)
  if valid_574503 != nil:
    section.add "subscriptionId", valid_574503
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574504 = query.getOrDefault("api-version")
  valid_574504 = validateParameter(valid_574504, JString, required = true,
                                 default = nil)
  if valid_574504 != nil:
    section.add "api-version", valid_574504
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574505: Call_P2sVpnServerConfigurationsListByVirtualWan_574498;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all P2SVpnServerConfigurations for a particular VirtualWan.
  ## 
  let valid = call_574505.validator(path, query, header, formData, body)
  let scheme = call_574505.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574505.url(scheme.get, call_574505.host, call_574505.base,
                         call_574505.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574505, url, valid)

proc call*(call_574506: Call_P2sVpnServerConfigurationsListByVirtualWan_574498;
          resourceGroupName: string; apiVersion: string; virtualWanName: string;
          subscriptionId: string): Recallable =
  ## p2sVpnServerConfigurationsListByVirtualWan
  ## Retrieves all P2SVpnServerConfigurations for a particular VirtualWan.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualWan.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualWanName: string (required)
  ##                 : The name of the VirtualWan.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574507 = newJObject()
  var query_574508 = newJObject()
  add(path_574507, "resourceGroupName", newJString(resourceGroupName))
  add(query_574508, "api-version", newJString(apiVersion))
  add(path_574507, "virtualWanName", newJString(virtualWanName))
  add(path_574507, "subscriptionId", newJString(subscriptionId))
  result = call_574506.call(path_574507, query_574508, nil, nil, nil)

var p2sVpnServerConfigurationsListByVirtualWan* = Call_P2sVpnServerConfigurationsListByVirtualWan_574498(
    name: "p2sVpnServerConfigurationsListByVirtualWan", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{virtualWanName}/p2sVpnServerConfigurations",
    validator: validate_P2sVpnServerConfigurationsListByVirtualWan_574499,
    base: "", url: url_P2sVpnServerConfigurationsListByVirtualWan_574500,
    schemes: {Scheme.Https})
type
  Call_P2sVpnServerConfigurationsCreateOrUpdate_574521 = ref object of OpenApiRestCall_573666
proc url_P2sVpnServerConfigurationsCreateOrUpdate_574523(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualWanName" in path, "`virtualWanName` is a required path parameter"
  assert "p2SVpnServerConfigurationName" in path,
        "`p2SVpnServerConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/virtualWans/"),
               (kind: VariableSegment, value: "virtualWanName"),
               (kind: ConstantSegment, value: "/p2sVpnServerConfigurations/"),
               (kind: VariableSegment, value: "p2SVpnServerConfigurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_P2sVpnServerConfigurationsCreateOrUpdate_574522(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a P2SVpnServerConfiguration to associate with a VirtualWan if it doesn't exist else updates the existing P2SVpnServerConfiguration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VirtualWan.
  ##   virtualWanName: JString (required)
  ##                 : The name of the VirtualWan.
  ##   p2SVpnServerConfigurationName: JString (required)
  ##                                : The name of the P2SVpnServerConfiguration.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574524 = path.getOrDefault("resourceGroupName")
  valid_574524 = validateParameter(valid_574524, JString, required = true,
                                 default = nil)
  if valid_574524 != nil:
    section.add "resourceGroupName", valid_574524
  var valid_574525 = path.getOrDefault("virtualWanName")
  valid_574525 = validateParameter(valid_574525, JString, required = true,
                                 default = nil)
  if valid_574525 != nil:
    section.add "virtualWanName", valid_574525
  var valid_574526 = path.getOrDefault("p2SVpnServerConfigurationName")
  valid_574526 = validateParameter(valid_574526, JString, required = true,
                                 default = nil)
  if valid_574526 != nil:
    section.add "p2SVpnServerConfigurationName", valid_574526
  var valid_574527 = path.getOrDefault("subscriptionId")
  valid_574527 = validateParameter(valid_574527, JString, required = true,
                                 default = nil)
  if valid_574527 != nil:
    section.add "subscriptionId", valid_574527
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574528 = query.getOrDefault("api-version")
  valid_574528 = validateParameter(valid_574528, JString, required = true,
                                 default = nil)
  if valid_574528 != nil:
    section.add "api-version", valid_574528
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   p2SVpnServerConfigurationParameters: JObject (required)
  ##                                      : Parameters supplied to create or Update a P2SVpnServerConfiguration.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574530: Call_P2sVpnServerConfigurationsCreateOrUpdate_574521;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a P2SVpnServerConfiguration to associate with a VirtualWan if it doesn't exist else updates the existing P2SVpnServerConfiguration.
  ## 
  let valid = call_574530.validator(path, query, header, formData, body)
  let scheme = call_574530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574530.url(scheme.get, call_574530.host, call_574530.base,
                         call_574530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574530, url, valid)

proc call*(call_574531: Call_P2sVpnServerConfigurationsCreateOrUpdate_574521;
          resourceGroupName: string; apiVersion: string; virtualWanName: string;
          p2SVpnServerConfigurationName: string; subscriptionId: string;
          p2SVpnServerConfigurationParameters: JsonNode): Recallable =
  ## p2sVpnServerConfigurationsCreateOrUpdate
  ## Creates a P2SVpnServerConfiguration to associate with a VirtualWan if it doesn't exist else updates the existing P2SVpnServerConfiguration.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualWan.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualWanName: string (required)
  ##                 : The name of the VirtualWan.
  ##   p2SVpnServerConfigurationName: string (required)
  ##                                : The name of the P2SVpnServerConfiguration.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   p2SVpnServerConfigurationParameters: JObject (required)
  ##                                      : Parameters supplied to create or Update a P2SVpnServerConfiguration.
  var path_574532 = newJObject()
  var query_574533 = newJObject()
  var body_574534 = newJObject()
  add(path_574532, "resourceGroupName", newJString(resourceGroupName))
  add(query_574533, "api-version", newJString(apiVersion))
  add(path_574532, "virtualWanName", newJString(virtualWanName))
  add(path_574532, "p2SVpnServerConfigurationName",
      newJString(p2SVpnServerConfigurationName))
  add(path_574532, "subscriptionId", newJString(subscriptionId))
  if p2SVpnServerConfigurationParameters != nil:
    body_574534 = p2SVpnServerConfigurationParameters
  result = call_574531.call(path_574532, query_574533, nil, nil, body_574534)

var p2sVpnServerConfigurationsCreateOrUpdate* = Call_P2sVpnServerConfigurationsCreateOrUpdate_574521(
    name: "p2sVpnServerConfigurationsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{virtualWanName}/p2sVpnServerConfigurations/{p2SVpnServerConfigurationName}",
    validator: validate_P2sVpnServerConfigurationsCreateOrUpdate_574522, base: "",
    url: url_P2sVpnServerConfigurationsCreateOrUpdate_574523,
    schemes: {Scheme.Https})
type
  Call_P2sVpnServerConfigurationsGet_574509 = ref object of OpenApiRestCall_573666
proc url_P2sVpnServerConfigurationsGet_574511(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualWanName" in path, "`virtualWanName` is a required path parameter"
  assert "p2SVpnServerConfigurationName" in path,
        "`p2SVpnServerConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/virtualWans/"),
               (kind: VariableSegment, value: "virtualWanName"),
               (kind: ConstantSegment, value: "/p2sVpnServerConfigurations/"),
               (kind: VariableSegment, value: "p2SVpnServerConfigurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_P2sVpnServerConfigurationsGet_574510(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the details of a P2SVpnServerConfiguration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the P2SVpnServerConfiguration.
  ##   virtualWanName: JString (required)
  ##                 : The name of the VirtualWan.
  ##   p2SVpnServerConfigurationName: JString (required)
  ##                                : The name of the P2SVpnServerConfiguration.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574512 = path.getOrDefault("resourceGroupName")
  valid_574512 = validateParameter(valid_574512, JString, required = true,
                                 default = nil)
  if valid_574512 != nil:
    section.add "resourceGroupName", valid_574512
  var valid_574513 = path.getOrDefault("virtualWanName")
  valid_574513 = validateParameter(valid_574513, JString, required = true,
                                 default = nil)
  if valid_574513 != nil:
    section.add "virtualWanName", valid_574513
  var valid_574514 = path.getOrDefault("p2SVpnServerConfigurationName")
  valid_574514 = validateParameter(valid_574514, JString, required = true,
                                 default = nil)
  if valid_574514 != nil:
    section.add "p2SVpnServerConfigurationName", valid_574514
  var valid_574515 = path.getOrDefault("subscriptionId")
  valid_574515 = validateParameter(valid_574515, JString, required = true,
                                 default = nil)
  if valid_574515 != nil:
    section.add "subscriptionId", valid_574515
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574516 = query.getOrDefault("api-version")
  valid_574516 = validateParameter(valid_574516, JString, required = true,
                                 default = nil)
  if valid_574516 != nil:
    section.add "api-version", valid_574516
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574517: Call_P2sVpnServerConfigurationsGet_574509; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a P2SVpnServerConfiguration.
  ## 
  let valid = call_574517.validator(path, query, header, formData, body)
  let scheme = call_574517.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574517.url(scheme.get, call_574517.host, call_574517.base,
                         call_574517.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574517, url, valid)

proc call*(call_574518: Call_P2sVpnServerConfigurationsGet_574509;
          resourceGroupName: string; apiVersion: string; virtualWanName: string;
          p2SVpnServerConfigurationName: string; subscriptionId: string): Recallable =
  ## p2sVpnServerConfigurationsGet
  ## Retrieves the details of a P2SVpnServerConfiguration.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the P2SVpnServerConfiguration.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualWanName: string (required)
  ##                 : The name of the VirtualWan.
  ##   p2SVpnServerConfigurationName: string (required)
  ##                                : The name of the P2SVpnServerConfiguration.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574519 = newJObject()
  var query_574520 = newJObject()
  add(path_574519, "resourceGroupName", newJString(resourceGroupName))
  add(query_574520, "api-version", newJString(apiVersion))
  add(path_574519, "virtualWanName", newJString(virtualWanName))
  add(path_574519, "p2SVpnServerConfigurationName",
      newJString(p2SVpnServerConfigurationName))
  add(path_574519, "subscriptionId", newJString(subscriptionId))
  result = call_574518.call(path_574519, query_574520, nil, nil, nil)

var p2sVpnServerConfigurationsGet* = Call_P2sVpnServerConfigurationsGet_574509(
    name: "p2sVpnServerConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{virtualWanName}/p2sVpnServerConfigurations/{p2SVpnServerConfigurationName}",
    validator: validate_P2sVpnServerConfigurationsGet_574510, base: "",
    url: url_P2sVpnServerConfigurationsGet_574511, schemes: {Scheme.Https})
type
  Call_P2sVpnServerConfigurationsDelete_574535 = ref object of OpenApiRestCall_573666
proc url_P2sVpnServerConfigurationsDelete_574537(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualWanName" in path, "`virtualWanName` is a required path parameter"
  assert "p2SVpnServerConfigurationName" in path,
        "`p2SVpnServerConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/virtualWans/"),
               (kind: VariableSegment, value: "virtualWanName"),
               (kind: ConstantSegment, value: "/p2sVpnServerConfigurations/"),
               (kind: VariableSegment, value: "p2SVpnServerConfigurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_P2sVpnServerConfigurationsDelete_574536(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a P2SVpnServerConfiguration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the P2SVpnServerConfiguration.
  ##   virtualWanName: JString (required)
  ##                 : The name of the VirtualWan.
  ##   p2SVpnServerConfigurationName: JString (required)
  ##                                : The name of the P2SVpnServerConfiguration.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574538 = path.getOrDefault("resourceGroupName")
  valid_574538 = validateParameter(valid_574538, JString, required = true,
                                 default = nil)
  if valid_574538 != nil:
    section.add "resourceGroupName", valid_574538
  var valid_574539 = path.getOrDefault("virtualWanName")
  valid_574539 = validateParameter(valid_574539, JString, required = true,
                                 default = nil)
  if valid_574539 != nil:
    section.add "virtualWanName", valid_574539
  var valid_574540 = path.getOrDefault("p2SVpnServerConfigurationName")
  valid_574540 = validateParameter(valid_574540, JString, required = true,
                                 default = nil)
  if valid_574540 != nil:
    section.add "p2SVpnServerConfigurationName", valid_574540
  var valid_574541 = path.getOrDefault("subscriptionId")
  valid_574541 = validateParameter(valid_574541, JString, required = true,
                                 default = nil)
  if valid_574541 != nil:
    section.add "subscriptionId", valid_574541
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574542 = query.getOrDefault("api-version")
  valid_574542 = validateParameter(valid_574542, JString, required = true,
                                 default = nil)
  if valid_574542 != nil:
    section.add "api-version", valid_574542
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574543: Call_P2sVpnServerConfigurationsDelete_574535;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a P2SVpnServerConfiguration.
  ## 
  let valid = call_574543.validator(path, query, header, formData, body)
  let scheme = call_574543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574543.url(scheme.get, call_574543.host, call_574543.base,
                         call_574543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574543, url, valid)

proc call*(call_574544: Call_P2sVpnServerConfigurationsDelete_574535;
          resourceGroupName: string; apiVersion: string; virtualWanName: string;
          p2SVpnServerConfigurationName: string; subscriptionId: string): Recallable =
  ## p2sVpnServerConfigurationsDelete
  ## Deletes a P2SVpnServerConfiguration.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the P2SVpnServerConfiguration.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualWanName: string (required)
  ##                 : The name of the VirtualWan.
  ##   p2SVpnServerConfigurationName: string (required)
  ##                                : The name of the P2SVpnServerConfiguration.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574545 = newJObject()
  var query_574546 = newJObject()
  add(path_574545, "resourceGroupName", newJString(resourceGroupName))
  add(query_574546, "api-version", newJString(apiVersion))
  add(path_574545, "virtualWanName", newJString(virtualWanName))
  add(path_574545, "p2SVpnServerConfigurationName",
      newJString(p2SVpnServerConfigurationName))
  add(path_574545, "subscriptionId", newJString(subscriptionId))
  result = call_574544.call(path_574545, query_574546, nil, nil, nil)

var p2sVpnServerConfigurationsDelete* = Call_P2sVpnServerConfigurationsDelete_574535(
    name: "p2sVpnServerConfigurationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{virtualWanName}/p2sVpnServerConfigurations/{p2SVpnServerConfigurationName}",
    validator: validate_P2sVpnServerConfigurationsDelete_574536, base: "",
    url: url_P2sVpnServerConfigurationsDelete_574537, schemes: {Scheme.Https})
type
  Call_VpnGatewaysListByResourceGroup_574547 = ref object of OpenApiRestCall_573666
proc url_VpnGatewaysListByResourceGroup_574549(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/vpnGateways")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VpnGatewaysListByResourceGroup_574548(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the VpnGateways in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnGateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574550 = path.getOrDefault("resourceGroupName")
  valid_574550 = validateParameter(valid_574550, JString, required = true,
                                 default = nil)
  if valid_574550 != nil:
    section.add "resourceGroupName", valid_574550
  var valid_574551 = path.getOrDefault("subscriptionId")
  valid_574551 = validateParameter(valid_574551, JString, required = true,
                                 default = nil)
  if valid_574551 != nil:
    section.add "subscriptionId", valid_574551
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574552 = query.getOrDefault("api-version")
  valid_574552 = validateParameter(valid_574552, JString, required = true,
                                 default = nil)
  if valid_574552 != nil:
    section.add "api-version", valid_574552
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574553: Call_VpnGatewaysListByResourceGroup_574547; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VpnGateways in a resource group.
  ## 
  let valid = call_574553.validator(path, query, header, formData, body)
  let scheme = call_574553.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574553.url(scheme.get, call_574553.host, call_574553.base,
                         call_574553.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574553, url, valid)

proc call*(call_574554: Call_VpnGatewaysListByResourceGroup_574547;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## vpnGatewaysListByResourceGroup
  ## Lists all the VpnGateways in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnGateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574555 = newJObject()
  var query_574556 = newJObject()
  add(path_574555, "resourceGroupName", newJString(resourceGroupName))
  add(query_574556, "api-version", newJString(apiVersion))
  add(path_574555, "subscriptionId", newJString(subscriptionId))
  result = call_574554.call(path_574555, query_574556, nil, nil, nil)

var vpnGatewaysListByResourceGroup* = Call_VpnGatewaysListByResourceGroup_574547(
    name: "vpnGatewaysListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways",
    validator: validate_VpnGatewaysListByResourceGroup_574548, base: "",
    url: url_VpnGatewaysListByResourceGroup_574549, schemes: {Scheme.Https})
type
  Call_VpnGatewaysCreateOrUpdate_574568 = ref object of OpenApiRestCall_573666
proc url_VpnGatewaysCreateOrUpdate_574570(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "gatewayName" in path, "`gatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/vpnGateways/"),
               (kind: VariableSegment, value: "gatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VpnGatewaysCreateOrUpdate_574569(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a virtual wan vpn gateway if it doesn't exist else updates the existing gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnGateway.
  ##   gatewayName: JString (required)
  ##              : The name of the gateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574571 = path.getOrDefault("resourceGroupName")
  valid_574571 = validateParameter(valid_574571, JString, required = true,
                                 default = nil)
  if valid_574571 != nil:
    section.add "resourceGroupName", valid_574571
  var valid_574572 = path.getOrDefault("gatewayName")
  valid_574572 = validateParameter(valid_574572, JString, required = true,
                                 default = nil)
  if valid_574572 != nil:
    section.add "gatewayName", valid_574572
  var valid_574573 = path.getOrDefault("subscriptionId")
  valid_574573 = validateParameter(valid_574573, JString, required = true,
                                 default = nil)
  if valid_574573 != nil:
    section.add "subscriptionId", valid_574573
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574574 = query.getOrDefault("api-version")
  valid_574574 = validateParameter(valid_574574, JString, required = true,
                                 default = nil)
  if valid_574574 != nil:
    section.add "api-version", valid_574574
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   vpnGatewayParameters: JObject (required)
  ##                       : Parameters supplied to create or Update a virtual wan vpn gateway.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574576: Call_VpnGatewaysCreateOrUpdate_574568; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a virtual wan vpn gateway if it doesn't exist else updates the existing gateway.
  ## 
  let valid = call_574576.validator(path, query, header, formData, body)
  let scheme = call_574576.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574576.url(scheme.get, call_574576.host, call_574576.base,
                         call_574576.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574576, url, valid)

proc call*(call_574577: Call_VpnGatewaysCreateOrUpdate_574568;
          resourceGroupName: string; apiVersion: string; gatewayName: string;
          subscriptionId: string; vpnGatewayParameters: JsonNode): Recallable =
  ## vpnGatewaysCreateOrUpdate
  ## Creates a virtual wan vpn gateway if it doesn't exist else updates the existing gateway.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnGateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   gatewayName: string (required)
  ##              : The name of the gateway.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vpnGatewayParameters: JObject (required)
  ##                       : Parameters supplied to create or Update a virtual wan vpn gateway.
  var path_574578 = newJObject()
  var query_574579 = newJObject()
  var body_574580 = newJObject()
  add(path_574578, "resourceGroupName", newJString(resourceGroupName))
  add(query_574579, "api-version", newJString(apiVersion))
  add(path_574578, "gatewayName", newJString(gatewayName))
  add(path_574578, "subscriptionId", newJString(subscriptionId))
  if vpnGatewayParameters != nil:
    body_574580 = vpnGatewayParameters
  result = call_574577.call(path_574578, query_574579, nil, nil, body_574580)

var vpnGatewaysCreateOrUpdate* = Call_VpnGatewaysCreateOrUpdate_574568(
    name: "vpnGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}",
    validator: validate_VpnGatewaysCreateOrUpdate_574569, base: "",
    url: url_VpnGatewaysCreateOrUpdate_574570, schemes: {Scheme.Https})
type
  Call_VpnGatewaysGet_574557 = ref object of OpenApiRestCall_573666
proc url_VpnGatewaysGet_574559(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "gatewayName" in path, "`gatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/vpnGateways/"),
               (kind: VariableSegment, value: "gatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VpnGatewaysGet_574558(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Retrieves the details of a virtual wan vpn gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnGateway.
  ##   gatewayName: JString (required)
  ##              : The name of the gateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574560 = path.getOrDefault("resourceGroupName")
  valid_574560 = validateParameter(valid_574560, JString, required = true,
                                 default = nil)
  if valid_574560 != nil:
    section.add "resourceGroupName", valid_574560
  var valid_574561 = path.getOrDefault("gatewayName")
  valid_574561 = validateParameter(valid_574561, JString, required = true,
                                 default = nil)
  if valid_574561 != nil:
    section.add "gatewayName", valid_574561
  var valid_574562 = path.getOrDefault("subscriptionId")
  valid_574562 = validateParameter(valid_574562, JString, required = true,
                                 default = nil)
  if valid_574562 != nil:
    section.add "subscriptionId", valid_574562
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574563 = query.getOrDefault("api-version")
  valid_574563 = validateParameter(valid_574563, JString, required = true,
                                 default = nil)
  if valid_574563 != nil:
    section.add "api-version", valid_574563
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574564: Call_VpnGatewaysGet_574557; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a virtual wan vpn gateway.
  ## 
  let valid = call_574564.validator(path, query, header, formData, body)
  let scheme = call_574564.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574564.url(scheme.get, call_574564.host, call_574564.base,
                         call_574564.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574564, url, valid)

proc call*(call_574565: Call_VpnGatewaysGet_574557; resourceGroupName: string;
          apiVersion: string; gatewayName: string; subscriptionId: string): Recallable =
  ## vpnGatewaysGet
  ## Retrieves the details of a virtual wan vpn gateway.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnGateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   gatewayName: string (required)
  ##              : The name of the gateway.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574566 = newJObject()
  var query_574567 = newJObject()
  add(path_574566, "resourceGroupName", newJString(resourceGroupName))
  add(query_574567, "api-version", newJString(apiVersion))
  add(path_574566, "gatewayName", newJString(gatewayName))
  add(path_574566, "subscriptionId", newJString(subscriptionId))
  result = call_574565.call(path_574566, query_574567, nil, nil, nil)

var vpnGatewaysGet* = Call_VpnGatewaysGet_574557(name: "vpnGatewaysGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}",
    validator: validate_VpnGatewaysGet_574558, base: "", url: url_VpnGatewaysGet_574559,
    schemes: {Scheme.Https})
type
  Call_VpnGatewaysUpdateTags_574592 = ref object of OpenApiRestCall_573666
proc url_VpnGatewaysUpdateTags_574594(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "gatewayName" in path, "`gatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/vpnGateways/"),
               (kind: VariableSegment, value: "gatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VpnGatewaysUpdateTags_574593(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates virtual wan vpn gateway tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnGateway.
  ##   gatewayName: JString (required)
  ##              : The name of the gateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574595 = path.getOrDefault("resourceGroupName")
  valid_574595 = validateParameter(valid_574595, JString, required = true,
                                 default = nil)
  if valid_574595 != nil:
    section.add "resourceGroupName", valid_574595
  var valid_574596 = path.getOrDefault("gatewayName")
  valid_574596 = validateParameter(valid_574596, JString, required = true,
                                 default = nil)
  if valid_574596 != nil:
    section.add "gatewayName", valid_574596
  var valid_574597 = path.getOrDefault("subscriptionId")
  valid_574597 = validateParameter(valid_574597, JString, required = true,
                                 default = nil)
  if valid_574597 != nil:
    section.add "subscriptionId", valid_574597
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574598 = query.getOrDefault("api-version")
  valid_574598 = validateParameter(valid_574598, JString, required = true,
                                 default = nil)
  if valid_574598 != nil:
    section.add "api-version", valid_574598
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   vpnGatewayParameters: JObject (required)
  ##                       : Parameters supplied to update a virtual wan vpn gateway tags.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574600: Call_VpnGatewaysUpdateTags_574592; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates virtual wan vpn gateway tags.
  ## 
  let valid = call_574600.validator(path, query, header, formData, body)
  let scheme = call_574600.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574600.url(scheme.get, call_574600.host, call_574600.base,
                         call_574600.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574600, url, valid)

proc call*(call_574601: Call_VpnGatewaysUpdateTags_574592;
          resourceGroupName: string; apiVersion: string; gatewayName: string;
          subscriptionId: string; vpnGatewayParameters: JsonNode): Recallable =
  ## vpnGatewaysUpdateTags
  ## Updates virtual wan vpn gateway tags.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnGateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   gatewayName: string (required)
  ##              : The name of the gateway.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vpnGatewayParameters: JObject (required)
  ##                       : Parameters supplied to update a virtual wan vpn gateway tags.
  var path_574602 = newJObject()
  var query_574603 = newJObject()
  var body_574604 = newJObject()
  add(path_574602, "resourceGroupName", newJString(resourceGroupName))
  add(query_574603, "api-version", newJString(apiVersion))
  add(path_574602, "gatewayName", newJString(gatewayName))
  add(path_574602, "subscriptionId", newJString(subscriptionId))
  if vpnGatewayParameters != nil:
    body_574604 = vpnGatewayParameters
  result = call_574601.call(path_574602, query_574603, nil, nil, body_574604)

var vpnGatewaysUpdateTags* = Call_VpnGatewaysUpdateTags_574592(
    name: "vpnGatewaysUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}",
    validator: validate_VpnGatewaysUpdateTags_574593, base: "",
    url: url_VpnGatewaysUpdateTags_574594, schemes: {Scheme.Https})
type
  Call_VpnGatewaysDelete_574581 = ref object of OpenApiRestCall_573666
proc url_VpnGatewaysDelete_574583(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "gatewayName" in path, "`gatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/vpnGateways/"),
               (kind: VariableSegment, value: "gatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VpnGatewaysDelete_574582(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes a virtual wan vpn gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnGateway.
  ##   gatewayName: JString (required)
  ##              : The name of the gateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574584 = path.getOrDefault("resourceGroupName")
  valid_574584 = validateParameter(valid_574584, JString, required = true,
                                 default = nil)
  if valid_574584 != nil:
    section.add "resourceGroupName", valid_574584
  var valid_574585 = path.getOrDefault("gatewayName")
  valid_574585 = validateParameter(valid_574585, JString, required = true,
                                 default = nil)
  if valid_574585 != nil:
    section.add "gatewayName", valid_574585
  var valid_574586 = path.getOrDefault("subscriptionId")
  valid_574586 = validateParameter(valid_574586, JString, required = true,
                                 default = nil)
  if valid_574586 != nil:
    section.add "subscriptionId", valid_574586
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574587 = query.getOrDefault("api-version")
  valid_574587 = validateParameter(valid_574587, JString, required = true,
                                 default = nil)
  if valid_574587 != nil:
    section.add "api-version", valid_574587
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574588: Call_VpnGatewaysDelete_574581; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a virtual wan vpn gateway.
  ## 
  let valid = call_574588.validator(path, query, header, formData, body)
  let scheme = call_574588.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574588.url(scheme.get, call_574588.host, call_574588.base,
                         call_574588.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574588, url, valid)

proc call*(call_574589: Call_VpnGatewaysDelete_574581; resourceGroupName: string;
          apiVersion: string; gatewayName: string; subscriptionId: string): Recallable =
  ## vpnGatewaysDelete
  ## Deletes a virtual wan vpn gateway.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnGateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   gatewayName: string (required)
  ##              : The name of the gateway.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574590 = newJObject()
  var query_574591 = newJObject()
  add(path_574590, "resourceGroupName", newJString(resourceGroupName))
  add(query_574591, "api-version", newJString(apiVersion))
  add(path_574590, "gatewayName", newJString(gatewayName))
  add(path_574590, "subscriptionId", newJString(subscriptionId))
  result = call_574589.call(path_574590, query_574591, nil, nil, nil)

var vpnGatewaysDelete* = Call_VpnGatewaysDelete_574581(name: "vpnGatewaysDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}",
    validator: validate_VpnGatewaysDelete_574582, base: "",
    url: url_VpnGatewaysDelete_574583, schemes: {Scheme.Https})
type
  Call_VpnGatewaysReset_574605 = ref object of OpenApiRestCall_573666
proc url_VpnGatewaysReset_574607(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "gatewayName" in path, "`gatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/vpnGateways/"),
               (kind: VariableSegment, value: "gatewayName"),
               (kind: ConstantSegment, value: "/reset")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VpnGatewaysReset_574606(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Resets the primary of the vpn gateway in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnGateway.
  ##   gatewayName: JString (required)
  ##              : The name of the gateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574608 = path.getOrDefault("resourceGroupName")
  valid_574608 = validateParameter(valid_574608, JString, required = true,
                                 default = nil)
  if valid_574608 != nil:
    section.add "resourceGroupName", valid_574608
  var valid_574609 = path.getOrDefault("gatewayName")
  valid_574609 = validateParameter(valid_574609, JString, required = true,
                                 default = nil)
  if valid_574609 != nil:
    section.add "gatewayName", valid_574609
  var valid_574610 = path.getOrDefault("subscriptionId")
  valid_574610 = validateParameter(valid_574610, JString, required = true,
                                 default = nil)
  if valid_574610 != nil:
    section.add "subscriptionId", valid_574610
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574611 = query.getOrDefault("api-version")
  valid_574611 = validateParameter(valid_574611, JString, required = true,
                                 default = nil)
  if valid_574611 != nil:
    section.add "api-version", valid_574611
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574612: Call_VpnGatewaysReset_574605; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets the primary of the vpn gateway in the specified resource group.
  ## 
  let valid = call_574612.validator(path, query, header, formData, body)
  let scheme = call_574612.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574612.url(scheme.get, call_574612.host, call_574612.base,
                         call_574612.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574612, url, valid)

proc call*(call_574613: Call_VpnGatewaysReset_574605; resourceGroupName: string;
          apiVersion: string; gatewayName: string; subscriptionId: string): Recallable =
  ## vpnGatewaysReset
  ## Resets the primary of the vpn gateway in the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnGateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   gatewayName: string (required)
  ##              : The name of the gateway.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574614 = newJObject()
  var query_574615 = newJObject()
  add(path_574614, "resourceGroupName", newJString(resourceGroupName))
  add(query_574615, "api-version", newJString(apiVersion))
  add(path_574614, "gatewayName", newJString(gatewayName))
  add(path_574614, "subscriptionId", newJString(subscriptionId))
  result = call_574613.call(path_574614, query_574615, nil, nil, nil)

var vpnGatewaysReset* = Call_VpnGatewaysReset_574605(name: "vpnGatewaysReset",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/reset",
    validator: validate_VpnGatewaysReset_574606, base: "",
    url: url_VpnGatewaysReset_574607, schemes: {Scheme.Https})
type
  Call_VpnConnectionsListByVpnGateway_574616 = ref object of OpenApiRestCall_573666
proc url_VpnConnectionsListByVpnGateway_574618(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "gatewayName" in path, "`gatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/vpnGateways/"),
               (kind: VariableSegment, value: "gatewayName"),
               (kind: ConstantSegment, value: "/vpnConnections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VpnConnectionsListByVpnGateway_574617(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all vpn connections for a particular virtual wan vpn gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnGateway.
  ##   gatewayName: JString (required)
  ##              : The name of the gateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574619 = path.getOrDefault("resourceGroupName")
  valid_574619 = validateParameter(valid_574619, JString, required = true,
                                 default = nil)
  if valid_574619 != nil:
    section.add "resourceGroupName", valid_574619
  var valid_574620 = path.getOrDefault("gatewayName")
  valid_574620 = validateParameter(valid_574620, JString, required = true,
                                 default = nil)
  if valid_574620 != nil:
    section.add "gatewayName", valid_574620
  var valid_574621 = path.getOrDefault("subscriptionId")
  valid_574621 = validateParameter(valid_574621, JString, required = true,
                                 default = nil)
  if valid_574621 != nil:
    section.add "subscriptionId", valid_574621
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574622 = query.getOrDefault("api-version")
  valid_574622 = validateParameter(valid_574622, JString, required = true,
                                 default = nil)
  if valid_574622 != nil:
    section.add "api-version", valid_574622
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574623: Call_VpnConnectionsListByVpnGateway_574616; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all vpn connections for a particular virtual wan vpn gateway.
  ## 
  let valid = call_574623.validator(path, query, header, formData, body)
  let scheme = call_574623.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574623.url(scheme.get, call_574623.host, call_574623.base,
                         call_574623.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574623, url, valid)

proc call*(call_574624: Call_VpnConnectionsListByVpnGateway_574616;
          resourceGroupName: string; apiVersion: string; gatewayName: string;
          subscriptionId: string): Recallable =
  ## vpnConnectionsListByVpnGateway
  ## Retrieves all vpn connections for a particular virtual wan vpn gateway.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnGateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   gatewayName: string (required)
  ##              : The name of the gateway.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574625 = newJObject()
  var query_574626 = newJObject()
  add(path_574625, "resourceGroupName", newJString(resourceGroupName))
  add(query_574626, "api-version", newJString(apiVersion))
  add(path_574625, "gatewayName", newJString(gatewayName))
  add(path_574625, "subscriptionId", newJString(subscriptionId))
  result = call_574624.call(path_574625, query_574626, nil, nil, nil)

var vpnConnectionsListByVpnGateway* = Call_VpnConnectionsListByVpnGateway_574616(
    name: "vpnConnectionsListByVpnGateway", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections",
    validator: validate_VpnConnectionsListByVpnGateway_574617, base: "",
    url: url_VpnConnectionsListByVpnGateway_574618, schemes: {Scheme.Https})
type
  Call_VpnConnectionsCreateOrUpdate_574639 = ref object of OpenApiRestCall_573666
proc url_VpnConnectionsCreateOrUpdate_574641(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "gatewayName" in path, "`gatewayName` is a required path parameter"
  assert "connectionName" in path, "`connectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/vpnGateways/"),
               (kind: VariableSegment, value: "gatewayName"),
               (kind: ConstantSegment, value: "/vpnConnections/"),
               (kind: VariableSegment, value: "connectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VpnConnectionsCreateOrUpdate_574640(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a vpn connection to a scalable vpn gateway if it doesn't exist else updates the existing connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnGateway.
  ##   gatewayName: JString (required)
  ##              : The name of the gateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: JString (required)
  ##                 : The name of the connection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574642 = path.getOrDefault("resourceGroupName")
  valid_574642 = validateParameter(valid_574642, JString, required = true,
                                 default = nil)
  if valid_574642 != nil:
    section.add "resourceGroupName", valid_574642
  var valid_574643 = path.getOrDefault("gatewayName")
  valid_574643 = validateParameter(valid_574643, JString, required = true,
                                 default = nil)
  if valid_574643 != nil:
    section.add "gatewayName", valid_574643
  var valid_574644 = path.getOrDefault("subscriptionId")
  valid_574644 = validateParameter(valid_574644, JString, required = true,
                                 default = nil)
  if valid_574644 != nil:
    section.add "subscriptionId", valid_574644
  var valid_574645 = path.getOrDefault("connectionName")
  valid_574645 = validateParameter(valid_574645, JString, required = true,
                                 default = nil)
  if valid_574645 != nil:
    section.add "connectionName", valid_574645
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574646 = query.getOrDefault("api-version")
  valid_574646 = validateParameter(valid_574646, JString, required = true,
                                 default = nil)
  if valid_574646 != nil:
    section.add "api-version", valid_574646
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   VpnConnectionParameters: JObject (required)
  ##                          : Parameters supplied to create or Update a VPN Connection.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574648: Call_VpnConnectionsCreateOrUpdate_574639; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a vpn connection to a scalable vpn gateway if it doesn't exist else updates the existing connection.
  ## 
  let valid = call_574648.validator(path, query, header, formData, body)
  let scheme = call_574648.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574648.url(scheme.get, call_574648.host, call_574648.base,
                         call_574648.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574648, url, valid)

proc call*(call_574649: Call_VpnConnectionsCreateOrUpdate_574639;
          resourceGroupName: string; apiVersion: string; gatewayName: string;
          subscriptionId: string; VpnConnectionParameters: JsonNode;
          connectionName: string): Recallable =
  ## vpnConnectionsCreateOrUpdate
  ## Creates a vpn connection to a scalable vpn gateway if it doesn't exist else updates the existing connection.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnGateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   gatewayName: string (required)
  ##              : The name of the gateway.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   VpnConnectionParameters: JObject (required)
  ##                          : Parameters supplied to create or Update a VPN Connection.
  ##   connectionName: string (required)
  ##                 : The name of the connection.
  var path_574650 = newJObject()
  var query_574651 = newJObject()
  var body_574652 = newJObject()
  add(path_574650, "resourceGroupName", newJString(resourceGroupName))
  add(query_574651, "api-version", newJString(apiVersion))
  add(path_574650, "gatewayName", newJString(gatewayName))
  add(path_574650, "subscriptionId", newJString(subscriptionId))
  if VpnConnectionParameters != nil:
    body_574652 = VpnConnectionParameters
  add(path_574650, "connectionName", newJString(connectionName))
  result = call_574649.call(path_574650, query_574651, nil, nil, body_574652)

var vpnConnectionsCreateOrUpdate* = Call_VpnConnectionsCreateOrUpdate_574639(
    name: "vpnConnectionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections/{connectionName}",
    validator: validate_VpnConnectionsCreateOrUpdate_574640, base: "",
    url: url_VpnConnectionsCreateOrUpdate_574641, schemes: {Scheme.Https})
type
  Call_VpnConnectionsGet_574627 = ref object of OpenApiRestCall_573666
proc url_VpnConnectionsGet_574629(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "gatewayName" in path, "`gatewayName` is a required path parameter"
  assert "connectionName" in path, "`connectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/vpnGateways/"),
               (kind: VariableSegment, value: "gatewayName"),
               (kind: ConstantSegment, value: "/vpnConnections/"),
               (kind: VariableSegment, value: "connectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VpnConnectionsGet_574628(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Retrieves the details of a vpn connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnGateway.
  ##   gatewayName: JString (required)
  ##              : The name of the gateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: JString (required)
  ##                 : The name of the vpn connection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574630 = path.getOrDefault("resourceGroupName")
  valid_574630 = validateParameter(valid_574630, JString, required = true,
                                 default = nil)
  if valid_574630 != nil:
    section.add "resourceGroupName", valid_574630
  var valid_574631 = path.getOrDefault("gatewayName")
  valid_574631 = validateParameter(valid_574631, JString, required = true,
                                 default = nil)
  if valid_574631 != nil:
    section.add "gatewayName", valid_574631
  var valid_574632 = path.getOrDefault("subscriptionId")
  valid_574632 = validateParameter(valid_574632, JString, required = true,
                                 default = nil)
  if valid_574632 != nil:
    section.add "subscriptionId", valid_574632
  var valid_574633 = path.getOrDefault("connectionName")
  valid_574633 = validateParameter(valid_574633, JString, required = true,
                                 default = nil)
  if valid_574633 != nil:
    section.add "connectionName", valid_574633
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574634 = query.getOrDefault("api-version")
  valid_574634 = validateParameter(valid_574634, JString, required = true,
                                 default = nil)
  if valid_574634 != nil:
    section.add "api-version", valid_574634
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574635: Call_VpnConnectionsGet_574627; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a vpn connection.
  ## 
  let valid = call_574635.validator(path, query, header, formData, body)
  let scheme = call_574635.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574635.url(scheme.get, call_574635.host, call_574635.base,
                         call_574635.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574635, url, valid)

proc call*(call_574636: Call_VpnConnectionsGet_574627; resourceGroupName: string;
          apiVersion: string; gatewayName: string; subscriptionId: string;
          connectionName: string): Recallable =
  ## vpnConnectionsGet
  ## Retrieves the details of a vpn connection.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnGateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   gatewayName: string (required)
  ##              : The name of the gateway.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: string (required)
  ##                 : The name of the vpn connection.
  var path_574637 = newJObject()
  var query_574638 = newJObject()
  add(path_574637, "resourceGroupName", newJString(resourceGroupName))
  add(query_574638, "api-version", newJString(apiVersion))
  add(path_574637, "gatewayName", newJString(gatewayName))
  add(path_574637, "subscriptionId", newJString(subscriptionId))
  add(path_574637, "connectionName", newJString(connectionName))
  result = call_574636.call(path_574637, query_574638, nil, nil, nil)

var vpnConnectionsGet* = Call_VpnConnectionsGet_574627(name: "vpnConnectionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections/{connectionName}",
    validator: validate_VpnConnectionsGet_574628, base: "",
    url: url_VpnConnectionsGet_574629, schemes: {Scheme.Https})
type
  Call_VpnConnectionsDelete_574653 = ref object of OpenApiRestCall_573666
proc url_VpnConnectionsDelete_574655(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "gatewayName" in path, "`gatewayName` is a required path parameter"
  assert "connectionName" in path, "`connectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/vpnGateways/"),
               (kind: VariableSegment, value: "gatewayName"),
               (kind: ConstantSegment, value: "/vpnConnections/"),
               (kind: VariableSegment, value: "connectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VpnConnectionsDelete_574654(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a vpn connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnGateway.
  ##   gatewayName: JString (required)
  ##              : The name of the gateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: JString (required)
  ##                 : The name of the connection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574656 = path.getOrDefault("resourceGroupName")
  valid_574656 = validateParameter(valid_574656, JString, required = true,
                                 default = nil)
  if valid_574656 != nil:
    section.add "resourceGroupName", valid_574656
  var valid_574657 = path.getOrDefault("gatewayName")
  valid_574657 = validateParameter(valid_574657, JString, required = true,
                                 default = nil)
  if valid_574657 != nil:
    section.add "gatewayName", valid_574657
  var valid_574658 = path.getOrDefault("subscriptionId")
  valid_574658 = validateParameter(valid_574658, JString, required = true,
                                 default = nil)
  if valid_574658 != nil:
    section.add "subscriptionId", valid_574658
  var valid_574659 = path.getOrDefault("connectionName")
  valid_574659 = validateParameter(valid_574659, JString, required = true,
                                 default = nil)
  if valid_574659 != nil:
    section.add "connectionName", valid_574659
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574660 = query.getOrDefault("api-version")
  valid_574660 = validateParameter(valid_574660, JString, required = true,
                                 default = nil)
  if valid_574660 != nil:
    section.add "api-version", valid_574660
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574661: Call_VpnConnectionsDelete_574653; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a vpn connection.
  ## 
  let valid = call_574661.validator(path, query, header, formData, body)
  let scheme = call_574661.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574661.url(scheme.get, call_574661.host, call_574661.base,
                         call_574661.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574661, url, valid)

proc call*(call_574662: Call_VpnConnectionsDelete_574653;
          resourceGroupName: string; apiVersion: string; gatewayName: string;
          subscriptionId: string; connectionName: string): Recallable =
  ## vpnConnectionsDelete
  ## Deletes a vpn connection.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnGateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   gatewayName: string (required)
  ##              : The name of the gateway.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: string (required)
  ##                 : The name of the connection.
  var path_574663 = newJObject()
  var query_574664 = newJObject()
  add(path_574663, "resourceGroupName", newJString(resourceGroupName))
  add(query_574664, "api-version", newJString(apiVersion))
  add(path_574663, "gatewayName", newJString(gatewayName))
  add(path_574663, "subscriptionId", newJString(subscriptionId))
  add(path_574663, "connectionName", newJString(connectionName))
  result = call_574662.call(path_574663, query_574664, nil, nil, nil)

var vpnConnectionsDelete* = Call_VpnConnectionsDelete_574653(
    name: "vpnConnectionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections/{connectionName}",
    validator: validate_VpnConnectionsDelete_574654, base: "",
    url: url_VpnConnectionsDelete_574655, schemes: {Scheme.Https})
type
  Call_VpnLinkConnectionsListByVpnConnection_574665 = ref object of OpenApiRestCall_573666
proc url_VpnLinkConnectionsListByVpnConnection_574667(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "gatewayName" in path, "`gatewayName` is a required path parameter"
  assert "connectionName" in path, "`connectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/vpnGateways/"),
               (kind: VariableSegment, value: "gatewayName"),
               (kind: ConstantSegment, value: "/vpnConnections/"),
               (kind: VariableSegment, value: "connectionName"),
               (kind: ConstantSegment, value: "/vpnLinkConnections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VpnLinkConnectionsListByVpnConnection_574666(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all vpn site link connections for a particular virtual wan vpn gateway vpn connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnGateway.
  ##   gatewayName: JString (required)
  ##              : The name of the gateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: JString (required)
  ##                 : The name of the vpn connection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574668 = path.getOrDefault("resourceGroupName")
  valid_574668 = validateParameter(valid_574668, JString, required = true,
                                 default = nil)
  if valid_574668 != nil:
    section.add "resourceGroupName", valid_574668
  var valid_574669 = path.getOrDefault("gatewayName")
  valid_574669 = validateParameter(valid_574669, JString, required = true,
                                 default = nil)
  if valid_574669 != nil:
    section.add "gatewayName", valid_574669
  var valid_574670 = path.getOrDefault("subscriptionId")
  valid_574670 = validateParameter(valid_574670, JString, required = true,
                                 default = nil)
  if valid_574670 != nil:
    section.add "subscriptionId", valid_574670
  var valid_574671 = path.getOrDefault("connectionName")
  valid_574671 = validateParameter(valid_574671, JString, required = true,
                                 default = nil)
  if valid_574671 != nil:
    section.add "connectionName", valid_574671
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574672 = query.getOrDefault("api-version")
  valid_574672 = validateParameter(valid_574672, JString, required = true,
                                 default = nil)
  if valid_574672 != nil:
    section.add "api-version", valid_574672
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574673: Call_VpnLinkConnectionsListByVpnConnection_574665;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all vpn site link connections for a particular virtual wan vpn gateway vpn connection.
  ## 
  let valid = call_574673.validator(path, query, header, formData, body)
  let scheme = call_574673.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574673.url(scheme.get, call_574673.host, call_574673.base,
                         call_574673.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574673, url, valid)

proc call*(call_574674: Call_VpnLinkConnectionsListByVpnConnection_574665;
          resourceGroupName: string; apiVersion: string; gatewayName: string;
          subscriptionId: string; connectionName: string): Recallable =
  ## vpnLinkConnectionsListByVpnConnection
  ## Retrieves all vpn site link connections for a particular virtual wan vpn gateway vpn connection.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnGateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   gatewayName: string (required)
  ##              : The name of the gateway.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: string (required)
  ##                 : The name of the vpn connection.
  var path_574675 = newJObject()
  var query_574676 = newJObject()
  add(path_574675, "resourceGroupName", newJString(resourceGroupName))
  add(query_574676, "api-version", newJString(apiVersion))
  add(path_574675, "gatewayName", newJString(gatewayName))
  add(path_574675, "subscriptionId", newJString(subscriptionId))
  add(path_574675, "connectionName", newJString(connectionName))
  result = call_574674.call(path_574675, query_574676, nil, nil, nil)

var vpnLinkConnectionsListByVpnConnection* = Call_VpnLinkConnectionsListByVpnConnection_574665(
    name: "vpnLinkConnectionsListByVpnConnection", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections/{connectionName}/vpnLinkConnections",
    validator: validate_VpnLinkConnectionsListByVpnConnection_574666, base: "",
    url: url_VpnLinkConnectionsListByVpnConnection_574667, schemes: {Scheme.Https})
type
  Call_VpnSiteLinkConnectionsGet_574677 = ref object of OpenApiRestCall_573666
proc url_VpnSiteLinkConnectionsGet_574679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "gatewayName" in path, "`gatewayName` is a required path parameter"
  assert "connectionName" in path, "`connectionName` is a required path parameter"
  assert "linkConnectionName" in path,
        "`linkConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/vpnGateways/"),
               (kind: VariableSegment, value: "gatewayName"),
               (kind: ConstantSegment, value: "/vpnConnections/"),
               (kind: VariableSegment, value: "connectionName"),
               (kind: ConstantSegment, value: "/vpnLinkConnections/"),
               (kind: VariableSegment, value: "linkConnectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VpnSiteLinkConnectionsGet_574678(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the details of a vpn site link connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnGateway.
  ##   gatewayName: JString (required)
  ##              : The name of the gateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   linkConnectionName: JString (required)
  ##                     : The name of the vpn connection.
  ##   connectionName: JString (required)
  ##                 : The name of the vpn connection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574680 = path.getOrDefault("resourceGroupName")
  valid_574680 = validateParameter(valid_574680, JString, required = true,
                                 default = nil)
  if valid_574680 != nil:
    section.add "resourceGroupName", valid_574680
  var valid_574681 = path.getOrDefault("gatewayName")
  valid_574681 = validateParameter(valid_574681, JString, required = true,
                                 default = nil)
  if valid_574681 != nil:
    section.add "gatewayName", valid_574681
  var valid_574682 = path.getOrDefault("subscriptionId")
  valid_574682 = validateParameter(valid_574682, JString, required = true,
                                 default = nil)
  if valid_574682 != nil:
    section.add "subscriptionId", valid_574682
  var valid_574683 = path.getOrDefault("linkConnectionName")
  valid_574683 = validateParameter(valid_574683, JString, required = true,
                                 default = nil)
  if valid_574683 != nil:
    section.add "linkConnectionName", valid_574683
  var valid_574684 = path.getOrDefault("connectionName")
  valid_574684 = validateParameter(valid_574684, JString, required = true,
                                 default = nil)
  if valid_574684 != nil:
    section.add "connectionName", valid_574684
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574685 = query.getOrDefault("api-version")
  valid_574685 = validateParameter(valid_574685, JString, required = true,
                                 default = nil)
  if valid_574685 != nil:
    section.add "api-version", valid_574685
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574686: Call_VpnSiteLinkConnectionsGet_574677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a vpn site link connection.
  ## 
  let valid = call_574686.validator(path, query, header, formData, body)
  let scheme = call_574686.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574686.url(scheme.get, call_574686.host, call_574686.base,
                         call_574686.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574686, url, valid)

proc call*(call_574687: Call_VpnSiteLinkConnectionsGet_574677;
          resourceGroupName: string; apiVersion: string; gatewayName: string;
          subscriptionId: string; linkConnectionName: string; connectionName: string): Recallable =
  ## vpnSiteLinkConnectionsGet
  ## Retrieves the details of a vpn site link connection.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnGateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   gatewayName: string (required)
  ##              : The name of the gateway.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   linkConnectionName: string (required)
  ##                     : The name of the vpn connection.
  ##   connectionName: string (required)
  ##                 : The name of the vpn connection.
  var path_574688 = newJObject()
  var query_574689 = newJObject()
  add(path_574688, "resourceGroupName", newJString(resourceGroupName))
  add(query_574689, "api-version", newJString(apiVersion))
  add(path_574688, "gatewayName", newJString(gatewayName))
  add(path_574688, "subscriptionId", newJString(subscriptionId))
  add(path_574688, "linkConnectionName", newJString(linkConnectionName))
  add(path_574688, "connectionName", newJString(connectionName))
  result = call_574687.call(path_574688, query_574689, nil, nil, nil)

var vpnSiteLinkConnectionsGet* = Call_VpnSiteLinkConnectionsGet_574677(
    name: "vpnSiteLinkConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections/{connectionName}/vpnLinkConnections/{linkConnectionName}",
    validator: validate_VpnSiteLinkConnectionsGet_574678, base: "",
    url: url_VpnSiteLinkConnectionsGet_574679, schemes: {Scheme.Https})
type
  Call_VpnSitesListByResourceGroup_574690 = ref object of OpenApiRestCall_573666
proc url_VpnSitesListByResourceGroup_574692(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/vpnSites")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VpnSitesListByResourceGroup_574691(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the vpnSites in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnSite.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574693 = path.getOrDefault("resourceGroupName")
  valid_574693 = validateParameter(valid_574693, JString, required = true,
                                 default = nil)
  if valid_574693 != nil:
    section.add "resourceGroupName", valid_574693
  var valid_574694 = path.getOrDefault("subscriptionId")
  valid_574694 = validateParameter(valid_574694, JString, required = true,
                                 default = nil)
  if valid_574694 != nil:
    section.add "subscriptionId", valid_574694
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574695 = query.getOrDefault("api-version")
  valid_574695 = validateParameter(valid_574695, JString, required = true,
                                 default = nil)
  if valid_574695 != nil:
    section.add "api-version", valid_574695
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574696: Call_VpnSitesListByResourceGroup_574690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the vpnSites in a resource group.
  ## 
  let valid = call_574696.validator(path, query, header, formData, body)
  let scheme = call_574696.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574696.url(scheme.get, call_574696.host, call_574696.base,
                         call_574696.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574696, url, valid)

proc call*(call_574697: Call_VpnSitesListByResourceGroup_574690;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## vpnSitesListByResourceGroup
  ## Lists all the vpnSites in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnSite.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574698 = newJObject()
  var query_574699 = newJObject()
  add(path_574698, "resourceGroupName", newJString(resourceGroupName))
  add(query_574699, "api-version", newJString(apiVersion))
  add(path_574698, "subscriptionId", newJString(subscriptionId))
  result = call_574697.call(path_574698, query_574699, nil, nil, nil)

var vpnSitesListByResourceGroup* = Call_VpnSitesListByResourceGroup_574690(
    name: "vpnSitesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites",
    validator: validate_VpnSitesListByResourceGroup_574691, base: "",
    url: url_VpnSitesListByResourceGroup_574692, schemes: {Scheme.Https})
type
  Call_VpnSitesCreateOrUpdate_574711 = ref object of OpenApiRestCall_573666
proc url_VpnSitesCreateOrUpdate_574713(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vpnSiteName" in path, "`vpnSiteName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/vpnSites/"),
               (kind: VariableSegment, value: "vpnSiteName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VpnSitesCreateOrUpdate_574712(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a VpnSite resource if it doesn't exist else updates the existing VpnSite.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnSite.
  ##   vpnSiteName: JString (required)
  ##              : The name of the VpnSite being created or updated.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574714 = path.getOrDefault("resourceGroupName")
  valid_574714 = validateParameter(valid_574714, JString, required = true,
                                 default = nil)
  if valid_574714 != nil:
    section.add "resourceGroupName", valid_574714
  var valid_574715 = path.getOrDefault("vpnSiteName")
  valid_574715 = validateParameter(valid_574715, JString, required = true,
                                 default = nil)
  if valid_574715 != nil:
    section.add "vpnSiteName", valid_574715
  var valid_574716 = path.getOrDefault("subscriptionId")
  valid_574716 = validateParameter(valid_574716, JString, required = true,
                                 default = nil)
  if valid_574716 != nil:
    section.add "subscriptionId", valid_574716
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574717 = query.getOrDefault("api-version")
  valid_574717 = validateParameter(valid_574717, JString, required = true,
                                 default = nil)
  if valid_574717 != nil:
    section.add "api-version", valid_574717
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   VpnSiteParameters: JObject (required)
  ##                    : Parameters supplied to create or update VpnSite.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574719: Call_VpnSitesCreateOrUpdate_574711; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a VpnSite resource if it doesn't exist else updates the existing VpnSite.
  ## 
  let valid = call_574719.validator(path, query, header, formData, body)
  let scheme = call_574719.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574719.url(scheme.get, call_574719.host, call_574719.base,
                         call_574719.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574719, url, valid)

proc call*(call_574720: Call_VpnSitesCreateOrUpdate_574711;
          resourceGroupName: string; apiVersion: string; vpnSiteName: string;
          subscriptionId: string; VpnSiteParameters: JsonNode): Recallable =
  ## vpnSitesCreateOrUpdate
  ## Creates a VpnSite resource if it doesn't exist else updates the existing VpnSite.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnSite.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   vpnSiteName: string (required)
  ##              : The name of the VpnSite being created or updated.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   VpnSiteParameters: JObject (required)
  ##                    : Parameters supplied to create or update VpnSite.
  var path_574721 = newJObject()
  var query_574722 = newJObject()
  var body_574723 = newJObject()
  add(path_574721, "resourceGroupName", newJString(resourceGroupName))
  add(query_574722, "api-version", newJString(apiVersion))
  add(path_574721, "vpnSiteName", newJString(vpnSiteName))
  add(path_574721, "subscriptionId", newJString(subscriptionId))
  if VpnSiteParameters != nil:
    body_574723 = VpnSiteParameters
  result = call_574720.call(path_574721, query_574722, nil, nil, body_574723)

var vpnSitesCreateOrUpdate* = Call_VpnSitesCreateOrUpdate_574711(
    name: "vpnSitesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}",
    validator: validate_VpnSitesCreateOrUpdate_574712, base: "",
    url: url_VpnSitesCreateOrUpdate_574713, schemes: {Scheme.Https})
type
  Call_VpnSitesGet_574700 = ref object of OpenApiRestCall_573666
proc url_VpnSitesGet_574702(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vpnSiteName" in path, "`vpnSiteName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/vpnSites/"),
               (kind: VariableSegment, value: "vpnSiteName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VpnSitesGet_574701(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the details of a VPN site.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnSite.
  ##   vpnSiteName: JString (required)
  ##              : The name of the VpnSite being retrieved.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574703 = path.getOrDefault("resourceGroupName")
  valid_574703 = validateParameter(valid_574703, JString, required = true,
                                 default = nil)
  if valid_574703 != nil:
    section.add "resourceGroupName", valid_574703
  var valid_574704 = path.getOrDefault("vpnSiteName")
  valid_574704 = validateParameter(valid_574704, JString, required = true,
                                 default = nil)
  if valid_574704 != nil:
    section.add "vpnSiteName", valid_574704
  var valid_574705 = path.getOrDefault("subscriptionId")
  valid_574705 = validateParameter(valid_574705, JString, required = true,
                                 default = nil)
  if valid_574705 != nil:
    section.add "subscriptionId", valid_574705
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574706 = query.getOrDefault("api-version")
  valid_574706 = validateParameter(valid_574706, JString, required = true,
                                 default = nil)
  if valid_574706 != nil:
    section.add "api-version", valid_574706
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574707: Call_VpnSitesGet_574700; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a VPN site.
  ## 
  let valid = call_574707.validator(path, query, header, formData, body)
  let scheme = call_574707.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574707.url(scheme.get, call_574707.host, call_574707.base,
                         call_574707.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574707, url, valid)

proc call*(call_574708: Call_VpnSitesGet_574700; resourceGroupName: string;
          apiVersion: string; vpnSiteName: string; subscriptionId: string): Recallable =
  ## vpnSitesGet
  ## Retrieves the details of a VPN site.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnSite.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   vpnSiteName: string (required)
  ##              : The name of the VpnSite being retrieved.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574709 = newJObject()
  var query_574710 = newJObject()
  add(path_574709, "resourceGroupName", newJString(resourceGroupName))
  add(query_574710, "api-version", newJString(apiVersion))
  add(path_574709, "vpnSiteName", newJString(vpnSiteName))
  add(path_574709, "subscriptionId", newJString(subscriptionId))
  result = call_574708.call(path_574709, query_574710, nil, nil, nil)

var vpnSitesGet* = Call_VpnSitesGet_574700(name: "vpnSitesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}",
                                        validator: validate_VpnSitesGet_574701,
                                        base: "", url: url_VpnSitesGet_574702,
                                        schemes: {Scheme.Https})
type
  Call_VpnSitesUpdateTags_574735 = ref object of OpenApiRestCall_573666
proc url_VpnSitesUpdateTags_574737(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vpnSiteName" in path, "`vpnSiteName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/vpnSites/"),
               (kind: VariableSegment, value: "vpnSiteName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VpnSitesUpdateTags_574736(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates VpnSite tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnSite.
  ##   vpnSiteName: JString (required)
  ##              : The name of the VpnSite being updated.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574738 = path.getOrDefault("resourceGroupName")
  valid_574738 = validateParameter(valid_574738, JString, required = true,
                                 default = nil)
  if valid_574738 != nil:
    section.add "resourceGroupName", valid_574738
  var valid_574739 = path.getOrDefault("vpnSiteName")
  valid_574739 = validateParameter(valid_574739, JString, required = true,
                                 default = nil)
  if valid_574739 != nil:
    section.add "vpnSiteName", valid_574739
  var valid_574740 = path.getOrDefault("subscriptionId")
  valid_574740 = validateParameter(valid_574740, JString, required = true,
                                 default = nil)
  if valid_574740 != nil:
    section.add "subscriptionId", valid_574740
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574741 = query.getOrDefault("api-version")
  valid_574741 = validateParameter(valid_574741, JString, required = true,
                                 default = nil)
  if valid_574741 != nil:
    section.add "api-version", valid_574741
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   VpnSiteParameters: JObject (required)
  ##                    : Parameters supplied to update VpnSite tags.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574743: Call_VpnSitesUpdateTags_574735; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates VpnSite tags.
  ## 
  let valid = call_574743.validator(path, query, header, formData, body)
  let scheme = call_574743.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574743.url(scheme.get, call_574743.host, call_574743.base,
                         call_574743.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574743, url, valid)

proc call*(call_574744: Call_VpnSitesUpdateTags_574735; resourceGroupName: string;
          apiVersion: string; vpnSiteName: string; subscriptionId: string;
          VpnSiteParameters: JsonNode): Recallable =
  ## vpnSitesUpdateTags
  ## Updates VpnSite tags.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnSite.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   vpnSiteName: string (required)
  ##              : The name of the VpnSite being updated.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   VpnSiteParameters: JObject (required)
  ##                    : Parameters supplied to update VpnSite tags.
  var path_574745 = newJObject()
  var query_574746 = newJObject()
  var body_574747 = newJObject()
  add(path_574745, "resourceGroupName", newJString(resourceGroupName))
  add(query_574746, "api-version", newJString(apiVersion))
  add(path_574745, "vpnSiteName", newJString(vpnSiteName))
  add(path_574745, "subscriptionId", newJString(subscriptionId))
  if VpnSiteParameters != nil:
    body_574747 = VpnSiteParameters
  result = call_574744.call(path_574745, query_574746, nil, nil, body_574747)

var vpnSitesUpdateTags* = Call_VpnSitesUpdateTags_574735(
    name: "vpnSitesUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}",
    validator: validate_VpnSitesUpdateTags_574736, base: "",
    url: url_VpnSitesUpdateTags_574737, schemes: {Scheme.Https})
type
  Call_VpnSitesDelete_574724 = ref object of OpenApiRestCall_573666
proc url_VpnSitesDelete_574726(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vpnSiteName" in path, "`vpnSiteName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/vpnSites/"),
               (kind: VariableSegment, value: "vpnSiteName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VpnSitesDelete_574725(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a VpnSite.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnSite.
  ##   vpnSiteName: JString (required)
  ##              : The name of the VpnSite being deleted.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574727 = path.getOrDefault("resourceGroupName")
  valid_574727 = validateParameter(valid_574727, JString, required = true,
                                 default = nil)
  if valid_574727 != nil:
    section.add "resourceGroupName", valid_574727
  var valid_574728 = path.getOrDefault("vpnSiteName")
  valid_574728 = validateParameter(valid_574728, JString, required = true,
                                 default = nil)
  if valid_574728 != nil:
    section.add "vpnSiteName", valid_574728
  var valid_574729 = path.getOrDefault("subscriptionId")
  valid_574729 = validateParameter(valid_574729, JString, required = true,
                                 default = nil)
  if valid_574729 != nil:
    section.add "subscriptionId", valid_574729
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574730 = query.getOrDefault("api-version")
  valid_574730 = validateParameter(valid_574730, JString, required = true,
                                 default = nil)
  if valid_574730 != nil:
    section.add "api-version", valid_574730
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574731: Call_VpnSitesDelete_574724; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a VpnSite.
  ## 
  let valid = call_574731.validator(path, query, header, formData, body)
  let scheme = call_574731.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574731.url(scheme.get, call_574731.host, call_574731.base,
                         call_574731.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574731, url, valid)

proc call*(call_574732: Call_VpnSitesDelete_574724; resourceGroupName: string;
          apiVersion: string; vpnSiteName: string; subscriptionId: string): Recallable =
  ## vpnSitesDelete
  ## Deletes a VpnSite.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnSite.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   vpnSiteName: string (required)
  ##              : The name of the VpnSite being deleted.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574733 = newJObject()
  var query_574734 = newJObject()
  add(path_574733, "resourceGroupName", newJString(resourceGroupName))
  add(query_574734, "api-version", newJString(apiVersion))
  add(path_574733, "vpnSiteName", newJString(vpnSiteName))
  add(path_574733, "subscriptionId", newJString(subscriptionId))
  result = call_574732.call(path_574733, query_574734, nil, nil, nil)

var vpnSitesDelete* = Call_VpnSitesDelete_574724(name: "vpnSitesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}",
    validator: validate_VpnSitesDelete_574725, base: "", url: url_VpnSitesDelete_574726,
    schemes: {Scheme.Https})
type
  Call_VpnSiteLinksListByVpnSite_574748 = ref object of OpenApiRestCall_573666
proc url_VpnSiteLinksListByVpnSite_574750(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vpnSiteName" in path, "`vpnSiteName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/vpnSites/"),
               (kind: VariableSegment, value: "vpnSiteName"),
               (kind: ConstantSegment, value: "/vpnSiteLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VpnSiteLinksListByVpnSite_574749(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the vpnSiteLinks in a resource group for a vpn site.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnSite.
  ##   vpnSiteName: JString (required)
  ##              : The name of the VpnSite.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574751 = path.getOrDefault("resourceGroupName")
  valid_574751 = validateParameter(valid_574751, JString, required = true,
                                 default = nil)
  if valid_574751 != nil:
    section.add "resourceGroupName", valid_574751
  var valid_574752 = path.getOrDefault("vpnSiteName")
  valid_574752 = validateParameter(valid_574752, JString, required = true,
                                 default = nil)
  if valid_574752 != nil:
    section.add "vpnSiteName", valid_574752
  var valid_574753 = path.getOrDefault("subscriptionId")
  valid_574753 = validateParameter(valid_574753, JString, required = true,
                                 default = nil)
  if valid_574753 != nil:
    section.add "subscriptionId", valid_574753
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574754 = query.getOrDefault("api-version")
  valid_574754 = validateParameter(valid_574754, JString, required = true,
                                 default = nil)
  if valid_574754 != nil:
    section.add "api-version", valid_574754
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574755: Call_VpnSiteLinksListByVpnSite_574748; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the vpnSiteLinks in a resource group for a vpn site.
  ## 
  let valid = call_574755.validator(path, query, header, formData, body)
  let scheme = call_574755.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574755.url(scheme.get, call_574755.host, call_574755.base,
                         call_574755.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574755, url, valid)

proc call*(call_574756: Call_VpnSiteLinksListByVpnSite_574748;
          resourceGroupName: string; apiVersion: string; vpnSiteName: string;
          subscriptionId: string): Recallable =
  ## vpnSiteLinksListByVpnSite
  ## Lists all the vpnSiteLinks in a resource group for a vpn site.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnSite.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   vpnSiteName: string (required)
  ##              : The name of the VpnSite.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574757 = newJObject()
  var query_574758 = newJObject()
  add(path_574757, "resourceGroupName", newJString(resourceGroupName))
  add(query_574758, "api-version", newJString(apiVersion))
  add(path_574757, "vpnSiteName", newJString(vpnSiteName))
  add(path_574757, "subscriptionId", newJString(subscriptionId))
  result = call_574756.call(path_574757, query_574758, nil, nil, nil)

var vpnSiteLinksListByVpnSite* = Call_VpnSiteLinksListByVpnSite_574748(
    name: "vpnSiteLinksListByVpnSite", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}/vpnSiteLinks",
    validator: validate_VpnSiteLinksListByVpnSite_574749, base: "",
    url: url_VpnSiteLinksListByVpnSite_574750, schemes: {Scheme.Https})
type
  Call_VpnSiteLinksGet_574759 = ref object of OpenApiRestCall_573666
proc url_VpnSiteLinksGet_574761(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vpnSiteName" in path, "`vpnSiteName` is a required path parameter"
  assert "vpnSiteLinkName" in path, "`vpnSiteLinkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/vpnSites/"),
               (kind: VariableSegment, value: "vpnSiteName"),
               (kind: ConstantSegment, value: "/vpnSiteLinks/"),
               (kind: VariableSegment, value: "vpnSiteLinkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VpnSiteLinksGet_574760(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Retrieves the details of a VPN site link.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnSite.
  ##   vpnSiteName: JString (required)
  ##              : The name of the VpnSite.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vpnSiteLinkName: JString (required)
  ##                  : The name of the VpnSiteLink being retrieved.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574762 = path.getOrDefault("resourceGroupName")
  valid_574762 = validateParameter(valid_574762, JString, required = true,
                                 default = nil)
  if valid_574762 != nil:
    section.add "resourceGroupName", valid_574762
  var valid_574763 = path.getOrDefault("vpnSiteName")
  valid_574763 = validateParameter(valid_574763, JString, required = true,
                                 default = nil)
  if valid_574763 != nil:
    section.add "vpnSiteName", valid_574763
  var valid_574764 = path.getOrDefault("subscriptionId")
  valid_574764 = validateParameter(valid_574764, JString, required = true,
                                 default = nil)
  if valid_574764 != nil:
    section.add "subscriptionId", valid_574764
  var valid_574765 = path.getOrDefault("vpnSiteLinkName")
  valid_574765 = validateParameter(valid_574765, JString, required = true,
                                 default = nil)
  if valid_574765 != nil:
    section.add "vpnSiteLinkName", valid_574765
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574766 = query.getOrDefault("api-version")
  valid_574766 = validateParameter(valid_574766, JString, required = true,
                                 default = nil)
  if valid_574766 != nil:
    section.add "api-version", valid_574766
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574767: Call_VpnSiteLinksGet_574759; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a VPN site link.
  ## 
  let valid = call_574767.validator(path, query, header, formData, body)
  let scheme = call_574767.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574767.url(scheme.get, call_574767.host, call_574767.base,
                         call_574767.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574767, url, valid)

proc call*(call_574768: Call_VpnSiteLinksGet_574759; resourceGroupName: string;
          apiVersion: string; vpnSiteName: string; subscriptionId: string;
          vpnSiteLinkName: string): Recallable =
  ## vpnSiteLinksGet
  ## Retrieves the details of a VPN site link.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnSite.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   vpnSiteName: string (required)
  ##              : The name of the VpnSite.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vpnSiteLinkName: string (required)
  ##                  : The name of the VpnSiteLink being retrieved.
  var path_574769 = newJObject()
  var query_574770 = newJObject()
  add(path_574769, "resourceGroupName", newJString(resourceGroupName))
  add(query_574770, "api-version", newJString(apiVersion))
  add(path_574769, "vpnSiteName", newJString(vpnSiteName))
  add(path_574769, "subscriptionId", newJString(subscriptionId))
  add(path_574769, "vpnSiteLinkName", newJString(vpnSiteLinkName))
  result = call_574768.call(path_574769, query_574770, nil, nil, nil)

var vpnSiteLinksGet* = Call_VpnSiteLinksGet_574759(name: "vpnSiteLinksGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}/vpnSiteLinks/{vpnSiteLinkName}",
    validator: validate_VpnSiteLinksGet_574760, base: "", url: url_VpnSiteLinksGet_574761,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
