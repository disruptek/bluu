
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ExpressRouteCrossConnection REST APIs
## version: 2018-12-01
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
  macServiceName = "network-expressRouteCrossConnection"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ExpressRouteCrossConnectionsList_563777 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCrossConnectionsList_563779(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCrossConnectionsList_563778(path: JsonNode;
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

proc call*(call_563969: Call_ExpressRouteCrossConnectionsList_563777;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all the ExpressRouteCrossConnections in a subscription.
  ## 
  let valid = call_563969.validator(path, query, header, formData, body)
  let scheme = call_563969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563969.url(scheme.get, call_563969.host, call_563969.base,
                         call_563969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563969, url, valid)

proc call*(call_564040: Call_ExpressRouteCrossConnectionsList_563777;
          apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteCrossConnectionsList
  ## Retrieves all the ExpressRouteCrossConnections in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564041 = newJObject()
  var query_564043 = newJObject()
  add(query_564043, "api-version", newJString(apiVersion))
  add(path_564041, "subscriptionId", newJString(subscriptionId))
  result = call_564040.call(path_564041, query_564043, nil, nil, nil)

var expressRouteCrossConnectionsList* = Call_ExpressRouteCrossConnectionsList_563777(
    name: "expressRouteCrossConnectionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/expressRouteCrossConnections",
    validator: validate_ExpressRouteCrossConnectionsList_563778, base: "",
    url: url_ExpressRouteCrossConnectionsList_563779, schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionsListByResourceGroup_564082 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCrossConnectionsListByResourceGroup_564084(protocol: Scheme;
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

proc validate_ExpressRouteCrossConnectionsListByResourceGroup_564083(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves all the ExpressRouteCrossConnections in a resource group.
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
  var valid_564085 = path.getOrDefault("subscriptionId")
  valid_564085 = validateParameter(valid_564085, JString, required = true,
                                 default = nil)
  if valid_564085 != nil:
    section.add "subscriptionId", valid_564085
  var valid_564086 = path.getOrDefault("resourceGroupName")
  valid_564086 = validateParameter(valid_564086, JString, required = true,
                                 default = nil)
  if valid_564086 != nil:
    section.add "resourceGroupName", valid_564086
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564087 = query.getOrDefault("api-version")
  valid_564087 = validateParameter(valid_564087, JString, required = true,
                                 default = nil)
  if valid_564087 != nil:
    section.add "api-version", valid_564087
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564088: Call_ExpressRouteCrossConnectionsListByResourceGroup_564082;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all the ExpressRouteCrossConnections in a resource group.
  ## 
  let valid = call_564088.validator(path, query, header, formData, body)
  let scheme = call_564088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564088.url(scheme.get, call_564088.host, call_564088.base,
                         call_564088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564088, url, valid)

proc call*(call_564089: Call_ExpressRouteCrossConnectionsListByResourceGroup_564082;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## expressRouteCrossConnectionsListByResourceGroup
  ## Retrieves all the ExpressRouteCrossConnections in a resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564090 = newJObject()
  var query_564091 = newJObject()
  add(query_564091, "api-version", newJString(apiVersion))
  add(path_564090, "subscriptionId", newJString(subscriptionId))
  add(path_564090, "resourceGroupName", newJString(resourceGroupName))
  result = call_564089.call(path_564090, query_564091, nil, nil, nil)

var expressRouteCrossConnectionsListByResourceGroup* = Call_ExpressRouteCrossConnectionsListByResourceGroup_564082(
    name: "expressRouteCrossConnectionsListByResourceGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections",
    validator: validate_ExpressRouteCrossConnectionsListByResourceGroup_564083,
    base: "", url: url_ExpressRouteCrossConnectionsListByResourceGroup_564084,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionsCreateOrUpdate_564103 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCrossConnectionsCreateOrUpdate_564105(protocol: Scheme;
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

proc validate_ExpressRouteCrossConnectionsCreateOrUpdate_564104(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the specified ExpressRouteCrossConnection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   crossConnectionName: JString (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `crossConnectionName` field"
  var valid_564132 = path.getOrDefault("crossConnectionName")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "crossConnectionName", valid_564132
  var valid_564133 = path.getOrDefault("subscriptionId")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "subscriptionId", valid_564133
  var valid_564134 = path.getOrDefault("resourceGroupName")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "resourceGroupName", valid_564134
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564135 = query.getOrDefault("api-version")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "api-version", valid_564135
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

proc call*(call_564137: Call_ExpressRouteCrossConnectionsCreateOrUpdate_564103;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the specified ExpressRouteCrossConnection.
  ## 
  let valid = call_564137.validator(path, query, header, formData, body)
  let scheme = call_564137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564137.url(scheme.get, call_564137.host, call_564137.base,
                         call_564137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564137, url, valid)

proc call*(call_564138: Call_ExpressRouteCrossConnectionsCreateOrUpdate_564103;
          apiVersion: string; crossConnectionName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## expressRouteCrossConnectionsCreateOrUpdate
  ## Update the specified ExpressRouteCrossConnection.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   crossConnectionName: string (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update express route crossConnection operation.
  var path_564139 = newJObject()
  var query_564140 = newJObject()
  var body_564141 = newJObject()
  add(query_564140, "api-version", newJString(apiVersion))
  add(path_564139, "crossConnectionName", newJString(crossConnectionName))
  add(path_564139, "subscriptionId", newJString(subscriptionId))
  add(path_564139, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564141 = parameters
  result = call_564138.call(path_564139, query_564140, nil, nil, body_564141)

var expressRouteCrossConnectionsCreateOrUpdate* = Call_ExpressRouteCrossConnectionsCreateOrUpdate_564103(
    name: "expressRouteCrossConnectionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}",
    validator: validate_ExpressRouteCrossConnectionsCreateOrUpdate_564104,
    base: "", url: url_ExpressRouteCrossConnectionsCreateOrUpdate_564105,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionsGet_564092 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCrossConnectionsGet_564094(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCrossConnectionsGet_564093(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets details about the specified ExpressRouteCrossConnection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   crossConnectionName: JString (required)
  ##                      : The name of the ExpressRouteCrossConnection (service key of the circuit).
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group (peering location of the circuit).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `crossConnectionName` field"
  var valid_564095 = path.getOrDefault("crossConnectionName")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "crossConnectionName", valid_564095
  var valid_564096 = path.getOrDefault("subscriptionId")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "subscriptionId", valid_564096
  var valid_564097 = path.getOrDefault("resourceGroupName")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "resourceGroupName", valid_564097
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564098 = query.getOrDefault("api-version")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "api-version", valid_564098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564099: Call_ExpressRouteCrossConnectionsGet_564092;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets details about the specified ExpressRouteCrossConnection.
  ## 
  let valid = call_564099.validator(path, query, header, formData, body)
  let scheme = call_564099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564099.url(scheme.get, call_564099.host, call_564099.base,
                         call_564099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564099, url, valid)

proc call*(call_564100: Call_ExpressRouteCrossConnectionsGet_564092;
          apiVersion: string; crossConnectionName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## expressRouteCrossConnectionsGet
  ## Gets details about the specified ExpressRouteCrossConnection.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   crossConnectionName: string (required)
  ##                      : The name of the ExpressRouteCrossConnection (service key of the circuit).
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group (peering location of the circuit).
  var path_564101 = newJObject()
  var query_564102 = newJObject()
  add(query_564102, "api-version", newJString(apiVersion))
  add(path_564101, "crossConnectionName", newJString(crossConnectionName))
  add(path_564101, "subscriptionId", newJString(subscriptionId))
  add(path_564101, "resourceGroupName", newJString(resourceGroupName))
  result = call_564100.call(path_564101, query_564102, nil, nil, nil)

var expressRouteCrossConnectionsGet* = Call_ExpressRouteCrossConnectionsGet_564092(
    name: "expressRouteCrossConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}",
    validator: validate_ExpressRouteCrossConnectionsGet_564093, base: "",
    url: url_ExpressRouteCrossConnectionsGet_564094, schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionsUpdateTags_564142 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCrossConnectionsUpdateTags_564144(protocol: Scheme;
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

proc validate_ExpressRouteCrossConnectionsUpdateTags_564143(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an express route cross connection tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   crossConnectionName: JString (required)
  ##                      : The name of the cross connection.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `crossConnectionName` field"
  var valid_564145 = path.getOrDefault("crossConnectionName")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "crossConnectionName", valid_564145
  var valid_564146 = path.getOrDefault("subscriptionId")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "subscriptionId", valid_564146
  var valid_564147 = path.getOrDefault("resourceGroupName")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "resourceGroupName", valid_564147
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564148 = query.getOrDefault("api-version")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "api-version", valid_564148
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

proc call*(call_564150: Call_ExpressRouteCrossConnectionsUpdateTags_564142;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an express route cross connection tags.
  ## 
  let valid = call_564150.validator(path, query, header, formData, body)
  let scheme = call_564150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564150.url(scheme.get, call_564150.host, call_564150.base,
                         call_564150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564150, url, valid)

proc call*(call_564151: Call_ExpressRouteCrossConnectionsUpdateTags_564142;
          crossConnectionParameters: JsonNode; apiVersion: string;
          crossConnectionName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## expressRouteCrossConnectionsUpdateTags
  ## Updates an express route cross connection tags.
  ##   crossConnectionParameters: JObject (required)
  ##                            : Parameters supplied to update express route cross connection tags.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   crossConnectionName: string (required)
  ##                      : The name of the cross connection.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564152 = newJObject()
  var query_564153 = newJObject()
  var body_564154 = newJObject()
  if crossConnectionParameters != nil:
    body_564154 = crossConnectionParameters
  add(query_564153, "api-version", newJString(apiVersion))
  add(path_564152, "crossConnectionName", newJString(crossConnectionName))
  add(path_564152, "subscriptionId", newJString(subscriptionId))
  add(path_564152, "resourceGroupName", newJString(resourceGroupName))
  result = call_564151.call(path_564152, query_564153, nil, nil, body_564154)

var expressRouteCrossConnectionsUpdateTags* = Call_ExpressRouteCrossConnectionsUpdateTags_564142(
    name: "expressRouteCrossConnectionsUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}",
    validator: validate_ExpressRouteCrossConnectionsUpdateTags_564143, base: "",
    url: url_ExpressRouteCrossConnectionsUpdateTags_564144,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionPeeringsList_564155 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCrossConnectionPeeringsList_564157(protocol: Scheme;
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

proc validate_ExpressRouteCrossConnectionPeeringsList_564156(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all peerings in a specified ExpressRouteCrossConnection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   crossConnectionName: JString (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `crossConnectionName` field"
  var valid_564158 = path.getOrDefault("crossConnectionName")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "crossConnectionName", valid_564158
  var valid_564159 = path.getOrDefault("subscriptionId")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "subscriptionId", valid_564159
  var valid_564160 = path.getOrDefault("resourceGroupName")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "resourceGroupName", valid_564160
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564161 = query.getOrDefault("api-version")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "api-version", valid_564161
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564162: Call_ExpressRouteCrossConnectionPeeringsList_564155;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all peerings in a specified ExpressRouteCrossConnection.
  ## 
  let valid = call_564162.validator(path, query, header, formData, body)
  let scheme = call_564162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564162.url(scheme.get, call_564162.host, call_564162.base,
                         call_564162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564162, url, valid)

proc call*(call_564163: Call_ExpressRouteCrossConnectionPeeringsList_564155;
          apiVersion: string; crossConnectionName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## expressRouteCrossConnectionPeeringsList
  ## Gets all peerings in a specified ExpressRouteCrossConnection.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   crossConnectionName: string (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564164 = newJObject()
  var query_564165 = newJObject()
  add(query_564165, "api-version", newJString(apiVersion))
  add(path_564164, "crossConnectionName", newJString(crossConnectionName))
  add(path_564164, "subscriptionId", newJString(subscriptionId))
  add(path_564164, "resourceGroupName", newJString(resourceGroupName))
  result = call_564163.call(path_564164, query_564165, nil, nil, nil)

var expressRouteCrossConnectionPeeringsList* = Call_ExpressRouteCrossConnectionPeeringsList_564155(
    name: "expressRouteCrossConnectionPeeringsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}/peerings",
    validator: validate_ExpressRouteCrossConnectionPeeringsList_564156, base: "",
    url: url_ExpressRouteCrossConnectionPeeringsList_564157,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_564178 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_564180(
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

proc validate_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_564179(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates or updates a peering in the specified ExpressRouteCrossConnection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   crossConnectionName: JString (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `crossConnectionName` field"
  var valid_564181 = path.getOrDefault("crossConnectionName")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "crossConnectionName", valid_564181
  var valid_564182 = path.getOrDefault("peeringName")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "peeringName", valid_564182
  var valid_564183 = path.getOrDefault("subscriptionId")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "subscriptionId", valid_564183
  var valid_564184 = path.getOrDefault("resourceGroupName")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "resourceGroupName", valid_564184
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564185 = query.getOrDefault("api-version")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "api-version", valid_564185
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

proc call*(call_564187: Call_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_564178;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a peering in the specified ExpressRouteCrossConnection.
  ## 
  let valid = call_564187.validator(path, query, header, formData, body)
  let scheme = call_564187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564187.url(scheme.get, call_564187.host, call_564187.base,
                         call_564187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564187, url, valid)

proc call*(call_564188: Call_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_564178;
          apiVersion: string; crossConnectionName: string; peeringName: string;
          subscriptionId: string; resourceGroupName: string;
          peeringParameters: JsonNode): Recallable =
  ## expressRouteCrossConnectionPeeringsCreateOrUpdate
  ## Creates or updates a peering in the specified ExpressRouteCrossConnection.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   crossConnectionName: string (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   peeringParameters: JObject (required)
  ##                    : Parameters supplied to the create or update ExpressRouteCrossConnection peering operation.
  var path_564189 = newJObject()
  var query_564190 = newJObject()
  var body_564191 = newJObject()
  add(query_564190, "api-version", newJString(apiVersion))
  add(path_564189, "crossConnectionName", newJString(crossConnectionName))
  add(path_564189, "peeringName", newJString(peeringName))
  add(path_564189, "subscriptionId", newJString(subscriptionId))
  add(path_564189, "resourceGroupName", newJString(resourceGroupName))
  if peeringParameters != nil:
    body_564191 = peeringParameters
  result = call_564188.call(path_564189, query_564190, nil, nil, body_564191)

var expressRouteCrossConnectionPeeringsCreateOrUpdate* = Call_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_564178(
    name: "expressRouteCrossConnectionPeeringsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_564179,
    base: "", url: url_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_564180,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionPeeringsGet_564166 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCrossConnectionPeeringsGet_564168(protocol: Scheme;
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

proc validate_ExpressRouteCrossConnectionPeeringsGet_564167(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified peering for the ExpressRouteCrossConnection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   crossConnectionName: JString (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `crossConnectionName` field"
  var valid_564169 = path.getOrDefault("crossConnectionName")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "crossConnectionName", valid_564169
  var valid_564170 = path.getOrDefault("peeringName")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "peeringName", valid_564170
  var valid_564171 = path.getOrDefault("subscriptionId")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "subscriptionId", valid_564171
  var valid_564172 = path.getOrDefault("resourceGroupName")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "resourceGroupName", valid_564172
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564173 = query.getOrDefault("api-version")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "api-version", valid_564173
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564174: Call_ExpressRouteCrossConnectionPeeringsGet_564166;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified peering for the ExpressRouteCrossConnection.
  ## 
  let valid = call_564174.validator(path, query, header, formData, body)
  let scheme = call_564174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564174.url(scheme.get, call_564174.host, call_564174.base,
                         call_564174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564174, url, valid)

proc call*(call_564175: Call_ExpressRouteCrossConnectionPeeringsGet_564166;
          apiVersion: string; crossConnectionName: string; peeringName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## expressRouteCrossConnectionPeeringsGet
  ## Gets the specified peering for the ExpressRouteCrossConnection.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   crossConnectionName: string (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564176 = newJObject()
  var query_564177 = newJObject()
  add(query_564177, "api-version", newJString(apiVersion))
  add(path_564176, "crossConnectionName", newJString(crossConnectionName))
  add(path_564176, "peeringName", newJString(peeringName))
  add(path_564176, "subscriptionId", newJString(subscriptionId))
  add(path_564176, "resourceGroupName", newJString(resourceGroupName))
  result = call_564175.call(path_564176, query_564177, nil, nil, nil)

var expressRouteCrossConnectionPeeringsGet* = Call_ExpressRouteCrossConnectionPeeringsGet_564166(
    name: "expressRouteCrossConnectionPeeringsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCrossConnectionPeeringsGet_564167, base: "",
    url: url_ExpressRouteCrossConnectionPeeringsGet_564168,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionPeeringsDelete_564192 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCrossConnectionPeeringsDelete_564194(protocol: Scheme;
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

proc validate_ExpressRouteCrossConnectionPeeringsDelete_564193(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified peering from the ExpressRouteCrossConnection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   crossConnectionName: JString (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `crossConnectionName` field"
  var valid_564195 = path.getOrDefault("crossConnectionName")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "crossConnectionName", valid_564195
  var valid_564196 = path.getOrDefault("peeringName")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "peeringName", valid_564196
  var valid_564197 = path.getOrDefault("subscriptionId")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "subscriptionId", valid_564197
  var valid_564198 = path.getOrDefault("resourceGroupName")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "resourceGroupName", valid_564198
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564199 = query.getOrDefault("api-version")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "api-version", valid_564199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564200: Call_ExpressRouteCrossConnectionPeeringsDelete_564192;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified peering from the ExpressRouteCrossConnection.
  ## 
  let valid = call_564200.validator(path, query, header, formData, body)
  let scheme = call_564200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564200.url(scheme.get, call_564200.host, call_564200.base,
                         call_564200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564200, url, valid)

proc call*(call_564201: Call_ExpressRouteCrossConnectionPeeringsDelete_564192;
          apiVersion: string; crossConnectionName: string; peeringName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## expressRouteCrossConnectionPeeringsDelete
  ## Deletes the specified peering from the ExpressRouteCrossConnection.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   crossConnectionName: string (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564202 = newJObject()
  var query_564203 = newJObject()
  add(query_564203, "api-version", newJString(apiVersion))
  add(path_564202, "crossConnectionName", newJString(crossConnectionName))
  add(path_564202, "peeringName", newJString(peeringName))
  add(path_564202, "subscriptionId", newJString(subscriptionId))
  add(path_564202, "resourceGroupName", newJString(resourceGroupName))
  result = call_564201.call(path_564202, query_564203, nil, nil, nil)

var expressRouteCrossConnectionPeeringsDelete* = Call_ExpressRouteCrossConnectionPeeringsDelete_564192(
    name: "expressRouteCrossConnectionPeeringsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCrossConnectionPeeringsDelete_564193,
    base: "", url: url_ExpressRouteCrossConnectionPeeringsDelete_564194,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionsListArpTable_564204 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCrossConnectionsListArpTable_564206(protocol: Scheme;
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

proc validate_ExpressRouteCrossConnectionsListArpTable_564205(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the currently advertised ARP table associated with the express route cross connection in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   crossConnectionName: JString (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   devicePath: JString (required)
  ##             : The path of the device
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `crossConnectionName` field"
  var valid_564207 = path.getOrDefault("crossConnectionName")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "crossConnectionName", valid_564207
  var valid_564208 = path.getOrDefault("peeringName")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "peeringName", valid_564208
  var valid_564209 = path.getOrDefault("subscriptionId")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "subscriptionId", valid_564209
  var valid_564210 = path.getOrDefault("devicePath")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "devicePath", valid_564210
  var valid_564211 = path.getOrDefault("resourceGroupName")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "resourceGroupName", valid_564211
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564212 = query.getOrDefault("api-version")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "api-version", valid_564212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564213: Call_ExpressRouteCrossConnectionsListArpTable_564204;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the currently advertised ARP table associated with the express route cross connection in a resource group.
  ## 
  let valid = call_564213.validator(path, query, header, formData, body)
  let scheme = call_564213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564213.url(scheme.get, call_564213.host, call_564213.base,
                         call_564213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564213, url, valid)

proc call*(call_564214: Call_ExpressRouteCrossConnectionsListArpTable_564204;
          apiVersion: string; crossConnectionName: string; peeringName: string;
          subscriptionId: string; devicePath: string; resourceGroupName: string): Recallable =
  ## expressRouteCrossConnectionsListArpTable
  ## Gets the currently advertised ARP table associated with the express route cross connection in a resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   crossConnectionName: string (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   devicePath: string (required)
  ##             : The path of the device
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564215 = newJObject()
  var query_564216 = newJObject()
  add(query_564216, "api-version", newJString(apiVersion))
  add(path_564215, "crossConnectionName", newJString(crossConnectionName))
  add(path_564215, "peeringName", newJString(peeringName))
  add(path_564215, "subscriptionId", newJString(subscriptionId))
  add(path_564215, "devicePath", newJString(devicePath))
  add(path_564215, "resourceGroupName", newJString(resourceGroupName))
  result = call_564214.call(path_564215, query_564216, nil, nil, nil)

var expressRouteCrossConnectionsListArpTable* = Call_ExpressRouteCrossConnectionsListArpTable_564204(
    name: "expressRouteCrossConnectionsListArpTable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}/peerings/{peeringName}/arpTables/{devicePath}",
    validator: validate_ExpressRouteCrossConnectionsListArpTable_564205, base: "",
    url: url_ExpressRouteCrossConnectionsListArpTable_564206,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionsListRoutesTable_564217 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCrossConnectionsListRoutesTable_564219(protocol: Scheme;
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

proc validate_ExpressRouteCrossConnectionsListRoutesTable_564218(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the currently advertised routes table associated with the express route cross connection in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   crossConnectionName: JString (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   devicePath: JString (required)
  ##             : The path of the device.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `crossConnectionName` field"
  var valid_564220 = path.getOrDefault("crossConnectionName")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "crossConnectionName", valid_564220
  var valid_564221 = path.getOrDefault("peeringName")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "peeringName", valid_564221
  var valid_564222 = path.getOrDefault("subscriptionId")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "subscriptionId", valid_564222
  var valid_564223 = path.getOrDefault("devicePath")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "devicePath", valid_564223
  var valid_564224 = path.getOrDefault("resourceGroupName")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "resourceGroupName", valid_564224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564225 = query.getOrDefault("api-version")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "api-version", valid_564225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564226: Call_ExpressRouteCrossConnectionsListRoutesTable_564217;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the currently advertised routes table associated with the express route cross connection in a resource group.
  ## 
  let valid = call_564226.validator(path, query, header, formData, body)
  let scheme = call_564226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564226.url(scheme.get, call_564226.host, call_564226.base,
                         call_564226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564226, url, valid)

proc call*(call_564227: Call_ExpressRouteCrossConnectionsListRoutesTable_564217;
          apiVersion: string; crossConnectionName: string; peeringName: string;
          subscriptionId: string; devicePath: string; resourceGroupName: string): Recallable =
  ## expressRouteCrossConnectionsListRoutesTable
  ## Gets the currently advertised routes table associated with the express route cross connection in a resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   crossConnectionName: string (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   devicePath: string (required)
  ##             : The path of the device.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564228 = newJObject()
  var query_564229 = newJObject()
  add(query_564229, "api-version", newJString(apiVersion))
  add(path_564228, "crossConnectionName", newJString(crossConnectionName))
  add(path_564228, "peeringName", newJString(peeringName))
  add(path_564228, "subscriptionId", newJString(subscriptionId))
  add(path_564228, "devicePath", newJString(devicePath))
  add(path_564228, "resourceGroupName", newJString(resourceGroupName))
  result = call_564227.call(path_564228, query_564229, nil, nil, nil)

var expressRouteCrossConnectionsListRoutesTable* = Call_ExpressRouteCrossConnectionsListRoutesTable_564217(
    name: "expressRouteCrossConnectionsListRoutesTable",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}/peerings/{peeringName}/routeTables/{devicePath}",
    validator: validate_ExpressRouteCrossConnectionsListRoutesTable_564218,
    base: "", url: url_ExpressRouteCrossConnectionsListRoutesTable_564219,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionsListRoutesTableSummary_564230 = ref object of OpenApiRestCall_563555
proc url_ExpressRouteCrossConnectionsListRoutesTableSummary_564232(
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

proc validate_ExpressRouteCrossConnectionsListRoutesTableSummary_564231(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the route table summary associated with the express route cross connection in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   crossConnectionName: JString (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   peeringName: JString (required)
  ##              : The name of the peering.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   devicePath: JString (required)
  ##             : The path of the device.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `crossConnectionName` field"
  var valid_564233 = path.getOrDefault("crossConnectionName")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "crossConnectionName", valid_564233
  var valid_564234 = path.getOrDefault("peeringName")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "peeringName", valid_564234
  var valid_564235 = path.getOrDefault("subscriptionId")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "subscriptionId", valid_564235
  var valid_564236 = path.getOrDefault("devicePath")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "devicePath", valid_564236
  var valid_564237 = path.getOrDefault("resourceGroupName")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "resourceGroupName", valid_564237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564238 = query.getOrDefault("api-version")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "api-version", valid_564238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564239: Call_ExpressRouteCrossConnectionsListRoutesTableSummary_564230;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the route table summary associated with the express route cross connection in a resource group.
  ## 
  let valid = call_564239.validator(path, query, header, formData, body)
  let scheme = call_564239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564239.url(scheme.get, call_564239.host, call_564239.base,
                         call_564239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564239, url, valid)

proc call*(call_564240: Call_ExpressRouteCrossConnectionsListRoutesTableSummary_564230;
          apiVersion: string; crossConnectionName: string; peeringName: string;
          subscriptionId: string; devicePath: string; resourceGroupName: string): Recallable =
  ## expressRouteCrossConnectionsListRoutesTableSummary
  ## Gets the route table summary associated with the express route cross connection in a resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   crossConnectionName: string (required)
  ##                      : The name of the ExpressRouteCrossConnection.
  ##   peeringName: string (required)
  ##              : The name of the peering.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   devicePath: string (required)
  ##             : The path of the device.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564241 = newJObject()
  var query_564242 = newJObject()
  add(query_564242, "api-version", newJString(apiVersion))
  add(path_564241, "crossConnectionName", newJString(crossConnectionName))
  add(path_564241, "peeringName", newJString(peeringName))
  add(path_564241, "subscriptionId", newJString(subscriptionId))
  add(path_564241, "devicePath", newJString(devicePath))
  add(path_564241, "resourceGroupName", newJString(resourceGroupName))
  result = call_564240.call(path_564241, query_564242, nil, nil, nil)

var expressRouteCrossConnectionsListRoutesTableSummary* = Call_ExpressRouteCrossConnectionsListRoutesTableSummary_564230(
    name: "expressRouteCrossConnectionsListRoutesTableSummary",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}/peerings/{peeringName}/routeTablesSummary/{devicePath}",
    validator: validate_ExpressRouteCrossConnectionsListRoutesTableSummary_564231,
    base: "", url: url_ExpressRouteCrossConnectionsListRoutesTableSummary_564232,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
