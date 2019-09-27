
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ExpressRouteCrossConnection REST APIs
## version: 2019-02-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Microsoft Azure ExpressRouteCrossConnection Resource Provider REST APIs describes the operations for the connectivity provider to provision ExpressRoute circuit, create and modify BGP peering entities and troubleshoot connectivity on customer's ExpressRoute circuit. 
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
  macServiceName = "network-expressRouteCrossConnection"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ExpressRouteCrossConnectionsList_593646 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCrossConnectionsList_593648(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Network/expressRouteCrossConnections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCrossConnectionsList_593647(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the ExpressRouteCrossConnections in a subscription.
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

proc call*(call_593836: Call_ExpressRouteCrossConnectionsList_593646;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all the ExpressRouteCrossConnections in a subscription.
  ## 
  let valid = call_593836.validator(path, query, header, formData, body)
  let scheme = call_593836.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593836.url(scheme.get, call_593836.host, call_593836.base,
                         call_593836.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593836, url, valid)

proc call*(call_593907: Call_ExpressRouteCrossConnectionsList_593646;
          apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteCrossConnectionsList
  ## Retrieves all the ExpressRouteCrossConnections in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593908 = newJObject()
  var query_593910 = newJObject()
  add(query_593910, "api-version", newJString(apiVersion))
  add(path_593908, "subscriptionId", newJString(subscriptionId))
  result = call_593907.call(path_593908, query_593910, nil, nil, nil)

var expressRouteCrossConnectionsList* = Call_ExpressRouteCrossConnectionsList_593646(
    name: "expressRouteCrossConnectionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/expressRouteCrossConnections",
    validator: validate_ExpressRouteCrossConnectionsList_593647, base: "",
    url: url_ExpressRouteCrossConnectionsList_593648, schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionsListByResourceGroup_593949 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCrossConnectionsListByResourceGroup_593951(protocol: Scheme;
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
        value: "/providers/Microsoft.Network/expressRouteCrossConnections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCrossConnectionsListByResourceGroup_593950(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves all the ExpressRouteCrossConnections in a resource group.
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
  var valid_593952 = path.getOrDefault("resourceGroupName")
  valid_593952 = validateParameter(valid_593952, JString, required = true,
                                 default = nil)
  if valid_593952 != nil:
    section.add "resourceGroupName", valid_593952
  var valid_593953 = path.getOrDefault("subscriptionId")
  valid_593953 = validateParameter(valid_593953, JString, required = true,
                                 default = nil)
  if valid_593953 != nil:
    section.add "subscriptionId", valid_593953
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593954 = query.getOrDefault("api-version")
  valid_593954 = validateParameter(valid_593954, JString, required = true,
                                 default = nil)
  if valid_593954 != nil:
    section.add "api-version", valid_593954
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593955: Call_ExpressRouteCrossConnectionsListByResourceGroup_593949;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all the ExpressRouteCrossConnections in a resource group.
  ## 
  let valid = call_593955.validator(path, query, header, formData, body)
  let scheme = call_593955.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593955.url(scheme.get, call_593955.host, call_593955.base,
                         call_593955.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593955, url, valid)

proc call*(call_593956: Call_ExpressRouteCrossConnectionsListByResourceGroup_593949;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteCrossConnectionsListByResourceGroup
  ## Retrieves all the ExpressRouteCrossConnections in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593957 = newJObject()
  var query_593958 = newJObject()
  add(path_593957, "resourceGroupName", newJString(resourceGroupName))
  add(query_593958, "api-version", newJString(apiVersion))
  add(path_593957, "subscriptionId", newJString(subscriptionId))
  result = call_593956.call(path_593957, query_593958, nil, nil, nil)

var expressRouteCrossConnectionsListByResourceGroup* = Call_ExpressRouteCrossConnectionsListByResourceGroup_593949(
    name: "expressRouteCrossConnectionsListByResourceGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections",
    validator: validate_ExpressRouteCrossConnectionsListByResourceGroup_593950,
    base: "", url: url_ExpressRouteCrossConnectionsListByResourceGroup_593951,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionsCreateOrUpdate_593970 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCrossConnectionsCreateOrUpdate_593972(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "crossConnectionName" in path,
        "`crossConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteCrossConnections/"),
               (kind: VariableSegment, value: "crossConnectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCrossConnectionsCreateOrUpdate_593971(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the specified ExpressRouteCrossConnection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   crossConnectionName: JString (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `crossConnectionName` field"
  var valid_593999 = path.getOrDefault("crossConnectionName")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "crossConnectionName", valid_593999
  var valid_594000 = path.getOrDefault("resourceGroupName")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "resourceGroupName", valid_594000
  var valid_594001 = path.getOrDefault("subscriptionId")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "subscriptionId", valid_594001
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594002 = query.getOrDefault("api-version")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "api-version", valid_594002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update express route crossConnection operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594004: Call_ExpressRouteCrossConnectionsCreateOrUpdate_593970;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the specified ExpressRouteCrossConnection.
  ## 
  let valid = call_594004.validator(path, query, header, formData, body)
  let scheme = call_594004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594004.url(scheme.get, call_594004.host, call_594004.base,
                         call_594004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594004, url, valid)

proc call*(call_594005: Call_ExpressRouteCrossConnectionsCreateOrUpdate_593970;
          crossConnectionName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## expressRouteCrossConnectionsCreateOrUpdate
  ## Update the specified ExpressRouteCrossConnection.
  ##   crossConnectionName: string (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update express route crossConnection operation.
  var path_594006 = newJObject()
  var query_594007 = newJObject()
  var body_594008 = newJObject()
  add(path_594006, "crossConnectionName", newJString(crossConnectionName))
  add(path_594006, "resourceGroupName", newJString(resourceGroupName))
  add(query_594007, "api-version", newJString(apiVersion))
  add(path_594006, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594008 = parameters
  result = call_594005.call(path_594006, query_594007, nil, nil, body_594008)

var expressRouteCrossConnectionsCreateOrUpdate* = Call_ExpressRouteCrossConnectionsCreateOrUpdate_593970(
    name: "expressRouteCrossConnectionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}",
    validator: validate_ExpressRouteCrossConnectionsCreateOrUpdate_593971,
    base: "", url: url_ExpressRouteCrossConnectionsCreateOrUpdate_593972,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionsGet_593959 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCrossConnectionsGet_593961(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "crossConnectionName" in path,
        "`crossConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteCrossConnections/"),
               (kind: VariableSegment, value: "crossConnectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCrossConnectionsGet_593960(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets details about the specified ExpressRouteCrossConnection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   crossConnectionName: JString (required)
  ##                      : The name of the ExpressRouteCrossConnection (service key of the circuit).
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group (peering location of the circuit).
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `crossConnectionName` field"
  var valid_593962 = path.getOrDefault("crossConnectionName")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "crossConnectionName", valid_593962
  var valid_593963 = path.getOrDefault("resourceGroupName")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "resourceGroupName", valid_593963
  var valid_593964 = path.getOrDefault("subscriptionId")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "subscriptionId", valid_593964
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593965 = query.getOrDefault("api-version")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "api-version", valid_593965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593966: Call_ExpressRouteCrossConnectionsGet_593959;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets details about the specified ExpressRouteCrossConnection.
  ## 
  let valid = call_593966.validator(path, query, header, formData, body)
  let scheme = call_593966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593966.url(scheme.get, call_593966.host, call_593966.base,
                         call_593966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593966, url, valid)

proc call*(call_593967: Call_ExpressRouteCrossConnectionsGet_593959;
          crossConnectionName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteCrossConnectionsGet
  ## Gets details about the specified ExpressRouteCrossConnection.
  ##   crossConnectionName: string (required)
  ##                      : The name of the ExpressRouteCrossConnection (service key of the circuit).
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group (peering location of the circuit).
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593968 = newJObject()
  var query_593969 = newJObject()
  add(path_593968, "crossConnectionName", newJString(crossConnectionName))
  add(path_593968, "resourceGroupName", newJString(resourceGroupName))
  add(query_593969, "api-version", newJString(apiVersion))
  add(path_593968, "subscriptionId", newJString(subscriptionId))
  result = call_593967.call(path_593968, query_593969, nil, nil, nil)

var expressRouteCrossConnectionsGet* = Call_ExpressRouteCrossConnectionsGet_593959(
    name: "expressRouteCrossConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}",
    validator: validate_ExpressRouteCrossConnectionsGet_593960, base: "",
    url: url_ExpressRouteCrossConnectionsGet_593961, schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionsUpdateTags_594009 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCrossConnectionsUpdateTags_594011(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "crossConnectionName" in path,
        "`crossConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteCrossConnections/"),
               (kind: VariableSegment, value: "crossConnectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCrossConnectionsUpdateTags_594010(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an express route cross connection tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   crossConnectionName: JString (required)
  ##                      : The name of the cross connection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `crossConnectionName` field"
  var valid_594012 = path.getOrDefault("crossConnectionName")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "crossConnectionName", valid_594012
  var valid_594013 = path.getOrDefault("resourceGroupName")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "resourceGroupName", valid_594013
  var valid_594014 = path.getOrDefault("subscriptionId")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "subscriptionId", valid_594014
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594015 = query.getOrDefault("api-version")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "api-version", valid_594015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   crossConnectionParameters: JObject (required)
  ##                            : Parameters supplied to update express route cross connection tags.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594017: Call_ExpressRouteCrossConnectionsUpdateTags_594009;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an express route cross connection tags.
  ## 
  let valid = call_594017.validator(path, query, header, formData, body)
  let scheme = call_594017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594017.url(scheme.get, call_594017.host, call_594017.base,
                         call_594017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594017, url, valid)

proc call*(call_594018: Call_ExpressRouteCrossConnectionsUpdateTags_594009;
          crossConnectionName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string;
          crossConnectionParameters: JsonNode): Recallable =
  ## expressRouteCrossConnectionsUpdateTags
  ## Updates an express route cross connection tags.
  ##   crossConnectionName: string (required)
  ##                      : The name of the cross connection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   crossConnectionParameters: JObject (required)
  ##                            : Parameters supplied to update express route cross connection tags.
  var path_594019 = newJObject()
  var query_594020 = newJObject()
  var body_594021 = newJObject()
  add(path_594019, "crossConnectionName", newJString(crossConnectionName))
  add(path_594019, "resourceGroupName", newJString(resourceGroupName))
  add(query_594020, "api-version", newJString(apiVersion))
  add(path_594019, "subscriptionId", newJString(subscriptionId))
  if crossConnectionParameters != nil:
    body_594021 = crossConnectionParameters
  result = call_594018.call(path_594019, query_594020, nil, nil, body_594021)

var expressRouteCrossConnectionsUpdateTags* = Call_ExpressRouteCrossConnectionsUpdateTags_594009(
    name: "expressRouteCrossConnectionsUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}",
    validator: validate_ExpressRouteCrossConnectionsUpdateTags_594010, base: "",
    url: url_ExpressRouteCrossConnectionsUpdateTags_594011,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionPeeringsList_594022 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCrossConnectionPeeringsList_594024(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "crossConnectionName" in path,
        "`crossConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteCrossConnections/"),
               (kind: VariableSegment, value: "crossConnectionName"),
               (kind: ConstantSegment, value: "/peerings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCrossConnectionPeeringsList_594023(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all peerings in a specified ExpressRouteCrossConnection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   crossConnectionName: JString (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `crossConnectionName` field"
  var valid_594025 = path.getOrDefault("crossConnectionName")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "crossConnectionName", valid_594025
  var valid_594026 = path.getOrDefault("resourceGroupName")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "resourceGroupName", valid_594026
  var valid_594027 = path.getOrDefault("subscriptionId")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "subscriptionId", valid_594027
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594028 = query.getOrDefault("api-version")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "api-version", valid_594028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594029: Call_ExpressRouteCrossConnectionPeeringsList_594022;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all peerings in a specified ExpressRouteCrossConnection.
  ## 
  let valid = call_594029.validator(path, query, header, formData, body)
  let scheme = call_594029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594029.url(scheme.get, call_594029.host, call_594029.base,
                         call_594029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594029, url, valid)

proc call*(call_594030: Call_ExpressRouteCrossConnectionPeeringsList_594022;
          crossConnectionName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteCrossConnectionPeeringsList
  ## Gets all peerings in a specified ExpressRouteCrossConnection.
  ##   crossConnectionName: string (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594031 = newJObject()
  var query_594032 = newJObject()
  add(path_594031, "crossConnectionName", newJString(crossConnectionName))
  add(path_594031, "resourceGroupName", newJString(resourceGroupName))
  add(query_594032, "api-version", newJString(apiVersion))
  add(path_594031, "subscriptionId", newJString(subscriptionId))
  result = call_594030.call(path_594031, query_594032, nil, nil, nil)

var expressRouteCrossConnectionPeeringsList* = Call_ExpressRouteCrossConnectionPeeringsList_594022(
    name: "expressRouteCrossConnectionPeeringsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}/peerings",
    validator: validate_ExpressRouteCrossConnectionPeeringsList_594023, base: "",
    url: url_ExpressRouteCrossConnectionPeeringsList_594024,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_594045 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_594047(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "crossConnectionName" in path,
        "`crossConnectionName` is a required path parameter"
  assert "peeringName" in path, "`peeringName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteCrossConnections/"),
               (kind: VariableSegment, value: "crossConnectionName"),
               (kind: ConstantSegment, value: "/peerings/"),
               (kind: VariableSegment, value: "peeringName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_594046(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates or updates a peering in the specified ExpressRouteCrossConnection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   crossConnectionName: JString (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `crossConnectionName` field"
  var valid_594048 = path.getOrDefault("crossConnectionName")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "crossConnectionName", valid_594048
  var valid_594049 = path.getOrDefault("resourceGroupName")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "resourceGroupName", valid_594049
  var valid_594050 = path.getOrDefault("peeringName")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "peeringName", valid_594050
  var valid_594051 = path.getOrDefault("subscriptionId")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "subscriptionId", valid_594051
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594052 = query.getOrDefault("api-version")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "api-version", valid_594052
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   peeringParameters: JObject (required)
  ##                    : Parameters supplied to the create or update ExpressRouteCrossConnection peering operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594054: Call_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_594045;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a peering in the specified ExpressRouteCrossConnection.
  ## 
  let valid = call_594054.validator(path, query, header, formData, body)
  let scheme = call_594054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594054.url(scheme.get, call_594054.host, call_594054.base,
                         call_594054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594054, url, valid)

proc call*(call_594055: Call_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_594045;
          crossConnectionName: string; resourceGroupName: string;
          apiVersion: string; peeringName: string; subscriptionId: string;
          peeringParameters: JsonNode): Recallable =
  ## expressRouteCrossConnectionPeeringsCreateOrUpdate
  ## Creates or updates a peering in the specified ExpressRouteCrossConnection.
  ##   crossConnectionName: string (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   peeringParameters: JObject (required)
  ##                    : Parameters supplied to the create or update ExpressRouteCrossConnection peering operation.
  var path_594056 = newJObject()
  var query_594057 = newJObject()
  var body_594058 = newJObject()
  add(path_594056, "crossConnectionName", newJString(crossConnectionName))
  add(path_594056, "resourceGroupName", newJString(resourceGroupName))
  add(query_594057, "api-version", newJString(apiVersion))
  add(path_594056, "peeringName", newJString(peeringName))
  add(path_594056, "subscriptionId", newJString(subscriptionId))
  if peeringParameters != nil:
    body_594058 = peeringParameters
  result = call_594055.call(path_594056, query_594057, nil, nil, body_594058)

var expressRouteCrossConnectionPeeringsCreateOrUpdate* = Call_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_594045(
    name: "expressRouteCrossConnectionPeeringsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_594046,
    base: "", url: url_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_594047,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionPeeringsGet_594033 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCrossConnectionPeeringsGet_594035(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "crossConnectionName" in path,
        "`crossConnectionName` is a required path parameter"
  assert "peeringName" in path, "`peeringName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteCrossConnections/"),
               (kind: VariableSegment, value: "crossConnectionName"),
               (kind: ConstantSegment, value: "/peerings/"),
               (kind: VariableSegment, value: "peeringName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCrossConnectionPeeringsGet_594034(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified peering for the ExpressRouteCrossConnection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   crossConnectionName: JString (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `crossConnectionName` field"
  var valid_594036 = path.getOrDefault("crossConnectionName")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "crossConnectionName", valid_594036
  var valid_594037 = path.getOrDefault("resourceGroupName")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "resourceGroupName", valid_594037
  var valid_594038 = path.getOrDefault("peeringName")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "peeringName", valid_594038
  var valid_594039 = path.getOrDefault("subscriptionId")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "subscriptionId", valid_594039
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594040 = query.getOrDefault("api-version")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "api-version", valid_594040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594041: Call_ExpressRouteCrossConnectionPeeringsGet_594033;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified peering for the ExpressRouteCrossConnection.
  ## 
  let valid = call_594041.validator(path, query, header, formData, body)
  let scheme = call_594041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594041.url(scheme.get, call_594041.host, call_594041.base,
                         call_594041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594041, url, valid)

proc call*(call_594042: Call_ExpressRouteCrossConnectionPeeringsGet_594033;
          crossConnectionName: string; resourceGroupName: string;
          apiVersion: string; peeringName: string; subscriptionId: string): Recallable =
  ## expressRouteCrossConnectionPeeringsGet
  ## Gets the specified peering for the ExpressRouteCrossConnection.
  ##   crossConnectionName: string (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594043 = newJObject()
  var query_594044 = newJObject()
  add(path_594043, "crossConnectionName", newJString(crossConnectionName))
  add(path_594043, "resourceGroupName", newJString(resourceGroupName))
  add(query_594044, "api-version", newJString(apiVersion))
  add(path_594043, "peeringName", newJString(peeringName))
  add(path_594043, "subscriptionId", newJString(subscriptionId))
  result = call_594042.call(path_594043, query_594044, nil, nil, nil)

var expressRouteCrossConnectionPeeringsGet* = Call_ExpressRouteCrossConnectionPeeringsGet_594033(
    name: "expressRouteCrossConnectionPeeringsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCrossConnectionPeeringsGet_594034, base: "",
    url: url_ExpressRouteCrossConnectionPeeringsGet_594035,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionPeeringsDelete_594059 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCrossConnectionPeeringsDelete_594061(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "crossConnectionName" in path,
        "`crossConnectionName` is a required path parameter"
  assert "peeringName" in path, "`peeringName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteCrossConnections/"),
               (kind: VariableSegment, value: "crossConnectionName"),
               (kind: ConstantSegment, value: "/peerings/"),
               (kind: VariableSegment, value: "peeringName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCrossConnectionPeeringsDelete_594060(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified peering from the ExpressRouteCrossConnection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   crossConnectionName: JString (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `crossConnectionName` field"
  var valid_594062 = path.getOrDefault("crossConnectionName")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "crossConnectionName", valid_594062
  var valid_594063 = path.getOrDefault("resourceGroupName")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "resourceGroupName", valid_594063
  var valid_594064 = path.getOrDefault("peeringName")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "peeringName", valid_594064
  var valid_594065 = path.getOrDefault("subscriptionId")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "subscriptionId", valid_594065
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594066 = query.getOrDefault("api-version")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "api-version", valid_594066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594067: Call_ExpressRouteCrossConnectionPeeringsDelete_594059;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified peering from the ExpressRouteCrossConnection.
  ## 
  let valid = call_594067.validator(path, query, header, formData, body)
  let scheme = call_594067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594067.url(scheme.get, call_594067.host, call_594067.base,
                         call_594067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594067, url, valid)

proc call*(call_594068: Call_ExpressRouteCrossConnectionPeeringsDelete_594059;
          crossConnectionName: string; resourceGroupName: string;
          apiVersion: string; peeringName: string; subscriptionId: string): Recallable =
  ## expressRouteCrossConnectionPeeringsDelete
  ## Deletes the specified peering from the ExpressRouteCrossConnection.
  ##   crossConnectionName: string (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594069 = newJObject()
  var query_594070 = newJObject()
  add(path_594069, "crossConnectionName", newJString(crossConnectionName))
  add(path_594069, "resourceGroupName", newJString(resourceGroupName))
  add(query_594070, "api-version", newJString(apiVersion))
  add(path_594069, "peeringName", newJString(peeringName))
  add(path_594069, "subscriptionId", newJString(subscriptionId))
  result = call_594068.call(path_594069, query_594070, nil, nil, nil)

var expressRouteCrossConnectionPeeringsDelete* = Call_ExpressRouteCrossConnectionPeeringsDelete_594059(
    name: "expressRouteCrossConnectionPeeringsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCrossConnectionPeeringsDelete_594060,
    base: "", url: url_ExpressRouteCrossConnectionPeeringsDelete_594061,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionsListArpTable_594071 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCrossConnectionsListArpTable_594073(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "crossConnectionName" in path,
        "`crossConnectionName` is a required path parameter"
  assert "peeringName" in path, "`peeringName` is a required path parameter"
  assert "devicePath" in path, "`devicePath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteCrossConnections/"),
               (kind: VariableSegment, value: "crossConnectionName"),
               (kind: ConstantSegment, value: "/peerings/"),
               (kind: VariableSegment, value: "peeringName"),
               (kind: ConstantSegment, value: "/arpTables/"),
               (kind: VariableSegment, value: "devicePath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCrossConnectionsListArpTable_594072(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the currently advertised ARP table associated with the express route cross connection in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   crossConnectionName: JString (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   devicePath: JString (required)
  ##             : The path of the device
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `crossConnectionName` field"
  var valid_594074 = path.getOrDefault("crossConnectionName")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "crossConnectionName", valid_594074
  var valid_594075 = path.getOrDefault("resourceGroupName")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "resourceGroupName", valid_594075
  var valid_594076 = path.getOrDefault("peeringName")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "peeringName", valid_594076
  var valid_594077 = path.getOrDefault("subscriptionId")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "subscriptionId", valid_594077
  var valid_594078 = path.getOrDefault("devicePath")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "devicePath", valid_594078
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594079 = query.getOrDefault("api-version")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "api-version", valid_594079
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594080: Call_ExpressRouteCrossConnectionsListArpTable_594071;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the currently advertised ARP table associated with the express route cross connection in a resource group.
  ## 
  let valid = call_594080.validator(path, query, header, formData, body)
  let scheme = call_594080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594080.url(scheme.get, call_594080.host, call_594080.base,
                         call_594080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594080, url, valid)

proc call*(call_594081: Call_ExpressRouteCrossConnectionsListArpTable_594071;
          crossConnectionName: string; resourceGroupName: string;
          apiVersion: string; peeringName: string; subscriptionId: string;
          devicePath: string): Recallable =
  ## expressRouteCrossConnectionsListArpTable
  ## Gets the currently advertised ARP table associated with the express route cross connection in a resource group.
  ##   crossConnectionName: string (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   devicePath: string (required)
  ##             : The path of the device
  var path_594082 = newJObject()
  var query_594083 = newJObject()
  add(path_594082, "crossConnectionName", newJString(crossConnectionName))
  add(path_594082, "resourceGroupName", newJString(resourceGroupName))
  add(query_594083, "api-version", newJString(apiVersion))
  add(path_594082, "peeringName", newJString(peeringName))
  add(path_594082, "subscriptionId", newJString(subscriptionId))
  add(path_594082, "devicePath", newJString(devicePath))
  result = call_594081.call(path_594082, query_594083, nil, nil, nil)

var expressRouteCrossConnectionsListArpTable* = Call_ExpressRouteCrossConnectionsListArpTable_594071(
    name: "expressRouteCrossConnectionsListArpTable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}/peerings/{peeringName}/arpTables/{devicePath}",
    validator: validate_ExpressRouteCrossConnectionsListArpTable_594072, base: "",
    url: url_ExpressRouteCrossConnectionsListArpTable_594073,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionsListRoutesTable_594084 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCrossConnectionsListRoutesTable_594086(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "crossConnectionName" in path,
        "`crossConnectionName` is a required path parameter"
  assert "peeringName" in path, "`peeringName` is a required path parameter"
  assert "devicePath" in path, "`devicePath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteCrossConnections/"),
               (kind: VariableSegment, value: "crossConnectionName"),
               (kind: ConstantSegment, value: "/peerings/"),
               (kind: VariableSegment, value: "peeringName"),
               (kind: ConstantSegment, value: "/routeTables/"),
               (kind: VariableSegment, value: "devicePath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCrossConnectionsListRoutesTable_594085(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the currently advertised routes table associated with the express route cross connection in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   crossConnectionName: JString (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   devicePath: JString (required)
  ##             : The path of the device.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `crossConnectionName` field"
  var valid_594087 = path.getOrDefault("crossConnectionName")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "crossConnectionName", valid_594087
  var valid_594088 = path.getOrDefault("resourceGroupName")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "resourceGroupName", valid_594088
  var valid_594089 = path.getOrDefault("peeringName")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "peeringName", valid_594089
  var valid_594090 = path.getOrDefault("subscriptionId")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "subscriptionId", valid_594090
  var valid_594091 = path.getOrDefault("devicePath")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "devicePath", valid_594091
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_594093: Call_ExpressRouteCrossConnectionsListRoutesTable_594084;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the currently advertised routes table associated with the express route cross connection in a resource group.
  ## 
  let valid = call_594093.validator(path, query, header, formData, body)
  let scheme = call_594093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594093.url(scheme.get, call_594093.host, call_594093.base,
                         call_594093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594093, url, valid)

proc call*(call_594094: Call_ExpressRouteCrossConnectionsListRoutesTable_594084;
          crossConnectionName: string; resourceGroupName: string;
          apiVersion: string; peeringName: string; subscriptionId: string;
          devicePath: string): Recallable =
  ## expressRouteCrossConnectionsListRoutesTable
  ## Gets the currently advertised routes table associated with the express route cross connection in a resource group.
  ##   crossConnectionName: string (required)
  ##                      : The name of the ExpressRouteCrossConnection.
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
  var path_594095 = newJObject()
  var query_594096 = newJObject()
  add(path_594095, "crossConnectionName", newJString(crossConnectionName))
  add(path_594095, "resourceGroupName", newJString(resourceGroupName))
  add(query_594096, "api-version", newJString(apiVersion))
  add(path_594095, "peeringName", newJString(peeringName))
  add(path_594095, "subscriptionId", newJString(subscriptionId))
  add(path_594095, "devicePath", newJString(devicePath))
  result = call_594094.call(path_594095, query_594096, nil, nil, nil)

var expressRouteCrossConnectionsListRoutesTable* = Call_ExpressRouteCrossConnectionsListRoutesTable_594084(
    name: "expressRouteCrossConnectionsListRoutesTable",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}/peerings/{peeringName}/routeTables/{devicePath}",
    validator: validate_ExpressRouteCrossConnectionsListRoutesTable_594085,
    base: "", url: url_ExpressRouteCrossConnectionsListRoutesTable_594086,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionsListRoutesTableSummary_594097 = ref object of OpenApiRestCall_593424
proc url_ExpressRouteCrossConnectionsListRoutesTableSummary_594099(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "crossConnectionName" in path,
        "`crossConnectionName` is a required path parameter"
  assert "peeringName" in path, "`peeringName` is a required path parameter"
  assert "devicePath" in path, "`devicePath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/expressRouteCrossConnections/"),
               (kind: VariableSegment, value: "crossConnectionName"),
               (kind: ConstantSegment, value: "/peerings/"),
               (kind: VariableSegment, value: "peeringName"),
               (kind: ConstantSegment, value: "/routeTablesSummary/"),
               (kind: VariableSegment, value: "devicePath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExpressRouteCrossConnectionsListRoutesTableSummary_594098(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the route table summary associated with the express route cross connection in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   crossConnectionName: JString (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   devicePath: JString (required)
  ##             : The path of the device.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `crossConnectionName` field"
  var valid_594100 = path.getOrDefault("crossConnectionName")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "crossConnectionName", valid_594100
  var valid_594101 = path.getOrDefault("resourceGroupName")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "resourceGroupName", valid_594101
  var valid_594102 = path.getOrDefault("peeringName")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "peeringName", valid_594102
  var valid_594103 = path.getOrDefault("subscriptionId")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "subscriptionId", valid_594103
  var valid_594104 = path.getOrDefault("devicePath")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "devicePath", valid_594104
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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

proc call*(call_594106: Call_ExpressRouteCrossConnectionsListRoutesTableSummary_594097;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the route table summary associated with the express route cross connection in a resource group.
  ## 
  let valid = call_594106.validator(path, query, header, formData, body)
  let scheme = call_594106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594106.url(scheme.get, call_594106.host, call_594106.base,
                         call_594106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594106, url, valid)

proc call*(call_594107: Call_ExpressRouteCrossConnectionsListRoutesTableSummary_594097;
          crossConnectionName: string; resourceGroupName: string;
          apiVersion: string; peeringName: string; subscriptionId: string;
          devicePath: string): Recallable =
  ## expressRouteCrossConnectionsListRoutesTableSummary
  ## Gets the route table summary associated with the express route cross connection in a resource group.
  ##   crossConnectionName: string (required)
  ##                      : The name of the ExpressRouteCrossConnection.
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
  var path_594108 = newJObject()
  var query_594109 = newJObject()
  add(path_594108, "crossConnectionName", newJString(crossConnectionName))
  add(path_594108, "resourceGroupName", newJString(resourceGroupName))
  add(query_594109, "api-version", newJString(apiVersion))
  add(path_594108, "peeringName", newJString(peeringName))
  add(path_594108, "subscriptionId", newJString(subscriptionId))
  add(path_594108, "devicePath", newJString(devicePath))
  result = call_594107.call(path_594108, query_594109, nil, nil, nil)

var expressRouteCrossConnectionsListRoutesTableSummary* = Call_ExpressRouteCrossConnectionsListRoutesTableSummary_594097(
    name: "expressRouteCrossConnectionsListRoutesTableSummary",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}/peerings/{peeringName}/routeTablesSummary/{devicePath}",
    validator: validate_ExpressRouteCrossConnectionsListRoutesTableSummary_594098,
    base: "", url: url_ExpressRouteCrossConnectionsListRoutesTableSummary_594099,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
