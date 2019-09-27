
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593422 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593422](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593422): Option[Scheme] {.used.} =
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
  Call_ApplicationGatewaysListAll_593644 = ref object of OpenApiRestCall_593422
proc url_ApplicationGatewaysListAll_593646(protocol: Scheme; host: string;
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

proc validate_ApplicationGatewaysListAll_593645(path: JsonNode; query: JsonNode;
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
  var valid_593819 = path.getOrDefault("subscriptionId")
  valid_593819 = validateParameter(valid_593819, JString, required = true,
                                 default = nil)
  if valid_593819 != nil:
    section.add "subscriptionId", valid_593819
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593820 = query.getOrDefault("api-version")
  valid_593820 = validateParameter(valid_593820, JString, required = true,
                                 default = nil)
  if valid_593820 != nil:
    section.add "api-version", valid_593820
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593843: Call_ApplicationGatewaysListAll_593644; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List application gateway operation retrieves all the application gateways in a subscription.
  ## 
  let valid = call_593843.validator(path, query, header, formData, body)
  let scheme = call_593843.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593843.url(scheme.get, call_593843.host, call_593843.base,
                         call_593843.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593843, url, valid)

proc call*(call_593914: Call_ApplicationGatewaysListAll_593644; apiVersion: string;
          subscriptionId: string): Recallable =
  ## applicationGatewaysListAll
  ## The List application gateway operation retrieves all the application gateways in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593915 = newJObject()
  var query_593917 = newJObject()
  add(query_593917, "api-version", newJString(apiVersion))
  add(path_593915, "subscriptionId", newJString(subscriptionId))
  result = call_593914.call(path_593915, query_593917, nil, nil, nil)

var applicationGatewaysListAll* = Call_ApplicationGatewaysListAll_593644(
    name: "applicationGatewaysListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/applicationGateways",
    validator: validate_ApplicationGatewaysListAll_593645, base: "",
    url: url_ApplicationGatewaysListAll_593646, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsListAll_593956 = ref object of OpenApiRestCall_593422
proc url_ExpressRouteCircuitsListAll_593958(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsListAll_593957(path: JsonNode; query: JsonNode;
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
  var valid_593959 = path.getOrDefault("subscriptionId")
  valid_593959 = validateParameter(valid_593959, JString, required = true,
                                 default = nil)
  if valid_593959 != nil:
    section.add "subscriptionId", valid_593959
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593960 = query.getOrDefault("api-version")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = nil)
  if valid_593960 != nil:
    section.add "api-version", valid_593960
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593961: Call_ExpressRouteCircuitsListAll_593956; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List ExpressRouteCircuit operation retrieves all the ExpressRouteCircuits in a subscription.
  ## 
  let valid = call_593961.validator(path, query, header, formData, body)
  let scheme = call_593961.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593961.url(scheme.get, call_593961.host, call_593961.base,
                         call_593961.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593961, url, valid)

proc call*(call_593962: Call_ExpressRouteCircuitsListAll_593956;
          apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteCircuitsListAll
  ## The List ExpressRouteCircuit operation retrieves all the ExpressRouteCircuits in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593963 = newJObject()
  var query_593964 = newJObject()
  add(query_593964, "api-version", newJString(apiVersion))
  add(path_593963, "subscriptionId", newJString(subscriptionId))
  result = call_593962.call(path_593963, query_593964, nil, nil, nil)

var expressRouteCircuitsListAll* = Call_ExpressRouteCircuitsListAll_593956(
    name: "expressRouteCircuitsListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/expressRouteCircuits",
    validator: validate_ExpressRouteCircuitsListAll_593957, base: "",
    url: url_ExpressRouteCircuitsListAll_593958, schemes: {Scheme.Https})
type
  Call_ExpressRouteServiceProvidersList_593965 = ref object of OpenApiRestCall_593422
proc url_ExpressRouteServiceProvidersList_593967(protocol: Scheme; host: string;
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

proc validate_ExpressRouteServiceProvidersList_593966(path: JsonNode;
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
  var valid_593968 = path.getOrDefault("subscriptionId")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "subscriptionId", valid_593968
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593969 = query.getOrDefault("api-version")
  valid_593969 = validateParameter(valid_593969, JString, required = true,
                                 default = nil)
  if valid_593969 != nil:
    section.add "api-version", valid_593969
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593970: Call_ExpressRouteServiceProvidersList_593965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The List ExpressRouteServiceProvider operation retrieves all the available ExpressRouteServiceProviders.
  ## 
  let valid = call_593970.validator(path, query, header, formData, body)
  let scheme = call_593970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593970.url(scheme.get, call_593970.host, call_593970.base,
                         call_593970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593970, url, valid)

proc call*(call_593971: Call_ExpressRouteServiceProvidersList_593965;
          apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteServiceProvidersList
  ## The List ExpressRouteServiceProvider operation retrieves all the available ExpressRouteServiceProviders.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593972 = newJObject()
  var query_593973 = newJObject()
  add(query_593973, "api-version", newJString(apiVersion))
  add(path_593972, "subscriptionId", newJString(subscriptionId))
  result = call_593971.call(path_593972, query_593973, nil, nil, nil)

var expressRouteServiceProvidersList* = Call_ExpressRouteServiceProvidersList_593965(
    name: "expressRouteServiceProvidersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/expressRouteServiceProviders",
    validator: validate_ExpressRouteServiceProvidersList_593966, base: "",
    url: url_ExpressRouteServiceProvidersList_593967, schemes: {Scheme.Https})
type
  Call_LoadBalancersListAll_593974 = ref object of OpenApiRestCall_593422
proc url_LoadBalancersListAll_593976(protocol: Scheme; host: string; base: string;
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

proc validate_LoadBalancersListAll_593975(path: JsonNode; query: JsonNode;
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
  var valid_593977 = path.getOrDefault("subscriptionId")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "subscriptionId", valid_593977
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593978 = query.getOrDefault("api-version")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "api-version", valid_593978
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593979: Call_LoadBalancersListAll_593974; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List loadBalancer operation retrieves all the load balancers in a subscription.
  ## 
  let valid = call_593979.validator(path, query, header, formData, body)
  let scheme = call_593979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593979.url(scheme.get, call_593979.host, call_593979.base,
                         call_593979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593979, url, valid)

proc call*(call_593980: Call_LoadBalancersListAll_593974; apiVersion: string;
          subscriptionId: string): Recallable =
  ## loadBalancersListAll
  ## The List loadBalancer operation retrieves all the load balancers in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593981 = newJObject()
  var query_593982 = newJObject()
  add(query_593982, "api-version", newJString(apiVersion))
  add(path_593981, "subscriptionId", newJString(subscriptionId))
  result = call_593980.call(path_593981, query_593982, nil, nil, nil)

var loadBalancersListAll* = Call_LoadBalancersListAll_593974(
    name: "loadBalancersListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/loadBalancers",
    validator: validate_LoadBalancersListAll_593975, base: "",
    url: url_LoadBalancersListAll_593976, schemes: {Scheme.Https})
type
  Call_CheckDnsNameAvailability_593983 = ref object of OpenApiRestCall_593422
proc url_CheckDnsNameAvailability_593985(protocol: Scheme; host: string;
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

proc validate_CheckDnsNameAvailability_593984(path: JsonNode; query: JsonNode;
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
  var valid_593986 = path.getOrDefault("subscriptionId")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "subscriptionId", valid_593986
  var valid_593987 = path.getOrDefault("location")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "location", valid_593987
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   domainNameLabel: JString
  ##                  : The domain name to be verified. It must conform to the following regular expression: ^[a-z][a-z0-9-]{1,61}[a-z0-9]$.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593988 = query.getOrDefault("api-version")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "api-version", valid_593988
  var valid_593989 = query.getOrDefault("domainNameLabel")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "domainNameLabel", valid_593989
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593990: Call_CheckDnsNameAvailability_593983; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether a domain name in the cloudapp.net zone is available for use.
  ## 
  let valid = call_593990.validator(path, query, header, formData, body)
  let scheme = call_593990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593990.url(scheme.get, call_593990.host, call_593990.base,
                         call_593990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593990, url, valid)

proc call*(call_593991: Call_CheckDnsNameAvailability_593983; apiVersion: string;
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
  var path_593992 = newJObject()
  var query_593993 = newJObject()
  add(query_593993, "api-version", newJString(apiVersion))
  add(path_593992, "subscriptionId", newJString(subscriptionId))
  add(query_593993, "domainNameLabel", newJString(domainNameLabel))
  add(path_593992, "location", newJString(location))
  result = call_593991.call(path_593992, query_593993, nil, nil, nil)

var checkDnsNameAvailability* = Call_CheckDnsNameAvailability_593983(
    name: "checkDnsNameAvailability", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/locations/{location}/CheckDnsNameAvailability",
    validator: validate_CheckDnsNameAvailability_593984, base: "",
    url: url_CheckDnsNameAvailability_593985, schemes: {Scheme.Https})
type
  Call_UsagesList_593994 = ref object of OpenApiRestCall_593422
proc url_UsagesList_593996(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UsagesList_593995(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593997 = path.getOrDefault("subscriptionId")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "subscriptionId", valid_593997
  var valid_593998 = path.getOrDefault("location")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "location", valid_593998
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593999 = query.getOrDefault("api-version")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "api-version", valid_593999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594000: Call_UsagesList_593994; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists compute usages for a subscription.
  ## 
  let valid = call_594000.validator(path, query, header, formData, body)
  let scheme = call_594000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594000.url(scheme.get, call_594000.host, call_594000.base,
                         call_594000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594000, url, valid)

proc call*(call_594001: Call_UsagesList_593994; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## usagesList
  ## Lists compute usages for a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location upon which resource usage is queried.
  var path_594002 = newJObject()
  var query_594003 = newJObject()
  add(query_594003, "api-version", newJString(apiVersion))
  add(path_594002, "subscriptionId", newJString(subscriptionId))
  add(path_594002, "location", newJString(location))
  result = call_594001.call(path_594002, query_594003, nil, nil, nil)

var usagesList* = Call_UsagesList_593994(name: "usagesList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/locations/{location}/usages",
                                      validator: validate_UsagesList_593995,
                                      base: "", url: url_UsagesList_593996,
                                      schemes: {Scheme.Https})
type
  Call_NetworkInterfacesListAll_594004 = ref object of OpenApiRestCall_593422
proc url_NetworkInterfacesListAll_594006(protocol: Scheme; host: string;
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

proc validate_NetworkInterfacesListAll_594005(path: JsonNode; query: JsonNode;
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
  var valid_594007 = path.getOrDefault("subscriptionId")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "subscriptionId", valid_594007
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594008 = query.getOrDefault("api-version")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "api-version", valid_594008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594009: Call_NetworkInterfacesListAll_594004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List networkInterfaces operation retrieves all the networkInterfaces in a subscription.
  ## 
  let valid = call_594009.validator(path, query, header, formData, body)
  let scheme = call_594009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594009.url(scheme.get, call_594009.host, call_594009.base,
                         call_594009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594009, url, valid)

proc call*(call_594010: Call_NetworkInterfacesListAll_594004; apiVersion: string;
          subscriptionId: string): Recallable =
  ## networkInterfacesListAll
  ## The List networkInterfaces operation retrieves all the networkInterfaces in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594011 = newJObject()
  var query_594012 = newJObject()
  add(query_594012, "api-version", newJString(apiVersion))
  add(path_594011, "subscriptionId", newJString(subscriptionId))
  result = call_594010.call(path_594011, query_594012, nil, nil, nil)

var networkInterfacesListAll* = Call_NetworkInterfacesListAll_594004(
    name: "networkInterfacesListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/networkInterfaces",
    validator: validate_NetworkInterfacesListAll_594005, base: "",
    url: url_NetworkInterfacesListAll_594006, schemes: {Scheme.Https})
type
  Call_NetworkSecurityGroupsListAll_594013 = ref object of OpenApiRestCall_593422
proc url_NetworkSecurityGroupsListAll_594015(protocol: Scheme; host: string;
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

proc validate_NetworkSecurityGroupsListAll_594014(path: JsonNode; query: JsonNode;
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
  var valid_594016 = path.getOrDefault("subscriptionId")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "subscriptionId", valid_594016
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594017 = query.getOrDefault("api-version")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "api-version", valid_594017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594018: Call_NetworkSecurityGroupsListAll_594013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list NetworkSecurityGroups returns all network security groups in a subscription
  ## 
  let valid = call_594018.validator(path, query, header, formData, body)
  let scheme = call_594018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594018.url(scheme.get, call_594018.host, call_594018.base,
                         call_594018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594018, url, valid)

proc call*(call_594019: Call_NetworkSecurityGroupsListAll_594013;
          apiVersion: string; subscriptionId: string): Recallable =
  ## networkSecurityGroupsListAll
  ## The list NetworkSecurityGroups returns all network security groups in a subscription
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594020 = newJObject()
  var query_594021 = newJObject()
  add(query_594021, "api-version", newJString(apiVersion))
  add(path_594020, "subscriptionId", newJString(subscriptionId))
  result = call_594019.call(path_594020, query_594021, nil, nil, nil)

var networkSecurityGroupsListAll* = Call_NetworkSecurityGroupsListAll_594013(
    name: "networkSecurityGroupsListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/networkSecurityGroups",
    validator: validate_NetworkSecurityGroupsListAll_594014, base: "",
    url: url_NetworkSecurityGroupsListAll_594015, schemes: {Scheme.Https})
type
  Call_PublicIPAddressesListAll_594022 = ref object of OpenApiRestCall_593422
proc url_PublicIPAddressesListAll_594024(protocol: Scheme; host: string;
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

proc validate_PublicIPAddressesListAll_594023(path: JsonNode; query: JsonNode;
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
  var valid_594025 = path.getOrDefault("subscriptionId")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "subscriptionId", valid_594025
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594026 = query.getOrDefault("api-version")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "api-version", valid_594026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594027: Call_PublicIPAddressesListAll_594022; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List publicIpAddress operation retrieves all the publicIpAddresses in a subscription.
  ## 
  let valid = call_594027.validator(path, query, header, formData, body)
  let scheme = call_594027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594027.url(scheme.get, call_594027.host, call_594027.base,
                         call_594027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594027, url, valid)

proc call*(call_594028: Call_PublicIPAddressesListAll_594022; apiVersion: string;
          subscriptionId: string): Recallable =
  ## publicIPAddressesListAll
  ## The List publicIpAddress operation retrieves all the publicIpAddresses in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594029 = newJObject()
  var query_594030 = newJObject()
  add(query_594030, "api-version", newJString(apiVersion))
  add(path_594029, "subscriptionId", newJString(subscriptionId))
  result = call_594028.call(path_594029, query_594030, nil, nil, nil)

var publicIPAddressesListAll* = Call_PublicIPAddressesListAll_594022(
    name: "publicIPAddressesListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/publicIPAddresses",
    validator: validate_PublicIPAddressesListAll_594023, base: "",
    url: url_PublicIPAddressesListAll_594024, schemes: {Scheme.Https})
type
  Call_RouteTablesListAll_594031 = ref object of OpenApiRestCall_593422
proc url_RouteTablesListAll_594033(protocol: Scheme; host: string; base: string;
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

proc validate_RouteTablesListAll_594032(path: JsonNode; query: JsonNode;
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
  var valid_594034 = path.getOrDefault("subscriptionId")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "subscriptionId", valid_594034
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594035 = query.getOrDefault("api-version")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "api-version", valid_594035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594036: Call_RouteTablesListAll_594031; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list RouteTables returns all route tables in a subscription
  ## 
  let valid = call_594036.validator(path, query, header, formData, body)
  let scheme = call_594036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594036.url(scheme.get, call_594036.host, call_594036.base,
                         call_594036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594036, url, valid)

proc call*(call_594037: Call_RouteTablesListAll_594031; apiVersion: string;
          subscriptionId: string): Recallable =
  ## routeTablesListAll
  ## The list RouteTables returns all route tables in a subscription
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594038 = newJObject()
  var query_594039 = newJObject()
  add(query_594039, "api-version", newJString(apiVersion))
  add(path_594038, "subscriptionId", newJString(subscriptionId))
  result = call_594037.call(path_594038, query_594039, nil, nil, nil)

var routeTablesListAll* = Call_RouteTablesListAll_594031(
    name: "routeTablesListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/routeTables",
    validator: validate_RouteTablesListAll_594032, base: "",
    url: url_RouteTablesListAll_594033, schemes: {Scheme.Https})
type
  Call_VirtualNetworksListAll_594040 = ref object of OpenApiRestCall_593422
proc url_VirtualNetworksListAll_594042(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksListAll_594041(path: JsonNode; query: JsonNode;
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
  var valid_594043 = path.getOrDefault("subscriptionId")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "subscriptionId", valid_594043
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594044 = query.getOrDefault("api-version")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "api-version", valid_594044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594045: Call_VirtualNetworksListAll_594040; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list VirtualNetwork returns all Virtual Networks in a subscription
  ## 
  let valid = call_594045.validator(path, query, header, formData, body)
  let scheme = call_594045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594045.url(scheme.get, call_594045.host, call_594045.base,
                         call_594045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594045, url, valid)

proc call*(call_594046: Call_VirtualNetworksListAll_594040; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualNetworksListAll
  ## The list VirtualNetwork returns all Virtual Networks in a subscription
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594047 = newJObject()
  var query_594048 = newJObject()
  add(query_594048, "api-version", newJString(apiVersion))
  add(path_594047, "subscriptionId", newJString(subscriptionId))
  result = call_594046.call(path_594047, query_594048, nil, nil, nil)

var virtualNetworksListAll* = Call_VirtualNetworksListAll_594040(
    name: "virtualNetworksListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/virtualNetworks",
    validator: validate_VirtualNetworksListAll_594041, base: "",
    url: url_VirtualNetworksListAll_594042, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysList_594049 = ref object of OpenApiRestCall_593422
proc url_ApplicationGatewaysList_594051(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationGatewaysList_594050(path: JsonNode; query: JsonNode;
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
  var valid_594052 = path.getOrDefault("resourceGroupName")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "resourceGroupName", valid_594052
  var valid_594053 = path.getOrDefault("subscriptionId")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "subscriptionId", valid_594053
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594054 = query.getOrDefault("api-version")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "api-version", valid_594054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594055: Call_ApplicationGatewaysList_594049; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List ApplicationGateway operation retrieves all the application gateways in a resource group.
  ## 
  let valid = call_594055.validator(path, query, header, formData, body)
  let scheme = call_594055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594055.url(scheme.get, call_594055.host, call_594055.base,
                         call_594055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594055, url, valid)

proc call*(call_594056: Call_ApplicationGatewaysList_594049;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## applicationGatewaysList
  ## The List ApplicationGateway operation retrieves all the application gateways in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594057 = newJObject()
  var query_594058 = newJObject()
  add(path_594057, "resourceGroupName", newJString(resourceGroupName))
  add(query_594058, "api-version", newJString(apiVersion))
  add(path_594057, "subscriptionId", newJString(subscriptionId))
  result = call_594056.call(path_594057, query_594058, nil, nil, nil)

var applicationGatewaysList* = Call_ApplicationGatewaysList_594049(
    name: "applicationGatewaysList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways",
    validator: validate_ApplicationGatewaysList_594050, base: "",
    url: url_ApplicationGatewaysList_594051, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysCreateOrUpdate_594070 = ref object of OpenApiRestCall_593422
proc url_ApplicationGatewaysCreateOrUpdate_594072(protocol: Scheme; host: string;
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

proc validate_ApplicationGatewaysCreateOrUpdate_594071(path: JsonNode;
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
  var valid_594090 = path.getOrDefault("resourceGroupName")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "resourceGroupName", valid_594090
  var valid_594091 = path.getOrDefault("subscriptionId")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "subscriptionId", valid_594091
  var valid_594092 = path.getOrDefault("applicationGatewayName")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "applicationGatewayName", valid_594092
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594093 = query.getOrDefault("api-version")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "api-version", valid_594093
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

proc call*(call_594095: Call_ApplicationGatewaysCreateOrUpdate_594070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put ApplicationGateway operation creates/updates a ApplicationGateway
  ## 
  let valid = call_594095.validator(path, query, header, formData, body)
  let scheme = call_594095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594095.url(scheme.get, call_594095.host, call_594095.base,
                         call_594095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594095, url, valid)

proc call*(call_594096: Call_ApplicationGatewaysCreateOrUpdate_594070;
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
  var path_594097 = newJObject()
  var query_594098 = newJObject()
  var body_594099 = newJObject()
  add(path_594097, "resourceGroupName", newJString(resourceGroupName))
  add(query_594098, "api-version", newJString(apiVersion))
  add(path_594097, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594099 = parameters
  add(path_594097, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_594096.call(path_594097, query_594098, nil, nil, body_594099)

var applicationGatewaysCreateOrUpdate* = Call_ApplicationGatewaysCreateOrUpdate_594070(
    name: "applicationGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}",
    validator: validate_ApplicationGatewaysCreateOrUpdate_594071, base: "",
    url: url_ApplicationGatewaysCreateOrUpdate_594072, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysGet_594059 = ref object of OpenApiRestCall_593422
proc url_ApplicationGatewaysGet_594061(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationGatewaysGet_594060(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get application gateway operation retrieves information about the specified application gateway.
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
  var valid_594062 = path.getOrDefault("resourceGroupName")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "resourceGroupName", valid_594062
  var valid_594063 = path.getOrDefault("subscriptionId")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "subscriptionId", valid_594063
  var valid_594064 = path.getOrDefault("applicationGatewayName")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "applicationGatewayName", valid_594064
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594065 = query.getOrDefault("api-version")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "api-version", valid_594065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594066: Call_ApplicationGatewaysGet_594059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get application gateway operation retrieves information about the specified application gateway.
  ## 
  let valid = call_594066.validator(path, query, header, formData, body)
  let scheme = call_594066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594066.url(scheme.get, call_594066.host, call_594066.base,
                         call_594066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594066, url, valid)

proc call*(call_594067: Call_ApplicationGatewaysGet_594059;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          applicationGatewayName: string): Recallable =
  ## applicationGatewaysGet
  ## The Get application gateway operation retrieves information about the specified application gateway.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: string (required)
  ##                         : The name of the application gateway.
  var path_594068 = newJObject()
  var query_594069 = newJObject()
  add(path_594068, "resourceGroupName", newJString(resourceGroupName))
  add(query_594069, "api-version", newJString(apiVersion))
  add(path_594068, "subscriptionId", newJString(subscriptionId))
  add(path_594068, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_594067.call(path_594068, query_594069, nil, nil, nil)

var applicationGatewaysGet* = Call_ApplicationGatewaysGet_594059(
    name: "applicationGatewaysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}",
    validator: validate_ApplicationGatewaysGet_594060, base: "",
    url: url_ApplicationGatewaysGet_594061, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysDelete_594100 = ref object of OpenApiRestCall_593422
proc url_ApplicationGatewaysDelete_594102(protocol: Scheme; host: string;
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

proc validate_ApplicationGatewaysDelete_594101(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The delete application gateway operation deletes the specified application gateway.
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
  var valid_594103 = path.getOrDefault("resourceGroupName")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "resourceGroupName", valid_594103
  var valid_594104 = path.getOrDefault("subscriptionId")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "subscriptionId", valid_594104
  var valid_594105 = path.getOrDefault("applicationGatewayName")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "applicationGatewayName", valid_594105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594106 = query.getOrDefault("api-version")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "api-version", valid_594106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594107: Call_ApplicationGatewaysDelete_594100; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete application gateway operation deletes the specified application gateway.
  ## 
  let valid = call_594107.validator(path, query, header, formData, body)
  let scheme = call_594107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594107.url(scheme.get, call_594107.host, call_594107.base,
                         call_594107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594107, url, valid)

proc call*(call_594108: Call_ApplicationGatewaysDelete_594100;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          applicationGatewayName: string): Recallable =
  ## applicationGatewaysDelete
  ## The delete application gateway operation deletes the specified application gateway.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationGatewayName: string (required)
  ##                         : The name of the application gateway.
  var path_594109 = newJObject()
  var query_594110 = newJObject()
  add(path_594109, "resourceGroupName", newJString(resourceGroupName))
  add(query_594110, "api-version", newJString(apiVersion))
  add(path_594109, "subscriptionId", newJString(subscriptionId))
  add(path_594109, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_594108.call(path_594109, query_594110, nil, nil, nil)

var applicationGatewaysDelete* = Call_ApplicationGatewaysDelete_594100(
    name: "applicationGatewaysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}",
    validator: validate_ApplicationGatewaysDelete_594101, base: "",
    url: url_ApplicationGatewaysDelete_594102, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysStart_594111 = ref object of OpenApiRestCall_593422
proc url_ApplicationGatewaysStart_594113(protocol: Scheme; host: string;
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

proc validate_ApplicationGatewaysStart_594112(path: JsonNode; query: JsonNode;
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
  var valid_594114 = path.getOrDefault("resourceGroupName")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "resourceGroupName", valid_594114
  var valid_594115 = path.getOrDefault("subscriptionId")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "subscriptionId", valid_594115
  var valid_594116 = path.getOrDefault("applicationGatewayName")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "applicationGatewayName", valid_594116
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594117 = query.getOrDefault("api-version")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "api-version", valid_594117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594118: Call_ApplicationGatewaysStart_594111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Start ApplicationGateway operation starts application gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_594118.validator(path, query, header, formData, body)
  let scheme = call_594118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594118.url(scheme.get, call_594118.host, call_594118.base,
                         call_594118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594118, url, valid)

proc call*(call_594119: Call_ApplicationGatewaysStart_594111;
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
  var path_594120 = newJObject()
  var query_594121 = newJObject()
  add(path_594120, "resourceGroupName", newJString(resourceGroupName))
  add(query_594121, "api-version", newJString(apiVersion))
  add(path_594120, "subscriptionId", newJString(subscriptionId))
  add(path_594120, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_594119.call(path_594120, query_594121, nil, nil, nil)

var applicationGatewaysStart* = Call_ApplicationGatewaysStart_594111(
    name: "applicationGatewaysStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}/start",
    validator: validate_ApplicationGatewaysStart_594112, base: "",
    url: url_ApplicationGatewaysStart_594113, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysStop_594122 = ref object of OpenApiRestCall_593422
proc url_ApplicationGatewaysStop_594124(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationGatewaysStop_594123(path: JsonNode; query: JsonNode;
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
  var valid_594125 = path.getOrDefault("resourceGroupName")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "resourceGroupName", valid_594125
  var valid_594126 = path.getOrDefault("subscriptionId")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "subscriptionId", valid_594126
  var valid_594127 = path.getOrDefault("applicationGatewayName")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "applicationGatewayName", valid_594127
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594128 = query.getOrDefault("api-version")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "api-version", valid_594128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594129: Call_ApplicationGatewaysStop_594122; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The STOP ApplicationGateway operation stops application gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_594129.validator(path, query, header, formData, body)
  let scheme = call_594129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594129.url(scheme.get, call_594129.host, call_594129.base,
                         call_594129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594129, url, valid)

proc call*(call_594130: Call_ApplicationGatewaysStop_594122;
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
  var path_594131 = newJObject()
  var query_594132 = newJObject()
  add(path_594131, "resourceGroupName", newJString(resourceGroupName))
  add(query_594132, "api-version", newJString(apiVersion))
  add(path_594131, "subscriptionId", newJString(subscriptionId))
  add(path_594131, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_594130.call(path_594131, query_594132, nil, nil, nil)

var applicationGatewaysStop* = Call_ApplicationGatewaysStop_594122(
    name: "applicationGatewaysStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}/stop",
    validator: validate_ApplicationGatewaysStop_594123, base: "",
    url: url_ApplicationGatewaysStop_594124, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsList_594133 = ref object of OpenApiRestCall_593422
proc url_VirtualNetworkGatewayConnectionsList_594135(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsList_594134(path: JsonNode;
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
  var valid_594136 = path.getOrDefault("resourceGroupName")
  valid_594136 = validateParameter(valid_594136, JString, required = true,
                                 default = nil)
  if valid_594136 != nil:
    section.add "resourceGroupName", valid_594136
  var valid_594137 = path.getOrDefault("subscriptionId")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = nil)
  if valid_594137 != nil:
    section.add "subscriptionId", valid_594137
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594138 = query.getOrDefault("api-version")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "api-version", valid_594138
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594139: Call_VirtualNetworkGatewayConnectionsList_594133;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The List VirtualNetworkGatewayConnections operation retrieves all the virtual network gateways connections created.
  ## 
  let valid = call_594139.validator(path, query, header, formData, body)
  let scheme = call_594139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594139.url(scheme.get, call_594139.host, call_594139.base,
                         call_594139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594139, url, valid)

proc call*(call_594140: Call_VirtualNetworkGatewayConnectionsList_594133;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualNetworkGatewayConnectionsList
  ## The List VirtualNetworkGatewayConnections operation retrieves all the virtual network gateways connections created.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594141 = newJObject()
  var query_594142 = newJObject()
  add(path_594141, "resourceGroupName", newJString(resourceGroupName))
  add(query_594142, "api-version", newJString(apiVersion))
  add(path_594141, "subscriptionId", newJString(subscriptionId))
  result = call_594140.call(path_594141, query_594142, nil, nil, nil)

var virtualNetworkGatewayConnectionsList* = Call_VirtualNetworkGatewayConnectionsList_594133(
    name: "virtualNetworkGatewayConnectionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections",
    validator: validate_VirtualNetworkGatewayConnectionsList_594134, base: "",
    url: url_VirtualNetworkGatewayConnectionsList_594135, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_594154 = ref object of OpenApiRestCall_593422
proc url_VirtualNetworkGatewayConnectionsCreateOrUpdate_594156(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsCreateOrUpdate_594155(
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
  var valid_594159 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_594159
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594160 = query.getOrDefault("api-version")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "api-version", valid_594160
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

proc call*(call_594162: Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_594154;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put VirtualNetworkGatewayConnection operation creates/updates a virtual network gateway connection in the specified resource group through Network resource provider.
  ## 
  let valid = call_594162.validator(path, query, header, formData, body)
  let scheme = call_594162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594162.url(scheme.get, call_594162.host, call_594162.base,
                         call_594162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594162, url, valid)

proc call*(call_594163: Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_594154;
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
  var path_594164 = newJObject()
  var query_594165 = newJObject()
  var body_594166 = newJObject()
  add(path_594164, "resourceGroupName", newJString(resourceGroupName))
  add(query_594165, "api-version", newJString(apiVersion))
  add(path_594164, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594166 = parameters
  add(path_594164, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_594163.call(path_594164, query_594165, nil, nil, body_594166)

var virtualNetworkGatewayConnectionsCreateOrUpdate* = Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_594154(
    name: "virtualNetworkGatewayConnectionsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}",
    validator: validate_VirtualNetworkGatewayConnectionsCreateOrUpdate_594155,
    base: "", url: url_VirtualNetworkGatewayConnectionsCreateOrUpdate_594156,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsGet_594143 = ref object of OpenApiRestCall_593422
proc url_VirtualNetworkGatewayConnectionsGet_594145(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGatewayConnectionsGet_594144(path: JsonNode;
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
  var valid_594146 = path.getOrDefault("resourceGroupName")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "resourceGroupName", valid_594146
  var valid_594147 = path.getOrDefault("subscriptionId")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "subscriptionId", valid_594147
  var valid_594148 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_594148
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594149 = query.getOrDefault("api-version")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "api-version", valid_594149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594150: Call_VirtualNetworkGatewayConnectionsGet_594143;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Get VirtualNetworkGatewayConnection operation retrieves information about the specified virtual network gateway connection through Network resource provider.
  ## 
  let valid = call_594150.validator(path, query, header, formData, body)
  let scheme = call_594150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594150.url(scheme.get, call_594150.host, call_594150.base,
                         call_594150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594150, url, valid)

proc call*(call_594151: Call_VirtualNetworkGatewayConnectionsGet_594143;
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
  var path_594152 = newJObject()
  var query_594153 = newJObject()
  add(path_594152, "resourceGroupName", newJString(resourceGroupName))
  add(query_594153, "api-version", newJString(apiVersion))
  add(path_594152, "subscriptionId", newJString(subscriptionId))
  add(path_594152, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_594151.call(path_594152, query_594153, nil, nil, nil)

var virtualNetworkGatewayConnectionsGet* = Call_VirtualNetworkGatewayConnectionsGet_594143(
    name: "virtualNetworkGatewayConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}",
    validator: validate_VirtualNetworkGatewayConnectionsGet_594144, base: "",
    url: url_VirtualNetworkGatewayConnectionsGet_594145, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsDelete_594167 = ref object of OpenApiRestCall_593422
proc url_VirtualNetworkGatewayConnectionsDelete_594169(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsDelete_594168(path: JsonNode;
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
  var valid_594170 = path.getOrDefault("resourceGroupName")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "resourceGroupName", valid_594170
  var valid_594171 = path.getOrDefault("subscriptionId")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "subscriptionId", valid_594171
  var valid_594172 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = nil)
  if valid_594172 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_594172
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594173 = query.getOrDefault("api-version")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "api-version", valid_594173
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594174: Call_VirtualNetworkGatewayConnectionsDelete_594167;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Delete VirtualNetworkGatewayConnection operation deletes the specified virtual network Gateway connection through Network resource provider.
  ## 
  let valid = call_594174.validator(path, query, header, formData, body)
  let scheme = call_594174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594174.url(scheme.get, call_594174.host, call_594174.base,
                         call_594174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594174, url, valid)

proc call*(call_594175: Call_VirtualNetworkGatewayConnectionsDelete_594167;
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
  var path_594176 = newJObject()
  var query_594177 = newJObject()
  add(path_594176, "resourceGroupName", newJString(resourceGroupName))
  add(query_594177, "api-version", newJString(apiVersion))
  add(path_594176, "subscriptionId", newJString(subscriptionId))
  add(path_594176, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_594175.call(path_594176, query_594177, nil, nil, nil)

var virtualNetworkGatewayConnectionsDelete* = Call_VirtualNetworkGatewayConnectionsDelete_594167(
    name: "virtualNetworkGatewayConnectionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}",
    validator: validate_VirtualNetworkGatewayConnectionsDelete_594168, base: "",
    url: url_VirtualNetworkGatewayConnectionsDelete_594169,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsSetSharedKey_594189 = ref object of OpenApiRestCall_593422
proc url_VirtualNetworkGatewayConnectionsSetSharedKey_594191(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsSetSharedKey_594190(path: JsonNode;
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
  var valid_594192 = path.getOrDefault("resourceGroupName")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "resourceGroupName", valid_594192
  var valid_594193 = path.getOrDefault("subscriptionId")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "subscriptionId", valid_594193
  var valid_594194 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_594194
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594195 = query.getOrDefault("api-version")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "api-version", valid_594195
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

proc call*(call_594197: Call_VirtualNetworkGatewayConnectionsSetSharedKey_594189;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put VirtualNetworkGatewayConnectionSharedKey operation sets the virtual network gateway connection shared key for passed virtual network gateway connection in the specified resource group through Network resource provider.
  ## 
  let valid = call_594197.validator(path, query, header, formData, body)
  let scheme = call_594197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594197.url(scheme.get, call_594197.host, call_594197.base,
                         call_594197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594197, url, valid)

proc call*(call_594198: Call_VirtualNetworkGatewayConnectionsSetSharedKey_594189;
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
  ##             : Parameters supplied to the Begin Set Virtual Network Gateway connection Shared key operation through Network resource provider.
  ##   virtualNetworkGatewayConnectionName: string (required)
  ##                                      : The virtual network gateway connection name.
  var path_594199 = newJObject()
  var query_594200 = newJObject()
  var body_594201 = newJObject()
  add(path_594199, "resourceGroupName", newJString(resourceGroupName))
  add(query_594200, "api-version", newJString(apiVersion))
  add(path_594199, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594201 = parameters
  add(path_594199, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_594198.call(path_594199, query_594200, nil, nil, body_594201)

var virtualNetworkGatewayConnectionsSetSharedKey* = Call_VirtualNetworkGatewayConnectionsSetSharedKey_594189(
    name: "virtualNetworkGatewayConnectionsSetSharedKey",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/sharedkey",
    validator: validate_VirtualNetworkGatewayConnectionsSetSharedKey_594190,
    base: "", url: url_VirtualNetworkGatewayConnectionsSetSharedKey_594191,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsGetSharedKey_594178 = ref object of OpenApiRestCall_593422
proc url_VirtualNetworkGatewayConnectionsGetSharedKey_594180(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsGetSharedKey_594179(path: JsonNode;
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
  var valid_594181 = path.getOrDefault("resourceGroupName")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "resourceGroupName", valid_594181
  var valid_594182 = path.getOrDefault("subscriptionId")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "subscriptionId", valid_594182
  var valid_594183 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_594183
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594184 = query.getOrDefault("api-version")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "api-version", valid_594184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594185: Call_VirtualNetworkGatewayConnectionsGetSharedKey_594178;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Get VirtualNetworkGatewayConnectionSharedKey operation retrieves information about the specified virtual network gateway connection shared key through Network resource provider.
  ## 
  let valid = call_594185.validator(path, query, header, formData, body)
  let scheme = call_594185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594185.url(scheme.get, call_594185.host, call_594185.base,
                         call_594185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594185, url, valid)

proc call*(call_594186: Call_VirtualNetworkGatewayConnectionsGetSharedKey_594178;
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
  var path_594187 = newJObject()
  var query_594188 = newJObject()
  add(path_594187, "resourceGroupName", newJString(resourceGroupName))
  add(query_594188, "api-version", newJString(apiVersion))
  add(path_594187, "subscriptionId", newJString(subscriptionId))
  add(path_594187, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_594186.call(path_594187, query_594188, nil, nil, nil)

var virtualNetworkGatewayConnectionsGetSharedKey* = Call_VirtualNetworkGatewayConnectionsGetSharedKey_594178(
    name: "virtualNetworkGatewayConnectionsGetSharedKey",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/sharedkey",
    validator: validate_VirtualNetworkGatewayConnectionsGetSharedKey_594179,
    base: "", url: url_VirtualNetworkGatewayConnectionsGetSharedKey_594180,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsResetSharedKey_594202 = ref object of OpenApiRestCall_593422
proc url_VirtualNetworkGatewayConnectionsResetSharedKey_594204(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsResetSharedKey_594203(
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
  var valid_594205 = path.getOrDefault("resourceGroupName")
  valid_594205 = validateParameter(valid_594205, JString, required = true,
                                 default = nil)
  if valid_594205 != nil:
    section.add "resourceGroupName", valid_594205
  var valid_594206 = path.getOrDefault("subscriptionId")
  valid_594206 = validateParameter(valid_594206, JString, required = true,
                                 default = nil)
  if valid_594206 != nil:
    section.add "subscriptionId", valid_594206
  var valid_594207 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_594207
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594208 = query.getOrDefault("api-version")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "api-version", valid_594208
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

proc call*(call_594210: Call_VirtualNetworkGatewayConnectionsResetSharedKey_594202;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The VirtualNetworkGatewayConnectionResetSharedKey operation resets the virtual network gateway connection shared key for passed virtual network gateway connection in the specified resource group through Network resource provider.
  ## 
  let valid = call_594210.validator(path, query, header, formData, body)
  let scheme = call_594210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594210.url(scheme.get, call_594210.host, call_594210.base,
                         call_594210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594210, url, valid)

proc call*(call_594211: Call_VirtualNetworkGatewayConnectionsResetSharedKey_594202;
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
  var path_594212 = newJObject()
  var query_594213 = newJObject()
  var body_594214 = newJObject()
  add(path_594212, "resourceGroupName", newJString(resourceGroupName))
  add(query_594213, "api-version", newJString(apiVersion))
  add(path_594212, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594214 = parameters
  add(path_594212, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_594211.call(path_594212, query_594213, nil, nil, body_594214)

var virtualNetworkGatewayConnectionsResetSharedKey* = Call_VirtualNetworkGatewayConnectionsResetSharedKey_594202(
    name: "virtualNetworkGatewayConnectionsResetSharedKey",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/sharedkey/reset",
    validator: validate_VirtualNetworkGatewayConnectionsResetSharedKey_594203,
    base: "", url: url_VirtualNetworkGatewayConnectionsResetSharedKey_594204,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsList_594215 = ref object of OpenApiRestCall_593422
proc url_ExpressRouteCircuitsList_594217(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsList_594216(path: JsonNode; query: JsonNode;
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
  var valid_594218 = path.getOrDefault("resourceGroupName")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "resourceGroupName", valid_594218
  var valid_594219 = path.getOrDefault("subscriptionId")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = nil)
  if valid_594219 != nil:
    section.add "subscriptionId", valid_594219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594220 = query.getOrDefault("api-version")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "api-version", valid_594220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594221: Call_ExpressRouteCircuitsList_594215; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List ExpressRouteCircuit operation retrieves all the ExpressRouteCircuits in a resource group.
  ## 
  let valid = call_594221.validator(path, query, header, formData, body)
  let scheme = call_594221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594221.url(scheme.get, call_594221.host, call_594221.base,
                         call_594221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594221, url, valid)

proc call*(call_594222: Call_ExpressRouteCircuitsList_594215;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteCircuitsList
  ## The List ExpressRouteCircuit operation retrieves all the ExpressRouteCircuits in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594223 = newJObject()
  var query_594224 = newJObject()
  add(path_594223, "resourceGroupName", newJString(resourceGroupName))
  add(query_594224, "api-version", newJString(apiVersion))
  add(path_594223, "subscriptionId", newJString(subscriptionId))
  result = call_594222.call(path_594223, query_594224, nil, nil, nil)

var expressRouteCircuitsList* = Call_ExpressRouteCircuitsList_594215(
    name: "expressRouteCircuitsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits",
    validator: validate_ExpressRouteCircuitsList_594216, base: "",
    url: url_ExpressRouteCircuitsList_594217, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsCreateOrUpdate_594236 = ref object of OpenApiRestCall_593422
proc url_ExpressRouteCircuitsCreateOrUpdate_594238(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsCreateOrUpdate_594237(path: JsonNode;
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
  var valid_594239 = path.getOrDefault("circuitName")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "circuitName", valid_594239
  var valid_594240 = path.getOrDefault("resourceGroupName")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "resourceGroupName", valid_594240
  var valid_594241 = path.getOrDefault("subscriptionId")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "subscriptionId", valid_594241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/delete ExpressRouteCircuit operation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594244: Call_ExpressRouteCircuitsCreateOrUpdate_594236;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put ExpressRouteCircuit operation creates/updates a ExpressRouteCircuit
  ## 
  let valid = call_594244.validator(path, query, header, formData, body)
  let scheme = call_594244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594244.url(scheme.get, call_594244.host, call_594244.base,
                         call_594244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594244, url, valid)

proc call*(call_594245: Call_ExpressRouteCircuitsCreateOrUpdate_594236;
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
  var path_594246 = newJObject()
  var query_594247 = newJObject()
  var body_594248 = newJObject()
  add(path_594246, "circuitName", newJString(circuitName))
  add(path_594246, "resourceGroupName", newJString(resourceGroupName))
  add(query_594247, "api-version", newJString(apiVersion))
  add(path_594246, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594248 = parameters
  result = call_594245.call(path_594246, query_594247, nil, nil, body_594248)

var expressRouteCircuitsCreateOrUpdate* = Call_ExpressRouteCircuitsCreateOrUpdate_594236(
    name: "expressRouteCircuitsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}",
    validator: validate_ExpressRouteCircuitsCreateOrUpdate_594237, base: "",
    url: url_ExpressRouteCircuitsCreateOrUpdate_594238, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsGet_594225 = ref object of OpenApiRestCall_593422
proc url_ExpressRouteCircuitsGet_594227(protocol: Scheme; host: string; base: string;
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

proc validate_ExpressRouteCircuitsGet_594226(path: JsonNode; query: JsonNode;
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
  var valid_594228 = path.getOrDefault("circuitName")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "circuitName", valid_594228
  var valid_594229 = path.getOrDefault("resourceGroupName")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "resourceGroupName", valid_594229
  var valid_594230 = path.getOrDefault("subscriptionId")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "subscriptionId", valid_594230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594231 = query.getOrDefault("api-version")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "api-version", valid_594231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594232: Call_ExpressRouteCircuitsGet_594225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get ExpressRouteCircuit operation retrieves information about the specified ExpressRouteCircuit.
  ## 
  let valid = call_594232.validator(path, query, header, formData, body)
  let scheme = call_594232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594232.url(scheme.get, call_594232.host, call_594232.base,
                         call_594232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594232, url, valid)

proc call*(call_594233: Call_ExpressRouteCircuitsGet_594225; circuitName: string;
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
  var path_594234 = newJObject()
  var query_594235 = newJObject()
  add(path_594234, "circuitName", newJString(circuitName))
  add(path_594234, "resourceGroupName", newJString(resourceGroupName))
  add(query_594235, "api-version", newJString(apiVersion))
  add(path_594234, "subscriptionId", newJString(subscriptionId))
  result = call_594233.call(path_594234, query_594235, nil, nil, nil)

var expressRouteCircuitsGet* = Call_ExpressRouteCircuitsGet_594225(
    name: "expressRouteCircuitsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}",
    validator: validate_ExpressRouteCircuitsGet_594226, base: "",
    url: url_ExpressRouteCircuitsGet_594227, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsDelete_594249 = ref object of OpenApiRestCall_593422
proc url_ExpressRouteCircuitsDelete_594251(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsDelete_594250(path: JsonNode; query: JsonNode;
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
  var valid_594252 = path.getOrDefault("circuitName")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = nil)
  if valid_594252 != nil:
    section.add "circuitName", valid_594252
  var valid_594253 = path.getOrDefault("resourceGroupName")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = nil)
  if valid_594253 != nil:
    section.add "resourceGroupName", valid_594253
  var valid_594254 = path.getOrDefault("subscriptionId")
  valid_594254 = validateParameter(valid_594254, JString, required = true,
                                 default = nil)
  if valid_594254 != nil:
    section.add "subscriptionId", valid_594254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594255 = query.getOrDefault("api-version")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = nil)
  if valid_594255 != nil:
    section.add "api-version", valid_594255
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594256: Call_ExpressRouteCircuitsDelete_594249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete ExpressRouteCircuit operation deletes the specified ExpressRouteCircuit.
  ## 
  let valid = call_594256.validator(path, query, header, formData, body)
  let scheme = call_594256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594256.url(scheme.get, call_594256.host, call_594256.base,
                         call_594256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594256, url, valid)

proc call*(call_594257: Call_ExpressRouteCircuitsDelete_594249;
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
  var path_594258 = newJObject()
  var query_594259 = newJObject()
  add(path_594258, "circuitName", newJString(circuitName))
  add(path_594258, "resourceGroupName", newJString(resourceGroupName))
  add(query_594259, "api-version", newJString(apiVersion))
  add(path_594258, "subscriptionId", newJString(subscriptionId))
  result = call_594257.call(path_594258, query_594259, nil, nil, nil)

var expressRouteCircuitsDelete* = Call_ExpressRouteCircuitsDelete_594249(
    name: "expressRouteCircuitsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}",
    validator: validate_ExpressRouteCircuitsDelete_594250, base: "",
    url: url_ExpressRouteCircuitsDelete_594251, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsList_594260 = ref object of OpenApiRestCall_593422
proc url_ExpressRouteCircuitAuthorizationsList_594262(protocol: Scheme;
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

proc validate_ExpressRouteCircuitAuthorizationsList_594261(path: JsonNode;
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
  var valid_594263 = path.getOrDefault("circuitName")
  valid_594263 = validateParameter(valid_594263, JString, required = true,
                                 default = nil)
  if valid_594263 != nil:
    section.add "circuitName", valid_594263
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
  ##              : Client Api Version.
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

proc call*(call_594267: Call_ExpressRouteCircuitAuthorizationsList_594260;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The List authorization operation retrieves all the authorizations in an ExpressRouteCircuit.
  ## 
  let valid = call_594267.validator(path, query, header, formData, body)
  let scheme = call_594267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594267.url(scheme.get, call_594267.host, call_594267.base,
                         call_594267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594267, url, valid)

proc call*(call_594268: Call_ExpressRouteCircuitAuthorizationsList_594260;
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
  var path_594269 = newJObject()
  var query_594270 = newJObject()
  add(path_594269, "circuitName", newJString(circuitName))
  add(path_594269, "resourceGroupName", newJString(resourceGroupName))
  add(query_594270, "api-version", newJString(apiVersion))
  add(path_594269, "subscriptionId", newJString(subscriptionId))
  result = call_594268.call(path_594269, query_594270, nil, nil, nil)

var expressRouteCircuitAuthorizationsList* = Call_ExpressRouteCircuitAuthorizationsList_594260(
    name: "expressRouteCircuitAuthorizationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations",
    validator: validate_ExpressRouteCircuitAuthorizationsList_594261, base: "",
    url: url_ExpressRouteCircuitAuthorizationsList_594262, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_594283 = ref object of OpenApiRestCall_593422
proc url_ExpressRouteCircuitAuthorizationsCreateOrUpdate_594285(protocol: Scheme;
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

proc validate_ExpressRouteCircuitAuthorizationsCreateOrUpdate_594284(
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
  var valid_594286 = path.getOrDefault("circuitName")
  valid_594286 = validateParameter(valid_594286, JString, required = true,
                                 default = nil)
  if valid_594286 != nil:
    section.add "circuitName", valid_594286
  var valid_594287 = path.getOrDefault("resourceGroupName")
  valid_594287 = validateParameter(valid_594287, JString, required = true,
                                 default = nil)
  if valid_594287 != nil:
    section.add "resourceGroupName", valid_594287
  var valid_594288 = path.getOrDefault("subscriptionId")
  valid_594288 = validateParameter(valid_594288, JString, required = true,
                                 default = nil)
  if valid_594288 != nil:
    section.add "subscriptionId", valid_594288
  var valid_594289 = path.getOrDefault("authorizationName")
  valid_594289 = validateParameter(valid_594289, JString, required = true,
                                 default = nil)
  if valid_594289 != nil:
    section.add "authorizationName", valid_594289
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594290 = query.getOrDefault("api-version")
  valid_594290 = validateParameter(valid_594290, JString, required = true,
                                 default = nil)
  if valid_594290 != nil:
    section.add "api-version", valid_594290
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

proc call*(call_594292: Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_594283;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put Authorization operation creates/updates an authorization in the specified ExpressRouteCircuits
  ## 
  let valid = call_594292.validator(path, query, header, formData, body)
  let scheme = call_594292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594292.url(scheme.get, call_594292.host, call_594292.base,
                         call_594292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594292, url, valid)

proc call*(call_594293: Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_594283;
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
  var path_594294 = newJObject()
  var query_594295 = newJObject()
  var body_594296 = newJObject()
  add(path_594294, "circuitName", newJString(circuitName))
  add(path_594294, "resourceGroupName", newJString(resourceGroupName))
  add(query_594295, "api-version", newJString(apiVersion))
  add(path_594294, "subscriptionId", newJString(subscriptionId))
  if authorizationParameters != nil:
    body_594296 = authorizationParameters
  add(path_594294, "authorizationName", newJString(authorizationName))
  result = call_594293.call(path_594294, query_594295, nil, nil, body_594296)

var expressRouteCircuitAuthorizationsCreateOrUpdate* = Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_594283(
    name: "expressRouteCircuitAuthorizationsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations/{authorizationName}",
    validator: validate_ExpressRouteCircuitAuthorizationsCreateOrUpdate_594284,
    base: "", url: url_ExpressRouteCircuitAuthorizationsCreateOrUpdate_594285,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsGet_594271 = ref object of OpenApiRestCall_593422
proc url_ExpressRouteCircuitAuthorizationsGet_594273(protocol: Scheme;
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

proc validate_ExpressRouteCircuitAuthorizationsGet_594272(path: JsonNode;
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
  var valid_594274 = path.getOrDefault("circuitName")
  valid_594274 = validateParameter(valid_594274, JString, required = true,
                                 default = nil)
  if valid_594274 != nil:
    section.add "circuitName", valid_594274
  var valid_594275 = path.getOrDefault("resourceGroupName")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "resourceGroupName", valid_594275
  var valid_594276 = path.getOrDefault("subscriptionId")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "subscriptionId", valid_594276
  var valid_594277 = path.getOrDefault("authorizationName")
  valid_594277 = validateParameter(valid_594277, JString, required = true,
                                 default = nil)
  if valid_594277 != nil:
    section.add "authorizationName", valid_594277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594278 = query.getOrDefault("api-version")
  valid_594278 = validateParameter(valid_594278, JString, required = true,
                                 default = nil)
  if valid_594278 != nil:
    section.add "api-version", valid_594278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594279: Call_ExpressRouteCircuitAuthorizationsGet_594271;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The GET authorization operation retrieves the specified authorization from the specified ExpressRouteCircuit.
  ## 
  let valid = call_594279.validator(path, query, header, formData, body)
  let scheme = call_594279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594279.url(scheme.get, call_594279.host, call_594279.base,
                         call_594279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594279, url, valid)

proc call*(call_594280: Call_ExpressRouteCircuitAuthorizationsGet_594271;
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
  var path_594281 = newJObject()
  var query_594282 = newJObject()
  add(path_594281, "circuitName", newJString(circuitName))
  add(path_594281, "resourceGroupName", newJString(resourceGroupName))
  add(query_594282, "api-version", newJString(apiVersion))
  add(path_594281, "subscriptionId", newJString(subscriptionId))
  add(path_594281, "authorizationName", newJString(authorizationName))
  result = call_594280.call(path_594281, query_594282, nil, nil, nil)

var expressRouteCircuitAuthorizationsGet* = Call_ExpressRouteCircuitAuthorizationsGet_594271(
    name: "expressRouteCircuitAuthorizationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations/{authorizationName}",
    validator: validate_ExpressRouteCircuitAuthorizationsGet_594272, base: "",
    url: url_ExpressRouteCircuitAuthorizationsGet_594273, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsDelete_594297 = ref object of OpenApiRestCall_593422
proc url_ExpressRouteCircuitAuthorizationsDelete_594299(protocol: Scheme;
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

proc validate_ExpressRouteCircuitAuthorizationsDelete_594298(path: JsonNode;
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
  var valid_594300 = path.getOrDefault("circuitName")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "circuitName", valid_594300
  var valid_594301 = path.getOrDefault("resourceGroupName")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "resourceGroupName", valid_594301
  var valid_594302 = path.getOrDefault("subscriptionId")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "subscriptionId", valid_594302
  var valid_594303 = path.getOrDefault("authorizationName")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "authorizationName", valid_594303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594304 = query.getOrDefault("api-version")
  valid_594304 = validateParameter(valid_594304, JString, required = true,
                                 default = nil)
  if valid_594304 != nil:
    section.add "api-version", valid_594304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594305: Call_ExpressRouteCircuitAuthorizationsDelete_594297;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The delete authorization operation deletes the specified authorization from the specified ExpressRouteCircuit.
  ## 
  let valid = call_594305.validator(path, query, header, formData, body)
  let scheme = call_594305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594305.url(scheme.get, call_594305.host, call_594305.base,
                         call_594305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594305, url, valid)

proc call*(call_594306: Call_ExpressRouteCircuitAuthorizationsDelete_594297;
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
  var path_594307 = newJObject()
  var query_594308 = newJObject()
  add(path_594307, "circuitName", newJString(circuitName))
  add(path_594307, "resourceGroupName", newJString(resourceGroupName))
  add(query_594308, "api-version", newJString(apiVersion))
  add(path_594307, "subscriptionId", newJString(subscriptionId))
  add(path_594307, "authorizationName", newJString(authorizationName))
  result = call_594306.call(path_594307, query_594308, nil, nil, nil)

var expressRouteCircuitAuthorizationsDelete* = Call_ExpressRouteCircuitAuthorizationsDelete_594297(
    name: "expressRouteCircuitAuthorizationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations/{authorizationName}",
    validator: validate_ExpressRouteCircuitAuthorizationsDelete_594298, base: "",
    url: url_ExpressRouteCircuitAuthorizationsDelete_594299,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsList_594309 = ref object of OpenApiRestCall_593422
proc url_ExpressRouteCircuitPeeringsList_594311(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitPeeringsList_594310(path: JsonNode;
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
  var valid_594312 = path.getOrDefault("circuitName")
  valid_594312 = validateParameter(valid_594312, JString, required = true,
                                 default = nil)
  if valid_594312 != nil:
    section.add "circuitName", valid_594312
  var valid_594313 = path.getOrDefault("resourceGroupName")
  valid_594313 = validateParameter(valid_594313, JString, required = true,
                                 default = nil)
  if valid_594313 != nil:
    section.add "resourceGroupName", valid_594313
  var valid_594314 = path.getOrDefault("subscriptionId")
  valid_594314 = validateParameter(valid_594314, JString, required = true,
                                 default = nil)
  if valid_594314 != nil:
    section.add "subscriptionId", valid_594314
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594315 = query.getOrDefault("api-version")
  valid_594315 = validateParameter(valid_594315, JString, required = true,
                                 default = nil)
  if valid_594315 != nil:
    section.add "api-version", valid_594315
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594316: Call_ExpressRouteCircuitPeeringsList_594309;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The List peering operation retrieves all the peerings in an ExpressRouteCircuit.
  ## 
  let valid = call_594316.validator(path, query, header, formData, body)
  let scheme = call_594316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594316.url(scheme.get, call_594316.host, call_594316.base,
                         call_594316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594316, url, valid)

proc call*(call_594317: Call_ExpressRouteCircuitPeeringsList_594309;
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
  var path_594318 = newJObject()
  var query_594319 = newJObject()
  add(path_594318, "circuitName", newJString(circuitName))
  add(path_594318, "resourceGroupName", newJString(resourceGroupName))
  add(query_594319, "api-version", newJString(apiVersion))
  add(path_594318, "subscriptionId", newJString(subscriptionId))
  result = call_594317.call(path_594318, query_594319, nil, nil, nil)

var expressRouteCircuitPeeringsList* = Call_ExpressRouteCircuitPeeringsList_594309(
    name: "expressRouteCircuitPeeringsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings",
    validator: validate_ExpressRouteCircuitPeeringsList_594310, base: "",
    url: url_ExpressRouteCircuitPeeringsList_594311, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsCreateOrUpdate_594332 = ref object of OpenApiRestCall_593422
proc url_ExpressRouteCircuitPeeringsCreateOrUpdate_594334(protocol: Scheme;
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

proc validate_ExpressRouteCircuitPeeringsCreateOrUpdate_594333(path: JsonNode;
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
  var valid_594335 = path.getOrDefault("circuitName")
  valid_594335 = validateParameter(valid_594335, JString, required = true,
                                 default = nil)
  if valid_594335 != nil:
    section.add "circuitName", valid_594335
  var valid_594336 = path.getOrDefault("resourceGroupName")
  valid_594336 = validateParameter(valid_594336, JString, required = true,
                                 default = nil)
  if valid_594336 != nil:
    section.add "resourceGroupName", valid_594336
  var valid_594337 = path.getOrDefault("peeringName")
  valid_594337 = validateParameter(valid_594337, JString, required = true,
                                 default = nil)
  if valid_594337 != nil:
    section.add "peeringName", valid_594337
  var valid_594338 = path.getOrDefault("subscriptionId")
  valid_594338 = validateParameter(valid_594338, JString, required = true,
                                 default = nil)
  if valid_594338 != nil:
    section.add "subscriptionId", valid_594338
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594339 = query.getOrDefault("api-version")
  valid_594339 = validateParameter(valid_594339, JString, required = true,
                                 default = nil)
  if valid_594339 != nil:
    section.add "api-version", valid_594339
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

proc call*(call_594341: Call_ExpressRouteCircuitPeeringsCreateOrUpdate_594332;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put Peering operation creates/updates an peering in the specified ExpressRouteCircuits
  ## 
  let valid = call_594341.validator(path, query, header, formData, body)
  let scheme = call_594341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594341.url(scheme.get, call_594341.host, call_594341.base,
                         call_594341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594341, url, valid)

proc call*(call_594342: Call_ExpressRouteCircuitPeeringsCreateOrUpdate_594332;
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
  var path_594343 = newJObject()
  var query_594344 = newJObject()
  var body_594345 = newJObject()
  add(path_594343, "circuitName", newJString(circuitName))
  add(path_594343, "resourceGroupName", newJString(resourceGroupName))
  add(query_594344, "api-version", newJString(apiVersion))
  add(path_594343, "peeringName", newJString(peeringName))
  add(path_594343, "subscriptionId", newJString(subscriptionId))
  if peeringParameters != nil:
    body_594345 = peeringParameters
  result = call_594342.call(path_594343, query_594344, nil, nil, body_594345)

var expressRouteCircuitPeeringsCreateOrUpdate* = Call_ExpressRouteCircuitPeeringsCreateOrUpdate_594332(
    name: "expressRouteCircuitPeeringsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCircuitPeeringsCreateOrUpdate_594333,
    base: "", url: url_ExpressRouteCircuitPeeringsCreateOrUpdate_594334,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsGet_594320 = ref object of OpenApiRestCall_593422
proc url_ExpressRouteCircuitPeeringsGet_594322(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitPeeringsGet_594321(path: JsonNode;
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
  var valid_594323 = path.getOrDefault("circuitName")
  valid_594323 = validateParameter(valid_594323, JString, required = true,
                                 default = nil)
  if valid_594323 != nil:
    section.add "circuitName", valid_594323
  var valid_594324 = path.getOrDefault("resourceGroupName")
  valid_594324 = validateParameter(valid_594324, JString, required = true,
                                 default = nil)
  if valid_594324 != nil:
    section.add "resourceGroupName", valid_594324
  var valid_594325 = path.getOrDefault("peeringName")
  valid_594325 = validateParameter(valid_594325, JString, required = true,
                                 default = nil)
  if valid_594325 != nil:
    section.add "peeringName", valid_594325
  var valid_594326 = path.getOrDefault("subscriptionId")
  valid_594326 = validateParameter(valid_594326, JString, required = true,
                                 default = nil)
  if valid_594326 != nil:
    section.add "subscriptionId", valid_594326
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594327 = query.getOrDefault("api-version")
  valid_594327 = validateParameter(valid_594327, JString, required = true,
                                 default = nil)
  if valid_594327 != nil:
    section.add "api-version", valid_594327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594328: Call_ExpressRouteCircuitPeeringsGet_594320; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GET peering operation retrieves the specified authorization from the ExpressRouteCircuit.
  ## 
  let valid = call_594328.validator(path, query, header, formData, body)
  let scheme = call_594328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594328.url(scheme.get, call_594328.host, call_594328.base,
                         call_594328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594328, url, valid)

proc call*(call_594329: Call_ExpressRouteCircuitPeeringsGet_594320;
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
  var path_594330 = newJObject()
  var query_594331 = newJObject()
  add(path_594330, "circuitName", newJString(circuitName))
  add(path_594330, "resourceGroupName", newJString(resourceGroupName))
  add(query_594331, "api-version", newJString(apiVersion))
  add(path_594330, "peeringName", newJString(peeringName))
  add(path_594330, "subscriptionId", newJString(subscriptionId))
  result = call_594329.call(path_594330, query_594331, nil, nil, nil)

var expressRouteCircuitPeeringsGet* = Call_ExpressRouteCircuitPeeringsGet_594320(
    name: "expressRouteCircuitPeeringsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCircuitPeeringsGet_594321, base: "",
    url: url_ExpressRouteCircuitPeeringsGet_594322, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsDelete_594346 = ref object of OpenApiRestCall_593422
proc url_ExpressRouteCircuitPeeringsDelete_594348(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitPeeringsDelete_594347(path: JsonNode;
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
  var valid_594349 = path.getOrDefault("circuitName")
  valid_594349 = validateParameter(valid_594349, JString, required = true,
                                 default = nil)
  if valid_594349 != nil:
    section.add "circuitName", valid_594349
  var valid_594350 = path.getOrDefault("resourceGroupName")
  valid_594350 = validateParameter(valid_594350, JString, required = true,
                                 default = nil)
  if valid_594350 != nil:
    section.add "resourceGroupName", valid_594350
  var valid_594351 = path.getOrDefault("peeringName")
  valid_594351 = validateParameter(valid_594351, JString, required = true,
                                 default = nil)
  if valid_594351 != nil:
    section.add "peeringName", valid_594351
  var valid_594352 = path.getOrDefault("subscriptionId")
  valid_594352 = validateParameter(valid_594352, JString, required = true,
                                 default = nil)
  if valid_594352 != nil:
    section.add "subscriptionId", valid_594352
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594353 = query.getOrDefault("api-version")
  valid_594353 = validateParameter(valid_594353, JString, required = true,
                                 default = nil)
  if valid_594353 != nil:
    section.add "api-version", valid_594353
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594354: Call_ExpressRouteCircuitPeeringsDelete_594346;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The delete peering operation deletes the specified peering from the ExpressRouteCircuit.
  ## 
  let valid = call_594354.validator(path, query, header, formData, body)
  let scheme = call_594354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594354.url(scheme.get, call_594354.host, call_594354.base,
                         call_594354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594354, url, valid)

proc call*(call_594355: Call_ExpressRouteCircuitPeeringsDelete_594346;
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
  var path_594356 = newJObject()
  var query_594357 = newJObject()
  add(path_594356, "circuitName", newJString(circuitName))
  add(path_594356, "resourceGroupName", newJString(resourceGroupName))
  add(query_594357, "api-version", newJString(apiVersion))
  add(path_594356, "peeringName", newJString(peeringName))
  add(path_594356, "subscriptionId", newJString(subscriptionId))
  result = call_594355.call(path_594356, query_594357, nil, nil, nil)

var expressRouteCircuitPeeringsDelete* = Call_ExpressRouteCircuitPeeringsDelete_594346(
    name: "expressRouteCircuitPeeringsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCircuitPeeringsDelete_594347, base: "",
    url: url_ExpressRouteCircuitPeeringsDelete_594348, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsListArpTable_594358 = ref object of OpenApiRestCall_593422
proc url_ExpressRouteCircuitsListArpTable_594360(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsListArpTable_594359(path: JsonNode;
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
  var valid_594361 = path.getOrDefault("circuitName")
  valid_594361 = validateParameter(valid_594361, JString, required = true,
                                 default = nil)
  if valid_594361 != nil:
    section.add "circuitName", valid_594361
  var valid_594362 = path.getOrDefault("resourceGroupName")
  valid_594362 = validateParameter(valid_594362, JString, required = true,
                                 default = nil)
  if valid_594362 != nil:
    section.add "resourceGroupName", valid_594362
  var valid_594363 = path.getOrDefault("peeringName")
  valid_594363 = validateParameter(valid_594363, JString, required = true,
                                 default = nil)
  if valid_594363 != nil:
    section.add "peeringName", valid_594363
  var valid_594364 = path.getOrDefault("subscriptionId")
  valid_594364 = validateParameter(valid_594364, JString, required = true,
                                 default = nil)
  if valid_594364 != nil:
    section.add "subscriptionId", valid_594364
  var valid_594365 = path.getOrDefault("devicePath")
  valid_594365 = validateParameter(valid_594365, JString, required = true,
                                 default = nil)
  if valid_594365 != nil:
    section.add "devicePath", valid_594365
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594366 = query.getOrDefault("api-version")
  valid_594366 = validateParameter(valid_594366, JString, required = true,
                                 default = nil)
  if valid_594366 != nil:
    section.add "api-version", valid_594366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594367: Call_ExpressRouteCircuitsListArpTable_594358;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The ListArpTable from ExpressRouteCircuit operation retrieves the currently advertised arp table associated with the ExpressRouteCircuits in a resource group.
  ## 
  let valid = call_594367.validator(path, query, header, formData, body)
  let scheme = call_594367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594367.url(scheme.get, call_594367.host, call_594367.base,
                         call_594367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594367, url, valid)

proc call*(call_594368: Call_ExpressRouteCircuitsListArpTable_594358;
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
  var path_594369 = newJObject()
  var query_594370 = newJObject()
  add(path_594369, "circuitName", newJString(circuitName))
  add(path_594369, "resourceGroupName", newJString(resourceGroupName))
  add(query_594370, "api-version", newJString(apiVersion))
  add(path_594369, "peeringName", newJString(peeringName))
  add(path_594369, "subscriptionId", newJString(subscriptionId))
  add(path_594369, "devicePath", newJString(devicePath))
  result = call_594368.call(path_594369, query_594370, nil, nil, nil)

var expressRouteCircuitsListArpTable* = Call_ExpressRouteCircuitsListArpTable_594358(
    name: "expressRouteCircuitsListArpTable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/arpTables/{devicePath}",
    validator: validate_ExpressRouteCircuitsListArpTable_594359, base: "",
    url: url_ExpressRouteCircuitsListArpTable_594360, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsListRoutesTable_594371 = ref object of OpenApiRestCall_593422
proc url_ExpressRouteCircuitsListRoutesTable_594373(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsListRoutesTable_594372(path: JsonNode;
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
  var valid_594374 = path.getOrDefault("circuitName")
  valid_594374 = validateParameter(valid_594374, JString, required = true,
                                 default = nil)
  if valid_594374 != nil:
    section.add "circuitName", valid_594374
  var valid_594375 = path.getOrDefault("resourceGroupName")
  valid_594375 = validateParameter(valid_594375, JString, required = true,
                                 default = nil)
  if valid_594375 != nil:
    section.add "resourceGroupName", valid_594375
  var valid_594376 = path.getOrDefault("peeringName")
  valid_594376 = validateParameter(valid_594376, JString, required = true,
                                 default = nil)
  if valid_594376 != nil:
    section.add "peeringName", valid_594376
  var valid_594377 = path.getOrDefault("subscriptionId")
  valid_594377 = validateParameter(valid_594377, JString, required = true,
                                 default = nil)
  if valid_594377 != nil:
    section.add "subscriptionId", valid_594377
  var valid_594378 = path.getOrDefault("devicePath")
  valid_594378 = validateParameter(valid_594378, JString, required = true,
                                 default = nil)
  if valid_594378 != nil:
    section.add "devicePath", valid_594378
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594379 = query.getOrDefault("api-version")
  valid_594379 = validateParameter(valid_594379, JString, required = true,
                                 default = nil)
  if valid_594379 != nil:
    section.add "api-version", valid_594379
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594380: Call_ExpressRouteCircuitsListRoutesTable_594371;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The ListRoutesTable from ExpressRouteCircuit operation retrieves the currently advertised routes table associated with the ExpressRouteCircuits in a resource group.
  ## 
  let valid = call_594380.validator(path, query, header, formData, body)
  let scheme = call_594380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594380.url(scheme.get, call_594380.host, call_594380.base,
                         call_594380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594380, url, valid)

proc call*(call_594381: Call_ExpressRouteCircuitsListRoutesTable_594371;
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
  var path_594382 = newJObject()
  var query_594383 = newJObject()
  add(path_594382, "circuitName", newJString(circuitName))
  add(path_594382, "resourceGroupName", newJString(resourceGroupName))
  add(query_594383, "api-version", newJString(apiVersion))
  add(path_594382, "peeringName", newJString(peeringName))
  add(path_594382, "subscriptionId", newJString(subscriptionId))
  add(path_594382, "devicePath", newJString(devicePath))
  result = call_594381.call(path_594382, query_594383, nil, nil, nil)

var expressRouteCircuitsListRoutesTable* = Call_ExpressRouteCircuitsListRoutesTable_594371(
    name: "expressRouteCircuitsListRoutesTable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/routeTables/{devicePath}",
    validator: validate_ExpressRouteCircuitsListRoutesTable_594372, base: "",
    url: url_ExpressRouteCircuitsListRoutesTable_594373, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsListRoutesTableSummary_594384 = ref object of OpenApiRestCall_593422
proc url_ExpressRouteCircuitsListRoutesTableSummary_594386(protocol: Scheme;
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

proc validate_ExpressRouteCircuitsListRoutesTableSummary_594385(path: JsonNode;
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
  var valid_594387 = path.getOrDefault("circuitName")
  valid_594387 = validateParameter(valid_594387, JString, required = true,
                                 default = nil)
  if valid_594387 != nil:
    section.add "circuitName", valid_594387
  var valid_594388 = path.getOrDefault("resourceGroupName")
  valid_594388 = validateParameter(valid_594388, JString, required = true,
                                 default = nil)
  if valid_594388 != nil:
    section.add "resourceGroupName", valid_594388
  var valid_594389 = path.getOrDefault("peeringName")
  valid_594389 = validateParameter(valid_594389, JString, required = true,
                                 default = nil)
  if valid_594389 != nil:
    section.add "peeringName", valid_594389
  var valid_594390 = path.getOrDefault("subscriptionId")
  valid_594390 = validateParameter(valid_594390, JString, required = true,
                                 default = nil)
  if valid_594390 != nil:
    section.add "subscriptionId", valid_594390
  var valid_594391 = path.getOrDefault("devicePath")
  valid_594391 = validateParameter(valid_594391, JString, required = true,
                                 default = nil)
  if valid_594391 != nil:
    section.add "devicePath", valid_594391
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594392 = query.getOrDefault("api-version")
  valid_594392 = validateParameter(valid_594392, JString, required = true,
                                 default = nil)
  if valid_594392 != nil:
    section.add "api-version", valid_594392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594393: Call_ExpressRouteCircuitsListRoutesTableSummary_594384;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The ListRoutesTable from ExpressRouteCircuit operation retrieves the currently advertised routes table associated with the ExpressRouteCircuits in a resource group.
  ## 
  let valid = call_594393.validator(path, query, header, formData, body)
  let scheme = call_594393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594393.url(scheme.get, call_594393.host, call_594393.base,
                         call_594393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594393, url, valid)

proc call*(call_594394: Call_ExpressRouteCircuitsListRoutesTableSummary_594384;
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
  var path_594395 = newJObject()
  var query_594396 = newJObject()
  add(path_594395, "circuitName", newJString(circuitName))
  add(path_594395, "resourceGroupName", newJString(resourceGroupName))
  add(query_594396, "api-version", newJString(apiVersion))
  add(path_594395, "peeringName", newJString(peeringName))
  add(path_594395, "subscriptionId", newJString(subscriptionId))
  add(path_594395, "devicePath", newJString(devicePath))
  result = call_594394.call(path_594395, query_594396, nil, nil, nil)

var expressRouteCircuitsListRoutesTableSummary* = Call_ExpressRouteCircuitsListRoutesTableSummary_594384(
    name: "expressRouteCircuitsListRoutesTableSummary", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/routeTablesSummary/{devicePath}",
    validator: validate_ExpressRouteCircuitsListRoutesTableSummary_594385,
    base: "", url: url_ExpressRouteCircuitsListRoutesTableSummary_594386,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsGetPeeringStats_594397 = ref object of OpenApiRestCall_593422
proc url_ExpressRouteCircuitsGetPeeringStats_594399(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsGetPeeringStats_594398(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The GetPeeringStats ExpressRouteCircuit operation retrieves all the stats from a ExpressRouteCircuits in a resource group.
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
  var valid_594400 = path.getOrDefault("circuitName")
  valid_594400 = validateParameter(valid_594400, JString, required = true,
                                 default = nil)
  if valid_594400 != nil:
    section.add "circuitName", valid_594400
  var valid_594401 = path.getOrDefault("resourceGroupName")
  valid_594401 = validateParameter(valid_594401, JString, required = true,
                                 default = nil)
  if valid_594401 != nil:
    section.add "resourceGroupName", valid_594401
  var valid_594402 = path.getOrDefault("peeringName")
  valid_594402 = validateParameter(valid_594402, JString, required = true,
                                 default = nil)
  if valid_594402 != nil:
    section.add "peeringName", valid_594402
  var valid_594403 = path.getOrDefault("subscriptionId")
  valid_594403 = validateParameter(valid_594403, JString, required = true,
                                 default = nil)
  if valid_594403 != nil:
    section.add "subscriptionId", valid_594403
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594404 = query.getOrDefault("api-version")
  valid_594404 = validateParameter(valid_594404, JString, required = true,
                                 default = nil)
  if valid_594404 != nil:
    section.add "api-version", valid_594404
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594405: Call_ExpressRouteCircuitsGetPeeringStats_594397;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The GetPeeringStats ExpressRouteCircuit operation retrieves all the stats from a ExpressRouteCircuits in a resource group.
  ## 
  let valid = call_594405.validator(path, query, header, formData, body)
  let scheme = call_594405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594405.url(scheme.get, call_594405.host, call_594405.base,
                         call_594405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594405, url, valid)

proc call*(call_594406: Call_ExpressRouteCircuitsGetPeeringStats_594397;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          peeringName: string; subscriptionId: string): Recallable =
  ## expressRouteCircuitsGetPeeringStats
  ## The GetPeeringStats ExpressRouteCircuit operation retrieves all the stats from a ExpressRouteCircuits in a resource group.
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
  var path_594407 = newJObject()
  var query_594408 = newJObject()
  add(path_594407, "circuitName", newJString(circuitName))
  add(path_594407, "resourceGroupName", newJString(resourceGroupName))
  add(query_594408, "api-version", newJString(apiVersion))
  add(path_594407, "peeringName", newJString(peeringName))
  add(path_594407, "subscriptionId", newJString(subscriptionId))
  result = call_594406.call(path_594407, query_594408, nil, nil, nil)

var expressRouteCircuitsGetPeeringStats* = Call_ExpressRouteCircuitsGetPeeringStats_594397(
    name: "expressRouteCircuitsGetPeeringStats", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/stats",
    validator: validate_ExpressRouteCircuitsGetPeeringStats_594398, base: "",
    url: url_ExpressRouteCircuitsGetPeeringStats_594399, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsGetStats_594409 = ref object of OpenApiRestCall_593422
proc url_ExpressRouteCircuitsGetStats_594411(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsGetStats_594410(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The GetStats ExpressRouteCircuit operation retrieves all the stats from a ExpressRouteCircuits in a resource group.
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
  var valid_594412 = path.getOrDefault("circuitName")
  valid_594412 = validateParameter(valid_594412, JString, required = true,
                                 default = nil)
  if valid_594412 != nil:
    section.add "circuitName", valid_594412
  var valid_594413 = path.getOrDefault("resourceGroupName")
  valid_594413 = validateParameter(valid_594413, JString, required = true,
                                 default = nil)
  if valid_594413 != nil:
    section.add "resourceGroupName", valid_594413
  var valid_594414 = path.getOrDefault("subscriptionId")
  valid_594414 = validateParameter(valid_594414, JString, required = true,
                                 default = nil)
  if valid_594414 != nil:
    section.add "subscriptionId", valid_594414
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594415 = query.getOrDefault("api-version")
  valid_594415 = validateParameter(valid_594415, JString, required = true,
                                 default = nil)
  if valid_594415 != nil:
    section.add "api-version", valid_594415
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594416: Call_ExpressRouteCircuitsGetStats_594409; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetStats ExpressRouteCircuit operation retrieves all the stats from a ExpressRouteCircuits in a resource group.
  ## 
  let valid = call_594416.validator(path, query, header, formData, body)
  let scheme = call_594416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594416.url(scheme.get, call_594416.host, call_594416.base,
                         call_594416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594416, url, valid)

proc call*(call_594417: Call_ExpressRouteCircuitsGetStats_594409;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## expressRouteCircuitsGetStats
  ## The GetStats ExpressRouteCircuit operation retrieves all the stats from a ExpressRouteCircuits in a resource group.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594418 = newJObject()
  var query_594419 = newJObject()
  add(path_594418, "circuitName", newJString(circuitName))
  add(path_594418, "resourceGroupName", newJString(resourceGroupName))
  add(query_594419, "api-version", newJString(apiVersion))
  add(path_594418, "subscriptionId", newJString(subscriptionId))
  result = call_594417.call(path_594418, query_594419, nil, nil, nil)

var expressRouteCircuitsGetStats* = Call_ExpressRouteCircuitsGetStats_594409(
    name: "expressRouteCircuitsGetStats", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/stats",
    validator: validate_ExpressRouteCircuitsGetStats_594410, base: "",
    url: url_ExpressRouteCircuitsGetStats_594411, schemes: {Scheme.Https})
type
  Call_LoadBalancersList_594420 = ref object of OpenApiRestCall_593422
proc url_LoadBalancersList_594422(protocol: Scheme; host: string; base: string;
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

proc validate_LoadBalancersList_594421(path: JsonNode; query: JsonNode;
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
  var valid_594423 = path.getOrDefault("resourceGroupName")
  valid_594423 = validateParameter(valid_594423, JString, required = true,
                                 default = nil)
  if valid_594423 != nil:
    section.add "resourceGroupName", valid_594423
  var valid_594424 = path.getOrDefault("subscriptionId")
  valid_594424 = validateParameter(valid_594424, JString, required = true,
                                 default = nil)
  if valid_594424 != nil:
    section.add "subscriptionId", valid_594424
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594425 = query.getOrDefault("api-version")
  valid_594425 = validateParameter(valid_594425, JString, required = true,
                                 default = nil)
  if valid_594425 != nil:
    section.add "api-version", valid_594425
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594426: Call_LoadBalancersList_594420; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List loadBalancer operation retrieves all the load balancers in a resource group.
  ## 
  let valid = call_594426.validator(path, query, header, formData, body)
  let scheme = call_594426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594426.url(scheme.get, call_594426.host, call_594426.base,
                         call_594426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594426, url, valid)

proc call*(call_594427: Call_LoadBalancersList_594420; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## loadBalancersList
  ## The List loadBalancer operation retrieves all the load balancers in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594428 = newJObject()
  var query_594429 = newJObject()
  add(path_594428, "resourceGroupName", newJString(resourceGroupName))
  add(query_594429, "api-version", newJString(apiVersion))
  add(path_594428, "subscriptionId", newJString(subscriptionId))
  result = call_594427.call(path_594428, query_594429, nil, nil, nil)

var loadBalancersList* = Call_LoadBalancersList_594420(name: "loadBalancersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers",
    validator: validate_LoadBalancersList_594421, base: "",
    url: url_LoadBalancersList_594422, schemes: {Scheme.Https})
type
  Call_LoadBalancersCreateOrUpdate_594443 = ref object of OpenApiRestCall_593422
proc url_LoadBalancersCreateOrUpdate_594445(protocol: Scheme; host: string;
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

proc validate_LoadBalancersCreateOrUpdate_594444(path: JsonNode; query: JsonNode;
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
  var valid_594446 = path.getOrDefault("resourceGroupName")
  valid_594446 = validateParameter(valid_594446, JString, required = true,
                                 default = nil)
  if valid_594446 != nil:
    section.add "resourceGroupName", valid_594446
  var valid_594447 = path.getOrDefault("loadBalancerName")
  valid_594447 = validateParameter(valid_594447, JString, required = true,
                                 default = nil)
  if valid_594447 != nil:
    section.add "loadBalancerName", valid_594447
  var valid_594448 = path.getOrDefault("subscriptionId")
  valid_594448 = validateParameter(valid_594448, JString, required = true,
                                 default = nil)
  if valid_594448 != nil:
    section.add "subscriptionId", valid_594448
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594449 = query.getOrDefault("api-version")
  valid_594449 = validateParameter(valid_594449, JString, required = true,
                                 default = nil)
  if valid_594449 != nil:
    section.add "api-version", valid_594449
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

proc call*(call_594451: Call_LoadBalancersCreateOrUpdate_594443; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put LoadBalancer operation creates/updates a LoadBalancer
  ## 
  let valid = call_594451.validator(path, query, header, formData, body)
  let scheme = call_594451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594451.url(scheme.get, call_594451.host, call_594451.base,
                         call_594451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594451, url, valid)

proc call*(call_594452: Call_LoadBalancersCreateOrUpdate_594443;
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
  var path_594453 = newJObject()
  var query_594454 = newJObject()
  var body_594455 = newJObject()
  add(path_594453, "resourceGroupName", newJString(resourceGroupName))
  add(query_594454, "api-version", newJString(apiVersion))
  add(path_594453, "loadBalancerName", newJString(loadBalancerName))
  add(path_594453, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594455 = parameters
  result = call_594452.call(path_594453, query_594454, nil, nil, body_594455)

var loadBalancersCreateOrUpdate* = Call_LoadBalancersCreateOrUpdate_594443(
    name: "loadBalancersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}",
    validator: validate_LoadBalancersCreateOrUpdate_594444, base: "",
    url: url_LoadBalancersCreateOrUpdate_594445, schemes: {Scheme.Https})
type
  Call_LoadBalancersGet_594430 = ref object of OpenApiRestCall_593422
proc url_LoadBalancersGet_594432(protocol: Scheme; host: string; base: string;
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

proc validate_LoadBalancersGet_594431(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## The Get network interface operation retrieves information about the specified network interface.
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
  var valid_594434 = path.getOrDefault("resourceGroupName")
  valid_594434 = validateParameter(valid_594434, JString, required = true,
                                 default = nil)
  if valid_594434 != nil:
    section.add "resourceGroupName", valid_594434
  var valid_594435 = path.getOrDefault("loadBalancerName")
  valid_594435 = validateParameter(valid_594435, JString, required = true,
                                 default = nil)
  if valid_594435 != nil:
    section.add "loadBalancerName", valid_594435
  var valid_594436 = path.getOrDefault("subscriptionId")
  valid_594436 = validateParameter(valid_594436, JString, required = true,
                                 default = nil)
  if valid_594436 != nil:
    section.add "subscriptionId", valid_594436
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594437 = query.getOrDefault("api-version")
  valid_594437 = validateParameter(valid_594437, JString, required = true,
                                 default = nil)
  if valid_594437 != nil:
    section.add "api-version", valid_594437
  var valid_594438 = query.getOrDefault("$expand")
  valid_594438 = validateParameter(valid_594438, JString, required = false,
                                 default = nil)
  if valid_594438 != nil:
    section.add "$expand", valid_594438
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594439: Call_LoadBalancersGet_594430; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get network interface operation retrieves information about the specified network interface.
  ## 
  let valid = call_594439.validator(path, query, header, formData, body)
  let scheme = call_594439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594439.url(scheme.get, call_594439.host, call_594439.base,
                         call_594439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594439, url, valid)

proc call*(call_594440: Call_LoadBalancersGet_594430; resourceGroupName: string;
          apiVersion: string; loadBalancerName: string; subscriptionId: string;
          Expand: string = ""): Recallable =
  ## loadBalancersGet
  ## The Get network interface operation retrieves information about the specified network interface.
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
  var path_594441 = newJObject()
  var query_594442 = newJObject()
  add(path_594441, "resourceGroupName", newJString(resourceGroupName))
  add(query_594442, "api-version", newJString(apiVersion))
  add(query_594442, "$expand", newJString(Expand))
  add(path_594441, "loadBalancerName", newJString(loadBalancerName))
  add(path_594441, "subscriptionId", newJString(subscriptionId))
  result = call_594440.call(path_594441, query_594442, nil, nil, nil)

var loadBalancersGet* = Call_LoadBalancersGet_594430(name: "loadBalancersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}",
    validator: validate_LoadBalancersGet_594431, base: "",
    url: url_LoadBalancersGet_594432, schemes: {Scheme.Https})
type
  Call_LoadBalancersDelete_594456 = ref object of OpenApiRestCall_593422
proc url_LoadBalancersDelete_594458(protocol: Scheme; host: string; base: string;
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

proc validate_LoadBalancersDelete_594457(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## The delete loadbalancer operation deletes the specified loadbalancer.
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
  var valid_594459 = path.getOrDefault("resourceGroupName")
  valid_594459 = validateParameter(valid_594459, JString, required = true,
                                 default = nil)
  if valid_594459 != nil:
    section.add "resourceGroupName", valid_594459
  var valid_594460 = path.getOrDefault("loadBalancerName")
  valid_594460 = validateParameter(valid_594460, JString, required = true,
                                 default = nil)
  if valid_594460 != nil:
    section.add "loadBalancerName", valid_594460
  var valid_594461 = path.getOrDefault("subscriptionId")
  valid_594461 = validateParameter(valid_594461, JString, required = true,
                                 default = nil)
  if valid_594461 != nil:
    section.add "subscriptionId", valid_594461
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594462 = query.getOrDefault("api-version")
  valid_594462 = validateParameter(valid_594462, JString, required = true,
                                 default = nil)
  if valid_594462 != nil:
    section.add "api-version", valid_594462
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594463: Call_LoadBalancersDelete_594456; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete loadbalancer operation deletes the specified loadbalancer.
  ## 
  let valid = call_594463.validator(path, query, header, formData, body)
  let scheme = call_594463.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594463.url(scheme.get, call_594463.host, call_594463.base,
                         call_594463.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594463, url, valid)

proc call*(call_594464: Call_LoadBalancersDelete_594456; resourceGroupName: string;
          apiVersion: string; loadBalancerName: string; subscriptionId: string): Recallable =
  ## loadBalancersDelete
  ## The delete loadbalancer operation deletes the specified loadbalancer.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   loadBalancerName: string (required)
  ##                   : The name of the loadBalancer.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594465 = newJObject()
  var query_594466 = newJObject()
  add(path_594465, "resourceGroupName", newJString(resourceGroupName))
  add(query_594466, "api-version", newJString(apiVersion))
  add(path_594465, "loadBalancerName", newJString(loadBalancerName))
  add(path_594465, "subscriptionId", newJString(subscriptionId))
  result = call_594464.call(path_594465, query_594466, nil, nil, nil)

var loadBalancersDelete* = Call_LoadBalancersDelete_594456(
    name: "loadBalancersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}",
    validator: validate_LoadBalancersDelete_594457, base: "",
    url: url_LoadBalancersDelete_594458, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysList_594467 = ref object of OpenApiRestCall_593422
proc url_LocalNetworkGatewaysList_594469(protocol: Scheme; host: string;
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

proc validate_LocalNetworkGatewaysList_594468(path: JsonNode; query: JsonNode;
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
  var valid_594470 = path.getOrDefault("resourceGroupName")
  valid_594470 = validateParameter(valid_594470, JString, required = true,
                                 default = nil)
  if valid_594470 != nil:
    section.add "resourceGroupName", valid_594470
  var valid_594471 = path.getOrDefault("subscriptionId")
  valid_594471 = validateParameter(valid_594471, JString, required = true,
                                 default = nil)
  if valid_594471 != nil:
    section.add "subscriptionId", valid_594471
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594472 = query.getOrDefault("api-version")
  valid_594472 = validateParameter(valid_594472, JString, required = true,
                                 default = nil)
  if valid_594472 != nil:
    section.add "api-version", valid_594472
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594473: Call_LocalNetworkGatewaysList_594467; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List LocalNetworkGateways operation retrieves all the local network gateways stored.
  ## 
  let valid = call_594473.validator(path, query, header, formData, body)
  let scheme = call_594473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594473.url(scheme.get, call_594473.host, call_594473.base,
                         call_594473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594473, url, valid)

proc call*(call_594474: Call_LocalNetworkGatewaysList_594467;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## localNetworkGatewaysList
  ## The List LocalNetworkGateways operation retrieves all the local network gateways stored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594475 = newJObject()
  var query_594476 = newJObject()
  add(path_594475, "resourceGroupName", newJString(resourceGroupName))
  add(query_594476, "api-version", newJString(apiVersion))
  add(path_594475, "subscriptionId", newJString(subscriptionId))
  result = call_594474.call(path_594475, query_594476, nil, nil, nil)

var localNetworkGatewaysList* = Call_LocalNetworkGatewaysList_594467(
    name: "localNetworkGatewaysList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways",
    validator: validate_LocalNetworkGatewaysList_594468, base: "",
    url: url_LocalNetworkGatewaysList_594469, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysCreateOrUpdate_594488 = ref object of OpenApiRestCall_593422
proc url_LocalNetworkGatewaysCreateOrUpdate_594490(protocol: Scheme; host: string;
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

proc validate_LocalNetworkGatewaysCreateOrUpdate_594489(path: JsonNode;
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
  var valid_594491 = path.getOrDefault("resourceGroupName")
  valid_594491 = validateParameter(valid_594491, JString, required = true,
                                 default = nil)
  if valid_594491 != nil:
    section.add "resourceGroupName", valid_594491
  var valid_594492 = path.getOrDefault("localNetworkGatewayName")
  valid_594492 = validateParameter(valid_594492, JString, required = true,
                                 default = nil)
  if valid_594492 != nil:
    section.add "localNetworkGatewayName", valid_594492
  var valid_594493 = path.getOrDefault("subscriptionId")
  valid_594493 = validateParameter(valid_594493, JString, required = true,
                                 default = nil)
  if valid_594493 != nil:
    section.add "subscriptionId", valid_594493
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594494 = query.getOrDefault("api-version")
  valid_594494 = validateParameter(valid_594494, JString, required = true,
                                 default = nil)
  if valid_594494 != nil:
    section.add "api-version", valid_594494
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

proc call*(call_594496: Call_LocalNetworkGatewaysCreateOrUpdate_594488;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put LocalNetworkGateway operation creates/updates a local network gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_594496.validator(path, query, header, formData, body)
  let scheme = call_594496.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594496.url(scheme.get, call_594496.host, call_594496.base,
                         call_594496.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594496, url, valid)

proc call*(call_594497: Call_LocalNetworkGatewaysCreateOrUpdate_594488;
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
  var path_594498 = newJObject()
  var query_594499 = newJObject()
  var body_594500 = newJObject()
  add(path_594498, "resourceGroupName", newJString(resourceGroupName))
  add(path_594498, "localNetworkGatewayName", newJString(localNetworkGatewayName))
  add(query_594499, "api-version", newJString(apiVersion))
  add(path_594498, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594500 = parameters
  result = call_594497.call(path_594498, query_594499, nil, nil, body_594500)

var localNetworkGatewaysCreateOrUpdate* = Call_LocalNetworkGatewaysCreateOrUpdate_594488(
    name: "localNetworkGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways/{localNetworkGatewayName}",
    validator: validate_LocalNetworkGatewaysCreateOrUpdate_594489, base: "",
    url: url_LocalNetworkGatewaysCreateOrUpdate_594490, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysGet_594477 = ref object of OpenApiRestCall_593422
proc url_LocalNetworkGatewaysGet_594479(protocol: Scheme; host: string; base: string;
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

proc validate_LocalNetworkGatewaysGet_594478(path: JsonNode; query: JsonNode;
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
  var valid_594480 = path.getOrDefault("resourceGroupName")
  valid_594480 = validateParameter(valid_594480, JString, required = true,
                                 default = nil)
  if valid_594480 != nil:
    section.add "resourceGroupName", valid_594480
  var valid_594481 = path.getOrDefault("localNetworkGatewayName")
  valid_594481 = validateParameter(valid_594481, JString, required = true,
                                 default = nil)
  if valid_594481 != nil:
    section.add "localNetworkGatewayName", valid_594481
  var valid_594482 = path.getOrDefault("subscriptionId")
  valid_594482 = validateParameter(valid_594482, JString, required = true,
                                 default = nil)
  if valid_594482 != nil:
    section.add "subscriptionId", valid_594482
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594483 = query.getOrDefault("api-version")
  valid_594483 = validateParameter(valid_594483, JString, required = true,
                                 default = nil)
  if valid_594483 != nil:
    section.add "api-version", valid_594483
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594484: Call_LocalNetworkGatewaysGet_594477; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get LocalNetworkGateway operation retrieves information about the specified local network gateway through Network resource provider.
  ## 
  let valid = call_594484.validator(path, query, header, formData, body)
  let scheme = call_594484.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594484.url(scheme.get, call_594484.host, call_594484.base,
                         call_594484.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594484, url, valid)

proc call*(call_594485: Call_LocalNetworkGatewaysGet_594477;
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
  var path_594486 = newJObject()
  var query_594487 = newJObject()
  add(path_594486, "resourceGroupName", newJString(resourceGroupName))
  add(path_594486, "localNetworkGatewayName", newJString(localNetworkGatewayName))
  add(query_594487, "api-version", newJString(apiVersion))
  add(path_594486, "subscriptionId", newJString(subscriptionId))
  result = call_594485.call(path_594486, query_594487, nil, nil, nil)

var localNetworkGatewaysGet* = Call_LocalNetworkGatewaysGet_594477(
    name: "localNetworkGatewaysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways/{localNetworkGatewayName}",
    validator: validate_LocalNetworkGatewaysGet_594478, base: "",
    url: url_LocalNetworkGatewaysGet_594479, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysDelete_594501 = ref object of OpenApiRestCall_593422
proc url_LocalNetworkGatewaysDelete_594503(protocol: Scheme; host: string;
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

proc validate_LocalNetworkGatewaysDelete_594502(path: JsonNode; query: JsonNode;
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
  var valid_594504 = path.getOrDefault("resourceGroupName")
  valid_594504 = validateParameter(valid_594504, JString, required = true,
                                 default = nil)
  if valid_594504 != nil:
    section.add "resourceGroupName", valid_594504
  var valid_594505 = path.getOrDefault("localNetworkGatewayName")
  valid_594505 = validateParameter(valid_594505, JString, required = true,
                                 default = nil)
  if valid_594505 != nil:
    section.add "localNetworkGatewayName", valid_594505
  var valid_594506 = path.getOrDefault("subscriptionId")
  valid_594506 = validateParameter(valid_594506, JString, required = true,
                                 default = nil)
  if valid_594506 != nil:
    section.add "subscriptionId", valid_594506
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594507 = query.getOrDefault("api-version")
  valid_594507 = validateParameter(valid_594507, JString, required = true,
                                 default = nil)
  if valid_594507 != nil:
    section.add "api-version", valid_594507
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594508: Call_LocalNetworkGatewaysDelete_594501; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete LocalNetworkGateway operation deletes the specified local network Gateway through Network resource provider.
  ## 
  let valid = call_594508.validator(path, query, header, formData, body)
  let scheme = call_594508.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594508.url(scheme.get, call_594508.host, call_594508.base,
                         call_594508.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594508, url, valid)

proc call*(call_594509: Call_LocalNetworkGatewaysDelete_594501;
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
  var path_594510 = newJObject()
  var query_594511 = newJObject()
  add(path_594510, "resourceGroupName", newJString(resourceGroupName))
  add(path_594510, "localNetworkGatewayName", newJString(localNetworkGatewayName))
  add(query_594511, "api-version", newJString(apiVersion))
  add(path_594510, "subscriptionId", newJString(subscriptionId))
  result = call_594509.call(path_594510, query_594511, nil, nil, nil)

var localNetworkGatewaysDelete* = Call_LocalNetworkGatewaysDelete_594501(
    name: "localNetworkGatewaysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways/{localNetworkGatewayName}",
    validator: validate_LocalNetworkGatewaysDelete_594502, base: "",
    url: url_LocalNetworkGatewaysDelete_594503, schemes: {Scheme.Https})
type
  Call_NetworkInterfacesList_594512 = ref object of OpenApiRestCall_593422
proc url_NetworkInterfacesList_594514(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkInterfacesList_594513(path: JsonNode; query: JsonNode;
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
  var valid_594515 = path.getOrDefault("resourceGroupName")
  valid_594515 = validateParameter(valid_594515, JString, required = true,
                                 default = nil)
  if valid_594515 != nil:
    section.add "resourceGroupName", valid_594515
  var valid_594516 = path.getOrDefault("subscriptionId")
  valid_594516 = validateParameter(valid_594516, JString, required = true,
                                 default = nil)
  if valid_594516 != nil:
    section.add "subscriptionId", valid_594516
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594517 = query.getOrDefault("api-version")
  valid_594517 = validateParameter(valid_594517, JString, required = true,
                                 default = nil)
  if valid_594517 != nil:
    section.add "api-version", valid_594517
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594518: Call_NetworkInterfacesList_594512; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List networkInterfaces operation retrieves all the networkInterfaces in a resource group.
  ## 
  let valid = call_594518.validator(path, query, header, formData, body)
  let scheme = call_594518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594518.url(scheme.get, call_594518.host, call_594518.base,
                         call_594518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594518, url, valid)

proc call*(call_594519: Call_NetworkInterfacesList_594512;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## networkInterfacesList
  ## The List networkInterfaces operation retrieves all the networkInterfaces in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594520 = newJObject()
  var query_594521 = newJObject()
  add(path_594520, "resourceGroupName", newJString(resourceGroupName))
  add(query_594521, "api-version", newJString(apiVersion))
  add(path_594520, "subscriptionId", newJString(subscriptionId))
  result = call_594519.call(path_594520, query_594521, nil, nil, nil)

var networkInterfacesList* = Call_NetworkInterfacesList_594512(
    name: "networkInterfacesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces",
    validator: validate_NetworkInterfacesList_594513, base: "",
    url: url_NetworkInterfacesList_594514, schemes: {Scheme.Https})
type
  Call_NetworkInterfacesCreateOrUpdate_594534 = ref object of OpenApiRestCall_593422
proc url_NetworkInterfacesCreateOrUpdate_594536(protocol: Scheme; host: string;
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

proc validate_NetworkInterfacesCreateOrUpdate_594535(path: JsonNode;
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
  var valid_594537 = path.getOrDefault("resourceGroupName")
  valid_594537 = validateParameter(valid_594537, JString, required = true,
                                 default = nil)
  if valid_594537 != nil:
    section.add "resourceGroupName", valid_594537
  var valid_594538 = path.getOrDefault("subscriptionId")
  valid_594538 = validateParameter(valid_594538, JString, required = true,
                                 default = nil)
  if valid_594538 != nil:
    section.add "subscriptionId", valid_594538
  var valid_594539 = path.getOrDefault("networkInterfaceName")
  valid_594539 = validateParameter(valid_594539, JString, required = true,
                                 default = nil)
  if valid_594539 != nil:
    section.add "networkInterfaceName", valid_594539
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594540 = query.getOrDefault("api-version")
  valid_594540 = validateParameter(valid_594540, JString, required = true,
                                 default = nil)
  if valid_594540 != nil:
    section.add "api-version", valid_594540
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

proc call*(call_594542: Call_NetworkInterfacesCreateOrUpdate_594534;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put NetworkInterface operation creates/updates a networkInterface
  ## 
  let valid = call_594542.validator(path, query, header, formData, body)
  let scheme = call_594542.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594542.url(scheme.get, call_594542.host, call_594542.base,
                         call_594542.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594542, url, valid)

proc call*(call_594543: Call_NetworkInterfacesCreateOrUpdate_594534;
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
  var path_594544 = newJObject()
  var query_594545 = newJObject()
  var body_594546 = newJObject()
  add(path_594544, "resourceGroupName", newJString(resourceGroupName))
  add(query_594545, "api-version", newJString(apiVersion))
  add(path_594544, "subscriptionId", newJString(subscriptionId))
  add(path_594544, "networkInterfaceName", newJString(networkInterfaceName))
  if parameters != nil:
    body_594546 = parameters
  result = call_594543.call(path_594544, query_594545, nil, nil, body_594546)

var networkInterfacesCreateOrUpdate* = Call_NetworkInterfacesCreateOrUpdate_594534(
    name: "networkInterfacesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/{networkInterfaceName}",
    validator: validate_NetworkInterfacesCreateOrUpdate_594535, base: "",
    url: url_NetworkInterfacesCreateOrUpdate_594536, schemes: {Scheme.Https})
type
  Call_NetworkInterfacesGet_594522 = ref object of OpenApiRestCall_593422
proc url_NetworkInterfacesGet_594524(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkInterfacesGet_594523(path: JsonNode; query: JsonNode;
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
  var valid_594525 = path.getOrDefault("resourceGroupName")
  valid_594525 = validateParameter(valid_594525, JString, required = true,
                                 default = nil)
  if valid_594525 != nil:
    section.add "resourceGroupName", valid_594525
  var valid_594526 = path.getOrDefault("subscriptionId")
  valid_594526 = validateParameter(valid_594526, JString, required = true,
                                 default = nil)
  if valid_594526 != nil:
    section.add "subscriptionId", valid_594526
  var valid_594527 = path.getOrDefault("networkInterfaceName")
  valid_594527 = validateParameter(valid_594527, JString, required = true,
                                 default = nil)
  if valid_594527 != nil:
    section.add "networkInterfaceName", valid_594527
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594528 = query.getOrDefault("api-version")
  valid_594528 = validateParameter(valid_594528, JString, required = true,
                                 default = nil)
  if valid_594528 != nil:
    section.add "api-version", valid_594528
  var valid_594529 = query.getOrDefault("$expand")
  valid_594529 = validateParameter(valid_594529, JString, required = false,
                                 default = nil)
  if valid_594529 != nil:
    section.add "$expand", valid_594529
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594530: Call_NetworkInterfacesGet_594522; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get network interface operation retrieves information about the specified network interface.
  ## 
  let valid = call_594530.validator(path, query, header, formData, body)
  let scheme = call_594530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594530.url(scheme.get, call_594530.host, call_594530.base,
                         call_594530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594530, url, valid)

proc call*(call_594531: Call_NetworkInterfacesGet_594522;
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
  var path_594532 = newJObject()
  var query_594533 = newJObject()
  add(path_594532, "resourceGroupName", newJString(resourceGroupName))
  add(query_594533, "api-version", newJString(apiVersion))
  add(query_594533, "$expand", newJString(Expand))
  add(path_594532, "subscriptionId", newJString(subscriptionId))
  add(path_594532, "networkInterfaceName", newJString(networkInterfaceName))
  result = call_594531.call(path_594532, query_594533, nil, nil, nil)

var networkInterfacesGet* = Call_NetworkInterfacesGet_594522(
    name: "networkInterfacesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/{networkInterfaceName}",
    validator: validate_NetworkInterfacesGet_594523, base: "",
    url: url_NetworkInterfacesGet_594524, schemes: {Scheme.Https})
type
  Call_NetworkInterfacesDelete_594547 = ref object of OpenApiRestCall_593422
proc url_NetworkInterfacesDelete_594549(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkInterfacesDelete_594548(path: JsonNode; query: JsonNode;
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
  var valid_594550 = path.getOrDefault("resourceGroupName")
  valid_594550 = validateParameter(valid_594550, JString, required = true,
                                 default = nil)
  if valid_594550 != nil:
    section.add "resourceGroupName", valid_594550
  var valid_594551 = path.getOrDefault("subscriptionId")
  valid_594551 = validateParameter(valid_594551, JString, required = true,
                                 default = nil)
  if valid_594551 != nil:
    section.add "subscriptionId", valid_594551
  var valid_594552 = path.getOrDefault("networkInterfaceName")
  valid_594552 = validateParameter(valid_594552, JString, required = true,
                                 default = nil)
  if valid_594552 != nil:
    section.add "networkInterfaceName", valid_594552
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594553 = query.getOrDefault("api-version")
  valid_594553 = validateParameter(valid_594553, JString, required = true,
                                 default = nil)
  if valid_594553 != nil:
    section.add "api-version", valid_594553
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594554: Call_NetworkInterfacesDelete_594547; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete networkInterface operation deletes the specified networkInterface.
  ## 
  let valid = call_594554.validator(path, query, header, formData, body)
  let scheme = call_594554.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594554.url(scheme.get, call_594554.host, call_594554.base,
                         call_594554.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594554, url, valid)

proc call*(call_594555: Call_NetworkInterfacesDelete_594547;
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
  var path_594556 = newJObject()
  var query_594557 = newJObject()
  add(path_594556, "resourceGroupName", newJString(resourceGroupName))
  add(query_594557, "api-version", newJString(apiVersion))
  add(path_594556, "subscriptionId", newJString(subscriptionId))
  add(path_594556, "networkInterfaceName", newJString(networkInterfaceName))
  result = call_594555.call(path_594556, query_594557, nil, nil, nil)

var networkInterfacesDelete* = Call_NetworkInterfacesDelete_594547(
    name: "networkInterfacesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/{networkInterfaceName}",
    validator: validate_NetworkInterfacesDelete_594548, base: "",
    url: url_NetworkInterfacesDelete_594549, schemes: {Scheme.Https})
type
  Call_NetworkSecurityGroupsList_594558 = ref object of OpenApiRestCall_593422
proc url_NetworkSecurityGroupsList_594560(protocol: Scheme; host: string;
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

proc validate_NetworkSecurityGroupsList_594559(path: JsonNode; query: JsonNode;
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
  var valid_594561 = path.getOrDefault("resourceGroupName")
  valid_594561 = validateParameter(valid_594561, JString, required = true,
                                 default = nil)
  if valid_594561 != nil:
    section.add "resourceGroupName", valid_594561
  var valid_594562 = path.getOrDefault("subscriptionId")
  valid_594562 = validateParameter(valid_594562, JString, required = true,
                                 default = nil)
  if valid_594562 != nil:
    section.add "subscriptionId", valid_594562
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

proc call*(call_594564: Call_NetworkSecurityGroupsList_594558; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list NetworkSecurityGroups returns all network security groups in a resource group
  ## 
  let valid = call_594564.validator(path, query, header, formData, body)
  let scheme = call_594564.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594564.url(scheme.get, call_594564.host, call_594564.base,
                         call_594564.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594564, url, valid)

proc call*(call_594565: Call_NetworkSecurityGroupsList_594558;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## networkSecurityGroupsList
  ## The list NetworkSecurityGroups returns all network security groups in a resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594566 = newJObject()
  var query_594567 = newJObject()
  add(path_594566, "resourceGroupName", newJString(resourceGroupName))
  add(query_594567, "api-version", newJString(apiVersion))
  add(path_594566, "subscriptionId", newJString(subscriptionId))
  result = call_594565.call(path_594566, query_594567, nil, nil, nil)

var networkSecurityGroupsList* = Call_NetworkSecurityGroupsList_594558(
    name: "networkSecurityGroupsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups",
    validator: validate_NetworkSecurityGroupsList_594559, base: "",
    url: url_NetworkSecurityGroupsList_594560, schemes: {Scheme.Https})
type
  Call_NetworkSecurityGroupsCreateOrUpdate_594580 = ref object of OpenApiRestCall_593422
proc url_NetworkSecurityGroupsCreateOrUpdate_594582(protocol: Scheme; host: string;
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

proc validate_NetworkSecurityGroupsCreateOrUpdate_594581(path: JsonNode;
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
  var valid_594583 = path.getOrDefault("resourceGroupName")
  valid_594583 = validateParameter(valid_594583, JString, required = true,
                                 default = nil)
  if valid_594583 != nil:
    section.add "resourceGroupName", valid_594583
  var valid_594584 = path.getOrDefault("subscriptionId")
  valid_594584 = validateParameter(valid_594584, JString, required = true,
                                 default = nil)
  if valid_594584 != nil:
    section.add "subscriptionId", valid_594584
  var valid_594585 = path.getOrDefault("networkSecurityGroupName")
  valid_594585 = validateParameter(valid_594585, JString, required = true,
                                 default = nil)
  if valid_594585 != nil:
    section.add "networkSecurityGroupName", valid_594585
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594586 = query.getOrDefault("api-version")
  valid_594586 = validateParameter(valid_594586, JString, required = true,
                                 default = nil)
  if valid_594586 != nil:
    section.add "api-version", valid_594586
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

proc call*(call_594588: Call_NetworkSecurityGroupsCreateOrUpdate_594580;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put NetworkSecurityGroup operation creates/updates a network security group in the specified resource group.
  ## 
  let valid = call_594588.validator(path, query, header, formData, body)
  let scheme = call_594588.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594588.url(scheme.get, call_594588.host, call_594588.base,
                         call_594588.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594588, url, valid)

proc call*(call_594589: Call_NetworkSecurityGroupsCreateOrUpdate_594580;
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
  var path_594590 = newJObject()
  var query_594591 = newJObject()
  var body_594592 = newJObject()
  add(path_594590, "resourceGroupName", newJString(resourceGroupName))
  add(query_594591, "api-version", newJString(apiVersion))
  add(path_594590, "subscriptionId", newJString(subscriptionId))
  add(path_594590, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  if parameters != nil:
    body_594592 = parameters
  result = call_594589.call(path_594590, query_594591, nil, nil, body_594592)

var networkSecurityGroupsCreateOrUpdate* = Call_NetworkSecurityGroupsCreateOrUpdate_594580(
    name: "networkSecurityGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}",
    validator: validate_NetworkSecurityGroupsCreateOrUpdate_594581, base: "",
    url: url_NetworkSecurityGroupsCreateOrUpdate_594582, schemes: {Scheme.Https})
type
  Call_NetworkSecurityGroupsGet_594568 = ref object of OpenApiRestCall_593422
proc url_NetworkSecurityGroupsGet_594570(protocol: Scheme; host: string;
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

proc validate_NetworkSecurityGroupsGet_594569(path: JsonNode; query: JsonNode;
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
  var valid_594573 = path.getOrDefault("networkSecurityGroupName")
  valid_594573 = validateParameter(valid_594573, JString, required = true,
                                 default = nil)
  if valid_594573 != nil:
    section.add "networkSecurityGroupName", valid_594573
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594574 = query.getOrDefault("api-version")
  valid_594574 = validateParameter(valid_594574, JString, required = true,
                                 default = nil)
  if valid_594574 != nil:
    section.add "api-version", valid_594574
  var valid_594575 = query.getOrDefault("$expand")
  valid_594575 = validateParameter(valid_594575, JString, required = false,
                                 default = nil)
  if valid_594575 != nil:
    section.add "$expand", valid_594575
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594576: Call_NetworkSecurityGroupsGet_594568; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get NetworkSecurityGroups operation retrieves information about the specified network security group.
  ## 
  let valid = call_594576.validator(path, query, header, formData, body)
  let scheme = call_594576.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594576.url(scheme.get, call_594576.host, call_594576.base,
                         call_594576.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594576, url, valid)

proc call*(call_594577: Call_NetworkSecurityGroupsGet_594568;
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
  var path_594578 = newJObject()
  var query_594579 = newJObject()
  add(path_594578, "resourceGroupName", newJString(resourceGroupName))
  add(query_594579, "api-version", newJString(apiVersion))
  add(query_594579, "$expand", newJString(Expand))
  add(path_594578, "subscriptionId", newJString(subscriptionId))
  add(path_594578, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  result = call_594577.call(path_594578, query_594579, nil, nil, nil)

var networkSecurityGroupsGet* = Call_NetworkSecurityGroupsGet_594568(
    name: "networkSecurityGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}",
    validator: validate_NetworkSecurityGroupsGet_594569, base: "",
    url: url_NetworkSecurityGroupsGet_594570, schemes: {Scheme.Https})
type
  Call_NetworkSecurityGroupsDelete_594593 = ref object of OpenApiRestCall_593422
proc url_NetworkSecurityGroupsDelete_594595(protocol: Scheme; host: string;
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

proc validate_NetworkSecurityGroupsDelete_594594(path: JsonNode; query: JsonNode;
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
  var valid_594596 = path.getOrDefault("resourceGroupName")
  valid_594596 = validateParameter(valid_594596, JString, required = true,
                                 default = nil)
  if valid_594596 != nil:
    section.add "resourceGroupName", valid_594596
  var valid_594597 = path.getOrDefault("subscriptionId")
  valid_594597 = validateParameter(valid_594597, JString, required = true,
                                 default = nil)
  if valid_594597 != nil:
    section.add "subscriptionId", valid_594597
  var valid_594598 = path.getOrDefault("networkSecurityGroupName")
  valid_594598 = validateParameter(valid_594598, JString, required = true,
                                 default = nil)
  if valid_594598 != nil:
    section.add "networkSecurityGroupName", valid_594598
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594599 = query.getOrDefault("api-version")
  valid_594599 = validateParameter(valid_594599, JString, required = true,
                                 default = nil)
  if valid_594599 != nil:
    section.add "api-version", valid_594599
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594600: Call_NetworkSecurityGroupsDelete_594593; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete NetworkSecurityGroup operation deletes the specified network security group
  ## 
  let valid = call_594600.validator(path, query, header, formData, body)
  let scheme = call_594600.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594600.url(scheme.get, call_594600.host, call_594600.base,
                         call_594600.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594600, url, valid)

proc call*(call_594601: Call_NetworkSecurityGroupsDelete_594593;
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
  var path_594602 = newJObject()
  var query_594603 = newJObject()
  add(path_594602, "resourceGroupName", newJString(resourceGroupName))
  add(query_594603, "api-version", newJString(apiVersion))
  add(path_594602, "subscriptionId", newJString(subscriptionId))
  add(path_594602, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  result = call_594601.call(path_594602, query_594603, nil, nil, nil)

var networkSecurityGroupsDelete* = Call_NetworkSecurityGroupsDelete_594593(
    name: "networkSecurityGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}",
    validator: validate_NetworkSecurityGroupsDelete_594594, base: "",
    url: url_NetworkSecurityGroupsDelete_594595, schemes: {Scheme.Https})
type
  Call_SecurityRulesList_594604 = ref object of OpenApiRestCall_593422
proc url_SecurityRulesList_594606(protocol: Scheme; host: string; base: string;
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

proc validate_SecurityRulesList_594605(path: JsonNode; query: JsonNode;
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
  var valid_594607 = path.getOrDefault("resourceGroupName")
  valid_594607 = validateParameter(valid_594607, JString, required = true,
                                 default = nil)
  if valid_594607 != nil:
    section.add "resourceGroupName", valid_594607
  var valid_594608 = path.getOrDefault("subscriptionId")
  valid_594608 = validateParameter(valid_594608, JString, required = true,
                                 default = nil)
  if valid_594608 != nil:
    section.add "subscriptionId", valid_594608
  var valid_594609 = path.getOrDefault("networkSecurityGroupName")
  valid_594609 = validateParameter(valid_594609, JString, required = true,
                                 default = nil)
  if valid_594609 != nil:
    section.add "networkSecurityGroupName", valid_594609
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594610 = query.getOrDefault("api-version")
  valid_594610 = validateParameter(valid_594610, JString, required = true,
                                 default = nil)
  if valid_594610 != nil:
    section.add "api-version", valid_594610
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594611: Call_SecurityRulesList_594604; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List network security rule operation retrieves all the security rules in a network security group.
  ## 
  let valid = call_594611.validator(path, query, header, formData, body)
  let scheme = call_594611.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594611.url(scheme.get, call_594611.host, call_594611.base,
                         call_594611.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594611, url, valid)

proc call*(call_594612: Call_SecurityRulesList_594604; resourceGroupName: string;
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
  var path_594613 = newJObject()
  var query_594614 = newJObject()
  add(path_594613, "resourceGroupName", newJString(resourceGroupName))
  add(query_594614, "api-version", newJString(apiVersion))
  add(path_594613, "subscriptionId", newJString(subscriptionId))
  add(path_594613, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  result = call_594612.call(path_594613, query_594614, nil, nil, nil)

var securityRulesList* = Call_SecurityRulesList_594604(name: "securityRulesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}/securityRules",
    validator: validate_SecurityRulesList_594605, base: "",
    url: url_SecurityRulesList_594606, schemes: {Scheme.Https})
type
  Call_SecurityRulesCreateOrUpdate_594627 = ref object of OpenApiRestCall_593422
proc url_SecurityRulesCreateOrUpdate_594629(protocol: Scheme; host: string;
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

proc validate_SecurityRulesCreateOrUpdate_594628(path: JsonNode; query: JsonNode;
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
  var valid_594630 = path.getOrDefault("resourceGroupName")
  valid_594630 = validateParameter(valid_594630, JString, required = true,
                                 default = nil)
  if valid_594630 != nil:
    section.add "resourceGroupName", valid_594630
  var valid_594631 = path.getOrDefault("subscriptionId")
  valid_594631 = validateParameter(valid_594631, JString, required = true,
                                 default = nil)
  if valid_594631 != nil:
    section.add "subscriptionId", valid_594631
  var valid_594632 = path.getOrDefault("networkSecurityGroupName")
  valid_594632 = validateParameter(valid_594632, JString, required = true,
                                 default = nil)
  if valid_594632 != nil:
    section.add "networkSecurityGroupName", valid_594632
  var valid_594633 = path.getOrDefault("securityRuleName")
  valid_594633 = validateParameter(valid_594633, JString, required = true,
                                 default = nil)
  if valid_594633 != nil:
    section.add "securityRuleName", valid_594633
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594634 = query.getOrDefault("api-version")
  valid_594634 = validateParameter(valid_594634, JString, required = true,
                                 default = nil)
  if valid_594634 != nil:
    section.add "api-version", valid_594634
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

proc call*(call_594636: Call_SecurityRulesCreateOrUpdate_594627; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put network security rule operation creates/updates a security rule in the specified network security group
  ## 
  let valid = call_594636.validator(path, query, header, formData, body)
  let scheme = call_594636.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594636.url(scheme.get, call_594636.host, call_594636.base,
                         call_594636.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594636, url, valid)

proc call*(call_594637: Call_SecurityRulesCreateOrUpdate_594627;
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
  var path_594638 = newJObject()
  var query_594639 = newJObject()
  var body_594640 = newJObject()
  add(path_594638, "resourceGroupName", newJString(resourceGroupName))
  add(query_594639, "api-version", newJString(apiVersion))
  add(path_594638, "subscriptionId", newJString(subscriptionId))
  add(path_594638, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  add(path_594638, "securityRuleName", newJString(securityRuleName))
  if securityRuleParameters != nil:
    body_594640 = securityRuleParameters
  result = call_594637.call(path_594638, query_594639, nil, nil, body_594640)

var securityRulesCreateOrUpdate* = Call_SecurityRulesCreateOrUpdate_594627(
    name: "securityRulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}/securityRules/{securityRuleName}",
    validator: validate_SecurityRulesCreateOrUpdate_594628, base: "",
    url: url_SecurityRulesCreateOrUpdate_594629, schemes: {Scheme.Https})
type
  Call_SecurityRulesGet_594615 = ref object of OpenApiRestCall_593422
proc url_SecurityRulesGet_594617(protocol: Scheme; host: string; base: string;
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

proc validate_SecurityRulesGet_594616(path: JsonNode; query: JsonNode;
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
  var valid_594618 = path.getOrDefault("resourceGroupName")
  valid_594618 = validateParameter(valid_594618, JString, required = true,
                                 default = nil)
  if valid_594618 != nil:
    section.add "resourceGroupName", valid_594618
  var valid_594619 = path.getOrDefault("subscriptionId")
  valid_594619 = validateParameter(valid_594619, JString, required = true,
                                 default = nil)
  if valid_594619 != nil:
    section.add "subscriptionId", valid_594619
  var valid_594620 = path.getOrDefault("networkSecurityGroupName")
  valid_594620 = validateParameter(valid_594620, JString, required = true,
                                 default = nil)
  if valid_594620 != nil:
    section.add "networkSecurityGroupName", valid_594620
  var valid_594621 = path.getOrDefault("securityRuleName")
  valid_594621 = validateParameter(valid_594621, JString, required = true,
                                 default = nil)
  if valid_594621 != nil:
    section.add "securityRuleName", valid_594621
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594622 = query.getOrDefault("api-version")
  valid_594622 = validateParameter(valid_594622, JString, required = true,
                                 default = nil)
  if valid_594622 != nil:
    section.add "api-version", valid_594622
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594623: Call_SecurityRulesGet_594615; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get NetworkSecurityRule operation retrieves information about the specified network security rule.
  ## 
  let valid = call_594623.validator(path, query, header, formData, body)
  let scheme = call_594623.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594623.url(scheme.get, call_594623.host, call_594623.base,
                         call_594623.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594623, url, valid)

proc call*(call_594624: Call_SecurityRulesGet_594615; resourceGroupName: string;
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
  var path_594625 = newJObject()
  var query_594626 = newJObject()
  add(path_594625, "resourceGroupName", newJString(resourceGroupName))
  add(query_594626, "api-version", newJString(apiVersion))
  add(path_594625, "subscriptionId", newJString(subscriptionId))
  add(path_594625, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  add(path_594625, "securityRuleName", newJString(securityRuleName))
  result = call_594624.call(path_594625, query_594626, nil, nil, nil)

var securityRulesGet* = Call_SecurityRulesGet_594615(name: "securityRulesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}/securityRules/{securityRuleName}",
    validator: validate_SecurityRulesGet_594616, base: "",
    url: url_SecurityRulesGet_594617, schemes: {Scheme.Https})
type
  Call_SecurityRulesDelete_594641 = ref object of OpenApiRestCall_593422
proc url_SecurityRulesDelete_594643(protocol: Scheme; host: string; base: string;
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

proc validate_SecurityRulesDelete_594642(path: JsonNode; query: JsonNode;
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
  var valid_594644 = path.getOrDefault("resourceGroupName")
  valid_594644 = validateParameter(valid_594644, JString, required = true,
                                 default = nil)
  if valid_594644 != nil:
    section.add "resourceGroupName", valid_594644
  var valid_594645 = path.getOrDefault("subscriptionId")
  valid_594645 = validateParameter(valid_594645, JString, required = true,
                                 default = nil)
  if valid_594645 != nil:
    section.add "subscriptionId", valid_594645
  var valid_594646 = path.getOrDefault("networkSecurityGroupName")
  valid_594646 = validateParameter(valid_594646, JString, required = true,
                                 default = nil)
  if valid_594646 != nil:
    section.add "networkSecurityGroupName", valid_594646
  var valid_594647 = path.getOrDefault("securityRuleName")
  valid_594647 = validateParameter(valid_594647, JString, required = true,
                                 default = nil)
  if valid_594647 != nil:
    section.add "securityRuleName", valid_594647
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594648 = query.getOrDefault("api-version")
  valid_594648 = validateParameter(valid_594648, JString, required = true,
                                 default = nil)
  if valid_594648 != nil:
    section.add "api-version", valid_594648
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594649: Call_SecurityRulesDelete_594641; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete network security rule operation deletes the specified network security rule.
  ## 
  let valid = call_594649.validator(path, query, header, formData, body)
  let scheme = call_594649.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594649.url(scheme.get, call_594649.host, call_594649.base,
                         call_594649.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594649, url, valid)

proc call*(call_594650: Call_SecurityRulesDelete_594641; resourceGroupName: string;
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
  var path_594651 = newJObject()
  var query_594652 = newJObject()
  add(path_594651, "resourceGroupName", newJString(resourceGroupName))
  add(query_594652, "api-version", newJString(apiVersion))
  add(path_594651, "subscriptionId", newJString(subscriptionId))
  add(path_594651, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  add(path_594651, "securityRuleName", newJString(securityRuleName))
  result = call_594650.call(path_594651, query_594652, nil, nil, nil)

var securityRulesDelete* = Call_SecurityRulesDelete_594641(
    name: "securityRulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}/securityRules/{securityRuleName}",
    validator: validate_SecurityRulesDelete_594642, base: "",
    url: url_SecurityRulesDelete_594643, schemes: {Scheme.Https})
type
  Call_PublicIPAddressesList_594653 = ref object of OpenApiRestCall_593422
proc url_PublicIPAddressesList_594655(protocol: Scheme; host: string; base: string;
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

proc validate_PublicIPAddressesList_594654(path: JsonNode; query: JsonNode;
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
  var valid_594656 = path.getOrDefault("resourceGroupName")
  valid_594656 = validateParameter(valid_594656, JString, required = true,
                                 default = nil)
  if valid_594656 != nil:
    section.add "resourceGroupName", valid_594656
  var valid_594657 = path.getOrDefault("subscriptionId")
  valid_594657 = validateParameter(valid_594657, JString, required = true,
                                 default = nil)
  if valid_594657 != nil:
    section.add "subscriptionId", valid_594657
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594658 = query.getOrDefault("api-version")
  valid_594658 = validateParameter(valid_594658, JString, required = true,
                                 default = nil)
  if valid_594658 != nil:
    section.add "api-version", valid_594658
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594659: Call_PublicIPAddressesList_594653; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List publicIpAddress operation retrieves all the publicIpAddresses in a resource group.
  ## 
  let valid = call_594659.validator(path, query, header, formData, body)
  let scheme = call_594659.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594659.url(scheme.get, call_594659.host, call_594659.base,
                         call_594659.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594659, url, valid)

proc call*(call_594660: Call_PublicIPAddressesList_594653;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## publicIPAddressesList
  ## The List publicIpAddress operation retrieves all the publicIpAddresses in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594661 = newJObject()
  var query_594662 = newJObject()
  add(path_594661, "resourceGroupName", newJString(resourceGroupName))
  add(query_594662, "api-version", newJString(apiVersion))
  add(path_594661, "subscriptionId", newJString(subscriptionId))
  result = call_594660.call(path_594661, query_594662, nil, nil, nil)

var publicIPAddressesList* = Call_PublicIPAddressesList_594653(
    name: "publicIPAddressesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses",
    validator: validate_PublicIPAddressesList_594654, base: "",
    url: url_PublicIPAddressesList_594655, schemes: {Scheme.Https})
type
  Call_PublicIPAddressesCreateOrUpdate_594675 = ref object of OpenApiRestCall_593422
proc url_PublicIPAddressesCreateOrUpdate_594677(protocol: Scheme; host: string;
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

proc validate_PublicIPAddressesCreateOrUpdate_594676(path: JsonNode;
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
  var valid_594678 = path.getOrDefault("resourceGroupName")
  valid_594678 = validateParameter(valid_594678, JString, required = true,
                                 default = nil)
  if valid_594678 != nil:
    section.add "resourceGroupName", valid_594678
  var valid_594679 = path.getOrDefault("publicIpAddressName")
  valid_594679 = validateParameter(valid_594679, JString, required = true,
                                 default = nil)
  if valid_594679 != nil:
    section.add "publicIpAddressName", valid_594679
  var valid_594680 = path.getOrDefault("subscriptionId")
  valid_594680 = validateParameter(valid_594680, JString, required = true,
                                 default = nil)
  if valid_594680 != nil:
    section.add "subscriptionId", valid_594680
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594681 = query.getOrDefault("api-version")
  valid_594681 = validateParameter(valid_594681, JString, required = true,
                                 default = nil)
  if valid_594681 != nil:
    section.add "api-version", valid_594681
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

proc call*(call_594683: Call_PublicIPAddressesCreateOrUpdate_594675;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put PublicIPAddress operation creates/updates a stable/dynamic PublicIP address
  ## 
  let valid = call_594683.validator(path, query, header, formData, body)
  let scheme = call_594683.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594683.url(scheme.get, call_594683.host, call_594683.base,
                         call_594683.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594683, url, valid)

proc call*(call_594684: Call_PublicIPAddressesCreateOrUpdate_594675;
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
  var path_594685 = newJObject()
  var query_594686 = newJObject()
  var body_594687 = newJObject()
  add(path_594685, "resourceGroupName", newJString(resourceGroupName))
  add(query_594686, "api-version", newJString(apiVersion))
  add(path_594685, "publicIpAddressName", newJString(publicIpAddressName))
  add(path_594685, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594687 = parameters
  result = call_594684.call(path_594685, query_594686, nil, nil, body_594687)

var publicIPAddressesCreateOrUpdate* = Call_PublicIPAddressesCreateOrUpdate_594675(
    name: "publicIPAddressesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses/{publicIpAddressName}",
    validator: validate_PublicIPAddressesCreateOrUpdate_594676, base: "",
    url: url_PublicIPAddressesCreateOrUpdate_594677, schemes: {Scheme.Https})
type
  Call_PublicIPAddressesGet_594663 = ref object of OpenApiRestCall_593422
proc url_PublicIPAddressesGet_594665(protocol: Scheme; host: string; base: string;
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

proc validate_PublicIPAddressesGet_594664(path: JsonNode; query: JsonNode;
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
  var valid_594666 = path.getOrDefault("resourceGroupName")
  valid_594666 = validateParameter(valid_594666, JString, required = true,
                                 default = nil)
  if valid_594666 != nil:
    section.add "resourceGroupName", valid_594666
  var valid_594667 = path.getOrDefault("publicIpAddressName")
  valid_594667 = validateParameter(valid_594667, JString, required = true,
                                 default = nil)
  if valid_594667 != nil:
    section.add "publicIpAddressName", valid_594667
  var valid_594668 = path.getOrDefault("subscriptionId")
  valid_594668 = validateParameter(valid_594668, JString, required = true,
                                 default = nil)
  if valid_594668 != nil:
    section.add "subscriptionId", valid_594668
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594669 = query.getOrDefault("api-version")
  valid_594669 = validateParameter(valid_594669, JString, required = true,
                                 default = nil)
  if valid_594669 != nil:
    section.add "api-version", valid_594669
  var valid_594670 = query.getOrDefault("$expand")
  valid_594670 = validateParameter(valid_594670, JString, required = false,
                                 default = nil)
  if valid_594670 != nil:
    section.add "$expand", valid_594670
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594671: Call_PublicIPAddressesGet_594663; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get publicIpAddress operation retrieves information about the specified pubicIpAddress
  ## 
  let valid = call_594671.validator(path, query, header, formData, body)
  let scheme = call_594671.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594671.url(scheme.get, call_594671.host, call_594671.base,
                         call_594671.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594671, url, valid)

proc call*(call_594672: Call_PublicIPAddressesGet_594663;
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
  var path_594673 = newJObject()
  var query_594674 = newJObject()
  add(path_594673, "resourceGroupName", newJString(resourceGroupName))
  add(query_594674, "api-version", newJString(apiVersion))
  add(query_594674, "$expand", newJString(Expand))
  add(path_594673, "publicIpAddressName", newJString(publicIpAddressName))
  add(path_594673, "subscriptionId", newJString(subscriptionId))
  result = call_594672.call(path_594673, query_594674, nil, nil, nil)

var publicIPAddressesGet* = Call_PublicIPAddressesGet_594663(
    name: "publicIPAddressesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses/{publicIpAddressName}",
    validator: validate_PublicIPAddressesGet_594664, base: "",
    url: url_PublicIPAddressesGet_594665, schemes: {Scheme.Https})
type
  Call_PublicIPAddressesDelete_594688 = ref object of OpenApiRestCall_593422
proc url_PublicIPAddressesDelete_594690(protocol: Scheme; host: string; base: string;
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

proc validate_PublicIPAddressesDelete_594689(path: JsonNode; query: JsonNode;
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
  var valid_594691 = path.getOrDefault("resourceGroupName")
  valid_594691 = validateParameter(valid_594691, JString, required = true,
                                 default = nil)
  if valid_594691 != nil:
    section.add "resourceGroupName", valid_594691
  var valid_594692 = path.getOrDefault("publicIpAddressName")
  valid_594692 = validateParameter(valid_594692, JString, required = true,
                                 default = nil)
  if valid_594692 != nil:
    section.add "publicIpAddressName", valid_594692
  var valid_594693 = path.getOrDefault("subscriptionId")
  valid_594693 = validateParameter(valid_594693, JString, required = true,
                                 default = nil)
  if valid_594693 != nil:
    section.add "subscriptionId", valid_594693
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594694 = query.getOrDefault("api-version")
  valid_594694 = validateParameter(valid_594694, JString, required = true,
                                 default = nil)
  if valid_594694 != nil:
    section.add "api-version", valid_594694
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594695: Call_PublicIPAddressesDelete_594688; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete publicIpAddress operation deletes the specified publicIpAddress.
  ## 
  let valid = call_594695.validator(path, query, header, formData, body)
  let scheme = call_594695.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594695.url(scheme.get, call_594695.host, call_594695.base,
                         call_594695.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594695, url, valid)

proc call*(call_594696: Call_PublicIPAddressesDelete_594688;
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
  var path_594697 = newJObject()
  var query_594698 = newJObject()
  add(path_594697, "resourceGroupName", newJString(resourceGroupName))
  add(query_594698, "api-version", newJString(apiVersion))
  add(path_594697, "publicIpAddressName", newJString(publicIpAddressName))
  add(path_594697, "subscriptionId", newJString(subscriptionId))
  result = call_594696.call(path_594697, query_594698, nil, nil, nil)

var publicIPAddressesDelete* = Call_PublicIPAddressesDelete_594688(
    name: "publicIPAddressesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses/{publicIpAddressName}",
    validator: validate_PublicIPAddressesDelete_594689, base: "",
    url: url_PublicIPAddressesDelete_594690, schemes: {Scheme.Https})
type
  Call_RouteTablesList_594699 = ref object of OpenApiRestCall_593422
proc url_RouteTablesList_594701(protocol: Scheme; host: string; base: string;
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

proc validate_RouteTablesList_594700(path: JsonNode; query: JsonNode;
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
  var valid_594702 = path.getOrDefault("resourceGroupName")
  valid_594702 = validateParameter(valid_594702, JString, required = true,
                                 default = nil)
  if valid_594702 != nil:
    section.add "resourceGroupName", valid_594702
  var valid_594703 = path.getOrDefault("subscriptionId")
  valid_594703 = validateParameter(valid_594703, JString, required = true,
                                 default = nil)
  if valid_594703 != nil:
    section.add "subscriptionId", valid_594703
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594704 = query.getOrDefault("api-version")
  valid_594704 = validateParameter(valid_594704, JString, required = true,
                                 default = nil)
  if valid_594704 != nil:
    section.add "api-version", valid_594704
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594705: Call_RouteTablesList_594699; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list RouteTables returns all route tables in a resource group
  ## 
  let valid = call_594705.validator(path, query, header, formData, body)
  let scheme = call_594705.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594705.url(scheme.get, call_594705.host, call_594705.base,
                         call_594705.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594705, url, valid)

proc call*(call_594706: Call_RouteTablesList_594699; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## routeTablesList
  ## The list RouteTables returns all route tables in a resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594707 = newJObject()
  var query_594708 = newJObject()
  add(path_594707, "resourceGroupName", newJString(resourceGroupName))
  add(query_594708, "api-version", newJString(apiVersion))
  add(path_594707, "subscriptionId", newJString(subscriptionId))
  result = call_594706.call(path_594707, query_594708, nil, nil, nil)

var routeTablesList* = Call_RouteTablesList_594699(name: "routeTablesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables",
    validator: validate_RouteTablesList_594700, base: "", url: url_RouteTablesList_594701,
    schemes: {Scheme.Https})
type
  Call_RouteTablesCreateOrUpdate_594721 = ref object of OpenApiRestCall_593422
proc url_RouteTablesCreateOrUpdate_594723(protocol: Scheme; host: string;
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

proc validate_RouteTablesCreateOrUpdate_594722(path: JsonNode; query: JsonNode;
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
  var valid_594724 = path.getOrDefault("resourceGroupName")
  valid_594724 = validateParameter(valid_594724, JString, required = true,
                                 default = nil)
  if valid_594724 != nil:
    section.add "resourceGroupName", valid_594724
  var valid_594725 = path.getOrDefault("routeTableName")
  valid_594725 = validateParameter(valid_594725, JString, required = true,
                                 default = nil)
  if valid_594725 != nil:
    section.add "routeTableName", valid_594725
  var valid_594726 = path.getOrDefault("subscriptionId")
  valid_594726 = validateParameter(valid_594726, JString, required = true,
                                 default = nil)
  if valid_594726 != nil:
    section.add "subscriptionId", valid_594726
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594727 = query.getOrDefault("api-version")
  valid_594727 = validateParameter(valid_594727, JString, required = true,
                                 default = nil)
  if valid_594727 != nil:
    section.add "api-version", valid_594727
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

proc call*(call_594729: Call_RouteTablesCreateOrUpdate_594721; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put RouteTable operation creates/updates a route table in the specified resource group.
  ## 
  let valid = call_594729.validator(path, query, header, formData, body)
  let scheme = call_594729.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594729.url(scheme.get, call_594729.host, call_594729.base,
                         call_594729.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594729, url, valid)

proc call*(call_594730: Call_RouteTablesCreateOrUpdate_594721;
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
  var path_594731 = newJObject()
  var query_594732 = newJObject()
  var body_594733 = newJObject()
  add(path_594731, "resourceGroupName", newJString(resourceGroupName))
  add(path_594731, "routeTableName", newJString(routeTableName))
  add(query_594732, "api-version", newJString(apiVersion))
  add(path_594731, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594733 = parameters
  result = call_594730.call(path_594731, query_594732, nil, nil, body_594733)

var routeTablesCreateOrUpdate* = Call_RouteTablesCreateOrUpdate_594721(
    name: "routeTablesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}",
    validator: validate_RouteTablesCreateOrUpdate_594722, base: "",
    url: url_RouteTablesCreateOrUpdate_594723, schemes: {Scheme.Https})
type
  Call_RouteTablesGet_594709 = ref object of OpenApiRestCall_593422
proc url_RouteTablesGet_594711(protocol: Scheme; host: string; base: string;
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

proc validate_RouteTablesGet_594710(path: JsonNode; query: JsonNode;
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
  var valid_594712 = path.getOrDefault("resourceGroupName")
  valid_594712 = validateParameter(valid_594712, JString, required = true,
                                 default = nil)
  if valid_594712 != nil:
    section.add "resourceGroupName", valid_594712
  var valid_594713 = path.getOrDefault("routeTableName")
  valid_594713 = validateParameter(valid_594713, JString, required = true,
                                 default = nil)
  if valid_594713 != nil:
    section.add "routeTableName", valid_594713
  var valid_594714 = path.getOrDefault("subscriptionId")
  valid_594714 = validateParameter(valid_594714, JString, required = true,
                                 default = nil)
  if valid_594714 != nil:
    section.add "subscriptionId", valid_594714
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594715 = query.getOrDefault("api-version")
  valid_594715 = validateParameter(valid_594715, JString, required = true,
                                 default = nil)
  if valid_594715 != nil:
    section.add "api-version", valid_594715
  var valid_594716 = query.getOrDefault("$expand")
  valid_594716 = validateParameter(valid_594716, JString, required = false,
                                 default = nil)
  if valid_594716 != nil:
    section.add "$expand", valid_594716
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594717: Call_RouteTablesGet_594709; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get RouteTables operation retrieves information about the specified route table.
  ## 
  let valid = call_594717.validator(path, query, header, formData, body)
  let scheme = call_594717.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594717.url(scheme.get, call_594717.host, call_594717.base,
                         call_594717.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594717, url, valid)

proc call*(call_594718: Call_RouteTablesGet_594709; resourceGroupName: string;
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
  var path_594719 = newJObject()
  var query_594720 = newJObject()
  add(path_594719, "resourceGroupName", newJString(resourceGroupName))
  add(path_594719, "routeTableName", newJString(routeTableName))
  add(query_594720, "api-version", newJString(apiVersion))
  add(query_594720, "$expand", newJString(Expand))
  add(path_594719, "subscriptionId", newJString(subscriptionId))
  result = call_594718.call(path_594719, query_594720, nil, nil, nil)

var routeTablesGet* = Call_RouteTablesGet_594709(name: "routeTablesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}",
    validator: validate_RouteTablesGet_594710, base: "", url: url_RouteTablesGet_594711,
    schemes: {Scheme.Https})
type
  Call_RouteTablesDelete_594734 = ref object of OpenApiRestCall_593422
proc url_RouteTablesDelete_594736(protocol: Scheme; host: string; base: string;
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

proc validate_RouteTablesDelete_594735(path: JsonNode; query: JsonNode;
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
  var valid_594737 = path.getOrDefault("resourceGroupName")
  valid_594737 = validateParameter(valid_594737, JString, required = true,
                                 default = nil)
  if valid_594737 != nil:
    section.add "resourceGroupName", valid_594737
  var valid_594738 = path.getOrDefault("routeTableName")
  valid_594738 = validateParameter(valid_594738, JString, required = true,
                                 default = nil)
  if valid_594738 != nil:
    section.add "routeTableName", valid_594738
  var valid_594739 = path.getOrDefault("subscriptionId")
  valid_594739 = validateParameter(valid_594739, JString, required = true,
                                 default = nil)
  if valid_594739 != nil:
    section.add "subscriptionId", valid_594739
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594740 = query.getOrDefault("api-version")
  valid_594740 = validateParameter(valid_594740, JString, required = true,
                                 default = nil)
  if valid_594740 != nil:
    section.add "api-version", valid_594740
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594741: Call_RouteTablesDelete_594734; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete RouteTable operation deletes the specified Route Table
  ## 
  let valid = call_594741.validator(path, query, header, formData, body)
  let scheme = call_594741.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594741.url(scheme.get, call_594741.host, call_594741.base,
                         call_594741.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594741, url, valid)

proc call*(call_594742: Call_RouteTablesDelete_594734; resourceGroupName: string;
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
  var path_594743 = newJObject()
  var query_594744 = newJObject()
  add(path_594743, "resourceGroupName", newJString(resourceGroupName))
  add(path_594743, "routeTableName", newJString(routeTableName))
  add(query_594744, "api-version", newJString(apiVersion))
  add(path_594743, "subscriptionId", newJString(subscriptionId))
  result = call_594742.call(path_594743, query_594744, nil, nil, nil)

var routeTablesDelete* = Call_RouteTablesDelete_594734(name: "routeTablesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}",
    validator: validate_RouteTablesDelete_594735, base: "",
    url: url_RouteTablesDelete_594736, schemes: {Scheme.Https})
type
  Call_RoutesList_594745 = ref object of OpenApiRestCall_593422
proc url_RoutesList_594747(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_RoutesList_594746(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594748 = path.getOrDefault("resourceGroupName")
  valid_594748 = validateParameter(valid_594748, JString, required = true,
                                 default = nil)
  if valid_594748 != nil:
    section.add "resourceGroupName", valid_594748
  var valid_594749 = path.getOrDefault("routeTableName")
  valid_594749 = validateParameter(valid_594749, JString, required = true,
                                 default = nil)
  if valid_594749 != nil:
    section.add "routeTableName", valid_594749
  var valid_594750 = path.getOrDefault("subscriptionId")
  valid_594750 = validateParameter(valid_594750, JString, required = true,
                                 default = nil)
  if valid_594750 != nil:
    section.add "subscriptionId", valid_594750
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594751 = query.getOrDefault("api-version")
  valid_594751 = validateParameter(valid_594751, JString, required = true,
                                 default = nil)
  if valid_594751 != nil:
    section.add "api-version", valid_594751
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594752: Call_RoutesList_594745; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List network security rule operation retrieves all the routes in a route table.
  ## 
  let valid = call_594752.validator(path, query, header, formData, body)
  let scheme = call_594752.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594752.url(scheme.get, call_594752.host, call_594752.base,
                         call_594752.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594752, url, valid)

proc call*(call_594753: Call_RoutesList_594745; resourceGroupName: string;
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
  var path_594754 = newJObject()
  var query_594755 = newJObject()
  add(path_594754, "resourceGroupName", newJString(resourceGroupName))
  add(path_594754, "routeTableName", newJString(routeTableName))
  add(query_594755, "api-version", newJString(apiVersion))
  add(path_594754, "subscriptionId", newJString(subscriptionId))
  result = call_594753.call(path_594754, query_594755, nil, nil, nil)

var routesList* = Call_RoutesList_594745(name: "routesList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}/routes",
                                      validator: validate_RoutesList_594746,
                                      base: "", url: url_RoutesList_594747,
                                      schemes: {Scheme.Https})
type
  Call_RoutesCreateOrUpdate_594768 = ref object of OpenApiRestCall_593422
proc url_RoutesCreateOrUpdate_594770(protocol: Scheme; host: string; base: string;
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

proc validate_RoutesCreateOrUpdate_594769(path: JsonNode; query: JsonNode;
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
  var valid_594771 = path.getOrDefault("resourceGroupName")
  valid_594771 = validateParameter(valid_594771, JString, required = true,
                                 default = nil)
  if valid_594771 != nil:
    section.add "resourceGroupName", valid_594771
  var valid_594772 = path.getOrDefault("routeTableName")
  valid_594772 = validateParameter(valid_594772, JString, required = true,
                                 default = nil)
  if valid_594772 != nil:
    section.add "routeTableName", valid_594772
  var valid_594773 = path.getOrDefault("subscriptionId")
  valid_594773 = validateParameter(valid_594773, JString, required = true,
                                 default = nil)
  if valid_594773 != nil:
    section.add "subscriptionId", valid_594773
  var valid_594774 = path.getOrDefault("routeName")
  valid_594774 = validateParameter(valid_594774, JString, required = true,
                                 default = nil)
  if valid_594774 != nil:
    section.add "routeName", valid_594774
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594775 = query.getOrDefault("api-version")
  valid_594775 = validateParameter(valid_594775, JString, required = true,
                                 default = nil)
  if valid_594775 != nil:
    section.add "api-version", valid_594775
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

proc call*(call_594777: Call_RoutesCreateOrUpdate_594768; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put route operation creates/updates a route in the specified route table
  ## 
  let valid = call_594777.validator(path, query, header, formData, body)
  let scheme = call_594777.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594777.url(scheme.get, call_594777.host, call_594777.base,
                         call_594777.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594777, url, valid)

proc call*(call_594778: Call_RoutesCreateOrUpdate_594768;
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
  var path_594779 = newJObject()
  var query_594780 = newJObject()
  var body_594781 = newJObject()
  add(path_594779, "resourceGroupName", newJString(resourceGroupName))
  add(path_594779, "routeTableName", newJString(routeTableName))
  add(query_594780, "api-version", newJString(apiVersion))
  add(path_594779, "subscriptionId", newJString(subscriptionId))
  add(path_594779, "routeName", newJString(routeName))
  if routeParameters != nil:
    body_594781 = routeParameters
  result = call_594778.call(path_594779, query_594780, nil, nil, body_594781)

var routesCreateOrUpdate* = Call_RoutesCreateOrUpdate_594768(
    name: "routesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}/routes/{routeName}",
    validator: validate_RoutesCreateOrUpdate_594769, base: "",
    url: url_RoutesCreateOrUpdate_594770, schemes: {Scheme.Https})
type
  Call_RoutesGet_594756 = ref object of OpenApiRestCall_593422
proc url_RoutesGet_594758(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_RoutesGet_594757(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594759 = path.getOrDefault("resourceGroupName")
  valid_594759 = validateParameter(valid_594759, JString, required = true,
                                 default = nil)
  if valid_594759 != nil:
    section.add "resourceGroupName", valid_594759
  var valid_594760 = path.getOrDefault("routeTableName")
  valid_594760 = validateParameter(valid_594760, JString, required = true,
                                 default = nil)
  if valid_594760 != nil:
    section.add "routeTableName", valid_594760
  var valid_594761 = path.getOrDefault("subscriptionId")
  valid_594761 = validateParameter(valid_594761, JString, required = true,
                                 default = nil)
  if valid_594761 != nil:
    section.add "subscriptionId", valid_594761
  var valid_594762 = path.getOrDefault("routeName")
  valid_594762 = validateParameter(valid_594762, JString, required = true,
                                 default = nil)
  if valid_594762 != nil:
    section.add "routeName", valid_594762
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594763 = query.getOrDefault("api-version")
  valid_594763 = validateParameter(valid_594763, JString, required = true,
                                 default = nil)
  if valid_594763 != nil:
    section.add "api-version", valid_594763
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594764: Call_RoutesGet_594756; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get route operation retrieves information about the specified route from the route table.
  ## 
  let valid = call_594764.validator(path, query, header, formData, body)
  let scheme = call_594764.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594764.url(scheme.get, call_594764.host, call_594764.base,
                         call_594764.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594764, url, valid)

proc call*(call_594765: Call_RoutesGet_594756; resourceGroupName: string;
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
  var path_594766 = newJObject()
  var query_594767 = newJObject()
  add(path_594766, "resourceGroupName", newJString(resourceGroupName))
  add(path_594766, "routeTableName", newJString(routeTableName))
  add(query_594767, "api-version", newJString(apiVersion))
  add(path_594766, "subscriptionId", newJString(subscriptionId))
  add(path_594766, "routeName", newJString(routeName))
  result = call_594765.call(path_594766, query_594767, nil, nil, nil)

var routesGet* = Call_RoutesGet_594756(name: "routesGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}/routes/{routeName}",
                                    validator: validate_RoutesGet_594757,
                                    base: "", url: url_RoutesGet_594758,
                                    schemes: {Scheme.Https})
type
  Call_RoutesDelete_594782 = ref object of OpenApiRestCall_593422
proc url_RoutesDelete_594784(protocol: Scheme; host: string; base: string;
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

proc validate_RoutesDelete_594783(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594785 = path.getOrDefault("resourceGroupName")
  valid_594785 = validateParameter(valid_594785, JString, required = true,
                                 default = nil)
  if valid_594785 != nil:
    section.add "resourceGroupName", valid_594785
  var valid_594786 = path.getOrDefault("routeTableName")
  valid_594786 = validateParameter(valid_594786, JString, required = true,
                                 default = nil)
  if valid_594786 != nil:
    section.add "routeTableName", valid_594786
  var valid_594787 = path.getOrDefault("subscriptionId")
  valid_594787 = validateParameter(valid_594787, JString, required = true,
                                 default = nil)
  if valid_594787 != nil:
    section.add "subscriptionId", valid_594787
  var valid_594788 = path.getOrDefault("routeName")
  valid_594788 = validateParameter(valid_594788, JString, required = true,
                                 default = nil)
  if valid_594788 != nil:
    section.add "routeName", valid_594788
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594789 = query.getOrDefault("api-version")
  valid_594789 = validateParameter(valid_594789, JString, required = true,
                                 default = nil)
  if valid_594789 != nil:
    section.add "api-version", valid_594789
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594790: Call_RoutesDelete_594782; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete route operation deletes the specified route from a route table.
  ## 
  let valid = call_594790.validator(path, query, header, formData, body)
  let scheme = call_594790.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594790.url(scheme.get, call_594790.host, call_594790.base,
                         call_594790.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594790, url, valid)

proc call*(call_594791: Call_RoutesDelete_594782; resourceGroupName: string;
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
  var path_594792 = newJObject()
  var query_594793 = newJObject()
  add(path_594792, "resourceGroupName", newJString(resourceGroupName))
  add(path_594792, "routeTableName", newJString(routeTableName))
  add(query_594793, "api-version", newJString(apiVersion))
  add(path_594792, "subscriptionId", newJString(subscriptionId))
  add(path_594792, "routeName", newJString(routeName))
  result = call_594791.call(path_594792, query_594793, nil, nil, nil)

var routesDelete* = Call_RoutesDelete_594782(name: "routesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}/routes/{routeName}",
    validator: validate_RoutesDelete_594783, base: "", url: url_RoutesDelete_594784,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysList_594794 = ref object of OpenApiRestCall_593422
proc url_VirtualNetworkGatewaysList_594796(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGatewaysList_594795(path: JsonNode; query: JsonNode;
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
  var valid_594797 = path.getOrDefault("resourceGroupName")
  valid_594797 = validateParameter(valid_594797, JString, required = true,
                                 default = nil)
  if valid_594797 != nil:
    section.add "resourceGroupName", valid_594797
  var valid_594798 = path.getOrDefault("subscriptionId")
  valid_594798 = validateParameter(valid_594798, JString, required = true,
                                 default = nil)
  if valid_594798 != nil:
    section.add "subscriptionId", valid_594798
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594799 = query.getOrDefault("api-version")
  valid_594799 = validateParameter(valid_594799, JString, required = true,
                                 default = nil)
  if valid_594799 != nil:
    section.add "api-version", valid_594799
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594800: Call_VirtualNetworkGatewaysList_594794; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List VirtualNetworkGateways operation retrieves all the virtual network gateways stored.
  ## 
  let valid = call_594800.validator(path, query, header, formData, body)
  let scheme = call_594800.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594800.url(scheme.get, call_594800.host, call_594800.base,
                         call_594800.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594800, url, valid)

proc call*(call_594801: Call_VirtualNetworkGatewaysList_594794;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualNetworkGatewaysList
  ## The List VirtualNetworkGateways operation retrieves all the virtual network gateways stored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594802 = newJObject()
  var query_594803 = newJObject()
  add(path_594802, "resourceGroupName", newJString(resourceGroupName))
  add(query_594803, "api-version", newJString(apiVersion))
  add(path_594802, "subscriptionId", newJString(subscriptionId))
  result = call_594801.call(path_594802, query_594803, nil, nil, nil)

var virtualNetworkGatewaysList* = Call_VirtualNetworkGatewaysList_594794(
    name: "virtualNetworkGatewaysList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways",
    validator: validate_VirtualNetworkGatewaysList_594795, base: "",
    url: url_VirtualNetworkGatewaysList_594796, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysCreateOrUpdate_594815 = ref object of OpenApiRestCall_593422
proc url_VirtualNetworkGatewaysCreateOrUpdate_594817(protocol: Scheme;
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

proc validate_VirtualNetworkGatewaysCreateOrUpdate_594816(path: JsonNode;
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
  var valid_594820 = path.getOrDefault("virtualNetworkGatewayName")
  valid_594820 = validateParameter(valid_594820, JString, required = true,
                                 default = nil)
  if valid_594820 != nil:
    section.add "virtualNetworkGatewayName", valid_594820
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594821 = query.getOrDefault("api-version")
  valid_594821 = validateParameter(valid_594821, JString, required = true,
                                 default = nil)
  if valid_594821 != nil:
    section.add "api-version", valid_594821
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

proc call*(call_594823: Call_VirtualNetworkGatewaysCreateOrUpdate_594815;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put VirtualNetworkGateway operation creates/updates a virtual network gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_594823.validator(path, query, header, formData, body)
  let scheme = call_594823.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594823.url(scheme.get, call_594823.host, call_594823.base,
                         call_594823.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594823, url, valid)

proc call*(call_594824: Call_VirtualNetworkGatewaysCreateOrUpdate_594815;
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
  var path_594825 = newJObject()
  var query_594826 = newJObject()
  var body_594827 = newJObject()
  add(path_594825, "resourceGroupName", newJString(resourceGroupName))
  add(query_594826, "api-version", newJString(apiVersion))
  add(path_594825, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594827 = parameters
  add(path_594825, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_594824.call(path_594825, query_594826, nil, nil, body_594827)

var virtualNetworkGatewaysCreateOrUpdate* = Call_VirtualNetworkGatewaysCreateOrUpdate_594815(
    name: "virtualNetworkGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}",
    validator: validate_VirtualNetworkGatewaysCreateOrUpdate_594816, base: "",
    url: url_VirtualNetworkGatewaysCreateOrUpdate_594817, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGet_594804 = ref object of OpenApiRestCall_593422
proc url_VirtualNetworkGatewaysGet_594806(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGatewaysGet_594805(path: JsonNode; query: JsonNode;
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
  var valid_594807 = path.getOrDefault("resourceGroupName")
  valid_594807 = validateParameter(valid_594807, JString, required = true,
                                 default = nil)
  if valid_594807 != nil:
    section.add "resourceGroupName", valid_594807
  var valid_594808 = path.getOrDefault("subscriptionId")
  valid_594808 = validateParameter(valid_594808, JString, required = true,
                                 default = nil)
  if valid_594808 != nil:
    section.add "subscriptionId", valid_594808
  var valid_594809 = path.getOrDefault("virtualNetworkGatewayName")
  valid_594809 = validateParameter(valid_594809, JString, required = true,
                                 default = nil)
  if valid_594809 != nil:
    section.add "virtualNetworkGatewayName", valid_594809
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

proc call*(call_594811: Call_VirtualNetworkGatewaysGet_594804; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get VirtualNetworkGateway operation retrieves information about the specified virtual network gateway through Network resource provider.
  ## 
  let valid = call_594811.validator(path, query, header, formData, body)
  let scheme = call_594811.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594811.url(scheme.get, call_594811.host, call_594811.base,
                         call_594811.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594811, url, valid)

proc call*(call_594812: Call_VirtualNetworkGatewaysGet_594804;
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
  var path_594813 = newJObject()
  var query_594814 = newJObject()
  add(path_594813, "resourceGroupName", newJString(resourceGroupName))
  add(query_594814, "api-version", newJString(apiVersion))
  add(path_594813, "subscriptionId", newJString(subscriptionId))
  add(path_594813, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_594812.call(path_594813, query_594814, nil, nil, nil)

var virtualNetworkGatewaysGet* = Call_VirtualNetworkGatewaysGet_594804(
    name: "virtualNetworkGatewaysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}",
    validator: validate_VirtualNetworkGatewaysGet_594805, base: "",
    url: url_VirtualNetworkGatewaysGet_594806, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysDelete_594828 = ref object of OpenApiRestCall_593422
proc url_VirtualNetworkGatewaysDelete_594830(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGatewaysDelete_594829(path: JsonNode; query: JsonNode;
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
  var valid_594831 = path.getOrDefault("resourceGroupName")
  valid_594831 = validateParameter(valid_594831, JString, required = true,
                                 default = nil)
  if valid_594831 != nil:
    section.add "resourceGroupName", valid_594831
  var valid_594832 = path.getOrDefault("subscriptionId")
  valid_594832 = validateParameter(valid_594832, JString, required = true,
                                 default = nil)
  if valid_594832 != nil:
    section.add "subscriptionId", valid_594832
  var valid_594833 = path.getOrDefault("virtualNetworkGatewayName")
  valid_594833 = validateParameter(valid_594833, JString, required = true,
                                 default = nil)
  if valid_594833 != nil:
    section.add "virtualNetworkGatewayName", valid_594833
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594834 = query.getOrDefault("api-version")
  valid_594834 = validateParameter(valid_594834, JString, required = true,
                                 default = nil)
  if valid_594834 != nil:
    section.add "api-version", valid_594834
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594835: Call_VirtualNetworkGatewaysDelete_594828; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete VirtualNetworkGateway operation deletes the specified virtual network Gateway through Network resource provider.
  ## 
  let valid = call_594835.validator(path, query, header, formData, body)
  let scheme = call_594835.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594835.url(scheme.get, call_594835.host, call_594835.base,
                         call_594835.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594835, url, valid)

proc call*(call_594836: Call_VirtualNetworkGatewaysDelete_594828;
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
  var path_594837 = newJObject()
  var query_594838 = newJObject()
  add(path_594837, "resourceGroupName", newJString(resourceGroupName))
  add(query_594838, "api-version", newJString(apiVersion))
  add(path_594837, "subscriptionId", newJString(subscriptionId))
  add(path_594837, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_594836.call(path_594837, query_594838, nil, nil, nil)

var virtualNetworkGatewaysDelete* = Call_VirtualNetworkGatewaysDelete_594828(
    name: "virtualNetworkGatewaysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}",
    validator: validate_VirtualNetworkGatewaysDelete_594829, base: "",
    url: url_VirtualNetworkGatewaysDelete_594830, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGeneratevpnclientpackage_594839 = ref object of OpenApiRestCall_593422
proc url_VirtualNetworkGatewaysGeneratevpnclientpackage_594841(protocol: Scheme;
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

proc validate_VirtualNetworkGatewaysGeneratevpnclientpackage_594840(
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
  var valid_594842 = path.getOrDefault("resourceGroupName")
  valid_594842 = validateParameter(valid_594842, JString, required = true,
                                 default = nil)
  if valid_594842 != nil:
    section.add "resourceGroupName", valid_594842
  var valid_594843 = path.getOrDefault("subscriptionId")
  valid_594843 = validateParameter(valid_594843, JString, required = true,
                                 default = nil)
  if valid_594843 != nil:
    section.add "subscriptionId", valid_594843
  var valid_594844 = path.getOrDefault("virtualNetworkGatewayName")
  valid_594844 = validateParameter(valid_594844, JString, required = true,
                                 default = nil)
  if valid_594844 != nil:
    section.add "virtualNetworkGatewayName", valid_594844
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594845 = query.getOrDefault("api-version")
  valid_594845 = validateParameter(valid_594845, JString, required = true,
                                 default = nil)
  if valid_594845 != nil:
    section.add "api-version", valid_594845
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

proc call*(call_594847: Call_VirtualNetworkGatewaysGeneratevpnclientpackage_594839;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Generatevpnclientpackage operation generates Vpn client package for P2S client of the virtual network gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_594847.validator(path, query, header, formData, body)
  let scheme = call_594847.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594847.url(scheme.get, call_594847.host, call_594847.base,
                         call_594847.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594847, url, valid)

proc call*(call_594848: Call_VirtualNetworkGatewaysGeneratevpnclientpackage_594839;
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
  var path_594849 = newJObject()
  var query_594850 = newJObject()
  var body_594851 = newJObject()
  add(path_594849, "resourceGroupName", newJString(resourceGroupName))
  add(query_594850, "api-version", newJString(apiVersion))
  add(path_594849, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594851 = parameters
  add(path_594849, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_594848.call(path_594849, query_594850, nil, nil, body_594851)

var virtualNetworkGatewaysGeneratevpnclientpackage* = Call_VirtualNetworkGatewaysGeneratevpnclientpackage_594839(
    name: "virtualNetworkGatewaysGeneratevpnclientpackage",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/generatevpnclientpackage",
    validator: validate_VirtualNetworkGatewaysGeneratevpnclientpackage_594840,
    base: "", url: url_VirtualNetworkGatewaysGeneratevpnclientpackage_594841,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysReset_594852 = ref object of OpenApiRestCall_593422
proc url_VirtualNetworkGatewaysReset_594854(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGatewaysReset_594853(path: JsonNode; query: JsonNode;
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
  var valid_594855 = path.getOrDefault("resourceGroupName")
  valid_594855 = validateParameter(valid_594855, JString, required = true,
                                 default = nil)
  if valid_594855 != nil:
    section.add "resourceGroupName", valid_594855
  var valid_594856 = path.getOrDefault("subscriptionId")
  valid_594856 = validateParameter(valid_594856, JString, required = true,
                                 default = nil)
  if valid_594856 != nil:
    section.add "subscriptionId", valid_594856
  var valid_594857 = path.getOrDefault("virtualNetworkGatewayName")
  valid_594857 = validateParameter(valid_594857, JString, required = true,
                                 default = nil)
  if valid_594857 != nil:
    section.add "virtualNetworkGatewayName", valid_594857
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594858 = query.getOrDefault("api-version")
  valid_594858 = validateParameter(valid_594858, JString, required = true,
                                 default = nil)
  if valid_594858 != nil:
    section.add "api-version", valid_594858
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

proc call*(call_594860: Call_VirtualNetworkGatewaysReset_594852; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Reset VirtualNetworkGateway operation resets the primary of the virtual network gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_594860.validator(path, query, header, formData, body)
  let scheme = call_594860.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594860.url(scheme.get, call_594860.host, call_594860.base,
                         call_594860.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594860, url, valid)

proc call*(call_594861: Call_VirtualNetworkGatewaysReset_594852;
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
  var path_594862 = newJObject()
  var query_594863 = newJObject()
  var body_594864 = newJObject()
  add(path_594862, "resourceGroupName", newJString(resourceGroupName))
  add(query_594863, "api-version", newJString(apiVersion))
  add(path_594862, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594864 = parameters
  add(path_594862, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_594861.call(path_594862, query_594863, nil, nil, body_594864)

var virtualNetworkGatewaysReset* = Call_VirtualNetworkGatewaysReset_594852(
    name: "virtualNetworkGatewaysReset", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/reset",
    validator: validate_VirtualNetworkGatewaysReset_594853, base: "",
    url: url_VirtualNetworkGatewaysReset_594854, schemes: {Scheme.Https})
type
  Call_VirtualNetworksList_594865 = ref object of OpenApiRestCall_593422
proc url_VirtualNetworksList_594867(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksList_594866(path: JsonNode; query: JsonNode;
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
  var valid_594868 = path.getOrDefault("resourceGroupName")
  valid_594868 = validateParameter(valid_594868, JString, required = true,
                                 default = nil)
  if valid_594868 != nil:
    section.add "resourceGroupName", valid_594868
  var valid_594869 = path.getOrDefault("subscriptionId")
  valid_594869 = validateParameter(valid_594869, JString, required = true,
                                 default = nil)
  if valid_594869 != nil:
    section.add "subscriptionId", valid_594869
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594870 = query.getOrDefault("api-version")
  valid_594870 = validateParameter(valid_594870, JString, required = true,
                                 default = nil)
  if valid_594870 != nil:
    section.add "api-version", valid_594870
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594871: Call_VirtualNetworksList_594865; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list VirtualNetwork returns all Virtual Networks in a resource group
  ## 
  let valid = call_594871.validator(path, query, header, formData, body)
  let scheme = call_594871.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594871.url(scheme.get, call_594871.host, call_594871.base,
                         call_594871.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594871, url, valid)

proc call*(call_594872: Call_VirtualNetworksList_594865; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## virtualNetworksList
  ## The list VirtualNetwork returns all Virtual Networks in a resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594873 = newJObject()
  var query_594874 = newJObject()
  add(path_594873, "resourceGroupName", newJString(resourceGroupName))
  add(query_594874, "api-version", newJString(apiVersion))
  add(path_594873, "subscriptionId", newJString(subscriptionId))
  result = call_594872.call(path_594873, query_594874, nil, nil, nil)

var virtualNetworksList* = Call_VirtualNetworksList_594865(
    name: "virtualNetworksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks",
    validator: validate_VirtualNetworksList_594866, base: "",
    url: url_VirtualNetworksList_594867, schemes: {Scheme.Https})
type
  Call_VirtualNetworksCreateOrUpdate_594887 = ref object of OpenApiRestCall_593422
proc url_VirtualNetworksCreateOrUpdate_594889(protocol: Scheme; host: string;
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

proc validate_VirtualNetworksCreateOrUpdate_594888(path: JsonNode; query: JsonNode;
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
  var valid_594890 = path.getOrDefault("resourceGroupName")
  valid_594890 = validateParameter(valid_594890, JString, required = true,
                                 default = nil)
  if valid_594890 != nil:
    section.add "resourceGroupName", valid_594890
  var valid_594891 = path.getOrDefault("subscriptionId")
  valid_594891 = validateParameter(valid_594891, JString, required = true,
                                 default = nil)
  if valid_594891 != nil:
    section.add "subscriptionId", valid_594891
  var valid_594892 = path.getOrDefault("virtualNetworkName")
  valid_594892 = validateParameter(valid_594892, JString, required = true,
                                 default = nil)
  if valid_594892 != nil:
    section.add "virtualNetworkName", valid_594892
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594893 = query.getOrDefault("api-version")
  valid_594893 = validateParameter(valid_594893, JString, required = true,
                                 default = nil)
  if valid_594893 != nil:
    section.add "api-version", valid_594893
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

proc call*(call_594895: Call_VirtualNetworksCreateOrUpdate_594887; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put VirtualNetwork operation creates/updates a virtual network in the specified resource group.
  ## 
  let valid = call_594895.validator(path, query, header, formData, body)
  let scheme = call_594895.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594895.url(scheme.get, call_594895.host, call_594895.base,
                         call_594895.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594895, url, valid)

proc call*(call_594896: Call_VirtualNetworksCreateOrUpdate_594887;
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
  var path_594897 = newJObject()
  var query_594898 = newJObject()
  var body_594899 = newJObject()
  add(path_594897, "resourceGroupName", newJString(resourceGroupName))
  add(query_594898, "api-version", newJString(apiVersion))
  add(path_594897, "subscriptionId", newJString(subscriptionId))
  add(path_594897, "virtualNetworkName", newJString(virtualNetworkName))
  if parameters != nil:
    body_594899 = parameters
  result = call_594896.call(path_594897, query_594898, nil, nil, body_594899)

var virtualNetworksCreateOrUpdate* = Call_VirtualNetworksCreateOrUpdate_594887(
    name: "virtualNetworksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworksCreateOrUpdate_594888, base: "",
    url: url_VirtualNetworksCreateOrUpdate_594889, schemes: {Scheme.Https})
type
  Call_VirtualNetworksGet_594875 = ref object of OpenApiRestCall_593422
proc url_VirtualNetworksGet_594877(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksGet_594876(path: JsonNode; query: JsonNode;
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
  var valid_594878 = path.getOrDefault("resourceGroupName")
  valid_594878 = validateParameter(valid_594878, JString, required = true,
                                 default = nil)
  if valid_594878 != nil:
    section.add "resourceGroupName", valid_594878
  var valid_594879 = path.getOrDefault("subscriptionId")
  valid_594879 = validateParameter(valid_594879, JString, required = true,
                                 default = nil)
  if valid_594879 != nil:
    section.add "subscriptionId", valid_594879
  var valid_594880 = path.getOrDefault("virtualNetworkName")
  valid_594880 = validateParameter(valid_594880, JString, required = true,
                                 default = nil)
  if valid_594880 != nil:
    section.add "virtualNetworkName", valid_594880
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594881 = query.getOrDefault("api-version")
  valid_594881 = validateParameter(valid_594881, JString, required = true,
                                 default = nil)
  if valid_594881 != nil:
    section.add "api-version", valid_594881
  var valid_594882 = query.getOrDefault("$expand")
  valid_594882 = validateParameter(valid_594882, JString, required = false,
                                 default = nil)
  if valid_594882 != nil:
    section.add "$expand", valid_594882
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594883: Call_VirtualNetworksGet_594875; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get VirtualNetwork operation retrieves information about the specified virtual network.
  ## 
  let valid = call_594883.validator(path, query, header, formData, body)
  let scheme = call_594883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594883.url(scheme.get, call_594883.host, call_594883.base,
                         call_594883.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594883, url, valid)

proc call*(call_594884: Call_VirtualNetworksGet_594875; resourceGroupName: string;
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
  var path_594885 = newJObject()
  var query_594886 = newJObject()
  add(path_594885, "resourceGroupName", newJString(resourceGroupName))
  add(query_594886, "api-version", newJString(apiVersion))
  add(query_594886, "$expand", newJString(Expand))
  add(path_594885, "subscriptionId", newJString(subscriptionId))
  add(path_594885, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_594884.call(path_594885, query_594886, nil, nil, nil)

var virtualNetworksGet* = Call_VirtualNetworksGet_594875(
    name: "virtualNetworksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworksGet_594876, base: "",
    url: url_VirtualNetworksGet_594877, schemes: {Scheme.Https})
type
  Call_VirtualNetworksDelete_594900 = ref object of OpenApiRestCall_593422
proc url_VirtualNetworksDelete_594902(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksDelete_594901(path: JsonNode; query: JsonNode;
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
  var valid_594903 = path.getOrDefault("resourceGroupName")
  valid_594903 = validateParameter(valid_594903, JString, required = true,
                                 default = nil)
  if valid_594903 != nil:
    section.add "resourceGroupName", valid_594903
  var valid_594904 = path.getOrDefault("subscriptionId")
  valid_594904 = validateParameter(valid_594904, JString, required = true,
                                 default = nil)
  if valid_594904 != nil:
    section.add "subscriptionId", valid_594904
  var valid_594905 = path.getOrDefault("virtualNetworkName")
  valid_594905 = validateParameter(valid_594905, JString, required = true,
                                 default = nil)
  if valid_594905 != nil:
    section.add "virtualNetworkName", valid_594905
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594906 = query.getOrDefault("api-version")
  valid_594906 = validateParameter(valid_594906, JString, required = true,
                                 default = nil)
  if valid_594906 != nil:
    section.add "api-version", valid_594906
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594907: Call_VirtualNetworksDelete_594900; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete VirtualNetwork operation deletes the specified virtual network
  ## 
  let valid = call_594907.validator(path, query, header, formData, body)
  let scheme = call_594907.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594907.url(scheme.get, call_594907.host, call_594907.base,
                         call_594907.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594907, url, valid)

proc call*(call_594908: Call_VirtualNetworksDelete_594900;
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
  var path_594909 = newJObject()
  var query_594910 = newJObject()
  add(path_594909, "resourceGroupName", newJString(resourceGroupName))
  add(query_594910, "api-version", newJString(apiVersion))
  add(path_594909, "subscriptionId", newJString(subscriptionId))
  add(path_594909, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_594908.call(path_594909, query_594910, nil, nil, nil)

var virtualNetworksDelete* = Call_VirtualNetworksDelete_594900(
    name: "virtualNetworksDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworksDelete_594901, base: "",
    url: url_VirtualNetworksDelete_594902, schemes: {Scheme.Https})
type
  Call_SubnetsList_594911 = ref object of OpenApiRestCall_593422
proc url_SubnetsList_594913(protocol: Scheme; host: string; base: string;
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

proc validate_SubnetsList_594912(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594914 = path.getOrDefault("resourceGroupName")
  valid_594914 = validateParameter(valid_594914, JString, required = true,
                                 default = nil)
  if valid_594914 != nil:
    section.add "resourceGroupName", valid_594914
  var valid_594915 = path.getOrDefault("subscriptionId")
  valid_594915 = validateParameter(valid_594915, JString, required = true,
                                 default = nil)
  if valid_594915 != nil:
    section.add "subscriptionId", valid_594915
  var valid_594916 = path.getOrDefault("virtualNetworkName")
  valid_594916 = validateParameter(valid_594916, JString, required = true,
                                 default = nil)
  if valid_594916 != nil:
    section.add "virtualNetworkName", valid_594916
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594917 = query.getOrDefault("api-version")
  valid_594917 = validateParameter(valid_594917, JString, required = true,
                                 default = nil)
  if valid_594917 != nil:
    section.add "api-version", valid_594917
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594918: Call_SubnetsList_594911; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List subnets operation retrieves all the subnets in a virtual network.
  ## 
  let valid = call_594918.validator(path, query, header, formData, body)
  let scheme = call_594918.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594918.url(scheme.get, call_594918.host, call_594918.base,
                         call_594918.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594918, url, valid)

proc call*(call_594919: Call_SubnetsList_594911; resourceGroupName: string;
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
  var path_594920 = newJObject()
  var query_594921 = newJObject()
  add(path_594920, "resourceGroupName", newJString(resourceGroupName))
  add(query_594921, "api-version", newJString(apiVersion))
  add(path_594920, "subscriptionId", newJString(subscriptionId))
  add(path_594920, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_594919.call(path_594920, query_594921, nil, nil, nil)

var subnetsList* = Call_SubnetsList_594911(name: "subnetsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets",
                                        validator: validate_SubnetsList_594912,
                                        base: "", url: url_SubnetsList_594913,
                                        schemes: {Scheme.Https})
type
  Call_SubnetsCreateOrUpdate_594935 = ref object of OpenApiRestCall_593422
proc url_SubnetsCreateOrUpdate_594937(protocol: Scheme; host: string; base: string;
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

proc validate_SubnetsCreateOrUpdate_594936(path: JsonNode; query: JsonNode;
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
  var valid_594938 = path.getOrDefault("resourceGroupName")
  valid_594938 = validateParameter(valid_594938, JString, required = true,
                                 default = nil)
  if valid_594938 != nil:
    section.add "resourceGroupName", valid_594938
  var valid_594939 = path.getOrDefault("subnetName")
  valid_594939 = validateParameter(valid_594939, JString, required = true,
                                 default = nil)
  if valid_594939 != nil:
    section.add "subnetName", valid_594939
  var valid_594940 = path.getOrDefault("subscriptionId")
  valid_594940 = validateParameter(valid_594940, JString, required = true,
                                 default = nil)
  if valid_594940 != nil:
    section.add "subscriptionId", valid_594940
  var valid_594941 = path.getOrDefault("virtualNetworkName")
  valid_594941 = validateParameter(valid_594941, JString, required = true,
                                 default = nil)
  if valid_594941 != nil:
    section.add "virtualNetworkName", valid_594941
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594942 = query.getOrDefault("api-version")
  valid_594942 = validateParameter(valid_594942, JString, required = true,
                                 default = nil)
  if valid_594942 != nil:
    section.add "api-version", valid_594942
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

proc call*(call_594944: Call_SubnetsCreateOrUpdate_594935; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put Subnet operation creates/updates a subnet in the specified virtual network
  ## 
  let valid = call_594944.validator(path, query, header, formData, body)
  let scheme = call_594944.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594944.url(scheme.get, call_594944.host, call_594944.base,
                         call_594944.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594944, url, valid)

proc call*(call_594945: Call_SubnetsCreateOrUpdate_594935;
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
  var path_594946 = newJObject()
  var query_594947 = newJObject()
  var body_594948 = newJObject()
  add(path_594946, "resourceGroupName", newJString(resourceGroupName))
  add(path_594946, "subnetName", newJString(subnetName))
  add(query_594947, "api-version", newJString(apiVersion))
  add(path_594946, "subscriptionId", newJString(subscriptionId))
  add(path_594946, "virtualNetworkName", newJString(virtualNetworkName))
  if subnetParameters != nil:
    body_594948 = subnetParameters
  result = call_594945.call(path_594946, query_594947, nil, nil, body_594948)

var subnetsCreateOrUpdate* = Call_SubnetsCreateOrUpdate_594935(
    name: "subnetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}",
    validator: validate_SubnetsCreateOrUpdate_594936, base: "",
    url: url_SubnetsCreateOrUpdate_594937, schemes: {Scheme.Https})
type
  Call_SubnetsGet_594922 = ref object of OpenApiRestCall_593422
proc url_SubnetsGet_594924(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SubnetsGet_594923(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594925 = path.getOrDefault("resourceGroupName")
  valid_594925 = validateParameter(valid_594925, JString, required = true,
                                 default = nil)
  if valid_594925 != nil:
    section.add "resourceGroupName", valid_594925
  var valid_594926 = path.getOrDefault("subnetName")
  valid_594926 = validateParameter(valid_594926, JString, required = true,
                                 default = nil)
  if valid_594926 != nil:
    section.add "subnetName", valid_594926
  var valid_594927 = path.getOrDefault("subscriptionId")
  valid_594927 = validateParameter(valid_594927, JString, required = true,
                                 default = nil)
  if valid_594927 != nil:
    section.add "subscriptionId", valid_594927
  var valid_594928 = path.getOrDefault("virtualNetworkName")
  valid_594928 = validateParameter(valid_594928, JString, required = true,
                                 default = nil)
  if valid_594928 != nil:
    section.add "virtualNetworkName", valid_594928
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594929 = query.getOrDefault("api-version")
  valid_594929 = validateParameter(valid_594929, JString, required = true,
                                 default = nil)
  if valid_594929 != nil:
    section.add "api-version", valid_594929
  var valid_594930 = query.getOrDefault("$expand")
  valid_594930 = validateParameter(valid_594930, JString, required = false,
                                 default = nil)
  if valid_594930 != nil:
    section.add "$expand", valid_594930
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594931: Call_SubnetsGet_594922; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get subnet operation retrieves information about the specified subnet.
  ## 
  let valid = call_594931.validator(path, query, header, formData, body)
  let scheme = call_594931.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594931.url(scheme.get, call_594931.host, call_594931.base,
                         call_594931.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594931, url, valid)

proc call*(call_594932: Call_SubnetsGet_594922; resourceGroupName: string;
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
  var path_594933 = newJObject()
  var query_594934 = newJObject()
  add(path_594933, "resourceGroupName", newJString(resourceGroupName))
  add(path_594933, "subnetName", newJString(subnetName))
  add(query_594934, "api-version", newJString(apiVersion))
  add(query_594934, "$expand", newJString(Expand))
  add(path_594933, "subscriptionId", newJString(subscriptionId))
  add(path_594933, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_594932.call(path_594933, query_594934, nil, nil, nil)

var subnetsGet* = Call_SubnetsGet_594922(name: "subnetsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}",
                                      validator: validate_SubnetsGet_594923,
                                      base: "", url: url_SubnetsGet_594924,
                                      schemes: {Scheme.Https})
type
  Call_SubnetsDelete_594949 = ref object of OpenApiRestCall_593422
proc url_SubnetsDelete_594951(protocol: Scheme; host: string; base: string;
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

proc validate_SubnetsDelete_594950(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594952 = path.getOrDefault("resourceGroupName")
  valid_594952 = validateParameter(valid_594952, JString, required = true,
                                 default = nil)
  if valid_594952 != nil:
    section.add "resourceGroupName", valid_594952
  var valid_594953 = path.getOrDefault("subnetName")
  valid_594953 = validateParameter(valid_594953, JString, required = true,
                                 default = nil)
  if valid_594953 != nil:
    section.add "subnetName", valid_594953
  var valid_594954 = path.getOrDefault("subscriptionId")
  valid_594954 = validateParameter(valid_594954, JString, required = true,
                                 default = nil)
  if valid_594954 != nil:
    section.add "subscriptionId", valid_594954
  var valid_594955 = path.getOrDefault("virtualNetworkName")
  valid_594955 = validateParameter(valid_594955, JString, required = true,
                                 default = nil)
  if valid_594955 != nil:
    section.add "virtualNetworkName", valid_594955
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594956 = query.getOrDefault("api-version")
  valid_594956 = validateParameter(valid_594956, JString, required = true,
                                 default = nil)
  if valid_594956 != nil:
    section.add "api-version", valid_594956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594957: Call_SubnetsDelete_594949; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete subnet operation deletes the specified subnet.
  ## 
  let valid = call_594957.validator(path, query, header, formData, body)
  let scheme = call_594957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594957.url(scheme.get, call_594957.host, call_594957.base,
                         call_594957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594957, url, valid)

proc call*(call_594958: Call_SubnetsDelete_594949; resourceGroupName: string;
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
  var path_594959 = newJObject()
  var query_594960 = newJObject()
  add(path_594959, "resourceGroupName", newJString(resourceGroupName))
  add(path_594959, "subnetName", newJString(subnetName))
  add(query_594960, "api-version", newJString(apiVersion))
  add(path_594959, "subscriptionId", newJString(subscriptionId))
  add(path_594959, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_594958.call(path_594959, query_594960, nil, nil, nil)

var subnetsDelete* = Call_SubnetsDelete_594949(name: "subnetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}",
    validator: validate_SubnetsDelete_594950, base: "", url: url_SubnetsDelete_594951,
    schemes: {Scheme.Https})
type
  Call_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_594961 = ref object of OpenApiRestCall_593422
proc url_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_594963(
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

proc validate_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_594962(
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
  var valid_594964 = path.getOrDefault("resourceGroupName")
  valid_594964 = validateParameter(valid_594964, JString, required = true,
                                 default = nil)
  if valid_594964 != nil:
    section.add "resourceGroupName", valid_594964
  var valid_594965 = path.getOrDefault("subscriptionId")
  valid_594965 = validateParameter(valid_594965, JString, required = true,
                                 default = nil)
  if valid_594965 != nil:
    section.add "subscriptionId", valid_594965
  var valid_594966 = path.getOrDefault("virtualMachineScaleSetName")
  valid_594966 = validateParameter(valid_594966, JString, required = true,
                                 default = nil)
  if valid_594966 != nil:
    section.add "virtualMachineScaleSetName", valid_594966
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594967 = query.getOrDefault("api-version")
  valid_594967 = validateParameter(valid_594967, JString, required = true,
                                 default = nil)
  if valid_594967 != nil:
    section.add "api-version", valid_594967
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594968: Call_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_594961;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The list network interface operation retrieves information about all network interfaces in a virtual machine scale set.
  ## 
  let valid = call_594968.validator(path, query, header, formData, body)
  let scheme = call_594968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594968.url(scheme.get, call_594968.host, call_594968.base,
                         call_594968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594968, url, valid)

proc call*(call_594969: Call_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_594961;
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
  var path_594970 = newJObject()
  var query_594971 = newJObject()
  add(path_594970, "resourceGroupName", newJString(resourceGroupName))
  add(query_594971, "api-version", newJString(apiVersion))
  add(path_594970, "subscriptionId", newJString(subscriptionId))
  add(path_594970, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  result = call_594969.call(path_594970, query_594971, nil, nil, nil)

var networkInterfacesListVirtualMachineScaleSetNetworkInterfaces* = Call_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_594961(
    name: "networkInterfacesListVirtualMachineScaleSetNetworkInterfaces",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/networkInterfaces", validator: validate_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_594962,
    base: "",
    url: url_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_594963,
    schemes: {Scheme.Https})
type
  Call_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_594972 = ref object of OpenApiRestCall_593422
proc url_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_594974(
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

proc validate_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_594973(
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
  var valid_594975 = path.getOrDefault("resourceGroupName")
  valid_594975 = validateParameter(valid_594975, JString, required = true,
                                 default = nil)
  if valid_594975 != nil:
    section.add "resourceGroupName", valid_594975
  var valid_594976 = path.getOrDefault("subscriptionId")
  valid_594976 = validateParameter(valid_594976, JString, required = true,
                                 default = nil)
  if valid_594976 != nil:
    section.add "subscriptionId", valid_594976
  var valid_594977 = path.getOrDefault("virtualmachineIndex")
  valid_594977 = validateParameter(valid_594977, JString, required = true,
                                 default = nil)
  if valid_594977 != nil:
    section.add "virtualmachineIndex", valid_594977
  var valid_594978 = path.getOrDefault("virtualMachineScaleSetName")
  valid_594978 = validateParameter(valid_594978, JString, required = true,
                                 default = nil)
  if valid_594978 != nil:
    section.add "virtualMachineScaleSetName", valid_594978
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594979 = query.getOrDefault("api-version")
  valid_594979 = validateParameter(valid_594979, JString, required = true,
                                 default = nil)
  if valid_594979 != nil:
    section.add "api-version", valid_594979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594980: Call_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_594972;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The list network interface operation retrieves information about all network interfaces in a virtual machine from a virtual machine scale set.
  ## 
  let valid = call_594980.validator(path, query, header, formData, body)
  let scheme = call_594980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594980.url(scheme.get, call_594980.host, call_594980.base,
                         call_594980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594980, url, valid)

proc call*(call_594981: Call_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_594972;
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
  var path_594982 = newJObject()
  var query_594983 = newJObject()
  add(path_594982, "resourceGroupName", newJString(resourceGroupName))
  add(query_594983, "api-version", newJString(apiVersion))
  add(path_594982, "subscriptionId", newJString(subscriptionId))
  add(path_594982, "virtualmachineIndex", newJString(virtualmachineIndex))
  add(path_594982, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  result = call_594981.call(path_594982, query_594983, nil, nil, nil)

var networkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces* = Call_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_594972(
    name: "networkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/virtualMachines/{virtualmachineIndex}/networkInterfaces", validator: validate_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_594973,
    base: "",
    url: url_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_594974,
    schemes: {Scheme.Https})
type
  Call_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_594984 = ref object of OpenApiRestCall_593422
proc url_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_594986(
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

proc validate_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_594985(
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
  var valid_594987 = path.getOrDefault("resourceGroupName")
  valid_594987 = validateParameter(valid_594987, JString, required = true,
                                 default = nil)
  if valid_594987 != nil:
    section.add "resourceGroupName", valid_594987
  var valid_594988 = path.getOrDefault("subscriptionId")
  valid_594988 = validateParameter(valid_594988, JString, required = true,
                                 default = nil)
  if valid_594988 != nil:
    section.add "subscriptionId", valid_594988
  var valid_594989 = path.getOrDefault("virtualmachineIndex")
  valid_594989 = validateParameter(valid_594989, JString, required = true,
                                 default = nil)
  if valid_594989 != nil:
    section.add "virtualmachineIndex", valid_594989
  var valid_594990 = path.getOrDefault("networkInterfaceName")
  valid_594990 = validateParameter(valid_594990, JString, required = true,
                                 default = nil)
  if valid_594990 != nil:
    section.add "networkInterfaceName", valid_594990
  var valid_594991 = path.getOrDefault("virtualMachineScaleSetName")
  valid_594991 = validateParameter(valid_594991, JString, required = true,
                                 default = nil)
  if valid_594991 != nil:
    section.add "virtualMachineScaleSetName", valid_594991
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594992 = query.getOrDefault("api-version")
  valid_594992 = validateParameter(valid_594992, JString, required = true,
                                 default = nil)
  if valid_594992 != nil:
    section.add "api-version", valid_594992
  var valid_594993 = query.getOrDefault("$expand")
  valid_594993 = validateParameter(valid_594993, JString, required = false,
                                 default = nil)
  if valid_594993 != nil:
    section.add "$expand", valid_594993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594994: Call_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_594984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Get network interface operation retrieves information about the specified network interface in a virtual machine scale set.
  ## 
  let valid = call_594994.validator(path, query, header, formData, body)
  let scheme = call_594994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594994.url(scheme.get, call_594994.host, call_594994.base,
                         call_594994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594994, url, valid)

proc call*(call_594995: Call_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_594984;
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
  var path_594996 = newJObject()
  var query_594997 = newJObject()
  add(path_594996, "resourceGroupName", newJString(resourceGroupName))
  add(query_594997, "api-version", newJString(apiVersion))
  add(query_594997, "$expand", newJString(Expand))
  add(path_594996, "subscriptionId", newJString(subscriptionId))
  add(path_594996, "virtualmachineIndex", newJString(virtualmachineIndex))
  add(path_594996, "networkInterfaceName", newJString(networkInterfaceName))
  add(path_594996, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  result = call_594995.call(path_594996, query_594997, nil, nil, nil)

var networkInterfacesGetVirtualMachineScaleSetNetworkInterface* = Call_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_594984(
    name: "networkInterfacesGetVirtualMachineScaleSetNetworkInterface",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/virtualMachines/{virtualmachineIndex}/networkInterfaces/{networkInterfaceName}", validator: validate_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_594985,
    base: "", url: url_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_594986,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
