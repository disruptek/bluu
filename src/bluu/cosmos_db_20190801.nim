
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

  OpenApiRestCall_573668 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573668](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573668): Option[Scheme] {.used.} =
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
  macServiceName = "cosmos-db"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DatabaseAccountsCheckNameExists_573890 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsCheckNameExists_573892(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsCheckNameExists_573891(path: JsonNode;
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
  var valid_574065 = path.getOrDefault("accountName")
  valid_574065 = validateParameter(valid_574065, JString, required = true,
                                 default = nil)
  if valid_574065 != nil:
    section.add "accountName", valid_574065
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574066 = query.getOrDefault("api-version")
  valid_574066 = validateParameter(valid_574066, JString, required = true,
                                 default = nil)
  if valid_574066 != nil:
    section.add "api-version", valid_574066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574089: Call_DatabaseAccountsCheckNameExists_573890;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks that the Azure Cosmos DB account name already exists. A valid account name may contain only lowercase letters, numbers, and the '-' character, and must be between 3 and 50 characters.
  ## 
  let valid = call_574089.validator(path, query, header, formData, body)
  let scheme = call_574089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574089.url(scheme.get, call_574089.host, call_574089.base,
                         call_574089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574089, url, valid)

proc call*(call_574160: Call_DatabaseAccountsCheckNameExists_573890;
          apiVersion: string; accountName: string): Recallable =
  ## databaseAccountsCheckNameExists
  ## Checks that the Azure Cosmos DB account name already exists. A valid account name may contain only lowercase letters, numbers, and the '-' character, and must be between 3 and 50 characters.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574161 = newJObject()
  var query_574163 = newJObject()
  add(query_574163, "api-version", newJString(apiVersion))
  add(path_574161, "accountName", newJString(accountName))
  result = call_574160.call(path_574161, query_574163, nil, nil, nil)

var databaseAccountsCheckNameExists* = Call_DatabaseAccountsCheckNameExists_573890(
    name: "databaseAccountsCheckNameExists", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/providers/Microsoft.DocumentDB/databaseAccountNames/{accountName}",
    validator: validate_DatabaseAccountsCheckNameExists_573891, base: "",
    url: url_DatabaseAccountsCheckNameExists_573892, schemes: {Scheme.Https})
type
  Call_OperationsList_574202 = ref object of OpenApiRestCall_573668
proc url_OperationsList_574204(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_574203(path: JsonNode; query: JsonNode;
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
  var valid_574205 = query.getOrDefault("api-version")
  valid_574205 = validateParameter(valid_574205, JString, required = true,
                                 default = nil)
  if valid_574205 != nil:
    section.add "api-version", valid_574205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574206: Call_OperationsList_574202; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Cosmos DB Resource Provider operations.
  ## 
  let valid = call_574206.validator(path, query, header, formData, body)
  let scheme = call_574206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574206.url(scheme.get, call_574206.host, call_574206.base,
                         call_574206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574206, url, valid)

proc call*(call_574207: Call_OperationsList_574202; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Cosmos DB Resource Provider operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  var query_574208 = newJObject()
  add(query_574208, "api-version", newJString(apiVersion))
  result = call_574207.call(nil, query_574208, nil, nil, nil)

var operationsList* = Call_OperationsList_574202(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DocumentDB/operations",
    validator: validate_OperationsList_574203, base: "", url: url_OperationsList_574204,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsList_574209 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsList_574211(protocol: Scheme; host: string; base: string;
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

proc validate_DatabaseAccountsList_574210(path: JsonNode; query: JsonNode;
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
  var valid_574212 = path.getOrDefault("subscriptionId")
  valid_574212 = validateParameter(valid_574212, JString, required = true,
                                 default = nil)
  if valid_574212 != nil:
    section.add "subscriptionId", valid_574212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574213 = query.getOrDefault("api-version")
  valid_574213 = validateParameter(valid_574213, JString, required = true,
                                 default = nil)
  if valid_574213 != nil:
    section.add "api-version", valid_574213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574214: Call_DatabaseAccountsList_574209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the Azure Cosmos DB database accounts available under the subscription.
  ## 
  let valid = call_574214.validator(path, query, header, formData, body)
  let scheme = call_574214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574214.url(scheme.get, call_574214.host, call_574214.base,
                         call_574214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574214, url, valid)

proc call*(call_574215: Call_DatabaseAccountsList_574209; apiVersion: string;
          subscriptionId: string): Recallable =
  ## databaseAccountsList
  ## Lists all the Azure Cosmos DB database accounts available under the subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  var path_574216 = newJObject()
  var query_574217 = newJObject()
  add(query_574217, "api-version", newJString(apiVersion))
  add(path_574216, "subscriptionId", newJString(subscriptionId))
  result = call_574215.call(path_574216, query_574217, nil, nil, nil)

var databaseAccountsList* = Call_DatabaseAccountsList_574209(
    name: "databaseAccountsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DocumentDB/databaseAccounts",
    validator: validate_DatabaseAccountsList_574210, base: "",
    url: url_DatabaseAccountsList_574211, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListByResourceGroup_574218 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsListByResourceGroup_574220(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListByResourceGroup_574219(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the Azure Cosmos DB database accounts available under the given resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574221 = path.getOrDefault("resourceGroupName")
  valid_574221 = validateParameter(valid_574221, JString, required = true,
                                 default = nil)
  if valid_574221 != nil:
    section.add "resourceGroupName", valid_574221
  var valid_574222 = path.getOrDefault("subscriptionId")
  valid_574222 = validateParameter(valid_574222, JString, required = true,
                                 default = nil)
  if valid_574222 != nil:
    section.add "subscriptionId", valid_574222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
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

proc call*(call_574224: Call_DatabaseAccountsListByResourceGroup_574218;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the Azure Cosmos DB database accounts available under the given resource group.
  ## 
  let valid = call_574224.validator(path, query, header, formData, body)
  let scheme = call_574224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574224.url(scheme.get, call_574224.host, call_574224.base,
                         call_574224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574224, url, valid)

proc call*(call_574225: Call_DatabaseAccountsListByResourceGroup_574218;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## databaseAccountsListByResourceGroup
  ## Lists all the Azure Cosmos DB database accounts available under the given resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  var path_574226 = newJObject()
  var query_574227 = newJObject()
  add(path_574226, "resourceGroupName", newJString(resourceGroupName))
  add(query_574227, "api-version", newJString(apiVersion))
  add(path_574226, "subscriptionId", newJString(subscriptionId))
  result = call_574225.call(path_574226, query_574227, nil, nil, nil)

var databaseAccountsListByResourceGroup* = Call_DatabaseAccountsListByResourceGroup_574218(
    name: "databaseAccountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts",
    validator: validate_DatabaseAccountsListByResourceGroup_574219, base: "",
    url: url_DatabaseAccountsListByResourceGroup_574220, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateOrUpdate_574239 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsCreateOrUpdate_574241(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsCreateOrUpdate_574240(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574242 = path.getOrDefault("resourceGroupName")
  valid_574242 = validateParameter(valid_574242, JString, required = true,
                                 default = nil)
  if valid_574242 != nil:
    section.add "resourceGroupName", valid_574242
  var valid_574243 = path.getOrDefault("subscriptionId")
  valid_574243 = validateParameter(valid_574243, JString, required = true,
                                 default = nil)
  if valid_574243 != nil:
    section.add "subscriptionId", valid_574243
  var valid_574244 = path.getOrDefault("accountName")
  valid_574244 = validateParameter(valid_574244, JString, required = true,
                                 default = nil)
  if valid_574244 != nil:
    section.add "accountName", valid_574244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574245 = query.getOrDefault("api-version")
  valid_574245 = validateParameter(valid_574245, JString, required = true,
                                 default = nil)
  if valid_574245 != nil:
    section.add "api-version", valid_574245
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

proc call*(call_574247: Call_DatabaseAccountsCreateOrUpdate_574239; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an Azure Cosmos DB database account.
  ## 
  let valid = call_574247.validator(path, query, header, formData, body)
  let scheme = call_574247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574247.url(scheme.get, call_574247.host, call_574247.base,
                         call_574247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574247, url, valid)

proc call*(call_574248: Call_DatabaseAccountsCreateOrUpdate_574239;
          resourceGroupName: string; apiVersion: string;
          createUpdateParameters: JsonNode; subscriptionId: string;
          accountName: string): Recallable =
  ## databaseAccountsCreateOrUpdate
  ## Creates or updates an Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   createUpdateParameters: JObject (required)
  ##                         : The parameters to provide for the current database account.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574249 = newJObject()
  var query_574250 = newJObject()
  var body_574251 = newJObject()
  add(path_574249, "resourceGroupName", newJString(resourceGroupName))
  add(query_574250, "api-version", newJString(apiVersion))
  if createUpdateParameters != nil:
    body_574251 = createUpdateParameters
  add(path_574249, "subscriptionId", newJString(subscriptionId))
  add(path_574249, "accountName", newJString(accountName))
  result = call_574248.call(path_574249, query_574250, nil, nil, body_574251)

var databaseAccountsCreateOrUpdate* = Call_DatabaseAccountsCreateOrUpdate_574239(
    name: "databaseAccountsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}",
    validator: validate_DatabaseAccountsCreateOrUpdate_574240, base: "",
    url: url_DatabaseAccountsCreateOrUpdate_574241, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGet_574228 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsGet_574230(protocol: Scheme; host: string; base: string;
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

proc validate_DatabaseAccountsGet_574229(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves the properties of an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574231 = path.getOrDefault("resourceGroupName")
  valid_574231 = validateParameter(valid_574231, JString, required = true,
                                 default = nil)
  if valid_574231 != nil:
    section.add "resourceGroupName", valid_574231
  var valid_574232 = path.getOrDefault("subscriptionId")
  valid_574232 = validateParameter(valid_574232, JString, required = true,
                                 default = nil)
  if valid_574232 != nil:
    section.add "subscriptionId", valid_574232
  var valid_574233 = path.getOrDefault("accountName")
  valid_574233 = validateParameter(valid_574233, JString, required = true,
                                 default = nil)
  if valid_574233 != nil:
    section.add "accountName", valid_574233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574234 = query.getOrDefault("api-version")
  valid_574234 = validateParameter(valid_574234, JString, required = true,
                                 default = nil)
  if valid_574234 != nil:
    section.add "api-version", valid_574234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574235: Call_DatabaseAccountsGet_574228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the properties of an existing Azure Cosmos DB database account.
  ## 
  let valid = call_574235.validator(path, query, header, formData, body)
  let scheme = call_574235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574235.url(scheme.get, call_574235.host, call_574235.base,
                         call_574235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574235, url, valid)

proc call*(call_574236: Call_DatabaseAccountsGet_574228; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## databaseAccountsGet
  ## Retrieves the properties of an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574237 = newJObject()
  var query_574238 = newJObject()
  add(path_574237, "resourceGroupName", newJString(resourceGroupName))
  add(query_574238, "api-version", newJString(apiVersion))
  add(path_574237, "subscriptionId", newJString(subscriptionId))
  add(path_574237, "accountName", newJString(accountName))
  result = call_574236.call(path_574237, query_574238, nil, nil, nil)

var databaseAccountsGet* = Call_DatabaseAccountsGet_574228(
    name: "databaseAccountsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}",
    validator: validate_DatabaseAccountsGet_574229, base: "",
    url: url_DatabaseAccountsGet_574230, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsPatch_574263 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsPatch_574265(protocol: Scheme; host: string; base: string;
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

proc validate_DatabaseAccountsPatch_574264(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patches the properties of an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574266 = path.getOrDefault("resourceGroupName")
  valid_574266 = validateParameter(valid_574266, JString, required = true,
                                 default = nil)
  if valid_574266 != nil:
    section.add "resourceGroupName", valid_574266
  var valid_574267 = path.getOrDefault("subscriptionId")
  valid_574267 = validateParameter(valid_574267, JString, required = true,
                                 default = nil)
  if valid_574267 != nil:
    section.add "subscriptionId", valid_574267
  var valid_574268 = path.getOrDefault("accountName")
  valid_574268 = validateParameter(valid_574268, JString, required = true,
                                 default = nil)
  if valid_574268 != nil:
    section.add "accountName", valid_574268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574269 = query.getOrDefault("api-version")
  valid_574269 = validateParameter(valid_574269, JString, required = true,
                                 default = nil)
  if valid_574269 != nil:
    section.add "api-version", valid_574269
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

proc call*(call_574271: Call_DatabaseAccountsPatch_574263; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patches the properties of an existing Azure Cosmos DB database account.
  ## 
  let valid = call_574271.validator(path, query, header, formData, body)
  let scheme = call_574271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574271.url(scheme.get, call_574271.host, call_574271.base,
                         call_574271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574271, url, valid)

proc call*(call_574272: Call_DatabaseAccountsPatch_574263;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          updateParameters: JsonNode; accountName: string): Recallable =
  ## databaseAccountsPatch
  ## Patches the properties of an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   updateParameters: JObject (required)
  ##                   : The tags parameter to patch for the current database account.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574273 = newJObject()
  var query_574274 = newJObject()
  var body_574275 = newJObject()
  add(path_574273, "resourceGroupName", newJString(resourceGroupName))
  add(query_574274, "api-version", newJString(apiVersion))
  add(path_574273, "subscriptionId", newJString(subscriptionId))
  if updateParameters != nil:
    body_574275 = updateParameters
  add(path_574273, "accountName", newJString(accountName))
  result = call_574272.call(path_574273, query_574274, nil, nil, body_574275)

var databaseAccountsPatch* = Call_DatabaseAccountsPatch_574263(
    name: "databaseAccountsPatch", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}",
    validator: validate_DatabaseAccountsPatch_574264, base: "",
    url: url_DatabaseAccountsPatch_574265, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDelete_574252 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsDelete_574254(protocol: Scheme; host: string; base: string;
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

proc validate_DatabaseAccountsDelete_574253(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574255 = path.getOrDefault("resourceGroupName")
  valid_574255 = validateParameter(valid_574255, JString, required = true,
                                 default = nil)
  if valid_574255 != nil:
    section.add "resourceGroupName", valid_574255
  var valid_574256 = path.getOrDefault("subscriptionId")
  valid_574256 = validateParameter(valid_574256, JString, required = true,
                                 default = nil)
  if valid_574256 != nil:
    section.add "subscriptionId", valid_574256
  var valid_574257 = path.getOrDefault("accountName")
  valid_574257 = validateParameter(valid_574257, JString, required = true,
                                 default = nil)
  if valid_574257 != nil:
    section.add "accountName", valid_574257
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574258 = query.getOrDefault("api-version")
  valid_574258 = validateParameter(valid_574258, JString, required = true,
                                 default = nil)
  if valid_574258 != nil:
    section.add "api-version", valid_574258
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574259: Call_DatabaseAccountsDelete_574252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB database account.
  ## 
  let valid = call_574259.validator(path, query, header, formData, body)
  let scheme = call_574259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574259.url(scheme.get, call_574259.host, call_574259.base,
                         call_574259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574259, url, valid)

proc call*(call_574260: Call_DatabaseAccountsDelete_574252;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## databaseAccountsDelete
  ## Deletes an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574261 = newJObject()
  var query_574262 = newJObject()
  add(path_574261, "resourceGroupName", newJString(resourceGroupName))
  add(query_574262, "api-version", newJString(apiVersion))
  add(path_574261, "subscriptionId", newJString(subscriptionId))
  add(path_574261, "accountName", newJString(accountName))
  result = call_574260.call(path_574261, query_574262, nil, nil, nil)

var databaseAccountsDelete* = Call_DatabaseAccountsDelete_574252(
    name: "databaseAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}",
    validator: validate_DatabaseAccountsDelete_574253, base: "",
    url: url_DatabaseAccountsDelete_574254, schemes: {Scheme.Https})
type
  Call_CassandraResourcesListCassandraKeyspaces_574276 = ref object of OpenApiRestCall_573668
proc url_CassandraResourcesListCassandraKeyspaces_574278(protocol: Scheme;
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

proc validate_CassandraResourcesListCassandraKeyspaces_574277(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Cassandra keyspaces under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574279 = path.getOrDefault("resourceGroupName")
  valid_574279 = validateParameter(valid_574279, JString, required = true,
                                 default = nil)
  if valid_574279 != nil:
    section.add "resourceGroupName", valid_574279
  var valid_574280 = path.getOrDefault("subscriptionId")
  valid_574280 = validateParameter(valid_574280, JString, required = true,
                                 default = nil)
  if valid_574280 != nil:
    section.add "subscriptionId", valid_574280
  var valid_574281 = path.getOrDefault("accountName")
  valid_574281 = validateParameter(valid_574281, JString, required = true,
                                 default = nil)
  if valid_574281 != nil:
    section.add "accountName", valid_574281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574282 = query.getOrDefault("api-version")
  valid_574282 = validateParameter(valid_574282, JString, required = true,
                                 default = nil)
  if valid_574282 != nil:
    section.add "api-version", valid_574282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574283: Call_CassandraResourcesListCassandraKeyspaces_574276;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Cassandra keyspaces under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_574283.validator(path, query, header, formData, body)
  let scheme = call_574283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574283.url(scheme.get, call_574283.host, call_574283.base,
                         call_574283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574283, url, valid)

proc call*(call_574284: Call_CassandraResourcesListCassandraKeyspaces_574276;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## cassandraResourcesListCassandraKeyspaces
  ## Lists the Cassandra keyspaces under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574285 = newJObject()
  var query_574286 = newJObject()
  add(path_574285, "resourceGroupName", newJString(resourceGroupName))
  add(query_574286, "api-version", newJString(apiVersion))
  add(path_574285, "subscriptionId", newJString(subscriptionId))
  add(path_574285, "accountName", newJString(accountName))
  result = call_574284.call(path_574285, query_574286, nil, nil, nil)

var cassandraResourcesListCassandraKeyspaces* = Call_CassandraResourcesListCassandraKeyspaces_574276(
    name: "cassandraResourcesListCassandraKeyspaces", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/cassandraKeyspaces",
    validator: validate_CassandraResourcesListCassandraKeyspaces_574277, base: "",
    url: url_CassandraResourcesListCassandraKeyspaces_574278,
    schemes: {Scheme.Https})
type
  Call_CassandraResourcesCreateUpdateCassandraKeyspace_574299 = ref object of OpenApiRestCall_573668
proc url_CassandraResourcesCreateUpdateCassandraKeyspace_574301(protocol: Scheme;
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

proc validate_CassandraResourcesCreateUpdateCassandraKeyspace_574300(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Create or update an Azure Cosmos DB Cassandra keyspace
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   keyspaceName: JString (required)
  ##               : Cosmos DB keyspace name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574302 = path.getOrDefault("resourceGroupName")
  valid_574302 = validateParameter(valid_574302, JString, required = true,
                                 default = nil)
  if valid_574302 != nil:
    section.add "resourceGroupName", valid_574302
  var valid_574303 = path.getOrDefault("keyspaceName")
  valid_574303 = validateParameter(valid_574303, JString, required = true,
                                 default = nil)
  if valid_574303 != nil:
    section.add "keyspaceName", valid_574303
  var valid_574304 = path.getOrDefault("subscriptionId")
  valid_574304 = validateParameter(valid_574304, JString, required = true,
                                 default = nil)
  if valid_574304 != nil:
    section.add "subscriptionId", valid_574304
  var valid_574305 = path.getOrDefault("accountName")
  valid_574305 = validateParameter(valid_574305, JString, required = true,
                                 default = nil)
  if valid_574305 != nil:
    section.add "accountName", valid_574305
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574306 = query.getOrDefault("api-version")
  valid_574306 = validateParameter(valid_574306, JString, required = true,
                                 default = nil)
  if valid_574306 != nil:
    section.add "api-version", valid_574306
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

proc call*(call_574308: Call_CassandraResourcesCreateUpdateCassandraKeyspace_574299;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB Cassandra keyspace
  ## 
  let valid = call_574308.validator(path, query, header, formData, body)
  let scheme = call_574308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574308.url(scheme.get, call_574308.host, call_574308.base,
                         call_574308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574308, url, valid)

proc call*(call_574309: Call_CassandraResourcesCreateUpdateCassandraKeyspace_574299;
          resourceGroupName: string; apiVersion: string;
          createUpdateCassandraKeyspaceParameters: JsonNode; keyspaceName: string;
          subscriptionId: string; accountName: string): Recallable =
  ## cassandraResourcesCreateUpdateCassandraKeyspace
  ## Create or update an Azure Cosmos DB Cassandra keyspace
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   createUpdateCassandraKeyspaceParameters: JObject (required)
  ##                                          : The parameters to provide for the current Cassandra keyspace.
  ##   keyspaceName: string (required)
  ##               : Cosmos DB keyspace name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574310 = newJObject()
  var query_574311 = newJObject()
  var body_574312 = newJObject()
  add(path_574310, "resourceGroupName", newJString(resourceGroupName))
  add(query_574311, "api-version", newJString(apiVersion))
  if createUpdateCassandraKeyspaceParameters != nil:
    body_574312 = createUpdateCassandraKeyspaceParameters
  add(path_574310, "keyspaceName", newJString(keyspaceName))
  add(path_574310, "subscriptionId", newJString(subscriptionId))
  add(path_574310, "accountName", newJString(accountName))
  result = call_574309.call(path_574310, query_574311, nil, nil, body_574312)

var cassandraResourcesCreateUpdateCassandraKeyspace* = Call_CassandraResourcesCreateUpdateCassandraKeyspace_574299(
    name: "cassandraResourcesCreateUpdateCassandraKeyspace",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/cassandraKeyspaces/{keyspaceName}",
    validator: validate_CassandraResourcesCreateUpdateCassandraKeyspace_574300,
    base: "", url: url_CassandraResourcesCreateUpdateCassandraKeyspace_574301,
    schemes: {Scheme.Https})
type
  Call_CassandraResourcesGetCassandraKeyspace_574287 = ref object of OpenApiRestCall_573668
proc url_CassandraResourcesGetCassandraKeyspace_574289(protocol: Scheme;
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

proc validate_CassandraResourcesGetCassandraKeyspace_574288(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Cassandra keyspaces under an existing Azure Cosmos DB database account with the provided name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   keyspaceName: JString (required)
  ##               : Cosmos DB keyspace name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574290 = path.getOrDefault("resourceGroupName")
  valid_574290 = validateParameter(valid_574290, JString, required = true,
                                 default = nil)
  if valid_574290 != nil:
    section.add "resourceGroupName", valid_574290
  var valid_574291 = path.getOrDefault("keyspaceName")
  valid_574291 = validateParameter(valid_574291, JString, required = true,
                                 default = nil)
  if valid_574291 != nil:
    section.add "keyspaceName", valid_574291
  var valid_574292 = path.getOrDefault("subscriptionId")
  valid_574292 = validateParameter(valid_574292, JString, required = true,
                                 default = nil)
  if valid_574292 != nil:
    section.add "subscriptionId", valid_574292
  var valid_574293 = path.getOrDefault("accountName")
  valid_574293 = validateParameter(valid_574293, JString, required = true,
                                 default = nil)
  if valid_574293 != nil:
    section.add "accountName", valid_574293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574294 = query.getOrDefault("api-version")
  valid_574294 = validateParameter(valid_574294, JString, required = true,
                                 default = nil)
  if valid_574294 != nil:
    section.add "api-version", valid_574294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574295: Call_CassandraResourcesGetCassandraKeyspace_574287;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the Cassandra keyspaces under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_574295.validator(path, query, header, formData, body)
  let scheme = call_574295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574295.url(scheme.get, call_574295.host, call_574295.base,
                         call_574295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574295, url, valid)

proc call*(call_574296: Call_CassandraResourcesGetCassandraKeyspace_574287;
          resourceGroupName: string; apiVersion: string; keyspaceName: string;
          subscriptionId: string; accountName: string): Recallable =
  ## cassandraResourcesGetCassandraKeyspace
  ## Gets the Cassandra keyspaces under an existing Azure Cosmos DB database account with the provided name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   keyspaceName: string (required)
  ##               : Cosmos DB keyspace name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574297 = newJObject()
  var query_574298 = newJObject()
  add(path_574297, "resourceGroupName", newJString(resourceGroupName))
  add(query_574298, "api-version", newJString(apiVersion))
  add(path_574297, "keyspaceName", newJString(keyspaceName))
  add(path_574297, "subscriptionId", newJString(subscriptionId))
  add(path_574297, "accountName", newJString(accountName))
  result = call_574296.call(path_574297, query_574298, nil, nil, nil)

var cassandraResourcesGetCassandraKeyspace* = Call_CassandraResourcesGetCassandraKeyspace_574287(
    name: "cassandraResourcesGetCassandraKeyspace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/cassandraKeyspaces/{keyspaceName}",
    validator: validate_CassandraResourcesGetCassandraKeyspace_574288, base: "",
    url: url_CassandraResourcesGetCassandraKeyspace_574289,
    schemes: {Scheme.Https})
type
  Call_CassandraResourcesDeleteCassandraKeyspace_574313 = ref object of OpenApiRestCall_573668
proc url_CassandraResourcesDeleteCassandraKeyspace_574315(protocol: Scheme;
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

proc validate_CassandraResourcesDeleteCassandraKeyspace_574314(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Azure Cosmos DB Cassandra keyspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   keyspaceName: JString (required)
  ##               : Cosmos DB keyspace name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574316 = path.getOrDefault("resourceGroupName")
  valid_574316 = validateParameter(valid_574316, JString, required = true,
                                 default = nil)
  if valid_574316 != nil:
    section.add "resourceGroupName", valid_574316
  var valid_574317 = path.getOrDefault("keyspaceName")
  valid_574317 = validateParameter(valid_574317, JString, required = true,
                                 default = nil)
  if valid_574317 != nil:
    section.add "keyspaceName", valid_574317
  var valid_574318 = path.getOrDefault("subscriptionId")
  valid_574318 = validateParameter(valid_574318, JString, required = true,
                                 default = nil)
  if valid_574318 != nil:
    section.add "subscriptionId", valid_574318
  var valid_574319 = path.getOrDefault("accountName")
  valid_574319 = validateParameter(valid_574319, JString, required = true,
                                 default = nil)
  if valid_574319 != nil:
    section.add "accountName", valid_574319
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574320 = query.getOrDefault("api-version")
  valid_574320 = validateParameter(valid_574320, JString, required = true,
                                 default = nil)
  if valid_574320 != nil:
    section.add "api-version", valid_574320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574321: Call_CassandraResourcesDeleteCassandraKeyspace_574313;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB Cassandra keyspace.
  ## 
  let valid = call_574321.validator(path, query, header, formData, body)
  let scheme = call_574321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574321.url(scheme.get, call_574321.host, call_574321.base,
                         call_574321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574321, url, valid)

proc call*(call_574322: Call_CassandraResourcesDeleteCassandraKeyspace_574313;
          resourceGroupName: string; apiVersion: string; keyspaceName: string;
          subscriptionId: string; accountName: string): Recallable =
  ## cassandraResourcesDeleteCassandraKeyspace
  ## Deletes an existing Azure Cosmos DB Cassandra keyspace.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   keyspaceName: string (required)
  ##               : Cosmos DB keyspace name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574323 = newJObject()
  var query_574324 = newJObject()
  add(path_574323, "resourceGroupName", newJString(resourceGroupName))
  add(query_574324, "api-version", newJString(apiVersion))
  add(path_574323, "keyspaceName", newJString(keyspaceName))
  add(path_574323, "subscriptionId", newJString(subscriptionId))
  add(path_574323, "accountName", newJString(accountName))
  result = call_574322.call(path_574323, query_574324, nil, nil, nil)

var cassandraResourcesDeleteCassandraKeyspace* = Call_CassandraResourcesDeleteCassandraKeyspace_574313(
    name: "cassandraResourcesDeleteCassandraKeyspace",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/cassandraKeyspaces/{keyspaceName}",
    validator: validate_CassandraResourcesDeleteCassandraKeyspace_574314,
    base: "", url: url_CassandraResourcesDeleteCassandraKeyspace_574315,
    schemes: {Scheme.Https})
type
  Call_CassandraResourcesListCassandraTables_574325 = ref object of OpenApiRestCall_573668
proc url_CassandraResourcesListCassandraTables_574327(protocol: Scheme;
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

proc validate_CassandraResourcesListCassandraTables_574326(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Cassandra table under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   keyspaceName: JString (required)
  ##               : Cosmos DB keyspace name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574328 = path.getOrDefault("resourceGroupName")
  valid_574328 = validateParameter(valid_574328, JString, required = true,
                                 default = nil)
  if valid_574328 != nil:
    section.add "resourceGroupName", valid_574328
  var valid_574329 = path.getOrDefault("keyspaceName")
  valid_574329 = validateParameter(valid_574329, JString, required = true,
                                 default = nil)
  if valid_574329 != nil:
    section.add "keyspaceName", valid_574329
  var valid_574330 = path.getOrDefault("subscriptionId")
  valid_574330 = validateParameter(valid_574330, JString, required = true,
                                 default = nil)
  if valid_574330 != nil:
    section.add "subscriptionId", valid_574330
  var valid_574331 = path.getOrDefault("accountName")
  valid_574331 = validateParameter(valid_574331, JString, required = true,
                                 default = nil)
  if valid_574331 != nil:
    section.add "accountName", valid_574331
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574332 = query.getOrDefault("api-version")
  valid_574332 = validateParameter(valid_574332, JString, required = true,
                                 default = nil)
  if valid_574332 != nil:
    section.add "api-version", valid_574332
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574333: Call_CassandraResourcesListCassandraTables_574325;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Cassandra table under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_574333.validator(path, query, header, formData, body)
  let scheme = call_574333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574333.url(scheme.get, call_574333.host, call_574333.base,
                         call_574333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574333, url, valid)

proc call*(call_574334: Call_CassandraResourcesListCassandraTables_574325;
          resourceGroupName: string; apiVersion: string; keyspaceName: string;
          subscriptionId: string; accountName: string): Recallable =
  ## cassandraResourcesListCassandraTables
  ## Lists the Cassandra table under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   keyspaceName: string (required)
  ##               : Cosmos DB keyspace name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574335 = newJObject()
  var query_574336 = newJObject()
  add(path_574335, "resourceGroupName", newJString(resourceGroupName))
  add(query_574336, "api-version", newJString(apiVersion))
  add(path_574335, "keyspaceName", newJString(keyspaceName))
  add(path_574335, "subscriptionId", newJString(subscriptionId))
  add(path_574335, "accountName", newJString(accountName))
  result = call_574334.call(path_574335, query_574336, nil, nil, nil)

var cassandraResourcesListCassandraTables* = Call_CassandraResourcesListCassandraTables_574325(
    name: "cassandraResourcesListCassandraTables", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/cassandraKeyspaces/{keyspaceName}/tables",
    validator: validate_CassandraResourcesListCassandraTables_574326, base: "",
    url: url_CassandraResourcesListCassandraTables_574327, schemes: {Scheme.Https})
type
  Call_CassandraResourcesCreateUpdateCassandraTable_574350 = ref object of OpenApiRestCall_573668
proc url_CassandraResourcesCreateUpdateCassandraTable_574352(protocol: Scheme;
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

proc validate_CassandraResourcesCreateUpdateCassandraTable_574351(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an Azure Cosmos DB Cassandra Table
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   keyspaceName: JString (required)
  ##               : Cosmos DB keyspace name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   tableName: JString (required)
  ##            : Cosmos DB table name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574353 = path.getOrDefault("resourceGroupName")
  valid_574353 = validateParameter(valid_574353, JString, required = true,
                                 default = nil)
  if valid_574353 != nil:
    section.add "resourceGroupName", valid_574353
  var valid_574354 = path.getOrDefault("keyspaceName")
  valid_574354 = validateParameter(valid_574354, JString, required = true,
                                 default = nil)
  if valid_574354 != nil:
    section.add "keyspaceName", valid_574354
  var valid_574355 = path.getOrDefault("subscriptionId")
  valid_574355 = validateParameter(valid_574355, JString, required = true,
                                 default = nil)
  if valid_574355 != nil:
    section.add "subscriptionId", valid_574355
  var valid_574356 = path.getOrDefault("tableName")
  valid_574356 = validateParameter(valid_574356, JString, required = true,
                                 default = nil)
  if valid_574356 != nil:
    section.add "tableName", valid_574356
  var valid_574357 = path.getOrDefault("accountName")
  valid_574357 = validateParameter(valid_574357, JString, required = true,
                                 default = nil)
  if valid_574357 != nil:
    section.add "accountName", valid_574357
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574358 = query.getOrDefault("api-version")
  valid_574358 = validateParameter(valid_574358, JString, required = true,
                                 default = nil)
  if valid_574358 != nil:
    section.add "api-version", valid_574358
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

proc call*(call_574360: Call_CassandraResourcesCreateUpdateCassandraTable_574350;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB Cassandra Table
  ## 
  let valid = call_574360.validator(path, query, header, formData, body)
  let scheme = call_574360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574360.url(scheme.get, call_574360.host, call_574360.base,
                         call_574360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574360, url, valid)

proc call*(call_574361: Call_CassandraResourcesCreateUpdateCassandraTable_574350;
          resourceGroupName: string; apiVersion: string; keyspaceName: string;
          subscriptionId: string; tableName: string;
          createUpdateCassandraTableParameters: JsonNode; accountName: string): Recallable =
  ## cassandraResourcesCreateUpdateCassandraTable
  ## Create or update an Azure Cosmos DB Cassandra Table
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   keyspaceName: string (required)
  ##               : Cosmos DB keyspace name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   createUpdateCassandraTableParameters: JObject (required)
  ##                                       : The parameters to provide for the current Cassandra Table.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574362 = newJObject()
  var query_574363 = newJObject()
  var body_574364 = newJObject()
  add(path_574362, "resourceGroupName", newJString(resourceGroupName))
  add(query_574363, "api-version", newJString(apiVersion))
  add(path_574362, "keyspaceName", newJString(keyspaceName))
  add(path_574362, "subscriptionId", newJString(subscriptionId))
  add(path_574362, "tableName", newJString(tableName))
  if createUpdateCassandraTableParameters != nil:
    body_574364 = createUpdateCassandraTableParameters
  add(path_574362, "accountName", newJString(accountName))
  result = call_574361.call(path_574362, query_574363, nil, nil, body_574364)

var cassandraResourcesCreateUpdateCassandraTable* = Call_CassandraResourcesCreateUpdateCassandraTable_574350(
    name: "cassandraResourcesCreateUpdateCassandraTable",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/cassandraKeyspaces/{keyspaceName}/tables/{tableName}",
    validator: validate_CassandraResourcesCreateUpdateCassandraTable_574351,
    base: "", url: url_CassandraResourcesCreateUpdateCassandraTable_574352,
    schemes: {Scheme.Https})
type
  Call_CassandraResourcesGetCassandraTable_574337 = ref object of OpenApiRestCall_573668
proc url_CassandraResourcesGetCassandraTable_574339(protocol: Scheme; host: string;
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

proc validate_CassandraResourcesGetCassandraTable_574338(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Cassandra table under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   keyspaceName: JString (required)
  ##               : Cosmos DB keyspace name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   tableName: JString (required)
  ##            : Cosmos DB table name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574340 = path.getOrDefault("resourceGroupName")
  valid_574340 = validateParameter(valid_574340, JString, required = true,
                                 default = nil)
  if valid_574340 != nil:
    section.add "resourceGroupName", valid_574340
  var valid_574341 = path.getOrDefault("keyspaceName")
  valid_574341 = validateParameter(valid_574341, JString, required = true,
                                 default = nil)
  if valid_574341 != nil:
    section.add "keyspaceName", valid_574341
  var valid_574342 = path.getOrDefault("subscriptionId")
  valid_574342 = validateParameter(valid_574342, JString, required = true,
                                 default = nil)
  if valid_574342 != nil:
    section.add "subscriptionId", valid_574342
  var valid_574343 = path.getOrDefault("tableName")
  valid_574343 = validateParameter(valid_574343, JString, required = true,
                                 default = nil)
  if valid_574343 != nil:
    section.add "tableName", valid_574343
  var valid_574344 = path.getOrDefault("accountName")
  valid_574344 = validateParameter(valid_574344, JString, required = true,
                                 default = nil)
  if valid_574344 != nil:
    section.add "accountName", valid_574344
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574345 = query.getOrDefault("api-version")
  valid_574345 = validateParameter(valid_574345, JString, required = true,
                                 default = nil)
  if valid_574345 != nil:
    section.add "api-version", valid_574345
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574346: Call_CassandraResourcesGetCassandraTable_574337;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the Cassandra table under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_574346.validator(path, query, header, formData, body)
  let scheme = call_574346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574346.url(scheme.get, call_574346.host, call_574346.base,
                         call_574346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574346, url, valid)

proc call*(call_574347: Call_CassandraResourcesGetCassandraTable_574337;
          resourceGroupName: string; apiVersion: string; keyspaceName: string;
          subscriptionId: string; tableName: string; accountName: string): Recallable =
  ## cassandraResourcesGetCassandraTable
  ## Gets the Cassandra table under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   keyspaceName: string (required)
  ##               : Cosmos DB keyspace name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574348 = newJObject()
  var query_574349 = newJObject()
  add(path_574348, "resourceGroupName", newJString(resourceGroupName))
  add(query_574349, "api-version", newJString(apiVersion))
  add(path_574348, "keyspaceName", newJString(keyspaceName))
  add(path_574348, "subscriptionId", newJString(subscriptionId))
  add(path_574348, "tableName", newJString(tableName))
  add(path_574348, "accountName", newJString(accountName))
  result = call_574347.call(path_574348, query_574349, nil, nil, nil)

var cassandraResourcesGetCassandraTable* = Call_CassandraResourcesGetCassandraTable_574337(
    name: "cassandraResourcesGetCassandraTable", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/cassandraKeyspaces/{keyspaceName}/tables/{tableName}",
    validator: validate_CassandraResourcesGetCassandraTable_574338, base: "",
    url: url_CassandraResourcesGetCassandraTable_574339, schemes: {Scheme.Https})
type
  Call_CassandraResourcesDeleteCassandraTable_574365 = ref object of OpenApiRestCall_573668
proc url_CassandraResourcesDeleteCassandraTable_574367(protocol: Scheme;
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

proc validate_CassandraResourcesDeleteCassandraTable_574366(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Azure Cosmos DB Cassandra table.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   keyspaceName: JString (required)
  ##               : Cosmos DB keyspace name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   tableName: JString (required)
  ##            : Cosmos DB table name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574368 = path.getOrDefault("resourceGroupName")
  valid_574368 = validateParameter(valid_574368, JString, required = true,
                                 default = nil)
  if valid_574368 != nil:
    section.add "resourceGroupName", valid_574368
  var valid_574369 = path.getOrDefault("keyspaceName")
  valid_574369 = validateParameter(valid_574369, JString, required = true,
                                 default = nil)
  if valid_574369 != nil:
    section.add "keyspaceName", valid_574369
  var valid_574370 = path.getOrDefault("subscriptionId")
  valid_574370 = validateParameter(valid_574370, JString, required = true,
                                 default = nil)
  if valid_574370 != nil:
    section.add "subscriptionId", valid_574370
  var valid_574371 = path.getOrDefault("tableName")
  valid_574371 = validateParameter(valid_574371, JString, required = true,
                                 default = nil)
  if valid_574371 != nil:
    section.add "tableName", valid_574371
  var valid_574372 = path.getOrDefault("accountName")
  valid_574372 = validateParameter(valid_574372, JString, required = true,
                                 default = nil)
  if valid_574372 != nil:
    section.add "accountName", valid_574372
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574373 = query.getOrDefault("api-version")
  valid_574373 = validateParameter(valid_574373, JString, required = true,
                                 default = nil)
  if valid_574373 != nil:
    section.add "api-version", valid_574373
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574374: Call_CassandraResourcesDeleteCassandraTable_574365;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB Cassandra table.
  ## 
  let valid = call_574374.validator(path, query, header, formData, body)
  let scheme = call_574374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574374.url(scheme.get, call_574374.host, call_574374.base,
                         call_574374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574374, url, valid)

proc call*(call_574375: Call_CassandraResourcesDeleteCassandraTable_574365;
          resourceGroupName: string; apiVersion: string; keyspaceName: string;
          subscriptionId: string; tableName: string; accountName: string): Recallable =
  ## cassandraResourcesDeleteCassandraTable
  ## Deletes an existing Azure Cosmos DB Cassandra table.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   keyspaceName: string (required)
  ##               : Cosmos DB keyspace name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574376 = newJObject()
  var query_574377 = newJObject()
  add(path_574376, "resourceGroupName", newJString(resourceGroupName))
  add(query_574377, "api-version", newJString(apiVersion))
  add(path_574376, "keyspaceName", newJString(keyspaceName))
  add(path_574376, "subscriptionId", newJString(subscriptionId))
  add(path_574376, "tableName", newJString(tableName))
  add(path_574376, "accountName", newJString(accountName))
  result = call_574375.call(path_574376, query_574377, nil, nil, nil)

var cassandraResourcesDeleteCassandraTable* = Call_CassandraResourcesDeleteCassandraTable_574365(
    name: "cassandraResourcesDeleteCassandraTable", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/cassandraKeyspaces/{keyspaceName}/tables/{tableName}",
    validator: validate_CassandraResourcesDeleteCassandraTable_574366, base: "",
    url: url_CassandraResourcesDeleteCassandraTable_574367,
    schemes: {Scheme.Https})
type
  Call_CassandraResourcesUpdateCassandraTableThroughput_574391 = ref object of OpenApiRestCall_573668
proc url_CassandraResourcesUpdateCassandraTableThroughput_574393(
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

proc validate_CassandraResourcesUpdateCassandraTableThroughput_574392(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Update RUs per second of an Azure Cosmos DB Cassandra table
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   keyspaceName: JString (required)
  ##               : Cosmos DB keyspace name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   tableName: JString (required)
  ##            : Cosmos DB table name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574394 = path.getOrDefault("resourceGroupName")
  valid_574394 = validateParameter(valid_574394, JString, required = true,
                                 default = nil)
  if valid_574394 != nil:
    section.add "resourceGroupName", valid_574394
  var valid_574395 = path.getOrDefault("keyspaceName")
  valid_574395 = validateParameter(valid_574395, JString, required = true,
                                 default = nil)
  if valid_574395 != nil:
    section.add "keyspaceName", valid_574395
  var valid_574396 = path.getOrDefault("subscriptionId")
  valid_574396 = validateParameter(valid_574396, JString, required = true,
                                 default = nil)
  if valid_574396 != nil:
    section.add "subscriptionId", valid_574396
  var valid_574397 = path.getOrDefault("tableName")
  valid_574397 = validateParameter(valid_574397, JString, required = true,
                                 default = nil)
  if valid_574397 != nil:
    section.add "tableName", valid_574397
  var valid_574398 = path.getOrDefault("accountName")
  valid_574398 = validateParameter(valid_574398, JString, required = true,
                                 default = nil)
  if valid_574398 != nil:
    section.add "accountName", valid_574398
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574399 = query.getOrDefault("api-version")
  valid_574399 = validateParameter(valid_574399, JString, required = true,
                                 default = nil)
  if valid_574399 != nil:
    section.add "api-version", valid_574399
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

proc call*(call_574401: Call_CassandraResourcesUpdateCassandraTableThroughput_574391;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Cassandra table
  ## 
  let valid = call_574401.validator(path, query, header, formData, body)
  let scheme = call_574401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574401.url(scheme.get, call_574401.host, call_574401.base,
                         call_574401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574401, url, valid)

proc call*(call_574402: Call_CassandraResourcesUpdateCassandraTableThroughput_574391;
          resourceGroupName: string; apiVersion: string; keyspaceName: string;
          subscriptionId: string; tableName: string;
          updateThroughputParameters: JsonNode; accountName: string): Recallable =
  ## cassandraResourcesUpdateCassandraTableThroughput
  ## Update RUs per second of an Azure Cosmos DB Cassandra table
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   keyspaceName: string (required)
  ##               : Cosmos DB keyspace name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   updateThroughputParameters: JObject (required)
  ##                             : The RUs per second of the parameters to provide for the current Cassandra table.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574403 = newJObject()
  var query_574404 = newJObject()
  var body_574405 = newJObject()
  add(path_574403, "resourceGroupName", newJString(resourceGroupName))
  add(query_574404, "api-version", newJString(apiVersion))
  add(path_574403, "keyspaceName", newJString(keyspaceName))
  add(path_574403, "subscriptionId", newJString(subscriptionId))
  add(path_574403, "tableName", newJString(tableName))
  if updateThroughputParameters != nil:
    body_574405 = updateThroughputParameters
  add(path_574403, "accountName", newJString(accountName))
  result = call_574402.call(path_574403, query_574404, nil, nil, body_574405)

var cassandraResourcesUpdateCassandraTableThroughput* = Call_CassandraResourcesUpdateCassandraTableThroughput_574391(
    name: "cassandraResourcesUpdateCassandraTableThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/cassandraKeyspaces/{keyspaceName}/tables/{tableName}/throughputSettings/default",
    validator: validate_CassandraResourcesUpdateCassandraTableThroughput_574392,
    base: "", url: url_CassandraResourcesUpdateCassandraTableThroughput_574393,
    schemes: {Scheme.Https})
type
  Call_CassandraResourcesGetCassandraTableThroughput_574378 = ref object of OpenApiRestCall_573668
proc url_CassandraResourcesGetCassandraTableThroughput_574380(protocol: Scheme;
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

proc validate_CassandraResourcesGetCassandraTableThroughput_574379(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the RUs per second of the Cassandra table under an existing Azure Cosmos DB database account with the provided name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   keyspaceName: JString (required)
  ##               : Cosmos DB keyspace name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   tableName: JString (required)
  ##            : Cosmos DB table name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574381 = path.getOrDefault("resourceGroupName")
  valid_574381 = validateParameter(valid_574381, JString, required = true,
                                 default = nil)
  if valid_574381 != nil:
    section.add "resourceGroupName", valid_574381
  var valid_574382 = path.getOrDefault("keyspaceName")
  valid_574382 = validateParameter(valid_574382, JString, required = true,
                                 default = nil)
  if valid_574382 != nil:
    section.add "keyspaceName", valid_574382
  var valid_574383 = path.getOrDefault("subscriptionId")
  valid_574383 = validateParameter(valid_574383, JString, required = true,
                                 default = nil)
  if valid_574383 != nil:
    section.add "subscriptionId", valid_574383
  var valid_574384 = path.getOrDefault("tableName")
  valid_574384 = validateParameter(valid_574384, JString, required = true,
                                 default = nil)
  if valid_574384 != nil:
    section.add "tableName", valid_574384
  var valid_574385 = path.getOrDefault("accountName")
  valid_574385 = validateParameter(valid_574385, JString, required = true,
                                 default = nil)
  if valid_574385 != nil:
    section.add "accountName", valid_574385
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574386 = query.getOrDefault("api-version")
  valid_574386 = validateParameter(valid_574386, JString, required = true,
                                 default = nil)
  if valid_574386 != nil:
    section.add "api-version", valid_574386
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574387: Call_CassandraResourcesGetCassandraTableThroughput_574378;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the Cassandra table under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_574387.validator(path, query, header, formData, body)
  let scheme = call_574387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574387.url(scheme.get, call_574387.host, call_574387.base,
                         call_574387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574387, url, valid)

proc call*(call_574388: Call_CassandraResourcesGetCassandraTableThroughput_574378;
          resourceGroupName: string; apiVersion: string; keyspaceName: string;
          subscriptionId: string; tableName: string; accountName: string): Recallable =
  ## cassandraResourcesGetCassandraTableThroughput
  ## Gets the RUs per second of the Cassandra table under an existing Azure Cosmos DB database account with the provided name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   keyspaceName: string (required)
  ##               : Cosmos DB keyspace name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574389 = newJObject()
  var query_574390 = newJObject()
  add(path_574389, "resourceGroupName", newJString(resourceGroupName))
  add(query_574390, "api-version", newJString(apiVersion))
  add(path_574389, "keyspaceName", newJString(keyspaceName))
  add(path_574389, "subscriptionId", newJString(subscriptionId))
  add(path_574389, "tableName", newJString(tableName))
  add(path_574389, "accountName", newJString(accountName))
  result = call_574388.call(path_574389, query_574390, nil, nil, nil)

var cassandraResourcesGetCassandraTableThroughput* = Call_CassandraResourcesGetCassandraTableThroughput_574378(
    name: "cassandraResourcesGetCassandraTableThroughput",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/cassandraKeyspaces/{keyspaceName}/tables/{tableName}/throughputSettings/default",
    validator: validate_CassandraResourcesGetCassandraTableThroughput_574379,
    base: "", url: url_CassandraResourcesGetCassandraTableThroughput_574380,
    schemes: {Scheme.Https})
type
  Call_CassandraResourcesUpdateCassandraKeyspaceThroughput_574418 = ref object of OpenApiRestCall_573668
proc url_CassandraResourcesUpdateCassandraKeyspaceThroughput_574420(
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

proc validate_CassandraResourcesUpdateCassandraKeyspaceThroughput_574419(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Update RUs per second of an Azure Cosmos DB Cassandra Keyspace
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   keyspaceName: JString (required)
  ##               : Cosmos DB keyspace name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574421 = path.getOrDefault("resourceGroupName")
  valid_574421 = validateParameter(valid_574421, JString, required = true,
                                 default = nil)
  if valid_574421 != nil:
    section.add "resourceGroupName", valid_574421
  var valid_574422 = path.getOrDefault("keyspaceName")
  valid_574422 = validateParameter(valid_574422, JString, required = true,
                                 default = nil)
  if valid_574422 != nil:
    section.add "keyspaceName", valid_574422
  var valid_574423 = path.getOrDefault("subscriptionId")
  valid_574423 = validateParameter(valid_574423, JString, required = true,
                                 default = nil)
  if valid_574423 != nil:
    section.add "subscriptionId", valid_574423
  var valid_574424 = path.getOrDefault("accountName")
  valid_574424 = validateParameter(valid_574424, JString, required = true,
                                 default = nil)
  if valid_574424 != nil:
    section.add "accountName", valid_574424
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574425 = query.getOrDefault("api-version")
  valid_574425 = validateParameter(valid_574425, JString, required = true,
                                 default = nil)
  if valid_574425 != nil:
    section.add "api-version", valid_574425
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

proc call*(call_574427: Call_CassandraResourcesUpdateCassandraKeyspaceThroughput_574418;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Cassandra Keyspace
  ## 
  let valid = call_574427.validator(path, query, header, formData, body)
  let scheme = call_574427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574427.url(scheme.get, call_574427.host, call_574427.base,
                         call_574427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574427, url, valid)

proc call*(call_574428: Call_CassandraResourcesUpdateCassandraKeyspaceThroughput_574418;
          resourceGroupName: string; apiVersion: string; keyspaceName: string;
          subscriptionId: string; updateThroughputParameters: JsonNode;
          accountName: string): Recallable =
  ## cassandraResourcesUpdateCassandraKeyspaceThroughput
  ## Update RUs per second of an Azure Cosmos DB Cassandra Keyspace
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   keyspaceName: string (required)
  ##               : Cosmos DB keyspace name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   updateThroughputParameters: JObject (required)
  ##                             : The RUs per second of the parameters to provide for the current Cassandra Keyspace.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574429 = newJObject()
  var query_574430 = newJObject()
  var body_574431 = newJObject()
  add(path_574429, "resourceGroupName", newJString(resourceGroupName))
  add(query_574430, "api-version", newJString(apiVersion))
  add(path_574429, "keyspaceName", newJString(keyspaceName))
  add(path_574429, "subscriptionId", newJString(subscriptionId))
  if updateThroughputParameters != nil:
    body_574431 = updateThroughputParameters
  add(path_574429, "accountName", newJString(accountName))
  result = call_574428.call(path_574429, query_574430, nil, nil, body_574431)

var cassandraResourcesUpdateCassandraKeyspaceThroughput* = Call_CassandraResourcesUpdateCassandraKeyspaceThroughput_574418(
    name: "cassandraResourcesUpdateCassandraKeyspaceThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/cassandraKeyspaces/{keyspaceName}/throughputSettings/default",
    validator: validate_CassandraResourcesUpdateCassandraKeyspaceThroughput_574419,
    base: "", url: url_CassandraResourcesUpdateCassandraKeyspaceThroughput_574420,
    schemes: {Scheme.Https})
type
  Call_CassandraResourcesGetCassandraKeyspaceThroughput_574406 = ref object of OpenApiRestCall_573668
proc url_CassandraResourcesGetCassandraKeyspaceThroughput_574408(
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

proc validate_CassandraResourcesGetCassandraKeyspaceThroughput_574407(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the RUs per second of the Cassandra Keyspace under an existing Azure Cosmos DB database account with the provided name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   keyspaceName: JString (required)
  ##               : Cosmos DB keyspace name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574409 = path.getOrDefault("resourceGroupName")
  valid_574409 = validateParameter(valid_574409, JString, required = true,
                                 default = nil)
  if valid_574409 != nil:
    section.add "resourceGroupName", valid_574409
  var valid_574410 = path.getOrDefault("keyspaceName")
  valid_574410 = validateParameter(valid_574410, JString, required = true,
                                 default = nil)
  if valid_574410 != nil:
    section.add "keyspaceName", valid_574410
  var valid_574411 = path.getOrDefault("subscriptionId")
  valid_574411 = validateParameter(valid_574411, JString, required = true,
                                 default = nil)
  if valid_574411 != nil:
    section.add "subscriptionId", valid_574411
  var valid_574412 = path.getOrDefault("accountName")
  valid_574412 = validateParameter(valid_574412, JString, required = true,
                                 default = nil)
  if valid_574412 != nil:
    section.add "accountName", valid_574412
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574413 = query.getOrDefault("api-version")
  valid_574413 = validateParameter(valid_574413, JString, required = true,
                                 default = nil)
  if valid_574413 != nil:
    section.add "api-version", valid_574413
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574414: Call_CassandraResourcesGetCassandraKeyspaceThroughput_574406;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the Cassandra Keyspace under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_574414.validator(path, query, header, formData, body)
  let scheme = call_574414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574414.url(scheme.get, call_574414.host, call_574414.base,
                         call_574414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574414, url, valid)

proc call*(call_574415: Call_CassandraResourcesGetCassandraKeyspaceThroughput_574406;
          resourceGroupName: string; apiVersion: string; keyspaceName: string;
          subscriptionId: string; accountName: string): Recallable =
  ## cassandraResourcesGetCassandraKeyspaceThroughput
  ## Gets the RUs per second of the Cassandra Keyspace under an existing Azure Cosmos DB database account with the provided name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   keyspaceName: string (required)
  ##               : Cosmos DB keyspace name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574416 = newJObject()
  var query_574417 = newJObject()
  add(path_574416, "resourceGroupName", newJString(resourceGroupName))
  add(query_574417, "api-version", newJString(apiVersion))
  add(path_574416, "keyspaceName", newJString(keyspaceName))
  add(path_574416, "subscriptionId", newJString(subscriptionId))
  add(path_574416, "accountName", newJString(accountName))
  result = call_574415.call(path_574416, query_574417, nil, nil, nil)

var cassandraResourcesGetCassandraKeyspaceThroughput* = Call_CassandraResourcesGetCassandraKeyspaceThroughput_574406(
    name: "cassandraResourcesGetCassandraKeyspaceThroughput",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/cassandraKeyspaces/{keyspaceName}/throughputSettings/default",
    validator: validate_CassandraResourcesGetCassandraKeyspaceThroughput_574407,
    base: "", url: url_CassandraResourcesGetCassandraKeyspaceThroughput_574408,
    schemes: {Scheme.Https})
type
  Call_CollectionListMetricDefinitions_574432 = ref object of OpenApiRestCall_573668
proc url_CollectionListMetricDefinitions_574434(protocol: Scheme; host: string;
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

proc validate_CollectionListMetricDefinitions_574433(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves metric definitions for the given collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   collectionRid: JString (required)
  ##                : Cosmos DB collection rid.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: JString (required)
  ##              : Cosmos DB database rid.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574435 = path.getOrDefault("resourceGroupName")
  valid_574435 = validateParameter(valid_574435, JString, required = true,
                                 default = nil)
  if valid_574435 != nil:
    section.add "resourceGroupName", valid_574435
  var valid_574436 = path.getOrDefault("collectionRid")
  valid_574436 = validateParameter(valid_574436, JString, required = true,
                                 default = nil)
  if valid_574436 != nil:
    section.add "collectionRid", valid_574436
  var valid_574437 = path.getOrDefault("subscriptionId")
  valid_574437 = validateParameter(valid_574437, JString, required = true,
                                 default = nil)
  if valid_574437 != nil:
    section.add "subscriptionId", valid_574437
  var valid_574438 = path.getOrDefault("databaseRid")
  valid_574438 = validateParameter(valid_574438, JString, required = true,
                                 default = nil)
  if valid_574438 != nil:
    section.add "databaseRid", valid_574438
  var valid_574439 = path.getOrDefault("accountName")
  valid_574439 = validateParameter(valid_574439, JString, required = true,
                                 default = nil)
  if valid_574439 != nil:
    section.add "accountName", valid_574439
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574440 = query.getOrDefault("api-version")
  valid_574440 = validateParameter(valid_574440, JString, required = true,
                                 default = nil)
  if valid_574440 != nil:
    section.add "api-version", valid_574440
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574441: Call_CollectionListMetricDefinitions_574432;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves metric definitions for the given collection.
  ## 
  let valid = call_574441.validator(path, query, header, formData, body)
  let scheme = call_574441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574441.url(scheme.get, call_574441.host, call_574441.base,
                         call_574441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574441, url, valid)

proc call*(call_574442: Call_CollectionListMetricDefinitions_574432;
          resourceGroupName: string; apiVersion: string; collectionRid: string;
          subscriptionId: string; databaseRid: string; accountName: string): Recallable =
  ## collectionListMetricDefinitions
  ## Retrieves metric definitions for the given collection.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   collectionRid: string (required)
  ##                : Cosmos DB collection rid.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: string (required)
  ##              : Cosmos DB database rid.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574443 = newJObject()
  var query_574444 = newJObject()
  add(path_574443, "resourceGroupName", newJString(resourceGroupName))
  add(query_574444, "api-version", newJString(apiVersion))
  add(path_574443, "collectionRid", newJString(collectionRid))
  add(path_574443, "subscriptionId", newJString(subscriptionId))
  add(path_574443, "databaseRid", newJString(databaseRid))
  add(path_574443, "accountName", newJString(accountName))
  result = call_574442.call(path_574443, query_574444, nil, nil, nil)

var collectionListMetricDefinitions* = Call_CollectionListMetricDefinitions_574432(
    name: "collectionListMetricDefinitions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/metricDefinitions",
    validator: validate_CollectionListMetricDefinitions_574433, base: "",
    url: url_CollectionListMetricDefinitions_574434, schemes: {Scheme.Https})
type
  Call_CollectionListMetrics_574445 = ref object of OpenApiRestCall_573668
proc url_CollectionListMetrics_574447(protocol: Scheme; host: string; base: string;
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

proc validate_CollectionListMetrics_574446(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the metrics determined by the given filter for the given database account and collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   collectionRid: JString (required)
  ##                : Cosmos DB collection rid.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: JString (required)
  ##              : Cosmos DB database rid.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574449 = path.getOrDefault("resourceGroupName")
  valid_574449 = validateParameter(valid_574449, JString, required = true,
                                 default = nil)
  if valid_574449 != nil:
    section.add "resourceGroupName", valid_574449
  var valid_574450 = path.getOrDefault("collectionRid")
  valid_574450 = validateParameter(valid_574450, JString, required = true,
                                 default = nil)
  if valid_574450 != nil:
    section.add "collectionRid", valid_574450
  var valid_574451 = path.getOrDefault("subscriptionId")
  valid_574451 = validateParameter(valid_574451, JString, required = true,
                                 default = nil)
  if valid_574451 != nil:
    section.add "subscriptionId", valid_574451
  var valid_574452 = path.getOrDefault("databaseRid")
  valid_574452 = validateParameter(valid_574452, JString, required = true,
                                 default = nil)
  if valid_574452 != nil:
    section.add "databaseRid", valid_574452
  var valid_574453 = path.getOrDefault("accountName")
  valid_574453 = validateParameter(valid_574453, JString, required = true,
                                 default = nil)
  if valid_574453 != nil:
    section.add "accountName", valid_574453
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574454 = query.getOrDefault("api-version")
  valid_574454 = validateParameter(valid_574454, JString, required = true,
                                 default = nil)
  if valid_574454 != nil:
    section.add "api-version", valid_574454
  var valid_574455 = query.getOrDefault("$filter")
  valid_574455 = validateParameter(valid_574455, JString, required = true,
                                 default = nil)
  if valid_574455 != nil:
    section.add "$filter", valid_574455
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574456: Call_CollectionListMetrics_574445; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account and collection.
  ## 
  let valid = call_574456.validator(path, query, header, formData, body)
  let scheme = call_574456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574456.url(scheme.get, call_574456.host, call_574456.base,
                         call_574456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574456, url, valid)

proc call*(call_574457: Call_CollectionListMetrics_574445;
          resourceGroupName: string; apiVersion: string; collectionRid: string;
          subscriptionId: string; databaseRid: string; accountName: string;
          Filter: string): Recallable =
  ## collectionListMetrics
  ## Retrieves the metrics determined by the given filter for the given database account and collection.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   collectionRid: string (required)
  ##                : Cosmos DB collection rid.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: string (required)
  ##              : Cosmos DB database rid.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  var path_574458 = newJObject()
  var query_574459 = newJObject()
  add(path_574458, "resourceGroupName", newJString(resourceGroupName))
  add(query_574459, "api-version", newJString(apiVersion))
  add(path_574458, "collectionRid", newJString(collectionRid))
  add(path_574458, "subscriptionId", newJString(subscriptionId))
  add(path_574458, "databaseRid", newJString(databaseRid))
  add(path_574458, "accountName", newJString(accountName))
  add(query_574459, "$filter", newJString(Filter))
  result = call_574457.call(path_574458, query_574459, nil, nil, nil)

var collectionListMetrics* = Call_CollectionListMetrics_574445(
    name: "collectionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/metrics",
    validator: validate_CollectionListMetrics_574446, base: "",
    url: url_CollectionListMetrics_574447, schemes: {Scheme.Https})
type
  Call_PartitionKeyRangeIdListMetrics_574460 = ref object of OpenApiRestCall_573668
proc url_PartitionKeyRangeIdListMetrics_574462(protocol: Scheme; host: string;
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

proc validate_PartitionKeyRangeIdListMetrics_574461(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the metrics determined by the given filter for the given partition key range id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   collectionRid: JString (required)
  ##                : Cosmos DB collection rid.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   partitionKeyRangeId: JString (required)
  ##                      : Partition Key Range Id for which to get data.
  ##   databaseRid: JString (required)
  ##              : Cosmos DB database rid.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574463 = path.getOrDefault("resourceGroupName")
  valid_574463 = validateParameter(valid_574463, JString, required = true,
                                 default = nil)
  if valid_574463 != nil:
    section.add "resourceGroupName", valid_574463
  var valid_574464 = path.getOrDefault("collectionRid")
  valid_574464 = validateParameter(valid_574464, JString, required = true,
                                 default = nil)
  if valid_574464 != nil:
    section.add "collectionRid", valid_574464
  var valid_574465 = path.getOrDefault("subscriptionId")
  valid_574465 = validateParameter(valid_574465, JString, required = true,
                                 default = nil)
  if valid_574465 != nil:
    section.add "subscriptionId", valid_574465
  var valid_574466 = path.getOrDefault("partitionKeyRangeId")
  valid_574466 = validateParameter(valid_574466, JString, required = true,
                                 default = nil)
  if valid_574466 != nil:
    section.add "partitionKeyRangeId", valid_574466
  var valid_574467 = path.getOrDefault("databaseRid")
  valid_574467 = validateParameter(valid_574467, JString, required = true,
                                 default = nil)
  if valid_574467 != nil:
    section.add "databaseRid", valid_574467
  var valid_574468 = path.getOrDefault("accountName")
  valid_574468 = validateParameter(valid_574468, JString, required = true,
                                 default = nil)
  if valid_574468 != nil:
    section.add "accountName", valid_574468
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574469 = query.getOrDefault("api-version")
  valid_574469 = validateParameter(valid_574469, JString, required = true,
                                 default = nil)
  if valid_574469 != nil:
    section.add "api-version", valid_574469
  var valid_574470 = query.getOrDefault("$filter")
  valid_574470 = validateParameter(valid_574470, JString, required = true,
                                 default = nil)
  if valid_574470 != nil:
    section.add "$filter", valid_574470
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574471: Call_PartitionKeyRangeIdListMetrics_574460; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given partition key range id.
  ## 
  let valid = call_574471.validator(path, query, header, formData, body)
  let scheme = call_574471.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574471.url(scheme.get, call_574471.host, call_574471.base,
                         call_574471.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574471, url, valid)

proc call*(call_574472: Call_PartitionKeyRangeIdListMetrics_574460;
          resourceGroupName: string; apiVersion: string; collectionRid: string;
          subscriptionId: string; partitionKeyRangeId: string; databaseRid: string;
          accountName: string; Filter: string): Recallable =
  ## partitionKeyRangeIdListMetrics
  ## Retrieves the metrics determined by the given filter for the given partition key range id.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   collectionRid: string (required)
  ##                : Cosmos DB collection rid.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   partitionKeyRangeId: string (required)
  ##                      : Partition Key Range Id for which to get data.
  ##   databaseRid: string (required)
  ##              : Cosmos DB database rid.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  var path_574473 = newJObject()
  var query_574474 = newJObject()
  add(path_574473, "resourceGroupName", newJString(resourceGroupName))
  add(query_574474, "api-version", newJString(apiVersion))
  add(path_574473, "collectionRid", newJString(collectionRid))
  add(path_574473, "subscriptionId", newJString(subscriptionId))
  add(path_574473, "partitionKeyRangeId", newJString(partitionKeyRangeId))
  add(path_574473, "databaseRid", newJString(databaseRid))
  add(path_574473, "accountName", newJString(accountName))
  add(query_574474, "$filter", newJString(Filter))
  result = call_574472.call(path_574473, query_574474, nil, nil, nil)

var partitionKeyRangeIdListMetrics* = Call_PartitionKeyRangeIdListMetrics_574460(
    name: "partitionKeyRangeIdListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/partitionKeyRangeId/{partitionKeyRangeId}/metrics",
    validator: validate_PartitionKeyRangeIdListMetrics_574461, base: "",
    url: url_PartitionKeyRangeIdListMetrics_574462, schemes: {Scheme.Https})
type
  Call_CollectionPartitionListMetrics_574475 = ref object of OpenApiRestCall_573668
proc url_CollectionPartitionListMetrics_574477(protocol: Scheme; host: string;
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

proc validate_CollectionPartitionListMetrics_574476(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the metrics determined by the given filter for the given collection, split by partition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   collectionRid: JString (required)
  ##                : Cosmos DB collection rid.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: JString (required)
  ##              : Cosmos DB database rid.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574478 = path.getOrDefault("resourceGroupName")
  valid_574478 = validateParameter(valid_574478, JString, required = true,
                                 default = nil)
  if valid_574478 != nil:
    section.add "resourceGroupName", valid_574478
  var valid_574479 = path.getOrDefault("collectionRid")
  valid_574479 = validateParameter(valid_574479, JString, required = true,
                                 default = nil)
  if valid_574479 != nil:
    section.add "collectionRid", valid_574479
  var valid_574480 = path.getOrDefault("subscriptionId")
  valid_574480 = validateParameter(valid_574480, JString, required = true,
                                 default = nil)
  if valid_574480 != nil:
    section.add "subscriptionId", valid_574480
  var valid_574481 = path.getOrDefault("databaseRid")
  valid_574481 = validateParameter(valid_574481, JString, required = true,
                                 default = nil)
  if valid_574481 != nil:
    section.add "databaseRid", valid_574481
  var valid_574482 = path.getOrDefault("accountName")
  valid_574482 = validateParameter(valid_574482, JString, required = true,
                                 default = nil)
  if valid_574482 != nil:
    section.add "accountName", valid_574482
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574483 = query.getOrDefault("api-version")
  valid_574483 = validateParameter(valid_574483, JString, required = true,
                                 default = nil)
  if valid_574483 != nil:
    section.add "api-version", valid_574483
  var valid_574484 = query.getOrDefault("$filter")
  valid_574484 = validateParameter(valid_574484, JString, required = true,
                                 default = nil)
  if valid_574484 != nil:
    section.add "$filter", valid_574484
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574485: Call_CollectionPartitionListMetrics_574475; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given collection, split by partition.
  ## 
  let valid = call_574485.validator(path, query, header, formData, body)
  let scheme = call_574485.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574485.url(scheme.get, call_574485.host, call_574485.base,
                         call_574485.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574485, url, valid)

proc call*(call_574486: Call_CollectionPartitionListMetrics_574475;
          resourceGroupName: string; apiVersion: string; collectionRid: string;
          subscriptionId: string; databaseRid: string; accountName: string;
          Filter: string): Recallable =
  ## collectionPartitionListMetrics
  ## Retrieves the metrics determined by the given filter for the given collection, split by partition.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   collectionRid: string (required)
  ##                : Cosmos DB collection rid.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: string (required)
  ##              : Cosmos DB database rid.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  var path_574487 = newJObject()
  var query_574488 = newJObject()
  add(path_574487, "resourceGroupName", newJString(resourceGroupName))
  add(query_574488, "api-version", newJString(apiVersion))
  add(path_574487, "collectionRid", newJString(collectionRid))
  add(path_574487, "subscriptionId", newJString(subscriptionId))
  add(path_574487, "databaseRid", newJString(databaseRid))
  add(path_574487, "accountName", newJString(accountName))
  add(query_574488, "$filter", newJString(Filter))
  result = call_574486.call(path_574487, query_574488, nil, nil, nil)

var collectionPartitionListMetrics* = Call_CollectionPartitionListMetrics_574475(
    name: "collectionPartitionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/partitions/metrics",
    validator: validate_CollectionPartitionListMetrics_574476, base: "",
    url: url_CollectionPartitionListMetrics_574477, schemes: {Scheme.Https})
type
  Call_CollectionPartitionListUsages_574489 = ref object of OpenApiRestCall_573668
proc url_CollectionPartitionListUsages_574491(protocol: Scheme; host: string;
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

proc validate_CollectionPartitionListUsages_574490(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the usages (most recent storage data) for the given collection, split by partition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   collectionRid: JString (required)
  ##                : Cosmos DB collection rid.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: JString (required)
  ##              : Cosmos DB database rid.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574492 = path.getOrDefault("resourceGroupName")
  valid_574492 = validateParameter(valid_574492, JString, required = true,
                                 default = nil)
  if valid_574492 != nil:
    section.add "resourceGroupName", valid_574492
  var valid_574493 = path.getOrDefault("collectionRid")
  valid_574493 = validateParameter(valid_574493, JString, required = true,
                                 default = nil)
  if valid_574493 != nil:
    section.add "collectionRid", valid_574493
  var valid_574494 = path.getOrDefault("subscriptionId")
  valid_574494 = validateParameter(valid_574494, JString, required = true,
                                 default = nil)
  if valid_574494 != nil:
    section.add "subscriptionId", valid_574494
  var valid_574495 = path.getOrDefault("databaseRid")
  valid_574495 = validateParameter(valid_574495, JString, required = true,
                                 default = nil)
  if valid_574495 != nil:
    section.add "databaseRid", valid_574495
  var valid_574496 = path.getOrDefault("accountName")
  valid_574496 = validateParameter(valid_574496, JString, required = true,
                                 default = nil)
  if valid_574496 != nil:
    section.add "accountName", valid_574496
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString
  ##          : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574497 = query.getOrDefault("api-version")
  valid_574497 = validateParameter(valid_574497, JString, required = true,
                                 default = nil)
  if valid_574497 != nil:
    section.add "api-version", valid_574497
  var valid_574498 = query.getOrDefault("$filter")
  valid_574498 = validateParameter(valid_574498, JString, required = false,
                                 default = nil)
  if valid_574498 != nil:
    section.add "$filter", valid_574498
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574499: Call_CollectionPartitionListUsages_574489; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the usages (most recent storage data) for the given collection, split by partition.
  ## 
  let valid = call_574499.validator(path, query, header, formData, body)
  let scheme = call_574499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574499.url(scheme.get, call_574499.host, call_574499.base,
                         call_574499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574499, url, valid)

proc call*(call_574500: Call_CollectionPartitionListUsages_574489;
          resourceGroupName: string; apiVersion: string; collectionRid: string;
          subscriptionId: string; databaseRid: string; accountName: string;
          Filter: string = ""): Recallable =
  ## collectionPartitionListUsages
  ## Retrieves the usages (most recent storage data) for the given collection, split by partition.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   collectionRid: string (required)
  ##                : Cosmos DB collection rid.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: string (required)
  ##              : Cosmos DB database rid.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   Filter: string
  ##         : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  var path_574501 = newJObject()
  var query_574502 = newJObject()
  add(path_574501, "resourceGroupName", newJString(resourceGroupName))
  add(query_574502, "api-version", newJString(apiVersion))
  add(path_574501, "collectionRid", newJString(collectionRid))
  add(path_574501, "subscriptionId", newJString(subscriptionId))
  add(path_574501, "databaseRid", newJString(databaseRid))
  add(path_574501, "accountName", newJString(accountName))
  add(query_574502, "$filter", newJString(Filter))
  result = call_574500.call(path_574501, query_574502, nil, nil, nil)

var collectionPartitionListUsages* = Call_CollectionPartitionListUsages_574489(
    name: "collectionPartitionListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/partitions/usages",
    validator: validate_CollectionPartitionListUsages_574490, base: "",
    url: url_CollectionPartitionListUsages_574491, schemes: {Scheme.Https})
type
  Call_CollectionListUsages_574503 = ref object of OpenApiRestCall_573668
proc url_CollectionListUsages_574505(protocol: Scheme; host: string; base: string;
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

proc validate_CollectionListUsages_574504(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the usages (most recent storage data) for the given collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   collectionRid: JString (required)
  ##                : Cosmos DB collection rid.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: JString (required)
  ##              : Cosmos DB database rid.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574506 = path.getOrDefault("resourceGroupName")
  valid_574506 = validateParameter(valid_574506, JString, required = true,
                                 default = nil)
  if valid_574506 != nil:
    section.add "resourceGroupName", valid_574506
  var valid_574507 = path.getOrDefault("collectionRid")
  valid_574507 = validateParameter(valid_574507, JString, required = true,
                                 default = nil)
  if valid_574507 != nil:
    section.add "collectionRid", valid_574507
  var valid_574508 = path.getOrDefault("subscriptionId")
  valid_574508 = validateParameter(valid_574508, JString, required = true,
                                 default = nil)
  if valid_574508 != nil:
    section.add "subscriptionId", valid_574508
  var valid_574509 = path.getOrDefault("databaseRid")
  valid_574509 = validateParameter(valid_574509, JString, required = true,
                                 default = nil)
  if valid_574509 != nil:
    section.add "databaseRid", valid_574509
  var valid_574510 = path.getOrDefault("accountName")
  valid_574510 = validateParameter(valid_574510, JString, required = true,
                                 default = nil)
  if valid_574510 != nil:
    section.add "accountName", valid_574510
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString
  ##          : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574511 = query.getOrDefault("api-version")
  valid_574511 = validateParameter(valid_574511, JString, required = true,
                                 default = nil)
  if valid_574511 != nil:
    section.add "api-version", valid_574511
  var valid_574512 = query.getOrDefault("$filter")
  valid_574512 = validateParameter(valid_574512, JString, required = false,
                                 default = nil)
  if valid_574512 != nil:
    section.add "$filter", valid_574512
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574513: Call_CollectionListUsages_574503; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the usages (most recent storage data) for the given collection.
  ## 
  let valid = call_574513.validator(path, query, header, formData, body)
  let scheme = call_574513.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574513.url(scheme.get, call_574513.host, call_574513.base,
                         call_574513.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574513, url, valid)

proc call*(call_574514: Call_CollectionListUsages_574503;
          resourceGroupName: string; apiVersion: string; collectionRid: string;
          subscriptionId: string; databaseRid: string; accountName: string;
          Filter: string = ""): Recallable =
  ## collectionListUsages
  ## Retrieves the usages (most recent storage data) for the given collection.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   collectionRid: string (required)
  ##                : Cosmos DB collection rid.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: string (required)
  ##              : Cosmos DB database rid.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   Filter: string
  ##         : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  var path_574515 = newJObject()
  var query_574516 = newJObject()
  add(path_574515, "resourceGroupName", newJString(resourceGroupName))
  add(query_574516, "api-version", newJString(apiVersion))
  add(path_574515, "collectionRid", newJString(collectionRid))
  add(path_574515, "subscriptionId", newJString(subscriptionId))
  add(path_574515, "databaseRid", newJString(databaseRid))
  add(path_574515, "accountName", newJString(accountName))
  add(query_574516, "$filter", newJString(Filter))
  result = call_574514.call(path_574515, query_574516, nil, nil, nil)

var collectionListUsages* = Call_CollectionListUsages_574503(
    name: "collectionListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/usages",
    validator: validate_CollectionListUsages_574504, base: "",
    url: url_CollectionListUsages_574505, schemes: {Scheme.Https})
type
  Call_DatabaseListMetricDefinitions_574517 = ref object of OpenApiRestCall_573668
proc url_DatabaseListMetricDefinitions_574519(protocol: Scheme; host: string;
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

proc validate_DatabaseListMetricDefinitions_574518(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves metric definitions for the given database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: JString (required)
  ##              : Cosmos DB database rid.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574520 = path.getOrDefault("resourceGroupName")
  valid_574520 = validateParameter(valid_574520, JString, required = true,
                                 default = nil)
  if valid_574520 != nil:
    section.add "resourceGroupName", valid_574520
  var valid_574521 = path.getOrDefault("subscriptionId")
  valid_574521 = validateParameter(valid_574521, JString, required = true,
                                 default = nil)
  if valid_574521 != nil:
    section.add "subscriptionId", valid_574521
  var valid_574522 = path.getOrDefault("databaseRid")
  valid_574522 = validateParameter(valid_574522, JString, required = true,
                                 default = nil)
  if valid_574522 != nil:
    section.add "databaseRid", valid_574522
  var valid_574523 = path.getOrDefault("accountName")
  valid_574523 = validateParameter(valid_574523, JString, required = true,
                                 default = nil)
  if valid_574523 != nil:
    section.add "accountName", valid_574523
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574524 = query.getOrDefault("api-version")
  valid_574524 = validateParameter(valid_574524, JString, required = true,
                                 default = nil)
  if valid_574524 != nil:
    section.add "api-version", valid_574524
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574525: Call_DatabaseListMetricDefinitions_574517; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves metric definitions for the given database.
  ## 
  let valid = call_574525.validator(path, query, header, formData, body)
  let scheme = call_574525.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574525.url(scheme.get, call_574525.host, call_574525.base,
                         call_574525.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574525, url, valid)

proc call*(call_574526: Call_DatabaseListMetricDefinitions_574517;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseRid: string; accountName: string): Recallable =
  ## databaseListMetricDefinitions
  ## Retrieves metric definitions for the given database.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: string (required)
  ##              : Cosmos DB database rid.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574527 = newJObject()
  var query_574528 = newJObject()
  add(path_574527, "resourceGroupName", newJString(resourceGroupName))
  add(query_574528, "api-version", newJString(apiVersion))
  add(path_574527, "subscriptionId", newJString(subscriptionId))
  add(path_574527, "databaseRid", newJString(databaseRid))
  add(path_574527, "accountName", newJString(accountName))
  result = call_574526.call(path_574527, query_574528, nil, nil, nil)

var databaseListMetricDefinitions* = Call_DatabaseListMetricDefinitions_574517(
    name: "databaseListMetricDefinitions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/metricDefinitions",
    validator: validate_DatabaseListMetricDefinitions_574518, base: "",
    url: url_DatabaseListMetricDefinitions_574519, schemes: {Scheme.Https})
type
  Call_DatabaseListMetrics_574529 = ref object of OpenApiRestCall_573668
proc url_DatabaseListMetrics_574531(protocol: Scheme; host: string; base: string;
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

proc validate_DatabaseListMetrics_574530(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves the metrics determined by the given filter for the given database account and database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: JString (required)
  ##              : Cosmos DB database rid.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574532 = path.getOrDefault("resourceGroupName")
  valid_574532 = validateParameter(valid_574532, JString, required = true,
                                 default = nil)
  if valid_574532 != nil:
    section.add "resourceGroupName", valid_574532
  var valid_574533 = path.getOrDefault("subscriptionId")
  valid_574533 = validateParameter(valid_574533, JString, required = true,
                                 default = nil)
  if valid_574533 != nil:
    section.add "subscriptionId", valid_574533
  var valid_574534 = path.getOrDefault("databaseRid")
  valid_574534 = validateParameter(valid_574534, JString, required = true,
                                 default = nil)
  if valid_574534 != nil:
    section.add "databaseRid", valid_574534
  var valid_574535 = path.getOrDefault("accountName")
  valid_574535 = validateParameter(valid_574535, JString, required = true,
                                 default = nil)
  if valid_574535 != nil:
    section.add "accountName", valid_574535
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574536 = query.getOrDefault("api-version")
  valid_574536 = validateParameter(valid_574536, JString, required = true,
                                 default = nil)
  if valid_574536 != nil:
    section.add "api-version", valid_574536
  var valid_574537 = query.getOrDefault("$filter")
  valid_574537 = validateParameter(valid_574537, JString, required = true,
                                 default = nil)
  if valid_574537 != nil:
    section.add "$filter", valid_574537
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574538: Call_DatabaseListMetrics_574529; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account and database.
  ## 
  let valid = call_574538.validator(path, query, header, formData, body)
  let scheme = call_574538.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574538.url(scheme.get, call_574538.host, call_574538.base,
                         call_574538.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574538, url, valid)

proc call*(call_574539: Call_DatabaseListMetrics_574529; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; databaseRid: string;
          accountName: string; Filter: string): Recallable =
  ## databaseListMetrics
  ## Retrieves the metrics determined by the given filter for the given database account and database.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: string (required)
  ##              : Cosmos DB database rid.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  var path_574540 = newJObject()
  var query_574541 = newJObject()
  add(path_574540, "resourceGroupName", newJString(resourceGroupName))
  add(query_574541, "api-version", newJString(apiVersion))
  add(path_574540, "subscriptionId", newJString(subscriptionId))
  add(path_574540, "databaseRid", newJString(databaseRid))
  add(path_574540, "accountName", newJString(accountName))
  add(query_574541, "$filter", newJString(Filter))
  result = call_574539.call(path_574540, query_574541, nil, nil, nil)

var databaseListMetrics* = Call_DatabaseListMetrics_574529(
    name: "databaseListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/metrics",
    validator: validate_DatabaseListMetrics_574530, base: "",
    url: url_DatabaseListMetrics_574531, schemes: {Scheme.Https})
type
  Call_DatabaseListUsages_574542 = ref object of OpenApiRestCall_573668
proc url_DatabaseListUsages_574544(protocol: Scheme; host: string; base: string;
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

proc validate_DatabaseListUsages_574543(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves the usages (most recent data) for the given database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: JString (required)
  ##              : Cosmos DB database rid.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574545 = path.getOrDefault("resourceGroupName")
  valid_574545 = validateParameter(valid_574545, JString, required = true,
                                 default = nil)
  if valid_574545 != nil:
    section.add "resourceGroupName", valid_574545
  var valid_574546 = path.getOrDefault("subscriptionId")
  valid_574546 = validateParameter(valid_574546, JString, required = true,
                                 default = nil)
  if valid_574546 != nil:
    section.add "subscriptionId", valid_574546
  var valid_574547 = path.getOrDefault("databaseRid")
  valid_574547 = validateParameter(valid_574547, JString, required = true,
                                 default = nil)
  if valid_574547 != nil:
    section.add "databaseRid", valid_574547
  var valid_574548 = path.getOrDefault("accountName")
  valid_574548 = validateParameter(valid_574548, JString, required = true,
                                 default = nil)
  if valid_574548 != nil:
    section.add "accountName", valid_574548
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString
  ##          : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574549 = query.getOrDefault("api-version")
  valid_574549 = validateParameter(valid_574549, JString, required = true,
                                 default = nil)
  if valid_574549 != nil:
    section.add "api-version", valid_574549
  var valid_574550 = query.getOrDefault("$filter")
  valid_574550 = validateParameter(valid_574550, JString, required = false,
                                 default = nil)
  if valid_574550 != nil:
    section.add "$filter", valid_574550
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574551: Call_DatabaseListUsages_574542; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the usages (most recent data) for the given database.
  ## 
  let valid = call_574551.validator(path, query, header, formData, body)
  let scheme = call_574551.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574551.url(scheme.get, call_574551.host, call_574551.base,
                         call_574551.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574551, url, valid)

proc call*(call_574552: Call_DatabaseListUsages_574542; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; databaseRid: string;
          accountName: string; Filter: string = ""): Recallable =
  ## databaseListUsages
  ## Retrieves the usages (most recent data) for the given database.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: string (required)
  ##              : Cosmos DB database rid.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   Filter: string
  ##         : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  var path_574553 = newJObject()
  var query_574554 = newJObject()
  add(path_574553, "resourceGroupName", newJString(resourceGroupName))
  add(query_574554, "api-version", newJString(apiVersion))
  add(path_574553, "subscriptionId", newJString(subscriptionId))
  add(path_574553, "databaseRid", newJString(databaseRid))
  add(path_574553, "accountName", newJString(accountName))
  add(query_574554, "$filter", newJString(Filter))
  result = call_574552.call(path_574553, query_574554, nil, nil, nil)

var databaseListUsages* = Call_DatabaseListUsages_574542(
    name: "databaseListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/usages",
    validator: validate_DatabaseListUsages_574543, base: "",
    url: url_DatabaseListUsages_574544, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsFailoverPriorityChange_574555 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsFailoverPriorityChange_574557(protocol: Scheme;
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

proc validate_DatabaseAccountsFailoverPriorityChange_574556(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Changes the failover priority for the Azure Cosmos DB database account. A failover priority of 0 indicates a write region. The maximum value for a failover priority = (total number of regions - 1). Failover priority values must be unique for each of the regions in which the database account exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574575 = path.getOrDefault("resourceGroupName")
  valid_574575 = validateParameter(valid_574575, JString, required = true,
                                 default = nil)
  if valid_574575 != nil:
    section.add "resourceGroupName", valid_574575
  var valid_574576 = path.getOrDefault("subscriptionId")
  valid_574576 = validateParameter(valid_574576, JString, required = true,
                                 default = nil)
  if valid_574576 != nil:
    section.add "subscriptionId", valid_574576
  var valid_574577 = path.getOrDefault("accountName")
  valid_574577 = validateParameter(valid_574577, JString, required = true,
                                 default = nil)
  if valid_574577 != nil:
    section.add "accountName", valid_574577
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574578 = query.getOrDefault("api-version")
  valid_574578 = validateParameter(valid_574578, JString, required = true,
                                 default = nil)
  if valid_574578 != nil:
    section.add "api-version", valid_574578
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

proc call*(call_574580: Call_DatabaseAccountsFailoverPriorityChange_574555;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Changes the failover priority for the Azure Cosmos DB database account. A failover priority of 0 indicates a write region. The maximum value for a failover priority = (total number of regions - 1). Failover priority values must be unique for each of the regions in which the database account exists.
  ## 
  let valid = call_574580.validator(path, query, header, formData, body)
  let scheme = call_574580.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574580.url(scheme.get, call_574580.host, call_574580.base,
                         call_574580.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574580, url, valid)

proc call*(call_574581: Call_DatabaseAccountsFailoverPriorityChange_574555;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          failoverParameters: JsonNode; accountName: string): Recallable =
  ## databaseAccountsFailoverPriorityChange
  ## Changes the failover priority for the Azure Cosmos DB database account. A failover priority of 0 indicates a write region. The maximum value for a failover priority = (total number of regions - 1). Failover priority values must be unique for each of the regions in which the database account exists.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   failoverParameters: JObject (required)
  ##                     : The new failover policies for the database account.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574582 = newJObject()
  var query_574583 = newJObject()
  var body_574584 = newJObject()
  add(path_574582, "resourceGroupName", newJString(resourceGroupName))
  add(query_574583, "api-version", newJString(apiVersion))
  add(path_574582, "subscriptionId", newJString(subscriptionId))
  if failoverParameters != nil:
    body_574584 = failoverParameters
  add(path_574582, "accountName", newJString(accountName))
  result = call_574581.call(path_574582, query_574583, nil, nil, body_574584)

var databaseAccountsFailoverPriorityChange* = Call_DatabaseAccountsFailoverPriorityChange_574555(
    name: "databaseAccountsFailoverPriorityChange", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/failoverPriorityChange",
    validator: validate_DatabaseAccountsFailoverPriorityChange_574556, base: "",
    url: url_DatabaseAccountsFailoverPriorityChange_574557,
    schemes: {Scheme.Https})
type
  Call_GremlinResourcesListGremlinDatabases_574585 = ref object of OpenApiRestCall_573668
proc url_GremlinResourcesListGremlinDatabases_574587(protocol: Scheme;
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

proc validate_GremlinResourcesListGremlinDatabases_574586(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Gremlin databases under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574588 = path.getOrDefault("resourceGroupName")
  valid_574588 = validateParameter(valid_574588, JString, required = true,
                                 default = nil)
  if valid_574588 != nil:
    section.add "resourceGroupName", valid_574588
  var valid_574589 = path.getOrDefault("subscriptionId")
  valid_574589 = validateParameter(valid_574589, JString, required = true,
                                 default = nil)
  if valid_574589 != nil:
    section.add "subscriptionId", valid_574589
  var valid_574590 = path.getOrDefault("accountName")
  valid_574590 = validateParameter(valid_574590, JString, required = true,
                                 default = nil)
  if valid_574590 != nil:
    section.add "accountName", valid_574590
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574591 = query.getOrDefault("api-version")
  valid_574591 = validateParameter(valid_574591, JString, required = true,
                                 default = nil)
  if valid_574591 != nil:
    section.add "api-version", valid_574591
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574592: Call_GremlinResourcesListGremlinDatabases_574585;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Gremlin databases under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_574592.validator(path, query, header, formData, body)
  let scheme = call_574592.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574592.url(scheme.get, call_574592.host, call_574592.base,
                         call_574592.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574592, url, valid)

proc call*(call_574593: Call_GremlinResourcesListGremlinDatabases_574585;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## gremlinResourcesListGremlinDatabases
  ## Lists the Gremlin databases under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574594 = newJObject()
  var query_574595 = newJObject()
  add(path_574594, "resourceGroupName", newJString(resourceGroupName))
  add(query_574595, "api-version", newJString(apiVersion))
  add(path_574594, "subscriptionId", newJString(subscriptionId))
  add(path_574594, "accountName", newJString(accountName))
  result = call_574593.call(path_574594, query_574595, nil, nil, nil)

var gremlinResourcesListGremlinDatabases* = Call_GremlinResourcesListGremlinDatabases_574585(
    name: "gremlinResourcesListGremlinDatabases", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/gremlinDatabases",
    validator: validate_GremlinResourcesListGremlinDatabases_574586, base: "",
    url: url_GremlinResourcesListGremlinDatabases_574587, schemes: {Scheme.Https})
type
  Call_GremlinResourcesCreateUpdateGremlinDatabase_574608 = ref object of OpenApiRestCall_573668
proc url_GremlinResourcesCreateUpdateGremlinDatabase_574610(protocol: Scheme;
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

proc validate_GremlinResourcesCreateUpdateGremlinDatabase_574609(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an Azure Cosmos DB Gremlin database
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574611 = path.getOrDefault("resourceGroupName")
  valid_574611 = validateParameter(valid_574611, JString, required = true,
                                 default = nil)
  if valid_574611 != nil:
    section.add "resourceGroupName", valid_574611
  var valid_574612 = path.getOrDefault("subscriptionId")
  valid_574612 = validateParameter(valid_574612, JString, required = true,
                                 default = nil)
  if valid_574612 != nil:
    section.add "subscriptionId", valid_574612
  var valid_574613 = path.getOrDefault("databaseName")
  valid_574613 = validateParameter(valid_574613, JString, required = true,
                                 default = nil)
  if valid_574613 != nil:
    section.add "databaseName", valid_574613
  var valid_574614 = path.getOrDefault("accountName")
  valid_574614 = validateParameter(valid_574614, JString, required = true,
                                 default = nil)
  if valid_574614 != nil:
    section.add "accountName", valid_574614
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574615 = query.getOrDefault("api-version")
  valid_574615 = validateParameter(valid_574615, JString, required = true,
                                 default = nil)
  if valid_574615 != nil:
    section.add "api-version", valid_574615
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

proc call*(call_574617: Call_GremlinResourcesCreateUpdateGremlinDatabase_574608;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB Gremlin database
  ## 
  let valid = call_574617.validator(path, query, header, formData, body)
  let scheme = call_574617.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574617.url(scheme.get, call_574617.host, call_574617.base,
                         call_574617.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574617, url, valid)

proc call*(call_574618: Call_GremlinResourcesCreateUpdateGremlinDatabase_574608;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          createUpdateGremlinDatabaseParameters: JsonNode; databaseName: string;
          accountName: string): Recallable =
  ## gremlinResourcesCreateUpdateGremlinDatabase
  ## Create or update an Azure Cosmos DB Gremlin database
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   createUpdateGremlinDatabaseParameters: JObject (required)
  ##                                        : The parameters to provide for the current Gremlin database.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574619 = newJObject()
  var query_574620 = newJObject()
  var body_574621 = newJObject()
  add(path_574619, "resourceGroupName", newJString(resourceGroupName))
  add(query_574620, "api-version", newJString(apiVersion))
  add(path_574619, "subscriptionId", newJString(subscriptionId))
  if createUpdateGremlinDatabaseParameters != nil:
    body_574621 = createUpdateGremlinDatabaseParameters
  add(path_574619, "databaseName", newJString(databaseName))
  add(path_574619, "accountName", newJString(accountName))
  result = call_574618.call(path_574619, query_574620, nil, nil, body_574621)

var gremlinResourcesCreateUpdateGremlinDatabase* = Call_GremlinResourcesCreateUpdateGremlinDatabase_574608(
    name: "gremlinResourcesCreateUpdateGremlinDatabase", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/gremlinDatabases/{databaseName}",
    validator: validate_GremlinResourcesCreateUpdateGremlinDatabase_574609,
    base: "", url: url_GremlinResourcesCreateUpdateGremlinDatabase_574610,
    schemes: {Scheme.Https})
type
  Call_GremlinResourcesGetGremlinDatabase_574596 = ref object of OpenApiRestCall_573668
proc url_GremlinResourcesGetGremlinDatabase_574598(protocol: Scheme; host: string;
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

proc validate_GremlinResourcesGetGremlinDatabase_574597(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Gremlin databases under an existing Azure Cosmos DB database account with the provided name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574599 = path.getOrDefault("resourceGroupName")
  valid_574599 = validateParameter(valid_574599, JString, required = true,
                                 default = nil)
  if valid_574599 != nil:
    section.add "resourceGroupName", valid_574599
  var valid_574600 = path.getOrDefault("subscriptionId")
  valid_574600 = validateParameter(valid_574600, JString, required = true,
                                 default = nil)
  if valid_574600 != nil:
    section.add "subscriptionId", valid_574600
  var valid_574601 = path.getOrDefault("databaseName")
  valid_574601 = validateParameter(valid_574601, JString, required = true,
                                 default = nil)
  if valid_574601 != nil:
    section.add "databaseName", valid_574601
  var valid_574602 = path.getOrDefault("accountName")
  valid_574602 = validateParameter(valid_574602, JString, required = true,
                                 default = nil)
  if valid_574602 != nil:
    section.add "accountName", valid_574602
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574603 = query.getOrDefault("api-version")
  valid_574603 = validateParameter(valid_574603, JString, required = true,
                                 default = nil)
  if valid_574603 != nil:
    section.add "api-version", valid_574603
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574604: Call_GremlinResourcesGetGremlinDatabase_574596;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the Gremlin databases under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_574604.validator(path, query, header, formData, body)
  let scheme = call_574604.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574604.url(scheme.get, call_574604.host, call_574604.base,
                         call_574604.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574604, url, valid)

proc call*(call_574605: Call_GremlinResourcesGetGremlinDatabase_574596;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; accountName: string): Recallable =
  ## gremlinResourcesGetGremlinDatabase
  ## Gets the Gremlin databases under an existing Azure Cosmos DB database account with the provided name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574606 = newJObject()
  var query_574607 = newJObject()
  add(path_574606, "resourceGroupName", newJString(resourceGroupName))
  add(query_574607, "api-version", newJString(apiVersion))
  add(path_574606, "subscriptionId", newJString(subscriptionId))
  add(path_574606, "databaseName", newJString(databaseName))
  add(path_574606, "accountName", newJString(accountName))
  result = call_574605.call(path_574606, query_574607, nil, nil, nil)

var gremlinResourcesGetGremlinDatabase* = Call_GremlinResourcesGetGremlinDatabase_574596(
    name: "gremlinResourcesGetGremlinDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/gremlinDatabases/{databaseName}",
    validator: validate_GremlinResourcesGetGremlinDatabase_574597, base: "",
    url: url_GremlinResourcesGetGremlinDatabase_574598, schemes: {Scheme.Https})
type
  Call_GremlinResourcesDeleteGremlinDatabase_574622 = ref object of OpenApiRestCall_573668
proc url_GremlinResourcesDeleteGremlinDatabase_574624(protocol: Scheme;
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

proc validate_GremlinResourcesDeleteGremlinDatabase_574623(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Azure Cosmos DB Gremlin database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574625 = path.getOrDefault("resourceGroupName")
  valid_574625 = validateParameter(valid_574625, JString, required = true,
                                 default = nil)
  if valid_574625 != nil:
    section.add "resourceGroupName", valid_574625
  var valid_574626 = path.getOrDefault("subscriptionId")
  valid_574626 = validateParameter(valid_574626, JString, required = true,
                                 default = nil)
  if valid_574626 != nil:
    section.add "subscriptionId", valid_574626
  var valid_574627 = path.getOrDefault("databaseName")
  valid_574627 = validateParameter(valid_574627, JString, required = true,
                                 default = nil)
  if valid_574627 != nil:
    section.add "databaseName", valid_574627
  var valid_574628 = path.getOrDefault("accountName")
  valid_574628 = validateParameter(valid_574628, JString, required = true,
                                 default = nil)
  if valid_574628 != nil:
    section.add "accountName", valid_574628
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574629 = query.getOrDefault("api-version")
  valid_574629 = validateParameter(valid_574629, JString, required = true,
                                 default = nil)
  if valid_574629 != nil:
    section.add "api-version", valid_574629
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574630: Call_GremlinResourcesDeleteGremlinDatabase_574622;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB Gremlin database.
  ## 
  let valid = call_574630.validator(path, query, header, formData, body)
  let scheme = call_574630.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574630.url(scheme.get, call_574630.host, call_574630.base,
                         call_574630.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574630, url, valid)

proc call*(call_574631: Call_GremlinResourcesDeleteGremlinDatabase_574622;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; accountName: string): Recallable =
  ## gremlinResourcesDeleteGremlinDatabase
  ## Deletes an existing Azure Cosmos DB Gremlin database.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574632 = newJObject()
  var query_574633 = newJObject()
  add(path_574632, "resourceGroupName", newJString(resourceGroupName))
  add(query_574633, "api-version", newJString(apiVersion))
  add(path_574632, "subscriptionId", newJString(subscriptionId))
  add(path_574632, "databaseName", newJString(databaseName))
  add(path_574632, "accountName", newJString(accountName))
  result = call_574631.call(path_574632, query_574633, nil, nil, nil)

var gremlinResourcesDeleteGremlinDatabase* = Call_GremlinResourcesDeleteGremlinDatabase_574622(
    name: "gremlinResourcesDeleteGremlinDatabase", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/gremlinDatabases/{databaseName}",
    validator: validate_GremlinResourcesDeleteGremlinDatabase_574623, base: "",
    url: url_GremlinResourcesDeleteGremlinDatabase_574624, schemes: {Scheme.Https})
type
  Call_GremlinResourcesListGremlinGraphs_574634 = ref object of OpenApiRestCall_573668
proc url_GremlinResourcesListGremlinGraphs_574636(protocol: Scheme; host: string;
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

proc validate_GremlinResourcesListGremlinGraphs_574635(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Gremlin graph under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574637 = path.getOrDefault("resourceGroupName")
  valid_574637 = validateParameter(valid_574637, JString, required = true,
                                 default = nil)
  if valid_574637 != nil:
    section.add "resourceGroupName", valid_574637
  var valid_574638 = path.getOrDefault("subscriptionId")
  valid_574638 = validateParameter(valid_574638, JString, required = true,
                                 default = nil)
  if valid_574638 != nil:
    section.add "subscriptionId", valid_574638
  var valid_574639 = path.getOrDefault("databaseName")
  valid_574639 = validateParameter(valid_574639, JString, required = true,
                                 default = nil)
  if valid_574639 != nil:
    section.add "databaseName", valid_574639
  var valid_574640 = path.getOrDefault("accountName")
  valid_574640 = validateParameter(valid_574640, JString, required = true,
                                 default = nil)
  if valid_574640 != nil:
    section.add "accountName", valid_574640
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574641 = query.getOrDefault("api-version")
  valid_574641 = validateParameter(valid_574641, JString, required = true,
                                 default = nil)
  if valid_574641 != nil:
    section.add "api-version", valid_574641
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574642: Call_GremlinResourcesListGremlinGraphs_574634;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Gremlin graph under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_574642.validator(path, query, header, formData, body)
  let scheme = call_574642.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574642.url(scheme.get, call_574642.host, call_574642.base,
                         call_574642.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574642, url, valid)

proc call*(call_574643: Call_GremlinResourcesListGremlinGraphs_574634;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; accountName: string): Recallable =
  ## gremlinResourcesListGremlinGraphs
  ## Lists the Gremlin graph under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574644 = newJObject()
  var query_574645 = newJObject()
  add(path_574644, "resourceGroupName", newJString(resourceGroupName))
  add(query_574645, "api-version", newJString(apiVersion))
  add(path_574644, "subscriptionId", newJString(subscriptionId))
  add(path_574644, "databaseName", newJString(databaseName))
  add(path_574644, "accountName", newJString(accountName))
  result = call_574643.call(path_574644, query_574645, nil, nil, nil)

var gremlinResourcesListGremlinGraphs* = Call_GremlinResourcesListGremlinGraphs_574634(
    name: "gremlinResourcesListGremlinGraphs", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/gremlinDatabases/{databaseName}/graphs",
    validator: validate_GremlinResourcesListGremlinGraphs_574635, base: "",
    url: url_GremlinResourcesListGremlinGraphs_574636, schemes: {Scheme.Https})
type
  Call_GremlinResourcesCreateUpdateGremlinGraph_574659 = ref object of OpenApiRestCall_573668
proc url_GremlinResourcesCreateUpdateGremlinGraph_574661(protocol: Scheme;
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

proc validate_GremlinResourcesCreateUpdateGremlinGraph_574660(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an Azure Cosmos DB Gremlin graph
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   graphName: JString (required)
  ##            : Cosmos DB graph name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574662 = path.getOrDefault("resourceGroupName")
  valid_574662 = validateParameter(valid_574662, JString, required = true,
                                 default = nil)
  if valid_574662 != nil:
    section.add "resourceGroupName", valid_574662
  var valid_574663 = path.getOrDefault("subscriptionId")
  valid_574663 = validateParameter(valid_574663, JString, required = true,
                                 default = nil)
  if valid_574663 != nil:
    section.add "subscriptionId", valid_574663
  var valid_574664 = path.getOrDefault("databaseName")
  valid_574664 = validateParameter(valid_574664, JString, required = true,
                                 default = nil)
  if valid_574664 != nil:
    section.add "databaseName", valid_574664
  var valid_574665 = path.getOrDefault("graphName")
  valid_574665 = validateParameter(valid_574665, JString, required = true,
                                 default = nil)
  if valid_574665 != nil:
    section.add "graphName", valid_574665
  var valid_574666 = path.getOrDefault("accountName")
  valid_574666 = validateParameter(valid_574666, JString, required = true,
                                 default = nil)
  if valid_574666 != nil:
    section.add "accountName", valid_574666
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574667 = query.getOrDefault("api-version")
  valid_574667 = validateParameter(valid_574667, JString, required = true,
                                 default = nil)
  if valid_574667 != nil:
    section.add "api-version", valid_574667
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

proc call*(call_574669: Call_GremlinResourcesCreateUpdateGremlinGraph_574659;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB Gremlin graph
  ## 
  let valid = call_574669.validator(path, query, header, formData, body)
  let scheme = call_574669.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574669.url(scheme.get, call_574669.host, call_574669.base,
                         call_574669.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574669, url, valid)

proc call*(call_574670: Call_GremlinResourcesCreateUpdateGremlinGraph_574659;
          resourceGroupName: string; apiVersion: string;
          createUpdateGremlinGraphParameters: JsonNode; subscriptionId: string;
          databaseName: string; graphName: string; accountName: string): Recallable =
  ## gremlinResourcesCreateUpdateGremlinGraph
  ## Create or update an Azure Cosmos DB Gremlin graph
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   createUpdateGremlinGraphParameters: JObject (required)
  ##                                     : The parameters to provide for the current Gremlin graph.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   graphName: string (required)
  ##            : Cosmos DB graph name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574671 = newJObject()
  var query_574672 = newJObject()
  var body_574673 = newJObject()
  add(path_574671, "resourceGroupName", newJString(resourceGroupName))
  add(query_574672, "api-version", newJString(apiVersion))
  if createUpdateGremlinGraphParameters != nil:
    body_574673 = createUpdateGremlinGraphParameters
  add(path_574671, "subscriptionId", newJString(subscriptionId))
  add(path_574671, "databaseName", newJString(databaseName))
  add(path_574671, "graphName", newJString(graphName))
  add(path_574671, "accountName", newJString(accountName))
  result = call_574670.call(path_574671, query_574672, nil, nil, body_574673)

var gremlinResourcesCreateUpdateGremlinGraph* = Call_GremlinResourcesCreateUpdateGremlinGraph_574659(
    name: "gremlinResourcesCreateUpdateGremlinGraph", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/gremlinDatabases/{databaseName}/graphs/{graphName}",
    validator: validate_GremlinResourcesCreateUpdateGremlinGraph_574660, base: "",
    url: url_GremlinResourcesCreateUpdateGremlinGraph_574661,
    schemes: {Scheme.Https})
type
  Call_GremlinResourcesGetGremlinGraph_574646 = ref object of OpenApiRestCall_573668
proc url_GremlinResourcesGetGremlinGraph_574648(protocol: Scheme; host: string;
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

proc validate_GremlinResourcesGetGremlinGraph_574647(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Gremlin graph under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   graphName: JString (required)
  ##            : Cosmos DB graph name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574649 = path.getOrDefault("resourceGroupName")
  valid_574649 = validateParameter(valid_574649, JString, required = true,
                                 default = nil)
  if valid_574649 != nil:
    section.add "resourceGroupName", valid_574649
  var valid_574650 = path.getOrDefault("subscriptionId")
  valid_574650 = validateParameter(valid_574650, JString, required = true,
                                 default = nil)
  if valid_574650 != nil:
    section.add "subscriptionId", valid_574650
  var valid_574651 = path.getOrDefault("databaseName")
  valid_574651 = validateParameter(valid_574651, JString, required = true,
                                 default = nil)
  if valid_574651 != nil:
    section.add "databaseName", valid_574651
  var valid_574652 = path.getOrDefault("graphName")
  valid_574652 = validateParameter(valid_574652, JString, required = true,
                                 default = nil)
  if valid_574652 != nil:
    section.add "graphName", valid_574652
  var valid_574653 = path.getOrDefault("accountName")
  valid_574653 = validateParameter(valid_574653, JString, required = true,
                                 default = nil)
  if valid_574653 != nil:
    section.add "accountName", valid_574653
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574654 = query.getOrDefault("api-version")
  valid_574654 = validateParameter(valid_574654, JString, required = true,
                                 default = nil)
  if valid_574654 != nil:
    section.add "api-version", valid_574654
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574655: Call_GremlinResourcesGetGremlinGraph_574646;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the Gremlin graph under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_574655.validator(path, query, header, formData, body)
  let scheme = call_574655.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574655.url(scheme.get, call_574655.host, call_574655.base,
                         call_574655.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574655, url, valid)

proc call*(call_574656: Call_GremlinResourcesGetGremlinGraph_574646;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; graphName: string; accountName: string): Recallable =
  ## gremlinResourcesGetGremlinGraph
  ## Gets the Gremlin graph under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   graphName: string (required)
  ##            : Cosmos DB graph name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574657 = newJObject()
  var query_574658 = newJObject()
  add(path_574657, "resourceGroupName", newJString(resourceGroupName))
  add(query_574658, "api-version", newJString(apiVersion))
  add(path_574657, "subscriptionId", newJString(subscriptionId))
  add(path_574657, "databaseName", newJString(databaseName))
  add(path_574657, "graphName", newJString(graphName))
  add(path_574657, "accountName", newJString(accountName))
  result = call_574656.call(path_574657, query_574658, nil, nil, nil)

var gremlinResourcesGetGremlinGraph* = Call_GremlinResourcesGetGremlinGraph_574646(
    name: "gremlinResourcesGetGremlinGraph", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/gremlinDatabases/{databaseName}/graphs/{graphName}",
    validator: validate_GremlinResourcesGetGremlinGraph_574647, base: "",
    url: url_GremlinResourcesGetGremlinGraph_574648, schemes: {Scheme.Https})
type
  Call_GremlinResourcesDeleteGremlinGraph_574674 = ref object of OpenApiRestCall_573668
proc url_GremlinResourcesDeleteGremlinGraph_574676(protocol: Scheme; host: string;
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

proc validate_GremlinResourcesDeleteGremlinGraph_574675(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Azure Cosmos DB Gremlin graph.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   graphName: JString (required)
  ##            : Cosmos DB graph name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574677 = path.getOrDefault("resourceGroupName")
  valid_574677 = validateParameter(valid_574677, JString, required = true,
                                 default = nil)
  if valid_574677 != nil:
    section.add "resourceGroupName", valid_574677
  var valid_574678 = path.getOrDefault("subscriptionId")
  valid_574678 = validateParameter(valid_574678, JString, required = true,
                                 default = nil)
  if valid_574678 != nil:
    section.add "subscriptionId", valid_574678
  var valid_574679 = path.getOrDefault("databaseName")
  valid_574679 = validateParameter(valid_574679, JString, required = true,
                                 default = nil)
  if valid_574679 != nil:
    section.add "databaseName", valid_574679
  var valid_574680 = path.getOrDefault("graphName")
  valid_574680 = validateParameter(valid_574680, JString, required = true,
                                 default = nil)
  if valid_574680 != nil:
    section.add "graphName", valid_574680
  var valid_574681 = path.getOrDefault("accountName")
  valid_574681 = validateParameter(valid_574681, JString, required = true,
                                 default = nil)
  if valid_574681 != nil:
    section.add "accountName", valid_574681
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574682 = query.getOrDefault("api-version")
  valid_574682 = validateParameter(valid_574682, JString, required = true,
                                 default = nil)
  if valid_574682 != nil:
    section.add "api-version", valid_574682
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574683: Call_GremlinResourcesDeleteGremlinGraph_574674;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB Gremlin graph.
  ## 
  let valid = call_574683.validator(path, query, header, formData, body)
  let scheme = call_574683.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574683.url(scheme.get, call_574683.host, call_574683.base,
                         call_574683.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574683, url, valid)

proc call*(call_574684: Call_GremlinResourcesDeleteGremlinGraph_574674;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; graphName: string; accountName: string): Recallable =
  ## gremlinResourcesDeleteGremlinGraph
  ## Deletes an existing Azure Cosmos DB Gremlin graph.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   graphName: string (required)
  ##            : Cosmos DB graph name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574685 = newJObject()
  var query_574686 = newJObject()
  add(path_574685, "resourceGroupName", newJString(resourceGroupName))
  add(query_574686, "api-version", newJString(apiVersion))
  add(path_574685, "subscriptionId", newJString(subscriptionId))
  add(path_574685, "databaseName", newJString(databaseName))
  add(path_574685, "graphName", newJString(graphName))
  add(path_574685, "accountName", newJString(accountName))
  result = call_574684.call(path_574685, query_574686, nil, nil, nil)

var gremlinResourcesDeleteGremlinGraph* = Call_GremlinResourcesDeleteGremlinGraph_574674(
    name: "gremlinResourcesDeleteGremlinGraph", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/gremlinDatabases/{databaseName}/graphs/{graphName}",
    validator: validate_GremlinResourcesDeleteGremlinGraph_574675, base: "",
    url: url_GremlinResourcesDeleteGremlinGraph_574676, schemes: {Scheme.Https})
type
  Call_GremlinResourcesUpdateGremlinGraphThroughput_574700 = ref object of OpenApiRestCall_573668
proc url_GremlinResourcesUpdateGremlinGraphThroughput_574702(protocol: Scheme;
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

proc validate_GremlinResourcesUpdateGremlinGraphThroughput_574701(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update RUs per second of an Azure Cosmos DB Gremlin graph
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   graphName: JString (required)
  ##            : Cosmos DB graph name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574703 = path.getOrDefault("resourceGroupName")
  valid_574703 = validateParameter(valid_574703, JString, required = true,
                                 default = nil)
  if valid_574703 != nil:
    section.add "resourceGroupName", valid_574703
  var valid_574704 = path.getOrDefault("subscriptionId")
  valid_574704 = validateParameter(valid_574704, JString, required = true,
                                 default = nil)
  if valid_574704 != nil:
    section.add "subscriptionId", valid_574704
  var valid_574705 = path.getOrDefault("databaseName")
  valid_574705 = validateParameter(valid_574705, JString, required = true,
                                 default = nil)
  if valid_574705 != nil:
    section.add "databaseName", valid_574705
  var valid_574706 = path.getOrDefault("graphName")
  valid_574706 = validateParameter(valid_574706, JString, required = true,
                                 default = nil)
  if valid_574706 != nil:
    section.add "graphName", valid_574706
  var valid_574707 = path.getOrDefault("accountName")
  valid_574707 = validateParameter(valid_574707, JString, required = true,
                                 default = nil)
  if valid_574707 != nil:
    section.add "accountName", valid_574707
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574708 = query.getOrDefault("api-version")
  valid_574708 = validateParameter(valid_574708, JString, required = true,
                                 default = nil)
  if valid_574708 != nil:
    section.add "api-version", valid_574708
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

proc call*(call_574710: Call_GremlinResourcesUpdateGremlinGraphThroughput_574700;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Gremlin graph
  ## 
  let valid = call_574710.validator(path, query, header, formData, body)
  let scheme = call_574710.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574710.url(scheme.get, call_574710.host, call_574710.base,
                         call_574710.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574710, url, valid)

proc call*(call_574711: Call_GremlinResourcesUpdateGremlinGraphThroughput_574700;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; updateThroughputParameters: JsonNode;
          graphName: string; accountName: string): Recallable =
  ## gremlinResourcesUpdateGremlinGraphThroughput
  ## Update RUs per second of an Azure Cosmos DB Gremlin graph
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   updateThroughputParameters: JObject (required)
  ##                             : The RUs per second of the parameters to provide for the current Gremlin graph.
  ##   graphName: string (required)
  ##            : Cosmos DB graph name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574712 = newJObject()
  var query_574713 = newJObject()
  var body_574714 = newJObject()
  add(path_574712, "resourceGroupName", newJString(resourceGroupName))
  add(query_574713, "api-version", newJString(apiVersion))
  add(path_574712, "subscriptionId", newJString(subscriptionId))
  add(path_574712, "databaseName", newJString(databaseName))
  if updateThroughputParameters != nil:
    body_574714 = updateThroughputParameters
  add(path_574712, "graphName", newJString(graphName))
  add(path_574712, "accountName", newJString(accountName))
  result = call_574711.call(path_574712, query_574713, nil, nil, body_574714)

var gremlinResourcesUpdateGremlinGraphThroughput* = Call_GremlinResourcesUpdateGremlinGraphThroughput_574700(
    name: "gremlinResourcesUpdateGremlinGraphThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/gremlinDatabases/{databaseName}/graphs/{graphName}/throughputSettings/default",
    validator: validate_GremlinResourcesUpdateGremlinGraphThroughput_574701,
    base: "", url: url_GremlinResourcesUpdateGremlinGraphThroughput_574702,
    schemes: {Scheme.Https})
type
  Call_GremlinResourcesGetGremlinGraphThroughput_574687 = ref object of OpenApiRestCall_573668
proc url_GremlinResourcesGetGremlinGraphThroughput_574689(protocol: Scheme;
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

proc validate_GremlinResourcesGetGremlinGraphThroughput_574688(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Gremlin graph throughput under an existing Azure Cosmos DB database account with the provided name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   graphName: JString (required)
  ##            : Cosmos DB graph name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574690 = path.getOrDefault("resourceGroupName")
  valid_574690 = validateParameter(valid_574690, JString, required = true,
                                 default = nil)
  if valid_574690 != nil:
    section.add "resourceGroupName", valid_574690
  var valid_574691 = path.getOrDefault("subscriptionId")
  valid_574691 = validateParameter(valid_574691, JString, required = true,
                                 default = nil)
  if valid_574691 != nil:
    section.add "subscriptionId", valid_574691
  var valid_574692 = path.getOrDefault("databaseName")
  valid_574692 = validateParameter(valid_574692, JString, required = true,
                                 default = nil)
  if valid_574692 != nil:
    section.add "databaseName", valid_574692
  var valid_574693 = path.getOrDefault("graphName")
  valid_574693 = validateParameter(valid_574693, JString, required = true,
                                 default = nil)
  if valid_574693 != nil:
    section.add "graphName", valid_574693
  var valid_574694 = path.getOrDefault("accountName")
  valid_574694 = validateParameter(valid_574694, JString, required = true,
                                 default = nil)
  if valid_574694 != nil:
    section.add "accountName", valid_574694
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574695 = query.getOrDefault("api-version")
  valid_574695 = validateParameter(valid_574695, JString, required = true,
                                 default = nil)
  if valid_574695 != nil:
    section.add "api-version", valid_574695
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574696: Call_GremlinResourcesGetGremlinGraphThroughput_574687;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the Gremlin graph throughput under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_574696.validator(path, query, header, formData, body)
  let scheme = call_574696.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574696.url(scheme.get, call_574696.host, call_574696.base,
                         call_574696.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574696, url, valid)

proc call*(call_574697: Call_GremlinResourcesGetGremlinGraphThroughput_574687;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; graphName: string; accountName: string): Recallable =
  ## gremlinResourcesGetGremlinGraphThroughput
  ## Gets the Gremlin graph throughput under an existing Azure Cosmos DB database account with the provided name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   graphName: string (required)
  ##            : Cosmos DB graph name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574698 = newJObject()
  var query_574699 = newJObject()
  add(path_574698, "resourceGroupName", newJString(resourceGroupName))
  add(query_574699, "api-version", newJString(apiVersion))
  add(path_574698, "subscriptionId", newJString(subscriptionId))
  add(path_574698, "databaseName", newJString(databaseName))
  add(path_574698, "graphName", newJString(graphName))
  add(path_574698, "accountName", newJString(accountName))
  result = call_574697.call(path_574698, query_574699, nil, nil, nil)

var gremlinResourcesGetGremlinGraphThroughput* = Call_GremlinResourcesGetGremlinGraphThroughput_574687(
    name: "gremlinResourcesGetGremlinGraphThroughput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/gremlinDatabases/{databaseName}/graphs/{graphName}/throughputSettings/default",
    validator: validate_GremlinResourcesGetGremlinGraphThroughput_574688,
    base: "", url: url_GremlinResourcesGetGremlinGraphThroughput_574689,
    schemes: {Scheme.Https})
type
  Call_GremlinResourcesUpdateGremlinDatabaseThroughput_574727 = ref object of OpenApiRestCall_573668
proc url_GremlinResourcesUpdateGremlinDatabaseThroughput_574729(protocol: Scheme;
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

proc validate_GremlinResourcesUpdateGremlinDatabaseThroughput_574728(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Update RUs per second of an Azure Cosmos DB Gremlin database
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574730 = path.getOrDefault("resourceGroupName")
  valid_574730 = validateParameter(valid_574730, JString, required = true,
                                 default = nil)
  if valid_574730 != nil:
    section.add "resourceGroupName", valid_574730
  var valid_574731 = path.getOrDefault("subscriptionId")
  valid_574731 = validateParameter(valid_574731, JString, required = true,
                                 default = nil)
  if valid_574731 != nil:
    section.add "subscriptionId", valid_574731
  var valid_574732 = path.getOrDefault("databaseName")
  valid_574732 = validateParameter(valid_574732, JString, required = true,
                                 default = nil)
  if valid_574732 != nil:
    section.add "databaseName", valid_574732
  var valid_574733 = path.getOrDefault("accountName")
  valid_574733 = validateParameter(valid_574733, JString, required = true,
                                 default = nil)
  if valid_574733 != nil:
    section.add "accountName", valid_574733
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574734 = query.getOrDefault("api-version")
  valid_574734 = validateParameter(valid_574734, JString, required = true,
                                 default = nil)
  if valid_574734 != nil:
    section.add "api-version", valid_574734
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

proc call*(call_574736: Call_GremlinResourcesUpdateGremlinDatabaseThroughput_574727;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Gremlin database
  ## 
  let valid = call_574736.validator(path, query, header, formData, body)
  let scheme = call_574736.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574736.url(scheme.get, call_574736.host, call_574736.base,
                         call_574736.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574736, url, valid)

proc call*(call_574737: Call_GremlinResourcesUpdateGremlinDatabaseThroughput_574727;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; updateThroughputParameters: JsonNode;
          accountName: string): Recallable =
  ## gremlinResourcesUpdateGremlinDatabaseThroughput
  ## Update RUs per second of an Azure Cosmos DB Gremlin database
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   updateThroughputParameters: JObject (required)
  ##                             : The RUs per second of the parameters to provide for the current Gremlin database.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574738 = newJObject()
  var query_574739 = newJObject()
  var body_574740 = newJObject()
  add(path_574738, "resourceGroupName", newJString(resourceGroupName))
  add(query_574739, "api-version", newJString(apiVersion))
  add(path_574738, "subscriptionId", newJString(subscriptionId))
  add(path_574738, "databaseName", newJString(databaseName))
  if updateThroughputParameters != nil:
    body_574740 = updateThroughputParameters
  add(path_574738, "accountName", newJString(accountName))
  result = call_574737.call(path_574738, query_574739, nil, nil, body_574740)

var gremlinResourcesUpdateGremlinDatabaseThroughput* = Call_GremlinResourcesUpdateGremlinDatabaseThroughput_574727(
    name: "gremlinResourcesUpdateGremlinDatabaseThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/gremlinDatabases/{databaseName}/throughputSettings/default",
    validator: validate_GremlinResourcesUpdateGremlinDatabaseThroughput_574728,
    base: "", url: url_GremlinResourcesUpdateGremlinDatabaseThroughput_574729,
    schemes: {Scheme.Https})
type
  Call_GremlinResourcesGetGremlinDatabaseThroughput_574715 = ref object of OpenApiRestCall_573668
proc url_GremlinResourcesGetGremlinDatabaseThroughput_574717(protocol: Scheme;
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

proc validate_GremlinResourcesGetGremlinDatabaseThroughput_574716(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the RUs per second of the Gremlin database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574718 = path.getOrDefault("resourceGroupName")
  valid_574718 = validateParameter(valid_574718, JString, required = true,
                                 default = nil)
  if valid_574718 != nil:
    section.add "resourceGroupName", valid_574718
  var valid_574719 = path.getOrDefault("subscriptionId")
  valid_574719 = validateParameter(valid_574719, JString, required = true,
                                 default = nil)
  if valid_574719 != nil:
    section.add "subscriptionId", valid_574719
  var valid_574720 = path.getOrDefault("databaseName")
  valid_574720 = validateParameter(valid_574720, JString, required = true,
                                 default = nil)
  if valid_574720 != nil:
    section.add "databaseName", valid_574720
  var valid_574721 = path.getOrDefault("accountName")
  valid_574721 = validateParameter(valid_574721, JString, required = true,
                                 default = nil)
  if valid_574721 != nil:
    section.add "accountName", valid_574721
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574722 = query.getOrDefault("api-version")
  valid_574722 = validateParameter(valid_574722, JString, required = true,
                                 default = nil)
  if valid_574722 != nil:
    section.add "api-version", valid_574722
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574723: Call_GremlinResourcesGetGremlinDatabaseThroughput_574715;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the Gremlin database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_574723.validator(path, query, header, formData, body)
  let scheme = call_574723.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574723.url(scheme.get, call_574723.host, call_574723.base,
                         call_574723.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574723, url, valid)

proc call*(call_574724: Call_GremlinResourcesGetGremlinDatabaseThroughput_574715;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; accountName: string): Recallable =
  ## gremlinResourcesGetGremlinDatabaseThroughput
  ## Gets the RUs per second of the Gremlin database under an existing Azure Cosmos DB database account with the provided name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574725 = newJObject()
  var query_574726 = newJObject()
  add(path_574725, "resourceGroupName", newJString(resourceGroupName))
  add(query_574726, "api-version", newJString(apiVersion))
  add(path_574725, "subscriptionId", newJString(subscriptionId))
  add(path_574725, "databaseName", newJString(databaseName))
  add(path_574725, "accountName", newJString(accountName))
  result = call_574724.call(path_574725, query_574726, nil, nil, nil)

var gremlinResourcesGetGremlinDatabaseThroughput* = Call_GremlinResourcesGetGremlinDatabaseThroughput_574715(
    name: "gremlinResourcesGetGremlinDatabaseThroughput",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/gremlinDatabases/{databaseName}/throughputSettings/default",
    validator: validate_GremlinResourcesGetGremlinDatabaseThroughput_574716,
    base: "", url: url_GremlinResourcesGetGremlinDatabaseThroughput_574717,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListConnectionStrings_574741 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsListConnectionStrings_574743(protocol: Scheme;
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

proc validate_DatabaseAccountsListConnectionStrings_574742(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the connection strings for the specified Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574744 = path.getOrDefault("resourceGroupName")
  valid_574744 = validateParameter(valid_574744, JString, required = true,
                                 default = nil)
  if valid_574744 != nil:
    section.add "resourceGroupName", valid_574744
  var valid_574745 = path.getOrDefault("subscriptionId")
  valid_574745 = validateParameter(valid_574745, JString, required = true,
                                 default = nil)
  if valid_574745 != nil:
    section.add "subscriptionId", valid_574745
  var valid_574746 = path.getOrDefault("accountName")
  valid_574746 = validateParameter(valid_574746, JString, required = true,
                                 default = nil)
  if valid_574746 != nil:
    section.add "accountName", valid_574746
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574747 = query.getOrDefault("api-version")
  valid_574747 = validateParameter(valid_574747, JString, required = true,
                                 default = nil)
  if valid_574747 != nil:
    section.add "api-version", valid_574747
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574748: Call_DatabaseAccountsListConnectionStrings_574741;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the connection strings for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_574748.validator(path, query, header, formData, body)
  let scheme = call_574748.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574748.url(scheme.get, call_574748.host, call_574748.base,
                         call_574748.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574748, url, valid)

proc call*(call_574749: Call_DatabaseAccountsListConnectionStrings_574741;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## databaseAccountsListConnectionStrings
  ## Lists the connection strings for the specified Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574750 = newJObject()
  var query_574751 = newJObject()
  add(path_574750, "resourceGroupName", newJString(resourceGroupName))
  add(query_574751, "api-version", newJString(apiVersion))
  add(path_574750, "subscriptionId", newJString(subscriptionId))
  add(path_574750, "accountName", newJString(accountName))
  result = call_574749.call(path_574750, query_574751, nil, nil, nil)

var databaseAccountsListConnectionStrings* = Call_DatabaseAccountsListConnectionStrings_574741(
    name: "databaseAccountsListConnectionStrings", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/listConnectionStrings",
    validator: validate_DatabaseAccountsListConnectionStrings_574742, base: "",
    url: url_DatabaseAccountsListConnectionStrings_574743, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListKeys_574752 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsListKeys_574754(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListKeys_574753(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the access keys for the specified Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574755 = path.getOrDefault("resourceGroupName")
  valid_574755 = validateParameter(valid_574755, JString, required = true,
                                 default = nil)
  if valid_574755 != nil:
    section.add "resourceGroupName", valid_574755
  var valid_574756 = path.getOrDefault("subscriptionId")
  valid_574756 = validateParameter(valid_574756, JString, required = true,
                                 default = nil)
  if valid_574756 != nil:
    section.add "subscriptionId", valid_574756
  var valid_574757 = path.getOrDefault("accountName")
  valid_574757 = validateParameter(valid_574757, JString, required = true,
                                 default = nil)
  if valid_574757 != nil:
    section.add "accountName", valid_574757
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574758 = query.getOrDefault("api-version")
  valid_574758 = validateParameter(valid_574758, JString, required = true,
                                 default = nil)
  if valid_574758 != nil:
    section.add "api-version", valid_574758
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574759: Call_DatabaseAccountsListKeys_574752; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the access keys for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_574759.validator(path, query, header, formData, body)
  let scheme = call_574759.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574759.url(scheme.get, call_574759.host, call_574759.base,
                         call_574759.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574759, url, valid)

proc call*(call_574760: Call_DatabaseAccountsListKeys_574752;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## databaseAccountsListKeys
  ## Lists the access keys for the specified Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574761 = newJObject()
  var query_574762 = newJObject()
  add(path_574761, "resourceGroupName", newJString(resourceGroupName))
  add(query_574762, "api-version", newJString(apiVersion))
  add(path_574761, "subscriptionId", newJString(subscriptionId))
  add(path_574761, "accountName", newJString(accountName))
  result = call_574760.call(path_574761, query_574762, nil, nil, nil)

var databaseAccountsListKeys* = Call_DatabaseAccountsListKeys_574752(
    name: "databaseAccountsListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/listKeys",
    validator: validate_DatabaseAccountsListKeys_574753, base: "",
    url: url_DatabaseAccountsListKeys_574754, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListMetricDefinitions_574763 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsListMetricDefinitions_574765(protocol: Scheme;
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

proc validate_DatabaseAccountsListMetricDefinitions_574764(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves metric definitions for the given database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574766 = path.getOrDefault("resourceGroupName")
  valid_574766 = validateParameter(valid_574766, JString, required = true,
                                 default = nil)
  if valid_574766 != nil:
    section.add "resourceGroupName", valid_574766
  var valid_574767 = path.getOrDefault("subscriptionId")
  valid_574767 = validateParameter(valid_574767, JString, required = true,
                                 default = nil)
  if valid_574767 != nil:
    section.add "subscriptionId", valid_574767
  var valid_574768 = path.getOrDefault("accountName")
  valid_574768 = validateParameter(valid_574768, JString, required = true,
                                 default = nil)
  if valid_574768 != nil:
    section.add "accountName", valid_574768
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574769 = query.getOrDefault("api-version")
  valid_574769 = validateParameter(valid_574769, JString, required = true,
                                 default = nil)
  if valid_574769 != nil:
    section.add "api-version", valid_574769
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574770: Call_DatabaseAccountsListMetricDefinitions_574763;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves metric definitions for the given database account.
  ## 
  let valid = call_574770.validator(path, query, header, formData, body)
  let scheme = call_574770.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574770.url(scheme.get, call_574770.host, call_574770.base,
                         call_574770.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574770, url, valid)

proc call*(call_574771: Call_DatabaseAccountsListMetricDefinitions_574763;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## databaseAccountsListMetricDefinitions
  ## Retrieves metric definitions for the given database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574772 = newJObject()
  var query_574773 = newJObject()
  add(path_574772, "resourceGroupName", newJString(resourceGroupName))
  add(query_574773, "api-version", newJString(apiVersion))
  add(path_574772, "subscriptionId", newJString(subscriptionId))
  add(path_574772, "accountName", newJString(accountName))
  result = call_574771.call(path_574772, query_574773, nil, nil, nil)

var databaseAccountsListMetricDefinitions* = Call_DatabaseAccountsListMetricDefinitions_574763(
    name: "databaseAccountsListMetricDefinitions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/metricDefinitions",
    validator: validate_DatabaseAccountsListMetricDefinitions_574764, base: "",
    url: url_DatabaseAccountsListMetricDefinitions_574765, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListMetrics_574774 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsListMetrics_574776(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListMetrics_574775(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the metrics determined by the given filter for the given database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574777 = path.getOrDefault("resourceGroupName")
  valid_574777 = validateParameter(valid_574777, JString, required = true,
                                 default = nil)
  if valid_574777 != nil:
    section.add "resourceGroupName", valid_574777
  var valid_574778 = path.getOrDefault("subscriptionId")
  valid_574778 = validateParameter(valid_574778, JString, required = true,
                                 default = nil)
  if valid_574778 != nil:
    section.add "subscriptionId", valid_574778
  var valid_574779 = path.getOrDefault("accountName")
  valid_574779 = validateParameter(valid_574779, JString, required = true,
                                 default = nil)
  if valid_574779 != nil:
    section.add "accountName", valid_574779
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574780 = query.getOrDefault("api-version")
  valid_574780 = validateParameter(valid_574780, JString, required = true,
                                 default = nil)
  if valid_574780 != nil:
    section.add "api-version", valid_574780
  var valid_574781 = query.getOrDefault("$filter")
  valid_574781 = validateParameter(valid_574781, JString, required = true,
                                 default = nil)
  if valid_574781 != nil:
    section.add "$filter", valid_574781
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574782: Call_DatabaseAccountsListMetrics_574774; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account.
  ## 
  let valid = call_574782.validator(path, query, header, formData, body)
  let scheme = call_574782.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574782.url(scheme.get, call_574782.host, call_574782.base,
                         call_574782.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574782, url, valid)

proc call*(call_574783: Call_DatabaseAccountsListMetrics_574774;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string; Filter: string): Recallable =
  ## databaseAccountsListMetrics
  ## Retrieves the metrics determined by the given filter for the given database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  var path_574784 = newJObject()
  var query_574785 = newJObject()
  add(path_574784, "resourceGroupName", newJString(resourceGroupName))
  add(query_574785, "api-version", newJString(apiVersion))
  add(path_574784, "subscriptionId", newJString(subscriptionId))
  add(path_574784, "accountName", newJString(accountName))
  add(query_574785, "$filter", newJString(Filter))
  result = call_574783.call(path_574784, query_574785, nil, nil, nil)

var databaseAccountsListMetrics* = Call_DatabaseAccountsListMetrics_574774(
    name: "databaseAccountsListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/metrics",
    validator: validate_DatabaseAccountsListMetrics_574775, base: "",
    url: url_DatabaseAccountsListMetrics_574776, schemes: {Scheme.Https})
type
  Call_MongoDBResourcesListMongoDBDatabases_574786 = ref object of OpenApiRestCall_573668
proc url_MongoDBResourcesListMongoDBDatabases_574788(protocol: Scheme;
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

proc validate_MongoDBResourcesListMongoDBDatabases_574787(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the MongoDB databases under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574789 = path.getOrDefault("resourceGroupName")
  valid_574789 = validateParameter(valid_574789, JString, required = true,
                                 default = nil)
  if valid_574789 != nil:
    section.add "resourceGroupName", valid_574789
  var valid_574790 = path.getOrDefault("subscriptionId")
  valid_574790 = validateParameter(valid_574790, JString, required = true,
                                 default = nil)
  if valid_574790 != nil:
    section.add "subscriptionId", valid_574790
  var valid_574791 = path.getOrDefault("accountName")
  valid_574791 = validateParameter(valid_574791, JString, required = true,
                                 default = nil)
  if valid_574791 != nil:
    section.add "accountName", valid_574791
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574792 = query.getOrDefault("api-version")
  valid_574792 = validateParameter(valid_574792, JString, required = true,
                                 default = nil)
  if valid_574792 != nil:
    section.add "api-version", valid_574792
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574793: Call_MongoDBResourcesListMongoDBDatabases_574786;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the MongoDB databases under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_574793.validator(path, query, header, formData, body)
  let scheme = call_574793.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574793.url(scheme.get, call_574793.host, call_574793.base,
                         call_574793.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574793, url, valid)

proc call*(call_574794: Call_MongoDBResourcesListMongoDBDatabases_574786;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## mongoDBResourcesListMongoDBDatabases
  ## Lists the MongoDB databases under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574795 = newJObject()
  var query_574796 = newJObject()
  add(path_574795, "resourceGroupName", newJString(resourceGroupName))
  add(query_574796, "api-version", newJString(apiVersion))
  add(path_574795, "subscriptionId", newJString(subscriptionId))
  add(path_574795, "accountName", newJString(accountName))
  result = call_574794.call(path_574795, query_574796, nil, nil, nil)

var mongoDBResourcesListMongoDBDatabases* = Call_MongoDBResourcesListMongoDBDatabases_574786(
    name: "mongoDBResourcesListMongoDBDatabases", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/mongodbDatabases",
    validator: validate_MongoDBResourcesListMongoDBDatabases_574787, base: "",
    url: url_MongoDBResourcesListMongoDBDatabases_574788, schemes: {Scheme.Https})
type
  Call_MongoDBResourcesCreateUpdateMongoDBDatabase_574809 = ref object of OpenApiRestCall_573668
proc url_MongoDBResourcesCreateUpdateMongoDBDatabase_574811(protocol: Scheme;
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

proc validate_MongoDBResourcesCreateUpdateMongoDBDatabase_574810(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or updates Azure Cosmos DB MongoDB database
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574812 = path.getOrDefault("resourceGroupName")
  valid_574812 = validateParameter(valid_574812, JString, required = true,
                                 default = nil)
  if valid_574812 != nil:
    section.add "resourceGroupName", valid_574812
  var valid_574813 = path.getOrDefault("subscriptionId")
  valid_574813 = validateParameter(valid_574813, JString, required = true,
                                 default = nil)
  if valid_574813 != nil:
    section.add "subscriptionId", valid_574813
  var valid_574814 = path.getOrDefault("databaseName")
  valid_574814 = validateParameter(valid_574814, JString, required = true,
                                 default = nil)
  if valid_574814 != nil:
    section.add "databaseName", valid_574814
  var valid_574815 = path.getOrDefault("accountName")
  valid_574815 = validateParameter(valid_574815, JString, required = true,
                                 default = nil)
  if valid_574815 != nil:
    section.add "accountName", valid_574815
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574816 = query.getOrDefault("api-version")
  valid_574816 = validateParameter(valid_574816, JString, required = true,
                                 default = nil)
  if valid_574816 != nil:
    section.add "api-version", valid_574816
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

proc call*(call_574818: Call_MongoDBResourcesCreateUpdateMongoDBDatabase_574809;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or updates Azure Cosmos DB MongoDB database
  ## 
  let valid = call_574818.validator(path, query, header, formData, body)
  let scheme = call_574818.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574818.url(scheme.get, call_574818.host, call_574818.base,
                         call_574818.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574818, url, valid)

proc call*(call_574819: Call_MongoDBResourcesCreateUpdateMongoDBDatabase_574809;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; createUpdateMongoDBDatabaseParameters: JsonNode;
          accountName: string): Recallable =
  ## mongoDBResourcesCreateUpdateMongoDBDatabase
  ## Create or updates Azure Cosmos DB MongoDB database
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   createUpdateMongoDBDatabaseParameters: JObject (required)
  ##                                        : The parameters to provide for the current MongoDB database.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574820 = newJObject()
  var query_574821 = newJObject()
  var body_574822 = newJObject()
  add(path_574820, "resourceGroupName", newJString(resourceGroupName))
  add(query_574821, "api-version", newJString(apiVersion))
  add(path_574820, "subscriptionId", newJString(subscriptionId))
  add(path_574820, "databaseName", newJString(databaseName))
  if createUpdateMongoDBDatabaseParameters != nil:
    body_574822 = createUpdateMongoDBDatabaseParameters
  add(path_574820, "accountName", newJString(accountName))
  result = call_574819.call(path_574820, query_574821, nil, nil, body_574822)

var mongoDBResourcesCreateUpdateMongoDBDatabase* = Call_MongoDBResourcesCreateUpdateMongoDBDatabase_574809(
    name: "mongoDBResourcesCreateUpdateMongoDBDatabase", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/mongodbDatabases/{databaseName}",
    validator: validate_MongoDBResourcesCreateUpdateMongoDBDatabase_574810,
    base: "", url: url_MongoDBResourcesCreateUpdateMongoDBDatabase_574811,
    schemes: {Scheme.Https})
type
  Call_MongoDBResourcesGetMongoDBDatabase_574797 = ref object of OpenApiRestCall_573668
proc url_MongoDBResourcesGetMongoDBDatabase_574799(protocol: Scheme; host: string;
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

proc validate_MongoDBResourcesGetMongoDBDatabase_574798(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the MongoDB databases under an existing Azure Cosmos DB database account with the provided name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574800 = path.getOrDefault("resourceGroupName")
  valid_574800 = validateParameter(valid_574800, JString, required = true,
                                 default = nil)
  if valid_574800 != nil:
    section.add "resourceGroupName", valid_574800
  var valid_574801 = path.getOrDefault("subscriptionId")
  valid_574801 = validateParameter(valid_574801, JString, required = true,
                                 default = nil)
  if valid_574801 != nil:
    section.add "subscriptionId", valid_574801
  var valid_574802 = path.getOrDefault("databaseName")
  valid_574802 = validateParameter(valid_574802, JString, required = true,
                                 default = nil)
  if valid_574802 != nil:
    section.add "databaseName", valid_574802
  var valid_574803 = path.getOrDefault("accountName")
  valid_574803 = validateParameter(valid_574803, JString, required = true,
                                 default = nil)
  if valid_574803 != nil:
    section.add "accountName", valid_574803
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574804 = query.getOrDefault("api-version")
  valid_574804 = validateParameter(valid_574804, JString, required = true,
                                 default = nil)
  if valid_574804 != nil:
    section.add "api-version", valid_574804
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574805: Call_MongoDBResourcesGetMongoDBDatabase_574797;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the MongoDB databases under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_574805.validator(path, query, header, formData, body)
  let scheme = call_574805.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574805.url(scheme.get, call_574805.host, call_574805.base,
                         call_574805.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574805, url, valid)

proc call*(call_574806: Call_MongoDBResourcesGetMongoDBDatabase_574797;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; accountName: string): Recallable =
  ## mongoDBResourcesGetMongoDBDatabase
  ## Gets the MongoDB databases under an existing Azure Cosmos DB database account with the provided name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574807 = newJObject()
  var query_574808 = newJObject()
  add(path_574807, "resourceGroupName", newJString(resourceGroupName))
  add(query_574808, "api-version", newJString(apiVersion))
  add(path_574807, "subscriptionId", newJString(subscriptionId))
  add(path_574807, "databaseName", newJString(databaseName))
  add(path_574807, "accountName", newJString(accountName))
  result = call_574806.call(path_574807, query_574808, nil, nil, nil)

var mongoDBResourcesGetMongoDBDatabase* = Call_MongoDBResourcesGetMongoDBDatabase_574797(
    name: "mongoDBResourcesGetMongoDBDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/mongodbDatabases/{databaseName}",
    validator: validate_MongoDBResourcesGetMongoDBDatabase_574798, base: "",
    url: url_MongoDBResourcesGetMongoDBDatabase_574799, schemes: {Scheme.Https})
type
  Call_MongoDBResourcesDeleteMongoDBDatabase_574823 = ref object of OpenApiRestCall_573668
proc url_MongoDBResourcesDeleteMongoDBDatabase_574825(protocol: Scheme;
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

proc validate_MongoDBResourcesDeleteMongoDBDatabase_574824(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Azure Cosmos DB MongoDB database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574826 = path.getOrDefault("resourceGroupName")
  valid_574826 = validateParameter(valid_574826, JString, required = true,
                                 default = nil)
  if valid_574826 != nil:
    section.add "resourceGroupName", valid_574826
  var valid_574827 = path.getOrDefault("subscriptionId")
  valid_574827 = validateParameter(valid_574827, JString, required = true,
                                 default = nil)
  if valid_574827 != nil:
    section.add "subscriptionId", valid_574827
  var valid_574828 = path.getOrDefault("databaseName")
  valid_574828 = validateParameter(valid_574828, JString, required = true,
                                 default = nil)
  if valid_574828 != nil:
    section.add "databaseName", valid_574828
  var valid_574829 = path.getOrDefault("accountName")
  valid_574829 = validateParameter(valid_574829, JString, required = true,
                                 default = nil)
  if valid_574829 != nil:
    section.add "accountName", valid_574829
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574830 = query.getOrDefault("api-version")
  valid_574830 = validateParameter(valid_574830, JString, required = true,
                                 default = nil)
  if valid_574830 != nil:
    section.add "api-version", valid_574830
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574831: Call_MongoDBResourcesDeleteMongoDBDatabase_574823;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB MongoDB database.
  ## 
  let valid = call_574831.validator(path, query, header, formData, body)
  let scheme = call_574831.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574831.url(scheme.get, call_574831.host, call_574831.base,
                         call_574831.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574831, url, valid)

proc call*(call_574832: Call_MongoDBResourcesDeleteMongoDBDatabase_574823;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; accountName: string): Recallable =
  ## mongoDBResourcesDeleteMongoDBDatabase
  ## Deletes an existing Azure Cosmos DB MongoDB database.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574833 = newJObject()
  var query_574834 = newJObject()
  add(path_574833, "resourceGroupName", newJString(resourceGroupName))
  add(query_574834, "api-version", newJString(apiVersion))
  add(path_574833, "subscriptionId", newJString(subscriptionId))
  add(path_574833, "databaseName", newJString(databaseName))
  add(path_574833, "accountName", newJString(accountName))
  result = call_574832.call(path_574833, query_574834, nil, nil, nil)

var mongoDBResourcesDeleteMongoDBDatabase* = Call_MongoDBResourcesDeleteMongoDBDatabase_574823(
    name: "mongoDBResourcesDeleteMongoDBDatabase", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/mongodbDatabases/{databaseName}",
    validator: validate_MongoDBResourcesDeleteMongoDBDatabase_574824, base: "",
    url: url_MongoDBResourcesDeleteMongoDBDatabase_574825, schemes: {Scheme.Https})
type
  Call_MongoDBResourcesListMongoDBCollections_574835 = ref object of OpenApiRestCall_573668
proc url_MongoDBResourcesListMongoDBCollections_574837(protocol: Scheme;
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

proc validate_MongoDBResourcesListMongoDBCollections_574836(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the MongoDB collection under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574838 = path.getOrDefault("resourceGroupName")
  valid_574838 = validateParameter(valid_574838, JString, required = true,
                                 default = nil)
  if valid_574838 != nil:
    section.add "resourceGroupName", valid_574838
  var valid_574839 = path.getOrDefault("subscriptionId")
  valid_574839 = validateParameter(valid_574839, JString, required = true,
                                 default = nil)
  if valid_574839 != nil:
    section.add "subscriptionId", valid_574839
  var valid_574840 = path.getOrDefault("databaseName")
  valid_574840 = validateParameter(valid_574840, JString, required = true,
                                 default = nil)
  if valid_574840 != nil:
    section.add "databaseName", valid_574840
  var valid_574841 = path.getOrDefault("accountName")
  valid_574841 = validateParameter(valid_574841, JString, required = true,
                                 default = nil)
  if valid_574841 != nil:
    section.add "accountName", valid_574841
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574842 = query.getOrDefault("api-version")
  valid_574842 = validateParameter(valid_574842, JString, required = true,
                                 default = nil)
  if valid_574842 != nil:
    section.add "api-version", valid_574842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574843: Call_MongoDBResourcesListMongoDBCollections_574835;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the MongoDB collection under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_574843.validator(path, query, header, formData, body)
  let scheme = call_574843.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574843.url(scheme.get, call_574843.host, call_574843.base,
                         call_574843.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574843, url, valid)

proc call*(call_574844: Call_MongoDBResourcesListMongoDBCollections_574835;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; accountName: string): Recallable =
  ## mongoDBResourcesListMongoDBCollections
  ## Lists the MongoDB collection under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574845 = newJObject()
  var query_574846 = newJObject()
  add(path_574845, "resourceGroupName", newJString(resourceGroupName))
  add(query_574846, "api-version", newJString(apiVersion))
  add(path_574845, "subscriptionId", newJString(subscriptionId))
  add(path_574845, "databaseName", newJString(databaseName))
  add(path_574845, "accountName", newJString(accountName))
  result = call_574844.call(path_574845, query_574846, nil, nil, nil)

var mongoDBResourcesListMongoDBCollections* = Call_MongoDBResourcesListMongoDBCollections_574835(
    name: "mongoDBResourcesListMongoDBCollections", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/mongodbDatabases/{databaseName}/collections",
    validator: validate_MongoDBResourcesListMongoDBCollections_574836, base: "",
    url: url_MongoDBResourcesListMongoDBCollections_574837,
    schemes: {Scheme.Https})
type
  Call_MongoDBResourcesCreateUpdateMongoDBCollection_574860 = ref object of OpenApiRestCall_573668
proc url_MongoDBResourcesCreateUpdateMongoDBCollection_574862(protocol: Scheme;
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

proc validate_MongoDBResourcesCreateUpdateMongoDBCollection_574861(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Create or update an Azure Cosmos DB MongoDB Collection
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   collectionName: JString (required)
  ##                 : Cosmos DB collection name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574863 = path.getOrDefault("resourceGroupName")
  valid_574863 = validateParameter(valid_574863, JString, required = true,
                                 default = nil)
  if valid_574863 != nil:
    section.add "resourceGroupName", valid_574863
  var valid_574864 = path.getOrDefault("subscriptionId")
  valid_574864 = validateParameter(valid_574864, JString, required = true,
                                 default = nil)
  if valid_574864 != nil:
    section.add "subscriptionId", valid_574864
  var valid_574865 = path.getOrDefault("databaseName")
  valid_574865 = validateParameter(valid_574865, JString, required = true,
                                 default = nil)
  if valid_574865 != nil:
    section.add "databaseName", valid_574865
  var valid_574866 = path.getOrDefault("collectionName")
  valid_574866 = validateParameter(valid_574866, JString, required = true,
                                 default = nil)
  if valid_574866 != nil:
    section.add "collectionName", valid_574866
  var valid_574867 = path.getOrDefault("accountName")
  valid_574867 = validateParameter(valid_574867, JString, required = true,
                                 default = nil)
  if valid_574867 != nil:
    section.add "accountName", valid_574867
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574868 = query.getOrDefault("api-version")
  valid_574868 = validateParameter(valid_574868, JString, required = true,
                                 default = nil)
  if valid_574868 != nil:
    section.add "api-version", valid_574868
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

proc call*(call_574870: Call_MongoDBResourcesCreateUpdateMongoDBCollection_574860;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB MongoDB Collection
  ## 
  let valid = call_574870.validator(path, query, header, formData, body)
  let scheme = call_574870.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574870.url(scheme.get, call_574870.host, call_574870.base,
                         call_574870.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574870, url, valid)

proc call*(call_574871: Call_MongoDBResourcesCreateUpdateMongoDBCollection_574860;
          resourceGroupName: string;
          createUpdateMongoDBCollectionParameters: JsonNode; apiVersion: string;
          subscriptionId: string; databaseName: string; collectionName: string;
          accountName: string): Recallable =
  ## mongoDBResourcesCreateUpdateMongoDBCollection
  ## Create or update an Azure Cosmos DB MongoDB Collection
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   createUpdateMongoDBCollectionParameters: JObject (required)
  ##                                          : The parameters to provide for the current MongoDB Collection.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   collectionName: string (required)
  ##                 : Cosmos DB collection name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574872 = newJObject()
  var query_574873 = newJObject()
  var body_574874 = newJObject()
  add(path_574872, "resourceGroupName", newJString(resourceGroupName))
  if createUpdateMongoDBCollectionParameters != nil:
    body_574874 = createUpdateMongoDBCollectionParameters
  add(query_574873, "api-version", newJString(apiVersion))
  add(path_574872, "subscriptionId", newJString(subscriptionId))
  add(path_574872, "databaseName", newJString(databaseName))
  add(path_574872, "collectionName", newJString(collectionName))
  add(path_574872, "accountName", newJString(accountName))
  result = call_574871.call(path_574872, query_574873, nil, nil, body_574874)

var mongoDBResourcesCreateUpdateMongoDBCollection* = Call_MongoDBResourcesCreateUpdateMongoDBCollection_574860(
    name: "mongoDBResourcesCreateUpdateMongoDBCollection",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/mongodbDatabases/{databaseName}/collections/{collectionName}",
    validator: validate_MongoDBResourcesCreateUpdateMongoDBCollection_574861,
    base: "", url: url_MongoDBResourcesCreateUpdateMongoDBCollection_574862,
    schemes: {Scheme.Https})
type
  Call_MongoDBResourcesGetMongoDBCollection_574847 = ref object of OpenApiRestCall_573668
proc url_MongoDBResourcesGetMongoDBCollection_574849(protocol: Scheme;
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

proc validate_MongoDBResourcesGetMongoDBCollection_574848(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the MongoDB collection under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   collectionName: JString (required)
  ##                 : Cosmos DB collection name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574850 = path.getOrDefault("resourceGroupName")
  valid_574850 = validateParameter(valid_574850, JString, required = true,
                                 default = nil)
  if valid_574850 != nil:
    section.add "resourceGroupName", valid_574850
  var valid_574851 = path.getOrDefault("subscriptionId")
  valid_574851 = validateParameter(valid_574851, JString, required = true,
                                 default = nil)
  if valid_574851 != nil:
    section.add "subscriptionId", valid_574851
  var valid_574852 = path.getOrDefault("databaseName")
  valid_574852 = validateParameter(valid_574852, JString, required = true,
                                 default = nil)
  if valid_574852 != nil:
    section.add "databaseName", valid_574852
  var valid_574853 = path.getOrDefault("collectionName")
  valid_574853 = validateParameter(valid_574853, JString, required = true,
                                 default = nil)
  if valid_574853 != nil:
    section.add "collectionName", valid_574853
  var valid_574854 = path.getOrDefault("accountName")
  valid_574854 = validateParameter(valid_574854, JString, required = true,
                                 default = nil)
  if valid_574854 != nil:
    section.add "accountName", valid_574854
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574855 = query.getOrDefault("api-version")
  valid_574855 = validateParameter(valid_574855, JString, required = true,
                                 default = nil)
  if valid_574855 != nil:
    section.add "api-version", valid_574855
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574856: Call_MongoDBResourcesGetMongoDBCollection_574847;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the MongoDB collection under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_574856.validator(path, query, header, formData, body)
  let scheme = call_574856.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574856.url(scheme.get, call_574856.host, call_574856.base,
                         call_574856.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574856, url, valid)

proc call*(call_574857: Call_MongoDBResourcesGetMongoDBCollection_574847;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; collectionName: string; accountName: string): Recallable =
  ## mongoDBResourcesGetMongoDBCollection
  ## Gets the MongoDB collection under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   collectionName: string (required)
  ##                 : Cosmos DB collection name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574858 = newJObject()
  var query_574859 = newJObject()
  add(path_574858, "resourceGroupName", newJString(resourceGroupName))
  add(query_574859, "api-version", newJString(apiVersion))
  add(path_574858, "subscriptionId", newJString(subscriptionId))
  add(path_574858, "databaseName", newJString(databaseName))
  add(path_574858, "collectionName", newJString(collectionName))
  add(path_574858, "accountName", newJString(accountName))
  result = call_574857.call(path_574858, query_574859, nil, nil, nil)

var mongoDBResourcesGetMongoDBCollection* = Call_MongoDBResourcesGetMongoDBCollection_574847(
    name: "mongoDBResourcesGetMongoDBCollection", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/mongodbDatabases/{databaseName}/collections/{collectionName}",
    validator: validate_MongoDBResourcesGetMongoDBCollection_574848, base: "",
    url: url_MongoDBResourcesGetMongoDBCollection_574849, schemes: {Scheme.Https})
type
  Call_MongoDBResourcesDeleteMongoDBCollection_574875 = ref object of OpenApiRestCall_573668
proc url_MongoDBResourcesDeleteMongoDBCollection_574877(protocol: Scheme;
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

proc validate_MongoDBResourcesDeleteMongoDBCollection_574876(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Azure Cosmos DB MongoDB Collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   collectionName: JString (required)
  ##                 : Cosmos DB collection name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574878 = path.getOrDefault("resourceGroupName")
  valid_574878 = validateParameter(valid_574878, JString, required = true,
                                 default = nil)
  if valid_574878 != nil:
    section.add "resourceGroupName", valid_574878
  var valid_574879 = path.getOrDefault("subscriptionId")
  valid_574879 = validateParameter(valid_574879, JString, required = true,
                                 default = nil)
  if valid_574879 != nil:
    section.add "subscriptionId", valid_574879
  var valid_574880 = path.getOrDefault("databaseName")
  valid_574880 = validateParameter(valid_574880, JString, required = true,
                                 default = nil)
  if valid_574880 != nil:
    section.add "databaseName", valid_574880
  var valid_574881 = path.getOrDefault("collectionName")
  valid_574881 = validateParameter(valid_574881, JString, required = true,
                                 default = nil)
  if valid_574881 != nil:
    section.add "collectionName", valid_574881
  var valid_574882 = path.getOrDefault("accountName")
  valid_574882 = validateParameter(valid_574882, JString, required = true,
                                 default = nil)
  if valid_574882 != nil:
    section.add "accountName", valid_574882
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574883 = query.getOrDefault("api-version")
  valid_574883 = validateParameter(valid_574883, JString, required = true,
                                 default = nil)
  if valid_574883 != nil:
    section.add "api-version", valid_574883
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574884: Call_MongoDBResourcesDeleteMongoDBCollection_574875;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB MongoDB Collection.
  ## 
  let valid = call_574884.validator(path, query, header, formData, body)
  let scheme = call_574884.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574884.url(scheme.get, call_574884.host, call_574884.base,
                         call_574884.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574884, url, valid)

proc call*(call_574885: Call_MongoDBResourcesDeleteMongoDBCollection_574875;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; collectionName: string; accountName: string): Recallable =
  ## mongoDBResourcesDeleteMongoDBCollection
  ## Deletes an existing Azure Cosmos DB MongoDB Collection.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   collectionName: string (required)
  ##                 : Cosmos DB collection name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574886 = newJObject()
  var query_574887 = newJObject()
  add(path_574886, "resourceGroupName", newJString(resourceGroupName))
  add(query_574887, "api-version", newJString(apiVersion))
  add(path_574886, "subscriptionId", newJString(subscriptionId))
  add(path_574886, "databaseName", newJString(databaseName))
  add(path_574886, "collectionName", newJString(collectionName))
  add(path_574886, "accountName", newJString(accountName))
  result = call_574885.call(path_574886, query_574887, nil, nil, nil)

var mongoDBResourcesDeleteMongoDBCollection* = Call_MongoDBResourcesDeleteMongoDBCollection_574875(
    name: "mongoDBResourcesDeleteMongoDBCollection", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/mongodbDatabases/{databaseName}/collections/{collectionName}",
    validator: validate_MongoDBResourcesDeleteMongoDBCollection_574876, base: "",
    url: url_MongoDBResourcesDeleteMongoDBCollection_574877,
    schemes: {Scheme.Https})
type
  Call_MongoDBResourcesUpdateMongoDBCollectionThroughput_574901 = ref object of OpenApiRestCall_573668
proc url_MongoDBResourcesUpdateMongoDBCollectionThroughput_574903(
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

proc validate_MongoDBResourcesUpdateMongoDBCollectionThroughput_574902(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Update the RUs per second of an Azure Cosmos DB MongoDB collection
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   collectionName: JString (required)
  ##                 : Cosmos DB collection name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574904 = path.getOrDefault("resourceGroupName")
  valid_574904 = validateParameter(valid_574904, JString, required = true,
                                 default = nil)
  if valid_574904 != nil:
    section.add "resourceGroupName", valid_574904
  var valid_574905 = path.getOrDefault("subscriptionId")
  valid_574905 = validateParameter(valid_574905, JString, required = true,
                                 default = nil)
  if valid_574905 != nil:
    section.add "subscriptionId", valid_574905
  var valid_574906 = path.getOrDefault("databaseName")
  valid_574906 = validateParameter(valid_574906, JString, required = true,
                                 default = nil)
  if valid_574906 != nil:
    section.add "databaseName", valid_574906
  var valid_574907 = path.getOrDefault("collectionName")
  valid_574907 = validateParameter(valid_574907, JString, required = true,
                                 default = nil)
  if valid_574907 != nil:
    section.add "collectionName", valid_574907
  var valid_574908 = path.getOrDefault("accountName")
  valid_574908 = validateParameter(valid_574908, JString, required = true,
                                 default = nil)
  if valid_574908 != nil:
    section.add "accountName", valid_574908
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574909 = query.getOrDefault("api-version")
  valid_574909 = validateParameter(valid_574909, JString, required = true,
                                 default = nil)
  if valid_574909 != nil:
    section.add "api-version", valid_574909
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

proc call*(call_574911: Call_MongoDBResourcesUpdateMongoDBCollectionThroughput_574901;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the RUs per second of an Azure Cosmos DB MongoDB collection
  ## 
  let valid = call_574911.validator(path, query, header, formData, body)
  let scheme = call_574911.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574911.url(scheme.get, call_574911.host, call_574911.base,
                         call_574911.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574911, url, valid)

proc call*(call_574912: Call_MongoDBResourcesUpdateMongoDBCollectionThroughput_574901;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; updateThroughputParameters: JsonNode;
          collectionName: string; accountName: string): Recallable =
  ## mongoDBResourcesUpdateMongoDBCollectionThroughput
  ## Update the RUs per second of an Azure Cosmos DB MongoDB collection
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   updateThroughputParameters: JObject (required)
  ##                             : The RUs per second of the parameters to provide for the current MongoDB collection.
  ##   collectionName: string (required)
  ##                 : Cosmos DB collection name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574913 = newJObject()
  var query_574914 = newJObject()
  var body_574915 = newJObject()
  add(path_574913, "resourceGroupName", newJString(resourceGroupName))
  add(query_574914, "api-version", newJString(apiVersion))
  add(path_574913, "subscriptionId", newJString(subscriptionId))
  add(path_574913, "databaseName", newJString(databaseName))
  if updateThroughputParameters != nil:
    body_574915 = updateThroughputParameters
  add(path_574913, "collectionName", newJString(collectionName))
  add(path_574913, "accountName", newJString(accountName))
  result = call_574912.call(path_574913, query_574914, nil, nil, body_574915)

var mongoDBResourcesUpdateMongoDBCollectionThroughput* = Call_MongoDBResourcesUpdateMongoDBCollectionThroughput_574901(
    name: "mongoDBResourcesUpdateMongoDBCollectionThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/mongodbDatabases/{databaseName}/collections/{collectionName}/throughputSettings/default",
    validator: validate_MongoDBResourcesUpdateMongoDBCollectionThroughput_574902,
    base: "", url: url_MongoDBResourcesUpdateMongoDBCollectionThroughput_574903,
    schemes: {Scheme.Https})
type
  Call_MongoDBResourcesGetMongoDBCollectionThroughput_574888 = ref object of OpenApiRestCall_573668
proc url_MongoDBResourcesGetMongoDBCollectionThroughput_574890(protocol: Scheme;
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

proc validate_MongoDBResourcesGetMongoDBCollectionThroughput_574889(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the RUs per second of the MongoDB collection under an existing Azure Cosmos DB database account with the provided name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   collectionName: JString (required)
  ##                 : Cosmos DB collection name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574891 = path.getOrDefault("resourceGroupName")
  valid_574891 = validateParameter(valid_574891, JString, required = true,
                                 default = nil)
  if valid_574891 != nil:
    section.add "resourceGroupName", valid_574891
  var valid_574892 = path.getOrDefault("subscriptionId")
  valid_574892 = validateParameter(valid_574892, JString, required = true,
                                 default = nil)
  if valid_574892 != nil:
    section.add "subscriptionId", valid_574892
  var valid_574893 = path.getOrDefault("databaseName")
  valid_574893 = validateParameter(valid_574893, JString, required = true,
                                 default = nil)
  if valid_574893 != nil:
    section.add "databaseName", valid_574893
  var valid_574894 = path.getOrDefault("collectionName")
  valid_574894 = validateParameter(valid_574894, JString, required = true,
                                 default = nil)
  if valid_574894 != nil:
    section.add "collectionName", valid_574894
  var valid_574895 = path.getOrDefault("accountName")
  valid_574895 = validateParameter(valid_574895, JString, required = true,
                                 default = nil)
  if valid_574895 != nil:
    section.add "accountName", valid_574895
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574896 = query.getOrDefault("api-version")
  valid_574896 = validateParameter(valid_574896, JString, required = true,
                                 default = nil)
  if valid_574896 != nil:
    section.add "api-version", valid_574896
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574897: Call_MongoDBResourcesGetMongoDBCollectionThroughput_574888;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the MongoDB collection under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_574897.validator(path, query, header, formData, body)
  let scheme = call_574897.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574897.url(scheme.get, call_574897.host, call_574897.base,
                         call_574897.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574897, url, valid)

proc call*(call_574898: Call_MongoDBResourcesGetMongoDBCollectionThroughput_574888;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; collectionName: string; accountName: string): Recallable =
  ## mongoDBResourcesGetMongoDBCollectionThroughput
  ## Gets the RUs per second of the MongoDB collection under an existing Azure Cosmos DB database account with the provided name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   collectionName: string (required)
  ##                 : Cosmos DB collection name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574899 = newJObject()
  var query_574900 = newJObject()
  add(path_574899, "resourceGroupName", newJString(resourceGroupName))
  add(query_574900, "api-version", newJString(apiVersion))
  add(path_574899, "subscriptionId", newJString(subscriptionId))
  add(path_574899, "databaseName", newJString(databaseName))
  add(path_574899, "collectionName", newJString(collectionName))
  add(path_574899, "accountName", newJString(accountName))
  result = call_574898.call(path_574899, query_574900, nil, nil, nil)

var mongoDBResourcesGetMongoDBCollectionThroughput* = Call_MongoDBResourcesGetMongoDBCollectionThroughput_574888(
    name: "mongoDBResourcesGetMongoDBCollectionThroughput",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/mongodbDatabases/{databaseName}/collections/{collectionName}/throughputSettings/default",
    validator: validate_MongoDBResourcesGetMongoDBCollectionThroughput_574889,
    base: "", url: url_MongoDBResourcesGetMongoDBCollectionThroughput_574890,
    schemes: {Scheme.Https})
type
  Call_MongoDBResourcesUpdateMongoDBDatabaseThroughput_574928 = ref object of OpenApiRestCall_573668
proc url_MongoDBResourcesUpdateMongoDBDatabaseThroughput_574930(protocol: Scheme;
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

proc validate_MongoDBResourcesUpdateMongoDBDatabaseThroughput_574929(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Update RUs per second of the an Azure Cosmos DB MongoDB database
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574931 = path.getOrDefault("resourceGroupName")
  valid_574931 = validateParameter(valid_574931, JString, required = true,
                                 default = nil)
  if valid_574931 != nil:
    section.add "resourceGroupName", valid_574931
  var valid_574932 = path.getOrDefault("subscriptionId")
  valid_574932 = validateParameter(valid_574932, JString, required = true,
                                 default = nil)
  if valid_574932 != nil:
    section.add "subscriptionId", valid_574932
  var valid_574933 = path.getOrDefault("databaseName")
  valid_574933 = validateParameter(valid_574933, JString, required = true,
                                 default = nil)
  if valid_574933 != nil:
    section.add "databaseName", valid_574933
  var valid_574934 = path.getOrDefault("accountName")
  valid_574934 = validateParameter(valid_574934, JString, required = true,
                                 default = nil)
  if valid_574934 != nil:
    section.add "accountName", valid_574934
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574935 = query.getOrDefault("api-version")
  valid_574935 = validateParameter(valid_574935, JString, required = true,
                                 default = nil)
  if valid_574935 != nil:
    section.add "api-version", valid_574935
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

proc call*(call_574937: Call_MongoDBResourcesUpdateMongoDBDatabaseThroughput_574928;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of the an Azure Cosmos DB MongoDB database
  ## 
  let valid = call_574937.validator(path, query, header, formData, body)
  let scheme = call_574937.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574937.url(scheme.get, call_574937.host, call_574937.base,
                         call_574937.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574937, url, valid)

proc call*(call_574938: Call_MongoDBResourcesUpdateMongoDBDatabaseThroughput_574928;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; updateThroughputParameters: JsonNode;
          accountName: string): Recallable =
  ## mongoDBResourcesUpdateMongoDBDatabaseThroughput
  ## Update RUs per second of the an Azure Cosmos DB MongoDB database
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   updateThroughputParameters: JObject (required)
  ##                             : The RUs per second of the parameters to provide for the current MongoDB database.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574939 = newJObject()
  var query_574940 = newJObject()
  var body_574941 = newJObject()
  add(path_574939, "resourceGroupName", newJString(resourceGroupName))
  add(query_574940, "api-version", newJString(apiVersion))
  add(path_574939, "subscriptionId", newJString(subscriptionId))
  add(path_574939, "databaseName", newJString(databaseName))
  if updateThroughputParameters != nil:
    body_574941 = updateThroughputParameters
  add(path_574939, "accountName", newJString(accountName))
  result = call_574938.call(path_574939, query_574940, nil, nil, body_574941)

var mongoDBResourcesUpdateMongoDBDatabaseThroughput* = Call_MongoDBResourcesUpdateMongoDBDatabaseThroughput_574928(
    name: "mongoDBResourcesUpdateMongoDBDatabaseThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/mongodbDatabases/{databaseName}/throughputSettings/default",
    validator: validate_MongoDBResourcesUpdateMongoDBDatabaseThroughput_574929,
    base: "", url: url_MongoDBResourcesUpdateMongoDBDatabaseThroughput_574930,
    schemes: {Scheme.Https})
type
  Call_MongoDBResourcesGetMongoDBDatabaseThroughput_574916 = ref object of OpenApiRestCall_573668
proc url_MongoDBResourcesGetMongoDBDatabaseThroughput_574918(protocol: Scheme;
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

proc validate_MongoDBResourcesGetMongoDBDatabaseThroughput_574917(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the RUs per second of the MongoDB database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574919 = path.getOrDefault("resourceGroupName")
  valid_574919 = validateParameter(valid_574919, JString, required = true,
                                 default = nil)
  if valid_574919 != nil:
    section.add "resourceGroupName", valid_574919
  var valid_574920 = path.getOrDefault("subscriptionId")
  valid_574920 = validateParameter(valid_574920, JString, required = true,
                                 default = nil)
  if valid_574920 != nil:
    section.add "subscriptionId", valid_574920
  var valid_574921 = path.getOrDefault("databaseName")
  valid_574921 = validateParameter(valid_574921, JString, required = true,
                                 default = nil)
  if valid_574921 != nil:
    section.add "databaseName", valid_574921
  var valid_574922 = path.getOrDefault("accountName")
  valid_574922 = validateParameter(valid_574922, JString, required = true,
                                 default = nil)
  if valid_574922 != nil:
    section.add "accountName", valid_574922
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574923 = query.getOrDefault("api-version")
  valid_574923 = validateParameter(valid_574923, JString, required = true,
                                 default = nil)
  if valid_574923 != nil:
    section.add "api-version", valid_574923
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574924: Call_MongoDBResourcesGetMongoDBDatabaseThroughput_574916;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the MongoDB database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_574924.validator(path, query, header, formData, body)
  let scheme = call_574924.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574924.url(scheme.get, call_574924.host, call_574924.base,
                         call_574924.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574924, url, valid)

proc call*(call_574925: Call_MongoDBResourcesGetMongoDBDatabaseThroughput_574916;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; accountName: string): Recallable =
  ## mongoDBResourcesGetMongoDBDatabaseThroughput
  ## Gets the RUs per second of the MongoDB database under an existing Azure Cosmos DB database account with the provided name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574926 = newJObject()
  var query_574927 = newJObject()
  add(path_574926, "resourceGroupName", newJString(resourceGroupName))
  add(query_574927, "api-version", newJString(apiVersion))
  add(path_574926, "subscriptionId", newJString(subscriptionId))
  add(path_574926, "databaseName", newJString(databaseName))
  add(path_574926, "accountName", newJString(accountName))
  result = call_574925.call(path_574926, query_574927, nil, nil, nil)

var mongoDBResourcesGetMongoDBDatabaseThroughput* = Call_MongoDBResourcesGetMongoDBDatabaseThroughput_574916(
    name: "mongoDBResourcesGetMongoDBDatabaseThroughput",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/mongodbDatabases/{databaseName}/throughputSettings/default",
    validator: validate_MongoDBResourcesGetMongoDBDatabaseThroughput_574917,
    base: "", url: url_MongoDBResourcesGetMongoDBDatabaseThroughput_574918,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsOfflineRegion_574942 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsOfflineRegion_574944(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsOfflineRegion_574943(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Offline the specified region for the specified Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574945 = path.getOrDefault("resourceGroupName")
  valid_574945 = validateParameter(valid_574945, JString, required = true,
                                 default = nil)
  if valid_574945 != nil:
    section.add "resourceGroupName", valid_574945
  var valid_574946 = path.getOrDefault("subscriptionId")
  valid_574946 = validateParameter(valid_574946, JString, required = true,
                                 default = nil)
  if valid_574946 != nil:
    section.add "subscriptionId", valid_574946
  var valid_574947 = path.getOrDefault("accountName")
  valid_574947 = validateParameter(valid_574947, JString, required = true,
                                 default = nil)
  if valid_574947 != nil:
    section.add "accountName", valid_574947
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574948 = query.getOrDefault("api-version")
  valid_574948 = validateParameter(valid_574948, JString, required = true,
                                 default = nil)
  if valid_574948 != nil:
    section.add "api-version", valid_574948
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

proc call*(call_574950: Call_DatabaseAccountsOfflineRegion_574942; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Offline the specified region for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_574950.validator(path, query, header, formData, body)
  let scheme = call_574950.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574950.url(scheme.get, call_574950.host, call_574950.base,
                         call_574950.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574950, url, valid)

proc call*(call_574951: Call_DatabaseAccountsOfflineRegion_574942;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          regionParameterForOffline: JsonNode; accountName: string): Recallable =
  ## databaseAccountsOfflineRegion
  ## Offline the specified region for the specified Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   regionParameterForOffline: JObject (required)
  ##                            : Cosmos DB region to offline for the database account.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574952 = newJObject()
  var query_574953 = newJObject()
  var body_574954 = newJObject()
  add(path_574952, "resourceGroupName", newJString(resourceGroupName))
  add(query_574953, "api-version", newJString(apiVersion))
  add(path_574952, "subscriptionId", newJString(subscriptionId))
  if regionParameterForOffline != nil:
    body_574954 = regionParameterForOffline
  add(path_574952, "accountName", newJString(accountName))
  result = call_574951.call(path_574952, query_574953, nil, nil, body_574954)

var databaseAccountsOfflineRegion* = Call_DatabaseAccountsOfflineRegion_574942(
    name: "databaseAccountsOfflineRegion", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/offlineRegion",
    validator: validate_DatabaseAccountsOfflineRegion_574943, base: "",
    url: url_DatabaseAccountsOfflineRegion_574944, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsOnlineRegion_574955 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsOnlineRegion_574957(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsOnlineRegion_574956(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Online the specified region for the specified Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574958 = path.getOrDefault("resourceGroupName")
  valid_574958 = validateParameter(valid_574958, JString, required = true,
                                 default = nil)
  if valid_574958 != nil:
    section.add "resourceGroupName", valid_574958
  var valid_574959 = path.getOrDefault("subscriptionId")
  valid_574959 = validateParameter(valid_574959, JString, required = true,
                                 default = nil)
  if valid_574959 != nil:
    section.add "subscriptionId", valid_574959
  var valid_574960 = path.getOrDefault("accountName")
  valid_574960 = validateParameter(valid_574960, JString, required = true,
                                 default = nil)
  if valid_574960 != nil:
    section.add "accountName", valid_574960
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574961 = query.getOrDefault("api-version")
  valid_574961 = validateParameter(valid_574961, JString, required = true,
                                 default = nil)
  if valid_574961 != nil:
    section.add "api-version", valid_574961
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

proc call*(call_574963: Call_DatabaseAccountsOnlineRegion_574955; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Online the specified region for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_574963.validator(path, query, header, formData, body)
  let scheme = call_574963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574963.url(scheme.get, call_574963.host, call_574963.base,
                         call_574963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574963, url, valid)

proc call*(call_574964: Call_DatabaseAccountsOnlineRegion_574955;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          regionParameterForOnline: JsonNode; accountName: string): Recallable =
  ## databaseAccountsOnlineRegion
  ## Online the specified region for the specified Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   regionParameterForOnline: JObject (required)
  ##                           : Cosmos DB region to online for the database account.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574965 = newJObject()
  var query_574966 = newJObject()
  var body_574967 = newJObject()
  add(path_574965, "resourceGroupName", newJString(resourceGroupName))
  add(query_574966, "api-version", newJString(apiVersion))
  add(path_574965, "subscriptionId", newJString(subscriptionId))
  if regionParameterForOnline != nil:
    body_574967 = regionParameterForOnline
  add(path_574965, "accountName", newJString(accountName))
  result = call_574964.call(path_574965, query_574966, nil, nil, body_574967)

var databaseAccountsOnlineRegion* = Call_DatabaseAccountsOnlineRegion_574955(
    name: "databaseAccountsOnlineRegion", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/onlineRegion",
    validator: validate_DatabaseAccountsOnlineRegion_574956, base: "",
    url: url_DatabaseAccountsOnlineRegion_574957, schemes: {Scheme.Https})
type
  Call_PercentileListMetrics_574968 = ref object of OpenApiRestCall_573668
proc url_PercentileListMetrics_574970(protocol: Scheme; host: string; base: string;
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

proc validate_PercentileListMetrics_574969(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the metrics determined by the given filter for the given database account. This url is only for PBS and Replication Latency data
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574971 = path.getOrDefault("resourceGroupName")
  valid_574971 = validateParameter(valid_574971, JString, required = true,
                                 default = nil)
  if valid_574971 != nil:
    section.add "resourceGroupName", valid_574971
  var valid_574972 = path.getOrDefault("subscriptionId")
  valid_574972 = validateParameter(valid_574972, JString, required = true,
                                 default = nil)
  if valid_574972 != nil:
    section.add "subscriptionId", valid_574972
  var valid_574973 = path.getOrDefault("accountName")
  valid_574973 = validateParameter(valid_574973, JString, required = true,
                                 default = nil)
  if valid_574973 != nil:
    section.add "accountName", valid_574973
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574974 = query.getOrDefault("api-version")
  valid_574974 = validateParameter(valid_574974, JString, required = true,
                                 default = nil)
  if valid_574974 != nil:
    section.add "api-version", valid_574974
  var valid_574975 = query.getOrDefault("$filter")
  valid_574975 = validateParameter(valid_574975, JString, required = true,
                                 default = nil)
  if valid_574975 != nil:
    section.add "$filter", valid_574975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574976: Call_PercentileListMetrics_574968; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account. This url is only for PBS and Replication Latency data
  ## 
  let valid = call_574976.validator(path, query, header, formData, body)
  let scheme = call_574976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574976.url(scheme.get, call_574976.host, call_574976.base,
                         call_574976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574976, url, valid)

proc call*(call_574977: Call_PercentileListMetrics_574968;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string; Filter: string): Recallable =
  ## percentileListMetrics
  ## Retrieves the metrics determined by the given filter for the given database account. This url is only for PBS and Replication Latency data
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  var path_574978 = newJObject()
  var query_574979 = newJObject()
  add(path_574978, "resourceGroupName", newJString(resourceGroupName))
  add(query_574979, "api-version", newJString(apiVersion))
  add(path_574978, "subscriptionId", newJString(subscriptionId))
  add(path_574978, "accountName", newJString(accountName))
  add(query_574979, "$filter", newJString(Filter))
  result = call_574977.call(path_574978, query_574979, nil, nil, nil)

var percentileListMetrics* = Call_PercentileListMetrics_574968(
    name: "percentileListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/percentile/metrics",
    validator: validate_PercentileListMetrics_574969, base: "",
    url: url_PercentileListMetrics_574970, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListReadOnlyKeys_574991 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsListReadOnlyKeys_574993(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListReadOnlyKeys_574992(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the read-only access keys for the specified Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574994 = path.getOrDefault("resourceGroupName")
  valid_574994 = validateParameter(valid_574994, JString, required = true,
                                 default = nil)
  if valid_574994 != nil:
    section.add "resourceGroupName", valid_574994
  var valid_574995 = path.getOrDefault("subscriptionId")
  valid_574995 = validateParameter(valid_574995, JString, required = true,
                                 default = nil)
  if valid_574995 != nil:
    section.add "subscriptionId", valid_574995
  var valid_574996 = path.getOrDefault("accountName")
  valid_574996 = validateParameter(valid_574996, JString, required = true,
                                 default = nil)
  if valid_574996 != nil:
    section.add "accountName", valid_574996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574997 = query.getOrDefault("api-version")
  valid_574997 = validateParameter(valid_574997, JString, required = true,
                                 default = nil)
  if valid_574997 != nil:
    section.add "api-version", valid_574997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574998: Call_DatabaseAccountsListReadOnlyKeys_574991;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the read-only access keys for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_574998.validator(path, query, header, formData, body)
  let scheme = call_574998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574998.url(scheme.get, call_574998.host, call_574998.base,
                         call_574998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574998, url, valid)

proc call*(call_574999: Call_DatabaseAccountsListReadOnlyKeys_574991;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## databaseAccountsListReadOnlyKeys
  ## Lists the read-only access keys for the specified Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575000 = newJObject()
  var query_575001 = newJObject()
  add(path_575000, "resourceGroupName", newJString(resourceGroupName))
  add(query_575001, "api-version", newJString(apiVersion))
  add(path_575000, "subscriptionId", newJString(subscriptionId))
  add(path_575000, "accountName", newJString(accountName))
  result = call_574999.call(path_575000, query_575001, nil, nil, nil)

var databaseAccountsListReadOnlyKeys* = Call_DatabaseAccountsListReadOnlyKeys_574991(
    name: "databaseAccountsListReadOnlyKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/readonlykeys",
    validator: validate_DatabaseAccountsListReadOnlyKeys_574992, base: "",
    url: url_DatabaseAccountsListReadOnlyKeys_574993, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetReadOnlyKeys_574980 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsGetReadOnlyKeys_574982(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsGetReadOnlyKeys_574981(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the read-only access keys for the specified Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574983 = path.getOrDefault("resourceGroupName")
  valid_574983 = validateParameter(valid_574983, JString, required = true,
                                 default = nil)
  if valid_574983 != nil:
    section.add "resourceGroupName", valid_574983
  var valid_574984 = path.getOrDefault("subscriptionId")
  valid_574984 = validateParameter(valid_574984, JString, required = true,
                                 default = nil)
  if valid_574984 != nil:
    section.add "subscriptionId", valid_574984
  var valid_574985 = path.getOrDefault("accountName")
  valid_574985 = validateParameter(valid_574985, JString, required = true,
                                 default = nil)
  if valid_574985 != nil:
    section.add "accountName", valid_574985
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574986 = query.getOrDefault("api-version")
  valid_574986 = validateParameter(valid_574986, JString, required = true,
                                 default = nil)
  if valid_574986 != nil:
    section.add "api-version", valid_574986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574987: Call_DatabaseAccountsGetReadOnlyKeys_574980;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the read-only access keys for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_574987.validator(path, query, header, formData, body)
  let scheme = call_574987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574987.url(scheme.get, call_574987.host, call_574987.base,
                         call_574987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574987, url, valid)

proc call*(call_574988: Call_DatabaseAccountsGetReadOnlyKeys_574980;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## databaseAccountsGetReadOnlyKeys
  ## Lists the read-only access keys for the specified Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574989 = newJObject()
  var query_574990 = newJObject()
  add(path_574989, "resourceGroupName", newJString(resourceGroupName))
  add(query_574990, "api-version", newJString(apiVersion))
  add(path_574989, "subscriptionId", newJString(subscriptionId))
  add(path_574989, "accountName", newJString(accountName))
  result = call_574988.call(path_574989, query_574990, nil, nil, nil)

var databaseAccountsGetReadOnlyKeys* = Call_DatabaseAccountsGetReadOnlyKeys_574980(
    name: "databaseAccountsGetReadOnlyKeys", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/readonlykeys",
    validator: validate_DatabaseAccountsGetReadOnlyKeys_574981, base: "",
    url: url_DatabaseAccountsGetReadOnlyKeys_574982, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsRegenerateKey_575002 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsRegenerateKey_575004(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsRegenerateKey_575003(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates an access key for the specified Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575005 = path.getOrDefault("resourceGroupName")
  valid_575005 = validateParameter(valid_575005, JString, required = true,
                                 default = nil)
  if valid_575005 != nil:
    section.add "resourceGroupName", valid_575005
  var valid_575006 = path.getOrDefault("subscriptionId")
  valid_575006 = validateParameter(valid_575006, JString, required = true,
                                 default = nil)
  if valid_575006 != nil:
    section.add "subscriptionId", valid_575006
  var valid_575007 = path.getOrDefault("accountName")
  valid_575007 = validateParameter(valid_575007, JString, required = true,
                                 default = nil)
  if valid_575007 != nil:
    section.add "accountName", valid_575007
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575008 = query.getOrDefault("api-version")
  valid_575008 = validateParameter(valid_575008, JString, required = true,
                                 default = nil)
  if valid_575008 != nil:
    section.add "api-version", valid_575008
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

proc call*(call_575010: Call_DatabaseAccountsRegenerateKey_575002; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates an access key for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_575010.validator(path, query, header, formData, body)
  let scheme = call_575010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575010.url(scheme.get, call_575010.host, call_575010.base,
                         call_575010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575010, url, valid)

proc call*(call_575011: Call_DatabaseAccountsRegenerateKey_575002;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string; keyToRegenerate: JsonNode): Recallable =
  ## databaseAccountsRegenerateKey
  ## Regenerates an access key for the specified Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   keyToRegenerate: JObject (required)
  ##                  : The name of the key to regenerate.
  var path_575012 = newJObject()
  var query_575013 = newJObject()
  var body_575014 = newJObject()
  add(path_575012, "resourceGroupName", newJString(resourceGroupName))
  add(query_575013, "api-version", newJString(apiVersion))
  add(path_575012, "subscriptionId", newJString(subscriptionId))
  add(path_575012, "accountName", newJString(accountName))
  if keyToRegenerate != nil:
    body_575014 = keyToRegenerate
  result = call_575011.call(path_575012, query_575013, nil, nil, body_575014)

var databaseAccountsRegenerateKey* = Call_DatabaseAccountsRegenerateKey_575002(
    name: "databaseAccountsRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/regenerateKey",
    validator: validate_DatabaseAccountsRegenerateKey_575003, base: "",
    url: url_DatabaseAccountsRegenerateKey_575004, schemes: {Scheme.Https})
type
  Call_CollectionRegionListMetrics_575015 = ref object of OpenApiRestCall_573668
proc url_CollectionRegionListMetrics_575017(protocol: Scheme; host: string;
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

proc validate_CollectionRegionListMetrics_575016(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the metrics determined by the given filter for the given database account, collection and region.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   collectionRid: JString (required)
  ##                : Cosmos DB collection rid.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   region: JString (required)
  ##         : Cosmos DB region, with spaces between words and each word capitalized.
  ##   databaseRid: JString (required)
  ##              : Cosmos DB database rid.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575018 = path.getOrDefault("resourceGroupName")
  valid_575018 = validateParameter(valid_575018, JString, required = true,
                                 default = nil)
  if valid_575018 != nil:
    section.add "resourceGroupName", valid_575018
  var valid_575019 = path.getOrDefault("collectionRid")
  valid_575019 = validateParameter(valid_575019, JString, required = true,
                                 default = nil)
  if valid_575019 != nil:
    section.add "collectionRid", valid_575019
  var valid_575020 = path.getOrDefault("subscriptionId")
  valid_575020 = validateParameter(valid_575020, JString, required = true,
                                 default = nil)
  if valid_575020 != nil:
    section.add "subscriptionId", valid_575020
  var valid_575021 = path.getOrDefault("region")
  valid_575021 = validateParameter(valid_575021, JString, required = true,
                                 default = nil)
  if valid_575021 != nil:
    section.add "region", valid_575021
  var valid_575022 = path.getOrDefault("databaseRid")
  valid_575022 = validateParameter(valid_575022, JString, required = true,
                                 default = nil)
  if valid_575022 != nil:
    section.add "databaseRid", valid_575022
  var valid_575023 = path.getOrDefault("accountName")
  valid_575023 = validateParameter(valid_575023, JString, required = true,
                                 default = nil)
  if valid_575023 != nil:
    section.add "accountName", valid_575023
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575024 = query.getOrDefault("api-version")
  valid_575024 = validateParameter(valid_575024, JString, required = true,
                                 default = nil)
  if valid_575024 != nil:
    section.add "api-version", valid_575024
  var valid_575025 = query.getOrDefault("$filter")
  valid_575025 = validateParameter(valid_575025, JString, required = true,
                                 default = nil)
  if valid_575025 != nil:
    section.add "$filter", valid_575025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575026: Call_CollectionRegionListMetrics_575015; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account, collection and region.
  ## 
  let valid = call_575026.validator(path, query, header, formData, body)
  let scheme = call_575026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575026.url(scheme.get, call_575026.host, call_575026.base,
                         call_575026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575026, url, valid)

proc call*(call_575027: Call_CollectionRegionListMetrics_575015;
          resourceGroupName: string; apiVersion: string; collectionRid: string;
          subscriptionId: string; region: string; databaseRid: string;
          accountName: string; Filter: string): Recallable =
  ## collectionRegionListMetrics
  ## Retrieves the metrics determined by the given filter for the given database account, collection and region.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   collectionRid: string (required)
  ##                : Cosmos DB collection rid.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   region: string (required)
  ##         : Cosmos DB region, with spaces between words and each word capitalized.
  ##   databaseRid: string (required)
  ##              : Cosmos DB database rid.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  var path_575028 = newJObject()
  var query_575029 = newJObject()
  add(path_575028, "resourceGroupName", newJString(resourceGroupName))
  add(query_575029, "api-version", newJString(apiVersion))
  add(path_575028, "collectionRid", newJString(collectionRid))
  add(path_575028, "subscriptionId", newJString(subscriptionId))
  add(path_575028, "region", newJString(region))
  add(path_575028, "databaseRid", newJString(databaseRid))
  add(path_575028, "accountName", newJString(accountName))
  add(query_575029, "$filter", newJString(Filter))
  result = call_575027.call(path_575028, query_575029, nil, nil, nil)

var collectionRegionListMetrics* = Call_CollectionRegionListMetrics_575015(
    name: "collectionRegionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/region/{region}/databases/{databaseRid}/collections/{collectionRid}/metrics",
    validator: validate_CollectionRegionListMetrics_575016, base: "",
    url: url_CollectionRegionListMetrics_575017, schemes: {Scheme.Https})
type
  Call_PartitionKeyRangeIdRegionListMetrics_575030 = ref object of OpenApiRestCall_573668
proc url_PartitionKeyRangeIdRegionListMetrics_575032(protocol: Scheme;
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

proc validate_PartitionKeyRangeIdRegionListMetrics_575031(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the metrics determined by the given filter for the given partition key range id and region.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   collectionRid: JString (required)
  ##                : Cosmos DB collection rid.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   partitionKeyRangeId: JString (required)
  ##                      : Partition Key Range Id for which to get data.
  ##   region: JString (required)
  ##         : Cosmos DB region, with spaces between words and each word capitalized.
  ##   databaseRid: JString (required)
  ##              : Cosmos DB database rid.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575033 = path.getOrDefault("resourceGroupName")
  valid_575033 = validateParameter(valid_575033, JString, required = true,
                                 default = nil)
  if valid_575033 != nil:
    section.add "resourceGroupName", valid_575033
  var valid_575034 = path.getOrDefault("collectionRid")
  valid_575034 = validateParameter(valid_575034, JString, required = true,
                                 default = nil)
  if valid_575034 != nil:
    section.add "collectionRid", valid_575034
  var valid_575035 = path.getOrDefault("subscriptionId")
  valid_575035 = validateParameter(valid_575035, JString, required = true,
                                 default = nil)
  if valid_575035 != nil:
    section.add "subscriptionId", valid_575035
  var valid_575036 = path.getOrDefault("partitionKeyRangeId")
  valid_575036 = validateParameter(valid_575036, JString, required = true,
                                 default = nil)
  if valid_575036 != nil:
    section.add "partitionKeyRangeId", valid_575036
  var valid_575037 = path.getOrDefault("region")
  valid_575037 = validateParameter(valid_575037, JString, required = true,
                                 default = nil)
  if valid_575037 != nil:
    section.add "region", valid_575037
  var valid_575038 = path.getOrDefault("databaseRid")
  valid_575038 = validateParameter(valid_575038, JString, required = true,
                                 default = nil)
  if valid_575038 != nil:
    section.add "databaseRid", valid_575038
  var valid_575039 = path.getOrDefault("accountName")
  valid_575039 = validateParameter(valid_575039, JString, required = true,
                                 default = nil)
  if valid_575039 != nil:
    section.add "accountName", valid_575039
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575040 = query.getOrDefault("api-version")
  valid_575040 = validateParameter(valid_575040, JString, required = true,
                                 default = nil)
  if valid_575040 != nil:
    section.add "api-version", valid_575040
  var valid_575041 = query.getOrDefault("$filter")
  valid_575041 = validateParameter(valid_575041, JString, required = true,
                                 default = nil)
  if valid_575041 != nil:
    section.add "$filter", valid_575041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575042: Call_PartitionKeyRangeIdRegionListMetrics_575030;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given partition key range id and region.
  ## 
  let valid = call_575042.validator(path, query, header, formData, body)
  let scheme = call_575042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575042.url(scheme.get, call_575042.host, call_575042.base,
                         call_575042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575042, url, valid)

proc call*(call_575043: Call_PartitionKeyRangeIdRegionListMetrics_575030;
          resourceGroupName: string; apiVersion: string; collectionRid: string;
          subscriptionId: string; partitionKeyRangeId: string; region: string;
          databaseRid: string; accountName: string; Filter: string): Recallable =
  ## partitionKeyRangeIdRegionListMetrics
  ## Retrieves the metrics determined by the given filter for the given partition key range id and region.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   collectionRid: string (required)
  ##                : Cosmos DB collection rid.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   partitionKeyRangeId: string (required)
  ##                      : Partition Key Range Id for which to get data.
  ##   region: string (required)
  ##         : Cosmos DB region, with spaces between words and each word capitalized.
  ##   databaseRid: string (required)
  ##              : Cosmos DB database rid.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  var path_575044 = newJObject()
  var query_575045 = newJObject()
  add(path_575044, "resourceGroupName", newJString(resourceGroupName))
  add(query_575045, "api-version", newJString(apiVersion))
  add(path_575044, "collectionRid", newJString(collectionRid))
  add(path_575044, "subscriptionId", newJString(subscriptionId))
  add(path_575044, "partitionKeyRangeId", newJString(partitionKeyRangeId))
  add(path_575044, "region", newJString(region))
  add(path_575044, "databaseRid", newJString(databaseRid))
  add(path_575044, "accountName", newJString(accountName))
  add(query_575045, "$filter", newJString(Filter))
  result = call_575043.call(path_575044, query_575045, nil, nil, nil)

var partitionKeyRangeIdRegionListMetrics* = Call_PartitionKeyRangeIdRegionListMetrics_575030(
    name: "partitionKeyRangeIdRegionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/region/{region}/databases/{databaseRid}/collections/{collectionRid}/partitionKeyRangeId/{partitionKeyRangeId}/metrics",
    validator: validate_PartitionKeyRangeIdRegionListMetrics_575031, base: "",
    url: url_PartitionKeyRangeIdRegionListMetrics_575032, schemes: {Scheme.Https})
type
  Call_CollectionPartitionRegionListMetrics_575046 = ref object of OpenApiRestCall_573668
proc url_CollectionPartitionRegionListMetrics_575048(protocol: Scheme;
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

proc validate_CollectionPartitionRegionListMetrics_575047(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the metrics determined by the given filter for the given collection and region, split by partition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   collectionRid: JString (required)
  ##                : Cosmos DB collection rid.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   region: JString (required)
  ##         : Cosmos DB region, with spaces between words and each word capitalized.
  ##   databaseRid: JString (required)
  ##              : Cosmos DB database rid.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575049 = path.getOrDefault("resourceGroupName")
  valid_575049 = validateParameter(valid_575049, JString, required = true,
                                 default = nil)
  if valid_575049 != nil:
    section.add "resourceGroupName", valid_575049
  var valid_575050 = path.getOrDefault("collectionRid")
  valid_575050 = validateParameter(valid_575050, JString, required = true,
                                 default = nil)
  if valid_575050 != nil:
    section.add "collectionRid", valid_575050
  var valid_575051 = path.getOrDefault("subscriptionId")
  valid_575051 = validateParameter(valid_575051, JString, required = true,
                                 default = nil)
  if valid_575051 != nil:
    section.add "subscriptionId", valid_575051
  var valid_575052 = path.getOrDefault("region")
  valid_575052 = validateParameter(valid_575052, JString, required = true,
                                 default = nil)
  if valid_575052 != nil:
    section.add "region", valid_575052
  var valid_575053 = path.getOrDefault("databaseRid")
  valid_575053 = validateParameter(valid_575053, JString, required = true,
                                 default = nil)
  if valid_575053 != nil:
    section.add "databaseRid", valid_575053
  var valid_575054 = path.getOrDefault("accountName")
  valid_575054 = validateParameter(valid_575054, JString, required = true,
                                 default = nil)
  if valid_575054 != nil:
    section.add "accountName", valid_575054
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575055 = query.getOrDefault("api-version")
  valid_575055 = validateParameter(valid_575055, JString, required = true,
                                 default = nil)
  if valid_575055 != nil:
    section.add "api-version", valid_575055
  var valid_575056 = query.getOrDefault("$filter")
  valid_575056 = validateParameter(valid_575056, JString, required = true,
                                 default = nil)
  if valid_575056 != nil:
    section.add "$filter", valid_575056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575057: Call_CollectionPartitionRegionListMetrics_575046;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given collection and region, split by partition.
  ## 
  let valid = call_575057.validator(path, query, header, formData, body)
  let scheme = call_575057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575057.url(scheme.get, call_575057.host, call_575057.base,
                         call_575057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575057, url, valid)

proc call*(call_575058: Call_CollectionPartitionRegionListMetrics_575046;
          resourceGroupName: string; apiVersion: string; collectionRid: string;
          subscriptionId: string; region: string; databaseRid: string;
          accountName: string; Filter: string): Recallable =
  ## collectionPartitionRegionListMetrics
  ## Retrieves the metrics determined by the given filter for the given collection and region, split by partition.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   collectionRid: string (required)
  ##                : Cosmos DB collection rid.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   region: string (required)
  ##         : Cosmos DB region, with spaces between words and each word capitalized.
  ##   databaseRid: string (required)
  ##              : Cosmos DB database rid.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  var path_575059 = newJObject()
  var query_575060 = newJObject()
  add(path_575059, "resourceGroupName", newJString(resourceGroupName))
  add(query_575060, "api-version", newJString(apiVersion))
  add(path_575059, "collectionRid", newJString(collectionRid))
  add(path_575059, "subscriptionId", newJString(subscriptionId))
  add(path_575059, "region", newJString(region))
  add(path_575059, "databaseRid", newJString(databaseRid))
  add(path_575059, "accountName", newJString(accountName))
  add(query_575060, "$filter", newJString(Filter))
  result = call_575058.call(path_575059, query_575060, nil, nil, nil)

var collectionPartitionRegionListMetrics* = Call_CollectionPartitionRegionListMetrics_575046(
    name: "collectionPartitionRegionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/region/{region}/databases/{databaseRid}/collections/{collectionRid}/partitions/metrics",
    validator: validate_CollectionPartitionRegionListMetrics_575047, base: "",
    url: url_CollectionPartitionRegionListMetrics_575048, schemes: {Scheme.Https})
type
  Call_DatabaseAccountRegionListMetrics_575061 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountRegionListMetrics_575063(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountRegionListMetrics_575062(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the metrics determined by the given filter for the given database account and region.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   region: JString (required)
  ##         : Cosmos DB region, with spaces between words and each word capitalized.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575064 = path.getOrDefault("resourceGroupName")
  valid_575064 = validateParameter(valid_575064, JString, required = true,
                                 default = nil)
  if valid_575064 != nil:
    section.add "resourceGroupName", valid_575064
  var valid_575065 = path.getOrDefault("subscriptionId")
  valid_575065 = validateParameter(valid_575065, JString, required = true,
                                 default = nil)
  if valid_575065 != nil:
    section.add "subscriptionId", valid_575065
  var valid_575066 = path.getOrDefault("region")
  valid_575066 = validateParameter(valid_575066, JString, required = true,
                                 default = nil)
  if valid_575066 != nil:
    section.add "region", valid_575066
  var valid_575067 = path.getOrDefault("accountName")
  valid_575067 = validateParameter(valid_575067, JString, required = true,
                                 default = nil)
  if valid_575067 != nil:
    section.add "accountName", valid_575067
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575068 = query.getOrDefault("api-version")
  valid_575068 = validateParameter(valid_575068, JString, required = true,
                                 default = nil)
  if valid_575068 != nil:
    section.add "api-version", valid_575068
  var valid_575069 = query.getOrDefault("$filter")
  valid_575069 = validateParameter(valid_575069, JString, required = true,
                                 default = nil)
  if valid_575069 != nil:
    section.add "$filter", valid_575069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575070: Call_DatabaseAccountRegionListMetrics_575061;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account and region.
  ## 
  let valid = call_575070.validator(path, query, header, formData, body)
  let scheme = call_575070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575070.url(scheme.get, call_575070.host, call_575070.base,
                         call_575070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575070, url, valid)

proc call*(call_575071: Call_DatabaseAccountRegionListMetrics_575061;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          region: string; accountName: string; Filter: string): Recallable =
  ## databaseAccountRegionListMetrics
  ## Retrieves the metrics determined by the given filter for the given database account and region.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   region: string (required)
  ##         : Cosmos DB region, with spaces between words and each word capitalized.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  var path_575072 = newJObject()
  var query_575073 = newJObject()
  add(path_575072, "resourceGroupName", newJString(resourceGroupName))
  add(query_575073, "api-version", newJString(apiVersion))
  add(path_575072, "subscriptionId", newJString(subscriptionId))
  add(path_575072, "region", newJString(region))
  add(path_575072, "accountName", newJString(accountName))
  add(query_575073, "$filter", newJString(Filter))
  result = call_575071.call(path_575072, query_575073, nil, nil, nil)

var databaseAccountRegionListMetrics* = Call_DatabaseAccountRegionListMetrics_575061(
    name: "databaseAccountRegionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/region/{region}/metrics",
    validator: validate_DatabaseAccountRegionListMetrics_575062, base: "",
    url: url_DatabaseAccountRegionListMetrics_575063, schemes: {Scheme.Https})
type
  Call_PercentileSourceTargetListMetrics_575074 = ref object of OpenApiRestCall_573668
proc url_PercentileSourceTargetListMetrics_575076(protocol: Scheme; host: string;
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

proc validate_PercentileSourceTargetListMetrics_575075(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the metrics determined by the given filter for the given account, source and target region. This url is only for PBS and Replication Latency data
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   sourceRegion: JString (required)
  ##               : Source region from which data is written. Cosmos DB region, with spaces between words and each word capitalized.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   targetRegion: JString (required)
  ##               : Target region to which data is written. Cosmos DB region, with spaces between words and each word capitalized.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575077 = path.getOrDefault("resourceGroupName")
  valid_575077 = validateParameter(valid_575077, JString, required = true,
                                 default = nil)
  if valid_575077 != nil:
    section.add "resourceGroupName", valid_575077
  var valid_575078 = path.getOrDefault("sourceRegion")
  valid_575078 = validateParameter(valid_575078, JString, required = true,
                                 default = nil)
  if valid_575078 != nil:
    section.add "sourceRegion", valid_575078
  var valid_575079 = path.getOrDefault("subscriptionId")
  valid_575079 = validateParameter(valid_575079, JString, required = true,
                                 default = nil)
  if valid_575079 != nil:
    section.add "subscriptionId", valid_575079
  var valid_575080 = path.getOrDefault("targetRegion")
  valid_575080 = validateParameter(valid_575080, JString, required = true,
                                 default = nil)
  if valid_575080 != nil:
    section.add "targetRegion", valid_575080
  var valid_575081 = path.getOrDefault("accountName")
  valid_575081 = validateParameter(valid_575081, JString, required = true,
                                 default = nil)
  if valid_575081 != nil:
    section.add "accountName", valid_575081
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575082 = query.getOrDefault("api-version")
  valid_575082 = validateParameter(valid_575082, JString, required = true,
                                 default = nil)
  if valid_575082 != nil:
    section.add "api-version", valid_575082
  var valid_575083 = query.getOrDefault("$filter")
  valid_575083 = validateParameter(valid_575083, JString, required = true,
                                 default = nil)
  if valid_575083 != nil:
    section.add "$filter", valid_575083
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575084: Call_PercentileSourceTargetListMetrics_575074;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given account, source and target region. This url is only for PBS and Replication Latency data
  ## 
  let valid = call_575084.validator(path, query, header, formData, body)
  let scheme = call_575084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575084.url(scheme.get, call_575084.host, call_575084.base,
                         call_575084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575084, url, valid)

proc call*(call_575085: Call_PercentileSourceTargetListMetrics_575074;
          resourceGroupName: string; apiVersion: string; sourceRegion: string;
          subscriptionId: string; targetRegion: string; accountName: string;
          Filter: string): Recallable =
  ## percentileSourceTargetListMetrics
  ## Retrieves the metrics determined by the given filter for the given account, source and target region. This url is only for PBS and Replication Latency data
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   sourceRegion: string (required)
  ##               : Source region from which data is written. Cosmos DB region, with spaces between words and each word capitalized.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   targetRegion: string (required)
  ##               : Target region to which data is written. Cosmos DB region, with spaces between words and each word capitalized.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  var path_575086 = newJObject()
  var query_575087 = newJObject()
  add(path_575086, "resourceGroupName", newJString(resourceGroupName))
  add(query_575087, "api-version", newJString(apiVersion))
  add(path_575086, "sourceRegion", newJString(sourceRegion))
  add(path_575086, "subscriptionId", newJString(subscriptionId))
  add(path_575086, "targetRegion", newJString(targetRegion))
  add(path_575086, "accountName", newJString(accountName))
  add(query_575087, "$filter", newJString(Filter))
  result = call_575085.call(path_575086, query_575087, nil, nil, nil)

var percentileSourceTargetListMetrics* = Call_PercentileSourceTargetListMetrics_575074(
    name: "percentileSourceTargetListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sourceRegion/{sourceRegion}/targetRegion/{targetRegion}/percentile/metrics",
    validator: validate_PercentileSourceTargetListMetrics_575075, base: "",
    url: url_PercentileSourceTargetListMetrics_575076, schemes: {Scheme.Https})
type
  Call_SqlResourcesListSqlDatabases_575088 = ref object of OpenApiRestCall_573668
proc url_SqlResourcesListSqlDatabases_575090(protocol: Scheme; host: string;
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

proc validate_SqlResourcesListSqlDatabases_575089(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the SQL databases under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575091 = path.getOrDefault("resourceGroupName")
  valid_575091 = validateParameter(valid_575091, JString, required = true,
                                 default = nil)
  if valid_575091 != nil:
    section.add "resourceGroupName", valid_575091
  var valid_575092 = path.getOrDefault("subscriptionId")
  valid_575092 = validateParameter(valid_575092, JString, required = true,
                                 default = nil)
  if valid_575092 != nil:
    section.add "subscriptionId", valid_575092
  var valid_575093 = path.getOrDefault("accountName")
  valid_575093 = validateParameter(valid_575093, JString, required = true,
                                 default = nil)
  if valid_575093 != nil:
    section.add "accountName", valid_575093
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575094 = query.getOrDefault("api-version")
  valid_575094 = validateParameter(valid_575094, JString, required = true,
                                 default = nil)
  if valid_575094 != nil:
    section.add "api-version", valid_575094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575095: Call_SqlResourcesListSqlDatabases_575088; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the SQL databases under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_575095.validator(path, query, header, formData, body)
  let scheme = call_575095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575095.url(scheme.get, call_575095.host, call_575095.base,
                         call_575095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575095, url, valid)

proc call*(call_575096: Call_SqlResourcesListSqlDatabases_575088;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## sqlResourcesListSqlDatabases
  ## Lists the SQL databases under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575097 = newJObject()
  var query_575098 = newJObject()
  add(path_575097, "resourceGroupName", newJString(resourceGroupName))
  add(query_575098, "api-version", newJString(apiVersion))
  add(path_575097, "subscriptionId", newJString(subscriptionId))
  add(path_575097, "accountName", newJString(accountName))
  result = call_575096.call(path_575097, query_575098, nil, nil, nil)

var sqlResourcesListSqlDatabases* = Call_SqlResourcesListSqlDatabases_575088(
    name: "sqlResourcesListSqlDatabases", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases",
    validator: validate_SqlResourcesListSqlDatabases_575089, base: "",
    url: url_SqlResourcesListSqlDatabases_575090, schemes: {Scheme.Https})
type
  Call_SqlResourcesCreateUpdateSqlDatabase_575111 = ref object of OpenApiRestCall_573668
proc url_SqlResourcesCreateUpdateSqlDatabase_575113(protocol: Scheme; host: string;
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

proc validate_SqlResourcesCreateUpdateSqlDatabase_575112(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an Azure Cosmos DB SQL database
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575114 = path.getOrDefault("resourceGroupName")
  valid_575114 = validateParameter(valid_575114, JString, required = true,
                                 default = nil)
  if valid_575114 != nil:
    section.add "resourceGroupName", valid_575114
  var valid_575115 = path.getOrDefault("subscriptionId")
  valid_575115 = validateParameter(valid_575115, JString, required = true,
                                 default = nil)
  if valid_575115 != nil:
    section.add "subscriptionId", valid_575115
  var valid_575116 = path.getOrDefault("databaseName")
  valid_575116 = validateParameter(valid_575116, JString, required = true,
                                 default = nil)
  if valid_575116 != nil:
    section.add "databaseName", valid_575116
  var valid_575117 = path.getOrDefault("accountName")
  valid_575117 = validateParameter(valid_575117, JString, required = true,
                                 default = nil)
  if valid_575117 != nil:
    section.add "accountName", valid_575117
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575118 = query.getOrDefault("api-version")
  valid_575118 = validateParameter(valid_575118, JString, required = true,
                                 default = nil)
  if valid_575118 != nil:
    section.add "api-version", valid_575118
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

proc call*(call_575120: Call_SqlResourcesCreateUpdateSqlDatabase_575111;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB SQL database
  ## 
  let valid = call_575120.validator(path, query, header, formData, body)
  let scheme = call_575120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575120.url(scheme.get, call_575120.host, call_575120.base,
                         call_575120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575120, url, valid)

proc call*(call_575121: Call_SqlResourcesCreateUpdateSqlDatabase_575111;
          createUpdateSqlDatabaseParameters: JsonNode; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; databaseName: string;
          accountName: string): Recallable =
  ## sqlResourcesCreateUpdateSqlDatabase
  ## Create or update an Azure Cosmos DB SQL database
  ##   createUpdateSqlDatabaseParameters: JObject (required)
  ##                                    : The parameters to provide for the current SQL database.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575122 = newJObject()
  var query_575123 = newJObject()
  var body_575124 = newJObject()
  if createUpdateSqlDatabaseParameters != nil:
    body_575124 = createUpdateSqlDatabaseParameters
  add(path_575122, "resourceGroupName", newJString(resourceGroupName))
  add(query_575123, "api-version", newJString(apiVersion))
  add(path_575122, "subscriptionId", newJString(subscriptionId))
  add(path_575122, "databaseName", newJString(databaseName))
  add(path_575122, "accountName", newJString(accountName))
  result = call_575121.call(path_575122, query_575123, nil, nil, body_575124)

var sqlResourcesCreateUpdateSqlDatabase* = Call_SqlResourcesCreateUpdateSqlDatabase_575111(
    name: "sqlResourcesCreateUpdateSqlDatabase", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}",
    validator: validate_SqlResourcesCreateUpdateSqlDatabase_575112, base: "",
    url: url_SqlResourcesCreateUpdateSqlDatabase_575113, schemes: {Scheme.Https})
type
  Call_SqlResourcesGetSqlDatabase_575099 = ref object of OpenApiRestCall_573668
proc url_SqlResourcesGetSqlDatabase_575101(protocol: Scheme; host: string;
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

proc validate_SqlResourcesGetSqlDatabase_575100(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the SQL database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575102 = path.getOrDefault("resourceGroupName")
  valid_575102 = validateParameter(valid_575102, JString, required = true,
                                 default = nil)
  if valid_575102 != nil:
    section.add "resourceGroupName", valid_575102
  var valid_575103 = path.getOrDefault("subscriptionId")
  valid_575103 = validateParameter(valid_575103, JString, required = true,
                                 default = nil)
  if valid_575103 != nil:
    section.add "subscriptionId", valid_575103
  var valid_575104 = path.getOrDefault("databaseName")
  valid_575104 = validateParameter(valid_575104, JString, required = true,
                                 default = nil)
  if valid_575104 != nil:
    section.add "databaseName", valid_575104
  var valid_575105 = path.getOrDefault("accountName")
  valid_575105 = validateParameter(valid_575105, JString, required = true,
                                 default = nil)
  if valid_575105 != nil:
    section.add "accountName", valid_575105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575106 = query.getOrDefault("api-version")
  valid_575106 = validateParameter(valid_575106, JString, required = true,
                                 default = nil)
  if valid_575106 != nil:
    section.add "api-version", valid_575106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575107: Call_SqlResourcesGetSqlDatabase_575099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the SQL database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_575107.validator(path, query, header, formData, body)
  let scheme = call_575107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575107.url(scheme.get, call_575107.host, call_575107.base,
                         call_575107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575107, url, valid)

proc call*(call_575108: Call_SqlResourcesGetSqlDatabase_575099;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; accountName: string): Recallable =
  ## sqlResourcesGetSqlDatabase
  ## Gets the SQL database under an existing Azure Cosmos DB database account with the provided name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575109 = newJObject()
  var query_575110 = newJObject()
  add(path_575109, "resourceGroupName", newJString(resourceGroupName))
  add(query_575110, "api-version", newJString(apiVersion))
  add(path_575109, "subscriptionId", newJString(subscriptionId))
  add(path_575109, "databaseName", newJString(databaseName))
  add(path_575109, "accountName", newJString(accountName))
  result = call_575108.call(path_575109, query_575110, nil, nil, nil)

var sqlResourcesGetSqlDatabase* = Call_SqlResourcesGetSqlDatabase_575099(
    name: "sqlResourcesGetSqlDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}",
    validator: validate_SqlResourcesGetSqlDatabase_575100, base: "",
    url: url_SqlResourcesGetSqlDatabase_575101, schemes: {Scheme.Https})
type
  Call_SqlResourcesDeleteSqlDatabase_575125 = ref object of OpenApiRestCall_573668
proc url_SqlResourcesDeleteSqlDatabase_575127(protocol: Scheme; host: string;
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

proc validate_SqlResourcesDeleteSqlDatabase_575126(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Azure Cosmos DB SQL database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575128 = path.getOrDefault("resourceGroupName")
  valid_575128 = validateParameter(valid_575128, JString, required = true,
                                 default = nil)
  if valid_575128 != nil:
    section.add "resourceGroupName", valid_575128
  var valid_575129 = path.getOrDefault("subscriptionId")
  valid_575129 = validateParameter(valid_575129, JString, required = true,
                                 default = nil)
  if valid_575129 != nil:
    section.add "subscriptionId", valid_575129
  var valid_575130 = path.getOrDefault("databaseName")
  valid_575130 = validateParameter(valid_575130, JString, required = true,
                                 default = nil)
  if valid_575130 != nil:
    section.add "databaseName", valid_575130
  var valid_575131 = path.getOrDefault("accountName")
  valid_575131 = validateParameter(valid_575131, JString, required = true,
                                 default = nil)
  if valid_575131 != nil:
    section.add "accountName", valid_575131
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575132 = query.getOrDefault("api-version")
  valid_575132 = validateParameter(valid_575132, JString, required = true,
                                 default = nil)
  if valid_575132 != nil:
    section.add "api-version", valid_575132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575133: Call_SqlResourcesDeleteSqlDatabase_575125; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB SQL database.
  ## 
  let valid = call_575133.validator(path, query, header, formData, body)
  let scheme = call_575133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575133.url(scheme.get, call_575133.host, call_575133.base,
                         call_575133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575133, url, valid)

proc call*(call_575134: Call_SqlResourcesDeleteSqlDatabase_575125;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; accountName: string): Recallable =
  ## sqlResourcesDeleteSqlDatabase
  ## Deletes an existing Azure Cosmos DB SQL database.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575135 = newJObject()
  var query_575136 = newJObject()
  add(path_575135, "resourceGroupName", newJString(resourceGroupName))
  add(query_575136, "api-version", newJString(apiVersion))
  add(path_575135, "subscriptionId", newJString(subscriptionId))
  add(path_575135, "databaseName", newJString(databaseName))
  add(path_575135, "accountName", newJString(accountName))
  result = call_575134.call(path_575135, query_575136, nil, nil, nil)

var sqlResourcesDeleteSqlDatabase* = Call_SqlResourcesDeleteSqlDatabase_575125(
    name: "sqlResourcesDeleteSqlDatabase", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}",
    validator: validate_SqlResourcesDeleteSqlDatabase_575126, base: "",
    url: url_SqlResourcesDeleteSqlDatabase_575127, schemes: {Scheme.Https})
type
  Call_SqlResourcesListSqlContainers_575137 = ref object of OpenApiRestCall_573668
proc url_SqlResourcesListSqlContainers_575139(protocol: Scheme; host: string;
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

proc validate_SqlResourcesListSqlContainers_575138(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the SQL container under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575140 = path.getOrDefault("resourceGroupName")
  valid_575140 = validateParameter(valid_575140, JString, required = true,
                                 default = nil)
  if valid_575140 != nil:
    section.add "resourceGroupName", valid_575140
  var valid_575141 = path.getOrDefault("subscriptionId")
  valid_575141 = validateParameter(valid_575141, JString, required = true,
                                 default = nil)
  if valid_575141 != nil:
    section.add "subscriptionId", valid_575141
  var valid_575142 = path.getOrDefault("databaseName")
  valid_575142 = validateParameter(valid_575142, JString, required = true,
                                 default = nil)
  if valid_575142 != nil:
    section.add "databaseName", valid_575142
  var valid_575143 = path.getOrDefault("accountName")
  valid_575143 = validateParameter(valid_575143, JString, required = true,
                                 default = nil)
  if valid_575143 != nil:
    section.add "accountName", valid_575143
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575144 = query.getOrDefault("api-version")
  valid_575144 = validateParameter(valid_575144, JString, required = true,
                                 default = nil)
  if valid_575144 != nil:
    section.add "api-version", valid_575144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575145: Call_SqlResourcesListSqlContainers_575137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the SQL container under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_575145.validator(path, query, header, formData, body)
  let scheme = call_575145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575145.url(scheme.get, call_575145.host, call_575145.base,
                         call_575145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575145, url, valid)

proc call*(call_575146: Call_SqlResourcesListSqlContainers_575137;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; accountName: string): Recallable =
  ## sqlResourcesListSqlContainers
  ## Lists the SQL container under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575147 = newJObject()
  var query_575148 = newJObject()
  add(path_575147, "resourceGroupName", newJString(resourceGroupName))
  add(query_575148, "api-version", newJString(apiVersion))
  add(path_575147, "subscriptionId", newJString(subscriptionId))
  add(path_575147, "databaseName", newJString(databaseName))
  add(path_575147, "accountName", newJString(accountName))
  result = call_575146.call(path_575147, query_575148, nil, nil, nil)

var sqlResourcesListSqlContainers* = Call_SqlResourcesListSqlContainers_575137(
    name: "sqlResourcesListSqlContainers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers",
    validator: validate_SqlResourcesListSqlContainers_575138, base: "",
    url: url_SqlResourcesListSqlContainers_575139, schemes: {Scheme.Https})
type
  Call_SqlResourcesCreateUpdateSqlContainer_575162 = ref object of OpenApiRestCall_573668
proc url_SqlResourcesCreateUpdateSqlContainer_575164(protocol: Scheme;
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

proc validate_SqlResourcesCreateUpdateSqlContainer_575163(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an Azure Cosmos DB SQL container
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575165 = path.getOrDefault("resourceGroupName")
  valid_575165 = validateParameter(valid_575165, JString, required = true,
                                 default = nil)
  if valid_575165 != nil:
    section.add "resourceGroupName", valid_575165
  var valid_575166 = path.getOrDefault("containerName")
  valid_575166 = validateParameter(valid_575166, JString, required = true,
                                 default = nil)
  if valid_575166 != nil:
    section.add "containerName", valid_575166
  var valid_575167 = path.getOrDefault("subscriptionId")
  valid_575167 = validateParameter(valid_575167, JString, required = true,
                                 default = nil)
  if valid_575167 != nil:
    section.add "subscriptionId", valid_575167
  var valid_575168 = path.getOrDefault("databaseName")
  valid_575168 = validateParameter(valid_575168, JString, required = true,
                                 default = nil)
  if valid_575168 != nil:
    section.add "databaseName", valid_575168
  var valid_575169 = path.getOrDefault("accountName")
  valid_575169 = validateParameter(valid_575169, JString, required = true,
                                 default = nil)
  if valid_575169 != nil:
    section.add "accountName", valid_575169
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575170 = query.getOrDefault("api-version")
  valid_575170 = validateParameter(valid_575170, JString, required = true,
                                 default = nil)
  if valid_575170 != nil:
    section.add "api-version", valid_575170
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

proc call*(call_575172: Call_SqlResourcesCreateUpdateSqlContainer_575162;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB SQL container
  ## 
  let valid = call_575172.validator(path, query, header, formData, body)
  let scheme = call_575172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575172.url(scheme.get, call_575172.host, call_575172.base,
                         call_575172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575172, url, valid)

proc call*(call_575173: Call_SqlResourcesCreateUpdateSqlContainer_575162;
          createUpdateSqlContainerParameters: JsonNode; resourceGroupName: string;
          apiVersion: string; containerName: string; subscriptionId: string;
          databaseName: string; accountName: string): Recallable =
  ## sqlResourcesCreateUpdateSqlContainer
  ## Create or update an Azure Cosmos DB SQL container
  ##   createUpdateSqlContainerParameters: JObject (required)
  ##                                     : The parameters to provide for the current SQL container.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575174 = newJObject()
  var query_575175 = newJObject()
  var body_575176 = newJObject()
  if createUpdateSqlContainerParameters != nil:
    body_575176 = createUpdateSqlContainerParameters
  add(path_575174, "resourceGroupName", newJString(resourceGroupName))
  add(query_575175, "api-version", newJString(apiVersion))
  add(path_575174, "containerName", newJString(containerName))
  add(path_575174, "subscriptionId", newJString(subscriptionId))
  add(path_575174, "databaseName", newJString(databaseName))
  add(path_575174, "accountName", newJString(accountName))
  result = call_575173.call(path_575174, query_575175, nil, nil, body_575176)

var sqlResourcesCreateUpdateSqlContainer* = Call_SqlResourcesCreateUpdateSqlContainer_575162(
    name: "sqlResourcesCreateUpdateSqlContainer", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}",
    validator: validate_SqlResourcesCreateUpdateSqlContainer_575163, base: "",
    url: url_SqlResourcesCreateUpdateSqlContainer_575164, schemes: {Scheme.Https})
type
  Call_SqlResourcesGetSqlContainer_575149 = ref object of OpenApiRestCall_573668
proc url_SqlResourcesGetSqlContainer_575151(protocol: Scheme; host: string;
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

proc validate_SqlResourcesGetSqlContainer_575150(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the SQL container under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575152 = path.getOrDefault("resourceGroupName")
  valid_575152 = validateParameter(valid_575152, JString, required = true,
                                 default = nil)
  if valid_575152 != nil:
    section.add "resourceGroupName", valid_575152
  var valid_575153 = path.getOrDefault("containerName")
  valid_575153 = validateParameter(valid_575153, JString, required = true,
                                 default = nil)
  if valid_575153 != nil:
    section.add "containerName", valid_575153
  var valid_575154 = path.getOrDefault("subscriptionId")
  valid_575154 = validateParameter(valid_575154, JString, required = true,
                                 default = nil)
  if valid_575154 != nil:
    section.add "subscriptionId", valid_575154
  var valid_575155 = path.getOrDefault("databaseName")
  valid_575155 = validateParameter(valid_575155, JString, required = true,
                                 default = nil)
  if valid_575155 != nil:
    section.add "databaseName", valid_575155
  var valid_575156 = path.getOrDefault("accountName")
  valid_575156 = validateParameter(valid_575156, JString, required = true,
                                 default = nil)
  if valid_575156 != nil:
    section.add "accountName", valid_575156
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575157 = query.getOrDefault("api-version")
  valid_575157 = validateParameter(valid_575157, JString, required = true,
                                 default = nil)
  if valid_575157 != nil:
    section.add "api-version", valid_575157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575158: Call_SqlResourcesGetSqlContainer_575149; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the SQL container under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_575158.validator(path, query, header, formData, body)
  let scheme = call_575158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575158.url(scheme.get, call_575158.host, call_575158.base,
                         call_575158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575158, url, valid)

proc call*(call_575159: Call_SqlResourcesGetSqlContainer_575149;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; databaseName: string; accountName: string): Recallable =
  ## sqlResourcesGetSqlContainer
  ## Gets the SQL container under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575160 = newJObject()
  var query_575161 = newJObject()
  add(path_575160, "resourceGroupName", newJString(resourceGroupName))
  add(query_575161, "api-version", newJString(apiVersion))
  add(path_575160, "containerName", newJString(containerName))
  add(path_575160, "subscriptionId", newJString(subscriptionId))
  add(path_575160, "databaseName", newJString(databaseName))
  add(path_575160, "accountName", newJString(accountName))
  result = call_575159.call(path_575160, query_575161, nil, nil, nil)

var sqlResourcesGetSqlContainer* = Call_SqlResourcesGetSqlContainer_575149(
    name: "sqlResourcesGetSqlContainer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}",
    validator: validate_SqlResourcesGetSqlContainer_575150, base: "",
    url: url_SqlResourcesGetSqlContainer_575151, schemes: {Scheme.Https})
type
  Call_SqlResourcesDeleteSqlContainer_575177 = ref object of OpenApiRestCall_573668
proc url_SqlResourcesDeleteSqlContainer_575179(protocol: Scheme; host: string;
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

proc validate_SqlResourcesDeleteSqlContainer_575178(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Azure Cosmos DB SQL container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575180 = path.getOrDefault("resourceGroupName")
  valid_575180 = validateParameter(valid_575180, JString, required = true,
                                 default = nil)
  if valid_575180 != nil:
    section.add "resourceGroupName", valid_575180
  var valid_575181 = path.getOrDefault("containerName")
  valid_575181 = validateParameter(valid_575181, JString, required = true,
                                 default = nil)
  if valid_575181 != nil:
    section.add "containerName", valid_575181
  var valid_575182 = path.getOrDefault("subscriptionId")
  valid_575182 = validateParameter(valid_575182, JString, required = true,
                                 default = nil)
  if valid_575182 != nil:
    section.add "subscriptionId", valid_575182
  var valid_575183 = path.getOrDefault("databaseName")
  valid_575183 = validateParameter(valid_575183, JString, required = true,
                                 default = nil)
  if valid_575183 != nil:
    section.add "databaseName", valid_575183
  var valid_575184 = path.getOrDefault("accountName")
  valid_575184 = validateParameter(valid_575184, JString, required = true,
                                 default = nil)
  if valid_575184 != nil:
    section.add "accountName", valid_575184
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575185 = query.getOrDefault("api-version")
  valid_575185 = validateParameter(valid_575185, JString, required = true,
                                 default = nil)
  if valid_575185 != nil:
    section.add "api-version", valid_575185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575186: Call_SqlResourcesDeleteSqlContainer_575177; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB SQL container.
  ## 
  let valid = call_575186.validator(path, query, header, formData, body)
  let scheme = call_575186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575186.url(scheme.get, call_575186.host, call_575186.base,
                         call_575186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575186, url, valid)

proc call*(call_575187: Call_SqlResourcesDeleteSqlContainer_575177;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; databaseName: string; accountName: string): Recallable =
  ## sqlResourcesDeleteSqlContainer
  ## Deletes an existing Azure Cosmos DB SQL container.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575188 = newJObject()
  var query_575189 = newJObject()
  add(path_575188, "resourceGroupName", newJString(resourceGroupName))
  add(query_575189, "api-version", newJString(apiVersion))
  add(path_575188, "containerName", newJString(containerName))
  add(path_575188, "subscriptionId", newJString(subscriptionId))
  add(path_575188, "databaseName", newJString(databaseName))
  add(path_575188, "accountName", newJString(accountName))
  result = call_575187.call(path_575188, query_575189, nil, nil, nil)

var sqlResourcesDeleteSqlContainer* = Call_SqlResourcesDeleteSqlContainer_575177(
    name: "sqlResourcesDeleteSqlContainer", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}",
    validator: validate_SqlResourcesDeleteSqlContainer_575178, base: "",
    url: url_SqlResourcesDeleteSqlContainer_575179, schemes: {Scheme.Https})
type
  Call_SqlResourcesListSqlStoredProcedures_575190 = ref object of OpenApiRestCall_573668
proc url_SqlResourcesListSqlStoredProcedures_575192(protocol: Scheme; host: string;
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

proc validate_SqlResourcesListSqlStoredProcedures_575191(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the SQL storedProcedure under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575193 = path.getOrDefault("resourceGroupName")
  valid_575193 = validateParameter(valid_575193, JString, required = true,
                                 default = nil)
  if valid_575193 != nil:
    section.add "resourceGroupName", valid_575193
  var valid_575194 = path.getOrDefault("containerName")
  valid_575194 = validateParameter(valid_575194, JString, required = true,
                                 default = nil)
  if valid_575194 != nil:
    section.add "containerName", valid_575194
  var valid_575195 = path.getOrDefault("subscriptionId")
  valid_575195 = validateParameter(valid_575195, JString, required = true,
                                 default = nil)
  if valid_575195 != nil:
    section.add "subscriptionId", valid_575195
  var valid_575196 = path.getOrDefault("databaseName")
  valid_575196 = validateParameter(valid_575196, JString, required = true,
                                 default = nil)
  if valid_575196 != nil:
    section.add "databaseName", valid_575196
  var valid_575197 = path.getOrDefault("accountName")
  valid_575197 = validateParameter(valid_575197, JString, required = true,
                                 default = nil)
  if valid_575197 != nil:
    section.add "accountName", valid_575197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575198 = query.getOrDefault("api-version")
  valid_575198 = validateParameter(valid_575198, JString, required = true,
                                 default = nil)
  if valid_575198 != nil:
    section.add "api-version", valid_575198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575199: Call_SqlResourcesListSqlStoredProcedures_575190;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the SQL storedProcedure under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_575199.validator(path, query, header, formData, body)
  let scheme = call_575199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575199.url(scheme.get, call_575199.host, call_575199.base,
                         call_575199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575199, url, valid)

proc call*(call_575200: Call_SqlResourcesListSqlStoredProcedures_575190;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; databaseName: string; accountName: string): Recallable =
  ## sqlResourcesListSqlStoredProcedures
  ## Lists the SQL storedProcedure under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575201 = newJObject()
  var query_575202 = newJObject()
  add(path_575201, "resourceGroupName", newJString(resourceGroupName))
  add(query_575202, "api-version", newJString(apiVersion))
  add(path_575201, "containerName", newJString(containerName))
  add(path_575201, "subscriptionId", newJString(subscriptionId))
  add(path_575201, "databaseName", newJString(databaseName))
  add(path_575201, "accountName", newJString(accountName))
  result = call_575200.call(path_575201, query_575202, nil, nil, nil)

var sqlResourcesListSqlStoredProcedures* = Call_SqlResourcesListSqlStoredProcedures_575190(
    name: "sqlResourcesListSqlStoredProcedures", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}/storedProcedures/",
    validator: validate_SqlResourcesListSqlStoredProcedures_575191, base: "",
    url: url_SqlResourcesListSqlStoredProcedures_575192, schemes: {Scheme.Https})
type
  Call_SqlResourcesCreateUpdateSqlStoredProcedure_575217 = ref object of OpenApiRestCall_573668
proc url_SqlResourcesCreateUpdateSqlStoredProcedure_575219(protocol: Scheme;
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

proc validate_SqlResourcesCreateUpdateSqlStoredProcedure_575218(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an Azure Cosmos DB SQL storedProcedure
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   storedProcedureName: JString (required)
  ##                      : Cosmos DB storedProcedure name.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575220 = path.getOrDefault("resourceGroupName")
  valid_575220 = validateParameter(valid_575220, JString, required = true,
                                 default = nil)
  if valid_575220 != nil:
    section.add "resourceGroupName", valid_575220
  var valid_575221 = path.getOrDefault("containerName")
  valid_575221 = validateParameter(valid_575221, JString, required = true,
                                 default = nil)
  if valid_575221 != nil:
    section.add "containerName", valid_575221
  var valid_575222 = path.getOrDefault("subscriptionId")
  valid_575222 = validateParameter(valid_575222, JString, required = true,
                                 default = nil)
  if valid_575222 != nil:
    section.add "subscriptionId", valid_575222
  var valid_575223 = path.getOrDefault("storedProcedureName")
  valid_575223 = validateParameter(valid_575223, JString, required = true,
                                 default = nil)
  if valid_575223 != nil:
    section.add "storedProcedureName", valid_575223
  var valid_575224 = path.getOrDefault("databaseName")
  valid_575224 = validateParameter(valid_575224, JString, required = true,
                                 default = nil)
  if valid_575224 != nil:
    section.add "databaseName", valid_575224
  var valid_575225 = path.getOrDefault("accountName")
  valid_575225 = validateParameter(valid_575225, JString, required = true,
                                 default = nil)
  if valid_575225 != nil:
    section.add "accountName", valid_575225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575226 = query.getOrDefault("api-version")
  valid_575226 = validateParameter(valid_575226, JString, required = true,
                                 default = nil)
  if valid_575226 != nil:
    section.add "api-version", valid_575226
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

proc call*(call_575228: Call_SqlResourcesCreateUpdateSqlStoredProcedure_575217;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB SQL storedProcedure
  ## 
  let valid = call_575228.validator(path, query, header, formData, body)
  let scheme = call_575228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575228.url(scheme.get, call_575228.host, call_575228.base,
                         call_575228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575228, url, valid)

proc call*(call_575229: Call_SqlResourcesCreateUpdateSqlStoredProcedure_575217;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; storedProcedureName: string;
          createUpdateSqlStoredProcedureParameters: JsonNode;
          databaseName: string; accountName: string): Recallable =
  ## sqlResourcesCreateUpdateSqlStoredProcedure
  ## Create or update an Azure Cosmos DB SQL storedProcedure
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   storedProcedureName: string (required)
  ##                      : Cosmos DB storedProcedure name.
  ##   createUpdateSqlStoredProcedureParameters: JObject (required)
  ##                                           : The parameters to provide for the current SQL storedProcedure.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575230 = newJObject()
  var query_575231 = newJObject()
  var body_575232 = newJObject()
  add(path_575230, "resourceGroupName", newJString(resourceGroupName))
  add(query_575231, "api-version", newJString(apiVersion))
  add(path_575230, "containerName", newJString(containerName))
  add(path_575230, "subscriptionId", newJString(subscriptionId))
  add(path_575230, "storedProcedureName", newJString(storedProcedureName))
  if createUpdateSqlStoredProcedureParameters != nil:
    body_575232 = createUpdateSqlStoredProcedureParameters
  add(path_575230, "databaseName", newJString(databaseName))
  add(path_575230, "accountName", newJString(accountName))
  result = call_575229.call(path_575230, query_575231, nil, nil, body_575232)

var sqlResourcesCreateUpdateSqlStoredProcedure* = Call_SqlResourcesCreateUpdateSqlStoredProcedure_575217(
    name: "sqlResourcesCreateUpdateSqlStoredProcedure", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}/storedProcedures/{storedProcedureName}",
    validator: validate_SqlResourcesCreateUpdateSqlStoredProcedure_575218,
    base: "", url: url_SqlResourcesCreateUpdateSqlStoredProcedure_575219,
    schemes: {Scheme.Https})
type
  Call_SqlResourcesGetSqlStoredProcedure_575203 = ref object of OpenApiRestCall_573668
proc url_SqlResourcesGetSqlStoredProcedure_575205(protocol: Scheme; host: string;
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

proc validate_SqlResourcesGetSqlStoredProcedure_575204(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the SQL storedProcedure under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   storedProcedureName: JString (required)
  ##                      : Cosmos DB storedProcedure name.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575206 = path.getOrDefault("resourceGroupName")
  valid_575206 = validateParameter(valid_575206, JString, required = true,
                                 default = nil)
  if valid_575206 != nil:
    section.add "resourceGroupName", valid_575206
  var valid_575207 = path.getOrDefault("containerName")
  valid_575207 = validateParameter(valid_575207, JString, required = true,
                                 default = nil)
  if valid_575207 != nil:
    section.add "containerName", valid_575207
  var valid_575208 = path.getOrDefault("subscriptionId")
  valid_575208 = validateParameter(valid_575208, JString, required = true,
                                 default = nil)
  if valid_575208 != nil:
    section.add "subscriptionId", valid_575208
  var valid_575209 = path.getOrDefault("storedProcedureName")
  valid_575209 = validateParameter(valid_575209, JString, required = true,
                                 default = nil)
  if valid_575209 != nil:
    section.add "storedProcedureName", valid_575209
  var valid_575210 = path.getOrDefault("databaseName")
  valid_575210 = validateParameter(valid_575210, JString, required = true,
                                 default = nil)
  if valid_575210 != nil:
    section.add "databaseName", valid_575210
  var valid_575211 = path.getOrDefault("accountName")
  valid_575211 = validateParameter(valid_575211, JString, required = true,
                                 default = nil)
  if valid_575211 != nil:
    section.add "accountName", valid_575211
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575212 = query.getOrDefault("api-version")
  valid_575212 = validateParameter(valid_575212, JString, required = true,
                                 default = nil)
  if valid_575212 != nil:
    section.add "api-version", valid_575212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575213: Call_SqlResourcesGetSqlStoredProcedure_575203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the SQL storedProcedure under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_575213.validator(path, query, header, formData, body)
  let scheme = call_575213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575213.url(scheme.get, call_575213.host, call_575213.base,
                         call_575213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575213, url, valid)

proc call*(call_575214: Call_SqlResourcesGetSqlStoredProcedure_575203;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; storedProcedureName: string; databaseName: string;
          accountName: string): Recallable =
  ## sqlResourcesGetSqlStoredProcedure
  ## Gets the SQL storedProcedure under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   storedProcedureName: string (required)
  ##                      : Cosmos DB storedProcedure name.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575215 = newJObject()
  var query_575216 = newJObject()
  add(path_575215, "resourceGroupName", newJString(resourceGroupName))
  add(query_575216, "api-version", newJString(apiVersion))
  add(path_575215, "containerName", newJString(containerName))
  add(path_575215, "subscriptionId", newJString(subscriptionId))
  add(path_575215, "storedProcedureName", newJString(storedProcedureName))
  add(path_575215, "databaseName", newJString(databaseName))
  add(path_575215, "accountName", newJString(accountName))
  result = call_575214.call(path_575215, query_575216, nil, nil, nil)

var sqlResourcesGetSqlStoredProcedure* = Call_SqlResourcesGetSqlStoredProcedure_575203(
    name: "sqlResourcesGetSqlStoredProcedure", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}/storedProcedures/{storedProcedureName}",
    validator: validate_SqlResourcesGetSqlStoredProcedure_575204, base: "",
    url: url_SqlResourcesGetSqlStoredProcedure_575205, schemes: {Scheme.Https})
type
  Call_SqlResourcesDeleteSqlStoredProcedure_575233 = ref object of OpenApiRestCall_573668
proc url_SqlResourcesDeleteSqlStoredProcedure_575235(protocol: Scheme;
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

proc validate_SqlResourcesDeleteSqlStoredProcedure_575234(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Azure Cosmos DB SQL storedProcedure.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   storedProcedureName: JString (required)
  ##                      : Cosmos DB storedProcedure name.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575236 = path.getOrDefault("resourceGroupName")
  valid_575236 = validateParameter(valid_575236, JString, required = true,
                                 default = nil)
  if valid_575236 != nil:
    section.add "resourceGroupName", valid_575236
  var valid_575237 = path.getOrDefault("containerName")
  valid_575237 = validateParameter(valid_575237, JString, required = true,
                                 default = nil)
  if valid_575237 != nil:
    section.add "containerName", valid_575237
  var valid_575238 = path.getOrDefault("subscriptionId")
  valid_575238 = validateParameter(valid_575238, JString, required = true,
                                 default = nil)
  if valid_575238 != nil:
    section.add "subscriptionId", valid_575238
  var valid_575239 = path.getOrDefault("storedProcedureName")
  valid_575239 = validateParameter(valid_575239, JString, required = true,
                                 default = nil)
  if valid_575239 != nil:
    section.add "storedProcedureName", valid_575239
  var valid_575240 = path.getOrDefault("databaseName")
  valid_575240 = validateParameter(valid_575240, JString, required = true,
                                 default = nil)
  if valid_575240 != nil:
    section.add "databaseName", valid_575240
  var valid_575241 = path.getOrDefault("accountName")
  valid_575241 = validateParameter(valid_575241, JString, required = true,
                                 default = nil)
  if valid_575241 != nil:
    section.add "accountName", valid_575241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575242 = query.getOrDefault("api-version")
  valid_575242 = validateParameter(valid_575242, JString, required = true,
                                 default = nil)
  if valid_575242 != nil:
    section.add "api-version", valid_575242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575243: Call_SqlResourcesDeleteSqlStoredProcedure_575233;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB SQL storedProcedure.
  ## 
  let valid = call_575243.validator(path, query, header, formData, body)
  let scheme = call_575243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575243.url(scheme.get, call_575243.host, call_575243.base,
                         call_575243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575243, url, valid)

proc call*(call_575244: Call_SqlResourcesDeleteSqlStoredProcedure_575233;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; storedProcedureName: string; databaseName: string;
          accountName: string): Recallable =
  ## sqlResourcesDeleteSqlStoredProcedure
  ## Deletes an existing Azure Cosmos DB SQL storedProcedure.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   storedProcedureName: string (required)
  ##                      : Cosmos DB storedProcedure name.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575245 = newJObject()
  var query_575246 = newJObject()
  add(path_575245, "resourceGroupName", newJString(resourceGroupName))
  add(query_575246, "api-version", newJString(apiVersion))
  add(path_575245, "containerName", newJString(containerName))
  add(path_575245, "subscriptionId", newJString(subscriptionId))
  add(path_575245, "storedProcedureName", newJString(storedProcedureName))
  add(path_575245, "databaseName", newJString(databaseName))
  add(path_575245, "accountName", newJString(accountName))
  result = call_575244.call(path_575245, query_575246, nil, nil, nil)

var sqlResourcesDeleteSqlStoredProcedure* = Call_SqlResourcesDeleteSqlStoredProcedure_575233(
    name: "sqlResourcesDeleteSqlStoredProcedure", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}/storedProcedures/{storedProcedureName}",
    validator: validate_SqlResourcesDeleteSqlStoredProcedure_575234, base: "",
    url: url_SqlResourcesDeleteSqlStoredProcedure_575235, schemes: {Scheme.Https})
type
  Call_SqlResourcesUpdateSqlContainerThroughput_575260 = ref object of OpenApiRestCall_573668
proc url_SqlResourcesUpdateSqlContainerThroughput_575262(protocol: Scheme;
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

proc validate_SqlResourcesUpdateSqlContainerThroughput_575261(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update RUs per second of an Azure Cosmos DB SQL container
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575263 = path.getOrDefault("resourceGroupName")
  valid_575263 = validateParameter(valid_575263, JString, required = true,
                                 default = nil)
  if valid_575263 != nil:
    section.add "resourceGroupName", valid_575263
  var valid_575264 = path.getOrDefault("containerName")
  valid_575264 = validateParameter(valid_575264, JString, required = true,
                                 default = nil)
  if valid_575264 != nil:
    section.add "containerName", valid_575264
  var valid_575265 = path.getOrDefault("subscriptionId")
  valid_575265 = validateParameter(valid_575265, JString, required = true,
                                 default = nil)
  if valid_575265 != nil:
    section.add "subscriptionId", valid_575265
  var valid_575266 = path.getOrDefault("databaseName")
  valid_575266 = validateParameter(valid_575266, JString, required = true,
                                 default = nil)
  if valid_575266 != nil:
    section.add "databaseName", valid_575266
  var valid_575267 = path.getOrDefault("accountName")
  valid_575267 = validateParameter(valid_575267, JString, required = true,
                                 default = nil)
  if valid_575267 != nil:
    section.add "accountName", valid_575267
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575268 = query.getOrDefault("api-version")
  valid_575268 = validateParameter(valid_575268, JString, required = true,
                                 default = nil)
  if valid_575268 != nil:
    section.add "api-version", valid_575268
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

proc call*(call_575270: Call_SqlResourcesUpdateSqlContainerThroughput_575260;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB SQL container
  ## 
  let valid = call_575270.validator(path, query, header, formData, body)
  let scheme = call_575270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575270.url(scheme.get, call_575270.host, call_575270.base,
                         call_575270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575270, url, valid)

proc call*(call_575271: Call_SqlResourcesUpdateSqlContainerThroughput_575260;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; databaseName: string;
          updateThroughputParameters: JsonNode; accountName: string): Recallable =
  ## sqlResourcesUpdateSqlContainerThroughput
  ## Update RUs per second of an Azure Cosmos DB SQL container
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   updateThroughputParameters: JObject (required)
  ##                             : The parameters to provide for the RUs per second of the current SQL container.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575272 = newJObject()
  var query_575273 = newJObject()
  var body_575274 = newJObject()
  add(path_575272, "resourceGroupName", newJString(resourceGroupName))
  add(query_575273, "api-version", newJString(apiVersion))
  add(path_575272, "containerName", newJString(containerName))
  add(path_575272, "subscriptionId", newJString(subscriptionId))
  add(path_575272, "databaseName", newJString(databaseName))
  if updateThroughputParameters != nil:
    body_575274 = updateThroughputParameters
  add(path_575272, "accountName", newJString(accountName))
  result = call_575271.call(path_575272, query_575273, nil, nil, body_575274)

var sqlResourcesUpdateSqlContainerThroughput* = Call_SqlResourcesUpdateSqlContainerThroughput_575260(
    name: "sqlResourcesUpdateSqlContainerThroughput", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}/throughputSettings/default",
    validator: validate_SqlResourcesUpdateSqlContainerThroughput_575261, base: "",
    url: url_SqlResourcesUpdateSqlContainerThroughput_575262,
    schemes: {Scheme.Https})
type
  Call_SqlResourcesGetSqlContainerThroughput_575247 = ref object of OpenApiRestCall_573668
proc url_SqlResourcesGetSqlContainerThroughput_575249(protocol: Scheme;
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

proc validate_SqlResourcesGetSqlContainerThroughput_575248(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the RUs per second of the SQL container under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575250 = path.getOrDefault("resourceGroupName")
  valid_575250 = validateParameter(valid_575250, JString, required = true,
                                 default = nil)
  if valid_575250 != nil:
    section.add "resourceGroupName", valid_575250
  var valid_575251 = path.getOrDefault("containerName")
  valid_575251 = validateParameter(valid_575251, JString, required = true,
                                 default = nil)
  if valid_575251 != nil:
    section.add "containerName", valid_575251
  var valid_575252 = path.getOrDefault("subscriptionId")
  valid_575252 = validateParameter(valid_575252, JString, required = true,
                                 default = nil)
  if valid_575252 != nil:
    section.add "subscriptionId", valid_575252
  var valid_575253 = path.getOrDefault("databaseName")
  valid_575253 = validateParameter(valid_575253, JString, required = true,
                                 default = nil)
  if valid_575253 != nil:
    section.add "databaseName", valid_575253
  var valid_575254 = path.getOrDefault("accountName")
  valid_575254 = validateParameter(valid_575254, JString, required = true,
                                 default = nil)
  if valid_575254 != nil:
    section.add "accountName", valid_575254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575255 = query.getOrDefault("api-version")
  valid_575255 = validateParameter(valid_575255, JString, required = true,
                                 default = nil)
  if valid_575255 != nil:
    section.add "api-version", valid_575255
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575256: Call_SqlResourcesGetSqlContainerThroughput_575247;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the SQL container under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_575256.validator(path, query, header, formData, body)
  let scheme = call_575256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575256.url(scheme.get, call_575256.host, call_575256.base,
                         call_575256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575256, url, valid)

proc call*(call_575257: Call_SqlResourcesGetSqlContainerThroughput_575247;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; databaseName: string; accountName: string): Recallable =
  ## sqlResourcesGetSqlContainerThroughput
  ## Gets the RUs per second of the SQL container under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575258 = newJObject()
  var query_575259 = newJObject()
  add(path_575258, "resourceGroupName", newJString(resourceGroupName))
  add(query_575259, "api-version", newJString(apiVersion))
  add(path_575258, "containerName", newJString(containerName))
  add(path_575258, "subscriptionId", newJString(subscriptionId))
  add(path_575258, "databaseName", newJString(databaseName))
  add(path_575258, "accountName", newJString(accountName))
  result = call_575257.call(path_575258, query_575259, nil, nil, nil)

var sqlResourcesGetSqlContainerThroughput* = Call_SqlResourcesGetSqlContainerThroughput_575247(
    name: "sqlResourcesGetSqlContainerThroughput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}/throughputSettings/default",
    validator: validate_SqlResourcesGetSqlContainerThroughput_575248, base: "",
    url: url_SqlResourcesGetSqlContainerThroughput_575249, schemes: {Scheme.Https})
type
  Call_SqlResourcesListSqlTriggers_575275 = ref object of OpenApiRestCall_573668
proc url_SqlResourcesListSqlTriggers_575277(protocol: Scheme; host: string;
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

proc validate_SqlResourcesListSqlTriggers_575276(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the SQL trigger under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575278 = path.getOrDefault("resourceGroupName")
  valid_575278 = validateParameter(valid_575278, JString, required = true,
                                 default = nil)
  if valid_575278 != nil:
    section.add "resourceGroupName", valid_575278
  var valid_575279 = path.getOrDefault("containerName")
  valid_575279 = validateParameter(valid_575279, JString, required = true,
                                 default = nil)
  if valid_575279 != nil:
    section.add "containerName", valid_575279
  var valid_575280 = path.getOrDefault("subscriptionId")
  valid_575280 = validateParameter(valid_575280, JString, required = true,
                                 default = nil)
  if valid_575280 != nil:
    section.add "subscriptionId", valid_575280
  var valid_575281 = path.getOrDefault("databaseName")
  valid_575281 = validateParameter(valid_575281, JString, required = true,
                                 default = nil)
  if valid_575281 != nil:
    section.add "databaseName", valid_575281
  var valid_575282 = path.getOrDefault("accountName")
  valid_575282 = validateParameter(valid_575282, JString, required = true,
                                 default = nil)
  if valid_575282 != nil:
    section.add "accountName", valid_575282
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575283 = query.getOrDefault("api-version")
  valid_575283 = validateParameter(valid_575283, JString, required = true,
                                 default = nil)
  if valid_575283 != nil:
    section.add "api-version", valid_575283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575284: Call_SqlResourcesListSqlTriggers_575275; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the SQL trigger under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_575284.validator(path, query, header, formData, body)
  let scheme = call_575284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575284.url(scheme.get, call_575284.host, call_575284.base,
                         call_575284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575284, url, valid)

proc call*(call_575285: Call_SqlResourcesListSqlTriggers_575275;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; databaseName: string; accountName: string): Recallable =
  ## sqlResourcesListSqlTriggers
  ## Lists the SQL trigger under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575286 = newJObject()
  var query_575287 = newJObject()
  add(path_575286, "resourceGroupName", newJString(resourceGroupName))
  add(query_575287, "api-version", newJString(apiVersion))
  add(path_575286, "containerName", newJString(containerName))
  add(path_575286, "subscriptionId", newJString(subscriptionId))
  add(path_575286, "databaseName", newJString(databaseName))
  add(path_575286, "accountName", newJString(accountName))
  result = call_575285.call(path_575286, query_575287, nil, nil, nil)

var sqlResourcesListSqlTriggers* = Call_SqlResourcesListSqlTriggers_575275(
    name: "sqlResourcesListSqlTriggers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}/triggers/",
    validator: validate_SqlResourcesListSqlTriggers_575276, base: "",
    url: url_SqlResourcesListSqlTriggers_575277, schemes: {Scheme.Https})
type
  Call_SqlResourcesCreateUpdateSqlTrigger_575302 = ref object of OpenApiRestCall_573668
proc url_SqlResourcesCreateUpdateSqlTrigger_575304(protocol: Scheme; host: string;
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

proc validate_SqlResourcesCreateUpdateSqlTrigger_575303(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an Azure Cosmos DB SQL trigger
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   triggerName: JString (required)
  ##              : Cosmos DB trigger name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575305 = path.getOrDefault("resourceGroupName")
  valid_575305 = validateParameter(valid_575305, JString, required = true,
                                 default = nil)
  if valid_575305 != nil:
    section.add "resourceGroupName", valid_575305
  var valid_575306 = path.getOrDefault("containerName")
  valid_575306 = validateParameter(valid_575306, JString, required = true,
                                 default = nil)
  if valid_575306 != nil:
    section.add "containerName", valid_575306
  var valid_575307 = path.getOrDefault("subscriptionId")
  valid_575307 = validateParameter(valid_575307, JString, required = true,
                                 default = nil)
  if valid_575307 != nil:
    section.add "subscriptionId", valid_575307
  var valid_575308 = path.getOrDefault("databaseName")
  valid_575308 = validateParameter(valid_575308, JString, required = true,
                                 default = nil)
  if valid_575308 != nil:
    section.add "databaseName", valid_575308
  var valid_575309 = path.getOrDefault("triggerName")
  valid_575309 = validateParameter(valid_575309, JString, required = true,
                                 default = nil)
  if valid_575309 != nil:
    section.add "triggerName", valid_575309
  var valid_575310 = path.getOrDefault("accountName")
  valid_575310 = validateParameter(valid_575310, JString, required = true,
                                 default = nil)
  if valid_575310 != nil:
    section.add "accountName", valid_575310
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575311 = query.getOrDefault("api-version")
  valid_575311 = validateParameter(valid_575311, JString, required = true,
                                 default = nil)
  if valid_575311 != nil:
    section.add "api-version", valid_575311
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

proc call*(call_575313: Call_SqlResourcesCreateUpdateSqlTrigger_575302;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB SQL trigger
  ## 
  let valid = call_575313.validator(path, query, header, formData, body)
  let scheme = call_575313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575313.url(scheme.get, call_575313.host, call_575313.base,
                         call_575313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575313, url, valid)

proc call*(call_575314: Call_SqlResourcesCreateUpdateSqlTrigger_575302;
          resourceGroupName: string; apiVersion: string;
          createUpdateSqlTriggerParameters: JsonNode; containerName: string;
          subscriptionId: string; databaseName: string; triggerName: string;
          accountName: string): Recallable =
  ## sqlResourcesCreateUpdateSqlTrigger
  ## Create or update an Azure Cosmos DB SQL trigger
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   createUpdateSqlTriggerParameters: JObject (required)
  ##                                   : The parameters to provide for the current SQL trigger.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   triggerName: string (required)
  ##              : Cosmos DB trigger name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575315 = newJObject()
  var query_575316 = newJObject()
  var body_575317 = newJObject()
  add(path_575315, "resourceGroupName", newJString(resourceGroupName))
  add(query_575316, "api-version", newJString(apiVersion))
  if createUpdateSqlTriggerParameters != nil:
    body_575317 = createUpdateSqlTriggerParameters
  add(path_575315, "containerName", newJString(containerName))
  add(path_575315, "subscriptionId", newJString(subscriptionId))
  add(path_575315, "databaseName", newJString(databaseName))
  add(path_575315, "triggerName", newJString(triggerName))
  add(path_575315, "accountName", newJString(accountName))
  result = call_575314.call(path_575315, query_575316, nil, nil, body_575317)

var sqlResourcesCreateUpdateSqlTrigger* = Call_SqlResourcesCreateUpdateSqlTrigger_575302(
    name: "sqlResourcesCreateUpdateSqlTrigger", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}/triggers/{triggerName}",
    validator: validate_SqlResourcesCreateUpdateSqlTrigger_575303, base: "",
    url: url_SqlResourcesCreateUpdateSqlTrigger_575304, schemes: {Scheme.Https})
type
  Call_SqlResourcesGetSqlTrigger_575288 = ref object of OpenApiRestCall_573668
proc url_SqlResourcesGetSqlTrigger_575290(protocol: Scheme; host: string;
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

proc validate_SqlResourcesGetSqlTrigger_575289(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the SQL trigger under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   triggerName: JString (required)
  ##              : Cosmos DB trigger name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575291 = path.getOrDefault("resourceGroupName")
  valid_575291 = validateParameter(valid_575291, JString, required = true,
                                 default = nil)
  if valid_575291 != nil:
    section.add "resourceGroupName", valid_575291
  var valid_575292 = path.getOrDefault("containerName")
  valid_575292 = validateParameter(valid_575292, JString, required = true,
                                 default = nil)
  if valid_575292 != nil:
    section.add "containerName", valid_575292
  var valid_575293 = path.getOrDefault("subscriptionId")
  valid_575293 = validateParameter(valid_575293, JString, required = true,
                                 default = nil)
  if valid_575293 != nil:
    section.add "subscriptionId", valid_575293
  var valid_575294 = path.getOrDefault("databaseName")
  valid_575294 = validateParameter(valid_575294, JString, required = true,
                                 default = nil)
  if valid_575294 != nil:
    section.add "databaseName", valid_575294
  var valid_575295 = path.getOrDefault("triggerName")
  valid_575295 = validateParameter(valid_575295, JString, required = true,
                                 default = nil)
  if valid_575295 != nil:
    section.add "triggerName", valid_575295
  var valid_575296 = path.getOrDefault("accountName")
  valid_575296 = validateParameter(valid_575296, JString, required = true,
                                 default = nil)
  if valid_575296 != nil:
    section.add "accountName", valid_575296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575297 = query.getOrDefault("api-version")
  valid_575297 = validateParameter(valid_575297, JString, required = true,
                                 default = nil)
  if valid_575297 != nil:
    section.add "api-version", valid_575297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575298: Call_SqlResourcesGetSqlTrigger_575288; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the SQL trigger under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_575298.validator(path, query, header, formData, body)
  let scheme = call_575298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575298.url(scheme.get, call_575298.host, call_575298.base,
                         call_575298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575298, url, valid)

proc call*(call_575299: Call_SqlResourcesGetSqlTrigger_575288;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; databaseName: string; triggerName: string;
          accountName: string): Recallable =
  ## sqlResourcesGetSqlTrigger
  ## Gets the SQL trigger under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   triggerName: string (required)
  ##              : Cosmos DB trigger name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575300 = newJObject()
  var query_575301 = newJObject()
  add(path_575300, "resourceGroupName", newJString(resourceGroupName))
  add(query_575301, "api-version", newJString(apiVersion))
  add(path_575300, "containerName", newJString(containerName))
  add(path_575300, "subscriptionId", newJString(subscriptionId))
  add(path_575300, "databaseName", newJString(databaseName))
  add(path_575300, "triggerName", newJString(triggerName))
  add(path_575300, "accountName", newJString(accountName))
  result = call_575299.call(path_575300, query_575301, nil, nil, nil)

var sqlResourcesGetSqlTrigger* = Call_SqlResourcesGetSqlTrigger_575288(
    name: "sqlResourcesGetSqlTrigger", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}/triggers/{triggerName}",
    validator: validate_SqlResourcesGetSqlTrigger_575289, base: "",
    url: url_SqlResourcesGetSqlTrigger_575290, schemes: {Scheme.Https})
type
  Call_SqlResourcesDeleteSqlTrigger_575318 = ref object of OpenApiRestCall_573668
proc url_SqlResourcesDeleteSqlTrigger_575320(protocol: Scheme; host: string;
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

proc validate_SqlResourcesDeleteSqlTrigger_575319(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Azure Cosmos DB SQL trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   triggerName: JString (required)
  ##              : Cosmos DB trigger name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575321 = path.getOrDefault("resourceGroupName")
  valid_575321 = validateParameter(valid_575321, JString, required = true,
                                 default = nil)
  if valid_575321 != nil:
    section.add "resourceGroupName", valid_575321
  var valid_575322 = path.getOrDefault("containerName")
  valid_575322 = validateParameter(valid_575322, JString, required = true,
                                 default = nil)
  if valid_575322 != nil:
    section.add "containerName", valid_575322
  var valid_575323 = path.getOrDefault("subscriptionId")
  valid_575323 = validateParameter(valid_575323, JString, required = true,
                                 default = nil)
  if valid_575323 != nil:
    section.add "subscriptionId", valid_575323
  var valid_575324 = path.getOrDefault("databaseName")
  valid_575324 = validateParameter(valid_575324, JString, required = true,
                                 default = nil)
  if valid_575324 != nil:
    section.add "databaseName", valid_575324
  var valid_575325 = path.getOrDefault("triggerName")
  valid_575325 = validateParameter(valid_575325, JString, required = true,
                                 default = nil)
  if valid_575325 != nil:
    section.add "triggerName", valid_575325
  var valid_575326 = path.getOrDefault("accountName")
  valid_575326 = validateParameter(valid_575326, JString, required = true,
                                 default = nil)
  if valid_575326 != nil:
    section.add "accountName", valid_575326
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575327 = query.getOrDefault("api-version")
  valid_575327 = validateParameter(valid_575327, JString, required = true,
                                 default = nil)
  if valid_575327 != nil:
    section.add "api-version", valid_575327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575328: Call_SqlResourcesDeleteSqlTrigger_575318; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB SQL trigger.
  ## 
  let valid = call_575328.validator(path, query, header, formData, body)
  let scheme = call_575328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575328.url(scheme.get, call_575328.host, call_575328.base,
                         call_575328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575328, url, valid)

proc call*(call_575329: Call_SqlResourcesDeleteSqlTrigger_575318;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; databaseName: string; triggerName: string;
          accountName: string): Recallable =
  ## sqlResourcesDeleteSqlTrigger
  ## Deletes an existing Azure Cosmos DB SQL trigger.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   triggerName: string (required)
  ##              : Cosmos DB trigger name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575330 = newJObject()
  var query_575331 = newJObject()
  add(path_575330, "resourceGroupName", newJString(resourceGroupName))
  add(query_575331, "api-version", newJString(apiVersion))
  add(path_575330, "containerName", newJString(containerName))
  add(path_575330, "subscriptionId", newJString(subscriptionId))
  add(path_575330, "databaseName", newJString(databaseName))
  add(path_575330, "triggerName", newJString(triggerName))
  add(path_575330, "accountName", newJString(accountName))
  result = call_575329.call(path_575330, query_575331, nil, nil, nil)

var sqlResourcesDeleteSqlTrigger* = Call_SqlResourcesDeleteSqlTrigger_575318(
    name: "sqlResourcesDeleteSqlTrigger", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}/triggers/{triggerName}",
    validator: validate_SqlResourcesDeleteSqlTrigger_575319, base: "",
    url: url_SqlResourcesDeleteSqlTrigger_575320, schemes: {Scheme.Https})
type
  Call_SqlResourcesListSqlUserDefinedFunctions_575332 = ref object of OpenApiRestCall_573668
proc url_SqlResourcesListSqlUserDefinedFunctions_575334(protocol: Scheme;
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

proc validate_SqlResourcesListSqlUserDefinedFunctions_575333(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the SQL userDefinedFunction under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575335 = path.getOrDefault("resourceGroupName")
  valid_575335 = validateParameter(valid_575335, JString, required = true,
                                 default = nil)
  if valid_575335 != nil:
    section.add "resourceGroupName", valid_575335
  var valid_575336 = path.getOrDefault("containerName")
  valid_575336 = validateParameter(valid_575336, JString, required = true,
                                 default = nil)
  if valid_575336 != nil:
    section.add "containerName", valid_575336
  var valid_575337 = path.getOrDefault("subscriptionId")
  valid_575337 = validateParameter(valid_575337, JString, required = true,
                                 default = nil)
  if valid_575337 != nil:
    section.add "subscriptionId", valid_575337
  var valid_575338 = path.getOrDefault("databaseName")
  valid_575338 = validateParameter(valid_575338, JString, required = true,
                                 default = nil)
  if valid_575338 != nil:
    section.add "databaseName", valid_575338
  var valid_575339 = path.getOrDefault("accountName")
  valid_575339 = validateParameter(valid_575339, JString, required = true,
                                 default = nil)
  if valid_575339 != nil:
    section.add "accountName", valid_575339
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575340 = query.getOrDefault("api-version")
  valid_575340 = validateParameter(valid_575340, JString, required = true,
                                 default = nil)
  if valid_575340 != nil:
    section.add "api-version", valid_575340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575341: Call_SqlResourcesListSqlUserDefinedFunctions_575332;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the SQL userDefinedFunction under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_575341.validator(path, query, header, formData, body)
  let scheme = call_575341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575341.url(scheme.get, call_575341.host, call_575341.base,
                         call_575341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575341, url, valid)

proc call*(call_575342: Call_SqlResourcesListSqlUserDefinedFunctions_575332;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; databaseName: string; accountName: string): Recallable =
  ## sqlResourcesListSqlUserDefinedFunctions
  ## Lists the SQL userDefinedFunction under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575343 = newJObject()
  var query_575344 = newJObject()
  add(path_575343, "resourceGroupName", newJString(resourceGroupName))
  add(query_575344, "api-version", newJString(apiVersion))
  add(path_575343, "containerName", newJString(containerName))
  add(path_575343, "subscriptionId", newJString(subscriptionId))
  add(path_575343, "databaseName", newJString(databaseName))
  add(path_575343, "accountName", newJString(accountName))
  result = call_575342.call(path_575343, query_575344, nil, nil, nil)

var sqlResourcesListSqlUserDefinedFunctions* = Call_SqlResourcesListSqlUserDefinedFunctions_575332(
    name: "sqlResourcesListSqlUserDefinedFunctions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}/userDefinedFunctions/",
    validator: validate_SqlResourcesListSqlUserDefinedFunctions_575333, base: "",
    url: url_SqlResourcesListSqlUserDefinedFunctions_575334,
    schemes: {Scheme.Https})
type
  Call_SqlResourcesCreateUpdateSqlUserDefinedFunction_575359 = ref object of OpenApiRestCall_573668
proc url_SqlResourcesCreateUpdateSqlUserDefinedFunction_575361(protocol: Scheme;
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

proc validate_SqlResourcesCreateUpdateSqlUserDefinedFunction_575360(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Create or update an Azure Cosmos DB SQL userDefinedFunction
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   userDefinedFunctionName: JString (required)
  ##                          : Cosmos DB userDefinedFunction name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575362 = path.getOrDefault("resourceGroupName")
  valid_575362 = validateParameter(valid_575362, JString, required = true,
                                 default = nil)
  if valid_575362 != nil:
    section.add "resourceGroupName", valid_575362
  var valid_575363 = path.getOrDefault("containerName")
  valid_575363 = validateParameter(valid_575363, JString, required = true,
                                 default = nil)
  if valid_575363 != nil:
    section.add "containerName", valid_575363
  var valid_575364 = path.getOrDefault("subscriptionId")
  valid_575364 = validateParameter(valid_575364, JString, required = true,
                                 default = nil)
  if valid_575364 != nil:
    section.add "subscriptionId", valid_575364
  var valid_575365 = path.getOrDefault("databaseName")
  valid_575365 = validateParameter(valid_575365, JString, required = true,
                                 default = nil)
  if valid_575365 != nil:
    section.add "databaseName", valid_575365
  var valid_575366 = path.getOrDefault("userDefinedFunctionName")
  valid_575366 = validateParameter(valid_575366, JString, required = true,
                                 default = nil)
  if valid_575366 != nil:
    section.add "userDefinedFunctionName", valid_575366
  var valid_575367 = path.getOrDefault("accountName")
  valid_575367 = validateParameter(valid_575367, JString, required = true,
                                 default = nil)
  if valid_575367 != nil:
    section.add "accountName", valid_575367
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575368 = query.getOrDefault("api-version")
  valid_575368 = validateParameter(valid_575368, JString, required = true,
                                 default = nil)
  if valid_575368 != nil:
    section.add "api-version", valid_575368
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

proc call*(call_575370: Call_SqlResourcesCreateUpdateSqlUserDefinedFunction_575359;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB SQL userDefinedFunction
  ## 
  let valid = call_575370.validator(path, query, header, formData, body)
  let scheme = call_575370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575370.url(scheme.get, call_575370.host, call_575370.base,
                         call_575370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575370, url, valid)

proc call*(call_575371: Call_SqlResourcesCreateUpdateSqlUserDefinedFunction_575359;
          createUpdateSqlUserDefinedFunctionParameters: JsonNode;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; databaseName: string;
          userDefinedFunctionName: string; accountName: string): Recallable =
  ## sqlResourcesCreateUpdateSqlUserDefinedFunction
  ## Create or update an Azure Cosmos DB SQL userDefinedFunction
  ##   createUpdateSqlUserDefinedFunctionParameters: JObject (required)
  ##                                               : The parameters to provide for the current SQL userDefinedFunction.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   userDefinedFunctionName: string (required)
  ##                          : Cosmos DB userDefinedFunction name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575372 = newJObject()
  var query_575373 = newJObject()
  var body_575374 = newJObject()
  if createUpdateSqlUserDefinedFunctionParameters != nil:
    body_575374 = createUpdateSqlUserDefinedFunctionParameters
  add(path_575372, "resourceGroupName", newJString(resourceGroupName))
  add(query_575373, "api-version", newJString(apiVersion))
  add(path_575372, "containerName", newJString(containerName))
  add(path_575372, "subscriptionId", newJString(subscriptionId))
  add(path_575372, "databaseName", newJString(databaseName))
  add(path_575372, "userDefinedFunctionName", newJString(userDefinedFunctionName))
  add(path_575372, "accountName", newJString(accountName))
  result = call_575371.call(path_575372, query_575373, nil, nil, body_575374)

var sqlResourcesCreateUpdateSqlUserDefinedFunction* = Call_SqlResourcesCreateUpdateSqlUserDefinedFunction_575359(
    name: "sqlResourcesCreateUpdateSqlUserDefinedFunction",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}/userDefinedFunctions/{userDefinedFunctionName}",
    validator: validate_SqlResourcesCreateUpdateSqlUserDefinedFunction_575360,
    base: "", url: url_SqlResourcesCreateUpdateSqlUserDefinedFunction_575361,
    schemes: {Scheme.Https})
type
  Call_SqlResourcesGetSqlUserDefinedFunction_575345 = ref object of OpenApiRestCall_573668
proc url_SqlResourcesGetSqlUserDefinedFunction_575347(protocol: Scheme;
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

proc validate_SqlResourcesGetSqlUserDefinedFunction_575346(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the SQL userDefinedFunction under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   userDefinedFunctionName: JString (required)
  ##                          : Cosmos DB userDefinedFunction name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575348 = path.getOrDefault("resourceGroupName")
  valid_575348 = validateParameter(valid_575348, JString, required = true,
                                 default = nil)
  if valid_575348 != nil:
    section.add "resourceGroupName", valid_575348
  var valid_575349 = path.getOrDefault("containerName")
  valid_575349 = validateParameter(valid_575349, JString, required = true,
                                 default = nil)
  if valid_575349 != nil:
    section.add "containerName", valid_575349
  var valid_575350 = path.getOrDefault("subscriptionId")
  valid_575350 = validateParameter(valid_575350, JString, required = true,
                                 default = nil)
  if valid_575350 != nil:
    section.add "subscriptionId", valid_575350
  var valid_575351 = path.getOrDefault("databaseName")
  valid_575351 = validateParameter(valid_575351, JString, required = true,
                                 default = nil)
  if valid_575351 != nil:
    section.add "databaseName", valid_575351
  var valid_575352 = path.getOrDefault("userDefinedFunctionName")
  valid_575352 = validateParameter(valid_575352, JString, required = true,
                                 default = nil)
  if valid_575352 != nil:
    section.add "userDefinedFunctionName", valid_575352
  var valid_575353 = path.getOrDefault("accountName")
  valid_575353 = validateParameter(valid_575353, JString, required = true,
                                 default = nil)
  if valid_575353 != nil:
    section.add "accountName", valid_575353
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575354 = query.getOrDefault("api-version")
  valid_575354 = validateParameter(valid_575354, JString, required = true,
                                 default = nil)
  if valid_575354 != nil:
    section.add "api-version", valid_575354
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575355: Call_SqlResourcesGetSqlUserDefinedFunction_575345;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the SQL userDefinedFunction under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_575355.validator(path, query, header, formData, body)
  let scheme = call_575355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575355.url(scheme.get, call_575355.host, call_575355.base,
                         call_575355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575355, url, valid)

proc call*(call_575356: Call_SqlResourcesGetSqlUserDefinedFunction_575345;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; databaseName: string;
          userDefinedFunctionName: string; accountName: string): Recallable =
  ## sqlResourcesGetSqlUserDefinedFunction
  ## Gets the SQL userDefinedFunction under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   userDefinedFunctionName: string (required)
  ##                          : Cosmos DB userDefinedFunction name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575357 = newJObject()
  var query_575358 = newJObject()
  add(path_575357, "resourceGroupName", newJString(resourceGroupName))
  add(query_575358, "api-version", newJString(apiVersion))
  add(path_575357, "containerName", newJString(containerName))
  add(path_575357, "subscriptionId", newJString(subscriptionId))
  add(path_575357, "databaseName", newJString(databaseName))
  add(path_575357, "userDefinedFunctionName", newJString(userDefinedFunctionName))
  add(path_575357, "accountName", newJString(accountName))
  result = call_575356.call(path_575357, query_575358, nil, nil, nil)

var sqlResourcesGetSqlUserDefinedFunction* = Call_SqlResourcesGetSqlUserDefinedFunction_575345(
    name: "sqlResourcesGetSqlUserDefinedFunction", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}/userDefinedFunctions/{userDefinedFunctionName}",
    validator: validate_SqlResourcesGetSqlUserDefinedFunction_575346, base: "",
    url: url_SqlResourcesGetSqlUserDefinedFunction_575347, schemes: {Scheme.Https})
type
  Call_SqlResourcesDeleteSqlUserDefinedFunction_575375 = ref object of OpenApiRestCall_573668
proc url_SqlResourcesDeleteSqlUserDefinedFunction_575377(protocol: Scheme;
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

proc validate_SqlResourcesDeleteSqlUserDefinedFunction_575376(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Azure Cosmos DB SQL userDefinedFunction.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   containerName: JString (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   userDefinedFunctionName: JString (required)
  ##                          : Cosmos DB userDefinedFunction name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575378 = path.getOrDefault("resourceGroupName")
  valid_575378 = validateParameter(valid_575378, JString, required = true,
                                 default = nil)
  if valid_575378 != nil:
    section.add "resourceGroupName", valid_575378
  var valid_575379 = path.getOrDefault("containerName")
  valid_575379 = validateParameter(valid_575379, JString, required = true,
                                 default = nil)
  if valid_575379 != nil:
    section.add "containerName", valid_575379
  var valid_575380 = path.getOrDefault("subscriptionId")
  valid_575380 = validateParameter(valid_575380, JString, required = true,
                                 default = nil)
  if valid_575380 != nil:
    section.add "subscriptionId", valid_575380
  var valid_575381 = path.getOrDefault("databaseName")
  valid_575381 = validateParameter(valid_575381, JString, required = true,
                                 default = nil)
  if valid_575381 != nil:
    section.add "databaseName", valid_575381
  var valid_575382 = path.getOrDefault("userDefinedFunctionName")
  valid_575382 = validateParameter(valid_575382, JString, required = true,
                                 default = nil)
  if valid_575382 != nil:
    section.add "userDefinedFunctionName", valid_575382
  var valid_575383 = path.getOrDefault("accountName")
  valid_575383 = validateParameter(valid_575383, JString, required = true,
                                 default = nil)
  if valid_575383 != nil:
    section.add "accountName", valid_575383
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575384 = query.getOrDefault("api-version")
  valid_575384 = validateParameter(valid_575384, JString, required = true,
                                 default = nil)
  if valid_575384 != nil:
    section.add "api-version", valid_575384
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575385: Call_SqlResourcesDeleteSqlUserDefinedFunction_575375;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB SQL userDefinedFunction.
  ## 
  let valid = call_575385.validator(path, query, header, formData, body)
  let scheme = call_575385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575385.url(scheme.get, call_575385.host, call_575385.base,
                         call_575385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575385, url, valid)

proc call*(call_575386: Call_SqlResourcesDeleteSqlUserDefinedFunction_575375;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; databaseName: string;
          userDefinedFunctionName: string; accountName: string): Recallable =
  ## sqlResourcesDeleteSqlUserDefinedFunction
  ## Deletes an existing Azure Cosmos DB SQL userDefinedFunction.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   userDefinedFunctionName: string (required)
  ##                          : Cosmos DB userDefinedFunction name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575387 = newJObject()
  var query_575388 = newJObject()
  add(path_575387, "resourceGroupName", newJString(resourceGroupName))
  add(query_575388, "api-version", newJString(apiVersion))
  add(path_575387, "containerName", newJString(containerName))
  add(path_575387, "subscriptionId", newJString(subscriptionId))
  add(path_575387, "databaseName", newJString(databaseName))
  add(path_575387, "userDefinedFunctionName", newJString(userDefinedFunctionName))
  add(path_575387, "accountName", newJString(accountName))
  result = call_575386.call(path_575387, query_575388, nil, nil, nil)

var sqlResourcesDeleteSqlUserDefinedFunction* = Call_SqlResourcesDeleteSqlUserDefinedFunction_575375(
    name: "sqlResourcesDeleteSqlUserDefinedFunction", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}/userDefinedFunctions/{userDefinedFunctionName}",
    validator: validate_SqlResourcesDeleteSqlUserDefinedFunction_575376, base: "",
    url: url_SqlResourcesDeleteSqlUserDefinedFunction_575377,
    schemes: {Scheme.Https})
type
  Call_SqlResourcesUpdateSqlDatabaseThroughput_575401 = ref object of OpenApiRestCall_573668
proc url_SqlResourcesUpdateSqlDatabaseThroughput_575403(protocol: Scheme;
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

proc validate_SqlResourcesUpdateSqlDatabaseThroughput_575402(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update RUs per second of an Azure Cosmos DB SQL database
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575404 = path.getOrDefault("resourceGroupName")
  valid_575404 = validateParameter(valid_575404, JString, required = true,
                                 default = nil)
  if valid_575404 != nil:
    section.add "resourceGroupName", valid_575404
  var valid_575405 = path.getOrDefault("subscriptionId")
  valid_575405 = validateParameter(valid_575405, JString, required = true,
                                 default = nil)
  if valid_575405 != nil:
    section.add "subscriptionId", valid_575405
  var valid_575406 = path.getOrDefault("databaseName")
  valid_575406 = validateParameter(valid_575406, JString, required = true,
                                 default = nil)
  if valid_575406 != nil:
    section.add "databaseName", valid_575406
  var valid_575407 = path.getOrDefault("accountName")
  valid_575407 = validateParameter(valid_575407, JString, required = true,
                                 default = nil)
  if valid_575407 != nil:
    section.add "accountName", valid_575407
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575408 = query.getOrDefault("api-version")
  valid_575408 = validateParameter(valid_575408, JString, required = true,
                                 default = nil)
  if valid_575408 != nil:
    section.add "api-version", valid_575408
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

proc call*(call_575410: Call_SqlResourcesUpdateSqlDatabaseThroughput_575401;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB SQL database
  ## 
  let valid = call_575410.validator(path, query, header, formData, body)
  let scheme = call_575410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575410.url(scheme.get, call_575410.host, call_575410.base,
                         call_575410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575410, url, valid)

proc call*(call_575411: Call_SqlResourcesUpdateSqlDatabaseThroughput_575401;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; updateThroughputParameters: JsonNode;
          accountName: string): Recallable =
  ## sqlResourcesUpdateSqlDatabaseThroughput
  ## Update RUs per second of an Azure Cosmos DB SQL database
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   updateThroughputParameters: JObject (required)
  ##                             : The parameters to provide for the RUs per second of the current SQL database.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575412 = newJObject()
  var query_575413 = newJObject()
  var body_575414 = newJObject()
  add(path_575412, "resourceGroupName", newJString(resourceGroupName))
  add(query_575413, "api-version", newJString(apiVersion))
  add(path_575412, "subscriptionId", newJString(subscriptionId))
  add(path_575412, "databaseName", newJString(databaseName))
  if updateThroughputParameters != nil:
    body_575414 = updateThroughputParameters
  add(path_575412, "accountName", newJString(accountName))
  result = call_575411.call(path_575412, query_575413, nil, nil, body_575414)

var sqlResourcesUpdateSqlDatabaseThroughput* = Call_SqlResourcesUpdateSqlDatabaseThroughput_575401(
    name: "sqlResourcesUpdateSqlDatabaseThroughput", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/throughputSettings/default",
    validator: validate_SqlResourcesUpdateSqlDatabaseThroughput_575402, base: "",
    url: url_SqlResourcesUpdateSqlDatabaseThroughput_575403,
    schemes: {Scheme.Https})
type
  Call_SqlResourcesGetSqlDatabaseThroughput_575389 = ref object of OpenApiRestCall_573668
proc url_SqlResourcesGetSqlDatabaseThroughput_575391(protocol: Scheme;
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

proc validate_SqlResourcesGetSqlDatabaseThroughput_575390(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the RUs per second of the SQL database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   databaseName: JString (required)
  ##               : Cosmos DB database name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575392 = path.getOrDefault("resourceGroupName")
  valid_575392 = validateParameter(valid_575392, JString, required = true,
                                 default = nil)
  if valid_575392 != nil:
    section.add "resourceGroupName", valid_575392
  var valid_575393 = path.getOrDefault("subscriptionId")
  valid_575393 = validateParameter(valid_575393, JString, required = true,
                                 default = nil)
  if valid_575393 != nil:
    section.add "subscriptionId", valid_575393
  var valid_575394 = path.getOrDefault("databaseName")
  valid_575394 = validateParameter(valid_575394, JString, required = true,
                                 default = nil)
  if valid_575394 != nil:
    section.add "databaseName", valid_575394
  var valid_575395 = path.getOrDefault("accountName")
  valid_575395 = validateParameter(valid_575395, JString, required = true,
                                 default = nil)
  if valid_575395 != nil:
    section.add "accountName", valid_575395
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575396 = query.getOrDefault("api-version")
  valid_575396 = validateParameter(valid_575396, JString, required = true,
                                 default = nil)
  if valid_575396 != nil:
    section.add "api-version", valid_575396
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575397: Call_SqlResourcesGetSqlDatabaseThroughput_575389;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the SQL database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_575397.validator(path, query, header, formData, body)
  let scheme = call_575397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575397.url(scheme.get, call_575397.host, call_575397.base,
                         call_575397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575397, url, valid)

proc call*(call_575398: Call_SqlResourcesGetSqlDatabaseThroughput_575389;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; accountName: string): Recallable =
  ## sqlResourcesGetSqlDatabaseThroughput
  ## Gets the RUs per second of the SQL database under an existing Azure Cosmos DB database account with the provided name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575399 = newJObject()
  var query_575400 = newJObject()
  add(path_575399, "resourceGroupName", newJString(resourceGroupName))
  add(query_575400, "api-version", newJString(apiVersion))
  add(path_575399, "subscriptionId", newJString(subscriptionId))
  add(path_575399, "databaseName", newJString(databaseName))
  add(path_575399, "accountName", newJString(accountName))
  result = call_575398.call(path_575399, query_575400, nil, nil, nil)

var sqlResourcesGetSqlDatabaseThroughput* = Call_SqlResourcesGetSqlDatabaseThroughput_575389(
    name: "sqlResourcesGetSqlDatabaseThroughput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sqlDatabases/{databaseName}/throughputSettings/default",
    validator: validate_SqlResourcesGetSqlDatabaseThroughput_575390, base: "",
    url: url_SqlResourcesGetSqlDatabaseThroughput_575391, schemes: {Scheme.Https})
type
  Call_TableResourcesListTables_575415 = ref object of OpenApiRestCall_573668
proc url_TableResourcesListTables_575417(protocol: Scheme; host: string;
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

proc validate_TableResourcesListTables_575416(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Tables under an existing Azure Cosmos DB database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575418 = path.getOrDefault("resourceGroupName")
  valid_575418 = validateParameter(valid_575418, JString, required = true,
                                 default = nil)
  if valid_575418 != nil:
    section.add "resourceGroupName", valid_575418
  var valid_575419 = path.getOrDefault("subscriptionId")
  valid_575419 = validateParameter(valid_575419, JString, required = true,
                                 default = nil)
  if valid_575419 != nil:
    section.add "subscriptionId", valid_575419
  var valid_575420 = path.getOrDefault("accountName")
  valid_575420 = validateParameter(valid_575420, JString, required = true,
                                 default = nil)
  if valid_575420 != nil:
    section.add "accountName", valid_575420
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575421 = query.getOrDefault("api-version")
  valid_575421 = validateParameter(valid_575421, JString, required = true,
                                 default = nil)
  if valid_575421 != nil:
    section.add "api-version", valid_575421
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575422: Call_TableResourcesListTables_575415; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Tables under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_575422.validator(path, query, header, formData, body)
  let scheme = call_575422.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575422.url(scheme.get, call_575422.host, call_575422.base,
                         call_575422.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575422, url, valid)

proc call*(call_575423: Call_TableResourcesListTables_575415;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## tableResourcesListTables
  ## Lists the Tables under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575424 = newJObject()
  var query_575425 = newJObject()
  add(path_575424, "resourceGroupName", newJString(resourceGroupName))
  add(query_575425, "api-version", newJString(apiVersion))
  add(path_575424, "subscriptionId", newJString(subscriptionId))
  add(path_575424, "accountName", newJString(accountName))
  result = call_575423.call(path_575424, query_575425, nil, nil, nil)

var tableResourcesListTables* = Call_TableResourcesListTables_575415(
    name: "tableResourcesListTables", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/tables",
    validator: validate_TableResourcesListTables_575416, base: "",
    url: url_TableResourcesListTables_575417, schemes: {Scheme.Https})
type
  Call_TableResourcesCreateUpdateTable_575438 = ref object of OpenApiRestCall_573668
proc url_TableResourcesCreateUpdateTable_575440(protocol: Scheme; host: string;
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

proc validate_TableResourcesCreateUpdateTable_575439(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an Azure Cosmos DB Table
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   tableName: JString (required)
  ##            : Cosmos DB table name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575441 = path.getOrDefault("resourceGroupName")
  valid_575441 = validateParameter(valid_575441, JString, required = true,
                                 default = nil)
  if valid_575441 != nil:
    section.add "resourceGroupName", valid_575441
  var valid_575442 = path.getOrDefault("subscriptionId")
  valid_575442 = validateParameter(valid_575442, JString, required = true,
                                 default = nil)
  if valid_575442 != nil:
    section.add "subscriptionId", valid_575442
  var valid_575443 = path.getOrDefault("tableName")
  valid_575443 = validateParameter(valid_575443, JString, required = true,
                                 default = nil)
  if valid_575443 != nil:
    section.add "tableName", valid_575443
  var valid_575444 = path.getOrDefault("accountName")
  valid_575444 = validateParameter(valid_575444, JString, required = true,
                                 default = nil)
  if valid_575444 != nil:
    section.add "accountName", valid_575444
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575445 = query.getOrDefault("api-version")
  valid_575445 = validateParameter(valid_575445, JString, required = true,
                                 default = nil)
  if valid_575445 != nil:
    section.add "api-version", valid_575445
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

proc call*(call_575447: Call_TableResourcesCreateUpdateTable_575438;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB Table
  ## 
  let valid = call_575447.validator(path, query, header, formData, body)
  let scheme = call_575447.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575447.url(scheme.get, call_575447.host, call_575447.base,
                         call_575447.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575447, url, valid)

proc call*(call_575448: Call_TableResourcesCreateUpdateTable_575438;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          tableName: string; createUpdateTableParameters: JsonNode;
          accountName: string): Recallable =
  ## tableResourcesCreateUpdateTable
  ## Create or update an Azure Cosmos DB Table
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   createUpdateTableParameters: JObject (required)
  ##                              : The parameters to provide for the current Table.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575449 = newJObject()
  var query_575450 = newJObject()
  var body_575451 = newJObject()
  add(path_575449, "resourceGroupName", newJString(resourceGroupName))
  add(query_575450, "api-version", newJString(apiVersion))
  add(path_575449, "subscriptionId", newJString(subscriptionId))
  add(path_575449, "tableName", newJString(tableName))
  if createUpdateTableParameters != nil:
    body_575451 = createUpdateTableParameters
  add(path_575449, "accountName", newJString(accountName))
  result = call_575448.call(path_575449, query_575450, nil, nil, body_575451)

var tableResourcesCreateUpdateTable* = Call_TableResourcesCreateUpdateTable_575438(
    name: "tableResourcesCreateUpdateTable", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/tables/{tableName}",
    validator: validate_TableResourcesCreateUpdateTable_575439, base: "",
    url: url_TableResourcesCreateUpdateTable_575440, schemes: {Scheme.Https})
type
  Call_TableResourcesGetTable_575426 = ref object of OpenApiRestCall_573668
proc url_TableResourcesGetTable_575428(protocol: Scheme; host: string; base: string;
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

proc validate_TableResourcesGetTable_575427(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Tables under an existing Azure Cosmos DB database account with the provided name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   tableName: JString (required)
  ##            : Cosmos DB table name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575429 = path.getOrDefault("resourceGroupName")
  valid_575429 = validateParameter(valid_575429, JString, required = true,
                                 default = nil)
  if valid_575429 != nil:
    section.add "resourceGroupName", valid_575429
  var valid_575430 = path.getOrDefault("subscriptionId")
  valid_575430 = validateParameter(valid_575430, JString, required = true,
                                 default = nil)
  if valid_575430 != nil:
    section.add "subscriptionId", valid_575430
  var valid_575431 = path.getOrDefault("tableName")
  valid_575431 = validateParameter(valid_575431, JString, required = true,
                                 default = nil)
  if valid_575431 != nil:
    section.add "tableName", valid_575431
  var valid_575432 = path.getOrDefault("accountName")
  valid_575432 = validateParameter(valid_575432, JString, required = true,
                                 default = nil)
  if valid_575432 != nil:
    section.add "accountName", valid_575432
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575433 = query.getOrDefault("api-version")
  valid_575433 = validateParameter(valid_575433, JString, required = true,
                                 default = nil)
  if valid_575433 != nil:
    section.add "api-version", valid_575433
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575434: Call_TableResourcesGetTable_575426; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Tables under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_575434.validator(path, query, header, formData, body)
  let scheme = call_575434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575434.url(scheme.get, call_575434.host, call_575434.base,
                         call_575434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575434, url, valid)

proc call*(call_575435: Call_TableResourcesGetTable_575426;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          tableName: string; accountName: string): Recallable =
  ## tableResourcesGetTable
  ## Gets the Tables under an existing Azure Cosmos DB database account with the provided name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575436 = newJObject()
  var query_575437 = newJObject()
  add(path_575436, "resourceGroupName", newJString(resourceGroupName))
  add(query_575437, "api-version", newJString(apiVersion))
  add(path_575436, "subscriptionId", newJString(subscriptionId))
  add(path_575436, "tableName", newJString(tableName))
  add(path_575436, "accountName", newJString(accountName))
  result = call_575435.call(path_575436, query_575437, nil, nil, nil)

var tableResourcesGetTable* = Call_TableResourcesGetTable_575426(
    name: "tableResourcesGetTable", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/tables/{tableName}",
    validator: validate_TableResourcesGetTable_575427, base: "",
    url: url_TableResourcesGetTable_575428, schemes: {Scheme.Https})
type
  Call_TableResourcesDeleteTable_575452 = ref object of OpenApiRestCall_573668
proc url_TableResourcesDeleteTable_575454(protocol: Scheme; host: string;
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

proc validate_TableResourcesDeleteTable_575453(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Azure Cosmos DB Table.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   tableName: JString (required)
  ##            : Cosmos DB table name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575455 = path.getOrDefault("resourceGroupName")
  valid_575455 = validateParameter(valid_575455, JString, required = true,
                                 default = nil)
  if valid_575455 != nil:
    section.add "resourceGroupName", valid_575455
  var valid_575456 = path.getOrDefault("subscriptionId")
  valid_575456 = validateParameter(valid_575456, JString, required = true,
                                 default = nil)
  if valid_575456 != nil:
    section.add "subscriptionId", valid_575456
  var valid_575457 = path.getOrDefault("tableName")
  valid_575457 = validateParameter(valid_575457, JString, required = true,
                                 default = nil)
  if valid_575457 != nil:
    section.add "tableName", valid_575457
  var valid_575458 = path.getOrDefault("accountName")
  valid_575458 = validateParameter(valid_575458, JString, required = true,
                                 default = nil)
  if valid_575458 != nil:
    section.add "accountName", valid_575458
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575459 = query.getOrDefault("api-version")
  valid_575459 = validateParameter(valid_575459, JString, required = true,
                                 default = nil)
  if valid_575459 != nil:
    section.add "api-version", valid_575459
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575460: Call_TableResourcesDeleteTable_575452; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB Table.
  ## 
  let valid = call_575460.validator(path, query, header, formData, body)
  let scheme = call_575460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575460.url(scheme.get, call_575460.host, call_575460.base,
                         call_575460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575460, url, valid)

proc call*(call_575461: Call_TableResourcesDeleteTable_575452;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          tableName: string; accountName: string): Recallable =
  ## tableResourcesDeleteTable
  ## Deletes an existing Azure Cosmos DB Table.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575462 = newJObject()
  var query_575463 = newJObject()
  add(path_575462, "resourceGroupName", newJString(resourceGroupName))
  add(query_575463, "api-version", newJString(apiVersion))
  add(path_575462, "subscriptionId", newJString(subscriptionId))
  add(path_575462, "tableName", newJString(tableName))
  add(path_575462, "accountName", newJString(accountName))
  result = call_575461.call(path_575462, query_575463, nil, nil, nil)

var tableResourcesDeleteTable* = Call_TableResourcesDeleteTable_575452(
    name: "tableResourcesDeleteTable", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/tables/{tableName}",
    validator: validate_TableResourcesDeleteTable_575453, base: "",
    url: url_TableResourcesDeleteTable_575454, schemes: {Scheme.Https})
type
  Call_TableResourcesUpdateTableThroughput_575476 = ref object of OpenApiRestCall_573668
proc url_TableResourcesUpdateTableThroughput_575478(protocol: Scheme; host: string;
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

proc validate_TableResourcesUpdateTableThroughput_575477(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update RUs per second of an Azure Cosmos DB Table
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   tableName: JString (required)
  ##            : Cosmos DB table name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575479 = path.getOrDefault("resourceGroupName")
  valid_575479 = validateParameter(valid_575479, JString, required = true,
                                 default = nil)
  if valid_575479 != nil:
    section.add "resourceGroupName", valid_575479
  var valid_575480 = path.getOrDefault("subscriptionId")
  valid_575480 = validateParameter(valid_575480, JString, required = true,
                                 default = nil)
  if valid_575480 != nil:
    section.add "subscriptionId", valid_575480
  var valid_575481 = path.getOrDefault("tableName")
  valid_575481 = validateParameter(valid_575481, JString, required = true,
                                 default = nil)
  if valid_575481 != nil:
    section.add "tableName", valid_575481
  var valid_575482 = path.getOrDefault("accountName")
  valid_575482 = validateParameter(valid_575482, JString, required = true,
                                 default = nil)
  if valid_575482 != nil:
    section.add "accountName", valid_575482
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575483 = query.getOrDefault("api-version")
  valid_575483 = validateParameter(valid_575483, JString, required = true,
                                 default = nil)
  if valid_575483 != nil:
    section.add "api-version", valid_575483
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

proc call*(call_575485: Call_TableResourcesUpdateTableThroughput_575476;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Table
  ## 
  let valid = call_575485.validator(path, query, header, formData, body)
  let scheme = call_575485.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575485.url(scheme.get, call_575485.host, call_575485.base,
                         call_575485.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575485, url, valid)

proc call*(call_575486: Call_TableResourcesUpdateTableThroughput_575476;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          tableName: string; updateThroughputParameters: JsonNode;
          accountName: string): Recallable =
  ## tableResourcesUpdateTableThroughput
  ## Update RUs per second of an Azure Cosmos DB Table
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   updateThroughputParameters: JObject (required)
  ##                             : The parameters to provide for the RUs per second of the current Table.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575487 = newJObject()
  var query_575488 = newJObject()
  var body_575489 = newJObject()
  add(path_575487, "resourceGroupName", newJString(resourceGroupName))
  add(query_575488, "api-version", newJString(apiVersion))
  add(path_575487, "subscriptionId", newJString(subscriptionId))
  add(path_575487, "tableName", newJString(tableName))
  if updateThroughputParameters != nil:
    body_575489 = updateThroughputParameters
  add(path_575487, "accountName", newJString(accountName))
  result = call_575486.call(path_575487, query_575488, nil, nil, body_575489)

var tableResourcesUpdateTableThroughput* = Call_TableResourcesUpdateTableThroughput_575476(
    name: "tableResourcesUpdateTableThroughput", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/tables/{tableName}/throughputSettings/default",
    validator: validate_TableResourcesUpdateTableThroughput_575477, base: "",
    url: url_TableResourcesUpdateTableThroughput_575478, schemes: {Scheme.Https})
type
  Call_TableResourcesGetTableThroughput_575464 = ref object of OpenApiRestCall_573668
proc url_TableResourcesGetTableThroughput_575466(protocol: Scheme; host: string;
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

proc validate_TableResourcesGetTableThroughput_575465(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the RUs per second of the Table under an existing Azure Cosmos DB database account with the provided name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   tableName: JString (required)
  ##            : Cosmos DB table name.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575467 = path.getOrDefault("resourceGroupName")
  valid_575467 = validateParameter(valid_575467, JString, required = true,
                                 default = nil)
  if valid_575467 != nil:
    section.add "resourceGroupName", valid_575467
  var valid_575468 = path.getOrDefault("subscriptionId")
  valid_575468 = validateParameter(valid_575468, JString, required = true,
                                 default = nil)
  if valid_575468 != nil:
    section.add "subscriptionId", valid_575468
  var valid_575469 = path.getOrDefault("tableName")
  valid_575469 = validateParameter(valid_575469, JString, required = true,
                                 default = nil)
  if valid_575469 != nil:
    section.add "tableName", valid_575469
  var valid_575470 = path.getOrDefault("accountName")
  valid_575470 = validateParameter(valid_575470, JString, required = true,
                                 default = nil)
  if valid_575470 != nil:
    section.add "accountName", valid_575470
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575471 = query.getOrDefault("api-version")
  valid_575471 = validateParameter(valid_575471, JString, required = true,
                                 default = nil)
  if valid_575471 != nil:
    section.add "api-version", valid_575471
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575472: Call_TableResourcesGetTableThroughput_575464;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the Table under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_575472.validator(path, query, header, formData, body)
  let scheme = call_575472.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575472.url(scheme.get, call_575472.host, call_575472.base,
                         call_575472.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575472, url, valid)

proc call*(call_575473: Call_TableResourcesGetTableThroughput_575464;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          tableName: string; accountName: string): Recallable =
  ## tableResourcesGetTableThroughput
  ## Gets the RUs per second of the Table under an existing Azure Cosmos DB database account with the provided name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575474 = newJObject()
  var query_575475 = newJObject()
  add(path_575474, "resourceGroupName", newJString(resourceGroupName))
  add(query_575475, "api-version", newJString(apiVersion))
  add(path_575474, "subscriptionId", newJString(subscriptionId))
  add(path_575474, "tableName", newJString(tableName))
  add(path_575474, "accountName", newJString(accountName))
  result = call_575473.call(path_575474, query_575475, nil, nil, nil)

var tableResourcesGetTableThroughput* = Call_TableResourcesGetTableThroughput_575464(
    name: "tableResourcesGetTableThroughput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/tables/{tableName}/throughputSettings/default",
    validator: validate_TableResourcesGetTableThroughput_575465, base: "",
    url: url_TableResourcesGetTableThroughput_575466, schemes: {Scheme.Https})
type
  Call_PercentileTargetListMetrics_575490 = ref object of OpenApiRestCall_573668
proc url_PercentileTargetListMetrics_575492(protocol: Scheme; host: string;
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

proc validate_PercentileTargetListMetrics_575491(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the metrics determined by the given filter for the given account target region. This url is only for PBS and Replication Latency data
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   targetRegion: JString (required)
  ##               : Target region to which data is written. Cosmos DB region, with spaces between words and each word capitalized.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575493 = path.getOrDefault("resourceGroupName")
  valid_575493 = validateParameter(valid_575493, JString, required = true,
                                 default = nil)
  if valid_575493 != nil:
    section.add "resourceGroupName", valid_575493
  var valid_575494 = path.getOrDefault("subscriptionId")
  valid_575494 = validateParameter(valid_575494, JString, required = true,
                                 default = nil)
  if valid_575494 != nil:
    section.add "subscriptionId", valid_575494
  var valid_575495 = path.getOrDefault("targetRegion")
  valid_575495 = validateParameter(valid_575495, JString, required = true,
                                 default = nil)
  if valid_575495 != nil:
    section.add "targetRegion", valid_575495
  var valid_575496 = path.getOrDefault("accountName")
  valid_575496 = validateParameter(valid_575496, JString, required = true,
                                 default = nil)
  if valid_575496 != nil:
    section.add "accountName", valid_575496
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575497 = query.getOrDefault("api-version")
  valid_575497 = validateParameter(valid_575497, JString, required = true,
                                 default = nil)
  if valid_575497 != nil:
    section.add "api-version", valid_575497
  var valid_575498 = query.getOrDefault("$filter")
  valid_575498 = validateParameter(valid_575498, JString, required = true,
                                 default = nil)
  if valid_575498 != nil:
    section.add "$filter", valid_575498
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575499: Call_PercentileTargetListMetrics_575490; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given account target region. This url is only for PBS and Replication Latency data
  ## 
  let valid = call_575499.validator(path, query, header, formData, body)
  let scheme = call_575499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575499.url(scheme.get, call_575499.host, call_575499.base,
                         call_575499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575499, url, valid)

proc call*(call_575500: Call_PercentileTargetListMetrics_575490;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          targetRegion: string; accountName: string; Filter: string): Recallable =
  ## percentileTargetListMetrics
  ## Retrieves the metrics determined by the given filter for the given account target region. This url is only for PBS and Replication Latency data
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   targetRegion: string (required)
  ##               : Target region to which data is written. Cosmos DB region, with spaces between words and each word capitalized.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  var path_575501 = newJObject()
  var query_575502 = newJObject()
  add(path_575501, "resourceGroupName", newJString(resourceGroupName))
  add(query_575502, "api-version", newJString(apiVersion))
  add(path_575501, "subscriptionId", newJString(subscriptionId))
  add(path_575501, "targetRegion", newJString(targetRegion))
  add(path_575501, "accountName", newJString(accountName))
  add(query_575502, "$filter", newJString(Filter))
  result = call_575500.call(path_575501, query_575502, nil, nil, nil)

var percentileTargetListMetrics* = Call_PercentileTargetListMetrics_575490(
    name: "percentileTargetListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/targetRegion/{targetRegion}/percentile/metrics",
    validator: validate_PercentileTargetListMetrics_575491, base: "",
    url: url_PercentileTargetListMetrics_575492, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListUsages_575503 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsListUsages_575505(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListUsages_575504(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the usages (most recent data) for the given database account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Cosmos DB database account name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575506 = path.getOrDefault("resourceGroupName")
  valid_575506 = validateParameter(valid_575506, JString, required = true,
                                 default = nil)
  if valid_575506 != nil:
    section.add "resourceGroupName", valid_575506
  var valid_575507 = path.getOrDefault("subscriptionId")
  valid_575507 = validateParameter(valid_575507, JString, required = true,
                                 default = nil)
  if valid_575507 != nil:
    section.add "subscriptionId", valid_575507
  var valid_575508 = path.getOrDefault("accountName")
  valid_575508 = validateParameter(valid_575508, JString, required = true,
                                 default = nil)
  if valid_575508 != nil:
    section.add "accountName", valid_575508
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   $filter: JString
  ##          : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575509 = query.getOrDefault("api-version")
  valid_575509 = validateParameter(valid_575509, JString, required = true,
                                 default = nil)
  if valid_575509 != nil:
    section.add "api-version", valid_575509
  var valid_575510 = query.getOrDefault("$filter")
  valid_575510 = validateParameter(valid_575510, JString, required = false,
                                 default = nil)
  if valid_575510 != nil:
    section.add "$filter", valid_575510
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575511: Call_DatabaseAccountsListUsages_575503; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the usages (most recent data) for the given database account.
  ## 
  let valid = call_575511.validator(path, query, header, formData, body)
  let scheme = call_575511.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575511.url(scheme.get, call_575511.host, call_575511.base,
                         call_575511.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575511, url, valid)

proc call*(call_575512: Call_DatabaseAccountsListUsages_575503;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string; Filter: string = ""): Recallable =
  ## databaseAccountsListUsages
  ## Retrieves the usages (most recent data) for the given database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2019-08-01.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   Filter: string
  ##         : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  var path_575513 = newJObject()
  var query_575514 = newJObject()
  add(path_575513, "resourceGroupName", newJString(resourceGroupName))
  add(query_575514, "api-version", newJString(apiVersion))
  add(path_575513, "subscriptionId", newJString(subscriptionId))
  add(path_575513, "accountName", newJString(accountName))
  add(query_575514, "$filter", newJString(Filter))
  result = call_575512.call(path_575513, query_575514, nil, nil, nil)

var databaseAccountsListUsages* = Call_DatabaseAccountsListUsages_575503(
    name: "databaseAccountsListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/usages",
    validator: validate_DatabaseAccountsListUsages_575504, base: "",
    url: url_DatabaseAccountsListUsages_575505, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
