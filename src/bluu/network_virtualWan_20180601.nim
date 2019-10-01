
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: VirtualWANAsAServiceManagementClient
## version: 2018-06-01
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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  Call_VirtualHubsList_567879 = ref object of OpenApiRestCall_567657
proc url_VirtualHubsList_567881(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualHubsList_567880(path: JsonNode; query: JsonNode;
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
  var valid_568041 = path.getOrDefault("subscriptionId")
  valid_568041 = validateParameter(valid_568041, JString, required = true,
                                 default = nil)
  if valid_568041 != nil:
    section.add "subscriptionId", valid_568041
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568042 = query.getOrDefault("api-version")
  valid_568042 = validateParameter(valid_568042, JString, required = true,
                                 default = nil)
  if valid_568042 != nil:
    section.add "api-version", valid_568042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568069: Call_VirtualHubsList_567879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VirtualHubs in a subscription.
  ## 
  let valid = call_568069.validator(path, query, header, formData, body)
  let scheme = call_568069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568069.url(scheme.get, call_568069.host, call_568069.base,
                         call_568069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568069, url, valid)

proc call*(call_568140: Call_VirtualHubsList_567879; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualHubsList
  ## Lists all the VirtualHubs in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568141 = newJObject()
  var query_568143 = newJObject()
  add(query_568143, "api-version", newJString(apiVersion))
  add(path_568141, "subscriptionId", newJString(subscriptionId))
  result = call_568140.call(path_568141, query_568143, nil, nil, nil)

var virtualHubsList* = Call_VirtualHubsList_567879(name: "virtualHubsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/virtualHubs",
    validator: validate_VirtualHubsList_567880, base: "", url: url_VirtualHubsList_567881,
    schemes: {Scheme.Https})
type
  Call_VirtualWANsList_568182 = ref object of OpenApiRestCall_567657
proc url_VirtualWANsList_568184(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualWANsList_568183(path: JsonNode; query: JsonNode;
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
  var valid_568185 = path.getOrDefault("subscriptionId")
  valid_568185 = validateParameter(valid_568185, JString, required = true,
                                 default = nil)
  if valid_568185 != nil:
    section.add "subscriptionId", valid_568185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568186 = query.getOrDefault("api-version")
  valid_568186 = validateParameter(valid_568186, JString, required = true,
                                 default = nil)
  if valid_568186 != nil:
    section.add "api-version", valid_568186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568187: Call_VirtualWANsList_568182; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VirtualWANs in a subscription.
  ## 
  let valid = call_568187.validator(path, query, header, formData, body)
  let scheme = call_568187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568187.url(scheme.get, call_568187.host, call_568187.base,
                         call_568187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568187, url, valid)

proc call*(call_568188: Call_VirtualWANsList_568182; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualWANsList
  ## Lists all the VirtualWANs in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568189 = newJObject()
  var query_568190 = newJObject()
  add(query_568190, "api-version", newJString(apiVersion))
  add(path_568189, "subscriptionId", newJString(subscriptionId))
  result = call_568188.call(path_568189, query_568190, nil, nil, nil)

var virtualWANsList* = Call_VirtualWANsList_568182(name: "virtualWANsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/virtualWans",
    validator: validate_VirtualWANsList_568183, base: "", url: url_VirtualWANsList_568184,
    schemes: {Scheme.Https})
type
  Call_VpnGatewaysList_568191 = ref object of OpenApiRestCall_567657
proc url_VpnGatewaysList_568193(protocol: Scheme; host: string; base: string;
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

proc validate_VpnGatewaysList_568192(path: JsonNode; query: JsonNode;
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

proc call*(call_568196: Call_VpnGatewaysList_568191; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VpnGateways in a subscription.
  ## 
  let valid = call_568196.validator(path, query, header, formData, body)
  let scheme = call_568196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568196.url(scheme.get, call_568196.host, call_568196.base,
                         call_568196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568196, url, valid)

proc call*(call_568197: Call_VpnGatewaysList_568191; apiVersion: string;
          subscriptionId: string): Recallable =
  ## vpnGatewaysList
  ## Lists all the VpnGateways in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568198 = newJObject()
  var query_568199 = newJObject()
  add(query_568199, "api-version", newJString(apiVersion))
  add(path_568198, "subscriptionId", newJString(subscriptionId))
  result = call_568197.call(path_568198, query_568199, nil, nil, nil)

var vpnGatewaysList* = Call_VpnGatewaysList_568191(name: "vpnGatewaysList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/vpnGateways",
    validator: validate_VpnGatewaysList_568192, base: "", url: url_VpnGatewaysList_568193,
    schemes: {Scheme.Https})
type
  Call_VpnSitesList_568200 = ref object of OpenApiRestCall_567657
proc url_VpnSitesList_568202(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSitesList_568201(path: JsonNode; query: JsonNode; header: JsonNode;
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

proc call*(call_568205: Call_VpnSitesList_568200; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VpnSites in a subscription.
  ## 
  let valid = call_568205.validator(path, query, header, formData, body)
  let scheme = call_568205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568205.url(scheme.get, call_568205.host, call_568205.base,
                         call_568205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568205, url, valid)

proc call*(call_568206: Call_VpnSitesList_568200; apiVersion: string;
          subscriptionId: string): Recallable =
  ## vpnSitesList
  ## Lists all the VpnSites in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568207 = newJObject()
  var query_568208 = newJObject()
  add(query_568208, "api-version", newJString(apiVersion))
  add(path_568207, "subscriptionId", newJString(subscriptionId))
  result = call_568206.call(path_568207, query_568208, nil, nil, nil)

var vpnSitesList* = Call_VpnSitesList_568200(name: "vpnSitesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/vpnSites",
    validator: validate_VpnSitesList_568201, base: "", url: url_VpnSitesList_568202,
    schemes: {Scheme.Https})
type
  Call_VirtualHubsListByResourceGroup_568209 = ref object of OpenApiRestCall_567657
proc url_VirtualHubsListByResourceGroup_568211(protocol: Scheme; host: string;
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

proc validate_VirtualHubsListByResourceGroup_568210(path: JsonNode;
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
  var valid_568212 = path.getOrDefault("resourceGroupName")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "resourceGroupName", valid_568212
  var valid_568213 = path.getOrDefault("subscriptionId")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "subscriptionId", valid_568213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568214 = query.getOrDefault("api-version")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "api-version", valid_568214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568215: Call_VirtualHubsListByResourceGroup_568209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VirtualHubs in a resource group.
  ## 
  let valid = call_568215.validator(path, query, header, formData, body)
  let scheme = call_568215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568215.url(scheme.get, call_568215.host, call_568215.base,
                         call_568215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568215, url, valid)

proc call*(call_568216: Call_VirtualHubsListByResourceGroup_568209;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualHubsListByResourceGroup
  ## Lists all the VirtualHubs in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualHub.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568217 = newJObject()
  var query_568218 = newJObject()
  add(path_568217, "resourceGroupName", newJString(resourceGroupName))
  add(query_568218, "api-version", newJString(apiVersion))
  add(path_568217, "subscriptionId", newJString(subscriptionId))
  result = call_568216.call(path_568217, query_568218, nil, nil, nil)

var virtualHubsListByResourceGroup* = Call_VirtualHubsListByResourceGroup_568209(
    name: "virtualHubsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs",
    validator: validate_VirtualHubsListByResourceGroup_568210, base: "",
    url: url_VirtualHubsListByResourceGroup_568211, schemes: {Scheme.Https})
type
  Call_VirtualHubsCreateOrUpdate_568230 = ref object of OpenApiRestCall_567657
proc url_VirtualHubsCreateOrUpdate_568232(protocol: Scheme; host: string;
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

proc validate_VirtualHubsCreateOrUpdate_568231(path: JsonNode; query: JsonNode;
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
  var valid_568259 = path.getOrDefault("resourceGroupName")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "resourceGroupName", valid_568259
  var valid_568260 = path.getOrDefault("subscriptionId")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "subscriptionId", valid_568260
  var valid_568261 = path.getOrDefault("virtualHubName")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "virtualHubName", valid_568261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568262 = query.getOrDefault("api-version")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "api-version", valid_568262
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

proc call*(call_568264: Call_VirtualHubsCreateOrUpdate_568230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a VirtualHub resource if it doesn't exist else updates the existing VirtualHub.
  ## 
  let valid = call_568264.validator(path, query, header, formData, body)
  let scheme = call_568264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568264.url(scheme.get, call_568264.host, call_568264.base,
                         call_568264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568264, url, valid)

proc call*(call_568265: Call_VirtualHubsCreateOrUpdate_568230;
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
  var path_568266 = newJObject()
  var query_568267 = newJObject()
  var body_568268 = newJObject()
  add(path_568266, "resourceGroupName", newJString(resourceGroupName))
  add(query_568267, "api-version", newJString(apiVersion))
  add(path_568266, "subscriptionId", newJString(subscriptionId))
  add(path_568266, "virtualHubName", newJString(virtualHubName))
  if virtualHubParameters != nil:
    body_568268 = virtualHubParameters
  result = call_568265.call(path_568266, query_568267, nil, nil, body_568268)

var virtualHubsCreateOrUpdate* = Call_VirtualHubsCreateOrUpdate_568230(
    name: "virtualHubsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}",
    validator: validate_VirtualHubsCreateOrUpdate_568231, base: "",
    url: url_VirtualHubsCreateOrUpdate_568232, schemes: {Scheme.Https})
type
  Call_VirtualHubsGet_568219 = ref object of OpenApiRestCall_567657
proc url_VirtualHubsGet_568221(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualHubsGet_568220(path: JsonNode; query: JsonNode;
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
  var valid_568222 = path.getOrDefault("resourceGroupName")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "resourceGroupName", valid_568222
  var valid_568223 = path.getOrDefault("subscriptionId")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "subscriptionId", valid_568223
  var valid_568224 = path.getOrDefault("virtualHubName")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "virtualHubName", valid_568224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568225 = query.getOrDefault("api-version")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "api-version", valid_568225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568226: Call_VirtualHubsGet_568219; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a VirtualHub.
  ## 
  let valid = call_568226.validator(path, query, header, formData, body)
  let scheme = call_568226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568226.url(scheme.get, call_568226.host, call_568226.base,
                         call_568226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568226, url, valid)

proc call*(call_568227: Call_VirtualHubsGet_568219; resourceGroupName: string;
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
  var path_568228 = newJObject()
  var query_568229 = newJObject()
  add(path_568228, "resourceGroupName", newJString(resourceGroupName))
  add(query_568229, "api-version", newJString(apiVersion))
  add(path_568228, "subscriptionId", newJString(subscriptionId))
  add(path_568228, "virtualHubName", newJString(virtualHubName))
  result = call_568227.call(path_568228, query_568229, nil, nil, nil)

var virtualHubsGet* = Call_VirtualHubsGet_568219(name: "virtualHubsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}",
    validator: validate_VirtualHubsGet_568220, base: "", url: url_VirtualHubsGet_568221,
    schemes: {Scheme.Https})
type
  Call_VirtualHubsUpdateTags_568280 = ref object of OpenApiRestCall_567657
proc url_VirtualHubsUpdateTags_568282(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualHubsUpdateTags_568281(path: JsonNode; query: JsonNode;
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
  var valid_568283 = path.getOrDefault("resourceGroupName")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "resourceGroupName", valid_568283
  var valid_568284 = path.getOrDefault("subscriptionId")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "subscriptionId", valid_568284
  var valid_568285 = path.getOrDefault("virtualHubName")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "virtualHubName", valid_568285
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568286 = query.getOrDefault("api-version")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "api-version", valid_568286
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

proc call*(call_568288: Call_VirtualHubsUpdateTags_568280; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates VirtualHub tags.
  ## 
  let valid = call_568288.validator(path, query, header, formData, body)
  let scheme = call_568288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568288.url(scheme.get, call_568288.host, call_568288.base,
                         call_568288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568288, url, valid)

proc call*(call_568289: Call_VirtualHubsUpdateTags_568280;
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
  var path_568290 = newJObject()
  var query_568291 = newJObject()
  var body_568292 = newJObject()
  add(path_568290, "resourceGroupName", newJString(resourceGroupName))
  add(query_568291, "api-version", newJString(apiVersion))
  add(path_568290, "subscriptionId", newJString(subscriptionId))
  add(path_568290, "virtualHubName", newJString(virtualHubName))
  if virtualHubParameters != nil:
    body_568292 = virtualHubParameters
  result = call_568289.call(path_568290, query_568291, nil, nil, body_568292)

var virtualHubsUpdateTags* = Call_VirtualHubsUpdateTags_568280(
    name: "virtualHubsUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}",
    validator: validate_VirtualHubsUpdateTags_568281, base: "",
    url: url_VirtualHubsUpdateTags_568282, schemes: {Scheme.Https})
type
  Call_VirtualHubsDelete_568269 = ref object of OpenApiRestCall_567657
proc url_VirtualHubsDelete_568271(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualHubsDelete_568270(path: JsonNode; query: JsonNode;
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
  var valid_568272 = path.getOrDefault("resourceGroupName")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "resourceGroupName", valid_568272
  var valid_568273 = path.getOrDefault("subscriptionId")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "subscriptionId", valid_568273
  var valid_568274 = path.getOrDefault("virtualHubName")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "virtualHubName", valid_568274
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568275 = query.getOrDefault("api-version")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "api-version", valid_568275
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568276: Call_VirtualHubsDelete_568269; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a VirtualHub.
  ## 
  let valid = call_568276.validator(path, query, header, formData, body)
  let scheme = call_568276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568276.url(scheme.get, call_568276.host, call_568276.base,
                         call_568276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568276, url, valid)

proc call*(call_568277: Call_VirtualHubsDelete_568269; resourceGroupName: string;
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
  var path_568278 = newJObject()
  var query_568279 = newJObject()
  add(path_568278, "resourceGroupName", newJString(resourceGroupName))
  add(query_568279, "api-version", newJString(apiVersion))
  add(path_568278, "subscriptionId", newJString(subscriptionId))
  add(path_568278, "virtualHubName", newJString(virtualHubName))
  result = call_568277.call(path_568278, query_568279, nil, nil, nil)

var virtualHubsDelete* = Call_VirtualHubsDelete_568269(name: "virtualHubsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}",
    validator: validate_VirtualHubsDelete_568270, base: "",
    url: url_VirtualHubsDelete_568271, schemes: {Scheme.Https})
type
  Call_HubVirtualNetworkConnectionsList_568293 = ref object of OpenApiRestCall_567657
proc url_HubVirtualNetworkConnectionsList_568295(protocol: Scheme; host: string;
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

proc validate_HubVirtualNetworkConnectionsList_568294(path: JsonNode;
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
  var valid_568296 = path.getOrDefault("resourceGroupName")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "resourceGroupName", valid_568296
  var valid_568297 = path.getOrDefault("subscriptionId")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "subscriptionId", valid_568297
  var valid_568298 = path.getOrDefault("virtualHubName")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "virtualHubName", valid_568298
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568299 = query.getOrDefault("api-version")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "api-version", valid_568299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568300: Call_HubVirtualNetworkConnectionsList_568293;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the details of all HubVirtualNetworkConnections.
  ## 
  let valid = call_568300.validator(path, query, header, formData, body)
  let scheme = call_568300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568300.url(scheme.get, call_568300.host, call_568300.base,
                         call_568300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568300, url, valid)

proc call*(call_568301: Call_HubVirtualNetworkConnectionsList_568293;
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
  var path_568302 = newJObject()
  var query_568303 = newJObject()
  add(path_568302, "resourceGroupName", newJString(resourceGroupName))
  add(query_568303, "api-version", newJString(apiVersion))
  add(path_568302, "subscriptionId", newJString(subscriptionId))
  add(path_568302, "virtualHubName", newJString(virtualHubName))
  result = call_568301.call(path_568302, query_568303, nil, nil, nil)

var hubVirtualNetworkConnectionsList* = Call_HubVirtualNetworkConnectionsList_568293(
    name: "hubVirtualNetworkConnectionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}/hubVirtualNetworkConnections",
    validator: validate_HubVirtualNetworkConnectionsList_568294, base: "",
    url: url_HubVirtualNetworkConnectionsList_568295, schemes: {Scheme.Https})
type
  Call_HubVirtualNetworkConnectionsGet_568304 = ref object of OpenApiRestCall_567657
proc url_HubVirtualNetworkConnectionsGet_568306(protocol: Scheme; host: string;
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

proc validate_HubVirtualNetworkConnectionsGet_568305(path: JsonNode;
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
  var valid_568307 = path.getOrDefault("resourceGroupName")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "resourceGroupName", valid_568307
  var valid_568308 = path.getOrDefault("subscriptionId")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "subscriptionId", valid_568308
  var valid_568309 = path.getOrDefault("virtualHubName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "virtualHubName", valid_568309
  var valid_568310 = path.getOrDefault("connectionName")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "connectionName", valid_568310
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568311 = query.getOrDefault("api-version")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "api-version", valid_568311
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568312: Call_HubVirtualNetworkConnectionsGet_568304;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the details of a HubVirtualNetworkConnection.
  ## 
  let valid = call_568312.validator(path, query, header, formData, body)
  let scheme = call_568312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568312.url(scheme.get, call_568312.host, call_568312.base,
                         call_568312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568312, url, valid)

proc call*(call_568313: Call_HubVirtualNetworkConnectionsGet_568304;
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
  var path_568314 = newJObject()
  var query_568315 = newJObject()
  add(path_568314, "resourceGroupName", newJString(resourceGroupName))
  add(query_568315, "api-version", newJString(apiVersion))
  add(path_568314, "subscriptionId", newJString(subscriptionId))
  add(path_568314, "virtualHubName", newJString(virtualHubName))
  add(path_568314, "connectionName", newJString(connectionName))
  result = call_568313.call(path_568314, query_568315, nil, nil, nil)

var hubVirtualNetworkConnectionsGet* = Call_HubVirtualNetworkConnectionsGet_568304(
    name: "hubVirtualNetworkConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}/hubVirtualNetworkConnections/{connectionName}",
    validator: validate_HubVirtualNetworkConnectionsGet_568305, base: "",
    url: url_HubVirtualNetworkConnectionsGet_568306, schemes: {Scheme.Https})
type
  Call_VirtualWANsListByResourceGroup_568316 = ref object of OpenApiRestCall_567657
proc url_VirtualWANsListByResourceGroup_568318(protocol: Scheme; host: string;
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

proc validate_VirtualWANsListByResourceGroup_568317(path: JsonNode;
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
  var valid_568319 = path.getOrDefault("resourceGroupName")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "resourceGroupName", valid_568319
  var valid_568320 = path.getOrDefault("subscriptionId")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "subscriptionId", valid_568320
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568321 = query.getOrDefault("api-version")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "api-version", valid_568321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568322: Call_VirtualWANsListByResourceGroup_568316; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VirtualWANs in a resource group.
  ## 
  let valid = call_568322.validator(path, query, header, formData, body)
  let scheme = call_568322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568322.url(scheme.get, call_568322.host, call_568322.base,
                         call_568322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568322, url, valid)

proc call*(call_568323: Call_VirtualWANsListByResourceGroup_568316;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualWANsListByResourceGroup
  ## Lists all the VirtualWANs in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualWan.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568324 = newJObject()
  var query_568325 = newJObject()
  add(path_568324, "resourceGroupName", newJString(resourceGroupName))
  add(query_568325, "api-version", newJString(apiVersion))
  add(path_568324, "subscriptionId", newJString(subscriptionId))
  result = call_568323.call(path_568324, query_568325, nil, nil, nil)

var virtualWANsListByResourceGroup* = Call_VirtualWANsListByResourceGroup_568316(
    name: "virtualWANsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans",
    validator: validate_VirtualWANsListByResourceGroup_568317, base: "",
    url: url_VirtualWANsListByResourceGroup_568318, schemes: {Scheme.Https})
type
  Call_VirtualWANsCreateOrUpdate_568337 = ref object of OpenApiRestCall_567657
proc url_VirtualWANsCreateOrUpdate_568339(protocol: Scheme; host: string;
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

proc validate_VirtualWANsCreateOrUpdate_568338(path: JsonNode; query: JsonNode;
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
  var valid_568340 = path.getOrDefault("resourceGroupName")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "resourceGroupName", valid_568340
  var valid_568341 = path.getOrDefault("VirtualWANName")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "VirtualWANName", valid_568341
  var valid_568342 = path.getOrDefault("subscriptionId")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "subscriptionId", valid_568342
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568343 = query.getOrDefault("api-version")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "api-version", valid_568343
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

proc call*(call_568345: Call_VirtualWANsCreateOrUpdate_568337; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a VirtualWAN resource if it doesn't exist else updates the existing VirtualWAN.
  ## 
  let valid = call_568345.validator(path, query, header, formData, body)
  let scheme = call_568345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568345.url(scheme.get, call_568345.host, call_568345.base,
                         call_568345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568345, url, valid)

proc call*(call_568346: Call_VirtualWANsCreateOrUpdate_568337;
          resourceGroupName: string; VirtualWANName: string; apiVersion: string;
          subscriptionId: string; WANParameters: JsonNode): Recallable =
  ## virtualWANsCreateOrUpdate
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
  var path_568347 = newJObject()
  var query_568348 = newJObject()
  var body_568349 = newJObject()
  add(path_568347, "resourceGroupName", newJString(resourceGroupName))
  add(path_568347, "VirtualWANName", newJString(VirtualWANName))
  add(query_568348, "api-version", newJString(apiVersion))
  add(path_568347, "subscriptionId", newJString(subscriptionId))
  if WANParameters != nil:
    body_568349 = WANParameters
  result = call_568346.call(path_568347, query_568348, nil, nil, body_568349)

var virtualWANsCreateOrUpdate* = Call_VirtualWANsCreateOrUpdate_568337(
    name: "virtualWANsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{VirtualWANName}",
    validator: validate_VirtualWANsCreateOrUpdate_568338, base: "",
    url: url_VirtualWANsCreateOrUpdate_568339, schemes: {Scheme.Https})
type
  Call_VirtualWANsGet_568326 = ref object of OpenApiRestCall_567657
proc url_VirtualWANsGet_568328(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualWANsGet_568327(path: JsonNode; query: JsonNode;
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
  var valid_568329 = path.getOrDefault("resourceGroupName")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "resourceGroupName", valid_568329
  var valid_568330 = path.getOrDefault("VirtualWANName")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "VirtualWANName", valid_568330
  var valid_568331 = path.getOrDefault("subscriptionId")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "subscriptionId", valid_568331
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568332 = query.getOrDefault("api-version")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "api-version", valid_568332
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568333: Call_VirtualWANsGet_568326; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a VirtualWAN.
  ## 
  let valid = call_568333.validator(path, query, header, formData, body)
  let scheme = call_568333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568333.url(scheme.get, call_568333.host, call_568333.base,
                         call_568333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568333, url, valid)

proc call*(call_568334: Call_VirtualWANsGet_568326; resourceGroupName: string;
          VirtualWANName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualWANsGet
  ## Retrieves the details of a VirtualWAN.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualWan.
  ##   VirtualWANName: string (required)
  ##                 : The name of the VirtualWAN being retrieved.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568335 = newJObject()
  var query_568336 = newJObject()
  add(path_568335, "resourceGroupName", newJString(resourceGroupName))
  add(path_568335, "VirtualWANName", newJString(VirtualWANName))
  add(query_568336, "api-version", newJString(apiVersion))
  add(path_568335, "subscriptionId", newJString(subscriptionId))
  result = call_568334.call(path_568335, query_568336, nil, nil, nil)

var virtualWANsGet* = Call_VirtualWANsGet_568326(name: "virtualWANsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{VirtualWANName}",
    validator: validate_VirtualWANsGet_568327, base: "", url: url_VirtualWANsGet_568328,
    schemes: {Scheme.Https})
type
  Call_VirtualWANsUpdateTags_568361 = ref object of OpenApiRestCall_567657
proc url_VirtualWANsUpdateTags_568363(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualWANsUpdateTags_568362(path: JsonNode; query: JsonNode;
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
  var valid_568364 = path.getOrDefault("resourceGroupName")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "resourceGroupName", valid_568364
  var valid_568365 = path.getOrDefault("VirtualWANName")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "VirtualWANName", valid_568365
  var valid_568366 = path.getOrDefault("subscriptionId")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "subscriptionId", valid_568366
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568367 = query.getOrDefault("api-version")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "api-version", valid_568367
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

proc call*(call_568369: Call_VirtualWANsUpdateTags_568361; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a VirtualWAN tags.
  ## 
  let valid = call_568369.validator(path, query, header, formData, body)
  let scheme = call_568369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568369.url(scheme.get, call_568369.host, call_568369.base,
                         call_568369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568369, url, valid)

proc call*(call_568370: Call_VirtualWANsUpdateTags_568361;
          resourceGroupName: string; VirtualWANName: string; apiVersion: string;
          subscriptionId: string; WANParameters: JsonNode): Recallable =
  ## virtualWANsUpdateTags
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
  var path_568371 = newJObject()
  var query_568372 = newJObject()
  var body_568373 = newJObject()
  add(path_568371, "resourceGroupName", newJString(resourceGroupName))
  add(path_568371, "VirtualWANName", newJString(VirtualWANName))
  add(query_568372, "api-version", newJString(apiVersion))
  add(path_568371, "subscriptionId", newJString(subscriptionId))
  if WANParameters != nil:
    body_568373 = WANParameters
  result = call_568370.call(path_568371, query_568372, nil, nil, body_568373)

var virtualWANsUpdateTags* = Call_VirtualWANsUpdateTags_568361(
    name: "virtualWANsUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{VirtualWANName}",
    validator: validate_VirtualWANsUpdateTags_568362, base: "",
    url: url_VirtualWANsUpdateTags_568363, schemes: {Scheme.Https})
type
  Call_VirtualWANsDelete_568350 = ref object of OpenApiRestCall_567657
proc url_VirtualWANsDelete_568352(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualWANsDelete_568351(path: JsonNode; query: JsonNode;
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
  var valid_568353 = path.getOrDefault("resourceGroupName")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "resourceGroupName", valid_568353
  var valid_568354 = path.getOrDefault("VirtualWANName")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "VirtualWANName", valid_568354
  var valid_568355 = path.getOrDefault("subscriptionId")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "subscriptionId", valid_568355
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568356 = query.getOrDefault("api-version")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "api-version", valid_568356
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568357: Call_VirtualWANsDelete_568350; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a VirtualWAN.
  ## 
  let valid = call_568357.validator(path, query, header, formData, body)
  let scheme = call_568357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568357.url(scheme.get, call_568357.host, call_568357.base,
                         call_568357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568357, url, valid)

proc call*(call_568358: Call_VirtualWANsDelete_568350; resourceGroupName: string;
          VirtualWANName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualWANsDelete
  ## Deletes a VirtualWAN.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualWan.
  ##   VirtualWANName: string (required)
  ##                 : The name of the VirtualWAN being deleted.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568359 = newJObject()
  var query_568360 = newJObject()
  add(path_568359, "resourceGroupName", newJString(resourceGroupName))
  add(path_568359, "VirtualWANName", newJString(VirtualWANName))
  add(query_568360, "api-version", newJString(apiVersion))
  add(path_568359, "subscriptionId", newJString(subscriptionId))
  result = call_568358.call(path_568359, query_568360, nil, nil, nil)

var virtualWANsDelete* = Call_VirtualWANsDelete_568350(name: "virtualWANsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{VirtualWANName}",
    validator: validate_VirtualWANsDelete_568351, base: "",
    url: url_VirtualWANsDelete_568352, schemes: {Scheme.Https})
type
  Call_VpnSitesConfigurationDownload_568374 = ref object of OpenApiRestCall_567657
proc url_VpnSitesConfigurationDownload_568376(protocol: Scheme; host: string;
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

proc validate_VpnSitesConfigurationDownload_568375(path: JsonNode; query: JsonNode;
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
  var valid_568377 = path.getOrDefault("resourceGroupName")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "resourceGroupName", valid_568377
  var valid_568378 = path.getOrDefault("subscriptionId")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "subscriptionId", valid_568378
  var valid_568379 = path.getOrDefault("virtualWANName")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "virtualWANName", valid_568379
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568380 = query.getOrDefault("api-version")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "api-version", valid_568380
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

proc call*(call_568382: Call_VpnSitesConfigurationDownload_568374; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gives the sas-url to download the configurations for vpn-sites in a resource group.
  ## 
  let valid = call_568382.validator(path, query, header, formData, body)
  let scheme = call_568382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568382.url(scheme.get, call_568382.host, call_568382.base,
                         call_568382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568382, url, valid)

proc call*(call_568383: Call_VpnSitesConfigurationDownload_568374;
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
  var path_568384 = newJObject()
  var query_568385 = newJObject()
  var body_568386 = newJObject()
  add(path_568384, "resourceGroupName", newJString(resourceGroupName))
  add(query_568385, "api-version", newJString(apiVersion))
  add(path_568384, "subscriptionId", newJString(subscriptionId))
  if request != nil:
    body_568386 = request
  add(path_568384, "virtualWANName", newJString(virtualWANName))
  result = call_568383.call(path_568384, query_568385, nil, nil, body_568386)

var vpnSitesConfigurationDownload* = Call_VpnSitesConfigurationDownload_568374(
    name: "vpnSitesConfigurationDownload", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{virtualWANName}/vpnConfiguration",
    validator: validate_VpnSitesConfigurationDownload_568375, base: "",
    url: url_VpnSitesConfigurationDownload_568376, schemes: {Scheme.Https})
type
  Call_VpnGatewaysListByResourceGroup_568387 = ref object of OpenApiRestCall_567657
proc url_VpnGatewaysListByResourceGroup_568389(protocol: Scheme; host: string;
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

proc validate_VpnGatewaysListByResourceGroup_568388(path: JsonNode;
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
  var valid_568390 = path.getOrDefault("resourceGroupName")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "resourceGroupName", valid_568390
  var valid_568391 = path.getOrDefault("subscriptionId")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "subscriptionId", valid_568391
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568392 = query.getOrDefault("api-version")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "api-version", valid_568392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568393: Call_VpnGatewaysListByResourceGroup_568387; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VpnGateways in a resource group.
  ## 
  let valid = call_568393.validator(path, query, header, formData, body)
  let scheme = call_568393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568393.url(scheme.get, call_568393.host, call_568393.base,
                         call_568393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568393, url, valid)

proc call*(call_568394: Call_VpnGatewaysListByResourceGroup_568387;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## vpnGatewaysListByResourceGroup
  ## Lists all the VpnGateways in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnGateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568395 = newJObject()
  var query_568396 = newJObject()
  add(path_568395, "resourceGroupName", newJString(resourceGroupName))
  add(query_568396, "api-version", newJString(apiVersion))
  add(path_568395, "subscriptionId", newJString(subscriptionId))
  result = call_568394.call(path_568395, query_568396, nil, nil, nil)

var vpnGatewaysListByResourceGroup* = Call_VpnGatewaysListByResourceGroup_568387(
    name: "vpnGatewaysListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways",
    validator: validate_VpnGatewaysListByResourceGroup_568388, base: "",
    url: url_VpnGatewaysListByResourceGroup_568389, schemes: {Scheme.Https})
type
  Call_VpnGatewaysCreateOrUpdate_568408 = ref object of OpenApiRestCall_567657
proc url_VpnGatewaysCreateOrUpdate_568410(protocol: Scheme; host: string;
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

proc validate_VpnGatewaysCreateOrUpdate_568409(path: JsonNode; query: JsonNode;
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
  var valid_568411 = path.getOrDefault("resourceGroupName")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "resourceGroupName", valid_568411
  var valid_568412 = path.getOrDefault("gatewayName")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "gatewayName", valid_568412
  var valid_568413 = path.getOrDefault("subscriptionId")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "subscriptionId", valid_568413
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568414 = query.getOrDefault("api-version")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "api-version", valid_568414
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

proc call*(call_568416: Call_VpnGatewaysCreateOrUpdate_568408; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a virtual wan vpn gateway if it doesn't exist else updates the existing gateway.
  ## 
  let valid = call_568416.validator(path, query, header, formData, body)
  let scheme = call_568416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568416.url(scheme.get, call_568416.host, call_568416.base,
                         call_568416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568416, url, valid)

proc call*(call_568417: Call_VpnGatewaysCreateOrUpdate_568408;
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
  var path_568418 = newJObject()
  var query_568419 = newJObject()
  var body_568420 = newJObject()
  add(path_568418, "resourceGroupName", newJString(resourceGroupName))
  add(query_568419, "api-version", newJString(apiVersion))
  add(path_568418, "gatewayName", newJString(gatewayName))
  add(path_568418, "subscriptionId", newJString(subscriptionId))
  if vpnGatewayParameters != nil:
    body_568420 = vpnGatewayParameters
  result = call_568417.call(path_568418, query_568419, nil, nil, body_568420)

var vpnGatewaysCreateOrUpdate* = Call_VpnGatewaysCreateOrUpdate_568408(
    name: "vpnGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}",
    validator: validate_VpnGatewaysCreateOrUpdate_568409, base: "",
    url: url_VpnGatewaysCreateOrUpdate_568410, schemes: {Scheme.Https})
type
  Call_VpnGatewaysGet_568397 = ref object of OpenApiRestCall_567657
proc url_VpnGatewaysGet_568399(protocol: Scheme; host: string; base: string;
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

proc validate_VpnGatewaysGet_568398(path: JsonNode; query: JsonNode;
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
  var valid_568400 = path.getOrDefault("resourceGroupName")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "resourceGroupName", valid_568400
  var valid_568401 = path.getOrDefault("gatewayName")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "gatewayName", valid_568401
  var valid_568402 = path.getOrDefault("subscriptionId")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "subscriptionId", valid_568402
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568403 = query.getOrDefault("api-version")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = nil)
  if valid_568403 != nil:
    section.add "api-version", valid_568403
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568404: Call_VpnGatewaysGet_568397; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a virtual wan vpn gateway.
  ## 
  let valid = call_568404.validator(path, query, header, formData, body)
  let scheme = call_568404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568404.url(scheme.get, call_568404.host, call_568404.base,
                         call_568404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568404, url, valid)

proc call*(call_568405: Call_VpnGatewaysGet_568397; resourceGroupName: string;
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
  var path_568406 = newJObject()
  var query_568407 = newJObject()
  add(path_568406, "resourceGroupName", newJString(resourceGroupName))
  add(query_568407, "api-version", newJString(apiVersion))
  add(path_568406, "gatewayName", newJString(gatewayName))
  add(path_568406, "subscriptionId", newJString(subscriptionId))
  result = call_568405.call(path_568406, query_568407, nil, nil, nil)

var vpnGatewaysGet* = Call_VpnGatewaysGet_568397(name: "vpnGatewaysGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}",
    validator: validate_VpnGatewaysGet_568398, base: "", url: url_VpnGatewaysGet_568399,
    schemes: {Scheme.Https})
type
  Call_VpnGatewaysUpdateTags_568432 = ref object of OpenApiRestCall_567657
proc url_VpnGatewaysUpdateTags_568434(protocol: Scheme; host: string; base: string;
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

proc validate_VpnGatewaysUpdateTags_568433(path: JsonNode; query: JsonNode;
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
  var valid_568435 = path.getOrDefault("resourceGroupName")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "resourceGroupName", valid_568435
  var valid_568436 = path.getOrDefault("gatewayName")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "gatewayName", valid_568436
  var valid_568437 = path.getOrDefault("subscriptionId")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "subscriptionId", valid_568437
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568438 = query.getOrDefault("api-version")
  valid_568438 = validateParameter(valid_568438, JString, required = true,
                                 default = nil)
  if valid_568438 != nil:
    section.add "api-version", valid_568438
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

proc call*(call_568440: Call_VpnGatewaysUpdateTags_568432; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates virtual wan vpn gateway tags.
  ## 
  let valid = call_568440.validator(path, query, header, formData, body)
  let scheme = call_568440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568440.url(scheme.get, call_568440.host, call_568440.base,
                         call_568440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568440, url, valid)

proc call*(call_568441: Call_VpnGatewaysUpdateTags_568432;
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
  var path_568442 = newJObject()
  var query_568443 = newJObject()
  var body_568444 = newJObject()
  add(path_568442, "resourceGroupName", newJString(resourceGroupName))
  add(query_568443, "api-version", newJString(apiVersion))
  add(path_568442, "gatewayName", newJString(gatewayName))
  add(path_568442, "subscriptionId", newJString(subscriptionId))
  if vpnGatewayParameters != nil:
    body_568444 = vpnGatewayParameters
  result = call_568441.call(path_568442, query_568443, nil, nil, body_568444)

var vpnGatewaysUpdateTags* = Call_VpnGatewaysUpdateTags_568432(
    name: "vpnGatewaysUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}",
    validator: validate_VpnGatewaysUpdateTags_568433, base: "",
    url: url_VpnGatewaysUpdateTags_568434, schemes: {Scheme.Https})
type
  Call_VpnGatewaysDelete_568421 = ref object of OpenApiRestCall_567657
proc url_VpnGatewaysDelete_568423(protocol: Scheme; host: string; base: string;
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

proc validate_VpnGatewaysDelete_568422(path: JsonNode; query: JsonNode;
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
  var valid_568424 = path.getOrDefault("resourceGroupName")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "resourceGroupName", valid_568424
  var valid_568425 = path.getOrDefault("gatewayName")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "gatewayName", valid_568425
  var valid_568426 = path.getOrDefault("subscriptionId")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "subscriptionId", valid_568426
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568427 = query.getOrDefault("api-version")
  valid_568427 = validateParameter(valid_568427, JString, required = true,
                                 default = nil)
  if valid_568427 != nil:
    section.add "api-version", valid_568427
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568428: Call_VpnGatewaysDelete_568421; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a virtual wan vpn gateway.
  ## 
  let valid = call_568428.validator(path, query, header, formData, body)
  let scheme = call_568428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568428.url(scheme.get, call_568428.host, call_568428.base,
                         call_568428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568428, url, valid)

proc call*(call_568429: Call_VpnGatewaysDelete_568421; resourceGroupName: string;
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
  var path_568430 = newJObject()
  var query_568431 = newJObject()
  add(path_568430, "resourceGroupName", newJString(resourceGroupName))
  add(query_568431, "api-version", newJString(apiVersion))
  add(path_568430, "gatewayName", newJString(gatewayName))
  add(path_568430, "subscriptionId", newJString(subscriptionId))
  result = call_568429.call(path_568430, query_568431, nil, nil, nil)

var vpnGatewaysDelete* = Call_VpnGatewaysDelete_568421(name: "vpnGatewaysDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}",
    validator: validate_VpnGatewaysDelete_568422, base: "",
    url: url_VpnGatewaysDelete_568423, schemes: {Scheme.Https})
type
  Call_VpnConnectionsListByVpnGateway_568445 = ref object of OpenApiRestCall_567657
proc url_VpnConnectionsListByVpnGateway_568447(protocol: Scheme; host: string;
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

proc validate_VpnConnectionsListByVpnGateway_568446(path: JsonNode;
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
  var valid_568448 = path.getOrDefault("resourceGroupName")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "resourceGroupName", valid_568448
  var valid_568449 = path.getOrDefault("gatewayName")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "gatewayName", valid_568449
  var valid_568450 = path.getOrDefault("subscriptionId")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "subscriptionId", valid_568450
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568451 = query.getOrDefault("api-version")
  valid_568451 = validateParameter(valid_568451, JString, required = true,
                                 default = nil)
  if valid_568451 != nil:
    section.add "api-version", valid_568451
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568452: Call_VpnConnectionsListByVpnGateway_568445; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all vpn connections for a particular virtual wan vpn gateway.
  ## 
  let valid = call_568452.validator(path, query, header, formData, body)
  let scheme = call_568452.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568452.url(scheme.get, call_568452.host, call_568452.base,
                         call_568452.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568452, url, valid)

proc call*(call_568453: Call_VpnConnectionsListByVpnGateway_568445;
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
  var path_568454 = newJObject()
  var query_568455 = newJObject()
  add(path_568454, "resourceGroupName", newJString(resourceGroupName))
  add(query_568455, "api-version", newJString(apiVersion))
  add(path_568454, "gatewayName", newJString(gatewayName))
  add(path_568454, "subscriptionId", newJString(subscriptionId))
  result = call_568453.call(path_568454, query_568455, nil, nil, nil)

var vpnConnectionsListByVpnGateway* = Call_VpnConnectionsListByVpnGateway_568445(
    name: "vpnConnectionsListByVpnGateway", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections",
    validator: validate_VpnConnectionsListByVpnGateway_568446, base: "",
    url: url_VpnConnectionsListByVpnGateway_568447, schemes: {Scheme.Https})
type
  Call_VpnConnectionsCreateOrUpdate_568468 = ref object of OpenApiRestCall_567657
proc url_VpnConnectionsCreateOrUpdate_568470(protocol: Scheme; host: string;
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

proc validate_VpnConnectionsCreateOrUpdate_568469(path: JsonNode; query: JsonNode;
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
  var valid_568471 = path.getOrDefault("resourceGroupName")
  valid_568471 = validateParameter(valid_568471, JString, required = true,
                                 default = nil)
  if valid_568471 != nil:
    section.add "resourceGroupName", valid_568471
  var valid_568472 = path.getOrDefault("gatewayName")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "gatewayName", valid_568472
  var valid_568473 = path.getOrDefault("subscriptionId")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "subscriptionId", valid_568473
  var valid_568474 = path.getOrDefault("connectionName")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = nil)
  if valid_568474 != nil:
    section.add "connectionName", valid_568474
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568475 = query.getOrDefault("api-version")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "api-version", valid_568475
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

proc call*(call_568477: Call_VpnConnectionsCreateOrUpdate_568468; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a vpn connection to a scalable vpn gateway if it doesn't exist else updates the existing connection.
  ## 
  let valid = call_568477.validator(path, query, header, formData, body)
  let scheme = call_568477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568477.url(scheme.get, call_568477.host, call_568477.base,
                         call_568477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568477, url, valid)

proc call*(call_568478: Call_VpnConnectionsCreateOrUpdate_568468;
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
  var path_568479 = newJObject()
  var query_568480 = newJObject()
  var body_568481 = newJObject()
  add(path_568479, "resourceGroupName", newJString(resourceGroupName))
  add(query_568480, "api-version", newJString(apiVersion))
  add(path_568479, "gatewayName", newJString(gatewayName))
  add(path_568479, "subscriptionId", newJString(subscriptionId))
  if VpnConnectionParameters != nil:
    body_568481 = VpnConnectionParameters
  add(path_568479, "connectionName", newJString(connectionName))
  result = call_568478.call(path_568479, query_568480, nil, nil, body_568481)

var vpnConnectionsCreateOrUpdate* = Call_VpnConnectionsCreateOrUpdate_568468(
    name: "vpnConnectionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections/{connectionName}",
    validator: validate_VpnConnectionsCreateOrUpdate_568469, base: "",
    url: url_VpnConnectionsCreateOrUpdate_568470, schemes: {Scheme.Https})
type
  Call_VpnConnectionsGet_568456 = ref object of OpenApiRestCall_567657
proc url_VpnConnectionsGet_568458(protocol: Scheme; host: string; base: string;
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

proc validate_VpnConnectionsGet_568457(path: JsonNode; query: JsonNode;
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
  var valid_568459 = path.getOrDefault("resourceGroupName")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "resourceGroupName", valid_568459
  var valid_568460 = path.getOrDefault("gatewayName")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "gatewayName", valid_568460
  var valid_568461 = path.getOrDefault("subscriptionId")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "subscriptionId", valid_568461
  var valid_568462 = path.getOrDefault("connectionName")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "connectionName", valid_568462
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568463 = query.getOrDefault("api-version")
  valid_568463 = validateParameter(valid_568463, JString, required = true,
                                 default = nil)
  if valid_568463 != nil:
    section.add "api-version", valid_568463
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568464: Call_VpnConnectionsGet_568456; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a vpn connection.
  ## 
  let valid = call_568464.validator(path, query, header, formData, body)
  let scheme = call_568464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568464.url(scheme.get, call_568464.host, call_568464.base,
                         call_568464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568464, url, valid)

proc call*(call_568465: Call_VpnConnectionsGet_568456; resourceGroupName: string;
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
  var path_568466 = newJObject()
  var query_568467 = newJObject()
  add(path_568466, "resourceGroupName", newJString(resourceGroupName))
  add(query_568467, "api-version", newJString(apiVersion))
  add(path_568466, "gatewayName", newJString(gatewayName))
  add(path_568466, "subscriptionId", newJString(subscriptionId))
  add(path_568466, "connectionName", newJString(connectionName))
  result = call_568465.call(path_568466, query_568467, nil, nil, nil)

var vpnConnectionsGet* = Call_VpnConnectionsGet_568456(name: "vpnConnectionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections/{connectionName}",
    validator: validate_VpnConnectionsGet_568457, base: "",
    url: url_VpnConnectionsGet_568458, schemes: {Scheme.Https})
type
  Call_VpnConnectionsDelete_568482 = ref object of OpenApiRestCall_567657
proc url_VpnConnectionsDelete_568484(protocol: Scheme; host: string; base: string;
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

proc validate_VpnConnectionsDelete_568483(path: JsonNode; query: JsonNode;
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
  var valid_568485 = path.getOrDefault("resourceGroupName")
  valid_568485 = validateParameter(valid_568485, JString, required = true,
                                 default = nil)
  if valid_568485 != nil:
    section.add "resourceGroupName", valid_568485
  var valid_568486 = path.getOrDefault("gatewayName")
  valid_568486 = validateParameter(valid_568486, JString, required = true,
                                 default = nil)
  if valid_568486 != nil:
    section.add "gatewayName", valid_568486
  var valid_568487 = path.getOrDefault("subscriptionId")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "subscriptionId", valid_568487
  var valid_568488 = path.getOrDefault("connectionName")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "connectionName", valid_568488
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568489 = query.getOrDefault("api-version")
  valid_568489 = validateParameter(valid_568489, JString, required = true,
                                 default = nil)
  if valid_568489 != nil:
    section.add "api-version", valid_568489
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568490: Call_VpnConnectionsDelete_568482; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a vpn connection.
  ## 
  let valid = call_568490.validator(path, query, header, formData, body)
  let scheme = call_568490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568490.url(scheme.get, call_568490.host, call_568490.base,
                         call_568490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568490, url, valid)

proc call*(call_568491: Call_VpnConnectionsDelete_568482;
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
  var path_568492 = newJObject()
  var query_568493 = newJObject()
  add(path_568492, "resourceGroupName", newJString(resourceGroupName))
  add(query_568493, "api-version", newJString(apiVersion))
  add(path_568492, "gatewayName", newJString(gatewayName))
  add(path_568492, "subscriptionId", newJString(subscriptionId))
  add(path_568492, "connectionName", newJString(connectionName))
  result = call_568491.call(path_568492, query_568493, nil, nil, nil)

var vpnConnectionsDelete* = Call_VpnConnectionsDelete_568482(
    name: "vpnConnectionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections/{connectionName}",
    validator: validate_VpnConnectionsDelete_568483, base: "",
    url: url_VpnConnectionsDelete_568484, schemes: {Scheme.Https})
type
  Call_VpnSitesListByResourceGroup_568494 = ref object of OpenApiRestCall_567657
proc url_VpnSitesListByResourceGroup_568496(protocol: Scheme; host: string;
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

proc validate_VpnSitesListByResourceGroup_568495(path: JsonNode; query: JsonNode;
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
  var valid_568497 = path.getOrDefault("resourceGroupName")
  valid_568497 = validateParameter(valid_568497, JString, required = true,
                                 default = nil)
  if valid_568497 != nil:
    section.add "resourceGroupName", valid_568497
  var valid_568498 = path.getOrDefault("subscriptionId")
  valid_568498 = validateParameter(valid_568498, JString, required = true,
                                 default = nil)
  if valid_568498 != nil:
    section.add "subscriptionId", valid_568498
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568499 = query.getOrDefault("api-version")
  valid_568499 = validateParameter(valid_568499, JString, required = true,
                                 default = nil)
  if valid_568499 != nil:
    section.add "api-version", valid_568499
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568500: Call_VpnSitesListByResourceGroup_568494; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the vpnSites in a resource group.
  ## 
  let valid = call_568500.validator(path, query, header, formData, body)
  let scheme = call_568500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568500.url(scheme.get, call_568500.host, call_568500.base,
                         call_568500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568500, url, valid)

proc call*(call_568501: Call_VpnSitesListByResourceGroup_568494;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## vpnSitesListByResourceGroup
  ## Lists all the vpnSites in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnSite.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568502 = newJObject()
  var query_568503 = newJObject()
  add(path_568502, "resourceGroupName", newJString(resourceGroupName))
  add(query_568503, "api-version", newJString(apiVersion))
  add(path_568502, "subscriptionId", newJString(subscriptionId))
  result = call_568501.call(path_568502, query_568503, nil, nil, nil)

var vpnSitesListByResourceGroup* = Call_VpnSitesListByResourceGroup_568494(
    name: "vpnSitesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites",
    validator: validate_VpnSitesListByResourceGroup_568495, base: "",
    url: url_VpnSitesListByResourceGroup_568496, schemes: {Scheme.Https})
type
  Call_VpnSitesCreateOrUpdate_568515 = ref object of OpenApiRestCall_567657
proc url_VpnSitesCreateOrUpdate_568517(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSitesCreateOrUpdate_568516(path: JsonNode; query: JsonNode;
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
  var valid_568518 = path.getOrDefault("resourceGroupName")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "resourceGroupName", valid_568518
  var valid_568519 = path.getOrDefault("vpnSiteName")
  valid_568519 = validateParameter(valid_568519, JString, required = true,
                                 default = nil)
  if valid_568519 != nil:
    section.add "vpnSiteName", valid_568519
  var valid_568520 = path.getOrDefault("subscriptionId")
  valid_568520 = validateParameter(valid_568520, JString, required = true,
                                 default = nil)
  if valid_568520 != nil:
    section.add "subscriptionId", valid_568520
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568521 = query.getOrDefault("api-version")
  valid_568521 = validateParameter(valid_568521, JString, required = true,
                                 default = nil)
  if valid_568521 != nil:
    section.add "api-version", valid_568521
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

proc call*(call_568523: Call_VpnSitesCreateOrUpdate_568515; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a VpnSite resource if it doesn't exist else updates the existing VpnSite.
  ## 
  let valid = call_568523.validator(path, query, header, formData, body)
  let scheme = call_568523.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568523.url(scheme.get, call_568523.host, call_568523.base,
                         call_568523.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568523, url, valid)

proc call*(call_568524: Call_VpnSitesCreateOrUpdate_568515;
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
  var path_568525 = newJObject()
  var query_568526 = newJObject()
  var body_568527 = newJObject()
  add(path_568525, "resourceGroupName", newJString(resourceGroupName))
  add(query_568526, "api-version", newJString(apiVersion))
  add(path_568525, "vpnSiteName", newJString(vpnSiteName))
  add(path_568525, "subscriptionId", newJString(subscriptionId))
  if VpnSiteParameters != nil:
    body_568527 = VpnSiteParameters
  result = call_568524.call(path_568525, query_568526, nil, nil, body_568527)

var vpnSitesCreateOrUpdate* = Call_VpnSitesCreateOrUpdate_568515(
    name: "vpnSitesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}",
    validator: validate_VpnSitesCreateOrUpdate_568516, base: "",
    url: url_VpnSitesCreateOrUpdate_568517, schemes: {Scheme.Https})
type
  Call_VpnSitesGet_568504 = ref object of OpenApiRestCall_567657
proc url_VpnSitesGet_568506(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSitesGet_568505(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568507 = path.getOrDefault("resourceGroupName")
  valid_568507 = validateParameter(valid_568507, JString, required = true,
                                 default = nil)
  if valid_568507 != nil:
    section.add "resourceGroupName", valid_568507
  var valid_568508 = path.getOrDefault("vpnSiteName")
  valid_568508 = validateParameter(valid_568508, JString, required = true,
                                 default = nil)
  if valid_568508 != nil:
    section.add "vpnSiteName", valid_568508
  var valid_568509 = path.getOrDefault("subscriptionId")
  valid_568509 = validateParameter(valid_568509, JString, required = true,
                                 default = nil)
  if valid_568509 != nil:
    section.add "subscriptionId", valid_568509
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568510 = query.getOrDefault("api-version")
  valid_568510 = validateParameter(valid_568510, JString, required = true,
                                 default = nil)
  if valid_568510 != nil:
    section.add "api-version", valid_568510
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568511: Call_VpnSitesGet_568504; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a VPN site.
  ## 
  let valid = call_568511.validator(path, query, header, formData, body)
  let scheme = call_568511.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568511.url(scheme.get, call_568511.host, call_568511.base,
                         call_568511.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568511, url, valid)

proc call*(call_568512: Call_VpnSitesGet_568504; resourceGroupName: string;
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
  var path_568513 = newJObject()
  var query_568514 = newJObject()
  add(path_568513, "resourceGroupName", newJString(resourceGroupName))
  add(query_568514, "api-version", newJString(apiVersion))
  add(path_568513, "vpnSiteName", newJString(vpnSiteName))
  add(path_568513, "subscriptionId", newJString(subscriptionId))
  result = call_568512.call(path_568513, query_568514, nil, nil, nil)

var vpnSitesGet* = Call_VpnSitesGet_568504(name: "vpnSitesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}",
                                        validator: validate_VpnSitesGet_568505,
                                        base: "", url: url_VpnSitesGet_568506,
                                        schemes: {Scheme.Https})
type
  Call_VpnSitesUpdateTags_568539 = ref object of OpenApiRestCall_567657
proc url_VpnSitesUpdateTags_568541(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSitesUpdateTags_568540(path: JsonNode; query: JsonNode;
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
  var valid_568542 = path.getOrDefault("resourceGroupName")
  valid_568542 = validateParameter(valid_568542, JString, required = true,
                                 default = nil)
  if valid_568542 != nil:
    section.add "resourceGroupName", valid_568542
  var valid_568543 = path.getOrDefault("vpnSiteName")
  valid_568543 = validateParameter(valid_568543, JString, required = true,
                                 default = nil)
  if valid_568543 != nil:
    section.add "vpnSiteName", valid_568543
  var valid_568544 = path.getOrDefault("subscriptionId")
  valid_568544 = validateParameter(valid_568544, JString, required = true,
                                 default = nil)
  if valid_568544 != nil:
    section.add "subscriptionId", valid_568544
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568545 = query.getOrDefault("api-version")
  valid_568545 = validateParameter(valid_568545, JString, required = true,
                                 default = nil)
  if valid_568545 != nil:
    section.add "api-version", valid_568545
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

proc call*(call_568547: Call_VpnSitesUpdateTags_568539; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates VpnSite tags.
  ## 
  let valid = call_568547.validator(path, query, header, formData, body)
  let scheme = call_568547.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568547.url(scheme.get, call_568547.host, call_568547.base,
                         call_568547.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568547, url, valid)

proc call*(call_568548: Call_VpnSitesUpdateTags_568539; resourceGroupName: string;
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
  var path_568549 = newJObject()
  var query_568550 = newJObject()
  var body_568551 = newJObject()
  add(path_568549, "resourceGroupName", newJString(resourceGroupName))
  add(query_568550, "api-version", newJString(apiVersion))
  add(path_568549, "vpnSiteName", newJString(vpnSiteName))
  add(path_568549, "subscriptionId", newJString(subscriptionId))
  if VpnSiteParameters != nil:
    body_568551 = VpnSiteParameters
  result = call_568548.call(path_568549, query_568550, nil, nil, body_568551)

var vpnSitesUpdateTags* = Call_VpnSitesUpdateTags_568539(
    name: "vpnSitesUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}",
    validator: validate_VpnSitesUpdateTags_568540, base: "",
    url: url_VpnSitesUpdateTags_568541, schemes: {Scheme.Https})
type
  Call_VpnSitesDelete_568528 = ref object of OpenApiRestCall_567657
proc url_VpnSitesDelete_568530(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSitesDelete_568529(path: JsonNode; query: JsonNode;
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
  var valid_568531 = path.getOrDefault("resourceGroupName")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "resourceGroupName", valid_568531
  var valid_568532 = path.getOrDefault("vpnSiteName")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "vpnSiteName", valid_568532
  var valid_568533 = path.getOrDefault("subscriptionId")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "subscriptionId", valid_568533
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568534 = query.getOrDefault("api-version")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "api-version", valid_568534
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568535: Call_VpnSitesDelete_568528; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a VpnSite.
  ## 
  let valid = call_568535.validator(path, query, header, formData, body)
  let scheme = call_568535.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568535.url(scheme.get, call_568535.host, call_568535.base,
                         call_568535.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568535, url, valid)

proc call*(call_568536: Call_VpnSitesDelete_568528; resourceGroupName: string;
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
  var path_568537 = newJObject()
  var query_568538 = newJObject()
  add(path_568537, "resourceGroupName", newJString(resourceGroupName))
  add(query_568538, "api-version", newJString(apiVersion))
  add(path_568537, "vpnSiteName", newJString(vpnSiteName))
  add(path_568537, "subscriptionId", newJString(subscriptionId))
  result = call_568536.call(path_568537, query_568538, nil, nil, nil)

var vpnSitesDelete* = Call_VpnSitesDelete_568528(name: "vpnSitesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}",
    validator: validate_VpnSitesDelete_568529, base: "", url: url_VpnSitesDelete_568530,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
