
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567641): Option[Scheme] {.used.} =
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
  macServiceName = "sql-ManagedInstanceKeys"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ManagedInstanceKeysListByInstance_567863 = ref object of OpenApiRestCall_567641
proc url_ManagedInstanceKeysListByInstance_567865(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/keys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedInstanceKeysListByInstance_567864(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of managed instance keys.
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
  var valid_568039 = path.getOrDefault("resourceGroupName")
  valid_568039 = validateParameter(valid_568039, JString, required = true,
                                 default = nil)
  if valid_568039 != nil:
    section.add "resourceGroupName", valid_568039
  var valid_568040 = path.getOrDefault("managedInstanceName")
  valid_568040 = validateParameter(valid_568040, JString, required = true,
                                 default = nil)
  if valid_568040 != nil:
    section.add "managedInstanceName", valid_568040
  var valid_568041 = path.getOrDefault("subscriptionId")
  valid_568041 = validateParameter(valid_568041, JString, required = true,
                                 default = nil)
  if valid_568041 != nil:
    section.add "subscriptionId", valid_568041
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   $filter: JString
  ##          : An OData filter expression that filters elements in the collection.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568042 = query.getOrDefault("api-version")
  valid_568042 = validateParameter(valid_568042, JString, required = true,
                                 default = nil)
  if valid_568042 != nil:
    section.add "api-version", valid_568042
  var valid_568043 = query.getOrDefault("$filter")
  valid_568043 = validateParameter(valid_568043, JString, required = false,
                                 default = nil)
  if valid_568043 != nil:
    section.add "$filter", valid_568043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568066: Call_ManagedInstanceKeysListByInstance_567863;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of managed instance keys.
  ## 
  let valid = call_568066.validator(path, query, header, formData, body)
  let scheme = call_568066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568066.url(scheme.get, call_568066.host, call_568066.base,
                         call_568066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568066, url, valid)

proc call*(call_568137: Call_ManagedInstanceKeysListByInstance_567863;
          resourceGroupName: string; apiVersion: string;
          managedInstanceName: string; subscriptionId: string; Filter: string = ""): Recallable =
  ## managedInstanceKeysListByInstance
  ## Gets a list of managed instance keys.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   Filter: string
  ##         : An OData filter expression that filters elements in the collection.
  var path_568138 = newJObject()
  var query_568140 = newJObject()
  add(path_568138, "resourceGroupName", newJString(resourceGroupName))
  add(query_568140, "api-version", newJString(apiVersion))
  add(path_568138, "managedInstanceName", newJString(managedInstanceName))
  add(path_568138, "subscriptionId", newJString(subscriptionId))
  add(query_568140, "$filter", newJString(Filter))
  result = call_568137.call(path_568138, query_568140, nil, nil, nil)

var managedInstanceKeysListByInstance* = Call_ManagedInstanceKeysListByInstance_567863(
    name: "managedInstanceKeysListByInstance", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/keys",
    validator: validate_ManagedInstanceKeysListByInstance_567864, base: "",
    url: url_ManagedInstanceKeysListByInstance_567865, schemes: {Scheme.Https})
type
  Call_ManagedInstanceKeysCreateOrUpdate_568191 = ref object of OpenApiRestCall_567641
proc url_ManagedInstanceKeysCreateOrUpdate_568193(protocol: Scheme; host: string;
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
  assert "keyName" in path, "`keyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/managedInstances/"),
               (kind: VariableSegment, value: "managedInstanceName"),
               (kind: ConstantSegment, value: "/keys/"),
               (kind: VariableSegment, value: "keyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedInstanceKeysCreateOrUpdate_568192(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a managed instance key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  ##   keyName: JString (required)
  ##          : The name of the managed instance key to be operated on (updated or created).
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568194 = path.getOrDefault("resourceGroupName")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "resourceGroupName", valid_568194
  var valid_568195 = path.getOrDefault("managedInstanceName")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "managedInstanceName", valid_568195
  var valid_568196 = path.getOrDefault("keyName")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "keyName", valid_568196
  var valid_568197 = path.getOrDefault("subscriptionId")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "subscriptionId", valid_568197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568198 = query.getOrDefault("api-version")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "api-version", valid_568198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The requested managed instance key resource state.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568200: Call_ManagedInstanceKeysCreateOrUpdate_568191;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a managed instance key.
  ## 
  let valid = call_568200.validator(path, query, header, formData, body)
  let scheme = call_568200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568200.url(scheme.get, call_568200.host, call_568200.base,
                         call_568200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568200, url, valid)

proc call*(call_568201: Call_ManagedInstanceKeysCreateOrUpdate_568191;
          resourceGroupName: string; apiVersion: string;
          managedInstanceName: string; keyName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## managedInstanceKeysCreateOrUpdate
  ## Creates or updates a managed instance key.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  ##   keyName: string (required)
  ##          : The name of the managed instance key to be operated on (updated or created).
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   parameters: JObject (required)
  ##             : The requested managed instance key resource state.
  var path_568202 = newJObject()
  var query_568203 = newJObject()
  var body_568204 = newJObject()
  add(path_568202, "resourceGroupName", newJString(resourceGroupName))
  add(query_568203, "api-version", newJString(apiVersion))
  add(path_568202, "managedInstanceName", newJString(managedInstanceName))
  add(path_568202, "keyName", newJString(keyName))
  add(path_568202, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568204 = parameters
  result = call_568201.call(path_568202, query_568203, nil, nil, body_568204)

var managedInstanceKeysCreateOrUpdate* = Call_ManagedInstanceKeysCreateOrUpdate_568191(
    name: "managedInstanceKeysCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/keys/{keyName}",
    validator: validate_ManagedInstanceKeysCreateOrUpdate_568192, base: "",
    url: url_ManagedInstanceKeysCreateOrUpdate_568193, schemes: {Scheme.Https})
type
  Call_ManagedInstanceKeysGet_568179 = ref object of OpenApiRestCall_567641
proc url_ManagedInstanceKeysGet_568181(protocol: Scheme; host: string; base: string;
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
  assert "keyName" in path, "`keyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/managedInstances/"),
               (kind: VariableSegment, value: "managedInstanceName"),
               (kind: ConstantSegment, value: "/keys/"),
               (kind: VariableSegment, value: "keyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedInstanceKeysGet_568180(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a managed instance key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  ##   keyName: JString (required)
  ##          : The name of the managed instance key to be retrieved.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568182 = path.getOrDefault("resourceGroupName")
  valid_568182 = validateParameter(valid_568182, JString, required = true,
                                 default = nil)
  if valid_568182 != nil:
    section.add "resourceGroupName", valid_568182
  var valid_568183 = path.getOrDefault("managedInstanceName")
  valid_568183 = validateParameter(valid_568183, JString, required = true,
                                 default = nil)
  if valid_568183 != nil:
    section.add "managedInstanceName", valid_568183
  var valid_568184 = path.getOrDefault("keyName")
  valid_568184 = validateParameter(valid_568184, JString, required = true,
                                 default = nil)
  if valid_568184 != nil:
    section.add "keyName", valid_568184
  var valid_568185 = path.getOrDefault("subscriptionId")
  valid_568185 = validateParameter(valid_568185, JString, required = true,
                                 default = nil)
  if valid_568185 != nil:
    section.add "subscriptionId", valid_568185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568186 = query.getOrDefault("api-version")
  valid_568186 = validateParameter(valid_568186, JString, required = true,
                                 default = nil)
  if valid_568186 != nil:
    section.add "api-version", valid_568186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568187: Call_ManagedInstanceKeysGet_568179; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a managed instance key.
  ## 
  let valid = call_568187.validator(path, query, header, formData, body)
  let scheme = call_568187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568187.url(scheme.get, call_568187.host, call_568187.base,
                         call_568187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568187, url, valid)

proc call*(call_568188: Call_ManagedInstanceKeysGet_568179;
          resourceGroupName: string; apiVersion: string;
          managedInstanceName: string; keyName: string; subscriptionId: string): Recallable =
  ## managedInstanceKeysGet
  ## Gets a managed instance key.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  ##   keyName: string (required)
  ##          : The name of the managed instance key to be retrieved.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568189 = newJObject()
  var query_568190 = newJObject()
  add(path_568189, "resourceGroupName", newJString(resourceGroupName))
  add(query_568190, "api-version", newJString(apiVersion))
  add(path_568189, "managedInstanceName", newJString(managedInstanceName))
  add(path_568189, "keyName", newJString(keyName))
  add(path_568189, "subscriptionId", newJString(subscriptionId))
  result = call_568188.call(path_568189, query_568190, nil, nil, nil)

var managedInstanceKeysGet* = Call_ManagedInstanceKeysGet_568179(
    name: "managedInstanceKeysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/keys/{keyName}",
    validator: validate_ManagedInstanceKeysGet_568180, base: "",
    url: url_ManagedInstanceKeysGet_568181, schemes: {Scheme.Https})
type
  Call_ManagedInstanceKeysDelete_568205 = ref object of OpenApiRestCall_567641
proc url_ManagedInstanceKeysDelete_568207(protocol: Scheme; host: string;
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
  assert "keyName" in path, "`keyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/managedInstances/"),
               (kind: VariableSegment, value: "managedInstanceName"),
               (kind: ConstantSegment, value: "/keys/"),
               (kind: VariableSegment, value: "keyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedInstanceKeysDelete_568206(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the managed instance key with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  ##   keyName: JString (required)
  ##          : The name of the managed instance key to be deleted.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568208 = path.getOrDefault("resourceGroupName")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "resourceGroupName", valid_568208
  var valid_568209 = path.getOrDefault("managedInstanceName")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "managedInstanceName", valid_568209
  var valid_568210 = path.getOrDefault("keyName")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "keyName", valid_568210
  var valid_568211 = path.getOrDefault("subscriptionId")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "subscriptionId", valid_568211
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568212 = query.getOrDefault("api-version")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "api-version", valid_568212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568213: Call_ManagedInstanceKeysDelete_568205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the managed instance key with the given name.
  ## 
  let valid = call_568213.validator(path, query, header, formData, body)
  let scheme = call_568213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568213.url(scheme.get, call_568213.host, call_568213.base,
                         call_568213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568213, url, valid)

proc call*(call_568214: Call_ManagedInstanceKeysDelete_568205;
          resourceGroupName: string; apiVersion: string;
          managedInstanceName: string; keyName: string; subscriptionId: string): Recallable =
  ## managedInstanceKeysDelete
  ## Deletes the managed instance key with the given name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  ##   keyName: string (required)
  ##          : The name of the managed instance key to be deleted.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_568215 = newJObject()
  var query_568216 = newJObject()
  add(path_568215, "resourceGroupName", newJString(resourceGroupName))
  add(query_568216, "api-version", newJString(apiVersion))
  add(path_568215, "managedInstanceName", newJString(managedInstanceName))
  add(path_568215, "keyName", newJString(keyName))
  add(path_568215, "subscriptionId", newJString(subscriptionId))
  result = call_568214.call(path_568215, query_568216, nil, nil, nil)

var managedInstanceKeysDelete* = Call_ManagedInstanceKeysDelete_568205(
    name: "managedInstanceKeysDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/keys/{keyName}",
    validator: validate_ManagedInstanceKeysDelete_568206, base: "",
    url: url_ManagedInstanceKeysDelete_568207, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
