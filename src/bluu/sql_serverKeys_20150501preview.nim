
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
  macServiceName = "sql-serverKeys"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServerKeysListByServer_567863 = ref object of OpenApiRestCall_567641
proc url_ServerKeysListByServer_567865(protocol: Scheme; host: string; base: string;
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
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/keys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServerKeysListByServer_567864(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of server keys.
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
  var valid_568038 = path.getOrDefault("resourceGroupName")
  valid_568038 = validateParameter(valid_568038, JString, required = true,
                                 default = nil)
  if valid_568038 != nil:
    section.add "resourceGroupName", valid_568038
  var valid_568039 = path.getOrDefault("serverName")
  valid_568039 = validateParameter(valid_568039, JString, required = true,
                                 default = nil)
  if valid_568039 != nil:
    section.add "serverName", valid_568039
  var valid_568040 = path.getOrDefault("subscriptionId")
  valid_568040 = validateParameter(valid_568040, JString, required = true,
                                 default = nil)
  if valid_568040 != nil:
    section.add "subscriptionId", valid_568040
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568041 = query.getOrDefault("api-version")
  valid_568041 = validateParameter(valid_568041, JString, required = true,
                                 default = nil)
  if valid_568041 != nil:
    section.add "api-version", valid_568041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568064: Call_ServerKeysListByServer_567863; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of server keys.
  ## 
  let valid = call_568064.validator(path, query, header, formData, body)
  let scheme = call_568064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568064.url(scheme.get, call_568064.host, call_568064.base,
                         call_568064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568064, url, valid)

proc call*(call_568135: Call_ServerKeysListByServer_567863;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string): Recallable =
  ## serverKeysListByServer
  ## Gets a list of server keys.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568136 = newJObject()
  var query_568138 = newJObject()
  add(path_568136, "resourceGroupName", newJString(resourceGroupName))
  add(query_568138, "api-version", newJString(apiVersion))
  add(path_568136, "serverName", newJString(serverName))
  add(path_568136, "subscriptionId", newJString(subscriptionId))
  result = call_568135.call(path_568136, query_568138, nil, nil, nil)

var serverKeysListByServer* = Call_ServerKeysListByServer_567863(
    name: "serverKeysListByServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/keys",
    validator: validate_ServerKeysListByServer_567864, base: "",
    url: url_ServerKeysListByServer_567865, schemes: {Scheme.Https})
type
  Call_ServerKeysCreateOrUpdate_568189 = ref object of OpenApiRestCall_567641
proc url_ServerKeysCreateOrUpdate_568191(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "keyName" in path, "`keyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/keys/"),
               (kind: VariableSegment, value: "keyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServerKeysCreateOrUpdate_568190(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a server key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   keyName: JString (required)
  ##          : The name of the server key to be operated on (updated or created). The key name is required to be in the format of 'vault_key_version'. For example, if the keyId is 
  ## https://YourVaultName.vault.azure.net/keys/YourKeyName/01234567890123456789012345678901, then the server key name should be formatted as: YourVaultName_YourKeyName_01234567890123456789012345678901
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568192 = path.getOrDefault("resourceGroupName")
  valid_568192 = validateParameter(valid_568192, JString, required = true,
                                 default = nil)
  if valid_568192 != nil:
    section.add "resourceGroupName", valid_568192
  var valid_568193 = path.getOrDefault("serverName")
  valid_568193 = validateParameter(valid_568193, JString, required = true,
                                 default = nil)
  if valid_568193 != nil:
    section.add "serverName", valid_568193
  var valid_568194 = path.getOrDefault("keyName")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "keyName", valid_568194
  var valid_568195 = path.getOrDefault("subscriptionId")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "subscriptionId", valid_568195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568196 = query.getOrDefault("api-version")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "api-version", valid_568196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The requested server key resource state.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568198: Call_ServerKeysCreateOrUpdate_568189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a server key.
  ## 
  let valid = call_568198.validator(path, query, header, formData, body)
  let scheme = call_568198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568198.url(scheme.get, call_568198.host, call_568198.base,
                         call_568198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568198, url, valid)

proc call*(call_568199: Call_ServerKeysCreateOrUpdate_568189;
          resourceGroupName: string; apiVersion: string; serverName: string;
          keyName: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## serverKeysCreateOrUpdate
  ## Creates or updates a server key.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   keyName: string (required)
  ##          : The name of the server key to be operated on (updated or created). The key name is required to be in the format of 'vault_key_version'. For example, if the keyId is 
  ## https://YourVaultName.vault.azure.net/keys/YourKeyName/01234567890123456789012345678901, then the server key name should be formatted as: YourVaultName_YourKeyName_01234567890123456789012345678901
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   parameters: JObject (required)
  ##             : The requested server key resource state.
  var path_568200 = newJObject()
  var query_568201 = newJObject()
  var body_568202 = newJObject()
  add(path_568200, "resourceGroupName", newJString(resourceGroupName))
  add(query_568201, "api-version", newJString(apiVersion))
  add(path_568200, "serverName", newJString(serverName))
  add(path_568200, "keyName", newJString(keyName))
  add(path_568200, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568202 = parameters
  result = call_568199.call(path_568200, query_568201, nil, nil, body_568202)

var serverKeysCreateOrUpdate* = Call_ServerKeysCreateOrUpdate_568189(
    name: "serverKeysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/keys/{keyName}",
    validator: validate_ServerKeysCreateOrUpdate_568190, base: "",
    url: url_ServerKeysCreateOrUpdate_568191, schemes: {Scheme.Https})
type
  Call_ServerKeysGet_568177 = ref object of OpenApiRestCall_567641
proc url_ServerKeysGet_568179(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "keyName" in path, "`keyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/keys/"),
               (kind: VariableSegment, value: "keyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServerKeysGet_568178(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a server key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   keyName: JString (required)
  ##          : The name of the server key to be retrieved.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568180 = path.getOrDefault("resourceGroupName")
  valid_568180 = validateParameter(valid_568180, JString, required = true,
                                 default = nil)
  if valid_568180 != nil:
    section.add "resourceGroupName", valid_568180
  var valid_568181 = path.getOrDefault("serverName")
  valid_568181 = validateParameter(valid_568181, JString, required = true,
                                 default = nil)
  if valid_568181 != nil:
    section.add "serverName", valid_568181
  var valid_568182 = path.getOrDefault("keyName")
  valid_568182 = validateParameter(valid_568182, JString, required = true,
                                 default = nil)
  if valid_568182 != nil:
    section.add "keyName", valid_568182
  var valid_568183 = path.getOrDefault("subscriptionId")
  valid_568183 = validateParameter(valid_568183, JString, required = true,
                                 default = nil)
  if valid_568183 != nil:
    section.add "subscriptionId", valid_568183
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568184 = query.getOrDefault("api-version")
  valid_568184 = validateParameter(valid_568184, JString, required = true,
                                 default = nil)
  if valid_568184 != nil:
    section.add "api-version", valid_568184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568185: Call_ServerKeysGet_568177; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a server key.
  ## 
  let valid = call_568185.validator(path, query, header, formData, body)
  let scheme = call_568185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568185.url(scheme.get, call_568185.host, call_568185.base,
                         call_568185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568185, url, valid)

proc call*(call_568186: Call_ServerKeysGet_568177; resourceGroupName: string;
          apiVersion: string; serverName: string; keyName: string;
          subscriptionId: string): Recallable =
  ## serverKeysGet
  ## Gets a server key.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   keyName: string (required)
  ##          : The name of the server key to be retrieved.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568187 = newJObject()
  var query_568188 = newJObject()
  add(path_568187, "resourceGroupName", newJString(resourceGroupName))
  add(query_568188, "api-version", newJString(apiVersion))
  add(path_568187, "serverName", newJString(serverName))
  add(path_568187, "keyName", newJString(keyName))
  add(path_568187, "subscriptionId", newJString(subscriptionId))
  result = call_568186.call(path_568187, query_568188, nil, nil, nil)

var serverKeysGet* = Call_ServerKeysGet_568177(name: "serverKeysGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/keys/{keyName}",
    validator: validate_ServerKeysGet_568178, base: "", url: url_ServerKeysGet_568179,
    schemes: {Scheme.Https})
type
  Call_ServerKeysDelete_568203 = ref object of OpenApiRestCall_567641
proc url_ServerKeysDelete_568205(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "keyName" in path, "`keyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/keys/"),
               (kind: VariableSegment, value: "keyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServerKeysDelete_568204(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes the server key with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   keyName: JString (required)
  ##          : The name of the server key to be deleted.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568206 = path.getOrDefault("resourceGroupName")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "resourceGroupName", valid_568206
  var valid_568207 = path.getOrDefault("serverName")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "serverName", valid_568207
  var valid_568208 = path.getOrDefault("keyName")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "keyName", valid_568208
  var valid_568209 = path.getOrDefault("subscriptionId")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "subscriptionId", valid_568209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568210 = query.getOrDefault("api-version")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "api-version", valid_568210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568211: Call_ServerKeysDelete_568203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the server key with the given name.
  ## 
  let valid = call_568211.validator(path, query, header, formData, body)
  let scheme = call_568211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568211.url(scheme.get, call_568211.host, call_568211.base,
                         call_568211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568211, url, valid)

proc call*(call_568212: Call_ServerKeysDelete_568203; resourceGroupName: string;
          apiVersion: string; serverName: string; keyName: string;
          subscriptionId: string): Recallable =
  ## serverKeysDelete
  ## Deletes the server key with the given name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   keyName: string (required)
  ##          : The name of the server key to be deleted.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568213 = newJObject()
  var query_568214 = newJObject()
  add(path_568213, "resourceGroupName", newJString(resourceGroupName))
  add(query_568214, "api-version", newJString(apiVersion))
  add(path_568213, "serverName", newJString(serverName))
  add(path_568213, "keyName", newJString(keyName))
  add(path_568213, "subscriptionId", newJString(subscriptionId))
  result = call_568212.call(path_568213, query_568214, nil, nil, nil)

var serverKeysDelete* = Call_ServerKeysDelete_568203(name: "serverKeysDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/keys/{keyName}",
    validator: validate_ServerKeysDelete_568204, base: "",
    url: url_ServerKeysDelete_568205, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
