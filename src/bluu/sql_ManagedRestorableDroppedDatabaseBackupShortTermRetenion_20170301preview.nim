
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase_593646 = ref object of OpenApiRestCall_593424
proc url_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase_593648(
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

proc validate_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase_593647(
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
  var valid_593821 = path.getOrDefault("resourceGroupName")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = nil)
  if valid_593821 != nil:
    section.add "resourceGroupName", valid_593821
  var valid_593822 = path.getOrDefault("managedInstanceName")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "managedInstanceName", valid_593822
  var valid_593823 = path.getOrDefault("restorableDroppedDatabaseId")
  valid_593823 = validateParameter(valid_593823, JString, required = true,
                                 default = nil)
  if valid_593823 != nil:
    section.add "restorableDroppedDatabaseId", valid_593823
  var valid_593824 = path.getOrDefault("subscriptionId")
  valid_593824 = validateParameter(valid_593824, JString, required = true,
                                 default = nil)
  if valid_593824 != nil:
    section.add "subscriptionId", valid_593824
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593825 = query.getOrDefault("api-version")
  valid_593825 = validateParameter(valid_593825, JString, required = true,
                                 default = nil)
  if valid_593825 != nil:
    section.add "api-version", valid_593825
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593848: Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase_593646;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a dropped database's short term retention policy list.
  ## 
  let valid = call_593848.validator(path, query, header, formData, body)
  let scheme = call_593848.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593848.url(scheme.get, call_593848.host, call_593848.base,
                         call_593848.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593848, url, valid)

proc call*(call_593919: Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase_593646;
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
  var path_593920 = newJObject()
  var query_593922 = newJObject()
  add(path_593920, "resourceGroupName", newJString(resourceGroupName))
  add(query_593922, "api-version", newJString(apiVersion))
  add(path_593920, "managedInstanceName", newJString(managedInstanceName))
  add(path_593920, "restorableDroppedDatabaseId",
      newJString(restorableDroppedDatabaseId))
  add(path_593920, "subscriptionId", newJString(subscriptionId))
  result = call_593919.call(path_593920, query_593922, nil, nil, nil)

var managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase* = Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase_593646(name: "managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/restorableDroppedDatabases/{restorableDroppedDatabaseId}/backupShortTermRetentionPolicies", validator: validate_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase_593647,
    base: "", url: url_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesListByRestorableDroppedDatabase_593648,
    schemes: {Scheme.Https})
type
  Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate_593987 = ref object of OpenApiRestCall_593424
proc url_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate_593989(
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

proc validate_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate_593988(
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
  var valid_593990 = path.getOrDefault("resourceGroupName")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "resourceGroupName", valid_593990
  var valid_593991 = path.getOrDefault("managedInstanceName")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "managedInstanceName", valid_593991
  var valid_593992 = path.getOrDefault("restorableDroppedDatabaseId")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "restorableDroppedDatabaseId", valid_593992
  var valid_593993 = path.getOrDefault("subscriptionId")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "subscriptionId", valid_593993
  var valid_593994 = path.getOrDefault("policyName")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = newJString("default"))
  if valid_593994 != nil:
    section.add "policyName", valid_593994
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593995 = query.getOrDefault("api-version")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "api-version", valid_593995
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

proc call*(call_593997: Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate_593987;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets a database's long term retention policy.
  ## 
  let valid = call_593997.validator(path, query, header, formData, body)
  let scheme = call_593997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593997.url(scheme.get, call_593997.host, call_593997.base,
                         call_593997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593997, url, valid)

proc call*(call_593998: Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate_593987;
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
  var path_593999 = newJObject()
  var query_594000 = newJObject()
  var body_594001 = newJObject()
  add(path_593999, "resourceGroupName", newJString(resourceGroupName))
  add(query_594000, "api-version", newJString(apiVersion))
  add(path_593999, "managedInstanceName", newJString(managedInstanceName))
  add(path_593999, "restorableDroppedDatabaseId",
      newJString(restorableDroppedDatabaseId))
  add(path_593999, "subscriptionId", newJString(subscriptionId))
  add(path_593999, "policyName", newJString(policyName))
  if parameters != nil:
    body_594001 = parameters
  result = call_593998.call(path_593999, query_594000, nil, nil, body_594001)

var managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate* = Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate_593987(name: "managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/restorableDroppedDatabases/{restorableDroppedDatabaseId}/backupShortTermRetentionPolicies/{policyName}", validator: validate_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate_593988,
    base: "", url: url_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesCreateOrUpdate_593989,
    schemes: {Scheme.Https})
type
  Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet_593961 = ref object of OpenApiRestCall_593424
proc url_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet_593963(
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

proc validate_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet_593962(
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
  var valid_593964 = path.getOrDefault("resourceGroupName")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "resourceGroupName", valid_593964
  var valid_593965 = path.getOrDefault("managedInstanceName")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "managedInstanceName", valid_593965
  var valid_593966 = path.getOrDefault("restorableDroppedDatabaseId")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "restorableDroppedDatabaseId", valid_593966
  var valid_593967 = path.getOrDefault("subscriptionId")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "subscriptionId", valid_593967
  var valid_593981 = path.getOrDefault("policyName")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = newJString("default"))
  if valid_593981 != nil:
    section.add "policyName", valid_593981
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593982 = query.getOrDefault("api-version")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "api-version", valid_593982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593983: Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet_593961;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a dropped database's short term retention policy.
  ## 
  let valid = call_593983.validator(path, query, header, formData, body)
  let scheme = call_593983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593983.url(scheme.get, call_593983.host, call_593983.base,
                         call_593983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593983, url, valid)

proc call*(call_593984: Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet_593961;
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
  var path_593985 = newJObject()
  var query_593986 = newJObject()
  add(path_593985, "resourceGroupName", newJString(resourceGroupName))
  add(query_593986, "api-version", newJString(apiVersion))
  add(path_593985, "managedInstanceName", newJString(managedInstanceName))
  add(path_593985, "restorableDroppedDatabaseId",
      newJString(restorableDroppedDatabaseId))
  add(path_593985, "subscriptionId", newJString(subscriptionId))
  add(path_593985, "policyName", newJString(policyName))
  result = call_593984.call(path_593985, query_593986, nil, nil, nil)

var managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet* = Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet_593961(name: "managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/restorableDroppedDatabases/{restorableDroppedDatabaseId}/backupShortTermRetentionPolicies/{policyName}", validator: validate_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet_593962,
    base: "", url: url_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesGet_593963,
    schemes: {Scheme.Https})
type
  Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate_594002 = ref object of OpenApiRestCall_593424
proc url_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate_594004(
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

proc validate_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate_594003(
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
  var valid_594005 = path.getOrDefault("resourceGroupName")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "resourceGroupName", valid_594005
  var valid_594006 = path.getOrDefault("managedInstanceName")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "managedInstanceName", valid_594006
  var valid_594007 = path.getOrDefault("restorableDroppedDatabaseId")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "restorableDroppedDatabaseId", valid_594007
  var valid_594008 = path.getOrDefault("subscriptionId")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "subscriptionId", valid_594008
  var valid_594009 = path.getOrDefault("policyName")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = newJString("default"))
  if valid_594009 != nil:
    section.add "policyName", valid_594009
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594010 = query.getOrDefault("api-version")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "api-version", valid_594010
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

proc call*(call_594012: Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate_594002;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets a database's long term retention policy.
  ## 
  let valid = call_594012.validator(path, query, header, formData, body)
  let scheme = call_594012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594012.url(scheme.get, call_594012.host, call_594012.base,
                         call_594012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594012, url, valid)

proc call*(call_594013: Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate_594002;
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
  var path_594014 = newJObject()
  var query_594015 = newJObject()
  var body_594016 = newJObject()
  add(path_594014, "resourceGroupName", newJString(resourceGroupName))
  add(query_594015, "api-version", newJString(apiVersion))
  add(path_594014, "managedInstanceName", newJString(managedInstanceName))
  add(path_594014, "restorableDroppedDatabaseId",
      newJString(restorableDroppedDatabaseId))
  add(path_594014, "subscriptionId", newJString(subscriptionId))
  add(path_594014, "policyName", newJString(policyName))
  if parameters != nil:
    body_594016 = parameters
  result = call_594013.call(path_594014, query_594015, nil, nil, body_594016)

var managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate* = Call_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate_594002(name: "managedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/restorableDroppedDatabases/{restorableDroppedDatabaseId}/backupShortTermRetentionPolicies/{policyName}", validator: validate_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate_594003,
    base: "", url: url_ManagedRestorableDroppedDatabaseBackupShortTermRetentionPoliciesUpdate_594004,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
