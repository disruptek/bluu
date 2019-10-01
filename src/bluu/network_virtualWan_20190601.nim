
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: VirtualWANAsAServiceManagementClient
## version: 2019-06-01
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

  OpenApiRestCall_567666 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567666](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567666): Option[Scheme] {.used.} =
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
  Call_P2sVpnGatewaysList_567888 = ref object of OpenApiRestCall_567666
proc url_P2sVpnGatewaysList_567890(protocol: Scheme; host: string; base: string;
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

proc validate_P2sVpnGatewaysList_567889(path: JsonNode; query: JsonNode;
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
  var valid_568050 = path.getOrDefault("subscriptionId")
  valid_568050 = validateParameter(valid_568050, JString, required = true,
                                 default = nil)
  if valid_568050 != nil:
    section.add "subscriptionId", valid_568050
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568051 = query.getOrDefault("api-version")
  valid_568051 = validateParameter(valid_568051, JString, required = true,
                                 default = nil)
  if valid_568051 != nil:
    section.add "api-version", valid_568051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568078: Call_P2sVpnGatewaysList_567888; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the P2SVpnGateways in a subscription.
  ## 
  let valid = call_568078.validator(path, query, header, formData, body)
  let scheme = call_568078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568078.url(scheme.get, call_568078.host, call_568078.base,
                         call_568078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568078, url, valid)

proc call*(call_568149: Call_P2sVpnGatewaysList_567888; apiVersion: string;
          subscriptionId: string): Recallable =
  ## p2sVpnGatewaysList
  ## Lists all the P2SVpnGateways in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568150 = newJObject()
  var query_568152 = newJObject()
  add(query_568152, "api-version", newJString(apiVersion))
  add(path_568150, "subscriptionId", newJString(subscriptionId))
  result = call_568149.call(path_568150, query_568152, nil, nil, nil)

var p2sVpnGatewaysList* = Call_P2sVpnGatewaysList_567888(
    name: "p2sVpnGatewaysList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/p2svpnGateways",
    validator: validate_P2sVpnGatewaysList_567889, base: "",
    url: url_P2sVpnGatewaysList_567890, schemes: {Scheme.Https})
type
  Call_VirtualHubsList_568191 = ref object of OpenApiRestCall_567666
proc url_VirtualHubsList_568193(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualHubsList_568192(path: JsonNode; query: JsonNode;
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
  var valid_568194 = path.getOrDefault("subscriptionId")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "subscriptionId", valid_568194
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568195 = query.getOrDefault("api-version")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "api-version", valid_568195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568196: Call_VirtualHubsList_568191; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VirtualHubs in a subscription.
  ## 
  let valid = call_568196.validator(path, query, header, formData, body)
  let scheme = call_568196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568196.url(scheme.get, call_568196.host, call_568196.base,
                         call_568196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568196, url, valid)

proc call*(call_568197: Call_VirtualHubsList_568191; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualHubsList
  ## Lists all the VirtualHubs in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568198 = newJObject()
  var query_568199 = newJObject()
  add(query_568199, "api-version", newJString(apiVersion))
  add(path_568198, "subscriptionId", newJString(subscriptionId))
  result = call_568197.call(path_568198, query_568199, nil, nil, nil)

var virtualHubsList* = Call_VirtualHubsList_568191(name: "virtualHubsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/virtualHubs",
    validator: validate_VirtualHubsList_568192, base: "", url: url_VirtualHubsList_568193,
    schemes: {Scheme.Https})
type
  Call_VirtualWansList_568200 = ref object of OpenApiRestCall_567666
proc url_VirtualWansList_568202(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualWansList_568201(path: JsonNode; query: JsonNode;
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
  var valid_568203 = path.getOrDefault("subscriptionId")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "subscriptionId", valid_568203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568204 = query.getOrDefault("api-version")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "api-version", valid_568204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568205: Call_VirtualWansList_568200; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VirtualWANs in a subscription.
  ## 
  let valid = call_568205.validator(path, query, header, formData, body)
  let scheme = call_568205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568205.url(scheme.get, call_568205.host, call_568205.base,
                         call_568205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568205, url, valid)

proc call*(call_568206: Call_VirtualWansList_568200; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualWansList
  ## Lists all the VirtualWANs in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568207 = newJObject()
  var query_568208 = newJObject()
  add(query_568208, "api-version", newJString(apiVersion))
  add(path_568207, "subscriptionId", newJString(subscriptionId))
  result = call_568206.call(path_568207, query_568208, nil, nil, nil)

var virtualWansList* = Call_VirtualWansList_568200(name: "virtualWansList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/virtualWans",
    validator: validate_VirtualWansList_568201, base: "", url: url_VirtualWansList_568202,
    schemes: {Scheme.Https})
type
  Call_VpnGatewaysList_568209 = ref object of OpenApiRestCall_567666
proc url_VpnGatewaysList_568211(protocol: Scheme; host: string; base: string;
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

proc validate_VpnGatewaysList_568210(path: JsonNode; query: JsonNode;
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
  var valid_568212 = path.getOrDefault("subscriptionId")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "subscriptionId", valid_568212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568213 = query.getOrDefault("api-version")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "api-version", valid_568213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568214: Call_VpnGatewaysList_568209; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VpnGateways in a subscription.
  ## 
  let valid = call_568214.validator(path, query, header, formData, body)
  let scheme = call_568214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568214.url(scheme.get, call_568214.host, call_568214.base,
                         call_568214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568214, url, valid)

proc call*(call_568215: Call_VpnGatewaysList_568209; apiVersion: string;
          subscriptionId: string): Recallable =
  ## vpnGatewaysList
  ## Lists all the VpnGateways in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568216 = newJObject()
  var query_568217 = newJObject()
  add(query_568217, "api-version", newJString(apiVersion))
  add(path_568216, "subscriptionId", newJString(subscriptionId))
  result = call_568215.call(path_568216, query_568217, nil, nil, nil)

var vpnGatewaysList* = Call_VpnGatewaysList_568209(name: "vpnGatewaysList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/vpnGateways",
    validator: validate_VpnGatewaysList_568210, base: "", url: url_VpnGatewaysList_568211,
    schemes: {Scheme.Https})
type
  Call_VpnSitesList_568218 = ref object of OpenApiRestCall_567666
proc url_VpnSitesList_568220(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSitesList_568219(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568221 = path.getOrDefault("subscriptionId")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "subscriptionId", valid_568221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568222 = query.getOrDefault("api-version")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "api-version", valid_568222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568223: Call_VpnSitesList_568218; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VpnSites in a subscription.
  ## 
  let valid = call_568223.validator(path, query, header, formData, body)
  let scheme = call_568223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568223.url(scheme.get, call_568223.host, call_568223.base,
                         call_568223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568223, url, valid)

proc call*(call_568224: Call_VpnSitesList_568218; apiVersion: string;
          subscriptionId: string): Recallable =
  ## vpnSitesList
  ## Lists all the VpnSites in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568225 = newJObject()
  var query_568226 = newJObject()
  add(query_568226, "api-version", newJString(apiVersion))
  add(path_568225, "subscriptionId", newJString(subscriptionId))
  result = call_568224.call(path_568225, query_568226, nil, nil, nil)

var vpnSitesList* = Call_VpnSitesList_568218(name: "vpnSitesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/vpnSites",
    validator: validate_VpnSitesList_568219, base: "", url: url_VpnSitesList_568220,
    schemes: {Scheme.Https})
type
  Call_P2sVpnGatewaysListByResourceGroup_568227 = ref object of OpenApiRestCall_567666
proc url_P2sVpnGatewaysListByResourceGroup_568229(protocol: Scheme; host: string;
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

proc validate_P2sVpnGatewaysListByResourceGroup_568228(path: JsonNode;
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
  var valid_568230 = path.getOrDefault("resourceGroupName")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "resourceGroupName", valid_568230
  var valid_568231 = path.getOrDefault("subscriptionId")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "subscriptionId", valid_568231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568232 = query.getOrDefault("api-version")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "api-version", valid_568232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568233: Call_P2sVpnGatewaysListByResourceGroup_568227;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the P2SVpnGateways in a resource group.
  ## 
  let valid = call_568233.validator(path, query, header, formData, body)
  let scheme = call_568233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568233.url(scheme.get, call_568233.host, call_568233.base,
                         call_568233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568233, url, valid)

proc call*(call_568234: Call_P2sVpnGatewaysListByResourceGroup_568227;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## p2sVpnGatewaysListByResourceGroup
  ## Lists all the P2SVpnGateways in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the P2SVpnGateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568235 = newJObject()
  var query_568236 = newJObject()
  add(path_568235, "resourceGroupName", newJString(resourceGroupName))
  add(query_568236, "api-version", newJString(apiVersion))
  add(path_568235, "subscriptionId", newJString(subscriptionId))
  result = call_568234.call(path_568235, query_568236, nil, nil, nil)

var p2sVpnGatewaysListByResourceGroup* = Call_P2sVpnGatewaysListByResourceGroup_568227(
    name: "p2sVpnGatewaysListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/p2svpnGateways",
    validator: validate_P2sVpnGatewaysListByResourceGroup_568228, base: "",
    url: url_P2sVpnGatewaysListByResourceGroup_568229, schemes: {Scheme.Https})
type
  Call_P2sVpnGatewaysCreateOrUpdate_568248 = ref object of OpenApiRestCall_567666
proc url_P2sVpnGatewaysCreateOrUpdate_568250(protocol: Scheme; host: string;
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

proc validate_P2sVpnGatewaysCreateOrUpdate_568249(path: JsonNode; query: JsonNode;
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
  var valid_568277 = path.getOrDefault("resourceGroupName")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "resourceGroupName", valid_568277
  var valid_568278 = path.getOrDefault("gatewayName")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "gatewayName", valid_568278
  var valid_568279 = path.getOrDefault("subscriptionId")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "subscriptionId", valid_568279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568280 = query.getOrDefault("api-version")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "api-version", valid_568280
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

proc call*(call_568282: Call_P2sVpnGatewaysCreateOrUpdate_568248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a virtual wan p2s vpn gateway if it doesn't exist else updates the existing gateway.
  ## 
  let valid = call_568282.validator(path, query, header, formData, body)
  let scheme = call_568282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568282.url(scheme.get, call_568282.host, call_568282.base,
                         call_568282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568282, url, valid)

proc call*(call_568283: Call_P2sVpnGatewaysCreateOrUpdate_568248;
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
  var path_568284 = newJObject()
  var query_568285 = newJObject()
  var body_568286 = newJObject()
  add(path_568284, "resourceGroupName", newJString(resourceGroupName))
  add(query_568285, "api-version", newJString(apiVersion))
  add(path_568284, "gatewayName", newJString(gatewayName))
  add(path_568284, "subscriptionId", newJString(subscriptionId))
  if p2SVpnGatewayParameters != nil:
    body_568286 = p2SVpnGatewayParameters
  result = call_568283.call(path_568284, query_568285, nil, nil, body_568286)

var p2sVpnGatewaysCreateOrUpdate* = Call_P2sVpnGatewaysCreateOrUpdate_568248(
    name: "p2sVpnGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/p2svpnGateways/{gatewayName}",
    validator: validate_P2sVpnGatewaysCreateOrUpdate_568249, base: "",
    url: url_P2sVpnGatewaysCreateOrUpdate_568250, schemes: {Scheme.Https})
type
  Call_P2sVpnGatewaysGet_568237 = ref object of OpenApiRestCall_567666
proc url_P2sVpnGatewaysGet_568239(protocol: Scheme; host: string; base: string;
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

proc validate_P2sVpnGatewaysGet_568238(path: JsonNode; query: JsonNode;
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
  var valid_568240 = path.getOrDefault("resourceGroupName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "resourceGroupName", valid_568240
  var valid_568241 = path.getOrDefault("gatewayName")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "gatewayName", valid_568241
  var valid_568242 = path.getOrDefault("subscriptionId")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "subscriptionId", valid_568242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568243 = query.getOrDefault("api-version")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "api-version", valid_568243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568244: Call_P2sVpnGatewaysGet_568237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a virtual wan p2s vpn gateway.
  ## 
  let valid = call_568244.validator(path, query, header, formData, body)
  let scheme = call_568244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568244.url(scheme.get, call_568244.host, call_568244.base,
                         call_568244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568244, url, valid)

proc call*(call_568245: Call_P2sVpnGatewaysGet_568237; resourceGroupName: string;
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
  var path_568246 = newJObject()
  var query_568247 = newJObject()
  add(path_568246, "resourceGroupName", newJString(resourceGroupName))
  add(query_568247, "api-version", newJString(apiVersion))
  add(path_568246, "gatewayName", newJString(gatewayName))
  add(path_568246, "subscriptionId", newJString(subscriptionId))
  result = call_568245.call(path_568246, query_568247, nil, nil, nil)

var p2sVpnGatewaysGet* = Call_P2sVpnGatewaysGet_568237(name: "p2sVpnGatewaysGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/p2svpnGateways/{gatewayName}",
    validator: validate_P2sVpnGatewaysGet_568238, base: "",
    url: url_P2sVpnGatewaysGet_568239, schemes: {Scheme.Https})
type
  Call_P2sVpnGatewaysUpdateTags_568298 = ref object of OpenApiRestCall_567666
proc url_P2sVpnGatewaysUpdateTags_568300(protocol: Scheme; host: string;
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

proc validate_P2sVpnGatewaysUpdateTags_568299(path: JsonNode; query: JsonNode;
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
  var valid_568301 = path.getOrDefault("resourceGroupName")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "resourceGroupName", valid_568301
  var valid_568302 = path.getOrDefault("gatewayName")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "gatewayName", valid_568302
  var valid_568303 = path.getOrDefault("subscriptionId")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "subscriptionId", valid_568303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568304 = query.getOrDefault("api-version")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "api-version", valid_568304
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

proc call*(call_568306: Call_P2sVpnGatewaysUpdateTags_568298; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates virtual wan p2s vpn gateway tags.
  ## 
  let valid = call_568306.validator(path, query, header, formData, body)
  let scheme = call_568306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568306.url(scheme.get, call_568306.host, call_568306.base,
                         call_568306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568306, url, valid)

proc call*(call_568307: Call_P2sVpnGatewaysUpdateTags_568298;
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
  var path_568308 = newJObject()
  var query_568309 = newJObject()
  var body_568310 = newJObject()
  add(path_568308, "resourceGroupName", newJString(resourceGroupName))
  add(query_568309, "api-version", newJString(apiVersion))
  add(path_568308, "gatewayName", newJString(gatewayName))
  add(path_568308, "subscriptionId", newJString(subscriptionId))
  if p2SVpnGatewayParameters != nil:
    body_568310 = p2SVpnGatewayParameters
  result = call_568307.call(path_568308, query_568309, nil, nil, body_568310)

var p2sVpnGatewaysUpdateTags* = Call_P2sVpnGatewaysUpdateTags_568298(
    name: "p2sVpnGatewaysUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/p2svpnGateways/{gatewayName}",
    validator: validate_P2sVpnGatewaysUpdateTags_568299, base: "",
    url: url_P2sVpnGatewaysUpdateTags_568300, schemes: {Scheme.Https})
type
  Call_P2sVpnGatewaysDelete_568287 = ref object of OpenApiRestCall_567666
proc url_P2sVpnGatewaysDelete_568289(protocol: Scheme; host: string; base: string;
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

proc validate_P2sVpnGatewaysDelete_568288(path: JsonNode; query: JsonNode;
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
  var valid_568290 = path.getOrDefault("resourceGroupName")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "resourceGroupName", valid_568290
  var valid_568291 = path.getOrDefault("gatewayName")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "gatewayName", valid_568291
  var valid_568292 = path.getOrDefault("subscriptionId")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "subscriptionId", valid_568292
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568293 = query.getOrDefault("api-version")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "api-version", valid_568293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568294: Call_P2sVpnGatewaysDelete_568287; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a virtual wan p2s vpn gateway.
  ## 
  let valid = call_568294.validator(path, query, header, formData, body)
  let scheme = call_568294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568294.url(scheme.get, call_568294.host, call_568294.base,
                         call_568294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568294, url, valid)

proc call*(call_568295: Call_P2sVpnGatewaysDelete_568287;
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
  var path_568296 = newJObject()
  var query_568297 = newJObject()
  add(path_568296, "resourceGroupName", newJString(resourceGroupName))
  add(query_568297, "api-version", newJString(apiVersion))
  add(path_568296, "gatewayName", newJString(gatewayName))
  add(path_568296, "subscriptionId", newJString(subscriptionId))
  result = call_568295.call(path_568296, query_568297, nil, nil, nil)

var p2sVpnGatewaysDelete* = Call_P2sVpnGatewaysDelete_568287(
    name: "p2sVpnGatewaysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/p2svpnGateways/{gatewayName}",
    validator: validate_P2sVpnGatewaysDelete_568288, base: "",
    url: url_P2sVpnGatewaysDelete_568289, schemes: {Scheme.Https})
type
  Call_P2sVpnGatewaysGenerateVpnProfile_568311 = ref object of OpenApiRestCall_567666
proc url_P2sVpnGatewaysGenerateVpnProfile_568313(protocol: Scheme; host: string;
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

proc validate_P2sVpnGatewaysGenerateVpnProfile_568312(path: JsonNode;
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
  var valid_568314 = path.getOrDefault("resourceGroupName")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "resourceGroupName", valid_568314
  var valid_568315 = path.getOrDefault("gatewayName")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "gatewayName", valid_568315
  var valid_568316 = path.getOrDefault("subscriptionId")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "subscriptionId", valid_568316
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568317 = query.getOrDefault("api-version")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "api-version", valid_568317
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

proc call*(call_568319: Call_P2sVpnGatewaysGenerateVpnProfile_568311;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates VPN profile for P2S client of the P2SVpnGateway in the specified resource group.
  ## 
  let valid = call_568319.validator(path, query, header, formData, body)
  let scheme = call_568319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568319.url(scheme.get, call_568319.host, call_568319.base,
                         call_568319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568319, url, valid)

proc call*(call_568320: Call_P2sVpnGatewaysGenerateVpnProfile_568311;
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
  var path_568321 = newJObject()
  var query_568322 = newJObject()
  var body_568323 = newJObject()
  add(path_568321, "resourceGroupName", newJString(resourceGroupName))
  add(query_568322, "api-version", newJString(apiVersion))
  add(path_568321, "gatewayName", newJString(gatewayName))
  add(path_568321, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568323 = parameters
  result = call_568320.call(path_568321, query_568322, nil, nil, body_568323)

var p2sVpnGatewaysGenerateVpnProfile* = Call_P2sVpnGatewaysGenerateVpnProfile_568311(
    name: "p2sVpnGatewaysGenerateVpnProfile", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/p2svpnGateways/{gatewayName}/generatevpnprofile",
    validator: validate_P2sVpnGatewaysGenerateVpnProfile_568312, base: "",
    url: url_P2sVpnGatewaysGenerateVpnProfile_568313, schemes: {Scheme.Https})
type
  Call_P2sVpnGatewaysGetP2sVpnConnectionHealth_568324 = ref object of OpenApiRestCall_567666
proc url_P2sVpnGatewaysGetP2sVpnConnectionHealth_568326(protocol: Scheme;
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

proc validate_P2sVpnGatewaysGetP2sVpnConnectionHealth_568325(path: JsonNode;
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
  var valid_568327 = path.getOrDefault("resourceGroupName")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "resourceGroupName", valid_568327
  var valid_568328 = path.getOrDefault("gatewayName")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "gatewayName", valid_568328
  var valid_568329 = path.getOrDefault("subscriptionId")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "subscriptionId", valid_568329
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568330 = query.getOrDefault("api-version")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "api-version", valid_568330
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568331: Call_P2sVpnGatewaysGetP2sVpnConnectionHealth_568324;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the connection health of P2S clients of the virtual wan P2SVpnGateway in the specified resource group.
  ## 
  let valid = call_568331.validator(path, query, header, formData, body)
  let scheme = call_568331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568331.url(scheme.get, call_568331.host, call_568331.base,
                         call_568331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568331, url, valid)

proc call*(call_568332: Call_P2sVpnGatewaysGetP2sVpnConnectionHealth_568324;
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
  var path_568333 = newJObject()
  var query_568334 = newJObject()
  add(path_568333, "resourceGroupName", newJString(resourceGroupName))
  add(query_568334, "api-version", newJString(apiVersion))
  add(path_568333, "gatewayName", newJString(gatewayName))
  add(path_568333, "subscriptionId", newJString(subscriptionId))
  result = call_568332.call(path_568333, query_568334, nil, nil, nil)

var p2sVpnGatewaysGetP2sVpnConnectionHealth* = Call_P2sVpnGatewaysGetP2sVpnConnectionHealth_568324(
    name: "p2sVpnGatewaysGetP2sVpnConnectionHealth", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/p2svpnGateways/{gatewayName}/getP2sVpnConnectionHealth",
    validator: validate_P2sVpnGatewaysGetP2sVpnConnectionHealth_568325, base: "",
    url: url_P2sVpnGatewaysGetP2sVpnConnectionHealth_568326,
    schemes: {Scheme.Https})
type
  Call_VirtualHubsListByResourceGroup_568335 = ref object of OpenApiRestCall_567666
proc url_VirtualHubsListByResourceGroup_568337(protocol: Scheme; host: string;
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

proc validate_VirtualHubsListByResourceGroup_568336(path: JsonNode;
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
  var valid_568338 = path.getOrDefault("resourceGroupName")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "resourceGroupName", valid_568338
  var valid_568339 = path.getOrDefault("subscriptionId")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "subscriptionId", valid_568339
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568340 = query.getOrDefault("api-version")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "api-version", valid_568340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568341: Call_VirtualHubsListByResourceGroup_568335; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VirtualHubs in a resource group.
  ## 
  let valid = call_568341.validator(path, query, header, formData, body)
  let scheme = call_568341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568341.url(scheme.get, call_568341.host, call_568341.base,
                         call_568341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568341, url, valid)

proc call*(call_568342: Call_VirtualHubsListByResourceGroup_568335;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualHubsListByResourceGroup
  ## Lists all the VirtualHubs in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualHub.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568343 = newJObject()
  var query_568344 = newJObject()
  add(path_568343, "resourceGroupName", newJString(resourceGroupName))
  add(query_568344, "api-version", newJString(apiVersion))
  add(path_568343, "subscriptionId", newJString(subscriptionId))
  result = call_568342.call(path_568343, query_568344, nil, nil, nil)

var virtualHubsListByResourceGroup* = Call_VirtualHubsListByResourceGroup_568335(
    name: "virtualHubsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs",
    validator: validate_VirtualHubsListByResourceGroup_568336, base: "",
    url: url_VirtualHubsListByResourceGroup_568337, schemes: {Scheme.Https})
type
  Call_VirtualHubsCreateOrUpdate_568356 = ref object of OpenApiRestCall_567666
proc url_VirtualHubsCreateOrUpdate_568358(protocol: Scheme; host: string;
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

proc validate_VirtualHubsCreateOrUpdate_568357(path: JsonNode; query: JsonNode;
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
  var valid_568359 = path.getOrDefault("resourceGroupName")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "resourceGroupName", valid_568359
  var valid_568360 = path.getOrDefault("subscriptionId")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "subscriptionId", valid_568360
  var valid_568361 = path.getOrDefault("virtualHubName")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "virtualHubName", valid_568361
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568362 = query.getOrDefault("api-version")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "api-version", valid_568362
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

proc call*(call_568364: Call_VirtualHubsCreateOrUpdate_568356; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a VirtualHub resource if it doesn't exist else updates the existing VirtualHub.
  ## 
  let valid = call_568364.validator(path, query, header, formData, body)
  let scheme = call_568364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568364.url(scheme.get, call_568364.host, call_568364.base,
                         call_568364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568364, url, valid)

proc call*(call_568365: Call_VirtualHubsCreateOrUpdate_568356;
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
  var path_568366 = newJObject()
  var query_568367 = newJObject()
  var body_568368 = newJObject()
  add(path_568366, "resourceGroupName", newJString(resourceGroupName))
  add(query_568367, "api-version", newJString(apiVersion))
  add(path_568366, "subscriptionId", newJString(subscriptionId))
  add(path_568366, "virtualHubName", newJString(virtualHubName))
  if virtualHubParameters != nil:
    body_568368 = virtualHubParameters
  result = call_568365.call(path_568366, query_568367, nil, nil, body_568368)

var virtualHubsCreateOrUpdate* = Call_VirtualHubsCreateOrUpdate_568356(
    name: "virtualHubsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}",
    validator: validate_VirtualHubsCreateOrUpdate_568357, base: "",
    url: url_VirtualHubsCreateOrUpdate_568358, schemes: {Scheme.Https})
type
  Call_VirtualHubsGet_568345 = ref object of OpenApiRestCall_567666
proc url_VirtualHubsGet_568347(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualHubsGet_568346(path: JsonNode; query: JsonNode;
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
  var valid_568348 = path.getOrDefault("resourceGroupName")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "resourceGroupName", valid_568348
  var valid_568349 = path.getOrDefault("subscriptionId")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "subscriptionId", valid_568349
  var valid_568350 = path.getOrDefault("virtualHubName")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "virtualHubName", valid_568350
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568351 = query.getOrDefault("api-version")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "api-version", valid_568351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568352: Call_VirtualHubsGet_568345; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a VirtualHub.
  ## 
  let valid = call_568352.validator(path, query, header, formData, body)
  let scheme = call_568352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568352.url(scheme.get, call_568352.host, call_568352.base,
                         call_568352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568352, url, valid)

proc call*(call_568353: Call_VirtualHubsGet_568345; resourceGroupName: string;
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
  var path_568354 = newJObject()
  var query_568355 = newJObject()
  add(path_568354, "resourceGroupName", newJString(resourceGroupName))
  add(query_568355, "api-version", newJString(apiVersion))
  add(path_568354, "subscriptionId", newJString(subscriptionId))
  add(path_568354, "virtualHubName", newJString(virtualHubName))
  result = call_568353.call(path_568354, query_568355, nil, nil, nil)

var virtualHubsGet* = Call_VirtualHubsGet_568345(name: "virtualHubsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}",
    validator: validate_VirtualHubsGet_568346, base: "", url: url_VirtualHubsGet_568347,
    schemes: {Scheme.Https})
type
  Call_VirtualHubsUpdateTags_568380 = ref object of OpenApiRestCall_567666
proc url_VirtualHubsUpdateTags_568382(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualHubsUpdateTags_568381(path: JsonNode; query: JsonNode;
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
  var valid_568383 = path.getOrDefault("resourceGroupName")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "resourceGroupName", valid_568383
  var valid_568384 = path.getOrDefault("subscriptionId")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "subscriptionId", valid_568384
  var valid_568385 = path.getOrDefault("virtualHubName")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "virtualHubName", valid_568385
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568386 = query.getOrDefault("api-version")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "api-version", valid_568386
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

proc call*(call_568388: Call_VirtualHubsUpdateTags_568380; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates VirtualHub tags.
  ## 
  let valid = call_568388.validator(path, query, header, formData, body)
  let scheme = call_568388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568388.url(scheme.get, call_568388.host, call_568388.base,
                         call_568388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568388, url, valid)

proc call*(call_568389: Call_VirtualHubsUpdateTags_568380;
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
  var path_568390 = newJObject()
  var query_568391 = newJObject()
  var body_568392 = newJObject()
  add(path_568390, "resourceGroupName", newJString(resourceGroupName))
  add(query_568391, "api-version", newJString(apiVersion))
  add(path_568390, "subscriptionId", newJString(subscriptionId))
  add(path_568390, "virtualHubName", newJString(virtualHubName))
  if virtualHubParameters != nil:
    body_568392 = virtualHubParameters
  result = call_568389.call(path_568390, query_568391, nil, nil, body_568392)

var virtualHubsUpdateTags* = Call_VirtualHubsUpdateTags_568380(
    name: "virtualHubsUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}",
    validator: validate_VirtualHubsUpdateTags_568381, base: "",
    url: url_VirtualHubsUpdateTags_568382, schemes: {Scheme.Https})
type
  Call_VirtualHubsDelete_568369 = ref object of OpenApiRestCall_567666
proc url_VirtualHubsDelete_568371(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualHubsDelete_568370(path: JsonNode; query: JsonNode;
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
  var valid_568372 = path.getOrDefault("resourceGroupName")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "resourceGroupName", valid_568372
  var valid_568373 = path.getOrDefault("subscriptionId")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "subscriptionId", valid_568373
  var valid_568374 = path.getOrDefault("virtualHubName")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "virtualHubName", valid_568374
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568375 = query.getOrDefault("api-version")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "api-version", valid_568375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568376: Call_VirtualHubsDelete_568369; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a VirtualHub.
  ## 
  let valid = call_568376.validator(path, query, header, formData, body)
  let scheme = call_568376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568376.url(scheme.get, call_568376.host, call_568376.base,
                         call_568376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568376, url, valid)

proc call*(call_568377: Call_VirtualHubsDelete_568369; resourceGroupName: string;
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
  var path_568378 = newJObject()
  var query_568379 = newJObject()
  add(path_568378, "resourceGroupName", newJString(resourceGroupName))
  add(query_568379, "api-version", newJString(apiVersion))
  add(path_568378, "subscriptionId", newJString(subscriptionId))
  add(path_568378, "virtualHubName", newJString(virtualHubName))
  result = call_568377.call(path_568378, query_568379, nil, nil, nil)

var virtualHubsDelete* = Call_VirtualHubsDelete_568369(name: "virtualHubsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}",
    validator: validate_VirtualHubsDelete_568370, base: "",
    url: url_VirtualHubsDelete_568371, schemes: {Scheme.Https})
type
  Call_HubVirtualNetworkConnectionsList_568393 = ref object of OpenApiRestCall_567666
proc url_HubVirtualNetworkConnectionsList_568395(protocol: Scheme; host: string;
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

proc validate_HubVirtualNetworkConnectionsList_568394(path: JsonNode;
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
  var valid_568396 = path.getOrDefault("resourceGroupName")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "resourceGroupName", valid_568396
  var valid_568397 = path.getOrDefault("subscriptionId")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "subscriptionId", valid_568397
  var valid_568398 = path.getOrDefault("virtualHubName")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "virtualHubName", valid_568398
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568399 = query.getOrDefault("api-version")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "api-version", valid_568399
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568400: Call_HubVirtualNetworkConnectionsList_568393;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the details of all HubVirtualNetworkConnections.
  ## 
  let valid = call_568400.validator(path, query, header, formData, body)
  let scheme = call_568400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568400.url(scheme.get, call_568400.host, call_568400.base,
                         call_568400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568400, url, valid)

proc call*(call_568401: Call_HubVirtualNetworkConnectionsList_568393;
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
  var path_568402 = newJObject()
  var query_568403 = newJObject()
  add(path_568402, "resourceGroupName", newJString(resourceGroupName))
  add(query_568403, "api-version", newJString(apiVersion))
  add(path_568402, "subscriptionId", newJString(subscriptionId))
  add(path_568402, "virtualHubName", newJString(virtualHubName))
  result = call_568401.call(path_568402, query_568403, nil, nil, nil)

var hubVirtualNetworkConnectionsList* = Call_HubVirtualNetworkConnectionsList_568393(
    name: "hubVirtualNetworkConnectionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}/hubVirtualNetworkConnections",
    validator: validate_HubVirtualNetworkConnectionsList_568394, base: "",
    url: url_HubVirtualNetworkConnectionsList_568395, schemes: {Scheme.Https})
type
  Call_HubVirtualNetworkConnectionsGet_568404 = ref object of OpenApiRestCall_567666
proc url_HubVirtualNetworkConnectionsGet_568406(protocol: Scheme; host: string;
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

proc validate_HubVirtualNetworkConnectionsGet_568405(path: JsonNode;
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
  var valid_568407 = path.getOrDefault("resourceGroupName")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "resourceGroupName", valid_568407
  var valid_568408 = path.getOrDefault("subscriptionId")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "subscriptionId", valid_568408
  var valid_568409 = path.getOrDefault("virtualHubName")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "virtualHubName", valid_568409
  var valid_568410 = path.getOrDefault("connectionName")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "connectionName", valid_568410
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568411 = query.getOrDefault("api-version")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "api-version", valid_568411
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568412: Call_HubVirtualNetworkConnectionsGet_568404;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the details of a HubVirtualNetworkConnection.
  ## 
  let valid = call_568412.validator(path, query, header, formData, body)
  let scheme = call_568412.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568412.url(scheme.get, call_568412.host, call_568412.base,
                         call_568412.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568412, url, valid)

proc call*(call_568413: Call_HubVirtualNetworkConnectionsGet_568404;
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
  var path_568414 = newJObject()
  var query_568415 = newJObject()
  add(path_568414, "resourceGroupName", newJString(resourceGroupName))
  add(query_568415, "api-version", newJString(apiVersion))
  add(path_568414, "subscriptionId", newJString(subscriptionId))
  add(path_568414, "virtualHubName", newJString(virtualHubName))
  add(path_568414, "connectionName", newJString(connectionName))
  result = call_568413.call(path_568414, query_568415, nil, nil, nil)

var hubVirtualNetworkConnectionsGet* = Call_HubVirtualNetworkConnectionsGet_568404(
    name: "hubVirtualNetworkConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}/hubVirtualNetworkConnections/{connectionName}",
    validator: validate_HubVirtualNetworkConnectionsGet_568405, base: "",
    url: url_HubVirtualNetworkConnectionsGet_568406, schemes: {Scheme.Https})
type
  Call_VirtualWansListByResourceGroup_568416 = ref object of OpenApiRestCall_567666
proc url_VirtualWansListByResourceGroup_568418(protocol: Scheme; host: string;
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

proc validate_VirtualWansListByResourceGroup_568417(path: JsonNode;
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
  var valid_568419 = path.getOrDefault("resourceGroupName")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "resourceGroupName", valid_568419
  var valid_568420 = path.getOrDefault("subscriptionId")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "subscriptionId", valid_568420
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568421 = query.getOrDefault("api-version")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "api-version", valid_568421
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568422: Call_VirtualWansListByResourceGroup_568416; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VirtualWANs in a resource group.
  ## 
  let valid = call_568422.validator(path, query, header, formData, body)
  let scheme = call_568422.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568422.url(scheme.get, call_568422.host, call_568422.base,
                         call_568422.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568422, url, valid)

proc call*(call_568423: Call_VirtualWansListByResourceGroup_568416;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualWansListByResourceGroup
  ## Lists all the VirtualWANs in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualWan.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568424 = newJObject()
  var query_568425 = newJObject()
  add(path_568424, "resourceGroupName", newJString(resourceGroupName))
  add(query_568425, "api-version", newJString(apiVersion))
  add(path_568424, "subscriptionId", newJString(subscriptionId))
  result = call_568423.call(path_568424, query_568425, nil, nil, nil)

var virtualWansListByResourceGroup* = Call_VirtualWansListByResourceGroup_568416(
    name: "virtualWansListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans",
    validator: validate_VirtualWansListByResourceGroup_568417, base: "",
    url: url_VirtualWansListByResourceGroup_568418, schemes: {Scheme.Https})
type
  Call_VirtualWansCreateOrUpdate_568437 = ref object of OpenApiRestCall_567666
proc url_VirtualWansCreateOrUpdate_568439(protocol: Scheme; host: string;
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

proc validate_VirtualWansCreateOrUpdate_568438(path: JsonNode; query: JsonNode;
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
  var valid_568440 = path.getOrDefault("resourceGroupName")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = nil)
  if valid_568440 != nil:
    section.add "resourceGroupName", valid_568440
  var valid_568441 = path.getOrDefault("VirtualWANName")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = nil)
  if valid_568441 != nil:
    section.add "VirtualWANName", valid_568441
  var valid_568442 = path.getOrDefault("subscriptionId")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "subscriptionId", valid_568442
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568443 = query.getOrDefault("api-version")
  valid_568443 = validateParameter(valid_568443, JString, required = true,
                                 default = nil)
  if valid_568443 != nil:
    section.add "api-version", valid_568443
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

proc call*(call_568445: Call_VirtualWansCreateOrUpdate_568437; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a VirtualWAN resource if it doesn't exist else updates the existing VirtualWAN.
  ## 
  let valid = call_568445.validator(path, query, header, formData, body)
  let scheme = call_568445.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568445.url(scheme.get, call_568445.host, call_568445.base,
                         call_568445.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568445, url, valid)

proc call*(call_568446: Call_VirtualWansCreateOrUpdate_568437;
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
  var path_568447 = newJObject()
  var query_568448 = newJObject()
  var body_568449 = newJObject()
  add(path_568447, "resourceGroupName", newJString(resourceGroupName))
  add(path_568447, "VirtualWANName", newJString(VirtualWANName))
  add(query_568448, "api-version", newJString(apiVersion))
  add(path_568447, "subscriptionId", newJString(subscriptionId))
  if WANParameters != nil:
    body_568449 = WANParameters
  result = call_568446.call(path_568447, query_568448, nil, nil, body_568449)

var virtualWansCreateOrUpdate* = Call_VirtualWansCreateOrUpdate_568437(
    name: "virtualWansCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{VirtualWANName}",
    validator: validate_VirtualWansCreateOrUpdate_568438, base: "",
    url: url_VirtualWansCreateOrUpdate_568439, schemes: {Scheme.Https})
type
  Call_VirtualWansGet_568426 = ref object of OpenApiRestCall_567666
proc url_VirtualWansGet_568428(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualWansGet_568427(path: JsonNode; query: JsonNode;
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
  var valid_568429 = path.getOrDefault("resourceGroupName")
  valid_568429 = validateParameter(valid_568429, JString, required = true,
                                 default = nil)
  if valid_568429 != nil:
    section.add "resourceGroupName", valid_568429
  var valid_568430 = path.getOrDefault("VirtualWANName")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "VirtualWANName", valid_568430
  var valid_568431 = path.getOrDefault("subscriptionId")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "subscriptionId", valid_568431
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568432 = query.getOrDefault("api-version")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "api-version", valid_568432
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568433: Call_VirtualWansGet_568426; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a VirtualWAN.
  ## 
  let valid = call_568433.validator(path, query, header, formData, body)
  let scheme = call_568433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568433.url(scheme.get, call_568433.host, call_568433.base,
                         call_568433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568433, url, valid)

proc call*(call_568434: Call_VirtualWansGet_568426; resourceGroupName: string;
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
  var path_568435 = newJObject()
  var query_568436 = newJObject()
  add(path_568435, "resourceGroupName", newJString(resourceGroupName))
  add(path_568435, "VirtualWANName", newJString(VirtualWANName))
  add(query_568436, "api-version", newJString(apiVersion))
  add(path_568435, "subscriptionId", newJString(subscriptionId))
  result = call_568434.call(path_568435, query_568436, nil, nil, nil)

var virtualWansGet* = Call_VirtualWansGet_568426(name: "virtualWansGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{VirtualWANName}",
    validator: validate_VirtualWansGet_568427, base: "", url: url_VirtualWansGet_568428,
    schemes: {Scheme.Https})
type
  Call_VirtualWansUpdateTags_568461 = ref object of OpenApiRestCall_567666
proc url_VirtualWansUpdateTags_568463(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualWansUpdateTags_568462(path: JsonNode; query: JsonNode;
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
  var valid_568464 = path.getOrDefault("resourceGroupName")
  valid_568464 = validateParameter(valid_568464, JString, required = true,
                                 default = nil)
  if valid_568464 != nil:
    section.add "resourceGroupName", valid_568464
  var valid_568465 = path.getOrDefault("VirtualWANName")
  valid_568465 = validateParameter(valid_568465, JString, required = true,
                                 default = nil)
  if valid_568465 != nil:
    section.add "VirtualWANName", valid_568465
  var valid_568466 = path.getOrDefault("subscriptionId")
  valid_568466 = validateParameter(valid_568466, JString, required = true,
                                 default = nil)
  if valid_568466 != nil:
    section.add "subscriptionId", valid_568466
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568467 = query.getOrDefault("api-version")
  valid_568467 = validateParameter(valid_568467, JString, required = true,
                                 default = nil)
  if valid_568467 != nil:
    section.add "api-version", valid_568467
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

proc call*(call_568469: Call_VirtualWansUpdateTags_568461; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a VirtualWAN tags.
  ## 
  let valid = call_568469.validator(path, query, header, formData, body)
  let scheme = call_568469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568469.url(scheme.get, call_568469.host, call_568469.base,
                         call_568469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568469, url, valid)

proc call*(call_568470: Call_VirtualWansUpdateTags_568461;
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
  var path_568471 = newJObject()
  var query_568472 = newJObject()
  var body_568473 = newJObject()
  add(path_568471, "resourceGroupName", newJString(resourceGroupName))
  add(path_568471, "VirtualWANName", newJString(VirtualWANName))
  add(query_568472, "api-version", newJString(apiVersion))
  add(path_568471, "subscriptionId", newJString(subscriptionId))
  if WANParameters != nil:
    body_568473 = WANParameters
  result = call_568470.call(path_568471, query_568472, nil, nil, body_568473)

var virtualWansUpdateTags* = Call_VirtualWansUpdateTags_568461(
    name: "virtualWansUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{VirtualWANName}",
    validator: validate_VirtualWansUpdateTags_568462, base: "",
    url: url_VirtualWansUpdateTags_568463, schemes: {Scheme.Https})
type
  Call_VirtualWansDelete_568450 = ref object of OpenApiRestCall_567666
proc url_VirtualWansDelete_568452(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualWansDelete_568451(path: JsonNode; query: JsonNode;
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
  var valid_568453 = path.getOrDefault("resourceGroupName")
  valid_568453 = validateParameter(valid_568453, JString, required = true,
                                 default = nil)
  if valid_568453 != nil:
    section.add "resourceGroupName", valid_568453
  var valid_568454 = path.getOrDefault("VirtualWANName")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = nil)
  if valid_568454 != nil:
    section.add "VirtualWANName", valid_568454
  var valid_568455 = path.getOrDefault("subscriptionId")
  valid_568455 = validateParameter(valid_568455, JString, required = true,
                                 default = nil)
  if valid_568455 != nil:
    section.add "subscriptionId", valid_568455
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568456 = query.getOrDefault("api-version")
  valid_568456 = validateParameter(valid_568456, JString, required = true,
                                 default = nil)
  if valid_568456 != nil:
    section.add "api-version", valid_568456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568457: Call_VirtualWansDelete_568450; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a VirtualWAN.
  ## 
  let valid = call_568457.validator(path, query, header, formData, body)
  let scheme = call_568457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568457.url(scheme.get, call_568457.host, call_568457.base,
                         call_568457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568457, url, valid)

proc call*(call_568458: Call_VirtualWansDelete_568450; resourceGroupName: string;
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
  var path_568459 = newJObject()
  var query_568460 = newJObject()
  add(path_568459, "resourceGroupName", newJString(resourceGroupName))
  add(path_568459, "VirtualWANName", newJString(VirtualWANName))
  add(query_568460, "api-version", newJString(apiVersion))
  add(path_568459, "subscriptionId", newJString(subscriptionId))
  result = call_568458.call(path_568459, query_568460, nil, nil, nil)

var virtualWansDelete* = Call_VirtualWansDelete_568450(name: "virtualWansDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{VirtualWANName}",
    validator: validate_VirtualWansDelete_568451, base: "",
    url: url_VirtualWansDelete_568452, schemes: {Scheme.Https})
type
  Call_SupportedSecurityProviders_568474 = ref object of OpenApiRestCall_567666
proc url_SupportedSecurityProviders_568476(protocol: Scheme; host: string;
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

proc validate_SupportedSecurityProviders_568475(path: JsonNode; query: JsonNode;
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
  var valid_568477 = path.getOrDefault("resourceGroupName")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = nil)
  if valid_568477 != nil:
    section.add "resourceGroupName", valid_568477
  var valid_568478 = path.getOrDefault("subscriptionId")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "subscriptionId", valid_568478
  var valid_568479 = path.getOrDefault("virtualWANName")
  valid_568479 = validateParameter(valid_568479, JString, required = true,
                                 default = nil)
  if valid_568479 != nil:
    section.add "virtualWANName", valid_568479
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568480 = query.getOrDefault("api-version")
  valid_568480 = validateParameter(valid_568480, JString, required = true,
                                 default = nil)
  if valid_568480 != nil:
    section.add "api-version", valid_568480
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568481: Call_SupportedSecurityProviders_568474; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gives the supported security providers for the virtual wan.
  ## 
  let valid = call_568481.validator(path, query, header, formData, body)
  let scheme = call_568481.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568481.url(scheme.get, call_568481.host, call_568481.base,
                         call_568481.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568481, url, valid)

proc call*(call_568482: Call_SupportedSecurityProviders_568474;
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
  var path_568483 = newJObject()
  var query_568484 = newJObject()
  add(path_568483, "resourceGroupName", newJString(resourceGroupName))
  add(query_568484, "api-version", newJString(apiVersion))
  add(path_568483, "subscriptionId", newJString(subscriptionId))
  add(path_568483, "virtualWANName", newJString(virtualWANName))
  result = call_568482.call(path_568483, query_568484, nil, nil, nil)

var supportedSecurityProviders* = Call_SupportedSecurityProviders_568474(
    name: "supportedSecurityProviders", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{virtualWANName}/supportedSecurityProviders",
    validator: validate_SupportedSecurityProviders_568475, base: "",
    url: url_SupportedSecurityProviders_568476, schemes: {Scheme.Https})
type
  Call_VpnSitesConfigurationDownload_568485 = ref object of OpenApiRestCall_567666
proc url_VpnSitesConfigurationDownload_568487(protocol: Scheme; host: string;
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

proc validate_VpnSitesConfigurationDownload_568486(path: JsonNode; query: JsonNode;
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
  var valid_568488 = path.getOrDefault("resourceGroupName")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "resourceGroupName", valid_568488
  var valid_568489 = path.getOrDefault("subscriptionId")
  valid_568489 = validateParameter(valid_568489, JString, required = true,
                                 default = nil)
  if valid_568489 != nil:
    section.add "subscriptionId", valid_568489
  var valid_568490 = path.getOrDefault("virtualWANName")
  valid_568490 = validateParameter(valid_568490, JString, required = true,
                                 default = nil)
  if valid_568490 != nil:
    section.add "virtualWANName", valid_568490
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568491 = query.getOrDefault("api-version")
  valid_568491 = validateParameter(valid_568491, JString, required = true,
                                 default = nil)
  if valid_568491 != nil:
    section.add "api-version", valid_568491
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

proc call*(call_568493: Call_VpnSitesConfigurationDownload_568485; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gives the sas-url to download the configurations for vpn-sites in a resource group.
  ## 
  let valid = call_568493.validator(path, query, header, formData, body)
  let scheme = call_568493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568493.url(scheme.get, call_568493.host, call_568493.base,
                         call_568493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568493, url, valid)

proc call*(call_568494: Call_VpnSitesConfigurationDownload_568485;
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
  var path_568495 = newJObject()
  var query_568496 = newJObject()
  var body_568497 = newJObject()
  add(path_568495, "resourceGroupName", newJString(resourceGroupName))
  add(query_568496, "api-version", newJString(apiVersion))
  add(path_568495, "subscriptionId", newJString(subscriptionId))
  if request != nil:
    body_568497 = request
  add(path_568495, "virtualWANName", newJString(virtualWANName))
  result = call_568494.call(path_568495, query_568496, nil, nil, body_568497)

var vpnSitesConfigurationDownload* = Call_VpnSitesConfigurationDownload_568485(
    name: "vpnSitesConfigurationDownload", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{virtualWANName}/vpnConfiguration",
    validator: validate_VpnSitesConfigurationDownload_568486, base: "",
    url: url_VpnSitesConfigurationDownload_568487, schemes: {Scheme.Https})
type
  Call_P2sVpnServerConfigurationsListByVirtualWan_568498 = ref object of OpenApiRestCall_567666
proc url_P2sVpnServerConfigurationsListByVirtualWan_568500(protocol: Scheme;
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

proc validate_P2sVpnServerConfigurationsListByVirtualWan_568499(path: JsonNode;
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
  var valid_568501 = path.getOrDefault("resourceGroupName")
  valid_568501 = validateParameter(valid_568501, JString, required = true,
                                 default = nil)
  if valid_568501 != nil:
    section.add "resourceGroupName", valid_568501
  var valid_568502 = path.getOrDefault("virtualWanName")
  valid_568502 = validateParameter(valid_568502, JString, required = true,
                                 default = nil)
  if valid_568502 != nil:
    section.add "virtualWanName", valid_568502
  var valid_568503 = path.getOrDefault("subscriptionId")
  valid_568503 = validateParameter(valid_568503, JString, required = true,
                                 default = nil)
  if valid_568503 != nil:
    section.add "subscriptionId", valid_568503
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568504 = query.getOrDefault("api-version")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "api-version", valid_568504
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568505: Call_P2sVpnServerConfigurationsListByVirtualWan_568498;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all P2SVpnServerConfigurations for a particular VirtualWan.
  ## 
  let valid = call_568505.validator(path, query, header, formData, body)
  let scheme = call_568505.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568505.url(scheme.get, call_568505.host, call_568505.base,
                         call_568505.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568505, url, valid)

proc call*(call_568506: Call_P2sVpnServerConfigurationsListByVirtualWan_568498;
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
  var path_568507 = newJObject()
  var query_568508 = newJObject()
  add(path_568507, "resourceGroupName", newJString(resourceGroupName))
  add(query_568508, "api-version", newJString(apiVersion))
  add(path_568507, "virtualWanName", newJString(virtualWanName))
  add(path_568507, "subscriptionId", newJString(subscriptionId))
  result = call_568506.call(path_568507, query_568508, nil, nil, nil)

var p2sVpnServerConfigurationsListByVirtualWan* = Call_P2sVpnServerConfigurationsListByVirtualWan_568498(
    name: "p2sVpnServerConfigurationsListByVirtualWan", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{virtualWanName}/p2sVpnServerConfigurations",
    validator: validate_P2sVpnServerConfigurationsListByVirtualWan_568499,
    base: "", url: url_P2sVpnServerConfigurationsListByVirtualWan_568500,
    schemes: {Scheme.Https})
type
  Call_P2sVpnServerConfigurationsCreateOrUpdate_568521 = ref object of OpenApiRestCall_567666
proc url_P2sVpnServerConfigurationsCreateOrUpdate_568523(protocol: Scheme;
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

proc validate_P2sVpnServerConfigurationsCreateOrUpdate_568522(path: JsonNode;
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
  var valid_568524 = path.getOrDefault("resourceGroupName")
  valid_568524 = validateParameter(valid_568524, JString, required = true,
                                 default = nil)
  if valid_568524 != nil:
    section.add "resourceGroupName", valid_568524
  var valid_568525 = path.getOrDefault("virtualWanName")
  valid_568525 = validateParameter(valid_568525, JString, required = true,
                                 default = nil)
  if valid_568525 != nil:
    section.add "virtualWanName", valid_568525
  var valid_568526 = path.getOrDefault("p2SVpnServerConfigurationName")
  valid_568526 = validateParameter(valid_568526, JString, required = true,
                                 default = nil)
  if valid_568526 != nil:
    section.add "p2SVpnServerConfigurationName", valid_568526
  var valid_568527 = path.getOrDefault("subscriptionId")
  valid_568527 = validateParameter(valid_568527, JString, required = true,
                                 default = nil)
  if valid_568527 != nil:
    section.add "subscriptionId", valid_568527
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568528 = query.getOrDefault("api-version")
  valid_568528 = validateParameter(valid_568528, JString, required = true,
                                 default = nil)
  if valid_568528 != nil:
    section.add "api-version", valid_568528
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

proc call*(call_568530: Call_P2sVpnServerConfigurationsCreateOrUpdate_568521;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a P2SVpnServerConfiguration to associate with a VirtualWan if it doesn't exist else updates the existing P2SVpnServerConfiguration.
  ## 
  let valid = call_568530.validator(path, query, header, formData, body)
  let scheme = call_568530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568530.url(scheme.get, call_568530.host, call_568530.base,
                         call_568530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568530, url, valid)

proc call*(call_568531: Call_P2sVpnServerConfigurationsCreateOrUpdate_568521;
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
  var path_568532 = newJObject()
  var query_568533 = newJObject()
  var body_568534 = newJObject()
  add(path_568532, "resourceGroupName", newJString(resourceGroupName))
  add(query_568533, "api-version", newJString(apiVersion))
  add(path_568532, "virtualWanName", newJString(virtualWanName))
  add(path_568532, "p2SVpnServerConfigurationName",
      newJString(p2SVpnServerConfigurationName))
  add(path_568532, "subscriptionId", newJString(subscriptionId))
  if p2SVpnServerConfigurationParameters != nil:
    body_568534 = p2SVpnServerConfigurationParameters
  result = call_568531.call(path_568532, query_568533, nil, nil, body_568534)

var p2sVpnServerConfigurationsCreateOrUpdate* = Call_P2sVpnServerConfigurationsCreateOrUpdate_568521(
    name: "p2sVpnServerConfigurationsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{virtualWanName}/p2sVpnServerConfigurations/{p2SVpnServerConfigurationName}",
    validator: validate_P2sVpnServerConfigurationsCreateOrUpdate_568522, base: "",
    url: url_P2sVpnServerConfigurationsCreateOrUpdate_568523,
    schemes: {Scheme.Https})
type
  Call_P2sVpnServerConfigurationsGet_568509 = ref object of OpenApiRestCall_567666
proc url_P2sVpnServerConfigurationsGet_568511(protocol: Scheme; host: string;
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

proc validate_P2sVpnServerConfigurationsGet_568510(path: JsonNode; query: JsonNode;
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
  var valid_568512 = path.getOrDefault("resourceGroupName")
  valid_568512 = validateParameter(valid_568512, JString, required = true,
                                 default = nil)
  if valid_568512 != nil:
    section.add "resourceGroupName", valid_568512
  var valid_568513 = path.getOrDefault("virtualWanName")
  valid_568513 = validateParameter(valid_568513, JString, required = true,
                                 default = nil)
  if valid_568513 != nil:
    section.add "virtualWanName", valid_568513
  var valid_568514 = path.getOrDefault("p2SVpnServerConfigurationName")
  valid_568514 = validateParameter(valid_568514, JString, required = true,
                                 default = nil)
  if valid_568514 != nil:
    section.add "p2SVpnServerConfigurationName", valid_568514
  var valid_568515 = path.getOrDefault("subscriptionId")
  valid_568515 = validateParameter(valid_568515, JString, required = true,
                                 default = nil)
  if valid_568515 != nil:
    section.add "subscriptionId", valid_568515
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568516 = query.getOrDefault("api-version")
  valid_568516 = validateParameter(valid_568516, JString, required = true,
                                 default = nil)
  if valid_568516 != nil:
    section.add "api-version", valid_568516
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568517: Call_P2sVpnServerConfigurationsGet_568509; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a P2SVpnServerConfiguration.
  ## 
  let valid = call_568517.validator(path, query, header, formData, body)
  let scheme = call_568517.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568517.url(scheme.get, call_568517.host, call_568517.base,
                         call_568517.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568517, url, valid)

proc call*(call_568518: Call_P2sVpnServerConfigurationsGet_568509;
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
  var path_568519 = newJObject()
  var query_568520 = newJObject()
  add(path_568519, "resourceGroupName", newJString(resourceGroupName))
  add(query_568520, "api-version", newJString(apiVersion))
  add(path_568519, "virtualWanName", newJString(virtualWanName))
  add(path_568519, "p2SVpnServerConfigurationName",
      newJString(p2SVpnServerConfigurationName))
  add(path_568519, "subscriptionId", newJString(subscriptionId))
  result = call_568518.call(path_568519, query_568520, nil, nil, nil)

var p2sVpnServerConfigurationsGet* = Call_P2sVpnServerConfigurationsGet_568509(
    name: "p2sVpnServerConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{virtualWanName}/p2sVpnServerConfigurations/{p2SVpnServerConfigurationName}",
    validator: validate_P2sVpnServerConfigurationsGet_568510, base: "",
    url: url_P2sVpnServerConfigurationsGet_568511, schemes: {Scheme.Https})
type
  Call_P2sVpnServerConfigurationsDelete_568535 = ref object of OpenApiRestCall_567666
proc url_P2sVpnServerConfigurationsDelete_568537(protocol: Scheme; host: string;
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

proc validate_P2sVpnServerConfigurationsDelete_568536(path: JsonNode;
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
  var valid_568538 = path.getOrDefault("resourceGroupName")
  valid_568538 = validateParameter(valid_568538, JString, required = true,
                                 default = nil)
  if valid_568538 != nil:
    section.add "resourceGroupName", valid_568538
  var valid_568539 = path.getOrDefault("virtualWanName")
  valid_568539 = validateParameter(valid_568539, JString, required = true,
                                 default = nil)
  if valid_568539 != nil:
    section.add "virtualWanName", valid_568539
  var valid_568540 = path.getOrDefault("p2SVpnServerConfigurationName")
  valid_568540 = validateParameter(valid_568540, JString, required = true,
                                 default = nil)
  if valid_568540 != nil:
    section.add "p2SVpnServerConfigurationName", valid_568540
  var valid_568541 = path.getOrDefault("subscriptionId")
  valid_568541 = validateParameter(valid_568541, JString, required = true,
                                 default = nil)
  if valid_568541 != nil:
    section.add "subscriptionId", valid_568541
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568542 = query.getOrDefault("api-version")
  valid_568542 = validateParameter(valid_568542, JString, required = true,
                                 default = nil)
  if valid_568542 != nil:
    section.add "api-version", valid_568542
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568543: Call_P2sVpnServerConfigurationsDelete_568535;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a P2SVpnServerConfiguration.
  ## 
  let valid = call_568543.validator(path, query, header, formData, body)
  let scheme = call_568543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568543.url(scheme.get, call_568543.host, call_568543.base,
                         call_568543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568543, url, valid)

proc call*(call_568544: Call_P2sVpnServerConfigurationsDelete_568535;
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
  var path_568545 = newJObject()
  var query_568546 = newJObject()
  add(path_568545, "resourceGroupName", newJString(resourceGroupName))
  add(query_568546, "api-version", newJString(apiVersion))
  add(path_568545, "virtualWanName", newJString(virtualWanName))
  add(path_568545, "p2SVpnServerConfigurationName",
      newJString(p2SVpnServerConfigurationName))
  add(path_568545, "subscriptionId", newJString(subscriptionId))
  result = call_568544.call(path_568545, query_568546, nil, nil, nil)

var p2sVpnServerConfigurationsDelete* = Call_P2sVpnServerConfigurationsDelete_568535(
    name: "p2sVpnServerConfigurationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{virtualWanName}/p2sVpnServerConfigurations/{p2SVpnServerConfigurationName}",
    validator: validate_P2sVpnServerConfigurationsDelete_568536, base: "",
    url: url_P2sVpnServerConfigurationsDelete_568537, schemes: {Scheme.Https})
type
  Call_VpnGatewaysListByResourceGroup_568547 = ref object of OpenApiRestCall_567666
proc url_VpnGatewaysListByResourceGroup_568549(protocol: Scheme; host: string;
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

proc validate_VpnGatewaysListByResourceGroup_568548(path: JsonNode;
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
  var valid_568550 = path.getOrDefault("resourceGroupName")
  valid_568550 = validateParameter(valid_568550, JString, required = true,
                                 default = nil)
  if valid_568550 != nil:
    section.add "resourceGroupName", valid_568550
  var valid_568551 = path.getOrDefault("subscriptionId")
  valid_568551 = validateParameter(valid_568551, JString, required = true,
                                 default = nil)
  if valid_568551 != nil:
    section.add "subscriptionId", valid_568551
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568552 = query.getOrDefault("api-version")
  valid_568552 = validateParameter(valid_568552, JString, required = true,
                                 default = nil)
  if valid_568552 != nil:
    section.add "api-version", valid_568552
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568553: Call_VpnGatewaysListByResourceGroup_568547; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VpnGateways in a resource group.
  ## 
  let valid = call_568553.validator(path, query, header, formData, body)
  let scheme = call_568553.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568553.url(scheme.get, call_568553.host, call_568553.base,
                         call_568553.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568553, url, valid)

proc call*(call_568554: Call_VpnGatewaysListByResourceGroup_568547;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## vpnGatewaysListByResourceGroup
  ## Lists all the VpnGateways in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnGateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568555 = newJObject()
  var query_568556 = newJObject()
  add(path_568555, "resourceGroupName", newJString(resourceGroupName))
  add(query_568556, "api-version", newJString(apiVersion))
  add(path_568555, "subscriptionId", newJString(subscriptionId))
  result = call_568554.call(path_568555, query_568556, nil, nil, nil)

var vpnGatewaysListByResourceGroup* = Call_VpnGatewaysListByResourceGroup_568547(
    name: "vpnGatewaysListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways",
    validator: validate_VpnGatewaysListByResourceGroup_568548, base: "",
    url: url_VpnGatewaysListByResourceGroup_568549, schemes: {Scheme.Https})
type
  Call_VpnGatewaysCreateOrUpdate_568568 = ref object of OpenApiRestCall_567666
proc url_VpnGatewaysCreateOrUpdate_568570(protocol: Scheme; host: string;
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

proc validate_VpnGatewaysCreateOrUpdate_568569(path: JsonNode; query: JsonNode;
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
  var valid_568571 = path.getOrDefault("resourceGroupName")
  valid_568571 = validateParameter(valid_568571, JString, required = true,
                                 default = nil)
  if valid_568571 != nil:
    section.add "resourceGroupName", valid_568571
  var valid_568572 = path.getOrDefault("gatewayName")
  valid_568572 = validateParameter(valid_568572, JString, required = true,
                                 default = nil)
  if valid_568572 != nil:
    section.add "gatewayName", valid_568572
  var valid_568573 = path.getOrDefault("subscriptionId")
  valid_568573 = validateParameter(valid_568573, JString, required = true,
                                 default = nil)
  if valid_568573 != nil:
    section.add "subscriptionId", valid_568573
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568574 = query.getOrDefault("api-version")
  valid_568574 = validateParameter(valid_568574, JString, required = true,
                                 default = nil)
  if valid_568574 != nil:
    section.add "api-version", valid_568574
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

proc call*(call_568576: Call_VpnGatewaysCreateOrUpdate_568568; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a virtual wan vpn gateway if it doesn't exist else updates the existing gateway.
  ## 
  let valid = call_568576.validator(path, query, header, formData, body)
  let scheme = call_568576.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568576.url(scheme.get, call_568576.host, call_568576.base,
                         call_568576.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568576, url, valid)

proc call*(call_568577: Call_VpnGatewaysCreateOrUpdate_568568;
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
  var path_568578 = newJObject()
  var query_568579 = newJObject()
  var body_568580 = newJObject()
  add(path_568578, "resourceGroupName", newJString(resourceGroupName))
  add(query_568579, "api-version", newJString(apiVersion))
  add(path_568578, "gatewayName", newJString(gatewayName))
  add(path_568578, "subscriptionId", newJString(subscriptionId))
  if vpnGatewayParameters != nil:
    body_568580 = vpnGatewayParameters
  result = call_568577.call(path_568578, query_568579, nil, nil, body_568580)

var vpnGatewaysCreateOrUpdate* = Call_VpnGatewaysCreateOrUpdate_568568(
    name: "vpnGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}",
    validator: validate_VpnGatewaysCreateOrUpdate_568569, base: "",
    url: url_VpnGatewaysCreateOrUpdate_568570, schemes: {Scheme.Https})
type
  Call_VpnGatewaysGet_568557 = ref object of OpenApiRestCall_567666
proc url_VpnGatewaysGet_568559(protocol: Scheme; host: string; base: string;
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

proc validate_VpnGatewaysGet_568558(path: JsonNode; query: JsonNode;
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
  var valid_568560 = path.getOrDefault("resourceGroupName")
  valid_568560 = validateParameter(valid_568560, JString, required = true,
                                 default = nil)
  if valid_568560 != nil:
    section.add "resourceGroupName", valid_568560
  var valid_568561 = path.getOrDefault("gatewayName")
  valid_568561 = validateParameter(valid_568561, JString, required = true,
                                 default = nil)
  if valid_568561 != nil:
    section.add "gatewayName", valid_568561
  var valid_568562 = path.getOrDefault("subscriptionId")
  valid_568562 = validateParameter(valid_568562, JString, required = true,
                                 default = nil)
  if valid_568562 != nil:
    section.add "subscriptionId", valid_568562
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568563 = query.getOrDefault("api-version")
  valid_568563 = validateParameter(valid_568563, JString, required = true,
                                 default = nil)
  if valid_568563 != nil:
    section.add "api-version", valid_568563
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568564: Call_VpnGatewaysGet_568557; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a virtual wan vpn gateway.
  ## 
  let valid = call_568564.validator(path, query, header, formData, body)
  let scheme = call_568564.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568564.url(scheme.get, call_568564.host, call_568564.base,
                         call_568564.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568564, url, valid)

proc call*(call_568565: Call_VpnGatewaysGet_568557; resourceGroupName: string;
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
  var path_568566 = newJObject()
  var query_568567 = newJObject()
  add(path_568566, "resourceGroupName", newJString(resourceGroupName))
  add(query_568567, "api-version", newJString(apiVersion))
  add(path_568566, "gatewayName", newJString(gatewayName))
  add(path_568566, "subscriptionId", newJString(subscriptionId))
  result = call_568565.call(path_568566, query_568567, nil, nil, nil)

var vpnGatewaysGet* = Call_VpnGatewaysGet_568557(name: "vpnGatewaysGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}",
    validator: validate_VpnGatewaysGet_568558, base: "", url: url_VpnGatewaysGet_568559,
    schemes: {Scheme.Https})
type
  Call_VpnGatewaysUpdateTags_568592 = ref object of OpenApiRestCall_567666
proc url_VpnGatewaysUpdateTags_568594(protocol: Scheme; host: string; base: string;
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

proc validate_VpnGatewaysUpdateTags_568593(path: JsonNode; query: JsonNode;
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
  var valid_568595 = path.getOrDefault("resourceGroupName")
  valid_568595 = validateParameter(valid_568595, JString, required = true,
                                 default = nil)
  if valid_568595 != nil:
    section.add "resourceGroupName", valid_568595
  var valid_568596 = path.getOrDefault("gatewayName")
  valid_568596 = validateParameter(valid_568596, JString, required = true,
                                 default = nil)
  if valid_568596 != nil:
    section.add "gatewayName", valid_568596
  var valid_568597 = path.getOrDefault("subscriptionId")
  valid_568597 = validateParameter(valid_568597, JString, required = true,
                                 default = nil)
  if valid_568597 != nil:
    section.add "subscriptionId", valid_568597
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568598 = query.getOrDefault("api-version")
  valid_568598 = validateParameter(valid_568598, JString, required = true,
                                 default = nil)
  if valid_568598 != nil:
    section.add "api-version", valid_568598
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

proc call*(call_568600: Call_VpnGatewaysUpdateTags_568592; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates virtual wan vpn gateway tags.
  ## 
  let valid = call_568600.validator(path, query, header, formData, body)
  let scheme = call_568600.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568600.url(scheme.get, call_568600.host, call_568600.base,
                         call_568600.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568600, url, valid)

proc call*(call_568601: Call_VpnGatewaysUpdateTags_568592;
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
  var path_568602 = newJObject()
  var query_568603 = newJObject()
  var body_568604 = newJObject()
  add(path_568602, "resourceGroupName", newJString(resourceGroupName))
  add(query_568603, "api-version", newJString(apiVersion))
  add(path_568602, "gatewayName", newJString(gatewayName))
  add(path_568602, "subscriptionId", newJString(subscriptionId))
  if vpnGatewayParameters != nil:
    body_568604 = vpnGatewayParameters
  result = call_568601.call(path_568602, query_568603, nil, nil, body_568604)

var vpnGatewaysUpdateTags* = Call_VpnGatewaysUpdateTags_568592(
    name: "vpnGatewaysUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}",
    validator: validate_VpnGatewaysUpdateTags_568593, base: "",
    url: url_VpnGatewaysUpdateTags_568594, schemes: {Scheme.Https})
type
  Call_VpnGatewaysDelete_568581 = ref object of OpenApiRestCall_567666
proc url_VpnGatewaysDelete_568583(protocol: Scheme; host: string; base: string;
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

proc validate_VpnGatewaysDelete_568582(path: JsonNode; query: JsonNode;
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
  var valid_568584 = path.getOrDefault("resourceGroupName")
  valid_568584 = validateParameter(valid_568584, JString, required = true,
                                 default = nil)
  if valid_568584 != nil:
    section.add "resourceGroupName", valid_568584
  var valid_568585 = path.getOrDefault("gatewayName")
  valid_568585 = validateParameter(valid_568585, JString, required = true,
                                 default = nil)
  if valid_568585 != nil:
    section.add "gatewayName", valid_568585
  var valid_568586 = path.getOrDefault("subscriptionId")
  valid_568586 = validateParameter(valid_568586, JString, required = true,
                                 default = nil)
  if valid_568586 != nil:
    section.add "subscriptionId", valid_568586
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568587 = query.getOrDefault("api-version")
  valid_568587 = validateParameter(valid_568587, JString, required = true,
                                 default = nil)
  if valid_568587 != nil:
    section.add "api-version", valid_568587
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568588: Call_VpnGatewaysDelete_568581; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a virtual wan vpn gateway.
  ## 
  let valid = call_568588.validator(path, query, header, formData, body)
  let scheme = call_568588.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568588.url(scheme.get, call_568588.host, call_568588.base,
                         call_568588.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568588, url, valid)

proc call*(call_568589: Call_VpnGatewaysDelete_568581; resourceGroupName: string;
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
  var path_568590 = newJObject()
  var query_568591 = newJObject()
  add(path_568590, "resourceGroupName", newJString(resourceGroupName))
  add(query_568591, "api-version", newJString(apiVersion))
  add(path_568590, "gatewayName", newJString(gatewayName))
  add(path_568590, "subscriptionId", newJString(subscriptionId))
  result = call_568589.call(path_568590, query_568591, nil, nil, nil)

var vpnGatewaysDelete* = Call_VpnGatewaysDelete_568581(name: "vpnGatewaysDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}",
    validator: validate_VpnGatewaysDelete_568582, base: "",
    url: url_VpnGatewaysDelete_568583, schemes: {Scheme.Https})
type
  Call_VpnGatewaysReset_568605 = ref object of OpenApiRestCall_567666
proc url_VpnGatewaysReset_568607(protocol: Scheme; host: string; base: string;
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

proc validate_VpnGatewaysReset_568606(path: JsonNode; query: JsonNode;
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
  var valid_568608 = path.getOrDefault("resourceGroupName")
  valid_568608 = validateParameter(valid_568608, JString, required = true,
                                 default = nil)
  if valid_568608 != nil:
    section.add "resourceGroupName", valid_568608
  var valid_568609 = path.getOrDefault("gatewayName")
  valid_568609 = validateParameter(valid_568609, JString, required = true,
                                 default = nil)
  if valid_568609 != nil:
    section.add "gatewayName", valid_568609
  var valid_568610 = path.getOrDefault("subscriptionId")
  valid_568610 = validateParameter(valid_568610, JString, required = true,
                                 default = nil)
  if valid_568610 != nil:
    section.add "subscriptionId", valid_568610
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568611 = query.getOrDefault("api-version")
  valid_568611 = validateParameter(valid_568611, JString, required = true,
                                 default = nil)
  if valid_568611 != nil:
    section.add "api-version", valid_568611
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568612: Call_VpnGatewaysReset_568605; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets the primary of the vpn gateway in the specified resource group.
  ## 
  let valid = call_568612.validator(path, query, header, formData, body)
  let scheme = call_568612.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568612.url(scheme.get, call_568612.host, call_568612.base,
                         call_568612.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568612, url, valid)

proc call*(call_568613: Call_VpnGatewaysReset_568605; resourceGroupName: string;
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
  var path_568614 = newJObject()
  var query_568615 = newJObject()
  add(path_568614, "resourceGroupName", newJString(resourceGroupName))
  add(query_568615, "api-version", newJString(apiVersion))
  add(path_568614, "gatewayName", newJString(gatewayName))
  add(path_568614, "subscriptionId", newJString(subscriptionId))
  result = call_568613.call(path_568614, query_568615, nil, nil, nil)

var vpnGatewaysReset* = Call_VpnGatewaysReset_568605(name: "vpnGatewaysReset",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/reset",
    validator: validate_VpnGatewaysReset_568606, base: "",
    url: url_VpnGatewaysReset_568607, schemes: {Scheme.Https})
type
  Call_VpnConnectionsListByVpnGateway_568616 = ref object of OpenApiRestCall_567666
proc url_VpnConnectionsListByVpnGateway_568618(protocol: Scheme; host: string;
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

proc validate_VpnConnectionsListByVpnGateway_568617(path: JsonNode;
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
  var valid_568619 = path.getOrDefault("resourceGroupName")
  valid_568619 = validateParameter(valid_568619, JString, required = true,
                                 default = nil)
  if valid_568619 != nil:
    section.add "resourceGroupName", valid_568619
  var valid_568620 = path.getOrDefault("gatewayName")
  valid_568620 = validateParameter(valid_568620, JString, required = true,
                                 default = nil)
  if valid_568620 != nil:
    section.add "gatewayName", valid_568620
  var valid_568621 = path.getOrDefault("subscriptionId")
  valid_568621 = validateParameter(valid_568621, JString, required = true,
                                 default = nil)
  if valid_568621 != nil:
    section.add "subscriptionId", valid_568621
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568622 = query.getOrDefault("api-version")
  valid_568622 = validateParameter(valid_568622, JString, required = true,
                                 default = nil)
  if valid_568622 != nil:
    section.add "api-version", valid_568622
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568623: Call_VpnConnectionsListByVpnGateway_568616; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all vpn connections for a particular virtual wan vpn gateway.
  ## 
  let valid = call_568623.validator(path, query, header, formData, body)
  let scheme = call_568623.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568623.url(scheme.get, call_568623.host, call_568623.base,
                         call_568623.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568623, url, valid)

proc call*(call_568624: Call_VpnConnectionsListByVpnGateway_568616;
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
  var path_568625 = newJObject()
  var query_568626 = newJObject()
  add(path_568625, "resourceGroupName", newJString(resourceGroupName))
  add(query_568626, "api-version", newJString(apiVersion))
  add(path_568625, "gatewayName", newJString(gatewayName))
  add(path_568625, "subscriptionId", newJString(subscriptionId))
  result = call_568624.call(path_568625, query_568626, nil, nil, nil)

var vpnConnectionsListByVpnGateway* = Call_VpnConnectionsListByVpnGateway_568616(
    name: "vpnConnectionsListByVpnGateway", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections",
    validator: validate_VpnConnectionsListByVpnGateway_568617, base: "",
    url: url_VpnConnectionsListByVpnGateway_568618, schemes: {Scheme.Https})
type
  Call_VpnConnectionsCreateOrUpdate_568639 = ref object of OpenApiRestCall_567666
proc url_VpnConnectionsCreateOrUpdate_568641(protocol: Scheme; host: string;
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

proc validate_VpnConnectionsCreateOrUpdate_568640(path: JsonNode; query: JsonNode;
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
  var valid_568642 = path.getOrDefault("resourceGroupName")
  valid_568642 = validateParameter(valid_568642, JString, required = true,
                                 default = nil)
  if valid_568642 != nil:
    section.add "resourceGroupName", valid_568642
  var valid_568643 = path.getOrDefault("gatewayName")
  valid_568643 = validateParameter(valid_568643, JString, required = true,
                                 default = nil)
  if valid_568643 != nil:
    section.add "gatewayName", valid_568643
  var valid_568644 = path.getOrDefault("subscriptionId")
  valid_568644 = validateParameter(valid_568644, JString, required = true,
                                 default = nil)
  if valid_568644 != nil:
    section.add "subscriptionId", valid_568644
  var valid_568645 = path.getOrDefault("connectionName")
  valid_568645 = validateParameter(valid_568645, JString, required = true,
                                 default = nil)
  if valid_568645 != nil:
    section.add "connectionName", valid_568645
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568646 = query.getOrDefault("api-version")
  valid_568646 = validateParameter(valid_568646, JString, required = true,
                                 default = nil)
  if valid_568646 != nil:
    section.add "api-version", valid_568646
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

proc call*(call_568648: Call_VpnConnectionsCreateOrUpdate_568639; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a vpn connection to a scalable vpn gateway if it doesn't exist else updates the existing connection.
  ## 
  let valid = call_568648.validator(path, query, header, formData, body)
  let scheme = call_568648.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568648.url(scheme.get, call_568648.host, call_568648.base,
                         call_568648.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568648, url, valid)

proc call*(call_568649: Call_VpnConnectionsCreateOrUpdate_568639;
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
  var path_568650 = newJObject()
  var query_568651 = newJObject()
  var body_568652 = newJObject()
  add(path_568650, "resourceGroupName", newJString(resourceGroupName))
  add(query_568651, "api-version", newJString(apiVersion))
  add(path_568650, "gatewayName", newJString(gatewayName))
  add(path_568650, "subscriptionId", newJString(subscriptionId))
  if VpnConnectionParameters != nil:
    body_568652 = VpnConnectionParameters
  add(path_568650, "connectionName", newJString(connectionName))
  result = call_568649.call(path_568650, query_568651, nil, nil, body_568652)

var vpnConnectionsCreateOrUpdate* = Call_VpnConnectionsCreateOrUpdate_568639(
    name: "vpnConnectionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections/{connectionName}",
    validator: validate_VpnConnectionsCreateOrUpdate_568640, base: "",
    url: url_VpnConnectionsCreateOrUpdate_568641, schemes: {Scheme.Https})
type
  Call_VpnConnectionsGet_568627 = ref object of OpenApiRestCall_567666
proc url_VpnConnectionsGet_568629(protocol: Scheme; host: string; base: string;
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

proc validate_VpnConnectionsGet_568628(path: JsonNode; query: JsonNode;
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
  var valid_568630 = path.getOrDefault("resourceGroupName")
  valid_568630 = validateParameter(valid_568630, JString, required = true,
                                 default = nil)
  if valid_568630 != nil:
    section.add "resourceGroupName", valid_568630
  var valid_568631 = path.getOrDefault("gatewayName")
  valid_568631 = validateParameter(valid_568631, JString, required = true,
                                 default = nil)
  if valid_568631 != nil:
    section.add "gatewayName", valid_568631
  var valid_568632 = path.getOrDefault("subscriptionId")
  valid_568632 = validateParameter(valid_568632, JString, required = true,
                                 default = nil)
  if valid_568632 != nil:
    section.add "subscriptionId", valid_568632
  var valid_568633 = path.getOrDefault("connectionName")
  valid_568633 = validateParameter(valid_568633, JString, required = true,
                                 default = nil)
  if valid_568633 != nil:
    section.add "connectionName", valid_568633
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568634 = query.getOrDefault("api-version")
  valid_568634 = validateParameter(valid_568634, JString, required = true,
                                 default = nil)
  if valid_568634 != nil:
    section.add "api-version", valid_568634
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568635: Call_VpnConnectionsGet_568627; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a vpn connection.
  ## 
  let valid = call_568635.validator(path, query, header, formData, body)
  let scheme = call_568635.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568635.url(scheme.get, call_568635.host, call_568635.base,
                         call_568635.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568635, url, valid)

proc call*(call_568636: Call_VpnConnectionsGet_568627; resourceGroupName: string;
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
  var path_568637 = newJObject()
  var query_568638 = newJObject()
  add(path_568637, "resourceGroupName", newJString(resourceGroupName))
  add(query_568638, "api-version", newJString(apiVersion))
  add(path_568637, "gatewayName", newJString(gatewayName))
  add(path_568637, "subscriptionId", newJString(subscriptionId))
  add(path_568637, "connectionName", newJString(connectionName))
  result = call_568636.call(path_568637, query_568638, nil, nil, nil)

var vpnConnectionsGet* = Call_VpnConnectionsGet_568627(name: "vpnConnectionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections/{connectionName}",
    validator: validate_VpnConnectionsGet_568628, base: "",
    url: url_VpnConnectionsGet_568629, schemes: {Scheme.Https})
type
  Call_VpnConnectionsDelete_568653 = ref object of OpenApiRestCall_567666
proc url_VpnConnectionsDelete_568655(protocol: Scheme; host: string; base: string;
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

proc validate_VpnConnectionsDelete_568654(path: JsonNode; query: JsonNode;
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
  var valid_568656 = path.getOrDefault("resourceGroupName")
  valid_568656 = validateParameter(valid_568656, JString, required = true,
                                 default = nil)
  if valid_568656 != nil:
    section.add "resourceGroupName", valid_568656
  var valid_568657 = path.getOrDefault("gatewayName")
  valid_568657 = validateParameter(valid_568657, JString, required = true,
                                 default = nil)
  if valid_568657 != nil:
    section.add "gatewayName", valid_568657
  var valid_568658 = path.getOrDefault("subscriptionId")
  valid_568658 = validateParameter(valid_568658, JString, required = true,
                                 default = nil)
  if valid_568658 != nil:
    section.add "subscriptionId", valid_568658
  var valid_568659 = path.getOrDefault("connectionName")
  valid_568659 = validateParameter(valid_568659, JString, required = true,
                                 default = nil)
  if valid_568659 != nil:
    section.add "connectionName", valid_568659
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568660 = query.getOrDefault("api-version")
  valid_568660 = validateParameter(valid_568660, JString, required = true,
                                 default = nil)
  if valid_568660 != nil:
    section.add "api-version", valid_568660
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568661: Call_VpnConnectionsDelete_568653; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a vpn connection.
  ## 
  let valid = call_568661.validator(path, query, header, formData, body)
  let scheme = call_568661.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568661.url(scheme.get, call_568661.host, call_568661.base,
                         call_568661.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568661, url, valid)

proc call*(call_568662: Call_VpnConnectionsDelete_568653;
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
  var path_568663 = newJObject()
  var query_568664 = newJObject()
  add(path_568663, "resourceGroupName", newJString(resourceGroupName))
  add(query_568664, "api-version", newJString(apiVersion))
  add(path_568663, "gatewayName", newJString(gatewayName))
  add(path_568663, "subscriptionId", newJString(subscriptionId))
  add(path_568663, "connectionName", newJString(connectionName))
  result = call_568662.call(path_568663, query_568664, nil, nil, nil)

var vpnConnectionsDelete* = Call_VpnConnectionsDelete_568653(
    name: "vpnConnectionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections/{connectionName}",
    validator: validate_VpnConnectionsDelete_568654, base: "",
    url: url_VpnConnectionsDelete_568655, schemes: {Scheme.Https})
type
  Call_VpnLinkConnectionsListByVpnConnection_568665 = ref object of OpenApiRestCall_567666
proc url_VpnLinkConnectionsListByVpnConnection_568667(protocol: Scheme;
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

proc validate_VpnLinkConnectionsListByVpnConnection_568666(path: JsonNode;
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
  var valid_568668 = path.getOrDefault("resourceGroupName")
  valid_568668 = validateParameter(valid_568668, JString, required = true,
                                 default = nil)
  if valid_568668 != nil:
    section.add "resourceGroupName", valid_568668
  var valid_568669 = path.getOrDefault("gatewayName")
  valid_568669 = validateParameter(valid_568669, JString, required = true,
                                 default = nil)
  if valid_568669 != nil:
    section.add "gatewayName", valid_568669
  var valid_568670 = path.getOrDefault("subscriptionId")
  valid_568670 = validateParameter(valid_568670, JString, required = true,
                                 default = nil)
  if valid_568670 != nil:
    section.add "subscriptionId", valid_568670
  var valid_568671 = path.getOrDefault("connectionName")
  valid_568671 = validateParameter(valid_568671, JString, required = true,
                                 default = nil)
  if valid_568671 != nil:
    section.add "connectionName", valid_568671
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568672 = query.getOrDefault("api-version")
  valid_568672 = validateParameter(valid_568672, JString, required = true,
                                 default = nil)
  if valid_568672 != nil:
    section.add "api-version", valid_568672
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568673: Call_VpnLinkConnectionsListByVpnConnection_568665;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all vpn site link connections for a particular virtual wan vpn gateway vpn connection.
  ## 
  let valid = call_568673.validator(path, query, header, formData, body)
  let scheme = call_568673.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568673.url(scheme.get, call_568673.host, call_568673.base,
                         call_568673.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568673, url, valid)

proc call*(call_568674: Call_VpnLinkConnectionsListByVpnConnection_568665;
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
  var path_568675 = newJObject()
  var query_568676 = newJObject()
  add(path_568675, "resourceGroupName", newJString(resourceGroupName))
  add(query_568676, "api-version", newJString(apiVersion))
  add(path_568675, "gatewayName", newJString(gatewayName))
  add(path_568675, "subscriptionId", newJString(subscriptionId))
  add(path_568675, "connectionName", newJString(connectionName))
  result = call_568674.call(path_568675, query_568676, nil, nil, nil)

var vpnLinkConnectionsListByVpnConnection* = Call_VpnLinkConnectionsListByVpnConnection_568665(
    name: "vpnLinkConnectionsListByVpnConnection", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections/{connectionName}/vpnLinkConnections",
    validator: validate_VpnLinkConnectionsListByVpnConnection_568666, base: "",
    url: url_VpnLinkConnectionsListByVpnConnection_568667, schemes: {Scheme.Https})
type
  Call_VpnSiteLinkConnectionsGet_568677 = ref object of OpenApiRestCall_567666
proc url_VpnSiteLinkConnectionsGet_568679(protocol: Scheme; host: string;
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

proc validate_VpnSiteLinkConnectionsGet_568678(path: JsonNode; query: JsonNode;
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
  var valid_568680 = path.getOrDefault("resourceGroupName")
  valid_568680 = validateParameter(valid_568680, JString, required = true,
                                 default = nil)
  if valid_568680 != nil:
    section.add "resourceGroupName", valid_568680
  var valid_568681 = path.getOrDefault("gatewayName")
  valid_568681 = validateParameter(valid_568681, JString, required = true,
                                 default = nil)
  if valid_568681 != nil:
    section.add "gatewayName", valid_568681
  var valid_568682 = path.getOrDefault("subscriptionId")
  valid_568682 = validateParameter(valid_568682, JString, required = true,
                                 default = nil)
  if valid_568682 != nil:
    section.add "subscriptionId", valid_568682
  var valid_568683 = path.getOrDefault("linkConnectionName")
  valid_568683 = validateParameter(valid_568683, JString, required = true,
                                 default = nil)
  if valid_568683 != nil:
    section.add "linkConnectionName", valid_568683
  var valid_568684 = path.getOrDefault("connectionName")
  valid_568684 = validateParameter(valid_568684, JString, required = true,
                                 default = nil)
  if valid_568684 != nil:
    section.add "connectionName", valid_568684
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568685 = query.getOrDefault("api-version")
  valid_568685 = validateParameter(valid_568685, JString, required = true,
                                 default = nil)
  if valid_568685 != nil:
    section.add "api-version", valid_568685
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568686: Call_VpnSiteLinkConnectionsGet_568677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a vpn site link connection.
  ## 
  let valid = call_568686.validator(path, query, header, formData, body)
  let scheme = call_568686.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568686.url(scheme.get, call_568686.host, call_568686.base,
                         call_568686.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568686, url, valid)

proc call*(call_568687: Call_VpnSiteLinkConnectionsGet_568677;
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
  var path_568688 = newJObject()
  var query_568689 = newJObject()
  add(path_568688, "resourceGroupName", newJString(resourceGroupName))
  add(query_568689, "api-version", newJString(apiVersion))
  add(path_568688, "gatewayName", newJString(gatewayName))
  add(path_568688, "subscriptionId", newJString(subscriptionId))
  add(path_568688, "linkConnectionName", newJString(linkConnectionName))
  add(path_568688, "connectionName", newJString(connectionName))
  result = call_568687.call(path_568688, query_568689, nil, nil, nil)

var vpnSiteLinkConnectionsGet* = Call_VpnSiteLinkConnectionsGet_568677(
    name: "vpnSiteLinkConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections/{connectionName}/vpnLinkConnections/{linkConnectionName}",
    validator: validate_VpnSiteLinkConnectionsGet_568678, base: "",
    url: url_VpnSiteLinkConnectionsGet_568679, schemes: {Scheme.Https})
type
  Call_VpnSitesListByResourceGroup_568690 = ref object of OpenApiRestCall_567666
proc url_VpnSitesListByResourceGroup_568692(protocol: Scheme; host: string;
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

proc validate_VpnSitesListByResourceGroup_568691(path: JsonNode; query: JsonNode;
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
  var valid_568693 = path.getOrDefault("resourceGroupName")
  valid_568693 = validateParameter(valid_568693, JString, required = true,
                                 default = nil)
  if valid_568693 != nil:
    section.add "resourceGroupName", valid_568693
  var valid_568694 = path.getOrDefault("subscriptionId")
  valid_568694 = validateParameter(valid_568694, JString, required = true,
                                 default = nil)
  if valid_568694 != nil:
    section.add "subscriptionId", valid_568694
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568695 = query.getOrDefault("api-version")
  valid_568695 = validateParameter(valid_568695, JString, required = true,
                                 default = nil)
  if valid_568695 != nil:
    section.add "api-version", valid_568695
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568696: Call_VpnSitesListByResourceGroup_568690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the vpnSites in a resource group.
  ## 
  let valid = call_568696.validator(path, query, header, formData, body)
  let scheme = call_568696.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568696.url(scheme.get, call_568696.host, call_568696.base,
                         call_568696.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568696, url, valid)

proc call*(call_568697: Call_VpnSitesListByResourceGroup_568690;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## vpnSitesListByResourceGroup
  ## Lists all the vpnSites in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnSite.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568698 = newJObject()
  var query_568699 = newJObject()
  add(path_568698, "resourceGroupName", newJString(resourceGroupName))
  add(query_568699, "api-version", newJString(apiVersion))
  add(path_568698, "subscriptionId", newJString(subscriptionId))
  result = call_568697.call(path_568698, query_568699, nil, nil, nil)

var vpnSitesListByResourceGroup* = Call_VpnSitesListByResourceGroup_568690(
    name: "vpnSitesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites",
    validator: validate_VpnSitesListByResourceGroup_568691, base: "",
    url: url_VpnSitesListByResourceGroup_568692, schemes: {Scheme.Https})
type
  Call_VpnSitesCreateOrUpdate_568711 = ref object of OpenApiRestCall_567666
proc url_VpnSitesCreateOrUpdate_568713(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSitesCreateOrUpdate_568712(path: JsonNode; query: JsonNode;
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
  var valid_568714 = path.getOrDefault("resourceGroupName")
  valid_568714 = validateParameter(valid_568714, JString, required = true,
                                 default = nil)
  if valid_568714 != nil:
    section.add "resourceGroupName", valid_568714
  var valid_568715 = path.getOrDefault("vpnSiteName")
  valid_568715 = validateParameter(valid_568715, JString, required = true,
                                 default = nil)
  if valid_568715 != nil:
    section.add "vpnSiteName", valid_568715
  var valid_568716 = path.getOrDefault("subscriptionId")
  valid_568716 = validateParameter(valid_568716, JString, required = true,
                                 default = nil)
  if valid_568716 != nil:
    section.add "subscriptionId", valid_568716
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568717 = query.getOrDefault("api-version")
  valid_568717 = validateParameter(valid_568717, JString, required = true,
                                 default = nil)
  if valid_568717 != nil:
    section.add "api-version", valid_568717
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

proc call*(call_568719: Call_VpnSitesCreateOrUpdate_568711; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a VpnSite resource if it doesn't exist else updates the existing VpnSite.
  ## 
  let valid = call_568719.validator(path, query, header, formData, body)
  let scheme = call_568719.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568719.url(scheme.get, call_568719.host, call_568719.base,
                         call_568719.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568719, url, valid)

proc call*(call_568720: Call_VpnSitesCreateOrUpdate_568711;
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
  var path_568721 = newJObject()
  var query_568722 = newJObject()
  var body_568723 = newJObject()
  add(path_568721, "resourceGroupName", newJString(resourceGroupName))
  add(query_568722, "api-version", newJString(apiVersion))
  add(path_568721, "vpnSiteName", newJString(vpnSiteName))
  add(path_568721, "subscriptionId", newJString(subscriptionId))
  if VpnSiteParameters != nil:
    body_568723 = VpnSiteParameters
  result = call_568720.call(path_568721, query_568722, nil, nil, body_568723)

var vpnSitesCreateOrUpdate* = Call_VpnSitesCreateOrUpdate_568711(
    name: "vpnSitesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}",
    validator: validate_VpnSitesCreateOrUpdate_568712, base: "",
    url: url_VpnSitesCreateOrUpdate_568713, schemes: {Scheme.Https})
type
  Call_VpnSitesGet_568700 = ref object of OpenApiRestCall_567666
proc url_VpnSitesGet_568702(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSitesGet_568701(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568703 = path.getOrDefault("resourceGroupName")
  valid_568703 = validateParameter(valid_568703, JString, required = true,
                                 default = nil)
  if valid_568703 != nil:
    section.add "resourceGroupName", valid_568703
  var valid_568704 = path.getOrDefault("vpnSiteName")
  valid_568704 = validateParameter(valid_568704, JString, required = true,
                                 default = nil)
  if valid_568704 != nil:
    section.add "vpnSiteName", valid_568704
  var valid_568705 = path.getOrDefault("subscriptionId")
  valid_568705 = validateParameter(valid_568705, JString, required = true,
                                 default = nil)
  if valid_568705 != nil:
    section.add "subscriptionId", valid_568705
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568706 = query.getOrDefault("api-version")
  valid_568706 = validateParameter(valid_568706, JString, required = true,
                                 default = nil)
  if valid_568706 != nil:
    section.add "api-version", valid_568706
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568707: Call_VpnSitesGet_568700; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a VPN site.
  ## 
  let valid = call_568707.validator(path, query, header, formData, body)
  let scheme = call_568707.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568707.url(scheme.get, call_568707.host, call_568707.base,
                         call_568707.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568707, url, valid)

proc call*(call_568708: Call_VpnSitesGet_568700; resourceGroupName: string;
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
  var path_568709 = newJObject()
  var query_568710 = newJObject()
  add(path_568709, "resourceGroupName", newJString(resourceGroupName))
  add(query_568710, "api-version", newJString(apiVersion))
  add(path_568709, "vpnSiteName", newJString(vpnSiteName))
  add(path_568709, "subscriptionId", newJString(subscriptionId))
  result = call_568708.call(path_568709, query_568710, nil, nil, nil)

var vpnSitesGet* = Call_VpnSitesGet_568700(name: "vpnSitesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}",
                                        validator: validate_VpnSitesGet_568701,
                                        base: "", url: url_VpnSitesGet_568702,
                                        schemes: {Scheme.Https})
type
  Call_VpnSitesUpdateTags_568735 = ref object of OpenApiRestCall_567666
proc url_VpnSitesUpdateTags_568737(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSitesUpdateTags_568736(path: JsonNode; query: JsonNode;
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
  var valid_568738 = path.getOrDefault("resourceGroupName")
  valid_568738 = validateParameter(valid_568738, JString, required = true,
                                 default = nil)
  if valid_568738 != nil:
    section.add "resourceGroupName", valid_568738
  var valid_568739 = path.getOrDefault("vpnSiteName")
  valid_568739 = validateParameter(valid_568739, JString, required = true,
                                 default = nil)
  if valid_568739 != nil:
    section.add "vpnSiteName", valid_568739
  var valid_568740 = path.getOrDefault("subscriptionId")
  valid_568740 = validateParameter(valid_568740, JString, required = true,
                                 default = nil)
  if valid_568740 != nil:
    section.add "subscriptionId", valid_568740
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568741 = query.getOrDefault("api-version")
  valid_568741 = validateParameter(valid_568741, JString, required = true,
                                 default = nil)
  if valid_568741 != nil:
    section.add "api-version", valid_568741
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

proc call*(call_568743: Call_VpnSitesUpdateTags_568735; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates VpnSite tags.
  ## 
  let valid = call_568743.validator(path, query, header, formData, body)
  let scheme = call_568743.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568743.url(scheme.get, call_568743.host, call_568743.base,
                         call_568743.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568743, url, valid)

proc call*(call_568744: Call_VpnSitesUpdateTags_568735; resourceGroupName: string;
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
  var path_568745 = newJObject()
  var query_568746 = newJObject()
  var body_568747 = newJObject()
  add(path_568745, "resourceGroupName", newJString(resourceGroupName))
  add(query_568746, "api-version", newJString(apiVersion))
  add(path_568745, "vpnSiteName", newJString(vpnSiteName))
  add(path_568745, "subscriptionId", newJString(subscriptionId))
  if VpnSiteParameters != nil:
    body_568747 = VpnSiteParameters
  result = call_568744.call(path_568745, query_568746, nil, nil, body_568747)

var vpnSitesUpdateTags* = Call_VpnSitesUpdateTags_568735(
    name: "vpnSitesUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}",
    validator: validate_VpnSitesUpdateTags_568736, base: "",
    url: url_VpnSitesUpdateTags_568737, schemes: {Scheme.Https})
type
  Call_VpnSitesDelete_568724 = ref object of OpenApiRestCall_567666
proc url_VpnSitesDelete_568726(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSitesDelete_568725(path: JsonNode; query: JsonNode;
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
  var valid_568727 = path.getOrDefault("resourceGroupName")
  valid_568727 = validateParameter(valid_568727, JString, required = true,
                                 default = nil)
  if valid_568727 != nil:
    section.add "resourceGroupName", valid_568727
  var valid_568728 = path.getOrDefault("vpnSiteName")
  valid_568728 = validateParameter(valid_568728, JString, required = true,
                                 default = nil)
  if valid_568728 != nil:
    section.add "vpnSiteName", valid_568728
  var valid_568729 = path.getOrDefault("subscriptionId")
  valid_568729 = validateParameter(valid_568729, JString, required = true,
                                 default = nil)
  if valid_568729 != nil:
    section.add "subscriptionId", valid_568729
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568730 = query.getOrDefault("api-version")
  valid_568730 = validateParameter(valid_568730, JString, required = true,
                                 default = nil)
  if valid_568730 != nil:
    section.add "api-version", valid_568730
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568731: Call_VpnSitesDelete_568724; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a VpnSite.
  ## 
  let valid = call_568731.validator(path, query, header, formData, body)
  let scheme = call_568731.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568731.url(scheme.get, call_568731.host, call_568731.base,
                         call_568731.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568731, url, valid)

proc call*(call_568732: Call_VpnSitesDelete_568724; resourceGroupName: string;
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
  var path_568733 = newJObject()
  var query_568734 = newJObject()
  add(path_568733, "resourceGroupName", newJString(resourceGroupName))
  add(query_568734, "api-version", newJString(apiVersion))
  add(path_568733, "vpnSiteName", newJString(vpnSiteName))
  add(path_568733, "subscriptionId", newJString(subscriptionId))
  result = call_568732.call(path_568733, query_568734, nil, nil, nil)

var vpnSitesDelete* = Call_VpnSitesDelete_568724(name: "vpnSitesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}",
    validator: validate_VpnSitesDelete_568725, base: "", url: url_VpnSitesDelete_568726,
    schemes: {Scheme.Https})
type
  Call_VpnSiteLinksListByVpnSite_568748 = ref object of OpenApiRestCall_567666
proc url_VpnSiteLinksListByVpnSite_568750(protocol: Scheme; host: string;
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

proc validate_VpnSiteLinksListByVpnSite_568749(path: JsonNode; query: JsonNode;
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
  var valid_568751 = path.getOrDefault("resourceGroupName")
  valid_568751 = validateParameter(valid_568751, JString, required = true,
                                 default = nil)
  if valid_568751 != nil:
    section.add "resourceGroupName", valid_568751
  var valid_568752 = path.getOrDefault("vpnSiteName")
  valid_568752 = validateParameter(valid_568752, JString, required = true,
                                 default = nil)
  if valid_568752 != nil:
    section.add "vpnSiteName", valid_568752
  var valid_568753 = path.getOrDefault("subscriptionId")
  valid_568753 = validateParameter(valid_568753, JString, required = true,
                                 default = nil)
  if valid_568753 != nil:
    section.add "subscriptionId", valid_568753
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568754 = query.getOrDefault("api-version")
  valid_568754 = validateParameter(valid_568754, JString, required = true,
                                 default = nil)
  if valid_568754 != nil:
    section.add "api-version", valid_568754
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568755: Call_VpnSiteLinksListByVpnSite_568748; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the vpnSiteLinks in a resource group for a vpn site.
  ## 
  let valid = call_568755.validator(path, query, header, formData, body)
  let scheme = call_568755.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568755.url(scheme.get, call_568755.host, call_568755.base,
                         call_568755.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568755, url, valid)

proc call*(call_568756: Call_VpnSiteLinksListByVpnSite_568748;
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
  var path_568757 = newJObject()
  var query_568758 = newJObject()
  add(path_568757, "resourceGroupName", newJString(resourceGroupName))
  add(query_568758, "api-version", newJString(apiVersion))
  add(path_568757, "vpnSiteName", newJString(vpnSiteName))
  add(path_568757, "subscriptionId", newJString(subscriptionId))
  result = call_568756.call(path_568757, query_568758, nil, nil, nil)

var vpnSiteLinksListByVpnSite* = Call_VpnSiteLinksListByVpnSite_568748(
    name: "vpnSiteLinksListByVpnSite", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}/vpnSiteLinks",
    validator: validate_VpnSiteLinksListByVpnSite_568749, base: "",
    url: url_VpnSiteLinksListByVpnSite_568750, schemes: {Scheme.Https})
type
  Call_VpnSiteLinksGet_568759 = ref object of OpenApiRestCall_567666
proc url_VpnSiteLinksGet_568761(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSiteLinksGet_568760(path: JsonNode; query: JsonNode;
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
  var valid_568762 = path.getOrDefault("resourceGroupName")
  valid_568762 = validateParameter(valid_568762, JString, required = true,
                                 default = nil)
  if valid_568762 != nil:
    section.add "resourceGroupName", valid_568762
  var valid_568763 = path.getOrDefault("vpnSiteName")
  valid_568763 = validateParameter(valid_568763, JString, required = true,
                                 default = nil)
  if valid_568763 != nil:
    section.add "vpnSiteName", valid_568763
  var valid_568764 = path.getOrDefault("subscriptionId")
  valid_568764 = validateParameter(valid_568764, JString, required = true,
                                 default = nil)
  if valid_568764 != nil:
    section.add "subscriptionId", valid_568764
  var valid_568765 = path.getOrDefault("vpnSiteLinkName")
  valid_568765 = validateParameter(valid_568765, JString, required = true,
                                 default = nil)
  if valid_568765 != nil:
    section.add "vpnSiteLinkName", valid_568765
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568766 = query.getOrDefault("api-version")
  valid_568766 = validateParameter(valid_568766, JString, required = true,
                                 default = nil)
  if valid_568766 != nil:
    section.add "api-version", valid_568766
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568767: Call_VpnSiteLinksGet_568759; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a VPN site link.
  ## 
  let valid = call_568767.validator(path, query, header, formData, body)
  let scheme = call_568767.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568767.url(scheme.get, call_568767.host, call_568767.base,
                         call_568767.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568767, url, valid)

proc call*(call_568768: Call_VpnSiteLinksGet_568759; resourceGroupName: string;
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
  var path_568769 = newJObject()
  var query_568770 = newJObject()
  add(path_568769, "resourceGroupName", newJString(resourceGroupName))
  add(query_568770, "api-version", newJString(apiVersion))
  add(path_568769, "vpnSiteName", newJString(vpnSiteName))
  add(path_568769, "subscriptionId", newJString(subscriptionId))
  add(path_568769, "vpnSiteLinkName", newJString(vpnSiteLinkName))
  result = call_568768.call(path_568769, query_568770, nil, nil, nil)

var vpnSiteLinksGet* = Call_VpnSiteLinksGet_568759(name: "vpnSiteLinksGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}/vpnSiteLinks/{vpnSiteLinkName}",
    validator: validate_VpnSiteLinksGet_568760, base: "", url: url_VpnSiteLinksGet_568761,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
