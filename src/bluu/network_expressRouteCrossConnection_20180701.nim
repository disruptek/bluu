
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ExpressRouteCrossConnection REST APIs
## version: 2018-07-01
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
  macServiceName = "network-expressRouteCrossConnection"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ExpressRouteCrossConnectionsList_567879 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCrossConnectionsList_567881(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCrossConnectionsList_567880(path: JsonNode;
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

proc call*(call_568069: Call_ExpressRouteCrossConnectionsList_567879;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all the ExpressRouteCrossConnections in a subscription.
  ## 
  let valid = call_568069.validator(path, query, header, formData, body)
  let scheme = call_568069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568069.url(scheme.get, call_568069.host, call_568069.base,
                         call_568069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568069, url, valid)

proc call*(call_568140: Call_ExpressRouteCrossConnectionsList_567879;
          apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteCrossConnectionsList
  ## Retrieves all the ExpressRouteCrossConnections in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568141 = newJObject()
  var query_568143 = newJObject()
  add(query_568143, "api-version", newJString(apiVersion))
  add(path_568141, "subscriptionId", newJString(subscriptionId))
  result = call_568140.call(path_568141, query_568143, nil, nil, nil)

var expressRouteCrossConnectionsList* = Call_ExpressRouteCrossConnectionsList_567879(
    name: "expressRouteCrossConnectionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/expressRouteCrossConnections",
    validator: validate_ExpressRouteCrossConnectionsList_567880, base: "",
    url: url_ExpressRouteCrossConnectionsList_567881, schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionsListByResourceGroup_568182 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCrossConnectionsListByResourceGroup_568184(protocol: Scheme;
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

proc validate_ExpressRouteCrossConnectionsListByResourceGroup_568183(
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
  var valid_568185 = path.getOrDefault("resourceGroupName")
  valid_568185 = validateParameter(valid_568185, JString, required = true,
                                 default = nil)
  if valid_568185 != nil:
    section.add "resourceGroupName", valid_568185
  var valid_568186 = path.getOrDefault("subscriptionId")
  valid_568186 = validateParameter(valid_568186, JString, required = true,
                                 default = nil)
  if valid_568186 != nil:
    section.add "subscriptionId", valid_568186
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568187 = query.getOrDefault("api-version")
  valid_568187 = validateParameter(valid_568187, JString, required = true,
                                 default = nil)
  if valid_568187 != nil:
    section.add "api-version", valid_568187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568188: Call_ExpressRouteCrossConnectionsListByResourceGroup_568182;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all the ExpressRouteCrossConnections in a resource group.
  ## 
  let valid = call_568188.validator(path, query, header, formData, body)
  let scheme = call_568188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568188.url(scheme.get, call_568188.host, call_568188.base,
                         call_568188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568188, url, valid)

proc call*(call_568189: Call_ExpressRouteCrossConnectionsListByResourceGroup_568182;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## expressRouteCrossConnectionsListByResourceGroup
  ## Retrieves all the ExpressRouteCrossConnections in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568190 = newJObject()
  var query_568191 = newJObject()
  add(path_568190, "resourceGroupName", newJString(resourceGroupName))
  add(query_568191, "api-version", newJString(apiVersion))
  add(path_568190, "subscriptionId", newJString(subscriptionId))
  result = call_568189.call(path_568190, query_568191, nil, nil, nil)

var expressRouteCrossConnectionsListByResourceGroup* = Call_ExpressRouteCrossConnectionsListByResourceGroup_568182(
    name: "expressRouteCrossConnectionsListByResourceGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections",
    validator: validate_ExpressRouteCrossConnectionsListByResourceGroup_568183,
    base: "", url: url_ExpressRouteCrossConnectionsListByResourceGroup_568184,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionsCreateOrUpdate_568203 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCrossConnectionsCreateOrUpdate_568205(protocol: Scheme;
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

proc validate_ExpressRouteCrossConnectionsCreateOrUpdate_568204(path: JsonNode;
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
  var valid_568232 = path.getOrDefault("crossConnectionName")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "crossConnectionName", valid_568232
  var valid_568233 = path.getOrDefault("resourceGroupName")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "resourceGroupName", valid_568233
  var valid_568234 = path.getOrDefault("subscriptionId")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "subscriptionId", valid_568234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568235 = query.getOrDefault("api-version")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "api-version", valid_568235
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

proc call*(call_568237: Call_ExpressRouteCrossConnectionsCreateOrUpdate_568203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the specified ExpressRouteCrossConnection.
  ## 
  let valid = call_568237.validator(path, query, header, formData, body)
  let scheme = call_568237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568237.url(scheme.get, call_568237.host, call_568237.base,
                         call_568237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568237, url, valid)

proc call*(call_568238: Call_ExpressRouteCrossConnectionsCreateOrUpdate_568203;
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
  var path_568239 = newJObject()
  var query_568240 = newJObject()
  var body_568241 = newJObject()
  add(path_568239, "crossConnectionName", newJString(crossConnectionName))
  add(path_568239, "resourceGroupName", newJString(resourceGroupName))
  add(query_568240, "api-version", newJString(apiVersion))
  add(path_568239, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568241 = parameters
  result = call_568238.call(path_568239, query_568240, nil, nil, body_568241)

var expressRouteCrossConnectionsCreateOrUpdate* = Call_ExpressRouteCrossConnectionsCreateOrUpdate_568203(
    name: "expressRouteCrossConnectionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}",
    validator: validate_ExpressRouteCrossConnectionsCreateOrUpdate_568204,
    base: "", url: url_ExpressRouteCrossConnectionsCreateOrUpdate_568205,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionsGet_568192 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCrossConnectionsGet_568194(protocol: Scheme; host: string;
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

proc validate_ExpressRouteCrossConnectionsGet_568193(path: JsonNode;
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
  var valid_568195 = path.getOrDefault("crossConnectionName")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "crossConnectionName", valid_568195
  var valid_568196 = path.getOrDefault("resourceGroupName")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "resourceGroupName", valid_568196
  var valid_568197 = path.getOrDefault("subscriptionId")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "subscriptionId", valid_568197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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

proc call*(call_568199: Call_ExpressRouteCrossConnectionsGet_568192;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets details about the specified ExpressRouteCrossConnection.
  ## 
  let valid = call_568199.validator(path, query, header, formData, body)
  let scheme = call_568199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568199.url(scheme.get, call_568199.host, call_568199.base,
                         call_568199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568199, url, valid)

proc call*(call_568200: Call_ExpressRouteCrossConnectionsGet_568192;
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
  var path_568201 = newJObject()
  var query_568202 = newJObject()
  add(path_568201, "crossConnectionName", newJString(crossConnectionName))
  add(path_568201, "resourceGroupName", newJString(resourceGroupName))
  add(query_568202, "api-version", newJString(apiVersion))
  add(path_568201, "subscriptionId", newJString(subscriptionId))
  result = call_568200.call(path_568201, query_568202, nil, nil, nil)

var expressRouteCrossConnectionsGet* = Call_ExpressRouteCrossConnectionsGet_568192(
    name: "expressRouteCrossConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}",
    validator: validate_ExpressRouteCrossConnectionsGet_568193, base: "",
    url: url_ExpressRouteCrossConnectionsGet_568194, schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionsUpdateTags_568242 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCrossConnectionsUpdateTags_568244(protocol: Scheme;
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

proc validate_ExpressRouteCrossConnectionsUpdateTags_568243(path: JsonNode;
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
  var valid_568245 = path.getOrDefault("crossConnectionName")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "crossConnectionName", valid_568245
  var valid_568246 = path.getOrDefault("resourceGroupName")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "resourceGroupName", valid_568246
  var valid_568247 = path.getOrDefault("subscriptionId")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "subscriptionId", valid_568247
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568248 = query.getOrDefault("api-version")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "api-version", valid_568248
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

proc call*(call_568250: Call_ExpressRouteCrossConnectionsUpdateTags_568242;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an express route cross connection tags.
  ## 
  let valid = call_568250.validator(path, query, header, formData, body)
  let scheme = call_568250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568250.url(scheme.get, call_568250.host, call_568250.base,
                         call_568250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568250, url, valid)

proc call*(call_568251: Call_ExpressRouteCrossConnectionsUpdateTags_568242;
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
  var path_568252 = newJObject()
  var query_568253 = newJObject()
  var body_568254 = newJObject()
  add(path_568252, "crossConnectionName", newJString(crossConnectionName))
  add(path_568252, "resourceGroupName", newJString(resourceGroupName))
  add(query_568253, "api-version", newJString(apiVersion))
  add(path_568252, "subscriptionId", newJString(subscriptionId))
  if crossConnectionParameters != nil:
    body_568254 = crossConnectionParameters
  result = call_568251.call(path_568252, query_568253, nil, nil, body_568254)

var expressRouteCrossConnectionsUpdateTags* = Call_ExpressRouteCrossConnectionsUpdateTags_568242(
    name: "expressRouteCrossConnectionsUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}",
    validator: validate_ExpressRouteCrossConnectionsUpdateTags_568243, base: "",
    url: url_ExpressRouteCrossConnectionsUpdateTags_568244,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionPeeringsList_568255 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCrossConnectionPeeringsList_568257(protocol: Scheme;
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

proc validate_ExpressRouteCrossConnectionPeeringsList_568256(path: JsonNode;
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
  var valid_568258 = path.getOrDefault("crossConnectionName")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "crossConnectionName", valid_568258
  var valid_568259 = path.getOrDefault("resourceGroupName")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "resourceGroupName", valid_568259
  var valid_568260 = path.getOrDefault("subscriptionId")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "subscriptionId", valid_568260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568261 = query.getOrDefault("api-version")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "api-version", valid_568261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568262: Call_ExpressRouteCrossConnectionPeeringsList_568255;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all peerings in a specified ExpressRouteCrossConnection.
  ## 
  let valid = call_568262.validator(path, query, header, formData, body)
  let scheme = call_568262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568262.url(scheme.get, call_568262.host, call_568262.base,
                         call_568262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568262, url, valid)

proc call*(call_568263: Call_ExpressRouteCrossConnectionPeeringsList_568255;
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
  var path_568264 = newJObject()
  var query_568265 = newJObject()
  add(path_568264, "crossConnectionName", newJString(crossConnectionName))
  add(path_568264, "resourceGroupName", newJString(resourceGroupName))
  add(query_568265, "api-version", newJString(apiVersion))
  add(path_568264, "subscriptionId", newJString(subscriptionId))
  result = call_568263.call(path_568264, query_568265, nil, nil, nil)

var expressRouteCrossConnectionPeeringsList* = Call_ExpressRouteCrossConnectionPeeringsList_568255(
    name: "expressRouteCrossConnectionPeeringsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}/peerings",
    validator: validate_ExpressRouteCrossConnectionPeeringsList_568256, base: "",
    url: url_ExpressRouteCrossConnectionPeeringsList_568257,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_568278 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_568280(
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

proc validate_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_568279(
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
  var valid_568281 = path.getOrDefault("crossConnectionName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "crossConnectionName", valid_568281
  var valid_568282 = path.getOrDefault("resourceGroupName")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "resourceGroupName", valid_568282
  var valid_568283 = path.getOrDefault("peeringName")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "peeringName", valid_568283
  var valid_568284 = path.getOrDefault("subscriptionId")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "subscriptionId", valid_568284
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568285 = query.getOrDefault("api-version")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "api-version", valid_568285
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

proc call*(call_568287: Call_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_568278;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a peering in the specified ExpressRouteCrossConnection.
  ## 
  let valid = call_568287.validator(path, query, header, formData, body)
  let scheme = call_568287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568287.url(scheme.get, call_568287.host, call_568287.base,
                         call_568287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568287, url, valid)

proc call*(call_568288: Call_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_568278;
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
  var path_568289 = newJObject()
  var query_568290 = newJObject()
  var body_568291 = newJObject()
  add(path_568289, "crossConnectionName", newJString(crossConnectionName))
  add(path_568289, "resourceGroupName", newJString(resourceGroupName))
  add(query_568290, "api-version", newJString(apiVersion))
  add(path_568289, "peeringName", newJString(peeringName))
  add(path_568289, "subscriptionId", newJString(subscriptionId))
  if peeringParameters != nil:
    body_568291 = peeringParameters
  result = call_568288.call(path_568289, query_568290, nil, nil, body_568291)

var expressRouteCrossConnectionPeeringsCreateOrUpdate* = Call_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_568278(
    name: "expressRouteCrossConnectionPeeringsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_568279,
    base: "", url: url_ExpressRouteCrossConnectionPeeringsCreateOrUpdate_568280,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionPeeringsGet_568266 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCrossConnectionPeeringsGet_568268(protocol: Scheme;
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

proc validate_ExpressRouteCrossConnectionPeeringsGet_568267(path: JsonNode;
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
  var valid_568269 = path.getOrDefault("crossConnectionName")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "crossConnectionName", valid_568269
  var valid_568270 = path.getOrDefault("resourceGroupName")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "resourceGroupName", valid_568270
  var valid_568271 = path.getOrDefault("peeringName")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "peeringName", valid_568271
  var valid_568272 = path.getOrDefault("subscriptionId")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "subscriptionId", valid_568272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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

proc call*(call_568274: Call_ExpressRouteCrossConnectionPeeringsGet_568266;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified peering for the ExpressRouteCrossConnection.
  ## 
  let valid = call_568274.validator(path, query, header, formData, body)
  let scheme = call_568274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568274.url(scheme.get, call_568274.host, call_568274.base,
                         call_568274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568274, url, valid)

proc call*(call_568275: Call_ExpressRouteCrossConnectionPeeringsGet_568266;
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
  var path_568276 = newJObject()
  var query_568277 = newJObject()
  add(path_568276, "crossConnectionName", newJString(crossConnectionName))
  add(path_568276, "resourceGroupName", newJString(resourceGroupName))
  add(query_568277, "api-version", newJString(apiVersion))
  add(path_568276, "peeringName", newJString(peeringName))
  add(path_568276, "subscriptionId", newJString(subscriptionId))
  result = call_568275.call(path_568276, query_568277, nil, nil, nil)

var expressRouteCrossConnectionPeeringsGet* = Call_ExpressRouteCrossConnectionPeeringsGet_568266(
    name: "expressRouteCrossConnectionPeeringsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCrossConnectionPeeringsGet_568267, base: "",
    url: url_ExpressRouteCrossConnectionPeeringsGet_568268,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionPeeringsDelete_568292 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCrossConnectionPeeringsDelete_568294(protocol: Scheme;
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

proc validate_ExpressRouteCrossConnectionPeeringsDelete_568293(path: JsonNode;
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
  var valid_568295 = path.getOrDefault("crossConnectionName")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "crossConnectionName", valid_568295
  var valid_568296 = path.getOrDefault("resourceGroupName")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "resourceGroupName", valid_568296
  var valid_568297 = path.getOrDefault("peeringName")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "peeringName", valid_568297
  var valid_568298 = path.getOrDefault("subscriptionId")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "subscriptionId", valid_568298
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568299 = query.getOrDefault("api-version")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "api-version", valid_568299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568300: Call_ExpressRouteCrossConnectionPeeringsDelete_568292;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified peering from the ExpressRouteCrossConnection.
  ## 
  let valid = call_568300.validator(path, query, header, formData, body)
  let scheme = call_568300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568300.url(scheme.get, call_568300.host, call_568300.base,
                         call_568300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568300, url, valid)

proc call*(call_568301: Call_ExpressRouteCrossConnectionPeeringsDelete_568292;
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
  var path_568302 = newJObject()
  var query_568303 = newJObject()
  add(path_568302, "crossConnectionName", newJString(crossConnectionName))
  add(path_568302, "resourceGroupName", newJString(resourceGroupName))
  add(query_568303, "api-version", newJString(apiVersion))
  add(path_568302, "peeringName", newJString(peeringName))
  add(path_568302, "subscriptionId", newJString(subscriptionId))
  result = call_568301.call(path_568302, query_568303, nil, nil, nil)

var expressRouteCrossConnectionPeeringsDelete* = Call_ExpressRouteCrossConnectionPeeringsDelete_568292(
    name: "expressRouteCrossConnectionPeeringsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}/peerings/{peeringName}",
    validator: validate_ExpressRouteCrossConnectionPeeringsDelete_568293,
    base: "", url: url_ExpressRouteCrossConnectionPeeringsDelete_568294,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionsListArpTable_568304 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCrossConnectionsListArpTable_568306(protocol: Scheme;
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

proc validate_ExpressRouteCrossConnectionsListArpTable_568305(path: JsonNode;
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
  var valid_568307 = path.getOrDefault("crossConnectionName")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "crossConnectionName", valid_568307
  var valid_568308 = path.getOrDefault("resourceGroupName")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "resourceGroupName", valid_568308
  var valid_568309 = path.getOrDefault("peeringName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "peeringName", valid_568309
  var valid_568310 = path.getOrDefault("subscriptionId")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "subscriptionId", valid_568310
  var valid_568311 = path.getOrDefault("devicePath")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "devicePath", valid_568311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568312 = query.getOrDefault("api-version")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "api-version", valid_568312
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568313: Call_ExpressRouteCrossConnectionsListArpTable_568304;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the currently advertised ARP table associated with the express route cross connection in a resource group.
  ## 
  let valid = call_568313.validator(path, query, header, formData, body)
  let scheme = call_568313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568313.url(scheme.get, call_568313.host, call_568313.base,
                         call_568313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568313, url, valid)

proc call*(call_568314: Call_ExpressRouteCrossConnectionsListArpTable_568304;
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
  var path_568315 = newJObject()
  var query_568316 = newJObject()
  add(path_568315, "crossConnectionName", newJString(crossConnectionName))
  add(path_568315, "resourceGroupName", newJString(resourceGroupName))
  add(query_568316, "api-version", newJString(apiVersion))
  add(path_568315, "peeringName", newJString(peeringName))
  add(path_568315, "subscriptionId", newJString(subscriptionId))
  add(path_568315, "devicePath", newJString(devicePath))
  result = call_568314.call(path_568315, query_568316, nil, nil, nil)

var expressRouteCrossConnectionsListArpTable* = Call_ExpressRouteCrossConnectionsListArpTable_568304(
    name: "expressRouteCrossConnectionsListArpTable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}/peerings/{peeringName}/arpTables/{devicePath}",
    validator: validate_ExpressRouteCrossConnectionsListArpTable_568305, base: "",
    url: url_ExpressRouteCrossConnectionsListArpTable_568306,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionsListRoutesTable_568317 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCrossConnectionsListRoutesTable_568319(protocol: Scheme;
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

proc validate_ExpressRouteCrossConnectionsListRoutesTable_568318(path: JsonNode;
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
  var valid_568320 = path.getOrDefault("crossConnectionName")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "crossConnectionName", valid_568320
  var valid_568321 = path.getOrDefault("resourceGroupName")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "resourceGroupName", valid_568321
  var valid_568322 = path.getOrDefault("peeringName")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "peeringName", valid_568322
  var valid_568323 = path.getOrDefault("subscriptionId")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "subscriptionId", valid_568323
  var valid_568324 = path.getOrDefault("devicePath")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "devicePath", valid_568324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568325 = query.getOrDefault("api-version")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "api-version", valid_568325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568326: Call_ExpressRouteCrossConnectionsListRoutesTable_568317;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the currently advertised routes table associated with the express route cross connection in a resource group.
  ## 
  let valid = call_568326.validator(path, query, header, formData, body)
  let scheme = call_568326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568326.url(scheme.get, call_568326.host, call_568326.base,
                         call_568326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568326, url, valid)

proc call*(call_568327: Call_ExpressRouteCrossConnectionsListRoutesTable_568317;
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
  var path_568328 = newJObject()
  var query_568329 = newJObject()
  add(path_568328, "crossConnectionName", newJString(crossConnectionName))
  add(path_568328, "resourceGroupName", newJString(resourceGroupName))
  add(query_568329, "api-version", newJString(apiVersion))
  add(path_568328, "peeringName", newJString(peeringName))
  add(path_568328, "subscriptionId", newJString(subscriptionId))
  add(path_568328, "devicePath", newJString(devicePath))
  result = call_568327.call(path_568328, query_568329, nil, nil, nil)

var expressRouteCrossConnectionsListRoutesTable* = Call_ExpressRouteCrossConnectionsListRoutesTable_568317(
    name: "expressRouteCrossConnectionsListRoutesTable",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}/peerings/{peeringName}/routeTables/{devicePath}",
    validator: validate_ExpressRouteCrossConnectionsListRoutesTable_568318,
    base: "", url: url_ExpressRouteCrossConnectionsListRoutesTable_568319,
    schemes: {Scheme.Https})
type
  Call_ExpressRouteCrossConnectionsListRoutesTableSummary_568330 = ref object of OpenApiRestCall_567657
proc url_ExpressRouteCrossConnectionsListRoutesTableSummary_568332(
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

proc validate_ExpressRouteCrossConnectionsListRoutesTableSummary_568331(
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
  var valid_568333 = path.getOrDefault("crossConnectionName")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "crossConnectionName", valid_568333
  var valid_568334 = path.getOrDefault("resourceGroupName")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "resourceGroupName", valid_568334
  var valid_568335 = path.getOrDefault("peeringName")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "peeringName", valid_568335
  var valid_568336 = path.getOrDefault("subscriptionId")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "subscriptionId", valid_568336
  var valid_568337 = path.getOrDefault("devicePath")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "devicePath", valid_568337
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568338 = query.getOrDefault("api-version")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "api-version", valid_568338
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568339: Call_ExpressRouteCrossConnectionsListRoutesTableSummary_568330;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the route table summary associated with the express route cross connection in a resource group.
  ## 
  let valid = call_568339.validator(path, query, header, formData, body)
  let scheme = call_568339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568339.url(scheme.get, call_568339.host, call_568339.base,
                         call_568339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568339, url, valid)

proc call*(call_568340: Call_ExpressRouteCrossConnectionsListRoutesTableSummary_568330;
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
  var path_568341 = newJObject()
  var query_568342 = newJObject()
  add(path_568341, "crossConnectionName", newJString(crossConnectionName))
  add(path_568341, "resourceGroupName", newJString(resourceGroupName))
  add(query_568342, "api-version", newJString(apiVersion))
  add(path_568341, "peeringName", newJString(peeringName))
  add(path_568341, "subscriptionId", newJString(subscriptionId))
  add(path_568341, "devicePath", newJString(devicePath))
  result = call_568340.call(path_568341, query_568342, nil, nil, nil)

var expressRouteCrossConnectionsListRoutesTableSummary* = Call_ExpressRouteCrossConnectionsListRoutesTableSummary_568330(
    name: "expressRouteCrossConnectionsListRoutesTableSummary",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCrossConnections/{crossConnectionName}/peerings/{peeringName}/routeTablesSummary/{devicePath}",
    validator: validate_ExpressRouteCrossConnectionsListRoutesTableSummary_568331,
    base: "", url: url_ExpressRouteCrossConnectionsListRoutesTableSummary_568332,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
