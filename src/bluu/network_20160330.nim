
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567651 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567651](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567651): Option[Scheme] {.used.} =
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
  Call_ApplicationGatewaysListAll_567873 = ref object of OpenApiRestCall_567651
proc url_ApplicationGatewaysListAll_567875(protocol: Scheme; host: string;
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

proc validate_ApplicationGatewaysListAll_567874(path: JsonNode; query: JsonNode;
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
  var valid_568048 = path.getOrDefault("subscriptionId")
  valid_568048 = validateParameter(valid_568048, JString, required = true,
                                 default = nil)
  if valid_568048 != nil:
    section.add "subscriptionId", valid_568048
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568049 = query.getOrDefault("api-version")
  valid_568049 = validateParameter(valid_568049, JString, required = true,
                                 default = nil)
  if valid_568049 != nil:
    section.add "api-version", valid_568049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568072: Call_ApplicationGatewaysListAll_567873; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List application gateway operation retrieves all the application gateways in a subscription.
  ## 
  let valid = call_568072.validator(path, query, header, formData, body)
  let scheme = call_568072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568072.url(scheme.get, call_568072.host, call_568072.base,
                         call_568072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568072, url, valid)

proc call*(call_568143: Call_ApplicationGatewaysListAll_567873; apiVersion: string;
          subscriptionId: string): Recallable =
  ## applicationGatewaysListAll
  ## The List application gateway operation retrieves all the application gateways in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568144 = newJObject()
  var query_568146 = newJObject()
  add(query_568146, "api-version", newJString(apiVersion))
  add(path_568144, "subscriptionId", newJString(subscriptionId))
  result = call_568143.call(path_568144, query_568146, nil, nil, nil)

var applicationGatewaysListAll* = Call_ApplicationGatewaysListAll_567873(
    name: "applicationGatewaysListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/applicationGateways",
    validator: validate_ApplicationGatewaysListAll_567874, base: "",
    url: url_ApplicationGatewaysListAll_567875, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsListAll_568185 = ref object of OpenApiRestCall_567651
proc url_ExpressRouteCircuitsListAll_568187(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsListAll_568186(path: JsonNode; query: JsonNode;
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
  var valid_568188 = path.getOrDefault("subscriptionId")
  valid_568188 = validateParameter(valid_568188, JString, required = true,
                                 default = nil)
  if valid_568188 != nil:
    section.add "subscriptionId", valid_568188
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568189 = query.getOrDefault("api-version")
  valid_568189 = validateParameter(valid_568189, JString, required = true,
                                 default = nil)
  if valid_568189 != nil:
    section.add "api-version", valid_568189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568190: Call_ExpressRouteCircuitsListAll_568185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List ExpressRouteCircuit operation retrieves all the ExpressRouteCircuits in a subscription.
  ## 
  let valid = call_568190.validator(path, query, header, formData, body)
  let scheme = call_568190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568190.url(scheme.get, call_568190.host, call_568190.base,
                         call_568190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568190, url, valid)

proc call*(call_568191: Call_ExpressRouteCircuitsListAll_568185;
          apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteCircuitsListAll
  ## The List ExpressRouteCircuit operation retrieves all the ExpressRouteCircuits in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568192 = newJObject()
  var query_568193 = newJObject()
  add(query_568193, "api-version", newJString(apiVersion))
  add(path_568192, "subscriptionId", newJString(subscriptionId))
  result = call_568191.call(path_568192, query_568193, nil, nil, nil)

var expressRouteCircuitsListAll* = Call_ExpressRouteCircuitsListAll_568185(
    name: "expressRouteCircuitsListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/expressRouteCircuits",
    validator: validate_ExpressRouteCircuitsListAll_568186, base: "",
    url: url_ExpressRouteCircuitsListAll_568187, schemes: {Scheme.Https})
type
  Call_ExpressRouteServiceProvidersList_568194 = ref object of OpenApiRestCall_567651
proc url_ExpressRouteServiceProvidersList_568196(protocol: Scheme; host: string;
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

proc validate_ExpressRouteServiceProvidersList_568195(path: JsonNode;
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
  var valid_568197 = path.getOrDefault("subscriptionId")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "subscriptionId", valid_568197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568198 = query.getOrDefault("api-version")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "api-version", valid_568198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568199: Call_ExpressRouteServiceProvidersList_568194;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The List ExpressRouteServiceProvider operation retrieves all the available ExpressRouteServiceProviders.
  ## 
  let valid = call_568199.validator(path, query, header, formData, body)
  let scheme = call_568199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568199.url(scheme.get, call_568199.host, call_568199.base,
                         call_568199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568199, url, valid)

proc call*(call_568200: Call_ExpressRouteServiceProvidersList_568194;
          apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteServiceProvidersList
  ## The List ExpressRouteServiceProvider operation retrieves all the available ExpressRouteServiceProviders.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568201 = newJObject()
  var query_568202 = newJObject()
  add(query_568202, "api-version", newJString(apiVersion))
  add(path_568201, "subscriptionId", newJString(subscriptionId))
  result = call_568200.call(path_568201, query_568202, nil, nil, nil)

var expressRouteServiceProvidersList* = Call_ExpressRouteServiceProvidersList_568194(
    name: "expressRouteServiceProvidersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/expressRouteServiceProviders",
    validator: validate_ExpressRouteServiceProvidersList_568195, base: "",
    url: url_ExpressRouteServiceProvidersList_568196, schemes: {Scheme.Https})
type
  Call_LoadBalancersListAll_568203 = ref object of OpenApiRestCall_567651
proc url_LoadBalancersListAll_568205(protocol: Scheme; host: string; base: string;
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

proc validate_LoadBalancersListAll_568204(path: JsonNode; query: JsonNode;
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
  var valid_568206 = path.getOrDefault("subscriptionId")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "subscriptionId", valid_568206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568207 = query.getOrDefault("api-version")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "api-version", valid_568207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568208: Call_LoadBalancersListAll_568203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List loadBalancer operation retrieves all the load balancers in a subscription.
  ## 
  let valid = call_568208.validator(path, query, header, formData, body)
  let scheme = call_568208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568208.url(scheme.get, call_568208.host, call_568208.base,
                         call_568208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568208, url, valid)

proc call*(call_568209: Call_LoadBalancersListAll_568203; apiVersion: string;
          subscriptionId: string): Recallable =
  ## loadBalancersListAll
  ## The List loadBalancer operation retrieves all the load balancers in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568210 = newJObject()
  var query_568211 = newJObject()
  add(query_568211, "api-version", newJString(apiVersion))
  add(path_568210, "subscriptionId", newJString(subscriptionId))
  result = call_568209.call(path_568210, query_568211, nil, nil, nil)

var loadBalancersListAll* = Call_LoadBalancersListAll_568203(
    name: "loadBalancersListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/loadBalancers",
    validator: validate_LoadBalancersListAll_568204, base: "",
    url: url_LoadBalancersListAll_568205, schemes: {Scheme.Https})
type
  Call_CheckDnsNameAvailability_568212 = ref object of OpenApiRestCall_567651
proc url_CheckDnsNameAvailability_568214(protocol: Scheme; host: string;
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

proc validate_CheckDnsNameAvailability_568213(path: JsonNode; query: JsonNode;
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
  var valid_568215 = path.getOrDefault("subscriptionId")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "subscriptionId", valid_568215
  var valid_568216 = path.getOrDefault("location")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "location", valid_568216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   domainNameLabel: JString
  ##                  : The domain name to be verified. It must conform to the following regular expression: ^[a-z][a-z0-9-]{1,61}[a-z0-9]$.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568217 = query.getOrDefault("api-version")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "api-version", valid_568217
  var valid_568218 = query.getOrDefault("domainNameLabel")
  valid_568218 = validateParameter(valid_568218, JString, required = false,
                                 default = nil)
  if valid_568218 != nil:
    section.add "domainNameLabel", valid_568218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568219: Call_CheckDnsNameAvailability_568212; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether a domain name in the cloudapp.net zone is available for use.
  ## 
  let valid = call_568219.validator(path, query, header, formData, body)
  let scheme = call_568219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568219.url(scheme.get, call_568219.host, call_568219.base,
                         call_568219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568219, url, valid)

proc call*(call_568220: Call_CheckDnsNameAvailability_568212; apiVersion: string;
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
  var path_568221 = newJObject()
  var query_568222 = newJObject()
  add(query_568222, "api-version", newJString(apiVersion))
  add(path_568221, "subscriptionId", newJString(subscriptionId))
  add(query_568222, "domainNameLabel", newJString(domainNameLabel))
  add(path_568221, "location", newJString(location))
  result = call_568220.call(path_568221, query_568222, nil, nil, nil)

var checkDnsNameAvailability* = Call_CheckDnsNameAvailability_568212(
    name: "checkDnsNameAvailability", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/locations/{location}/CheckDnsNameAvailability",
    validator: validate_CheckDnsNameAvailability_568213, base: "",
    url: url_CheckDnsNameAvailability_568214, schemes: {Scheme.Https})
type
  Call_UsagesList_568223 = ref object of OpenApiRestCall_567651
proc url_UsagesList_568225(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UsagesList_568224(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568226 = path.getOrDefault("subscriptionId")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "subscriptionId", valid_568226
  var valid_568227 = path.getOrDefault("location")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "location", valid_568227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568228 = query.getOrDefault("api-version")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "api-version", valid_568228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568229: Call_UsagesList_568223; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists compute usages for a subscription.
  ## 
  let valid = call_568229.validator(path, query, header, formData, body)
  let scheme = call_568229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568229.url(scheme.get, call_568229.host, call_568229.base,
                         call_568229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568229, url, valid)

proc call*(call_568230: Call_UsagesList_568223; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## usagesList
  ## Lists compute usages for a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location upon which resource usage is queried.
  var path_568231 = newJObject()
  var query_568232 = newJObject()
  add(query_568232, "api-version", newJString(apiVersion))
  add(path_568231, "subscriptionId", newJString(subscriptionId))
  add(path_568231, "location", newJString(location))
  result = call_568230.call(path_568231, query_568232, nil, nil, nil)

var usagesList* = Call_UsagesList_568223(name: "usagesList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/locations/{location}/usages",
                                      validator: validate_UsagesList_568224,
                                      base: "", url: url_UsagesList_568225,
                                      schemes: {Scheme.Https})
type
  Call_NetworkInterfacesListAll_568233 = ref object of OpenApiRestCall_567651
proc url_NetworkInterfacesListAll_568235(protocol: Scheme; host: string;
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

proc validate_NetworkInterfacesListAll_568234(path: JsonNode; query: JsonNode;
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
  var valid_568236 = path.getOrDefault("subscriptionId")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "subscriptionId", valid_568236
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568237 = query.getOrDefault("api-version")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "api-version", valid_568237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568238: Call_NetworkInterfacesListAll_568233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List networkInterfaces operation retrieves all the networkInterfaces in a subscription.
  ## 
  let valid = call_568238.validator(path, query, header, formData, body)
  let scheme = call_568238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568238.url(scheme.get, call_568238.host, call_568238.base,
                         call_568238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568238, url, valid)

proc call*(call_568239: Call_NetworkInterfacesListAll_568233; apiVersion: string;
          subscriptionId: string): Recallable =
  ## networkInterfacesListAll
  ## The List networkInterfaces operation retrieves all the networkInterfaces in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568240 = newJObject()
  var query_568241 = newJObject()
  add(query_568241, "api-version", newJString(apiVersion))
  add(path_568240, "subscriptionId", newJString(subscriptionId))
  result = call_568239.call(path_568240, query_568241, nil, nil, nil)

var networkInterfacesListAll* = Call_NetworkInterfacesListAll_568233(
    name: "networkInterfacesListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/networkInterfaces",
    validator: validate_NetworkInterfacesListAll_568234, base: "",
    url: url_NetworkInterfacesListAll_568235, schemes: {Scheme.Https})
type
  Call_NetworkSecurityGroupsListAll_568242 = ref object of OpenApiRestCall_567651
proc url_NetworkSecurityGroupsListAll_568244(protocol: Scheme; host: string;
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

proc validate_NetworkSecurityGroupsListAll_568243(path: JsonNode; query: JsonNode;
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
  var valid_568245 = path.getOrDefault("subscriptionId")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "subscriptionId", valid_568245
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568246 = query.getOrDefault("api-version")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "api-version", valid_568246
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568247: Call_NetworkSecurityGroupsListAll_568242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list NetworkSecurityGroups returns all network security groups in a subscription
  ## 
  let valid = call_568247.validator(path, query, header, formData, body)
  let scheme = call_568247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568247.url(scheme.get, call_568247.host, call_568247.base,
                         call_568247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568247, url, valid)

proc call*(call_568248: Call_NetworkSecurityGroupsListAll_568242;
          apiVersion: string; subscriptionId: string): Recallable =
  ## networkSecurityGroupsListAll
  ## The list NetworkSecurityGroups returns all network security groups in a subscription
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568249 = newJObject()
  var query_568250 = newJObject()
  add(query_568250, "api-version", newJString(apiVersion))
  add(path_568249, "subscriptionId", newJString(subscriptionId))
  result = call_568248.call(path_568249, query_568250, nil, nil, nil)

var networkSecurityGroupsListAll* = Call_NetworkSecurityGroupsListAll_568242(
    name: "networkSecurityGroupsListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/networkSecurityGroups",
    validator: validate_NetworkSecurityGroupsListAll_568243, base: "",
    url: url_NetworkSecurityGroupsListAll_568244, schemes: {Scheme.Https})
type
  Call_PublicIPAddressesListAll_568251 = ref object of OpenApiRestCall_567651
proc url_PublicIPAddressesListAll_568253(protocol: Scheme; host: string;
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

proc validate_PublicIPAddressesListAll_568252(path: JsonNode; query: JsonNode;
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
  var valid_568254 = path.getOrDefault("subscriptionId")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "subscriptionId", valid_568254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568255 = query.getOrDefault("api-version")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "api-version", valid_568255
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568256: Call_PublicIPAddressesListAll_568251; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List publicIpAddress operation retrieves all the publicIpAddresses in a subscription.
  ## 
  let valid = call_568256.validator(path, query, header, formData, body)
  let scheme = call_568256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568256.url(scheme.get, call_568256.host, call_568256.base,
                         call_568256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568256, url, valid)

proc call*(call_568257: Call_PublicIPAddressesListAll_568251; apiVersion: string;
          subscriptionId: string): Recallable =
  ## publicIPAddressesListAll
  ## The List publicIpAddress operation retrieves all the publicIpAddresses in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568258 = newJObject()
  var query_568259 = newJObject()
  add(query_568259, "api-version", newJString(apiVersion))
  add(path_568258, "subscriptionId", newJString(subscriptionId))
  result = call_568257.call(path_568258, query_568259, nil, nil, nil)

var publicIPAddressesListAll* = Call_PublicIPAddressesListAll_568251(
    name: "publicIPAddressesListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/publicIPAddresses",
    validator: validate_PublicIPAddressesListAll_568252, base: "",
    url: url_PublicIPAddressesListAll_568253, schemes: {Scheme.Https})
type
  Call_RouteTablesListAll_568260 = ref object of OpenApiRestCall_567651
proc url_RouteTablesListAll_568262(protocol: Scheme; host: string; base: string;
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

proc validate_RouteTablesListAll_568261(path: JsonNode; query: JsonNode;
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
  var valid_568263 = path.getOrDefault("subscriptionId")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "subscriptionId", valid_568263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568264 = query.getOrDefault("api-version")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "api-version", valid_568264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568265: Call_RouteTablesListAll_568260; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list RouteTables returns all route tables in a subscription
  ## 
  let valid = call_568265.validator(path, query, header, formData, body)
  let scheme = call_568265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568265.url(scheme.get, call_568265.host, call_568265.base,
                         call_568265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568265, url, valid)

proc call*(call_568266: Call_RouteTablesListAll_568260; apiVersion: string;
          subscriptionId: string): Recallable =
  ## routeTablesListAll
  ## The list RouteTables returns all route tables in a subscription
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568267 = newJObject()
  var query_568268 = newJObject()
  add(query_568268, "api-version", newJString(apiVersion))
  add(path_568267, "subscriptionId", newJString(subscriptionId))
  result = call_568266.call(path_568267, query_568268, nil, nil, nil)

var routeTablesListAll* = Call_RouteTablesListAll_568260(
    name: "routeTablesListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/routeTables",
    validator: validate_RouteTablesListAll_568261, base: "",
    url: url_RouteTablesListAll_568262, schemes: {Scheme.Https})
type
  Call_VirtualNetworksListAll_568269 = ref object of OpenApiRestCall_567651
proc url_VirtualNetworksListAll_568271(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksListAll_568270(path: JsonNode; query: JsonNode;
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
  var valid_568272 = path.getOrDefault("subscriptionId")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "subscriptionId", valid_568272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568273 = query.getOrDefault("api-version")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "api-version", valid_568273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568274: Call_VirtualNetworksListAll_568269; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list VirtualNetwork returns all Virtual Networks in a subscription
  ## 
  let valid = call_568274.validator(path, query, header, formData, body)
  let scheme = call_568274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568274.url(scheme.get, call_568274.host, call_568274.base,
                         call_568274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568274, url, valid)

proc call*(call_568275: Call_VirtualNetworksListAll_568269; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualNetworksListAll
  ## The list VirtualNetwork returns all Virtual Networks in a subscription
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568276 = newJObject()
  var query_568277 = newJObject()
  add(query_568277, "api-version", newJString(apiVersion))
  add(path_568276, "subscriptionId", newJString(subscriptionId))
  result = call_568275.call(path_568276, query_568277, nil, nil, nil)

var virtualNetworksListAll* = Call_VirtualNetworksListAll_568269(
    name: "virtualNetworksListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/virtualNetworks",
    validator: validate_VirtualNetworksListAll_568270, base: "",
    url: url_VirtualNetworksListAll_568271, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysList_568278 = ref object of OpenApiRestCall_567651
proc url_ApplicationGatewaysList_568280(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationGatewaysList_568279(path: JsonNode; query: JsonNode;
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
  var valid_568281 = path.getOrDefault("resourceGroupName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "resourceGroupName", valid_568281
  var valid_568282 = path.getOrDefault("subscriptionId")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "subscriptionId", valid_568282
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568283 = query.getOrDefault("api-version")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "api-version", valid_568283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568284: Call_ApplicationGatewaysList_568278; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List ApplicationGateway operation retrieves all the application gateways in a resource group.
  ## 
  let valid = call_568284.validator(path, query, header, formData, body)
  let scheme = call_568284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568284.url(scheme.get, call_568284.host, call_568284.base,
                         call_568284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568284, url, valid)

proc call*(call_568285: Call_ApplicationGatewaysList_568278;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## applicationGatewaysList
  ## The List ApplicationGateway operation retrieves all the application gateways in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568286 = newJObject()
  var query_568287 = newJObject()
  add(path_568286, "resourceGroupName", newJString(resourceGroupName))
  add(query_568287, "api-version", newJString(apiVersion))
  add(path_568286, "subscriptionId", newJString(subscriptionId))
  result = call_568285.call(path_568286, query_568287, nil, nil, nil)

var applicationGatewaysList* = Call_ApplicationGatewaysList_568278(
    name: "applicationGatewaysList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways",
    validator: validate_ApplicationGatewaysList_568279, base: "",
    url: url_ApplicationGatewaysList_568280, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysCreateOrUpdate_568299 = ref object of OpenApiRestCall_567651
proc url_ApplicationGatewaysCreateOrUpdate_568301(protocol: Scheme; host: string;
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

proc validate_ApplicationGatewaysCreateOrUpdate_568300(path: JsonNode;
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
  var valid_568321 = path.getOrDefault("applicationGatewayName")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "applicationGatewayName", valid_568321
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568322 = query.getOrDefault("api-version")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "api-version", valid_568322
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

proc call*(call_568324: Call_ApplicationGatewaysCreateOrUpdate_568299;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put ApplicationGateway operation creates/updates a ApplicationGateway
  ## 
  let valid = call_568324.validator(path, query, header, formData, body)
  let scheme = call_568324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568324.url(scheme.get, call_568324.host, call_568324.base,
                         call_568324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568324, url, valid)

proc call*(call_568325: Call_ApplicationGatewaysCreateOrUpdate_568299;
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
  var path_568326 = newJObject()
  var query_568327 = newJObject()
  var body_568328 = newJObject()
  add(path_568326, "resourceGroupName", newJString(resourceGroupName))
  add(query_568327, "api-version", newJString(apiVersion))
  add(path_568326, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568328 = parameters
  add(path_568326, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_568325.call(path_568326, query_568327, nil, nil, body_568328)

var applicationGatewaysCreateOrUpdate* = Call_ApplicationGatewaysCreateOrUpdate_568299(
    name: "applicationGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}",
    validator: validate_ApplicationGatewaysCreateOrUpdate_568300, base: "",
    url: url_ApplicationGatewaysCreateOrUpdate_568301, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysGet_568288 = ref object of OpenApiRestCall_567651
proc url_ApplicationGatewaysGet_568290(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationGatewaysGet_568289(path: JsonNode; query: JsonNode;
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
  var valid_568291 = path.getOrDefault("resourceGroupName")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "resourceGroupName", valid_568291
  var valid_568292 = path.getOrDefault("subscriptionId")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "subscriptionId", valid_568292
  var valid_568293 = path.getOrDefault("applicationGatewayName")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "applicationGatewayName", valid_568293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568294 = query.getOrDefault("api-version")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "api-version", valid_568294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568295: Call_ApplicationGatewaysGet_568288; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get application gateway operation retrieves information about the specified application gateway.
  ## 
  let valid = call_568295.validator(path, query, header, formData, body)
  let scheme = call_568295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568295.url(scheme.get, call_568295.host, call_568295.base,
                         call_568295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568295, url, valid)

proc call*(call_568296: Call_ApplicationGatewaysGet_568288;
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
  var path_568297 = newJObject()
  var query_568298 = newJObject()
  add(path_568297, "resourceGroupName", newJString(resourceGroupName))
  add(query_568298, "api-version", newJString(apiVersion))
  add(path_568297, "subscriptionId", newJString(subscriptionId))
  add(path_568297, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_568296.call(path_568297, query_568298, nil, nil, nil)

var applicationGatewaysGet* = Call_ApplicationGatewaysGet_568288(
    name: "applicationGatewaysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}",
    validator: validate_ApplicationGatewaysGet_568289, base: "",
    url: url_ApplicationGatewaysGet_568290, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysDelete_568329 = ref object of OpenApiRestCall_567651
proc url_ApplicationGatewaysDelete_568331(protocol: Scheme; host: string;
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

proc validate_ApplicationGatewaysDelete_568330(path: JsonNode; query: JsonNode;
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
  var valid_568332 = path.getOrDefault("resourceGroupName")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "resourceGroupName", valid_568332
  var valid_568333 = path.getOrDefault("subscriptionId")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "subscriptionId", valid_568333
  var valid_568334 = path.getOrDefault("applicationGatewayName")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "applicationGatewayName", valid_568334
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568335 = query.getOrDefault("api-version")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "api-version", valid_568335
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568336: Call_ApplicationGatewaysDelete_568329; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete application gateway operation deletes the specified application gateway.
  ## 
  let valid = call_568336.validator(path, query, header, formData, body)
  let scheme = call_568336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568336.url(scheme.get, call_568336.host, call_568336.base,
                         call_568336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568336, url, valid)

proc call*(call_568337: Call_ApplicationGatewaysDelete_568329;
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
  var path_568338 = newJObject()
  var query_568339 = newJObject()
  add(path_568338, "resourceGroupName", newJString(resourceGroupName))
  add(query_568339, "api-version", newJString(apiVersion))
  add(path_568338, "subscriptionId", newJString(subscriptionId))
  add(path_568338, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_568337.call(path_568338, query_568339, nil, nil, nil)

var applicationGatewaysDelete* = Call_ApplicationGatewaysDelete_568329(
    name: "applicationGatewaysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}",
    validator: validate_ApplicationGatewaysDelete_568330, base: "",
    url: url_ApplicationGatewaysDelete_568331, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysStart_568340 = ref object of OpenApiRestCall_567651
proc url_ApplicationGatewaysStart_568342(protocol: Scheme; host: string;
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

proc validate_ApplicationGatewaysStart_568341(path: JsonNode; query: JsonNode;
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
  var valid_568343 = path.getOrDefault("resourceGroupName")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "resourceGroupName", valid_568343
  var valid_568344 = path.getOrDefault("subscriptionId")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "subscriptionId", valid_568344
  var valid_568345 = path.getOrDefault("applicationGatewayName")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "applicationGatewayName", valid_568345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568346 = query.getOrDefault("api-version")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "api-version", valid_568346
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568347: Call_ApplicationGatewaysStart_568340; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Start ApplicationGateway operation starts application gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_568347.validator(path, query, header, formData, body)
  let scheme = call_568347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568347.url(scheme.get, call_568347.host, call_568347.base,
                         call_568347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568347, url, valid)

proc call*(call_568348: Call_ApplicationGatewaysStart_568340;
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
  var path_568349 = newJObject()
  var query_568350 = newJObject()
  add(path_568349, "resourceGroupName", newJString(resourceGroupName))
  add(query_568350, "api-version", newJString(apiVersion))
  add(path_568349, "subscriptionId", newJString(subscriptionId))
  add(path_568349, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_568348.call(path_568349, query_568350, nil, nil, nil)

var applicationGatewaysStart* = Call_ApplicationGatewaysStart_568340(
    name: "applicationGatewaysStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}/start",
    validator: validate_ApplicationGatewaysStart_568341, base: "",
    url: url_ApplicationGatewaysStart_568342, schemes: {Scheme.Https})
type
  Call_ApplicationGatewaysStop_568351 = ref object of OpenApiRestCall_567651
proc url_ApplicationGatewaysStop_568353(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationGatewaysStop_568352(path: JsonNode; query: JsonNode;
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
  var valid_568354 = path.getOrDefault("resourceGroupName")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "resourceGroupName", valid_568354
  var valid_568355 = path.getOrDefault("subscriptionId")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "subscriptionId", valid_568355
  var valid_568356 = path.getOrDefault("applicationGatewayName")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "applicationGatewayName", valid_568356
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568357 = query.getOrDefault("api-version")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "api-version", valid_568357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568358: Call_ApplicationGatewaysStop_568351; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The STOP ApplicationGateway operation stops application gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_568358.validator(path, query, header, formData, body)
  let scheme = call_568358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568358.url(scheme.get, call_568358.host, call_568358.base,
                         call_568358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568358, url, valid)

proc call*(call_568359: Call_ApplicationGatewaysStop_568351;
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
  var path_568360 = newJObject()
  var query_568361 = newJObject()
  add(path_568360, "resourceGroupName", newJString(resourceGroupName))
  add(query_568361, "api-version", newJString(apiVersion))
  add(path_568360, "subscriptionId", newJString(subscriptionId))
  add(path_568360, "applicationGatewayName", newJString(applicationGatewayName))
  result = call_568359.call(path_568360, query_568361, nil, nil, nil)

var applicationGatewaysStop* = Call_ApplicationGatewaysStop_568351(
    name: "applicationGatewaysStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/{applicationGatewayName}/stop",
    validator: validate_ApplicationGatewaysStop_568352, base: "",
    url: url_ApplicationGatewaysStop_568353, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsList_568362 = ref object of OpenApiRestCall_567651
proc url_VirtualNetworkGatewayConnectionsList_568364(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsList_568363(path: JsonNode;
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
  var valid_568365 = path.getOrDefault("resourceGroupName")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "resourceGroupName", valid_568365
  var valid_568366 = path.getOrDefault("subscriptionId")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "subscriptionId", valid_568366
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  if body != nil:
    result.add "body", body

proc call*(call_568368: Call_VirtualNetworkGatewayConnectionsList_568362;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The List VirtualNetworkGatewayConnections operation retrieves all the virtual network gateways connections created.
  ## 
  let valid = call_568368.validator(path, query, header, formData, body)
  let scheme = call_568368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568368.url(scheme.get, call_568368.host, call_568368.base,
                         call_568368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568368, url, valid)

proc call*(call_568369: Call_VirtualNetworkGatewayConnectionsList_568362;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualNetworkGatewayConnectionsList
  ## The List VirtualNetworkGatewayConnections operation retrieves all the virtual network gateways connections created.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568370 = newJObject()
  var query_568371 = newJObject()
  add(path_568370, "resourceGroupName", newJString(resourceGroupName))
  add(query_568371, "api-version", newJString(apiVersion))
  add(path_568370, "subscriptionId", newJString(subscriptionId))
  result = call_568369.call(path_568370, query_568371, nil, nil, nil)

var virtualNetworkGatewayConnectionsList* = Call_VirtualNetworkGatewayConnectionsList_568362(
    name: "virtualNetworkGatewayConnectionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections",
    validator: validate_VirtualNetworkGatewayConnectionsList_568363, base: "",
    url: url_VirtualNetworkGatewayConnectionsList_568364, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_568383 = ref object of OpenApiRestCall_567651
proc url_VirtualNetworkGatewayConnectionsCreateOrUpdate_568385(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsCreateOrUpdate_568384(
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
  var valid_568386 = path.getOrDefault("resourceGroupName")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "resourceGroupName", valid_568386
  var valid_568387 = path.getOrDefault("subscriptionId")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "subscriptionId", valid_568387
  var valid_568388 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_568388
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568389 = query.getOrDefault("api-version")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "api-version", valid_568389
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

proc call*(call_568391: Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_568383;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put VirtualNetworkGatewayConnection operation creates/updates a virtual network gateway connection in the specified resource group through Network resource provider.
  ## 
  let valid = call_568391.validator(path, query, header, formData, body)
  let scheme = call_568391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568391.url(scheme.get, call_568391.host, call_568391.base,
                         call_568391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568391, url, valid)

proc call*(call_568392: Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_568383;
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
  var path_568393 = newJObject()
  var query_568394 = newJObject()
  var body_568395 = newJObject()
  add(path_568393, "resourceGroupName", newJString(resourceGroupName))
  add(query_568394, "api-version", newJString(apiVersion))
  add(path_568393, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568395 = parameters
  add(path_568393, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_568392.call(path_568393, query_568394, nil, nil, body_568395)

var virtualNetworkGatewayConnectionsCreateOrUpdate* = Call_VirtualNetworkGatewayConnectionsCreateOrUpdate_568383(
    name: "virtualNetworkGatewayConnectionsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}",
    validator: validate_VirtualNetworkGatewayConnectionsCreateOrUpdate_568384,
    base: "", url: url_VirtualNetworkGatewayConnectionsCreateOrUpdate_568385,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsGet_568372 = ref object of OpenApiRestCall_567651
proc url_VirtualNetworkGatewayConnectionsGet_568374(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGatewayConnectionsGet_568373(path: JsonNode;
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
  var valid_568375 = path.getOrDefault("resourceGroupName")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "resourceGroupName", valid_568375
  var valid_568376 = path.getOrDefault("subscriptionId")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "subscriptionId", valid_568376
  var valid_568377 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_568377
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568378 = query.getOrDefault("api-version")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "api-version", valid_568378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568379: Call_VirtualNetworkGatewayConnectionsGet_568372;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Get VirtualNetworkGatewayConnection operation retrieves information about the specified virtual network gateway connection through Network resource provider.
  ## 
  let valid = call_568379.validator(path, query, header, formData, body)
  let scheme = call_568379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568379.url(scheme.get, call_568379.host, call_568379.base,
                         call_568379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568379, url, valid)

proc call*(call_568380: Call_VirtualNetworkGatewayConnectionsGet_568372;
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
  var path_568381 = newJObject()
  var query_568382 = newJObject()
  add(path_568381, "resourceGroupName", newJString(resourceGroupName))
  add(query_568382, "api-version", newJString(apiVersion))
  add(path_568381, "subscriptionId", newJString(subscriptionId))
  add(path_568381, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_568380.call(path_568381, query_568382, nil, nil, nil)

var virtualNetworkGatewayConnectionsGet* = Call_VirtualNetworkGatewayConnectionsGet_568372(
    name: "virtualNetworkGatewayConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}",
    validator: validate_VirtualNetworkGatewayConnectionsGet_568373, base: "",
    url: url_VirtualNetworkGatewayConnectionsGet_568374, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsDelete_568396 = ref object of OpenApiRestCall_567651
proc url_VirtualNetworkGatewayConnectionsDelete_568398(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsDelete_568397(path: JsonNode;
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
  var valid_568399 = path.getOrDefault("resourceGroupName")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "resourceGroupName", valid_568399
  var valid_568400 = path.getOrDefault("subscriptionId")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "subscriptionId", valid_568400
  var valid_568401 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_568401
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568402 = query.getOrDefault("api-version")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "api-version", valid_568402
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568403: Call_VirtualNetworkGatewayConnectionsDelete_568396;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Delete VirtualNetworkGatewayConnection operation deletes the specified virtual network Gateway connection through Network resource provider.
  ## 
  let valid = call_568403.validator(path, query, header, formData, body)
  let scheme = call_568403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568403.url(scheme.get, call_568403.host, call_568403.base,
                         call_568403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568403, url, valid)

proc call*(call_568404: Call_VirtualNetworkGatewayConnectionsDelete_568396;
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
  var path_568405 = newJObject()
  var query_568406 = newJObject()
  add(path_568405, "resourceGroupName", newJString(resourceGroupName))
  add(query_568406, "api-version", newJString(apiVersion))
  add(path_568405, "subscriptionId", newJString(subscriptionId))
  add(path_568405, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_568404.call(path_568405, query_568406, nil, nil, nil)

var virtualNetworkGatewayConnectionsDelete* = Call_VirtualNetworkGatewayConnectionsDelete_568396(
    name: "virtualNetworkGatewayConnectionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}",
    validator: validate_VirtualNetworkGatewayConnectionsDelete_568397, base: "",
    url: url_VirtualNetworkGatewayConnectionsDelete_568398,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsSetSharedKey_568418 = ref object of OpenApiRestCall_567651
proc url_VirtualNetworkGatewayConnectionsSetSharedKey_568420(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsSetSharedKey_568419(path: JsonNode;
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
  var valid_568421 = path.getOrDefault("resourceGroupName")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "resourceGroupName", valid_568421
  var valid_568422 = path.getOrDefault("subscriptionId")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "subscriptionId", valid_568422
  var valid_568423 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_568423
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568424 = query.getOrDefault("api-version")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "api-version", valid_568424
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

proc call*(call_568426: Call_VirtualNetworkGatewayConnectionsSetSharedKey_568418;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put VirtualNetworkGatewayConnectionSharedKey operation sets the virtual network gateway connection shared key for passed virtual network gateway connection in the specified resource group through Network resource provider.
  ## 
  let valid = call_568426.validator(path, query, header, formData, body)
  let scheme = call_568426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568426.url(scheme.get, call_568426.host, call_568426.base,
                         call_568426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568426, url, valid)

proc call*(call_568427: Call_VirtualNetworkGatewayConnectionsSetSharedKey_568418;
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
  var path_568428 = newJObject()
  var query_568429 = newJObject()
  var body_568430 = newJObject()
  add(path_568428, "resourceGroupName", newJString(resourceGroupName))
  add(query_568429, "api-version", newJString(apiVersion))
  add(path_568428, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568430 = parameters
  add(path_568428, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_568427.call(path_568428, query_568429, nil, nil, body_568430)

var virtualNetworkGatewayConnectionsSetSharedKey* = Call_VirtualNetworkGatewayConnectionsSetSharedKey_568418(
    name: "virtualNetworkGatewayConnectionsSetSharedKey",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/sharedkey",
    validator: validate_VirtualNetworkGatewayConnectionsSetSharedKey_568419,
    base: "", url: url_VirtualNetworkGatewayConnectionsSetSharedKey_568420,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsGetSharedKey_568407 = ref object of OpenApiRestCall_567651
proc url_VirtualNetworkGatewayConnectionsGetSharedKey_568409(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsGetSharedKey_568408(path: JsonNode;
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
  var valid_568410 = path.getOrDefault("resourceGroupName")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "resourceGroupName", valid_568410
  var valid_568411 = path.getOrDefault("subscriptionId")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "subscriptionId", valid_568411
  var valid_568412 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_568412
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568413 = query.getOrDefault("api-version")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "api-version", valid_568413
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568414: Call_VirtualNetworkGatewayConnectionsGetSharedKey_568407;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Get VirtualNetworkGatewayConnectionSharedKey operation retrieves information about the specified virtual network gateway connection shared key through Network resource provider.
  ## 
  let valid = call_568414.validator(path, query, header, formData, body)
  let scheme = call_568414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568414.url(scheme.get, call_568414.host, call_568414.base,
                         call_568414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568414, url, valid)

proc call*(call_568415: Call_VirtualNetworkGatewayConnectionsGetSharedKey_568407;
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
  var path_568416 = newJObject()
  var query_568417 = newJObject()
  add(path_568416, "resourceGroupName", newJString(resourceGroupName))
  add(query_568417, "api-version", newJString(apiVersion))
  add(path_568416, "subscriptionId", newJString(subscriptionId))
  add(path_568416, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_568415.call(path_568416, query_568417, nil, nil, nil)

var virtualNetworkGatewayConnectionsGetSharedKey* = Call_VirtualNetworkGatewayConnectionsGetSharedKey_568407(
    name: "virtualNetworkGatewayConnectionsGetSharedKey",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/sharedkey",
    validator: validate_VirtualNetworkGatewayConnectionsGetSharedKey_568408,
    base: "", url: url_VirtualNetworkGatewayConnectionsGetSharedKey_568409,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewayConnectionsResetSharedKey_568431 = ref object of OpenApiRestCall_567651
proc url_VirtualNetworkGatewayConnectionsResetSharedKey_568433(protocol: Scheme;
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

proc validate_VirtualNetworkGatewayConnectionsResetSharedKey_568432(
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
  var valid_568434 = path.getOrDefault("resourceGroupName")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "resourceGroupName", valid_568434
  var valid_568435 = path.getOrDefault("subscriptionId")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "subscriptionId", valid_568435
  var valid_568436 = path.getOrDefault("virtualNetworkGatewayConnectionName")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "virtualNetworkGatewayConnectionName", valid_568436
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568437 = query.getOrDefault("api-version")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "api-version", valid_568437
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

proc call*(call_568439: Call_VirtualNetworkGatewayConnectionsResetSharedKey_568431;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The VirtualNetworkGatewayConnectionResetSharedKey operation resets the virtual network gateway connection shared key for passed virtual network gateway connection in the specified resource group through Network resource provider.
  ## 
  let valid = call_568439.validator(path, query, header, formData, body)
  let scheme = call_568439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568439.url(scheme.get, call_568439.host, call_568439.base,
                         call_568439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568439, url, valid)

proc call*(call_568440: Call_VirtualNetworkGatewayConnectionsResetSharedKey_568431;
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
  var path_568441 = newJObject()
  var query_568442 = newJObject()
  var body_568443 = newJObject()
  add(path_568441, "resourceGroupName", newJString(resourceGroupName))
  add(query_568442, "api-version", newJString(apiVersion))
  add(path_568441, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568443 = parameters
  add(path_568441, "virtualNetworkGatewayConnectionName",
      newJString(virtualNetworkGatewayConnectionName))
  result = call_568440.call(path_568441, query_568442, nil, nil, body_568443)

var virtualNetworkGatewayConnectionsResetSharedKey* = Call_VirtualNetworkGatewayConnectionsResetSharedKey_568431(
    name: "virtualNetworkGatewayConnectionsResetSharedKey",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/connections/{virtualNetworkGatewayConnectionName}/sharedkey/reset",
    validator: validate_VirtualNetworkGatewayConnectionsResetSharedKey_568432,
    base: "", url: url_VirtualNetworkGatewayConnectionsResetSharedKey_568433,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsList_568444 = ref object of OpenApiRestCall_567651
proc url_ExpressRouteCircuitsList_568446(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsList_568445(path: JsonNode; query: JsonNode;
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
  var valid_568447 = path.getOrDefault("resourceGroupName")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = nil)
  if valid_568447 != nil:
    section.add "resourceGroupName", valid_568447
  var valid_568448 = path.getOrDefault("subscriptionId")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "subscriptionId", valid_568448
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568449 = query.getOrDefault("api-version")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "api-version", valid_568449
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568450: Call_ExpressRouteCircuitsList_568444; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List ExpressRouteCircuit operation retrieves all the ExpressRouteCircuits in a resource group.
  ## 
  let valid = call_568450.validator(path, query, header, formData, body)
  let scheme = call_568450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568450.url(scheme.get, call_568450.host, call_568450.base,
                         call_568450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568450, url, valid)

proc call*(call_568451: Call_ExpressRouteCircuitsList_568444;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteCircuitsList
  ## The List ExpressRouteCircuit operation retrieves all the ExpressRouteCircuits in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568452 = newJObject()
  var query_568453 = newJObject()
  add(path_568452, "resourceGroupName", newJString(resourceGroupName))
  add(query_568453, "api-version", newJString(apiVersion))
  add(path_568452, "subscriptionId", newJString(subscriptionId))
  result = call_568451.call(path_568452, query_568453, nil, nil, nil)

var expressRouteCircuitsList* = Call_ExpressRouteCircuitsList_568444(
    name: "expressRouteCircuitsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits",
    validator: validate_ExpressRouteCircuitsList_568445, base: "",
    url: url_ExpressRouteCircuitsList_568446, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsCreateOrUpdate_568465 = ref object of OpenApiRestCall_567651
proc url_ExpressRouteCircuitsCreateOrUpdate_568467(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsCreateOrUpdate_568466(path: JsonNode;
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
  var valid_568468 = path.getOrDefault("circuitName")
  valid_568468 = validateParameter(valid_568468, JString, required = true,
                                 default = nil)
  if valid_568468 != nil:
    section.add "circuitName", valid_568468
  var valid_568469 = path.getOrDefault("resourceGroupName")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "resourceGroupName", valid_568469
  var valid_568470 = path.getOrDefault("subscriptionId")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = nil)
  if valid_568470 != nil:
    section.add "subscriptionId", valid_568470
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568471 = query.getOrDefault("api-version")
  valid_568471 = validateParameter(valid_568471, JString, required = true,
                                 default = nil)
  if valid_568471 != nil:
    section.add "api-version", valid_568471
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

proc call*(call_568473: Call_ExpressRouteCircuitsCreateOrUpdate_568465;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put ExpressRouteCircuit operation creates/updates a ExpressRouteCircuit
  ## 
  let valid = call_568473.validator(path, query, header, formData, body)
  let scheme = call_568473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568473.url(scheme.get, call_568473.host, call_568473.base,
                         call_568473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568473, url, valid)

proc call*(call_568474: Call_ExpressRouteCircuitsCreateOrUpdate_568465;
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
  var path_568475 = newJObject()
  var query_568476 = newJObject()
  var body_568477 = newJObject()
  add(path_568475, "circuitName", newJString(circuitName))
  add(path_568475, "resourceGroupName", newJString(resourceGroupName))
  add(query_568476, "api-version", newJString(apiVersion))
  add(path_568475, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568477 = parameters
  result = call_568474.call(path_568475, query_568476, nil, nil, body_568477)

var expressRouteCircuitsCreateOrUpdate* = Call_ExpressRouteCircuitsCreateOrUpdate_568465(
    name: "expressRouteCircuitsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}",
    validator: validate_ExpressRouteCircuitsCreateOrUpdate_568466, base: "",
    url: url_ExpressRouteCircuitsCreateOrUpdate_568467, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsGet_568454 = ref object of OpenApiRestCall_567651
proc url_ExpressRouteCircuitsGet_568456(protocol: Scheme; host: string; base: string;
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

proc validate_ExpressRouteCircuitsGet_568455(path: JsonNode; query: JsonNode;
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
  var valid_568457 = path.getOrDefault("circuitName")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = nil)
  if valid_568457 != nil:
    section.add "circuitName", valid_568457
  var valid_568458 = path.getOrDefault("resourceGroupName")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "resourceGroupName", valid_568458
  var valid_568459 = path.getOrDefault("subscriptionId")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "subscriptionId", valid_568459
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568460 = query.getOrDefault("api-version")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "api-version", valid_568460
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568461: Call_ExpressRouteCircuitsGet_568454; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get ExpressRouteCircuit operation retrieves information about the specified ExpressRouteCircuit.
  ## 
  let valid = call_568461.validator(path, query, header, formData, body)
  let scheme = call_568461.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568461.url(scheme.get, call_568461.host, call_568461.base,
                         call_568461.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568461, url, valid)

proc call*(call_568462: Call_ExpressRouteCircuitsGet_568454; circuitName: string;
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
  var path_568463 = newJObject()
  var query_568464 = newJObject()
  add(path_568463, "circuitName", newJString(circuitName))
  add(path_568463, "resourceGroupName", newJString(resourceGroupName))
  add(query_568464, "api-version", newJString(apiVersion))
  add(path_568463, "subscriptionId", newJString(subscriptionId))
  result = call_568462.call(path_568463, query_568464, nil, nil, nil)

var expressRouteCircuitsGet* = Call_ExpressRouteCircuitsGet_568454(
    name: "expressRouteCircuitsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}",
    validator: validate_ExpressRouteCircuitsGet_568455, base: "",
    url: url_ExpressRouteCircuitsGet_568456, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsDelete_568478 = ref object of OpenApiRestCall_567651
proc url_ExpressRouteCircuitsDelete_568480(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsDelete_568479(path: JsonNode; query: JsonNode;
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
  var valid_568481 = path.getOrDefault("circuitName")
  valid_568481 = validateParameter(valid_568481, JString, required = true,
                                 default = nil)
  if valid_568481 != nil:
    section.add "circuitName", valid_568481
  var valid_568482 = path.getOrDefault("resourceGroupName")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = nil)
  if valid_568482 != nil:
    section.add "resourceGroupName", valid_568482
  var valid_568483 = path.getOrDefault("subscriptionId")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = nil)
  if valid_568483 != nil:
    section.add "subscriptionId", valid_568483
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568484 = query.getOrDefault("api-version")
  valid_568484 = validateParameter(valid_568484, JString, required = true,
                                 default = nil)
  if valid_568484 != nil:
    section.add "api-version", valid_568484
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568485: Call_ExpressRouteCircuitsDelete_568478; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete ExpressRouteCircuit operation deletes the specified ExpressRouteCircuit.
  ## 
  let valid = call_568485.validator(path, query, header, formData, body)
  let scheme = call_568485.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568485.url(scheme.get, call_568485.host, call_568485.base,
                         call_568485.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568485, url, valid)

proc call*(call_568486: Call_ExpressRouteCircuitsDelete_568478;
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
  var path_568487 = newJObject()
  var query_568488 = newJObject()
  add(path_568487, "circuitName", newJString(circuitName))
  add(path_568487, "resourceGroupName", newJString(resourceGroupName))
  add(query_568488, "api-version", newJString(apiVersion))
  add(path_568487, "subscriptionId", newJString(subscriptionId))
  result = call_568486.call(path_568487, query_568488, nil, nil, nil)

var expressRouteCircuitsDelete* = Call_ExpressRouteCircuitsDelete_568478(
    name: "expressRouteCircuitsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}",
    validator: validate_ExpressRouteCircuitsDelete_568479, base: "",
    url: url_ExpressRouteCircuitsDelete_568480, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsList_568489 = ref object of OpenApiRestCall_567651
proc url_ExpressRouteCircuitAuthorizationsList_568491(protocol: Scheme;
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

proc validate_ExpressRouteCircuitAuthorizationsList_568490(path: JsonNode;
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
  var valid_568492 = path.getOrDefault("circuitName")
  valid_568492 = validateParameter(valid_568492, JString, required = true,
                                 default = nil)
  if valid_568492 != nil:
    section.add "circuitName", valid_568492
  var valid_568493 = path.getOrDefault("resourceGroupName")
  valid_568493 = validateParameter(valid_568493, JString, required = true,
                                 default = nil)
  if valid_568493 != nil:
    section.add "resourceGroupName", valid_568493
  var valid_568494 = path.getOrDefault("subscriptionId")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = nil)
  if valid_568494 != nil:
    section.add "subscriptionId", valid_568494
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568495 = query.getOrDefault("api-version")
  valid_568495 = validateParameter(valid_568495, JString, required = true,
                                 default = nil)
  if valid_568495 != nil:
    section.add "api-version", valid_568495
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568496: Call_ExpressRouteCircuitAuthorizationsList_568489;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The List authorization operation retrieves all the authorizations in an ExpressRouteCircuit.
  ## 
  let valid = call_568496.validator(path, query, header, formData, body)
  let scheme = call_568496.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568496.url(scheme.get, call_568496.host, call_568496.base,
                         call_568496.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568496, url, valid)

proc call*(call_568497: Call_ExpressRouteCircuitAuthorizationsList_568489;
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
  var path_568498 = newJObject()
  var query_568499 = newJObject()
  add(path_568498, "circuitName", newJString(circuitName))
  add(path_568498, "resourceGroupName", newJString(resourceGroupName))
  add(query_568499, "api-version", newJString(apiVersion))
  add(path_568498, "subscriptionId", newJString(subscriptionId))
  result = call_568497.call(path_568498, query_568499, nil, nil, nil)

var expressRouteCircuitAuthorizationsList* = Call_ExpressRouteCircuitAuthorizationsList_568489(
    name: "expressRouteCircuitAuthorizationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations",
    validator: validate_ExpressRouteCircuitAuthorizationsList_568490, base: "",
    url: url_ExpressRouteCircuitAuthorizationsList_568491, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_568512 = ref object of OpenApiRestCall_567651
proc url_ExpressRouteCircuitAuthorizationsCreateOrUpdate_568514(protocol: Scheme;
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

proc validate_ExpressRouteCircuitAuthorizationsCreateOrUpdate_568513(
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
  var valid_568515 = path.getOrDefault("circuitName")
  valid_568515 = validateParameter(valid_568515, JString, required = true,
                                 default = nil)
  if valid_568515 != nil:
    section.add "circuitName", valid_568515
  var valid_568516 = path.getOrDefault("resourceGroupName")
  valid_568516 = validateParameter(valid_568516, JString, required = true,
                                 default = nil)
  if valid_568516 != nil:
    section.add "resourceGroupName", valid_568516
  var valid_568517 = path.getOrDefault("subscriptionId")
  valid_568517 = validateParameter(valid_568517, JString, required = true,
                                 default = nil)
  if valid_568517 != nil:
    section.add "subscriptionId", valid_568517
  var valid_568518 = path.getOrDefault("authorizationName")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "authorizationName", valid_568518
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568519 = query.getOrDefault("api-version")
  valid_568519 = validateParameter(valid_568519, JString, required = true,
                                 default = nil)
  if valid_568519 != nil:
    section.add "api-version", valid_568519
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

proc call*(call_568521: Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_568512;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put Authorization operation creates/updates an authorization in the specified ExpressRouteCircuits
  ## 
  let valid = call_568521.validator(path, query, header, formData, body)
  let scheme = call_568521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568521.url(scheme.get, call_568521.host, call_568521.base,
                         call_568521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568521, url, valid)

proc call*(call_568522: Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_568512;
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
  var path_568523 = newJObject()
  var query_568524 = newJObject()
  var body_568525 = newJObject()
  add(path_568523, "circuitName", newJString(circuitName))
  add(path_568523, "resourceGroupName", newJString(resourceGroupName))
  add(query_568524, "api-version", newJString(apiVersion))
  add(path_568523, "subscriptionId", newJString(subscriptionId))
  if authorizationParameters != nil:
    body_568525 = authorizationParameters
  add(path_568523, "authorizationName", newJString(authorizationName))
  result = call_568522.call(path_568523, query_568524, nil, nil, body_568525)

var expressRouteCircuitAuthorizationsCreateOrUpdate* = Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_568512(
    name: "expressRouteCircuitAuthorizationsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations/{authorizationName}",
    validator: validate_ExpressRouteCircuitAuthorizationsCreateOrUpdate_568513,
    base: "", url: url_ExpressRouteCircuitAuthorizationsCreateOrUpdate_568514,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsGet_568500 = ref object of OpenApiRestCall_567651
proc url_ExpressRouteCircuitAuthorizationsGet_568502(protocol: Scheme;
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

proc validate_ExpressRouteCircuitAuthorizationsGet_568501(path: JsonNode;
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
  var valid_568503 = path.getOrDefault("circuitName")
  valid_568503 = validateParameter(valid_568503, JString, required = true,
                                 default = nil)
  if valid_568503 != nil:
    section.add "circuitName", valid_568503
  var valid_568504 = path.getOrDefault("resourceGroupName")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "resourceGroupName", valid_568504
  var valid_568505 = path.getOrDefault("subscriptionId")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "subscriptionId", valid_568505
  var valid_568506 = path.getOrDefault("authorizationName")
  valid_568506 = validateParameter(valid_568506, JString, required = true,
                                 default = nil)
  if valid_568506 != nil:
    section.add "authorizationName", valid_568506
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568507 = query.getOrDefault("api-version")
  valid_568507 = validateParameter(valid_568507, JString, required = true,
                                 default = nil)
  if valid_568507 != nil:
    section.add "api-version", valid_568507
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568508: Call_ExpressRouteCircuitAuthorizationsGet_568500;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The GET authorization operation retrieves the specified authorization from the specified ExpressRouteCircuit.
  ## 
  let valid = call_568508.validator(path, query, header, formData, body)
  let scheme = call_568508.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568508.url(scheme.get, call_568508.host, call_568508.base,
                         call_568508.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568508, url, valid)

proc call*(call_568509: Call_ExpressRouteCircuitAuthorizationsGet_568500;
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
  var path_568510 = newJObject()
  var query_568511 = newJObject()
  add(path_568510, "circuitName", newJString(circuitName))
  add(path_568510, "resourceGroupName", newJString(resourceGroupName))
  add(query_568511, "api-version", newJString(apiVersion))
  add(path_568510, "subscriptionId", newJString(subscriptionId))
  add(path_568510, "authorizationName", newJString(authorizationName))
  result = call_568509.call(path_568510, query_568511, nil, nil, nil)

var expressRouteCircuitAuthorizationsGet* = Call_ExpressRouteCircuitAuthorizationsGet_568500(
    name: "expressRouteCircuitAuthorizationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations/{authorizationName}",
    validator: validate_ExpressRouteCircuitAuthorizationsGet_568501, base: "",
    url: url_ExpressRouteCircuitAuthorizationsGet_568502, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsDelete_568526 = ref object of OpenApiRestCall_567651
proc url_ExpressRouteCircuitAuthorizationsDelete_568528(protocol: Scheme;
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

proc validate_ExpressRouteCircuitAuthorizationsDelete_568527(path: JsonNode;
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
  var valid_568529 = path.getOrDefault("circuitName")
  valid_568529 = validateParameter(valid_568529, JString, required = true,
                                 default = nil)
  if valid_568529 != nil:
    section.add "circuitName", valid_568529
  var valid_568530 = path.getOrDefault("resourceGroupName")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "resourceGroupName", valid_568530
  var valid_568531 = path.getOrDefault("subscriptionId")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "subscriptionId", valid_568531
  var valid_568532 = path.getOrDefault("authorizationName")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "authorizationName", valid_568532
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568533 = query.getOrDefault("api-version")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "api-version", valid_568533
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568534: Call_ExpressRouteCircuitAuthorizationsDelete_568526;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The delete authorization operation deletes the specified authorization from the specified ExpressRouteCircuit.
  ## 
  let valid = call_568534.validator(path, query, header, formData, body)
  let scheme = call_568534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568534.url(scheme.get, call_568534.host, call_568534.base,
                         call_568534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568534, url, valid)

proc call*(call_568535: Call_ExpressRouteCircuitAuthorizationsDelete_568526;
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
  var path_568536 = newJObject()
  var query_568537 = newJObject()
  add(path_568536, "circuitName", newJString(circuitName))
  add(path_568536, "resourceGroupName", newJString(resourceGroupName))
  add(query_568537, "api-version", newJString(apiVersion))
  add(path_568536, "subscriptionId", newJString(subscriptionId))
  add(path_568536, "authorizationName", newJString(authorizationName))
  result = call_568535.call(path_568536, query_568537, nil, nil, nil)

var expressRouteCircuitAuthorizationsDelete* = Call_ExpressRouteCircuitAuthorizationsDelete_568526(
    name: "expressRouteCircuitAuthorizationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations/{authorizationName}",
    validator: validate_ExpressRouteCircuitAuthorizationsDelete_568527, base: "",
    url: url_ExpressRouteCircuitAuthorizationsDelete_568528,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsList_568538 = ref object of OpenApiRestCall_567651
proc url_ExpressRouteCircuitPeeringsList_568540(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitPeeringsList_568539(path: JsonNode;
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
  var valid_568541 = path.getOrDefault("circuitName")
  valid_568541 = validateParameter(valid_568541, JString, required = true,
                                 default = nil)
  if valid_568541 != nil:
    section.add "circuitName", valid_568541
  var valid_568542 = path.getOrDefault("resourceGroupName")
  valid_568542 = validateParameter(valid_568542, JString, required = true,
                                 default = nil)
  if valid_568542 != nil:
    section.add "resourceGroupName", valid_568542
  var valid_568543 = path.getOrDefault("subscriptionId")
  valid_568543 = validateParameter(valid_568543, JString, required = true,
                                 default = nil)
  if valid_568543 != nil:
    section.add "subscriptionId", valid_568543
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568544 = query.getOrDefault("api-version")
  valid_568544 = validateParameter(valid_568544, JString, required = true,
                                 default = nil)
  if valid_568544 != nil:
    section.add "api-version", valid_568544
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568545: Call_ExpressRouteCircuitPeeringsList_568538;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The List peering operation retrieves all the peerings in an ExpressRouteCircuit.
  ## 
  let valid = call_568545.validator(path, query, header, formData, body)
  let scheme = call_568545.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568545.url(scheme.get, call_568545.host, call_568545.base,
                         call_568545.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568545, url, valid)

proc call*(call_568546: Call_ExpressRouteCircuitPeeringsList_568538;
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
  var path_568547 = newJObject()
  var query_568548 = newJObject()
  add(path_568547, "circuitName", newJString(circuitName))
  add(path_568547, "resourceGroupName", newJString(resourceGroupName))
  add(query_568548, "api-version", newJString(apiVersion))
  add(path_568547, "subscriptionId", newJString(subscriptionId))
  result = call_568546.call(path_568547, query_568548, nil, nil, nil)

var expressRouteCircuitPeeringsList* = Call_ExpressRouteCircuitPeeringsList_568538(
    name: "expressRouteCircuitPeeringsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings",
    validator: validate_ExpressRouteCircuitPeeringsList_568539, base: "",
    url: url_ExpressRouteCircuitPeeringsList_568540, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsCreateOrUpdate_568561 = ref object of OpenApiRestCall_567651
proc url_ExpressRouteCircuitPeeringsCreateOrUpdate_568563(protocol: Scheme;
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

proc validate_ExpressRouteCircuitPeeringsCreateOrUpdate_568562(path: JsonNode;
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
  var valid_568564 = path.getOrDefault("circuitName")
  valid_568564 = validateParameter(valid_568564, JString, required = true,
                                 default = nil)
  if valid_568564 != nil:
    section.add "circuitName", valid_568564
  var valid_568565 = path.getOrDefault("resourceGroupName")
  valid_568565 = validateParameter(valid_568565, JString, required = true,
                                 default = nil)
  if valid_568565 != nil:
    section.add "resourceGroupName", valid_568565
  var valid_568566 = path.getOrDefault("peeringName")
  valid_568566 = validateParameter(valid_568566, JString, required = true,
                                 default = nil)
  if valid_568566 != nil:
    section.add "peeringName", valid_568566
  var valid_568567 = path.getOrDefault("subscriptionId")
  valid_568567 = validateParameter(valid_568567, JString, required = true,
                                 default = nil)
  if valid_568567 != nil:
    section.add "subscriptionId", valid_568567
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568568 = query.getOrDefault("api-version")
  valid_568568 = validateParameter(valid_568568, JString, required = true,
                                 default = nil)
  if valid_568568 != nil:
    section.add "api-version", valid_568568
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

proc call*(call_568570: Call_ExpressRouteCircuitPeeringsCreateOrUpdate_568561;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put Peering operation creates/updates an peering in the specified ExpressRouteCircuits
  ## 
  let valid = call_568570.validator(path, query, header, formData, body)
  let scheme = call_568570.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568570.url(scheme.get, call_568570.host, call_568570.base,
                         call_568570.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568570, url, valid)

proc call*(call_568571: Call_ExpressRouteCircuitPeeringsCreateOrUpdate_568561;
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
  var path_568572 = newJObject()
  var query_568573 = newJObject()
  var body_568574 = newJObject()
  add(path_568572, "circuitName", newJString(circuitName))
  add(path_568572, "resourceGroupName", newJString(resourceGroupName))
  add(query_568573, "api-version", newJString(apiVersion))
  add(path_568572, "peeringName", newJString(peeringName))
  add(path_568572, "subscriptionId", newJString(subscriptionId))
  if peeringParameters != nil:
    body_568574 = peeringParameters
  result = call_568571.call(path_568572, query_568573, nil, nil, body_568574)

var expressRouteCircuitPeeringsCreateOrUpdate* = Call_ExpressRouteCircuitPeeringsCreateOrUpdate_568561(
    name: "expressRouteCircuitPeeringsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCircuitPeeringsCreateOrUpdate_568562,
    base: "", url: url_ExpressRouteCircuitPeeringsCreateOrUpdate_568563,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsGet_568549 = ref object of OpenApiRestCall_567651
proc url_ExpressRouteCircuitPeeringsGet_568551(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitPeeringsGet_568550(path: JsonNode;
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
  var valid_568552 = path.getOrDefault("circuitName")
  valid_568552 = validateParameter(valid_568552, JString, required = true,
                                 default = nil)
  if valid_568552 != nil:
    section.add "circuitName", valid_568552
  var valid_568553 = path.getOrDefault("resourceGroupName")
  valid_568553 = validateParameter(valid_568553, JString, required = true,
                                 default = nil)
  if valid_568553 != nil:
    section.add "resourceGroupName", valid_568553
  var valid_568554 = path.getOrDefault("peeringName")
  valid_568554 = validateParameter(valid_568554, JString, required = true,
                                 default = nil)
  if valid_568554 != nil:
    section.add "peeringName", valid_568554
  var valid_568555 = path.getOrDefault("subscriptionId")
  valid_568555 = validateParameter(valid_568555, JString, required = true,
                                 default = nil)
  if valid_568555 != nil:
    section.add "subscriptionId", valid_568555
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568556 = query.getOrDefault("api-version")
  valid_568556 = validateParameter(valid_568556, JString, required = true,
                                 default = nil)
  if valid_568556 != nil:
    section.add "api-version", valid_568556
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568557: Call_ExpressRouteCircuitPeeringsGet_568549; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GET peering operation retrieves the specified authorization from the ExpressRouteCircuit.
  ## 
  let valid = call_568557.validator(path, query, header, formData, body)
  let scheme = call_568557.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568557.url(scheme.get, call_568557.host, call_568557.base,
                         call_568557.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568557, url, valid)

proc call*(call_568558: Call_ExpressRouteCircuitPeeringsGet_568549;
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
  var path_568559 = newJObject()
  var query_568560 = newJObject()
  add(path_568559, "circuitName", newJString(circuitName))
  add(path_568559, "resourceGroupName", newJString(resourceGroupName))
  add(query_568560, "api-version", newJString(apiVersion))
  add(path_568559, "peeringName", newJString(peeringName))
  add(path_568559, "subscriptionId", newJString(subscriptionId))
  result = call_568558.call(path_568559, query_568560, nil, nil, nil)

var expressRouteCircuitPeeringsGet* = Call_ExpressRouteCircuitPeeringsGet_568549(
    name: "expressRouteCircuitPeeringsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCircuitPeeringsGet_568550, base: "",
    url: url_ExpressRouteCircuitPeeringsGet_568551, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsDelete_568575 = ref object of OpenApiRestCall_567651
proc url_ExpressRouteCircuitPeeringsDelete_568577(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitPeeringsDelete_568576(path: JsonNode;
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
  var valid_568578 = path.getOrDefault("circuitName")
  valid_568578 = validateParameter(valid_568578, JString, required = true,
                                 default = nil)
  if valid_568578 != nil:
    section.add "circuitName", valid_568578
  var valid_568579 = path.getOrDefault("resourceGroupName")
  valid_568579 = validateParameter(valid_568579, JString, required = true,
                                 default = nil)
  if valid_568579 != nil:
    section.add "resourceGroupName", valid_568579
  var valid_568580 = path.getOrDefault("peeringName")
  valid_568580 = validateParameter(valid_568580, JString, required = true,
                                 default = nil)
  if valid_568580 != nil:
    section.add "peeringName", valid_568580
  var valid_568581 = path.getOrDefault("subscriptionId")
  valid_568581 = validateParameter(valid_568581, JString, required = true,
                                 default = nil)
  if valid_568581 != nil:
    section.add "subscriptionId", valid_568581
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568582 = query.getOrDefault("api-version")
  valid_568582 = validateParameter(valid_568582, JString, required = true,
                                 default = nil)
  if valid_568582 != nil:
    section.add "api-version", valid_568582
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568583: Call_ExpressRouteCircuitPeeringsDelete_568575;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The delete peering operation deletes the specified peering from the ExpressRouteCircuit.
  ## 
  let valid = call_568583.validator(path, query, header, formData, body)
  let scheme = call_568583.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568583.url(scheme.get, call_568583.host, call_568583.base,
                         call_568583.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568583, url, valid)

proc call*(call_568584: Call_ExpressRouteCircuitPeeringsDelete_568575;
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
  var path_568585 = newJObject()
  var query_568586 = newJObject()
  add(path_568585, "circuitName", newJString(circuitName))
  add(path_568585, "resourceGroupName", newJString(resourceGroupName))
  add(query_568586, "api-version", newJString(apiVersion))
  add(path_568585, "peeringName", newJString(peeringName))
  add(path_568585, "subscriptionId", newJString(subscriptionId))
  result = call_568584.call(path_568585, query_568586, nil, nil, nil)

var expressRouteCircuitPeeringsDelete* = Call_ExpressRouteCircuitPeeringsDelete_568575(
    name: "expressRouteCircuitPeeringsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCircuitPeeringsDelete_568576, base: "",
    url: url_ExpressRouteCircuitPeeringsDelete_568577, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsListArpTable_568587 = ref object of OpenApiRestCall_567651
proc url_ExpressRouteCircuitsListArpTable_568589(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsListArpTable_568588(path: JsonNode;
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
  var valid_568590 = path.getOrDefault("circuitName")
  valid_568590 = validateParameter(valid_568590, JString, required = true,
                                 default = nil)
  if valid_568590 != nil:
    section.add "circuitName", valid_568590
  var valid_568591 = path.getOrDefault("resourceGroupName")
  valid_568591 = validateParameter(valid_568591, JString, required = true,
                                 default = nil)
  if valid_568591 != nil:
    section.add "resourceGroupName", valid_568591
  var valid_568592 = path.getOrDefault("peeringName")
  valid_568592 = validateParameter(valid_568592, JString, required = true,
                                 default = nil)
  if valid_568592 != nil:
    section.add "peeringName", valid_568592
  var valid_568593 = path.getOrDefault("subscriptionId")
  valid_568593 = validateParameter(valid_568593, JString, required = true,
                                 default = nil)
  if valid_568593 != nil:
    section.add "subscriptionId", valid_568593
  var valid_568594 = path.getOrDefault("devicePath")
  valid_568594 = validateParameter(valid_568594, JString, required = true,
                                 default = nil)
  if valid_568594 != nil:
    section.add "devicePath", valid_568594
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568595 = query.getOrDefault("api-version")
  valid_568595 = validateParameter(valid_568595, JString, required = true,
                                 default = nil)
  if valid_568595 != nil:
    section.add "api-version", valid_568595
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568596: Call_ExpressRouteCircuitsListArpTable_568587;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The ListArpTable from ExpressRouteCircuit operation retrieves the currently advertised arp table associated with the ExpressRouteCircuits in a resource group.
  ## 
  let valid = call_568596.validator(path, query, header, formData, body)
  let scheme = call_568596.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568596.url(scheme.get, call_568596.host, call_568596.base,
                         call_568596.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568596, url, valid)

proc call*(call_568597: Call_ExpressRouteCircuitsListArpTable_568587;
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
  var path_568598 = newJObject()
  var query_568599 = newJObject()
  add(path_568598, "circuitName", newJString(circuitName))
  add(path_568598, "resourceGroupName", newJString(resourceGroupName))
  add(query_568599, "api-version", newJString(apiVersion))
  add(path_568598, "peeringName", newJString(peeringName))
  add(path_568598, "subscriptionId", newJString(subscriptionId))
  add(path_568598, "devicePath", newJString(devicePath))
  result = call_568597.call(path_568598, query_568599, nil, nil, nil)

var expressRouteCircuitsListArpTable* = Call_ExpressRouteCircuitsListArpTable_568587(
    name: "expressRouteCircuitsListArpTable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/arpTables/{devicePath}",
    validator: validate_ExpressRouteCircuitsListArpTable_568588, base: "",
    url: url_ExpressRouteCircuitsListArpTable_568589, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsListRoutesTable_568600 = ref object of OpenApiRestCall_567651
proc url_ExpressRouteCircuitsListRoutesTable_568602(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsListRoutesTable_568601(path: JsonNode;
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
  var valid_568603 = path.getOrDefault("circuitName")
  valid_568603 = validateParameter(valid_568603, JString, required = true,
                                 default = nil)
  if valid_568603 != nil:
    section.add "circuitName", valid_568603
  var valid_568604 = path.getOrDefault("resourceGroupName")
  valid_568604 = validateParameter(valid_568604, JString, required = true,
                                 default = nil)
  if valid_568604 != nil:
    section.add "resourceGroupName", valid_568604
  var valid_568605 = path.getOrDefault("peeringName")
  valid_568605 = validateParameter(valid_568605, JString, required = true,
                                 default = nil)
  if valid_568605 != nil:
    section.add "peeringName", valid_568605
  var valid_568606 = path.getOrDefault("subscriptionId")
  valid_568606 = validateParameter(valid_568606, JString, required = true,
                                 default = nil)
  if valid_568606 != nil:
    section.add "subscriptionId", valid_568606
  var valid_568607 = path.getOrDefault("devicePath")
  valid_568607 = validateParameter(valid_568607, JString, required = true,
                                 default = nil)
  if valid_568607 != nil:
    section.add "devicePath", valid_568607
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568608 = query.getOrDefault("api-version")
  valid_568608 = validateParameter(valid_568608, JString, required = true,
                                 default = nil)
  if valid_568608 != nil:
    section.add "api-version", valid_568608
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568609: Call_ExpressRouteCircuitsListRoutesTable_568600;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The ListRoutesTable from ExpressRouteCircuit operation retrieves the currently advertised routes table associated with the ExpressRouteCircuits in a resource group.
  ## 
  let valid = call_568609.validator(path, query, header, formData, body)
  let scheme = call_568609.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568609.url(scheme.get, call_568609.host, call_568609.base,
                         call_568609.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568609, url, valid)

proc call*(call_568610: Call_ExpressRouteCircuitsListRoutesTable_568600;
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
  var path_568611 = newJObject()
  var query_568612 = newJObject()
  add(path_568611, "circuitName", newJString(circuitName))
  add(path_568611, "resourceGroupName", newJString(resourceGroupName))
  add(query_568612, "api-version", newJString(apiVersion))
  add(path_568611, "peeringName", newJString(peeringName))
  add(path_568611, "subscriptionId", newJString(subscriptionId))
  add(path_568611, "devicePath", newJString(devicePath))
  result = call_568610.call(path_568611, query_568612, nil, nil, nil)

var expressRouteCircuitsListRoutesTable* = Call_ExpressRouteCircuitsListRoutesTable_568600(
    name: "expressRouteCircuitsListRoutesTable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/routeTables/{devicePath}",
    validator: validate_ExpressRouteCircuitsListRoutesTable_568601, base: "",
    url: url_ExpressRouteCircuitsListRoutesTable_568602, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsListRoutesTableSummary_568613 = ref object of OpenApiRestCall_567651
proc url_ExpressRouteCircuitsListRoutesTableSummary_568615(protocol: Scheme;
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

proc validate_ExpressRouteCircuitsListRoutesTableSummary_568614(path: JsonNode;
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
  var valid_568616 = path.getOrDefault("circuitName")
  valid_568616 = validateParameter(valid_568616, JString, required = true,
                                 default = nil)
  if valid_568616 != nil:
    section.add "circuitName", valid_568616
  var valid_568617 = path.getOrDefault("resourceGroupName")
  valid_568617 = validateParameter(valid_568617, JString, required = true,
                                 default = nil)
  if valid_568617 != nil:
    section.add "resourceGroupName", valid_568617
  var valid_568618 = path.getOrDefault("peeringName")
  valid_568618 = validateParameter(valid_568618, JString, required = true,
                                 default = nil)
  if valid_568618 != nil:
    section.add "peeringName", valid_568618
  var valid_568619 = path.getOrDefault("subscriptionId")
  valid_568619 = validateParameter(valid_568619, JString, required = true,
                                 default = nil)
  if valid_568619 != nil:
    section.add "subscriptionId", valid_568619
  var valid_568620 = path.getOrDefault("devicePath")
  valid_568620 = validateParameter(valid_568620, JString, required = true,
                                 default = nil)
  if valid_568620 != nil:
    section.add "devicePath", valid_568620
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568621 = query.getOrDefault("api-version")
  valid_568621 = validateParameter(valid_568621, JString, required = true,
                                 default = nil)
  if valid_568621 != nil:
    section.add "api-version", valid_568621
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568622: Call_ExpressRouteCircuitsListRoutesTableSummary_568613;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The ListRoutesTable from ExpressRouteCircuit operation retrieves the currently advertised routes table associated with the ExpressRouteCircuits in a resource group.
  ## 
  let valid = call_568622.validator(path, query, header, formData, body)
  let scheme = call_568622.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568622.url(scheme.get, call_568622.host, call_568622.base,
                         call_568622.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568622, url, valid)

proc call*(call_568623: Call_ExpressRouteCircuitsListRoutesTableSummary_568613;
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
  var path_568624 = newJObject()
  var query_568625 = newJObject()
  add(path_568624, "circuitName", newJString(circuitName))
  add(path_568624, "resourceGroupName", newJString(resourceGroupName))
  add(query_568625, "api-version", newJString(apiVersion))
  add(path_568624, "peeringName", newJString(peeringName))
  add(path_568624, "subscriptionId", newJString(subscriptionId))
  add(path_568624, "devicePath", newJString(devicePath))
  result = call_568623.call(path_568624, query_568625, nil, nil, nil)

var expressRouteCircuitsListRoutesTableSummary* = Call_ExpressRouteCircuitsListRoutesTableSummary_568613(
    name: "expressRouteCircuitsListRoutesTableSummary", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/routeTablesSummary/{devicePath}",
    validator: validate_ExpressRouteCircuitsListRoutesTableSummary_568614,
    base: "", url: url_ExpressRouteCircuitsListRoutesTableSummary_568615,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsGetPeeringStats_568626 = ref object of OpenApiRestCall_567651
proc url_ExpressRouteCircuitsGetPeeringStats_568628(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsGetPeeringStats_568627(path: JsonNode;
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
  var valid_568629 = path.getOrDefault("circuitName")
  valid_568629 = validateParameter(valid_568629, JString, required = true,
                                 default = nil)
  if valid_568629 != nil:
    section.add "circuitName", valid_568629
  var valid_568630 = path.getOrDefault("resourceGroupName")
  valid_568630 = validateParameter(valid_568630, JString, required = true,
                                 default = nil)
  if valid_568630 != nil:
    section.add "resourceGroupName", valid_568630
  var valid_568631 = path.getOrDefault("peeringName")
  valid_568631 = validateParameter(valid_568631, JString, required = true,
                                 default = nil)
  if valid_568631 != nil:
    section.add "peeringName", valid_568631
  var valid_568632 = path.getOrDefault("subscriptionId")
  valid_568632 = validateParameter(valid_568632, JString, required = true,
                                 default = nil)
  if valid_568632 != nil:
    section.add "subscriptionId", valid_568632
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568633 = query.getOrDefault("api-version")
  valid_568633 = validateParameter(valid_568633, JString, required = true,
                                 default = nil)
  if valid_568633 != nil:
    section.add "api-version", valid_568633
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568634: Call_ExpressRouteCircuitsGetPeeringStats_568626;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The GetPeeringStats ExpressRouteCircuit operation retrieves all the stats from a ExpressRouteCircuits in a resource group.
  ## 
  let valid = call_568634.validator(path, query, header, formData, body)
  let scheme = call_568634.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568634.url(scheme.get, call_568634.host, call_568634.base,
                         call_568634.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568634, url, valid)

proc call*(call_568635: Call_ExpressRouteCircuitsGetPeeringStats_568626;
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
  var path_568636 = newJObject()
  var query_568637 = newJObject()
  add(path_568636, "circuitName", newJString(circuitName))
  add(path_568636, "resourceGroupName", newJString(resourceGroupName))
  add(query_568637, "api-version", newJString(apiVersion))
  add(path_568636, "peeringName", newJString(peeringName))
  add(path_568636, "subscriptionId", newJString(subscriptionId))
  result = call_568635.call(path_568636, query_568637, nil, nil, nil)

var expressRouteCircuitsGetPeeringStats* = Call_ExpressRouteCircuitsGetPeeringStats_568626(
    name: "expressRouteCircuitsGetPeeringStats", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/stats",
    validator: validate_ExpressRouteCircuitsGetPeeringStats_568627, base: "",
    url: url_ExpressRouteCircuitsGetPeeringStats_568628, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsGetStats_568638 = ref object of OpenApiRestCall_567651
proc url_ExpressRouteCircuitsGetStats_568640(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsGetStats_568639(path: JsonNode; query: JsonNode;
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
  var valid_568641 = path.getOrDefault("circuitName")
  valid_568641 = validateParameter(valid_568641, JString, required = true,
                                 default = nil)
  if valid_568641 != nil:
    section.add "circuitName", valid_568641
  var valid_568642 = path.getOrDefault("resourceGroupName")
  valid_568642 = validateParameter(valid_568642, JString, required = true,
                                 default = nil)
  if valid_568642 != nil:
    section.add "resourceGroupName", valid_568642
  var valid_568643 = path.getOrDefault("subscriptionId")
  valid_568643 = validateParameter(valid_568643, JString, required = true,
                                 default = nil)
  if valid_568643 != nil:
    section.add "subscriptionId", valid_568643
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568644 = query.getOrDefault("api-version")
  valid_568644 = validateParameter(valid_568644, JString, required = true,
                                 default = nil)
  if valid_568644 != nil:
    section.add "api-version", valid_568644
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568645: Call_ExpressRouteCircuitsGetStats_568638; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetStats ExpressRouteCircuit operation retrieves all the stats from a ExpressRouteCircuits in a resource group.
  ## 
  let valid = call_568645.validator(path, query, header, formData, body)
  let scheme = call_568645.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568645.url(scheme.get, call_568645.host, call_568645.base,
                         call_568645.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568645, url, valid)

proc call*(call_568646: Call_ExpressRouteCircuitsGetStats_568638;
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
  var path_568647 = newJObject()
  var query_568648 = newJObject()
  add(path_568647, "circuitName", newJString(circuitName))
  add(path_568647, "resourceGroupName", newJString(resourceGroupName))
  add(query_568648, "api-version", newJString(apiVersion))
  add(path_568647, "subscriptionId", newJString(subscriptionId))
  result = call_568646.call(path_568647, query_568648, nil, nil, nil)

var expressRouteCircuitsGetStats* = Call_ExpressRouteCircuitsGetStats_568638(
    name: "expressRouteCircuitsGetStats", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/stats",
    validator: validate_ExpressRouteCircuitsGetStats_568639, base: "",
    url: url_ExpressRouteCircuitsGetStats_568640, schemes: {Scheme.Https})
type
  Call_LoadBalancersList_568649 = ref object of OpenApiRestCall_567651
proc url_LoadBalancersList_568651(protocol: Scheme; host: string; base: string;
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

proc validate_LoadBalancersList_568650(path: JsonNode; query: JsonNode;
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
  var valid_568652 = path.getOrDefault("resourceGroupName")
  valid_568652 = validateParameter(valid_568652, JString, required = true,
                                 default = nil)
  if valid_568652 != nil:
    section.add "resourceGroupName", valid_568652
  var valid_568653 = path.getOrDefault("subscriptionId")
  valid_568653 = validateParameter(valid_568653, JString, required = true,
                                 default = nil)
  if valid_568653 != nil:
    section.add "subscriptionId", valid_568653
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568654 = query.getOrDefault("api-version")
  valid_568654 = validateParameter(valid_568654, JString, required = true,
                                 default = nil)
  if valid_568654 != nil:
    section.add "api-version", valid_568654
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568655: Call_LoadBalancersList_568649; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List loadBalancer operation retrieves all the load balancers in a resource group.
  ## 
  let valid = call_568655.validator(path, query, header, formData, body)
  let scheme = call_568655.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568655.url(scheme.get, call_568655.host, call_568655.base,
                         call_568655.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568655, url, valid)

proc call*(call_568656: Call_LoadBalancersList_568649; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## loadBalancersList
  ## The List loadBalancer operation retrieves all the load balancers in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568657 = newJObject()
  var query_568658 = newJObject()
  add(path_568657, "resourceGroupName", newJString(resourceGroupName))
  add(query_568658, "api-version", newJString(apiVersion))
  add(path_568657, "subscriptionId", newJString(subscriptionId))
  result = call_568656.call(path_568657, query_568658, nil, nil, nil)

var loadBalancersList* = Call_LoadBalancersList_568649(name: "loadBalancersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers",
    validator: validate_LoadBalancersList_568650, base: "",
    url: url_LoadBalancersList_568651, schemes: {Scheme.Https})
type
  Call_LoadBalancersCreateOrUpdate_568672 = ref object of OpenApiRestCall_567651
proc url_LoadBalancersCreateOrUpdate_568674(protocol: Scheme; host: string;
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

proc validate_LoadBalancersCreateOrUpdate_568673(path: JsonNode; query: JsonNode;
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
  var valid_568675 = path.getOrDefault("resourceGroupName")
  valid_568675 = validateParameter(valid_568675, JString, required = true,
                                 default = nil)
  if valid_568675 != nil:
    section.add "resourceGroupName", valid_568675
  var valid_568676 = path.getOrDefault("loadBalancerName")
  valid_568676 = validateParameter(valid_568676, JString, required = true,
                                 default = nil)
  if valid_568676 != nil:
    section.add "loadBalancerName", valid_568676
  var valid_568677 = path.getOrDefault("subscriptionId")
  valid_568677 = validateParameter(valid_568677, JString, required = true,
                                 default = nil)
  if valid_568677 != nil:
    section.add "subscriptionId", valid_568677
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568678 = query.getOrDefault("api-version")
  valid_568678 = validateParameter(valid_568678, JString, required = true,
                                 default = nil)
  if valid_568678 != nil:
    section.add "api-version", valid_568678
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

proc call*(call_568680: Call_LoadBalancersCreateOrUpdate_568672; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put LoadBalancer operation creates/updates a LoadBalancer
  ## 
  let valid = call_568680.validator(path, query, header, formData, body)
  let scheme = call_568680.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568680.url(scheme.get, call_568680.host, call_568680.base,
                         call_568680.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568680, url, valid)

proc call*(call_568681: Call_LoadBalancersCreateOrUpdate_568672;
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
  var path_568682 = newJObject()
  var query_568683 = newJObject()
  var body_568684 = newJObject()
  add(path_568682, "resourceGroupName", newJString(resourceGroupName))
  add(query_568683, "api-version", newJString(apiVersion))
  add(path_568682, "loadBalancerName", newJString(loadBalancerName))
  add(path_568682, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568684 = parameters
  result = call_568681.call(path_568682, query_568683, nil, nil, body_568684)

var loadBalancersCreateOrUpdate* = Call_LoadBalancersCreateOrUpdate_568672(
    name: "loadBalancersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}",
    validator: validate_LoadBalancersCreateOrUpdate_568673, base: "",
    url: url_LoadBalancersCreateOrUpdate_568674, schemes: {Scheme.Https})
type
  Call_LoadBalancersGet_568659 = ref object of OpenApiRestCall_567651
proc url_LoadBalancersGet_568661(protocol: Scheme; host: string; base: string;
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

proc validate_LoadBalancersGet_568660(path: JsonNode; query: JsonNode;
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
  var valid_568663 = path.getOrDefault("resourceGroupName")
  valid_568663 = validateParameter(valid_568663, JString, required = true,
                                 default = nil)
  if valid_568663 != nil:
    section.add "resourceGroupName", valid_568663
  var valid_568664 = path.getOrDefault("loadBalancerName")
  valid_568664 = validateParameter(valid_568664, JString, required = true,
                                 default = nil)
  if valid_568664 != nil:
    section.add "loadBalancerName", valid_568664
  var valid_568665 = path.getOrDefault("subscriptionId")
  valid_568665 = validateParameter(valid_568665, JString, required = true,
                                 default = nil)
  if valid_568665 != nil:
    section.add "subscriptionId", valid_568665
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568666 = query.getOrDefault("api-version")
  valid_568666 = validateParameter(valid_568666, JString, required = true,
                                 default = nil)
  if valid_568666 != nil:
    section.add "api-version", valid_568666
  var valid_568667 = query.getOrDefault("$expand")
  valid_568667 = validateParameter(valid_568667, JString, required = false,
                                 default = nil)
  if valid_568667 != nil:
    section.add "$expand", valid_568667
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568668: Call_LoadBalancersGet_568659; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get network interface operation retrieves information about the specified network interface.
  ## 
  let valid = call_568668.validator(path, query, header, formData, body)
  let scheme = call_568668.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568668.url(scheme.get, call_568668.host, call_568668.base,
                         call_568668.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568668, url, valid)

proc call*(call_568669: Call_LoadBalancersGet_568659; resourceGroupName: string;
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
  var path_568670 = newJObject()
  var query_568671 = newJObject()
  add(path_568670, "resourceGroupName", newJString(resourceGroupName))
  add(query_568671, "api-version", newJString(apiVersion))
  add(query_568671, "$expand", newJString(Expand))
  add(path_568670, "loadBalancerName", newJString(loadBalancerName))
  add(path_568670, "subscriptionId", newJString(subscriptionId))
  result = call_568669.call(path_568670, query_568671, nil, nil, nil)

var loadBalancersGet* = Call_LoadBalancersGet_568659(name: "loadBalancersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}",
    validator: validate_LoadBalancersGet_568660, base: "",
    url: url_LoadBalancersGet_568661, schemes: {Scheme.Https})
type
  Call_LoadBalancersDelete_568685 = ref object of OpenApiRestCall_567651
proc url_LoadBalancersDelete_568687(protocol: Scheme; host: string; base: string;
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

proc validate_LoadBalancersDelete_568686(path: JsonNode; query: JsonNode;
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
  var valid_568688 = path.getOrDefault("resourceGroupName")
  valid_568688 = validateParameter(valid_568688, JString, required = true,
                                 default = nil)
  if valid_568688 != nil:
    section.add "resourceGroupName", valid_568688
  var valid_568689 = path.getOrDefault("loadBalancerName")
  valid_568689 = validateParameter(valid_568689, JString, required = true,
                                 default = nil)
  if valid_568689 != nil:
    section.add "loadBalancerName", valid_568689
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
  if body != nil:
    result.add "body", body

proc call*(call_568692: Call_LoadBalancersDelete_568685; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete loadbalancer operation deletes the specified loadbalancer.
  ## 
  let valid = call_568692.validator(path, query, header, formData, body)
  let scheme = call_568692.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568692.url(scheme.get, call_568692.host, call_568692.base,
                         call_568692.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568692, url, valid)

proc call*(call_568693: Call_LoadBalancersDelete_568685; resourceGroupName: string;
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
  var path_568694 = newJObject()
  var query_568695 = newJObject()
  add(path_568694, "resourceGroupName", newJString(resourceGroupName))
  add(query_568695, "api-version", newJString(apiVersion))
  add(path_568694, "loadBalancerName", newJString(loadBalancerName))
  add(path_568694, "subscriptionId", newJString(subscriptionId))
  result = call_568693.call(path_568694, query_568695, nil, nil, nil)

var loadBalancersDelete* = Call_LoadBalancersDelete_568685(
    name: "loadBalancersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/{loadBalancerName}",
    validator: validate_LoadBalancersDelete_568686, base: "",
    url: url_LoadBalancersDelete_568687, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysList_568696 = ref object of OpenApiRestCall_567651
proc url_LocalNetworkGatewaysList_568698(protocol: Scheme; host: string;
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

proc validate_LocalNetworkGatewaysList_568697(path: JsonNode; query: JsonNode;
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
  var valid_568699 = path.getOrDefault("resourceGroupName")
  valid_568699 = validateParameter(valid_568699, JString, required = true,
                                 default = nil)
  if valid_568699 != nil:
    section.add "resourceGroupName", valid_568699
  var valid_568700 = path.getOrDefault("subscriptionId")
  valid_568700 = validateParameter(valid_568700, JString, required = true,
                                 default = nil)
  if valid_568700 != nil:
    section.add "subscriptionId", valid_568700
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568701 = query.getOrDefault("api-version")
  valid_568701 = validateParameter(valid_568701, JString, required = true,
                                 default = nil)
  if valid_568701 != nil:
    section.add "api-version", valid_568701
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568702: Call_LocalNetworkGatewaysList_568696; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List LocalNetworkGateways operation retrieves all the local network gateways stored.
  ## 
  let valid = call_568702.validator(path, query, header, formData, body)
  let scheme = call_568702.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568702.url(scheme.get, call_568702.host, call_568702.base,
                         call_568702.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568702, url, valid)

proc call*(call_568703: Call_LocalNetworkGatewaysList_568696;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## localNetworkGatewaysList
  ## The List LocalNetworkGateways operation retrieves all the local network gateways stored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568704 = newJObject()
  var query_568705 = newJObject()
  add(path_568704, "resourceGroupName", newJString(resourceGroupName))
  add(query_568705, "api-version", newJString(apiVersion))
  add(path_568704, "subscriptionId", newJString(subscriptionId))
  result = call_568703.call(path_568704, query_568705, nil, nil, nil)

var localNetworkGatewaysList* = Call_LocalNetworkGatewaysList_568696(
    name: "localNetworkGatewaysList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways",
    validator: validate_LocalNetworkGatewaysList_568697, base: "",
    url: url_LocalNetworkGatewaysList_568698, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysCreateOrUpdate_568717 = ref object of OpenApiRestCall_567651
proc url_LocalNetworkGatewaysCreateOrUpdate_568719(protocol: Scheme; host: string;
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

proc validate_LocalNetworkGatewaysCreateOrUpdate_568718(path: JsonNode;
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
  var valid_568720 = path.getOrDefault("resourceGroupName")
  valid_568720 = validateParameter(valid_568720, JString, required = true,
                                 default = nil)
  if valid_568720 != nil:
    section.add "resourceGroupName", valid_568720
  var valid_568721 = path.getOrDefault("localNetworkGatewayName")
  valid_568721 = validateParameter(valid_568721, JString, required = true,
                                 default = nil)
  if valid_568721 != nil:
    section.add "localNetworkGatewayName", valid_568721
  var valid_568722 = path.getOrDefault("subscriptionId")
  valid_568722 = validateParameter(valid_568722, JString, required = true,
                                 default = nil)
  if valid_568722 != nil:
    section.add "subscriptionId", valid_568722
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568723 = query.getOrDefault("api-version")
  valid_568723 = validateParameter(valid_568723, JString, required = true,
                                 default = nil)
  if valid_568723 != nil:
    section.add "api-version", valid_568723
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

proc call*(call_568725: Call_LocalNetworkGatewaysCreateOrUpdate_568717;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put LocalNetworkGateway operation creates/updates a local network gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_568725.validator(path, query, header, formData, body)
  let scheme = call_568725.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568725.url(scheme.get, call_568725.host, call_568725.base,
                         call_568725.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568725, url, valid)

proc call*(call_568726: Call_LocalNetworkGatewaysCreateOrUpdate_568717;
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
  var path_568727 = newJObject()
  var query_568728 = newJObject()
  var body_568729 = newJObject()
  add(path_568727, "resourceGroupName", newJString(resourceGroupName))
  add(path_568727, "localNetworkGatewayName", newJString(localNetworkGatewayName))
  add(query_568728, "api-version", newJString(apiVersion))
  add(path_568727, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568729 = parameters
  result = call_568726.call(path_568727, query_568728, nil, nil, body_568729)

var localNetworkGatewaysCreateOrUpdate* = Call_LocalNetworkGatewaysCreateOrUpdate_568717(
    name: "localNetworkGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways/{localNetworkGatewayName}",
    validator: validate_LocalNetworkGatewaysCreateOrUpdate_568718, base: "",
    url: url_LocalNetworkGatewaysCreateOrUpdate_568719, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysGet_568706 = ref object of OpenApiRestCall_567651
proc url_LocalNetworkGatewaysGet_568708(protocol: Scheme; host: string; base: string;
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

proc validate_LocalNetworkGatewaysGet_568707(path: JsonNode; query: JsonNode;
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
  var valid_568709 = path.getOrDefault("resourceGroupName")
  valid_568709 = validateParameter(valid_568709, JString, required = true,
                                 default = nil)
  if valid_568709 != nil:
    section.add "resourceGroupName", valid_568709
  var valid_568710 = path.getOrDefault("localNetworkGatewayName")
  valid_568710 = validateParameter(valid_568710, JString, required = true,
                                 default = nil)
  if valid_568710 != nil:
    section.add "localNetworkGatewayName", valid_568710
  var valid_568711 = path.getOrDefault("subscriptionId")
  valid_568711 = validateParameter(valid_568711, JString, required = true,
                                 default = nil)
  if valid_568711 != nil:
    section.add "subscriptionId", valid_568711
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568712 = query.getOrDefault("api-version")
  valid_568712 = validateParameter(valid_568712, JString, required = true,
                                 default = nil)
  if valid_568712 != nil:
    section.add "api-version", valid_568712
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568713: Call_LocalNetworkGatewaysGet_568706; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get LocalNetworkGateway operation retrieves information about the specified local network gateway through Network resource provider.
  ## 
  let valid = call_568713.validator(path, query, header, formData, body)
  let scheme = call_568713.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568713.url(scheme.get, call_568713.host, call_568713.base,
                         call_568713.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568713, url, valid)

proc call*(call_568714: Call_LocalNetworkGatewaysGet_568706;
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
  var path_568715 = newJObject()
  var query_568716 = newJObject()
  add(path_568715, "resourceGroupName", newJString(resourceGroupName))
  add(path_568715, "localNetworkGatewayName", newJString(localNetworkGatewayName))
  add(query_568716, "api-version", newJString(apiVersion))
  add(path_568715, "subscriptionId", newJString(subscriptionId))
  result = call_568714.call(path_568715, query_568716, nil, nil, nil)

var localNetworkGatewaysGet* = Call_LocalNetworkGatewaysGet_568706(
    name: "localNetworkGatewaysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways/{localNetworkGatewayName}",
    validator: validate_LocalNetworkGatewaysGet_568707, base: "",
    url: url_LocalNetworkGatewaysGet_568708, schemes: {Scheme.Https})
type
  Call_LocalNetworkGatewaysDelete_568730 = ref object of OpenApiRestCall_567651
proc url_LocalNetworkGatewaysDelete_568732(protocol: Scheme; host: string;
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

proc validate_LocalNetworkGatewaysDelete_568731(path: JsonNode; query: JsonNode;
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
  var valid_568733 = path.getOrDefault("resourceGroupName")
  valid_568733 = validateParameter(valid_568733, JString, required = true,
                                 default = nil)
  if valid_568733 != nil:
    section.add "resourceGroupName", valid_568733
  var valid_568734 = path.getOrDefault("localNetworkGatewayName")
  valid_568734 = validateParameter(valid_568734, JString, required = true,
                                 default = nil)
  if valid_568734 != nil:
    section.add "localNetworkGatewayName", valid_568734
  var valid_568735 = path.getOrDefault("subscriptionId")
  valid_568735 = validateParameter(valid_568735, JString, required = true,
                                 default = nil)
  if valid_568735 != nil:
    section.add "subscriptionId", valid_568735
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
  if body != nil:
    result.add "body", body

proc call*(call_568737: Call_LocalNetworkGatewaysDelete_568730; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete LocalNetworkGateway operation deletes the specified local network Gateway through Network resource provider.
  ## 
  let valid = call_568737.validator(path, query, header, formData, body)
  let scheme = call_568737.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568737.url(scheme.get, call_568737.host, call_568737.base,
                         call_568737.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568737, url, valid)

proc call*(call_568738: Call_LocalNetworkGatewaysDelete_568730;
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
  var path_568739 = newJObject()
  var query_568740 = newJObject()
  add(path_568739, "resourceGroupName", newJString(resourceGroupName))
  add(path_568739, "localNetworkGatewayName", newJString(localNetworkGatewayName))
  add(query_568740, "api-version", newJString(apiVersion))
  add(path_568739, "subscriptionId", newJString(subscriptionId))
  result = call_568738.call(path_568739, query_568740, nil, nil, nil)

var localNetworkGatewaysDelete* = Call_LocalNetworkGatewaysDelete_568730(
    name: "localNetworkGatewaysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/localNetworkGateways/{localNetworkGatewayName}",
    validator: validate_LocalNetworkGatewaysDelete_568731, base: "",
    url: url_LocalNetworkGatewaysDelete_568732, schemes: {Scheme.Https})
type
  Call_NetworkInterfacesList_568741 = ref object of OpenApiRestCall_567651
proc url_NetworkInterfacesList_568743(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkInterfacesList_568742(path: JsonNode; query: JsonNode;
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
  var valid_568744 = path.getOrDefault("resourceGroupName")
  valid_568744 = validateParameter(valid_568744, JString, required = true,
                                 default = nil)
  if valid_568744 != nil:
    section.add "resourceGroupName", valid_568744
  var valid_568745 = path.getOrDefault("subscriptionId")
  valid_568745 = validateParameter(valid_568745, JString, required = true,
                                 default = nil)
  if valid_568745 != nil:
    section.add "subscriptionId", valid_568745
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568746 = query.getOrDefault("api-version")
  valid_568746 = validateParameter(valid_568746, JString, required = true,
                                 default = nil)
  if valid_568746 != nil:
    section.add "api-version", valid_568746
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568747: Call_NetworkInterfacesList_568741; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List networkInterfaces operation retrieves all the networkInterfaces in a resource group.
  ## 
  let valid = call_568747.validator(path, query, header, formData, body)
  let scheme = call_568747.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568747.url(scheme.get, call_568747.host, call_568747.base,
                         call_568747.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568747, url, valid)

proc call*(call_568748: Call_NetworkInterfacesList_568741;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## networkInterfacesList
  ## The List networkInterfaces operation retrieves all the networkInterfaces in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568749 = newJObject()
  var query_568750 = newJObject()
  add(path_568749, "resourceGroupName", newJString(resourceGroupName))
  add(query_568750, "api-version", newJString(apiVersion))
  add(path_568749, "subscriptionId", newJString(subscriptionId))
  result = call_568748.call(path_568749, query_568750, nil, nil, nil)

var networkInterfacesList* = Call_NetworkInterfacesList_568741(
    name: "networkInterfacesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces",
    validator: validate_NetworkInterfacesList_568742, base: "",
    url: url_NetworkInterfacesList_568743, schemes: {Scheme.Https})
type
  Call_NetworkInterfacesCreateOrUpdate_568763 = ref object of OpenApiRestCall_567651
proc url_NetworkInterfacesCreateOrUpdate_568765(protocol: Scheme; host: string;
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

proc validate_NetworkInterfacesCreateOrUpdate_568764(path: JsonNode;
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
  var valid_568766 = path.getOrDefault("resourceGroupName")
  valid_568766 = validateParameter(valid_568766, JString, required = true,
                                 default = nil)
  if valid_568766 != nil:
    section.add "resourceGroupName", valid_568766
  var valid_568767 = path.getOrDefault("subscriptionId")
  valid_568767 = validateParameter(valid_568767, JString, required = true,
                                 default = nil)
  if valid_568767 != nil:
    section.add "subscriptionId", valid_568767
  var valid_568768 = path.getOrDefault("networkInterfaceName")
  valid_568768 = validateParameter(valid_568768, JString, required = true,
                                 default = nil)
  if valid_568768 != nil:
    section.add "networkInterfaceName", valid_568768
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568769 = query.getOrDefault("api-version")
  valid_568769 = validateParameter(valid_568769, JString, required = true,
                                 default = nil)
  if valid_568769 != nil:
    section.add "api-version", valid_568769
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

proc call*(call_568771: Call_NetworkInterfacesCreateOrUpdate_568763;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put NetworkInterface operation creates/updates a networkInterface
  ## 
  let valid = call_568771.validator(path, query, header, formData, body)
  let scheme = call_568771.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568771.url(scheme.get, call_568771.host, call_568771.base,
                         call_568771.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568771, url, valid)

proc call*(call_568772: Call_NetworkInterfacesCreateOrUpdate_568763;
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
  var path_568773 = newJObject()
  var query_568774 = newJObject()
  var body_568775 = newJObject()
  add(path_568773, "resourceGroupName", newJString(resourceGroupName))
  add(query_568774, "api-version", newJString(apiVersion))
  add(path_568773, "subscriptionId", newJString(subscriptionId))
  add(path_568773, "networkInterfaceName", newJString(networkInterfaceName))
  if parameters != nil:
    body_568775 = parameters
  result = call_568772.call(path_568773, query_568774, nil, nil, body_568775)

var networkInterfacesCreateOrUpdate* = Call_NetworkInterfacesCreateOrUpdate_568763(
    name: "networkInterfacesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/{networkInterfaceName}",
    validator: validate_NetworkInterfacesCreateOrUpdate_568764, base: "",
    url: url_NetworkInterfacesCreateOrUpdate_568765, schemes: {Scheme.Https})
type
  Call_NetworkInterfacesGet_568751 = ref object of OpenApiRestCall_567651
proc url_NetworkInterfacesGet_568753(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkInterfacesGet_568752(path: JsonNode; query: JsonNode;
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
  var valid_568754 = path.getOrDefault("resourceGroupName")
  valid_568754 = validateParameter(valid_568754, JString, required = true,
                                 default = nil)
  if valid_568754 != nil:
    section.add "resourceGroupName", valid_568754
  var valid_568755 = path.getOrDefault("subscriptionId")
  valid_568755 = validateParameter(valid_568755, JString, required = true,
                                 default = nil)
  if valid_568755 != nil:
    section.add "subscriptionId", valid_568755
  var valid_568756 = path.getOrDefault("networkInterfaceName")
  valid_568756 = validateParameter(valid_568756, JString, required = true,
                                 default = nil)
  if valid_568756 != nil:
    section.add "networkInterfaceName", valid_568756
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568757 = query.getOrDefault("api-version")
  valid_568757 = validateParameter(valid_568757, JString, required = true,
                                 default = nil)
  if valid_568757 != nil:
    section.add "api-version", valid_568757
  var valid_568758 = query.getOrDefault("$expand")
  valid_568758 = validateParameter(valid_568758, JString, required = false,
                                 default = nil)
  if valid_568758 != nil:
    section.add "$expand", valid_568758
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568759: Call_NetworkInterfacesGet_568751; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get network interface operation retrieves information about the specified network interface.
  ## 
  let valid = call_568759.validator(path, query, header, formData, body)
  let scheme = call_568759.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568759.url(scheme.get, call_568759.host, call_568759.base,
                         call_568759.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568759, url, valid)

proc call*(call_568760: Call_NetworkInterfacesGet_568751;
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
  var path_568761 = newJObject()
  var query_568762 = newJObject()
  add(path_568761, "resourceGroupName", newJString(resourceGroupName))
  add(query_568762, "api-version", newJString(apiVersion))
  add(query_568762, "$expand", newJString(Expand))
  add(path_568761, "subscriptionId", newJString(subscriptionId))
  add(path_568761, "networkInterfaceName", newJString(networkInterfaceName))
  result = call_568760.call(path_568761, query_568762, nil, nil, nil)

var networkInterfacesGet* = Call_NetworkInterfacesGet_568751(
    name: "networkInterfacesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/{networkInterfaceName}",
    validator: validate_NetworkInterfacesGet_568752, base: "",
    url: url_NetworkInterfacesGet_568753, schemes: {Scheme.Https})
type
  Call_NetworkInterfacesDelete_568776 = ref object of OpenApiRestCall_567651
proc url_NetworkInterfacesDelete_568778(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkInterfacesDelete_568777(path: JsonNode; query: JsonNode;
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
  var valid_568779 = path.getOrDefault("resourceGroupName")
  valid_568779 = validateParameter(valid_568779, JString, required = true,
                                 default = nil)
  if valid_568779 != nil:
    section.add "resourceGroupName", valid_568779
  var valid_568780 = path.getOrDefault("subscriptionId")
  valid_568780 = validateParameter(valid_568780, JString, required = true,
                                 default = nil)
  if valid_568780 != nil:
    section.add "subscriptionId", valid_568780
  var valid_568781 = path.getOrDefault("networkInterfaceName")
  valid_568781 = validateParameter(valid_568781, JString, required = true,
                                 default = nil)
  if valid_568781 != nil:
    section.add "networkInterfaceName", valid_568781
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568782 = query.getOrDefault("api-version")
  valid_568782 = validateParameter(valid_568782, JString, required = true,
                                 default = nil)
  if valid_568782 != nil:
    section.add "api-version", valid_568782
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568783: Call_NetworkInterfacesDelete_568776; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete networkInterface operation deletes the specified networkInterface.
  ## 
  let valid = call_568783.validator(path, query, header, formData, body)
  let scheme = call_568783.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568783.url(scheme.get, call_568783.host, call_568783.base,
                         call_568783.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568783, url, valid)

proc call*(call_568784: Call_NetworkInterfacesDelete_568776;
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
  var path_568785 = newJObject()
  var query_568786 = newJObject()
  add(path_568785, "resourceGroupName", newJString(resourceGroupName))
  add(query_568786, "api-version", newJString(apiVersion))
  add(path_568785, "subscriptionId", newJString(subscriptionId))
  add(path_568785, "networkInterfaceName", newJString(networkInterfaceName))
  result = call_568784.call(path_568785, query_568786, nil, nil, nil)

var networkInterfacesDelete* = Call_NetworkInterfacesDelete_568776(
    name: "networkInterfacesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/{networkInterfaceName}",
    validator: validate_NetworkInterfacesDelete_568777, base: "",
    url: url_NetworkInterfacesDelete_568778, schemes: {Scheme.Https})
type
  Call_NetworkSecurityGroupsList_568787 = ref object of OpenApiRestCall_567651
proc url_NetworkSecurityGroupsList_568789(protocol: Scheme; host: string;
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

proc validate_NetworkSecurityGroupsList_568788(path: JsonNode; query: JsonNode;
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
  var valid_568790 = path.getOrDefault("resourceGroupName")
  valid_568790 = validateParameter(valid_568790, JString, required = true,
                                 default = nil)
  if valid_568790 != nil:
    section.add "resourceGroupName", valid_568790
  var valid_568791 = path.getOrDefault("subscriptionId")
  valid_568791 = validateParameter(valid_568791, JString, required = true,
                                 default = nil)
  if valid_568791 != nil:
    section.add "subscriptionId", valid_568791
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568792 = query.getOrDefault("api-version")
  valid_568792 = validateParameter(valid_568792, JString, required = true,
                                 default = nil)
  if valid_568792 != nil:
    section.add "api-version", valid_568792
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568793: Call_NetworkSecurityGroupsList_568787; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list NetworkSecurityGroups returns all network security groups in a resource group
  ## 
  let valid = call_568793.validator(path, query, header, formData, body)
  let scheme = call_568793.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568793.url(scheme.get, call_568793.host, call_568793.base,
                         call_568793.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568793, url, valid)

proc call*(call_568794: Call_NetworkSecurityGroupsList_568787;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## networkSecurityGroupsList
  ## The list NetworkSecurityGroups returns all network security groups in a resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568795 = newJObject()
  var query_568796 = newJObject()
  add(path_568795, "resourceGroupName", newJString(resourceGroupName))
  add(query_568796, "api-version", newJString(apiVersion))
  add(path_568795, "subscriptionId", newJString(subscriptionId))
  result = call_568794.call(path_568795, query_568796, nil, nil, nil)

var networkSecurityGroupsList* = Call_NetworkSecurityGroupsList_568787(
    name: "networkSecurityGroupsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups",
    validator: validate_NetworkSecurityGroupsList_568788, base: "",
    url: url_NetworkSecurityGroupsList_568789, schemes: {Scheme.Https})
type
  Call_NetworkSecurityGroupsCreateOrUpdate_568809 = ref object of OpenApiRestCall_567651
proc url_NetworkSecurityGroupsCreateOrUpdate_568811(protocol: Scheme; host: string;
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

proc validate_NetworkSecurityGroupsCreateOrUpdate_568810(path: JsonNode;
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
  var valid_568812 = path.getOrDefault("resourceGroupName")
  valid_568812 = validateParameter(valid_568812, JString, required = true,
                                 default = nil)
  if valid_568812 != nil:
    section.add "resourceGroupName", valid_568812
  var valid_568813 = path.getOrDefault("subscriptionId")
  valid_568813 = validateParameter(valid_568813, JString, required = true,
                                 default = nil)
  if valid_568813 != nil:
    section.add "subscriptionId", valid_568813
  var valid_568814 = path.getOrDefault("networkSecurityGroupName")
  valid_568814 = validateParameter(valid_568814, JString, required = true,
                                 default = nil)
  if valid_568814 != nil:
    section.add "networkSecurityGroupName", valid_568814
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568815 = query.getOrDefault("api-version")
  valid_568815 = validateParameter(valid_568815, JString, required = true,
                                 default = nil)
  if valid_568815 != nil:
    section.add "api-version", valid_568815
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

proc call*(call_568817: Call_NetworkSecurityGroupsCreateOrUpdate_568809;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put NetworkSecurityGroup operation creates/updates a network security group in the specified resource group.
  ## 
  let valid = call_568817.validator(path, query, header, formData, body)
  let scheme = call_568817.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568817.url(scheme.get, call_568817.host, call_568817.base,
                         call_568817.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568817, url, valid)

proc call*(call_568818: Call_NetworkSecurityGroupsCreateOrUpdate_568809;
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
  var path_568819 = newJObject()
  var query_568820 = newJObject()
  var body_568821 = newJObject()
  add(path_568819, "resourceGroupName", newJString(resourceGroupName))
  add(query_568820, "api-version", newJString(apiVersion))
  add(path_568819, "subscriptionId", newJString(subscriptionId))
  add(path_568819, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  if parameters != nil:
    body_568821 = parameters
  result = call_568818.call(path_568819, query_568820, nil, nil, body_568821)

var networkSecurityGroupsCreateOrUpdate* = Call_NetworkSecurityGroupsCreateOrUpdate_568809(
    name: "networkSecurityGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}",
    validator: validate_NetworkSecurityGroupsCreateOrUpdate_568810, base: "",
    url: url_NetworkSecurityGroupsCreateOrUpdate_568811, schemes: {Scheme.Https})
type
  Call_NetworkSecurityGroupsGet_568797 = ref object of OpenApiRestCall_567651
proc url_NetworkSecurityGroupsGet_568799(protocol: Scheme; host: string;
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

proc validate_NetworkSecurityGroupsGet_568798(path: JsonNode; query: JsonNode;
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
  var valid_568800 = path.getOrDefault("resourceGroupName")
  valid_568800 = validateParameter(valid_568800, JString, required = true,
                                 default = nil)
  if valid_568800 != nil:
    section.add "resourceGroupName", valid_568800
  var valid_568801 = path.getOrDefault("subscriptionId")
  valid_568801 = validateParameter(valid_568801, JString, required = true,
                                 default = nil)
  if valid_568801 != nil:
    section.add "subscriptionId", valid_568801
  var valid_568802 = path.getOrDefault("networkSecurityGroupName")
  valid_568802 = validateParameter(valid_568802, JString, required = true,
                                 default = nil)
  if valid_568802 != nil:
    section.add "networkSecurityGroupName", valid_568802
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568803 = query.getOrDefault("api-version")
  valid_568803 = validateParameter(valid_568803, JString, required = true,
                                 default = nil)
  if valid_568803 != nil:
    section.add "api-version", valid_568803
  var valid_568804 = query.getOrDefault("$expand")
  valid_568804 = validateParameter(valid_568804, JString, required = false,
                                 default = nil)
  if valid_568804 != nil:
    section.add "$expand", valid_568804
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568805: Call_NetworkSecurityGroupsGet_568797; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get NetworkSecurityGroups operation retrieves information about the specified network security group.
  ## 
  let valid = call_568805.validator(path, query, header, formData, body)
  let scheme = call_568805.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568805.url(scheme.get, call_568805.host, call_568805.base,
                         call_568805.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568805, url, valid)

proc call*(call_568806: Call_NetworkSecurityGroupsGet_568797;
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
  var path_568807 = newJObject()
  var query_568808 = newJObject()
  add(path_568807, "resourceGroupName", newJString(resourceGroupName))
  add(query_568808, "api-version", newJString(apiVersion))
  add(query_568808, "$expand", newJString(Expand))
  add(path_568807, "subscriptionId", newJString(subscriptionId))
  add(path_568807, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  result = call_568806.call(path_568807, query_568808, nil, nil, nil)

var networkSecurityGroupsGet* = Call_NetworkSecurityGroupsGet_568797(
    name: "networkSecurityGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}",
    validator: validate_NetworkSecurityGroupsGet_568798, base: "",
    url: url_NetworkSecurityGroupsGet_568799, schemes: {Scheme.Https})
type
  Call_NetworkSecurityGroupsDelete_568822 = ref object of OpenApiRestCall_567651
proc url_NetworkSecurityGroupsDelete_568824(protocol: Scheme; host: string;
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

proc validate_NetworkSecurityGroupsDelete_568823(path: JsonNode; query: JsonNode;
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568828 = query.getOrDefault("api-version")
  valid_568828 = validateParameter(valid_568828, JString, required = true,
                                 default = nil)
  if valid_568828 != nil:
    section.add "api-version", valid_568828
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568829: Call_NetworkSecurityGroupsDelete_568822; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete NetworkSecurityGroup operation deletes the specified network security group
  ## 
  let valid = call_568829.validator(path, query, header, formData, body)
  let scheme = call_568829.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568829.url(scheme.get, call_568829.host, call_568829.base,
                         call_568829.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568829, url, valid)

proc call*(call_568830: Call_NetworkSecurityGroupsDelete_568822;
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
  var path_568831 = newJObject()
  var query_568832 = newJObject()
  add(path_568831, "resourceGroupName", newJString(resourceGroupName))
  add(query_568832, "api-version", newJString(apiVersion))
  add(path_568831, "subscriptionId", newJString(subscriptionId))
  add(path_568831, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  result = call_568830.call(path_568831, query_568832, nil, nil, nil)

var networkSecurityGroupsDelete* = Call_NetworkSecurityGroupsDelete_568822(
    name: "networkSecurityGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}",
    validator: validate_NetworkSecurityGroupsDelete_568823, base: "",
    url: url_NetworkSecurityGroupsDelete_568824, schemes: {Scheme.Https})
type
  Call_SecurityRulesList_568833 = ref object of OpenApiRestCall_567651
proc url_SecurityRulesList_568835(protocol: Scheme; host: string; base: string;
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

proc validate_SecurityRulesList_568834(path: JsonNode; query: JsonNode;
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
  var valid_568836 = path.getOrDefault("resourceGroupName")
  valid_568836 = validateParameter(valid_568836, JString, required = true,
                                 default = nil)
  if valid_568836 != nil:
    section.add "resourceGroupName", valid_568836
  var valid_568837 = path.getOrDefault("subscriptionId")
  valid_568837 = validateParameter(valid_568837, JString, required = true,
                                 default = nil)
  if valid_568837 != nil:
    section.add "subscriptionId", valid_568837
  var valid_568838 = path.getOrDefault("networkSecurityGroupName")
  valid_568838 = validateParameter(valid_568838, JString, required = true,
                                 default = nil)
  if valid_568838 != nil:
    section.add "networkSecurityGroupName", valid_568838
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568839 = query.getOrDefault("api-version")
  valid_568839 = validateParameter(valid_568839, JString, required = true,
                                 default = nil)
  if valid_568839 != nil:
    section.add "api-version", valid_568839
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568840: Call_SecurityRulesList_568833; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List network security rule operation retrieves all the security rules in a network security group.
  ## 
  let valid = call_568840.validator(path, query, header, formData, body)
  let scheme = call_568840.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568840.url(scheme.get, call_568840.host, call_568840.base,
                         call_568840.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568840, url, valid)

proc call*(call_568841: Call_SecurityRulesList_568833; resourceGroupName: string;
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
  var path_568842 = newJObject()
  var query_568843 = newJObject()
  add(path_568842, "resourceGroupName", newJString(resourceGroupName))
  add(query_568843, "api-version", newJString(apiVersion))
  add(path_568842, "subscriptionId", newJString(subscriptionId))
  add(path_568842, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  result = call_568841.call(path_568842, query_568843, nil, nil, nil)

var securityRulesList* = Call_SecurityRulesList_568833(name: "securityRulesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}/securityRules",
    validator: validate_SecurityRulesList_568834, base: "",
    url: url_SecurityRulesList_568835, schemes: {Scheme.Https})
type
  Call_SecurityRulesCreateOrUpdate_568856 = ref object of OpenApiRestCall_567651
proc url_SecurityRulesCreateOrUpdate_568858(protocol: Scheme; host: string;
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

proc validate_SecurityRulesCreateOrUpdate_568857(path: JsonNode; query: JsonNode;
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
  var valid_568859 = path.getOrDefault("resourceGroupName")
  valid_568859 = validateParameter(valid_568859, JString, required = true,
                                 default = nil)
  if valid_568859 != nil:
    section.add "resourceGroupName", valid_568859
  var valid_568860 = path.getOrDefault("subscriptionId")
  valid_568860 = validateParameter(valid_568860, JString, required = true,
                                 default = nil)
  if valid_568860 != nil:
    section.add "subscriptionId", valid_568860
  var valid_568861 = path.getOrDefault("networkSecurityGroupName")
  valid_568861 = validateParameter(valid_568861, JString, required = true,
                                 default = nil)
  if valid_568861 != nil:
    section.add "networkSecurityGroupName", valid_568861
  var valid_568862 = path.getOrDefault("securityRuleName")
  valid_568862 = validateParameter(valid_568862, JString, required = true,
                                 default = nil)
  if valid_568862 != nil:
    section.add "securityRuleName", valid_568862
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568863 = query.getOrDefault("api-version")
  valid_568863 = validateParameter(valid_568863, JString, required = true,
                                 default = nil)
  if valid_568863 != nil:
    section.add "api-version", valid_568863
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

proc call*(call_568865: Call_SecurityRulesCreateOrUpdate_568856; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put network security rule operation creates/updates a security rule in the specified network security group
  ## 
  let valid = call_568865.validator(path, query, header, formData, body)
  let scheme = call_568865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568865.url(scheme.get, call_568865.host, call_568865.base,
                         call_568865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568865, url, valid)

proc call*(call_568866: Call_SecurityRulesCreateOrUpdate_568856;
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
  var path_568867 = newJObject()
  var query_568868 = newJObject()
  var body_568869 = newJObject()
  add(path_568867, "resourceGroupName", newJString(resourceGroupName))
  add(query_568868, "api-version", newJString(apiVersion))
  add(path_568867, "subscriptionId", newJString(subscriptionId))
  add(path_568867, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  add(path_568867, "securityRuleName", newJString(securityRuleName))
  if securityRuleParameters != nil:
    body_568869 = securityRuleParameters
  result = call_568866.call(path_568867, query_568868, nil, nil, body_568869)

var securityRulesCreateOrUpdate* = Call_SecurityRulesCreateOrUpdate_568856(
    name: "securityRulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}/securityRules/{securityRuleName}",
    validator: validate_SecurityRulesCreateOrUpdate_568857, base: "",
    url: url_SecurityRulesCreateOrUpdate_568858, schemes: {Scheme.Https})
type
  Call_SecurityRulesGet_568844 = ref object of OpenApiRestCall_567651
proc url_SecurityRulesGet_568846(protocol: Scheme; host: string; base: string;
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

proc validate_SecurityRulesGet_568845(path: JsonNode; query: JsonNode;
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
  var valid_568847 = path.getOrDefault("resourceGroupName")
  valid_568847 = validateParameter(valid_568847, JString, required = true,
                                 default = nil)
  if valid_568847 != nil:
    section.add "resourceGroupName", valid_568847
  var valid_568848 = path.getOrDefault("subscriptionId")
  valid_568848 = validateParameter(valid_568848, JString, required = true,
                                 default = nil)
  if valid_568848 != nil:
    section.add "subscriptionId", valid_568848
  var valid_568849 = path.getOrDefault("networkSecurityGroupName")
  valid_568849 = validateParameter(valid_568849, JString, required = true,
                                 default = nil)
  if valid_568849 != nil:
    section.add "networkSecurityGroupName", valid_568849
  var valid_568850 = path.getOrDefault("securityRuleName")
  valid_568850 = validateParameter(valid_568850, JString, required = true,
                                 default = nil)
  if valid_568850 != nil:
    section.add "securityRuleName", valid_568850
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568851 = query.getOrDefault("api-version")
  valid_568851 = validateParameter(valid_568851, JString, required = true,
                                 default = nil)
  if valid_568851 != nil:
    section.add "api-version", valid_568851
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568852: Call_SecurityRulesGet_568844; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get NetworkSecurityRule operation retrieves information about the specified network security rule.
  ## 
  let valid = call_568852.validator(path, query, header, formData, body)
  let scheme = call_568852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568852.url(scheme.get, call_568852.host, call_568852.base,
                         call_568852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568852, url, valid)

proc call*(call_568853: Call_SecurityRulesGet_568844; resourceGroupName: string;
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
  var path_568854 = newJObject()
  var query_568855 = newJObject()
  add(path_568854, "resourceGroupName", newJString(resourceGroupName))
  add(query_568855, "api-version", newJString(apiVersion))
  add(path_568854, "subscriptionId", newJString(subscriptionId))
  add(path_568854, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  add(path_568854, "securityRuleName", newJString(securityRuleName))
  result = call_568853.call(path_568854, query_568855, nil, nil, nil)

var securityRulesGet* = Call_SecurityRulesGet_568844(name: "securityRulesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}/securityRules/{securityRuleName}",
    validator: validate_SecurityRulesGet_568845, base: "",
    url: url_SecurityRulesGet_568846, schemes: {Scheme.Https})
type
  Call_SecurityRulesDelete_568870 = ref object of OpenApiRestCall_567651
proc url_SecurityRulesDelete_568872(protocol: Scheme; host: string; base: string;
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

proc validate_SecurityRulesDelete_568871(path: JsonNode; query: JsonNode;
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
  var valid_568873 = path.getOrDefault("resourceGroupName")
  valid_568873 = validateParameter(valid_568873, JString, required = true,
                                 default = nil)
  if valid_568873 != nil:
    section.add "resourceGroupName", valid_568873
  var valid_568874 = path.getOrDefault("subscriptionId")
  valid_568874 = validateParameter(valid_568874, JString, required = true,
                                 default = nil)
  if valid_568874 != nil:
    section.add "subscriptionId", valid_568874
  var valid_568875 = path.getOrDefault("networkSecurityGroupName")
  valid_568875 = validateParameter(valid_568875, JString, required = true,
                                 default = nil)
  if valid_568875 != nil:
    section.add "networkSecurityGroupName", valid_568875
  var valid_568876 = path.getOrDefault("securityRuleName")
  valid_568876 = validateParameter(valid_568876, JString, required = true,
                                 default = nil)
  if valid_568876 != nil:
    section.add "securityRuleName", valid_568876
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568877 = query.getOrDefault("api-version")
  valid_568877 = validateParameter(valid_568877, JString, required = true,
                                 default = nil)
  if valid_568877 != nil:
    section.add "api-version", valid_568877
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568878: Call_SecurityRulesDelete_568870; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete network security rule operation deletes the specified network security rule.
  ## 
  let valid = call_568878.validator(path, query, header, formData, body)
  let scheme = call_568878.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568878.url(scheme.get, call_568878.host, call_568878.base,
                         call_568878.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568878, url, valid)

proc call*(call_568879: Call_SecurityRulesDelete_568870; resourceGroupName: string;
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
  var path_568880 = newJObject()
  var query_568881 = newJObject()
  add(path_568880, "resourceGroupName", newJString(resourceGroupName))
  add(query_568881, "api-version", newJString(apiVersion))
  add(path_568880, "subscriptionId", newJString(subscriptionId))
  add(path_568880, "networkSecurityGroupName",
      newJString(networkSecurityGroupName))
  add(path_568880, "securityRuleName", newJString(securityRuleName))
  result = call_568879.call(path_568880, query_568881, nil, nil, nil)

var securityRulesDelete* = Call_SecurityRulesDelete_568870(
    name: "securityRulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{networkSecurityGroupName}/securityRules/{securityRuleName}",
    validator: validate_SecurityRulesDelete_568871, base: "",
    url: url_SecurityRulesDelete_568872, schemes: {Scheme.Https})
type
  Call_PublicIPAddressesList_568882 = ref object of OpenApiRestCall_567651
proc url_PublicIPAddressesList_568884(protocol: Scheme; host: string; base: string;
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

proc validate_PublicIPAddressesList_568883(path: JsonNode; query: JsonNode;
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
  var valid_568885 = path.getOrDefault("resourceGroupName")
  valid_568885 = validateParameter(valid_568885, JString, required = true,
                                 default = nil)
  if valid_568885 != nil:
    section.add "resourceGroupName", valid_568885
  var valid_568886 = path.getOrDefault("subscriptionId")
  valid_568886 = validateParameter(valid_568886, JString, required = true,
                                 default = nil)
  if valid_568886 != nil:
    section.add "subscriptionId", valid_568886
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568887 = query.getOrDefault("api-version")
  valid_568887 = validateParameter(valid_568887, JString, required = true,
                                 default = nil)
  if valid_568887 != nil:
    section.add "api-version", valid_568887
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568888: Call_PublicIPAddressesList_568882; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List publicIpAddress operation retrieves all the publicIpAddresses in a resource group.
  ## 
  let valid = call_568888.validator(path, query, header, formData, body)
  let scheme = call_568888.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568888.url(scheme.get, call_568888.host, call_568888.base,
                         call_568888.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568888, url, valid)

proc call*(call_568889: Call_PublicIPAddressesList_568882;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## publicIPAddressesList
  ## The List publicIpAddress operation retrieves all the publicIpAddresses in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568890 = newJObject()
  var query_568891 = newJObject()
  add(path_568890, "resourceGroupName", newJString(resourceGroupName))
  add(query_568891, "api-version", newJString(apiVersion))
  add(path_568890, "subscriptionId", newJString(subscriptionId))
  result = call_568889.call(path_568890, query_568891, nil, nil, nil)

var publicIPAddressesList* = Call_PublicIPAddressesList_568882(
    name: "publicIPAddressesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses",
    validator: validate_PublicIPAddressesList_568883, base: "",
    url: url_PublicIPAddressesList_568884, schemes: {Scheme.Https})
type
  Call_PublicIPAddressesCreateOrUpdate_568904 = ref object of OpenApiRestCall_567651
proc url_PublicIPAddressesCreateOrUpdate_568906(protocol: Scheme; host: string;
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

proc validate_PublicIPAddressesCreateOrUpdate_568905(path: JsonNode;
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
  var valid_568907 = path.getOrDefault("resourceGroupName")
  valid_568907 = validateParameter(valid_568907, JString, required = true,
                                 default = nil)
  if valid_568907 != nil:
    section.add "resourceGroupName", valid_568907
  var valid_568908 = path.getOrDefault("publicIpAddressName")
  valid_568908 = validateParameter(valid_568908, JString, required = true,
                                 default = nil)
  if valid_568908 != nil:
    section.add "publicIpAddressName", valid_568908
  var valid_568909 = path.getOrDefault("subscriptionId")
  valid_568909 = validateParameter(valid_568909, JString, required = true,
                                 default = nil)
  if valid_568909 != nil:
    section.add "subscriptionId", valid_568909
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568910 = query.getOrDefault("api-version")
  valid_568910 = validateParameter(valid_568910, JString, required = true,
                                 default = nil)
  if valid_568910 != nil:
    section.add "api-version", valid_568910
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

proc call*(call_568912: Call_PublicIPAddressesCreateOrUpdate_568904;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put PublicIPAddress operation creates/updates a stable/dynamic PublicIP address
  ## 
  let valid = call_568912.validator(path, query, header, formData, body)
  let scheme = call_568912.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568912.url(scheme.get, call_568912.host, call_568912.base,
                         call_568912.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568912, url, valid)

proc call*(call_568913: Call_PublicIPAddressesCreateOrUpdate_568904;
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
  var path_568914 = newJObject()
  var query_568915 = newJObject()
  var body_568916 = newJObject()
  add(path_568914, "resourceGroupName", newJString(resourceGroupName))
  add(query_568915, "api-version", newJString(apiVersion))
  add(path_568914, "publicIpAddressName", newJString(publicIpAddressName))
  add(path_568914, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568916 = parameters
  result = call_568913.call(path_568914, query_568915, nil, nil, body_568916)

var publicIPAddressesCreateOrUpdate* = Call_PublicIPAddressesCreateOrUpdate_568904(
    name: "publicIPAddressesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses/{publicIpAddressName}",
    validator: validate_PublicIPAddressesCreateOrUpdate_568905, base: "",
    url: url_PublicIPAddressesCreateOrUpdate_568906, schemes: {Scheme.Https})
type
  Call_PublicIPAddressesGet_568892 = ref object of OpenApiRestCall_567651
proc url_PublicIPAddressesGet_568894(protocol: Scheme; host: string; base: string;
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

proc validate_PublicIPAddressesGet_568893(path: JsonNode; query: JsonNode;
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
  var valid_568895 = path.getOrDefault("resourceGroupName")
  valid_568895 = validateParameter(valid_568895, JString, required = true,
                                 default = nil)
  if valid_568895 != nil:
    section.add "resourceGroupName", valid_568895
  var valid_568896 = path.getOrDefault("publicIpAddressName")
  valid_568896 = validateParameter(valid_568896, JString, required = true,
                                 default = nil)
  if valid_568896 != nil:
    section.add "publicIpAddressName", valid_568896
  var valid_568897 = path.getOrDefault("subscriptionId")
  valid_568897 = validateParameter(valid_568897, JString, required = true,
                                 default = nil)
  if valid_568897 != nil:
    section.add "subscriptionId", valid_568897
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568898 = query.getOrDefault("api-version")
  valid_568898 = validateParameter(valid_568898, JString, required = true,
                                 default = nil)
  if valid_568898 != nil:
    section.add "api-version", valid_568898
  var valid_568899 = query.getOrDefault("$expand")
  valid_568899 = validateParameter(valid_568899, JString, required = false,
                                 default = nil)
  if valid_568899 != nil:
    section.add "$expand", valid_568899
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568900: Call_PublicIPAddressesGet_568892; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get publicIpAddress operation retrieves information about the specified pubicIpAddress
  ## 
  let valid = call_568900.validator(path, query, header, formData, body)
  let scheme = call_568900.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568900.url(scheme.get, call_568900.host, call_568900.base,
                         call_568900.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568900, url, valid)

proc call*(call_568901: Call_PublicIPAddressesGet_568892;
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
  var path_568902 = newJObject()
  var query_568903 = newJObject()
  add(path_568902, "resourceGroupName", newJString(resourceGroupName))
  add(query_568903, "api-version", newJString(apiVersion))
  add(query_568903, "$expand", newJString(Expand))
  add(path_568902, "publicIpAddressName", newJString(publicIpAddressName))
  add(path_568902, "subscriptionId", newJString(subscriptionId))
  result = call_568901.call(path_568902, query_568903, nil, nil, nil)

var publicIPAddressesGet* = Call_PublicIPAddressesGet_568892(
    name: "publicIPAddressesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses/{publicIpAddressName}",
    validator: validate_PublicIPAddressesGet_568893, base: "",
    url: url_PublicIPAddressesGet_568894, schemes: {Scheme.Https})
type
  Call_PublicIPAddressesDelete_568917 = ref object of OpenApiRestCall_567651
proc url_PublicIPAddressesDelete_568919(protocol: Scheme; host: string; base: string;
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

proc validate_PublicIPAddressesDelete_568918(path: JsonNode; query: JsonNode;
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
  var valid_568920 = path.getOrDefault("resourceGroupName")
  valid_568920 = validateParameter(valid_568920, JString, required = true,
                                 default = nil)
  if valid_568920 != nil:
    section.add "resourceGroupName", valid_568920
  var valid_568921 = path.getOrDefault("publicIpAddressName")
  valid_568921 = validateParameter(valid_568921, JString, required = true,
                                 default = nil)
  if valid_568921 != nil:
    section.add "publicIpAddressName", valid_568921
  var valid_568922 = path.getOrDefault("subscriptionId")
  valid_568922 = validateParameter(valid_568922, JString, required = true,
                                 default = nil)
  if valid_568922 != nil:
    section.add "subscriptionId", valid_568922
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568923 = query.getOrDefault("api-version")
  valid_568923 = validateParameter(valid_568923, JString, required = true,
                                 default = nil)
  if valid_568923 != nil:
    section.add "api-version", valid_568923
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568924: Call_PublicIPAddressesDelete_568917; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete publicIpAddress operation deletes the specified publicIpAddress.
  ## 
  let valid = call_568924.validator(path, query, header, formData, body)
  let scheme = call_568924.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568924.url(scheme.get, call_568924.host, call_568924.base,
                         call_568924.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568924, url, valid)

proc call*(call_568925: Call_PublicIPAddressesDelete_568917;
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
  var path_568926 = newJObject()
  var query_568927 = newJObject()
  add(path_568926, "resourceGroupName", newJString(resourceGroupName))
  add(query_568927, "api-version", newJString(apiVersion))
  add(path_568926, "publicIpAddressName", newJString(publicIpAddressName))
  add(path_568926, "subscriptionId", newJString(subscriptionId))
  result = call_568925.call(path_568926, query_568927, nil, nil, nil)

var publicIPAddressesDelete* = Call_PublicIPAddressesDelete_568917(
    name: "publicIPAddressesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses/{publicIpAddressName}",
    validator: validate_PublicIPAddressesDelete_568918, base: "",
    url: url_PublicIPAddressesDelete_568919, schemes: {Scheme.Https})
type
  Call_RouteTablesList_568928 = ref object of OpenApiRestCall_567651
proc url_RouteTablesList_568930(protocol: Scheme; host: string; base: string;
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

proc validate_RouteTablesList_568929(path: JsonNode; query: JsonNode;
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
  var valid_568931 = path.getOrDefault("resourceGroupName")
  valid_568931 = validateParameter(valid_568931, JString, required = true,
                                 default = nil)
  if valid_568931 != nil:
    section.add "resourceGroupName", valid_568931
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

proc call*(call_568934: Call_RouteTablesList_568928; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list RouteTables returns all route tables in a resource group
  ## 
  let valid = call_568934.validator(path, query, header, formData, body)
  let scheme = call_568934.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568934.url(scheme.get, call_568934.host, call_568934.base,
                         call_568934.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568934, url, valid)

proc call*(call_568935: Call_RouteTablesList_568928; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## routeTablesList
  ## The list RouteTables returns all route tables in a resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568936 = newJObject()
  var query_568937 = newJObject()
  add(path_568936, "resourceGroupName", newJString(resourceGroupName))
  add(query_568937, "api-version", newJString(apiVersion))
  add(path_568936, "subscriptionId", newJString(subscriptionId))
  result = call_568935.call(path_568936, query_568937, nil, nil, nil)

var routeTablesList* = Call_RouteTablesList_568928(name: "routeTablesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables",
    validator: validate_RouteTablesList_568929, base: "", url: url_RouteTablesList_568930,
    schemes: {Scheme.Https})
type
  Call_RouteTablesCreateOrUpdate_568950 = ref object of OpenApiRestCall_567651
proc url_RouteTablesCreateOrUpdate_568952(protocol: Scheme; host: string;
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

proc validate_RouteTablesCreateOrUpdate_568951(path: JsonNode; query: JsonNode;
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
  var valid_568953 = path.getOrDefault("resourceGroupName")
  valid_568953 = validateParameter(valid_568953, JString, required = true,
                                 default = nil)
  if valid_568953 != nil:
    section.add "resourceGroupName", valid_568953
  var valid_568954 = path.getOrDefault("routeTableName")
  valid_568954 = validateParameter(valid_568954, JString, required = true,
                                 default = nil)
  if valid_568954 != nil:
    section.add "routeTableName", valid_568954
  var valid_568955 = path.getOrDefault("subscriptionId")
  valid_568955 = validateParameter(valid_568955, JString, required = true,
                                 default = nil)
  if valid_568955 != nil:
    section.add "subscriptionId", valid_568955
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update Route Table operation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568958: Call_RouteTablesCreateOrUpdate_568950; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put RouteTable operation creates/updates a route table in the specified resource group.
  ## 
  let valid = call_568958.validator(path, query, header, formData, body)
  let scheme = call_568958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568958.url(scheme.get, call_568958.host, call_568958.base,
                         call_568958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568958, url, valid)

proc call*(call_568959: Call_RouteTablesCreateOrUpdate_568950;
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
  var path_568960 = newJObject()
  var query_568961 = newJObject()
  var body_568962 = newJObject()
  add(path_568960, "resourceGroupName", newJString(resourceGroupName))
  add(path_568960, "routeTableName", newJString(routeTableName))
  add(query_568961, "api-version", newJString(apiVersion))
  add(path_568960, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568962 = parameters
  result = call_568959.call(path_568960, query_568961, nil, nil, body_568962)

var routeTablesCreateOrUpdate* = Call_RouteTablesCreateOrUpdate_568950(
    name: "routeTablesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}",
    validator: validate_RouteTablesCreateOrUpdate_568951, base: "",
    url: url_RouteTablesCreateOrUpdate_568952, schemes: {Scheme.Https})
type
  Call_RouteTablesGet_568938 = ref object of OpenApiRestCall_567651
proc url_RouteTablesGet_568940(protocol: Scheme; host: string; base: string;
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

proc validate_RouteTablesGet_568939(path: JsonNode; query: JsonNode;
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
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568944 = query.getOrDefault("api-version")
  valid_568944 = validateParameter(valid_568944, JString, required = true,
                                 default = nil)
  if valid_568944 != nil:
    section.add "api-version", valid_568944
  var valid_568945 = query.getOrDefault("$expand")
  valid_568945 = validateParameter(valid_568945, JString, required = false,
                                 default = nil)
  if valid_568945 != nil:
    section.add "$expand", valid_568945
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568946: Call_RouteTablesGet_568938; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get RouteTables operation retrieves information about the specified route table.
  ## 
  let valid = call_568946.validator(path, query, header, formData, body)
  let scheme = call_568946.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568946.url(scheme.get, call_568946.host, call_568946.base,
                         call_568946.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568946, url, valid)

proc call*(call_568947: Call_RouteTablesGet_568938; resourceGroupName: string;
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
  var path_568948 = newJObject()
  var query_568949 = newJObject()
  add(path_568948, "resourceGroupName", newJString(resourceGroupName))
  add(path_568948, "routeTableName", newJString(routeTableName))
  add(query_568949, "api-version", newJString(apiVersion))
  add(query_568949, "$expand", newJString(Expand))
  add(path_568948, "subscriptionId", newJString(subscriptionId))
  result = call_568947.call(path_568948, query_568949, nil, nil, nil)

var routeTablesGet* = Call_RouteTablesGet_568938(name: "routeTablesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}",
    validator: validate_RouteTablesGet_568939, base: "", url: url_RouteTablesGet_568940,
    schemes: {Scheme.Https})
type
  Call_RouteTablesDelete_568963 = ref object of OpenApiRestCall_567651
proc url_RouteTablesDelete_568965(protocol: Scheme; host: string; base: string;
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

proc validate_RouteTablesDelete_568964(path: JsonNode; query: JsonNode;
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
  var valid_568966 = path.getOrDefault("resourceGroupName")
  valid_568966 = validateParameter(valid_568966, JString, required = true,
                                 default = nil)
  if valid_568966 != nil:
    section.add "resourceGroupName", valid_568966
  var valid_568967 = path.getOrDefault("routeTableName")
  valid_568967 = validateParameter(valid_568967, JString, required = true,
                                 default = nil)
  if valid_568967 != nil:
    section.add "routeTableName", valid_568967
  var valid_568968 = path.getOrDefault("subscriptionId")
  valid_568968 = validateParameter(valid_568968, JString, required = true,
                                 default = nil)
  if valid_568968 != nil:
    section.add "subscriptionId", valid_568968
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568969 = query.getOrDefault("api-version")
  valid_568969 = validateParameter(valid_568969, JString, required = true,
                                 default = nil)
  if valid_568969 != nil:
    section.add "api-version", valid_568969
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568970: Call_RouteTablesDelete_568963; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete RouteTable operation deletes the specified Route Table
  ## 
  let valid = call_568970.validator(path, query, header, formData, body)
  let scheme = call_568970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568970.url(scheme.get, call_568970.host, call_568970.base,
                         call_568970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568970, url, valid)

proc call*(call_568971: Call_RouteTablesDelete_568963; resourceGroupName: string;
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
  var path_568972 = newJObject()
  var query_568973 = newJObject()
  add(path_568972, "resourceGroupName", newJString(resourceGroupName))
  add(path_568972, "routeTableName", newJString(routeTableName))
  add(query_568973, "api-version", newJString(apiVersion))
  add(path_568972, "subscriptionId", newJString(subscriptionId))
  result = call_568971.call(path_568972, query_568973, nil, nil, nil)

var routeTablesDelete* = Call_RouteTablesDelete_568963(name: "routeTablesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}",
    validator: validate_RouteTablesDelete_568964, base: "",
    url: url_RouteTablesDelete_568965, schemes: {Scheme.Https})
type
  Call_RoutesList_568974 = ref object of OpenApiRestCall_567651
proc url_RoutesList_568976(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_RoutesList_568975(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568977 = path.getOrDefault("resourceGroupName")
  valid_568977 = validateParameter(valid_568977, JString, required = true,
                                 default = nil)
  if valid_568977 != nil:
    section.add "resourceGroupName", valid_568977
  var valid_568978 = path.getOrDefault("routeTableName")
  valid_568978 = validateParameter(valid_568978, JString, required = true,
                                 default = nil)
  if valid_568978 != nil:
    section.add "routeTableName", valid_568978
  var valid_568979 = path.getOrDefault("subscriptionId")
  valid_568979 = validateParameter(valid_568979, JString, required = true,
                                 default = nil)
  if valid_568979 != nil:
    section.add "subscriptionId", valid_568979
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568980 = query.getOrDefault("api-version")
  valid_568980 = validateParameter(valid_568980, JString, required = true,
                                 default = nil)
  if valid_568980 != nil:
    section.add "api-version", valid_568980
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568981: Call_RoutesList_568974; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List network security rule operation retrieves all the routes in a route table.
  ## 
  let valid = call_568981.validator(path, query, header, formData, body)
  let scheme = call_568981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568981.url(scheme.get, call_568981.host, call_568981.base,
                         call_568981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568981, url, valid)

proc call*(call_568982: Call_RoutesList_568974; resourceGroupName: string;
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
  var path_568983 = newJObject()
  var query_568984 = newJObject()
  add(path_568983, "resourceGroupName", newJString(resourceGroupName))
  add(path_568983, "routeTableName", newJString(routeTableName))
  add(query_568984, "api-version", newJString(apiVersion))
  add(path_568983, "subscriptionId", newJString(subscriptionId))
  result = call_568982.call(path_568983, query_568984, nil, nil, nil)

var routesList* = Call_RoutesList_568974(name: "routesList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}/routes",
                                      validator: validate_RoutesList_568975,
                                      base: "", url: url_RoutesList_568976,
                                      schemes: {Scheme.Https})
type
  Call_RoutesCreateOrUpdate_568997 = ref object of OpenApiRestCall_567651
proc url_RoutesCreateOrUpdate_568999(protocol: Scheme; host: string; base: string;
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

proc validate_RoutesCreateOrUpdate_568998(path: JsonNode; query: JsonNode;
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
  var valid_569000 = path.getOrDefault("resourceGroupName")
  valid_569000 = validateParameter(valid_569000, JString, required = true,
                                 default = nil)
  if valid_569000 != nil:
    section.add "resourceGroupName", valid_569000
  var valid_569001 = path.getOrDefault("routeTableName")
  valid_569001 = validateParameter(valid_569001, JString, required = true,
                                 default = nil)
  if valid_569001 != nil:
    section.add "routeTableName", valid_569001
  var valid_569002 = path.getOrDefault("subscriptionId")
  valid_569002 = validateParameter(valid_569002, JString, required = true,
                                 default = nil)
  if valid_569002 != nil:
    section.add "subscriptionId", valid_569002
  var valid_569003 = path.getOrDefault("routeName")
  valid_569003 = validateParameter(valid_569003, JString, required = true,
                                 default = nil)
  if valid_569003 != nil:
    section.add "routeName", valid_569003
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569004 = query.getOrDefault("api-version")
  valid_569004 = validateParameter(valid_569004, JString, required = true,
                                 default = nil)
  if valid_569004 != nil:
    section.add "api-version", valid_569004
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

proc call*(call_569006: Call_RoutesCreateOrUpdate_568997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put route operation creates/updates a route in the specified route table
  ## 
  let valid = call_569006.validator(path, query, header, formData, body)
  let scheme = call_569006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569006.url(scheme.get, call_569006.host, call_569006.base,
                         call_569006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569006, url, valid)

proc call*(call_569007: Call_RoutesCreateOrUpdate_568997;
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
  var path_569008 = newJObject()
  var query_569009 = newJObject()
  var body_569010 = newJObject()
  add(path_569008, "resourceGroupName", newJString(resourceGroupName))
  add(path_569008, "routeTableName", newJString(routeTableName))
  add(query_569009, "api-version", newJString(apiVersion))
  add(path_569008, "subscriptionId", newJString(subscriptionId))
  add(path_569008, "routeName", newJString(routeName))
  if routeParameters != nil:
    body_569010 = routeParameters
  result = call_569007.call(path_569008, query_569009, nil, nil, body_569010)

var routesCreateOrUpdate* = Call_RoutesCreateOrUpdate_568997(
    name: "routesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}/routes/{routeName}",
    validator: validate_RoutesCreateOrUpdate_568998, base: "",
    url: url_RoutesCreateOrUpdate_568999, schemes: {Scheme.Https})
type
  Call_RoutesGet_568985 = ref object of OpenApiRestCall_567651
proc url_RoutesGet_568987(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_RoutesGet_568986(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568988 = path.getOrDefault("resourceGroupName")
  valid_568988 = validateParameter(valid_568988, JString, required = true,
                                 default = nil)
  if valid_568988 != nil:
    section.add "resourceGroupName", valid_568988
  var valid_568989 = path.getOrDefault("routeTableName")
  valid_568989 = validateParameter(valid_568989, JString, required = true,
                                 default = nil)
  if valid_568989 != nil:
    section.add "routeTableName", valid_568989
  var valid_568990 = path.getOrDefault("subscriptionId")
  valid_568990 = validateParameter(valid_568990, JString, required = true,
                                 default = nil)
  if valid_568990 != nil:
    section.add "subscriptionId", valid_568990
  var valid_568991 = path.getOrDefault("routeName")
  valid_568991 = validateParameter(valid_568991, JString, required = true,
                                 default = nil)
  if valid_568991 != nil:
    section.add "routeName", valid_568991
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

proc call*(call_568993: Call_RoutesGet_568985; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get route operation retrieves information about the specified route from the route table.
  ## 
  let valid = call_568993.validator(path, query, header, formData, body)
  let scheme = call_568993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568993.url(scheme.get, call_568993.host, call_568993.base,
                         call_568993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568993, url, valid)

proc call*(call_568994: Call_RoutesGet_568985; resourceGroupName: string;
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
  var path_568995 = newJObject()
  var query_568996 = newJObject()
  add(path_568995, "resourceGroupName", newJString(resourceGroupName))
  add(path_568995, "routeTableName", newJString(routeTableName))
  add(query_568996, "api-version", newJString(apiVersion))
  add(path_568995, "subscriptionId", newJString(subscriptionId))
  add(path_568995, "routeName", newJString(routeName))
  result = call_568994.call(path_568995, query_568996, nil, nil, nil)

var routesGet* = Call_RoutesGet_568985(name: "routesGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}/routes/{routeName}",
                                    validator: validate_RoutesGet_568986,
                                    base: "", url: url_RoutesGet_568987,
                                    schemes: {Scheme.Https})
type
  Call_RoutesDelete_569011 = ref object of OpenApiRestCall_567651
proc url_RoutesDelete_569013(protocol: Scheme; host: string; base: string;
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

proc validate_RoutesDelete_569012(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_569014 = path.getOrDefault("resourceGroupName")
  valid_569014 = validateParameter(valid_569014, JString, required = true,
                                 default = nil)
  if valid_569014 != nil:
    section.add "resourceGroupName", valid_569014
  var valid_569015 = path.getOrDefault("routeTableName")
  valid_569015 = validateParameter(valid_569015, JString, required = true,
                                 default = nil)
  if valid_569015 != nil:
    section.add "routeTableName", valid_569015
  var valid_569016 = path.getOrDefault("subscriptionId")
  valid_569016 = validateParameter(valid_569016, JString, required = true,
                                 default = nil)
  if valid_569016 != nil:
    section.add "subscriptionId", valid_569016
  var valid_569017 = path.getOrDefault("routeName")
  valid_569017 = validateParameter(valid_569017, JString, required = true,
                                 default = nil)
  if valid_569017 != nil:
    section.add "routeName", valid_569017
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569018 = query.getOrDefault("api-version")
  valid_569018 = validateParameter(valid_569018, JString, required = true,
                                 default = nil)
  if valid_569018 != nil:
    section.add "api-version", valid_569018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569019: Call_RoutesDelete_569011; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete route operation deletes the specified route from a route table.
  ## 
  let valid = call_569019.validator(path, query, header, formData, body)
  let scheme = call_569019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569019.url(scheme.get, call_569019.host, call_569019.base,
                         call_569019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569019, url, valid)

proc call*(call_569020: Call_RoutesDelete_569011; resourceGroupName: string;
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
  var path_569021 = newJObject()
  var query_569022 = newJObject()
  add(path_569021, "resourceGroupName", newJString(resourceGroupName))
  add(path_569021, "routeTableName", newJString(routeTableName))
  add(query_569022, "api-version", newJString(apiVersion))
  add(path_569021, "subscriptionId", newJString(subscriptionId))
  add(path_569021, "routeName", newJString(routeName))
  result = call_569020.call(path_569021, query_569022, nil, nil, nil)

var routesDelete* = Call_RoutesDelete_569011(name: "routesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/{routeTableName}/routes/{routeName}",
    validator: validate_RoutesDelete_569012, base: "", url: url_RoutesDelete_569013,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysList_569023 = ref object of OpenApiRestCall_567651
proc url_VirtualNetworkGatewaysList_569025(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGatewaysList_569024(path: JsonNode; query: JsonNode;
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
  var valid_569026 = path.getOrDefault("resourceGroupName")
  valid_569026 = validateParameter(valid_569026, JString, required = true,
                                 default = nil)
  if valid_569026 != nil:
    section.add "resourceGroupName", valid_569026
  var valid_569027 = path.getOrDefault("subscriptionId")
  valid_569027 = validateParameter(valid_569027, JString, required = true,
                                 default = nil)
  if valid_569027 != nil:
    section.add "subscriptionId", valid_569027
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569028 = query.getOrDefault("api-version")
  valid_569028 = validateParameter(valid_569028, JString, required = true,
                                 default = nil)
  if valid_569028 != nil:
    section.add "api-version", valid_569028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569029: Call_VirtualNetworkGatewaysList_569023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List VirtualNetworkGateways operation retrieves all the virtual network gateways stored.
  ## 
  let valid = call_569029.validator(path, query, header, formData, body)
  let scheme = call_569029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569029.url(scheme.get, call_569029.host, call_569029.base,
                         call_569029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569029, url, valid)

proc call*(call_569030: Call_VirtualNetworkGatewaysList_569023;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualNetworkGatewaysList
  ## The List VirtualNetworkGateways operation retrieves all the virtual network gateways stored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_569031 = newJObject()
  var query_569032 = newJObject()
  add(path_569031, "resourceGroupName", newJString(resourceGroupName))
  add(query_569032, "api-version", newJString(apiVersion))
  add(path_569031, "subscriptionId", newJString(subscriptionId))
  result = call_569030.call(path_569031, query_569032, nil, nil, nil)

var virtualNetworkGatewaysList* = Call_VirtualNetworkGatewaysList_569023(
    name: "virtualNetworkGatewaysList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways",
    validator: validate_VirtualNetworkGatewaysList_569024, base: "",
    url: url_VirtualNetworkGatewaysList_569025, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysCreateOrUpdate_569044 = ref object of OpenApiRestCall_567651
proc url_VirtualNetworkGatewaysCreateOrUpdate_569046(protocol: Scheme;
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

proc validate_VirtualNetworkGatewaysCreateOrUpdate_569045(path: JsonNode;
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
  var valid_569047 = path.getOrDefault("resourceGroupName")
  valid_569047 = validateParameter(valid_569047, JString, required = true,
                                 default = nil)
  if valid_569047 != nil:
    section.add "resourceGroupName", valid_569047
  var valid_569048 = path.getOrDefault("subscriptionId")
  valid_569048 = validateParameter(valid_569048, JString, required = true,
                                 default = nil)
  if valid_569048 != nil:
    section.add "subscriptionId", valid_569048
  var valid_569049 = path.getOrDefault("virtualNetworkGatewayName")
  valid_569049 = validateParameter(valid_569049, JString, required = true,
                                 default = nil)
  if valid_569049 != nil:
    section.add "virtualNetworkGatewayName", valid_569049
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Begin Create or update Virtual Network Gateway operation through Network resource provider.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569052: Call_VirtualNetworkGatewaysCreateOrUpdate_569044;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put VirtualNetworkGateway operation creates/updates a virtual network gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_569052.validator(path, query, header, formData, body)
  let scheme = call_569052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569052.url(scheme.get, call_569052.host, call_569052.base,
                         call_569052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569052, url, valid)

proc call*(call_569053: Call_VirtualNetworkGatewaysCreateOrUpdate_569044;
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
  var path_569054 = newJObject()
  var query_569055 = newJObject()
  var body_569056 = newJObject()
  add(path_569054, "resourceGroupName", newJString(resourceGroupName))
  add(query_569055, "api-version", newJString(apiVersion))
  add(path_569054, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_569056 = parameters
  add(path_569054, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_569053.call(path_569054, query_569055, nil, nil, body_569056)

var virtualNetworkGatewaysCreateOrUpdate* = Call_VirtualNetworkGatewaysCreateOrUpdate_569044(
    name: "virtualNetworkGatewaysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}",
    validator: validate_VirtualNetworkGatewaysCreateOrUpdate_569045, base: "",
    url: url_VirtualNetworkGatewaysCreateOrUpdate_569046, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGet_569033 = ref object of OpenApiRestCall_567651
proc url_VirtualNetworkGatewaysGet_569035(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGatewaysGet_569034(path: JsonNode; query: JsonNode;
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
  var valid_569036 = path.getOrDefault("resourceGroupName")
  valid_569036 = validateParameter(valid_569036, JString, required = true,
                                 default = nil)
  if valid_569036 != nil:
    section.add "resourceGroupName", valid_569036
  var valid_569037 = path.getOrDefault("subscriptionId")
  valid_569037 = validateParameter(valid_569037, JString, required = true,
                                 default = nil)
  if valid_569037 != nil:
    section.add "subscriptionId", valid_569037
  var valid_569038 = path.getOrDefault("virtualNetworkGatewayName")
  valid_569038 = validateParameter(valid_569038, JString, required = true,
                                 default = nil)
  if valid_569038 != nil:
    section.add "virtualNetworkGatewayName", valid_569038
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569039 = query.getOrDefault("api-version")
  valid_569039 = validateParameter(valid_569039, JString, required = true,
                                 default = nil)
  if valid_569039 != nil:
    section.add "api-version", valid_569039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569040: Call_VirtualNetworkGatewaysGet_569033; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get VirtualNetworkGateway operation retrieves information about the specified virtual network gateway through Network resource provider.
  ## 
  let valid = call_569040.validator(path, query, header, formData, body)
  let scheme = call_569040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569040.url(scheme.get, call_569040.host, call_569040.base,
                         call_569040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569040, url, valid)

proc call*(call_569041: Call_VirtualNetworkGatewaysGet_569033;
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
  var path_569042 = newJObject()
  var query_569043 = newJObject()
  add(path_569042, "resourceGroupName", newJString(resourceGroupName))
  add(query_569043, "api-version", newJString(apiVersion))
  add(path_569042, "subscriptionId", newJString(subscriptionId))
  add(path_569042, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_569041.call(path_569042, query_569043, nil, nil, nil)

var virtualNetworkGatewaysGet* = Call_VirtualNetworkGatewaysGet_569033(
    name: "virtualNetworkGatewaysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}",
    validator: validate_VirtualNetworkGatewaysGet_569034, base: "",
    url: url_VirtualNetworkGatewaysGet_569035, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysDelete_569057 = ref object of OpenApiRestCall_567651
proc url_VirtualNetworkGatewaysDelete_569059(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGatewaysDelete_569058(path: JsonNode; query: JsonNode;
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
  var valid_569060 = path.getOrDefault("resourceGroupName")
  valid_569060 = validateParameter(valid_569060, JString, required = true,
                                 default = nil)
  if valid_569060 != nil:
    section.add "resourceGroupName", valid_569060
  var valid_569061 = path.getOrDefault("subscriptionId")
  valid_569061 = validateParameter(valid_569061, JString, required = true,
                                 default = nil)
  if valid_569061 != nil:
    section.add "subscriptionId", valid_569061
  var valid_569062 = path.getOrDefault("virtualNetworkGatewayName")
  valid_569062 = validateParameter(valid_569062, JString, required = true,
                                 default = nil)
  if valid_569062 != nil:
    section.add "virtualNetworkGatewayName", valid_569062
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569063 = query.getOrDefault("api-version")
  valid_569063 = validateParameter(valid_569063, JString, required = true,
                                 default = nil)
  if valid_569063 != nil:
    section.add "api-version", valid_569063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569064: Call_VirtualNetworkGatewaysDelete_569057; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete VirtualNetworkGateway operation deletes the specified virtual network Gateway through Network resource provider.
  ## 
  let valid = call_569064.validator(path, query, header, formData, body)
  let scheme = call_569064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569064.url(scheme.get, call_569064.host, call_569064.base,
                         call_569064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569064, url, valid)

proc call*(call_569065: Call_VirtualNetworkGatewaysDelete_569057;
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
  var path_569066 = newJObject()
  var query_569067 = newJObject()
  add(path_569066, "resourceGroupName", newJString(resourceGroupName))
  add(query_569067, "api-version", newJString(apiVersion))
  add(path_569066, "subscriptionId", newJString(subscriptionId))
  add(path_569066, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_569065.call(path_569066, query_569067, nil, nil, nil)

var virtualNetworkGatewaysDelete* = Call_VirtualNetworkGatewaysDelete_569057(
    name: "virtualNetworkGatewaysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}",
    validator: validate_VirtualNetworkGatewaysDelete_569058, base: "",
    url: url_VirtualNetworkGatewaysDelete_569059, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysGeneratevpnclientpackage_569068 = ref object of OpenApiRestCall_567651
proc url_VirtualNetworkGatewaysGeneratevpnclientpackage_569070(protocol: Scheme;
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

proc validate_VirtualNetworkGatewaysGeneratevpnclientpackage_569069(
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
  var valid_569071 = path.getOrDefault("resourceGroupName")
  valid_569071 = validateParameter(valid_569071, JString, required = true,
                                 default = nil)
  if valid_569071 != nil:
    section.add "resourceGroupName", valid_569071
  var valid_569072 = path.getOrDefault("subscriptionId")
  valid_569072 = validateParameter(valid_569072, JString, required = true,
                                 default = nil)
  if valid_569072 != nil:
    section.add "subscriptionId", valid_569072
  var valid_569073 = path.getOrDefault("virtualNetworkGatewayName")
  valid_569073 = validateParameter(valid_569073, JString, required = true,
                                 default = nil)
  if valid_569073 != nil:
    section.add "virtualNetworkGatewayName", valid_569073
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569074 = query.getOrDefault("api-version")
  valid_569074 = validateParameter(valid_569074, JString, required = true,
                                 default = nil)
  if valid_569074 != nil:
    section.add "api-version", valid_569074
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

proc call*(call_569076: Call_VirtualNetworkGatewaysGeneratevpnclientpackage_569068;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Generatevpnclientpackage operation generates Vpn client package for P2S client of the virtual network gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_569076.validator(path, query, header, formData, body)
  let scheme = call_569076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569076.url(scheme.get, call_569076.host, call_569076.base,
                         call_569076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569076, url, valid)

proc call*(call_569077: Call_VirtualNetworkGatewaysGeneratevpnclientpackage_569068;
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
  var path_569078 = newJObject()
  var query_569079 = newJObject()
  var body_569080 = newJObject()
  add(path_569078, "resourceGroupName", newJString(resourceGroupName))
  add(query_569079, "api-version", newJString(apiVersion))
  add(path_569078, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_569080 = parameters
  add(path_569078, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_569077.call(path_569078, query_569079, nil, nil, body_569080)

var virtualNetworkGatewaysGeneratevpnclientpackage* = Call_VirtualNetworkGatewaysGeneratevpnclientpackage_569068(
    name: "virtualNetworkGatewaysGeneratevpnclientpackage",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/generatevpnclientpackage",
    validator: validate_VirtualNetworkGatewaysGeneratevpnclientpackage_569069,
    base: "", url: url_VirtualNetworkGatewaysGeneratevpnclientpackage_569070,
    schemes: {Scheme.Https})
type
  Call_VirtualNetworkGatewaysReset_569081 = ref object of OpenApiRestCall_567651
proc url_VirtualNetworkGatewaysReset_569083(protocol: Scheme; host: string;
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

proc validate_VirtualNetworkGatewaysReset_569082(path: JsonNode; query: JsonNode;
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
  var valid_569084 = path.getOrDefault("resourceGroupName")
  valid_569084 = validateParameter(valid_569084, JString, required = true,
                                 default = nil)
  if valid_569084 != nil:
    section.add "resourceGroupName", valid_569084
  var valid_569085 = path.getOrDefault("subscriptionId")
  valid_569085 = validateParameter(valid_569085, JString, required = true,
                                 default = nil)
  if valid_569085 != nil:
    section.add "subscriptionId", valid_569085
  var valid_569086 = path.getOrDefault("virtualNetworkGatewayName")
  valid_569086 = validateParameter(valid_569086, JString, required = true,
                                 default = nil)
  if valid_569086 != nil:
    section.add "virtualNetworkGatewayName", valid_569086
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569087 = query.getOrDefault("api-version")
  valid_569087 = validateParameter(valid_569087, JString, required = true,
                                 default = nil)
  if valid_569087 != nil:
    section.add "api-version", valid_569087
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

proc call*(call_569089: Call_VirtualNetworkGatewaysReset_569081; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Reset VirtualNetworkGateway operation resets the primary of the virtual network gateway in the specified resource group through Network resource provider.
  ## 
  let valid = call_569089.validator(path, query, header, formData, body)
  let scheme = call_569089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569089.url(scheme.get, call_569089.host, call_569089.base,
                         call_569089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569089, url, valid)

proc call*(call_569090: Call_VirtualNetworkGatewaysReset_569081;
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
  var path_569091 = newJObject()
  var query_569092 = newJObject()
  var body_569093 = newJObject()
  add(path_569091, "resourceGroupName", newJString(resourceGroupName))
  add(query_569092, "api-version", newJString(apiVersion))
  add(path_569091, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_569093 = parameters
  add(path_569091, "virtualNetworkGatewayName",
      newJString(virtualNetworkGatewayName))
  result = call_569090.call(path_569091, query_569092, nil, nil, body_569093)

var virtualNetworkGatewaysReset* = Call_VirtualNetworkGatewaysReset_569081(
    name: "virtualNetworkGatewaysReset", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworkGateways/{virtualNetworkGatewayName}/reset",
    validator: validate_VirtualNetworkGatewaysReset_569082, base: "",
    url: url_VirtualNetworkGatewaysReset_569083, schemes: {Scheme.Https})
type
  Call_VirtualNetworksList_569094 = ref object of OpenApiRestCall_567651
proc url_VirtualNetworksList_569096(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksList_569095(path: JsonNode; query: JsonNode;
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
  var valid_569097 = path.getOrDefault("resourceGroupName")
  valid_569097 = validateParameter(valid_569097, JString, required = true,
                                 default = nil)
  if valid_569097 != nil:
    section.add "resourceGroupName", valid_569097
  var valid_569098 = path.getOrDefault("subscriptionId")
  valid_569098 = validateParameter(valid_569098, JString, required = true,
                                 default = nil)
  if valid_569098 != nil:
    section.add "subscriptionId", valid_569098
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569099 = query.getOrDefault("api-version")
  valid_569099 = validateParameter(valid_569099, JString, required = true,
                                 default = nil)
  if valid_569099 != nil:
    section.add "api-version", valid_569099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569100: Call_VirtualNetworksList_569094; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The list VirtualNetwork returns all Virtual Networks in a resource group
  ## 
  let valid = call_569100.validator(path, query, header, formData, body)
  let scheme = call_569100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569100.url(scheme.get, call_569100.host, call_569100.base,
                         call_569100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569100, url, valid)

proc call*(call_569101: Call_VirtualNetworksList_569094; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## virtualNetworksList
  ## The list VirtualNetwork returns all Virtual Networks in a resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_569102 = newJObject()
  var query_569103 = newJObject()
  add(path_569102, "resourceGroupName", newJString(resourceGroupName))
  add(query_569103, "api-version", newJString(apiVersion))
  add(path_569102, "subscriptionId", newJString(subscriptionId))
  result = call_569101.call(path_569102, query_569103, nil, nil, nil)

var virtualNetworksList* = Call_VirtualNetworksList_569094(
    name: "virtualNetworksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks",
    validator: validate_VirtualNetworksList_569095, base: "",
    url: url_VirtualNetworksList_569096, schemes: {Scheme.Https})
type
  Call_VirtualNetworksCreateOrUpdate_569116 = ref object of OpenApiRestCall_567651
proc url_VirtualNetworksCreateOrUpdate_569118(protocol: Scheme; host: string;
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

proc validate_VirtualNetworksCreateOrUpdate_569117(path: JsonNode; query: JsonNode;
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
  var valid_569119 = path.getOrDefault("resourceGroupName")
  valid_569119 = validateParameter(valid_569119, JString, required = true,
                                 default = nil)
  if valid_569119 != nil:
    section.add "resourceGroupName", valid_569119
  var valid_569120 = path.getOrDefault("subscriptionId")
  valid_569120 = validateParameter(valid_569120, JString, required = true,
                                 default = nil)
  if valid_569120 != nil:
    section.add "subscriptionId", valid_569120
  var valid_569121 = path.getOrDefault("virtualNetworkName")
  valid_569121 = validateParameter(valid_569121, JString, required = true,
                                 default = nil)
  if valid_569121 != nil:
    section.add "virtualNetworkName", valid_569121
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569122 = query.getOrDefault("api-version")
  valid_569122 = validateParameter(valid_569122, JString, required = true,
                                 default = nil)
  if valid_569122 != nil:
    section.add "api-version", valid_569122
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

proc call*(call_569124: Call_VirtualNetworksCreateOrUpdate_569116; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put VirtualNetwork operation creates/updates a virtual network in the specified resource group.
  ## 
  let valid = call_569124.validator(path, query, header, formData, body)
  let scheme = call_569124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569124.url(scheme.get, call_569124.host, call_569124.base,
                         call_569124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569124, url, valid)

proc call*(call_569125: Call_VirtualNetworksCreateOrUpdate_569116;
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
  var path_569126 = newJObject()
  var query_569127 = newJObject()
  var body_569128 = newJObject()
  add(path_569126, "resourceGroupName", newJString(resourceGroupName))
  add(query_569127, "api-version", newJString(apiVersion))
  add(path_569126, "subscriptionId", newJString(subscriptionId))
  add(path_569126, "virtualNetworkName", newJString(virtualNetworkName))
  if parameters != nil:
    body_569128 = parameters
  result = call_569125.call(path_569126, query_569127, nil, nil, body_569128)

var virtualNetworksCreateOrUpdate* = Call_VirtualNetworksCreateOrUpdate_569116(
    name: "virtualNetworksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworksCreateOrUpdate_569117, base: "",
    url: url_VirtualNetworksCreateOrUpdate_569118, schemes: {Scheme.Https})
type
  Call_VirtualNetworksGet_569104 = ref object of OpenApiRestCall_567651
proc url_VirtualNetworksGet_569106(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksGet_569105(path: JsonNode; query: JsonNode;
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
  var valid_569107 = path.getOrDefault("resourceGroupName")
  valid_569107 = validateParameter(valid_569107, JString, required = true,
                                 default = nil)
  if valid_569107 != nil:
    section.add "resourceGroupName", valid_569107
  var valid_569108 = path.getOrDefault("subscriptionId")
  valid_569108 = validateParameter(valid_569108, JString, required = true,
                                 default = nil)
  if valid_569108 != nil:
    section.add "subscriptionId", valid_569108
  var valid_569109 = path.getOrDefault("virtualNetworkName")
  valid_569109 = validateParameter(valid_569109, JString, required = true,
                                 default = nil)
  if valid_569109 != nil:
    section.add "virtualNetworkName", valid_569109
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569110 = query.getOrDefault("api-version")
  valid_569110 = validateParameter(valid_569110, JString, required = true,
                                 default = nil)
  if valid_569110 != nil:
    section.add "api-version", valid_569110
  var valid_569111 = query.getOrDefault("$expand")
  valid_569111 = validateParameter(valid_569111, JString, required = false,
                                 default = nil)
  if valid_569111 != nil:
    section.add "$expand", valid_569111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569112: Call_VirtualNetworksGet_569104; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get VirtualNetwork operation retrieves information about the specified virtual network.
  ## 
  let valid = call_569112.validator(path, query, header, formData, body)
  let scheme = call_569112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569112.url(scheme.get, call_569112.host, call_569112.base,
                         call_569112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569112, url, valid)

proc call*(call_569113: Call_VirtualNetworksGet_569104; resourceGroupName: string;
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
  var path_569114 = newJObject()
  var query_569115 = newJObject()
  add(path_569114, "resourceGroupName", newJString(resourceGroupName))
  add(query_569115, "api-version", newJString(apiVersion))
  add(query_569115, "$expand", newJString(Expand))
  add(path_569114, "subscriptionId", newJString(subscriptionId))
  add(path_569114, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_569113.call(path_569114, query_569115, nil, nil, nil)

var virtualNetworksGet* = Call_VirtualNetworksGet_569104(
    name: "virtualNetworksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworksGet_569105, base: "",
    url: url_VirtualNetworksGet_569106, schemes: {Scheme.Https})
type
  Call_VirtualNetworksDelete_569129 = ref object of OpenApiRestCall_567651
proc url_VirtualNetworksDelete_569131(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksDelete_569130(path: JsonNode; query: JsonNode;
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
  var valid_569132 = path.getOrDefault("resourceGroupName")
  valid_569132 = validateParameter(valid_569132, JString, required = true,
                                 default = nil)
  if valid_569132 != nil:
    section.add "resourceGroupName", valid_569132
  var valid_569133 = path.getOrDefault("subscriptionId")
  valid_569133 = validateParameter(valid_569133, JString, required = true,
                                 default = nil)
  if valid_569133 != nil:
    section.add "subscriptionId", valid_569133
  var valid_569134 = path.getOrDefault("virtualNetworkName")
  valid_569134 = validateParameter(valid_569134, JString, required = true,
                                 default = nil)
  if valid_569134 != nil:
    section.add "virtualNetworkName", valid_569134
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569135 = query.getOrDefault("api-version")
  valid_569135 = validateParameter(valid_569135, JString, required = true,
                                 default = nil)
  if valid_569135 != nil:
    section.add "api-version", valid_569135
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569136: Call_VirtualNetworksDelete_569129; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete VirtualNetwork operation deletes the specified virtual network
  ## 
  let valid = call_569136.validator(path, query, header, formData, body)
  let scheme = call_569136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569136.url(scheme.get, call_569136.host, call_569136.base,
                         call_569136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569136, url, valid)

proc call*(call_569137: Call_VirtualNetworksDelete_569129;
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
  var path_569138 = newJObject()
  var query_569139 = newJObject()
  add(path_569138, "resourceGroupName", newJString(resourceGroupName))
  add(query_569139, "api-version", newJString(apiVersion))
  add(path_569138, "subscriptionId", newJString(subscriptionId))
  add(path_569138, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_569137.call(path_569138, query_569139, nil, nil, nil)

var virtualNetworksDelete* = Call_VirtualNetworksDelete_569129(
    name: "virtualNetworksDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}",
    validator: validate_VirtualNetworksDelete_569130, base: "",
    url: url_VirtualNetworksDelete_569131, schemes: {Scheme.Https})
type
  Call_SubnetsList_569140 = ref object of OpenApiRestCall_567651
proc url_SubnetsList_569142(protocol: Scheme; host: string; base: string;
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

proc validate_SubnetsList_569141(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_569143 = path.getOrDefault("resourceGroupName")
  valid_569143 = validateParameter(valid_569143, JString, required = true,
                                 default = nil)
  if valid_569143 != nil:
    section.add "resourceGroupName", valid_569143
  var valid_569144 = path.getOrDefault("subscriptionId")
  valid_569144 = validateParameter(valid_569144, JString, required = true,
                                 default = nil)
  if valid_569144 != nil:
    section.add "subscriptionId", valid_569144
  var valid_569145 = path.getOrDefault("virtualNetworkName")
  valid_569145 = validateParameter(valid_569145, JString, required = true,
                                 default = nil)
  if valid_569145 != nil:
    section.add "virtualNetworkName", valid_569145
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569146 = query.getOrDefault("api-version")
  valid_569146 = validateParameter(valid_569146, JString, required = true,
                                 default = nil)
  if valid_569146 != nil:
    section.add "api-version", valid_569146
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569147: Call_SubnetsList_569140; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List subnets operation retrieves all the subnets in a virtual network.
  ## 
  let valid = call_569147.validator(path, query, header, formData, body)
  let scheme = call_569147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569147.url(scheme.get, call_569147.host, call_569147.base,
                         call_569147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569147, url, valid)

proc call*(call_569148: Call_SubnetsList_569140; resourceGroupName: string;
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
  var path_569149 = newJObject()
  var query_569150 = newJObject()
  add(path_569149, "resourceGroupName", newJString(resourceGroupName))
  add(query_569150, "api-version", newJString(apiVersion))
  add(path_569149, "subscriptionId", newJString(subscriptionId))
  add(path_569149, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_569148.call(path_569149, query_569150, nil, nil, nil)

var subnetsList* = Call_SubnetsList_569140(name: "subnetsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets",
                                        validator: validate_SubnetsList_569141,
                                        base: "", url: url_SubnetsList_569142,
                                        schemes: {Scheme.Https})
type
  Call_SubnetsCreateOrUpdate_569164 = ref object of OpenApiRestCall_567651
proc url_SubnetsCreateOrUpdate_569166(protocol: Scheme; host: string; base: string;
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

proc validate_SubnetsCreateOrUpdate_569165(path: JsonNode; query: JsonNode;
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
  var valid_569167 = path.getOrDefault("resourceGroupName")
  valid_569167 = validateParameter(valid_569167, JString, required = true,
                                 default = nil)
  if valid_569167 != nil:
    section.add "resourceGroupName", valid_569167
  var valid_569168 = path.getOrDefault("subnetName")
  valid_569168 = validateParameter(valid_569168, JString, required = true,
                                 default = nil)
  if valid_569168 != nil:
    section.add "subnetName", valid_569168
  var valid_569169 = path.getOrDefault("subscriptionId")
  valid_569169 = validateParameter(valid_569169, JString, required = true,
                                 default = nil)
  if valid_569169 != nil:
    section.add "subscriptionId", valid_569169
  var valid_569170 = path.getOrDefault("virtualNetworkName")
  valid_569170 = validateParameter(valid_569170, JString, required = true,
                                 default = nil)
  if valid_569170 != nil:
    section.add "virtualNetworkName", valid_569170
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569171 = query.getOrDefault("api-version")
  valid_569171 = validateParameter(valid_569171, JString, required = true,
                                 default = nil)
  if valid_569171 != nil:
    section.add "api-version", valid_569171
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

proc call*(call_569173: Call_SubnetsCreateOrUpdate_569164; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put Subnet operation creates/updates a subnet in the specified virtual network
  ## 
  let valid = call_569173.validator(path, query, header, formData, body)
  let scheme = call_569173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569173.url(scheme.get, call_569173.host, call_569173.base,
                         call_569173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569173, url, valid)

proc call*(call_569174: Call_SubnetsCreateOrUpdate_569164;
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
  var path_569175 = newJObject()
  var query_569176 = newJObject()
  var body_569177 = newJObject()
  add(path_569175, "resourceGroupName", newJString(resourceGroupName))
  add(path_569175, "subnetName", newJString(subnetName))
  add(query_569176, "api-version", newJString(apiVersion))
  add(path_569175, "subscriptionId", newJString(subscriptionId))
  add(path_569175, "virtualNetworkName", newJString(virtualNetworkName))
  if subnetParameters != nil:
    body_569177 = subnetParameters
  result = call_569174.call(path_569175, query_569176, nil, nil, body_569177)

var subnetsCreateOrUpdate* = Call_SubnetsCreateOrUpdate_569164(
    name: "subnetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}",
    validator: validate_SubnetsCreateOrUpdate_569165, base: "",
    url: url_SubnetsCreateOrUpdate_569166, schemes: {Scheme.Https})
type
  Call_SubnetsGet_569151 = ref object of OpenApiRestCall_567651
proc url_SubnetsGet_569153(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SubnetsGet_569152(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_569154 = path.getOrDefault("resourceGroupName")
  valid_569154 = validateParameter(valid_569154, JString, required = true,
                                 default = nil)
  if valid_569154 != nil:
    section.add "resourceGroupName", valid_569154
  var valid_569155 = path.getOrDefault("subnetName")
  valid_569155 = validateParameter(valid_569155, JString, required = true,
                                 default = nil)
  if valid_569155 != nil:
    section.add "subnetName", valid_569155
  var valid_569156 = path.getOrDefault("subscriptionId")
  valid_569156 = validateParameter(valid_569156, JString, required = true,
                                 default = nil)
  if valid_569156 != nil:
    section.add "subscriptionId", valid_569156
  var valid_569157 = path.getOrDefault("virtualNetworkName")
  valid_569157 = validateParameter(valid_569157, JString, required = true,
                                 default = nil)
  if valid_569157 != nil:
    section.add "virtualNetworkName", valid_569157
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569158 = query.getOrDefault("api-version")
  valid_569158 = validateParameter(valid_569158, JString, required = true,
                                 default = nil)
  if valid_569158 != nil:
    section.add "api-version", valid_569158
  var valid_569159 = query.getOrDefault("$expand")
  valid_569159 = validateParameter(valid_569159, JString, required = false,
                                 default = nil)
  if valid_569159 != nil:
    section.add "$expand", valid_569159
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569160: Call_SubnetsGet_569151; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get subnet operation retrieves information about the specified subnet.
  ## 
  let valid = call_569160.validator(path, query, header, formData, body)
  let scheme = call_569160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569160.url(scheme.get, call_569160.host, call_569160.base,
                         call_569160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569160, url, valid)

proc call*(call_569161: Call_SubnetsGet_569151; resourceGroupName: string;
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
  var path_569162 = newJObject()
  var query_569163 = newJObject()
  add(path_569162, "resourceGroupName", newJString(resourceGroupName))
  add(path_569162, "subnetName", newJString(subnetName))
  add(query_569163, "api-version", newJString(apiVersion))
  add(query_569163, "$expand", newJString(Expand))
  add(path_569162, "subscriptionId", newJString(subscriptionId))
  add(path_569162, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_569161.call(path_569162, query_569163, nil, nil, nil)

var subnetsGet* = Call_SubnetsGet_569151(name: "subnetsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}",
                                      validator: validate_SubnetsGet_569152,
                                      base: "", url: url_SubnetsGet_569153,
                                      schemes: {Scheme.Https})
type
  Call_SubnetsDelete_569178 = ref object of OpenApiRestCall_567651
proc url_SubnetsDelete_569180(protocol: Scheme; host: string; base: string;
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

proc validate_SubnetsDelete_569179(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_569181 = path.getOrDefault("resourceGroupName")
  valid_569181 = validateParameter(valid_569181, JString, required = true,
                                 default = nil)
  if valid_569181 != nil:
    section.add "resourceGroupName", valid_569181
  var valid_569182 = path.getOrDefault("subnetName")
  valid_569182 = validateParameter(valid_569182, JString, required = true,
                                 default = nil)
  if valid_569182 != nil:
    section.add "subnetName", valid_569182
  var valid_569183 = path.getOrDefault("subscriptionId")
  valid_569183 = validateParameter(valid_569183, JString, required = true,
                                 default = nil)
  if valid_569183 != nil:
    section.add "subscriptionId", valid_569183
  var valid_569184 = path.getOrDefault("virtualNetworkName")
  valid_569184 = validateParameter(valid_569184, JString, required = true,
                                 default = nil)
  if valid_569184 != nil:
    section.add "virtualNetworkName", valid_569184
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569185 = query.getOrDefault("api-version")
  valid_569185 = validateParameter(valid_569185, JString, required = true,
                                 default = nil)
  if valid_569185 != nil:
    section.add "api-version", valid_569185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569186: Call_SubnetsDelete_569178; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete subnet operation deletes the specified subnet.
  ## 
  let valid = call_569186.validator(path, query, header, formData, body)
  let scheme = call_569186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569186.url(scheme.get, call_569186.host, call_569186.base,
                         call_569186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569186, url, valid)

proc call*(call_569187: Call_SubnetsDelete_569178; resourceGroupName: string;
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
  var path_569188 = newJObject()
  var query_569189 = newJObject()
  add(path_569188, "resourceGroupName", newJString(resourceGroupName))
  add(path_569188, "subnetName", newJString(subnetName))
  add(query_569189, "api-version", newJString(apiVersion))
  add(path_569188, "subscriptionId", newJString(subscriptionId))
  add(path_569188, "virtualNetworkName", newJString(virtualNetworkName))
  result = call_569187.call(path_569188, query_569189, nil, nil, nil)

var subnetsDelete* = Call_SubnetsDelete_569178(name: "subnetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}",
    validator: validate_SubnetsDelete_569179, base: "", url: url_SubnetsDelete_569180,
    schemes: {Scheme.Https})
type
  Call_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_569190 = ref object of OpenApiRestCall_567651
proc url_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_569192(
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

proc validate_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_569191(
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
  var valid_569193 = path.getOrDefault("resourceGroupName")
  valid_569193 = validateParameter(valid_569193, JString, required = true,
                                 default = nil)
  if valid_569193 != nil:
    section.add "resourceGroupName", valid_569193
  var valid_569194 = path.getOrDefault("subscriptionId")
  valid_569194 = validateParameter(valid_569194, JString, required = true,
                                 default = nil)
  if valid_569194 != nil:
    section.add "subscriptionId", valid_569194
  var valid_569195 = path.getOrDefault("virtualMachineScaleSetName")
  valid_569195 = validateParameter(valid_569195, JString, required = true,
                                 default = nil)
  if valid_569195 != nil:
    section.add "virtualMachineScaleSetName", valid_569195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569196 = query.getOrDefault("api-version")
  valid_569196 = validateParameter(valid_569196, JString, required = true,
                                 default = nil)
  if valid_569196 != nil:
    section.add "api-version", valid_569196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569197: Call_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_569190;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The list network interface operation retrieves information about all network interfaces in a virtual machine scale set.
  ## 
  let valid = call_569197.validator(path, query, header, formData, body)
  let scheme = call_569197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569197.url(scheme.get, call_569197.host, call_569197.base,
                         call_569197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569197, url, valid)

proc call*(call_569198: Call_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_569190;
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
  var path_569199 = newJObject()
  var query_569200 = newJObject()
  add(path_569199, "resourceGroupName", newJString(resourceGroupName))
  add(query_569200, "api-version", newJString(apiVersion))
  add(path_569199, "subscriptionId", newJString(subscriptionId))
  add(path_569199, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  result = call_569198.call(path_569199, query_569200, nil, nil, nil)

var networkInterfacesListVirtualMachineScaleSetNetworkInterfaces* = Call_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_569190(
    name: "networkInterfacesListVirtualMachineScaleSetNetworkInterfaces",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/networkInterfaces", validator: validate_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_569191,
    base: "",
    url: url_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_569192,
    schemes: {Scheme.Https})
type
  Call_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_569201 = ref object of OpenApiRestCall_567651
proc url_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_569203(
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

proc validate_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_569202(
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
  var valid_569204 = path.getOrDefault("resourceGroupName")
  valid_569204 = validateParameter(valid_569204, JString, required = true,
                                 default = nil)
  if valid_569204 != nil:
    section.add "resourceGroupName", valid_569204
  var valid_569205 = path.getOrDefault("subscriptionId")
  valid_569205 = validateParameter(valid_569205, JString, required = true,
                                 default = nil)
  if valid_569205 != nil:
    section.add "subscriptionId", valid_569205
  var valid_569206 = path.getOrDefault("virtualmachineIndex")
  valid_569206 = validateParameter(valid_569206, JString, required = true,
                                 default = nil)
  if valid_569206 != nil:
    section.add "virtualmachineIndex", valid_569206
  var valid_569207 = path.getOrDefault("virtualMachineScaleSetName")
  valid_569207 = validateParameter(valid_569207, JString, required = true,
                                 default = nil)
  if valid_569207 != nil:
    section.add "virtualMachineScaleSetName", valid_569207
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569208 = query.getOrDefault("api-version")
  valid_569208 = validateParameter(valid_569208, JString, required = true,
                                 default = nil)
  if valid_569208 != nil:
    section.add "api-version", valid_569208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569209: Call_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_569201;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The list network interface operation retrieves information about all network interfaces in a virtual machine from a virtual machine scale set.
  ## 
  let valid = call_569209.validator(path, query, header, formData, body)
  let scheme = call_569209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569209.url(scheme.get, call_569209.host, call_569209.base,
                         call_569209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569209, url, valid)

proc call*(call_569210: Call_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_569201;
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
  var path_569211 = newJObject()
  var query_569212 = newJObject()
  add(path_569211, "resourceGroupName", newJString(resourceGroupName))
  add(query_569212, "api-version", newJString(apiVersion))
  add(path_569211, "subscriptionId", newJString(subscriptionId))
  add(path_569211, "virtualmachineIndex", newJString(virtualmachineIndex))
  add(path_569211, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  result = call_569210.call(path_569211, query_569212, nil, nil, nil)

var networkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces* = Call_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_569201(
    name: "networkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/virtualMachines/{virtualmachineIndex}/networkInterfaces", validator: validate_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_569202,
    base: "",
    url: url_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_569203,
    schemes: {Scheme.Https})
type
  Call_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_569213 = ref object of OpenApiRestCall_567651
proc url_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_569215(
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

proc validate_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_569214(
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
  var valid_569216 = path.getOrDefault("resourceGroupName")
  valid_569216 = validateParameter(valid_569216, JString, required = true,
                                 default = nil)
  if valid_569216 != nil:
    section.add "resourceGroupName", valid_569216
  var valid_569217 = path.getOrDefault("subscriptionId")
  valid_569217 = validateParameter(valid_569217, JString, required = true,
                                 default = nil)
  if valid_569217 != nil:
    section.add "subscriptionId", valid_569217
  var valid_569218 = path.getOrDefault("virtualmachineIndex")
  valid_569218 = validateParameter(valid_569218, JString, required = true,
                                 default = nil)
  if valid_569218 != nil:
    section.add "virtualmachineIndex", valid_569218
  var valid_569219 = path.getOrDefault("networkInterfaceName")
  valid_569219 = validateParameter(valid_569219, JString, required = true,
                                 default = nil)
  if valid_569219 != nil:
    section.add "networkInterfaceName", valid_569219
  var valid_569220 = path.getOrDefault("virtualMachineScaleSetName")
  valid_569220 = validateParameter(valid_569220, JString, required = true,
                                 default = nil)
  if valid_569220 != nil:
    section.add "virtualMachineScaleSetName", valid_569220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : expand references resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569221 = query.getOrDefault("api-version")
  valid_569221 = validateParameter(valid_569221, JString, required = true,
                                 default = nil)
  if valid_569221 != nil:
    section.add "api-version", valid_569221
  var valid_569222 = query.getOrDefault("$expand")
  valid_569222 = validateParameter(valid_569222, JString, required = false,
                                 default = nil)
  if valid_569222 != nil:
    section.add "$expand", valid_569222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569223: Call_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_569213;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Get network interface operation retrieves information about the specified network interface in a virtual machine scale set.
  ## 
  let valid = call_569223.validator(path, query, header, formData, body)
  let scheme = call_569223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569223.url(scheme.get, call_569223.host, call_569223.base,
                         call_569223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569223, url, valid)

proc call*(call_569224: Call_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_569213;
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
  var path_569225 = newJObject()
  var query_569226 = newJObject()
  add(path_569225, "resourceGroupName", newJString(resourceGroupName))
  add(query_569226, "api-version", newJString(apiVersion))
  add(query_569226, "$expand", newJString(Expand))
  add(path_569225, "subscriptionId", newJString(subscriptionId))
  add(path_569225, "virtualmachineIndex", newJString(virtualmachineIndex))
  add(path_569225, "networkInterfaceName", newJString(networkInterfaceName))
  add(path_569225, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  result = call_569224.call(path_569225, query_569226, nil, nil, nil)

var networkInterfacesGetVirtualMachineScaleSetNetworkInterface* = Call_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_569213(
    name: "networkInterfacesGetVirtualMachineScaleSetNetworkInterface",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/virtualMachines/{virtualmachineIndex}/networkInterfaces/{networkInterfaceName}", validator: validate_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_569214,
    base: "", url: url_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_569215,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
