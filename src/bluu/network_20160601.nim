
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2016-06-01
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

  OpenApiRestCall_593421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593421): Option[Scheme] {.used.} =
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
  macServiceName = "network"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ApplicationGatewaysListAll_593643 = ref object of OpenApiRestCall_593421
proc url_ApplicationGatewaysListAll_593645(protocol: Scheme; host: string;
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

proc validate_ApplicationGatewaysListAll_593644(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List ApplicationGateway operation retrieves all the application gateways in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593818 = path.getOrDefault("subscriptionId")
  valid_593818 = validateParameter(valid_593818, JString, required = true,
                                 default = nil)
  if valid_593818 != nil:
    section.add "subscriptionId", valid_593818
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593819 = query.getOrDefault("api-version")
  valid_593819 = validateParameter(valid_593819, JString, required = true,
                                 default = nil)
  if valid_593819 != nil:
    section.add "api-version", valid_593819
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593842: Call_ApplicationGatewaysListAll_593643; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List ApplicationGateway operation retrieves all the application gateways in a subscription.
  ## 
  let valid = call_593842.validator(path, query, header, formData, body)
  let scheme = call_593842.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593842.url(scheme.get, call_593842.host, call_593842.base,
                         call_593842.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593842, url, valid)

proc call*(call_593913: Call_ApplicationGatewaysListAll_593643; apiVersion: string;
          subscriptionId: string): Recallable =
  ## applicationGatewaysListAll
  ## The List ApplicationGateway operation retrieves all the application gateways in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593914 = newJObject()
  var query_593916 = newJObject()
  add(query_593916, "api-version", newJString(apiVersion))
  add(path_593914, "subscriptionId", newJString(subscriptionId))
  result = call_593913.call(path_593914, query_593916, nil, nil, nil)

var applicationGatewaysListAll* = Call_ApplicationGatewaysListAll_593643(
    name: "applicationGatewaysListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/applicationGateways",
    validator: validate_ApplicationGatewaysListAll_593644, base: "",
    url: url_ApplicationGatewaysListAll_593645, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsListAll_593955 = ref object of OpenApiRestCall_593421
proc url_ExpressRouteCircuitsListAll_593957(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsListAll_593956(path: JsonNode; query: JsonNode;
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
  var valid_593958 = path.getOrDefault("subscriptionId")
  valid_593958 = validateParameter(valid_593958, JString, required = true,
                                 default = nil)
  if valid_593958 != nil:
    section.add "subscriptionId", valid_593958
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593959 = query.getOrDefault("api-version")
  valid_593959 = validateParameter(valid_593959, JString, required = true,
                                 default = nil)
  if valid_593959 != nil:
    section.add "api-version", valid_593959
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593960: Call_ExpressRouteCircuitsListAll_593955; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List ExpressRouteCircuit operation retrieves all the ExpressRouteCircuits in a subscription.
  ## 
  let valid = call_593960.validator(path, query, header, formData, body)
  let scheme = call_593960.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593960.url(scheme.get, call_593960.host, call_593960.base,
                         call_593960.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593960, url, valid)

proc call*(call_593961: Call_ExpressRouteCircuitsListAll_593955;
          apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteCircuitsListAll
  ## The List ExpressRouteCircuit operation retrieves all the ExpressRouteCircuits in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593962 = newJObject()
  var query_593963 = newJObject()
  add(query_593963, "api-version", newJString(apiVersion))
  add(path_593962, "subscriptionId", newJString(subscriptionId))
  result = call_593961.call(path_593962, query_593963, nil, nil, nil)

var expressRouteCircuitsListAll* = Call_ExpressRouteCircuitsListAll_593955(
    name: "expressRouteCircuitsListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/expressRouteCircuits",
    validator: validate_ExpressRouteCircuitsListAll_593956, base: "",
    url: url_ExpressRouteCircuitsListAll_593957, schemes: {Scheme.Https})
type
  Call_ExpressRouteServiceProvidersList_593964 = ref object of OpenApiRestCall_593421
proc url_ExpressRouteServiceProvidersList_593966(protocol: Scheme; host: string;
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

proc validate_ExpressRouteServiceProvidersList_593965(path: JsonNode;
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
  var valid_593967 = path.getOrDefault("subscriptionId")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "subscriptionId", valid_593967
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593968 = query.getOrDefault("api-version")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "api-version", valid_593968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593969: Call_ExpressRouteServiceProvidersList_593964;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The List ExpressRouteServiceProvider operation retrieves all the available ExpressRouteServiceProviders.
  ## 
  let valid = call_593969.validator(path, query, header, formData, body)
  let scheme = call_593969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593969.url(scheme.get, call_593969.host, call_593969.base,
                         call_593969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593969, url, valid)

proc call*(call_593970: Call_ExpressRouteServiceProvidersList_593964;
          apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteServiceProvidersList
  ## The List ExpressRouteServiceProvider operation retrieves all the available ExpressRouteServiceProviders.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593971 = newJObject()
  var query_593972 = newJObject()
  add(query_593972, "api-version", newJString(apiVersion))
  add(path_593971, "subscriptionId", newJString(subscriptionId))
  result = call_593970.call(path_593971, query_593972, nil, nil, nil)

var expressRouteServiceProvidersList* = Call_ExpressRouteServiceProvidersList_593964(
    name: "expressRouteServiceProvidersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/expressRouteServiceProviders",
    validator: validate_ExpressRouteServiceProvidersList_593965, base: "",
    url: url_ExpressRouteServiceProvidersList_593966, schemes: {Scheme.Https})
type
  Call_LoadBalancersListAll_593973 = ref object of OpenApiRestCall_593421
proc url_LoadBalancersListAll_593975(protocol: Scheme; host: string; base: string;
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

proc validate_LoadBalancersListAll_593974(path: JsonNode; query: JsonNode;
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
  var valid_593976 = path.getOrDefault("subscriptionId")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "subscriptionId", valid_593976
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593977 = query.getOrDefault("api-version")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "api-version", valid_593977
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593978: Call_LoadBalancersListAll_593973; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List loadBalancer operation retrieves all the load balancers in a subscription.
  ## 
  let valid = call_593978.validator(path, query, header, formData, body)
  let scheme = call_593978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593978.url(scheme.get, call_593978.host, call_593978.base,
                         call_593978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593978, url, valid)

proc call*(call_593979: Call_LoadBalancersListAll_593973; apiVersion: string;
          subscriptionId: string): Recallable =
  ## loadBalancersListAll
  ## The List loadBalancer operation retrieves all the load balancers in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593980 = newJObject()
  var query_593981 = newJObject()
  add(query_593981, "api-version", newJString(apiVersion))
  add(path_593980, "subscriptionId", newJString(subscriptionId))
  result = call_593979.call(path_593980, query_593981, nil, nil, nil)

var loadBalancersListAll* = Call_LoadBalancersListAll_593973(
    name: "loadBalancersListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/loadBalancers",
    validator: validate_LoadBalancersListAll_593974, base: "",
    url: url_LoadBalancersListAll_593975, schemes: {Scheme.Https})
type
  Call_CheckDnsNameAvailability_593982 = ref object of OpenApiRestCall_593421
proc url_CheckDnsNameAvailability_593984(protocol: Scheme; host: string;
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

proc validate_CheckDnsNameAvailability_593983(path: JsonNode; query: JsonNode;
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
  var valid_593985 = path.getOrDefault("subscriptionId")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "subscriptionId", valid_593985
  var valid_593986 = path.getOrDefault("location")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "location", valid_593986
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   domainNameLabel: JString
  ##                  : The domain name to be verified. It must conform to the following regular expression: ^[a-z][a-z0-9-]{1,61}[a-z0-9]$.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593987 = query.getOrDefault("api-version")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "api-version", valid_593987
  var valid_593988 = query.getOrDefault("domainNameLabel")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "domainNameLabel", valid_593988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593989: Call_CheckDnsNameAvailability_593982; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether a domain name in the cloudapp.net zone is available for use.
  ## 
  let valid = call_593989.validator(path, query, header, formData, body)
  let scheme = call_593989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593989.url(scheme.get, call_593989.host, call_593989.base,
                         call_593989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593989, url, valid)

proc call*(call_593990: Call_CheckDnsNameAvailability_593982; apiVersion: string;
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
  var path_593991 = newJObject()
  var query_593992 = newJObject()
  add(query_593992, "api-version", newJString(apiVersion))
  add(path_593991, "subscriptionId", newJString(subscriptionId))
  add(query_593992, "domainNameLabel", newJString(domainNameLabel))
  add(path_593991, "location", newJString(location))
  result = call_593990.call(path_593991, query_593992, nil, nil, nil)

var checkDnsNameAvailability* = Call_CheckDnsNameAvailability_593982(
    name: "checkDnsNameAvailability", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/locations/{location}/CheckDnsNameAvailability",
    validator: validate_CheckDnsNameAvailability_593983, base: "",
    url: url_CheckDnsNameAvailability_593984, schemes: {Scheme.Https})
type
  Call_UsagesList_593993 = ref object of OpenApiRestCall_593421
proc url_UsagesList_593995(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UsagesList_593994(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593996 = path.getOrDefault("subscriptionId")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "subscriptionId", valid_593996
  var valid_593997 = path.getOrDefault("location")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "location", valid_593997
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593998 = query.getOrDefault("api-version")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "api-version", valid_593998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593999: Call_UsagesList_593993; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists compute usages for a subscription.
  ## 
  let valid = call_593999.validator(path, query, header, formData, body)
  let scheme = call_593999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593999.url(scheme.get, call_593999.host, call_593999.base,
                         call_593999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593999, url, valid)

proc call*(call_594000: Call_UsagesList_593993; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## usagesList
  ## Lists compute usages for a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location upon which resource usage is queried.
  var path_594001 = newJObject()
  var query_594002 = newJObject()
  add(query_594002, "api-version", newJString(apiVersion))
  add(path_594001, "subscriptionId", newJString(subscriptionId))
  add(path_594001, "location", newJString(location))
  result = call_594000.call(path_594001, query_594002, nil, nil, nil)

var usagesList* = Call_UsagesList_593993(name: "usagesList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/locations/{location}/usages",
                                      validator: validate_UsagesList_593994,
                                      base: "", url: url_UsagesList_593995,
                                      schemes: {Scheme.Https})
type
  Call_NetworkInterfacesListAll_594003 = ref object of OpenApiRestCall_593421
proc url_NetworkInterfacesListAll_594005(protocol: Scheme; host: string;
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

proc validate_NetworkInterfacesListAll_594004(path: JsonNode; query: JsonNode;
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
  var valid_594006 = path.getOrDefault("subscriptionId")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "subscriptionId", valid_594006
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594007 = query.getOrDefault("api-version")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "api-version", valid_594007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594008: Call_NetworkInterfacesListAll_594003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List networkInterfaces operation retrieves all the networkInterfaces in a subscription.
  ## 
  let valid = call_594008.validator(path, query, header, formData, body)
  let scheme = call_594008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594008.url(scheme.get, call_594008.host, call_594008.base,
                         call_594008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594008, url, valid)

proc call*(call_594009: Call_NetworkInterfacesListAll_594003; apiVersion: string;
          subscriptionId: string): Recallable =
  ## networkInterfacesListAll
  ## The List networkInterfaces operation retrieves all the networkInterfaces in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594010 = newJObject()
  var query_594011 = newJObject()
  add(query_594011, "api-version", newJString(apiVersion))
  add(path_594010, "subscriptionId", newJString(subscriptionId))
  result = call_594009.call(path_594010, query_594011, nil, nil, nil)

var networkInterfacesListAll* = Call_NetworkInterfacesListAll_594003(
    name: "networkInterfacesListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/networkInterfaces",
    validator: validate_NetworkInterfacesListAll_594004, base: "",
    url: url_NetworkInterfacesListAll_594005, schemes: {Scheme.Https})
type
  Call_NetworkSecurityGroupsListAll_594012 = ref object of OpenApiRestCall_593421
proc url_NetworkSecurityGroupsListAll_594014(protocol: Scheme; host: string;
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

proc validate_NetworkSecurityGroupsListAll_594013(path: JsonNode; query: JsonNode;
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
  var valid_594015 = path.getOrDefault("subscriptionId")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "subscriptionId", valid_594015
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594016 = query.getOrDefault("api-version")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "api-version", valid_594016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594017: Call_NetworkSecurityGroupsListAll_594012; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list NetworkSecurityGroups returns all network security groups in a subscription
  ## 
  let valid = call_594017.validator(path, query, header, formData, body)
  let scheme = call_594017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594017.url(scheme.get, call_594017.host, call_594017.base,
                         call_594017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594017, url, valid)

proc call*(call_594018: Call_NetworkSecurityGroupsListAll_594012;
          apiVersion: string; subscriptionId: string): Recallable =
  ## networkSecurityGroupsListAll
  ## The list NetworkSecurityGroups returns all network security groups in a subscription
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594019 = newJObject()
  var query_594020 = newJObject()
  add(query_594020, "api-version", newJString(apiVersion))
  add(path_594019, "subscriptionId", newJString(subscriptionId))
  result = call_594018.call(path_594019, query_594020, nil, nil, nil)

var networkSecurityGroupsListAll* = Call_NetworkSecurityGroupsListAll_594012(
    name: "networkSecurityGroupsListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/networkSecurityGroups",
    validator: validate_NetworkSecurityGroupsListAll_594013, base: "",
    url: url_NetworkSecurityGroupsListAll_594014, schemes: {Scheme.Https})
type
  Call_PublicIPAddressesListAll_594021 = ref object of OpenApiRestCall_593421
proc url_PublicIPAddressesListAll_594023(protocol: Scheme; host: string;
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

proc validate_PublicIPAddressesListAll_594022(path: JsonNode; query: JsonNode;
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
  var valid_594024 = path.getOrDefault("subscriptionId")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "subscriptionId", valid_594024
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594025 = query.getOrDefault("api-version")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "api-version", valid_594025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594026: Call_PublicIPAddressesListAll_594021; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List publicIpAddress operation retrieves all the publicIpAddresses in a subscription.
  ## 
  let valid = call_594026.validator(path, query, header, formData, body)
  let scheme = call_594026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594026.url(scheme.get, call_594026.host, call_594026.base,
                         call_594026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594026, url, valid)

proc call*(call_594027: Call_PublicIPAddressesListAll_594021; apiVersion: string;
          subscriptionId: string): Recallable =
  ## publicIPAddressesListAll
  ## The List publicIpAddress operation retrieves all the publicIpAddresses in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594028 = newJObject()
  var query_594029 = newJObject()
  add(query_594029, "api-version", newJString(apiVersion))
  add(path_594028, "subscriptionId", newJString(subscriptionId))
  result = call_594027.call(path_594028, query_594029, nil, nil, nil)

var publicIPAddressesListAll* = Call_PublicIPAddressesListAll_594021(
    name: "publicIPAddressesListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/publicIPAddresses",
    validator: validate_PublicIPAddressesListAll_594022, base: "",
    url: url_PublicIPAddressesListAll_594023, schemes: {Scheme.Https})
type
  Call_RouteTablesListAll_594030 = ref object of OpenApiRestCall_593421
proc url_RouteTablesListAll_594032(protocol: Scheme; host: string; base: string;
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

proc validate_RouteTablesListAll_594031(path: JsonNode; query: JsonNode;
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
  var valid_594033 = path.getOrDefault("subscriptionId")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "subscriptionId", valid_594033
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594034 = query.getOrDefault("api-version")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "api-version", valid_594034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594035: Call_RouteTablesListAll_594030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list RouteTables returns all route tables in a subscription
  ## 
  let valid = call_594035.validator(path, query, header, formData, body)
  let scheme = call_594035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594035.url(scheme.get, call_594035.host, call_594035.base,
                         call_594035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594035, url, valid)

proc call*(call_594036: Call_RouteTablesListAll_594030; apiVersion: string;
          subscriptionId: string): Recallable =
  ## routeTablesListAll
  ## The list RouteTables returns all route tables in a subscription
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594037 = newJObject()
  var query_594038 = newJObject()
  add(query_594038, "api-version", newJString(apiVersion))
  add(path_594037, "subscriptionId", newJString(subscriptionId))
  result = call_594036.call(path_594037, query_594038, nil, nil, nil)

var routeTablesListAll* = Call_RouteTablesListAll_594030(
    name: "routeTablesListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/routeTables",
    validator: validate_RouteTablesListAll_594031, base: "",
    url: url_RouteTablesListAll_594032, schemes: {Scheme.Https})
type
  Call_VirtualNetworksListAll_594039 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworksListAll_594041(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksListAll_594040(path: JsonNode; query: JsonNode;
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
  var valid_594042 = path.getOrDefault("subscriptionId")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "subscriptionId", valid_594042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594043 = query.getOrDefault("api-version")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "api-version", valid_594043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594044: Call_VirtualNetworksListAll_594039; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list VirtualNetwork returns all Virtual Networks in a subscription
  ## 
  let valid = call_594044.validator(path, query, header, formData, body)
  let scheme = call_594044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594044.url(scheme.get, call_594044.host, call_594044.base,
                         call_594044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594044, url, valid)

proc call*(call_594045: Call_VirtualNetworksListAll_594039; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualNetworksListAll
  ## The list VirtualNetwork returns all Virtual Networks in a subscription
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594046 = newJObject()
  var query_594047 = newJObject()
  add(query_594047, "api-version", newJString(apiVersion))
  add(path_594046, "subscriptionId", newJString(subscriptionId))
  result = call_594045.call(path_594046, query_594047, nil, nil, nil)

var virtualNetworksListAll* = Call_VirtualNetworksListAll_594039(
    name: "virtualNetworksListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/virtualNetworks",
    validator: validate_VirtualNetworksListAll_594040, base: "",
    url: url_VirtualNetworksListAll_594041, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysList_594048 = ref object of OpenApiRestCall_593421
proc url_ApplicationGatewaysList_594050(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationGatewaysList_594049(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List ApplicationGateway operation retrieves all the application gateways in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594051 = path.getOrDefault("resourceGroupName")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "resourceGroupName", valid_594051
  var valid_594052 = path.getOrDefault("subscriptionId")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "subscriptionId", valid_594052
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  if body != nil:
    result.add "body", body

proc call*(call_594054: Call_ApplicationGatewaysList_594048; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List ApplicationGateway operation retrieves all the application gateways in a resource group.
  ## 
  let valid = call_594054.validator(path, query, header, formData, body)
  let scheme = call_594054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594054.url(scheme.get, call_594054.host, call_594054.base,
                         call_594054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594054, url, valid)

proc call*(call_594055: Call_ApplicationGatewaysList_594048;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## applicationGatewaysList
  ## The List ApplicationGateway operation retrieves all the application gateways in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594056 = newJObject()
  var query_594057 = newJObject()
  add(path_594056, "resourceGroupName", newJString(resourceGroupName))
  add(query_594057, "api-version", newJString(apiVersion))
  add(path_594056, "subscriptionId", newJString(subscriptionId))
  result = call_594055.call(path_594056, query_594057, nil, nil, nil)

var applicationGatewaysList* = Call_ApplicationGatewaysList_594048(
    name: "applicationGatewaysList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways",
    validator: validate_ApplicationGatewaysList_594049, base: "",
    url: url_ApplicationGatewaysList_594050, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysCreateOrUpdate_594069 = ref object of OpenApiRestCall_593421
proc url_ApplicationGatewaysCreateOrUpdate_594071(protocol: Scheme; host: string;
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

proc validate_ApplicationGatewaysCreateOrUpdate_594070(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put ApplicationGateway operation creates/updates a ApplicationGateway
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: JString (required)
  ##                         : The name of the ApplicationGateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594089 = path.getOrDefault("resourceGroupName")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "resourceGroupName", valid_594089
  var valid_594090 = path.getOrDefault("subscriptionId")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "subscriptionId", valid_594090
  var valid_594091 = path.getOrDefault("applicationGatewayName")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "applicationGatewayName", valid_594091
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594092 = query.getOrDefault("api-version")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "api-version", valid_594092
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

proc call*(call_594094: Call_ApplicationGatewaysCreateOrUpdate_594069;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put ApplicationGateway operation creates/updates a ApplicationGateway
  ## 
  let valid = call_594094.validator(path, query, header, formData, body)
  let scheme = call_594094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594094.url(scheme.get, call_594094.host, call_594094.base,
                         call_594094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594094, url, valid)

proc call*(call_594095: Call_ApplicationGatewaysCreateOrUpdate_594069;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; applicationGatewayName: string): Recallable =
  ## applicationGatewaysCreateOrUpdate
  ## The Put ApplicationGateway operation creates/updates a ApplicationGateway
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/delete ApplicationGateway operation
  ##   applicationGatewayName: string (required)
  ##                         : The name of the ApplicationGateway.
  var path_594096 = newJObject()
  var query_594097 = newJObject()
  var body_594098 = newJObject()
  add(path_594096, "resourceGroupName", newJString(resourceGroupName))
  add(query_594097, "api-version", newJString(apiVersion))
  add(path_594096, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594098 = parameters
  add(path_594096, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_594095.call(path_594096, query_594097, nil, nil, body_594098)

var applicationGatewaysCreateOrUpdate* = Call_ApplicationGatewaysCreateOrUpdate_594069(
    name: "applicationGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}",
    validator: validate_ApplicationGatewaysCreateOrUpdate_594070, base: "",
    url: url_ApplicationGatewaysCreateOrUpdate_594071, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysGet_594058 = ref object of OpenApiRestCall_593421
proc url_ApplicationGatewaysGet_594060(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationGatewaysGet_594059(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get ApplicationGateway operation retrieves information about the specified application gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: JString (required)
  ##                         : The name of the application gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594061 = path.getOrDefault("resourceGroupName")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "resourceGroupName", valid_594061
  var valid_594062 = path.getOrDefault("subscriptionId")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "subscriptionId", valid_594062
  var valid_594063 = path.getOrDefault("applicationGatewayName")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "applicationGatewayName", valid_594063
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_594065: Call_ApplicationGatewaysGet_594058; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get ApplicationGateway operation retrieves information about the specified application gateway.
  ## 
  let valid = call_594065.validator(path, query, header, formData, body)
  let scheme = call_594065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594065.url(scheme.get, call_594065.host, call_594065.base,
                         call_594065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594065, url, valid)

proc call*(call_594066: Call_ApplicationGatewaysGet_594058;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          applicationGatewayName: string): Recallable =
  ## applicationGatewaysGet
  ## The Get ApplicationGateway operation retrieves information about the specified application gateway.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: string (required)
  ##                         : The name of the application gateway.
  var path_594067 = newJObject()
  var query_594068 = newJObject()
  add(path_594067, "resourceGroupName", newJString(resourceGroupName))
  add(query_594068, "api-version", newJString(apiVersion))
  add(path_594067, "subscriptionId", newJString(subscriptionId))
  add(path_594067, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_594066.call(path_594067, query_594068, nil, nil, nil)

var applicationGatewaysGet* = Call_ApplicationGatewaysGet_594058(
    name: "applicationGatewaysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}",
    validator: validate_ApplicationGatewaysGet_594059, base: "",
    url: url_ApplicationGatewaysGet_594060, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysDelete_594099 = ref object of OpenApiRestCall_593421
proc url_ApplicationGatewaysDelete_594101(protocol: Scheme; host: string;
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

proc validate_ApplicationGatewaysDelete_594100(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The delete ApplicationGateway operation deletes the specified application gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: JString (required)
  ##                         : The name of the application gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594102 = path.getOrDefault("resourceGroupName")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "resourceGroupName", valid_594102
  var valid_594103 = path.getOrDefault("subscriptionId")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "subscriptionId", valid_594103
  var valid_594104 = path.getOrDefault("applicationGatewayName")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "applicationGatewayName", valid_594104
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594105 = query.getOrDefault("api-version")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "api-version", valid_594105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594106: Call_ApplicationGatewaysDelete_594099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete ApplicationGateway operation deletes the specified application gateway.
  ## 
  let valid = call_594106.validator(path, query, header, formData, body)
  let scheme = call_594106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594106.url(scheme.get, call_594106.host, call_594106.base,
                         call_594106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594106, url, valid)

proc call*(call_594107: Call_ApplicationGatewaysDelete_594099;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          applicationGatewayName: string): Recallable =
  ## applicationGatewaysDelete
  ## The delete ApplicationGateway operation deletes the specified application gateway.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: string (required)
  ##                         : The name of the application gateway.
  var path_594108 = newJObject()
  var query_594109 = newJObject()
  add(path_594108, "resourceGroupName", newJString(resourceGroupName))
  add(query_594109, "api-version", newJString(apiVersion))
  add(path_594108, "subscriptionId", newJString(subscriptionId))
  add(path_594108, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_594107.call(path_594108, query_594109, nil, nil, nil)

var applicationGatewaysDelete* = Call_ApplicationGatewaysDelete_594099(
    name: "applicationGatewaysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}",
    validator: validate_ApplicationGatewaysDelete_594100, base: "",
    url: url_ApplicationGatewaysDelete_594101, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysStart_594110 = ref object of OpenApiRestCall_593421
proc url_ApplicationGatewaysStart_594112(protocol: Scheme; host: string;
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

proc validate_ApplicationGatewaysStart_594111(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Start ApplicationGateway operation starts application gateway in the specified resource group through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: JString (required)
  ##                         : The name of the application gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594113 = path.getOrDefault("resourceGroupName")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "resourceGroupName", valid_594113
  var valid_594114 = path.getOrDefault("subscriptionId")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "subscriptionId", valid_594114
  var valid_594115 = path.getOrDefault("applicationGatewayName")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "applicationGatewayName", valid_594115
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594116 = query.getOrDefault("api-version")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "api-version", valid_594116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594117: Call_ApplicationGatewaysStart_594110; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Start ApplicationGateway operation starts application gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_594117.validator(path, query, header, formData, body)
  let scheme = call_594117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594117.url(scheme.get, call_594117.host, call_594117.base,
                         call_594117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594117, url, valid)

proc call*(call_594118: Call_ApplicationGatewaysStart_594110;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          applicationGatewayName: string): Recallable =
  ## applicationGatewaysStart
  ## The Start ApplicationGateway operation starts application gateway in the specified resource group through Network resource provider.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: string (required)
  ##                         : The name of the application gateway.
  var path_594119 = newJObject()
  var query_594120 = newJObject()
  add(path_594119, "resourceGroupName", newJString(resourceGroupName))
  add(query_594120, "api-version", newJString(apiVersion))
  add(path_594119, "subscriptionId", newJString(subscriptionId))
  add(path_594119, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_594118.call(path_594119, query_594120, nil, nil, nil)

var applicationGatewaysStart* = Call_ApplicationGatewaysStart_594110(
    name: "applicationGatewaysStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}/start",
    validator: validate_ApplicationGatewaysStart_594111, base: "",
    url: url_ApplicationGatewaysStart_594112, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysStop_594121 = ref object of OpenApiRestCall_593421
proc url_ApplicationGatewaysStop_594123(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationGatewaysStop_594122(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The STOP ApplicationGateway operation stops application gateway in the specified resource group through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: JString (required)
  ##                         : The name of the application gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594124 = path.getOrDefault("resourceGroupName")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "resourceGroupName", valid_594124
  var valid_594125 = path.getOrDefault("subscriptionId")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "subscriptionId", valid_594125
  var valid_594126 = path.getOrDefault("applicationGatewayName")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "applicationGatewayName", valid_594126
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594127 = query.getOrDefault("api-version")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "api-version", valid_594127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594128: Call_ApplicationGatewaysStop_594121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The STOP ApplicationGateway operation stops application gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_594128.validator(path, query, header, formData, body)
  let scheme = call_594128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594128.url(scheme.get, call_594128.host, call_594128.base,
                         call_594128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594128, url, valid)

proc call*(call_594129: Call_ApplicationGatewaysStop_594121;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          applicationGatewayName: string): Recallable =
  ## applicationGatewaysStop
  ## The STOP ApplicationGateway operation stops application gateway in the specified resource group through Network resource provider.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: string (required)
  ##                         : The name of the application gateway.
  var path_594130 = newJObject()
  var query_594131 = newJObject()
  add(path_594130, "resourceGroupName", newJString(resourceGroupName))
  add(query_594131, "api-version", newJString(apiVersion))
  add(path_594130, "subscriptionId", newJString(subscriptionId))
  add(path_594130, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_594129.call(path_594130, query_594131, nil, nil, nil)

var applicationGatewaysStop* = Call_ApplicationGatewaysStop_594121(
    name: "applicationGatewaysStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}/stop",
    validator: validate_ApplicationGatewaysStop_594122, base: "",
    url: url_ApplicationGatewaysStop_594123, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsList_594132 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworkGatewayConnectionsList_594134(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsList_594133(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List VirtualNetworkGatewayConnections operation retrieves all the virtual network gateways connections created.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594135 = path.getOrDefault("resourceGroupName")
  valid_594135 = validateParameter(valid_594135, JString, required = true,
                                 default = nil)
  if valid_594135 != nil:
    section.add "resourceGroupName", valid_594135
  var valid_594136 = path.getOrDefault("subscriptionId")
  valid_594136 = validateParameter(valid_594136, JString, required = true,
                                 default = nil)
  if valid_594136 != nil:
    section.add "subscriptionId", valid_594136
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594137 = query.getOrDefault("api-version")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = nil)
  if valid_594137 != nil:
    section.add "api-version", valid_594137
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594138: Call_VirtualNetworkGatewayConnectionsList_594132;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The List VirtualNetworkGatewayConnections operation retrieves all the virtual network gateways connections created.
  ## 
  let valid = call_594138.validator(path, query, header, formData, body)
  let scheme = call_594138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594138.url(scheme.get, call_594138.host, call_594138.base,
                         call_594138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594138, url, valid)

proc call*(call_594139: Call_VirtualNetworkGatewayConnectionsList_594132;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualNetworkGatewayConnectionsList
  ## The List VirtualNetworkGatewayConnections operation retrieves all the virtual network gateways connections created.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594140 = newJObject()
  var query_594141 = newJObject()
  add(path_594140, "resourceGroupName", newJString(resourceGroupName))
  add(query_594141, "api-version", newJString(apiVersion))
  add(path_594140, "subscriptionId", newJString(subscriptionId))
  result = call_594139.call(path_594140, query_594141, nil, nil, nil)

var virtualNetworkGatewayConnectionsList* = Call_VirtualNetworkGatewayConnectionsList_594132(
    name: "virtualNetworkGatewayConnectionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections",
    validator: validate_VirtualNetworkGatewayConnectionsList_594133, base: "",
    url: url_VirtualNetworkGatewayConnectionsList_594134, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_594153 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworkGatewayConnectionsCreateOrUpdate_594155(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsCreateOrUpdate_594154(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The Put VirtualNetworkGatewayConnection operation creates/updates a virtual network gateway connection in the specified resource group through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: JString (required)
  ##                                      : The name of the virtual network gateway connection.
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
  var valid_594158 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_594158
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Begin Create or update Virtual Network Gateway connection operation through Network resource provider.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594161: Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_594153;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put VirtualNetworkGatewayConnection operation creates/updates a virtual network gateway connection in the specified resource group through Network resource provider.
  ## 
  let valid = call_594161.validator(path, query, header, formData, body)
  let scheme = call_594161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594161.url(scheme.get, call_594161.host, call_594161.base,
                         call_594161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594161, url, valid)

proc call*(call_594162: Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_594153;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; virtualNetworkGatewayConnectionName: string): Recallable =
  ## virtualNetworkGatewayConnectionsCreateOrUpdate
  ## The Put VirtualNetworkGatewayConnection operation creates/updates a virtual network gateway connection in the specified resource group through Network resource provider.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Begin Create or update Virtual Network Gateway connection operation through Network resource provider.
  ##   virtualNetworkGatewayConnectionName: string (required)
  ##                                      : The name of the virtual network gateway connection.
  var path_594163 = newJObject()
  var query_594164 = newJObject()
  var body_594165 = newJObject()
  add(path_594163, "resourceGroupName", newJString(resourceGroupName))
  add(query_594164, "api-version", newJString(apiVersion))
  add(path_594163, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594165 = parameters
  add(path_594163, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_594162.call(path_594163, query_594164, nil, nil, body_594165)

var virtualNetworkGatewayConnectionsCreateOrUpdate* = Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_594153(
    name: "virtualNetworkGatewayConnectionsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}",
    validator: validate_VirtualNetworkGatewayConnectionsCreateOrUpdate_594154,
    base: "", url: url_VirtualNetworkGatewayConnectionsCreateOrUpdate_594155,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsGet_594142 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworkGatewayConnectionsGet_594144(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGatewayConnectionsGet_594143(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get VirtualNetworkGatewayConnection operation retrieves information about the specified virtual network gateway connection through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: JString (required)
  ##                                      : The name of the virtual network gateway connection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594145 = path.getOrDefault("resourceGroupName")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "resourceGroupName", valid_594145
  var valid_594146 = path.getOrDefault("subscriptionId")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "subscriptionId", valid_594146
  var valid_594147 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_594147
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594148 = query.getOrDefault("api-version")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "api-version", valid_594148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594149: Call_VirtualNetworkGatewayConnectionsGet_594142;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Get VirtualNetworkGatewayConnection operation retrieves information about the specified virtual network gateway connection through Network resource provider.
  ## 
  let valid = call_594149.validator(path, query, header, formData, body)
  let scheme = call_594149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594149.url(scheme.get, call_594149.host, call_594149.base,
                         call_594149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594149, url, valid)

proc call*(call_594150: Call_VirtualNetworkGatewayConnectionsGet_594142;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkGatewayConnectionName: string): Recallable =
  ## virtualNetworkGatewayConnectionsGet
  ## The Get VirtualNetworkGatewayConnection operation retrieves information about the specified virtual network gateway connection through Network resource provider.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: string (required)
  ##                                      : The name of the virtual network gateway connection.
  var path_594151 = newJObject()
  var query_594152 = newJObject()
  add(path_594151, "resourceGroupName", newJString(resourceGroupName))
  add(query_594152, "api-version", newJString(apiVersion))
  add(path_594151, "subscriptionId", newJString(subscriptionId))
  add(path_594151, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_594150.call(path_594151, query_594152, nil, nil, nil)

var virtualNetworkGatewayConnectionsGet* = Call_VirtualNetworkGatewayConnectionsGet_594142(
    name: "virtualNetworkGatewayConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}",
    validator: validate_VirtualNetworkGatewayConnectionsGet_594143, base: "",
    url: url_VirtualNetworkGatewayConnectionsGet_594144, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsDelete_594166 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworkGatewayConnectionsDelete_594168(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsDelete_594167(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Delete VirtualNetworkGatewayConnection operation deletes the specified virtual network Gateway connection through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: JString (required)
  ##                                      : The name of the virtual network gateway connection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594169 = path.getOrDefault("resourceGroupName")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "resourceGroupName", valid_594169
  var valid_594170 = path.getOrDefault("subscriptionId")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "subscriptionId", valid_594170
  var valid_594171 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_594171
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594172 = query.getOrDefault("api-version")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = nil)
  if valid_594172 != nil:
    section.add "api-version", valid_594172
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594173: Call_VirtualNetworkGatewayConnectionsDelete_594166;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Delete VirtualNetworkGatewayConnection operation deletes the specified virtual network Gateway connection through Network resource provider.
  ## 
  let valid = call_594173.validator(path, query, header, formData, body)
  let scheme = call_594173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594173.url(scheme.get, call_594173.host, call_594173.base,
                         call_594173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594173, url, valid)

proc call*(call_594174: Call_VirtualNetworkGatewayConnectionsDelete_594166;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkGatewayConnectionName: string): Recallable =
  ## virtualNetworkGatewayConnectionsDelete
  ## The Delete VirtualNetworkGatewayConnection operation deletes the specified virtual network Gateway connection through Network resource provider.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: string (required)
  ##                                      : The name of the virtual network gateway connection.
  var path_594175 = newJObject()
  var query_594176 = newJObject()
  add(path_594175, "resourceGroupName", newJString(resourceGroupName))
  add(query_594176, "api-version", newJString(apiVersion))
  add(path_594175, "subscriptionId", newJString(subscriptionId))
  add(path_594175, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_594174.call(path_594175, query_594176, nil, nil, nil)

var virtualNetworkGatewayConnectionsDelete* = Call_VirtualNetworkGatewayConnectionsDelete_594166(
    name: "virtualNetworkGatewayConnectionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}",
    validator: validate_VirtualNetworkGatewayConnectionsDelete_594167, base: "",
    url: url_VirtualNetworkGatewayConnectionsDelete_594168,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsSetSharedKey_594188 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworkGatewayConnectionsSetSharedKey_594190(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsSetSharedKey_594189(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put VirtualNetworkGatewayConnectionSharedKey operation sets the virtual network gateway connection shared key for passed virtual network gateway connection in the specified resource group through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: JString (required)
  ##                                      : The virtual network gateway connection name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594191 = path.getOrDefault("resourceGroupName")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "resourceGroupName", valid_594191
  var valid_594192 = path.getOrDefault("subscriptionId")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "subscriptionId", valid_594192
  var valid_594193 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_594193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Begin Set Virtual Network Gateway connection Shared key operation throughNetwork resource provider.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594196: Call_VirtualNetworkGatewayConnectionsSetSharedKey_594188;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put VirtualNetworkGatewayConnectionSharedKey operation sets the virtual network gateway connection shared key for passed virtual network gateway connection in the specified resource group through Network resource provider.
  ## 
  let valid = call_594196.validator(path, query, header, formData, body)
  let scheme = call_594196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594196.url(scheme.get, call_594196.host, call_594196.base,
                         call_594196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594196, url, valid)

proc call*(call_594197: Call_VirtualNetworkGatewayConnectionsSetSharedKey_594188;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; virtualNetworkGatewayConnectionName: string): Recallable =
  ## virtualNetworkGatewayConnectionsSetSharedKey
  ## The Put VirtualNetworkGatewayConnectionSharedKey operation sets the virtual network gateway connection shared key for passed virtual network gateway connection in the specified resource group through Network resource provider.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Begin Set Virtual Network Gateway connection Shared key operation throughNetwork resource provider.
  ##   virtualNetworkGatewayConnectionName: string (required)
  ##                                      : The virtual network gateway connection name.
  var path_594198 = newJObject()
  var query_594199 = newJObject()
  var body_594200 = newJObject()
  add(path_594198, "resourceGroupName", newJString(resourceGroupName))
  add(query_594199, "api-version", newJString(apiVersion))
  add(path_594198, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594200 = parameters
  add(path_594198, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_594197.call(path_594198, query_594199, nil, nil, body_594200)

var virtualNetworkGatewayConnectionsSetSharedKey* = Call_VirtualNetworkGatewayConnectionsSetSharedKey_594188(
    name: "virtualNetworkGatewayConnectionsSetSharedKey",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/sharedkey",
    validator: validate_VirtualNetworkGatewayConnectionsSetSharedKey_594189,
    base: "", url: url_VirtualNetworkGatewayConnectionsSetSharedKey_594190,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsGetSharedKey_594177 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworkGatewayConnectionsGetSharedKey_594179(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsGetSharedKey_594178(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get VirtualNetworkGatewayConnectionSharedKey operation retrieves information about the specified virtual network gateway connection shared key through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: JString (required)
  ##                                      : The virtual network gateway connection shared key name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594180 = path.getOrDefault("resourceGroupName")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "resourceGroupName", valid_594180
  var valid_594181 = path.getOrDefault("subscriptionId")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "subscriptionId", valid_594181
  var valid_594182 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_594182
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594183 = query.getOrDefault("api-version")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "api-version", valid_594183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594184: Call_VirtualNetworkGatewayConnectionsGetSharedKey_594177;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Get VirtualNetworkGatewayConnectionSharedKey operation retrieves information about the specified virtual network gateway connection shared key through Network resource provider.
  ## 
  let valid = call_594184.validator(path, query, header, formData, body)
  let scheme = call_594184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594184.url(scheme.get, call_594184.host, call_594184.base,
                         call_594184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594184, url, valid)

proc call*(call_594185: Call_VirtualNetworkGatewayConnectionsGetSharedKey_594177;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkGatewayConnectionName: string): Recallable =
  ## virtualNetworkGatewayConnectionsGetSharedKey
  ## The Get VirtualNetworkGatewayConnectionSharedKey operation retrieves information about the specified virtual network gateway connection shared key through Network resource provider.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: string (required)
  ##                                      : The virtual network gateway connection shared key name.
  var path_594186 = newJObject()
  var query_594187 = newJObject()
  add(path_594186, "resourceGroupName", newJString(resourceGroupName))
  add(query_594187, "api-version", newJString(apiVersion))
  add(path_594186, "subscriptionId", newJString(subscriptionId))
  add(path_594186, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_594185.call(path_594186, query_594187, nil, nil, nil)

var virtualNetworkGatewayConnectionsGetSharedKey* = Call_VirtualNetworkGatewayConnectionsGetSharedKey_594177(
    name: "virtualNetworkGatewayConnectionsGetSharedKey",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/sharedkey",
    validator: validate_VirtualNetworkGatewayConnectionsGetSharedKey_594178,
    base: "", url: url_VirtualNetworkGatewayConnectionsGetSharedKey_594179,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsResetSharedKey_594201 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworkGatewayConnectionsResetSharedKey_594203(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsResetSharedKey_594202(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The VirtualNetworkGatewayConnectionResetSharedKey operation resets the virtual network gateway connection shared key for passed virtual network gateway connection in the specified resource group through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayConnectionName: JString (required)
  ##                                      : The virtual network gateway connection reset shared key Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594204 = path.getOrDefault("resourceGroupName")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = nil)
  if valid_594204 != nil:
    section.add "resourceGroupName", valid_594204
  var valid_594205 = path.getOrDefault("subscriptionId")
  valid_594205 = validateParameter(valid_594205, JString, required = true,
                                 default = nil)
  if valid_594205 != nil:
    section.add "subscriptionId", valid_594205
  var valid_594206 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_594206 = validateParameter(valid_594206, JString, required = true,
                                 default = nil)
  if valid_594206 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_594206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594207 = query.getOrDefault("api-version")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "api-version", valid_594207
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

proc call*(call_594209: Call_VirtualNetworkGatewayConnectionsResetSharedKey_594201;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The VirtualNetworkGatewayConnectionResetSharedKey operation resets the virtual network gateway connection shared key for passed virtual network gateway connection in the specified resource group through Network resource provider.
  ## 
  let valid = call_594209.validator(path, query, header, formData, body)
  let scheme = call_594209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594209.url(scheme.get, call_594209.host, call_594209.base,
                         call_594209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594209, url, valid)

proc call*(call_594210: Call_VirtualNetworkGatewayConnectionsResetSharedKey_594201;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; virtualNetworkGatewayConnectionName: string): Recallable =
  ## virtualNetworkGatewayConnectionsResetSharedKey
  ## The VirtualNetworkGatewayConnectionResetSharedKey operation resets the virtual network gateway connection shared key for passed virtual network gateway connection in the specified resource group through Network resource provider.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Begin Reset Virtual Network Gateway connection shared key operation through Network resource provider.
  ##   virtualNetworkGatewayConnectionName: string (required)
  ##                                      : The virtual network gateway connection reset shared key Name.
  var path_594211 = newJObject()
  var query_594212 = newJObject()
  var body_594213 = newJObject()
  add(path_594211, "resourceGroupName", newJString(resourceGroupName))
  add(query_594212, "api-version", newJString(apiVersion))
  add(path_594211, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594213 = parameters
  add(path_594211, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_594210.call(path_594211, query_594212, nil, nil, body_594213)

var virtualNetworkGatewayConnectionsResetSharedKey* = Call_VirtualNetworkGatewayConnectionsResetSharedKey_594201(
    name: "virtualNetworkGatewayConnectionsResetSharedKey",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/sharedkey/reset",
    validator: validate_VirtualNetworkGatewayConnectionsResetSharedKey_594202,
    base: "", url: url_VirtualNetworkGatewayConnectionsResetSharedKey_594203,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsList_594214 = ref object of OpenApiRestCall_593421
proc url_ExpressRouteCircuitsList_594216(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsList_594215(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List ExpressRouteCircuit operation retrieves all the ExpressRouteCircuits in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594217 = path.getOrDefault("resourceGroupName")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "resourceGroupName", valid_594217
  var valid_594218 = path.getOrDefault("subscriptionId")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "subscriptionId", valid_594218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594219 = query.getOrDefault("api-version")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = nil)
  if valid_594219 != nil:
    section.add "api-version", valid_594219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594220: Call_ExpressRouteCircuitsList_594214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List ExpressRouteCircuit operation retrieves all the ExpressRouteCircuits in a resource group.
  ## 
  let valid = call_594220.validator(path, query, header, formData, body)
  let scheme = call_594220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594220.url(scheme.get, call_594220.host, call_594220.base,
                         call_594220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594220, url, valid)

proc call*(call_594221: Call_ExpressRouteCircuitsList_594214;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteCircuitsList
  ## The List ExpressRouteCircuit operation retrieves all the ExpressRouteCircuits in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594222 = newJObject()
  var query_594223 = newJObject()
  add(path_594222, "resourceGroupName", newJString(resourceGroupName))
  add(query_594223, "api-version", newJString(apiVersion))
  add(path_594222, "subscriptionId", newJString(subscriptionId))
  result = call_594221.call(path_594222, query_594223, nil, nil, nil)

var expressRouteCircuitsList* = Call_ExpressRouteCircuitsList_594214(
    name: "expressRouteCircuitsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits",
    validator: validate_ExpressRouteCircuitsList_594215, base: "",
    url: url_ExpressRouteCircuitsList_594216, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsCreateOrUpdate_594235 = ref object of OpenApiRestCall_593421
proc url_ExpressRouteCircuitsCreateOrUpdate_594237(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsCreateOrUpdate_594236(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put ExpressRouteCircuit operation creates/updates a ExpressRouteCircuit
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   circuitName: JString (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_594238 = path.getOrDefault("circuitName")
  valid_594238 = validateParameter(valid_594238, JString, required = true,
                                 default = nil)
  if valid_594238 != nil:
    section.add "circuitName", valid_594238
  var valid_594239 = path.getOrDefault("resourceGroupName")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "resourceGroupName", valid_594239
  var valid_594240 = path.getOrDefault("subscriptionId")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "subscriptionId", valid_594240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594241 = query.getOrDefault("api-version")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "api-version", valid_594241
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

proc call*(call_594243: Call_ExpressRouteCircuitsCreateOrUpdate_594235;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put ExpressRouteCircuit operation creates/updates a ExpressRouteCircuit
  ## 
  let valid = call_594243.validator(path, query, header, formData, body)
  let scheme = call_594243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594243.url(scheme.get, call_594243.host, call_594243.base,
                         call_594243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594243, url, valid)

proc call*(call_594244: Call_ExpressRouteCircuitsCreateOrUpdate_594235;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## expressRouteCircuitsCreateOrUpdate
  ## The Put ExpressRouteCircuit operation creates/updates a ExpressRouteCircuit
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/delete ExpressRouteCircuit operation
  var path_594245 = newJObject()
  var query_594246 = newJObject()
  var body_594247 = newJObject()
  add(path_594245, "circuitName", newJString(circuitName))
  add(path_594245, "resourceGroupName", newJString(resourceGroupName))
  add(query_594246, "api-version", newJString(apiVersion))
  add(path_594245, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594247 = parameters
  result = call_594244.call(path_594245, query_594246, nil, nil, body_594247)

var expressRouteCircuitsCreateOrUpdate* = Call_ExpressRouteCircuitsCreateOrUpdate_594235(
    name: "expressRouteCircuitsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}",
    validator: validate_ExpressRouteCircuitsCreateOrUpdate_594236, base: "",
    url: url_ExpressRouteCircuitsCreateOrUpdate_594237, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsGet_594224 = ref object of OpenApiRestCall_593421
proc url_ExpressRouteCircuitsGet_594226(protocol: Scheme; host: string; base: string;
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

proc validate_ExpressRouteCircuitsGet_594225(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get ExpressRouteCircuit operation retrieves information about the specified ExpressRouteCircuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   circuitName: JString (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_594227 = path.getOrDefault("circuitName")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "circuitName", valid_594227
  var valid_594228 = path.getOrDefault("resourceGroupName")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "resourceGroupName", valid_594228
  var valid_594229 = path.getOrDefault("subscriptionId")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "subscriptionId", valid_594229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_594231: Call_ExpressRouteCircuitsGet_594224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get ExpressRouteCircuit operation retrieves information about the specified ExpressRouteCircuit.
  ## 
  let valid = call_594231.validator(path, query, header, formData, body)
  let scheme = call_594231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594231.url(scheme.get, call_594231.host, call_594231.base,
                         call_594231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594231, url, valid)

proc call*(call_594232: Call_ExpressRouteCircuitsGet_594224; circuitName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteCircuitsGet
  ## The Get ExpressRouteCircuit operation retrieves information about the specified ExpressRouteCircuit.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594233 = newJObject()
  var query_594234 = newJObject()
  add(path_594233, "circuitName", newJString(circuitName))
  add(path_594233, "resourceGroupName", newJString(resourceGroupName))
  add(query_594234, "api-version", newJString(apiVersion))
  add(path_594233, "subscriptionId", newJString(subscriptionId))
  result = call_594232.call(path_594233, query_594234, nil, nil, nil)

var expressRouteCircuitsGet* = Call_ExpressRouteCircuitsGet_594224(
    name: "expressRouteCircuitsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}",
    validator: validate_ExpressRouteCircuitsGet_594225, base: "",
    url: url_ExpressRouteCircuitsGet_594226, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsDelete_594248 = ref object of OpenApiRestCall_593421
proc url_ExpressRouteCircuitsDelete_594250(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsDelete_594249(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The delete ExpressRouteCircuit operation deletes the specified ExpressRouteCircuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   circuitName: JString (required)
  ##              : The name of the express route Circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_594251 = path.getOrDefault("circuitName")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = nil)
  if valid_594251 != nil:
    section.add "circuitName", valid_594251
  var valid_594252 = path.getOrDefault("resourceGroupName")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = nil)
  if valid_594252 != nil:
    section.add "resourceGroupName", valid_594252
  var valid_594253 = path.getOrDefault("subscriptionId")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = nil)
  if valid_594253 != nil:
    section.add "subscriptionId", valid_594253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594254 = query.getOrDefault("api-version")
  valid_594254 = validateParameter(valid_594254, JString, required = true,
                                 default = nil)
  if valid_594254 != nil:
    section.add "api-version", valid_594254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594255: Call_ExpressRouteCircuitsDelete_594248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete ExpressRouteCircuit operation deletes the specified ExpressRouteCircuit.
  ## 
  let valid = call_594255.validator(path, query, header, formData, body)
  let scheme = call_594255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594255.url(scheme.get, call_594255.host, call_594255.base,
                         call_594255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594255, url, valid)

proc call*(call_594256: Call_ExpressRouteCircuitsDelete_594248;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## expressRouteCircuitsDelete
  ## The delete ExpressRouteCircuit operation deletes the specified ExpressRouteCircuit.
  ##   circuitName: string (required)
  ##              : The name of the express route Circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594257 = newJObject()
  var query_594258 = newJObject()
  add(path_594257, "circuitName", newJString(circuitName))
  add(path_594257, "resourceGroupName", newJString(resourceGroupName))
  add(query_594258, "api-version", newJString(apiVersion))
  add(path_594257, "subscriptionId", newJString(subscriptionId))
  result = call_594256.call(path_594257, query_594258, nil, nil, nil)

var expressRouteCircuitsDelete* = Call_ExpressRouteCircuitsDelete_594248(
    name: "expressRouteCircuitsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}",
    validator: validate_ExpressRouteCircuitsDelete_594249, base: "",
    url: url_ExpressRouteCircuitsDelete_594250, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsList_594259 = ref object of OpenApiRestCall_593421
proc url_ExpressRouteCircuitAuthorizationsList_594261(protocol: Scheme;
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

proc validate_ExpressRouteCircuitAuthorizationsList_594260(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List authorization operation retrieves all the authorizations in an ExpressRouteCircuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   circuitName: JString (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_594262 = path.getOrDefault("circuitName")
  valid_594262 = validateParameter(valid_594262, JString, required = true,
                                 default = nil)
  if valid_594262 != nil:
    section.add "circuitName", valid_594262
  var valid_594263 = path.getOrDefault("resourceGroupName")
  valid_594263 = validateParameter(valid_594263, JString, required = true,
                                 default = nil)
  if valid_594263 != nil:
    section.add "resourceGroupName", valid_594263
  var valid_594264 = path.getOrDefault("subscriptionId")
  valid_594264 = validateParameter(valid_594264, JString, required = true,
                                 default = nil)
  if valid_594264 != nil:
    section.add "subscriptionId", valid_594264
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594265 = query.getOrDefault("api-version")
  valid_594265 = validateParameter(valid_594265, JString, required = true,
                                 default = nil)
  if valid_594265 != nil:
    section.add "api-version", valid_594265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594266: Call_ExpressRouteCircuitAuthorizationsList_594259;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The List authorization operation retrieves all the authorizations in an ExpressRouteCircuit.
  ## 
  let valid = call_594266.validator(path, query, header, formData, body)
  let scheme = call_594266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594266.url(scheme.get, call_594266.host, call_594266.base,
                         call_594266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594266, url, valid)

proc call*(call_594267: Call_ExpressRouteCircuitAuthorizationsList_594259;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## expressRouteCircuitAuthorizationsList
  ## The List authorization operation retrieves all the authorizations in an ExpressRouteCircuit.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594268 = newJObject()
  var query_594269 = newJObject()
  add(path_594268, "circuitName", newJString(circuitName))
  add(path_594268, "resourceGroupName", newJString(resourceGroupName))
  add(query_594269, "api-version", newJString(apiVersion))
  add(path_594268, "subscriptionId", newJString(subscriptionId))
  result = call_594267.call(path_594268, query_594269, nil, nil, nil)

var expressRouteCircuitAuthorizationsList* = Call_ExpressRouteCircuitAuthorizationsList_594259(
    name: "expressRouteCircuitAuthorizationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations",
    validator: validate_ExpressRouteCircuitAuthorizationsList_594260, base: "",
    url: url_ExpressRouteCircuitAuthorizationsList_594261, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_594282 = ref object of OpenApiRestCall_593421
proc url_ExpressRouteCircuitAuthorizationsCreateOrUpdate_594284(protocol: Scheme;
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

proc validate_ExpressRouteCircuitAuthorizationsCreateOrUpdate_594283(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The Put Authorization operation creates/updates an authorization in the specified ExpressRouteCircuits
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationName: JString (required)
  ##                    : The name of the authorization.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_594285 = path.getOrDefault("circuitName")
  valid_594285 = validateParameter(valid_594285, JString, required = true,
                                 default = nil)
  if valid_594285 != nil:
    section.add "circuitName", valid_594285
  var valid_594286 = path.getOrDefault("resourceGroupName")
  valid_594286 = validateParameter(valid_594286, JString, required = true,
                                 default = nil)
  if valid_594286 != nil:
    section.add "resourceGroupName", valid_594286
  var valid_594287 = path.getOrDefault("subscriptionId")
  valid_594287 = validateParameter(valid_594287, JString, required = true,
                                 default = nil)
  if valid_594287 != nil:
    section.add "subscriptionId", valid_594287
  var valid_594288 = path.getOrDefault("authorizationName")
  valid_594288 = validateParameter(valid_594288, JString, required = true,
                                 default = nil)
  if valid_594288 != nil:
    section.add "authorizationName", valid_594288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594289 = query.getOrDefault("api-version")
  valid_594289 = validateParameter(valid_594289, JString, required = true,
                                 default = nil)
  if valid_594289 != nil:
    section.add "api-version", valid_594289
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

proc call*(call_594291: Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_594282;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put Authorization operation creates/updates an authorization in the specified ExpressRouteCircuits
  ## 
  let valid = call_594291.validator(path, query, header, formData, body)
  let scheme = call_594291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594291.url(scheme.get, call_594291.host, call_594291.base,
                         call_594291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594291, url, valid)

proc call*(call_594292: Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_594282;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; authorizationParameters: JsonNode;
          authorizationName: string): Recallable =
  ## expressRouteCircuitAuthorizationsCreateOrUpdate
  ## The Put Authorization operation creates/updates an authorization in the specified ExpressRouteCircuits
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationParameters: JObject (required)
  ##                          : Parameters supplied to the create/update ExpressRouteCircuitAuthorization operation
  ##   authorizationName: string (required)
  ##                    : The name of the authorization.
  var path_594293 = newJObject()
  var query_594294 = newJObject()
  var body_594295 = newJObject()
  add(path_594293, "circuitName", newJString(circuitName))
  add(path_594293, "resourceGroupName", newJString(resourceGroupName))
  add(query_594294, "api-version", newJString(apiVersion))
  add(path_594293, "subscriptionId", newJString(subscriptionId))
  if authorizationParameters != nil:
    body_594295 = authorizationParameters
  add(path_594293, "authorizationName", newJString(authorizationName))
  result = call_594292.call(path_594293, query_594294, nil, nil, body_594295)

var expressRouteCircuitAuthorizationsCreateOrUpdate* = Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_594282(
    name: "expressRouteCircuitAuthorizationsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations/{authorizationName}",
    validator: validate_ExpressRouteCircuitAuthorizationsCreateOrUpdate_594283,
    base: "", url: url_ExpressRouteCircuitAuthorizationsCreateOrUpdate_594284,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsGet_594270 = ref object of OpenApiRestCall_593421
proc url_ExpressRouteCircuitAuthorizationsGet_594272(protocol: Scheme;
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

proc validate_ExpressRouteCircuitAuthorizationsGet_594271(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The GET authorization operation retrieves the specified authorization from the specified ExpressRouteCircuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationName: JString (required)
  ##                    : The name of the authorization.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_594273 = path.getOrDefault("circuitName")
  valid_594273 = validateParameter(valid_594273, JString, required = true,
                                 default = nil)
  if valid_594273 != nil:
    section.add "circuitName", valid_594273
  var valid_594274 = path.getOrDefault("resourceGroupName")
  valid_594274 = validateParameter(valid_594274, JString, required = true,
                                 default = nil)
  if valid_594274 != nil:
    section.add "resourceGroupName", valid_594274
  var valid_594275 = path.getOrDefault("subscriptionId")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "subscriptionId", valid_594275
  var valid_594276 = path.getOrDefault("authorizationName")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "authorizationName", valid_594276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_594278: Call_ExpressRouteCircuitAuthorizationsGet_594270;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The GET authorization operation retrieves the specified authorization from the specified ExpressRouteCircuit.
  ## 
  let valid = call_594278.validator(path, query, header, formData, body)
  let scheme = call_594278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594278.url(scheme.get, call_594278.host, call_594278.base,
                         call_594278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594278, url, valid)

proc call*(call_594279: Call_ExpressRouteCircuitAuthorizationsGet_594270;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; authorizationName: string): Recallable =
  ## expressRouteCircuitAuthorizationsGet
  ## The GET authorization operation retrieves the specified authorization from the specified ExpressRouteCircuit.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationName: string (required)
  ##                    : The name of the authorization.
  var path_594280 = newJObject()
  var query_594281 = newJObject()
  add(path_594280, "circuitName", newJString(circuitName))
  add(path_594280, "resourceGroupName", newJString(resourceGroupName))
  add(query_594281, "api-version", newJString(apiVersion))
  add(path_594280, "subscriptionId", newJString(subscriptionId))
  add(path_594280, "authorizationName", newJString(authorizationName))
  result = call_594279.call(path_594280, query_594281, nil, nil, nil)

var expressRouteCircuitAuthorizationsGet* = Call_ExpressRouteCircuitAuthorizationsGet_594270(
    name: "expressRouteCircuitAuthorizationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations/{authorizationName}",
    validator: validate_ExpressRouteCircuitAuthorizationsGet_594271, base: "",
    url: url_ExpressRouteCircuitAuthorizationsGet_594272, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsDelete_594296 = ref object of OpenApiRestCall_593421
proc url_ExpressRouteCircuitAuthorizationsDelete_594298(protocol: Scheme;
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

proc validate_ExpressRouteCircuitAuthorizationsDelete_594297(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The delete authorization operation deletes the specified authorization from the specified ExpressRouteCircuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationName: JString (required)
  ##                    : The name of the authorization.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_594299 = path.getOrDefault("circuitName")
  valid_594299 = validateParameter(valid_594299, JString, required = true,
                                 default = nil)
  if valid_594299 != nil:
    section.add "circuitName", valid_594299
  var valid_594300 = path.getOrDefault("resourceGroupName")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "resourceGroupName", valid_594300
  var valid_594301 = path.getOrDefault("subscriptionId")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "subscriptionId", valid_594301
  var valid_594302 = path.getOrDefault("authorizationName")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "authorizationName", valid_594302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594303 = query.getOrDefault("api-version")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "api-version", valid_594303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594304: Call_ExpressRouteCircuitAuthorizationsDelete_594296;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The delete authorization operation deletes the specified authorization from the specified ExpressRouteCircuit.
  ## 
  let valid = call_594304.validator(path, query, header, formData, body)
  let scheme = call_594304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594304.url(scheme.get, call_594304.host, call_594304.base,
                         call_594304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594304, url, valid)

proc call*(call_594305: Call_ExpressRouteCircuitAuthorizationsDelete_594296;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; authorizationName: string): Recallable =
  ## expressRouteCircuitAuthorizationsDelete
  ## The delete authorization operation deletes the specified authorization from the specified ExpressRouteCircuit.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationName: string (required)
  ##                    : The name of the authorization.
  var path_594306 = newJObject()
  var query_594307 = newJObject()
  add(path_594306, "circuitName", newJString(circuitName))
  add(path_594306, "resourceGroupName", newJString(resourceGroupName))
  add(query_594307, "api-version", newJString(apiVersion))
  add(path_594306, "subscriptionId", newJString(subscriptionId))
  add(path_594306, "authorizationName", newJString(authorizationName))
  result = call_594305.call(path_594306, query_594307, nil, nil, nil)

var expressRouteCircuitAuthorizationsDelete* = Call_ExpressRouteCircuitAuthorizationsDelete_594296(
    name: "expressRouteCircuitAuthorizationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations/{authorizationName}",
    validator: validate_ExpressRouteCircuitAuthorizationsDelete_594297, base: "",
    url: url_ExpressRouteCircuitAuthorizationsDelete_594298,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsList_594308 = ref object of OpenApiRestCall_593421
proc url_ExpressRouteCircuitPeeringsList_594310(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitPeeringsList_594309(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List peering operation retrieves all the peerings in an ExpressRouteCircuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   circuitName: JString (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_594311 = path.getOrDefault("circuitName")
  valid_594311 = validateParameter(valid_594311, JString, required = true,
                                 default = nil)
  if valid_594311 != nil:
    section.add "circuitName", valid_594311
  var valid_594312 = path.getOrDefault("resourceGroupName")
  valid_594312 = validateParameter(valid_594312, JString, required = true,
                                 default = nil)
  if valid_594312 != nil:
    section.add "resourceGroupName", valid_594312
  var valid_594313 = path.getOrDefault("subscriptionId")
  valid_594313 = validateParameter(valid_594313, JString, required = true,
                                 default = nil)
  if valid_594313 != nil:
    section.add "subscriptionId", valid_594313
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594314 = query.getOrDefault("api-version")
  valid_594314 = validateParameter(valid_594314, JString, required = true,
                                 default = nil)
  if valid_594314 != nil:
    section.add "api-version", valid_594314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594315: Call_ExpressRouteCircuitPeeringsList_594308;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The List peering operation retrieves all the peerings in an ExpressRouteCircuit.
  ## 
  let valid = call_594315.validator(path, query, header, formData, body)
  let scheme = call_594315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594315.url(scheme.get, call_594315.host, call_594315.base,
                         call_594315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594315, url, valid)

proc call*(call_594316: Call_ExpressRouteCircuitPeeringsList_594308;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## expressRouteCircuitPeeringsList
  ## The List peering operation retrieves all the peerings in an ExpressRouteCircuit.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594317 = newJObject()
  var query_594318 = newJObject()
  add(path_594317, "circuitName", newJString(circuitName))
  add(path_594317, "resourceGroupName", newJString(resourceGroupName))
  add(query_594318, "api-version", newJString(apiVersion))
  add(path_594317, "subscriptionId", newJString(subscriptionId))
  result = call_594316.call(path_594317, query_594318, nil, nil, nil)

var expressRouteCircuitPeeringsList* = Call_ExpressRouteCircuitPeeringsList_594308(
    name: "expressRouteCircuitPeeringsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings",
    validator: validate_ExpressRouteCircuitPeeringsList_594309, base: "",
    url: url_ExpressRouteCircuitPeeringsList_594310, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsCreateOrUpdate_594331 = ref object of OpenApiRestCall_593421
proc url_ExpressRouteCircuitPeeringsCreateOrUpdate_594333(protocol: Scheme;
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

proc validate_ExpressRouteCircuitPeeringsCreateOrUpdate_594332(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put Peering operation creates/updates an peering in the specified ExpressRouteCircuits
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_594334 = path.getOrDefault("circuitName")
  valid_594334 = validateParameter(valid_594334, JString, required = true,
                                 default = nil)
  if valid_594334 != nil:
    section.add "circuitName", valid_594334
  var valid_594335 = path.getOrDefault("resourceGroupName")
  valid_594335 = validateParameter(valid_594335, JString, required = true,
                                 default = nil)
  if valid_594335 != nil:
    section.add "resourceGroupName", valid_594335
  var valid_594336 = path.getOrDefault("peeringName")
  valid_594336 = validateParameter(valid_594336, JString, required = true,
                                 default = nil)
  if valid_594336 != nil:
    section.add "peeringName", valid_594336
  var valid_594337 = path.getOrDefault("subscriptionId")
  valid_594337 = validateParameter(valid_594337, JString, required = true,
                                 default = nil)
  if valid_594337 != nil:
    section.add "subscriptionId", valid_594337
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594338 = query.getOrDefault("api-version")
  valid_594338 = validateParameter(valid_594338, JString, required = true,
                                 default = nil)
  if valid_594338 != nil:
    section.add "api-version", valid_594338
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

proc call*(call_594340: Call_ExpressRouteCircuitPeeringsCreateOrUpdate_594331;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put Peering operation creates/updates an peering in the specified ExpressRouteCircuits
  ## 
  let valid = call_594340.validator(path, query, header, formData, body)
  let scheme = call_594340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594340.url(scheme.get, call_594340.host, call_594340.base,
                         call_594340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594340, url, valid)

proc call*(call_594341: Call_ExpressRouteCircuitPeeringsCreateOrUpdate_594331;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          peeringName: string; subscriptionId: string; peeringParameters: JsonNode): Recallable =
  ## expressRouteCircuitPeeringsCreateOrUpdate
  ## The Put Peering operation creates/updates an peering in the specified ExpressRouteCircuits
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   peeringParameters: JObject (required)
  ##                    : Parameters supplied to the create/update ExpressRouteCircuit Peering operation
  var path_594342 = newJObject()
  var query_594343 = newJObject()
  var body_594344 = newJObject()
  add(path_594342, "circuitName", newJString(circuitName))
  add(path_594342, "resourceGroupName", newJString(resourceGroupName))
  add(query_594343, "api-version", newJString(apiVersion))
  add(path_594342, "peeringName", newJString(peeringName))
  add(path_594342, "subscriptionId", newJString(subscriptionId))
  if peeringParameters != nil:
    body_594344 = peeringParameters
  result = call_594341.call(path_594342, query_594343, nil, nil, body_594344)

var expressRouteCircuitPeeringsCreateOrUpdate* = Call_ExpressRouteCircuitPeeringsCreateOrUpdate_594331(
    name: "expressRouteCircuitPeeringsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCircuitPeeringsCreateOrUpdate_594332,
    base: "", url: url_ExpressRouteCircuitPeeringsCreateOrUpdate_594333,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsGet_594319 = ref object of OpenApiRestCall_593421
proc url_ExpressRouteCircuitPeeringsGet_594321(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitPeeringsGet_594320(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The GET peering operation retrieves the specified authorization from the ExpressRouteCircuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_594322 = path.getOrDefault("circuitName")
  valid_594322 = validateParameter(valid_594322, JString, required = true,
                                 default = nil)
  if valid_594322 != nil:
    section.add "circuitName", valid_594322
  var valid_594323 = path.getOrDefault("resourceGroupName")
  valid_594323 = validateParameter(valid_594323, JString, required = true,
                                 default = nil)
  if valid_594323 != nil:
    section.add "resourceGroupName", valid_594323
  var valid_594324 = path.getOrDefault("peeringName")
  valid_594324 = validateParameter(valid_594324, JString, required = true,
                                 default = nil)
  if valid_594324 != nil:
    section.add "peeringName", valid_594324
  var valid_594325 = path.getOrDefault("subscriptionId")
  valid_594325 = validateParameter(valid_594325, JString, required = true,
                                 default = nil)
  if valid_594325 != nil:
    section.add "subscriptionId", valid_594325
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594326 = query.getOrDefault("api-version")
  valid_594326 = validateParameter(valid_594326, JString, required = true,
                                 default = nil)
  if valid_594326 != nil:
    section.add "api-version", valid_594326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594327: Call_ExpressRouteCircuitPeeringsGet_594319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GET peering operation retrieves the specified authorization from the ExpressRouteCircuit.
  ## 
  let valid = call_594327.validator(path, query, header, formData, body)
  let scheme = call_594327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594327.url(scheme.get, call_594327.host, call_594327.base,
                         call_594327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594327, url, valid)

proc call*(call_594328: Call_ExpressRouteCircuitPeeringsGet_594319;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          peeringName: string; subscriptionId: string): Recallable =
  ## expressRouteCircuitPeeringsGet
  ## The GET peering operation retrieves the specified authorization from the ExpressRouteCircuit.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594329 = newJObject()
  var query_594330 = newJObject()
  add(path_594329, "circuitName", newJString(circuitName))
  add(path_594329, "resourceGroupName", newJString(resourceGroupName))
  add(query_594330, "api-version", newJString(apiVersion))
  add(path_594329, "peeringName", newJString(peeringName))
  add(path_594329, "subscriptionId", newJString(subscriptionId))
  result = call_594328.call(path_594329, query_594330, nil, nil, nil)

var expressRouteCircuitPeeringsGet* = Call_ExpressRouteCircuitPeeringsGet_594319(
    name: "expressRouteCircuitPeeringsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCircuitPeeringsGet_594320, base: "",
    url: url_ExpressRouteCircuitPeeringsGet_594321, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsDelete_594345 = ref object of OpenApiRestCall_593421
proc url_ExpressRouteCircuitPeeringsDelete_594347(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitPeeringsDelete_594346(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The delete peering operation deletes the specified peering from the ExpressRouteCircuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_594348 = path.getOrDefault("circuitName")
  valid_594348 = validateParameter(valid_594348, JString, required = true,
                                 default = nil)
  if valid_594348 != nil:
    section.add "circuitName", valid_594348
  var valid_594349 = path.getOrDefault("resourceGroupName")
  valid_594349 = validateParameter(valid_594349, JString, required = true,
                                 default = nil)
  if valid_594349 != nil:
    section.add "resourceGroupName", valid_594349
  var valid_594350 = path.getOrDefault("peeringName")
  valid_594350 = validateParameter(valid_594350, JString, required = true,
                                 default = nil)
  if valid_594350 != nil:
    section.add "peeringName", valid_594350
  var valid_594351 = path.getOrDefault("subscriptionId")
  valid_594351 = validateParameter(valid_594351, JString, required = true,
                                 default = nil)
  if valid_594351 != nil:
    section.add "subscriptionId", valid_594351
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594352 = query.getOrDefault("api-version")
  valid_594352 = validateParameter(valid_594352, JString, required = true,
                                 default = nil)
  if valid_594352 != nil:
    section.add "api-version", valid_594352
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594353: Call_ExpressRouteCircuitPeeringsDelete_594345;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The delete peering operation deletes the specified peering from the ExpressRouteCircuit.
  ## 
  let valid = call_594353.validator(path, query, header, formData, body)
  let scheme = call_594353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594353.url(scheme.get, call_594353.host, call_594353.base,
                         call_594353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594353, url, valid)

proc call*(call_594354: Call_ExpressRouteCircuitPeeringsDelete_594345;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          peeringName: string; subscriptionId: string): Recallable =
  ## expressRouteCircuitPeeringsDelete
  ## The delete peering operation deletes the specified peering from the ExpressRouteCircuit.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594355 = newJObject()
  var query_594356 = newJObject()
  add(path_594355, "circuitName", newJString(circuitName))
  add(path_594355, "resourceGroupName", newJString(resourceGroupName))
  add(query_594356, "api-version", newJString(apiVersion))
  add(path_594355, "peeringName", newJString(peeringName))
  add(path_594355, "subscriptionId", newJString(subscriptionId))
  result = call_594354.call(path_594355, query_594356, nil, nil, nil)

var expressRouteCircuitPeeringsDelete* = Call_ExpressRouteCircuitPeeringsDelete_594345(
    name: "expressRouteCircuitPeeringsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCircuitPeeringsDelete_594346, base: "",
    url: url_ExpressRouteCircuitPeeringsDelete_594347, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsListArpTable_594357 = ref object of OpenApiRestCall_593421
proc url_ExpressRouteCircuitsListArpTable_594359(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsListArpTable_594358(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The ListArpTable from ExpressRouteCircuit operation retrieves the currently advertised arp table associated with the ExpressRouteCircuits in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   circuitName: JString (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   devicePath: JString (required)
  ##             : The path of the device.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_594360 = path.getOrDefault("circuitName")
  valid_594360 = validateParameter(valid_594360, JString, required = true,
                                 default = nil)
  if valid_594360 != nil:
    section.add "circuitName", valid_594360
  var valid_594361 = path.getOrDefault("resourceGroupName")
  valid_594361 = validateParameter(valid_594361, JString, required = true,
                                 default = nil)
  if valid_594361 != nil:
    section.add "resourceGroupName", valid_594361
  var valid_594362 = path.getOrDefault("peeringName")
  valid_594362 = validateParameter(valid_594362, JString, required = true,
                                 default = nil)
  if valid_594362 != nil:
    section.add "peeringName", valid_594362
  var valid_594363 = path.getOrDefault("subscriptionId")
  valid_594363 = validateParameter(valid_594363, JString, required = true,
                                 default = nil)
  if valid_594363 != nil:
    section.add "subscriptionId", valid_594363
  var valid_594364 = path.getOrDefault("devicePath")
  valid_594364 = validateParameter(valid_594364, JString, required = true,
                                 default = nil)
  if valid_594364 != nil:
    section.add "devicePath", valid_594364
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594365 = query.getOrDefault("api-version")
  valid_594365 = validateParameter(valid_594365, JString, required = true,
                                 default = nil)
  if valid_594365 != nil:
    section.add "api-version", valid_594365
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594366: Call_ExpressRouteCircuitsListArpTable_594357;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The ListArpTable from ExpressRouteCircuit operation retrieves the currently advertised arp table associated with the ExpressRouteCircuits in a resource group.
  ## 
  let valid = call_594366.validator(path, query, header, formData, body)
  let scheme = call_594366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594366.url(scheme.get, call_594366.host, call_594366.base,
                         call_594366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594366, url, valid)

proc call*(call_594367: Call_ExpressRouteCircuitsListArpTable_594357;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          peeringName: string; subscriptionId: string; devicePath: string): Recallable =
  ## expressRouteCircuitsListArpTable
  ## The ListArpTable from ExpressRouteCircuit operation retrieves the currently advertised arp table associated with the ExpressRouteCircuits in a resource group.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   devicePath: string (required)
  ##             : The path of the device.
  var path_594368 = newJObject()
  var query_594369 = newJObject()
  add(path_594368, "circuitName", newJString(circuitName))
  add(path_594368, "resourceGroupName", newJString(resourceGroupName))
  add(query_594369, "api-version", newJString(apiVersion))
  add(path_594368, "peeringName", newJString(peeringName))
  add(path_594368, "subscriptionId", newJString(subscriptionId))
  add(path_594368, "devicePath", newJString(devicePath))
  result = call_594367.call(path_594368, query_594369, nil, nil, nil)

var expressRouteCircuitsListArpTable* = Call_ExpressRouteCircuitsListArpTable_594357(
    name: "expressRouteCircuitsListArpTable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/arpTables/{devicePath}",
    validator: validate_ExpressRouteCircuitsListArpTable_594358, base: "",
    url: url_ExpressRouteCircuitsListArpTable_594359, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsListRoutesTable_594370 = ref object of OpenApiRestCall_593421
proc url_ExpressRouteCircuitsListRoutesTable_594372(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsListRoutesTable_594371(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The ListRoutesTable from ExpressRouteCircuit operation retrieves the currently advertised routes table associated with the ExpressRouteCircuits in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   circuitName: JString (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   devicePath: JString (required)
  ##             : The path of the device.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_594373 = path.getOrDefault("circuitName")
  valid_594373 = validateParameter(valid_594373, JString, required = true,
                                 default = nil)
  if valid_594373 != nil:
    section.add "circuitName", valid_594373
  var valid_594374 = path.getOrDefault("resourceGroupName")
  valid_594374 = validateParameter(valid_594374, JString, required = true,
                                 default = nil)
  if valid_594374 != nil:
    section.add "resourceGroupName", valid_594374
  var valid_594375 = path.getOrDefault("peeringName")
  valid_594375 = validateParameter(valid_594375, JString, required = true,
                                 default = nil)
  if valid_594375 != nil:
    section.add "peeringName", valid_594375
  var valid_594376 = path.getOrDefault("subscriptionId")
  valid_594376 = validateParameter(valid_594376, JString, required = true,
                                 default = nil)
  if valid_594376 != nil:
    section.add "subscriptionId", valid_594376
  var valid_594377 = path.getOrDefault("devicePath")
  valid_594377 = validateParameter(valid_594377, JString, required = true,
                                 default = nil)
  if valid_594377 != nil:
    section.add "devicePath", valid_594377
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594378 = query.getOrDefault("api-version")
  valid_594378 = validateParameter(valid_594378, JString, required = true,
                                 default = nil)
  if valid_594378 != nil:
    section.add "api-version", valid_594378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594379: Call_ExpressRouteCircuitsListRoutesTable_594370;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The ListRoutesTable from ExpressRouteCircuit operation retrieves the currently advertised routes table associated with the ExpressRouteCircuits in a resource group.
  ## 
  let valid = call_594379.validator(path, query, header, formData, body)
  let scheme = call_594379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594379.url(scheme.get, call_594379.host, call_594379.base,
                         call_594379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594379, url, valid)

proc call*(call_594380: Call_ExpressRouteCircuitsListRoutesTable_594370;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          peeringName: string; subscriptionId: string; devicePath: string): Recallable =
  ## expressRouteCircuitsListRoutesTable
  ## The ListRoutesTable from ExpressRouteCircuit operation retrieves the currently advertised routes table associated with the ExpressRouteCircuits in a resource group.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   devicePath: string (required)
  ##             : The path of the device.
  var path_594381 = newJObject()
  var query_594382 = newJObject()
  add(path_594381, "circuitName", newJString(circuitName))
  add(path_594381, "resourceGroupName", newJString(resourceGroupName))
  add(query_594382, "api-version", newJString(apiVersion))
  add(path_594381, "peeringName", newJString(peeringName))
  add(path_594381, "subscriptionId", newJString(subscriptionId))
  add(path_594381, "devicePath", newJString(devicePath))
  result = call_594380.call(path_594381, query_594382, nil, nil, nil)

var expressRouteCircuitsListRoutesTable* = Call_ExpressRouteCircuitsListRoutesTable_594370(
    name: "expressRouteCircuitsListRoutesTable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/routeTables/{devicePath}",
    validator: validate_ExpressRouteCircuitsListRoutesTable_594371, base: "",
    url: url_ExpressRouteCircuitsListRoutesTable_594372, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsListRoutesTableSummary_594383 = ref object of OpenApiRestCall_593421
proc url_ExpressRouteCircuitsListRoutesTableSummary_594385(protocol: Scheme;
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

proc validate_ExpressRouteCircuitsListRoutesTableSummary_594384(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The ListRoutesTable from ExpressRouteCircuit operation retrieves the currently advertised routes table associated with the ExpressRouteCircuits in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   circuitName: JString (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   devicePath: JString (required)
  ##             : The path of the device.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_594386 = path.getOrDefault("circuitName")
  valid_594386 = validateParameter(valid_594386, JString, required = true,
                                 default = nil)
  if valid_594386 != nil:
    section.add "circuitName", valid_594386
  var valid_594387 = path.getOrDefault("resourceGroupName")
  valid_594387 = validateParameter(valid_594387, JString, required = true,
                                 default = nil)
  if valid_594387 != nil:
    section.add "resourceGroupName", valid_594387
  var valid_594388 = path.getOrDefault("peeringName")
  valid_594388 = validateParameter(valid_594388, JString, required = true,
                                 default = nil)
  if valid_594388 != nil:
    section.add "peeringName", valid_594388
  var valid_594389 = path.getOrDefault("subscriptionId")
  valid_594389 = validateParameter(valid_594389, JString, required = true,
                                 default = nil)
  if valid_594389 != nil:
    section.add "subscriptionId", valid_594389
  var valid_594390 = path.getOrDefault("devicePath")
  valid_594390 = validateParameter(valid_594390, JString, required = true,
                                 default = nil)
  if valid_594390 != nil:
    section.add "devicePath", valid_594390
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594391 = query.getOrDefault("api-version")
  valid_594391 = validateParameter(valid_594391, JString, required = true,
                                 default = nil)
  if valid_594391 != nil:
    section.add "api-version", valid_594391
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594392: Call_ExpressRouteCircuitsListRoutesTableSummary_594383;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The ListRoutesTable from ExpressRouteCircuit operation retrieves the currently advertised routes table associated with the ExpressRouteCircuits in a resource group.
  ## 
  let valid = call_594392.validator(path, query, header, formData, body)
  let scheme = call_594392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594392.url(scheme.get, call_594392.host, call_594392.base,
                         call_594392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594392, url, valid)

proc call*(call_594393: Call_ExpressRouteCircuitsListRoutesTableSummary_594383;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          peeringName: string; subscriptionId: string; devicePath: string): Recallable =
  ## expressRouteCircuitsListRoutesTableSummary
  ## The ListRoutesTable from ExpressRouteCircuit operation retrieves the currently advertised routes table associated with the ExpressRouteCircuits in a resource group.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   devicePath: string (required)
  ##             : The path of the device.
  var path_594394 = newJObject()
  var query_594395 = newJObject()
  add(path_594394, "circuitName", newJString(circuitName))
  add(path_594394, "resourceGroupName", newJString(resourceGroupName))
  add(query_594395, "api-version", newJString(apiVersion))
  add(path_594394, "peeringName", newJString(peeringName))
  add(path_594394, "subscriptionId", newJString(subscriptionId))
  add(path_594394, "devicePath", newJString(devicePath))
  result = call_594393.call(path_594394, query_594395, nil, nil, nil)

var expressRouteCircuitsListRoutesTableSummary* = Call_ExpressRouteCircuitsListRoutesTableSummary_594383(
    name: "expressRouteCircuitsListRoutesTableSummary", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/routeTablesSummary/{devicePath}",
    validator: validate_ExpressRouteCircuitsListRoutesTableSummary_594384,
    base: "", url: url_ExpressRouteCircuitsListRoutesTableSummary_594385,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsGetPeeringStats_594396 = ref object of OpenApiRestCall_593421
proc url_ExpressRouteCircuitsGetPeeringStats_594398(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsGetPeeringStats_594397(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List stats ExpressRouteCircuit operation retrieves all the stats from a ExpressRouteCircuits in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   circuitName: JString (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_594399 = path.getOrDefault("circuitName")
  valid_594399 = validateParameter(valid_594399, JString, required = true,
                                 default = nil)
  if valid_594399 != nil:
    section.add "circuitName", valid_594399
  var valid_594400 = path.getOrDefault("resourceGroupName")
  valid_594400 = validateParameter(valid_594400, JString, required = true,
                                 default = nil)
  if valid_594400 != nil:
    section.add "resourceGroupName", valid_594400
  var valid_594401 = path.getOrDefault("peeringName")
  valid_594401 = validateParameter(valid_594401, JString, required = true,
                                 default = nil)
  if valid_594401 != nil:
    section.add "peeringName", valid_594401
  var valid_594402 = path.getOrDefault("subscriptionId")
  valid_594402 = validateParameter(valid_594402, JString, required = true,
                                 default = nil)
  if valid_594402 != nil:
    section.add "subscriptionId", valid_594402
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594403 = query.getOrDefault("api-version")
  valid_594403 = validateParameter(valid_594403, JString, required = true,
                                 default = nil)
  if valid_594403 != nil:
    section.add "api-version", valid_594403
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594404: Call_ExpressRouteCircuitsGetPeeringStats_594396;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The List stats ExpressRouteCircuit operation retrieves all the stats from a ExpressRouteCircuits in a resource group.
  ## 
  let valid = call_594404.validator(path, query, header, formData, body)
  let scheme = call_594404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594404.url(scheme.get, call_594404.host, call_594404.base,
                         call_594404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594404, url, valid)

proc call*(call_594405: Call_ExpressRouteCircuitsGetPeeringStats_594396;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          peeringName: string; subscriptionId: string): Recallable =
  ## expressRouteCircuitsGetPeeringStats
  ## The List stats ExpressRouteCircuit operation retrieves all the stats from a ExpressRouteCircuits in a resource group.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594406 = newJObject()
  var query_594407 = newJObject()
  add(path_594406, "circuitName", newJString(circuitName))
  add(path_594406, "resourceGroupName", newJString(resourceGroupName))
  add(query_594407, "api-version", newJString(apiVersion))
  add(path_594406, "peeringName", newJString(peeringName))
  add(path_594406, "subscriptionId", newJString(subscriptionId))
  result = call_594405.call(path_594406, query_594407, nil, nil, nil)

var expressRouteCircuitsGetPeeringStats* = Call_ExpressRouteCircuitsGetPeeringStats_594396(
    name: "expressRouteCircuitsGetPeeringStats", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/stats",
    validator: validate_ExpressRouteCircuitsGetPeeringStats_594397, base: "",
    url: url_ExpressRouteCircuitsGetPeeringStats_594398, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsGetStats_594408 = ref object of OpenApiRestCall_593421
proc url_ExpressRouteCircuitsGetStats_594410(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsGetStats_594409(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List stats ExpressRouteCircuit operation retrieves all the stats from a ExpressRouteCircuits in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   circuitName: JString (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_594411 = path.getOrDefault("circuitName")
  valid_594411 = validateParameter(valid_594411, JString, required = true,
                                 default = nil)
  if valid_594411 != nil:
    section.add "circuitName", valid_594411
  var valid_594412 = path.getOrDefault("resourceGroupName")
  valid_594412 = validateParameter(valid_594412, JString, required = true,
                                 default = nil)
  if valid_594412 != nil:
    section.add "resourceGroupName", valid_594412
  var valid_594413 = path.getOrDefault("subscriptionId")
  valid_594413 = validateParameter(valid_594413, JString, required = true,
                                 default = nil)
  if valid_594413 != nil:
    section.add "subscriptionId", valid_594413
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594414 = query.getOrDefault("api-version")
  valid_594414 = validateParameter(valid_594414, JString, required = true,
                                 default = nil)
  if valid_594414 != nil:
    section.add "api-version", valid_594414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594415: Call_ExpressRouteCircuitsGetStats_594408; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List stats ExpressRouteCircuit operation retrieves all the stats from a ExpressRouteCircuits in a resource group.
  ## 
  let valid = call_594415.validator(path, query, header, formData, body)
  let scheme = call_594415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594415.url(scheme.get, call_594415.host, call_594415.base,
                         call_594415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594415, url, valid)

proc call*(call_594416: Call_ExpressRouteCircuitsGetStats_594408;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## expressRouteCircuitsGetStats
  ## The List stats ExpressRouteCircuit operation retrieves all the stats from a ExpressRouteCircuits in a resource group.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594417 = newJObject()
  var query_594418 = newJObject()
  add(path_594417, "circuitName", newJString(circuitName))
  add(path_594417, "resourceGroupName", newJString(resourceGroupName))
  add(query_594418, "api-version", newJString(apiVersion))
  add(path_594417, "subscriptionId", newJString(subscriptionId))
  result = call_594416.call(path_594417, query_594418, nil, nil, nil)

var expressRouteCircuitsGetStats* = Call_ExpressRouteCircuitsGetStats_594408(
    name: "expressRouteCircuitsGetStats", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/stats",
    validator: validate_ExpressRouteCircuitsGetStats_594409, base: "",
    url: url_ExpressRouteCircuitsGetStats_594410, schemes: {Scheme.Https})
type
  Call_LoadBalancersList_594419 = ref object of OpenApiRestCall_593421
proc url_LoadBalancersList_594421(protocol: Scheme; host: string; base: string;
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

proc validate_LoadBalancersList_594420(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## The List loadBalancer operation retrieves all the load balancers in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594422 = path.getOrDefault("resourceGroupName")
  valid_594422 = validateParameter(valid_594422, JString, required = true,
                                 default = nil)
  if valid_594422 != nil:
    section.add "resourceGroupName", valid_594422
  var valid_594423 = path.getOrDefault("subscriptionId")
  valid_594423 = validateParameter(valid_594423, JString, required = true,
                                 default = nil)
  if valid_594423 != nil:
    section.add "subscriptionId", valid_594423
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594424 = query.getOrDefault("api-version")
  valid_594424 = validateParameter(valid_594424, JString, required = true,
                                 default = nil)
  if valid_594424 != nil:
    section.add "api-version", valid_594424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594425: Call_LoadBalancersList_594419; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List loadBalancer operation retrieves all the load balancers in a resource group.
  ## 
  let valid = call_594425.validator(path, query, header, formData, body)
  let scheme = call_594425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594425.url(scheme.get, call_594425.host, call_594425.base,
                         call_594425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594425, url, valid)

proc call*(call_594426: Call_LoadBalancersList_594419; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## loadBalancersList
  ## The List loadBalancer operation retrieves all the load balancers in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594427 = newJObject()
  var query_594428 = newJObject()
  add(path_594427, "resourceGroupName", newJString(resourceGroupName))
  add(query_594428, "api-version", newJString(apiVersion))
  add(path_594427, "subscriptionId", newJString(subscriptionId))
  result = call_594426.call(path_594427, query_594428, nil, nil, nil)

var loadBalancersList* = Call_LoadBalancersList_594419(name: "loadBalancersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers",
    validator: validate_LoadBalancersList_594420, base: "",
    url: url_LoadBalancersList_594421, schemes: {Scheme.Https})
type
  Call_LoadBalancersCreateOrUpdate_594442 = ref object of OpenApiRestCall_593421
proc url_LoadBalancersCreateOrUpdate_594444(protocol: Scheme; host: string;
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

proc validate_LoadBalancersCreateOrUpdate_594443(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put LoadBalancer operation creates/updates a LoadBalancer
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   loadBalancerName: JString (required)
  ##                   : The name of the loadBalancer.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594445 = path.getOrDefault("resourceGroupName")
  valid_594445 = validateParameter(valid_594445, JString, required = true,
                                 default = nil)
  if valid_594445 != nil:
    section.add "resourceGroupName", valid_594445
  var valid_594446 = path.getOrDefault("loadBalancerName")
  valid_594446 = validateParameter(valid_594446, JString, required = true,
                                 default = nil)
  if valid_594446 != nil:
    section.add "loadBalancerName", valid_594446
  var valid_594447 = path.getOrDefault("subscriptionId")
  valid_594447 = validateParameter(valid_594447, JString, required = true,
                                 default = nil)
  if valid_594447 != nil:
    section.add "subscriptionId", valid_594447
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594448 = query.getOrDefault("api-version")
  valid_594448 = validateParameter(valid_594448, JString, required = true,
                                 default = nil)
  if valid_594448 != nil:
    section.add "api-version", valid_594448
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

proc call*(call_594450: Call_LoadBalancersCreateOrUpdate_594442; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put LoadBalancer operation creates/updates a LoadBalancer
  ## 
  let valid = call_594450.validator(path, query, header, formData, body)
  let scheme = call_594450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594450.url(scheme.get, call_594450.host, call_594450.base,
                         call_594450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594450, url, valid)

proc call*(call_594451: Call_LoadBalancersCreateOrUpdate_594442;
          resourceGroupName: string; apiVersion: string; loadBalancerName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## loadBalancersCreateOrUpdate
  ## The Put LoadBalancer operation creates/updates a LoadBalancer
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   loadBalancerName: string (required)
  ##                   : The name of the loadBalancer.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/delete LoadBalancer operation
  var path_594452 = newJObject()
  var query_594453 = newJObject()
  var body_594454 = newJObject()
  add(path_594452, "resourceGroupName", newJString(resourceGroupName))
  add(query_594453, "api-version", newJString(apiVersion))
  add(path_594452, "loadBalancerName", newJString(loadBalancerName))
  add(path_594452, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594454 = parameters
  result = call_594451.call(path_594452, query_594453, nil, nil, body_594454)

var loadBalancersCreateOrUpdate* = Call_LoadBalancersCreateOrUpdate_594442(
    name: "loadBalancersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}",
    validator: validate_LoadBalancersCreateOrUpdate_594443, base: "",
    url: url_LoadBalancersCreateOrUpdate_594444, schemes: {Scheme.Https})
type
  Call_LoadBalancersGet_594429 = ref object of OpenApiRestCall_593421
proc url_LoadBalancersGet_594431(protocol: Scheme; host: string; base: string;
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

proc validate_LoadBalancersGet_594430(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## The Get LoadBalancer operation retrieves information about the specified LoadBalancer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   loadBalancerName: JString (required)
  ##                   : The name of the loadBalancer.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594433 = path.getOrDefault("resourceGroupName")
  valid_594433 = validateParameter(valid_594433, JString, required = true,
                                 default = nil)
  if valid_594433 != nil:
    section.add "resourceGroupName", valid_594433
  var valid_594434 = path.getOrDefault("loadBalancerName")
  valid_594434 = validateParameter(valid_594434, JString, required = true,
                                 default = nil)
  if valid_594434 != nil:
    section.add "loadBalancerName", valid_594434
  var valid_594435 = path.getOrDefault("subscriptionId")
  valid_594435 = validateParameter(valid_594435, JString, required = true,
                                 default = nil)
  if valid_594435 != nil:
    section.add "subscriptionId", valid_594435
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594436 = query.getOrDefault("api-version")
  valid_594436 = validateParameter(valid_594436, JString, required = true,
                                 default = nil)
  if valid_594436 != nil:
    section.add "api-version", valid_594436
  var valid_594437 = query.getOrDefault("$expand")
  valid_594437 = validateParameter(valid_594437, JString, required = false,
                                 default = nil)
  if valid_594437 != nil:
    section.add "$expand", valid_594437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594438: Call_LoadBalancersGet_594429; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get LoadBalancer operation retrieves information about the specified LoadBalancer.
  ## 
  let valid = call_594438.validator(path, query, header, formData, body)
  let scheme = call_594438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594438.url(scheme.get, call_594438.host, call_594438.base,
                         call_594438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594438, url, valid)

proc call*(call_594439: Call_LoadBalancersGet_594429; resourceGroupName: string;
          apiVersion: string; loadBalancerName: string; subscriptionId: string;
          Expand: string = ""): Recallable =
  ## loadBalancersGet
  ## The Get LoadBalancer operation retrieves information about the specified LoadBalancer.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : expand references resources.
  ##   loadBalancerName: string (required)
  ##                   : The name of the loadBalancer.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594440 = newJObject()
  var query_594441 = newJObject()
  add(path_594440, "resourceGroupName", newJString(resourceGroupName))
  add(query_594441, "api-version", newJString(apiVersion))
  add(query_594441, "$expand", newJString(Expand))
  add(path_594440, "loadBalancerName", newJString(loadBalancerName))
  add(path_594440, "subscriptionId", newJString(subscriptionId))
  result = call_594439.call(path_594440, query_594441, nil, nil, nil)

var loadBalancersGet* = Call_LoadBalancersGet_594429(name: "loadBalancersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}",
    validator: validate_LoadBalancersGet_594430, base: "",
    url: url_LoadBalancersGet_594431, schemes: {Scheme.Https})
type
  Call_LoadBalancersDelete_594455 = ref object of OpenApiRestCall_593421
proc url_LoadBalancersDelete_594457(protocol: Scheme; host: string; base: string;
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

proc validate_LoadBalancersDelete_594456(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## The delete LoadBalancer operation deletes the specified load balancer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   loadBalancerName: JString (required)
  ##                   : The name of the loadBalancer.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594458 = path.getOrDefault("resourceGroupName")
  valid_594458 = validateParameter(valid_594458, JString, required = true,
                                 default = nil)
  if valid_594458 != nil:
    section.add "resourceGroupName", valid_594458
  var valid_594459 = path.getOrDefault("loadBalancerName")
  valid_594459 = validateParameter(valid_594459, JString, required = true,
                                 default = nil)
  if valid_594459 != nil:
    section.add "loadBalancerName", valid_594459
  var valid_594460 = path.getOrDefault("subscriptionId")
  valid_594460 = validateParameter(valid_594460, JString, required = true,
                                 default = nil)
  if valid_594460 != nil:
    section.add "subscriptionId", valid_594460
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594461 = query.getOrDefault("api-version")
  valid_594461 = validateParameter(valid_594461, JString, required = true,
                                 default = nil)
  if valid_594461 != nil:
    section.add "api-version", valid_594461
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594462: Call_LoadBalancersDelete_594455; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete LoadBalancer operation deletes the specified load balancer.
  ## 
  let valid = call_594462.validator(path, query, header, formData, body)
  let scheme = call_594462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594462.url(scheme.get, call_594462.host, call_594462.base,
                         call_594462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594462, url, valid)

proc call*(call_594463: Call_LoadBalancersDelete_594455; resourceGroupName: string;
          apiVersion: string; loadBalancerName: string; subscriptionId: string): Recallable =
  ## loadBalancersDelete
  ## The delete LoadBalancer operation deletes the specified load balancer.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   loadBalancerName: string (required)
  ##                   : The name of the loadBalancer.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594464 = newJObject()
  var query_594465 = newJObject()
  add(path_594464, "resourceGroupName", newJString(resourceGroupName))
  add(query_594465, "api-version", newJString(apiVersion))
  add(path_594464, "loadBalancerName", newJString(loadBalancerName))
  add(path_594464, "subscriptionId", newJString(subscriptionId))
  result = call_594463.call(path_594464, query_594465, nil, nil, nil)

var loadBalancersDelete* = Call_LoadBalancersDelete_594455(
    name: "loadBalancersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}",
    validator: validate_LoadBalancersDelete_594456, base: "",
    url: url_LoadBalancersDelete_594457, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysList_594466 = ref object of OpenApiRestCall_593421
proc url_LocalNetworkGatewaysList_594468(protocol: Scheme; host: string;
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

proc validate_LocalNetworkGatewaysList_594467(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List LocalNetworkGateways operation retrieves all the local network gateways stored.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594469 = path.getOrDefault("resourceGroupName")
  valid_594469 = validateParameter(valid_594469, JString, required = true,
                                 default = nil)
  if valid_594469 != nil:
    section.add "resourceGroupName", valid_594469
  var valid_594470 = path.getOrDefault("subscriptionId")
  valid_594470 = validateParameter(valid_594470, JString, required = true,
                                 default = nil)
  if valid_594470 != nil:
    section.add "subscriptionId", valid_594470
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594471 = query.getOrDefault("api-version")
  valid_594471 = validateParameter(valid_594471, JString, required = true,
                                 default = nil)
  if valid_594471 != nil:
    section.add "api-version", valid_594471
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594472: Call_LocalNetworkGatewaysList_594466; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List LocalNetworkGateways operation retrieves all the local network gateways stored.
  ## 
  let valid = call_594472.validator(path, query, header, formData, body)
  let scheme = call_594472.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594472.url(scheme.get, call_594472.host, call_594472.base,
                         call_594472.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594472, url, valid)

proc call*(call_594473: Call_LocalNetworkGatewaysList_594466;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## localNetworkGatewaysList
  ## The List LocalNetworkGateways operation retrieves all the local network gateways stored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594474 = newJObject()
  var query_594475 = newJObject()
  add(path_594474, "resourceGroupName", newJString(resourceGroupName))
  add(query_594475, "api-version", newJString(apiVersion))
  add(path_594474, "subscriptionId", newJString(subscriptionId))
  result = call_594473.call(path_594474, query_594475, nil, nil, nil)

var localNetworkGatewaysList* = Call_LocalNetworkGatewaysList_594466(
    name: "localNetworkGatewaysList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways",
    validator: validate_LocalNetworkGatewaysList_594467, base: "",
    url: url_LocalNetworkGatewaysList_594468, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysCreateOrUpdate_594487 = ref object of OpenApiRestCall_593421
proc url_LocalNetworkGatewaysCreateOrUpdate_594489(protocol: Scheme; host: string;
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

proc validate_LocalNetworkGatewaysCreateOrUpdate_594488(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put LocalNetworkGateway operation creates/updates a local network gateway in the specified resource group through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   localNetworkGatewayName: JString (required)
  ##                          : The name of the local network gateway.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594490 = path.getOrDefault("resourceGroupName")
  valid_594490 = validateParameter(valid_594490, JString, required = true,
                                 default = nil)
  if valid_594490 != nil:
    section.add "resourceGroupName", valid_594490
  var valid_594491 = path.getOrDefault("localNetworkGatewayName")
  valid_594491 = validateParameter(valid_594491, JString, required = true,
                                 default = nil)
  if valid_594491 != nil:
    section.add "localNetworkGatewayName", valid_594491
  var valid_594492 = path.getOrDefault("subscriptionId")
  valid_594492 = validateParameter(valid_594492, JString, required = true,
                                 default = nil)
  if valid_594492 != nil:
    section.add "subscriptionId", valid_594492
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594493 = query.getOrDefault("api-version")
  valid_594493 = validateParameter(valid_594493, JString, required = true,
                                 default = nil)
  if valid_594493 != nil:
    section.add "api-version", valid_594493
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

proc call*(call_594495: Call_LocalNetworkGatewaysCreateOrUpdate_594487;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put LocalNetworkGateway operation creates/updates a local network gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_594495.validator(path, query, header, formData, body)
  let scheme = call_594495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594495.url(scheme.get, call_594495.host, call_594495.base,
                         call_594495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594495, url, valid)

proc call*(call_594496: Call_LocalNetworkGatewaysCreateOrUpdate_594487;
          resourceGroupName: string; localNetworkGatewayName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## localNetworkGatewaysCreateOrUpdate
  ## The Put LocalNetworkGateway operation creates/updates a local network gateway in the specified resource group through Network resource provider.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   localNetworkGatewayName: string (required)
  ##                          : The name of the local network gateway.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Begin Create or update Local Network Gateway operation through Network resource provider.
  var path_594497 = newJObject()
  var query_594498 = newJObject()
  var body_594499 = newJObject()
  add(path_594497, "resourceGroupName", newJString(resourceGroupName))
  add(path_594497, "localNetworkGatewayName", newJString(localNetworkGatewayName))
  add(query_594498, "api-version", newJString(apiVersion))
  add(path_594497, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594499 = parameters
  result = call_594496.call(path_594497, query_594498, nil, nil, body_594499)

var localNetworkGatewaysCreateOrUpdate* = Call_LocalNetworkGatewaysCreateOrUpdate_594487(
    name: "localNetworkGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways/{localNetworkGatewayName}",
    validator: validate_LocalNetworkGatewaysCreateOrUpdate_594488, base: "",
    url: url_LocalNetworkGatewaysCreateOrUpdate_594489, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysGet_594476 = ref object of OpenApiRestCall_593421
proc url_LocalNetworkGatewaysGet_594478(protocol: Scheme; host: string; base: string;
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

proc validate_LocalNetworkGatewaysGet_594477(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get LocalNetworkGateway operation retrieves information about the specified local network gateway through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   localNetworkGatewayName: JString (required)
  ##                          : The name of the local network gateway.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594479 = path.getOrDefault("resourceGroupName")
  valid_594479 = validateParameter(valid_594479, JString, required = true,
                                 default = nil)
  if valid_594479 != nil:
    section.add "resourceGroupName", valid_594479
  var valid_594480 = path.getOrDefault("localNetworkGatewayName")
  valid_594480 = validateParameter(valid_594480, JString, required = true,
                                 default = nil)
  if valid_594480 != nil:
    section.add "localNetworkGatewayName", valid_594480
  var valid_594481 = path.getOrDefault("subscriptionId")
  valid_594481 = validateParameter(valid_594481, JString, required = true,
                                 default = nil)
  if valid_594481 != nil:
    section.add "subscriptionId", valid_594481
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594482 = query.getOrDefault("api-version")
  valid_594482 = validateParameter(valid_594482, JString, required = true,
                                 default = nil)
  if valid_594482 != nil:
    section.add "api-version", valid_594482
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594483: Call_LocalNetworkGatewaysGet_594476; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get LocalNetworkGateway operation retrieves information about the specified local network gateway through Network resource provider.
  ## 
  let valid = call_594483.validator(path, query, header, formData, body)
  let scheme = call_594483.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594483.url(scheme.get, call_594483.host, call_594483.base,
                         call_594483.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594483, url, valid)

proc call*(call_594484: Call_LocalNetworkGatewaysGet_594476;
          resourceGroupName: string; localNetworkGatewayName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## localNetworkGatewaysGet
  ## The Get LocalNetworkGateway operation retrieves information about the specified local network gateway through Network resource provider.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   localNetworkGatewayName: string (required)
  ##                          : The name of the local network gateway.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594485 = newJObject()
  var query_594486 = newJObject()
  add(path_594485, "resourceGroupName", newJString(resourceGroupName))
  add(path_594485, "localNetworkGatewayName", newJString(localNetworkGatewayName))
  add(query_594486, "api-version", newJString(apiVersion))
  add(path_594485, "subscriptionId", newJString(subscriptionId))
  result = call_594484.call(path_594485, query_594486, nil, nil, nil)

var localNetworkGatewaysGet* = Call_LocalNetworkGatewaysGet_594476(
    name: "localNetworkGatewaysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways/{localNetworkGatewayName}",
    validator: validate_LocalNetworkGatewaysGet_594477, base: "",
    url: url_LocalNetworkGatewaysGet_594478, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysDelete_594500 = ref object of OpenApiRestCall_593421
proc url_LocalNetworkGatewaysDelete_594502(protocol: Scheme; host: string;
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

proc validate_LocalNetworkGatewaysDelete_594501(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Delete LocalNetworkGateway operation deletes the specified local network Gateway through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   localNetworkGatewayName: JString (required)
  ##                          : The name of the local network gateway.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594503 = path.getOrDefault("resourceGroupName")
  valid_594503 = validateParameter(valid_594503, JString, required = true,
                                 default = nil)
  if valid_594503 != nil:
    section.add "resourceGroupName", valid_594503
  var valid_594504 = path.getOrDefault("localNetworkGatewayName")
  valid_594504 = validateParameter(valid_594504, JString, required = true,
                                 default = nil)
  if valid_594504 != nil:
    section.add "localNetworkGatewayName", valid_594504
  var valid_594505 = path.getOrDefault("subscriptionId")
  valid_594505 = validateParameter(valid_594505, JString, required = true,
                                 default = nil)
  if valid_594505 != nil:
    section.add "subscriptionId", valid_594505
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594506 = query.getOrDefault("api-version")
  valid_594506 = validateParameter(valid_594506, JString, required = true,
                                 default = nil)
  if valid_594506 != nil:
    section.add "api-version", valid_594506
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594507: Call_LocalNetworkGatewaysDelete_594500; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete LocalNetworkGateway operation deletes the specified local network Gateway through Network resource provider.
  ## 
  let valid = call_594507.validator(path, query, header, formData, body)
  let scheme = call_594507.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594507.url(scheme.get, call_594507.host, call_594507.base,
                         call_594507.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594507, url, valid)

proc call*(call_594508: Call_LocalNetworkGatewaysDelete_594500;
          resourceGroupName: string; localNetworkGatewayName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## localNetworkGatewaysDelete
  ## The Delete LocalNetworkGateway operation deletes the specified local network Gateway through Network resource provider.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   localNetworkGatewayName: string (required)
  ##                          : The name of the local network gateway.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594509 = newJObject()
  var query_594510 = newJObject()
  add(path_594509, "resourceGroupName", newJString(resourceGroupName))
  add(path_594509, "localNetworkGatewayName", newJString(localNetworkGatewayName))
  add(query_594510, "api-version", newJString(apiVersion))
  add(path_594509, "subscriptionId", newJString(subscriptionId))
  result = call_594508.call(path_594509, query_594510, nil, nil, nil)

var localNetworkGatewaysDelete* = Call_LocalNetworkGatewaysDelete_594500(
    name: "localNetworkGatewaysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways/{localNetworkGatewayName}",
    validator: validate_LocalNetworkGatewaysDelete_594501, base: "",
    url: url_LocalNetworkGatewaysDelete_594502, schemes: {Scheme.Https})
type
  Call_NetworkInterfacesList_594511 = ref object of OpenApiRestCall_593421
proc url_NetworkInterfacesList_594513(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkInterfacesList_594512(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List networkInterfaces operation retrieves all the networkInterfaces in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594514 = path.getOrDefault("resourceGroupName")
  valid_594514 = validateParameter(valid_594514, JString, required = true,
                                 default = nil)
  if valid_594514 != nil:
    section.add "resourceGroupName", valid_594514
  var valid_594515 = path.getOrDefault("subscriptionId")
  valid_594515 = validateParameter(valid_594515, JString, required = true,
                                 default = nil)
  if valid_594515 != nil:
    section.add "subscriptionId", valid_594515
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594516 = query.getOrDefault("api-version")
  valid_594516 = validateParameter(valid_594516, JString, required = true,
                                 default = nil)
  if valid_594516 != nil:
    section.add "api-version", valid_594516
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594517: Call_NetworkInterfacesList_594511; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List networkInterfaces operation retrieves all the networkInterfaces in a resource group.
  ## 
  let valid = call_594517.validator(path, query, header, formData, body)
  let scheme = call_594517.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594517.url(scheme.get, call_594517.host, call_594517.base,
                         call_594517.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594517, url, valid)

proc call*(call_594518: Call_NetworkInterfacesList_594511;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## networkInterfacesList
  ## The List networkInterfaces operation retrieves all the networkInterfaces in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594519 = newJObject()
  var query_594520 = newJObject()
  add(path_594519, "resourceGroupName", newJString(resourceGroupName))
  add(query_594520, "api-version", newJString(apiVersion))
  add(path_594519, "subscriptionId", newJString(subscriptionId))
  result = call_594518.call(path_594519, query_594520, nil, nil, nil)

var networkInterfacesList* = Call_NetworkInterfacesList_594511(
    name: "networkInterfacesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces",
    validator: validate_NetworkInterfacesList_594512, base: "",
    url: url_NetworkInterfacesList_594513, schemes: {Scheme.Https})
type
  Call_NetworkInterfacesCreateOrUpdate_594533 = ref object of OpenApiRestCall_593421
proc url_NetworkInterfacesCreateOrUpdate_594535(protocol: Scheme; host: string;
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

proc validate_NetworkInterfacesCreateOrUpdate_594534(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put NetworkInterface operation creates/updates a networkInterface
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkInterfaceName: JString (required)
  ##                       : The name of the network interface.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594536 = path.getOrDefault("resourceGroupName")
  valid_594536 = validateParameter(valid_594536, JString, required = true,
                                 default = nil)
  if valid_594536 != nil:
    section.add "resourceGroupName", valid_594536
  var valid_594537 = path.getOrDefault("subscriptionId")
  valid_594537 = validateParameter(valid_594537, JString, required = true,
                                 default = nil)
  if valid_594537 != nil:
    section.add "subscriptionId", valid_594537
  var valid_594538 = path.getOrDefault("networkInterfaceName")
  valid_594538 = validateParameter(valid_594538, JString, required = true,
                                 default = nil)
  if valid_594538 != nil:
    section.add "networkInterfaceName", valid_594538
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594539 = query.getOrDefault("api-version")
  valid_594539 = validateParameter(valid_594539, JString, required = true,
                                 default = nil)
  if valid_594539 != nil:
    section.add "api-version", valid_594539
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

proc call*(call_594541: Call_NetworkInterfacesCreateOrUpdate_594533;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put NetworkInterface operation creates/updates a networkInterface
  ## 
  let valid = call_594541.validator(path, query, header, formData, body)
  let scheme = call_594541.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594541.url(scheme.get, call_594541.host, call_594541.base,
                         call_594541.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594541, url, valid)

proc call*(call_594542: Call_NetworkInterfacesCreateOrUpdate_594533;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkInterfaceName: string; parameters: JsonNode): Recallable =
  ## networkInterfacesCreateOrUpdate
  ## The Put NetworkInterface operation creates/updates a networkInterface
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkInterfaceName: string (required)
  ##                       : The name of the network interface.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update NetworkInterface operation
  var path_594543 = newJObject()
  var query_594544 = newJObject()
  var body_594545 = newJObject()
  add(path_594543, "resourceGroupName", newJString(resourceGroupName))
  add(query_594544, "api-version", newJString(apiVersion))
  add(path_594543, "subscriptionId", newJString(subscriptionId))
  add(path_594543, "networkInterfaceName", newJString(networkInterfaceName))
  if parameters != nil:
    body_594545 = parameters
  result = call_594542.call(path_594543, query_594544, nil, nil, body_594545)

var networkInterfacesCreateOrUpdate* = Call_NetworkInterfacesCreateOrUpdate_594533(
    name: "networkInterfacesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/{networkInterfaceName}",
    validator: validate_NetworkInterfacesCreateOrUpdate_594534, base: "",
    url: url_NetworkInterfacesCreateOrUpdate_594535, schemes: {Scheme.Https})
type
  Call_NetworkInterfacesGet_594521 = ref object of OpenApiRestCall_593421
proc url_NetworkInterfacesGet_594523(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkInterfacesGet_594522(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get network interface operation retrieves information about the specified network interface.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkInterfaceName: JString (required)
  ##                       : The name of the network interface.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594524 = path.getOrDefault("resourceGroupName")
  valid_594524 = validateParameter(valid_594524, JString, required = true,
                                 default = nil)
  if valid_594524 != nil:
    section.add "resourceGroupName", valid_594524
  var valid_594525 = path.getOrDefault("subscriptionId")
  valid_594525 = validateParameter(valid_594525, JString, required = true,
                                 default = nil)
  if valid_594525 != nil:
    section.add "subscriptionId", valid_594525
  var valid_594526 = path.getOrDefault("networkInterfaceName")
  valid_594526 = validateParameter(valid_594526, JString, required = true,
                                 default = nil)
  if valid_594526 != nil:
    section.add "networkInterfaceName", valid_594526
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594527 = query.getOrDefault("api-version")
  valid_594527 = validateParameter(valid_594527, JString, required = true,
                                 default = nil)
  if valid_594527 != nil:
    section.add "api-version", valid_594527
  var valid_594528 = query.getOrDefault("$expand")
  valid_594528 = validateParameter(valid_594528, JString, required = false,
                                 default = nil)
  if valid_594528 != nil:
    section.add "$expand", valid_594528
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594529: Call_NetworkInterfacesGet_594521; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get network interface operation retrieves information about the specified network interface.
  ## 
  let valid = call_594529.validator(path, query, header, formData, body)
  let scheme = call_594529.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594529.url(scheme.get, call_594529.host, call_594529.base,
                         call_594529.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594529, url, valid)

proc call*(call_594530: Call_NetworkInterfacesGet_594521;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkInterfaceName: string; Expand: string = ""): Recallable =
  ## networkInterfacesGet
  ## The Get network interface operation retrieves information about the specified network interface.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : expand references resources.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkInterfaceName: string (required)
  ##                       : The name of the network interface.
  var path_594531 = newJObject()
  var query_594532 = newJObject()
  add(path_594531, "resourceGroupName", newJString(resourceGroupName))
  add(query_594532, "api-version", newJString(apiVersion))
  add(query_594532, "$expand", newJString(Expand))
  add(path_594531, "subscriptionId", newJString(subscriptionId))
  add(path_594531, "networkInterfaceName", newJString(networkInterfaceName))
  result = call_594530.call(path_594531, query_594532, nil, nil, nil)

var networkInterfacesGet* = Call_NetworkInterfacesGet_594521(
    name: "networkInterfacesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/{networkInterfaceName}",
    validator: validate_NetworkInterfacesGet_594522, base: "",
    url: url_NetworkInterfacesGet_594523, schemes: {Scheme.Https})
type
  Call_NetworkInterfacesDelete_594546 = ref object of OpenApiRestCall_593421
proc url_NetworkInterfacesDelete_594548(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkInterfacesDelete_594547(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The delete networkInterface operation deletes the specified networkInterface.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkInterfaceName: JString (required)
  ##                       : The name of the network interface.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594549 = path.getOrDefault("resourceGroupName")
  valid_594549 = validateParameter(valid_594549, JString, required = true,
                                 default = nil)
  if valid_594549 != nil:
    section.add "resourceGroupName", valid_594549
  var valid_594550 = path.getOrDefault("subscriptionId")
  valid_594550 = validateParameter(valid_594550, JString, required = true,
                                 default = nil)
  if valid_594550 != nil:
    section.add "subscriptionId", valid_594550
  var valid_594551 = path.getOrDefault("networkInterfaceName")
  valid_594551 = validateParameter(valid_594551, JString, required = true,
                                 default = nil)
  if valid_594551 != nil:
    section.add "networkInterfaceName", valid_594551
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594552 = query.getOrDefault("api-version")
  valid_594552 = validateParameter(valid_594552, JString, required = true,
                                 default = nil)
  if valid_594552 != nil:
    section.add "api-version", valid_594552
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594553: Call_NetworkInterfacesDelete_594546; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete networkInterface operation deletes the specified networkInterface.
  ## 
  let valid = call_594553.validator(path, query, header, formData, body)
  let scheme = call_594553.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594553.url(scheme.get, call_594553.host, call_594553.base,
                         call_594553.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594553, url, valid)

proc call*(call_594554: Call_NetworkInterfacesDelete_594546;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkInterfaceName: string): Recallable =
  ## networkInterfacesDelete
  ## The delete networkInterface operation deletes the specified networkInterface.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkInterfaceName: string (required)
  ##                       : The name of the network interface.
  var path_594555 = newJObject()
  var query_594556 = newJObject()
  add(path_594555, "resourceGroupName", newJString(resourceGroupName))
  add(query_594556, "api-version", newJString(apiVersion))
  add(path_594555, "subscriptionId", newJString(subscriptionId))
  add(path_594555, "networkInterfaceName", newJString(networkInterfaceName))
  result = call_594554.call(path_594555, query_594556, nil, nil, nil)

var networkInterfacesDelete* = Call_NetworkInterfacesDelete_594546(
    name: "networkInterfacesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/{networkInterfaceName}",
    validator: validate_NetworkInterfacesDelete_594547, base: "",
    url: url_NetworkInterfacesDelete_594548, schemes: {Scheme.Https})
type
  Call_NetworkInterfacesListEffectiveNetworkSecurityGroups_594557 = ref object of OpenApiRestCall_593421
proc url_NetworkInterfacesListEffectiveNetworkSecurityGroups_594559(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
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
               (kind: VariableSegment, value: "networkInterfaceName"), (
        kind: ConstantSegment, value: "/effectiveNetworkSecurityGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfacesListEffectiveNetworkSecurityGroups_594558(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The list effective network security group operation retrieves all the network security groups applied on a networkInterface.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkInterfaceName: JString (required)
  ##                       : The name of the network interface.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594560 = path.getOrDefault("resourceGroupName")
  valid_594560 = validateParameter(valid_594560, JString, required = true,
                                 default = nil)
  if valid_594560 != nil:
    section.add "resourceGroupName", valid_594560
  var valid_594561 = path.getOrDefault("subscriptionId")
  valid_594561 = validateParameter(valid_594561, JString, required = true,
                                 default = nil)
  if valid_594561 != nil:
    section.add "subscriptionId", valid_594561
  var valid_594562 = path.getOrDefault("networkInterfaceName")
  valid_594562 = validateParameter(valid_594562, JString, required = true,
                                 default = nil)
  if valid_594562 != nil:
    section.add "networkInterfaceName", valid_594562
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594563 = query.getOrDefault("api-version")
  valid_594563 = validateParameter(valid_594563, JString, required = true,
                                 default = nil)
  if valid_594563 != nil:
    section.add "api-version", valid_594563
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594564: Call_NetworkInterfacesListEffectiveNetworkSecurityGroups_594557;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The list effective network security group operation retrieves all the network security groups applied on a networkInterface.
  ## 
  let valid = call_594564.validator(path, query, header, formData, body)
  let scheme = call_594564.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594564.url(scheme.get, call_594564.host, call_594564.base,
                         call_594564.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594564, url, valid)

proc call*(call_594565: Call_NetworkInterfacesListEffectiveNetworkSecurityGroups_594557;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkInterfaceName: string): Recallable =
  ## networkInterfacesListEffectiveNetworkSecurityGroups
  ## The list effective network security group operation retrieves all the network security groups applied on a networkInterface.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkInterfaceName: string (required)
  ##                       : The name of the network interface.
  var path_594566 = newJObject()
  var query_594567 = newJObject()
  add(path_594566, "resourceGroupName", newJString(resourceGroupName))
  add(query_594567, "api-version", newJString(apiVersion))
  add(path_594566, "subscriptionId", newJString(subscriptionId))
  add(path_594566, "networkInterfaceName", newJString(networkInterfaceName))
  result = call_594565.call(path_594566, query_594567, nil, nil, nil)

var networkInterfacesListEffectiveNetworkSecurityGroups* = Call_NetworkInterfacesListEffectiveNetworkSecurityGroups_594557(
    name: "networkInterfacesListEffectiveNetworkSecurityGroups",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/{networkInterfaceName}/effectiveNetworkSecurityGroups",
    validator: validate_NetworkInterfacesListEffectiveNetworkSecurityGroups_594558,
    base: "", url: url_NetworkInterfacesListEffectiveNetworkSecurityGroups_594559,
    schemes: {Scheme.Https})
type
  Call_NetworkInterfacesGetEffectiveRouteTable_594568 = ref object of OpenApiRestCall_593421
proc url_NetworkInterfacesGetEffectiveRouteTable_594570(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "networkInterfaceName"),
               (kind: ConstantSegment, value: "/effectiveRouteTable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfacesGetEffectiveRouteTable_594569(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the route tables applied on a networkInterface.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkInterfaceName: JString (required)
  ##                       : The name of the network interface.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594571 = path.getOrDefault("resourceGroupName")
  valid_594571 = validateParameter(valid_594571, JString, required = true,
                                 default = nil)
  if valid_594571 != nil:
    section.add "resourceGroupName", valid_594571
  var valid_594572 = path.getOrDefault("subscriptionId")
  valid_594572 = validateParameter(valid_594572, JString, required = true,
                                 default = nil)
  if valid_594572 != nil:
    section.add "subscriptionId", valid_594572
  var valid_594573 = path.getOrDefault("networkInterfaceName")
  valid_594573 = validateParameter(valid_594573, JString, required = true,
                                 default = nil)
  if valid_594573 != nil:
    section.add "networkInterfaceName", valid_594573
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594574 = query.getOrDefault("api-version")
  valid_594574 = validateParameter(valid_594574, JString, required = true,
                                 default = nil)
  if valid_594574 != nil:
    section.add "api-version", valid_594574
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594575: Call_NetworkInterfacesGetEffectiveRouteTable_594568;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all the route tables applied on a networkInterface.
  ## 
  let valid = call_594575.validator(path, query, header, formData, body)
  let scheme = call_594575.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594575.url(scheme.get, call_594575.host, call_594575.base,
                         call_594575.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594575, url, valid)

proc call*(call_594576: Call_NetworkInterfacesGetEffectiveRouteTable_594568;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkInterfaceName: string): Recallable =
  ## networkInterfacesGetEffectiveRouteTable
  ## Retrieves all the route tables applied on a networkInterface.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkInterfaceName: string (required)
  ##                       : The name of the network interface.
  var path_594577 = newJObject()
  var query_594578 = newJObject()
  add(path_594577, "resourceGroupName", newJString(resourceGroupName))
  add(query_594578, "api-version", newJString(apiVersion))
  add(path_594577, "subscriptionId", newJString(subscriptionId))
  add(path_594577, "networkInterfaceName", newJString(networkInterfaceName))
  result = call_594576.call(path_594577, query_594578, nil, nil, nil)

var networkInterfacesGetEffectiveRouteTable* = Call_NetworkInterfacesGetEffectiveRouteTable_594568(
    name: "networkInterfacesGetEffectiveRouteTable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/{networkInterfaceName}/effectiveRouteTable",
    validator: validate_NetworkInterfacesGetEffectiveRouteTable_594569, base: "",
    url: url_NetworkInterfacesGetEffectiveRouteTable_594570,
    schemes: {Scheme.Https})
type
  Call_NetworkSecurityGroupsList_594579 = ref object of OpenApiRestCall_593421
proc url_NetworkSecurityGroupsList_594581(protocol: Scheme; host: string;
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

proc validate_NetworkSecurityGroupsList_594580(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The list NetworkSecurityGroups returns all network security groups in a resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594582 = path.getOrDefault("resourceGroupName")
  valid_594582 = validateParameter(valid_594582, JString, required = true,
                                 default = nil)
  if valid_594582 != nil:
    section.add "resourceGroupName", valid_594582
  var valid_594583 = path.getOrDefault("subscriptionId")
  valid_594583 = validateParameter(valid_594583, JString, required = true,
                                 default = nil)
  if valid_594583 != nil:
    section.add "subscriptionId", valid_594583
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594584 = query.getOrDefault("api-version")
  valid_594584 = validateParameter(valid_594584, JString, required = true,
                                 default = nil)
  if valid_594584 != nil:
    section.add "api-version", valid_594584
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594585: Call_NetworkSecurityGroupsList_594579; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list NetworkSecurityGroups returns all network security groups in a resource group
  ## 
  let valid = call_594585.validator(path, query, header, formData, body)
  let scheme = call_594585.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594585.url(scheme.get, call_594585.host, call_594585.base,
                         call_594585.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594585, url, valid)

proc call*(call_594586: Call_NetworkSecurityGroupsList_594579;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## networkSecurityGroupsList
  ## The list NetworkSecurityGroups returns all network security groups in a resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594587 = newJObject()
  var query_594588 = newJObject()
  add(path_594587, "resourceGroupName", newJString(resourceGroupName))
  add(query_594588, "api-version", newJString(apiVersion))
  add(path_594587, "subscriptionId", newJString(subscriptionId))
  result = call_594586.call(path_594587, query_594588, nil, nil, nil)

var networkSecurityGroupsList* = Call_NetworkSecurityGroupsList_594579(
    name: "networkSecurityGroupsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups",
    validator: validate_NetworkSecurityGroupsList_594580, base: "",
    url: url_NetworkSecurityGroupsList_594581, schemes: {Scheme.Https})
type
  Call_NetworkSecurityGroupsCreateOrUpdate_594601 = ref object of OpenApiRestCall_593421
proc url_NetworkSecurityGroupsCreateOrUpdate_594603(protocol: Scheme; host: string;
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

proc validate_NetworkSecurityGroupsCreateOrUpdate_594602(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put NetworkSecurityGroup operation creates/updates a network security group in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkSecurityGroupName: JString (required)
  ##                           : The name of the network security group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594604 = path.getOrDefault("resourceGroupName")
  valid_594604 = validateParameter(valid_594604, JString, required = true,
                                 default = nil)
  if valid_594604 != nil:
    section.add "resourceGroupName", valid_594604
  var valid_594605 = path.getOrDefault("subscriptionId")
  valid_594605 = validateParameter(valid_594605, JString, required = true,
                                 default = nil)
  if valid_594605 != nil:
    section.add "subscriptionId", valid_594605
  var valid_594606 = path.getOrDefault("networkSecurityGroupName")
  valid_594606 = validateParameter(valid_594606, JString, required = true,
                                 default = nil)
  if valid_594606 != nil:
    section.add "networkSecurityGroupName", valid_594606
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594607 = query.getOrDefault("api-version")
  valid_594607 = validateParameter(valid_594607, JString, required = true,
                                 default = nil)
  if valid_594607 != nil:
    section.add "api-version", valid_594607
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

proc call*(call_594609: Call_NetworkSecurityGroupsCreateOrUpdate_594601;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put NetworkSecurityGroup operation creates/updates a network security group in the specified resource group.
  ## 
  let valid = call_594609.validator(path, query, header, formData, body)
  let scheme = call_594609.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594609.url(scheme.get, call_594609.host, call_594609.base,
                         call_594609.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594609, url, valid)

proc call*(call_594610: Call_NetworkSecurityGroupsCreateOrUpdate_594601;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkSecurityGroupName: string; parameters: JsonNode): Recallable =
  ## networkSecurityGroupsCreateOrUpdate
  ## The Put NetworkSecurityGroup operation creates/updates a network security group in the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkSecurityGroupName: string (required)
  ##                           : The name of the network security group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update Network Security Group operation
  var path_594611 = newJObject()
  var query_594612 = newJObject()
  var body_594613 = newJObject()
  add(path_594611, "resourceGroupName", newJString(resourceGroupName))
  add(query_594612, "api-version", newJString(apiVersion))
  add(path_594611, "subscriptionId", newJString(subscriptionId))
  add(path_594611, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  if parameters != nil:
    body_594613 = parameters
  result = call_594610.call(path_594611, query_594612, nil, nil, body_594613)

var networkSecurityGroupsCreateOrUpdate* = Call_NetworkSecurityGroupsCreateOrUpdate_594601(
    name: "networkSecurityGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}",
    validator: validate_NetworkSecurityGroupsCreateOrUpdate_594602, base: "",
    url: url_NetworkSecurityGroupsCreateOrUpdate_594603, schemes: {Scheme.Https})
type
  Call_NetworkSecurityGroupsGet_594589 = ref object of OpenApiRestCall_593421
proc url_NetworkSecurityGroupsGet_594591(protocol: Scheme; host: string;
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

proc validate_NetworkSecurityGroupsGet_594590(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get NetworkSecurityGroups operation retrieves information about the specified network security group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkSecurityGroupName: JString (required)
  ##                           : The name of the network security group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594592 = path.getOrDefault("resourceGroupName")
  valid_594592 = validateParameter(valid_594592, JString, required = true,
                                 default = nil)
  if valid_594592 != nil:
    section.add "resourceGroupName", valid_594592
  var valid_594593 = path.getOrDefault("subscriptionId")
  valid_594593 = validateParameter(valid_594593, JString, required = true,
                                 default = nil)
  if valid_594593 != nil:
    section.add "subscriptionId", valid_594593
  var valid_594594 = path.getOrDefault("networkSecurityGroupName")
  valid_594594 = validateParameter(valid_594594, JString, required = true,
                                 default = nil)
  if valid_594594 != nil:
    section.add "networkSecurityGroupName", valid_594594
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594595 = query.getOrDefault("api-version")
  valid_594595 = validateParameter(valid_594595, JString, required = true,
                                 default = nil)
  if valid_594595 != nil:
    section.add "api-version", valid_594595
  var valid_594596 = query.getOrDefault("$expand")
  valid_594596 = validateParameter(valid_594596, JString, required = false,
                                 default = nil)
  if valid_594596 != nil:
    section.add "$expand", valid_594596
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594597: Call_NetworkSecurityGroupsGet_594589; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get NetworkSecurityGroups operation retrieves information about the specified network security group.
  ## 
  let valid = call_594597.validator(path, query, header, formData, body)
  let scheme = call_594597.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594597.url(scheme.get, call_594597.host, call_594597.base,
                         call_594597.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594597, url, valid)

proc call*(call_594598: Call_NetworkSecurityGroupsGet_594589;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkSecurityGroupName: string; Expand: string = ""): Recallable =
  ## networkSecurityGroupsGet
  ## The Get NetworkSecurityGroups operation retrieves information about the specified network security group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : expand references resources.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkSecurityGroupName: string (required)
  ##                           : The name of the network security group.
  var path_594599 = newJObject()
  var query_594600 = newJObject()
  add(path_594599, "resourceGroupName", newJString(resourceGroupName))
  add(query_594600, "api-version", newJString(apiVersion))
  add(query_594600, "$expand", newJString(Expand))
  add(path_594599, "subscriptionId", newJString(subscriptionId))
  add(path_594599, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  result = call_594598.call(path_594599, query_594600, nil, nil, nil)

var networkSecurityGroupsGet* = Call_NetworkSecurityGroupsGet_594589(
    name: "networkSecurityGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}",
    validator: validate_NetworkSecurityGroupsGet_594590, base: "",
    url: url_NetworkSecurityGroupsGet_594591, schemes: {Scheme.Https})
type
  Call_NetworkSecurityGroupsDelete_594614 = ref object of OpenApiRestCall_593421
proc url_NetworkSecurityGroupsDelete_594616(protocol: Scheme; host: string;
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

proc validate_NetworkSecurityGroupsDelete_594615(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Delete NetworkSecurityGroup operation deletes the specified network security group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkSecurityGroupName: JString (required)
  ##                           : The name of the network security group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594617 = path.getOrDefault("resourceGroupName")
  valid_594617 = validateParameter(valid_594617, JString, required = true,
                                 default = nil)
  if valid_594617 != nil:
    section.add "resourceGroupName", valid_594617
  var valid_594618 = path.getOrDefault("subscriptionId")
  valid_594618 = validateParameter(valid_594618, JString, required = true,
                                 default = nil)
  if valid_594618 != nil:
    section.add "subscriptionId", valid_594618
  var valid_594619 = path.getOrDefault("networkSecurityGroupName")
  valid_594619 = validateParameter(valid_594619, JString, required = true,
                                 default = nil)
  if valid_594619 != nil:
    section.add "networkSecurityGroupName", valid_594619
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594620 = query.getOrDefault("api-version")
  valid_594620 = validateParameter(valid_594620, JString, required = true,
                                 default = nil)
  if valid_594620 != nil:
    section.add "api-version", valid_594620
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594621: Call_NetworkSecurityGroupsDelete_594614; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete NetworkSecurityGroup operation deletes the specified network security group
  ## 
  let valid = call_594621.validator(path, query, header, formData, body)
  let scheme = call_594621.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594621.url(scheme.get, call_594621.host, call_594621.base,
                         call_594621.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594621, url, valid)

proc call*(call_594622: Call_NetworkSecurityGroupsDelete_594614;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkSecurityGroupName: string): Recallable =
  ## networkSecurityGroupsDelete
  ## The Delete NetworkSecurityGroup operation deletes the specified network security group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkSecurityGroupName: string (required)
  ##                           : The name of the network security group.
  var path_594623 = newJObject()
  var query_594624 = newJObject()
  add(path_594623, "resourceGroupName", newJString(resourceGroupName))
  add(query_594624, "api-version", newJString(apiVersion))
  add(path_594623, "subscriptionId", newJString(subscriptionId))
  add(path_594623, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  result = call_594622.call(path_594623, query_594624, nil, nil, nil)

var networkSecurityGroupsDelete* = Call_NetworkSecurityGroupsDelete_594614(
    name: "networkSecurityGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}",
    validator: validate_NetworkSecurityGroupsDelete_594615, base: "",
    url: url_NetworkSecurityGroupsDelete_594616, schemes: {Scheme.Https})
type
  Call_SecurityRulesList_594625 = ref object of OpenApiRestCall_593421
proc url_SecurityRulesList_594627(protocol: Scheme; host: string; base: string;
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

proc validate_SecurityRulesList_594626(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## The List network security rule operation retrieves all the security rules in a network security group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkSecurityGroupName: JString (required)
  ##                           : The name of the network security group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594628 = path.getOrDefault("resourceGroupName")
  valid_594628 = validateParameter(valid_594628, JString, required = true,
                                 default = nil)
  if valid_594628 != nil:
    section.add "resourceGroupName", valid_594628
  var valid_594629 = path.getOrDefault("subscriptionId")
  valid_594629 = validateParameter(valid_594629, JString, required = true,
                                 default = nil)
  if valid_594629 != nil:
    section.add "subscriptionId", valid_594629
  var valid_594630 = path.getOrDefault("networkSecurityGroupName")
  valid_594630 = validateParameter(valid_594630, JString, required = true,
                                 default = nil)
  if valid_594630 != nil:
    section.add "networkSecurityGroupName", valid_594630
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594631 = query.getOrDefault("api-version")
  valid_594631 = validateParameter(valid_594631, JString, required = true,
                                 default = nil)
  if valid_594631 != nil:
    section.add "api-version", valid_594631
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594632: Call_SecurityRulesList_594625; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List network security rule operation retrieves all the security rules in a network security group.
  ## 
  let valid = call_594632.validator(path, query, header, formData, body)
  let scheme = call_594632.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594632.url(scheme.get, call_594632.host, call_594632.base,
                         call_594632.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594632, url, valid)

proc call*(call_594633: Call_SecurityRulesList_594625; resourceGroupName: string;
          apiVersion: string; subscriptionId: string;
          networkSecurityGroupName: string): Recallable =
  ## securityRulesList
  ## The List network security rule operation retrieves all the security rules in a network security group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkSecurityGroupName: string (required)
  ##                           : The name of the network security group.
  var path_594634 = newJObject()
  var query_594635 = newJObject()
  add(path_594634, "resourceGroupName", newJString(resourceGroupName))
  add(query_594635, "api-version", newJString(apiVersion))
  add(path_594634, "subscriptionId", newJString(subscriptionId))
  add(path_594634, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  result = call_594633.call(path_594634, query_594635, nil, nil, nil)

var securityRulesList* = Call_SecurityRulesList_594625(name: "securityRulesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}/securityRules",
    validator: validate_SecurityRulesList_594626, base: "",
    url: url_SecurityRulesList_594627, schemes: {Scheme.Https})
type
  Call_SecurityRulesCreateOrUpdate_594648 = ref object of OpenApiRestCall_593421
proc url_SecurityRulesCreateOrUpdate_594650(protocol: Scheme; host: string;
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

proc validate_SecurityRulesCreateOrUpdate_594649(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put network security rule operation creates/updates a security rule in the specified network security group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkSecurityGroupName: JString (required)
  ##                           : The name of the network security group.
  ##   securityRuleName: JString (required)
  ##                   : The name of the security rule.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594651 = path.getOrDefault("resourceGroupName")
  valid_594651 = validateParameter(valid_594651, JString, required = true,
                                 default = nil)
  if valid_594651 != nil:
    section.add "resourceGroupName", valid_594651
  var valid_594652 = path.getOrDefault("subscriptionId")
  valid_594652 = validateParameter(valid_594652, JString, required = true,
                                 default = nil)
  if valid_594652 != nil:
    section.add "subscriptionId", valid_594652
  var valid_594653 = path.getOrDefault("networkSecurityGroupName")
  valid_594653 = validateParameter(valid_594653, JString, required = true,
                                 default = nil)
  if valid_594653 != nil:
    section.add "networkSecurityGroupName", valid_594653
  var valid_594654 = path.getOrDefault("securityRuleName")
  valid_594654 = validateParameter(valid_594654, JString, required = true,
                                 default = nil)
  if valid_594654 != nil:
    section.add "securityRuleName", valid_594654
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594655 = query.getOrDefault("api-version")
  valid_594655 = validateParameter(valid_594655, JString, required = true,
                                 default = nil)
  if valid_594655 != nil:
    section.add "api-version", valid_594655
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

proc call*(call_594657: Call_SecurityRulesCreateOrUpdate_594648; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put network security rule operation creates/updates a security rule in the specified network security group
  ## 
  let valid = call_594657.validator(path, query, header, formData, body)
  let scheme = call_594657.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594657.url(scheme.get, call_594657.host, call_594657.base,
                         call_594657.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594657, url, valid)

proc call*(call_594658: Call_SecurityRulesCreateOrUpdate_594648;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkSecurityGroupName: string; securityRuleName: string;
          securityRuleParameters: JsonNode): Recallable =
  ## securityRulesCreateOrUpdate
  ## The Put network security rule operation creates/updates a security rule in the specified network security group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkSecurityGroupName: string (required)
  ##                           : The name of the network security group.
  ##   securityRuleName: string (required)
  ##                   : The name of the security rule.
  ##   securityRuleParameters: JObject (required)
  ##                         : Parameters supplied to the create/update network security rule operation
  var path_594659 = newJObject()
  var query_594660 = newJObject()
  var body_594661 = newJObject()
  add(path_594659, "resourceGroupName", newJString(resourceGroupName))
  add(query_594660, "api-version", newJString(apiVersion))
  add(path_594659, "subscriptionId", newJString(subscriptionId))
  add(path_594659, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  add(path_594659, "securityRuleName", newJString(securityRuleName))
  if securityRuleParameters != nil:
    body_594661 = securityRuleParameters
  result = call_594658.call(path_594659, query_594660, nil, nil, body_594661)

var securityRulesCreateOrUpdate* = Call_SecurityRulesCreateOrUpdate_594648(
    name: "securityRulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}/securityRules/{securityRuleName}",
    validator: validate_SecurityRulesCreateOrUpdate_594649, base: "",
    url: url_SecurityRulesCreateOrUpdate_594650, schemes: {Scheme.Https})
type
  Call_SecurityRulesGet_594636 = ref object of OpenApiRestCall_593421
proc url_SecurityRulesGet_594638(protocol: Scheme; host: string; base: string;
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

proc validate_SecurityRulesGet_594637(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## The Get NetworkSecurityRule operation retrieves information about the specified network security rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkSecurityGroupName: JString (required)
  ##                           : The name of the network security group.
  ##   securityRuleName: JString (required)
  ##                   : The name of the security rule.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594639 = path.getOrDefault("resourceGroupName")
  valid_594639 = validateParameter(valid_594639, JString, required = true,
                                 default = nil)
  if valid_594639 != nil:
    section.add "resourceGroupName", valid_594639
  var valid_594640 = path.getOrDefault("subscriptionId")
  valid_594640 = validateParameter(valid_594640, JString, required = true,
                                 default = nil)
  if valid_594640 != nil:
    section.add "subscriptionId", valid_594640
  var valid_594641 = path.getOrDefault("networkSecurityGroupName")
  valid_594641 = validateParameter(valid_594641, JString, required = true,
                                 default = nil)
  if valid_594641 != nil:
    section.add "networkSecurityGroupName", valid_594641
  var valid_594642 = path.getOrDefault("securityRuleName")
  valid_594642 = validateParameter(valid_594642, JString, required = true,
                                 default = nil)
  if valid_594642 != nil:
    section.add "securityRuleName", valid_594642
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594643 = query.getOrDefault("api-version")
  valid_594643 = validateParameter(valid_594643, JString, required = true,
                                 default = nil)
  if valid_594643 != nil:
    section.add "api-version", valid_594643
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594644: Call_SecurityRulesGet_594636; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get NetworkSecurityRule operation retrieves information about the specified network security rule.
  ## 
  let valid = call_594644.validator(path, query, header, formData, body)
  let scheme = call_594644.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594644.url(scheme.get, call_594644.host, call_594644.base,
                         call_594644.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594644, url, valid)

proc call*(call_594645: Call_SecurityRulesGet_594636; resourceGroupName: string;
          apiVersion: string; subscriptionId: string;
          networkSecurityGroupName: string; securityRuleName: string): Recallable =
  ## securityRulesGet
  ## The Get NetworkSecurityRule operation retrieves information about the specified network security rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkSecurityGroupName: string (required)
  ##                           : The name of the network security group.
  ##   securityRuleName: string (required)
  ##                   : The name of the security rule.
  var path_594646 = newJObject()
  var query_594647 = newJObject()
  add(path_594646, "resourceGroupName", newJString(resourceGroupName))
  add(query_594647, "api-version", newJString(apiVersion))
  add(path_594646, "subscriptionId", newJString(subscriptionId))
  add(path_594646, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  add(path_594646, "securityRuleName", newJString(securityRuleName))
  result = call_594645.call(path_594646, query_594647, nil, nil, nil)

var securityRulesGet* = Call_SecurityRulesGet_594636(name: "securityRulesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}/securityRules/{securityRuleName}",
    validator: validate_SecurityRulesGet_594637, base: "",
    url: url_SecurityRulesGet_594638, schemes: {Scheme.Https})
type
  Call_SecurityRulesDelete_594662 = ref object of OpenApiRestCall_593421
proc url_SecurityRulesDelete_594664(protocol: Scheme; host: string; base: string;
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

proc validate_SecurityRulesDelete_594663(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## The delete network security rule operation deletes the specified network security rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkSecurityGroupName: JString (required)
  ##                           : The name of the network security group.
  ##   securityRuleName: JString (required)
  ##                   : The name of the security rule.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594665 = path.getOrDefault("resourceGroupName")
  valid_594665 = validateParameter(valid_594665, JString, required = true,
                                 default = nil)
  if valid_594665 != nil:
    section.add "resourceGroupName", valid_594665
  var valid_594666 = path.getOrDefault("subscriptionId")
  valid_594666 = validateParameter(valid_594666, JString, required = true,
                                 default = nil)
  if valid_594666 != nil:
    section.add "subscriptionId", valid_594666
  var valid_594667 = path.getOrDefault("networkSecurityGroupName")
  valid_594667 = validateParameter(valid_594667, JString, required = true,
                                 default = nil)
  if valid_594667 != nil:
    section.add "networkSecurityGroupName", valid_594667
  var valid_594668 = path.getOrDefault("securityRuleName")
  valid_594668 = validateParameter(valid_594668, JString, required = true,
                                 default = nil)
  if valid_594668 != nil:
    section.add "securityRuleName", valid_594668
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594669 = query.getOrDefault("api-version")
  valid_594669 = validateParameter(valid_594669, JString, required = true,
                                 default = nil)
  if valid_594669 != nil:
    section.add "api-version", valid_594669
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594670: Call_SecurityRulesDelete_594662; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete network security rule operation deletes the specified network security rule.
  ## 
  let valid = call_594670.validator(path, query, header, formData, body)
  let scheme = call_594670.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594670.url(scheme.get, call_594670.host, call_594670.base,
                         call_594670.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594670, url, valid)

proc call*(call_594671: Call_SecurityRulesDelete_594662; resourceGroupName: string;
          apiVersion: string; subscriptionId: string;
          networkSecurityGroupName: string; securityRuleName: string): Recallable =
  ## securityRulesDelete
  ## The delete network security rule operation deletes the specified network security rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkSecurityGroupName: string (required)
  ##                           : The name of the network security group.
  ##   securityRuleName: string (required)
  ##                   : The name of the security rule.
  var path_594672 = newJObject()
  var query_594673 = newJObject()
  add(path_594672, "resourceGroupName", newJString(resourceGroupName))
  add(query_594673, "api-version", newJString(apiVersion))
  add(path_594672, "subscriptionId", newJString(subscriptionId))
  add(path_594672, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  add(path_594672, "securityRuleName", newJString(securityRuleName))
  result = call_594671.call(path_594672, query_594673, nil, nil, nil)

var securityRulesDelete* = Call_SecurityRulesDelete_594662(
    name: "securityRulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}/securityRules/{securityRuleName}",
    validator: validate_SecurityRulesDelete_594663, base: "",
    url: url_SecurityRulesDelete_594664, schemes: {Scheme.Https})
type
  Call_PublicIPAddressesList_594674 = ref object of OpenApiRestCall_593421
proc url_PublicIPAddressesList_594676(protocol: Scheme; host: string; base: string;
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

proc validate_PublicIPAddressesList_594675(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List publicIpAddress operation retrieves all the publicIpAddresses in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594677 = path.getOrDefault("resourceGroupName")
  valid_594677 = validateParameter(valid_594677, JString, required = true,
                                 default = nil)
  if valid_594677 != nil:
    section.add "resourceGroupName", valid_594677
  var valid_594678 = path.getOrDefault("subscriptionId")
  valid_594678 = validateParameter(valid_594678, JString, required = true,
                                 default = nil)
  if valid_594678 != nil:
    section.add "subscriptionId", valid_594678
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594679 = query.getOrDefault("api-version")
  valid_594679 = validateParameter(valid_594679, JString, required = true,
                                 default = nil)
  if valid_594679 != nil:
    section.add "api-version", valid_594679
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594680: Call_PublicIPAddressesList_594674; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List publicIpAddress operation retrieves all the publicIpAddresses in a resource group.
  ## 
  let valid = call_594680.validator(path, query, header, formData, body)
  let scheme = call_594680.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594680.url(scheme.get, call_594680.host, call_594680.base,
                         call_594680.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594680, url, valid)

proc call*(call_594681: Call_PublicIPAddressesList_594674;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## publicIPAddressesList
  ## The List publicIpAddress operation retrieves all the publicIpAddresses in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594682 = newJObject()
  var query_594683 = newJObject()
  add(path_594682, "resourceGroupName", newJString(resourceGroupName))
  add(query_594683, "api-version", newJString(apiVersion))
  add(path_594682, "subscriptionId", newJString(subscriptionId))
  result = call_594681.call(path_594682, query_594683, nil, nil, nil)

var publicIPAddressesList* = Call_PublicIPAddressesList_594674(
    name: "publicIPAddressesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses",
    validator: validate_PublicIPAddressesList_594675, base: "",
    url: url_PublicIPAddressesList_594676, schemes: {Scheme.Https})
type
  Call_PublicIPAddressesCreateOrUpdate_594696 = ref object of OpenApiRestCall_593421
proc url_PublicIPAddressesCreateOrUpdate_594698(protocol: Scheme; host: string;
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

proc validate_PublicIPAddressesCreateOrUpdate_594697(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put PublicIPAddress operation creates/updates a stable/dynamic PublicIP address
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   publicIpAddressName: JString (required)
  ##                      : The name of the publicIpAddress.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594699 = path.getOrDefault("resourceGroupName")
  valid_594699 = validateParameter(valid_594699, JString, required = true,
                                 default = nil)
  if valid_594699 != nil:
    section.add "resourceGroupName", valid_594699
  var valid_594700 = path.getOrDefault("publicIpAddressName")
  valid_594700 = validateParameter(valid_594700, JString, required = true,
                                 default = nil)
  if valid_594700 != nil:
    section.add "publicIpAddressName", valid_594700
  var valid_594701 = path.getOrDefault("subscriptionId")
  valid_594701 = validateParameter(valid_594701, JString, required = true,
                                 default = nil)
  if valid_594701 != nil:
    section.add "subscriptionId", valid_594701
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594702 = query.getOrDefault("api-version")
  valid_594702 = validateParameter(valid_594702, JString, required = true,
                                 default = nil)
  if valid_594702 != nil:
    section.add "api-version", valid_594702
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

proc call*(call_594704: Call_PublicIPAddressesCreateOrUpdate_594696;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put PublicIPAddress operation creates/updates a stable/dynamic PublicIP address
  ## 
  let valid = call_594704.validator(path, query, header, formData, body)
  let scheme = call_594704.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594704.url(scheme.get, call_594704.host, call_594704.base,
                         call_594704.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594704, url, valid)

proc call*(call_594705: Call_PublicIPAddressesCreateOrUpdate_594696;
          resourceGroupName: string; apiVersion: string;
          publicIpAddressName: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## publicIPAddressesCreateOrUpdate
  ## The Put PublicIPAddress operation creates/updates a stable/dynamic PublicIP address
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   publicIpAddressName: string (required)
  ##                      : The name of the publicIpAddress.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update PublicIPAddress operation
  var path_594706 = newJObject()
  var query_594707 = newJObject()
  var body_594708 = newJObject()
  add(path_594706, "resourceGroupName", newJString(resourceGroupName))
  add(query_594707, "api-version", newJString(apiVersion))
  add(path_594706, "publicIpAddressName", newJString(publicIpAddressName))
  add(path_594706, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594708 = parameters
  result = call_594705.call(path_594706, query_594707, nil, nil, body_594708)

var publicIPAddressesCreateOrUpdate* = Call_PublicIPAddressesCreateOrUpdate_594696(
    name: "publicIPAddressesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses/{publicIpAddressName}",
    validator: validate_PublicIPAddressesCreateOrUpdate_594697, base: "",
    url: url_PublicIPAddressesCreateOrUpdate_594698, schemes: {Scheme.Https})
type
  Call_PublicIPAddressesGet_594684 = ref object of OpenApiRestCall_593421
proc url_PublicIPAddressesGet_594686(protocol: Scheme; host: string; base: string;
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

proc validate_PublicIPAddressesGet_594685(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get publicIpAddress operation retrieves information about the specified pubicIpAddress
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   publicIpAddressName: JString (required)
  ##                      : The name of the subnet.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594687 = path.getOrDefault("resourceGroupName")
  valid_594687 = validateParameter(valid_594687, JString, required = true,
                                 default = nil)
  if valid_594687 != nil:
    section.add "resourceGroupName", valid_594687
  var valid_594688 = path.getOrDefault("publicIpAddressName")
  valid_594688 = validateParameter(valid_594688, JString, required = true,
                                 default = nil)
  if valid_594688 != nil:
    section.add "publicIpAddressName", valid_594688
  var valid_594689 = path.getOrDefault("subscriptionId")
  valid_594689 = validateParameter(valid_594689, JString, required = true,
                                 default = nil)
  if valid_594689 != nil:
    section.add "subscriptionId", valid_594689
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594690 = query.getOrDefault("api-version")
  valid_594690 = validateParameter(valid_594690, JString, required = true,
                                 default = nil)
  if valid_594690 != nil:
    section.add "api-version", valid_594690
  var valid_594691 = query.getOrDefault("$expand")
  valid_594691 = validateParameter(valid_594691, JString, required = false,
                                 default = nil)
  if valid_594691 != nil:
    section.add "$expand", valid_594691
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594692: Call_PublicIPAddressesGet_594684; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get publicIpAddress operation retrieves information about the specified pubicIpAddress
  ## 
  let valid = call_594692.validator(path, query, header, formData, body)
  let scheme = call_594692.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594692.url(scheme.get, call_594692.host, call_594692.base,
                         call_594692.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594692, url, valid)

proc call*(call_594693: Call_PublicIPAddressesGet_594684;
          resourceGroupName: string; apiVersion: string;
          publicIpAddressName: string; subscriptionId: string; Expand: string = ""): Recallable =
  ## publicIPAddressesGet
  ## The Get publicIpAddress operation retrieves information about the specified pubicIpAddress
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : expand references resources.
  ##   publicIpAddressName: string (required)
  ##                      : The name of the subnet.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594694 = newJObject()
  var query_594695 = newJObject()
  add(path_594694, "resourceGroupName", newJString(resourceGroupName))
  add(query_594695, "api-version", newJString(apiVersion))
  add(query_594695, "$expand", newJString(Expand))
  add(path_594694, "publicIpAddressName", newJString(publicIpAddressName))
  add(path_594694, "subscriptionId", newJString(subscriptionId))
  result = call_594693.call(path_594694, query_594695, nil, nil, nil)

var publicIPAddressesGet* = Call_PublicIPAddressesGet_594684(
    name: "publicIPAddressesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses/{publicIpAddressName}",
    validator: validate_PublicIPAddressesGet_594685, base: "",
    url: url_PublicIPAddressesGet_594686, schemes: {Scheme.Https})
type
  Call_PublicIPAddressesDelete_594709 = ref object of OpenApiRestCall_593421
proc url_PublicIPAddressesDelete_594711(protocol: Scheme; host: string; base: string;
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

proc validate_PublicIPAddressesDelete_594710(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The delete publicIpAddress operation deletes the specified publicIpAddress.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   publicIpAddressName: JString (required)
  ##                      : The name of the subnet.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594712 = path.getOrDefault("resourceGroupName")
  valid_594712 = validateParameter(valid_594712, JString, required = true,
                                 default = nil)
  if valid_594712 != nil:
    section.add "resourceGroupName", valid_594712
  var valid_594713 = path.getOrDefault("publicIpAddressName")
  valid_594713 = validateParameter(valid_594713, JString, required = true,
                                 default = nil)
  if valid_594713 != nil:
    section.add "publicIpAddressName", valid_594713
  var valid_594714 = path.getOrDefault("subscriptionId")
  valid_594714 = validateParameter(valid_594714, JString, required = true,
                                 default = nil)
  if valid_594714 != nil:
    section.add "subscriptionId", valid_594714
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594715 = query.getOrDefault("api-version")
  valid_594715 = validateParameter(valid_594715, JString, required = true,
                                 default = nil)
  if valid_594715 != nil:
    section.add "api-version", valid_594715
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594716: Call_PublicIPAddressesDelete_594709; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete publicIpAddress operation deletes the specified publicIpAddress.
  ## 
  let valid = call_594716.validator(path, query, header, formData, body)
  let scheme = call_594716.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594716.url(scheme.get, call_594716.host, call_594716.base,
                         call_594716.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594716, url, valid)

proc call*(call_594717: Call_PublicIPAddressesDelete_594709;
          resourceGroupName: string; apiVersion: string;
          publicIpAddressName: string; subscriptionId: string): Recallable =
  ## publicIPAddressesDelete
  ## The delete publicIpAddress operation deletes the specified publicIpAddress.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   publicIpAddressName: string (required)
  ##                      : The name of the subnet.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594718 = newJObject()
  var query_594719 = newJObject()
  add(path_594718, "resourceGroupName", newJString(resourceGroupName))
  add(query_594719, "api-version", newJString(apiVersion))
  add(path_594718, "publicIpAddressName", newJString(publicIpAddressName))
  add(path_594718, "subscriptionId", newJString(subscriptionId))
  result = call_594717.call(path_594718, query_594719, nil, nil, nil)

var publicIPAddressesDelete* = Call_PublicIPAddressesDelete_594709(
    name: "publicIPAddressesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses/{publicIpAddressName}",
    validator: validate_PublicIPAddressesDelete_594710, base: "",
    url: url_PublicIPAddressesDelete_594711, schemes: {Scheme.Https})
type
  Call_RouteTablesList_594720 = ref object of OpenApiRestCall_593421
proc url_RouteTablesList_594722(protocol: Scheme; host: string; base: string;
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

proc validate_RouteTablesList_594721(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## The list RouteTables returns all route tables in a resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594723 = path.getOrDefault("resourceGroupName")
  valid_594723 = validateParameter(valid_594723, JString, required = true,
                                 default = nil)
  if valid_594723 != nil:
    section.add "resourceGroupName", valid_594723
  var valid_594724 = path.getOrDefault("subscriptionId")
  valid_594724 = validateParameter(valid_594724, JString, required = true,
                                 default = nil)
  if valid_594724 != nil:
    section.add "subscriptionId", valid_594724
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594725 = query.getOrDefault("api-version")
  valid_594725 = validateParameter(valid_594725, JString, required = true,
                                 default = nil)
  if valid_594725 != nil:
    section.add "api-version", valid_594725
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594726: Call_RouteTablesList_594720; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list RouteTables returns all route tables in a resource group
  ## 
  let valid = call_594726.validator(path, query, header, formData, body)
  let scheme = call_594726.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594726.url(scheme.get, call_594726.host, call_594726.base,
                         call_594726.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594726, url, valid)

proc call*(call_594727: Call_RouteTablesList_594720; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## routeTablesList
  ## The list RouteTables returns all route tables in a resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594728 = newJObject()
  var query_594729 = newJObject()
  add(path_594728, "resourceGroupName", newJString(resourceGroupName))
  add(query_594729, "api-version", newJString(apiVersion))
  add(path_594728, "subscriptionId", newJString(subscriptionId))
  result = call_594727.call(path_594728, query_594729, nil, nil, nil)

var routeTablesList* = Call_RouteTablesList_594720(name: "routeTablesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables",
    validator: validate_RouteTablesList_594721, base: "", url: url_RouteTablesList_594722,
    schemes: {Scheme.Https})
type
  Call_RouteTablesCreateOrUpdate_594742 = ref object of OpenApiRestCall_593421
proc url_RouteTablesCreateOrUpdate_594744(protocol: Scheme; host: string;
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

proc validate_RouteTablesCreateOrUpdate_594743(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put RouteTable operation creates/updates a route table in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   routeTableName: JString (required)
  ##                 : The name of the route table.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594745 = path.getOrDefault("resourceGroupName")
  valid_594745 = validateParameter(valid_594745, JString, required = true,
                                 default = nil)
  if valid_594745 != nil:
    section.add "resourceGroupName", valid_594745
  var valid_594746 = path.getOrDefault("routeTableName")
  valid_594746 = validateParameter(valid_594746, JString, required = true,
                                 default = nil)
  if valid_594746 != nil:
    section.add "routeTableName", valid_594746
  var valid_594747 = path.getOrDefault("subscriptionId")
  valid_594747 = validateParameter(valid_594747, JString, required = true,
                                 default = nil)
  if valid_594747 != nil:
    section.add "subscriptionId", valid_594747
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594748 = query.getOrDefault("api-version")
  valid_594748 = validateParameter(valid_594748, JString, required = true,
                                 default = nil)
  if valid_594748 != nil:
    section.add "api-version", valid_594748
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

proc call*(call_594750: Call_RouteTablesCreateOrUpdate_594742; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put RouteTable operation creates/updates a route table in the specified resource group.
  ## 
  let valid = call_594750.validator(path, query, header, formData, body)
  let scheme = call_594750.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594750.url(scheme.get, call_594750.host, call_594750.base,
                         call_594750.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594750, url, valid)

proc call*(call_594751: Call_RouteTablesCreateOrUpdate_594742;
          resourceGroupName: string; routeTableName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## routeTablesCreateOrUpdate
  ## The Put RouteTable operation creates/updates a route table in the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   routeTableName: string (required)
  ##                 : The name of the route table.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update Route Table operation
  var path_594752 = newJObject()
  var query_594753 = newJObject()
  var body_594754 = newJObject()
  add(path_594752, "resourceGroupName", newJString(resourceGroupName))
  add(path_594752, "routeTableName", newJString(routeTableName))
  add(query_594753, "api-version", newJString(apiVersion))
  add(path_594752, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594754 = parameters
  result = call_594751.call(path_594752, query_594753, nil, nil, body_594754)

var routeTablesCreateOrUpdate* = Call_RouteTablesCreateOrUpdate_594742(
    name: "routeTablesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}",
    validator: validate_RouteTablesCreateOrUpdate_594743, base: "",
    url: url_RouteTablesCreateOrUpdate_594744, schemes: {Scheme.Https})
type
  Call_RouteTablesGet_594730 = ref object of OpenApiRestCall_593421
proc url_RouteTablesGet_594732(protocol: Scheme; host: string; base: string;
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

proc validate_RouteTablesGet_594731(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## The Get RouteTables operation retrieves information about the specified route table.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   routeTableName: JString (required)
  ##                 : The name of the route table.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594733 = path.getOrDefault("resourceGroupName")
  valid_594733 = validateParameter(valid_594733, JString, required = true,
                                 default = nil)
  if valid_594733 != nil:
    section.add "resourceGroupName", valid_594733
  var valid_594734 = path.getOrDefault("routeTableName")
  valid_594734 = validateParameter(valid_594734, JString, required = true,
                                 default = nil)
  if valid_594734 != nil:
    section.add "routeTableName", valid_594734
  var valid_594735 = path.getOrDefault("subscriptionId")
  valid_594735 = validateParameter(valid_594735, JString, required = true,
                                 default = nil)
  if valid_594735 != nil:
    section.add "subscriptionId", valid_594735
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594736 = query.getOrDefault("api-version")
  valid_594736 = validateParameter(valid_594736, JString, required = true,
                                 default = nil)
  if valid_594736 != nil:
    section.add "api-version", valid_594736
  var valid_594737 = query.getOrDefault("$expand")
  valid_594737 = validateParameter(valid_594737, JString, required = false,
                                 default = nil)
  if valid_594737 != nil:
    section.add "$expand", valid_594737
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594738: Call_RouteTablesGet_594730; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get RouteTables operation retrieves information about the specified route table.
  ## 
  let valid = call_594738.validator(path, query, header, formData, body)
  let scheme = call_594738.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594738.url(scheme.get, call_594738.host, call_594738.base,
                         call_594738.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594738, url, valid)

proc call*(call_594739: Call_RouteTablesGet_594730; resourceGroupName: string;
          routeTableName: string; apiVersion: string; subscriptionId: string;
          Expand: string = ""): Recallable =
  ## routeTablesGet
  ## The Get RouteTables operation retrieves information about the specified route table.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   routeTableName: string (required)
  ##                 : The name of the route table.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : expand references resources.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594740 = newJObject()
  var query_594741 = newJObject()
  add(path_594740, "resourceGroupName", newJString(resourceGroupName))
  add(path_594740, "routeTableName", newJString(routeTableName))
  add(query_594741, "api-version", newJString(apiVersion))
  add(query_594741, "$expand", newJString(Expand))
  add(path_594740, "subscriptionId", newJString(subscriptionId))
  result = call_594739.call(path_594740, query_594741, nil, nil, nil)

var routeTablesGet* = Call_RouteTablesGet_594730(name: "routeTablesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}",
    validator: validate_RouteTablesGet_594731, base: "", url: url_RouteTablesGet_594732,
    schemes: {Scheme.Https})
type
  Call_RouteTablesDelete_594755 = ref object of OpenApiRestCall_593421
proc url_RouteTablesDelete_594757(protocol: Scheme; host: string; base: string;
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

proc validate_RouteTablesDelete_594756(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## The Delete RouteTable operation deletes the specified Route Table
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   routeTableName: JString (required)
  ##                 : The name of the route table.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594758 = path.getOrDefault("resourceGroupName")
  valid_594758 = validateParameter(valid_594758, JString, required = true,
                                 default = nil)
  if valid_594758 != nil:
    section.add "resourceGroupName", valid_594758
  var valid_594759 = path.getOrDefault("routeTableName")
  valid_594759 = validateParameter(valid_594759, JString, required = true,
                                 default = nil)
  if valid_594759 != nil:
    section.add "routeTableName", valid_594759
  var valid_594760 = path.getOrDefault("subscriptionId")
  valid_594760 = validateParameter(valid_594760, JString, required = true,
                                 default = nil)
  if valid_594760 != nil:
    section.add "subscriptionId", valid_594760
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594761 = query.getOrDefault("api-version")
  valid_594761 = validateParameter(valid_594761, JString, required = true,
                                 default = nil)
  if valid_594761 != nil:
    section.add "api-version", valid_594761
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594762: Call_RouteTablesDelete_594755; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete RouteTable operation deletes the specified Route Table
  ## 
  let valid = call_594762.validator(path, query, header, formData, body)
  let scheme = call_594762.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594762.url(scheme.get, call_594762.host, call_594762.base,
                         call_594762.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594762, url, valid)

proc call*(call_594763: Call_RouteTablesDelete_594755; resourceGroupName: string;
          routeTableName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## routeTablesDelete
  ## The Delete RouteTable operation deletes the specified Route Table
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   routeTableName: string (required)
  ##                 : The name of the route table.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594764 = newJObject()
  var query_594765 = newJObject()
  add(path_594764, "resourceGroupName", newJString(resourceGroupName))
  add(path_594764, "routeTableName", newJString(routeTableName))
  add(query_594765, "api-version", newJString(apiVersion))
  add(path_594764, "subscriptionId", newJString(subscriptionId))
  result = call_594763.call(path_594764, query_594765, nil, nil, nil)

var routeTablesDelete* = Call_RouteTablesDelete_594755(name: "routeTablesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}",
    validator: validate_RouteTablesDelete_594756, base: "",
    url: url_RouteTablesDelete_594757, schemes: {Scheme.Https})
type
  Call_RoutesList_594766 = ref object of OpenApiRestCall_593421
proc url_RoutesList_594768(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_RoutesList_594767(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## The List network security rule operation retrieves all the routes in a route table.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   routeTableName: JString (required)
  ##                 : The name of the route table.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594769 = path.getOrDefault("resourceGroupName")
  valid_594769 = validateParameter(valid_594769, JString, required = true,
                                 default = nil)
  if valid_594769 != nil:
    section.add "resourceGroupName", valid_594769
  var valid_594770 = path.getOrDefault("routeTableName")
  valid_594770 = validateParameter(valid_594770, JString, required = true,
                                 default = nil)
  if valid_594770 != nil:
    section.add "routeTableName", valid_594770
  var valid_594771 = path.getOrDefault("subscriptionId")
  valid_594771 = validateParameter(valid_594771, JString, required = true,
                                 default = nil)
  if valid_594771 != nil:
    section.add "subscriptionId", valid_594771
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594772 = query.getOrDefault("api-version")
  valid_594772 = validateParameter(valid_594772, JString, required = true,
                                 default = nil)
  if valid_594772 != nil:
    section.add "api-version", valid_594772
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594773: Call_RoutesList_594766; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List network security rule operation retrieves all the routes in a route table.
  ## 
  let valid = call_594773.validator(path, query, header, formData, body)
  let scheme = call_594773.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594773.url(scheme.get, call_594773.host, call_594773.base,
                         call_594773.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594773, url, valid)

proc call*(call_594774: Call_RoutesList_594766; resourceGroupName: string;
          routeTableName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## routesList
  ## The List network security rule operation retrieves all the routes in a route table.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   routeTableName: string (required)
  ##                 : The name of the route table.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594775 = newJObject()
  var query_594776 = newJObject()
  add(path_594775, "resourceGroupName", newJString(resourceGroupName))
  add(path_594775, "routeTableName", newJString(routeTableName))
  add(query_594776, "api-version", newJString(apiVersion))
  add(path_594775, "subscriptionId", newJString(subscriptionId))
  result = call_594774.call(path_594775, query_594776, nil, nil, nil)

var routesList* = Call_RoutesList_594766(name: "routesList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}/routes",
                                      validator: validate_RoutesList_594767,
                                      base: "", url: url_RoutesList_594768,
                                      schemes: {Scheme.Https})
type
  Call_RoutesCreateOrUpdate_594789 = ref object of OpenApiRestCall_593421
proc url_RoutesCreateOrUpdate_594791(protocol: Scheme; host: string; base: string;
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

proc validate_RoutesCreateOrUpdate_594790(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put route operation creates/updates a route in the specified route table
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   routeTableName: JString (required)
  ##                 : The name of the route table.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   routeName: JString (required)
  ##            : The name of the route.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594792 = path.getOrDefault("resourceGroupName")
  valid_594792 = validateParameter(valid_594792, JString, required = true,
                                 default = nil)
  if valid_594792 != nil:
    section.add "resourceGroupName", valid_594792
  var valid_594793 = path.getOrDefault("routeTableName")
  valid_594793 = validateParameter(valid_594793, JString, required = true,
                                 default = nil)
  if valid_594793 != nil:
    section.add "routeTableName", valid_594793
  var valid_594794 = path.getOrDefault("subscriptionId")
  valid_594794 = validateParameter(valid_594794, JString, required = true,
                                 default = nil)
  if valid_594794 != nil:
    section.add "subscriptionId", valid_594794
  var valid_594795 = path.getOrDefault("routeName")
  valid_594795 = validateParameter(valid_594795, JString, required = true,
                                 default = nil)
  if valid_594795 != nil:
    section.add "routeName", valid_594795
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594796 = query.getOrDefault("api-version")
  valid_594796 = validateParameter(valid_594796, JString, required = true,
                                 default = nil)
  if valid_594796 != nil:
    section.add "api-version", valid_594796
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

proc call*(call_594798: Call_RoutesCreateOrUpdate_594789; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put route operation creates/updates a route in the specified route table
  ## 
  let valid = call_594798.validator(path, query, header, formData, body)
  let scheme = call_594798.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594798.url(scheme.get, call_594798.host, call_594798.base,
                         call_594798.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594798, url, valid)

proc call*(call_594799: Call_RoutesCreateOrUpdate_594789;
          resourceGroupName: string; routeTableName: string; apiVersion: string;
          subscriptionId: string; routeName: string; routeParameters: JsonNode): Recallable =
  ## routesCreateOrUpdate
  ## The Put route operation creates/updates a route in the specified route table
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   routeTableName: string (required)
  ##                 : The name of the route table.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   routeName: string (required)
  ##            : The name of the route.
  ##   routeParameters: JObject (required)
  ##                  : Parameters supplied to the create/update route operation
  var path_594800 = newJObject()
  var query_594801 = newJObject()
  var body_594802 = newJObject()
  add(path_594800, "resourceGroupName", newJString(resourceGroupName))
  add(path_594800, "routeTableName", newJString(routeTableName))
  add(query_594801, "api-version", newJString(apiVersion))
  add(path_594800, "subscriptionId", newJString(subscriptionId))
  add(path_594800, "routeName", newJString(routeName))
  if routeParameters != nil:
    body_594802 = routeParameters
  result = call_594799.call(path_594800, query_594801, nil, nil, body_594802)

var routesCreateOrUpdate* = Call_RoutesCreateOrUpdate_594789(
    name: "routesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}/routes/{routeName}",
    validator: validate_RoutesCreateOrUpdate_594790, base: "",
    url: url_RoutesCreateOrUpdate_594791, schemes: {Scheme.Https})
type
  Call_RoutesGet_594777 = ref object of OpenApiRestCall_593421
proc url_RoutesGet_594779(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_RoutesGet_594778(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get route operation retrieves information about the specified route from the route table.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   routeTableName: JString (required)
  ##                 : The name of the route table.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   routeName: JString (required)
  ##            : The name of the route.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594780 = path.getOrDefault("resourceGroupName")
  valid_594780 = validateParameter(valid_594780, JString, required = true,
                                 default = nil)
  if valid_594780 != nil:
    section.add "resourceGroupName", valid_594780
  var valid_594781 = path.getOrDefault("routeTableName")
  valid_594781 = validateParameter(valid_594781, JString, required = true,
                                 default = nil)
  if valid_594781 != nil:
    section.add "routeTableName", valid_594781
  var valid_594782 = path.getOrDefault("subscriptionId")
  valid_594782 = validateParameter(valid_594782, JString, required = true,
                                 default = nil)
  if valid_594782 != nil:
    section.add "subscriptionId", valid_594782
  var valid_594783 = path.getOrDefault("routeName")
  valid_594783 = validateParameter(valid_594783, JString, required = true,
                                 default = nil)
  if valid_594783 != nil:
    section.add "routeName", valid_594783
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594784 = query.getOrDefault("api-version")
  valid_594784 = validateParameter(valid_594784, JString, required = true,
                                 default = nil)
  if valid_594784 != nil:
    section.add "api-version", valid_594784
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594785: Call_RoutesGet_594777; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get route operation retrieves information about the specified route from the route table.
  ## 
  let valid = call_594785.validator(path, query, header, formData, body)
  let scheme = call_594785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594785.url(scheme.get, call_594785.host, call_594785.base,
                         call_594785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594785, url, valid)

proc call*(call_594786: Call_RoutesGet_594777; resourceGroupName: string;
          routeTableName: string; apiVersion: string; subscriptionId: string;
          routeName: string): Recallable =
  ## routesGet
  ## The Get route operation retrieves information about the specified route from the route table.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   routeTableName: string (required)
  ##                 : The name of the route table.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   routeName: string (required)
  ##            : The name of the route.
  var path_594787 = newJObject()
  var query_594788 = newJObject()
  add(path_594787, "resourceGroupName", newJString(resourceGroupName))
  add(path_594787, "routeTableName", newJString(routeTableName))
  add(query_594788, "api-version", newJString(apiVersion))
  add(path_594787, "subscriptionId", newJString(subscriptionId))
  add(path_594787, "routeName", newJString(routeName))
  result = call_594786.call(path_594787, query_594788, nil, nil, nil)

var routesGet* = Call_RoutesGet_594777(name: "routesGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}/routes/{routeName}",
                                    validator: validate_RoutesGet_594778,
                                    base: "", url: url_RoutesGet_594779,
                                    schemes: {Scheme.Https})
type
  Call_RoutesDelete_594803 = ref object of OpenApiRestCall_593421
proc url_RoutesDelete_594805(protocol: Scheme; host: string; base: string;
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

proc validate_RoutesDelete_594804(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## The delete route operation deletes the specified route from a route table.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   routeTableName: JString (required)
  ##                 : The name of the route table.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   routeName: JString (required)
  ##            : The name of the route.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594806 = path.getOrDefault("resourceGroupName")
  valid_594806 = validateParameter(valid_594806, JString, required = true,
                                 default = nil)
  if valid_594806 != nil:
    section.add "resourceGroupName", valid_594806
  var valid_594807 = path.getOrDefault("routeTableName")
  valid_594807 = validateParameter(valid_594807, JString, required = true,
                                 default = nil)
  if valid_594807 != nil:
    section.add "routeTableName", valid_594807
  var valid_594808 = path.getOrDefault("subscriptionId")
  valid_594808 = validateParameter(valid_594808, JString, required = true,
                                 default = nil)
  if valid_594808 != nil:
    section.add "subscriptionId", valid_594808
  var valid_594809 = path.getOrDefault("routeName")
  valid_594809 = validateParameter(valid_594809, JString, required = true,
                                 default = nil)
  if valid_594809 != nil:
    section.add "routeName", valid_594809
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594810 = query.getOrDefault("api-version")
  valid_594810 = validateParameter(valid_594810, JString, required = true,
                                 default = nil)
  if valid_594810 != nil:
    section.add "api-version", valid_594810
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594811: Call_RoutesDelete_594803; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete route operation deletes the specified route from a route table.
  ## 
  let valid = call_594811.validator(path, query, header, formData, body)
  let scheme = call_594811.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594811.url(scheme.get, call_594811.host, call_594811.base,
                         call_594811.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594811, url, valid)

proc call*(call_594812: Call_RoutesDelete_594803; resourceGroupName: string;
          routeTableName: string; apiVersion: string; subscriptionId: string;
          routeName: string): Recallable =
  ## routesDelete
  ## The delete route operation deletes the specified route from a route table.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   routeTableName: string (required)
  ##                 : The name of the route table.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   routeName: string (required)
  ##            : The name of the route.
  var path_594813 = newJObject()
  var query_594814 = newJObject()
  add(path_594813, "resourceGroupName", newJString(resourceGroupName))
  add(path_594813, "routeTableName", newJString(routeTableName))
  add(query_594814, "api-version", newJString(apiVersion))
  add(path_594813, "subscriptionId", newJString(subscriptionId))
  add(path_594813, "routeName", newJString(routeName))
  result = call_594812.call(path_594813, query_594814, nil, nil, nil)

var routesDelete* = Call_RoutesDelete_594803(name: "routesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}/routes/{routeName}",
    validator: validate_RoutesDelete_594804, base: "", url: url_RoutesDelete_594805,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysList_594815 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworkGatewaysList_594817(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGatewaysList_594816(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List VirtualNetworkGateways operation retrieves all the virtual network gateways stored.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594818 = path.getOrDefault("resourceGroupName")
  valid_594818 = validateParameter(valid_594818, JString, required = true,
                                 default = nil)
  if valid_594818 != nil:
    section.add "resourceGroupName", valid_594818
  var valid_594819 = path.getOrDefault("subscriptionId")
  valid_594819 = validateParameter(valid_594819, JString, required = true,
                                 default = nil)
  if valid_594819 != nil:
    section.add "subscriptionId", valid_594819
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594820 = query.getOrDefault("api-version")
  valid_594820 = validateParameter(valid_594820, JString, required = true,
                                 default = nil)
  if valid_594820 != nil:
    section.add "api-version", valid_594820
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594821: Call_VirtualNetworkGatewaysList_594815; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List VirtualNetworkGateways operation retrieves all the virtual network gateways stored.
  ## 
  let valid = call_594821.validator(path, query, header, formData, body)
  let scheme = call_594821.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594821.url(scheme.get, call_594821.host, call_594821.base,
                         call_594821.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594821, url, valid)

proc call*(call_594822: Call_VirtualNetworkGatewaysList_594815;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualNetworkGatewaysList
  ## The List VirtualNetworkGateways operation retrieves all the virtual network gateways stored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594823 = newJObject()
  var query_594824 = newJObject()
  add(path_594823, "resourceGroupName", newJString(resourceGroupName))
  add(query_594824, "api-version", newJString(apiVersion))
  add(path_594823, "subscriptionId", newJString(subscriptionId))
  result = call_594822.call(path_594823, query_594824, nil, nil, nil)

var virtualNetworkGatewaysList* = Call_VirtualNetworkGatewaysList_594815(
    name: "virtualNetworkGatewaysList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways",
    validator: validate_VirtualNetworkGatewaysList_594816, base: "",
    url: url_VirtualNetworkGatewaysList_594817, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysCreateOrUpdate_594836 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworkGatewaysCreateOrUpdate_594838(protocol: Scheme;
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

proc validate_VirtualNetworkGatewaysCreateOrUpdate_594837(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put VirtualNetworkGateway operation creates/updates a virtual network gateway in the specified resource group through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: JString (required)
  ##                            : The name of the virtual network gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594839 = path.getOrDefault("resourceGroupName")
  valid_594839 = validateParameter(valid_594839, JString, required = true,
                                 default = nil)
  if valid_594839 != nil:
    section.add "resourceGroupName", valid_594839
  var valid_594840 = path.getOrDefault("subscriptionId")
  valid_594840 = validateParameter(valid_594840, JString, required = true,
                                 default = nil)
  if valid_594840 != nil:
    section.add "subscriptionId", valid_594840
  var valid_594841 = path.getOrDefault("virtualNetworkGatewayName")
  valid_594841 = validateParameter(valid_594841, JString, required = true,
                                 default = nil)
  if valid_594841 != nil:
    section.add "virtualNetworkGatewayName", valid_594841
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594842 = query.getOrDefault("api-version")
  valid_594842 = validateParameter(valid_594842, JString, required = true,
                                 default = nil)
  if valid_594842 != nil:
    section.add "api-version", valid_594842
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

proc call*(call_594844: Call_VirtualNetworkGatewaysCreateOrUpdate_594836;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put VirtualNetworkGateway operation creates/updates a virtual network gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_594844.validator(path, query, header, formData, body)
  let scheme = call_594844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594844.url(scheme.get, call_594844.host, call_594844.base,
                         call_594844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594844, url, valid)

proc call*(call_594845: Call_VirtualNetworkGatewaysCreateOrUpdate_594836;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; virtualNetworkGatewayName: string): Recallable =
  ## virtualNetworkGatewaysCreateOrUpdate
  ## The Put VirtualNetworkGateway operation creates/updates a virtual network gateway in the specified resource group through Network resource provider.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Begin Create or update Virtual Network Gateway operation through Network resource provider.
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The name of the virtual network gateway.
  var path_594846 = newJObject()
  var query_594847 = newJObject()
  var body_594848 = newJObject()
  add(path_594846, "resourceGroupName", newJString(resourceGroupName))
  add(query_594847, "api-version", newJString(apiVersion))
  add(path_594846, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594848 = parameters
  add(path_594846, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_594845.call(path_594846, query_594847, nil, nil, body_594848)

var virtualNetworkGatewaysCreateOrUpdate* = Call_VirtualNetworkGatewaysCreateOrUpdate_594836(
    name: "virtualNetworkGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}",
    validator: validate_VirtualNetworkGatewaysCreateOrUpdate_594837, base: "",
    url: url_VirtualNetworkGatewaysCreateOrUpdate_594838, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGet_594825 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworkGatewaysGet_594827(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGatewaysGet_594826(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get VirtualNetworkGateway operation retrieves information about the specified virtual network gateway through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: JString (required)
  ##                            : The name of the virtual network gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594828 = path.getOrDefault("resourceGroupName")
  valid_594828 = validateParameter(valid_594828, JString, required = true,
                                 default = nil)
  if valid_594828 != nil:
    section.add "resourceGroupName", valid_594828
  var valid_594829 = path.getOrDefault("subscriptionId")
  valid_594829 = validateParameter(valid_594829, JString, required = true,
                                 default = nil)
  if valid_594829 != nil:
    section.add "subscriptionId", valid_594829
  var valid_594830 = path.getOrDefault("virtualNetworkGatewayName")
  valid_594830 = validateParameter(valid_594830, JString, required = true,
                                 default = nil)
  if valid_594830 != nil:
    section.add "virtualNetworkGatewayName", valid_594830
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594831 = query.getOrDefault("api-version")
  valid_594831 = validateParameter(valid_594831, JString, required = true,
                                 default = nil)
  if valid_594831 != nil:
    section.add "api-version", valid_594831
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594832: Call_VirtualNetworkGatewaysGet_594825; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get VirtualNetworkGateway operation retrieves information about the specified virtual network gateway through Network resource provider.
  ## 
  let valid = call_594832.validator(path, query, header, formData, body)
  let scheme = call_594832.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594832.url(scheme.get, call_594832.host, call_594832.base,
                         call_594832.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594832, url, valid)

proc call*(call_594833: Call_VirtualNetworkGatewaysGet_594825;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkGatewayName: string): Recallable =
  ## virtualNetworkGatewaysGet
  ## The Get VirtualNetworkGateway operation retrieves information about the specified virtual network gateway through Network resource provider.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The name of the virtual network gateway.
  var path_594834 = newJObject()
  var query_594835 = newJObject()
  add(path_594834, "resourceGroupName", newJString(resourceGroupName))
  add(query_594835, "api-version", newJString(apiVersion))
  add(path_594834, "subscriptionId", newJString(subscriptionId))
  add(path_594834, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_594833.call(path_594834, query_594835, nil, nil, nil)

var virtualNetworkGatewaysGet* = Call_VirtualNetworkGatewaysGet_594825(
    name: "virtualNetworkGatewaysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}",
    validator: validate_VirtualNetworkGatewaysGet_594826, base: "",
    url: url_VirtualNetworkGatewaysGet_594827, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysDelete_594849 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworkGatewaysDelete_594851(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGatewaysDelete_594850(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Delete VirtualNetworkGateway operation deletes the specified virtual network Gateway through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: JString (required)
  ##                            : The name of the virtual network gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594852 = path.getOrDefault("resourceGroupName")
  valid_594852 = validateParameter(valid_594852, JString, required = true,
                                 default = nil)
  if valid_594852 != nil:
    section.add "resourceGroupName", valid_594852
  var valid_594853 = path.getOrDefault("subscriptionId")
  valid_594853 = validateParameter(valid_594853, JString, required = true,
                                 default = nil)
  if valid_594853 != nil:
    section.add "subscriptionId", valid_594853
  var valid_594854 = path.getOrDefault("virtualNetworkGatewayName")
  valid_594854 = validateParameter(valid_594854, JString, required = true,
                                 default = nil)
  if valid_594854 != nil:
    section.add "virtualNetworkGatewayName", valid_594854
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594855 = query.getOrDefault("api-version")
  valid_594855 = validateParameter(valid_594855, JString, required = true,
                                 default = nil)
  if valid_594855 != nil:
    section.add "api-version", valid_594855
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594856: Call_VirtualNetworkGatewaysDelete_594849; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete VirtualNetworkGateway operation deletes the specified virtual network Gateway through Network resource provider.
  ## 
  let valid = call_594856.validator(path, query, header, formData, body)
  let scheme = call_594856.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594856.url(scheme.get, call_594856.host, call_594856.base,
                         call_594856.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594856, url, valid)

proc call*(call_594857: Call_VirtualNetworkGatewaysDelete_594849;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkGatewayName: string): Recallable =
  ## virtualNetworkGatewaysDelete
  ## The Delete VirtualNetworkGateway operation deletes the specified virtual network Gateway through Network resource provider.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The name of the virtual network gateway.
  var path_594858 = newJObject()
  var query_594859 = newJObject()
  add(path_594858, "resourceGroupName", newJString(resourceGroupName))
  add(query_594859, "api-version", newJString(apiVersion))
  add(path_594858, "subscriptionId", newJString(subscriptionId))
  add(path_594858, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_594857.call(path_594858, query_594859, nil, nil, nil)

var virtualNetworkGatewaysDelete* = Call_VirtualNetworkGatewaysDelete_594849(
    name: "virtualNetworkGatewaysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}",
    validator: validate_VirtualNetworkGatewaysDelete_594850, base: "",
    url: url_VirtualNetworkGatewaysDelete_594851, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGeneratevpnclientpackage_594860 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworkGatewaysGeneratevpnclientpackage_594862(protocol: Scheme;
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

proc validate_VirtualNetworkGatewaysGeneratevpnclientpackage_594861(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The Generatevpnclientpackage operation generates Vpn client package for P2S client of the virtual network gateway in the specified resource group through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: JString (required)
  ##                            : The name of the virtual network gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594863 = path.getOrDefault("resourceGroupName")
  valid_594863 = validateParameter(valid_594863, JString, required = true,
                                 default = nil)
  if valid_594863 != nil:
    section.add "resourceGroupName", valid_594863
  var valid_594864 = path.getOrDefault("subscriptionId")
  valid_594864 = validateParameter(valid_594864, JString, required = true,
                                 default = nil)
  if valid_594864 != nil:
    section.add "subscriptionId", valid_594864
  var valid_594865 = path.getOrDefault("virtualNetworkGatewayName")
  valid_594865 = validateParameter(valid_594865, JString, required = true,
                                 default = nil)
  if valid_594865 != nil:
    section.add "virtualNetworkGatewayName", valid_594865
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594866 = query.getOrDefault("api-version")
  valid_594866 = validateParameter(valid_594866, JString, required = true,
                                 default = nil)
  if valid_594866 != nil:
    section.add "api-version", valid_594866
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

proc call*(call_594868: Call_VirtualNetworkGatewaysGeneratevpnclientpackage_594860;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Generatevpnclientpackage operation generates Vpn client package for P2S client of the virtual network gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_594868.validator(path, query, header, formData, body)
  let scheme = call_594868.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594868.url(scheme.get, call_594868.host, call_594868.base,
                         call_594868.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594868, url, valid)

proc call*(call_594869: Call_VirtualNetworkGatewaysGeneratevpnclientpackage_594860;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; virtualNetworkGatewayName: string): Recallable =
  ## virtualNetworkGatewaysGeneratevpnclientpackage
  ## The Generatevpnclientpackage operation generates Vpn client package for P2S client of the virtual network gateway in the specified resource group through Network resource provider.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Begin Generating  Virtual Network Gateway Vpn client package operation through Network resource provider.
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The name of the virtual network gateway.
  var path_594870 = newJObject()
  var query_594871 = newJObject()
  var body_594872 = newJObject()
  add(path_594870, "resourceGroupName", newJString(resourceGroupName))
  add(query_594871, "api-version", newJString(apiVersion))
  add(path_594870, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594872 = parameters
  add(path_594870, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_594869.call(path_594870, query_594871, nil, nil, body_594872)

var virtualNetworkGatewaysGeneratevpnclientpackage* = Call_VirtualNetworkGatewaysGeneratevpnclientpackage_594860(
    name: "virtualNetworkGatewaysGeneratevpnclientpackage",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/generatevpnclientpackage",
    validator: validate_VirtualNetworkGatewaysGeneratevpnclientpackage_594861,
    base: "", url: url_VirtualNetworkGatewaysGeneratevpnclientpackage_594862,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysReset_594873 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworkGatewaysReset_594875(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGatewaysReset_594874(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Reset VirtualNetworkGateway operation resets the primary of the virtual network gateway in the specified resource group through Network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkGatewayName: JString (required)
  ##                            : The name of the virtual network gateway.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594876 = path.getOrDefault("resourceGroupName")
  valid_594876 = validateParameter(valid_594876, JString, required = true,
                                 default = nil)
  if valid_594876 != nil:
    section.add "resourceGroupName", valid_594876
  var valid_594877 = path.getOrDefault("subscriptionId")
  valid_594877 = validateParameter(valid_594877, JString, required = true,
                                 default = nil)
  if valid_594877 != nil:
    section.add "subscriptionId", valid_594877
  var valid_594878 = path.getOrDefault("virtualNetworkGatewayName")
  valid_594878 = validateParameter(valid_594878, JString, required = true,
                                 default = nil)
  if valid_594878 != nil:
    section.add "virtualNetworkGatewayName", valid_594878
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594879 = query.getOrDefault("api-version")
  valid_594879 = validateParameter(valid_594879, JString, required = true,
                                 default = nil)
  if valid_594879 != nil:
    section.add "api-version", valid_594879
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

proc call*(call_594881: Call_VirtualNetworkGatewaysReset_594873; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Reset VirtualNetworkGateway operation resets the primary of the virtual network gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_594881.validator(path, query, header, formData, body)
  let scheme = call_594881.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594881.url(scheme.get, call_594881.host, call_594881.base,
                         call_594881.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594881, url, valid)

proc call*(call_594882: Call_VirtualNetworkGatewaysReset_594873;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; virtualNetworkGatewayName: string): Recallable =
  ## virtualNetworkGatewaysReset
  ## The Reset VirtualNetworkGateway operation resets the primary of the virtual network gateway in the specified resource group through Network resource provider.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Begin Reset Virtual Network Gateway operation through Network resource provider.
  ##   virtualNetworkGatewayName: string (required)
  ##                            : The name of the virtual network gateway.
  var path_594883 = newJObject()
  var query_594884 = newJObject()
  var body_594885 = newJObject()
  add(path_594883, "resourceGroupName", newJString(resourceGroupName))
  add(query_594884, "api-version", newJString(apiVersion))
  add(path_594883, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594885 = parameters
  add(path_594883, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_594882.call(path_594883, query_594884, nil, nil, body_594885)

var virtualNetworkGatewaysReset* = Call_VirtualNetworkGatewaysReset_594873(
    name: "virtualNetworkGatewaysReset", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/reset",
    validator: validate_VirtualNetworkGatewaysReset_594874, base: "",
    url: url_VirtualNetworkGatewaysReset_594875, schemes: {Scheme.Https})
type
  Call_VirtualNetworksList_594886 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworksList_594888(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksList_594887(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## The list VirtualNetwork returns all Virtual Networks in a resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594889 = path.getOrDefault("resourceGroupName")
  valid_594889 = validateParameter(valid_594889, JString, required = true,
                                 default = nil)
  if valid_594889 != nil:
    section.add "resourceGroupName", valid_594889
  var valid_594890 = path.getOrDefault("subscriptionId")
  valid_594890 = validateParameter(valid_594890, JString, required = true,
                                 default = nil)
  if valid_594890 != nil:
    section.add "subscriptionId", valid_594890
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594891 = query.getOrDefault("api-version")
  valid_594891 = validateParameter(valid_594891, JString, required = true,
                                 default = nil)
  if valid_594891 != nil:
    section.add "api-version", valid_594891
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594892: Call_VirtualNetworksList_594886; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list VirtualNetwork returns all Virtual Networks in a resource group
  ## 
  let valid = call_594892.validator(path, query, header, formData, body)
  let scheme = call_594892.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594892.url(scheme.get, call_594892.host, call_594892.base,
                         call_594892.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594892, url, valid)

proc call*(call_594893: Call_VirtualNetworksList_594886; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## virtualNetworksList
  ## The list VirtualNetwork returns all Virtual Networks in a resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594894 = newJObject()
  var query_594895 = newJObject()
  add(path_594894, "resourceGroupName", newJString(resourceGroupName))
  add(query_594895, "api-version", newJString(apiVersion))
  add(path_594894, "subscriptionId", newJString(subscriptionId))
  result = call_594893.call(path_594894, query_594895, nil, nil, nil)

var virtualNetworksList* = Call_VirtualNetworksList_594886(
    name: "virtualNetworksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks",
    validator: validate_VirtualNetworksList_594887, base: "",
    url: url_VirtualNetworksList_594888, schemes: {Scheme.Https})
type
  Call_VirtualNetworksCreateOrUpdate_594908 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworksCreateOrUpdate_594910(protocol: Scheme; host: string;
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

proc validate_VirtualNetworksCreateOrUpdate_594909(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put VirtualNetwork operation creates/updates a virtual network in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594911 = path.getOrDefault("resourceGroupName")
  valid_594911 = validateParameter(valid_594911, JString, required = true,
                                 default = nil)
  if valid_594911 != nil:
    section.add "resourceGroupName", valid_594911
  var valid_594912 = path.getOrDefault("subscriptionId")
  valid_594912 = validateParameter(valid_594912, JString, required = true,
                                 default = nil)
  if valid_594912 != nil:
    section.add "subscriptionId", valid_594912
  var valid_594913 = path.getOrDefault("virtualNetworkName")
  valid_594913 = validateParameter(valid_594913, JString, required = true,
                                 default = nil)
  if valid_594913 != nil:
    section.add "virtualNetworkName", valid_594913
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594914 = query.getOrDefault("api-version")
  valid_594914 = validateParameter(valid_594914, JString, required = true,
                                 default = nil)
  if valid_594914 != nil:
    section.add "api-version", valid_594914
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

proc call*(call_594916: Call_VirtualNetworksCreateOrUpdate_594908; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put VirtualNetwork operation creates/updates a virtual network in the specified resource group.
  ## 
  let valid = call_594916.validator(path, query, header, formData, body)
  let scheme = call_594916.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594916.url(scheme.get, call_594916.host, call_594916.base,
                         call_594916.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594916, url, valid)

proc call*(call_594917: Call_VirtualNetworksCreateOrUpdate_594908;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkName: string; parameters: JsonNode): Recallable =
  ## virtualNetworksCreateOrUpdate
  ## The Put VirtualNetwork operation creates/updates a virtual network in the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update Virtual Network operation
  var path_594918 = newJObject()
  var query_594919 = newJObject()
  var body_594920 = newJObject()
  add(path_594918, "resourceGroupName", newJString(resourceGroupName))
  add(query_594919, "api-version", newJString(apiVersion))
  add(path_594918, "subscriptionId", newJString(subscriptionId))
  add(path_594918, "virtualNetworkName", newJString(virtualNetworkName))
  if parameters != nil:
    body_594920 = parameters
  result = call_594917.call(path_594918, query_594919, nil, nil, body_594920)

var virtualNetworksCreateOrUpdate* = Call_VirtualNetworksCreateOrUpdate_594908(
    name: "virtualNetworksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworksCreateOrUpdate_594909, base: "",
    url: url_VirtualNetworksCreateOrUpdate_594910, schemes: {Scheme.Https})
type
  Call_VirtualNetworksGet_594896 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworksGet_594898(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksGet_594897(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## The Get VirtualNetwork operation retrieves information about the specified virtual network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594899 = path.getOrDefault("resourceGroupName")
  valid_594899 = validateParameter(valid_594899, JString, required = true,
                                 default = nil)
  if valid_594899 != nil:
    section.add "resourceGroupName", valid_594899
  var valid_594900 = path.getOrDefault("subscriptionId")
  valid_594900 = validateParameter(valid_594900, JString, required = true,
                                 default = nil)
  if valid_594900 != nil:
    section.add "subscriptionId", valid_594900
  var valid_594901 = path.getOrDefault("virtualNetworkName")
  valid_594901 = validateParameter(valid_594901, JString, required = true,
                                 default = nil)
  if valid_594901 != nil:
    section.add "virtualNetworkName", valid_594901
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594902 = query.getOrDefault("api-version")
  valid_594902 = validateParameter(valid_594902, JString, required = true,
                                 default = nil)
  if valid_594902 != nil:
    section.add "api-version", valid_594902
  var valid_594903 = query.getOrDefault("$expand")
  valid_594903 = validateParameter(valid_594903, JString, required = false,
                                 default = nil)
  if valid_594903 != nil:
    section.add "$expand", valid_594903
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594904: Call_VirtualNetworksGet_594896; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get VirtualNetwork operation retrieves information about the specified virtual network.
  ## 
  let valid = call_594904.validator(path, query, header, formData, body)
  let scheme = call_594904.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594904.url(scheme.get, call_594904.host, call_594904.base,
                         call_594904.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594904, url, valid)

proc call*(call_594905: Call_VirtualNetworksGet_594896; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; virtualNetworkName: string;
          Expand: string = ""): Recallable =
  ## virtualNetworksGet
  ## The Get VirtualNetwork operation retrieves information about the specified virtual network.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : expand references resources.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_594906 = newJObject()
  var query_594907 = newJObject()
  add(path_594906, "resourceGroupName", newJString(resourceGroupName))
  add(query_594907, "api-version", newJString(apiVersion))
  add(query_594907, "$expand", newJString(Expand))
  add(path_594906, "subscriptionId", newJString(subscriptionId))
  add(path_594906, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_594905.call(path_594906, query_594907, nil, nil, nil)

var virtualNetworksGet* = Call_VirtualNetworksGet_594896(
    name: "virtualNetworksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworksGet_594897, base: "",
    url: url_VirtualNetworksGet_594898, schemes: {Scheme.Https})
type
  Call_VirtualNetworksDelete_594921 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworksDelete_594923(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksDelete_594922(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Delete VirtualNetwork operation deletes the specified virtual network
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594924 = path.getOrDefault("resourceGroupName")
  valid_594924 = validateParameter(valid_594924, JString, required = true,
                                 default = nil)
  if valid_594924 != nil:
    section.add "resourceGroupName", valid_594924
  var valid_594925 = path.getOrDefault("subscriptionId")
  valid_594925 = validateParameter(valid_594925, JString, required = true,
                                 default = nil)
  if valid_594925 != nil:
    section.add "subscriptionId", valid_594925
  var valid_594926 = path.getOrDefault("virtualNetworkName")
  valid_594926 = validateParameter(valid_594926, JString, required = true,
                                 default = nil)
  if valid_594926 != nil:
    section.add "virtualNetworkName", valid_594926
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594927 = query.getOrDefault("api-version")
  valid_594927 = validateParameter(valid_594927, JString, required = true,
                                 default = nil)
  if valid_594927 != nil:
    section.add "api-version", valid_594927
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594928: Call_VirtualNetworksDelete_594921; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete VirtualNetwork operation deletes the specified virtual network
  ## 
  let valid = call_594928.validator(path, query, header, formData, body)
  let scheme = call_594928.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594928.url(scheme.get, call_594928.host, call_594928.base,
                         call_594928.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594928, url, valid)

proc call*(call_594929: Call_VirtualNetworksDelete_594921;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkName: string): Recallable =
  ## virtualNetworksDelete
  ## The Delete VirtualNetwork operation deletes the specified virtual network
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_594930 = newJObject()
  var query_594931 = newJObject()
  add(path_594930, "resourceGroupName", newJString(resourceGroupName))
  add(query_594931, "api-version", newJString(apiVersion))
  add(path_594930, "subscriptionId", newJString(subscriptionId))
  add(path_594930, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_594929.call(path_594930, query_594931, nil, nil, nil)

var virtualNetworksDelete* = Call_VirtualNetworksDelete_594921(
    name: "virtualNetworksDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworksDelete_594922, base: "",
    url: url_VirtualNetworksDelete_594923, schemes: {Scheme.Https})
type
  Call_VirtualNetworksCheckIPAddressAvailability_594932 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworksCheckIPAddressAvailability_594934(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/CheckIPAddressAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksCheckIPAddressAvailability_594933(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether a private Ip address is available for use.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594935 = path.getOrDefault("resourceGroupName")
  valid_594935 = validateParameter(valid_594935, JString, required = true,
                                 default = nil)
  if valid_594935 != nil:
    section.add "resourceGroupName", valid_594935
  var valid_594936 = path.getOrDefault("subscriptionId")
  valid_594936 = validateParameter(valid_594936, JString, required = true,
                                 default = nil)
  if valid_594936 != nil:
    section.add "subscriptionId", valid_594936
  var valid_594937 = path.getOrDefault("virtualNetworkName")
  valid_594937 = validateParameter(valid_594937, JString, required = true,
                                 default = nil)
  if valid_594937 != nil:
    section.add "virtualNetworkName", valid_594937
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   ipAddress: JString
  ##            : The private IP address to be verified.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594938 = query.getOrDefault("api-version")
  valid_594938 = validateParameter(valid_594938, JString, required = true,
                                 default = nil)
  if valid_594938 != nil:
    section.add "api-version", valid_594938
  var valid_594939 = query.getOrDefault("ipAddress")
  valid_594939 = validateParameter(valid_594939, JString, required = false,
                                 default = nil)
  if valid_594939 != nil:
    section.add "ipAddress", valid_594939
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594940: Call_VirtualNetworksCheckIPAddressAvailability_594932;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether a private Ip address is available for use.
  ## 
  let valid = call_594940.validator(path, query, header, formData, body)
  let scheme = call_594940.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594940.url(scheme.get, call_594940.host, call_594940.base,
                         call_594940.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594940, url, valid)

proc call*(call_594941: Call_VirtualNetworksCheckIPAddressAvailability_594932;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkName: string; ipAddress: string = ""): Recallable =
  ## virtualNetworksCheckIPAddressAvailability
  ## Checks whether a private Ip address is available for use.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   ipAddress: string
  ##            : The private IP address to be verified.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_594942 = newJObject()
  var query_594943 = newJObject()
  add(path_594942, "resourceGroupName", newJString(resourceGroupName))
  add(query_594943, "api-version", newJString(apiVersion))
  add(query_594943, "ipAddress", newJString(ipAddress))
  add(path_594942, "subscriptionId", newJString(subscriptionId))
  add(path_594942, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_594941.call(path_594942, query_594943, nil, nil, nil)

var virtualNetworksCheckIPAddressAvailability* = Call_VirtualNetworksCheckIPAddressAvailability_594932(
    name: "virtualNetworksCheckIPAddressAvailability", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/CheckIPAddressAvailability",
    validator: validate_VirtualNetworksCheckIPAddressAvailability_594933,
    base: "", url: url_VirtualNetworksCheckIPAddressAvailability_594934,
    schemes: {Scheme.Https})
type
  Call_SubnetsList_594944 = ref object of OpenApiRestCall_593421
proc url_SubnetsList_594946(protocol: Scheme; host: string; base: string;
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

proc validate_SubnetsList_594945(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## The List subnets operation retrieves all the subnets in a virtual network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594947 = path.getOrDefault("resourceGroupName")
  valid_594947 = validateParameter(valid_594947, JString, required = true,
                                 default = nil)
  if valid_594947 != nil:
    section.add "resourceGroupName", valid_594947
  var valid_594948 = path.getOrDefault("subscriptionId")
  valid_594948 = validateParameter(valid_594948, JString, required = true,
                                 default = nil)
  if valid_594948 != nil:
    section.add "subscriptionId", valid_594948
  var valid_594949 = path.getOrDefault("virtualNetworkName")
  valid_594949 = validateParameter(valid_594949, JString, required = true,
                                 default = nil)
  if valid_594949 != nil:
    section.add "virtualNetworkName", valid_594949
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594950 = query.getOrDefault("api-version")
  valid_594950 = validateParameter(valid_594950, JString, required = true,
                                 default = nil)
  if valid_594950 != nil:
    section.add "api-version", valid_594950
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594951: Call_SubnetsList_594944; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List subnets operation retrieves all the subnets in a virtual network.
  ## 
  let valid = call_594951.validator(path, query, header, formData, body)
  let scheme = call_594951.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594951.url(scheme.get, call_594951.host, call_594951.base,
                         call_594951.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594951, url, valid)

proc call*(call_594952: Call_SubnetsList_594944; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; virtualNetworkName: string): Recallable =
  ## subnetsList
  ## The List subnets operation retrieves all the subnets in a virtual network.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_594953 = newJObject()
  var query_594954 = newJObject()
  add(path_594953, "resourceGroupName", newJString(resourceGroupName))
  add(query_594954, "api-version", newJString(apiVersion))
  add(path_594953, "subscriptionId", newJString(subscriptionId))
  add(path_594953, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_594952.call(path_594953, query_594954, nil, nil, nil)

var subnetsList* = Call_SubnetsList_594944(name: "subnetsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets",
                                        validator: validate_SubnetsList_594945,
                                        base: "", url: url_SubnetsList_594946,
                                        schemes: {Scheme.Https})
type
  Call_SubnetsCreateOrUpdate_594968 = ref object of OpenApiRestCall_593421
proc url_SubnetsCreateOrUpdate_594970(protocol: Scheme; host: string; base: string;
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

proc validate_SubnetsCreateOrUpdate_594969(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put Subnet operation creates/updates a subnet in the specified virtual network
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subnetName: JString (required)
  ##             : The name of the subnet.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594971 = path.getOrDefault("resourceGroupName")
  valid_594971 = validateParameter(valid_594971, JString, required = true,
                                 default = nil)
  if valid_594971 != nil:
    section.add "resourceGroupName", valid_594971
  var valid_594972 = path.getOrDefault("subnetName")
  valid_594972 = validateParameter(valid_594972, JString, required = true,
                                 default = nil)
  if valid_594972 != nil:
    section.add "subnetName", valid_594972
  var valid_594973 = path.getOrDefault("subscriptionId")
  valid_594973 = validateParameter(valid_594973, JString, required = true,
                                 default = nil)
  if valid_594973 != nil:
    section.add "subscriptionId", valid_594973
  var valid_594974 = path.getOrDefault("virtualNetworkName")
  valid_594974 = validateParameter(valid_594974, JString, required = true,
                                 default = nil)
  if valid_594974 != nil:
    section.add "virtualNetworkName", valid_594974
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594975 = query.getOrDefault("api-version")
  valid_594975 = validateParameter(valid_594975, JString, required = true,
                                 default = nil)
  if valid_594975 != nil:
    section.add "api-version", valid_594975
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

proc call*(call_594977: Call_SubnetsCreateOrUpdate_594968; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put Subnet operation creates/updates a subnet in the specified virtual network
  ## 
  let valid = call_594977.validator(path, query, header, formData, body)
  let scheme = call_594977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594977.url(scheme.get, call_594977.host, call_594977.base,
                         call_594977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594977, url, valid)

proc call*(call_594978: Call_SubnetsCreateOrUpdate_594968;
          resourceGroupName: string; subnetName: string; apiVersion: string;
          subscriptionId: string; virtualNetworkName: string;
          subnetParameters: JsonNode): Recallable =
  ## subnetsCreateOrUpdate
  ## The Put Subnet operation creates/updates a subnet in the specified virtual network
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   subnetName: string (required)
  ##             : The name of the subnet.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  ##   subnetParameters: JObject (required)
  ##                   : Parameters supplied to the create/update Subnet operation
  var path_594979 = newJObject()
  var query_594980 = newJObject()
  var body_594981 = newJObject()
  add(path_594979, "resourceGroupName", newJString(resourceGroupName))
  add(path_594979, "subnetName", newJString(subnetName))
  add(query_594980, "api-version", newJString(apiVersion))
  add(path_594979, "subscriptionId", newJString(subscriptionId))
  add(path_594979, "virtualNetworkName", newJString(virtualNetworkName))
  if subnetParameters != nil:
    body_594981 = subnetParameters
  result = call_594978.call(path_594979, query_594980, nil, nil, body_594981)

var subnetsCreateOrUpdate* = Call_SubnetsCreateOrUpdate_594968(
    name: "subnetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}",
    validator: validate_SubnetsCreateOrUpdate_594969, base: "",
    url: url_SubnetsCreateOrUpdate_594970, schemes: {Scheme.Https})
type
  Call_SubnetsGet_594955 = ref object of OpenApiRestCall_593421
proc url_SubnetsGet_594957(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SubnetsGet_594956(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get subnet operation retrieves information about the specified subnet.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subnetName: JString (required)
  ##             : The name of the subnet.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594958 = path.getOrDefault("resourceGroupName")
  valid_594958 = validateParameter(valid_594958, JString, required = true,
                                 default = nil)
  if valid_594958 != nil:
    section.add "resourceGroupName", valid_594958
  var valid_594959 = path.getOrDefault("subnetName")
  valid_594959 = validateParameter(valid_594959, JString, required = true,
                                 default = nil)
  if valid_594959 != nil:
    section.add "subnetName", valid_594959
  var valid_594960 = path.getOrDefault("subscriptionId")
  valid_594960 = validateParameter(valid_594960, JString, required = true,
                                 default = nil)
  if valid_594960 != nil:
    section.add "subscriptionId", valid_594960
  var valid_594961 = path.getOrDefault("virtualNetworkName")
  valid_594961 = validateParameter(valid_594961, JString, required = true,
                                 default = nil)
  if valid_594961 != nil:
    section.add "virtualNetworkName", valid_594961
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594962 = query.getOrDefault("api-version")
  valid_594962 = validateParameter(valid_594962, JString, required = true,
                                 default = nil)
  if valid_594962 != nil:
    section.add "api-version", valid_594962
  var valid_594963 = query.getOrDefault("$expand")
  valid_594963 = validateParameter(valid_594963, JString, required = false,
                                 default = nil)
  if valid_594963 != nil:
    section.add "$expand", valid_594963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594964: Call_SubnetsGet_594955; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get subnet operation retrieves information about the specified subnet.
  ## 
  let valid = call_594964.validator(path, query, header, formData, body)
  let scheme = call_594964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594964.url(scheme.get, call_594964.host, call_594964.base,
                         call_594964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594964, url, valid)

proc call*(call_594965: Call_SubnetsGet_594955; resourceGroupName: string;
          subnetName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkName: string; Expand: string = ""): Recallable =
  ## subnetsGet
  ## The Get subnet operation retrieves information about the specified subnet.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   subnetName: string (required)
  ##             : The name of the subnet.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : expand references resources.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_594966 = newJObject()
  var query_594967 = newJObject()
  add(path_594966, "resourceGroupName", newJString(resourceGroupName))
  add(path_594966, "subnetName", newJString(subnetName))
  add(query_594967, "api-version", newJString(apiVersion))
  add(query_594967, "$expand", newJString(Expand))
  add(path_594966, "subscriptionId", newJString(subscriptionId))
  add(path_594966, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_594965.call(path_594966, query_594967, nil, nil, nil)

var subnetsGet* = Call_SubnetsGet_594955(name: "subnetsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}",
                                      validator: validate_SubnetsGet_594956,
                                      base: "", url: url_SubnetsGet_594957,
                                      schemes: {Scheme.Https})
type
  Call_SubnetsDelete_594982 = ref object of OpenApiRestCall_593421
proc url_SubnetsDelete_594984(protocol: Scheme; host: string; base: string;
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

proc validate_SubnetsDelete_594983(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## The delete subnet operation deletes the specified subnet.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subnetName: JString (required)
  ##             : The name of the subnet.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594985 = path.getOrDefault("resourceGroupName")
  valid_594985 = validateParameter(valid_594985, JString, required = true,
                                 default = nil)
  if valid_594985 != nil:
    section.add "resourceGroupName", valid_594985
  var valid_594986 = path.getOrDefault("subnetName")
  valid_594986 = validateParameter(valid_594986, JString, required = true,
                                 default = nil)
  if valid_594986 != nil:
    section.add "subnetName", valid_594986
  var valid_594987 = path.getOrDefault("subscriptionId")
  valid_594987 = validateParameter(valid_594987, JString, required = true,
                                 default = nil)
  if valid_594987 != nil:
    section.add "subscriptionId", valid_594987
  var valid_594988 = path.getOrDefault("virtualNetworkName")
  valid_594988 = validateParameter(valid_594988, JString, required = true,
                                 default = nil)
  if valid_594988 != nil:
    section.add "virtualNetworkName", valid_594988
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594989 = query.getOrDefault("api-version")
  valid_594989 = validateParameter(valid_594989, JString, required = true,
                                 default = nil)
  if valid_594989 != nil:
    section.add "api-version", valid_594989
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594990: Call_SubnetsDelete_594982; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete subnet operation deletes the specified subnet.
  ## 
  let valid = call_594990.validator(path, query, header, formData, body)
  let scheme = call_594990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594990.url(scheme.get, call_594990.host, call_594990.base,
                         call_594990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594990, url, valid)

proc call*(call_594991: Call_SubnetsDelete_594982; resourceGroupName: string;
          subnetName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkName: string): Recallable =
  ## subnetsDelete
  ## The delete subnet operation deletes the specified subnet.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   subnetName: string (required)
  ##             : The name of the subnet.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_594992 = newJObject()
  var query_594993 = newJObject()
  add(path_594992, "resourceGroupName", newJString(resourceGroupName))
  add(path_594992, "subnetName", newJString(subnetName))
  add(query_594993, "api-version", newJString(apiVersion))
  add(path_594992, "subscriptionId", newJString(subscriptionId))
  add(path_594992, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_594991.call(path_594992, query_594993, nil, nil, nil)

var subnetsDelete* = Call_SubnetsDelete_594982(name: "subnetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}",
    validator: validate_SubnetsDelete_594983, base: "", url: url_SubnetsDelete_594984,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkPeeringsList_594994 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworkPeeringsList_594996(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "virtualNetworkName"),
               (kind: ConstantSegment, value: "/virtualNetworkPeerings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkPeeringsList_594995(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List virtual network peerings operation retrieves all the peerings in a virtual network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594997 = path.getOrDefault("resourceGroupName")
  valid_594997 = validateParameter(valid_594997, JString, required = true,
                                 default = nil)
  if valid_594997 != nil:
    section.add "resourceGroupName", valid_594997
  var valid_594998 = path.getOrDefault("subscriptionId")
  valid_594998 = validateParameter(valid_594998, JString, required = true,
                                 default = nil)
  if valid_594998 != nil:
    section.add "subscriptionId", valid_594998
  var valid_594999 = path.getOrDefault("virtualNetworkName")
  valid_594999 = validateParameter(valid_594999, JString, required = true,
                                 default = nil)
  if valid_594999 != nil:
    section.add "virtualNetworkName", valid_594999
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595000 = query.getOrDefault("api-version")
  valid_595000 = validateParameter(valid_595000, JString, required = true,
                                 default = nil)
  if valid_595000 != nil:
    section.add "api-version", valid_595000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595001: Call_VirtualNetworkPeeringsList_594994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List virtual network peerings operation retrieves all the peerings in a virtual network.
  ## 
  let valid = call_595001.validator(path, query, header, formData, body)
  let scheme = call_595001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595001.url(scheme.get, call_595001.host, call_595001.base,
                         call_595001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595001, url, valid)

proc call*(call_595002: Call_VirtualNetworkPeeringsList_594994;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkName: string): Recallable =
  ## virtualNetworkPeeringsList
  ## The List virtual network peerings operation retrieves all the peerings in a virtual network.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_595003 = newJObject()
  var query_595004 = newJObject()
  add(path_595003, "resourceGroupName", newJString(resourceGroupName))
  add(query_595004, "api-version", newJString(apiVersion))
  add(path_595003, "subscriptionId", newJString(subscriptionId))
  add(path_595003, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_595002.call(path_595003, query_595004, nil, nil, nil)

var virtualNetworkPeeringsList* = Call_VirtualNetworkPeeringsList_594994(
    name: "virtualNetworkPeeringsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/virtualNetworkPeerings",
    validator: validate_VirtualNetworkPeeringsList_594995, base: "",
    url: url_VirtualNetworkPeeringsList_594996, schemes: {Scheme.Https})
type
  Call_VirtualNetworkPeeringsCreateOrUpdate_595017 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworkPeeringsCreateOrUpdate_595019(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualNetworkName" in path,
        "`virtualNetworkName` is a required path parameter"
  assert "virtualNetworkPeeringName" in path,
        "`virtualNetworkPeeringName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName"),
               (kind: ConstantSegment, value: "/virtualNetworkPeerings/"),
               (kind: VariableSegment, value: "virtualNetworkPeeringName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkPeeringsCreateOrUpdate_595018(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put virtual network peering operation creates/updates a peering in the specified virtual network
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  ##   virtualNetworkPeeringName: JString (required)
  ##                            : The name of the peering.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595020 = path.getOrDefault("resourceGroupName")
  valid_595020 = validateParameter(valid_595020, JString, required = true,
                                 default = nil)
  if valid_595020 != nil:
    section.add "resourceGroupName", valid_595020
  var valid_595021 = path.getOrDefault("subscriptionId")
  valid_595021 = validateParameter(valid_595021, JString, required = true,
                                 default = nil)
  if valid_595021 != nil:
    section.add "subscriptionId", valid_595021
  var valid_595022 = path.getOrDefault("virtualNetworkName")
  valid_595022 = validateParameter(valid_595022, JString, required = true,
                                 default = nil)
  if valid_595022 != nil:
    section.add "virtualNetworkName", valid_595022
  var valid_595023 = path.getOrDefault("virtualNetworkPeeringName")
  valid_595023 = validateParameter(valid_595023, JString, required = true,
                                 default = nil)
  if valid_595023 != nil:
    section.add "virtualNetworkPeeringName", valid_595023
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595024 = query.getOrDefault("api-version")
  valid_595024 = validateParameter(valid_595024, JString, required = true,
                                 default = nil)
  if valid_595024 != nil:
    section.add "api-version", valid_595024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   VirtualNetworkPeeringParameters: JObject (required)
  ##                                  : Parameters supplied to the create/update virtual network peering operation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595026: Call_VirtualNetworkPeeringsCreateOrUpdate_595017;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put virtual network peering operation creates/updates a peering in the specified virtual network
  ## 
  let valid = call_595026.validator(path, query, header, formData, body)
  let scheme = call_595026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595026.url(scheme.get, call_595026.host, call_595026.base,
                         call_595026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595026, url, valid)

proc call*(call_595027: Call_VirtualNetworkPeeringsCreateOrUpdate_595017;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkName: string; virtualNetworkPeeringName: string;
          VirtualNetworkPeeringParameters: JsonNode): Recallable =
  ## virtualNetworkPeeringsCreateOrUpdate
  ## The Put virtual network peering operation creates/updates a peering in the specified virtual network
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  ##   virtualNetworkPeeringName: string (required)
  ##                            : The name of the peering.
  ##   VirtualNetworkPeeringParameters: JObject (required)
  ##                                  : Parameters supplied to the create/update virtual network peering operation
  var path_595028 = newJObject()
  var query_595029 = newJObject()
  var body_595030 = newJObject()
  add(path_595028, "resourceGroupName", newJString(resourceGroupName))
  add(query_595029, "api-version", newJString(apiVersion))
  add(path_595028, "subscriptionId", newJString(subscriptionId))
  add(path_595028, "virtualNetworkName", newJString(virtualNetworkName))
  add(path_595028, "virtualNetworkPeeringName",
      newJString(virtualNetworkPeeringName))
  if VirtualNetworkPeeringParameters != nil:
    body_595030 = VirtualNetworkPeeringParameters
  result = call_595027.call(path_595028, query_595029, nil, nil, body_595030)

var virtualNetworkPeeringsCreateOrUpdate* = Call_VirtualNetworkPeeringsCreateOrUpdate_595017(
    name: "virtualNetworkPeeringsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/virtualNetworkPeerings/{virtualNetworkPeeringName}",
    validator: validate_VirtualNetworkPeeringsCreateOrUpdate_595018, base: "",
    url: url_VirtualNetworkPeeringsCreateOrUpdate_595019, schemes: {Scheme.Https})
type
  Call_VirtualNetworkPeeringsGet_595005 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworkPeeringsGet_595007(protocol: Scheme; host: string;
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
  assert "virtualNetworkPeeringName" in path,
        "`virtualNetworkPeeringName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName"),
               (kind: ConstantSegment, value: "/virtualNetworkPeerings/"),
               (kind: VariableSegment, value: "virtualNetworkPeeringName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkPeeringsGet_595006(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get virtual network peering operation retrieves information about the specified virtual network peering.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  ##   virtualNetworkPeeringName: JString (required)
  ##                            : The name of the virtual network peering.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595008 = path.getOrDefault("resourceGroupName")
  valid_595008 = validateParameter(valid_595008, JString, required = true,
                                 default = nil)
  if valid_595008 != nil:
    section.add "resourceGroupName", valid_595008
  var valid_595009 = path.getOrDefault("subscriptionId")
  valid_595009 = validateParameter(valid_595009, JString, required = true,
                                 default = nil)
  if valid_595009 != nil:
    section.add "subscriptionId", valid_595009
  var valid_595010 = path.getOrDefault("virtualNetworkName")
  valid_595010 = validateParameter(valid_595010, JString, required = true,
                                 default = nil)
  if valid_595010 != nil:
    section.add "virtualNetworkName", valid_595010
  var valid_595011 = path.getOrDefault("virtualNetworkPeeringName")
  valid_595011 = validateParameter(valid_595011, JString, required = true,
                                 default = nil)
  if valid_595011 != nil:
    section.add "virtualNetworkPeeringName", valid_595011
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595012 = query.getOrDefault("api-version")
  valid_595012 = validateParameter(valid_595012, JString, required = true,
                                 default = nil)
  if valid_595012 != nil:
    section.add "api-version", valid_595012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595013: Call_VirtualNetworkPeeringsGet_595005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get virtual network peering operation retrieves information about the specified virtual network peering.
  ## 
  let valid = call_595013.validator(path, query, header, formData, body)
  let scheme = call_595013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595013.url(scheme.get, call_595013.host, call_595013.base,
                         call_595013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595013, url, valid)

proc call*(call_595014: Call_VirtualNetworkPeeringsGet_595005;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkName: string; virtualNetworkPeeringName: string): Recallable =
  ## virtualNetworkPeeringsGet
  ## The Get virtual network peering operation retrieves information about the specified virtual network peering.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  ##   virtualNetworkPeeringName: string (required)
  ##                            : The name of the virtual network peering.
  var path_595015 = newJObject()
  var query_595016 = newJObject()
  add(path_595015, "resourceGroupName", newJString(resourceGroupName))
  add(query_595016, "api-version", newJString(apiVersion))
  add(path_595015, "subscriptionId", newJString(subscriptionId))
  add(path_595015, "virtualNetworkName", newJString(virtualNetworkName))
  add(path_595015, "virtualNetworkPeeringName",
      newJString(virtualNetworkPeeringName))
  result = call_595014.call(path_595015, query_595016, nil, nil, nil)

var virtualNetworkPeeringsGet* = Call_VirtualNetworkPeeringsGet_595005(
    name: "virtualNetworkPeeringsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/virtualNetworkPeerings/{virtualNetworkPeeringName}",
    validator: validate_VirtualNetworkPeeringsGet_595006, base: "",
    url: url_VirtualNetworkPeeringsGet_595007, schemes: {Scheme.Https})
type
  Call_VirtualNetworkPeeringsDelete_595031 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworkPeeringsDelete_595033(protocol: Scheme; host: string;
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
  assert "virtualNetworkPeeringName" in path,
        "`virtualNetworkPeeringName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/virtualNetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName"),
               (kind: ConstantSegment, value: "/virtualNetworkPeerings/"),
               (kind: VariableSegment, value: "virtualNetworkPeeringName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkPeeringsDelete_595032(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The delete virtual network peering operation deletes the specified peering.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: JString (required)
  ##                     : The name of the virtual network.
  ##   virtualNetworkPeeringName: JString (required)
  ##                            : The name of the virtual network peering.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595034 = path.getOrDefault("resourceGroupName")
  valid_595034 = validateParameter(valid_595034, JString, required = true,
                                 default = nil)
  if valid_595034 != nil:
    section.add "resourceGroupName", valid_595034
  var valid_595035 = path.getOrDefault("subscriptionId")
  valid_595035 = validateParameter(valid_595035, JString, required = true,
                                 default = nil)
  if valid_595035 != nil:
    section.add "subscriptionId", valid_595035
  var valid_595036 = path.getOrDefault("virtualNetworkName")
  valid_595036 = validateParameter(valid_595036, JString, required = true,
                                 default = nil)
  if valid_595036 != nil:
    section.add "virtualNetworkName", valid_595036
  var valid_595037 = path.getOrDefault("virtualNetworkPeeringName")
  valid_595037 = validateParameter(valid_595037, JString, required = true,
                                 default = nil)
  if valid_595037 != nil:
    section.add "virtualNetworkPeeringName", valid_595037
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595038 = query.getOrDefault("api-version")
  valid_595038 = validateParameter(valid_595038, JString, required = true,
                                 default = nil)
  if valid_595038 != nil:
    section.add "api-version", valid_595038
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595039: Call_VirtualNetworkPeeringsDelete_595031; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete virtual network peering operation deletes the specified peering.
  ## 
  let valid = call_595039.validator(path, query, header, formData, body)
  let scheme = call_595039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595039.url(scheme.get, call_595039.host, call_595039.base,
                         call_595039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595039, url, valid)

proc call*(call_595040: Call_VirtualNetworkPeeringsDelete_595031;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkName: string; virtualNetworkPeeringName: string): Recallable =
  ## virtualNetworkPeeringsDelete
  ## The delete virtual network peering operation deletes the specified peering.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  ##   virtualNetworkPeeringName: string (required)
  ##                            : The name of the virtual network peering.
  var path_595041 = newJObject()
  var query_595042 = newJObject()
  add(path_595041, "resourceGroupName", newJString(resourceGroupName))
  add(query_595042, "api-version", newJString(apiVersion))
  add(path_595041, "subscriptionId", newJString(subscriptionId))
  add(path_595041, "virtualNetworkName", newJString(virtualNetworkName))
  add(path_595041, "virtualNetworkPeeringName",
      newJString(virtualNetworkPeeringName))
  result = call_595040.call(path_595041, query_595042, nil, nil, nil)

var virtualNetworkPeeringsDelete* = Call_VirtualNetworkPeeringsDelete_595031(
    name: "virtualNetworkPeeringsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/virtualNetworkPeerings/{virtualNetworkPeeringName}",
    validator: validate_VirtualNetworkPeeringsDelete_595032, base: "",
    url: url_VirtualNetworkPeeringsDelete_595033, schemes: {Scheme.Https})
type
  Call_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_595043 = ref object of OpenApiRestCall_593421
proc url_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_595045(
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

proc validate_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_595044(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The list network interface operation retrieves information about all network interfaces in a virtual machine scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualMachineScaleSetName: JString (required)
  ##                             : The name of the virtual machine scale set.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595046 = path.getOrDefault("resourceGroupName")
  valid_595046 = validateParameter(valid_595046, JString, required = true,
                                 default = nil)
  if valid_595046 != nil:
    section.add "resourceGroupName", valid_595046
  var valid_595047 = path.getOrDefault("subscriptionId")
  valid_595047 = validateParameter(valid_595047, JString, required = true,
                                 default = nil)
  if valid_595047 != nil:
    section.add "subscriptionId", valid_595047
  var valid_595048 = path.getOrDefault("virtualMachineScaleSetName")
  valid_595048 = validateParameter(valid_595048, JString, required = true,
                                 default = nil)
  if valid_595048 != nil:
    section.add "virtualMachineScaleSetName", valid_595048
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595049 = query.getOrDefault("api-version")
  valid_595049 = validateParameter(valid_595049, JString, required = true,
                                 default = nil)
  if valid_595049 != nil:
    section.add "api-version", valid_595049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595050: Call_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_595043;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The list network interface operation retrieves information about all network interfaces in a virtual machine scale set.
  ## 
  let valid = call_595050.validator(path, query, header, formData, body)
  let scheme = call_595050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595050.url(scheme.get, call_595050.host, call_595050.base,
                         call_595050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595050, url, valid)

proc call*(call_595051: Call_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_595043;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualMachineScaleSetName: string): Recallable =
  ## networkInterfacesListVirtualMachineScaleSetNetworkInterfaces
  ## The list network interface operation retrieves information about all network interfaces in a virtual machine scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualMachineScaleSetName: string (required)
  ##                             : The name of the virtual machine scale set.
  var path_595052 = newJObject()
  var query_595053 = newJObject()
  add(path_595052, "resourceGroupName", newJString(resourceGroupName))
  add(query_595053, "api-version", newJString(apiVersion))
  add(path_595052, "subscriptionId", newJString(subscriptionId))
  add(path_595052, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  result = call_595051.call(path_595052, query_595053, nil, nil, nil)

var networkInterfacesListVirtualMachineScaleSetNetworkInterfaces* = Call_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_595043(
    name: "networkInterfacesListVirtualMachineScaleSetNetworkInterfaces",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/networkInterfaces", validator: validate_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_595044,
    base: "",
    url: url_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_595045,
    schemes: {Scheme.Https})
type
  Call_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_595054 = ref object of OpenApiRestCall_593421
proc url_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_595056(
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

proc validate_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_595055(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The list network interface operation retrieves information about all network interfaces in a virtual machine from a virtual machine scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualmachineIndex: JString (required)
  ##                      : The virtual machine index.
  ##   virtualMachineScaleSetName: JString (required)
  ##                             : The name of the virtual machine scale set.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595057 = path.getOrDefault("resourceGroupName")
  valid_595057 = validateParameter(valid_595057, JString, required = true,
                                 default = nil)
  if valid_595057 != nil:
    section.add "resourceGroupName", valid_595057
  var valid_595058 = path.getOrDefault("subscriptionId")
  valid_595058 = validateParameter(valid_595058, JString, required = true,
                                 default = nil)
  if valid_595058 != nil:
    section.add "subscriptionId", valid_595058
  var valid_595059 = path.getOrDefault("virtualmachineIndex")
  valid_595059 = validateParameter(valid_595059, JString, required = true,
                                 default = nil)
  if valid_595059 != nil:
    section.add "virtualmachineIndex", valid_595059
  var valid_595060 = path.getOrDefault("virtualMachineScaleSetName")
  valid_595060 = validateParameter(valid_595060, JString, required = true,
                                 default = nil)
  if valid_595060 != nil:
    section.add "virtualMachineScaleSetName", valid_595060
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595061 = query.getOrDefault("api-version")
  valid_595061 = validateParameter(valid_595061, JString, required = true,
                                 default = nil)
  if valid_595061 != nil:
    section.add "api-version", valid_595061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595062: Call_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_595054;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The list network interface operation retrieves information about all network interfaces in a virtual machine from a virtual machine scale set.
  ## 
  let valid = call_595062.validator(path, query, header, formData, body)
  let scheme = call_595062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595062.url(scheme.get, call_595062.host, call_595062.base,
                         call_595062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595062, url, valid)

proc call*(call_595063: Call_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_595054;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualmachineIndex: string; virtualMachineScaleSetName: string): Recallable =
  ## networkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces
  ## The list network interface operation retrieves information about all network interfaces in a virtual machine from a virtual machine scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualmachineIndex: string (required)
  ##                      : The virtual machine index.
  ##   virtualMachineScaleSetName: string (required)
  ##                             : The name of the virtual machine scale set.
  var path_595064 = newJObject()
  var query_595065 = newJObject()
  add(path_595064, "resourceGroupName", newJString(resourceGroupName))
  add(query_595065, "api-version", newJString(apiVersion))
  add(path_595064, "subscriptionId", newJString(subscriptionId))
  add(path_595064, "virtualmachineIndex", newJString(virtualmachineIndex))
  add(path_595064, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  result = call_595063.call(path_595064, query_595065, nil, nil, nil)

var networkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces* = Call_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_595054(
    name: "networkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/virtualMachines/{virtualmachineIndex}/networkInterfaces", validator: validate_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_595055,
    base: "",
    url: url_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_595056,
    schemes: {Scheme.Https})
type
  Call_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_595066 = ref object of OpenApiRestCall_593421
proc url_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_595068(
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

proc validate_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_595067(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The Get network interface operation retrieves information about the specified network interface in a virtual machine scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualmachineIndex: JString (required)
  ##                      : The virtual machine index.
  ##   networkInterfaceName: JString (required)
  ##                       : The name of the network interface.
  ##   virtualMachineScaleSetName: JString (required)
  ##                             : The name of the virtual machine scale set.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595069 = path.getOrDefault("resourceGroupName")
  valid_595069 = validateParameter(valid_595069, JString, required = true,
                                 default = nil)
  if valid_595069 != nil:
    section.add "resourceGroupName", valid_595069
  var valid_595070 = path.getOrDefault("subscriptionId")
  valid_595070 = validateParameter(valid_595070, JString, required = true,
                                 default = nil)
  if valid_595070 != nil:
    section.add "subscriptionId", valid_595070
  var valid_595071 = path.getOrDefault("virtualmachineIndex")
  valid_595071 = validateParameter(valid_595071, JString, required = true,
                                 default = nil)
  if valid_595071 != nil:
    section.add "virtualmachineIndex", valid_595071
  var valid_595072 = path.getOrDefault("networkInterfaceName")
  valid_595072 = validateParameter(valid_595072, JString, required = true,
                                 default = nil)
  if valid_595072 != nil:
    section.add "networkInterfaceName", valid_595072
  var valid_595073 = path.getOrDefault("virtualMachineScaleSetName")
  valid_595073 = validateParameter(valid_595073, JString, required = true,
                                 default = nil)
  if valid_595073 != nil:
    section.add "virtualMachineScaleSetName", valid_595073
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595074 = query.getOrDefault("api-version")
  valid_595074 = validateParameter(valid_595074, JString, required = true,
                                 default = nil)
  if valid_595074 != nil:
    section.add "api-version", valid_595074
  var valid_595075 = query.getOrDefault("$expand")
  valid_595075 = validateParameter(valid_595075, JString, required = false,
                                 default = nil)
  if valid_595075 != nil:
    section.add "$expand", valid_595075
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595076: Call_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_595066;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Get network interface operation retrieves information about the specified network interface in a virtual machine scale set.
  ## 
  let valid = call_595076.validator(path, query, header, formData, body)
  let scheme = call_595076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595076.url(scheme.get, call_595076.host, call_595076.base,
                         call_595076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595076, url, valid)

proc call*(call_595077: Call_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_595066;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualmachineIndex: string; networkInterfaceName: string;
          virtualMachineScaleSetName: string; Expand: string = ""): Recallable =
  ## networkInterfacesGetVirtualMachineScaleSetNetworkInterface
  ## The Get network interface operation retrieves information about the specified network interface in a virtual machine scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : expand references resources.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualmachineIndex: string (required)
  ##                      : The virtual machine index.
  ##   networkInterfaceName: string (required)
  ##                       : The name of the network interface.
  ##   virtualMachineScaleSetName: string (required)
  ##                             : The name of the virtual machine scale set.
  var path_595078 = newJObject()
  var query_595079 = newJObject()
  add(path_595078, "resourceGroupName", newJString(resourceGroupName))
  add(query_595079, "api-version", newJString(apiVersion))
  add(query_595079, "$expand", newJString(Expand))
  add(path_595078, "subscriptionId", newJString(subscriptionId))
  add(path_595078, "virtualmachineIndex", newJString(virtualmachineIndex))
  add(path_595078, "networkInterfaceName", newJString(networkInterfaceName))
  add(path_595078, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  result = call_595077.call(path_595078, query_595079, nil, nil, nil)

var networkInterfacesGetVirtualMachineScaleSetNetworkInterface* = Call_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_595066(
    name: "networkInterfacesGetVirtualMachineScaleSetNetworkInterface",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/virtualMachines/{virtualmachineIndex}/networkInterfaces/{networkInterfaceName}", validator: validate_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_595067,
    base: "", url: url_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_595068,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
