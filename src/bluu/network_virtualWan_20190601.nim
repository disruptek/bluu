
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  Call_P2sVpnGatewaysGetP2sVpnConnectionHealth_594095 = ref object of OpenApiRestCall_593437
proc url_P2sVpnGatewaysGetP2sVpnConnectionHealth_594097(protocol: Scheme;
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

proc validate_P2sVpnGatewaysGetP2sVpnConnectionHealth_594096(path: JsonNode;
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
  var valid_594098 = path.getOrDefault("resourceGroupName")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "resourceGroupName", valid_594098
  var valid_594099 = path.getOrDefault("gatewayName")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "gatewayName", valid_594099
  var valid_594100 = path.getOrDefault("subscriptionId")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "subscriptionId", valid_594100
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594101 = query.getOrDefault("api-version")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "api-version", valid_594101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594102: Call_P2sVpnGatewaysGetP2sVpnConnectionHealth_594095;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the connection health of P2S clients of the virtual wan P2SVpnGateway in the specified resource group.
  ## 
  let valid = call_594102.validator(path, query, header, formData, body)
  let scheme = call_594102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594102.url(scheme.get, call_594102.host, call_594102.base,
                         call_594102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594102, url, valid)

proc call*(call_594103: Call_P2sVpnGatewaysGetP2sVpnConnectionHealth_594095;
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
  var path_594104 = newJObject()
  var query_594105 = newJObject()
  add(path_594104, "resourceGroupName", newJString(resourceGroupName))
  add(query_594105, "api-version", newJString(apiVersion))
  add(path_594104, "gatewayName", newJString(gatewayName))
  add(path_594104, "subscriptionId", newJString(subscriptionId))
  result = call_594103.call(path_594104, query_594105, nil, nil, nil)

var p2sVpnGatewaysGetP2sVpnConnectionHealth* = Call_P2sVpnGatewaysGetP2sVpnConnectionHealth_594095(
    name: "p2sVpnGatewaysGetP2sVpnConnectionHealth", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/p2svpnGateways/{gatewayName}/getP2sVpnConnectionHealth",
    validator: validate_P2sVpnGatewaysGetP2sVpnConnectionHealth_594096, base: "",
    url: url_P2sVpnGatewaysGetP2sVpnConnectionHealth_594097,
    schemes: {Scheme.Https})
type
  Call_VirtualHubsListByResourceGroup_594106 = ref object of OpenApiRestCall_593437
proc url_VirtualHubsListByResourceGroup_594108(protocol: Scheme; host: string;
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

proc validate_VirtualHubsListByResourceGroup_594107(path: JsonNode;
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
  var valid_594109 = path.getOrDefault("resourceGroupName")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "resourceGroupName", valid_594109
  var valid_594110 = path.getOrDefault("subscriptionId")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "subscriptionId", valid_594110
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

proc call*(call_594112: Call_VirtualHubsListByResourceGroup_594106; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VirtualHubs in a resource group.
  ## 
  let valid = call_594112.validator(path, query, header, formData, body)
  let scheme = call_594112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594112.url(scheme.get, call_594112.host, call_594112.base,
                         call_594112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594112, url, valid)

proc call*(call_594113: Call_VirtualHubsListByResourceGroup_594106;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualHubsListByResourceGroup
  ## Lists all the VirtualHubs in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualHub.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594114 = newJObject()
  var query_594115 = newJObject()
  add(path_594114, "resourceGroupName", newJString(resourceGroupName))
  add(query_594115, "api-version", newJString(apiVersion))
  add(path_594114, "subscriptionId", newJString(subscriptionId))
  result = call_594113.call(path_594114, query_594115, nil, nil, nil)

var virtualHubsListByResourceGroup* = Call_VirtualHubsListByResourceGroup_594106(
    name: "virtualHubsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs",
    validator: validate_VirtualHubsListByResourceGroup_594107, base: "",
    url: url_VirtualHubsListByResourceGroup_594108, schemes: {Scheme.Https})
type
  Call_VirtualHubsCreateOrUpdate_594127 = ref object of OpenApiRestCall_593437
proc url_VirtualHubsCreateOrUpdate_594129(protocol: Scheme; host: string;
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

proc validate_VirtualHubsCreateOrUpdate_594128(path: JsonNode; query: JsonNode;
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
  var valid_594130 = path.getOrDefault("resourceGroupName")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "resourceGroupName", valid_594130
  var valid_594131 = path.getOrDefault("subscriptionId")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "subscriptionId", valid_594131
  var valid_594132 = path.getOrDefault("virtualHubName")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "virtualHubName", valid_594132
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594133 = query.getOrDefault("api-version")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "api-version", valid_594133
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

proc call*(call_594135: Call_VirtualHubsCreateOrUpdate_594127; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a VirtualHub resource if it doesn't exist else updates the existing VirtualHub.
  ## 
  let valid = call_594135.validator(path, query, header, formData, body)
  let scheme = call_594135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594135.url(scheme.get, call_594135.host, call_594135.base,
                         call_594135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594135, url, valid)

proc call*(call_594136: Call_VirtualHubsCreateOrUpdate_594127;
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
  var path_594137 = newJObject()
  var query_594138 = newJObject()
  var body_594139 = newJObject()
  add(path_594137, "resourceGroupName", newJString(resourceGroupName))
  add(query_594138, "api-version", newJString(apiVersion))
  add(path_594137, "subscriptionId", newJString(subscriptionId))
  add(path_594137, "virtualHubName", newJString(virtualHubName))
  if virtualHubParameters != nil:
    body_594139 = virtualHubParameters
  result = call_594136.call(path_594137, query_594138, nil, nil, body_594139)

var virtualHubsCreateOrUpdate* = Call_VirtualHubsCreateOrUpdate_594127(
    name: "virtualHubsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}",
    validator: validate_VirtualHubsCreateOrUpdate_594128, base: "",
    url: url_VirtualHubsCreateOrUpdate_594129, schemes: {Scheme.Https})
type
  Call_VirtualHubsGet_594116 = ref object of OpenApiRestCall_593437
proc url_VirtualHubsGet_594118(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualHubsGet_594117(path: JsonNode; query: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_594123: Call_VirtualHubsGet_594116; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a VirtualHub.
  ## 
  let valid = call_594123.validator(path, query, header, formData, body)
  let scheme = call_594123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594123.url(scheme.get, call_594123.host, call_594123.base,
                         call_594123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594123, url, valid)

proc call*(call_594124: Call_VirtualHubsGet_594116; resourceGroupName: string;
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
  var path_594125 = newJObject()
  var query_594126 = newJObject()
  add(path_594125, "resourceGroupName", newJString(resourceGroupName))
  add(query_594126, "api-version", newJString(apiVersion))
  add(path_594125, "subscriptionId", newJString(subscriptionId))
  add(path_594125, "virtualHubName", newJString(virtualHubName))
  result = call_594124.call(path_594125, query_594126, nil, nil, nil)

var virtualHubsGet* = Call_VirtualHubsGet_594116(name: "virtualHubsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}",
    validator: validate_VirtualHubsGet_594117, base: "", url: url_VirtualHubsGet_594118,
    schemes: {Scheme.Https})
type
  Call_VirtualHubsUpdateTags_594151 = ref object of OpenApiRestCall_593437
proc url_VirtualHubsUpdateTags_594153(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualHubsUpdateTags_594152(path: JsonNode; query: JsonNode;
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
  var valid_594154 = path.getOrDefault("resourceGroupName")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "resourceGroupName", valid_594154
  var valid_594155 = path.getOrDefault("subscriptionId")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "subscriptionId", valid_594155
  var valid_594156 = path.getOrDefault("virtualHubName")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "virtualHubName", valid_594156
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594157 = query.getOrDefault("api-version")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "api-version", valid_594157
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

proc call*(call_594159: Call_VirtualHubsUpdateTags_594151; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates VirtualHub tags.
  ## 
  let valid = call_594159.validator(path, query, header, formData, body)
  let scheme = call_594159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594159.url(scheme.get, call_594159.host, call_594159.base,
                         call_594159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594159, url, valid)

proc call*(call_594160: Call_VirtualHubsUpdateTags_594151;
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
  var path_594161 = newJObject()
  var query_594162 = newJObject()
  var body_594163 = newJObject()
  add(path_594161, "resourceGroupName", newJString(resourceGroupName))
  add(query_594162, "api-version", newJString(apiVersion))
  add(path_594161, "subscriptionId", newJString(subscriptionId))
  add(path_594161, "virtualHubName", newJString(virtualHubName))
  if virtualHubParameters != nil:
    body_594163 = virtualHubParameters
  result = call_594160.call(path_594161, query_594162, nil, nil, body_594163)

var virtualHubsUpdateTags* = Call_VirtualHubsUpdateTags_594151(
    name: "virtualHubsUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}",
    validator: validate_VirtualHubsUpdateTags_594152, base: "",
    url: url_VirtualHubsUpdateTags_594153, schemes: {Scheme.Https})
type
  Call_VirtualHubsDelete_594140 = ref object of OpenApiRestCall_593437
proc url_VirtualHubsDelete_594142(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualHubsDelete_594141(path: JsonNode; query: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_594147: Call_VirtualHubsDelete_594140; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a VirtualHub.
  ## 
  let valid = call_594147.validator(path, query, header, formData, body)
  let scheme = call_594147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594147.url(scheme.get, call_594147.host, call_594147.base,
                         call_594147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594147, url, valid)

proc call*(call_594148: Call_VirtualHubsDelete_594140; resourceGroupName: string;
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
  var path_594149 = newJObject()
  var query_594150 = newJObject()
  add(path_594149, "resourceGroupName", newJString(resourceGroupName))
  add(query_594150, "api-version", newJString(apiVersion))
  add(path_594149, "subscriptionId", newJString(subscriptionId))
  add(path_594149, "virtualHubName", newJString(virtualHubName))
  result = call_594148.call(path_594149, query_594150, nil, nil, nil)

var virtualHubsDelete* = Call_VirtualHubsDelete_594140(name: "virtualHubsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}",
    validator: validate_VirtualHubsDelete_594141, base: "",
    url: url_VirtualHubsDelete_594142, schemes: {Scheme.Https})
type
  Call_HubVirtualNetworkConnectionsList_594164 = ref object of OpenApiRestCall_593437
proc url_HubVirtualNetworkConnectionsList_594166(protocol: Scheme; host: string;
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

proc validate_HubVirtualNetworkConnectionsList_594165(path: JsonNode;
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

proc call*(call_594171: Call_HubVirtualNetworkConnectionsList_594164;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the details of all HubVirtualNetworkConnections.
  ## 
  let valid = call_594171.validator(path, query, header, formData, body)
  let scheme = call_594171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594171.url(scheme.get, call_594171.host, call_594171.base,
                         call_594171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594171, url, valid)

proc call*(call_594172: Call_HubVirtualNetworkConnectionsList_594164;
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
  var path_594173 = newJObject()
  var query_594174 = newJObject()
  add(path_594173, "resourceGroupName", newJString(resourceGroupName))
  add(query_594174, "api-version", newJString(apiVersion))
  add(path_594173, "subscriptionId", newJString(subscriptionId))
  add(path_594173, "virtualHubName", newJString(virtualHubName))
  result = call_594172.call(path_594173, query_594174, nil, nil, nil)

var hubVirtualNetworkConnectionsList* = Call_HubVirtualNetworkConnectionsList_594164(
    name: "hubVirtualNetworkConnectionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}/hubVirtualNetworkConnections",
    validator: validate_HubVirtualNetworkConnectionsList_594165, base: "",
    url: url_HubVirtualNetworkConnectionsList_594166, schemes: {Scheme.Https})
type
  Call_HubVirtualNetworkConnectionsGet_594175 = ref object of OpenApiRestCall_593437
proc url_HubVirtualNetworkConnectionsGet_594177(protocol: Scheme; host: string;
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

proc validate_HubVirtualNetworkConnectionsGet_594176(path: JsonNode;
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
  var valid_594178 = path.getOrDefault("resourceGroupName")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "resourceGroupName", valid_594178
  var valid_594179 = path.getOrDefault("subscriptionId")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "subscriptionId", valid_594179
  var valid_594180 = path.getOrDefault("virtualHubName")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "virtualHubName", valid_594180
  var valid_594181 = path.getOrDefault("connectionName")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "connectionName", valid_594181
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594182 = query.getOrDefault("api-version")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "api-version", valid_594182
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594183: Call_HubVirtualNetworkConnectionsGet_594175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the details of a HubVirtualNetworkConnection.
  ## 
  let valid = call_594183.validator(path, query, header, formData, body)
  let scheme = call_594183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594183.url(scheme.get, call_594183.host, call_594183.base,
                         call_594183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594183, url, valid)

proc call*(call_594184: Call_HubVirtualNetworkConnectionsGet_594175;
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
  var path_594185 = newJObject()
  var query_594186 = newJObject()
  add(path_594185, "resourceGroupName", newJString(resourceGroupName))
  add(query_594186, "api-version", newJString(apiVersion))
  add(path_594185, "subscriptionId", newJString(subscriptionId))
  add(path_594185, "virtualHubName", newJString(virtualHubName))
  add(path_594185, "connectionName", newJString(connectionName))
  result = call_594184.call(path_594185, query_594186, nil, nil, nil)

var hubVirtualNetworkConnectionsGet* = Call_HubVirtualNetworkConnectionsGet_594175(
    name: "hubVirtualNetworkConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualHubs/{virtualHubName}/hubVirtualNetworkConnections/{connectionName}",
    validator: validate_HubVirtualNetworkConnectionsGet_594176, base: "",
    url: url_HubVirtualNetworkConnectionsGet_594177, schemes: {Scheme.Https})
type
  Call_VirtualWansListByResourceGroup_594187 = ref object of OpenApiRestCall_593437
proc url_VirtualWansListByResourceGroup_594189(protocol: Scheme; host: string;
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

proc validate_VirtualWansListByResourceGroup_594188(path: JsonNode;
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
  var valid_594190 = path.getOrDefault("resourceGroupName")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "resourceGroupName", valid_594190
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

proc call*(call_594193: Call_VirtualWansListByResourceGroup_594187; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VirtualWANs in a resource group.
  ## 
  let valid = call_594193.validator(path, query, header, formData, body)
  let scheme = call_594193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594193.url(scheme.get, call_594193.host, call_594193.base,
                         call_594193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594193, url, valid)

proc call*(call_594194: Call_VirtualWansListByResourceGroup_594187;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualWansListByResourceGroup
  ## Lists all the VirtualWANs in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VirtualWan.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594195 = newJObject()
  var query_594196 = newJObject()
  add(path_594195, "resourceGroupName", newJString(resourceGroupName))
  add(query_594196, "api-version", newJString(apiVersion))
  add(path_594195, "subscriptionId", newJString(subscriptionId))
  result = call_594194.call(path_594195, query_594196, nil, nil, nil)

var virtualWansListByResourceGroup* = Call_VirtualWansListByResourceGroup_594187(
    name: "virtualWansListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans",
    validator: validate_VirtualWansListByResourceGroup_594188, base: "",
    url: url_VirtualWansListByResourceGroup_594189, schemes: {Scheme.Https})
type
  Call_VirtualWansCreateOrUpdate_594208 = ref object of OpenApiRestCall_593437
proc url_VirtualWansCreateOrUpdate_594210(protocol: Scheme; host: string;
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

proc validate_VirtualWansCreateOrUpdate_594209(path: JsonNode; query: JsonNode;
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
  var valid_594211 = path.getOrDefault("resourceGroupName")
  valid_594211 = validateParameter(valid_594211, JString, required = true,
                                 default = nil)
  if valid_594211 != nil:
    section.add "resourceGroupName", valid_594211
  var valid_594212 = path.getOrDefault("VirtualWANName")
  valid_594212 = validateParameter(valid_594212, JString, required = true,
                                 default = nil)
  if valid_594212 != nil:
    section.add "VirtualWANName", valid_594212
  var valid_594213 = path.getOrDefault("subscriptionId")
  valid_594213 = validateParameter(valid_594213, JString, required = true,
                                 default = nil)
  if valid_594213 != nil:
    section.add "subscriptionId", valid_594213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594214 = query.getOrDefault("api-version")
  valid_594214 = validateParameter(valid_594214, JString, required = true,
                                 default = nil)
  if valid_594214 != nil:
    section.add "api-version", valid_594214
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

proc call*(call_594216: Call_VirtualWansCreateOrUpdate_594208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a VirtualWAN resource if it doesn't exist else updates the existing VirtualWAN.
  ## 
  let valid = call_594216.validator(path, query, header, formData, body)
  let scheme = call_594216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594216.url(scheme.get, call_594216.host, call_594216.base,
                         call_594216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594216, url, valid)

proc call*(call_594217: Call_VirtualWansCreateOrUpdate_594208;
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
  var path_594218 = newJObject()
  var query_594219 = newJObject()
  var body_594220 = newJObject()
  add(path_594218, "resourceGroupName", newJString(resourceGroupName))
  add(path_594218, "VirtualWANName", newJString(VirtualWANName))
  add(query_594219, "api-version", newJString(apiVersion))
  add(path_594218, "subscriptionId", newJString(subscriptionId))
  if WANParameters != nil:
    body_594220 = WANParameters
  result = call_594217.call(path_594218, query_594219, nil, nil, body_594220)

var virtualWansCreateOrUpdate* = Call_VirtualWansCreateOrUpdate_594208(
    name: "virtualWansCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{VirtualWANName}",
    validator: validate_VirtualWansCreateOrUpdate_594209, base: "",
    url: url_VirtualWansCreateOrUpdate_594210, schemes: {Scheme.Https})
type
  Call_VirtualWansGet_594197 = ref object of OpenApiRestCall_593437
proc url_VirtualWansGet_594199(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualWansGet_594198(path: JsonNode; query: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_594204: Call_VirtualWansGet_594197; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a VirtualWAN.
  ## 
  let valid = call_594204.validator(path, query, header, formData, body)
  let scheme = call_594204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594204.url(scheme.get, call_594204.host, call_594204.base,
                         call_594204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594204, url, valid)

proc call*(call_594205: Call_VirtualWansGet_594197; resourceGroupName: string;
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
  var path_594206 = newJObject()
  var query_594207 = newJObject()
  add(path_594206, "resourceGroupName", newJString(resourceGroupName))
  add(path_594206, "VirtualWANName", newJString(VirtualWANName))
  add(query_594207, "api-version", newJString(apiVersion))
  add(path_594206, "subscriptionId", newJString(subscriptionId))
  result = call_594205.call(path_594206, query_594207, nil, nil, nil)

var virtualWansGet* = Call_VirtualWansGet_594197(name: "virtualWansGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{VirtualWANName}",
    validator: validate_VirtualWansGet_594198, base: "", url: url_VirtualWansGet_594199,
    schemes: {Scheme.Https})
type
  Call_VirtualWansUpdateTags_594232 = ref object of OpenApiRestCall_593437
proc url_VirtualWansUpdateTags_594234(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualWansUpdateTags_594233(path: JsonNode; query: JsonNode;
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
  var valid_594235 = path.getOrDefault("resourceGroupName")
  valid_594235 = validateParameter(valid_594235, JString, required = true,
                                 default = nil)
  if valid_594235 != nil:
    section.add "resourceGroupName", valid_594235
  var valid_594236 = path.getOrDefault("VirtualWANName")
  valid_594236 = validateParameter(valid_594236, JString, required = true,
                                 default = nil)
  if valid_594236 != nil:
    section.add "VirtualWANName", valid_594236
  var valid_594237 = path.getOrDefault("subscriptionId")
  valid_594237 = validateParameter(valid_594237, JString, required = true,
                                 default = nil)
  if valid_594237 != nil:
    section.add "subscriptionId", valid_594237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594238 = query.getOrDefault("api-version")
  valid_594238 = validateParameter(valid_594238, JString, required = true,
                                 default = nil)
  if valid_594238 != nil:
    section.add "api-version", valid_594238
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

proc call*(call_594240: Call_VirtualWansUpdateTags_594232; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a VirtualWAN tags.
  ## 
  let valid = call_594240.validator(path, query, header, formData, body)
  let scheme = call_594240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594240.url(scheme.get, call_594240.host, call_594240.base,
                         call_594240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594240, url, valid)

proc call*(call_594241: Call_VirtualWansUpdateTags_594232;
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
  var path_594242 = newJObject()
  var query_594243 = newJObject()
  var body_594244 = newJObject()
  add(path_594242, "resourceGroupName", newJString(resourceGroupName))
  add(path_594242, "VirtualWANName", newJString(VirtualWANName))
  add(query_594243, "api-version", newJString(apiVersion))
  add(path_594242, "subscriptionId", newJString(subscriptionId))
  if WANParameters != nil:
    body_594244 = WANParameters
  result = call_594241.call(path_594242, query_594243, nil, nil, body_594244)

var virtualWansUpdateTags* = Call_VirtualWansUpdateTags_594232(
    name: "virtualWansUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{VirtualWANName}",
    validator: validate_VirtualWansUpdateTags_594233, base: "",
    url: url_VirtualWansUpdateTags_594234, schemes: {Scheme.Https})
type
  Call_VirtualWansDelete_594221 = ref object of OpenApiRestCall_593437
proc url_VirtualWansDelete_594223(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualWansDelete_594222(path: JsonNode; query: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_594228: Call_VirtualWansDelete_594221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a VirtualWAN.
  ## 
  let valid = call_594228.validator(path, query, header, formData, body)
  let scheme = call_594228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594228.url(scheme.get, call_594228.host, call_594228.base,
                         call_594228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594228, url, valid)

proc call*(call_594229: Call_VirtualWansDelete_594221; resourceGroupName: string;
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
  var path_594230 = newJObject()
  var query_594231 = newJObject()
  add(path_594230, "resourceGroupName", newJString(resourceGroupName))
  add(path_594230, "VirtualWANName", newJString(VirtualWANName))
  add(query_594231, "api-version", newJString(apiVersion))
  add(path_594230, "subscriptionId", newJString(subscriptionId))
  result = call_594229.call(path_594230, query_594231, nil, nil, nil)

var virtualWansDelete* = Call_VirtualWansDelete_594221(name: "virtualWansDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{VirtualWANName}",
    validator: validate_VirtualWansDelete_594222, base: "",
    url: url_VirtualWansDelete_594223, schemes: {Scheme.Https})
type
  Call_SupportedSecurityProviders_594245 = ref object of OpenApiRestCall_593437
proc url_SupportedSecurityProviders_594247(protocol: Scheme; host: string;
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

proc validate_SupportedSecurityProviders_594246(path: JsonNode; query: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_594252: Call_SupportedSecurityProviders_594245; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gives the supported security providers for the virtual wan.
  ## 
  let valid = call_594252.validator(path, query, header, formData, body)
  let scheme = call_594252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594252.url(scheme.get, call_594252.host, call_594252.base,
                         call_594252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594252, url, valid)

proc call*(call_594253: Call_SupportedSecurityProviders_594245;
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
  var path_594254 = newJObject()
  var query_594255 = newJObject()
  add(path_594254, "resourceGroupName", newJString(resourceGroupName))
  add(query_594255, "api-version", newJString(apiVersion))
  add(path_594254, "subscriptionId", newJString(subscriptionId))
  add(path_594254, "virtualWANName", newJString(virtualWANName))
  result = call_594253.call(path_594254, query_594255, nil, nil, nil)

var supportedSecurityProviders* = Call_SupportedSecurityProviders_594245(
    name: "supportedSecurityProviders", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{virtualWANName}/supportedSecurityProviders",
    validator: validate_SupportedSecurityProviders_594246, base: "",
    url: url_SupportedSecurityProviders_594247, schemes: {Scheme.Https})
type
  Call_VpnSitesConfigurationDownload_594256 = ref object of OpenApiRestCall_593437
proc url_VpnSitesConfigurationDownload_594258(protocol: Scheme; host: string;
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

proc validate_VpnSitesConfigurationDownload_594257(path: JsonNode; query: JsonNode;
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
  var valid_594259 = path.getOrDefault("resourceGroupName")
  valid_594259 = validateParameter(valid_594259, JString, required = true,
                                 default = nil)
  if valid_594259 != nil:
    section.add "resourceGroupName", valid_594259
  var valid_594260 = path.getOrDefault("subscriptionId")
  valid_594260 = validateParameter(valid_594260, JString, required = true,
                                 default = nil)
  if valid_594260 != nil:
    section.add "subscriptionId", valid_594260
  var valid_594261 = path.getOrDefault("virtualWANName")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = nil)
  if valid_594261 != nil:
    section.add "virtualWANName", valid_594261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594262 = query.getOrDefault("api-version")
  valid_594262 = validateParameter(valid_594262, JString, required = true,
                                 default = nil)
  if valid_594262 != nil:
    section.add "api-version", valid_594262
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

proc call*(call_594264: Call_VpnSitesConfigurationDownload_594256; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gives the sas-url to download the configurations for vpn-sites in a resource group.
  ## 
  let valid = call_594264.validator(path, query, header, formData, body)
  let scheme = call_594264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594264.url(scheme.get, call_594264.host, call_594264.base,
                         call_594264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594264, url, valid)

proc call*(call_594265: Call_VpnSitesConfigurationDownload_594256;
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
  var path_594266 = newJObject()
  var query_594267 = newJObject()
  var body_594268 = newJObject()
  add(path_594266, "resourceGroupName", newJString(resourceGroupName))
  add(query_594267, "api-version", newJString(apiVersion))
  add(path_594266, "subscriptionId", newJString(subscriptionId))
  if request != nil:
    body_594268 = request
  add(path_594266, "virtualWANName", newJString(virtualWANName))
  result = call_594265.call(path_594266, query_594267, nil, nil, body_594268)

var vpnSitesConfigurationDownload* = Call_VpnSitesConfigurationDownload_594256(
    name: "vpnSitesConfigurationDownload", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{virtualWANName}/vpnConfiguration",
    validator: validate_VpnSitesConfigurationDownload_594257, base: "",
    url: url_VpnSitesConfigurationDownload_594258, schemes: {Scheme.Https})
type
  Call_P2sVpnServerConfigurationsListByVirtualWan_594269 = ref object of OpenApiRestCall_593437
proc url_P2sVpnServerConfigurationsListByVirtualWan_594271(protocol: Scheme;
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

proc validate_P2sVpnServerConfigurationsListByVirtualWan_594270(path: JsonNode;
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
  var valid_594274 = path.getOrDefault("subscriptionId")
  valid_594274 = validateParameter(valid_594274, JString, required = true,
                                 default = nil)
  if valid_594274 != nil:
    section.add "subscriptionId", valid_594274
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594275 = query.getOrDefault("api-version")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "api-version", valid_594275
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594276: Call_P2sVpnServerConfigurationsListByVirtualWan_594269;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all P2SVpnServerConfigurations for a particular VirtualWan.
  ## 
  let valid = call_594276.validator(path, query, header, formData, body)
  let scheme = call_594276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594276.url(scheme.get, call_594276.host, call_594276.base,
                         call_594276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594276, url, valid)

proc call*(call_594277: Call_P2sVpnServerConfigurationsListByVirtualWan_594269;
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
  var path_594278 = newJObject()
  var query_594279 = newJObject()
  add(path_594278, "resourceGroupName", newJString(resourceGroupName))
  add(query_594279, "api-version", newJString(apiVersion))
  add(path_594278, "virtualWanName", newJString(virtualWanName))
  add(path_594278, "subscriptionId", newJString(subscriptionId))
  result = call_594277.call(path_594278, query_594279, nil, nil, nil)

var p2sVpnServerConfigurationsListByVirtualWan* = Call_P2sVpnServerConfigurationsListByVirtualWan_594269(
    name: "p2sVpnServerConfigurationsListByVirtualWan", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{virtualWanName}/p2sVpnServerConfigurations",
    validator: validate_P2sVpnServerConfigurationsListByVirtualWan_594270,
    base: "", url: url_P2sVpnServerConfigurationsListByVirtualWan_594271,
    schemes: {Scheme.Https})
type
  Call_P2sVpnServerConfigurationsCreateOrUpdate_594292 = ref object of OpenApiRestCall_593437
proc url_P2sVpnServerConfigurationsCreateOrUpdate_594294(protocol: Scheme;
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

proc validate_P2sVpnServerConfigurationsCreateOrUpdate_594293(path: JsonNode;
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
  var valid_594295 = path.getOrDefault("resourceGroupName")
  valid_594295 = validateParameter(valid_594295, JString, required = true,
                                 default = nil)
  if valid_594295 != nil:
    section.add "resourceGroupName", valid_594295
  var valid_594296 = path.getOrDefault("virtualWanName")
  valid_594296 = validateParameter(valid_594296, JString, required = true,
                                 default = nil)
  if valid_594296 != nil:
    section.add "virtualWanName", valid_594296
  var valid_594297 = path.getOrDefault("p2SVpnServerConfigurationName")
  valid_594297 = validateParameter(valid_594297, JString, required = true,
                                 default = nil)
  if valid_594297 != nil:
    section.add "p2SVpnServerConfigurationName", valid_594297
  var valid_594298 = path.getOrDefault("subscriptionId")
  valid_594298 = validateParameter(valid_594298, JString, required = true,
                                 default = nil)
  if valid_594298 != nil:
    section.add "subscriptionId", valid_594298
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594299 = query.getOrDefault("api-version")
  valid_594299 = validateParameter(valid_594299, JString, required = true,
                                 default = nil)
  if valid_594299 != nil:
    section.add "api-version", valid_594299
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

proc call*(call_594301: Call_P2sVpnServerConfigurationsCreateOrUpdate_594292;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a P2SVpnServerConfiguration to associate with a VirtualWan if it doesn't exist else updates the existing P2SVpnServerConfiguration.
  ## 
  let valid = call_594301.validator(path, query, header, formData, body)
  let scheme = call_594301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594301.url(scheme.get, call_594301.host, call_594301.base,
                         call_594301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594301, url, valid)

proc call*(call_594302: Call_P2sVpnServerConfigurationsCreateOrUpdate_594292;
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
  var path_594303 = newJObject()
  var query_594304 = newJObject()
  var body_594305 = newJObject()
  add(path_594303, "resourceGroupName", newJString(resourceGroupName))
  add(query_594304, "api-version", newJString(apiVersion))
  add(path_594303, "virtualWanName", newJString(virtualWanName))
  add(path_594303, "p2SVpnServerConfigurationName",
      newJString(p2SVpnServerConfigurationName))
  add(path_594303, "subscriptionId", newJString(subscriptionId))
  if p2SVpnServerConfigurationParameters != nil:
    body_594305 = p2SVpnServerConfigurationParameters
  result = call_594302.call(path_594303, query_594304, nil, nil, body_594305)

var p2sVpnServerConfigurationsCreateOrUpdate* = Call_P2sVpnServerConfigurationsCreateOrUpdate_594292(
    name: "p2sVpnServerConfigurationsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{virtualWanName}/p2sVpnServerConfigurations/{p2SVpnServerConfigurationName}",
    validator: validate_P2sVpnServerConfigurationsCreateOrUpdate_594293, base: "",
    url: url_P2sVpnServerConfigurationsCreateOrUpdate_594294,
    schemes: {Scheme.Https})
type
  Call_P2sVpnServerConfigurationsGet_594280 = ref object of OpenApiRestCall_593437
proc url_P2sVpnServerConfigurationsGet_594282(protocol: Scheme; host: string;
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

proc validate_P2sVpnServerConfigurationsGet_594281(path: JsonNode; query: JsonNode;
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
  var valid_594283 = path.getOrDefault("resourceGroupName")
  valid_594283 = validateParameter(valid_594283, JString, required = true,
                                 default = nil)
  if valid_594283 != nil:
    section.add "resourceGroupName", valid_594283
  var valid_594284 = path.getOrDefault("virtualWanName")
  valid_594284 = validateParameter(valid_594284, JString, required = true,
                                 default = nil)
  if valid_594284 != nil:
    section.add "virtualWanName", valid_594284
  var valid_594285 = path.getOrDefault("p2SVpnServerConfigurationName")
  valid_594285 = validateParameter(valid_594285, JString, required = true,
                                 default = nil)
  if valid_594285 != nil:
    section.add "p2SVpnServerConfigurationName", valid_594285
  var valid_594286 = path.getOrDefault("subscriptionId")
  valid_594286 = validateParameter(valid_594286, JString, required = true,
                                 default = nil)
  if valid_594286 != nil:
    section.add "subscriptionId", valid_594286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594287 = query.getOrDefault("api-version")
  valid_594287 = validateParameter(valid_594287, JString, required = true,
                                 default = nil)
  if valid_594287 != nil:
    section.add "api-version", valid_594287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594288: Call_P2sVpnServerConfigurationsGet_594280; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a P2SVpnServerConfiguration.
  ## 
  let valid = call_594288.validator(path, query, header, formData, body)
  let scheme = call_594288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594288.url(scheme.get, call_594288.host, call_594288.base,
                         call_594288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594288, url, valid)

proc call*(call_594289: Call_P2sVpnServerConfigurationsGet_594280;
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
  var path_594290 = newJObject()
  var query_594291 = newJObject()
  add(path_594290, "resourceGroupName", newJString(resourceGroupName))
  add(query_594291, "api-version", newJString(apiVersion))
  add(path_594290, "virtualWanName", newJString(virtualWanName))
  add(path_594290, "p2SVpnServerConfigurationName",
      newJString(p2SVpnServerConfigurationName))
  add(path_594290, "subscriptionId", newJString(subscriptionId))
  result = call_594289.call(path_594290, query_594291, nil, nil, nil)

var p2sVpnServerConfigurationsGet* = Call_P2sVpnServerConfigurationsGet_594280(
    name: "p2sVpnServerConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{virtualWanName}/p2sVpnServerConfigurations/{p2SVpnServerConfigurationName}",
    validator: validate_P2sVpnServerConfigurationsGet_594281, base: "",
    url: url_P2sVpnServerConfigurationsGet_594282, schemes: {Scheme.Https})
type
  Call_P2sVpnServerConfigurationsDelete_594306 = ref object of OpenApiRestCall_593437
proc url_P2sVpnServerConfigurationsDelete_594308(protocol: Scheme; host: string;
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

proc validate_P2sVpnServerConfigurationsDelete_594307(path: JsonNode;
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
  var valid_594309 = path.getOrDefault("resourceGroupName")
  valid_594309 = validateParameter(valid_594309, JString, required = true,
                                 default = nil)
  if valid_594309 != nil:
    section.add "resourceGroupName", valid_594309
  var valid_594310 = path.getOrDefault("virtualWanName")
  valid_594310 = validateParameter(valid_594310, JString, required = true,
                                 default = nil)
  if valid_594310 != nil:
    section.add "virtualWanName", valid_594310
  var valid_594311 = path.getOrDefault("p2SVpnServerConfigurationName")
  valid_594311 = validateParameter(valid_594311, JString, required = true,
                                 default = nil)
  if valid_594311 != nil:
    section.add "p2SVpnServerConfigurationName", valid_594311
  var valid_594312 = path.getOrDefault("subscriptionId")
  valid_594312 = validateParameter(valid_594312, JString, required = true,
                                 default = nil)
  if valid_594312 != nil:
    section.add "subscriptionId", valid_594312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594313 = query.getOrDefault("api-version")
  valid_594313 = validateParameter(valid_594313, JString, required = true,
                                 default = nil)
  if valid_594313 != nil:
    section.add "api-version", valid_594313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594314: Call_P2sVpnServerConfigurationsDelete_594306;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a P2SVpnServerConfiguration.
  ## 
  let valid = call_594314.validator(path, query, header, formData, body)
  let scheme = call_594314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594314.url(scheme.get, call_594314.host, call_594314.base,
                         call_594314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594314, url, valid)

proc call*(call_594315: Call_P2sVpnServerConfigurationsDelete_594306;
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
  var path_594316 = newJObject()
  var query_594317 = newJObject()
  add(path_594316, "resourceGroupName", newJString(resourceGroupName))
  add(query_594317, "api-version", newJString(apiVersion))
  add(path_594316, "virtualWanName", newJString(virtualWanName))
  add(path_594316, "p2SVpnServerConfigurationName",
      newJString(p2SVpnServerConfigurationName))
  add(path_594316, "subscriptionId", newJString(subscriptionId))
  result = call_594315.call(path_594316, query_594317, nil, nil, nil)

var p2sVpnServerConfigurationsDelete* = Call_P2sVpnServerConfigurationsDelete_594306(
    name: "p2sVpnServerConfigurationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualWans/{virtualWanName}/p2sVpnServerConfigurations/{p2SVpnServerConfigurationName}",
    validator: validate_P2sVpnServerConfigurationsDelete_594307, base: "",
    url: url_P2sVpnServerConfigurationsDelete_594308, schemes: {Scheme.Https})
type
  Call_VpnGatewaysListByResourceGroup_594318 = ref object of OpenApiRestCall_593437
proc url_VpnGatewaysListByResourceGroup_594320(protocol: Scheme; host: string;
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

proc validate_VpnGatewaysListByResourceGroup_594319(path: JsonNode;
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
  var valid_594321 = path.getOrDefault("resourceGroupName")
  valid_594321 = validateParameter(valid_594321, JString, required = true,
                                 default = nil)
  if valid_594321 != nil:
    section.add "resourceGroupName", valid_594321
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

proc call*(call_594324: Call_VpnGatewaysListByResourceGroup_594318; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the VpnGateways in a resource group.
  ## 
  let valid = call_594324.validator(path, query, header, formData, body)
  let scheme = call_594324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594324.url(scheme.get, call_594324.host, call_594324.base,
                         call_594324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594324, url, valid)

proc call*(call_594325: Call_VpnGatewaysListByResourceGroup_594318;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## vpnGatewaysListByResourceGroup
  ## Lists all the VpnGateways in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnGateway.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594326 = newJObject()
  var query_594327 = newJObject()
  add(path_594326, "resourceGroupName", newJString(resourceGroupName))
  add(query_594327, "api-version", newJString(apiVersion))
  add(path_594326, "subscriptionId", newJString(subscriptionId))
  result = call_594325.call(path_594326, query_594327, nil, nil, nil)

var vpnGatewaysListByResourceGroup* = Call_VpnGatewaysListByResourceGroup_594318(
    name: "vpnGatewaysListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways",
    validator: validate_VpnGatewaysListByResourceGroup_594319, base: "",
    url: url_VpnGatewaysListByResourceGroup_594320, schemes: {Scheme.Https})
type
  Call_VpnGatewaysCreateOrUpdate_594339 = ref object of OpenApiRestCall_593437
proc url_VpnGatewaysCreateOrUpdate_594341(protocol: Scheme; host: string;
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

proc validate_VpnGatewaysCreateOrUpdate_594340(path: JsonNode; query: JsonNode;
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
  var valid_594342 = path.getOrDefault("resourceGroupName")
  valid_594342 = validateParameter(valid_594342, JString, required = true,
                                 default = nil)
  if valid_594342 != nil:
    section.add "resourceGroupName", valid_594342
  var valid_594343 = path.getOrDefault("gatewayName")
  valid_594343 = validateParameter(valid_594343, JString, required = true,
                                 default = nil)
  if valid_594343 != nil:
    section.add "gatewayName", valid_594343
  var valid_594344 = path.getOrDefault("subscriptionId")
  valid_594344 = validateParameter(valid_594344, JString, required = true,
                                 default = nil)
  if valid_594344 != nil:
    section.add "subscriptionId", valid_594344
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594345 = query.getOrDefault("api-version")
  valid_594345 = validateParameter(valid_594345, JString, required = true,
                                 default = nil)
  if valid_594345 != nil:
    section.add "api-version", valid_594345
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

proc call*(call_594347: Call_VpnGatewaysCreateOrUpdate_594339; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a virtual wan vpn gateway if it doesn't exist else updates the existing gateway.
  ## 
  let valid = call_594347.validator(path, query, header, formData, body)
  let scheme = call_594347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594347.url(scheme.get, call_594347.host, call_594347.base,
                         call_594347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594347, url, valid)

proc call*(call_594348: Call_VpnGatewaysCreateOrUpdate_594339;
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
  var path_594349 = newJObject()
  var query_594350 = newJObject()
  var body_594351 = newJObject()
  add(path_594349, "resourceGroupName", newJString(resourceGroupName))
  add(query_594350, "api-version", newJString(apiVersion))
  add(path_594349, "gatewayName", newJString(gatewayName))
  add(path_594349, "subscriptionId", newJString(subscriptionId))
  if vpnGatewayParameters != nil:
    body_594351 = vpnGatewayParameters
  result = call_594348.call(path_594349, query_594350, nil, nil, body_594351)

var vpnGatewaysCreateOrUpdate* = Call_VpnGatewaysCreateOrUpdate_594339(
    name: "vpnGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}",
    validator: validate_VpnGatewaysCreateOrUpdate_594340, base: "",
    url: url_VpnGatewaysCreateOrUpdate_594341, schemes: {Scheme.Https})
type
  Call_VpnGatewaysGet_594328 = ref object of OpenApiRestCall_593437
proc url_VpnGatewaysGet_594330(protocol: Scheme; host: string; base: string;
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

proc validate_VpnGatewaysGet_594329(path: JsonNode; query: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_594335: Call_VpnGatewaysGet_594328; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a virtual wan vpn gateway.
  ## 
  let valid = call_594335.validator(path, query, header, formData, body)
  let scheme = call_594335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594335.url(scheme.get, call_594335.host, call_594335.base,
                         call_594335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594335, url, valid)

proc call*(call_594336: Call_VpnGatewaysGet_594328; resourceGroupName: string;
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
  var path_594337 = newJObject()
  var query_594338 = newJObject()
  add(path_594337, "resourceGroupName", newJString(resourceGroupName))
  add(query_594338, "api-version", newJString(apiVersion))
  add(path_594337, "gatewayName", newJString(gatewayName))
  add(path_594337, "subscriptionId", newJString(subscriptionId))
  result = call_594336.call(path_594337, query_594338, nil, nil, nil)

var vpnGatewaysGet* = Call_VpnGatewaysGet_594328(name: "vpnGatewaysGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}",
    validator: validate_VpnGatewaysGet_594329, base: "", url: url_VpnGatewaysGet_594330,
    schemes: {Scheme.Https})
type
  Call_VpnGatewaysUpdateTags_594363 = ref object of OpenApiRestCall_593437
proc url_VpnGatewaysUpdateTags_594365(protocol: Scheme; host: string; base: string;
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

proc validate_VpnGatewaysUpdateTags_594364(path: JsonNode; query: JsonNode;
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
  var valid_594366 = path.getOrDefault("resourceGroupName")
  valid_594366 = validateParameter(valid_594366, JString, required = true,
                                 default = nil)
  if valid_594366 != nil:
    section.add "resourceGroupName", valid_594366
  var valid_594367 = path.getOrDefault("gatewayName")
  valid_594367 = validateParameter(valid_594367, JString, required = true,
                                 default = nil)
  if valid_594367 != nil:
    section.add "gatewayName", valid_594367
  var valid_594368 = path.getOrDefault("subscriptionId")
  valid_594368 = validateParameter(valid_594368, JString, required = true,
                                 default = nil)
  if valid_594368 != nil:
    section.add "subscriptionId", valid_594368
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594369 = query.getOrDefault("api-version")
  valid_594369 = validateParameter(valid_594369, JString, required = true,
                                 default = nil)
  if valid_594369 != nil:
    section.add "api-version", valid_594369
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

proc call*(call_594371: Call_VpnGatewaysUpdateTags_594363; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates virtual wan vpn gateway tags.
  ## 
  let valid = call_594371.validator(path, query, header, formData, body)
  let scheme = call_594371.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594371.url(scheme.get, call_594371.host, call_594371.base,
                         call_594371.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594371, url, valid)

proc call*(call_594372: Call_VpnGatewaysUpdateTags_594363;
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
  var path_594373 = newJObject()
  var query_594374 = newJObject()
  var body_594375 = newJObject()
  add(path_594373, "resourceGroupName", newJString(resourceGroupName))
  add(query_594374, "api-version", newJString(apiVersion))
  add(path_594373, "gatewayName", newJString(gatewayName))
  add(path_594373, "subscriptionId", newJString(subscriptionId))
  if vpnGatewayParameters != nil:
    body_594375 = vpnGatewayParameters
  result = call_594372.call(path_594373, query_594374, nil, nil, body_594375)

var vpnGatewaysUpdateTags* = Call_VpnGatewaysUpdateTags_594363(
    name: "vpnGatewaysUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}",
    validator: validate_VpnGatewaysUpdateTags_594364, base: "",
    url: url_VpnGatewaysUpdateTags_594365, schemes: {Scheme.Https})
type
  Call_VpnGatewaysDelete_594352 = ref object of OpenApiRestCall_593437
proc url_VpnGatewaysDelete_594354(protocol: Scheme; host: string; base: string;
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

proc validate_VpnGatewaysDelete_594353(path: JsonNode; query: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_594359: Call_VpnGatewaysDelete_594352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a virtual wan vpn gateway.
  ## 
  let valid = call_594359.validator(path, query, header, formData, body)
  let scheme = call_594359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594359.url(scheme.get, call_594359.host, call_594359.base,
                         call_594359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594359, url, valid)

proc call*(call_594360: Call_VpnGatewaysDelete_594352; resourceGroupName: string;
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
  var path_594361 = newJObject()
  var query_594362 = newJObject()
  add(path_594361, "resourceGroupName", newJString(resourceGroupName))
  add(query_594362, "api-version", newJString(apiVersion))
  add(path_594361, "gatewayName", newJString(gatewayName))
  add(path_594361, "subscriptionId", newJString(subscriptionId))
  result = call_594360.call(path_594361, query_594362, nil, nil, nil)

var vpnGatewaysDelete* = Call_VpnGatewaysDelete_594352(name: "vpnGatewaysDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}",
    validator: validate_VpnGatewaysDelete_594353, base: "",
    url: url_VpnGatewaysDelete_594354, schemes: {Scheme.Https})
type
  Call_VpnGatewaysReset_594376 = ref object of OpenApiRestCall_593437
proc url_VpnGatewaysReset_594378(protocol: Scheme; host: string; base: string;
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

proc validate_VpnGatewaysReset_594377(path: JsonNode; query: JsonNode;
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594382 = query.getOrDefault("api-version")
  valid_594382 = validateParameter(valid_594382, JString, required = true,
                                 default = nil)
  if valid_594382 != nil:
    section.add "api-version", valid_594382
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594383: Call_VpnGatewaysReset_594376; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets the primary of the vpn gateway in the specified resource group.
  ## 
  let valid = call_594383.validator(path, query, header, formData, body)
  let scheme = call_594383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594383.url(scheme.get, call_594383.host, call_594383.base,
                         call_594383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594383, url, valid)

proc call*(call_594384: Call_VpnGatewaysReset_594376; resourceGroupName: string;
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
  var path_594385 = newJObject()
  var query_594386 = newJObject()
  add(path_594385, "resourceGroupName", newJString(resourceGroupName))
  add(query_594386, "api-version", newJString(apiVersion))
  add(path_594385, "gatewayName", newJString(gatewayName))
  add(path_594385, "subscriptionId", newJString(subscriptionId))
  result = call_594384.call(path_594385, query_594386, nil, nil, nil)

var vpnGatewaysReset* = Call_VpnGatewaysReset_594376(name: "vpnGatewaysReset",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/reset",
    validator: validate_VpnGatewaysReset_594377, base: "",
    url: url_VpnGatewaysReset_594378, schemes: {Scheme.Https})
type
  Call_VpnConnectionsListByVpnGateway_594387 = ref object of OpenApiRestCall_593437
proc url_VpnConnectionsListByVpnGateway_594389(protocol: Scheme; host: string;
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

proc validate_VpnConnectionsListByVpnGateway_594388(path: JsonNode;
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
  var valid_594390 = path.getOrDefault("resourceGroupName")
  valid_594390 = validateParameter(valid_594390, JString, required = true,
                                 default = nil)
  if valid_594390 != nil:
    section.add "resourceGroupName", valid_594390
  var valid_594391 = path.getOrDefault("gatewayName")
  valid_594391 = validateParameter(valid_594391, JString, required = true,
                                 default = nil)
  if valid_594391 != nil:
    section.add "gatewayName", valid_594391
  var valid_594392 = path.getOrDefault("subscriptionId")
  valid_594392 = validateParameter(valid_594392, JString, required = true,
                                 default = nil)
  if valid_594392 != nil:
    section.add "subscriptionId", valid_594392
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594393 = query.getOrDefault("api-version")
  valid_594393 = validateParameter(valid_594393, JString, required = true,
                                 default = nil)
  if valid_594393 != nil:
    section.add "api-version", valid_594393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594394: Call_VpnConnectionsListByVpnGateway_594387; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all vpn connections for a particular virtual wan vpn gateway.
  ## 
  let valid = call_594394.validator(path, query, header, formData, body)
  let scheme = call_594394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594394.url(scheme.get, call_594394.host, call_594394.base,
                         call_594394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594394, url, valid)

proc call*(call_594395: Call_VpnConnectionsListByVpnGateway_594387;
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
  var path_594396 = newJObject()
  var query_594397 = newJObject()
  add(path_594396, "resourceGroupName", newJString(resourceGroupName))
  add(query_594397, "api-version", newJString(apiVersion))
  add(path_594396, "gatewayName", newJString(gatewayName))
  add(path_594396, "subscriptionId", newJString(subscriptionId))
  result = call_594395.call(path_594396, query_594397, nil, nil, nil)

var vpnConnectionsListByVpnGateway* = Call_VpnConnectionsListByVpnGateway_594387(
    name: "vpnConnectionsListByVpnGateway", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections",
    validator: validate_VpnConnectionsListByVpnGateway_594388, base: "",
    url: url_VpnConnectionsListByVpnGateway_594389, schemes: {Scheme.Https})
type
  Call_VpnConnectionsCreateOrUpdate_594410 = ref object of OpenApiRestCall_593437
proc url_VpnConnectionsCreateOrUpdate_594412(protocol: Scheme; host: string;
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

proc validate_VpnConnectionsCreateOrUpdate_594411(path: JsonNode; query: JsonNode;
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
  var valid_594413 = path.getOrDefault("resourceGroupName")
  valid_594413 = validateParameter(valid_594413, JString, required = true,
                                 default = nil)
  if valid_594413 != nil:
    section.add "resourceGroupName", valid_594413
  var valid_594414 = path.getOrDefault("gatewayName")
  valid_594414 = validateParameter(valid_594414, JString, required = true,
                                 default = nil)
  if valid_594414 != nil:
    section.add "gatewayName", valid_594414
  var valid_594415 = path.getOrDefault("subscriptionId")
  valid_594415 = validateParameter(valid_594415, JString, required = true,
                                 default = nil)
  if valid_594415 != nil:
    section.add "subscriptionId", valid_594415
  var valid_594416 = path.getOrDefault("connectionName")
  valid_594416 = validateParameter(valid_594416, JString, required = true,
                                 default = nil)
  if valid_594416 != nil:
    section.add "connectionName", valid_594416
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594417 = query.getOrDefault("api-version")
  valid_594417 = validateParameter(valid_594417, JString, required = true,
                                 default = nil)
  if valid_594417 != nil:
    section.add "api-version", valid_594417
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

proc call*(call_594419: Call_VpnConnectionsCreateOrUpdate_594410; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a vpn connection to a scalable vpn gateway if it doesn't exist else updates the existing connection.
  ## 
  let valid = call_594419.validator(path, query, header, formData, body)
  let scheme = call_594419.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594419.url(scheme.get, call_594419.host, call_594419.base,
                         call_594419.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594419, url, valid)

proc call*(call_594420: Call_VpnConnectionsCreateOrUpdate_594410;
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
  var path_594421 = newJObject()
  var query_594422 = newJObject()
  var body_594423 = newJObject()
  add(path_594421, "resourceGroupName", newJString(resourceGroupName))
  add(query_594422, "api-version", newJString(apiVersion))
  add(path_594421, "gatewayName", newJString(gatewayName))
  add(path_594421, "subscriptionId", newJString(subscriptionId))
  if VpnConnectionParameters != nil:
    body_594423 = VpnConnectionParameters
  add(path_594421, "connectionName", newJString(connectionName))
  result = call_594420.call(path_594421, query_594422, nil, nil, body_594423)

var vpnConnectionsCreateOrUpdate* = Call_VpnConnectionsCreateOrUpdate_594410(
    name: "vpnConnectionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections/{connectionName}",
    validator: validate_VpnConnectionsCreateOrUpdate_594411, base: "",
    url: url_VpnConnectionsCreateOrUpdate_594412, schemes: {Scheme.Https})
type
  Call_VpnConnectionsGet_594398 = ref object of OpenApiRestCall_593437
proc url_VpnConnectionsGet_594400(protocol: Scheme; host: string; base: string;
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

proc validate_VpnConnectionsGet_594399(path: JsonNode; query: JsonNode;
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
  var valid_594401 = path.getOrDefault("resourceGroupName")
  valid_594401 = validateParameter(valid_594401, JString, required = true,
                                 default = nil)
  if valid_594401 != nil:
    section.add "resourceGroupName", valid_594401
  var valid_594402 = path.getOrDefault("gatewayName")
  valid_594402 = validateParameter(valid_594402, JString, required = true,
                                 default = nil)
  if valid_594402 != nil:
    section.add "gatewayName", valid_594402
  var valid_594403 = path.getOrDefault("subscriptionId")
  valid_594403 = validateParameter(valid_594403, JString, required = true,
                                 default = nil)
  if valid_594403 != nil:
    section.add "subscriptionId", valid_594403
  var valid_594404 = path.getOrDefault("connectionName")
  valid_594404 = validateParameter(valid_594404, JString, required = true,
                                 default = nil)
  if valid_594404 != nil:
    section.add "connectionName", valid_594404
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594405 = query.getOrDefault("api-version")
  valid_594405 = validateParameter(valid_594405, JString, required = true,
                                 default = nil)
  if valid_594405 != nil:
    section.add "api-version", valid_594405
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594406: Call_VpnConnectionsGet_594398; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a vpn connection.
  ## 
  let valid = call_594406.validator(path, query, header, formData, body)
  let scheme = call_594406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594406.url(scheme.get, call_594406.host, call_594406.base,
                         call_594406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594406, url, valid)

proc call*(call_594407: Call_VpnConnectionsGet_594398; resourceGroupName: string;
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
  var path_594408 = newJObject()
  var query_594409 = newJObject()
  add(path_594408, "resourceGroupName", newJString(resourceGroupName))
  add(query_594409, "api-version", newJString(apiVersion))
  add(path_594408, "gatewayName", newJString(gatewayName))
  add(path_594408, "subscriptionId", newJString(subscriptionId))
  add(path_594408, "connectionName", newJString(connectionName))
  result = call_594407.call(path_594408, query_594409, nil, nil, nil)

var vpnConnectionsGet* = Call_VpnConnectionsGet_594398(name: "vpnConnectionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections/{connectionName}",
    validator: validate_VpnConnectionsGet_594399, base: "",
    url: url_VpnConnectionsGet_594400, schemes: {Scheme.Https})
type
  Call_VpnConnectionsDelete_594424 = ref object of OpenApiRestCall_593437
proc url_VpnConnectionsDelete_594426(protocol: Scheme; host: string; base: string;
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

proc validate_VpnConnectionsDelete_594425(path: JsonNode; query: JsonNode;
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
  var valid_594427 = path.getOrDefault("resourceGroupName")
  valid_594427 = validateParameter(valid_594427, JString, required = true,
                                 default = nil)
  if valid_594427 != nil:
    section.add "resourceGroupName", valid_594427
  var valid_594428 = path.getOrDefault("gatewayName")
  valid_594428 = validateParameter(valid_594428, JString, required = true,
                                 default = nil)
  if valid_594428 != nil:
    section.add "gatewayName", valid_594428
  var valid_594429 = path.getOrDefault("subscriptionId")
  valid_594429 = validateParameter(valid_594429, JString, required = true,
                                 default = nil)
  if valid_594429 != nil:
    section.add "subscriptionId", valid_594429
  var valid_594430 = path.getOrDefault("connectionName")
  valid_594430 = validateParameter(valid_594430, JString, required = true,
                                 default = nil)
  if valid_594430 != nil:
    section.add "connectionName", valid_594430
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594431 = query.getOrDefault("api-version")
  valid_594431 = validateParameter(valid_594431, JString, required = true,
                                 default = nil)
  if valid_594431 != nil:
    section.add "api-version", valid_594431
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594432: Call_VpnConnectionsDelete_594424; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a vpn connection.
  ## 
  let valid = call_594432.validator(path, query, header, formData, body)
  let scheme = call_594432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594432.url(scheme.get, call_594432.host, call_594432.base,
                         call_594432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594432, url, valid)

proc call*(call_594433: Call_VpnConnectionsDelete_594424;
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
  var path_594434 = newJObject()
  var query_594435 = newJObject()
  add(path_594434, "resourceGroupName", newJString(resourceGroupName))
  add(query_594435, "api-version", newJString(apiVersion))
  add(path_594434, "gatewayName", newJString(gatewayName))
  add(path_594434, "subscriptionId", newJString(subscriptionId))
  add(path_594434, "connectionName", newJString(connectionName))
  result = call_594433.call(path_594434, query_594435, nil, nil, nil)

var vpnConnectionsDelete* = Call_VpnConnectionsDelete_594424(
    name: "vpnConnectionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections/{connectionName}",
    validator: validate_VpnConnectionsDelete_594425, base: "",
    url: url_VpnConnectionsDelete_594426, schemes: {Scheme.Https})
type
  Call_VpnLinkConnectionsListByVpnConnection_594436 = ref object of OpenApiRestCall_593437
proc url_VpnLinkConnectionsListByVpnConnection_594438(protocol: Scheme;
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

proc validate_VpnLinkConnectionsListByVpnConnection_594437(path: JsonNode;
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
  var valid_594439 = path.getOrDefault("resourceGroupName")
  valid_594439 = validateParameter(valid_594439, JString, required = true,
                                 default = nil)
  if valid_594439 != nil:
    section.add "resourceGroupName", valid_594439
  var valid_594440 = path.getOrDefault("gatewayName")
  valid_594440 = validateParameter(valid_594440, JString, required = true,
                                 default = nil)
  if valid_594440 != nil:
    section.add "gatewayName", valid_594440
  var valid_594441 = path.getOrDefault("subscriptionId")
  valid_594441 = validateParameter(valid_594441, JString, required = true,
                                 default = nil)
  if valid_594441 != nil:
    section.add "subscriptionId", valid_594441
  var valid_594442 = path.getOrDefault("connectionName")
  valid_594442 = validateParameter(valid_594442, JString, required = true,
                                 default = nil)
  if valid_594442 != nil:
    section.add "connectionName", valid_594442
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594443 = query.getOrDefault("api-version")
  valid_594443 = validateParameter(valid_594443, JString, required = true,
                                 default = nil)
  if valid_594443 != nil:
    section.add "api-version", valid_594443
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594444: Call_VpnLinkConnectionsListByVpnConnection_594436;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all vpn site link connections for a particular virtual wan vpn gateway vpn connection.
  ## 
  let valid = call_594444.validator(path, query, header, formData, body)
  let scheme = call_594444.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594444.url(scheme.get, call_594444.host, call_594444.base,
                         call_594444.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594444, url, valid)

proc call*(call_594445: Call_VpnLinkConnectionsListByVpnConnection_594436;
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
  var path_594446 = newJObject()
  var query_594447 = newJObject()
  add(path_594446, "resourceGroupName", newJString(resourceGroupName))
  add(query_594447, "api-version", newJString(apiVersion))
  add(path_594446, "gatewayName", newJString(gatewayName))
  add(path_594446, "subscriptionId", newJString(subscriptionId))
  add(path_594446, "connectionName", newJString(connectionName))
  result = call_594445.call(path_594446, query_594447, nil, nil, nil)

var vpnLinkConnectionsListByVpnConnection* = Call_VpnLinkConnectionsListByVpnConnection_594436(
    name: "vpnLinkConnectionsListByVpnConnection", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections/{connectionName}/vpnLinkConnections",
    validator: validate_VpnLinkConnectionsListByVpnConnection_594437, base: "",
    url: url_VpnLinkConnectionsListByVpnConnection_594438, schemes: {Scheme.Https})
type
  Call_VpnSiteLinkConnectionsGet_594448 = ref object of OpenApiRestCall_593437
proc url_VpnSiteLinkConnectionsGet_594450(protocol: Scheme; host: string;
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

proc validate_VpnSiteLinkConnectionsGet_594449(path: JsonNode; query: JsonNode;
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
  var valid_594451 = path.getOrDefault("resourceGroupName")
  valid_594451 = validateParameter(valid_594451, JString, required = true,
                                 default = nil)
  if valid_594451 != nil:
    section.add "resourceGroupName", valid_594451
  var valid_594452 = path.getOrDefault("gatewayName")
  valid_594452 = validateParameter(valid_594452, JString, required = true,
                                 default = nil)
  if valid_594452 != nil:
    section.add "gatewayName", valid_594452
  var valid_594453 = path.getOrDefault("subscriptionId")
  valid_594453 = validateParameter(valid_594453, JString, required = true,
                                 default = nil)
  if valid_594453 != nil:
    section.add "subscriptionId", valid_594453
  var valid_594454 = path.getOrDefault("linkConnectionName")
  valid_594454 = validateParameter(valid_594454, JString, required = true,
                                 default = nil)
  if valid_594454 != nil:
    section.add "linkConnectionName", valid_594454
  var valid_594455 = path.getOrDefault("connectionName")
  valid_594455 = validateParameter(valid_594455, JString, required = true,
                                 default = nil)
  if valid_594455 != nil:
    section.add "connectionName", valid_594455
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594456 = query.getOrDefault("api-version")
  valid_594456 = validateParameter(valid_594456, JString, required = true,
                                 default = nil)
  if valid_594456 != nil:
    section.add "api-version", valid_594456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594457: Call_VpnSiteLinkConnectionsGet_594448; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a vpn site link connection.
  ## 
  let valid = call_594457.validator(path, query, header, formData, body)
  let scheme = call_594457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594457.url(scheme.get, call_594457.host, call_594457.base,
                         call_594457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594457, url, valid)

proc call*(call_594458: Call_VpnSiteLinkConnectionsGet_594448;
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
  var path_594459 = newJObject()
  var query_594460 = newJObject()
  add(path_594459, "resourceGroupName", newJString(resourceGroupName))
  add(query_594460, "api-version", newJString(apiVersion))
  add(path_594459, "gatewayName", newJString(gatewayName))
  add(path_594459, "subscriptionId", newJString(subscriptionId))
  add(path_594459, "linkConnectionName", newJString(linkConnectionName))
  add(path_594459, "connectionName", newJString(connectionName))
  result = call_594458.call(path_594459, query_594460, nil, nil, nil)

var vpnSiteLinkConnectionsGet* = Call_VpnSiteLinkConnectionsGet_594448(
    name: "vpnSiteLinkConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/{gatewayName}/vpnConnections/{connectionName}/vpnLinkConnections/{linkConnectionName}",
    validator: validate_VpnSiteLinkConnectionsGet_594449, base: "",
    url: url_VpnSiteLinkConnectionsGet_594450, schemes: {Scheme.Https})
type
  Call_VpnSitesListByResourceGroup_594461 = ref object of OpenApiRestCall_593437
proc url_VpnSitesListByResourceGroup_594463(protocol: Scheme; host: string;
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

proc validate_VpnSitesListByResourceGroup_594462(path: JsonNode; query: JsonNode;
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
  var valid_594464 = path.getOrDefault("resourceGroupName")
  valid_594464 = validateParameter(valid_594464, JString, required = true,
                                 default = nil)
  if valid_594464 != nil:
    section.add "resourceGroupName", valid_594464
  var valid_594465 = path.getOrDefault("subscriptionId")
  valid_594465 = validateParameter(valid_594465, JString, required = true,
                                 default = nil)
  if valid_594465 != nil:
    section.add "subscriptionId", valid_594465
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594466 = query.getOrDefault("api-version")
  valid_594466 = validateParameter(valid_594466, JString, required = true,
                                 default = nil)
  if valid_594466 != nil:
    section.add "api-version", valid_594466
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594467: Call_VpnSitesListByResourceGroup_594461; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the vpnSites in a resource group.
  ## 
  let valid = call_594467.validator(path, query, header, formData, body)
  let scheme = call_594467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594467.url(scheme.get, call_594467.host, call_594467.base,
                         call_594467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594467, url, valid)

proc call*(call_594468: Call_VpnSitesListByResourceGroup_594461;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## vpnSitesListByResourceGroup
  ## Lists all the vpnSites in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name of the VpnSite.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594469 = newJObject()
  var query_594470 = newJObject()
  add(path_594469, "resourceGroupName", newJString(resourceGroupName))
  add(query_594470, "api-version", newJString(apiVersion))
  add(path_594469, "subscriptionId", newJString(subscriptionId))
  result = call_594468.call(path_594469, query_594470, nil, nil, nil)

var vpnSitesListByResourceGroup* = Call_VpnSitesListByResourceGroup_594461(
    name: "vpnSitesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites",
    validator: validate_VpnSitesListByResourceGroup_594462, base: "",
    url: url_VpnSitesListByResourceGroup_594463, schemes: {Scheme.Https})
type
  Call_VpnSitesCreateOrUpdate_594482 = ref object of OpenApiRestCall_593437
proc url_VpnSitesCreateOrUpdate_594484(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSitesCreateOrUpdate_594483(path: JsonNode; query: JsonNode;
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
  var valid_594485 = path.getOrDefault("resourceGroupName")
  valid_594485 = validateParameter(valid_594485, JString, required = true,
                                 default = nil)
  if valid_594485 != nil:
    section.add "resourceGroupName", valid_594485
  var valid_594486 = path.getOrDefault("vpnSiteName")
  valid_594486 = validateParameter(valid_594486, JString, required = true,
                                 default = nil)
  if valid_594486 != nil:
    section.add "vpnSiteName", valid_594486
  var valid_594487 = path.getOrDefault("subscriptionId")
  valid_594487 = validateParameter(valid_594487, JString, required = true,
                                 default = nil)
  if valid_594487 != nil:
    section.add "subscriptionId", valid_594487
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594488 = query.getOrDefault("api-version")
  valid_594488 = validateParameter(valid_594488, JString, required = true,
                                 default = nil)
  if valid_594488 != nil:
    section.add "api-version", valid_594488
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

proc call*(call_594490: Call_VpnSitesCreateOrUpdate_594482; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a VpnSite resource if it doesn't exist else updates the existing VpnSite.
  ## 
  let valid = call_594490.validator(path, query, header, formData, body)
  let scheme = call_594490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594490.url(scheme.get, call_594490.host, call_594490.base,
                         call_594490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594490, url, valid)

proc call*(call_594491: Call_VpnSitesCreateOrUpdate_594482;
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
  var path_594492 = newJObject()
  var query_594493 = newJObject()
  var body_594494 = newJObject()
  add(path_594492, "resourceGroupName", newJString(resourceGroupName))
  add(query_594493, "api-version", newJString(apiVersion))
  add(path_594492, "vpnSiteName", newJString(vpnSiteName))
  add(path_594492, "subscriptionId", newJString(subscriptionId))
  if VpnSiteParameters != nil:
    body_594494 = VpnSiteParameters
  result = call_594491.call(path_594492, query_594493, nil, nil, body_594494)

var vpnSitesCreateOrUpdate* = Call_VpnSitesCreateOrUpdate_594482(
    name: "vpnSitesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}",
    validator: validate_VpnSitesCreateOrUpdate_594483, base: "",
    url: url_VpnSitesCreateOrUpdate_594484, schemes: {Scheme.Https})
type
  Call_VpnSitesGet_594471 = ref object of OpenApiRestCall_593437
proc url_VpnSitesGet_594473(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSitesGet_594472(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594474 = path.getOrDefault("resourceGroupName")
  valid_594474 = validateParameter(valid_594474, JString, required = true,
                                 default = nil)
  if valid_594474 != nil:
    section.add "resourceGroupName", valid_594474
  var valid_594475 = path.getOrDefault("vpnSiteName")
  valid_594475 = validateParameter(valid_594475, JString, required = true,
                                 default = nil)
  if valid_594475 != nil:
    section.add "vpnSiteName", valid_594475
  var valid_594476 = path.getOrDefault("subscriptionId")
  valid_594476 = validateParameter(valid_594476, JString, required = true,
                                 default = nil)
  if valid_594476 != nil:
    section.add "subscriptionId", valid_594476
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594477 = query.getOrDefault("api-version")
  valid_594477 = validateParameter(valid_594477, JString, required = true,
                                 default = nil)
  if valid_594477 != nil:
    section.add "api-version", valid_594477
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594478: Call_VpnSitesGet_594471; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a VPN site.
  ## 
  let valid = call_594478.validator(path, query, header, formData, body)
  let scheme = call_594478.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594478.url(scheme.get, call_594478.host, call_594478.base,
                         call_594478.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594478, url, valid)

proc call*(call_594479: Call_VpnSitesGet_594471; resourceGroupName: string;
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
  var path_594480 = newJObject()
  var query_594481 = newJObject()
  add(path_594480, "resourceGroupName", newJString(resourceGroupName))
  add(query_594481, "api-version", newJString(apiVersion))
  add(path_594480, "vpnSiteName", newJString(vpnSiteName))
  add(path_594480, "subscriptionId", newJString(subscriptionId))
  result = call_594479.call(path_594480, query_594481, nil, nil, nil)

var vpnSitesGet* = Call_VpnSitesGet_594471(name: "vpnSitesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}",
                                        validator: validate_VpnSitesGet_594472,
                                        base: "", url: url_VpnSitesGet_594473,
                                        schemes: {Scheme.Https})
type
  Call_VpnSitesUpdateTags_594506 = ref object of OpenApiRestCall_593437
proc url_VpnSitesUpdateTags_594508(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSitesUpdateTags_594507(path: JsonNode; query: JsonNode;
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
  var valid_594509 = path.getOrDefault("resourceGroupName")
  valid_594509 = validateParameter(valid_594509, JString, required = true,
                                 default = nil)
  if valid_594509 != nil:
    section.add "resourceGroupName", valid_594509
  var valid_594510 = path.getOrDefault("vpnSiteName")
  valid_594510 = validateParameter(valid_594510, JString, required = true,
                                 default = nil)
  if valid_594510 != nil:
    section.add "vpnSiteName", valid_594510
  var valid_594511 = path.getOrDefault("subscriptionId")
  valid_594511 = validateParameter(valid_594511, JString, required = true,
                                 default = nil)
  if valid_594511 != nil:
    section.add "subscriptionId", valid_594511
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594512 = query.getOrDefault("api-version")
  valid_594512 = validateParameter(valid_594512, JString, required = true,
                                 default = nil)
  if valid_594512 != nil:
    section.add "api-version", valid_594512
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

proc call*(call_594514: Call_VpnSitesUpdateTags_594506; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates VpnSite tags.
  ## 
  let valid = call_594514.validator(path, query, header, formData, body)
  let scheme = call_594514.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594514.url(scheme.get, call_594514.host, call_594514.base,
                         call_594514.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594514, url, valid)

proc call*(call_594515: Call_VpnSitesUpdateTags_594506; resourceGroupName: string;
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
  var path_594516 = newJObject()
  var query_594517 = newJObject()
  var body_594518 = newJObject()
  add(path_594516, "resourceGroupName", newJString(resourceGroupName))
  add(query_594517, "api-version", newJString(apiVersion))
  add(path_594516, "vpnSiteName", newJString(vpnSiteName))
  add(path_594516, "subscriptionId", newJString(subscriptionId))
  if VpnSiteParameters != nil:
    body_594518 = VpnSiteParameters
  result = call_594515.call(path_594516, query_594517, nil, nil, body_594518)

var vpnSitesUpdateTags* = Call_VpnSitesUpdateTags_594506(
    name: "vpnSitesUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}",
    validator: validate_VpnSitesUpdateTags_594507, base: "",
    url: url_VpnSitesUpdateTags_594508, schemes: {Scheme.Https})
type
  Call_VpnSitesDelete_594495 = ref object of OpenApiRestCall_593437
proc url_VpnSitesDelete_594497(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSitesDelete_594496(path: JsonNode; query: JsonNode;
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
  var valid_594498 = path.getOrDefault("resourceGroupName")
  valid_594498 = validateParameter(valid_594498, JString, required = true,
                                 default = nil)
  if valid_594498 != nil:
    section.add "resourceGroupName", valid_594498
  var valid_594499 = path.getOrDefault("vpnSiteName")
  valid_594499 = validateParameter(valid_594499, JString, required = true,
                                 default = nil)
  if valid_594499 != nil:
    section.add "vpnSiteName", valid_594499
  var valid_594500 = path.getOrDefault("subscriptionId")
  valid_594500 = validateParameter(valid_594500, JString, required = true,
                                 default = nil)
  if valid_594500 != nil:
    section.add "subscriptionId", valid_594500
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594501 = query.getOrDefault("api-version")
  valid_594501 = validateParameter(valid_594501, JString, required = true,
                                 default = nil)
  if valid_594501 != nil:
    section.add "api-version", valid_594501
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594502: Call_VpnSitesDelete_594495; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a VpnSite.
  ## 
  let valid = call_594502.validator(path, query, header, formData, body)
  let scheme = call_594502.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594502.url(scheme.get, call_594502.host, call_594502.base,
                         call_594502.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594502, url, valid)

proc call*(call_594503: Call_VpnSitesDelete_594495; resourceGroupName: string;
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
  var path_594504 = newJObject()
  var query_594505 = newJObject()
  add(path_594504, "resourceGroupName", newJString(resourceGroupName))
  add(query_594505, "api-version", newJString(apiVersion))
  add(path_594504, "vpnSiteName", newJString(vpnSiteName))
  add(path_594504, "subscriptionId", newJString(subscriptionId))
  result = call_594503.call(path_594504, query_594505, nil, nil, nil)

var vpnSitesDelete* = Call_VpnSitesDelete_594495(name: "vpnSitesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}",
    validator: validate_VpnSitesDelete_594496, base: "", url: url_VpnSitesDelete_594497,
    schemes: {Scheme.Https})
type
  Call_VpnSiteLinksListByVpnSite_594519 = ref object of OpenApiRestCall_593437
proc url_VpnSiteLinksListByVpnSite_594521(protocol: Scheme; host: string;
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

proc validate_VpnSiteLinksListByVpnSite_594520(path: JsonNode; query: JsonNode;
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
  var valid_594522 = path.getOrDefault("resourceGroupName")
  valid_594522 = validateParameter(valid_594522, JString, required = true,
                                 default = nil)
  if valid_594522 != nil:
    section.add "resourceGroupName", valid_594522
  var valid_594523 = path.getOrDefault("vpnSiteName")
  valid_594523 = validateParameter(valid_594523, JString, required = true,
                                 default = nil)
  if valid_594523 != nil:
    section.add "vpnSiteName", valid_594523
  var valid_594524 = path.getOrDefault("subscriptionId")
  valid_594524 = validateParameter(valid_594524, JString, required = true,
                                 default = nil)
  if valid_594524 != nil:
    section.add "subscriptionId", valid_594524
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594525 = query.getOrDefault("api-version")
  valid_594525 = validateParameter(valid_594525, JString, required = true,
                                 default = nil)
  if valid_594525 != nil:
    section.add "api-version", valid_594525
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594526: Call_VpnSiteLinksListByVpnSite_594519; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the vpnSiteLinks in a resource group for a vpn site.
  ## 
  let valid = call_594526.validator(path, query, header, formData, body)
  let scheme = call_594526.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594526.url(scheme.get, call_594526.host, call_594526.base,
                         call_594526.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594526, url, valid)

proc call*(call_594527: Call_VpnSiteLinksListByVpnSite_594519;
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
  var path_594528 = newJObject()
  var query_594529 = newJObject()
  add(path_594528, "resourceGroupName", newJString(resourceGroupName))
  add(query_594529, "api-version", newJString(apiVersion))
  add(path_594528, "vpnSiteName", newJString(vpnSiteName))
  add(path_594528, "subscriptionId", newJString(subscriptionId))
  result = call_594527.call(path_594528, query_594529, nil, nil, nil)

var vpnSiteLinksListByVpnSite* = Call_VpnSiteLinksListByVpnSite_594519(
    name: "vpnSiteLinksListByVpnSite", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}/vpnSiteLinks",
    validator: validate_VpnSiteLinksListByVpnSite_594520, base: "",
    url: url_VpnSiteLinksListByVpnSite_594521, schemes: {Scheme.Https})
type
  Call_VpnSiteLinksGet_594530 = ref object of OpenApiRestCall_593437
proc url_VpnSiteLinksGet_594532(protocol: Scheme; host: string; base: string;
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

proc validate_VpnSiteLinksGet_594531(path: JsonNode; query: JsonNode;
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
  var valid_594533 = path.getOrDefault("resourceGroupName")
  valid_594533 = validateParameter(valid_594533, JString, required = true,
                                 default = nil)
  if valid_594533 != nil:
    section.add "resourceGroupName", valid_594533
  var valid_594534 = path.getOrDefault("vpnSiteName")
  valid_594534 = validateParameter(valid_594534, JString, required = true,
                                 default = nil)
  if valid_594534 != nil:
    section.add "vpnSiteName", valid_594534
  var valid_594535 = path.getOrDefault("subscriptionId")
  valid_594535 = validateParameter(valid_594535, JString, required = true,
                                 default = nil)
  if valid_594535 != nil:
    section.add "subscriptionId", valid_594535
  var valid_594536 = path.getOrDefault("vpnSiteLinkName")
  valid_594536 = validateParameter(valid_594536, JString, required = true,
                                 default = nil)
  if valid_594536 != nil:
    section.add "vpnSiteLinkName", valid_594536
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594537 = query.getOrDefault("api-version")
  valid_594537 = validateParameter(valid_594537, JString, required = true,
                                 default = nil)
  if valid_594537 != nil:
    section.add "api-version", valid_594537
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594538: Call_VpnSiteLinksGet_594530; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a VPN site link.
  ## 
  let valid = call_594538.validator(path, query, header, formData, body)
  let scheme = call_594538.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594538.url(scheme.get, call_594538.host, call_594538.base,
                         call_594538.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594538, url, valid)

proc call*(call_594539: Call_VpnSiteLinksGet_594530; resourceGroupName: string;
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
  var path_594540 = newJObject()
  var query_594541 = newJObject()
  add(path_594540, "resourceGroupName", newJString(resourceGroupName))
  add(query_594541, "api-version", newJString(apiVersion))
  add(path_594540, "vpnSiteName", newJString(vpnSiteName))
  add(path_594540, "subscriptionId", newJString(subscriptionId))
  add(path_594540, "vpnSiteLinkName", newJString(vpnSiteLinkName))
  result = call_594539.call(path_594540, query_594541, nil, nil, nil)

var vpnSiteLinksGet* = Call_VpnSiteLinksGet_594530(name: "vpnSiteLinksGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnSites/{vpnSiteName}/vpnSiteLinks/{vpnSiteLinkName}",
    validator: validate_VpnSiteLinksGet_594531, base: "", url: url_VpnSiteLinksGet_594532,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
