
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Resource Graph Query
## version: 2018-09-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Resource Graph Query API Reference
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

  OpenApiRestCall_567642 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567642](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567642): Option[Scheme] {.used.} =
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
  macServiceName = "resourcegraph-graphquery"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567864 = ref object of OpenApiRestCall_567642
proc url_OperationsList_567866(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567865(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568025 = query.getOrDefault("api-version")
  valid_568025 = validateParameter(valid_568025, JString, required = true,
                                 default = nil)
  if valid_568025 != nil:
    section.add "api-version", valid_568025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568048: Call_OperationsList_567864; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available REST API operations.
  ## 
  let valid = call_568048.validator(path, query, header, formData, body)
  let scheme = call_568048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568048.url(scheme.get, call_568048.host, call_568048.base,
                         call_568048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568048, url, valid)

proc call*(call_568119: Call_OperationsList_567864; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available REST API operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568120 = newJObject()
  add(query_568120, "api-version", newJString(apiVersion))
  result = call_568119.call(nil, query_568120, nil, nil, nil)

var operationsList* = Call_OperationsList_567864(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ResourceGraph/operations",
    validator: validate_OperationsList_567865, base: "", url: url_OperationsList_567866,
    schemes: {Scheme.Https})
type
  Call_GraphQueryList_568160 = ref object of OpenApiRestCall_567642
proc url_GraphQueryList_568162(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/resourceGroup/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.ResourceGraph/queries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GraphQueryList_568161(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get all graph queries defined within a specified subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568177 = path.getOrDefault("resourceGroupName")
  valid_568177 = validateParameter(valid_568177, JString, required = true,
                                 default = nil)
  if valid_568177 != nil:
    section.add "resourceGroupName", valid_568177
  var valid_568178 = path.getOrDefault("subscriptionId")
  valid_568178 = validateParameter(valid_568178, JString, required = true,
                                 default = nil)
  if valid_568178 != nil:
    section.add "subscriptionId", valid_568178
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568179 = query.getOrDefault("api-version")
  valid_568179 = validateParameter(valid_568179, JString, required = true,
                                 default = nil)
  if valid_568179 != nil:
    section.add "api-version", valid_568179
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568180: Call_GraphQueryList_568160; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all graph queries defined within a specified subscription and resource group.
  ## 
  let valid = call_568180.validator(path, query, header, formData, body)
  let scheme = call_568180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568180.url(scheme.get, call_568180.host, call_568180.base,
                         call_568180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568180, url, valid)

proc call*(call_568181: Call_GraphQueryList_568160; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## graphQueryList
  ## Get all graph queries defined within a specified subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription Id.
  var path_568182 = newJObject()
  var query_568183 = newJObject()
  add(path_568182, "resourceGroupName", newJString(resourceGroupName))
  add(query_568183, "api-version", newJString(apiVersion))
  add(path_568182, "subscriptionId", newJString(subscriptionId))
  result = call_568181.call(path_568182, query_568183, nil, nil, nil)

var graphQueryList* = Call_GraphQueryList_568160(name: "graphQueryList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroup/{resourceGroupName}/providers/Microsoft.ResourceGraph/queries",
    validator: validate_GraphQueryList_568161, base: "", url: url_GraphQueryList_568162,
    schemes: {Scheme.Https})
type
  Call_GraphQueryCreateOrUpdate_568195 = ref object of OpenApiRestCall_567642
proc url_GraphQueryCreateOrUpdate_568197(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroup/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ResourceGraph/queries/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GraphQueryCreateOrUpdate_568196(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new graph query.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the Graph Query resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568215 = path.getOrDefault("resourceGroupName")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "resourceGroupName", valid_568215
  var valid_568216 = path.getOrDefault("subscriptionId")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "subscriptionId", valid_568216
  var valid_568217 = path.getOrDefault("resourceName")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "resourceName", valid_568217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568218 = query.getOrDefault("api-version")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "api-version", valid_568218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   properties: JObject (required)
  ##             : Properties that need to be specified to create a new graph query.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568220: Call_GraphQueryCreateOrUpdate_568195; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new graph query.
  ## 
  let valid = call_568220.validator(path, query, header, formData, body)
  let scheme = call_568220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568220.url(scheme.get, call_568220.host, call_568220.base,
                         call_568220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568220, url, valid)

proc call*(call_568221: Call_GraphQueryCreateOrUpdate_568195;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; properties: JsonNode): Recallable =
  ## graphQueryCreateOrUpdate
  ## Create a new graph query.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the Graph Query resource.
  ##   properties: JObject (required)
  ##             : Properties that need to be specified to create a new graph query.
  var path_568222 = newJObject()
  var query_568223 = newJObject()
  var body_568224 = newJObject()
  add(path_568222, "resourceGroupName", newJString(resourceGroupName))
  add(query_568223, "api-version", newJString(apiVersion))
  add(path_568222, "subscriptionId", newJString(subscriptionId))
  add(path_568222, "resourceName", newJString(resourceName))
  if properties != nil:
    body_568224 = properties
  result = call_568221.call(path_568222, query_568223, nil, nil, body_568224)

var graphQueryCreateOrUpdate* = Call_GraphQueryCreateOrUpdate_568195(
    name: "graphQueryCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroup/{resourceGroupName}/providers/Microsoft.ResourceGraph/queries/{resourceName}",
    validator: validate_GraphQueryCreateOrUpdate_568196, base: "",
    url: url_GraphQueryCreateOrUpdate_568197, schemes: {Scheme.Https})
type
  Call_GraphQueryGet_568184 = ref object of OpenApiRestCall_567642
proc url_GraphQueryGet_568186(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroup/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ResourceGraph/queries/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GraphQueryGet_568185(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a single graph query by its resourceName.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the Graph Query resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568187 = path.getOrDefault("resourceGroupName")
  valid_568187 = validateParameter(valid_568187, JString, required = true,
                                 default = nil)
  if valid_568187 != nil:
    section.add "resourceGroupName", valid_568187
  var valid_568188 = path.getOrDefault("subscriptionId")
  valid_568188 = validateParameter(valid_568188, JString, required = true,
                                 default = nil)
  if valid_568188 != nil:
    section.add "subscriptionId", valid_568188
  var valid_568189 = path.getOrDefault("resourceName")
  valid_568189 = validateParameter(valid_568189, JString, required = true,
                                 default = nil)
  if valid_568189 != nil:
    section.add "resourceName", valid_568189
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568190 = query.getOrDefault("api-version")
  valid_568190 = validateParameter(valid_568190, JString, required = true,
                                 default = nil)
  if valid_568190 != nil:
    section.add "api-version", valid_568190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568191: Call_GraphQueryGet_568184; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a single graph query by its resourceName.
  ## 
  let valid = call_568191.validator(path, query, header, formData, body)
  let scheme = call_568191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568191.url(scheme.get, call_568191.host, call_568191.base,
                         call_568191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568191, url, valid)

proc call*(call_568192: Call_GraphQueryGet_568184; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string): Recallable =
  ## graphQueryGet
  ## Get a single graph query by its resourceName.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the Graph Query resource.
  var path_568193 = newJObject()
  var query_568194 = newJObject()
  add(path_568193, "resourceGroupName", newJString(resourceGroupName))
  add(query_568194, "api-version", newJString(apiVersion))
  add(path_568193, "subscriptionId", newJString(subscriptionId))
  add(path_568193, "resourceName", newJString(resourceName))
  result = call_568192.call(path_568193, query_568194, nil, nil, nil)

var graphQueryGet* = Call_GraphQueryGet_568184(name: "graphQueryGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroup/{resourceGroupName}/providers/Microsoft.ResourceGraph/queries/{resourceName}",
    validator: validate_GraphQueryGet_568185, base: "", url: url_GraphQueryGet_568186,
    schemes: {Scheme.Https})
type
  Call_GraphQueryUpdate_568236 = ref object of OpenApiRestCall_567642
proc url_GraphQueryUpdate_568238(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroup/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ResourceGraph/queries/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GraphQueryUpdate_568237(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates a graph query that has already been added.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the Graph Query resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568239 = path.getOrDefault("resourceGroupName")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "resourceGroupName", valid_568239
  var valid_568240 = path.getOrDefault("subscriptionId")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "subscriptionId", valid_568240
  var valid_568241 = path.getOrDefault("resourceName")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "resourceName", valid_568241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568242 = query.getOrDefault("api-version")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "api-version", valid_568242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Properties that need to be specified to create a new graph query.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568244: Call_GraphQueryUpdate_568236; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a graph query that has already been added.
  ## 
  let valid = call_568244.validator(path, query, header, formData, body)
  let scheme = call_568244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568244.url(scheme.get, call_568244.host, call_568244.base,
                         call_568244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568244, url, valid)

proc call*(call_568245: Call_GraphQueryUpdate_568236; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          body: JsonNode): Recallable =
  ## graphQueryUpdate
  ## Updates a graph query that has already been added.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the Graph Query resource.
  ##   body: JObject (required)
  ##       : Properties that need to be specified to create a new graph query.
  var path_568246 = newJObject()
  var query_568247 = newJObject()
  var body_568248 = newJObject()
  add(path_568246, "resourceGroupName", newJString(resourceGroupName))
  add(query_568247, "api-version", newJString(apiVersion))
  add(path_568246, "subscriptionId", newJString(subscriptionId))
  add(path_568246, "resourceName", newJString(resourceName))
  if body != nil:
    body_568248 = body
  result = call_568245.call(path_568246, query_568247, nil, nil, body_568248)

var graphQueryUpdate* = Call_GraphQueryUpdate_568236(name: "graphQueryUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroup/{resourceGroupName}/providers/Microsoft.ResourceGraph/queries/{resourceName}",
    validator: validate_GraphQueryUpdate_568237, base: "",
    url: url_GraphQueryUpdate_568238, schemes: {Scheme.Https})
type
  Call_GraphQueryDelete_568225 = ref object of OpenApiRestCall_567642
proc url_GraphQueryDelete_568227(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroup/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ResourceGraph/queries/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GraphQueryDelete_568226(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Delete a graph query.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the Graph Query resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568228 = path.getOrDefault("resourceGroupName")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "resourceGroupName", valid_568228
  var valid_568229 = path.getOrDefault("subscriptionId")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "subscriptionId", valid_568229
  var valid_568230 = path.getOrDefault("resourceName")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "resourceName", valid_568230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568231 = query.getOrDefault("api-version")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "api-version", valid_568231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568232: Call_GraphQueryDelete_568225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a graph query.
  ## 
  let valid = call_568232.validator(path, query, header, formData, body)
  let scheme = call_568232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568232.url(scheme.get, call_568232.host, call_568232.base,
                         call_568232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568232, url, valid)

proc call*(call_568233: Call_GraphQueryDelete_568225; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string): Recallable =
  ## graphQueryDelete
  ## Delete a graph query.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the Graph Query resource.
  var path_568234 = newJObject()
  var query_568235 = newJObject()
  add(path_568234, "resourceGroupName", newJString(resourceGroupName))
  add(query_568235, "api-version", newJString(apiVersion))
  add(path_568234, "subscriptionId", newJString(subscriptionId))
  add(path_568234, "resourceName", newJString(resourceName))
  result = call_568233.call(path_568234, query_568235, nil, nil, nil)

var graphQueryDelete* = Call_GraphQueryDelete_568225(name: "graphQueryDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroup/{resourceGroupName}/providers/Microsoft.ResourceGraph/queries/{resourceName}",
    validator: validate_GraphQueryDelete_568226, base: "",
    url: url_GraphQueryDelete_568227, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
