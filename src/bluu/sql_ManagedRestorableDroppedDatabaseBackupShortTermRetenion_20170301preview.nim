
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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
  macServiceName = "sql-ManagedRestorableDroppedDatabaseBackupShortTermRetenion"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase_567879 = ref object of OpenApiRestCall_567657
proc url_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase_567881(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedInstanceName" in path,
        "`managedInstanceName` is a required path parameter"
  assert "restorableDroppedDatabaseId" in path,
        "`restorableDroppedDatabaseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/managedInstances/"),
               (kind: VariableSegment, value: "managedInstanceName"),
               (kind: ConstantSegment, value: "/restorableDroppedDatabases/"),
               (kind: VariableSegment, value: "restorableDroppedDatabaseId"), (
        kind: ConstantSegment, value: "/backupShortTermRetentionPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase_567880(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a dropped database's short term retention policy list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  ##   restorableDroppedDatabaseId: JString (required)
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568054 = path.getOrDefault("resourceGroupName")
  valid_568054 = validateParameter(valid_568054, JString, required = true,
                                 default = nil)
  if valid_568054 != nil:
    section.add "resourceGroupName", valid_568054
  var valid_568055 = path.getOrDefault("managedInstanceName")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "managedInstanceName", valid_568055
  var valid_568056 = path.getOrDefault("restorableDroppedDatabaseId")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "restorableDroppedDatabaseId", valid_568056
  var valid_568057 = path.getOrDefault("subscriptionId")
  valid_568057 = validateParameter(valid_568057, JString, required = true,
                                 default = nil)
  if valid_568057 != nil:
    section.add "subscriptionId", valid_568057
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568058 = query.getOrDefault("api-version")
  valid_568058 = validateParameter(valid_568058, JString, required = true,
                                 default = nil)
  if valid_568058 != nil:
    section.add "api-version", valid_568058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568081: Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase_567879;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a dropped database's short term retention policy list.
  ## 
  let valid = call_568081.validator(path, query, header, formData, body)
  let scheme = call_568081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568081.url(scheme.get, call_568081.host, call_568081.base,
                         call_568081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568081, url, valid)

proc call*(call_568152: Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase_567879;
          resourceGroupName: string; apiVersion: string;
          managedInstanceName: string; restorableDroppedDatabaseId: string;
          subscriptionId: string): Recallable =
  ## managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase
  ## Gets a dropped database's short term retention policy list.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  ##   restorableDroppedDatabaseId: string (required)
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568153 = newJObject()
  var query_568155 = newJObject()
  add(path_568153, "resourceGroupName", newJString(resourceGroupName))
  add(query_568155, "api-version", newJString(apiVersion))
  add(path_568153, "managedInstanceName", newJString(managedInstanceName))
  add(path_568153, "restorableDroppedDatabaseId",
      newJString(restorableDroppedDatabaseId))
  add(path_568153, "subscriptionId", newJString(subscriptionId))
  result = call_568152.call(path_568153, query_568155, nil, nil, nil)

var managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase* = Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase_567879(name: "managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/restorableDroppedDatabases/{restorableDroppedDatabaseId}/backupShortTermRetentionPolicies", validator: validate_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase_567880,
    base: "", url: url_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase_567881,
    schemes: {Scheme.Https})
type
  Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate_568220 = ref object of OpenApiRestCall_567657
proc url_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate_568222(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedInstanceName" in path,
        "`managedInstanceName` is a required path parameter"
  assert "restorableDroppedDatabaseId" in path,
        "`restorableDroppedDatabaseId` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/managedInstances/"),
               (kind: VariableSegment, value: "managedInstanceName"),
               (kind: ConstantSegment, value: "/restorableDroppedDatabases/"),
               (kind: VariableSegment, value: "restorableDroppedDatabaseId"), (
        kind: ConstantSegment, value: "/backupShortTermRetentionPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate_568221(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets a database's long term retention policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  ##   restorableDroppedDatabaseId: JString (required)
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   policyName: JString (required)
  ##             : The policy name. Should always be "default".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568223 = path.getOrDefault("resourceGroupName")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "resourceGroupName", valid_568223
  var valid_568224 = path.getOrDefault("managedInstanceName")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "managedInstanceName", valid_568224
  var valid_568225 = path.getOrDefault("restorableDroppedDatabaseId")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "restorableDroppedDatabaseId", valid_568225
  var valid_568226 = path.getOrDefault("subscriptionId")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "subscriptionId", valid_568226
  var valid_568227 = path.getOrDefault("policyName")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = newJString("default"))
  if valid_568227 != nil:
    section.add "policyName", valid_568227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568228 = query.getOrDefault("api-version")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "api-version", valid_568228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The long term retention policy info.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568230: Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate_568220;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets a database's long term retention policy.
  ## 
  let valid = call_568230.validator(path, query, header, formData, body)
  let scheme = call_568230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568230.url(scheme.get, call_568230.host, call_568230.base,
                         call_568230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568230, url, valid)

proc call*(call_568231: Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate_568220;
          resourceGroupName: string; apiVersion: string;
          managedInstanceName: string; restorableDroppedDatabaseId: string;
          subscriptionId: string; parameters: JsonNode;
          policyName: string = "default"): Recallable =
  ## managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate
  ## Sets a database's long term retention policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  ##   restorableDroppedDatabaseId: string (required)
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   policyName: string (required)
  ##             : The policy name. Should always be "default".
  ##   parameters: JObject (required)
  ##             : The long term retention policy info.
  var path_568232 = newJObject()
  var query_568233 = newJObject()
  var body_568234 = newJObject()
  add(path_568232, "resourceGroupName", newJString(resourceGroupName))
  add(query_568233, "api-version", newJString(apiVersion))
  add(path_568232, "managedInstanceName", newJString(managedInstanceName))
  add(path_568232, "restorableDroppedDatabaseId",
      newJString(restorableDroppedDatabaseId))
  add(path_568232, "subscriptionId", newJString(subscriptionId))
  add(path_568232, "policyName", newJString(policyName))
  if parameters != nil:
    body_568234 = parameters
  result = call_568231.call(path_568232, query_568233, nil, nil, body_568234)

var managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate* = Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate_568220(name: "managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/restorableDroppedDatabases/{restorableDroppedDatabaseId}/backupShortTermRetentionPolicies/{policyName}", validator: validate_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate_568221,
    base: "", url: url_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate_568222,
    schemes: {Scheme.Https})
type
  Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet_568194 = ref object of OpenApiRestCall_567657
proc url_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet_568196(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedInstanceName" in path,
        "`managedInstanceName` is a required path parameter"
  assert "restorableDroppedDatabaseId" in path,
        "`restorableDroppedDatabaseId` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/managedInstances/"),
               (kind: VariableSegment, value: "managedInstanceName"),
               (kind: ConstantSegment, value: "/restorableDroppedDatabases/"),
               (kind: VariableSegment, value: "restorableDroppedDatabaseId"), (
        kind: ConstantSegment, value: "/backupShortTermRetentionPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet_568195(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a dropped database's short term retention policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  ##   restorableDroppedDatabaseId: JString (required)
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   policyName: JString (required)
  ##             : The policy name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568197 = path.getOrDefault("resourceGroupName")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "resourceGroupName", valid_568197
  var valid_568198 = path.getOrDefault("managedInstanceName")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "managedInstanceName", valid_568198
  var valid_568199 = path.getOrDefault("restorableDroppedDatabaseId")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "restorableDroppedDatabaseId", valid_568199
  var valid_568200 = path.getOrDefault("subscriptionId")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "subscriptionId", valid_568200
  var valid_568214 = path.getOrDefault("policyName")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = newJString("default"))
  if valid_568214 != nil:
    section.add "policyName", valid_568214
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

proc call*(call_568216: Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet_568194;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a dropped database's short term retention policy.
  ## 
  let valid = call_568216.validator(path, query, header, formData, body)
  let scheme = call_568216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568216.url(scheme.get, call_568216.host, call_568216.base,
                         call_568216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568216, url, valid)

proc call*(call_568217: Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet_568194;
          resourceGroupName: string; apiVersion: string;
          managedInstanceName: string; restorableDroppedDatabaseId: string;
          subscriptionId: string; policyName: string = "default"): Recallable =
  ## managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet
  ## Gets a dropped database's short term retention policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  ##   restorableDroppedDatabaseId: string (required)
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   policyName: string (required)
  ##             : The policy name.
  var path_568218 = newJObject()
  var query_568219 = newJObject()
  add(path_568218, "resourceGroupName", newJString(resourceGroupName))
  add(query_568219, "api-version", newJString(apiVersion))
  add(path_568218, "managedInstanceName", newJString(managedInstanceName))
  add(path_568218, "restorableDroppedDatabaseId",
      newJString(restorableDroppedDatabaseId))
  add(path_568218, "subscriptionId", newJString(subscriptionId))
  add(path_568218, "policyName", newJString(policyName))
  result = call_568217.call(path_568218, query_568219, nil, nil, nil)

var managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet* = Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet_568194(name: "managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/restorableDroppedDatabases/{restorableDroppedDatabaseId}/backupShortTermRetentionPolicies/{policyName}", validator: validate_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet_568195,
    base: "", url: url_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet_568196,
    schemes: {Scheme.Https})
type
  Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate_568235 = ref object of OpenApiRestCall_567657
proc url_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate_568237(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedInstanceName" in path,
        "`managedInstanceName` is a required path parameter"
  assert "restorableDroppedDatabaseId" in path,
        "`restorableDroppedDatabaseId` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/managedInstances/"),
               (kind: VariableSegment, value: "managedInstanceName"),
               (kind: ConstantSegment, value: "/restorableDroppedDatabases/"),
               (kind: VariableSegment, value: "restorableDroppedDatabaseId"), (
        kind: ConstantSegment, value: "/backupShortTermRetentionPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate_568236(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets a database's long term retention policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  ##   restorableDroppedDatabaseId: JString (required)
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   policyName: JString (required)
  ##             : The policy name. Should always be "default".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568238 = path.getOrDefault("resourceGroupName")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "resourceGroupName", valid_568238
  var valid_568239 = path.getOrDefault("managedInstanceName")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "managedInstanceName", valid_568239
  var valid_568240 = path.getOrDefault("restorableDroppedDatabaseId")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "restorableDroppedDatabaseId", valid_568240
  var valid_568241 = path.getOrDefault("subscriptionId")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "subscriptionId", valid_568241
  var valid_568242 = path.getOrDefault("policyName")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = newJString("default"))
  if valid_568242 != nil:
    section.add "policyName", valid_568242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568243 = query.getOrDefault("api-version")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "api-version", valid_568243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The long term retention policy info.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568245: Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate_568235;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets a database's long term retention policy.
  ## 
  let valid = call_568245.validator(path, query, header, formData, body)
  let scheme = call_568245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568245.url(scheme.get, call_568245.host, call_568245.base,
                         call_568245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568245, url, valid)

proc call*(call_568246: Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate_568235;
          resourceGroupName: string; apiVersion: string;
          managedInstanceName: string; restorableDroppedDatabaseId: string;
          subscriptionId: string; parameters: JsonNode;
          policyName: string = "default"): Recallable =
  ## managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate
  ## Sets a database's long term retention policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  ##   restorableDroppedDatabaseId: string (required)
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   policyName: string (required)
  ##             : The policy name. Should always be "default".
  ##   parameters: JObject (required)
  ##             : The long term retention policy info.
  var path_568247 = newJObject()
  var query_568248 = newJObject()
  var body_568249 = newJObject()
  add(path_568247, "resourceGroupName", newJString(resourceGroupName))
  add(query_568248, "api-version", newJString(apiVersion))
  add(path_568247, "managedInstanceName", newJString(managedInstanceName))
  add(path_568247, "restorableDroppedDatabaseId",
      newJString(restorableDroppedDatabaseId))
  add(path_568247, "subscriptionId", newJString(subscriptionId))
  add(path_568247, "policyName", newJString(policyName))
  if parameters != nil:
    body_568249 = parameters
  result = call_568246.call(path_568247, query_568248, nil, nil, body_568249)

var managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate* = Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate_568235(name: "managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/restorableDroppedDatabases/{restorableDroppedDatabaseId}/backupShortTermRetentionPolicies/{policyName}", validator: validate_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate_568236,
    base: "", url: url_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate_568237,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
