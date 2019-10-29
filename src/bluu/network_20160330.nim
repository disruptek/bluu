
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2016-03-30
## termsOfService: (not provided)
## license: (not provided)
## 
## The Microsoft Azure Network management API provides a RESTful set of web services that interact with Microsoft Azure Networks service to manage your network resources. The API has entities that capture the relationship between an end user and the Microsoft Azure Networks service.
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

  OpenApiRestCall_563549 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563549](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563549): Option[Scheme] {.used.} =
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
  macServiceName = "network"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ApplicationGatewaysListAll_563771 = ref object of OpenApiRestCall_563549
proc url_ApplicationGatewaysListAll_563773(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/applicationGateways")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGatewaysListAll_563772(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List application gateway operation retrieves all the application gateways in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563948 = path.getOrDefault("subscriptionId")
  valid_563948 = validateParameter(valid_563948, JString, required = true,
                                 default = nil)
  if valid_563948 != nil:
    section.add "subscriptionId", valid_563948
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563949 = query.getOrDefault("api-version")
  valid_563949 = validateParameter(valid_563949, JString, required = true,
                                 default = nil)
  if valid_563949 != nil:
    section.add "api-version", valid_563949
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563972: Call_ApplicationGatewaysListAll_563771; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List application gateway operation retrieves all the application gateways in a subscription.
  ## 
  let valid = call_563972.validator(path, query, header, formData, body)
  let scheme = call_563972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563972.url(scheme.get, call_563972.host, call_563972.base,
                         call_563972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563972, url, valid)

proc call*(call_564043: Call_ApplicationGatewaysListAll_563771; apiVersion: string;
          subscriptionId: string): Recallable =
  ## applicationGatewaysListAll
  ## The List application gateway operation retrieves all the application gateways in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564044 = newJObject()
  var query_564046 = newJObject()
  add(query_564046, "api-version", newJString(apiVersion))
  add(path_564044, "subscriptionId", newJString(subscriptionId))
  result = call_564043.call(path_564044, query_564046, nil, nil, nil)

var applicationGatewaysListAll* = Call_ApplicationGatewaysListAll_563771(
    name: "applicationGatewaysListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/applicationGateways",
    validator: validate_ApplicationGatewaysListAll_563772, base: "",
    url: url_ApplicationGatewaysListAll_563773, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsListAll_564085 = ref object of OpenApiRestCall_563549
proc url_ExpressRouteCircuitsListAll_564087(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteCircuits")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCircuitsListAll_564086(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List ExpressRouteCircuit operation retrieves all the ExpressRouteCircuits in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564088 = path.getOrDefault("subscriptionId")
  valid_564088 = validateParameter(valid_564088, JString, required = true,
                                 default = nil)
  if valid_564088 != nil:
    section.add "subscriptionId", valid_564088
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564089 = query.getOrDefault("api-version")
  valid_564089 = validateParameter(valid_564089, JString, required = true,
                                 default = nil)
  if valid_564089 != nil:
    section.add "api-version", valid_564089
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564090: Call_ExpressRouteCircuitsListAll_564085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List ExpressRouteCircuit operation retrieves all the ExpressRouteCircuits in a subscription.
  ## 
  let valid = call_564090.validator(path, query, header, formData, body)
  let scheme = call_564090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564090.url(scheme.get, call_564090.host, call_564090.base,
                         call_564090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564090, url, valid)

proc call*(call_564091: Call_ExpressRouteCircuitsListAll_564085;
          apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteCircuitsListAll
  ## The List ExpressRouteCircuit operation retrieves all the ExpressRouteCircuits in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564092 = newJObject()
  var query_564093 = newJObject()
  add(query_564093, "api-version", newJString(apiVersion))
  add(path_564092, "subscriptionId", newJString(subscriptionId))
  result = call_564091.call(path_564092, query_564093, nil, nil, nil)

var expressRouteCircuitsListAll* = Call_ExpressRouteCircuitsListAll_564085(
    name: "expressRouteCircuitsListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/expressRouteCircuits",
    validator: validate_ExpressRouteCircuitsListAll_564086, base: "",
    url: url_ExpressRouteCircuitsListAll_564087, schemes: {Scheme.Https})
type
  Call_ExpressRouteServiceProvidersList_564094 = ref object of OpenApiRestCall_563549
proc url_ExpressRouteServiceProvidersList_564096(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteServiceProviders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteServiceProvidersList_564095(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List ExpressRouteServiceProvider operation retrieves all the available ExpressRouteServiceProviders.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564097 = path.getOrDefault("subscriptionId")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "subscriptionId", valid_564097
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564098 = query.getOrDefault("api-version")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "api-version", valid_564098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564099: Call_ExpressRouteServiceProvidersList_564094;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The List ExpressRouteServiceProvider operation retrieves all the available ExpressRouteServiceProviders.
  ## 
  let valid = call_564099.validator(path, query, header, formData, body)
  let scheme = call_564099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564099.url(scheme.get, call_564099.host, call_564099.base,
                         call_564099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564099, url, valid)

proc call*(call_564100: Call_ExpressRouteServiceProvidersList_564094;
          apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteServiceProvidersList
  ## The List ExpressRouteServiceProvider operation retrieves all the available ExpressRouteServiceProviders.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564101 = newJObject()
  var query_564102 = newJObject()
  add(query_564102, "api-version", newJString(apiVersion))
  add(path_564101, "subscriptionId", newJString(subscriptionId))
  result = call_564100.call(path_564101, query_564102, nil, nil, nil)

var expressRouteServiceProvidersList* = Call_ExpressRouteServiceProvidersList_564094(
    name: "expressRouteServiceProvidersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/expressRouteServiceProviders",
    validator: validate_ExpressRouteServiceProvidersList_564095, base: "",
    url: url_ExpressRouteServiceProvidersList_564096, schemes: {Scheme.Https})
type
  Call_LoadBalancersListAll_564103 = ref object of OpenApiRestCall_563549
proc url_LoadBalancersListAll_564105(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/loadBalancers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoadBalancersListAll_564104(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List loadBalancer operation retrieves all the load balancers in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564106 = path.getOrDefault("subscriptionId")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "subscriptionId", valid_564106
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564107 = query.getOrDefault("api-version")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "api-version", valid_564107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564108: Call_LoadBalancersListAll_564103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List loadBalancer operation retrieves all the load balancers in a subscription.
  ## 
  let valid = call_564108.validator(path, query, header, formData, body)
  let scheme = call_564108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564108.url(scheme.get, call_564108.host, call_564108.base,
                         call_564108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564108, url, valid)

proc call*(call_564109: Call_LoadBalancersListAll_564103; apiVersion: string;
          subscriptionId: string): Recallable =
  ## loadBalancersListAll
  ## The List loadBalancer operation retrieves all the load balancers in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564110 = newJObject()
  var query_564111 = newJObject()
  add(query_564111, "api-version", newJString(apiVersion))
  add(path_564110, "subscriptionId", newJString(subscriptionId))
  result = call_564109.call(path_564110, query_564111, nil, nil, nil)

var loadBalancersListAll* = Call_LoadBalancersListAll_564103(
    name: "loadBalancersListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/loadBalancers",
    validator: validate_LoadBalancersListAll_564104, base: "",
    url: url_LoadBalancersListAll_564105, schemes: {Scheme.Https})
type
  Call_CheckDnsNameAvailability_564112 = ref object of OpenApiRestCall_563549
proc url_CheckDnsNameAvailability_564114(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/CheckDnsNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CheckDnsNameAvailability_564113(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether a domain name in the cloudapp.net zone is available for use.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The location of the domain name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564115 = path.getOrDefault("subscriptionId")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "subscriptionId", valid_564115
  var valid_564116 = path.getOrDefault("location")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "location", valid_564116
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   domainNameLabel: JString
  ##                  : The domain name to be verified. It must conform to the following regular expression: ^[a-z][a-z0-9-]{1,61}[a-z0-9]$.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564117 = query.getOrDefault("api-version")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "api-version", valid_564117
  var valid_564118 = query.getOrDefault("domainNameLabel")
  valid_564118 = validateParameter(valid_564118, JString, required = false,
                                 default = nil)
  if valid_564118 != nil:
    section.add "domainNameLabel", valid_564118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564119: Call_CheckDnsNameAvailability_564112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether a domain name in the cloudapp.net zone is available for use.
  ## 
  let valid = call_564119.validator(path, query, header, formData, body)
  let scheme = call_564119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564119.url(scheme.get, call_564119.host, call_564119.base,
                         call_564119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564119, url, valid)

proc call*(call_564120: Call_CheckDnsNameAvailability_564112; apiVersion: string;
          subscriptionId: string; location: string; domainNameLabel: string = ""): Recallable =
  ## checkDnsNameAvailability
  ## Checks whether a domain name in the cloudapp.net zone is available for use.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainNameLabel: string
  ##                  : The domain name to be verified. It must conform to the following regular expression: ^[a-z][a-z0-9-]{1,61}[a-z0-9]$.
  ##   location: string (required)
  ##           : The location of the domain name
  var path_564121 = newJObject()
  var query_564122 = newJObject()
  add(query_564122, "api-version", newJString(apiVersion))
  add(path_564121, "subscriptionId", newJString(subscriptionId))
  add(query_564122, "domainNameLabel", newJString(domainNameLabel))
  add(path_564121, "location", newJString(location))
  result = call_564120.call(path_564121, query_564122, nil, nil, nil)

var checkDnsNameAvailability* = Call_CheckDnsNameAvailability_564112(
    name: "checkDnsNameAvailability", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/locations/{location}/CheckDnsNameAvailability",
    validator: validate_CheckDnsNameAvailability_564113, base: "",
    url: url_CheckDnsNameAvailability_564114, schemes: {Scheme.Https})
type
  Call_UsagesList_564123 = ref object of OpenApiRestCall_563549
proc url_UsagesList_564125(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsagesList_564124(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists compute usages for a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The location upon which resource usage is queried.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564126 = path.getOrDefault("subscriptionId")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "subscriptionId", valid_564126
  var valid_564127 = path.getOrDefault("location")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "location", valid_564127
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564128 = query.getOrDefault("api-version")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "api-version", valid_564128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564129: Call_UsagesList_564123; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists compute usages for a subscription.
  ## 
  let valid = call_564129.validator(path, query, header, formData, body)
  let scheme = call_564129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564129.url(scheme.get, call_564129.host, call_564129.base,
                         call_564129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564129, url, valid)

proc call*(call_564130: Call_UsagesList_564123; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## usagesList
  ## Lists compute usages for a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location upon which resource usage is queried.
  var path_564131 = newJObject()
  var query_564132 = newJObject()
  add(query_564132, "api-version", newJString(apiVersion))
  add(path_564131, "subscriptionId", newJString(subscriptionId))
  add(path_564131, "location", newJString(location))
  result = call_564130.call(path_564131, query_564132, nil, nil, nil)

var usagesList* = Call_UsagesList_564123(name: "usagesList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/locations/{location}/usages",
                                      validator: validate_UsagesList_564124,
                                      base: "", url: url_UsagesList_564125,
                                      schemes: {Scheme.Https})
type
  Call_NetworkInterfacesListAll_564133 = ref object of OpenApiRestCall_563549
proc url_NetworkInterfacesListAll_564135(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkInterfaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfacesListAll_564134(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List networkInterfaces operation retrieves all the networkInterfaces in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564136 = path.getOrDefault("subscriptionId")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "subscriptionId", valid_564136
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564137 = query.getOrDefault("api-version")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "api-version", valid_564137
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564138: Call_NetworkInterfacesListAll_564133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List networkInterfaces operation retrieves all the networkInterfaces in a subscription.
  ## 
  let valid = call_564138.validator(path, query, header, formData, body)
  let scheme = call_564138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564138.url(scheme.get, call_564138.host, call_564138.base,
                         call_564138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564138, url, valid)

proc call*(call_564139: Call_NetworkInterfacesListAll_564133; apiVersion: string;
          subscriptionId: string): Recallable =
  ## networkInterfacesListAll
  ## The List networkInterfaces operation retrieves all the networkInterfaces in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564140 = newJObject()
  var query_564141 = newJObject()
  add(query_564141, "api-version", newJString(apiVersion))
  add(path_564140, "subscriptionId", newJString(subscriptionId))
  result = call_564139.call(path_564140, query_564141, nil, nil, nil)

var networkInterfacesListAll* = Call_NetworkInterfacesListAll_564133(
    name: "networkInterfacesListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/networkInterfaces",
    validator: validate_NetworkInterfacesListAll_564134, base: "",
    url: url_NetworkInterfacesListAll_564135, schemes: {Scheme.Https})
type
  Call_NetworkSecurityGroupsListAll_564142 = ref object of OpenApiRestCall_563549
proc url_NetworkSecurityGroupsListAll_564144(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkSecurityGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkSecurityGroupsListAll_564143(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The list NetworkSecurityGroups returns all network security groups in a subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564145 = path.getOrDefault("subscriptionId")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "subscriptionId", valid_564145
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564146 = query.getOrDefault("api-version")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "api-version", valid_564146
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564147: Call_NetworkSecurityGroupsListAll_564142; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list NetworkSecurityGroups returns all network security groups in a subscription
  ## 
  let valid = call_564147.validator(path, query, header, formData, body)
  let scheme = call_564147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564147.url(scheme.get, call_564147.host, call_564147.base,
                         call_564147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564147, url, valid)

proc call*(call_564148: Call_NetworkSecurityGroupsListAll_564142;
          apiVersion: string; subscriptionId: string): Recallable =
  ## networkSecurityGroupsListAll
  ## The list NetworkSecurityGroups returns all network security groups in a subscription
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564149 = newJObject()
  var query_564150 = newJObject()
  add(query_564150, "api-version", newJString(apiVersion))
  add(path_564149, "subscriptionId", newJString(subscriptionId))
  result = call_564148.call(path_564149, query_564150, nil, nil, nil)

var networkSecurityGroupsListAll* = Call_NetworkSecurityGroupsListAll_564142(
    name: "networkSecurityGroupsListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/networkSecurityGroups",
    validator: validate_NetworkSecurityGroupsListAll_564143, base: "",
    url: url_NetworkSecurityGroupsListAll_564144, schemes: {Scheme.Https})
type
  Call_PublicIPAddressesListAll_564151 = ref object of OpenApiRestCall_563549
proc url_PublicIPAddressesListAll_564153(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/publicIPAddresses")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PublicIPAddressesListAll_564152(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List publicIpAddress operation retrieves all the publicIpAddresses in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564154 = path.getOrDefault("subscriptionId")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "subscriptionId", valid_564154
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564155 = query.getOrDefault("api-version")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "api-version", valid_564155
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564156: Call_PublicIPAddressesListAll_564151; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List publicIpAddress operation retrieves all the publicIpAddresses in a subscription.
  ## 
  let valid = call_564156.validator(path, query, header, formData, body)
  let scheme = call_564156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564156.url(scheme.get, call_564156.host, call_564156.base,
                         call_564156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564156, url, valid)

proc call*(call_564157: Call_PublicIPAddressesListAll_564151; apiVersion: string;
          subscriptionId: string): Recallable =
  ## publicIPAddressesListAll
  ## The List publicIpAddress operation retrieves all the publicIpAddresses in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564158 = newJObject()
  var query_564159 = newJObject()
  add(query_564159, "api-version", newJString(apiVersion))
  add(path_564158, "subscriptionId", newJString(subscriptionId))
  result = call_564157.call(path_564158, query_564159, nil, nil, nil)

var publicIPAddressesListAll* = Call_PublicIPAddressesListAll_564151(
    name: "publicIPAddressesListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/publicIPAddresses",
    validator: validate_PublicIPAddressesListAll_564152, base: "",
    url: url_PublicIPAddressesListAll_564153, schemes: {Scheme.Https})
type
  Call_RouteTablesListAll_564160 = ref object of OpenApiRestCall_563549
proc url_RouteTablesListAll_564162(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/routeTables")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RouteTablesListAll_564161(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## The list RouteTables returns all route tables in a subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564163 = path.getOrDefault("subscriptionId")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "subscriptionId", valid_564163
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564164 = query.getOrDefault("api-version")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "api-version", valid_564164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564165: Call_RouteTablesListAll_564160; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list RouteTables returns all route tables in a subscription
  ## 
  let valid = call_564165.validator(path, query, header, formData, body)
  let scheme = call_564165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564165.url(scheme.get, call_564165.host, call_564165.base,
                         call_564165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564165, url, valid)

proc call*(call_564166: Call_RouteTablesListAll_564160; apiVersion: string;
          subscriptionId: string): Recallable =
  ## routeTablesListAll
  ## The list RouteTables returns all route tables in a subscription
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564167 = newJObject()
  var query_564168 = newJObject()
  add(query_564168, "api-version", newJString(apiVersion))
  add(path_564167, "subscriptionId", newJString(subscriptionId))
  result = call_564166.call(path_564167, query_564168, nil, nil, nil)

var routeTablesListAll* = Call_RouteTablesListAll_564160(
    name: "routeTablesListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/routeTables",
    validator: validate_RouteTablesListAll_564161, base: "",
    url: url_RouteTablesListAll_564162, schemes: {Scheme.Https})
type
  Call_VirtualNetworksListAll_564169 = ref object of OpenApiRestCall_563549
proc url_VirtualNetworksListAll_564171(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Network/virtualNetworks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksListAll_564170(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The list VirtualNetwork returns all Virtual Networks in a subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564172 = path.getOrDefault("subscriptionId")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "subscriptionId", valid_564172
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564173 = query.getOrDefault("api-version")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "api-version", valid_564173
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564174: Call_VirtualNetworksListAll_564169; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list VirtualNetwork returns all Virtual Networks in a subscription
  ## 
  let valid = call_564174.validator(path, query, header, formData, body)
  let scheme = call_564174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564174.url(scheme.get, call_564174.host, call_564174.base,
                         call_564174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564174, url, valid)

proc call*(call_564175: Call_VirtualNetworksListAll_564169; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualNetworksListAll
  ## The list VirtualNetwork returns all Virtual Networks in a subscription
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564176 = newJObject()
  var query_564177 = newJObject()
  add(query_564177, "api-version", newJString(apiVersion))
  add(path_564176, "subscriptionId", newJString(subscriptionId))
  result = call_564175.call(path_564176, query_564177, nil, nil, nil)

var virtualNetworksListAll* = Call_VirtualNetworksListAll_564169(
    name: "virtualNetworksListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/virtualNetworks",
    validator: validate_VirtualNetworksListAll_564170, base: "",
    url: url_VirtualNetworksListAll_564171, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysList_564178 = ref object of OpenApiRestCall_563549
proc url_ApplicationGatewaysList_564180(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Network/applicationGateways")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGatewaysList_564179(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List ApplicationGateway operation retrieves all the application gateways in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564181 = path.getOrDefault("subscriptionId")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "subscriptionId", valid_564181
  var valid_564182 = path.getOrDefault("resourceGroupName")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "resourceGroupName", valid_564182
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564183 = query.getOrDefault("api-version")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "api-version", valid_564183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564184: Call_ApplicationGatewaysList_564178; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List ApplicationGateway operation retrieves all the application gateways in a resource group.
  ## 
  let valid = call_564184.validator(path, query, header, formData, body)
  let scheme = call_564184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564184.url(scheme.get, call_564184.host, call_564184.base,
                         call_564184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564184, url, valid)

proc call*(call_564185: Call_ApplicationGatewaysList_564178; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## applicationGatewaysList
  ## The List ApplicationGateway operation retrieves all the application gateways in a resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564186 = newJObject()
  var query_564187 = newJObject()
  add(query_564187, "api-version", newJString(apiVersion))
  add(path_564186, "subscriptionId", newJString(subscriptionId))
  add(path_564186, "resourceGroupName", newJString(resourceGroupName))
  result = call_564185.call(path_564186, query_564187, nil, nil, nil)

var applicationGatewaysList* = Call_ApplicationGatewaysList_564178(
    name: "applicationGatewaysList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways",
    validator: validate_ApplicationGatewaysList_564179, base: "",
    url: url_ApplicationGatewaysList_564180, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysCreateOrUpdate_564199 = ref object of OpenApiRestCall_563549
proc url_ApplicationGatewaysCreateOrUpdate_564201(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationGatewayName" in path,
        "`applicationGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/applicationGateways/"),
               (kind: VariableSegment, value: "applicationGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGatewaysCreateOrUpdate_564200(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put ApplicationGateway operation creates/updates a ApplicationGateway
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: JString (required)
  ##                         : The name of the ApplicationGateway.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564219 = path.getOrDefault("subscriptionId")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "subscriptionId", valid_564219
  var valid_564220 = path.getOrDefault("applicationGatewayName")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "applicationGatewayName", valid_564220
  var valid_564221 = path.getOrDefault("resourceGroupName")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "resourceGroupName", valid_564221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564222 = query.getOrDefault("api-version")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "api-version", valid_564222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/delete ApplicationGateway operation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564224: Call_ApplicationGatewaysCreateOrUpdate_564199;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put ApplicationGateway operation creates/updates a ApplicationGateway
  ## 
  let valid = call_564224.validator(path, query, header, formData, body)
  let scheme = call_564224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564224.url(scheme.get, call_564224.host, call_564224.base,
                         call_564224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564224, url, valid)

proc call*(call_564225: Call_ApplicationGatewaysCreateOrUpdate_564199;
          apiVersion: string; subscriptionId: string;
          applicationGatewayName: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## applicationGatewaysCreateOrUpdate
  ## The Put ApplicationGateway operation creates/updates a ApplicationGateway
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: string (required)
  ##                         : The name of the ApplicationGateway.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/delete ApplicationGateway operation
  var path_564226 = newJObject()
  var query_564227 = newJObject()
  var body_564228 = newJObject()
  add(query_564227, "api-version", newJString(apiVersion))
  add(path_564226, "subscriptionId", newJString(subscriptionId))
  add(path_564226, "applicationGatewayName", newJString(applicationGatewayName))
  add(path_564226, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564228 = parameters
  result = call_564225.call(path_564226, query_564227, nil, nil, body_564228)

var applicationGatewaysCreateOrUpdate* = Call_ApplicationGatewaysCreateOrUpdate_564199(
    name: "applicationGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}",
    validator: validate_ApplicationGatewaysCreateOrUpdate_564200, base: "",
    url: url_ApplicationGatewaysCreateOrUpdate_564201, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysGet_564188 = ref object of OpenApiRestCall_563549
proc url_ApplicationGatewaysGet_564190(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationGatewayName" in path,
        "`applicationGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/applicationGateways/"),
               (kind: VariableSegment, value: "applicationGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGatewaysGet_564189(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get application gateway operation retrieves information about the specified application gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: JString (required)
  ##                         : The name of the application gateway.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564191 = path.getOrDefault("subscriptionId")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "subscriptionId", valid_564191
  var valid_564192 = path.getOrDefault("applicationGatewayName")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "applicationGatewayName", valid_564192
  var valid_564193 = path.getOrDefault("resourceGroupName")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "resourceGroupName", valid_564193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564194 = query.getOrDefault("api-version")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "api-version", valid_564194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564195: Call_ApplicationGatewaysGet_564188; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get application gateway operation retrieves information about the specified application gateway.
  ## 
  let valid = call_564195.validator(path, query, header, formData, body)
  let scheme = call_564195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564195.url(scheme.get, call_564195.host, call_564195.base,
                         call_564195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564195, url, valid)

proc call*(call_564196: Call_ApplicationGatewaysGet_564188; apiVersion: string;
          subscriptionId: string; applicationGatewayName: string;
          resourceGroupName: string): Recallable =
  ## applicationGatewaysGet
  ## The Get application gateway operation retrieves information about the specified application gateway.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: string (required)
  ##                         : The name of the application gateway.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564197 = newJObject()
  var query_564198 = newJObject()
  add(query_564198, "api-version", newJString(apiVersion))
  add(path_564197, "subscriptionId", newJString(subscriptionId))
  add(path_564197, "applicationGatewayName", newJString(applicationGatewayName))
  add(path_564197, "resourceGroupName", newJString(resourceGroupName))
  result = call_564196.call(path_564197, query_564198, nil, nil, nil)

var applicationGatewaysGet* = Call_ApplicationGatewaysGet_564188(
    name: "applicationGatewaysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}",
    validator: validate_ApplicationGatewaysGet_564189, base: "",
    url: url_ApplicationGatewaysGet_564190, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysDelete_564229 = ref object of OpenApiRestCall_563549
proc url_ApplicationGatewaysDelete_564231(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationGatewayName" in path,
        "`applicationGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/applicationGateways/"),
               (kind: VariableSegment, value: "applicationGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGatewaysDelete_564230(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The delete application gateway operation deletes the specified application gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: JString (required)
  ##                         : The name of the application gateway.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564232 = path.getOrDefault("subscriptionId")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "subscriptionId", valid_564232
  var valid_564233 = path.getOrDefault("applicationGatewayName")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "applicationGatewayName", valid_564233
  var valid_564234 = path.getOrDefault("resourceGroupName")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "resourceGroupName", valid_564234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564235 = query.getOrDefault("api-version")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "api-version", valid_564235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564236: Call_ApplicationGatewaysDelete_564229; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete application gateway operation deletes the specified application gateway.
  ## 
  let valid = call_564236.validator(path, query, header, formData, body)
  let scheme = call_564236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564236.url(scheme.get, call_564236.host, call_564236.base,
                         call_564236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564236, url, valid)

proc call*(call_564237: Call_ApplicationGatewaysDelete_564229; apiVersion: string;
          subscriptionId: string; applicationGatewayName: string;
          resourceGroupName: string): Recallable =
  ## applicationGatewaysDelete
  ## The delete application gateway operation deletes the specified application gateway.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: string (required)
  ##                         : The name of the application gateway.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564238 = newJObject()
  var query_564239 = newJObject()
  add(query_564239, "api-version", newJString(apiVersion))
  add(path_564238, "subscriptionId", newJString(subscriptionId))
  add(path_564238, "applicationGatewayName", newJString(applicationGatewayName))
  add(path_564238, "resourceGroupName", newJString(resourceGroupName))
  result = call_564237.call(path_564238, query_564239, nil, nil, nil)

var applicationGatewaysDelete* = Call_ApplicationGatewaysDelete_564229(
    name: "applicationGatewaysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}",
    validator: validate_ApplicationGatewaysDelete_564230, base: "",
    url: url_ApplicationGatewaysDelete_564231, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysStart_564240 = ref object of OpenApiRestCall_563549
proc url_ApplicationGatewaysStart_564242(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationGatewayName" in path,
        "`applicationGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/applicationGateways/"),
               (kind: VariableSegment, value: "applicationGatewayName"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGatewaysStart_564241(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Start ApplicationGateway operation starts application gateway in the specified resource group through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: JString (required)
  ##                         : The name of the application gateway.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564243 = path.getOrDefault("subscriptionId")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "subscriptionId", valid_564243
  var valid_564244 = path.getOrDefault("applicationGatewayName")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "applicationGatewayName", valid_564244
  var valid_564245 = path.getOrDefault("resourceGroupName")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "resourceGroupName", valid_564245
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564246 = query.getOrDefault("api-version")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "api-version", valid_564246
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564247: Call_ApplicationGatewaysStart_564240; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Start ApplicationGateway operation starts application gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_564247.validator(path, query, header, formData, body)
  let scheme = call_564247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564247.url(scheme.get, call_564247.host, call_564247.base,
                         call_564247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564247, url, valid)

proc call*(call_564248: Call_ApplicationGatewaysStart_564240; apiVersion: string;
          subscriptionId: string; applicationGatewayName: string;
          resourceGroupName: string): Recallable =
  ## applicationGatewaysStart
  ## The Start ApplicationGateway operation starts application gateway in the specified resource group through Network resource provider.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: string (required)
  ##                         : The name of the application gateway.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564249 = newJObject()
  var query_564250 = newJObject()
  add(query_564250, "api-version", newJString(apiVersion))
  add(path_564249, "subscriptionId", newJString(subscriptionId))
  add(path_564249, "applicationGatewayName", newJString(applicationGatewayName))
  add(path_564249, "resourceGroupName", newJString(resourceGroupName))
  result = call_564248.call(path_564249, query_564250, nil, nil, nil)

var applicationGatewaysStart* = Call_ApplicationGatewaysStart_564240(
    name: "applicationGatewaysStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}/start",
    validator: validate_ApplicationGatewaysStart_564241, base: "",
    url: url_ApplicationGatewaysStart_564242, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysStop_564251 = ref object of OpenApiRestCall_563549
proc url_ApplicationGatewaysStop_564253(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationGatewayName" in path,
        "`applicationGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/applicationGateways/"),
               (kind: VariableSegment, value: "applicationGatewayName"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGatewaysStop_564252(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The STOP ApplicationGateway operation stops application gateway in the specified resource group through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: JString (required)
  ##                         : The name of the application gateway.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564254 = path.getOrDefault("subscriptionId")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "subscriptionId", valid_564254
  var valid_564255 = path.getOrDefault("applicationGatewayName")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "applicationGatewayName", valid_564255
  var valid_564256 = path.getOrDefault("resourceGroupName")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "resourceGroupName", valid_564256
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564257 = query.getOrDefault("api-version")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "api-version", valid_564257
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564258: Call_ApplicationGatewaysStop_564251; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The STOP ApplicationGateway operation stops application gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_564258.validator(path, query, header, formData, body)
  let scheme = call_564258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564258.url(scheme.get, call_564258.host, call_564258.base,
                         call_564258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564258, url, valid)

proc call*(call_564259: Call_ApplicationGatewaysStop_564251; apiVersion: string;
          subscriptionId: string; applicationGatewayName: string;
          resourceGroupName: string): Recallable =
  ## applicationGatewaysStop
  ## The STOP ApplicationGateway operation stops application gateway in the specified resource group through Network resource provider.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: string (required)
  ##                         : The name of the application gateway.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564260 = newJObject()
  var query_564261 = newJObject()
  add(query_564261, "api-version", newJString(apiVersion))
  add(path_564260, "subscriptionId", newJString(subscriptionId))
  add(path_564260, "applicationGatewayName", newJString(applicationGatewayName))
  add(path_564260, "resourceGroupName", newJString(resourceGroupName))
  result = call_564259.call(path_564260, query_564261, nil, nil, nil)

var applicationGatewaysStop* = Call_ApplicationGatewaysStop_564251(
    name: "applicationGatewaysStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}/stop",
    validator: validate_ApplicationGatewaysStop_564252, base: "",
    url: url_ApplicationGatewaysStop_564253, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsList_564262 = ref object of OpenApiRestCall_563549
proc url_VirtualNetworkGatewayConnectionsList_564264(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.Network/connections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewayConnectionsList_564263(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List VirtualNetworkGatewayConnections operation retrieves all the virtual network gateways connections created.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
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
  ##              : Client Api Version.
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
  if body != nil:
    result.add "body", body

proc call*(call_564268: Call_VirtualNetworkGatewayConnectionsList_564262;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The List VirtualNetworkGatewayConnections operation retrieves all the virtual network gateways connections created.
  ## 
  let valid = call_564268.validator(path, query, header, formData, body)
  let scheme = call_564268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564268.url(scheme.get, call_564268.host, call_564268.base,
                         call_564268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564268, url, valid)

proc call*(call_564269: Call_VirtualNetworkGatewayConnectionsList_564262;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## virtualNetworkGatewayConnectionsList
  ## The List VirtualNetworkGatewayConnections operation retrieves all the virtual network gateways connections created.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564270 = newJObject()
  var query_564271 = newJObject()
  add(query_564271, "api-version", newJString(apiVersion))
  add(path_564270, "subscriptionId", newJString(subscriptionId))
  add(path_564270, "resourceGroupName", newJString(resourceGroupName))
  result = call_564269.call(path_564270, query_564271, nil, nil, nil)

var virtualNetworkGatewayConnectionsList* = Call_VirtualNetworkGatewayConnectionsList_564262(
    name: "virtualNetworkGatewayConnectionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections",
    validator: validate_VirtualNetworkGatewayConnectionsList_564263, base: "",
    url: url_VirtualNetworkGatewayConnectionsList_564264, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_564283 = ref object of OpenApiRestCall_563549
proc url_VirtualNetworkGatewayConnectionsCreateOrUpdate_564285(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayConnectionName" in path,
        "`virtualNetworkGatewayConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/connections/"), (
        kind: VariableSegment, value: "virtualNetworkGatewayConnectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewayConnectionsCreateOrUpdate_564284(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The Put VirtualNetworkGatewayConnection operation creates/updates a virtual network gateway connection in the specified resource group through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: JString (required)
  ##                                      : The name of the virtual network gateway connection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564286 = path.getOrDefault("subscriptionId")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "subscriptionId", valid_564286
  var valid_564287 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_564287
  var valid_564288 = path.getOrDefault("resourceGroupName")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "resourceGroupName", valid_564288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564289 = query.getOrDefault("api-version")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "api-version", valid_564289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Begin Create or update Virtual Network Gateway connection operation through Network resource provider.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564291: Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_564283;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put VirtualNetworkGatewayConnection operation creates/updates a virtual network gateway connection in the specified resource group through Network resource provider.
  ## 
  let valid = call_564291.validator(path, query, header, formData, body)
  let scheme = call_564291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564291.url(scheme.get, call_564291.host, call_564291.base,
                         call_564291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564291, url, valid)

proc call*(call_564292: Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_564283;
          apiVersion: string; subscriptionId: string;
          virtualNetworkGatewayConnectionName: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## virtualNetworkGatewayConnectionsCreateOrUpdate
  ## The Put VirtualNetworkGatewayConnection operation creates/updates a virtual network gateway connection in the specified resource group through Network resource provider.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: string (required)
  ##                                      : The name of the virtual network gateway connection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Begin Create or update Virtual Network Gateway connection operation through Network resource provider.
  var path_564293 = newJObject()
  var query_564294 = newJObject()
  var body_564295 = newJObject()
  add(query_564294, "api-version", newJString(apiVersion))
  add(path_564293, "subscriptionId", newJString(subscriptionId))
  add(path_564293, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  add(path_564293, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564295 = parameters
  result = call_564292.call(path_564293, query_564294, nil, nil, body_564295)

var virtualNetworkGatewayConnectionsCreateOrUpdate* = Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_564283(
    name: "virtualNetworkGatewayConnectionsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}",
    validator: validate_VirtualNetworkGatewayConnectionsCreateOrUpdate_564284,
    base: "", url: url_VirtualNetworkGatewayConnectionsCreateOrUpdate_564285,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsGet_564272 = ref object of OpenApiRestCall_563549
proc url_VirtualNetworkGatewayConnectionsGet_564274(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayConnectionName" in path,
        "`virtualNetworkGatewayConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/connections/"), (
        kind: VariableSegment, value: "virtualNetworkGatewayConnectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewayConnectionsGet_564273(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get VirtualNetworkGatewayConnection operation retrieves information about the specified virtual network gateway connection through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: JString (required)
  ##                                      : The name of the virtual network gateway connection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564275 = path.getOrDefault("subscriptionId")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "subscriptionId", valid_564275
  var valid_564276 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_564276
  var valid_564277 = path.getOrDefault("resourceGroupName")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = nil)
  if valid_564277 != nil:
    section.add "resourceGroupName", valid_564277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564278 = query.getOrDefault("api-version")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "api-version", valid_564278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564279: Call_VirtualNetworkGatewayConnectionsGet_564272;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Get VirtualNetworkGatewayConnection operation retrieves information about the specified virtual network gateway connection through Network resource provider.
  ## 
  let valid = call_564279.validator(path, query, header, formData, body)
  let scheme = call_564279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564279.url(scheme.get, call_564279.host, call_564279.base,
                         call_564279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564279, url, valid)

proc call*(call_564280: Call_VirtualNetworkGatewayConnectionsGet_564272;
          apiVersion: string; subscriptionId: string;
          virtualNetworkGatewayConnectionName: string; resourceGroupName: string): Recallable =
  ## virtualNetworkGatewayConnectionsGet
  ## The Get VirtualNetworkGatewayConnection operation retrieves information about the specified virtual network gateway connection through Network resource provider.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: string (required)
  ##                                      : The name of the virtual network gateway connection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564281 = newJObject()
  var query_564282 = newJObject()
  add(query_564282, "api-version", newJString(apiVersion))
  add(path_564281, "subscriptionId", newJString(subscriptionId))
  add(path_564281, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  add(path_564281, "resourceGroupName", newJString(resourceGroupName))
  result = call_564280.call(path_564281, query_564282, nil, nil, nil)

var virtualNetworkGatewayConnectionsGet* = Call_VirtualNetworkGatewayConnectionsGet_564272(
    name: "virtualNetworkGatewayConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}",
    validator: validate_VirtualNetworkGatewayConnectionsGet_564273, base: "",
    url: url_VirtualNetworkGatewayConnectionsGet_564274, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsDelete_564296 = ref object of OpenApiRestCall_563549
proc url_VirtualNetworkGatewayConnectionsDelete_564298(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayConnectionName" in path,
        "`virtualNetworkGatewayConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/connections/"), (
        kind: VariableSegment, value: "virtualNetworkGatewayConnectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewayConnectionsDelete_564297(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Delete VirtualNetworkGatewayConnection operation deletes the specified virtual network Gateway connection through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: JString (required)
  ##                                      : The name of the virtual network gateway connection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564299 = path.getOrDefault("subscriptionId")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "subscriptionId", valid_564299
  var valid_564300 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_564300
  var valid_564301 = path.getOrDefault("resourceGroupName")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "resourceGroupName", valid_564301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564302 = query.getOrDefault("api-version")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "api-version", valid_564302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564303: Call_VirtualNetworkGatewayConnectionsDelete_564296;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Delete VirtualNetworkGatewayConnection operation deletes the specified virtual network Gateway connection through Network resource provider.
  ## 
  let valid = call_564303.validator(path, query, header, formData, body)
  let scheme = call_564303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564303.url(scheme.get, call_564303.host, call_564303.base,
                         call_564303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564303, url, valid)

proc call*(call_564304: Call_VirtualNetworkGatewayConnectionsDelete_564296;
          apiVersion: string; subscriptionId: string;
          virtualNetworkGatewayConnectionName: string; resourceGroupName: string): Recallable =
  ## virtualNetworkGatewayConnectionsDelete
  ## The Delete VirtualNetworkGatewayConnection operation deletes the specified virtual network Gateway connection through Network resource provider.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: string (required)
  ##                                      : The name of the virtual network gateway connection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564305 = newJObject()
  var query_564306 = newJObject()
  add(query_564306, "api-version", newJString(apiVersion))
  add(path_564305, "subscriptionId", newJString(subscriptionId))
  add(path_564305, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  add(path_564305, "resourceGroupName", newJString(resourceGroupName))
  result = call_564304.call(path_564305, query_564306, nil, nil, nil)

var virtualNetworkGatewayConnectionsDelete* = Call_VirtualNetworkGatewayConnectionsDelete_564296(
    name: "virtualNetworkGatewayConnectionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}",
    validator: validate_VirtualNetworkGatewayConnectionsDelete_564297, base: "",
    url: url_VirtualNetworkGatewayConnectionsDelete_564298,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsSetSharedKey_564318 = ref object of OpenApiRestCall_563549
proc url_VirtualNetworkGatewayConnectionsSetSharedKey_564320(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayConnectionName" in path,
        "`virtualNetworkGatewayConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/connections/"), (
        kind: VariableSegment, value: "virtualNetworkGatewayConnectionName"),
               (kind: ConstantSegment, value: "/sharedkey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewayConnectionsSetSharedKey_564319(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put VirtualNetworkGatewayConnectionSharedKey operation sets the virtual network gateway connection shared key for passed virtual network gateway connection in the specified resource group through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: JString (required)
  ##                                      : The virtual network gateway connection name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564321 = path.getOrDefault("subscriptionId")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "subscriptionId", valid_564321
  var valid_564322 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_564322
  var valid_564323 = path.getOrDefault("resourceGroupName")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "resourceGroupName", valid_564323
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564324 = query.getOrDefault("api-version")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "api-version", valid_564324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Begin Set Virtual Network Gateway connection Shared key operation through Network resource provider.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564326: Call_VirtualNetworkGatewayConnectionsSetSharedKey_564318;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put VirtualNetworkGatewayConnectionSharedKey operation sets the virtual network gateway connection shared key for passed virtual network gateway connection in the specified resource group through Network resource provider.
  ## 
  let valid = call_564326.validator(path, query, header, formData, body)
  let scheme = call_564326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564326.url(scheme.get, call_564326.host, call_564326.base,
                         call_564326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564326, url, valid)

proc call*(call_564327: Call_VirtualNetworkGatewayConnectionsSetSharedKey_564318;
          apiVersion: string; subscriptionId: string;
          virtualNetworkGatewayConnectionName: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## virtualNetworkGatewayConnectionsSetSharedKey
  ## The Put VirtualNetworkGatewayConnectionSharedKey operation sets the virtual network gateway connection shared key for passed virtual network gateway connection in the specified resource group through Network resource provider.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: string (required)
  ##                                      : The virtual network gateway connection name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Begin Set Virtual Network Gateway connection Shared key operation through Network resource provider.
  var path_564328 = newJObject()
  var query_564329 = newJObject()
  var body_564330 = newJObject()
  add(query_564329, "api-version", newJString(apiVersion))
  add(path_564328, "subscriptionId", newJString(subscriptionId))
  add(path_564328, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  add(path_564328, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564330 = parameters
  result = call_564327.call(path_564328, query_564329, nil, nil, body_564330)

var virtualNetworkGatewayConnectionsSetSharedKey* = Call_VirtualNetworkGatewayConnectionsSetSharedKey_564318(
    name: "virtualNetworkGatewayConnectionsSetSharedKey",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/sharedkey",
    validator: validate_VirtualNetworkGatewayConnectionsSetSharedKey_564319,
    base: "", url: url_VirtualNetworkGatewayConnectionsSetSharedKey_564320,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsGetSharedKey_564307 = ref object of OpenApiRestCall_563549
proc url_VirtualNetworkGatewayConnectionsGetSharedKey_564309(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayConnectionName" in path,
        "`virtualNetworkGatewayConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/connections/"), (
        kind: VariableSegment, value: "virtualNetworkGatewayConnectionName"),
               (kind: ConstantSegment, value: "/sharedkey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewayConnectionsGetSharedKey_564308(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get VirtualNetworkGatewayConnectionSharedKey operation retrieves information about the specified virtual network gateway connection shared key through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: JString (required)
  ##                                      : The virtual network gateway connection shared key name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564310 = path.getOrDefault("subscriptionId")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "subscriptionId", valid_564310
  var valid_564311 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_564311
  var valid_564312 = path.getOrDefault("resourceGroupName")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "resourceGroupName", valid_564312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564313 = query.getOrDefault("api-version")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "api-version", valid_564313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564314: Call_VirtualNetworkGatewayConnectionsGetSharedKey_564307;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Get VirtualNetworkGatewayConnectionSharedKey operation retrieves information about the specified virtual network gateway connection shared key through Network resource provider.
  ## 
  let valid = call_564314.validator(path, query, header, formData, body)
  let scheme = call_564314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564314.url(scheme.get, call_564314.host, call_564314.base,
                         call_564314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564314, url, valid)

proc call*(call_564315: Call_VirtualNetworkGatewayConnectionsGetSharedKey_564307;
          apiVersion: string; subscriptionId: string;
          virtualNetworkGatewayConnectionName: string; resourceGroupName: string): Recallable =
  ## virtualNetworkGatewayConnectionsGetSharedKey
  ## The Get VirtualNetworkGatewayConnectionSharedKey operation retrieves information about the specified virtual network gateway connection shared key through Network resource provider.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: string (required)
  ##                                      : The virtual network gateway connection shared key name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564316 = newJObject()
  var query_564317 = newJObject()
  add(query_564317, "api-version", newJString(apiVersion))
  add(path_564316, "subscriptionId", newJString(subscriptionId))
  add(path_564316, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  add(path_564316, "resourceGroupName", newJString(resourceGroupName))
  result = call_564315.call(path_564316, query_564317, nil, nil, nil)

var virtualNetworkGatewayConnectionsGetSharedKey* = Call_VirtualNetworkGatewayConnectionsGetSharedKey_564307(
    name: "virtualNetworkGatewayConnectionsGetSharedKey",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/sharedkey",
    validator: validate_VirtualNetworkGatewayConnectionsGetSharedKey_564308,
    base: "", url: url_VirtualNetworkGatewayConnectionsGetSharedKey_564309,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsResetSharedKey_564331 = ref object of OpenApiRestCall_563549
proc url_VirtualNetworkGatewayConnectionsResetSharedKey_564333(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayConnectionName" in path,
        "`virtualNetworkGatewayConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/connections/"), (
        kind: VariableSegment, value: "virtualNetworkGatewayConnectionName"),
               (kind: ConstantSegment, value: "/sharedkey/reset")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewayConnectionsResetSharedKey_564332(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The VirtualNetworkGatewayConnectionResetSharedKey operation resets the virtual network gateway connection shared key for passed virtual network gateway connection in the specified resource group through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: JString (required)
  ##                                      : The virtual network gateway connection reset shared key Name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564334 = path.getOrDefault("subscriptionId")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "subscriptionId", valid_564334
  var valid_564335 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_564335
  var valid_564336 = path.getOrDefault("resourceGroupName")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "resourceGroupName", valid_564336
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564337 = query.getOrDefault("api-version")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "api-version", valid_564337
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Begin Reset Virtual Network Gateway connection shared key operation through Network resource provider.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564339: Call_VirtualNetworkGatewayConnectionsResetSharedKey_564331;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The VirtualNetworkGatewayConnectionResetSharedKey operation resets the virtual network gateway connection shared key for passed virtual network gateway connection in the specified resource group through Network resource provider.
  ## 
  let valid = call_564339.validator(path, query, header, formData, body)
  let scheme = call_564339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564339.url(scheme.get, call_564339.host, call_564339.base,
                         call_564339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564339, url, valid)

proc call*(call_564340: Call_VirtualNetworkGatewayConnectionsResetSharedKey_564331;
          apiVersion: string; subscriptionId: string;
          virtualNetworkGatewayConnectionName: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## virtualNetworkGatewayConnectionsResetSharedKey
  ## The VirtualNetworkGatewayConnectionResetSharedKey operation resets the virtual network gateway connection shared key for passed virtual network gateway connection in the specified resource group through Network resource provider.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: string (required)
  ##                                      : The virtual network gateway connection reset shared key Name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Begin Reset Virtual Network Gateway connection shared key operation through Network resource provider.
  var path_564341 = newJObject()
  var query_564342 = newJObject()
  var body_564343 = newJObject()
  add(query_564342, "api-version", newJString(apiVersion))
  add(path_564341, "subscriptionId", newJString(subscriptionId))
  add(path_564341, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  add(path_564341, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564343 = parameters
  result = call_564340.call(path_564341, query_564342, nil, nil, body_564343)

var virtualNetworkGatewayConnectionsResetSharedKey* = Call_VirtualNetworkGatewayConnectionsResetSharedKey_564331(
    name: "virtualNetworkGatewayConnectionsResetSharedKey",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/sharedkey/reset",
    validator: validate_VirtualNetworkGatewayConnectionsResetSharedKey_564332,
    base: "", url: url_VirtualNetworkGatewayConnectionsResetSharedKey_564333,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsList_564344 = ref object of OpenApiRestCall_563549
proc url_ExpressRouteCircuitsList_564346(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Network/expressRouteCircuits")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCircuitsList_564345(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List ExpressRouteCircuit operation retrieves all the ExpressRouteCircuits in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564347 = path.getOrDefault("subscriptionId")
  valid_564347 = validateParameter(valid_564347, JString, required = true,
                                 default = nil)
  if valid_564347 != nil:
    section.add "subscriptionId", valid_564347
  var valid_564348 = path.getOrDefault("resourceGroupName")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "resourceGroupName", valid_564348
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564349 = query.getOrDefault("api-version")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "api-version", valid_564349
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564350: Call_ExpressRouteCircuitsList_564344; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List ExpressRouteCircuit operation retrieves all the ExpressRouteCircuits in a resource group.
  ## 
  let valid = call_564350.validator(path, query, header, formData, body)
  let scheme = call_564350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564350.url(scheme.get, call_564350.host, call_564350.base,
                         call_564350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564350, url, valid)

proc call*(call_564351: Call_ExpressRouteCircuitsList_564344; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## expressRouteCircuitsList
  ## The List ExpressRouteCircuit operation retrieves all the ExpressRouteCircuits in a resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564352 = newJObject()
  var query_564353 = newJObject()
  add(query_564353, "api-version", newJString(apiVersion))
  add(path_564352, "subscriptionId", newJString(subscriptionId))
  add(path_564352, "resourceGroupName", newJString(resourceGroupName))
  result = call_564351.call(path_564352, query_564353, nil, nil, nil)

var expressRouteCircuitsList* = Call_ExpressRouteCircuitsList_564344(
    name: "expressRouteCircuitsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits",
    validator: validate_ExpressRouteCircuitsList_564345, base: "",
    url: url_ExpressRouteCircuitsList_564346, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsCreateOrUpdate_564365 = ref object of OpenApiRestCall_563549
proc url_ExpressRouteCircuitsCreateOrUpdate_564367(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "circuitName" in path, "`circuitName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteCircuits/"),
               (kind: VariableSegment, value: "circuitName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCircuitsCreateOrUpdate_564366(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put ExpressRouteCircuit operation creates/updates a ExpressRouteCircuit
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564368 = path.getOrDefault("subscriptionId")
  valid_564368 = validateParameter(valid_564368, JString, required = true,
                                 default = nil)
  if valid_564368 != nil:
    section.add "subscriptionId", valid_564368
  var valid_564369 = path.getOrDefault("circuitName")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "circuitName", valid_564369
  var valid_564370 = path.getOrDefault("resourceGroupName")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = nil)
  if valid_564370 != nil:
    section.add "resourceGroupName", valid_564370
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564371 = query.getOrDefault("api-version")
  valid_564371 = validateParameter(valid_564371, JString, required = true,
                                 default = nil)
  if valid_564371 != nil:
    section.add "api-version", valid_564371
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/delete ExpressRouteCircuit operation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564373: Call_ExpressRouteCircuitsCreateOrUpdate_564365;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put ExpressRouteCircuit operation creates/updates a ExpressRouteCircuit
  ## 
  let valid = call_564373.validator(path, query, header, formData, body)
  let scheme = call_564373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564373.url(scheme.get, call_564373.host, call_564373.base,
                         call_564373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564373, url, valid)

proc call*(call_564374: Call_ExpressRouteCircuitsCreateOrUpdate_564365;
          apiVersion: string; subscriptionId: string; circuitName: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## expressRouteCircuitsCreateOrUpdate
  ## The Put ExpressRouteCircuit operation creates/updates a ExpressRouteCircuit
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/delete ExpressRouteCircuit operation
  var path_564375 = newJObject()
  var query_564376 = newJObject()
  var body_564377 = newJObject()
  add(query_564376, "api-version", newJString(apiVersion))
  add(path_564375, "subscriptionId", newJString(subscriptionId))
  add(path_564375, "circuitName", newJString(circuitName))
  add(path_564375, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564377 = parameters
  result = call_564374.call(path_564375, query_564376, nil, nil, body_564377)

var expressRouteCircuitsCreateOrUpdate* = Call_ExpressRouteCircuitsCreateOrUpdate_564365(
    name: "expressRouteCircuitsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}",
    validator: validate_ExpressRouteCircuitsCreateOrUpdate_564366, base: "",
    url: url_ExpressRouteCircuitsCreateOrUpdate_564367, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsGet_564354 = ref object of OpenApiRestCall_563549
proc url_ExpressRouteCircuitsGet_564356(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "circuitName" in path, "`circuitName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteCircuits/"),
               (kind: VariableSegment, value: "circuitName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCircuitsGet_564355(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get ExpressRouteCircuit operation retrieves information about the specified ExpressRouteCircuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564357 = path.getOrDefault("subscriptionId")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "subscriptionId", valid_564357
  var valid_564358 = path.getOrDefault("circuitName")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "circuitName", valid_564358
  var valid_564359 = path.getOrDefault("resourceGroupName")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "resourceGroupName", valid_564359
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564360 = query.getOrDefault("api-version")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "api-version", valid_564360
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564361: Call_ExpressRouteCircuitsGet_564354; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get ExpressRouteCircuit operation retrieves information about the specified ExpressRouteCircuit.
  ## 
  let valid = call_564361.validator(path, query, header, formData, body)
  let scheme = call_564361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564361.url(scheme.get, call_564361.host, call_564361.base,
                         call_564361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564361, url, valid)

proc call*(call_564362: Call_ExpressRouteCircuitsGet_564354; apiVersion: string;
          subscriptionId: string; circuitName: string; resourceGroupName: string): Recallable =
  ## expressRouteCircuitsGet
  ## The Get ExpressRouteCircuit operation retrieves information about the specified ExpressRouteCircuit.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564363 = newJObject()
  var query_564364 = newJObject()
  add(query_564364, "api-version", newJString(apiVersion))
  add(path_564363, "subscriptionId", newJString(subscriptionId))
  add(path_564363, "circuitName", newJString(circuitName))
  add(path_564363, "resourceGroupName", newJString(resourceGroupName))
  result = call_564362.call(path_564363, query_564364, nil, nil, nil)

var expressRouteCircuitsGet* = Call_ExpressRouteCircuitsGet_564354(
    name: "expressRouteCircuitsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}",
    validator: validate_ExpressRouteCircuitsGet_564355, base: "",
    url: url_ExpressRouteCircuitsGet_564356, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsDelete_564378 = ref object of OpenApiRestCall_563549
proc url_ExpressRouteCircuitsDelete_564380(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "circuitName" in path, "`circuitName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteCircuits/"),
               (kind: VariableSegment, value: "circuitName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCircuitsDelete_564379(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The delete ExpressRouteCircuit operation deletes the specified ExpressRouteCircuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the express route Circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564381 = path.getOrDefault("subscriptionId")
  valid_564381 = validateParameter(valid_564381, JString, required = true,
                                 default = nil)
  if valid_564381 != nil:
    section.add "subscriptionId", valid_564381
  var valid_564382 = path.getOrDefault("circuitName")
  valid_564382 = validateParameter(valid_564382, JString, required = true,
                                 default = nil)
  if valid_564382 != nil:
    section.add "circuitName", valid_564382
  var valid_564383 = path.getOrDefault("resourceGroupName")
  valid_564383 = validateParameter(valid_564383, JString, required = true,
                                 default = nil)
  if valid_564383 != nil:
    section.add "resourceGroupName", valid_564383
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564384 = query.getOrDefault("api-version")
  valid_564384 = validateParameter(valid_564384, JString, required = true,
                                 default = nil)
  if valid_564384 != nil:
    section.add "api-version", valid_564384
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564385: Call_ExpressRouteCircuitsDelete_564378; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete ExpressRouteCircuit operation deletes the specified ExpressRouteCircuit.
  ## 
  let valid = call_564385.validator(path, query, header, formData, body)
  let scheme = call_564385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564385.url(scheme.get, call_564385.host, call_564385.base,
                         call_564385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564385, url, valid)

proc call*(call_564386: Call_ExpressRouteCircuitsDelete_564378; apiVersion: string;
          subscriptionId: string; circuitName: string; resourceGroupName: string): Recallable =
  ## expressRouteCircuitsDelete
  ## The delete ExpressRouteCircuit operation deletes the specified ExpressRouteCircuit.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the express route Circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564387 = newJObject()
  var query_564388 = newJObject()
  add(query_564388, "api-version", newJString(apiVersion))
  add(path_564387, "subscriptionId", newJString(subscriptionId))
  add(path_564387, "circuitName", newJString(circuitName))
  add(path_564387, "resourceGroupName", newJString(resourceGroupName))
  result = call_564386.call(path_564387, query_564388, nil, nil, nil)

var expressRouteCircuitsDelete* = Call_ExpressRouteCircuitsDelete_564378(
    name: "expressRouteCircuitsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}",
    validator: validate_ExpressRouteCircuitsDelete_564379, base: "",
    url: url_ExpressRouteCircuitsDelete_564380, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsList_564389 = ref object of OpenApiRestCall_563549
proc url_ExpressRouteCircuitAuthorizationsList_564391(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "circuitName" in path, "`circuitName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteCircuits/"),
               (kind: VariableSegment, value: "circuitName"),
               (kind: ConstantSegment, value: "/authorizations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCircuitAuthorizationsList_564390(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List authorization operation retrieves all the authorizations in an ExpressRouteCircuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564392 = path.getOrDefault("subscriptionId")
  valid_564392 = validateParameter(valid_564392, JString, required = true,
                                 default = nil)
  if valid_564392 != nil:
    section.add "subscriptionId", valid_564392
  var valid_564393 = path.getOrDefault("circuitName")
  valid_564393 = validateParameter(valid_564393, JString, required = true,
                                 default = nil)
  if valid_564393 != nil:
    section.add "circuitName", valid_564393
  var valid_564394 = path.getOrDefault("resourceGroupName")
  valid_564394 = validateParameter(valid_564394, JString, required = true,
                                 default = nil)
  if valid_564394 != nil:
    section.add "resourceGroupName", valid_564394
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564395 = query.getOrDefault("api-version")
  valid_564395 = validateParameter(valid_564395, JString, required = true,
                                 default = nil)
  if valid_564395 != nil:
    section.add "api-version", valid_564395
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564396: Call_ExpressRouteCircuitAuthorizationsList_564389;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The List authorization operation retrieves all the authorizations in an ExpressRouteCircuit.
  ## 
  let valid = call_564396.validator(path, query, header, formData, body)
  let scheme = call_564396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564396.url(scheme.get, call_564396.host, call_564396.base,
                         call_564396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564396, url, valid)

proc call*(call_564397: Call_ExpressRouteCircuitAuthorizationsList_564389;
          apiVersion: string; subscriptionId: string; circuitName: string;
          resourceGroupName: string): Recallable =
  ## expressRouteCircuitAuthorizationsList
  ## The List authorization operation retrieves all the authorizations in an ExpressRouteCircuit.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564398 = newJObject()
  var query_564399 = newJObject()
  add(query_564399, "api-version", newJString(apiVersion))
  add(path_564398, "subscriptionId", newJString(subscriptionId))
  add(path_564398, "circuitName", newJString(circuitName))
  add(path_564398, "resourceGroupName", newJString(resourceGroupName))
  result = call_564397.call(path_564398, query_564399, nil, nil, nil)

var expressRouteCircuitAuthorizationsList* = Call_ExpressRouteCircuitAuthorizationsList_564389(
    name: "expressRouteCircuitAuthorizationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations",
    validator: validate_ExpressRouteCircuitAuthorizationsList_564390, base: "",
    url: url_ExpressRouteCircuitAuthorizationsList_564391, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_564412 = ref object of OpenApiRestCall_563549
proc url_ExpressRouteCircuitAuthorizationsCreateOrUpdate_564414(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "circuitName" in path, "`circuitName` is a required path parameter"
  assert "authorizationName" in path,
        "`authorizationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteCircuits/"),
               (kind: VariableSegment, value: "circuitName"),
               (kind: ConstantSegment, value: "/authorizations/"),
               (kind: VariableSegment, value: "authorizationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCircuitAuthorizationsCreateOrUpdate_564413(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The Put Authorization operation creates/updates an authorization in the specified ExpressRouteCircuits
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authorizationName: JString (required)
  ##                    : The name of the authorization.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564415 = path.getOrDefault("subscriptionId")
  valid_564415 = validateParameter(valid_564415, JString, required = true,
                                 default = nil)
  if valid_564415 != nil:
    section.add "subscriptionId", valid_564415
  var valid_564416 = path.getOrDefault("circuitName")
  valid_564416 = validateParameter(valid_564416, JString, required = true,
                                 default = nil)
  if valid_564416 != nil:
    section.add "circuitName", valid_564416
  var valid_564417 = path.getOrDefault("resourceGroupName")
  valid_564417 = validateParameter(valid_564417, JString, required = true,
                                 default = nil)
  if valid_564417 != nil:
    section.add "resourceGroupName", valid_564417
  var valid_564418 = path.getOrDefault("authorizationName")
  valid_564418 = validateParameter(valid_564418, JString, required = true,
                                 default = nil)
  if valid_564418 != nil:
    section.add "authorizationName", valid_564418
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564419 = query.getOrDefault("api-version")
  valid_564419 = validateParameter(valid_564419, JString, required = true,
                                 default = nil)
  if valid_564419 != nil:
    section.add "api-version", valid_564419
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   authorizationParameters: JObject (required)
  ##                          : Parameters supplied to the create/update ExpressRouteCircuitAuthorization operation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564421: Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_564412;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put Authorization operation creates/updates an authorization in the specified ExpressRouteCircuits
  ## 
  let valid = call_564421.validator(path, query, header, formData, body)
  let scheme = call_564421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564421.url(scheme.get, call_564421.host, call_564421.base,
                         call_564421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564421, url, valid)

proc call*(call_564422: Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_564412;
          apiVersion: string; subscriptionId: string; circuitName: string;
          authorizationParameters: JsonNode; resourceGroupName: string;
          authorizationName: string): Recallable =
  ## expressRouteCircuitAuthorizationsCreateOrUpdate
  ## The Put Authorization operation creates/updates an authorization in the specified ExpressRouteCircuits
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   authorizationParameters: JObject (required)
  ##                          : Parameters supplied to the create/update ExpressRouteCircuitAuthorization operation
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   authorizationName: string (required)
  ##                    : The name of the authorization.
  var path_564423 = newJObject()
  var query_564424 = newJObject()
  var body_564425 = newJObject()
  add(query_564424, "api-version", newJString(apiVersion))
  add(path_564423, "subscriptionId", newJString(subscriptionId))
  add(path_564423, "circuitName", newJString(circuitName))
  if authorizationParameters != nil:
    body_564425 = authorizationParameters
  add(path_564423, "resourceGroupName", newJString(resourceGroupName))
  add(path_564423, "authorizationName", newJString(authorizationName))
  result = call_564422.call(path_564423, query_564424, nil, nil, body_564425)

var expressRouteCircuitAuthorizationsCreateOrUpdate* = Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_564412(
    name: "expressRouteCircuitAuthorizationsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations/{authorizationName}",
    validator: validate_ExpressRouteCircuitAuthorizationsCreateOrUpdate_564413,
    base: "", url: url_ExpressRouteCircuitAuthorizationsCreateOrUpdate_564414,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsGet_564400 = ref object of OpenApiRestCall_563549
proc url_ExpressRouteCircuitAuthorizationsGet_564402(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "circuitName" in path, "`circuitName` is a required path parameter"
  assert "authorizationName" in path,
        "`authorizationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteCircuits/"),
               (kind: VariableSegment, value: "circuitName"),
               (kind: ConstantSegment, value: "/authorizations/"),
               (kind: VariableSegment, value: "authorizationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCircuitAuthorizationsGet_564401(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The GET authorization operation retrieves the specified authorization from the specified ExpressRouteCircuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authorizationName: JString (required)
  ##                    : The name of the authorization.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564403 = path.getOrDefault("subscriptionId")
  valid_564403 = validateParameter(valid_564403, JString, required = true,
                                 default = nil)
  if valid_564403 != nil:
    section.add "subscriptionId", valid_564403
  var valid_564404 = path.getOrDefault("circuitName")
  valid_564404 = validateParameter(valid_564404, JString, required = true,
                                 default = nil)
  if valid_564404 != nil:
    section.add "circuitName", valid_564404
  var valid_564405 = path.getOrDefault("resourceGroupName")
  valid_564405 = validateParameter(valid_564405, JString, required = true,
                                 default = nil)
  if valid_564405 != nil:
    section.add "resourceGroupName", valid_564405
  var valid_564406 = path.getOrDefault("authorizationName")
  valid_564406 = validateParameter(valid_564406, JString, required = true,
                                 default = nil)
  if valid_564406 != nil:
    section.add "authorizationName", valid_564406
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564407 = query.getOrDefault("api-version")
  valid_564407 = validateParameter(valid_564407, JString, required = true,
                                 default = nil)
  if valid_564407 != nil:
    section.add "api-version", valid_564407
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564408: Call_ExpressRouteCircuitAuthorizationsGet_564400;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The GET authorization operation retrieves the specified authorization from the specified ExpressRouteCircuit.
  ## 
  let valid = call_564408.validator(path, query, header, formData, body)
  let scheme = call_564408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564408.url(scheme.get, call_564408.host, call_564408.base,
                         call_564408.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564408, url, valid)

proc call*(call_564409: Call_ExpressRouteCircuitAuthorizationsGet_564400;
          apiVersion: string; subscriptionId: string; circuitName: string;
          resourceGroupName: string; authorizationName: string): Recallable =
  ## expressRouteCircuitAuthorizationsGet
  ## The GET authorization operation retrieves the specified authorization from the specified ExpressRouteCircuit.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   authorizationName: string (required)
  ##                    : The name of the authorization.
  var path_564410 = newJObject()
  var query_564411 = newJObject()
  add(query_564411, "api-version", newJString(apiVersion))
  add(path_564410, "subscriptionId", newJString(subscriptionId))
  add(path_564410, "circuitName", newJString(circuitName))
  add(path_564410, "resourceGroupName", newJString(resourceGroupName))
  add(path_564410, "authorizationName", newJString(authorizationName))
  result = call_564409.call(path_564410, query_564411, nil, nil, nil)

var expressRouteCircuitAuthorizationsGet* = Call_ExpressRouteCircuitAuthorizationsGet_564400(
    name: "expressRouteCircuitAuthorizationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations/{authorizationName}",
    validator: validate_ExpressRouteCircuitAuthorizationsGet_564401, base: "",
    url: url_ExpressRouteCircuitAuthorizationsGet_564402, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsDelete_564426 = ref object of OpenApiRestCall_563549
proc url_ExpressRouteCircuitAuthorizationsDelete_564428(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "circuitName" in path, "`circuitName` is a required path parameter"
  assert "authorizationName" in path,
        "`authorizationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteCircuits/"),
               (kind: VariableSegment, value: "circuitName"),
               (kind: ConstantSegment, value: "/authorizations/"),
               (kind: VariableSegment, value: "authorizationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCircuitAuthorizationsDelete_564427(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The delete authorization operation deletes the specified authorization from the specified ExpressRouteCircuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authorizationName: JString (required)
  ##                    : The name of the authorization.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564429 = path.getOrDefault("subscriptionId")
  valid_564429 = validateParameter(valid_564429, JString, required = true,
                                 default = nil)
  if valid_564429 != nil:
    section.add "subscriptionId", valid_564429
  var valid_564430 = path.getOrDefault("circuitName")
  valid_564430 = validateParameter(valid_564430, JString, required = true,
                                 default = nil)
  if valid_564430 != nil:
    section.add "circuitName", valid_564430
  var valid_564431 = path.getOrDefault("resourceGroupName")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = nil)
  if valid_564431 != nil:
    section.add "resourceGroupName", valid_564431
  var valid_564432 = path.getOrDefault("authorizationName")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "authorizationName", valid_564432
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564433 = query.getOrDefault("api-version")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "api-version", valid_564433
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564434: Call_ExpressRouteCircuitAuthorizationsDelete_564426;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The delete authorization operation deletes the specified authorization from the specified ExpressRouteCircuit.
  ## 
  let valid = call_564434.validator(path, query, header, formData, body)
  let scheme = call_564434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564434.url(scheme.get, call_564434.host, call_564434.base,
                         call_564434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564434, url, valid)

proc call*(call_564435: Call_ExpressRouteCircuitAuthorizationsDelete_564426;
          apiVersion: string; subscriptionId: string; circuitName: string;
          resourceGroupName: string; authorizationName: string): Recallable =
  ## expressRouteCircuitAuthorizationsDelete
  ## The delete authorization operation deletes the specified authorization from the specified ExpressRouteCircuit.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   authorizationName: string (required)
  ##                    : The name of the authorization.
  var path_564436 = newJObject()
  var query_564437 = newJObject()
  add(query_564437, "api-version", newJString(apiVersion))
  add(path_564436, "subscriptionId", newJString(subscriptionId))
  add(path_564436, "circuitName", newJString(circuitName))
  add(path_564436, "resourceGroupName", newJString(resourceGroupName))
  add(path_564436, "authorizationName", newJString(authorizationName))
  result = call_564435.call(path_564436, query_564437, nil, nil, nil)

var expressRouteCircuitAuthorizationsDelete* = Call_ExpressRouteCircuitAuthorizationsDelete_564426(
    name: "expressRouteCircuitAuthorizationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations/{authorizationName}",
    validator: validate_ExpressRouteCircuitAuthorizationsDelete_564427, base: "",
    url: url_ExpressRouteCircuitAuthorizationsDelete_564428,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsList_564438 = ref object of OpenApiRestCall_563549
proc url_ExpressRouteCircuitPeeringsList_564440(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "circuitName" in path, "`circuitName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteCircuits/"),
               (kind: VariableSegment, value: "circuitName"),
               (kind: ConstantSegment, value: "/peerings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCircuitPeeringsList_564439(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List peering operation retrieves all the peerings in an ExpressRouteCircuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564441 = path.getOrDefault("subscriptionId")
  valid_564441 = validateParameter(valid_564441, JString, required = true,
                                 default = nil)
  if valid_564441 != nil:
    section.add "subscriptionId", valid_564441
  var valid_564442 = path.getOrDefault("circuitName")
  valid_564442 = validateParameter(valid_564442, JString, required = true,
                                 default = nil)
  if valid_564442 != nil:
    section.add "circuitName", valid_564442
  var valid_564443 = path.getOrDefault("resourceGroupName")
  valid_564443 = validateParameter(valid_564443, JString, required = true,
                                 default = nil)
  if valid_564443 != nil:
    section.add "resourceGroupName", valid_564443
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564444 = query.getOrDefault("api-version")
  valid_564444 = validateParameter(valid_564444, JString, required = true,
                                 default = nil)
  if valid_564444 != nil:
    section.add "api-version", valid_564444
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564445: Call_ExpressRouteCircuitPeeringsList_564438;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The List peering operation retrieves all the peerings in an ExpressRouteCircuit.
  ## 
  let valid = call_564445.validator(path, query, header, formData, body)
  let scheme = call_564445.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564445.url(scheme.get, call_564445.host, call_564445.base,
                         call_564445.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564445, url, valid)

proc call*(call_564446: Call_ExpressRouteCircuitPeeringsList_564438;
          apiVersion: string; subscriptionId: string; circuitName: string;
          resourceGroupName: string): Recallable =
  ## expressRouteCircuitPeeringsList
  ## The List peering operation retrieves all the peerings in an ExpressRouteCircuit.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564447 = newJObject()
  var query_564448 = newJObject()
  add(query_564448, "api-version", newJString(apiVersion))
  add(path_564447, "subscriptionId", newJString(subscriptionId))
  add(path_564447, "circuitName", newJString(circuitName))
  add(path_564447, "resourceGroupName", newJString(resourceGroupName))
  result = call_564446.call(path_564447, query_564448, nil, nil, nil)

var expressRouteCircuitPeeringsList* = Call_ExpressRouteCircuitPeeringsList_564438(
    name: "expressRouteCircuitPeeringsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings",
    validator: validate_ExpressRouteCircuitPeeringsList_564439, base: "",
    url: url_ExpressRouteCircuitPeeringsList_564440, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsCreateOrUpdate_564461 = ref object of OpenApiRestCall_563549
proc url_ExpressRouteCircuitPeeringsCreateOrUpdate_564463(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "circuitName" in path, "`circuitName` is a required path parameter"
  assert "peeringName" in path, "`peeringName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteCircuits/"),
               (kind: VariableSegment, value: "circuitName"),
               (kind: ConstantSegment, value: "/peerings/"),
               (kind: VariableSegment, value: "peeringName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCircuitPeeringsCreateOrUpdate_564462(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put Peering operation creates/updates an peering in the specified ExpressRouteCircuits
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `peeringName` field"
  var valid_564464 = path.getOrDefault("peeringName")
  valid_564464 = validateParameter(valid_564464, JString, required = true,
                                 default = nil)
  if valid_564464 != nil:
    section.add "peeringName", valid_564464
  var valid_564465 = path.getOrDefault("subscriptionId")
  valid_564465 = validateParameter(valid_564465, JString, required = true,
                                 default = nil)
  if valid_564465 != nil:
    section.add "subscriptionId", valid_564465
  var valid_564466 = path.getOrDefault("circuitName")
  valid_564466 = validateParameter(valid_564466, JString, required = true,
                                 default = nil)
  if valid_564466 != nil:
    section.add "circuitName", valid_564466
  var valid_564467 = path.getOrDefault("resourceGroupName")
  valid_564467 = validateParameter(valid_564467, JString, required = true,
                                 default = nil)
  if valid_564467 != nil:
    section.add "resourceGroupName", valid_564467
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564468 = query.getOrDefault("api-version")
  valid_564468 = validateParameter(valid_564468, JString, required = true,
                                 default = nil)
  if valid_564468 != nil:
    section.add "api-version", valid_564468
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   peeringParameters: JObject (required)
  ##                    : Parameters supplied to the create/update ExpressRouteCircuit Peering operation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564470: Call_ExpressRouteCircuitPeeringsCreateOrUpdate_564461;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put Peering operation creates/updates an peering in the specified ExpressRouteCircuits
  ## 
  let valid = call_564470.validator(path, query, header, formData, body)
  let scheme = call_564470.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564470.url(scheme.get, call_564470.host, call_564470.base,
                         call_564470.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564470, url, valid)

proc call*(call_564471: Call_ExpressRouteCircuitPeeringsCreateOrUpdate_564461;
          apiVersion: string; peeringName: string; subscriptionId: string;
          circuitName: string; resourceGroupName: string;
          peeringParameters: JsonNode): Recallable =
  ## expressRouteCircuitPeeringsCreateOrUpdate
  ## The Put Peering operation creates/updates an peering in the specified ExpressRouteCircuits
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   peeringParameters: JObject (required)
  ##                    : Parameters supplied to the create/update ExpressRouteCircuit Peering operation
  var path_564472 = newJObject()
  var query_564473 = newJObject()
  var body_564474 = newJObject()
  add(query_564473, "api-version", newJString(apiVersion))
  add(path_564472, "peeringName", newJString(peeringName))
  add(path_564472, "subscriptionId", newJString(subscriptionId))
  add(path_564472, "circuitName", newJString(circuitName))
  add(path_564472, "resourceGroupName", newJString(resourceGroupName))
  if peeringParameters != nil:
    body_564474 = peeringParameters
  result = call_564471.call(path_564472, query_564473, nil, nil, body_564474)

var expressRouteCircuitPeeringsCreateOrUpdate* = Call_ExpressRouteCircuitPeeringsCreateOrUpdate_564461(
    name: "expressRouteCircuitPeeringsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCircuitPeeringsCreateOrUpdate_564462,
    base: "", url: url_ExpressRouteCircuitPeeringsCreateOrUpdate_564463,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsGet_564449 = ref object of OpenApiRestCall_563549
proc url_ExpressRouteCircuitPeeringsGet_564451(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "circuitName" in path, "`circuitName` is a required path parameter"
  assert "peeringName" in path, "`peeringName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteCircuits/"),
               (kind: VariableSegment, value: "circuitName"),
               (kind: ConstantSegment, value: "/peerings/"),
               (kind: VariableSegment, value: "peeringName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCircuitPeeringsGet_564450(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The GET peering operation retrieves the specified authorization from the ExpressRouteCircuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `peeringName` field"
  var valid_564452 = path.getOrDefault("peeringName")
  valid_564452 = validateParameter(valid_564452, JString, required = true,
                                 default = nil)
  if valid_564452 != nil:
    section.add "peeringName", valid_564452
  var valid_564453 = path.getOrDefault("subscriptionId")
  valid_564453 = validateParameter(valid_564453, JString, required = true,
                                 default = nil)
  if valid_564453 != nil:
    section.add "subscriptionId", valid_564453
  var valid_564454 = path.getOrDefault("circuitName")
  valid_564454 = validateParameter(valid_564454, JString, required = true,
                                 default = nil)
  if valid_564454 != nil:
    section.add "circuitName", valid_564454
  var valid_564455 = path.getOrDefault("resourceGroupName")
  valid_564455 = validateParameter(valid_564455, JString, required = true,
                                 default = nil)
  if valid_564455 != nil:
    section.add "resourceGroupName", valid_564455
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564456 = query.getOrDefault("api-version")
  valid_564456 = validateParameter(valid_564456, JString, required = true,
                                 default = nil)
  if valid_564456 != nil:
    section.add "api-version", valid_564456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564457: Call_ExpressRouteCircuitPeeringsGet_564449; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GET peering operation retrieves the specified authorization from the ExpressRouteCircuit.
  ## 
  let valid = call_564457.validator(path, query, header, formData, body)
  let scheme = call_564457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564457.url(scheme.get, call_564457.host, call_564457.base,
                         call_564457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564457, url, valid)

proc call*(call_564458: Call_ExpressRouteCircuitPeeringsGet_564449;
          apiVersion: string; peeringName: string; subscriptionId: string;
          circuitName: string; resourceGroupName: string): Recallable =
  ## expressRouteCircuitPeeringsGet
  ## The GET peering operation retrieves the specified authorization from the ExpressRouteCircuit.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564459 = newJObject()
  var query_564460 = newJObject()
  add(query_564460, "api-version", newJString(apiVersion))
  add(path_564459, "peeringName", newJString(peeringName))
  add(path_564459, "subscriptionId", newJString(subscriptionId))
  add(path_564459, "circuitName", newJString(circuitName))
  add(path_564459, "resourceGroupName", newJString(resourceGroupName))
  result = call_564458.call(path_564459, query_564460, nil, nil, nil)

var expressRouteCircuitPeeringsGet* = Call_ExpressRouteCircuitPeeringsGet_564449(
    name: "expressRouteCircuitPeeringsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCircuitPeeringsGet_564450, base: "",
    url: url_ExpressRouteCircuitPeeringsGet_564451, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsDelete_564475 = ref object of OpenApiRestCall_563549
proc url_ExpressRouteCircuitPeeringsDelete_564477(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "circuitName" in path, "`circuitName` is a required path parameter"
  assert "peeringName" in path, "`peeringName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteCircuits/"),
               (kind: VariableSegment, value: "circuitName"),
               (kind: ConstantSegment, value: "/peerings/"),
               (kind: VariableSegment, value: "peeringName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCircuitPeeringsDelete_564476(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The delete peering operation deletes the specified peering from the ExpressRouteCircuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `peeringName` field"
  var valid_564478 = path.getOrDefault("peeringName")
  valid_564478 = validateParameter(valid_564478, JString, required = true,
                                 default = nil)
  if valid_564478 != nil:
    section.add "peeringName", valid_564478
  var valid_564479 = path.getOrDefault("subscriptionId")
  valid_564479 = validateParameter(valid_564479, JString, required = true,
                                 default = nil)
  if valid_564479 != nil:
    section.add "subscriptionId", valid_564479
  var valid_564480 = path.getOrDefault("circuitName")
  valid_564480 = validateParameter(valid_564480, JString, required = true,
                                 default = nil)
  if valid_564480 != nil:
    section.add "circuitName", valid_564480
  var valid_564481 = path.getOrDefault("resourceGroupName")
  valid_564481 = validateParameter(valid_564481, JString, required = true,
                                 default = nil)
  if valid_564481 != nil:
    section.add "resourceGroupName", valid_564481
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564482 = query.getOrDefault("api-version")
  valid_564482 = validateParameter(valid_564482, JString, required = true,
                                 default = nil)
  if valid_564482 != nil:
    section.add "api-version", valid_564482
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564483: Call_ExpressRouteCircuitPeeringsDelete_564475;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The delete peering operation deletes the specified peering from the ExpressRouteCircuit.
  ## 
  let valid = call_564483.validator(path, query, header, formData, body)
  let scheme = call_564483.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564483.url(scheme.get, call_564483.host, call_564483.base,
                         call_564483.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564483, url, valid)

proc call*(call_564484: Call_ExpressRouteCircuitPeeringsDelete_564475;
          apiVersion: string; peeringName: string; subscriptionId: string;
          circuitName: string; resourceGroupName: string): Recallable =
  ## expressRouteCircuitPeeringsDelete
  ## The delete peering operation deletes the specified peering from the ExpressRouteCircuit.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564485 = newJObject()
  var query_564486 = newJObject()
  add(query_564486, "api-version", newJString(apiVersion))
  add(path_564485, "peeringName", newJString(peeringName))
  add(path_564485, "subscriptionId", newJString(subscriptionId))
  add(path_564485, "circuitName", newJString(circuitName))
  add(path_564485, "resourceGroupName", newJString(resourceGroupName))
  result = call_564484.call(path_564485, query_564486, nil, nil, nil)

var expressRouteCircuitPeeringsDelete* = Call_ExpressRouteCircuitPeeringsDelete_564475(
    name: "expressRouteCircuitPeeringsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCircuitPeeringsDelete_564476, base: "",
    url: url_ExpressRouteCircuitPeeringsDelete_564477, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsListArpTable_564487 = ref object of OpenApiRestCall_563549
proc url_ExpressRouteCircuitsListArpTable_564489(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "circuitName" in path, "`circuitName` is a required path parameter"
  assert "peeringName" in path, "`peeringName` is a required path parameter"
  assert "devicePath" in path, "`devicePath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteCircuits/"),
               (kind: VariableSegment, value: "circuitName"),
               (kind: ConstantSegment, value: "/peerings/"),
               (kind: VariableSegment, value: "peeringName"),
               (kind: ConstantSegment, value: "/arpTables/"),
               (kind: VariableSegment, value: "devicePath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCircuitsListArpTable_564488(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The ListArpTable from ExpressRouteCircuit operation retrieves the currently advertised arp table associated with the ExpressRouteCircuits in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the circuit.
  ##   devicePath: JString (required)
  ##             : The path of the device.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `peeringName` field"
  var valid_564490 = path.getOrDefault("peeringName")
  valid_564490 = validateParameter(valid_564490, JString, required = true,
                                 default = nil)
  if valid_564490 != nil:
    section.add "peeringName", valid_564490
  var valid_564491 = path.getOrDefault("subscriptionId")
  valid_564491 = validateParameter(valid_564491, JString, required = true,
                                 default = nil)
  if valid_564491 != nil:
    section.add "subscriptionId", valid_564491
  var valid_564492 = path.getOrDefault("circuitName")
  valid_564492 = validateParameter(valid_564492, JString, required = true,
                                 default = nil)
  if valid_564492 != nil:
    section.add "circuitName", valid_564492
  var valid_564493 = path.getOrDefault("devicePath")
  valid_564493 = validateParameter(valid_564493, JString, required = true,
                                 default = nil)
  if valid_564493 != nil:
    section.add "devicePath", valid_564493
  var valid_564494 = path.getOrDefault("resourceGroupName")
  valid_564494 = validateParameter(valid_564494, JString, required = true,
                                 default = nil)
  if valid_564494 != nil:
    section.add "resourceGroupName", valid_564494
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564495 = query.getOrDefault("api-version")
  valid_564495 = validateParameter(valid_564495, JString, required = true,
                                 default = nil)
  if valid_564495 != nil:
    section.add "api-version", valid_564495
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564496: Call_ExpressRouteCircuitsListArpTable_564487;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The ListArpTable from ExpressRouteCircuit operation retrieves the currently advertised arp table associated with the ExpressRouteCircuits in a resource group.
  ## 
  let valid = call_564496.validator(path, query, header, formData, body)
  let scheme = call_564496.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564496.url(scheme.get, call_564496.host, call_564496.base,
                         call_564496.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564496, url, valid)

proc call*(call_564497: Call_ExpressRouteCircuitsListArpTable_564487;
          apiVersion: string; peeringName: string; subscriptionId: string;
          circuitName: string; devicePath: string; resourceGroupName: string): Recallable =
  ## expressRouteCircuitsListArpTable
  ## The ListArpTable from ExpressRouteCircuit operation retrieves the currently advertised arp table associated with the ExpressRouteCircuits in a resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   devicePath: string (required)
  ##             : The path of the device.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564498 = newJObject()
  var query_564499 = newJObject()
  add(query_564499, "api-version", newJString(apiVersion))
  add(path_564498, "peeringName", newJString(peeringName))
  add(path_564498, "subscriptionId", newJString(subscriptionId))
  add(path_564498, "circuitName", newJString(circuitName))
  add(path_564498, "devicePath", newJString(devicePath))
  add(path_564498, "resourceGroupName", newJString(resourceGroupName))
  result = call_564497.call(path_564498, query_564499, nil, nil, nil)

var expressRouteCircuitsListArpTable* = Call_ExpressRouteCircuitsListArpTable_564487(
    name: "expressRouteCircuitsListArpTable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/arpTables/{devicePath}",
    validator: validate_ExpressRouteCircuitsListArpTable_564488, base: "",
    url: url_ExpressRouteCircuitsListArpTable_564489, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsListRoutesTable_564500 = ref object of OpenApiRestCall_563549
proc url_ExpressRouteCircuitsListRoutesTable_564502(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "circuitName" in path, "`circuitName` is a required path parameter"
  assert "peeringName" in path, "`peeringName` is a required path parameter"
  assert "devicePath" in path, "`devicePath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteCircuits/"),
               (kind: VariableSegment, value: "circuitName"),
               (kind: ConstantSegment, value: "/peerings/"),
               (kind: VariableSegment, value: "peeringName"),
               (kind: ConstantSegment, value: "/routeTables/"),
               (kind: VariableSegment, value: "devicePath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCircuitsListRoutesTable_564501(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The ListRoutesTable from ExpressRouteCircuit operation retrieves the currently advertised routes table associated with the ExpressRouteCircuits in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the circuit.
  ##   devicePath: JString (required)
  ##             : The path of the device.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `peeringName` field"
  var valid_564503 = path.getOrDefault("peeringName")
  valid_564503 = validateParameter(valid_564503, JString, required = true,
                                 default = nil)
  if valid_564503 != nil:
    section.add "peeringName", valid_564503
  var valid_564504 = path.getOrDefault("subscriptionId")
  valid_564504 = validateParameter(valid_564504, JString, required = true,
                                 default = nil)
  if valid_564504 != nil:
    section.add "subscriptionId", valid_564504
  var valid_564505 = path.getOrDefault("circuitName")
  valid_564505 = validateParameter(valid_564505, JString, required = true,
                                 default = nil)
  if valid_564505 != nil:
    section.add "circuitName", valid_564505
  var valid_564506 = path.getOrDefault("devicePath")
  valid_564506 = validateParameter(valid_564506, JString, required = true,
                                 default = nil)
  if valid_564506 != nil:
    section.add "devicePath", valid_564506
  var valid_564507 = path.getOrDefault("resourceGroupName")
  valid_564507 = validateParameter(valid_564507, JString, required = true,
                                 default = nil)
  if valid_564507 != nil:
    section.add "resourceGroupName", valid_564507
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564508 = query.getOrDefault("api-version")
  valid_564508 = validateParameter(valid_564508, JString, required = true,
                                 default = nil)
  if valid_564508 != nil:
    section.add "api-version", valid_564508
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564509: Call_ExpressRouteCircuitsListRoutesTable_564500;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The ListRoutesTable from ExpressRouteCircuit operation retrieves the currently advertised routes table associated with the ExpressRouteCircuits in a resource group.
  ## 
  let valid = call_564509.validator(path, query, header, formData, body)
  let scheme = call_564509.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564509.url(scheme.get, call_564509.host, call_564509.base,
                         call_564509.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564509, url, valid)

proc call*(call_564510: Call_ExpressRouteCircuitsListRoutesTable_564500;
          apiVersion: string; peeringName: string; subscriptionId: string;
          circuitName: string; devicePath: string; resourceGroupName: string): Recallable =
  ## expressRouteCircuitsListRoutesTable
  ## The ListRoutesTable from ExpressRouteCircuit operation retrieves the currently advertised routes table associated with the ExpressRouteCircuits in a resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   devicePath: string (required)
  ##             : The path of the device.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564511 = newJObject()
  var query_564512 = newJObject()
  add(query_564512, "api-version", newJString(apiVersion))
  add(path_564511, "peeringName", newJString(peeringName))
  add(path_564511, "subscriptionId", newJString(subscriptionId))
  add(path_564511, "circuitName", newJString(circuitName))
  add(path_564511, "devicePath", newJString(devicePath))
  add(path_564511, "resourceGroupName", newJString(resourceGroupName))
  result = call_564510.call(path_564511, query_564512, nil, nil, nil)

var expressRouteCircuitsListRoutesTable* = Call_ExpressRouteCircuitsListRoutesTable_564500(
    name: "expressRouteCircuitsListRoutesTable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/routeTables/{devicePath}",
    validator: validate_ExpressRouteCircuitsListRoutesTable_564501, base: "",
    url: url_ExpressRouteCircuitsListRoutesTable_564502, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsListRoutesTableSummary_564513 = ref object of OpenApiRestCall_563549
proc url_ExpressRouteCircuitsListRoutesTableSummary_564515(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "circuitName" in path, "`circuitName` is a required path parameter"
  assert "peeringName" in path, "`peeringName` is a required path parameter"
  assert "devicePath" in path, "`devicePath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteCircuits/"),
               (kind: VariableSegment, value: "circuitName"),
               (kind: ConstantSegment, value: "/peerings/"),
               (kind: VariableSegment, value: "peeringName"),
               (kind: ConstantSegment, value: "/routeTablesSummary/"),
               (kind: VariableSegment, value: "devicePath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCircuitsListRoutesTableSummary_564514(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The ListRoutesTable from ExpressRouteCircuit operation retrieves the currently advertised routes table associated with the ExpressRouteCircuits in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the circuit.
  ##   devicePath: JString (required)
  ##             : The path of the device.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `peeringName` field"
  var valid_564516 = path.getOrDefault("peeringName")
  valid_564516 = validateParameter(valid_564516, JString, required = true,
                                 default = nil)
  if valid_564516 != nil:
    section.add "peeringName", valid_564516
  var valid_564517 = path.getOrDefault("subscriptionId")
  valid_564517 = validateParameter(valid_564517, JString, required = true,
                                 default = nil)
  if valid_564517 != nil:
    section.add "subscriptionId", valid_564517
  var valid_564518 = path.getOrDefault("circuitName")
  valid_564518 = validateParameter(valid_564518, JString, required = true,
                                 default = nil)
  if valid_564518 != nil:
    section.add "circuitName", valid_564518
  var valid_564519 = path.getOrDefault("devicePath")
  valid_564519 = validateParameter(valid_564519, JString, required = true,
                                 default = nil)
  if valid_564519 != nil:
    section.add "devicePath", valid_564519
  var valid_564520 = path.getOrDefault("resourceGroupName")
  valid_564520 = validateParameter(valid_564520, JString, required = true,
                                 default = nil)
  if valid_564520 != nil:
    section.add "resourceGroupName", valid_564520
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564521 = query.getOrDefault("api-version")
  valid_564521 = validateParameter(valid_564521, JString, required = true,
                                 default = nil)
  if valid_564521 != nil:
    section.add "api-version", valid_564521
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564522: Call_ExpressRouteCircuitsListRoutesTableSummary_564513;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The ListRoutesTable from ExpressRouteCircuit operation retrieves the currently advertised routes table associated with the ExpressRouteCircuits in a resource group.
  ## 
  let valid = call_564522.validator(path, query, header, formData, body)
  let scheme = call_564522.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564522.url(scheme.get, call_564522.host, call_564522.base,
                         call_564522.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564522, url, valid)

proc call*(call_564523: Call_ExpressRouteCircuitsListRoutesTableSummary_564513;
          apiVersion: string; peeringName: string; subscriptionId: string;
          circuitName: string; devicePath: string; resourceGroupName: string): Recallable =
  ## expressRouteCircuitsListRoutesTableSummary
  ## The ListRoutesTable from ExpressRouteCircuit operation retrieves the currently advertised routes table associated with the ExpressRouteCircuits in a resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   devicePath: string (required)
  ##             : The path of the device.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564524 = newJObject()
  var query_564525 = newJObject()
  add(query_564525, "api-version", newJString(apiVersion))
  add(path_564524, "peeringName", newJString(peeringName))
  add(path_564524, "subscriptionId", newJString(subscriptionId))
  add(path_564524, "circuitName", newJString(circuitName))
  add(path_564524, "devicePath", newJString(devicePath))
  add(path_564524, "resourceGroupName", newJString(resourceGroupName))
  result = call_564523.call(path_564524, query_564525, nil, nil, nil)

var expressRouteCircuitsListRoutesTableSummary* = Call_ExpressRouteCircuitsListRoutesTableSummary_564513(
    name: "expressRouteCircuitsListRoutesTableSummary", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/routeTablesSummary/{devicePath}",
    validator: validate_ExpressRouteCircuitsListRoutesTableSummary_564514,
    base: "", url: url_ExpressRouteCircuitsListRoutesTableSummary_564515,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsGetPeeringStats_564526 = ref object of OpenApiRestCall_563549
proc url_ExpressRouteCircuitsGetPeeringStats_564528(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "circuitName" in path, "`circuitName` is a required path parameter"
  assert "peeringName" in path, "`peeringName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteCircuits/"),
               (kind: VariableSegment, value: "circuitName"),
               (kind: ConstantSegment, value: "/peerings/"),
               (kind: VariableSegment, value: "peeringName"),
               (kind: ConstantSegment, value: "/stats")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCircuitsGetPeeringStats_564527(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The GetPeeringStats ExpressRouteCircuit operation retrieves all the stats from a ExpressRouteCircuits in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `peeringName` field"
  var valid_564529 = path.getOrDefault("peeringName")
  valid_564529 = validateParameter(valid_564529, JString, required = true,
                                 default = nil)
  if valid_564529 != nil:
    section.add "peeringName", valid_564529
  var valid_564530 = path.getOrDefault("subscriptionId")
  valid_564530 = validateParameter(valid_564530, JString, required = true,
                                 default = nil)
  if valid_564530 != nil:
    section.add "subscriptionId", valid_564530
  var valid_564531 = path.getOrDefault("circuitName")
  valid_564531 = validateParameter(valid_564531, JString, required = true,
                                 default = nil)
  if valid_564531 != nil:
    section.add "circuitName", valid_564531
  var valid_564532 = path.getOrDefault("resourceGroupName")
  valid_564532 = validateParameter(valid_564532, JString, required = true,
                                 default = nil)
  if valid_564532 != nil:
    section.add "resourceGroupName", valid_564532
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564533 = query.getOrDefault("api-version")
  valid_564533 = validateParameter(valid_564533, JString, required = true,
                                 default = nil)
  if valid_564533 != nil:
    section.add "api-version", valid_564533
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564534: Call_ExpressRouteCircuitsGetPeeringStats_564526;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The GetPeeringStats ExpressRouteCircuit operation retrieves all the stats from a ExpressRouteCircuits in a resource group.
  ## 
  let valid = call_564534.validator(path, query, header, formData, body)
  let scheme = call_564534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564534.url(scheme.get, call_564534.host, call_564534.base,
                         call_564534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564534, url, valid)

proc call*(call_564535: Call_ExpressRouteCircuitsGetPeeringStats_564526;
          apiVersion: string; peeringName: string; subscriptionId: string;
          circuitName: string; resourceGroupName: string): Recallable =
  ## expressRouteCircuitsGetPeeringStats
  ## The GetPeeringStats ExpressRouteCircuit operation retrieves all the stats from a ExpressRouteCircuits in a resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564536 = newJObject()
  var query_564537 = newJObject()
  add(query_564537, "api-version", newJString(apiVersion))
  add(path_564536, "peeringName", newJString(peeringName))
  add(path_564536, "subscriptionId", newJString(subscriptionId))
  add(path_564536, "circuitName", newJString(circuitName))
  add(path_564536, "resourceGroupName", newJString(resourceGroupName))
  result = call_564535.call(path_564536, query_564537, nil, nil, nil)

var expressRouteCircuitsGetPeeringStats* = Call_ExpressRouteCircuitsGetPeeringStats_564526(
    name: "expressRouteCircuitsGetPeeringStats", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/stats",
    validator: validate_ExpressRouteCircuitsGetPeeringStats_564527, base: "",
    url: url_ExpressRouteCircuitsGetPeeringStats_564528, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsGetStats_564538 = ref object of OpenApiRestCall_563549
proc url_ExpressRouteCircuitsGetStats_564540(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "circuitName" in path, "`circuitName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteCircuits/"),
               (kind: VariableSegment, value: "circuitName"),
               (kind: ConstantSegment, value: "/stats")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCircuitsGetStats_564539(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The GetStats ExpressRouteCircuit operation retrieves all the stats from a ExpressRouteCircuits in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564541 = path.getOrDefault("subscriptionId")
  valid_564541 = validateParameter(valid_564541, JString, required = true,
                                 default = nil)
  if valid_564541 != nil:
    section.add "subscriptionId", valid_564541
  var valid_564542 = path.getOrDefault("circuitName")
  valid_564542 = validateParameter(valid_564542, JString, required = true,
                                 default = nil)
  if valid_564542 != nil:
    section.add "circuitName", valid_564542
  var valid_564543 = path.getOrDefault("resourceGroupName")
  valid_564543 = validateParameter(valid_564543, JString, required = true,
                                 default = nil)
  if valid_564543 != nil:
    section.add "resourceGroupName", valid_564543
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564544 = query.getOrDefault("api-version")
  valid_564544 = validateParameter(valid_564544, JString, required = true,
                                 default = nil)
  if valid_564544 != nil:
    section.add "api-version", valid_564544
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564545: Call_ExpressRouteCircuitsGetStats_564538; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetStats ExpressRouteCircuit operation retrieves all the stats from a ExpressRouteCircuits in a resource group.
  ## 
  let valid = call_564545.validator(path, query, header, formData, body)
  let scheme = call_564545.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564545.url(scheme.get, call_564545.host, call_564545.base,
                         call_564545.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564545, url, valid)

proc call*(call_564546: Call_ExpressRouteCircuitsGetStats_564538;
          apiVersion: string; subscriptionId: string; circuitName: string;
          resourceGroupName: string): Recallable =
  ## expressRouteCircuitsGetStats
  ## The GetStats ExpressRouteCircuit operation retrieves all the stats from a ExpressRouteCircuits in a resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564547 = newJObject()
  var query_564548 = newJObject()
  add(query_564548, "api-version", newJString(apiVersion))
  add(path_564547, "subscriptionId", newJString(subscriptionId))
  add(path_564547, "circuitName", newJString(circuitName))
  add(path_564547, "resourceGroupName", newJString(resourceGroupName))
  result = call_564546.call(path_564547, query_564548, nil, nil, nil)

var expressRouteCircuitsGetStats* = Call_ExpressRouteCircuitsGetStats_564538(
    name: "expressRouteCircuitsGetStats", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/stats",
    validator: validate_ExpressRouteCircuitsGetStats_564539, base: "",
    url: url_ExpressRouteCircuitsGetStats_564540, schemes: {Scheme.Https})
type
  Call_LoadBalancersList_564549 = ref object of OpenApiRestCall_563549
proc url_LoadBalancersList_564551(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.Network/loadBalancers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoadBalancersList_564550(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## The List loadBalancer operation retrieves all the load balancers in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564552 = path.getOrDefault("subscriptionId")
  valid_564552 = validateParameter(valid_564552, JString, required = true,
                                 default = nil)
  if valid_564552 != nil:
    section.add "subscriptionId", valid_564552
  var valid_564553 = path.getOrDefault("resourceGroupName")
  valid_564553 = validateParameter(valid_564553, JString, required = true,
                                 default = nil)
  if valid_564553 != nil:
    section.add "resourceGroupName", valid_564553
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564554 = query.getOrDefault("api-version")
  valid_564554 = validateParameter(valid_564554, JString, required = true,
                                 default = nil)
  if valid_564554 != nil:
    section.add "api-version", valid_564554
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564555: Call_LoadBalancersList_564549; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List loadBalancer operation retrieves all the load balancers in a resource group.
  ## 
  let valid = call_564555.validator(path, query, header, formData, body)
  let scheme = call_564555.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564555.url(scheme.get, call_564555.host, call_564555.base,
                         call_564555.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564555, url, valid)

proc call*(call_564556: Call_LoadBalancersList_564549; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## loadBalancersList
  ## The List loadBalancer operation retrieves all the load balancers in a resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564557 = newJObject()
  var query_564558 = newJObject()
  add(query_564558, "api-version", newJString(apiVersion))
  add(path_564557, "subscriptionId", newJString(subscriptionId))
  add(path_564557, "resourceGroupName", newJString(resourceGroupName))
  result = call_564556.call(path_564557, query_564558, nil, nil, nil)

var loadBalancersList* = Call_LoadBalancersList_564549(name: "loadBalancersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers",
    validator: validate_LoadBalancersList_564550, base: "",
    url: url_LoadBalancersList_564551, schemes: {Scheme.Https})
type
  Call_LoadBalancersCreateOrUpdate_564572 = ref object of OpenApiRestCall_563549
proc url_LoadBalancersCreateOrUpdate_564574(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "loadBalancerName" in path,
        "`loadBalancerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/loadBalancers/"),
               (kind: VariableSegment, value: "loadBalancerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoadBalancersCreateOrUpdate_564573(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put LoadBalancer operation creates/updates a LoadBalancer
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   loadBalancerName: JString (required)
  ##                   : The name of the loadBalancer.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `loadBalancerName` field"
  var valid_564575 = path.getOrDefault("loadBalancerName")
  valid_564575 = validateParameter(valid_564575, JString, required = true,
                                 default = nil)
  if valid_564575 != nil:
    section.add "loadBalancerName", valid_564575
  var valid_564576 = path.getOrDefault("subscriptionId")
  valid_564576 = validateParameter(valid_564576, JString, required = true,
                                 default = nil)
  if valid_564576 != nil:
    section.add "subscriptionId", valid_564576
  var valid_564577 = path.getOrDefault("resourceGroupName")
  valid_564577 = validateParameter(valid_564577, JString, required = true,
                                 default = nil)
  if valid_564577 != nil:
    section.add "resourceGroupName", valid_564577
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564578 = query.getOrDefault("api-version")
  valid_564578 = validateParameter(valid_564578, JString, required = true,
                                 default = nil)
  if valid_564578 != nil:
    section.add "api-version", valid_564578
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/delete LoadBalancer operation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564580: Call_LoadBalancersCreateOrUpdate_564572; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put LoadBalancer operation creates/updates a LoadBalancer
  ## 
  let valid = call_564580.validator(path, query, header, formData, body)
  let scheme = call_564580.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564580.url(scheme.get, call_564580.host, call_564580.base,
                         call_564580.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564580, url, valid)

proc call*(call_564581: Call_LoadBalancersCreateOrUpdate_564572;
          loadBalancerName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## loadBalancersCreateOrUpdate
  ## The Put LoadBalancer operation creates/updates a LoadBalancer
  ##   loadBalancerName: string (required)
  ##                   : The name of the loadBalancer.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/delete LoadBalancer operation
  var path_564582 = newJObject()
  var query_564583 = newJObject()
  var body_564584 = newJObject()
  add(path_564582, "loadBalancerName", newJString(loadBalancerName))
  add(query_564583, "api-version", newJString(apiVersion))
  add(path_564582, "subscriptionId", newJString(subscriptionId))
  add(path_564582, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564584 = parameters
  result = call_564581.call(path_564582, query_564583, nil, nil, body_564584)

var loadBalancersCreateOrUpdate* = Call_LoadBalancersCreateOrUpdate_564572(
    name: "loadBalancersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}",
    validator: validate_LoadBalancersCreateOrUpdate_564573, base: "",
    url: url_LoadBalancersCreateOrUpdate_564574, schemes: {Scheme.Https})
type
  Call_LoadBalancersGet_564559 = ref object of OpenApiRestCall_563549
proc url_LoadBalancersGet_564561(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "loadBalancerName" in path,
        "`loadBalancerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/loadBalancers/"),
               (kind: VariableSegment, value: "loadBalancerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoadBalancersGet_564560(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## The Get network interface operation retrieves information about the specified network interface.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   loadBalancerName: JString (required)
  ##                   : The name of the loadBalancer.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `loadBalancerName` field"
  var valid_564563 = path.getOrDefault("loadBalancerName")
  valid_564563 = validateParameter(valid_564563, JString, required = true,
                                 default = nil)
  if valid_564563 != nil:
    section.add "loadBalancerName", valid_564563
  var valid_564564 = path.getOrDefault("subscriptionId")
  valid_564564 = validateParameter(valid_564564, JString, required = true,
                                 default = nil)
  if valid_564564 != nil:
    section.add "subscriptionId", valid_564564
  var valid_564565 = path.getOrDefault("resourceGroupName")
  valid_564565 = validateParameter(valid_564565, JString, required = true,
                                 default = nil)
  if valid_564565 != nil:
    section.add "resourceGroupName", valid_564565
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564566 = query.getOrDefault("api-version")
  valid_564566 = validateParameter(valid_564566, JString, required = true,
                                 default = nil)
  if valid_564566 != nil:
    section.add "api-version", valid_564566
  var valid_564567 = query.getOrDefault("$expand")
  valid_564567 = validateParameter(valid_564567, JString, required = false,
                                 default = nil)
  if valid_564567 != nil:
    section.add "$expand", valid_564567
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564568: Call_LoadBalancersGet_564559; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get network interface operation retrieves information about the specified network interface.
  ## 
  let valid = call_564568.validator(path, query, header, formData, body)
  let scheme = call_564568.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564568.url(scheme.get, call_564568.host, call_564568.base,
                         call_564568.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564568, url, valid)

proc call*(call_564569: Call_LoadBalancersGet_564559; loadBalancerName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          Expand: string = ""): Recallable =
  ## loadBalancersGet
  ## The Get network interface operation retrieves information about the specified network interface.
  ##   loadBalancerName: string (required)
  ##                   : The name of the loadBalancer.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : expand references resources.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564570 = newJObject()
  var query_564571 = newJObject()
  add(path_564570, "loadBalancerName", newJString(loadBalancerName))
  add(query_564571, "api-version", newJString(apiVersion))
  add(query_564571, "$expand", newJString(Expand))
  add(path_564570, "subscriptionId", newJString(subscriptionId))
  add(path_564570, "resourceGroupName", newJString(resourceGroupName))
  result = call_564569.call(path_564570, query_564571, nil, nil, nil)

var loadBalancersGet* = Call_LoadBalancersGet_564559(name: "loadBalancersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}",
    validator: validate_LoadBalancersGet_564560, base: "",
    url: url_LoadBalancersGet_564561, schemes: {Scheme.Https})
type
  Call_LoadBalancersDelete_564585 = ref object of OpenApiRestCall_563549
proc url_LoadBalancersDelete_564587(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "loadBalancerName" in path,
        "`loadBalancerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/loadBalancers/"),
               (kind: VariableSegment, value: "loadBalancerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoadBalancersDelete_564586(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## The delete loadbalancer operation deletes the specified loadbalancer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   loadBalancerName: JString (required)
  ##                   : The name of the loadBalancer.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `loadBalancerName` field"
  var valid_564588 = path.getOrDefault("loadBalancerName")
  valid_564588 = validateParameter(valid_564588, JString, required = true,
                                 default = nil)
  if valid_564588 != nil:
    section.add "loadBalancerName", valid_564588
  var valid_564589 = path.getOrDefault("subscriptionId")
  valid_564589 = validateParameter(valid_564589, JString, required = true,
                                 default = nil)
  if valid_564589 != nil:
    section.add "subscriptionId", valid_564589
  var valid_564590 = path.getOrDefault("resourceGroupName")
  valid_564590 = validateParameter(valid_564590, JString, required = true,
                                 default = nil)
  if valid_564590 != nil:
    section.add "resourceGroupName", valid_564590
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564591 = query.getOrDefault("api-version")
  valid_564591 = validateParameter(valid_564591, JString, required = true,
                                 default = nil)
  if valid_564591 != nil:
    section.add "api-version", valid_564591
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564592: Call_LoadBalancersDelete_564585; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete loadbalancer operation deletes the specified loadbalancer.
  ## 
  let valid = call_564592.validator(path, query, header, formData, body)
  let scheme = call_564592.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564592.url(scheme.get, call_564592.host, call_564592.base,
                         call_564592.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564592, url, valid)

proc call*(call_564593: Call_LoadBalancersDelete_564585; loadBalancerName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## loadBalancersDelete
  ## The delete loadbalancer operation deletes the specified loadbalancer.
  ##   loadBalancerName: string (required)
  ##                   : The name of the loadBalancer.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564594 = newJObject()
  var query_564595 = newJObject()
  add(path_564594, "loadBalancerName", newJString(loadBalancerName))
  add(query_564595, "api-version", newJString(apiVersion))
  add(path_564594, "subscriptionId", newJString(subscriptionId))
  add(path_564594, "resourceGroupName", newJString(resourceGroupName))
  result = call_564593.call(path_564594, query_564595, nil, nil, nil)

var loadBalancersDelete* = Call_LoadBalancersDelete_564585(
    name: "loadBalancersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}",
    validator: validate_LoadBalancersDelete_564586, base: "",
    url: url_LoadBalancersDelete_564587, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysList_564596 = ref object of OpenApiRestCall_563549
proc url_LocalNetworkGatewaysList_564598(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Network/localNetworkGateways")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocalNetworkGatewaysList_564597(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List LocalNetworkGateways operation retrieves all the local network gateways stored.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564599 = path.getOrDefault("subscriptionId")
  valid_564599 = validateParameter(valid_564599, JString, required = true,
                                 default = nil)
  if valid_564599 != nil:
    section.add "subscriptionId", valid_564599
  var valid_564600 = path.getOrDefault("resourceGroupName")
  valid_564600 = validateParameter(valid_564600, JString, required = true,
                                 default = nil)
  if valid_564600 != nil:
    section.add "resourceGroupName", valid_564600
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564601 = query.getOrDefault("api-version")
  valid_564601 = validateParameter(valid_564601, JString, required = true,
                                 default = nil)
  if valid_564601 != nil:
    section.add "api-version", valid_564601
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564602: Call_LocalNetworkGatewaysList_564596; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List LocalNetworkGateways operation retrieves all the local network gateways stored.
  ## 
  let valid = call_564602.validator(path, query, header, formData, body)
  let scheme = call_564602.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564602.url(scheme.get, call_564602.host, call_564602.base,
                         call_564602.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564602, url, valid)

proc call*(call_564603: Call_LocalNetworkGatewaysList_564596; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## localNetworkGatewaysList
  ## The List LocalNetworkGateways operation retrieves all the local network gateways stored.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564604 = newJObject()
  var query_564605 = newJObject()
  add(query_564605, "api-version", newJString(apiVersion))
  add(path_564604, "subscriptionId", newJString(subscriptionId))
  add(path_564604, "resourceGroupName", newJString(resourceGroupName))
  result = call_564603.call(path_564604, query_564605, nil, nil, nil)

var localNetworkGatewaysList* = Call_LocalNetworkGatewaysList_564596(
    name: "localNetworkGatewaysList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways",
    validator: validate_LocalNetworkGatewaysList_564597, base: "",
    url: url_LocalNetworkGatewaysList_564598, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysCreateOrUpdate_564617 = ref object of OpenApiRestCall_563549
proc url_LocalNetworkGatewaysCreateOrUpdate_564619(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "localNetworkGatewayName" in path,
        "`localNetworkGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/localNetworkGateways/"),
               (kind: VariableSegment, value: "localNetworkGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocalNetworkGatewaysCreateOrUpdate_564618(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put LocalNetworkGateway operation creates/updates a local network gateway in the specified resource group through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   localNetworkGatewayName: JString (required)
  ##                          : The name of the local network gateway.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `localNetworkGatewayName` field"
  var valid_564620 = path.getOrDefault("localNetworkGatewayName")
  valid_564620 = validateParameter(valid_564620, JString, required = true,
                                 default = nil)
  if valid_564620 != nil:
    section.add "localNetworkGatewayName", valid_564620
  var valid_564621 = path.getOrDefault("subscriptionId")
  valid_564621 = validateParameter(valid_564621, JString, required = true,
                                 default = nil)
  if valid_564621 != nil:
    section.add "subscriptionId", valid_564621
  var valid_564622 = path.getOrDefault("resourceGroupName")
  valid_564622 = validateParameter(valid_564622, JString, required = true,
                                 default = nil)
  if valid_564622 != nil:
    section.add "resourceGroupName", valid_564622
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564623 = query.getOrDefault("api-version")
  valid_564623 = validateParameter(valid_564623, JString, required = true,
                                 default = nil)
  if valid_564623 != nil:
    section.add "api-version", valid_564623
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Begin Create or update Local Network Gateway operation through Network resource provider.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564625: Call_LocalNetworkGatewaysCreateOrUpdate_564617;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put LocalNetworkGateway operation creates/updates a local network gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_564625.validator(path, query, header, formData, body)
  let scheme = call_564625.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564625.url(scheme.get, call_564625.host, call_564625.base,
                         call_564625.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564625, url, valid)

proc call*(call_564626: Call_LocalNetworkGatewaysCreateOrUpdate_564617;
          apiVersion: string; localNetworkGatewayName: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode): Recallable =
  ## localNetworkGatewaysCreateOrUpdate
  ## The Put LocalNetworkGateway operation creates/updates a local network gateway in the specified resource group through Network resource provider.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   localNetworkGatewayName: string (required)
  ##                          : The name of the local network gateway.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Begin Create or update Local Network Gateway operation through Network resource provider.
  var path_564627 = newJObject()
  var query_564628 = newJObject()
  var body_564629 = newJObject()
  add(query_564628, "api-version", newJString(apiVersion))
  add(path_564627, "localNetworkGatewayName", newJString(localNetworkGatewayName))
  add(path_564627, "subscriptionId", newJString(subscriptionId))
  add(path_564627, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564629 = parameters
  result = call_564626.call(path_564627, query_564628, nil, nil, body_564629)

var localNetworkGatewaysCreateOrUpdate* = Call_LocalNetworkGatewaysCreateOrUpdate_564617(
    name: "localNetworkGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways/{localNetworkGatewayName}",
    validator: validate_LocalNetworkGatewaysCreateOrUpdate_564618, base: "",
    url: url_LocalNetworkGatewaysCreateOrUpdate_564619, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysGet_564606 = ref object of OpenApiRestCall_563549
proc url_LocalNetworkGatewaysGet_564608(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "localNetworkGatewayName" in path,
        "`localNetworkGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/localNetworkGateways/"),
               (kind: VariableSegment, value: "localNetworkGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocalNetworkGatewaysGet_564607(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get LocalNetworkGateway operation retrieves information about the specified local network gateway through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   localNetworkGatewayName: JString (required)
  ##                          : The name of the local network gateway.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `localNetworkGatewayName` field"
  var valid_564609 = path.getOrDefault("localNetworkGatewayName")
  valid_564609 = validateParameter(valid_564609, JString, required = true,
                                 default = nil)
  if valid_564609 != nil:
    section.add "localNetworkGatewayName", valid_564609
  var valid_564610 = path.getOrDefault("subscriptionId")
  valid_564610 = validateParameter(valid_564610, JString, required = true,
                                 default = nil)
  if valid_564610 != nil:
    section.add "subscriptionId", valid_564610
  var valid_564611 = path.getOrDefault("resourceGroupName")
  valid_564611 = validateParameter(valid_564611, JString, required = true,
                                 default = nil)
  if valid_564611 != nil:
    section.add "resourceGroupName", valid_564611
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564612 = query.getOrDefault("api-version")
  valid_564612 = validateParameter(valid_564612, JString, required = true,
                                 default = nil)
  if valid_564612 != nil:
    section.add "api-version", valid_564612
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564613: Call_LocalNetworkGatewaysGet_564606; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get LocalNetworkGateway operation retrieves information about the specified local network gateway through Network resource provider.
  ## 
  let valid = call_564613.validator(path, query, header, formData, body)
  let scheme = call_564613.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564613.url(scheme.get, call_564613.host, call_564613.base,
                         call_564613.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564613, url, valid)

proc call*(call_564614: Call_LocalNetworkGatewaysGet_564606; apiVersion: string;
          localNetworkGatewayName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## localNetworkGatewaysGet
  ## The Get LocalNetworkGateway operation retrieves information about the specified local network gateway through Network resource provider.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   localNetworkGatewayName: string (required)
  ##                          : The name of the local network gateway.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564615 = newJObject()
  var query_564616 = newJObject()
  add(query_564616, "api-version", newJString(apiVersion))
  add(path_564615, "localNetworkGatewayName", newJString(localNetworkGatewayName))
  add(path_564615, "subscriptionId", newJString(subscriptionId))
  add(path_564615, "resourceGroupName", newJString(resourceGroupName))
  result = call_564614.call(path_564615, query_564616, nil, nil, nil)

var localNetworkGatewaysGet* = Call_LocalNetworkGatewaysGet_564606(
    name: "localNetworkGatewaysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways/{localNetworkGatewayName}",
    validator: validate_LocalNetworkGatewaysGet_564607, base: "",
    url: url_LocalNetworkGatewaysGet_564608, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysDelete_564630 = ref object of OpenApiRestCall_563549
proc url_LocalNetworkGatewaysDelete_564632(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "localNetworkGatewayName" in path,
        "`localNetworkGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/localNetworkGateways/"),
               (kind: VariableSegment, value: "localNetworkGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocalNetworkGatewaysDelete_564631(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Delete LocalNetworkGateway operation deletes the specified local network Gateway through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   localNetworkGatewayName: JString (required)
  ##                          : The name of the local network gateway.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `localNetworkGatewayName` field"
  var valid_564633 = path.getOrDefault("localNetworkGatewayName")
  valid_564633 = validateParameter(valid_564633, JString, required = true,
                                 default = nil)
  if valid_564633 != nil:
    section.add "localNetworkGatewayName", valid_564633
  var valid_564634 = path.getOrDefault("subscriptionId")
  valid_564634 = validateParameter(valid_564634, JString, required = true,
                                 default = nil)
  if valid_564634 != nil:
    section.add "subscriptionId", valid_564634
  var valid_564635 = path.getOrDefault("resourceGroupName")
  valid_564635 = validateParameter(valid_564635, JString, required = true,
                                 default = nil)
  if valid_564635 != nil:
    section.add "resourceGroupName", valid_564635
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564636 = query.getOrDefault("api-version")
  valid_564636 = validateParameter(valid_564636, JString, required = true,
                                 default = nil)
  if valid_564636 != nil:
    section.add "api-version", valid_564636
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564637: Call_LocalNetworkGatewaysDelete_564630; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete LocalNetworkGateway operation deletes the specified local network Gateway through Network resource provider.
  ## 
  let valid = call_564637.validator(path, query, header, formData, body)
  let scheme = call_564637.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564637.url(scheme.get, call_564637.host, call_564637.base,
                         call_564637.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564637, url, valid)

proc call*(call_564638: Call_LocalNetworkGatewaysDelete_564630; apiVersion: string;
          localNetworkGatewayName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## localNetworkGatewaysDelete
  ## The Delete LocalNetworkGateway operation deletes the specified local network Gateway through Network resource provider.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   localNetworkGatewayName: string (required)
  ##                          : The name of the local network gateway.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564639 = newJObject()
  var query_564640 = newJObject()
  add(query_564640, "api-version", newJString(apiVersion))
  add(path_564639, "localNetworkGatewayName", newJString(localNetworkGatewayName))
  add(path_564639, "subscriptionId", newJString(subscriptionId))
  add(path_564639, "resourceGroupName", newJString(resourceGroupName))
  result = call_564638.call(path_564639, query_564640, nil, nil, nil)

var localNetworkGatewaysDelete* = Call_LocalNetworkGatewaysDelete_564630(
    name: "localNetworkGatewaysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways/{localNetworkGatewayName}",
    validator: validate_LocalNetworkGatewaysDelete_564631, base: "",
    url: url_LocalNetworkGatewaysDelete_564632, schemes: {Scheme.Https})
type
  Call_NetworkInterfacesList_564641 = ref object of OpenApiRestCall_563549
proc url_NetworkInterfacesList_564643(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Network/networkInterfaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfacesList_564642(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List networkInterfaces operation retrieves all the networkInterfaces in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564644 = path.getOrDefault("subscriptionId")
  valid_564644 = validateParameter(valid_564644, JString, required = true,
                                 default = nil)
  if valid_564644 != nil:
    section.add "subscriptionId", valid_564644
  var valid_564645 = path.getOrDefault("resourceGroupName")
  valid_564645 = validateParameter(valid_564645, JString, required = true,
                                 default = nil)
  if valid_564645 != nil:
    section.add "resourceGroupName", valid_564645
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564646 = query.getOrDefault("api-version")
  valid_564646 = validateParameter(valid_564646, JString, required = true,
                                 default = nil)
  if valid_564646 != nil:
    section.add "api-version", valid_564646
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564647: Call_NetworkInterfacesList_564641; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List networkInterfaces operation retrieves all the networkInterfaces in a resource group.
  ## 
  let valid = call_564647.validator(path, query, header, formData, body)
  let scheme = call_564647.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564647.url(scheme.get, call_564647.host, call_564647.base,
                         call_564647.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564647, url, valid)

proc call*(call_564648: Call_NetworkInterfacesList_564641; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## networkInterfacesList
  ## The List networkInterfaces operation retrieves all the networkInterfaces in a resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564649 = newJObject()
  var query_564650 = newJObject()
  add(query_564650, "api-version", newJString(apiVersion))
  add(path_564649, "subscriptionId", newJString(subscriptionId))
  add(path_564649, "resourceGroupName", newJString(resourceGroupName))
  result = call_564648.call(path_564649, query_564650, nil, nil, nil)

var networkInterfacesList* = Call_NetworkInterfacesList_564641(
    name: "networkInterfacesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces",
    validator: validate_NetworkInterfacesList_564642, base: "",
    url: url_NetworkInterfacesList_564643, schemes: {Scheme.Https})
type
  Call_NetworkInterfacesCreateOrUpdate_564663 = ref object of OpenApiRestCall_563549
proc url_NetworkInterfacesCreateOrUpdate_564665(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkInterfaceName" in path,
        "`networkInterfaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkInterfaces/"),
               (kind: VariableSegment, value: "networkInterfaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfacesCreateOrUpdate_564664(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put NetworkInterface operation creates/updates a networkInterface
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkInterfaceName: JString (required)
  ##                       : The name of the network interface.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `networkInterfaceName` field"
  var valid_564666 = path.getOrDefault("networkInterfaceName")
  valid_564666 = validateParameter(valid_564666, JString, required = true,
                                 default = nil)
  if valid_564666 != nil:
    section.add "networkInterfaceName", valid_564666
  var valid_564667 = path.getOrDefault("subscriptionId")
  valid_564667 = validateParameter(valid_564667, JString, required = true,
                                 default = nil)
  if valid_564667 != nil:
    section.add "subscriptionId", valid_564667
  var valid_564668 = path.getOrDefault("resourceGroupName")
  valid_564668 = validateParameter(valid_564668, JString, required = true,
                                 default = nil)
  if valid_564668 != nil:
    section.add "resourceGroupName", valid_564668
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564669 = query.getOrDefault("api-version")
  valid_564669 = validateParameter(valid_564669, JString, required = true,
                                 default = nil)
  if valid_564669 != nil:
    section.add "api-version", valid_564669
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update NetworkInterface operation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564671: Call_NetworkInterfacesCreateOrUpdate_564663;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put NetworkInterface operation creates/updates a networkInterface
  ## 
  let valid = call_564671.validator(path, query, header, formData, body)
  let scheme = call_564671.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564671.url(scheme.get, call_564671.host, call_564671.base,
                         call_564671.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564671, url, valid)

proc call*(call_564672: Call_NetworkInterfacesCreateOrUpdate_564663;
          apiVersion: string; networkInterfaceName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## networkInterfacesCreateOrUpdate
  ## The Put NetworkInterface operation creates/updates a networkInterface
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   networkInterfaceName: string (required)
  ##                       : The name of the network interface.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update NetworkInterface operation
  var path_564673 = newJObject()
  var query_564674 = newJObject()
  var body_564675 = newJObject()
  add(query_564674, "api-version", newJString(apiVersion))
  add(path_564673, "networkInterfaceName", newJString(networkInterfaceName))
  add(path_564673, "subscriptionId", newJString(subscriptionId))
  add(path_564673, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564675 = parameters
  result = call_564672.call(path_564673, query_564674, nil, nil, body_564675)

var networkInterfacesCreateOrUpdate* = Call_NetworkInterfacesCreateOrUpdate_564663(
    name: "networkInterfacesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/{networkInterfaceName}",
    validator: validate_NetworkInterfacesCreateOrUpdate_564664, base: "",
    url: url_NetworkInterfacesCreateOrUpdate_564665, schemes: {Scheme.Https})
type
  Call_NetworkInterfacesGet_564651 = ref object of OpenApiRestCall_563549
proc url_NetworkInterfacesGet_564653(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkInterfaceName" in path,
        "`networkInterfaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkInterfaces/"),
               (kind: VariableSegment, value: "networkInterfaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfacesGet_564652(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get network interface operation retrieves information about the specified network interface.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkInterfaceName: JString (required)
  ##                       : The name of the network interface.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `networkInterfaceName` field"
  var valid_564654 = path.getOrDefault("networkInterfaceName")
  valid_564654 = validateParameter(valid_564654, JString, required = true,
                                 default = nil)
  if valid_564654 != nil:
    section.add "networkInterfaceName", valid_564654
  var valid_564655 = path.getOrDefault("subscriptionId")
  valid_564655 = validateParameter(valid_564655, JString, required = true,
                                 default = nil)
  if valid_564655 != nil:
    section.add "subscriptionId", valid_564655
  var valid_564656 = path.getOrDefault("resourceGroupName")
  valid_564656 = validateParameter(valid_564656, JString, required = true,
                                 default = nil)
  if valid_564656 != nil:
    section.add "resourceGroupName", valid_564656
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564657 = query.getOrDefault("api-version")
  valid_564657 = validateParameter(valid_564657, JString, required = true,
                                 default = nil)
  if valid_564657 != nil:
    section.add "api-version", valid_564657
  var valid_564658 = query.getOrDefault("$expand")
  valid_564658 = validateParameter(valid_564658, JString, required = false,
                                 default = nil)
  if valid_564658 != nil:
    section.add "$expand", valid_564658
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564659: Call_NetworkInterfacesGet_564651; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get network interface operation retrieves information about the specified network interface.
  ## 
  let valid = call_564659.validator(path, query, header, formData, body)
  let scheme = call_564659.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564659.url(scheme.get, call_564659.host, call_564659.base,
                         call_564659.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564659, url, valid)

proc call*(call_564660: Call_NetworkInterfacesGet_564651; apiVersion: string;
          networkInterfaceName: string; subscriptionId: string;
          resourceGroupName: string; Expand: string = ""): Recallable =
  ## networkInterfacesGet
  ## The Get network interface operation retrieves information about the specified network interface.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   networkInterfaceName: string (required)
  ##                       : The name of the network interface.
  ##   Expand: string
  ##         : expand references resources.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564661 = newJObject()
  var query_564662 = newJObject()
  add(query_564662, "api-version", newJString(apiVersion))
  add(path_564661, "networkInterfaceName", newJString(networkInterfaceName))
  add(query_564662, "$expand", newJString(Expand))
  add(path_564661, "subscriptionId", newJString(subscriptionId))
  add(path_564661, "resourceGroupName", newJString(resourceGroupName))
  result = call_564660.call(path_564661, query_564662, nil, nil, nil)

var networkInterfacesGet* = Call_NetworkInterfacesGet_564651(
    name: "networkInterfacesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/{networkInterfaceName}",
    validator: validate_NetworkInterfacesGet_564652, base: "",
    url: url_NetworkInterfacesGet_564653, schemes: {Scheme.Https})
type
  Call_NetworkInterfacesDelete_564676 = ref object of OpenApiRestCall_563549
proc url_NetworkInterfacesDelete_564678(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkInterfaceName" in path,
        "`networkInterfaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkInterfaces/"),
               (kind: VariableSegment, value: "networkInterfaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfacesDelete_564677(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The delete networkInterface operation deletes the specified networkInterface.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkInterfaceName: JString (required)
  ##                       : The name of the network interface.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `networkInterfaceName` field"
  var valid_564679 = path.getOrDefault("networkInterfaceName")
  valid_564679 = validateParameter(valid_564679, JString, required = true,
                                 default = nil)
  if valid_564679 != nil:
    section.add "networkInterfaceName", valid_564679
  var valid_564680 = path.getOrDefault("subscriptionId")
  valid_564680 = validateParameter(valid_564680, JString, required = true,
                                 default = nil)
  if valid_564680 != nil:
    section.add "subscriptionId", valid_564680
  var valid_564681 = path.getOrDefault("resourceGroupName")
  valid_564681 = validateParameter(valid_564681, JString, required = true,
                                 default = nil)
  if valid_564681 != nil:
    section.add "resourceGroupName", valid_564681
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564682 = query.getOrDefault("api-version")
  valid_564682 = validateParameter(valid_564682, JString, required = true,
                                 default = nil)
  if valid_564682 != nil:
    section.add "api-version", valid_564682
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564683: Call_NetworkInterfacesDelete_564676; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete networkInterface operation deletes the specified networkInterface.
  ## 
  let valid = call_564683.validator(path, query, header, formData, body)
  let scheme = call_564683.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564683.url(scheme.get, call_564683.host, call_564683.base,
                         call_564683.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564683, url, valid)

proc call*(call_564684: Call_NetworkInterfacesDelete_564676; apiVersion: string;
          networkInterfaceName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## networkInterfacesDelete
  ## The delete networkInterface operation deletes the specified networkInterface.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   networkInterfaceName: string (required)
  ##                       : The name of the network interface.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564685 = newJObject()
  var query_564686 = newJObject()
  add(query_564686, "api-version", newJString(apiVersion))
  add(path_564685, "networkInterfaceName", newJString(networkInterfaceName))
  add(path_564685, "subscriptionId", newJString(subscriptionId))
  add(path_564685, "resourceGroupName", newJString(resourceGroupName))
  result = call_564684.call(path_564685, query_564686, nil, nil, nil)

var networkInterfacesDelete* = Call_NetworkInterfacesDelete_564676(
    name: "networkInterfacesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/{networkInterfaceName}",
    validator: validate_NetworkInterfacesDelete_564677, base: "",
    url: url_NetworkInterfacesDelete_564678, schemes: {Scheme.Https})
type
  Call_NetworkSecurityGroupsList_564687 = ref object of OpenApiRestCall_563549
proc url_NetworkSecurityGroupsList_564689(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Network/networkSecurityGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkSecurityGroupsList_564688(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The list NetworkSecurityGroups returns all network security groups in a resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564690 = path.getOrDefault("subscriptionId")
  valid_564690 = validateParameter(valid_564690, JString, required = true,
                                 default = nil)
  if valid_564690 != nil:
    section.add "subscriptionId", valid_564690
  var valid_564691 = path.getOrDefault("resourceGroupName")
  valid_564691 = validateParameter(valid_564691, JString, required = true,
                                 default = nil)
  if valid_564691 != nil:
    section.add "resourceGroupName", valid_564691
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564692 = query.getOrDefault("api-version")
  valid_564692 = validateParameter(valid_564692, JString, required = true,
                                 default = nil)
  if valid_564692 != nil:
    section.add "api-version", valid_564692
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564693: Call_NetworkSecurityGroupsList_564687; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list NetworkSecurityGroups returns all network security groups in a resource group
  ## 
  let valid = call_564693.validator(path, query, header, formData, body)
  let scheme = call_564693.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564693.url(scheme.get, call_564693.host, call_564693.base,
                         call_564693.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564693, url, valid)

proc call*(call_564694: Call_NetworkSecurityGroupsList_564687; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## networkSecurityGroupsList
  ## The list NetworkSecurityGroups returns all network security groups in a resource group
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564695 = newJObject()
  var query_564696 = newJObject()
  add(query_564696, "api-version", newJString(apiVersion))
  add(path_564695, "subscriptionId", newJString(subscriptionId))
  add(path_564695, "resourceGroupName", newJString(resourceGroupName))
  result = call_564694.call(path_564695, query_564696, nil, nil, nil)

var networkSecurityGroupsList* = Call_NetworkSecurityGroupsList_564687(
    name: "networkSecurityGroupsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups",
    validator: validate_NetworkSecurityGroupsList_564688, base: "",
    url: url_NetworkSecurityGroupsList_564689, schemes: {Scheme.Https})
type
  Call_NetworkSecurityGroupsCreateOrUpdate_564709 = ref object of OpenApiRestCall_563549
proc url_NetworkSecurityGroupsCreateOrUpdate_564711(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkSecurityGroupName" in path,
        "`networkSecurityGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkSecurityGroups/"),
               (kind: VariableSegment, value: "networkSecurityGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkSecurityGroupsCreateOrUpdate_564710(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put NetworkSecurityGroup operation creates/updates a network security group in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   networkSecurityGroupName: JString (required)
  ##                           : The name of the network security group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564712 = path.getOrDefault("subscriptionId")
  valid_564712 = validateParameter(valid_564712, JString, required = true,
                                 default = nil)
  if valid_564712 != nil:
    section.add "subscriptionId", valid_564712
  var valid_564713 = path.getOrDefault("resourceGroupName")
  valid_564713 = validateParameter(valid_564713, JString, required = true,
                                 default = nil)
  if valid_564713 != nil:
    section.add "resourceGroupName", valid_564713
  var valid_564714 = path.getOrDefault("networkSecurityGroupName")
  valid_564714 = validateParameter(valid_564714, JString, required = true,
                                 default = nil)
  if valid_564714 != nil:
    section.add "networkSecurityGroupName", valid_564714
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564715 = query.getOrDefault("api-version")
  valid_564715 = validateParameter(valid_564715, JString, required = true,
                                 default = nil)
  if valid_564715 != nil:
    section.add "api-version", valid_564715
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update Network Security Group operation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564717: Call_NetworkSecurityGroupsCreateOrUpdate_564709;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put NetworkSecurityGroup operation creates/updates a network security group in the specified resource group.
  ## 
  let valid = call_564717.validator(path, query, header, formData, body)
  let scheme = call_564717.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564717.url(scheme.get, call_564717.host, call_564717.base,
                         call_564717.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564717, url, valid)

proc call*(call_564718: Call_NetworkSecurityGroupsCreateOrUpdate_564709;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          networkSecurityGroupName: string; parameters: JsonNode): Recallable =
  ## networkSecurityGroupsCreateOrUpdate
  ## The Put NetworkSecurityGroup operation creates/updates a network security group in the specified resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   networkSecurityGroupName: string (required)
  ##                           : The name of the network security group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update Network Security Group operation
  var path_564719 = newJObject()
  var query_564720 = newJObject()
  var body_564721 = newJObject()
  add(query_564720, "api-version", newJString(apiVersion))
  add(path_564719, "subscriptionId", newJString(subscriptionId))
  add(path_564719, "resourceGroupName", newJString(resourceGroupName))
  add(path_564719, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  if parameters != nil:
    body_564721 = parameters
  result = call_564718.call(path_564719, query_564720, nil, nil, body_564721)

var networkSecurityGroupsCreateOrUpdate* = Call_NetworkSecurityGroupsCreateOrUpdate_564709(
    name: "networkSecurityGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}",
    validator: validate_NetworkSecurityGroupsCreateOrUpdate_564710, base: "",
    url: url_NetworkSecurityGroupsCreateOrUpdate_564711, schemes: {Scheme.Https})
type
  Call_NetworkSecurityGroupsGet_564697 = ref object of OpenApiRestCall_563549
proc url_NetworkSecurityGroupsGet_564699(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkSecurityGroupName" in path,
        "`networkSecurityGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkSecurityGroups/"),
               (kind: VariableSegment, value: "networkSecurityGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkSecurityGroupsGet_564698(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get NetworkSecurityGroups operation retrieves information about the specified network security group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   networkSecurityGroupName: JString (required)
  ##                           : The name of the network security group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564700 = path.getOrDefault("subscriptionId")
  valid_564700 = validateParameter(valid_564700, JString, required = true,
                                 default = nil)
  if valid_564700 != nil:
    section.add "subscriptionId", valid_564700
  var valid_564701 = path.getOrDefault("resourceGroupName")
  valid_564701 = validateParameter(valid_564701, JString, required = true,
                                 default = nil)
  if valid_564701 != nil:
    section.add "resourceGroupName", valid_564701
  var valid_564702 = path.getOrDefault("networkSecurityGroupName")
  valid_564702 = validateParameter(valid_564702, JString, required = true,
                                 default = nil)
  if valid_564702 != nil:
    section.add "networkSecurityGroupName", valid_564702
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564703 = query.getOrDefault("api-version")
  valid_564703 = validateParameter(valid_564703, JString, required = true,
                                 default = nil)
  if valid_564703 != nil:
    section.add "api-version", valid_564703
  var valid_564704 = query.getOrDefault("$expand")
  valid_564704 = validateParameter(valid_564704, JString, required = false,
                                 default = nil)
  if valid_564704 != nil:
    section.add "$expand", valid_564704
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564705: Call_NetworkSecurityGroupsGet_564697; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get NetworkSecurityGroups operation retrieves information about the specified network security group.
  ## 
  let valid = call_564705.validator(path, query, header, formData, body)
  let scheme = call_564705.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564705.url(scheme.get, call_564705.host, call_564705.base,
                         call_564705.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564705, url, valid)

proc call*(call_564706: Call_NetworkSecurityGroupsGet_564697; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          networkSecurityGroupName: string; Expand: string = ""): Recallable =
  ## networkSecurityGroupsGet
  ## The Get NetworkSecurityGroups operation retrieves information about the specified network security group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : expand references resources.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   networkSecurityGroupName: string (required)
  ##                           : The name of the network security group.
  var path_564707 = newJObject()
  var query_564708 = newJObject()
  add(query_564708, "api-version", newJString(apiVersion))
  add(query_564708, "$expand", newJString(Expand))
  add(path_564707, "subscriptionId", newJString(subscriptionId))
  add(path_564707, "resourceGroupName", newJString(resourceGroupName))
  add(path_564707, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  result = call_564706.call(path_564707, query_564708, nil, nil, nil)

var networkSecurityGroupsGet* = Call_NetworkSecurityGroupsGet_564697(
    name: "networkSecurityGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}",
    validator: validate_NetworkSecurityGroupsGet_564698, base: "",
    url: url_NetworkSecurityGroupsGet_564699, schemes: {Scheme.Https})
type
  Call_NetworkSecurityGroupsDelete_564722 = ref object of OpenApiRestCall_563549
proc url_NetworkSecurityGroupsDelete_564724(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkSecurityGroupName" in path,
        "`networkSecurityGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkSecurityGroups/"),
               (kind: VariableSegment, value: "networkSecurityGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkSecurityGroupsDelete_564723(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Delete NetworkSecurityGroup operation deletes the specified network security group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   networkSecurityGroupName: JString (required)
  ##                           : The name of the network security group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564725 = path.getOrDefault("subscriptionId")
  valid_564725 = validateParameter(valid_564725, JString, required = true,
                                 default = nil)
  if valid_564725 != nil:
    section.add "subscriptionId", valid_564725
  var valid_564726 = path.getOrDefault("resourceGroupName")
  valid_564726 = validateParameter(valid_564726, JString, required = true,
                                 default = nil)
  if valid_564726 != nil:
    section.add "resourceGroupName", valid_564726
  var valid_564727 = path.getOrDefault("networkSecurityGroupName")
  valid_564727 = validateParameter(valid_564727, JString, required = true,
                                 default = nil)
  if valid_564727 != nil:
    section.add "networkSecurityGroupName", valid_564727
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564728 = query.getOrDefault("api-version")
  valid_564728 = validateParameter(valid_564728, JString, required = true,
                                 default = nil)
  if valid_564728 != nil:
    section.add "api-version", valid_564728
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564729: Call_NetworkSecurityGroupsDelete_564722; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete NetworkSecurityGroup operation deletes the specified network security group
  ## 
  let valid = call_564729.validator(path, query, header, formData, body)
  let scheme = call_564729.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564729.url(scheme.get, call_564729.host, call_564729.base,
                         call_564729.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564729, url, valid)

proc call*(call_564730: Call_NetworkSecurityGroupsDelete_564722;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          networkSecurityGroupName: string): Recallable =
  ## networkSecurityGroupsDelete
  ## The Delete NetworkSecurityGroup operation deletes the specified network security group
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   networkSecurityGroupName: string (required)
  ##                           : The name of the network security group.
  var path_564731 = newJObject()
  var query_564732 = newJObject()
  add(query_564732, "api-version", newJString(apiVersion))
  add(path_564731, "subscriptionId", newJString(subscriptionId))
  add(path_564731, "resourceGroupName", newJString(resourceGroupName))
  add(path_564731, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  result = call_564730.call(path_564731, query_564732, nil, nil, nil)

var networkSecurityGroupsDelete* = Call_NetworkSecurityGroupsDelete_564722(
    name: "networkSecurityGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}",
    validator: validate_NetworkSecurityGroupsDelete_564723, base: "",
    url: url_NetworkSecurityGroupsDelete_564724, schemes: {Scheme.Https})
type
  Call_SecurityRulesList_564733 = ref object of OpenApiRestCall_563549
proc url_SecurityRulesList_564735(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkSecurityGroupName" in path,
        "`networkSecurityGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkSecurityGroups/"),
               (kind: VariableSegment, value: "networkSecurityGroupName"),
               (kind: ConstantSegment, value: "/securityRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecurityRulesList_564734(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## The List network security rule operation retrieves all the security rules in a network security group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   networkSecurityGroupName: JString (required)
  ##                           : The name of the network security group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564736 = path.getOrDefault("subscriptionId")
  valid_564736 = validateParameter(valid_564736, JString, required = true,
                                 default = nil)
  if valid_564736 != nil:
    section.add "subscriptionId", valid_564736
  var valid_564737 = path.getOrDefault("resourceGroupName")
  valid_564737 = validateParameter(valid_564737, JString, required = true,
                                 default = nil)
  if valid_564737 != nil:
    section.add "resourceGroupName", valid_564737
  var valid_564738 = path.getOrDefault("networkSecurityGroupName")
  valid_564738 = validateParameter(valid_564738, JString, required = true,
                                 default = nil)
  if valid_564738 != nil:
    section.add "networkSecurityGroupName", valid_564738
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564739 = query.getOrDefault("api-version")
  valid_564739 = validateParameter(valid_564739, JString, required = true,
                                 default = nil)
  if valid_564739 != nil:
    section.add "api-version", valid_564739
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564740: Call_SecurityRulesList_564733; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List network security rule operation retrieves all the security rules in a network security group.
  ## 
  let valid = call_564740.validator(path, query, header, formData, body)
  let scheme = call_564740.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564740.url(scheme.get, call_564740.host, call_564740.base,
                         call_564740.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564740, url, valid)

proc call*(call_564741: Call_SecurityRulesList_564733; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          networkSecurityGroupName: string): Recallable =
  ## securityRulesList
  ## The List network security rule operation retrieves all the security rules in a network security group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   networkSecurityGroupName: string (required)
  ##                           : The name of the network security group.
  var path_564742 = newJObject()
  var query_564743 = newJObject()
  add(query_564743, "api-version", newJString(apiVersion))
  add(path_564742, "subscriptionId", newJString(subscriptionId))
  add(path_564742, "resourceGroupName", newJString(resourceGroupName))
  add(path_564742, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  result = call_564741.call(path_564742, query_564743, nil, nil, nil)

var securityRulesList* = Call_SecurityRulesList_564733(name: "securityRulesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}/securityRules",
    validator: validate_SecurityRulesList_564734, base: "",
    url: url_SecurityRulesList_564735, schemes: {Scheme.Https})
type
  Call_SecurityRulesCreateOrUpdate_564756 = ref object of OpenApiRestCall_563549
proc url_SecurityRulesCreateOrUpdate_564758(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkSecurityGroupName" in path,
        "`networkSecurityGroupName` is a required path parameter"
  assert "securityRuleName" in path,
        "`securityRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkSecurityGroups/"),
               (kind: VariableSegment, value: "networkSecurityGroupName"),
               (kind: ConstantSegment, value: "/securityRules/"),
               (kind: VariableSegment, value: "securityRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecurityRulesCreateOrUpdate_564757(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put network security rule operation creates/updates a security rule in the specified network security group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   securityRuleName: JString (required)
  ##                   : The name of the security rule.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   networkSecurityGroupName: JString (required)
  ##                           : The name of the network security group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `securityRuleName` field"
  var valid_564759 = path.getOrDefault("securityRuleName")
  valid_564759 = validateParameter(valid_564759, JString, required = true,
                                 default = nil)
  if valid_564759 != nil:
    section.add "securityRuleName", valid_564759
  var valid_564760 = path.getOrDefault("subscriptionId")
  valid_564760 = validateParameter(valid_564760, JString, required = true,
                                 default = nil)
  if valid_564760 != nil:
    section.add "subscriptionId", valid_564760
  var valid_564761 = path.getOrDefault("resourceGroupName")
  valid_564761 = validateParameter(valid_564761, JString, required = true,
                                 default = nil)
  if valid_564761 != nil:
    section.add "resourceGroupName", valid_564761
  var valid_564762 = path.getOrDefault("networkSecurityGroupName")
  valid_564762 = validateParameter(valid_564762, JString, required = true,
                                 default = nil)
  if valid_564762 != nil:
    section.add "networkSecurityGroupName", valid_564762
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564763 = query.getOrDefault("api-version")
  valid_564763 = validateParameter(valid_564763, JString, required = true,
                                 default = nil)
  if valid_564763 != nil:
    section.add "api-version", valid_564763
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   securityRuleParameters: JObject (required)
  ##                         : Parameters supplied to the create/update network security rule operation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564765: Call_SecurityRulesCreateOrUpdate_564756; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put network security rule operation creates/updates a security rule in the specified network security group
  ## 
  let valid = call_564765.validator(path, query, header, formData, body)
  let scheme = call_564765.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564765.url(scheme.get, call_564765.host, call_564765.base,
                         call_564765.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564765, url, valid)

proc call*(call_564766: Call_SecurityRulesCreateOrUpdate_564756;
          securityRuleName: string; apiVersion: string;
          securityRuleParameters: JsonNode; subscriptionId: string;
          resourceGroupName: string; networkSecurityGroupName: string): Recallable =
  ## securityRulesCreateOrUpdate
  ## The Put network security rule operation creates/updates a security rule in the specified network security group
  ##   securityRuleName: string (required)
  ##                   : The name of the security rule.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   securityRuleParameters: JObject (required)
  ##                         : Parameters supplied to the create/update network security rule operation
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   networkSecurityGroupName: string (required)
  ##                           : The name of the network security group.
  var path_564767 = newJObject()
  var query_564768 = newJObject()
  var body_564769 = newJObject()
  add(path_564767, "securityRuleName", newJString(securityRuleName))
  add(query_564768, "api-version", newJString(apiVersion))
  if securityRuleParameters != nil:
    body_564769 = securityRuleParameters
  add(path_564767, "subscriptionId", newJString(subscriptionId))
  add(path_564767, "resourceGroupName", newJString(resourceGroupName))
  add(path_564767, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  result = call_564766.call(path_564767, query_564768, nil, nil, body_564769)

var securityRulesCreateOrUpdate* = Call_SecurityRulesCreateOrUpdate_564756(
    name: "securityRulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}/securityRules/{securityRuleName}",
    validator: validate_SecurityRulesCreateOrUpdate_564757, base: "",
    url: url_SecurityRulesCreateOrUpdate_564758, schemes: {Scheme.Https})
type
  Call_SecurityRulesGet_564744 = ref object of OpenApiRestCall_563549
proc url_SecurityRulesGet_564746(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkSecurityGroupName" in path,
        "`networkSecurityGroupName` is a required path parameter"
  assert "securityRuleName" in path,
        "`securityRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkSecurityGroups/"),
               (kind: VariableSegment, value: "networkSecurityGroupName"),
               (kind: ConstantSegment, value: "/securityRules/"),
               (kind: VariableSegment, value: "securityRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecurityRulesGet_564745(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## The Get NetworkSecurityRule operation retrieves information about the specified network security rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   securityRuleName: JString (required)
  ##                   : The name of the security rule.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   networkSecurityGroupName: JString (required)
  ##                           : The name of the network security group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `securityRuleName` field"
  var valid_564747 = path.getOrDefault("securityRuleName")
  valid_564747 = validateParameter(valid_564747, JString, required = true,
                                 default = nil)
  if valid_564747 != nil:
    section.add "securityRuleName", valid_564747
  var valid_564748 = path.getOrDefault("subscriptionId")
  valid_564748 = validateParameter(valid_564748, JString, required = true,
                                 default = nil)
  if valid_564748 != nil:
    section.add "subscriptionId", valid_564748
  var valid_564749 = path.getOrDefault("resourceGroupName")
  valid_564749 = validateParameter(valid_564749, JString, required = true,
                                 default = nil)
  if valid_564749 != nil:
    section.add "resourceGroupName", valid_564749
  var valid_564750 = path.getOrDefault("networkSecurityGroupName")
  valid_564750 = validateParameter(valid_564750, JString, required = true,
                                 default = nil)
  if valid_564750 != nil:
    section.add "networkSecurityGroupName", valid_564750
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564751 = query.getOrDefault("api-version")
  valid_564751 = validateParameter(valid_564751, JString, required = true,
                                 default = nil)
  if valid_564751 != nil:
    section.add "api-version", valid_564751
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564752: Call_SecurityRulesGet_564744; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get NetworkSecurityRule operation retrieves information about the specified network security rule.
  ## 
  let valid = call_564752.validator(path, query, header, formData, body)
  let scheme = call_564752.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564752.url(scheme.get, call_564752.host, call_564752.base,
                         call_564752.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564752, url, valid)

proc call*(call_564753: Call_SecurityRulesGet_564744; securityRuleName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          networkSecurityGroupName: string): Recallable =
  ## securityRulesGet
  ## The Get NetworkSecurityRule operation retrieves information about the specified network security rule.
  ##   securityRuleName: string (required)
  ##                   : The name of the security rule.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   networkSecurityGroupName: string (required)
  ##                           : The name of the network security group.
  var path_564754 = newJObject()
  var query_564755 = newJObject()
  add(path_564754, "securityRuleName", newJString(securityRuleName))
  add(query_564755, "api-version", newJString(apiVersion))
  add(path_564754, "subscriptionId", newJString(subscriptionId))
  add(path_564754, "resourceGroupName", newJString(resourceGroupName))
  add(path_564754, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  result = call_564753.call(path_564754, query_564755, nil, nil, nil)

var securityRulesGet* = Call_SecurityRulesGet_564744(name: "securityRulesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}/securityRules/{securityRuleName}",
    validator: validate_SecurityRulesGet_564745, base: "",
    url: url_SecurityRulesGet_564746, schemes: {Scheme.Https})
type
  Call_SecurityRulesDelete_564770 = ref object of OpenApiRestCall_563549
proc url_SecurityRulesDelete_564772(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkSecurityGroupName" in path,
        "`networkSecurityGroupName` is a required path parameter"
  assert "securityRuleName" in path,
        "`securityRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/networkSecurityGroups/"),
               (kind: VariableSegment, value: "networkSecurityGroupName"),
               (kind: ConstantSegment, value: "/securityRules/"),
               (kind: VariableSegment, value: "securityRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecurityRulesDelete_564771(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## The delete network security rule operation deletes the specified network security rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   securityRuleName: JString (required)
  ##                   : The name of the security rule.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   networkSecurityGroupName: JString (required)
  ##                           : The name of the network security group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `securityRuleName` field"
  var valid_564773 = path.getOrDefault("securityRuleName")
  valid_564773 = validateParameter(valid_564773, JString, required = true,
                                 default = nil)
  if valid_564773 != nil:
    section.add "securityRuleName", valid_564773
  var valid_564774 = path.getOrDefault("subscriptionId")
  valid_564774 = validateParameter(valid_564774, JString, required = true,
                                 default = nil)
  if valid_564774 != nil:
    section.add "subscriptionId", valid_564774
  var valid_564775 = path.getOrDefault("resourceGroupName")
  valid_564775 = validateParameter(valid_564775, JString, required = true,
                                 default = nil)
  if valid_564775 != nil:
    section.add "resourceGroupName", valid_564775
  var valid_564776 = path.getOrDefault("networkSecurityGroupName")
  valid_564776 = validateParameter(valid_564776, JString, required = true,
                                 default = nil)
  if valid_564776 != nil:
    section.add "networkSecurityGroupName", valid_564776
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564777 = query.getOrDefault("api-version")
  valid_564777 = validateParameter(valid_564777, JString, required = true,
                                 default = nil)
  if valid_564777 != nil:
    section.add "api-version", valid_564777
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564778: Call_SecurityRulesDelete_564770; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete network security rule operation deletes the specified network security rule.
  ## 
  let valid = call_564778.validator(path, query, header, formData, body)
  let scheme = call_564778.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564778.url(scheme.get, call_564778.host, call_564778.base,
                         call_564778.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564778, url, valid)

proc call*(call_564779: Call_SecurityRulesDelete_564770; securityRuleName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          networkSecurityGroupName: string): Recallable =
  ## securityRulesDelete
  ## The delete network security rule operation deletes the specified network security rule.
  ##   securityRuleName: string (required)
  ##                   : The name of the security rule.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   networkSecurityGroupName: string (required)
  ##                           : The name of the network security group.
  var path_564780 = newJObject()
  var query_564781 = newJObject()
  add(path_564780, "securityRuleName", newJString(securityRuleName))
  add(query_564781, "api-version", newJString(apiVersion))
  add(path_564780, "subscriptionId", newJString(subscriptionId))
  add(path_564780, "resourceGroupName", newJString(resourceGroupName))
  add(path_564780, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  result = call_564779.call(path_564780, query_564781, nil, nil, nil)

var securityRulesDelete* = Call_SecurityRulesDelete_564770(
    name: "securityRulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}/securityRules/{securityRuleName}",
    validator: validate_SecurityRulesDelete_564771, base: "",
    url: url_SecurityRulesDelete_564772, schemes: {Scheme.Https})
type
  Call_PublicIPAddressesList_564782 = ref object of OpenApiRestCall_563549
proc url_PublicIPAddressesList_564784(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Network/publicIPAddresses")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PublicIPAddressesList_564783(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List publicIpAddress operation retrieves all the publicIpAddresses in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564785 = path.getOrDefault("subscriptionId")
  valid_564785 = validateParameter(valid_564785, JString, required = true,
                                 default = nil)
  if valid_564785 != nil:
    section.add "subscriptionId", valid_564785
  var valid_564786 = path.getOrDefault("resourceGroupName")
  valid_564786 = validateParameter(valid_564786, JString, required = true,
                                 default = nil)
  if valid_564786 != nil:
    section.add "resourceGroupName", valid_564786
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564787 = query.getOrDefault("api-version")
  valid_564787 = validateParameter(valid_564787, JString, required = true,
                                 default = nil)
  if valid_564787 != nil:
    section.add "api-version", valid_564787
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564788: Call_PublicIPAddressesList_564782; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List publicIpAddress operation retrieves all the publicIpAddresses in a resource group.
  ## 
  let valid = call_564788.validator(path, query, header, formData, body)
  let scheme = call_564788.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564788.url(scheme.get, call_564788.host, call_564788.base,
                         call_564788.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564788, url, valid)

proc call*(call_564789: Call_PublicIPAddressesList_564782; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## publicIPAddressesList
  ## The List publicIpAddress operation retrieves all the publicIpAddresses in a resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564790 = newJObject()
  var query_564791 = newJObject()
  add(query_564791, "api-version", newJString(apiVersion))
  add(path_564790, "subscriptionId", newJString(subscriptionId))
  add(path_564790, "resourceGroupName", newJString(resourceGroupName))
  result = call_564789.call(path_564790, query_564791, nil, nil, nil)

var publicIPAddressesList* = Call_PublicIPAddressesList_564782(
    name: "publicIPAddressesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses",
    validator: validate_PublicIPAddressesList_564783, base: "",
    url: url_PublicIPAddressesList_564784, schemes: {Scheme.Https})
type
  Call_PublicIPAddressesCreateOrUpdate_564804 = ref object of OpenApiRestCall_563549
proc url_PublicIPAddressesCreateOrUpdate_564806(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "publicIpAddressName" in path,
        "`publicIpAddressName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/publicIPAddresses/"),
               (kind: VariableSegment, value: "publicIpAddressName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PublicIPAddressesCreateOrUpdate_564805(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put PublicIPAddress operation creates/updates a stable/dynamic PublicIP address
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   publicIpAddressName: JString (required)
  ##                      : The name of the publicIpAddress.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564807 = path.getOrDefault("subscriptionId")
  valid_564807 = validateParameter(valid_564807, JString, required = true,
                                 default = nil)
  if valid_564807 != nil:
    section.add "subscriptionId", valid_564807
  var valid_564808 = path.getOrDefault("resourceGroupName")
  valid_564808 = validateParameter(valid_564808, JString, required = true,
                                 default = nil)
  if valid_564808 != nil:
    section.add "resourceGroupName", valid_564808
  var valid_564809 = path.getOrDefault("publicIpAddressName")
  valid_564809 = validateParameter(valid_564809, JString, required = true,
                                 default = nil)
  if valid_564809 != nil:
    section.add "publicIpAddressName", valid_564809
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564810 = query.getOrDefault("api-version")
  valid_564810 = validateParameter(valid_564810, JString, required = true,
                                 default = nil)
  if valid_564810 != nil:
    section.add "api-version", valid_564810
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update PublicIPAddress operation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564812: Call_PublicIPAddressesCreateOrUpdate_564804;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put PublicIPAddress operation creates/updates a stable/dynamic PublicIP address
  ## 
  let valid = call_564812.validator(path, query, header, formData, body)
  let scheme = call_564812.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564812.url(scheme.get, call_564812.host, call_564812.base,
                         call_564812.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564812, url, valid)

proc call*(call_564813: Call_PublicIPAddressesCreateOrUpdate_564804;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode; publicIpAddressName: string): Recallable =
  ## publicIPAddressesCreateOrUpdate
  ## The Put PublicIPAddress operation creates/updates a stable/dynamic PublicIP address
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update PublicIPAddress operation
  ##   publicIpAddressName: string (required)
  ##                      : The name of the publicIpAddress.
  var path_564814 = newJObject()
  var query_564815 = newJObject()
  var body_564816 = newJObject()
  add(query_564815, "api-version", newJString(apiVersion))
  add(path_564814, "subscriptionId", newJString(subscriptionId))
  add(path_564814, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564816 = parameters
  add(path_564814, "publicIpAddressName", newJString(publicIpAddressName))
  result = call_564813.call(path_564814, query_564815, nil, nil, body_564816)

var publicIPAddressesCreateOrUpdate* = Call_PublicIPAddressesCreateOrUpdate_564804(
    name: "publicIPAddressesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses/{publicIpAddressName}",
    validator: validate_PublicIPAddressesCreateOrUpdate_564805, base: "",
    url: url_PublicIPAddressesCreateOrUpdate_564806, schemes: {Scheme.Https})
type
  Call_PublicIPAddressesGet_564792 = ref object of OpenApiRestCall_563549
proc url_PublicIPAddressesGet_564794(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "publicIpAddressName" in path,
        "`publicIpAddressName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/publicIPAddresses/"),
               (kind: VariableSegment, value: "publicIpAddressName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PublicIPAddressesGet_564793(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get publicIpAddress operation retrieves information about the specified pubicIpAddress
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   publicIpAddressName: JString (required)
  ##                      : The name of the subnet.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564795 = path.getOrDefault("subscriptionId")
  valid_564795 = validateParameter(valid_564795, JString, required = true,
                                 default = nil)
  if valid_564795 != nil:
    section.add "subscriptionId", valid_564795
  var valid_564796 = path.getOrDefault("resourceGroupName")
  valid_564796 = validateParameter(valid_564796, JString, required = true,
                                 default = nil)
  if valid_564796 != nil:
    section.add "resourceGroupName", valid_564796
  var valid_564797 = path.getOrDefault("publicIpAddressName")
  valid_564797 = validateParameter(valid_564797, JString, required = true,
                                 default = nil)
  if valid_564797 != nil:
    section.add "publicIpAddressName", valid_564797
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564798 = query.getOrDefault("api-version")
  valid_564798 = validateParameter(valid_564798, JString, required = true,
                                 default = nil)
  if valid_564798 != nil:
    section.add "api-version", valid_564798
  var valid_564799 = query.getOrDefault("$expand")
  valid_564799 = validateParameter(valid_564799, JString, required = false,
                                 default = nil)
  if valid_564799 != nil:
    section.add "$expand", valid_564799
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564800: Call_PublicIPAddressesGet_564792; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get publicIpAddress operation retrieves information about the specified pubicIpAddress
  ## 
  let valid = call_564800.validator(path, query, header, formData, body)
  let scheme = call_564800.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564800.url(scheme.get, call_564800.host, call_564800.base,
                         call_564800.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564800, url, valid)

proc call*(call_564801: Call_PublicIPAddressesGet_564792; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          publicIpAddressName: string; Expand: string = ""): Recallable =
  ## publicIPAddressesGet
  ## The Get publicIpAddress operation retrieves information about the specified pubicIpAddress
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : expand references resources.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   publicIpAddressName: string (required)
  ##                      : The name of the subnet.
  var path_564802 = newJObject()
  var query_564803 = newJObject()
  add(query_564803, "api-version", newJString(apiVersion))
  add(query_564803, "$expand", newJString(Expand))
  add(path_564802, "subscriptionId", newJString(subscriptionId))
  add(path_564802, "resourceGroupName", newJString(resourceGroupName))
  add(path_564802, "publicIpAddressName", newJString(publicIpAddressName))
  result = call_564801.call(path_564802, query_564803, nil, nil, nil)

var publicIPAddressesGet* = Call_PublicIPAddressesGet_564792(
    name: "publicIPAddressesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses/{publicIpAddressName}",
    validator: validate_PublicIPAddressesGet_564793, base: "",
    url: url_PublicIPAddressesGet_564794, schemes: {Scheme.Https})
type
  Call_PublicIPAddressesDelete_564817 = ref object of OpenApiRestCall_563549
proc url_PublicIPAddressesDelete_564819(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "publicIpAddressName" in path,
        "`publicIpAddressName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/publicIPAddresses/"),
               (kind: VariableSegment, value: "publicIpAddressName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PublicIPAddressesDelete_564818(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The delete publicIpAddress operation deletes the specified publicIpAddress.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   publicIpAddressName: JString (required)
  ##                      : The name of the subnet.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564820 = path.getOrDefault("subscriptionId")
  valid_564820 = validateParameter(valid_564820, JString, required = true,
                                 default = nil)
  if valid_564820 != nil:
    section.add "subscriptionId", valid_564820
  var valid_564821 = path.getOrDefault("resourceGroupName")
  valid_564821 = validateParameter(valid_564821, JString, required = true,
                                 default = nil)
  if valid_564821 != nil:
    section.add "resourceGroupName", valid_564821
  var valid_564822 = path.getOrDefault("publicIpAddressName")
  valid_564822 = validateParameter(valid_564822, JString, required = true,
                                 default = nil)
  if valid_564822 != nil:
    section.add "publicIpAddressName", valid_564822
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564823 = query.getOrDefault("api-version")
  valid_564823 = validateParameter(valid_564823, JString, required = true,
                                 default = nil)
  if valid_564823 != nil:
    section.add "api-version", valid_564823
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564824: Call_PublicIPAddressesDelete_564817; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete publicIpAddress operation deletes the specified publicIpAddress.
  ## 
  let valid = call_564824.validator(path, query, header, formData, body)
  let scheme = call_564824.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564824.url(scheme.get, call_564824.host, call_564824.base,
                         call_564824.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564824, url, valid)

proc call*(call_564825: Call_PublicIPAddressesDelete_564817; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          publicIpAddressName: string): Recallable =
  ## publicIPAddressesDelete
  ## The delete publicIpAddress operation deletes the specified publicIpAddress.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   publicIpAddressName: string (required)
  ##                      : The name of the subnet.
  var path_564826 = newJObject()
  var query_564827 = newJObject()
  add(query_564827, "api-version", newJString(apiVersion))
  add(path_564826, "subscriptionId", newJString(subscriptionId))
  add(path_564826, "resourceGroupName", newJString(resourceGroupName))
  add(path_564826, "publicIpAddressName", newJString(publicIpAddressName))
  result = call_564825.call(path_564826, query_564827, nil, nil, nil)

var publicIPAddressesDelete* = Call_PublicIPAddressesDelete_564817(
    name: "publicIPAddressesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses/{publicIpAddressName}",
    validator: validate_PublicIPAddressesDelete_564818, base: "",
    url: url_PublicIPAddressesDelete_564819, schemes: {Scheme.Https})
type
  Call_RouteTablesList_564828 = ref object of OpenApiRestCall_563549
proc url_RouteTablesList_564830(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.Network/routeTables")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RouteTablesList_564829(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## The list RouteTables returns all route tables in a resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564831 = path.getOrDefault("subscriptionId")
  valid_564831 = validateParameter(valid_564831, JString, required = true,
                                 default = nil)
  if valid_564831 != nil:
    section.add "subscriptionId", valid_564831
  var valid_564832 = path.getOrDefault("resourceGroupName")
  valid_564832 = validateParameter(valid_564832, JString, required = true,
                                 default = nil)
  if valid_564832 != nil:
    section.add "resourceGroupName", valid_564832
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564833 = query.getOrDefault("api-version")
  valid_564833 = validateParameter(valid_564833, JString, required = true,
                                 default = nil)
  if valid_564833 != nil:
    section.add "api-version", valid_564833
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564834: Call_RouteTablesList_564828; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list RouteTables returns all route tables in a resource group
  ## 
  let valid = call_564834.validator(path, query, header, formData, body)
  let scheme = call_564834.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564834.url(scheme.get, call_564834.host, call_564834.base,
                         call_564834.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564834, url, valid)

proc call*(call_564835: Call_RouteTablesList_564828; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## routeTablesList
  ## The list RouteTables returns all route tables in a resource group
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564836 = newJObject()
  var query_564837 = newJObject()
  add(query_564837, "api-version", newJString(apiVersion))
  add(path_564836, "subscriptionId", newJString(subscriptionId))
  add(path_564836, "resourceGroupName", newJString(resourceGroupName))
  result = call_564835.call(path_564836, query_564837, nil, nil, nil)

var routeTablesList* = Call_RouteTablesList_564828(name: "routeTablesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables",
    validator: validate_RouteTablesList_564829, base: "", url: url_RouteTablesList_564830,
    schemes: {Scheme.Https})
type
  Call_RouteTablesCreateOrUpdate_564850 = ref object of OpenApiRestCall_563549
proc url_RouteTablesCreateOrUpdate_564852(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "routeTableName" in path, "`routeTableName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/routeTables/"),
               (kind: VariableSegment, value: "routeTableName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RouteTablesCreateOrUpdate_564851(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put RouteTable operation creates/updates a route table in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   routeTableName: JString (required)
  ##                 : The name of the route table.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `routeTableName` field"
  var valid_564853 = path.getOrDefault("routeTableName")
  valid_564853 = validateParameter(valid_564853, JString, required = true,
                                 default = nil)
  if valid_564853 != nil:
    section.add "routeTableName", valid_564853
  var valid_564854 = path.getOrDefault("subscriptionId")
  valid_564854 = validateParameter(valid_564854, JString, required = true,
                                 default = nil)
  if valid_564854 != nil:
    section.add "subscriptionId", valid_564854
  var valid_564855 = path.getOrDefault("resourceGroupName")
  valid_564855 = validateParameter(valid_564855, JString, required = true,
                                 default = nil)
  if valid_564855 != nil:
    section.add "resourceGroupName", valid_564855
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564856 = query.getOrDefault("api-version")
  valid_564856 = validateParameter(valid_564856, JString, required = true,
                                 default = nil)
  if valid_564856 != nil:
    section.add "api-version", valid_564856
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update Route Table operation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564858: Call_RouteTablesCreateOrUpdate_564850; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put RouteTable operation creates/updates a route table in the specified resource group.
  ## 
  let valid = call_564858.validator(path, query, header, formData, body)
  let scheme = call_564858.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564858.url(scheme.get, call_564858.host, call_564858.base,
                         call_564858.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564858, url, valid)

proc call*(call_564859: Call_RouteTablesCreateOrUpdate_564850; apiVersion: string;
          routeTableName: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## routeTablesCreateOrUpdate
  ## The Put RouteTable operation creates/updates a route table in the specified resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   routeTableName: string (required)
  ##                 : The name of the route table.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update Route Table operation
  var path_564860 = newJObject()
  var query_564861 = newJObject()
  var body_564862 = newJObject()
  add(query_564861, "api-version", newJString(apiVersion))
  add(path_564860, "routeTableName", newJString(routeTableName))
  add(path_564860, "subscriptionId", newJString(subscriptionId))
  add(path_564860, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564862 = parameters
  result = call_564859.call(path_564860, query_564861, nil, nil, body_564862)

var routeTablesCreateOrUpdate* = Call_RouteTablesCreateOrUpdate_564850(
    name: "routeTablesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}",
    validator: validate_RouteTablesCreateOrUpdate_564851, base: "",
    url: url_RouteTablesCreateOrUpdate_564852, schemes: {Scheme.Https})
type
  Call_RouteTablesGet_564838 = ref object of OpenApiRestCall_563549
proc url_RouteTablesGet_564840(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "routeTableName" in path, "`routeTableName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/routeTables/"),
               (kind: VariableSegment, value: "routeTableName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RouteTablesGet_564839(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## The Get RouteTables operation retrieves information about the specified route table.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   routeTableName: JString (required)
  ##                 : The name of the route table.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `routeTableName` field"
  var valid_564841 = path.getOrDefault("routeTableName")
  valid_564841 = validateParameter(valid_564841, JString, required = true,
                                 default = nil)
  if valid_564841 != nil:
    section.add "routeTableName", valid_564841
  var valid_564842 = path.getOrDefault("subscriptionId")
  valid_564842 = validateParameter(valid_564842, JString, required = true,
                                 default = nil)
  if valid_564842 != nil:
    section.add "subscriptionId", valid_564842
  var valid_564843 = path.getOrDefault("resourceGroupName")
  valid_564843 = validateParameter(valid_564843, JString, required = true,
                                 default = nil)
  if valid_564843 != nil:
    section.add "resourceGroupName", valid_564843
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564844 = query.getOrDefault("api-version")
  valid_564844 = validateParameter(valid_564844, JString, required = true,
                                 default = nil)
  if valid_564844 != nil:
    section.add "api-version", valid_564844
  var valid_564845 = query.getOrDefault("$expand")
  valid_564845 = validateParameter(valid_564845, JString, required = false,
                                 default = nil)
  if valid_564845 != nil:
    section.add "$expand", valid_564845
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564846: Call_RouteTablesGet_564838; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get RouteTables operation retrieves information about the specified route table.
  ## 
  let valid = call_564846.validator(path, query, header, formData, body)
  let scheme = call_564846.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564846.url(scheme.get, call_564846.host, call_564846.base,
                         call_564846.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564846, url, valid)

proc call*(call_564847: Call_RouteTablesGet_564838; apiVersion: string;
          routeTableName: string; subscriptionId: string; resourceGroupName: string;
          Expand: string = ""): Recallable =
  ## routeTablesGet
  ## The Get RouteTables operation retrieves information about the specified route table.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   routeTableName: string (required)
  ##                 : The name of the route table.
  ##   Expand: string
  ##         : expand references resources.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564848 = newJObject()
  var query_564849 = newJObject()
  add(query_564849, "api-version", newJString(apiVersion))
  add(path_564848, "routeTableName", newJString(routeTableName))
  add(query_564849, "$expand", newJString(Expand))
  add(path_564848, "subscriptionId", newJString(subscriptionId))
  add(path_564848, "resourceGroupName", newJString(resourceGroupName))
  result = call_564847.call(path_564848, query_564849, nil, nil, nil)

var routeTablesGet* = Call_RouteTablesGet_564838(name: "routeTablesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}",
    validator: validate_RouteTablesGet_564839, base: "", url: url_RouteTablesGet_564840,
    schemes: {Scheme.Https})
type
  Call_RouteTablesDelete_564863 = ref object of OpenApiRestCall_563549
proc url_RouteTablesDelete_564865(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "routeTableName" in path, "`routeTableName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/routeTables/"),
               (kind: VariableSegment, value: "routeTableName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RouteTablesDelete_564864(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## The Delete RouteTable operation deletes the specified Route Table
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   routeTableName: JString (required)
  ##                 : The name of the route table.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `routeTableName` field"
  var valid_564866 = path.getOrDefault("routeTableName")
  valid_564866 = validateParameter(valid_564866, JString, required = true,
                                 default = nil)
  if valid_564866 != nil:
    section.add "routeTableName", valid_564866
  var valid_564867 = path.getOrDefault("subscriptionId")
  valid_564867 = validateParameter(valid_564867, JString, required = true,
                                 default = nil)
  if valid_564867 != nil:
    section.add "subscriptionId", valid_564867
  var valid_564868 = path.getOrDefault("resourceGroupName")
  valid_564868 = validateParameter(valid_564868, JString, required = true,
                                 default = nil)
  if valid_564868 != nil:
    section.add "resourceGroupName", valid_564868
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564869 = query.getOrDefault("api-version")
  valid_564869 = validateParameter(valid_564869, JString, required = true,
                                 default = nil)
  if valid_564869 != nil:
    section.add "api-version", valid_564869
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564870: Call_RouteTablesDelete_564863; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete RouteTable operation deletes the specified Route Table
  ## 
  let valid = call_564870.validator(path, query, header, formData, body)
  let scheme = call_564870.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564870.url(scheme.get, call_564870.host, call_564870.base,
                         call_564870.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564870, url, valid)

proc call*(call_564871: Call_RouteTablesDelete_564863; apiVersion: string;
          routeTableName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## routeTablesDelete
  ## The Delete RouteTable operation deletes the specified Route Table
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   routeTableName: string (required)
  ##                 : The name of the route table.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564872 = newJObject()
  var query_564873 = newJObject()
  add(query_564873, "api-version", newJString(apiVersion))
  add(path_564872, "routeTableName", newJString(routeTableName))
  add(path_564872, "subscriptionId", newJString(subscriptionId))
  add(path_564872, "resourceGroupName", newJString(resourceGroupName))
  result = call_564871.call(path_564872, query_564873, nil, nil, nil)

var routeTablesDelete* = Call_RouteTablesDelete_564863(name: "routeTablesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}",
    validator: validate_RouteTablesDelete_564864, base: "",
    url: url_RouteTablesDelete_564865, schemes: {Scheme.Https})
type
  Call_RoutesList_564874 = ref object of OpenApiRestCall_563549
proc url_RoutesList_564876(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "routeTableName" in path, "`routeTableName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/routeTables/"),
               (kind: VariableSegment, value: "routeTableName"),
               (kind: ConstantSegment, value: "/routes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoutesList_564875(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## The List network security rule operation retrieves all the routes in a route table.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   routeTableName: JString (required)
  ##                 : The name of the route table.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `routeTableName` field"
  var valid_564877 = path.getOrDefault("routeTableName")
  valid_564877 = validateParameter(valid_564877, JString, required = true,
                                 default = nil)
  if valid_564877 != nil:
    section.add "routeTableName", valid_564877
  var valid_564878 = path.getOrDefault("subscriptionId")
  valid_564878 = validateParameter(valid_564878, JString, required = true,
                                 default = nil)
  if valid_564878 != nil:
    section.add "subscriptionId", valid_564878
  var valid_564879 = path.getOrDefault("resourceGroupName")
  valid_564879 = validateParameter(valid_564879, JString, required = true,
                                 default = nil)
  if valid_564879 != nil:
    section.add "resourceGroupName", valid_564879
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564880 = query.getOrDefault("api-version")
  valid_564880 = validateParameter(valid_564880, JString, required = true,
                                 default = nil)
  if valid_564880 != nil:
    section.add "api-version", valid_564880
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564881: Call_RoutesList_564874; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List network security rule operation retrieves all the routes in a route table.
  ## 
  let valid = call_564881.validator(path, query, header, formData, body)
  let scheme = call_564881.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564881.url(scheme.get, call_564881.host, call_564881.base,
                         call_564881.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564881, url, valid)

proc call*(call_564882: Call_RoutesList_564874; apiVersion: string;
          routeTableName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## routesList
  ## The List network security rule operation retrieves all the routes in a route table.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   routeTableName: string (required)
  ##                 : The name of the route table.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564883 = newJObject()
  var query_564884 = newJObject()
  add(query_564884, "api-version", newJString(apiVersion))
  add(path_564883, "routeTableName", newJString(routeTableName))
  add(path_564883, "subscriptionId", newJString(subscriptionId))
  add(path_564883, "resourceGroupName", newJString(resourceGroupName))
  result = call_564882.call(path_564883, query_564884, nil, nil, nil)

var routesList* = Call_RoutesList_564874(name: "routesList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}/routes",
                                      validator: validate_RoutesList_564875,
                                      base: "", url: url_RoutesList_564876,
                                      schemes: {Scheme.Https})
type
  Call_RoutesCreateOrUpdate_564897 = ref object of OpenApiRestCall_563549
proc url_RoutesCreateOrUpdate_564899(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "routeTableName" in path, "`routeTableName` is a required path parameter"
  assert "routeName" in path, "`routeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/routeTables/"),
               (kind: VariableSegment, value: "routeTableName"),
               (kind: ConstantSegment, value: "/routes/"),
               (kind: VariableSegment, value: "routeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoutesCreateOrUpdate_564898(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put route operation creates/updates a route in the specified route table
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   routeName: JString (required)
  ##            : The name of the route.
  ##   routeTableName: JString (required)
  ##                 : The name of the route table.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `routeName` field"
  var valid_564900 = path.getOrDefault("routeName")
  valid_564900 = validateParameter(valid_564900, JString, required = true,
                                 default = nil)
  if valid_564900 != nil:
    section.add "routeName", valid_564900
  var valid_564901 = path.getOrDefault("routeTableName")
  valid_564901 = validateParameter(valid_564901, JString, required = true,
                                 default = nil)
  if valid_564901 != nil:
    section.add "routeTableName", valid_564901
  var valid_564902 = path.getOrDefault("subscriptionId")
  valid_564902 = validateParameter(valid_564902, JString, required = true,
                                 default = nil)
  if valid_564902 != nil:
    section.add "subscriptionId", valid_564902
  var valid_564903 = path.getOrDefault("resourceGroupName")
  valid_564903 = validateParameter(valid_564903, JString, required = true,
                                 default = nil)
  if valid_564903 != nil:
    section.add "resourceGroupName", valid_564903
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564904 = query.getOrDefault("api-version")
  valid_564904 = validateParameter(valid_564904, JString, required = true,
                                 default = nil)
  if valid_564904 != nil:
    section.add "api-version", valid_564904
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   routeParameters: JObject (required)
  ##                  : Parameters supplied to the create/update route operation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564906: Call_RoutesCreateOrUpdate_564897; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put route operation creates/updates a route in the specified route table
  ## 
  let valid = call_564906.validator(path, query, header, formData, body)
  let scheme = call_564906.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564906.url(scheme.get, call_564906.host, call_564906.base,
                         call_564906.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564906, url, valid)

proc call*(call_564907: Call_RoutesCreateOrUpdate_564897; routeName: string;
          apiVersion: string; routeTableName: string; subscriptionId: string;
          routeParameters: JsonNode; resourceGroupName: string): Recallable =
  ## routesCreateOrUpdate
  ## The Put route operation creates/updates a route in the specified route table
  ##   routeName: string (required)
  ##            : The name of the route.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   routeTableName: string (required)
  ##                 : The name of the route table.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   routeParameters: JObject (required)
  ##                  : Parameters supplied to the create/update route operation
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564908 = newJObject()
  var query_564909 = newJObject()
  var body_564910 = newJObject()
  add(path_564908, "routeName", newJString(routeName))
  add(query_564909, "api-version", newJString(apiVersion))
  add(path_564908, "routeTableName", newJString(routeTableName))
  add(path_564908, "subscriptionId", newJString(subscriptionId))
  if routeParameters != nil:
    body_564910 = routeParameters
  add(path_564908, "resourceGroupName", newJString(resourceGroupName))
  result = call_564907.call(path_564908, query_564909, nil, nil, body_564910)

var routesCreateOrUpdate* = Call_RoutesCreateOrUpdate_564897(
    name: "routesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}/routes/{routeName}",
    validator: validate_RoutesCreateOrUpdate_564898, base: "",
    url: url_RoutesCreateOrUpdate_564899, schemes: {Scheme.Https})
type
  Call_RoutesGet_564885 = ref object of OpenApiRestCall_563549
proc url_RoutesGet_564887(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "routeTableName" in path, "`routeTableName` is a required path parameter"
  assert "routeName" in path, "`routeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/routeTables/"),
               (kind: VariableSegment, value: "routeTableName"),
               (kind: ConstantSegment, value: "/routes/"),
               (kind: VariableSegment, value: "routeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoutesGet_564886(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get route operation retrieves information about the specified route from the route table.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   routeName: JString (required)
  ##            : The name of the route.
  ##   routeTableName: JString (required)
  ##                 : The name of the route table.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `routeName` field"
  var valid_564888 = path.getOrDefault("routeName")
  valid_564888 = validateParameter(valid_564888, JString, required = true,
                                 default = nil)
  if valid_564888 != nil:
    section.add "routeName", valid_564888
  var valid_564889 = path.getOrDefault("routeTableName")
  valid_564889 = validateParameter(valid_564889, JString, required = true,
                                 default = nil)
  if valid_564889 != nil:
    section.add "routeTableName", valid_564889
  var valid_564890 = path.getOrDefault("subscriptionId")
  valid_564890 = validateParameter(valid_564890, JString, required = true,
                                 default = nil)
  if valid_564890 != nil:
    section.add "subscriptionId", valid_564890
  var valid_564891 = path.getOrDefault("resourceGroupName")
  valid_564891 = validateParameter(valid_564891, JString, required = true,
                                 default = nil)
  if valid_564891 != nil:
    section.add "resourceGroupName", valid_564891
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564892 = query.getOrDefault("api-version")
  valid_564892 = validateParameter(valid_564892, JString, required = true,
                                 default = nil)
  if valid_564892 != nil:
    section.add "api-version", valid_564892
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564893: Call_RoutesGet_564885; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get route operation retrieves information about the specified route from the route table.
  ## 
  let valid = call_564893.validator(path, query, header, formData, body)
  let scheme = call_564893.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564893.url(scheme.get, call_564893.host, call_564893.base,
                         call_564893.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564893, url, valid)

proc call*(call_564894: Call_RoutesGet_564885; routeName: string; apiVersion: string;
          routeTableName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## routesGet
  ## The Get route operation retrieves information about the specified route from the route table.
  ##   routeName: string (required)
  ##            : The name of the route.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   routeTableName: string (required)
  ##                 : The name of the route table.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564895 = newJObject()
  var query_564896 = newJObject()
  add(path_564895, "routeName", newJString(routeName))
  add(query_564896, "api-version", newJString(apiVersion))
  add(path_564895, "routeTableName", newJString(routeTableName))
  add(path_564895, "subscriptionId", newJString(subscriptionId))
  add(path_564895, "resourceGroupName", newJString(resourceGroupName))
  result = call_564894.call(path_564895, query_564896, nil, nil, nil)

var routesGet* = Call_RoutesGet_564885(name: "routesGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}/routes/{routeName}",
                                    validator: validate_RoutesGet_564886,
                                    base: "", url: url_RoutesGet_564887,
                                    schemes: {Scheme.Https})
type
  Call_RoutesDelete_564911 = ref object of OpenApiRestCall_563549
proc url_RoutesDelete_564913(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "routeTableName" in path, "`routeTableName` is a required path parameter"
  assert "routeName" in path, "`routeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Network/routeTables/"),
               (kind: VariableSegment, value: "routeTableName"),
               (kind: ConstantSegment, value: "/routes/"),
               (kind: VariableSegment, value: "routeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoutesDelete_564912(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## The delete route operation deletes the specified route from a route table.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   routeName: JString (required)
  ##            : The name of the route.
  ##   routeTableName: JString (required)
  ##                 : The name of the route table.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `routeName` field"
  var valid_564914 = path.getOrDefault("routeName")
  valid_564914 = validateParameter(valid_564914, JString, required = true,
                                 default = nil)
  if valid_564914 != nil:
    section.add "routeName", valid_564914
  var valid_564915 = path.getOrDefault("routeTableName")
  valid_564915 = validateParameter(valid_564915, JString, required = true,
                                 default = nil)
  if valid_564915 != nil:
    section.add "routeTableName", valid_564915
  var valid_564916 = path.getOrDefault("subscriptionId")
  valid_564916 = validateParameter(valid_564916, JString, required = true,
                                 default = nil)
  if valid_564916 != nil:
    section.add "subscriptionId", valid_564916
  var valid_564917 = path.getOrDefault("resourceGroupName")
  valid_564917 = validateParameter(valid_564917, JString, required = true,
                                 default = nil)
  if valid_564917 != nil:
    section.add "resourceGroupName", valid_564917
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564918 = query.getOrDefault("api-version")
  valid_564918 = validateParameter(valid_564918, JString, required = true,
                                 default = nil)
  if valid_564918 != nil:
    section.add "api-version", valid_564918
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564919: Call_RoutesDelete_564911; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete route operation deletes the specified route from a route table.
  ## 
  let valid = call_564919.validator(path, query, header, formData, body)
  let scheme = call_564919.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564919.url(scheme.get, call_564919.host, call_564919.base,
                         call_564919.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564919, url, valid)

proc call*(call_564920: Call_RoutesDelete_564911; routeName: string;
          apiVersion: string; routeTableName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## routesDelete
  ## The delete route operation deletes the specified route from a route table.
  ##   routeName: string (required)
  ##            : The name of the route.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   routeTableName: string (required)
  ##                 : The name of the route table.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564921 = newJObject()
  var query_564922 = newJObject()
  add(path_564921, "routeName", newJString(routeName))
  add(query_564922, "api-version", newJString(apiVersion))
  add(path_564921, "routeTableName", newJString(routeTableName))
  add(path_564921, "subscriptionId", newJString(subscriptionId))
  add(path_564921, "resourceGroupName", newJString(resourceGroupName))
  result = call_564920.call(path_564921, query_564922, nil, nil, nil)

var routesDelete* = Call_RoutesDelete_564911(name: "routesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}/routes/{routeName}",
    validator: validate_RoutesDelete_564912, base: "", url: url_RoutesDelete_564913,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysList_564923 = ref object of OpenApiRestCall_563549
proc url_VirtualNetworkGatewaysList_564925(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Network/virtualNetworkGateways")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysList_564924(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List VirtualNetworkGateways operation retrieves all the virtual network gateways stored.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564926 = path.getOrDefault("subscriptionId")
  valid_564926 = validateParameter(valid_564926, JString, required = true,
                                 default = nil)
  if valid_564926 != nil:
    section.add "subscriptionId", valid_564926
  var valid_564927 = path.getOrDefault("resourceGroupName")
  valid_564927 = validateParameter(valid_564927, JString, required = true,
                                 default = nil)
  if valid_564927 != nil:
    section.add "resourceGroupName", valid_564927
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564928 = query.getOrDefault("api-version")
  valid_564928 = validateParameter(valid_564928, JString, required = true,
                                 default = nil)
  if valid_564928 != nil:
    section.add "api-version", valid_564928
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564929: Call_VirtualNetworkGatewaysList_564923; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List VirtualNetworkGateways operation retrieves all the virtual network gateways stored.
  ## 
  let valid = call_564929.validator(path, query, header, formData, body)
  let scheme = call_564929.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564929.url(scheme.get, call_564929.host, call_564929.base,
                         call_564929.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564929, url, valid)

proc call*(call_564930: Call_VirtualNetworkGatewaysList_564923; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## virtualNetworkGatewaysList
  ## The List VirtualNetworkGateways operation retrieves all the virtual network gateways stored.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564931 = newJObject()
  var query_564932 = newJObject()
  add(query_564932, "api-version", newJString(apiVersion))
  add(path_564931, "subscriptionId", newJString(subscriptionId))
  add(path_564931, "resourceGroupName", newJString(resourceGroupName))
  result = call_564930.call(path_564931, query_564932, nil, nil, nil)

var virtualNetworkGatewaysList* = Call_VirtualNetworkGatewaysList_564923(
    name: "virtualNetworkGatewaysList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways",
    validator: validate_VirtualNetworkGatewaysList_564924, base: "",
    url: url_VirtualNetworkGatewaysList_564925, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysCreateOrUpdate_564944 = ref object of OpenApiRestCall_563549
proc url_VirtualNetworkGatewaysCreateOrUpdate_564946(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayName" in path,
        "`virtualNetworkGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworkGateways/"),
               (kind: VariableSegment, value: "virtualNetworkGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysCreateOrUpdate_564945(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put VirtualNetworkGateway operation creates/updates a virtual network gateway in the specified resource group through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkGatewayName: JString (required)
  ##                            : The name of the virtual network gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564947 = path.getOrDefault("subscriptionId")
  valid_564947 = validateParameter(valid_564947, JString, required = true,
                                 default = nil)
  if valid_564947 != nil:
    section.add "subscriptionId", valid_564947
  var valid_564948 = path.getOrDefault("resourceGroupName")
  valid_564948 = validateParameter(valid_564948, JString, required = true,
                                 default = nil)
  if valid_564948 != nil:
    section.add "resourceGroupName", valid_564948
  var valid_564949 = path.getOrDefault("virtualNetworkGatewayName")
  valid_564949 = validateParameter(valid_564949, JString, required = true,
                                 default = nil)
  if valid_564949 != nil:
    section.add "virtualNetworkGatewayName", valid_564949
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564950 = query.getOrDefault("api-version")
  valid_564950 = validateParameter(valid_564950, JString, required = true,
                                 default = nil)
  if valid_564950 != nil:
    section.add "api-version", valid_564950
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Begin Create or update Virtual Network Gateway operation through Network resource provider.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564952: Call_VirtualNetworkGatewaysCreateOrUpdate_564944;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put VirtualNetworkGateway operation creates/updates a virtual network gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_564952.validator(path, query, header, formData, body)
  let scheme = call_564952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564952.url(scheme.get, call_564952.host, call_564952.base,
                         call_564952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564952, url, valid)

proc call*(call_564953: Call_VirtualNetworkGatewaysCreateOrUpdate_564944;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode; virtualNetworkGatewayName: string): Recallable =
  ## virtualNetworkGatewaysCreateOrUpdate
  ## The Put VirtualNetworkGateway operation creates/updates a virtual network gateway in the specified resource group through Network resource provider.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Begin Create or update Virtual Network Gateway operation through Network resource provider.
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The name of the virtual network gateway.
  var path_564954 = newJObject()
  var query_564955 = newJObject()
  var body_564956 = newJObject()
  add(query_564955, "api-version", newJString(apiVersion))
  add(path_564954, "subscriptionId", newJString(subscriptionId))
  add(path_564954, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564956 = parameters
  add(path_564954, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_564953.call(path_564954, query_564955, nil, nil, body_564956)

var virtualNetworkGatewaysCreateOrUpdate* = Call_VirtualNetworkGatewaysCreateOrUpdate_564944(
    name: "virtualNetworkGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}",
    validator: validate_VirtualNetworkGatewaysCreateOrUpdate_564945, base: "",
    url: url_VirtualNetworkGatewaysCreateOrUpdate_564946, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGet_564933 = ref object of OpenApiRestCall_563549
proc url_VirtualNetworkGatewaysGet_564935(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayName" in path,
        "`virtualNetworkGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworkGateways/"),
               (kind: VariableSegment, value: "virtualNetworkGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysGet_564934(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get VirtualNetworkGateway operation retrieves information about the specified virtual network gateway through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkGatewayName: JString (required)
  ##                            : The name of the virtual network gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564936 = path.getOrDefault("subscriptionId")
  valid_564936 = validateParameter(valid_564936, JString, required = true,
                                 default = nil)
  if valid_564936 != nil:
    section.add "subscriptionId", valid_564936
  var valid_564937 = path.getOrDefault("resourceGroupName")
  valid_564937 = validateParameter(valid_564937, JString, required = true,
                                 default = nil)
  if valid_564937 != nil:
    section.add "resourceGroupName", valid_564937
  var valid_564938 = path.getOrDefault("virtualNetworkGatewayName")
  valid_564938 = validateParameter(valid_564938, JString, required = true,
                                 default = nil)
  if valid_564938 != nil:
    section.add "virtualNetworkGatewayName", valid_564938
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564939 = query.getOrDefault("api-version")
  valid_564939 = validateParameter(valid_564939, JString, required = true,
                                 default = nil)
  if valid_564939 != nil:
    section.add "api-version", valid_564939
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564940: Call_VirtualNetworkGatewaysGet_564933; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get VirtualNetworkGateway operation retrieves information about the specified virtual network gateway through Network resource provider.
  ## 
  let valid = call_564940.validator(path, query, header, formData, body)
  let scheme = call_564940.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564940.url(scheme.get, call_564940.host, call_564940.base,
                         call_564940.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564940, url, valid)

proc call*(call_564941: Call_VirtualNetworkGatewaysGet_564933; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          virtualNetworkGatewayName: string): Recallable =
  ## virtualNetworkGatewaysGet
  ## The Get VirtualNetworkGateway operation retrieves information about the specified virtual network gateway through Network resource provider.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The name of the virtual network gateway.
  var path_564942 = newJObject()
  var query_564943 = newJObject()
  add(query_564943, "api-version", newJString(apiVersion))
  add(path_564942, "subscriptionId", newJString(subscriptionId))
  add(path_564942, "resourceGroupName", newJString(resourceGroupName))
  add(path_564942, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_564941.call(path_564942, query_564943, nil, nil, nil)

var virtualNetworkGatewaysGet* = Call_VirtualNetworkGatewaysGet_564933(
    name: "virtualNetworkGatewaysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}",
    validator: validate_VirtualNetworkGatewaysGet_564934, base: "",
    url: url_VirtualNetworkGatewaysGet_564935, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysDelete_564957 = ref object of OpenApiRestCall_563549
proc url_VirtualNetworkGatewaysDelete_564959(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayName" in path,
        "`virtualNetworkGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworkGateways/"),
               (kind: VariableSegment, value: "virtualNetworkGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysDelete_564958(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Delete VirtualNetworkGateway operation deletes the specified virtual network Gateway through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkGatewayName: JString (required)
  ##                            : The name of the virtual network gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564960 = path.getOrDefault("subscriptionId")
  valid_564960 = validateParameter(valid_564960, JString, required = true,
                                 default = nil)
  if valid_564960 != nil:
    section.add "subscriptionId", valid_564960
  var valid_564961 = path.getOrDefault("resourceGroupName")
  valid_564961 = validateParameter(valid_564961, JString, required = true,
                                 default = nil)
  if valid_564961 != nil:
    section.add "resourceGroupName", valid_564961
  var valid_564962 = path.getOrDefault("virtualNetworkGatewayName")
  valid_564962 = validateParameter(valid_564962, JString, required = true,
                                 default = nil)
  if valid_564962 != nil:
    section.add "virtualNetworkGatewayName", valid_564962
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564963 = query.getOrDefault("api-version")
  valid_564963 = validateParameter(valid_564963, JString, required = true,
                                 default = nil)
  if valid_564963 != nil:
    section.add "api-version", valid_564963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564964: Call_VirtualNetworkGatewaysDelete_564957; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete VirtualNetworkGateway operation deletes the specified virtual network Gateway through Network resource provider.
  ## 
  let valid = call_564964.validator(path, query, header, formData, body)
  let scheme = call_564964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564964.url(scheme.get, call_564964.host, call_564964.base,
                         call_564964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564964, url, valid)

proc call*(call_564965: Call_VirtualNetworkGatewaysDelete_564957;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          virtualNetworkGatewayName: string): Recallable =
  ## virtualNetworkGatewaysDelete
  ## The Delete VirtualNetworkGateway operation deletes the specified virtual network Gateway through Network resource provider.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The name of the virtual network gateway.
  var path_564966 = newJObject()
  var query_564967 = newJObject()
  add(query_564967, "api-version", newJString(apiVersion))
  add(path_564966, "subscriptionId", newJString(subscriptionId))
  add(path_564966, "resourceGroupName", newJString(resourceGroupName))
  add(path_564966, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_564965.call(path_564966, query_564967, nil, nil, nil)

var virtualNetworkGatewaysDelete* = Call_VirtualNetworkGatewaysDelete_564957(
    name: "virtualNetworkGatewaysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}",
    validator: validate_VirtualNetworkGatewaysDelete_564958, base: "",
    url: url_VirtualNetworkGatewaysDelete_564959, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGeneratevpnclientpackage_564968 = ref object of OpenApiRestCall_563549
proc url_VirtualNetworkGatewaysGeneratevpnclientpackage_564970(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayName" in path,
        "`virtualNetworkGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworkGateways/"),
               (kind: VariableSegment, value: "virtualNetworkGatewayName"),
               (kind: ConstantSegment, value: "/generatevpnclientpackage")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysGeneratevpnclientpackage_564969(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The Generatevpnclientpackage operation generates Vpn client package for P2S client of the virtual network gateway in the specified resource group through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkGatewayName: JString (required)
  ##                            : The name of the virtual network gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564971 = path.getOrDefault("subscriptionId")
  valid_564971 = validateParameter(valid_564971, JString, required = true,
                                 default = nil)
  if valid_564971 != nil:
    section.add "subscriptionId", valid_564971
  var valid_564972 = path.getOrDefault("resourceGroupName")
  valid_564972 = validateParameter(valid_564972, JString, required = true,
                                 default = nil)
  if valid_564972 != nil:
    section.add "resourceGroupName", valid_564972
  var valid_564973 = path.getOrDefault("virtualNetworkGatewayName")
  valid_564973 = validateParameter(valid_564973, JString, required = true,
                                 default = nil)
  if valid_564973 != nil:
    section.add "virtualNetworkGatewayName", valid_564973
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564974 = query.getOrDefault("api-version")
  valid_564974 = validateParameter(valid_564974, JString, required = true,
                                 default = nil)
  if valid_564974 != nil:
    section.add "api-version", valid_564974
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Begin Generating  Virtual Network Gateway Vpn client package operation through Network resource provider.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564976: Call_VirtualNetworkGatewaysGeneratevpnclientpackage_564968;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Generatevpnclientpackage operation generates Vpn client package for P2S client of the virtual network gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_564976.validator(path, query, header, formData, body)
  let scheme = call_564976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564976.url(scheme.get, call_564976.host, call_564976.base,
                         call_564976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564976, url, valid)

proc call*(call_564977: Call_VirtualNetworkGatewaysGeneratevpnclientpackage_564968;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode; virtualNetworkGatewayName: string): Recallable =
  ## virtualNetworkGatewaysGeneratevpnclientpackage
  ## The Generatevpnclientpackage operation generates Vpn client package for P2S client of the virtual network gateway in the specified resource group through Network resource provider.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Begin Generating  Virtual Network Gateway Vpn client package operation through Network resource provider.
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The name of the virtual network gateway.
  var path_564978 = newJObject()
  var query_564979 = newJObject()
  var body_564980 = newJObject()
  add(query_564979, "api-version", newJString(apiVersion))
  add(path_564978, "subscriptionId", newJString(subscriptionId))
  add(path_564978, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564980 = parameters
  add(path_564978, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_564977.call(path_564978, query_564979, nil, nil, body_564980)

var virtualNetworkGatewaysGeneratevpnclientpackage* = Call_VirtualNetworkGatewaysGeneratevpnclientpackage_564968(
    name: "virtualNetworkGatewaysGeneratevpnclientpackage",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/generatevpnclientpackage",
    validator: validate_VirtualNetworkGatewaysGeneratevpnclientpackage_564969,
    base: "", url: url_VirtualNetworkGatewaysGeneratevpnclientpackage_564970,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysReset_564981 = ref object of OpenApiRestCall_563549
proc url_VirtualNetworkGatewaysReset_564983(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkGatewayName" in path,
        "`virtualNetworkGatewayName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworkGateways/"),
               (kind: VariableSegment, value: "virtualNetworkGatewayName"),
               (kind: ConstantSegment, value: "/reset")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysReset_564982(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Reset VirtualNetworkGateway operation resets the primary of the virtual network gateway in the specified resource group through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkGatewayName: JString (required)
  ##                            : The name of the virtual network gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564984 = path.getOrDefault("subscriptionId")
  valid_564984 = validateParameter(valid_564984, JString, required = true,
                                 default = nil)
  if valid_564984 != nil:
    section.add "subscriptionId", valid_564984
  var valid_564985 = path.getOrDefault("resourceGroupName")
  valid_564985 = validateParameter(valid_564985, JString, required = true,
                                 default = nil)
  if valid_564985 != nil:
    section.add "resourceGroupName", valid_564985
  var valid_564986 = path.getOrDefault("virtualNetworkGatewayName")
  valid_564986 = validateParameter(valid_564986, JString, required = true,
                                 default = nil)
  if valid_564986 != nil:
    section.add "virtualNetworkGatewayName", valid_564986
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564987 = query.getOrDefault("api-version")
  valid_564987 = validateParameter(valid_564987, JString, required = true,
                                 default = nil)
  if valid_564987 != nil:
    section.add "api-version", valid_564987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Begin Reset Virtual Network Gateway operation through Network resource provider.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564989: Call_VirtualNetworkGatewaysReset_564981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Reset VirtualNetworkGateway operation resets the primary of the virtual network gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_564989.validator(path, query, header, formData, body)
  let scheme = call_564989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564989.url(scheme.get, call_564989.host, call_564989.base,
                         call_564989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564989, url, valid)

proc call*(call_564990: Call_VirtualNetworkGatewaysReset_564981;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode; virtualNetworkGatewayName: string): Recallable =
  ## virtualNetworkGatewaysReset
  ## The Reset VirtualNetworkGateway operation resets the primary of the virtual network gateway in the specified resource group through Network resource provider.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Begin Reset Virtual Network Gateway operation through Network resource provider.
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The name of the virtual network gateway.
  var path_564991 = newJObject()
  var query_564992 = newJObject()
  var body_564993 = newJObject()
  add(query_564992, "api-version", newJString(apiVersion))
  add(path_564991, "subscriptionId", newJString(subscriptionId))
  add(path_564991, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564993 = parameters
  add(path_564991, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_564990.call(path_564991, query_564992, nil, nil, body_564993)

var virtualNetworkGatewaysReset* = Call_VirtualNetworkGatewaysReset_564981(
    name: "virtualNetworkGatewaysReset", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/reset",
    validator: validate_VirtualNetworkGatewaysReset_564982, base: "",
    url: url_VirtualNetworkGatewaysReset_564983, schemes: {Scheme.Https})
type
  Call_VirtualNetworksList_564994 = ref object of OpenApiRestCall_563549
proc url_VirtualNetworksList_564996(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Network/virtualNetworks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksList_564995(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## The list VirtualNetwork returns all Virtual Networks in a resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564997 = path.getOrDefault("subscriptionId")
  valid_564997 = validateParameter(valid_564997, JString, required = true,
                                 default = nil)
  if valid_564997 != nil:
    section.add "subscriptionId", valid_564997
  var valid_564998 = path.getOrDefault("resourceGroupName")
  valid_564998 = validateParameter(valid_564998, JString, required = true,
                                 default = nil)
  if valid_564998 != nil:
    section.add "resourceGroupName", valid_564998
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564999 = query.getOrDefault("api-version")
  valid_564999 = validateParameter(valid_564999, JString, required = true,
                                 default = nil)
  if valid_564999 != nil:
    section.add "api-version", valid_564999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565000: Call_VirtualNetworksList_564994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list VirtualNetwork returns all Virtual Networks in a resource group
  ## 
  let valid = call_565000.validator(path, query, header, formData, body)
  let scheme = call_565000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565000.url(scheme.get, call_565000.host, call_565000.base,
                         call_565000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565000, url, valid)

proc call*(call_565001: Call_VirtualNetworksList_564994; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## virtualNetworksList
  ## The list VirtualNetwork returns all Virtual Networks in a resource group
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565002 = newJObject()
  var query_565003 = newJObject()
  add(query_565003, "api-version", newJString(apiVersion))
  add(path_565002, "subscriptionId", newJString(subscriptionId))
  add(path_565002, "resourceGroupName", newJString(resourceGroupName))
  result = call_565001.call(path_565002, query_565003, nil, nil, nil)

var virtualNetworksList* = Call_VirtualNetworksList_564994(
    name: "virtualNetworksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks",
    validator: validate_VirtualNetworksList_564995, base: "",
    url: url_VirtualNetworksList_564996, schemes: {Scheme.Https})
type
  Call_VirtualNetworksCreateOrUpdate_565016 = ref object of OpenApiRestCall_563549
proc url_VirtualNetworksCreateOrUpdate_565018(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkName" in path,
        "`virtualNetworkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksCreateOrUpdate_565017(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put VirtualNetwork operation creates/updates a virtual network in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565019 = path.getOrDefault("subscriptionId")
  valid_565019 = validateParameter(valid_565019, JString, required = true,
                                 default = nil)
  if valid_565019 != nil:
    section.add "subscriptionId", valid_565019
  var valid_565020 = path.getOrDefault("resourceGroupName")
  valid_565020 = validateParameter(valid_565020, JString, required = true,
                                 default = nil)
  if valid_565020 != nil:
    section.add "resourceGroupName", valid_565020
  var valid_565021 = path.getOrDefault("virtualNetworkName")
  valid_565021 = validateParameter(valid_565021, JString, required = true,
                                 default = nil)
  if valid_565021 != nil:
    section.add "virtualNetworkName", valid_565021
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565022 = query.getOrDefault("api-version")
  valid_565022 = validateParameter(valid_565022, JString, required = true,
                                 default = nil)
  if valid_565022 != nil:
    section.add "api-version", valid_565022
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update Virtual Network operation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565024: Call_VirtualNetworksCreateOrUpdate_565016; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put VirtualNetwork operation creates/updates a virtual network in the specified resource group.
  ## 
  let valid = call_565024.validator(path, query, header, formData, body)
  let scheme = call_565024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565024.url(scheme.get, call_565024.host, call_565024.base,
                         call_565024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565024, url, valid)

proc call*(call_565025: Call_VirtualNetworksCreateOrUpdate_565016;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          virtualNetworkName: string; parameters: JsonNode): Recallable =
  ## virtualNetworksCreateOrUpdate
  ## The Put VirtualNetwork operation creates/updates a virtual network in the specified resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update Virtual Network operation
  var path_565026 = newJObject()
  var query_565027 = newJObject()
  var body_565028 = newJObject()
  add(query_565027, "api-version", newJString(apiVersion))
  add(path_565026, "subscriptionId", newJString(subscriptionId))
  add(path_565026, "resourceGroupName", newJString(resourceGroupName))
  add(path_565026, "virtualNetworkName", newJString(virtualNetworkName))
  if parameters != nil:
    body_565028 = parameters
  result = call_565025.call(path_565026, query_565027, nil, nil, body_565028)

var virtualNetworksCreateOrUpdate* = Call_VirtualNetworksCreateOrUpdate_565016(
    name: "virtualNetworksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworksCreateOrUpdate_565017, base: "",
    url: url_VirtualNetworksCreateOrUpdate_565018, schemes: {Scheme.Https})
type
  Call_VirtualNetworksGet_565004 = ref object of OpenApiRestCall_563549
proc url_VirtualNetworksGet_565006(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkName" in path,
        "`virtualNetworkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksGet_565005(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## The Get VirtualNetwork operation retrieves information about the specified virtual network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565007 = path.getOrDefault("subscriptionId")
  valid_565007 = validateParameter(valid_565007, JString, required = true,
                                 default = nil)
  if valid_565007 != nil:
    section.add "subscriptionId", valid_565007
  var valid_565008 = path.getOrDefault("resourceGroupName")
  valid_565008 = validateParameter(valid_565008, JString, required = true,
                                 default = nil)
  if valid_565008 != nil:
    section.add "resourceGroupName", valid_565008
  var valid_565009 = path.getOrDefault("virtualNetworkName")
  valid_565009 = validateParameter(valid_565009, JString, required = true,
                                 default = nil)
  if valid_565009 != nil:
    section.add "virtualNetworkName", valid_565009
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565010 = query.getOrDefault("api-version")
  valid_565010 = validateParameter(valid_565010, JString, required = true,
                                 default = nil)
  if valid_565010 != nil:
    section.add "api-version", valid_565010
  var valid_565011 = query.getOrDefault("$expand")
  valid_565011 = validateParameter(valid_565011, JString, required = false,
                                 default = nil)
  if valid_565011 != nil:
    section.add "$expand", valid_565011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565012: Call_VirtualNetworksGet_565004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get VirtualNetwork operation retrieves information about the specified virtual network.
  ## 
  let valid = call_565012.validator(path, query, header, formData, body)
  let scheme = call_565012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565012.url(scheme.get, call_565012.host, call_565012.base,
                         call_565012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565012, url, valid)

proc call*(call_565013: Call_VirtualNetworksGet_565004; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          virtualNetworkName: string; Expand: string = ""): Recallable =
  ## virtualNetworksGet
  ## The Get VirtualNetwork operation retrieves information about the specified virtual network.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : expand references resources.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_565014 = newJObject()
  var query_565015 = newJObject()
  add(query_565015, "api-version", newJString(apiVersion))
  add(query_565015, "$expand", newJString(Expand))
  add(path_565014, "subscriptionId", newJString(subscriptionId))
  add(path_565014, "resourceGroupName", newJString(resourceGroupName))
  add(path_565014, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_565013.call(path_565014, query_565015, nil, nil, nil)

var virtualNetworksGet* = Call_VirtualNetworksGet_565004(
    name: "virtualNetworksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworksGet_565005, base: "",
    url: url_VirtualNetworksGet_565006, schemes: {Scheme.Https})
type
  Call_VirtualNetworksDelete_565029 = ref object of OpenApiRestCall_563549
proc url_VirtualNetworksDelete_565031(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkName" in path,
        "`virtualNetworkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksDelete_565030(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Delete VirtualNetwork operation deletes the specified virtual network
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565032 = path.getOrDefault("subscriptionId")
  valid_565032 = validateParameter(valid_565032, JString, required = true,
                                 default = nil)
  if valid_565032 != nil:
    section.add "subscriptionId", valid_565032
  var valid_565033 = path.getOrDefault("resourceGroupName")
  valid_565033 = validateParameter(valid_565033, JString, required = true,
                                 default = nil)
  if valid_565033 != nil:
    section.add "resourceGroupName", valid_565033
  var valid_565034 = path.getOrDefault("virtualNetworkName")
  valid_565034 = validateParameter(valid_565034, JString, required = true,
                                 default = nil)
  if valid_565034 != nil:
    section.add "virtualNetworkName", valid_565034
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565035 = query.getOrDefault("api-version")
  valid_565035 = validateParameter(valid_565035, JString, required = true,
                                 default = nil)
  if valid_565035 != nil:
    section.add "api-version", valid_565035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565036: Call_VirtualNetworksDelete_565029; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete VirtualNetwork operation deletes the specified virtual network
  ## 
  let valid = call_565036.validator(path, query, header, formData, body)
  let scheme = call_565036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565036.url(scheme.get, call_565036.host, call_565036.base,
                         call_565036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565036, url, valid)

proc call*(call_565037: Call_VirtualNetworksDelete_565029; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          virtualNetworkName: string): Recallable =
  ## virtualNetworksDelete
  ## The Delete VirtualNetwork operation deletes the specified virtual network
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_565038 = newJObject()
  var query_565039 = newJObject()
  add(query_565039, "api-version", newJString(apiVersion))
  add(path_565038, "subscriptionId", newJString(subscriptionId))
  add(path_565038, "resourceGroupName", newJString(resourceGroupName))
  add(path_565038, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_565037.call(path_565038, query_565039, nil, nil, nil)

var virtualNetworksDelete* = Call_VirtualNetworksDelete_565029(
    name: "virtualNetworksDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworksDelete_565030, base: "",
    url: url_VirtualNetworksDelete_565031, schemes: {Scheme.Https})
type
  Call_SubnetsList_565040 = ref object of OpenApiRestCall_563549
proc url_SubnetsList_565042(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkName" in path,
        "`virtualNetworkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName"),
               (kind: ConstantSegment, value: "/subnets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubnetsList_565041(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## The List subnets operation retrieves all the subnets in a virtual network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565043 = path.getOrDefault("subscriptionId")
  valid_565043 = validateParameter(valid_565043, JString, required = true,
                                 default = nil)
  if valid_565043 != nil:
    section.add "subscriptionId", valid_565043
  var valid_565044 = path.getOrDefault("resourceGroupName")
  valid_565044 = validateParameter(valid_565044, JString, required = true,
                                 default = nil)
  if valid_565044 != nil:
    section.add "resourceGroupName", valid_565044
  var valid_565045 = path.getOrDefault("virtualNetworkName")
  valid_565045 = validateParameter(valid_565045, JString, required = true,
                                 default = nil)
  if valid_565045 != nil:
    section.add "virtualNetworkName", valid_565045
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565046 = query.getOrDefault("api-version")
  valid_565046 = validateParameter(valid_565046, JString, required = true,
                                 default = nil)
  if valid_565046 != nil:
    section.add "api-version", valid_565046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565047: Call_SubnetsList_565040; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List subnets operation retrieves all the subnets in a virtual network.
  ## 
  let valid = call_565047.validator(path, query, header, formData, body)
  let scheme = call_565047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565047.url(scheme.get, call_565047.host, call_565047.base,
                         call_565047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565047, url, valid)

proc call*(call_565048: Call_SubnetsList_565040; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          virtualNetworkName: string): Recallable =
  ## subnetsList
  ## The List subnets operation retrieves all the subnets in a virtual network.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_565049 = newJObject()
  var query_565050 = newJObject()
  add(query_565050, "api-version", newJString(apiVersion))
  add(path_565049, "subscriptionId", newJString(subscriptionId))
  add(path_565049, "resourceGroupName", newJString(resourceGroupName))
  add(path_565049, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_565048.call(path_565049, query_565050, nil, nil, nil)

var subnetsList* = Call_SubnetsList_565040(name: "subnetsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets",
                                        validator: validate_SubnetsList_565041,
                                        base: "", url: url_SubnetsList_565042,
                                        schemes: {Scheme.Https})
type
  Call_SubnetsCreateOrUpdate_565064 = ref object of OpenApiRestCall_563549
proc url_SubnetsCreateOrUpdate_565066(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkName" in path,
        "`virtualNetworkName` is a required path parameter"
  assert "subnetName" in path, "`subnetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName"),
               (kind: ConstantSegment, value: "/subnets/"),
               (kind: VariableSegment, value: "subnetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubnetsCreateOrUpdate_565065(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put Subnet operation creates/updates a subnet in the specified virtual network
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subnetName: JString (required)
  ##             : The name of the subnet.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565067 = path.getOrDefault("subscriptionId")
  valid_565067 = validateParameter(valid_565067, JString, required = true,
                                 default = nil)
  if valid_565067 != nil:
    section.add "subscriptionId", valid_565067
  var valid_565068 = path.getOrDefault("resourceGroupName")
  valid_565068 = validateParameter(valid_565068, JString, required = true,
                                 default = nil)
  if valid_565068 != nil:
    section.add "resourceGroupName", valid_565068
  var valid_565069 = path.getOrDefault("subnetName")
  valid_565069 = validateParameter(valid_565069, JString, required = true,
                                 default = nil)
  if valid_565069 != nil:
    section.add "subnetName", valid_565069
  var valid_565070 = path.getOrDefault("virtualNetworkName")
  valid_565070 = validateParameter(valid_565070, JString, required = true,
                                 default = nil)
  if valid_565070 != nil:
    section.add "virtualNetworkName", valid_565070
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565071 = query.getOrDefault("api-version")
  valid_565071 = validateParameter(valid_565071, JString, required = true,
                                 default = nil)
  if valid_565071 != nil:
    section.add "api-version", valid_565071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   subnetParameters: JObject (required)
  ##                   : Parameters supplied to the create/update Subnet operation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565073: Call_SubnetsCreateOrUpdate_565064; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put Subnet operation creates/updates a subnet in the specified virtual network
  ## 
  let valid = call_565073.validator(path, query, header, formData, body)
  let scheme = call_565073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565073.url(scheme.get, call_565073.host, call_565073.base,
                         call_565073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565073, url, valid)

proc call*(call_565074: Call_SubnetsCreateOrUpdate_565064; apiVersion: string;
          subnetParameters: JsonNode; subscriptionId: string;
          resourceGroupName: string; subnetName: string; virtualNetworkName: string): Recallable =
  ## subnetsCreateOrUpdate
  ## The Put Subnet operation creates/updates a subnet in the specified virtual network
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subnetParameters: JObject (required)
  ##                   : Parameters supplied to the create/update Subnet operation
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   subnetName: string (required)
  ##             : The name of the subnet.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_565075 = newJObject()
  var query_565076 = newJObject()
  var body_565077 = newJObject()
  add(query_565076, "api-version", newJString(apiVersion))
  if subnetParameters != nil:
    body_565077 = subnetParameters
  add(path_565075, "subscriptionId", newJString(subscriptionId))
  add(path_565075, "resourceGroupName", newJString(resourceGroupName))
  add(path_565075, "subnetName", newJString(subnetName))
  add(path_565075, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_565074.call(path_565075, query_565076, nil, nil, body_565077)

var subnetsCreateOrUpdate* = Call_SubnetsCreateOrUpdate_565064(
    name: "subnetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}",
    validator: validate_SubnetsCreateOrUpdate_565065, base: "",
    url: url_SubnetsCreateOrUpdate_565066, schemes: {Scheme.Https})
type
  Call_SubnetsGet_565051 = ref object of OpenApiRestCall_563549
proc url_SubnetsGet_565053(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkName" in path,
        "`virtualNetworkName` is a required path parameter"
  assert "subnetName" in path, "`subnetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName"),
               (kind: ConstantSegment, value: "/subnets/"),
               (kind: VariableSegment, value: "subnetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubnetsGet_565052(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get subnet operation retrieves information about the specified subnet.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subnetName: JString (required)
  ##             : The name of the subnet.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565054 = path.getOrDefault("subscriptionId")
  valid_565054 = validateParameter(valid_565054, JString, required = true,
                                 default = nil)
  if valid_565054 != nil:
    section.add "subscriptionId", valid_565054
  var valid_565055 = path.getOrDefault("resourceGroupName")
  valid_565055 = validateParameter(valid_565055, JString, required = true,
                                 default = nil)
  if valid_565055 != nil:
    section.add "resourceGroupName", valid_565055
  var valid_565056 = path.getOrDefault("subnetName")
  valid_565056 = validateParameter(valid_565056, JString, required = true,
                                 default = nil)
  if valid_565056 != nil:
    section.add "subnetName", valid_565056
  var valid_565057 = path.getOrDefault("virtualNetworkName")
  valid_565057 = validateParameter(valid_565057, JString, required = true,
                                 default = nil)
  if valid_565057 != nil:
    section.add "virtualNetworkName", valid_565057
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565058 = query.getOrDefault("api-version")
  valid_565058 = validateParameter(valid_565058, JString, required = true,
                                 default = nil)
  if valid_565058 != nil:
    section.add "api-version", valid_565058
  var valid_565059 = query.getOrDefault("$expand")
  valid_565059 = validateParameter(valid_565059, JString, required = false,
                                 default = nil)
  if valid_565059 != nil:
    section.add "$expand", valid_565059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565060: Call_SubnetsGet_565051; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get subnet operation retrieves information about the specified subnet.
  ## 
  let valid = call_565060.validator(path, query, header, formData, body)
  let scheme = call_565060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565060.url(scheme.get, call_565060.host, call_565060.base,
                         call_565060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565060, url, valid)

proc call*(call_565061: Call_SubnetsGet_565051; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; subnetName: string;
          virtualNetworkName: string; Expand: string = ""): Recallable =
  ## subnetsGet
  ## The Get subnet operation retrieves information about the specified subnet.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : expand references resources.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   subnetName: string (required)
  ##             : The name of the subnet.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_565062 = newJObject()
  var query_565063 = newJObject()
  add(query_565063, "api-version", newJString(apiVersion))
  add(query_565063, "$expand", newJString(Expand))
  add(path_565062, "subscriptionId", newJString(subscriptionId))
  add(path_565062, "resourceGroupName", newJString(resourceGroupName))
  add(path_565062, "subnetName", newJString(subnetName))
  add(path_565062, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_565061.call(path_565062, query_565063, nil, nil, nil)

var subnetsGet* = Call_SubnetsGet_565051(name: "subnetsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}",
                                      validator: validate_SubnetsGet_565052,
                                      base: "", url: url_SubnetsGet_565053,
                                      schemes: {Scheme.Https})
type
  Call_SubnetsDelete_565078 = ref object of OpenApiRestCall_563549
proc url_SubnetsDelete_565080(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkName" in path,
        "`virtualNetworkName` is a required path parameter"
  assert "subnetName" in path, "`subnetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName"),
               (kind: ConstantSegment, value: "/subnets/"),
               (kind: VariableSegment, value: "subnetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubnetsDelete_565079(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## The delete subnet operation deletes the specified subnet.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subnetName: JString (required)
  ##             : The name of the subnet.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565081 = path.getOrDefault("subscriptionId")
  valid_565081 = validateParameter(valid_565081, JString, required = true,
                                 default = nil)
  if valid_565081 != nil:
    section.add "subscriptionId", valid_565081
  var valid_565082 = path.getOrDefault("resourceGroupName")
  valid_565082 = validateParameter(valid_565082, JString, required = true,
                                 default = nil)
  if valid_565082 != nil:
    section.add "resourceGroupName", valid_565082
  var valid_565083 = path.getOrDefault("subnetName")
  valid_565083 = validateParameter(valid_565083, JString, required = true,
                                 default = nil)
  if valid_565083 != nil:
    section.add "subnetName", valid_565083
  var valid_565084 = path.getOrDefault("virtualNetworkName")
  valid_565084 = validateParameter(valid_565084, JString, required = true,
                                 default = nil)
  if valid_565084 != nil:
    section.add "virtualNetworkName", valid_565084
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565085 = query.getOrDefault("api-version")
  valid_565085 = validateParameter(valid_565085, JString, required = true,
                                 default = nil)
  if valid_565085 != nil:
    section.add "api-version", valid_565085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565086: Call_SubnetsDelete_565078; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete subnet operation deletes the specified subnet.
  ## 
  let valid = call_565086.validator(path, query, header, formData, body)
  let scheme = call_565086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565086.url(scheme.get, call_565086.host, call_565086.base,
                         call_565086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565086, url, valid)

proc call*(call_565087: Call_SubnetsDelete_565078; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; subnetName: string;
          virtualNetworkName: string): Recallable =
  ## subnetsDelete
  ## The delete subnet operation deletes the specified subnet.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   subnetName: string (required)
  ##             : The name of the subnet.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_565088 = newJObject()
  var query_565089 = newJObject()
  add(query_565089, "api-version", newJString(apiVersion))
  add(path_565088, "subscriptionId", newJString(subscriptionId))
  add(path_565088, "resourceGroupName", newJString(resourceGroupName))
  add(path_565088, "subnetName", newJString(subnetName))
  add(path_565088, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_565087.call(path_565088, query_565089, nil, nil, nil)

var subnetsDelete* = Call_SubnetsDelete_565078(name: "subnetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}",
    validator: validate_SubnetsDelete_565079, base: "", url: url_SubnetsDelete_565080,
    schemes: {Scheme.Https})
type
  Call_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_565090 = ref object of OpenApiRestCall_563549
proc url_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_565092(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualMachineScaleSetName" in path,
        "`virtualMachineScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "virtualMachineScaleSetName"),
               (kind: ConstantSegment, value: "/networkInterfaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_565091(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The list network interface operation retrieves information about all network interfaces in a virtual machine scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualMachineScaleSetName: JString (required)
  ##                             : The name of the virtual machine scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565093 = path.getOrDefault("subscriptionId")
  valid_565093 = validateParameter(valid_565093, JString, required = true,
                                 default = nil)
  if valid_565093 != nil:
    section.add "subscriptionId", valid_565093
  var valid_565094 = path.getOrDefault("virtualMachineScaleSetName")
  valid_565094 = validateParameter(valid_565094, JString, required = true,
                                 default = nil)
  if valid_565094 != nil:
    section.add "virtualMachineScaleSetName", valid_565094
  var valid_565095 = path.getOrDefault("resourceGroupName")
  valid_565095 = validateParameter(valid_565095, JString, required = true,
                                 default = nil)
  if valid_565095 != nil:
    section.add "resourceGroupName", valid_565095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565096 = query.getOrDefault("api-version")
  valid_565096 = validateParameter(valid_565096, JString, required = true,
                                 default = nil)
  if valid_565096 != nil:
    section.add "api-version", valid_565096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565097: Call_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_565090;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The list network interface operation retrieves information about all network interfaces in a virtual machine scale set.
  ## 
  let valid = call_565097.validator(path, query, header, formData, body)
  let scheme = call_565097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565097.url(scheme.get, call_565097.host, call_565097.base,
                         call_565097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565097, url, valid)

proc call*(call_565098: Call_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_565090;
          apiVersion: string; subscriptionId: string;
          virtualMachineScaleSetName: string; resourceGroupName: string): Recallable =
  ## networkInterfacesListVirtualMachineScaleSetNetworkInterfaces
  ## The list network interface operation retrieves information about all network interfaces in a virtual machine scale set.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualMachineScaleSetName: string (required)
  ##                             : The name of the virtual machine scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565099 = newJObject()
  var query_565100 = newJObject()
  add(query_565100, "api-version", newJString(apiVersion))
  add(path_565099, "subscriptionId", newJString(subscriptionId))
  add(path_565099, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  add(path_565099, "resourceGroupName", newJString(resourceGroupName))
  result = call_565098.call(path_565099, query_565100, nil, nil, nil)

var networkInterfacesListVirtualMachineScaleSetNetworkInterfaces* = Call_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_565090(
    name: "networkInterfacesListVirtualMachineScaleSetNetworkInterfaces",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/networkInterfaces", validator: validate_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_565091,
    base: "",
    url: url_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_565092,
    schemes: {Scheme.Https})
type
  Call_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_565101 = ref object of OpenApiRestCall_563549
proc url_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_565103(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualMachineScaleSetName" in path,
        "`virtualMachineScaleSetName` is a required path parameter"
  assert "virtualmachineIndex" in path,
        "`virtualmachineIndex` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "virtualMachineScaleSetName"),
               (kind: ConstantSegment, value: "/virtualMachines/"),
               (kind: VariableSegment, value: "virtualmachineIndex"),
               (kind: ConstantSegment, value: "/networkInterfaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_565102(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The list network interface operation retrieves information about all network interfaces in a virtual machine from a virtual machine scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualMachineScaleSetName: JString (required)
  ##                             : The name of the virtual machine scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualmachineIndex: JString (required)
  ##                      : The virtual machine index.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565104 = path.getOrDefault("subscriptionId")
  valid_565104 = validateParameter(valid_565104, JString, required = true,
                                 default = nil)
  if valid_565104 != nil:
    section.add "subscriptionId", valid_565104
  var valid_565105 = path.getOrDefault("virtualMachineScaleSetName")
  valid_565105 = validateParameter(valid_565105, JString, required = true,
                                 default = nil)
  if valid_565105 != nil:
    section.add "virtualMachineScaleSetName", valid_565105
  var valid_565106 = path.getOrDefault("resourceGroupName")
  valid_565106 = validateParameter(valid_565106, JString, required = true,
                                 default = nil)
  if valid_565106 != nil:
    section.add "resourceGroupName", valid_565106
  var valid_565107 = path.getOrDefault("virtualmachineIndex")
  valid_565107 = validateParameter(valid_565107, JString, required = true,
                                 default = nil)
  if valid_565107 != nil:
    section.add "virtualmachineIndex", valid_565107
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565108 = query.getOrDefault("api-version")
  valid_565108 = validateParameter(valid_565108, JString, required = true,
                                 default = nil)
  if valid_565108 != nil:
    section.add "api-version", valid_565108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565109: Call_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_565101;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The list network interface operation retrieves information about all network interfaces in a virtual machine from a virtual machine scale set.
  ## 
  let valid = call_565109.validator(path, query, header, formData, body)
  let scheme = call_565109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565109.url(scheme.get, call_565109.host, call_565109.base,
                         call_565109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565109, url, valid)

proc call*(call_565110: Call_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_565101;
          apiVersion: string; subscriptionId: string;
          virtualMachineScaleSetName: string; resourceGroupName: string;
          virtualmachineIndex: string): Recallable =
  ## networkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces
  ## The list network interface operation retrieves information about all network interfaces in a virtual machine from a virtual machine scale set.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualMachineScaleSetName: string (required)
  ##                             : The name of the virtual machine scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   virtualmachineIndex: string (required)
  ##                      : The virtual machine index.
  var path_565111 = newJObject()
  var query_565112 = newJObject()
  add(query_565112, "api-version", newJString(apiVersion))
  add(path_565111, "subscriptionId", newJString(subscriptionId))
  add(path_565111, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  add(path_565111, "resourceGroupName", newJString(resourceGroupName))
  add(path_565111, "virtualmachineIndex", newJString(virtualmachineIndex))
  result = call_565110.call(path_565111, query_565112, nil, nil, nil)

var networkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces* = Call_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_565101(
    name: "networkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/virtualMachines/{virtualmachineIndex}/networkInterfaces", validator: validate_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_565102,
    base: "",
    url: url_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_565103,
    schemes: {Scheme.Https})
type
  Call_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_565113 = ref object of OpenApiRestCall_563549
proc url_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_565115(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualMachineScaleSetName" in path,
        "`virtualMachineScaleSetName` is a required path parameter"
  assert "virtualmachineIndex" in path,
        "`virtualmachineIndex` is a required path parameter"
  assert "networkInterfaceName" in path,
        "`networkInterfaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "virtualMachineScaleSetName"),
               (kind: ConstantSegment, value: "/virtualMachines/"),
               (kind: VariableSegment, value: "virtualmachineIndex"),
               (kind: ConstantSegment, value: "/networkInterfaces/"),
               (kind: VariableSegment, value: "networkInterfaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_565114(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The Get network interface operation retrieves information about the specified network interface in a virtual machine scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkInterfaceName: JString (required)
  ##                       : The name of the network interface.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualMachineScaleSetName: JString (required)
  ##                             : The name of the virtual machine scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualmachineIndex: JString (required)
  ##                      : The virtual machine index.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `networkInterfaceName` field"
  var valid_565116 = path.getOrDefault("networkInterfaceName")
  valid_565116 = validateParameter(valid_565116, JString, required = true,
                                 default = nil)
  if valid_565116 != nil:
    section.add "networkInterfaceName", valid_565116
  var valid_565117 = path.getOrDefault("subscriptionId")
  valid_565117 = validateParameter(valid_565117, JString, required = true,
                                 default = nil)
  if valid_565117 != nil:
    section.add "subscriptionId", valid_565117
  var valid_565118 = path.getOrDefault("virtualMachineScaleSetName")
  valid_565118 = validateParameter(valid_565118, JString, required = true,
                                 default = nil)
  if valid_565118 != nil:
    section.add "virtualMachineScaleSetName", valid_565118
  var valid_565119 = path.getOrDefault("resourceGroupName")
  valid_565119 = validateParameter(valid_565119, JString, required = true,
                                 default = nil)
  if valid_565119 != nil:
    section.add "resourceGroupName", valid_565119
  var valid_565120 = path.getOrDefault("virtualmachineIndex")
  valid_565120 = validateParameter(valid_565120, JString, required = true,
                                 default = nil)
  if valid_565120 != nil:
    section.add "virtualmachineIndex", valid_565120
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565121 = query.getOrDefault("api-version")
  valid_565121 = validateParameter(valid_565121, JString, required = true,
                                 default = nil)
  if valid_565121 != nil:
    section.add "api-version", valid_565121
  var valid_565122 = query.getOrDefault("$expand")
  valid_565122 = validateParameter(valid_565122, JString, required = false,
                                 default = nil)
  if valid_565122 != nil:
    section.add "$expand", valid_565122
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565123: Call_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_565113;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Get network interface operation retrieves information about the specified network interface in a virtual machine scale set.
  ## 
  let valid = call_565123.validator(path, query, header, formData, body)
  let scheme = call_565123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565123.url(scheme.get, call_565123.host, call_565123.base,
                         call_565123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565123, url, valid)

proc call*(call_565124: Call_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_565113;
          apiVersion: string; networkInterfaceName: string; subscriptionId: string;
          virtualMachineScaleSetName: string; resourceGroupName: string;
          virtualmachineIndex: string; Expand: string = ""): Recallable =
  ## networkInterfacesGetVirtualMachineScaleSetNetworkInterface
  ## The Get network interface operation retrieves information about the specified network interface in a virtual machine scale set.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   networkInterfaceName: string (required)
  ##                       : The name of the network interface.
  ##   Expand: string
  ##         : expand references resources.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualMachineScaleSetName: string (required)
  ##                             : The name of the virtual machine scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   virtualmachineIndex: string (required)
  ##                      : The virtual machine index.
  var path_565125 = newJObject()
  var query_565126 = newJObject()
  add(query_565126, "api-version", newJString(apiVersion))
  add(path_565125, "networkInterfaceName", newJString(networkInterfaceName))
  add(query_565126, "$expand", newJString(Expand))
  add(path_565125, "subscriptionId", newJString(subscriptionId))
  add(path_565125, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  add(path_565125, "resourceGroupName", newJString(resourceGroupName))
  add(path_565125, "virtualmachineIndex", newJString(virtualmachineIndex))
  result = call_565124.call(path_565125, query_565126, nil, nil, nil)

var networkInterfacesGetVirtualMachineScaleSetNetworkInterface* = Call_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_565113(
    name: "networkInterfacesGetVirtualMachineScaleSetNetworkInterface",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/virtualMachines/{virtualmachineIndex}/networkInterfaces/{networkInterfaceName}", validator: validate_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_565114,
    base: "", url: url_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_565115,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
