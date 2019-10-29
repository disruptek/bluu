
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

  OpenApiRestCall_563539 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563539](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563539): Option[Scheme] {.used.} =
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
  macServiceName = "sql-managedDatabases"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ManagedDatabasesCompleteRestore_563761 = ref object of OpenApiRestCall_563539
proc url_ManagedDatabasesCompleteRestore_563763(protocol: Scheme; host: string;
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

proc validate_ManagedDatabasesCompleteRestore_563762(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Completes the restore operation on a managed database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   locationName: JString (required)
  ##               : The name of the region where the resource is located.
  ##   operationId: JString (required)
  ##              : Management operation id that this request tries to complete.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `locationName` field"
  var valid_563938 = path.getOrDefault("locationName")
  valid_563938 = validateParameter(valid_563938, JString, required = true,
                                 default = nil)
  if valid_563938 != nil:
    section.add "locationName", valid_563938
  var valid_563939 = path.getOrDefault("operationId")
  valid_563939 = validateParameter(valid_563939, JString, required = true,
                                 default = nil)
  if valid_563939 != nil:
    section.add "operationId", valid_563939
  var valid_563940 = path.getOrDefault("subscriptionId")
  valid_563940 = validateParameter(valid_563940, JString, required = true,
                                 default = nil)
  if valid_563940 != nil:
    section.add "subscriptionId", valid_563940
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563941 = query.getOrDefault("api-version")
  valid_563941 = validateParameter(valid_563941, JString, required = true,
                                 default = nil)
  if valid_563941 != nil:
    section.add "api-version", valid_563941
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

proc call*(call_563965: Call_ManagedDatabasesCompleteRestore_563761;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Completes the restore operation on a managed database.
  ## 
  let valid = call_563965.validator(path, query, header, formData, body)
  let scheme = call_563965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563965.url(scheme.get, call_563965.host, call_563965.base,
                         call_563965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563965, url, valid)

proc call*(call_564036: Call_ManagedDatabasesCompleteRestore_563761;
          apiVersion: string; locationName: string; operationId: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## managedDatabasesCompleteRestore
  ## Completes the restore operation on a managed database.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   locationName: string (required)
  ##               : The name of the region where the resource is located.
  ##   operationId: string (required)
  ##              : Management operation id that this request tries to complete.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   parameters: JObject (required)
  ##             : The definition for completing the restore of this managed database.
  var path_564037 = newJObject()
  var query_564039 = newJObject()
  var body_564040 = newJObject()
  add(query_564039, "api-version", newJString(apiVersion))
  add(path_564037, "locationName", newJString(locationName))
  add(path_564037, "operationId", newJString(operationId))
  add(path_564037, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_564040 = parameters
  result = call_564036.call(path_564037, query_564039, nil, nil, body_564040)

var managedDatabasesCompleteRestore* = Call_ManagedDatabasesCompleteRestore_563761(
    name: "managedDatabasesCompleteRestore", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Sql/locations/{locationName}/managedDatabaseRestoreAzureAsyncOperation/{operationId}/completeRestore",
    validator: validate_ManagedDatabasesCompleteRestore_563762, base: "",
    url: url_ManagedDatabasesCompleteRestore_563763, schemes: {Scheme.Https})
type
  Call_ManagedDatabasesListByInstance_564079 = ref object of OpenApiRestCall_563539
proc url_ManagedDatabasesListByInstance_564081(protocol: Scheme; host: string;
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

proc validate_ManagedDatabasesListByInstance_564080(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of managed databases.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564082 = path.getOrDefault("subscriptionId")
  valid_564082 = validateParameter(valid_564082, JString, required = true,
                                 default = nil)
  if valid_564082 != nil:
    section.add "subscriptionId", valid_564082
  var valid_564083 = path.getOrDefault("resourceGroupName")
  valid_564083 = validateParameter(valid_564083, JString, required = true,
                                 default = nil)
  if valid_564083 != nil:
    section.add "resourceGroupName", valid_564083
  var valid_564084 = path.getOrDefault("managedInstanceName")
  valid_564084 = validateParameter(valid_564084, JString, required = true,
                                 default = nil)
  if valid_564084 != nil:
    section.add "managedInstanceName", valid_564084
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564085 = query.getOrDefault("api-version")
  valid_564085 = validateParameter(valid_564085, JString, required = true,
                                 default = nil)
  if valid_564085 != nil:
    section.add "api-version", valid_564085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564086: Call_ManagedDatabasesListByInstance_564079; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of managed databases.
  ## 
  let valid = call_564086.validator(path, query, header, formData, body)
  let scheme = call_564086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564086.url(scheme.get, call_564086.host, call_564086.base,
                         call_564086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564086, url, valid)

proc call*(call_564087: Call_ManagedDatabasesListByInstance_564079;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          managedInstanceName: string): Recallable =
  ## managedDatabasesListByInstance
  ## Gets a list of managed databases.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  var path_564088 = newJObject()
  var query_564089 = newJObject()
  add(query_564089, "api-version", newJString(apiVersion))
  add(path_564088, "subscriptionId", newJString(subscriptionId))
  add(path_564088, "resourceGroupName", newJString(resourceGroupName))
  add(path_564088, "managedInstanceName", newJString(managedInstanceName))
  result = call_564087.call(path_564088, query_564089, nil, nil, nil)

var managedDatabasesListByInstance* = Call_ManagedDatabasesListByInstance_564079(
    name: "managedDatabasesListByInstance", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/databases",
    validator: validate_ManagedDatabasesListByInstance_564080, base: "",
    url: url_ManagedDatabasesListByInstance_564081, schemes: {Scheme.Https})
type
  Call_ManagedDatabasesCreateOrUpdate_564102 = ref object of OpenApiRestCall_563539
proc url_ManagedDatabasesCreateOrUpdate_564104(protocol: Scheme; host: string;
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

proc validate_ManagedDatabasesCreateOrUpdate_564103(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new database or updates an existing database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564105 = path.getOrDefault("subscriptionId")
  valid_564105 = validateParameter(valid_564105, JString, required = true,
                                 default = nil)
  if valid_564105 != nil:
    section.add "subscriptionId", valid_564105
  var valid_564106 = path.getOrDefault("databaseName")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "databaseName", valid_564106
  var valid_564107 = path.getOrDefault("resourceGroupName")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "resourceGroupName", valid_564107
  var valid_564108 = path.getOrDefault("managedInstanceName")
  valid_564108 = validateParameter(valid_564108, JString, required = true,
                                 default = nil)
  if valid_564108 != nil:
    section.add "managedInstanceName", valid_564108
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564109 = query.getOrDefault("api-version")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = nil)
  if valid_564109 != nil:
    section.add "api-version", valid_564109
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

proc call*(call_564111: Call_ManagedDatabasesCreateOrUpdate_564102; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new database or updates an existing database.
  ## 
  let valid = call_564111.validator(path, query, header, formData, body)
  let scheme = call_564111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564111.url(scheme.get, call_564111.host, call_564111.base,
                         call_564111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564111, url, valid)

proc call*(call_564112: Call_ManagedDatabasesCreateOrUpdate_564102;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; managedInstanceName: string;
          parameters: JsonNode): Recallable =
  ## managedDatabasesCreateOrUpdate
  ## Creates a new database or updates an existing database.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  ##   parameters: JObject (required)
  ##             : The requested database resource state.
  var path_564113 = newJObject()
  var query_564114 = newJObject()
  var body_564115 = newJObject()
  add(query_564114, "api-version", newJString(apiVersion))
  add(path_564113, "subscriptionId", newJString(subscriptionId))
  add(path_564113, "databaseName", newJString(databaseName))
  add(path_564113, "resourceGroupName", newJString(resourceGroupName))
  add(path_564113, "managedInstanceName", newJString(managedInstanceName))
  if parameters != nil:
    body_564115 = parameters
  result = call_564112.call(path_564113, query_564114, nil, nil, body_564115)

var managedDatabasesCreateOrUpdate* = Call_ManagedDatabasesCreateOrUpdate_564102(
    name: "managedDatabasesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/databases/{databaseName}",
    validator: validate_ManagedDatabasesCreateOrUpdate_564103, base: "",
    url: url_ManagedDatabasesCreateOrUpdate_564104, schemes: {Scheme.Https})
type
  Call_ManagedDatabasesGet_564090 = ref object of OpenApiRestCall_563539
proc url_ManagedDatabasesGet_564092(protocol: Scheme; host: string; base: string;
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

proc validate_ManagedDatabasesGet_564091(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets a managed database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564093 = path.getOrDefault("subscriptionId")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "subscriptionId", valid_564093
  var valid_564094 = path.getOrDefault("databaseName")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "databaseName", valid_564094
  var valid_564095 = path.getOrDefault("resourceGroupName")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "resourceGroupName", valid_564095
  var valid_564096 = path.getOrDefault("managedInstanceName")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "managedInstanceName", valid_564096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564097 = query.getOrDefault("api-version")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "api-version", valid_564097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564098: Call_ManagedDatabasesGet_564090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a managed database.
  ## 
  let valid = call_564098.validator(path, query, header, formData, body)
  let scheme = call_564098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564098.url(scheme.get, call_564098.host, call_564098.base,
                         call_564098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564098, url, valid)

proc call*(call_564099: Call_ManagedDatabasesGet_564090; apiVersion: string;
          subscriptionId: string; databaseName: string; resourceGroupName: string;
          managedInstanceName: string): Recallable =
  ## managedDatabasesGet
  ## Gets a managed database.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  var path_564100 = newJObject()
  var query_564101 = newJObject()
  add(query_564101, "api-version", newJString(apiVersion))
  add(path_564100, "subscriptionId", newJString(subscriptionId))
  add(path_564100, "databaseName", newJString(databaseName))
  add(path_564100, "resourceGroupName", newJString(resourceGroupName))
  add(path_564100, "managedInstanceName", newJString(managedInstanceName))
  result = call_564099.call(path_564100, query_564101, nil, nil, nil)

var managedDatabasesGet* = Call_ManagedDatabasesGet_564090(
    name: "managedDatabasesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/databases/{databaseName}",
    validator: validate_ManagedDatabasesGet_564091, base: "",
    url: url_ManagedDatabasesGet_564092, schemes: {Scheme.Https})
type
  Call_ManagedDatabasesUpdate_564128 = ref object of OpenApiRestCall_563539
proc url_ManagedDatabasesUpdate_564130(protocol: Scheme; host: string; base: string;
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

proc validate_ManagedDatabasesUpdate_564129(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564131 = path.getOrDefault("subscriptionId")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "subscriptionId", valid_564131
  var valid_564132 = path.getOrDefault("databaseName")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "databaseName", valid_564132
  var valid_564133 = path.getOrDefault("resourceGroupName")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "resourceGroupName", valid_564133
  var valid_564134 = path.getOrDefault("managedInstanceName")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "managedInstanceName", valid_564134
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564135 = query.getOrDefault("api-version")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "api-version", valid_564135
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

proc call*(call_564137: Call_ManagedDatabasesUpdate_564128; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing database.
  ## 
  let valid = call_564137.validator(path, query, header, formData, body)
  let scheme = call_564137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564137.url(scheme.get, call_564137.host, call_564137.base,
                         call_564137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564137, url, valid)

proc call*(call_564138: Call_ManagedDatabasesUpdate_564128; apiVersion: string;
          subscriptionId: string; databaseName: string; resourceGroupName: string;
          managedInstanceName: string; parameters: JsonNode): Recallable =
  ## managedDatabasesUpdate
  ## Updates an existing database.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  ##   parameters: JObject (required)
  ##             : The requested database resource state.
  var path_564139 = newJObject()
  var query_564140 = newJObject()
  var body_564141 = newJObject()
  add(query_564140, "api-version", newJString(apiVersion))
  add(path_564139, "subscriptionId", newJString(subscriptionId))
  add(path_564139, "databaseName", newJString(databaseName))
  add(path_564139, "resourceGroupName", newJString(resourceGroupName))
  add(path_564139, "managedInstanceName", newJString(managedInstanceName))
  if parameters != nil:
    body_564141 = parameters
  result = call_564138.call(path_564139, query_564140, nil, nil, body_564141)

var managedDatabasesUpdate* = Call_ManagedDatabasesUpdate_564128(
    name: "managedDatabasesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/databases/{databaseName}",
    validator: validate_ManagedDatabasesUpdate_564129, base: "",
    url: url_ManagedDatabasesUpdate_564130, schemes: {Scheme.Https})
type
  Call_ManagedDatabasesDelete_564116 = ref object of OpenApiRestCall_563539
proc url_ManagedDatabasesDelete_564118(protocol: Scheme; host: string; base: string;
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

proc validate_ManagedDatabasesDelete_564117(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a managed database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564119 = path.getOrDefault("subscriptionId")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "subscriptionId", valid_564119
  var valid_564120 = path.getOrDefault("databaseName")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "databaseName", valid_564120
  var valid_564121 = path.getOrDefault("resourceGroupName")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "resourceGroupName", valid_564121
  var valid_564122 = path.getOrDefault("managedInstanceName")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "managedInstanceName", valid_564122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564123 = query.getOrDefault("api-version")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "api-version", valid_564123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564124: Call_ManagedDatabasesDelete_564116; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a managed database.
  ## 
  let valid = call_564124.validator(path, query, header, formData, body)
  let scheme = call_564124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564124.url(scheme.get, call_564124.host, call_564124.base,
                         call_564124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564124, url, valid)

proc call*(call_564125: Call_ManagedDatabasesDelete_564116; apiVersion: string;
          subscriptionId: string; databaseName: string; resourceGroupName: string;
          managedInstanceName: string): Recallable =
  ## managedDatabasesDelete
  ## Deletes a managed database.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  var path_564126 = newJObject()
  var query_564127 = newJObject()
  add(query_564127, "api-version", newJString(apiVersion))
  add(path_564126, "subscriptionId", newJString(subscriptionId))
  add(path_564126, "databaseName", newJString(databaseName))
  add(path_564126, "resourceGroupName", newJString(resourceGroupName))
  add(path_564126, "managedInstanceName", newJString(managedInstanceName))
  result = call_564125.call(path_564126, query_564127, nil, nil, nil)

var managedDatabasesDelete* = Call_ManagedDatabasesDelete_564116(
    name: "managedDatabasesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/databases/{databaseName}",
    validator: validate_ManagedDatabasesDelete_564117, base: "",
    url: url_ManagedDatabasesDelete_564118, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
