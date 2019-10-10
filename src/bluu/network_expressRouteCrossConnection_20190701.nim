
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ExpressRouteCrossConnection REST APIs
## version: 2019-07-01
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
  macServiceName = "network-expressRouteCrossConnection"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ExpressRouteCrossConnectionsList_573879 = ref object of OpenApiRestCall_573657
proc url_ExpressRouteCrossConnectionsList_573881(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCrossConnectionsList_573880(path: JsonNode;
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

proc call*(call_574069: Call_ExpressRouteCrossConnectionsList_573879;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all the ExpressRouteCrossConnections in a subscription.
  ## 
  let valid = call_574069.validator(path, query, header, formData, body)
  let scheme = call_574069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574069.url(scheme.get, call_574069.host, call_574069.base,
                         call_574069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574069, url, valid)

proc call*(call_574140: Call_ExpressRouteCrossConnectionsList_573879;
          apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteCrossConnectionsList
  ## Retrieves all the ExpressRouteCrossConnections in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574141 = newJObject()
  var query_574143 = newJObject()
  add(query_574143, "api-version", newJString(apiVersion))
  add(path_574141, "subscriptionId", newJString(subscriptionId))
  result = call_574140.call(path_574141, query_574143, nil, nil, nil)

var expressRouteCrossConnectionsList* = Call_ExpressRouteCrossConnectionsList_573879(
    name: "expressRouteCrossConnectionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/expressRouteCrossConnections",
    validator: validate_ExpressRouteCrossConnectionsList_573880, base: "",
    url: url_ExpressRouteCrossConnectionsList_573881, schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionsListByResourceGroup_574182 = ref object of OpenApiRestCall_573657
proc url_ExpressRouteCrossConnectionsListByResourceGroup_574184(protocol: Scheme;
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

proc validate_ExpressRouteCrossConnectionsListByResourceGroup_574183(
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
  var valid_574185 = path.getOrDefault("resourceGroupName")
  valid_574185 = validateParameter(valid_574185, JString, required = true,
                                 default = nil)
  if valid_574185 != nil:
    section.add "resourceGroupName", valid_574185
  var valid_574186 = path.getOrDefault("subscriptionId")
  valid_574186 = validateParameter(valid_574186, JString, required = true,
                                 default = nil)
  if valid_574186 != nil:
    section.add "subscriptionId", valid_574186
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574187 = query.getOrDefault("api-version")
  valid_574187 = validateParameter(valid_574187, JString, required = true,
                                 default = nil)
  if valid_574187 != nil:
    section.add "api-version", valid_574187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574188: Call_ExpressRouteCrossConnectionsListByResourceGroup_574182;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all the ExpressRouteCrossConnections in a resource group.
  ## 
  let valid = call_574188.validator(path, query, header, formData, body)
  let scheme = call_574188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574188.url(scheme.get, call_574188.host, call_574188.base,
                         call_574188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574188, url, valid)

proc call*(call_574189: Call_ExpressRouteCrossConnectionsListByResourceGroup_574182;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteCrossConnectionsListByResourceGroup
  ## Retrieves all the ExpressRouteCrossConnections in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574190 = newJObject()
  var query_574191 = newJObject()
  add(path_574190, "resourceGroupName", newJString(resourceGroupName))
  add(query_574191, "api-version", newJString(apiVersion))
  add(path_574190, "subscriptionId", newJString(subscriptionId))
  result = call_574189.call(path_574190, query_574191, nil, nil, nil)

var expressRouteCrossConnectionsListByResourceGroup* = Call_ExpressRouteCrossConnectionsListByResourceGroup_574182(
    name: "expressRouteCrossConnectionsListByResourceGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections",
    validator: validate_ExpressRouteCrossConnectionsListByResourceGroup_574183,
    base: "", url: url_ExpressRouteCrossConnectionsListByResourceGroup_574184,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionsCreateOrUpdate_574203 = ref object of OpenApiRestCall_573657
proc url_ExpressRouteCrossConnectionsCreateOrUpdate_574205(protocol: Scheme;
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

proc validate_ExpressRouteCrossConnectionsCreateOrUpdate_574204(path: JsonNode;
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
  var valid_574232 = path.getOrDefault("crossConnectionName")
  valid_574232 = validateParameter(valid_574232, JString, required = true,
                                 default = nil)
  if valid_574232 != nil:
    section.add "crossConnectionName", valid_574232
  var valid_574233 = path.getOrDefault("resourceGroupName")
  valid_574233 = validateParameter(valid_574233, JString, required = true,
                                 default = nil)
  if valid_574233 != nil:
    section.add "resourceGroupName", valid_574233
  var valid_574234 = path.getOrDefault("subscriptionId")
  valid_574234 = validateParameter(valid_574234, JString, required = true,
                                 default = nil)
  if valid_574234 != nil:
    section.add "subscriptionId", valid_574234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574235 = query.getOrDefault("api-version")
  valid_574235 = validateParameter(valid_574235, JString, required = true,
                                 default = nil)
  if valid_574235 != nil:
    section.add "api-version", valid_574235
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

proc call*(call_574237: Call_ExpressRouteCrossConnectionsCreateOrUpdate_574203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the specified ExpressRouteCrossConnection.
  ## 
  let valid = call_574237.validator(path, query, header, formData, body)
  let scheme = call_574237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574237.url(scheme.get, call_574237.host, call_574237.base,
                         call_574237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574237, url, valid)

proc call*(call_574238: Call_ExpressRouteCrossConnectionsCreateOrUpdate_574203;
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
  var path_574239 = newJObject()
  var query_574240 = newJObject()
  var body_574241 = newJObject()
  add(path_574239, "crossConnectionName", newJString(crossConnectionName))
  add(path_574239, "resourceGroupName", newJString(resourceGroupName))
  add(query_574240, "api-version", newJString(apiVersion))
  add(path_574239, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574241 = parameters
  result = call_574238.call(path_574239, query_574240, nil, nil, body_574241)

var expressRouteCrossConnectionsCreateOrUpdate* = Call_ExpressRouteCrossConnectionsCreateOrUpdate_574203(
    name: "expressRouteCrossConnectionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}",
    validator: validate_ExpressRouteCrossConnectionsCreateOrUpdate_574204,
    base: "", url: url_ExpressRouteCrossConnectionsCreateOrUpdate_574205,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionsGet_574192 = ref object of OpenApiRestCall_573657
proc url_ExpressRouteCrossConnectionsGet_574194(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCrossConnectionsGet_574193(path: JsonNode;
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
  var valid_574195 = path.getOrDefault("crossConnectionName")
  valid_574195 = validateParameter(valid_574195, JString, required = true,
                                 default = nil)
  if valid_574195 != nil:
    section.add "crossConnectionName", valid_574195
  var valid_574196 = path.getOrDefault("resourceGroupName")
  valid_574196 = validateParameter(valid_574196, JString, required = true,
                                 default = nil)
  if valid_574196 != nil:
    section.add "resourceGroupName", valid_574196
  var valid_574197 = path.getOrDefault("subscriptionId")
  valid_574197 = validateParameter(valid_574197, JString, required = true,
                                 default = nil)
  if valid_574197 != nil:
    section.add "subscriptionId", valid_574197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574198 = query.getOrDefault("api-version")
  valid_574198 = validateParameter(valid_574198, JString, required = true,
                                 default = nil)
  if valid_574198 != nil:
    section.add "api-version", valid_574198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574199: Call_ExpressRouteCrossConnectionsGet_574192;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets details about the specified ExpressRouteCrossConnection.
  ## 
  let valid = call_574199.validator(path, query, header, formData, body)
  let scheme = call_574199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574199.url(scheme.get, call_574199.host, call_574199.base,
                         call_574199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574199, url, valid)

proc call*(call_574200: Call_ExpressRouteCrossConnectionsGet_574192;
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
  var path_574201 = newJObject()
  var query_574202 = newJObject()
  add(path_574201, "crossConnectionName", newJString(crossConnectionName))
  add(path_574201, "resourceGroupName", newJString(resourceGroupName))
  add(query_574202, "api-version", newJString(apiVersion))
  add(path_574201, "subscriptionId", newJString(subscriptionId))
  result = call_574200.call(path_574201, query_574202, nil, nil, nil)

var expressRouteCrossConnectionsGet* = Call_ExpressRouteCrossConnectionsGet_574192(
    name: "expressRouteCrossConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}",
    validator: validate_ExpressRouteCrossConnectionsGet_574193, base: "",
    url: url_ExpressRouteCrossConnectionsGet_574194, schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionsUpdateTags_574242 = ref object of OpenApiRestCall_573657
proc url_ExpressRouteCrossConnectionsUpdateTags_574244(protocol: Scheme;
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

proc validate_ExpressRouteCrossConnectionsUpdateTags_574243(path: JsonNode;
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
  var valid_574245 = path.getOrDefault("crossConnectionName")
  valid_574245 = validateParameter(valid_574245, JString, required = true,
                                 default = nil)
  if valid_574245 != nil:
    section.add "crossConnectionName", valid_574245
  var valid_574246 = path.getOrDefault("resourceGroupName")
  valid_574246 = validateParameter(valid_574246, JString, required = true,
                                 default = nil)
  if valid_574246 != nil:
    section.add "resourceGroupName", valid_574246
  var valid_574247 = path.getOrDefault("subscriptionId")
  valid_574247 = validateParameter(valid_574247, JString, required = true,
                                 default = nil)
  if valid_574247 != nil:
    section.add "subscriptionId", valid_574247
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574248 = query.getOrDefault("api-version")
  valid_574248 = validateParameter(valid_574248, JString, required = true,
                                 default = nil)
  if valid_574248 != nil:
    section.add "api-version", valid_574248
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

proc call*(call_574250: Call_ExpressRouteCrossConnectionsUpdateTags_574242;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an express route cross connection tags.
  ## 
  let valid = call_574250.validator(path, query, header, formData, body)
  let scheme = call_574250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574250.url(scheme.get, call_574250.host, call_574250.base,
                         call_574250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574250, url, valid)

proc call*(call_574251: Call_ExpressRouteCrossConnectionsUpdateTags_574242;
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
  var path_574252 = newJObject()
  var query_574253 = newJObject()
  var body_574254 = newJObject()
  add(path_574252, "crossConnectionName", newJString(crossConnectionName))
  add(path_574252, "resourceGroupName", newJString(resourceGroupName))
  add(query_574253, "api-version", newJString(apiVersion))
  add(path_574252, "subscriptionId", newJString(subscriptionId))
  if crossConnectionParameters != nil:
    body_574254 = crossConnectionParameters
  result = call_574251.call(path_574252, query_574253, nil, nil, body_574254)

var expressRouteCrossConnectionsUpdateTags* = Call_ExpressRouteCrossConnectionsUpdateTags_574242(
    name: "expressRouteCrossConnectionsUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}",
    validator: validate_ExpressRouteCrossConnectionsUpdateTags_574243, base: "",
    url: url_ExpressRouteCrossConnectionsUpdateTags_574244,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionPeeringsList_574255 = ref object of OpenApiRestCall_573657
proc url_ExpressRouteCrossConnectionPeeringsList_574257(protocol: Scheme;
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

proc validate_ExpressRouteCrossConnectionPeeringsList_574256(path: JsonNode;
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
  var valid_574258 = path.getOrDefault("crossConnectionName")
  valid_574258 = validateParameter(valid_574258, JString, required = true,
                                 default = nil)
  if valid_574258 != nil:
    section.add "crossConnectionName", valid_574258
  var valid_574259 = path.getOrDefault("resourceGroupName")
  valid_574259 = validateParameter(valid_574259, JString, required = true,
                                 default = nil)
  if valid_574259 != nil:
    section.add "resourceGroupName", valid_574259
  var valid_574260 = path.getOrDefault("subscriptionId")
  valid_574260 = validateParameter(valid_574260, JString, required = true,
                                 default = nil)
  if valid_574260 != nil:
    section.add "subscriptionId", valid_574260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574261 = query.getOrDefault("api-version")
  valid_574261 = validateParameter(valid_574261, JString, required = true,
                                 default = nil)
  if valid_574261 != nil:
    section.add "api-version", valid_574261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574262: Call_ExpressRouteCrossConnectionPeeringsList_574255;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all peerings in a specified ExpressRouteCrossConnection.
  ## 
  let valid = call_574262.validator(path, query, header, formData, body)
  let scheme = call_574262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574262.url(scheme.get, call_574262.host, call_574262.base,
                         call_574262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574262, url, valid)

proc call*(call_574263: Call_ExpressRouteCrossConnectionPeeringsList_574255;
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
  var path_574264 = newJObject()
  var query_574265 = newJObject()
  add(path_574264, "crossConnectionName", newJString(crossConnectionName))
  add(path_574264, "resourceGroupName", newJString(resourceGroupName))
  add(query_574265, "api-version", newJString(apiVersion))
  add(path_574264, "subscriptionId", newJString(subscriptionId))
  result = call_574263.call(path_574264, query_574265, nil, nil, nil)

var expressRouteCrossConnectionPeeringsList* = Call_ExpressRouteCrossConnectionPeeringsList_574255(
    name: "expressRouteCrossConnectionPeeringsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}/peerings",
    validator: validate_ExpressRouteCrossConnectionPeeringsList_574256, base: "",
    url: url_ExpressRouteCrossConnectionPeeringsList_574257,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_574278 = ref object of OpenApiRestCall_573657
proc url_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_574280(
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

proc validate_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_574279(
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
  var valid_574281 = path.getOrDefault("crossConnectionName")
  valid_574281 = validateParameter(valid_574281, JString, required = true,
                                 default = nil)
  if valid_574281 != nil:
    section.add "crossConnectionName", valid_574281
  var valid_574282 = path.getOrDefault("resourceGroupName")
  valid_574282 = validateParameter(valid_574282, JString, required = true,
                                 default = nil)
  if valid_574282 != nil:
    section.add "resourceGroupName", valid_574282
  var valid_574283 = path.getOrDefault("peeringName")
  valid_574283 = validateParameter(valid_574283, JString, required = true,
                                 default = nil)
  if valid_574283 != nil:
    section.add "peeringName", valid_574283
  var valid_574284 = path.getOrDefault("subscriptionId")
  valid_574284 = validateParameter(valid_574284, JString, required = true,
                                 default = nil)
  if valid_574284 != nil:
    section.add "subscriptionId", valid_574284
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574285 = query.getOrDefault("api-version")
  valid_574285 = validateParameter(valid_574285, JString, required = true,
                                 default = nil)
  if valid_574285 != nil:
    section.add "api-version", valid_574285
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

proc call*(call_574287: Call_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_574278;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a peering in the specified ExpressRouteCrossConnection.
  ## 
  let valid = call_574287.validator(path, query, header, formData, body)
  let scheme = call_574287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574287.url(scheme.get, call_574287.host, call_574287.base,
                         call_574287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574287, url, valid)

proc call*(call_574288: Call_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_574278;
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
  var path_574289 = newJObject()
  var query_574290 = newJObject()
  var body_574291 = newJObject()
  add(path_574289, "crossConnectionName", newJString(crossConnectionName))
  add(path_574289, "resourceGroupName", newJString(resourceGroupName))
  add(query_574290, "api-version", newJString(apiVersion))
  add(path_574289, "peeringName", newJString(peeringName))
  add(path_574289, "subscriptionId", newJString(subscriptionId))
  if peeringParameters != nil:
    body_574291 = peeringParameters
  result = call_574288.call(path_574289, query_574290, nil, nil, body_574291)

var expressRouteCrossConnectionPeeringsCreateOrUpdate* = Call_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_574278(
    name: "expressRouteCrossConnectionPeeringsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_574279,
    base: "", url: url_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_574280,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionPeeringsGet_574266 = ref object of OpenApiRestCall_573657
proc url_ExpressRouteCrossConnectionPeeringsGet_574268(protocol: Scheme;
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

proc validate_ExpressRouteCrossConnectionPeeringsGet_574267(path: JsonNode;
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
  var valid_574269 = path.getOrDefault("crossConnectionName")
  valid_574269 = validateParameter(valid_574269, JString, required = true,
                                 default = nil)
  if valid_574269 != nil:
    section.add "crossConnectionName", valid_574269
  var valid_574270 = path.getOrDefault("resourceGroupName")
  valid_574270 = validateParameter(valid_574270, JString, required = true,
                                 default = nil)
  if valid_574270 != nil:
    section.add "resourceGroupName", valid_574270
  var valid_574271 = path.getOrDefault("peeringName")
  valid_574271 = validateParameter(valid_574271, JString, required = true,
                                 default = nil)
  if valid_574271 != nil:
    section.add "peeringName", valid_574271
  var valid_574272 = path.getOrDefault("subscriptionId")
  valid_574272 = validateParameter(valid_574272, JString, required = true,
                                 default = nil)
  if valid_574272 != nil:
    section.add "subscriptionId", valid_574272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574273 = query.getOrDefault("api-version")
  valid_574273 = validateParameter(valid_574273, JString, required = true,
                                 default = nil)
  if valid_574273 != nil:
    section.add "api-version", valid_574273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574274: Call_ExpressRouteCrossConnectionPeeringsGet_574266;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified peering for the ExpressRouteCrossConnection.
  ## 
  let valid = call_574274.validator(path, query, header, formData, body)
  let scheme = call_574274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574274.url(scheme.get, call_574274.host, call_574274.base,
                         call_574274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574274, url, valid)

proc call*(call_574275: Call_ExpressRouteCrossConnectionPeeringsGet_574266;
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
  var path_574276 = newJObject()
  var query_574277 = newJObject()
  add(path_574276, "crossConnectionName", newJString(crossConnectionName))
  add(path_574276, "resourceGroupName", newJString(resourceGroupName))
  add(query_574277, "api-version", newJString(apiVersion))
  add(path_574276, "peeringName", newJString(peeringName))
  add(path_574276, "subscriptionId", newJString(subscriptionId))
  result = call_574275.call(path_574276, query_574277, nil, nil, nil)

var expressRouteCrossConnectionPeeringsGet* = Call_ExpressRouteCrossConnectionPeeringsGet_574266(
    name: "expressRouteCrossConnectionPeeringsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCrossConnectionPeeringsGet_574267, base: "",
    url: url_ExpressRouteCrossConnectionPeeringsGet_574268,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionPeeringsDelete_574292 = ref object of OpenApiRestCall_573657
proc url_ExpressRouteCrossConnectionPeeringsDelete_574294(protocol: Scheme;
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

proc validate_ExpressRouteCrossConnectionPeeringsDelete_574293(path: JsonNode;
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
  var valid_574295 = path.getOrDefault("crossConnectionName")
  valid_574295 = validateParameter(valid_574295, JString, required = true,
                                 default = nil)
  if valid_574295 != nil:
    section.add "crossConnectionName", valid_574295
  var valid_574296 = path.getOrDefault("resourceGroupName")
  valid_574296 = validateParameter(valid_574296, JString, required = true,
                                 default = nil)
  if valid_574296 != nil:
    section.add "resourceGroupName", valid_574296
  var valid_574297 = path.getOrDefault("peeringName")
  valid_574297 = validateParameter(valid_574297, JString, required = true,
                                 default = nil)
  if valid_574297 != nil:
    section.add "peeringName", valid_574297
  var valid_574298 = path.getOrDefault("subscriptionId")
  valid_574298 = validateParameter(valid_574298, JString, required = true,
                                 default = nil)
  if valid_574298 != nil:
    section.add "subscriptionId", valid_574298
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574299 = query.getOrDefault("api-version")
  valid_574299 = validateParameter(valid_574299, JString, required = true,
                                 default = nil)
  if valid_574299 != nil:
    section.add "api-version", valid_574299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574300: Call_ExpressRouteCrossConnectionPeeringsDelete_574292;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified peering from the ExpressRouteCrossConnection.
  ## 
  let valid = call_574300.validator(path, query, header, formData, body)
  let scheme = call_574300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574300.url(scheme.get, call_574300.host, call_574300.base,
                         call_574300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574300, url, valid)

proc call*(call_574301: Call_ExpressRouteCrossConnectionPeeringsDelete_574292;
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
  var path_574302 = newJObject()
  var query_574303 = newJObject()
  add(path_574302, "crossConnectionName", newJString(crossConnectionName))
  add(path_574302, "resourceGroupName", newJString(resourceGroupName))
  add(query_574303, "api-version", newJString(apiVersion))
  add(path_574302, "peeringName", newJString(peeringName))
  add(path_574302, "subscriptionId", newJString(subscriptionId))
  result = call_574301.call(path_574302, query_574303, nil, nil, nil)

var expressRouteCrossConnectionPeeringsDelete* = Call_ExpressRouteCrossConnectionPeeringsDelete_574292(
    name: "expressRouteCrossConnectionPeeringsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCrossConnectionPeeringsDelete_574293,
    base: "", url: url_ExpressRouteCrossConnectionPeeringsDelete_574294,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionsListArpTable_574304 = ref object of OpenApiRestCall_573657
proc url_ExpressRouteCrossConnectionsListArpTable_574306(protocol: Scheme;
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

proc validate_ExpressRouteCrossConnectionsListArpTable_574305(path: JsonNode;
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
  ##             : The path of the device.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `crossConnectionName` field"
  var valid_574307 = path.getOrDefault("crossConnectionName")
  valid_574307 = validateParameter(valid_574307, JString, required = true,
                                 default = nil)
  if valid_574307 != nil:
    section.add "crossConnectionName", valid_574307
  var valid_574308 = path.getOrDefault("resourceGroupName")
  valid_574308 = validateParameter(valid_574308, JString, required = true,
                                 default = nil)
  if valid_574308 != nil:
    section.add "resourceGroupName", valid_574308
  var valid_574309 = path.getOrDefault("peeringName")
  valid_574309 = validateParameter(valid_574309, JString, required = true,
                                 default = nil)
  if valid_574309 != nil:
    section.add "peeringName", valid_574309
  var valid_574310 = path.getOrDefault("subscriptionId")
  valid_574310 = validateParameter(valid_574310, JString, required = true,
                                 default = nil)
  if valid_574310 != nil:
    section.add "subscriptionId", valid_574310
  var valid_574311 = path.getOrDefault("devicePath")
  valid_574311 = validateParameter(valid_574311, JString, required = true,
                                 default = nil)
  if valid_574311 != nil:
    section.add "devicePath", valid_574311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574312 = query.getOrDefault("api-version")
  valid_574312 = validateParameter(valid_574312, JString, required = true,
                                 default = nil)
  if valid_574312 != nil:
    section.add "api-version", valid_574312
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574313: Call_ExpressRouteCrossConnectionsListArpTable_574304;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the currently advertised ARP table associated with the express route cross connection in a resource group.
  ## 
  let valid = call_574313.validator(path, query, header, formData, body)
  let scheme = call_574313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574313.url(scheme.get, call_574313.host, call_574313.base,
                         call_574313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574313, url, valid)

proc call*(call_574314: Call_ExpressRouteCrossConnectionsListArpTable_574304;
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
  ##             : The path of the device.
  var path_574315 = newJObject()
  var query_574316 = newJObject()
  add(path_574315, "crossConnectionName", newJString(crossConnectionName))
  add(path_574315, "resourceGroupName", newJString(resourceGroupName))
  add(query_574316, "api-version", newJString(apiVersion))
  add(path_574315, "peeringName", newJString(peeringName))
  add(path_574315, "subscriptionId", newJString(subscriptionId))
  add(path_574315, "devicePath", newJString(devicePath))
  result = call_574314.call(path_574315, query_574316, nil, nil, nil)

var expressRouteCrossConnectionsListArpTable* = Call_ExpressRouteCrossConnectionsListArpTable_574304(
    name: "expressRouteCrossConnectionsListArpTable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}/peerings/{peeringName}/arpTables/{devicePath}",
    validator: validate_ExpressRouteCrossConnectionsListArpTable_574305, base: "",
    url: url_ExpressRouteCrossConnectionsListArpTable_574306,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionsListRoutesTable_574317 = ref object of OpenApiRestCall_573657
proc url_ExpressRouteCrossConnectionsListRoutesTable_574319(protocol: Scheme;
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

proc validate_ExpressRouteCrossConnectionsListRoutesTable_574318(path: JsonNode;
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
  var valid_574320 = path.getOrDefault("crossConnectionName")
  valid_574320 = validateParameter(valid_574320, JString, required = true,
                                 default = nil)
  if valid_574320 != nil:
    section.add "crossConnectionName", valid_574320
  var valid_574321 = path.getOrDefault("resourceGroupName")
  valid_574321 = validateParameter(valid_574321, JString, required = true,
                                 default = nil)
  if valid_574321 != nil:
    section.add "resourceGroupName", valid_574321
  var valid_574322 = path.getOrDefault("peeringName")
  valid_574322 = validateParameter(valid_574322, JString, required = true,
                                 default = nil)
  if valid_574322 != nil:
    section.add "peeringName", valid_574322
  var valid_574323 = path.getOrDefault("subscriptionId")
  valid_574323 = validateParameter(valid_574323, JString, required = true,
                                 default = nil)
  if valid_574323 != nil:
    section.add "subscriptionId", valid_574323
  var valid_574324 = path.getOrDefault("devicePath")
  valid_574324 = validateParameter(valid_574324, JString, required = true,
                                 default = nil)
  if valid_574324 != nil:
    section.add "devicePath", valid_574324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574325 = query.getOrDefault("api-version")
  valid_574325 = validateParameter(valid_574325, JString, required = true,
                                 default = nil)
  if valid_574325 != nil:
    section.add "api-version", valid_574325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574326: Call_ExpressRouteCrossConnectionsListRoutesTable_574317;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the currently advertised routes table associated with the express route cross connection in a resource group.
  ## 
  let valid = call_574326.validator(path, query, header, formData, body)
  let scheme = call_574326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574326.url(scheme.get, call_574326.host, call_574326.base,
                         call_574326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574326, url, valid)

proc call*(call_574327: Call_ExpressRouteCrossConnectionsListRoutesTable_574317;
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
  var path_574328 = newJObject()
  var query_574329 = newJObject()
  add(path_574328, "crossConnectionName", newJString(crossConnectionName))
  add(path_574328, "resourceGroupName", newJString(resourceGroupName))
  add(query_574329, "api-version", newJString(apiVersion))
  add(path_574328, "peeringName", newJString(peeringName))
  add(path_574328, "subscriptionId", newJString(subscriptionId))
  add(path_574328, "devicePath", newJString(devicePath))
  result = call_574327.call(path_574328, query_574329, nil, nil, nil)

var expressRouteCrossConnectionsListRoutesTable* = Call_ExpressRouteCrossConnectionsListRoutesTable_574317(
    name: "expressRouteCrossConnectionsListRoutesTable",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}/peerings/{peeringName}/routeTables/{devicePath}",
    validator: validate_ExpressRouteCrossConnectionsListRoutesTable_574318,
    base: "", url: url_ExpressRouteCrossConnectionsListRoutesTable_574319,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionsListRoutesTableSummary_574330 = ref object of OpenApiRestCall_573657
proc url_ExpressRouteCrossConnectionsListRoutesTableSummary_574332(
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

proc validate_ExpressRouteCrossConnectionsListRoutesTableSummary_574331(
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
  var valid_574333 = path.getOrDefault("crossConnectionName")
  valid_574333 = validateParameter(valid_574333, JString, required = true,
                                 default = nil)
  if valid_574333 != nil:
    section.add "crossConnectionName", valid_574333
  var valid_574334 = path.getOrDefault("resourceGroupName")
  valid_574334 = validateParameter(valid_574334, JString, required = true,
                                 default = nil)
  if valid_574334 != nil:
    section.add "resourceGroupName", valid_574334
  var valid_574335 = path.getOrDefault("peeringName")
  valid_574335 = validateParameter(valid_574335, JString, required = true,
                                 default = nil)
  if valid_574335 != nil:
    section.add "peeringName", valid_574335
  var valid_574336 = path.getOrDefault("subscriptionId")
  valid_574336 = validateParameter(valid_574336, JString, required = true,
                                 default = nil)
  if valid_574336 != nil:
    section.add "subscriptionId", valid_574336
  var valid_574337 = path.getOrDefault("devicePath")
  valid_574337 = validateParameter(valid_574337, JString, required = true,
                                 default = nil)
  if valid_574337 != nil:
    section.add "devicePath", valid_574337
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574338 = query.getOrDefault("api-version")
  valid_574338 = validateParameter(valid_574338, JString, required = true,
                                 default = nil)
  if valid_574338 != nil:
    section.add "api-version", valid_574338
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574339: Call_ExpressRouteCrossConnectionsListRoutesTableSummary_574330;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the route table summary associated with the express route cross connection in a resource group.
  ## 
  let valid = call_574339.validator(path, query, header, formData, body)
  let scheme = call_574339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574339.url(scheme.get, call_574339.host, call_574339.base,
                         call_574339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574339, url, valid)

proc call*(call_574340: Call_ExpressRouteCrossConnectionsListRoutesTableSummary_574330;
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
  var path_574341 = newJObject()
  var query_574342 = newJObject()
  add(path_574341, "crossConnectionName", newJString(crossConnectionName))
  add(path_574341, "resourceGroupName", newJString(resourceGroupName))
  add(query_574342, "api-version", newJString(apiVersion))
  add(path_574341, "peeringName", newJString(peeringName))
  add(path_574341, "subscriptionId", newJString(subscriptionId))
  add(path_574341, "devicePath", newJString(devicePath))
  result = call_574340.call(path_574341, query_574342, nil, nil, nil)

var expressRouteCrossConnectionsListRoutesTableSummary* = Call_ExpressRouteCrossConnectionsListRoutesTableSummary_574330(
    name: "expressRouteCrossConnectionsListRoutesTableSummary",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}/peerings/{peeringName}/routeTablesSummary/{devicePath}",
    validator: validate_ExpressRouteCrossConnectionsListRoutesTableSummary_574331,
    base: "", url: url_ExpressRouteCrossConnectionsListRoutesTableSummary_574332,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
