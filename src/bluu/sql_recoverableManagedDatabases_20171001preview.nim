
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: SqlManagementClient
## version: 2017-10-01-preview
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
  macServiceName = "sql-recoverableManagedDatabases"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RecoverableManagedDatabasesListByInstance_563761 = ref object of OpenApiRestCall_563539
proc url_RecoverableManagedDatabasesListByInstance_563763(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/recoverableDatabases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecoverableManagedDatabasesListByInstance_563762(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of recoverable managed databases.
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
  var valid_563938 = path.getOrDefault("subscriptionId")
  valid_563938 = validateParameter(valid_563938, JString, required = true,
                                 default = nil)
  if valid_563938 != nil:
    section.add "subscriptionId", valid_563938
  var valid_563939 = path.getOrDefault("resourceGroupName")
  valid_563939 = validateParameter(valid_563939, JString, required = true,
                                 default = nil)
  if valid_563939 != nil:
    section.add "resourceGroupName", valid_563939
  var valid_563940 = path.getOrDefault("managedInstanceName")
  valid_563940 = validateParameter(valid_563940, JString, required = true,
                                 default = nil)
  if valid_563940 != nil:
    section.add "managedInstanceName", valid_563940
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
  if body != nil:
    result.add "body", body

proc call*(call_563964: Call_RecoverableManagedDatabasesListByInstance_563761;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of recoverable managed databases.
  ## 
  let valid = call_563964.validator(path, query, header, formData, body)
  let scheme = call_563964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563964.url(scheme.get, call_563964.host, call_563964.base,
                         call_563964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563964, url, valid)

proc call*(call_564035: Call_RecoverableManagedDatabasesListByInstance_563761;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          managedInstanceName: string): Recallable =
  ## recoverableManagedDatabasesListByInstance
  ## Gets a list of recoverable managed databases.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  var path_564036 = newJObject()
  var query_564038 = newJObject()
  add(query_564038, "api-version", newJString(apiVersion))
  add(path_564036, "subscriptionId", newJString(subscriptionId))
  add(path_564036, "resourceGroupName", newJString(resourceGroupName))
  add(path_564036, "managedInstanceName", newJString(managedInstanceName))
  result = call_564035.call(path_564036, query_564038, nil, nil, nil)

var recoverableManagedDatabasesListByInstance* = Call_RecoverableManagedDatabasesListByInstance_563761(
    name: "recoverableManagedDatabasesListByInstance", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/recoverableDatabases",
    validator: validate_RecoverableManagedDatabasesListByInstance_563762,
    base: "", url: url_RecoverableManagedDatabasesListByInstance_563763,
    schemes: {Scheme.Https})
type
  Call_RecoverableManagedDatabasesGet_564077 = ref object of OpenApiRestCall_563539
proc url_RecoverableManagedDatabasesGet_564079(protocol: Scheme; host: string;
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
  assert "recoverableDatabaseName" in path,
        "`recoverableDatabaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/managedInstances/"),
               (kind: VariableSegment, value: "managedInstanceName"),
               (kind: ConstantSegment, value: "/recoverableDatabases/"),
               (kind: VariableSegment, value: "recoverableDatabaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecoverableManagedDatabasesGet_564078(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a recoverable managed database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   recoverableDatabaseName: JString (required)
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `recoverableDatabaseName` field"
  var valid_564080 = path.getOrDefault("recoverableDatabaseName")
  valid_564080 = validateParameter(valid_564080, JString, required = true,
                                 default = nil)
  if valid_564080 != nil:
    section.add "recoverableDatabaseName", valid_564080
  var valid_564081 = path.getOrDefault("subscriptionId")
  valid_564081 = validateParameter(valid_564081, JString, required = true,
                                 default = nil)
  if valid_564081 != nil:
    section.add "subscriptionId", valid_564081
  var valid_564082 = path.getOrDefault("resourceGroupName")
  valid_564082 = validateParameter(valid_564082, JString, required = true,
                                 default = nil)
  if valid_564082 != nil:
    section.add "resourceGroupName", valid_564082
  var valid_564083 = path.getOrDefault("managedInstanceName")
  valid_564083 = validateParameter(valid_564083, JString, required = true,
                                 default = nil)
  if valid_564083 != nil:
    section.add "managedInstanceName", valid_564083
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564084 = query.getOrDefault("api-version")
  valid_564084 = validateParameter(valid_564084, JString, required = true,
                                 default = nil)
  if valid_564084 != nil:
    section.add "api-version", valid_564084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564085: Call_RecoverableManagedDatabasesGet_564077; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a recoverable managed database.
  ## 
  let valid = call_564085.validator(path, query, header, formData, body)
  let scheme = call_564085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564085.url(scheme.get, call_564085.host, call_564085.base,
                         call_564085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564085, url, valid)

proc call*(call_564086: Call_RecoverableManagedDatabasesGet_564077;
          apiVersion: string; recoverableDatabaseName: string;
          subscriptionId: string; resourceGroupName: string;
          managedInstanceName: string): Recallable =
  ## recoverableManagedDatabasesGet
  ## Gets a recoverable managed database.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   recoverableDatabaseName: string (required)
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  var path_564087 = newJObject()
  var query_564088 = newJObject()
  add(query_564088, "api-version", newJString(apiVersion))
  add(path_564087, "recoverableDatabaseName", newJString(recoverableDatabaseName))
  add(path_564087, "subscriptionId", newJString(subscriptionId))
  add(path_564087, "resourceGroupName", newJString(resourceGroupName))
  add(path_564087, "managedInstanceName", newJString(managedInstanceName))
  result = call_564086.call(path_564087, query_564088, nil, nil, nil)

var recoverableManagedDatabasesGet* = Call_RecoverableManagedDatabasesGet_564077(
    name: "recoverableManagedDatabasesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/recoverableDatabases/{recoverableDatabaseName}",
    validator: validate_RecoverableManagedDatabasesGet_564078, base: "",
    url: url_RecoverableManagedDatabasesGet_564079, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
