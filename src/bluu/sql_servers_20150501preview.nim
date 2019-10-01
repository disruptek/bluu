
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SqlManagementClient
## version: 2015-05-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The Azure SQL Database management API provides a RESTful set of web APIs that interact with Azure SQL Database services to manage your databases. The API enables users to create, retrieve, update, and delete databases, servers, and other entities.
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

  OpenApiRestCall_567641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567641): Option[Scheme] {.used.} =
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
  macServiceName = "sql-servers"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServersList_567863 = ref object of OpenApiRestCall_567641
proc url_ServersList_567865(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersList_567864(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of all servers in the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568038 = path.getOrDefault("subscriptionId")
  valid_568038 = validateParameter(valid_568038, JString, required = true,
                                 default = nil)
  if valid_568038 != nil:
    section.add "subscriptionId", valid_568038
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568039 = query.getOrDefault("api-version")
  valid_568039 = validateParameter(valid_568039, JString, required = true,
                                 default = nil)
  if valid_568039 != nil:
    section.add "api-version", valid_568039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568062: Call_ServersList_567863; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all servers in the subscription.
  ## 
  let valid = call_568062.validator(path, query, header, formData, body)
  let scheme = call_568062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568062.url(scheme.get, call_568062.host, call_568062.base,
                         call_568062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568062, url, valid)

proc call*(call_568133: Call_ServersList_567863; apiVersion: string;
          subscriptionId: string): Recallable =
  ## serversList
  ## Gets a list of all servers in the subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568134 = newJObject()
  var query_568136 = newJObject()
  add(query_568136, "api-version", newJString(apiVersion))
  add(path_568134, "subscriptionId", newJString(subscriptionId))
  result = call_568133.call(path_568134, query_568136, nil, nil, nil)

var serversList* = Call_ServersList_567863(name: "serversList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Sql/servers",
                                        validator: validate_ServersList_567864,
                                        base: "", url: url_ServersList_567865,
                                        schemes: {Scheme.Https})
type
  Call_ServersListByResourceGroup_568175 = ref object of OpenApiRestCall_567641
proc url_ServersListByResourceGroup_568177(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersListByResourceGroup_568176(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of servers in a resource groups.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568178 = path.getOrDefault("resourceGroupName")
  valid_568178 = validateParameter(valid_568178, JString, required = true,
                                 default = nil)
  if valid_568178 != nil:
    section.add "resourceGroupName", valid_568178
  var valid_568179 = path.getOrDefault("subscriptionId")
  valid_568179 = validateParameter(valid_568179, JString, required = true,
                                 default = nil)
  if valid_568179 != nil:
    section.add "subscriptionId", valid_568179
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568180 = query.getOrDefault("api-version")
  valid_568180 = validateParameter(valid_568180, JString, required = true,
                                 default = nil)
  if valid_568180 != nil:
    section.add "api-version", valid_568180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568181: Call_ServersListByResourceGroup_568175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of servers in a resource groups.
  ## 
  let valid = call_568181.validator(path, query, header, formData, body)
  let scheme = call_568181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568181.url(scheme.get, call_568181.host, call_568181.base,
                         call_568181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568181, url, valid)

proc call*(call_568182: Call_ServersListByResourceGroup_568175;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## serversListByResourceGroup
  ## Gets a list of servers in a resource groups.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568183 = newJObject()
  var query_568184 = newJObject()
  add(path_568183, "resourceGroupName", newJString(resourceGroupName))
  add(query_568184, "api-version", newJString(apiVersion))
  add(path_568183, "subscriptionId", newJString(subscriptionId))
  result = call_568182.call(path_568183, query_568184, nil, nil, nil)

var serversListByResourceGroup* = Call_ServersListByResourceGroup_568175(
    name: "serversListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers",
    validator: validate_ServersListByResourceGroup_568176, base: "",
    url: url_ServersListByResourceGroup_568177, schemes: {Scheme.Https})
type
  Call_ServersCreateOrUpdate_568196 = ref object of OpenApiRestCall_567641
proc url_ServersCreateOrUpdate_568198(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersCreateOrUpdate_568197(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568199 = path.getOrDefault("resourceGroupName")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "resourceGroupName", valid_568199
  var valid_568200 = path.getOrDefault("serverName")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "serverName", valid_568200
  var valid_568201 = path.getOrDefault("subscriptionId")
  valid_568201 = validateParameter(valid_568201, JString, required = true,
                                 default = nil)
  if valid_568201 != nil:
    section.add "subscriptionId", valid_568201
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568202 = query.getOrDefault("api-version")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "api-version", valid_568202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The requested server resource state.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568204: Call_ServersCreateOrUpdate_568196; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a server.
  ## 
  let valid = call_568204.validator(path, query, header, formData, body)
  let scheme = call_568204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568204.url(scheme.get, call_568204.host, call_568204.base,
                         call_568204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568204, url, valid)

proc call*(call_568205: Call_ServersCreateOrUpdate_568196;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## serversCreateOrUpdate
  ## Creates or updates a server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   parameters: JObject (required)
  ##             : The requested server resource state.
  var path_568206 = newJObject()
  var query_568207 = newJObject()
  var body_568208 = newJObject()
  add(path_568206, "resourceGroupName", newJString(resourceGroupName))
  add(query_568207, "api-version", newJString(apiVersion))
  add(path_568206, "serverName", newJString(serverName))
  add(path_568206, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568208 = parameters
  result = call_568205.call(path_568206, query_568207, nil, nil, body_568208)

var serversCreateOrUpdate* = Call_ServersCreateOrUpdate_568196(
    name: "serversCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}",
    validator: validate_ServersCreateOrUpdate_568197, base: "",
    url: url_ServersCreateOrUpdate_568198, schemes: {Scheme.Https})
type
  Call_ServersGet_568185 = ref object of OpenApiRestCall_567641
proc url_ServersGet_568187(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersGet_568186(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568188 = path.getOrDefault("resourceGroupName")
  valid_568188 = validateParameter(valid_568188, JString, required = true,
                                 default = nil)
  if valid_568188 != nil:
    section.add "resourceGroupName", valid_568188
  var valid_568189 = path.getOrDefault("serverName")
  valid_568189 = validateParameter(valid_568189, JString, required = true,
                                 default = nil)
  if valid_568189 != nil:
    section.add "serverName", valid_568189
  var valid_568190 = path.getOrDefault("subscriptionId")
  valid_568190 = validateParameter(valid_568190, JString, required = true,
                                 default = nil)
  if valid_568190 != nil:
    section.add "subscriptionId", valid_568190
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568191 = query.getOrDefault("api-version")
  valid_568191 = validateParameter(valid_568191, JString, required = true,
                                 default = nil)
  if valid_568191 != nil:
    section.add "api-version", valid_568191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568192: Call_ServersGet_568185; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a server.
  ## 
  let valid = call_568192.validator(path, query, header, formData, body)
  let scheme = call_568192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568192.url(scheme.get, call_568192.host, call_568192.base,
                         call_568192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568192, url, valid)

proc call*(call_568193: Call_ServersGet_568185; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string): Recallable =
  ## serversGet
  ## Gets a server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568194 = newJObject()
  var query_568195 = newJObject()
  add(path_568194, "resourceGroupName", newJString(resourceGroupName))
  add(query_568195, "api-version", newJString(apiVersion))
  add(path_568194, "serverName", newJString(serverName))
  add(path_568194, "subscriptionId", newJString(subscriptionId))
  result = call_568193.call(path_568194, query_568195, nil, nil, nil)

var serversGet* = Call_ServersGet_568185(name: "serversGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}",
                                      validator: validate_ServersGet_568186,
                                      base: "", url: url_ServersGet_568187,
                                      schemes: {Scheme.Https})
type
  Call_ServersUpdate_568220 = ref object of OpenApiRestCall_567641
proc url_ServersUpdate_568222(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersUpdate_568221(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568223 = path.getOrDefault("resourceGroupName")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "resourceGroupName", valid_568223
  var valid_568224 = path.getOrDefault("serverName")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "serverName", valid_568224
  var valid_568225 = path.getOrDefault("subscriptionId")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "subscriptionId", valid_568225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568226 = query.getOrDefault("api-version")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "api-version", valid_568226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The requested server resource state.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568228: Call_ServersUpdate_568220; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a server.
  ## 
  let valid = call_568228.validator(path, query, header, formData, body)
  let scheme = call_568228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568228.url(scheme.get, call_568228.host, call_568228.base,
                         call_568228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568228, url, valid)

proc call*(call_568229: Call_ServersUpdate_568220; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## serversUpdate
  ## Updates a server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   parameters: JObject (required)
  ##             : The requested server resource state.
  var path_568230 = newJObject()
  var query_568231 = newJObject()
  var body_568232 = newJObject()
  add(path_568230, "resourceGroupName", newJString(resourceGroupName))
  add(query_568231, "api-version", newJString(apiVersion))
  add(path_568230, "serverName", newJString(serverName))
  add(path_568230, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568232 = parameters
  result = call_568229.call(path_568230, query_568231, nil, nil, body_568232)

var serversUpdate* = Call_ServersUpdate_568220(name: "serversUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}",
    validator: validate_ServersUpdate_568221, base: "", url: url_ServersUpdate_568222,
    schemes: {Scheme.Https})
type
  Call_ServersDelete_568209 = ref object of OpenApiRestCall_567641
proc url_ServersDelete_568211(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersDelete_568210(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568212 = path.getOrDefault("resourceGroupName")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "resourceGroupName", valid_568212
  var valid_568213 = path.getOrDefault("serverName")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "serverName", valid_568213
  var valid_568214 = path.getOrDefault("subscriptionId")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "subscriptionId", valid_568214
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568215 = query.getOrDefault("api-version")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "api-version", valid_568215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568216: Call_ServersDelete_568209; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a server.
  ## 
  let valid = call_568216.validator(path, query, header, formData, body)
  let scheme = call_568216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568216.url(scheme.get, call_568216.host, call_568216.base,
                         call_568216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568216, url, valid)

proc call*(call_568217: Call_ServersDelete_568209; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string): Recallable =
  ## serversDelete
  ## Deletes a server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568218 = newJObject()
  var query_568219 = newJObject()
  add(path_568218, "resourceGroupName", newJString(resourceGroupName))
  add(query_568219, "api-version", newJString(apiVersion))
  add(path_568218, "serverName", newJString(serverName))
  add(path_568218, "subscriptionId", newJString(subscriptionId))
  result = call_568217.call(path_568218, query_568219, nil, nil, nil)

var serversDelete* = Call_ServersDelete_568209(name: "serversDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}",
    validator: validate_ServersDelete_568210, base: "", url: url_ServersDelete_568211,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
