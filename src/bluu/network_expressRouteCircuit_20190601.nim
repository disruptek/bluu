
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2019-06-01
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
  macServiceName = "network-expressRouteCircuit"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ExpressRouteCircuitsListAll_563777 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCircuitsListAll_563779(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsListAll_563778(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the express route circuits in a subscription.
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

proc call*(call_563969: Call_ExpressRouteCircuitsListAll_563777; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the express route circuits in a subscription.
  ## 
  let valid = call_563969.validator(path, query, header, formData, body)
  let scheme = call_563969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563969.url(scheme.get, call_563969.host, call_563969.base,
                         call_563969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563969, url, valid)

proc call*(call_564040: Call_ExpressRouteCircuitsListAll_563777;
          apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteCircuitsListAll
  ## Gets all the express route circuits in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564041 = newJObject()
  var query_564043 = newJObject()
  add(query_564043, "api-version", newJString(apiVersion))
  add(path_564041, "subscriptionId", newJString(subscriptionId))
  result = call_564040.call(path_564041, query_564043, nil, nil, nil)

var expressRouteCircuitsListAll* = Call_ExpressRouteCircuitsListAll_563777(
    name: "expressRouteCircuitsListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/expressRouteCircuits",
    validator: validate_ExpressRouteCircuitsListAll_563778, base: "",
    url: url_ExpressRouteCircuitsListAll_563779, schemes: {Scheme.Https})
type
  Call_ExpressRouteServiceProvidersList_564082 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteServiceProvidersList_564084(protocol: Scheme; host: string;
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

proc validate_ExpressRouteServiceProvidersList_564083(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the available express route service providers.
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

proc call*(call_564087: Call_ExpressRouteServiceProvidersList_564082;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the available express route service providers.
  ## 
  let valid = call_564087.validator(path, query, header, formData, body)
  let scheme = call_564087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564087.url(scheme.get, call_564087.host, call_564087.base,
                         call_564087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564087, url, valid)

proc call*(call_564088: Call_ExpressRouteServiceProvidersList_564082;
          apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteServiceProvidersList
  ## Gets all the available express route service providers.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564089 = newJObject()
  var query_564090 = newJObject()
  add(query_564090, "api-version", newJString(apiVersion))
  add(path_564089, "subscriptionId", newJString(subscriptionId))
  result = call_564088.call(path_564089, query_564090, nil, nil, nil)

var expressRouteServiceProvidersList* = Call_ExpressRouteServiceProvidersList_564082(
    name: "expressRouteServiceProvidersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/expressRouteServiceProviders",
    validator: validate_ExpressRouteServiceProvidersList_564083, base: "",
    url: url_ExpressRouteServiceProvidersList_564084, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsList_564091 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCircuitsList_564093(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsList_564092(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the express route circuits in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564094 = path.getOrDefault("subscriptionId")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "subscriptionId", valid_564094
  var valid_564095 = path.getOrDefault("resourceGroupName")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "resourceGroupName", valid_564095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564096 = query.getOrDefault("api-version")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "api-version", valid_564096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564097: Call_ExpressRouteCircuitsList_564091; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the express route circuits in a resource group.
  ## 
  let valid = call_564097.validator(path, query, header, formData, body)
  let scheme = call_564097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564097.url(scheme.get, call_564097.host, call_564097.base,
                         call_564097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564097, url, valid)

proc call*(call_564098: Call_ExpressRouteCircuitsList_564091; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## expressRouteCircuitsList
  ## Gets all the express route circuits in a resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564099 = newJObject()
  var query_564100 = newJObject()
  add(query_564100, "api-version", newJString(apiVersion))
  add(path_564099, "subscriptionId", newJString(subscriptionId))
  add(path_564099, "resourceGroupName", newJString(resourceGroupName))
  result = call_564098.call(path_564099, query_564100, nil, nil, nil)

var expressRouteCircuitsList* = Call_ExpressRouteCircuitsList_564091(
    name: "expressRouteCircuitsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits",
    validator: validate_ExpressRouteCircuitsList_564092, base: "",
    url: url_ExpressRouteCircuitsList_564093, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsCreateOrUpdate_564112 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCircuitsCreateOrUpdate_564114(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsCreateOrUpdate_564113(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an express route circuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564141 = path.getOrDefault("subscriptionId")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "subscriptionId", valid_564141
  var valid_564142 = path.getOrDefault("circuitName")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "circuitName", valid_564142
  var valid_564143 = path.getOrDefault("resourceGroupName")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "resourceGroupName", valid_564143
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564144 = query.getOrDefault("api-version")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "api-version", valid_564144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update express route circuit operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564146: Call_ExpressRouteCircuitsCreateOrUpdate_564112;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an express route circuit.
  ## 
  let valid = call_564146.validator(path, query, header, formData, body)
  let scheme = call_564146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564146.url(scheme.get, call_564146.host, call_564146.base,
                         call_564146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564146, url, valid)

proc call*(call_564147: Call_ExpressRouteCircuitsCreateOrUpdate_564112;
          apiVersion: string; subscriptionId: string; circuitName: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## expressRouteCircuitsCreateOrUpdate
  ## Creates or updates an express route circuit.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update express route circuit operation.
  var path_564148 = newJObject()
  var query_564149 = newJObject()
  var body_564150 = newJObject()
  add(query_564149, "api-version", newJString(apiVersion))
  add(path_564148, "subscriptionId", newJString(subscriptionId))
  add(path_564148, "circuitName", newJString(circuitName))
  add(path_564148, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564150 = parameters
  result = call_564147.call(path_564148, query_564149, nil, nil, body_564150)

var expressRouteCircuitsCreateOrUpdate* = Call_ExpressRouteCircuitsCreateOrUpdate_564112(
    name: "expressRouteCircuitsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}",
    validator: validate_ExpressRouteCircuitsCreateOrUpdate_564113, base: "",
    url: url_ExpressRouteCircuitsCreateOrUpdate_564114, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsGet_564101 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCircuitsGet_564103(protocol: Scheme; host: string; base: string;
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

proc validate_ExpressRouteCircuitsGet_564102(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the specified express route circuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564104 = path.getOrDefault("subscriptionId")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "subscriptionId", valid_564104
  var valid_564105 = path.getOrDefault("circuitName")
  valid_564105 = validateParameter(valid_564105, JString, required = true,
                                 default = nil)
  if valid_564105 != nil:
    section.add "circuitName", valid_564105
  var valid_564106 = path.getOrDefault("resourceGroupName")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "resourceGroupName", valid_564106
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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

proc call*(call_564108: Call_ExpressRouteCircuitsGet_564101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified express route circuit.
  ## 
  let valid = call_564108.validator(path, query, header, formData, body)
  let scheme = call_564108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564108.url(scheme.get, call_564108.host, call_564108.base,
                         call_564108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564108, url, valid)

proc call*(call_564109: Call_ExpressRouteCircuitsGet_564101; apiVersion: string;
          subscriptionId: string; circuitName: string; resourceGroupName: string): Recallable =
  ## expressRouteCircuitsGet
  ## Gets information about the specified express route circuit.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564110 = newJObject()
  var query_564111 = newJObject()
  add(query_564111, "api-version", newJString(apiVersion))
  add(path_564110, "subscriptionId", newJString(subscriptionId))
  add(path_564110, "circuitName", newJString(circuitName))
  add(path_564110, "resourceGroupName", newJString(resourceGroupName))
  result = call_564109.call(path_564110, query_564111, nil, nil, nil)

var expressRouteCircuitsGet* = Call_ExpressRouteCircuitsGet_564101(
    name: "expressRouteCircuitsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}",
    validator: validate_ExpressRouteCircuitsGet_564102, base: "",
    url: url_ExpressRouteCircuitsGet_564103, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsUpdateTags_564162 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCircuitsUpdateTags_564164(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsUpdateTags_564163(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an express route circuit tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564165 = path.getOrDefault("subscriptionId")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "subscriptionId", valid_564165
  var valid_564166 = path.getOrDefault("circuitName")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "circuitName", valid_564166
  var valid_564167 = path.getOrDefault("resourceGroupName")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "resourceGroupName", valid_564167
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564168 = query.getOrDefault("api-version")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "api-version", valid_564168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update express route circuit tags.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564170: Call_ExpressRouteCircuitsUpdateTags_564162; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an express route circuit tags.
  ## 
  let valid = call_564170.validator(path, query, header, formData, body)
  let scheme = call_564170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564170.url(scheme.get, call_564170.host, call_564170.base,
                         call_564170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564170, url, valid)

proc call*(call_564171: Call_ExpressRouteCircuitsUpdateTags_564162;
          apiVersion: string; subscriptionId: string; circuitName: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## expressRouteCircuitsUpdateTags
  ## Updates an express route circuit tags.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update express route circuit tags.
  var path_564172 = newJObject()
  var query_564173 = newJObject()
  var body_564174 = newJObject()
  add(query_564173, "api-version", newJString(apiVersion))
  add(path_564172, "subscriptionId", newJString(subscriptionId))
  add(path_564172, "circuitName", newJString(circuitName))
  add(path_564172, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564174 = parameters
  result = call_564171.call(path_564172, query_564173, nil, nil, body_564174)

var expressRouteCircuitsUpdateTags* = Call_ExpressRouteCircuitsUpdateTags_564162(
    name: "expressRouteCircuitsUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}",
    validator: validate_ExpressRouteCircuitsUpdateTags_564163, base: "",
    url: url_ExpressRouteCircuitsUpdateTags_564164, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsDelete_564151 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCircuitsDelete_564153(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsDelete_564152(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified express route circuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564154 = path.getOrDefault("subscriptionId")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "subscriptionId", valid_564154
  var valid_564155 = path.getOrDefault("circuitName")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "circuitName", valid_564155
  var valid_564156 = path.getOrDefault("resourceGroupName")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "resourceGroupName", valid_564156
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564157 = query.getOrDefault("api-version")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "api-version", valid_564157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564158: Call_ExpressRouteCircuitsDelete_564151; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified express route circuit.
  ## 
  let valid = call_564158.validator(path, query, header, formData, body)
  let scheme = call_564158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564158.url(scheme.get, call_564158.host, call_564158.base,
                         call_564158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564158, url, valid)

proc call*(call_564159: Call_ExpressRouteCircuitsDelete_564151; apiVersion: string;
          subscriptionId: string; circuitName: string; resourceGroupName: string): Recallable =
  ## expressRouteCircuitsDelete
  ## Deletes the specified express route circuit.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564160 = newJObject()
  var query_564161 = newJObject()
  add(query_564161, "api-version", newJString(apiVersion))
  add(path_564160, "subscriptionId", newJString(subscriptionId))
  add(path_564160, "circuitName", newJString(circuitName))
  add(path_564160, "resourceGroupName", newJString(resourceGroupName))
  result = call_564159.call(path_564160, query_564161, nil, nil, nil)

var expressRouteCircuitsDelete* = Call_ExpressRouteCircuitsDelete_564151(
    name: "expressRouteCircuitsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}",
    validator: validate_ExpressRouteCircuitsDelete_564152, base: "",
    url: url_ExpressRouteCircuitsDelete_564153, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsList_564175 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCircuitAuthorizationsList_564177(protocol: Scheme;
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

proc validate_ExpressRouteCircuitAuthorizationsList_564176(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all authorizations in an express route circuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564178 = path.getOrDefault("subscriptionId")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "subscriptionId", valid_564178
  var valid_564179 = path.getOrDefault("circuitName")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "circuitName", valid_564179
  var valid_564180 = path.getOrDefault("resourceGroupName")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "resourceGroupName", valid_564180
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564181 = query.getOrDefault("api-version")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "api-version", valid_564181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564182: Call_ExpressRouteCircuitAuthorizationsList_564175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all authorizations in an express route circuit.
  ## 
  let valid = call_564182.validator(path, query, header, formData, body)
  let scheme = call_564182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564182.url(scheme.get, call_564182.host, call_564182.base,
                         call_564182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564182, url, valid)

proc call*(call_564183: Call_ExpressRouteCircuitAuthorizationsList_564175;
          apiVersion: string; subscriptionId: string; circuitName: string;
          resourceGroupName: string): Recallable =
  ## expressRouteCircuitAuthorizationsList
  ## Gets all authorizations in an express route circuit.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564184 = newJObject()
  var query_564185 = newJObject()
  add(query_564185, "api-version", newJString(apiVersion))
  add(path_564184, "subscriptionId", newJString(subscriptionId))
  add(path_564184, "circuitName", newJString(circuitName))
  add(path_564184, "resourceGroupName", newJString(resourceGroupName))
  result = call_564183.call(path_564184, query_564185, nil, nil, nil)

var expressRouteCircuitAuthorizationsList* = Call_ExpressRouteCircuitAuthorizationsList_564175(
    name: "expressRouteCircuitAuthorizationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations",
    validator: validate_ExpressRouteCircuitAuthorizationsList_564176, base: "",
    url: url_ExpressRouteCircuitAuthorizationsList_564177, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_564198 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCircuitAuthorizationsCreateOrUpdate_564200(protocol: Scheme;
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

proc validate_ExpressRouteCircuitAuthorizationsCreateOrUpdate_564199(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates or updates an authorization in the specified express route circuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authorizationName: JString (required)
  ##                    : The name of the authorization.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564201 = path.getOrDefault("subscriptionId")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "subscriptionId", valid_564201
  var valid_564202 = path.getOrDefault("circuitName")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "circuitName", valid_564202
  var valid_564203 = path.getOrDefault("resourceGroupName")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "resourceGroupName", valid_564203
  var valid_564204 = path.getOrDefault("authorizationName")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = nil)
  if valid_564204 != nil:
    section.add "authorizationName", valid_564204
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564205 = query.getOrDefault("api-version")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "api-version", valid_564205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   authorizationParameters: JObject (required)
  ##                          : Parameters supplied to the create or update express route circuit authorization operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564207: Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_564198;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an authorization in the specified express route circuit.
  ## 
  let valid = call_564207.validator(path, query, header, formData, body)
  let scheme = call_564207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564207.url(scheme.get, call_564207.host, call_564207.base,
                         call_564207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564207, url, valid)

proc call*(call_564208: Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_564198;
          apiVersion: string; subscriptionId: string; circuitName: string;
          authorizationParameters: JsonNode; resourceGroupName: string;
          authorizationName: string): Recallable =
  ## expressRouteCircuitAuthorizationsCreateOrUpdate
  ## Creates or updates an authorization in the specified express route circuit.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   authorizationParameters: JObject (required)
  ##                          : Parameters supplied to the create or update express route circuit authorization operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   authorizationName: string (required)
  ##                    : The name of the authorization.
  var path_564209 = newJObject()
  var query_564210 = newJObject()
  var body_564211 = newJObject()
  add(query_564210, "api-version", newJString(apiVersion))
  add(path_564209, "subscriptionId", newJString(subscriptionId))
  add(path_564209, "circuitName", newJString(circuitName))
  if authorizationParameters != nil:
    body_564211 = authorizationParameters
  add(path_564209, "resourceGroupName", newJString(resourceGroupName))
  add(path_564209, "authorizationName", newJString(authorizationName))
  result = call_564208.call(path_564209, query_564210, nil, nil, body_564211)

var expressRouteCircuitAuthorizationsCreateOrUpdate* = Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_564198(
    name: "expressRouteCircuitAuthorizationsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations/{authorizationName}",
    validator: validate_ExpressRouteCircuitAuthorizationsCreateOrUpdate_564199,
    base: "", url: url_ExpressRouteCircuitAuthorizationsCreateOrUpdate_564200,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsGet_564186 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCircuitAuthorizationsGet_564188(protocol: Scheme;
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

proc validate_ExpressRouteCircuitAuthorizationsGet_564187(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified authorization from the specified express route circuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authorizationName: JString (required)
  ##                    : The name of the authorization.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564189 = path.getOrDefault("subscriptionId")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "subscriptionId", valid_564189
  var valid_564190 = path.getOrDefault("circuitName")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "circuitName", valid_564190
  var valid_564191 = path.getOrDefault("resourceGroupName")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "resourceGroupName", valid_564191
  var valid_564192 = path.getOrDefault("authorizationName")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "authorizationName", valid_564192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564193 = query.getOrDefault("api-version")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "api-version", valid_564193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564194: Call_ExpressRouteCircuitAuthorizationsGet_564186;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified authorization from the specified express route circuit.
  ## 
  let valid = call_564194.validator(path, query, header, formData, body)
  let scheme = call_564194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564194.url(scheme.get, call_564194.host, call_564194.base,
                         call_564194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564194, url, valid)

proc call*(call_564195: Call_ExpressRouteCircuitAuthorizationsGet_564186;
          apiVersion: string; subscriptionId: string; circuitName: string;
          resourceGroupName: string; authorizationName: string): Recallable =
  ## expressRouteCircuitAuthorizationsGet
  ## Gets the specified authorization from the specified express route circuit.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   authorizationName: string (required)
  ##                    : The name of the authorization.
  var path_564196 = newJObject()
  var query_564197 = newJObject()
  add(query_564197, "api-version", newJString(apiVersion))
  add(path_564196, "subscriptionId", newJString(subscriptionId))
  add(path_564196, "circuitName", newJString(circuitName))
  add(path_564196, "resourceGroupName", newJString(resourceGroupName))
  add(path_564196, "authorizationName", newJString(authorizationName))
  result = call_564195.call(path_564196, query_564197, nil, nil, nil)

var expressRouteCircuitAuthorizationsGet* = Call_ExpressRouteCircuitAuthorizationsGet_564186(
    name: "expressRouteCircuitAuthorizationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations/{authorizationName}",
    validator: validate_ExpressRouteCircuitAuthorizationsGet_564187, base: "",
    url: url_ExpressRouteCircuitAuthorizationsGet_564188, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsDelete_564212 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCircuitAuthorizationsDelete_564214(protocol: Scheme;
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

proc validate_ExpressRouteCircuitAuthorizationsDelete_564213(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified authorization from the specified express route circuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authorizationName: JString (required)
  ##                    : The name of the authorization.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564215 = path.getOrDefault("subscriptionId")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "subscriptionId", valid_564215
  var valid_564216 = path.getOrDefault("circuitName")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "circuitName", valid_564216
  var valid_564217 = path.getOrDefault("resourceGroupName")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = nil)
  if valid_564217 != nil:
    section.add "resourceGroupName", valid_564217
  var valid_564218 = path.getOrDefault("authorizationName")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "authorizationName", valid_564218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564219 = query.getOrDefault("api-version")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "api-version", valid_564219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564220: Call_ExpressRouteCircuitAuthorizationsDelete_564212;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified authorization from the specified express route circuit.
  ## 
  let valid = call_564220.validator(path, query, header, formData, body)
  let scheme = call_564220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564220.url(scheme.get, call_564220.host, call_564220.base,
                         call_564220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564220, url, valid)

proc call*(call_564221: Call_ExpressRouteCircuitAuthorizationsDelete_564212;
          apiVersion: string; subscriptionId: string; circuitName: string;
          resourceGroupName: string; authorizationName: string): Recallable =
  ## expressRouteCircuitAuthorizationsDelete
  ## Deletes the specified authorization from the specified express route circuit.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   authorizationName: string (required)
  ##                    : The name of the authorization.
  var path_564222 = newJObject()
  var query_564223 = newJObject()
  add(query_564223, "api-version", newJString(apiVersion))
  add(path_564222, "subscriptionId", newJString(subscriptionId))
  add(path_564222, "circuitName", newJString(circuitName))
  add(path_564222, "resourceGroupName", newJString(resourceGroupName))
  add(path_564222, "authorizationName", newJString(authorizationName))
  result = call_564221.call(path_564222, query_564223, nil, nil, nil)

var expressRouteCircuitAuthorizationsDelete* = Call_ExpressRouteCircuitAuthorizationsDelete_564212(
    name: "expressRouteCircuitAuthorizationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations/{authorizationName}",
    validator: validate_ExpressRouteCircuitAuthorizationsDelete_564213, base: "",
    url: url_ExpressRouteCircuitAuthorizationsDelete_564214,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsList_564224 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCircuitPeeringsList_564226(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitPeeringsList_564225(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all peerings in a specified express route circuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564227 = path.getOrDefault("subscriptionId")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "subscriptionId", valid_564227
  var valid_564228 = path.getOrDefault("circuitName")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "circuitName", valid_564228
  var valid_564229 = path.getOrDefault("resourceGroupName")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "resourceGroupName", valid_564229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564230 = query.getOrDefault("api-version")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "api-version", valid_564230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564231: Call_ExpressRouteCircuitPeeringsList_564224;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all peerings in a specified express route circuit.
  ## 
  let valid = call_564231.validator(path, query, header, formData, body)
  let scheme = call_564231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564231.url(scheme.get, call_564231.host, call_564231.base,
                         call_564231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564231, url, valid)

proc call*(call_564232: Call_ExpressRouteCircuitPeeringsList_564224;
          apiVersion: string; subscriptionId: string; circuitName: string;
          resourceGroupName: string): Recallable =
  ## expressRouteCircuitPeeringsList
  ## Gets all peerings in a specified express route circuit.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564233 = newJObject()
  var query_564234 = newJObject()
  add(query_564234, "api-version", newJString(apiVersion))
  add(path_564233, "subscriptionId", newJString(subscriptionId))
  add(path_564233, "circuitName", newJString(circuitName))
  add(path_564233, "resourceGroupName", newJString(resourceGroupName))
  result = call_564232.call(path_564233, query_564234, nil, nil, nil)

var expressRouteCircuitPeeringsList* = Call_ExpressRouteCircuitPeeringsList_564224(
    name: "expressRouteCircuitPeeringsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings",
    validator: validate_ExpressRouteCircuitPeeringsList_564225, base: "",
    url: url_ExpressRouteCircuitPeeringsList_564226, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsCreateOrUpdate_564247 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCircuitPeeringsCreateOrUpdate_564249(protocol: Scheme;
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

proc validate_ExpressRouteCircuitPeeringsCreateOrUpdate_564248(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a peering in the specified express route circuits.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `peeringName` field"
  var valid_564250 = path.getOrDefault("peeringName")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "peeringName", valid_564250
  var valid_564251 = path.getOrDefault("subscriptionId")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "subscriptionId", valid_564251
  var valid_564252 = path.getOrDefault("circuitName")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "circuitName", valid_564252
  var valid_564253 = path.getOrDefault("resourceGroupName")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "resourceGroupName", valid_564253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564254 = query.getOrDefault("api-version")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "api-version", valid_564254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   peeringParameters: JObject (required)
  ##                    : Parameters supplied to the create or update express route circuit peering operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564256: Call_ExpressRouteCircuitPeeringsCreateOrUpdate_564247;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a peering in the specified express route circuits.
  ## 
  let valid = call_564256.validator(path, query, header, formData, body)
  let scheme = call_564256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564256.url(scheme.get, call_564256.host, call_564256.base,
                         call_564256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564256, url, valid)

proc call*(call_564257: Call_ExpressRouteCircuitPeeringsCreateOrUpdate_564247;
          apiVersion: string; peeringName: string; subscriptionId: string;
          circuitName: string; resourceGroupName: string;
          peeringParameters: JsonNode): Recallable =
  ## expressRouteCircuitPeeringsCreateOrUpdate
  ## Creates or updates a peering in the specified express route circuits.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   peeringParameters: JObject (required)
  ##                    : Parameters supplied to the create or update express route circuit peering operation.
  var path_564258 = newJObject()
  var query_564259 = newJObject()
  var body_564260 = newJObject()
  add(query_564259, "api-version", newJString(apiVersion))
  add(path_564258, "peeringName", newJString(peeringName))
  add(path_564258, "subscriptionId", newJString(subscriptionId))
  add(path_564258, "circuitName", newJString(circuitName))
  add(path_564258, "resourceGroupName", newJString(resourceGroupName))
  if peeringParameters != nil:
    body_564260 = peeringParameters
  result = call_564257.call(path_564258, query_564259, nil, nil, body_564260)

var expressRouteCircuitPeeringsCreateOrUpdate* = Call_ExpressRouteCircuitPeeringsCreateOrUpdate_564247(
    name: "expressRouteCircuitPeeringsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCircuitPeeringsCreateOrUpdate_564248,
    base: "", url: url_ExpressRouteCircuitPeeringsCreateOrUpdate_564249,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsGet_564235 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCircuitPeeringsGet_564237(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitPeeringsGet_564236(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified peering for the express route circuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `peeringName` field"
  var valid_564238 = path.getOrDefault("peeringName")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "peeringName", valid_564238
  var valid_564239 = path.getOrDefault("subscriptionId")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "subscriptionId", valid_564239
  var valid_564240 = path.getOrDefault("circuitName")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "circuitName", valid_564240
  var valid_564241 = path.getOrDefault("resourceGroupName")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "resourceGroupName", valid_564241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564242 = query.getOrDefault("api-version")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "api-version", valid_564242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564243: Call_ExpressRouteCircuitPeeringsGet_564235; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified peering for the express route circuit.
  ## 
  let valid = call_564243.validator(path, query, header, formData, body)
  let scheme = call_564243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564243.url(scheme.get, call_564243.host, call_564243.base,
                         call_564243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564243, url, valid)

proc call*(call_564244: Call_ExpressRouteCircuitPeeringsGet_564235;
          apiVersion: string; peeringName: string; subscriptionId: string;
          circuitName: string; resourceGroupName: string): Recallable =
  ## expressRouteCircuitPeeringsGet
  ## Gets the specified peering for the express route circuit.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564245 = newJObject()
  var query_564246 = newJObject()
  add(query_564246, "api-version", newJString(apiVersion))
  add(path_564245, "peeringName", newJString(peeringName))
  add(path_564245, "subscriptionId", newJString(subscriptionId))
  add(path_564245, "circuitName", newJString(circuitName))
  add(path_564245, "resourceGroupName", newJString(resourceGroupName))
  result = call_564244.call(path_564245, query_564246, nil, nil, nil)

var expressRouteCircuitPeeringsGet* = Call_ExpressRouteCircuitPeeringsGet_564235(
    name: "expressRouteCircuitPeeringsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCircuitPeeringsGet_564236, base: "",
    url: url_ExpressRouteCircuitPeeringsGet_564237, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsDelete_564261 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCircuitPeeringsDelete_564263(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitPeeringsDelete_564262(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified peering from the specified express route circuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `peeringName` field"
  var valid_564264 = path.getOrDefault("peeringName")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "peeringName", valid_564264
  var valid_564265 = path.getOrDefault("subscriptionId")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = nil)
  if valid_564265 != nil:
    section.add "subscriptionId", valid_564265
  var valid_564266 = path.getOrDefault("circuitName")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "circuitName", valid_564266
  var valid_564267 = path.getOrDefault("resourceGroupName")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "resourceGroupName", valid_564267
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564268 = query.getOrDefault("api-version")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = nil)
  if valid_564268 != nil:
    section.add "api-version", valid_564268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564269: Call_ExpressRouteCircuitPeeringsDelete_564261;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified peering from the specified express route circuit.
  ## 
  let valid = call_564269.validator(path, query, header, formData, body)
  let scheme = call_564269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564269.url(scheme.get, call_564269.host, call_564269.base,
                         call_564269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564269, url, valid)

proc call*(call_564270: Call_ExpressRouteCircuitPeeringsDelete_564261;
          apiVersion: string; peeringName: string; subscriptionId: string;
          circuitName: string; resourceGroupName: string): Recallable =
  ## expressRouteCircuitPeeringsDelete
  ## Deletes the specified peering from the specified express route circuit.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564271 = newJObject()
  var query_564272 = newJObject()
  add(query_564272, "api-version", newJString(apiVersion))
  add(path_564271, "peeringName", newJString(peeringName))
  add(path_564271, "subscriptionId", newJString(subscriptionId))
  add(path_564271, "circuitName", newJString(circuitName))
  add(path_564271, "resourceGroupName", newJString(resourceGroupName))
  result = call_564270.call(path_564271, query_564272, nil, nil, nil)

var expressRouteCircuitPeeringsDelete* = Call_ExpressRouteCircuitPeeringsDelete_564261(
    name: "expressRouteCircuitPeeringsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCircuitPeeringsDelete_564262, base: "",
    url: url_ExpressRouteCircuitPeeringsDelete_564263, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsListArpTable_564273 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCircuitsListArpTable_564275(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsListArpTable_564274(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the currently advertised ARP table associated with the express route circuit in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   devicePath: JString (required)
  ##             : The path of the device.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `peeringName` field"
  var valid_564276 = path.getOrDefault("peeringName")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "peeringName", valid_564276
  var valid_564277 = path.getOrDefault("subscriptionId")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = nil)
  if valid_564277 != nil:
    section.add "subscriptionId", valid_564277
  var valid_564278 = path.getOrDefault("circuitName")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "circuitName", valid_564278
  var valid_564279 = path.getOrDefault("devicePath")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = nil)
  if valid_564279 != nil:
    section.add "devicePath", valid_564279
  var valid_564280 = path.getOrDefault("resourceGroupName")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "resourceGroupName", valid_564280
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564281 = query.getOrDefault("api-version")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "api-version", valid_564281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564282: Call_ExpressRouteCircuitsListArpTable_564273;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the currently advertised ARP table associated with the express route circuit in a resource group.
  ## 
  let valid = call_564282.validator(path, query, header, formData, body)
  let scheme = call_564282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564282.url(scheme.get, call_564282.host, call_564282.base,
                         call_564282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564282, url, valid)

proc call*(call_564283: Call_ExpressRouteCircuitsListArpTable_564273;
          apiVersion: string; peeringName: string; subscriptionId: string;
          circuitName: string; devicePath: string; resourceGroupName: string): Recallable =
  ## expressRouteCircuitsListArpTable
  ## Gets the currently advertised ARP table associated with the express route circuit in a resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   devicePath: string (required)
  ##             : The path of the device.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564284 = newJObject()
  var query_564285 = newJObject()
  add(query_564285, "api-version", newJString(apiVersion))
  add(path_564284, "peeringName", newJString(peeringName))
  add(path_564284, "subscriptionId", newJString(subscriptionId))
  add(path_564284, "circuitName", newJString(circuitName))
  add(path_564284, "devicePath", newJString(devicePath))
  add(path_564284, "resourceGroupName", newJString(resourceGroupName))
  result = call_564283.call(path_564284, query_564285, nil, nil, nil)

var expressRouteCircuitsListArpTable* = Call_ExpressRouteCircuitsListArpTable_564273(
    name: "expressRouteCircuitsListArpTable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/arpTables/{devicePath}",
    validator: validate_ExpressRouteCircuitsListArpTable_564274, base: "",
    url: url_ExpressRouteCircuitsListArpTable_564275, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitConnectionsList_564286 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCircuitConnectionsList_564288(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/connections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCircuitConnectionsList_564287(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all global reach connections associated with a private peering in an express route circuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `peeringName` field"
  var valid_564289 = path.getOrDefault("peeringName")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "peeringName", valid_564289
  var valid_564290 = path.getOrDefault("subscriptionId")
  valid_564290 = validateParameter(valid_564290, JString, required = true,
                                 default = nil)
  if valid_564290 != nil:
    section.add "subscriptionId", valid_564290
  var valid_564291 = path.getOrDefault("circuitName")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = nil)
  if valid_564291 != nil:
    section.add "circuitName", valid_564291
  var valid_564292 = path.getOrDefault("resourceGroupName")
  valid_564292 = validateParameter(valid_564292, JString, required = true,
                                 default = nil)
  if valid_564292 != nil:
    section.add "resourceGroupName", valid_564292
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564293 = query.getOrDefault("api-version")
  valid_564293 = validateParameter(valid_564293, JString, required = true,
                                 default = nil)
  if valid_564293 != nil:
    section.add "api-version", valid_564293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564294: Call_ExpressRouteCircuitConnectionsList_564286;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all global reach connections associated with a private peering in an express route circuit.
  ## 
  let valid = call_564294.validator(path, query, header, formData, body)
  let scheme = call_564294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564294.url(scheme.get, call_564294.host, call_564294.base,
                         call_564294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564294, url, valid)

proc call*(call_564295: Call_ExpressRouteCircuitConnectionsList_564286;
          apiVersion: string; peeringName: string; subscriptionId: string;
          circuitName: string; resourceGroupName: string): Recallable =
  ## expressRouteCircuitConnectionsList
  ## Gets all global reach connections associated with a private peering in an express route circuit.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564296 = newJObject()
  var query_564297 = newJObject()
  add(query_564297, "api-version", newJString(apiVersion))
  add(path_564296, "peeringName", newJString(peeringName))
  add(path_564296, "subscriptionId", newJString(subscriptionId))
  add(path_564296, "circuitName", newJString(circuitName))
  add(path_564296, "resourceGroupName", newJString(resourceGroupName))
  result = call_564295.call(path_564296, query_564297, nil, nil, nil)

var expressRouteCircuitConnectionsList* = Call_ExpressRouteCircuitConnectionsList_564286(
    name: "expressRouteCircuitConnectionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/connections",
    validator: validate_ExpressRouteCircuitConnectionsList_564287, base: "",
    url: url_ExpressRouteCircuitConnectionsList_564288, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitConnectionsCreateOrUpdate_564311 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCircuitConnectionsCreateOrUpdate_564313(protocol: Scheme;
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
  assert "connectionName" in path, "`connectionName` is a required path parameter"
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
               (kind: ConstantSegment, value: "/connections/"),
               (kind: VariableSegment, value: "connectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCircuitConnectionsCreateOrUpdate_564312(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a Express Route Circuit Connection in the specified express route circuits.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: JString (required)
  ##                 : The name of the express route circuit connection.
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `peeringName` field"
  var valid_564314 = path.getOrDefault("peeringName")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "peeringName", valid_564314
  var valid_564315 = path.getOrDefault("subscriptionId")
  valid_564315 = validateParameter(valid_564315, JString, required = true,
                                 default = nil)
  if valid_564315 != nil:
    section.add "subscriptionId", valid_564315
  var valid_564316 = path.getOrDefault("connectionName")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "connectionName", valid_564316
  var valid_564317 = path.getOrDefault("circuitName")
  valid_564317 = validateParameter(valid_564317, JString, required = true,
                                 default = nil)
  if valid_564317 != nil:
    section.add "circuitName", valid_564317
  var valid_564318 = path.getOrDefault("resourceGroupName")
  valid_564318 = validateParameter(valid_564318, JString, required = true,
                                 default = nil)
  if valid_564318 != nil:
    section.add "resourceGroupName", valid_564318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564319 = query.getOrDefault("api-version")
  valid_564319 = validateParameter(valid_564319, JString, required = true,
                                 default = nil)
  if valid_564319 != nil:
    section.add "api-version", valid_564319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   expressRouteCircuitConnectionParameters: JObject (required)
  ##                                          : Parameters supplied to the create or update express route circuit connection operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564321: Call_ExpressRouteCircuitConnectionsCreateOrUpdate_564311;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a Express Route Circuit Connection in the specified express route circuits.
  ## 
  let valid = call_564321.validator(path, query, header, formData, body)
  let scheme = call_564321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564321.url(scheme.get, call_564321.host, call_564321.base,
                         call_564321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564321, url, valid)

proc call*(call_564322: Call_ExpressRouteCircuitConnectionsCreateOrUpdate_564311;
          apiVersion: string; expressRouteCircuitConnectionParameters: JsonNode;
          peeringName: string; subscriptionId: string; connectionName: string;
          circuitName: string; resourceGroupName: string): Recallable =
  ## expressRouteCircuitConnectionsCreateOrUpdate
  ## Creates or updates a Express Route Circuit Connection in the specified express route circuits.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   expressRouteCircuitConnectionParameters: JObject (required)
  ##                                          : Parameters supplied to the create or update express route circuit connection operation.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: string (required)
  ##                 : The name of the express route circuit connection.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564323 = newJObject()
  var query_564324 = newJObject()
  var body_564325 = newJObject()
  add(query_564324, "api-version", newJString(apiVersion))
  if expressRouteCircuitConnectionParameters != nil:
    body_564325 = expressRouteCircuitConnectionParameters
  add(path_564323, "peeringName", newJString(peeringName))
  add(path_564323, "subscriptionId", newJString(subscriptionId))
  add(path_564323, "connectionName", newJString(connectionName))
  add(path_564323, "circuitName", newJString(circuitName))
  add(path_564323, "resourceGroupName", newJString(resourceGroupName))
  result = call_564322.call(path_564323, query_564324, nil, nil, body_564325)

var expressRouteCircuitConnectionsCreateOrUpdate* = Call_ExpressRouteCircuitConnectionsCreateOrUpdate_564311(
    name: "expressRouteCircuitConnectionsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/connections/{connectionName}",
    validator: validate_ExpressRouteCircuitConnectionsCreateOrUpdate_564312,
    base: "", url: url_ExpressRouteCircuitConnectionsCreateOrUpdate_564313,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitConnectionsGet_564298 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCircuitConnectionsGet_564300(protocol: Scheme; host: string;
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
  assert "connectionName" in path, "`connectionName` is a required path parameter"
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
               (kind: ConstantSegment, value: "/connections/"),
               (kind: VariableSegment, value: "connectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCircuitConnectionsGet_564299(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified Express Route Circuit Connection from the specified express route circuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: JString (required)
  ##                 : The name of the express route circuit connection.
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `peeringName` field"
  var valid_564301 = path.getOrDefault("peeringName")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "peeringName", valid_564301
  var valid_564302 = path.getOrDefault("subscriptionId")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "subscriptionId", valid_564302
  var valid_564303 = path.getOrDefault("connectionName")
  valid_564303 = validateParameter(valid_564303, JString, required = true,
                                 default = nil)
  if valid_564303 != nil:
    section.add "connectionName", valid_564303
  var valid_564304 = path.getOrDefault("circuitName")
  valid_564304 = validateParameter(valid_564304, JString, required = true,
                                 default = nil)
  if valid_564304 != nil:
    section.add "circuitName", valid_564304
  var valid_564305 = path.getOrDefault("resourceGroupName")
  valid_564305 = validateParameter(valid_564305, JString, required = true,
                                 default = nil)
  if valid_564305 != nil:
    section.add "resourceGroupName", valid_564305
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564306 = query.getOrDefault("api-version")
  valid_564306 = validateParameter(valid_564306, JString, required = true,
                                 default = nil)
  if valid_564306 != nil:
    section.add "api-version", valid_564306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564307: Call_ExpressRouteCircuitConnectionsGet_564298;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified Express Route Circuit Connection from the specified express route circuit.
  ## 
  let valid = call_564307.validator(path, query, header, formData, body)
  let scheme = call_564307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564307.url(scheme.get, call_564307.host, call_564307.base,
                         call_564307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564307, url, valid)

proc call*(call_564308: Call_ExpressRouteCircuitConnectionsGet_564298;
          apiVersion: string; peeringName: string; subscriptionId: string;
          connectionName: string; circuitName: string; resourceGroupName: string): Recallable =
  ## expressRouteCircuitConnectionsGet
  ## Gets the specified Express Route Circuit Connection from the specified express route circuit.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: string (required)
  ##                 : The name of the express route circuit connection.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564309 = newJObject()
  var query_564310 = newJObject()
  add(query_564310, "api-version", newJString(apiVersion))
  add(path_564309, "peeringName", newJString(peeringName))
  add(path_564309, "subscriptionId", newJString(subscriptionId))
  add(path_564309, "connectionName", newJString(connectionName))
  add(path_564309, "circuitName", newJString(circuitName))
  add(path_564309, "resourceGroupName", newJString(resourceGroupName))
  result = call_564308.call(path_564309, query_564310, nil, nil, nil)

var expressRouteCircuitConnectionsGet* = Call_ExpressRouteCircuitConnectionsGet_564298(
    name: "expressRouteCircuitConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/connections/{connectionName}",
    validator: validate_ExpressRouteCircuitConnectionsGet_564299, base: "",
    url: url_ExpressRouteCircuitConnectionsGet_564300, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitConnectionsDelete_564326 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCircuitConnectionsDelete_564328(protocol: Scheme;
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
  assert "connectionName" in path, "`connectionName` is a required path parameter"
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
               (kind: ConstantSegment, value: "/connections/"),
               (kind: VariableSegment, value: "connectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCircuitConnectionsDelete_564327(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified Express Route Circuit Connection from the specified express route circuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: JString (required)
  ##                 : The name of the express route circuit connection.
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `peeringName` field"
  var valid_564329 = path.getOrDefault("peeringName")
  valid_564329 = validateParameter(valid_564329, JString, required = true,
                                 default = nil)
  if valid_564329 != nil:
    section.add "peeringName", valid_564329
  var valid_564330 = path.getOrDefault("subscriptionId")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "subscriptionId", valid_564330
  var valid_564331 = path.getOrDefault("connectionName")
  valid_564331 = validateParameter(valid_564331, JString, required = true,
                                 default = nil)
  if valid_564331 != nil:
    section.add "connectionName", valid_564331
  var valid_564332 = path.getOrDefault("circuitName")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = nil)
  if valid_564332 != nil:
    section.add "circuitName", valid_564332
  var valid_564333 = path.getOrDefault("resourceGroupName")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "resourceGroupName", valid_564333
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564334 = query.getOrDefault("api-version")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "api-version", valid_564334
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564335: Call_ExpressRouteCircuitConnectionsDelete_564326;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified Express Route Circuit Connection from the specified express route circuit.
  ## 
  let valid = call_564335.validator(path, query, header, formData, body)
  let scheme = call_564335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564335.url(scheme.get, call_564335.host, call_564335.base,
                         call_564335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564335, url, valid)

proc call*(call_564336: Call_ExpressRouteCircuitConnectionsDelete_564326;
          apiVersion: string; peeringName: string; subscriptionId: string;
          connectionName: string; circuitName: string; resourceGroupName: string): Recallable =
  ## expressRouteCircuitConnectionsDelete
  ## Deletes the specified Express Route Circuit Connection from the specified express route circuit.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: string (required)
  ##                 : The name of the express route circuit connection.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564337 = newJObject()
  var query_564338 = newJObject()
  add(query_564338, "api-version", newJString(apiVersion))
  add(path_564337, "peeringName", newJString(peeringName))
  add(path_564337, "subscriptionId", newJString(subscriptionId))
  add(path_564337, "connectionName", newJString(connectionName))
  add(path_564337, "circuitName", newJString(circuitName))
  add(path_564337, "resourceGroupName", newJString(resourceGroupName))
  result = call_564336.call(path_564337, query_564338, nil, nil, nil)

var expressRouteCircuitConnectionsDelete* = Call_ExpressRouteCircuitConnectionsDelete_564326(
    name: "expressRouteCircuitConnectionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/connections/{connectionName}",
    validator: validate_ExpressRouteCircuitConnectionsDelete_564327, base: "",
    url: url_ExpressRouteCircuitConnectionsDelete_564328, schemes: {Scheme.Https})
type
  Call_PeerExpressRouteCircuitConnectionsList_564339 = ref object of OpenApiRestCall_563555
proc url_PeerExpressRouteCircuitConnectionsList_564341(protocol: Scheme;
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
               (kind: VariableSegment, value: "peeringName"),
               (kind: ConstantSegment, value: "/peerConnections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeerExpressRouteCircuitConnectionsList_564340(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all global reach peer connections associated with a private peering in an express route circuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `peeringName` field"
  var valid_564342 = path.getOrDefault("peeringName")
  valid_564342 = validateParameter(valid_564342, JString, required = true,
                                 default = nil)
  if valid_564342 != nil:
    section.add "peeringName", valid_564342
  var valid_564343 = path.getOrDefault("subscriptionId")
  valid_564343 = validateParameter(valid_564343, JString, required = true,
                                 default = nil)
  if valid_564343 != nil:
    section.add "subscriptionId", valid_564343
  var valid_564344 = path.getOrDefault("circuitName")
  valid_564344 = validateParameter(valid_564344, JString, required = true,
                                 default = nil)
  if valid_564344 != nil:
    section.add "circuitName", valid_564344
  var valid_564345 = path.getOrDefault("resourceGroupName")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "resourceGroupName", valid_564345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564346 = query.getOrDefault("api-version")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "api-version", valid_564346
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564347: Call_PeerExpressRouteCircuitConnectionsList_564339;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all global reach peer connections associated with a private peering in an express route circuit.
  ## 
  let valid = call_564347.validator(path, query, header, formData, body)
  let scheme = call_564347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564347.url(scheme.get, call_564347.host, call_564347.base,
                         call_564347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564347, url, valid)

proc call*(call_564348: Call_PeerExpressRouteCircuitConnectionsList_564339;
          apiVersion: string; peeringName: string; subscriptionId: string;
          circuitName: string; resourceGroupName: string): Recallable =
  ## peerExpressRouteCircuitConnectionsList
  ## Gets all global reach peer connections associated with a private peering in an express route circuit.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564349 = newJObject()
  var query_564350 = newJObject()
  add(query_564350, "api-version", newJString(apiVersion))
  add(path_564349, "peeringName", newJString(peeringName))
  add(path_564349, "subscriptionId", newJString(subscriptionId))
  add(path_564349, "circuitName", newJString(circuitName))
  add(path_564349, "resourceGroupName", newJString(resourceGroupName))
  result = call_564348.call(path_564349, query_564350, nil, nil, nil)

var peerExpressRouteCircuitConnectionsList* = Call_PeerExpressRouteCircuitConnectionsList_564339(
    name: "peerExpressRouteCircuitConnectionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/peerConnections",
    validator: validate_PeerExpressRouteCircuitConnectionsList_564340, base: "",
    url: url_PeerExpressRouteCircuitConnectionsList_564341,
    schemes: {Scheme.Https})
type
  Call_PeerExpressRouteCircuitConnectionsGet_564351 = ref object of OpenApiRestCall_563555
proc url_PeerExpressRouteCircuitConnectionsGet_564353(protocol: Scheme;
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
  assert "connectionName" in path, "`connectionName` is a required path parameter"
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
               (kind: ConstantSegment, value: "/peerConnections/"),
               (kind: VariableSegment, value: "connectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeerExpressRouteCircuitConnectionsGet_564352(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified Peer Express Route Circuit Connection from the specified express route circuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: JString (required)
  ##                 : The name of the peer express route circuit connection.
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `peeringName` field"
  var valid_564354 = path.getOrDefault("peeringName")
  valid_564354 = validateParameter(valid_564354, JString, required = true,
                                 default = nil)
  if valid_564354 != nil:
    section.add "peeringName", valid_564354
  var valid_564355 = path.getOrDefault("subscriptionId")
  valid_564355 = validateParameter(valid_564355, JString, required = true,
                                 default = nil)
  if valid_564355 != nil:
    section.add "subscriptionId", valid_564355
  var valid_564356 = path.getOrDefault("connectionName")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = nil)
  if valid_564356 != nil:
    section.add "connectionName", valid_564356
  var valid_564357 = path.getOrDefault("circuitName")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "circuitName", valid_564357
  var valid_564358 = path.getOrDefault("resourceGroupName")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "resourceGroupName", valid_564358
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564359 = query.getOrDefault("api-version")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "api-version", valid_564359
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564360: Call_PeerExpressRouteCircuitConnectionsGet_564351;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified Peer Express Route Circuit Connection from the specified express route circuit.
  ## 
  let valid = call_564360.validator(path, query, header, formData, body)
  let scheme = call_564360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564360.url(scheme.get, call_564360.host, call_564360.base,
                         call_564360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564360, url, valid)

proc call*(call_564361: Call_PeerExpressRouteCircuitConnectionsGet_564351;
          apiVersion: string; peeringName: string; subscriptionId: string;
          connectionName: string; circuitName: string; resourceGroupName: string): Recallable =
  ## peerExpressRouteCircuitConnectionsGet
  ## Gets the specified Peer Express Route Circuit Connection from the specified express route circuit.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: string (required)
  ##                 : The name of the peer express route circuit connection.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564362 = newJObject()
  var query_564363 = newJObject()
  add(query_564363, "api-version", newJString(apiVersion))
  add(path_564362, "peeringName", newJString(peeringName))
  add(path_564362, "subscriptionId", newJString(subscriptionId))
  add(path_564362, "connectionName", newJString(connectionName))
  add(path_564362, "circuitName", newJString(circuitName))
  add(path_564362, "resourceGroupName", newJString(resourceGroupName))
  result = call_564361.call(path_564362, query_564363, nil, nil, nil)

var peerExpressRouteCircuitConnectionsGet* = Call_PeerExpressRouteCircuitConnectionsGet_564351(
    name: "peerExpressRouteCircuitConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/peerConnections/{connectionName}",
    validator: validate_PeerExpressRouteCircuitConnectionsGet_564352, base: "",
    url: url_PeerExpressRouteCircuitConnectionsGet_564353, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsListRoutesTable_564364 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCircuitsListRoutesTable_564366(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsListRoutesTable_564365(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the currently advertised routes table associated with the express route circuit in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   devicePath: JString (required)
  ##             : The path of the device.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `peeringName` field"
  var valid_564367 = path.getOrDefault("peeringName")
  valid_564367 = validateParameter(valid_564367, JString, required = true,
                                 default = nil)
  if valid_564367 != nil:
    section.add "peeringName", valid_564367
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
  var valid_564370 = path.getOrDefault("devicePath")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = nil)
  if valid_564370 != nil:
    section.add "devicePath", valid_564370
  var valid_564371 = path.getOrDefault("resourceGroupName")
  valid_564371 = validateParameter(valid_564371, JString, required = true,
                                 default = nil)
  if valid_564371 != nil:
    section.add "resourceGroupName", valid_564371
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564372 = query.getOrDefault("api-version")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "api-version", valid_564372
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564373: Call_ExpressRouteCircuitsListRoutesTable_564364;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the currently advertised routes table associated with the express route circuit in a resource group.
  ## 
  let valid = call_564373.validator(path, query, header, formData, body)
  let scheme = call_564373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564373.url(scheme.get, call_564373.host, call_564373.base,
                         call_564373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564373, url, valid)

proc call*(call_564374: Call_ExpressRouteCircuitsListRoutesTable_564364;
          apiVersion: string; peeringName: string; subscriptionId: string;
          circuitName: string; devicePath: string; resourceGroupName: string): Recallable =
  ## expressRouteCircuitsListRoutesTable
  ## Gets the currently advertised routes table associated with the express route circuit in a resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   devicePath: string (required)
  ##             : The path of the device.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564375 = newJObject()
  var query_564376 = newJObject()
  add(query_564376, "api-version", newJString(apiVersion))
  add(path_564375, "peeringName", newJString(peeringName))
  add(path_564375, "subscriptionId", newJString(subscriptionId))
  add(path_564375, "circuitName", newJString(circuitName))
  add(path_564375, "devicePath", newJString(devicePath))
  add(path_564375, "resourceGroupName", newJString(resourceGroupName))
  result = call_564374.call(path_564375, query_564376, nil, nil, nil)

var expressRouteCircuitsListRoutesTable* = Call_ExpressRouteCircuitsListRoutesTable_564364(
    name: "expressRouteCircuitsListRoutesTable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/routeTables/{devicePath}",
    validator: validate_ExpressRouteCircuitsListRoutesTable_564365, base: "",
    url: url_ExpressRouteCircuitsListRoutesTable_564366, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsListRoutesTableSummary_564377 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCircuitsListRoutesTableSummary_564379(protocol: Scheme;
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

proc validate_ExpressRouteCircuitsListRoutesTableSummary_564378(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the currently advertised routes table summary associated with the express route circuit in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   devicePath: JString (required)
  ##             : The path of the device.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `peeringName` field"
  var valid_564380 = path.getOrDefault("peeringName")
  valid_564380 = validateParameter(valid_564380, JString, required = true,
                                 default = nil)
  if valid_564380 != nil:
    section.add "peeringName", valid_564380
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
  var valid_564383 = path.getOrDefault("devicePath")
  valid_564383 = validateParameter(valid_564383, JString, required = true,
                                 default = nil)
  if valid_564383 != nil:
    section.add "devicePath", valid_564383
  var valid_564384 = path.getOrDefault("resourceGroupName")
  valid_564384 = validateParameter(valid_564384, JString, required = true,
                                 default = nil)
  if valid_564384 != nil:
    section.add "resourceGroupName", valid_564384
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564385 = query.getOrDefault("api-version")
  valid_564385 = validateParameter(valid_564385, JString, required = true,
                                 default = nil)
  if valid_564385 != nil:
    section.add "api-version", valid_564385
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564386: Call_ExpressRouteCircuitsListRoutesTableSummary_564377;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the currently advertised routes table summary associated with the express route circuit in a resource group.
  ## 
  let valid = call_564386.validator(path, query, header, formData, body)
  let scheme = call_564386.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564386.url(scheme.get, call_564386.host, call_564386.base,
                         call_564386.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564386, url, valid)

proc call*(call_564387: Call_ExpressRouteCircuitsListRoutesTableSummary_564377;
          apiVersion: string; peeringName: string; subscriptionId: string;
          circuitName: string; devicePath: string; resourceGroupName: string): Recallable =
  ## expressRouteCircuitsListRoutesTableSummary
  ## Gets the currently advertised routes table summary associated with the express route circuit in a resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   devicePath: string (required)
  ##             : The path of the device.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564388 = newJObject()
  var query_564389 = newJObject()
  add(query_564389, "api-version", newJString(apiVersion))
  add(path_564388, "peeringName", newJString(peeringName))
  add(path_564388, "subscriptionId", newJString(subscriptionId))
  add(path_564388, "circuitName", newJString(circuitName))
  add(path_564388, "devicePath", newJString(devicePath))
  add(path_564388, "resourceGroupName", newJString(resourceGroupName))
  result = call_564387.call(path_564388, query_564389, nil, nil, nil)

var expressRouteCircuitsListRoutesTableSummary* = Call_ExpressRouteCircuitsListRoutesTableSummary_564377(
    name: "expressRouteCircuitsListRoutesTableSummary", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/routeTablesSummary/{devicePath}",
    validator: validate_ExpressRouteCircuitsListRoutesTableSummary_564378,
    base: "", url: url_ExpressRouteCircuitsListRoutesTableSummary_564379,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsGetPeeringStats_564390 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCircuitsGetPeeringStats_564392(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsGetPeeringStats_564391(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all stats from an express route circuit in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `peeringName` field"
  var valid_564393 = path.getOrDefault("peeringName")
  valid_564393 = validateParameter(valid_564393, JString, required = true,
                                 default = nil)
  if valid_564393 != nil:
    section.add "peeringName", valid_564393
  var valid_564394 = path.getOrDefault("subscriptionId")
  valid_564394 = validateParameter(valid_564394, JString, required = true,
                                 default = nil)
  if valid_564394 != nil:
    section.add "subscriptionId", valid_564394
  var valid_564395 = path.getOrDefault("circuitName")
  valid_564395 = validateParameter(valid_564395, JString, required = true,
                                 default = nil)
  if valid_564395 != nil:
    section.add "circuitName", valid_564395
  var valid_564396 = path.getOrDefault("resourceGroupName")
  valid_564396 = validateParameter(valid_564396, JString, required = true,
                                 default = nil)
  if valid_564396 != nil:
    section.add "resourceGroupName", valid_564396
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564397 = query.getOrDefault("api-version")
  valid_564397 = validateParameter(valid_564397, JString, required = true,
                                 default = nil)
  if valid_564397 != nil:
    section.add "api-version", valid_564397
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564398: Call_ExpressRouteCircuitsGetPeeringStats_564390;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all stats from an express route circuit in a resource group.
  ## 
  let valid = call_564398.validator(path, query, header, formData, body)
  let scheme = call_564398.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564398.url(scheme.get, call_564398.host, call_564398.base,
                         call_564398.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564398, url, valid)

proc call*(call_564399: Call_ExpressRouteCircuitsGetPeeringStats_564390;
          apiVersion: string; peeringName: string; subscriptionId: string;
          circuitName: string; resourceGroupName: string): Recallable =
  ## expressRouteCircuitsGetPeeringStats
  ## Gets all stats from an express route circuit in a resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564400 = newJObject()
  var query_564401 = newJObject()
  add(query_564401, "api-version", newJString(apiVersion))
  add(path_564400, "peeringName", newJString(peeringName))
  add(path_564400, "subscriptionId", newJString(subscriptionId))
  add(path_564400, "circuitName", newJString(circuitName))
  add(path_564400, "resourceGroupName", newJString(resourceGroupName))
  result = call_564399.call(path_564400, query_564401, nil, nil, nil)

var expressRouteCircuitsGetPeeringStats* = Call_ExpressRouteCircuitsGetPeeringStats_564390(
    name: "expressRouteCircuitsGetPeeringStats", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/stats",
    validator: validate_ExpressRouteCircuitsGetPeeringStats_564391, base: "",
    url: url_ExpressRouteCircuitsGetPeeringStats_564392, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsGetStats_564402 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCircuitsGetStats_564404(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsGetStats_564403(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the stats from an express route circuit in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564405 = path.getOrDefault("subscriptionId")
  valid_564405 = validateParameter(valid_564405, JString, required = true,
                                 default = nil)
  if valid_564405 != nil:
    section.add "subscriptionId", valid_564405
  var valid_564406 = path.getOrDefault("circuitName")
  valid_564406 = validateParameter(valid_564406, JString, required = true,
                                 default = nil)
  if valid_564406 != nil:
    section.add "circuitName", valid_564406
  var valid_564407 = path.getOrDefault("resourceGroupName")
  valid_564407 = validateParameter(valid_564407, JString, required = true,
                                 default = nil)
  if valid_564407 != nil:
    section.add "resourceGroupName", valid_564407
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564408 = query.getOrDefault("api-version")
  valid_564408 = validateParameter(valid_564408, JString, required = true,
                                 default = nil)
  if valid_564408 != nil:
    section.add "api-version", valid_564408
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564409: Call_ExpressRouteCircuitsGetStats_564402; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the stats from an express route circuit in a resource group.
  ## 
  let valid = call_564409.validator(path, query, header, formData, body)
  let scheme = call_564409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564409.url(scheme.get, call_564409.host, call_564409.base,
                         call_564409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564409, url, valid)

proc call*(call_564410: Call_ExpressRouteCircuitsGetStats_564402;
          apiVersion: string; subscriptionId: string; circuitName: string;
          resourceGroupName: string): Recallable =
  ## expressRouteCircuitsGetStats
  ## Gets all the stats from an express route circuit in a resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564411 = newJObject()
  var query_564412 = newJObject()
  add(query_564412, "api-version", newJString(apiVersion))
  add(path_564411, "subscriptionId", newJString(subscriptionId))
  add(path_564411, "circuitName", newJString(circuitName))
  add(path_564411, "resourceGroupName", newJString(resourceGroupName))
  result = call_564410.call(path_564411, query_564412, nil, nil, nil)

var expressRouteCircuitsGetStats* = Call_ExpressRouteCircuitsGetStats_564402(
    name: "expressRouteCircuitsGetStats", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/stats",
    validator: validate_ExpressRouteCircuitsGetStats_564403, base: "",
    url: url_ExpressRouteCircuitsGetStats_564404, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
