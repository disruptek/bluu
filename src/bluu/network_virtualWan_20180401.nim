
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: VirtualWANAsAServiceManagementClient
## version: 2018-04-01
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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "network-virtualWan"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_VirtualHubsList_563777 = ref object of OpenApiRestCall_563555
proc url_VirtualHubsList_563779(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualHubsList_563778(path: JsonNode; query: JsonNode;
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
  var valid_563941 = path.getOrDefault("subscriptionId")
  valid_563941 = validateParameter(valid_563941, JString, required = true,
                                 default = nil)
  if valid_563941 != nil:
    section.add "subscriptionId", valid_563941
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563942 = query.getOrDefault("api-version")
  valid_563942 = validateParameter(valid_563942, JString, required = true,
                                 default = nil)
  if valid_563942 != nil:
    section.add "api-version", valid_563942
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563969: Call_VirtualHubsList_563777; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VirtualHubs in a subscription.
  ## 
  let valid = call_563969.validator(path, query, header, formData, body)
  let scheme = call_563969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563969.url(scheme.get, call_563969.host, call_563969.base,
                         call_563969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563969, url, valid)

proc call*(call_564040: Call_VirtualHubsList_563777; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualHubsList
  ## Lists all the VirtualHubs in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564041 = newJObject()
  var query_564043 = newJObject()
  add(query_564043, "api-version", newJString(apiVersion))
  add(path_564041, "subscriptionId", newJString(subscriptionId))
  result = call_564040.call(path_564041, query_564043, nil, nil, nil)

var virtualHubsList* = Call_VirtualHubsList_563777(name: "virtualHubsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/virtualHubs",
    validator: validate_VirtualHubsList_563778, base: "", url: url_VirtualHubsList_563779,
    schemes: {Scheme.Https})
type
  Call_VirtualWANsList_564082 = ref object of OpenApiRestCall_563555
proc url_VirtualWANsList_564084(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualWANsList_564083(path: JsonNode; query: JsonNode;
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
  var valid_564085 = path.getOrDefault("subscriptionId")
  valid_564085 = validateParameter(valid_564085, JString, required = true,
                                 default = nil)
  if valid_564085 != nil:
    section.add "subscriptionId", valid_564085
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564086 = query.getOrDefault("api-version")
  valid_564086 = validateParameter(valid_564086, JString, required = true,
                                 default = nil)
  if valid_564086 != nil:
    section.add "api-version", valid_564086
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564087: Call_VirtualWANsList_564082; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VirtualWANs in a subscription.
  ## 
  let valid = call_564087.validator(path, query, header, formData, body)
  let scheme = call_564087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564087.url(scheme.get, call_564087.host, call_564087.base,
                         call_564087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564087, url, valid)

proc call*(call_564088: Call_VirtualWANsList_564082; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualWANsList
  ## Lists all the VirtualWANs in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564089 = newJObject()
  var query_564090 = newJObject()
  add(query_564090, "api-version", newJString(apiVersion))
  add(path_564089, "subscriptionId", newJString(subscriptionId))
  result = call_564088.call(path_564089, query_564090, nil, nil, nil)

var virtualWANsList* = Call_VirtualWANsList_564082(name: "virtualWANsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/virtualWans",
    validator: validate_VirtualWANsList_564083, base: "", url: url_VirtualWANsList_564084,
    schemes: {Scheme.Https})
type
  Call_VpnGatewaysList_564091 = ref object of OpenApiRestCall_563555
proc url_VpnGatewaysList_564093(protocol: Scheme; host: string; base: string;
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

proc validate_VpnGatewaysList_564092(path: JsonNode; query: JsonNode;
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
  var valid_564094 = path.getOrDefault("subscriptionId")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "subscriptionId", valid_564094
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564095 = query.getOrDefault("api-version")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "api-version", valid_564095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564096: Call_VpnGatewaysList_564091; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VpnGateways in a subscription.
  ## 
  let valid = call_564096.validator(path, query, header, formData, body)
  let scheme = call_564096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564096.url(scheme.get, call_564096.host, call_564096.base,
                         call_564096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564096, url, valid)

proc call*(call_564097: Call_VpnGatewaysList_564091; apiVersion: string;
          subscriptionId: string): Recallable =
  ## vpnGatewaysList
  ## Lists all the VpnGateways in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564098 = newJObject()
  var query_564099 = newJObject()
  add(query_564099, "api-version", newJString(apiVersion))
  add(path_564098, "subscriptionId", newJString(subscriptionId))
  result = call_564097.call(path_564098, query_564099, nil, nil, nil)

var vpnGatewaysList* = Call_VpnGatewaysList_564091(name: "vpnGatewaysList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/vpnGateways",
    validator: validate_VpnGatewaysList_564092, base: "", url: url_VpnGatewaysList_564093,
    schemes: {Scheme.Https})
type
  Call_VpnSitesList_564100 = ref object of OpenApiRestCall_563555
proc url_VpnSitesList_564102(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSitesList_564101(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564103 = path.getOrDefault("subscriptionId")
  valid_564103 = validateParameter(valid_564103, JString, required = true,
                                 default = nil)
  if valid_564103 != nil:
    section.add "subscriptionId", valid_564103
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564104 = query.getOrDefault("api-version")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "api-version", valid_564104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564105: Call_VpnSitesList_564100; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VpnSites in a subscription.
  ## 
  let valid = call_564105.validator(path, query, header, formData, body)
  let scheme = call_564105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564105.url(scheme.get, call_564105.host, call_564105.base,
                         call_564105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564105, url, valid)

proc call*(call_564106: Call_VpnSitesList_564100; apiVersion: string;
          subscriptionId: string): Recallable =
  ## vpnSitesList
  ## Lists all the VpnSites in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564107 = newJObject()
  var query_564108 = newJObject()
  add(query_564108, "api-version", newJString(apiVersion))
  add(path_564107, "subscriptionId", newJString(subscriptionId))
  result = call_564106.call(path_564107, query_564108, nil, nil, nil)

var vpnSitesList* = Call_VpnSitesList_564100(name: "vpnSitesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/vpnSites",
    validator: validate_VpnSitesList_564101, base: "", url: url_VpnSitesList_564102,
    schemes: {Scheme.Https})
type
  Call_VirtualHubsListByResourceGroup_564109 = ref object of OpenApiRestCall_563555
proc url_VirtualHubsListByResourceGroup_564111(protocol: Scheme; host: string;
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

proc validate_VirtualHubsListByResourceGroup_564110(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the VirtualHubs in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VirtualHub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564112 = path.getOrDefault("subscriptionId")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "subscriptionId", valid_564112
  var valid_564113 = path.getOrDefault("resourceGroupName")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "resourceGroupName", valid_564113
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564114 = query.getOrDefault("api-version")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "api-version", valid_564114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564115: Call_VirtualHubsListByResourceGroup_564109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VirtualHubs in a resource group.
  ## 
  let valid = call_564115.validator(path, query, header, formData, body)
  let scheme = call_564115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564115.url(scheme.get, call_564115.host, call_564115.base,
                         call_564115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564115, url, valid)

proc call*(call_564116: Call_VirtualHubsListByResourceGroup_564109;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## virtualHubsListByResourceGroup
  ## Lists all the VirtualHubs in a resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualHub.
  var path_564117 = newJObject()
  var query_564118 = newJObject()
  add(query_564118, "api-version", newJString(apiVersion))
  add(path_564117, "subscriptionId", newJString(subscriptionId))
  add(path_564117, "resourceGroupName", newJString(resourceGroupName))
  result = call_564116.call(path_564117, query_564118, nil, nil, nil)

var virtualHubsListByResourceGroup* = Call_VirtualHubsListByResourceGroup_564109(
    name: "virtualHubsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs",
    validator: validate_VirtualHubsListByResourceGroup_564110, base: "",
    url: url_VirtualHubsListByResourceGroup_564111, schemes: {Scheme.Https})
type
  Call_VirtualHubsCreateOrUpdate_564130 = ref object of OpenApiRestCall_563555
proc url_VirtualHubsCreateOrUpdate_564132(protocol: Scheme; host: string;
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

proc validate_VirtualHubsCreateOrUpdate_564131(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a VirtualHub resource if it doesn't exist else updates the existing VirtualHub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   virtualHubName: JString (required)
  ##                 : The name of the VirtualHub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VirtualHub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `virtualHubName` field"
  var valid_564159 = path.getOrDefault("virtualHubName")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "virtualHubName", valid_564159
  var valid_564160 = path.getOrDefault("subscriptionId")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "subscriptionId", valid_564160
  var valid_564161 = path.getOrDefault("resourceGroupName")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "resourceGroupName", valid_564161
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564162 = query.getOrDefault("api-version")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "api-version", valid_564162
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

proc call*(call_564164: Call_VirtualHubsCreateOrUpdate_564130; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a VirtualHub resource if it doesn't exist else updates the existing VirtualHub.
  ## 
  let valid = call_564164.validator(path, query, header, formData, body)
  let scheme = call_564164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564164.url(scheme.get, call_564164.host, call_564164.base,
                         call_564164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564164, url, valid)

proc call*(call_564165: Call_VirtualHubsCreateOrUpdate_564130; apiVersion: string;
          virtualHubName: string; subscriptionId: string; resourceGroupName: string;
          virtualHubParameters: JsonNode): Recallable =
  ## virtualHubsCreateOrUpdate
  ## Creates a VirtualHub resource if it doesn't exist else updates the existing VirtualHub.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualHubName: string (required)
  ##                 : The name of the VirtualHub.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualHub.
  ##   virtualHubParameters: JObject (required)
  ##                       : Parameters supplied to create or update VirtualHub.
  var path_564166 = newJObject()
  var query_564167 = newJObject()
  var body_564168 = newJObject()
  add(query_564167, "api-version", newJString(apiVersion))
  add(path_564166, "virtualHubName", newJString(virtualHubName))
  add(path_564166, "subscriptionId", newJString(subscriptionId))
  add(path_564166, "resourceGroupName", newJString(resourceGroupName))
  if virtualHubParameters != nil:
    body_564168 = virtualHubParameters
  result = call_564165.call(path_564166, query_564167, nil, nil, body_564168)

var virtualHubsCreateOrUpdate* = Call_VirtualHubsCreateOrUpdate_564130(
    name: "virtualHubsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}",
    validator: validate_VirtualHubsCreateOrUpdate_564131, base: "",
    url: url_VirtualHubsCreateOrUpdate_564132, schemes: {Scheme.Https})
type
  Call_VirtualHubsGet_564119 = ref object of OpenApiRestCall_563555
proc url_VirtualHubsGet_564121(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualHubsGet_564120(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Retrieves the details of a VirtualHub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   virtualHubName: JString (required)
  ##                 : The name of the VirtualHub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VirtualHub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `virtualHubName` field"
  var valid_564122 = path.getOrDefault("virtualHubName")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "virtualHubName", valid_564122
  var valid_564123 = path.getOrDefault("subscriptionId")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "subscriptionId", valid_564123
  var valid_564124 = path.getOrDefault("resourceGroupName")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "resourceGroupName", valid_564124
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564125 = query.getOrDefault("api-version")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "api-version", valid_564125
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564126: Call_VirtualHubsGet_564119; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a VirtualHub.
  ## 
  let valid = call_564126.validator(path, query, header, formData, body)
  let scheme = call_564126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564126.url(scheme.get, call_564126.host, call_564126.base,
                         call_564126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564126, url, valid)

proc call*(call_564127: Call_VirtualHubsGet_564119; apiVersion: string;
          virtualHubName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## virtualHubsGet
  ## Retrieves the details of a VirtualHub.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualHubName: string (required)
  ##                 : The name of the VirtualHub.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualHub.
  var path_564128 = newJObject()
  var query_564129 = newJObject()
  add(query_564129, "api-version", newJString(apiVersion))
  add(path_564128, "virtualHubName", newJString(virtualHubName))
  add(path_564128, "subscriptionId", newJString(subscriptionId))
  add(path_564128, "resourceGroupName", newJString(resourceGroupName))
  result = call_564127.call(path_564128, query_564129, nil, nil, nil)

var virtualHubsGet* = Call_VirtualHubsGet_564119(name: "virtualHubsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}",
    validator: validate_VirtualHubsGet_564120, base: "", url: url_VirtualHubsGet_564121,
    schemes: {Scheme.Https})
type
  Call_VirtualHubsUpdateTags_564180 = ref object of OpenApiRestCall_563555
proc url_VirtualHubsUpdateTags_564182(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualHubsUpdateTags_564181(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates VirtualHub tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   virtualHubName: JString (required)
  ##                 : The name of the VirtualHub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VirtualHub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `virtualHubName` field"
  var valid_564183 = path.getOrDefault("virtualHubName")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "virtualHubName", valid_564183
  var valid_564184 = path.getOrDefault("subscriptionId")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "subscriptionId", valid_564184
  var valid_564185 = path.getOrDefault("resourceGroupName")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "resourceGroupName", valid_564185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564186 = query.getOrDefault("api-version")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "api-version", valid_564186
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

proc call*(call_564188: Call_VirtualHubsUpdateTags_564180; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates VirtualHub tags.
  ## 
  let valid = call_564188.validator(path, query, header, formData, body)
  let scheme = call_564188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564188.url(scheme.get, call_564188.host, call_564188.base,
                         call_564188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564188, url, valid)

proc call*(call_564189: Call_VirtualHubsUpdateTags_564180; apiVersion: string;
          virtualHubName: string; subscriptionId: string; resourceGroupName: string;
          virtualHubParameters: JsonNode): Recallable =
  ## virtualHubsUpdateTags
  ## Updates VirtualHub tags.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualHubName: string (required)
  ##                 : The name of the VirtualHub.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualHub.
  ##   virtualHubParameters: JObject (required)
  ##                       : Parameters supplied to update VirtualHub tags.
  var path_564190 = newJObject()
  var query_564191 = newJObject()
  var body_564192 = newJObject()
  add(query_564191, "api-version", newJString(apiVersion))
  add(path_564190, "virtualHubName", newJString(virtualHubName))
  add(path_564190, "subscriptionId", newJString(subscriptionId))
  add(path_564190, "resourceGroupName", newJString(resourceGroupName))
  if virtualHubParameters != nil:
    body_564192 = virtualHubParameters
  result = call_564189.call(path_564190, query_564191, nil, nil, body_564192)

var virtualHubsUpdateTags* = Call_VirtualHubsUpdateTags_564180(
    name: "virtualHubsUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}",
    validator: validate_VirtualHubsUpdateTags_564181, base: "",
    url: url_VirtualHubsUpdateTags_564182, schemes: {Scheme.Https})
type
  Call_VirtualHubsDelete_564169 = ref object of OpenApiRestCall_563555
proc url_VirtualHubsDelete_564171(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualHubsDelete_564170(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes a VirtualHub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   virtualHubName: JString (required)
  ##                 : The name of the VirtualHub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VirtualHub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `virtualHubName` field"
  var valid_564172 = path.getOrDefault("virtualHubName")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "virtualHubName", valid_564172
  var valid_564173 = path.getOrDefault("subscriptionId")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "subscriptionId", valid_564173
  var valid_564174 = path.getOrDefault("resourceGroupName")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "resourceGroupName", valid_564174
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564175 = query.getOrDefault("api-version")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "api-version", valid_564175
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564176: Call_VirtualHubsDelete_564169; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a VirtualHub.
  ## 
  let valid = call_564176.validator(path, query, header, formData, body)
  let scheme = call_564176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564176.url(scheme.get, call_564176.host, call_564176.base,
                         call_564176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564176, url, valid)

proc call*(call_564177: Call_VirtualHubsDelete_564169; apiVersion: string;
          virtualHubName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## virtualHubsDelete
  ## Deletes a VirtualHub.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualHubName: string (required)
  ##                 : The name of the VirtualHub.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualHub.
  var path_564178 = newJObject()
  var query_564179 = newJObject()
  add(query_564179, "api-version", newJString(apiVersion))
  add(path_564178, "virtualHubName", newJString(virtualHubName))
  add(path_564178, "subscriptionId", newJString(subscriptionId))
  add(path_564178, "resourceGroupName", newJString(resourceGroupName))
  result = call_564177.call(path_564178, query_564179, nil, nil, nil)

var virtualHubsDelete* = Call_VirtualHubsDelete_564169(name: "virtualHubsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}",
    validator: validate_VirtualHubsDelete_564170, base: "",
    url: url_VirtualHubsDelete_564171, schemes: {Scheme.Https})
type
  Call_HubVirtualNetworkConnectionsList_564193 = ref object of OpenApiRestCall_563555
proc url_HubVirtualNetworkConnectionsList_564195(protocol: Scheme; host: string;
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

proc validate_HubVirtualNetworkConnectionsList_564194(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the details of all HubVirtualNetworkConnections.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   virtualHubName: JString (required)
  ##                 : The name of the VirtualHub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VirtualHub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `virtualHubName` field"
  var valid_564196 = path.getOrDefault("virtualHubName")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "virtualHubName", valid_564196
  var valid_564197 = path.getOrDefault("subscriptionId")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "subscriptionId", valid_564197
  var valid_564198 = path.getOrDefault("resourceGroupName")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "resourceGroupName", valid_564198
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564199 = query.getOrDefault("api-version")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "api-version", valid_564199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564200: Call_HubVirtualNetworkConnectionsList_564193;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the details of all HubVirtualNetworkConnections.
  ## 
  let valid = call_564200.validator(path, query, header, formData, body)
  let scheme = call_564200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564200.url(scheme.get, call_564200.host, call_564200.base,
                         call_564200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564200, url, valid)

proc call*(call_564201: Call_HubVirtualNetworkConnectionsList_564193;
          apiVersion: string; virtualHubName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## hubVirtualNetworkConnectionsList
  ## Retrieves the details of all HubVirtualNetworkConnections.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualHubName: string (required)
  ##                 : The name of the VirtualHub.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualHub.
  var path_564202 = newJObject()
  var query_564203 = newJObject()
  add(query_564203, "api-version", newJString(apiVersion))
  add(path_564202, "virtualHubName", newJString(virtualHubName))
  add(path_564202, "subscriptionId", newJString(subscriptionId))
  add(path_564202, "resourceGroupName", newJString(resourceGroupName))
  result = call_564201.call(path_564202, query_564203, nil, nil, nil)

var hubVirtualNetworkConnectionsList* = Call_HubVirtualNetworkConnectionsList_564193(
    name: "hubVirtualNetworkConnectionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}/hubVirtualNetworkConnections",
    validator: validate_HubVirtualNetworkConnectionsList_564194, base: "",
    url: url_HubVirtualNetworkConnectionsList_564195, schemes: {Scheme.Https})
type
  Call_HubVirtualNetworkConnectionsGet_564204 = ref object of OpenApiRestCall_563555
proc url_HubVirtualNetworkConnectionsGet_564206(protocol: Scheme; host: string;
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

proc validate_HubVirtualNetworkConnectionsGet_564205(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the details of a HubVirtualNetworkConnection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   virtualHubName: JString (required)
  ##                 : The name of the VirtualHub.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: JString (required)
  ##                 : The name of the vpn connection.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VirtualHub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `virtualHubName` field"
  var valid_564207 = path.getOrDefault("virtualHubName")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "virtualHubName", valid_564207
  var valid_564208 = path.getOrDefault("subscriptionId")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "subscriptionId", valid_564208
  var valid_564209 = path.getOrDefault("connectionName")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "connectionName", valid_564209
  var valid_564210 = path.getOrDefault("resourceGroupName")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "resourceGroupName", valid_564210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564211 = query.getOrDefault("api-version")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "api-version", valid_564211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564212: Call_HubVirtualNetworkConnectionsGet_564204;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the details of a HubVirtualNetworkConnection.
  ## 
  let valid = call_564212.validator(path, query, header, formData, body)
  let scheme = call_564212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564212.url(scheme.get, call_564212.host, call_564212.base,
                         call_564212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564212, url, valid)

proc call*(call_564213: Call_HubVirtualNetworkConnectionsGet_564204;
          apiVersion: string; virtualHubName: string; subscriptionId: string;
          connectionName: string; resourceGroupName: string): Recallable =
  ## hubVirtualNetworkConnectionsGet
  ## Retrieves the details of a HubVirtualNetworkConnection.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualHubName: string (required)
  ##                 : The name of the VirtualHub.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: string (required)
  ##                 : The name of the vpn connection.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualHub.
  var path_564214 = newJObject()
  var query_564215 = newJObject()
  add(query_564215, "api-version", newJString(apiVersion))
  add(path_564214, "virtualHubName", newJString(virtualHubName))
  add(path_564214, "subscriptionId", newJString(subscriptionId))
  add(path_564214, "connectionName", newJString(connectionName))
  add(path_564214, "resourceGroupName", newJString(resourceGroupName))
  result = call_564213.call(path_564214, query_564215, nil, nil, nil)

var hubVirtualNetworkConnectionsGet* = Call_HubVirtualNetworkConnectionsGet_564204(
    name: "hubVirtualNetworkConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}/hubVirtualNetworkConnections/{connectionName}",
    validator: validate_HubVirtualNetworkConnectionsGet_564205, base: "",
    url: url_HubVirtualNetworkConnectionsGet_564206, schemes: {Scheme.Https})
type
  Call_VirtualWANsListByResourceGroup_564216 = ref object of OpenApiRestCall_563555
proc url_VirtualWANsListByResourceGroup_564218(protocol: Scheme; host: string;
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

proc validate_VirtualWANsListByResourceGroup_564217(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the VirtualWANs in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VirtualWan.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564219 = path.getOrDefault("subscriptionId")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "subscriptionId", valid_564219
  var valid_564220 = path.getOrDefault("resourceGroupName")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "resourceGroupName", valid_564220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564221 = query.getOrDefault("api-version")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "api-version", valid_564221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564222: Call_VirtualWANsListByResourceGroup_564216; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VirtualWANs in a resource group.
  ## 
  let valid = call_564222.validator(path, query, header, formData, body)
  let scheme = call_564222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564222.url(scheme.get, call_564222.host, call_564222.base,
                         call_564222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564222, url, valid)

proc call*(call_564223: Call_VirtualWANsListByResourceGroup_564216;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## virtualWANsListByResourceGroup
  ## Lists all the VirtualWANs in a resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualWan.
  var path_564224 = newJObject()
  var query_564225 = newJObject()
  add(query_564225, "api-version", newJString(apiVersion))
  add(path_564224, "subscriptionId", newJString(subscriptionId))
  add(path_564224, "resourceGroupName", newJString(resourceGroupName))
  result = call_564223.call(path_564224, query_564225, nil, nil, nil)

var virtualWANsListByResourceGroup* = Call_VirtualWANsListByResourceGroup_564216(
    name: "virtualWANsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans",
    validator: validate_VirtualWANsListByResourceGroup_564217, base: "",
    url: url_VirtualWANsListByResourceGroup_564218, schemes: {Scheme.Https})
type
  Call_VirtualWANsCreateOrUpdate_564237 = ref object of OpenApiRestCall_563555
proc url_VirtualWANsCreateOrUpdate_564239(protocol: Scheme; host: string;
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

proc validate_VirtualWANsCreateOrUpdate_564238(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a VirtualWAN resource if it doesn't exist else updates the existing VirtualWAN.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   VirtualWANName: JString (required)
  ##                 : The name of the VirtualWAN being created or updated.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VirtualWan.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `VirtualWANName` field"
  var valid_564240 = path.getOrDefault("VirtualWANName")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "VirtualWANName", valid_564240
  var valid_564241 = path.getOrDefault("subscriptionId")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "subscriptionId", valid_564241
  var valid_564242 = path.getOrDefault("resourceGroupName")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "resourceGroupName", valid_564242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564243 = query.getOrDefault("api-version")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "api-version", valid_564243
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

proc call*(call_564245: Call_VirtualWANsCreateOrUpdate_564237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a VirtualWAN resource if it doesn't exist else updates the existing VirtualWAN.
  ## 
  let valid = call_564245.validator(path, query, header, formData, body)
  let scheme = call_564245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564245.url(scheme.get, call_564245.host, call_564245.base,
                         call_564245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564245, url, valid)

proc call*(call_564246: Call_VirtualWANsCreateOrUpdate_564237;
          WANParameters: JsonNode; VirtualWANName: string; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## virtualWANsCreateOrUpdate
  ## Creates a VirtualWAN resource if it doesn't exist else updates the existing VirtualWAN.
  ##   WANParameters: JObject (required)
  ##                : Parameters supplied to create or update VirtualWAN.
  ##   VirtualWANName: string (required)
  ##                 : The name of the VirtualWAN being created or updated.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualWan.
  var path_564247 = newJObject()
  var query_564248 = newJObject()
  var body_564249 = newJObject()
  if WANParameters != nil:
    body_564249 = WANParameters
  add(path_564247, "VirtualWANName", newJString(VirtualWANName))
  add(query_564248, "api-version", newJString(apiVersion))
  add(path_564247, "subscriptionId", newJString(subscriptionId))
  add(path_564247, "resourceGroupName", newJString(resourceGroupName))
  result = call_564246.call(path_564247, query_564248, nil, nil, body_564249)

var virtualWANsCreateOrUpdate* = Call_VirtualWANsCreateOrUpdate_564237(
    name: "virtualWANsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{VirtualWANName}",
    validator: validate_VirtualWANsCreateOrUpdate_564238, base: "",
    url: url_VirtualWANsCreateOrUpdate_564239, schemes: {Scheme.Https})
type
  Call_VirtualWANsGet_564226 = ref object of OpenApiRestCall_563555
proc url_VirtualWANsGet_564228(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualWANsGet_564227(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Retrieves the details of a VirtualWAN.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   VirtualWANName: JString (required)
  ##                 : The name of the VirtualWAN being retrieved.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VirtualWan.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `VirtualWANName` field"
  var valid_564229 = path.getOrDefault("VirtualWANName")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "VirtualWANName", valid_564229
  var valid_564230 = path.getOrDefault("subscriptionId")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "subscriptionId", valid_564230
  var valid_564231 = path.getOrDefault("resourceGroupName")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "resourceGroupName", valid_564231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564232 = query.getOrDefault("api-version")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "api-version", valid_564232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564233: Call_VirtualWANsGet_564226; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a VirtualWAN.
  ## 
  let valid = call_564233.validator(path, query, header, formData, body)
  let scheme = call_564233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564233.url(scheme.get, call_564233.host, call_564233.base,
                         call_564233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564233, url, valid)

proc call*(call_564234: Call_VirtualWANsGet_564226; VirtualWANName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## virtualWANsGet
  ## Retrieves the details of a VirtualWAN.
  ##   VirtualWANName: string (required)
  ##                 : The name of the VirtualWAN being retrieved.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualWan.
  var path_564235 = newJObject()
  var query_564236 = newJObject()
  add(path_564235, "VirtualWANName", newJString(VirtualWANName))
  add(query_564236, "api-version", newJString(apiVersion))
  add(path_564235, "subscriptionId", newJString(subscriptionId))
  add(path_564235, "resourceGroupName", newJString(resourceGroupName))
  result = call_564234.call(path_564235, query_564236, nil, nil, nil)

var virtualWANsGet* = Call_VirtualWANsGet_564226(name: "virtualWANsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{VirtualWANName}",
    validator: validate_VirtualWANsGet_564227, base: "", url: url_VirtualWANsGet_564228,
    schemes: {Scheme.Https})
type
  Call_VirtualWANsUpdateTags_564261 = ref object of OpenApiRestCall_563555
proc url_VirtualWANsUpdateTags_564263(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualWANsUpdateTags_564262(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a VirtualWAN tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   VirtualWANName: JString (required)
  ##                 : The name of the VirtualWAN being updated.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VirtualWan.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `VirtualWANName` field"
  var valid_564264 = path.getOrDefault("VirtualWANName")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "VirtualWANName", valid_564264
  var valid_564265 = path.getOrDefault("subscriptionId")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = nil)
  if valid_564265 != nil:
    section.add "subscriptionId", valid_564265
  var valid_564266 = path.getOrDefault("resourceGroupName")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "resourceGroupName", valid_564266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564267 = query.getOrDefault("api-version")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "api-version", valid_564267
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

proc call*(call_564269: Call_VirtualWANsUpdateTags_564261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a VirtualWAN tags.
  ## 
  let valid = call_564269.validator(path, query, header, formData, body)
  let scheme = call_564269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564269.url(scheme.get, call_564269.host, call_564269.base,
                         call_564269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564269, url, valid)

proc call*(call_564270: Call_VirtualWANsUpdateTags_564261; WANParameters: JsonNode;
          VirtualWANName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## virtualWANsUpdateTags
  ## Updates a VirtualWAN tags.
  ##   WANParameters: JObject (required)
  ##                : Parameters supplied to Update VirtualWAN tags.
  ##   VirtualWANName: string (required)
  ##                 : The name of the VirtualWAN being updated.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualWan.
  var path_564271 = newJObject()
  var query_564272 = newJObject()
  var body_564273 = newJObject()
  if WANParameters != nil:
    body_564273 = WANParameters
  add(path_564271, "VirtualWANName", newJString(VirtualWANName))
  add(query_564272, "api-version", newJString(apiVersion))
  add(path_564271, "subscriptionId", newJString(subscriptionId))
  add(path_564271, "resourceGroupName", newJString(resourceGroupName))
  result = call_564270.call(path_564271, query_564272, nil, nil, body_564273)

var virtualWANsUpdateTags* = Call_VirtualWANsUpdateTags_564261(
    name: "virtualWANsUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{VirtualWANName}",
    validator: validate_VirtualWANsUpdateTags_564262, base: "",
    url: url_VirtualWANsUpdateTags_564263, schemes: {Scheme.Https})
type
  Call_VirtualWANsDelete_564250 = ref object of OpenApiRestCall_563555
proc url_VirtualWANsDelete_564252(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualWANsDelete_564251(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes a VirtualWAN.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   VirtualWANName: JString (required)
  ##                 : The name of the VirtualWAN being deleted.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VirtualWan.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `VirtualWANName` field"
  var valid_564253 = path.getOrDefault("VirtualWANName")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "VirtualWANName", valid_564253
  var valid_564254 = path.getOrDefault("subscriptionId")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "subscriptionId", valid_564254
  var valid_564255 = path.getOrDefault("resourceGroupName")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "resourceGroupName", valid_564255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564256 = query.getOrDefault("api-version")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "api-version", valid_564256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564257: Call_VirtualWANsDelete_564250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a VirtualWAN.
  ## 
  let valid = call_564257.validator(path, query, header, formData, body)
  let scheme = call_564257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564257.url(scheme.get, call_564257.host, call_564257.base,
                         call_564257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564257, url, valid)

proc call*(call_564258: Call_VirtualWANsDelete_564250; VirtualWANName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## virtualWANsDelete
  ## Deletes a VirtualWAN.
  ##   VirtualWANName: string (required)
  ##                 : The name of the VirtualWAN being deleted.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualWan.
  var path_564259 = newJObject()
  var query_564260 = newJObject()
  add(path_564259, "VirtualWANName", newJString(VirtualWANName))
  add(query_564260, "api-version", newJString(apiVersion))
  add(path_564259, "subscriptionId", newJString(subscriptionId))
  add(path_564259, "resourceGroupName", newJString(resourceGroupName))
  result = call_564258.call(path_564259, query_564260, nil, nil, nil)

var virtualWANsDelete* = Call_VirtualWANsDelete_564250(name: "virtualWANsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{VirtualWANName}",
    validator: validate_VirtualWANsDelete_564251, base: "",
    url: url_VirtualWANsDelete_564252, schemes: {Scheme.Https})
type
  Call_VpnSitesConfigurationDownload_564274 = ref object of OpenApiRestCall_563555
proc url_VpnSitesConfigurationDownload_564276(protocol: Scheme; host: string;
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

proc validate_VpnSitesConfigurationDownload_564275(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gives the sas-url to download the configurations for vpn-sites in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   virtualWANName: JString (required)
  ##                 : The name of the VirtualWAN for which configuration of all vpn-sites is needed.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564277 = path.getOrDefault("subscriptionId")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = nil)
  if valid_564277 != nil:
    section.add "subscriptionId", valid_564277
  var valid_564278 = path.getOrDefault("resourceGroupName")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "resourceGroupName", valid_564278
  var valid_564279 = path.getOrDefault("virtualWANName")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = nil)
  if valid_564279 != nil:
    section.add "virtualWANName", valid_564279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564280 = query.getOrDefault("api-version")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "api-version", valid_564280
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

proc call*(call_564282: Call_VpnSitesConfigurationDownload_564274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gives the sas-url to download the configurations for vpn-sites in a resource group.
  ## 
  let valid = call_564282.validator(path, query, header, formData, body)
  let scheme = call_564282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564282.url(scheme.get, call_564282.host, call_564282.base,
                         call_564282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564282, url, valid)

proc call*(call_564283: Call_VpnSitesConfigurationDownload_564274;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          virtualWANName: string; request: JsonNode): Recallable =
  ## vpnSitesConfigurationDownload
  ## Gives the sas-url to download the configurations for vpn-sites in a resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   virtualWANName: string (required)
  ##                 : The name of the VirtualWAN for which configuration of all vpn-sites is needed.
  ##   request: JObject (required)
  ##          : Parameters supplied to download vpn-sites configuration.
  var path_564284 = newJObject()
  var query_564285 = newJObject()
  var body_564286 = newJObject()
  add(query_564285, "api-version", newJString(apiVersion))
  add(path_564284, "subscriptionId", newJString(subscriptionId))
  add(path_564284, "resourceGroupName", newJString(resourceGroupName))
  add(path_564284, "virtualWANName", newJString(virtualWANName))
  if request != nil:
    body_564286 = request
  result = call_564283.call(path_564284, query_564285, nil, nil, body_564286)

var vpnSitesConfigurationDownload* = Call_VpnSitesConfigurationDownload_564274(
    name: "vpnSitesConfigurationDownload", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{virtualWANName}/vpnConfiguration",
    validator: validate_VpnSitesConfigurationDownload_564275, base: "",
    url: url_VpnSitesConfigurationDownload_564276, schemes: {Scheme.Https})
type
  Call_VpnGatewaysListByResourceGroup_564287 = ref object of OpenApiRestCall_563555
proc url_VpnGatewaysListByResourceGroup_564289(protocol: Scheme; host: string;
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

proc validate_VpnGatewaysListByResourceGroup_564288(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the VpnGateways in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnGateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564290 = path.getOrDefault("subscriptionId")
  valid_564290 = validateParameter(valid_564290, JString, required = true,
                                 default = nil)
  if valid_564290 != nil:
    section.add "subscriptionId", valid_564290
  var valid_564291 = path.getOrDefault("resourceGroupName")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = nil)
  if valid_564291 != nil:
    section.add "resourceGroupName", valid_564291
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564292 = query.getOrDefault("api-version")
  valid_564292 = validateParameter(valid_564292, JString, required = true,
                                 default = nil)
  if valid_564292 != nil:
    section.add "api-version", valid_564292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564293: Call_VpnGatewaysListByResourceGroup_564287; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VpnGateways in a resource group.
  ## 
  let valid = call_564293.validator(path, query, header, formData, body)
  let scheme = call_564293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564293.url(scheme.get, call_564293.host, call_564293.base,
                         call_564293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564293, url, valid)

proc call*(call_564294: Call_VpnGatewaysListByResourceGroup_564287;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## vpnGatewaysListByResourceGroup
  ## Lists all the VpnGateways in a resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnGateway.
  var path_564295 = newJObject()
  var query_564296 = newJObject()
  add(query_564296, "api-version", newJString(apiVersion))
  add(path_564295, "subscriptionId", newJString(subscriptionId))
  add(path_564295, "resourceGroupName", newJString(resourceGroupName))
  result = call_564294.call(path_564295, query_564296, nil, nil, nil)

var vpnGatewaysListByResourceGroup* = Call_VpnGatewaysListByResourceGroup_564287(
    name: "vpnGatewaysListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways",
    validator: validate_VpnGatewaysListByResourceGroup_564288, base: "",
    url: url_VpnGatewaysListByResourceGroup_564289, schemes: {Scheme.Https})
type
  Call_VpnGatewaysCreateOrUpdate_564308 = ref object of OpenApiRestCall_563555
proc url_VpnGatewaysCreateOrUpdate_564310(protocol: Scheme; host: string;
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

proc validate_VpnGatewaysCreateOrUpdate_564309(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a virtual wan vpn gateway if it doesn't exist else updates the existing gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   gatewayName: JString (required)
  ##              : The name of the gateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnGateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `gatewayName` field"
  var valid_564311 = path.getOrDefault("gatewayName")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "gatewayName", valid_564311
  var valid_564312 = path.getOrDefault("subscriptionId")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "subscriptionId", valid_564312
  var valid_564313 = path.getOrDefault("resourceGroupName")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "resourceGroupName", valid_564313
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564314 = query.getOrDefault("api-version")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "api-version", valid_564314
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

proc call*(call_564316: Call_VpnGatewaysCreateOrUpdate_564308; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a virtual wan vpn gateway if it doesn't exist else updates the existing gateway.
  ## 
  let valid = call_564316.validator(path, query, header, formData, body)
  let scheme = call_564316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564316.url(scheme.get, call_564316.host, call_564316.base,
                         call_564316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564316, url, valid)

proc call*(call_564317: Call_VpnGatewaysCreateOrUpdate_564308; apiVersion: string;
          vpnGatewayParameters: JsonNode; gatewayName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## vpnGatewaysCreateOrUpdate
  ## Creates a virtual wan vpn gateway if it doesn't exist else updates the existing gateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   vpnGatewayParameters: JObject (required)
  ##                       : Parameters supplied to create or Update a virtual wan vpn gateway.
  ##   gatewayName: string (required)
  ##              : The name of the gateway.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnGateway.
  var path_564318 = newJObject()
  var query_564319 = newJObject()
  var body_564320 = newJObject()
  add(query_564319, "api-version", newJString(apiVersion))
  if vpnGatewayParameters != nil:
    body_564320 = vpnGatewayParameters
  add(path_564318, "gatewayName", newJString(gatewayName))
  add(path_564318, "subscriptionId", newJString(subscriptionId))
  add(path_564318, "resourceGroupName", newJString(resourceGroupName))
  result = call_564317.call(path_564318, query_564319, nil, nil, body_564320)

var vpnGatewaysCreateOrUpdate* = Call_VpnGatewaysCreateOrUpdate_564308(
    name: "vpnGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}",
    validator: validate_VpnGatewaysCreateOrUpdate_564309, base: "",
    url: url_VpnGatewaysCreateOrUpdate_564310, schemes: {Scheme.Https})
type
  Call_VpnGatewaysGet_564297 = ref object of OpenApiRestCall_563555
proc url_VpnGatewaysGet_564299(protocol: Scheme; host: string; base: string;
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

proc validate_VpnGatewaysGet_564298(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Retrieves the details of a virtual wan vpn gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   gatewayName: JString (required)
  ##              : The name of the gateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnGateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `gatewayName` field"
  var valid_564300 = path.getOrDefault("gatewayName")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "gatewayName", valid_564300
  var valid_564301 = path.getOrDefault("subscriptionId")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "subscriptionId", valid_564301
  var valid_564302 = path.getOrDefault("resourceGroupName")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "resourceGroupName", valid_564302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564303 = query.getOrDefault("api-version")
  valid_564303 = validateParameter(valid_564303, JString, required = true,
                                 default = nil)
  if valid_564303 != nil:
    section.add "api-version", valid_564303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564304: Call_VpnGatewaysGet_564297; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a virtual wan vpn gateway.
  ## 
  let valid = call_564304.validator(path, query, header, formData, body)
  let scheme = call_564304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564304.url(scheme.get, call_564304.host, call_564304.base,
                         call_564304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564304, url, valid)

proc call*(call_564305: Call_VpnGatewaysGet_564297; apiVersion: string;
          gatewayName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## vpnGatewaysGet
  ## Retrieves the details of a virtual wan vpn gateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   gatewayName: string (required)
  ##              : The name of the gateway.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnGateway.
  var path_564306 = newJObject()
  var query_564307 = newJObject()
  add(query_564307, "api-version", newJString(apiVersion))
  add(path_564306, "gatewayName", newJString(gatewayName))
  add(path_564306, "subscriptionId", newJString(subscriptionId))
  add(path_564306, "resourceGroupName", newJString(resourceGroupName))
  result = call_564305.call(path_564306, query_564307, nil, nil, nil)

var vpnGatewaysGet* = Call_VpnGatewaysGet_564297(name: "vpnGatewaysGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}",
    validator: validate_VpnGatewaysGet_564298, base: "", url: url_VpnGatewaysGet_564299,
    schemes: {Scheme.Https})
type
  Call_VpnGatewaysUpdateTags_564332 = ref object of OpenApiRestCall_563555
proc url_VpnGatewaysUpdateTags_564334(protocol: Scheme; host: string; base: string;
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

proc validate_VpnGatewaysUpdateTags_564333(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates virtual wan vpn gateway tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   gatewayName: JString (required)
  ##              : The name of the gateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnGateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `gatewayName` field"
  var valid_564335 = path.getOrDefault("gatewayName")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "gatewayName", valid_564335
  var valid_564336 = path.getOrDefault("subscriptionId")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "subscriptionId", valid_564336
  var valid_564337 = path.getOrDefault("resourceGroupName")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "resourceGroupName", valid_564337
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564338 = query.getOrDefault("api-version")
  valid_564338 = validateParameter(valid_564338, JString, required = true,
                                 default = nil)
  if valid_564338 != nil:
    section.add "api-version", valid_564338
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

proc call*(call_564340: Call_VpnGatewaysUpdateTags_564332; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates virtual wan vpn gateway tags.
  ## 
  let valid = call_564340.validator(path, query, header, formData, body)
  let scheme = call_564340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564340.url(scheme.get, call_564340.host, call_564340.base,
                         call_564340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564340, url, valid)

proc call*(call_564341: Call_VpnGatewaysUpdateTags_564332; apiVersion: string;
          vpnGatewayParameters: JsonNode; gatewayName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## vpnGatewaysUpdateTags
  ## Updates virtual wan vpn gateway tags.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   vpnGatewayParameters: JObject (required)
  ##                       : Parameters supplied to update a virtual wan vpn gateway tags.
  ##   gatewayName: string (required)
  ##              : The name of the gateway.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnGateway.
  var path_564342 = newJObject()
  var query_564343 = newJObject()
  var body_564344 = newJObject()
  add(query_564343, "api-version", newJString(apiVersion))
  if vpnGatewayParameters != nil:
    body_564344 = vpnGatewayParameters
  add(path_564342, "gatewayName", newJString(gatewayName))
  add(path_564342, "subscriptionId", newJString(subscriptionId))
  add(path_564342, "resourceGroupName", newJString(resourceGroupName))
  result = call_564341.call(path_564342, query_564343, nil, nil, body_564344)

var vpnGatewaysUpdateTags* = Call_VpnGatewaysUpdateTags_564332(
    name: "vpnGatewaysUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}",
    validator: validate_VpnGatewaysUpdateTags_564333, base: "",
    url: url_VpnGatewaysUpdateTags_564334, schemes: {Scheme.Https})
type
  Call_VpnGatewaysDelete_564321 = ref object of OpenApiRestCall_563555
proc url_VpnGatewaysDelete_564323(protocol: Scheme; host: string; base: string;
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

proc validate_VpnGatewaysDelete_564322(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes a virtual wan vpn gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   gatewayName: JString (required)
  ##              : The name of the gateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnGateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `gatewayName` field"
  var valid_564324 = path.getOrDefault("gatewayName")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "gatewayName", valid_564324
  var valid_564325 = path.getOrDefault("subscriptionId")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "subscriptionId", valid_564325
  var valid_564326 = path.getOrDefault("resourceGroupName")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "resourceGroupName", valid_564326
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564327 = query.getOrDefault("api-version")
  valid_564327 = validateParameter(valid_564327, JString, required = true,
                                 default = nil)
  if valid_564327 != nil:
    section.add "api-version", valid_564327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564328: Call_VpnGatewaysDelete_564321; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a virtual wan vpn gateway.
  ## 
  let valid = call_564328.validator(path, query, header, formData, body)
  let scheme = call_564328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564328.url(scheme.get, call_564328.host, call_564328.base,
                         call_564328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564328, url, valid)

proc call*(call_564329: Call_VpnGatewaysDelete_564321; apiVersion: string;
          gatewayName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## vpnGatewaysDelete
  ## Deletes a virtual wan vpn gateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   gatewayName: string (required)
  ##              : The name of the gateway.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnGateway.
  var path_564330 = newJObject()
  var query_564331 = newJObject()
  add(query_564331, "api-version", newJString(apiVersion))
  add(path_564330, "gatewayName", newJString(gatewayName))
  add(path_564330, "subscriptionId", newJString(subscriptionId))
  add(path_564330, "resourceGroupName", newJString(resourceGroupName))
  result = call_564329.call(path_564330, query_564331, nil, nil, nil)

var vpnGatewaysDelete* = Call_VpnGatewaysDelete_564321(name: "vpnGatewaysDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}",
    validator: validate_VpnGatewaysDelete_564322, base: "",
    url: url_VpnGatewaysDelete_564323, schemes: {Scheme.Https})
type
  Call_VpnConnectionsListByVpnGateway_564345 = ref object of OpenApiRestCall_563555
proc url_VpnConnectionsListByVpnGateway_564347(protocol: Scheme; host: string;
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

proc validate_VpnConnectionsListByVpnGateway_564346(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all vpn connections for a particular virtual wan vpn gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   gatewayName: JString (required)
  ##              : The name of the gateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnGateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `gatewayName` field"
  var valid_564348 = path.getOrDefault("gatewayName")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "gatewayName", valid_564348
  var valid_564349 = path.getOrDefault("subscriptionId")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "subscriptionId", valid_564349
  var valid_564350 = path.getOrDefault("resourceGroupName")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "resourceGroupName", valid_564350
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564351 = query.getOrDefault("api-version")
  valid_564351 = validateParameter(valid_564351, JString, required = true,
                                 default = nil)
  if valid_564351 != nil:
    section.add "api-version", valid_564351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564352: Call_VpnConnectionsListByVpnGateway_564345; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all vpn connections for a particular virtual wan vpn gateway.
  ## 
  let valid = call_564352.validator(path, query, header, formData, body)
  let scheme = call_564352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564352.url(scheme.get, call_564352.host, call_564352.base,
                         call_564352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564352, url, valid)

proc call*(call_564353: Call_VpnConnectionsListByVpnGateway_564345;
          apiVersion: string; gatewayName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## vpnConnectionsListByVpnGateway
  ## Retrieves all vpn connections for a particular virtual wan vpn gateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   gatewayName: string (required)
  ##              : The name of the gateway.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnGateway.
  var path_564354 = newJObject()
  var query_564355 = newJObject()
  add(query_564355, "api-version", newJString(apiVersion))
  add(path_564354, "gatewayName", newJString(gatewayName))
  add(path_564354, "subscriptionId", newJString(subscriptionId))
  add(path_564354, "resourceGroupName", newJString(resourceGroupName))
  result = call_564353.call(path_564354, query_564355, nil, nil, nil)

var vpnConnectionsListByVpnGateway* = Call_VpnConnectionsListByVpnGateway_564345(
    name: "vpnConnectionsListByVpnGateway", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections",
    validator: validate_VpnConnectionsListByVpnGateway_564346, base: "",
    url: url_VpnConnectionsListByVpnGateway_564347, schemes: {Scheme.Https})
type
  Call_VpnConnectionsCreateOrUpdate_564368 = ref object of OpenApiRestCall_563555
proc url_VpnConnectionsCreateOrUpdate_564370(protocol: Scheme; host: string;
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

proc validate_VpnConnectionsCreateOrUpdate_564369(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a vpn connection to a scalable vpn gateway if it doesn't exist else updates the existing connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   gatewayName: JString (required)
  ##              : The name of the gateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: JString (required)
  ##                 : The name of the connection.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnGateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `gatewayName` field"
  var valid_564371 = path.getOrDefault("gatewayName")
  valid_564371 = validateParameter(valid_564371, JString, required = true,
                                 default = nil)
  if valid_564371 != nil:
    section.add "gatewayName", valid_564371
  var valid_564372 = path.getOrDefault("subscriptionId")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "subscriptionId", valid_564372
  var valid_564373 = path.getOrDefault("connectionName")
  valid_564373 = validateParameter(valid_564373, JString, required = true,
                                 default = nil)
  if valid_564373 != nil:
    section.add "connectionName", valid_564373
  var valid_564374 = path.getOrDefault("resourceGroupName")
  valid_564374 = validateParameter(valid_564374, JString, required = true,
                                 default = nil)
  if valid_564374 != nil:
    section.add "resourceGroupName", valid_564374
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564375 = query.getOrDefault("api-version")
  valid_564375 = validateParameter(valid_564375, JString, required = true,
                                 default = nil)
  if valid_564375 != nil:
    section.add "api-version", valid_564375
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

proc call*(call_564377: Call_VpnConnectionsCreateOrUpdate_564368; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a vpn connection to a scalable vpn gateway if it doesn't exist else updates the existing connection.
  ## 
  let valid = call_564377.validator(path, query, header, formData, body)
  let scheme = call_564377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564377.url(scheme.get, call_564377.host, call_564377.base,
                         call_564377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564377, url, valid)

proc call*(call_564378: Call_VpnConnectionsCreateOrUpdate_564368;
          VpnConnectionParameters: JsonNode; apiVersion: string;
          gatewayName: string; subscriptionId: string; connectionName: string;
          resourceGroupName: string): Recallable =
  ## vpnConnectionsCreateOrUpdate
  ## Creates a vpn connection to a scalable vpn gateway if it doesn't exist else updates the existing connection.
  ##   VpnConnectionParameters: JObject (required)
  ##                          : Parameters supplied to create or Update a VPN Connection.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   gatewayName: string (required)
  ##              : The name of the gateway.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: string (required)
  ##                 : The name of the connection.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnGateway.
  var path_564379 = newJObject()
  var query_564380 = newJObject()
  var body_564381 = newJObject()
  if VpnConnectionParameters != nil:
    body_564381 = VpnConnectionParameters
  add(query_564380, "api-version", newJString(apiVersion))
  add(path_564379, "gatewayName", newJString(gatewayName))
  add(path_564379, "subscriptionId", newJString(subscriptionId))
  add(path_564379, "connectionName", newJString(connectionName))
  add(path_564379, "resourceGroupName", newJString(resourceGroupName))
  result = call_564378.call(path_564379, query_564380, nil, nil, body_564381)

var vpnConnectionsCreateOrUpdate* = Call_VpnConnectionsCreateOrUpdate_564368(
    name: "vpnConnectionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections/{connectionName}",
    validator: validate_VpnConnectionsCreateOrUpdate_564369, base: "",
    url: url_VpnConnectionsCreateOrUpdate_564370, schemes: {Scheme.Https})
type
  Call_VpnConnectionsGet_564356 = ref object of OpenApiRestCall_563555
proc url_VpnConnectionsGet_564358(protocol: Scheme; host: string; base: string;
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

proc validate_VpnConnectionsGet_564357(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Retrieves the details of a vpn connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   gatewayName: JString (required)
  ##              : The name of the gateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: JString (required)
  ##                 : The name of the vpn connection.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnGateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `gatewayName` field"
  var valid_564359 = path.getOrDefault("gatewayName")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "gatewayName", valid_564359
  var valid_564360 = path.getOrDefault("subscriptionId")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "subscriptionId", valid_564360
  var valid_564361 = path.getOrDefault("connectionName")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "connectionName", valid_564361
  var valid_564362 = path.getOrDefault("resourceGroupName")
  valid_564362 = validateParameter(valid_564362, JString, required = true,
                                 default = nil)
  if valid_564362 != nil:
    section.add "resourceGroupName", valid_564362
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564363 = query.getOrDefault("api-version")
  valid_564363 = validateParameter(valid_564363, JString, required = true,
                                 default = nil)
  if valid_564363 != nil:
    section.add "api-version", valid_564363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564364: Call_VpnConnectionsGet_564356; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a vpn connection.
  ## 
  let valid = call_564364.validator(path, query, header, formData, body)
  let scheme = call_564364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564364.url(scheme.get, call_564364.host, call_564364.base,
                         call_564364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564364, url, valid)

proc call*(call_564365: Call_VpnConnectionsGet_564356; apiVersion: string;
          gatewayName: string; subscriptionId: string; connectionName: string;
          resourceGroupName: string): Recallable =
  ## vpnConnectionsGet
  ## Retrieves the details of a vpn connection.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   gatewayName: string (required)
  ##              : The name of the gateway.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: string (required)
  ##                 : The name of the vpn connection.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnGateway.
  var path_564366 = newJObject()
  var query_564367 = newJObject()
  add(query_564367, "api-version", newJString(apiVersion))
  add(path_564366, "gatewayName", newJString(gatewayName))
  add(path_564366, "subscriptionId", newJString(subscriptionId))
  add(path_564366, "connectionName", newJString(connectionName))
  add(path_564366, "resourceGroupName", newJString(resourceGroupName))
  result = call_564365.call(path_564366, query_564367, nil, nil, nil)

var vpnConnectionsGet* = Call_VpnConnectionsGet_564356(name: "vpnConnectionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections/{connectionName}",
    validator: validate_VpnConnectionsGet_564357, base: "",
    url: url_VpnConnectionsGet_564358, schemes: {Scheme.Https})
type
  Call_VpnConnectionsDelete_564382 = ref object of OpenApiRestCall_563555
proc url_VpnConnectionsDelete_564384(protocol: Scheme; host: string; base: string;
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

proc validate_VpnConnectionsDelete_564383(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a vpn connection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   gatewayName: JString (required)
  ##              : The name of the gateway.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: JString (required)
  ##                 : The name of the connection.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnGateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `gatewayName` field"
  var valid_564385 = path.getOrDefault("gatewayName")
  valid_564385 = validateParameter(valid_564385, JString, required = true,
                                 default = nil)
  if valid_564385 != nil:
    section.add "gatewayName", valid_564385
  var valid_564386 = path.getOrDefault("subscriptionId")
  valid_564386 = validateParameter(valid_564386, JString, required = true,
                                 default = nil)
  if valid_564386 != nil:
    section.add "subscriptionId", valid_564386
  var valid_564387 = path.getOrDefault("connectionName")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "connectionName", valid_564387
  var valid_564388 = path.getOrDefault("resourceGroupName")
  valid_564388 = validateParameter(valid_564388, JString, required = true,
                                 default = nil)
  if valid_564388 != nil:
    section.add "resourceGroupName", valid_564388
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564389 = query.getOrDefault("api-version")
  valid_564389 = validateParameter(valid_564389, JString, required = true,
                                 default = nil)
  if valid_564389 != nil:
    section.add "api-version", valid_564389
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564390: Call_VpnConnectionsDelete_564382; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a vpn connection.
  ## 
  let valid = call_564390.validator(path, query, header, formData, body)
  let scheme = call_564390.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564390.url(scheme.get, call_564390.host, call_564390.base,
                         call_564390.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564390, url, valid)

proc call*(call_564391: Call_VpnConnectionsDelete_564382; apiVersion: string;
          gatewayName: string; subscriptionId: string; connectionName: string;
          resourceGroupName: string): Recallable =
  ## vpnConnectionsDelete
  ## Deletes a vpn connection.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   gatewayName: string (required)
  ##              : The name of the gateway.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: string (required)
  ##                 : The name of the connection.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnGateway.
  var path_564392 = newJObject()
  var query_564393 = newJObject()
  add(query_564393, "api-version", newJString(apiVersion))
  add(path_564392, "gatewayName", newJString(gatewayName))
  add(path_564392, "subscriptionId", newJString(subscriptionId))
  add(path_564392, "connectionName", newJString(connectionName))
  add(path_564392, "resourceGroupName", newJString(resourceGroupName))
  result = call_564391.call(path_564392, query_564393, nil, nil, nil)

var vpnConnectionsDelete* = Call_VpnConnectionsDelete_564382(
    name: "vpnConnectionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections/{connectionName}",
    validator: validate_VpnConnectionsDelete_564383, base: "",
    url: url_VpnConnectionsDelete_564384, schemes: {Scheme.Https})
type
  Call_VpnSitesListByResourceGroup_564394 = ref object of OpenApiRestCall_563555
proc url_VpnSitesListByResourceGroup_564396(protocol: Scheme; host: string;
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

proc validate_VpnSitesListByResourceGroup_564395(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the vpnSites in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnSite.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564397 = path.getOrDefault("subscriptionId")
  valid_564397 = validateParameter(valid_564397, JString, required = true,
                                 default = nil)
  if valid_564397 != nil:
    section.add "subscriptionId", valid_564397
  var valid_564398 = path.getOrDefault("resourceGroupName")
  valid_564398 = validateParameter(valid_564398, JString, required = true,
                                 default = nil)
  if valid_564398 != nil:
    section.add "resourceGroupName", valid_564398
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564399 = query.getOrDefault("api-version")
  valid_564399 = validateParameter(valid_564399, JString, required = true,
                                 default = nil)
  if valid_564399 != nil:
    section.add "api-version", valid_564399
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564400: Call_VpnSitesListByResourceGroup_564394; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the vpnSites in a resource group.
  ## 
  let valid = call_564400.validator(path, query, header, formData, body)
  let scheme = call_564400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564400.url(scheme.get, call_564400.host, call_564400.base,
                         call_564400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564400, url, valid)

proc call*(call_564401: Call_VpnSitesListByResourceGroup_564394;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## vpnSitesListByResourceGroup
  ## Lists all the vpnSites in a resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnSite.
  var path_564402 = newJObject()
  var query_564403 = newJObject()
  add(query_564403, "api-version", newJString(apiVersion))
  add(path_564402, "subscriptionId", newJString(subscriptionId))
  add(path_564402, "resourceGroupName", newJString(resourceGroupName))
  result = call_564401.call(path_564402, query_564403, nil, nil, nil)

var vpnSitesListByResourceGroup* = Call_VpnSitesListByResourceGroup_564394(
    name: "vpnSitesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites",
    validator: validate_VpnSitesListByResourceGroup_564395, base: "",
    url: url_VpnSitesListByResourceGroup_564396, schemes: {Scheme.Https})
type
  Call_VpnSitesCreateOrUpdate_564415 = ref object of OpenApiRestCall_563555
proc url_VpnSitesCreateOrUpdate_564417(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSitesCreateOrUpdate_564416(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a VpnSite resource if it doesn't exist else updates the existing VpnSite.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vpnSiteName: JString (required)
  ##              : The name of the VpnSite being created or updated.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnSite.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vpnSiteName` field"
  var valid_564418 = path.getOrDefault("vpnSiteName")
  valid_564418 = validateParameter(valid_564418, JString, required = true,
                                 default = nil)
  if valid_564418 != nil:
    section.add "vpnSiteName", valid_564418
  var valid_564419 = path.getOrDefault("subscriptionId")
  valid_564419 = validateParameter(valid_564419, JString, required = true,
                                 default = nil)
  if valid_564419 != nil:
    section.add "subscriptionId", valid_564419
  var valid_564420 = path.getOrDefault("resourceGroupName")
  valid_564420 = validateParameter(valid_564420, JString, required = true,
                                 default = nil)
  if valid_564420 != nil:
    section.add "resourceGroupName", valid_564420
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564421 = query.getOrDefault("api-version")
  valid_564421 = validateParameter(valid_564421, JString, required = true,
                                 default = nil)
  if valid_564421 != nil:
    section.add "api-version", valid_564421
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

proc call*(call_564423: Call_VpnSitesCreateOrUpdate_564415; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a VpnSite resource if it doesn't exist else updates the existing VpnSite.
  ## 
  let valid = call_564423.validator(path, query, header, formData, body)
  let scheme = call_564423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564423.url(scheme.get, call_564423.host, call_564423.base,
                         call_564423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564423, url, valid)

proc call*(call_564424: Call_VpnSitesCreateOrUpdate_564415;
          VpnSiteParameters: JsonNode; apiVersion: string; vpnSiteName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## vpnSitesCreateOrUpdate
  ## Creates a VpnSite resource if it doesn't exist else updates the existing VpnSite.
  ##   VpnSiteParameters: JObject (required)
  ##                    : Parameters supplied to create or update VpnSite.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   vpnSiteName: string (required)
  ##              : The name of the VpnSite being created or updated.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnSite.
  var path_564425 = newJObject()
  var query_564426 = newJObject()
  var body_564427 = newJObject()
  if VpnSiteParameters != nil:
    body_564427 = VpnSiteParameters
  add(query_564426, "api-version", newJString(apiVersion))
  add(path_564425, "vpnSiteName", newJString(vpnSiteName))
  add(path_564425, "subscriptionId", newJString(subscriptionId))
  add(path_564425, "resourceGroupName", newJString(resourceGroupName))
  result = call_564424.call(path_564425, query_564426, nil, nil, body_564427)

var vpnSitesCreateOrUpdate* = Call_VpnSitesCreateOrUpdate_564415(
    name: "vpnSitesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}",
    validator: validate_VpnSitesCreateOrUpdate_564416, base: "",
    url: url_VpnSitesCreateOrUpdate_564417, schemes: {Scheme.Https})
type
  Call_VpnSitesGet_564404 = ref object of OpenApiRestCall_563555
proc url_VpnSitesGet_564406(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSitesGet_564405(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the details of a VPN site.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vpnSiteName: JString (required)
  ##              : The name of the VpnSite being retrieved.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnSite.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vpnSiteName` field"
  var valid_564407 = path.getOrDefault("vpnSiteName")
  valid_564407 = validateParameter(valid_564407, JString, required = true,
                                 default = nil)
  if valid_564407 != nil:
    section.add "vpnSiteName", valid_564407
  var valid_564408 = path.getOrDefault("subscriptionId")
  valid_564408 = validateParameter(valid_564408, JString, required = true,
                                 default = nil)
  if valid_564408 != nil:
    section.add "subscriptionId", valid_564408
  var valid_564409 = path.getOrDefault("resourceGroupName")
  valid_564409 = validateParameter(valid_564409, JString, required = true,
                                 default = nil)
  if valid_564409 != nil:
    section.add "resourceGroupName", valid_564409
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564410 = query.getOrDefault("api-version")
  valid_564410 = validateParameter(valid_564410, JString, required = true,
                                 default = nil)
  if valid_564410 != nil:
    section.add "api-version", valid_564410
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564411: Call_VpnSitesGet_564404; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a VPN site.
  ## 
  let valid = call_564411.validator(path, query, header, formData, body)
  let scheme = call_564411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564411.url(scheme.get, call_564411.host, call_564411.base,
                         call_564411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564411, url, valid)

proc call*(call_564412: Call_VpnSitesGet_564404; apiVersion: string;
          vpnSiteName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## vpnSitesGet
  ## Retrieves the details of a VPN site.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   vpnSiteName: string (required)
  ##              : The name of the VpnSite being retrieved.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnSite.
  var path_564413 = newJObject()
  var query_564414 = newJObject()
  add(query_564414, "api-version", newJString(apiVersion))
  add(path_564413, "vpnSiteName", newJString(vpnSiteName))
  add(path_564413, "subscriptionId", newJString(subscriptionId))
  add(path_564413, "resourceGroupName", newJString(resourceGroupName))
  result = call_564412.call(path_564413, query_564414, nil, nil, nil)

var vpnSitesGet* = Call_VpnSitesGet_564404(name: "vpnSitesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}",
                                        validator: validate_VpnSitesGet_564405,
                                        base: "", url: url_VpnSitesGet_564406,
                                        schemes: {Scheme.Https})
type
  Call_VpnSitesUpdateTags_564439 = ref object of OpenApiRestCall_563555
proc url_VpnSitesUpdateTags_564441(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSitesUpdateTags_564440(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates VpnSite tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vpnSiteName: JString (required)
  ##              : The name of the VpnSite being updated.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnSite.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vpnSiteName` field"
  var valid_564442 = path.getOrDefault("vpnSiteName")
  valid_564442 = validateParameter(valid_564442, JString, required = true,
                                 default = nil)
  if valid_564442 != nil:
    section.add "vpnSiteName", valid_564442
  var valid_564443 = path.getOrDefault("subscriptionId")
  valid_564443 = validateParameter(valid_564443, JString, required = true,
                                 default = nil)
  if valid_564443 != nil:
    section.add "subscriptionId", valid_564443
  var valid_564444 = path.getOrDefault("resourceGroupName")
  valid_564444 = validateParameter(valid_564444, JString, required = true,
                                 default = nil)
  if valid_564444 != nil:
    section.add "resourceGroupName", valid_564444
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564445 = query.getOrDefault("api-version")
  valid_564445 = validateParameter(valid_564445, JString, required = true,
                                 default = nil)
  if valid_564445 != nil:
    section.add "api-version", valid_564445
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

proc call*(call_564447: Call_VpnSitesUpdateTags_564439; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates VpnSite tags.
  ## 
  let valid = call_564447.validator(path, query, header, formData, body)
  let scheme = call_564447.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564447.url(scheme.get, call_564447.host, call_564447.base,
                         call_564447.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564447, url, valid)

proc call*(call_564448: Call_VpnSitesUpdateTags_564439;
          VpnSiteParameters: JsonNode; apiVersion: string; vpnSiteName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## vpnSitesUpdateTags
  ## Updates VpnSite tags.
  ##   VpnSiteParameters: JObject (required)
  ##                    : Parameters supplied to update VpnSite tags.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   vpnSiteName: string (required)
  ##              : The name of the VpnSite being updated.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnSite.
  var path_564449 = newJObject()
  var query_564450 = newJObject()
  var body_564451 = newJObject()
  if VpnSiteParameters != nil:
    body_564451 = VpnSiteParameters
  add(query_564450, "api-version", newJString(apiVersion))
  add(path_564449, "vpnSiteName", newJString(vpnSiteName))
  add(path_564449, "subscriptionId", newJString(subscriptionId))
  add(path_564449, "resourceGroupName", newJString(resourceGroupName))
  result = call_564448.call(path_564449, query_564450, nil, nil, body_564451)

var vpnSitesUpdateTags* = Call_VpnSitesUpdateTags_564439(
    name: "vpnSitesUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}",
    validator: validate_VpnSitesUpdateTags_564440, base: "",
    url: url_VpnSitesUpdateTags_564441, schemes: {Scheme.Https})
type
  Call_VpnSitesDelete_564428 = ref object of OpenApiRestCall_563555
proc url_VpnSitesDelete_564430(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSitesDelete_564429(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a VpnSite.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vpnSiteName: JString (required)
  ##              : The name of the VpnSite being deleted.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name of the VpnSite.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vpnSiteName` field"
  var valid_564431 = path.getOrDefault("vpnSiteName")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = nil)
  if valid_564431 != nil:
    section.add "vpnSiteName", valid_564431
  var valid_564432 = path.getOrDefault("subscriptionId")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "subscriptionId", valid_564432
  var valid_564433 = path.getOrDefault("resourceGroupName")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "resourceGroupName", valid_564433
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564434 = query.getOrDefault("api-version")
  valid_564434 = validateParameter(valid_564434, JString, required = true,
                                 default = nil)
  if valid_564434 != nil:
    section.add "api-version", valid_564434
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564435: Call_VpnSitesDelete_564428; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a VpnSite.
  ## 
  let valid = call_564435.validator(path, query, header, formData, body)
  let scheme = call_564435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564435.url(scheme.get, call_564435.host, call_564435.base,
                         call_564435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564435, url, valid)

proc call*(call_564436: Call_VpnSitesDelete_564428; apiVersion: string;
          vpnSiteName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## vpnSitesDelete
  ## Deletes a VpnSite.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   vpnSiteName: string (required)
  ##              : The name of the VpnSite being deleted.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnSite.
  var path_564437 = newJObject()
  var query_564438 = newJObject()
  add(query_564438, "api-version", newJString(apiVersion))
  add(path_564437, "vpnSiteName", newJString(vpnSiteName))
  add(path_564437, "subscriptionId", newJString(subscriptionId))
  add(path_564437, "resourceGroupName", newJString(resourceGroupName))
  result = call_564436.call(path_564437, query_564438, nil, nil, nil)

var vpnSitesDelete* = Call_VpnSitesDelete_564428(name: "vpnSitesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}",
    validator: validate_VpnSitesDelete_564429, base: "", url: url_VpnSitesDelete_564430,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
