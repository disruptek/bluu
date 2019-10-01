
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: NetworkResourceProviderClient
## version: 2015-05-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The Windows Azure Network management API provides a RESTful set of web services that interact with Windows Azure Networks service to manage your network resources. The API has entities that capture the relationship between an end user and the Windows Azure Networks service.
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

  OpenApiRestCall_567650 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567650](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567650): Option[Scheme] {.used.} =
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
  macServiceName = "network"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ApplicationGatewaysListAll_567872 = ref object of OpenApiRestCall_567650
proc url_ApplicationGatewaysListAll_567874(protocol: Scheme; host: string;
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

proc validate_ApplicationGatewaysListAll_567873(path: JsonNode; query: JsonNode;
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
  var valid_568047 = path.getOrDefault("subscriptionId")
  valid_568047 = validateParameter(valid_568047, JString, required = true,
                                 default = nil)
  if valid_568047 != nil:
    section.add "subscriptionId", valid_568047
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568048 = query.getOrDefault("api-version")
  valid_568048 = validateParameter(valid_568048, JString, required = true,
                                 default = nil)
  if valid_568048 != nil:
    section.add "api-version", valid_568048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568071: Call_ApplicationGatewaysListAll_567872; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List application gateway operation retrieves all the application gateways in a subscription.
  ## 
  let valid = call_568071.validator(path, query, header, formData, body)
  let scheme = call_568071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568071.url(scheme.get, call_568071.host, call_568071.base,
                         call_568071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568071, url, valid)

proc call*(call_568142: Call_ApplicationGatewaysListAll_567872; apiVersion: string;
          subscriptionId: string): Recallable =
  ## applicationGatewaysListAll
  ## The List application gateway operation retrieves all the application gateways in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568143 = newJObject()
  var query_568145 = newJObject()
  add(query_568145, "api-version", newJString(apiVersion))
  add(path_568143, "subscriptionId", newJString(subscriptionId))
  result = call_568142.call(path_568143, query_568145, nil, nil, nil)

var applicationGatewaysListAll* = Call_ApplicationGatewaysListAll_567872(
    name: "applicationGatewaysListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/applicationGateways",
    validator: validate_ApplicationGatewaysListAll_567873, base: "",
    url: url_ApplicationGatewaysListAll_567874, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsListAll_568184 = ref object of OpenApiRestCall_567650
proc url_ExpressRouteCircuitsListAll_568186(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsListAll_568185(path: JsonNode; query: JsonNode;
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
  var valid_568187 = path.getOrDefault("subscriptionId")
  valid_568187 = validateParameter(valid_568187, JString, required = true,
                                 default = nil)
  if valid_568187 != nil:
    section.add "subscriptionId", valid_568187
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568188 = query.getOrDefault("api-version")
  valid_568188 = validateParameter(valid_568188, JString, required = true,
                                 default = nil)
  if valid_568188 != nil:
    section.add "api-version", valid_568188
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568189: Call_ExpressRouteCircuitsListAll_568184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List ExpressRouteCircuit operation retrieves all the ExpressRouteCircuits in a subscription.
  ## 
  let valid = call_568189.validator(path, query, header, formData, body)
  let scheme = call_568189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568189.url(scheme.get, call_568189.host, call_568189.base,
                         call_568189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568189, url, valid)

proc call*(call_568190: Call_ExpressRouteCircuitsListAll_568184;
          apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteCircuitsListAll
  ## The List ExpressRouteCircuit operation retrieves all the ExpressRouteCircuits in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568191 = newJObject()
  var query_568192 = newJObject()
  add(query_568192, "api-version", newJString(apiVersion))
  add(path_568191, "subscriptionId", newJString(subscriptionId))
  result = call_568190.call(path_568191, query_568192, nil, nil, nil)

var expressRouteCircuitsListAll* = Call_ExpressRouteCircuitsListAll_568184(
    name: "expressRouteCircuitsListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/expressRouteCircuits",
    validator: validate_ExpressRouteCircuitsListAll_568185, base: "",
    url: url_ExpressRouteCircuitsListAll_568186, schemes: {Scheme.Https})
type
  Call_ExpressRouteServiceProvidersList_568193 = ref object of OpenApiRestCall_567650
proc url_ExpressRouteServiceProvidersList_568195(protocol: Scheme; host: string;
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

proc validate_ExpressRouteServiceProvidersList_568194(path: JsonNode;
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
  var valid_568196 = path.getOrDefault("subscriptionId")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "subscriptionId", valid_568196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568197 = query.getOrDefault("api-version")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "api-version", valid_568197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568198: Call_ExpressRouteServiceProvidersList_568193;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The List ExpressRouteServiceProvider operation retrieves all the available ExpressRouteServiceProviders.
  ## 
  let valid = call_568198.validator(path, query, header, formData, body)
  let scheme = call_568198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568198.url(scheme.get, call_568198.host, call_568198.base,
                         call_568198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568198, url, valid)

proc call*(call_568199: Call_ExpressRouteServiceProvidersList_568193;
          apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteServiceProvidersList
  ## The List ExpressRouteServiceProvider operation retrieves all the available ExpressRouteServiceProviders.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568200 = newJObject()
  var query_568201 = newJObject()
  add(query_568201, "api-version", newJString(apiVersion))
  add(path_568200, "subscriptionId", newJString(subscriptionId))
  result = call_568199.call(path_568200, query_568201, nil, nil, nil)

var expressRouteServiceProvidersList* = Call_ExpressRouteServiceProvidersList_568193(
    name: "expressRouteServiceProvidersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/expressRouteServiceProviders",
    validator: validate_ExpressRouteServiceProvidersList_568194, base: "",
    url: url_ExpressRouteServiceProvidersList_568195, schemes: {Scheme.Https})
type
  Call_LoadBalancersListAll_568202 = ref object of OpenApiRestCall_567650
proc url_LoadBalancersListAll_568204(protocol: Scheme; host: string; base: string;
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

proc validate_LoadBalancersListAll_568203(path: JsonNode; query: JsonNode;
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
  var valid_568205 = path.getOrDefault("subscriptionId")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "subscriptionId", valid_568205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568206 = query.getOrDefault("api-version")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "api-version", valid_568206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568207: Call_LoadBalancersListAll_568202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List loadBalancer operation retrieves all the load balancers in a subscription.
  ## 
  let valid = call_568207.validator(path, query, header, formData, body)
  let scheme = call_568207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568207.url(scheme.get, call_568207.host, call_568207.base,
                         call_568207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568207, url, valid)

proc call*(call_568208: Call_LoadBalancersListAll_568202; apiVersion: string;
          subscriptionId: string): Recallable =
  ## loadBalancersListAll
  ## The List loadBalancer operation retrieves all the load balancers in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568209 = newJObject()
  var query_568210 = newJObject()
  add(query_568210, "api-version", newJString(apiVersion))
  add(path_568209, "subscriptionId", newJString(subscriptionId))
  result = call_568208.call(path_568209, query_568210, nil, nil, nil)

var loadBalancersListAll* = Call_LoadBalancersListAll_568202(
    name: "loadBalancersListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/loadBalancers",
    validator: validate_LoadBalancersListAll_568203, base: "",
    url: url_LoadBalancersListAll_568204, schemes: {Scheme.Https})
type
  Call_CheckDnsNameAvailability_568211 = ref object of OpenApiRestCall_567650
proc url_CheckDnsNameAvailability_568213(protocol: Scheme; host: string;
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

proc validate_CheckDnsNameAvailability_568212(path: JsonNode; query: JsonNode;
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
  var valid_568214 = path.getOrDefault("subscriptionId")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "subscriptionId", valid_568214
  var valid_568215 = path.getOrDefault("location")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "location", valid_568215
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   domainNameLabel: JString
  ##                  : The domain name to be verified. It must conform to the following regular expression: ^[a-z][a-z0-9-]{1,61}[a-z0-9]$.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568216 = query.getOrDefault("api-version")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "api-version", valid_568216
  var valid_568217 = query.getOrDefault("domainNameLabel")
  valid_568217 = validateParameter(valid_568217, JString, required = false,
                                 default = nil)
  if valid_568217 != nil:
    section.add "domainNameLabel", valid_568217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568218: Call_CheckDnsNameAvailability_568211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether a domain name in the cloudapp.net zone is available for use.
  ## 
  let valid = call_568218.validator(path, query, header, formData, body)
  let scheme = call_568218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568218.url(scheme.get, call_568218.host, call_568218.base,
                         call_568218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568218, url, valid)

proc call*(call_568219: Call_CheckDnsNameAvailability_568211; apiVersion: string;
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
  var path_568220 = newJObject()
  var query_568221 = newJObject()
  add(query_568221, "api-version", newJString(apiVersion))
  add(path_568220, "subscriptionId", newJString(subscriptionId))
  add(query_568221, "domainNameLabel", newJString(domainNameLabel))
  add(path_568220, "location", newJString(location))
  result = call_568219.call(path_568220, query_568221, nil, nil, nil)

var checkDnsNameAvailability* = Call_CheckDnsNameAvailability_568211(
    name: "checkDnsNameAvailability", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/locations/{location}/CheckDnsNameAvailability",
    validator: validate_CheckDnsNameAvailability_568212, base: "",
    url: url_CheckDnsNameAvailability_568213, schemes: {Scheme.Https})
type
  Call_UsagesList_568222 = ref object of OpenApiRestCall_567650
proc url_UsagesList_568224(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UsagesList_568223(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568225 = path.getOrDefault("subscriptionId")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "subscriptionId", valid_568225
  var valid_568226 = path.getOrDefault("location")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "location", valid_568226
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568227 = query.getOrDefault("api-version")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "api-version", valid_568227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568228: Call_UsagesList_568222; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists compute usages for a subscription.
  ## 
  let valid = call_568228.validator(path, query, header, formData, body)
  let scheme = call_568228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568228.url(scheme.get, call_568228.host, call_568228.base,
                         call_568228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568228, url, valid)

proc call*(call_568229: Call_UsagesList_568222; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## usagesList
  ## Lists compute usages for a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location upon which resource usage is queried.
  var path_568230 = newJObject()
  var query_568231 = newJObject()
  add(query_568231, "api-version", newJString(apiVersion))
  add(path_568230, "subscriptionId", newJString(subscriptionId))
  add(path_568230, "location", newJString(location))
  result = call_568229.call(path_568230, query_568231, nil, nil, nil)

var usagesList* = Call_UsagesList_568222(name: "usagesList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/locations/{location}/usages",
                                      validator: validate_UsagesList_568223,
                                      base: "", url: url_UsagesList_568224,
                                      schemes: {Scheme.Https})
type
  Call_NetworkInterfacesListAll_568232 = ref object of OpenApiRestCall_567650
proc url_NetworkInterfacesListAll_568234(protocol: Scheme; host: string;
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

proc validate_NetworkInterfacesListAll_568233(path: JsonNode; query: JsonNode;
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
  var valid_568235 = path.getOrDefault("subscriptionId")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "subscriptionId", valid_568235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568236 = query.getOrDefault("api-version")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "api-version", valid_568236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568237: Call_NetworkInterfacesListAll_568232; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List networkInterfaces operation retrieves all the networkInterfaces in a subscription.
  ## 
  let valid = call_568237.validator(path, query, header, formData, body)
  let scheme = call_568237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568237.url(scheme.get, call_568237.host, call_568237.base,
                         call_568237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568237, url, valid)

proc call*(call_568238: Call_NetworkInterfacesListAll_568232; apiVersion: string;
          subscriptionId: string): Recallable =
  ## networkInterfacesListAll
  ## The List networkInterfaces operation retrieves all the networkInterfaces in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568239 = newJObject()
  var query_568240 = newJObject()
  add(query_568240, "api-version", newJString(apiVersion))
  add(path_568239, "subscriptionId", newJString(subscriptionId))
  result = call_568238.call(path_568239, query_568240, nil, nil, nil)

var networkInterfacesListAll* = Call_NetworkInterfacesListAll_568232(
    name: "networkInterfacesListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/networkInterfaces",
    validator: validate_NetworkInterfacesListAll_568233, base: "",
    url: url_NetworkInterfacesListAll_568234, schemes: {Scheme.Https})
type
  Call_NetworkSecurityGroupsListAll_568241 = ref object of OpenApiRestCall_567650
proc url_NetworkSecurityGroupsListAll_568243(protocol: Scheme; host: string;
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

proc validate_NetworkSecurityGroupsListAll_568242(path: JsonNode; query: JsonNode;
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
  var valid_568244 = path.getOrDefault("subscriptionId")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "subscriptionId", valid_568244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568245 = query.getOrDefault("api-version")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "api-version", valid_568245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568246: Call_NetworkSecurityGroupsListAll_568241; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list NetworkSecurityGroups returns all network security groups in a subscription
  ## 
  let valid = call_568246.validator(path, query, header, formData, body)
  let scheme = call_568246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568246.url(scheme.get, call_568246.host, call_568246.base,
                         call_568246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568246, url, valid)

proc call*(call_568247: Call_NetworkSecurityGroupsListAll_568241;
          apiVersion: string; subscriptionId: string): Recallable =
  ## networkSecurityGroupsListAll
  ## The list NetworkSecurityGroups returns all network security groups in a subscription
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568248 = newJObject()
  var query_568249 = newJObject()
  add(query_568249, "api-version", newJString(apiVersion))
  add(path_568248, "subscriptionId", newJString(subscriptionId))
  result = call_568247.call(path_568248, query_568249, nil, nil, nil)

var networkSecurityGroupsListAll* = Call_NetworkSecurityGroupsListAll_568241(
    name: "networkSecurityGroupsListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/networkSecurityGroups",
    validator: validate_NetworkSecurityGroupsListAll_568242, base: "",
    url: url_NetworkSecurityGroupsListAll_568243, schemes: {Scheme.Https})
type
  Call_PublicIpAddressesListAll_568250 = ref object of OpenApiRestCall_567650
proc url_PublicIpAddressesListAll_568252(protocol: Scheme; host: string;
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

proc validate_PublicIpAddressesListAll_568251(path: JsonNode; query: JsonNode;
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
  var valid_568253 = path.getOrDefault("subscriptionId")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "subscriptionId", valid_568253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568254 = query.getOrDefault("api-version")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "api-version", valid_568254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568255: Call_PublicIpAddressesListAll_568250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List publicIpAddress operation retrieves all the publicIpAddresses in a subscription.
  ## 
  let valid = call_568255.validator(path, query, header, formData, body)
  let scheme = call_568255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568255.url(scheme.get, call_568255.host, call_568255.base,
                         call_568255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568255, url, valid)

proc call*(call_568256: Call_PublicIpAddressesListAll_568250; apiVersion: string;
          subscriptionId: string): Recallable =
  ## publicIpAddressesListAll
  ## The List publicIpAddress operation retrieves all the publicIpAddresses in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568257 = newJObject()
  var query_568258 = newJObject()
  add(query_568258, "api-version", newJString(apiVersion))
  add(path_568257, "subscriptionId", newJString(subscriptionId))
  result = call_568256.call(path_568257, query_568258, nil, nil, nil)

var publicIpAddressesListAll* = Call_PublicIpAddressesListAll_568250(
    name: "publicIpAddressesListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/publicIPAddresses",
    validator: validate_PublicIpAddressesListAll_568251, base: "",
    url: url_PublicIpAddressesListAll_568252, schemes: {Scheme.Https})
type
  Call_RouteTablesListAll_568259 = ref object of OpenApiRestCall_567650
proc url_RouteTablesListAll_568261(protocol: Scheme; host: string; base: string;
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

proc validate_RouteTablesListAll_568260(path: JsonNode; query: JsonNode;
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
  var valid_568262 = path.getOrDefault("subscriptionId")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "subscriptionId", valid_568262
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568263 = query.getOrDefault("api-version")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "api-version", valid_568263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568264: Call_RouteTablesListAll_568259; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list RouteTables returns all route tables in a subscription
  ## 
  let valid = call_568264.validator(path, query, header, formData, body)
  let scheme = call_568264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568264.url(scheme.get, call_568264.host, call_568264.base,
                         call_568264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568264, url, valid)

proc call*(call_568265: Call_RouteTablesListAll_568259; apiVersion: string;
          subscriptionId: string): Recallable =
  ## routeTablesListAll
  ## The list RouteTables returns all route tables in a subscription
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568266 = newJObject()
  var query_568267 = newJObject()
  add(query_568267, "api-version", newJString(apiVersion))
  add(path_568266, "subscriptionId", newJString(subscriptionId))
  result = call_568265.call(path_568266, query_568267, nil, nil, nil)

var routeTablesListAll* = Call_RouteTablesListAll_568259(
    name: "routeTablesListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/routeTables",
    validator: validate_RouteTablesListAll_568260, base: "",
    url: url_RouteTablesListAll_568261, schemes: {Scheme.Https})
type
  Call_VirtualNetworksListAll_568268 = ref object of OpenApiRestCall_567650
proc url_VirtualNetworksListAll_568270(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Network/virtualnetworks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksListAll_568269(path: JsonNode; query: JsonNode;
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
  var valid_568271 = path.getOrDefault("subscriptionId")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "subscriptionId", valid_568271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568272 = query.getOrDefault("api-version")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "api-version", valid_568272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568273: Call_VirtualNetworksListAll_568268; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list VirtualNetwork returns all Virtual Networks in a subscription
  ## 
  let valid = call_568273.validator(path, query, header, formData, body)
  let scheme = call_568273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568273.url(scheme.get, call_568273.host, call_568273.base,
                         call_568273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568273, url, valid)

proc call*(call_568274: Call_VirtualNetworksListAll_568268; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualNetworksListAll
  ## The list VirtualNetwork returns all Virtual Networks in a subscription
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568275 = newJObject()
  var query_568276 = newJObject()
  add(query_568276, "api-version", newJString(apiVersion))
  add(path_568275, "subscriptionId", newJString(subscriptionId))
  result = call_568274.call(path_568275, query_568276, nil, nil, nil)

var virtualNetworksListAll* = Call_VirtualNetworksListAll_568268(
    name: "virtualNetworksListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/virtualnetworks",
    validator: validate_VirtualNetworksListAll_568269, base: "",
    url: url_VirtualNetworksListAll_568270, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysList_568277 = ref object of OpenApiRestCall_567650
proc url_ApplicationGatewaysList_568279(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationGatewaysList_568278(path: JsonNode; query: JsonNode;
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
  var valid_568280 = path.getOrDefault("resourceGroupName")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "resourceGroupName", valid_568280
  var valid_568281 = path.getOrDefault("subscriptionId")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "subscriptionId", valid_568281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568282 = query.getOrDefault("api-version")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "api-version", valid_568282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568283: Call_ApplicationGatewaysList_568277; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List ApplicationGateway operation retrieves all the application gateways in a resource group.
  ## 
  let valid = call_568283.validator(path, query, header, formData, body)
  let scheme = call_568283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568283.url(scheme.get, call_568283.host, call_568283.base,
                         call_568283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568283, url, valid)

proc call*(call_568284: Call_ApplicationGatewaysList_568277;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## applicationGatewaysList
  ## The List ApplicationGateway operation retrieves all the application gateways in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568285 = newJObject()
  var query_568286 = newJObject()
  add(path_568285, "resourceGroupName", newJString(resourceGroupName))
  add(query_568286, "api-version", newJString(apiVersion))
  add(path_568285, "subscriptionId", newJString(subscriptionId))
  result = call_568284.call(path_568285, query_568286, nil, nil, nil)

var applicationGatewaysList* = Call_ApplicationGatewaysList_568277(
    name: "applicationGatewaysList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways",
    validator: validate_ApplicationGatewaysList_568278, base: "",
    url: url_ApplicationGatewaysList_568279, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysCreateOrUpdate_568298 = ref object of OpenApiRestCall_567650
proc url_ApplicationGatewaysCreateOrUpdate_568300(protocol: Scheme; host: string;
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

proc validate_ApplicationGatewaysCreateOrUpdate_568299(path: JsonNode;
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
  var valid_568318 = path.getOrDefault("resourceGroupName")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "resourceGroupName", valid_568318
  var valid_568319 = path.getOrDefault("subscriptionId")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "subscriptionId", valid_568319
  var valid_568320 = path.getOrDefault("applicationGatewayName")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "applicationGatewayName", valid_568320
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/delete ApplicationGateway operation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568323: Call_ApplicationGatewaysCreateOrUpdate_568298;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put ApplicationGateway operation creates/updates a ApplicationGateway
  ## 
  let valid = call_568323.validator(path, query, header, formData, body)
  let scheme = call_568323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568323.url(scheme.get, call_568323.host, call_568323.base,
                         call_568323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568323, url, valid)

proc call*(call_568324: Call_ApplicationGatewaysCreateOrUpdate_568298;
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
  var path_568325 = newJObject()
  var query_568326 = newJObject()
  var body_568327 = newJObject()
  add(path_568325, "resourceGroupName", newJString(resourceGroupName))
  add(query_568326, "api-version", newJString(apiVersion))
  add(path_568325, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568327 = parameters
  add(path_568325, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_568324.call(path_568325, query_568326, nil, nil, body_568327)

var applicationGatewaysCreateOrUpdate* = Call_ApplicationGatewaysCreateOrUpdate_568298(
    name: "applicationGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}",
    validator: validate_ApplicationGatewaysCreateOrUpdate_568299, base: "",
    url: url_ApplicationGatewaysCreateOrUpdate_568300, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysGet_568287 = ref object of OpenApiRestCall_567650
proc url_ApplicationGatewaysGet_568289(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationGatewaysGet_568288(path: JsonNode; query: JsonNode;
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
  var valid_568290 = path.getOrDefault("resourceGroupName")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "resourceGroupName", valid_568290
  var valid_568291 = path.getOrDefault("subscriptionId")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "subscriptionId", valid_568291
  var valid_568292 = path.getOrDefault("applicationGatewayName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "applicationGatewayName", valid_568292
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_568294: Call_ApplicationGatewaysGet_568287; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get application gateway operation retrieves information about the specified application gateway.
  ## 
  let valid = call_568294.validator(path, query, header, formData, body)
  let scheme = call_568294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568294.url(scheme.get, call_568294.host, call_568294.base,
                         call_568294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568294, url, valid)

proc call*(call_568295: Call_ApplicationGatewaysGet_568287;
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
  var path_568296 = newJObject()
  var query_568297 = newJObject()
  add(path_568296, "resourceGroupName", newJString(resourceGroupName))
  add(query_568297, "api-version", newJString(apiVersion))
  add(path_568296, "subscriptionId", newJString(subscriptionId))
  add(path_568296, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_568295.call(path_568296, query_568297, nil, nil, nil)

var applicationGatewaysGet* = Call_ApplicationGatewaysGet_568287(
    name: "applicationGatewaysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}",
    validator: validate_ApplicationGatewaysGet_568288, base: "",
    url: url_ApplicationGatewaysGet_568289, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysDelete_568328 = ref object of OpenApiRestCall_567650
proc url_ApplicationGatewaysDelete_568330(protocol: Scheme; host: string;
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

proc validate_ApplicationGatewaysDelete_568329(path: JsonNode; query: JsonNode;
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
  var valid_568331 = path.getOrDefault("resourceGroupName")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "resourceGroupName", valid_568331
  var valid_568332 = path.getOrDefault("subscriptionId")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "subscriptionId", valid_568332
  var valid_568333 = path.getOrDefault("applicationGatewayName")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "applicationGatewayName", valid_568333
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568334 = query.getOrDefault("api-version")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "api-version", valid_568334
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568335: Call_ApplicationGatewaysDelete_568328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete application gateway operation deletes the specified application gateway.
  ## 
  let valid = call_568335.validator(path, query, header, formData, body)
  let scheme = call_568335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568335.url(scheme.get, call_568335.host, call_568335.base,
                         call_568335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568335, url, valid)

proc call*(call_568336: Call_ApplicationGatewaysDelete_568328;
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
  var path_568337 = newJObject()
  var query_568338 = newJObject()
  add(path_568337, "resourceGroupName", newJString(resourceGroupName))
  add(query_568338, "api-version", newJString(apiVersion))
  add(path_568337, "subscriptionId", newJString(subscriptionId))
  add(path_568337, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_568336.call(path_568337, query_568338, nil, nil, nil)

var applicationGatewaysDelete* = Call_ApplicationGatewaysDelete_568328(
    name: "applicationGatewaysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}",
    validator: validate_ApplicationGatewaysDelete_568329, base: "",
    url: url_ApplicationGatewaysDelete_568330, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysStart_568339 = ref object of OpenApiRestCall_567650
proc url_ApplicationGatewaysStart_568341(protocol: Scheme; host: string;
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

proc validate_ApplicationGatewaysStart_568340(path: JsonNode; query: JsonNode;
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
  var valid_568342 = path.getOrDefault("resourceGroupName")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "resourceGroupName", valid_568342
  var valid_568343 = path.getOrDefault("subscriptionId")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "subscriptionId", valid_568343
  var valid_568344 = path.getOrDefault("applicationGatewayName")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "applicationGatewayName", valid_568344
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568345 = query.getOrDefault("api-version")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "api-version", valid_568345
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568346: Call_ApplicationGatewaysStart_568339; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Start ApplicationGateway operation starts application gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_568346.validator(path, query, header, formData, body)
  let scheme = call_568346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568346.url(scheme.get, call_568346.host, call_568346.base,
                         call_568346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568346, url, valid)

proc call*(call_568347: Call_ApplicationGatewaysStart_568339;
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
  var path_568348 = newJObject()
  var query_568349 = newJObject()
  add(path_568348, "resourceGroupName", newJString(resourceGroupName))
  add(query_568349, "api-version", newJString(apiVersion))
  add(path_568348, "subscriptionId", newJString(subscriptionId))
  add(path_568348, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_568347.call(path_568348, query_568349, nil, nil, nil)

var applicationGatewaysStart* = Call_ApplicationGatewaysStart_568339(
    name: "applicationGatewaysStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}/start",
    validator: validate_ApplicationGatewaysStart_568340, base: "",
    url: url_ApplicationGatewaysStart_568341, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysStop_568350 = ref object of OpenApiRestCall_567650
proc url_ApplicationGatewaysStop_568352(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationGatewaysStop_568351(path: JsonNode; query: JsonNode;
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
  var valid_568353 = path.getOrDefault("resourceGroupName")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "resourceGroupName", valid_568353
  var valid_568354 = path.getOrDefault("subscriptionId")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "subscriptionId", valid_568354
  var valid_568355 = path.getOrDefault("applicationGatewayName")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "applicationGatewayName", valid_568355
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_568357: Call_ApplicationGatewaysStop_568350; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The STOP ApplicationGateway operation stops application gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_568357.validator(path, query, header, formData, body)
  let scheme = call_568357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568357.url(scheme.get, call_568357.host, call_568357.base,
                         call_568357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568357, url, valid)

proc call*(call_568358: Call_ApplicationGatewaysStop_568350;
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
  var path_568359 = newJObject()
  var query_568360 = newJObject()
  add(path_568359, "resourceGroupName", newJString(resourceGroupName))
  add(query_568360, "api-version", newJString(apiVersion))
  add(path_568359, "subscriptionId", newJString(subscriptionId))
  add(path_568359, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_568358.call(path_568359, query_568360, nil, nil, nil)

var applicationGatewaysStop* = Call_ApplicationGatewaysStop_568350(
    name: "applicationGatewaysStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}/stop",
    validator: validate_ApplicationGatewaysStop_568351, base: "",
    url: url_ApplicationGatewaysStop_568352, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsList_568361 = ref object of OpenApiRestCall_567650
proc url_VirtualNetworkGatewayConnectionsList_568363(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsList_568362(path: JsonNode;
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
  var valid_568364 = path.getOrDefault("resourceGroupName")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "resourceGroupName", valid_568364
  var valid_568365 = path.getOrDefault("subscriptionId")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "subscriptionId", valid_568365
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568366 = query.getOrDefault("api-version")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "api-version", valid_568366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568367: Call_VirtualNetworkGatewayConnectionsList_568361;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The List VirtualNetworkGatewayConnections operation retrieves all the virtual network gateways connections created.
  ## 
  let valid = call_568367.validator(path, query, header, formData, body)
  let scheme = call_568367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568367.url(scheme.get, call_568367.host, call_568367.base,
                         call_568367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568367, url, valid)

proc call*(call_568368: Call_VirtualNetworkGatewayConnectionsList_568361;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualNetworkGatewayConnectionsList
  ## The List VirtualNetworkGatewayConnections operation retrieves all the virtual network gateways connections created.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568369 = newJObject()
  var query_568370 = newJObject()
  add(path_568369, "resourceGroupName", newJString(resourceGroupName))
  add(query_568370, "api-version", newJString(apiVersion))
  add(path_568369, "subscriptionId", newJString(subscriptionId))
  result = call_568368.call(path_568369, query_568370, nil, nil, nil)

var virtualNetworkGatewayConnectionsList* = Call_VirtualNetworkGatewayConnectionsList_568361(
    name: "virtualNetworkGatewayConnectionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections",
    validator: validate_VirtualNetworkGatewayConnectionsList_568362, base: "",
    url: url_VirtualNetworkGatewayConnectionsList_568363, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_568382 = ref object of OpenApiRestCall_567650
proc url_VirtualNetworkGatewayConnectionsCreateOrUpdate_568384(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsCreateOrUpdate_568383(
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
  var valid_568385 = path.getOrDefault("resourceGroupName")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "resourceGroupName", valid_568385
  var valid_568386 = path.getOrDefault("subscriptionId")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "subscriptionId", valid_568386
  var valid_568387 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_568387
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568388 = query.getOrDefault("api-version")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "api-version", valid_568388
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

proc call*(call_568390: Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_568382;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put VirtualNetworkGatewayConnection operation creates/updates a virtual network gateway connection in the specified resource group through Network resource provider.
  ## 
  let valid = call_568390.validator(path, query, header, formData, body)
  let scheme = call_568390.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568390.url(scheme.get, call_568390.host, call_568390.base,
                         call_568390.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568390, url, valid)

proc call*(call_568391: Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_568382;
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
  var path_568392 = newJObject()
  var query_568393 = newJObject()
  var body_568394 = newJObject()
  add(path_568392, "resourceGroupName", newJString(resourceGroupName))
  add(query_568393, "api-version", newJString(apiVersion))
  add(path_568392, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568394 = parameters
  add(path_568392, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_568391.call(path_568392, query_568393, nil, nil, body_568394)

var virtualNetworkGatewayConnectionsCreateOrUpdate* = Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_568382(
    name: "virtualNetworkGatewayConnectionsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}",
    validator: validate_VirtualNetworkGatewayConnectionsCreateOrUpdate_568383,
    base: "", url: url_VirtualNetworkGatewayConnectionsCreateOrUpdate_568384,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsGet_568371 = ref object of OpenApiRestCall_567650
proc url_VirtualNetworkGatewayConnectionsGet_568373(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGatewayConnectionsGet_568372(path: JsonNode;
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
  var valid_568374 = path.getOrDefault("resourceGroupName")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "resourceGroupName", valid_568374
  var valid_568375 = path.getOrDefault("subscriptionId")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "subscriptionId", valid_568375
  var valid_568376 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_568376
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568377 = query.getOrDefault("api-version")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "api-version", valid_568377
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568378: Call_VirtualNetworkGatewayConnectionsGet_568371;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Get VirtualNetworkGatewayConnection operation retrieves information about the specified virtual network gateway connection through Network resource provider.
  ## 
  let valid = call_568378.validator(path, query, header, formData, body)
  let scheme = call_568378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568378.url(scheme.get, call_568378.host, call_568378.base,
                         call_568378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568378, url, valid)

proc call*(call_568379: Call_VirtualNetworkGatewayConnectionsGet_568371;
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
  var path_568380 = newJObject()
  var query_568381 = newJObject()
  add(path_568380, "resourceGroupName", newJString(resourceGroupName))
  add(query_568381, "api-version", newJString(apiVersion))
  add(path_568380, "subscriptionId", newJString(subscriptionId))
  add(path_568380, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_568379.call(path_568380, query_568381, nil, nil, nil)

var virtualNetworkGatewayConnectionsGet* = Call_VirtualNetworkGatewayConnectionsGet_568371(
    name: "virtualNetworkGatewayConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}",
    validator: validate_VirtualNetworkGatewayConnectionsGet_568372, base: "",
    url: url_VirtualNetworkGatewayConnectionsGet_568373, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsDelete_568395 = ref object of OpenApiRestCall_567650
proc url_VirtualNetworkGatewayConnectionsDelete_568397(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewayConnectionsDelete_568396(path: JsonNode;
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
  var valid_568398 = path.getOrDefault("resourceGroupName")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "resourceGroupName", valid_568398
  var valid_568399 = path.getOrDefault("subscriptionId")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "subscriptionId", valid_568399
  var valid_568400 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_568400
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568401 = query.getOrDefault("api-version")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "api-version", valid_568401
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568402: Call_VirtualNetworkGatewayConnectionsDelete_568395;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Delete VirtualNetworkGatewayConnection operation deletes the specified virtual network Gateway connection through Network resource provider.
  ## 
  let valid = call_568402.validator(path, query, header, formData, body)
  let scheme = call_568402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568402.url(scheme.get, call_568402.host, call_568402.base,
                         call_568402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568402, url, valid)

proc call*(call_568403: Call_VirtualNetworkGatewayConnectionsDelete_568395;
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
  var path_568404 = newJObject()
  var query_568405 = newJObject()
  add(path_568404, "resourceGroupName", newJString(resourceGroupName))
  add(query_568405, "api-version", newJString(apiVersion))
  add(path_568404, "subscriptionId", newJString(subscriptionId))
  add(path_568404, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_568403.call(path_568404, query_568405, nil, nil, nil)

var virtualNetworkGatewayConnectionsDelete* = Call_VirtualNetworkGatewayConnectionsDelete_568395(
    name: "virtualNetworkGatewayConnectionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/",
    validator: validate_VirtualNetworkGatewayConnectionsDelete_568396, base: "",
    url: url_VirtualNetworkGatewayConnectionsDelete_568397,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsSetSharedKey_568417 = ref object of OpenApiRestCall_567650
proc url_VirtualNetworkGatewayConnectionsSetSharedKey_568419(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsSetSharedKey_568418(path: JsonNode;
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
  var valid_568420 = path.getOrDefault("resourceGroupName")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "resourceGroupName", valid_568420
  var valid_568421 = path.getOrDefault("subscriptionId")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "subscriptionId", valid_568421
  var valid_568422 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_568422
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568423 = query.getOrDefault("api-version")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "api-version", valid_568423
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

proc call*(call_568425: Call_VirtualNetworkGatewayConnectionsSetSharedKey_568417;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put VirtualNetworkGatewayConnectionSharedKey operation sets the virtual network gateway connection shared key for passed virtual network gateway connection in the specified resource group through Network resource provider.
  ## 
  let valid = call_568425.validator(path, query, header, formData, body)
  let scheme = call_568425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568425.url(scheme.get, call_568425.host, call_568425.base,
                         call_568425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568425, url, valid)

proc call*(call_568426: Call_VirtualNetworkGatewayConnectionsSetSharedKey_568417;
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
  var path_568427 = newJObject()
  var query_568428 = newJObject()
  var body_568429 = newJObject()
  add(path_568427, "resourceGroupName", newJString(resourceGroupName))
  add(query_568428, "api-version", newJString(apiVersion))
  add(path_568427, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568429 = parameters
  add(path_568427, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_568426.call(path_568427, query_568428, nil, nil, body_568429)

var virtualNetworkGatewayConnectionsSetSharedKey* = Call_VirtualNetworkGatewayConnectionsSetSharedKey_568417(
    name: "virtualNetworkGatewayConnectionsSetSharedKey",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/sharedkey",
    validator: validate_VirtualNetworkGatewayConnectionsSetSharedKey_568418,
    base: "", url: url_VirtualNetworkGatewayConnectionsSetSharedKey_568419,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsGetSharedKey_568406 = ref object of OpenApiRestCall_567650
proc url_VirtualNetworkGatewayConnectionsGetSharedKey_568408(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsGetSharedKey_568407(path: JsonNode;
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
  var valid_568409 = path.getOrDefault("resourceGroupName")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "resourceGroupName", valid_568409
  var valid_568410 = path.getOrDefault("subscriptionId")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "subscriptionId", valid_568410
  var valid_568411 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_568411
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568412 = query.getOrDefault("api-version")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "api-version", valid_568412
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568413: Call_VirtualNetworkGatewayConnectionsGetSharedKey_568406;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Get VirtualNetworkGatewayConnectionSharedKey operation retrieves information about the specified virtual network gateway connection shared key through Network resource provider.
  ## 
  let valid = call_568413.validator(path, query, header, formData, body)
  let scheme = call_568413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568413.url(scheme.get, call_568413.host, call_568413.base,
                         call_568413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568413, url, valid)

proc call*(call_568414: Call_VirtualNetworkGatewayConnectionsGetSharedKey_568406;
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
  var path_568415 = newJObject()
  var query_568416 = newJObject()
  add(path_568415, "resourceGroupName", newJString(resourceGroupName))
  add(query_568416, "api-version", newJString(apiVersion))
  add(path_568415, "subscriptionId", newJString(subscriptionId))
  add(path_568415, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_568414.call(path_568415, query_568416, nil, nil, nil)

var virtualNetworkGatewayConnectionsGetSharedKey* = Call_VirtualNetworkGatewayConnectionsGetSharedKey_568406(
    name: "virtualNetworkGatewayConnectionsGetSharedKey",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/sharedkey",
    validator: validate_VirtualNetworkGatewayConnectionsGetSharedKey_568407,
    base: "", url: url_VirtualNetworkGatewayConnectionsGetSharedKey_568408,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsResetSharedKey_568430 = ref object of OpenApiRestCall_567650
proc url_VirtualNetworkGatewayConnectionsResetSharedKey_568432(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsResetSharedKey_568431(
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
  var valid_568433 = path.getOrDefault("resourceGroupName")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "resourceGroupName", valid_568433
  var valid_568434 = path.getOrDefault("subscriptionId")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "subscriptionId", valid_568434
  var valid_568435 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_568435
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568436 = query.getOrDefault("api-version")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "api-version", valid_568436
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

proc call*(call_568438: Call_VirtualNetworkGatewayConnectionsResetSharedKey_568430;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The VirtualNetworkGatewayConnectionResetSharedKey operation resets the virtual network gateway connection shared key for passed virtual network gateway connection in the specified resource group through Network resource provider.
  ## 
  let valid = call_568438.validator(path, query, header, formData, body)
  let scheme = call_568438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568438.url(scheme.get, call_568438.host, call_568438.base,
                         call_568438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568438, url, valid)

proc call*(call_568439: Call_VirtualNetworkGatewayConnectionsResetSharedKey_568430;
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
  var path_568440 = newJObject()
  var query_568441 = newJObject()
  var body_568442 = newJObject()
  add(path_568440, "resourceGroupName", newJString(resourceGroupName))
  add(query_568441, "api-version", newJString(apiVersion))
  add(path_568440, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568442 = parameters
  add(path_568440, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_568439.call(path_568440, query_568441, nil, nil, body_568442)

var virtualNetworkGatewayConnectionsResetSharedKey* = Call_VirtualNetworkGatewayConnectionsResetSharedKey_568430(
    name: "virtualNetworkGatewayConnectionsResetSharedKey",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/sharedkey/reset",
    validator: validate_VirtualNetworkGatewayConnectionsResetSharedKey_568431,
    base: "", url: url_VirtualNetworkGatewayConnectionsResetSharedKey_568432,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsList_568443 = ref object of OpenApiRestCall_567650
proc url_ExpressRouteCircuitsList_568445(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsList_568444(path: JsonNode; query: JsonNode;
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
  var valid_568446 = path.getOrDefault("resourceGroupName")
  valid_568446 = validateParameter(valid_568446, JString, required = true,
                                 default = nil)
  if valid_568446 != nil:
    section.add "resourceGroupName", valid_568446
  var valid_568447 = path.getOrDefault("subscriptionId")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = nil)
  if valid_568447 != nil:
    section.add "subscriptionId", valid_568447
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568448 = query.getOrDefault("api-version")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "api-version", valid_568448
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568449: Call_ExpressRouteCircuitsList_568443; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List ExpressRouteCircuit operation retrieves all the ExpressRouteCircuits in a resource group.
  ## 
  let valid = call_568449.validator(path, query, header, formData, body)
  let scheme = call_568449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568449.url(scheme.get, call_568449.host, call_568449.base,
                         call_568449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568449, url, valid)

proc call*(call_568450: Call_ExpressRouteCircuitsList_568443;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteCircuitsList
  ## The List ExpressRouteCircuit operation retrieves all the ExpressRouteCircuits in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568451 = newJObject()
  var query_568452 = newJObject()
  add(path_568451, "resourceGroupName", newJString(resourceGroupName))
  add(query_568452, "api-version", newJString(apiVersion))
  add(path_568451, "subscriptionId", newJString(subscriptionId))
  result = call_568450.call(path_568451, query_568452, nil, nil, nil)

var expressRouteCircuitsList* = Call_ExpressRouteCircuitsList_568443(
    name: "expressRouteCircuitsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits",
    validator: validate_ExpressRouteCircuitsList_568444, base: "",
    url: url_ExpressRouteCircuitsList_568445, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsCreateOrUpdate_568464 = ref object of OpenApiRestCall_567650
proc url_ExpressRouteCircuitsCreateOrUpdate_568466(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCircuitsCreateOrUpdate_568465(path: JsonNode;
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
  var valid_568467 = path.getOrDefault("circuitName")
  valid_568467 = validateParameter(valid_568467, JString, required = true,
                                 default = nil)
  if valid_568467 != nil:
    section.add "circuitName", valid_568467
  var valid_568468 = path.getOrDefault("resourceGroupName")
  valid_568468 = validateParameter(valid_568468, JString, required = true,
                                 default = nil)
  if valid_568468 != nil:
    section.add "resourceGroupName", valid_568468
  var valid_568469 = path.getOrDefault("subscriptionId")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "subscriptionId", valid_568469
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568470 = query.getOrDefault("api-version")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = nil)
  if valid_568470 != nil:
    section.add "api-version", valid_568470
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

proc call*(call_568472: Call_ExpressRouteCircuitsCreateOrUpdate_568464;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put ExpressRouteCircuit operation creates/updates a ExpressRouteCircuit
  ## 
  let valid = call_568472.validator(path, query, header, formData, body)
  let scheme = call_568472.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568472.url(scheme.get, call_568472.host, call_568472.base,
                         call_568472.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568472, url, valid)

proc call*(call_568473: Call_ExpressRouteCircuitsCreateOrUpdate_568464;
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
  var path_568474 = newJObject()
  var query_568475 = newJObject()
  var body_568476 = newJObject()
  add(path_568474, "circuitName", newJString(circuitName))
  add(path_568474, "resourceGroupName", newJString(resourceGroupName))
  add(query_568475, "api-version", newJString(apiVersion))
  add(path_568474, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568476 = parameters
  result = call_568473.call(path_568474, query_568475, nil, nil, body_568476)

var expressRouteCircuitsCreateOrUpdate* = Call_ExpressRouteCircuitsCreateOrUpdate_568464(
    name: "expressRouteCircuitsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/",
    validator: validate_ExpressRouteCircuitsCreateOrUpdate_568465, base: "",
    url: url_ExpressRouteCircuitsCreateOrUpdate_568466, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsGet_568453 = ref object of OpenApiRestCall_567650
proc url_ExpressRouteCircuitsGet_568455(protocol: Scheme; host: string; base: string;
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
               (kind: VariableSegment, value: "circuitName"),
               (kind: ConstantSegment, value: "/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCircuitsGet_568454(path: JsonNode; query: JsonNode;
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
  var valid_568456 = path.getOrDefault("circuitName")
  valid_568456 = validateParameter(valid_568456, JString, required = true,
                                 default = nil)
  if valid_568456 != nil:
    section.add "circuitName", valid_568456
  var valid_568457 = path.getOrDefault("resourceGroupName")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = nil)
  if valid_568457 != nil:
    section.add "resourceGroupName", valid_568457
  var valid_568458 = path.getOrDefault("subscriptionId")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "subscriptionId", valid_568458
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568459 = query.getOrDefault("api-version")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "api-version", valid_568459
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568460: Call_ExpressRouteCircuitsGet_568453; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get ExpressRouteCircuit operation retrieves information about the specified ExpressRouteCircuit.
  ## 
  let valid = call_568460.validator(path, query, header, formData, body)
  let scheme = call_568460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568460.url(scheme.get, call_568460.host, call_568460.base,
                         call_568460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568460, url, valid)

proc call*(call_568461: Call_ExpressRouteCircuitsGet_568453; circuitName: string;
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
  var path_568462 = newJObject()
  var query_568463 = newJObject()
  add(path_568462, "circuitName", newJString(circuitName))
  add(path_568462, "resourceGroupName", newJString(resourceGroupName))
  add(query_568463, "api-version", newJString(apiVersion))
  add(path_568462, "subscriptionId", newJString(subscriptionId))
  result = call_568461.call(path_568462, query_568463, nil, nil, nil)

var expressRouteCircuitsGet* = Call_ExpressRouteCircuitsGet_568453(
    name: "expressRouteCircuitsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/",
    validator: validate_ExpressRouteCircuitsGet_568454, base: "",
    url: url_ExpressRouteCircuitsGet_568455, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsDelete_568477 = ref object of OpenApiRestCall_567650
proc url_ExpressRouteCircuitsDelete_568479(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCircuitsDelete_568478(path: JsonNode; query: JsonNode;
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
  var valid_568480 = path.getOrDefault("circuitName")
  valid_568480 = validateParameter(valid_568480, JString, required = true,
                                 default = nil)
  if valid_568480 != nil:
    section.add "circuitName", valid_568480
  var valid_568481 = path.getOrDefault("resourceGroupName")
  valid_568481 = validateParameter(valid_568481, JString, required = true,
                                 default = nil)
  if valid_568481 != nil:
    section.add "resourceGroupName", valid_568481
  var valid_568482 = path.getOrDefault("subscriptionId")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = nil)
  if valid_568482 != nil:
    section.add "subscriptionId", valid_568482
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568483 = query.getOrDefault("api-version")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = nil)
  if valid_568483 != nil:
    section.add "api-version", valid_568483
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568484: Call_ExpressRouteCircuitsDelete_568477; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete ExpressRouteCircuit operation deletes the specified ExpressRouteCircuit.
  ## 
  let valid = call_568484.validator(path, query, header, formData, body)
  let scheme = call_568484.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568484.url(scheme.get, call_568484.host, call_568484.base,
                         call_568484.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568484, url, valid)

proc call*(call_568485: Call_ExpressRouteCircuitsDelete_568477;
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
  var path_568486 = newJObject()
  var query_568487 = newJObject()
  add(path_568486, "circuitName", newJString(circuitName))
  add(path_568486, "resourceGroupName", newJString(resourceGroupName))
  add(query_568487, "api-version", newJString(apiVersion))
  add(path_568486, "subscriptionId", newJString(subscriptionId))
  result = call_568485.call(path_568486, query_568487, nil, nil, nil)

var expressRouteCircuitsDelete* = Call_ExpressRouteCircuitsDelete_568477(
    name: "expressRouteCircuitsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/",
    validator: validate_ExpressRouteCircuitsDelete_568478, base: "",
    url: url_ExpressRouteCircuitsDelete_568479, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsList_568488 = ref object of OpenApiRestCall_567650
proc url_ExpressRouteCircuitAuthorizationsList_568490(protocol: Scheme;
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

proc validate_ExpressRouteCircuitAuthorizationsList_568489(path: JsonNode;
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
  var valid_568491 = path.getOrDefault("circuitName")
  valid_568491 = validateParameter(valid_568491, JString, required = true,
                                 default = nil)
  if valid_568491 != nil:
    section.add "circuitName", valid_568491
  var valid_568492 = path.getOrDefault("resourceGroupName")
  valid_568492 = validateParameter(valid_568492, JString, required = true,
                                 default = nil)
  if valid_568492 != nil:
    section.add "resourceGroupName", valid_568492
  var valid_568493 = path.getOrDefault("subscriptionId")
  valid_568493 = validateParameter(valid_568493, JString, required = true,
                                 default = nil)
  if valid_568493 != nil:
    section.add "subscriptionId", valid_568493
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568494 = query.getOrDefault("api-version")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = nil)
  if valid_568494 != nil:
    section.add "api-version", valid_568494
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568495: Call_ExpressRouteCircuitAuthorizationsList_568488;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The List authorization operation retrieves all the authorizations in an ExpressRouteCircuit.
  ## 
  let valid = call_568495.validator(path, query, header, formData, body)
  let scheme = call_568495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568495.url(scheme.get, call_568495.host, call_568495.base,
                         call_568495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568495, url, valid)

proc call*(call_568496: Call_ExpressRouteCircuitAuthorizationsList_568488;
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
  var path_568497 = newJObject()
  var query_568498 = newJObject()
  add(path_568497, "circuitName", newJString(circuitName))
  add(path_568497, "resourceGroupName", newJString(resourceGroupName))
  add(query_568498, "api-version", newJString(apiVersion))
  add(path_568497, "subscriptionId", newJString(subscriptionId))
  result = call_568496.call(path_568497, query_568498, nil, nil, nil)

var expressRouteCircuitAuthorizationsList* = Call_ExpressRouteCircuitAuthorizationsList_568488(
    name: "expressRouteCircuitAuthorizationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations",
    validator: validate_ExpressRouteCircuitAuthorizationsList_568489, base: "",
    url: url_ExpressRouteCircuitAuthorizationsList_568490, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_568511 = ref object of OpenApiRestCall_567650
proc url_ExpressRouteCircuitAuthorizationsCreateOrUpdate_568513(protocol: Scheme;
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

proc validate_ExpressRouteCircuitAuthorizationsCreateOrUpdate_568512(
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
  var valid_568514 = path.getOrDefault("circuitName")
  valid_568514 = validateParameter(valid_568514, JString, required = true,
                                 default = nil)
  if valid_568514 != nil:
    section.add "circuitName", valid_568514
  var valid_568515 = path.getOrDefault("resourceGroupName")
  valid_568515 = validateParameter(valid_568515, JString, required = true,
                                 default = nil)
  if valid_568515 != nil:
    section.add "resourceGroupName", valid_568515
  var valid_568516 = path.getOrDefault("subscriptionId")
  valid_568516 = validateParameter(valid_568516, JString, required = true,
                                 default = nil)
  if valid_568516 != nil:
    section.add "subscriptionId", valid_568516
  var valid_568517 = path.getOrDefault("authorizationName")
  valid_568517 = validateParameter(valid_568517, JString, required = true,
                                 default = nil)
  if valid_568517 != nil:
    section.add "authorizationName", valid_568517
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568518 = query.getOrDefault("api-version")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "api-version", valid_568518
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

proc call*(call_568520: Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_568511;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put Authorization operation creates/updates an authorization in the specified ExpressRouteCircuits
  ## 
  let valid = call_568520.validator(path, query, header, formData, body)
  let scheme = call_568520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568520.url(scheme.get, call_568520.host, call_568520.base,
                         call_568520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568520, url, valid)

proc call*(call_568521: Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_568511;
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
  var path_568522 = newJObject()
  var query_568523 = newJObject()
  var body_568524 = newJObject()
  add(path_568522, "circuitName", newJString(circuitName))
  add(path_568522, "resourceGroupName", newJString(resourceGroupName))
  add(query_568523, "api-version", newJString(apiVersion))
  add(path_568522, "subscriptionId", newJString(subscriptionId))
  if authorizationParameters != nil:
    body_568524 = authorizationParameters
  add(path_568522, "authorizationName", newJString(authorizationName))
  result = call_568521.call(path_568522, query_568523, nil, nil, body_568524)

var expressRouteCircuitAuthorizationsCreateOrUpdate* = Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_568511(
    name: "expressRouteCircuitAuthorizationsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations/{authorizationName}",
    validator: validate_ExpressRouteCircuitAuthorizationsCreateOrUpdate_568512,
    base: "", url: url_ExpressRouteCircuitAuthorizationsCreateOrUpdate_568513,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsGet_568499 = ref object of OpenApiRestCall_567650
proc url_ExpressRouteCircuitAuthorizationsGet_568501(protocol: Scheme;
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

proc validate_ExpressRouteCircuitAuthorizationsGet_568500(path: JsonNode;
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
  var valid_568502 = path.getOrDefault("circuitName")
  valid_568502 = validateParameter(valid_568502, JString, required = true,
                                 default = nil)
  if valid_568502 != nil:
    section.add "circuitName", valid_568502
  var valid_568503 = path.getOrDefault("resourceGroupName")
  valid_568503 = validateParameter(valid_568503, JString, required = true,
                                 default = nil)
  if valid_568503 != nil:
    section.add "resourceGroupName", valid_568503
  var valid_568504 = path.getOrDefault("subscriptionId")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "subscriptionId", valid_568504
  var valid_568505 = path.getOrDefault("authorizationName")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "authorizationName", valid_568505
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568506 = query.getOrDefault("api-version")
  valid_568506 = validateParameter(valid_568506, JString, required = true,
                                 default = nil)
  if valid_568506 != nil:
    section.add "api-version", valid_568506
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568507: Call_ExpressRouteCircuitAuthorizationsGet_568499;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The GET authorization operation retrieves the specified authorization from the specified ExpressRouteCircuit.
  ## 
  let valid = call_568507.validator(path, query, header, formData, body)
  let scheme = call_568507.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568507.url(scheme.get, call_568507.host, call_568507.base,
                         call_568507.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568507, url, valid)

proc call*(call_568508: Call_ExpressRouteCircuitAuthorizationsGet_568499;
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
  var path_568509 = newJObject()
  var query_568510 = newJObject()
  add(path_568509, "circuitName", newJString(circuitName))
  add(path_568509, "resourceGroupName", newJString(resourceGroupName))
  add(query_568510, "api-version", newJString(apiVersion))
  add(path_568509, "subscriptionId", newJString(subscriptionId))
  add(path_568509, "authorizationName", newJString(authorizationName))
  result = call_568508.call(path_568509, query_568510, nil, nil, nil)

var expressRouteCircuitAuthorizationsGet* = Call_ExpressRouteCircuitAuthorizationsGet_568499(
    name: "expressRouteCircuitAuthorizationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations/{authorizationName}",
    validator: validate_ExpressRouteCircuitAuthorizationsGet_568500, base: "",
    url: url_ExpressRouteCircuitAuthorizationsGet_568501, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsDelete_568525 = ref object of OpenApiRestCall_567650
proc url_ExpressRouteCircuitAuthorizationsDelete_568527(protocol: Scheme;
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

proc validate_ExpressRouteCircuitAuthorizationsDelete_568526(path: JsonNode;
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
  var valid_568528 = path.getOrDefault("circuitName")
  valid_568528 = validateParameter(valid_568528, JString, required = true,
                                 default = nil)
  if valid_568528 != nil:
    section.add "circuitName", valid_568528
  var valid_568529 = path.getOrDefault("resourceGroupName")
  valid_568529 = validateParameter(valid_568529, JString, required = true,
                                 default = nil)
  if valid_568529 != nil:
    section.add "resourceGroupName", valid_568529
  var valid_568530 = path.getOrDefault("subscriptionId")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "subscriptionId", valid_568530
  var valid_568531 = path.getOrDefault("authorizationName")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "authorizationName", valid_568531
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568532 = query.getOrDefault("api-version")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "api-version", valid_568532
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568533: Call_ExpressRouteCircuitAuthorizationsDelete_568525;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The delete authorization operation deletes the specified authorization from the specified ExpressRouteCircuit.
  ## 
  let valid = call_568533.validator(path, query, header, formData, body)
  let scheme = call_568533.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568533.url(scheme.get, call_568533.host, call_568533.base,
                         call_568533.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568533, url, valid)

proc call*(call_568534: Call_ExpressRouteCircuitAuthorizationsDelete_568525;
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
  var path_568535 = newJObject()
  var query_568536 = newJObject()
  add(path_568535, "circuitName", newJString(circuitName))
  add(path_568535, "resourceGroupName", newJString(resourceGroupName))
  add(query_568536, "api-version", newJString(apiVersion))
  add(path_568535, "subscriptionId", newJString(subscriptionId))
  add(path_568535, "authorizationName", newJString(authorizationName))
  result = call_568534.call(path_568535, query_568536, nil, nil, nil)

var expressRouteCircuitAuthorizationsDelete* = Call_ExpressRouteCircuitAuthorizationsDelete_568525(
    name: "expressRouteCircuitAuthorizationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations/{authorizationName}",
    validator: validate_ExpressRouteCircuitAuthorizationsDelete_568526, base: "",
    url: url_ExpressRouteCircuitAuthorizationsDelete_568527,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsList_568537 = ref object of OpenApiRestCall_567650
proc url_ExpressRouteCircuitPeeringsList_568539(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitPeeringsList_568538(path: JsonNode;
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
  var valid_568540 = path.getOrDefault("circuitName")
  valid_568540 = validateParameter(valid_568540, JString, required = true,
                                 default = nil)
  if valid_568540 != nil:
    section.add "circuitName", valid_568540
  var valid_568541 = path.getOrDefault("resourceGroupName")
  valid_568541 = validateParameter(valid_568541, JString, required = true,
                                 default = nil)
  if valid_568541 != nil:
    section.add "resourceGroupName", valid_568541
  var valid_568542 = path.getOrDefault("subscriptionId")
  valid_568542 = validateParameter(valid_568542, JString, required = true,
                                 default = nil)
  if valid_568542 != nil:
    section.add "subscriptionId", valid_568542
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568543 = query.getOrDefault("api-version")
  valid_568543 = validateParameter(valid_568543, JString, required = true,
                                 default = nil)
  if valid_568543 != nil:
    section.add "api-version", valid_568543
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568544: Call_ExpressRouteCircuitPeeringsList_568537;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The List peering operation retrieves all the peerings in an ExpressRouteCircuit.
  ## 
  let valid = call_568544.validator(path, query, header, formData, body)
  let scheme = call_568544.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568544.url(scheme.get, call_568544.host, call_568544.base,
                         call_568544.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568544, url, valid)

proc call*(call_568545: Call_ExpressRouteCircuitPeeringsList_568537;
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
  var path_568546 = newJObject()
  var query_568547 = newJObject()
  add(path_568546, "circuitName", newJString(circuitName))
  add(path_568546, "resourceGroupName", newJString(resourceGroupName))
  add(query_568547, "api-version", newJString(apiVersion))
  add(path_568546, "subscriptionId", newJString(subscriptionId))
  result = call_568545.call(path_568546, query_568547, nil, nil, nil)

var expressRouteCircuitPeeringsList* = Call_ExpressRouteCircuitPeeringsList_568537(
    name: "expressRouteCircuitPeeringsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings",
    validator: validate_ExpressRouteCircuitPeeringsList_568538, base: "",
    url: url_ExpressRouteCircuitPeeringsList_568539, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsCreateOrUpdate_568560 = ref object of OpenApiRestCall_567650
proc url_ExpressRouteCircuitPeeringsCreateOrUpdate_568562(protocol: Scheme;
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

proc validate_ExpressRouteCircuitPeeringsCreateOrUpdate_568561(path: JsonNode;
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
  var valid_568563 = path.getOrDefault("circuitName")
  valid_568563 = validateParameter(valid_568563, JString, required = true,
                                 default = nil)
  if valid_568563 != nil:
    section.add "circuitName", valid_568563
  var valid_568564 = path.getOrDefault("resourceGroupName")
  valid_568564 = validateParameter(valid_568564, JString, required = true,
                                 default = nil)
  if valid_568564 != nil:
    section.add "resourceGroupName", valid_568564
  var valid_568565 = path.getOrDefault("peeringName")
  valid_568565 = validateParameter(valid_568565, JString, required = true,
                                 default = nil)
  if valid_568565 != nil:
    section.add "peeringName", valid_568565
  var valid_568566 = path.getOrDefault("subscriptionId")
  valid_568566 = validateParameter(valid_568566, JString, required = true,
                                 default = nil)
  if valid_568566 != nil:
    section.add "subscriptionId", valid_568566
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568567 = query.getOrDefault("api-version")
  valid_568567 = validateParameter(valid_568567, JString, required = true,
                                 default = nil)
  if valid_568567 != nil:
    section.add "api-version", valid_568567
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

proc call*(call_568569: Call_ExpressRouteCircuitPeeringsCreateOrUpdate_568560;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put Peering operation creates/updates an peering in the specified ExpressRouteCircuits
  ## 
  let valid = call_568569.validator(path, query, header, formData, body)
  let scheme = call_568569.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568569.url(scheme.get, call_568569.host, call_568569.base,
                         call_568569.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568569, url, valid)

proc call*(call_568570: Call_ExpressRouteCircuitPeeringsCreateOrUpdate_568560;
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
  var path_568571 = newJObject()
  var query_568572 = newJObject()
  var body_568573 = newJObject()
  add(path_568571, "circuitName", newJString(circuitName))
  add(path_568571, "resourceGroupName", newJString(resourceGroupName))
  add(query_568572, "api-version", newJString(apiVersion))
  add(path_568571, "peeringName", newJString(peeringName))
  add(path_568571, "subscriptionId", newJString(subscriptionId))
  if peeringParameters != nil:
    body_568573 = peeringParameters
  result = call_568570.call(path_568571, query_568572, nil, nil, body_568573)

var expressRouteCircuitPeeringsCreateOrUpdate* = Call_ExpressRouteCircuitPeeringsCreateOrUpdate_568560(
    name: "expressRouteCircuitPeeringsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCircuitPeeringsCreateOrUpdate_568561,
    base: "", url: url_ExpressRouteCircuitPeeringsCreateOrUpdate_568562,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsGet_568548 = ref object of OpenApiRestCall_567650
proc url_ExpressRouteCircuitPeeringsGet_568550(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitPeeringsGet_568549(path: JsonNode;
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
  var valid_568551 = path.getOrDefault("circuitName")
  valid_568551 = validateParameter(valid_568551, JString, required = true,
                                 default = nil)
  if valid_568551 != nil:
    section.add "circuitName", valid_568551
  var valid_568552 = path.getOrDefault("resourceGroupName")
  valid_568552 = validateParameter(valid_568552, JString, required = true,
                                 default = nil)
  if valid_568552 != nil:
    section.add "resourceGroupName", valid_568552
  var valid_568553 = path.getOrDefault("peeringName")
  valid_568553 = validateParameter(valid_568553, JString, required = true,
                                 default = nil)
  if valid_568553 != nil:
    section.add "peeringName", valid_568553
  var valid_568554 = path.getOrDefault("subscriptionId")
  valid_568554 = validateParameter(valid_568554, JString, required = true,
                                 default = nil)
  if valid_568554 != nil:
    section.add "subscriptionId", valid_568554
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568555 = query.getOrDefault("api-version")
  valid_568555 = validateParameter(valid_568555, JString, required = true,
                                 default = nil)
  if valid_568555 != nil:
    section.add "api-version", valid_568555
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568556: Call_ExpressRouteCircuitPeeringsGet_568548; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GET peering operation retrieves the specified authorization from the ExpressRouteCircuit.
  ## 
  let valid = call_568556.validator(path, query, header, formData, body)
  let scheme = call_568556.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568556.url(scheme.get, call_568556.host, call_568556.base,
                         call_568556.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568556, url, valid)

proc call*(call_568557: Call_ExpressRouteCircuitPeeringsGet_568548;
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
  var path_568558 = newJObject()
  var query_568559 = newJObject()
  add(path_568558, "circuitName", newJString(circuitName))
  add(path_568558, "resourceGroupName", newJString(resourceGroupName))
  add(query_568559, "api-version", newJString(apiVersion))
  add(path_568558, "peeringName", newJString(peeringName))
  add(path_568558, "subscriptionId", newJString(subscriptionId))
  result = call_568557.call(path_568558, query_568559, nil, nil, nil)

var expressRouteCircuitPeeringsGet* = Call_ExpressRouteCircuitPeeringsGet_568548(
    name: "expressRouteCircuitPeeringsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCircuitPeeringsGet_568549, base: "",
    url: url_ExpressRouteCircuitPeeringsGet_568550, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsDelete_568574 = ref object of OpenApiRestCall_567650
proc url_ExpressRouteCircuitPeeringsDelete_568576(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitPeeringsDelete_568575(path: JsonNode;
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
  var valid_568577 = path.getOrDefault("circuitName")
  valid_568577 = validateParameter(valid_568577, JString, required = true,
                                 default = nil)
  if valid_568577 != nil:
    section.add "circuitName", valid_568577
  var valid_568578 = path.getOrDefault("resourceGroupName")
  valid_568578 = validateParameter(valid_568578, JString, required = true,
                                 default = nil)
  if valid_568578 != nil:
    section.add "resourceGroupName", valid_568578
  var valid_568579 = path.getOrDefault("peeringName")
  valid_568579 = validateParameter(valid_568579, JString, required = true,
                                 default = nil)
  if valid_568579 != nil:
    section.add "peeringName", valid_568579
  var valid_568580 = path.getOrDefault("subscriptionId")
  valid_568580 = validateParameter(valid_568580, JString, required = true,
                                 default = nil)
  if valid_568580 != nil:
    section.add "subscriptionId", valid_568580
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568581 = query.getOrDefault("api-version")
  valid_568581 = validateParameter(valid_568581, JString, required = true,
                                 default = nil)
  if valid_568581 != nil:
    section.add "api-version", valid_568581
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568582: Call_ExpressRouteCircuitPeeringsDelete_568574;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The delete peering operation deletes the specified peering from the ExpressRouteCircuit.
  ## 
  let valid = call_568582.validator(path, query, header, formData, body)
  let scheme = call_568582.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568582.url(scheme.get, call_568582.host, call_568582.base,
                         call_568582.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568582, url, valid)

proc call*(call_568583: Call_ExpressRouteCircuitPeeringsDelete_568574;
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
  var path_568584 = newJObject()
  var query_568585 = newJObject()
  add(path_568584, "circuitName", newJString(circuitName))
  add(path_568584, "resourceGroupName", newJString(resourceGroupName))
  add(query_568585, "api-version", newJString(apiVersion))
  add(path_568584, "peeringName", newJString(peeringName))
  add(path_568584, "subscriptionId", newJString(subscriptionId))
  result = call_568583.call(path_568584, query_568585, nil, nil, nil)

var expressRouteCircuitPeeringsDelete* = Call_ExpressRouteCircuitPeeringsDelete_568574(
    name: "expressRouteCircuitPeeringsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCircuitPeeringsDelete_568575, base: "",
    url: url_ExpressRouteCircuitPeeringsDelete_568576, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsListArpTable_568586 = ref object of OpenApiRestCall_567650
proc url_ExpressRouteCircuitsListArpTable_568588(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "arpTable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCircuitsListArpTable_568587(path: JsonNode;
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
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_568589 = path.getOrDefault("circuitName")
  valid_568589 = validateParameter(valid_568589, JString, required = true,
                                 default = nil)
  if valid_568589 != nil:
    section.add "circuitName", valid_568589
  var valid_568590 = path.getOrDefault("resourceGroupName")
  valid_568590 = validateParameter(valid_568590, JString, required = true,
                                 default = nil)
  if valid_568590 != nil:
    section.add "resourceGroupName", valid_568590
  var valid_568591 = path.getOrDefault("subscriptionId")
  valid_568591 = validateParameter(valid_568591, JString, required = true,
                                 default = nil)
  if valid_568591 != nil:
    section.add "subscriptionId", valid_568591
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568592 = query.getOrDefault("api-version")
  valid_568592 = validateParameter(valid_568592, JString, required = true,
                                 default = nil)
  if valid_568592 != nil:
    section.add "api-version", valid_568592
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568593: Call_ExpressRouteCircuitsListArpTable_568586;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The ListArpTable from ExpressRouteCircuit operation retrieves the currently advertised arp table associated with the ExpressRouteCircuits in a resource group.
  ## 
  let valid = call_568593.validator(path, query, header, formData, body)
  let scheme = call_568593.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568593.url(scheme.get, call_568593.host, call_568593.base,
                         call_568593.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568593, url, valid)

proc call*(call_568594: Call_ExpressRouteCircuitsListArpTable_568586;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## expressRouteCircuitsListArpTable
  ## The ListArpTable from ExpressRouteCircuit operation retrieves the currently advertised arp table associated with the ExpressRouteCircuits in a resource group.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568595 = newJObject()
  var query_568596 = newJObject()
  add(path_568595, "circuitName", newJString(circuitName))
  add(path_568595, "resourceGroupName", newJString(resourceGroupName))
  add(query_568596, "api-version", newJString(apiVersion))
  add(path_568595, "subscriptionId", newJString(subscriptionId))
  result = call_568594.call(path_568595, query_568596, nil, nil, nil)

var expressRouteCircuitsListArpTable* = Call_ExpressRouteCircuitsListArpTable_568586(
    name: "expressRouteCircuitsListArpTable", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}arpTable",
    validator: validate_ExpressRouteCircuitsListArpTable_568587, base: "",
    url: url_ExpressRouteCircuitsListArpTable_568588, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsListRoutesTable_568597 = ref object of OpenApiRestCall_567650
proc url_ExpressRouteCircuitsListRoutesTable_568599(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "routesTable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCircuitsListRoutesTable_568598(path: JsonNode;
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
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_568600 = path.getOrDefault("circuitName")
  valid_568600 = validateParameter(valid_568600, JString, required = true,
                                 default = nil)
  if valid_568600 != nil:
    section.add "circuitName", valid_568600
  var valid_568601 = path.getOrDefault("resourceGroupName")
  valid_568601 = validateParameter(valid_568601, JString, required = true,
                                 default = nil)
  if valid_568601 != nil:
    section.add "resourceGroupName", valid_568601
  var valid_568602 = path.getOrDefault("subscriptionId")
  valid_568602 = validateParameter(valid_568602, JString, required = true,
                                 default = nil)
  if valid_568602 != nil:
    section.add "subscriptionId", valid_568602
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568603 = query.getOrDefault("api-version")
  valid_568603 = validateParameter(valid_568603, JString, required = true,
                                 default = nil)
  if valid_568603 != nil:
    section.add "api-version", valid_568603
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568604: Call_ExpressRouteCircuitsListRoutesTable_568597;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The ListRoutesTable from ExpressRouteCircuit operation retrieves the currently advertised routes table associated with the ExpressRouteCircuits in a resource group.
  ## 
  let valid = call_568604.validator(path, query, header, formData, body)
  let scheme = call_568604.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568604.url(scheme.get, call_568604.host, call_568604.base,
                         call_568604.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568604, url, valid)

proc call*(call_568605: Call_ExpressRouteCircuitsListRoutesTable_568597;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## expressRouteCircuitsListRoutesTable
  ## The ListRoutesTable from ExpressRouteCircuit operation retrieves the currently advertised routes table associated with the ExpressRouteCircuits in a resource group.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568606 = newJObject()
  var query_568607 = newJObject()
  add(path_568606, "circuitName", newJString(circuitName))
  add(path_568606, "resourceGroupName", newJString(resourceGroupName))
  add(query_568607, "api-version", newJString(apiVersion))
  add(path_568606, "subscriptionId", newJString(subscriptionId))
  result = call_568605.call(path_568606, query_568607, nil, nil, nil)

var expressRouteCircuitsListRoutesTable* = Call_ExpressRouteCircuitsListRoutesTable_568597(
    name: "expressRouteCircuitsListRoutesTable", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}routesTable",
    validator: validate_ExpressRouteCircuitsListRoutesTable_568598, base: "",
    url: url_ExpressRouteCircuitsListRoutesTable_568599, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsListStats_568608 = ref object of OpenApiRestCall_567650
proc url_ExpressRouteCircuitsListStats_568610(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "stats")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCircuitsListStats_568609(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The ListStats ExpressRouteCircuit operation retrieves all the stats from a ExpressRouteCircuits in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   circuitName: JString (required)
  ##              : The name of the loadBalancer.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_568611 = path.getOrDefault("circuitName")
  valid_568611 = validateParameter(valid_568611, JString, required = true,
                                 default = nil)
  if valid_568611 != nil:
    section.add "circuitName", valid_568611
  var valid_568612 = path.getOrDefault("resourceGroupName")
  valid_568612 = validateParameter(valid_568612, JString, required = true,
                                 default = nil)
  if valid_568612 != nil:
    section.add "resourceGroupName", valid_568612
  var valid_568613 = path.getOrDefault("subscriptionId")
  valid_568613 = validateParameter(valid_568613, JString, required = true,
                                 default = nil)
  if valid_568613 != nil:
    section.add "subscriptionId", valid_568613
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568614 = query.getOrDefault("api-version")
  valid_568614 = validateParameter(valid_568614, JString, required = true,
                                 default = nil)
  if valid_568614 != nil:
    section.add "api-version", valid_568614
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568615: Call_ExpressRouteCircuitsListStats_568608; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The ListStats ExpressRouteCircuit operation retrieves all the stats from a ExpressRouteCircuits in a resource group.
  ## 
  let valid = call_568615.validator(path, query, header, formData, body)
  let scheme = call_568615.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568615.url(scheme.get, call_568615.host, call_568615.base,
                         call_568615.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568615, url, valid)

proc call*(call_568616: Call_ExpressRouteCircuitsListStats_568608;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## expressRouteCircuitsListStats
  ## The ListStats ExpressRouteCircuit operation retrieves all the stats from a ExpressRouteCircuits in a resource group.
  ##   circuitName: string (required)
  ##              : The name of the loadBalancer.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568617 = newJObject()
  var query_568618 = newJObject()
  add(path_568617, "circuitName", newJString(circuitName))
  add(path_568617, "resourceGroupName", newJString(resourceGroupName))
  add(query_568618, "api-version", newJString(apiVersion))
  add(path_568617, "subscriptionId", newJString(subscriptionId))
  result = call_568616.call(path_568617, query_568618, nil, nil, nil)

var expressRouteCircuitsListStats* = Call_ExpressRouteCircuitsListStats_568608(
    name: "expressRouteCircuitsListStats", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}stats",
    validator: validate_ExpressRouteCircuitsListStats_568609, base: "",
    url: url_ExpressRouteCircuitsListStats_568610, schemes: {Scheme.Https})
type
  Call_LoadBalancersList_568619 = ref object of OpenApiRestCall_567650
proc url_LoadBalancersList_568621(protocol: Scheme; host: string; base: string;
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

proc validate_LoadBalancersList_568620(path: JsonNode; query: JsonNode;
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
  var valid_568622 = path.getOrDefault("resourceGroupName")
  valid_568622 = validateParameter(valid_568622, JString, required = true,
                                 default = nil)
  if valid_568622 != nil:
    section.add "resourceGroupName", valid_568622
  var valid_568623 = path.getOrDefault("subscriptionId")
  valid_568623 = validateParameter(valid_568623, JString, required = true,
                                 default = nil)
  if valid_568623 != nil:
    section.add "subscriptionId", valid_568623
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568624 = query.getOrDefault("api-version")
  valid_568624 = validateParameter(valid_568624, JString, required = true,
                                 default = nil)
  if valid_568624 != nil:
    section.add "api-version", valid_568624
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568625: Call_LoadBalancersList_568619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List loadBalancer operation retrieves all the load balancers in a resource group.
  ## 
  let valid = call_568625.validator(path, query, header, formData, body)
  let scheme = call_568625.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568625.url(scheme.get, call_568625.host, call_568625.base,
                         call_568625.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568625, url, valid)

proc call*(call_568626: Call_LoadBalancersList_568619; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## loadBalancersList
  ## The List loadBalancer operation retrieves all the load balancers in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568627 = newJObject()
  var query_568628 = newJObject()
  add(path_568627, "resourceGroupName", newJString(resourceGroupName))
  add(query_568628, "api-version", newJString(apiVersion))
  add(path_568627, "subscriptionId", newJString(subscriptionId))
  result = call_568626.call(path_568627, query_568628, nil, nil, nil)

var loadBalancersList* = Call_LoadBalancersList_568619(name: "loadBalancersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers",
    validator: validate_LoadBalancersList_568620, base: "",
    url: url_LoadBalancersList_568621, schemes: {Scheme.Https})
type
  Call_LoadBalancersCreateOrUpdate_568640 = ref object of OpenApiRestCall_567650
proc url_LoadBalancersCreateOrUpdate_568642(protocol: Scheme; host: string;
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

proc validate_LoadBalancersCreateOrUpdate_568641(path: JsonNode; query: JsonNode;
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
  var valid_568643 = path.getOrDefault("resourceGroupName")
  valid_568643 = validateParameter(valid_568643, JString, required = true,
                                 default = nil)
  if valid_568643 != nil:
    section.add "resourceGroupName", valid_568643
  var valid_568644 = path.getOrDefault("loadBalancerName")
  valid_568644 = validateParameter(valid_568644, JString, required = true,
                                 default = nil)
  if valid_568644 != nil:
    section.add "loadBalancerName", valid_568644
  var valid_568645 = path.getOrDefault("subscriptionId")
  valid_568645 = validateParameter(valid_568645, JString, required = true,
                                 default = nil)
  if valid_568645 != nil:
    section.add "subscriptionId", valid_568645
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/delete LoadBalancer operation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568648: Call_LoadBalancersCreateOrUpdate_568640; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put LoadBalancer operation creates/updates a LoadBalancer
  ## 
  let valid = call_568648.validator(path, query, header, formData, body)
  let scheme = call_568648.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568648.url(scheme.get, call_568648.host, call_568648.base,
                         call_568648.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568648, url, valid)

proc call*(call_568649: Call_LoadBalancersCreateOrUpdate_568640;
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
  var path_568650 = newJObject()
  var query_568651 = newJObject()
  var body_568652 = newJObject()
  add(path_568650, "resourceGroupName", newJString(resourceGroupName))
  add(query_568651, "api-version", newJString(apiVersion))
  add(path_568650, "loadBalancerName", newJString(loadBalancerName))
  add(path_568650, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568652 = parameters
  result = call_568649.call(path_568650, query_568651, nil, nil, body_568652)

var loadBalancersCreateOrUpdate* = Call_LoadBalancersCreateOrUpdate_568640(
    name: "loadBalancersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}",
    validator: validate_LoadBalancersCreateOrUpdate_568641, base: "",
    url: url_LoadBalancersCreateOrUpdate_568642, schemes: {Scheme.Https})
type
  Call_LoadBalancersGet_568629 = ref object of OpenApiRestCall_567650
proc url_LoadBalancersGet_568631(protocol: Scheme; host: string; base: string;
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

proc validate_LoadBalancersGet_568630(path: JsonNode; query: JsonNode;
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
  var valid_568632 = path.getOrDefault("resourceGroupName")
  valid_568632 = validateParameter(valid_568632, JString, required = true,
                                 default = nil)
  if valid_568632 != nil:
    section.add "resourceGroupName", valid_568632
  var valid_568633 = path.getOrDefault("loadBalancerName")
  valid_568633 = validateParameter(valid_568633, JString, required = true,
                                 default = nil)
  if valid_568633 != nil:
    section.add "loadBalancerName", valid_568633
  var valid_568634 = path.getOrDefault("subscriptionId")
  valid_568634 = validateParameter(valid_568634, JString, required = true,
                                 default = nil)
  if valid_568634 != nil:
    section.add "subscriptionId", valid_568634
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568635 = query.getOrDefault("api-version")
  valid_568635 = validateParameter(valid_568635, JString, required = true,
                                 default = nil)
  if valid_568635 != nil:
    section.add "api-version", valid_568635
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568636: Call_LoadBalancersGet_568629; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get network interface operation retrieves information about the specified network interface.
  ## 
  let valid = call_568636.validator(path, query, header, formData, body)
  let scheme = call_568636.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568636.url(scheme.get, call_568636.host, call_568636.base,
                         call_568636.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568636, url, valid)

proc call*(call_568637: Call_LoadBalancersGet_568629; resourceGroupName: string;
          apiVersion: string; loadBalancerName: string; subscriptionId: string): Recallable =
  ## loadBalancersGet
  ## The Get network interface operation retrieves information about the specified network interface.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   loadBalancerName: string (required)
  ##                   : The name of the loadBalancer.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568638 = newJObject()
  var query_568639 = newJObject()
  add(path_568638, "resourceGroupName", newJString(resourceGroupName))
  add(query_568639, "api-version", newJString(apiVersion))
  add(path_568638, "loadBalancerName", newJString(loadBalancerName))
  add(path_568638, "subscriptionId", newJString(subscriptionId))
  result = call_568637.call(path_568638, query_568639, nil, nil, nil)

var loadBalancersGet* = Call_LoadBalancersGet_568629(name: "loadBalancersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}",
    validator: validate_LoadBalancersGet_568630, base: "",
    url: url_LoadBalancersGet_568631, schemes: {Scheme.Https})
type
  Call_LoadBalancersDelete_568653 = ref object of OpenApiRestCall_567650
proc url_LoadBalancersDelete_568655(protocol: Scheme; host: string; base: string;
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

proc validate_LoadBalancersDelete_568654(path: JsonNode; query: JsonNode;
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
  var valid_568656 = path.getOrDefault("resourceGroupName")
  valid_568656 = validateParameter(valid_568656, JString, required = true,
                                 default = nil)
  if valid_568656 != nil:
    section.add "resourceGroupName", valid_568656
  var valid_568657 = path.getOrDefault("loadBalancerName")
  valid_568657 = validateParameter(valid_568657, JString, required = true,
                                 default = nil)
  if valid_568657 != nil:
    section.add "loadBalancerName", valid_568657
  var valid_568658 = path.getOrDefault("subscriptionId")
  valid_568658 = validateParameter(valid_568658, JString, required = true,
                                 default = nil)
  if valid_568658 != nil:
    section.add "subscriptionId", valid_568658
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568659 = query.getOrDefault("api-version")
  valid_568659 = validateParameter(valid_568659, JString, required = true,
                                 default = nil)
  if valid_568659 != nil:
    section.add "api-version", valid_568659
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568660: Call_LoadBalancersDelete_568653; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete loadbalancer operation deletes the specified loadbalancer.
  ## 
  let valid = call_568660.validator(path, query, header, formData, body)
  let scheme = call_568660.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568660.url(scheme.get, call_568660.host, call_568660.base,
                         call_568660.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568660, url, valid)

proc call*(call_568661: Call_LoadBalancersDelete_568653; resourceGroupName: string;
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
  var path_568662 = newJObject()
  var query_568663 = newJObject()
  add(path_568662, "resourceGroupName", newJString(resourceGroupName))
  add(query_568663, "api-version", newJString(apiVersion))
  add(path_568662, "loadBalancerName", newJString(loadBalancerName))
  add(path_568662, "subscriptionId", newJString(subscriptionId))
  result = call_568661.call(path_568662, query_568663, nil, nil, nil)

var loadBalancersDelete* = Call_LoadBalancersDelete_568653(
    name: "loadBalancersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}",
    validator: validate_LoadBalancersDelete_568654, base: "",
    url: url_LoadBalancersDelete_568655, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysList_568664 = ref object of OpenApiRestCall_567650
proc url_LocalNetworkGatewaysList_568666(protocol: Scheme; host: string;
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

proc validate_LocalNetworkGatewaysList_568665(path: JsonNode; query: JsonNode;
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
  var valid_568667 = path.getOrDefault("resourceGroupName")
  valid_568667 = validateParameter(valid_568667, JString, required = true,
                                 default = nil)
  if valid_568667 != nil:
    section.add "resourceGroupName", valid_568667
  var valid_568668 = path.getOrDefault("subscriptionId")
  valid_568668 = validateParameter(valid_568668, JString, required = true,
                                 default = nil)
  if valid_568668 != nil:
    section.add "subscriptionId", valid_568668
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568669 = query.getOrDefault("api-version")
  valid_568669 = validateParameter(valid_568669, JString, required = true,
                                 default = nil)
  if valid_568669 != nil:
    section.add "api-version", valid_568669
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568670: Call_LocalNetworkGatewaysList_568664; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List LocalNetworkGateways operation retrieves all the local network gateways stored.
  ## 
  let valid = call_568670.validator(path, query, header, formData, body)
  let scheme = call_568670.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568670.url(scheme.get, call_568670.host, call_568670.base,
                         call_568670.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568670, url, valid)

proc call*(call_568671: Call_LocalNetworkGatewaysList_568664;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## localNetworkGatewaysList
  ## The List LocalNetworkGateways operation retrieves all the local network gateways stored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568672 = newJObject()
  var query_568673 = newJObject()
  add(path_568672, "resourceGroupName", newJString(resourceGroupName))
  add(query_568673, "api-version", newJString(apiVersion))
  add(path_568672, "subscriptionId", newJString(subscriptionId))
  result = call_568671.call(path_568672, query_568673, nil, nil, nil)

var localNetworkGatewaysList* = Call_LocalNetworkGatewaysList_568664(
    name: "localNetworkGatewaysList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways",
    validator: validate_LocalNetworkGatewaysList_568665, base: "",
    url: url_LocalNetworkGatewaysList_568666, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysCreateOrUpdate_568685 = ref object of OpenApiRestCall_567650
proc url_LocalNetworkGatewaysCreateOrUpdate_568687(protocol: Scheme; host: string;
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

proc validate_LocalNetworkGatewaysCreateOrUpdate_568686(path: JsonNode;
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
  var valid_568688 = path.getOrDefault("resourceGroupName")
  valid_568688 = validateParameter(valid_568688, JString, required = true,
                                 default = nil)
  if valid_568688 != nil:
    section.add "resourceGroupName", valid_568688
  var valid_568689 = path.getOrDefault("localNetworkGatewayName")
  valid_568689 = validateParameter(valid_568689, JString, required = true,
                                 default = nil)
  if valid_568689 != nil:
    section.add "localNetworkGatewayName", valid_568689
  var valid_568690 = path.getOrDefault("subscriptionId")
  valid_568690 = validateParameter(valid_568690, JString, required = true,
                                 default = nil)
  if valid_568690 != nil:
    section.add "subscriptionId", valid_568690
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568691 = query.getOrDefault("api-version")
  valid_568691 = validateParameter(valid_568691, JString, required = true,
                                 default = nil)
  if valid_568691 != nil:
    section.add "api-version", valid_568691
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

proc call*(call_568693: Call_LocalNetworkGatewaysCreateOrUpdate_568685;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put LocalNetworkGateway operation creates/updates a local network gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_568693.validator(path, query, header, formData, body)
  let scheme = call_568693.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568693.url(scheme.get, call_568693.host, call_568693.base,
                         call_568693.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568693, url, valid)

proc call*(call_568694: Call_LocalNetworkGatewaysCreateOrUpdate_568685;
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
  var path_568695 = newJObject()
  var query_568696 = newJObject()
  var body_568697 = newJObject()
  add(path_568695, "resourceGroupName", newJString(resourceGroupName))
  add(path_568695, "localNetworkGatewayName", newJString(localNetworkGatewayName))
  add(query_568696, "api-version", newJString(apiVersion))
  add(path_568695, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568697 = parameters
  result = call_568694.call(path_568695, query_568696, nil, nil, body_568697)

var localNetworkGatewaysCreateOrUpdate* = Call_LocalNetworkGatewaysCreateOrUpdate_568685(
    name: "localNetworkGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways/{localNetworkGatewayName}",
    validator: validate_LocalNetworkGatewaysCreateOrUpdate_568686, base: "",
    url: url_LocalNetworkGatewaysCreateOrUpdate_568687, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysGet_568674 = ref object of OpenApiRestCall_567650
proc url_LocalNetworkGatewaysGet_568676(protocol: Scheme; host: string; base: string;
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

proc validate_LocalNetworkGatewaysGet_568675(path: JsonNode; query: JsonNode;
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
  var valid_568677 = path.getOrDefault("resourceGroupName")
  valid_568677 = validateParameter(valid_568677, JString, required = true,
                                 default = nil)
  if valid_568677 != nil:
    section.add "resourceGroupName", valid_568677
  var valid_568678 = path.getOrDefault("localNetworkGatewayName")
  valid_568678 = validateParameter(valid_568678, JString, required = true,
                                 default = nil)
  if valid_568678 != nil:
    section.add "localNetworkGatewayName", valid_568678
  var valid_568679 = path.getOrDefault("subscriptionId")
  valid_568679 = validateParameter(valid_568679, JString, required = true,
                                 default = nil)
  if valid_568679 != nil:
    section.add "subscriptionId", valid_568679
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568680 = query.getOrDefault("api-version")
  valid_568680 = validateParameter(valid_568680, JString, required = true,
                                 default = nil)
  if valid_568680 != nil:
    section.add "api-version", valid_568680
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568681: Call_LocalNetworkGatewaysGet_568674; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get LocalNetworkGateway operation retrieves information about the specified local network gateway through Network resource provider.
  ## 
  let valid = call_568681.validator(path, query, header, formData, body)
  let scheme = call_568681.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568681.url(scheme.get, call_568681.host, call_568681.base,
                         call_568681.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568681, url, valid)

proc call*(call_568682: Call_LocalNetworkGatewaysGet_568674;
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
  var path_568683 = newJObject()
  var query_568684 = newJObject()
  add(path_568683, "resourceGroupName", newJString(resourceGroupName))
  add(path_568683, "localNetworkGatewayName", newJString(localNetworkGatewayName))
  add(query_568684, "api-version", newJString(apiVersion))
  add(path_568683, "subscriptionId", newJString(subscriptionId))
  result = call_568682.call(path_568683, query_568684, nil, nil, nil)

var localNetworkGatewaysGet* = Call_LocalNetworkGatewaysGet_568674(
    name: "localNetworkGatewaysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways/{localNetworkGatewayName}",
    validator: validate_LocalNetworkGatewaysGet_568675, base: "",
    url: url_LocalNetworkGatewaysGet_568676, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysDelete_568698 = ref object of OpenApiRestCall_567650
proc url_LocalNetworkGatewaysDelete_568700(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "localNetworkGatewayName"),
               (kind: ConstantSegment, value: "/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocalNetworkGatewaysDelete_568699(path: JsonNode; query: JsonNode;
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
  var valid_568701 = path.getOrDefault("resourceGroupName")
  valid_568701 = validateParameter(valid_568701, JString, required = true,
                                 default = nil)
  if valid_568701 != nil:
    section.add "resourceGroupName", valid_568701
  var valid_568702 = path.getOrDefault("localNetworkGatewayName")
  valid_568702 = validateParameter(valid_568702, JString, required = true,
                                 default = nil)
  if valid_568702 != nil:
    section.add "localNetworkGatewayName", valid_568702
  var valid_568703 = path.getOrDefault("subscriptionId")
  valid_568703 = validateParameter(valid_568703, JString, required = true,
                                 default = nil)
  if valid_568703 != nil:
    section.add "subscriptionId", valid_568703
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568704 = query.getOrDefault("api-version")
  valid_568704 = validateParameter(valid_568704, JString, required = true,
                                 default = nil)
  if valid_568704 != nil:
    section.add "api-version", valid_568704
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568705: Call_LocalNetworkGatewaysDelete_568698; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete LocalNetworkGateway operation deletes the specified local network Gateway through Network resource provider.
  ## 
  let valid = call_568705.validator(path, query, header, formData, body)
  let scheme = call_568705.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568705.url(scheme.get, call_568705.host, call_568705.base,
                         call_568705.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568705, url, valid)

proc call*(call_568706: Call_LocalNetworkGatewaysDelete_568698;
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
  var path_568707 = newJObject()
  var query_568708 = newJObject()
  add(path_568707, "resourceGroupName", newJString(resourceGroupName))
  add(path_568707, "localNetworkGatewayName", newJString(localNetworkGatewayName))
  add(query_568708, "api-version", newJString(apiVersion))
  add(path_568707, "subscriptionId", newJString(subscriptionId))
  result = call_568706.call(path_568707, query_568708, nil, nil, nil)

var localNetworkGatewaysDelete* = Call_LocalNetworkGatewaysDelete_568698(
    name: "localNetworkGatewaysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways/{localNetworkGatewayName}/",
    validator: validate_LocalNetworkGatewaysDelete_568699, base: "",
    url: url_LocalNetworkGatewaysDelete_568700, schemes: {Scheme.Https})
type
  Call_NetworkInterfacesList_568709 = ref object of OpenApiRestCall_567650
proc url_NetworkInterfacesList_568711(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkInterfacesList_568710(path: JsonNode; query: JsonNode;
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
  var valid_568712 = path.getOrDefault("resourceGroupName")
  valid_568712 = validateParameter(valid_568712, JString, required = true,
                                 default = nil)
  if valid_568712 != nil:
    section.add "resourceGroupName", valid_568712
  var valid_568713 = path.getOrDefault("subscriptionId")
  valid_568713 = validateParameter(valid_568713, JString, required = true,
                                 default = nil)
  if valid_568713 != nil:
    section.add "subscriptionId", valid_568713
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568714 = query.getOrDefault("api-version")
  valid_568714 = validateParameter(valid_568714, JString, required = true,
                                 default = nil)
  if valid_568714 != nil:
    section.add "api-version", valid_568714
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568715: Call_NetworkInterfacesList_568709; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List networkInterfaces operation retrieves all the networkInterfaces in a resource group.
  ## 
  let valid = call_568715.validator(path, query, header, formData, body)
  let scheme = call_568715.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568715.url(scheme.get, call_568715.host, call_568715.base,
                         call_568715.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568715, url, valid)

proc call*(call_568716: Call_NetworkInterfacesList_568709;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## networkInterfacesList
  ## The List networkInterfaces operation retrieves all the networkInterfaces in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568717 = newJObject()
  var query_568718 = newJObject()
  add(path_568717, "resourceGroupName", newJString(resourceGroupName))
  add(query_568718, "api-version", newJString(apiVersion))
  add(path_568717, "subscriptionId", newJString(subscriptionId))
  result = call_568716.call(path_568717, query_568718, nil, nil, nil)

var networkInterfacesList* = Call_NetworkInterfacesList_568709(
    name: "networkInterfacesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces",
    validator: validate_NetworkInterfacesList_568710, base: "",
    url: url_NetworkInterfacesList_568711, schemes: {Scheme.Https})
type
  Call_NetworkInterfacesCreateOrUpdate_568730 = ref object of OpenApiRestCall_567650
proc url_NetworkInterfacesCreateOrUpdate_568732(protocol: Scheme; host: string;
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

proc validate_NetworkInterfacesCreateOrUpdate_568731(path: JsonNode;
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
  var valid_568733 = path.getOrDefault("resourceGroupName")
  valid_568733 = validateParameter(valid_568733, JString, required = true,
                                 default = nil)
  if valid_568733 != nil:
    section.add "resourceGroupName", valid_568733
  var valid_568734 = path.getOrDefault("subscriptionId")
  valid_568734 = validateParameter(valid_568734, JString, required = true,
                                 default = nil)
  if valid_568734 != nil:
    section.add "subscriptionId", valid_568734
  var valid_568735 = path.getOrDefault("networkInterfaceName")
  valid_568735 = validateParameter(valid_568735, JString, required = true,
                                 default = nil)
  if valid_568735 != nil:
    section.add "networkInterfaceName", valid_568735
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568736 = query.getOrDefault("api-version")
  valid_568736 = validateParameter(valid_568736, JString, required = true,
                                 default = nil)
  if valid_568736 != nil:
    section.add "api-version", valid_568736
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

proc call*(call_568738: Call_NetworkInterfacesCreateOrUpdate_568730;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put NetworkInterface operation creates/updates a networkInterface
  ## 
  let valid = call_568738.validator(path, query, header, formData, body)
  let scheme = call_568738.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568738.url(scheme.get, call_568738.host, call_568738.base,
                         call_568738.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568738, url, valid)

proc call*(call_568739: Call_NetworkInterfacesCreateOrUpdate_568730;
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
  var path_568740 = newJObject()
  var query_568741 = newJObject()
  var body_568742 = newJObject()
  add(path_568740, "resourceGroupName", newJString(resourceGroupName))
  add(query_568741, "api-version", newJString(apiVersion))
  add(path_568740, "subscriptionId", newJString(subscriptionId))
  add(path_568740, "networkInterfaceName", newJString(networkInterfaceName))
  if parameters != nil:
    body_568742 = parameters
  result = call_568739.call(path_568740, query_568741, nil, nil, body_568742)

var networkInterfacesCreateOrUpdate* = Call_NetworkInterfacesCreateOrUpdate_568730(
    name: "networkInterfacesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/{networkInterfaceName}",
    validator: validate_NetworkInterfacesCreateOrUpdate_568731, base: "",
    url: url_NetworkInterfacesCreateOrUpdate_568732, schemes: {Scheme.Https})
type
  Call_NetworkInterfacesGet_568719 = ref object of OpenApiRestCall_567650
proc url_NetworkInterfacesGet_568721(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkInterfacesGet_568720(path: JsonNode; query: JsonNode;
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
  var valid_568722 = path.getOrDefault("resourceGroupName")
  valid_568722 = validateParameter(valid_568722, JString, required = true,
                                 default = nil)
  if valid_568722 != nil:
    section.add "resourceGroupName", valid_568722
  var valid_568723 = path.getOrDefault("subscriptionId")
  valid_568723 = validateParameter(valid_568723, JString, required = true,
                                 default = nil)
  if valid_568723 != nil:
    section.add "subscriptionId", valid_568723
  var valid_568724 = path.getOrDefault("networkInterfaceName")
  valid_568724 = validateParameter(valid_568724, JString, required = true,
                                 default = nil)
  if valid_568724 != nil:
    section.add "networkInterfaceName", valid_568724
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568725 = query.getOrDefault("api-version")
  valid_568725 = validateParameter(valid_568725, JString, required = true,
                                 default = nil)
  if valid_568725 != nil:
    section.add "api-version", valid_568725
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568726: Call_NetworkInterfacesGet_568719; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get network interface operation retrieves information about the specified network interface.
  ## 
  let valid = call_568726.validator(path, query, header, formData, body)
  let scheme = call_568726.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568726.url(scheme.get, call_568726.host, call_568726.base,
                         call_568726.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568726, url, valid)

proc call*(call_568727: Call_NetworkInterfacesGet_568719;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkInterfaceName: string): Recallable =
  ## networkInterfacesGet
  ## The Get network interface operation retrieves information about the specified network interface.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkInterfaceName: string (required)
  ##                       : The name of the network interface.
  var path_568728 = newJObject()
  var query_568729 = newJObject()
  add(path_568728, "resourceGroupName", newJString(resourceGroupName))
  add(query_568729, "api-version", newJString(apiVersion))
  add(path_568728, "subscriptionId", newJString(subscriptionId))
  add(path_568728, "networkInterfaceName", newJString(networkInterfaceName))
  result = call_568727.call(path_568728, query_568729, nil, nil, nil)

var networkInterfacesGet* = Call_NetworkInterfacesGet_568719(
    name: "networkInterfacesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/{networkInterfaceName}",
    validator: validate_NetworkInterfacesGet_568720, base: "",
    url: url_NetworkInterfacesGet_568721, schemes: {Scheme.Https})
type
  Call_NetworkInterfacesDelete_568743 = ref object of OpenApiRestCall_567650
proc url_NetworkInterfacesDelete_568745(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkInterfacesDelete_568744(path: JsonNode; query: JsonNode;
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
  var valid_568746 = path.getOrDefault("resourceGroupName")
  valid_568746 = validateParameter(valid_568746, JString, required = true,
                                 default = nil)
  if valid_568746 != nil:
    section.add "resourceGroupName", valid_568746
  var valid_568747 = path.getOrDefault("subscriptionId")
  valid_568747 = validateParameter(valid_568747, JString, required = true,
                                 default = nil)
  if valid_568747 != nil:
    section.add "subscriptionId", valid_568747
  var valid_568748 = path.getOrDefault("networkInterfaceName")
  valid_568748 = validateParameter(valid_568748, JString, required = true,
                                 default = nil)
  if valid_568748 != nil:
    section.add "networkInterfaceName", valid_568748
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568749 = query.getOrDefault("api-version")
  valid_568749 = validateParameter(valid_568749, JString, required = true,
                                 default = nil)
  if valid_568749 != nil:
    section.add "api-version", valid_568749
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568750: Call_NetworkInterfacesDelete_568743; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete networkInterface operation deletes the specified networkInterface.
  ## 
  let valid = call_568750.validator(path, query, header, formData, body)
  let scheme = call_568750.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568750.url(scheme.get, call_568750.host, call_568750.base,
                         call_568750.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568750, url, valid)

proc call*(call_568751: Call_NetworkInterfacesDelete_568743;
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
  var path_568752 = newJObject()
  var query_568753 = newJObject()
  add(path_568752, "resourceGroupName", newJString(resourceGroupName))
  add(query_568753, "api-version", newJString(apiVersion))
  add(path_568752, "subscriptionId", newJString(subscriptionId))
  add(path_568752, "networkInterfaceName", newJString(networkInterfaceName))
  result = call_568751.call(path_568752, query_568753, nil, nil, nil)

var networkInterfacesDelete* = Call_NetworkInterfacesDelete_568743(
    name: "networkInterfacesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/{networkInterfaceName}",
    validator: validate_NetworkInterfacesDelete_568744, base: "",
    url: url_NetworkInterfacesDelete_568745, schemes: {Scheme.Https})
type
  Call_NetworkSecurityGroupsList_568754 = ref object of OpenApiRestCall_567650
proc url_NetworkSecurityGroupsList_568756(protocol: Scheme; host: string;
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

proc validate_NetworkSecurityGroupsList_568755(path: JsonNode; query: JsonNode;
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
  var valid_568757 = path.getOrDefault("resourceGroupName")
  valid_568757 = validateParameter(valid_568757, JString, required = true,
                                 default = nil)
  if valid_568757 != nil:
    section.add "resourceGroupName", valid_568757
  var valid_568758 = path.getOrDefault("subscriptionId")
  valid_568758 = validateParameter(valid_568758, JString, required = true,
                                 default = nil)
  if valid_568758 != nil:
    section.add "subscriptionId", valid_568758
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568759 = query.getOrDefault("api-version")
  valid_568759 = validateParameter(valid_568759, JString, required = true,
                                 default = nil)
  if valid_568759 != nil:
    section.add "api-version", valid_568759
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568760: Call_NetworkSecurityGroupsList_568754; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list NetworkSecurityGroups returns all network security groups in a resource group
  ## 
  let valid = call_568760.validator(path, query, header, formData, body)
  let scheme = call_568760.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568760.url(scheme.get, call_568760.host, call_568760.base,
                         call_568760.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568760, url, valid)

proc call*(call_568761: Call_NetworkSecurityGroupsList_568754;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## networkSecurityGroupsList
  ## The list NetworkSecurityGroups returns all network security groups in a resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568762 = newJObject()
  var query_568763 = newJObject()
  add(path_568762, "resourceGroupName", newJString(resourceGroupName))
  add(query_568763, "api-version", newJString(apiVersion))
  add(path_568762, "subscriptionId", newJString(subscriptionId))
  result = call_568761.call(path_568762, query_568763, nil, nil, nil)

var networkSecurityGroupsList* = Call_NetworkSecurityGroupsList_568754(
    name: "networkSecurityGroupsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups",
    validator: validate_NetworkSecurityGroupsList_568755, base: "",
    url: url_NetworkSecurityGroupsList_568756, schemes: {Scheme.Https})
type
  Call_NetworkSecurityGroupsCreateOrUpdate_568775 = ref object of OpenApiRestCall_567650
proc url_NetworkSecurityGroupsCreateOrUpdate_568777(protocol: Scheme; host: string;
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

proc validate_NetworkSecurityGroupsCreateOrUpdate_568776(path: JsonNode;
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
  var valid_568778 = path.getOrDefault("resourceGroupName")
  valid_568778 = validateParameter(valid_568778, JString, required = true,
                                 default = nil)
  if valid_568778 != nil:
    section.add "resourceGroupName", valid_568778
  var valid_568779 = path.getOrDefault("subscriptionId")
  valid_568779 = validateParameter(valid_568779, JString, required = true,
                                 default = nil)
  if valid_568779 != nil:
    section.add "subscriptionId", valid_568779
  var valid_568780 = path.getOrDefault("networkSecurityGroupName")
  valid_568780 = validateParameter(valid_568780, JString, required = true,
                                 default = nil)
  if valid_568780 != nil:
    section.add "networkSecurityGroupName", valid_568780
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568781 = query.getOrDefault("api-version")
  valid_568781 = validateParameter(valid_568781, JString, required = true,
                                 default = nil)
  if valid_568781 != nil:
    section.add "api-version", valid_568781
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

proc call*(call_568783: Call_NetworkSecurityGroupsCreateOrUpdate_568775;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put NetworkSecurityGroup operation creates/updates a network security group in the specified resource group.
  ## 
  let valid = call_568783.validator(path, query, header, formData, body)
  let scheme = call_568783.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568783.url(scheme.get, call_568783.host, call_568783.base,
                         call_568783.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568783, url, valid)

proc call*(call_568784: Call_NetworkSecurityGroupsCreateOrUpdate_568775;
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
  var path_568785 = newJObject()
  var query_568786 = newJObject()
  var body_568787 = newJObject()
  add(path_568785, "resourceGroupName", newJString(resourceGroupName))
  add(query_568786, "api-version", newJString(apiVersion))
  add(path_568785, "subscriptionId", newJString(subscriptionId))
  add(path_568785, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  if parameters != nil:
    body_568787 = parameters
  result = call_568784.call(path_568785, query_568786, nil, nil, body_568787)

var networkSecurityGroupsCreateOrUpdate* = Call_NetworkSecurityGroupsCreateOrUpdate_568775(
    name: "networkSecurityGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}",
    validator: validate_NetworkSecurityGroupsCreateOrUpdate_568776, base: "",
    url: url_NetworkSecurityGroupsCreateOrUpdate_568777, schemes: {Scheme.Https})
type
  Call_NetworkSecurityGroupsGet_568764 = ref object of OpenApiRestCall_567650
proc url_NetworkSecurityGroupsGet_568766(protocol: Scheme; host: string;
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

proc validate_NetworkSecurityGroupsGet_568765(path: JsonNode; query: JsonNode;
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
  var valid_568767 = path.getOrDefault("resourceGroupName")
  valid_568767 = validateParameter(valid_568767, JString, required = true,
                                 default = nil)
  if valid_568767 != nil:
    section.add "resourceGroupName", valid_568767
  var valid_568768 = path.getOrDefault("subscriptionId")
  valid_568768 = validateParameter(valid_568768, JString, required = true,
                                 default = nil)
  if valid_568768 != nil:
    section.add "subscriptionId", valid_568768
  var valid_568769 = path.getOrDefault("networkSecurityGroupName")
  valid_568769 = validateParameter(valid_568769, JString, required = true,
                                 default = nil)
  if valid_568769 != nil:
    section.add "networkSecurityGroupName", valid_568769
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568770 = query.getOrDefault("api-version")
  valid_568770 = validateParameter(valid_568770, JString, required = true,
                                 default = nil)
  if valid_568770 != nil:
    section.add "api-version", valid_568770
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568771: Call_NetworkSecurityGroupsGet_568764; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get NetworkSecurityGroups operation retrieves information about the specified network security group.
  ## 
  let valid = call_568771.validator(path, query, header, formData, body)
  let scheme = call_568771.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568771.url(scheme.get, call_568771.host, call_568771.base,
                         call_568771.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568771, url, valid)

proc call*(call_568772: Call_NetworkSecurityGroupsGet_568764;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          networkSecurityGroupName: string): Recallable =
  ## networkSecurityGroupsGet
  ## The Get NetworkSecurityGroups operation retrieves information about the specified network security group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   networkSecurityGroupName: string (required)
  ##                           : The name of the network security group.
  var path_568773 = newJObject()
  var query_568774 = newJObject()
  add(path_568773, "resourceGroupName", newJString(resourceGroupName))
  add(query_568774, "api-version", newJString(apiVersion))
  add(path_568773, "subscriptionId", newJString(subscriptionId))
  add(path_568773, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  result = call_568772.call(path_568773, query_568774, nil, nil, nil)

var networkSecurityGroupsGet* = Call_NetworkSecurityGroupsGet_568764(
    name: "networkSecurityGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}",
    validator: validate_NetworkSecurityGroupsGet_568765, base: "",
    url: url_NetworkSecurityGroupsGet_568766, schemes: {Scheme.Https})
type
  Call_NetworkSecurityGroupsDelete_568788 = ref object of OpenApiRestCall_567650
proc url_NetworkSecurityGroupsDelete_568790(protocol: Scheme; host: string;
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

proc validate_NetworkSecurityGroupsDelete_568789(path: JsonNode; query: JsonNode;
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
  var valid_568791 = path.getOrDefault("resourceGroupName")
  valid_568791 = validateParameter(valid_568791, JString, required = true,
                                 default = nil)
  if valid_568791 != nil:
    section.add "resourceGroupName", valid_568791
  var valid_568792 = path.getOrDefault("subscriptionId")
  valid_568792 = validateParameter(valid_568792, JString, required = true,
                                 default = nil)
  if valid_568792 != nil:
    section.add "subscriptionId", valid_568792
  var valid_568793 = path.getOrDefault("networkSecurityGroupName")
  valid_568793 = validateParameter(valid_568793, JString, required = true,
                                 default = nil)
  if valid_568793 != nil:
    section.add "networkSecurityGroupName", valid_568793
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568794 = query.getOrDefault("api-version")
  valid_568794 = validateParameter(valid_568794, JString, required = true,
                                 default = nil)
  if valid_568794 != nil:
    section.add "api-version", valid_568794
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568795: Call_NetworkSecurityGroupsDelete_568788; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete NetworkSecurityGroup operation deletes the specified network security group
  ## 
  let valid = call_568795.validator(path, query, header, formData, body)
  let scheme = call_568795.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568795.url(scheme.get, call_568795.host, call_568795.base,
                         call_568795.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568795, url, valid)

proc call*(call_568796: Call_NetworkSecurityGroupsDelete_568788;
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
  var path_568797 = newJObject()
  var query_568798 = newJObject()
  add(path_568797, "resourceGroupName", newJString(resourceGroupName))
  add(query_568798, "api-version", newJString(apiVersion))
  add(path_568797, "subscriptionId", newJString(subscriptionId))
  add(path_568797, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  result = call_568796.call(path_568797, query_568798, nil, nil, nil)

var networkSecurityGroupsDelete* = Call_NetworkSecurityGroupsDelete_568788(
    name: "networkSecurityGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}",
    validator: validate_NetworkSecurityGroupsDelete_568789, base: "",
    url: url_NetworkSecurityGroupsDelete_568790, schemes: {Scheme.Https})
type
  Call_SecurityRulesList_568799 = ref object of OpenApiRestCall_567650
proc url_SecurityRulesList_568801(protocol: Scheme; host: string; base: string;
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

proc validate_SecurityRulesList_568800(path: JsonNode; query: JsonNode;
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
  var valid_568802 = path.getOrDefault("resourceGroupName")
  valid_568802 = validateParameter(valid_568802, JString, required = true,
                                 default = nil)
  if valid_568802 != nil:
    section.add "resourceGroupName", valid_568802
  var valid_568803 = path.getOrDefault("subscriptionId")
  valid_568803 = validateParameter(valid_568803, JString, required = true,
                                 default = nil)
  if valid_568803 != nil:
    section.add "subscriptionId", valid_568803
  var valid_568804 = path.getOrDefault("networkSecurityGroupName")
  valid_568804 = validateParameter(valid_568804, JString, required = true,
                                 default = nil)
  if valid_568804 != nil:
    section.add "networkSecurityGroupName", valid_568804
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568805 = query.getOrDefault("api-version")
  valid_568805 = validateParameter(valid_568805, JString, required = true,
                                 default = nil)
  if valid_568805 != nil:
    section.add "api-version", valid_568805
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568806: Call_SecurityRulesList_568799; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List network security rule operation retrieves all the security rules in a network security group.
  ## 
  let valid = call_568806.validator(path, query, header, formData, body)
  let scheme = call_568806.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568806.url(scheme.get, call_568806.host, call_568806.base,
                         call_568806.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568806, url, valid)

proc call*(call_568807: Call_SecurityRulesList_568799; resourceGroupName: string;
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
  var path_568808 = newJObject()
  var query_568809 = newJObject()
  add(path_568808, "resourceGroupName", newJString(resourceGroupName))
  add(query_568809, "api-version", newJString(apiVersion))
  add(path_568808, "subscriptionId", newJString(subscriptionId))
  add(path_568808, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  result = call_568807.call(path_568808, query_568809, nil, nil, nil)

var securityRulesList* = Call_SecurityRulesList_568799(name: "securityRulesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}/securityRules",
    validator: validate_SecurityRulesList_568800, base: "",
    url: url_SecurityRulesList_568801, schemes: {Scheme.Https})
type
  Call_SecurityRulesCreateOrUpdate_568822 = ref object of OpenApiRestCall_567650
proc url_SecurityRulesCreateOrUpdate_568824(protocol: Scheme; host: string;
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

proc validate_SecurityRulesCreateOrUpdate_568823(path: JsonNode; query: JsonNode;
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
  var valid_568825 = path.getOrDefault("resourceGroupName")
  valid_568825 = validateParameter(valid_568825, JString, required = true,
                                 default = nil)
  if valid_568825 != nil:
    section.add "resourceGroupName", valid_568825
  var valid_568826 = path.getOrDefault("subscriptionId")
  valid_568826 = validateParameter(valid_568826, JString, required = true,
                                 default = nil)
  if valid_568826 != nil:
    section.add "subscriptionId", valid_568826
  var valid_568827 = path.getOrDefault("networkSecurityGroupName")
  valid_568827 = validateParameter(valid_568827, JString, required = true,
                                 default = nil)
  if valid_568827 != nil:
    section.add "networkSecurityGroupName", valid_568827
  var valid_568828 = path.getOrDefault("securityRuleName")
  valid_568828 = validateParameter(valid_568828, JString, required = true,
                                 default = nil)
  if valid_568828 != nil:
    section.add "securityRuleName", valid_568828
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568829 = query.getOrDefault("api-version")
  valid_568829 = validateParameter(valid_568829, JString, required = true,
                                 default = nil)
  if valid_568829 != nil:
    section.add "api-version", valid_568829
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

proc call*(call_568831: Call_SecurityRulesCreateOrUpdate_568822; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put network security rule operation creates/updates a security rule in the specified network security group
  ## 
  let valid = call_568831.validator(path, query, header, formData, body)
  let scheme = call_568831.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568831.url(scheme.get, call_568831.host, call_568831.base,
                         call_568831.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568831, url, valid)

proc call*(call_568832: Call_SecurityRulesCreateOrUpdate_568822;
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
  var path_568833 = newJObject()
  var query_568834 = newJObject()
  var body_568835 = newJObject()
  add(path_568833, "resourceGroupName", newJString(resourceGroupName))
  add(query_568834, "api-version", newJString(apiVersion))
  add(path_568833, "subscriptionId", newJString(subscriptionId))
  add(path_568833, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  add(path_568833, "securityRuleName", newJString(securityRuleName))
  if securityRuleParameters != nil:
    body_568835 = securityRuleParameters
  result = call_568832.call(path_568833, query_568834, nil, nil, body_568835)

var securityRulesCreateOrUpdate* = Call_SecurityRulesCreateOrUpdate_568822(
    name: "securityRulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}/securityRules/{securityRuleName}",
    validator: validate_SecurityRulesCreateOrUpdate_568823, base: "",
    url: url_SecurityRulesCreateOrUpdate_568824, schemes: {Scheme.Https})
type
  Call_SecurityRulesGet_568810 = ref object of OpenApiRestCall_567650
proc url_SecurityRulesGet_568812(protocol: Scheme; host: string; base: string;
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

proc validate_SecurityRulesGet_568811(path: JsonNode; query: JsonNode;
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
  var valid_568813 = path.getOrDefault("resourceGroupName")
  valid_568813 = validateParameter(valid_568813, JString, required = true,
                                 default = nil)
  if valid_568813 != nil:
    section.add "resourceGroupName", valid_568813
  var valid_568814 = path.getOrDefault("subscriptionId")
  valid_568814 = validateParameter(valid_568814, JString, required = true,
                                 default = nil)
  if valid_568814 != nil:
    section.add "subscriptionId", valid_568814
  var valid_568815 = path.getOrDefault("networkSecurityGroupName")
  valid_568815 = validateParameter(valid_568815, JString, required = true,
                                 default = nil)
  if valid_568815 != nil:
    section.add "networkSecurityGroupName", valid_568815
  var valid_568816 = path.getOrDefault("securityRuleName")
  valid_568816 = validateParameter(valid_568816, JString, required = true,
                                 default = nil)
  if valid_568816 != nil:
    section.add "securityRuleName", valid_568816
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568817 = query.getOrDefault("api-version")
  valid_568817 = validateParameter(valid_568817, JString, required = true,
                                 default = nil)
  if valid_568817 != nil:
    section.add "api-version", valid_568817
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568818: Call_SecurityRulesGet_568810; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get NetworkSecurityRule operation retrieves information about the specified network security rule.
  ## 
  let valid = call_568818.validator(path, query, header, formData, body)
  let scheme = call_568818.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568818.url(scheme.get, call_568818.host, call_568818.base,
                         call_568818.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568818, url, valid)

proc call*(call_568819: Call_SecurityRulesGet_568810; resourceGroupName: string;
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
  var path_568820 = newJObject()
  var query_568821 = newJObject()
  add(path_568820, "resourceGroupName", newJString(resourceGroupName))
  add(query_568821, "api-version", newJString(apiVersion))
  add(path_568820, "subscriptionId", newJString(subscriptionId))
  add(path_568820, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  add(path_568820, "securityRuleName", newJString(securityRuleName))
  result = call_568819.call(path_568820, query_568821, nil, nil, nil)

var securityRulesGet* = Call_SecurityRulesGet_568810(name: "securityRulesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}/securityRules/{securityRuleName}",
    validator: validate_SecurityRulesGet_568811, base: "",
    url: url_SecurityRulesGet_568812, schemes: {Scheme.Https})
type
  Call_SecurityRulesDelete_568836 = ref object of OpenApiRestCall_567650
proc url_SecurityRulesDelete_568838(protocol: Scheme; host: string; base: string;
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

proc validate_SecurityRulesDelete_568837(path: JsonNode; query: JsonNode;
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
  var valid_568839 = path.getOrDefault("resourceGroupName")
  valid_568839 = validateParameter(valid_568839, JString, required = true,
                                 default = nil)
  if valid_568839 != nil:
    section.add "resourceGroupName", valid_568839
  var valid_568840 = path.getOrDefault("subscriptionId")
  valid_568840 = validateParameter(valid_568840, JString, required = true,
                                 default = nil)
  if valid_568840 != nil:
    section.add "subscriptionId", valid_568840
  var valid_568841 = path.getOrDefault("networkSecurityGroupName")
  valid_568841 = validateParameter(valid_568841, JString, required = true,
                                 default = nil)
  if valid_568841 != nil:
    section.add "networkSecurityGroupName", valid_568841
  var valid_568842 = path.getOrDefault("securityRuleName")
  valid_568842 = validateParameter(valid_568842, JString, required = true,
                                 default = nil)
  if valid_568842 != nil:
    section.add "securityRuleName", valid_568842
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568843 = query.getOrDefault("api-version")
  valid_568843 = validateParameter(valid_568843, JString, required = true,
                                 default = nil)
  if valid_568843 != nil:
    section.add "api-version", valid_568843
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568844: Call_SecurityRulesDelete_568836; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete network security rule operation deletes the specified network security rule.
  ## 
  let valid = call_568844.validator(path, query, header, formData, body)
  let scheme = call_568844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568844.url(scheme.get, call_568844.host, call_568844.base,
                         call_568844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568844, url, valid)

proc call*(call_568845: Call_SecurityRulesDelete_568836; resourceGroupName: string;
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
  var path_568846 = newJObject()
  var query_568847 = newJObject()
  add(path_568846, "resourceGroupName", newJString(resourceGroupName))
  add(query_568847, "api-version", newJString(apiVersion))
  add(path_568846, "subscriptionId", newJString(subscriptionId))
  add(path_568846, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  add(path_568846, "securityRuleName", newJString(securityRuleName))
  result = call_568845.call(path_568846, query_568847, nil, nil, nil)

var securityRulesDelete* = Call_SecurityRulesDelete_568836(
    name: "securityRulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}/securityRules/{securityRuleName}",
    validator: validate_SecurityRulesDelete_568837, base: "",
    url: url_SecurityRulesDelete_568838, schemes: {Scheme.Https})
type
  Call_PublicIpAddressesList_568848 = ref object of OpenApiRestCall_567650
proc url_PublicIpAddressesList_568850(protocol: Scheme; host: string; base: string;
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

proc validate_PublicIpAddressesList_568849(path: JsonNode; query: JsonNode;
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
  var valid_568851 = path.getOrDefault("resourceGroupName")
  valid_568851 = validateParameter(valid_568851, JString, required = true,
                                 default = nil)
  if valid_568851 != nil:
    section.add "resourceGroupName", valid_568851
  var valid_568852 = path.getOrDefault("subscriptionId")
  valid_568852 = validateParameter(valid_568852, JString, required = true,
                                 default = nil)
  if valid_568852 != nil:
    section.add "subscriptionId", valid_568852
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568853 = query.getOrDefault("api-version")
  valid_568853 = validateParameter(valid_568853, JString, required = true,
                                 default = nil)
  if valid_568853 != nil:
    section.add "api-version", valid_568853
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568854: Call_PublicIpAddressesList_568848; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List publicIpAddress operation retrieves all the publicIpAddresses in a resource group.
  ## 
  let valid = call_568854.validator(path, query, header, formData, body)
  let scheme = call_568854.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568854.url(scheme.get, call_568854.host, call_568854.base,
                         call_568854.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568854, url, valid)

proc call*(call_568855: Call_PublicIpAddressesList_568848;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## publicIpAddressesList
  ## The List publicIpAddress operation retrieves all the publicIpAddresses in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568856 = newJObject()
  var query_568857 = newJObject()
  add(path_568856, "resourceGroupName", newJString(resourceGroupName))
  add(query_568857, "api-version", newJString(apiVersion))
  add(path_568856, "subscriptionId", newJString(subscriptionId))
  result = call_568855.call(path_568856, query_568857, nil, nil, nil)

var publicIpAddressesList* = Call_PublicIpAddressesList_568848(
    name: "publicIpAddressesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses",
    validator: validate_PublicIpAddressesList_568849, base: "",
    url: url_PublicIpAddressesList_568850, schemes: {Scheme.Https})
type
  Call_PublicIpAddressesCreateOrUpdate_568869 = ref object of OpenApiRestCall_567650
proc url_PublicIpAddressesCreateOrUpdate_568871(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "publicIpAddressName"),
               (kind: ConstantSegment, value: "/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PublicIpAddressesCreateOrUpdate_568870(path: JsonNode;
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
  var valid_568872 = path.getOrDefault("resourceGroupName")
  valid_568872 = validateParameter(valid_568872, JString, required = true,
                                 default = nil)
  if valid_568872 != nil:
    section.add "resourceGroupName", valid_568872
  var valid_568873 = path.getOrDefault("publicIpAddressName")
  valid_568873 = validateParameter(valid_568873, JString, required = true,
                                 default = nil)
  if valid_568873 != nil:
    section.add "publicIpAddressName", valid_568873
  var valid_568874 = path.getOrDefault("subscriptionId")
  valid_568874 = validateParameter(valid_568874, JString, required = true,
                                 default = nil)
  if valid_568874 != nil:
    section.add "subscriptionId", valid_568874
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568875 = query.getOrDefault("api-version")
  valid_568875 = validateParameter(valid_568875, JString, required = true,
                                 default = nil)
  if valid_568875 != nil:
    section.add "api-version", valid_568875
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

proc call*(call_568877: Call_PublicIpAddressesCreateOrUpdate_568869;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put PublicIPAddress operation creates/updates a stable/dynamic PublicIP address
  ## 
  let valid = call_568877.validator(path, query, header, formData, body)
  let scheme = call_568877.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568877.url(scheme.get, call_568877.host, call_568877.base,
                         call_568877.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568877, url, valid)

proc call*(call_568878: Call_PublicIpAddressesCreateOrUpdate_568869;
          resourceGroupName: string; apiVersion: string;
          publicIpAddressName: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## publicIpAddressesCreateOrUpdate
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
  var path_568879 = newJObject()
  var query_568880 = newJObject()
  var body_568881 = newJObject()
  add(path_568879, "resourceGroupName", newJString(resourceGroupName))
  add(query_568880, "api-version", newJString(apiVersion))
  add(path_568879, "publicIpAddressName", newJString(publicIpAddressName))
  add(path_568879, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568881 = parameters
  result = call_568878.call(path_568879, query_568880, nil, nil, body_568881)

var publicIpAddressesCreateOrUpdate* = Call_PublicIpAddressesCreateOrUpdate_568869(
    name: "publicIpAddressesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses/{publicIpAddressName}/",
    validator: validate_PublicIpAddressesCreateOrUpdate_568870, base: "",
    url: url_PublicIpAddressesCreateOrUpdate_568871, schemes: {Scheme.Https})
type
  Call_PublicIpAddressesGet_568858 = ref object of OpenApiRestCall_567650
proc url_PublicIpAddressesGet_568860(protocol: Scheme; host: string; base: string;
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
               (kind: VariableSegment, value: "publicIpAddressName"),
               (kind: ConstantSegment, value: "/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PublicIpAddressesGet_568859(path: JsonNode; query: JsonNode;
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
  var valid_568861 = path.getOrDefault("resourceGroupName")
  valid_568861 = validateParameter(valid_568861, JString, required = true,
                                 default = nil)
  if valid_568861 != nil:
    section.add "resourceGroupName", valid_568861
  var valid_568862 = path.getOrDefault("publicIpAddressName")
  valid_568862 = validateParameter(valid_568862, JString, required = true,
                                 default = nil)
  if valid_568862 != nil:
    section.add "publicIpAddressName", valid_568862
  var valid_568863 = path.getOrDefault("subscriptionId")
  valid_568863 = validateParameter(valid_568863, JString, required = true,
                                 default = nil)
  if valid_568863 != nil:
    section.add "subscriptionId", valid_568863
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568864 = query.getOrDefault("api-version")
  valid_568864 = validateParameter(valid_568864, JString, required = true,
                                 default = nil)
  if valid_568864 != nil:
    section.add "api-version", valid_568864
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568865: Call_PublicIpAddressesGet_568858; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get publicIpAddress operation retrieves information about the specified pubicIpAddress
  ## 
  let valid = call_568865.validator(path, query, header, formData, body)
  let scheme = call_568865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568865.url(scheme.get, call_568865.host, call_568865.base,
                         call_568865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568865, url, valid)

proc call*(call_568866: Call_PublicIpAddressesGet_568858;
          resourceGroupName: string; apiVersion: string;
          publicIpAddressName: string; subscriptionId: string): Recallable =
  ## publicIpAddressesGet
  ## The Get publicIpAddress operation retrieves information about the specified pubicIpAddress
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   publicIpAddressName: string (required)
  ##                      : The name of the subnet.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568867 = newJObject()
  var query_568868 = newJObject()
  add(path_568867, "resourceGroupName", newJString(resourceGroupName))
  add(query_568868, "api-version", newJString(apiVersion))
  add(path_568867, "publicIpAddressName", newJString(publicIpAddressName))
  add(path_568867, "subscriptionId", newJString(subscriptionId))
  result = call_568866.call(path_568867, query_568868, nil, nil, nil)

var publicIpAddressesGet* = Call_PublicIpAddressesGet_568858(
    name: "publicIpAddressesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses/{publicIpAddressName}/",
    validator: validate_PublicIpAddressesGet_568859, base: "",
    url: url_PublicIpAddressesGet_568860, schemes: {Scheme.Https})
type
  Call_PublicIpAddressesDelete_568882 = ref object of OpenApiRestCall_567650
proc url_PublicIpAddressesDelete_568884(protocol: Scheme; host: string; base: string;
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
               (kind: VariableSegment, value: "publicIpAddressName"),
               (kind: ConstantSegment, value: "/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PublicIpAddressesDelete_568883(path: JsonNode; query: JsonNode;
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
  var valid_568885 = path.getOrDefault("resourceGroupName")
  valid_568885 = validateParameter(valid_568885, JString, required = true,
                                 default = nil)
  if valid_568885 != nil:
    section.add "resourceGroupName", valid_568885
  var valid_568886 = path.getOrDefault("publicIpAddressName")
  valid_568886 = validateParameter(valid_568886, JString, required = true,
                                 default = nil)
  if valid_568886 != nil:
    section.add "publicIpAddressName", valid_568886
  var valid_568887 = path.getOrDefault("subscriptionId")
  valid_568887 = validateParameter(valid_568887, JString, required = true,
                                 default = nil)
  if valid_568887 != nil:
    section.add "subscriptionId", valid_568887
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568888 = query.getOrDefault("api-version")
  valid_568888 = validateParameter(valid_568888, JString, required = true,
                                 default = nil)
  if valid_568888 != nil:
    section.add "api-version", valid_568888
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568889: Call_PublicIpAddressesDelete_568882; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete publicIpAddress operation deletes the specified publicIpAddress.
  ## 
  let valid = call_568889.validator(path, query, header, formData, body)
  let scheme = call_568889.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568889.url(scheme.get, call_568889.host, call_568889.base,
                         call_568889.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568889, url, valid)

proc call*(call_568890: Call_PublicIpAddressesDelete_568882;
          resourceGroupName: string; apiVersion: string;
          publicIpAddressName: string; subscriptionId: string): Recallable =
  ## publicIpAddressesDelete
  ## The delete publicIpAddress operation deletes the specified publicIpAddress.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   publicIpAddressName: string (required)
  ##                      : The name of the subnet.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568891 = newJObject()
  var query_568892 = newJObject()
  add(path_568891, "resourceGroupName", newJString(resourceGroupName))
  add(query_568892, "api-version", newJString(apiVersion))
  add(path_568891, "publicIpAddressName", newJString(publicIpAddressName))
  add(path_568891, "subscriptionId", newJString(subscriptionId))
  result = call_568890.call(path_568891, query_568892, nil, nil, nil)

var publicIpAddressesDelete* = Call_PublicIpAddressesDelete_568882(
    name: "publicIpAddressesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses/{publicIpAddressName}/",
    validator: validate_PublicIpAddressesDelete_568883, base: "",
    url: url_PublicIpAddressesDelete_568884, schemes: {Scheme.Https})
type
  Call_RouteTablesList_568893 = ref object of OpenApiRestCall_567650
proc url_RouteTablesList_568895(protocol: Scheme; host: string; base: string;
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

proc validate_RouteTablesList_568894(path: JsonNode; query: JsonNode;
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
  var valid_568896 = path.getOrDefault("resourceGroupName")
  valid_568896 = validateParameter(valid_568896, JString, required = true,
                                 default = nil)
  if valid_568896 != nil:
    section.add "resourceGroupName", valid_568896
  var valid_568897 = path.getOrDefault("subscriptionId")
  valid_568897 = validateParameter(valid_568897, JString, required = true,
                                 default = nil)
  if valid_568897 != nil:
    section.add "subscriptionId", valid_568897
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568898 = query.getOrDefault("api-version")
  valid_568898 = validateParameter(valid_568898, JString, required = true,
                                 default = nil)
  if valid_568898 != nil:
    section.add "api-version", valid_568898
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568899: Call_RouteTablesList_568893; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list RouteTables returns all route tables in a resource group
  ## 
  let valid = call_568899.validator(path, query, header, formData, body)
  let scheme = call_568899.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568899.url(scheme.get, call_568899.host, call_568899.base,
                         call_568899.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568899, url, valid)

proc call*(call_568900: Call_RouteTablesList_568893; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## routeTablesList
  ## The list RouteTables returns all route tables in a resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568901 = newJObject()
  var query_568902 = newJObject()
  add(path_568901, "resourceGroupName", newJString(resourceGroupName))
  add(query_568902, "api-version", newJString(apiVersion))
  add(path_568901, "subscriptionId", newJString(subscriptionId))
  result = call_568900.call(path_568901, query_568902, nil, nil, nil)

var routeTablesList* = Call_RouteTablesList_568893(name: "routeTablesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables",
    validator: validate_RouteTablesList_568894, base: "", url: url_RouteTablesList_568895,
    schemes: {Scheme.Https})
type
  Call_RouteTablesCreateOrUpdate_568914 = ref object of OpenApiRestCall_567650
proc url_RouteTablesCreateOrUpdate_568916(protocol: Scheme; host: string;
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

proc validate_RouteTablesCreateOrUpdate_568915(path: JsonNode; query: JsonNode;
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
  var valid_568917 = path.getOrDefault("resourceGroupName")
  valid_568917 = validateParameter(valid_568917, JString, required = true,
                                 default = nil)
  if valid_568917 != nil:
    section.add "resourceGroupName", valid_568917
  var valid_568918 = path.getOrDefault("routeTableName")
  valid_568918 = validateParameter(valid_568918, JString, required = true,
                                 default = nil)
  if valid_568918 != nil:
    section.add "routeTableName", valid_568918
  var valid_568919 = path.getOrDefault("subscriptionId")
  valid_568919 = validateParameter(valid_568919, JString, required = true,
                                 default = nil)
  if valid_568919 != nil:
    section.add "subscriptionId", valid_568919
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568920 = query.getOrDefault("api-version")
  valid_568920 = validateParameter(valid_568920, JString, required = true,
                                 default = nil)
  if valid_568920 != nil:
    section.add "api-version", valid_568920
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

proc call*(call_568922: Call_RouteTablesCreateOrUpdate_568914; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put RouteTable operation creates/updates a route table in the specified resource group.
  ## 
  let valid = call_568922.validator(path, query, header, formData, body)
  let scheme = call_568922.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568922.url(scheme.get, call_568922.host, call_568922.base,
                         call_568922.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568922, url, valid)

proc call*(call_568923: Call_RouteTablesCreateOrUpdate_568914;
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
  var path_568924 = newJObject()
  var query_568925 = newJObject()
  var body_568926 = newJObject()
  add(path_568924, "resourceGroupName", newJString(resourceGroupName))
  add(path_568924, "routeTableName", newJString(routeTableName))
  add(query_568925, "api-version", newJString(apiVersion))
  add(path_568924, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568926 = parameters
  result = call_568923.call(path_568924, query_568925, nil, nil, body_568926)

var routeTablesCreateOrUpdate* = Call_RouteTablesCreateOrUpdate_568914(
    name: "routeTablesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}",
    validator: validate_RouteTablesCreateOrUpdate_568915, base: "",
    url: url_RouteTablesCreateOrUpdate_568916, schemes: {Scheme.Https})
type
  Call_RouteTablesGet_568903 = ref object of OpenApiRestCall_567650
proc url_RouteTablesGet_568905(protocol: Scheme; host: string; base: string;
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

proc validate_RouteTablesGet_568904(path: JsonNode; query: JsonNode;
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
  var valid_568906 = path.getOrDefault("resourceGroupName")
  valid_568906 = validateParameter(valid_568906, JString, required = true,
                                 default = nil)
  if valid_568906 != nil:
    section.add "resourceGroupName", valid_568906
  var valid_568907 = path.getOrDefault("routeTableName")
  valid_568907 = validateParameter(valid_568907, JString, required = true,
                                 default = nil)
  if valid_568907 != nil:
    section.add "routeTableName", valid_568907
  var valid_568908 = path.getOrDefault("subscriptionId")
  valid_568908 = validateParameter(valid_568908, JString, required = true,
                                 default = nil)
  if valid_568908 != nil:
    section.add "subscriptionId", valid_568908
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568909 = query.getOrDefault("api-version")
  valid_568909 = validateParameter(valid_568909, JString, required = true,
                                 default = nil)
  if valid_568909 != nil:
    section.add "api-version", valid_568909
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568910: Call_RouteTablesGet_568903; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get RouteTables operation retrieves information about the specified route table.
  ## 
  let valid = call_568910.validator(path, query, header, formData, body)
  let scheme = call_568910.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568910.url(scheme.get, call_568910.host, call_568910.base,
                         call_568910.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568910, url, valid)

proc call*(call_568911: Call_RouteTablesGet_568903; resourceGroupName: string;
          routeTableName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## routeTablesGet
  ## The Get RouteTables operation retrieves information about the specified route table.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   routeTableName: string (required)
  ##                 : The name of the route table.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568912 = newJObject()
  var query_568913 = newJObject()
  add(path_568912, "resourceGroupName", newJString(resourceGroupName))
  add(path_568912, "routeTableName", newJString(routeTableName))
  add(query_568913, "api-version", newJString(apiVersion))
  add(path_568912, "subscriptionId", newJString(subscriptionId))
  result = call_568911.call(path_568912, query_568913, nil, nil, nil)

var routeTablesGet* = Call_RouteTablesGet_568903(name: "routeTablesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}",
    validator: validate_RouteTablesGet_568904, base: "", url: url_RouteTablesGet_568905,
    schemes: {Scheme.Https})
type
  Call_RouteTablesDelete_568927 = ref object of OpenApiRestCall_567650
proc url_RouteTablesDelete_568929(protocol: Scheme; host: string; base: string;
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

proc validate_RouteTablesDelete_568928(path: JsonNode; query: JsonNode;
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
  var valid_568930 = path.getOrDefault("resourceGroupName")
  valid_568930 = validateParameter(valid_568930, JString, required = true,
                                 default = nil)
  if valid_568930 != nil:
    section.add "resourceGroupName", valid_568930
  var valid_568931 = path.getOrDefault("routeTableName")
  valid_568931 = validateParameter(valid_568931, JString, required = true,
                                 default = nil)
  if valid_568931 != nil:
    section.add "routeTableName", valid_568931
  var valid_568932 = path.getOrDefault("subscriptionId")
  valid_568932 = validateParameter(valid_568932, JString, required = true,
                                 default = nil)
  if valid_568932 != nil:
    section.add "subscriptionId", valid_568932
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568933 = query.getOrDefault("api-version")
  valid_568933 = validateParameter(valid_568933, JString, required = true,
                                 default = nil)
  if valid_568933 != nil:
    section.add "api-version", valid_568933
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568934: Call_RouteTablesDelete_568927; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete RouteTable operation deletes the specified Route Table
  ## 
  let valid = call_568934.validator(path, query, header, formData, body)
  let scheme = call_568934.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568934.url(scheme.get, call_568934.host, call_568934.base,
                         call_568934.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568934, url, valid)

proc call*(call_568935: Call_RouteTablesDelete_568927; resourceGroupName: string;
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
  var path_568936 = newJObject()
  var query_568937 = newJObject()
  add(path_568936, "resourceGroupName", newJString(resourceGroupName))
  add(path_568936, "routeTableName", newJString(routeTableName))
  add(query_568937, "api-version", newJString(apiVersion))
  add(path_568936, "subscriptionId", newJString(subscriptionId))
  result = call_568935.call(path_568936, query_568937, nil, nil, nil)

var routeTablesDelete* = Call_RouteTablesDelete_568927(name: "routeTablesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}",
    validator: validate_RouteTablesDelete_568928, base: "",
    url: url_RouteTablesDelete_568929, schemes: {Scheme.Https})
type
  Call_RoutesList_568938 = ref object of OpenApiRestCall_567650
proc url_RoutesList_568940(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_RoutesList_568939(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568941 = path.getOrDefault("resourceGroupName")
  valid_568941 = validateParameter(valid_568941, JString, required = true,
                                 default = nil)
  if valid_568941 != nil:
    section.add "resourceGroupName", valid_568941
  var valid_568942 = path.getOrDefault("routeTableName")
  valid_568942 = validateParameter(valid_568942, JString, required = true,
                                 default = nil)
  if valid_568942 != nil:
    section.add "routeTableName", valid_568942
  var valid_568943 = path.getOrDefault("subscriptionId")
  valid_568943 = validateParameter(valid_568943, JString, required = true,
                                 default = nil)
  if valid_568943 != nil:
    section.add "subscriptionId", valid_568943
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568944 = query.getOrDefault("api-version")
  valid_568944 = validateParameter(valid_568944, JString, required = true,
                                 default = nil)
  if valid_568944 != nil:
    section.add "api-version", valid_568944
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568945: Call_RoutesList_568938; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List network security rule operation retrieves all the routes in a route table.
  ## 
  let valid = call_568945.validator(path, query, header, formData, body)
  let scheme = call_568945.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568945.url(scheme.get, call_568945.host, call_568945.base,
                         call_568945.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568945, url, valid)

proc call*(call_568946: Call_RoutesList_568938; resourceGroupName: string;
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
  var path_568947 = newJObject()
  var query_568948 = newJObject()
  add(path_568947, "resourceGroupName", newJString(resourceGroupName))
  add(path_568947, "routeTableName", newJString(routeTableName))
  add(query_568948, "api-version", newJString(apiVersion))
  add(path_568947, "subscriptionId", newJString(subscriptionId))
  result = call_568946.call(path_568947, query_568948, nil, nil, nil)

var routesList* = Call_RoutesList_568938(name: "routesList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}/routes",
                                      validator: validate_RoutesList_568939,
                                      base: "", url: url_RoutesList_568940,
                                      schemes: {Scheme.Https})
type
  Call_RoutesCreateOrUpdate_568961 = ref object of OpenApiRestCall_567650
proc url_RoutesCreateOrUpdate_568963(protocol: Scheme; host: string; base: string;
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

proc validate_RoutesCreateOrUpdate_568962(path: JsonNode; query: JsonNode;
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
  var valid_568964 = path.getOrDefault("resourceGroupName")
  valid_568964 = validateParameter(valid_568964, JString, required = true,
                                 default = nil)
  if valid_568964 != nil:
    section.add "resourceGroupName", valid_568964
  var valid_568965 = path.getOrDefault("routeTableName")
  valid_568965 = validateParameter(valid_568965, JString, required = true,
                                 default = nil)
  if valid_568965 != nil:
    section.add "routeTableName", valid_568965
  var valid_568966 = path.getOrDefault("subscriptionId")
  valid_568966 = validateParameter(valid_568966, JString, required = true,
                                 default = nil)
  if valid_568966 != nil:
    section.add "subscriptionId", valid_568966
  var valid_568967 = path.getOrDefault("routeName")
  valid_568967 = validateParameter(valid_568967, JString, required = true,
                                 default = nil)
  if valid_568967 != nil:
    section.add "routeName", valid_568967
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568968 = query.getOrDefault("api-version")
  valid_568968 = validateParameter(valid_568968, JString, required = true,
                                 default = nil)
  if valid_568968 != nil:
    section.add "api-version", valid_568968
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

proc call*(call_568970: Call_RoutesCreateOrUpdate_568961; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put route operation creates/updates a route in the specified route table
  ## 
  let valid = call_568970.validator(path, query, header, formData, body)
  let scheme = call_568970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568970.url(scheme.get, call_568970.host, call_568970.base,
                         call_568970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568970, url, valid)

proc call*(call_568971: Call_RoutesCreateOrUpdate_568961;
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
  var path_568972 = newJObject()
  var query_568973 = newJObject()
  var body_568974 = newJObject()
  add(path_568972, "resourceGroupName", newJString(resourceGroupName))
  add(path_568972, "routeTableName", newJString(routeTableName))
  add(query_568973, "api-version", newJString(apiVersion))
  add(path_568972, "subscriptionId", newJString(subscriptionId))
  add(path_568972, "routeName", newJString(routeName))
  if routeParameters != nil:
    body_568974 = routeParameters
  result = call_568971.call(path_568972, query_568973, nil, nil, body_568974)

var routesCreateOrUpdate* = Call_RoutesCreateOrUpdate_568961(
    name: "routesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}/routes/{routeName}",
    validator: validate_RoutesCreateOrUpdate_568962, base: "",
    url: url_RoutesCreateOrUpdate_568963, schemes: {Scheme.Https})
type
  Call_RoutesGet_568949 = ref object of OpenApiRestCall_567650
proc url_RoutesGet_568951(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_RoutesGet_568950(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568952 = path.getOrDefault("resourceGroupName")
  valid_568952 = validateParameter(valid_568952, JString, required = true,
                                 default = nil)
  if valid_568952 != nil:
    section.add "resourceGroupName", valid_568952
  var valid_568953 = path.getOrDefault("routeTableName")
  valid_568953 = validateParameter(valid_568953, JString, required = true,
                                 default = nil)
  if valid_568953 != nil:
    section.add "routeTableName", valid_568953
  var valid_568954 = path.getOrDefault("subscriptionId")
  valid_568954 = validateParameter(valid_568954, JString, required = true,
                                 default = nil)
  if valid_568954 != nil:
    section.add "subscriptionId", valid_568954
  var valid_568955 = path.getOrDefault("routeName")
  valid_568955 = validateParameter(valid_568955, JString, required = true,
                                 default = nil)
  if valid_568955 != nil:
    section.add "routeName", valid_568955
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568956 = query.getOrDefault("api-version")
  valid_568956 = validateParameter(valid_568956, JString, required = true,
                                 default = nil)
  if valid_568956 != nil:
    section.add "api-version", valid_568956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568957: Call_RoutesGet_568949; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get route operation retrieves information about the specified route from the route table.
  ## 
  let valid = call_568957.validator(path, query, header, formData, body)
  let scheme = call_568957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568957.url(scheme.get, call_568957.host, call_568957.base,
                         call_568957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568957, url, valid)

proc call*(call_568958: Call_RoutesGet_568949; resourceGroupName: string;
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
  var path_568959 = newJObject()
  var query_568960 = newJObject()
  add(path_568959, "resourceGroupName", newJString(resourceGroupName))
  add(path_568959, "routeTableName", newJString(routeTableName))
  add(query_568960, "api-version", newJString(apiVersion))
  add(path_568959, "subscriptionId", newJString(subscriptionId))
  add(path_568959, "routeName", newJString(routeName))
  result = call_568958.call(path_568959, query_568960, nil, nil, nil)

var routesGet* = Call_RoutesGet_568949(name: "routesGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}/routes/{routeName}",
                                    validator: validate_RoutesGet_568950,
                                    base: "", url: url_RoutesGet_568951,
                                    schemes: {Scheme.Https})
type
  Call_RoutesDelete_568975 = ref object of OpenApiRestCall_567650
proc url_RoutesDelete_568977(protocol: Scheme; host: string; base: string;
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

proc validate_RoutesDelete_568976(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568978 = path.getOrDefault("resourceGroupName")
  valid_568978 = validateParameter(valid_568978, JString, required = true,
                                 default = nil)
  if valid_568978 != nil:
    section.add "resourceGroupName", valid_568978
  var valid_568979 = path.getOrDefault("routeTableName")
  valid_568979 = validateParameter(valid_568979, JString, required = true,
                                 default = nil)
  if valid_568979 != nil:
    section.add "routeTableName", valid_568979
  var valid_568980 = path.getOrDefault("subscriptionId")
  valid_568980 = validateParameter(valid_568980, JString, required = true,
                                 default = nil)
  if valid_568980 != nil:
    section.add "subscriptionId", valid_568980
  var valid_568981 = path.getOrDefault("routeName")
  valid_568981 = validateParameter(valid_568981, JString, required = true,
                                 default = nil)
  if valid_568981 != nil:
    section.add "routeName", valid_568981
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568982 = query.getOrDefault("api-version")
  valid_568982 = validateParameter(valid_568982, JString, required = true,
                                 default = nil)
  if valid_568982 != nil:
    section.add "api-version", valid_568982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568983: Call_RoutesDelete_568975; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete route operation deletes the specified route from a route table.
  ## 
  let valid = call_568983.validator(path, query, header, formData, body)
  let scheme = call_568983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568983.url(scheme.get, call_568983.host, call_568983.base,
                         call_568983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568983, url, valid)

proc call*(call_568984: Call_RoutesDelete_568975; resourceGroupName: string;
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
  var path_568985 = newJObject()
  var query_568986 = newJObject()
  add(path_568985, "resourceGroupName", newJString(resourceGroupName))
  add(path_568985, "routeTableName", newJString(routeTableName))
  add(query_568986, "api-version", newJString(apiVersion))
  add(path_568985, "subscriptionId", newJString(subscriptionId))
  add(path_568985, "routeName", newJString(routeName))
  result = call_568984.call(path_568985, query_568986, nil, nil, nil)

var routesDelete* = Call_RoutesDelete_568975(name: "routesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}/routes/{routeName}",
    validator: validate_RoutesDelete_568976, base: "", url: url_RoutesDelete_568977,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysList_568987 = ref object of OpenApiRestCall_567650
proc url_VirtualNetworkGatewaysList_568989(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGatewaysList_568988(path: JsonNode; query: JsonNode;
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
  var valid_568990 = path.getOrDefault("resourceGroupName")
  valid_568990 = validateParameter(valid_568990, JString, required = true,
                                 default = nil)
  if valid_568990 != nil:
    section.add "resourceGroupName", valid_568990
  var valid_568991 = path.getOrDefault("subscriptionId")
  valid_568991 = validateParameter(valid_568991, JString, required = true,
                                 default = nil)
  if valid_568991 != nil:
    section.add "subscriptionId", valid_568991
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568992 = query.getOrDefault("api-version")
  valid_568992 = validateParameter(valid_568992, JString, required = true,
                                 default = nil)
  if valid_568992 != nil:
    section.add "api-version", valid_568992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568993: Call_VirtualNetworkGatewaysList_568987; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List VirtualNetworkGateways operation retrieves all the virtual network gateways stored.
  ## 
  let valid = call_568993.validator(path, query, header, formData, body)
  let scheme = call_568993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568993.url(scheme.get, call_568993.host, call_568993.base,
                         call_568993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568993, url, valid)

proc call*(call_568994: Call_VirtualNetworkGatewaysList_568987;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualNetworkGatewaysList
  ## The List VirtualNetworkGateways operation retrieves all the virtual network gateways stored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568995 = newJObject()
  var query_568996 = newJObject()
  add(path_568995, "resourceGroupName", newJString(resourceGroupName))
  add(query_568996, "api-version", newJString(apiVersion))
  add(path_568995, "subscriptionId", newJString(subscriptionId))
  result = call_568994.call(path_568995, query_568996, nil, nil, nil)

var virtualNetworkGatewaysList* = Call_VirtualNetworkGatewaysList_568987(
    name: "virtualNetworkGatewaysList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways",
    validator: validate_VirtualNetworkGatewaysList_568988, base: "",
    url: url_VirtualNetworkGatewaysList_568989, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysDelete_568997 = ref object of OpenApiRestCall_567650
proc url_VirtualNetworkGatewaysDelete_568999(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysDelete_568998(path: JsonNode; query: JsonNode;
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
  var valid_569000 = path.getOrDefault("resourceGroupName")
  valid_569000 = validateParameter(valid_569000, JString, required = true,
                                 default = nil)
  if valid_569000 != nil:
    section.add "resourceGroupName", valid_569000
  var valid_569001 = path.getOrDefault("subscriptionId")
  valid_569001 = validateParameter(valid_569001, JString, required = true,
                                 default = nil)
  if valid_569001 != nil:
    section.add "subscriptionId", valid_569001
  var valid_569002 = path.getOrDefault("virtualNetworkGatewayName")
  valid_569002 = validateParameter(valid_569002, JString, required = true,
                                 default = nil)
  if valid_569002 != nil:
    section.add "virtualNetworkGatewayName", valid_569002
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569003 = query.getOrDefault("api-version")
  valid_569003 = validateParameter(valid_569003, JString, required = true,
                                 default = nil)
  if valid_569003 != nil:
    section.add "api-version", valid_569003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569004: Call_VirtualNetworkGatewaysDelete_568997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete VirtualNetworkGateway operation deletes the specified virtual network Gateway through Network resource provider.
  ## 
  let valid = call_569004.validator(path, query, header, formData, body)
  let scheme = call_569004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569004.url(scheme.get, call_569004.host, call_569004.base,
                         call_569004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569004, url, valid)

proc call*(call_569005: Call_VirtualNetworkGatewaysDelete_568997;
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
  var path_569006 = newJObject()
  var query_569007 = newJObject()
  add(path_569006, "resourceGroupName", newJString(resourceGroupName))
  add(query_569007, "api-version", newJString(apiVersion))
  add(path_569006, "subscriptionId", newJString(subscriptionId))
  add(path_569006, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_569005.call(path_569006, query_569007, nil, nil, nil)

var virtualNetworkGatewaysDelete* = Call_VirtualNetworkGatewaysDelete_568997(
    name: "virtualNetworkGatewaysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/",
    validator: validate_VirtualNetworkGatewaysDelete_568998, base: "",
    url: url_VirtualNetworkGatewaysDelete_568999, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysCreateOrUpdate_569019 = ref object of OpenApiRestCall_567650
proc url_VirtualNetworkGatewaysCreateOrUpdate_569021(protocol: Scheme;
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
        value: "/providers/Microsoft.Network/virtualnetworkgateways/"),
               (kind: VariableSegment, value: "virtualNetworkGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysCreateOrUpdate_569020(path: JsonNode;
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
  var valid_569022 = path.getOrDefault("resourceGroupName")
  valid_569022 = validateParameter(valid_569022, JString, required = true,
                                 default = nil)
  if valid_569022 != nil:
    section.add "resourceGroupName", valid_569022
  var valid_569023 = path.getOrDefault("subscriptionId")
  valid_569023 = validateParameter(valid_569023, JString, required = true,
                                 default = nil)
  if valid_569023 != nil:
    section.add "subscriptionId", valid_569023
  var valid_569024 = path.getOrDefault("virtualNetworkGatewayName")
  valid_569024 = validateParameter(valid_569024, JString, required = true,
                                 default = nil)
  if valid_569024 != nil:
    section.add "virtualNetworkGatewayName", valid_569024
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569025 = query.getOrDefault("api-version")
  valid_569025 = validateParameter(valid_569025, JString, required = true,
                                 default = nil)
  if valid_569025 != nil:
    section.add "api-version", valid_569025
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

proc call*(call_569027: Call_VirtualNetworkGatewaysCreateOrUpdate_569019;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put VirtualNetworkGateway operation creates/updates a virtual network gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_569027.validator(path, query, header, formData, body)
  let scheme = call_569027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569027.url(scheme.get, call_569027.host, call_569027.base,
                         call_569027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569027, url, valid)

proc call*(call_569028: Call_VirtualNetworkGatewaysCreateOrUpdate_569019;
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
  var path_569029 = newJObject()
  var query_569030 = newJObject()
  var body_569031 = newJObject()
  add(path_569029, "resourceGroupName", newJString(resourceGroupName))
  add(query_569030, "api-version", newJString(apiVersion))
  add(path_569029, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_569031 = parameters
  add(path_569029, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_569028.call(path_569029, query_569030, nil, nil, body_569031)

var virtualNetworkGatewaysCreateOrUpdate* = Call_VirtualNetworkGatewaysCreateOrUpdate_569019(
    name: "virtualNetworkGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualnetworkgateways/{virtualNetworkGatewayName}",
    validator: validate_VirtualNetworkGatewaysCreateOrUpdate_569020, base: "",
    url: url_VirtualNetworkGatewaysCreateOrUpdate_569021, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGet_569008 = ref object of OpenApiRestCall_567650
proc url_VirtualNetworkGatewaysGet_569010(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Network/virtualnetworkgateways/"),
               (kind: VariableSegment, value: "virtualNetworkGatewayName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysGet_569009(path: JsonNode; query: JsonNode;
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
  var valid_569011 = path.getOrDefault("resourceGroupName")
  valid_569011 = validateParameter(valid_569011, JString, required = true,
                                 default = nil)
  if valid_569011 != nil:
    section.add "resourceGroupName", valid_569011
  var valid_569012 = path.getOrDefault("subscriptionId")
  valid_569012 = validateParameter(valid_569012, JString, required = true,
                                 default = nil)
  if valid_569012 != nil:
    section.add "subscriptionId", valid_569012
  var valid_569013 = path.getOrDefault("virtualNetworkGatewayName")
  valid_569013 = validateParameter(valid_569013, JString, required = true,
                                 default = nil)
  if valid_569013 != nil:
    section.add "virtualNetworkGatewayName", valid_569013
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569014 = query.getOrDefault("api-version")
  valid_569014 = validateParameter(valid_569014, JString, required = true,
                                 default = nil)
  if valid_569014 != nil:
    section.add "api-version", valid_569014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569015: Call_VirtualNetworkGatewaysGet_569008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get VirtualNetworkGateway operation retrieves information about the specified virtual network gateway through Network resource provider.
  ## 
  let valid = call_569015.validator(path, query, header, formData, body)
  let scheme = call_569015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569015.url(scheme.get, call_569015.host, call_569015.base,
                         call_569015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569015, url, valid)

proc call*(call_569016: Call_VirtualNetworkGatewaysGet_569008;
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
  var path_569017 = newJObject()
  var query_569018 = newJObject()
  add(path_569017, "resourceGroupName", newJString(resourceGroupName))
  add(query_569018, "api-version", newJString(apiVersion))
  add(path_569017, "subscriptionId", newJString(subscriptionId))
  add(path_569017, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_569016.call(path_569017, query_569018, nil, nil, nil)

var virtualNetworkGatewaysGet* = Call_VirtualNetworkGatewaysGet_569008(
    name: "virtualNetworkGatewaysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualnetworkgateways/{virtualNetworkGatewayName}",
    validator: validate_VirtualNetworkGatewaysGet_569009, base: "",
    url: url_VirtualNetworkGatewaysGet_569010, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysReset_569032 = ref object of OpenApiRestCall_567650
proc url_VirtualNetworkGatewaysReset_569034(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Network/virtualnetworkgateways/"),
               (kind: VariableSegment, value: "virtualNetworkGatewayName"),
               (kind: ConstantSegment, value: "/reset")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGatewaysReset_569033(path: JsonNode; query: JsonNode;
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
  var valid_569035 = path.getOrDefault("resourceGroupName")
  valid_569035 = validateParameter(valid_569035, JString, required = true,
                                 default = nil)
  if valid_569035 != nil:
    section.add "resourceGroupName", valid_569035
  var valid_569036 = path.getOrDefault("subscriptionId")
  valid_569036 = validateParameter(valid_569036, JString, required = true,
                                 default = nil)
  if valid_569036 != nil:
    section.add "subscriptionId", valid_569036
  var valid_569037 = path.getOrDefault("virtualNetworkGatewayName")
  valid_569037 = validateParameter(valid_569037, JString, required = true,
                                 default = nil)
  if valid_569037 != nil:
    section.add "virtualNetworkGatewayName", valid_569037
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569038 = query.getOrDefault("api-version")
  valid_569038 = validateParameter(valid_569038, JString, required = true,
                                 default = nil)
  if valid_569038 != nil:
    section.add "api-version", valid_569038
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

proc call*(call_569040: Call_VirtualNetworkGatewaysReset_569032; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Reset VirtualNetworkGateway operation resets the primary of the virtual network gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_569040.validator(path, query, header, formData, body)
  let scheme = call_569040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569040.url(scheme.get, call_569040.host, call_569040.base,
                         call_569040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569040, url, valid)

proc call*(call_569041: Call_VirtualNetworkGatewaysReset_569032;
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
  var path_569042 = newJObject()
  var query_569043 = newJObject()
  var body_569044 = newJObject()
  add(path_569042, "resourceGroupName", newJString(resourceGroupName))
  add(query_569043, "api-version", newJString(apiVersion))
  add(path_569042, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_569044 = parameters
  add(path_569042, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_569041.call(path_569042, query_569043, nil, nil, body_569044)

var virtualNetworkGatewaysReset* = Call_VirtualNetworkGatewaysReset_569032(
    name: "virtualNetworkGatewaysReset", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualnetworkgateways/{virtualNetworkGatewayName}/reset",
    validator: validate_VirtualNetworkGatewaysReset_569033, base: "",
    url: url_VirtualNetworkGatewaysReset_569034, schemes: {Scheme.Https})
type
  Call_VirtualNetworksList_569045 = ref object of OpenApiRestCall_567650
proc url_VirtualNetworksList_569047(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Network/virtualnetworks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksList_569046(path: JsonNode; query: JsonNode;
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
  var valid_569048 = path.getOrDefault("resourceGroupName")
  valid_569048 = validateParameter(valid_569048, JString, required = true,
                                 default = nil)
  if valid_569048 != nil:
    section.add "resourceGroupName", valid_569048
  var valid_569049 = path.getOrDefault("subscriptionId")
  valid_569049 = validateParameter(valid_569049, JString, required = true,
                                 default = nil)
  if valid_569049 != nil:
    section.add "subscriptionId", valid_569049
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569050 = query.getOrDefault("api-version")
  valid_569050 = validateParameter(valid_569050, JString, required = true,
                                 default = nil)
  if valid_569050 != nil:
    section.add "api-version", valid_569050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569051: Call_VirtualNetworksList_569045; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list VirtualNetwork returns all Virtual Networks in a resource group
  ## 
  let valid = call_569051.validator(path, query, header, formData, body)
  let scheme = call_569051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569051.url(scheme.get, call_569051.host, call_569051.base,
                         call_569051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569051, url, valid)

proc call*(call_569052: Call_VirtualNetworksList_569045; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## virtualNetworksList
  ## The list VirtualNetwork returns all Virtual Networks in a resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_569053 = newJObject()
  var query_569054 = newJObject()
  add(path_569053, "resourceGroupName", newJString(resourceGroupName))
  add(query_569054, "api-version", newJString(apiVersion))
  add(path_569053, "subscriptionId", newJString(subscriptionId))
  result = call_569052.call(path_569053, query_569054, nil, nil, nil)

var virtualNetworksList* = Call_VirtualNetworksList_569045(
    name: "virtualNetworksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualnetworks",
    validator: validate_VirtualNetworksList_569046, base: "",
    url: url_VirtualNetworksList_569047, schemes: {Scheme.Https})
type
  Call_VirtualNetworksCreateOrUpdate_569066 = ref object of OpenApiRestCall_567650
proc url_VirtualNetworksCreateOrUpdate_569068(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Network/virtualnetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksCreateOrUpdate_569067(path: JsonNode; query: JsonNode;
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
  var valid_569069 = path.getOrDefault("resourceGroupName")
  valid_569069 = validateParameter(valid_569069, JString, required = true,
                                 default = nil)
  if valid_569069 != nil:
    section.add "resourceGroupName", valid_569069
  var valid_569070 = path.getOrDefault("subscriptionId")
  valid_569070 = validateParameter(valid_569070, JString, required = true,
                                 default = nil)
  if valid_569070 != nil:
    section.add "subscriptionId", valid_569070
  var valid_569071 = path.getOrDefault("virtualNetworkName")
  valid_569071 = validateParameter(valid_569071, JString, required = true,
                                 default = nil)
  if valid_569071 != nil:
    section.add "virtualNetworkName", valid_569071
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569072 = query.getOrDefault("api-version")
  valid_569072 = validateParameter(valid_569072, JString, required = true,
                                 default = nil)
  if valid_569072 != nil:
    section.add "api-version", valid_569072
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

proc call*(call_569074: Call_VirtualNetworksCreateOrUpdate_569066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put VirtualNetwork operation creates/updates a virtual network in the specified resource group.
  ## 
  let valid = call_569074.validator(path, query, header, formData, body)
  let scheme = call_569074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569074.url(scheme.get, call_569074.host, call_569074.base,
                         call_569074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569074, url, valid)

proc call*(call_569075: Call_VirtualNetworksCreateOrUpdate_569066;
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
  var path_569076 = newJObject()
  var query_569077 = newJObject()
  var body_569078 = newJObject()
  add(path_569076, "resourceGroupName", newJString(resourceGroupName))
  add(query_569077, "api-version", newJString(apiVersion))
  add(path_569076, "subscriptionId", newJString(subscriptionId))
  add(path_569076, "virtualNetworkName", newJString(virtualNetworkName))
  if parameters != nil:
    body_569078 = parameters
  result = call_569075.call(path_569076, query_569077, nil, nil, body_569078)

var virtualNetworksCreateOrUpdate* = Call_VirtualNetworksCreateOrUpdate_569066(
    name: "virtualNetworksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualnetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworksCreateOrUpdate_569067, base: "",
    url: url_VirtualNetworksCreateOrUpdate_569068, schemes: {Scheme.Https})
type
  Call_VirtualNetworksGet_569055 = ref object of OpenApiRestCall_567650
proc url_VirtualNetworksGet_569057(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Network/virtualnetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksGet_569056(path: JsonNode; query: JsonNode;
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
  var valid_569058 = path.getOrDefault("resourceGroupName")
  valid_569058 = validateParameter(valid_569058, JString, required = true,
                                 default = nil)
  if valid_569058 != nil:
    section.add "resourceGroupName", valid_569058
  var valid_569059 = path.getOrDefault("subscriptionId")
  valid_569059 = validateParameter(valid_569059, JString, required = true,
                                 default = nil)
  if valid_569059 != nil:
    section.add "subscriptionId", valid_569059
  var valid_569060 = path.getOrDefault("virtualNetworkName")
  valid_569060 = validateParameter(valid_569060, JString, required = true,
                                 default = nil)
  if valid_569060 != nil:
    section.add "virtualNetworkName", valid_569060
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569061 = query.getOrDefault("api-version")
  valid_569061 = validateParameter(valid_569061, JString, required = true,
                                 default = nil)
  if valid_569061 != nil:
    section.add "api-version", valid_569061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569062: Call_VirtualNetworksGet_569055; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get VirtualNetwork operation retrieves information about the specified virtual network.
  ## 
  let valid = call_569062.validator(path, query, header, formData, body)
  let scheme = call_569062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569062.url(scheme.get, call_569062.host, call_569062.base,
                         call_569062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569062, url, valid)

proc call*(call_569063: Call_VirtualNetworksGet_569055; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; virtualNetworkName: string): Recallable =
  ## virtualNetworksGet
  ## The Get VirtualNetwork operation retrieves information about the specified virtual network.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualNetworkName: string (required)
  ##                     : The name of the virtual network.
  var path_569064 = newJObject()
  var query_569065 = newJObject()
  add(path_569064, "resourceGroupName", newJString(resourceGroupName))
  add(query_569065, "api-version", newJString(apiVersion))
  add(path_569064, "subscriptionId", newJString(subscriptionId))
  add(path_569064, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_569063.call(path_569064, query_569065, nil, nil, nil)

var virtualNetworksGet* = Call_VirtualNetworksGet_569055(
    name: "virtualNetworksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualnetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworksGet_569056, base: "",
    url: url_VirtualNetworksGet_569057, schemes: {Scheme.Https})
type
  Call_VirtualNetworksDelete_569079 = ref object of OpenApiRestCall_567650
proc url_VirtualNetworksDelete_569081(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Network/virtualnetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksDelete_569080(path: JsonNode; query: JsonNode;
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
  var valid_569082 = path.getOrDefault("resourceGroupName")
  valid_569082 = validateParameter(valid_569082, JString, required = true,
                                 default = nil)
  if valid_569082 != nil:
    section.add "resourceGroupName", valid_569082
  var valid_569083 = path.getOrDefault("subscriptionId")
  valid_569083 = validateParameter(valid_569083, JString, required = true,
                                 default = nil)
  if valid_569083 != nil:
    section.add "subscriptionId", valid_569083
  var valid_569084 = path.getOrDefault("virtualNetworkName")
  valid_569084 = validateParameter(valid_569084, JString, required = true,
                                 default = nil)
  if valid_569084 != nil:
    section.add "virtualNetworkName", valid_569084
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569085 = query.getOrDefault("api-version")
  valid_569085 = validateParameter(valid_569085, JString, required = true,
                                 default = nil)
  if valid_569085 != nil:
    section.add "api-version", valid_569085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569086: Call_VirtualNetworksDelete_569079; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete VirtualNetwork operation deletes the specified virtual network
  ## 
  let valid = call_569086.validator(path, query, header, formData, body)
  let scheme = call_569086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569086.url(scheme.get, call_569086.host, call_569086.base,
                         call_569086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569086, url, valid)

proc call*(call_569087: Call_VirtualNetworksDelete_569079;
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
  var path_569088 = newJObject()
  var query_569089 = newJObject()
  add(path_569088, "resourceGroupName", newJString(resourceGroupName))
  add(query_569089, "api-version", newJString(apiVersion))
  add(path_569088, "subscriptionId", newJString(subscriptionId))
  add(path_569088, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_569087.call(path_569088, query_569089, nil, nil, nil)

var virtualNetworksDelete* = Call_VirtualNetworksDelete_569079(
    name: "virtualNetworksDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualnetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworksDelete_569080, base: "",
    url: url_VirtualNetworksDelete_569081, schemes: {Scheme.Https})
type
  Call_SubnetsList_569090 = ref object of OpenApiRestCall_567650
proc url_SubnetsList_569092(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Network/virtualnetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName"),
               (kind: ConstantSegment, value: "/subnets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubnetsList_569091(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_569093 = path.getOrDefault("resourceGroupName")
  valid_569093 = validateParameter(valid_569093, JString, required = true,
                                 default = nil)
  if valid_569093 != nil:
    section.add "resourceGroupName", valid_569093
  var valid_569094 = path.getOrDefault("subscriptionId")
  valid_569094 = validateParameter(valid_569094, JString, required = true,
                                 default = nil)
  if valid_569094 != nil:
    section.add "subscriptionId", valid_569094
  var valid_569095 = path.getOrDefault("virtualNetworkName")
  valid_569095 = validateParameter(valid_569095, JString, required = true,
                                 default = nil)
  if valid_569095 != nil:
    section.add "virtualNetworkName", valid_569095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569096 = query.getOrDefault("api-version")
  valid_569096 = validateParameter(valid_569096, JString, required = true,
                                 default = nil)
  if valid_569096 != nil:
    section.add "api-version", valid_569096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569097: Call_SubnetsList_569090; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List subnets operation retrieves all the subnets in a virtual network.
  ## 
  let valid = call_569097.validator(path, query, header, formData, body)
  let scheme = call_569097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569097.url(scheme.get, call_569097.host, call_569097.base,
                         call_569097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569097, url, valid)

proc call*(call_569098: Call_SubnetsList_569090; resourceGroupName: string;
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
  var path_569099 = newJObject()
  var query_569100 = newJObject()
  add(path_569099, "resourceGroupName", newJString(resourceGroupName))
  add(query_569100, "api-version", newJString(apiVersion))
  add(path_569099, "subscriptionId", newJString(subscriptionId))
  add(path_569099, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_569098.call(path_569099, query_569100, nil, nil, nil)

var subnetsList* = Call_SubnetsList_569090(name: "subnetsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualnetworks/{virtualNetworkName}/subnets",
                                        validator: validate_SubnetsList_569091,
                                        base: "", url: url_SubnetsList_569092,
                                        schemes: {Scheme.Https})
type
  Call_SubnetsCreateOrUpdate_569113 = ref object of OpenApiRestCall_567650
proc url_SubnetsCreateOrUpdate_569115(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Network/virtualnetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName"),
               (kind: ConstantSegment, value: "/subnets/"),
               (kind: VariableSegment, value: "subnetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubnetsCreateOrUpdate_569114(path: JsonNode; query: JsonNode;
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
  var valid_569116 = path.getOrDefault("resourceGroupName")
  valid_569116 = validateParameter(valid_569116, JString, required = true,
                                 default = nil)
  if valid_569116 != nil:
    section.add "resourceGroupName", valid_569116
  var valid_569117 = path.getOrDefault("subnetName")
  valid_569117 = validateParameter(valid_569117, JString, required = true,
                                 default = nil)
  if valid_569117 != nil:
    section.add "subnetName", valid_569117
  var valid_569118 = path.getOrDefault("subscriptionId")
  valid_569118 = validateParameter(valid_569118, JString, required = true,
                                 default = nil)
  if valid_569118 != nil:
    section.add "subscriptionId", valid_569118
  var valid_569119 = path.getOrDefault("virtualNetworkName")
  valid_569119 = validateParameter(valid_569119, JString, required = true,
                                 default = nil)
  if valid_569119 != nil:
    section.add "virtualNetworkName", valid_569119
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569120 = query.getOrDefault("api-version")
  valid_569120 = validateParameter(valid_569120, JString, required = true,
                                 default = nil)
  if valid_569120 != nil:
    section.add "api-version", valid_569120
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

proc call*(call_569122: Call_SubnetsCreateOrUpdate_569113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put Subnet operation creates/updates a subnet in the specified virtual network
  ## 
  let valid = call_569122.validator(path, query, header, formData, body)
  let scheme = call_569122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569122.url(scheme.get, call_569122.host, call_569122.base,
                         call_569122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569122, url, valid)

proc call*(call_569123: Call_SubnetsCreateOrUpdate_569113;
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
  var path_569124 = newJObject()
  var query_569125 = newJObject()
  var body_569126 = newJObject()
  add(path_569124, "resourceGroupName", newJString(resourceGroupName))
  add(path_569124, "subnetName", newJString(subnetName))
  add(query_569125, "api-version", newJString(apiVersion))
  add(path_569124, "subscriptionId", newJString(subscriptionId))
  add(path_569124, "virtualNetworkName", newJString(virtualNetworkName))
  if subnetParameters != nil:
    body_569126 = subnetParameters
  result = call_569123.call(path_569124, query_569125, nil, nil, body_569126)

var subnetsCreateOrUpdate* = Call_SubnetsCreateOrUpdate_569113(
    name: "subnetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualnetworks/{virtualNetworkName}/subnets/{subnetName}",
    validator: validate_SubnetsCreateOrUpdate_569114, base: "",
    url: url_SubnetsCreateOrUpdate_569115, schemes: {Scheme.Https})
type
  Call_SubnetsGet_569101 = ref object of OpenApiRestCall_567650
proc url_SubnetsGet_569103(protocol: Scheme; host: string; base: string; route: string;
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
        value: "/providers/Microsoft.Network/virtualnetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName"),
               (kind: ConstantSegment, value: "/subnets/"),
               (kind: VariableSegment, value: "subnetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubnetsGet_569102(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_569104 = path.getOrDefault("resourceGroupName")
  valid_569104 = validateParameter(valid_569104, JString, required = true,
                                 default = nil)
  if valid_569104 != nil:
    section.add "resourceGroupName", valid_569104
  var valid_569105 = path.getOrDefault("subnetName")
  valid_569105 = validateParameter(valid_569105, JString, required = true,
                                 default = nil)
  if valid_569105 != nil:
    section.add "subnetName", valid_569105
  var valid_569106 = path.getOrDefault("subscriptionId")
  valid_569106 = validateParameter(valid_569106, JString, required = true,
                                 default = nil)
  if valid_569106 != nil:
    section.add "subscriptionId", valid_569106
  var valid_569107 = path.getOrDefault("virtualNetworkName")
  valid_569107 = validateParameter(valid_569107, JString, required = true,
                                 default = nil)
  if valid_569107 != nil:
    section.add "virtualNetworkName", valid_569107
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569108 = query.getOrDefault("api-version")
  valid_569108 = validateParameter(valid_569108, JString, required = true,
                                 default = nil)
  if valid_569108 != nil:
    section.add "api-version", valid_569108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569109: Call_SubnetsGet_569101; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get subnet operation retrieves information about the specified subnet.
  ## 
  let valid = call_569109.validator(path, query, header, formData, body)
  let scheme = call_569109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569109.url(scheme.get, call_569109.host, call_569109.base,
                         call_569109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569109, url, valid)

proc call*(call_569110: Call_SubnetsGet_569101; resourceGroupName: string;
          subnetName: string; apiVersion: string; subscriptionId: string;
          virtualNetworkName: string): Recallable =
  ## subnetsGet
  ## The Get subnet operation retrieves information about the specified subnet.
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
  var path_569111 = newJObject()
  var query_569112 = newJObject()
  add(path_569111, "resourceGroupName", newJString(resourceGroupName))
  add(path_569111, "subnetName", newJString(subnetName))
  add(query_569112, "api-version", newJString(apiVersion))
  add(path_569111, "subscriptionId", newJString(subscriptionId))
  add(path_569111, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_569110.call(path_569111, query_569112, nil, nil, nil)

var subnetsGet* = Call_SubnetsGet_569101(name: "subnetsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualnetworks/{virtualNetworkName}/subnets/{subnetName}",
                                      validator: validate_SubnetsGet_569102,
                                      base: "", url: url_SubnetsGet_569103,
                                      schemes: {Scheme.Https})
type
  Call_SubnetsDelete_569127 = ref object of OpenApiRestCall_567650
proc url_SubnetsDelete_569129(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Network/virtualnetworks/"),
               (kind: VariableSegment, value: "virtualNetworkName"),
               (kind: ConstantSegment, value: "/subnets/"),
               (kind: VariableSegment, value: "subnetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubnetsDelete_569128(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_569130 = path.getOrDefault("resourceGroupName")
  valid_569130 = validateParameter(valid_569130, JString, required = true,
                                 default = nil)
  if valid_569130 != nil:
    section.add "resourceGroupName", valid_569130
  var valid_569131 = path.getOrDefault("subnetName")
  valid_569131 = validateParameter(valid_569131, JString, required = true,
                                 default = nil)
  if valid_569131 != nil:
    section.add "subnetName", valid_569131
  var valid_569132 = path.getOrDefault("subscriptionId")
  valid_569132 = validateParameter(valid_569132, JString, required = true,
                                 default = nil)
  if valid_569132 != nil:
    section.add "subscriptionId", valid_569132
  var valid_569133 = path.getOrDefault("virtualNetworkName")
  valid_569133 = validateParameter(valid_569133, JString, required = true,
                                 default = nil)
  if valid_569133 != nil:
    section.add "virtualNetworkName", valid_569133
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569134 = query.getOrDefault("api-version")
  valid_569134 = validateParameter(valid_569134, JString, required = true,
                                 default = nil)
  if valid_569134 != nil:
    section.add "api-version", valid_569134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569135: Call_SubnetsDelete_569127; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete subnet operation deletes the specified subnet.
  ## 
  let valid = call_569135.validator(path, query, header, formData, body)
  let scheme = call_569135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569135.url(scheme.get, call_569135.host, call_569135.base,
                         call_569135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569135, url, valid)

proc call*(call_569136: Call_SubnetsDelete_569127; resourceGroupName: string;
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
  var path_569137 = newJObject()
  var query_569138 = newJObject()
  add(path_569137, "resourceGroupName", newJString(resourceGroupName))
  add(path_569137, "subnetName", newJString(subnetName))
  add(query_569138, "api-version", newJString(apiVersion))
  add(path_569137, "subscriptionId", newJString(subscriptionId))
  add(path_569137, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_569136.call(path_569137, query_569138, nil, nil, nil)

var subnetsDelete* = Call_SubnetsDelete_569127(name: "subnetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualnetworks/{virtualNetworkName}/subnets/{subnetName}",
    validator: validate_SubnetsDelete_569128, base: "", url: url_SubnetsDelete_569129,
    schemes: {Scheme.Https})
type
  Call_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_569139 = ref object of OpenApiRestCall_567650
proc url_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_569141(
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
        value: "/providers/microsoft.compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "virtualMachineScaleSetName"),
               (kind: ConstantSegment, value: "/networkInterfaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_569140(
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
  var valid_569142 = path.getOrDefault("resourceGroupName")
  valid_569142 = validateParameter(valid_569142, JString, required = true,
                                 default = nil)
  if valid_569142 != nil:
    section.add "resourceGroupName", valid_569142
  var valid_569143 = path.getOrDefault("subscriptionId")
  valid_569143 = validateParameter(valid_569143, JString, required = true,
                                 default = nil)
  if valid_569143 != nil:
    section.add "subscriptionId", valid_569143
  var valid_569144 = path.getOrDefault("virtualMachineScaleSetName")
  valid_569144 = validateParameter(valid_569144, JString, required = true,
                                 default = nil)
  if valid_569144 != nil:
    section.add "virtualMachineScaleSetName", valid_569144
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569145 = query.getOrDefault("api-version")
  valid_569145 = validateParameter(valid_569145, JString, required = true,
                                 default = nil)
  if valid_569145 != nil:
    section.add "api-version", valid_569145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569146: Call_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_569139;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The list network interface operation retrieves information about all network interfaces in a virtual machine scale set.
  ## 
  let valid = call_569146.validator(path, query, header, formData, body)
  let scheme = call_569146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569146.url(scheme.get, call_569146.host, call_569146.base,
                         call_569146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569146, url, valid)

proc call*(call_569147: Call_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_569139;
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
  var path_569148 = newJObject()
  var query_569149 = newJObject()
  add(path_569148, "resourceGroupName", newJString(resourceGroupName))
  add(query_569149, "api-version", newJString(apiVersion))
  add(path_569148, "subscriptionId", newJString(subscriptionId))
  add(path_569148, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  result = call_569147.call(path_569148, query_569149, nil, nil, nil)

var networkInterfacesListVirtualMachineScaleSetNetworkInterfaces* = Call_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_569139(
    name: "networkInterfacesListVirtualMachineScaleSetNetworkInterfaces",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/networkInterfaces", validator: validate_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_569140,
    base: "",
    url: url_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_569141,
    schemes: {Scheme.Https})
type
  Call_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_569150 = ref object of OpenApiRestCall_567650
proc url_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_569152(
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
        value: "/providers/microsoft.compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "virtualMachineScaleSetName"),
               (kind: ConstantSegment, value: "/virtualMachines/"),
               (kind: VariableSegment, value: "virtualmachineIndex"),
               (kind: ConstantSegment, value: "/networkInterfaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_569151(
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
  var valid_569153 = path.getOrDefault("resourceGroupName")
  valid_569153 = validateParameter(valid_569153, JString, required = true,
                                 default = nil)
  if valid_569153 != nil:
    section.add "resourceGroupName", valid_569153
  var valid_569154 = path.getOrDefault("subscriptionId")
  valid_569154 = validateParameter(valid_569154, JString, required = true,
                                 default = nil)
  if valid_569154 != nil:
    section.add "subscriptionId", valid_569154
  var valid_569155 = path.getOrDefault("virtualmachineIndex")
  valid_569155 = validateParameter(valid_569155, JString, required = true,
                                 default = nil)
  if valid_569155 != nil:
    section.add "virtualmachineIndex", valid_569155
  var valid_569156 = path.getOrDefault("virtualMachineScaleSetName")
  valid_569156 = validateParameter(valid_569156, JString, required = true,
                                 default = nil)
  if valid_569156 != nil:
    section.add "virtualMachineScaleSetName", valid_569156
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569157 = query.getOrDefault("api-version")
  valid_569157 = validateParameter(valid_569157, JString, required = true,
                                 default = nil)
  if valid_569157 != nil:
    section.add "api-version", valid_569157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569158: Call_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_569150;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The list network interface operation retrieves information about all network interfaces in a virtual machine from a virtual machine scale set.
  ## 
  let valid = call_569158.validator(path, query, header, formData, body)
  let scheme = call_569158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569158.url(scheme.get, call_569158.host, call_569158.base,
                         call_569158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569158, url, valid)

proc call*(call_569159: Call_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_569150;
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
  var path_569160 = newJObject()
  var query_569161 = newJObject()
  add(path_569160, "resourceGroupName", newJString(resourceGroupName))
  add(query_569161, "api-version", newJString(apiVersion))
  add(path_569160, "subscriptionId", newJString(subscriptionId))
  add(path_569160, "virtualmachineIndex", newJString(virtualmachineIndex))
  add(path_569160, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  result = call_569159.call(path_569160, query_569161, nil, nil, nil)

var networkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces* = Call_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_569150(
    name: "networkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/virtualMachines/{virtualmachineIndex}/networkInterfaces", validator: validate_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_569151,
    base: "",
    url: url_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_569152,
    schemes: {Scheme.Https})
type
  Call_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_569162 = ref object of OpenApiRestCall_567650
proc url_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_569164(
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
        value: "/providers/microsoft.compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "virtualMachineScaleSetName"),
               (kind: ConstantSegment, value: "/virtualMachines/"),
               (kind: VariableSegment, value: "virtualmachineIndex"),
               (kind: ConstantSegment, value: "/networkInterfaces/"),
               (kind: VariableSegment, value: "networkInterfaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_569163(
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
  var valid_569165 = path.getOrDefault("resourceGroupName")
  valid_569165 = validateParameter(valid_569165, JString, required = true,
                                 default = nil)
  if valid_569165 != nil:
    section.add "resourceGroupName", valid_569165
  var valid_569166 = path.getOrDefault("subscriptionId")
  valid_569166 = validateParameter(valid_569166, JString, required = true,
                                 default = nil)
  if valid_569166 != nil:
    section.add "subscriptionId", valid_569166
  var valid_569167 = path.getOrDefault("virtualmachineIndex")
  valid_569167 = validateParameter(valid_569167, JString, required = true,
                                 default = nil)
  if valid_569167 != nil:
    section.add "virtualmachineIndex", valid_569167
  var valid_569168 = path.getOrDefault("networkInterfaceName")
  valid_569168 = validateParameter(valid_569168, JString, required = true,
                                 default = nil)
  if valid_569168 != nil:
    section.add "networkInterfaceName", valid_569168
  var valid_569169 = path.getOrDefault("virtualMachineScaleSetName")
  valid_569169 = validateParameter(valid_569169, JString, required = true,
                                 default = nil)
  if valid_569169 != nil:
    section.add "virtualMachineScaleSetName", valid_569169
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569170 = query.getOrDefault("api-version")
  valid_569170 = validateParameter(valid_569170, JString, required = true,
                                 default = nil)
  if valid_569170 != nil:
    section.add "api-version", valid_569170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569171: Call_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_569162;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Get network interface operation retrieves information about the specified network interface in a virtual machine scale set.
  ## 
  let valid = call_569171.validator(path, query, header, formData, body)
  let scheme = call_569171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569171.url(scheme.get, call_569171.host, call_569171.base,
                         call_569171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569171, url, valid)

proc call*(call_569172: Call_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_569162;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualmachineIndex: string; networkInterfaceName: string;
          virtualMachineScaleSetName: string): Recallable =
  ## networkInterfacesGetVirtualMachineScaleSetNetworkInterface
  ## The Get network interface operation retrieves information about the specified network interface in a virtual machine scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualmachineIndex: string (required)
  ##                      : The virtual machine index.
  ##   networkInterfaceName: string (required)
  ##                       : The name of the network interface.
  ##   virtualMachineScaleSetName: string (required)
  ##                             : The name of the virtual machine scale set.
  var path_569173 = newJObject()
  var query_569174 = newJObject()
  add(path_569173, "resourceGroupName", newJString(resourceGroupName))
  add(query_569174, "api-version", newJString(apiVersion))
  add(path_569173, "subscriptionId", newJString(subscriptionId))
  add(path_569173, "virtualmachineIndex", newJString(virtualmachineIndex))
  add(path_569173, "networkInterfaceName", newJString(networkInterfaceName))
  add(path_569173, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  result = call_569172.call(path_569173, query_569174, nil, nil, nil)

var networkInterfacesGetVirtualMachineScaleSetNetworkInterface* = Call_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_569162(
    name: "networkInterfacesGetVirtualMachineScaleSetNetworkInterface",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/virtualMachines/{virtualmachineIndex}/networkInterfaces/{networkInterfaceName}", validator: validate_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_569163,
    base: "", url: url_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_569164,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
