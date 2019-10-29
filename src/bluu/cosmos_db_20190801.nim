
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Cosmos DB
## version: 2019-08-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Cosmos DB Database Service Resource Provider REST API
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

  OpenApiRestCall_563566 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563566](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563566): Option[Scheme] {.used.} =
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
  macServiceName = "cosmos-db"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DatabaseAccountsCheckNameExists_563788 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsCheckNameExists_563790(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.DocumentDB/databaseAccountNames/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsCheckNameExists_563789(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks that the Azure Cosmos DB account name already exists. A valid account name may contain only lowercase letters, numbers, and the '-' character, and must be between 3 and 50 characters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `accountName` field"
  var valid_563965 = path.getOrDefault("accountName")
  valid_563965 = validateParameter(valid_563965, JString, required = true,
                                 default = nil)
  if valid_563965 != nil:
    section.add "accountName", valid_563965
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563966 = query.getOrDefault("api-version")
  valid_563966 = validateParameter(valid_563966, JString, required = true,
                                 default = nil)
  if valid_563966 != nil:
    section.add "api-version", valid_563966
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563989: Call_DatabaseAccountsCheckNameExists_563788;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks that the Azure Cosmos DB account name already exists. A valid account name may contain only lowercase letters, numbers, and the '-' character, and must be between 3 and 50 characters.
  ## 
  let valid = call_563989.validator(path, query, header, formData, body)
  let scheme = call_563989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563989.url(scheme.get, call_563989.host, call_563989.base,
                         call_563989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563989, url, valid)

proc call*(call_564060: Call_DatabaseAccountsCheckNameExists_563788;
          apiVersion: string; accountName: string): Recallable =
  ## databaseAccountsCheckNameExists
  ## Checks that the Azure Cosmos DB account name already exists. A valid account name may contain only lowercase letters, numbers, and the '-' character, and must be between 3 and 50 characters.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564061 = newJObject()
  var query_564063 = newJObject()
  add(query_564063, "api-version", newJString(apiVersion))
  add(path_564061, "accountName", newJString(accountName))
  result = call_564060.call(path_564061, query_564063, nil, nil, nil)

var databaseAccountsCheckNameExists* = Call_DatabaseAccountsCheckNameExists_563788(
    name: "databaseAccountsCheckNameExists", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/providers/Microsoft.DocumentDB/databaseAccountNames/{accountName}",
    validator: validate_DatabaseAccountsCheckNameExists_563789, base: "",
    url: url_DatabaseAccountsCheckNameExists_563790, schemes: {Scheme.Https})
type
  Call_OperationsList_564102 = ref object of OpenApiRestCall_563566
proc url_OperationsList_564104(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_564103(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Cosmos DB Resource Provider operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564105 = query.getOrDefault("api-version")
  valid_564105 = validateParameter(valid_564105, JString, required = true,
                                 default = nil)
  if valid_564105 != nil:
    section.add "api-version", valid_564105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564106: Call_OperationsList_564102; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Cosmos DB Resource Provider operations.
  ## 
  let valid = call_564106.validator(path, query, header, formData, body)
  let scheme = call_564106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564106.url(scheme.get, call_564106.host, call_564106.base,
                         call_564106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564106, url, valid)

proc call*(call_564107: Call_OperationsList_564102; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Cosmos DB Resource Provider operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  var query_564108 = newJObject()
  add(query_564108, "api-version", newJString(apiVersion))
  result = call_564107.call(nil, query_564108, nil, nil, nil)

var operationsList* = Call_OperationsList_564102(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DocumentDB/operations",
    validator: validate_OperationsList_564103, base: "", url: url_OperationsList_564104,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsList_564109 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsList_564111(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsList_564110(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the Azure Cosmos DB database accounts available under the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564112 = path.getOrDefault("subscriptionId")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "subscriptionId", valid_564112
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564113 = query.getOrDefault("api-version")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "api-version", valid_564113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564114: Call_DatabaseAccountsList_564109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the Azure Cosmos DB database accounts available under the subscription.
  ## 
  let valid = call_564114.validator(path, query, header, formData, body)
  let scheme = call_564114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564114.url(scheme.get, call_564114.host, call_564114.base,
                         call_564114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564114, url, valid)

proc call*(call_564115: Call_DatabaseAccountsList_564109; apiVersion: string;
          subscriptionId: string): Recallable =
  ## databaseAccountsList
  ## Lists all the Azure Cosmos DB database accounts available under the subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  var path_564116 = newJObject()
  var query_564117 = newJObject()
  add(query_564117, "api-version", newJString(apiVersion))
  add(path_564116, "subscriptionId", newJString(subscriptionId))
  result = call_564115.call(path_564116, query_564117, nil, nil, nil)

var databaseAccountsList* = Call_DatabaseAccountsList_564109(
    name: "databaseAccountsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DocumentDB/databaseAccounts",
    validator: validate_DatabaseAccountsList_564110, base: "",
    url: url_DatabaseAccountsList_564111, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListByResourceGroup_564118 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsListByResourceGroup_564120(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.DocumentDB/databaseAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsListByResourceGroup_564119(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the Azure Cosmos DB database accounts available under the given resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564121 = path.getOrDefault("subscriptionId")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "subscriptionId", valid_564121
  var valid_564122 = path.getOrDefault("resourceGroupName")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "resourceGroupName", valid_564122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
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

proc call*(call_564124: Call_DatabaseAccountsListByResourceGroup_564118;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the Azure Cosmos DB database accounts available under the given resource group.
  ## 
  let valid = call_564124.validator(path, query, header, formData, body)
  let scheme = call_564124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564124.url(scheme.get, call_564124.host, call_564124.base,
                         call_564124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564124, url, valid)

proc call*(call_564125: Call_DatabaseAccountsListByResourceGroup_564118;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## databaseAccountsListByResourceGroup
  ## Lists all the Azure Cosmos DB database accounts available under the given resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  var path_564126 = newJObject()
  var query_564127 = newJObject()
  add(query_564127, "api-version", newJString(apiVersion))
  add(path_564126, "subscriptionId", newJString(subscriptionId))
  add(path_564126, "resourceGroupName", newJString(resourceGroupName))
  result = call_564125.call(path_564126, query_564127, nil, nil, nil)

var databaseAccountsListByResourceGroup* = Call_DatabaseAccountsListByResourceGroup_564118(
    name: "databaseAccountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts",
    validator: validate_DatabaseAccountsListByResourceGroup_564119, base: "",
    url: url_DatabaseAccountsListByResourceGroup_564120, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateOrUpdate_564139 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsCreateOrUpdate_564141(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsCreateOrUpdate_564140(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564142 = path.getOrDefault("subscriptionId")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "subscriptionId", valid_564142
  var valid_564143 = path.getOrDefault("resourceGroupName")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "resourceGroupName", valid_564143
  var valid_564144 = path.getOrDefault("accountName")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "accountName", valid_564144
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564145 = query.getOrDefault("api-version")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "api-version", valid_564145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   createUpdateParameters: JObject (required)
  ##                         : The parameters to provide for the current database account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564147: Call_DatabaseAccountsCreateOrUpdate_564139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an Azure Cosmos DB database account.
  ## 
  let valid = call_564147.validator(path, query, header, formData, body)
  let scheme = call_564147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564147.url(scheme.get, call_564147.host, call_564147.base,
                         call_564147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564147, url, valid)

proc call*(call_564148: Call_DatabaseAccountsCreateOrUpdate_564139;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          createUpdateParameters: JsonNode; accountName: string): Recallable =
  ## databaseAccountsCreateOrUpdate
  ## Creates or updates an Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   createUpdateParameters: JObject (required)
  ##                         : The parameters to provide for the current database account.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564149 = newJObject()
  var query_564150 = newJObject()
  var body_564151 = newJObject()
  add(query_564150, "api-version", newJString(apiVersion))
  add(path_564149, "subscriptionId", newJString(subscriptionId))
  add(path_564149, "resourceGroupName", newJString(resourceGroupName))
  if createUpdateParameters != nil:
    body_564151 = createUpdateParameters
  add(path_564149, "accountName", newJString(accountName))
  result = call_564148.call(path_564149, query_564150, nil, nil, body_564151)

var databaseAccountsCreateOrUpdate* = Call_DatabaseAccountsCreateOrUpdate_564139(
    name: "databaseAccountsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}",
    validator: validate_DatabaseAccountsCreateOrUpdate_564140, base: "",
    url: url_DatabaseAccountsCreateOrUpdate_564141, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGet_564128 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsGet_564130(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsGet_564129(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves the properties of an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564131 = path.getOrDefault("subscriptionId")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "subscriptionId", valid_564131
  var valid_564132 = path.getOrDefault("resourceGroupName")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "resourceGroupName", valid_564132
  var valid_564133 = path.getOrDefault("accountName")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "accountName", valid_564133
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564134 = query.getOrDefault("api-version")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "api-version", valid_564134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564135: Call_DatabaseAccountsGet_564128; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the properties of an existing Azure Cosmos DB database account.
  ## 
  let valid = call_564135.validator(path, query, header, formData, body)
  let scheme = call_564135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564135.url(scheme.get, call_564135.host, call_564135.base,
                         call_564135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564135, url, valid)

proc call*(call_564136: Call_DatabaseAccountsGet_564128; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsGet
  ## Retrieves the properties of an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564137 = newJObject()
  var query_564138 = newJObject()
  add(query_564138, "api-version", newJString(apiVersion))
  add(path_564137, "subscriptionId", newJString(subscriptionId))
  add(path_564137, "resourceGroupName", newJString(resourceGroupName))
  add(path_564137, "accountName", newJString(accountName))
  result = call_564136.call(path_564137, query_564138, nil, nil, nil)

var databaseAccountsGet* = Call_DatabaseAccountsGet_564128(
    name: "databaseAccountsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}",
    validator: validate_DatabaseAccountsGet_564129, base: "",
    url: url_DatabaseAccountsGet_564130, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsPatch_564163 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsPatch_564165(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsPatch_564164(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patches the properties of an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564166 = path.getOrDefault("subscriptionId")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "subscriptionId", valid_564166
  var valid_564167 = path.getOrDefault("resourceGroupName")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "resourceGroupName", valid_564167
  var valid_564168 = path.getOrDefault("accountName")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "accountName", valid_564168
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564169 = query.getOrDefault("api-version")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "api-version", valid_564169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   updateParameters: JObject (required)
  ##                   : The tags parameter to patch for the current database account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564171: Call_DatabaseAccountsPatch_564163; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patches the properties of an existing Azure Cosmos DB database account.
  ## 
  let valid = call_564171.validator(path, query, header, formData, body)
  let scheme = call_564171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564171.url(scheme.get, call_564171.host, call_564171.base,
                         call_564171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564171, url, valid)

proc call*(call_564172: Call_DatabaseAccountsPatch_564163; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          updateParameters: JsonNode; accountName: string): Recallable =
  ## databaseAccountsPatch
  ## Patches the properties of an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   updateParameters: JObject (required)
  ##                   : The tags parameter to patch for the current database account.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564173 = newJObject()
  var query_564174 = newJObject()
  var body_564175 = newJObject()
  add(query_564174, "api-version", newJString(apiVersion))
  add(path_564173, "subscriptionId", newJString(subscriptionId))
  add(path_564173, "resourceGroupName", newJString(resourceGroupName))
  if updateParameters != nil:
    body_564175 = updateParameters
  add(path_564173, "accountName", newJString(accountName))
  result = call_564172.call(path_564173, query_564174, nil, nil, body_564175)

var databaseAccountsPatch* = Call_DatabaseAccountsPatch_564163(
    name: "databaseAccountsPatch", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}",
    validator: validate_DatabaseAccountsPatch_564164, base: "",
    url: url_DatabaseAccountsPatch_564165, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDelete_564152 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsDelete_564154(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsDelete_564153(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564155 = path.getOrDefault("subscriptionId")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "subscriptionId", valid_564155
  var valid_564156 = path.getOrDefault("resourceGroupName")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "resourceGroupName", valid_564156
  var valid_564157 = path.getOrDefault("accountName")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "accountName", valid_564157
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564158 = query.getOrDefault("api-version")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "api-version", valid_564158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564159: Call_DatabaseAccountsDelete_564152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB database account.
  ## 
  let valid = call_564159.validator(path, query, header, formData, body)
  let scheme = call_564159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564159.url(scheme.get, call_564159.host, call_564159.base,
                         call_564159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564159, url, valid)

proc call*(call_564160: Call_DatabaseAccountsDelete_564152; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsDelete
  ## Deletes an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564161 = newJObject()
  var query_564162 = newJObject()
  add(query_564162, "api-version", newJString(apiVersion))
  add(path_564161, "subscriptionId", newJString(subscriptionId))
  add(path_564161, "resourceGroupName", newJString(resourceGroupName))
  add(path_564161, "accountName", newJString(accountName))
  result = call_564160.call(path_564161, query_564162, nil, nil, nil)

var databaseAccountsDelete* = Call_DatabaseAccountsDelete_564152(
    name: "databaseAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}",
    validator: validate_DatabaseAccountsDelete_564153, base: "",
    url: url_DatabaseAccountsDelete_564154, schemes: {Scheme.Https})
type
  Call_CassandraResourcesListCassandraKeyspaces_564176 = ref object of OpenApiRestCall_563566
proc url_CassandraResourcesListCassandraKeyspaces_564178(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/cassandraKeyspaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CassandraResourcesListCassandraKeyspaces_564177(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Cassandra keyspaces under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564179 = path.getOrDefault("subscriptionId")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "subscriptionId", valid_564179
  var valid_564180 = path.getOrDefault("resourceGroupName")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "resourceGroupName", valid_564180
  var valid_564181 = path.getOrDefault("accountName")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "accountName", valid_564181
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564182 = query.getOrDefault("api-version")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "api-version", valid_564182
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564183: Call_CassandraResourcesListCassandraKeyspaces_564176;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Cassandra keyspaces under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_564183.validator(path, query, header, formData, body)
  let scheme = call_564183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564183.url(scheme.get, call_564183.host, call_564183.base,
                         call_564183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564183, url, valid)

proc call*(call_564184: Call_CassandraResourcesListCassandraKeyspaces_564176;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## cassandraResourcesListCassandraKeyspaces
  ## Lists the Cassandra keyspaces under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564185 = newJObject()
  var query_564186 = newJObject()
  add(query_564186, "api-version", newJString(apiVersion))
  add(path_564185, "subscriptionId", newJString(subscriptionId))
  add(path_564185, "resourceGroupName", newJString(resourceGroupName))
  add(path_564185, "accountName", newJString(accountName))
  result = call_564184.call(path_564185, query_564186, nil, nil, nil)

var cassandraResourcesListCassandraKeyspaces* = Call_CassandraResourcesListCassandraKeyspaces_564176(
    name: "cassandraResourcesListCassandraKeyspaces", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/cassandraKeyspaces",
    validator: validate_CassandraResourcesListCassandraKeyspaces_564177, base: "",
    url: url_CassandraResourcesListCassandraKeyspaces_564178,
    schemes: {Scheme.Https})
type
  Call_CassandraResourcesCreateUpdateCassandraKeyspace_564199 = ref object of OpenApiRestCall_563566
proc url_CassandraResourcesCreateUpdateCassandraKeyspace_564201(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "keyspaceName" in path, "`keyspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/cassandraKeyspaces/"),
               (kind: VariableSegment, value: "keyspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CassandraResourcesCreateUpdateCassandraKeyspace_564200(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Create or update an Azure Cosmos DB Cassandra keyspace
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   keyspaceName: JString (required)
  ##               : Cosmos DB keyspace name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564202 = path.getOrDefault("subscriptionId")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "subscriptionId", valid_564202
  var valid_564203 = path.getOrDefault("resourceGroupName")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "resourceGroupName", valid_564203
  var valid_564204 = path.getOrDefault("keyspaceName")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = nil)
  if valid_564204 != nil:
    section.add "keyspaceName", valid_564204
  var valid_564205 = path.getOrDefault("accountName")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "accountName", valid_564205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564206 = query.getOrDefault("api-version")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "api-version", valid_564206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   createUpdateCassandraKeyspaceParameters: JObject (required)
  ##                                          : The parameters to provide for the current Cassandra keyspace.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564208: Call_CassandraResourcesCreateUpdateCassandraKeyspace_564199;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB Cassandra keyspace
  ## 
  let valid = call_564208.validator(path, query, header, formData, body)
  let scheme = call_564208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564208.url(scheme.get, call_564208.host, call_564208.base,
                         call_564208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564208, url, valid)

proc call*(call_564209: Call_CassandraResourcesCreateUpdateCassandraKeyspace_564199;
          apiVersion: string; createUpdateCassandraKeyspaceParameters: JsonNode;
          subscriptionId: string; resourceGroupName: string; keyspaceName: string;
          accountName: string): Recallable =
  ## cassandraResourcesCreateUpdateCassandraKeyspace
  ## Create or update an Azure Cosmos DB Cassandra keyspace
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   createUpdateCassandraKeyspaceParameters: JObject (required)
  ##                                          : The parameters to provide for the current Cassandra keyspace.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   keyspaceName: string (required)
  ##               : Cosmos DB keyspace name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564210 = newJObject()
  var query_564211 = newJObject()
  var body_564212 = newJObject()
  add(query_564211, "api-version", newJString(apiVersion))
  if createUpdateCassandraKeyspaceParameters != nil:
    body_564212 = createUpdateCassandraKeyspaceParameters
  add(path_564210, "subscriptionId", newJString(subscriptionId))
  add(path_564210, "resourceGroupName", newJString(resourceGroupName))
  add(path_564210, "keyspaceName", newJString(keyspaceName))
  add(path_564210, "accountName", newJString(accountName))
  result = call_564209.call(path_564210, query_564211, nil, nil, body_564212)

var cassandraResourcesCreateUpdateCassandraKeyspace* = Call_CassandraResourcesCreateUpdateCassandraKeyspace_564199(
    name: "cassandraResourcesCreateUpdateCassandraKeyspace",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/cassandraKeyspaces/{keyspaceName}",
    validator: validate_CassandraResourcesCreateUpdateCassandraKeyspace_564200,
    base: "", url: url_CassandraResourcesCreateUpdateCassandraKeyspace_564201,
    schemes: {Scheme.Https})
type
  Call_CassandraResourcesGetCassandraKeyspace_564187 = ref object of OpenApiRestCall_563566
proc url_CassandraResourcesGetCassandraKeyspace_564189(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "keyspaceName" in path, "`keyspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/cassandraKeyspaces/"),
               (kind: VariableSegment, value: "keyspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CassandraResourcesGetCassandraKeyspace_564188(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Cassandra keyspaces under an existing Azure Cosmos DB database account with the provided name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   keyspaceName: JString (required)
  ##               : Cosmos DB keyspace name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564190 = path.getOrDefault("subscriptionId")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "subscriptionId", valid_564190
  var valid_564191 = path.getOrDefault("resourceGroupName")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "resourceGroupName", valid_564191
  var valid_564192 = path.getOrDefault("keyspaceName")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "keyspaceName", valid_564192
  var valid_564193 = path.getOrDefault("accountName")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "accountName", valid_564193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564194 = query.getOrDefault("api-version")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "api-version", valid_564194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564195: Call_CassandraResourcesGetCassandraKeyspace_564187;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the Cassandra keyspaces under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_564195.validator(path, query, header, formData, body)
  let scheme = call_564195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564195.url(scheme.get, call_564195.host, call_564195.base,
                         call_564195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564195, url, valid)

proc call*(call_564196: Call_CassandraResourcesGetCassandraKeyspace_564187;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          keyspaceName: string; accountName: string): Recallable =
  ## cassandraResourcesGetCassandraKeyspace
  ## Gets the Cassandra keyspaces under an existing Azure Cosmos DB database account with the provided name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   keyspaceName: string (required)
  ##               : Cosmos DB keyspace name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564197 = newJObject()
  var query_564198 = newJObject()
  add(query_564198, "api-version", newJString(apiVersion))
  add(path_564197, "subscriptionId", newJString(subscriptionId))
  add(path_564197, "resourceGroupName", newJString(resourceGroupName))
  add(path_564197, "keyspaceName", newJString(keyspaceName))
  add(path_564197, "accountName", newJString(accountName))
  result = call_564196.call(path_564197, query_564198, nil, nil, nil)

var cassandraResourcesGetCassandraKeyspace* = Call_CassandraResourcesGetCassandraKeyspace_564187(
    name: "cassandraResourcesGetCassandraKeyspace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/cassandraKeyspaces/{keyspaceName}",
    validator: validate_CassandraResourcesGetCassandraKeyspace_564188, base: "",
    url: url_CassandraResourcesGetCassandraKeyspace_564189,
    schemes: {Scheme.Https})
type
  Call_CassandraResourcesDeleteCassandraKeyspace_564213 = ref object of OpenApiRestCall_563566
proc url_CassandraResourcesDeleteCassandraKeyspace_564215(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "keyspaceName" in path, "`keyspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/cassandraKeyspaces/"),
               (kind: VariableSegment, value: "keyspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CassandraResourcesDeleteCassandraKeyspace_564214(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Azure Cosmos DB Cassandra keyspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   keyspaceName: JString (required)
  ##               : Cosmos DB keyspace name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564216 = path.getOrDefault("subscriptionId")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "subscriptionId", valid_564216
  var valid_564217 = path.getOrDefault("resourceGroupName")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = nil)
  if valid_564217 != nil:
    section.add "resourceGroupName", valid_564217
  var valid_564218 = path.getOrDefault("keyspaceName")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "keyspaceName", valid_564218
  var valid_564219 = path.getOrDefault("accountName")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "accountName", valid_564219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564220 = query.getOrDefault("api-version")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "api-version", valid_564220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564221: Call_CassandraResourcesDeleteCassandraKeyspace_564213;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB Cassandra keyspace.
  ## 
  let valid = call_564221.validator(path, query, header, formData, body)
  let scheme = call_564221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564221.url(scheme.get, call_564221.host, call_564221.base,
                         call_564221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564221, url, valid)

proc call*(call_564222: Call_CassandraResourcesDeleteCassandraKeyspace_564213;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          keyspaceName: string; accountName: string): Recallable =
  ## cassandraResourcesDeleteCassandraKeyspace
  ## Deletes an existing Azure Cosmos DB Cassandra keyspace.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   keyspaceName: string (required)
  ##               : Cosmos DB keyspace name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564223 = newJObject()
  var query_564224 = newJObject()
  add(query_564224, "api-version", newJString(apiVersion))
  add(path_564223, "subscriptionId", newJString(subscriptionId))
  add(path_564223, "resourceGroupName", newJString(resourceGroupName))
  add(path_564223, "keyspaceName", newJString(keyspaceName))
  add(path_564223, "accountName", newJString(accountName))
  result = call_564222.call(path_564223, query_564224, nil, nil, nil)

var cassandraResourcesDeleteCassandraKeyspace* = Call_CassandraResourcesDeleteCassandraKeyspace_564213(
    name: "cassandraResourcesDeleteCassandraKeyspace",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/cassandraKeyspaces/{keyspaceName}",
    validator: validate_CassandraResourcesDeleteCassandraKeyspace_564214,
    base: "", url: url_CassandraResourcesDeleteCassandraKeyspace_564215,
    schemes: {Scheme.Https})
type
  Call_CassandraResourcesListCassandraTables_564225 = ref object of OpenApiRestCall_563566
proc url_CassandraResourcesListCassandraTables_564227(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "keyspaceName" in path, "`keyspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/cassandraKeyspaces/"),
               (kind: VariableSegment, value: "keyspaceName"),
               (kind: ConstantSegment, value: "/tables")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CassandraResourcesListCassandraTables_564226(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Cassandra table under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   keyspaceName: JString (required)
  ##               : Cosmos DB keyspace name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564228 = path.getOrDefault("subscriptionId")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "subscriptionId", valid_564228
  var valid_564229 = path.getOrDefault("resourceGroupName")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "resourceGroupName", valid_564229
  var valid_564230 = path.getOrDefault("keyspaceName")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "keyspaceName", valid_564230
  var valid_564231 = path.getOrDefault("accountName")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "accountName", valid_564231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564232 = query.getOrDefault("api-version")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "api-version", valid_564232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564233: Call_CassandraResourcesListCassandraTables_564225;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Cassandra table under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_564233.validator(path, query, header, formData, body)
  let scheme = call_564233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564233.url(scheme.get, call_564233.host, call_564233.base,
                         call_564233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564233, url, valid)

proc call*(call_564234: Call_CassandraResourcesListCassandraTables_564225;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          keyspaceName: string; accountName: string): Recallable =
  ## cassandraResourcesListCassandraTables
  ## Lists the Cassandra table under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   keyspaceName: string (required)
  ##               : Cosmos DB keyspace name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564235 = newJObject()
  var query_564236 = newJObject()
  add(query_564236, "api-version", newJString(apiVersion))
  add(path_564235, "subscriptionId", newJString(subscriptionId))
  add(path_564235, "resourceGroupName", newJString(resourceGroupName))
  add(path_564235, "keyspaceName", newJString(keyspaceName))
  add(path_564235, "accountName", newJString(accountName))
  result = call_564234.call(path_564235, query_564236, nil, nil, nil)

var cassandraResourcesListCassandraTables* = Call_CassandraResourcesListCassandraTables_564225(
    name: "cassandraResourcesListCassandraTables", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/cassandraKeyspaces/{keyspaceName}/tables",
    validator: validate_CassandraResourcesListCassandraTables_564226, base: "",
    url: url_CassandraResourcesListCassandraTables_564227, schemes: {Scheme.Https})
type
  Call_CassandraResourcesCreateUpdateCassandraTable_564250 = ref object of OpenApiRestCall_563566
proc url_CassandraResourcesCreateUpdateCassandraTable_564252(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "keyspaceName" in path, "`keyspaceName` is a required path parameter"
  assert "tableName" in path, "`tableName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/cassandraKeyspaces/"),
               (kind: VariableSegment, value: "keyspaceName"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CassandraResourcesCreateUpdateCassandraTable_564251(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an Azure Cosmos DB Cassandra Table
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   tableName: JString (required)
  ##            : Cosmos DB table name.
  ##   keyspaceName: JString (required)
  ##               : Cosmos DB keyspace name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564253 = path.getOrDefault("subscriptionId")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "subscriptionId", valid_564253
  var valid_564254 = path.getOrDefault("resourceGroupName")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "resourceGroupName", valid_564254
  var valid_564255 = path.getOrDefault("tableName")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "tableName", valid_564255
  var valid_564256 = path.getOrDefault("keyspaceName")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "keyspaceName", valid_564256
  var valid_564257 = path.getOrDefault("accountName")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "accountName", valid_564257
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564258 = query.getOrDefault("api-version")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "api-version", valid_564258
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   createUpdateCassandraTableParameters: JObject (required)
  ##                                       : The parameters to provide for the current Cassandra Table.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564260: Call_CassandraResourcesCreateUpdateCassandraTable_564250;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB Cassandra Table
  ## 
  let valid = call_564260.validator(path, query, header, formData, body)
  let scheme = call_564260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564260.url(scheme.get, call_564260.host, call_564260.base,
                         call_564260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564260, url, valid)

proc call*(call_564261: Call_CassandraResourcesCreateUpdateCassandraTable_564250;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          createUpdateCassandraTableParameters: JsonNode; tableName: string;
          keyspaceName: string; accountName: string): Recallable =
  ## cassandraResourcesCreateUpdateCassandraTable
  ## Create or update an Azure Cosmos DB Cassandra Table
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   createUpdateCassandraTableParameters: JObject (required)
  ##                                       : The parameters to provide for the current Cassandra Table.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   keyspaceName: string (required)
  ##               : Cosmos DB keyspace name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564262 = newJObject()
  var query_564263 = newJObject()
  var body_564264 = newJObject()
  add(query_564263, "api-version", newJString(apiVersion))
  add(path_564262, "subscriptionId", newJString(subscriptionId))
  add(path_564262, "resourceGroupName", newJString(resourceGroupName))
  if createUpdateCassandraTableParameters != nil:
    body_564264 = createUpdateCassandraTableParameters
  add(path_564262, "tableName", newJString(tableName))
  add(path_564262, "keyspaceName", newJString(keyspaceName))
  add(path_564262, "accountName", newJString(accountName))
  result = call_564261.call(path_564262, query_564263, nil, nil, body_564264)

var cassandraResourcesCreateUpdateCassandraTable* = Call_CassandraResourcesCreateUpdateCassandraTable_564250(
    name: "cassandraResourcesCreateUpdateCassandraTable",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/cassandraKeyspaces/{keyspaceName}/tables/{tableName}",
    validator: validate_CassandraResourcesCreateUpdateCassandraTable_564251,
    base: "", url: url_CassandraResourcesCreateUpdateCassandraTable_564252,
    schemes: {Scheme.Https})
type
  Call_CassandraResourcesGetCassandraTable_564237 = ref object of OpenApiRestCall_563566
proc url_CassandraResourcesGetCassandraTable_564239(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "keyspaceName" in path, "`keyspaceName` is a required path parameter"
  assert "tableName" in path, "`tableName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/cassandraKeyspaces/"),
               (kind: VariableSegment, value: "keyspaceName"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CassandraResourcesGetCassandraTable_564238(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Cassandra table under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   tableName: JString (required)
  ##            : Cosmos DB table name.
  ##   keyspaceName: JString (required)
  ##               : Cosmos DB keyspace name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564240 = path.getOrDefault("subscriptionId")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "subscriptionId", valid_564240
  var valid_564241 = path.getOrDefault("resourceGroupName")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "resourceGroupName", valid_564241
  var valid_564242 = path.getOrDefault("tableName")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "tableName", valid_564242
  var valid_564243 = path.getOrDefault("keyspaceName")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "keyspaceName", valid_564243
  var valid_564244 = path.getOrDefault("accountName")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "accountName", valid_564244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564245 = query.getOrDefault("api-version")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "api-version", valid_564245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564246: Call_CassandraResourcesGetCassandraTable_564237;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the Cassandra table under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_564246.validator(path, query, header, formData, body)
  let scheme = call_564246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564246.url(scheme.get, call_564246.host, call_564246.base,
                         call_564246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564246, url, valid)

proc call*(call_564247: Call_CassandraResourcesGetCassandraTable_564237;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          tableName: string; keyspaceName: string; accountName: string): Recallable =
  ## cassandraResourcesGetCassandraTable
  ## Gets the Cassandra table under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   keyspaceName: string (required)
  ##               : Cosmos DB keyspace name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564248 = newJObject()
  var query_564249 = newJObject()
  add(query_564249, "api-version", newJString(apiVersion))
  add(path_564248, "subscriptionId", newJString(subscriptionId))
  add(path_564248, "resourceGroupName", newJString(resourceGroupName))
  add(path_564248, "tableName", newJString(tableName))
  add(path_564248, "keyspaceName", newJString(keyspaceName))
  add(path_564248, "accountName", newJString(accountName))
  result = call_564247.call(path_564248, query_564249, nil, nil, nil)

var cassandraResourcesGetCassandraTable* = Call_CassandraResourcesGetCassandraTable_564237(
    name: "cassandraResourcesGetCassandraTable", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/cassandraKeyspaces/{keyspaceName}/tables/{tableName}",
    validator: validate_CassandraResourcesGetCassandraTable_564238, base: "",
    url: url_CassandraResourcesGetCassandraTable_564239, schemes: {Scheme.Https})
type
  Call_CassandraResourcesDeleteCassandraTable_564265 = ref object of OpenApiRestCall_563566
proc url_CassandraResourcesDeleteCassandraTable_564267(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "keyspaceName" in path, "`keyspaceName` is a required path parameter"
  assert "tableName" in path, "`tableName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/cassandraKeyspaces/"),
               (kind: VariableSegment, value: "keyspaceName"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CassandraResourcesDeleteCassandraTable_564266(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Azure Cosmos DB Cassandra table.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   tableName: JString (required)
  ##            : Cosmos DB table name.
  ##   keyspaceName: JString (required)
  ##               : Cosmos DB keyspace name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564268 = path.getOrDefault("subscriptionId")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = nil)
  if valid_564268 != nil:
    section.add "subscriptionId", valid_564268
  var valid_564269 = path.getOrDefault("resourceGroupName")
  valid_564269 = validateParameter(valid_564269, JString, required = true,
                                 default = nil)
  if valid_564269 != nil:
    section.add "resourceGroupName", valid_564269
  var valid_564270 = path.getOrDefault("tableName")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "tableName", valid_564270
  var valid_564271 = path.getOrDefault("keyspaceName")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "keyspaceName", valid_564271
  var valid_564272 = path.getOrDefault("accountName")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "accountName", valid_564272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564273 = query.getOrDefault("api-version")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "api-version", valid_564273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564274: Call_CassandraResourcesDeleteCassandraTable_564265;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB Cassandra table.
  ## 
  let valid = call_564274.validator(path, query, header, formData, body)
  let scheme = call_564274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564274.url(scheme.get, call_564274.host, call_564274.base,
                         call_564274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564274, url, valid)

proc call*(call_564275: Call_CassandraResourcesDeleteCassandraTable_564265;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          tableName: string; keyspaceName: string; accountName: string): Recallable =
  ## cassandraResourcesDeleteCassandraTable
  ## Deletes an existing Azure Cosmos DB Cassandra table.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   keyspaceName: string (required)
  ##               : Cosmos DB keyspace name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564276 = newJObject()
  var query_564277 = newJObject()
  add(query_564277, "api-version", newJString(apiVersion))
  add(path_564276, "subscriptionId", newJString(subscriptionId))
  add(path_564276, "resourceGroupName", newJString(resourceGroupName))
  add(path_564276, "tableName", newJString(tableName))
  add(path_564276, "keyspaceName", newJString(keyspaceName))
  add(path_564276, "accountName", newJString(accountName))
  result = call_564275.call(path_564276, query_564277, nil, nil, nil)

var cassandraResourcesDeleteCassandraTable* = Call_CassandraResourcesDeleteCassandraTable_564265(
    name: "cassandraResourcesDeleteCassandraTable", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/cassandraKeyspaces/{keyspaceName}/tables/{tableName}",
    validator: validate_CassandraResourcesDeleteCassandraTable_564266, base: "",
    url: url_CassandraResourcesDeleteCassandraTable_564267,
    schemes: {Scheme.Https})
type
  Call_CassandraResourcesUpdateCassandraTableThroughput_564291 = ref object of OpenApiRestCall_563566
proc url_CassandraResourcesUpdateCassandraTableThroughput_564293(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "keyspaceName" in path, "`keyspaceName` is a required path parameter"
  assert "tableName" in path, "`tableName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/cassandraKeyspaces/"),
               (kind: VariableSegment, value: "keyspaceName"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableName"),
               (kind: ConstantSegment, value: "/throughputSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CassandraResourcesUpdateCassandraTableThroughput_564292(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Update RUs per second of an Azure Cosmos DB Cassandra table
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   tableName: JString (required)
  ##            : Cosmos DB table name.
  ##   keyspaceName: JString (required)
  ##               : Cosmos DB keyspace name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564294 = path.getOrDefault("subscriptionId")
  valid_564294 = validateParameter(valid_564294, JString, required = true,
                                 default = nil)
  if valid_564294 != nil:
    section.add "subscriptionId", valid_564294
  var valid_564295 = path.getOrDefault("resourceGroupName")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "resourceGroupName", valid_564295
  var valid_564296 = path.getOrDefault("tableName")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "tableName", valid_564296
  var valid_564297 = path.getOrDefault("keyspaceName")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "keyspaceName", valid_564297
  var valid_564298 = path.getOrDefault("accountName")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "accountName", valid_564298
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564299 = query.getOrDefault("api-version")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "api-version", valid_564299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   updateThroughputParameters: JObject (required)
  ##                             : The RUs per second of the parameters to provide for the current Cassandra table.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564301: Call_CassandraResourcesUpdateCassandraTableThroughput_564291;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Cassandra table
  ## 
  let valid = call_564301.validator(path, query, header, formData, body)
  let scheme = call_564301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564301.url(scheme.get, call_564301.host, call_564301.base,
                         call_564301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564301, url, valid)

proc call*(call_564302: Call_CassandraResourcesUpdateCassandraTableThroughput_564291;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          tableName: string; keyspaceName: string; accountName: string;
          updateThroughputParameters: JsonNode): Recallable =
  ## cassandraResourcesUpdateCassandraTableThroughput
  ## Update RUs per second of an Azure Cosmos DB Cassandra table
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   keyspaceName: string (required)
  ##               : Cosmos DB keyspace name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   updateThroughputParameters: JObject (required)
  ##                             : The RUs per second of the parameters to provide for the current Cassandra table.
  var path_564303 = newJObject()
  var query_564304 = newJObject()
  var body_564305 = newJObject()
  add(query_564304, "api-version", newJString(apiVersion))
  add(path_564303, "subscriptionId", newJString(subscriptionId))
  add(path_564303, "resourceGroupName", newJString(resourceGroupName))
  add(path_564303, "tableName", newJString(tableName))
  add(path_564303, "keyspaceName", newJString(keyspaceName))
  add(path_564303, "accountName", newJString(accountName))
  if updateThroughputParameters != nil:
    body_564305 = updateThroughputParameters
  result = call_564302.call(path_564303, query_564304, nil, nil, body_564305)

var cassandraResourcesUpdateCassandraTableThroughput* = Call_CassandraResourcesUpdateCassandraTableThroughput_564291(
    name: "cassandraResourcesUpdateCassandraTableThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/cassandraKeyspaces/{keyspaceName}/tables/{tableName}/throughputSettings/default",
    validator: validate_CassandraResourcesUpdateCassandraTableThroughput_564292,
    base: "", url: url_CassandraResourcesUpdateCassandraTableThroughput_564293,
    schemes: {Scheme.Https})
type
  Call_CassandraResourcesGetCassandraTableThroughput_564278 = ref object of OpenApiRestCall_563566
proc url_CassandraResourcesGetCassandraTableThroughput_564280(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "keyspaceName" in path, "`keyspaceName` is a required path parameter"
  assert "tableName" in path, "`tableName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/cassandraKeyspaces/"),
               (kind: VariableSegment, value: "keyspaceName"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableName"),
               (kind: ConstantSegment, value: "/throughputSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CassandraResourcesGetCassandraTableThroughput_564279(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the RUs per second of the Cassandra table under an existing Azure Cosmos DB database account with the provided name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   tableName: JString (required)
  ##            : Cosmos DB table name.
  ##   keyspaceName: JString (required)
  ##               : Cosmos DB keyspace name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564281 = path.getOrDefault("subscriptionId")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "subscriptionId", valid_564281
  var valid_564282 = path.getOrDefault("resourceGroupName")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "resourceGroupName", valid_564282
  var valid_564283 = path.getOrDefault("tableName")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "tableName", valid_564283
  var valid_564284 = path.getOrDefault("keyspaceName")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "keyspaceName", valid_564284
  var valid_564285 = path.getOrDefault("accountName")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "accountName", valid_564285
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564286 = query.getOrDefault("api-version")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "api-version", valid_564286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564287: Call_CassandraResourcesGetCassandraTableThroughput_564278;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the Cassandra table under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_564287.validator(path, query, header, formData, body)
  let scheme = call_564287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564287.url(scheme.get, call_564287.host, call_564287.base,
                         call_564287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564287, url, valid)

proc call*(call_564288: Call_CassandraResourcesGetCassandraTableThroughput_564278;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          tableName: string; keyspaceName: string; accountName: string): Recallable =
  ## cassandraResourcesGetCassandraTableThroughput
  ## Gets the RUs per second of the Cassandra table under an existing Azure Cosmos DB database account with the provided name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   keyspaceName: string (required)
  ##               : Cosmos DB keyspace name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564289 = newJObject()
  var query_564290 = newJObject()
  add(query_564290, "api-version", newJString(apiVersion))
  add(path_564289, "subscriptionId", newJString(subscriptionId))
  add(path_564289, "resourceGroupName", newJString(resourceGroupName))
  add(path_564289, "tableName", newJString(tableName))
  add(path_564289, "keyspaceName", newJString(keyspaceName))
  add(path_564289, "accountName", newJString(accountName))
  result = call_564288.call(path_564289, query_564290, nil, nil, nil)

var cassandraResourcesGetCassandraTableThroughput* = Call_CassandraResourcesGetCassandraTableThroughput_564278(
    name: "cassandraResourcesGetCassandraTableThroughput",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/cassandraKeyspaces/{keyspaceName}/tables/{tableName}/throughputSettings/default",
    validator: validate_CassandraResourcesGetCassandraTableThroughput_564279,
    base: "", url: url_CassandraResourcesGetCassandraTableThroughput_564280,
    schemes: {Scheme.Https})
type
  Call_CassandraResourcesUpdateCassandraKeyspaceThroughput_564318 = ref object of OpenApiRestCall_563566
proc url_CassandraResourcesUpdateCassandraKeyspaceThroughput_564320(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "keyspaceName" in path, "`keyspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/cassandraKeyspaces/"),
               (kind: VariableSegment, value: "keyspaceName"),
               (kind: ConstantSegment, value: "/throughputSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CassandraResourcesUpdateCassandraKeyspaceThroughput_564319(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Update RUs per second of an Azure Cosmos DB Cassandra Keyspace
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   keyspaceName: JString (required)
  ##               : Cosmos DB keyspace name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564321 = path.getOrDefault("subscriptionId")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "subscriptionId", valid_564321
  var valid_564322 = path.getOrDefault("resourceGroupName")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "resourceGroupName", valid_564322
  var valid_564323 = path.getOrDefault("keyspaceName")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "keyspaceName", valid_564323
  var valid_564324 = path.getOrDefault("accountName")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "accountName", valid_564324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564325 = query.getOrDefault("api-version")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "api-version", valid_564325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   updateThroughputParameters: JObject (required)
  ##                             : The RUs per second of the parameters to provide for the current Cassandra Keyspace.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564327: Call_CassandraResourcesUpdateCassandraKeyspaceThroughput_564318;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Cassandra Keyspace
  ## 
  let valid = call_564327.validator(path, query, header, formData, body)
  let scheme = call_564327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564327.url(scheme.get, call_564327.host, call_564327.base,
                         call_564327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564327, url, valid)

proc call*(call_564328: Call_CassandraResourcesUpdateCassandraKeyspaceThroughput_564318;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          keyspaceName: string; accountName: string;
          updateThroughputParameters: JsonNode): Recallable =
  ## cassandraResourcesUpdateCassandraKeyspaceThroughput
  ## Update RUs per second of an Azure Cosmos DB Cassandra Keyspace
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   keyspaceName: string (required)
  ##               : Cosmos DB keyspace name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   updateThroughputParameters: JObject (required)
  ##                             : The RUs per second of the parameters to provide for the current Cassandra Keyspace.
  var path_564329 = newJObject()
  var query_564330 = newJObject()
  var body_564331 = newJObject()
  add(query_564330, "api-version", newJString(apiVersion))
  add(path_564329, "subscriptionId", newJString(subscriptionId))
  add(path_564329, "resourceGroupName", newJString(resourceGroupName))
  add(path_564329, "keyspaceName", newJString(keyspaceName))
  add(path_564329, "accountName", newJString(accountName))
  if updateThroughputParameters != nil:
    body_564331 = updateThroughputParameters
  result = call_564328.call(path_564329, query_564330, nil, nil, body_564331)

var cassandraResourcesUpdateCassandraKeyspaceThroughput* = Call_CassandraResourcesUpdateCassandraKeyspaceThroughput_564318(
    name: "cassandraResourcesUpdateCassandraKeyspaceThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/cassandraKeyspaces/{keyspaceName}/throughputSettings/default",
    validator: validate_CassandraResourcesUpdateCassandraKeyspaceThroughput_564319,
    base: "", url: url_CassandraResourcesUpdateCassandraKeyspaceThroughput_564320,
    schemes: {Scheme.Https})
type
  Call_CassandraResourcesGetCassandraKeyspaceThroughput_564306 = ref object of OpenApiRestCall_563566
proc url_CassandraResourcesGetCassandraKeyspaceThroughput_564308(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "keyspaceName" in path, "`keyspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/cassandraKeyspaces/"),
               (kind: VariableSegment, value: "keyspaceName"),
               (kind: ConstantSegment, value: "/throughputSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CassandraResourcesGetCassandraKeyspaceThroughput_564307(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the RUs per second of the Cassandra Keyspace under an existing Azure Cosmos DB database account with the provided name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   keyspaceName: JString (required)
  ##               : Cosmos DB keyspace name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564309 = path.getOrDefault("subscriptionId")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "subscriptionId", valid_564309
  var valid_564310 = path.getOrDefault("resourceGroupName")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "resourceGroupName", valid_564310
  var valid_564311 = path.getOrDefault("keyspaceName")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "keyspaceName", valid_564311
  var valid_564312 = path.getOrDefault("accountName")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "accountName", valid_564312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564313 = query.getOrDefault("api-version")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "api-version", valid_564313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564314: Call_CassandraResourcesGetCassandraKeyspaceThroughput_564306;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the Cassandra Keyspace under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_564314.validator(path, query, header, formData, body)
  let scheme = call_564314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564314.url(scheme.get, call_564314.host, call_564314.base,
                         call_564314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564314, url, valid)

proc call*(call_564315: Call_CassandraResourcesGetCassandraKeyspaceThroughput_564306;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          keyspaceName: string; accountName: string): Recallable =
  ## cassandraResourcesGetCassandraKeyspaceThroughput
  ## Gets the RUs per second of the Cassandra Keyspace under an existing Azure Cosmos DB database account with the provided name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   keyspaceName: string (required)
  ##               : Cosmos DB keyspace name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564316 = newJObject()
  var query_564317 = newJObject()
  add(query_564317, "api-version", newJString(apiVersion))
  add(path_564316, "subscriptionId", newJString(subscriptionId))
  add(path_564316, "resourceGroupName", newJString(resourceGroupName))
  add(path_564316, "keyspaceName", newJString(keyspaceName))
  add(path_564316, "accountName", newJString(accountName))
  result = call_564315.call(path_564316, query_564317, nil, nil, nil)

var cassandraResourcesGetCassandraKeyspaceThroughput* = Call_CassandraResourcesGetCassandraKeyspaceThroughput_564306(
    name: "cassandraResourcesGetCassandraKeyspaceThroughput",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/cassandraKeyspaces/{keyspaceName}/throughputSettings/default",
    validator: validate_CassandraResourcesGetCassandraKeyspaceThroughput_564307,
    base: "", url: url_CassandraResourcesGetCassandraKeyspaceThroughput_564308,
    schemes: {Scheme.Https})
type
  Call_CollectionListMetricDefinitions_564332 = ref object of OpenApiRestCall_563566
proc url_CollectionListMetricDefinitions_564334(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseRid" in path, "`databaseRid` is a required path parameter"
  assert "collectionRid" in path, "`collectionRid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseRid"),
               (kind: ConstantSegment, value: "/collections/"),
               (kind: VariableSegment, value: "collectionRid"),
               (kind: ConstantSegment, value: "/metricDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CollectionListMetricDefinitions_564333(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves metric definitions for the given collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: JString (required)
  ##              : Cosmos DB database rid.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   collectionRid: JString (required)
  ##                : Cosmos DB collection rid.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564335 = path.getOrDefault("subscriptionId")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "subscriptionId", valid_564335
  var valid_564336 = path.getOrDefault("databaseRid")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "databaseRid", valid_564336
  var valid_564337 = path.getOrDefault("resourceGroupName")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "resourceGroupName", valid_564337
  var valid_564338 = path.getOrDefault("collectionRid")
  valid_564338 = validateParameter(valid_564338, JString, required = true,
                                 default = nil)
  if valid_564338 != nil:
    section.add "collectionRid", valid_564338
  var valid_564339 = path.getOrDefault("accountName")
  valid_564339 = validateParameter(valid_564339, JString, required = true,
                                 default = nil)
  if valid_564339 != nil:
    section.add "accountName", valid_564339
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564340 = query.getOrDefault("api-version")
  valid_564340 = validateParameter(valid_564340, JString, required = true,
                                 default = nil)
  if valid_564340 != nil:
    section.add "api-version", valid_564340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564341: Call_CollectionListMetricDefinitions_564332;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves metric definitions for the given collection.
  ## 
  let valid = call_564341.validator(path, query, header, formData, body)
  let scheme = call_564341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564341.url(scheme.get, call_564341.host, call_564341.base,
                         call_564341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564341, url, valid)

proc call*(call_564342: Call_CollectionListMetricDefinitions_564332;
          apiVersion: string; subscriptionId: string; databaseRid: string;
          resourceGroupName: string; collectionRid: string; accountName: string): Recallable =
  ## collectionListMetricDefinitions
  ## Retrieves metric definitions for the given collection.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: string (required)
  ##              : Cosmos DB database rid.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   collectionRid: string (required)
  ##                : Cosmos DB collection rid.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564343 = newJObject()
  var query_564344 = newJObject()
  add(query_564344, "api-version", newJString(apiVersion))
  add(path_564343, "subscriptionId", newJString(subscriptionId))
  add(path_564343, "databaseRid", newJString(databaseRid))
  add(path_564343, "resourceGroupName", newJString(resourceGroupName))
  add(path_564343, "collectionRid", newJString(collectionRid))
  add(path_564343, "accountName", newJString(accountName))
  result = call_564342.call(path_564343, query_564344, nil, nil, nil)

var collectionListMetricDefinitions* = Call_CollectionListMetricDefinitions_564332(
    name: "collectionListMetricDefinitions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/metricDefinitions",
    validator: validate_CollectionListMetricDefinitions_564333, base: "",
    url: url_CollectionListMetricDefinitions_564334, schemes: {Scheme.Https})
type
  Call_CollectionListMetrics_564345 = ref object of OpenApiRestCall_563566
proc url_CollectionListMetrics_564347(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseRid" in path, "`databaseRid` is a required path parameter"
  assert "collectionRid" in path, "`collectionRid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseRid"),
               (kind: ConstantSegment, value: "/collections/"),
               (kind: VariableSegment, value: "collectionRid"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CollectionListMetrics_564346(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the metrics determined by the given filter for the given database account and collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: JString (required)
  ##              : Cosmos DB database rid.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   collectionRid: JString (required)
  ##                : Cosmos DB collection rid.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564349 = path.getOrDefault("subscriptionId")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "subscriptionId", valid_564349
  var valid_564350 = path.getOrDefault("databaseRid")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "databaseRid", valid_564350
  var valid_564351 = path.getOrDefault("resourceGroupName")
  valid_564351 = validateParameter(valid_564351, JString, required = true,
                                 default = nil)
  if valid_564351 != nil:
    section.add "resourceGroupName", valid_564351
  var valid_564352 = path.getOrDefault("collectionRid")
  valid_564352 = validateParameter(valid_564352, JString, required = true,
                                 default = nil)
  if valid_564352 != nil:
    section.add "collectionRid", valid_564352
  var valid_564353 = path.getOrDefault("accountName")
  valid_564353 = validateParameter(valid_564353, JString, required = true,
                                 default = nil)
  if valid_564353 != nil:
    section.add "accountName", valid_564353
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564354 = query.getOrDefault("api-version")
  valid_564354 = validateParameter(valid_564354, JString, required = true,
                                 default = nil)
  if valid_564354 != nil:
    section.add "api-version", valid_564354
  var valid_564355 = query.getOrDefault("$filter")
  valid_564355 = validateParameter(valid_564355, JString, required = true,
                                 default = nil)
  if valid_564355 != nil:
    section.add "$filter", valid_564355
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564356: Call_CollectionListMetrics_564345; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account and collection.
  ## 
  let valid = call_564356.validator(path, query, header, formData, body)
  let scheme = call_564356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564356.url(scheme.get, call_564356.host, call_564356.base,
                         call_564356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564356, url, valid)

proc call*(call_564357: Call_CollectionListMetrics_564345; apiVersion: string;
          subscriptionId: string; databaseRid: string; resourceGroupName: string;
          collectionRid: string; Filter: string; accountName: string): Recallable =
  ## collectionListMetrics
  ## Retrieves the metrics determined by the given filter for the given database account and collection.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: string (required)
  ##              : Cosmos DB database rid.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   collectionRid: string (required)
  ##                : Cosmos DB collection rid.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564358 = newJObject()
  var query_564359 = newJObject()
  add(query_564359, "api-version", newJString(apiVersion))
  add(path_564358, "subscriptionId", newJString(subscriptionId))
  add(path_564358, "databaseRid", newJString(databaseRid))
  add(path_564358, "resourceGroupName", newJString(resourceGroupName))
  add(path_564358, "collectionRid", newJString(collectionRid))
  add(query_564359, "$filter", newJString(Filter))
  add(path_564358, "accountName", newJString(accountName))
  result = call_564357.call(path_564358, query_564359, nil, nil, nil)

var collectionListMetrics* = Call_CollectionListMetrics_564345(
    name: "collectionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/metrics",
    validator: validate_CollectionListMetrics_564346, base: "",
    url: url_CollectionListMetrics_564347, schemes: {Scheme.Https})
type
  Call_PartitionKeyRangeIdListMetrics_564360 = ref object of OpenApiRestCall_563566
proc url_PartitionKeyRangeIdListMetrics_564362(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseRid" in path, "`databaseRid` is a required path parameter"
  assert "collectionRid" in path, "`collectionRid` is a required path parameter"
  assert "partitionKeyRangeId" in path,
        "`partitionKeyRangeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseRid"),
               (kind: ConstantSegment, value: "/collections/"),
               (kind: VariableSegment, value: "collectionRid"),
               (kind: ConstantSegment, value: "/partitionKeyRangeId/"),
               (kind: VariableSegment, value: "partitionKeyRangeId"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartitionKeyRangeIdListMetrics_564361(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the metrics determined by the given filter for the given partition key range id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partitionKeyRangeId: JString (required)
  ##                      : Partition Key Range Id for which to get data.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: JString (required)
  ##              : Cosmos DB database rid.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   collectionRid: JString (required)
  ##                : Cosmos DB collection rid.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `partitionKeyRangeId` field"
  var valid_564363 = path.getOrDefault("partitionKeyRangeId")
  valid_564363 = validateParameter(valid_564363, JString, required = true,
                                 default = nil)
  if valid_564363 != nil:
    section.add "partitionKeyRangeId", valid_564363
  var valid_564364 = path.getOrDefault("subscriptionId")
  valid_564364 = validateParameter(valid_564364, JString, required = true,
                                 default = nil)
  if valid_564364 != nil:
    section.add "subscriptionId", valid_564364
  var valid_564365 = path.getOrDefault("databaseRid")
  valid_564365 = validateParameter(valid_564365, JString, required = true,
                                 default = nil)
  if valid_564365 != nil:
    section.add "databaseRid", valid_564365
  var valid_564366 = path.getOrDefault("resourceGroupName")
  valid_564366 = validateParameter(valid_564366, JString, required = true,
                                 default = nil)
  if valid_564366 != nil:
    section.add "resourceGroupName", valid_564366
  var valid_564367 = path.getOrDefault("collectionRid")
  valid_564367 = validateParameter(valid_564367, JString, required = true,
                                 default = nil)
  if valid_564367 != nil:
    section.add "collectionRid", valid_564367
  var valid_564368 = path.getOrDefault("accountName")
  valid_564368 = validateParameter(valid_564368, JString, required = true,
                                 default = nil)
  if valid_564368 != nil:
    section.add "accountName", valid_564368
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564369 = query.getOrDefault("api-version")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "api-version", valid_564369
  var valid_564370 = query.getOrDefault("$filter")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = nil)
  if valid_564370 != nil:
    section.add "$filter", valid_564370
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564371: Call_PartitionKeyRangeIdListMetrics_564360; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given partition key range id.
  ## 
  let valid = call_564371.validator(path, query, header, formData, body)
  let scheme = call_564371.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564371.url(scheme.get, call_564371.host, call_564371.base,
                         call_564371.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564371, url, valid)

proc call*(call_564372: Call_PartitionKeyRangeIdListMetrics_564360;
          partitionKeyRangeId: string; apiVersion: string; subscriptionId: string;
          databaseRid: string; resourceGroupName: string; collectionRid: string;
          Filter: string; accountName: string): Recallable =
  ## partitionKeyRangeIdListMetrics
  ## Retrieves the metrics determined by the given filter for the given partition key range id.
  ##   partitionKeyRangeId: string (required)
  ##                      : Partition Key Range Id for which to get data.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: string (required)
  ##              : Cosmos DB database rid.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   collectionRid: string (required)
  ##                : Cosmos DB collection rid.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564373 = newJObject()
  var query_564374 = newJObject()
  add(path_564373, "partitionKeyRangeId", newJString(partitionKeyRangeId))
  add(query_564374, "api-version", newJString(apiVersion))
  add(path_564373, "subscriptionId", newJString(subscriptionId))
  add(path_564373, "databaseRid", newJString(databaseRid))
  add(path_564373, "resourceGroupName", newJString(resourceGroupName))
  add(path_564373, "collectionRid", newJString(collectionRid))
  add(query_564374, "$filter", newJString(Filter))
  add(path_564373, "accountName", newJString(accountName))
  result = call_564372.call(path_564373, query_564374, nil, nil, nil)

var partitionKeyRangeIdListMetrics* = Call_PartitionKeyRangeIdListMetrics_564360(
    name: "partitionKeyRangeIdListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/partitionKeyRangeId/{partitionKeyRangeId}/metrics",
    validator: validate_PartitionKeyRangeIdListMetrics_564361, base: "",
    url: url_PartitionKeyRangeIdListMetrics_564362, schemes: {Scheme.Https})
type
  Call_CollectionPartitionListMetrics_564375 = ref object of OpenApiRestCall_563566
proc url_CollectionPartitionListMetrics_564377(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseRid" in path, "`databaseRid` is a required path parameter"
  assert "collectionRid" in path, "`collectionRid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseRid"),
               (kind: ConstantSegment, value: "/collections/"),
               (kind: VariableSegment, value: "collectionRid"),
               (kind: ConstantSegment, value: "/partitions/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CollectionPartitionListMetrics_564376(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the metrics determined by the given filter for the given collection, split by partition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: JString (required)
  ##              : Cosmos DB database rid.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   collectionRid: JString (required)
  ##                : Cosmos DB collection rid.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564378 = path.getOrDefault("subscriptionId")
  valid_564378 = validateParameter(valid_564378, JString, required = true,
                                 default = nil)
  if valid_564378 != nil:
    section.add "subscriptionId", valid_564378
  var valid_564379 = path.getOrDefault("databaseRid")
  valid_564379 = validateParameter(valid_564379, JString, required = true,
                                 default = nil)
  if valid_564379 != nil:
    section.add "databaseRid", valid_564379
  var valid_564380 = path.getOrDefault("resourceGroupName")
  valid_564380 = validateParameter(valid_564380, JString, required = true,
                                 default = nil)
  if valid_564380 != nil:
    section.add "resourceGroupName", valid_564380
  var valid_564381 = path.getOrDefault("collectionRid")
  valid_564381 = validateParameter(valid_564381, JString, required = true,
                                 default = nil)
  if valid_564381 != nil:
    section.add "collectionRid", valid_564381
  var valid_564382 = path.getOrDefault("accountName")
  valid_564382 = validateParameter(valid_564382, JString, required = true,
                                 default = nil)
  if valid_564382 != nil:
    section.add "accountName", valid_564382
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564383 = query.getOrDefault("api-version")
  valid_564383 = validateParameter(valid_564383, JString, required = true,
                                 default = nil)
  if valid_564383 != nil:
    section.add "api-version", valid_564383
  var valid_564384 = query.getOrDefault("$filter")
  valid_564384 = validateParameter(valid_564384, JString, required = true,
                                 default = nil)
  if valid_564384 != nil:
    section.add "$filter", valid_564384
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564385: Call_CollectionPartitionListMetrics_564375; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given collection, split by partition.
  ## 
  let valid = call_564385.validator(path, query, header, formData, body)
  let scheme = call_564385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564385.url(scheme.get, call_564385.host, call_564385.base,
                         call_564385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564385, url, valid)

proc call*(call_564386: Call_CollectionPartitionListMetrics_564375;
          apiVersion: string; subscriptionId: string; databaseRid: string;
          resourceGroupName: string; collectionRid: string; Filter: string;
          accountName: string): Recallable =
  ## collectionPartitionListMetrics
  ## Retrieves the metrics determined by the given filter for the given collection, split by partition.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: string (required)
  ##              : Cosmos DB database rid.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   collectionRid: string (required)
  ##                : Cosmos DB collection rid.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564387 = newJObject()
  var query_564388 = newJObject()
  add(query_564388, "api-version", newJString(apiVersion))
  add(path_564387, "subscriptionId", newJString(subscriptionId))
  add(path_564387, "databaseRid", newJString(databaseRid))
  add(path_564387, "resourceGroupName", newJString(resourceGroupName))
  add(path_564387, "collectionRid", newJString(collectionRid))
  add(query_564388, "$filter", newJString(Filter))
  add(path_564387, "accountName", newJString(accountName))
  result = call_564386.call(path_564387, query_564388, nil, nil, nil)

var collectionPartitionListMetrics* = Call_CollectionPartitionListMetrics_564375(
    name: "collectionPartitionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/partitions/metrics",
    validator: validate_CollectionPartitionListMetrics_564376, base: "",
    url: url_CollectionPartitionListMetrics_564377, schemes: {Scheme.Https})
type
  Call_CollectionPartitionListUsages_564389 = ref object of OpenApiRestCall_563566
proc url_CollectionPartitionListUsages_564391(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseRid" in path, "`databaseRid` is a required path parameter"
  assert "collectionRid" in path, "`collectionRid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseRid"),
               (kind: ConstantSegment, value: "/collections/"),
               (kind: VariableSegment, value: "collectionRid"),
               (kind: ConstantSegment, value: "/partitions/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CollectionPartitionListUsages_564390(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the usages (most recent storage data) for the given collection, split by partition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: JString (required)
  ##              : Cosmos DB database rid.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   collectionRid: JString (required)
  ##                : Cosmos DB collection rid.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564392 = path.getOrDefault("subscriptionId")
  valid_564392 = validateParameter(valid_564392, JString, required = true,
                                 default = nil)
  if valid_564392 != nil:
    section.add "subscriptionId", valid_564392
  var valid_564393 = path.getOrDefault("databaseRid")
  valid_564393 = validateParameter(valid_564393, JString, required = true,
                                 default = nil)
  if valid_564393 != nil:
    section.add "databaseRid", valid_564393
  var valid_564394 = path.getOrDefault("resourceGroupName")
  valid_564394 = validateParameter(valid_564394, JString, required = true,
                                 default = nil)
  if valid_564394 != nil:
    section.add "resourceGroupName", valid_564394
  var valid_564395 = path.getOrDefault("collectionRid")
  valid_564395 = validateParameter(valid_564395, JString, required = true,
                                 default = nil)
  if valid_564395 != nil:
    section.add "collectionRid", valid_564395
  var valid_564396 = path.getOrDefault("accountName")
  valid_564396 = validateParameter(valid_564396, JString, required = true,
                                 default = nil)
  if valid_564396 != nil:
    section.add "accountName", valid_564396
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString
  ##          : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564397 = query.getOrDefault("api-version")
  valid_564397 = validateParameter(valid_564397, JString, required = true,
                                 default = nil)
  if valid_564397 != nil:
    section.add "api-version", valid_564397
  var valid_564398 = query.getOrDefault("$filter")
  valid_564398 = validateParameter(valid_564398, JString, required = false,
                                 default = nil)
  if valid_564398 != nil:
    section.add "$filter", valid_564398
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564399: Call_CollectionPartitionListUsages_564389; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the usages (most recent storage data) for the given collection, split by partition.
  ## 
  let valid = call_564399.validator(path, query, header, formData, body)
  let scheme = call_564399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564399.url(scheme.get, call_564399.host, call_564399.base,
                         call_564399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564399, url, valid)

proc call*(call_564400: Call_CollectionPartitionListUsages_564389;
          apiVersion: string; subscriptionId: string; databaseRid: string;
          resourceGroupName: string; collectionRid: string; accountName: string;
          Filter: string = ""): Recallable =
  ## collectionPartitionListUsages
  ## Retrieves the usages (most recent storage data) for the given collection, split by partition.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: string (required)
  ##              : Cosmos DB database rid.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   collectionRid: string (required)
  ##                : Cosmos DB collection rid.
  ##   Filter: string
  ##         : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564401 = newJObject()
  var query_564402 = newJObject()
  add(query_564402, "api-version", newJString(apiVersion))
  add(path_564401, "subscriptionId", newJString(subscriptionId))
  add(path_564401, "databaseRid", newJString(databaseRid))
  add(path_564401, "resourceGroupName", newJString(resourceGroupName))
  add(path_564401, "collectionRid", newJString(collectionRid))
  add(query_564402, "$filter", newJString(Filter))
  add(path_564401, "accountName", newJString(accountName))
  result = call_564400.call(path_564401, query_564402, nil, nil, nil)

var collectionPartitionListUsages* = Call_CollectionPartitionListUsages_564389(
    name: "collectionPartitionListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/partitions/usages",
    validator: validate_CollectionPartitionListUsages_564390, base: "",
    url: url_CollectionPartitionListUsages_564391, schemes: {Scheme.Https})
type
  Call_CollectionListUsages_564403 = ref object of OpenApiRestCall_563566
proc url_CollectionListUsages_564405(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseRid" in path, "`databaseRid` is a required path parameter"
  assert "collectionRid" in path, "`collectionRid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseRid"),
               (kind: ConstantSegment, value: "/collections/"),
               (kind: VariableSegment, value: "collectionRid"),
               (kind: ConstantSegment, value: "/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CollectionListUsages_564404(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the usages (most recent storage data) for the given collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: JString (required)
  ##              : Cosmos DB database rid.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   collectionRid: JString (required)
  ##                : Cosmos DB collection rid.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564406 = path.getOrDefault("subscriptionId")
  valid_564406 = validateParameter(valid_564406, JString, required = true,
                                 default = nil)
  if valid_564406 != nil:
    section.add "subscriptionId", valid_564406
  var valid_564407 = path.getOrDefault("databaseRid")
  valid_564407 = validateParameter(valid_564407, JString, required = true,
                                 default = nil)
  if valid_564407 != nil:
    section.add "databaseRid", valid_564407
  var valid_564408 = path.getOrDefault("resourceGroupName")
  valid_564408 = validateParameter(valid_564408, JString, required = true,
                                 default = nil)
  if valid_564408 != nil:
    section.add "resourceGroupName", valid_564408
  var valid_564409 = path.getOrDefault("collectionRid")
  valid_564409 = validateParameter(valid_564409, JString, required = true,
                                 default = nil)
  if valid_564409 != nil:
    section.add "collectionRid", valid_564409
  var valid_564410 = path.getOrDefault("accountName")
  valid_564410 = validateParameter(valid_564410, JString, required = true,
                                 default = nil)
  if valid_564410 != nil:
    section.add "accountName", valid_564410
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString
  ##          : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564411 = query.getOrDefault("api-version")
  valid_564411 = validateParameter(valid_564411, JString, required = true,
                                 default = nil)
  if valid_564411 != nil:
    section.add "api-version", valid_564411
  var valid_564412 = query.getOrDefault("$filter")
  valid_564412 = validateParameter(valid_564412, JString, required = false,
                                 default = nil)
  if valid_564412 != nil:
    section.add "$filter", valid_564412
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564413: Call_CollectionListUsages_564403; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the usages (most recent storage data) for the given collection.
  ## 
  let valid = call_564413.validator(path, query, header, formData, body)
  let scheme = call_564413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564413.url(scheme.get, call_564413.host, call_564413.base,
                         call_564413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564413, url, valid)

proc call*(call_564414: Call_CollectionListUsages_564403; apiVersion: string;
          subscriptionId: string; databaseRid: string; resourceGroupName: string;
          collectionRid: string; accountName: string; Filter: string = ""): Recallable =
  ## collectionListUsages
  ## Retrieves the usages (most recent storage data) for the given collection.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: string (required)
  ##              : Cosmos DB database rid.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   collectionRid: string (required)
  ##                : Cosmos DB collection rid.
  ##   Filter: string
  ##         : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564415 = newJObject()
  var query_564416 = newJObject()
  add(query_564416, "api-version", newJString(apiVersion))
  add(path_564415, "subscriptionId", newJString(subscriptionId))
  add(path_564415, "databaseRid", newJString(databaseRid))
  add(path_564415, "resourceGroupName", newJString(resourceGroupName))
  add(path_564415, "collectionRid", newJString(collectionRid))
  add(query_564416, "$filter", newJString(Filter))
  add(path_564415, "accountName", newJString(accountName))
  result = call_564414.call(path_564415, query_564416, nil, nil, nil)

var collectionListUsages* = Call_CollectionListUsages_564403(
    name: "collectionListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/usages",
    validator: validate_CollectionListUsages_564404, base: "",
    url: url_CollectionListUsages_564405, schemes: {Scheme.Https})
type
  Call_DatabaseListMetricDefinitions_564417 = ref object of OpenApiRestCall_563566
proc url_DatabaseListMetricDefinitions_564419(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseRid" in path, "`databaseRid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseRid"),
               (kind: ConstantSegment, value: "/metricDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseListMetricDefinitions_564418(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves metric definitions for the given database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: JString (required)
  ##              : Cosmos DB database rid.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564420 = path.getOrDefault("subscriptionId")
  valid_564420 = validateParameter(valid_564420, JString, required = true,
                                 default = nil)
  if valid_564420 != nil:
    section.add "subscriptionId", valid_564420
  var valid_564421 = path.getOrDefault("databaseRid")
  valid_564421 = validateParameter(valid_564421, JString, required = true,
                                 default = nil)
  if valid_564421 != nil:
    section.add "databaseRid", valid_564421
  var valid_564422 = path.getOrDefault("resourceGroupName")
  valid_564422 = validateParameter(valid_564422, JString, required = true,
                                 default = nil)
  if valid_564422 != nil:
    section.add "resourceGroupName", valid_564422
  var valid_564423 = path.getOrDefault("accountName")
  valid_564423 = validateParameter(valid_564423, JString, required = true,
                                 default = nil)
  if valid_564423 != nil:
    section.add "accountName", valid_564423
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564424 = query.getOrDefault("api-version")
  valid_564424 = validateParameter(valid_564424, JString, required = true,
                                 default = nil)
  if valid_564424 != nil:
    section.add "api-version", valid_564424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564425: Call_DatabaseListMetricDefinitions_564417; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves metric definitions for the given database.
  ## 
  let valid = call_564425.validator(path, query, header, formData, body)
  let scheme = call_564425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564425.url(scheme.get, call_564425.host, call_564425.base,
                         call_564425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564425, url, valid)

proc call*(call_564426: Call_DatabaseListMetricDefinitions_564417;
          apiVersion: string; subscriptionId: string; databaseRid: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## databaseListMetricDefinitions
  ## Retrieves metric definitions for the given database.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: string (required)
  ##              : Cosmos DB database rid.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564427 = newJObject()
  var query_564428 = newJObject()
  add(query_564428, "api-version", newJString(apiVersion))
  add(path_564427, "subscriptionId", newJString(subscriptionId))
  add(path_564427, "databaseRid", newJString(databaseRid))
  add(path_564427, "resourceGroupName", newJString(resourceGroupName))
  add(path_564427, "accountName", newJString(accountName))
  result = call_564426.call(path_564427, query_564428, nil, nil, nil)

var databaseListMetricDefinitions* = Call_DatabaseListMetricDefinitions_564417(
    name: "databaseListMetricDefinitions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/metricDefinitions",
    validator: validate_DatabaseListMetricDefinitions_564418, base: "",
    url: url_DatabaseListMetricDefinitions_564419, schemes: {Scheme.Https})
type
  Call_DatabaseListMetrics_564429 = ref object of OpenApiRestCall_563566
proc url_DatabaseListMetrics_564431(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseRid" in path, "`databaseRid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseRid"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseListMetrics_564430(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves the metrics determined by the given filter for the given database account and database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: JString (required)
  ##              : Cosmos DB database rid.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564432 = path.getOrDefault("subscriptionId")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "subscriptionId", valid_564432
  var valid_564433 = path.getOrDefault("databaseRid")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "databaseRid", valid_564433
  var valid_564434 = path.getOrDefault("resourceGroupName")
  valid_564434 = validateParameter(valid_564434, JString, required = true,
                                 default = nil)
  if valid_564434 != nil:
    section.add "resourceGroupName", valid_564434
  var valid_564435 = path.getOrDefault("accountName")
  valid_564435 = validateParameter(valid_564435, JString, required = true,
                                 default = nil)
  if valid_564435 != nil:
    section.add "accountName", valid_564435
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564436 = query.getOrDefault("api-version")
  valid_564436 = validateParameter(valid_564436, JString, required = true,
                                 default = nil)
  if valid_564436 != nil:
    section.add "api-version", valid_564436
  var valid_564437 = query.getOrDefault("$filter")
  valid_564437 = validateParameter(valid_564437, JString, required = true,
                                 default = nil)
  if valid_564437 != nil:
    section.add "$filter", valid_564437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564438: Call_DatabaseListMetrics_564429; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account and database.
  ## 
  let valid = call_564438.validator(path, query, header, formData, body)
  let scheme = call_564438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564438.url(scheme.get, call_564438.host, call_564438.base,
                         call_564438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564438, url, valid)

proc call*(call_564439: Call_DatabaseListMetrics_564429; apiVersion: string;
          subscriptionId: string; databaseRid: string; resourceGroupName: string;
          Filter: string; accountName: string): Recallable =
  ## databaseListMetrics
  ## Retrieves the metrics determined by the given filter for the given database account and database.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: string (required)
  ##              : Cosmos DB database rid.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564440 = newJObject()
  var query_564441 = newJObject()
  add(query_564441, "api-version", newJString(apiVersion))
  add(path_564440, "subscriptionId", newJString(subscriptionId))
  add(path_564440, "databaseRid", newJString(databaseRid))
  add(path_564440, "resourceGroupName", newJString(resourceGroupName))
  add(query_564441, "$filter", newJString(Filter))
  add(path_564440, "accountName", newJString(accountName))
  result = call_564439.call(path_564440, query_564441, nil, nil, nil)

var databaseListMetrics* = Call_DatabaseListMetrics_564429(
    name: "databaseListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/metrics",
    validator: validate_DatabaseListMetrics_564430, base: "",
    url: url_DatabaseListMetrics_564431, schemes: {Scheme.Https})
type
  Call_DatabaseListUsages_564442 = ref object of OpenApiRestCall_563566
proc url_DatabaseListUsages_564444(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseRid" in path, "`databaseRid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseRid"),
               (kind: ConstantSegment, value: "/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseListUsages_564443(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves the usages (most recent data) for the given database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: JString (required)
  ##              : Cosmos DB database rid.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564445 = path.getOrDefault("subscriptionId")
  valid_564445 = validateParameter(valid_564445, JString, required = true,
                                 default = nil)
  if valid_564445 != nil:
    section.add "subscriptionId", valid_564445
  var valid_564446 = path.getOrDefault("databaseRid")
  valid_564446 = validateParameter(valid_564446, JString, required = true,
                                 default = nil)
  if valid_564446 != nil:
    section.add "databaseRid", valid_564446
  var valid_564447 = path.getOrDefault("resourceGroupName")
  valid_564447 = validateParameter(valid_564447, JString, required = true,
                                 default = nil)
  if valid_564447 != nil:
    section.add "resourceGroupName", valid_564447
  var valid_564448 = path.getOrDefault("accountName")
  valid_564448 = validateParameter(valid_564448, JString, required = true,
                                 default = nil)
  if valid_564448 != nil:
    section.add "accountName", valid_564448
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString
  ##          : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564449 = query.getOrDefault("api-version")
  valid_564449 = validateParameter(valid_564449, JString, required = true,
                                 default = nil)
  if valid_564449 != nil:
    section.add "api-version", valid_564449
  var valid_564450 = query.getOrDefault("$filter")
  valid_564450 = validateParameter(valid_564450, JString, required = false,
                                 default = nil)
  if valid_564450 != nil:
    section.add "$filter", valid_564450
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564451: Call_DatabaseListUsages_564442; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the usages (most recent data) for the given database.
  ## 
  let valid = call_564451.validator(path, query, header, formData, body)
  let scheme = call_564451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564451.url(scheme.get, call_564451.host, call_564451.base,
                         call_564451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564451, url, valid)

proc call*(call_564452: Call_DatabaseListUsages_564442; apiVersion: string;
          subscriptionId: string; databaseRid: string; resourceGroupName: string;
          accountName: string; Filter: string = ""): Recallable =
  ## databaseListUsages
  ## Retrieves the usages (most recent data) for the given database.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: string (required)
  ##              : Cosmos DB database rid.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   Filter: string
  ##         : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564453 = newJObject()
  var query_564454 = newJObject()
  add(query_564454, "api-version", newJString(apiVersion))
  add(path_564453, "subscriptionId", newJString(subscriptionId))
  add(path_564453, "databaseRid", newJString(databaseRid))
  add(path_564453, "resourceGroupName", newJString(resourceGroupName))
  add(query_564454, "$filter", newJString(Filter))
  add(path_564453, "accountName", newJString(accountName))
  result = call_564452.call(path_564453, query_564454, nil, nil, nil)

var databaseListUsages* = Call_DatabaseListUsages_564442(
    name: "databaseListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/usages",
    validator: validate_DatabaseListUsages_564443, base: "",
    url: url_DatabaseListUsages_564444, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsFailoverPriorityChange_564455 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsFailoverPriorityChange_564457(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/failoverPriorityChange")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsFailoverPriorityChange_564456(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Changes the failover priority for the Azure Cosmos DB database account. A failover priority of 0 indicates a write region. The maximum value for a failover priority = (total number of regions - 1). Failover priority values must be unique for each of the regions in which the database account exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564475 = path.getOrDefault("subscriptionId")
  valid_564475 = validateParameter(valid_564475, JString, required = true,
                                 default = nil)
  if valid_564475 != nil:
    section.add "subscriptionId", valid_564475
  var valid_564476 = path.getOrDefault("resourceGroupName")
  valid_564476 = validateParameter(valid_564476, JString, required = true,
                                 default = nil)
  if valid_564476 != nil:
    section.add "resourceGroupName", valid_564476
  var valid_564477 = path.getOrDefault("accountName")
  valid_564477 = validateParameter(valid_564477, JString, required = true,
                                 default = nil)
  if valid_564477 != nil:
    section.add "accountName", valid_564477
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564478 = query.getOrDefault("api-version")
  valid_564478 = validateParameter(valid_564478, JString, required = true,
                                 default = nil)
  if valid_564478 != nil:
    section.add "api-version", valid_564478
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   failoverParameters: JObject (required)
  ##                     : The new failover policies for the database account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564480: Call_DatabaseAccountsFailoverPriorityChange_564455;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Changes the failover priority for the Azure Cosmos DB database account. A failover priority of 0 indicates a write region. The maximum value for a failover priority = (total number of regions - 1). Failover priority values must be unique for each of the regions in which the database account exists.
  ## 
  let valid = call_564480.validator(path, query, header, formData, body)
  let scheme = call_564480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564480.url(scheme.get, call_564480.host, call_564480.base,
                         call_564480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564480, url, valid)

proc call*(call_564481: Call_DatabaseAccountsFailoverPriorityChange_564455;
          apiVersion: string; subscriptionId: string; failoverParameters: JsonNode;
          resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsFailoverPriorityChange
  ## Changes the failover priority for the Azure Cosmos DB database account. A failover priority of 0 indicates a write region. The maximum value for a failover priority = (total number of regions - 1). Failover priority values must be unique for each of the regions in which the database account exists.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   failoverParameters: JObject (required)
  ##                     : The new failover policies for the database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564482 = newJObject()
  var query_564483 = newJObject()
  var body_564484 = newJObject()
  add(query_564483, "api-version", newJString(apiVersion))
  add(path_564482, "subscriptionId", newJString(subscriptionId))
  if failoverParameters != nil:
    body_564484 = failoverParameters
  add(path_564482, "resourceGroupName", newJString(resourceGroupName))
  add(path_564482, "accountName", newJString(accountName))
  result = call_564481.call(path_564482, query_564483, nil, nil, body_564484)

var databaseAccountsFailoverPriorityChange* = Call_DatabaseAccountsFailoverPriorityChange_564455(
    name: "databaseAccountsFailoverPriorityChange", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/failoverPriorityChange",
    validator: validate_DatabaseAccountsFailoverPriorityChange_564456, base: "",
    url: url_DatabaseAccountsFailoverPriorityChange_564457,
    schemes: {Scheme.Https})
type
  Call_GremlinResourcesListGremlinDatabases_564485 = ref object of OpenApiRestCall_563566
proc url_GremlinResourcesListGremlinDatabases_564487(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/gremlinDatabases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GremlinResourcesListGremlinDatabases_564486(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Gremlin databases under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564488 = path.getOrDefault("subscriptionId")
  valid_564488 = validateParameter(valid_564488, JString, required = true,
                                 default = nil)
  if valid_564488 != nil:
    section.add "subscriptionId", valid_564488
  var valid_564489 = path.getOrDefault("resourceGroupName")
  valid_564489 = validateParameter(valid_564489, JString, required = true,
                                 default = nil)
  if valid_564489 != nil:
    section.add "resourceGroupName", valid_564489
  var valid_564490 = path.getOrDefault("accountName")
  valid_564490 = validateParameter(valid_564490, JString, required = true,
                                 default = nil)
  if valid_564490 != nil:
    section.add "accountName", valid_564490
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564491 = query.getOrDefault("api-version")
  valid_564491 = validateParameter(valid_564491, JString, required = true,
                                 default = nil)
  if valid_564491 != nil:
    section.add "api-version", valid_564491
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564492: Call_GremlinResourcesListGremlinDatabases_564485;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Gremlin databases under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_564492.validator(path, query, header, formData, body)
  let scheme = call_564492.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564492.url(scheme.get, call_564492.host, call_564492.base,
                         call_564492.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564492, url, valid)

proc call*(call_564493: Call_GremlinResourcesListGremlinDatabases_564485;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## gremlinResourcesListGremlinDatabases
  ## Lists the Gremlin databases under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564494 = newJObject()
  var query_564495 = newJObject()
  add(query_564495, "api-version", newJString(apiVersion))
  add(path_564494, "subscriptionId", newJString(subscriptionId))
  add(path_564494, "resourceGroupName", newJString(resourceGroupName))
  add(path_564494, "accountName", newJString(accountName))
  result = call_564493.call(path_564494, query_564495, nil, nil, nil)

var gremlinResourcesListGremlinDatabases* = Call_GremlinResourcesListGremlinDatabases_564485(
    name: "gremlinResourcesListGremlinDatabases", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/gremlinDatabases",
    validator: validate_GremlinResourcesListGremlinDatabases_564486, base: "",
    url: url_GremlinResourcesListGremlinDatabases_564487, schemes: {Scheme.Https})
type
  Call_GremlinResourcesCreateUpdateGremlinDatabase_564508 = ref object of OpenApiRestCall_563566
proc url_GremlinResourcesCreateUpdateGremlinDatabase_564510(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/gremlinDatabases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GremlinResourcesCreateUpdateGremlinDatabase_564509(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an Azure Cosmos DB Gremlin database
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564511 = path.getOrDefault("subscriptionId")
  valid_564511 = validateParameter(valid_564511, JString, required = true,
                                 default = nil)
  if valid_564511 != nil:
    section.add "subscriptionId", valid_564511
  var valid_564512 = path.getOrDefault("databaseName")
  valid_564512 = validateParameter(valid_564512, JString, required = true,
                                 default = nil)
  if valid_564512 != nil:
    section.add "databaseName", valid_564512
  var valid_564513 = path.getOrDefault("resourceGroupName")
  valid_564513 = validateParameter(valid_564513, JString, required = true,
                                 default = nil)
  if valid_564513 != nil:
    section.add "resourceGroupName", valid_564513
  var valid_564514 = path.getOrDefault("accountName")
  valid_564514 = validateParameter(valid_564514, JString, required = true,
                                 default = nil)
  if valid_564514 != nil:
    section.add "accountName", valid_564514
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564515 = query.getOrDefault("api-version")
  valid_564515 = validateParameter(valid_564515, JString, required = true,
                                 default = nil)
  if valid_564515 != nil:
    section.add "api-version", valid_564515
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   createUpdateGremlinDatabaseParameters: JObject (required)
  ##                                        : The parameters to provide for the current Gremlin database.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564517: Call_GremlinResourcesCreateUpdateGremlinDatabase_564508;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB Gremlin database
  ## 
  let valid = call_564517.validator(path, query, header, formData, body)
  let scheme = call_564517.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564517.url(scheme.get, call_564517.host, call_564517.base,
                         call_564517.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564517, url, valid)

proc call*(call_564518: Call_GremlinResourcesCreateUpdateGremlinDatabase_564508;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string;
          createUpdateGremlinDatabaseParameters: JsonNode; accountName: string): Recallable =
  ## gremlinResourcesCreateUpdateGremlinDatabase
  ## Create or update an Azure Cosmos DB Gremlin database
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   createUpdateGremlinDatabaseParameters: JObject (required)
  ##                                        : The parameters to provide for the current Gremlin database.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564519 = newJObject()
  var query_564520 = newJObject()
  var body_564521 = newJObject()
  add(query_564520, "api-version", newJString(apiVersion))
  add(path_564519, "subscriptionId", newJString(subscriptionId))
  add(path_564519, "databaseName", newJString(databaseName))
  add(path_564519, "resourceGroupName", newJString(resourceGroupName))
  if createUpdateGremlinDatabaseParameters != nil:
    body_564521 = createUpdateGremlinDatabaseParameters
  add(path_564519, "accountName", newJString(accountName))
  result = call_564518.call(path_564519, query_564520, nil, nil, body_564521)

var gremlinResourcesCreateUpdateGremlinDatabase* = Call_GremlinResourcesCreateUpdateGremlinDatabase_564508(
    name: "gremlinResourcesCreateUpdateGremlinDatabase", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/gremlinDatabases/{databaseName}",
    validator: validate_GremlinResourcesCreateUpdateGremlinDatabase_564509,
    base: "", url: url_GremlinResourcesCreateUpdateGremlinDatabase_564510,
    schemes: {Scheme.Https})
type
  Call_GremlinResourcesGetGremlinDatabase_564496 = ref object of OpenApiRestCall_563566
proc url_GremlinResourcesGetGremlinDatabase_564498(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/gremlinDatabases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GremlinResourcesGetGremlinDatabase_564497(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Gremlin databases under an existing Azure Cosmos DB database account with the provided name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564499 = path.getOrDefault("subscriptionId")
  valid_564499 = validateParameter(valid_564499, JString, required = true,
                                 default = nil)
  if valid_564499 != nil:
    section.add "subscriptionId", valid_564499
  var valid_564500 = path.getOrDefault("databaseName")
  valid_564500 = validateParameter(valid_564500, JString, required = true,
                                 default = nil)
  if valid_564500 != nil:
    section.add "databaseName", valid_564500
  var valid_564501 = path.getOrDefault("resourceGroupName")
  valid_564501 = validateParameter(valid_564501, JString, required = true,
                                 default = nil)
  if valid_564501 != nil:
    section.add "resourceGroupName", valid_564501
  var valid_564502 = path.getOrDefault("accountName")
  valid_564502 = validateParameter(valid_564502, JString, required = true,
                                 default = nil)
  if valid_564502 != nil:
    section.add "accountName", valid_564502
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564503 = query.getOrDefault("api-version")
  valid_564503 = validateParameter(valid_564503, JString, required = true,
                                 default = nil)
  if valid_564503 != nil:
    section.add "api-version", valid_564503
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564504: Call_GremlinResourcesGetGremlinDatabase_564496;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the Gremlin databases under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_564504.validator(path, query, header, formData, body)
  let scheme = call_564504.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564504.url(scheme.get, call_564504.host, call_564504.base,
                         call_564504.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564504, url, valid)

proc call*(call_564505: Call_GremlinResourcesGetGremlinDatabase_564496;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## gremlinResourcesGetGremlinDatabase
  ## Gets the Gremlin databases under an existing Azure Cosmos DB database account with the provided name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564506 = newJObject()
  var query_564507 = newJObject()
  add(query_564507, "api-version", newJString(apiVersion))
  add(path_564506, "subscriptionId", newJString(subscriptionId))
  add(path_564506, "databaseName", newJString(databaseName))
  add(path_564506, "resourceGroupName", newJString(resourceGroupName))
  add(path_564506, "accountName", newJString(accountName))
  result = call_564505.call(path_564506, query_564507, nil, nil, nil)

var gremlinResourcesGetGremlinDatabase* = Call_GremlinResourcesGetGremlinDatabase_564496(
    name: "gremlinResourcesGetGremlinDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/gremlinDatabases/{databaseName}",
    validator: validate_GremlinResourcesGetGremlinDatabase_564497, base: "",
    url: url_GremlinResourcesGetGremlinDatabase_564498, schemes: {Scheme.Https})
type
  Call_GremlinResourcesDeleteGremlinDatabase_564522 = ref object of OpenApiRestCall_563566
proc url_GremlinResourcesDeleteGremlinDatabase_564524(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/gremlinDatabases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GremlinResourcesDeleteGremlinDatabase_564523(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Azure Cosmos DB Gremlin database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564525 = path.getOrDefault("subscriptionId")
  valid_564525 = validateParameter(valid_564525, JString, required = true,
                                 default = nil)
  if valid_564525 != nil:
    section.add "subscriptionId", valid_564525
  var valid_564526 = path.getOrDefault("databaseName")
  valid_564526 = validateParameter(valid_564526, JString, required = true,
                                 default = nil)
  if valid_564526 != nil:
    section.add "databaseName", valid_564526
  var valid_564527 = path.getOrDefault("resourceGroupName")
  valid_564527 = validateParameter(valid_564527, JString, required = true,
                                 default = nil)
  if valid_564527 != nil:
    section.add "resourceGroupName", valid_564527
  var valid_564528 = path.getOrDefault("accountName")
  valid_564528 = validateParameter(valid_564528, JString, required = true,
                                 default = nil)
  if valid_564528 != nil:
    section.add "accountName", valid_564528
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564529 = query.getOrDefault("api-version")
  valid_564529 = validateParameter(valid_564529, JString, required = true,
                                 default = nil)
  if valid_564529 != nil:
    section.add "api-version", valid_564529
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564530: Call_GremlinResourcesDeleteGremlinDatabase_564522;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB Gremlin database.
  ## 
  let valid = call_564530.validator(path, query, header, formData, body)
  let scheme = call_564530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564530.url(scheme.get, call_564530.host, call_564530.base,
                         call_564530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564530, url, valid)

proc call*(call_564531: Call_GremlinResourcesDeleteGremlinDatabase_564522;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## gremlinResourcesDeleteGremlinDatabase
  ## Deletes an existing Azure Cosmos DB Gremlin database.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564532 = newJObject()
  var query_564533 = newJObject()
  add(query_564533, "api-version", newJString(apiVersion))
  add(path_564532, "subscriptionId", newJString(subscriptionId))
  add(path_564532, "databaseName", newJString(databaseName))
  add(path_564532, "resourceGroupName", newJString(resourceGroupName))
  add(path_564532, "accountName", newJString(accountName))
  result = call_564531.call(path_564532, query_564533, nil, nil, nil)

var gremlinResourcesDeleteGremlinDatabase* = Call_GremlinResourcesDeleteGremlinDatabase_564522(
    name: "gremlinResourcesDeleteGremlinDatabase", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/gremlinDatabases/{databaseName}",
    validator: validate_GremlinResourcesDeleteGremlinDatabase_564523, base: "",
    url: url_GremlinResourcesDeleteGremlinDatabase_564524, schemes: {Scheme.Https})
type
  Call_GremlinResourcesListGremlinGraphs_564534 = ref object of OpenApiRestCall_563566
proc url_GremlinResourcesListGremlinGraphs_564536(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/gremlinDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/graphs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GremlinResourcesListGremlinGraphs_564535(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Gremlin graph under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564537 = path.getOrDefault("subscriptionId")
  valid_564537 = validateParameter(valid_564537, JString, required = true,
                                 default = nil)
  if valid_564537 != nil:
    section.add "subscriptionId", valid_564537
  var valid_564538 = path.getOrDefault("databaseName")
  valid_564538 = validateParameter(valid_564538, JString, required = true,
                                 default = nil)
  if valid_564538 != nil:
    section.add "databaseName", valid_564538
  var valid_564539 = path.getOrDefault("resourceGroupName")
  valid_564539 = validateParameter(valid_564539, JString, required = true,
                                 default = nil)
  if valid_564539 != nil:
    section.add "resourceGroupName", valid_564539
  var valid_564540 = path.getOrDefault("accountName")
  valid_564540 = validateParameter(valid_564540, JString, required = true,
                                 default = nil)
  if valid_564540 != nil:
    section.add "accountName", valid_564540
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564541 = query.getOrDefault("api-version")
  valid_564541 = validateParameter(valid_564541, JString, required = true,
                                 default = nil)
  if valid_564541 != nil:
    section.add "api-version", valid_564541
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564542: Call_GremlinResourcesListGremlinGraphs_564534;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Gremlin graph under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_564542.validator(path, query, header, formData, body)
  let scheme = call_564542.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564542.url(scheme.get, call_564542.host, call_564542.base,
                         call_564542.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564542, url, valid)

proc call*(call_564543: Call_GremlinResourcesListGremlinGraphs_564534;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## gremlinResourcesListGremlinGraphs
  ## Lists the Gremlin graph under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564544 = newJObject()
  var query_564545 = newJObject()
  add(query_564545, "api-version", newJString(apiVersion))
  add(path_564544, "subscriptionId", newJString(subscriptionId))
  add(path_564544, "databaseName", newJString(databaseName))
  add(path_564544, "resourceGroupName", newJString(resourceGroupName))
  add(path_564544, "accountName", newJString(accountName))
  result = call_564543.call(path_564544, query_564545, nil, nil, nil)

var gremlinResourcesListGremlinGraphs* = Call_GremlinResourcesListGremlinGraphs_564534(
    name: "gremlinResourcesListGremlinGraphs", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/gremlinDatabases/{databaseName}/graphs",
    validator: validate_GremlinResourcesListGremlinGraphs_564535, base: "",
    url: url_GremlinResourcesListGremlinGraphs_564536, schemes: {Scheme.Https})
type
  Call_GremlinResourcesCreateUpdateGremlinGraph_564559 = ref object of OpenApiRestCall_563566
proc url_GremlinResourcesCreateUpdateGremlinGraph_564561(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "graphName" in path, "`graphName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/gremlinDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/graphs/"),
               (kind: VariableSegment, value: "graphName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GremlinResourcesCreateUpdateGremlinGraph_564560(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an Azure Cosmos DB Gremlin graph
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   graphName: JString (required)
  ##            : Cosmos DB graph name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `graphName` field"
  var valid_564562 = path.getOrDefault("graphName")
  valid_564562 = validateParameter(valid_564562, JString, required = true,
                                 default = nil)
  if valid_564562 != nil:
    section.add "graphName", valid_564562
  var valid_564563 = path.getOrDefault("subscriptionId")
  valid_564563 = validateParameter(valid_564563, JString, required = true,
                                 default = nil)
  if valid_564563 != nil:
    section.add "subscriptionId", valid_564563
  var valid_564564 = path.getOrDefault("databaseName")
  valid_564564 = validateParameter(valid_564564, JString, required = true,
                                 default = nil)
  if valid_564564 != nil:
    section.add "databaseName", valid_564564
  var valid_564565 = path.getOrDefault("resourceGroupName")
  valid_564565 = validateParameter(valid_564565, JString, required = true,
                                 default = nil)
  if valid_564565 != nil:
    section.add "resourceGroupName", valid_564565
  var valid_564566 = path.getOrDefault("accountName")
  valid_564566 = validateParameter(valid_564566, JString, required = true,
                                 default = nil)
  if valid_564566 != nil:
    section.add "accountName", valid_564566
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564567 = query.getOrDefault("api-version")
  valid_564567 = validateParameter(valid_564567, JString, required = true,
                                 default = nil)
  if valid_564567 != nil:
    section.add "api-version", valid_564567
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   createUpdateGremlinGraphParameters: JObject (required)
  ##                                     : The parameters to provide for the current Gremlin graph.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564569: Call_GremlinResourcesCreateUpdateGremlinGraph_564559;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB Gremlin graph
  ## 
  let valid = call_564569.validator(path, query, header, formData, body)
  let scheme = call_564569.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564569.url(scheme.get, call_564569.host, call_564569.base,
                         call_564569.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564569, url, valid)

proc call*(call_564570: Call_GremlinResourcesCreateUpdateGremlinGraph_564559;
          apiVersion: string; graphName: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string;
          createUpdateGremlinGraphParameters: JsonNode; accountName: string): Recallable =
  ## gremlinResourcesCreateUpdateGremlinGraph
  ## Create or update an Azure Cosmos DB Gremlin graph
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   graphName: string (required)
  ##            : Cosmos DB graph name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   createUpdateGremlinGraphParameters: JObject (required)
  ##                                     : The parameters to provide for the current Gremlin graph.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564571 = newJObject()
  var query_564572 = newJObject()
  var body_564573 = newJObject()
  add(query_564572, "api-version", newJString(apiVersion))
  add(path_564571, "graphName", newJString(graphName))
  add(path_564571, "subscriptionId", newJString(subscriptionId))
  add(path_564571, "databaseName", newJString(databaseName))
  add(path_564571, "resourceGroupName", newJString(resourceGroupName))
  if createUpdateGremlinGraphParameters != nil:
    body_564573 = createUpdateGremlinGraphParameters
  add(path_564571, "accountName", newJString(accountName))
  result = call_564570.call(path_564571, query_564572, nil, nil, body_564573)

var gremlinResourcesCreateUpdateGremlinGraph* = Call_GremlinResourcesCreateUpdateGremlinGraph_564559(
    name: "gremlinResourcesCreateUpdateGremlinGraph", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/gremlinDatabases/{databaseName}/graphs/{graphName}",
    validator: validate_GremlinResourcesCreateUpdateGremlinGraph_564560, base: "",
    url: url_GremlinResourcesCreateUpdateGremlinGraph_564561,
    schemes: {Scheme.Https})
type
  Call_GremlinResourcesGetGremlinGraph_564546 = ref object of OpenApiRestCall_563566
proc url_GremlinResourcesGetGremlinGraph_564548(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "graphName" in path, "`graphName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/gremlinDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/graphs/"),
               (kind: VariableSegment, value: "graphName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GremlinResourcesGetGremlinGraph_564547(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Gremlin graph under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   graphName: JString (required)
  ##            : Cosmos DB graph name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `graphName` field"
  var valid_564549 = path.getOrDefault("graphName")
  valid_564549 = validateParameter(valid_564549, JString, required = true,
                                 default = nil)
  if valid_564549 != nil:
    section.add "graphName", valid_564549
  var valid_564550 = path.getOrDefault("subscriptionId")
  valid_564550 = validateParameter(valid_564550, JString, required = true,
                                 default = nil)
  if valid_564550 != nil:
    section.add "subscriptionId", valid_564550
  var valid_564551 = path.getOrDefault("databaseName")
  valid_564551 = validateParameter(valid_564551, JString, required = true,
                                 default = nil)
  if valid_564551 != nil:
    section.add "databaseName", valid_564551
  var valid_564552 = path.getOrDefault("resourceGroupName")
  valid_564552 = validateParameter(valid_564552, JString, required = true,
                                 default = nil)
  if valid_564552 != nil:
    section.add "resourceGroupName", valid_564552
  var valid_564553 = path.getOrDefault("accountName")
  valid_564553 = validateParameter(valid_564553, JString, required = true,
                                 default = nil)
  if valid_564553 != nil:
    section.add "accountName", valid_564553
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564554 = query.getOrDefault("api-version")
  valid_564554 = validateParameter(valid_564554, JString, required = true,
                                 default = nil)
  if valid_564554 != nil:
    section.add "api-version", valid_564554
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564555: Call_GremlinResourcesGetGremlinGraph_564546;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the Gremlin graph under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_564555.validator(path, query, header, formData, body)
  let scheme = call_564555.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564555.url(scheme.get, call_564555.host, call_564555.base,
                         call_564555.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564555, url, valid)

proc call*(call_564556: Call_GremlinResourcesGetGremlinGraph_564546;
          apiVersion: string; graphName: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string; accountName: string): Recallable =
  ## gremlinResourcesGetGremlinGraph
  ## Gets the Gremlin graph under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   graphName: string (required)
  ##            : Cosmos DB graph name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564557 = newJObject()
  var query_564558 = newJObject()
  add(query_564558, "api-version", newJString(apiVersion))
  add(path_564557, "graphName", newJString(graphName))
  add(path_564557, "subscriptionId", newJString(subscriptionId))
  add(path_564557, "databaseName", newJString(databaseName))
  add(path_564557, "resourceGroupName", newJString(resourceGroupName))
  add(path_564557, "accountName", newJString(accountName))
  result = call_564556.call(path_564557, query_564558, nil, nil, nil)

var gremlinResourcesGetGremlinGraph* = Call_GremlinResourcesGetGremlinGraph_564546(
    name: "gremlinResourcesGetGremlinGraph", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/gremlinDatabases/{databaseName}/graphs/{graphName}",
    validator: validate_GremlinResourcesGetGremlinGraph_564547, base: "",
    url: url_GremlinResourcesGetGremlinGraph_564548, schemes: {Scheme.Https})
type
  Call_GremlinResourcesDeleteGremlinGraph_564574 = ref object of OpenApiRestCall_563566
proc url_GremlinResourcesDeleteGremlinGraph_564576(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "graphName" in path, "`graphName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/gremlinDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/graphs/"),
               (kind: VariableSegment, value: "graphName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GremlinResourcesDeleteGremlinGraph_564575(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Azure Cosmos DB Gremlin graph.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   graphName: JString (required)
  ##            : Cosmos DB graph name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `graphName` field"
  var valid_564577 = path.getOrDefault("graphName")
  valid_564577 = validateParameter(valid_564577, JString, required = true,
                                 default = nil)
  if valid_564577 != nil:
    section.add "graphName", valid_564577
  var valid_564578 = path.getOrDefault("subscriptionId")
  valid_564578 = validateParameter(valid_564578, JString, required = true,
                                 default = nil)
  if valid_564578 != nil:
    section.add "subscriptionId", valid_564578
  var valid_564579 = path.getOrDefault("databaseName")
  valid_564579 = validateParameter(valid_564579, JString, required = true,
                                 default = nil)
  if valid_564579 != nil:
    section.add "databaseName", valid_564579
  var valid_564580 = path.getOrDefault("resourceGroupName")
  valid_564580 = validateParameter(valid_564580, JString, required = true,
                                 default = nil)
  if valid_564580 != nil:
    section.add "resourceGroupName", valid_564580
  var valid_564581 = path.getOrDefault("accountName")
  valid_564581 = validateParameter(valid_564581, JString, required = true,
                                 default = nil)
  if valid_564581 != nil:
    section.add "accountName", valid_564581
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564582 = query.getOrDefault("api-version")
  valid_564582 = validateParameter(valid_564582, JString, required = true,
                                 default = nil)
  if valid_564582 != nil:
    section.add "api-version", valid_564582
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564583: Call_GremlinResourcesDeleteGremlinGraph_564574;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB Gremlin graph.
  ## 
  let valid = call_564583.validator(path, query, header, formData, body)
  let scheme = call_564583.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564583.url(scheme.get, call_564583.host, call_564583.base,
                         call_564583.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564583, url, valid)

proc call*(call_564584: Call_GremlinResourcesDeleteGremlinGraph_564574;
          apiVersion: string; graphName: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string; accountName: string): Recallable =
  ## gremlinResourcesDeleteGremlinGraph
  ## Deletes an existing Azure Cosmos DB Gremlin graph.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   graphName: string (required)
  ##            : Cosmos DB graph name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564585 = newJObject()
  var query_564586 = newJObject()
  add(query_564586, "api-version", newJString(apiVersion))
  add(path_564585, "graphName", newJString(graphName))
  add(path_564585, "subscriptionId", newJString(subscriptionId))
  add(path_564585, "databaseName", newJString(databaseName))
  add(path_564585, "resourceGroupName", newJString(resourceGroupName))
  add(path_564585, "accountName", newJString(accountName))
  result = call_564584.call(path_564585, query_564586, nil, nil, nil)

var gremlinResourcesDeleteGremlinGraph* = Call_GremlinResourcesDeleteGremlinGraph_564574(
    name: "gremlinResourcesDeleteGremlinGraph", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/gremlinDatabases/{databaseName}/graphs/{graphName}",
    validator: validate_GremlinResourcesDeleteGremlinGraph_564575, base: "",
    url: url_GremlinResourcesDeleteGremlinGraph_564576, schemes: {Scheme.Https})
type
  Call_GremlinResourcesUpdateGremlinGraphThroughput_564600 = ref object of OpenApiRestCall_563566
proc url_GremlinResourcesUpdateGremlinGraphThroughput_564602(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "graphName" in path, "`graphName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/gremlinDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/graphs/"),
               (kind: VariableSegment, value: "graphName"),
               (kind: ConstantSegment, value: "/throughputSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GremlinResourcesUpdateGremlinGraphThroughput_564601(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update RUs per second of an Azure Cosmos DB Gremlin graph
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   graphName: JString (required)
  ##            : Cosmos DB graph name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `graphName` field"
  var valid_564603 = path.getOrDefault("graphName")
  valid_564603 = validateParameter(valid_564603, JString, required = true,
                                 default = nil)
  if valid_564603 != nil:
    section.add "graphName", valid_564603
  var valid_564604 = path.getOrDefault("subscriptionId")
  valid_564604 = validateParameter(valid_564604, JString, required = true,
                                 default = nil)
  if valid_564604 != nil:
    section.add "subscriptionId", valid_564604
  var valid_564605 = path.getOrDefault("databaseName")
  valid_564605 = validateParameter(valid_564605, JString, required = true,
                                 default = nil)
  if valid_564605 != nil:
    section.add "databaseName", valid_564605
  var valid_564606 = path.getOrDefault("resourceGroupName")
  valid_564606 = validateParameter(valid_564606, JString, required = true,
                                 default = nil)
  if valid_564606 != nil:
    section.add "resourceGroupName", valid_564606
  var valid_564607 = path.getOrDefault("accountName")
  valid_564607 = validateParameter(valid_564607, JString, required = true,
                                 default = nil)
  if valid_564607 != nil:
    section.add "accountName", valid_564607
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564608 = query.getOrDefault("api-version")
  valid_564608 = validateParameter(valid_564608, JString, required = true,
                                 default = nil)
  if valid_564608 != nil:
    section.add "api-version", valid_564608
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   updateThroughputParameters: JObject (required)
  ##                             : The RUs per second of the parameters to provide for the current Gremlin graph.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564610: Call_GremlinResourcesUpdateGremlinGraphThroughput_564600;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Gremlin graph
  ## 
  let valid = call_564610.validator(path, query, header, formData, body)
  let scheme = call_564610.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564610.url(scheme.get, call_564610.host, call_564610.base,
                         call_564610.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564610, url, valid)

proc call*(call_564611: Call_GremlinResourcesUpdateGremlinGraphThroughput_564600;
          apiVersion: string; graphName: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string; accountName: string;
          updateThroughputParameters: JsonNode): Recallable =
  ## gremlinResourcesUpdateGremlinGraphThroughput
  ## Update RUs per second of an Azure Cosmos DB Gremlin graph
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   graphName: string (required)
  ##            : Cosmos DB graph name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   updateThroughputParameters: JObject (required)
  ##                             : The RUs per second of the parameters to provide for the current Gremlin graph.
  var path_564612 = newJObject()
  var query_564613 = newJObject()
  var body_564614 = newJObject()
  add(query_564613, "api-version", newJString(apiVersion))
  add(path_564612, "graphName", newJString(graphName))
  add(path_564612, "subscriptionId", newJString(subscriptionId))
  add(path_564612, "databaseName", newJString(databaseName))
  add(path_564612, "resourceGroupName", newJString(resourceGroupName))
  add(path_564612, "accountName", newJString(accountName))
  if updateThroughputParameters != nil:
    body_564614 = updateThroughputParameters
  result = call_564611.call(path_564612, query_564613, nil, nil, body_564614)

var gremlinResourcesUpdateGremlinGraphThroughput* = Call_GremlinResourcesUpdateGremlinGraphThroughput_564600(
    name: "gremlinResourcesUpdateGremlinGraphThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/gremlinDatabases/{databaseName}/graphs/{graphName}/throughputSettings/default",
    validator: validate_GremlinResourcesUpdateGremlinGraphThroughput_564601,
    base: "", url: url_GremlinResourcesUpdateGremlinGraphThroughput_564602,
    schemes: {Scheme.Https})
type
  Call_GremlinResourcesGetGremlinGraphThroughput_564587 = ref object of OpenApiRestCall_563566
proc url_GremlinResourcesGetGremlinGraphThroughput_564589(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "graphName" in path, "`graphName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/gremlinDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/graphs/"),
               (kind: VariableSegment, value: "graphName"),
               (kind: ConstantSegment, value: "/throughputSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GremlinResourcesGetGremlinGraphThroughput_564588(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Gremlin graph throughput under an existing Azure Cosmos DB database account with the provided name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   graphName: JString (required)
  ##            : Cosmos DB graph name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `graphName` field"
  var valid_564590 = path.getOrDefault("graphName")
  valid_564590 = validateParameter(valid_564590, JString, required = true,
                                 default = nil)
  if valid_564590 != nil:
    section.add "graphName", valid_564590
  var valid_564591 = path.getOrDefault("subscriptionId")
  valid_564591 = validateParameter(valid_564591, JString, required = true,
                                 default = nil)
  if valid_564591 != nil:
    section.add "subscriptionId", valid_564591
  var valid_564592 = path.getOrDefault("databaseName")
  valid_564592 = validateParameter(valid_564592, JString, required = true,
                                 default = nil)
  if valid_564592 != nil:
    section.add "databaseName", valid_564592
  var valid_564593 = path.getOrDefault("resourceGroupName")
  valid_564593 = validateParameter(valid_564593, JString, required = true,
                                 default = nil)
  if valid_564593 != nil:
    section.add "resourceGroupName", valid_564593
  var valid_564594 = path.getOrDefault("accountName")
  valid_564594 = validateParameter(valid_564594, JString, required = true,
                                 default = nil)
  if valid_564594 != nil:
    section.add "accountName", valid_564594
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564595 = query.getOrDefault("api-version")
  valid_564595 = validateParameter(valid_564595, JString, required = true,
                                 default = nil)
  if valid_564595 != nil:
    section.add "api-version", valid_564595
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564596: Call_GremlinResourcesGetGremlinGraphThroughput_564587;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the Gremlin graph throughput under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_564596.validator(path, query, header, formData, body)
  let scheme = call_564596.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564596.url(scheme.get, call_564596.host, call_564596.base,
                         call_564596.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564596, url, valid)

proc call*(call_564597: Call_GremlinResourcesGetGremlinGraphThroughput_564587;
          apiVersion: string; graphName: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string; accountName: string): Recallable =
  ## gremlinResourcesGetGremlinGraphThroughput
  ## Gets the Gremlin graph throughput under an existing Azure Cosmos DB database account with the provided name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   graphName: string (required)
  ##            : Cosmos DB graph name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564598 = newJObject()
  var query_564599 = newJObject()
  add(query_564599, "api-version", newJString(apiVersion))
  add(path_564598, "graphName", newJString(graphName))
  add(path_564598, "subscriptionId", newJString(subscriptionId))
  add(path_564598, "databaseName", newJString(databaseName))
  add(path_564598, "resourceGroupName", newJString(resourceGroupName))
  add(path_564598, "accountName", newJString(accountName))
  result = call_564597.call(path_564598, query_564599, nil, nil, nil)

var gremlinResourcesGetGremlinGraphThroughput* = Call_GremlinResourcesGetGremlinGraphThroughput_564587(
    name: "gremlinResourcesGetGremlinGraphThroughput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/gremlinDatabases/{databaseName}/graphs/{graphName}/throughputSettings/default",
    validator: validate_GremlinResourcesGetGremlinGraphThroughput_564588,
    base: "", url: url_GremlinResourcesGetGremlinGraphThroughput_564589,
    schemes: {Scheme.Https})
type
  Call_GremlinResourcesUpdateGremlinDatabaseThroughput_564627 = ref object of OpenApiRestCall_563566
proc url_GremlinResourcesUpdateGremlinDatabaseThroughput_564629(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/gremlinDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/throughputSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GremlinResourcesUpdateGremlinDatabaseThroughput_564628(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Update RUs per second of an Azure Cosmos DB Gremlin database
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564630 = path.getOrDefault("subscriptionId")
  valid_564630 = validateParameter(valid_564630, JString, required = true,
                                 default = nil)
  if valid_564630 != nil:
    section.add "subscriptionId", valid_564630
  var valid_564631 = path.getOrDefault("databaseName")
  valid_564631 = validateParameter(valid_564631, JString, required = true,
                                 default = nil)
  if valid_564631 != nil:
    section.add "databaseName", valid_564631
  var valid_564632 = path.getOrDefault("resourceGroupName")
  valid_564632 = validateParameter(valid_564632, JString, required = true,
                                 default = nil)
  if valid_564632 != nil:
    section.add "resourceGroupName", valid_564632
  var valid_564633 = path.getOrDefault("accountName")
  valid_564633 = validateParameter(valid_564633, JString, required = true,
                                 default = nil)
  if valid_564633 != nil:
    section.add "accountName", valid_564633
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564634 = query.getOrDefault("api-version")
  valid_564634 = validateParameter(valid_564634, JString, required = true,
                                 default = nil)
  if valid_564634 != nil:
    section.add "api-version", valid_564634
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   updateThroughputParameters: JObject (required)
  ##                             : The RUs per second of the parameters to provide for the current Gremlin database.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564636: Call_GremlinResourcesUpdateGremlinDatabaseThroughput_564627;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Gremlin database
  ## 
  let valid = call_564636.validator(path, query, header, formData, body)
  let scheme = call_564636.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564636.url(scheme.get, call_564636.host, call_564636.base,
                         call_564636.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564636, url, valid)

proc call*(call_564637: Call_GremlinResourcesUpdateGremlinDatabaseThroughput_564627;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; accountName: string;
          updateThroughputParameters: JsonNode): Recallable =
  ## gremlinResourcesUpdateGremlinDatabaseThroughput
  ## Update RUs per second of an Azure Cosmos DB Gremlin database
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   updateThroughputParameters: JObject (required)
  ##                             : The RUs per second of the parameters to provide for the current Gremlin database.
  var path_564638 = newJObject()
  var query_564639 = newJObject()
  var body_564640 = newJObject()
  add(query_564639, "api-version", newJString(apiVersion))
  add(path_564638, "subscriptionId", newJString(subscriptionId))
  add(path_564638, "databaseName", newJString(databaseName))
  add(path_564638, "resourceGroupName", newJString(resourceGroupName))
  add(path_564638, "accountName", newJString(accountName))
  if updateThroughputParameters != nil:
    body_564640 = updateThroughputParameters
  result = call_564637.call(path_564638, query_564639, nil, nil, body_564640)

var gremlinResourcesUpdateGremlinDatabaseThroughput* = Call_GremlinResourcesUpdateGremlinDatabaseThroughput_564627(
    name: "gremlinResourcesUpdateGremlinDatabaseThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/gremlinDatabases/{databaseName}/throughputSettings/default",
    validator: validate_GremlinResourcesUpdateGremlinDatabaseThroughput_564628,
    base: "", url: url_GremlinResourcesUpdateGremlinDatabaseThroughput_564629,
    schemes: {Scheme.Https})
type
  Call_GremlinResourcesGetGremlinDatabaseThroughput_564615 = ref object of OpenApiRestCall_563566
proc url_GremlinResourcesGetGremlinDatabaseThroughput_564617(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/gremlinDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/throughputSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GremlinResourcesGetGremlinDatabaseThroughput_564616(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the RUs per second of the Gremlin database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564618 = path.getOrDefault("subscriptionId")
  valid_564618 = validateParameter(valid_564618, JString, required = true,
                                 default = nil)
  if valid_564618 != nil:
    section.add "subscriptionId", valid_564618
  var valid_564619 = path.getOrDefault("databaseName")
  valid_564619 = validateParameter(valid_564619, JString, required = true,
                                 default = nil)
  if valid_564619 != nil:
    section.add "databaseName", valid_564619
  var valid_564620 = path.getOrDefault("resourceGroupName")
  valid_564620 = validateParameter(valid_564620, JString, required = true,
                                 default = nil)
  if valid_564620 != nil:
    section.add "resourceGroupName", valid_564620
  var valid_564621 = path.getOrDefault("accountName")
  valid_564621 = validateParameter(valid_564621, JString, required = true,
                                 default = nil)
  if valid_564621 != nil:
    section.add "accountName", valid_564621
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564622 = query.getOrDefault("api-version")
  valid_564622 = validateParameter(valid_564622, JString, required = true,
                                 default = nil)
  if valid_564622 != nil:
    section.add "api-version", valid_564622
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564623: Call_GremlinResourcesGetGremlinDatabaseThroughput_564615;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the Gremlin database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_564623.validator(path, query, header, formData, body)
  let scheme = call_564623.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564623.url(scheme.get, call_564623.host, call_564623.base,
                         call_564623.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564623, url, valid)

proc call*(call_564624: Call_GremlinResourcesGetGremlinDatabaseThroughput_564615;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## gremlinResourcesGetGremlinDatabaseThroughput
  ## Gets the RUs per second of the Gremlin database under an existing Azure Cosmos DB database account with the provided name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564625 = newJObject()
  var query_564626 = newJObject()
  add(query_564626, "api-version", newJString(apiVersion))
  add(path_564625, "subscriptionId", newJString(subscriptionId))
  add(path_564625, "databaseName", newJString(databaseName))
  add(path_564625, "resourceGroupName", newJString(resourceGroupName))
  add(path_564625, "accountName", newJString(accountName))
  result = call_564624.call(path_564625, query_564626, nil, nil, nil)

var gremlinResourcesGetGremlinDatabaseThroughput* = Call_GremlinResourcesGetGremlinDatabaseThroughput_564615(
    name: "gremlinResourcesGetGremlinDatabaseThroughput",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/gremlinDatabases/{databaseName}/throughputSettings/default",
    validator: validate_GremlinResourcesGetGremlinDatabaseThroughput_564616,
    base: "", url: url_GremlinResourcesGetGremlinDatabaseThroughput_564617,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListConnectionStrings_564641 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsListConnectionStrings_564643(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/listConnectionStrings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsListConnectionStrings_564642(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the connection strings for the specified Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564644 = path.getOrDefault("subscriptionId")
  valid_564644 = validateParameter(valid_564644, JString, required = true,
                                 default = nil)
  if valid_564644 != nil:
    section.add "subscriptionId", valid_564644
  var valid_564645 = path.getOrDefault("resourceGroupName")
  valid_564645 = validateParameter(valid_564645, JString, required = true,
                                 default = nil)
  if valid_564645 != nil:
    section.add "resourceGroupName", valid_564645
  var valid_564646 = path.getOrDefault("accountName")
  valid_564646 = validateParameter(valid_564646, JString, required = true,
                                 default = nil)
  if valid_564646 != nil:
    section.add "accountName", valid_564646
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564647 = query.getOrDefault("api-version")
  valid_564647 = validateParameter(valid_564647, JString, required = true,
                                 default = nil)
  if valid_564647 != nil:
    section.add "api-version", valid_564647
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564648: Call_DatabaseAccountsListConnectionStrings_564641;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the connection strings for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_564648.validator(path, query, header, formData, body)
  let scheme = call_564648.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564648.url(scheme.get, call_564648.host, call_564648.base,
                         call_564648.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564648, url, valid)

proc call*(call_564649: Call_DatabaseAccountsListConnectionStrings_564641;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## databaseAccountsListConnectionStrings
  ## Lists the connection strings for the specified Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564650 = newJObject()
  var query_564651 = newJObject()
  add(query_564651, "api-version", newJString(apiVersion))
  add(path_564650, "subscriptionId", newJString(subscriptionId))
  add(path_564650, "resourceGroupName", newJString(resourceGroupName))
  add(path_564650, "accountName", newJString(accountName))
  result = call_564649.call(path_564650, query_564651, nil, nil, nil)

var databaseAccountsListConnectionStrings* = Call_DatabaseAccountsListConnectionStrings_564641(
    name: "databaseAccountsListConnectionStrings", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/listConnectionStrings",
    validator: validate_DatabaseAccountsListConnectionStrings_564642, base: "",
    url: url_DatabaseAccountsListConnectionStrings_564643, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListKeys_564652 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsListKeys_564654(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsListKeys_564653(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the access keys for the specified Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564655 = path.getOrDefault("subscriptionId")
  valid_564655 = validateParameter(valid_564655, JString, required = true,
                                 default = nil)
  if valid_564655 != nil:
    section.add "subscriptionId", valid_564655
  var valid_564656 = path.getOrDefault("resourceGroupName")
  valid_564656 = validateParameter(valid_564656, JString, required = true,
                                 default = nil)
  if valid_564656 != nil:
    section.add "resourceGroupName", valid_564656
  var valid_564657 = path.getOrDefault("accountName")
  valid_564657 = validateParameter(valid_564657, JString, required = true,
                                 default = nil)
  if valid_564657 != nil:
    section.add "accountName", valid_564657
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564658 = query.getOrDefault("api-version")
  valid_564658 = validateParameter(valid_564658, JString, required = true,
                                 default = nil)
  if valid_564658 != nil:
    section.add "api-version", valid_564658
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564659: Call_DatabaseAccountsListKeys_564652; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the access keys for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_564659.validator(path, query, header, formData, body)
  let scheme = call_564659.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564659.url(scheme.get, call_564659.host, call_564659.base,
                         call_564659.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564659, url, valid)

proc call*(call_564660: Call_DatabaseAccountsListKeys_564652; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsListKeys
  ## Lists the access keys for the specified Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564661 = newJObject()
  var query_564662 = newJObject()
  add(query_564662, "api-version", newJString(apiVersion))
  add(path_564661, "subscriptionId", newJString(subscriptionId))
  add(path_564661, "resourceGroupName", newJString(resourceGroupName))
  add(path_564661, "accountName", newJString(accountName))
  result = call_564660.call(path_564661, query_564662, nil, nil, nil)

var databaseAccountsListKeys* = Call_DatabaseAccountsListKeys_564652(
    name: "databaseAccountsListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/listKeys",
    validator: validate_DatabaseAccountsListKeys_564653, base: "",
    url: url_DatabaseAccountsListKeys_564654, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListMetricDefinitions_564663 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsListMetricDefinitions_564665(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/metricDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsListMetricDefinitions_564664(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves metric definitions for the given database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564666 = path.getOrDefault("subscriptionId")
  valid_564666 = validateParameter(valid_564666, JString, required = true,
                                 default = nil)
  if valid_564666 != nil:
    section.add "subscriptionId", valid_564666
  var valid_564667 = path.getOrDefault("resourceGroupName")
  valid_564667 = validateParameter(valid_564667, JString, required = true,
                                 default = nil)
  if valid_564667 != nil:
    section.add "resourceGroupName", valid_564667
  var valid_564668 = path.getOrDefault("accountName")
  valid_564668 = validateParameter(valid_564668, JString, required = true,
                                 default = nil)
  if valid_564668 != nil:
    section.add "accountName", valid_564668
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564669 = query.getOrDefault("api-version")
  valid_564669 = validateParameter(valid_564669, JString, required = true,
                                 default = nil)
  if valid_564669 != nil:
    section.add "api-version", valid_564669
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564670: Call_DatabaseAccountsListMetricDefinitions_564663;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves metric definitions for the given database account.
  ## 
  let valid = call_564670.validator(path, query, header, formData, body)
  let scheme = call_564670.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564670.url(scheme.get, call_564670.host, call_564670.base,
                         call_564670.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564670, url, valid)

proc call*(call_564671: Call_DatabaseAccountsListMetricDefinitions_564663;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## databaseAccountsListMetricDefinitions
  ## Retrieves metric definitions for the given database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564672 = newJObject()
  var query_564673 = newJObject()
  add(query_564673, "api-version", newJString(apiVersion))
  add(path_564672, "subscriptionId", newJString(subscriptionId))
  add(path_564672, "resourceGroupName", newJString(resourceGroupName))
  add(path_564672, "accountName", newJString(accountName))
  result = call_564671.call(path_564672, query_564673, nil, nil, nil)

var databaseAccountsListMetricDefinitions* = Call_DatabaseAccountsListMetricDefinitions_564663(
    name: "databaseAccountsListMetricDefinitions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/metricDefinitions",
    validator: validate_DatabaseAccountsListMetricDefinitions_564664, base: "",
    url: url_DatabaseAccountsListMetricDefinitions_564665, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListMetrics_564674 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsListMetrics_564676(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsListMetrics_564675(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the metrics determined by the given filter for the given database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564677 = path.getOrDefault("subscriptionId")
  valid_564677 = validateParameter(valid_564677, JString, required = true,
                                 default = nil)
  if valid_564677 != nil:
    section.add "subscriptionId", valid_564677
  var valid_564678 = path.getOrDefault("resourceGroupName")
  valid_564678 = validateParameter(valid_564678, JString, required = true,
                                 default = nil)
  if valid_564678 != nil:
    section.add "resourceGroupName", valid_564678
  var valid_564679 = path.getOrDefault("accountName")
  valid_564679 = validateParameter(valid_564679, JString, required = true,
                                 default = nil)
  if valid_564679 != nil:
    section.add "accountName", valid_564679
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564680 = query.getOrDefault("api-version")
  valid_564680 = validateParameter(valid_564680, JString, required = true,
                                 default = nil)
  if valid_564680 != nil:
    section.add "api-version", valid_564680
  var valid_564681 = query.getOrDefault("$filter")
  valid_564681 = validateParameter(valid_564681, JString, required = true,
                                 default = nil)
  if valid_564681 != nil:
    section.add "$filter", valid_564681
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564682: Call_DatabaseAccountsListMetrics_564674; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account.
  ## 
  let valid = call_564682.validator(path, query, header, formData, body)
  let scheme = call_564682.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564682.url(scheme.get, call_564682.host, call_564682.base,
                         call_564682.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564682, url, valid)

proc call*(call_564683: Call_DatabaseAccountsListMetrics_564674;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          Filter: string; accountName: string): Recallable =
  ## databaseAccountsListMetrics
  ## Retrieves the metrics determined by the given filter for the given database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564684 = newJObject()
  var query_564685 = newJObject()
  add(query_564685, "api-version", newJString(apiVersion))
  add(path_564684, "subscriptionId", newJString(subscriptionId))
  add(path_564684, "resourceGroupName", newJString(resourceGroupName))
  add(query_564685, "$filter", newJString(Filter))
  add(path_564684, "accountName", newJString(accountName))
  result = call_564683.call(path_564684, query_564685, nil, nil, nil)

var databaseAccountsListMetrics* = Call_DatabaseAccountsListMetrics_564674(
    name: "databaseAccountsListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/metrics",
    validator: validate_DatabaseAccountsListMetrics_564675, base: "",
    url: url_DatabaseAccountsListMetrics_564676, schemes: {Scheme.Https})
type
  Call_MongoDBResourcesListMongoDBDatabases_564686 = ref object of OpenApiRestCall_563566
proc url_MongoDBResourcesListMongoDBDatabases_564688(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/mongodbDatabases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MongoDBResourcesListMongoDBDatabases_564687(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the MongoDB databases under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564689 = path.getOrDefault("subscriptionId")
  valid_564689 = validateParameter(valid_564689, JString, required = true,
                                 default = nil)
  if valid_564689 != nil:
    section.add "subscriptionId", valid_564689
  var valid_564690 = path.getOrDefault("resourceGroupName")
  valid_564690 = validateParameter(valid_564690, JString, required = true,
                                 default = nil)
  if valid_564690 != nil:
    section.add "resourceGroupName", valid_564690
  var valid_564691 = path.getOrDefault("accountName")
  valid_564691 = validateParameter(valid_564691, JString, required = true,
                                 default = nil)
  if valid_564691 != nil:
    section.add "accountName", valid_564691
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564692 = query.getOrDefault("api-version")
  valid_564692 = validateParameter(valid_564692, JString, required = true,
                                 default = nil)
  if valid_564692 != nil:
    section.add "api-version", valid_564692
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564693: Call_MongoDBResourcesListMongoDBDatabases_564686;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the MongoDB databases under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_564693.validator(path, query, header, formData, body)
  let scheme = call_564693.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564693.url(scheme.get, call_564693.host, call_564693.base,
                         call_564693.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564693, url, valid)

proc call*(call_564694: Call_MongoDBResourcesListMongoDBDatabases_564686;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## mongoDBResourcesListMongoDBDatabases
  ## Lists the MongoDB databases under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564695 = newJObject()
  var query_564696 = newJObject()
  add(query_564696, "api-version", newJString(apiVersion))
  add(path_564695, "subscriptionId", newJString(subscriptionId))
  add(path_564695, "resourceGroupName", newJString(resourceGroupName))
  add(path_564695, "accountName", newJString(accountName))
  result = call_564694.call(path_564695, query_564696, nil, nil, nil)

var mongoDBResourcesListMongoDBDatabases* = Call_MongoDBResourcesListMongoDBDatabases_564686(
    name: "mongoDBResourcesListMongoDBDatabases", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/mongodbDatabases",
    validator: validate_MongoDBResourcesListMongoDBDatabases_564687, base: "",
    url: url_MongoDBResourcesListMongoDBDatabases_564688, schemes: {Scheme.Https})
type
  Call_MongoDBResourcesCreateUpdateMongoDBDatabase_564709 = ref object of OpenApiRestCall_563566
proc url_MongoDBResourcesCreateUpdateMongoDBDatabase_564711(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/mongodbDatabases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MongoDBResourcesCreateUpdateMongoDBDatabase_564710(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or updates Azure Cosmos DB MongoDB database
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564712 = path.getOrDefault("subscriptionId")
  valid_564712 = validateParameter(valid_564712, JString, required = true,
                                 default = nil)
  if valid_564712 != nil:
    section.add "subscriptionId", valid_564712
  var valid_564713 = path.getOrDefault("databaseName")
  valid_564713 = validateParameter(valid_564713, JString, required = true,
                                 default = nil)
  if valid_564713 != nil:
    section.add "databaseName", valid_564713
  var valid_564714 = path.getOrDefault("resourceGroupName")
  valid_564714 = validateParameter(valid_564714, JString, required = true,
                                 default = nil)
  if valid_564714 != nil:
    section.add "resourceGroupName", valid_564714
  var valid_564715 = path.getOrDefault("accountName")
  valid_564715 = validateParameter(valid_564715, JString, required = true,
                                 default = nil)
  if valid_564715 != nil:
    section.add "accountName", valid_564715
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564716 = query.getOrDefault("api-version")
  valid_564716 = validateParameter(valid_564716, JString, required = true,
                                 default = nil)
  if valid_564716 != nil:
    section.add "api-version", valid_564716
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   createUpdateMongoDBDatabaseParameters: JObject (required)
  ##                                        : The parameters to provide for the current MongoDB database.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564718: Call_MongoDBResourcesCreateUpdateMongoDBDatabase_564709;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or updates Azure Cosmos DB MongoDB database
  ## 
  let valid = call_564718.validator(path, query, header, formData, body)
  let scheme = call_564718.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564718.url(scheme.get, call_564718.host, call_564718.base,
                         call_564718.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564718, url, valid)

proc call*(call_564719: Call_MongoDBResourcesCreateUpdateMongoDBDatabase_564709;
          createUpdateMongoDBDatabaseParameters: JsonNode; apiVersion: string;
          subscriptionId: string; databaseName: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## mongoDBResourcesCreateUpdateMongoDBDatabase
  ## Create or updates Azure Cosmos DB MongoDB database
  ##   createUpdateMongoDBDatabaseParameters: JObject (required)
  ##                                        : The parameters to provide for the current MongoDB database.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564720 = newJObject()
  var query_564721 = newJObject()
  var body_564722 = newJObject()
  if createUpdateMongoDBDatabaseParameters != nil:
    body_564722 = createUpdateMongoDBDatabaseParameters
  add(query_564721, "api-version", newJString(apiVersion))
  add(path_564720, "subscriptionId", newJString(subscriptionId))
  add(path_564720, "databaseName", newJString(databaseName))
  add(path_564720, "resourceGroupName", newJString(resourceGroupName))
  add(path_564720, "accountName", newJString(accountName))
  result = call_564719.call(path_564720, query_564721, nil, nil, body_564722)

var mongoDBResourcesCreateUpdateMongoDBDatabase* = Call_MongoDBResourcesCreateUpdateMongoDBDatabase_564709(
    name: "mongoDBResourcesCreateUpdateMongoDBDatabase", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/mongodbDatabases/{databaseName}",
    validator: validate_MongoDBResourcesCreateUpdateMongoDBDatabase_564710,
    base: "", url: url_MongoDBResourcesCreateUpdateMongoDBDatabase_564711,
    schemes: {Scheme.Https})
type
  Call_MongoDBResourcesGetMongoDBDatabase_564697 = ref object of OpenApiRestCall_563566
proc url_MongoDBResourcesGetMongoDBDatabase_564699(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/mongodbDatabases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MongoDBResourcesGetMongoDBDatabase_564698(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the MongoDB databases under an existing Azure Cosmos DB database account with the provided name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564700 = path.getOrDefault("subscriptionId")
  valid_564700 = validateParameter(valid_564700, JString, required = true,
                                 default = nil)
  if valid_564700 != nil:
    section.add "subscriptionId", valid_564700
  var valid_564701 = path.getOrDefault("databaseName")
  valid_564701 = validateParameter(valid_564701, JString, required = true,
                                 default = nil)
  if valid_564701 != nil:
    section.add "databaseName", valid_564701
  var valid_564702 = path.getOrDefault("resourceGroupName")
  valid_564702 = validateParameter(valid_564702, JString, required = true,
                                 default = nil)
  if valid_564702 != nil:
    section.add "resourceGroupName", valid_564702
  var valid_564703 = path.getOrDefault("accountName")
  valid_564703 = validateParameter(valid_564703, JString, required = true,
                                 default = nil)
  if valid_564703 != nil:
    section.add "accountName", valid_564703
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564704 = query.getOrDefault("api-version")
  valid_564704 = validateParameter(valid_564704, JString, required = true,
                                 default = nil)
  if valid_564704 != nil:
    section.add "api-version", valid_564704
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564705: Call_MongoDBResourcesGetMongoDBDatabase_564697;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the MongoDB databases under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_564705.validator(path, query, header, formData, body)
  let scheme = call_564705.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564705.url(scheme.get, call_564705.host, call_564705.base,
                         call_564705.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564705, url, valid)

proc call*(call_564706: Call_MongoDBResourcesGetMongoDBDatabase_564697;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## mongoDBResourcesGetMongoDBDatabase
  ## Gets the MongoDB databases under an existing Azure Cosmos DB database account with the provided name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564707 = newJObject()
  var query_564708 = newJObject()
  add(query_564708, "api-version", newJString(apiVersion))
  add(path_564707, "subscriptionId", newJString(subscriptionId))
  add(path_564707, "databaseName", newJString(databaseName))
  add(path_564707, "resourceGroupName", newJString(resourceGroupName))
  add(path_564707, "accountName", newJString(accountName))
  result = call_564706.call(path_564707, query_564708, nil, nil, nil)

var mongoDBResourcesGetMongoDBDatabase* = Call_MongoDBResourcesGetMongoDBDatabase_564697(
    name: "mongoDBResourcesGetMongoDBDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/mongodbDatabases/{databaseName}",
    validator: validate_MongoDBResourcesGetMongoDBDatabase_564698, base: "",
    url: url_MongoDBResourcesGetMongoDBDatabase_564699, schemes: {Scheme.Https})
type
  Call_MongoDBResourcesDeleteMongoDBDatabase_564723 = ref object of OpenApiRestCall_563566
proc url_MongoDBResourcesDeleteMongoDBDatabase_564725(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/mongodbDatabases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MongoDBResourcesDeleteMongoDBDatabase_564724(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Azure Cosmos DB MongoDB database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564726 = path.getOrDefault("subscriptionId")
  valid_564726 = validateParameter(valid_564726, JString, required = true,
                                 default = nil)
  if valid_564726 != nil:
    section.add "subscriptionId", valid_564726
  var valid_564727 = path.getOrDefault("databaseName")
  valid_564727 = validateParameter(valid_564727, JString, required = true,
                                 default = nil)
  if valid_564727 != nil:
    section.add "databaseName", valid_564727
  var valid_564728 = path.getOrDefault("resourceGroupName")
  valid_564728 = validateParameter(valid_564728, JString, required = true,
                                 default = nil)
  if valid_564728 != nil:
    section.add "resourceGroupName", valid_564728
  var valid_564729 = path.getOrDefault("accountName")
  valid_564729 = validateParameter(valid_564729, JString, required = true,
                                 default = nil)
  if valid_564729 != nil:
    section.add "accountName", valid_564729
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564730 = query.getOrDefault("api-version")
  valid_564730 = validateParameter(valid_564730, JString, required = true,
                                 default = nil)
  if valid_564730 != nil:
    section.add "api-version", valid_564730
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564731: Call_MongoDBResourcesDeleteMongoDBDatabase_564723;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB MongoDB database.
  ## 
  let valid = call_564731.validator(path, query, header, formData, body)
  let scheme = call_564731.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564731.url(scheme.get, call_564731.host, call_564731.base,
                         call_564731.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564731, url, valid)

proc call*(call_564732: Call_MongoDBResourcesDeleteMongoDBDatabase_564723;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## mongoDBResourcesDeleteMongoDBDatabase
  ## Deletes an existing Azure Cosmos DB MongoDB database.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564733 = newJObject()
  var query_564734 = newJObject()
  add(query_564734, "api-version", newJString(apiVersion))
  add(path_564733, "subscriptionId", newJString(subscriptionId))
  add(path_564733, "databaseName", newJString(databaseName))
  add(path_564733, "resourceGroupName", newJString(resourceGroupName))
  add(path_564733, "accountName", newJString(accountName))
  result = call_564732.call(path_564733, query_564734, nil, nil, nil)

var mongoDBResourcesDeleteMongoDBDatabase* = Call_MongoDBResourcesDeleteMongoDBDatabase_564723(
    name: "mongoDBResourcesDeleteMongoDBDatabase", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/mongodbDatabases/{databaseName}",
    validator: validate_MongoDBResourcesDeleteMongoDBDatabase_564724, base: "",
    url: url_MongoDBResourcesDeleteMongoDBDatabase_564725, schemes: {Scheme.Https})
type
  Call_MongoDBResourcesListMongoDBCollections_564735 = ref object of OpenApiRestCall_563566
proc url_MongoDBResourcesListMongoDBCollections_564737(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/mongodbDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/collections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MongoDBResourcesListMongoDBCollections_564736(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the MongoDB collection under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564738 = path.getOrDefault("subscriptionId")
  valid_564738 = validateParameter(valid_564738, JString, required = true,
                                 default = nil)
  if valid_564738 != nil:
    section.add "subscriptionId", valid_564738
  var valid_564739 = path.getOrDefault("databaseName")
  valid_564739 = validateParameter(valid_564739, JString, required = true,
                                 default = nil)
  if valid_564739 != nil:
    section.add "databaseName", valid_564739
  var valid_564740 = path.getOrDefault("resourceGroupName")
  valid_564740 = validateParameter(valid_564740, JString, required = true,
                                 default = nil)
  if valid_564740 != nil:
    section.add "resourceGroupName", valid_564740
  var valid_564741 = path.getOrDefault("accountName")
  valid_564741 = validateParameter(valid_564741, JString, required = true,
                                 default = nil)
  if valid_564741 != nil:
    section.add "accountName", valid_564741
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564742 = query.getOrDefault("api-version")
  valid_564742 = validateParameter(valid_564742, JString, required = true,
                                 default = nil)
  if valid_564742 != nil:
    section.add "api-version", valid_564742
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564743: Call_MongoDBResourcesListMongoDBCollections_564735;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the MongoDB collection under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_564743.validator(path, query, header, formData, body)
  let scheme = call_564743.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564743.url(scheme.get, call_564743.host, call_564743.base,
                         call_564743.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564743, url, valid)

proc call*(call_564744: Call_MongoDBResourcesListMongoDBCollections_564735;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## mongoDBResourcesListMongoDBCollections
  ## Lists the MongoDB collection under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564745 = newJObject()
  var query_564746 = newJObject()
  add(query_564746, "api-version", newJString(apiVersion))
  add(path_564745, "subscriptionId", newJString(subscriptionId))
  add(path_564745, "databaseName", newJString(databaseName))
  add(path_564745, "resourceGroupName", newJString(resourceGroupName))
  add(path_564745, "accountName", newJString(accountName))
  result = call_564744.call(path_564745, query_564746, nil, nil, nil)

var mongoDBResourcesListMongoDBCollections* = Call_MongoDBResourcesListMongoDBCollections_564735(
    name: "mongoDBResourcesListMongoDBCollections", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/mongodbDatabases/{databaseName}/collections",
    validator: validate_MongoDBResourcesListMongoDBCollections_564736, base: "",
    url: url_MongoDBResourcesListMongoDBCollections_564737,
    schemes: {Scheme.Https})
type
  Call_MongoDBResourcesCreateUpdateMongoDBCollection_564760 = ref object of OpenApiRestCall_563566
proc url_MongoDBResourcesCreateUpdateMongoDBCollection_564762(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "collectionName" in path, "`collectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/mongodbDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/collections/"),
               (kind: VariableSegment, value: "collectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MongoDBResourcesCreateUpdateMongoDBCollection_564761(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Create or update an Azure Cosmos DB MongoDB Collection
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   collectionName: JString (required)
  ##                 : Cosmos DB collection name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `collectionName` field"
  var valid_564763 = path.getOrDefault("collectionName")
  valid_564763 = validateParameter(valid_564763, JString, required = true,
                                 default = nil)
  if valid_564763 != nil:
    section.add "collectionName", valid_564763
  var valid_564764 = path.getOrDefault("subscriptionId")
  valid_564764 = validateParameter(valid_564764, JString, required = true,
                                 default = nil)
  if valid_564764 != nil:
    section.add "subscriptionId", valid_564764
  var valid_564765 = path.getOrDefault("databaseName")
  valid_564765 = validateParameter(valid_564765, JString, required = true,
                                 default = nil)
  if valid_564765 != nil:
    section.add "databaseName", valid_564765
  var valid_564766 = path.getOrDefault("resourceGroupName")
  valid_564766 = validateParameter(valid_564766, JString, required = true,
                                 default = nil)
  if valid_564766 != nil:
    section.add "resourceGroupName", valid_564766
  var valid_564767 = path.getOrDefault("accountName")
  valid_564767 = validateParameter(valid_564767, JString, required = true,
                                 default = nil)
  if valid_564767 != nil:
    section.add "accountName", valid_564767
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564768 = query.getOrDefault("api-version")
  valid_564768 = validateParameter(valid_564768, JString, required = true,
                                 default = nil)
  if valid_564768 != nil:
    section.add "api-version", valid_564768
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   createUpdateMongoDBCollectionParameters: JObject (required)
  ##                                          : The parameters to provide for the current MongoDB Collection.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564770: Call_MongoDBResourcesCreateUpdateMongoDBCollection_564760;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB MongoDB Collection
  ## 
  let valid = call_564770.validator(path, query, header, formData, body)
  let scheme = call_564770.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564770.url(scheme.get, call_564770.host, call_564770.base,
                         call_564770.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564770, url, valid)

proc call*(call_564771: Call_MongoDBResourcesCreateUpdateMongoDBCollection_564760;
          collectionName: string; apiVersion: string;
          createUpdateMongoDBCollectionParameters: JsonNode;
          subscriptionId: string; databaseName: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## mongoDBResourcesCreateUpdateMongoDBCollection
  ## Create or update an Azure Cosmos DB MongoDB Collection
  ##   collectionName: string (required)
  ##                 : Cosmos DB collection name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   createUpdateMongoDBCollectionParameters: JObject (required)
  ##                                          : The parameters to provide for the current MongoDB Collection.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564772 = newJObject()
  var query_564773 = newJObject()
  var body_564774 = newJObject()
  add(path_564772, "collectionName", newJString(collectionName))
  add(query_564773, "api-version", newJString(apiVersion))
  if createUpdateMongoDBCollectionParameters != nil:
    body_564774 = createUpdateMongoDBCollectionParameters
  add(path_564772, "subscriptionId", newJString(subscriptionId))
  add(path_564772, "databaseName", newJString(databaseName))
  add(path_564772, "resourceGroupName", newJString(resourceGroupName))
  add(path_564772, "accountName", newJString(accountName))
  result = call_564771.call(path_564772, query_564773, nil, nil, body_564774)

var mongoDBResourcesCreateUpdateMongoDBCollection* = Call_MongoDBResourcesCreateUpdateMongoDBCollection_564760(
    name: "mongoDBResourcesCreateUpdateMongoDBCollection",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/mongodbDatabases/{databaseName}/collections/{collectionName}",
    validator: validate_MongoDBResourcesCreateUpdateMongoDBCollection_564761,
    base: "", url: url_MongoDBResourcesCreateUpdateMongoDBCollection_564762,
    schemes: {Scheme.Https})
type
  Call_MongoDBResourcesGetMongoDBCollection_564747 = ref object of OpenApiRestCall_563566
proc url_MongoDBResourcesGetMongoDBCollection_564749(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "collectionName" in path, "`collectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/mongodbDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/collections/"),
               (kind: VariableSegment, value: "collectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MongoDBResourcesGetMongoDBCollection_564748(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the MongoDB collection under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   collectionName: JString (required)
  ##                 : Cosmos DB collection name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `collectionName` field"
  var valid_564750 = path.getOrDefault("collectionName")
  valid_564750 = validateParameter(valid_564750, JString, required = true,
                                 default = nil)
  if valid_564750 != nil:
    section.add "collectionName", valid_564750
  var valid_564751 = path.getOrDefault("subscriptionId")
  valid_564751 = validateParameter(valid_564751, JString, required = true,
                                 default = nil)
  if valid_564751 != nil:
    section.add "subscriptionId", valid_564751
  var valid_564752 = path.getOrDefault("databaseName")
  valid_564752 = validateParameter(valid_564752, JString, required = true,
                                 default = nil)
  if valid_564752 != nil:
    section.add "databaseName", valid_564752
  var valid_564753 = path.getOrDefault("resourceGroupName")
  valid_564753 = validateParameter(valid_564753, JString, required = true,
                                 default = nil)
  if valid_564753 != nil:
    section.add "resourceGroupName", valid_564753
  var valid_564754 = path.getOrDefault("accountName")
  valid_564754 = validateParameter(valid_564754, JString, required = true,
                                 default = nil)
  if valid_564754 != nil:
    section.add "accountName", valid_564754
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564755 = query.getOrDefault("api-version")
  valid_564755 = validateParameter(valid_564755, JString, required = true,
                                 default = nil)
  if valid_564755 != nil:
    section.add "api-version", valid_564755
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564756: Call_MongoDBResourcesGetMongoDBCollection_564747;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the MongoDB collection under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_564756.validator(path, query, header, formData, body)
  let scheme = call_564756.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564756.url(scheme.get, call_564756.host, call_564756.base,
                         call_564756.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564756, url, valid)

proc call*(call_564757: Call_MongoDBResourcesGetMongoDBCollection_564747;
          collectionName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string; accountName: string): Recallable =
  ## mongoDBResourcesGetMongoDBCollection
  ## Gets the MongoDB collection under an existing Azure Cosmos DB database account.
  ##   collectionName: string (required)
  ##                 : Cosmos DB collection name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564758 = newJObject()
  var query_564759 = newJObject()
  add(path_564758, "collectionName", newJString(collectionName))
  add(query_564759, "api-version", newJString(apiVersion))
  add(path_564758, "subscriptionId", newJString(subscriptionId))
  add(path_564758, "databaseName", newJString(databaseName))
  add(path_564758, "resourceGroupName", newJString(resourceGroupName))
  add(path_564758, "accountName", newJString(accountName))
  result = call_564757.call(path_564758, query_564759, nil, nil, nil)

var mongoDBResourcesGetMongoDBCollection* = Call_MongoDBResourcesGetMongoDBCollection_564747(
    name: "mongoDBResourcesGetMongoDBCollection", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/mongodbDatabases/{databaseName}/collections/{collectionName}",
    validator: validate_MongoDBResourcesGetMongoDBCollection_564748, base: "",
    url: url_MongoDBResourcesGetMongoDBCollection_564749, schemes: {Scheme.Https})
type
  Call_MongoDBResourcesDeleteMongoDBCollection_564775 = ref object of OpenApiRestCall_563566
proc url_MongoDBResourcesDeleteMongoDBCollection_564777(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "collectionName" in path, "`collectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/mongodbDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/collections/"),
               (kind: VariableSegment, value: "collectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MongoDBResourcesDeleteMongoDBCollection_564776(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Azure Cosmos DB MongoDB Collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   collectionName: JString (required)
  ##                 : Cosmos DB collection name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `collectionName` field"
  var valid_564778 = path.getOrDefault("collectionName")
  valid_564778 = validateParameter(valid_564778, JString, required = true,
                                 default = nil)
  if valid_564778 != nil:
    section.add "collectionName", valid_564778
  var valid_564779 = path.getOrDefault("subscriptionId")
  valid_564779 = validateParameter(valid_564779, JString, required = true,
                                 default = nil)
  if valid_564779 != nil:
    section.add "subscriptionId", valid_564779
  var valid_564780 = path.getOrDefault("databaseName")
  valid_564780 = validateParameter(valid_564780, JString, required = true,
                                 default = nil)
  if valid_564780 != nil:
    section.add "databaseName", valid_564780
  var valid_564781 = path.getOrDefault("resourceGroupName")
  valid_564781 = validateParameter(valid_564781, JString, required = true,
                                 default = nil)
  if valid_564781 != nil:
    section.add "resourceGroupName", valid_564781
  var valid_564782 = path.getOrDefault("accountName")
  valid_564782 = validateParameter(valid_564782, JString, required = true,
                                 default = nil)
  if valid_564782 != nil:
    section.add "accountName", valid_564782
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564783 = query.getOrDefault("api-version")
  valid_564783 = validateParameter(valid_564783, JString, required = true,
                                 default = nil)
  if valid_564783 != nil:
    section.add "api-version", valid_564783
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564784: Call_MongoDBResourcesDeleteMongoDBCollection_564775;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB MongoDB Collection.
  ## 
  let valid = call_564784.validator(path, query, header, formData, body)
  let scheme = call_564784.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564784.url(scheme.get, call_564784.host, call_564784.base,
                         call_564784.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564784, url, valid)

proc call*(call_564785: Call_MongoDBResourcesDeleteMongoDBCollection_564775;
          collectionName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string; accountName: string): Recallable =
  ## mongoDBResourcesDeleteMongoDBCollection
  ## Deletes an existing Azure Cosmos DB MongoDB Collection.
  ##   collectionName: string (required)
  ##                 : Cosmos DB collection name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564786 = newJObject()
  var query_564787 = newJObject()
  add(path_564786, "collectionName", newJString(collectionName))
  add(query_564787, "api-version", newJString(apiVersion))
  add(path_564786, "subscriptionId", newJString(subscriptionId))
  add(path_564786, "databaseName", newJString(databaseName))
  add(path_564786, "resourceGroupName", newJString(resourceGroupName))
  add(path_564786, "accountName", newJString(accountName))
  result = call_564785.call(path_564786, query_564787, nil, nil, nil)

var mongoDBResourcesDeleteMongoDBCollection* = Call_MongoDBResourcesDeleteMongoDBCollection_564775(
    name: "mongoDBResourcesDeleteMongoDBCollection", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/mongodbDatabases/{databaseName}/collections/{collectionName}",
    validator: validate_MongoDBResourcesDeleteMongoDBCollection_564776, base: "",
    url: url_MongoDBResourcesDeleteMongoDBCollection_564777,
    schemes: {Scheme.Https})
type
  Call_MongoDBResourcesUpdateMongoDBCollectionThroughput_564801 = ref object of OpenApiRestCall_563566
proc url_MongoDBResourcesUpdateMongoDBCollectionThroughput_564803(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "collectionName" in path, "`collectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/mongodbDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/collections/"),
               (kind: VariableSegment, value: "collectionName"),
               (kind: ConstantSegment, value: "/throughputSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MongoDBResourcesUpdateMongoDBCollectionThroughput_564802(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Update the RUs per second of an Azure Cosmos DB MongoDB collection
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   collectionName: JString (required)
  ##                 : Cosmos DB collection name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `collectionName` field"
  var valid_564804 = path.getOrDefault("collectionName")
  valid_564804 = validateParameter(valid_564804, JString, required = true,
                                 default = nil)
  if valid_564804 != nil:
    section.add "collectionName", valid_564804
  var valid_564805 = path.getOrDefault("subscriptionId")
  valid_564805 = validateParameter(valid_564805, JString, required = true,
                                 default = nil)
  if valid_564805 != nil:
    section.add "subscriptionId", valid_564805
  var valid_564806 = path.getOrDefault("databaseName")
  valid_564806 = validateParameter(valid_564806, JString, required = true,
                                 default = nil)
  if valid_564806 != nil:
    section.add "databaseName", valid_564806
  var valid_564807 = path.getOrDefault("resourceGroupName")
  valid_564807 = validateParameter(valid_564807, JString, required = true,
                                 default = nil)
  if valid_564807 != nil:
    section.add "resourceGroupName", valid_564807
  var valid_564808 = path.getOrDefault("accountName")
  valid_564808 = validateParameter(valid_564808, JString, required = true,
                                 default = nil)
  if valid_564808 != nil:
    section.add "accountName", valid_564808
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564809 = query.getOrDefault("api-version")
  valid_564809 = validateParameter(valid_564809, JString, required = true,
                                 default = nil)
  if valid_564809 != nil:
    section.add "api-version", valid_564809
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   updateThroughputParameters: JObject (required)
  ##                             : The RUs per second of the parameters to provide for the current MongoDB collection.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564811: Call_MongoDBResourcesUpdateMongoDBCollectionThroughput_564801;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the RUs per second of an Azure Cosmos DB MongoDB collection
  ## 
  let valid = call_564811.validator(path, query, header, formData, body)
  let scheme = call_564811.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564811.url(scheme.get, call_564811.host, call_564811.base,
                         call_564811.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564811, url, valid)

proc call*(call_564812: Call_MongoDBResourcesUpdateMongoDBCollectionThroughput_564801;
          collectionName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string; accountName: string;
          updateThroughputParameters: JsonNode): Recallable =
  ## mongoDBResourcesUpdateMongoDBCollectionThroughput
  ## Update the RUs per second of an Azure Cosmos DB MongoDB collection
  ##   collectionName: string (required)
  ##                 : Cosmos DB collection name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   updateThroughputParameters: JObject (required)
  ##                             : The RUs per second of the parameters to provide for the current MongoDB collection.
  var path_564813 = newJObject()
  var query_564814 = newJObject()
  var body_564815 = newJObject()
  add(path_564813, "collectionName", newJString(collectionName))
  add(query_564814, "api-version", newJString(apiVersion))
  add(path_564813, "subscriptionId", newJString(subscriptionId))
  add(path_564813, "databaseName", newJString(databaseName))
  add(path_564813, "resourceGroupName", newJString(resourceGroupName))
  add(path_564813, "accountName", newJString(accountName))
  if updateThroughputParameters != nil:
    body_564815 = updateThroughputParameters
  result = call_564812.call(path_564813, query_564814, nil, nil, body_564815)

var mongoDBResourcesUpdateMongoDBCollectionThroughput* = Call_MongoDBResourcesUpdateMongoDBCollectionThroughput_564801(
    name: "mongoDBResourcesUpdateMongoDBCollectionThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/mongodbDatabases/{databaseName}/collections/{collectionName}/throughputSettings/default",
    validator: validate_MongoDBResourcesUpdateMongoDBCollectionThroughput_564802,
    base: "", url: url_MongoDBResourcesUpdateMongoDBCollectionThroughput_564803,
    schemes: {Scheme.Https})
type
  Call_MongoDBResourcesGetMongoDBCollectionThroughput_564788 = ref object of OpenApiRestCall_563566
proc url_MongoDBResourcesGetMongoDBCollectionThroughput_564790(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "collectionName" in path, "`collectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/mongodbDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/collections/"),
               (kind: VariableSegment, value: "collectionName"),
               (kind: ConstantSegment, value: "/throughputSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MongoDBResourcesGetMongoDBCollectionThroughput_564789(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the RUs per second of the MongoDB collection under an existing Azure Cosmos DB database account with the provided name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   collectionName: JString (required)
  ##                 : Cosmos DB collection name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `collectionName` field"
  var valid_564791 = path.getOrDefault("collectionName")
  valid_564791 = validateParameter(valid_564791, JString, required = true,
                                 default = nil)
  if valid_564791 != nil:
    section.add "collectionName", valid_564791
  var valid_564792 = path.getOrDefault("subscriptionId")
  valid_564792 = validateParameter(valid_564792, JString, required = true,
                                 default = nil)
  if valid_564792 != nil:
    section.add "subscriptionId", valid_564792
  var valid_564793 = path.getOrDefault("databaseName")
  valid_564793 = validateParameter(valid_564793, JString, required = true,
                                 default = nil)
  if valid_564793 != nil:
    section.add "databaseName", valid_564793
  var valid_564794 = path.getOrDefault("resourceGroupName")
  valid_564794 = validateParameter(valid_564794, JString, required = true,
                                 default = nil)
  if valid_564794 != nil:
    section.add "resourceGroupName", valid_564794
  var valid_564795 = path.getOrDefault("accountName")
  valid_564795 = validateParameter(valid_564795, JString, required = true,
                                 default = nil)
  if valid_564795 != nil:
    section.add "accountName", valid_564795
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564796 = query.getOrDefault("api-version")
  valid_564796 = validateParameter(valid_564796, JString, required = true,
                                 default = nil)
  if valid_564796 != nil:
    section.add "api-version", valid_564796
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564797: Call_MongoDBResourcesGetMongoDBCollectionThroughput_564788;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the MongoDB collection under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_564797.validator(path, query, header, formData, body)
  let scheme = call_564797.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564797.url(scheme.get, call_564797.host, call_564797.base,
                         call_564797.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564797, url, valid)

proc call*(call_564798: Call_MongoDBResourcesGetMongoDBCollectionThroughput_564788;
          collectionName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string; accountName: string): Recallable =
  ## mongoDBResourcesGetMongoDBCollectionThroughput
  ## Gets the RUs per second of the MongoDB collection under an existing Azure Cosmos DB database account with the provided name.
  ##   collectionName: string (required)
  ##                 : Cosmos DB collection name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564799 = newJObject()
  var query_564800 = newJObject()
  add(path_564799, "collectionName", newJString(collectionName))
  add(query_564800, "api-version", newJString(apiVersion))
  add(path_564799, "subscriptionId", newJString(subscriptionId))
  add(path_564799, "databaseName", newJString(databaseName))
  add(path_564799, "resourceGroupName", newJString(resourceGroupName))
  add(path_564799, "accountName", newJString(accountName))
  result = call_564798.call(path_564799, query_564800, nil, nil, nil)

var mongoDBResourcesGetMongoDBCollectionThroughput* = Call_MongoDBResourcesGetMongoDBCollectionThroughput_564788(
    name: "mongoDBResourcesGetMongoDBCollectionThroughput",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/mongodbDatabases/{databaseName}/collections/{collectionName}/throughputSettings/default",
    validator: validate_MongoDBResourcesGetMongoDBCollectionThroughput_564789,
    base: "", url: url_MongoDBResourcesGetMongoDBCollectionThroughput_564790,
    schemes: {Scheme.Https})
type
  Call_MongoDBResourcesUpdateMongoDBDatabaseThroughput_564828 = ref object of OpenApiRestCall_563566
proc url_MongoDBResourcesUpdateMongoDBDatabaseThroughput_564830(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/mongodbDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/throughputSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MongoDBResourcesUpdateMongoDBDatabaseThroughput_564829(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Update RUs per second of the an Azure Cosmos DB MongoDB database
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564831 = path.getOrDefault("subscriptionId")
  valid_564831 = validateParameter(valid_564831, JString, required = true,
                                 default = nil)
  if valid_564831 != nil:
    section.add "subscriptionId", valid_564831
  var valid_564832 = path.getOrDefault("databaseName")
  valid_564832 = validateParameter(valid_564832, JString, required = true,
                                 default = nil)
  if valid_564832 != nil:
    section.add "databaseName", valid_564832
  var valid_564833 = path.getOrDefault("resourceGroupName")
  valid_564833 = validateParameter(valid_564833, JString, required = true,
                                 default = nil)
  if valid_564833 != nil:
    section.add "resourceGroupName", valid_564833
  var valid_564834 = path.getOrDefault("accountName")
  valid_564834 = validateParameter(valid_564834, JString, required = true,
                                 default = nil)
  if valid_564834 != nil:
    section.add "accountName", valid_564834
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564835 = query.getOrDefault("api-version")
  valid_564835 = validateParameter(valid_564835, JString, required = true,
                                 default = nil)
  if valid_564835 != nil:
    section.add "api-version", valid_564835
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   updateThroughputParameters: JObject (required)
  ##                             : The RUs per second of the parameters to provide for the current MongoDB database.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564837: Call_MongoDBResourcesUpdateMongoDBDatabaseThroughput_564828;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of the an Azure Cosmos DB MongoDB database
  ## 
  let valid = call_564837.validator(path, query, header, formData, body)
  let scheme = call_564837.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564837.url(scheme.get, call_564837.host, call_564837.base,
                         call_564837.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564837, url, valid)

proc call*(call_564838: Call_MongoDBResourcesUpdateMongoDBDatabaseThroughput_564828;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; accountName: string;
          updateThroughputParameters: JsonNode): Recallable =
  ## mongoDBResourcesUpdateMongoDBDatabaseThroughput
  ## Update RUs per second of the an Azure Cosmos DB MongoDB database
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   updateThroughputParameters: JObject (required)
  ##                             : The RUs per second of the parameters to provide for the current MongoDB database.
  var path_564839 = newJObject()
  var query_564840 = newJObject()
  var body_564841 = newJObject()
  add(query_564840, "api-version", newJString(apiVersion))
  add(path_564839, "subscriptionId", newJString(subscriptionId))
  add(path_564839, "databaseName", newJString(databaseName))
  add(path_564839, "resourceGroupName", newJString(resourceGroupName))
  add(path_564839, "accountName", newJString(accountName))
  if updateThroughputParameters != nil:
    body_564841 = updateThroughputParameters
  result = call_564838.call(path_564839, query_564840, nil, nil, body_564841)

var mongoDBResourcesUpdateMongoDBDatabaseThroughput* = Call_MongoDBResourcesUpdateMongoDBDatabaseThroughput_564828(
    name: "mongoDBResourcesUpdateMongoDBDatabaseThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/mongodbDatabases/{databaseName}/throughputSettings/default",
    validator: validate_MongoDBResourcesUpdateMongoDBDatabaseThroughput_564829,
    base: "", url: url_MongoDBResourcesUpdateMongoDBDatabaseThroughput_564830,
    schemes: {Scheme.Https})
type
  Call_MongoDBResourcesGetMongoDBDatabaseThroughput_564816 = ref object of OpenApiRestCall_563566
proc url_MongoDBResourcesGetMongoDBDatabaseThroughput_564818(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/mongodbDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/throughputSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MongoDBResourcesGetMongoDBDatabaseThroughput_564817(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the RUs per second of the MongoDB database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564819 = path.getOrDefault("subscriptionId")
  valid_564819 = validateParameter(valid_564819, JString, required = true,
                                 default = nil)
  if valid_564819 != nil:
    section.add "subscriptionId", valid_564819
  var valid_564820 = path.getOrDefault("databaseName")
  valid_564820 = validateParameter(valid_564820, JString, required = true,
                                 default = nil)
  if valid_564820 != nil:
    section.add "databaseName", valid_564820
  var valid_564821 = path.getOrDefault("resourceGroupName")
  valid_564821 = validateParameter(valid_564821, JString, required = true,
                                 default = nil)
  if valid_564821 != nil:
    section.add "resourceGroupName", valid_564821
  var valid_564822 = path.getOrDefault("accountName")
  valid_564822 = validateParameter(valid_564822, JString, required = true,
                                 default = nil)
  if valid_564822 != nil:
    section.add "accountName", valid_564822
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564823 = query.getOrDefault("api-version")
  valid_564823 = validateParameter(valid_564823, JString, required = true,
                                 default = nil)
  if valid_564823 != nil:
    section.add "api-version", valid_564823
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564824: Call_MongoDBResourcesGetMongoDBDatabaseThroughput_564816;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the MongoDB database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_564824.validator(path, query, header, formData, body)
  let scheme = call_564824.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564824.url(scheme.get, call_564824.host, call_564824.base,
                         call_564824.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564824, url, valid)

proc call*(call_564825: Call_MongoDBResourcesGetMongoDBDatabaseThroughput_564816;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## mongoDBResourcesGetMongoDBDatabaseThroughput
  ## Gets the RUs per second of the MongoDB database under an existing Azure Cosmos DB database account with the provided name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564826 = newJObject()
  var query_564827 = newJObject()
  add(query_564827, "api-version", newJString(apiVersion))
  add(path_564826, "subscriptionId", newJString(subscriptionId))
  add(path_564826, "databaseName", newJString(databaseName))
  add(path_564826, "resourceGroupName", newJString(resourceGroupName))
  add(path_564826, "accountName", newJString(accountName))
  result = call_564825.call(path_564826, query_564827, nil, nil, nil)

var mongoDBResourcesGetMongoDBDatabaseThroughput* = Call_MongoDBResourcesGetMongoDBDatabaseThroughput_564816(
    name: "mongoDBResourcesGetMongoDBDatabaseThroughput",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/mongodbDatabases/{databaseName}/throughputSettings/default",
    validator: validate_MongoDBResourcesGetMongoDBDatabaseThroughput_564817,
    base: "", url: url_MongoDBResourcesGetMongoDBDatabaseThroughput_564818,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsOfflineRegion_564842 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsOfflineRegion_564844(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/offlineRegion")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsOfflineRegion_564843(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Offline the specified region for the specified Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564845 = path.getOrDefault("subscriptionId")
  valid_564845 = validateParameter(valid_564845, JString, required = true,
                                 default = nil)
  if valid_564845 != nil:
    section.add "subscriptionId", valid_564845
  var valid_564846 = path.getOrDefault("resourceGroupName")
  valid_564846 = validateParameter(valid_564846, JString, required = true,
                                 default = nil)
  if valid_564846 != nil:
    section.add "resourceGroupName", valid_564846
  var valid_564847 = path.getOrDefault("accountName")
  valid_564847 = validateParameter(valid_564847, JString, required = true,
                                 default = nil)
  if valid_564847 != nil:
    section.add "accountName", valid_564847
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564848 = query.getOrDefault("api-version")
  valid_564848 = validateParameter(valid_564848, JString, required = true,
                                 default = nil)
  if valid_564848 != nil:
    section.add "api-version", valid_564848
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   regionParameterForOffline: JObject (required)
  ##                            : Cosmos DB region to offline for the database account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564850: Call_DatabaseAccountsOfflineRegion_564842; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Offline the specified region for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_564850.validator(path, query, header, formData, body)
  let scheme = call_564850.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564850.url(scheme.get, call_564850.host, call_564850.base,
                         call_564850.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564850, url, valid)

proc call*(call_564851: Call_DatabaseAccountsOfflineRegion_564842;
          apiVersion: string; regionParameterForOffline: JsonNode;
          subscriptionId: string; resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsOfflineRegion
  ## Offline the specified region for the specified Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   regionParameterForOffline: JObject (required)
  ##                            : Cosmos DB region to offline for the database account.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564852 = newJObject()
  var query_564853 = newJObject()
  var body_564854 = newJObject()
  add(query_564853, "api-version", newJString(apiVersion))
  if regionParameterForOffline != nil:
    body_564854 = regionParameterForOffline
  add(path_564852, "subscriptionId", newJString(subscriptionId))
  add(path_564852, "resourceGroupName", newJString(resourceGroupName))
  add(path_564852, "accountName", newJString(accountName))
  result = call_564851.call(path_564852, query_564853, nil, nil, body_564854)

var databaseAccountsOfflineRegion* = Call_DatabaseAccountsOfflineRegion_564842(
    name: "databaseAccountsOfflineRegion", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/offlineRegion",
    validator: validate_DatabaseAccountsOfflineRegion_564843, base: "",
    url: url_DatabaseAccountsOfflineRegion_564844, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsOnlineRegion_564855 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsOnlineRegion_564857(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/onlineRegion")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsOnlineRegion_564856(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Online the specified region for the specified Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564858 = path.getOrDefault("subscriptionId")
  valid_564858 = validateParameter(valid_564858, JString, required = true,
                                 default = nil)
  if valid_564858 != nil:
    section.add "subscriptionId", valid_564858
  var valid_564859 = path.getOrDefault("resourceGroupName")
  valid_564859 = validateParameter(valid_564859, JString, required = true,
                                 default = nil)
  if valid_564859 != nil:
    section.add "resourceGroupName", valid_564859
  var valid_564860 = path.getOrDefault("accountName")
  valid_564860 = validateParameter(valid_564860, JString, required = true,
                                 default = nil)
  if valid_564860 != nil:
    section.add "accountName", valid_564860
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564861 = query.getOrDefault("api-version")
  valid_564861 = validateParameter(valid_564861, JString, required = true,
                                 default = nil)
  if valid_564861 != nil:
    section.add "api-version", valid_564861
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   regionParameterForOnline: JObject (required)
  ##                           : Cosmos DB region to online for the database account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564863: Call_DatabaseAccountsOnlineRegion_564855; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Online the specified region for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_564863.validator(path, query, header, formData, body)
  let scheme = call_564863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564863.url(scheme.get, call_564863.host, call_564863.base,
                         call_564863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564863, url, valid)

proc call*(call_564864: Call_DatabaseAccountsOnlineRegion_564855;
          regionParameterForOnline: JsonNode; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsOnlineRegion
  ## Online the specified region for the specified Azure Cosmos DB database account.
  ##   regionParameterForOnline: JObject (required)
  ##                           : Cosmos DB region to online for the database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564865 = newJObject()
  var query_564866 = newJObject()
  var body_564867 = newJObject()
  if regionParameterForOnline != nil:
    body_564867 = regionParameterForOnline
  add(query_564866, "api-version", newJString(apiVersion))
  add(path_564865, "subscriptionId", newJString(subscriptionId))
  add(path_564865, "resourceGroupName", newJString(resourceGroupName))
  add(path_564865, "accountName", newJString(accountName))
  result = call_564864.call(path_564865, query_564866, nil, nil, body_564867)

var databaseAccountsOnlineRegion* = Call_DatabaseAccountsOnlineRegion_564855(
    name: "databaseAccountsOnlineRegion", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/onlineRegion",
    validator: validate_DatabaseAccountsOnlineRegion_564856, base: "",
    url: url_DatabaseAccountsOnlineRegion_564857, schemes: {Scheme.Https})
type
  Call_PercentileListMetrics_564868 = ref object of OpenApiRestCall_563566
proc url_PercentileListMetrics_564870(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/percentile/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PercentileListMetrics_564869(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the metrics determined by the given filter for the given database account. This url is only for PBS and Replication Latency data
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564871 = path.getOrDefault("subscriptionId")
  valid_564871 = validateParameter(valid_564871, JString, required = true,
                                 default = nil)
  if valid_564871 != nil:
    section.add "subscriptionId", valid_564871
  var valid_564872 = path.getOrDefault("resourceGroupName")
  valid_564872 = validateParameter(valid_564872, JString, required = true,
                                 default = nil)
  if valid_564872 != nil:
    section.add "resourceGroupName", valid_564872
  var valid_564873 = path.getOrDefault("accountName")
  valid_564873 = validateParameter(valid_564873, JString, required = true,
                                 default = nil)
  if valid_564873 != nil:
    section.add "accountName", valid_564873
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564874 = query.getOrDefault("api-version")
  valid_564874 = validateParameter(valid_564874, JString, required = true,
                                 default = nil)
  if valid_564874 != nil:
    section.add "api-version", valid_564874
  var valid_564875 = query.getOrDefault("$filter")
  valid_564875 = validateParameter(valid_564875, JString, required = true,
                                 default = nil)
  if valid_564875 != nil:
    section.add "$filter", valid_564875
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564876: Call_PercentileListMetrics_564868; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account. This url is only for PBS and Replication Latency data
  ## 
  let valid = call_564876.validator(path, query, header, formData, body)
  let scheme = call_564876.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564876.url(scheme.get, call_564876.host, call_564876.base,
                         call_564876.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564876, url, valid)

proc call*(call_564877: Call_PercentileListMetrics_564868; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; Filter: string;
          accountName: string): Recallable =
  ## percentileListMetrics
  ## Retrieves the metrics determined by the given filter for the given database account. This url is only for PBS and Replication Latency data
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564878 = newJObject()
  var query_564879 = newJObject()
  add(query_564879, "api-version", newJString(apiVersion))
  add(path_564878, "subscriptionId", newJString(subscriptionId))
  add(path_564878, "resourceGroupName", newJString(resourceGroupName))
  add(query_564879, "$filter", newJString(Filter))
  add(path_564878, "accountName", newJString(accountName))
  result = call_564877.call(path_564878, query_564879, nil, nil, nil)

var percentileListMetrics* = Call_PercentileListMetrics_564868(
    name: "percentileListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/percentile/metrics",
    validator: validate_PercentileListMetrics_564869, base: "",
    url: url_PercentileListMetrics_564870, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListReadOnlyKeys_564891 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsListReadOnlyKeys_564893(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/readonlykeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsListReadOnlyKeys_564892(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the read-only access keys for the specified Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564894 = path.getOrDefault("subscriptionId")
  valid_564894 = validateParameter(valid_564894, JString, required = true,
                                 default = nil)
  if valid_564894 != nil:
    section.add "subscriptionId", valid_564894
  var valid_564895 = path.getOrDefault("resourceGroupName")
  valid_564895 = validateParameter(valid_564895, JString, required = true,
                                 default = nil)
  if valid_564895 != nil:
    section.add "resourceGroupName", valid_564895
  var valid_564896 = path.getOrDefault("accountName")
  valid_564896 = validateParameter(valid_564896, JString, required = true,
                                 default = nil)
  if valid_564896 != nil:
    section.add "accountName", valid_564896
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564897 = query.getOrDefault("api-version")
  valid_564897 = validateParameter(valid_564897, JString, required = true,
                                 default = nil)
  if valid_564897 != nil:
    section.add "api-version", valid_564897
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564898: Call_DatabaseAccountsListReadOnlyKeys_564891;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the read-only access keys for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_564898.validator(path, query, header, formData, body)
  let scheme = call_564898.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564898.url(scheme.get, call_564898.host, call_564898.base,
                         call_564898.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564898, url, valid)

proc call*(call_564899: Call_DatabaseAccountsListReadOnlyKeys_564891;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## databaseAccountsListReadOnlyKeys
  ## Lists the read-only access keys for the specified Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564900 = newJObject()
  var query_564901 = newJObject()
  add(query_564901, "api-version", newJString(apiVersion))
  add(path_564900, "subscriptionId", newJString(subscriptionId))
  add(path_564900, "resourceGroupName", newJString(resourceGroupName))
  add(path_564900, "accountName", newJString(accountName))
  result = call_564899.call(path_564900, query_564901, nil, nil, nil)

var databaseAccountsListReadOnlyKeys* = Call_DatabaseAccountsListReadOnlyKeys_564891(
    name: "databaseAccountsListReadOnlyKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/readonlykeys",
    validator: validate_DatabaseAccountsListReadOnlyKeys_564892, base: "",
    url: url_DatabaseAccountsListReadOnlyKeys_564893, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetReadOnlyKeys_564880 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsGetReadOnlyKeys_564882(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/readonlykeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsGetReadOnlyKeys_564881(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the read-only access keys for the specified Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564883 = path.getOrDefault("subscriptionId")
  valid_564883 = validateParameter(valid_564883, JString, required = true,
                                 default = nil)
  if valid_564883 != nil:
    section.add "subscriptionId", valid_564883
  var valid_564884 = path.getOrDefault("resourceGroupName")
  valid_564884 = validateParameter(valid_564884, JString, required = true,
                                 default = nil)
  if valid_564884 != nil:
    section.add "resourceGroupName", valid_564884
  var valid_564885 = path.getOrDefault("accountName")
  valid_564885 = validateParameter(valid_564885, JString, required = true,
                                 default = nil)
  if valid_564885 != nil:
    section.add "accountName", valid_564885
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564886 = query.getOrDefault("api-version")
  valid_564886 = validateParameter(valid_564886, JString, required = true,
                                 default = nil)
  if valid_564886 != nil:
    section.add "api-version", valid_564886
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564887: Call_DatabaseAccountsGetReadOnlyKeys_564880;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the read-only access keys for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_564887.validator(path, query, header, formData, body)
  let scheme = call_564887.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564887.url(scheme.get, call_564887.host, call_564887.base,
                         call_564887.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564887, url, valid)

proc call*(call_564888: Call_DatabaseAccountsGetReadOnlyKeys_564880;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## databaseAccountsGetReadOnlyKeys
  ## Lists the read-only access keys for the specified Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564889 = newJObject()
  var query_564890 = newJObject()
  add(query_564890, "api-version", newJString(apiVersion))
  add(path_564889, "subscriptionId", newJString(subscriptionId))
  add(path_564889, "resourceGroupName", newJString(resourceGroupName))
  add(path_564889, "accountName", newJString(accountName))
  result = call_564888.call(path_564889, query_564890, nil, nil, nil)

var databaseAccountsGetReadOnlyKeys* = Call_DatabaseAccountsGetReadOnlyKeys_564880(
    name: "databaseAccountsGetReadOnlyKeys", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/readonlykeys",
    validator: validate_DatabaseAccountsGetReadOnlyKeys_564881, base: "",
    url: url_DatabaseAccountsGetReadOnlyKeys_564882, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsRegenerateKey_564902 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsRegenerateKey_564904(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/regenerateKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsRegenerateKey_564903(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates an access key for the specified Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564905 = path.getOrDefault("subscriptionId")
  valid_564905 = validateParameter(valid_564905, JString, required = true,
                                 default = nil)
  if valid_564905 != nil:
    section.add "subscriptionId", valid_564905
  var valid_564906 = path.getOrDefault("resourceGroupName")
  valid_564906 = validateParameter(valid_564906, JString, required = true,
                                 default = nil)
  if valid_564906 != nil:
    section.add "resourceGroupName", valid_564906
  var valid_564907 = path.getOrDefault("accountName")
  valid_564907 = validateParameter(valid_564907, JString, required = true,
                                 default = nil)
  if valid_564907 != nil:
    section.add "accountName", valid_564907
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564908 = query.getOrDefault("api-version")
  valid_564908 = validateParameter(valid_564908, JString, required = true,
                                 default = nil)
  if valid_564908 != nil:
    section.add "api-version", valid_564908
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   keyToRegenerate: JObject (required)
  ##                  : The name of the key to regenerate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564910: Call_DatabaseAccountsRegenerateKey_564902; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates an access key for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_564910.validator(path, query, header, formData, body)
  let scheme = call_564910.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564910.url(scheme.get, call_564910.host, call_564910.base,
                         call_564910.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564910, url, valid)

proc call*(call_564911: Call_DatabaseAccountsRegenerateKey_564902;
          apiVersion: string; keyToRegenerate: JsonNode; subscriptionId: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsRegenerateKey
  ## Regenerates an access key for the specified Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   keyToRegenerate: JObject (required)
  ##                  : The name of the key to regenerate.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564912 = newJObject()
  var query_564913 = newJObject()
  var body_564914 = newJObject()
  add(query_564913, "api-version", newJString(apiVersion))
  if keyToRegenerate != nil:
    body_564914 = keyToRegenerate
  add(path_564912, "subscriptionId", newJString(subscriptionId))
  add(path_564912, "resourceGroupName", newJString(resourceGroupName))
  add(path_564912, "accountName", newJString(accountName))
  result = call_564911.call(path_564912, query_564913, nil, nil, body_564914)

var databaseAccountsRegenerateKey* = Call_DatabaseAccountsRegenerateKey_564902(
    name: "databaseAccountsRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/regenerateKey",
    validator: validate_DatabaseAccountsRegenerateKey_564903, base: "",
    url: url_DatabaseAccountsRegenerateKey_564904, schemes: {Scheme.Https})
type
  Call_CollectionRegionListMetrics_564915 = ref object of OpenApiRestCall_563566
proc url_CollectionRegionListMetrics_564917(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  assert "databaseRid" in path, "`databaseRid` is a required path parameter"
  assert "collectionRid" in path, "`collectionRid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/region/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseRid"),
               (kind: ConstantSegment, value: "/collections/"),
               (kind: VariableSegment, value: "collectionRid"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CollectionRegionListMetrics_564916(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the metrics determined by the given filter for the given database account, collection and region.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   region: JString (required)
  ##         : Cosmos DB region, with spaces between words and each word capitalized.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: JString (required)
  ##              : Cosmos DB database rid.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   collectionRid: JString (required)
  ##                : Cosmos DB collection rid.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `region` field"
  var valid_564918 = path.getOrDefault("region")
  valid_564918 = validateParameter(valid_564918, JString, required = true,
                                 default = nil)
  if valid_564918 != nil:
    section.add "region", valid_564918
  var valid_564919 = path.getOrDefault("subscriptionId")
  valid_564919 = validateParameter(valid_564919, JString, required = true,
                                 default = nil)
  if valid_564919 != nil:
    section.add "subscriptionId", valid_564919
  var valid_564920 = path.getOrDefault("databaseRid")
  valid_564920 = validateParameter(valid_564920, JString, required = true,
                                 default = nil)
  if valid_564920 != nil:
    section.add "databaseRid", valid_564920
  var valid_564921 = path.getOrDefault("resourceGroupName")
  valid_564921 = validateParameter(valid_564921, JString, required = true,
                                 default = nil)
  if valid_564921 != nil:
    section.add "resourceGroupName", valid_564921
  var valid_564922 = path.getOrDefault("collectionRid")
  valid_564922 = validateParameter(valid_564922, JString, required = true,
                                 default = nil)
  if valid_564922 != nil:
    section.add "collectionRid", valid_564922
  var valid_564923 = path.getOrDefault("accountName")
  valid_564923 = validateParameter(valid_564923, JString, required = true,
                                 default = nil)
  if valid_564923 != nil:
    section.add "accountName", valid_564923
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564924 = query.getOrDefault("api-version")
  valid_564924 = validateParameter(valid_564924, JString, required = true,
                                 default = nil)
  if valid_564924 != nil:
    section.add "api-version", valid_564924
  var valid_564925 = query.getOrDefault("$filter")
  valid_564925 = validateParameter(valid_564925, JString, required = true,
                                 default = nil)
  if valid_564925 != nil:
    section.add "$filter", valid_564925
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564926: Call_CollectionRegionListMetrics_564915; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account, collection and region.
  ## 
  let valid = call_564926.validator(path, query, header, formData, body)
  let scheme = call_564926.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564926.url(scheme.get, call_564926.host, call_564926.base,
                         call_564926.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564926, url, valid)

proc call*(call_564927: Call_CollectionRegionListMetrics_564915;
          apiVersion: string; region: string; subscriptionId: string;
          databaseRid: string; resourceGroupName: string; collectionRid: string;
          Filter: string; accountName: string): Recallable =
  ## collectionRegionListMetrics
  ## Retrieves the metrics determined by the given filter for the given database account, collection and region.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   region: string (required)
  ##         : Cosmos DB region, with spaces between words and each word capitalized.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: string (required)
  ##              : Cosmos DB database rid.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   collectionRid: string (required)
  ##                : Cosmos DB collection rid.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564928 = newJObject()
  var query_564929 = newJObject()
  add(query_564929, "api-version", newJString(apiVersion))
  add(path_564928, "region", newJString(region))
  add(path_564928, "subscriptionId", newJString(subscriptionId))
  add(path_564928, "databaseRid", newJString(databaseRid))
  add(path_564928, "resourceGroupName", newJString(resourceGroupName))
  add(path_564928, "collectionRid", newJString(collectionRid))
  add(query_564929, "$filter", newJString(Filter))
  add(path_564928, "accountName", newJString(accountName))
  result = call_564927.call(path_564928, query_564929, nil, nil, nil)

var collectionRegionListMetrics* = Call_CollectionRegionListMetrics_564915(
    name: "collectionRegionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/region/{region}/databases/{databaseRid}/collections/{collectionRid}/metrics",
    validator: validate_CollectionRegionListMetrics_564916, base: "",
    url: url_CollectionRegionListMetrics_564917, schemes: {Scheme.Https})
type
  Call_PartitionKeyRangeIdRegionListMetrics_564930 = ref object of OpenApiRestCall_563566
proc url_PartitionKeyRangeIdRegionListMetrics_564932(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  assert "databaseRid" in path, "`databaseRid` is a required path parameter"
  assert "collectionRid" in path, "`collectionRid` is a required path parameter"
  assert "partitionKeyRangeId" in path,
        "`partitionKeyRangeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/region/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseRid"),
               (kind: ConstantSegment, value: "/collections/"),
               (kind: VariableSegment, value: "collectionRid"),
               (kind: ConstantSegment, value: "/partitionKeyRangeId/"),
               (kind: VariableSegment, value: "partitionKeyRangeId"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartitionKeyRangeIdRegionListMetrics_564931(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the metrics determined by the given filter for the given partition key range id and region.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partitionKeyRangeId: JString (required)
  ##                      : Partition Key Range Id for which to get data.
  ##   region: JString (required)
  ##         : Cosmos DB region, with spaces between words and each word capitalized.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: JString (required)
  ##              : Cosmos DB database rid.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   collectionRid: JString (required)
  ##                : Cosmos DB collection rid.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `partitionKeyRangeId` field"
  var valid_564933 = path.getOrDefault("partitionKeyRangeId")
  valid_564933 = validateParameter(valid_564933, JString, required = true,
                                 default = nil)
  if valid_564933 != nil:
    section.add "partitionKeyRangeId", valid_564933
  var valid_564934 = path.getOrDefault("region")
  valid_564934 = validateParameter(valid_564934, JString, required = true,
                                 default = nil)
  if valid_564934 != nil:
    section.add "region", valid_564934
  var valid_564935 = path.getOrDefault("subscriptionId")
  valid_564935 = validateParameter(valid_564935, JString, required = true,
                                 default = nil)
  if valid_564935 != nil:
    section.add "subscriptionId", valid_564935
  var valid_564936 = path.getOrDefault("databaseRid")
  valid_564936 = validateParameter(valid_564936, JString, required = true,
                                 default = nil)
  if valid_564936 != nil:
    section.add "databaseRid", valid_564936
  var valid_564937 = path.getOrDefault("resourceGroupName")
  valid_564937 = validateParameter(valid_564937, JString, required = true,
                                 default = nil)
  if valid_564937 != nil:
    section.add "resourceGroupName", valid_564937
  var valid_564938 = path.getOrDefault("collectionRid")
  valid_564938 = validateParameter(valid_564938, JString, required = true,
                                 default = nil)
  if valid_564938 != nil:
    section.add "collectionRid", valid_564938
  var valid_564939 = path.getOrDefault("accountName")
  valid_564939 = validateParameter(valid_564939, JString, required = true,
                                 default = nil)
  if valid_564939 != nil:
    section.add "accountName", valid_564939
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564940 = query.getOrDefault("api-version")
  valid_564940 = validateParameter(valid_564940, JString, required = true,
                                 default = nil)
  if valid_564940 != nil:
    section.add "api-version", valid_564940
  var valid_564941 = query.getOrDefault("$filter")
  valid_564941 = validateParameter(valid_564941, JString, required = true,
                                 default = nil)
  if valid_564941 != nil:
    section.add "$filter", valid_564941
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564942: Call_PartitionKeyRangeIdRegionListMetrics_564930;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given partition key range id and region.
  ## 
  let valid = call_564942.validator(path, query, header, formData, body)
  let scheme = call_564942.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564942.url(scheme.get, call_564942.host, call_564942.base,
                         call_564942.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564942, url, valid)

proc call*(call_564943: Call_PartitionKeyRangeIdRegionListMetrics_564930;
          partitionKeyRangeId: string; apiVersion: string; region: string;
          subscriptionId: string; databaseRid: string; resourceGroupName: string;
          collectionRid: string; Filter: string; accountName: string): Recallable =
  ## partitionKeyRangeIdRegionListMetrics
  ## Retrieves the metrics determined by the given filter for the given partition key range id and region.
  ##   partitionKeyRangeId: string (required)
  ##                      : Partition Key Range Id for which to get data.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   region: string (required)
  ##         : Cosmos DB region, with spaces between words and each word capitalized.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: string (required)
  ##              : Cosmos DB database rid.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   collectionRid: string (required)
  ##                : Cosmos DB collection rid.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564944 = newJObject()
  var query_564945 = newJObject()
  add(path_564944, "partitionKeyRangeId", newJString(partitionKeyRangeId))
  add(query_564945, "api-version", newJString(apiVersion))
  add(path_564944, "region", newJString(region))
  add(path_564944, "subscriptionId", newJString(subscriptionId))
  add(path_564944, "databaseRid", newJString(databaseRid))
  add(path_564944, "resourceGroupName", newJString(resourceGroupName))
  add(path_564944, "collectionRid", newJString(collectionRid))
  add(query_564945, "$filter", newJString(Filter))
  add(path_564944, "accountName", newJString(accountName))
  result = call_564943.call(path_564944, query_564945, nil, nil, nil)

var partitionKeyRangeIdRegionListMetrics* = Call_PartitionKeyRangeIdRegionListMetrics_564930(
    name: "partitionKeyRangeIdRegionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/region/{region}/databases/{databaseRid}/collections/{collectionRid}/partitionKeyRangeId/{partitionKeyRangeId}/metrics",
    validator: validate_PartitionKeyRangeIdRegionListMetrics_564931, base: "",
    url: url_PartitionKeyRangeIdRegionListMetrics_564932, schemes: {Scheme.Https})
type
  Call_CollectionPartitionRegionListMetrics_564946 = ref object of OpenApiRestCall_563566
proc url_CollectionPartitionRegionListMetrics_564948(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  assert "databaseRid" in path, "`databaseRid` is a required path parameter"
  assert "collectionRid" in path, "`collectionRid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/region/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseRid"),
               (kind: ConstantSegment, value: "/collections/"),
               (kind: VariableSegment, value: "collectionRid"),
               (kind: ConstantSegment, value: "/partitions/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CollectionPartitionRegionListMetrics_564947(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the metrics determined by the given filter for the given collection and region, split by partition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   region: JString (required)
  ##         : Cosmos DB region, with spaces between words and each word capitalized.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: JString (required)
  ##              : Cosmos DB database rid.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   collectionRid: JString (required)
  ##                : Cosmos DB collection rid.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `region` field"
  var valid_564949 = path.getOrDefault("region")
  valid_564949 = validateParameter(valid_564949, JString, required = true,
                                 default = nil)
  if valid_564949 != nil:
    section.add "region", valid_564949
  var valid_564950 = path.getOrDefault("subscriptionId")
  valid_564950 = validateParameter(valid_564950, JString, required = true,
                                 default = nil)
  if valid_564950 != nil:
    section.add "subscriptionId", valid_564950
  var valid_564951 = path.getOrDefault("databaseRid")
  valid_564951 = validateParameter(valid_564951, JString, required = true,
                                 default = nil)
  if valid_564951 != nil:
    section.add "databaseRid", valid_564951
  var valid_564952 = path.getOrDefault("resourceGroupName")
  valid_564952 = validateParameter(valid_564952, JString, required = true,
                                 default = nil)
  if valid_564952 != nil:
    section.add "resourceGroupName", valid_564952
  var valid_564953 = path.getOrDefault("collectionRid")
  valid_564953 = validateParameter(valid_564953, JString, required = true,
                                 default = nil)
  if valid_564953 != nil:
    section.add "collectionRid", valid_564953
  var valid_564954 = path.getOrDefault("accountName")
  valid_564954 = validateParameter(valid_564954, JString, required = true,
                                 default = nil)
  if valid_564954 != nil:
    section.add "accountName", valid_564954
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564955 = query.getOrDefault("api-version")
  valid_564955 = validateParameter(valid_564955, JString, required = true,
                                 default = nil)
  if valid_564955 != nil:
    section.add "api-version", valid_564955
  var valid_564956 = query.getOrDefault("$filter")
  valid_564956 = validateParameter(valid_564956, JString, required = true,
                                 default = nil)
  if valid_564956 != nil:
    section.add "$filter", valid_564956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564957: Call_CollectionPartitionRegionListMetrics_564946;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given collection and region, split by partition.
  ## 
  let valid = call_564957.validator(path, query, header, formData, body)
  let scheme = call_564957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564957.url(scheme.get, call_564957.host, call_564957.base,
                         call_564957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564957, url, valid)

proc call*(call_564958: Call_CollectionPartitionRegionListMetrics_564946;
          apiVersion: string; region: string; subscriptionId: string;
          databaseRid: string; resourceGroupName: string; collectionRid: string;
          Filter: string; accountName: string): Recallable =
  ## collectionPartitionRegionListMetrics
  ## Retrieves the metrics determined by the given filter for the given collection and region, split by partition.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   region: string (required)
  ##         : Cosmos DB region, with spaces between words and each word capitalized.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: string (required)
  ##              : Cosmos DB database rid.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   collectionRid: string (required)
  ##                : Cosmos DB collection rid.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564959 = newJObject()
  var query_564960 = newJObject()
  add(query_564960, "api-version", newJString(apiVersion))
  add(path_564959, "region", newJString(region))
  add(path_564959, "subscriptionId", newJString(subscriptionId))
  add(path_564959, "databaseRid", newJString(databaseRid))
  add(path_564959, "resourceGroupName", newJString(resourceGroupName))
  add(path_564959, "collectionRid", newJString(collectionRid))
  add(query_564960, "$filter", newJString(Filter))
  add(path_564959, "accountName", newJString(accountName))
  result = call_564958.call(path_564959, query_564960, nil, nil, nil)

var collectionPartitionRegionListMetrics* = Call_CollectionPartitionRegionListMetrics_564946(
    name: "collectionPartitionRegionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/region/{region}/databases/{databaseRid}/collections/{collectionRid}/partitions/metrics",
    validator: validate_CollectionPartitionRegionListMetrics_564947, base: "",
    url: url_CollectionPartitionRegionListMetrics_564948, schemes: {Scheme.Https})
type
  Call_DatabaseAccountRegionListMetrics_564961 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountRegionListMetrics_564963(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/region/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountRegionListMetrics_564962(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the metrics determined by the given filter for the given database account and region.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   region: JString (required)
  ##         : Cosmos DB region, with spaces between words and each word capitalized.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `region` field"
  var valid_564964 = path.getOrDefault("region")
  valid_564964 = validateParameter(valid_564964, JString, required = true,
                                 default = nil)
  if valid_564964 != nil:
    section.add "region", valid_564964
  var valid_564965 = path.getOrDefault("subscriptionId")
  valid_564965 = validateParameter(valid_564965, JString, required = true,
                                 default = nil)
  if valid_564965 != nil:
    section.add "subscriptionId", valid_564965
  var valid_564966 = path.getOrDefault("resourceGroupName")
  valid_564966 = validateParameter(valid_564966, JString, required = true,
                                 default = nil)
  if valid_564966 != nil:
    section.add "resourceGroupName", valid_564966
  var valid_564967 = path.getOrDefault("accountName")
  valid_564967 = validateParameter(valid_564967, JString, required = true,
                                 default = nil)
  if valid_564967 != nil:
    section.add "accountName", valid_564967
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564968 = query.getOrDefault("api-version")
  valid_564968 = validateParameter(valid_564968, JString, required = true,
                                 default = nil)
  if valid_564968 != nil:
    section.add "api-version", valid_564968
  var valid_564969 = query.getOrDefault("$filter")
  valid_564969 = validateParameter(valid_564969, JString, required = true,
                                 default = nil)
  if valid_564969 != nil:
    section.add "$filter", valid_564969
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564970: Call_DatabaseAccountRegionListMetrics_564961;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account and region.
  ## 
  let valid = call_564970.validator(path, query, header, formData, body)
  let scheme = call_564970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564970.url(scheme.get, call_564970.host, call_564970.base,
                         call_564970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564970, url, valid)

proc call*(call_564971: Call_DatabaseAccountRegionListMetrics_564961;
          apiVersion: string; region: string; subscriptionId: string;
          resourceGroupName: string; Filter: string; accountName: string): Recallable =
  ## databaseAccountRegionListMetrics
  ## Retrieves the metrics determined by the given filter for the given database account and region.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   region: string (required)
  ##         : Cosmos DB region, with spaces between words and each word capitalized.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564972 = newJObject()
  var query_564973 = newJObject()
  add(query_564973, "api-version", newJString(apiVersion))
  add(path_564972, "region", newJString(region))
  add(path_564972, "subscriptionId", newJString(subscriptionId))
  add(path_564972, "resourceGroupName", newJString(resourceGroupName))
  add(query_564973, "$filter", newJString(Filter))
  add(path_564972, "accountName", newJString(accountName))
  result = call_564971.call(path_564972, query_564973, nil, nil, nil)

var databaseAccountRegionListMetrics* = Call_DatabaseAccountRegionListMetrics_564961(
    name: "databaseAccountRegionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/region/{region}/metrics",
    validator: validate_DatabaseAccountRegionListMetrics_564962, base: "",
    url: url_DatabaseAccountRegionListMetrics_564963, schemes: {Scheme.Https})
type
  Call_PercentileSourceTargetListMetrics_564974 = ref object of OpenApiRestCall_563566
proc url_PercentileSourceTargetListMetrics_564976(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "sourceRegion" in path, "`sourceRegion` is a required path parameter"
  assert "targetRegion" in path, "`targetRegion` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/sourceRegion/"),
               (kind: VariableSegment, value: "sourceRegion"),
               (kind: ConstantSegment, value: "/targetRegion/"),
               (kind: VariableSegment, value: "targetRegion"),
               (kind: ConstantSegment, value: "/percentile/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PercentileSourceTargetListMetrics_564975(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the metrics determined by the given filter for the given account, source and target region. This url is only for PBS and Replication Latency data
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   sourceRegion: JString (required)
  ##               : Source region from which data is written. Cosmos DB region, with spaces between words and each word capitalized.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   targetRegion: JString (required)
  ##               : Target region to which data is written. Cosmos DB region, with spaces between words and each word capitalized.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564977 = path.getOrDefault("subscriptionId")
  valid_564977 = validateParameter(valid_564977, JString, required = true,
                                 default = nil)
  if valid_564977 != nil:
    section.add "subscriptionId", valid_564977
  var valid_564978 = path.getOrDefault("sourceRegion")
  valid_564978 = validateParameter(valid_564978, JString, required = true,
                                 default = nil)
  if valid_564978 != nil:
    section.add "sourceRegion", valid_564978
  var valid_564979 = path.getOrDefault("resourceGroupName")
  valid_564979 = validateParameter(valid_564979, JString, required = true,
                                 default = nil)
  if valid_564979 != nil:
    section.add "resourceGroupName", valid_564979
  var valid_564980 = path.getOrDefault("targetRegion")
  valid_564980 = validateParameter(valid_564980, JString, required = true,
                                 default = nil)
  if valid_564980 != nil:
    section.add "targetRegion", valid_564980
  var valid_564981 = path.getOrDefault("accountName")
  valid_564981 = validateParameter(valid_564981, JString, required = true,
                                 default = nil)
  if valid_564981 != nil:
    section.add "accountName", valid_564981
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564982 = query.getOrDefault("api-version")
  valid_564982 = validateParameter(valid_564982, JString, required = true,
                                 default = nil)
  if valid_564982 != nil:
    section.add "api-version", valid_564982
  var valid_564983 = query.getOrDefault("$filter")
  valid_564983 = validateParameter(valid_564983, JString, required = true,
                                 default = nil)
  if valid_564983 != nil:
    section.add "$filter", valid_564983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564984: Call_PercentileSourceTargetListMetrics_564974;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given account, source and target region. This url is only for PBS and Replication Latency data
  ## 
  let valid = call_564984.validator(path, query, header, formData, body)
  let scheme = call_564984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564984.url(scheme.get, call_564984.host, call_564984.base,
                         call_564984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564984, url, valid)

proc call*(call_564985: Call_PercentileSourceTargetListMetrics_564974;
          apiVersion: string; subscriptionId: string; sourceRegion: string;
          resourceGroupName: string; Filter: string; targetRegion: string;
          accountName: string): Recallable =
  ## percentileSourceTargetListMetrics
  ## Retrieves the metrics determined by the given filter for the given account, source and target region. This url is only for PBS and Replication Latency data
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   sourceRegion: string (required)
  ##               : Source region from which data is written. Cosmos DB region, with spaces between words and each word capitalized.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  ##   targetRegion: string (required)
  ##               : Target region to which data is written. Cosmos DB region, with spaces between words and each word capitalized.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564986 = newJObject()
  var query_564987 = newJObject()
  add(query_564987, "api-version", newJString(apiVersion))
  add(path_564986, "subscriptionId", newJString(subscriptionId))
  add(path_564986, "sourceRegion", newJString(sourceRegion))
  add(path_564986, "resourceGroupName", newJString(resourceGroupName))
  add(query_564987, "$filter", newJString(Filter))
  add(path_564986, "targetRegion", newJString(targetRegion))
  add(path_564986, "accountName", newJString(accountName))
  result = call_564985.call(path_564986, query_564987, nil, nil, nil)

var percentileSourceTargetListMetrics* = Call_PercentileSourceTargetListMetrics_564974(
    name: "percentileSourceTargetListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sourceRegion/{sourceRegion}/targetRegion/{targetRegion}/percentile/metrics",
    validator: validate_PercentileSourceTargetListMetrics_564975, base: "",
    url: url_PercentileSourceTargetListMetrics_564976, schemes: {Scheme.Https})
type
  Call_SqlResourcesListSqlDatabases_564988 = ref object of OpenApiRestCall_563566
proc url_SqlResourcesListSqlDatabases_564990(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/sqlDatabases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlResourcesListSqlDatabases_564989(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the SQL databases under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564991 = path.getOrDefault("subscriptionId")
  valid_564991 = validateParameter(valid_564991, JString, required = true,
                                 default = nil)
  if valid_564991 != nil:
    section.add "subscriptionId", valid_564991
  var valid_564992 = path.getOrDefault("resourceGroupName")
  valid_564992 = validateParameter(valid_564992, JString, required = true,
                                 default = nil)
  if valid_564992 != nil:
    section.add "resourceGroupName", valid_564992
  var valid_564993 = path.getOrDefault("accountName")
  valid_564993 = validateParameter(valid_564993, JString, required = true,
                                 default = nil)
  if valid_564993 != nil:
    section.add "accountName", valid_564993
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564994 = query.getOrDefault("api-version")
  valid_564994 = validateParameter(valid_564994, JString, required = true,
                                 default = nil)
  if valid_564994 != nil:
    section.add "api-version", valid_564994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564995: Call_SqlResourcesListSqlDatabases_564988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the SQL databases under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_564995.validator(path, query, header, formData, body)
  let scheme = call_564995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564995.url(scheme.get, call_564995.host, call_564995.base,
                         call_564995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564995, url, valid)

proc call*(call_564996: Call_SqlResourcesListSqlDatabases_564988;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## sqlResourcesListSqlDatabases
  ## Lists the SQL databases under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564997 = newJObject()
  var query_564998 = newJObject()
  add(query_564998, "api-version", newJString(apiVersion))
  add(path_564997, "subscriptionId", newJString(subscriptionId))
  add(path_564997, "resourceGroupName", newJString(resourceGroupName))
  add(path_564997, "accountName", newJString(accountName))
  result = call_564996.call(path_564997, query_564998, nil, nil, nil)

var sqlResourcesListSqlDatabases* = Call_SqlResourcesListSqlDatabases_564988(
    name: "sqlResourcesListSqlDatabases", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases",
    validator: validate_SqlResourcesListSqlDatabases_564989, base: "",
    url: url_SqlResourcesListSqlDatabases_564990, schemes: {Scheme.Https})
type
  Call_SqlResourcesCreateUpdateSqlDatabase_565011 = ref object of OpenApiRestCall_563566
proc url_SqlResourcesCreateUpdateSqlDatabase_565013(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/sqlDatabases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlResourcesCreateUpdateSqlDatabase_565012(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an Azure Cosmos DB SQL database
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565014 = path.getOrDefault("subscriptionId")
  valid_565014 = validateParameter(valid_565014, JString, required = true,
                                 default = nil)
  if valid_565014 != nil:
    section.add "subscriptionId", valid_565014
  var valid_565015 = path.getOrDefault("databaseName")
  valid_565015 = validateParameter(valid_565015, JString, required = true,
                                 default = nil)
  if valid_565015 != nil:
    section.add "databaseName", valid_565015
  var valid_565016 = path.getOrDefault("resourceGroupName")
  valid_565016 = validateParameter(valid_565016, JString, required = true,
                                 default = nil)
  if valid_565016 != nil:
    section.add "resourceGroupName", valid_565016
  var valid_565017 = path.getOrDefault("accountName")
  valid_565017 = validateParameter(valid_565017, JString, required = true,
                                 default = nil)
  if valid_565017 != nil:
    section.add "accountName", valid_565017
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565018 = query.getOrDefault("api-version")
  valid_565018 = validateParameter(valid_565018, JString, required = true,
                                 default = nil)
  if valid_565018 != nil:
    section.add "api-version", valid_565018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   createUpdateSqlDatabaseParameters: JObject (required)
  ##                                    : The parameters to provide for the current SQL database.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565020: Call_SqlResourcesCreateUpdateSqlDatabase_565011;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB SQL database
  ## 
  let valid = call_565020.validator(path, query, header, formData, body)
  let scheme = call_565020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565020.url(scheme.get, call_565020.host, call_565020.base,
                         call_565020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565020, url, valid)

proc call*(call_565021: Call_SqlResourcesCreateUpdateSqlDatabase_565011;
          apiVersion: string; subscriptionId: string; databaseName: string;
          createUpdateSqlDatabaseParameters: JsonNode; resourceGroupName: string;
          accountName: string): Recallable =
  ## sqlResourcesCreateUpdateSqlDatabase
  ## Create or update an Azure Cosmos DB SQL database
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   createUpdateSqlDatabaseParameters: JObject (required)
  ##                                    : The parameters to provide for the current SQL database.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565022 = newJObject()
  var query_565023 = newJObject()
  var body_565024 = newJObject()
  add(query_565023, "api-version", newJString(apiVersion))
  add(path_565022, "subscriptionId", newJString(subscriptionId))
  add(path_565022, "databaseName", newJString(databaseName))
  if createUpdateSqlDatabaseParameters != nil:
    body_565024 = createUpdateSqlDatabaseParameters
  add(path_565022, "resourceGroupName", newJString(resourceGroupName))
  add(path_565022, "accountName", newJString(accountName))
  result = call_565021.call(path_565022, query_565023, nil, nil, body_565024)

var sqlResourcesCreateUpdateSqlDatabase* = Call_SqlResourcesCreateUpdateSqlDatabase_565011(
    name: "sqlResourcesCreateUpdateSqlDatabase", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}",
    validator: validate_SqlResourcesCreateUpdateSqlDatabase_565012, base: "",
    url: url_SqlResourcesCreateUpdateSqlDatabase_565013, schemes: {Scheme.Https})
type
  Call_SqlResourcesGetSqlDatabase_564999 = ref object of OpenApiRestCall_563566
proc url_SqlResourcesGetSqlDatabase_565001(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/sqlDatabases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlResourcesGetSqlDatabase_565000(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the SQL database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565002 = path.getOrDefault("subscriptionId")
  valid_565002 = validateParameter(valid_565002, JString, required = true,
                                 default = nil)
  if valid_565002 != nil:
    section.add "subscriptionId", valid_565002
  var valid_565003 = path.getOrDefault("databaseName")
  valid_565003 = validateParameter(valid_565003, JString, required = true,
                                 default = nil)
  if valid_565003 != nil:
    section.add "databaseName", valid_565003
  var valid_565004 = path.getOrDefault("resourceGroupName")
  valid_565004 = validateParameter(valid_565004, JString, required = true,
                                 default = nil)
  if valid_565004 != nil:
    section.add "resourceGroupName", valid_565004
  var valid_565005 = path.getOrDefault("accountName")
  valid_565005 = validateParameter(valid_565005, JString, required = true,
                                 default = nil)
  if valid_565005 != nil:
    section.add "accountName", valid_565005
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565006 = query.getOrDefault("api-version")
  valid_565006 = validateParameter(valid_565006, JString, required = true,
                                 default = nil)
  if valid_565006 != nil:
    section.add "api-version", valid_565006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565007: Call_SqlResourcesGetSqlDatabase_564999; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the SQL database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_565007.validator(path, query, header, formData, body)
  let scheme = call_565007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565007.url(scheme.get, call_565007.host, call_565007.base,
                         call_565007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565007, url, valid)

proc call*(call_565008: Call_SqlResourcesGetSqlDatabase_564999; apiVersion: string;
          subscriptionId: string; databaseName: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## sqlResourcesGetSqlDatabase
  ## Gets the SQL database under an existing Azure Cosmos DB database account with the provided name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565009 = newJObject()
  var query_565010 = newJObject()
  add(query_565010, "api-version", newJString(apiVersion))
  add(path_565009, "subscriptionId", newJString(subscriptionId))
  add(path_565009, "databaseName", newJString(databaseName))
  add(path_565009, "resourceGroupName", newJString(resourceGroupName))
  add(path_565009, "accountName", newJString(accountName))
  result = call_565008.call(path_565009, query_565010, nil, nil, nil)

var sqlResourcesGetSqlDatabase* = Call_SqlResourcesGetSqlDatabase_564999(
    name: "sqlResourcesGetSqlDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}",
    validator: validate_SqlResourcesGetSqlDatabase_565000, base: "",
    url: url_SqlResourcesGetSqlDatabase_565001, schemes: {Scheme.Https})
type
  Call_SqlResourcesDeleteSqlDatabase_565025 = ref object of OpenApiRestCall_563566
proc url_SqlResourcesDeleteSqlDatabase_565027(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/sqlDatabases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlResourcesDeleteSqlDatabase_565026(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Azure Cosmos DB SQL database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565028 = path.getOrDefault("subscriptionId")
  valid_565028 = validateParameter(valid_565028, JString, required = true,
                                 default = nil)
  if valid_565028 != nil:
    section.add "subscriptionId", valid_565028
  var valid_565029 = path.getOrDefault("databaseName")
  valid_565029 = validateParameter(valid_565029, JString, required = true,
                                 default = nil)
  if valid_565029 != nil:
    section.add "databaseName", valid_565029
  var valid_565030 = path.getOrDefault("resourceGroupName")
  valid_565030 = validateParameter(valid_565030, JString, required = true,
                                 default = nil)
  if valid_565030 != nil:
    section.add "resourceGroupName", valid_565030
  var valid_565031 = path.getOrDefault("accountName")
  valid_565031 = validateParameter(valid_565031, JString, required = true,
                                 default = nil)
  if valid_565031 != nil:
    section.add "accountName", valid_565031
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565032 = query.getOrDefault("api-version")
  valid_565032 = validateParameter(valid_565032, JString, required = true,
                                 default = nil)
  if valid_565032 != nil:
    section.add "api-version", valid_565032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565033: Call_SqlResourcesDeleteSqlDatabase_565025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB SQL database.
  ## 
  let valid = call_565033.validator(path, query, header, formData, body)
  let scheme = call_565033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565033.url(scheme.get, call_565033.host, call_565033.base,
                         call_565033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565033, url, valid)

proc call*(call_565034: Call_SqlResourcesDeleteSqlDatabase_565025;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## sqlResourcesDeleteSqlDatabase
  ## Deletes an existing Azure Cosmos DB SQL database.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565035 = newJObject()
  var query_565036 = newJObject()
  add(query_565036, "api-version", newJString(apiVersion))
  add(path_565035, "subscriptionId", newJString(subscriptionId))
  add(path_565035, "databaseName", newJString(databaseName))
  add(path_565035, "resourceGroupName", newJString(resourceGroupName))
  add(path_565035, "accountName", newJString(accountName))
  result = call_565034.call(path_565035, query_565036, nil, nil, nil)

var sqlResourcesDeleteSqlDatabase* = Call_SqlResourcesDeleteSqlDatabase_565025(
    name: "sqlResourcesDeleteSqlDatabase", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}",
    validator: validate_SqlResourcesDeleteSqlDatabase_565026, base: "",
    url: url_SqlResourcesDeleteSqlDatabase_565027, schemes: {Scheme.Https})
type
  Call_SqlResourcesListSqlContainers_565037 = ref object of OpenApiRestCall_563566
proc url_SqlResourcesListSqlContainers_565039(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/sqlDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/containers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlResourcesListSqlContainers_565038(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the SQL container under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565040 = path.getOrDefault("subscriptionId")
  valid_565040 = validateParameter(valid_565040, JString, required = true,
                                 default = nil)
  if valid_565040 != nil:
    section.add "subscriptionId", valid_565040
  var valid_565041 = path.getOrDefault("databaseName")
  valid_565041 = validateParameter(valid_565041, JString, required = true,
                                 default = nil)
  if valid_565041 != nil:
    section.add "databaseName", valid_565041
  var valid_565042 = path.getOrDefault("resourceGroupName")
  valid_565042 = validateParameter(valid_565042, JString, required = true,
                                 default = nil)
  if valid_565042 != nil:
    section.add "resourceGroupName", valid_565042
  var valid_565043 = path.getOrDefault("accountName")
  valid_565043 = validateParameter(valid_565043, JString, required = true,
                                 default = nil)
  if valid_565043 != nil:
    section.add "accountName", valid_565043
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565044 = query.getOrDefault("api-version")
  valid_565044 = validateParameter(valid_565044, JString, required = true,
                                 default = nil)
  if valid_565044 != nil:
    section.add "api-version", valid_565044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565045: Call_SqlResourcesListSqlContainers_565037; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the SQL container under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_565045.validator(path, query, header, formData, body)
  let scheme = call_565045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565045.url(scheme.get, call_565045.host, call_565045.base,
                         call_565045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565045, url, valid)

proc call*(call_565046: Call_SqlResourcesListSqlContainers_565037;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## sqlResourcesListSqlContainers
  ## Lists the SQL container under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565047 = newJObject()
  var query_565048 = newJObject()
  add(query_565048, "api-version", newJString(apiVersion))
  add(path_565047, "subscriptionId", newJString(subscriptionId))
  add(path_565047, "databaseName", newJString(databaseName))
  add(path_565047, "resourceGroupName", newJString(resourceGroupName))
  add(path_565047, "accountName", newJString(accountName))
  result = call_565046.call(path_565047, query_565048, nil, nil, nil)

var sqlResourcesListSqlContainers* = Call_SqlResourcesListSqlContainers_565037(
    name: "sqlResourcesListSqlContainers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers",
    validator: validate_SqlResourcesListSqlContainers_565038, base: "",
    url: url_SqlResourcesListSqlContainers_565039, schemes: {Scheme.Https})
type
  Call_SqlResourcesCreateUpdateSqlContainer_565062 = ref object of OpenApiRestCall_563566
proc url_SqlResourcesCreateUpdateSqlContainer_565064(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/sqlDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlResourcesCreateUpdateSqlContainer_565063(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an Azure Cosmos DB SQL container
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565065 = path.getOrDefault("subscriptionId")
  valid_565065 = validateParameter(valid_565065, JString, required = true,
                                 default = nil)
  if valid_565065 != nil:
    section.add "subscriptionId", valid_565065
  var valid_565066 = path.getOrDefault("databaseName")
  valid_565066 = validateParameter(valid_565066, JString, required = true,
                                 default = nil)
  if valid_565066 != nil:
    section.add "databaseName", valid_565066
  var valid_565067 = path.getOrDefault("resourceGroupName")
  valid_565067 = validateParameter(valid_565067, JString, required = true,
                                 default = nil)
  if valid_565067 != nil:
    section.add "resourceGroupName", valid_565067
  var valid_565068 = path.getOrDefault("containerName")
  valid_565068 = validateParameter(valid_565068, JString, required = true,
                                 default = nil)
  if valid_565068 != nil:
    section.add "containerName", valid_565068
  var valid_565069 = path.getOrDefault("accountName")
  valid_565069 = validateParameter(valid_565069, JString, required = true,
                                 default = nil)
  if valid_565069 != nil:
    section.add "accountName", valid_565069
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565070 = query.getOrDefault("api-version")
  valid_565070 = validateParameter(valid_565070, JString, required = true,
                                 default = nil)
  if valid_565070 != nil:
    section.add "api-version", valid_565070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   createUpdateSqlContainerParameters: JObject (required)
  ##                                     : The parameters to provide for the current SQL container.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565072: Call_SqlResourcesCreateUpdateSqlContainer_565062;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB SQL container
  ## 
  let valid = call_565072.validator(path, query, header, formData, body)
  let scheme = call_565072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565072.url(scheme.get, call_565072.host, call_565072.base,
                         call_565072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565072, url, valid)

proc call*(call_565073: Call_SqlResourcesCreateUpdateSqlContainer_565062;
          apiVersion: string; subscriptionId: string;
          createUpdateSqlContainerParameters: JsonNode; databaseName: string;
          resourceGroupName: string; containerName: string; accountName: string): Recallable =
  ## sqlResourcesCreateUpdateSqlContainer
  ## Create or update an Azure Cosmos DB SQL container
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   createUpdateSqlContainerParameters: JObject (required)
  ##                                     : The parameters to provide for the current SQL container.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565074 = newJObject()
  var query_565075 = newJObject()
  var body_565076 = newJObject()
  add(query_565075, "api-version", newJString(apiVersion))
  add(path_565074, "subscriptionId", newJString(subscriptionId))
  if createUpdateSqlContainerParameters != nil:
    body_565076 = createUpdateSqlContainerParameters
  add(path_565074, "databaseName", newJString(databaseName))
  add(path_565074, "resourceGroupName", newJString(resourceGroupName))
  add(path_565074, "containerName", newJString(containerName))
  add(path_565074, "accountName", newJString(accountName))
  result = call_565073.call(path_565074, query_565075, nil, nil, body_565076)

var sqlResourcesCreateUpdateSqlContainer* = Call_SqlResourcesCreateUpdateSqlContainer_565062(
    name: "sqlResourcesCreateUpdateSqlContainer", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}",
    validator: validate_SqlResourcesCreateUpdateSqlContainer_565063, base: "",
    url: url_SqlResourcesCreateUpdateSqlContainer_565064, schemes: {Scheme.Https})
type
  Call_SqlResourcesGetSqlContainer_565049 = ref object of OpenApiRestCall_563566
proc url_SqlResourcesGetSqlContainer_565051(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/sqlDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlResourcesGetSqlContainer_565050(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the SQL container under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565052 = path.getOrDefault("subscriptionId")
  valid_565052 = validateParameter(valid_565052, JString, required = true,
                                 default = nil)
  if valid_565052 != nil:
    section.add "subscriptionId", valid_565052
  var valid_565053 = path.getOrDefault("databaseName")
  valid_565053 = validateParameter(valid_565053, JString, required = true,
                                 default = nil)
  if valid_565053 != nil:
    section.add "databaseName", valid_565053
  var valid_565054 = path.getOrDefault("resourceGroupName")
  valid_565054 = validateParameter(valid_565054, JString, required = true,
                                 default = nil)
  if valid_565054 != nil:
    section.add "resourceGroupName", valid_565054
  var valid_565055 = path.getOrDefault("containerName")
  valid_565055 = validateParameter(valid_565055, JString, required = true,
                                 default = nil)
  if valid_565055 != nil:
    section.add "containerName", valid_565055
  var valid_565056 = path.getOrDefault("accountName")
  valid_565056 = validateParameter(valid_565056, JString, required = true,
                                 default = nil)
  if valid_565056 != nil:
    section.add "accountName", valid_565056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565057 = query.getOrDefault("api-version")
  valid_565057 = validateParameter(valid_565057, JString, required = true,
                                 default = nil)
  if valid_565057 != nil:
    section.add "api-version", valid_565057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565058: Call_SqlResourcesGetSqlContainer_565049; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the SQL container under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_565058.validator(path, query, header, formData, body)
  let scheme = call_565058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565058.url(scheme.get, call_565058.host, call_565058.base,
                         call_565058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565058, url, valid)

proc call*(call_565059: Call_SqlResourcesGetSqlContainer_565049;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; containerName: string; accountName: string): Recallable =
  ## sqlResourcesGetSqlContainer
  ## Gets the SQL container under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565060 = newJObject()
  var query_565061 = newJObject()
  add(query_565061, "api-version", newJString(apiVersion))
  add(path_565060, "subscriptionId", newJString(subscriptionId))
  add(path_565060, "databaseName", newJString(databaseName))
  add(path_565060, "resourceGroupName", newJString(resourceGroupName))
  add(path_565060, "containerName", newJString(containerName))
  add(path_565060, "accountName", newJString(accountName))
  result = call_565059.call(path_565060, query_565061, nil, nil, nil)

var sqlResourcesGetSqlContainer* = Call_SqlResourcesGetSqlContainer_565049(
    name: "sqlResourcesGetSqlContainer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}",
    validator: validate_SqlResourcesGetSqlContainer_565050, base: "",
    url: url_SqlResourcesGetSqlContainer_565051, schemes: {Scheme.Https})
type
  Call_SqlResourcesDeleteSqlContainer_565077 = ref object of OpenApiRestCall_563566
proc url_SqlResourcesDeleteSqlContainer_565079(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/sqlDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlResourcesDeleteSqlContainer_565078(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Azure Cosmos DB SQL container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565080 = path.getOrDefault("subscriptionId")
  valid_565080 = validateParameter(valid_565080, JString, required = true,
                                 default = nil)
  if valid_565080 != nil:
    section.add "subscriptionId", valid_565080
  var valid_565081 = path.getOrDefault("databaseName")
  valid_565081 = validateParameter(valid_565081, JString, required = true,
                                 default = nil)
  if valid_565081 != nil:
    section.add "databaseName", valid_565081
  var valid_565082 = path.getOrDefault("resourceGroupName")
  valid_565082 = validateParameter(valid_565082, JString, required = true,
                                 default = nil)
  if valid_565082 != nil:
    section.add "resourceGroupName", valid_565082
  var valid_565083 = path.getOrDefault("containerName")
  valid_565083 = validateParameter(valid_565083, JString, required = true,
                                 default = nil)
  if valid_565083 != nil:
    section.add "containerName", valid_565083
  var valid_565084 = path.getOrDefault("accountName")
  valid_565084 = validateParameter(valid_565084, JString, required = true,
                                 default = nil)
  if valid_565084 != nil:
    section.add "accountName", valid_565084
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565085 = query.getOrDefault("api-version")
  valid_565085 = validateParameter(valid_565085, JString, required = true,
                                 default = nil)
  if valid_565085 != nil:
    section.add "api-version", valid_565085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565086: Call_SqlResourcesDeleteSqlContainer_565077; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB SQL container.
  ## 
  let valid = call_565086.validator(path, query, header, formData, body)
  let scheme = call_565086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565086.url(scheme.get, call_565086.host, call_565086.base,
                         call_565086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565086, url, valid)

proc call*(call_565087: Call_SqlResourcesDeleteSqlContainer_565077;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; containerName: string; accountName: string): Recallable =
  ## sqlResourcesDeleteSqlContainer
  ## Deletes an existing Azure Cosmos DB SQL container.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565088 = newJObject()
  var query_565089 = newJObject()
  add(query_565089, "api-version", newJString(apiVersion))
  add(path_565088, "subscriptionId", newJString(subscriptionId))
  add(path_565088, "databaseName", newJString(databaseName))
  add(path_565088, "resourceGroupName", newJString(resourceGroupName))
  add(path_565088, "containerName", newJString(containerName))
  add(path_565088, "accountName", newJString(accountName))
  result = call_565087.call(path_565088, query_565089, nil, nil, nil)

var sqlResourcesDeleteSqlContainer* = Call_SqlResourcesDeleteSqlContainer_565077(
    name: "sqlResourcesDeleteSqlContainer", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}",
    validator: validate_SqlResourcesDeleteSqlContainer_565078, base: "",
    url: url_SqlResourcesDeleteSqlContainer_565079, schemes: {Scheme.Https})
type
  Call_SqlResourcesListSqlStoredProcedures_565090 = ref object of OpenApiRestCall_563566
proc url_SqlResourcesListSqlStoredProcedures_565092(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/sqlDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/storedProcedures/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlResourcesListSqlStoredProcedures_565091(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the SQL storedProcedure under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565093 = path.getOrDefault("subscriptionId")
  valid_565093 = validateParameter(valid_565093, JString, required = true,
                                 default = nil)
  if valid_565093 != nil:
    section.add "subscriptionId", valid_565093
  var valid_565094 = path.getOrDefault("databaseName")
  valid_565094 = validateParameter(valid_565094, JString, required = true,
                                 default = nil)
  if valid_565094 != nil:
    section.add "databaseName", valid_565094
  var valid_565095 = path.getOrDefault("resourceGroupName")
  valid_565095 = validateParameter(valid_565095, JString, required = true,
                                 default = nil)
  if valid_565095 != nil:
    section.add "resourceGroupName", valid_565095
  var valid_565096 = path.getOrDefault("containerName")
  valid_565096 = validateParameter(valid_565096, JString, required = true,
                                 default = nil)
  if valid_565096 != nil:
    section.add "containerName", valid_565096
  var valid_565097 = path.getOrDefault("accountName")
  valid_565097 = validateParameter(valid_565097, JString, required = true,
                                 default = nil)
  if valid_565097 != nil:
    section.add "accountName", valid_565097
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565098 = query.getOrDefault("api-version")
  valid_565098 = validateParameter(valid_565098, JString, required = true,
                                 default = nil)
  if valid_565098 != nil:
    section.add "api-version", valid_565098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565099: Call_SqlResourcesListSqlStoredProcedures_565090;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the SQL storedProcedure under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_565099.validator(path, query, header, formData, body)
  let scheme = call_565099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565099.url(scheme.get, call_565099.host, call_565099.base,
                         call_565099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565099, url, valid)

proc call*(call_565100: Call_SqlResourcesListSqlStoredProcedures_565090;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; containerName: string; accountName: string): Recallable =
  ## sqlResourcesListSqlStoredProcedures
  ## Lists the SQL storedProcedure under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565101 = newJObject()
  var query_565102 = newJObject()
  add(query_565102, "api-version", newJString(apiVersion))
  add(path_565101, "subscriptionId", newJString(subscriptionId))
  add(path_565101, "databaseName", newJString(databaseName))
  add(path_565101, "resourceGroupName", newJString(resourceGroupName))
  add(path_565101, "containerName", newJString(containerName))
  add(path_565101, "accountName", newJString(accountName))
  result = call_565100.call(path_565101, query_565102, nil, nil, nil)

var sqlResourcesListSqlStoredProcedures* = Call_SqlResourcesListSqlStoredProcedures_565090(
    name: "sqlResourcesListSqlStoredProcedures", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}/storedProcedures/",
    validator: validate_SqlResourcesListSqlStoredProcedures_565091, base: "",
    url: url_SqlResourcesListSqlStoredProcedures_565092, schemes: {Scheme.Https})
type
  Call_SqlResourcesCreateUpdateSqlStoredProcedure_565117 = ref object of OpenApiRestCall_563566
proc url_SqlResourcesCreateUpdateSqlStoredProcedure_565119(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "storedProcedureName" in path,
        "`storedProcedureName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/sqlDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/storedProcedures/"),
               (kind: VariableSegment, value: "storedProcedureName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlResourcesCreateUpdateSqlStoredProcedure_565118(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an Azure Cosmos DB SQL storedProcedure
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   storedProcedureName: JString (required)
  ##                      : Cosmos DB storedProcedure name.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565120 = path.getOrDefault("subscriptionId")
  valid_565120 = validateParameter(valid_565120, JString, required = true,
                                 default = nil)
  if valid_565120 != nil:
    section.add "subscriptionId", valid_565120
  var valid_565121 = path.getOrDefault("storedProcedureName")
  valid_565121 = validateParameter(valid_565121, JString, required = true,
                                 default = nil)
  if valid_565121 != nil:
    section.add "storedProcedureName", valid_565121
  var valid_565122 = path.getOrDefault("databaseName")
  valid_565122 = validateParameter(valid_565122, JString, required = true,
                                 default = nil)
  if valid_565122 != nil:
    section.add "databaseName", valid_565122
  var valid_565123 = path.getOrDefault("resourceGroupName")
  valid_565123 = validateParameter(valid_565123, JString, required = true,
                                 default = nil)
  if valid_565123 != nil:
    section.add "resourceGroupName", valid_565123
  var valid_565124 = path.getOrDefault("containerName")
  valid_565124 = validateParameter(valid_565124, JString, required = true,
                                 default = nil)
  if valid_565124 != nil:
    section.add "containerName", valid_565124
  var valid_565125 = path.getOrDefault("accountName")
  valid_565125 = validateParameter(valid_565125, JString, required = true,
                                 default = nil)
  if valid_565125 != nil:
    section.add "accountName", valid_565125
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565126 = query.getOrDefault("api-version")
  valid_565126 = validateParameter(valid_565126, JString, required = true,
                                 default = nil)
  if valid_565126 != nil:
    section.add "api-version", valid_565126
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   createUpdateSqlStoredProcedureParameters: JObject (required)
  ##                                           : The parameters to provide for the current SQL storedProcedure.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565128: Call_SqlResourcesCreateUpdateSqlStoredProcedure_565117;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB SQL storedProcedure
  ## 
  let valid = call_565128.validator(path, query, header, formData, body)
  let scheme = call_565128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565128.url(scheme.get, call_565128.host, call_565128.base,
                         call_565128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565128, url, valid)

proc call*(call_565129: Call_SqlResourcesCreateUpdateSqlStoredProcedure_565117;
          apiVersion: string; subscriptionId: string; storedProcedureName: string;
          databaseName: string;
          createUpdateSqlStoredProcedureParameters: JsonNode;
          resourceGroupName: string; containerName: string; accountName: string): Recallable =
  ## sqlResourcesCreateUpdateSqlStoredProcedure
  ## Create or update an Azure Cosmos DB SQL storedProcedure
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   storedProcedureName: string (required)
  ##                      : Cosmos DB storedProcedure name.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   createUpdateSqlStoredProcedureParameters: JObject (required)
  ##                                           : The parameters to provide for the current SQL storedProcedure.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565130 = newJObject()
  var query_565131 = newJObject()
  var body_565132 = newJObject()
  add(query_565131, "api-version", newJString(apiVersion))
  add(path_565130, "subscriptionId", newJString(subscriptionId))
  add(path_565130, "storedProcedureName", newJString(storedProcedureName))
  add(path_565130, "databaseName", newJString(databaseName))
  if createUpdateSqlStoredProcedureParameters != nil:
    body_565132 = createUpdateSqlStoredProcedureParameters
  add(path_565130, "resourceGroupName", newJString(resourceGroupName))
  add(path_565130, "containerName", newJString(containerName))
  add(path_565130, "accountName", newJString(accountName))
  result = call_565129.call(path_565130, query_565131, nil, nil, body_565132)

var sqlResourcesCreateUpdateSqlStoredProcedure* = Call_SqlResourcesCreateUpdateSqlStoredProcedure_565117(
    name: "sqlResourcesCreateUpdateSqlStoredProcedure", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}/storedProcedures/{storedProcedureName}",
    validator: validate_SqlResourcesCreateUpdateSqlStoredProcedure_565118,
    base: "", url: url_SqlResourcesCreateUpdateSqlStoredProcedure_565119,
    schemes: {Scheme.Https})
type
  Call_SqlResourcesGetSqlStoredProcedure_565103 = ref object of OpenApiRestCall_563566
proc url_SqlResourcesGetSqlStoredProcedure_565105(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "storedProcedureName" in path,
        "`storedProcedureName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/sqlDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/storedProcedures/"),
               (kind: VariableSegment, value: "storedProcedureName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlResourcesGetSqlStoredProcedure_565104(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the SQL storedProcedure under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   storedProcedureName: JString (required)
  ##                      : Cosmos DB storedProcedure name.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565106 = path.getOrDefault("subscriptionId")
  valid_565106 = validateParameter(valid_565106, JString, required = true,
                                 default = nil)
  if valid_565106 != nil:
    section.add "subscriptionId", valid_565106
  var valid_565107 = path.getOrDefault("storedProcedureName")
  valid_565107 = validateParameter(valid_565107, JString, required = true,
                                 default = nil)
  if valid_565107 != nil:
    section.add "storedProcedureName", valid_565107
  var valid_565108 = path.getOrDefault("databaseName")
  valid_565108 = validateParameter(valid_565108, JString, required = true,
                                 default = nil)
  if valid_565108 != nil:
    section.add "databaseName", valid_565108
  var valid_565109 = path.getOrDefault("resourceGroupName")
  valid_565109 = validateParameter(valid_565109, JString, required = true,
                                 default = nil)
  if valid_565109 != nil:
    section.add "resourceGroupName", valid_565109
  var valid_565110 = path.getOrDefault("containerName")
  valid_565110 = validateParameter(valid_565110, JString, required = true,
                                 default = nil)
  if valid_565110 != nil:
    section.add "containerName", valid_565110
  var valid_565111 = path.getOrDefault("accountName")
  valid_565111 = validateParameter(valid_565111, JString, required = true,
                                 default = nil)
  if valid_565111 != nil:
    section.add "accountName", valid_565111
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565112 = query.getOrDefault("api-version")
  valid_565112 = validateParameter(valid_565112, JString, required = true,
                                 default = nil)
  if valid_565112 != nil:
    section.add "api-version", valid_565112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565113: Call_SqlResourcesGetSqlStoredProcedure_565103;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the SQL storedProcedure under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_565113.validator(path, query, header, formData, body)
  let scheme = call_565113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565113.url(scheme.get, call_565113.host, call_565113.base,
                         call_565113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565113, url, valid)

proc call*(call_565114: Call_SqlResourcesGetSqlStoredProcedure_565103;
          apiVersion: string; subscriptionId: string; storedProcedureName: string;
          databaseName: string; resourceGroupName: string; containerName: string;
          accountName: string): Recallable =
  ## sqlResourcesGetSqlStoredProcedure
  ## Gets the SQL storedProcedure under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   storedProcedureName: string (required)
  ##                      : Cosmos DB storedProcedure name.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565115 = newJObject()
  var query_565116 = newJObject()
  add(query_565116, "api-version", newJString(apiVersion))
  add(path_565115, "subscriptionId", newJString(subscriptionId))
  add(path_565115, "storedProcedureName", newJString(storedProcedureName))
  add(path_565115, "databaseName", newJString(databaseName))
  add(path_565115, "resourceGroupName", newJString(resourceGroupName))
  add(path_565115, "containerName", newJString(containerName))
  add(path_565115, "accountName", newJString(accountName))
  result = call_565114.call(path_565115, query_565116, nil, nil, nil)

var sqlResourcesGetSqlStoredProcedure* = Call_SqlResourcesGetSqlStoredProcedure_565103(
    name: "sqlResourcesGetSqlStoredProcedure", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}/storedProcedures/{storedProcedureName}",
    validator: validate_SqlResourcesGetSqlStoredProcedure_565104, base: "",
    url: url_SqlResourcesGetSqlStoredProcedure_565105, schemes: {Scheme.Https})
type
  Call_SqlResourcesDeleteSqlStoredProcedure_565133 = ref object of OpenApiRestCall_563566
proc url_SqlResourcesDeleteSqlStoredProcedure_565135(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "storedProcedureName" in path,
        "`storedProcedureName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/sqlDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/storedProcedures/"),
               (kind: VariableSegment, value: "storedProcedureName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlResourcesDeleteSqlStoredProcedure_565134(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Azure Cosmos DB SQL storedProcedure.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   storedProcedureName: JString (required)
  ##                      : Cosmos DB storedProcedure name.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565136 = path.getOrDefault("subscriptionId")
  valid_565136 = validateParameter(valid_565136, JString, required = true,
                                 default = nil)
  if valid_565136 != nil:
    section.add "subscriptionId", valid_565136
  var valid_565137 = path.getOrDefault("storedProcedureName")
  valid_565137 = validateParameter(valid_565137, JString, required = true,
                                 default = nil)
  if valid_565137 != nil:
    section.add "storedProcedureName", valid_565137
  var valid_565138 = path.getOrDefault("databaseName")
  valid_565138 = validateParameter(valid_565138, JString, required = true,
                                 default = nil)
  if valid_565138 != nil:
    section.add "databaseName", valid_565138
  var valid_565139 = path.getOrDefault("resourceGroupName")
  valid_565139 = validateParameter(valid_565139, JString, required = true,
                                 default = nil)
  if valid_565139 != nil:
    section.add "resourceGroupName", valid_565139
  var valid_565140 = path.getOrDefault("containerName")
  valid_565140 = validateParameter(valid_565140, JString, required = true,
                                 default = nil)
  if valid_565140 != nil:
    section.add "containerName", valid_565140
  var valid_565141 = path.getOrDefault("accountName")
  valid_565141 = validateParameter(valid_565141, JString, required = true,
                                 default = nil)
  if valid_565141 != nil:
    section.add "accountName", valid_565141
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565142 = query.getOrDefault("api-version")
  valid_565142 = validateParameter(valid_565142, JString, required = true,
                                 default = nil)
  if valid_565142 != nil:
    section.add "api-version", valid_565142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565143: Call_SqlResourcesDeleteSqlStoredProcedure_565133;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB SQL storedProcedure.
  ## 
  let valid = call_565143.validator(path, query, header, formData, body)
  let scheme = call_565143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565143.url(scheme.get, call_565143.host, call_565143.base,
                         call_565143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565143, url, valid)

proc call*(call_565144: Call_SqlResourcesDeleteSqlStoredProcedure_565133;
          apiVersion: string; subscriptionId: string; storedProcedureName: string;
          databaseName: string; resourceGroupName: string; containerName: string;
          accountName: string): Recallable =
  ## sqlResourcesDeleteSqlStoredProcedure
  ## Deletes an existing Azure Cosmos DB SQL storedProcedure.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   storedProcedureName: string (required)
  ##                      : Cosmos DB storedProcedure name.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565145 = newJObject()
  var query_565146 = newJObject()
  add(query_565146, "api-version", newJString(apiVersion))
  add(path_565145, "subscriptionId", newJString(subscriptionId))
  add(path_565145, "storedProcedureName", newJString(storedProcedureName))
  add(path_565145, "databaseName", newJString(databaseName))
  add(path_565145, "resourceGroupName", newJString(resourceGroupName))
  add(path_565145, "containerName", newJString(containerName))
  add(path_565145, "accountName", newJString(accountName))
  result = call_565144.call(path_565145, query_565146, nil, nil, nil)

var sqlResourcesDeleteSqlStoredProcedure* = Call_SqlResourcesDeleteSqlStoredProcedure_565133(
    name: "sqlResourcesDeleteSqlStoredProcedure", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}/storedProcedures/{storedProcedureName}",
    validator: validate_SqlResourcesDeleteSqlStoredProcedure_565134, base: "",
    url: url_SqlResourcesDeleteSqlStoredProcedure_565135, schemes: {Scheme.Https})
type
  Call_SqlResourcesUpdateSqlContainerThroughput_565160 = ref object of OpenApiRestCall_563566
proc url_SqlResourcesUpdateSqlContainerThroughput_565162(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/sqlDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/throughputSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlResourcesUpdateSqlContainerThroughput_565161(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update RUs per second of an Azure Cosmos DB SQL container
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565163 = path.getOrDefault("subscriptionId")
  valid_565163 = validateParameter(valid_565163, JString, required = true,
                                 default = nil)
  if valid_565163 != nil:
    section.add "subscriptionId", valid_565163
  var valid_565164 = path.getOrDefault("databaseName")
  valid_565164 = validateParameter(valid_565164, JString, required = true,
                                 default = nil)
  if valid_565164 != nil:
    section.add "databaseName", valid_565164
  var valid_565165 = path.getOrDefault("resourceGroupName")
  valid_565165 = validateParameter(valid_565165, JString, required = true,
                                 default = nil)
  if valid_565165 != nil:
    section.add "resourceGroupName", valid_565165
  var valid_565166 = path.getOrDefault("containerName")
  valid_565166 = validateParameter(valid_565166, JString, required = true,
                                 default = nil)
  if valid_565166 != nil:
    section.add "containerName", valid_565166
  var valid_565167 = path.getOrDefault("accountName")
  valid_565167 = validateParameter(valid_565167, JString, required = true,
                                 default = nil)
  if valid_565167 != nil:
    section.add "accountName", valid_565167
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565168 = query.getOrDefault("api-version")
  valid_565168 = validateParameter(valid_565168, JString, required = true,
                                 default = nil)
  if valid_565168 != nil:
    section.add "api-version", valid_565168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   updateThroughputParameters: JObject (required)
  ##                             : The parameters to provide for the RUs per second of the current SQL container.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565170: Call_SqlResourcesUpdateSqlContainerThroughput_565160;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB SQL container
  ## 
  let valid = call_565170.validator(path, query, header, formData, body)
  let scheme = call_565170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565170.url(scheme.get, call_565170.host, call_565170.base,
                         call_565170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565170, url, valid)

proc call*(call_565171: Call_SqlResourcesUpdateSqlContainerThroughput_565160;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; containerName: string; accountName: string;
          updateThroughputParameters: JsonNode): Recallable =
  ## sqlResourcesUpdateSqlContainerThroughput
  ## Update RUs per second of an Azure Cosmos DB SQL container
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   updateThroughputParameters: JObject (required)
  ##                             : The parameters to provide for the RUs per second of the current SQL container.
  var path_565172 = newJObject()
  var query_565173 = newJObject()
  var body_565174 = newJObject()
  add(query_565173, "api-version", newJString(apiVersion))
  add(path_565172, "subscriptionId", newJString(subscriptionId))
  add(path_565172, "databaseName", newJString(databaseName))
  add(path_565172, "resourceGroupName", newJString(resourceGroupName))
  add(path_565172, "containerName", newJString(containerName))
  add(path_565172, "accountName", newJString(accountName))
  if updateThroughputParameters != nil:
    body_565174 = updateThroughputParameters
  result = call_565171.call(path_565172, query_565173, nil, nil, body_565174)

var sqlResourcesUpdateSqlContainerThroughput* = Call_SqlResourcesUpdateSqlContainerThroughput_565160(
    name: "sqlResourcesUpdateSqlContainerThroughput", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}/throughputSettings/default",
    validator: validate_SqlResourcesUpdateSqlContainerThroughput_565161, base: "",
    url: url_SqlResourcesUpdateSqlContainerThroughput_565162,
    schemes: {Scheme.Https})
type
  Call_SqlResourcesGetSqlContainerThroughput_565147 = ref object of OpenApiRestCall_563566
proc url_SqlResourcesGetSqlContainerThroughput_565149(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/sqlDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/throughputSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlResourcesGetSqlContainerThroughput_565148(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the RUs per second of the SQL container under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565150 = path.getOrDefault("subscriptionId")
  valid_565150 = validateParameter(valid_565150, JString, required = true,
                                 default = nil)
  if valid_565150 != nil:
    section.add "subscriptionId", valid_565150
  var valid_565151 = path.getOrDefault("databaseName")
  valid_565151 = validateParameter(valid_565151, JString, required = true,
                                 default = nil)
  if valid_565151 != nil:
    section.add "databaseName", valid_565151
  var valid_565152 = path.getOrDefault("resourceGroupName")
  valid_565152 = validateParameter(valid_565152, JString, required = true,
                                 default = nil)
  if valid_565152 != nil:
    section.add "resourceGroupName", valid_565152
  var valid_565153 = path.getOrDefault("containerName")
  valid_565153 = validateParameter(valid_565153, JString, required = true,
                                 default = nil)
  if valid_565153 != nil:
    section.add "containerName", valid_565153
  var valid_565154 = path.getOrDefault("accountName")
  valid_565154 = validateParameter(valid_565154, JString, required = true,
                                 default = nil)
  if valid_565154 != nil:
    section.add "accountName", valid_565154
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565155 = query.getOrDefault("api-version")
  valid_565155 = validateParameter(valid_565155, JString, required = true,
                                 default = nil)
  if valid_565155 != nil:
    section.add "api-version", valid_565155
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565156: Call_SqlResourcesGetSqlContainerThroughput_565147;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the SQL container under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_565156.validator(path, query, header, formData, body)
  let scheme = call_565156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565156.url(scheme.get, call_565156.host, call_565156.base,
                         call_565156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565156, url, valid)

proc call*(call_565157: Call_SqlResourcesGetSqlContainerThroughput_565147;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; containerName: string; accountName: string): Recallable =
  ## sqlResourcesGetSqlContainerThroughput
  ## Gets the RUs per second of the SQL container under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565158 = newJObject()
  var query_565159 = newJObject()
  add(query_565159, "api-version", newJString(apiVersion))
  add(path_565158, "subscriptionId", newJString(subscriptionId))
  add(path_565158, "databaseName", newJString(databaseName))
  add(path_565158, "resourceGroupName", newJString(resourceGroupName))
  add(path_565158, "containerName", newJString(containerName))
  add(path_565158, "accountName", newJString(accountName))
  result = call_565157.call(path_565158, query_565159, nil, nil, nil)

var sqlResourcesGetSqlContainerThroughput* = Call_SqlResourcesGetSqlContainerThroughput_565147(
    name: "sqlResourcesGetSqlContainerThroughput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}/throughputSettings/default",
    validator: validate_SqlResourcesGetSqlContainerThroughput_565148, base: "",
    url: url_SqlResourcesGetSqlContainerThroughput_565149, schemes: {Scheme.Https})
type
  Call_SqlResourcesListSqlTriggers_565175 = ref object of OpenApiRestCall_563566
proc url_SqlResourcesListSqlTriggers_565177(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/sqlDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/triggers/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlResourcesListSqlTriggers_565176(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the SQL trigger under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565178 = path.getOrDefault("subscriptionId")
  valid_565178 = validateParameter(valid_565178, JString, required = true,
                                 default = nil)
  if valid_565178 != nil:
    section.add "subscriptionId", valid_565178
  var valid_565179 = path.getOrDefault("databaseName")
  valid_565179 = validateParameter(valid_565179, JString, required = true,
                                 default = nil)
  if valid_565179 != nil:
    section.add "databaseName", valid_565179
  var valid_565180 = path.getOrDefault("resourceGroupName")
  valid_565180 = validateParameter(valid_565180, JString, required = true,
                                 default = nil)
  if valid_565180 != nil:
    section.add "resourceGroupName", valid_565180
  var valid_565181 = path.getOrDefault("containerName")
  valid_565181 = validateParameter(valid_565181, JString, required = true,
                                 default = nil)
  if valid_565181 != nil:
    section.add "containerName", valid_565181
  var valid_565182 = path.getOrDefault("accountName")
  valid_565182 = validateParameter(valid_565182, JString, required = true,
                                 default = nil)
  if valid_565182 != nil:
    section.add "accountName", valid_565182
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565183 = query.getOrDefault("api-version")
  valid_565183 = validateParameter(valid_565183, JString, required = true,
                                 default = nil)
  if valid_565183 != nil:
    section.add "api-version", valid_565183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565184: Call_SqlResourcesListSqlTriggers_565175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the SQL trigger under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_565184.validator(path, query, header, formData, body)
  let scheme = call_565184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565184.url(scheme.get, call_565184.host, call_565184.base,
                         call_565184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565184, url, valid)

proc call*(call_565185: Call_SqlResourcesListSqlTriggers_565175;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; containerName: string; accountName: string): Recallable =
  ## sqlResourcesListSqlTriggers
  ## Lists the SQL trigger under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565186 = newJObject()
  var query_565187 = newJObject()
  add(query_565187, "api-version", newJString(apiVersion))
  add(path_565186, "subscriptionId", newJString(subscriptionId))
  add(path_565186, "databaseName", newJString(databaseName))
  add(path_565186, "resourceGroupName", newJString(resourceGroupName))
  add(path_565186, "containerName", newJString(containerName))
  add(path_565186, "accountName", newJString(accountName))
  result = call_565185.call(path_565186, query_565187, nil, nil, nil)

var sqlResourcesListSqlTriggers* = Call_SqlResourcesListSqlTriggers_565175(
    name: "sqlResourcesListSqlTriggers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}/triggers/",
    validator: validate_SqlResourcesListSqlTriggers_565176, base: "",
    url: url_SqlResourcesListSqlTriggers_565177, schemes: {Scheme.Https})
type
  Call_SqlResourcesCreateUpdateSqlTrigger_565202 = ref object of OpenApiRestCall_563566
proc url_SqlResourcesCreateUpdateSqlTrigger_565204(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/sqlDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlResourcesCreateUpdateSqlTrigger_565203(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an Azure Cosmos DB SQL trigger
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   triggerName: JString (required)
  ##              : Cosmos DB trigger name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565205 = path.getOrDefault("subscriptionId")
  valid_565205 = validateParameter(valid_565205, JString, required = true,
                                 default = nil)
  if valid_565205 != nil:
    section.add "subscriptionId", valid_565205
  var valid_565206 = path.getOrDefault("databaseName")
  valid_565206 = validateParameter(valid_565206, JString, required = true,
                                 default = nil)
  if valid_565206 != nil:
    section.add "databaseName", valid_565206
  var valid_565207 = path.getOrDefault("resourceGroupName")
  valid_565207 = validateParameter(valid_565207, JString, required = true,
                                 default = nil)
  if valid_565207 != nil:
    section.add "resourceGroupName", valid_565207
  var valid_565208 = path.getOrDefault("containerName")
  valid_565208 = validateParameter(valid_565208, JString, required = true,
                                 default = nil)
  if valid_565208 != nil:
    section.add "containerName", valid_565208
  var valid_565209 = path.getOrDefault("triggerName")
  valid_565209 = validateParameter(valid_565209, JString, required = true,
                                 default = nil)
  if valid_565209 != nil:
    section.add "triggerName", valid_565209
  var valid_565210 = path.getOrDefault("accountName")
  valid_565210 = validateParameter(valid_565210, JString, required = true,
                                 default = nil)
  if valid_565210 != nil:
    section.add "accountName", valid_565210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565211 = query.getOrDefault("api-version")
  valid_565211 = validateParameter(valid_565211, JString, required = true,
                                 default = nil)
  if valid_565211 != nil:
    section.add "api-version", valid_565211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   createUpdateSqlTriggerParameters: JObject (required)
  ##                                   : The parameters to provide for the current SQL trigger.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565213: Call_SqlResourcesCreateUpdateSqlTrigger_565202;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB SQL trigger
  ## 
  let valid = call_565213.validator(path, query, header, formData, body)
  let scheme = call_565213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565213.url(scheme.get, call_565213.host, call_565213.base,
                         call_565213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565213, url, valid)

proc call*(call_565214: Call_SqlResourcesCreateUpdateSqlTrigger_565202;
          apiVersion: string; createUpdateSqlTriggerParameters: JsonNode;
          subscriptionId: string; databaseName: string; resourceGroupName: string;
          containerName: string; triggerName: string; accountName: string): Recallable =
  ## sqlResourcesCreateUpdateSqlTrigger
  ## Create or update an Azure Cosmos DB SQL trigger
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   createUpdateSqlTriggerParameters: JObject (required)
  ##                                   : The parameters to provide for the current SQL trigger.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   triggerName: string (required)
  ##              : Cosmos DB trigger name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565215 = newJObject()
  var query_565216 = newJObject()
  var body_565217 = newJObject()
  add(query_565216, "api-version", newJString(apiVersion))
  if createUpdateSqlTriggerParameters != nil:
    body_565217 = createUpdateSqlTriggerParameters
  add(path_565215, "subscriptionId", newJString(subscriptionId))
  add(path_565215, "databaseName", newJString(databaseName))
  add(path_565215, "resourceGroupName", newJString(resourceGroupName))
  add(path_565215, "containerName", newJString(containerName))
  add(path_565215, "triggerName", newJString(triggerName))
  add(path_565215, "accountName", newJString(accountName))
  result = call_565214.call(path_565215, query_565216, nil, nil, body_565217)

var sqlResourcesCreateUpdateSqlTrigger* = Call_SqlResourcesCreateUpdateSqlTrigger_565202(
    name: "sqlResourcesCreateUpdateSqlTrigger", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}/triggers/{triggerName}",
    validator: validate_SqlResourcesCreateUpdateSqlTrigger_565203, base: "",
    url: url_SqlResourcesCreateUpdateSqlTrigger_565204, schemes: {Scheme.Https})
type
  Call_SqlResourcesGetSqlTrigger_565188 = ref object of OpenApiRestCall_563566
proc url_SqlResourcesGetSqlTrigger_565190(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/sqlDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlResourcesGetSqlTrigger_565189(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the SQL trigger under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   triggerName: JString (required)
  ##              : Cosmos DB trigger name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565191 = path.getOrDefault("subscriptionId")
  valid_565191 = validateParameter(valid_565191, JString, required = true,
                                 default = nil)
  if valid_565191 != nil:
    section.add "subscriptionId", valid_565191
  var valid_565192 = path.getOrDefault("databaseName")
  valid_565192 = validateParameter(valid_565192, JString, required = true,
                                 default = nil)
  if valid_565192 != nil:
    section.add "databaseName", valid_565192
  var valid_565193 = path.getOrDefault("resourceGroupName")
  valid_565193 = validateParameter(valid_565193, JString, required = true,
                                 default = nil)
  if valid_565193 != nil:
    section.add "resourceGroupName", valid_565193
  var valid_565194 = path.getOrDefault("containerName")
  valid_565194 = validateParameter(valid_565194, JString, required = true,
                                 default = nil)
  if valid_565194 != nil:
    section.add "containerName", valid_565194
  var valid_565195 = path.getOrDefault("triggerName")
  valid_565195 = validateParameter(valid_565195, JString, required = true,
                                 default = nil)
  if valid_565195 != nil:
    section.add "triggerName", valid_565195
  var valid_565196 = path.getOrDefault("accountName")
  valid_565196 = validateParameter(valid_565196, JString, required = true,
                                 default = nil)
  if valid_565196 != nil:
    section.add "accountName", valid_565196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565197 = query.getOrDefault("api-version")
  valid_565197 = validateParameter(valid_565197, JString, required = true,
                                 default = nil)
  if valid_565197 != nil:
    section.add "api-version", valid_565197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565198: Call_SqlResourcesGetSqlTrigger_565188; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the SQL trigger under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_565198.validator(path, query, header, formData, body)
  let scheme = call_565198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565198.url(scheme.get, call_565198.host, call_565198.base,
                         call_565198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565198, url, valid)

proc call*(call_565199: Call_SqlResourcesGetSqlTrigger_565188; apiVersion: string;
          subscriptionId: string; databaseName: string; resourceGroupName: string;
          containerName: string; triggerName: string; accountName: string): Recallable =
  ## sqlResourcesGetSqlTrigger
  ## Gets the SQL trigger under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   triggerName: string (required)
  ##              : Cosmos DB trigger name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565200 = newJObject()
  var query_565201 = newJObject()
  add(query_565201, "api-version", newJString(apiVersion))
  add(path_565200, "subscriptionId", newJString(subscriptionId))
  add(path_565200, "databaseName", newJString(databaseName))
  add(path_565200, "resourceGroupName", newJString(resourceGroupName))
  add(path_565200, "containerName", newJString(containerName))
  add(path_565200, "triggerName", newJString(triggerName))
  add(path_565200, "accountName", newJString(accountName))
  result = call_565199.call(path_565200, query_565201, nil, nil, nil)

var sqlResourcesGetSqlTrigger* = Call_SqlResourcesGetSqlTrigger_565188(
    name: "sqlResourcesGetSqlTrigger", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}/triggers/{triggerName}",
    validator: validate_SqlResourcesGetSqlTrigger_565189, base: "",
    url: url_SqlResourcesGetSqlTrigger_565190, schemes: {Scheme.Https})
type
  Call_SqlResourcesDeleteSqlTrigger_565218 = ref object of OpenApiRestCall_563566
proc url_SqlResourcesDeleteSqlTrigger_565220(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/sqlDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlResourcesDeleteSqlTrigger_565219(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Azure Cosmos DB SQL trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   triggerName: JString (required)
  ##              : Cosmos DB trigger name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565221 = path.getOrDefault("subscriptionId")
  valid_565221 = validateParameter(valid_565221, JString, required = true,
                                 default = nil)
  if valid_565221 != nil:
    section.add "subscriptionId", valid_565221
  var valid_565222 = path.getOrDefault("databaseName")
  valid_565222 = validateParameter(valid_565222, JString, required = true,
                                 default = nil)
  if valid_565222 != nil:
    section.add "databaseName", valid_565222
  var valid_565223 = path.getOrDefault("resourceGroupName")
  valid_565223 = validateParameter(valid_565223, JString, required = true,
                                 default = nil)
  if valid_565223 != nil:
    section.add "resourceGroupName", valid_565223
  var valid_565224 = path.getOrDefault("containerName")
  valid_565224 = validateParameter(valid_565224, JString, required = true,
                                 default = nil)
  if valid_565224 != nil:
    section.add "containerName", valid_565224
  var valid_565225 = path.getOrDefault("triggerName")
  valid_565225 = validateParameter(valid_565225, JString, required = true,
                                 default = nil)
  if valid_565225 != nil:
    section.add "triggerName", valid_565225
  var valid_565226 = path.getOrDefault("accountName")
  valid_565226 = validateParameter(valid_565226, JString, required = true,
                                 default = nil)
  if valid_565226 != nil:
    section.add "accountName", valid_565226
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565227 = query.getOrDefault("api-version")
  valid_565227 = validateParameter(valid_565227, JString, required = true,
                                 default = nil)
  if valid_565227 != nil:
    section.add "api-version", valid_565227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565228: Call_SqlResourcesDeleteSqlTrigger_565218; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB SQL trigger.
  ## 
  let valid = call_565228.validator(path, query, header, formData, body)
  let scheme = call_565228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565228.url(scheme.get, call_565228.host, call_565228.base,
                         call_565228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565228, url, valid)

proc call*(call_565229: Call_SqlResourcesDeleteSqlTrigger_565218;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; containerName: string; triggerName: string;
          accountName: string): Recallable =
  ## sqlResourcesDeleteSqlTrigger
  ## Deletes an existing Azure Cosmos DB SQL trigger.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   triggerName: string (required)
  ##              : Cosmos DB trigger name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565230 = newJObject()
  var query_565231 = newJObject()
  add(query_565231, "api-version", newJString(apiVersion))
  add(path_565230, "subscriptionId", newJString(subscriptionId))
  add(path_565230, "databaseName", newJString(databaseName))
  add(path_565230, "resourceGroupName", newJString(resourceGroupName))
  add(path_565230, "containerName", newJString(containerName))
  add(path_565230, "triggerName", newJString(triggerName))
  add(path_565230, "accountName", newJString(accountName))
  result = call_565229.call(path_565230, query_565231, nil, nil, nil)

var sqlResourcesDeleteSqlTrigger* = Call_SqlResourcesDeleteSqlTrigger_565218(
    name: "sqlResourcesDeleteSqlTrigger", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}/triggers/{triggerName}",
    validator: validate_SqlResourcesDeleteSqlTrigger_565219, base: "",
    url: url_SqlResourcesDeleteSqlTrigger_565220, schemes: {Scheme.Https})
type
  Call_SqlResourcesListSqlUserDefinedFunctions_565232 = ref object of OpenApiRestCall_563566
proc url_SqlResourcesListSqlUserDefinedFunctions_565234(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/sqlDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/userDefinedFunctions/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlResourcesListSqlUserDefinedFunctions_565233(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the SQL userDefinedFunction under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565235 = path.getOrDefault("subscriptionId")
  valid_565235 = validateParameter(valid_565235, JString, required = true,
                                 default = nil)
  if valid_565235 != nil:
    section.add "subscriptionId", valid_565235
  var valid_565236 = path.getOrDefault("databaseName")
  valid_565236 = validateParameter(valid_565236, JString, required = true,
                                 default = nil)
  if valid_565236 != nil:
    section.add "databaseName", valid_565236
  var valid_565237 = path.getOrDefault("resourceGroupName")
  valid_565237 = validateParameter(valid_565237, JString, required = true,
                                 default = nil)
  if valid_565237 != nil:
    section.add "resourceGroupName", valid_565237
  var valid_565238 = path.getOrDefault("containerName")
  valid_565238 = validateParameter(valid_565238, JString, required = true,
                                 default = nil)
  if valid_565238 != nil:
    section.add "containerName", valid_565238
  var valid_565239 = path.getOrDefault("accountName")
  valid_565239 = validateParameter(valid_565239, JString, required = true,
                                 default = nil)
  if valid_565239 != nil:
    section.add "accountName", valid_565239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565240 = query.getOrDefault("api-version")
  valid_565240 = validateParameter(valid_565240, JString, required = true,
                                 default = nil)
  if valid_565240 != nil:
    section.add "api-version", valid_565240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565241: Call_SqlResourcesListSqlUserDefinedFunctions_565232;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the SQL userDefinedFunction under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_565241.validator(path, query, header, formData, body)
  let scheme = call_565241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565241.url(scheme.get, call_565241.host, call_565241.base,
                         call_565241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565241, url, valid)

proc call*(call_565242: Call_SqlResourcesListSqlUserDefinedFunctions_565232;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; containerName: string; accountName: string): Recallable =
  ## sqlResourcesListSqlUserDefinedFunctions
  ## Lists the SQL userDefinedFunction under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565243 = newJObject()
  var query_565244 = newJObject()
  add(query_565244, "api-version", newJString(apiVersion))
  add(path_565243, "subscriptionId", newJString(subscriptionId))
  add(path_565243, "databaseName", newJString(databaseName))
  add(path_565243, "resourceGroupName", newJString(resourceGroupName))
  add(path_565243, "containerName", newJString(containerName))
  add(path_565243, "accountName", newJString(accountName))
  result = call_565242.call(path_565243, query_565244, nil, nil, nil)

var sqlResourcesListSqlUserDefinedFunctions* = Call_SqlResourcesListSqlUserDefinedFunctions_565232(
    name: "sqlResourcesListSqlUserDefinedFunctions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}/userDefinedFunctions/",
    validator: validate_SqlResourcesListSqlUserDefinedFunctions_565233, base: "",
    url: url_SqlResourcesListSqlUserDefinedFunctions_565234,
    schemes: {Scheme.Https})
type
  Call_SqlResourcesCreateUpdateSqlUserDefinedFunction_565259 = ref object of OpenApiRestCall_563566
proc url_SqlResourcesCreateUpdateSqlUserDefinedFunction_565261(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "userDefinedFunctionName" in path,
        "`userDefinedFunctionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/sqlDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/userDefinedFunctions/"),
               (kind: VariableSegment, value: "userDefinedFunctionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlResourcesCreateUpdateSqlUserDefinedFunction_565260(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Create or update an Azure Cosmos DB SQL userDefinedFunction
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   userDefinedFunctionName: JString (required)
  ##                          : Cosmos DB userDefinedFunction name.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565262 = path.getOrDefault("subscriptionId")
  valid_565262 = validateParameter(valid_565262, JString, required = true,
                                 default = nil)
  if valid_565262 != nil:
    section.add "subscriptionId", valid_565262
  var valid_565263 = path.getOrDefault("userDefinedFunctionName")
  valid_565263 = validateParameter(valid_565263, JString, required = true,
                                 default = nil)
  if valid_565263 != nil:
    section.add "userDefinedFunctionName", valid_565263
  var valid_565264 = path.getOrDefault("databaseName")
  valid_565264 = validateParameter(valid_565264, JString, required = true,
                                 default = nil)
  if valid_565264 != nil:
    section.add "databaseName", valid_565264
  var valid_565265 = path.getOrDefault("resourceGroupName")
  valid_565265 = validateParameter(valid_565265, JString, required = true,
                                 default = nil)
  if valid_565265 != nil:
    section.add "resourceGroupName", valid_565265
  var valid_565266 = path.getOrDefault("containerName")
  valid_565266 = validateParameter(valid_565266, JString, required = true,
                                 default = nil)
  if valid_565266 != nil:
    section.add "containerName", valid_565266
  var valid_565267 = path.getOrDefault("accountName")
  valid_565267 = validateParameter(valid_565267, JString, required = true,
                                 default = nil)
  if valid_565267 != nil:
    section.add "accountName", valid_565267
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565268 = query.getOrDefault("api-version")
  valid_565268 = validateParameter(valid_565268, JString, required = true,
                                 default = nil)
  if valid_565268 != nil:
    section.add "api-version", valid_565268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   createUpdateSqlUserDefinedFunctionParameters: JObject (required)
  ##                                               : The parameters to provide for the current SQL userDefinedFunction.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565270: Call_SqlResourcesCreateUpdateSqlUserDefinedFunction_565259;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB SQL userDefinedFunction
  ## 
  let valid = call_565270.validator(path, query, header, formData, body)
  let scheme = call_565270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565270.url(scheme.get, call_565270.host, call_565270.base,
                         call_565270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565270, url, valid)

proc call*(call_565271: Call_SqlResourcesCreateUpdateSqlUserDefinedFunction_565259;
          apiVersion: string; subscriptionId: string;
          userDefinedFunctionName: string; databaseName: string;
          createUpdateSqlUserDefinedFunctionParameters: JsonNode;
          resourceGroupName: string; containerName: string; accountName: string): Recallable =
  ## sqlResourcesCreateUpdateSqlUserDefinedFunction
  ## Create or update an Azure Cosmos DB SQL userDefinedFunction
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   userDefinedFunctionName: string (required)
  ##                          : Cosmos DB userDefinedFunction name.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   createUpdateSqlUserDefinedFunctionParameters: JObject (required)
  ##                                               : The parameters to provide for the current SQL userDefinedFunction.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565272 = newJObject()
  var query_565273 = newJObject()
  var body_565274 = newJObject()
  add(query_565273, "api-version", newJString(apiVersion))
  add(path_565272, "subscriptionId", newJString(subscriptionId))
  add(path_565272, "userDefinedFunctionName", newJString(userDefinedFunctionName))
  add(path_565272, "databaseName", newJString(databaseName))
  if createUpdateSqlUserDefinedFunctionParameters != nil:
    body_565274 = createUpdateSqlUserDefinedFunctionParameters
  add(path_565272, "resourceGroupName", newJString(resourceGroupName))
  add(path_565272, "containerName", newJString(containerName))
  add(path_565272, "accountName", newJString(accountName))
  result = call_565271.call(path_565272, query_565273, nil, nil, body_565274)

var sqlResourcesCreateUpdateSqlUserDefinedFunction* = Call_SqlResourcesCreateUpdateSqlUserDefinedFunction_565259(
    name: "sqlResourcesCreateUpdateSqlUserDefinedFunction",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}/userDefinedFunctions/{userDefinedFunctionName}",
    validator: validate_SqlResourcesCreateUpdateSqlUserDefinedFunction_565260,
    base: "", url: url_SqlResourcesCreateUpdateSqlUserDefinedFunction_565261,
    schemes: {Scheme.Https})
type
  Call_SqlResourcesGetSqlUserDefinedFunction_565245 = ref object of OpenApiRestCall_563566
proc url_SqlResourcesGetSqlUserDefinedFunction_565247(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "userDefinedFunctionName" in path,
        "`userDefinedFunctionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/sqlDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/userDefinedFunctions/"),
               (kind: VariableSegment, value: "userDefinedFunctionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlResourcesGetSqlUserDefinedFunction_565246(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the SQL userDefinedFunction under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   userDefinedFunctionName: JString (required)
  ##                          : Cosmos DB userDefinedFunction name.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565248 = path.getOrDefault("subscriptionId")
  valid_565248 = validateParameter(valid_565248, JString, required = true,
                                 default = nil)
  if valid_565248 != nil:
    section.add "subscriptionId", valid_565248
  var valid_565249 = path.getOrDefault("userDefinedFunctionName")
  valid_565249 = validateParameter(valid_565249, JString, required = true,
                                 default = nil)
  if valid_565249 != nil:
    section.add "userDefinedFunctionName", valid_565249
  var valid_565250 = path.getOrDefault("databaseName")
  valid_565250 = validateParameter(valid_565250, JString, required = true,
                                 default = nil)
  if valid_565250 != nil:
    section.add "databaseName", valid_565250
  var valid_565251 = path.getOrDefault("resourceGroupName")
  valid_565251 = validateParameter(valid_565251, JString, required = true,
                                 default = nil)
  if valid_565251 != nil:
    section.add "resourceGroupName", valid_565251
  var valid_565252 = path.getOrDefault("containerName")
  valid_565252 = validateParameter(valid_565252, JString, required = true,
                                 default = nil)
  if valid_565252 != nil:
    section.add "containerName", valid_565252
  var valid_565253 = path.getOrDefault("accountName")
  valid_565253 = validateParameter(valid_565253, JString, required = true,
                                 default = nil)
  if valid_565253 != nil:
    section.add "accountName", valid_565253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565254 = query.getOrDefault("api-version")
  valid_565254 = validateParameter(valid_565254, JString, required = true,
                                 default = nil)
  if valid_565254 != nil:
    section.add "api-version", valid_565254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565255: Call_SqlResourcesGetSqlUserDefinedFunction_565245;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the SQL userDefinedFunction under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_565255.validator(path, query, header, formData, body)
  let scheme = call_565255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565255.url(scheme.get, call_565255.host, call_565255.base,
                         call_565255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565255, url, valid)

proc call*(call_565256: Call_SqlResourcesGetSqlUserDefinedFunction_565245;
          apiVersion: string; subscriptionId: string;
          userDefinedFunctionName: string; databaseName: string;
          resourceGroupName: string; containerName: string; accountName: string): Recallable =
  ## sqlResourcesGetSqlUserDefinedFunction
  ## Gets the SQL userDefinedFunction under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   userDefinedFunctionName: string (required)
  ##                          : Cosmos DB userDefinedFunction name.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565257 = newJObject()
  var query_565258 = newJObject()
  add(query_565258, "api-version", newJString(apiVersion))
  add(path_565257, "subscriptionId", newJString(subscriptionId))
  add(path_565257, "userDefinedFunctionName", newJString(userDefinedFunctionName))
  add(path_565257, "databaseName", newJString(databaseName))
  add(path_565257, "resourceGroupName", newJString(resourceGroupName))
  add(path_565257, "containerName", newJString(containerName))
  add(path_565257, "accountName", newJString(accountName))
  result = call_565256.call(path_565257, query_565258, nil, nil, nil)

var sqlResourcesGetSqlUserDefinedFunction* = Call_SqlResourcesGetSqlUserDefinedFunction_565245(
    name: "sqlResourcesGetSqlUserDefinedFunction", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}/userDefinedFunctions/{userDefinedFunctionName}",
    validator: validate_SqlResourcesGetSqlUserDefinedFunction_565246, base: "",
    url: url_SqlResourcesGetSqlUserDefinedFunction_565247, schemes: {Scheme.Https})
type
  Call_SqlResourcesDeleteSqlUserDefinedFunction_565275 = ref object of OpenApiRestCall_563566
proc url_SqlResourcesDeleteSqlUserDefinedFunction_565277(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "userDefinedFunctionName" in path,
        "`userDefinedFunctionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/sqlDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/userDefinedFunctions/"),
               (kind: VariableSegment, value: "userDefinedFunctionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlResourcesDeleteSqlUserDefinedFunction_565276(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Azure Cosmos DB SQL userDefinedFunction.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   userDefinedFunctionName: JString (required)
  ##                          : Cosmos DB userDefinedFunction name.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565278 = path.getOrDefault("subscriptionId")
  valid_565278 = validateParameter(valid_565278, JString, required = true,
                                 default = nil)
  if valid_565278 != nil:
    section.add "subscriptionId", valid_565278
  var valid_565279 = path.getOrDefault("userDefinedFunctionName")
  valid_565279 = validateParameter(valid_565279, JString, required = true,
                                 default = nil)
  if valid_565279 != nil:
    section.add "userDefinedFunctionName", valid_565279
  var valid_565280 = path.getOrDefault("databaseName")
  valid_565280 = validateParameter(valid_565280, JString, required = true,
                                 default = nil)
  if valid_565280 != nil:
    section.add "databaseName", valid_565280
  var valid_565281 = path.getOrDefault("resourceGroupName")
  valid_565281 = validateParameter(valid_565281, JString, required = true,
                                 default = nil)
  if valid_565281 != nil:
    section.add "resourceGroupName", valid_565281
  var valid_565282 = path.getOrDefault("containerName")
  valid_565282 = validateParameter(valid_565282, JString, required = true,
                                 default = nil)
  if valid_565282 != nil:
    section.add "containerName", valid_565282
  var valid_565283 = path.getOrDefault("accountName")
  valid_565283 = validateParameter(valid_565283, JString, required = true,
                                 default = nil)
  if valid_565283 != nil:
    section.add "accountName", valid_565283
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565284 = query.getOrDefault("api-version")
  valid_565284 = validateParameter(valid_565284, JString, required = true,
                                 default = nil)
  if valid_565284 != nil:
    section.add "api-version", valid_565284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565285: Call_SqlResourcesDeleteSqlUserDefinedFunction_565275;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB SQL userDefinedFunction.
  ## 
  let valid = call_565285.validator(path, query, header, formData, body)
  let scheme = call_565285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565285.url(scheme.get, call_565285.host, call_565285.base,
                         call_565285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565285, url, valid)

proc call*(call_565286: Call_SqlResourcesDeleteSqlUserDefinedFunction_565275;
          apiVersion: string; subscriptionId: string;
          userDefinedFunctionName: string; databaseName: string;
          resourceGroupName: string; containerName: string; accountName: string): Recallable =
  ## sqlResourcesDeleteSqlUserDefinedFunction
  ## Deletes an existing Azure Cosmos DB SQL userDefinedFunction.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   userDefinedFunctionName: string (required)
  ##                          : Cosmos DB userDefinedFunction name.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565287 = newJObject()
  var query_565288 = newJObject()
  add(query_565288, "api-version", newJString(apiVersion))
  add(path_565287, "subscriptionId", newJString(subscriptionId))
  add(path_565287, "userDefinedFunctionName", newJString(userDefinedFunctionName))
  add(path_565287, "databaseName", newJString(databaseName))
  add(path_565287, "resourceGroupName", newJString(resourceGroupName))
  add(path_565287, "containerName", newJString(containerName))
  add(path_565287, "accountName", newJString(accountName))
  result = call_565286.call(path_565287, query_565288, nil, nil, nil)

var sqlResourcesDeleteSqlUserDefinedFunction* = Call_SqlResourcesDeleteSqlUserDefinedFunction_565275(
    name: "sqlResourcesDeleteSqlUserDefinedFunction", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}/userDefinedFunctions/{userDefinedFunctionName}",
    validator: validate_SqlResourcesDeleteSqlUserDefinedFunction_565276, base: "",
    url: url_SqlResourcesDeleteSqlUserDefinedFunction_565277,
    schemes: {Scheme.Https})
type
  Call_SqlResourcesUpdateSqlDatabaseThroughput_565301 = ref object of OpenApiRestCall_563566
proc url_SqlResourcesUpdateSqlDatabaseThroughput_565303(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/sqlDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/throughputSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlResourcesUpdateSqlDatabaseThroughput_565302(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update RUs per second of an Azure Cosmos DB SQL database
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565304 = path.getOrDefault("subscriptionId")
  valid_565304 = validateParameter(valid_565304, JString, required = true,
                                 default = nil)
  if valid_565304 != nil:
    section.add "subscriptionId", valid_565304
  var valid_565305 = path.getOrDefault("databaseName")
  valid_565305 = validateParameter(valid_565305, JString, required = true,
                                 default = nil)
  if valid_565305 != nil:
    section.add "databaseName", valid_565305
  var valid_565306 = path.getOrDefault("resourceGroupName")
  valid_565306 = validateParameter(valid_565306, JString, required = true,
                                 default = nil)
  if valid_565306 != nil:
    section.add "resourceGroupName", valid_565306
  var valid_565307 = path.getOrDefault("accountName")
  valid_565307 = validateParameter(valid_565307, JString, required = true,
                                 default = nil)
  if valid_565307 != nil:
    section.add "accountName", valid_565307
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565308 = query.getOrDefault("api-version")
  valid_565308 = validateParameter(valid_565308, JString, required = true,
                                 default = nil)
  if valid_565308 != nil:
    section.add "api-version", valid_565308
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   updateThroughputParameters: JObject (required)
  ##                             : The parameters to provide for the RUs per second of the current SQL database.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565310: Call_SqlResourcesUpdateSqlDatabaseThroughput_565301;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB SQL database
  ## 
  let valid = call_565310.validator(path, query, header, formData, body)
  let scheme = call_565310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565310.url(scheme.get, call_565310.host, call_565310.base,
                         call_565310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565310, url, valid)

proc call*(call_565311: Call_SqlResourcesUpdateSqlDatabaseThroughput_565301;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; accountName: string;
          updateThroughputParameters: JsonNode): Recallable =
  ## sqlResourcesUpdateSqlDatabaseThroughput
  ## Update RUs per second of an Azure Cosmos DB SQL database
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   updateThroughputParameters: JObject (required)
  ##                             : The parameters to provide for the RUs per second of the current SQL database.
  var path_565312 = newJObject()
  var query_565313 = newJObject()
  var body_565314 = newJObject()
  add(query_565313, "api-version", newJString(apiVersion))
  add(path_565312, "subscriptionId", newJString(subscriptionId))
  add(path_565312, "databaseName", newJString(databaseName))
  add(path_565312, "resourceGroupName", newJString(resourceGroupName))
  add(path_565312, "accountName", newJString(accountName))
  if updateThroughputParameters != nil:
    body_565314 = updateThroughputParameters
  result = call_565311.call(path_565312, query_565313, nil, nil, body_565314)

var sqlResourcesUpdateSqlDatabaseThroughput* = Call_SqlResourcesUpdateSqlDatabaseThroughput_565301(
    name: "sqlResourcesUpdateSqlDatabaseThroughput", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/throughputSettings/default",
    validator: validate_SqlResourcesUpdateSqlDatabaseThroughput_565302, base: "",
    url: url_SqlResourcesUpdateSqlDatabaseThroughput_565303,
    schemes: {Scheme.Https})
type
  Call_SqlResourcesGetSqlDatabaseThroughput_565289 = ref object of OpenApiRestCall_563566
proc url_SqlResourcesGetSqlDatabaseThroughput_565291(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/sqlDatabases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/throughputSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlResourcesGetSqlDatabaseThroughput_565290(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the RUs per second of the SQL database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565292 = path.getOrDefault("subscriptionId")
  valid_565292 = validateParameter(valid_565292, JString, required = true,
                                 default = nil)
  if valid_565292 != nil:
    section.add "subscriptionId", valid_565292
  var valid_565293 = path.getOrDefault("databaseName")
  valid_565293 = validateParameter(valid_565293, JString, required = true,
                                 default = nil)
  if valid_565293 != nil:
    section.add "databaseName", valid_565293
  var valid_565294 = path.getOrDefault("resourceGroupName")
  valid_565294 = validateParameter(valid_565294, JString, required = true,
                                 default = nil)
  if valid_565294 != nil:
    section.add "resourceGroupName", valid_565294
  var valid_565295 = path.getOrDefault("accountName")
  valid_565295 = validateParameter(valid_565295, JString, required = true,
                                 default = nil)
  if valid_565295 != nil:
    section.add "accountName", valid_565295
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565296 = query.getOrDefault("api-version")
  valid_565296 = validateParameter(valid_565296, JString, required = true,
                                 default = nil)
  if valid_565296 != nil:
    section.add "api-version", valid_565296
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565297: Call_SqlResourcesGetSqlDatabaseThroughput_565289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the SQL database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_565297.validator(path, query, header, formData, body)
  let scheme = call_565297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565297.url(scheme.get, call_565297.host, call_565297.base,
                         call_565297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565297, url, valid)

proc call*(call_565298: Call_SqlResourcesGetSqlDatabaseThroughput_565289;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## sqlResourcesGetSqlDatabaseThroughput
  ## Gets the RUs per second of the SQL database under an existing Azure Cosmos DB database account with the provided name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565299 = newJObject()
  var query_565300 = newJObject()
  add(query_565300, "api-version", newJString(apiVersion))
  add(path_565299, "subscriptionId", newJString(subscriptionId))
  add(path_565299, "databaseName", newJString(databaseName))
  add(path_565299, "resourceGroupName", newJString(resourceGroupName))
  add(path_565299, "accountName", newJString(accountName))
  result = call_565298.call(path_565299, query_565300, nil, nil, nil)

var sqlResourcesGetSqlDatabaseThroughput* = Call_SqlResourcesGetSqlDatabaseThroughput_565289(
    name: "sqlResourcesGetSqlDatabaseThroughput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/throughputSettings/default",
    validator: validate_SqlResourcesGetSqlDatabaseThroughput_565290, base: "",
    url: url_SqlResourcesGetSqlDatabaseThroughput_565291, schemes: {Scheme.Https})
type
  Call_TableResourcesListTables_565315 = ref object of OpenApiRestCall_563566
proc url_TableResourcesListTables_565317(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/tables")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TableResourcesListTables_565316(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Tables under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565318 = path.getOrDefault("subscriptionId")
  valid_565318 = validateParameter(valid_565318, JString, required = true,
                                 default = nil)
  if valid_565318 != nil:
    section.add "subscriptionId", valid_565318
  var valid_565319 = path.getOrDefault("resourceGroupName")
  valid_565319 = validateParameter(valid_565319, JString, required = true,
                                 default = nil)
  if valid_565319 != nil:
    section.add "resourceGroupName", valid_565319
  var valid_565320 = path.getOrDefault("accountName")
  valid_565320 = validateParameter(valid_565320, JString, required = true,
                                 default = nil)
  if valid_565320 != nil:
    section.add "accountName", valid_565320
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565321 = query.getOrDefault("api-version")
  valid_565321 = validateParameter(valid_565321, JString, required = true,
                                 default = nil)
  if valid_565321 != nil:
    section.add "api-version", valid_565321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565322: Call_TableResourcesListTables_565315; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Tables under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_565322.validator(path, query, header, formData, body)
  let scheme = call_565322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565322.url(scheme.get, call_565322.host, call_565322.base,
                         call_565322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565322, url, valid)

proc call*(call_565323: Call_TableResourcesListTables_565315; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string): Recallable =
  ## tableResourcesListTables
  ## Lists the Tables under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565324 = newJObject()
  var query_565325 = newJObject()
  add(query_565325, "api-version", newJString(apiVersion))
  add(path_565324, "subscriptionId", newJString(subscriptionId))
  add(path_565324, "resourceGroupName", newJString(resourceGroupName))
  add(path_565324, "accountName", newJString(accountName))
  result = call_565323.call(path_565324, query_565325, nil, nil, nil)

var tableResourcesListTables* = Call_TableResourcesListTables_565315(
    name: "tableResourcesListTables", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/tables",
    validator: validate_TableResourcesListTables_565316, base: "",
    url: url_TableResourcesListTables_565317, schemes: {Scheme.Https})
type
  Call_TableResourcesCreateUpdateTable_565338 = ref object of OpenApiRestCall_563566
proc url_TableResourcesCreateUpdateTable_565340(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "tableName" in path, "`tableName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TableResourcesCreateUpdateTable_565339(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an Azure Cosmos DB Table
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   tableName: JString (required)
  ##            : Cosmos DB table name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565341 = path.getOrDefault("subscriptionId")
  valid_565341 = validateParameter(valid_565341, JString, required = true,
                                 default = nil)
  if valid_565341 != nil:
    section.add "subscriptionId", valid_565341
  var valid_565342 = path.getOrDefault("resourceGroupName")
  valid_565342 = validateParameter(valid_565342, JString, required = true,
                                 default = nil)
  if valid_565342 != nil:
    section.add "resourceGroupName", valid_565342
  var valid_565343 = path.getOrDefault("tableName")
  valid_565343 = validateParameter(valid_565343, JString, required = true,
                                 default = nil)
  if valid_565343 != nil:
    section.add "tableName", valid_565343
  var valid_565344 = path.getOrDefault("accountName")
  valid_565344 = validateParameter(valid_565344, JString, required = true,
                                 default = nil)
  if valid_565344 != nil:
    section.add "accountName", valid_565344
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565345 = query.getOrDefault("api-version")
  valid_565345 = validateParameter(valid_565345, JString, required = true,
                                 default = nil)
  if valid_565345 != nil:
    section.add "api-version", valid_565345
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   createUpdateTableParameters: JObject (required)
  ##                              : The parameters to provide for the current Table.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565347: Call_TableResourcesCreateUpdateTable_565338;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB Table
  ## 
  let valid = call_565347.validator(path, query, header, formData, body)
  let scheme = call_565347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565347.url(scheme.get, call_565347.host, call_565347.base,
                         call_565347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565347, url, valid)

proc call*(call_565348: Call_TableResourcesCreateUpdateTable_565338;
          apiVersion: string; subscriptionId: string;
          createUpdateTableParameters: JsonNode; resourceGroupName: string;
          tableName: string; accountName: string): Recallable =
  ## tableResourcesCreateUpdateTable
  ## Create or update an Azure Cosmos DB Table
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   createUpdateTableParameters: JObject (required)
  ##                              : The parameters to provide for the current Table.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565349 = newJObject()
  var query_565350 = newJObject()
  var body_565351 = newJObject()
  add(query_565350, "api-version", newJString(apiVersion))
  add(path_565349, "subscriptionId", newJString(subscriptionId))
  if createUpdateTableParameters != nil:
    body_565351 = createUpdateTableParameters
  add(path_565349, "resourceGroupName", newJString(resourceGroupName))
  add(path_565349, "tableName", newJString(tableName))
  add(path_565349, "accountName", newJString(accountName))
  result = call_565348.call(path_565349, query_565350, nil, nil, body_565351)

var tableResourcesCreateUpdateTable* = Call_TableResourcesCreateUpdateTable_565338(
    name: "tableResourcesCreateUpdateTable", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/tables/{tableName}",
    validator: validate_TableResourcesCreateUpdateTable_565339, base: "",
    url: url_TableResourcesCreateUpdateTable_565340, schemes: {Scheme.Https})
type
  Call_TableResourcesGetTable_565326 = ref object of OpenApiRestCall_563566
proc url_TableResourcesGetTable_565328(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "tableName" in path, "`tableName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TableResourcesGetTable_565327(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Tables under an existing Azure Cosmos DB database account with the provided name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   tableName: JString (required)
  ##            : Cosmos DB table name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565329 = path.getOrDefault("subscriptionId")
  valid_565329 = validateParameter(valid_565329, JString, required = true,
                                 default = nil)
  if valid_565329 != nil:
    section.add "subscriptionId", valid_565329
  var valid_565330 = path.getOrDefault("resourceGroupName")
  valid_565330 = validateParameter(valid_565330, JString, required = true,
                                 default = nil)
  if valid_565330 != nil:
    section.add "resourceGroupName", valid_565330
  var valid_565331 = path.getOrDefault("tableName")
  valid_565331 = validateParameter(valid_565331, JString, required = true,
                                 default = nil)
  if valid_565331 != nil:
    section.add "tableName", valid_565331
  var valid_565332 = path.getOrDefault("accountName")
  valid_565332 = validateParameter(valid_565332, JString, required = true,
                                 default = nil)
  if valid_565332 != nil:
    section.add "accountName", valid_565332
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565333 = query.getOrDefault("api-version")
  valid_565333 = validateParameter(valid_565333, JString, required = true,
                                 default = nil)
  if valid_565333 != nil:
    section.add "api-version", valid_565333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565334: Call_TableResourcesGetTable_565326; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Tables under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_565334.validator(path, query, header, formData, body)
  let scheme = call_565334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565334.url(scheme.get, call_565334.host, call_565334.base,
                         call_565334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565334, url, valid)

proc call*(call_565335: Call_TableResourcesGetTable_565326; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; tableName: string;
          accountName: string): Recallable =
  ## tableResourcesGetTable
  ## Gets the Tables under an existing Azure Cosmos DB database account with the provided name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565336 = newJObject()
  var query_565337 = newJObject()
  add(query_565337, "api-version", newJString(apiVersion))
  add(path_565336, "subscriptionId", newJString(subscriptionId))
  add(path_565336, "resourceGroupName", newJString(resourceGroupName))
  add(path_565336, "tableName", newJString(tableName))
  add(path_565336, "accountName", newJString(accountName))
  result = call_565335.call(path_565336, query_565337, nil, nil, nil)

var tableResourcesGetTable* = Call_TableResourcesGetTable_565326(
    name: "tableResourcesGetTable", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/tables/{tableName}",
    validator: validate_TableResourcesGetTable_565327, base: "",
    url: url_TableResourcesGetTable_565328, schemes: {Scheme.Https})
type
  Call_TableResourcesDeleteTable_565352 = ref object of OpenApiRestCall_563566
proc url_TableResourcesDeleteTable_565354(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "tableName" in path, "`tableName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TableResourcesDeleteTable_565353(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Azure Cosmos DB Table.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   tableName: JString (required)
  ##            : Cosmos DB table name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565355 = path.getOrDefault("subscriptionId")
  valid_565355 = validateParameter(valid_565355, JString, required = true,
                                 default = nil)
  if valid_565355 != nil:
    section.add "subscriptionId", valid_565355
  var valid_565356 = path.getOrDefault("resourceGroupName")
  valid_565356 = validateParameter(valid_565356, JString, required = true,
                                 default = nil)
  if valid_565356 != nil:
    section.add "resourceGroupName", valid_565356
  var valid_565357 = path.getOrDefault("tableName")
  valid_565357 = validateParameter(valid_565357, JString, required = true,
                                 default = nil)
  if valid_565357 != nil:
    section.add "tableName", valid_565357
  var valid_565358 = path.getOrDefault("accountName")
  valid_565358 = validateParameter(valid_565358, JString, required = true,
                                 default = nil)
  if valid_565358 != nil:
    section.add "accountName", valid_565358
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565359 = query.getOrDefault("api-version")
  valid_565359 = validateParameter(valid_565359, JString, required = true,
                                 default = nil)
  if valid_565359 != nil:
    section.add "api-version", valid_565359
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565360: Call_TableResourcesDeleteTable_565352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB Table.
  ## 
  let valid = call_565360.validator(path, query, header, formData, body)
  let scheme = call_565360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565360.url(scheme.get, call_565360.host, call_565360.base,
                         call_565360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565360, url, valid)

proc call*(call_565361: Call_TableResourcesDeleteTable_565352; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; tableName: string;
          accountName: string): Recallable =
  ## tableResourcesDeleteTable
  ## Deletes an existing Azure Cosmos DB Table.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565362 = newJObject()
  var query_565363 = newJObject()
  add(query_565363, "api-version", newJString(apiVersion))
  add(path_565362, "subscriptionId", newJString(subscriptionId))
  add(path_565362, "resourceGroupName", newJString(resourceGroupName))
  add(path_565362, "tableName", newJString(tableName))
  add(path_565362, "accountName", newJString(accountName))
  result = call_565361.call(path_565362, query_565363, nil, nil, nil)

var tableResourcesDeleteTable* = Call_TableResourcesDeleteTable_565352(
    name: "tableResourcesDeleteTable", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/tables/{tableName}",
    validator: validate_TableResourcesDeleteTable_565353, base: "",
    url: url_TableResourcesDeleteTable_565354, schemes: {Scheme.Https})
type
  Call_TableResourcesUpdateTableThroughput_565376 = ref object of OpenApiRestCall_563566
proc url_TableResourcesUpdateTableThroughput_565378(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "tableName" in path, "`tableName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableName"),
               (kind: ConstantSegment, value: "/throughputSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TableResourcesUpdateTableThroughput_565377(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update RUs per second of an Azure Cosmos DB Table
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   tableName: JString (required)
  ##            : Cosmos DB table name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565379 = path.getOrDefault("subscriptionId")
  valid_565379 = validateParameter(valid_565379, JString, required = true,
                                 default = nil)
  if valid_565379 != nil:
    section.add "subscriptionId", valid_565379
  var valid_565380 = path.getOrDefault("resourceGroupName")
  valid_565380 = validateParameter(valid_565380, JString, required = true,
                                 default = nil)
  if valid_565380 != nil:
    section.add "resourceGroupName", valid_565380
  var valid_565381 = path.getOrDefault("tableName")
  valid_565381 = validateParameter(valid_565381, JString, required = true,
                                 default = nil)
  if valid_565381 != nil:
    section.add "tableName", valid_565381
  var valid_565382 = path.getOrDefault("accountName")
  valid_565382 = validateParameter(valid_565382, JString, required = true,
                                 default = nil)
  if valid_565382 != nil:
    section.add "accountName", valid_565382
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565383 = query.getOrDefault("api-version")
  valid_565383 = validateParameter(valid_565383, JString, required = true,
                                 default = nil)
  if valid_565383 != nil:
    section.add "api-version", valid_565383
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   updateThroughputParameters: JObject (required)
  ##                             : The parameters to provide for the RUs per second of the current Table.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565385: Call_TableResourcesUpdateTableThroughput_565376;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Table
  ## 
  let valid = call_565385.validator(path, query, header, formData, body)
  let scheme = call_565385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565385.url(scheme.get, call_565385.host, call_565385.base,
                         call_565385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565385, url, valid)

proc call*(call_565386: Call_TableResourcesUpdateTableThroughput_565376;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          tableName: string; accountName: string;
          updateThroughputParameters: JsonNode): Recallable =
  ## tableResourcesUpdateTableThroughput
  ## Update RUs per second of an Azure Cosmos DB Table
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   updateThroughputParameters: JObject (required)
  ##                             : The parameters to provide for the RUs per second of the current Table.
  var path_565387 = newJObject()
  var query_565388 = newJObject()
  var body_565389 = newJObject()
  add(query_565388, "api-version", newJString(apiVersion))
  add(path_565387, "subscriptionId", newJString(subscriptionId))
  add(path_565387, "resourceGroupName", newJString(resourceGroupName))
  add(path_565387, "tableName", newJString(tableName))
  add(path_565387, "accountName", newJString(accountName))
  if updateThroughputParameters != nil:
    body_565389 = updateThroughputParameters
  result = call_565386.call(path_565387, query_565388, nil, nil, body_565389)

var tableResourcesUpdateTableThroughput* = Call_TableResourcesUpdateTableThroughput_565376(
    name: "tableResourcesUpdateTableThroughput", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/tables/{tableName}/throughputSettings/default",
    validator: validate_TableResourcesUpdateTableThroughput_565377, base: "",
    url: url_TableResourcesUpdateTableThroughput_565378, schemes: {Scheme.Https})
type
  Call_TableResourcesGetTableThroughput_565364 = ref object of OpenApiRestCall_563566
proc url_TableResourcesGetTableThroughput_565366(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "tableName" in path, "`tableName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableName"),
               (kind: ConstantSegment, value: "/throughputSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TableResourcesGetTableThroughput_565365(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the RUs per second of the Table under an existing Azure Cosmos DB database account with the provided name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   tableName: JString (required)
  ##            : Cosmos DB table name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565367 = path.getOrDefault("subscriptionId")
  valid_565367 = validateParameter(valid_565367, JString, required = true,
                                 default = nil)
  if valid_565367 != nil:
    section.add "subscriptionId", valid_565367
  var valid_565368 = path.getOrDefault("resourceGroupName")
  valid_565368 = validateParameter(valid_565368, JString, required = true,
                                 default = nil)
  if valid_565368 != nil:
    section.add "resourceGroupName", valid_565368
  var valid_565369 = path.getOrDefault("tableName")
  valid_565369 = validateParameter(valid_565369, JString, required = true,
                                 default = nil)
  if valid_565369 != nil:
    section.add "tableName", valid_565369
  var valid_565370 = path.getOrDefault("accountName")
  valid_565370 = validateParameter(valid_565370, JString, required = true,
                                 default = nil)
  if valid_565370 != nil:
    section.add "accountName", valid_565370
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565371 = query.getOrDefault("api-version")
  valid_565371 = validateParameter(valid_565371, JString, required = true,
                                 default = nil)
  if valid_565371 != nil:
    section.add "api-version", valid_565371
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565372: Call_TableResourcesGetTableThroughput_565364;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the Table under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_565372.validator(path, query, header, formData, body)
  let scheme = call_565372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565372.url(scheme.get, call_565372.host, call_565372.base,
                         call_565372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565372, url, valid)

proc call*(call_565373: Call_TableResourcesGetTableThroughput_565364;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          tableName: string; accountName: string): Recallable =
  ## tableResourcesGetTableThroughput
  ## Gets the RUs per second of the Table under an existing Azure Cosmos DB database account with the provided name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565374 = newJObject()
  var query_565375 = newJObject()
  add(query_565375, "api-version", newJString(apiVersion))
  add(path_565374, "subscriptionId", newJString(subscriptionId))
  add(path_565374, "resourceGroupName", newJString(resourceGroupName))
  add(path_565374, "tableName", newJString(tableName))
  add(path_565374, "accountName", newJString(accountName))
  result = call_565373.call(path_565374, query_565375, nil, nil, nil)

var tableResourcesGetTableThroughput* = Call_TableResourcesGetTableThroughput_565364(
    name: "tableResourcesGetTableThroughput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/tables/{tableName}/throughputSettings/default",
    validator: validate_TableResourcesGetTableThroughput_565365, base: "",
    url: url_TableResourcesGetTableThroughput_565366, schemes: {Scheme.Https})
type
  Call_PercentileTargetListMetrics_565390 = ref object of OpenApiRestCall_563566
proc url_PercentileTargetListMetrics_565392(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "targetRegion" in path, "`targetRegion` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/targetRegion/"),
               (kind: VariableSegment, value: "targetRegion"),
               (kind: ConstantSegment, value: "/percentile/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PercentileTargetListMetrics_565391(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the metrics determined by the given filter for the given account target region. This url is only for PBS and Replication Latency data
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   targetRegion: JString (required)
  ##               : Target region to which data is written. Cosmos DB region, with spaces between words and each word capitalized.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565393 = path.getOrDefault("subscriptionId")
  valid_565393 = validateParameter(valid_565393, JString, required = true,
                                 default = nil)
  if valid_565393 != nil:
    section.add "subscriptionId", valid_565393
  var valid_565394 = path.getOrDefault("resourceGroupName")
  valid_565394 = validateParameter(valid_565394, JString, required = true,
                                 default = nil)
  if valid_565394 != nil:
    section.add "resourceGroupName", valid_565394
  var valid_565395 = path.getOrDefault("targetRegion")
  valid_565395 = validateParameter(valid_565395, JString, required = true,
                                 default = nil)
  if valid_565395 != nil:
    section.add "targetRegion", valid_565395
  var valid_565396 = path.getOrDefault("accountName")
  valid_565396 = validateParameter(valid_565396, JString, required = true,
                                 default = nil)
  if valid_565396 != nil:
    section.add "accountName", valid_565396
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565397 = query.getOrDefault("api-version")
  valid_565397 = validateParameter(valid_565397, JString, required = true,
                                 default = nil)
  if valid_565397 != nil:
    section.add "api-version", valid_565397
  var valid_565398 = query.getOrDefault("$filter")
  valid_565398 = validateParameter(valid_565398, JString, required = true,
                                 default = nil)
  if valid_565398 != nil:
    section.add "$filter", valid_565398
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565399: Call_PercentileTargetListMetrics_565390; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given account target region. This url is only for PBS and Replication Latency data
  ## 
  let valid = call_565399.validator(path, query, header, formData, body)
  let scheme = call_565399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565399.url(scheme.get, call_565399.host, call_565399.base,
                         call_565399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565399, url, valid)

proc call*(call_565400: Call_PercentileTargetListMetrics_565390;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          Filter: string; targetRegion: string; accountName: string): Recallable =
  ## percentileTargetListMetrics
  ## Retrieves the metrics determined by the given filter for the given account target region. This url is only for PBS and Replication Latency data
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  ##   targetRegion: string (required)
  ##               : Target region to which data is written. Cosmos DB region, with spaces between words and each word capitalized.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565401 = newJObject()
  var query_565402 = newJObject()
  add(query_565402, "api-version", newJString(apiVersion))
  add(path_565401, "subscriptionId", newJString(subscriptionId))
  add(path_565401, "resourceGroupName", newJString(resourceGroupName))
  add(query_565402, "$filter", newJString(Filter))
  add(path_565401, "targetRegion", newJString(targetRegion))
  add(path_565401, "accountName", newJString(accountName))
  result = call_565400.call(path_565401, query_565402, nil, nil, nil)

var percentileTargetListMetrics* = Call_PercentileTargetListMetrics_565390(
    name: "percentileTargetListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/targetRegion/{targetRegion}/percentile/metrics",
    validator: validate_PercentileTargetListMetrics_565391, base: "",
    url: url_PercentileTargetListMetrics_565392, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListUsages_565403 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsListUsages_565405(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsListUsages_565404(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the usages (most recent data) for the given database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565406 = path.getOrDefault("subscriptionId")
  valid_565406 = validateParameter(valid_565406, JString, required = true,
                                 default = nil)
  if valid_565406 != nil:
    section.add "subscriptionId", valid_565406
  var valid_565407 = path.getOrDefault("resourceGroupName")
  valid_565407 = validateParameter(valid_565407, JString, required = true,
                                 default = nil)
  if valid_565407 != nil:
    section.add "resourceGroupName", valid_565407
  var valid_565408 = path.getOrDefault("accountName")
  valid_565408 = validateParameter(valid_565408, JString, required = true,
                                 default = nil)
  if valid_565408 != nil:
    section.add "accountName", valid_565408
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString
  ##          : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565409 = query.getOrDefault("api-version")
  valid_565409 = validateParameter(valid_565409, JString, required = true,
                                 default = nil)
  if valid_565409 != nil:
    section.add "api-version", valid_565409
  var valid_565410 = query.getOrDefault("$filter")
  valid_565410 = validateParameter(valid_565410, JString, required = false,
                                 default = nil)
  if valid_565410 != nil:
    section.add "$filter", valid_565410
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565411: Call_DatabaseAccountsListUsages_565403; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the usages (most recent data) for the given database account.
  ## 
  let valid = call_565411.validator(path, query, header, formData, body)
  let scheme = call_565411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565411.url(scheme.get, call_565411.host, call_565411.base,
                         call_565411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565411, url, valid)

proc call*(call_565412: Call_DatabaseAccountsListUsages_565403; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string;
          Filter: string = ""): Recallable =
  ## databaseAccountsListUsages
  ## Retrieves the usages (most recent data) for the given database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   Filter: string
  ##         : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565413 = newJObject()
  var query_565414 = newJObject()
  add(query_565414, "api-version", newJString(apiVersion))
  add(path_565413, "subscriptionId", newJString(subscriptionId))
  add(path_565413, "resourceGroupName", newJString(resourceGroupName))
  add(query_565414, "$filter", newJString(Filter))
  add(path_565413, "accountName", newJString(accountName))
  result = call_565412.call(path_565413, query_565414, nil, nil, nil)

var databaseAccountsListUsages* = Call_DatabaseAccountsListUsages_565403(
    name: "databaseAccountsListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/usages",
    validator: validate_DatabaseAccountsListUsages_565404, base: "",
    url: url_DatabaseAccountsListUsages_565405, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
