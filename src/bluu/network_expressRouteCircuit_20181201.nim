
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2018-12-01
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
  macServiceName = "network-expressRouteCircuit"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ExpressRouteCircuitsListAll_567879 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCircuitsListAll_567881(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsListAll_567880(path: JsonNode; query: JsonNode;
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

proc call*(call_568069: Call_ExpressRouteCircuitsListAll_567879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the express route circuits in a subscription.
  ## 
  let valid = call_568069.validator(path, query, header, formData, body)
  let scheme = call_568069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568069.url(scheme.get, call_568069.host, call_568069.base,
                         call_568069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568069, url, valid)

proc call*(call_568140: Call_ExpressRouteCircuitsListAll_567879;
          apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteCircuitsListAll
  ## Gets all the express route circuits in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568141 = newJObject()
  var query_568143 = newJObject()
  add(query_568143, "api-version", newJString(apiVersion))
  add(path_568141, "subscriptionId", newJString(subscriptionId))
  result = call_568140.call(path_568141, query_568143, nil, nil, nil)

var expressRouteCircuitsListAll* = Call_ExpressRouteCircuitsListAll_567879(
    name: "expressRouteCircuitsListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/expressRouteCircuits",
    validator: validate_ExpressRouteCircuitsListAll_567880, base: "",
    url: url_ExpressRouteCircuitsListAll_567881, schemes: {Scheme.Https})
type
  Call_ExpressRouteServiceProvidersList_568182 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteServiceProvidersList_568184(protocol: Scheme; host: string;
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

proc validate_ExpressRouteServiceProvidersList_568183(path: JsonNode;
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

proc call*(call_568187: Call_ExpressRouteServiceProvidersList_568182;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the available express route service providers.
  ## 
  let valid = call_568187.validator(path, query, header, formData, body)
  let scheme = call_568187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568187.url(scheme.get, call_568187.host, call_568187.base,
                         call_568187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568187, url, valid)

proc call*(call_568188: Call_ExpressRouteServiceProvidersList_568182;
          apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteServiceProvidersList
  ## Gets all the available express route service providers.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568189 = newJObject()
  var query_568190 = newJObject()
  add(query_568190, "api-version", newJString(apiVersion))
  add(path_568189, "subscriptionId", newJString(subscriptionId))
  result = call_568188.call(path_568189, query_568190, nil, nil, nil)

var expressRouteServiceProvidersList* = Call_ExpressRouteServiceProvidersList_568182(
    name: "expressRouteServiceProvidersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/expressRouteServiceProviders",
    validator: validate_ExpressRouteServiceProvidersList_568183, base: "",
    url: url_ExpressRouteServiceProvidersList_568184, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsList_568191 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCircuitsList_568193(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsList_568192(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the express route circuits in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568194 = path.getOrDefault("resourceGroupName")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "resourceGroupName", valid_568194
  var valid_568195 = path.getOrDefault("subscriptionId")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "subscriptionId", valid_568195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568196 = query.getOrDefault("api-version")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "api-version", valid_568196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568197: Call_ExpressRouteCircuitsList_568191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the express route circuits in a resource group.
  ## 
  let valid = call_568197.validator(path, query, header, formData, body)
  let scheme = call_568197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568197.url(scheme.get, call_568197.host, call_568197.base,
                         call_568197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568197, url, valid)

proc call*(call_568198: Call_ExpressRouteCircuitsList_568191;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteCircuitsList
  ## Gets all the express route circuits in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568199 = newJObject()
  var query_568200 = newJObject()
  add(path_568199, "resourceGroupName", newJString(resourceGroupName))
  add(query_568200, "api-version", newJString(apiVersion))
  add(path_568199, "subscriptionId", newJString(subscriptionId))
  result = call_568198.call(path_568199, query_568200, nil, nil, nil)

var expressRouteCircuitsList* = Call_ExpressRouteCircuitsList_568191(
    name: "expressRouteCircuitsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits",
    validator: validate_ExpressRouteCircuitsList_568192, base: "",
    url: url_ExpressRouteCircuitsList_568193, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsCreateOrUpdate_568212 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCircuitsCreateOrUpdate_568214(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsCreateOrUpdate_568213(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an express route circuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   circuitName: JString (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_568241 = path.getOrDefault("circuitName")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "circuitName", valid_568241
  var valid_568242 = path.getOrDefault("resourceGroupName")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "resourceGroupName", valid_568242
  var valid_568243 = path.getOrDefault("subscriptionId")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "subscriptionId", valid_568243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568244 = query.getOrDefault("api-version")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "api-version", valid_568244
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

proc call*(call_568246: Call_ExpressRouteCircuitsCreateOrUpdate_568212;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an express route circuit.
  ## 
  let valid = call_568246.validator(path, query, header, formData, body)
  let scheme = call_568246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568246.url(scheme.get, call_568246.host, call_568246.base,
                         call_568246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568246, url, valid)

proc call*(call_568247: Call_ExpressRouteCircuitsCreateOrUpdate_568212;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## expressRouteCircuitsCreateOrUpdate
  ## Creates or updates an express route circuit.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update express route circuit operation.
  var path_568248 = newJObject()
  var query_568249 = newJObject()
  var body_568250 = newJObject()
  add(path_568248, "circuitName", newJString(circuitName))
  add(path_568248, "resourceGroupName", newJString(resourceGroupName))
  add(query_568249, "api-version", newJString(apiVersion))
  add(path_568248, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568250 = parameters
  result = call_568247.call(path_568248, query_568249, nil, nil, body_568250)

var expressRouteCircuitsCreateOrUpdate* = Call_ExpressRouteCircuitsCreateOrUpdate_568212(
    name: "expressRouteCircuitsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}",
    validator: validate_ExpressRouteCircuitsCreateOrUpdate_568213, base: "",
    url: url_ExpressRouteCircuitsCreateOrUpdate_568214, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsGet_568201 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCircuitsGet_568203(protocol: Scheme; host: string; base: string;
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

proc validate_ExpressRouteCircuitsGet_568202(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the specified express route circuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   circuitName: JString (required)
  ##              : The name of express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_568204 = path.getOrDefault("circuitName")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "circuitName", valid_568204
  var valid_568205 = path.getOrDefault("resourceGroupName")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "resourceGroupName", valid_568205
  var valid_568206 = path.getOrDefault("subscriptionId")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "subscriptionId", valid_568206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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

proc call*(call_568208: Call_ExpressRouteCircuitsGet_568201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified express route circuit.
  ## 
  let valid = call_568208.validator(path, query, header, formData, body)
  let scheme = call_568208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568208.url(scheme.get, call_568208.host, call_568208.base,
                         call_568208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568208, url, valid)

proc call*(call_568209: Call_ExpressRouteCircuitsGet_568201; circuitName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteCircuitsGet
  ## Gets information about the specified express route circuit.
  ##   circuitName: string (required)
  ##              : The name of express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568210 = newJObject()
  var query_568211 = newJObject()
  add(path_568210, "circuitName", newJString(circuitName))
  add(path_568210, "resourceGroupName", newJString(resourceGroupName))
  add(query_568211, "api-version", newJString(apiVersion))
  add(path_568210, "subscriptionId", newJString(subscriptionId))
  result = call_568209.call(path_568210, query_568211, nil, nil, nil)

var expressRouteCircuitsGet* = Call_ExpressRouteCircuitsGet_568201(
    name: "expressRouteCircuitsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}",
    validator: validate_ExpressRouteCircuitsGet_568202, base: "",
    url: url_ExpressRouteCircuitsGet_568203, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsUpdateTags_568262 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCircuitsUpdateTags_568264(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsUpdateTags_568263(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an express route circuit tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   circuitName: JString (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_568265 = path.getOrDefault("circuitName")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "circuitName", valid_568265
  var valid_568266 = path.getOrDefault("resourceGroupName")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "resourceGroupName", valid_568266
  var valid_568267 = path.getOrDefault("subscriptionId")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "subscriptionId", valid_568267
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568268 = query.getOrDefault("api-version")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "api-version", valid_568268
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

proc call*(call_568270: Call_ExpressRouteCircuitsUpdateTags_568262; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an express route circuit tags.
  ## 
  let valid = call_568270.validator(path, query, header, formData, body)
  let scheme = call_568270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568270.url(scheme.get, call_568270.host, call_568270.base,
                         call_568270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568270, url, valid)

proc call*(call_568271: Call_ExpressRouteCircuitsUpdateTags_568262;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## expressRouteCircuitsUpdateTags
  ## Updates an express route circuit tags.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update express route circuit tags.
  var path_568272 = newJObject()
  var query_568273 = newJObject()
  var body_568274 = newJObject()
  add(path_568272, "circuitName", newJString(circuitName))
  add(path_568272, "resourceGroupName", newJString(resourceGroupName))
  add(query_568273, "api-version", newJString(apiVersion))
  add(path_568272, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568274 = parameters
  result = call_568271.call(path_568272, query_568273, nil, nil, body_568274)

var expressRouteCircuitsUpdateTags* = Call_ExpressRouteCircuitsUpdateTags_568262(
    name: "expressRouteCircuitsUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}",
    validator: validate_ExpressRouteCircuitsUpdateTags_568263, base: "",
    url: url_ExpressRouteCircuitsUpdateTags_568264, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsDelete_568251 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCircuitsDelete_568253(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsDelete_568252(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified express route circuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_568254 = path.getOrDefault("circuitName")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "circuitName", valid_568254
  var valid_568255 = path.getOrDefault("resourceGroupName")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "resourceGroupName", valid_568255
  var valid_568256 = path.getOrDefault("subscriptionId")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "subscriptionId", valid_568256
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568257 = query.getOrDefault("api-version")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "api-version", valid_568257
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568258: Call_ExpressRouteCircuitsDelete_568251; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified express route circuit.
  ## 
  let valid = call_568258.validator(path, query, header, formData, body)
  let scheme = call_568258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568258.url(scheme.get, call_568258.host, call_568258.base,
                         call_568258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568258, url, valid)

proc call*(call_568259: Call_ExpressRouteCircuitsDelete_568251;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## expressRouteCircuitsDelete
  ## Deletes the specified express route circuit.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568260 = newJObject()
  var query_568261 = newJObject()
  add(path_568260, "circuitName", newJString(circuitName))
  add(path_568260, "resourceGroupName", newJString(resourceGroupName))
  add(query_568261, "api-version", newJString(apiVersion))
  add(path_568260, "subscriptionId", newJString(subscriptionId))
  result = call_568259.call(path_568260, query_568261, nil, nil, nil)

var expressRouteCircuitsDelete* = Call_ExpressRouteCircuitsDelete_568251(
    name: "expressRouteCircuitsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}",
    validator: validate_ExpressRouteCircuitsDelete_568252, base: "",
    url: url_ExpressRouteCircuitsDelete_568253, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsList_568275 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCircuitAuthorizationsList_568277(protocol: Scheme;
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

proc validate_ExpressRouteCircuitAuthorizationsList_568276(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all authorizations in an express route circuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   circuitName: JString (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_568278 = path.getOrDefault("circuitName")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "circuitName", valid_568278
  var valid_568279 = path.getOrDefault("resourceGroupName")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "resourceGroupName", valid_568279
  var valid_568280 = path.getOrDefault("subscriptionId")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "subscriptionId", valid_568280
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568281 = query.getOrDefault("api-version")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "api-version", valid_568281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568282: Call_ExpressRouteCircuitAuthorizationsList_568275;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all authorizations in an express route circuit.
  ## 
  let valid = call_568282.validator(path, query, header, formData, body)
  let scheme = call_568282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568282.url(scheme.get, call_568282.host, call_568282.base,
                         call_568282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568282, url, valid)

proc call*(call_568283: Call_ExpressRouteCircuitAuthorizationsList_568275;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## expressRouteCircuitAuthorizationsList
  ## Gets all authorizations in an express route circuit.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568284 = newJObject()
  var query_568285 = newJObject()
  add(path_568284, "circuitName", newJString(circuitName))
  add(path_568284, "resourceGroupName", newJString(resourceGroupName))
  add(query_568285, "api-version", newJString(apiVersion))
  add(path_568284, "subscriptionId", newJString(subscriptionId))
  result = call_568283.call(path_568284, query_568285, nil, nil, nil)

var expressRouteCircuitAuthorizationsList* = Call_ExpressRouteCircuitAuthorizationsList_568275(
    name: "expressRouteCircuitAuthorizationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations",
    validator: validate_ExpressRouteCircuitAuthorizationsList_568276, base: "",
    url: url_ExpressRouteCircuitAuthorizationsList_568277, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_568298 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCircuitAuthorizationsCreateOrUpdate_568300(protocol: Scheme;
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

proc validate_ExpressRouteCircuitAuthorizationsCreateOrUpdate_568299(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates or updates an authorization in the specified express route circuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationName: JString (required)
  ##                    : The name of the authorization.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_568301 = path.getOrDefault("circuitName")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "circuitName", valid_568301
  var valid_568302 = path.getOrDefault("resourceGroupName")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "resourceGroupName", valid_568302
  var valid_568303 = path.getOrDefault("subscriptionId")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "subscriptionId", valid_568303
  var valid_568304 = path.getOrDefault("authorizationName")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "authorizationName", valid_568304
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568305 = query.getOrDefault("api-version")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "api-version", valid_568305
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

proc call*(call_568307: Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_568298;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an authorization in the specified express route circuit.
  ## 
  let valid = call_568307.validator(path, query, header, formData, body)
  let scheme = call_568307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568307.url(scheme.get, call_568307.host, call_568307.base,
                         call_568307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568307, url, valid)

proc call*(call_568308: Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_568298;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; authorizationParameters: JsonNode;
          authorizationName: string): Recallable =
  ## expressRouteCircuitAuthorizationsCreateOrUpdate
  ## Creates or updates an authorization in the specified express route circuit.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationParameters: JObject (required)
  ##                          : Parameters supplied to the create or update express route circuit authorization operation.
  ##   authorizationName: string (required)
  ##                    : The name of the authorization.
  var path_568309 = newJObject()
  var query_568310 = newJObject()
  var body_568311 = newJObject()
  add(path_568309, "circuitName", newJString(circuitName))
  add(path_568309, "resourceGroupName", newJString(resourceGroupName))
  add(query_568310, "api-version", newJString(apiVersion))
  add(path_568309, "subscriptionId", newJString(subscriptionId))
  if authorizationParameters != nil:
    body_568311 = authorizationParameters
  add(path_568309, "authorizationName", newJString(authorizationName))
  result = call_568308.call(path_568309, query_568310, nil, nil, body_568311)

var expressRouteCircuitAuthorizationsCreateOrUpdate* = Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_568298(
    name: "expressRouteCircuitAuthorizationsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations/{authorizationName}",
    validator: validate_ExpressRouteCircuitAuthorizationsCreateOrUpdate_568299,
    base: "", url: url_ExpressRouteCircuitAuthorizationsCreateOrUpdate_568300,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsGet_568286 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCircuitAuthorizationsGet_568288(protocol: Scheme;
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

proc validate_ExpressRouteCircuitAuthorizationsGet_568287(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified authorization from the specified express route circuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationName: JString (required)
  ##                    : The name of the authorization.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_568289 = path.getOrDefault("circuitName")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "circuitName", valid_568289
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
  var valid_568292 = path.getOrDefault("authorizationName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "authorizationName", valid_568292
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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

proc call*(call_568294: Call_ExpressRouteCircuitAuthorizationsGet_568286;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified authorization from the specified express route circuit.
  ## 
  let valid = call_568294.validator(path, query, header, formData, body)
  let scheme = call_568294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568294.url(scheme.get, call_568294.host, call_568294.base,
                         call_568294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568294, url, valid)

proc call*(call_568295: Call_ExpressRouteCircuitAuthorizationsGet_568286;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; authorizationName: string): Recallable =
  ## expressRouteCircuitAuthorizationsGet
  ## Gets the specified authorization from the specified express route circuit.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationName: string (required)
  ##                    : The name of the authorization.
  var path_568296 = newJObject()
  var query_568297 = newJObject()
  add(path_568296, "circuitName", newJString(circuitName))
  add(path_568296, "resourceGroupName", newJString(resourceGroupName))
  add(query_568297, "api-version", newJString(apiVersion))
  add(path_568296, "subscriptionId", newJString(subscriptionId))
  add(path_568296, "authorizationName", newJString(authorizationName))
  result = call_568295.call(path_568296, query_568297, nil, nil, nil)

var expressRouteCircuitAuthorizationsGet* = Call_ExpressRouteCircuitAuthorizationsGet_568286(
    name: "expressRouteCircuitAuthorizationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations/{authorizationName}",
    validator: validate_ExpressRouteCircuitAuthorizationsGet_568287, base: "",
    url: url_ExpressRouteCircuitAuthorizationsGet_568288, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsDelete_568312 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCircuitAuthorizationsDelete_568314(protocol: Scheme;
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

proc validate_ExpressRouteCircuitAuthorizationsDelete_568313(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified authorization from the specified express route circuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationName: JString (required)
  ##                    : The name of the authorization.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_568315 = path.getOrDefault("circuitName")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "circuitName", valid_568315
  var valid_568316 = path.getOrDefault("resourceGroupName")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "resourceGroupName", valid_568316
  var valid_568317 = path.getOrDefault("subscriptionId")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "subscriptionId", valid_568317
  var valid_568318 = path.getOrDefault("authorizationName")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "authorizationName", valid_568318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568319 = query.getOrDefault("api-version")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "api-version", valid_568319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568320: Call_ExpressRouteCircuitAuthorizationsDelete_568312;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified authorization from the specified express route circuit.
  ## 
  let valid = call_568320.validator(path, query, header, formData, body)
  let scheme = call_568320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568320.url(scheme.get, call_568320.host, call_568320.base,
                         call_568320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568320, url, valid)

proc call*(call_568321: Call_ExpressRouteCircuitAuthorizationsDelete_568312;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; authorizationName: string): Recallable =
  ## expressRouteCircuitAuthorizationsDelete
  ## Deletes the specified authorization from the specified express route circuit.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationName: string (required)
  ##                    : The name of the authorization.
  var path_568322 = newJObject()
  var query_568323 = newJObject()
  add(path_568322, "circuitName", newJString(circuitName))
  add(path_568322, "resourceGroupName", newJString(resourceGroupName))
  add(query_568323, "api-version", newJString(apiVersion))
  add(path_568322, "subscriptionId", newJString(subscriptionId))
  add(path_568322, "authorizationName", newJString(authorizationName))
  result = call_568321.call(path_568322, query_568323, nil, nil, nil)

var expressRouteCircuitAuthorizationsDelete* = Call_ExpressRouteCircuitAuthorizationsDelete_568312(
    name: "expressRouteCircuitAuthorizationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations/{authorizationName}",
    validator: validate_ExpressRouteCircuitAuthorizationsDelete_568313, base: "",
    url: url_ExpressRouteCircuitAuthorizationsDelete_568314,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsList_568324 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCircuitPeeringsList_568326(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitPeeringsList_568325(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all peerings in a specified express route circuit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_568327 = path.getOrDefault("circuitName")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "circuitName", valid_568327
  var valid_568328 = path.getOrDefault("resourceGroupName")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "resourceGroupName", valid_568328
  var valid_568329 = path.getOrDefault("subscriptionId")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "subscriptionId", valid_568329
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568330 = query.getOrDefault("api-version")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "api-version", valid_568330
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568331: Call_ExpressRouteCircuitPeeringsList_568324;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all peerings in a specified express route circuit.
  ## 
  let valid = call_568331.validator(path, query, header, formData, body)
  let scheme = call_568331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568331.url(scheme.get, call_568331.host, call_568331.base,
                         call_568331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568331, url, valid)

proc call*(call_568332: Call_ExpressRouteCircuitPeeringsList_568324;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## expressRouteCircuitPeeringsList
  ## Gets all peerings in a specified express route circuit.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568333 = newJObject()
  var query_568334 = newJObject()
  add(path_568333, "circuitName", newJString(circuitName))
  add(path_568333, "resourceGroupName", newJString(resourceGroupName))
  add(query_568334, "api-version", newJString(apiVersion))
  add(path_568333, "subscriptionId", newJString(subscriptionId))
  result = call_568332.call(path_568333, query_568334, nil, nil, nil)

var expressRouteCircuitPeeringsList* = Call_ExpressRouteCircuitPeeringsList_568324(
    name: "expressRouteCircuitPeeringsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings",
    validator: validate_ExpressRouteCircuitPeeringsList_568325, base: "",
    url: url_ExpressRouteCircuitPeeringsList_568326, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsCreateOrUpdate_568347 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCircuitPeeringsCreateOrUpdate_568349(protocol: Scheme;
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

proc validate_ExpressRouteCircuitPeeringsCreateOrUpdate_568348(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a peering in the specified express route circuits.
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
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_568350 = path.getOrDefault("circuitName")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "circuitName", valid_568350
  var valid_568351 = path.getOrDefault("resourceGroupName")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "resourceGroupName", valid_568351
  var valid_568352 = path.getOrDefault("peeringName")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "peeringName", valid_568352
  var valid_568353 = path.getOrDefault("subscriptionId")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "subscriptionId", valid_568353
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568354 = query.getOrDefault("api-version")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "api-version", valid_568354
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

proc call*(call_568356: Call_ExpressRouteCircuitPeeringsCreateOrUpdate_568347;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a peering in the specified express route circuits.
  ## 
  let valid = call_568356.validator(path, query, header, formData, body)
  let scheme = call_568356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568356.url(scheme.get, call_568356.host, call_568356.base,
                         call_568356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568356, url, valid)

proc call*(call_568357: Call_ExpressRouteCircuitPeeringsCreateOrUpdate_568347;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          peeringName: string; subscriptionId: string; peeringParameters: JsonNode): Recallable =
  ## expressRouteCircuitPeeringsCreateOrUpdate
  ## Creates or updates a peering in the specified express route circuits.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   peeringParameters: JObject (required)
  ##                    : Parameters supplied to the create or update express route circuit peering operation.
  var path_568358 = newJObject()
  var query_568359 = newJObject()
  var body_568360 = newJObject()
  add(path_568358, "circuitName", newJString(circuitName))
  add(path_568358, "resourceGroupName", newJString(resourceGroupName))
  add(query_568359, "api-version", newJString(apiVersion))
  add(path_568358, "peeringName", newJString(peeringName))
  add(path_568358, "subscriptionId", newJString(subscriptionId))
  if peeringParameters != nil:
    body_568360 = peeringParameters
  result = call_568357.call(path_568358, query_568359, nil, nil, body_568360)

var expressRouteCircuitPeeringsCreateOrUpdate* = Call_ExpressRouteCircuitPeeringsCreateOrUpdate_568347(
    name: "expressRouteCircuitPeeringsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCircuitPeeringsCreateOrUpdate_568348,
    base: "", url: url_ExpressRouteCircuitPeeringsCreateOrUpdate_568349,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsGet_568335 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCircuitPeeringsGet_568337(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitPeeringsGet_568336(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified peering for the express route circuit.
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
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_568338 = path.getOrDefault("circuitName")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "circuitName", valid_568338
  var valid_568339 = path.getOrDefault("resourceGroupName")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "resourceGroupName", valid_568339
  var valid_568340 = path.getOrDefault("peeringName")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "peeringName", valid_568340
  var valid_568341 = path.getOrDefault("subscriptionId")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "subscriptionId", valid_568341
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568342 = query.getOrDefault("api-version")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "api-version", valid_568342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568343: Call_ExpressRouteCircuitPeeringsGet_568335; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified peering for the express route circuit.
  ## 
  let valid = call_568343.validator(path, query, header, formData, body)
  let scheme = call_568343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568343.url(scheme.get, call_568343.host, call_568343.base,
                         call_568343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568343, url, valid)

proc call*(call_568344: Call_ExpressRouteCircuitPeeringsGet_568335;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          peeringName: string; subscriptionId: string): Recallable =
  ## expressRouteCircuitPeeringsGet
  ## Gets the specified peering for the express route circuit.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568345 = newJObject()
  var query_568346 = newJObject()
  add(path_568345, "circuitName", newJString(circuitName))
  add(path_568345, "resourceGroupName", newJString(resourceGroupName))
  add(query_568346, "api-version", newJString(apiVersion))
  add(path_568345, "peeringName", newJString(peeringName))
  add(path_568345, "subscriptionId", newJString(subscriptionId))
  result = call_568344.call(path_568345, query_568346, nil, nil, nil)

var expressRouteCircuitPeeringsGet* = Call_ExpressRouteCircuitPeeringsGet_568335(
    name: "expressRouteCircuitPeeringsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCircuitPeeringsGet_568336, base: "",
    url: url_ExpressRouteCircuitPeeringsGet_568337, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsDelete_568361 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCircuitPeeringsDelete_568363(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitPeeringsDelete_568362(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified peering from the specified express route circuit.
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
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_568364 = path.getOrDefault("circuitName")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "circuitName", valid_568364
  var valid_568365 = path.getOrDefault("resourceGroupName")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "resourceGroupName", valid_568365
  var valid_568366 = path.getOrDefault("peeringName")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "peeringName", valid_568366
  var valid_568367 = path.getOrDefault("subscriptionId")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "subscriptionId", valid_568367
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568368 = query.getOrDefault("api-version")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = nil)
  if valid_568368 != nil:
    section.add "api-version", valid_568368
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568369: Call_ExpressRouteCircuitPeeringsDelete_568361;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified peering from the specified express route circuit.
  ## 
  let valid = call_568369.validator(path, query, header, formData, body)
  let scheme = call_568369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568369.url(scheme.get, call_568369.host, call_568369.base,
                         call_568369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568369, url, valid)

proc call*(call_568370: Call_ExpressRouteCircuitPeeringsDelete_568361;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          peeringName: string; subscriptionId: string): Recallable =
  ## expressRouteCircuitPeeringsDelete
  ## Deletes the specified peering from the specified express route circuit.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568371 = newJObject()
  var query_568372 = newJObject()
  add(path_568371, "circuitName", newJString(circuitName))
  add(path_568371, "resourceGroupName", newJString(resourceGroupName))
  add(query_568372, "api-version", newJString(apiVersion))
  add(path_568371, "peeringName", newJString(peeringName))
  add(path_568371, "subscriptionId", newJString(subscriptionId))
  result = call_568370.call(path_568371, query_568372, nil, nil, nil)

var expressRouteCircuitPeeringsDelete* = Call_ExpressRouteCircuitPeeringsDelete_568361(
    name: "expressRouteCircuitPeeringsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCircuitPeeringsDelete_568362, base: "",
    url: url_ExpressRouteCircuitPeeringsDelete_568363, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsListArpTable_568373 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCircuitsListArpTable_568375(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsListArpTable_568374(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the currently advertised ARP table associated with the express route circuit in a resource group.
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
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   devicePath: JString (required)
  ##             : The path of the device.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_568376 = path.getOrDefault("circuitName")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "circuitName", valid_568376
  var valid_568377 = path.getOrDefault("resourceGroupName")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "resourceGroupName", valid_568377
  var valid_568378 = path.getOrDefault("peeringName")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "peeringName", valid_568378
  var valid_568379 = path.getOrDefault("subscriptionId")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "subscriptionId", valid_568379
  var valid_568380 = path.getOrDefault("devicePath")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "devicePath", valid_568380
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568381 = query.getOrDefault("api-version")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "api-version", valid_568381
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568382: Call_ExpressRouteCircuitsListArpTable_568373;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the currently advertised ARP table associated with the express route circuit in a resource group.
  ## 
  let valid = call_568382.validator(path, query, header, formData, body)
  let scheme = call_568382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568382.url(scheme.get, call_568382.host, call_568382.base,
                         call_568382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568382, url, valid)

proc call*(call_568383: Call_ExpressRouteCircuitsListArpTable_568373;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          peeringName: string; subscriptionId: string; devicePath: string): Recallable =
  ## expressRouteCircuitsListArpTable
  ## Gets the currently advertised ARP table associated with the express route circuit in a resource group.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   devicePath: string (required)
  ##             : The path of the device.
  var path_568384 = newJObject()
  var query_568385 = newJObject()
  add(path_568384, "circuitName", newJString(circuitName))
  add(path_568384, "resourceGroupName", newJString(resourceGroupName))
  add(query_568385, "api-version", newJString(apiVersion))
  add(path_568384, "peeringName", newJString(peeringName))
  add(path_568384, "subscriptionId", newJString(subscriptionId))
  add(path_568384, "devicePath", newJString(devicePath))
  result = call_568383.call(path_568384, query_568385, nil, nil, nil)

var expressRouteCircuitsListArpTable* = Call_ExpressRouteCircuitsListArpTable_568373(
    name: "expressRouteCircuitsListArpTable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/arpTables/{devicePath}",
    validator: validate_ExpressRouteCircuitsListArpTable_568374, base: "",
    url: url_ExpressRouteCircuitsListArpTable_568375, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitConnectionsList_568386 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCircuitConnectionsList_568388(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitConnectionsList_568387(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all global reach connections associated with a private peering in an express route circuit.
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
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_568389 = path.getOrDefault("circuitName")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "circuitName", valid_568389
  var valid_568390 = path.getOrDefault("resourceGroupName")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "resourceGroupName", valid_568390
  var valid_568391 = path.getOrDefault("peeringName")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "peeringName", valid_568391
  var valid_568392 = path.getOrDefault("subscriptionId")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "subscriptionId", valid_568392
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568393 = query.getOrDefault("api-version")
  valid_568393 = validateParameter(valid_568393, JString, required = true,
                                 default = nil)
  if valid_568393 != nil:
    section.add "api-version", valid_568393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568394: Call_ExpressRouteCircuitConnectionsList_568386;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all global reach connections associated with a private peering in an express route circuit.
  ## 
  let valid = call_568394.validator(path, query, header, formData, body)
  let scheme = call_568394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568394.url(scheme.get, call_568394.host, call_568394.base,
                         call_568394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568394, url, valid)

proc call*(call_568395: Call_ExpressRouteCircuitConnectionsList_568386;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          peeringName: string; subscriptionId: string): Recallable =
  ## expressRouteCircuitConnectionsList
  ## Gets all global reach connections associated with a private peering in an express route circuit.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568396 = newJObject()
  var query_568397 = newJObject()
  add(path_568396, "circuitName", newJString(circuitName))
  add(path_568396, "resourceGroupName", newJString(resourceGroupName))
  add(query_568397, "api-version", newJString(apiVersion))
  add(path_568396, "peeringName", newJString(peeringName))
  add(path_568396, "subscriptionId", newJString(subscriptionId))
  result = call_568395.call(path_568396, query_568397, nil, nil, nil)

var expressRouteCircuitConnectionsList* = Call_ExpressRouteCircuitConnectionsList_568386(
    name: "expressRouteCircuitConnectionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/connections",
    validator: validate_ExpressRouteCircuitConnectionsList_568387, base: "",
    url: url_ExpressRouteCircuitConnectionsList_568388, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitConnectionsCreateOrUpdate_568411 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCircuitConnectionsCreateOrUpdate_568413(protocol: Scheme;
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

proc validate_ExpressRouteCircuitConnectionsCreateOrUpdate_568412(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a Express Route Circuit Connection in the specified express route circuits.
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
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: JString (required)
  ##                 : The name of the express route circuit connection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_568414 = path.getOrDefault("circuitName")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "circuitName", valid_568414
  var valid_568415 = path.getOrDefault("resourceGroupName")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "resourceGroupName", valid_568415
  var valid_568416 = path.getOrDefault("peeringName")
  valid_568416 = validateParameter(valid_568416, JString, required = true,
                                 default = nil)
  if valid_568416 != nil:
    section.add "peeringName", valid_568416
  var valid_568417 = path.getOrDefault("subscriptionId")
  valid_568417 = validateParameter(valid_568417, JString, required = true,
                                 default = nil)
  if valid_568417 != nil:
    section.add "subscriptionId", valid_568417
  var valid_568418 = path.getOrDefault("connectionName")
  valid_568418 = validateParameter(valid_568418, JString, required = true,
                                 default = nil)
  if valid_568418 != nil:
    section.add "connectionName", valid_568418
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568419 = query.getOrDefault("api-version")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "api-version", valid_568419
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

proc call*(call_568421: Call_ExpressRouteCircuitConnectionsCreateOrUpdate_568411;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a Express Route Circuit Connection in the specified express route circuits.
  ## 
  let valid = call_568421.validator(path, query, header, formData, body)
  let scheme = call_568421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568421.url(scheme.get, call_568421.host, call_568421.base,
                         call_568421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568421, url, valid)

proc call*(call_568422: Call_ExpressRouteCircuitConnectionsCreateOrUpdate_568411;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          peeringName: string; expressRouteCircuitConnectionParameters: JsonNode;
          subscriptionId: string; connectionName: string): Recallable =
  ## expressRouteCircuitConnectionsCreateOrUpdate
  ## Creates or updates a Express Route Circuit Connection in the specified express route circuits.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   expressRouteCircuitConnectionParameters: JObject (required)
  ##                                          : Parameters supplied to the create or update express route circuit connection operation.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: string (required)
  ##                 : The name of the express route circuit connection.
  var path_568423 = newJObject()
  var query_568424 = newJObject()
  var body_568425 = newJObject()
  add(path_568423, "circuitName", newJString(circuitName))
  add(path_568423, "resourceGroupName", newJString(resourceGroupName))
  add(query_568424, "api-version", newJString(apiVersion))
  add(path_568423, "peeringName", newJString(peeringName))
  if expressRouteCircuitConnectionParameters != nil:
    body_568425 = expressRouteCircuitConnectionParameters
  add(path_568423, "subscriptionId", newJString(subscriptionId))
  add(path_568423, "connectionName", newJString(connectionName))
  result = call_568422.call(path_568423, query_568424, nil, nil, body_568425)

var expressRouteCircuitConnectionsCreateOrUpdate* = Call_ExpressRouteCircuitConnectionsCreateOrUpdate_568411(
    name: "expressRouteCircuitConnectionsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/connections/{connectionName}",
    validator: validate_ExpressRouteCircuitConnectionsCreateOrUpdate_568412,
    base: "", url: url_ExpressRouteCircuitConnectionsCreateOrUpdate_568413,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitConnectionsGet_568398 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCircuitConnectionsGet_568400(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitConnectionsGet_568399(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified Express Route Circuit Connection from the specified express route circuit.
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
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: JString (required)
  ##                 : The name of the express route circuit connection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_568401 = path.getOrDefault("circuitName")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "circuitName", valid_568401
  var valid_568402 = path.getOrDefault("resourceGroupName")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "resourceGroupName", valid_568402
  var valid_568403 = path.getOrDefault("peeringName")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = nil)
  if valid_568403 != nil:
    section.add "peeringName", valid_568403
  var valid_568404 = path.getOrDefault("subscriptionId")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "subscriptionId", valid_568404
  var valid_568405 = path.getOrDefault("connectionName")
  valid_568405 = validateParameter(valid_568405, JString, required = true,
                                 default = nil)
  if valid_568405 != nil:
    section.add "connectionName", valid_568405
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568406 = query.getOrDefault("api-version")
  valid_568406 = validateParameter(valid_568406, JString, required = true,
                                 default = nil)
  if valid_568406 != nil:
    section.add "api-version", valid_568406
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568407: Call_ExpressRouteCircuitConnectionsGet_568398;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified Express Route Circuit Connection from the specified express route circuit.
  ## 
  let valid = call_568407.validator(path, query, header, formData, body)
  let scheme = call_568407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568407.url(scheme.get, call_568407.host, call_568407.base,
                         call_568407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568407, url, valid)

proc call*(call_568408: Call_ExpressRouteCircuitConnectionsGet_568398;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          peeringName: string; subscriptionId: string; connectionName: string): Recallable =
  ## expressRouteCircuitConnectionsGet
  ## Gets the specified Express Route Circuit Connection from the specified express route circuit.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: string (required)
  ##                 : The name of the express route circuit connection.
  var path_568409 = newJObject()
  var query_568410 = newJObject()
  add(path_568409, "circuitName", newJString(circuitName))
  add(path_568409, "resourceGroupName", newJString(resourceGroupName))
  add(query_568410, "api-version", newJString(apiVersion))
  add(path_568409, "peeringName", newJString(peeringName))
  add(path_568409, "subscriptionId", newJString(subscriptionId))
  add(path_568409, "connectionName", newJString(connectionName))
  result = call_568408.call(path_568409, query_568410, nil, nil, nil)

var expressRouteCircuitConnectionsGet* = Call_ExpressRouteCircuitConnectionsGet_568398(
    name: "expressRouteCircuitConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/connections/{connectionName}",
    validator: validate_ExpressRouteCircuitConnectionsGet_568399, base: "",
    url: url_ExpressRouteCircuitConnectionsGet_568400, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitConnectionsDelete_568426 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCircuitConnectionsDelete_568428(protocol: Scheme;
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

proc validate_ExpressRouteCircuitConnectionsDelete_568427(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified Express Route Circuit Connection from the specified express route circuit.
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
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: JString (required)
  ##                 : The name of the express route circuit connection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_568429 = path.getOrDefault("circuitName")
  valid_568429 = validateParameter(valid_568429, JString, required = true,
                                 default = nil)
  if valid_568429 != nil:
    section.add "circuitName", valid_568429
  var valid_568430 = path.getOrDefault("resourceGroupName")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "resourceGroupName", valid_568430
  var valid_568431 = path.getOrDefault("peeringName")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "peeringName", valid_568431
  var valid_568432 = path.getOrDefault("subscriptionId")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "subscriptionId", valid_568432
  var valid_568433 = path.getOrDefault("connectionName")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "connectionName", valid_568433
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568434 = query.getOrDefault("api-version")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "api-version", valid_568434
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568435: Call_ExpressRouteCircuitConnectionsDelete_568426;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified Express Route Circuit Connection from the specified express route circuit.
  ## 
  let valid = call_568435.validator(path, query, header, formData, body)
  let scheme = call_568435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568435.url(scheme.get, call_568435.host, call_568435.base,
                         call_568435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568435, url, valid)

proc call*(call_568436: Call_ExpressRouteCircuitConnectionsDelete_568426;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          peeringName: string; subscriptionId: string; connectionName: string): Recallable =
  ## expressRouteCircuitConnectionsDelete
  ## Deletes the specified Express Route Circuit Connection from the specified express route circuit.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: string (required)
  ##                 : The name of the express route circuit connection.
  var path_568437 = newJObject()
  var query_568438 = newJObject()
  add(path_568437, "circuitName", newJString(circuitName))
  add(path_568437, "resourceGroupName", newJString(resourceGroupName))
  add(query_568438, "api-version", newJString(apiVersion))
  add(path_568437, "peeringName", newJString(peeringName))
  add(path_568437, "subscriptionId", newJString(subscriptionId))
  add(path_568437, "connectionName", newJString(connectionName))
  result = call_568436.call(path_568437, query_568438, nil, nil, nil)

var expressRouteCircuitConnectionsDelete* = Call_ExpressRouteCircuitConnectionsDelete_568426(
    name: "expressRouteCircuitConnectionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/connections/{connectionName}",
    validator: validate_ExpressRouteCircuitConnectionsDelete_568427, base: "",
    url: url_ExpressRouteCircuitConnectionsDelete_568428, schemes: {Scheme.Https})
type
  Call_PeerExpressRouteCircuitConnectionsList_568439 = ref object of OpenApiRestCall_567657
proc url_PeerExpressRouteCircuitConnectionsList_568441(protocol: Scheme;
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

proc validate_PeerExpressRouteCircuitConnectionsList_568440(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all global reach peer connections associated with a private peering in an express route circuit.
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
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_568442 = path.getOrDefault("circuitName")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "circuitName", valid_568442
  var valid_568443 = path.getOrDefault("resourceGroupName")
  valid_568443 = validateParameter(valid_568443, JString, required = true,
                                 default = nil)
  if valid_568443 != nil:
    section.add "resourceGroupName", valid_568443
  var valid_568444 = path.getOrDefault("peeringName")
  valid_568444 = validateParameter(valid_568444, JString, required = true,
                                 default = nil)
  if valid_568444 != nil:
    section.add "peeringName", valid_568444
  var valid_568445 = path.getOrDefault("subscriptionId")
  valid_568445 = validateParameter(valid_568445, JString, required = true,
                                 default = nil)
  if valid_568445 != nil:
    section.add "subscriptionId", valid_568445
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568446 = query.getOrDefault("api-version")
  valid_568446 = validateParameter(valid_568446, JString, required = true,
                                 default = nil)
  if valid_568446 != nil:
    section.add "api-version", valid_568446
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568447: Call_PeerExpressRouteCircuitConnectionsList_568439;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all global reach peer connections associated with a private peering in an express route circuit.
  ## 
  let valid = call_568447.validator(path, query, header, formData, body)
  let scheme = call_568447.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568447.url(scheme.get, call_568447.host, call_568447.base,
                         call_568447.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568447, url, valid)

proc call*(call_568448: Call_PeerExpressRouteCircuitConnectionsList_568439;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          peeringName: string; subscriptionId: string): Recallable =
  ## peerExpressRouteCircuitConnectionsList
  ## Gets all global reach peer connections associated with a private peering in an express route circuit.
  ##   circuitName: string (required)
  ##              : The name of the circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568449 = newJObject()
  var query_568450 = newJObject()
  add(path_568449, "circuitName", newJString(circuitName))
  add(path_568449, "resourceGroupName", newJString(resourceGroupName))
  add(query_568450, "api-version", newJString(apiVersion))
  add(path_568449, "peeringName", newJString(peeringName))
  add(path_568449, "subscriptionId", newJString(subscriptionId))
  result = call_568448.call(path_568449, query_568450, nil, nil, nil)

var peerExpressRouteCircuitConnectionsList* = Call_PeerExpressRouteCircuitConnectionsList_568439(
    name: "peerExpressRouteCircuitConnectionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/peerConnections",
    validator: validate_PeerExpressRouteCircuitConnectionsList_568440, base: "",
    url: url_PeerExpressRouteCircuitConnectionsList_568441,
    schemes: {Scheme.Https})
type
  Call_PeerExpressRouteCircuitConnectionsGet_568451 = ref object of OpenApiRestCall_567657
proc url_PeerExpressRouteCircuitConnectionsGet_568453(protocol: Scheme;
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

proc validate_PeerExpressRouteCircuitConnectionsGet_568452(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified Peer Express Route Circuit Connection from the specified express route circuit.
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
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: JString (required)
  ##                 : The name of the peer express route circuit connection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_568454 = path.getOrDefault("circuitName")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = nil)
  if valid_568454 != nil:
    section.add "circuitName", valid_568454
  var valid_568455 = path.getOrDefault("resourceGroupName")
  valid_568455 = validateParameter(valid_568455, JString, required = true,
                                 default = nil)
  if valid_568455 != nil:
    section.add "resourceGroupName", valid_568455
  var valid_568456 = path.getOrDefault("peeringName")
  valid_568456 = validateParameter(valid_568456, JString, required = true,
                                 default = nil)
  if valid_568456 != nil:
    section.add "peeringName", valid_568456
  var valid_568457 = path.getOrDefault("subscriptionId")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = nil)
  if valid_568457 != nil:
    section.add "subscriptionId", valid_568457
  var valid_568458 = path.getOrDefault("connectionName")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "connectionName", valid_568458
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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

proc call*(call_568460: Call_PeerExpressRouteCircuitConnectionsGet_568451;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified Peer Express Route Circuit Connection from the specified express route circuit.
  ## 
  let valid = call_568460.validator(path, query, header, formData, body)
  let scheme = call_568460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568460.url(scheme.get, call_568460.host, call_568460.base,
                         call_568460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568460, url, valid)

proc call*(call_568461: Call_PeerExpressRouteCircuitConnectionsGet_568451;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          peeringName: string; subscriptionId: string; connectionName: string): Recallable =
  ## peerExpressRouteCircuitConnectionsGet
  ## Gets the specified Peer Express Route Circuit Connection from the specified express route circuit.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectionName: string (required)
  ##                 : The name of the peer express route circuit connection.
  var path_568462 = newJObject()
  var query_568463 = newJObject()
  add(path_568462, "circuitName", newJString(circuitName))
  add(path_568462, "resourceGroupName", newJString(resourceGroupName))
  add(query_568463, "api-version", newJString(apiVersion))
  add(path_568462, "peeringName", newJString(peeringName))
  add(path_568462, "subscriptionId", newJString(subscriptionId))
  add(path_568462, "connectionName", newJString(connectionName))
  result = call_568461.call(path_568462, query_568463, nil, nil, nil)

var peerExpressRouteCircuitConnectionsGet* = Call_PeerExpressRouteCircuitConnectionsGet_568451(
    name: "peerExpressRouteCircuitConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/peerConnections/{connectionName}",
    validator: validate_PeerExpressRouteCircuitConnectionsGet_568452, base: "",
    url: url_PeerExpressRouteCircuitConnectionsGet_568453, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsListRoutesTable_568464 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCircuitsListRoutesTable_568466(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsListRoutesTable_568465(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the currently advertised routes table associated with the express route circuit in a resource group.
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
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   devicePath: JString (required)
  ##             : The path of the device.
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
  var valid_568469 = path.getOrDefault("peeringName")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "peeringName", valid_568469
  var valid_568470 = path.getOrDefault("subscriptionId")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = nil)
  if valid_568470 != nil:
    section.add "subscriptionId", valid_568470
  var valid_568471 = path.getOrDefault("devicePath")
  valid_568471 = validateParameter(valid_568471, JString, required = true,
                                 default = nil)
  if valid_568471 != nil:
    section.add "devicePath", valid_568471
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568472 = query.getOrDefault("api-version")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "api-version", valid_568472
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568473: Call_ExpressRouteCircuitsListRoutesTable_568464;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the currently advertised routes table associated with the express route circuit in a resource group.
  ## 
  let valid = call_568473.validator(path, query, header, formData, body)
  let scheme = call_568473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568473.url(scheme.get, call_568473.host, call_568473.base,
                         call_568473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568473, url, valid)

proc call*(call_568474: Call_ExpressRouteCircuitsListRoutesTable_568464;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          peeringName: string; subscriptionId: string; devicePath: string): Recallable =
  ## expressRouteCircuitsListRoutesTable
  ## Gets the currently advertised routes table associated with the express route circuit in a resource group.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   devicePath: string (required)
  ##             : The path of the device.
  var path_568475 = newJObject()
  var query_568476 = newJObject()
  add(path_568475, "circuitName", newJString(circuitName))
  add(path_568475, "resourceGroupName", newJString(resourceGroupName))
  add(query_568476, "api-version", newJString(apiVersion))
  add(path_568475, "peeringName", newJString(peeringName))
  add(path_568475, "subscriptionId", newJString(subscriptionId))
  add(path_568475, "devicePath", newJString(devicePath))
  result = call_568474.call(path_568475, query_568476, nil, nil, nil)

var expressRouteCircuitsListRoutesTable* = Call_ExpressRouteCircuitsListRoutesTable_568464(
    name: "expressRouteCircuitsListRoutesTable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/routeTables/{devicePath}",
    validator: validate_ExpressRouteCircuitsListRoutesTable_568465, base: "",
    url: url_ExpressRouteCircuitsListRoutesTable_568466, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsListRoutesTableSummary_568477 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCircuitsListRoutesTableSummary_568479(protocol: Scheme;
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

proc validate_ExpressRouteCircuitsListRoutesTableSummary_568478(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the currently advertised routes table summary associated with the express route circuit in a resource group.
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
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   devicePath: JString (required)
  ##             : The path of the device.
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
  var valid_568482 = path.getOrDefault("peeringName")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = nil)
  if valid_568482 != nil:
    section.add "peeringName", valid_568482
  var valid_568483 = path.getOrDefault("subscriptionId")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = nil)
  if valid_568483 != nil:
    section.add "subscriptionId", valid_568483
  var valid_568484 = path.getOrDefault("devicePath")
  valid_568484 = validateParameter(valid_568484, JString, required = true,
                                 default = nil)
  if valid_568484 != nil:
    section.add "devicePath", valid_568484
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568485 = query.getOrDefault("api-version")
  valid_568485 = validateParameter(valid_568485, JString, required = true,
                                 default = nil)
  if valid_568485 != nil:
    section.add "api-version", valid_568485
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568486: Call_ExpressRouteCircuitsListRoutesTableSummary_568477;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the currently advertised routes table summary associated with the express route circuit in a resource group.
  ## 
  let valid = call_568486.validator(path, query, header, formData, body)
  let scheme = call_568486.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568486.url(scheme.get, call_568486.host, call_568486.base,
                         call_568486.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568486, url, valid)

proc call*(call_568487: Call_ExpressRouteCircuitsListRoutesTableSummary_568477;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          peeringName: string; subscriptionId: string; devicePath: string): Recallable =
  ## expressRouteCircuitsListRoutesTableSummary
  ## Gets the currently advertised routes table summary associated with the express route circuit in a resource group.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   devicePath: string (required)
  ##             : The path of the device.
  var path_568488 = newJObject()
  var query_568489 = newJObject()
  add(path_568488, "circuitName", newJString(circuitName))
  add(path_568488, "resourceGroupName", newJString(resourceGroupName))
  add(query_568489, "api-version", newJString(apiVersion))
  add(path_568488, "peeringName", newJString(peeringName))
  add(path_568488, "subscriptionId", newJString(subscriptionId))
  add(path_568488, "devicePath", newJString(devicePath))
  result = call_568487.call(path_568488, query_568489, nil, nil, nil)

var expressRouteCircuitsListRoutesTableSummary* = Call_ExpressRouteCircuitsListRoutesTableSummary_568477(
    name: "expressRouteCircuitsListRoutesTableSummary", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/routeTablesSummary/{devicePath}",
    validator: validate_ExpressRouteCircuitsListRoutesTableSummary_568478,
    base: "", url: url_ExpressRouteCircuitsListRoutesTableSummary_568479,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsGetPeeringStats_568490 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCircuitsGetPeeringStats_568492(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsGetPeeringStats_568491(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all stats from an express route circuit in a resource group.
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
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_568493 = path.getOrDefault("circuitName")
  valid_568493 = validateParameter(valid_568493, JString, required = true,
                                 default = nil)
  if valid_568493 != nil:
    section.add "circuitName", valid_568493
  var valid_568494 = path.getOrDefault("resourceGroupName")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = nil)
  if valid_568494 != nil:
    section.add "resourceGroupName", valid_568494
  var valid_568495 = path.getOrDefault("peeringName")
  valid_568495 = validateParameter(valid_568495, JString, required = true,
                                 default = nil)
  if valid_568495 != nil:
    section.add "peeringName", valid_568495
  var valid_568496 = path.getOrDefault("subscriptionId")
  valid_568496 = validateParameter(valid_568496, JString, required = true,
                                 default = nil)
  if valid_568496 != nil:
    section.add "subscriptionId", valid_568496
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568497 = query.getOrDefault("api-version")
  valid_568497 = validateParameter(valid_568497, JString, required = true,
                                 default = nil)
  if valid_568497 != nil:
    section.add "api-version", valid_568497
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568498: Call_ExpressRouteCircuitsGetPeeringStats_568490;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all stats from an express route circuit in a resource group.
  ## 
  let valid = call_568498.validator(path, query, header, formData, body)
  let scheme = call_568498.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568498.url(scheme.get, call_568498.host, call_568498.base,
                         call_568498.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568498, url, valid)

proc call*(call_568499: Call_ExpressRouteCircuitsGetPeeringStats_568490;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          peeringName: string; subscriptionId: string): Recallable =
  ## expressRouteCircuitsGetPeeringStats
  ## Gets all stats from an express route circuit in a resource group.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568500 = newJObject()
  var query_568501 = newJObject()
  add(path_568500, "circuitName", newJString(circuitName))
  add(path_568500, "resourceGroupName", newJString(resourceGroupName))
  add(query_568501, "api-version", newJString(apiVersion))
  add(path_568500, "peeringName", newJString(peeringName))
  add(path_568500, "subscriptionId", newJString(subscriptionId))
  result = call_568499.call(path_568500, query_568501, nil, nil, nil)

var expressRouteCircuitsGetPeeringStats* = Call_ExpressRouteCircuitsGetPeeringStats_568490(
    name: "expressRouteCircuitsGetPeeringStats", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/stats",
    validator: validate_ExpressRouteCircuitsGetPeeringStats_568491, base: "",
    url: url_ExpressRouteCircuitsGetPeeringStats_568492, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsGetStats_568502 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCircuitsGetStats_568504(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsGetStats_568503(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the stats from an express route circuit in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   circuitName: JString (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_568505 = path.getOrDefault("circuitName")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "circuitName", valid_568505
  var valid_568506 = path.getOrDefault("resourceGroupName")
  valid_568506 = validateParameter(valid_568506, JString, required = true,
                                 default = nil)
  if valid_568506 != nil:
    section.add "resourceGroupName", valid_568506
  var valid_568507 = path.getOrDefault("subscriptionId")
  valid_568507 = validateParameter(valid_568507, JString, required = true,
                                 default = nil)
  if valid_568507 != nil:
    section.add "subscriptionId", valid_568507
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568508 = query.getOrDefault("api-version")
  valid_568508 = validateParameter(valid_568508, JString, required = true,
                                 default = nil)
  if valid_568508 != nil:
    section.add "api-version", valid_568508
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568509: Call_ExpressRouteCircuitsGetStats_568502; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the stats from an express route circuit in a resource group.
  ## 
  let valid = call_568509.validator(path, query, header, formData, body)
  let scheme = call_568509.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568509.url(scheme.get, call_568509.host, call_568509.base,
                         call_568509.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568509, url, valid)

proc call*(call_568510: Call_ExpressRouteCircuitsGetStats_568502;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## expressRouteCircuitsGetStats
  ## Gets all the stats from an express route circuit in a resource group.
  ##   circuitName: string (required)
  ##              : The name of the express route circuit.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568511 = newJObject()
  var query_568512 = newJObject()
  add(path_568511, "circuitName", newJString(circuitName))
  add(path_568511, "resourceGroupName", newJString(resourceGroupName))
  add(query_568512, "api-version", newJString(apiVersion))
  add(path_568511, "subscriptionId", newJString(subscriptionId))
  result = call_568510.call(path_568511, query_568512, nil, nil, nil)

var expressRouteCircuitsGetStats* = Call_ExpressRouteCircuitsGetStats_568502(
    name: "expressRouteCircuitsGetStats", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/stats",
    validator: validate_ExpressRouteCircuitsGetStats_568503, base: "",
    url: url_ExpressRouteCircuitsGetStats_568504, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
