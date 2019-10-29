
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Azure SQL Database Backup Long Term Retention Policy
## version: 2014-04-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Provides read and update functionality for Azure SQL Database backup long term retention policy
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

  OpenApiRestCall_563540 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563540](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563540): Option[Scheme] {.used.} =
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
  macServiceName = "sql-backupLongTermRetentionPolicies"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BackupLongTermRetentionPoliciesListByDatabase_563762 = ref object of OpenApiRestCall_563540
proc url_BackupLongTermRetentionPoliciesListByDatabase_563764(protocol: Scheme;
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
               (kind: VariableSegment, value: "databaseName"), (
        kind: ConstantSegment, value: "/backupLongTermRetentionPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupLongTermRetentionPoliciesListByDatabase_563763(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns a database backup long term retention policy
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
  var valid_563939 = path.getOrDefault("serverName")
  valid_563939 = validateParameter(valid_563939, JString, required = true,
                                 default = nil)
  if valid_563939 != nil:
    section.add "serverName", valid_563939
  var valid_563940 = path.getOrDefault("subscriptionId")
  valid_563940 = validateParameter(valid_563940, JString, required = true,
                                 default = nil)
  if valid_563940 != nil:
    section.add "subscriptionId", valid_563940
  var valid_563941 = path.getOrDefault("databaseName")
  valid_563941 = validateParameter(valid_563941, JString, required = true,
                                 default = nil)
  if valid_563941 != nil:
    section.add "databaseName", valid_563941
  var valid_563942 = path.getOrDefault("resourceGroupName")
  valid_563942 = validateParameter(valid_563942, JString, required = true,
                                 default = nil)
  if valid_563942 != nil:
    section.add "resourceGroupName", valid_563942
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563943 = query.getOrDefault("api-version")
  valid_563943 = validateParameter(valid_563943, JString, required = true,
                                 default = nil)
  if valid_563943 != nil:
    section.add "api-version", valid_563943
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563966: Call_BackupLongTermRetentionPoliciesListByDatabase_563762;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a database backup long term retention policy
  ## 
  let valid = call_563966.validator(path, query, header, formData, body)
  let scheme = call_563966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563966.url(scheme.get, call_563966.host, call_563966.base,
                         call_563966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563966, url, valid)

proc call*(call_564037: Call_BackupLongTermRetentionPoliciesListByDatabase_563762;
          apiVersion: string; serverName: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string): Recallable =
  ## backupLongTermRetentionPoliciesListByDatabase
  ## Returns a database backup long term retention policy
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
  var path_564038 = newJObject()
  var query_564040 = newJObject()
  add(query_564040, "api-version", newJString(apiVersion))
  add(path_564038, "serverName", newJString(serverName))
  add(path_564038, "subscriptionId", newJString(subscriptionId))
  add(path_564038, "databaseName", newJString(databaseName))
  add(path_564038, "resourceGroupName", newJString(resourceGroupName))
  result = call_564037.call(path_564038, query_564040, nil, nil, nil)

var backupLongTermRetentionPoliciesListByDatabase* = Call_BackupLongTermRetentionPoliciesListByDatabase_563762(
    name: "backupLongTermRetentionPoliciesListByDatabase",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/backupLongTermRetentionPolicies",
    validator: validate_BackupLongTermRetentionPoliciesListByDatabase_563763,
    base: "", url: url_BackupLongTermRetentionPoliciesListByDatabase_563764,
    schemes: {Scheme.Https})
type
  Call_BackupLongTermRetentionPoliciesCreateOrUpdate_564105 = ref object of OpenApiRestCall_563540
proc url_BackupLongTermRetentionPoliciesCreateOrUpdate_564107(protocol: Scheme;
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
  assert "backupLongTermRetentionPolicyName" in path,
        "`backupLongTermRetentionPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"), (
        kind: ConstantSegment, value: "/backupLongTermRetentionPolicies/"), (
        kind: VariableSegment, value: "backupLongTermRetentionPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupLongTermRetentionPoliciesCreateOrUpdate_564106(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates or updates a database backup long term retention policy
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   backupLongTermRetentionPolicyName: JString (required)
  ##                                    : The name of the backup long term retention policy
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564125 = path.getOrDefault("serverName")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "serverName", valid_564125
  var valid_564126 = path.getOrDefault("backupLongTermRetentionPolicyName")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = newJString("Default"))
  if valid_564126 != nil:
    section.add "backupLongTermRetentionPolicyName", valid_564126
  var valid_564127 = path.getOrDefault("subscriptionId")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "subscriptionId", valid_564127
  var valid_564128 = path.getOrDefault("databaseName")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "databaseName", valid_564128
  var valid_564129 = path.getOrDefault("resourceGroupName")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "resourceGroupName", valid_564129
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564130 = query.getOrDefault("api-version")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "api-version", valid_564130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The required parameters to update a backup long term retention policy
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564132: Call_BackupLongTermRetentionPoliciesCreateOrUpdate_564105;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a database backup long term retention policy
  ## 
  let valid = call_564132.validator(path, query, header, formData, body)
  let scheme = call_564132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564132.url(scheme.get, call_564132.host, call_564132.base,
                         call_564132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564132, url, valid)

proc call*(call_564133: Call_BackupLongTermRetentionPoliciesCreateOrUpdate_564105;
          apiVersion: string; serverName: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string; parameters: JsonNode;
          backupLongTermRetentionPolicyName: string = "Default"): Recallable =
  ## backupLongTermRetentionPoliciesCreateOrUpdate
  ## Creates or updates a database backup long term retention policy
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   backupLongTermRetentionPolicyName: string (required)
  ##                                    : The name of the backup long term retention policy
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   parameters: JObject (required)
  ##             : The required parameters to update a backup long term retention policy
  var path_564134 = newJObject()
  var query_564135 = newJObject()
  var body_564136 = newJObject()
  add(query_564135, "api-version", newJString(apiVersion))
  add(path_564134, "serverName", newJString(serverName))
  add(path_564134, "backupLongTermRetentionPolicyName",
      newJString(backupLongTermRetentionPolicyName))
  add(path_564134, "subscriptionId", newJString(subscriptionId))
  add(path_564134, "databaseName", newJString(databaseName))
  add(path_564134, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564136 = parameters
  result = call_564133.call(path_564134, query_564135, nil, nil, body_564136)

var backupLongTermRetentionPoliciesCreateOrUpdate* = Call_BackupLongTermRetentionPoliciesCreateOrUpdate_564105(
    name: "backupLongTermRetentionPoliciesCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/backupLongTermRetentionPolicies/{backupLongTermRetentionPolicyName}",
    validator: validate_BackupLongTermRetentionPoliciesCreateOrUpdate_564106,
    base: "", url: url_BackupLongTermRetentionPoliciesCreateOrUpdate_564107,
    schemes: {Scheme.Https})
type
  Call_BackupLongTermRetentionPoliciesGet_564079 = ref object of OpenApiRestCall_563540
proc url_BackupLongTermRetentionPoliciesGet_564081(protocol: Scheme; host: string;
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
  assert "backupLongTermRetentionPolicyName" in path,
        "`backupLongTermRetentionPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"), (
        kind: ConstantSegment, value: "/backupLongTermRetentionPolicies/"), (
        kind: VariableSegment, value: "backupLongTermRetentionPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupLongTermRetentionPoliciesGet_564080(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a database backup long term retention policy
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   backupLongTermRetentionPolicyName: JString (required)
  ##                                    : The name of the backup long term retention policy
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564082 = path.getOrDefault("serverName")
  valid_564082 = validateParameter(valid_564082, JString, required = true,
                                 default = nil)
  if valid_564082 != nil:
    section.add "serverName", valid_564082
  var valid_564096 = path.getOrDefault("backupLongTermRetentionPolicyName")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = newJString("Default"))
  if valid_564096 != nil:
    section.add "backupLongTermRetentionPolicyName", valid_564096
  var valid_564097 = path.getOrDefault("subscriptionId")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "subscriptionId", valid_564097
  var valid_564098 = path.getOrDefault("databaseName")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "databaseName", valid_564098
  var valid_564099 = path.getOrDefault("resourceGroupName")
  valid_564099 = validateParameter(valid_564099, JString, required = true,
                                 default = nil)
  if valid_564099 != nil:
    section.add "resourceGroupName", valid_564099
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564100 = query.getOrDefault("api-version")
  valid_564100 = validateParameter(valid_564100, JString, required = true,
                                 default = nil)
  if valid_564100 != nil:
    section.add "api-version", valid_564100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564101: Call_BackupLongTermRetentionPoliciesGet_564079;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a database backup long term retention policy
  ## 
  let valid = call_564101.validator(path, query, header, formData, body)
  let scheme = call_564101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564101.url(scheme.get, call_564101.host, call_564101.base,
                         call_564101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564101, url, valid)

proc call*(call_564102: Call_BackupLongTermRetentionPoliciesGet_564079;
          apiVersion: string; serverName: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string;
          backupLongTermRetentionPolicyName: string = "Default"): Recallable =
  ## backupLongTermRetentionPoliciesGet
  ## Returns a database backup long term retention policy
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   backupLongTermRetentionPolicyName: string (required)
  ##                                    : The name of the backup long term retention policy
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564103 = newJObject()
  var query_564104 = newJObject()
  add(query_564104, "api-version", newJString(apiVersion))
  add(path_564103, "serverName", newJString(serverName))
  add(path_564103, "backupLongTermRetentionPolicyName",
      newJString(backupLongTermRetentionPolicyName))
  add(path_564103, "subscriptionId", newJString(subscriptionId))
  add(path_564103, "databaseName", newJString(databaseName))
  add(path_564103, "resourceGroupName", newJString(resourceGroupName))
  result = call_564102.call(path_564103, query_564104, nil, nil, nil)

var backupLongTermRetentionPoliciesGet* = Call_BackupLongTermRetentionPoliciesGet_564079(
    name: "backupLongTermRetentionPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/backupLongTermRetentionPolicies/{backupLongTermRetentionPolicyName}",
    validator: validate_BackupLongTermRetentionPoliciesGet_564080, base: "",
    url: url_BackupLongTermRetentionPoliciesGet_564081, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
