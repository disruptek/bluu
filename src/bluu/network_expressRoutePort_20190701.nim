
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2019-07-01
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

  OpenApiRestCall_573657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573657): Option[Scheme] {.used.} =
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
  macServiceName = "network-expressRoutePort"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ExpressRoutePortsList_573879 = ref object of OpenApiRestCall_573657
proc url_ExpressRoutePortsList_573881(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Network/ExpressRoutePorts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRoutePortsList_573880(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the ExpressRoutePort resources in the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574041 = path.getOrDefault("subscriptionId")
  valid_574041 = validateParameter(valid_574041, JString, required = true,
                                 default = nil)
  if valid_574041 != nil:
    section.add "subscriptionId", valid_574041
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574042 = query.getOrDefault("api-version")
  valid_574042 = validateParameter(valid_574042, JString, required = true,
                                 default = nil)
  if valid_574042 != nil:
    section.add "api-version", valid_574042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574069: Call_ExpressRoutePortsList_573879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the ExpressRoutePort resources in the specified subscription.
  ## 
  let valid = call_574069.validator(path, query, header, formData, body)
  let scheme = call_574069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574069.url(scheme.get, call_574069.host, call_574069.base,
                         call_574069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574069, url, valid)

proc call*(call_574140: Call_ExpressRoutePortsList_573879; apiVersion: string;
          subscriptionId: string): Recallable =
  ## expressRoutePortsList
  ## List all the ExpressRoutePort resources in the specified subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574141 = newJObject()
  var query_574143 = newJObject()
  add(query_574143, "api-version", newJString(apiVersion))
  add(path_574141, "subscriptionId", newJString(subscriptionId))
  result = call_574140.call(path_574141, query_574143, nil, nil, nil)

var expressRoutePortsList* = Call_ExpressRoutePortsList_573879(
    name: "expressRoutePortsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/ExpressRoutePorts",
    validator: validate_ExpressRoutePortsList_573880, base: "",
    url: url_ExpressRoutePortsList_573881, schemes: {Scheme.Https})
type
  Call_ExpressRoutePortsLocationsList_574182 = ref object of OpenApiRestCall_573657
proc url_ExpressRoutePortsLocationsList_574184(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Network/ExpressRoutePortsLocations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRoutePortsLocationsList_574183(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all ExpressRoutePort peering locations. Does not return available bandwidths for each location. Available bandwidths can only be obtained when retrieving a specific peering location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574185 = path.getOrDefault("subscriptionId")
  valid_574185 = validateParameter(valid_574185, JString, required = true,
                                 default = nil)
  if valid_574185 != nil:
    section.add "subscriptionId", valid_574185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574186 = query.getOrDefault("api-version")
  valid_574186 = validateParameter(valid_574186, JString, required = true,
                                 default = nil)
  if valid_574186 != nil:
    section.add "api-version", valid_574186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574187: Call_ExpressRoutePortsLocationsList_574182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all ExpressRoutePort peering locations. Does not return available bandwidths for each location. Available bandwidths can only be obtained when retrieving a specific peering location.
  ## 
  let valid = call_574187.validator(path, query, header, formData, body)
  let scheme = call_574187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574187.url(scheme.get, call_574187.host, call_574187.base,
                         call_574187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574187, url, valid)

proc call*(call_574188: Call_ExpressRoutePortsLocationsList_574182;
          apiVersion: string; subscriptionId: string): Recallable =
  ## expressRoutePortsLocationsList
  ## Retrieves all ExpressRoutePort peering locations. Does not return available bandwidths for each location. Available bandwidths can only be obtained when retrieving a specific peering location.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574189 = newJObject()
  var query_574190 = newJObject()
  add(query_574190, "api-version", newJString(apiVersion))
  add(path_574189, "subscriptionId", newJString(subscriptionId))
  result = call_574188.call(path_574189, query_574190, nil, nil, nil)

var expressRoutePortsLocationsList* = Call_ExpressRoutePortsLocationsList_574182(
    name: "expressRoutePortsLocationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/ExpressRoutePortsLocations",
    validator: validate_ExpressRoutePortsLocationsList_574183, base: "",
    url: url_ExpressRoutePortsLocationsList_574184, schemes: {Scheme.Https})
type
  Call_ExpressRoutePortsLocationsGet_574191 = ref object of OpenApiRestCall_573657
proc url_ExpressRoutePortsLocationsGet_574193(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/ExpressRoutePortsLocations/"),
               (kind: VariableSegment, value: "locationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRoutePortsLocationsGet_574192(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a single ExpressRoutePort peering location, including the list of available bandwidths available at said peering location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   locationName: JString (required)
  ##               : Name of the requested ExpressRoutePort peering location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574194 = path.getOrDefault("subscriptionId")
  valid_574194 = validateParameter(valid_574194, JString, required = true,
                                 default = nil)
  if valid_574194 != nil:
    section.add "subscriptionId", valid_574194
  var valid_574195 = path.getOrDefault("locationName")
  valid_574195 = validateParameter(valid_574195, JString, required = true,
                                 default = nil)
  if valid_574195 != nil:
    section.add "locationName", valid_574195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574196 = query.getOrDefault("api-version")
  valid_574196 = validateParameter(valid_574196, JString, required = true,
                                 default = nil)
  if valid_574196 != nil:
    section.add "api-version", valid_574196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574197: Call_ExpressRoutePortsLocationsGet_574191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a single ExpressRoutePort peering location, including the list of available bandwidths available at said peering location.
  ## 
  let valid = call_574197.validator(path, query, header, formData, body)
  let scheme = call_574197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574197.url(scheme.get, call_574197.host, call_574197.base,
                         call_574197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574197, url, valid)

proc call*(call_574198: Call_ExpressRoutePortsLocationsGet_574191;
          apiVersion: string; subscriptionId: string; locationName: string): Recallable =
  ## expressRoutePortsLocationsGet
  ## Retrieves a single ExpressRoutePort peering location, including the list of available bandwidths available at said peering location.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   locationName: string (required)
  ##               : Name of the requested ExpressRoutePort peering location.
  var path_574199 = newJObject()
  var query_574200 = newJObject()
  add(query_574200, "api-version", newJString(apiVersion))
  add(path_574199, "subscriptionId", newJString(subscriptionId))
  add(path_574199, "locationName", newJString(locationName))
  result = call_574198.call(path_574199, query_574200, nil, nil, nil)

var expressRoutePortsLocationsGet* = Call_ExpressRoutePortsLocationsGet_574191(
    name: "expressRoutePortsLocationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/ExpressRoutePortsLocations/{locationName}",
    validator: validate_ExpressRoutePortsLocationsGet_574192, base: "",
    url: url_ExpressRoutePortsLocationsGet_574193, schemes: {Scheme.Https})
type
  Call_ExpressRoutePortsListByResourceGroup_574201 = ref object of OpenApiRestCall_573657
proc url_ExpressRoutePortsListByResourceGroup_574203(protocol: Scheme;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/ExpressRoutePorts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRoutePortsListByResourceGroup_574202(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the ExpressRoutePort resources in the specified resource group.
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
  var valid_574204 = path.getOrDefault("resourceGroupName")
  valid_574204 = validateParameter(valid_574204, JString, required = true,
                                 default = nil)
  if valid_574204 != nil:
    section.add "resourceGroupName", valid_574204
  var valid_574205 = path.getOrDefault("subscriptionId")
  valid_574205 = validateParameter(valid_574205, JString, required = true,
                                 default = nil)
  if valid_574205 != nil:
    section.add "subscriptionId", valid_574205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574206 = query.getOrDefault("api-version")
  valid_574206 = validateParameter(valid_574206, JString, required = true,
                                 default = nil)
  if valid_574206 != nil:
    section.add "api-version", valid_574206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574207: Call_ExpressRoutePortsListByResourceGroup_574201;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all the ExpressRoutePort resources in the specified resource group.
  ## 
  let valid = call_574207.validator(path, query, header, formData, body)
  let scheme = call_574207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574207.url(scheme.get, call_574207.host, call_574207.base,
                         call_574207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574207, url, valid)

proc call*(call_574208: Call_ExpressRoutePortsListByResourceGroup_574201;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## expressRoutePortsListByResourceGroup
  ## List all the ExpressRoutePort resources in the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574209 = newJObject()
  var query_574210 = newJObject()
  add(path_574209, "resourceGroupName", newJString(resourceGroupName))
  add(query_574210, "api-version", newJString(apiVersion))
  add(path_574209, "subscriptionId", newJString(subscriptionId))
  result = call_574208.call(path_574209, query_574210, nil, nil, nil)

var expressRoutePortsListByResourceGroup* = Call_ExpressRoutePortsListByResourceGroup_574201(
    name: "expressRoutePortsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/ExpressRoutePorts",
    validator: validate_ExpressRoutePortsListByResourceGroup_574202, base: "",
    url: url_ExpressRoutePortsListByResourceGroup_574203, schemes: {Scheme.Https})
type
  Call_ExpressRoutePortsCreateOrUpdate_574222 = ref object of OpenApiRestCall_573657
proc url_ExpressRoutePortsCreateOrUpdate_574224(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "expressRoutePortName" in path,
        "`expressRoutePortName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/ExpressRoutePorts/"),
               (kind: VariableSegment, value: "expressRoutePortName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRoutePortsCreateOrUpdate_574223(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the specified ExpressRoutePort resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   expressRoutePortName: JString (required)
  ##                       : The name of the ExpressRoutePort resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574251 = path.getOrDefault("resourceGroupName")
  valid_574251 = validateParameter(valid_574251, JString, required = true,
                                 default = nil)
  if valid_574251 != nil:
    section.add "resourceGroupName", valid_574251
  var valid_574252 = path.getOrDefault("subscriptionId")
  valid_574252 = validateParameter(valid_574252, JString, required = true,
                                 default = nil)
  if valid_574252 != nil:
    section.add "subscriptionId", valid_574252
  var valid_574253 = path.getOrDefault("expressRoutePortName")
  valid_574253 = validateParameter(valid_574253, JString, required = true,
                                 default = nil)
  if valid_574253 != nil:
    section.add "expressRoutePortName", valid_574253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574254 = query.getOrDefault("api-version")
  valid_574254 = validateParameter(valid_574254, JString, required = true,
                                 default = nil)
  if valid_574254 != nil:
    section.add "api-version", valid_574254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create ExpressRoutePort operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574256: Call_ExpressRoutePortsCreateOrUpdate_574222;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the specified ExpressRoutePort resource.
  ## 
  let valid = call_574256.validator(path, query, header, formData, body)
  let scheme = call_574256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574256.url(scheme.get, call_574256.host, call_574256.base,
                         call_574256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574256, url, valid)

proc call*(call_574257: Call_ExpressRoutePortsCreateOrUpdate_574222;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; expressRoutePortName: string): Recallable =
  ## expressRoutePortsCreateOrUpdate
  ## Creates or updates the specified ExpressRoutePort resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create ExpressRoutePort operation.
  ##   expressRoutePortName: string (required)
  ##                       : The name of the ExpressRoutePort resource.
  var path_574258 = newJObject()
  var query_574259 = newJObject()
  var body_574260 = newJObject()
  add(path_574258, "resourceGroupName", newJString(resourceGroupName))
  add(query_574259, "api-version", newJString(apiVersion))
  add(path_574258, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574260 = parameters
  add(path_574258, "expressRoutePortName", newJString(expressRoutePortName))
  result = call_574257.call(path_574258, query_574259, nil, nil, body_574260)

var expressRoutePortsCreateOrUpdate* = Call_ExpressRoutePortsCreateOrUpdate_574222(
    name: "expressRoutePortsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/ExpressRoutePorts/{expressRoutePortName}",
    validator: validate_ExpressRoutePortsCreateOrUpdate_574223, base: "",
    url: url_ExpressRoutePortsCreateOrUpdate_574224, schemes: {Scheme.Https})
type
  Call_ExpressRoutePortsGet_574211 = ref object of OpenApiRestCall_573657
proc url_ExpressRoutePortsGet_574213(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "expressRoutePortName" in path,
        "`expressRoutePortName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/ExpressRoutePorts/"),
               (kind: VariableSegment, value: "expressRoutePortName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRoutePortsGet_574212(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the requested ExpressRoutePort resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   expressRoutePortName: JString (required)
  ##                       : The name of ExpressRoutePort.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574214 = path.getOrDefault("resourceGroupName")
  valid_574214 = validateParameter(valid_574214, JString, required = true,
                                 default = nil)
  if valid_574214 != nil:
    section.add "resourceGroupName", valid_574214
  var valid_574215 = path.getOrDefault("subscriptionId")
  valid_574215 = validateParameter(valid_574215, JString, required = true,
                                 default = nil)
  if valid_574215 != nil:
    section.add "subscriptionId", valid_574215
  var valid_574216 = path.getOrDefault("expressRoutePortName")
  valid_574216 = validateParameter(valid_574216, JString, required = true,
                                 default = nil)
  if valid_574216 != nil:
    section.add "expressRoutePortName", valid_574216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574217 = query.getOrDefault("api-version")
  valid_574217 = validateParameter(valid_574217, JString, required = true,
                                 default = nil)
  if valid_574217 != nil:
    section.add "api-version", valid_574217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574218: Call_ExpressRoutePortsGet_574211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the requested ExpressRoutePort resource.
  ## 
  let valid = call_574218.validator(path, query, header, formData, body)
  let scheme = call_574218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574218.url(scheme.get, call_574218.host, call_574218.base,
                         call_574218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574218, url, valid)

proc call*(call_574219: Call_ExpressRoutePortsGet_574211;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          expressRoutePortName: string): Recallable =
  ## expressRoutePortsGet
  ## Retrieves the requested ExpressRoutePort resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   expressRoutePortName: string (required)
  ##                       : The name of ExpressRoutePort.
  var path_574220 = newJObject()
  var query_574221 = newJObject()
  add(path_574220, "resourceGroupName", newJString(resourceGroupName))
  add(query_574221, "api-version", newJString(apiVersion))
  add(path_574220, "subscriptionId", newJString(subscriptionId))
  add(path_574220, "expressRoutePortName", newJString(expressRoutePortName))
  result = call_574219.call(path_574220, query_574221, nil, nil, nil)

var expressRoutePortsGet* = Call_ExpressRoutePortsGet_574211(
    name: "expressRoutePortsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/ExpressRoutePorts/{expressRoutePortName}",
    validator: validate_ExpressRoutePortsGet_574212, base: "",
    url: url_ExpressRoutePortsGet_574213, schemes: {Scheme.Https})
type
  Call_ExpressRoutePortsUpdateTags_574272 = ref object of OpenApiRestCall_573657
proc url_ExpressRoutePortsUpdateTags_574274(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "expressRoutePortName" in path,
        "`expressRoutePortName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/ExpressRoutePorts/"),
               (kind: VariableSegment, value: "expressRoutePortName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRoutePortsUpdateTags_574273(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update ExpressRoutePort tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   expressRoutePortName: JString (required)
  ##                       : The name of the ExpressRoutePort resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574275 = path.getOrDefault("resourceGroupName")
  valid_574275 = validateParameter(valid_574275, JString, required = true,
                                 default = nil)
  if valid_574275 != nil:
    section.add "resourceGroupName", valid_574275
  var valid_574276 = path.getOrDefault("subscriptionId")
  valid_574276 = validateParameter(valid_574276, JString, required = true,
                                 default = nil)
  if valid_574276 != nil:
    section.add "subscriptionId", valid_574276
  var valid_574277 = path.getOrDefault("expressRoutePortName")
  valid_574277 = validateParameter(valid_574277, JString, required = true,
                                 default = nil)
  if valid_574277 != nil:
    section.add "expressRoutePortName", valid_574277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574278 = query.getOrDefault("api-version")
  valid_574278 = validateParameter(valid_574278, JString, required = true,
                                 default = nil)
  if valid_574278 != nil:
    section.add "api-version", valid_574278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update ExpressRoutePort resource tags.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574280: Call_ExpressRoutePortsUpdateTags_574272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update ExpressRoutePort tags.
  ## 
  let valid = call_574280.validator(path, query, header, formData, body)
  let scheme = call_574280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574280.url(scheme.get, call_574280.host, call_574280.base,
                         call_574280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574280, url, valid)

proc call*(call_574281: Call_ExpressRoutePortsUpdateTags_574272;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; expressRoutePortName: string): Recallable =
  ## expressRoutePortsUpdateTags
  ## Update ExpressRoutePort tags.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update ExpressRoutePort resource tags.
  ##   expressRoutePortName: string (required)
  ##                       : The name of the ExpressRoutePort resource.
  var path_574282 = newJObject()
  var query_574283 = newJObject()
  var body_574284 = newJObject()
  add(path_574282, "resourceGroupName", newJString(resourceGroupName))
  add(query_574283, "api-version", newJString(apiVersion))
  add(path_574282, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574284 = parameters
  add(path_574282, "expressRoutePortName", newJString(expressRoutePortName))
  result = call_574281.call(path_574282, query_574283, nil, nil, body_574284)

var expressRoutePortsUpdateTags* = Call_ExpressRoutePortsUpdateTags_574272(
    name: "expressRoutePortsUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/ExpressRoutePorts/{expressRoutePortName}",
    validator: validate_ExpressRoutePortsUpdateTags_574273, base: "",
    url: url_ExpressRoutePortsUpdateTags_574274, schemes: {Scheme.Https})
type
  Call_ExpressRoutePortsDelete_574261 = ref object of OpenApiRestCall_573657
proc url_ExpressRoutePortsDelete_574263(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "expressRoutePortName" in path,
        "`expressRoutePortName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/ExpressRoutePorts/"),
               (kind: VariableSegment, value: "expressRoutePortName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRoutePortsDelete_574262(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified ExpressRoutePort resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   expressRoutePortName: JString (required)
  ##                       : The name of the ExpressRoutePort resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574264 = path.getOrDefault("resourceGroupName")
  valid_574264 = validateParameter(valid_574264, JString, required = true,
                                 default = nil)
  if valid_574264 != nil:
    section.add "resourceGroupName", valid_574264
  var valid_574265 = path.getOrDefault("subscriptionId")
  valid_574265 = validateParameter(valid_574265, JString, required = true,
                                 default = nil)
  if valid_574265 != nil:
    section.add "subscriptionId", valid_574265
  var valid_574266 = path.getOrDefault("expressRoutePortName")
  valid_574266 = validateParameter(valid_574266, JString, required = true,
                                 default = nil)
  if valid_574266 != nil:
    section.add "expressRoutePortName", valid_574266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574267 = query.getOrDefault("api-version")
  valid_574267 = validateParameter(valid_574267, JString, required = true,
                                 default = nil)
  if valid_574267 != nil:
    section.add "api-version", valid_574267
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574268: Call_ExpressRoutePortsDelete_574261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified ExpressRoutePort resource.
  ## 
  let valid = call_574268.validator(path, query, header, formData, body)
  let scheme = call_574268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574268.url(scheme.get, call_574268.host, call_574268.base,
                         call_574268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574268, url, valid)

proc call*(call_574269: Call_ExpressRoutePortsDelete_574261;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          expressRoutePortName: string): Recallable =
  ## expressRoutePortsDelete
  ## Deletes the specified ExpressRoutePort resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   expressRoutePortName: string (required)
  ##                       : The name of the ExpressRoutePort resource.
  var path_574270 = newJObject()
  var query_574271 = newJObject()
  add(path_574270, "resourceGroupName", newJString(resourceGroupName))
  add(query_574271, "api-version", newJString(apiVersion))
  add(path_574270, "subscriptionId", newJString(subscriptionId))
  add(path_574270, "expressRoutePortName", newJString(expressRoutePortName))
  result = call_574269.call(path_574270, query_574271, nil, nil, nil)

var expressRoutePortsDelete* = Call_ExpressRoutePortsDelete_574261(
    name: "expressRoutePortsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/ExpressRoutePorts/{expressRoutePortName}",
    validator: validate_ExpressRoutePortsDelete_574262, base: "",
    url: url_ExpressRoutePortsDelete_574263, schemes: {Scheme.Https})
type
  Call_ExpressRouteLinksList_574285 = ref object of OpenApiRestCall_573657
proc url_ExpressRouteLinksList_574287(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "expressRoutePortName" in path,
        "`expressRoutePortName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/ExpressRoutePorts/"),
               (kind: VariableSegment, value: "expressRoutePortName"),
               (kind: ConstantSegment, value: "/links")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteLinksList_574286(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the ExpressRouteLink sub-resources of the specified ExpressRoutePort resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   expressRoutePortName: JString (required)
  ##                       : The name of the ExpressRoutePort resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574288 = path.getOrDefault("resourceGroupName")
  valid_574288 = validateParameter(valid_574288, JString, required = true,
                                 default = nil)
  if valid_574288 != nil:
    section.add "resourceGroupName", valid_574288
  var valid_574289 = path.getOrDefault("subscriptionId")
  valid_574289 = validateParameter(valid_574289, JString, required = true,
                                 default = nil)
  if valid_574289 != nil:
    section.add "subscriptionId", valid_574289
  var valid_574290 = path.getOrDefault("expressRoutePortName")
  valid_574290 = validateParameter(valid_574290, JString, required = true,
                                 default = nil)
  if valid_574290 != nil:
    section.add "expressRoutePortName", valid_574290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574291 = query.getOrDefault("api-version")
  valid_574291 = validateParameter(valid_574291, JString, required = true,
                                 default = nil)
  if valid_574291 != nil:
    section.add "api-version", valid_574291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574292: Call_ExpressRouteLinksList_574285; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the ExpressRouteLink sub-resources of the specified ExpressRoutePort resource.
  ## 
  let valid = call_574292.validator(path, query, header, formData, body)
  let scheme = call_574292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574292.url(scheme.get, call_574292.host, call_574292.base,
                         call_574292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574292, url, valid)

proc call*(call_574293: Call_ExpressRouteLinksList_574285;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          expressRoutePortName: string): Recallable =
  ## expressRouteLinksList
  ## Retrieve the ExpressRouteLink sub-resources of the specified ExpressRoutePort resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   expressRoutePortName: string (required)
  ##                       : The name of the ExpressRoutePort resource.
  var path_574294 = newJObject()
  var query_574295 = newJObject()
  add(path_574294, "resourceGroupName", newJString(resourceGroupName))
  add(query_574295, "api-version", newJString(apiVersion))
  add(path_574294, "subscriptionId", newJString(subscriptionId))
  add(path_574294, "expressRoutePortName", newJString(expressRoutePortName))
  result = call_574293.call(path_574294, query_574295, nil, nil, nil)

var expressRouteLinksList* = Call_ExpressRouteLinksList_574285(
    name: "expressRouteLinksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/ExpressRoutePorts/{expressRoutePortName}/links",
    validator: validate_ExpressRouteLinksList_574286, base: "",
    url: url_ExpressRouteLinksList_574287, schemes: {Scheme.Https})
type
  Call_ExpressRouteLinksGet_574296 = ref object of OpenApiRestCall_573657
proc url_ExpressRouteLinksGet_574298(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "expressRoutePortName" in path,
        "`expressRoutePortName` is a required path parameter"
  assert "linkName" in path, "`linkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/ExpressRoutePorts/"),
               (kind: VariableSegment, value: "expressRoutePortName"),
               (kind: ConstantSegment, value: "/links/"),
               (kind: VariableSegment, value: "linkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteLinksGet_574297(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the specified ExpressRouteLink resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   linkName: JString (required)
  ##           : The name of the ExpressRouteLink resource.
  ##   expressRoutePortName: JString (required)
  ##                       : The name of the ExpressRoutePort resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574299 = path.getOrDefault("resourceGroupName")
  valid_574299 = validateParameter(valid_574299, JString, required = true,
                                 default = nil)
  if valid_574299 != nil:
    section.add "resourceGroupName", valid_574299
  var valid_574300 = path.getOrDefault("subscriptionId")
  valid_574300 = validateParameter(valid_574300, JString, required = true,
                                 default = nil)
  if valid_574300 != nil:
    section.add "subscriptionId", valid_574300
  var valid_574301 = path.getOrDefault("linkName")
  valid_574301 = validateParameter(valid_574301, JString, required = true,
                                 default = nil)
  if valid_574301 != nil:
    section.add "linkName", valid_574301
  var valid_574302 = path.getOrDefault("expressRoutePortName")
  valid_574302 = validateParameter(valid_574302, JString, required = true,
                                 default = nil)
  if valid_574302 != nil:
    section.add "expressRoutePortName", valid_574302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574303 = query.getOrDefault("api-version")
  valid_574303 = validateParameter(valid_574303, JString, required = true,
                                 default = nil)
  if valid_574303 != nil:
    section.add "api-version", valid_574303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574304: Call_ExpressRouteLinksGet_574296; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified ExpressRouteLink resource.
  ## 
  let valid = call_574304.validator(path, query, header, formData, body)
  let scheme = call_574304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574304.url(scheme.get, call_574304.host, call_574304.base,
                         call_574304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574304, url, valid)

proc call*(call_574305: Call_ExpressRouteLinksGet_574296;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          linkName: string; expressRoutePortName: string): Recallable =
  ## expressRouteLinksGet
  ## Retrieves the specified ExpressRouteLink resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   linkName: string (required)
  ##           : The name of the ExpressRouteLink resource.
  ##   expressRoutePortName: string (required)
  ##                       : The name of the ExpressRoutePort resource.
  var path_574306 = newJObject()
  var query_574307 = newJObject()
  add(path_574306, "resourceGroupName", newJString(resourceGroupName))
  add(query_574307, "api-version", newJString(apiVersion))
  add(path_574306, "subscriptionId", newJString(subscriptionId))
  add(path_574306, "linkName", newJString(linkName))
  add(path_574306, "expressRoutePortName", newJString(expressRoutePortName))
  result = call_574305.call(path_574306, query_574307, nil, nil, nil)

var expressRouteLinksGet* = Call_ExpressRouteLinksGet_574296(
    name: "expressRouteLinksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/ExpressRoutePorts/{expressRoutePortName}/links/{linkName}",
    validator: validate_ExpressRouteLinksGet_574297, base: "",
    url: url_ExpressRouteLinksGet_574298, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
