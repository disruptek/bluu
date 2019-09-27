
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2018-08-01
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
  macServiceName = "network-expressRoutePort"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ExpressRoutePortsList_593646 = ref object of OpenApiRestCall_593424
proc url_ExpressRoutePortsList_593648(protocol: Scheme; host: string; base: string;
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

proc validate_ExpressRoutePortsList_593647(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the ExpressRoutePort resources in the specified subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593808 = path.getOrDefault("subscriptionId")
  valid_593808 = validateParameter(valid_593808, JString, required = true,
                                 default = nil)
  if valid_593808 != nil:
    section.add "subscriptionId", valid_593808
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593809 = query.getOrDefault("api-version")
  valid_593809 = validateParameter(valid_593809, JString, required = true,
                                 default = nil)
  if valid_593809 != nil:
    section.add "api-version", valid_593809
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593836: Call_ExpressRoutePortsList_593646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the ExpressRoutePort resources in the specified subscription
  ## 
  let valid = call_593836.validator(path, query, header, formData, body)
  let scheme = call_593836.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593836.url(scheme.get, call_593836.host, call_593836.base,
                         call_593836.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593836, url, valid)

proc call*(call_593907: Call_ExpressRoutePortsList_593646; apiVersion: string;
          subscriptionId: string): Recallable =
  ## expressRoutePortsList
  ## List all the ExpressRoutePort resources in the specified subscription
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593908 = newJObject()
  var query_593910 = newJObject()
  add(query_593910, "api-version", newJString(apiVersion))
  add(path_593908, "subscriptionId", newJString(subscriptionId))
  result = call_593907.call(path_593908, query_593910, nil, nil, nil)

var expressRoutePortsList* = Call_ExpressRoutePortsList_593646(
    name: "expressRoutePortsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/ExpressRoutePorts",
    validator: validate_ExpressRoutePortsList_593647, base: "",
    url: url_ExpressRoutePortsList_593648, schemes: {Scheme.Https})
type
  Call_ExpressRoutePortsLocationsList_593949 = ref object of OpenApiRestCall_593424
proc url_ExpressRoutePortsLocationsList_593951(protocol: Scheme; host: string;
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

proc validate_ExpressRoutePortsLocationsList_593950(path: JsonNode;
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
  var valid_593952 = path.getOrDefault("subscriptionId")
  valid_593952 = validateParameter(valid_593952, JString, required = true,
                                 default = nil)
  if valid_593952 != nil:
    section.add "subscriptionId", valid_593952
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593953 = query.getOrDefault("api-version")
  valid_593953 = validateParameter(valid_593953, JString, required = true,
                                 default = nil)
  if valid_593953 != nil:
    section.add "api-version", valid_593953
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593954: Call_ExpressRoutePortsLocationsList_593949; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all ExpressRoutePort peering locations. Does not return available bandwidths for each location. Available bandwidths can only be obtained when retrieving a specific peering location.
  ## 
  let valid = call_593954.validator(path, query, header, formData, body)
  let scheme = call_593954.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593954.url(scheme.get, call_593954.host, call_593954.base,
                         call_593954.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593954, url, valid)

proc call*(call_593955: Call_ExpressRoutePortsLocationsList_593949;
          apiVersion: string; subscriptionId: string): Recallable =
  ## expressRoutePortsLocationsList
  ## Retrieves all ExpressRoutePort peering locations. Does not return available bandwidths for each location. Available bandwidths can only be obtained when retrieving a specific peering location.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593956 = newJObject()
  var query_593957 = newJObject()
  add(query_593957, "api-version", newJString(apiVersion))
  add(path_593956, "subscriptionId", newJString(subscriptionId))
  result = call_593955.call(path_593956, query_593957, nil, nil, nil)

var expressRoutePortsLocationsList* = Call_ExpressRoutePortsLocationsList_593949(
    name: "expressRoutePortsLocationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/ExpressRoutePortsLocations",
    validator: validate_ExpressRoutePortsLocationsList_593950, base: "",
    url: url_ExpressRoutePortsLocationsList_593951, schemes: {Scheme.Https})
type
  Call_ExpressRoutePortsLocationsGet_593958 = ref object of OpenApiRestCall_593424
proc url_ExpressRoutePortsLocationsGet_593960(protocol: Scheme; host: string;
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

proc validate_ExpressRoutePortsLocationsGet_593959(path: JsonNode; query: JsonNode;
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
  var valid_593961 = path.getOrDefault("subscriptionId")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "subscriptionId", valid_593961
  var valid_593962 = path.getOrDefault("locationName")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "locationName", valid_593962
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593963 = query.getOrDefault("api-version")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "api-version", valid_593963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593964: Call_ExpressRoutePortsLocationsGet_593958; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a single ExpressRoutePort peering location, including the list of available bandwidths available at said peering location.
  ## 
  let valid = call_593964.validator(path, query, header, formData, body)
  let scheme = call_593964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593964.url(scheme.get, call_593964.host, call_593964.base,
                         call_593964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593964, url, valid)

proc call*(call_593965: Call_ExpressRoutePortsLocationsGet_593958;
          apiVersion: string; subscriptionId: string; locationName: string): Recallable =
  ## expressRoutePortsLocationsGet
  ## Retrieves a single ExpressRoutePort peering location, including the list of available bandwidths available at said peering location.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   locationName: string (required)
  ##               : Name of the requested ExpressRoutePort peering location.
  var path_593966 = newJObject()
  var query_593967 = newJObject()
  add(query_593967, "api-version", newJString(apiVersion))
  add(path_593966, "subscriptionId", newJString(subscriptionId))
  add(path_593966, "locationName", newJString(locationName))
  result = call_593965.call(path_593966, query_593967, nil, nil, nil)

var expressRoutePortsLocationsGet* = Call_ExpressRoutePortsLocationsGet_593958(
    name: "expressRoutePortsLocationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/ExpressRoutePortsLocations/{locationName}",
    validator: validate_ExpressRoutePortsLocationsGet_593959, base: "",
    url: url_ExpressRoutePortsLocationsGet_593960, schemes: {Scheme.Https})
type
  Call_ExpressRoutePortsListByResourceGroup_593968 = ref object of OpenApiRestCall_593424
proc url_ExpressRoutePortsListByResourceGroup_593970(protocol: Scheme;
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

proc validate_ExpressRoutePortsListByResourceGroup_593969(path: JsonNode;
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
  var valid_593971 = path.getOrDefault("resourceGroupName")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = nil)
  if valid_593971 != nil:
    section.add "resourceGroupName", valid_593971
  var valid_593972 = path.getOrDefault("subscriptionId")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "subscriptionId", valid_593972
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593973 = query.getOrDefault("api-version")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "api-version", valid_593973
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593974: Call_ExpressRoutePortsListByResourceGroup_593968;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all the ExpressRoutePort resources in the specified resource group.
  ## 
  let valid = call_593974.validator(path, query, header, formData, body)
  let scheme = call_593974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593974.url(scheme.get, call_593974.host, call_593974.base,
                         call_593974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593974, url, valid)

proc call*(call_593975: Call_ExpressRoutePortsListByResourceGroup_593968;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## expressRoutePortsListByResourceGroup
  ## List all the ExpressRoutePort resources in the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593976 = newJObject()
  var query_593977 = newJObject()
  add(path_593976, "resourceGroupName", newJString(resourceGroupName))
  add(query_593977, "api-version", newJString(apiVersion))
  add(path_593976, "subscriptionId", newJString(subscriptionId))
  result = call_593975.call(path_593976, query_593977, nil, nil, nil)

var expressRoutePortsListByResourceGroup* = Call_ExpressRoutePortsListByResourceGroup_593968(
    name: "expressRoutePortsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/ExpressRoutePorts",
    validator: validate_ExpressRoutePortsListByResourceGroup_593969, base: "",
    url: url_ExpressRoutePortsListByResourceGroup_593970, schemes: {Scheme.Https})
type
  Call_ExpressRoutePortsCreateOrUpdate_593989 = ref object of OpenApiRestCall_593424
proc url_ExpressRoutePortsCreateOrUpdate_593991(protocol: Scheme; host: string;
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

proc validate_ExpressRoutePortsCreateOrUpdate_593990(path: JsonNode;
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
  var valid_594018 = path.getOrDefault("resourceGroupName")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "resourceGroupName", valid_594018
  var valid_594019 = path.getOrDefault("subscriptionId")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "subscriptionId", valid_594019
  var valid_594020 = path.getOrDefault("expressRoutePortName")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "expressRoutePortName", valid_594020
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594021 = query.getOrDefault("api-version")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "api-version", valid_594021
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

proc call*(call_594023: Call_ExpressRoutePortsCreateOrUpdate_593989;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the specified ExpressRoutePort resource.
  ## 
  let valid = call_594023.validator(path, query, header, formData, body)
  let scheme = call_594023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594023.url(scheme.get, call_594023.host, call_594023.base,
                         call_594023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594023, url, valid)

proc call*(call_594024: Call_ExpressRoutePortsCreateOrUpdate_593989;
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
  var path_594025 = newJObject()
  var query_594026 = newJObject()
  var body_594027 = newJObject()
  add(path_594025, "resourceGroupName", newJString(resourceGroupName))
  add(query_594026, "api-version", newJString(apiVersion))
  add(path_594025, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594027 = parameters
  add(path_594025, "expressRoutePortName", newJString(expressRoutePortName))
  result = call_594024.call(path_594025, query_594026, nil, nil, body_594027)

var expressRoutePortsCreateOrUpdate* = Call_ExpressRoutePortsCreateOrUpdate_593989(
    name: "expressRoutePortsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/ExpressRoutePorts/{expressRoutePortName}",
    validator: validate_ExpressRoutePortsCreateOrUpdate_593990, base: "",
    url: url_ExpressRoutePortsCreateOrUpdate_593991, schemes: {Scheme.Https})
type
  Call_ExpressRoutePortsGet_593978 = ref object of OpenApiRestCall_593424
proc url_ExpressRoutePortsGet_593980(protocol: Scheme; host: string; base: string;
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

proc validate_ExpressRoutePortsGet_593979(path: JsonNode; query: JsonNode;
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
  var valid_593983 = path.getOrDefault("expressRoutePortName")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "expressRoutePortName", valid_593983
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

proc call*(call_593985: Call_ExpressRoutePortsGet_593978; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the requested ExpressRoutePort resource.
  ## 
  let valid = call_593985.validator(path, query, header, formData, body)
  let scheme = call_593985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593985.url(scheme.get, call_593985.host, call_593985.base,
                         call_593985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593985, url, valid)

proc call*(call_593986: Call_ExpressRoutePortsGet_593978;
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
  var path_593987 = newJObject()
  var query_593988 = newJObject()
  add(path_593987, "resourceGroupName", newJString(resourceGroupName))
  add(query_593988, "api-version", newJString(apiVersion))
  add(path_593987, "subscriptionId", newJString(subscriptionId))
  add(path_593987, "expressRoutePortName", newJString(expressRoutePortName))
  result = call_593986.call(path_593987, query_593988, nil, nil, nil)

var expressRoutePortsGet* = Call_ExpressRoutePortsGet_593978(
    name: "expressRoutePortsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/ExpressRoutePorts/{expressRoutePortName}",
    validator: validate_ExpressRoutePortsGet_593979, base: "",
    url: url_ExpressRoutePortsGet_593980, schemes: {Scheme.Https})
type
  Call_ExpressRoutePortsUpdateTags_594039 = ref object of OpenApiRestCall_593424
proc url_ExpressRoutePortsUpdateTags_594041(protocol: Scheme; host: string;
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

proc validate_ExpressRoutePortsUpdateTags_594040(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update ExpressRoutePort tags
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
  var valid_594042 = path.getOrDefault("resourceGroupName")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "resourceGroupName", valid_594042
  var valid_594043 = path.getOrDefault("subscriptionId")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "subscriptionId", valid_594043
  var valid_594044 = path.getOrDefault("expressRoutePortName")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "expressRoutePortName", valid_594044
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594045 = query.getOrDefault("api-version")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "api-version", valid_594045
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

proc call*(call_594047: Call_ExpressRoutePortsUpdateTags_594039; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update ExpressRoutePort tags
  ## 
  let valid = call_594047.validator(path, query, header, formData, body)
  let scheme = call_594047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594047.url(scheme.get, call_594047.host, call_594047.base,
                         call_594047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594047, url, valid)

proc call*(call_594048: Call_ExpressRoutePortsUpdateTags_594039;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; expressRoutePortName: string): Recallable =
  ## expressRoutePortsUpdateTags
  ## Update ExpressRoutePort tags
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
  var path_594049 = newJObject()
  var query_594050 = newJObject()
  var body_594051 = newJObject()
  add(path_594049, "resourceGroupName", newJString(resourceGroupName))
  add(query_594050, "api-version", newJString(apiVersion))
  add(path_594049, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594051 = parameters
  add(path_594049, "expressRoutePortName", newJString(expressRoutePortName))
  result = call_594048.call(path_594049, query_594050, nil, nil, body_594051)

var expressRoutePortsUpdateTags* = Call_ExpressRoutePortsUpdateTags_594039(
    name: "expressRoutePortsUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/ExpressRoutePorts/{expressRoutePortName}",
    validator: validate_ExpressRoutePortsUpdateTags_594040, base: "",
    url: url_ExpressRoutePortsUpdateTags_594041, schemes: {Scheme.Https})
type
  Call_ExpressRoutePortsDelete_594028 = ref object of OpenApiRestCall_593424
proc url_ExpressRoutePortsDelete_594030(protocol: Scheme; host: string; base: string;
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

proc validate_ExpressRoutePortsDelete_594029(path: JsonNode; query: JsonNode;
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
  var valid_594031 = path.getOrDefault("resourceGroupName")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "resourceGroupName", valid_594031
  var valid_594032 = path.getOrDefault("subscriptionId")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "subscriptionId", valid_594032
  var valid_594033 = path.getOrDefault("expressRoutePortName")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "expressRoutePortName", valid_594033
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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

proc call*(call_594035: Call_ExpressRoutePortsDelete_594028; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified ExpressRoutePort resource.
  ## 
  let valid = call_594035.validator(path, query, header, formData, body)
  let scheme = call_594035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594035.url(scheme.get, call_594035.host, call_594035.base,
                         call_594035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594035, url, valid)

proc call*(call_594036: Call_ExpressRoutePortsDelete_594028;
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
  var path_594037 = newJObject()
  var query_594038 = newJObject()
  add(path_594037, "resourceGroupName", newJString(resourceGroupName))
  add(query_594038, "api-version", newJString(apiVersion))
  add(path_594037, "subscriptionId", newJString(subscriptionId))
  add(path_594037, "expressRoutePortName", newJString(expressRoutePortName))
  result = call_594036.call(path_594037, query_594038, nil, nil, nil)

var expressRoutePortsDelete* = Call_ExpressRoutePortsDelete_594028(
    name: "expressRoutePortsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/ExpressRoutePorts/{expressRoutePortName}",
    validator: validate_ExpressRoutePortsDelete_594029, base: "",
    url: url_ExpressRoutePortsDelete_594030, schemes: {Scheme.Https})
type
  Call_ExpressRouteLinksList_594052 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteLinksList_594054(protocol: Scheme; host: string; base: string;
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

proc validate_ExpressRouteLinksList_594053(path: JsonNode; query: JsonNode;
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
  var valid_594055 = path.getOrDefault("resourceGroupName")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "resourceGroupName", valid_594055
  var valid_594056 = path.getOrDefault("subscriptionId")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "subscriptionId", valid_594056
  var valid_594057 = path.getOrDefault("expressRoutePortName")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "expressRoutePortName", valid_594057
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594058 = query.getOrDefault("api-version")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "api-version", valid_594058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594059: Call_ExpressRouteLinksList_594052; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the ExpressRouteLink sub-resources of the specified ExpressRoutePort resource.
  ## 
  let valid = call_594059.validator(path, query, header, formData, body)
  let scheme = call_594059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594059.url(scheme.get, call_594059.host, call_594059.base,
                         call_594059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594059, url, valid)

proc call*(call_594060: Call_ExpressRouteLinksList_594052;
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
  var path_594061 = newJObject()
  var query_594062 = newJObject()
  add(path_594061, "resourceGroupName", newJString(resourceGroupName))
  add(query_594062, "api-version", newJString(apiVersion))
  add(path_594061, "subscriptionId", newJString(subscriptionId))
  add(path_594061, "expressRoutePortName", newJString(expressRoutePortName))
  result = call_594060.call(path_594061, query_594062, nil, nil, nil)

var expressRouteLinksList* = Call_ExpressRouteLinksList_594052(
    name: "expressRouteLinksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/ExpressRoutePorts/{expressRoutePortName}/links",
    validator: validate_ExpressRouteLinksList_594053, base: "",
    url: url_ExpressRouteLinksList_594054, schemes: {Scheme.Https})
type
  Call_ExpressRouteLinksGet_594063 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteLinksGet_594065(protocol: Scheme; host: string; base: string;
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

proc validate_ExpressRouteLinksGet_594064(path: JsonNode; query: JsonNode;
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
  var valid_594066 = path.getOrDefault("resourceGroupName")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "resourceGroupName", valid_594066
  var valid_594067 = path.getOrDefault("subscriptionId")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "subscriptionId", valid_594067
  var valid_594068 = path.getOrDefault("linkName")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "linkName", valid_594068
  var valid_594069 = path.getOrDefault("expressRoutePortName")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "expressRoutePortName", valid_594069
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594070 = query.getOrDefault("api-version")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "api-version", valid_594070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594071: Call_ExpressRouteLinksGet_594063; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified ExpressRouteLink resource.
  ## 
  let valid = call_594071.validator(path, query, header, formData, body)
  let scheme = call_594071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594071.url(scheme.get, call_594071.host, call_594071.base,
                         call_594071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594071, url, valid)

proc call*(call_594072: Call_ExpressRouteLinksGet_594063;
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
  var path_594073 = newJObject()
  var query_594074 = newJObject()
  add(path_594073, "resourceGroupName", newJString(resourceGroupName))
  add(query_594074, "api-version", newJString(apiVersion))
  add(path_594073, "subscriptionId", newJString(subscriptionId))
  add(path_594073, "linkName", newJString(linkName))
  add(path_594073, "expressRoutePortName", newJString(expressRoutePortName))
  result = call_594072.call(path_594073, query_594074, nil, nil, nil)

var expressRouteLinksGet* = Call_ExpressRouteLinksGet_594063(
    name: "expressRouteLinksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/ExpressRoutePorts/{expressRoutePortName}/links/{linkName}",
    validator: validate_ExpressRouteLinksGet_594064, base: "",
    url: url_ExpressRouteLinksGet_594065, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
