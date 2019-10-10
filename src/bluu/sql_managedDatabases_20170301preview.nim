
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
  macServiceName = "sql-managedDatabases"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ManagedDatabasesCompleteRestore_573863 = ref object of OpenApiRestCall_573641
proc url_ManagedDatabasesCompleteRestore_573865(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/locations/"),
               (kind: VariableSegment, value: "locationName"), (
        kind: ConstantSegment,
        value: "/managedDatabaseRestoreAzureAsyncOperation/"),
               (kind: VariableSegment, value: "operationId"),
               (kind: ConstantSegment, value: "/completeRestore")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedDatabasesCompleteRestore_573864(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Completes the restore operation on a managed database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   locationName: JString (required)
  ##               : The name of the region where the resource is located.
  ##   operationId: JString (required)
  ##              : Management operation id that this request tries to complete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574038 = path.getOrDefault("subscriptionId")
  valid_574038 = validateParameter(valid_574038, JString, required = true,
                                 default = nil)
  if valid_574038 != nil:
    section.add "subscriptionId", valid_574038
  var valid_574039 = path.getOrDefault("locationName")
  valid_574039 = validateParameter(valid_574039, JString, required = true,
                                 default = nil)
  if valid_574039 != nil:
    section.add "locationName", valid_574039
  var valid_574040 = path.getOrDefault("operationId")
  valid_574040 = validateParameter(valid_574040, JString, required = true,
                                 default = nil)
  if valid_574040 != nil:
    section.add "operationId", valid_574040
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The definition for completing the restore of this managed database.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574065: Call_ManagedDatabasesCompleteRestore_573863;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Completes the restore operation on a managed database.
  ## 
  let valid = call_574065.validator(path, query, header, formData, body)
  let scheme = call_574065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574065.url(scheme.get, call_574065.host, call_574065.base,
                         call_574065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574065, url, valid)

proc call*(call_574136: Call_ManagedDatabasesCompleteRestore_573863;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          locationName: string; operationId: string): Recallable =
  ## managedDatabasesCompleteRestore
  ## Completes the restore operation on a managed database.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   parameters: JObject (required)
  ##             : The definition for completing the restore of this managed database.
  ##   locationName: string (required)
  ##               : The name of the region where the resource is located.
  ##   operationId: string (required)
  ##              : Management operation id that this request tries to complete.
  var path_574137 = newJObject()
  var query_574139 = newJObject()
  var body_574140 = newJObject()
  add(query_574139, "api-version", newJString(apiVersion))
  add(path_574137, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574140 = parameters
  add(path_574137, "locationName", newJString(locationName))
  add(path_574137, "operationId", newJString(operationId))
  result = call_574136.call(path_574137, query_574139, nil, nil, body_574140)

var managedDatabasesCompleteRestore* = Call_ManagedDatabasesCompleteRestore_573863(
    name: "managedDatabasesCompleteRestore", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Sql/locations/{locationName}/managedDatabaseRestoreAzureAsyncOperation/{operationId}/completeRestore",
    validator: validate_ManagedDatabasesCompleteRestore_573864, base: "",
    url: url_ManagedDatabasesCompleteRestore_573865, schemes: {Scheme.Https})
type
  Call_ManagedDatabasesListByInstance_574179 = ref object of OpenApiRestCall_573641
proc url_ManagedDatabasesListByInstance_574181(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedInstanceName" in path,
        "`managedInstanceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/managedInstances/"),
               (kind: VariableSegment, value: "managedInstanceName"),
               (kind: ConstantSegment, value: "/databases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedDatabasesListByInstance_574180(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of managed databases.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574182 = path.getOrDefault("resourceGroupName")
  valid_574182 = validateParameter(valid_574182, JString, required = true,
                                 default = nil)
  if valid_574182 != nil:
    section.add "resourceGroupName", valid_574182
  var valid_574183 = path.getOrDefault("managedInstanceName")
  valid_574183 = validateParameter(valid_574183, JString, required = true,
                                 default = nil)
  if valid_574183 != nil:
    section.add "managedInstanceName", valid_574183
  var valid_574184 = path.getOrDefault("subscriptionId")
  valid_574184 = validateParameter(valid_574184, JString, required = true,
                                 default = nil)
  if valid_574184 != nil:
    section.add "subscriptionId", valid_574184
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574185 = query.getOrDefault("api-version")
  valid_574185 = validateParameter(valid_574185, JString, required = true,
                                 default = nil)
  if valid_574185 != nil:
    section.add "api-version", valid_574185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574186: Call_ManagedDatabasesListByInstance_574179; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of managed databases.
  ## 
  let valid = call_574186.validator(path, query, header, formData, body)
  let scheme = call_574186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574186.url(scheme.get, call_574186.host, call_574186.base,
                         call_574186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574186, url, valid)

proc call*(call_574187: Call_ManagedDatabasesListByInstance_574179;
          resourceGroupName: string; apiVersion: string;
          managedInstanceName: string; subscriptionId: string): Recallable =
  ## managedDatabasesListByInstance
  ## Gets a list of managed databases.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_574188 = newJObject()
  var query_574189 = newJObject()
  add(path_574188, "resourceGroupName", newJString(resourceGroupName))
  add(query_574189, "api-version", newJString(apiVersion))
  add(path_574188, "managedInstanceName", newJString(managedInstanceName))
  add(path_574188, "subscriptionId", newJString(subscriptionId))
  result = call_574187.call(path_574188, query_574189, nil, nil, nil)

var managedDatabasesListByInstance* = Call_ManagedDatabasesListByInstance_574179(
    name: "managedDatabasesListByInstance", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/databases",
    validator: validate_ManagedDatabasesListByInstance_574180, base: "",
    url: url_ManagedDatabasesListByInstance_574181, schemes: {Scheme.Https})
type
  Call_ManagedDatabasesCreateOrUpdate_574202 = ref object of OpenApiRestCall_573641
proc url_ManagedDatabasesCreateOrUpdate_574204(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedInstanceName" in path,
        "`managedInstanceName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/managedInstances/"),
               (kind: VariableSegment, value: "managedInstanceName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedDatabasesCreateOrUpdate_574203(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new database or updates an existing database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574205 = path.getOrDefault("resourceGroupName")
  valid_574205 = validateParameter(valid_574205, JString, required = true,
                                 default = nil)
  if valid_574205 != nil:
    section.add "resourceGroupName", valid_574205
  var valid_574206 = path.getOrDefault("managedInstanceName")
  valid_574206 = validateParameter(valid_574206, JString, required = true,
                                 default = nil)
  if valid_574206 != nil:
    section.add "managedInstanceName", valid_574206
  var valid_574207 = path.getOrDefault("subscriptionId")
  valid_574207 = validateParameter(valid_574207, JString, required = true,
                                 default = nil)
  if valid_574207 != nil:
    section.add "subscriptionId", valid_574207
  var valid_574208 = path.getOrDefault("databaseName")
  valid_574208 = validateParameter(valid_574208, JString, required = true,
                                 default = nil)
  if valid_574208 != nil:
    section.add "databaseName", valid_574208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574209 = query.getOrDefault("api-version")
  valid_574209 = validateParameter(valid_574209, JString, required = true,
                                 default = nil)
  if valid_574209 != nil:
    section.add "api-version", valid_574209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The requested database resource state.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574211: Call_ManagedDatabasesCreateOrUpdate_574202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new database or updates an existing database.
  ## 
  let valid = call_574211.validator(path, query, header, formData, body)
  let scheme = call_574211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574211.url(scheme.get, call_574211.host, call_574211.base,
                         call_574211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574211, url, valid)

proc call*(call_574212: Call_ManagedDatabasesCreateOrUpdate_574202;
          resourceGroupName: string; apiVersion: string;
          managedInstanceName: string; subscriptionId: string; databaseName: string;
          parameters: JsonNode): Recallable =
  ## managedDatabasesCreateOrUpdate
  ## Creates a new database or updates an existing database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   parameters: JObject (required)
  ##             : The requested database resource state.
  var path_574213 = newJObject()
  var query_574214 = newJObject()
  var body_574215 = newJObject()
  add(path_574213, "resourceGroupName", newJString(resourceGroupName))
  add(query_574214, "api-version", newJString(apiVersion))
  add(path_574213, "managedInstanceName", newJString(managedInstanceName))
  add(path_574213, "subscriptionId", newJString(subscriptionId))
  add(path_574213, "databaseName", newJString(databaseName))
  if parameters != nil:
    body_574215 = parameters
  result = call_574212.call(path_574213, query_574214, nil, nil, body_574215)

var managedDatabasesCreateOrUpdate* = Call_ManagedDatabasesCreateOrUpdate_574202(
    name: "managedDatabasesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/databases/{databaseName}",
    validator: validate_ManagedDatabasesCreateOrUpdate_574203, base: "",
    url: url_ManagedDatabasesCreateOrUpdate_574204, schemes: {Scheme.Https})
type
  Call_ManagedDatabasesGet_574190 = ref object of OpenApiRestCall_573641
proc url_ManagedDatabasesGet_574192(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedInstanceName" in path,
        "`managedInstanceName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/managedInstances/"),
               (kind: VariableSegment, value: "managedInstanceName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedDatabasesGet_574191(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets a managed database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574193 = path.getOrDefault("resourceGroupName")
  valid_574193 = validateParameter(valid_574193, JString, required = true,
                                 default = nil)
  if valid_574193 != nil:
    section.add "resourceGroupName", valid_574193
  var valid_574194 = path.getOrDefault("managedInstanceName")
  valid_574194 = validateParameter(valid_574194, JString, required = true,
                                 default = nil)
  if valid_574194 != nil:
    section.add "managedInstanceName", valid_574194
  var valid_574195 = path.getOrDefault("subscriptionId")
  valid_574195 = validateParameter(valid_574195, JString, required = true,
                                 default = nil)
  if valid_574195 != nil:
    section.add "subscriptionId", valid_574195
  var valid_574196 = path.getOrDefault("databaseName")
  valid_574196 = validateParameter(valid_574196, JString, required = true,
                                 default = nil)
  if valid_574196 != nil:
    section.add "databaseName", valid_574196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574197 = query.getOrDefault("api-version")
  valid_574197 = validateParameter(valid_574197, JString, required = true,
                                 default = nil)
  if valid_574197 != nil:
    section.add "api-version", valid_574197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574198: Call_ManagedDatabasesGet_574190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a managed database.
  ## 
  let valid = call_574198.validator(path, query, header, formData, body)
  let scheme = call_574198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574198.url(scheme.get, call_574198.host, call_574198.base,
                         call_574198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574198, url, valid)

proc call*(call_574199: Call_ManagedDatabasesGet_574190; resourceGroupName: string;
          apiVersion: string; managedInstanceName: string; subscriptionId: string;
          databaseName: string): Recallable =
  ## managedDatabasesGet
  ## Gets a managed database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  var path_574200 = newJObject()
  var query_574201 = newJObject()
  add(path_574200, "resourceGroupName", newJString(resourceGroupName))
  add(query_574201, "api-version", newJString(apiVersion))
  add(path_574200, "managedInstanceName", newJString(managedInstanceName))
  add(path_574200, "subscriptionId", newJString(subscriptionId))
  add(path_574200, "databaseName", newJString(databaseName))
  result = call_574199.call(path_574200, query_574201, nil, nil, nil)

var managedDatabasesGet* = Call_ManagedDatabasesGet_574190(
    name: "managedDatabasesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/databases/{databaseName}",
    validator: validate_ManagedDatabasesGet_574191, base: "",
    url: url_ManagedDatabasesGet_574192, schemes: {Scheme.Https})
type
  Call_ManagedDatabasesUpdate_574228 = ref object of OpenApiRestCall_573641
proc url_ManagedDatabasesUpdate_574230(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedInstanceName" in path,
        "`managedInstanceName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/managedInstances/"),
               (kind: VariableSegment, value: "managedInstanceName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedDatabasesUpdate_574229(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574231 = path.getOrDefault("resourceGroupName")
  valid_574231 = validateParameter(valid_574231, JString, required = true,
                                 default = nil)
  if valid_574231 != nil:
    section.add "resourceGroupName", valid_574231
  var valid_574232 = path.getOrDefault("managedInstanceName")
  valid_574232 = validateParameter(valid_574232, JString, required = true,
                                 default = nil)
  if valid_574232 != nil:
    section.add "managedInstanceName", valid_574232
  var valid_574233 = path.getOrDefault("subscriptionId")
  valid_574233 = validateParameter(valid_574233, JString, required = true,
                                 default = nil)
  if valid_574233 != nil:
    section.add "subscriptionId", valid_574233
  var valid_574234 = path.getOrDefault("databaseName")
  valid_574234 = validateParameter(valid_574234, JString, required = true,
                                 default = nil)
  if valid_574234 != nil:
    section.add "databaseName", valid_574234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574235 = query.getOrDefault("api-version")
  valid_574235 = validateParameter(valid_574235, JString, required = true,
                                 default = nil)
  if valid_574235 != nil:
    section.add "api-version", valid_574235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The requested database resource state.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574237: Call_ManagedDatabasesUpdate_574228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing database.
  ## 
  let valid = call_574237.validator(path, query, header, formData, body)
  let scheme = call_574237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574237.url(scheme.get, call_574237.host, call_574237.base,
                         call_574237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574237, url, valid)

proc call*(call_574238: Call_ManagedDatabasesUpdate_574228;
          resourceGroupName: string; apiVersion: string;
          managedInstanceName: string; subscriptionId: string; databaseName: string;
          parameters: JsonNode): Recallable =
  ## managedDatabasesUpdate
  ## Updates an existing database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   parameters: JObject (required)
  ##             : The requested database resource state.
  var path_574239 = newJObject()
  var query_574240 = newJObject()
  var body_574241 = newJObject()
  add(path_574239, "resourceGroupName", newJString(resourceGroupName))
  add(query_574240, "api-version", newJString(apiVersion))
  add(path_574239, "managedInstanceName", newJString(managedInstanceName))
  add(path_574239, "subscriptionId", newJString(subscriptionId))
  add(path_574239, "databaseName", newJString(databaseName))
  if parameters != nil:
    body_574241 = parameters
  result = call_574238.call(path_574239, query_574240, nil, nil, body_574241)

var managedDatabasesUpdate* = Call_ManagedDatabasesUpdate_574228(
    name: "managedDatabasesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/databases/{databaseName}",
    validator: validate_ManagedDatabasesUpdate_574229, base: "",
    url: url_ManagedDatabasesUpdate_574230, schemes: {Scheme.Https})
type
  Call_ManagedDatabasesDelete_574216 = ref object of OpenApiRestCall_573641
proc url_ManagedDatabasesDelete_574218(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedInstanceName" in path,
        "`managedInstanceName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/managedInstances/"),
               (kind: VariableSegment, value: "managedInstanceName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedDatabasesDelete_574217(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a managed database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574219 = path.getOrDefault("resourceGroupName")
  valid_574219 = validateParameter(valid_574219, JString, required = true,
                                 default = nil)
  if valid_574219 != nil:
    section.add "resourceGroupName", valid_574219
  var valid_574220 = path.getOrDefault("managedInstanceName")
  valid_574220 = validateParameter(valid_574220, JString, required = true,
                                 default = nil)
  if valid_574220 != nil:
    section.add "managedInstanceName", valid_574220
  var valid_574221 = path.getOrDefault("subscriptionId")
  valid_574221 = validateParameter(valid_574221, JString, required = true,
                                 default = nil)
  if valid_574221 != nil:
    section.add "subscriptionId", valid_574221
  var valid_574222 = path.getOrDefault("databaseName")
  valid_574222 = validateParameter(valid_574222, JString, required = true,
                                 default = nil)
  if valid_574222 != nil:
    section.add "databaseName", valid_574222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574223 = query.getOrDefault("api-version")
  valid_574223 = validateParameter(valid_574223, JString, required = true,
                                 default = nil)
  if valid_574223 != nil:
    section.add "api-version", valid_574223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574224: Call_ManagedDatabasesDelete_574216; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a managed database.
  ## 
  let valid = call_574224.validator(path, query, header, formData, body)
  let scheme = call_574224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574224.url(scheme.get, call_574224.host, call_574224.base,
                         call_574224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574224, url, valid)

proc call*(call_574225: Call_ManagedDatabasesDelete_574216;
          resourceGroupName: string; apiVersion: string;
          managedInstanceName: string; subscriptionId: string; databaseName: string): Recallable =
  ## managedDatabasesDelete
  ## Deletes a managed database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  var path_574226 = newJObject()
  var query_574227 = newJObject()
  add(path_574226, "resourceGroupName", newJString(resourceGroupName))
  add(query_574227, "api-version", newJString(apiVersion))
  add(path_574226, "managedInstanceName", newJString(managedInstanceName))
  add(path_574226, "subscriptionId", newJString(subscriptionId))
  add(path_574226, "databaseName", newJString(databaseName))
  result = call_574225.call(path_574226, query_574227, nil, nil, nil)

var managedDatabasesDelete* = Call_ManagedDatabasesDelete_574216(
    name: "managedDatabasesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/databases/{databaseName}",
    validator: validate_ManagedDatabasesDelete_574217, base: "",
    url: url_ManagedDatabasesDelete_574218, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
