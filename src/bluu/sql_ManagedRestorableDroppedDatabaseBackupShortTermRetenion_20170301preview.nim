
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
  macServiceName = "sql-ManagedRestorableDroppedDatabaseBackupShortTermRetenion"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase_563777 = ref object of OpenApiRestCall_563555
proc url_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase_563779(
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

proc validate_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase_563778(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a dropped database's short term retention policy list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   restorableDroppedDatabaseId: JString (required)
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `restorableDroppedDatabaseId` field"
  var valid_563954 = path.getOrDefault("restorableDroppedDatabaseId")
  valid_563954 = validateParameter(valid_563954, JString, required = true,
                                 default = nil)
  if valid_563954 != nil:
    section.add "restorableDroppedDatabaseId", valid_563954
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
  var valid_563957 = path.getOrDefault("managedInstanceName")
  valid_563957 = validateParameter(valid_563957, JString, required = true,
                                 default = nil)
  if valid_563957 != nil:
    section.add "managedInstanceName", valid_563957
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563958 = query.getOrDefault("api-version")
  valid_563958 = validateParameter(valid_563958, JString, required = true,
                                 default = nil)
  if valid_563958 != nil:
    section.add "api-version", valid_563958
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563981: Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase_563777;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a dropped database's short term retention policy list.
  ## 
  let valid = call_563981.validator(path, query, header, formData, body)
  let scheme = call_563981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563981.url(scheme.get, call_563981.host, call_563981.base,
                         call_563981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563981, url, valid)

proc call*(call_564052: Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase_563777;
          apiVersion: string; restorableDroppedDatabaseId: string;
          subscriptionId: string; resourceGroupName: string;
          managedInstanceName: string): Recallable =
  ## managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase
  ## Gets a dropped database's short term retention policy list.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   restorableDroppedDatabaseId: string (required)
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  var path_564053 = newJObject()
  var query_564055 = newJObject()
  add(query_564055, "api-version", newJString(apiVersion))
  add(path_564053, "restorableDroppedDatabaseId",
      newJString(restorableDroppedDatabaseId))
  add(path_564053, "subscriptionId", newJString(subscriptionId))
  add(path_564053, "resourceGroupName", newJString(resourceGroupName))
  add(path_564053, "managedInstanceName", newJString(managedInstanceName))
  result = call_564052.call(path_564053, query_564055, nil, nil, nil)

var managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase* = Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase_563777(name: "managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/restorableDroppedDatabases/{restorableDroppedDatabaseId}/backupShortTermRetentionPolicies", validator: validate_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase_563778,
    base: "", url: url_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase_563779,
    schemes: {Scheme.Https})
type
  Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate_564120 = ref object of OpenApiRestCall_563555
proc url_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate_564122(
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

proc validate_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate_564121(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets a database's long term retention policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : The policy name. Should always be "default".
  ##   restorableDroppedDatabaseId: JString (required)
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564123 = path.getOrDefault("policyName")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = newJString("default"))
  if valid_564123 != nil:
    section.add "policyName", valid_564123
  var valid_564124 = path.getOrDefault("restorableDroppedDatabaseId")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "restorableDroppedDatabaseId", valid_564124
  var valid_564125 = path.getOrDefault("subscriptionId")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "subscriptionId", valid_564125
  var valid_564126 = path.getOrDefault("resourceGroupName")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "resourceGroupName", valid_564126
  var valid_564127 = path.getOrDefault("managedInstanceName")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "managedInstanceName", valid_564127
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564128 = query.getOrDefault("api-version")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "api-version", valid_564128
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

proc call*(call_564130: Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate_564120;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets a database's long term retention policy.
  ## 
  let valid = call_564130.validator(path, query, header, formData, body)
  let scheme = call_564130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564130.url(scheme.get, call_564130.host, call_564130.base,
                         call_564130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564130, url, valid)

proc call*(call_564131: Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate_564120;
          apiVersion: string; restorableDroppedDatabaseId: string;
          subscriptionId: string; resourceGroupName: string;
          managedInstanceName: string; parameters: JsonNode;
          policyName: string = "default"): Recallable =
  ## managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate
  ## Sets a database's long term retention policy.
  ##   policyName: string (required)
  ##             : The policy name. Should always be "default".
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   restorableDroppedDatabaseId: string (required)
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  ##   parameters: JObject (required)
  ##             : The long term retention policy info.
  var path_564132 = newJObject()
  var query_564133 = newJObject()
  var body_564134 = newJObject()
  add(path_564132, "policyName", newJString(policyName))
  add(query_564133, "api-version", newJString(apiVersion))
  add(path_564132, "restorableDroppedDatabaseId",
      newJString(restorableDroppedDatabaseId))
  add(path_564132, "subscriptionId", newJString(subscriptionId))
  add(path_564132, "resourceGroupName", newJString(resourceGroupName))
  add(path_564132, "managedInstanceName", newJString(managedInstanceName))
  if parameters != nil:
    body_564134 = parameters
  result = call_564131.call(path_564132, query_564133, nil, nil, body_564134)

var managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate* = Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate_564120(name: "managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/restorableDroppedDatabases/{restorableDroppedDatabaseId}/backupShortTermRetentionPolicies/{policyName}", validator: validate_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate_564121,
    base: "", url: url_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate_564122,
    schemes: {Scheme.Https})
type
  Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet_564094 = ref object of OpenApiRestCall_563555
proc url_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet_564096(
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

proc validate_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet_564095(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a dropped database's short term retention policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : The policy name.
  ##   restorableDroppedDatabaseId: JString (required)
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564110 = path.getOrDefault("policyName")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = newJString("default"))
  if valid_564110 != nil:
    section.add "policyName", valid_564110
  var valid_564111 = path.getOrDefault("restorableDroppedDatabaseId")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "restorableDroppedDatabaseId", valid_564111
  var valid_564112 = path.getOrDefault("subscriptionId")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "subscriptionId", valid_564112
  var valid_564113 = path.getOrDefault("resourceGroupName")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "resourceGroupName", valid_564113
  var valid_564114 = path.getOrDefault("managedInstanceName")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "managedInstanceName", valid_564114
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564115 = query.getOrDefault("api-version")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "api-version", valid_564115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564116: Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet_564094;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a dropped database's short term retention policy.
  ## 
  let valid = call_564116.validator(path, query, header, formData, body)
  let scheme = call_564116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564116.url(scheme.get, call_564116.host, call_564116.base,
                         call_564116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564116, url, valid)

proc call*(call_564117: Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet_564094;
          apiVersion: string; restorableDroppedDatabaseId: string;
          subscriptionId: string; resourceGroupName: string;
          managedInstanceName: string; policyName: string = "default"): Recallable =
  ## managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet
  ## Gets a dropped database's short term retention policy.
  ##   policyName: string (required)
  ##             : The policy name.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   restorableDroppedDatabaseId: string (required)
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  var path_564118 = newJObject()
  var query_564119 = newJObject()
  add(path_564118, "policyName", newJString(policyName))
  add(query_564119, "api-version", newJString(apiVersion))
  add(path_564118, "restorableDroppedDatabaseId",
      newJString(restorableDroppedDatabaseId))
  add(path_564118, "subscriptionId", newJString(subscriptionId))
  add(path_564118, "resourceGroupName", newJString(resourceGroupName))
  add(path_564118, "managedInstanceName", newJString(managedInstanceName))
  result = call_564117.call(path_564118, query_564119, nil, nil, nil)

var managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet* = Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet_564094(name: "managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/restorableDroppedDatabases/{restorableDroppedDatabaseId}/backupShortTermRetentionPolicies/{policyName}", validator: validate_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet_564095,
    base: "", url: url_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet_564096,
    schemes: {Scheme.Https})
type
  Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate_564135 = ref object of OpenApiRestCall_563555
proc url_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate_564137(
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

proc validate_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate_564136(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets a database's long term retention policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : The policy name. Should always be "default".
  ##   restorableDroppedDatabaseId: JString (required)
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564138 = path.getOrDefault("policyName")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = newJString("default"))
  if valid_564138 != nil:
    section.add "policyName", valid_564138
  var valid_564139 = path.getOrDefault("restorableDroppedDatabaseId")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "restorableDroppedDatabaseId", valid_564139
  var valid_564140 = path.getOrDefault("subscriptionId")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "subscriptionId", valid_564140
  var valid_564141 = path.getOrDefault("resourceGroupName")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "resourceGroupName", valid_564141
  var valid_564142 = path.getOrDefault("managedInstanceName")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "managedInstanceName", valid_564142
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564143 = query.getOrDefault("api-version")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "api-version", valid_564143
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

proc call*(call_564145: Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate_564135;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets a database's long term retention policy.
  ## 
  let valid = call_564145.validator(path, query, header, formData, body)
  let scheme = call_564145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564145.url(scheme.get, call_564145.host, call_564145.base,
                         call_564145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564145, url, valid)

proc call*(call_564146: Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate_564135;
          apiVersion: string; restorableDroppedDatabaseId: string;
          subscriptionId: string; resourceGroupName: string;
          managedInstanceName: string; parameters: JsonNode;
          policyName: string = "default"): Recallable =
  ## managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate
  ## Sets a database's long term retention policy.
  ##   policyName: string (required)
  ##             : The policy name. Should always be "default".
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   restorableDroppedDatabaseId: string (required)
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  ##   parameters: JObject (required)
  ##             : The long term retention policy info.
  var path_564147 = newJObject()
  var query_564148 = newJObject()
  var body_564149 = newJObject()
  add(path_564147, "policyName", newJString(policyName))
  add(query_564148, "api-version", newJString(apiVersion))
  add(path_564147, "restorableDroppedDatabaseId",
      newJString(restorableDroppedDatabaseId))
  add(path_564147, "subscriptionId", newJString(subscriptionId))
  add(path_564147, "resourceGroupName", newJString(resourceGroupName))
  add(path_564147, "managedInstanceName", newJString(managedInstanceName))
  if parameters != nil:
    body_564149 = parameters
  result = call_564146.call(path_564147, query_564148, nil, nil, body_564149)

var managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate* = Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate_564135(name: "managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/restorableDroppedDatabases/{restorableDroppedDatabaseId}/backupShortTermRetentionPolicies/{policyName}", validator: validate_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate_564136,
    base: "", url: url_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate_564137,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
