
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Cosmos DB
## version: 2015-04-08
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  Call_DatabaseAccountsListCassandraKeyspaces_564176 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsListCassandraKeyspaces_564178(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/cassandra/keyspaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsListCassandraKeyspaces_564177(path: JsonNode;
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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

proc call*(call_564183: Call_DatabaseAccountsListCassandraKeyspaces_564176;
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

proc call*(call_564184: Call_DatabaseAccountsListCassandraKeyspaces_564176;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## databaseAccountsListCassandraKeyspaces
  ## Lists the Cassandra keyspaces under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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

var databaseAccountsListCassandraKeyspaces* = Call_DatabaseAccountsListCassandraKeyspaces_564176(
    name: "databaseAccountsListCassandraKeyspaces", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces",
    validator: validate_DatabaseAccountsListCassandraKeyspaces_564177, base: "",
    url: url_DatabaseAccountsListCassandraKeyspaces_564178,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateCassandraKeyspace_564199 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsCreateUpdateCassandraKeyspace_564201(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/cassandra/keyspaces/"),
               (kind: VariableSegment, value: "keyspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsCreateUpdateCassandraKeyspace_564200(
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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

proc call*(call_564208: Call_DatabaseAccountsCreateUpdateCassandraKeyspace_564199;
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

proc call*(call_564209: Call_DatabaseAccountsCreateUpdateCassandraKeyspace_564199;
          apiVersion: string; createUpdateCassandraKeyspaceParameters: JsonNode;
          subscriptionId: string; resourceGroupName: string; keyspaceName: string;
          accountName: string): Recallable =
  ## databaseAccountsCreateUpdateCassandraKeyspace
  ## Create or update an Azure Cosmos DB Cassandra keyspace
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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

var databaseAccountsCreateUpdateCassandraKeyspace* = Call_DatabaseAccountsCreateUpdateCassandraKeyspace_564199(
    name: "databaseAccountsCreateUpdateCassandraKeyspace",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}",
    validator: validate_DatabaseAccountsCreateUpdateCassandraKeyspace_564200,
    base: "", url: url_DatabaseAccountsCreateUpdateCassandraKeyspace_564201,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetCassandraKeyspace_564187 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsGetCassandraKeyspace_564189(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/cassandra/keyspaces/"),
               (kind: VariableSegment, value: "keyspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsGetCassandraKeyspace_564188(path: JsonNode;
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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

proc call*(call_564195: Call_DatabaseAccountsGetCassandraKeyspace_564187;
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

proc call*(call_564196: Call_DatabaseAccountsGetCassandraKeyspace_564187;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          keyspaceName: string; accountName: string): Recallable =
  ## databaseAccountsGetCassandraKeyspace
  ## Gets the Cassandra keyspaces under an existing Azure Cosmos DB database account with the provided name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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

var databaseAccountsGetCassandraKeyspace* = Call_DatabaseAccountsGetCassandraKeyspace_564187(
    name: "databaseAccountsGetCassandraKeyspace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}",
    validator: validate_DatabaseAccountsGetCassandraKeyspace_564188, base: "",
    url: url_DatabaseAccountsGetCassandraKeyspace_564189, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteCassandraKeyspace_564213 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsDeleteCassandraKeyspace_564215(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/cassandra/keyspaces/"),
               (kind: VariableSegment, value: "keyspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsDeleteCassandraKeyspace_564214(path: JsonNode;
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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

proc call*(call_564221: Call_DatabaseAccountsDeleteCassandraKeyspace_564213;
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

proc call*(call_564222: Call_DatabaseAccountsDeleteCassandraKeyspace_564213;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          keyspaceName: string; accountName: string): Recallable =
  ## databaseAccountsDeleteCassandraKeyspace
  ## Deletes an existing Azure Cosmos DB Cassandra keyspace.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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

var databaseAccountsDeleteCassandraKeyspace* = Call_DatabaseAccountsDeleteCassandraKeyspace_564213(
    name: "databaseAccountsDeleteCassandraKeyspace", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}",
    validator: validate_DatabaseAccountsDeleteCassandraKeyspace_564214, base: "",
    url: url_DatabaseAccountsDeleteCassandraKeyspace_564215,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateCassandraKeyspaceThroughput_564237 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsUpdateCassandraKeyspaceThroughput_564239(
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
               (kind: ConstantSegment, value: "/apis/cassandra/keyspaces/"),
               (kind: VariableSegment, value: "keyspaceName"),
               (kind: ConstantSegment, value: "/settings/throughput")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsUpdateCassandraKeyspaceThroughput_564238(
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
  var valid_564242 = path.getOrDefault("keyspaceName")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "keyspaceName", valid_564242
  var valid_564243 = path.getOrDefault("accountName")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "accountName", valid_564243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564244 = query.getOrDefault("api-version")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "api-version", valid_564244
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

proc call*(call_564246: Call_DatabaseAccountsUpdateCassandraKeyspaceThroughput_564237;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Cassandra Keyspace
  ## 
  let valid = call_564246.validator(path, query, header, formData, body)
  let scheme = call_564246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564246.url(scheme.get, call_564246.host, call_564246.base,
                         call_564246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564246, url, valid)

proc call*(call_564247: Call_DatabaseAccountsUpdateCassandraKeyspaceThroughput_564237;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          keyspaceName: string; accountName: string;
          updateThroughputParameters: JsonNode): Recallable =
  ## databaseAccountsUpdateCassandraKeyspaceThroughput
  ## Update RUs per second of an Azure Cosmos DB Cassandra Keyspace
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564248 = newJObject()
  var query_564249 = newJObject()
  var body_564250 = newJObject()
  add(query_564249, "api-version", newJString(apiVersion))
  add(path_564248, "subscriptionId", newJString(subscriptionId))
  add(path_564248, "resourceGroupName", newJString(resourceGroupName))
  add(path_564248, "keyspaceName", newJString(keyspaceName))
  add(path_564248, "accountName", newJString(accountName))
  if updateThroughputParameters != nil:
    body_564250 = updateThroughputParameters
  result = call_564247.call(path_564248, query_564249, nil, nil, body_564250)

var databaseAccountsUpdateCassandraKeyspaceThroughput* = Call_DatabaseAccountsUpdateCassandraKeyspaceThroughput_564237(
    name: "databaseAccountsUpdateCassandraKeyspaceThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateCassandraKeyspaceThroughput_564238,
    base: "", url: url_DatabaseAccountsUpdateCassandraKeyspaceThroughput_564239,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetCassandraKeyspaceThroughput_564225 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsGetCassandraKeyspaceThroughput_564227(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/cassandra/keyspaces/"),
               (kind: VariableSegment, value: "keyspaceName"),
               (kind: ConstantSegment, value: "/settings/throughput")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsGetCassandraKeyspaceThroughput_564226(
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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

proc call*(call_564233: Call_DatabaseAccountsGetCassandraKeyspaceThroughput_564225;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the Cassandra Keyspace under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_564233.validator(path, query, header, formData, body)
  let scheme = call_564233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564233.url(scheme.get, call_564233.host, call_564233.base,
                         call_564233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564233, url, valid)

proc call*(call_564234: Call_DatabaseAccountsGetCassandraKeyspaceThroughput_564225;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          keyspaceName: string; accountName: string): Recallable =
  ## databaseAccountsGetCassandraKeyspaceThroughput
  ## Gets the RUs per second of the Cassandra Keyspace under an existing Azure Cosmos DB database account with the provided name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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

var databaseAccountsGetCassandraKeyspaceThroughput* = Call_DatabaseAccountsGetCassandraKeyspaceThroughput_564225(
    name: "databaseAccountsGetCassandraKeyspaceThroughput",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/settings/throughput",
    validator: validate_DatabaseAccountsGetCassandraKeyspaceThroughput_564226,
    base: "", url: url_DatabaseAccountsGetCassandraKeyspaceThroughput_564227,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListCassandraTables_564251 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsListCassandraTables_564253(protocol: Scheme; host: string;
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
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/apis/cassandra/keyspaces/"),
               (kind: VariableSegment, value: "keyspaceName"),
               (kind: ConstantSegment, value: "/tables")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsListCassandraTables_564252(path: JsonNode;
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
  var valid_564254 = path.getOrDefault("subscriptionId")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "subscriptionId", valid_564254
  var valid_564255 = path.getOrDefault("resourceGroupName")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "resourceGroupName", valid_564255
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  if body != nil:
    result.add "body", body

proc call*(call_564259: Call_DatabaseAccountsListCassandraTables_564251;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Cassandra table under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_564259.validator(path, query, header, formData, body)
  let scheme = call_564259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564259.url(scheme.get, call_564259.host, call_564259.base,
                         call_564259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564259, url, valid)

proc call*(call_564260: Call_DatabaseAccountsListCassandraTables_564251;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          keyspaceName: string; accountName: string): Recallable =
  ## databaseAccountsListCassandraTables
  ## Lists the Cassandra table under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   keyspaceName: string (required)
  ##               : Cosmos DB keyspace name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564261 = newJObject()
  var query_564262 = newJObject()
  add(query_564262, "api-version", newJString(apiVersion))
  add(path_564261, "subscriptionId", newJString(subscriptionId))
  add(path_564261, "resourceGroupName", newJString(resourceGroupName))
  add(path_564261, "keyspaceName", newJString(keyspaceName))
  add(path_564261, "accountName", newJString(accountName))
  result = call_564260.call(path_564261, query_564262, nil, nil, nil)

var databaseAccountsListCassandraTables* = Call_DatabaseAccountsListCassandraTables_564251(
    name: "databaseAccountsListCassandraTables", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/tables",
    validator: validate_DatabaseAccountsListCassandraTables_564252, base: "",
    url: url_DatabaseAccountsListCassandraTables_564253, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateCassandraTable_564276 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsCreateUpdateCassandraTable_564278(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/cassandra/keyspaces/"),
               (kind: VariableSegment, value: "keyspaceName"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsCreateUpdateCassandraTable_564277(path: JsonNode;
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
  var valid_564279 = path.getOrDefault("subscriptionId")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = nil)
  if valid_564279 != nil:
    section.add "subscriptionId", valid_564279
  var valid_564280 = path.getOrDefault("resourceGroupName")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "resourceGroupName", valid_564280
  var valid_564281 = path.getOrDefault("tableName")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "tableName", valid_564281
  var valid_564282 = path.getOrDefault("keyspaceName")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "keyspaceName", valid_564282
  var valid_564283 = path.getOrDefault("accountName")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "accountName", valid_564283
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564284 = query.getOrDefault("api-version")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "api-version", valid_564284
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

proc call*(call_564286: Call_DatabaseAccountsCreateUpdateCassandraTable_564276;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB Cassandra Table
  ## 
  let valid = call_564286.validator(path, query, header, formData, body)
  let scheme = call_564286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564286.url(scheme.get, call_564286.host, call_564286.base,
                         call_564286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564286, url, valid)

proc call*(call_564287: Call_DatabaseAccountsCreateUpdateCassandraTable_564276;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          createUpdateCassandraTableParameters: JsonNode; tableName: string;
          keyspaceName: string; accountName: string): Recallable =
  ## databaseAccountsCreateUpdateCassandraTable
  ## Create or update an Azure Cosmos DB Cassandra Table
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564288 = newJObject()
  var query_564289 = newJObject()
  var body_564290 = newJObject()
  add(query_564289, "api-version", newJString(apiVersion))
  add(path_564288, "subscriptionId", newJString(subscriptionId))
  add(path_564288, "resourceGroupName", newJString(resourceGroupName))
  if createUpdateCassandraTableParameters != nil:
    body_564290 = createUpdateCassandraTableParameters
  add(path_564288, "tableName", newJString(tableName))
  add(path_564288, "keyspaceName", newJString(keyspaceName))
  add(path_564288, "accountName", newJString(accountName))
  result = call_564287.call(path_564288, query_564289, nil, nil, body_564290)

var databaseAccountsCreateUpdateCassandraTable* = Call_DatabaseAccountsCreateUpdateCassandraTable_564276(
    name: "databaseAccountsCreateUpdateCassandraTable", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/tables/{tableName}",
    validator: validate_DatabaseAccountsCreateUpdateCassandraTable_564277,
    base: "", url: url_DatabaseAccountsCreateUpdateCassandraTable_564278,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetCassandraTable_564263 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsGetCassandraTable_564265(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/apis/cassandra/keyspaces/"),
               (kind: VariableSegment, value: "keyspaceName"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsGetCassandraTable_564264(path: JsonNode;
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
  var valid_564266 = path.getOrDefault("subscriptionId")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "subscriptionId", valid_564266
  var valid_564267 = path.getOrDefault("resourceGroupName")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "resourceGroupName", valid_564267
  var valid_564268 = path.getOrDefault("tableName")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = nil)
  if valid_564268 != nil:
    section.add "tableName", valid_564268
  var valid_564269 = path.getOrDefault("keyspaceName")
  valid_564269 = validateParameter(valid_564269, JString, required = true,
                                 default = nil)
  if valid_564269 != nil:
    section.add "keyspaceName", valid_564269
  var valid_564270 = path.getOrDefault("accountName")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "accountName", valid_564270
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564271 = query.getOrDefault("api-version")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "api-version", valid_564271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564272: Call_DatabaseAccountsGetCassandraTable_564263;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the Cassandra table under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_564272.validator(path, query, header, formData, body)
  let scheme = call_564272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564272.url(scheme.get, call_564272.host, call_564272.base,
                         call_564272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564272, url, valid)

proc call*(call_564273: Call_DatabaseAccountsGetCassandraTable_564263;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          tableName: string; keyspaceName: string; accountName: string): Recallable =
  ## databaseAccountsGetCassandraTable
  ## Gets the Cassandra table under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564274 = newJObject()
  var query_564275 = newJObject()
  add(query_564275, "api-version", newJString(apiVersion))
  add(path_564274, "subscriptionId", newJString(subscriptionId))
  add(path_564274, "resourceGroupName", newJString(resourceGroupName))
  add(path_564274, "tableName", newJString(tableName))
  add(path_564274, "keyspaceName", newJString(keyspaceName))
  add(path_564274, "accountName", newJString(accountName))
  result = call_564273.call(path_564274, query_564275, nil, nil, nil)

var databaseAccountsGetCassandraTable* = Call_DatabaseAccountsGetCassandraTable_564263(
    name: "databaseAccountsGetCassandraTable", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/tables/{tableName}",
    validator: validate_DatabaseAccountsGetCassandraTable_564264, base: "",
    url: url_DatabaseAccountsGetCassandraTable_564265, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteCassandraTable_564291 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsDeleteCassandraTable_564293(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/cassandra/keyspaces/"),
               (kind: VariableSegment, value: "keyspaceName"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsDeleteCassandraTable_564292(path: JsonNode;
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  if body != nil:
    result.add "body", body

proc call*(call_564300: Call_DatabaseAccountsDeleteCassandraTable_564291;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB Cassandra table.
  ## 
  let valid = call_564300.validator(path, query, header, formData, body)
  let scheme = call_564300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564300.url(scheme.get, call_564300.host, call_564300.base,
                         call_564300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564300, url, valid)

proc call*(call_564301: Call_DatabaseAccountsDeleteCassandraTable_564291;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          tableName: string; keyspaceName: string; accountName: string): Recallable =
  ## databaseAccountsDeleteCassandraTable
  ## Deletes an existing Azure Cosmos DB Cassandra table.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564302 = newJObject()
  var query_564303 = newJObject()
  add(query_564303, "api-version", newJString(apiVersion))
  add(path_564302, "subscriptionId", newJString(subscriptionId))
  add(path_564302, "resourceGroupName", newJString(resourceGroupName))
  add(path_564302, "tableName", newJString(tableName))
  add(path_564302, "keyspaceName", newJString(keyspaceName))
  add(path_564302, "accountName", newJString(accountName))
  result = call_564301.call(path_564302, query_564303, nil, nil, nil)

var databaseAccountsDeleteCassandraTable* = Call_DatabaseAccountsDeleteCassandraTable_564291(
    name: "databaseAccountsDeleteCassandraTable", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/tables/{tableName}",
    validator: validate_DatabaseAccountsDeleteCassandraTable_564292, base: "",
    url: url_DatabaseAccountsDeleteCassandraTable_564293, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateCassandraTableThroughput_564317 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsUpdateCassandraTableThroughput_564319(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/cassandra/keyspaces/"),
               (kind: VariableSegment, value: "keyspaceName"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableName"),
               (kind: ConstantSegment, value: "/settings/throughput")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsUpdateCassandraTableThroughput_564318(
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
  var valid_564320 = path.getOrDefault("subscriptionId")
  valid_564320 = validateParameter(valid_564320, JString, required = true,
                                 default = nil)
  if valid_564320 != nil:
    section.add "subscriptionId", valid_564320
  var valid_564321 = path.getOrDefault("resourceGroupName")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "resourceGroupName", valid_564321
  var valid_564322 = path.getOrDefault("tableName")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "tableName", valid_564322
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##                             : The RUs per second of the parameters to provide for the current Cassandra table.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564327: Call_DatabaseAccountsUpdateCassandraTableThroughput_564317;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Cassandra table
  ## 
  let valid = call_564327.validator(path, query, header, formData, body)
  let scheme = call_564327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564327.url(scheme.get, call_564327.host, call_564327.base,
                         call_564327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564327, url, valid)

proc call*(call_564328: Call_DatabaseAccountsUpdateCassandraTableThroughput_564317;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          tableName: string; keyspaceName: string; accountName: string;
          updateThroughputParameters: JsonNode): Recallable =
  ## databaseAccountsUpdateCassandraTableThroughput
  ## Update RUs per second of an Azure Cosmos DB Cassandra table
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564329 = newJObject()
  var query_564330 = newJObject()
  var body_564331 = newJObject()
  add(query_564330, "api-version", newJString(apiVersion))
  add(path_564329, "subscriptionId", newJString(subscriptionId))
  add(path_564329, "resourceGroupName", newJString(resourceGroupName))
  add(path_564329, "tableName", newJString(tableName))
  add(path_564329, "keyspaceName", newJString(keyspaceName))
  add(path_564329, "accountName", newJString(accountName))
  if updateThroughputParameters != nil:
    body_564331 = updateThroughputParameters
  result = call_564328.call(path_564329, query_564330, nil, nil, body_564331)

var databaseAccountsUpdateCassandraTableThroughput* = Call_DatabaseAccountsUpdateCassandraTableThroughput_564317(
    name: "databaseAccountsUpdateCassandraTableThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/tables/{tableName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateCassandraTableThroughput_564318,
    base: "", url: url_DatabaseAccountsUpdateCassandraTableThroughput_564319,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetCassandraTableThroughput_564304 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsGetCassandraTableThroughput_564306(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/cassandra/keyspaces/"),
               (kind: VariableSegment, value: "keyspaceName"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableName"),
               (kind: ConstantSegment, value: "/settings/throughput")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsGetCassandraTableThroughput_564305(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_564307 = path.getOrDefault("subscriptionId")
  valid_564307 = validateParameter(valid_564307, JString, required = true,
                                 default = nil)
  if valid_564307 != nil:
    section.add "subscriptionId", valid_564307
  var valid_564308 = path.getOrDefault("resourceGroupName")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "resourceGroupName", valid_564308
  var valid_564309 = path.getOrDefault("tableName")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "tableName", valid_564309
  var valid_564310 = path.getOrDefault("keyspaceName")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "keyspaceName", valid_564310
  var valid_564311 = path.getOrDefault("accountName")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "accountName", valid_564311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564312 = query.getOrDefault("api-version")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "api-version", valid_564312
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564313: Call_DatabaseAccountsGetCassandraTableThroughput_564304;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the Cassandra table under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_564313.validator(path, query, header, formData, body)
  let scheme = call_564313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564313.url(scheme.get, call_564313.host, call_564313.base,
                         call_564313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564313, url, valid)

proc call*(call_564314: Call_DatabaseAccountsGetCassandraTableThroughput_564304;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          tableName: string; keyspaceName: string; accountName: string): Recallable =
  ## databaseAccountsGetCassandraTableThroughput
  ## Gets the RUs per second of the Cassandra table under an existing Azure Cosmos DB database account with the provided name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564315 = newJObject()
  var query_564316 = newJObject()
  add(query_564316, "api-version", newJString(apiVersion))
  add(path_564315, "subscriptionId", newJString(subscriptionId))
  add(path_564315, "resourceGroupName", newJString(resourceGroupName))
  add(path_564315, "tableName", newJString(tableName))
  add(path_564315, "keyspaceName", newJString(keyspaceName))
  add(path_564315, "accountName", newJString(accountName))
  result = call_564314.call(path_564315, query_564316, nil, nil, nil)

var databaseAccountsGetCassandraTableThroughput* = Call_DatabaseAccountsGetCassandraTableThroughput_564304(
    name: "databaseAccountsGetCassandraTableThroughput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/tables/{tableName}/settings/throughput",
    validator: validate_DatabaseAccountsGetCassandraTableThroughput_564305,
    base: "", url: url_DatabaseAccountsGetCassandraTableThroughput_564306,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListGremlinDatabases_564332 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsListGremlinDatabases_564334(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/gremlin/databases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsListGremlinDatabases_564333(path: JsonNode;
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
  var valid_564335 = path.getOrDefault("subscriptionId")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "subscriptionId", valid_564335
  var valid_564336 = path.getOrDefault("resourceGroupName")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "resourceGroupName", valid_564336
  var valid_564337 = path.getOrDefault("accountName")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "accountName", valid_564337
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564338 = query.getOrDefault("api-version")
  valid_564338 = validateParameter(valid_564338, JString, required = true,
                                 default = nil)
  if valid_564338 != nil:
    section.add "api-version", valid_564338
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564339: Call_DatabaseAccountsListGremlinDatabases_564332;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Gremlin databases under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_564339.validator(path, query, header, formData, body)
  let scheme = call_564339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564339.url(scheme.get, call_564339.host, call_564339.base,
                         call_564339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564339, url, valid)

proc call*(call_564340: Call_DatabaseAccountsListGremlinDatabases_564332;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## databaseAccountsListGremlinDatabases
  ## Lists the Gremlin databases under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564341 = newJObject()
  var query_564342 = newJObject()
  add(query_564342, "api-version", newJString(apiVersion))
  add(path_564341, "subscriptionId", newJString(subscriptionId))
  add(path_564341, "resourceGroupName", newJString(resourceGroupName))
  add(path_564341, "accountName", newJString(accountName))
  result = call_564340.call(path_564341, query_564342, nil, nil, nil)

var databaseAccountsListGremlinDatabases* = Call_DatabaseAccountsListGremlinDatabases_564332(
    name: "databaseAccountsListGremlinDatabases", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases",
    validator: validate_DatabaseAccountsListGremlinDatabases_564333, base: "",
    url: url_DatabaseAccountsListGremlinDatabases_564334, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateGremlinDatabase_564355 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsCreateUpdateGremlinDatabase_564357(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/gremlin/databases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsCreateUpdateGremlinDatabase_564356(path: JsonNode;
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
  var valid_564358 = path.getOrDefault("subscriptionId")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "subscriptionId", valid_564358
  var valid_564359 = path.getOrDefault("databaseName")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "databaseName", valid_564359
  var valid_564360 = path.getOrDefault("resourceGroupName")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "resourceGroupName", valid_564360
  var valid_564361 = path.getOrDefault("accountName")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "accountName", valid_564361
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564362 = query.getOrDefault("api-version")
  valid_564362 = validateParameter(valid_564362, JString, required = true,
                                 default = nil)
  if valid_564362 != nil:
    section.add "api-version", valid_564362
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

proc call*(call_564364: Call_DatabaseAccountsCreateUpdateGremlinDatabase_564355;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB Gremlin database
  ## 
  let valid = call_564364.validator(path, query, header, formData, body)
  let scheme = call_564364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564364.url(scheme.get, call_564364.host, call_564364.base,
                         call_564364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564364, url, valid)

proc call*(call_564365: Call_DatabaseAccountsCreateUpdateGremlinDatabase_564355;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string;
          createUpdateGremlinDatabaseParameters: JsonNode; accountName: string): Recallable =
  ## databaseAccountsCreateUpdateGremlinDatabase
  ## Create or update an Azure Cosmos DB Gremlin database
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564366 = newJObject()
  var query_564367 = newJObject()
  var body_564368 = newJObject()
  add(query_564367, "api-version", newJString(apiVersion))
  add(path_564366, "subscriptionId", newJString(subscriptionId))
  add(path_564366, "databaseName", newJString(databaseName))
  add(path_564366, "resourceGroupName", newJString(resourceGroupName))
  if createUpdateGremlinDatabaseParameters != nil:
    body_564368 = createUpdateGremlinDatabaseParameters
  add(path_564366, "accountName", newJString(accountName))
  result = call_564365.call(path_564366, query_564367, nil, nil, body_564368)

var databaseAccountsCreateUpdateGremlinDatabase* = Call_DatabaseAccountsCreateUpdateGremlinDatabase_564355(
    name: "databaseAccountsCreateUpdateGremlinDatabase", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}",
    validator: validate_DatabaseAccountsCreateUpdateGremlinDatabase_564356,
    base: "", url: url_DatabaseAccountsCreateUpdateGremlinDatabase_564357,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetGremlinDatabase_564343 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsGetGremlinDatabase_564345(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/apis/gremlin/databases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsGetGremlinDatabase_564344(path: JsonNode;
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
  var valid_564346 = path.getOrDefault("subscriptionId")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "subscriptionId", valid_564346
  var valid_564347 = path.getOrDefault("databaseName")
  valid_564347 = validateParameter(valid_564347, JString, required = true,
                                 default = nil)
  if valid_564347 != nil:
    section.add "databaseName", valid_564347
  var valid_564348 = path.getOrDefault("resourceGroupName")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "resourceGroupName", valid_564348
  var valid_564349 = path.getOrDefault("accountName")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "accountName", valid_564349
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564350 = query.getOrDefault("api-version")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "api-version", valid_564350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564351: Call_DatabaseAccountsGetGremlinDatabase_564343;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the Gremlin databases under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_564351.validator(path, query, header, formData, body)
  let scheme = call_564351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564351.url(scheme.get, call_564351.host, call_564351.base,
                         call_564351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564351, url, valid)

proc call*(call_564352: Call_DatabaseAccountsGetGremlinDatabase_564343;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsGetGremlinDatabase
  ## Gets the Gremlin databases under an existing Azure Cosmos DB database account with the provided name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564353 = newJObject()
  var query_564354 = newJObject()
  add(query_564354, "api-version", newJString(apiVersion))
  add(path_564353, "subscriptionId", newJString(subscriptionId))
  add(path_564353, "databaseName", newJString(databaseName))
  add(path_564353, "resourceGroupName", newJString(resourceGroupName))
  add(path_564353, "accountName", newJString(accountName))
  result = call_564352.call(path_564353, query_564354, nil, nil, nil)

var databaseAccountsGetGremlinDatabase* = Call_DatabaseAccountsGetGremlinDatabase_564343(
    name: "databaseAccountsGetGremlinDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}",
    validator: validate_DatabaseAccountsGetGremlinDatabase_564344, base: "",
    url: url_DatabaseAccountsGetGremlinDatabase_564345, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteGremlinDatabase_564369 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsDeleteGremlinDatabase_564371(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/gremlin/databases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsDeleteGremlinDatabase_564370(path: JsonNode;
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
  var valid_564372 = path.getOrDefault("subscriptionId")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "subscriptionId", valid_564372
  var valid_564373 = path.getOrDefault("databaseName")
  valid_564373 = validateParameter(valid_564373, JString, required = true,
                                 default = nil)
  if valid_564373 != nil:
    section.add "databaseName", valid_564373
  var valid_564374 = path.getOrDefault("resourceGroupName")
  valid_564374 = validateParameter(valid_564374, JString, required = true,
                                 default = nil)
  if valid_564374 != nil:
    section.add "resourceGroupName", valid_564374
  var valid_564375 = path.getOrDefault("accountName")
  valid_564375 = validateParameter(valid_564375, JString, required = true,
                                 default = nil)
  if valid_564375 != nil:
    section.add "accountName", valid_564375
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564376 = query.getOrDefault("api-version")
  valid_564376 = validateParameter(valid_564376, JString, required = true,
                                 default = nil)
  if valid_564376 != nil:
    section.add "api-version", valid_564376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564377: Call_DatabaseAccountsDeleteGremlinDatabase_564369;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB Gremlin database.
  ## 
  let valid = call_564377.validator(path, query, header, formData, body)
  let scheme = call_564377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564377.url(scheme.get, call_564377.host, call_564377.base,
                         call_564377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564377, url, valid)

proc call*(call_564378: Call_DatabaseAccountsDeleteGremlinDatabase_564369;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsDeleteGremlinDatabase
  ## Deletes an existing Azure Cosmos DB Gremlin database.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564379 = newJObject()
  var query_564380 = newJObject()
  add(query_564380, "api-version", newJString(apiVersion))
  add(path_564379, "subscriptionId", newJString(subscriptionId))
  add(path_564379, "databaseName", newJString(databaseName))
  add(path_564379, "resourceGroupName", newJString(resourceGroupName))
  add(path_564379, "accountName", newJString(accountName))
  result = call_564378.call(path_564379, query_564380, nil, nil, nil)

var databaseAccountsDeleteGremlinDatabase* = Call_DatabaseAccountsDeleteGremlinDatabase_564369(
    name: "databaseAccountsDeleteGremlinDatabase", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}",
    validator: validate_DatabaseAccountsDeleteGremlinDatabase_564370, base: "",
    url: url_DatabaseAccountsDeleteGremlinDatabase_564371, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListGremlinGraphs_564381 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsListGremlinGraphs_564383(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/apis/gremlin/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/graphs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsListGremlinGraphs_564382(path: JsonNode;
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
  var valid_564384 = path.getOrDefault("subscriptionId")
  valid_564384 = validateParameter(valid_564384, JString, required = true,
                                 default = nil)
  if valid_564384 != nil:
    section.add "subscriptionId", valid_564384
  var valid_564385 = path.getOrDefault("databaseName")
  valid_564385 = validateParameter(valid_564385, JString, required = true,
                                 default = nil)
  if valid_564385 != nil:
    section.add "databaseName", valid_564385
  var valid_564386 = path.getOrDefault("resourceGroupName")
  valid_564386 = validateParameter(valid_564386, JString, required = true,
                                 default = nil)
  if valid_564386 != nil:
    section.add "resourceGroupName", valid_564386
  var valid_564387 = path.getOrDefault("accountName")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "accountName", valid_564387
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564388 = query.getOrDefault("api-version")
  valid_564388 = validateParameter(valid_564388, JString, required = true,
                                 default = nil)
  if valid_564388 != nil:
    section.add "api-version", valid_564388
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564389: Call_DatabaseAccountsListGremlinGraphs_564381;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Gremlin graph under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_564389.validator(path, query, header, formData, body)
  let scheme = call_564389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564389.url(scheme.get, call_564389.host, call_564389.base,
                         call_564389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564389, url, valid)

proc call*(call_564390: Call_DatabaseAccountsListGremlinGraphs_564381;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsListGremlinGraphs
  ## Lists the Gremlin graph under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564391 = newJObject()
  var query_564392 = newJObject()
  add(query_564392, "api-version", newJString(apiVersion))
  add(path_564391, "subscriptionId", newJString(subscriptionId))
  add(path_564391, "databaseName", newJString(databaseName))
  add(path_564391, "resourceGroupName", newJString(resourceGroupName))
  add(path_564391, "accountName", newJString(accountName))
  result = call_564390.call(path_564391, query_564392, nil, nil, nil)

var databaseAccountsListGremlinGraphs* = Call_DatabaseAccountsListGremlinGraphs_564381(
    name: "databaseAccountsListGremlinGraphs", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/graphs",
    validator: validate_DatabaseAccountsListGremlinGraphs_564382, base: "",
    url: url_DatabaseAccountsListGremlinGraphs_564383, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateGremlinGraph_564406 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsCreateUpdateGremlinGraph_564408(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/gremlin/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/graphs/"),
               (kind: VariableSegment, value: "graphName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsCreateUpdateGremlinGraph_564407(path: JsonNode;
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
  var valid_564409 = path.getOrDefault("graphName")
  valid_564409 = validateParameter(valid_564409, JString, required = true,
                                 default = nil)
  if valid_564409 != nil:
    section.add "graphName", valid_564409
  var valid_564410 = path.getOrDefault("subscriptionId")
  valid_564410 = validateParameter(valid_564410, JString, required = true,
                                 default = nil)
  if valid_564410 != nil:
    section.add "subscriptionId", valid_564410
  var valid_564411 = path.getOrDefault("databaseName")
  valid_564411 = validateParameter(valid_564411, JString, required = true,
                                 default = nil)
  if valid_564411 != nil:
    section.add "databaseName", valid_564411
  var valid_564412 = path.getOrDefault("resourceGroupName")
  valid_564412 = validateParameter(valid_564412, JString, required = true,
                                 default = nil)
  if valid_564412 != nil:
    section.add "resourceGroupName", valid_564412
  var valid_564413 = path.getOrDefault("accountName")
  valid_564413 = validateParameter(valid_564413, JString, required = true,
                                 default = nil)
  if valid_564413 != nil:
    section.add "accountName", valid_564413
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564414 = query.getOrDefault("api-version")
  valid_564414 = validateParameter(valid_564414, JString, required = true,
                                 default = nil)
  if valid_564414 != nil:
    section.add "api-version", valid_564414
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

proc call*(call_564416: Call_DatabaseAccountsCreateUpdateGremlinGraph_564406;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB Gremlin graph
  ## 
  let valid = call_564416.validator(path, query, header, formData, body)
  let scheme = call_564416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564416.url(scheme.get, call_564416.host, call_564416.base,
                         call_564416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564416, url, valid)

proc call*(call_564417: Call_DatabaseAccountsCreateUpdateGremlinGraph_564406;
          apiVersion: string; graphName: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string;
          createUpdateGremlinGraphParameters: JsonNode; accountName: string): Recallable =
  ## databaseAccountsCreateUpdateGremlinGraph
  ## Create or update an Azure Cosmos DB Gremlin graph
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564418 = newJObject()
  var query_564419 = newJObject()
  var body_564420 = newJObject()
  add(query_564419, "api-version", newJString(apiVersion))
  add(path_564418, "graphName", newJString(graphName))
  add(path_564418, "subscriptionId", newJString(subscriptionId))
  add(path_564418, "databaseName", newJString(databaseName))
  add(path_564418, "resourceGroupName", newJString(resourceGroupName))
  if createUpdateGremlinGraphParameters != nil:
    body_564420 = createUpdateGremlinGraphParameters
  add(path_564418, "accountName", newJString(accountName))
  result = call_564417.call(path_564418, query_564419, nil, nil, body_564420)

var databaseAccountsCreateUpdateGremlinGraph* = Call_DatabaseAccountsCreateUpdateGremlinGraph_564406(
    name: "databaseAccountsCreateUpdateGremlinGraph", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/graphs/{graphName}",
    validator: validate_DatabaseAccountsCreateUpdateGremlinGraph_564407, base: "",
    url: url_DatabaseAccountsCreateUpdateGremlinGraph_564408,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetGremlinGraph_564393 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsGetGremlinGraph_564395(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/apis/gremlin/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/graphs/"),
               (kind: VariableSegment, value: "graphName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsGetGremlinGraph_564394(path: JsonNode;
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
  var valid_564396 = path.getOrDefault("graphName")
  valid_564396 = validateParameter(valid_564396, JString, required = true,
                                 default = nil)
  if valid_564396 != nil:
    section.add "graphName", valid_564396
  var valid_564397 = path.getOrDefault("subscriptionId")
  valid_564397 = validateParameter(valid_564397, JString, required = true,
                                 default = nil)
  if valid_564397 != nil:
    section.add "subscriptionId", valid_564397
  var valid_564398 = path.getOrDefault("databaseName")
  valid_564398 = validateParameter(valid_564398, JString, required = true,
                                 default = nil)
  if valid_564398 != nil:
    section.add "databaseName", valid_564398
  var valid_564399 = path.getOrDefault("resourceGroupName")
  valid_564399 = validateParameter(valid_564399, JString, required = true,
                                 default = nil)
  if valid_564399 != nil:
    section.add "resourceGroupName", valid_564399
  var valid_564400 = path.getOrDefault("accountName")
  valid_564400 = validateParameter(valid_564400, JString, required = true,
                                 default = nil)
  if valid_564400 != nil:
    section.add "accountName", valid_564400
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564401 = query.getOrDefault("api-version")
  valid_564401 = validateParameter(valid_564401, JString, required = true,
                                 default = nil)
  if valid_564401 != nil:
    section.add "api-version", valid_564401
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564402: Call_DatabaseAccountsGetGremlinGraph_564393;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the Gremlin graph under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_564402.validator(path, query, header, formData, body)
  let scheme = call_564402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564402.url(scheme.get, call_564402.host, call_564402.base,
                         call_564402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564402, url, valid)

proc call*(call_564403: Call_DatabaseAccountsGetGremlinGraph_564393;
          apiVersion: string; graphName: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsGetGremlinGraph
  ## Gets the Gremlin graph under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564404 = newJObject()
  var query_564405 = newJObject()
  add(query_564405, "api-version", newJString(apiVersion))
  add(path_564404, "graphName", newJString(graphName))
  add(path_564404, "subscriptionId", newJString(subscriptionId))
  add(path_564404, "databaseName", newJString(databaseName))
  add(path_564404, "resourceGroupName", newJString(resourceGroupName))
  add(path_564404, "accountName", newJString(accountName))
  result = call_564403.call(path_564404, query_564405, nil, nil, nil)

var databaseAccountsGetGremlinGraph* = Call_DatabaseAccountsGetGremlinGraph_564393(
    name: "databaseAccountsGetGremlinGraph", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/graphs/{graphName}",
    validator: validate_DatabaseAccountsGetGremlinGraph_564394, base: "",
    url: url_DatabaseAccountsGetGremlinGraph_564395, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteGremlinGraph_564421 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsDeleteGremlinGraph_564423(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/apis/gremlin/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/graphs/"),
               (kind: VariableSegment, value: "graphName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsDeleteGremlinGraph_564422(path: JsonNode;
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
  var valid_564424 = path.getOrDefault("graphName")
  valid_564424 = validateParameter(valid_564424, JString, required = true,
                                 default = nil)
  if valid_564424 != nil:
    section.add "graphName", valid_564424
  var valid_564425 = path.getOrDefault("subscriptionId")
  valid_564425 = validateParameter(valid_564425, JString, required = true,
                                 default = nil)
  if valid_564425 != nil:
    section.add "subscriptionId", valid_564425
  var valid_564426 = path.getOrDefault("databaseName")
  valid_564426 = validateParameter(valid_564426, JString, required = true,
                                 default = nil)
  if valid_564426 != nil:
    section.add "databaseName", valid_564426
  var valid_564427 = path.getOrDefault("resourceGroupName")
  valid_564427 = validateParameter(valid_564427, JString, required = true,
                                 default = nil)
  if valid_564427 != nil:
    section.add "resourceGroupName", valid_564427
  var valid_564428 = path.getOrDefault("accountName")
  valid_564428 = validateParameter(valid_564428, JString, required = true,
                                 default = nil)
  if valid_564428 != nil:
    section.add "accountName", valid_564428
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564429 = query.getOrDefault("api-version")
  valid_564429 = validateParameter(valid_564429, JString, required = true,
                                 default = nil)
  if valid_564429 != nil:
    section.add "api-version", valid_564429
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564430: Call_DatabaseAccountsDeleteGremlinGraph_564421;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB Gremlin graph.
  ## 
  let valid = call_564430.validator(path, query, header, formData, body)
  let scheme = call_564430.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564430.url(scheme.get, call_564430.host, call_564430.base,
                         call_564430.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564430, url, valid)

proc call*(call_564431: Call_DatabaseAccountsDeleteGremlinGraph_564421;
          apiVersion: string; graphName: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsDeleteGremlinGraph
  ## Deletes an existing Azure Cosmos DB Gremlin graph.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564432 = newJObject()
  var query_564433 = newJObject()
  add(query_564433, "api-version", newJString(apiVersion))
  add(path_564432, "graphName", newJString(graphName))
  add(path_564432, "subscriptionId", newJString(subscriptionId))
  add(path_564432, "databaseName", newJString(databaseName))
  add(path_564432, "resourceGroupName", newJString(resourceGroupName))
  add(path_564432, "accountName", newJString(accountName))
  result = call_564431.call(path_564432, query_564433, nil, nil, nil)

var databaseAccountsDeleteGremlinGraph* = Call_DatabaseAccountsDeleteGremlinGraph_564421(
    name: "databaseAccountsDeleteGremlinGraph", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/graphs/{graphName}",
    validator: validate_DatabaseAccountsDeleteGremlinGraph_564422, base: "",
    url: url_DatabaseAccountsDeleteGremlinGraph_564423, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateGremlinGraphThroughput_564447 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsUpdateGremlinGraphThroughput_564449(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/gremlin/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/graphs/"),
               (kind: VariableSegment, value: "graphName"),
               (kind: ConstantSegment, value: "/settings/throughput")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsUpdateGremlinGraphThroughput_564448(path: JsonNode;
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
  var valid_564450 = path.getOrDefault("graphName")
  valid_564450 = validateParameter(valid_564450, JString, required = true,
                                 default = nil)
  if valid_564450 != nil:
    section.add "graphName", valid_564450
  var valid_564451 = path.getOrDefault("subscriptionId")
  valid_564451 = validateParameter(valid_564451, JString, required = true,
                                 default = nil)
  if valid_564451 != nil:
    section.add "subscriptionId", valid_564451
  var valid_564452 = path.getOrDefault("databaseName")
  valid_564452 = validateParameter(valid_564452, JString, required = true,
                                 default = nil)
  if valid_564452 != nil:
    section.add "databaseName", valid_564452
  var valid_564453 = path.getOrDefault("resourceGroupName")
  valid_564453 = validateParameter(valid_564453, JString, required = true,
                                 default = nil)
  if valid_564453 != nil:
    section.add "resourceGroupName", valid_564453
  var valid_564454 = path.getOrDefault("accountName")
  valid_564454 = validateParameter(valid_564454, JString, required = true,
                                 default = nil)
  if valid_564454 != nil:
    section.add "accountName", valid_564454
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564455 = query.getOrDefault("api-version")
  valid_564455 = validateParameter(valid_564455, JString, required = true,
                                 default = nil)
  if valid_564455 != nil:
    section.add "api-version", valid_564455
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

proc call*(call_564457: Call_DatabaseAccountsUpdateGremlinGraphThroughput_564447;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Gremlin graph
  ## 
  let valid = call_564457.validator(path, query, header, formData, body)
  let scheme = call_564457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564457.url(scheme.get, call_564457.host, call_564457.base,
                         call_564457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564457, url, valid)

proc call*(call_564458: Call_DatabaseAccountsUpdateGremlinGraphThroughput_564447;
          apiVersion: string; graphName: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string; accountName: string;
          updateThroughputParameters: JsonNode): Recallable =
  ## databaseAccountsUpdateGremlinGraphThroughput
  ## Update RUs per second of an Azure Cosmos DB Gremlin graph
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564459 = newJObject()
  var query_564460 = newJObject()
  var body_564461 = newJObject()
  add(query_564460, "api-version", newJString(apiVersion))
  add(path_564459, "graphName", newJString(graphName))
  add(path_564459, "subscriptionId", newJString(subscriptionId))
  add(path_564459, "databaseName", newJString(databaseName))
  add(path_564459, "resourceGroupName", newJString(resourceGroupName))
  add(path_564459, "accountName", newJString(accountName))
  if updateThroughputParameters != nil:
    body_564461 = updateThroughputParameters
  result = call_564458.call(path_564459, query_564460, nil, nil, body_564461)

var databaseAccountsUpdateGremlinGraphThroughput* = Call_DatabaseAccountsUpdateGremlinGraphThroughput_564447(
    name: "databaseAccountsUpdateGremlinGraphThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/graphs/{graphName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateGremlinGraphThroughput_564448,
    base: "", url: url_DatabaseAccountsUpdateGremlinGraphThroughput_564449,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetGremlinGraphThroughput_564434 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsGetGremlinGraphThroughput_564436(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/gremlin/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/graphs/"),
               (kind: VariableSegment, value: "graphName"),
               (kind: ConstantSegment, value: "/settings/throughput")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsGetGremlinGraphThroughput_564435(path: JsonNode;
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
  var valid_564437 = path.getOrDefault("graphName")
  valid_564437 = validateParameter(valid_564437, JString, required = true,
                                 default = nil)
  if valid_564437 != nil:
    section.add "graphName", valid_564437
  var valid_564438 = path.getOrDefault("subscriptionId")
  valid_564438 = validateParameter(valid_564438, JString, required = true,
                                 default = nil)
  if valid_564438 != nil:
    section.add "subscriptionId", valid_564438
  var valid_564439 = path.getOrDefault("databaseName")
  valid_564439 = validateParameter(valid_564439, JString, required = true,
                                 default = nil)
  if valid_564439 != nil:
    section.add "databaseName", valid_564439
  var valid_564440 = path.getOrDefault("resourceGroupName")
  valid_564440 = validateParameter(valid_564440, JString, required = true,
                                 default = nil)
  if valid_564440 != nil:
    section.add "resourceGroupName", valid_564440
  var valid_564441 = path.getOrDefault("accountName")
  valid_564441 = validateParameter(valid_564441, JString, required = true,
                                 default = nil)
  if valid_564441 != nil:
    section.add "accountName", valid_564441
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564442 = query.getOrDefault("api-version")
  valid_564442 = validateParameter(valid_564442, JString, required = true,
                                 default = nil)
  if valid_564442 != nil:
    section.add "api-version", valid_564442
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564443: Call_DatabaseAccountsGetGremlinGraphThroughput_564434;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the Gremlin graph throughput under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_564443.validator(path, query, header, formData, body)
  let scheme = call_564443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564443.url(scheme.get, call_564443.host, call_564443.base,
                         call_564443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564443, url, valid)

proc call*(call_564444: Call_DatabaseAccountsGetGremlinGraphThroughput_564434;
          apiVersion: string; graphName: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsGetGremlinGraphThroughput
  ## Gets the Gremlin graph throughput under an existing Azure Cosmos DB database account with the provided name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564445 = newJObject()
  var query_564446 = newJObject()
  add(query_564446, "api-version", newJString(apiVersion))
  add(path_564445, "graphName", newJString(graphName))
  add(path_564445, "subscriptionId", newJString(subscriptionId))
  add(path_564445, "databaseName", newJString(databaseName))
  add(path_564445, "resourceGroupName", newJString(resourceGroupName))
  add(path_564445, "accountName", newJString(accountName))
  result = call_564444.call(path_564445, query_564446, nil, nil, nil)

var databaseAccountsGetGremlinGraphThroughput* = Call_DatabaseAccountsGetGremlinGraphThroughput_564434(
    name: "databaseAccountsGetGremlinGraphThroughput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/graphs/{graphName}/settings/throughput",
    validator: validate_DatabaseAccountsGetGremlinGraphThroughput_564435,
    base: "", url: url_DatabaseAccountsGetGremlinGraphThroughput_564436,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateGremlinDatabaseThroughput_564474 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsUpdateGremlinDatabaseThroughput_564476(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/gremlin/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/settings/throughput")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsUpdateGremlinDatabaseThroughput_564475(
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
  var valid_564477 = path.getOrDefault("subscriptionId")
  valid_564477 = validateParameter(valid_564477, JString, required = true,
                                 default = nil)
  if valid_564477 != nil:
    section.add "subscriptionId", valid_564477
  var valid_564478 = path.getOrDefault("databaseName")
  valid_564478 = validateParameter(valid_564478, JString, required = true,
                                 default = nil)
  if valid_564478 != nil:
    section.add "databaseName", valid_564478
  var valid_564479 = path.getOrDefault("resourceGroupName")
  valid_564479 = validateParameter(valid_564479, JString, required = true,
                                 default = nil)
  if valid_564479 != nil:
    section.add "resourceGroupName", valid_564479
  var valid_564480 = path.getOrDefault("accountName")
  valid_564480 = validateParameter(valid_564480, JString, required = true,
                                 default = nil)
  if valid_564480 != nil:
    section.add "accountName", valid_564480
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564481 = query.getOrDefault("api-version")
  valid_564481 = validateParameter(valid_564481, JString, required = true,
                                 default = nil)
  if valid_564481 != nil:
    section.add "api-version", valid_564481
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

proc call*(call_564483: Call_DatabaseAccountsUpdateGremlinDatabaseThroughput_564474;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Gremlin database
  ## 
  let valid = call_564483.validator(path, query, header, formData, body)
  let scheme = call_564483.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564483.url(scheme.get, call_564483.host, call_564483.base,
                         call_564483.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564483, url, valid)

proc call*(call_564484: Call_DatabaseAccountsUpdateGremlinDatabaseThroughput_564474;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; accountName: string;
          updateThroughputParameters: JsonNode): Recallable =
  ## databaseAccountsUpdateGremlinDatabaseThroughput
  ## Update RUs per second of an Azure Cosmos DB Gremlin database
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564485 = newJObject()
  var query_564486 = newJObject()
  var body_564487 = newJObject()
  add(query_564486, "api-version", newJString(apiVersion))
  add(path_564485, "subscriptionId", newJString(subscriptionId))
  add(path_564485, "databaseName", newJString(databaseName))
  add(path_564485, "resourceGroupName", newJString(resourceGroupName))
  add(path_564485, "accountName", newJString(accountName))
  if updateThroughputParameters != nil:
    body_564487 = updateThroughputParameters
  result = call_564484.call(path_564485, query_564486, nil, nil, body_564487)

var databaseAccountsUpdateGremlinDatabaseThroughput* = Call_DatabaseAccountsUpdateGremlinDatabaseThroughput_564474(
    name: "databaseAccountsUpdateGremlinDatabaseThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateGremlinDatabaseThroughput_564475,
    base: "", url: url_DatabaseAccountsUpdateGremlinDatabaseThroughput_564476,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetGremlinDatabaseThroughput_564462 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsGetGremlinDatabaseThroughput_564464(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/gremlin/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/settings/throughput")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsGetGremlinDatabaseThroughput_564463(path: JsonNode;
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
  var valid_564465 = path.getOrDefault("subscriptionId")
  valid_564465 = validateParameter(valid_564465, JString, required = true,
                                 default = nil)
  if valid_564465 != nil:
    section.add "subscriptionId", valid_564465
  var valid_564466 = path.getOrDefault("databaseName")
  valid_564466 = validateParameter(valid_564466, JString, required = true,
                                 default = nil)
  if valid_564466 != nil:
    section.add "databaseName", valid_564466
  var valid_564467 = path.getOrDefault("resourceGroupName")
  valid_564467 = validateParameter(valid_564467, JString, required = true,
                                 default = nil)
  if valid_564467 != nil:
    section.add "resourceGroupName", valid_564467
  var valid_564468 = path.getOrDefault("accountName")
  valid_564468 = validateParameter(valid_564468, JString, required = true,
                                 default = nil)
  if valid_564468 != nil:
    section.add "accountName", valid_564468
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564469 = query.getOrDefault("api-version")
  valid_564469 = validateParameter(valid_564469, JString, required = true,
                                 default = nil)
  if valid_564469 != nil:
    section.add "api-version", valid_564469
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564470: Call_DatabaseAccountsGetGremlinDatabaseThroughput_564462;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the Gremlin database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_564470.validator(path, query, header, formData, body)
  let scheme = call_564470.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564470.url(scheme.get, call_564470.host, call_564470.base,
                         call_564470.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564470, url, valid)

proc call*(call_564471: Call_DatabaseAccountsGetGremlinDatabaseThroughput_564462;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsGetGremlinDatabaseThroughput
  ## Gets the RUs per second of the Gremlin database under an existing Azure Cosmos DB database account with the provided name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564472 = newJObject()
  var query_564473 = newJObject()
  add(query_564473, "api-version", newJString(apiVersion))
  add(path_564472, "subscriptionId", newJString(subscriptionId))
  add(path_564472, "databaseName", newJString(databaseName))
  add(path_564472, "resourceGroupName", newJString(resourceGroupName))
  add(path_564472, "accountName", newJString(accountName))
  result = call_564471.call(path_564472, query_564473, nil, nil, nil)

var databaseAccountsGetGremlinDatabaseThroughput* = Call_DatabaseAccountsGetGremlinDatabaseThroughput_564462(
    name: "databaseAccountsGetGremlinDatabaseThroughput",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/settings/throughput",
    validator: validate_DatabaseAccountsGetGremlinDatabaseThroughput_564463,
    base: "", url: url_DatabaseAccountsGetGremlinDatabaseThroughput_564464,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListMongoDBDatabases_564488 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsListMongoDBDatabases_564490(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/mongodb/databases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsListMongoDBDatabases_564489(path: JsonNode;
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
  var valid_564491 = path.getOrDefault("subscriptionId")
  valid_564491 = validateParameter(valid_564491, JString, required = true,
                                 default = nil)
  if valid_564491 != nil:
    section.add "subscriptionId", valid_564491
  var valid_564492 = path.getOrDefault("resourceGroupName")
  valid_564492 = validateParameter(valid_564492, JString, required = true,
                                 default = nil)
  if valid_564492 != nil:
    section.add "resourceGroupName", valid_564492
  var valid_564493 = path.getOrDefault("accountName")
  valid_564493 = validateParameter(valid_564493, JString, required = true,
                                 default = nil)
  if valid_564493 != nil:
    section.add "accountName", valid_564493
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564494 = query.getOrDefault("api-version")
  valid_564494 = validateParameter(valid_564494, JString, required = true,
                                 default = nil)
  if valid_564494 != nil:
    section.add "api-version", valid_564494
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564495: Call_DatabaseAccountsListMongoDBDatabases_564488;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the MongoDB databases under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_564495.validator(path, query, header, formData, body)
  let scheme = call_564495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564495.url(scheme.get, call_564495.host, call_564495.base,
                         call_564495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564495, url, valid)

proc call*(call_564496: Call_DatabaseAccountsListMongoDBDatabases_564488;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## databaseAccountsListMongoDBDatabases
  ## Lists the MongoDB databases under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564497 = newJObject()
  var query_564498 = newJObject()
  add(query_564498, "api-version", newJString(apiVersion))
  add(path_564497, "subscriptionId", newJString(subscriptionId))
  add(path_564497, "resourceGroupName", newJString(resourceGroupName))
  add(path_564497, "accountName", newJString(accountName))
  result = call_564496.call(path_564497, query_564498, nil, nil, nil)

var databaseAccountsListMongoDBDatabases* = Call_DatabaseAccountsListMongoDBDatabases_564488(
    name: "databaseAccountsListMongoDBDatabases", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases",
    validator: validate_DatabaseAccountsListMongoDBDatabases_564489, base: "",
    url: url_DatabaseAccountsListMongoDBDatabases_564490, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateMongoDBDatabase_564511 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsCreateUpdateMongoDBDatabase_564513(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/mongodb/databases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsCreateUpdateMongoDBDatabase_564512(path: JsonNode;
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
  var valid_564514 = path.getOrDefault("subscriptionId")
  valid_564514 = validateParameter(valid_564514, JString, required = true,
                                 default = nil)
  if valid_564514 != nil:
    section.add "subscriptionId", valid_564514
  var valid_564515 = path.getOrDefault("databaseName")
  valid_564515 = validateParameter(valid_564515, JString, required = true,
                                 default = nil)
  if valid_564515 != nil:
    section.add "databaseName", valid_564515
  var valid_564516 = path.getOrDefault("resourceGroupName")
  valid_564516 = validateParameter(valid_564516, JString, required = true,
                                 default = nil)
  if valid_564516 != nil:
    section.add "resourceGroupName", valid_564516
  var valid_564517 = path.getOrDefault("accountName")
  valid_564517 = validateParameter(valid_564517, JString, required = true,
                                 default = nil)
  if valid_564517 != nil:
    section.add "accountName", valid_564517
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564518 = query.getOrDefault("api-version")
  valid_564518 = validateParameter(valid_564518, JString, required = true,
                                 default = nil)
  if valid_564518 != nil:
    section.add "api-version", valid_564518
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

proc call*(call_564520: Call_DatabaseAccountsCreateUpdateMongoDBDatabase_564511;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or updates Azure Cosmos DB MongoDB database
  ## 
  let valid = call_564520.validator(path, query, header, formData, body)
  let scheme = call_564520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564520.url(scheme.get, call_564520.host, call_564520.base,
                         call_564520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564520, url, valid)

proc call*(call_564521: Call_DatabaseAccountsCreateUpdateMongoDBDatabase_564511;
          createUpdateMongoDBDatabaseParameters: JsonNode; apiVersion: string;
          subscriptionId: string; databaseName: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## databaseAccountsCreateUpdateMongoDBDatabase
  ## Create or updates Azure Cosmos DB MongoDB database
  ##   createUpdateMongoDBDatabaseParameters: JObject (required)
  ##                                        : The parameters to provide for the current MongoDB database.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564522 = newJObject()
  var query_564523 = newJObject()
  var body_564524 = newJObject()
  if createUpdateMongoDBDatabaseParameters != nil:
    body_564524 = createUpdateMongoDBDatabaseParameters
  add(query_564523, "api-version", newJString(apiVersion))
  add(path_564522, "subscriptionId", newJString(subscriptionId))
  add(path_564522, "databaseName", newJString(databaseName))
  add(path_564522, "resourceGroupName", newJString(resourceGroupName))
  add(path_564522, "accountName", newJString(accountName))
  result = call_564521.call(path_564522, query_564523, nil, nil, body_564524)

var databaseAccountsCreateUpdateMongoDBDatabase* = Call_DatabaseAccountsCreateUpdateMongoDBDatabase_564511(
    name: "databaseAccountsCreateUpdateMongoDBDatabase", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}",
    validator: validate_DatabaseAccountsCreateUpdateMongoDBDatabase_564512,
    base: "", url: url_DatabaseAccountsCreateUpdateMongoDBDatabase_564513,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetMongoDBDatabase_564499 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsGetMongoDBDatabase_564501(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/apis/mongodb/databases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsGetMongoDBDatabase_564500(path: JsonNode;
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
  var valid_564502 = path.getOrDefault("subscriptionId")
  valid_564502 = validateParameter(valid_564502, JString, required = true,
                                 default = nil)
  if valid_564502 != nil:
    section.add "subscriptionId", valid_564502
  var valid_564503 = path.getOrDefault("databaseName")
  valid_564503 = validateParameter(valid_564503, JString, required = true,
                                 default = nil)
  if valid_564503 != nil:
    section.add "databaseName", valid_564503
  var valid_564504 = path.getOrDefault("resourceGroupName")
  valid_564504 = validateParameter(valid_564504, JString, required = true,
                                 default = nil)
  if valid_564504 != nil:
    section.add "resourceGroupName", valid_564504
  var valid_564505 = path.getOrDefault("accountName")
  valid_564505 = validateParameter(valid_564505, JString, required = true,
                                 default = nil)
  if valid_564505 != nil:
    section.add "accountName", valid_564505
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564506 = query.getOrDefault("api-version")
  valid_564506 = validateParameter(valid_564506, JString, required = true,
                                 default = nil)
  if valid_564506 != nil:
    section.add "api-version", valid_564506
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564507: Call_DatabaseAccountsGetMongoDBDatabase_564499;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the MongoDB databases under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_564507.validator(path, query, header, formData, body)
  let scheme = call_564507.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564507.url(scheme.get, call_564507.host, call_564507.base,
                         call_564507.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564507, url, valid)

proc call*(call_564508: Call_DatabaseAccountsGetMongoDBDatabase_564499;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsGetMongoDBDatabase
  ## Gets the MongoDB databases under an existing Azure Cosmos DB database account with the provided name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564509 = newJObject()
  var query_564510 = newJObject()
  add(query_564510, "api-version", newJString(apiVersion))
  add(path_564509, "subscriptionId", newJString(subscriptionId))
  add(path_564509, "databaseName", newJString(databaseName))
  add(path_564509, "resourceGroupName", newJString(resourceGroupName))
  add(path_564509, "accountName", newJString(accountName))
  result = call_564508.call(path_564509, query_564510, nil, nil, nil)

var databaseAccountsGetMongoDBDatabase* = Call_DatabaseAccountsGetMongoDBDatabase_564499(
    name: "databaseAccountsGetMongoDBDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}",
    validator: validate_DatabaseAccountsGetMongoDBDatabase_564500, base: "",
    url: url_DatabaseAccountsGetMongoDBDatabase_564501, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteMongoDBDatabase_564525 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsDeleteMongoDBDatabase_564527(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/mongodb/databases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsDeleteMongoDBDatabase_564526(path: JsonNode;
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
  var valid_564528 = path.getOrDefault("subscriptionId")
  valid_564528 = validateParameter(valid_564528, JString, required = true,
                                 default = nil)
  if valid_564528 != nil:
    section.add "subscriptionId", valid_564528
  var valid_564529 = path.getOrDefault("databaseName")
  valid_564529 = validateParameter(valid_564529, JString, required = true,
                                 default = nil)
  if valid_564529 != nil:
    section.add "databaseName", valid_564529
  var valid_564530 = path.getOrDefault("resourceGroupName")
  valid_564530 = validateParameter(valid_564530, JString, required = true,
                                 default = nil)
  if valid_564530 != nil:
    section.add "resourceGroupName", valid_564530
  var valid_564531 = path.getOrDefault("accountName")
  valid_564531 = validateParameter(valid_564531, JString, required = true,
                                 default = nil)
  if valid_564531 != nil:
    section.add "accountName", valid_564531
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564532 = query.getOrDefault("api-version")
  valid_564532 = validateParameter(valid_564532, JString, required = true,
                                 default = nil)
  if valid_564532 != nil:
    section.add "api-version", valid_564532
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564533: Call_DatabaseAccountsDeleteMongoDBDatabase_564525;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB MongoDB database.
  ## 
  let valid = call_564533.validator(path, query, header, formData, body)
  let scheme = call_564533.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564533.url(scheme.get, call_564533.host, call_564533.base,
                         call_564533.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564533, url, valid)

proc call*(call_564534: Call_DatabaseAccountsDeleteMongoDBDatabase_564525;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsDeleteMongoDBDatabase
  ## Deletes an existing Azure Cosmos DB MongoDB database.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564535 = newJObject()
  var query_564536 = newJObject()
  add(query_564536, "api-version", newJString(apiVersion))
  add(path_564535, "subscriptionId", newJString(subscriptionId))
  add(path_564535, "databaseName", newJString(databaseName))
  add(path_564535, "resourceGroupName", newJString(resourceGroupName))
  add(path_564535, "accountName", newJString(accountName))
  result = call_564534.call(path_564535, query_564536, nil, nil, nil)

var databaseAccountsDeleteMongoDBDatabase* = Call_DatabaseAccountsDeleteMongoDBDatabase_564525(
    name: "databaseAccountsDeleteMongoDBDatabase", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}",
    validator: validate_DatabaseAccountsDeleteMongoDBDatabase_564526, base: "",
    url: url_DatabaseAccountsDeleteMongoDBDatabase_564527, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListMongoDBCollections_564537 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsListMongoDBCollections_564539(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/mongodb/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/collections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsListMongoDBCollections_564538(path: JsonNode;
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
  var valid_564540 = path.getOrDefault("subscriptionId")
  valid_564540 = validateParameter(valid_564540, JString, required = true,
                                 default = nil)
  if valid_564540 != nil:
    section.add "subscriptionId", valid_564540
  var valid_564541 = path.getOrDefault("databaseName")
  valid_564541 = validateParameter(valid_564541, JString, required = true,
                                 default = nil)
  if valid_564541 != nil:
    section.add "databaseName", valid_564541
  var valid_564542 = path.getOrDefault("resourceGroupName")
  valid_564542 = validateParameter(valid_564542, JString, required = true,
                                 default = nil)
  if valid_564542 != nil:
    section.add "resourceGroupName", valid_564542
  var valid_564543 = path.getOrDefault("accountName")
  valid_564543 = validateParameter(valid_564543, JString, required = true,
                                 default = nil)
  if valid_564543 != nil:
    section.add "accountName", valid_564543
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564544 = query.getOrDefault("api-version")
  valid_564544 = validateParameter(valid_564544, JString, required = true,
                                 default = nil)
  if valid_564544 != nil:
    section.add "api-version", valid_564544
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564545: Call_DatabaseAccountsListMongoDBCollections_564537;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the MongoDB collection under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_564545.validator(path, query, header, formData, body)
  let scheme = call_564545.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564545.url(scheme.get, call_564545.host, call_564545.base,
                         call_564545.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564545, url, valid)

proc call*(call_564546: Call_DatabaseAccountsListMongoDBCollections_564537;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsListMongoDBCollections
  ## Lists the MongoDB collection under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564547 = newJObject()
  var query_564548 = newJObject()
  add(query_564548, "api-version", newJString(apiVersion))
  add(path_564547, "subscriptionId", newJString(subscriptionId))
  add(path_564547, "databaseName", newJString(databaseName))
  add(path_564547, "resourceGroupName", newJString(resourceGroupName))
  add(path_564547, "accountName", newJString(accountName))
  result = call_564546.call(path_564547, query_564548, nil, nil, nil)

var databaseAccountsListMongoDBCollections* = Call_DatabaseAccountsListMongoDBCollections_564537(
    name: "databaseAccountsListMongoDBCollections", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/collections",
    validator: validate_DatabaseAccountsListMongoDBCollections_564538, base: "",
    url: url_DatabaseAccountsListMongoDBCollections_564539,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateMongoDBCollection_564562 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsCreateUpdateMongoDBCollection_564564(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/mongodb/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/collections/"),
               (kind: VariableSegment, value: "collectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsCreateUpdateMongoDBCollection_564563(
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
  var valid_564565 = path.getOrDefault("collectionName")
  valid_564565 = validateParameter(valid_564565, JString, required = true,
                                 default = nil)
  if valid_564565 != nil:
    section.add "collectionName", valid_564565
  var valid_564566 = path.getOrDefault("subscriptionId")
  valid_564566 = validateParameter(valid_564566, JString, required = true,
                                 default = nil)
  if valid_564566 != nil:
    section.add "subscriptionId", valid_564566
  var valid_564567 = path.getOrDefault("databaseName")
  valid_564567 = validateParameter(valid_564567, JString, required = true,
                                 default = nil)
  if valid_564567 != nil:
    section.add "databaseName", valid_564567
  var valid_564568 = path.getOrDefault("resourceGroupName")
  valid_564568 = validateParameter(valid_564568, JString, required = true,
                                 default = nil)
  if valid_564568 != nil:
    section.add "resourceGroupName", valid_564568
  var valid_564569 = path.getOrDefault("accountName")
  valid_564569 = validateParameter(valid_564569, JString, required = true,
                                 default = nil)
  if valid_564569 != nil:
    section.add "accountName", valid_564569
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564570 = query.getOrDefault("api-version")
  valid_564570 = validateParameter(valid_564570, JString, required = true,
                                 default = nil)
  if valid_564570 != nil:
    section.add "api-version", valid_564570
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

proc call*(call_564572: Call_DatabaseAccountsCreateUpdateMongoDBCollection_564562;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB MongoDB Collection
  ## 
  let valid = call_564572.validator(path, query, header, formData, body)
  let scheme = call_564572.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564572.url(scheme.get, call_564572.host, call_564572.base,
                         call_564572.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564572, url, valid)

proc call*(call_564573: Call_DatabaseAccountsCreateUpdateMongoDBCollection_564562;
          collectionName: string; apiVersion: string;
          createUpdateMongoDBCollectionParameters: JsonNode;
          subscriptionId: string; databaseName: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## databaseAccountsCreateUpdateMongoDBCollection
  ## Create or update an Azure Cosmos DB MongoDB Collection
  ##   collectionName: string (required)
  ##                 : Cosmos DB collection name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564574 = newJObject()
  var query_564575 = newJObject()
  var body_564576 = newJObject()
  add(path_564574, "collectionName", newJString(collectionName))
  add(query_564575, "api-version", newJString(apiVersion))
  if createUpdateMongoDBCollectionParameters != nil:
    body_564576 = createUpdateMongoDBCollectionParameters
  add(path_564574, "subscriptionId", newJString(subscriptionId))
  add(path_564574, "databaseName", newJString(databaseName))
  add(path_564574, "resourceGroupName", newJString(resourceGroupName))
  add(path_564574, "accountName", newJString(accountName))
  result = call_564573.call(path_564574, query_564575, nil, nil, body_564576)

var databaseAccountsCreateUpdateMongoDBCollection* = Call_DatabaseAccountsCreateUpdateMongoDBCollection_564562(
    name: "databaseAccountsCreateUpdateMongoDBCollection",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/collections/{collectionName}",
    validator: validate_DatabaseAccountsCreateUpdateMongoDBCollection_564563,
    base: "", url: url_DatabaseAccountsCreateUpdateMongoDBCollection_564564,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetMongoDBCollection_564549 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsGetMongoDBCollection_564551(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/mongodb/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/collections/"),
               (kind: VariableSegment, value: "collectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsGetMongoDBCollection_564550(path: JsonNode;
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
  var valid_564552 = path.getOrDefault("collectionName")
  valid_564552 = validateParameter(valid_564552, JString, required = true,
                                 default = nil)
  if valid_564552 != nil:
    section.add "collectionName", valid_564552
  var valid_564553 = path.getOrDefault("subscriptionId")
  valid_564553 = validateParameter(valid_564553, JString, required = true,
                                 default = nil)
  if valid_564553 != nil:
    section.add "subscriptionId", valid_564553
  var valid_564554 = path.getOrDefault("databaseName")
  valid_564554 = validateParameter(valid_564554, JString, required = true,
                                 default = nil)
  if valid_564554 != nil:
    section.add "databaseName", valid_564554
  var valid_564555 = path.getOrDefault("resourceGroupName")
  valid_564555 = validateParameter(valid_564555, JString, required = true,
                                 default = nil)
  if valid_564555 != nil:
    section.add "resourceGroupName", valid_564555
  var valid_564556 = path.getOrDefault("accountName")
  valid_564556 = validateParameter(valid_564556, JString, required = true,
                                 default = nil)
  if valid_564556 != nil:
    section.add "accountName", valid_564556
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564557 = query.getOrDefault("api-version")
  valid_564557 = validateParameter(valid_564557, JString, required = true,
                                 default = nil)
  if valid_564557 != nil:
    section.add "api-version", valid_564557
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564558: Call_DatabaseAccountsGetMongoDBCollection_564549;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the MongoDB collection under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_564558.validator(path, query, header, formData, body)
  let scheme = call_564558.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564558.url(scheme.get, call_564558.host, call_564558.base,
                         call_564558.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564558, url, valid)

proc call*(call_564559: Call_DatabaseAccountsGetMongoDBCollection_564549;
          collectionName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsGetMongoDBCollection
  ## Gets the MongoDB collection under an existing Azure Cosmos DB database account.
  ##   collectionName: string (required)
  ##                 : Cosmos DB collection name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564560 = newJObject()
  var query_564561 = newJObject()
  add(path_564560, "collectionName", newJString(collectionName))
  add(query_564561, "api-version", newJString(apiVersion))
  add(path_564560, "subscriptionId", newJString(subscriptionId))
  add(path_564560, "databaseName", newJString(databaseName))
  add(path_564560, "resourceGroupName", newJString(resourceGroupName))
  add(path_564560, "accountName", newJString(accountName))
  result = call_564559.call(path_564560, query_564561, nil, nil, nil)

var databaseAccountsGetMongoDBCollection* = Call_DatabaseAccountsGetMongoDBCollection_564549(
    name: "databaseAccountsGetMongoDBCollection", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/collections/{collectionName}",
    validator: validate_DatabaseAccountsGetMongoDBCollection_564550, base: "",
    url: url_DatabaseAccountsGetMongoDBCollection_564551, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteMongoDBCollection_564577 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsDeleteMongoDBCollection_564579(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/mongodb/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/collections/"),
               (kind: VariableSegment, value: "collectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsDeleteMongoDBCollection_564578(path: JsonNode;
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
  var valid_564580 = path.getOrDefault("collectionName")
  valid_564580 = validateParameter(valid_564580, JString, required = true,
                                 default = nil)
  if valid_564580 != nil:
    section.add "collectionName", valid_564580
  var valid_564581 = path.getOrDefault("subscriptionId")
  valid_564581 = validateParameter(valid_564581, JString, required = true,
                                 default = nil)
  if valid_564581 != nil:
    section.add "subscriptionId", valid_564581
  var valid_564582 = path.getOrDefault("databaseName")
  valid_564582 = validateParameter(valid_564582, JString, required = true,
                                 default = nil)
  if valid_564582 != nil:
    section.add "databaseName", valid_564582
  var valid_564583 = path.getOrDefault("resourceGroupName")
  valid_564583 = validateParameter(valid_564583, JString, required = true,
                                 default = nil)
  if valid_564583 != nil:
    section.add "resourceGroupName", valid_564583
  var valid_564584 = path.getOrDefault("accountName")
  valid_564584 = validateParameter(valid_564584, JString, required = true,
                                 default = nil)
  if valid_564584 != nil:
    section.add "accountName", valid_564584
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564585 = query.getOrDefault("api-version")
  valid_564585 = validateParameter(valid_564585, JString, required = true,
                                 default = nil)
  if valid_564585 != nil:
    section.add "api-version", valid_564585
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564586: Call_DatabaseAccountsDeleteMongoDBCollection_564577;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB MongoDB Collection.
  ## 
  let valid = call_564586.validator(path, query, header, formData, body)
  let scheme = call_564586.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564586.url(scheme.get, call_564586.host, call_564586.base,
                         call_564586.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564586, url, valid)

proc call*(call_564587: Call_DatabaseAccountsDeleteMongoDBCollection_564577;
          collectionName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsDeleteMongoDBCollection
  ## Deletes an existing Azure Cosmos DB MongoDB Collection.
  ##   collectionName: string (required)
  ##                 : Cosmos DB collection name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564588 = newJObject()
  var query_564589 = newJObject()
  add(path_564588, "collectionName", newJString(collectionName))
  add(query_564589, "api-version", newJString(apiVersion))
  add(path_564588, "subscriptionId", newJString(subscriptionId))
  add(path_564588, "databaseName", newJString(databaseName))
  add(path_564588, "resourceGroupName", newJString(resourceGroupName))
  add(path_564588, "accountName", newJString(accountName))
  result = call_564587.call(path_564588, query_564589, nil, nil, nil)

var databaseAccountsDeleteMongoDBCollection* = Call_DatabaseAccountsDeleteMongoDBCollection_564577(
    name: "databaseAccountsDeleteMongoDBCollection", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/collections/{collectionName}",
    validator: validate_DatabaseAccountsDeleteMongoDBCollection_564578, base: "",
    url: url_DatabaseAccountsDeleteMongoDBCollection_564579,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateMongoDBCollectionThroughput_564603 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsUpdateMongoDBCollectionThroughput_564605(
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
               (kind: ConstantSegment, value: "/apis/mongodb/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/collections/"),
               (kind: VariableSegment, value: "collectionName"),
               (kind: ConstantSegment, value: "/settings/throughput")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsUpdateMongoDBCollectionThroughput_564604(
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
  var valid_564606 = path.getOrDefault("collectionName")
  valid_564606 = validateParameter(valid_564606, JString, required = true,
                                 default = nil)
  if valid_564606 != nil:
    section.add "collectionName", valid_564606
  var valid_564607 = path.getOrDefault("subscriptionId")
  valid_564607 = validateParameter(valid_564607, JString, required = true,
                                 default = nil)
  if valid_564607 != nil:
    section.add "subscriptionId", valid_564607
  var valid_564608 = path.getOrDefault("databaseName")
  valid_564608 = validateParameter(valid_564608, JString, required = true,
                                 default = nil)
  if valid_564608 != nil:
    section.add "databaseName", valid_564608
  var valid_564609 = path.getOrDefault("resourceGroupName")
  valid_564609 = validateParameter(valid_564609, JString, required = true,
                                 default = nil)
  if valid_564609 != nil:
    section.add "resourceGroupName", valid_564609
  var valid_564610 = path.getOrDefault("accountName")
  valid_564610 = validateParameter(valid_564610, JString, required = true,
                                 default = nil)
  if valid_564610 != nil:
    section.add "accountName", valid_564610
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564611 = query.getOrDefault("api-version")
  valid_564611 = validateParameter(valid_564611, JString, required = true,
                                 default = nil)
  if valid_564611 != nil:
    section.add "api-version", valid_564611
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

proc call*(call_564613: Call_DatabaseAccountsUpdateMongoDBCollectionThroughput_564603;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the RUs per second of an Azure Cosmos DB MongoDB collection
  ## 
  let valid = call_564613.validator(path, query, header, formData, body)
  let scheme = call_564613.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564613.url(scheme.get, call_564613.host, call_564613.base,
                         call_564613.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564613, url, valid)

proc call*(call_564614: Call_DatabaseAccountsUpdateMongoDBCollectionThroughput_564603;
          collectionName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string; accountName: string;
          updateThroughputParameters: JsonNode): Recallable =
  ## databaseAccountsUpdateMongoDBCollectionThroughput
  ## Update the RUs per second of an Azure Cosmos DB MongoDB collection
  ##   collectionName: string (required)
  ##                 : Cosmos DB collection name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564615 = newJObject()
  var query_564616 = newJObject()
  var body_564617 = newJObject()
  add(path_564615, "collectionName", newJString(collectionName))
  add(query_564616, "api-version", newJString(apiVersion))
  add(path_564615, "subscriptionId", newJString(subscriptionId))
  add(path_564615, "databaseName", newJString(databaseName))
  add(path_564615, "resourceGroupName", newJString(resourceGroupName))
  add(path_564615, "accountName", newJString(accountName))
  if updateThroughputParameters != nil:
    body_564617 = updateThroughputParameters
  result = call_564614.call(path_564615, query_564616, nil, nil, body_564617)

var databaseAccountsUpdateMongoDBCollectionThroughput* = Call_DatabaseAccountsUpdateMongoDBCollectionThroughput_564603(
    name: "databaseAccountsUpdateMongoDBCollectionThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/collections/{collectionName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateMongoDBCollectionThroughput_564604,
    base: "", url: url_DatabaseAccountsUpdateMongoDBCollectionThroughput_564605,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetMongoDBCollectionThroughput_564590 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsGetMongoDBCollectionThroughput_564592(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/mongodb/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/collections/"),
               (kind: VariableSegment, value: "collectionName"),
               (kind: ConstantSegment, value: "/settings/throughput")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsGetMongoDBCollectionThroughput_564591(
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
  var valid_564593 = path.getOrDefault("collectionName")
  valid_564593 = validateParameter(valid_564593, JString, required = true,
                                 default = nil)
  if valid_564593 != nil:
    section.add "collectionName", valid_564593
  var valid_564594 = path.getOrDefault("subscriptionId")
  valid_564594 = validateParameter(valid_564594, JString, required = true,
                                 default = nil)
  if valid_564594 != nil:
    section.add "subscriptionId", valid_564594
  var valid_564595 = path.getOrDefault("databaseName")
  valid_564595 = validateParameter(valid_564595, JString, required = true,
                                 default = nil)
  if valid_564595 != nil:
    section.add "databaseName", valid_564595
  var valid_564596 = path.getOrDefault("resourceGroupName")
  valid_564596 = validateParameter(valid_564596, JString, required = true,
                                 default = nil)
  if valid_564596 != nil:
    section.add "resourceGroupName", valid_564596
  var valid_564597 = path.getOrDefault("accountName")
  valid_564597 = validateParameter(valid_564597, JString, required = true,
                                 default = nil)
  if valid_564597 != nil:
    section.add "accountName", valid_564597
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564598 = query.getOrDefault("api-version")
  valid_564598 = validateParameter(valid_564598, JString, required = true,
                                 default = nil)
  if valid_564598 != nil:
    section.add "api-version", valid_564598
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564599: Call_DatabaseAccountsGetMongoDBCollectionThroughput_564590;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the MongoDB collection under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_564599.validator(path, query, header, formData, body)
  let scheme = call_564599.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564599.url(scheme.get, call_564599.host, call_564599.base,
                         call_564599.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564599, url, valid)

proc call*(call_564600: Call_DatabaseAccountsGetMongoDBCollectionThroughput_564590;
          collectionName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsGetMongoDBCollectionThroughput
  ## Gets the RUs per second of the MongoDB collection under an existing Azure Cosmos DB database account with the provided name.
  ##   collectionName: string (required)
  ##                 : Cosmos DB collection name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564601 = newJObject()
  var query_564602 = newJObject()
  add(path_564601, "collectionName", newJString(collectionName))
  add(query_564602, "api-version", newJString(apiVersion))
  add(path_564601, "subscriptionId", newJString(subscriptionId))
  add(path_564601, "databaseName", newJString(databaseName))
  add(path_564601, "resourceGroupName", newJString(resourceGroupName))
  add(path_564601, "accountName", newJString(accountName))
  result = call_564600.call(path_564601, query_564602, nil, nil, nil)

var databaseAccountsGetMongoDBCollectionThroughput* = Call_DatabaseAccountsGetMongoDBCollectionThroughput_564590(
    name: "databaseAccountsGetMongoDBCollectionThroughput",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/collections/{collectionName}/settings/throughput",
    validator: validate_DatabaseAccountsGetMongoDBCollectionThroughput_564591,
    base: "", url: url_DatabaseAccountsGetMongoDBCollectionThroughput_564592,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateMongoDBDatabaseThroughput_564630 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsUpdateMongoDBDatabaseThroughput_564632(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/mongodb/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/settings/throughput")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsUpdateMongoDBDatabaseThroughput_564631(
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
  var valid_564633 = path.getOrDefault("subscriptionId")
  valid_564633 = validateParameter(valid_564633, JString, required = true,
                                 default = nil)
  if valid_564633 != nil:
    section.add "subscriptionId", valid_564633
  var valid_564634 = path.getOrDefault("databaseName")
  valid_564634 = validateParameter(valid_564634, JString, required = true,
                                 default = nil)
  if valid_564634 != nil:
    section.add "databaseName", valid_564634
  var valid_564635 = path.getOrDefault("resourceGroupName")
  valid_564635 = validateParameter(valid_564635, JString, required = true,
                                 default = nil)
  if valid_564635 != nil:
    section.add "resourceGroupName", valid_564635
  var valid_564636 = path.getOrDefault("accountName")
  valid_564636 = validateParameter(valid_564636, JString, required = true,
                                 default = nil)
  if valid_564636 != nil:
    section.add "accountName", valid_564636
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564637 = query.getOrDefault("api-version")
  valid_564637 = validateParameter(valid_564637, JString, required = true,
                                 default = nil)
  if valid_564637 != nil:
    section.add "api-version", valid_564637
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

proc call*(call_564639: Call_DatabaseAccountsUpdateMongoDBDatabaseThroughput_564630;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of the an Azure Cosmos DB MongoDB database
  ## 
  let valid = call_564639.validator(path, query, header, formData, body)
  let scheme = call_564639.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564639.url(scheme.get, call_564639.host, call_564639.base,
                         call_564639.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564639, url, valid)

proc call*(call_564640: Call_DatabaseAccountsUpdateMongoDBDatabaseThroughput_564630;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; accountName: string;
          updateThroughputParameters: JsonNode): Recallable =
  ## databaseAccountsUpdateMongoDBDatabaseThroughput
  ## Update RUs per second of the an Azure Cosmos DB MongoDB database
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564641 = newJObject()
  var query_564642 = newJObject()
  var body_564643 = newJObject()
  add(query_564642, "api-version", newJString(apiVersion))
  add(path_564641, "subscriptionId", newJString(subscriptionId))
  add(path_564641, "databaseName", newJString(databaseName))
  add(path_564641, "resourceGroupName", newJString(resourceGroupName))
  add(path_564641, "accountName", newJString(accountName))
  if updateThroughputParameters != nil:
    body_564643 = updateThroughputParameters
  result = call_564640.call(path_564641, query_564642, nil, nil, body_564643)

var databaseAccountsUpdateMongoDBDatabaseThroughput* = Call_DatabaseAccountsUpdateMongoDBDatabaseThroughput_564630(
    name: "databaseAccountsUpdateMongoDBDatabaseThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateMongoDBDatabaseThroughput_564631,
    base: "", url: url_DatabaseAccountsUpdateMongoDBDatabaseThroughput_564632,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetMongoDBDatabaseThroughput_564618 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsGetMongoDBDatabaseThroughput_564620(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/mongodb/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/settings/throughput")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsGetMongoDBDatabaseThroughput_564619(path: JsonNode;
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
  var valid_564621 = path.getOrDefault("subscriptionId")
  valid_564621 = validateParameter(valid_564621, JString, required = true,
                                 default = nil)
  if valid_564621 != nil:
    section.add "subscriptionId", valid_564621
  var valid_564622 = path.getOrDefault("databaseName")
  valid_564622 = validateParameter(valid_564622, JString, required = true,
                                 default = nil)
  if valid_564622 != nil:
    section.add "databaseName", valid_564622
  var valid_564623 = path.getOrDefault("resourceGroupName")
  valid_564623 = validateParameter(valid_564623, JString, required = true,
                                 default = nil)
  if valid_564623 != nil:
    section.add "resourceGroupName", valid_564623
  var valid_564624 = path.getOrDefault("accountName")
  valid_564624 = validateParameter(valid_564624, JString, required = true,
                                 default = nil)
  if valid_564624 != nil:
    section.add "accountName", valid_564624
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564625 = query.getOrDefault("api-version")
  valid_564625 = validateParameter(valid_564625, JString, required = true,
                                 default = nil)
  if valid_564625 != nil:
    section.add "api-version", valid_564625
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564626: Call_DatabaseAccountsGetMongoDBDatabaseThroughput_564618;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the MongoDB database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_564626.validator(path, query, header, formData, body)
  let scheme = call_564626.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564626.url(scheme.get, call_564626.host, call_564626.base,
                         call_564626.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564626, url, valid)

proc call*(call_564627: Call_DatabaseAccountsGetMongoDBDatabaseThroughput_564618;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsGetMongoDBDatabaseThroughput
  ## Gets the RUs per second of the MongoDB database under an existing Azure Cosmos DB database account with the provided name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564628 = newJObject()
  var query_564629 = newJObject()
  add(query_564629, "api-version", newJString(apiVersion))
  add(path_564628, "subscriptionId", newJString(subscriptionId))
  add(path_564628, "databaseName", newJString(databaseName))
  add(path_564628, "resourceGroupName", newJString(resourceGroupName))
  add(path_564628, "accountName", newJString(accountName))
  result = call_564627.call(path_564628, query_564629, nil, nil, nil)

var databaseAccountsGetMongoDBDatabaseThroughput* = Call_DatabaseAccountsGetMongoDBDatabaseThroughput_564618(
    name: "databaseAccountsGetMongoDBDatabaseThroughput",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/settings/throughput",
    validator: validate_DatabaseAccountsGetMongoDBDatabaseThroughput_564619,
    base: "", url: url_DatabaseAccountsGetMongoDBDatabaseThroughput_564620,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListSqlDatabases_564644 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsListSqlDatabases_564646(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/apis/sql/databases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsListSqlDatabases_564645(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_564647 = path.getOrDefault("subscriptionId")
  valid_564647 = validateParameter(valid_564647, JString, required = true,
                                 default = nil)
  if valid_564647 != nil:
    section.add "subscriptionId", valid_564647
  var valid_564648 = path.getOrDefault("resourceGroupName")
  valid_564648 = validateParameter(valid_564648, JString, required = true,
                                 default = nil)
  if valid_564648 != nil:
    section.add "resourceGroupName", valid_564648
  var valid_564649 = path.getOrDefault("accountName")
  valid_564649 = validateParameter(valid_564649, JString, required = true,
                                 default = nil)
  if valid_564649 != nil:
    section.add "accountName", valid_564649
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564650 = query.getOrDefault("api-version")
  valid_564650 = validateParameter(valid_564650, JString, required = true,
                                 default = nil)
  if valid_564650 != nil:
    section.add "api-version", valid_564650
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564651: Call_DatabaseAccountsListSqlDatabases_564644;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the SQL databases under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_564651.validator(path, query, header, formData, body)
  let scheme = call_564651.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564651.url(scheme.get, call_564651.host, call_564651.base,
                         call_564651.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564651, url, valid)

proc call*(call_564652: Call_DatabaseAccountsListSqlDatabases_564644;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## databaseAccountsListSqlDatabases
  ## Lists the SQL databases under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564653 = newJObject()
  var query_564654 = newJObject()
  add(query_564654, "api-version", newJString(apiVersion))
  add(path_564653, "subscriptionId", newJString(subscriptionId))
  add(path_564653, "resourceGroupName", newJString(resourceGroupName))
  add(path_564653, "accountName", newJString(accountName))
  result = call_564652.call(path_564653, query_564654, nil, nil, nil)

var databaseAccountsListSqlDatabases* = Call_DatabaseAccountsListSqlDatabases_564644(
    name: "databaseAccountsListSqlDatabases", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases",
    validator: validate_DatabaseAccountsListSqlDatabases_564645, base: "",
    url: url_DatabaseAccountsListSqlDatabases_564646, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateSqlDatabase_564667 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsCreateUpdateSqlDatabase_564669(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/sql/databases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsCreateUpdateSqlDatabase_564668(path: JsonNode;
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
  var valid_564670 = path.getOrDefault("subscriptionId")
  valid_564670 = validateParameter(valid_564670, JString, required = true,
                                 default = nil)
  if valid_564670 != nil:
    section.add "subscriptionId", valid_564670
  var valid_564671 = path.getOrDefault("databaseName")
  valid_564671 = validateParameter(valid_564671, JString, required = true,
                                 default = nil)
  if valid_564671 != nil:
    section.add "databaseName", valid_564671
  var valid_564672 = path.getOrDefault("resourceGroupName")
  valid_564672 = validateParameter(valid_564672, JString, required = true,
                                 default = nil)
  if valid_564672 != nil:
    section.add "resourceGroupName", valid_564672
  var valid_564673 = path.getOrDefault("accountName")
  valid_564673 = validateParameter(valid_564673, JString, required = true,
                                 default = nil)
  if valid_564673 != nil:
    section.add "accountName", valid_564673
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564674 = query.getOrDefault("api-version")
  valid_564674 = validateParameter(valid_564674, JString, required = true,
                                 default = nil)
  if valid_564674 != nil:
    section.add "api-version", valid_564674
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

proc call*(call_564676: Call_DatabaseAccountsCreateUpdateSqlDatabase_564667;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB SQL database
  ## 
  let valid = call_564676.validator(path, query, header, formData, body)
  let scheme = call_564676.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564676.url(scheme.get, call_564676.host, call_564676.base,
                         call_564676.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564676, url, valid)

proc call*(call_564677: Call_DatabaseAccountsCreateUpdateSqlDatabase_564667;
          apiVersion: string; subscriptionId: string; databaseName: string;
          createUpdateSqlDatabaseParameters: JsonNode; resourceGroupName: string;
          accountName: string): Recallable =
  ## databaseAccountsCreateUpdateSqlDatabase
  ## Create or update an Azure Cosmos DB SQL database
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564678 = newJObject()
  var query_564679 = newJObject()
  var body_564680 = newJObject()
  add(query_564679, "api-version", newJString(apiVersion))
  add(path_564678, "subscriptionId", newJString(subscriptionId))
  add(path_564678, "databaseName", newJString(databaseName))
  if createUpdateSqlDatabaseParameters != nil:
    body_564680 = createUpdateSqlDatabaseParameters
  add(path_564678, "resourceGroupName", newJString(resourceGroupName))
  add(path_564678, "accountName", newJString(accountName))
  result = call_564677.call(path_564678, query_564679, nil, nil, body_564680)

var databaseAccountsCreateUpdateSqlDatabase* = Call_DatabaseAccountsCreateUpdateSqlDatabase_564667(
    name: "databaseAccountsCreateUpdateSqlDatabase", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}",
    validator: validate_DatabaseAccountsCreateUpdateSqlDatabase_564668, base: "",
    url: url_DatabaseAccountsCreateUpdateSqlDatabase_564669,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetSqlDatabase_564655 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsGetSqlDatabase_564657(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/apis/sql/databases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsGetSqlDatabase_564656(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_564658 = path.getOrDefault("subscriptionId")
  valid_564658 = validateParameter(valid_564658, JString, required = true,
                                 default = nil)
  if valid_564658 != nil:
    section.add "subscriptionId", valid_564658
  var valid_564659 = path.getOrDefault("databaseName")
  valid_564659 = validateParameter(valid_564659, JString, required = true,
                                 default = nil)
  if valid_564659 != nil:
    section.add "databaseName", valid_564659
  var valid_564660 = path.getOrDefault("resourceGroupName")
  valid_564660 = validateParameter(valid_564660, JString, required = true,
                                 default = nil)
  if valid_564660 != nil:
    section.add "resourceGroupName", valid_564660
  var valid_564661 = path.getOrDefault("accountName")
  valid_564661 = validateParameter(valid_564661, JString, required = true,
                                 default = nil)
  if valid_564661 != nil:
    section.add "accountName", valid_564661
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564662 = query.getOrDefault("api-version")
  valid_564662 = validateParameter(valid_564662, JString, required = true,
                                 default = nil)
  if valid_564662 != nil:
    section.add "api-version", valid_564662
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564663: Call_DatabaseAccountsGetSqlDatabase_564655; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the SQL database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_564663.validator(path, query, header, formData, body)
  let scheme = call_564663.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564663.url(scheme.get, call_564663.host, call_564663.base,
                         call_564663.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564663, url, valid)

proc call*(call_564664: Call_DatabaseAccountsGetSqlDatabase_564655;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsGetSqlDatabase
  ## Gets the SQL database under an existing Azure Cosmos DB database account with the provided name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564665 = newJObject()
  var query_564666 = newJObject()
  add(query_564666, "api-version", newJString(apiVersion))
  add(path_564665, "subscriptionId", newJString(subscriptionId))
  add(path_564665, "databaseName", newJString(databaseName))
  add(path_564665, "resourceGroupName", newJString(resourceGroupName))
  add(path_564665, "accountName", newJString(accountName))
  result = call_564664.call(path_564665, query_564666, nil, nil, nil)

var databaseAccountsGetSqlDatabase* = Call_DatabaseAccountsGetSqlDatabase_564655(
    name: "databaseAccountsGetSqlDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}",
    validator: validate_DatabaseAccountsGetSqlDatabase_564656, base: "",
    url: url_DatabaseAccountsGetSqlDatabase_564657, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteSqlDatabase_564681 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsDeleteSqlDatabase_564683(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/apis/sql/databases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsDeleteSqlDatabase_564682(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_564684 = path.getOrDefault("subscriptionId")
  valid_564684 = validateParameter(valid_564684, JString, required = true,
                                 default = nil)
  if valid_564684 != nil:
    section.add "subscriptionId", valid_564684
  var valid_564685 = path.getOrDefault("databaseName")
  valid_564685 = validateParameter(valid_564685, JString, required = true,
                                 default = nil)
  if valid_564685 != nil:
    section.add "databaseName", valid_564685
  var valid_564686 = path.getOrDefault("resourceGroupName")
  valid_564686 = validateParameter(valid_564686, JString, required = true,
                                 default = nil)
  if valid_564686 != nil:
    section.add "resourceGroupName", valid_564686
  var valid_564687 = path.getOrDefault("accountName")
  valid_564687 = validateParameter(valid_564687, JString, required = true,
                                 default = nil)
  if valid_564687 != nil:
    section.add "accountName", valid_564687
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564688 = query.getOrDefault("api-version")
  valid_564688 = validateParameter(valid_564688, JString, required = true,
                                 default = nil)
  if valid_564688 != nil:
    section.add "api-version", valid_564688
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564689: Call_DatabaseAccountsDeleteSqlDatabase_564681;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB SQL database.
  ## 
  let valid = call_564689.validator(path, query, header, formData, body)
  let scheme = call_564689.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564689.url(scheme.get, call_564689.host, call_564689.base,
                         call_564689.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564689, url, valid)

proc call*(call_564690: Call_DatabaseAccountsDeleteSqlDatabase_564681;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsDeleteSqlDatabase
  ## Deletes an existing Azure Cosmos DB SQL database.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564691 = newJObject()
  var query_564692 = newJObject()
  add(query_564692, "api-version", newJString(apiVersion))
  add(path_564691, "subscriptionId", newJString(subscriptionId))
  add(path_564691, "databaseName", newJString(databaseName))
  add(path_564691, "resourceGroupName", newJString(resourceGroupName))
  add(path_564691, "accountName", newJString(accountName))
  result = call_564690.call(path_564691, query_564692, nil, nil, nil)

var databaseAccountsDeleteSqlDatabase* = Call_DatabaseAccountsDeleteSqlDatabase_564681(
    name: "databaseAccountsDeleteSqlDatabase", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}",
    validator: validate_DatabaseAccountsDeleteSqlDatabase_564682, base: "",
    url: url_DatabaseAccountsDeleteSqlDatabase_564683, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListSqlContainers_564693 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsListSqlContainers_564695(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/apis/sql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/containers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsListSqlContainers_564694(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_564696 = path.getOrDefault("subscriptionId")
  valid_564696 = validateParameter(valid_564696, JString, required = true,
                                 default = nil)
  if valid_564696 != nil:
    section.add "subscriptionId", valid_564696
  var valid_564697 = path.getOrDefault("databaseName")
  valid_564697 = validateParameter(valid_564697, JString, required = true,
                                 default = nil)
  if valid_564697 != nil:
    section.add "databaseName", valid_564697
  var valid_564698 = path.getOrDefault("resourceGroupName")
  valid_564698 = validateParameter(valid_564698, JString, required = true,
                                 default = nil)
  if valid_564698 != nil:
    section.add "resourceGroupName", valid_564698
  var valid_564699 = path.getOrDefault("accountName")
  valid_564699 = validateParameter(valid_564699, JString, required = true,
                                 default = nil)
  if valid_564699 != nil:
    section.add "accountName", valid_564699
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564700 = query.getOrDefault("api-version")
  valid_564700 = validateParameter(valid_564700, JString, required = true,
                                 default = nil)
  if valid_564700 != nil:
    section.add "api-version", valid_564700
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564701: Call_DatabaseAccountsListSqlContainers_564693;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the SQL container under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_564701.validator(path, query, header, formData, body)
  let scheme = call_564701.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564701.url(scheme.get, call_564701.host, call_564701.base,
                         call_564701.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564701, url, valid)

proc call*(call_564702: Call_DatabaseAccountsListSqlContainers_564693;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsListSqlContainers
  ## Lists the SQL container under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564703 = newJObject()
  var query_564704 = newJObject()
  add(query_564704, "api-version", newJString(apiVersion))
  add(path_564703, "subscriptionId", newJString(subscriptionId))
  add(path_564703, "databaseName", newJString(databaseName))
  add(path_564703, "resourceGroupName", newJString(resourceGroupName))
  add(path_564703, "accountName", newJString(accountName))
  result = call_564702.call(path_564703, query_564704, nil, nil, nil)

var databaseAccountsListSqlContainers* = Call_DatabaseAccountsListSqlContainers_564693(
    name: "databaseAccountsListSqlContainers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/containers",
    validator: validate_DatabaseAccountsListSqlContainers_564694, base: "",
    url: url_DatabaseAccountsListSqlContainers_564695, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateSqlContainer_564718 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsCreateUpdateSqlContainer_564720(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/sql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsCreateUpdateSqlContainer_564719(path: JsonNode;
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
  var valid_564721 = path.getOrDefault("subscriptionId")
  valid_564721 = validateParameter(valid_564721, JString, required = true,
                                 default = nil)
  if valid_564721 != nil:
    section.add "subscriptionId", valid_564721
  var valid_564722 = path.getOrDefault("databaseName")
  valid_564722 = validateParameter(valid_564722, JString, required = true,
                                 default = nil)
  if valid_564722 != nil:
    section.add "databaseName", valid_564722
  var valid_564723 = path.getOrDefault("resourceGroupName")
  valid_564723 = validateParameter(valid_564723, JString, required = true,
                                 default = nil)
  if valid_564723 != nil:
    section.add "resourceGroupName", valid_564723
  var valid_564724 = path.getOrDefault("containerName")
  valid_564724 = validateParameter(valid_564724, JString, required = true,
                                 default = nil)
  if valid_564724 != nil:
    section.add "containerName", valid_564724
  var valid_564725 = path.getOrDefault("accountName")
  valid_564725 = validateParameter(valid_564725, JString, required = true,
                                 default = nil)
  if valid_564725 != nil:
    section.add "accountName", valid_564725
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564726 = query.getOrDefault("api-version")
  valid_564726 = validateParameter(valid_564726, JString, required = true,
                                 default = nil)
  if valid_564726 != nil:
    section.add "api-version", valid_564726
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

proc call*(call_564728: Call_DatabaseAccountsCreateUpdateSqlContainer_564718;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB SQL container
  ## 
  let valid = call_564728.validator(path, query, header, formData, body)
  let scheme = call_564728.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564728.url(scheme.get, call_564728.host, call_564728.base,
                         call_564728.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564728, url, valid)

proc call*(call_564729: Call_DatabaseAccountsCreateUpdateSqlContainer_564718;
          apiVersion: string; subscriptionId: string;
          createUpdateSqlContainerParameters: JsonNode; databaseName: string;
          resourceGroupName: string; containerName: string; accountName: string): Recallable =
  ## databaseAccountsCreateUpdateSqlContainer
  ## Create or update an Azure Cosmos DB SQL container
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564730 = newJObject()
  var query_564731 = newJObject()
  var body_564732 = newJObject()
  add(query_564731, "api-version", newJString(apiVersion))
  add(path_564730, "subscriptionId", newJString(subscriptionId))
  if createUpdateSqlContainerParameters != nil:
    body_564732 = createUpdateSqlContainerParameters
  add(path_564730, "databaseName", newJString(databaseName))
  add(path_564730, "resourceGroupName", newJString(resourceGroupName))
  add(path_564730, "containerName", newJString(containerName))
  add(path_564730, "accountName", newJString(accountName))
  result = call_564729.call(path_564730, query_564731, nil, nil, body_564732)

var databaseAccountsCreateUpdateSqlContainer* = Call_DatabaseAccountsCreateUpdateSqlContainer_564718(
    name: "databaseAccountsCreateUpdateSqlContainer", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/containers/{containerName}",
    validator: validate_DatabaseAccountsCreateUpdateSqlContainer_564719, base: "",
    url: url_DatabaseAccountsCreateUpdateSqlContainer_564720,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetSqlContainer_564705 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsGetSqlContainer_564707(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/apis/sql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsGetSqlContainer_564706(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_564708 = path.getOrDefault("subscriptionId")
  valid_564708 = validateParameter(valid_564708, JString, required = true,
                                 default = nil)
  if valid_564708 != nil:
    section.add "subscriptionId", valid_564708
  var valid_564709 = path.getOrDefault("databaseName")
  valid_564709 = validateParameter(valid_564709, JString, required = true,
                                 default = nil)
  if valid_564709 != nil:
    section.add "databaseName", valid_564709
  var valid_564710 = path.getOrDefault("resourceGroupName")
  valid_564710 = validateParameter(valid_564710, JString, required = true,
                                 default = nil)
  if valid_564710 != nil:
    section.add "resourceGroupName", valid_564710
  var valid_564711 = path.getOrDefault("containerName")
  valid_564711 = validateParameter(valid_564711, JString, required = true,
                                 default = nil)
  if valid_564711 != nil:
    section.add "containerName", valid_564711
  var valid_564712 = path.getOrDefault("accountName")
  valid_564712 = validateParameter(valid_564712, JString, required = true,
                                 default = nil)
  if valid_564712 != nil:
    section.add "accountName", valid_564712
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564713 = query.getOrDefault("api-version")
  valid_564713 = validateParameter(valid_564713, JString, required = true,
                                 default = nil)
  if valid_564713 != nil:
    section.add "api-version", valid_564713
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564714: Call_DatabaseAccountsGetSqlContainer_564705;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the SQL container under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_564714.validator(path, query, header, formData, body)
  let scheme = call_564714.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564714.url(scheme.get, call_564714.host, call_564714.base,
                         call_564714.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564714, url, valid)

proc call*(call_564715: Call_DatabaseAccountsGetSqlContainer_564705;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; containerName: string; accountName: string): Recallable =
  ## databaseAccountsGetSqlContainer
  ## Gets the SQL container under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564716 = newJObject()
  var query_564717 = newJObject()
  add(query_564717, "api-version", newJString(apiVersion))
  add(path_564716, "subscriptionId", newJString(subscriptionId))
  add(path_564716, "databaseName", newJString(databaseName))
  add(path_564716, "resourceGroupName", newJString(resourceGroupName))
  add(path_564716, "containerName", newJString(containerName))
  add(path_564716, "accountName", newJString(accountName))
  result = call_564715.call(path_564716, query_564717, nil, nil, nil)

var databaseAccountsGetSqlContainer* = Call_DatabaseAccountsGetSqlContainer_564705(
    name: "databaseAccountsGetSqlContainer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/containers/{containerName}",
    validator: validate_DatabaseAccountsGetSqlContainer_564706, base: "",
    url: url_DatabaseAccountsGetSqlContainer_564707, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteSqlContainer_564733 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsDeleteSqlContainer_564735(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/apis/sql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsDeleteSqlContainer_564734(path: JsonNode;
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
  var valid_564736 = path.getOrDefault("subscriptionId")
  valid_564736 = validateParameter(valid_564736, JString, required = true,
                                 default = nil)
  if valid_564736 != nil:
    section.add "subscriptionId", valid_564736
  var valid_564737 = path.getOrDefault("databaseName")
  valid_564737 = validateParameter(valid_564737, JString, required = true,
                                 default = nil)
  if valid_564737 != nil:
    section.add "databaseName", valid_564737
  var valid_564738 = path.getOrDefault("resourceGroupName")
  valid_564738 = validateParameter(valid_564738, JString, required = true,
                                 default = nil)
  if valid_564738 != nil:
    section.add "resourceGroupName", valid_564738
  var valid_564739 = path.getOrDefault("containerName")
  valid_564739 = validateParameter(valid_564739, JString, required = true,
                                 default = nil)
  if valid_564739 != nil:
    section.add "containerName", valid_564739
  var valid_564740 = path.getOrDefault("accountName")
  valid_564740 = validateParameter(valid_564740, JString, required = true,
                                 default = nil)
  if valid_564740 != nil:
    section.add "accountName", valid_564740
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564741 = query.getOrDefault("api-version")
  valid_564741 = validateParameter(valid_564741, JString, required = true,
                                 default = nil)
  if valid_564741 != nil:
    section.add "api-version", valid_564741
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564742: Call_DatabaseAccountsDeleteSqlContainer_564733;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB SQL container.
  ## 
  let valid = call_564742.validator(path, query, header, formData, body)
  let scheme = call_564742.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564742.url(scheme.get, call_564742.host, call_564742.base,
                         call_564742.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564742, url, valid)

proc call*(call_564743: Call_DatabaseAccountsDeleteSqlContainer_564733;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; containerName: string; accountName: string): Recallable =
  ## databaseAccountsDeleteSqlContainer
  ## Deletes an existing Azure Cosmos DB SQL container.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564744 = newJObject()
  var query_564745 = newJObject()
  add(query_564745, "api-version", newJString(apiVersion))
  add(path_564744, "subscriptionId", newJString(subscriptionId))
  add(path_564744, "databaseName", newJString(databaseName))
  add(path_564744, "resourceGroupName", newJString(resourceGroupName))
  add(path_564744, "containerName", newJString(containerName))
  add(path_564744, "accountName", newJString(accountName))
  result = call_564743.call(path_564744, query_564745, nil, nil, nil)

var databaseAccountsDeleteSqlContainer* = Call_DatabaseAccountsDeleteSqlContainer_564733(
    name: "databaseAccountsDeleteSqlContainer", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/containers/{containerName}",
    validator: validate_DatabaseAccountsDeleteSqlContainer_564734, base: "",
    url: url_DatabaseAccountsDeleteSqlContainer_564735, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateSqlContainerThroughput_564759 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsUpdateSqlContainerThroughput_564761(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/sql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/settings/throughput")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsUpdateSqlContainerThroughput_564760(path: JsonNode;
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
  var valid_564762 = path.getOrDefault("subscriptionId")
  valid_564762 = validateParameter(valid_564762, JString, required = true,
                                 default = nil)
  if valid_564762 != nil:
    section.add "subscriptionId", valid_564762
  var valid_564763 = path.getOrDefault("databaseName")
  valid_564763 = validateParameter(valid_564763, JString, required = true,
                                 default = nil)
  if valid_564763 != nil:
    section.add "databaseName", valid_564763
  var valid_564764 = path.getOrDefault("resourceGroupName")
  valid_564764 = validateParameter(valid_564764, JString, required = true,
                                 default = nil)
  if valid_564764 != nil:
    section.add "resourceGroupName", valid_564764
  var valid_564765 = path.getOrDefault("containerName")
  valid_564765 = validateParameter(valid_564765, JString, required = true,
                                 default = nil)
  if valid_564765 != nil:
    section.add "containerName", valid_564765
  var valid_564766 = path.getOrDefault("accountName")
  valid_564766 = validateParameter(valid_564766, JString, required = true,
                                 default = nil)
  if valid_564766 != nil:
    section.add "accountName", valid_564766
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564767 = query.getOrDefault("api-version")
  valid_564767 = validateParameter(valid_564767, JString, required = true,
                                 default = nil)
  if valid_564767 != nil:
    section.add "api-version", valid_564767
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

proc call*(call_564769: Call_DatabaseAccountsUpdateSqlContainerThroughput_564759;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB SQL container
  ## 
  let valid = call_564769.validator(path, query, header, formData, body)
  let scheme = call_564769.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564769.url(scheme.get, call_564769.host, call_564769.base,
                         call_564769.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564769, url, valid)

proc call*(call_564770: Call_DatabaseAccountsUpdateSqlContainerThroughput_564759;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; containerName: string; accountName: string;
          updateThroughputParameters: JsonNode): Recallable =
  ## databaseAccountsUpdateSqlContainerThroughput
  ## Update RUs per second of an Azure Cosmos DB SQL container
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564771 = newJObject()
  var query_564772 = newJObject()
  var body_564773 = newJObject()
  add(query_564772, "api-version", newJString(apiVersion))
  add(path_564771, "subscriptionId", newJString(subscriptionId))
  add(path_564771, "databaseName", newJString(databaseName))
  add(path_564771, "resourceGroupName", newJString(resourceGroupName))
  add(path_564771, "containerName", newJString(containerName))
  add(path_564771, "accountName", newJString(accountName))
  if updateThroughputParameters != nil:
    body_564773 = updateThroughputParameters
  result = call_564770.call(path_564771, query_564772, nil, nil, body_564773)

var databaseAccountsUpdateSqlContainerThroughput* = Call_DatabaseAccountsUpdateSqlContainerThroughput_564759(
    name: "databaseAccountsUpdateSqlContainerThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/containers/{containerName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateSqlContainerThroughput_564760,
    base: "", url: url_DatabaseAccountsUpdateSqlContainerThroughput_564761,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetSqlContainerThroughput_564746 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsGetSqlContainerThroughput_564748(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/sql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/containers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/settings/throughput")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsGetSqlContainerThroughput_564747(path: JsonNode;
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
  var valid_564749 = path.getOrDefault("subscriptionId")
  valid_564749 = validateParameter(valid_564749, JString, required = true,
                                 default = nil)
  if valid_564749 != nil:
    section.add "subscriptionId", valid_564749
  var valid_564750 = path.getOrDefault("databaseName")
  valid_564750 = validateParameter(valid_564750, JString, required = true,
                                 default = nil)
  if valid_564750 != nil:
    section.add "databaseName", valid_564750
  var valid_564751 = path.getOrDefault("resourceGroupName")
  valid_564751 = validateParameter(valid_564751, JString, required = true,
                                 default = nil)
  if valid_564751 != nil:
    section.add "resourceGroupName", valid_564751
  var valid_564752 = path.getOrDefault("containerName")
  valid_564752 = validateParameter(valid_564752, JString, required = true,
                                 default = nil)
  if valid_564752 != nil:
    section.add "containerName", valid_564752
  var valid_564753 = path.getOrDefault("accountName")
  valid_564753 = validateParameter(valid_564753, JString, required = true,
                                 default = nil)
  if valid_564753 != nil:
    section.add "accountName", valid_564753
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564754 = query.getOrDefault("api-version")
  valid_564754 = validateParameter(valid_564754, JString, required = true,
                                 default = nil)
  if valid_564754 != nil:
    section.add "api-version", valid_564754
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564755: Call_DatabaseAccountsGetSqlContainerThroughput_564746;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the SQL container under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_564755.validator(path, query, header, formData, body)
  let scheme = call_564755.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564755.url(scheme.get, call_564755.host, call_564755.base,
                         call_564755.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564755, url, valid)

proc call*(call_564756: Call_DatabaseAccountsGetSqlContainerThroughput_564746;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; containerName: string; accountName: string): Recallable =
  ## databaseAccountsGetSqlContainerThroughput
  ## Gets the RUs per second of the SQL container under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564757 = newJObject()
  var query_564758 = newJObject()
  add(query_564758, "api-version", newJString(apiVersion))
  add(path_564757, "subscriptionId", newJString(subscriptionId))
  add(path_564757, "databaseName", newJString(databaseName))
  add(path_564757, "resourceGroupName", newJString(resourceGroupName))
  add(path_564757, "containerName", newJString(containerName))
  add(path_564757, "accountName", newJString(accountName))
  result = call_564756.call(path_564757, query_564758, nil, nil, nil)

var databaseAccountsGetSqlContainerThroughput* = Call_DatabaseAccountsGetSqlContainerThroughput_564746(
    name: "databaseAccountsGetSqlContainerThroughput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/containers/{containerName}/settings/throughput",
    validator: validate_DatabaseAccountsGetSqlContainerThroughput_564747,
    base: "", url: url_DatabaseAccountsGetSqlContainerThroughput_564748,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateSqlDatabaseThroughput_564786 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsUpdateSqlDatabaseThroughput_564788(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/sql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/settings/throughput")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsUpdateSqlDatabaseThroughput_564787(path: JsonNode;
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
  var valid_564789 = path.getOrDefault("subscriptionId")
  valid_564789 = validateParameter(valid_564789, JString, required = true,
                                 default = nil)
  if valid_564789 != nil:
    section.add "subscriptionId", valid_564789
  var valid_564790 = path.getOrDefault("databaseName")
  valid_564790 = validateParameter(valid_564790, JString, required = true,
                                 default = nil)
  if valid_564790 != nil:
    section.add "databaseName", valid_564790
  var valid_564791 = path.getOrDefault("resourceGroupName")
  valid_564791 = validateParameter(valid_564791, JString, required = true,
                                 default = nil)
  if valid_564791 != nil:
    section.add "resourceGroupName", valid_564791
  var valid_564792 = path.getOrDefault("accountName")
  valid_564792 = validateParameter(valid_564792, JString, required = true,
                                 default = nil)
  if valid_564792 != nil:
    section.add "accountName", valid_564792
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564793 = query.getOrDefault("api-version")
  valid_564793 = validateParameter(valid_564793, JString, required = true,
                                 default = nil)
  if valid_564793 != nil:
    section.add "api-version", valid_564793
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

proc call*(call_564795: Call_DatabaseAccountsUpdateSqlDatabaseThroughput_564786;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB SQL database
  ## 
  let valid = call_564795.validator(path, query, header, formData, body)
  let scheme = call_564795.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564795.url(scheme.get, call_564795.host, call_564795.base,
                         call_564795.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564795, url, valid)

proc call*(call_564796: Call_DatabaseAccountsUpdateSqlDatabaseThroughput_564786;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; accountName: string;
          updateThroughputParameters: JsonNode): Recallable =
  ## databaseAccountsUpdateSqlDatabaseThroughput
  ## Update RUs per second of an Azure Cosmos DB SQL database
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564797 = newJObject()
  var query_564798 = newJObject()
  var body_564799 = newJObject()
  add(query_564798, "api-version", newJString(apiVersion))
  add(path_564797, "subscriptionId", newJString(subscriptionId))
  add(path_564797, "databaseName", newJString(databaseName))
  add(path_564797, "resourceGroupName", newJString(resourceGroupName))
  add(path_564797, "accountName", newJString(accountName))
  if updateThroughputParameters != nil:
    body_564799 = updateThroughputParameters
  result = call_564796.call(path_564797, query_564798, nil, nil, body_564799)

var databaseAccountsUpdateSqlDatabaseThroughput* = Call_DatabaseAccountsUpdateSqlDatabaseThroughput_564786(
    name: "databaseAccountsUpdateSqlDatabaseThroughput", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateSqlDatabaseThroughput_564787,
    base: "", url: url_DatabaseAccountsUpdateSqlDatabaseThroughput_564788,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetSqlDatabaseThroughput_564774 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsGetSqlDatabaseThroughput_564776(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/apis/sql/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/settings/throughput")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsGetSqlDatabaseThroughput_564775(path: JsonNode;
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
  var valid_564777 = path.getOrDefault("subscriptionId")
  valid_564777 = validateParameter(valid_564777, JString, required = true,
                                 default = nil)
  if valid_564777 != nil:
    section.add "subscriptionId", valid_564777
  var valid_564778 = path.getOrDefault("databaseName")
  valid_564778 = validateParameter(valid_564778, JString, required = true,
                                 default = nil)
  if valid_564778 != nil:
    section.add "databaseName", valid_564778
  var valid_564779 = path.getOrDefault("resourceGroupName")
  valid_564779 = validateParameter(valid_564779, JString, required = true,
                                 default = nil)
  if valid_564779 != nil:
    section.add "resourceGroupName", valid_564779
  var valid_564780 = path.getOrDefault("accountName")
  valid_564780 = validateParameter(valid_564780, JString, required = true,
                                 default = nil)
  if valid_564780 != nil:
    section.add "accountName", valid_564780
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564781 = query.getOrDefault("api-version")
  valid_564781 = validateParameter(valid_564781, JString, required = true,
                                 default = nil)
  if valid_564781 != nil:
    section.add "api-version", valid_564781
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564782: Call_DatabaseAccountsGetSqlDatabaseThroughput_564774;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the SQL database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_564782.validator(path, query, header, formData, body)
  let scheme = call_564782.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564782.url(scheme.get, call_564782.host, call_564782.base,
                         call_564782.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564782, url, valid)

proc call*(call_564783: Call_DatabaseAccountsGetSqlDatabaseThroughput_564774;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsGetSqlDatabaseThroughput
  ## Gets the RUs per second of the SQL database under an existing Azure Cosmos DB database account with the provided name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564784 = newJObject()
  var query_564785 = newJObject()
  add(query_564785, "api-version", newJString(apiVersion))
  add(path_564784, "subscriptionId", newJString(subscriptionId))
  add(path_564784, "databaseName", newJString(databaseName))
  add(path_564784, "resourceGroupName", newJString(resourceGroupName))
  add(path_564784, "accountName", newJString(accountName))
  result = call_564783.call(path_564784, query_564785, nil, nil, nil)

var databaseAccountsGetSqlDatabaseThroughput* = Call_DatabaseAccountsGetSqlDatabaseThroughput_564774(
    name: "databaseAccountsGetSqlDatabaseThroughput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/settings/throughput",
    validator: validate_DatabaseAccountsGetSqlDatabaseThroughput_564775, base: "",
    url: url_DatabaseAccountsGetSqlDatabaseThroughput_564776,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListTables_564800 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsListTables_564802(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/apis/table/tables")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsListTables_564801(path: JsonNode; query: JsonNode;
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
  var valid_564803 = path.getOrDefault("subscriptionId")
  valid_564803 = validateParameter(valid_564803, JString, required = true,
                                 default = nil)
  if valid_564803 != nil:
    section.add "subscriptionId", valid_564803
  var valid_564804 = path.getOrDefault("resourceGroupName")
  valid_564804 = validateParameter(valid_564804, JString, required = true,
                                 default = nil)
  if valid_564804 != nil:
    section.add "resourceGroupName", valid_564804
  var valid_564805 = path.getOrDefault("accountName")
  valid_564805 = validateParameter(valid_564805, JString, required = true,
                                 default = nil)
  if valid_564805 != nil:
    section.add "accountName", valid_564805
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564806 = query.getOrDefault("api-version")
  valid_564806 = validateParameter(valid_564806, JString, required = true,
                                 default = nil)
  if valid_564806 != nil:
    section.add "api-version", valid_564806
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564807: Call_DatabaseAccountsListTables_564800; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Tables under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_564807.validator(path, query, header, formData, body)
  let scheme = call_564807.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564807.url(scheme.get, call_564807.host, call_564807.base,
                         call_564807.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564807, url, valid)

proc call*(call_564808: Call_DatabaseAccountsListTables_564800; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsListTables
  ## Lists the Tables under an existing Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564809 = newJObject()
  var query_564810 = newJObject()
  add(query_564810, "api-version", newJString(apiVersion))
  add(path_564809, "subscriptionId", newJString(subscriptionId))
  add(path_564809, "resourceGroupName", newJString(resourceGroupName))
  add(path_564809, "accountName", newJString(accountName))
  result = call_564808.call(path_564809, query_564810, nil, nil, nil)

var databaseAccountsListTables* = Call_DatabaseAccountsListTables_564800(
    name: "databaseAccountsListTables", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/table/tables",
    validator: validate_DatabaseAccountsListTables_564801, base: "",
    url: url_DatabaseAccountsListTables_564802, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateTable_564823 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsCreateUpdateTable_564825(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/apis/table/tables/"),
               (kind: VariableSegment, value: "tableName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsCreateUpdateTable_564824(path: JsonNode;
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
  var valid_564826 = path.getOrDefault("subscriptionId")
  valid_564826 = validateParameter(valid_564826, JString, required = true,
                                 default = nil)
  if valid_564826 != nil:
    section.add "subscriptionId", valid_564826
  var valid_564827 = path.getOrDefault("resourceGroupName")
  valid_564827 = validateParameter(valid_564827, JString, required = true,
                                 default = nil)
  if valid_564827 != nil:
    section.add "resourceGroupName", valid_564827
  var valid_564828 = path.getOrDefault("tableName")
  valid_564828 = validateParameter(valid_564828, JString, required = true,
                                 default = nil)
  if valid_564828 != nil:
    section.add "tableName", valid_564828
  var valid_564829 = path.getOrDefault("accountName")
  valid_564829 = validateParameter(valid_564829, JString, required = true,
                                 default = nil)
  if valid_564829 != nil:
    section.add "accountName", valid_564829
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564830 = query.getOrDefault("api-version")
  valid_564830 = validateParameter(valid_564830, JString, required = true,
                                 default = nil)
  if valid_564830 != nil:
    section.add "api-version", valid_564830
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

proc call*(call_564832: Call_DatabaseAccountsCreateUpdateTable_564823;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB Table
  ## 
  let valid = call_564832.validator(path, query, header, formData, body)
  let scheme = call_564832.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564832.url(scheme.get, call_564832.host, call_564832.base,
                         call_564832.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564832, url, valid)

proc call*(call_564833: Call_DatabaseAccountsCreateUpdateTable_564823;
          apiVersion: string; subscriptionId: string;
          createUpdateTableParameters: JsonNode; resourceGroupName: string;
          tableName: string; accountName: string): Recallable =
  ## databaseAccountsCreateUpdateTable
  ## Create or update an Azure Cosmos DB Table
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564834 = newJObject()
  var query_564835 = newJObject()
  var body_564836 = newJObject()
  add(query_564835, "api-version", newJString(apiVersion))
  add(path_564834, "subscriptionId", newJString(subscriptionId))
  if createUpdateTableParameters != nil:
    body_564836 = createUpdateTableParameters
  add(path_564834, "resourceGroupName", newJString(resourceGroupName))
  add(path_564834, "tableName", newJString(tableName))
  add(path_564834, "accountName", newJString(accountName))
  result = call_564833.call(path_564834, query_564835, nil, nil, body_564836)

var databaseAccountsCreateUpdateTable* = Call_DatabaseAccountsCreateUpdateTable_564823(
    name: "databaseAccountsCreateUpdateTable", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/table/tables/{tableName}",
    validator: validate_DatabaseAccountsCreateUpdateTable_564824, base: "",
    url: url_DatabaseAccountsCreateUpdateTable_564825, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetTable_564811 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsGetTable_564813(protocol: Scheme; host: string;
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
  assert "tableName" in path, "`tableName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DocumentDB/databaseAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/apis/table/tables/"),
               (kind: VariableSegment, value: "tableName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsGetTable_564812(path: JsonNode; query: JsonNode;
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
  var valid_564814 = path.getOrDefault("subscriptionId")
  valid_564814 = validateParameter(valid_564814, JString, required = true,
                                 default = nil)
  if valid_564814 != nil:
    section.add "subscriptionId", valid_564814
  var valid_564815 = path.getOrDefault("resourceGroupName")
  valid_564815 = validateParameter(valid_564815, JString, required = true,
                                 default = nil)
  if valid_564815 != nil:
    section.add "resourceGroupName", valid_564815
  var valid_564816 = path.getOrDefault("tableName")
  valid_564816 = validateParameter(valid_564816, JString, required = true,
                                 default = nil)
  if valid_564816 != nil:
    section.add "tableName", valid_564816
  var valid_564817 = path.getOrDefault("accountName")
  valid_564817 = validateParameter(valid_564817, JString, required = true,
                                 default = nil)
  if valid_564817 != nil:
    section.add "accountName", valid_564817
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564818 = query.getOrDefault("api-version")
  valid_564818 = validateParameter(valid_564818, JString, required = true,
                                 default = nil)
  if valid_564818 != nil:
    section.add "api-version", valid_564818
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564819: Call_DatabaseAccountsGetTable_564811; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Tables under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_564819.validator(path, query, header, formData, body)
  let scheme = call_564819.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564819.url(scheme.get, call_564819.host, call_564819.base,
                         call_564819.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564819, url, valid)

proc call*(call_564820: Call_DatabaseAccountsGetTable_564811; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; tableName: string;
          accountName: string): Recallable =
  ## databaseAccountsGetTable
  ## Gets the Tables under an existing Azure Cosmos DB database account with the provided name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564821 = newJObject()
  var query_564822 = newJObject()
  add(query_564822, "api-version", newJString(apiVersion))
  add(path_564821, "subscriptionId", newJString(subscriptionId))
  add(path_564821, "resourceGroupName", newJString(resourceGroupName))
  add(path_564821, "tableName", newJString(tableName))
  add(path_564821, "accountName", newJString(accountName))
  result = call_564820.call(path_564821, query_564822, nil, nil, nil)

var databaseAccountsGetTable* = Call_DatabaseAccountsGetTable_564811(
    name: "databaseAccountsGetTable", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/table/tables/{tableName}",
    validator: validate_DatabaseAccountsGetTable_564812, base: "",
    url: url_DatabaseAccountsGetTable_564813, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteTable_564837 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsDeleteTable_564839(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/apis/table/tables/"),
               (kind: VariableSegment, value: "tableName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsDeleteTable_564838(path: JsonNode; query: JsonNode;
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
  var valid_564840 = path.getOrDefault("subscriptionId")
  valid_564840 = validateParameter(valid_564840, JString, required = true,
                                 default = nil)
  if valid_564840 != nil:
    section.add "subscriptionId", valid_564840
  var valid_564841 = path.getOrDefault("resourceGroupName")
  valid_564841 = validateParameter(valid_564841, JString, required = true,
                                 default = nil)
  if valid_564841 != nil:
    section.add "resourceGroupName", valid_564841
  var valid_564842 = path.getOrDefault("tableName")
  valid_564842 = validateParameter(valid_564842, JString, required = true,
                                 default = nil)
  if valid_564842 != nil:
    section.add "tableName", valid_564842
  var valid_564843 = path.getOrDefault("accountName")
  valid_564843 = validateParameter(valid_564843, JString, required = true,
                                 default = nil)
  if valid_564843 != nil:
    section.add "accountName", valid_564843
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564844 = query.getOrDefault("api-version")
  valid_564844 = validateParameter(valid_564844, JString, required = true,
                                 default = nil)
  if valid_564844 != nil:
    section.add "api-version", valid_564844
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564845: Call_DatabaseAccountsDeleteTable_564837; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB Table.
  ## 
  let valid = call_564845.validator(path, query, header, formData, body)
  let scheme = call_564845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564845.url(scheme.get, call_564845.host, call_564845.base,
                         call_564845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564845, url, valid)

proc call*(call_564846: Call_DatabaseAccountsDeleteTable_564837;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          tableName: string; accountName: string): Recallable =
  ## databaseAccountsDeleteTable
  ## Deletes an existing Azure Cosmos DB Table.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564847 = newJObject()
  var query_564848 = newJObject()
  add(query_564848, "api-version", newJString(apiVersion))
  add(path_564847, "subscriptionId", newJString(subscriptionId))
  add(path_564847, "resourceGroupName", newJString(resourceGroupName))
  add(path_564847, "tableName", newJString(tableName))
  add(path_564847, "accountName", newJString(accountName))
  result = call_564846.call(path_564847, query_564848, nil, nil, nil)

var databaseAccountsDeleteTable* = Call_DatabaseAccountsDeleteTable_564837(
    name: "databaseAccountsDeleteTable", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/table/tables/{tableName}",
    validator: validate_DatabaseAccountsDeleteTable_564838, base: "",
    url: url_DatabaseAccountsDeleteTable_564839, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateTableThroughput_564861 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsUpdateTableThroughput_564863(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/apis/table/tables/"),
               (kind: VariableSegment, value: "tableName"),
               (kind: ConstantSegment, value: "/settings/throughput")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsUpdateTableThroughput_564862(path: JsonNode;
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
  var valid_564864 = path.getOrDefault("subscriptionId")
  valid_564864 = validateParameter(valid_564864, JString, required = true,
                                 default = nil)
  if valid_564864 != nil:
    section.add "subscriptionId", valid_564864
  var valid_564865 = path.getOrDefault("resourceGroupName")
  valid_564865 = validateParameter(valid_564865, JString, required = true,
                                 default = nil)
  if valid_564865 != nil:
    section.add "resourceGroupName", valid_564865
  var valid_564866 = path.getOrDefault("tableName")
  valid_564866 = validateParameter(valid_564866, JString, required = true,
                                 default = nil)
  if valid_564866 != nil:
    section.add "tableName", valid_564866
  var valid_564867 = path.getOrDefault("accountName")
  valid_564867 = validateParameter(valid_564867, JString, required = true,
                                 default = nil)
  if valid_564867 != nil:
    section.add "accountName", valid_564867
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564868 = query.getOrDefault("api-version")
  valid_564868 = validateParameter(valid_564868, JString, required = true,
                                 default = nil)
  if valid_564868 != nil:
    section.add "api-version", valid_564868
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

proc call*(call_564870: Call_DatabaseAccountsUpdateTableThroughput_564861;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Table
  ## 
  let valid = call_564870.validator(path, query, header, formData, body)
  let scheme = call_564870.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564870.url(scheme.get, call_564870.host, call_564870.base,
                         call_564870.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564870, url, valid)

proc call*(call_564871: Call_DatabaseAccountsUpdateTableThroughput_564861;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          tableName: string; accountName: string;
          updateThroughputParameters: JsonNode): Recallable =
  ## databaseAccountsUpdateTableThroughput
  ## Update RUs per second of an Azure Cosmos DB Table
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564872 = newJObject()
  var query_564873 = newJObject()
  var body_564874 = newJObject()
  add(query_564873, "api-version", newJString(apiVersion))
  add(path_564872, "subscriptionId", newJString(subscriptionId))
  add(path_564872, "resourceGroupName", newJString(resourceGroupName))
  add(path_564872, "tableName", newJString(tableName))
  add(path_564872, "accountName", newJString(accountName))
  if updateThroughputParameters != nil:
    body_564874 = updateThroughputParameters
  result = call_564871.call(path_564872, query_564873, nil, nil, body_564874)

var databaseAccountsUpdateTableThroughput* = Call_DatabaseAccountsUpdateTableThroughput_564861(
    name: "databaseAccountsUpdateTableThroughput", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/table/tables/{tableName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateTableThroughput_564862, base: "",
    url: url_DatabaseAccountsUpdateTableThroughput_564863, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetTableThroughput_564849 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsGetTableThroughput_564851(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/apis/table/tables/"),
               (kind: VariableSegment, value: "tableName"),
               (kind: ConstantSegment, value: "/settings/throughput")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseAccountsGetTableThroughput_564850(path: JsonNode;
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
  var valid_564852 = path.getOrDefault("subscriptionId")
  valid_564852 = validateParameter(valid_564852, JString, required = true,
                                 default = nil)
  if valid_564852 != nil:
    section.add "subscriptionId", valid_564852
  var valid_564853 = path.getOrDefault("resourceGroupName")
  valid_564853 = validateParameter(valid_564853, JString, required = true,
                                 default = nil)
  if valid_564853 != nil:
    section.add "resourceGroupName", valid_564853
  var valid_564854 = path.getOrDefault("tableName")
  valid_564854 = validateParameter(valid_564854, JString, required = true,
                                 default = nil)
  if valid_564854 != nil:
    section.add "tableName", valid_564854
  var valid_564855 = path.getOrDefault("accountName")
  valid_564855 = validateParameter(valid_564855, JString, required = true,
                                 default = nil)
  if valid_564855 != nil:
    section.add "accountName", valid_564855
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564856 = query.getOrDefault("api-version")
  valid_564856 = validateParameter(valid_564856, JString, required = true,
                                 default = nil)
  if valid_564856 != nil:
    section.add "api-version", valid_564856
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564857: Call_DatabaseAccountsGetTableThroughput_564849;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the Table under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_564857.validator(path, query, header, formData, body)
  let scheme = call_564857.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564857.url(scheme.get, call_564857.host, call_564857.base,
                         call_564857.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564857, url, valid)

proc call*(call_564858: Call_DatabaseAccountsGetTableThroughput_564849;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          tableName: string; accountName: string): Recallable =
  ## databaseAccountsGetTableThroughput
  ## Gets the RUs per second of the Table under an existing Azure Cosmos DB database account with the provided name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564859 = newJObject()
  var query_564860 = newJObject()
  add(query_564860, "api-version", newJString(apiVersion))
  add(path_564859, "subscriptionId", newJString(subscriptionId))
  add(path_564859, "resourceGroupName", newJString(resourceGroupName))
  add(path_564859, "tableName", newJString(tableName))
  add(path_564859, "accountName", newJString(accountName))
  result = call_564858.call(path_564859, query_564860, nil, nil, nil)

var databaseAccountsGetTableThroughput* = Call_DatabaseAccountsGetTableThroughput_564849(
    name: "databaseAccountsGetTableThroughput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/table/tables/{tableName}/settings/throughput",
    validator: validate_DatabaseAccountsGetTableThroughput_564850, base: "",
    url: url_DatabaseAccountsGetTableThroughput_564851, schemes: {Scheme.Https})
type
  Call_CollectionListMetricDefinitions_564875 = ref object of OpenApiRestCall_563566
proc url_CollectionListMetricDefinitions_564877(protocol: Scheme; host: string;
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

proc validate_CollectionListMetricDefinitions_564876(path: JsonNode;
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
  var valid_564878 = path.getOrDefault("subscriptionId")
  valid_564878 = validateParameter(valid_564878, JString, required = true,
                                 default = nil)
  if valid_564878 != nil:
    section.add "subscriptionId", valid_564878
  var valid_564879 = path.getOrDefault("databaseRid")
  valid_564879 = validateParameter(valid_564879, JString, required = true,
                                 default = nil)
  if valid_564879 != nil:
    section.add "databaseRid", valid_564879
  var valid_564880 = path.getOrDefault("resourceGroupName")
  valid_564880 = validateParameter(valid_564880, JString, required = true,
                                 default = nil)
  if valid_564880 != nil:
    section.add "resourceGroupName", valid_564880
  var valid_564881 = path.getOrDefault("collectionRid")
  valid_564881 = validateParameter(valid_564881, JString, required = true,
                                 default = nil)
  if valid_564881 != nil:
    section.add "collectionRid", valid_564881
  var valid_564882 = path.getOrDefault("accountName")
  valid_564882 = validateParameter(valid_564882, JString, required = true,
                                 default = nil)
  if valid_564882 != nil:
    section.add "accountName", valid_564882
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564883 = query.getOrDefault("api-version")
  valid_564883 = validateParameter(valid_564883, JString, required = true,
                                 default = nil)
  if valid_564883 != nil:
    section.add "api-version", valid_564883
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564884: Call_CollectionListMetricDefinitions_564875;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves metric definitions for the given collection.
  ## 
  let valid = call_564884.validator(path, query, header, formData, body)
  let scheme = call_564884.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564884.url(scheme.get, call_564884.host, call_564884.base,
                         call_564884.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564884, url, valid)

proc call*(call_564885: Call_CollectionListMetricDefinitions_564875;
          apiVersion: string; subscriptionId: string; databaseRid: string;
          resourceGroupName: string; collectionRid: string; accountName: string): Recallable =
  ## collectionListMetricDefinitions
  ## Retrieves metric definitions for the given collection.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564886 = newJObject()
  var query_564887 = newJObject()
  add(query_564887, "api-version", newJString(apiVersion))
  add(path_564886, "subscriptionId", newJString(subscriptionId))
  add(path_564886, "databaseRid", newJString(databaseRid))
  add(path_564886, "resourceGroupName", newJString(resourceGroupName))
  add(path_564886, "collectionRid", newJString(collectionRid))
  add(path_564886, "accountName", newJString(accountName))
  result = call_564885.call(path_564886, query_564887, nil, nil, nil)

var collectionListMetricDefinitions* = Call_CollectionListMetricDefinitions_564875(
    name: "collectionListMetricDefinitions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/metricDefinitions",
    validator: validate_CollectionListMetricDefinitions_564876, base: "",
    url: url_CollectionListMetricDefinitions_564877, schemes: {Scheme.Https})
type
  Call_CollectionListMetrics_564888 = ref object of OpenApiRestCall_563566
proc url_CollectionListMetrics_564890(protocol: Scheme; host: string; base: string;
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

proc validate_CollectionListMetrics_564889(path: JsonNode; query: JsonNode;
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
  var valid_564892 = path.getOrDefault("subscriptionId")
  valid_564892 = validateParameter(valid_564892, JString, required = true,
                                 default = nil)
  if valid_564892 != nil:
    section.add "subscriptionId", valid_564892
  var valid_564893 = path.getOrDefault("databaseRid")
  valid_564893 = validateParameter(valid_564893, JString, required = true,
                                 default = nil)
  if valid_564893 != nil:
    section.add "databaseRid", valid_564893
  var valid_564894 = path.getOrDefault("resourceGroupName")
  valid_564894 = validateParameter(valid_564894, JString, required = true,
                                 default = nil)
  if valid_564894 != nil:
    section.add "resourceGroupName", valid_564894
  var valid_564895 = path.getOrDefault("collectionRid")
  valid_564895 = validateParameter(valid_564895, JString, required = true,
                                 default = nil)
  if valid_564895 != nil:
    section.add "collectionRid", valid_564895
  var valid_564896 = path.getOrDefault("accountName")
  valid_564896 = validateParameter(valid_564896, JString, required = true,
                                 default = nil)
  if valid_564896 != nil:
    section.add "accountName", valid_564896
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564897 = query.getOrDefault("api-version")
  valid_564897 = validateParameter(valid_564897, JString, required = true,
                                 default = nil)
  if valid_564897 != nil:
    section.add "api-version", valid_564897
  var valid_564898 = query.getOrDefault("$filter")
  valid_564898 = validateParameter(valid_564898, JString, required = true,
                                 default = nil)
  if valid_564898 != nil:
    section.add "$filter", valid_564898
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564899: Call_CollectionListMetrics_564888; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account and collection.
  ## 
  let valid = call_564899.validator(path, query, header, formData, body)
  let scheme = call_564899.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564899.url(scheme.get, call_564899.host, call_564899.base,
                         call_564899.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564899, url, valid)

proc call*(call_564900: Call_CollectionListMetrics_564888; apiVersion: string;
          subscriptionId: string; databaseRid: string; resourceGroupName: string;
          collectionRid: string; Filter: string; accountName: string): Recallable =
  ## collectionListMetrics
  ## Retrieves the metrics determined by the given filter for the given database account and collection.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564901 = newJObject()
  var query_564902 = newJObject()
  add(query_564902, "api-version", newJString(apiVersion))
  add(path_564901, "subscriptionId", newJString(subscriptionId))
  add(path_564901, "databaseRid", newJString(databaseRid))
  add(path_564901, "resourceGroupName", newJString(resourceGroupName))
  add(path_564901, "collectionRid", newJString(collectionRid))
  add(query_564902, "$filter", newJString(Filter))
  add(path_564901, "accountName", newJString(accountName))
  result = call_564900.call(path_564901, query_564902, nil, nil, nil)

var collectionListMetrics* = Call_CollectionListMetrics_564888(
    name: "collectionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/metrics",
    validator: validate_CollectionListMetrics_564889, base: "",
    url: url_CollectionListMetrics_564890, schemes: {Scheme.Https})
type
  Call_PartitionKeyRangeIdListMetrics_564903 = ref object of OpenApiRestCall_563566
proc url_PartitionKeyRangeIdListMetrics_564905(protocol: Scheme; host: string;
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

proc validate_PartitionKeyRangeIdListMetrics_564904(path: JsonNode;
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
  var valid_564906 = path.getOrDefault("partitionKeyRangeId")
  valid_564906 = validateParameter(valid_564906, JString, required = true,
                                 default = nil)
  if valid_564906 != nil:
    section.add "partitionKeyRangeId", valid_564906
  var valid_564907 = path.getOrDefault("subscriptionId")
  valid_564907 = validateParameter(valid_564907, JString, required = true,
                                 default = nil)
  if valid_564907 != nil:
    section.add "subscriptionId", valid_564907
  var valid_564908 = path.getOrDefault("databaseRid")
  valid_564908 = validateParameter(valid_564908, JString, required = true,
                                 default = nil)
  if valid_564908 != nil:
    section.add "databaseRid", valid_564908
  var valid_564909 = path.getOrDefault("resourceGroupName")
  valid_564909 = validateParameter(valid_564909, JString, required = true,
                                 default = nil)
  if valid_564909 != nil:
    section.add "resourceGroupName", valid_564909
  var valid_564910 = path.getOrDefault("collectionRid")
  valid_564910 = validateParameter(valid_564910, JString, required = true,
                                 default = nil)
  if valid_564910 != nil:
    section.add "collectionRid", valid_564910
  var valid_564911 = path.getOrDefault("accountName")
  valid_564911 = validateParameter(valid_564911, JString, required = true,
                                 default = nil)
  if valid_564911 != nil:
    section.add "accountName", valid_564911
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564912 = query.getOrDefault("api-version")
  valid_564912 = validateParameter(valid_564912, JString, required = true,
                                 default = nil)
  if valid_564912 != nil:
    section.add "api-version", valid_564912
  var valid_564913 = query.getOrDefault("$filter")
  valid_564913 = validateParameter(valid_564913, JString, required = true,
                                 default = nil)
  if valid_564913 != nil:
    section.add "$filter", valid_564913
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564914: Call_PartitionKeyRangeIdListMetrics_564903; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given partition key range id.
  ## 
  let valid = call_564914.validator(path, query, header, formData, body)
  let scheme = call_564914.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564914.url(scheme.get, call_564914.host, call_564914.base,
                         call_564914.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564914, url, valid)

proc call*(call_564915: Call_PartitionKeyRangeIdListMetrics_564903;
          partitionKeyRangeId: string; apiVersion: string; subscriptionId: string;
          databaseRid: string; resourceGroupName: string; collectionRid: string;
          Filter: string; accountName: string): Recallable =
  ## partitionKeyRangeIdListMetrics
  ## Retrieves the metrics determined by the given filter for the given partition key range id.
  ##   partitionKeyRangeId: string (required)
  ##                      : Partition Key Range Id for which to get data.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564916 = newJObject()
  var query_564917 = newJObject()
  add(path_564916, "partitionKeyRangeId", newJString(partitionKeyRangeId))
  add(query_564917, "api-version", newJString(apiVersion))
  add(path_564916, "subscriptionId", newJString(subscriptionId))
  add(path_564916, "databaseRid", newJString(databaseRid))
  add(path_564916, "resourceGroupName", newJString(resourceGroupName))
  add(path_564916, "collectionRid", newJString(collectionRid))
  add(query_564917, "$filter", newJString(Filter))
  add(path_564916, "accountName", newJString(accountName))
  result = call_564915.call(path_564916, query_564917, nil, nil, nil)

var partitionKeyRangeIdListMetrics* = Call_PartitionKeyRangeIdListMetrics_564903(
    name: "partitionKeyRangeIdListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/partitionKeyRangeId/{partitionKeyRangeId}/metrics",
    validator: validate_PartitionKeyRangeIdListMetrics_564904, base: "",
    url: url_PartitionKeyRangeIdListMetrics_564905, schemes: {Scheme.Https})
type
  Call_CollectionPartitionListMetrics_564918 = ref object of OpenApiRestCall_563566
proc url_CollectionPartitionListMetrics_564920(protocol: Scheme; host: string;
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

proc validate_CollectionPartitionListMetrics_564919(path: JsonNode;
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
  var valid_564921 = path.getOrDefault("subscriptionId")
  valid_564921 = validateParameter(valid_564921, JString, required = true,
                                 default = nil)
  if valid_564921 != nil:
    section.add "subscriptionId", valid_564921
  var valid_564922 = path.getOrDefault("databaseRid")
  valid_564922 = validateParameter(valid_564922, JString, required = true,
                                 default = nil)
  if valid_564922 != nil:
    section.add "databaseRid", valid_564922
  var valid_564923 = path.getOrDefault("resourceGroupName")
  valid_564923 = validateParameter(valid_564923, JString, required = true,
                                 default = nil)
  if valid_564923 != nil:
    section.add "resourceGroupName", valid_564923
  var valid_564924 = path.getOrDefault("collectionRid")
  valid_564924 = validateParameter(valid_564924, JString, required = true,
                                 default = nil)
  if valid_564924 != nil:
    section.add "collectionRid", valid_564924
  var valid_564925 = path.getOrDefault("accountName")
  valid_564925 = validateParameter(valid_564925, JString, required = true,
                                 default = nil)
  if valid_564925 != nil:
    section.add "accountName", valid_564925
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564926 = query.getOrDefault("api-version")
  valid_564926 = validateParameter(valid_564926, JString, required = true,
                                 default = nil)
  if valid_564926 != nil:
    section.add "api-version", valid_564926
  var valid_564927 = query.getOrDefault("$filter")
  valid_564927 = validateParameter(valid_564927, JString, required = true,
                                 default = nil)
  if valid_564927 != nil:
    section.add "$filter", valid_564927
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564928: Call_CollectionPartitionListMetrics_564918; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given collection, split by partition.
  ## 
  let valid = call_564928.validator(path, query, header, formData, body)
  let scheme = call_564928.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564928.url(scheme.get, call_564928.host, call_564928.base,
                         call_564928.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564928, url, valid)

proc call*(call_564929: Call_CollectionPartitionListMetrics_564918;
          apiVersion: string; subscriptionId: string; databaseRid: string;
          resourceGroupName: string; collectionRid: string; Filter: string;
          accountName: string): Recallable =
  ## collectionPartitionListMetrics
  ## Retrieves the metrics determined by the given filter for the given collection, split by partition.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564930 = newJObject()
  var query_564931 = newJObject()
  add(query_564931, "api-version", newJString(apiVersion))
  add(path_564930, "subscriptionId", newJString(subscriptionId))
  add(path_564930, "databaseRid", newJString(databaseRid))
  add(path_564930, "resourceGroupName", newJString(resourceGroupName))
  add(path_564930, "collectionRid", newJString(collectionRid))
  add(query_564931, "$filter", newJString(Filter))
  add(path_564930, "accountName", newJString(accountName))
  result = call_564929.call(path_564930, query_564931, nil, nil, nil)

var collectionPartitionListMetrics* = Call_CollectionPartitionListMetrics_564918(
    name: "collectionPartitionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/partitions/metrics",
    validator: validate_CollectionPartitionListMetrics_564919, base: "",
    url: url_CollectionPartitionListMetrics_564920, schemes: {Scheme.Https})
type
  Call_CollectionPartitionListUsages_564932 = ref object of OpenApiRestCall_563566
proc url_CollectionPartitionListUsages_564934(protocol: Scheme; host: string;
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

proc validate_CollectionPartitionListUsages_564933(path: JsonNode; query: JsonNode;
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString
  ##          : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564940 = query.getOrDefault("api-version")
  valid_564940 = validateParameter(valid_564940, JString, required = true,
                                 default = nil)
  if valid_564940 != nil:
    section.add "api-version", valid_564940
  var valid_564941 = query.getOrDefault("$filter")
  valid_564941 = validateParameter(valid_564941, JString, required = false,
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

proc call*(call_564942: Call_CollectionPartitionListUsages_564932; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the usages (most recent storage data) for the given collection, split by partition.
  ## 
  let valid = call_564942.validator(path, query, header, formData, body)
  let scheme = call_564942.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564942.url(scheme.get, call_564942.host, call_564942.base,
                         call_564942.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564942, url, valid)

proc call*(call_564943: Call_CollectionPartitionListUsages_564932;
          apiVersion: string; subscriptionId: string; databaseRid: string;
          resourceGroupName: string; collectionRid: string; accountName: string;
          Filter: string = ""): Recallable =
  ## collectionPartitionListUsages
  ## Retrieves the usages (most recent storage data) for the given collection, split by partition.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564944 = newJObject()
  var query_564945 = newJObject()
  add(query_564945, "api-version", newJString(apiVersion))
  add(path_564944, "subscriptionId", newJString(subscriptionId))
  add(path_564944, "databaseRid", newJString(databaseRid))
  add(path_564944, "resourceGroupName", newJString(resourceGroupName))
  add(path_564944, "collectionRid", newJString(collectionRid))
  add(query_564945, "$filter", newJString(Filter))
  add(path_564944, "accountName", newJString(accountName))
  result = call_564943.call(path_564944, query_564945, nil, nil, nil)

var collectionPartitionListUsages* = Call_CollectionPartitionListUsages_564932(
    name: "collectionPartitionListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/partitions/usages",
    validator: validate_CollectionPartitionListUsages_564933, base: "",
    url: url_CollectionPartitionListUsages_564934, schemes: {Scheme.Https})
type
  Call_CollectionListUsages_564946 = ref object of OpenApiRestCall_563566
proc url_CollectionListUsages_564948(protocol: Scheme; host: string; base: string;
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

proc validate_CollectionListUsages_564947(path: JsonNode; query: JsonNode;
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
  var valid_564949 = path.getOrDefault("subscriptionId")
  valid_564949 = validateParameter(valid_564949, JString, required = true,
                                 default = nil)
  if valid_564949 != nil:
    section.add "subscriptionId", valid_564949
  var valid_564950 = path.getOrDefault("databaseRid")
  valid_564950 = validateParameter(valid_564950, JString, required = true,
                                 default = nil)
  if valid_564950 != nil:
    section.add "databaseRid", valid_564950
  var valid_564951 = path.getOrDefault("resourceGroupName")
  valid_564951 = validateParameter(valid_564951, JString, required = true,
                                 default = nil)
  if valid_564951 != nil:
    section.add "resourceGroupName", valid_564951
  var valid_564952 = path.getOrDefault("collectionRid")
  valid_564952 = validateParameter(valid_564952, JString, required = true,
                                 default = nil)
  if valid_564952 != nil:
    section.add "collectionRid", valid_564952
  var valid_564953 = path.getOrDefault("accountName")
  valid_564953 = validateParameter(valid_564953, JString, required = true,
                                 default = nil)
  if valid_564953 != nil:
    section.add "accountName", valid_564953
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString
  ##          : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564954 = query.getOrDefault("api-version")
  valid_564954 = validateParameter(valid_564954, JString, required = true,
                                 default = nil)
  if valid_564954 != nil:
    section.add "api-version", valid_564954
  var valid_564955 = query.getOrDefault("$filter")
  valid_564955 = validateParameter(valid_564955, JString, required = false,
                                 default = nil)
  if valid_564955 != nil:
    section.add "$filter", valid_564955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564956: Call_CollectionListUsages_564946; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the usages (most recent storage data) for the given collection.
  ## 
  let valid = call_564956.validator(path, query, header, formData, body)
  let scheme = call_564956.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564956.url(scheme.get, call_564956.host, call_564956.base,
                         call_564956.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564956, url, valid)

proc call*(call_564957: Call_CollectionListUsages_564946; apiVersion: string;
          subscriptionId: string; databaseRid: string; resourceGroupName: string;
          collectionRid: string; accountName: string; Filter: string = ""): Recallable =
  ## collectionListUsages
  ## Retrieves the usages (most recent storage data) for the given collection.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564958 = newJObject()
  var query_564959 = newJObject()
  add(query_564959, "api-version", newJString(apiVersion))
  add(path_564958, "subscriptionId", newJString(subscriptionId))
  add(path_564958, "databaseRid", newJString(databaseRid))
  add(path_564958, "resourceGroupName", newJString(resourceGroupName))
  add(path_564958, "collectionRid", newJString(collectionRid))
  add(query_564959, "$filter", newJString(Filter))
  add(path_564958, "accountName", newJString(accountName))
  result = call_564957.call(path_564958, query_564959, nil, nil, nil)

var collectionListUsages* = Call_CollectionListUsages_564946(
    name: "collectionListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/usages",
    validator: validate_CollectionListUsages_564947, base: "",
    url: url_CollectionListUsages_564948, schemes: {Scheme.Https})
type
  Call_DatabaseListMetricDefinitions_564960 = ref object of OpenApiRestCall_563566
proc url_DatabaseListMetricDefinitions_564962(protocol: Scheme; host: string;
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

proc validate_DatabaseListMetricDefinitions_564961(path: JsonNode; query: JsonNode;
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
  var valid_564963 = path.getOrDefault("subscriptionId")
  valid_564963 = validateParameter(valid_564963, JString, required = true,
                                 default = nil)
  if valid_564963 != nil:
    section.add "subscriptionId", valid_564963
  var valid_564964 = path.getOrDefault("databaseRid")
  valid_564964 = validateParameter(valid_564964, JString, required = true,
                                 default = nil)
  if valid_564964 != nil:
    section.add "databaseRid", valid_564964
  var valid_564965 = path.getOrDefault("resourceGroupName")
  valid_564965 = validateParameter(valid_564965, JString, required = true,
                                 default = nil)
  if valid_564965 != nil:
    section.add "resourceGroupName", valid_564965
  var valid_564966 = path.getOrDefault("accountName")
  valid_564966 = validateParameter(valid_564966, JString, required = true,
                                 default = nil)
  if valid_564966 != nil:
    section.add "accountName", valid_564966
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564967 = query.getOrDefault("api-version")
  valid_564967 = validateParameter(valid_564967, JString, required = true,
                                 default = nil)
  if valid_564967 != nil:
    section.add "api-version", valid_564967
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564968: Call_DatabaseListMetricDefinitions_564960; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves metric definitions for the given database.
  ## 
  let valid = call_564968.validator(path, query, header, formData, body)
  let scheme = call_564968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564968.url(scheme.get, call_564968.host, call_564968.base,
                         call_564968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564968, url, valid)

proc call*(call_564969: Call_DatabaseListMetricDefinitions_564960;
          apiVersion: string; subscriptionId: string; databaseRid: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## databaseListMetricDefinitions
  ## Retrieves metric definitions for the given database.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: string (required)
  ##              : Cosmos DB database rid.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_564970 = newJObject()
  var query_564971 = newJObject()
  add(query_564971, "api-version", newJString(apiVersion))
  add(path_564970, "subscriptionId", newJString(subscriptionId))
  add(path_564970, "databaseRid", newJString(databaseRid))
  add(path_564970, "resourceGroupName", newJString(resourceGroupName))
  add(path_564970, "accountName", newJString(accountName))
  result = call_564969.call(path_564970, query_564971, nil, nil, nil)

var databaseListMetricDefinitions* = Call_DatabaseListMetricDefinitions_564960(
    name: "databaseListMetricDefinitions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/metricDefinitions",
    validator: validate_DatabaseListMetricDefinitions_564961, base: "",
    url: url_DatabaseListMetricDefinitions_564962, schemes: {Scheme.Https})
type
  Call_DatabaseListMetrics_564972 = ref object of OpenApiRestCall_563566
proc url_DatabaseListMetrics_564974(protocol: Scheme; host: string; base: string;
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

proc validate_DatabaseListMetrics_564973(path: JsonNode; query: JsonNode;
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
  var valid_564975 = path.getOrDefault("subscriptionId")
  valid_564975 = validateParameter(valid_564975, JString, required = true,
                                 default = nil)
  if valid_564975 != nil:
    section.add "subscriptionId", valid_564975
  var valid_564976 = path.getOrDefault("databaseRid")
  valid_564976 = validateParameter(valid_564976, JString, required = true,
                                 default = nil)
  if valid_564976 != nil:
    section.add "databaseRid", valid_564976
  var valid_564977 = path.getOrDefault("resourceGroupName")
  valid_564977 = validateParameter(valid_564977, JString, required = true,
                                 default = nil)
  if valid_564977 != nil:
    section.add "resourceGroupName", valid_564977
  var valid_564978 = path.getOrDefault("accountName")
  valid_564978 = validateParameter(valid_564978, JString, required = true,
                                 default = nil)
  if valid_564978 != nil:
    section.add "accountName", valid_564978
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564979 = query.getOrDefault("api-version")
  valid_564979 = validateParameter(valid_564979, JString, required = true,
                                 default = nil)
  if valid_564979 != nil:
    section.add "api-version", valid_564979
  var valid_564980 = query.getOrDefault("$filter")
  valid_564980 = validateParameter(valid_564980, JString, required = true,
                                 default = nil)
  if valid_564980 != nil:
    section.add "$filter", valid_564980
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564981: Call_DatabaseListMetrics_564972; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account and database.
  ## 
  let valid = call_564981.validator(path, query, header, formData, body)
  let scheme = call_564981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564981.url(scheme.get, call_564981.host, call_564981.base,
                         call_564981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564981, url, valid)

proc call*(call_564982: Call_DatabaseListMetrics_564972; apiVersion: string;
          subscriptionId: string; databaseRid: string; resourceGroupName: string;
          Filter: string; accountName: string): Recallable =
  ## databaseListMetrics
  ## Retrieves the metrics determined by the given filter for the given database account and database.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564983 = newJObject()
  var query_564984 = newJObject()
  add(query_564984, "api-version", newJString(apiVersion))
  add(path_564983, "subscriptionId", newJString(subscriptionId))
  add(path_564983, "databaseRid", newJString(databaseRid))
  add(path_564983, "resourceGroupName", newJString(resourceGroupName))
  add(query_564984, "$filter", newJString(Filter))
  add(path_564983, "accountName", newJString(accountName))
  result = call_564982.call(path_564983, query_564984, nil, nil, nil)

var databaseListMetrics* = Call_DatabaseListMetrics_564972(
    name: "databaseListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/metrics",
    validator: validate_DatabaseListMetrics_564973, base: "",
    url: url_DatabaseListMetrics_564974, schemes: {Scheme.Https})
type
  Call_DatabaseListUsages_564985 = ref object of OpenApiRestCall_563566
proc url_DatabaseListUsages_564987(protocol: Scheme; host: string; base: string;
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

proc validate_DatabaseListUsages_564986(path: JsonNode; query: JsonNode;
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
  var valid_564988 = path.getOrDefault("subscriptionId")
  valid_564988 = validateParameter(valid_564988, JString, required = true,
                                 default = nil)
  if valid_564988 != nil:
    section.add "subscriptionId", valid_564988
  var valid_564989 = path.getOrDefault("databaseRid")
  valid_564989 = validateParameter(valid_564989, JString, required = true,
                                 default = nil)
  if valid_564989 != nil:
    section.add "databaseRid", valid_564989
  var valid_564990 = path.getOrDefault("resourceGroupName")
  valid_564990 = validateParameter(valid_564990, JString, required = true,
                                 default = nil)
  if valid_564990 != nil:
    section.add "resourceGroupName", valid_564990
  var valid_564991 = path.getOrDefault("accountName")
  valid_564991 = validateParameter(valid_564991, JString, required = true,
                                 default = nil)
  if valid_564991 != nil:
    section.add "accountName", valid_564991
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString
  ##          : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564992 = query.getOrDefault("api-version")
  valid_564992 = validateParameter(valid_564992, JString, required = true,
                                 default = nil)
  if valid_564992 != nil:
    section.add "api-version", valid_564992
  var valid_564993 = query.getOrDefault("$filter")
  valid_564993 = validateParameter(valid_564993, JString, required = false,
                                 default = nil)
  if valid_564993 != nil:
    section.add "$filter", valid_564993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564994: Call_DatabaseListUsages_564985; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the usages (most recent data) for the given database.
  ## 
  let valid = call_564994.validator(path, query, header, formData, body)
  let scheme = call_564994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564994.url(scheme.get, call_564994.host, call_564994.base,
                         call_564994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564994, url, valid)

proc call*(call_564995: Call_DatabaseListUsages_564985; apiVersion: string;
          subscriptionId: string; databaseRid: string; resourceGroupName: string;
          accountName: string; Filter: string = ""): Recallable =
  ## databaseListUsages
  ## Retrieves the usages (most recent data) for the given database.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_564996 = newJObject()
  var query_564997 = newJObject()
  add(query_564997, "api-version", newJString(apiVersion))
  add(path_564996, "subscriptionId", newJString(subscriptionId))
  add(path_564996, "databaseRid", newJString(databaseRid))
  add(path_564996, "resourceGroupName", newJString(resourceGroupName))
  add(query_564997, "$filter", newJString(Filter))
  add(path_564996, "accountName", newJString(accountName))
  result = call_564995.call(path_564996, query_564997, nil, nil, nil)

var databaseListUsages* = Call_DatabaseListUsages_564985(
    name: "databaseListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/usages",
    validator: validate_DatabaseListUsages_564986, base: "",
    url: url_DatabaseListUsages_564987, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsFailoverPriorityChange_564998 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsFailoverPriorityChange_565000(protocol: Scheme;
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

proc validate_DatabaseAccountsFailoverPriorityChange_564999(path: JsonNode;
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
  var valid_565018 = path.getOrDefault("subscriptionId")
  valid_565018 = validateParameter(valid_565018, JString, required = true,
                                 default = nil)
  if valid_565018 != nil:
    section.add "subscriptionId", valid_565018
  var valid_565019 = path.getOrDefault("resourceGroupName")
  valid_565019 = validateParameter(valid_565019, JString, required = true,
                                 default = nil)
  if valid_565019 != nil:
    section.add "resourceGroupName", valid_565019
  var valid_565020 = path.getOrDefault("accountName")
  valid_565020 = validateParameter(valid_565020, JString, required = true,
                                 default = nil)
  if valid_565020 != nil:
    section.add "accountName", valid_565020
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565021 = query.getOrDefault("api-version")
  valid_565021 = validateParameter(valid_565021, JString, required = true,
                                 default = nil)
  if valid_565021 != nil:
    section.add "api-version", valid_565021
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

proc call*(call_565023: Call_DatabaseAccountsFailoverPriorityChange_564998;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Changes the failover priority for the Azure Cosmos DB database account. A failover priority of 0 indicates a write region. The maximum value for a failover priority = (total number of regions - 1). Failover priority values must be unique for each of the regions in which the database account exists.
  ## 
  let valid = call_565023.validator(path, query, header, formData, body)
  let scheme = call_565023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565023.url(scheme.get, call_565023.host, call_565023.base,
                         call_565023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565023, url, valid)

proc call*(call_565024: Call_DatabaseAccountsFailoverPriorityChange_564998;
          apiVersion: string; subscriptionId: string; failoverParameters: JsonNode;
          resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsFailoverPriorityChange
  ## Changes the failover priority for the Azure Cosmos DB database account. A failover priority of 0 indicates a write region. The maximum value for a failover priority = (total number of regions - 1). Failover priority values must be unique for each of the regions in which the database account exists.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   failoverParameters: JObject (required)
  ##                     : The new failover policies for the database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565025 = newJObject()
  var query_565026 = newJObject()
  var body_565027 = newJObject()
  add(query_565026, "api-version", newJString(apiVersion))
  add(path_565025, "subscriptionId", newJString(subscriptionId))
  if failoverParameters != nil:
    body_565027 = failoverParameters
  add(path_565025, "resourceGroupName", newJString(resourceGroupName))
  add(path_565025, "accountName", newJString(accountName))
  result = call_565024.call(path_565025, query_565026, nil, nil, body_565027)

var databaseAccountsFailoverPriorityChange* = Call_DatabaseAccountsFailoverPriorityChange_564998(
    name: "databaseAccountsFailoverPriorityChange", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/failoverPriorityChange",
    validator: validate_DatabaseAccountsFailoverPriorityChange_564999, base: "",
    url: url_DatabaseAccountsFailoverPriorityChange_565000,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListConnectionStrings_565028 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsListConnectionStrings_565030(protocol: Scheme;
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

proc validate_DatabaseAccountsListConnectionStrings_565029(path: JsonNode;
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
  var valid_565031 = path.getOrDefault("subscriptionId")
  valid_565031 = validateParameter(valid_565031, JString, required = true,
                                 default = nil)
  if valid_565031 != nil:
    section.add "subscriptionId", valid_565031
  var valid_565032 = path.getOrDefault("resourceGroupName")
  valid_565032 = validateParameter(valid_565032, JString, required = true,
                                 default = nil)
  if valid_565032 != nil:
    section.add "resourceGroupName", valid_565032
  var valid_565033 = path.getOrDefault("accountName")
  valid_565033 = validateParameter(valid_565033, JString, required = true,
                                 default = nil)
  if valid_565033 != nil:
    section.add "accountName", valid_565033
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565034 = query.getOrDefault("api-version")
  valid_565034 = validateParameter(valid_565034, JString, required = true,
                                 default = nil)
  if valid_565034 != nil:
    section.add "api-version", valid_565034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565035: Call_DatabaseAccountsListConnectionStrings_565028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the connection strings for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_565035.validator(path, query, header, formData, body)
  let scheme = call_565035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565035.url(scheme.get, call_565035.host, call_565035.base,
                         call_565035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565035, url, valid)

proc call*(call_565036: Call_DatabaseAccountsListConnectionStrings_565028;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## databaseAccountsListConnectionStrings
  ## Lists the connection strings for the specified Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565037 = newJObject()
  var query_565038 = newJObject()
  add(query_565038, "api-version", newJString(apiVersion))
  add(path_565037, "subscriptionId", newJString(subscriptionId))
  add(path_565037, "resourceGroupName", newJString(resourceGroupName))
  add(path_565037, "accountName", newJString(accountName))
  result = call_565036.call(path_565037, query_565038, nil, nil, nil)

var databaseAccountsListConnectionStrings* = Call_DatabaseAccountsListConnectionStrings_565028(
    name: "databaseAccountsListConnectionStrings", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/listConnectionStrings",
    validator: validate_DatabaseAccountsListConnectionStrings_565029, base: "",
    url: url_DatabaseAccountsListConnectionStrings_565030, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListKeys_565039 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsListKeys_565041(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListKeys_565040(path: JsonNode; query: JsonNode;
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
  var valid_565042 = path.getOrDefault("subscriptionId")
  valid_565042 = validateParameter(valid_565042, JString, required = true,
                                 default = nil)
  if valid_565042 != nil:
    section.add "subscriptionId", valid_565042
  var valid_565043 = path.getOrDefault("resourceGroupName")
  valid_565043 = validateParameter(valid_565043, JString, required = true,
                                 default = nil)
  if valid_565043 != nil:
    section.add "resourceGroupName", valid_565043
  var valid_565044 = path.getOrDefault("accountName")
  valid_565044 = validateParameter(valid_565044, JString, required = true,
                                 default = nil)
  if valid_565044 != nil:
    section.add "accountName", valid_565044
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565045 = query.getOrDefault("api-version")
  valid_565045 = validateParameter(valid_565045, JString, required = true,
                                 default = nil)
  if valid_565045 != nil:
    section.add "api-version", valid_565045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565046: Call_DatabaseAccountsListKeys_565039; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the access keys for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_565046.validator(path, query, header, formData, body)
  let scheme = call_565046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565046.url(scheme.get, call_565046.host, call_565046.base,
                         call_565046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565046, url, valid)

proc call*(call_565047: Call_DatabaseAccountsListKeys_565039; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsListKeys
  ## Lists the access keys for the specified Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565048 = newJObject()
  var query_565049 = newJObject()
  add(query_565049, "api-version", newJString(apiVersion))
  add(path_565048, "subscriptionId", newJString(subscriptionId))
  add(path_565048, "resourceGroupName", newJString(resourceGroupName))
  add(path_565048, "accountName", newJString(accountName))
  result = call_565047.call(path_565048, query_565049, nil, nil, nil)

var databaseAccountsListKeys* = Call_DatabaseAccountsListKeys_565039(
    name: "databaseAccountsListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/listKeys",
    validator: validate_DatabaseAccountsListKeys_565040, base: "",
    url: url_DatabaseAccountsListKeys_565041, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListMetricDefinitions_565050 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsListMetricDefinitions_565052(protocol: Scheme;
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

proc validate_DatabaseAccountsListMetricDefinitions_565051(path: JsonNode;
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
  var valid_565053 = path.getOrDefault("subscriptionId")
  valid_565053 = validateParameter(valid_565053, JString, required = true,
                                 default = nil)
  if valid_565053 != nil:
    section.add "subscriptionId", valid_565053
  var valid_565054 = path.getOrDefault("resourceGroupName")
  valid_565054 = validateParameter(valid_565054, JString, required = true,
                                 default = nil)
  if valid_565054 != nil:
    section.add "resourceGroupName", valid_565054
  var valid_565055 = path.getOrDefault("accountName")
  valid_565055 = validateParameter(valid_565055, JString, required = true,
                                 default = nil)
  if valid_565055 != nil:
    section.add "accountName", valid_565055
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565056 = query.getOrDefault("api-version")
  valid_565056 = validateParameter(valid_565056, JString, required = true,
                                 default = nil)
  if valid_565056 != nil:
    section.add "api-version", valid_565056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565057: Call_DatabaseAccountsListMetricDefinitions_565050;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves metric definitions for the given database account.
  ## 
  let valid = call_565057.validator(path, query, header, formData, body)
  let scheme = call_565057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565057.url(scheme.get, call_565057.host, call_565057.base,
                         call_565057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565057, url, valid)

proc call*(call_565058: Call_DatabaseAccountsListMetricDefinitions_565050;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## databaseAccountsListMetricDefinitions
  ## Retrieves metric definitions for the given database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565059 = newJObject()
  var query_565060 = newJObject()
  add(query_565060, "api-version", newJString(apiVersion))
  add(path_565059, "subscriptionId", newJString(subscriptionId))
  add(path_565059, "resourceGroupName", newJString(resourceGroupName))
  add(path_565059, "accountName", newJString(accountName))
  result = call_565058.call(path_565059, query_565060, nil, nil, nil)

var databaseAccountsListMetricDefinitions* = Call_DatabaseAccountsListMetricDefinitions_565050(
    name: "databaseAccountsListMetricDefinitions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/metricDefinitions",
    validator: validate_DatabaseAccountsListMetricDefinitions_565051, base: "",
    url: url_DatabaseAccountsListMetricDefinitions_565052, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListMetrics_565061 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsListMetrics_565063(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListMetrics_565062(path: JsonNode; query: JsonNode;
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
  var valid_565064 = path.getOrDefault("subscriptionId")
  valid_565064 = validateParameter(valid_565064, JString, required = true,
                                 default = nil)
  if valid_565064 != nil:
    section.add "subscriptionId", valid_565064
  var valid_565065 = path.getOrDefault("resourceGroupName")
  valid_565065 = validateParameter(valid_565065, JString, required = true,
                                 default = nil)
  if valid_565065 != nil:
    section.add "resourceGroupName", valid_565065
  var valid_565066 = path.getOrDefault("accountName")
  valid_565066 = validateParameter(valid_565066, JString, required = true,
                                 default = nil)
  if valid_565066 != nil:
    section.add "accountName", valid_565066
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565067 = query.getOrDefault("api-version")
  valid_565067 = validateParameter(valid_565067, JString, required = true,
                                 default = nil)
  if valid_565067 != nil:
    section.add "api-version", valid_565067
  var valid_565068 = query.getOrDefault("$filter")
  valid_565068 = validateParameter(valid_565068, JString, required = true,
                                 default = nil)
  if valid_565068 != nil:
    section.add "$filter", valid_565068
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565069: Call_DatabaseAccountsListMetrics_565061; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account.
  ## 
  let valid = call_565069.validator(path, query, header, formData, body)
  let scheme = call_565069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565069.url(scheme.get, call_565069.host, call_565069.base,
                         call_565069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565069, url, valid)

proc call*(call_565070: Call_DatabaseAccountsListMetrics_565061;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          Filter: string; accountName: string): Recallable =
  ## databaseAccountsListMetrics
  ## Retrieves the metrics determined by the given filter for the given database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565071 = newJObject()
  var query_565072 = newJObject()
  add(query_565072, "api-version", newJString(apiVersion))
  add(path_565071, "subscriptionId", newJString(subscriptionId))
  add(path_565071, "resourceGroupName", newJString(resourceGroupName))
  add(query_565072, "$filter", newJString(Filter))
  add(path_565071, "accountName", newJString(accountName))
  result = call_565070.call(path_565071, query_565072, nil, nil, nil)

var databaseAccountsListMetrics* = Call_DatabaseAccountsListMetrics_565061(
    name: "databaseAccountsListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/metrics",
    validator: validate_DatabaseAccountsListMetrics_565062, base: "",
    url: url_DatabaseAccountsListMetrics_565063, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsOfflineRegion_565073 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsOfflineRegion_565075(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsOfflineRegion_565074(path: JsonNode; query: JsonNode;
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
  var valid_565076 = path.getOrDefault("subscriptionId")
  valid_565076 = validateParameter(valid_565076, JString, required = true,
                                 default = nil)
  if valid_565076 != nil:
    section.add "subscriptionId", valid_565076
  var valid_565077 = path.getOrDefault("resourceGroupName")
  valid_565077 = validateParameter(valid_565077, JString, required = true,
                                 default = nil)
  if valid_565077 != nil:
    section.add "resourceGroupName", valid_565077
  var valid_565078 = path.getOrDefault("accountName")
  valid_565078 = validateParameter(valid_565078, JString, required = true,
                                 default = nil)
  if valid_565078 != nil:
    section.add "accountName", valid_565078
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565079 = query.getOrDefault("api-version")
  valid_565079 = validateParameter(valid_565079, JString, required = true,
                                 default = nil)
  if valid_565079 != nil:
    section.add "api-version", valid_565079
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

proc call*(call_565081: Call_DatabaseAccountsOfflineRegion_565073; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Offline the specified region for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_565081.validator(path, query, header, formData, body)
  let scheme = call_565081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565081.url(scheme.get, call_565081.host, call_565081.base,
                         call_565081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565081, url, valid)

proc call*(call_565082: Call_DatabaseAccountsOfflineRegion_565073;
          apiVersion: string; regionParameterForOffline: JsonNode;
          subscriptionId: string; resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsOfflineRegion
  ## Offline the specified region for the specified Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   regionParameterForOffline: JObject (required)
  ##                            : Cosmos DB region to offline for the database account.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565083 = newJObject()
  var query_565084 = newJObject()
  var body_565085 = newJObject()
  add(query_565084, "api-version", newJString(apiVersion))
  if regionParameterForOffline != nil:
    body_565085 = regionParameterForOffline
  add(path_565083, "subscriptionId", newJString(subscriptionId))
  add(path_565083, "resourceGroupName", newJString(resourceGroupName))
  add(path_565083, "accountName", newJString(accountName))
  result = call_565082.call(path_565083, query_565084, nil, nil, body_565085)

var databaseAccountsOfflineRegion* = Call_DatabaseAccountsOfflineRegion_565073(
    name: "databaseAccountsOfflineRegion", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/offlineRegion",
    validator: validate_DatabaseAccountsOfflineRegion_565074, base: "",
    url: url_DatabaseAccountsOfflineRegion_565075, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsOnlineRegion_565086 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsOnlineRegion_565088(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsOnlineRegion_565087(path: JsonNode; query: JsonNode;
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
  var valid_565089 = path.getOrDefault("subscriptionId")
  valid_565089 = validateParameter(valid_565089, JString, required = true,
                                 default = nil)
  if valid_565089 != nil:
    section.add "subscriptionId", valid_565089
  var valid_565090 = path.getOrDefault("resourceGroupName")
  valid_565090 = validateParameter(valid_565090, JString, required = true,
                                 default = nil)
  if valid_565090 != nil:
    section.add "resourceGroupName", valid_565090
  var valid_565091 = path.getOrDefault("accountName")
  valid_565091 = validateParameter(valid_565091, JString, required = true,
                                 default = nil)
  if valid_565091 != nil:
    section.add "accountName", valid_565091
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565092 = query.getOrDefault("api-version")
  valid_565092 = validateParameter(valid_565092, JString, required = true,
                                 default = nil)
  if valid_565092 != nil:
    section.add "api-version", valid_565092
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

proc call*(call_565094: Call_DatabaseAccountsOnlineRegion_565086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Online the specified region for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_565094.validator(path, query, header, formData, body)
  let scheme = call_565094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565094.url(scheme.get, call_565094.host, call_565094.base,
                         call_565094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565094, url, valid)

proc call*(call_565095: Call_DatabaseAccountsOnlineRegion_565086;
          regionParameterForOnline: JsonNode; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsOnlineRegion
  ## Online the specified region for the specified Azure Cosmos DB database account.
  ##   regionParameterForOnline: JObject (required)
  ##                           : Cosmos DB region to online for the database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565096 = newJObject()
  var query_565097 = newJObject()
  var body_565098 = newJObject()
  if regionParameterForOnline != nil:
    body_565098 = regionParameterForOnline
  add(query_565097, "api-version", newJString(apiVersion))
  add(path_565096, "subscriptionId", newJString(subscriptionId))
  add(path_565096, "resourceGroupName", newJString(resourceGroupName))
  add(path_565096, "accountName", newJString(accountName))
  result = call_565095.call(path_565096, query_565097, nil, nil, body_565098)

var databaseAccountsOnlineRegion* = Call_DatabaseAccountsOnlineRegion_565086(
    name: "databaseAccountsOnlineRegion", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/onlineRegion",
    validator: validate_DatabaseAccountsOnlineRegion_565087, base: "",
    url: url_DatabaseAccountsOnlineRegion_565088, schemes: {Scheme.Https})
type
  Call_PercentileListMetrics_565099 = ref object of OpenApiRestCall_563566
proc url_PercentileListMetrics_565101(protocol: Scheme; host: string; base: string;
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

proc validate_PercentileListMetrics_565100(path: JsonNode; query: JsonNode;
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
  var valid_565102 = path.getOrDefault("subscriptionId")
  valid_565102 = validateParameter(valid_565102, JString, required = true,
                                 default = nil)
  if valid_565102 != nil:
    section.add "subscriptionId", valid_565102
  var valid_565103 = path.getOrDefault("resourceGroupName")
  valid_565103 = validateParameter(valid_565103, JString, required = true,
                                 default = nil)
  if valid_565103 != nil:
    section.add "resourceGroupName", valid_565103
  var valid_565104 = path.getOrDefault("accountName")
  valid_565104 = validateParameter(valid_565104, JString, required = true,
                                 default = nil)
  if valid_565104 != nil:
    section.add "accountName", valid_565104
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565105 = query.getOrDefault("api-version")
  valid_565105 = validateParameter(valid_565105, JString, required = true,
                                 default = nil)
  if valid_565105 != nil:
    section.add "api-version", valid_565105
  var valid_565106 = query.getOrDefault("$filter")
  valid_565106 = validateParameter(valid_565106, JString, required = true,
                                 default = nil)
  if valid_565106 != nil:
    section.add "$filter", valid_565106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565107: Call_PercentileListMetrics_565099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account. This url is only for PBS and Replication Latency data
  ## 
  let valid = call_565107.validator(path, query, header, formData, body)
  let scheme = call_565107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565107.url(scheme.get, call_565107.host, call_565107.base,
                         call_565107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565107, url, valid)

proc call*(call_565108: Call_PercentileListMetrics_565099; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; Filter: string;
          accountName: string): Recallable =
  ## percentileListMetrics
  ## Retrieves the metrics determined by the given filter for the given database account. This url is only for PBS and Replication Latency data
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565109 = newJObject()
  var query_565110 = newJObject()
  add(query_565110, "api-version", newJString(apiVersion))
  add(path_565109, "subscriptionId", newJString(subscriptionId))
  add(path_565109, "resourceGroupName", newJString(resourceGroupName))
  add(query_565110, "$filter", newJString(Filter))
  add(path_565109, "accountName", newJString(accountName))
  result = call_565108.call(path_565109, query_565110, nil, nil, nil)

var percentileListMetrics* = Call_PercentileListMetrics_565099(
    name: "percentileListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/percentile/metrics",
    validator: validate_PercentileListMetrics_565100, base: "",
    url: url_PercentileListMetrics_565101, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListReadOnlyKeys_565122 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsListReadOnlyKeys_565124(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListReadOnlyKeys_565123(path: JsonNode;
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
  var valid_565125 = path.getOrDefault("subscriptionId")
  valid_565125 = validateParameter(valid_565125, JString, required = true,
                                 default = nil)
  if valid_565125 != nil:
    section.add "subscriptionId", valid_565125
  var valid_565126 = path.getOrDefault("resourceGroupName")
  valid_565126 = validateParameter(valid_565126, JString, required = true,
                                 default = nil)
  if valid_565126 != nil:
    section.add "resourceGroupName", valid_565126
  var valid_565127 = path.getOrDefault("accountName")
  valid_565127 = validateParameter(valid_565127, JString, required = true,
                                 default = nil)
  if valid_565127 != nil:
    section.add "accountName", valid_565127
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565128 = query.getOrDefault("api-version")
  valid_565128 = validateParameter(valid_565128, JString, required = true,
                                 default = nil)
  if valid_565128 != nil:
    section.add "api-version", valid_565128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565129: Call_DatabaseAccountsListReadOnlyKeys_565122;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the read-only access keys for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_565129.validator(path, query, header, formData, body)
  let scheme = call_565129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565129.url(scheme.get, call_565129.host, call_565129.base,
                         call_565129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565129, url, valid)

proc call*(call_565130: Call_DatabaseAccountsListReadOnlyKeys_565122;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## databaseAccountsListReadOnlyKeys
  ## Lists the read-only access keys for the specified Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565131 = newJObject()
  var query_565132 = newJObject()
  add(query_565132, "api-version", newJString(apiVersion))
  add(path_565131, "subscriptionId", newJString(subscriptionId))
  add(path_565131, "resourceGroupName", newJString(resourceGroupName))
  add(path_565131, "accountName", newJString(accountName))
  result = call_565130.call(path_565131, query_565132, nil, nil, nil)

var databaseAccountsListReadOnlyKeys* = Call_DatabaseAccountsListReadOnlyKeys_565122(
    name: "databaseAccountsListReadOnlyKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/readonlykeys",
    validator: validate_DatabaseAccountsListReadOnlyKeys_565123, base: "",
    url: url_DatabaseAccountsListReadOnlyKeys_565124, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetReadOnlyKeys_565111 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsGetReadOnlyKeys_565113(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsGetReadOnlyKeys_565112(path: JsonNode;
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
  var valid_565114 = path.getOrDefault("subscriptionId")
  valid_565114 = validateParameter(valid_565114, JString, required = true,
                                 default = nil)
  if valid_565114 != nil:
    section.add "subscriptionId", valid_565114
  var valid_565115 = path.getOrDefault("resourceGroupName")
  valid_565115 = validateParameter(valid_565115, JString, required = true,
                                 default = nil)
  if valid_565115 != nil:
    section.add "resourceGroupName", valid_565115
  var valid_565116 = path.getOrDefault("accountName")
  valid_565116 = validateParameter(valid_565116, JString, required = true,
                                 default = nil)
  if valid_565116 != nil:
    section.add "accountName", valid_565116
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565117 = query.getOrDefault("api-version")
  valid_565117 = validateParameter(valid_565117, JString, required = true,
                                 default = nil)
  if valid_565117 != nil:
    section.add "api-version", valid_565117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565118: Call_DatabaseAccountsGetReadOnlyKeys_565111;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the read-only access keys for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_565118.validator(path, query, header, formData, body)
  let scheme = call_565118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565118.url(scheme.get, call_565118.host, call_565118.base,
                         call_565118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565118, url, valid)

proc call*(call_565119: Call_DatabaseAccountsGetReadOnlyKeys_565111;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## databaseAccountsGetReadOnlyKeys
  ## Lists the read-only access keys for the specified Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565120 = newJObject()
  var query_565121 = newJObject()
  add(query_565121, "api-version", newJString(apiVersion))
  add(path_565120, "subscriptionId", newJString(subscriptionId))
  add(path_565120, "resourceGroupName", newJString(resourceGroupName))
  add(path_565120, "accountName", newJString(accountName))
  result = call_565119.call(path_565120, query_565121, nil, nil, nil)

var databaseAccountsGetReadOnlyKeys* = Call_DatabaseAccountsGetReadOnlyKeys_565111(
    name: "databaseAccountsGetReadOnlyKeys", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/readonlykeys",
    validator: validate_DatabaseAccountsGetReadOnlyKeys_565112, base: "",
    url: url_DatabaseAccountsGetReadOnlyKeys_565113, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsRegenerateKey_565133 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsRegenerateKey_565135(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsRegenerateKey_565134(path: JsonNode; query: JsonNode;
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
  var valid_565136 = path.getOrDefault("subscriptionId")
  valid_565136 = validateParameter(valid_565136, JString, required = true,
                                 default = nil)
  if valid_565136 != nil:
    section.add "subscriptionId", valid_565136
  var valid_565137 = path.getOrDefault("resourceGroupName")
  valid_565137 = validateParameter(valid_565137, JString, required = true,
                                 default = nil)
  if valid_565137 != nil:
    section.add "resourceGroupName", valid_565137
  var valid_565138 = path.getOrDefault("accountName")
  valid_565138 = validateParameter(valid_565138, JString, required = true,
                                 default = nil)
  if valid_565138 != nil:
    section.add "accountName", valid_565138
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565139 = query.getOrDefault("api-version")
  valid_565139 = validateParameter(valid_565139, JString, required = true,
                                 default = nil)
  if valid_565139 != nil:
    section.add "api-version", valid_565139
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

proc call*(call_565141: Call_DatabaseAccountsRegenerateKey_565133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates an access key for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_565141.validator(path, query, header, formData, body)
  let scheme = call_565141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565141.url(scheme.get, call_565141.host, call_565141.base,
                         call_565141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565141, url, valid)

proc call*(call_565142: Call_DatabaseAccountsRegenerateKey_565133;
          apiVersion: string; keyToRegenerate: JsonNode; subscriptionId: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## databaseAccountsRegenerateKey
  ## Regenerates an access key for the specified Azure Cosmos DB database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   keyToRegenerate: JObject (required)
  ##                  : The name of the key to regenerate.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565143 = newJObject()
  var query_565144 = newJObject()
  var body_565145 = newJObject()
  add(query_565144, "api-version", newJString(apiVersion))
  if keyToRegenerate != nil:
    body_565145 = keyToRegenerate
  add(path_565143, "subscriptionId", newJString(subscriptionId))
  add(path_565143, "resourceGroupName", newJString(resourceGroupName))
  add(path_565143, "accountName", newJString(accountName))
  result = call_565142.call(path_565143, query_565144, nil, nil, body_565145)

var databaseAccountsRegenerateKey* = Call_DatabaseAccountsRegenerateKey_565133(
    name: "databaseAccountsRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/regenerateKey",
    validator: validate_DatabaseAccountsRegenerateKey_565134, base: "",
    url: url_DatabaseAccountsRegenerateKey_565135, schemes: {Scheme.Https})
type
  Call_CollectionRegionListMetrics_565146 = ref object of OpenApiRestCall_563566
proc url_CollectionRegionListMetrics_565148(protocol: Scheme; host: string;
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

proc validate_CollectionRegionListMetrics_565147(path: JsonNode; query: JsonNode;
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
  var valid_565149 = path.getOrDefault("region")
  valid_565149 = validateParameter(valid_565149, JString, required = true,
                                 default = nil)
  if valid_565149 != nil:
    section.add "region", valid_565149
  var valid_565150 = path.getOrDefault("subscriptionId")
  valid_565150 = validateParameter(valid_565150, JString, required = true,
                                 default = nil)
  if valid_565150 != nil:
    section.add "subscriptionId", valid_565150
  var valid_565151 = path.getOrDefault("databaseRid")
  valid_565151 = validateParameter(valid_565151, JString, required = true,
                                 default = nil)
  if valid_565151 != nil:
    section.add "databaseRid", valid_565151
  var valid_565152 = path.getOrDefault("resourceGroupName")
  valid_565152 = validateParameter(valid_565152, JString, required = true,
                                 default = nil)
  if valid_565152 != nil:
    section.add "resourceGroupName", valid_565152
  var valid_565153 = path.getOrDefault("collectionRid")
  valid_565153 = validateParameter(valid_565153, JString, required = true,
                                 default = nil)
  if valid_565153 != nil:
    section.add "collectionRid", valid_565153
  var valid_565154 = path.getOrDefault("accountName")
  valid_565154 = validateParameter(valid_565154, JString, required = true,
                                 default = nil)
  if valid_565154 != nil:
    section.add "accountName", valid_565154
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565155 = query.getOrDefault("api-version")
  valid_565155 = validateParameter(valid_565155, JString, required = true,
                                 default = nil)
  if valid_565155 != nil:
    section.add "api-version", valid_565155
  var valid_565156 = query.getOrDefault("$filter")
  valid_565156 = validateParameter(valid_565156, JString, required = true,
                                 default = nil)
  if valid_565156 != nil:
    section.add "$filter", valid_565156
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565157: Call_CollectionRegionListMetrics_565146; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account, collection and region.
  ## 
  let valid = call_565157.validator(path, query, header, formData, body)
  let scheme = call_565157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565157.url(scheme.get, call_565157.host, call_565157.base,
                         call_565157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565157, url, valid)

proc call*(call_565158: Call_CollectionRegionListMetrics_565146;
          apiVersion: string; region: string; subscriptionId: string;
          databaseRid: string; resourceGroupName: string; collectionRid: string;
          Filter: string; accountName: string): Recallable =
  ## collectionRegionListMetrics
  ## Retrieves the metrics determined by the given filter for the given database account, collection and region.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_565159 = newJObject()
  var query_565160 = newJObject()
  add(query_565160, "api-version", newJString(apiVersion))
  add(path_565159, "region", newJString(region))
  add(path_565159, "subscriptionId", newJString(subscriptionId))
  add(path_565159, "databaseRid", newJString(databaseRid))
  add(path_565159, "resourceGroupName", newJString(resourceGroupName))
  add(path_565159, "collectionRid", newJString(collectionRid))
  add(query_565160, "$filter", newJString(Filter))
  add(path_565159, "accountName", newJString(accountName))
  result = call_565158.call(path_565159, query_565160, nil, nil, nil)

var collectionRegionListMetrics* = Call_CollectionRegionListMetrics_565146(
    name: "collectionRegionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/region/{region}/databases/{databaseRid}/collections/{collectionRid}/metrics",
    validator: validate_CollectionRegionListMetrics_565147, base: "",
    url: url_CollectionRegionListMetrics_565148, schemes: {Scheme.Https})
type
  Call_PartitionKeyRangeIdRegionListMetrics_565161 = ref object of OpenApiRestCall_563566
proc url_PartitionKeyRangeIdRegionListMetrics_565163(protocol: Scheme;
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

proc validate_PartitionKeyRangeIdRegionListMetrics_565162(path: JsonNode;
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
  var valid_565164 = path.getOrDefault("partitionKeyRangeId")
  valid_565164 = validateParameter(valid_565164, JString, required = true,
                                 default = nil)
  if valid_565164 != nil:
    section.add "partitionKeyRangeId", valid_565164
  var valid_565165 = path.getOrDefault("region")
  valid_565165 = validateParameter(valid_565165, JString, required = true,
                                 default = nil)
  if valid_565165 != nil:
    section.add "region", valid_565165
  var valid_565166 = path.getOrDefault("subscriptionId")
  valid_565166 = validateParameter(valid_565166, JString, required = true,
                                 default = nil)
  if valid_565166 != nil:
    section.add "subscriptionId", valid_565166
  var valid_565167 = path.getOrDefault("databaseRid")
  valid_565167 = validateParameter(valid_565167, JString, required = true,
                                 default = nil)
  if valid_565167 != nil:
    section.add "databaseRid", valid_565167
  var valid_565168 = path.getOrDefault("resourceGroupName")
  valid_565168 = validateParameter(valid_565168, JString, required = true,
                                 default = nil)
  if valid_565168 != nil:
    section.add "resourceGroupName", valid_565168
  var valid_565169 = path.getOrDefault("collectionRid")
  valid_565169 = validateParameter(valid_565169, JString, required = true,
                                 default = nil)
  if valid_565169 != nil:
    section.add "collectionRid", valid_565169
  var valid_565170 = path.getOrDefault("accountName")
  valid_565170 = validateParameter(valid_565170, JString, required = true,
                                 default = nil)
  if valid_565170 != nil:
    section.add "accountName", valid_565170
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565171 = query.getOrDefault("api-version")
  valid_565171 = validateParameter(valid_565171, JString, required = true,
                                 default = nil)
  if valid_565171 != nil:
    section.add "api-version", valid_565171
  var valid_565172 = query.getOrDefault("$filter")
  valid_565172 = validateParameter(valid_565172, JString, required = true,
                                 default = nil)
  if valid_565172 != nil:
    section.add "$filter", valid_565172
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565173: Call_PartitionKeyRangeIdRegionListMetrics_565161;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given partition key range id and region.
  ## 
  let valid = call_565173.validator(path, query, header, formData, body)
  let scheme = call_565173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565173.url(scheme.get, call_565173.host, call_565173.base,
                         call_565173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565173, url, valid)

proc call*(call_565174: Call_PartitionKeyRangeIdRegionListMetrics_565161;
          partitionKeyRangeId: string; apiVersion: string; region: string;
          subscriptionId: string; databaseRid: string; resourceGroupName: string;
          collectionRid: string; Filter: string; accountName: string): Recallable =
  ## partitionKeyRangeIdRegionListMetrics
  ## Retrieves the metrics determined by the given filter for the given partition key range id and region.
  ##   partitionKeyRangeId: string (required)
  ##                      : Partition Key Range Id for which to get data.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_565175 = newJObject()
  var query_565176 = newJObject()
  add(path_565175, "partitionKeyRangeId", newJString(partitionKeyRangeId))
  add(query_565176, "api-version", newJString(apiVersion))
  add(path_565175, "region", newJString(region))
  add(path_565175, "subscriptionId", newJString(subscriptionId))
  add(path_565175, "databaseRid", newJString(databaseRid))
  add(path_565175, "resourceGroupName", newJString(resourceGroupName))
  add(path_565175, "collectionRid", newJString(collectionRid))
  add(query_565176, "$filter", newJString(Filter))
  add(path_565175, "accountName", newJString(accountName))
  result = call_565174.call(path_565175, query_565176, nil, nil, nil)

var partitionKeyRangeIdRegionListMetrics* = Call_PartitionKeyRangeIdRegionListMetrics_565161(
    name: "partitionKeyRangeIdRegionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/region/{region}/databases/{databaseRid}/collections/{collectionRid}/partitionKeyRangeId/{partitionKeyRangeId}/metrics",
    validator: validate_PartitionKeyRangeIdRegionListMetrics_565162, base: "",
    url: url_PartitionKeyRangeIdRegionListMetrics_565163, schemes: {Scheme.Https})
type
  Call_CollectionPartitionRegionListMetrics_565177 = ref object of OpenApiRestCall_563566
proc url_CollectionPartitionRegionListMetrics_565179(protocol: Scheme;
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

proc validate_CollectionPartitionRegionListMetrics_565178(path: JsonNode;
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
  var valid_565180 = path.getOrDefault("region")
  valid_565180 = validateParameter(valid_565180, JString, required = true,
                                 default = nil)
  if valid_565180 != nil:
    section.add "region", valid_565180
  var valid_565181 = path.getOrDefault("subscriptionId")
  valid_565181 = validateParameter(valid_565181, JString, required = true,
                                 default = nil)
  if valid_565181 != nil:
    section.add "subscriptionId", valid_565181
  var valid_565182 = path.getOrDefault("databaseRid")
  valid_565182 = validateParameter(valid_565182, JString, required = true,
                                 default = nil)
  if valid_565182 != nil:
    section.add "databaseRid", valid_565182
  var valid_565183 = path.getOrDefault("resourceGroupName")
  valid_565183 = validateParameter(valid_565183, JString, required = true,
                                 default = nil)
  if valid_565183 != nil:
    section.add "resourceGroupName", valid_565183
  var valid_565184 = path.getOrDefault("collectionRid")
  valid_565184 = validateParameter(valid_565184, JString, required = true,
                                 default = nil)
  if valid_565184 != nil:
    section.add "collectionRid", valid_565184
  var valid_565185 = path.getOrDefault("accountName")
  valid_565185 = validateParameter(valid_565185, JString, required = true,
                                 default = nil)
  if valid_565185 != nil:
    section.add "accountName", valid_565185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565186 = query.getOrDefault("api-version")
  valid_565186 = validateParameter(valid_565186, JString, required = true,
                                 default = nil)
  if valid_565186 != nil:
    section.add "api-version", valid_565186
  var valid_565187 = query.getOrDefault("$filter")
  valid_565187 = validateParameter(valid_565187, JString, required = true,
                                 default = nil)
  if valid_565187 != nil:
    section.add "$filter", valid_565187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565188: Call_CollectionPartitionRegionListMetrics_565177;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given collection and region, split by partition.
  ## 
  let valid = call_565188.validator(path, query, header, formData, body)
  let scheme = call_565188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565188.url(scheme.get, call_565188.host, call_565188.base,
                         call_565188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565188, url, valid)

proc call*(call_565189: Call_CollectionPartitionRegionListMetrics_565177;
          apiVersion: string; region: string; subscriptionId: string;
          databaseRid: string; resourceGroupName: string; collectionRid: string;
          Filter: string; accountName: string): Recallable =
  ## collectionPartitionRegionListMetrics
  ## Retrieves the metrics determined by the given filter for the given collection and region, split by partition.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_565190 = newJObject()
  var query_565191 = newJObject()
  add(query_565191, "api-version", newJString(apiVersion))
  add(path_565190, "region", newJString(region))
  add(path_565190, "subscriptionId", newJString(subscriptionId))
  add(path_565190, "databaseRid", newJString(databaseRid))
  add(path_565190, "resourceGroupName", newJString(resourceGroupName))
  add(path_565190, "collectionRid", newJString(collectionRid))
  add(query_565191, "$filter", newJString(Filter))
  add(path_565190, "accountName", newJString(accountName))
  result = call_565189.call(path_565190, query_565191, nil, nil, nil)

var collectionPartitionRegionListMetrics* = Call_CollectionPartitionRegionListMetrics_565177(
    name: "collectionPartitionRegionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/region/{region}/databases/{databaseRid}/collections/{collectionRid}/partitions/metrics",
    validator: validate_CollectionPartitionRegionListMetrics_565178, base: "",
    url: url_CollectionPartitionRegionListMetrics_565179, schemes: {Scheme.Https})
type
  Call_DatabaseAccountRegionListMetrics_565192 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountRegionListMetrics_565194(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountRegionListMetrics_565193(path: JsonNode;
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
  var valid_565195 = path.getOrDefault("region")
  valid_565195 = validateParameter(valid_565195, JString, required = true,
                                 default = nil)
  if valid_565195 != nil:
    section.add "region", valid_565195
  var valid_565196 = path.getOrDefault("subscriptionId")
  valid_565196 = validateParameter(valid_565196, JString, required = true,
                                 default = nil)
  if valid_565196 != nil:
    section.add "subscriptionId", valid_565196
  var valid_565197 = path.getOrDefault("resourceGroupName")
  valid_565197 = validateParameter(valid_565197, JString, required = true,
                                 default = nil)
  if valid_565197 != nil:
    section.add "resourceGroupName", valid_565197
  var valid_565198 = path.getOrDefault("accountName")
  valid_565198 = validateParameter(valid_565198, JString, required = true,
                                 default = nil)
  if valid_565198 != nil:
    section.add "accountName", valid_565198
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565199 = query.getOrDefault("api-version")
  valid_565199 = validateParameter(valid_565199, JString, required = true,
                                 default = nil)
  if valid_565199 != nil:
    section.add "api-version", valid_565199
  var valid_565200 = query.getOrDefault("$filter")
  valid_565200 = validateParameter(valid_565200, JString, required = true,
                                 default = nil)
  if valid_565200 != nil:
    section.add "$filter", valid_565200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565201: Call_DatabaseAccountRegionListMetrics_565192;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account and region.
  ## 
  let valid = call_565201.validator(path, query, header, formData, body)
  let scheme = call_565201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565201.url(scheme.get, call_565201.host, call_565201.base,
                         call_565201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565201, url, valid)

proc call*(call_565202: Call_DatabaseAccountRegionListMetrics_565192;
          apiVersion: string; region: string; subscriptionId: string;
          resourceGroupName: string; Filter: string; accountName: string): Recallable =
  ## databaseAccountRegionListMetrics
  ## Retrieves the metrics determined by the given filter for the given database account and region.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_565203 = newJObject()
  var query_565204 = newJObject()
  add(query_565204, "api-version", newJString(apiVersion))
  add(path_565203, "region", newJString(region))
  add(path_565203, "subscriptionId", newJString(subscriptionId))
  add(path_565203, "resourceGroupName", newJString(resourceGroupName))
  add(query_565204, "$filter", newJString(Filter))
  add(path_565203, "accountName", newJString(accountName))
  result = call_565202.call(path_565203, query_565204, nil, nil, nil)

var databaseAccountRegionListMetrics* = Call_DatabaseAccountRegionListMetrics_565192(
    name: "databaseAccountRegionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/region/{region}/metrics",
    validator: validate_DatabaseAccountRegionListMetrics_565193, base: "",
    url: url_DatabaseAccountRegionListMetrics_565194, schemes: {Scheme.Https})
type
  Call_PercentileSourceTargetListMetrics_565205 = ref object of OpenApiRestCall_563566
proc url_PercentileSourceTargetListMetrics_565207(protocol: Scheme; host: string;
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

proc validate_PercentileSourceTargetListMetrics_565206(path: JsonNode;
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
  var valid_565208 = path.getOrDefault("subscriptionId")
  valid_565208 = validateParameter(valid_565208, JString, required = true,
                                 default = nil)
  if valid_565208 != nil:
    section.add "subscriptionId", valid_565208
  var valid_565209 = path.getOrDefault("sourceRegion")
  valid_565209 = validateParameter(valid_565209, JString, required = true,
                                 default = nil)
  if valid_565209 != nil:
    section.add "sourceRegion", valid_565209
  var valid_565210 = path.getOrDefault("resourceGroupName")
  valid_565210 = validateParameter(valid_565210, JString, required = true,
                                 default = nil)
  if valid_565210 != nil:
    section.add "resourceGroupName", valid_565210
  var valid_565211 = path.getOrDefault("targetRegion")
  valid_565211 = validateParameter(valid_565211, JString, required = true,
                                 default = nil)
  if valid_565211 != nil:
    section.add "targetRegion", valid_565211
  var valid_565212 = path.getOrDefault("accountName")
  valid_565212 = validateParameter(valid_565212, JString, required = true,
                                 default = nil)
  if valid_565212 != nil:
    section.add "accountName", valid_565212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565213 = query.getOrDefault("api-version")
  valid_565213 = validateParameter(valid_565213, JString, required = true,
                                 default = nil)
  if valid_565213 != nil:
    section.add "api-version", valid_565213
  var valid_565214 = query.getOrDefault("$filter")
  valid_565214 = validateParameter(valid_565214, JString, required = true,
                                 default = nil)
  if valid_565214 != nil:
    section.add "$filter", valid_565214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565215: Call_PercentileSourceTargetListMetrics_565205;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given account, source and target region. This url is only for PBS and Replication Latency data
  ## 
  let valid = call_565215.validator(path, query, header, formData, body)
  let scheme = call_565215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565215.url(scheme.get, call_565215.host, call_565215.base,
                         call_565215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565215, url, valid)

proc call*(call_565216: Call_PercentileSourceTargetListMetrics_565205;
          apiVersion: string; subscriptionId: string; sourceRegion: string;
          resourceGroupName: string; Filter: string; targetRegion: string;
          accountName: string): Recallable =
  ## percentileSourceTargetListMetrics
  ## Retrieves the metrics determined by the given filter for the given account, source and target region. This url is only for PBS and Replication Latency data
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_565217 = newJObject()
  var query_565218 = newJObject()
  add(query_565218, "api-version", newJString(apiVersion))
  add(path_565217, "subscriptionId", newJString(subscriptionId))
  add(path_565217, "sourceRegion", newJString(sourceRegion))
  add(path_565217, "resourceGroupName", newJString(resourceGroupName))
  add(query_565218, "$filter", newJString(Filter))
  add(path_565217, "targetRegion", newJString(targetRegion))
  add(path_565217, "accountName", newJString(accountName))
  result = call_565216.call(path_565217, query_565218, nil, nil, nil)

var percentileSourceTargetListMetrics* = Call_PercentileSourceTargetListMetrics_565205(
    name: "percentileSourceTargetListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sourceRegion/{sourceRegion}/targetRegion/{targetRegion}/percentile/metrics",
    validator: validate_PercentileSourceTargetListMetrics_565206, base: "",
    url: url_PercentileSourceTargetListMetrics_565207, schemes: {Scheme.Https})
type
  Call_PercentileTargetListMetrics_565219 = ref object of OpenApiRestCall_563566
proc url_PercentileTargetListMetrics_565221(protocol: Scheme; host: string;
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

proc validate_PercentileTargetListMetrics_565220(path: JsonNode; query: JsonNode;
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
  var valid_565222 = path.getOrDefault("subscriptionId")
  valid_565222 = validateParameter(valid_565222, JString, required = true,
                                 default = nil)
  if valid_565222 != nil:
    section.add "subscriptionId", valid_565222
  var valid_565223 = path.getOrDefault("resourceGroupName")
  valid_565223 = validateParameter(valid_565223, JString, required = true,
                                 default = nil)
  if valid_565223 != nil:
    section.add "resourceGroupName", valid_565223
  var valid_565224 = path.getOrDefault("targetRegion")
  valid_565224 = validateParameter(valid_565224, JString, required = true,
                                 default = nil)
  if valid_565224 != nil:
    section.add "targetRegion", valid_565224
  var valid_565225 = path.getOrDefault("accountName")
  valid_565225 = validateParameter(valid_565225, JString, required = true,
                                 default = nil)
  if valid_565225 != nil:
    section.add "accountName", valid_565225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565226 = query.getOrDefault("api-version")
  valid_565226 = validateParameter(valid_565226, JString, required = true,
                                 default = nil)
  if valid_565226 != nil:
    section.add "api-version", valid_565226
  var valid_565227 = query.getOrDefault("$filter")
  valid_565227 = validateParameter(valid_565227, JString, required = true,
                                 default = nil)
  if valid_565227 != nil:
    section.add "$filter", valid_565227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565228: Call_PercentileTargetListMetrics_565219; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given account target region. This url is only for PBS and Replication Latency data
  ## 
  let valid = call_565228.validator(path, query, header, formData, body)
  let scheme = call_565228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565228.url(scheme.get, call_565228.host, call_565228.base,
                         call_565228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565228, url, valid)

proc call*(call_565229: Call_PercentileTargetListMetrics_565219;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          Filter: string; targetRegion: string; accountName: string): Recallable =
  ## percentileTargetListMetrics
  ## Retrieves the metrics determined by the given filter for the given account target region. This url is only for PBS and Replication Latency data
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_565230 = newJObject()
  var query_565231 = newJObject()
  add(query_565231, "api-version", newJString(apiVersion))
  add(path_565230, "subscriptionId", newJString(subscriptionId))
  add(path_565230, "resourceGroupName", newJString(resourceGroupName))
  add(query_565231, "$filter", newJString(Filter))
  add(path_565230, "targetRegion", newJString(targetRegion))
  add(path_565230, "accountName", newJString(accountName))
  result = call_565229.call(path_565230, query_565231, nil, nil, nil)

var percentileTargetListMetrics* = Call_PercentileTargetListMetrics_565219(
    name: "percentileTargetListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/targetRegion/{targetRegion}/percentile/metrics",
    validator: validate_PercentileTargetListMetrics_565220, base: "",
    url: url_PercentileTargetListMetrics_565221, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListUsages_565232 = ref object of OpenApiRestCall_563566
proc url_DatabaseAccountsListUsages_565234(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListUsages_565233(path: JsonNode; query: JsonNode;
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
  var valid_565235 = path.getOrDefault("subscriptionId")
  valid_565235 = validateParameter(valid_565235, JString, required = true,
                                 default = nil)
  if valid_565235 != nil:
    section.add "subscriptionId", valid_565235
  var valid_565236 = path.getOrDefault("resourceGroupName")
  valid_565236 = validateParameter(valid_565236, JString, required = true,
                                 default = nil)
  if valid_565236 != nil:
    section.add "resourceGroupName", valid_565236
  var valid_565237 = path.getOrDefault("accountName")
  valid_565237 = validateParameter(valid_565237, JString, required = true,
                                 default = nil)
  if valid_565237 != nil:
    section.add "accountName", valid_565237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString
  ##          : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565238 = query.getOrDefault("api-version")
  valid_565238 = validateParameter(valid_565238, JString, required = true,
                                 default = nil)
  if valid_565238 != nil:
    section.add "api-version", valid_565238
  var valid_565239 = query.getOrDefault("$filter")
  valid_565239 = validateParameter(valid_565239, JString, required = false,
                                 default = nil)
  if valid_565239 != nil:
    section.add "$filter", valid_565239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565240: Call_DatabaseAccountsListUsages_565232; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the usages (most recent data) for the given database account.
  ## 
  let valid = call_565240.validator(path, query, header, formData, body)
  let scheme = call_565240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565240.url(scheme.get, call_565240.host, call_565240.base,
                         call_565240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565240, url, valid)

proc call*(call_565241: Call_DatabaseAccountsListUsages_565232; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string;
          Filter: string = ""): Recallable =
  ## databaseAccountsListUsages
  ## Retrieves the usages (most recent data) for the given database account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   Filter: string
  ##         : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_565242 = newJObject()
  var query_565243 = newJObject()
  add(query_565243, "api-version", newJString(apiVersion))
  add(path_565242, "subscriptionId", newJString(subscriptionId))
  add(path_565242, "resourceGroupName", newJString(resourceGroupName))
  add(query_565243, "$filter", newJString(Filter))
  add(path_565242, "accountName", newJString(accountName))
  result = call_565241.call(path_565242, query_565243, nil, nil, nil)

var databaseAccountsListUsages* = Call_DatabaseAccountsListUsages_565232(
    name: "databaseAccountsListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/usages",
    validator: validate_DatabaseAccountsListUsages_565233, base: "",
    url: url_DatabaseAccountsListUsages_565234, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
