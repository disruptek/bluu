
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: VirtualWANAsAServiceManagementClient
## version: 2018-12-01
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

  OpenApiRestCall_593437 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593437](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593437): Option[Scheme] {.used.} =
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
  Call_P2sVpnGatewaysList_593659 = ref object of OpenApiRestCall_593437
proc url_P2sVpnGatewaysList_593661(protocol: Scheme; host: string; base: string;
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

proc validate_P2sVpnGatewaysList_593660(path: JsonNode; query: JsonNode;
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
  var valid_593821 = path.getOrDefault("subscriptionId")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = nil)
  if valid_593821 != nil:
    section.add "subscriptionId", valid_593821
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593822 = query.getOrDefault("api-version")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "api-version", valid_593822
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593849: Call_P2sVpnGatewaysList_593659; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the P2SVpnGateways in a subscription.
  ## 
  let valid = call_593849.validator(path, query, header, formData, body)
  let scheme = call_593849.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593849.url(scheme.get, call_593849.host, call_593849.base,
                         call_593849.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593849, url, valid)

proc call*(call_593920: Call_P2sVpnGatewaysList_593659; apiVersion: string;
          subscriptionId: string): Recallable =
  ## p2sVpnGatewaysList
  ## Lists all the P2SVpnGateways in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593921 = newJObject()
  var query_593923 = newJObject()
  add(query_593923, "api-version", newJString(apiVersion))
  add(path_593921, "subscriptionId", newJString(subscriptionId))
  result = call_593920.call(path_593921, query_593923, nil, nil, nil)

var p2sVpnGatewaysList* = Call_P2sVpnGatewaysList_593659(
    name: "p2sVpnGatewaysList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/p2svpnGateways",
    validator: validate_P2sVpnGatewaysList_593660, base: "",
    url: url_P2sVpnGatewaysList_593661, schemes: {Scheme.Https})
type
  Call_VirtualHubsList_593962 = ref object of OpenApiRestCall_593437
proc url_VirtualHubsList_593964(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualHubsList_593963(path: JsonNode; query: JsonNode;
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
  var valid_593965 = path.getOrDefault("subscriptionId")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "subscriptionId", valid_593965
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593966 = query.getOrDefault("api-version")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "api-version", valid_593966
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593967: Call_VirtualHubsList_593962; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VirtualHubs in a subscription.
  ## 
  let valid = call_593967.validator(path, query, header, formData, body)
  let scheme = call_593967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593967.url(scheme.get, call_593967.host, call_593967.base,
                         call_593967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593967, url, valid)

proc call*(call_593968: Call_VirtualHubsList_593962; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualHubsList
  ## Lists all the VirtualHubs in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593969 = newJObject()
  var query_593970 = newJObject()
  add(query_593970, "api-version", newJString(apiVersion))
  add(path_593969, "subscriptionId", newJString(subscriptionId))
  result = call_593968.call(path_593969, query_593970, nil, nil, nil)

var virtualHubsList* = Call_VirtualHubsList_593962(name: "virtualHubsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/virtualHubs",
    validator: validate_VirtualHubsList_593963, base: "", url: url_VirtualHubsList_593964,
    schemes: {Scheme.Https})
type
  Call_VirtualWansList_593971 = ref object of OpenApiRestCall_593437
proc url_VirtualWansList_593973(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualWansList_593972(path: JsonNode; query: JsonNode;
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
  var valid_593974 = path.getOrDefault("subscriptionId")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "subscriptionId", valid_593974
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593975 = query.getOrDefault("api-version")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "api-version", valid_593975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593976: Call_VirtualWansList_593971; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VirtualWANs in a subscription.
  ## 
  let valid = call_593976.validator(path, query, header, formData, body)
  let scheme = call_593976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593976.url(scheme.get, call_593976.host, call_593976.base,
                         call_593976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593976, url, valid)

proc call*(call_593977: Call_VirtualWansList_593971; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualWansList
  ## Lists all the VirtualWANs in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593978 = newJObject()
  var query_593979 = newJObject()
  add(query_593979, "api-version", newJString(apiVersion))
  add(path_593978, "subscriptionId", newJString(subscriptionId))
  result = call_593977.call(path_593978, query_593979, nil, nil, nil)

var virtualWansList* = Call_VirtualWansList_593971(name: "virtualWansList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/virtualWans",
    validator: validate_VirtualWansList_593972, base: "", url: url_VirtualWansList_593973,
    schemes: {Scheme.Https})
type
  Call_VpnGatewaysList_593980 = ref object of OpenApiRestCall_593437
proc url_VpnGatewaysList_593982(protocol: Scheme; host: string; base: string;
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

proc validate_VpnGatewaysList_593981(path: JsonNode; query: JsonNode;
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
  var valid_593983 = path.getOrDefault("subscriptionId")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "subscriptionId", valid_593983
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593984 = query.getOrDefault("api-version")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "api-version", valid_593984
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593985: Call_VpnGatewaysList_593980; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VpnGateways in a subscription.
  ## 
  let valid = call_593985.validator(path, query, header, formData, body)
  let scheme = call_593985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593985.url(scheme.get, call_593985.host, call_593985.base,
                         call_593985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593985, url, valid)

proc call*(call_593986: Call_VpnGatewaysList_593980; apiVersion: string;
          subscriptionId: string): Recallable =
  ## vpnGatewaysList
  ## Lists all the VpnGateways in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593987 = newJObject()
  var query_593988 = newJObject()
  add(query_593988, "api-version", newJString(apiVersion))
  add(path_593987, "subscriptionId", newJString(subscriptionId))
  result = call_593986.call(path_593987, query_593988, nil, nil, nil)

var vpnGatewaysList* = Call_VpnGatewaysList_593980(name: "vpnGatewaysList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/vpnGateways",
    validator: validate_VpnGatewaysList_593981, base: "", url: url_VpnGatewaysList_593982,
    schemes: {Scheme.Https})
type
  Call_VpnSitesList_593989 = ref object of OpenApiRestCall_593437
proc url_VpnSitesList_593991(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSitesList_593990(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593992 = path.getOrDefault("subscriptionId")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "subscriptionId", valid_593992
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593993 = query.getOrDefault("api-version")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "api-version", valid_593993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593994: Call_VpnSitesList_593989; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VpnSites in a subscription.
  ## 
  let valid = call_593994.validator(path, query, header, formData, body)
  let scheme = call_593994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593994.url(scheme.get, call_593994.host, call_593994.base,
                         call_593994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593994, url, valid)

proc call*(call_593995: Call_VpnSitesList_593989; apiVersion: string;
          subscriptionId: string): Recallable =
  ## vpnSitesList
  ## Lists all the VpnSites in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593996 = newJObject()
  var query_593997 = newJObject()
  add(query_593997, "api-version", newJString(apiVersion))
  add(path_593996, "subscriptionId", newJString(subscriptionId))
  result = call_593995.call(path_593996, query_593997, nil, nil, nil)

var vpnSitesList* = Call_VpnSitesList_593989(name: "vpnSitesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/vpnSites",
    validator: validate_VpnSitesList_593990, base: "", url: url_VpnSitesList_593991,
    schemes: {Scheme.Https})
type
  Call_P2sVpnGatewaysListByResourceGroup_593998 = ref object of OpenApiRestCall_593437
proc url_P2sVpnGatewaysListByResourceGroup_594000(protocol: Scheme; host: string;
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

proc validate_P2sVpnGatewaysListByResourceGroup_593999(path: JsonNode;
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
  var valid_594001 = path.getOrDefault("resourceGroupName")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "resourceGroupName", valid_594001
  var valid_594002 = path.getOrDefault("subscriptionId")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "subscriptionId", valid_594002
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594003 = query.getOrDefault("api-version")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "api-version", valid_594003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594004: Call_P2sVpnGatewaysListByResourceGroup_593998;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the P2SVpnGateways in a resource group.
  ## 
  let valid = call_594004.validator(path, query, header, formData, body)
  let scheme = call_594004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594004.url(scheme.get, call_594004.host, call_594004.base,
                         call_594004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594004, url, valid)

proc call*(call_594005: Call_P2sVpnGatewaysListByResourceGroup_593998;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## p2sVpnGatewaysListByResourceGroup
  ## Lists all the P2SVpnGateways in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the P2SVpnGateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594006 = newJObject()
  var query_594007 = newJObject()
  add(path_594006, "resourceGroupName", newJString(resourceGroupName))
  add(query_594007, "api-version", newJString(apiVersion))
  add(path_594006, "subscriptionId", newJString(subscriptionId))
  result = call_594005.call(path_594006, query_594007, nil, nil, nil)

var p2sVpnGatewaysListByResourceGroup* = Call_P2sVpnGatewaysListByResourceGroup_593998(
    name: "p2sVpnGatewaysListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/p2svpnGateways",
    validator: validate_P2sVpnGatewaysListByResourceGroup_593999, base: "",
    url: url_P2sVpnGatewaysListByResourceGroup_594000, schemes: {Scheme.Https})
type
  Call_P2sVpnGatewaysCreateOrUpdate_594019 = ref object of OpenApiRestCall_593437
proc url_P2sVpnGatewaysCreateOrUpdate_594021(protocol: Scheme; host: string;
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

proc validate_P2sVpnGatewaysCreateOrUpdate_594020(path: JsonNode; query: JsonNode;
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
  var valid_594048 = path.getOrDefault("resourceGroupName")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "resourceGroupName", valid_594048
  var valid_594049 = path.getOrDefault("gatewayName")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "gatewayName", valid_594049
  var valid_594050 = path.getOrDefault("subscriptionId")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "subscriptionId", valid_594050
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594051 = query.getOrDefault("api-version")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "api-version", valid_594051
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

proc call*(call_594053: Call_P2sVpnGatewaysCreateOrUpdate_594019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a virtual wan p2s vpn gateway if it doesn't exist else updates the existing gateway.
  ## 
  let valid = call_594053.validator(path, query, header, formData, body)
  let scheme = call_594053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594053.url(scheme.get, call_594053.host, call_594053.base,
                         call_594053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594053, url, valid)

proc call*(call_594054: Call_P2sVpnGatewaysCreateOrUpdate_594019;
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
  var path_594055 = newJObject()
  var query_594056 = newJObject()
  var body_594057 = newJObject()
  add(path_594055, "resourceGroupName", newJString(resourceGroupName))
  add(query_594056, "api-version", newJString(apiVersion))
  add(path_594055, "gatewayName", newJString(gatewayName))
  add(path_594055, "subscriptionId", newJString(subscriptionId))
  if p2SVpnGatewayParameters != nil:
    body_594057 = p2SVpnGatewayParameters
  result = call_594054.call(path_594055, query_594056, nil, nil, body_594057)

var p2sVpnGatewaysCreateOrUpdate* = Call_P2sVpnGatewaysCreateOrUpdate_594019(
    name: "p2sVpnGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/p2svpnGateways/{gatewayName}",
    validator: validate_P2sVpnGatewaysCreateOrUpdate_594020, base: "",
    url: url_P2sVpnGatewaysCreateOrUpdate_594021, schemes: {Scheme.Https})
type
  Call_P2sVpnGatewaysGet_594008 = ref object of OpenApiRestCall_593437
proc url_P2sVpnGatewaysGet_594010(protocol: Scheme; host: string; base: string;
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

proc validate_P2sVpnGatewaysGet_594009(path: JsonNode; query: JsonNode;
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
  var valid_594011 = path.getOrDefault("resourceGroupName")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "resourceGroupName", valid_594011
  var valid_594012 = path.getOrDefault("gatewayName")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "gatewayName", valid_594012
  var valid_594013 = path.getOrDefault("subscriptionId")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "subscriptionId", valid_594013
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594014 = query.getOrDefault("api-version")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "api-version", valid_594014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594015: Call_P2sVpnGatewaysGet_594008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a virtual wan p2s vpn gateway.
  ## 
  let valid = call_594015.validator(path, query, header, formData, body)
  let scheme = call_594015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594015.url(scheme.get, call_594015.host, call_594015.base,
                         call_594015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594015, url, valid)

proc call*(call_594016: Call_P2sVpnGatewaysGet_594008; resourceGroupName: string;
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
  var path_594017 = newJObject()
  var query_594018 = newJObject()
  add(path_594017, "resourceGroupName", newJString(resourceGroupName))
  add(query_594018, "api-version", newJString(apiVersion))
  add(path_594017, "gatewayName", newJString(gatewayName))
  add(path_594017, "subscriptionId", newJString(subscriptionId))
  result = call_594016.call(path_594017, query_594018, nil, nil, nil)

var p2sVpnGatewaysGet* = Call_P2sVpnGatewaysGet_594008(name: "p2sVpnGatewaysGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/p2svpnGateways/{gatewayName}",
    validator: validate_P2sVpnGatewaysGet_594009, base: "",
    url: url_P2sVpnGatewaysGet_594010, schemes: {Scheme.Https})
type
  Call_P2sVpnGatewaysUpdateTags_594069 = ref object of OpenApiRestCall_593437
proc url_P2sVpnGatewaysUpdateTags_594071(protocol: Scheme; host: string;
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

proc validate_P2sVpnGatewaysUpdateTags_594070(path: JsonNode; query: JsonNode;
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
  var valid_594072 = path.getOrDefault("resourceGroupName")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "resourceGroupName", valid_594072
  var valid_594073 = path.getOrDefault("gatewayName")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "gatewayName", valid_594073
  var valid_594074 = path.getOrDefault("subscriptionId")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "subscriptionId", valid_594074
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594075 = query.getOrDefault("api-version")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "api-version", valid_594075
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

proc call*(call_594077: Call_P2sVpnGatewaysUpdateTags_594069; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates virtual wan p2s vpn gateway tags.
  ## 
  let valid = call_594077.validator(path, query, header, formData, body)
  let scheme = call_594077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594077.url(scheme.get, call_594077.host, call_594077.base,
                         call_594077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594077, url, valid)

proc call*(call_594078: Call_P2sVpnGatewaysUpdateTags_594069;
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
  var path_594079 = newJObject()
  var query_594080 = newJObject()
  var body_594081 = newJObject()
  add(path_594079, "resourceGroupName", newJString(resourceGroupName))
  add(query_594080, "api-version", newJString(apiVersion))
  add(path_594079, "gatewayName", newJString(gatewayName))
  add(path_594079, "subscriptionId", newJString(subscriptionId))
  if p2SVpnGatewayParameters != nil:
    body_594081 = p2SVpnGatewayParameters
  result = call_594078.call(path_594079, query_594080, nil, nil, body_594081)

var p2sVpnGatewaysUpdateTags* = Call_P2sVpnGatewaysUpdateTags_594069(
    name: "p2sVpnGatewaysUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/p2svpnGateways/{gatewayName}",
    validator: validate_P2sVpnGatewaysUpdateTags_594070, base: "",
    url: url_P2sVpnGatewaysUpdateTags_594071, schemes: {Scheme.Https})
type
  Call_P2sVpnGatewaysDelete_594058 = ref object of OpenApiRestCall_593437
proc url_P2sVpnGatewaysDelete_594060(protocol: Scheme; host: string; base: string;
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

proc validate_P2sVpnGatewaysDelete_594059(path: JsonNode; query: JsonNode;
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
  var valid_594061 = path.getOrDefault("resourceGroupName")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "resourceGroupName", valid_594061
  var valid_594062 = path.getOrDefault("gatewayName")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "gatewayName", valid_594062
  var valid_594063 = path.getOrDefault("subscriptionId")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "subscriptionId", valid_594063
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594064 = query.getOrDefault("api-version")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "api-version", valid_594064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594065: Call_P2sVpnGatewaysDelete_594058; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a virtual wan p2s vpn gateway.
  ## 
  let valid = call_594065.validator(path, query, header, formData, body)
  let scheme = call_594065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594065.url(scheme.get, call_594065.host, call_594065.base,
                         call_594065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594065, url, valid)

proc call*(call_594066: Call_P2sVpnGatewaysDelete_594058;
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
  var path_594067 = newJObject()
  var query_594068 = newJObject()
  add(path_594067, "resourceGroupName", newJString(resourceGroupName))
  add(query_594068, "api-version", newJString(apiVersion))
  add(path_594067, "gatewayName", newJString(gatewayName))
  add(path_594067, "subscriptionId", newJString(subscriptionId))
  result = call_594066.call(path_594067, query_594068, nil, nil, nil)

var p2sVpnGatewaysDelete* = Call_P2sVpnGatewaysDelete_594058(
    name: "p2sVpnGatewaysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/p2svpnGateways/{gatewayName}",
    validator: validate_P2sVpnGatewaysDelete_594059, base: "",
    url: url_P2sVpnGatewaysDelete_594060, schemes: {Scheme.Https})
type
  Call_P2sVpnGatewaysGenerateVpnProfile_594082 = ref object of OpenApiRestCall_593437
proc url_P2sVpnGatewaysGenerateVpnProfile_594084(protocol: Scheme; host: string;
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

proc validate_P2sVpnGatewaysGenerateVpnProfile_594083(path: JsonNode;
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
  var valid_594085 = path.getOrDefault("resourceGroupName")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "resourceGroupName", valid_594085
  var valid_594086 = path.getOrDefault("gatewayName")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "gatewayName", valid_594086
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the generate P2SVpnGateway VPN client package operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594090: Call_P2sVpnGatewaysGenerateVpnProfile_594082;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates VPN profile for P2S client of the P2SVpnGateway in the specified resource group.
  ## 
  let valid = call_594090.validator(path, query, header, formData, body)
  let scheme = call_594090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594090.url(scheme.get, call_594090.host, call_594090.base,
                         call_594090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594090, url, valid)

proc call*(call_594091: Call_P2sVpnGatewaysGenerateVpnProfile_594082;
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
  var path_594092 = newJObject()
  var query_594093 = newJObject()
  var body_594094 = newJObject()
  add(path_594092, "resourceGroupName", newJString(resourceGroupName))
  add(query_594093, "api-version", newJString(apiVersion))
  add(path_594092, "gatewayName", newJString(gatewayName))
  add(path_594092, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594094 = parameters
  result = call_594091.call(path_594092, query_594093, nil, nil, body_594094)

var p2sVpnGatewaysGenerateVpnProfile* = Call_P2sVpnGatewaysGenerateVpnProfile_594082(
    name: "p2sVpnGatewaysGenerateVpnProfile", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/p2svpnGateways/{gatewayName}/generatevpnprofile",
    validator: validate_P2sVpnGatewaysGenerateVpnProfile_594083, base: "",
    url: url_P2sVpnGatewaysGenerateVpnProfile_594084, schemes: {Scheme.Https})
type
  Call_VirtualHubsListByResourceGroup_594095 = ref object of OpenApiRestCall_593437
proc url_VirtualHubsListByResourceGroup_594097(protocol: Scheme; host: string;
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

proc validate_VirtualHubsListByResourceGroup_594096(path: JsonNode;
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
  var valid_594098 = path.getOrDefault("resourceGroupName")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "resourceGroupName", valid_594098
  var valid_594099 = path.getOrDefault("subscriptionId")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "subscriptionId", valid_594099
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594100 = query.getOrDefault("api-version")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "api-version", valid_594100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594101: Call_VirtualHubsListByResourceGroup_594095; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VirtualHubs in a resource group.
  ## 
  let valid = call_594101.validator(path, query, header, formData, body)
  let scheme = call_594101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594101.url(scheme.get, call_594101.host, call_594101.base,
                         call_594101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594101, url, valid)

proc call*(call_594102: Call_VirtualHubsListByResourceGroup_594095;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualHubsListByResourceGroup
  ## Lists all the VirtualHubs in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualHub.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594103 = newJObject()
  var query_594104 = newJObject()
  add(path_594103, "resourceGroupName", newJString(resourceGroupName))
  add(query_594104, "api-version", newJString(apiVersion))
  add(path_594103, "subscriptionId", newJString(subscriptionId))
  result = call_594102.call(path_594103, query_594104, nil, nil, nil)

var virtualHubsListByResourceGroup* = Call_VirtualHubsListByResourceGroup_594095(
    name: "virtualHubsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs",
    validator: validate_VirtualHubsListByResourceGroup_594096, base: "",
    url: url_VirtualHubsListByResourceGroup_594097, schemes: {Scheme.Https})
type
  Call_VirtualHubsCreateOrUpdate_594116 = ref object of OpenApiRestCall_593437
proc url_VirtualHubsCreateOrUpdate_594118(protocol: Scheme; host: string;
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

proc validate_VirtualHubsCreateOrUpdate_594117(path: JsonNode; query: JsonNode;
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
  var valid_594119 = path.getOrDefault("resourceGroupName")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = nil)
  if valid_594119 != nil:
    section.add "resourceGroupName", valid_594119
  var valid_594120 = path.getOrDefault("subscriptionId")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "subscriptionId", valid_594120
  var valid_594121 = path.getOrDefault("virtualHubName")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "virtualHubName", valid_594121
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594122 = query.getOrDefault("api-version")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "api-version", valid_594122
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

proc call*(call_594124: Call_VirtualHubsCreateOrUpdate_594116; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a VirtualHub resource if it doesn't exist else updates the existing VirtualHub.
  ## 
  let valid = call_594124.validator(path, query, header, formData, body)
  let scheme = call_594124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594124.url(scheme.get, call_594124.host, call_594124.base,
                         call_594124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594124, url, valid)

proc call*(call_594125: Call_VirtualHubsCreateOrUpdate_594116;
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
  var path_594126 = newJObject()
  var query_594127 = newJObject()
  var body_594128 = newJObject()
  add(path_594126, "resourceGroupName", newJString(resourceGroupName))
  add(query_594127, "api-version", newJString(apiVersion))
  add(path_594126, "subscriptionId", newJString(subscriptionId))
  add(path_594126, "virtualHubName", newJString(virtualHubName))
  if virtualHubParameters != nil:
    body_594128 = virtualHubParameters
  result = call_594125.call(path_594126, query_594127, nil, nil, body_594128)

var virtualHubsCreateOrUpdate* = Call_VirtualHubsCreateOrUpdate_594116(
    name: "virtualHubsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}",
    validator: validate_VirtualHubsCreateOrUpdate_594117, base: "",
    url: url_VirtualHubsCreateOrUpdate_594118, schemes: {Scheme.Https})
type
  Call_VirtualHubsGet_594105 = ref object of OpenApiRestCall_593437
proc url_VirtualHubsGet_594107(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualHubsGet_594106(path: JsonNode; query: JsonNode;
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
  var valid_594108 = path.getOrDefault("resourceGroupName")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "resourceGroupName", valid_594108
  var valid_594109 = path.getOrDefault("subscriptionId")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "subscriptionId", valid_594109
  var valid_594110 = path.getOrDefault("virtualHubName")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "virtualHubName", valid_594110
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594111 = query.getOrDefault("api-version")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "api-version", valid_594111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594112: Call_VirtualHubsGet_594105; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a VirtualHub.
  ## 
  let valid = call_594112.validator(path, query, header, formData, body)
  let scheme = call_594112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594112.url(scheme.get, call_594112.host, call_594112.base,
                         call_594112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594112, url, valid)

proc call*(call_594113: Call_VirtualHubsGet_594105; resourceGroupName: string;
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
  var path_594114 = newJObject()
  var query_594115 = newJObject()
  add(path_594114, "resourceGroupName", newJString(resourceGroupName))
  add(query_594115, "api-version", newJString(apiVersion))
  add(path_594114, "subscriptionId", newJString(subscriptionId))
  add(path_594114, "virtualHubName", newJString(virtualHubName))
  result = call_594113.call(path_594114, query_594115, nil, nil, nil)

var virtualHubsGet* = Call_VirtualHubsGet_594105(name: "virtualHubsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}",
    validator: validate_VirtualHubsGet_594106, base: "", url: url_VirtualHubsGet_594107,
    schemes: {Scheme.Https})
type
  Call_VirtualHubsUpdateTags_594140 = ref object of OpenApiRestCall_593437
proc url_VirtualHubsUpdateTags_594142(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualHubsUpdateTags_594141(path: JsonNode; query: JsonNode;
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
  var valid_594143 = path.getOrDefault("resourceGroupName")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "resourceGroupName", valid_594143
  var valid_594144 = path.getOrDefault("subscriptionId")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "subscriptionId", valid_594144
  var valid_594145 = path.getOrDefault("virtualHubName")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "virtualHubName", valid_594145
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594146 = query.getOrDefault("api-version")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "api-version", valid_594146
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

proc call*(call_594148: Call_VirtualHubsUpdateTags_594140; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates VirtualHub tags.
  ## 
  let valid = call_594148.validator(path, query, header, formData, body)
  let scheme = call_594148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594148.url(scheme.get, call_594148.host, call_594148.base,
                         call_594148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594148, url, valid)

proc call*(call_594149: Call_VirtualHubsUpdateTags_594140;
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
  var path_594150 = newJObject()
  var query_594151 = newJObject()
  var body_594152 = newJObject()
  add(path_594150, "resourceGroupName", newJString(resourceGroupName))
  add(query_594151, "api-version", newJString(apiVersion))
  add(path_594150, "subscriptionId", newJString(subscriptionId))
  add(path_594150, "virtualHubName", newJString(virtualHubName))
  if virtualHubParameters != nil:
    body_594152 = virtualHubParameters
  result = call_594149.call(path_594150, query_594151, nil, nil, body_594152)

var virtualHubsUpdateTags* = Call_VirtualHubsUpdateTags_594140(
    name: "virtualHubsUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}",
    validator: validate_VirtualHubsUpdateTags_594141, base: "",
    url: url_VirtualHubsUpdateTags_594142, schemes: {Scheme.Https})
type
  Call_VirtualHubsDelete_594129 = ref object of OpenApiRestCall_593437
proc url_VirtualHubsDelete_594131(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualHubsDelete_594130(path: JsonNode; query: JsonNode;
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
  var valid_594132 = path.getOrDefault("resourceGroupName")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "resourceGroupName", valid_594132
  var valid_594133 = path.getOrDefault("subscriptionId")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "subscriptionId", valid_594133
  var valid_594134 = path.getOrDefault("virtualHubName")
  valid_594134 = validateParameter(valid_594134, JString, required = true,
                                 default = nil)
  if valid_594134 != nil:
    section.add "virtualHubName", valid_594134
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594135 = query.getOrDefault("api-version")
  valid_594135 = validateParameter(valid_594135, JString, required = true,
                                 default = nil)
  if valid_594135 != nil:
    section.add "api-version", valid_594135
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594136: Call_VirtualHubsDelete_594129; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a VirtualHub.
  ## 
  let valid = call_594136.validator(path, query, header, formData, body)
  let scheme = call_594136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594136.url(scheme.get, call_594136.host, call_594136.base,
                         call_594136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594136, url, valid)

proc call*(call_594137: Call_VirtualHubsDelete_594129; resourceGroupName: string;
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
  var path_594138 = newJObject()
  var query_594139 = newJObject()
  add(path_594138, "resourceGroupName", newJString(resourceGroupName))
  add(query_594139, "api-version", newJString(apiVersion))
  add(path_594138, "subscriptionId", newJString(subscriptionId))
  add(path_594138, "virtualHubName", newJString(virtualHubName))
  result = call_594137.call(path_594138, query_594139, nil, nil, nil)

var virtualHubsDelete* = Call_VirtualHubsDelete_594129(name: "virtualHubsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}",
    validator: validate_VirtualHubsDelete_594130, base: "",
    url: url_VirtualHubsDelete_594131, schemes: {Scheme.Https})
type
  Call_HubVirtualNetworkConnectionsList_594153 = ref object of OpenApiRestCall_593437
proc url_HubVirtualNetworkConnectionsList_594155(protocol: Scheme; host: string;
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

proc validate_HubVirtualNetworkConnectionsList_594154(path: JsonNode;
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
  var valid_594156 = path.getOrDefault("resourceGroupName")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "resourceGroupName", valid_594156
  var valid_594157 = path.getOrDefault("subscriptionId")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "subscriptionId", valid_594157
  var valid_594158 = path.getOrDefault("virtualHubName")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "virtualHubName", valid_594158
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

proc call*(call_594160: Call_HubVirtualNetworkConnectionsList_594153;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the details of all HubVirtualNetworkConnections.
  ## 
  let valid = call_594160.validator(path, query, header, formData, body)
  let scheme = call_594160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594160.url(scheme.get, call_594160.host, call_594160.base,
                         call_594160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594160, url, valid)

proc call*(call_594161: Call_HubVirtualNetworkConnectionsList_594153;
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
  var path_594162 = newJObject()
  var query_594163 = newJObject()
  add(path_594162, "resourceGroupName", newJString(resourceGroupName))
  add(query_594163, "api-version", newJString(apiVersion))
  add(path_594162, "subscriptionId", newJString(subscriptionId))
  add(path_594162, "virtualHubName", newJString(virtualHubName))
  result = call_594161.call(path_594162, query_594163, nil, nil, nil)

var hubVirtualNetworkConnectionsList* = Call_HubVirtualNetworkConnectionsList_594153(
    name: "hubVirtualNetworkConnectionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}/hubVirtualNetworkConnections",
    validator: validate_HubVirtualNetworkConnectionsList_594154, base: "",
    url: url_HubVirtualNetworkConnectionsList_594155, schemes: {Scheme.Https})
type
  Call_HubVirtualNetworkConnectionsGet_594164 = ref object of OpenApiRestCall_593437
proc url_HubVirtualNetworkConnectionsGet_594166(protocol: Scheme; host: string;
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

proc validate_HubVirtualNetworkConnectionsGet_594165(path: JsonNode;
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
  var valid_594167 = path.getOrDefault("resourceGroupName")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "resourceGroupName", valid_594167
  var valid_594168 = path.getOrDefault("subscriptionId")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "subscriptionId", valid_594168
  var valid_594169 = path.getOrDefault("virtualHubName")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "virtualHubName", valid_594169
  var valid_594170 = path.getOrDefault("connectionName")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "connectionName", valid_594170
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594171 = query.getOrDefault("api-version")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "api-version", valid_594171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594172: Call_HubVirtualNetworkConnectionsGet_594164;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the details of a HubVirtualNetworkConnection.
  ## 
  let valid = call_594172.validator(path, query, header, formData, body)
  let scheme = call_594172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594172.url(scheme.get, call_594172.host, call_594172.base,
                         call_594172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594172, url, valid)

proc call*(call_594173: Call_HubVirtualNetworkConnectionsGet_594164;
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
  var path_594174 = newJObject()
  var query_594175 = newJObject()
  add(path_594174, "resourceGroupName", newJString(resourceGroupName))
  add(query_594175, "api-version", newJString(apiVersion))
  add(path_594174, "subscriptionId", newJString(subscriptionId))
  add(path_594174, "virtualHubName", newJString(virtualHubName))
  add(path_594174, "connectionName", newJString(connectionName))
  result = call_594173.call(path_594174, query_594175, nil, nil, nil)

var hubVirtualNetworkConnectionsGet* = Call_HubVirtualNetworkConnectionsGet_594164(
    name: "hubVirtualNetworkConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}/hubVirtualNetworkConnections/{connectionName}",
    validator: validate_HubVirtualNetworkConnectionsGet_594165, base: "",
    url: url_HubVirtualNetworkConnectionsGet_594166, schemes: {Scheme.Https})
type
  Call_VirtualWansListByResourceGroup_594176 = ref object of OpenApiRestCall_593437
proc url_VirtualWansListByResourceGroup_594178(protocol: Scheme; host: string;
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

proc validate_VirtualWansListByResourceGroup_594177(path: JsonNode;
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
  var valid_594179 = path.getOrDefault("resourceGroupName")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "resourceGroupName", valid_594179
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
  if body != nil:
    result.add "body", body

proc call*(call_594182: Call_VirtualWansListByResourceGroup_594176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VirtualWANs in a resource group.
  ## 
  let valid = call_594182.validator(path, query, header, formData, body)
  let scheme = call_594182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594182.url(scheme.get, call_594182.host, call_594182.base,
                         call_594182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594182, url, valid)

proc call*(call_594183: Call_VirtualWansListByResourceGroup_594176;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualWansListByResourceGroup
  ## Lists all the VirtualWANs in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualWan.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594184 = newJObject()
  var query_594185 = newJObject()
  add(path_594184, "resourceGroupName", newJString(resourceGroupName))
  add(query_594185, "api-version", newJString(apiVersion))
  add(path_594184, "subscriptionId", newJString(subscriptionId))
  result = call_594183.call(path_594184, query_594185, nil, nil, nil)

var virtualWansListByResourceGroup* = Call_VirtualWansListByResourceGroup_594176(
    name: "virtualWansListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans",
    validator: validate_VirtualWansListByResourceGroup_594177, base: "",
    url: url_VirtualWansListByResourceGroup_594178, schemes: {Scheme.Https})
type
  Call_VirtualWansCreateOrUpdate_594197 = ref object of OpenApiRestCall_593437
proc url_VirtualWansCreateOrUpdate_594199(protocol: Scheme; host: string;
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

proc validate_VirtualWansCreateOrUpdate_594198(path: JsonNode; query: JsonNode;
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
  var valid_594200 = path.getOrDefault("resourceGroupName")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "resourceGroupName", valid_594200
  var valid_594201 = path.getOrDefault("VirtualWANName")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "VirtualWANName", valid_594201
  var valid_594202 = path.getOrDefault("subscriptionId")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "subscriptionId", valid_594202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594203 = query.getOrDefault("api-version")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "api-version", valid_594203
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

proc call*(call_594205: Call_VirtualWansCreateOrUpdate_594197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a VirtualWAN resource if it doesn't exist else updates the existing VirtualWAN.
  ## 
  let valid = call_594205.validator(path, query, header, formData, body)
  let scheme = call_594205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594205.url(scheme.get, call_594205.host, call_594205.base,
                         call_594205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594205, url, valid)

proc call*(call_594206: Call_VirtualWansCreateOrUpdate_594197;
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
  var path_594207 = newJObject()
  var query_594208 = newJObject()
  var body_594209 = newJObject()
  add(path_594207, "resourceGroupName", newJString(resourceGroupName))
  add(path_594207, "VirtualWANName", newJString(VirtualWANName))
  add(query_594208, "api-version", newJString(apiVersion))
  add(path_594207, "subscriptionId", newJString(subscriptionId))
  if WANParameters != nil:
    body_594209 = WANParameters
  result = call_594206.call(path_594207, query_594208, nil, nil, body_594209)

var virtualWansCreateOrUpdate* = Call_VirtualWansCreateOrUpdate_594197(
    name: "virtualWansCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{VirtualWANName}",
    validator: validate_VirtualWansCreateOrUpdate_594198, base: "",
    url: url_VirtualWansCreateOrUpdate_594199, schemes: {Scheme.Https})
type
  Call_VirtualWansGet_594186 = ref object of OpenApiRestCall_593437
proc url_VirtualWansGet_594188(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualWansGet_594187(path: JsonNode; query: JsonNode;
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
  var valid_594189 = path.getOrDefault("resourceGroupName")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "resourceGroupName", valid_594189
  var valid_594190 = path.getOrDefault("VirtualWANName")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "VirtualWANName", valid_594190
  var valid_594191 = path.getOrDefault("subscriptionId")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "subscriptionId", valid_594191
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594192 = query.getOrDefault("api-version")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "api-version", valid_594192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594193: Call_VirtualWansGet_594186; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a VirtualWAN.
  ## 
  let valid = call_594193.validator(path, query, header, formData, body)
  let scheme = call_594193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594193.url(scheme.get, call_594193.host, call_594193.base,
                         call_594193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594193, url, valid)

proc call*(call_594194: Call_VirtualWansGet_594186; resourceGroupName: string;
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
  var path_594195 = newJObject()
  var query_594196 = newJObject()
  add(path_594195, "resourceGroupName", newJString(resourceGroupName))
  add(path_594195, "VirtualWANName", newJString(VirtualWANName))
  add(query_594196, "api-version", newJString(apiVersion))
  add(path_594195, "subscriptionId", newJString(subscriptionId))
  result = call_594194.call(path_594195, query_594196, nil, nil, nil)

var virtualWansGet* = Call_VirtualWansGet_594186(name: "virtualWansGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{VirtualWANName}",
    validator: validate_VirtualWansGet_594187, base: "", url: url_VirtualWansGet_594188,
    schemes: {Scheme.Https})
type
  Call_VirtualWansUpdateTags_594221 = ref object of OpenApiRestCall_593437
proc url_VirtualWansUpdateTags_594223(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualWansUpdateTags_594222(path: JsonNode; query: JsonNode;
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
  var valid_594224 = path.getOrDefault("resourceGroupName")
  valid_594224 = validateParameter(valid_594224, JString, required = true,
                                 default = nil)
  if valid_594224 != nil:
    section.add "resourceGroupName", valid_594224
  var valid_594225 = path.getOrDefault("VirtualWANName")
  valid_594225 = validateParameter(valid_594225, JString, required = true,
                                 default = nil)
  if valid_594225 != nil:
    section.add "VirtualWANName", valid_594225
  var valid_594226 = path.getOrDefault("subscriptionId")
  valid_594226 = validateParameter(valid_594226, JString, required = true,
                                 default = nil)
  if valid_594226 != nil:
    section.add "subscriptionId", valid_594226
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594227 = query.getOrDefault("api-version")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "api-version", valid_594227
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

proc call*(call_594229: Call_VirtualWansUpdateTags_594221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a VirtualWAN tags.
  ## 
  let valid = call_594229.validator(path, query, header, formData, body)
  let scheme = call_594229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594229.url(scheme.get, call_594229.host, call_594229.base,
                         call_594229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594229, url, valid)

proc call*(call_594230: Call_VirtualWansUpdateTags_594221;
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
  var path_594231 = newJObject()
  var query_594232 = newJObject()
  var body_594233 = newJObject()
  add(path_594231, "resourceGroupName", newJString(resourceGroupName))
  add(path_594231, "VirtualWANName", newJString(VirtualWANName))
  add(query_594232, "api-version", newJString(apiVersion))
  add(path_594231, "subscriptionId", newJString(subscriptionId))
  if WANParameters != nil:
    body_594233 = WANParameters
  result = call_594230.call(path_594231, query_594232, nil, nil, body_594233)

var virtualWansUpdateTags* = Call_VirtualWansUpdateTags_594221(
    name: "virtualWansUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{VirtualWANName}",
    validator: validate_VirtualWansUpdateTags_594222, base: "",
    url: url_VirtualWansUpdateTags_594223, schemes: {Scheme.Https})
type
  Call_VirtualWansDelete_594210 = ref object of OpenApiRestCall_593437
proc url_VirtualWansDelete_594212(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualWansDelete_594211(path: JsonNode; query: JsonNode;
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
  var valid_594213 = path.getOrDefault("resourceGroupName")
  valid_594213 = validateParameter(valid_594213, JString, required = true,
                                 default = nil)
  if valid_594213 != nil:
    section.add "resourceGroupName", valid_594213
  var valid_594214 = path.getOrDefault("VirtualWANName")
  valid_594214 = validateParameter(valid_594214, JString, required = true,
                                 default = nil)
  if valid_594214 != nil:
    section.add "VirtualWANName", valid_594214
  var valid_594215 = path.getOrDefault("subscriptionId")
  valid_594215 = validateParameter(valid_594215, JString, required = true,
                                 default = nil)
  if valid_594215 != nil:
    section.add "subscriptionId", valid_594215
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594216 = query.getOrDefault("api-version")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "api-version", valid_594216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594217: Call_VirtualWansDelete_594210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a VirtualWAN.
  ## 
  let valid = call_594217.validator(path, query, header, formData, body)
  let scheme = call_594217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594217.url(scheme.get, call_594217.host, call_594217.base,
                         call_594217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594217, url, valid)

proc call*(call_594218: Call_VirtualWansDelete_594210; resourceGroupName: string;
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
  var path_594219 = newJObject()
  var query_594220 = newJObject()
  add(path_594219, "resourceGroupName", newJString(resourceGroupName))
  add(path_594219, "VirtualWANName", newJString(VirtualWANName))
  add(query_594220, "api-version", newJString(apiVersion))
  add(path_594219, "subscriptionId", newJString(subscriptionId))
  result = call_594218.call(path_594219, query_594220, nil, nil, nil)

var virtualWansDelete* = Call_VirtualWansDelete_594210(name: "virtualWansDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{VirtualWANName}",
    validator: validate_VirtualWansDelete_594211, base: "",
    url: url_VirtualWansDelete_594212, schemes: {Scheme.Https})
type
  Call_SupportedSecurityProviders_594234 = ref object of OpenApiRestCall_593437
proc url_SupportedSecurityProviders_594236(protocol: Scheme; host: string;
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

proc validate_SupportedSecurityProviders_594235(path: JsonNode; query: JsonNode;
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
  var valid_594237 = path.getOrDefault("resourceGroupName")
  valid_594237 = validateParameter(valid_594237, JString, required = true,
                                 default = nil)
  if valid_594237 != nil:
    section.add "resourceGroupName", valid_594237
  var valid_594238 = path.getOrDefault("subscriptionId")
  valid_594238 = validateParameter(valid_594238, JString, required = true,
                                 default = nil)
  if valid_594238 != nil:
    section.add "subscriptionId", valid_594238
  var valid_594239 = path.getOrDefault("virtualWANName")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "virtualWANName", valid_594239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594240 = query.getOrDefault("api-version")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "api-version", valid_594240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594241: Call_SupportedSecurityProviders_594234; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gives the supported security providers for the virtual wan.
  ## 
  let valid = call_594241.validator(path, query, header, formData, body)
  let scheme = call_594241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594241.url(scheme.get, call_594241.host, call_594241.base,
                         call_594241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594241, url, valid)

proc call*(call_594242: Call_SupportedSecurityProviders_594234;
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
  var path_594243 = newJObject()
  var query_594244 = newJObject()
  add(path_594243, "resourceGroupName", newJString(resourceGroupName))
  add(query_594244, "api-version", newJString(apiVersion))
  add(path_594243, "subscriptionId", newJString(subscriptionId))
  add(path_594243, "virtualWANName", newJString(virtualWANName))
  result = call_594242.call(path_594243, query_594244, nil, nil, nil)

var supportedSecurityProviders* = Call_SupportedSecurityProviders_594234(
    name: "supportedSecurityProviders", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{virtualWANName}/supportedSecurityProviders",
    validator: validate_SupportedSecurityProviders_594235, base: "",
    url: url_SupportedSecurityProviders_594236, schemes: {Scheme.Https})
type
  Call_VpnSitesConfigurationDownload_594245 = ref object of OpenApiRestCall_593437
proc url_VpnSitesConfigurationDownload_594247(protocol: Scheme; host: string;
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

proc validate_VpnSitesConfigurationDownload_594246(path: JsonNode; query: JsonNode;
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
  var valid_594248 = path.getOrDefault("resourceGroupName")
  valid_594248 = validateParameter(valid_594248, JString, required = true,
                                 default = nil)
  if valid_594248 != nil:
    section.add "resourceGroupName", valid_594248
  var valid_594249 = path.getOrDefault("subscriptionId")
  valid_594249 = validateParameter(valid_594249, JString, required = true,
                                 default = nil)
  if valid_594249 != nil:
    section.add "subscriptionId", valid_594249
  var valid_594250 = path.getOrDefault("virtualWANName")
  valid_594250 = validateParameter(valid_594250, JString, required = true,
                                 default = nil)
  if valid_594250 != nil:
    section.add "virtualWANName", valid_594250
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594251 = query.getOrDefault("api-version")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = nil)
  if valid_594251 != nil:
    section.add "api-version", valid_594251
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

proc call*(call_594253: Call_VpnSitesConfigurationDownload_594245; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gives the sas-url to download the configurations for vpn-sites in a resource group.
  ## 
  let valid = call_594253.validator(path, query, header, formData, body)
  let scheme = call_594253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594253.url(scheme.get, call_594253.host, call_594253.base,
                         call_594253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594253, url, valid)

proc call*(call_594254: Call_VpnSitesConfigurationDownload_594245;
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
  var path_594255 = newJObject()
  var query_594256 = newJObject()
  var body_594257 = newJObject()
  add(path_594255, "resourceGroupName", newJString(resourceGroupName))
  add(query_594256, "api-version", newJString(apiVersion))
  add(path_594255, "subscriptionId", newJString(subscriptionId))
  if request != nil:
    body_594257 = request
  add(path_594255, "virtualWANName", newJString(virtualWANName))
  result = call_594254.call(path_594255, query_594256, nil, nil, body_594257)

var vpnSitesConfigurationDownload* = Call_VpnSitesConfigurationDownload_594245(
    name: "vpnSitesConfigurationDownload", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{virtualWANName}/vpnConfiguration",
    validator: validate_VpnSitesConfigurationDownload_594246, base: "",
    url: url_VpnSitesConfigurationDownload_594247, schemes: {Scheme.Https})
type
  Call_P2sVpnServerConfigurationsListByVirtualWan_594258 = ref object of OpenApiRestCall_593437
proc url_P2sVpnServerConfigurationsListByVirtualWan_594260(protocol: Scheme;
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

proc validate_P2sVpnServerConfigurationsListByVirtualWan_594259(path: JsonNode;
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
  var valid_594261 = path.getOrDefault("resourceGroupName")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = nil)
  if valid_594261 != nil:
    section.add "resourceGroupName", valid_594261
  var valid_594262 = path.getOrDefault("virtualWanName")
  valid_594262 = validateParameter(valid_594262, JString, required = true,
                                 default = nil)
  if valid_594262 != nil:
    section.add "virtualWanName", valid_594262
  var valid_594263 = path.getOrDefault("subscriptionId")
  valid_594263 = validateParameter(valid_594263, JString, required = true,
                                 default = nil)
  if valid_594263 != nil:
    section.add "subscriptionId", valid_594263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594264 = query.getOrDefault("api-version")
  valid_594264 = validateParameter(valid_594264, JString, required = true,
                                 default = nil)
  if valid_594264 != nil:
    section.add "api-version", valid_594264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594265: Call_P2sVpnServerConfigurationsListByVirtualWan_594258;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all P2SVpnServerConfigurations for a particular VirtualWan.
  ## 
  let valid = call_594265.validator(path, query, header, formData, body)
  let scheme = call_594265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594265.url(scheme.get, call_594265.host, call_594265.base,
                         call_594265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594265, url, valid)

proc call*(call_594266: Call_P2sVpnServerConfigurationsListByVirtualWan_594258;
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
  var path_594267 = newJObject()
  var query_594268 = newJObject()
  add(path_594267, "resourceGroupName", newJString(resourceGroupName))
  add(query_594268, "api-version", newJString(apiVersion))
  add(path_594267, "virtualWanName", newJString(virtualWanName))
  add(path_594267, "subscriptionId", newJString(subscriptionId))
  result = call_594266.call(path_594267, query_594268, nil, nil, nil)

var p2sVpnServerConfigurationsListByVirtualWan* = Call_P2sVpnServerConfigurationsListByVirtualWan_594258(
    name: "p2sVpnServerConfigurationsListByVirtualWan", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{virtualWanName}/p2sVpnServerConfigurations",
    validator: validate_P2sVpnServerConfigurationsListByVirtualWan_594259,
    base: "", url: url_P2sVpnServerConfigurationsListByVirtualWan_594260,
    schemes: {Scheme.Https})
type
  Call_P2sVpnServerConfigurationsCreateOrUpdate_594281 = ref object of OpenApiRestCall_593437
proc url_P2sVpnServerConfigurationsCreateOrUpdate_594283(protocol: Scheme;
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

proc validate_P2sVpnServerConfigurationsCreateOrUpdate_594282(path: JsonNode;
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
  var valid_594284 = path.getOrDefault("resourceGroupName")
  valid_594284 = validateParameter(valid_594284, JString, required = true,
                                 default = nil)
  if valid_594284 != nil:
    section.add "resourceGroupName", valid_594284
  var valid_594285 = path.getOrDefault("virtualWanName")
  valid_594285 = validateParameter(valid_594285, JString, required = true,
                                 default = nil)
  if valid_594285 != nil:
    section.add "virtualWanName", valid_594285
  var valid_594286 = path.getOrDefault("p2SVpnServerConfigurationName")
  valid_594286 = validateParameter(valid_594286, JString, required = true,
                                 default = nil)
  if valid_594286 != nil:
    section.add "p2SVpnServerConfigurationName", valid_594286
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
  ##   p2SVpnServerConfigurationParameters: JObject (required)
  ##                                      : Parameters supplied to create or Update a P2SVpnServerConfiguration.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594290: Call_P2sVpnServerConfigurationsCreateOrUpdate_594281;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a P2SVpnServerConfiguration to associate with a VirtualWan if it doesn't exist else updates the existing P2SVpnServerConfiguration.
  ## 
  let valid = call_594290.validator(path, query, header, formData, body)
  let scheme = call_594290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594290.url(scheme.get, call_594290.host, call_594290.base,
                         call_594290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594290, url, valid)

proc call*(call_594291: Call_P2sVpnServerConfigurationsCreateOrUpdate_594281;
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
  var path_594292 = newJObject()
  var query_594293 = newJObject()
  var body_594294 = newJObject()
  add(path_594292, "resourceGroupName", newJString(resourceGroupName))
  add(query_594293, "api-version", newJString(apiVersion))
  add(path_594292, "virtualWanName", newJString(virtualWanName))
  add(path_594292, "p2SVpnServerConfigurationName",
      newJString(p2SVpnServerConfigurationName))
  add(path_594292, "subscriptionId", newJString(subscriptionId))
  if p2SVpnServerConfigurationParameters != nil:
    body_594294 = p2SVpnServerConfigurationParameters
  result = call_594291.call(path_594292, query_594293, nil, nil, body_594294)

var p2sVpnServerConfigurationsCreateOrUpdate* = Call_P2sVpnServerConfigurationsCreateOrUpdate_594281(
    name: "p2sVpnServerConfigurationsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{virtualWanName}/p2sVpnServerConfigurations/{p2SVpnServerConfigurationName}",
    validator: validate_P2sVpnServerConfigurationsCreateOrUpdate_594282, base: "",
    url: url_P2sVpnServerConfigurationsCreateOrUpdate_594283,
    schemes: {Scheme.Https})
type
  Call_P2sVpnServerConfigurationsGet_594269 = ref object of OpenApiRestCall_593437
proc url_P2sVpnServerConfigurationsGet_594271(protocol: Scheme; host: string;
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

proc validate_P2sVpnServerConfigurationsGet_594270(path: JsonNode; query: JsonNode;
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
  var valid_594272 = path.getOrDefault("resourceGroupName")
  valid_594272 = validateParameter(valid_594272, JString, required = true,
                                 default = nil)
  if valid_594272 != nil:
    section.add "resourceGroupName", valid_594272
  var valid_594273 = path.getOrDefault("virtualWanName")
  valid_594273 = validateParameter(valid_594273, JString, required = true,
                                 default = nil)
  if valid_594273 != nil:
    section.add "virtualWanName", valid_594273
  var valid_594274 = path.getOrDefault("p2SVpnServerConfigurationName")
  valid_594274 = validateParameter(valid_594274, JString, required = true,
                                 default = nil)
  if valid_594274 != nil:
    section.add "p2SVpnServerConfigurationName", valid_594274
  var valid_594275 = path.getOrDefault("subscriptionId")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "subscriptionId", valid_594275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594276 = query.getOrDefault("api-version")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "api-version", valid_594276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594277: Call_P2sVpnServerConfigurationsGet_594269; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a P2SVpnServerConfiguration.
  ## 
  let valid = call_594277.validator(path, query, header, formData, body)
  let scheme = call_594277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594277.url(scheme.get, call_594277.host, call_594277.base,
                         call_594277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594277, url, valid)

proc call*(call_594278: Call_P2sVpnServerConfigurationsGet_594269;
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
  var path_594279 = newJObject()
  var query_594280 = newJObject()
  add(path_594279, "resourceGroupName", newJString(resourceGroupName))
  add(query_594280, "api-version", newJString(apiVersion))
  add(path_594279, "virtualWanName", newJString(virtualWanName))
  add(path_594279, "p2SVpnServerConfigurationName",
      newJString(p2SVpnServerConfigurationName))
  add(path_594279, "subscriptionId", newJString(subscriptionId))
  result = call_594278.call(path_594279, query_594280, nil, nil, nil)

var p2sVpnServerConfigurationsGet* = Call_P2sVpnServerConfigurationsGet_594269(
    name: "p2sVpnServerConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{virtualWanName}/p2sVpnServerConfigurations/{p2SVpnServerConfigurationName}",
    validator: validate_P2sVpnServerConfigurationsGet_594270, base: "",
    url: url_P2sVpnServerConfigurationsGet_594271, schemes: {Scheme.Https})
type
  Call_P2sVpnServerConfigurationsDelete_594295 = ref object of OpenApiRestCall_593437
proc url_P2sVpnServerConfigurationsDelete_594297(protocol: Scheme; host: string;
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

proc validate_P2sVpnServerConfigurationsDelete_594296(path: JsonNode;
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
  var valid_594298 = path.getOrDefault("resourceGroupName")
  valid_594298 = validateParameter(valid_594298, JString, required = true,
                                 default = nil)
  if valid_594298 != nil:
    section.add "resourceGroupName", valid_594298
  var valid_594299 = path.getOrDefault("virtualWanName")
  valid_594299 = validateParameter(valid_594299, JString, required = true,
                                 default = nil)
  if valid_594299 != nil:
    section.add "virtualWanName", valid_594299
  var valid_594300 = path.getOrDefault("p2SVpnServerConfigurationName")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "p2SVpnServerConfigurationName", valid_594300
  var valid_594301 = path.getOrDefault("subscriptionId")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "subscriptionId", valid_594301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594302 = query.getOrDefault("api-version")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "api-version", valid_594302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594303: Call_P2sVpnServerConfigurationsDelete_594295;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a P2SVpnServerConfiguration.
  ## 
  let valid = call_594303.validator(path, query, header, formData, body)
  let scheme = call_594303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594303.url(scheme.get, call_594303.host, call_594303.base,
                         call_594303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594303, url, valid)

proc call*(call_594304: Call_P2sVpnServerConfigurationsDelete_594295;
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
  var path_594305 = newJObject()
  var query_594306 = newJObject()
  add(path_594305, "resourceGroupName", newJString(resourceGroupName))
  add(query_594306, "api-version", newJString(apiVersion))
  add(path_594305, "virtualWanName", newJString(virtualWanName))
  add(path_594305, "p2SVpnServerConfigurationName",
      newJString(p2SVpnServerConfigurationName))
  add(path_594305, "subscriptionId", newJString(subscriptionId))
  result = call_594304.call(path_594305, query_594306, nil, nil, nil)

var p2sVpnServerConfigurationsDelete* = Call_P2sVpnServerConfigurationsDelete_594295(
    name: "p2sVpnServerConfigurationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{virtualWanName}/p2sVpnServerConfigurations/{p2SVpnServerConfigurationName}",
    validator: validate_P2sVpnServerConfigurationsDelete_594296, base: "",
    url: url_P2sVpnServerConfigurationsDelete_594297, schemes: {Scheme.Https})
type
  Call_VpnGatewaysListByResourceGroup_594307 = ref object of OpenApiRestCall_593437
proc url_VpnGatewaysListByResourceGroup_594309(protocol: Scheme; host: string;
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

proc validate_VpnGatewaysListByResourceGroup_594308(path: JsonNode;
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
  var valid_594310 = path.getOrDefault("resourceGroupName")
  valid_594310 = validateParameter(valid_594310, JString, required = true,
                                 default = nil)
  if valid_594310 != nil:
    section.add "resourceGroupName", valid_594310
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
  if body != nil:
    result.add "body", body

proc call*(call_594313: Call_VpnGatewaysListByResourceGroup_594307; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VpnGateways in a resource group.
  ## 
  let valid = call_594313.validator(path, query, header, formData, body)
  let scheme = call_594313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594313.url(scheme.get, call_594313.host, call_594313.base,
                         call_594313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594313, url, valid)

proc call*(call_594314: Call_VpnGatewaysListByResourceGroup_594307;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## vpnGatewaysListByResourceGroup
  ## Lists all the VpnGateways in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnGateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594315 = newJObject()
  var query_594316 = newJObject()
  add(path_594315, "resourceGroupName", newJString(resourceGroupName))
  add(query_594316, "api-version", newJString(apiVersion))
  add(path_594315, "subscriptionId", newJString(subscriptionId))
  result = call_594314.call(path_594315, query_594316, nil, nil, nil)

var vpnGatewaysListByResourceGroup* = Call_VpnGatewaysListByResourceGroup_594307(
    name: "vpnGatewaysListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways",
    validator: validate_VpnGatewaysListByResourceGroup_594308, base: "",
    url: url_VpnGatewaysListByResourceGroup_594309, schemes: {Scheme.Https})
type
  Call_VpnGatewaysCreateOrUpdate_594328 = ref object of OpenApiRestCall_593437
proc url_VpnGatewaysCreateOrUpdate_594330(protocol: Scheme; host: string;
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

proc validate_VpnGatewaysCreateOrUpdate_594329(path: JsonNode; query: JsonNode;
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
  var valid_594331 = path.getOrDefault("resourceGroupName")
  valid_594331 = validateParameter(valid_594331, JString, required = true,
                                 default = nil)
  if valid_594331 != nil:
    section.add "resourceGroupName", valid_594331
  var valid_594332 = path.getOrDefault("gatewayName")
  valid_594332 = validateParameter(valid_594332, JString, required = true,
                                 default = nil)
  if valid_594332 != nil:
    section.add "gatewayName", valid_594332
  var valid_594333 = path.getOrDefault("subscriptionId")
  valid_594333 = validateParameter(valid_594333, JString, required = true,
                                 default = nil)
  if valid_594333 != nil:
    section.add "subscriptionId", valid_594333
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594334 = query.getOrDefault("api-version")
  valid_594334 = validateParameter(valid_594334, JString, required = true,
                                 default = nil)
  if valid_594334 != nil:
    section.add "api-version", valid_594334
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

proc call*(call_594336: Call_VpnGatewaysCreateOrUpdate_594328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a virtual wan vpn gateway if it doesn't exist else updates the existing gateway.
  ## 
  let valid = call_594336.validator(path, query, header, formData, body)
  let scheme = call_594336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594336.url(scheme.get, call_594336.host, call_594336.base,
                         call_594336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594336, url, valid)

proc call*(call_594337: Call_VpnGatewaysCreateOrUpdate_594328;
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
  var path_594338 = newJObject()
  var query_594339 = newJObject()
  var body_594340 = newJObject()
  add(path_594338, "resourceGroupName", newJString(resourceGroupName))
  add(query_594339, "api-version", newJString(apiVersion))
  add(path_594338, "gatewayName", newJString(gatewayName))
  add(path_594338, "subscriptionId", newJString(subscriptionId))
  if vpnGatewayParameters != nil:
    body_594340 = vpnGatewayParameters
  result = call_594337.call(path_594338, query_594339, nil, nil, body_594340)

var vpnGatewaysCreateOrUpdate* = Call_VpnGatewaysCreateOrUpdate_594328(
    name: "vpnGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}",
    validator: validate_VpnGatewaysCreateOrUpdate_594329, base: "",
    url: url_VpnGatewaysCreateOrUpdate_594330, schemes: {Scheme.Https})
type
  Call_VpnGatewaysGet_594317 = ref object of OpenApiRestCall_593437
proc url_VpnGatewaysGet_594319(protocol: Scheme; host: string; base: string;
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

proc validate_VpnGatewaysGet_594318(path: JsonNode; query: JsonNode;
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
  var valid_594320 = path.getOrDefault("resourceGroupName")
  valid_594320 = validateParameter(valid_594320, JString, required = true,
                                 default = nil)
  if valid_594320 != nil:
    section.add "resourceGroupName", valid_594320
  var valid_594321 = path.getOrDefault("gatewayName")
  valid_594321 = validateParameter(valid_594321, JString, required = true,
                                 default = nil)
  if valid_594321 != nil:
    section.add "gatewayName", valid_594321
  var valid_594322 = path.getOrDefault("subscriptionId")
  valid_594322 = validateParameter(valid_594322, JString, required = true,
                                 default = nil)
  if valid_594322 != nil:
    section.add "subscriptionId", valid_594322
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594323 = query.getOrDefault("api-version")
  valid_594323 = validateParameter(valid_594323, JString, required = true,
                                 default = nil)
  if valid_594323 != nil:
    section.add "api-version", valid_594323
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594324: Call_VpnGatewaysGet_594317; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a virtual wan vpn gateway.
  ## 
  let valid = call_594324.validator(path, query, header, formData, body)
  let scheme = call_594324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594324.url(scheme.get, call_594324.host, call_594324.base,
                         call_594324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594324, url, valid)

proc call*(call_594325: Call_VpnGatewaysGet_594317; resourceGroupName: string;
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
  var path_594326 = newJObject()
  var query_594327 = newJObject()
  add(path_594326, "resourceGroupName", newJString(resourceGroupName))
  add(query_594327, "api-version", newJString(apiVersion))
  add(path_594326, "gatewayName", newJString(gatewayName))
  add(path_594326, "subscriptionId", newJString(subscriptionId))
  result = call_594325.call(path_594326, query_594327, nil, nil, nil)

var vpnGatewaysGet* = Call_VpnGatewaysGet_594317(name: "vpnGatewaysGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}",
    validator: validate_VpnGatewaysGet_594318, base: "", url: url_VpnGatewaysGet_594319,
    schemes: {Scheme.Https})
type
  Call_VpnGatewaysUpdateTags_594352 = ref object of OpenApiRestCall_593437
proc url_VpnGatewaysUpdateTags_594354(protocol: Scheme; host: string; base: string;
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

proc validate_VpnGatewaysUpdateTags_594353(path: JsonNode; query: JsonNode;
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
  var valid_594355 = path.getOrDefault("resourceGroupName")
  valid_594355 = validateParameter(valid_594355, JString, required = true,
                                 default = nil)
  if valid_594355 != nil:
    section.add "resourceGroupName", valid_594355
  var valid_594356 = path.getOrDefault("gatewayName")
  valid_594356 = validateParameter(valid_594356, JString, required = true,
                                 default = nil)
  if valid_594356 != nil:
    section.add "gatewayName", valid_594356
  var valid_594357 = path.getOrDefault("subscriptionId")
  valid_594357 = validateParameter(valid_594357, JString, required = true,
                                 default = nil)
  if valid_594357 != nil:
    section.add "subscriptionId", valid_594357
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594358 = query.getOrDefault("api-version")
  valid_594358 = validateParameter(valid_594358, JString, required = true,
                                 default = nil)
  if valid_594358 != nil:
    section.add "api-version", valid_594358
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

proc call*(call_594360: Call_VpnGatewaysUpdateTags_594352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates virtual wan vpn gateway tags.
  ## 
  let valid = call_594360.validator(path, query, header, formData, body)
  let scheme = call_594360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594360.url(scheme.get, call_594360.host, call_594360.base,
                         call_594360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594360, url, valid)

proc call*(call_594361: Call_VpnGatewaysUpdateTags_594352;
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
  var path_594362 = newJObject()
  var query_594363 = newJObject()
  var body_594364 = newJObject()
  add(path_594362, "resourceGroupName", newJString(resourceGroupName))
  add(query_594363, "api-version", newJString(apiVersion))
  add(path_594362, "gatewayName", newJString(gatewayName))
  add(path_594362, "subscriptionId", newJString(subscriptionId))
  if vpnGatewayParameters != nil:
    body_594364 = vpnGatewayParameters
  result = call_594361.call(path_594362, query_594363, nil, nil, body_594364)

var vpnGatewaysUpdateTags* = Call_VpnGatewaysUpdateTags_594352(
    name: "vpnGatewaysUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}",
    validator: validate_VpnGatewaysUpdateTags_594353, base: "",
    url: url_VpnGatewaysUpdateTags_594354, schemes: {Scheme.Https})
type
  Call_VpnGatewaysDelete_594341 = ref object of OpenApiRestCall_593437
proc url_VpnGatewaysDelete_594343(protocol: Scheme; host: string; base: string;
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

proc validate_VpnGatewaysDelete_594342(path: JsonNode; query: JsonNode;
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
  var valid_594344 = path.getOrDefault("resourceGroupName")
  valid_594344 = validateParameter(valid_594344, JString, required = true,
                                 default = nil)
  if valid_594344 != nil:
    section.add "resourceGroupName", valid_594344
  var valid_594345 = path.getOrDefault("gatewayName")
  valid_594345 = validateParameter(valid_594345, JString, required = true,
                                 default = nil)
  if valid_594345 != nil:
    section.add "gatewayName", valid_594345
  var valid_594346 = path.getOrDefault("subscriptionId")
  valid_594346 = validateParameter(valid_594346, JString, required = true,
                                 default = nil)
  if valid_594346 != nil:
    section.add "subscriptionId", valid_594346
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594347 = query.getOrDefault("api-version")
  valid_594347 = validateParameter(valid_594347, JString, required = true,
                                 default = nil)
  if valid_594347 != nil:
    section.add "api-version", valid_594347
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594348: Call_VpnGatewaysDelete_594341; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a virtual wan vpn gateway.
  ## 
  let valid = call_594348.validator(path, query, header, formData, body)
  let scheme = call_594348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594348.url(scheme.get, call_594348.host, call_594348.base,
                         call_594348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594348, url, valid)

proc call*(call_594349: Call_VpnGatewaysDelete_594341; resourceGroupName: string;
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
  var path_594350 = newJObject()
  var query_594351 = newJObject()
  add(path_594350, "resourceGroupName", newJString(resourceGroupName))
  add(query_594351, "api-version", newJString(apiVersion))
  add(path_594350, "gatewayName", newJString(gatewayName))
  add(path_594350, "subscriptionId", newJString(subscriptionId))
  result = call_594349.call(path_594350, query_594351, nil, nil, nil)

var vpnGatewaysDelete* = Call_VpnGatewaysDelete_594341(name: "vpnGatewaysDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}",
    validator: validate_VpnGatewaysDelete_594342, base: "",
    url: url_VpnGatewaysDelete_594343, schemes: {Scheme.Https})
type
  Call_VpnConnectionsListByVpnGateway_594365 = ref object of OpenApiRestCall_593437
proc url_VpnConnectionsListByVpnGateway_594367(protocol: Scheme; host: string;
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

proc validate_VpnConnectionsListByVpnGateway_594366(path: JsonNode;
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
  var valid_594368 = path.getOrDefault("resourceGroupName")
  valid_594368 = validateParameter(valid_594368, JString, required = true,
                                 default = nil)
  if valid_594368 != nil:
    section.add "resourceGroupName", valid_594368
  var valid_594369 = path.getOrDefault("gatewayName")
  valid_594369 = validateParameter(valid_594369, JString, required = true,
                                 default = nil)
  if valid_594369 != nil:
    section.add "gatewayName", valid_594369
  var valid_594370 = path.getOrDefault("subscriptionId")
  valid_594370 = validateParameter(valid_594370, JString, required = true,
                                 default = nil)
  if valid_594370 != nil:
    section.add "subscriptionId", valid_594370
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594371 = query.getOrDefault("api-version")
  valid_594371 = validateParameter(valid_594371, JString, required = true,
                                 default = nil)
  if valid_594371 != nil:
    section.add "api-version", valid_594371
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594372: Call_VpnConnectionsListByVpnGateway_594365; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all vpn connections for a particular virtual wan vpn gateway.
  ## 
  let valid = call_594372.validator(path, query, header, formData, body)
  let scheme = call_594372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594372.url(scheme.get, call_594372.host, call_594372.base,
                         call_594372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594372, url, valid)

proc call*(call_594373: Call_VpnConnectionsListByVpnGateway_594365;
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
  var path_594374 = newJObject()
  var query_594375 = newJObject()
  add(path_594374, "resourceGroupName", newJString(resourceGroupName))
  add(query_594375, "api-version", newJString(apiVersion))
  add(path_594374, "gatewayName", newJString(gatewayName))
  add(path_594374, "subscriptionId", newJString(subscriptionId))
  result = call_594373.call(path_594374, query_594375, nil, nil, nil)

var vpnConnectionsListByVpnGateway* = Call_VpnConnectionsListByVpnGateway_594365(
    name: "vpnConnectionsListByVpnGateway", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections",
    validator: validate_VpnConnectionsListByVpnGateway_594366, base: "",
    url: url_VpnConnectionsListByVpnGateway_594367, schemes: {Scheme.Https})
type
  Call_VpnConnectionsCreateOrUpdate_594388 = ref object of OpenApiRestCall_593437
proc url_VpnConnectionsCreateOrUpdate_594390(protocol: Scheme; host: string;
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

proc validate_VpnConnectionsCreateOrUpdate_594389(path: JsonNode; query: JsonNode;
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
  var valid_594391 = path.getOrDefault("resourceGroupName")
  valid_594391 = validateParameter(valid_594391, JString, required = true,
                                 default = nil)
  if valid_594391 != nil:
    section.add "resourceGroupName", valid_594391
  var valid_594392 = path.getOrDefault("gatewayName")
  valid_594392 = validateParameter(valid_594392, JString, required = true,
                                 default = nil)
  if valid_594392 != nil:
    section.add "gatewayName", valid_594392
  var valid_594393 = path.getOrDefault("subscriptionId")
  valid_594393 = validateParameter(valid_594393, JString, required = true,
                                 default = nil)
  if valid_594393 != nil:
    section.add "subscriptionId", valid_594393
  var valid_594394 = path.getOrDefault("connectionName")
  valid_594394 = validateParameter(valid_594394, JString, required = true,
                                 default = nil)
  if valid_594394 != nil:
    section.add "connectionName", valid_594394
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594395 = query.getOrDefault("api-version")
  valid_594395 = validateParameter(valid_594395, JString, required = true,
                                 default = nil)
  if valid_594395 != nil:
    section.add "api-version", valid_594395
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

proc call*(call_594397: Call_VpnConnectionsCreateOrUpdate_594388; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a vpn connection to a scalable vpn gateway if it doesn't exist else updates the existing connection.
  ## 
  let valid = call_594397.validator(path, query, header, formData, body)
  let scheme = call_594397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594397.url(scheme.get, call_594397.host, call_594397.base,
                         call_594397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594397, url, valid)

proc call*(call_594398: Call_VpnConnectionsCreateOrUpdate_594388;
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
  var path_594399 = newJObject()
  var query_594400 = newJObject()
  var body_594401 = newJObject()
  add(path_594399, "resourceGroupName", newJString(resourceGroupName))
  add(query_594400, "api-version", newJString(apiVersion))
  add(path_594399, "gatewayName", newJString(gatewayName))
  add(path_594399, "subscriptionId", newJString(subscriptionId))
  if VpnConnectionParameters != nil:
    body_594401 = VpnConnectionParameters
  add(path_594399, "connectionName", newJString(connectionName))
  result = call_594398.call(path_594399, query_594400, nil, nil, body_594401)

var vpnConnectionsCreateOrUpdate* = Call_VpnConnectionsCreateOrUpdate_594388(
    name: "vpnConnectionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections/{connectionName}",
    validator: validate_VpnConnectionsCreateOrUpdate_594389, base: "",
    url: url_VpnConnectionsCreateOrUpdate_594390, schemes: {Scheme.Https})
type
  Call_VpnConnectionsGet_594376 = ref object of OpenApiRestCall_593437
proc url_VpnConnectionsGet_594378(protocol: Scheme; host: string; base: string;
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

proc validate_VpnConnectionsGet_594377(path: JsonNode; query: JsonNode;
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
  var valid_594379 = path.getOrDefault("resourceGroupName")
  valid_594379 = validateParameter(valid_594379, JString, required = true,
                                 default = nil)
  if valid_594379 != nil:
    section.add "resourceGroupName", valid_594379
  var valid_594380 = path.getOrDefault("gatewayName")
  valid_594380 = validateParameter(valid_594380, JString, required = true,
                                 default = nil)
  if valid_594380 != nil:
    section.add "gatewayName", valid_594380
  var valid_594381 = path.getOrDefault("subscriptionId")
  valid_594381 = validateParameter(valid_594381, JString, required = true,
                                 default = nil)
  if valid_594381 != nil:
    section.add "subscriptionId", valid_594381
  var valid_594382 = path.getOrDefault("connectionName")
  valid_594382 = validateParameter(valid_594382, JString, required = true,
                                 default = nil)
  if valid_594382 != nil:
    section.add "connectionName", valid_594382
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594383 = query.getOrDefault("api-version")
  valid_594383 = validateParameter(valid_594383, JString, required = true,
                                 default = nil)
  if valid_594383 != nil:
    section.add "api-version", valid_594383
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594384: Call_VpnConnectionsGet_594376; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a vpn connection.
  ## 
  let valid = call_594384.validator(path, query, header, formData, body)
  let scheme = call_594384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594384.url(scheme.get, call_594384.host, call_594384.base,
                         call_594384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594384, url, valid)

proc call*(call_594385: Call_VpnConnectionsGet_594376; resourceGroupName: string;
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
  var path_594386 = newJObject()
  var query_594387 = newJObject()
  add(path_594386, "resourceGroupName", newJString(resourceGroupName))
  add(query_594387, "api-version", newJString(apiVersion))
  add(path_594386, "gatewayName", newJString(gatewayName))
  add(path_594386, "subscriptionId", newJString(subscriptionId))
  add(path_594386, "connectionName", newJString(connectionName))
  result = call_594385.call(path_594386, query_594387, nil, nil, nil)

var vpnConnectionsGet* = Call_VpnConnectionsGet_594376(name: "vpnConnectionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections/{connectionName}",
    validator: validate_VpnConnectionsGet_594377, base: "",
    url: url_VpnConnectionsGet_594378, schemes: {Scheme.Https})
type
  Call_VpnConnectionsDelete_594402 = ref object of OpenApiRestCall_593437
proc url_VpnConnectionsDelete_594404(protocol: Scheme; host: string; base: string;
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

proc validate_VpnConnectionsDelete_594403(path: JsonNode; query: JsonNode;
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
  var valid_594405 = path.getOrDefault("resourceGroupName")
  valid_594405 = validateParameter(valid_594405, JString, required = true,
                                 default = nil)
  if valid_594405 != nil:
    section.add "resourceGroupName", valid_594405
  var valid_594406 = path.getOrDefault("gatewayName")
  valid_594406 = validateParameter(valid_594406, JString, required = true,
                                 default = nil)
  if valid_594406 != nil:
    section.add "gatewayName", valid_594406
  var valid_594407 = path.getOrDefault("subscriptionId")
  valid_594407 = validateParameter(valid_594407, JString, required = true,
                                 default = nil)
  if valid_594407 != nil:
    section.add "subscriptionId", valid_594407
  var valid_594408 = path.getOrDefault("connectionName")
  valid_594408 = validateParameter(valid_594408, JString, required = true,
                                 default = nil)
  if valid_594408 != nil:
    section.add "connectionName", valid_594408
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594409 = query.getOrDefault("api-version")
  valid_594409 = validateParameter(valid_594409, JString, required = true,
                                 default = nil)
  if valid_594409 != nil:
    section.add "api-version", valid_594409
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594410: Call_VpnConnectionsDelete_594402; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a vpn connection.
  ## 
  let valid = call_594410.validator(path, query, header, formData, body)
  let scheme = call_594410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594410.url(scheme.get, call_594410.host, call_594410.base,
                         call_594410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594410, url, valid)

proc call*(call_594411: Call_VpnConnectionsDelete_594402;
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
  var path_594412 = newJObject()
  var query_594413 = newJObject()
  add(path_594412, "resourceGroupName", newJString(resourceGroupName))
  add(query_594413, "api-version", newJString(apiVersion))
  add(path_594412, "gatewayName", newJString(gatewayName))
  add(path_594412, "subscriptionId", newJString(subscriptionId))
  add(path_594412, "connectionName", newJString(connectionName))
  result = call_594411.call(path_594412, query_594413, nil, nil, nil)

var vpnConnectionsDelete* = Call_VpnConnectionsDelete_594402(
    name: "vpnConnectionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections/{connectionName}",
    validator: validate_VpnConnectionsDelete_594403, base: "",
    url: url_VpnConnectionsDelete_594404, schemes: {Scheme.Https})
type
  Call_VpnSitesListByResourceGroup_594414 = ref object of OpenApiRestCall_593437
proc url_VpnSitesListByResourceGroup_594416(protocol: Scheme; host: string;
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

proc validate_VpnSitesListByResourceGroup_594415(path: JsonNode; query: JsonNode;
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
  var valid_594417 = path.getOrDefault("resourceGroupName")
  valid_594417 = validateParameter(valid_594417, JString, required = true,
                                 default = nil)
  if valid_594417 != nil:
    section.add "resourceGroupName", valid_594417
  var valid_594418 = path.getOrDefault("subscriptionId")
  valid_594418 = validateParameter(valid_594418, JString, required = true,
                                 default = nil)
  if valid_594418 != nil:
    section.add "subscriptionId", valid_594418
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594419 = query.getOrDefault("api-version")
  valid_594419 = validateParameter(valid_594419, JString, required = true,
                                 default = nil)
  if valid_594419 != nil:
    section.add "api-version", valid_594419
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594420: Call_VpnSitesListByResourceGroup_594414; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the vpnSites in a resource group.
  ## 
  let valid = call_594420.validator(path, query, header, formData, body)
  let scheme = call_594420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594420.url(scheme.get, call_594420.host, call_594420.base,
                         call_594420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594420, url, valid)

proc call*(call_594421: Call_VpnSitesListByResourceGroup_594414;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## vpnSitesListByResourceGroup
  ## Lists all the vpnSites in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnSite.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594422 = newJObject()
  var query_594423 = newJObject()
  add(path_594422, "resourceGroupName", newJString(resourceGroupName))
  add(query_594423, "api-version", newJString(apiVersion))
  add(path_594422, "subscriptionId", newJString(subscriptionId))
  result = call_594421.call(path_594422, query_594423, nil, nil, nil)

var vpnSitesListByResourceGroup* = Call_VpnSitesListByResourceGroup_594414(
    name: "vpnSitesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites",
    validator: validate_VpnSitesListByResourceGroup_594415, base: "",
    url: url_VpnSitesListByResourceGroup_594416, schemes: {Scheme.Https})
type
  Call_VpnSitesCreateOrUpdate_594435 = ref object of OpenApiRestCall_593437
proc url_VpnSitesCreateOrUpdate_594437(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSitesCreateOrUpdate_594436(path: JsonNode; query: JsonNode;
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
  var valid_594438 = path.getOrDefault("resourceGroupName")
  valid_594438 = validateParameter(valid_594438, JString, required = true,
                                 default = nil)
  if valid_594438 != nil:
    section.add "resourceGroupName", valid_594438
  var valid_594439 = path.getOrDefault("vpnSiteName")
  valid_594439 = validateParameter(valid_594439, JString, required = true,
                                 default = nil)
  if valid_594439 != nil:
    section.add "vpnSiteName", valid_594439
  var valid_594440 = path.getOrDefault("subscriptionId")
  valid_594440 = validateParameter(valid_594440, JString, required = true,
                                 default = nil)
  if valid_594440 != nil:
    section.add "subscriptionId", valid_594440
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594441 = query.getOrDefault("api-version")
  valid_594441 = validateParameter(valid_594441, JString, required = true,
                                 default = nil)
  if valid_594441 != nil:
    section.add "api-version", valid_594441
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

proc call*(call_594443: Call_VpnSitesCreateOrUpdate_594435; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a VpnSite resource if it doesn't exist else updates the existing VpnSite.
  ## 
  let valid = call_594443.validator(path, query, header, formData, body)
  let scheme = call_594443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594443.url(scheme.get, call_594443.host, call_594443.base,
                         call_594443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594443, url, valid)

proc call*(call_594444: Call_VpnSitesCreateOrUpdate_594435;
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
  var path_594445 = newJObject()
  var query_594446 = newJObject()
  var body_594447 = newJObject()
  add(path_594445, "resourceGroupName", newJString(resourceGroupName))
  add(query_594446, "api-version", newJString(apiVersion))
  add(path_594445, "vpnSiteName", newJString(vpnSiteName))
  add(path_594445, "subscriptionId", newJString(subscriptionId))
  if VpnSiteParameters != nil:
    body_594447 = VpnSiteParameters
  result = call_594444.call(path_594445, query_594446, nil, nil, body_594447)

var vpnSitesCreateOrUpdate* = Call_VpnSitesCreateOrUpdate_594435(
    name: "vpnSitesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}",
    validator: validate_VpnSitesCreateOrUpdate_594436, base: "",
    url: url_VpnSitesCreateOrUpdate_594437, schemes: {Scheme.Https})
type
  Call_VpnSitesGet_594424 = ref object of OpenApiRestCall_593437
proc url_VpnSitesGet_594426(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSitesGet_594425(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594427 = path.getOrDefault("resourceGroupName")
  valid_594427 = validateParameter(valid_594427, JString, required = true,
                                 default = nil)
  if valid_594427 != nil:
    section.add "resourceGroupName", valid_594427
  var valid_594428 = path.getOrDefault("vpnSiteName")
  valid_594428 = validateParameter(valid_594428, JString, required = true,
                                 default = nil)
  if valid_594428 != nil:
    section.add "vpnSiteName", valid_594428
  var valid_594429 = path.getOrDefault("subscriptionId")
  valid_594429 = validateParameter(valid_594429, JString, required = true,
                                 default = nil)
  if valid_594429 != nil:
    section.add "subscriptionId", valid_594429
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594430 = query.getOrDefault("api-version")
  valid_594430 = validateParameter(valid_594430, JString, required = true,
                                 default = nil)
  if valid_594430 != nil:
    section.add "api-version", valid_594430
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594431: Call_VpnSitesGet_594424; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a VPN site.
  ## 
  let valid = call_594431.validator(path, query, header, formData, body)
  let scheme = call_594431.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594431.url(scheme.get, call_594431.host, call_594431.base,
                         call_594431.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594431, url, valid)

proc call*(call_594432: Call_VpnSitesGet_594424; resourceGroupName: string;
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
  var path_594433 = newJObject()
  var query_594434 = newJObject()
  add(path_594433, "resourceGroupName", newJString(resourceGroupName))
  add(query_594434, "api-version", newJString(apiVersion))
  add(path_594433, "vpnSiteName", newJString(vpnSiteName))
  add(path_594433, "subscriptionId", newJString(subscriptionId))
  result = call_594432.call(path_594433, query_594434, nil, nil, nil)

var vpnSitesGet* = Call_VpnSitesGet_594424(name: "vpnSitesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}",
                                        validator: validate_VpnSitesGet_594425,
                                        base: "", url: url_VpnSitesGet_594426,
                                        schemes: {Scheme.Https})
type
  Call_VpnSitesUpdateTags_594459 = ref object of OpenApiRestCall_593437
proc url_VpnSitesUpdateTags_594461(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSitesUpdateTags_594460(path: JsonNode; query: JsonNode;
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
  var valid_594462 = path.getOrDefault("resourceGroupName")
  valid_594462 = validateParameter(valid_594462, JString, required = true,
                                 default = nil)
  if valid_594462 != nil:
    section.add "resourceGroupName", valid_594462
  var valid_594463 = path.getOrDefault("vpnSiteName")
  valid_594463 = validateParameter(valid_594463, JString, required = true,
                                 default = nil)
  if valid_594463 != nil:
    section.add "vpnSiteName", valid_594463
  var valid_594464 = path.getOrDefault("subscriptionId")
  valid_594464 = validateParameter(valid_594464, JString, required = true,
                                 default = nil)
  if valid_594464 != nil:
    section.add "subscriptionId", valid_594464
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594465 = query.getOrDefault("api-version")
  valid_594465 = validateParameter(valid_594465, JString, required = true,
                                 default = nil)
  if valid_594465 != nil:
    section.add "api-version", valid_594465
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

proc call*(call_594467: Call_VpnSitesUpdateTags_594459; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates VpnSite tags.
  ## 
  let valid = call_594467.validator(path, query, header, formData, body)
  let scheme = call_594467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594467.url(scheme.get, call_594467.host, call_594467.base,
                         call_594467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594467, url, valid)

proc call*(call_594468: Call_VpnSitesUpdateTags_594459; resourceGroupName: string;
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
  var path_594469 = newJObject()
  var query_594470 = newJObject()
  var body_594471 = newJObject()
  add(path_594469, "resourceGroupName", newJString(resourceGroupName))
  add(query_594470, "api-version", newJString(apiVersion))
  add(path_594469, "vpnSiteName", newJString(vpnSiteName))
  add(path_594469, "subscriptionId", newJString(subscriptionId))
  if VpnSiteParameters != nil:
    body_594471 = VpnSiteParameters
  result = call_594468.call(path_594469, query_594470, nil, nil, body_594471)

var vpnSitesUpdateTags* = Call_VpnSitesUpdateTags_594459(
    name: "vpnSitesUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}",
    validator: validate_VpnSitesUpdateTags_594460, base: "",
    url: url_VpnSitesUpdateTags_594461, schemes: {Scheme.Https})
type
  Call_VpnSitesDelete_594448 = ref object of OpenApiRestCall_593437
proc url_VpnSitesDelete_594450(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSitesDelete_594449(path: JsonNode; query: JsonNode;
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
  var valid_594451 = path.getOrDefault("resourceGroupName")
  valid_594451 = validateParameter(valid_594451, JString, required = true,
                                 default = nil)
  if valid_594451 != nil:
    section.add "resourceGroupName", valid_594451
  var valid_594452 = path.getOrDefault("vpnSiteName")
  valid_594452 = validateParameter(valid_594452, JString, required = true,
                                 default = nil)
  if valid_594452 != nil:
    section.add "vpnSiteName", valid_594452
  var valid_594453 = path.getOrDefault("subscriptionId")
  valid_594453 = validateParameter(valid_594453, JString, required = true,
                                 default = nil)
  if valid_594453 != nil:
    section.add "subscriptionId", valid_594453
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594454 = query.getOrDefault("api-version")
  valid_594454 = validateParameter(valid_594454, JString, required = true,
                                 default = nil)
  if valid_594454 != nil:
    section.add "api-version", valid_594454
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594455: Call_VpnSitesDelete_594448; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a VpnSite.
  ## 
  let valid = call_594455.validator(path, query, header, formData, body)
  let scheme = call_594455.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594455.url(scheme.get, call_594455.host, call_594455.base,
                         call_594455.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594455, url, valid)

proc call*(call_594456: Call_VpnSitesDelete_594448; resourceGroupName: string;
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
  var path_594457 = newJObject()
  var query_594458 = newJObject()
  add(path_594457, "resourceGroupName", newJString(resourceGroupName))
  add(query_594458, "api-version", newJString(apiVersion))
  add(path_594457, "vpnSiteName", newJString(vpnSiteName))
  add(path_594457, "subscriptionId", newJString(subscriptionId))
  result = call_594456.call(path_594457, query_594458, nil, nil, nil)

var vpnSitesDelete* = Call_VpnSitesDelete_594448(name: "vpnSitesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}",
    validator: validate_VpnSitesDelete_594449, base: "", url: url_VpnSitesDelete_594450,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
