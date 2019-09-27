
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_VirtualHubsList_593646 = ref object of OpenApiRestCall_593424
proc url_VirtualHubsList_593648(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualHubsList_593647(path: JsonNode; query: JsonNode;
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
  var valid_593808 = path.getOrDefault("subscriptionId")
  valid_593808 = validateParameter(valid_593808, JString, required = true,
                                 default = nil)
  if valid_593808 != nil:
    section.add "subscriptionId", valid_593808
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593809 = query.getOrDefault("api-version")
  valid_593809 = validateParameter(valid_593809, JString, required = true,
                                 default = nil)
  if valid_593809 != nil:
    section.add "api-version", valid_593809
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593836: Call_VirtualHubsList_593646; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VirtualHubs in a subscription.
  ## 
  let valid = call_593836.validator(path, query, header, formData, body)
  let scheme = call_593836.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593836.url(scheme.get, call_593836.host, call_593836.base,
                         call_593836.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593836, url, valid)

proc call*(call_593907: Call_VirtualHubsList_593646; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualHubsList
  ## Lists all the VirtualHubs in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593908 = newJObject()
  var query_593910 = newJObject()
  add(query_593910, "api-version", newJString(apiVersion))
  add(path_593908, "subscriptionId", newJString(subscriptionId))
  result = call_593907.call(path_593908, query_593910, nil, nil, nil)

var virtualHubsList* = Call_VirtualHubsList_593646(name: "virtualHubsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/virtualHubs",
    validator: validate_VirtualHubsList_593647, base: "", url: url_VirtualHubsList_593648,
    schemes: {Scheme.Https})
type
  Call_VirtualWANsList_593949 = ref object of OpenApiRestCall_593424
proc url_VirtualWANsList_593951(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualWANsList_593950(path: JsonNode; query: JsonNode;
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
  var valid_593952 = path.getOrDefault("subscriptionId")
  valid_593952 = validateParameter(valid_593952, JString, required = true,
                                 default = nil)
  if valid_593952 != nil:
    section.add "subscriptionId", valid_593952
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593953 = query.getOrDefault("api-version")
  valid_593953 = validateParameter(valid_593953, JString, required = true,
                                 default = nil)
  if valid_593953 != nil:
    section.add "api-version", valid_593953
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593954: Call_VirtualWANsList_593949; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VirtualWANs in a subscription.
  ## 
  let valid = call_593954.validator(path, query, header, formData, body)
  let scheme = call_593954.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593954.url(scheme.get, call_593954.host, call_593954.base,
                         call_593954.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593954, url, valid)

proc call*(call_593955: Call_VirtualWANsList_593949; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualWANsList
  ## Lists all the VirtualWANs in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593956 = newJObject()
  var query_593957 = newJObject()
  add(query_593957, "api-version", newJString(apiVersion))
  add(path_593956, "subscriptionId", newJString(subscriptionId))
  result = call_593955.call(path_593956, query_593957, nil, nil, nil)

var virtualWANsList* = Call_VirtualWANsList_593949(name: "virtualWANsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/virtualWans",
    validator: validate_VirtualWANsList_593950, base: "", url: url_VirtualWANsList_593951,
    schemes: {Scheme.Https})
type
  Call_VpnGatewaysList_593958 = ref object of OpenApiRestCall_593424
proc url_VpnGatewaysList_593960(protocol: Scheme; host: string; base: string;
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

proc validate_VpnGatewaysList_593959(path: JsonNode; query: JsonNode;
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
  var valid_593961 = path.getOrDefault("subscriptionId")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "subscriptionId", valid_593961
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593962 = query.getOrDefault("api-version")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "api-version", valid_593962
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593963: Call_VpnGatewaysList_593958; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VpnGateways in a subscription.
  ## 
  let valid = call_593963.validator(path, query, header, formData, body)
  let scheme = call_593963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593963.url(scheme.get, call_593963.host, call_593963.base,
                         call_593963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593963, url, valid)

proc call*(call_593964: Call_VpnGatewaysList_593958; apiVersion: string;
          subscriptionId: string): Recallable =
  ## vpnGatewaysList
  ## Lists all the VpnGateways in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593965 = newJObject()
  var query_593966 = newJObject()
  add(query_593966, "api-version", newJString(apiVersion))
  add(path_593965, "subscriptionId", newJString(subscriptionId))
  result = call_593964.call(path_593965, query_593966, nil, nil, nil)

var vpnGatewaysList* = Call_VpnGatewaysList_593958(name: "vpnGatewaysList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/vpnGateways",
    validator: validate_VpnGatewaysList_593959, base: "", url: url_VpnGatewaysList_593960,
    schemes: {Scheme.Https})
type
  Call_VpnSitesList_593967 = ref object of OpenApiRestCall_593424
proc url_VpnSitesList_593969(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSitesList_593968(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593970 = path.getOrDefault("subscriptionId")
  valid_593970 = validateParameter(valid_593970, JString, required = true,
                                 default = nil)
  if valid_593970 != nil:
    section.add "subscriptionId", valid_593970
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593971 = query.getOrDefault("api-version")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = nil)
  if valid_593971 != nil:
    section.add "api-version", valid_593971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593972: Call_VpnSitesList_593967; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VpnSites in a subscription.
  ## 
  let valid = call_593972.validator(path, query, header, formData, body)
  let scheme = call_593972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593972.url(scheme.get, call_593972.host, call_593972.base,
                         call_593972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593972, url, valid)

proc call*(call_593973: Call_VpnSitesList_593967; apiVersion: string;
          subscriptionId: string): Recallable =
  ## vpnSitesList
  ## Lists all the VpnSites in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593974 = newJObject()
  var query_593975 = newJObject()
  add(query_593975, "api-version", newJString(apiVersion))
  add(path_593974, "subscriptionId", newJString(subscriptionId))
  result = call_593973.call(path_593974, query_593975, nil, nil, nil)

var vpnSitesList* = Call_VpnSitesList_593967(name: "vpnSitesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/vpnSites",
    validator: validate_VpnSitesList_593968, base: "", url: url_VpnSitesList_593969,
    schemes: {Scheme.Https})
type
  Call_VirtualHubsListByResourceGroup_593976 = ref object of OpenApiRestCall_593424
proc url_VirtualHubsListByResourceGroup_593978(protocol: Scheme; host: string;
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

proc validate_VirtualHubsListByResourceGroup_593977(path: JsonNode;
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
  var valid_593979 = path.getOrDefault("resourceGroupName")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "resourceGroupName", valid_593979
  var valid_593980 = path.getOrDefault("subscriptionId")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "subscriptionId", valid_593980
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593981 = query.getOrDefault("api-version")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "api-version", valid_593981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593982: Call_VirtualHubsListByResourceGroup_593976; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VirtualHubs in a resource group.
  ## 
  let valid = call_593982.validator(path, query, header, formData, body)
  let scheme = call_593982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593982.url(scheme.get, call_593982.host, call_593982.base,
                         call_593982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593982, url, valid)

proc call*(call_593983: Call_VirtualHubsListByResourceGroup_593976;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualHubsListByResourceGroup
  ## Lists all the VirtualHubs in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualHub.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593984 = newJObject()
  var query_593985 = newJObject()
  add(path_593984, "resourceGroupName", newJString(resourceGroupName))
  add(query_593985, "api-version", newJString(apiVersion))
  add(path_593984, "subscriptionId", newJString(subscriptionId))
  result = call_593983.call(path_593984, query_593985, nil, nil, nil)

var virtualHubsListByResourceGroup* = Call_VirtualHubsListByResourceGroup_593976(
    name: "virtualHubsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs",
    validator: validate_VirtualHubsListByResourceGroup_593977, base: "",
    url: url_VirtualHubsListByResourceGroup_593978, schemes: {Scheme.Https})
type
  Call_VirtualHubsCreateOrUpdate_593997 = ref object of OpenApiRestCall_593424
proc url_VirtualHubsCreateOrUpdate_593999(protocol: Scheme; host: string;
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

proc validate_VirtualHubsCreateOrUpdate_593998(path: JsonNode; query: JsonNode;
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
  var valid_594026 = path.getOrDefault("resourceGroupName")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "resourceGroupName", valid_594026
  var valid_594027 = path.getOrDefault("subscriptionId")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "subscriptionId", valid_594027
  var valid_594028 = path.getOrDefault("virtualHubName")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "virtualHubName", valid_594028
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594029 = query.getOrDefault("api-version")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "api-version", valid_594029
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

proc call*(call_594031: Call_VirtualHubsCreateOrUpdate_593997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a VirtualHub resource if it doesn't exist else updates the existing VirtualHub.
  ## 
  let valid = call_594031.validator(path, query, header, formData, body)
  let scheme = call_594031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594031.url(scheme.get, call_594031.host, call_594031.base,
                         call_594031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594031, url, valid)

proc call*(call_594032: Call_VirtualHubsCreateOrUpdate_593997;
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
  var path_594033 = newJObject()
  var query_594034 = newJObject()
  var body_594035 = newJObject()
  add(path_594033, "resourceGroupName", newJString(resourceGroupName))
  add(query_594034, "api-version", newJString(apiVersion))
  add(path_594033, "subscriptionId", newJString(subscriptionId))
  add(path_594033, "virtualHubName", newJString(virtualHubName))
  if virtualHubParameters != nil:
    body_594035 = virtualHubParameters
  result = call_594032.call(path_594033, query_594034, nil, nil, body_594035)

var virtualHubsCreateOrUpdate* = Call_VirtualHubsCreateOrUpdate_593997(
    name: "virtualHubsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}",
    validator: validate_VirtualHubsCreateOrUpdate_593998, base: "",
    url: url_VirtualHubsCreateOrUpdate_593999, schemes: {Scheme.Https})
type
  Call_VirtualHubsGet_593986 = ref object of OpenApiRestCall_593424
proc url_VirtualHubsGet_593988(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualHubsGet_593987(path: JsonNode; query: JsonNode;
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
  var valid_593989 = path.getOrDefault("resourceGroupName")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "resourceGroupName", valid_593989
  var valid_593990 = path.getOrDefault("subscriptionId")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "subscriptionId", valid_593990
  var valid_593991 = path.getOrDefault("virtualHubName")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "virtualHubName", valid_593991
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593992 = query.getOrDefault("api-version")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "api-version", valid_593992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593993: Call_VirtualHubsGet_593986; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a VirtualHub.
  ## 
  let valid = call_593993.validator(path, query, header, formData, body)
  let scheme = call_593993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593993.url(scheme.get, call_593993.host, call_593993.base,
                         call_593993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593993, url, valid)

proc call*(call_593994: Call_VirtualHubsGet_593986; resourceGroupName: string;
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
  var path_593995 = newJObject()
  var query_593996 = newJObject()
  add(path_593995, "resourceGroupName", newJString(resourceGroupName))
  add(query_593996, "api-version", newJString(apiVersion))
  add(path_593995, "subscriptionId", newJString(subscriptionId))
  add(path_593995, "virtualHubName", newJString(virtualHubName))
  result = call_593994.call(path_593995, query_593996, nil, nil, nil)

var virtualHubsGet* = Call_VirtualHubsGet_593986(name: "virtualHubsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}",
    validator: validate_VirtualHubsGet_593987, base: "", url: url_VirtualHubsGet_593988,
    schemes: {Scheme.Https})
type
  Call_VirtualHubsUpdateTags_594047 = ref object of OpenApiRestCall_593424
proc url_VirtualHubsUpdateTags_594049(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualHubsUpdateTags_594048(path: JsonNode; query: JsonNode;
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
  var valid_594050 = path.getOrDefault("resourceGroupName")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "resourceGroupName", valid_594050
  var valid_594051 = path.getOrDefault("subscriptionId")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "subscriptionId", valid_594051
  var valid_594052 = path.getOrDefault("virtualHubName")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "virtualHubName", valid_594052
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594053 = query.getOrDefault("api-version")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "api-version", valid_594053
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

proc call*(call_594055: Call_VirtualHubsUpdateTags_594047; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates VirtualHub tags.
  ## 
  let valid = call_594055.validator(path, query, header, formData, body)
  let scheme = call_594055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594055.url(scheme.get, call_594055.host, call_594055.base,
                         call_594055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594055, url, valid)

proc call*(call_594056: Call_VirtualHubsUpdateTags_594047;
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
  var path_594057 = newJObject()
  var query_594058 = newJObject()
  var body_594059 = newJObject()
  add(path_594057, "resourceGroupName", newJString(resourceGroupName))
  add(query_594058, "api-version", newJString(apiVersion))
  add(path_594057, "subscriptionId", newJString(subscriptionId))
  add(path_594057, "virtualHubName", newJString(virtualHubName))
  if virtualHubParameters != nil:
    body_594059 = virtualHubParameters
  result = call_594056.call(path_594057, query_594058, nil, nil, body_594059)

var virtualHubsUpdateTags* = Call_VirtualHubsUpdateTags_594047(
    name: "virtualHubsUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}",
    validator: validate_VirtualHubsUpdateTags_594048, base: "",
    url: url_VirtualHubsUpdateTags_594049, schemes: {Scheme.Https})
type
  Call_VirtualHubsDelete_594036 = ref object of OpenApiRestCall_593424
proc url_VirtualHubsDelete_594038(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualHubsDelete_594037(path: JsonNode; query: JsonNode;
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
  var valid_594039 = path.getOrDefault("resourceGroupName")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "resourceGroupName", valid_594039
  var valid_594040 = path.getOrDefault("subscriptionId")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "subscriptionId", valid_594040
  var valid_594041 = path.getOrDefault("virtualHubName")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "virtualHubName", valid_594041
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594042 = query.getOrDefault("api-version")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "api-version", valid_594042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594043: Call_VirtualHubsDelete_594036; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a VirtualHub.
  ## 
  let valid = call_594043.validator(path, query, header, formData, body)
  let scheme = call_594043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594043.url(scheme.get, call_594043.host, call_594043.base,
                         call_594043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594043, url, valid)

proc call*(call_594044: Call_VirtualHubsDelete_594036; resourceGroupName: string;
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
  var path_594045 = newJObject()
  var query_594046 = newJObject()
  add(path_594045, "resourceGroupName", newJString(resourceGroupName))
  add(query_594046, "api-version", newJString(apiVersion))
  add(path_594045, "subscriptionId", newJString(subscriptionId))
  add(path_594045, "virtualHubName", newJString(virtualHubName))
  result = call_594044.call(path_594045, query_594046, nil, nil, nil)

var virtualHubsDelete* = Call_VirtualHubsDelete_594036(name: "virtualHubsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}",
    validator: validate_VirtualHubsDelete_594037, base: "",
    url: url_VirtualHubsDelete_594038, schemes: {Scheme.Https})
type
  Call_HubVirtualNetworkConnectionsList_594060 = ref object of OpenApiRestCall_593424
proc url_HubVirtualNetworkConnectionsList_594062(protocol: Scheme; host: string;
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

proc validate_HubVirtualNetworkConnectionsList_594061(path: JsonNode;
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
  var valid_594063 = path.getOrDefault("resourceGroupName")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "resourceGroupName", valid_594063
  var valid_594064 = path.getOrDefault("subscriptionId")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "subscriptionId", valid_594064
  var valid_594065 = path.getOrDefault("virtualHubName")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "virtualHubName", valid_594065
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594066 = query.getOrDefault("api-version")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "api-version", valid_594066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594067: Call_HubVirtualNetworkConnectionsList_594060;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the details of all HubVirtualNetworkConnections.
  ## 
  let valid = call_594067.validator(path, query, header, formData, body)
  let scheme = call_594067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594067.url(scheme.get, call_594067.host, call_594067.base,
                         call_594067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594067, url, valid)

proc call*(call_594068: Call_HubVirtualNetworkConnectionsList_594060;
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
  var path_594069 = newJObject()
  var query_594070 = newJObject()
  add(path_594069, "resourceGroupName", newJString(resourceGroupName))
  add(query_594070, "api-version", newJString(apiVersion))
  add(path_594069, "subscriptionId", newJString(subscriptionId))
  add(path_594069, "virtualHubName", newJString(virtualHubName))
  result = call_594068.call(path_594069, query_594070, nil, nil, nil)

var hubVirtualNetworkConnectionsList* = Call_HubVirtualNetworkConnectionsList_594060(
    name: "hubVirtualNetworkConnectionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}/hubVirtualNetworkConnections",
    validator: validate_HubVirtualNetworkConnectionsList_594061, base: "",
    url: url_HubVirtualNetworkConnectionsList_594062, schemes: {Scheme.Https})
type
  Call_HubVirtualNetworkConnectionsGet_594071 = ref object of OpenApiRestCall_593424
proc url_HubVirtualNetworkConnectionsGet_594073(protocol: Scheme; host: string;
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

proc validate_HubVirtualNetworkConnectionsGet_594072(path: JsonNode;
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
  var valid_594074 = path.getOrDefault("resourceGroupName")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "resourceGroupName", valid_594074
  var valid_594075 = path.getOrDefault("subscriptionId")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "subscriptionId", valid_594075
  var valid_594076 = path.getOrDefault("virtualHubName")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "virtualHubName", valid_594076
  var valid_594077 = path.getOrDefault("connectionName")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "connectionName", valid_594077
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594078 = query.getOrDefault("api-version")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "api-version", valid_594078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594079: Call_HubVirtualNetworkConnectionsGet_594071;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the details of a HubVirtualNetworkConnection.
  ## 
  let valid = call_594079.validator(path, query, header, formData, body)
  let scheme = call_594079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594079.url(scheme.get, call_594079.host, call_594079.base,
                         call_594079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594079, url, valid)

proc call*(call_594080: Call_HubVirtualNetworkConnectionsGet_594071;
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
  var path_594081 = newJObject()
  var query_594082 = newJObject()
  add(path_594081, "resourceGroupName", newJString(resourceGroupName))
  add(query_594082, "api-version", newJString(apiVersion))
  add(path_594081, "subscriptionId", newJString(subscriptionId))
  add(path_594081, "virtualHubName", newJString(virtualHubName))
  add(path_594081, "connectionName", newJString(connectionName))
  result = call_594080.call(path_594081, query_594082, nil, nil, nil)

var hubVirtualNetworkConnectionsGet* = Call_HubVirtualNetworkConnectionsGet_594071(
    name: "hubVirtualNetworkConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}/hubVirtualNetworkConnections/{connectionName}",
    validator: validate_HubVirtualNetworkConnectionsGet_594072, base: "",
    url: url_HubVirtualNetworkConnectionsGet_594073, schemes: {Scheme.Https})
type
  Call_VirtualWANsListByResourceGroup_594083 = ref object of OpenApiRestCall_593424
proc url_VirtualWANsListByResourceGroup_594085(protocol: Scheme; host: string;
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

proc validate_VirtualWANsListByResourceGroup_594084(path: JsonNode;
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
  var valid_594086 = path.getOrDefault("resourceGroupName")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "resourceGroupName", valid_594086
  var valid_594087 = path.getOrDefault("subscriptionId")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "subscriptionId", valid_594087
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594088 = query.getOrDefault("api-version")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "api-version", valid_594088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594089: Call_VirtualWANsListByResourceGroup_594083; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VirtualWANs in a resource group.
  ## 
  let valid = call_594089.validator(path, query, header, formData, body)
  let scheme = call_594089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594089.url(scheme.get, call_594089.host, call_594089.base,
                         call_594089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594089, url, valid)

proc call*(call_594090: Call_VirtualWANsListByResourceGroup_594083;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualWANsListByResourceGroup
  ## Lists all the VirtualWANs in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualWan.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594091 = newJObject()
  var query_594092 = newJObject()
  add(path_594091, "resourceGroupName", newJString(resourceGroupName))
  add(query_594092, "api-version", newJString(apiVersion))
  add(path_594091, "subscriptionId", newJString(subscriptionId))
  result = call_594090.call(path_594091, query_594092, nil, nil, nil)

var virtualWANsListByResourceGroup* = Call_VirtualWANsListByResourceGroup_594083(
    name: "virtualWANsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans",
    validator: validate_VirtualWANsListByResourceGroup_594084, base: "",
    url: url_VirtualWANsListByResourceGroup_594085, schemes: {Scheme.Https})
type
  Call_VirtualWANsCreateOrUpdate_594104 = ref object of OpenApiRestCall_593424
proc url_VirtualWANsCreateOrUpdate_594106(protocol: Scheme; host: string;
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

proc validate_VirtualWANsCreateOrUpdate_594105(path: JsonNode; query: JsonNode;
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
  var valid_594107 = path.getOrDefault("resourceGroupName")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "resourceGroupName", valid_594107
  var valid_594108 = path.getOrDefault("VirtualWANName")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "VirtualWANName", valid_594108
  var valid_594109 = path.getOrDefault("subscriptionId")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "subscriptionId", valid_594109
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594110 = query.getOrDefault("api-version")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "api-version", valid_594110
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

proc call*(call_594112: Call_VirtualWANsCreateOrUpdate_594104; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a VirtualWAN resource if it doesn't exist else updates the existing VirtualWAN.
  ## 
  let valid = call_594112.validator(path, query, header, formData, body)
  let scheme = call_594112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594112.url(scheme.get, call_594112.host, call_594112.base,
                         call_594112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594112, url, valid)

proc call*(call_594113: Call_VirtualWANsCreateOrUpdate_594104;
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
  var path_594114 = newJObject()
  var query_594115 = newJObject()
  var body_594116 = newJObject()
  add(path_594114, "resourceGroupName", newJString(resourceGroupName))
  add(path_594114, "VirtualWANName", newJString(VirtualWANName))
  add(query_594115, "api-version", newJString(apiVersion))
  add(path_594114, "subscriptionId", newJString(subscriptionId))
  if WANParameters != nil:
    body_594116 = WANParameters
  result = call_594113.call(path_594114, query_594115, nil, nil, body_594116)

var virtualWANsCreateOrUpdate* = Call_VirtualWANsCreateOrUpdate_594104(
    name: "virtualWANsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{VirtualWANName}",
    validator: validate_VirtualWANsCreateOrUpdate_594105, base: "",
    url: url_VirtualWANsCreateOrUpdate_594106, schemes: {Scheme.Https})
type
  Call_VirtualWANsGet_594093 = ref object of OpenApiRestCall_593424
proc url_VirtualWANsGet_594095(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualWANsGet_594094(path: JsonNode; query: JsonNode;
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
  var valid_594096 = path.getOrDefault("resourceGroupName")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "resourceGroupName", valid_594096
  var valid_594097 = path.getOrDefault("VirtualWANName")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "VirtualWANName", valid_594097
  var valid_594098 = path.getOrDefault("subscriptionId")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "subscriptionId", valid_594098
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594099 = query.getOrDefault("api-version")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "api-version", valid_594099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594100: Call_VirtualWANsGet_594093; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a VirtualWAN.
  ## 
  let valid = call_594100.validator(path, query, header, formData, body)
  let scheme = call_594100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594100.url(scheme.get, call_594100.host, call_594100.base,
                         call_594100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594100, url, valid)

proc call*(call_594101: Call_VirtualWANsGet_594093; resourceGroupName: string;
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
  var path_594102 = newJObject()
  var query_594103 = newJObject()
  add(path_594102, "resourceGroupName", newJString(resourceGroupName))
  add(path_594102, "VirtualWANName", newJString(VirtualWANName))
  add(query_594103, "api-version", newJString(apiVersion))
  add(path_594102, "subscriptionId", newJString(subscriptionId))
  result = call_594101.call(path_594102, query_594103, nil, nil, nil)

var virtualWANsGet* = Call_VirtualWANsGet_594093(name: "virtualWANsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{VirtualWANName}",
    validator: validate_VirtualWANsGet_594094, base: "", url: url_VirtualWANsGet_594095,
    schemes: {Scheme.Https})
type
  Call_VirtualWANsUpdateTags_594128 = ref object of OpenApiRestCall_593424
proc url_VirtualWANsUpdateTags_594130(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualWANsUpdateTags_594129(path: JsonNode; query: JsonNode;
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
  var valid_594131 = path.getOrDefault("resourceGroupName")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "resourceGroupName", valid_594131
  var valid_594132 = path.getOrDefault("VirtualWANName")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "VirtualWANName", valid_594132
  var valid_594133 = path.getOrDefault("subscriptionId")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "subscriptionId", valid_594133
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594134 = query.getOrDefault("api-version")
  valid_594134 = validateParameter(valid_594134, JString, required = true,
                                 default = nil)
  if valid_594134 != nil:
    section.add "api-version", valid_594134
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

proc call*(call_594136: Call_VirtualWANsUpdateTags_594128; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a VirtualWAN tags.
  ## 
  let valid = call_594136.validator(path, query, header, formData, body)
  let scheme = call_594136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594136.url(scheme.get, call_594136.host, call_594136.base,
                         call_594136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594136, url, valid)

proc call*(call_594137: Call_VirtualWANsUpdateTags_594128;
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
  var path_594138 = newJObject()
  var query_594139 = newJObject()
  var body_594140 = newJObject()
  add(path_594138, "resourceGroupName", newJString(resourceGroupName))
  add(path_594138, "VirtualWANName", newJString(VirtualWANName))
  add(query_594139, "api-version", newJString(apiVersion))
  add(path_594138, "subscriptionId", newJString(subscriptionId))
  if WANParameters != nil:
    body_594140 = WANParameters
  result = call_594137.call(path_594138, query_594139, nil, nil, body_594140)

var virtualWANsUpdateTags* = Call_VirtualWANsUpdateTags_594128(
    name: "virtualWANsUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{VirtualWANName}",
    validator: validate_VirtualWANsUpdateTags_594129, base: "",
    url: url_VirtualWANsUpdateTags_594130, schemes: {Scheme.Https})
type
  Call_VirtualWANsDelete_594117 = ref object of OpenApiRestCall_593424
proc url_VirtualWANsDelete_594119(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualWANsDelete_594118(path: JsonNode; query: JsonNode;
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
  var valid_594120 = path.getOrDefault("resourceGroupName")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "resourceGroupName", valid_594120
  var valid_594121 = path.getOrDefault("VirtualWANName")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "VirtualWANName", valid_594121
  var valid_594122 = path.getOrDefault("subscriptionId")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "subscriptionId", valid_594122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594123 = query.getOrDefault("api-version")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "api-version", valid_594123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594124: Call_VirtualWANsDelete_594117; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a VirtualWAN.
  ## 
  let valid = call_594124.validator(path, query, header, formData, body)
  let scheme = call_594124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594124.url(scheme.get, call_594124.host, call_594124.base,
                         call_594124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594124, url, valid)

proc call*(call_594125: Call_VirtualWANsDelete_594117; resourceGroupName: string;
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
  var path_594126 = newJObject()
  var query_594127 = newJObject()
  add(path_594126, "resourceGroupName", newJString(resourceGroupName))
  add(path_594126, "VirtualWANName", newJString(VirtualWANName))
  add(query_594127, "api-version", newJString(apiVersion))
  add(path_594126, "subscriptionId", newJString(subscriptionId))
  result = call_594125.call(path_594126, query_594127, nil, nil, nil)

var virtualWANsDelete* = Call_VirtualWANsDelete_594117(name: "virtualWANsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{VirtualWANName}",
    validator: validate_VirtualWANsDelete_594118, base: "",
    url: url_VirtualWANsDelete_594119, schemes: {Scheme.Https})
type
  Call_VpnSitesConfigurationDownload_594141 = ref object of OpenApiRestCall_593424
proc url_VpnSitesConfigurationDownload_594143(protocol: Scheme; host: string;
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

proc validate_VpnSitesConfigurationDownload_594142(path: JsonNode; query: JsonNode;
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
  var valid_594144 = path.getOrDefault("resourceGroupName")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "resourceGroupName", valid_594144
  var valid_594145 = path.getOrDefault("subscriptionId")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "subscriptionId", valid_594145
  var valid_594146 = path.getOrDefault("virtualWANName")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "virtualWANName", valid_594146
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594147 = query.getOrDefault("api-version")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "api-version", valid_594147
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

proc call*(call_594149: Call_VpnSitesConfigurationDownload_594141; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gives the sas-url to download the configurations for vpn-sites in a resource group.
  ## 
  let valid = call_594149.validator(path, query, header, formData, body)
  let scheme = call_594149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594149.url(scheme.get, call_594149.host, call_594149.base,
                         call_594149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594149, url, valid)

proc call*(call_594150: Call_VpnSitesConfigurationDownload_594141;
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
  var path_594151 = newJObject()
  var query_594152 = newJObject()
  var body_594153 = newJObject()
  add(path_594151, "resourceGroupName", newJString(resourceGroupName))
  add(query_594152, "api-version", newJString(apiVersion))
  add(path_594151, "subscriptionId", newJString(subscriptionId))
  if request != nil:
    body_594153 = request
  add(path_594151, "virtualWANName", newJString(virtualWANName))
  result = call_594150.call(path_594151, query_594152, nil, nil, body_594153)

var vpnSitesConfigurationDownload* = Call_VpnSitesConfigurationDownload_594141(
    name: "vpnSitesConfigurationDownload", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{virtualWANName}/vpnConfiguration",
    validator: validate_VpnSitesConfigurationDownload_594142, base: "",
    url: url_VpnSitesConfigurationDownload_594143, schemes: {Scheme.Https})
type
  Call_VpnGatewaysListByResourceGroup_594154 = ref object of OpenApiRestCall_593424
proc url_VpnGatewaysListByResourceGroup_594156(protocol: Scheme; host: string;
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

proc validate_VpnGatewaysListByResourceGroup_594155(path: JsonNode;
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
  var valid_594157 = path.getOrDefault("resourceGroupName")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "resourceGroupName", valid_594157
  var valid_594158 = path.getOrDefault("subscriptionId")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "subscriptionId", valid_594158
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594159 = query.getOrDefault("api-version")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "api-version", valid_594159
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594160: Call_VpnGatewaysListByResourceGroup_594154; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VpnGateways in a resource group.
  ## 
  let valid = call_594160.validator(path, query, header, formData, body)
  let scheme = call_594160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594160.url(scheme.get, call_594160.host, call_594160.base,
                         call_594160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594160, url, valid)

proc call*(call_594161: Call_VpnGatewaysListByResourceGroup_594154;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## vpnGatewaysListByResourceGroup
  ## Lists all the VpnGateways in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnGateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594162 = newJObject()
  var query_594163 = newJObject()
  add(path_594162, "resourceGroupName", newJString(resourceGroupName))
  add(query_594163, "api-version", newJString(apiVersion))
  add(path_594162, "subscriptionId", newJString(subscriptionId))
  result = call_594161.call(path_594162, query_594163, nil, nil, nil)

var vpnGatewaysListByResourceGroup* = Call_VpnGatewaysListByResourceGroup_594154(
    name: "vpnGatewaysListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways",
    validator: validate_VpnGatewaysListByResourceGroup_594155, base: "",
    url: url_VpnGatewaysListByResourceGroup_594156, schemes: {Scheme.Https})
type
  Call_VpnGatewaysCreateOrUpdate_594175 = ref object of OpenApiRestCall_593424
proc url_VpnGatewaysCreateOrUpdate_594177(protocol: Scheme; host: string;
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

proc validate_VpnGatewaysCreateOrUpdate_594176(path: JsonNode; query: JsonNode;
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
  var valid_594178 = path.getOrDefault("resourceGroupName")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "resourceGroupName", valid_594178
  var valid_594179 = path.getOrDefault("gatewayName")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "gatewayName", valid_594179
  var valid_594180 = path.getOrDefault("subscriptionId")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "subscriptionId", valid_594180
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594181 = query.getOrDefault("api-version")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "api-version", valid_594181
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

proc call*(call_594183: Call_VpnGatewaysCreateOrUpdate_594175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a virtual wan vpn gateway if it doesn't exist else updates the existing gateway.
  ## 
  let valid = call_594183.validator(path, query, header, formData, body)
  let scheme = call_594183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594183.url(scheme.get, call_594183.host, call_594183.base,
                         call_594183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594183, url, valid)

proc call*(call_594184: Call_VpnGatewaysCreateOrUpdate_594175;
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
  var path_594185 = newJObject()
  var query_594186 = newJObject()
  var body_594187 = newJObject()
  add(path_594185, "resourceGroupName", newJString(resourceGroupName))
  add(query_594186, "api-version", newJString(apiVersion))
  add(path_594185, "gatewayName", newJString(gatewayName))
  add(path_594185, "subscriptionId", newJString(subscriptionId))
  if vpnGatewayParameters != nil:
    body_594187 = vpnGatewayParameters
  result = call_594184.call(path_594185, query_594186, nil, nil, body_594187)

var vpnGatewaysCreateOrUpdate* = Call_VpnGatewaysCreateOrUpdate_594175(
    name: "vpnGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}",
    validator: validate_VpnGatewaysCreateOrUpdate_594176, base: "",
    url: url_VpnGatewaysCreateOrUpdate_594177, schemes: {Scheme.Https})
type
  Call_VpnGatewaysGet_594164 = ref object of OpenApiRestCall_593424
proc url_VpnGatewaysGet_594166(protocol: Scheme; host: string; base: string;
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

proc validate_VpnGatewaysGet_594165(path: JsonNode; query: JsonNode;
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
  var valid_594167 = path.getOrDefault("resourceGroupName")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "resourceGroupName", valid_594167
  var valid_594168 = path.getOrDefault("gatewayName")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "gatewayName", valid_594168
  var valid_594169 = path.getOrDefault("subscriptionId")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "subscriptionId", valid_594169
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594170 = query.getOrDefault("api-version")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "api-version", valid_594170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594171: Call_VpnGatewaysGet_594164; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a virtual wan vpn gateway.
  ## 
  let valid = call_594171.validator(path, query, header, formData, body)
  let scheme = call_594171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594171.url(scheme.get, call_594171.host, call_594171.base,
                         call_594171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594171, url, valid)

proc call*(call_594172: Call_VpnGatewaysGet_594164; resourceGroupName: string;
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
  var path_594173 = newJObject()
  var query_594174 = newJObject()
  add(path_594173, "resourceGroupName", newJString(resourceGroupName))
  add(query_594174, "api-version", newJString(apiVersion))
  add(path_594173, "gatewayName", newJString(gatewayName))
  add(path_594173, "subscriptionId", newJString(subscriptionId))
  result = call_594172.call(path_594173, query_594174, nil, nil, nil)

var vpnGatewaysGet* = Call_VpnGatewaysGet_594164(name: "vpnGatewaysGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}",
    validator: validate_VpnGatewaysGet_594165, base: "", url: url_VpnGatewaysGet_594166,
    schemes: {Scheme.Https})
type
  Call_VpnGatewaysUpdateTags_594199 = ref object of OpenApiRestCall_593424
proc url_VpnGatewaysUpdateTags_594201(protocol: Scheme; host: string; base: string;
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

proc validate_VpnGatewaysUpdateTags_594200(path: JsonNode; query: JsonNode;
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
  var valid_594202 = path.getOrDefault("resourceGroupName")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "resourceGroupName", valid_594202
  var valid_594203 = path.getOrDefault("gatewayName")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "gatewayName", valid_594203
  var valid_594204 = path.getOrDefault("subscriptionId")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = nil)
  if valid_594204 != nil:
    section.add "subscriptionId", valid_594204
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594205 = query.getOrDefault("api-version")
  valid_594205 = validateParameter(valid_594205, JString, required = true,
                                 default = nil)
  if valid_594205 != nil:
    section.add "api-version", valid_594205
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

proc call*(call_594207: Call_VpnGatewaysUpdateTags_594199; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates virtual wan vpn gateway tags.
  ## 
  let valid = call_594207.validator(path, query, header, formData, body)
  let scheme = call_594207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594207.url(scheme.get, call_594207.host, call_594207.base,
                         call_594207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594207, url, valid)

proc call*(call_594208: Call_VpnGatewaysUpdateTags_594199;
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
  var path_594209 = newJObject()
  var query_594210 = newJObject()
  var body_594211 = newJObject()
  add(path_594209, "resourceGroupName", newJString(resourceGroupName))
  add(query_594210, "api-version", newJString(apiVersion))
  add(path_594209, "gatewayName", newJString(gatewayName))
  add(path_594209, "subscriptionId", newJString(subscriptionId))
  if vpnGatewayParameters != nil:
    body_594211 = vpnGatewayParameters
  result = call_594208.call(path_594209, query_594210, nil, nil, body_594211)

var vpnGatewaysUpdateTags* = Call_VpnGatewaysUpdateTags_594199(
    name: "vpnGatewaysUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}",
    validator: validate_VpnGatewaysUpdateTags_594200, base: "",
    url: url_VpnGatewaysUpdateTags_594201, schemes: {Scheme.Https})
type
  Call_VpnGatewaysDelete_594188 = ref object of OpenApiRestCall_593424
proc url_VpnGatewaysDelete_594190(protocol: Scheme; host: string; base: string;
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

proc validate_VpnGatewaysDelete_594189(path: JsonNode; query: JsonNode;
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
  var valid_594191 = path.getOrDefault("resourceGroupName")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "resourceGroupName", valid_594191
  var valid_594192 = path.getOrDefault("gatewayName")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "gatewayName", valid_594192
  var valid_594193 = path.getOrDefault("subscriptionId")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "subscriptionId", valid_594193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594194 = query.getOrDefault("api-version")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "api-version", valid_594194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594195: Call_VpnGatewaysDelete_594188; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a virtual wan vpn gateway.
  ## 
  let valid = call_594195.validator(path, query, header, formData, body)
  let scheme = call_594195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594195.url(scheme.get, call_594195.host, call_594195.base,
                         call_594195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594195, url, valid)

proc call*(call_594196: Call_VpnGatewaysDelete_594188; resourceGroupName: string;
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
  var path_594197 = newJObject()
  var query_594198 = newJObject()
  add(path_594197, "resourceGroupName", newJString(resourceGroupName))
  add(query_594198, "api-version", newJString(apiVersion))
  add(path_594197, "gatewayName", newJString(gatewayName))
  add(path_594197, "subscriptionId", newJString(subscriptionId))
  result = call_594196.call(path_594197, query_594198, nil, nil, nil)

var vpnGatewaysDelete* = Call_VpnGatewaysDelete_594188(name: "vpnGatewaysDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}",
    validator: validate_VpnGatewaysDelete_594189, base: "",
    url: url_VpnGatewaysDelete_594190, schemes: {Scheme.Https})
type
  Call_VpnConnectionsListByVpnGateway_594212 = ref object of OpenApiRestCall_593424
proc url_VpnConnectionsListByVpnGateway_594214(protocol: Scheme; host: string;
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

proc validate_VpnConnectionsListByVpnGateway_594213(path: JsonNode;
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
  var valid_594215 = path.getOrDefault("resourceGroupName")
  valid_594215 = validateParameter(valid_594215, JString, required = true,
                                 default = nil)
  if valid_594215 != nil:
    section.add "resourceGroupName", valid_594215
  var valid_594216 = path.getOrDefault("gatewayName")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "gatewayName", valid_594216
  var valid_594217 = path.getOrDefault("subscriptionId")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "subscriptionId", valid_594217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594218 = query.getOrDefault("api-version")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "api-version", valid_594218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594219: Call_VpnConnectionsListByVpnGateway_594212; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all vpn connections for a particular virtual wan vpn gateway.
  ## 
  let valid = call_594219.validator(path, query, header, formData, body)
  let scheme = call_594219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594219.url(scheme.get, call_594219.host, call_594219.base,
                         call_594219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594219, url, valid)

proc call*(call_594220: Call_VpnConnectionsListByVpnGateway_594212;
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
  var path_594221 = newJObject()
  var query_594222 = newJObject()
  add(path_594221, "resourceGroupName", newJString(resourceGroupName))
  add(query_594222, "api-version", newJString(apiVersion))
  add(path_594221, "gatewayName", newJString(gatewayName))
  add(path_594221, "subscriptionId", newJString(subscriptionId))
  result = call_594220.call(path_594221, query_594222, nil, nil, nil)

var vpnConnectionsListByVpnGateway* = Call_VpnConnectionsListByVpnGateway_594212(
    name: "vpnConnectionsListByVpnGateway", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections",
    validator: validate_VpnConnectionsListByVpnGateway_594213, base: "",
    url: url_VpnConnectionsListByVpnGateway_594214, schemes: {Scheme.Https})
type
  Call_VpnConnectionsCreateOrUpdate_594235 = ref object of OpenApiRestCall_593424
proc url_VpnConnectionsCreateOrUpdate_594237(protocol: Scheme; host: string;
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

proc validate_VpnConnectionsCreateOrUpdate_594236(path: JsonNode; query: JsonNode;
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
  var valid_594238 = path.getOrDefault("resourceGroupName")
  valid_594238 = validateParameter(valid_594238, JString, required = true,
                                 default = nil)
  if valid_594238 != nil:
    section.add "resourceGroupName", valid_594238
  var valid_594239 = path.getOrDefault("gatewayName")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "gatewayName", valid_594239
  var valid_594240 = path.getOrDefault("subscriptionId")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "subscriptionId", valid_594240
  var valid_594241 = path.getOrDefault("connectionName")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "connectionName", valid_594241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594242 = query.getOrDefault("api-version")
  valid_594242 = validateParameter(valid_594242, JString, required = true,
                                 default = nil)
  if valid_594242 != nil:
    section.add "api-version", valid_594242
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

proc call*(call_594244: Call_VpnConnectionsCreateOrUpdate_594235; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a vpn connection to a scalable vpn gateway if it doesn't exist else updates the existing connection.
  ## 
  let valid = call_594244.validator(path, query, header, formData, body)
  let scheme = call_594244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594244.url(scheme.get, call_594244.host, call_594244.base,
                         call_594244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594244, url, valid)

proc call*(call_594245: Call_VpnConnectionsCreateOrUpdate_594235;
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
  var path_594246 = newJObject()
  var query_594247 = newJObject()
  var body_594248 = newJObject()
  add(path_594246, "resourceGroupName", newJString(resourceGroupName))
  add(query_594247, "api-version", newJString(apiVersion))
  add(path_594246, "gatewayName", newJString(gatewayName))
  add(path_594246, "subscriptionId", newJString(subscriptionId))
  if VpnConnectionParameters != nil:
    body_594248 = VpnConnectionParameters
  add(path_594246, "connectionName", newJString(connectionName))
  result = call_594245.call(path_594246, query_594247, nil, nil, body_594248)

var vpnConnectionsCreateOrUpdate* = Call_VpnConnectionsCreateOrUpdate_594235(
    name: "vpnConnectionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections/{connectionName}",
    validator: validate_VpnConnectionsCreateOrUpdate_594236, base: "",
    url: url_VpnConnectionsCreateOrUpdate_594237, schemes: {Scheme.Https})
type
  Call_VpnConnectionsGet_594223 = ref object of OpenApiRestCall_593424
proc url_VpnConnectionsGet_594225(protocol: Scheme; host: string; base: string;
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

proc validate_VpnConnectionsGet_594224(path: JsonNode; query: JsonNode;
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
  var valid_594226 = path.getOrDefault("resourceGroupName")
  valid_594226 = validateParameter(valid_594226, JString, required = true,
                                 default = nil)
  if valid_594226 != nil:
    section.add "resourceGroupName", valid_594226
  var valid_594227 = path.getOrDefault("gatewayName")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "gatewayName", valid_594227
  var valid_594228 = path.getOrDefault("subscriptionId")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "subscriptionId", valid_594228
  var valid_594229 = path.getOrDefault("connectionName")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "connectionName", valid_594229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594230 = query.getOrDefault("api-version")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "api-version", valid_594230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594231: Call_VpnConnectionsGet_594223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a vpn connection.
  ## 
  let valid = call_594231.validator(path, query, header, formData, body)
  let scheme = call_594231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594231.url(scheme.get, call_594231.host, call_594231.base,
                         call_594231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594231, url, valid)

proc call*(call_594232: Call_VpnConnectionsGet_594223; resourceGroupName: string;
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
  var path_594233 = newJObject()
  var query_594234 = newJObject()
  add(path_594233, "resourceGroupName", newJString(resourceGroupName))
  add(query_594234, "api-version", newJString(apiVersion))
  add(path_594233, "gatewayName", newJString(gatewayName))
  add(path_594233, "subscriptionId", newJString(subscriptionId))
  add(path_594233, "connectionName", newJString(connectionName))
  result = call_594232.call(path_594233, query_594234, nil, nil, nil)

var vpnConnectionsGet* = Call_VpnConnectionsGet_594223(name: "vpnConnectionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections/{connectionName}",
    validator: validate_VpnConnectionsGet_594224, base: "",
    url: url_VpnConnectionsGet_594225, schemes: {Scheme.Https})
type
  Call_VpnConnectionsDelete_594249 = ref object of OpenApiRestCall_593424
proc url_VpnConnectionsDelete_594251(protocol: Scheme; host: string; base: string;
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

proc validate_VpnConnectionsDelete_594250(path: JsonNode; query: JsonNode;
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
  var valid_594252 = path.getOrDefault("resourceGroupName")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = nil)
  if valid_594252 != nil:
    section.add "resourceGroupName", valid_594252
  var valid_594253 = path.getOrDefault("gatewayName")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = nil)
  if valid_594253 != nil:
    section.add "gatewayName", valid_594253
  var valid_594254 = path.getOrDefault("subscriptionId")
  valid_594254 = validateParameter(valid_594254, JString, required = true,
                                 default = nil)
  if valid_594254 != nil:
    section.add "subscriptionId", valid_594254
  var valid_594255 = path.getOrDefault("connectionName")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = nil)
  if valid_594255 != nil:
    section.add "connectionName", valid_594255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594256 = query.getOrDefault("api-version")
  valid_594256 = validateParameter(valid_594256, JString, required = true,
                                 default = nil)
  if valid_594256 != nil:
    section.add "api-version", valid_594256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594257: Call_VpnConnectionsDelete_594249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a vpn connection.
  ## 
  let valid = call_594257.validator(path, query, header, formData, body)
  let scheme = call_594257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594257.url(scheme.get, call_594257.host, call_594257.base,
                         call_594257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594257, url, valid)

proc call*(call_594258: Call_VpnConnectionsDelete_594249;
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
  var path_594259 = newJObject()
  var query_594260 = newJObject()
  add(path_594259, "resourceGroupName", newJString(resourceGroupName))
  add(query_594260, "api-version", newJString(apiVersion))
  add(path_594259, "gatewayName", newJString(gatewayName))
  add(path_594259, "subscriptionId", newJString(subscriptionId))
  add(path_594259, "connectionName", newJString(connectionName))
  result = call_594258.call(path_594259, query_594260, nil, nil, nil)

var vpnConnectionsDelete* = Call_VpnConnectionsDelete_594249(
    name: "vpnConnectionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections/{connectionName}",
    validator: validate_VpnConnectionsDelete_594250, base: "",
    url: url_VpnConnectionsDelete_594251, schemes: {Scheme.Https})
type
  Call_VpnSitesListByResourceGroup_594261 = ref object of OpenApiRestCall_593424
proc url_VpnSitesListByResourceGroup_594263(protocol: Scheme; host: string;
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

proc validate_VpnSitesListByResourceGroup_594262(path: JsonNode; query: JsonNode;
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
  var valid_594264 = path.getOrDefault("resourceGroupName")
  valid_594264 = validateParameter(valid_594264, JString, required = true,
                                 default = nil)
  if valid_594264 != nil:
    section.add "resourceGroupName", valid_594264
  var valid_594265 = path.getOrDefault("subscriptionId")
  valid_594265 = validateParameter(valid_594265, JString, required = true,
                                 default = nil)
  if valid_594265 != nil:
    section.add "subscriptionId", valid_594265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594266 = query.getOrDefault("api-version")
  valid_594266 = validateParameter(valid_594266, JString, required = true,
                                 default = nil)
  if valid_594266 != nil:
    section.add "api-version", valid_594266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594267: Call_VpnSitesListByResourceGroup_594261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the vpnSites in a resource group.
  ## 
  let valid = call_594267.validator(path, query, header, formData, body)
  let scheme = call_594267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594267.url(scheme.get, call_594267.host, call_594267.base,
                         call_594267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594267, url, valid)

proc call*(call_594268: Call_VpnSitesListByResourceGroup_594261;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## vpnSitesListByResourceGroup
  ## Lists all the vpnSites in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnSite.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594269 = newJObject()
  var query_594270 = newJObject()
  add(path_594269, "resourceGroupName", newJString(resourceGroupName))
  add(query_594270, "api-version", newJString(apiVersion))
  add(path_594269, "subscriptionId", newJString(subscriptionId))
  result = call_594268.call(path_594269, query_594270, nil, nil, nil)

var vpnSitesListByResourceGroup* = Call_VpnSitesListByResourceGroup_594261(
    name: "vpnSitesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites",
    validator: validate_VpnSitesListByResourceGroup_594262, base: "",
    url: url_VpnSitesListByResourceGroup_594263, schemes: {Scheme.Https})
type
  Call_VpnSitesCreateOrUpdate_594282 = ref object of OpenApiRestCall_593424
proc url_VpnSitesCreateOrUpdate_594284(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSitesCreateOrUpdate_594283(path: JsonNode; query: JsonNode;
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
  var valid_594285 = path.getOrDefault("resourceGroupName")
  valid_594285 = validateParameter(valid_594285, JString, required = true,
                                 default = nil)
  if valid_594285 != nil:
    section.add "resourceGroupName", valid_594285
  var valid_594286 = path.getOrDefault("vpnSiteName")
  valid_594286 = validateParameter(valid_594286, JString, required = true,
                                 default = nil)
  if valid_594286 != nil:
    section.add "vpnSiteName", valid_594286
  var valid_594287 = path.getOrDefault("subscriptionId")
  valid_594287 = validateParameter(valid_594287, JString, required = true,
                                 default = nil)
  if valid_594287 != nil:
    section.add "subscriptionId", valid_594287
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594288 = query.getOrDefault("api-version")
  valid_594288 = validateParameter(valid_594288, JString, required = true,
                                 default = nil)
  if valid_594288 != nil:
    section.add "api-version", valid_594288
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

proc call*(call_594290: Call_VpnSitesCreateOrUpdate_594282; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a VpnSite resource if it doesn't exist else updates the existing VpnSite.
  ## 
  let valid = call_594290.validator(path, query, header, formData, body)
  let scheme = call_594290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594290.url(scheme.get, call_594290.host, call_594290.base,
                         call_594290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594290, url, valid)

proc call*(call_594291: Call_VpnSitesCreateOrUpdate_594282;
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
  var path_594292 = newJObject()
  var query_594293 = newJObject()
  var body_594294 = newJObject()
  add(path_594292, "resourceGroupName", newJString(resourceGroupName))
  add(query_594293, "api-version", newJString(apiVersion))
  add(path_594292, "vpnSiteName", newJString(vpnSiteName))
  add(path_594292, "subscriptionId", newJString(subscriptionId))
  if VpnSiteParameters != nil:
    body_594294 = VpnSiteParameters
  result = call_594291.call(path_594292, query_594293, nil, nil, body_594294)

var vpnSitesCreateOrUpdate* = Call_VpnSitesCreateOrUpdate_594282(
    name: "vpnSitesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}",
    validator: validate_VpnSitesCreateOrUpdate_594283, base: "",
    url: url_VpnSitesCreateOrUpdate_594284, schemes: {Scheme.Https})
type
  Call_VpnSitesGet_594271 = ref object of OpenApiRestCall_593424
proc url_VpnSitesGet_594273(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSitesGet_594272(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594274 = path.getOrDefault("resourceGroupName")
  valid_594274 = validateParameter(valid_594274, JString, required = true,
                                 default = nil)
  if valid_594274 != nil:
    section.add "resourceGroupName", valid_594274
  var valid_594275 = path.getOrDefault("vpnSiteName")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "vpnSiteName", valid_594275
  var valid_594276 = path.getOrDefault("subscriptionId")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "subscriptionId", valid_594276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594277 = query.getOrDefault("api-version")
  valid_594277 = validateParameter(valid_594277, JString, required = true,
                                 default = nil)
  if valid_594277 != nil:
    section.add "api-version", valid_594277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594278: Call_VpnSitesGet_594271; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a VPN site.
  ## 
  let valid = call_594278.validator(path, query, header, formData, body)
  let scheme = call_594278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594278.url(scheme.get, call_594278.host, call_594278.base,
                         call_594278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594278, url, valid)

proc call*(call_594279: Call_VpnSitesGet_594271; resourceGroupName: string;
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
  var path_594280 = newJObject()
  var query_594281 = newJObject()
  add(path_594280, "resourceGroupName", newJString(resourceGroupName))
  add(query_594281, "api-version", newJString(apiVersion))
  add(path_594280, "vpnSiteName", newJString(vpnSiteName))
  add(path_594280, "subscriptionId", newJString(subscriptionId))
  result = call_594279.call(path_594280, query_594281, nil, nil, nil)

var vpnSitesGet* = Call_VpnSitesGet_594271(name: "vpnSitesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}",
                                        validator: validate_VpnSitesGet_594272,
                                        base: "", url: url_VpnSitesGet_594273,
                                        schemes: {Scheme.Https})
type
  Call_VpnSitesUpdateTags_594306 = ref object of OpenApiRestCall_593424
proc url_VpnSitesUpdateTags_594308(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSitesUpdateTags_594307(path: JsonNode; query: JsonNode;
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
  var valid_594309 = path.getOrDefault("resourceGroupName")
  valid_594309 = validateParameter(valid_594309, JString, required = true,
                                 default = nil)
  if valid_594309 != nil:
    section.add "resourceGroupName", valid_594309
  var valid_594310 = path.getOrDefault("vpnSiteName")
  valid_594310 = validateParameter(valid_594310, JString, required = true,
                                 default = nil)
  if valid_594310 != nil:
    section.add "vpnSiteName", valid_594310
  var valid_594311 = path.getOrDefault("subscriptionId")
  valid_594311 = validateParameter(valid_594311, JString, required = true,
                                 default = nil)
  if valid_594311 != nil:
    section.add "subscriptionId", valid_594311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594312 = query.getOrDefault("api-version")
  valid_594312 = validateParameter(valid_594312, JString, required = true,
                                 default = nil)
  if valid_594312 != nil:
    section.add "api-version", valid_594312
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

proc call*(call_594314: Call_VpnSitesUpdateTags_594306; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates VpnSite tags.
  ## 
  let valid = call_594314.validator(path, query, header, formData, body)
  let scheme = call_594314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594314.url(scheme.get, call_594314.host, call_594314.base,
                         call_594314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594314, url, valid)

proc call*(call_594315: Call_VpnSitesUpdateTags_594306; resourceGroupName: string;
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
  var path_594316 = newJObject()
  var query_594317 = newJObject()
  var body_594318 = newJObject()
  add(path_594316, "resourceGroupName", newJString(resourceGroupName))
  add(query_594317, "api-version", newJString(apiVersion))
  add(path_594316, "vpnSiteName", newJString(vpnSiteName))
  add(path_594316, "subscriptionId", newJString(subscriptionId))
  if VpnSiteParameters != nil:
    body_594318 = VpnSiteParameters
  result = call_594315.call(path_594316, query_594317, nil, nil, body_594318)

var vpnSitesUpdateTags* = Call_VpnSitesUpdateTags_594306(
    name: "vpnSitesUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}",
    validator: validate_VpnSitesUpdateTags_594307, base: "",
    url: url_VpnSitesUpdateTags_594308, schemes: {Scheme.Https})
type
  Call_VpnSitesDelete_594295 = ref object of OpenApiRestCall_593424
proc url_VpnSitesDelete_594297(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSitesDelete_594296(path: JsonNode; query: JsonNode;
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
  var valid_594298 = path.getOrDefault("resourceGroupName")
  valid_594298 = validateParameter(valid_594298, JString, required = true,
                                 default = nil)
  if valid_594298 != nil:
    section.add "resourceGroupName", valid_594298
  var valid_594299 = path.getOrDefault("vpnSiteName")
  valid_594299 = validateParameter(valid_594299, JString, required = true,
                                 default = nil)
  if valid_594299 != nil:
    section.add "vpnSiteName", valid_594299
  var valid_594300 = path.getOrDefault("subscriptionId")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "subscriptionId", valid_594300
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594301 = query.getOrDefault("api-version")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "api-version", valid_594301
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594302: Call_VpnSitesDelete_594295; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a VpnSite.
  ## 
  let valid = call_594302.validator(path, query, header, formData, body)
  let scheme = call_594302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594302.url(scheme.get, call_594302.host, call_594302.base,
                         call_594302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594302, url, valid)

proc call*(call_594303: Call_VpnSitesDelete_594295; resourceGroupName: string;
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
  var path_594304 = newJObject()
  var query_594305 = newJObject()
  add(path_594304, "resourceGroupName", newJString(resourceGroupName))
  add(query_594305, "api-version", newJString(apiVersion))
  add(path_594304, "vpnSiteName", newJString(vpnSiteName))
  add(path_594304, "subscriptionId", newJString(subscriptionId))
  result = call_594303.call(path_594304, query_594305, nil, nil, nil)

var vpnSitesDelete* = Call_VpnSitesDelete_594295(name: "vpnSitesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}",
    validator: validate_VpnSitesDelete_594296, base: "", url: url_VpnSitesDelete_594297,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
