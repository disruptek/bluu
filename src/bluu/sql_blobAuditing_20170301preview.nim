
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: SqlManagementClient
## version: 2017-03-01-preview
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
  macServiceName = "sql-blobAuditing"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServerBlobAuditingPoliciesListByServer_563777 = ref object of OpenApiRestCall_563555
proc url_ServerBlobAuditingPoliciesListByServer_563779(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/auditingSettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServerBlobAuditingPoliciesListByServer_563778(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists auditing settings of a server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_563954 = path.getOrDefault("serverName")
  valid_563954 = validateParameter(valid_563954, JString, required = true,
                                 default = nil)
  if valid_563954 != nil:
    section.add "serverName", valid_563954
  var valid_563955 = path.getOrDefault("subscriptionId")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "subscriptionId", valid_563955
  var valid_563956 = path.getOrDefault("resourceGroupName")
  valid_563956 = validateParameter(valid_563956, JString, required = true,
                                 default = nil)
  if valid_563956 != nil:
    section.add "resourceGroupName", valid_563956
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563957 = query.getOrDefault("api-version")
  valid_563957 = validateParameter(valid_563957, JString, required = true,
                                 default = nil)
  if valid_563957 != nil:
    section.add "api-version", valid_563957
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563980: Call_ServerBlobAuditingPoliciesListByServer_563777;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists auditing settings of a server.
  ## 
  let valid = call_563980.validator(path, query, header, formData, body)
  let scheme = call_563980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563980.url(scheme.get, call_563980.host, call_563980.base,
                         call_563980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563980, url, valid)

proc call*(call_564051: Call_ServerBlobAuditingPoliciesListByServer_563777;
          apiVersion: string; serverName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## serverBlobAuditingPoliciesListByServer
  ## Lists auditing settings of a server.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564052 = newJObject()
  var query_564054 = newJObject()
  add(query_564054, "api-version", newJString(apiVersion))
  add(path_564052, "serverName", newJString(serverName))
  add(path_564052, "subscriptionId", newJString(subscriptionId))
  add(path_564052, "resourceGroupName", newJString(resourceGroupName))
  result = call_564051.call(path_564052, query_564054, nil, nil, nil)

var serverBlobAuditingPoliciesListByServer* = Call_ServerBlobAuditingPoliciesListByServer_563777(
    name: "serverBlobAuditingPoliciesListByServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/auditingSettings",
    validator: validate_ServerBlobAuditingPoliciesListByServer_563778, base: "",
    url: url_ServerBlobAuditingPoliciesListByServer_563779,
    schemes: {Scheme.Https})
type
  Call_ServerBlobAuditingPoliciesCreateOrUpdate_564118 = ref object of OpenApiRestCall_563555
proc url_ServerBlobAuditingPoliciesCreateOrUpdate_564120(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "blobAuditingPolicyName" in path,
        "`blobAuditingPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/auditingSettings/"),
               (kind: VariableSegment, value: "blobAuditingPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServerBlobAuditingPoliciesCreateOrUpdate_564119(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a server's blob auditing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blobAuditingPolicyName: JString (required)
  ##                         : The name of the blob auditing policy.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blobAuditingPolicyName` field"
  var valid_564121 = path.getOrDefault("blobAuditingPolicyName")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = newJString("default"))
  if valid_564121 != nil:
    section.add "blobAuditingPolicyName", valid_564121
  var valid_564122 = path.getOrDefault("serverName")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "serverName", valid_564122
  var valid_564123 = path.getOrDefault("subscriptionId")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "subscriptionId", valid_564123
  var valid_564124 = path.getOrDefault("resourceGroupName")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "resourceGroupName", valid_564124
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564125 = query.getOrDefault("api-version")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "api-version", valid_564125
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Properties of blob auditing policy
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564127: Call_ServerBlobAuditingPoliciesCreateOrUpdate_564118;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a server's blob auditing policy.
  ## 
  let valid = call_564127.validator(path, query, header, formData, body)
  let scheme = call_564127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564127.url(scheme.get, call_564127.host, call_564127.base,
                         call_564127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564127, url, valid)

proc call*(call_564128: Call_ServerBlobAuditingPoliciesCreateOrUpdate_564118;
          apiVersion: string; serverName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode;
          blobAuditingPolicyName: string = "default"): Recallable =
  ## serverBlobAuditingPoliciesCreateOrUpdate
  ## Creates or updates a server's blob auditing policy.
  ##   blobAuditingPolicyName: string (required)
  ##                         : The name of the blob auditing policy.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   parameters: JObject (required)
  ##             : Properties of blob auditing policy
  var path_564129 = newJObject()
  var query_564130 = newJObject()
  var body_564131 = newJObject()
  add(path_564129, "blobAuditingPolicyName", newJString(blobAuditingPolicyName))
  add(query_564130, "api-version", newJString(apiVersion))
  add(path_564129, "serverName", newJString(serverName))
  add(path_564129, "subscriptionId", newJString(subscriptionId))
  add(path_564129, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564131 = parameters
  result = call_564128.call(path_564129, query_564130, nil, nil, body_564131)

var serverBlobAuditingPoliciesCreateOrUpdate* = Call_ServerBlobAuditingPoliciesCreateOrUpdate_564118(
    name: "serverBlobAuditingPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/auditingSettings/{blobAuditingPolicyName}",
    validator: validate_ServerBlobAuditingPoliciesCreateOrUpdate_564119, base: "",
    url: url_ServerBlobAuditingPoliciesCreateOrUpdate_564120,
    schemes: {Scheme.Https})
type
  Call_ServerBlobAuditingPoliciesGet_564093 = ref object of OpenApiRestCall_563555
proc url_ServerBlobAuditingPoliciesGet_564095(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "blobAuditingPolicyName" in path,
        "`blobAuditingPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/auditingSettings/"),
               (kind: VariableSegment, value: "blobAuditingPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServerBlobAuditingPoliciesGet_564094(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a server's blob auditing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blobAuditingPolicyName: JString (required)
  ##                         : The name of the blob auditing policy.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blobAuditingPolicyName` field"
  var valid_564109 = path.getOrDefault("blobAuditingPolicyName")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = newJString("default"))
  if valid_564109 != nil:
    section.add "blobAuditingPolicyName", valid_564109
  var valid_564110 = path.getOrDefault("serverName")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = nil)
  if valid_564110 != nil:
    section.add "serverName", valid_564110
  var valid_564111 = path.getOrDefault("subscriptionId")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "subscriptionId", valid_564111
  var valid_564112 = path.getOrDefault("resourceGroupName")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "resourceGroupName", valid_564112
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564113 = query.getOrDefault("api-version")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "api-version", valid_564113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564114: Call_ServerBlobAuditingPoliciesGet_564093; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a server's blob auditing policy.
  ## 
  let valid = call_564114.validator(path, query, header, formData, body)
  let scheme = call_564114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564114.url(scheme.get, call_564114.host, call_564114.base,
                         call_564114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564114, url, valid)

proc call*(call_564115: Call_ServerBlobAuditingPoliciesGet_564093;
          apiVersion: string; serverName: string; subscriptionId: string;
          resourceGroupName: string; blobAuditingPolicyName: string = "default"): Recallable =
  ## serverBlobAuditingPoliciesGet
  ## Gets a server's blob auditing policy.
  ##   blobAuditingPolicyName: string (required)
  ##                         : The name of the blob auditing policy.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564116 = newJObject()
  var query_564117 = newJObject()
  add(path_564116, "blobAuditingPolicyName", newJString(blobAuditingPolicyName))
  add(query_564117, "api-version", newJString(apiVersion))
  add(path_564116, "serverName", newJString(serverName))
  add(path_564116, "subscriptionId", newJString(subscriptionId))
  add(path_564116, "resourceGroupName", newJString(resourceGroupName))
  result = call_564115.call(path_564116, query_564117, nil, nil, nil)

var serverBlobAuditingPoliciesGet* = Call_ServerBlobAuditingPoliciesGet_564093(
    name: "serverBlobAuditingPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/auditingSettings/{blobAuditingPolicyName}",
    validator: validate_ServerBlobAuditingPoliciesGet_564094, base: "",
    url: url_ServerBlobAuditingPoliciesGet_564095, schemes: {Scheme.Https})
type
  Call_DatabaseBlobAuditingPoliciesListByDatabase_564132 = ref object of OpenApiRestCall_563555
proc url_DatabaseBlobAuditingPoliciesListByDatabase_564134(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/auditingSettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseBlobAuditingPoliciesListByDatabase_564133(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists auditing settings of a database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564135 = path.getOrDefault("serverName")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "serverName", valid_564135
  var valid_564136 = path.getOrDefault("subscriptionId")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "subscriptionId", valid_564136
  var valid_564137 = path.getOrDefault("databaseName")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "databaseName", valid_564137
  var valid_564138 = path.getOrDefault("resourceGroupName")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "resourceGroupName", valid_564138
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564139 = query.getOrDefault("api-version")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "api-version", valid_564139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564140: Call_DatabaseBlobAuditingPoliciesListByDatabase_564132;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists auditing settings of a database.
  ## 
  let valid = call_564140.validator(path, query, header, formData, body)
  let scheme = call_564140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564140.url(scheme.get, call_564140.host, call_564140.base,
                         call_564140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564140, url, valid)

proc call*(call_564141: Call_DatabaseBlobAuditingPoliciesListByDatabase_564132;
          apiVersion: string; serverName: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string): Recallable =
  ## databaseBlobAuditingPoliciesListByDatabase
  ## Lists auditing settings of a database.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564142 = newJObject()
  var query_564143 = newJObject()
  add(query_564143, "api-version", newJString(apiVersion))
  add(path_564142, "serverName", newJString(serverName))
  add(path_564142, "subscriptionId", newJString(subscriptionId))
  add(path_564142, "databaseName", newJString(databaseName))
  add(path_564142, "resourceGroupName", newJString(resourceGroupName))
  result = call_564141.call(path_564142, query_564143, nil, nil, nil)

var databaseBlobAuditingPoliciesListByDatabase* = Call_DatabaseBlobAuditingPoliciesListByDatabase_564132(
    name: "databaseBlobAuditingPoliciesListByDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/auditingSettings",
    validator: validate_DatabaseBlobAuditingPoliciesListByDatabase_564133,
    base: "", url: url_DatabaseBlobAuditingPoliciesListByDatabase_564134,
    schemes: {Scheme.Https})
type
  Call_DatabaseBlobAuditingPoliciesCreateOrUpdate_564157 = ref object of OpenApiRestCall_563555
proc url_DatabaseBlobAuditingPoliciesCreateOrUpdate_564159(protocol: Scheme;
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
  assert "blobAuditingPolicyName" in path,
        "`blobAuditingPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/auditingSettings/"),
               (kind: VariableSegment, value: "blobAuditingPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseBlobAuditingPoliciesCreateOrUpdate_564158(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a database's blob auditing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blobAuditingPolicyName: JString (required)
  ##                         : The name of the blob auditing policy.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blobAuditingPolicyName` field"
  var valid_564160 = path.getOrDefault("blobAuditingPolicyName")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = newJString("default"))
  if valid_564160 != nil:
    section.add "blobAuditingPolicyName", valid_564160
  var valid_564161 = path.getOrDefault("serverName")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "serverName", valid_564161
  var valid_564162 = path.getOrDefault("subscriptionId")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "subscriptionId", valid_564162
  var valid_564163 = path.getOrDefault("databaseName")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "databaseName", valid_564163
  var valid_564164 = path.getOrDefault("resourceGroupName")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "resourceGroupName", valid_564164
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564165 = query.getOrDefault("api-version")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "api-version", valid_564165
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The database blob auditing policy.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564167: Call_DatabaseBlobAuditingPoliciesCreateOrUpdate_564157;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a database's blob auditing policy.
  ## 
  let valid = call_564167.validator(path, query, header, formData, body)
  let scheme = call_564167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564167.url(scheme.get, call_564167.host, call_564167.base,
                         call_564167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564167, url, valid)

proc call*(call_564168: Call_DatabaseBlobAuditingPoliciesCreateOrUpdate_564157;
          apiVersion: string; serverName: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string; parameters: JsonNode;
          blobAuditingPolicyName: string = "default"): Recallable =
  ## databaseBlobAuditingPoliciesCreateOrUpdate
  ## Creates or updates a database's blob auditing policy.
  ##   blobAuditingPolicyName: string (required)
  ##                         : The name of the blob auditing policy.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   parameters: JObject (required)
  ##             : The database blob auditing policy.
  var path_564169 = newJObject()
  var query_564170 = newJObject()
  var body_564171 = newJObject()
  add(path_564169, "blobAuditingPolicyName", newJString(blobAuditingPolicyName))
  add(query_564170, "api-version", newJString(apiVersion))
  add(path_564169, "serverName", newJString(serverName))
  add(path_564169, "subscriptionId", newJString(subscriptionId))
  add(path_564169, "databaseName", newJString(databaseName))
  add(path_564169, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564171 = parameters
  result = call_564168.call(path_564169, query_564170, nil, nil, body_564171)

var databaseBlobAuditingPoliciesCreateOrUpdate* = Call_DatabaseBlobAuditingPoliciesCreateOrUpdate_564157(
    name: "databaseBlobAuditingPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/auditingSettings/{blobAuditingPolicyName}",
    validator: validate_DatabaseBlobAuditingPoliciesCreateOrUpdate_564158,
    base: "", url: url_DatabaseBlobAuditingPoliciesCreateOrUpdate_564159,
    schemes: {Scheme.Https})
type
  Call_DatabaseBlobAuditingPoliciesGet_564144 = ref object of OpenApiRestCall_563555
proc url_DatabaseBlobAuditingPoliciesGet_564146(protocol: Scheme; host: string;
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
  assert "blobAuditingPolicyName" in path,
        "`blobAuditingPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/auditingSettings/"),
               (kind: VariableSegment, value: "blobAuditingPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseBlobAuditingPoliciesGet_564145(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a database's blob auditing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blobAuditingPolicyName: JString (required)
  ##                         : The name of the blob auditing policy.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blobAuditingPolicyName` field"
  var valid_564147 = path.getOrDefault("blobAuditingPolicyName")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = newJString("default"))
  if valid_564147 != nil:
    section.add "blobAuditingPolicyName", valid_564147
  var valid_564148 = path.getOrDefault("serverName")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "serverName", valid_564148
  var valid_564149 = path.getOrDefault("subscriptionId")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "subscriptionId", valid_564149
  var valid_564150 = path.getOrDefault("databaseName")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "databaseName", valid_564150
  var valid_564151 = path.getOrDefault("resourceGroupName")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "resourceGroupName", valid_564151
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564152 = query.getOrDefault("api-version")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "api-version", valid_564152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564153: Call_DatabaseBlobAuditingPoliciesGet_564144;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a database's blob auditing policy.
  ## 
  let valid = call_564153.validator(path, query, header, formData, body)
  let scheme = call_564153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564153.url(scheme.get, call_564153.host, call_564153.base,
                         call_564153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564153, url, valid)

proc call*(call_564154: Call_DatabaseBlobAuditingPoliciesGet_564144;
          apiVersion: string; serverName: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string;
          blobAuditingPolicyName: string = "default"): Recallable =
  ## databaseBlobAuditingPoliciesGet
  ## Gets a database's blob auditing policy.
  ##   blobAuditingPolicyName: string (required)
  ##                         : The name of the blob auditing policy.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564155 = newJObject()
  var query_564156 = newJObject()
  add(path_564155, "blobAuditingPolicyName", newJString(blobAuditingPolicyName))
  add(query_564156, "api-version", newJString(apiVersion))
  add(path_564155, "serverName", newJString(serverName))
  add(path_564155, "subscriptionId", newJString(subscriptionId))
  add(path_564155, "databaseName", newJString(databaseName))
  add(path_564155, "resourceGroupName", newJString(resourceGroupName))
  result = call_564154.call(path_564155, query_564156, nil, nil, nil)

var databaseBlobAuditingPoliciesGet* = Call_DatabaseBlobAuditingPoliciesGet_564144(
    name: "databaseBlobAuditingPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/auditingSettings/{blobAuditingPolicyName}",
    validator: validate_DatabaseBlobAuditingPoliciesGet_564145, base: "",
    url: url_DatabaseBlobAuditingPoliciesGet_564146, schemes: {Scheme.Https})
type
  Call_ExtendedDatabaseBlobAuditingPoliciesCreateOrUpdate_564185 = ref object of OpenApiRestCall_563555
proc url_ExtendedDatabaseBlobAuditingPoliciesCreateOrUpdate_564187(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "blobAuditingPolicyName" in path,
        "`blobAuditingPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/extendedAuditingSettings/"),
               (kind: VariableSegment, value: "blobAuditingPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExtendedDatabaseBlobAuditingPoliciesCreateOrUpdate_564186(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates or updates an extended database's blob auditing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blobAuditingPolicyName: JString (required)
  ##                         : The name of the blob auditing policy.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blobAuditingPolicyName` field"
  var valid_564188 = path.getOrDefault("blobAuditingPolicyName")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = newJString("default"))
  if valid_564188 != nil:
    section.add "blobAuditingPolicyName", valid_564188
  var valid_564189 = path.getOrDefault("serverName")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "serverName", valid_564189
  var valid_564190 = path.getOrDefault("subscriptionId")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "subscriptionId", valid_564190
  var valid_564191 = path.getOrDefault("databaseName")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "databaseName", valid_564191
  var valid_564192 = path.getOrDefault("resourceGroupName")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "resourceGroupName", valid_564192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564193 = query.getOrDefault("api-version")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "api-version", valid_564193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The extended database blob auditing policy.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564195: Call_ExtendedDatabaseBlobAuditingPoliciesCreateOrUpdate_564185;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an extended database's blob auditing policy.
  ## 
  let valid = call_564195.validator(path, query, header, formData, body)
  let scheme = call_564195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564195.url(scheme.get, call_564195.host, call_564195.base,
                         call_564195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564195, url, valid)

proc call*(call_564196: Call_ExtendedDatabaseBlobAuditingPoliciesCreateOrUpdate_564185;
          apiVersion: string; serverName: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string; parameters: JsonNode;
          blobAuditingPolicyName: string = "default"): Recallable =
  ## extendedDatabaseBlobAuditingPoliciesCreateOrUpdate
  ## Creates or updates an extended database's blob auditing policy.
  ##   blobAuditingPolicyName: string (required)
  ##                         : The name of the blob auditing policy.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   parameters: JObject (required)
  ##             : The extended database blob auditing policy.
  var path_564197 = newJObject()
  var query_564198 = newJObject()
  var body_564199 = newJObject()
  add(path_564197, "blobAuditingPolicyName", newJString(blobAuditingPolicyName))
  add(query_564198, "api-version", newJString(apiVersion))
  add(path_564197, "serverName", newJString(serverName))
  add(path_564197, "subscriptionId", newJString(subscriptionId))
  add(path_564197, "databaseName", newJString(databaseName))
  add(path_564197, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564199 = parameters
  result = call_564196.call(path_564197, query_564198, nil, nil, body_564199)

var extendedDatabaseBlobAuditingPoliciesCreateOrUpdate* = Call_ExtendedDatabaseBlobAuditingPoliciesCreateOrUpdate_564185(
    name: "extendedDatabaseBlobAuditingPoliciesCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/extendedAuditingSettings/{blobAuditingPolicyName}",
    validator: validate_ExtendedDatabaseBlobAuditingPoliciesCreateOrUpdate_564186,
    base: "", url: url_ExtendedDatabaseBlobAuditingPoliciesCreateOrUpdate_564187,
    schemes: {Scheme.Https})
type
  Call_ExtendedDatabaseBlobAuditingPoliciesGet_564172 = ref object of OpenApiRestCall_563555
proc url_ExtendedDatabaseBlobAuditingPoliciesGet_564174(protocol: Scheme;
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
  assert "blobAuditingPolicyName" in path,
        "`blobAuditingPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/extendedAuditingSettings/"),
               (kind: VariableSegment, value: "blobAuditingPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExtendedDatabaseBlobAuditingPoliciesGet_564173(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an extended database's blob auditing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blobAuditingPolicyName: JString (required)
  ##                         : The name of the blob auditing policy.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blobAuditingPolicyName` field"
  var valid_564175 = path.getOrDefault("blobAuditingPolicyName")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = newJString("default"))
  if valid_564175 != nil:
    section.add "blobAuditingPolicyName", valid_564175
  var valid_564176 = path.getOrDefault("serverName")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "serverName", valid_564176
  var valid_564177 = path.getOrDefault("subscriptionId")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "subscriptionId", valid_564177
  var valid_564178 = path.getOrDefault("databaseName")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "databaseName", valid_564178
  var valid_564179 = path.getOrDefault("resourceGroupName")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "resourceGroupName", valid_564179
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564180 = query.getOrDefault("api-version")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "api-version", valid_564180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564181: Call_ExtendedDatabaseBlobAuditingPoliciesGet_564172;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an extended database's blob auditing policy.
  ## 
  let valid = call_564181.validator(path, query, header, formData, body)
  let scheme = call_564181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564181.url(scheme.get, call_564181.host, call_564181.base,
                         call_564181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564181, url, valid)

proc call*(call_564182: Call_ExtendedDatabaseBlobAuditingPoliciesGet_564172;
          apiVersion: string; serverName: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string;
          blobAuditingPolicyName: string = "default"): Recallable =
  ## extendedDatabaseBlobAuditingPoliciesGet
  ## Gets an extended database's blob auditing policy.
  ##   blobAuditingPolicyName: string (required)
  ##                         : The name of the blob auditing policy.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564183 = newJObject()
  var query_564184 = newJObject()
  add(path_564183, "blobAuditingPolicyName", newJString(blobAuditingPolicyName))
  add(query_564184, "api-version", newJString(apiVersion))
  add(path_564183, "serverName", newJString(serverName))
  add(path_564183, "subscriptionId", newJString(subscriptionId))
  add(path_564183, "databaseName", newJString(databaseName))
  add(path_564183, "resourceGroupName", newJString(resourceGroupName))
  result = call_564182.call(path_564183, query_564184, nil, nil, nil)

var extendedDatabaseBlobAuditingPoliciesGet* = Call_ExtendedDatabaseBlobAuditingPoliciesGet_564172(
    name: "extendedDatabaseBlobAuditingPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/extendedAuditingSettings/{blobAuditingPolicyName}",
    validator: validate_ExtendedDatabaseBlobAuditingPoliciesGet_564173, base: "",
    url: url_ExtendedDatabaseBlobAuditingPoliciesGet_564174,
    schemes: {Scheme.Https})
type
  Call_ExtendedServerBlobAuditingPoliciesCreateOrUpdate_564212 = ref object of OpenApiRestCall_563555
proc url_ExtendedServerBlobAuditingPoliciesCreateOrUpdate_564214(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "blobAuditingPolicyName" in path,
        "`blobAuditingPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/extendedAuditingSettings/"),
               (kind: VariableSegment, value: "blobAuditingPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExtendedServerBlobAuditingPoliciesCreateOrUpdate_564213(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates or updates an extended server's blob auditing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blobAuditingPolicyName: JString (required)
  ##                         : The name of the blob auditing policy.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blobAuditingPolicyName` field"
  var valid_564215 = path.getOrDefault("blobAuditingPolicyName")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = newJString("default"))
  if valid_564215 != nil:
    section.add "blobAuditingPolicyName", valid_564215
  var valid_564216 = path.getOrDefault("serverName")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "serverName", valid_564216
  var valid_564217 = path.getOrDefault("subscriptionId")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = nil)
  if valid_564217 != nil:
    section.add "subscriptionId", valid_564217
  var valid_564218 = path.getOrDefault("resourceGroupName")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "resourceGroupName", valid_564218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564219 = query.getOrDefault("api-version")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "api-version", valid_564219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Properties of extended blob auditing policy
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564221: Call_ExtendedServerBlobAuditingPoliciesCreateOrUpdate_564212;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an extended server's blob auditing policy.
  ## 
  let valid = call_564221.validator(path, query, header, formData, body)
  let scheme = call_564221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564221.url(scheme.get, call_564221.host, call_564221.base,
                         call_564221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564221, url, valid)

proc call*(call_564222: Call_ExtendedServerBlobAuditingPoliciesCreateOrUpdate_564212;
          apiVersion: string; serverName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode;
          blobAuditingPolicyName: string = "default"): Recallable =
  ## extendedServerBlobAuditingPoliciesCreateOrUpdate
  ## Creates or updates an extended server's blob auditing policy.
  ##   blobAuditingPolicyName: string (required)
  ##                         : The name of the blob auditing policy.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   parameters: JObject (required)
  ##             : Properties of extended blob auditing policy
  var path_564223 = newJObject()
  var query_564224 = newJObject()
  var body_564225 = newJObject()
  add(path_564223, "blobAuditingPolicyName", newJString(blobAuditingPolicyName))
  add(query_564224, "api-version", newJString(apiVersion))
  add(path_564223, "serverName", newJString(serverName))
  add(path_564223, "subscriptionId", newJString(subscriptionId))
  add(path_564223, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564225 = parameters
  result = call_564222.call(path_564223, query_564224, nil, nil, body_564225)

var extendedServerBlobAuditingPoliciesCreateOrUpdate* = Call_ExtendedServerBlobAuditingPoliciesCreateOrUpdate_564212(
    name: "extendedServerBlobAuditingPoliciesCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/extendedAuditingSettings/{blobAuditingPolicyName}",
    validator: validate_ExtendedServerBlobAuditingPoliciesCreateOrUpdate_564213,
    base: "", url: url_ExtendedServerBlobAuditingPoliciesCreateOrUpdate_564214,
    schemes: {Scheme.Https})
type
  Call_ExtendedServerBlobAuditingPoliciesGet_564200 = ref object of OpenApiRestCall_563555
proc url_ExtendedServerBlobAuditingPoliciesGet_564202(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "blobAuditingPolicyName" in path,
        "`blobAuditingPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/extendedAuditingSettings/"),
               (kind: VariableSegment, value: "blobAuditingPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExtendedServerBlobAuditingPoliciesGet_564201(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an extended server's blob auditing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blobAuditingPolicyName: JString (required)
  ##                         : The name of the blob auditing policy.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blobAuditingPolicyName` field"
  var valid_564203 = path.getOrDefault("blobAuditingPolicyName")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = newJString("default"))
  if valid_564203 != nil:
    section.add "blobAuditingPolicyName", valid_564203
  var valid_564204 = path.getOrDefault("serverName")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = nil)
  if valid_564204 != nil:
    section.add "serverName", valid_564204
  var valid_564205 = path.getOrDefault("subscriptionId")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "subscriptionId", valid_564205
  var valid_564206 = path.getOrDefault("resourceGroupName")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "resourceGroupName", valid_564206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564207 = query.getOrDefault("api-version")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "api-version", valid_564207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564208: Call_ExtendedServerBlobAuditingPoliciesGet_564200;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an extended server's blob auditing policy.
  ## 
  let valid = call_564208.validator(path, query, header, formData, body)
  let scheme = call_564208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564208.url(scheme.get, call_564208.host, call_564208.base,
                         call_564208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564208, url, valid)

proc call*(call_564209: Call_ExtendedServerBlobAuditingPoliciesGet_564200;
          apiVersion: string; serverName: string; subscriptionId: string;
          resourceGroupName: string; blobAuditingPolicyName: string = "default"): Recallable =
  ## extendedServerBlobAuditingPoliciesGet
  ## Gets an extended server's blob auditing policy.
  ##   blobAuditingPolicyName: string (required)
  ##                         : The name of the blob auditing policy.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564210 = newJObject()
  var query_564211 = newJObject()
  add(path_564210, "blobAuditingPolicyName", newJString(blobAuditingPolicyName))
  add(query_564211, "api-version", newJString(apiVersion))
  add(path_564210, "serverName", newJString(serverName))
  add(path_564210, "subscriptionId", newJString(subscriptionId))
  add(path_564210, "resourceGroupName", newJString(resourceGroupName))
  result = call_564209.call(path_564210, query_564211, nil, nil, nil)

var extendedServerBlobAuditingPoliciesGet* = Call_ExtendedServerBlobAuditingPoliciesGet_564200(
    name: "extendedServerBlobAuditingPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/extendedAuditingSettings/{blobAuditingPolicyName}",
    validator: validate_ExtendedServerBlobAuditingPoliciesGet_564201, base: "",
    url: url_ExtendedServerBlobAuditingPoliciesGet_564202, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
