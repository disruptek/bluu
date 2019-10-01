
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SqlManagementClient
## version: 2014-04-01
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
  macServiceName = "sql-tableAuditing"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServerTableAuditingPoliciesListByServer_567864 = ref object of OpenApiRestCall_567642
proc url_ServerTableAuditingPoliciesListByServer_567866(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/auditingPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServerTableAuditingPoliciesListByServer_567865(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a server's table auditing policies. Table auditing is deprecated, use blob auditing instead.
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
  var valid_568039 = path.getOrDefault("resourceGroupName")
  valid_568039 = validateParameter(valid_568039, JString, required = true,
                                 default = nil)
  if valid_568039 != nil:
    section.add "resourceGroupName", valid_568039
  var valid_568040 = path.getOrDefault("serverName")
  valid_568040 = validateParameter(valid_568040, JString, required = true,
                                 default = nil)
  if valid_568040 != nil:
    section.add "serverName", valid_568040
  var valid_568041 = path.getOrDefault("subscriptionId")
  valid_568041 = validateParameter(valid_568041, JString, required = true,
                                 default = nil)
  if valid_568041 != nil:
    section.add "subscriptionId", valid_568041
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
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

proc call*(call_568065: Call_ServerTableAuditingPoliciesListByServer_567864;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a server's table auditing policies. Table auditing is deprecated, use blob auditing instead.
  ## 
  let valid = call_568065.validator(path, query, header, formData, body)
  let scheme = call_568065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568065.url(scheme.get, call_568065.host, call_568065.base,
                         call_568065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568065, url, valid)

proc call*(call_568136: Call_ServerTableAuditingPoliciesListByServer_567864;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string): Recallable =
  ## serverTableAuditingPoliciesListByServer
  ## Lists a server's table auditing policies. Table auditing is deprecated, use blob auditing instead.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568137 = newJObject()
  var query_568139 = newJObject()
  add(path_568137, "resourceGroupName", newJString(resourceGroupName))
  add(query_568139, "api-version", newJString(apiVersion))
  add(path_568137, "serverName", newJString(serverName))
  add(path_568137, "subscriptionId", newJString(subscriptionId))
  result = call_568136.call(path_568137, query_568139, nil, nil, nil)

var serverTableAuditingPoliciesListByServer* = Call_ServerTableAuditingPoliciesListByServer_567864(
    name: "serverTableAuditingPoliciesListByServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/auditingPolicies",
    validator: validate_ServerTableAuditingPoliciesListByServer_567865, base: "",
    url: url_ServerTableAuditingPoliciesListByServer_567866,
    schemes: {Scheme.Https})
type
  Call_ServerTableAuditingPoliciesCreateOrUpdate_568203 = ref object of OpenApiRestCall_567642
proc url_ServerTableAuditingPoliciesCreateOrUpdate_568205(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "tableAuditingPolicyName" in path,
        "`tableAuditingPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/auditingPolicies/"),
               (kind: VariableSegment, value: "tableAuditingPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServerTableAuditingPoliciesCreateOrUpdate_568204(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a server's table auditing policy. Table auditing is deprecated, use blob auditing instead.
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
  ##   tableAuditingPolicyName: JString (required)
  ##                          : The name of the table auditing policy.
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
  var valid_568208 = path.getOrDefault("subscriptionId")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "subscriptionId", valid_568208
  var valid_568209 = path.getOrDefault("tableAuditingPolicyName")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = newJString("default"))
  if valid_568209 != nil:
    section.add "tableAuditingPolicyName", valid_568209
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The server table auditing policy.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568212: Call_ServerTableAuditingPoliciesCreateOrUpdate_568203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a server's table auditing policy. Table auditing is deprecated, use blob auditing instead.
  ## 
  let valid = call_568212.validator(path, query, header, formData, body)
  let scheme = call_568212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568212.url(scheme.get, call_568212.host, call_568212.base,
                         call_568212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568212, url, valid)

proc call*(call_568213: Call_ServerTableAuditingPoliciesCreateOrUpdate_568203;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; parameters: JsonNode;
          tableAuditingPolicyName: string = "default"): Recallable =
  ## serverTableAuditingPoliciesCreateOrUpdate
  ## Creates or updates a server's table auditing policy. Table auditing is deprecated, use blob auditing instead.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   parameters: JObject (required)
  ##             : The server table auditing policy.
  ##   tableAuditingPolicyName: string (required)
  ##                          : The name of the table auditing policy.
  var path_568214 = newJObject()
  var query_568215 = newJObject()
  var body_568216 = newJObject()
  add(path_568214, "resourceGroupName", newJString(resourceGroupName))
  add(query_568215, "api-version", newJString(apiVersion))
  add(path_568214, "serverName", newJString(serverName))
  add(path_568214, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568216 = parameters
  add(path_568214, "tableAuditingPolicyName", newJString(tableAuditingPolicyName))
  result = call_568213.call(path_568214, query_568215, nil, nil, body_568216)

var serverTableAuditingPoliciesCreateOrUpdate* = Call_ServerTableAuditingPoliciesCreateOrUpdate_568203(
    name: "serverTableAuditingPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/auditingPolicies/{tableAuditingPolicyName}",
    validator: validate_ServerTableAuditingPoliciesCreateOrUpdate_568204,
    base: "", url: url_ServerTableAuditingPoliciesCreateOrUpdate_568205,
    schemes: {Scheme.Https})
type
  Call_ServerTableAuditingPoliciesGet_568178 = ref object of OpenApiRestCall_567642
proc url_ServerTableAuditingPoliciesGet_568180(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "tableAuditingPolicyName" in path,
        "`tableAuditingPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/auditingPolicies/"),
               (kind: VariableSegment, value: "tableAuditingPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServerTableAuditingPoliciesGet_568179(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a server's table auditing policy. Table auditing is deprecated, use blob auditing instead.
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
  ##   tableAuditingPolicyName: JString (required)
  ##                          : The name of the table auditing policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568181 = path.getOrDefault("resourceGroupName")
  valid_568181 = validateParameter(valid_568181, JString, required = true,
                                 default = nil)
  if valid_568181 != nil:
    section.add "resourceGroupName", valid_568181
  var valid_568182 = path.getOrDefault("serverName")
  valid_568182 = validateParameter(valid_568182, JString, required = true,
                                 default = nil)
  if valid_568182 != nil:
    section.add "serverName", valid_568182
  var valid_568183 = path.getOrDefault("subscriptionId")
  valid_568183 = validateParameter(valid_568183, JString, required = true,
                                 default = nil)
  if valid_568183 != nil:
    section.add "subscriptionId", valid_568183
  var valid_568197 = path.getOrDefault("tableAuditingPolicyName")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = newJString("default"))
  if valid_568197 != nil:
    section.add "tableAuditingPolicyName", valid_568197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
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

proc call*(call_568199: Call_ServerTableAuditingPoliciesGet_568178; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a server's table auditing policy. Table auditing is deprecated, use blob auditing instead.
  ## 
  let valid = call_568199.validator(path, query, header, formData, body)
  let scheme = call_568199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568199.url(scheme.get, call_568199.host, call_568199.base,
                         call_568199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568199, url, valid)

proc call*(call_568200: Call_ServerTableAuditingPoliciesGet_568178;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; tableAuditingPolicyName: string = "default"): Recallable =
  ## serverTableAuditingPoliciesGet
  ## Gets a server's table auditing policy. Table auditing is deprecated, use blob auditing instead.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   tableAuditingPolicyName: string (required)
  ##                          : The name of the table auditing policy.
  var path_568201 = newJObject()
  var query_568202 = newJObject()
  add(path_568201, "resourceGroupName", newJString(resourceGroupName))
  add(query_568202, "api-version", newJString(apiVersion))
  add(path_568201, "serverName", newJString(serverName))
  add(path_568201, "subscriptionId", newJString(subscriptionId))
  add(path_568201, "tableAuditingPolicyName", newJString(tableAuditingPolicyName))
  result = call_568200.call(path_568201, query_568202, nil, nil, nil)

var serverTableAuditingPoliciesGet* = Call_ServerTableAuditingPoliciesGet_568178(
    name: "serverTableAuditingPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/auditingPolicies/{tableAuditingPolicyName}",
    validator: validate_ServerTableAuditingPoliciesGet_568179, base: "",
    url: url_ServerTableAuditingPoliciesGet_568180, schemes: {Scheme.Https})
type
  Call_DatabaseTableAuditingPoliciesListByDatabase_568217 = ref object of OpenApiRestCall_567642
proc url_DatabaseTableAuditingPoliciesListByDatabase_568219(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/auditingPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseTableAuditingPoliciesListByDatabase_568218(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a database's table auditing policies. Table auditing is deprecated, use blob auditing instead.
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
  ##   databaseName: JString (required)
  ##               : The name of the database for which the table audit policy is defined.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568220 = path.getOrDefault("resourceGroupName")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "resourceGroupName", valid_568220
  var valid_568221 = path.getOrDefault("serverName")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "serverName", valid_568221
  var valid_568222 = path.getOrDefault("subscriptionId")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "subscriptionId", valid_568222
  var valid_568223 = path.getOrDefault("databaseName")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "databaseName", valid_568223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568224 = query.getOrDefault("api-version")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "api-version", valid_568224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568225: Call_DatabaseTableAuditingPoliciesListByDatabase_568217;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a database's table auditing policies. Table auditing is deprecated, use blob auditing instead.
  ## 
  let valid = call_568225.validator(path, query, header, formData, body)
  let scheme = call_568225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568225.url(scheme.get, call_568225.host, call_568225.base,
                         call_568225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568225, url, valid)

proc call*(call_568226: Call_DatabaseTableAuditingPoliciesListByDatabase_568217;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; databaseName: string): Recallable =
  ## databaseTableAuditingPoliciesListByDatabase
  ## Lists a database's table auditing policies. Table auditing is deprecated, use blob auditing instead.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database for which the table audit policy is defined.
  var path_568227 = newJObject()
  var query_568228 = newJObject()
  add(path_568227, "resourceGroupName", newJString(resourceGroupName))
  add(query_568228, "api-version", newJString(apiVersion))
  add(path_568227, "serverName", newJString(serverName))
  add(path_568227, "subscriptionId", newJString(subscriptionId))
  add(path_568227, "databaseName", newJString(databaseName))
  result = call_568226.call(path_568227, query_568228, nil, nil, nil)

var databaseTableAuditingPoliciesListByDatabase* = Call_DatabaseTableAuditingPoliciesListByDatabase_568217(
    name: "databaseTableAuditingPoliciesListByDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/auditingPolicies",
    validator: validate_DatabaseTableAuditingPoliciesListByDatabase_568218,
    base: "", url: url_DatabaseTableAuditingPoliciesListByDatabase_568219,
    schemes: {Scheme.Https})
type
  Call_DatabaseTableAuditingPoliciesCreateOrUpdate_568242 = ref object of OpenApiRestCall_567642
proc url_DatabaseTableAuditingPoliciesCreateOrUpdate_568244(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "tableAuditingPolicyName" in path,
        "`tableAuditingPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/auditingPolicies/"),
               (kind: VariableSegment, value: "tableAuditingPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseTableAuditingPoliciesCreateOrUpdate_568243(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a database's table auditing policy. Table auditing is deprecated, use blob auditing instead.
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
  ##   databaseName: JString (required)
  ##               : The name of the database for which the table auditing policy will be defined.
  ##   tableAuditingPolicyName: JString (required)
  ##                          : The name of the table auditing policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568245 = path.getOrDefault("resourceGroupName")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "resourceGroupName", valid_568245
  var valid_568246 = path.getOrDefault("serverName")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "serverName", valid_568246
  var valid_568247 = path.getOrDefault("subscriptionId")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "subscriptionId", valid_568247
  var valid_568248 = path.getOrDefault("databaseName")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "databaseName", valid_568248
  var valid_568249 = path.getOrDefault("tableAuditingPolicyName")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = newJString("default"))
  if valid_568249 != nil:
    section.add "tableAuditingPolicyName", valid_568249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568250 = query.getOrDefault("api-version")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "api-version", valid_568250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The database table auditing policy.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568252: Call_DatabaseTableAuditingPoliciesCreateOrUpdate_568242;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a database's table auditing policy. Table auditing is deprecated, use blob auditing instead.
  ## 
  let valid = call_568252.validator(path, query, header, formData, body)
  let scheme = call_568252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568252.url(scheme.get, call_568252.host, call_568252.base,
                         call_568252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568252, url, valid)

proc call*(call_568253: Call_DatabaseTableAuditingPoliciesCreateOrUpdate_568242;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; databaseName: string; parameters: JsonNode;
          tableAuditingPolicyName: string = "default"): Recallable =
  ## databaseTableAuditingPoliciesCreateOrUpdate
  ## Creates or updates a database's table auditing policy. Table auditing is deprecated, use blob auditing instead.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database for which the table auditing policy will be defined.
  ##   parameters: JObject (required)
  ##             : The database table auditing policy.
  ##   tableAuditingPolicyName: string (required)
  ##                          : The name of the table auditing policy.
  var path_568254 = newJObject()
  var query_568255 = newJObject()
  var body_568256 = newJObject()
  add(path_568254, "resourceGroupName", newJString(resourceGroupName))
  add(query_568255, "api-version", newJString(apiVersion))
  add(path_568254, "serverName", newJString(serverName))
  add(path_568254, "subscriptionId", newJString(subscriptionId))
  add(path_568254, "databaseName", newJString(databaseName))
  if parameters != nil:
    body_568256 = parameters
  add(path_568254, "tableAuditingPolicyName", newJString(tableAuditingPolicyName))
  result = call_568253.call(path_568254, query_568255, nil, nil, body_568256)

var databaseTableAuditingPoliciesCreateOrUpdate* = Call_DatabaseTableAuditingPoliciesCreateOrUpdate_568242(
    name: "databaseTableAuditingPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/auditingPolicies/{tableAuditingPolicyName}",
    validator: validate_DatabaseTableAuditingPoliciesCreateOrUpdate_568243,
    base: "", url: url_DatabaseTableAuditingPoliciesCreateOrUpdate_568244,
    schemes: {Scheme.Https})
type
  Call_DatabaseTableAuditingPoliciesGet_568229 = ref object of OpenApiRestCall_567642
proc url_DatabaseTableAuditingPoliciesGet_568231(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "tableAuditingPolicyName" in path,
        "`tableAuditingPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/auditingPolicies/"),
               (kind: VariableSegment, value: "tableAuditingPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseTableAuditingPoliciesGet_568230(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a database's table auditing policy. Table auditing is deprecated, use blob auditing instead.
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
  ##   databaseName: JString (required)
  ##               : The name of the database for which the table audit policy is defined.
  ##   tableAuditingPolicyName: JString (required)
  ##                          : The name of the table auditing policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568232 = path.getOrDefault("resourceGroupName")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "resourceGroupName", valid_568232
  var valid_568233 = path.getOrDefault("serverName")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "serverName", valid_568233
  var valid_568234 = path.getOrDefault("subscriptionId")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "subscriptionId", valid_568234
  var valid_568235 = path.getOrDefault("databaseName")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "databaseName", valid_568235
  var valid_568236 = path.getOrDefault("tableAuditingPolicyName")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = newJString("default"))
  if valid_568236 != nil:
    section.add "tableAuditingPolicyName", valid_568236
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568237 = query.getOrDefault("api-version")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "api-version", valid_568237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568238: Call_DatabaseTableAuditingPoliciesGet_568229;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a database's table auditing policy. Table auditing is deprecated, use blob auditing instead.
  ## 
  let valid = call_568238.validator(path, query, header, formData, body)
  let scheme = call_568238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568238.url(scheme.get, call_568238.host, call_568238.base,
                         call_568238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568238, url, valid)

proc call*(call_568239: Call_DatabaseTableAuditingPoliciesGet_568229;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; databaseName: string;
          tableAuditingPolicyName: string = "default"): Recallable =
  ## databaseTableAuditingPoliciesGet
  ## Gets a database's table auditing policy. Table auditing is deprecated, use blob auditing instead.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database for which the table audit policy is defined.
  ##   tableAuditingPolicyName: string (required)
  ##                          : The name of the table auditing policy.
  var path_568240 = newJObject()
  var query_568241 = newJObject()
  add(path_568240, "resourceGroupName", newJString(resourceGroupName))
  add(query_568241, "api-version", newJString(apiVersion))
  add(path_568240, "serverName", newJString(serverName))
  add(path_568240, "subscriptionId", newJString(subscriptionId))
  add(path_568240, "databaseName", newJString(databaseName))
  add(path_568240, "tableAuditingPolicyName", newJString(tableAuditingPolicyName))
  result = call_568239.call(path_568240, query_568241, nil, nil, nil)

var databaseTableAuditingPoliciesGet* = Call_DatabaseTableAuditingPoliciesGet_568229(
    name: "databaseTableAuditingPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/auditingPolicies/{tableAuditingPolicyName}",
    validator: validate_DatabaseTableAuditingPoliciesGet_568230, base: "",
    url: url_DatabaseTableAuditingPoliciesGet_568231, schemes: {Scheme.Https})
type
  Call_DatabaseConnectionPoliciesCreateOrUpdate_568270 = ref object of OpenApiRestCall_567642
proc url_DatabaseConnectionPoliciesCreateOrUpdate_568272(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "connectionPolicyName" in path,
        "`connectionPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/connectionPolicies/"),
               (kind: VariableSegment, value: "connectionPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseConnectionPoliciesCreateOrUpdate_568271(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a database's connection policy, which is used with table auditing. Table auditing is deprecated, use blob auditing instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   connectionPolicyName: JString (required)
  ##                       : The name of the connection policy.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database for which the connection policy will be defined.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568273 = path.getOrDefault("resourceGroupName")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "resourceGroupName", valid_568273
  var valid_568274 = path.getOrDefault("connectionPolicyName")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = newJString("default"))
  if valid_568274 != nil:
    section.add "connectionPolicyName", valid_568274
  var valid_568275 = path.getOrDefault("serverName")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "serverName", valid_568275
  var valid_568276 = path.getOrDefault("subscriptionId")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "subscriptionId", valid_568276
  var valid_568277 = path.getOrDefault("databaseName")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "databaseName", valid_568277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568278 = query.getOrDefault("api-version")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "api-version", valid_568278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The database connection policy.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568280: Call_DatabaseConnectionPoliciesCreateOrUpdate_568270;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a database's connection policy, which is used with table auditing. Table auditing is deprecated, use blob auditing instead.
  ## 
  let valid = call_568280.validator(path, query, header, formData, body)
  let scheme = call_568280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568280.url(scheme.get, call_568280.host, call_568280.base,
                         call_568280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568280, url, valid)

proc call*(call_568281: Call_DatabaseConnectionPoliciesCreateOrUpdate_568270;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; databaseName: string; parameters: JsonNode;
          connectionPolicyName: string = "default"): Recallable =
  ## databaseConnectionPoliciesCreateOrUpdate
  ## Creates or updates a database's connection policy, which is used with table auditing. Table auditing is deprecated, use blob auditing instead.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   connectionPolicyName: string (required)
  ##                       : The name of the connection policy.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database for which the connection policy will be defined.
  ##   parameters: JObject (required)
  ##             : The database connection policy.
  var path_568282 = newJObject()
  var query_568283 = newJObject()
  var body_568284 = newJObject()
  add(path_568282, "resourceGroupName", newJString(resourceGroupName))
  add(path_568282, "connectionPolicyName", newJString(connectionPolicyName))
  add(query_568283, "api-version", newJString(apiVersion))
  add(path_568282, "serverName", newJString(serverName))
  add(path_568282, "subscriptionId", newJString(subscriptionId))
  add(path_568282, "databaseName", newJString(databaseName))
  if parameters != nil:
    body_568284 = parameters
  result = call_568281.call(path_568282, query_568283, nil, nil, body_568284)

var databaseConnectionPoliciesCreateOrUpdate* = Call_DatabaseConnectionPoliciesCreateOrUpdate_568270(
    name: "databaseConnectionPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/connectionPolicies/{connectionPolicyName}",
    validator: validate_DatabaseConnectionPoliciesCreateOrUpdate_568271, base: "",
    url: url_DatabaseConnectionPoliciesCreateOrUpdate_568272,
    schemes: {Scheme.Https})
type
  Call_DatabaseConnectionPoliciesGet_568257 = ref object of OpenApiRestCall_567642
proc url_DatabaseConnectionPoliciesGet_568259(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "connectionPolicyName" in path,
        "`connectionPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/connectionPolicies/"),
               (kind: VariableSegment, value: "connectionPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseConnectionPoliciesGet_568258(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a database's connection policy, which is used with table auditing. Table auditing is deprecated, use blob auditing instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   connectionPolicyName: JString (required)
  ##                       : The name of the connection policy.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database for which the connection policy is defined.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568260 = path.getOrDefault("resourceGroupName")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "resourceGroupName", valid_568260
  var valid_568261 = path.getOrDefault("connectionPolicyName")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = newJString("default"))
  if valid_568261 != nil:
    section.add "connectionPolicyName", valid_568261
  var valid_568262 = path.getOrDefault("serverName")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "serverName", valid_568262
  var valid_568263 = path.getOrDefault("subscriptionId")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "subscriptionId", valid_568263
  var valid_568264 = path.getOrDefault("databaseName")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "databaseName", valid_568264
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568265 = query.getOrDefault("api-version")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "api-version", valid_568265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568266: Call_DatabaseConnectionPoliciesGet_568257; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a database's connection policy, which is used with table auditing. Table auditing is deprecated, use blob auditing instead.
  ## 
  let valid = call_568266.validator(path, query, header, formData, body)
  let scheme = call_568266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568266.url(scheme.get, call_568266.host, call_568266.base,
                         call_568266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568266, url, valid)

proc call*(call_568267: Call_DatabaseConnectionPoliciesGet_568257;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; databaseName: string;
          connectionPolicyName: string = "default"): Recallable =
  ## databaseConnectionPoliciesGet
  ## Gets a database's connection policy, which is used with table auditing. Table auditing is deprecated, use blob auditing instead.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   connectionPolicyName: string (required)
  ##                       : The name of the connection policy.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database for which the connection policy is defined.
  var path_568268 = newJObject()
  var query_568269 = newJObject()
  add(path_568268, "resourceGroupName", newJString(resourceGroupName))
  add(path_568268, "connectionPolicyName", newJString(connectionPolicyName))
  add(query_568269, "api-version", newJString(apiVersion))
  add(path_568268, "serverName", newJString(serverName))
  add(path_568268, "subscriptionId", newJString(subscriptionId))
  add(path_568268, "databaseName", newJString(databaseName))
  result = call_568267.call(path_568268, query_568269, nil, nil, nil)

var databaseConnectionPoliciesGet* = Call_DatabaseConnectionPoliciesGet_568257(
    name: "databaseConnectionPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/connectionPolicies/{connectionPolicyName}",
    validator: validate_DatabaseConnectionPoliciesGet_568258, base: "",
    url: url_DatabaseConnectionPoliciesGet_568259, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
