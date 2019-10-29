
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: AzureDataManagementClient
## version: 2017-03-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The AzureData management API provides a RESTful set of web APIs to manage Azure Data Resources. For example, register, delete and retrieve a SQL Server, SQL Server registration.
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
  macServiceName = "azuredata"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563777 = ref object of OpenApiRestCall_563555
proc url_OperationsList_563779(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563778(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available SQL Server Registration API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563940 = query.getOrDefault("api-version")
  valid_563940 = validateParameter(valid_563940, JString, required = true,
                                 default = nil)
  if valid_563940 != nil:
    section.add "api-version", valid_563940
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563963: Call_OperationsList_563777; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available SQL Server Registration API operations.
  ## 
  let valid = call_563963.validator(path, query, header, formData, body)
  let scheme = call_563963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563963.url(scheme.get, call_563963.host, call_563963.base,
                         call_563963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563963, url, valid)

proc call*(call_564034: Call_OperationsList_563777; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available SQL Server Registration API operations.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  var query_564035 = newJObject()
  add(query_564035, "api-version", newJString(apiVersion))
  result = call_564034.call(nil, query_564035, nil, nil, nil)

var operationsList* = Call_OperationsList_563777(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.AzureData/operations",
    validator: validate_OperationsList_563778, base: "", url: url_OperationsList_563779,
    schemes: {Scheme.Https})
type
  Call_SqlServerRegistrationsList_564075 = ref object of OpenApiRestCall_563555
proc url_SqlServerRegistrationsList_564077(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureData/sqlServerRegistrations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlServerRegistrationsList_564076(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all SQL Server registrations in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564092 = path.getOrDefault("subscriptionId")
  valid_564092 = validateParameter(valid_564092, JString, required = true,
                                 default = nil)
  if valid_564092 != nil:
    section.add "subscriptionId", valid_564092
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564093 = query.getOrDefault("api-version")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "api-version", valid_564093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564094: Call_SqlServerRegistrationsList_564075; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all SQL Server registrations in a subscription.
  ## 
  let valid = call_564094.validator(path, query, header, formData, body)
  let scheme = call_564094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564094.url(scheme.get, call_564094.host, call_564094.base,
                         call_564094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564094, url, valid)

proc call*(call_564095: Call_SqlServerRegistrationsList_564075; apiVersion: string;
          subscriptionId: string): Recallable =
  ## sqlServerRegistrationsList
  ## Gets all SQL Server registrations in a subscription.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  var path_564096 = newJObject()
  var query_564097 = newJObject()
  add(query_564097, "api-version", newJString(apiVersion))
  add(path_564096, "subscriptionId", newJString(subscriptionId))
  result = call_564095.call(path_564096, query_564097, nil, nil, nil)

var sqlServerRegistrationsList* = Call_SqlServerRegistrationsList_564075(
    name: "sqlServerRegistrationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AzureData/sqlServerRegistrations",
    validator: validate_SqlServerRegistrationsList_564076, base: "",
    url: url_SqlServerRegistrationsList_564077, schemes: {Scheme.Https})
type
  Call_SqlServerRegistrationsListByResourceGroup_564098 = ref object of OpenApiRestCall_563555
proc url_SqlServerRegistrationsListByResourceGroup_564100(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureData/sqlServerRegistrations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlServerRegistrationsListByResourceGroup_564099(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all SQL Server registrations in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564101 = path.getOrDefault("subscriptionId")
  valid_564101 = validateParameter(valid_564101, JString, required = true,
                                 default = nil)
  if valid_564101 != nil:
    section.add "subscriptionId", valid_564101
  var valid_564102 = path.getOrDefault("resourceGroupName")
  valid_564102 = validateParameter(valid_564102, JString, required = true,
                                 default = nil)
  if valid_564102 != nil:
    section.add "resourceGroupName", valid_564102
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564103 = query.getOrDefault("api-version")
  valid_564103 = validateParameter(valid_564103, JString, required = true,
                                 default = nil)
  if valid_564103 != nil:
    section.add "api-version", valid_564103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564104: Call_SqlServerRegistrationsListByResourceGroup_564098;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all SQL Server registrations in a resource group.
  ## 
  let valid = call_564104.validator(path, query, header, formData, body)
  let scheme = call_564104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564104.url(scheme.get, call_564104.host, call_564104.base,
                         call_564104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564104, url, valid)

proc call*(call_564105: Call_SqlServerRegistrationsListByResourceGroup_564098;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## sqlServerRegistrationsListByResourceGroup
  ## Gets all SQL Server registrations in a resource group.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564106 = newJObject()
  var query_564107 = newJObject()
  add(query_564107, "api-version", newJString(apiVersion))
  add(path_564106, "subscriptionId", newJString(subscriptionId))
  add(path_564106, "resourceGroupName", newJString(resourceGroupName))
  result = call_564105.call(path_564106, query_564107, nil, nil, nil)

var sqlServerRegistrationsListByResourceGroup* = Call_SqlServerRegistrationsListByResourceGroup_564098(
    name: "sqlServerRegistrationsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureData/sqlServerRegistrations",
    validator: validate_SqlServerRegistrationsListByResourceGroup_564099,
    base: "", url: url_SqlServerRegistrationsListByResourceGroup_564100,
    schemes: {Scheme.Https})
type
  Call_SqlServerRegistrationsCreateOrUpdate_564119 = ref object of OpenApiRestCall_563555
proc url_SqlServerRegistrationsCreateOrUpdate_564121(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "sqlServerRegistrationName" in path,
        "`sqlServerRegistrationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureData/sqlServerRegistrations/"),
               (kind: VariableSegment, value: "sqlServerRegistrationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlServerRegistrationsCreateOrUpdate_564120(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a SQL Server registration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   sqlServerRegistrationName: JString (required)
  ##                            : Name of the SQL Server registration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564122 = path.getOrDefault("subscriptionId")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "subscriptionId", valid_564122
  var valid_564123 = path.getOrDefault("resourceGroupName")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "resourceGroupName", valid_564123
  var valid_564124 = path.getOrDefault("sqlServerRegistrationName")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "sqlServerRegistrationName", valid_564124
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
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
  ##             : The SQL Server registration to be created or updated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564127: Call_SqlServerRegistrationsCreateOrUpdate_564119;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a SQL Server registration.
  ## 
  let valid = call_564127.validator(path, query, header, formData, body)
  let scheme = call_564127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564127.url(scheme.get, call_564127.host, call_564127.base,
                         call_564127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564127, url, valid)

proc call*(call_564128: Call_SqlServerRegistrationsCreateOrUpdate_564119;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode; sqlServerRegistrationName: string): Recallable =
  ## sqlServerRegistrationsCreateOrUpdate
  ## Creates or updates a SQL Server registration.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   parameters: JObject (required)
  ##             : The SQL Server registration to be created or updated.
  ##   sqlServerRegistrationName: string (required)
  ##                            : Name of the SQL Server registration.
  var path_564129 = newJObject()
  var query_564130 = newJObject()
  var body_564131 = newJObject()
  add(query_564130, "api-version", newJString(apiVersion))
  add(path_564129, "subscriptionId", newJString(subscriptionId))
  add(path_564129, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564131 = parameters
  add(path_564129, "sqlServerRegistrationName",
      newJString(sqlServerRegistrationName))
  result = call_564128.call(path_564129, query_564130, nil, nil, body_564131)

var sqlServerRegistrationsCreateOrUpdate* = Call_SqlServerRegistrationsCreateOrUpdate_564119(
    name: "sqlServerRegistrationsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureData/sqlServerRegistrations/{sqlServerRegistrationName}",
    validator: validate_SqlServerRegistrationsCreateOrUpdate_564120, base: "",
    url: url_SqlServerRegistrationsCreateOrUpdate_564121, schemes: {Scheme.Https})
type
  Call_SqlServerRegistrationsGet_564108 = ref object of OpenApiRestCall_563555
proc url_SqlServerRegistrationsGet_564110(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "sqlServerRegistrationName" in path,
        "`sqlServerRegistrationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureData/sqlServerRegistrations/"),
               (kind: VariableSegment, value: "sqlServerRegistrationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlServerRegistrationsGet_564109(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a SQL Server registration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   sqlServerRegistrationName: JString (required)
  ##                            : Name of the SQL Server registration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
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
  var valid_564113 = path.getOrDefault("sqlServerRegistrationName")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "sqlServerRegistrationName", valid_564113
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564114 = query.getOrDefault("api-version")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "api-version", valid_564114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564115: Call_SqlServerRegistrationsGet_564108; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a SQL Server registration.
  ## 
  let valid = call_564115.validator(path, query, header, formData, body)
  let scheme = call_564115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564115.url(scheme.get, call_564115.host, call_564115.base,
                         call_564115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564115, url, valid)

proc call*(call_564116: Call_SqlServerRegistrationsGet_564108; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          sqlServerRegistrationName: string): Recallable =
  ## sqlServerRegistrationsGet
  ## Gets a SQL Server registration.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   sqlServerRegistrationName: string (required)
  ##                            : Name of the SQL Server registration.
  var path_564117 = newJObject()
  var query_564118 = newJObject()
  add(query_564118, "api-version", newJString(apiVersion))
  add(path_564117, "subscriptionId", newJString(subscriptionId))
  add(path_564117, "resourceGroupName", newJString(resourceGroupName))
  add(path_564117, "sqlServerRegistrationName",
      newJString(sqlServerRegistrationName))
  result = call_564116.call(path_564117, query_564118, nil, nil, nil)

var sqlServerRegistrationsGet* = Call_SqlServerRegistrationsGet_564108(
    name: "sqlServerRegistrationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureData/sqlServerRegistrations/{sqlServerRegistrationName}",
    validator: validate_SqlServerRegistrationsGet_564109, base: "",
    url: url_SqlServerRegistrationsGet_564110, schemes: {Scheme.Https})
type
  Call_SqlServerRegistrationsUpdate_564143 = ref object of OpenApiRestCall_563555
proc url_SqlServerRegistrationsUpdate_564145(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "sqlServerRegistrationName" in path,
        "`sqlServerRegistrationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureData/sqlServerRegistrations/"),
               (kind: VariableSegment, value: "sqlServerRegistrationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlServerRegistrationsUpdate_564144(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates SQL Server Registration tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   sqlServerRegistrationName: JString (required)
  ##                            : Name of the SQL Server registration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564146 = path.getOrDefault("subscriptionId")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "subscriptionId", valid_564146
  var valid_564147 = path.getOrDefault("resourceGroupName")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "resourceGroupName", valid_564147
  var valid_564148 = path.getOrDefault("sqlServerRegistrationName")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "sqlServerRegistrationName", valid_564148
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564149 = query.getOrDefault("api-version")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "api-version", valid_564149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The SQL Server Registration.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564151: Call_SqlServerRegistrationsUpdate_564143; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates SQL Server Registration tags.
  ## 
  let valid = call_564151.validator(path, query, header, formData, body)
  let scheme = call_564151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564151.url(scheme.get, call_564151.host, call_564151.base,
                         call_564151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564151, url, valid)

proc call*(call_564152: Call_SqlServerRegistrationsUpdate_564143;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode; sqlServerRegistrationName: string): Recallable =
  ## sqlServerRegistrationsUpdate
  ## Updates SQL Server Registration tags.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   parameters: JObject (required)
  ##             : The SQL Server Registration.
  ##   sqlServerRegistrationName: string (required)
  ##                            : Name of the SQL Server registration.
  var path_564153 = newJObject()
  var query_564154 = newJObject()
  var body_564155 = newJObject()
  add(query_564154, "api-version", newJString(apiVersion))
  add(path_564153, "subscriptionId", newJString(subscriptionId))
  add(path_564153, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564155 = parameters
  add(path_564153, "sqlServerRegistrationName",
      newJString(sqlServerRegistrationName))
  result = call_564152.call(path_564153, query_564154, nil, nil, body_564155)

var sqlServerRegistrationsUpdate* = Call_SqlServerRegistrationsUpdate_564143(
    name: "sqlServerRegistrationsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureData/sqlServerRegistrations/{sqlServerRegistrationName}",
    validator: validate_SqlServerRegistrationsUpdate_564144, base: "",
    url: url_SqlServerRegistrationsUpdate_564145, schemes: {Scheme.Https})
type
  Call_SqlServerRegistrationsDelete_564132 = ref object of OpenApiRestCall_563555
proc url_SqlServerRegistrationsDelete_564134(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "sqlServerRegistrationName" in path,
        "`sqlServerRegistrationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureData/sqlServerRegistrations/"),
               (kind: VariableSegment, value: "sqlServerRegistrationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlServerRegistrationsDelete_564133(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a SQL Server registration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   sqlServerRegistrationName: JString (required)
  ##                            : Name of the SQL Server registration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564135 = path.getOrDefault("subscriptionId")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "subscriptionId", valid_564135
  var valid_564136 = path.getOrDefault("resourceGroupName")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "resourceGroupName", valid_564136
  var valid_564137 = path.getOrDefault("sqlServerRegistrationName")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "sqlServerRegistrationName", valid_564137
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564138 = query.getOrDefault("api-version")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "api-version", valid_564138
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564139: Call_SqlServerRegistrationsDelete_564132; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a SQL Server registration.
  ## 
  let valid = call_564139.validator(path, query, header, formData, body)
  let scheme = call_564139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564139.url(scheme.get, call_564139.host, call_564139.base,
                         call_564139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564139, url, valid)

proc call*(call_564140: Call_SqlServerRegistrationsDelete_564132;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          sqlServerRegistrationName: string): Recallable =
  ## sqlServerRegistrationsDelete
  ## Deletes a SQL Server registration.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   sqlServerRegistrationName: string (required)
  ##                            : Name of the SQL Server registration.
  var path_564141 = newJObject()
  var query_564142 = newJObject()
  add(query_564142, "api-version", newJString(apiVersion))
  add(path_564141, "subscriptionId", newJString(subscriptionId))
  add(path_564141, "resourceGroupName", newJString(resourceGroupName))
  add(path_564141, "sqlServerRegistrationName",
      newJString(sqlServerRegistrationName))
  result = call_564140.call(path_564141, query_564142, nil, nil, nil)

var sqlServerRegistrationsDelete* = Call_SqlServerRegistrationsDelete_564132(
    name: "sqlServerRegistrationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureData/sqlServerRegistrations/{sqlServerRegistrationName}",
    validator: validate_SqlServerRegistrationsDelete_564133, base: "",
    url: url_SqlServerRegistrationsDelete_564134, schemes: {Scheme.Https})
type
  Call_SqlServersListByResourceGroup_564156 = ref object of OpenApiRestCall_563555
proc url_SqlServersListByResourceGroup_564158(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "sqlServerRegistrationName" in path,
        "`sqlServerRegistrationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureData/sqlServerRegistrations/"),
               (kind: VariableSegment, value: "sqlServerRegistrationName"),
               (kind: ConstantSegment, value: "/sqlServers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlServersListByResourceGroup_564157(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all SQL Servers in a SQL Server Registration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   sqlServerRegistrationName: JString (required)
  ##                            : Name of the SQL Server registration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564160 = path.getOrDefault("subscriptionId")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "subscriptionId", valid_564160
  var valid_564161 = path.getOrDefault("resourceGroupName")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "resourceGroupName", valid_564161
  var valid_564162 = path.getOrDefault("sqlServerRegistrationName")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "sqlServerRegistrationName", valid_564162
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  ##   $expand: JString
  ##          : The child resources to include in the response.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564163 = query.getOrDefault("api-version")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "api-version", valid_564163
  var valid_564164 = query.getOrDefault("$expand")
  valid_564164 = validateParameter(valid_564164, JString, required = false,
                                 default = nil)
  if valid_564164 != nil:
    section.add "$expand", valid_564164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564165: Call_SqlServersListByResourceGroup_564156; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all SQL Servers in a SQL Server Registration.
  ## 
  let valid = call_564165.validator(path, query, header, formData, body)
  let scheme = call_564165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564165.url(scheme.get, call_564165.host, call_564165.base,
                         call_564165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564165, url, valid)

proc call*(call_564166: Call_SqlServersListByResourceGroup_564156;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          sqlServerRegistrationName: string; Expand: string = ""): Recallable =
  ## sqlServersListByResourceGroup
  ## Gets all SQL Servers in a SQL Server Registration.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   Expand: string
  ##         : The child resources to include in the response.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   sqlServerRegistrationName: string (required)
  ##                            : Name of the SQL Server registration.
  var path_564167 = newJObject()
  var query_564168 = newJObject()
  add(query_564168, "api-version", newJString(apiVersion))
  add(query_564168, "$expand", newJString(Expand))
  add(path_564167, "subscriptionId", newJString(subscriptionId))
  add(path_564167, "resourceGroupName", newJString(resourceGroupName))
  add(path_564167, "sqlServerRegistrationName",
      newJString(sqlServerRegistrationName))
  result = call_564166.call(path_564167, query_564168, nil, nil, nil)

var sqlServersListByResourceGroup* = Call_SqlServersListByResourceGroup_564156(
    name: "sqlServersListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureData/sqlServerRegistrations/{sqlServerRegistrationName}/sqlServers",
    validator: validate_SqlServersListByResourceGroup_564157, base: "",
    url: url_SqlServersListByResourceGroup_564158, schemes: {Scheme.Https})
type
  Call_SqlServersCreateOrUpdate_564182 = ref object of OpenApiRestCall_563555
proc url_SqlServersCreateOrUpdate_564184(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "sqlServerRegistrationName" in path,
        "`sqlServerRegistrationName` is a required path parameter"
  assert "sqlServerName" in path, "`sqlServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureData/sqlServerRegistrations/"),
               (kind: VariableSegment, value: "sqlServerRegistrationName"),
               (kind: ConstantSegment, value: "/sqlServers/"),
               (kind: VariableSegment, value: "sqlServerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlServersCreateOrUpdate_564183(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a SQL Server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sqlServerName: JString (required)
  ##                : Name of the SQL Server.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   sqlServerRegistrationName: JString (required)
  ##                            : Name of the SQL Server registration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `sqlServerName` field"
  var valid_564185 = path.getOrDefault("sqlServerName")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "sqlServerName", valid_564185
  var valid_564186 = path.getOrDefault("subscriptionId")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "subscriptionId", valid_564186
  var valid_564187 = path.getOrDefault("resourceGroupName")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "resourceGroupName", valid_564187
  var valid_564188 = path.getOrDefault("sqlServerRegistrationName")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "sqlServerRegistrationName", valid_564188
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564189 = query.getOrDefault("api-version")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "api-version", valid_564189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The SQL Server to be created or updated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564191: Call_SqlServersCreateOrUpdate_564182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a SQL Server.
  ## 
  let valid = call_564191.validator(path, query, header, formData, body)
  let scheme = call_564191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564191.url(scheme.get, call_564191.host, call_564191.base,
                         call_564191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564191, url, valid)

proc call*(call_564192: Call_SqlServersCreateOrUpdate_564182;
          sqlServerName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode;
          sqlServerRegistrationName: string): Recallable =
  ## sqlServersCreateOrUpdate
  ## Creates or updates a SQL Server.
  ##   sqlServerName: string (required)
  ##                : Name of the SQL Server.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   parameters: JObject (required)
  ##             : The SQL Server to be created or updated.
  ##   sqlServerRegistrationName: string (required)
  ##                            : Name of the SQL Server registration.
  var path_564193 = newJObject()
  var query_564194 = newJObject()
  var body_564195 = newJObject()
  add(path_564193, "sqlServerName", newJString(sqlServerName))
  add(query_564194, "api-version", newJString(apiVersion))
  add(path_564193, "subscriptionId", newJString(subscriptionId))
  add(path_564193, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564195 = parameters
  add(path_564193, "sqlServerRegistrationName",
      newJString(sqlServerRegistrationName))
  result = call_564192.call(path_564193, query_564194, nil, nil, body_564195)

var sqlServersCreateOrUpdate* = Call_SqlServersCreateOrUpdate_564182(
    name: "sqlServersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureData/sqlServerRegistrations/{sqlServerRegistrationName}/sqlServers/{sqlServerName}",
    validator: validate_SqlServersCreateOrUpdate_564183, base: "",
    url: url_SqlServersCreateOrUpdate_564184, schemes: {Scheme.Https})
type
  Call_SqlServersGet_564169 = ref object of OpenApiRestCall_563555
proc url_SqlServersGet_564171(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "sqlServerRegistrationName" in path,
        "`sqlServerRegistrationName` is a required path parameter"
  assert "sqlServerName" in path, "`sqlServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureData/sqlServerRegistrations/"),
               (kind: VariableSegment, value: "sqlServerRegistrationName"),
               (kind: ConstantSegment, value: "/sqlServers/"),
               (kind: VariableSegment, value: "sqlServerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlServersGet_564170(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a SQL Server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sqlServerName: JString (required)
  ##                : Name of the SQL Server.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   sqlServerRegistrationName: JString (required)
  ##                            : Name of the SQL Server registration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `sqlServerName` field"
  var valid_564172 = path.getOrDefault("sqlServerName")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "sqlServerName", valid_564172
  var valid_564173 = path.getOrDefault("subscriptionId")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "subscriptionId", valid_564173
  var valid_564174 = path.getOrDefault("resourceGroupName")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "resourceGroupName", valid_564174
  var valid_564175 = path.getOrDefault("sqlServerRegistrationName")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "sqlServerRegistrationName", valid_564175
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  ##   $expand: JString
  ##          : The child resources to include in the response.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564176 = query.getOrDefault("api-version")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "api-version", valid_564176
  var valid_564177 = query.getOrDefault("$expand")
  valid_564177 = validateParameter(valid_564177, JString, required = false,
                                 default = nil)
  if valid_564177 != nil:
    section.add "$expand", valid_564177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564178: Call_SqlServersGet_564169; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a SQL Server.
  ## 
  let valid = call_564178.validator(path, query, header, formData, body)
  let scheme = call_564178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564178.url(scheme.get, call_564178.host, call_564178.base,
                         call_564178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564178, url, valid)

proc call*(call_564179: Call_SqlServersGet_564169; sqlServerName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          sqlServerRegistrationName: string; Expand: string = ""): Recallable =
  ## sqlServersGet
  ## Gets a SQL Server.
  ##   sqlServerName: string (required)
  ##                : Name of the SQL Server.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   Expand: string
  ##         : The child resources to include in the response.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   sqlServerRegistrationName: string (required)
  ##                            : Name of the SQL Server registration.
  var path_564180 = newJObject()
  var query_564181 = newJObject()
  add(path_564180, "sqlServerName", newJString(sqlServerName))
  add(query_564181, "api-version", newJString(apiVersion))
  add(query_564181, "$expand", newJString(Expand))
  add(path_564180, "subscriptionId", newJString(subscriptionId))
  add(path_564180, "resourceGroupName", newJString(resourceGroupName))
  add(path_564180, "sqlServerRegistrationName",
      newJString(sqlServerRegistrationName))
  result = call_564179.call(path_564180, query_564181, nil, nil, nil)

var sqlServersGet* = Call_SqlServersGet_564169(name: "sqlServersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureData/sqlServerRegistrations/{sqlServerRegistrationName}/sqlServers/{sqlServerName}",
    validator: validate_SqlServersGet_564170, base: "", url: url_SqlServersGet_564171,
    schemes: {Scheme.Https})
type
  Call_SqlServersDelete_564196 = ref object of OpenApiRestCall_563555
proc url_SqlServersDelete_564198(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "sqlServerRegistrationName" in path,
        "`sqlServerRegistrationName` is a required path parameter"
  assert "sqlServerName" in path, "`sqlServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureData/sqlServerRegistrations/"),
               (kind: VariableSegment, value: "sqlServerRegistrationName"),
               (kind: ConstantSegment, value: "/sqlServers/"),
               (kind: VariableSegment, value: "sqlServerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlServersDelete_564197(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes a SQL Server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sqlServerName: JString (required)
  ##                : Name of the SQL Server.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   sqlServerRegistrationName: JString (required)
  ##                            : Name of the SQL Server registration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `sqlServerName` field"
  var valid_564199 = path.getOrDefault("sqlServerName")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "sqlServerName", valid_564199
  var valid_564200 = path.getOrDefault("subscriptionId")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "subscriptionId", valid_564200
  var valid_564201 = path.getOrDefault("resourceGroupName")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "resourceGroupName", valid_564201
  var valid_564202 = path.getOrDefault("sqlServerRegistrationName")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "sqlServerRegistrationName", valid_564202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564203 = query.getOrDefault("api-version")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "api-version", valid_564203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564204: Call_SqlServersDelete_564196; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a SQL Server.
  ## 
  let valid = call_564204.validator(path, query, header, formData, body)
  let scheme = call_564204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564204.url(scheme.get, call_564204.host, call_564204.base,
                         call_564204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564204, url, valid)

proc call*(call_564205: Call_SqlServersDelete_564196; sqlServerName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          sqlServerRegistrationName: string): Recallable =
  ## sqlServersDelete
  ## Deletes a SQL Server.
  ##   sqlServerName: string (required)
  ##                : Name of the SQL Server.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   sqlServerRegistrationName: string (required)
  ##                            : Name of the SQL Server registration.
  var path_564206 = newJObject()
  var query_564207 = newJObject()
  add(path_564206, "sqlServerName", newJString(sqlServerName))
  add(query_564207, "api-version", newJString(apiVersion))
  add(path_564206, "subscriptionId", newJString(subscriptionId))
  add(path_564206, "resourceGroupName", newJString(resourceGroupName))
  add(path_564206, "sqlServerRegistrationName",
      newJString(sqlServerRegistrationName))
  result = call_564205.call(path_564206, query_564207, nil, nil, nil)

var sqlServersDelete* = Call_SqlServersDelete_564196(name: "sqlServersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureData/sqlServerRegistrations/{sqlServerRegistrationName}/sqlServers/{sqlServerName}",
    validator: validate_SqlServersDelete_564197, base: "",
    url: url_SqlServersDelete_564198, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
