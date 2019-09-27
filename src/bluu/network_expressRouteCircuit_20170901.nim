
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2017-09-01
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
  macServiceName = "network-expressRouteCircuit"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ExpressRouteCircuitsListAll_593646 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCircuitsListAll_593648(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsListAll_593647(path: JsonNode; query: JsonNode;
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

proc call*(call_593845: Call_ExpressRouteCircuitsListAll_593646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the express route circuits in a subscription.
  ## 
  let valid = call_593845.validator(path, query, header, formData, body)
  let scheme = call_593845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593845.url(scheme.get, call_593845.host, call_593845.base,
                         call_593845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593845, url, valid)

proc call*(call_593916: Call_ExpressRouteCircuitsListAll_593646;
          apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteCircuitsListAll
  ## Gets all the express route circuits in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593917 = newJObject()
  var query_593919 = newJObject()
  add(query_593919, "api-version", newJString(apiVersion))
  add(path_593917, "subscriptionId", newJString(subscriptionId))
  result = call_593916.call(path_593917, query_593919, nil, nil, nil)

var expressRouteCircuitsListAll* = Call_ExpressRouteCircuitsListAll_593646(
    name: "expressRouteCircuitsListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/expressRouteCircuits",
    validator: validate_ExpressRouteCircuitsListAll_593647, base: "",
    url: url_ExpressRouteCircuitsListAll_593648, schemes: {Scheme.Https})
type
  Call_ExpressRouteServiceProvidersList_593958 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteServiceProvidersList_593960(protocol: Scheme; host: string;
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

proc validate_ExpressRouteServiceProvidersList_593959(path: JsonNode;
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

proc call*(call_593963: Call_ExpressRouteServiceProvidersList_593958;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the available express route service providers.
  ## 
  let valid = call_593963.validator(path, query, header, formData, body)
  let scheme = call_593963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593963.url(scheme.get, call_593963.host, call_593963.base,
                         call_593963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593963, url, valid)

proc call*(call_593964: Call_ExpressRouteServiceProvidersList_593958;
          apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteServiceProvidersList
  ## Gets all the available express route service providers.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593965 = newJObject()
  var query_593966 = newJObject()
  add(query_593966, "api-version", newJString(apiVersion))
  add(path_593965, "subscriptionId", newJString(subscriptionId))
  result = call_593964.call(path_593965, query_593966, nil, nil, nil)

var expressRouteServiceProvidersList* = Call_ExpressRouteServiceProvidersList_593958(
    name: "expressRouteServiceProvidersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/expressRouteServiceProviders",
    validator: validate_ExpressRouteServiceProvidersList_593959, base: "",
    url: url_ExpressRouteServiceProvidersList_593960, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsList_593967 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCircuitsList_593969(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsList_593968(path: JsonNode; query: JsonNode;
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
  var valid_593970 = path.getOrDefault("resourceGroupName")
  valid_593970 = validateParameter(valid_593970, JString, required = true,
                                 default = nil)
  if valid_593970 != nil:
    section.add "resourceGroupName", valid_593970
  var valid_593971 = path.getOrDefault("subscriptionId")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = nil)
  if valid_593971 != nil:
    section.add "subscriptionId", valid_593971
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593972 = query.getOrDefault("api-version")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "api-version", valid_593972
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593973: Call_ExpressRouteCircuitsList_593967; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the express route circuits in a resource group.
  ## 
  let valid = call_593973.validator(path, query, header, formData, body)
  let scheme = call_593973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593973.url(scheme.get, call_593973.host, call_593973.base,
                         call_593973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593973, url, valid)

proc call*(call_593974: Call_ExpressRouteCircuitsList_593967;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteCircuitsList
  ## Gets all the express route circuits in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593975 = newJObject()
  var query_593976 = newJObject()
  add(path_593975, "resourceGroupName", newJString(resourceGroupName))
  add(query_593976, "api-version", newJString(apiVersion))
  add(path_593975, "subscriptionId", newJString(subscriptionId))
  result = call_593974.call(path_593975, query_593976, nil, nil, nil)

var expressRouteCircuitsList* = Call_ExpressRouteCircuitsList_593967(
    name: "expressRouteCircuitsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits",
    validator: validate_ExpressRouteCircuitsList_593968, base: "",
    url: url_ExpressRouteCircuitsList_593969, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsCreateOrUpdate_593988 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCircuitsCreateOrUpdate_593990(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsCreateOrUpdate_593989(path: JsonNode;
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
  var valid_594008 = path.getOrDefault("circuitName")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "circuitName", valid_594008
  var valid_594009 = path.getOrDefault("resourceGroupName")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "resourceGroupName", valid_594009
  var valid_594010 = path.getOrDefault("subscriptionId")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "subscriptionId", valid_594010
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594011 = query.getOrDefault("api-version")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "api-version", valid_594011
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

proc call*(call_594013: Call_ExpressRouteCircuitsCreateOrUpdate_593988;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an express route circuit.
  ## 
  let valid = call_594013.validator(path, query, header, formData, body)
  let scheme = call_594013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594013.url(scheme.get, call_594013.host, call_594013.base,
                         call_594013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594013, url, valid)

proc call*(call_594014: Call_ExpressRouteCircuitsCreateOrUpdate_593988;
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
  var path_594015 = newJObject()
  var query_594016 = newJObject()
  var body_594017 = newJObject()
  add(path_594015, "circuitName", newJString(circuitName))
  add(path_594015, "resourceGroupName", newJString(resourceGroupName))
  add(query_594016, "api-version", newJString(apiVersion))
  add(path_594015, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594017 = parameters
  result = call_594014.call(path_594015, query_594016, nil, nil, body_594017)

var expressRouteCircuitsCreateOrUpdate* = Call_ExpressRouteCircuitsCreateOrUpdate_593988(
    name: "expressRouteCircuitsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}",
    validator: validate_ExpressRouteCircuitsCreateOrUpdate_593989, base: "",
    url: url_ExpressRouteCircuitsCreateOrUpdate_593990, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsGet_593977 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCircuitsGet_593979(protocol: Scheme; host: string; base: string;
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

proc validate_ExpressRouteCircuitsGet_593978(path: JsonNode; query: JsonNode;
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
  var valid_593980 = path.getOrDefault("circuitName")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "circuitName", valid_593980
  var valid_593981 = path.getOrDefault("resourceGroupName")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "resourceGroupName", valid_593981
  var valid_593982 = path.getOrDefault("subscriptionId")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "subscriptionId", valid_593982
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593983 = query.getOrDefault("api-version")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "api-version", valid_593983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593984: Call_ExpressRouteCircuitsGet_593977; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified express route circuit.
  ## 
  let valid = call_593984.validator(path, query, header, formData, body)
  let scheme = call_593984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593984.url(scheme.get, call_593984.host, call_593984.base,
                         call_593984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593984, url, valid)

proc call*(call_593985: Call_ExpressRouteCircuitsGet_593977; circuitName: string;
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
  var path_593986 = newJObject()
  var query_593987 = newJObject()
  add(path_593986, "circuitName", newJString(circuitName))
  add(path_593986, "resourceGroupName", newJString(resourceGroupName))
  add(query_593987, "api-version", newJString(apiVersion))
  add(path_593986, "subscriptionId", newJString(subscriptionId))
  result = call_593985.call(path_593986, query_593987, nil, nil, nil)

var expressRouteCircuitsGet* = Call_ExpressRouteCircuitsGet_593977(
    name: "expressRouteCircuitsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}",
    validator: validate_ExpressRouteCircuitsGet_593978, base: "",
    url: url_ExpressRouteCircuitsGet_593979, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsUpdateTags_594029 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCircuitsUpdateTags_594031(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsUpdateTags_594030(path: JsonNode;
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
  var valid_594032 = path.getOrDefault("circuitName")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "circuitName", valid_594032
  var valid_594033 = path.getOrDefault("resourceGroupName")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "resourceGroupName", valid_594033
  var valid_594034 = path.getOrDefault("subscriptionId")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "subscriptionId", valid_594034
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update express route circuit tags.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594037: Call_ExpressRouteCircuitsUpdateTags_594029; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an express route circuit tags.
  ## 
  let valid = call_594037.validator(path, query, header, formData, body)
  let scheme = call_594037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594037.url(scheme.get, call_594037.host, call_594037.base,
                         call_594037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594037, url, valid)

proc call*(call_594038: Call_ExpressRouteCircuitsUpdateTags_594029;
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
  var path_594039 = newJObject()
  var query_594040 = newJObject()
  var body_594041 = newJObject()
  add(path_594039, "circuitName", newJString(circuitName))
  add(path_594039, "resourceGroupName", newJString(resourceGroupName))
  add(query_594040, "api-version", newJString(apiVersion))
  add(path_594039, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594041 = parameters
  result = call_594038.call(path_594039, query_594040, nil, nil, body_594041)

var expressRouteCircuitsUpdateTags* = Call_ExpressRouteCircuitsUpdateTags_594029(
    name: "expressRouteCircuitsUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}",
    validator: validate_ExpressRouteCircuitsUpdateTags_594030, base: "",
    url: url_ExpressRouteCircuitsUpdateTags_594031, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsDelete_594018 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCircuitsDelete_594020(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsDelete_594019(path: JsonNode; query: JsonNode;
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
  var valid_594021 = path.getOrDefault("circuitName")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "circuitName", valid_594021
  var valid_594022 = path.getOrDefault("resourceGroupName")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "resourceGroupName", valid_594022
  var valid_594023 = path.getOrDefault("subscriptionId")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "subscriptionId", valid_594023
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594024 = query.getOrDefault("api-version")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "api-version", valid_594024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594025: Call_ExpressRouteCircuitsDelete_594018; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified express route circuit.
  ## 
  let valid = call_594025.validator(path, query, header, formData, body)
  let scheme = call_594025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594025.url(scheme.get, call_594025.host, call_594025.base,
                         call_594025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594025, url, valid)

proc call*(call_594026: Call_ExpressRouteCircuitsDelete_594018;
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
  var path_594027 = newJObject()
  var query_594028 = newJObject()
  add(path_594027, "circuitName", newJString(circuitName))
  add(path_594027, "resourceGroupName", newJString(resourceGroupName))
  add(query_594028, "api-version", newJString(apiVersion))
  add(path_594027, "subscriptionId", newJString(subscriptionId))
  result = call_594026.call(path_594027, query_594028, nil, nil, nil)

var expressRouteCircuitsDelete* = Call_ExpressRouteCircuitsDelete_594018(
    name: "expressRouteCircuitsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}",
    validator: validate_ExpressRouteCircuitsDelete_594019, base: "",
    url: url_ExpressRouteCircuitsDelete_594020, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsList_594042 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCircuitAuthorizationsList_594044(protocol: Scheme;
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

proc validate_ExpressRouteCircuitAuthorizationsList_594043(path: JsonNode;
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
  var valid_594045 = path.getOrDefault("circuitName")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "circuitName", valid_594045
  var valid_594046 = path.getOrDefault("resourceGroupName")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "resourceGroupName", valid_594046
  var valid_594047 = path.getOrDefault("subscriptionId")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "subscriptionId", valid_594047
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594048 = query.getOrDefault("api-version")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "api-version", valid_594048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594049: Call_ExpressRouteCircuitAuthorizationsList_594042;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all authorizations in an express route circuit.
  ## 
  let valid = call_594049.validator(path, query, header, formData, body)
  let scheme = call_594049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594049.url(scheme.get, call_594049.host, call_594049.base,
                         call_594049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594049, url, valid)

proc call*(call_594050: Call_ExpressRouteCircuitAuthorizationsList_594042;
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
  var path_594051 = newJObject()
  var query_594052 = newJObject()
  add(path_594051, "circuitName", newJString(circuitName))
  add(path_594051, "resourceGroupName", newJString(resourceGroupName))
  add(query_594052, "api-version", newJString(apiVersion))
  add(path_594051, "subscriptionId", newJString(subscriptionId))
  result = call_594050.call(path_594051, query_594052, nil, nil, nil)

var expressRouteCircuitAuthorizationsList* = Call_ExpressRouteCircuitAuthorizationsList_594042(
    name: "expressRouteCircuitAuthorizationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations",
    validator: validate_ExpressRouteCircuitAuthorizationsList_594043, base: "",
    url: url_ExpressRouteCircuitAuthorizationsList_594044, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_594065 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCircuitAuthorizationsCreateOrUpdate_594067(protocol: Scheme;
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

proc validate_ExpressRouteCircuitAuthorizationsCreateOrUpdate_594066(
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
  var valid_594068 = path.getOrDefault("circuitName")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "circuitName", valid_594068
  var valid_594069 = path.getOrDefault("resourceGroupName")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "resourceGroupName", valid_594069
  var valid_594070 = path.getOrDefault("subscriptionId")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "subscriptionId", valid_594070
  var valid_594071 = path.getOrDefault("authorizationName")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "authorizationName", valid_594071
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594072 = query.getOrDefault("api-version")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "api-version", valid_594072
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

proc call*(call_594074: Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_594065;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an authorization in the specified express route circuit.
  ## 
  let valid = call_594074.validator(path, query, header, formData, body)
  let scheme = call_594074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594074.url(scheme.get, call_594074.host, call_594074.base,
                         call_594074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594074, url, valid)

proc call*(call_594075: Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_594065;
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
  var path_594076 = newJObject()
  var query_594077 = newJObject()
  var body_594078 = newJObject()
  add(path_594076, "circuitName", newJString(circuitName))
  add(path_594076, "resourceGroupName", newJString(resourceGroupName))
  add(query_594077, "api-version", newJString(apiVersion))
  add(path_594076, "subscriptionId", newJString(subscriptionId))
  if authorizationParameters != nil:
    body_594078 = authorizationParameters
  add(path_594076, "authorizationName", newJString(authorizationName))
  result = call_594075.call(path_594076, query_594077, nil, nil, body_594078)

var expressRouteCircuitAuthorizationsCreateOrUpdate* = Call_ExpressRouteCircuitAuthorizationsCreateOrUpdate_594065(
    name: "expressRouteCircuitAuthorizationsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations/{authorizationName}",
    validator: validate_ExpressRouteCircuitAuthorizationsCreateOrUpdate_594066,
    base: "", url: url_ExpressRouteCircuitAuthorizationsCreateOrUpdate_594067,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsGet_594053 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCircuitAuthorizationsGet_594055(protocol: Scheme;
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

proc validate_ExpressRouteCircuitAuthorizationsGet_594054(path: JsonNode;
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
  var valid_594056 = path.getOrDefault("circuitName")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "circuitName", valid_594056
  var valid_594057 = path.getOrDefault("resourceGroupName")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "resourceGroupName", valid_594057
  var valid_594058 = path.getOrDefault("subscriptionId")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "subscriptionId", valid_594058
  var valid_594059 = path.getOrDefault("authorizationName")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "authorizationName", valid_594059
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594060 = query.getOrDefault("api-version")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "api-version", valid_594060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594061: Call_ExpressRouteCircuitAuthorizationsGet_594053;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified authorization from the specified express route circuit.
  ## 
  let valid = call_594061.validator(path, query, header, formData, body)
  let scheme = call_594061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594061.url(scheme.get, call_594061.host, call_594061.base,
                         call_594061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594061, url, valid)

proc call*(call_594062: Call_ExpressRouteCircuitAuthorizationsGet_594053;
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
  var path_594063 = newJObject()
  var query_594064 = newJObject()
  add(path_594063, "circuitName", newJString(circuitName))
  add(path_594063, "resourceGroupName", newJString(resourceGroupName))
  add(query_594064, "api-version", newJString(apiVersion))
  add(path_594063, "subscriptionId", newJString(subscriptionId))
  add(path_594063, "authorizationName", newJString(authorizationName))
  result = call_594062.call(path_594063, query_594064, nil, nil, nil)

var expressRouteCircuitAuthorizationsGet* = Call_ExpressRouteCircuitAuthorizationsGet_594053(
    name: "expressRouteCircuitAuthorizationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations/{authorizationName}",
    validator: validate_ExpressRouteCircuitAuthorizationsGet_594054, base: "",
    url: url_ExpressRouteCircuitAuthorizationsGet_594055, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitAuthorizationsDelete_594079 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCircuitAuthorizationsDelete_594081(protocol: Scheme;
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

proc validate_ExpressRouteCircuitAuthorizationsDelete_594080(path: JsonNode;
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
  var valid_594082 = path.getOrDefault("circuitName")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "circuitName", valid_594082
  var valid_594083 = path.getOrDefault("resourceGroupName")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "resourceGroupName", valid_594083
  var valid_594084 = path.getOrDefault("subscriptionId")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "subscriptionId", valid_594084
  var valid_594085 = path.getOrDefault("authorizationName")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "authorizationName", valid_594085
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594086 = query.getOrDefault("api-version")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "api-version", valid_594086
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594087: Call_ExpressRouteCircuitAuthorizationsDelete_594079;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified authorization from the specified express route circuit.
  ## 
  let valid = call_594087.validator(path, query, header, formData, body)
  let scheme = call_594087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594087.url(scheme.get, call_594087.host, call_594087.base,
                         call_594087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594087, url, valid)

proc call*(call_594088: Call_ExpressRouteCircuitAuthorizationsDelete_594079;
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
  var path_594089 = newJObject()
  var query_594090 = newJObject()
  add(path_594089, "circuitName", newJString(circuitName))
  add(path_594089, "resourceGroupName", newJString(resourceGroupName))
  add(query_594090, "api-version", newJString(apiVersion))
  add(path_594089, "subscriptionId", newJString(subscriptionId))
  add(path_594089, "authorizationName", newJString(authorizationName))
  result = call_594088.call(path_594089, query_594090, nil, nil, nil)

var expressRouteCircuitAuthorizationsDelete* = Call_ExpressRouteCircuitAuthorizationsDelete_594079(
    name: "expressRouteCircuitAuthorizationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations/{authorizationName}",
    validator: validate_ExpressRouteCircuitAuthorizationsDelete_594080, base: "",
    url: url_ExpressRouteCircuitAuthorizationsDelete_594081,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsList_594091 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCircuitPeeringsList_594093(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitPeeringsList_594092(path: JsonNode;
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
  var valid_594094 = path.getOrDefault("circuitName")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "circuitName", valid_594094
  var valid_594095 = path.getOrDefault("resourceGroupName")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "resourceGroupName", valid_594095
  var valid_594096 = path.getOrDefault("subscriptionId")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "subscriptionId", valid_594096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594097 = query.getOrDefault("api-version")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "api-version", valid_594097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594098: Call_ExpressRouteCircuitPeeringsList_594091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all peerings in a specified express route circuit.
  ## 
  let valid = call_594098.validator(path, query, header, formData, body)
  let scheme = call_594098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594098.url(scheme.get, call_594098.host, call_594098.base,
                         call_594098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594098, url, valid)

proc call*(call_594099: Call_ExpressRouteCircuitPeeringsList_594091;
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
  var path_594100 = newJObject()
  var query_594101 = newJObject()
  add(path_594100, "circuitName", newJString(circuitName))
  add(path_594100, "resourceGroupName", newJString(resourceGroupName))
  add(query_594101, "api-version", newJString(apiVersion))
  add(path_594100, "subscriptionId", newJString(subscriptionId))
  result = call_594099.call(path_594100, query_594101, nil, nil, nil)

var expressRouteCircuitPeeringsList* = Call_ExpressRouteCircuitPeeringsList_594091(
    name: "expressRouteCircuitPeeringsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings",
    validator: validate_ExpressRouteCircuitPeeringsList_594092, base: "",
    url: url_ExpressRouteCircuitPeeringsList_594093, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsCreateOrUpdate_594114 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCircuitPeeringsCreateOrUpdate_594116(protocol: Scheme;
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

proc validate_ExpressRouteCircuitPeeringsCreateOrUpdate_594115(path: JsonNode;
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
  var valid_594117 = path.getOrDefault("circuitName")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "circuitName", valid_594117
  var valid_594118 = path.getOrDefault("resourceGroupName")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "resourceGroupName", valid_594118
  var valid_594119 = path.getOrDefault("peeringName")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = nil)
  if valid_594119 != nil:
    section.add "peeringName", valid_594119
  var valid_594120 = path.getOrDefault("subscriptionId")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "subscriptionId", valid_594120
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594121 = query.getOrDefault("api-version")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "api-version", valid_594121
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

proc call*(call_594123: Call_ExpressRouteCircuitPeeringsCreateOrUpdate_594114;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a peering in the specified express route circuits.
  ## 
  let valid = call_594123.validator(path, query, header, formData, body)
  let scheme = call_594123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594123.url(scheme.get, call_594123.host, call_594123.base,
                         call_594123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594123, url, valid)

proc call*(call_594124: Call_ExpressRouteCircuitPeeringsCreateOrUpdate_594114;
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
  var path_594125 = newJObject()
  var query_594126 = newJObject()
  var body_594127 = newJObject()
  add(path_594125, "circuitName", newJString(circuitName))
  add(path_594125, "resourceGroupName", newJString(resourceGroupName))
  add(query_594126, "api-version", newJString(apiVersion))
  add(path_594125, "peeringName", newJString(peeringName))
  add(path_594125, "subscriptionId", newJString(subscriptionId))
  if peeringParameters != nil:
    body_594127 = peeringParameters
  result = call_594124.call(path_594125, query_594126, nil, nil, body_594127)

var expressRouteCircuitPeeringsCreateOrUpdate* = Call_ExpressRouteCircuitPeeringsCreateOrUpdate_594114(
    name: "expressRouteCircuitPeeringsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCircuitPeeringsCreateOrUpdate_594115,
    base: "", url: url_ExpressRouteCircuitPeeringsCreateOrUpdate_594116,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsGet_594102 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCircuitPeeringsGet_594104(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitPeeringsGet_594103(path: JsonNode;
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
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `circuitName` field"
  var valid_594105 = path.getOrDefault("circuitName")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "circuitName", valid_594105
  var valid_594106 = path.getOrDefault("resourceGroupName")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "resourceGroupName", valid_594106
  var valid_594107 = path.getOrDefault("peeringName")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "peeringName", valid_594107
  var valid_594108 = path.getOrDefault("subscriptionId")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "subscriptionId", valid_594108
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594109 = query.getOrDefault("api-version")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "api-version", valid_594109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594110: Call_ExpressRouteCircuitPeeringsGet_594102; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified authorization from the specified express route circuit.
  ## 
  let valid = call_594110.validator(path, query, header, formData, body)
  let scheme = call_594110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594110.url(scheme.get, call_594110.host, call_594110.base,
                         call_594110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594110, url, valid)

proc call*(call_594111: Call_ExpressRouteCircuitPeeringsGet_594102;
          circuitName: string; resourceGroupName: string; apiVersion: string;
          peeringName: string; subscriptionId: string): Recallable =
  ## expressRouteCircuitPeeringsGet
  ## Gets the specified authorization from the specified express route circuit.
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
  var path_594112 = newJObject()
  var query_594113 = newJObject()
  add(path_594112, "circuitName", newJString(circuitName))
  add(path_594112, "resourceGroupName", newJString(resourceGroupName))
  add(query_594113, "api-version", newJString(apiVersion))
  add(path_594112, "peeringName", newJString(peeringName))
  add(path_594112, "subscriptionId", newJString(subscriptionId))
  result = call_594111.call(path_594112, query_594113, nil, nil, nil)

var expressRouteCircuitPeeringsGet* = Call_ExpressRouteCircuitPeeringsGet_594102(
    name: "expressRouteCircuitPeeringsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCircuitPeeringsGet_594103, base: "",
    url: url_ExpressRouteCircuitPeeringsGet_594104, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitPeeringsDelete_594128 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCircuitPeeringsDelete_594130(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitPeeringsDelete_594129(path: JsonNode;
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
  var valid_594131 = path.getOrDefault("circuitName")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "circuitName", valid_594131
  var valid_594132 = path.getOrDefault("resourceGroupName")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "resourceGroupName", valid_594132
  var valid_594133 = path.getOrDefault("peeringName")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "peeringName", valid_594133
  var valid_594134 = path.getOrDefault("subscriptionId")
  valid_594134 = validateParameter(valid_594134, JString, required = true,
                                 default = nil)
  if valid_594134 != nil:
    section.add "subscriptionId", valid_594134
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

proc call*(call_594136: Call_ExpressRouteCircuitPeeringsDelete_594128;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified peering from the specified express route circuit.
  ## 
  let valid = call_594136.validator(path, query, header, formData, body)
  let scheme = call_594136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594136.url(scheme.get, call_594136.host, call_594136.base,
                         call_594136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594136, url, valid)

proc call*(call_594137: Call_ExpressRouteCircuitPeeringsDelete_594128;
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
  var path_594138 = newJObject()
  var query_594139 = newJObject()
  add(path_594138, "circuitName", newJString(circuitName))
  add(path_594138, "resourceGroupName", newJString(resourceGroupName))
  add(query_594139, "api-version", newJString(apiVersion))
  add(path_594138, "peeringName", newJString(peeringName))
  add(path_594138, "subscriptionId", newJString(subscriptionId))
  result = call_594137.call(path_594138, query_594139, nil, nil, nil)

var expressRouteCircuitPeeringsDelete* = Call_ExpressRouteCircuitPeeringsDelete_594128(
    name: "expressRouteCircuitPeeringsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCircuitPeeringsDelete_594129, base: "",
    url: url_ExpressRouteCircuitPeeringsDelete_594130, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsListArpTable_594140 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCircuitsListArpTable_594142(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsListArpTable_594141(path: JsonNode;
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
  var valid_594143 = path.getOrDefault("circuitName")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "circuitName", valid_594143
  var valid_594144 = path.getOrDefault("resourceGroupName")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "resourceGroupName", valid_594144
  var valid_594145 = path.getOrDefault("peeringName")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "peeringName", valid_594145
  var valid_594146 = path.getOrDefault("subscriptionId")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "subscriptionId", valid_594146
  var valid_594147 = path.getOrDefault("devicePath")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "devicePath", valid_594147
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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

proc call*(call_594149: Call_ExpressRouteCircuitsListArpTable_594140;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the currently advertised ARP table associated with the express route circuit in a resource group.
  ## 
  let valid = call_594149.validator(path, query, header, formData, body)
  let scheme = call_594149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594149.url(scheme.get, call_594149.host, call_594149.base,
                         call_594149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594149, url, valid)

proc call*(call_594150: Call_ExpressRouteCircuitsListArpTable_594140;
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
  var path_594151 = newJObject()
  var query_594152 = newJObject()
  add(path_594151, "circuitName", newJString(circuitName))
  add(path_594151, "resourceGroupName", newJString(resourceGroupName))
  add(query_594152, "api-version", newJString(apiVersion))
  add(path_594151, "peeringName", newJString(peeringName))
  add(path_594151, "subscriptionId", newJString(subscriptionId))
  add(path_594151, "devicePath", newJString(devicePath))
  result = call_594150.call(path_594151, query_594152, nil, nil, nil)

var expressRouteCircuitsListArpTable* = Call_ExpressRouteCircuitsListArpTable_594140(
    name: "expressRouteCircuitsListArpTable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/arpTables/{devicePath}",
    validator: validate_ExpressRouteCircuitsListArpTable_594141, base: "",
    url: url_ExpressRouteCircuitsListArpTable_594142, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsListRoutesTable_594153 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCircuitsListRoutesTable_594155(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsListRoutesTable_594154(path: JsonNode;
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
  var valid_594156 = path.getOrDefault("circuitName")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "circuitName", valid_594156
  var valid_594157 = path.getOrDefault("resourceGroupName")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "resourceGroupName", valid_594157
  var valid_594158 = path.getOrDefault("peeringName")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "peeringName", valid_594158
  var valid_594159 = path.getOrDefault("subscriptionId")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "subscriptionId", valid_594159
  var valid_594160 = path.getOrDefault("devicePath")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "devicePath", valid_594160
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594161 = query.getOrDefault("api-version")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "api-version", valid_594161
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594162: Call_ExpressRouteCircuitsListRoutesTable_594153;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the currently advertised routes table associated with the express route circuit in a resource group.
  ## 
  let valid = call_594162.validator(path, query, header, formData, body)
  let scheme = call_594162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594162.url(scheme.get, call_594162.host, call_594162.base,
                         call_594162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594162, url, valid)

proc call*(call_594163: Call_ExpressRouteCircuitsListRoutesTable_594153;
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
  var path_594164 = newJObject()
  var query_594165 = newJObject()
  add(path_594164, "circuitName", newJString(circuitName))
  add(path_594164, "resourceGroupName", newJString(resourceGroupName))
  add(query_594165, "api-version", newJString(apiVersion))
  add(path_594164, "peeringName", newJString(peeringName))
  add(path_594164, "subscriptionId", newJString(subscriptionId))
  add(path_594164, "devicePath", newJString(devicePath))
  result = call_594163.call(path_594164, query_594165, nil, nil, nil)

var expressRouteCircuitsListRoutesTable* = Call_ExpressRouteCircuitsListRoutesTable_594153(
    name: "expressRouteCircuitsListRoutesTable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/routeTables/{devicePath}",
    validator: validate_ExpressRouteCircuitsListRoutesTable_594154, base: "",
    url: url_ExpressRouteCircuitsListRoutesTable_594155, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsListRoutesTableSummary_594166 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCircuitsListRoutesTableSummary_594168(protocol: Scheme;
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

proc validate_ExpressRouteCircuitsListRoutesTableSummary_594167(path: JsonNode;
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
  var valid_594169 = path.getOrDefault("circuitName")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "circuitName", valid_594169
  var valid_594170 = path.getOrDefault("resourceGroupName")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "resourceGroupName", valid_594170
  var valid_594171 = path.getOrDefault("peeringName")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "peeringName", valid_594171
  var valid_594172 = path.getOrDefault("subscriptionId")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = nil)
  if valid_594172 != nil:
    section.add "subscriptionId", valid_594172
  var valid_594173 = path.getOrDefault("devicePath")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "devicePath", valid_594173
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594174 = query.getOrDefault("api-version")
  valid_594174 = validateParameter(valid_594174, JString, required = true,
                                 default = nil)
  if valid_594174 != nil:
    section.add "api-version", valid_594174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594175: Call_ExpressRouteCircuitsListRoutesTableSummary_594166;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the currently advertised routes table summary associated with the express route circuit in a resource group.
  ## 
  let valid = call_594175.validator(path, query, header, formData, body)
  let scheme = call_594175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594175.url(scheme.get, call_594175.host, call_594175.base,
                         call_594175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594175, url, valid)

proc call*(call_594176: Call_ExpressRouteCircuitsListRoutesTableSummary_594166;
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
  var path_594177 = newJObject()
  var query_594178 = newJObject()
  add(path_594177, "circuitName", newJString(circuitName))
  add(path_594177, "resourceGroupName", newJString(resourceGroupName))
  add(query_594178, "api-version", newJString(apiVersion))
  add(path_594177, "peeringName", newJString(peeringName))
  add(path_594177, "subscriptionId", newJString(subscriptionId))
  add(path_594177, "devicePath", newJString(devicePath))
  result = call_594176.call(path_594177, query_594178, nil, nil, nil)

var expressRouteCircuitsListRoutesTableSummary* = Call_ExpressRouteCircuitsListRoutesTableSummary_594166(
    name: "expressRouteCircuitsListRoutesTableSummary", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/routeTablesSummary/{devicePath}",
    validator: validate_ExpressRouteCircuitsListRoutesTableSummary_594167,
    base: "", url: url_ExpressRouteCircuitsListRoutesTableSummary_594168,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsGetPeeringStats_594179 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCircuitsGetPeeringStats_594181(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsGetPeeringStats_594180(path: JsonNode;
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
  var valid_594182 = path.getOrDefault("circuitName")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "circuitName", valid_594182
  var valid_594183 = path.getOrDefault("resourceGroupName")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "resourceGroupName", valid_594183
  var valid_594184 = path.getOrDefault("peeringName")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "peeringName", valid_594184
  var valid_594185 = path.getOrDefault("subscriptionId")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = nil)
  if valid_594185 != nil:
    section.add "subscriptionId", valid_594185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594186 = query.getOrDefault("api-version")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "api-version", valid_594186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594187: Call_ExpressRouteCircuitsGetPeeringStats_594179;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all stats from an express route circuit in a resource group.
  ## 
  let valid = call_594187.validator(path, query, header, formData, body)
  let scheme = call_594187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594187.url(scheme.get, call_594187.host, call_594187.base,
                         call_594187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594187, url, valid)

proc call*(call_594188: Call_ExpressRouteCircuitsGetPeeringStats_594179;
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
  var path_594189 = newJObject()
  var query_594190 = newJObject()
  add(path_594189, "circuitName", newJString(circuitName))
  add(path_594189, "resourceGroupName", newJString(resourceGroupName))
  add(query_594190, "api-version", newJString(apiVersion))
  add(path_594189, "peeringName", newJString(peeringName))
  add(path_594189, "subscriptionId", newJString(subscriptionId))
  result = call_594188.call(path_594189, query_594190, nil, nil, nil)

var expressRouteCircuitsGetPeeringStats* = Call_ExpressRouteCircuitsGetPeeringStats_594179(
    name: "expressRouteCircuitsGetPeeringStats", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/stats",
    validator: validate_ExpressRouteCircuitsGetPeeringStats_594180, base: "",
    url: url_ExpressRouteCircuitsGetPeeringStats_594181, schemes: {Scheme.Https})
type
  Call_ExpressRouteCircuitsGetStats_594191 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCircuitsGetStats_594193(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCircuitsGetStats_594192(path: JsonNode; query: JsonNode;
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
  var valid_594194 = path.getOrDefault("circuitName")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "circuitName", valid_594194
  var valid_594195 = path.getOrDefault("resourceGroupName")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "resourceGroupName", valid_594195
  var valid_594196 = path.getOrDefault("subscriptionId")
  valid_594196 = validateParameter(valid_594196, JString, required = true,
                                 default = nil)
  if valid_594196 != nil:
    section.add "subscriptionId", valid_594196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594197 = query.getOrDefault("api-version")
  valid_594197 = validateParameter(valid_594197, JString, required = true,
                                 default = nil)
  if valid_594197 != nil:
    section.add "api-version", valid_594197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594198: Call_ExpressRouteCircuitsGetStats_594191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the stats from an express route circuit in a resource group.
  ## 
  let valid = call_594198.validator(path, query, header, formData, body)
  let scheme = call_594198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594198.url(scheme.get, call_594198.host, call_594198.base,
                         call_594198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594198, url, valid)

proc call*(call_594199: Call_ExpressRouteCircuitsGetStats_594191;
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
  var path_594200 = newJObject()
  var query_594201 = newJObject()
  add(path_594200, "circuitName", newJString(circuitName))
  add(path_594200, "resourceGroupName", newJString(resourceGroupName))
  add(query_594201, "api-version", newJString(apiVersion))
  add(path_594200, "subscriptionId", newJString(subscriptionId))
  result = call_594199.call(path_594200, query_594201, nil, nil, nil)

var expressRouteCircuitsGetStats* = Call_ExpressRouteCircuitsGetStats_594191(
    name: "expressRouteCircuitsGetStats", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/stats",
    validator: validate_ExpressRouteCircuitsGetStats_594192, base: "",
    url: url_ExpressRouteCircuitsGetStats_594193, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
