
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

  OpenApiRestCall_573657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573657): Option[Scheme] {.used.} =
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
  macServiceName = "azuredata"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_573879 = ref object of OpenApiRestCall_573657
proc url_OperationsList_573881(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_573880(path: JsonNode; query: JsonNode;
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
  var valid_574040 = query.getOrDefault("api-version")
  valid_574040 = validateParameter(valid_574040, JString, required = true,
                                 default = nil)
  if valid_574040 != nil:
    section.add "api-version", valid_574040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574063: Call_OperationsList_573879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available SQL Server Registration API operations.
  ## 
  let valid = call_574063.validator(path, query, header, formData, body)
  let scheme = call_574063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574063.url(scheme.get, call_574063.host, call_574063.base,
                         call_574063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574063, url, valid)

proc call*(call_574134: Call_OperationsList_573879; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available SQL Server Registration API operations.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  var query_574135 = newJObject()
  add(query_574135, "api-version", newJString(apiVersion))
  result = call_574134.call(nil, query_574135, nil, nil, nil)

var operationsList* = Call_OperationsList_573879(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.AzureData/operations",
    validator: validate_OperationsList_573880, base: "", url: url_OperationsList_573881,
    schemes: {Scheme.Https})
type
  Call_SqlServerRegistrationsList_574175 = ref object of OpenApiRestCall_573657
proc url_SqlServerRegistrationsList_574177(protocol: Scheme; host: string;
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

proc validate_SqlServerRegistrationsList_574176(path: JsonNode; query: JsonNode;
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
  var valid_574192 = path.getOrDefault("subscriptionId")
  valid_574192 = validateParameter(valid_574192, JString, required = true,
                                 default = nil)
  if valid_574192 != nil:
    section.add "subscriptionId", valid_574192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574193 = query.getOrDefault("api-version")
  valid_574193 = validateParameter(valid_574193, JString, required = true,
                                 default = nil)
  if valid_574193 != nil:
    section.add "api-version", valid_574193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574194: Call_SqlServerRegistrationsList_574175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all SQL Server registrations in a subscription.
  ## 
  let valid = call_574194.validator(path, query, header, formData, body)
  let scheme = call_574194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574194.url(scheme.get, call_574194.host, call_574194.base,
                         call_574194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574194, url, valid)

proc call*(call_574195: Call_SqlServerRegistrationsList_574175; apiVersion: string;
          subscriptionId: string): Recallable =
  ## sqlServerRegistrationsList
  ## Gets all SQL Server registrations in a subscription.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  var path_574196 = newJObject()
  var query_574197 = newJObject()
  add(query_574197, "api-version", newJString(apiVersion))
  add(path_574196, "subscriptionId", newJString(subscriptionId))
  result = call_574195.call(path_574196, query_574197, nil, nil, nil)

var sqlServerRegistrationsList* = Call_SqlServerRegistrationsList_574175(
    name: "sqlServerRegistrationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AzureData/sqlServerRegistrations",
    validator: validate_SqlServerRegistrationsList_574176, base: "",
    url: url_SqlServerRegistrationsList_574177, schemes: {Scheme.Https})
type
  Call_SqlServerRegistrationsListByResourceGroup_574198 = ref object of OpenApiRestCall_573657
proc url_SqlServerRegistrationsListByResourceGroup_574200(protocol: Scheme;
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

proc validate_SqlServerRegistrationsListByResourceGroup_574199(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all SQL Server registrations in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574201 = path.getOrDefault("resourceGroupName")
  valid_574201 = validateParameter(valid_574201, JString, required = true,
                                 default = nil)
  if valid_574201 != nil:
    section.add "resourceGroupName", valid_574201
  var valid_574202 = path.getOrDefault("subscriptionId")
  valid_574202 = validateParameter(valid_574202, JString, required = true,
                                 default = nil)
  if valid_574202 != nil:
    section.add "subscriptionId", valid_574202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574203 = query.getOrDefault("api-version")
  valid_574203 = validateParameter(valid_574203, JString, required = true,
                                 default = nil)
  if valid_574203 != nil:
    section.add "api-version", valid_574203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574204: Call_SqlServerRegistrationsListByResourceGroup_574198;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all SQL Server registrations in a resource group.
  ## 
  let valid = call_574204.validator(path, query, header, formData, body)
  let scheme = call_574204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574204.url(scheme.get, call_574204.host, call_574204.base,
                         call_574204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574204, url, valid)

proc call*(call_574205: Call_SqlServerRegistrationsListByResourceGroup_574198;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## sqlServerRegistrationsListByResourceGroup
  ## Gets all SQL Server registrations in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  var path_574206 = newJObject()
  var query_574207 = newJObject()
  add(path_574206, "resourceGroupName", newJString(resourceGroupName))
  add(query_574207, "api-version", newJString(apiVersion))
  add(path_574206, "subscriptionId", newJString(subscriptionId))
  result = call_574205.call(path_574206, query_574207, nil, nil, nil)

var sqlServerRegistrationsListByResourceGroup* = Call_SqlServerRegistrationsListByResourceGroup_574198(
    name: "sqlServerRegistrationsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureData/sqlServerRegistrations",
    validator: validate_SqlServerRegistrationsListByResourceGroup_574199,
    base: "", url: url_SqlServerRegistrationsListByResourceGroup_574200,
    schemes: {Scheme.Https})
type
  Call_SqlServerRegistrationsCreateOrUpdate_574219 = ref object of OpenApiRestCall_573657
proc url_SqlServerRegistrationsCreateOrUpdate_574221(protocol: Scheme;
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

proc validate_SqlServerRegistrationsCreateOrUpdate_574220(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a SQL Server registration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   sqlServerRegistrationName: JString (required)
  ##                            : Name of the SQL Server registration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574222 = path.getOrDefault("resourceGroupName")
  valid_574222 = validateParameter(valid_574222, JString, required = true,
                                 default = nil)
  if valid_574222 != nil:
    section.add "resourceGroupName", valid_574222
  var valid_574223 = path.getOrDefault("subscriptionId")
  valid_574223 = validateParameter(valid_574223, JString, required = true,
                                 default = nil)
  if valid_574223 != nil:
    section.add "subscriptionId", valid_574223
  var valid_574224 = path.getOrDefault("sqlServerRegistrationName")
  valid_574224 = validateParameter(valid_574224, JString, required = true,
                                 default = nil)
  if valid_574224 != nil:
    section.add "sqlServerRegistrationName", valid_574224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574225 = query.getOrDefault("api-version")
  valid_574225 = validateParameter(valid_574225, JString, required = true,
                                 default = nil)
  if valid_574225 != nil:
    section.add "api-version", valid_574225
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

proc call*(call_574227: Call_SqlServerRegistrationsCreateOrUpdate_574219;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a SQL Server registration.
  ## 
  let valid = call_574227.validator(path, query, header, formData, body)
  let scheme = call_574227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574227.url(scheme.get, call_574227.host, call_574227.base,
                         call_574227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574227, url, valid)

proc call*(call_574228: Call_SqlServerRegistrationsCreateOrUpdate_574219;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; sqlServerRegistrationName: string): Recallable =
  ## sqlServerRegistrationsCreateOrUpdate
  ## Creates or updates a SQL Server registration.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   parameters: JObject (required)
  ##             : The SQL Server registration to be created or updated.
  ##   sqlServerRegistrationName: string (required)
  ##                            : Name of the SQL Server registration.
  var path_574229 = newJObject()
  var query_574230 = newJObject()
  var body_574231 = newJObject()
  add(path_574229, "resourceGroupName", newJString(resourceGroupName))
  add(query_574230, "api-version", newJString(apiVersion))
  add(path_574229, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574231 = parameters
  add(path_574229, "sqlServerRegistrationName",
      newJString(sqlServerRegistrationName))
  result = call_574228.call(path_574229, query_574230, nil, nil, body_574231)

var sqlServerRegistrationsCreateOrUpdate* = Call_SqlServerRegistrationsCreateOrUpdate_574219(
    name: "sqlServerRegistrationsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureData/sqlServerRegistrations/{sqlServerRegistrationName}",
    validator: validate_SqlServerRegistrationsCreateOrUpdate_574220, base: "",
    url: url_SqlServerRegistrationsCreateOrUpdate_574221, schemes: {Scheme.Https})
type
  Call_SqlServerRegistrationsGet_574208 = ref object of OpenApiRestCall_573657
proc url_SqlServerRegistrationsGet_574210(protocol: Scheme; host: string;
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

proc validate_SqlServerRegistrationsGet_574209(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a SQL Server registration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   sqlServerRegistrationName: JString (required)
  ##                            : Name of the SQL Server registration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574211 = path.getOrDefault("resourceGroupName")
  valid_574211 = validateParameter(valid_574211, JString, required = true,
                                 default = nil)
  if valid_574211 != nil:
    section.add "resourceGroupName", valid_574211
  var valid_574212 = path.getOrDefault("subscriptionId")
  valid_574212 = validateParameter(valid_574212, JString, required = true,
                                 default = nil)
  if valid_574212 != nil:
    section.add "subscriptionId", valid_574212
  var valid_574213 = path.getOrDefault("sqlServerRegistrationName")
  valid_574213 = validateParameter(valid_574213, JString, required = true,
                                 default = nil)
  if valid_574213 != nil:
    section.add "sqlServerRegistrationName", valid_574213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574214 = query.getOrDefault("api-version")
  valid_574214 = validateParameter(valid_574214, JString, required = true,
                                 default = nil)
  if valid_574214 != nil:
    section.add "api-version", valid_574214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574215: Call_SqlServerRegistrationsGet_574208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a SQL Server registration.
  ## 
  let valid = call_574215.validator(path, query, header, formData, body)
  let scheme = call_574215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574215.url(scheme.get, call_574215.host, call_574215.base,
                         call_574215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574215, url, valid)

proc call*(call_574216: Call_SqlServerRegistrationsGet_574208;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          sqlServerRegistrationName: string): Recallable =
  ## sqlServerRegistrationsGet
  ## Gets a SQL Server registration.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   sqlServerRegistrationName: string (required)
  ##                            : Name of the SQL Server registration.
  var path_574217 = newJObject()
  var query_574218 = newJObject()
  add(path_574217, "resourceGroupName", newJString(resourceGroupName))
  add(query_574218, "api-version", newJString(apiVersion))
  add(path_574217, "subscriptionId", newJString(subscriptionId))
  add(path_574217, "sqlServerRegistrationName",
      newJString(sqlServerRegistrationName))
  result = call_574216.call(path_574217, query_574218, nil, nil, nil)

var sqlServerRegistrationsGet* = Call_SqlServerRegistrationsGet_574208(
    name: "sqlServerRegistrationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureData/sqlServerRegistrations/{sqlServerRegistrationName}",
    validator: validate_SqlServerRegistrationsGet_574209, base: "",
    url: url_SqlServerRegistrationsGet_574210, schemes: {Scheme.Https})
type
  Call_SqlServerRegistrationsUpdate_574243 = ref object of OpenApiRestCall_573657
proc url_SqlServerRegistrationsUpdate_574245(protocol: Scheme; host: string;
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

proc validate_SqlServerRegistrationsUpdate_574244(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates SQL Server Registration tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   sqlServerRegistrationName: JString (required)
  ##                            : Name of the SQL Server registration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574246 = path.getOrDefault("resourceGroupName")
  valid_574246 = validateParameter(valid_574246, JString, required = true,
                                 default = nil)
  if valid_574246 != nil:
    section.add "resourceGroupName", valid_574246
  var valid_574247 = path.getOrDefault("subscriptionId")
  valid_574247 = validateParameter(valid_574247, JString, required = true,
                                 default = nil)
  if valid_574247 != nil:
    section.add "subscriptionId", valid_574247
  var valid_574248 = path.getOrDefault("sqlServerRegistrationName")
  valid_574248 = validateParameter(valid_574248, JString, required = true,
                                 default = nil)
  if valid_574248 != nil:
    section.add "sqlServerRegistrationName", valid_574248
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574249 = query.getOrDefault("api-version")
  valid_574249 = validateParameter(valid_574249, JString, required = true,
                                 default = nil)
  if valid_574249 != nil:
    section.add "api-version", valid_574249
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

proc call*(call_574251: Call_SqlServerRegistrationsUpdate_574243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates SQL Server Registration tags.
  ## 
  let valid = call_574251.validator(path, query, header, formData, body)
  let scheme = call_574251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574251.url(scheme.get, call_574251.host, call_574251.base,
                         call_574251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574251, url, valid)

proc call*(call_574252: Call_SqlServerRegistrationsUpdate_574243;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; sqlServerRegistrationName: string): Recallable =
  ## sqlServerRegistrationsUpdate
  ## Updates SQL Server Registration tags.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   parameters: JObject (required)
  ##             : The SQL Server Registration.
  ##   sqlServerRegistrationName: string (required)
  ##                            : Name of the SQL Server registration.
  var path_574253 = newJObject()
  var query_574254 = newJObject()
  var body_574255 = newJObject()
  add(path_574253, "resourceGroupName", newJString(resourceGroupName))
  add(query_574254, "api-version", newJString(apiVersion))
  add(path_574253, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574255 = parameters
  add(path_574253, "sqlServerRegistrationName",
      newJString(sqlServerRegistrationName))
  result = call_574252.call(path_574253, query_574254, nil, nil, body_574255)

var sqlServerRegistrationsUpdate* = Call_SqlServerRegistrationsUpdate_574243(
    name: "sqlServerRegistrationsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureData/sqlServerRegistrations/{sqlServerRegistrationName}",
    validator: validate_SqlServerRegistrationsUpdate_574244, base: "",
    url: url_SqlServerRegistrationsUpdate_574245, schemes: {Scheme.Https})
type
  Call_SqlServerRegistrationsDelete_574232 = ref object of OpenApiRestCall_573657
proc url_SqlServerRegistrationsDelete_574234(protocol: Scheme; host: string;
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

proc validate_SqlServerRegistrationsDelete_574233(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a SQL Server registration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   sqlServerRegistrationName: JString (required)
  ##                            : Name of the SQL Server registration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574235 = path.getOrDefault("resourceGroupName")
  valid_574235 = validateParameter(valid_574235, JString, required = true,
                                 default = nil)
  if valid_574235 != nil:
    section.add "resourceGroupName", valid_574235
  var valid_574236 = path.getOrDefault("subscriptionId")
  valid_574236 = validateParameter(valid_574236, JString, required = true,
                                 default = nil)
  if valid_574236 != nil:
    section.add "subscriptionId", valid_574236
  var valid_574237 = path.getOrDefault("sqlServerRegistrationName")
  valid_574237 = validateParameter(valid_574237, JString, required = true,
                                 default = nil)
  if valid_574237 != nil:
    section.add "sqlServerRegistrationName", valid_574237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574238 = query.getOrDefault("api-version")
  valid_574238 = validateParameter(valid_574238, JString, required = true,
                                 default = nil)
  if valid_574238 != nil:
    section.add "api-version", valid_574238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574239: Call_SqlServerRegistrationsDelete_574232; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a SQL Server registration.
  ## 
  let valid = call_574239.validator(path, query, header, formData, body)
  let scheme = call_574239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574239.url(scheme.get, call_574239.host, call_574239.base,
                         call_574239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574239, url, valid)

proc call*(call_574240: Call_SqlServerRegistrationsDelete_574232;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          sqlServerRegistrationName: string): Recallable =
  ## sqlServerRegistrationsDelete
  ## Deletes a SQL Server registration.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   sqlServerRegistrationName: string (required)
  ##                            : Name of the SQL Server registration.
  var path_574241 = newJObject()
  var query_574242 = newJObject()
  add(path_574241, "resourceGroupName", newJString(resourceGroupName))
  add(query_574242, "api-version", newJString(apiVersion))
  add(path_574241, "subscriptionId", newJString(subscriptionId))
  add(path_574241, "sqlServerRegistrationName",
      newJString(sqlServerRegistrationName))
  result = call_574240.call(path_574241, query_574242, nil, nil, nil)

var sqlServerRegistrationsDelete* = Call_SqlServerRegistrationsDelete_574232(
    name: "sqlServerRegistrationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureData/sqlServerRegistrations/{sqlServerRegistrationName}",
    validator: validate_SqlServerRegistrationsDelete_574233, base: "",
    url: url_SqlServerRegistrationsDelete_574234, schemes: {Scheme.Https})
type
  Call_SqlServersListByResourceGroup_574256 = ref object of OpenApiRestCall_573657
proc url_SqlServersListByResourceGroup_574258(protocol: Scheme; host: string;
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

proc validate_SqlServersListByResourceGroup_574257(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all SQL Servers in a SQL Server Registration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   sqlServerRegistrationName: JString (required)
  ##                            : Name of the SQL Server registration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574260 = path.getOrDefault("resourceGroupName")
  valid_574260 = validateParameter(valid_574260, JString, required = true,
                                 default = nil)
  if valid_574260 != nil:
    section.add "resourceGroupName", valid_574260
  var valid_574261 = path.getOrDefault("subscriptionId")
  valid_574261 = validateParameter(valid_574261, JString, required = true,
                                 default = nil)
  if valid_574261 != nil:
    section.add "subscriptionId", valid_574261
  var valid_574262 = path.getOrDefault("sqlServerRegistrationName")
  valid_574262 = validateParameter(valid_574262, JString, required = true,
                                 default = nil)
  if valid_574262 != nil:
    section.add "sqlServerRegistrationName", valid_574262
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The child resources to include in the response.
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  var valid_574263 = query.getOrDefault("$expand")
  valid_574263 = validateParameter(valid_574263, JString, required = false,
                                 default = nil)
  if valid_574263 != nil:
    section.add "$expand", valid_574263
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574264 = query.getOrDefault("api-version")
  valid_574264 = validateParameter(valid_574264, JString, required = true,
                                 default = nil)
  if valid_574264 != nil:
    section.add "api-version", valid_574264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574265: Call_SqlServersListByResourceGroup_574256; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all SQL Servers in a SQL Server Registration.
  ## 
  let valid = call_574265.validator(path, query, header, formData, body)
  let scheme = call_574265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574265.url(scheme.get, call_574265.host, call_574265.base,
                         call_574265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574265, url, valid)

proc call*(call_574266: Call_SqlServersListByResourceGroup_574256;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          sqlServerRegistrationName: string; Expand: string = ""): Recallable =
  ## sqlServersListByResourceGroup
  ## Gets all SQL Servers in a SQL Server Registration.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   Expand: string
  ##         : The child resources to include in the response.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   sqlServerRegistrationName: string (required)
  ##                            : Name of the SQL Server registration.
  var path_574267 = newJObject()
  var query_574268 = newJObject()
  add(path_574267, "resourceGroupName", newJString(resourceGroupName))
  add(query_574268, "$expand", newJString(Expand))
  add(query_574268, "api-version", newJString(apiVersion))
  add(path_574267, "subscriptionId", newJString(subscriptionId))
  add(path_574267, "sqlServerRegistrationName",
      newJString(sqlServerRegistrationName))
  result = call_574266.call(path_574267, query_574268, nil, nil, nil)

var sqlServersListByResourceGroup* = Call_SqlServersListByResourceGroup_574256(
    name: "sqlServersListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureData/sqlServerRegistrations/{sqlServerRegistrationName}/sqlServers",
    validator: validate_SqlServersListByResourceGroup_574257, base: "",
    url: url_SqlServersListByResourceGroup_574258, schemes: {Scheme.Https})
type
  Call_SqlServersCreateOrUpdate_574282 = ref object of OpenApiRestCall_573657
proc url_SqlServersCreateOrUpdate_574284(protocol: Scheme; host: string;
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

proc validate_SqlServersCreateOrUpdate_574283(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a SQL Server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   sqlServerName: JString (required)
  ##                : Name of the SQL Server.
  ##   sqlServerRegistrationName: JString (required)
  ##                            : Name of the SQL Server registration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574285 = path.getOrDefault("resourceGroupName")
  valid_574285 = validateParameter(valid_574285, JString, required = true,
                                 default = nil)
  if valid_574285 != nil:
    section.add "resourceGroupName", valid_574285
  var valid_574286 = path.getOrDefault("subscriptionId")
  valid_574286 = validateParameter(valid_574286, JString, required = true,
                                 default = nil)
  if valid_574286 != nil:
    section.add "subscriptionId", valid_574286
  var valid_574287 = path.getOrDefault("sqlServerName")
  valid_574287 = validateParameter(valid_574287, JString, required = true,
                                 default = nil)
  if valid_574287 != nil:
    section.add "sqlServerName", valid_574287
  var valid_574288 = path.getOrDefault("sqlServerRegistrationName")
  valid_574288 = validateParameter(valid_574288, JString, required = true,
                                 default = nil)
  if valid_574288 != nil:
    section.add "sqlServerRegistrationName", valid_574288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574289 = query.getOrDefault("api-version")
  valid_574289 = validateParameter(valid_574289, JString, required = true,
                                 default = nil)
  if valid_574289 != nil:
    section.add "api-version", valid_574289
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

proc call*(call_574291: Call_SqlServersCreateOrUpdate_574282; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a SQL Server.
  ## 
  let valid = call_574291.validator(path, query, header, formData, body)
  let scheme = call_574291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574291.url(scheme.get, call_574291.host, call_574291.base,
                         call_574291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574291, url, valid)

proc call*(call_574292: Call_SqlServersCreateOrUpdate_574282;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          sqlServerName: string; parameters: JsonNode;
          sqlServerRegistrationName: string): Recallable =
  ## sqlServersCreateOrUpdate
  ## Creates or updates a SQL Server.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   sqlServerName: string (required)
  ##                : Name of the SQL Server.
  ##   parameters: JObject (required)
  ##             : The SQL Server to be created or updated.
  ##   sqlServerRegistrationName: string (required)
  ##                            : Name of the SQL Server registration.
  var path_574293 = newJObject()
  var query_574294 = newJObject()
  var body_574295 = newJObject()
  add(path_574293, "resourceGroupName", newJString(resourceGroupName))
  add(query_574294, "api-version", newJString(apiVersion))
  add(path_574293, "subscriptionId", newJString(subscriptionId))
  add(path_574293, "sqlServerName", newJString(sqlServerName))
  if parameters != nil:
    body_574295 = parameters
  add(path_574293, "sqlServerRegistrationName",
      newJString(sqlServerRegistrationName))
  result = call_574292.call(path_574293, query_574294, nil, nil, body_574295)

var sqlServersCreateOrUpdate* = Call_SqlServersCreateOrUpdate_574282(
    name: "sqlServersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureData/sqlServerRegistrations/{sqlServerRegistrationName}/sqlServers/{sqlServerName}",
    validator: validate_SqlServersCreateOrUpdate_574283, base: "",
    url: url_SqlServersCreateOrUpdate_574284, schemes: {Scheme.Https})
type
  Call_SqlServersGet_574269 = ref object of OpenApiRestCall_573657
proc url_SqlServersGet_574271(protocol: Scheme; host: string; base: string;
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

proc validate_SqlServersGet_574270(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a SQL Server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   sqlServerName: JString (required)
  ##                : Name of the SQL Server.
  ##   sqlServerRegistrationName: JString (required)
  ##                            : Name of the SQL Server registration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574272 = path.getOrDefault("resourceGroupName")
  valid_574272 = validateParameter(valid_574272, JString, required = true,
                                 default = nil)
  if valid_574272 != nil:
    section.add "resourceGroupName", valid_574272
  var valid_574273 = path.getOrDefault("subscriptionId")
  valid_574273 = validateParameter(valid_574273, JString, required = true,
                                 default = nil)
  if valid_574273 != nil:
    section.add "subscriptionId", valid_574273
  var valid_574274 = path.getOrDefault("sqlServerName")
  valid_574274 = validateParameter(valid_574274, JString, required = true,
                                 default = nil)
  if valid_574274 != nil:
    section.add "sqlServerName", valid_574274
  var valid_574275 = path.getOrDefault("sqlServerRegistrationName")
  valid_574275 = validateParameter(valid_574275, JString, required = true,
                                 default = nil)
  if valid_574275 != nil:
    section.add "sqlServerRegistrationName", valid_574275
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The child resources to include in the response.
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  var valid_574276 = query.getOrDefault("$expand")
  valid_574276 = validateParameter(valid_574276, JString, required = false,
                                 default = nil)
  if valid_574276 != nil:
    section.add "$expand", valid_574276
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574277 = query.getOrDefault("api-version")
  valid_574277 = validateParameter(valid_574277, JString, required = true,
                                 default = nil)
  if valid_574277 != nil:
    section.add "api-version", valid_574277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574278: Call_SqlServersGet_574269; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a SQL Server.
  ## 
  let valid = call_574278.validator(path, query, header, formData, body)
  let scheme = call_574278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574278.url(scheme.get, call_574278.host, call_574278.base,
                         call_574278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574278, url, valid)

proc call*(call_574279: Call_SqlServersGet_574269; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; sqlServerName: string;
          sqlServerRegistrationName: string; Expand: string = ""): Recallable =
  ## sqlServersGet
  ## Gets a SQL Server.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   Expand: string
  ##         : The child resources to include in the response.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   sqlServerName: string (required)
  ##                : Name of the SQL Server.
  ##   sqlServerRegistrationName: string (required)
  ##                            : Name of the SQL Server registration.
  var path_574280 = newJObject()
  var query_574281 = newJObject()
  add(path_574280, "resourceGroupName", newJString(resourceGroupName))
  add(query_574281, "$expand", newJString(Expand))
  add(query_574281, "api-version", newJString(apiVersion))
  add(path_574280, "subscriptionId", newJString(subscriptionId))
  add(path_574280, "sqlServerName", newJString(sqlServerName))
  add(path_574280, "sqlServerRegistrationName",
      newJString(sqlServerRegistrationName))
  result = call_574279.call(path_574280, query_574281, nil, nil, nil)

var sqlServersGet* = Call_SqlServersGet_574269(name: "sqlServersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureData/sqlServerRegistrations/{sqlServerRegistrationName}/sqlServers/{sqlServerName}",
    validator: validate_SqlServersGet_574270, base: "", url: url_SqlServersGet_574271,
    schemes: {Scheme.Https})
type
  Call_SqlServersDelete_574296 = ref object of OpenApiRestCall_573657
proc url_SqlServersDelete_574298(protocol: Scheme; host: string; base: string;
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

proc validate_SqlServersDelete_574297(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes a SQL Server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   sqlServerName: JString (required)
  ##                : Name of the SQL Server.
  ##   sqlServerRegistrationName: JString (required)
  ##                            : Name of the SQL Server registration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574299 = path.getOrDefault("resourceGroupName")
  valid_574299 = validateParameter(valid_574299, JString, required = true,
                                 default = nil)
  if valid_574299 != nil:
    section.add "resourceGroupName", valid_574299
  var valid_574300 = path.getOrDefault("subscriptionId")
  valid_574300 = validateParameter(valid_574300, JString, required = true,
                                 default = nil)
  if valid_574300 != nil:
    section.add "subscriptionId", valid_574300
  var valid_574301 = path.getOrDefault("sqlServerName")
  valid_574301 = validateParameter(valid_574301, JString, required = true,
                                 default = nil)
  if valid_574301 != nil:
    section.add "sqlServerName", valid_574301
  var valid_574302 = path.getOrDefault("sqlServerRegistrationName")
  valid_574302 = validateParameter(valid_574302, JString, required = true,
                                 default = nil)
  if valid_574302 != nil:
    section.add "sqlServerRegistrationName", valid_574302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574303 = query.getOrDefault("api-version")
  valid_574303 = validateParameter(valid_574303, JString, required = true,
                                 default = nil)
  if valid_574303 != nil:
    section.add "api-version", valid_574303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574304: Call_SqlServersDelete_574296; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a SQL Server.
  ## 
  let valid = call_574304.validator(path, query, header, formData, body)
  let scheme = call_574304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574304.url(scheme.get, call_574304.host, call_574304.base,
                         call_574304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574304, url, valid)

proc call*(call_574305: Call_SqlServersDelete_574296; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; sqlServerName: string;
          sqlServerRegistrationName: string): Recallable =
  ## sqlServersDelete
  ## Deletes a SQL Server.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   sqlServerName: string (required)
  ##                : Name of the SQL Server.
  ##   sqlServerRegistrationName: string (required)
  ##                            : Name of the SQL Server registration.
  var path_574306 = newJObject()
  var query_574307 = newJObject()
  add(path_574306, "resourceGroupName", newJString(resourceGroupName))
  add(query_574307, "api-version", newJString(apiVersion))
  add(path_574306, "subscriptionId", newJString(subscriptionId))
  add(path_574306, "sqlServerName", newJString(sqlServerName))
  add(path_574306, "sqlServerRegistrationName",
      newJString(sqlServerRegistrationName))
  result = call_574305.call(path_574306, query_574307, nil, nil, nil)

var sqlServersDelete* = Call_SqlServersDelete_574296(name: "sqlServersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureData/sqlServerRegistrations/{sqlServerRegistrationName}/sqlServers/{sqlServerName}",
    validator: validate_SqlServersDelete_574297, base: "",
    url: url_SqlServersDelete_574298, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
