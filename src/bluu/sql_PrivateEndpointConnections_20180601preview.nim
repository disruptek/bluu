
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: SqlManagementClient
## version: 2018-06-01-preview
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

  OpenApiRestCall_573641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573641): Option[Scheme] {.used.} =
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
  macServiceName = "sql-PrivateEndpointConnections"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PrivateEndpointConnectionsListByServer_573863 = ref object of OpenApiRestCall_573641
proc url_PrivateEndpointConnectionsListByServer_573865(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/privateEndpointConnections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PrivateEndpointConnectionsListByServer_573864(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all private endpoint connections on a server.
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
  var valid_574038 = path.getOrDefault("resourceGroupName")
  valid_574038 = validateParameter(valid_574038, JString, required = true,
                                 default = nil)
  if valid_574038 != nil:
    section.add "resourceGroupName", valid_574038
  var valid_574039 = path.getOrDefault("serverName")
  valid_574039 = validateParameter(valid_574039, JString, required = true,
                                 default = nil)
  if valid_574039 != nil:
    section.add "serverName", valid_574039
  var valid_574040 = path.getOrDefault("subscriptionId")
  valid_574040 = validateParameter(valid_574040, JString, required = true,
                                 default = nil)
  if valid_574040 != nil:
    section.add "subscriptionId", valid_574040
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574041 = query.getOrDefault("api-version")
  valid_574041 = validateParameter(valid_574041, JString, required = true,
                                 default = nil)
  if valid_574041 != nil:
    section.add "api-version", valid_574041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574064: Call_PrivateEndpointConnectionsListByServer_573863;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all private endpoint connections on a server.
  ## 
  let valid = call_574064.validator(path, query, header, formData, body)
  let scheme = call_574064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574064.url(scheme.get, call_574064.host, call_574064.base,
                         call_574064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574064, url, valid)

proc call*(call_574135: Call_PrivateEndpointConnectionsListByServer_573863;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string): Recallable =
  ## privateEndpointConnectionsListByServer
  ## Gets all private endpoint connections on a server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_574136 = newJObject()
  var query_574138 = newJObject()
  add(path_574136, "resourceGroupName", newJString(resourceGroupName))
  add(query_574138, "api-version", newJString(apiVersion))
  add(path_574136, "serverName", newJString(serverName))
  add(path_574136, "subscriptionId", newJString(subscriptionId))
  result = call_574135.call(path_574136, query_574138, nil, nil, nil)

var privateEndpointConnectionsListByServer* = Call_PrivateEndpointConnectionsListByServer_573863(
    name: "privateEndpointConnectionsListByServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/privateEndpointConnections",
    validator: validate_PrivateEndpointConnectionsListByServer_573864, base: "",
    url: url_PrivateEndpointConnectionsListByServer_573865,
    schemes: {Scheme.Https})
type
  Call_PrivateEndpointConnectionsCreateOrUpdate_574189 = ref object of OpenApiRestCall_573641
proc url_PrivateEndpointConnectionsCreateOrUpdate_574191(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "privateEndpointConnectionName" in path,
        "`privateEndpointConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/privateEndpointConnections/"),
               (kind: VariableSegment, value: "privateEndpointConnectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PrivateEndpointConnectionsCreateOrUpdate_574190(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Approve or reject a private endpoint connection with a given name.
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
  ##   privateEndpointConnectionName: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574192 = path.getOrDefault("resourceGroupName")
  valid_574192 = validateParameter(valid_574192, JString, required = true,
                                 default = nil)
  if valid_574192 != nil:
    section.add "resourceGroupName", valid_574192
  var valid_574193 = path.getOrDefault("serverName")
  valid_574193 = validateParameter(valid_574193, JString, required = true,
                                 default = nil)
  if valid_574193 != nil:
    section.add "serverName", valid_574193
  var valid_574194 = path.getOrDefault("subscriptionId")
  valid_574194 = validateParameter(valid_574194, JString, required = true,
                                 default = nil)
  if valid_574194 != nil:
    section.add "subscriptionId", valid_574194
  var valid_574195 = path.getOrDefault("privateEndpointConnectionName")
  valid_574195 = validateParameter(valid_574195, JString, required = true,
                                 default = nil)
  if valid_574195 != nil:
    section.add "privateEndpointConnectionName", valid_574195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574198: Call_PrivateEndpointConnectionsCreateOrUpdate_574189;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Approve or reject a private endpoint connection with a given name.
  ## 
  let valid = call_574198.validator(path, query, header, formData, body)
  let scheme = call_574198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574198.url(scheme.get, call_574198.host, call_574198.base,
                         call_574198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574198, url, valid)

proc call*(call_574199: Call_PrivateEndpointConnectionsCreateOrUpdate_574189;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; parameters: JsonNode;
          privateEndpointConnectionName: string): Recallable =
  ## privateEndpointConnectionsCreateOrUpdate
  ## Approve or reject a private endpoint connection with a given name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   parameters: JObject (required)
  ##   privateEndpointConnectionName: string (required)
  var path_574200 = newJObject()
  var query_574201 = newJObject()
  var body_574202 = newJObject()
  add(path_574200, "resourceGroupName", newJString(resourceGroupName))
  add(query_574201, "api-version", newJString(apiVersion))
  add(path_574200, "serverName", newJString(serverName))
  add(path_574200, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574202 = parameters
  add(path_574200, "privateEndpointConnectionName",
      newJString(privateEndpointConnectionName))
  result = call_574199.call(path_574200, query_574201, nil, nil, body_574202)

var privateEndpointConnectionsCreateOrUpdate* = Call_PrivateEndpointConnectionsCreateOrUpdate_574189(
    name: "privateEndpointConnectionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/privateEndpointConnections/{privateEndpointConnectionName}",
    validator: validate_PrivateEndpointConnectionsCreateOrUpdate_574190, base: "",
    url: url_PrivateEndpointConnectionsCreateOrUpdate_574191,
    schemes: {Scheme.Https})
type
  Call_PrivateEndpointConnectionsGet_574177 = ref object of OpenApiRestCall_573641
proc url_PrivateEndpointConnectionsGet_574179(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "privateEndpointConnectionName" in path,
        "`privateEndpointConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/privateEndpointConnections/"),
               (kind: VariableSegment, value: "privateEndpointConnectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PrivateEndpointConnectionsGet_574178(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a private endpoint connection.
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
  ##   privateEndpointConnectionName: JString (required)
  ##                                : The name of the private endpoint connection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574180 = path.getOrDefault("resourceGroupName")
  valid_574180 = validateParameter(valid_574180, JString, required = true,
                                 default = nil)
  if valid_574180 != nil:
    section.add "resourceGroupName", valid_574180
  var valid_574181 = path.getOrDefault("serverName")
  valid_574181 = validateParameter(valid_574181, JString, required = true,
                                 default = nil)
  if valid_574181 != nil:
    section.add "serverName", valid_574181
  var valid_574182 = path.getOrDefault("subscriptionId")
  valid_574182 = validateParameter(valid_574182, JString, required = true,
                                 default = nil)
  if valid_574182 != nil:
    section.add "subscriptionId", valid_574182
  var valid_574183 = path.getOrDefault("privateEndpointConnectionName")
  valid_574183 = validateParameter(valid_574183, JString, required = true,
                                 default = nil)
  if valid_574183 != nil:
    section.add "privateEndpointConnectionName", valid_574183
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574184 = query.getOrDefault("api-version")
  valid_574184 = validateParameter(valid_574184, JString, required = true,
                                 default = nil)
  if valid_574184 != nil:
    section.add "api-version", valid_574184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574185: Call_PrivateEndpointConnectionsGet_574177; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a private endpoint connection.
  ## 
  let valid = call_574185.validator(path, query, header, formData, body)
  let scheme = call_574185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574185.url(scheme.get, call_574185.host, call_574185.base,
                         call_574185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574185, url, valid)

proc call*(call_574186: Call_PrivateEndpointConnectionsGet_574177;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; privateEndpointConnectionName: string): Recallable =
  ## privateEndpointConnectionsGet
  ## Gets a private endpoint connection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   privateEndpointConnectionName: string (required)
  ##                                : The name of the private endpoint connection.
  var path_574187 = newJObject()
  var query_574188 = newJObject()
  add(path_574187, "resourceGroupName", newJString(resourceGroupName))
  add(query_574188, "api-version", newJString(apiVersion))
  add(path_574187, "serverName", newJString(serverName))
  add(path_574187, "subscriptionId", newJString(subscriptionId))
  add(path_574187, "privateEndpointConnectionName",
      newJString(privateEndpointConnectionName))
  result = call_574186.call(path_574187, query_574188, nil, nil, nil)

var privateEndpointConnectionsGet* = Call_PrivateEndpointConnectionsGet_574177(
    name: "privateEndpointConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/privateEndpointConnections/{privateEndpointConnectionName}",
    validator: validate_PrivateEndpointConnectionsGet_574178, base: "",
    url: url_PrivateEndpointConnectionsGet_574179, schemes: {Scheme.Https})
type
  Call_PrivateEndpointConnectionsDelete_574203 = ref object of OpenApiRestCall_573641
proc url_PrivateEndpointConnectionsDelete_574205(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "privateEndpointConnectionName" in path,
        "`privateEndpointConnectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/privateEndpointConnections/"),
               (kind: VariableSegment, value: "privateEndpointConnectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PrivateEndpointConnectionsDelete_574204(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a private endpoint connection with a given name.
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
  ##   privateEndpointConnectionName: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574206 = path.getOrDefault("resourceGroupName")
  valid_574206 = validateParameter(valid_574206, JString, required = true,
                                 default = nil)
  if valid_574206 != nil:
    section.add "resourceGroupName", valid_574206
  var valid_574207 = path.getOrDefault("serverName")
  valid_574207 = validateParameter(valid_574207, JString, required = true,
                                 default = nil)
  if valid_574207 != nil:
    section.add "serverName", valid_574207
  var valid_574208 = path.getOrDefault("subscriptionId")
  valid_574208 = validateParameter(valid_574208, JString, required = true,
                                 default = nil)
  if valid_574208 != nil:
    section.add "subscriptionId", valid_574208
  var valid_574209 = path.getOrDefault("privateEndpointConnectionName")
  valid_574209 = validateParameter(valid_574209, JString, required = true,
                                 default = nil)
  if valid_574209 != nil:
    section.add "privateEndpointConnectionName", valid_574209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574210 = query.getOrDefault("api-version")
  valid_574210 = validateParameter(valid_574210, JString, required = true,
                                 default = nil)
  if valid_574210 != nil:
    section.add "api-version", valid_574210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574211: Call_PrivateEndpointConnectionsDelete_574203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a private endpoint connection with a given name.
  ## 
  let valid = call_574211.validator(path, query, header, formData, body)
  let scheme = call_574211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574211.url(scheme.get, call_574211.host, call_574211.base,
                         call_574211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574211, url, valid)

proc call*(call_574212: Call_PrivateEndpointConnectionsDelete_574203;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; privateEndpointConnectionName: string): Recallable =
  ## privateEndpointConnectionsDelete
  ## Deletes a private endpoint connection with a given name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   privateEndpointConnectionName: string (required)
  var path_574213 = newJObject()
  var query_574214 = newJObject()
  add(path_574213, "resourceGroupName", newJString(resourceGroupName))
  add(query_574214, "api-version", newJString(apiVersion))
  add(path_574213, "serverName", newJString(serverName))
  add(path_574213, "subscriptionId", newJString(subscriptionId))
  add(path_574213, "privateEndpointConnectionName",
      newJString(privateEndpointConnectionName))
  result = call_574212.call(path_574213, query_574214, nil, nil, nil)

var privateEndpointConnectionsDelete* = Call_PrivateEndpointConnectionsDelete_574203(
    name: "privateEndpointConnectionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/privateEndpointConnections/{privateEndpointConnectionName}",
    validator: validate_PrivateEndpointConnectionsDelete_574204, base: "",
    url: url_PrivateEndpointConnectionsDelete_574205, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
