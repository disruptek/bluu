
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  Call_DatabaseAccountsListCassandraKeyspaces_574276 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsListCassandraKeyspaces_574278(protocol: Scheme;
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

proc validate_DatabaseAccountsListCassandraKeyspaces_574277(path: JsonNode;
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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

proc call*(call_574283: Call_DatabaseAccountsListCassandraKeyspaces_574276;
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

proc call*(call_574284: Call_DatabaseAccountsListCassandraKeyspaces_574276;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## databaseAccountsListCassandraKeyspaces
  ## Lists the Cassandra keyspaces under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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

var databaseAccountsListCassandraKeyspaces* = Call_DatabaseAccountsListCassandraKeyspaces_574276(
    name: "databaseAccountsListCassandraKeyspaces", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces",
    validator: validate_DatabaseAccountsListCassandraKeyspaces_574277, base: "",
    url: url_DatabaseAccountsListCassandraKeyspaces_574278,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateCassandraKeyspace_574299 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsCreateUpdateCassandraKeyspace_574301(protocol: Scheme;
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

proc validate_DatabaseAccountsCreateUpdateCassandraKeyspace_574300(
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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

proc call*(call_574308: Call_DatabaseAccountsCreateUpdateCassandraKeyspace_574299;
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

proc call*(call_574309: Call_DatabaseAccountsCreateUpdateCassandraKeyspace_574299;
          resourceGroupName: string; apiVersion: string;
          createUpdateCassandraKeyspaceParameters: JsonNode; keyspaceName: string;
          subscriptionId: string; accountName: string): Recallable =
  ## databaseAccountsCreateUpdateCassandraKeyspace
  ## Create or update an Azure Cosmos DB Cassandra keyspace
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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

var databaseAccountsCreateUpdateCassandraKeyspace* = Call_DatabaseAccountsCreateUpdateCassandraKeyspace_574299(
    name: "databaseAccountsCreateUpdateCassandraKeyspace",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}",
    validator: validate_DatabaseAccountsCreateUpdateCassandraKeyspace_574300,
    base: "", url: url_DatabaseAccountsCreateUpdateCassandraKeyspace_574301,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetCassandraKeyspace_574287 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsGetCassandraKeyspace_574289(protocol: Scheme;
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

proc validate_DatabaseAccountsGetCassandraKeyspace_574288(path: JsonNode;
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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

proc call*(call_574295: Call_DatabaseAccountsGetCassandraKeyspace_574287;
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

proc call*(call_574296: Call_DatabaseAccountsGetCassandraKeyspace_574287;
          resourceGroupName: string; apiVersion: string; keyspaceName: string;
          subscriptionId: string; accountName: string): Recallable =
  ## databaseAccountsGetCassandraKeyspace
  ## Gets the Cassandra keyspaces under an existing Azure Cosmos DB database account with the provided name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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

var databaseAccountsGetCassandraKeyspace* = Call_DatabaseAccountsGetCassandraKeyspace_574287(
    name: "databaseAccountsGetCassandraKeyspace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}",
    validator: validate_DatabaseAccountsGetCassandraKeyspace_574288, base: "",
    url: url_DatabaseAccountsGetCassandraKeyspace_574289, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteCassandraKeyspace_574313 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsDeleteCassandraKeyspace_574315(protocol: Scheme;
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

proc validate_DatabaseAccountsDeleteCassandraKeyspace_574314(path: JsonNode;
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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

proc call*(call_574321: Call_DatabaseAccountsDeleteCassandraKeyspace_574313;
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

proc call*(call_574322: Call_DatabaseAccountsDeleteCassandraKeyspace_574313;
          resourceGroupName: string; apiVersion: string; keyspaceName: string;
          subscriptionId: string; accountName: string): Recallable =
  ## databaseAccountsDeleteCassandraKeyspace
  ## Deletes an existing Azure Cosmos DB Cassandra keyspace.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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

var databaseAccountsDeleteCassandraKeyspace* = Call_DatabaseAccountsDeleteCassandraKeyspace_574313(
    name: "databaseAccountsDeleteCassandraKeyspace", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}",
    validator: validate_DatabaseAccountsDeleteCassandraKeyspace_574314, base: "",
    url: url_DatabaseAccountsDeleteCassandraKeyspace_574315,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateCassandraKeyspaceThroughput_574337 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsUpdateCassandraKeyspaceThroughput_574339(
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

proc validate_DatabaseAccountsUpdateCassandraKeyspaceThroughput_574338(
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
  var valid_574343 = path.getOrDefault("accountName")
  valid_574343 = validateParameter(valid_574343, JString, required = true,
                                 default = nil)
  if valid_574343 != nil:
    section.add "accountName", valid_574343
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574344 = query.getOrDefault("api-version")
  valid_574344 = validateParameter(valid_574344, JString, required = true,
                                 default = nil)
  if valid_574344 != nil:
    section.add "api-version", valid_574344
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

proc call*(call_574346: Call_DatabaseAccountsUpdateCassandraKeyspaceThroughput_574337;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Cassandra Keyspace
  ## 
  let valid = call_574346.validator(path, query, header, formData, body)
  let scheme = call_574346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574346.url(scheme.get, call_574346.host, call_574346.base,
                         call_574346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574346, url, valid)

proc call*(call_574347: Call_DatabaseAccountsUpdateCassandraKeyspaceThroughput_574337;
          resourceGroupName: string; apiVersion: string; keyspaceName: string;
          subscriptionId: string; updateThroughputParameters: JsonNode;
          accountName: string): Recallable =
  ## databaseAccountsUpdateCassandraKeyspaceThroughput
  ## Update RUs per second of an Azure Cosmos DB Cassandra Keyspace
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   keyspaceName: string (required)
  ##               : Cosmos DB keyspace name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   updateThroughputParameters: JObject (required)
  ##                             : The RUs per second of the parameters to provide for the current Cassandra Keyspace.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574348 = newJObject()
  var query_574349 = newJObject()
  var body_574350 = newJObject()
  add(path_574348, "resourceGroupName", newJString(resourceGroupName))
  add(query_574349, "api-version", newJString(apiVersion))
  add(path_574348, "keyspaceName", newJString(keyspaceName))
  add(path_574348, "subscriptionId", newJString(subscriptionId))
  if updateThroughputParameters != nil:
    body_574350 = updateThroughputParameters
  add(path_574348, "accountName", newJString(accountName))
  result = call_574347.call(path_574348, query_574349, nil, nil, body_574350)

var databaseAccountsUpdateCassandraKeyspaceThroughput* = Call_DatabaseAccountsUpdateCassandraKeyspaceThroughput_574337(
    name: "databaseAccountsUpdateCassandraKeyspaceThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateCassandraKeyspaceThroughput_574338,
    base: "", url: url_DatabaseAccountsUpdateCassandraKeyspaceThroughput_574339,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetCassandraKeyspaceThroughput_574325 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsGetCassandraKeyspaceThroughput_574327(protocol: Scheme;
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

proc validate_DatabaseAccountsGetCassandraKeyspaceThroughput_574326(
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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

proc call*(call_574333: Call_DatabaseAccountsGetCassandraKeyspaceThroughput_574325;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the Cassandra Keyspace under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_574333.validator(path, query, header, formData, body)
  let scheme = call_574333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574333.url(scheme.get, call_574333.host, call_574333.base,
                         call_574333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574333, url, valid)

proc call*(call_574334: Call_DatabaseAccountsGetCassandraKeyspaceThroughput_574325;
          resourceGroupName: string; apiVersion: string; keyspaceName: string;
          subscriptionId: string; accountName: string): Recallable =
  ## databaseAccountsGetCassandraKeyspaceThroughput
  ## Gets the RUs per second of the Cassandra Keyspace under an existing Azure Cosmos DB database account with the provided name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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

var databaseAccountsGetCassandraKeyspaceThroughput* = Call_DatabaseAccountsGetCassandraKeyspaceThroughput_574325(
    name: "databaseAccountsGetCassandraKeyspaceThroughput",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/settings/throughput",
    validator: validate_DatabaseAccountsGetCassandraKeyspaceThroughput_574326,
    base: "", url: url_DatabaseAccountsGetCassandraKeyspaceThroughput_574327,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListCassandraTables_574351 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsListCassandraTables_574353(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListCassandraTables_574352(path: JsonNode;
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
  var valid_574354 = path.getOrDefault("resourceGroupName")
  valid_574354 = validateParameter(valid_574354, JString, required = true,
                                 default = nil)
  if valid_574354 != nil:
    section.add "resourceGroupName", valid_574354
  var valid_574355 = path.getOrDefault("keyspaceName")
  valid_574355 = validateParameter(valid_574355, JString, required = true,
                                 default = nil)
  if valid_574355 != nil:
    section.add "keyspaceName", valid_574355
  var valid_574356 = path.getOrDefault("subscriptionId")
  valid_574356 = validateParameter(valid_574356, JString, required = true,
                                 default = nil)
  if valid_574356 != nil:
    section.add "subscriptionId", valid_574356
  var valid_574357 = path.getOrDefault("accountName")
  valid_574357 = validateParameter(valid_574357, JString, required = true,
                                 default = nil)
  if valid_574357 != nil:
    section.add "accountName", valid_574357
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  if body != nil:
    result.add "body", body

proc call*(call_574359: Call_DatabaseAccountsListCassandraTables_574351;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Cassandra table under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_574359.validator(path, query, header, formData, body)
  let scheme = call_574359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574359.url(scheme.get, call_574359.host, call_574359.base,
                         call_574359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574359, url, valid)

proc call*(call_574360: Call_DatabaseAccountsListCassandraTables_574351;
          resourceGroupName: string; apiVersion: string; keyspaceName: string;
          subscriptionId: string; accountName: string): Recallable =
  ## databaseAccountsListCassandraTables
  ## Lists the Cassandra table under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   keyspaceName: string (required)
  ##               : Cosmos DB keyspace name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574361 = newJObject()
  var query_574362 = newJObject()
  add(path_574361, "resourceGroupName", newJString(resourceGroupName))
  add(query_574362, "api-version", newJString(apiVersion))
  add(path_574361, "keyspaceName", newJString(keyspaceName))
  add(path_574361, "subscriptionId", newJString(subscriptionId))
  add(path_574361, "accountName", newJString(accountName))
  result = call_574360.call(path_574361, query_574362, nil, nil, nil)

var databaseAccountsListCassandraTables* = Call_DatabaseAccountsListCassandraTables_574351(
    name: "databaseAccountsListCassandraTables", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/tables",
    validator: validate_DatabaseAccountsListCassandraTables_574352, base: "",
    url: url_DatabaseAccountsListCassandraTables_574353, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateCassandraTable_574376 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsCreateUpdateCassandraTable_574378(protocol: Scheme;
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

proc validate_DatabaseAccountsCreateUpdateCassandraTable_574377(path: JsonNode;
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
  var valid_574379 = path.getOrDefault("resourceGroupName")
  valid_574379 = validateParameter(valid_574379, JString, required = true,
                                 default = nil)
  if valid_574379 != nil:
    section.add "resourceGroupName", valid_574379
  var valid_574380 = path.getOrDefault("keyspaceName")
  valid_574380 = validateParameter(valid_574380, JString, required = true,
                                 default = nil)
  if valid_574380 != nil:
    section.add "keyspaceName", valid_574380
  var valid_574381 = path.getOrDefault("subscriptionId")
  valid_574381 = validateParameter(valid_574381, JString, required = true,
                                 default = nil)
  if valid_574381 != nil:
    section.add "subscriptionId", valid_574381
  var valid_574382 = path.getOrDefault("tableName")
  valid_574382 = validateParameter(valid_574382, JString, required = true,
                                 default = nil)
  if valid_574382 != nil:
    section.add "tableName", valid_574382
  var valid_574383 = path.getOrDefault("accountName")
  valid_574383 = validateParameter(valid_574383, JString, required = true,
                                 default = nil)
  if valid_574383 != nil:
    section.add "accountName", valid_574383
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574384 = query.getOrDefault("api-version")
  valid_574384 = validateParameter(valid_574384, JString, required = true,
                                 default = nil)
  if valid_574384 != nil:
    section.add "api-version", valid_574384
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

proc call*(call_574386: Call_DatabaseAccountsCreateUpdateCassandraTable_574376;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB Cassandra Table
  ## 
  let valid = call_574386.validator(path, query, header, formData, body)
  let scheme = call_574386.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574386.url(scheme.get, call_574386.host, call_574386.base,
                         call_574386.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574386, url, valid)

proc call*(call_574387: Call_DatabaseAccountsCreateUpdateCassandraTable_574376;
          resourceGroupName: string; apiVersion: string; keyspaceName: string;
          subscriptionId: string; tableName: string;
          createUpdateCassandraTableParameters: JsonNode; accountName: string): Recallable =
  ## databaseAccountsCreateUpdateCassandraTable
  ## Create or update an Azure Cosmos DB Cassandra Table
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_574388 = newJObject()
  var query_574389 = newJObject()
  var body_574390 = newJObject()
  add(path_574388, "resourceGroupName", newJString(resourceGroupName))
  add(query_574389, "api-version", newJString(apiVersion))
  add(path_574388, "keyspaceName", newJString(keyspaceName))
  add(path_574388, "subscriptionId", newJString(subscriptionId))
  add(path_574388, "tableName", newJString(tableName))
  if createUpdateCassandraTableParameters != nil:
    body_574390 = createUpdateCassandraTableParameters
  add(path_574388, "accountName", newJString(accountName))
  result = call_574387.call(path_574388, query_574389, nil, nil, body_574390)

var databaseAccountsCreateUpdateCassandraTable* = Call_DatabaseAccountsCreateUpdateCassandraTable_574376(
    name: "databaseAccountsCreateUpdateCassandraTable", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/tables/{tableName}",
    validator: validate_DatabaseAccountsCreateUpdateCassandraTable_574377,
    base: "", url: url_DatabaseAccountsCreateUpdateCassandraTable_574378,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetCassandraTable_574363 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsGetCassandraTable_574365(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsGetCassandraTable_574364(path: JsonNode;
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
  var valid_574366 = path.getOrDefault("resourceGroupName")
  valid_574366 = validateParameter(valid_574366, JString, required = true,
                                 default = nil)
  if valid_574366 != nil:
    section.add "resourceGroupName", valid_574366
  var valid_574367 = path.getOrDefault("keyspaceName")
  valid_574367 = validateParameter(valid_574367, JString, required = true,
                                 default = nil)
  if valid_574367 != nil:
    section.add "keyspaceName", valid_574367
  var valid_574368 = path.getOrDefault("subscriptionId")
  valid_574368 = validateParameter(valid_574368, JString, required = true,
                                 default = nil)
  if valid_574368 != nil:
    section.add "subscriptionId", valid_574368
  var valid_574369 = path.getOrDefault("tableName")
  valid_574369 = validateParameter(valid_574369, JString, required = true,
                                 default = nil)
  if valid_574369 != nil:
    section.add "tableName", valid_574369
  var valid_574370 = path.getOrDefault("accountName")
  valid_574370 = validateParameter(valid_574370, JString, required = true,
                                 default = nil)
  if valid_574370 != nil:
    section.add "accountName", valid_574370
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574371 = query.getOrDefault("api-version")
  valid_574371 = validateParameter(valid_574371, JString, required = true,
                                 default = nil)
  if valid_574371 != nil:
    section.add "api-version", valid_574371
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574372: Call_DatabaseAccountsGetCassandraTable_574363;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the Cassandra table under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_574372.validator(path, query, header, formData, body)
  let scheme = call_574372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574372.url(scheme.get, call_574372.host, call_574372.base,
                         call_574372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574372, url, valid)

proc call*(call_574373: Call_DatabaseAccountsGetCassandraTable_574363;
          resourceGroupName: string; apiVersion: string; keyspaceName: string;
          subscriptionId: string; tableName: string; accountName: string): Recallable =
  ## databaseAccountsGetCassandraTable
  ## Gets the Cassandra table under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   keyspaceName: string (required)
  ##               : Cosmos DB keyspace name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574374 = newJObject()
  var query_574375 = newJObject()
  add(path_574374, "resourceGroupName", newJString(resourceGroupName))
  add(query_574375, "api-version", newJString(apiVersion))
  add(path_574374, "keyspaceName", newJString(keyspaceName))
  add(path_574374, "subscriptionId", newJString(subscriptionId))
  add(path_574374, "tableName", newJString(tableName))
  add(path_574374, "accountName", newJString(accountName))
  result = call_574373.call(path_574374, query_574375, nil, nil, nil)

var databaseAccountsGetCassandraTable* = Call_DatabaseAccountsGetCassandraTable_574363(
    name: "databaseAccountsGetCassandraTable", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/tables/{tableName}",
    validator: validate_DatabaseAccountsGetCassandraTable_574364, base: "",
    url: url_DatabaseAccountsGetCassandraTable_574365, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteCassandraTable_574391 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsDeleteCassandraTable_574393(protocol: Scheme;
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

proc validate_DatabaseAccountsDeleteCassandraTable_574392(path: JsonNode;
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  if body != nil:
    result.add "body", body

proc call*(call_574400: Call_DatabaseAccountsDeleteCassandraTable_574391;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB Cassandra table.
  ## 
  let valid = call_574400.validator(path, query, header, formData, body)
  let scheme = call_574400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574400.url(scheme.get, call_574400.host, call_574400.base,
                         call_574400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574400, url, valid)

proc call*(call_574401: Call_DatabaseAccountsDeleteCassandraTable_574391;
          resourceGroupName: string; apiVersion: string; keyspaceName: string;
          subscriptionId: string; tableName: string; accountName: string): Recallable =
  ## databaseAccountsDeleteCassandraTable
  ## Deletes an existing Azure Cosmos DB Cassandra table.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   keyspaceName: string (required)
  ##               : Cosmos DB keyspace name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574402 = newJObject()
  var query_574403 = newJObject()
  add(path_574402, "resourceGroupName", newJString(resourceGroupName))
  add(query_574403, "api-version", newJString(apiVersion))
  add(path_574402, "keyspaceName", newJString(keyspaceName))
  add(path_574402, "subscriptionId", newJString(subscriptionId))
  add(path_574402, "tableName", newJString(tableName))
  add(path_574402, "accountName", newJString(accountName))
  result = call_574401.call(path_574402, query_574403, nil, nil, nil)

var databaseAccountsDeleteCassandraTable* = Call_DatabaseAccountsDeleteCassandraTable_574391(
    name: "databaseAccountsDeleteCassandraTable", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/tables/{tableName}",
    validator: validate_DatabaseAccountsDeleteCassandraTable_574392, base: "",
    url: url_DatabaseAccountsDeleteCassandraTable_574393, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateCassandraTableThroughput_574417 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsUpdateCassandraTableThroughput_574419(protocol: Scheme;
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

proc validate_DatabaseAccountsUpdateCassandraTableThroughput_574418(
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
  var valid_574420 = path.getOrDefault("resourceGroupName")
  valid_574420 = validateParameter(valid_574420, JString, required = true,
                                 default = nil)
  if valid_574420 != nil:
    section.add "resourceGroupName", valid_574420
  var valid_574421 = path.getOrDefault("keyspaceName")
  valid_574421 = validateParameter(valid_574421, JString, required = true,
                                 default = nil)
  if valid_574421 != nil:
    section.add "keyspaceName", valid_574421
  var valid_574422 = path.getOrDefault("subscriptionId")
  valid_574422 = validateParameter(valid_574422, JString, required = true,
                                 default = nil)
  if valid_574422 != nil:
    section.add "subscriptionId", valid_574422
  var valid_574423 = path.getOrDefault("tableName")
  valid_574423 = validateParameter(valid_574423, JString, required = true,
                                 default = nil)
  if valid_574423 != nil:
    section.add "tableName", valid_574423
  var valid_574424 = path.getOrDefault("accountName")
  valid_574424 = validateParameter(valid_574424, JString, required = true,
                                 default = nil)
  if valid_574424 != nil:
    section.add "accountName", valid_574424
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  ##                             : The RUs per second of the parameters to provide for the current Cassandra table.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574427: Call_DatabaseAccountsUpdateCassandraTableThroughput_574417;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Cassandra table
  ## 
  let valid = call_574427.validator(path, query, header, formData, body)
  let scheme = call_574427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574427.url(scheme.get, call_574427.host, call_574427.base,
                         call_574427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574427, url, valid)

proc call*(call_574428: Call_DatabaseAccountsUpdateCassandraTableThroughput_574417;
          resourceGroupName: string; apiVersion: string; keyspaceName: string;
          subscriptionId: string; tableName: string;
          updateThroughputParameters: JsonNode; accountName: string): Recallable =
  ## databaseAccountsUpdateCassandraTableThroughput
  ## Update RUs per second of an Azure Cosmos DB Cassandra table
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_574429 = newJObject()
  var query_574430 = newJObject()
  var body_574431 = newJObject()
  add(path_574429, "resourceGroupName", newJString(resourceGroupName))
  add(query_574430, "api-version", newJString(apiVersion))
  add(path_574429, "keyspaceName", newJString(keyspaceName))
  add(path_574429, "subscriptionId", newJString(subscriptionId))
  add(path_574429, "tableName", newJString(tableName))
  if updateThroughputParameters != nil:
    body_574431 = updateThroughputParameters
  add(path_574429, "accountName", newJString(accountName))
  result = call_574428.call(path_574429, query_574430, nil, nil, body_574431)

var databaseAccountsUpdateCassandraTableThroughput* = Call_DatabaseAccountsUpdateCassandraTableThroughput_574417(
    name: "databaseAccountsUpdateCassandraTableThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/tables/{tableName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateCassandraTableThroughput_574418,
    base: "", url: url_DatabaseAccountsUpdateCassandraTableThroughput_574419,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetCassandraTableThroughput_574404 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsGetCassandraTableThroughput_574406(protocol: Scheme;
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

proc validate_DatabaseAccountsGetCassandraTableThroughput_574405(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_574407 = path.getOrDefault("resourceGroupName")
  valid_574407 = validateParameter(valid_574407, JString, required = true,
                                 default = nil)
  if valid_574407 != nil:
    section.add "resourceGroupName", valid_574407
  var valid_574408 = path.getOrDefault("keyspaceName")
  valid_574408 = validateParameter(valid_574408, JString, required = true,
                                 default = nil)
  if valid_574408 != nil:
    section.add "keyspaceName", valid_574408
  var valid_574409 = path.getOrDefault("subscriptionId")
  valid_574409 = validateParameter(valid_574409, JString, required = true,
                                 default = nil)
  if valid_574409 != nil:
    section.add "subscriptionId", valid_574409
  var valid_574410 = path.getOrDefault("tableName")
  valid_574410 = validateParameter(valid_574410, JString, required = true,
                                 default = nil)
  if valid_574410 != nil:
    section.add "tableName", valid_574410
  var valid_574411 = path.getOrDefault("accountName")
  valid_574411 = validateParameter(valid_574411, JString, required = true,
                                 default = nil)
  if valid_574411 != nil:
    section.add "accountName", valid_574411
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574412 = query.getOrDefault("api-version")
  valid_574412 = validateParameter(valid_574412, JString, required = true,
                                 default = nil)
  if valid_574412 != nil:
    section.add "api-version", valid_574412
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574413: Call_DatabaseAccountsGetCassandraTableThroughput_574404;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the Cassandra table under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_574413.validator(path, query, header, formData, body)
  let scheme = call_574413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574413.url(scheme.get, call_574413.host, call_574413.base,
                         call_574413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574413, url, valid)

proc call*(call_574414: Call_DatabaseAccountsGetCassandraTableThroughput_574404;
          resourceGroupName: string; apiVersion: string; keyspaceName: string;
          subscriptionId: string; tableName: string; accountName: string): Recallable =
  ## databaseAccountsGetCassandraTableThroughput
  ## Gets the RUs per second of the Cassandra table under an existing Azure Cosmos DB database account with the provided name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   keyspaceName: string (required)
  ##               : Cosmos DB keyspace name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574415 = newJObject()
  var query_574416 = newJObject()
  add(path_574415, "resourceGroupName", newJString(resourceGroupName))
  add(query_574416, "api-version", newJString(apiVersion))
  add(path_574415, "keyspaceName", newJString(keyspaceName))
  add(path_574415, "subscriptionId", newJString(subscriptionId))
  add(path_574415, "tableName", newJString(tableName))
  add(path_574415, "accountName", newJString(accountName))
  result = call_574414.call(path_574415, query_574416, nil, nil, nil)

var databaseAccountsGetCassandraTableThroughput* = Call_DatabaseAccountsGetCassandraTableThroughput_574404(
    name: "databaseAccountsGetCassandraTableThroughput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/tables/{tableName}/settings/throughput",
    validator: validate_DatabaseAccountsGetCassandraTableThroughput_574405,
    base: "", url: url_DatabaseAccountsGetCassandraTableThroughput_574406,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListGremlinDatabases_574432 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsListGremlinDatabases_574434(protocol: Scheme;
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

proc validate_DatabaseAccountsListGremlinDatabases_574433(path: JsonNode;
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
  var valid_574435 = path.getOrDefault("resourceGroupName")
  valid_574435 = validateParameter(valid_574435, JString, required = true,
                                 default = nil)
  if valid_574435 != nil:
    section.add "resourceGroupName", valid_574435
  var valid_574436 = path.getOrDefault("subscriptionId")
  valid_574436 = validateParameter(valid_574436, JString, required = true,
                                 default = nil)
  if valid_574436 != nil:
    section.add "subscriptionId", valid_574436
  var valid_574437 = path.getOrDefault("accountName")
  valid_574437 = validateParameter(valid_574437, JString, required = true,
                                 default = nil)
  if valid_574437 != nil:
    section.add "accountName", valid_574437
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574438 = query.getOrDefault("api-version")
  valid_574438 = validateParameter(valid_574438, JString, required = true,
                                 default = nil)
  if valid_574438 != nil:
    section.add "api-version", valid_574438
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574439: Call_DatabaseAccountsListGremlinDatabases_574432;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Gremlin databases under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_574439.validator(path, query, header, formData, body)
  let scheme = call_574439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574439.url(scheme.get, call_574439.host, call_574439.base,
                         call_574439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574439, url, valid)

proc call*(call_574440: Call_DatabaseAccountsListGremlinDatabases_574432;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## databaseAccountsListGremlinDatabases
  ## Lists the Gremlin databases under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574441 = newJObject()
  var query_574442 = newJObject()
  add(path_574441, "resourceGroupName", newJString(resourceGroupName))
  add(query_574442, "api-version", newJString(apiVersion))
  add(path_574441, "subscriptionId", newJString(subscriptionId))
  add(path_574441, "accountName", newJString(accountName))
  result = call_574440.call(path_574441, query_574442, nil, nil, nil)

var databaseAccountsListGremlinDatabases* = Call_DatabaseAccountsListGremlinDatabases_574432(
    name: "databaseAccountsListGremlinDatabases", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases",
    validator: validate_DatabaseAccountsListGremlinDatabases_574433, base: "",
    url: url_DatabaseAccountsListGremlinDatabases_574434, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateGremlinDatabase_574455 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsCreateUpdateGremlinDatabase_574457(protocol: Scheme;
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

proc validate_DatabaseAccountsCreateUpdateGremlinDatabase_574456(path: JsonNode;
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
  var valid_574458 = path.getOrDefault("resourceGroupName")
  valid_574458 = validateParameter(valid_574458, JString, required = true,
                                 default = nil)
  if valid_574458 != nil:
    section.add "resourceGroupName", valid_574458
  var valid_574459 = path.getOrDefault("subscriptionId")
  valid_574459 = validateParameter(valid_574459, JString, required = true,
                                 default = nil)
  if valid_574459 != nil:
    section.add "subscriptionId", valid_574459
  var valid_574460 = path.getOrDefault("databaseName")
  valid_574460 = validateParameter(valid_574460, JString, required = true,
                                 default = nil)
  if valid_574460 != nil:
    section.add "databaseName", valid_574460
  var valid_574461 = path.getOrDefault("accountName")
  valid_574461 = validateParameter(valid_574461, JString, required = true,
                                 default = nil)
  if valid_574461 != nil:
    section.add "accountName", valid_574461
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574462 = query.getOrDefault("api-version")
  valid_574462 = validateParameter(valid_574462, JString, required = true,
                                 default = nil)
  if valid_574462 != nil:
    section.add "api-version", valid_574462
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

proc call*(call_574464: Call_DatabaseAccountsCreateUpdateGremlinDatabase_574455;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB Gremlin database
  ## 
  let valid = call_574464.validator(path, query, header, formData, body)
  let scheme = call_574464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574464.url(scheme.get, call_574464.host, call_574464.base,
                         call_574464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574464, url, valid)

proc call*(call_574465: Call_DatabaseAccountsCreateUpdateGremlinDatabase_574455;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          createUpdateGremlinDatabaseParameters: JsonNode; databaseName: string;
          accountName: string): Recallable =
  ## databaseAccountsCreateUpdateGremlinDatabase
  ## Create or update an Azure Cosmos DB Gremlin database
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   createUpdateGremlinDatabaseParameters: JObject (required)
  ##                                        : The parameters to provide for the current Gremlin database.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574466 = newJObject()
  var query_574467 = newJObject()
  var body_574468 = newJObject()
  add(path_574466, "resourceGroupName", newJString(resourceGroupName))
  add(query_574467, "api-version", newJString(apiVersion))
  add(path_574466, "subscriptionId", newJString(subscriptionId))
  if createUpdateGremlinDatabaseParameters != nil:
    body_574468 = createUpdateGremlinDatabaseParameters
  add(path_574466, "databaseName", newJString(databaseName))
  add(path_574466, "accountName", newJString(accountName))
  result = call_574465.call(path_574466, query_574467, nil, nil, body_574468)

var databaseAccountsCreateUpdateGremlinDatabase* = Call_DatabaseAccountsCreateUpdateGremlinDatabase_574455(
    name: "databaseAccountsCreateUpdateGremlinDatabase", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}",
    validator: validate_DatabaseAccountsCreateUpdateGremlinDatabase_574456,
    base: "", url: url_DatabaseAccountsCreateUpdateGremlinDatabase_574457,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetGremlinDatabase_574443 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsGetGremlinDatabase_574445(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsGetGremlinDatabase_574444(path: JsonNode;
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
  var valid_574446 = path.getOrDefault("resourceGroupName")
  valid_574446 = validateParameter(valid_574446, JString, required = true,
                                 default = nil)
  if valid_574446 != nil:
    section.add "resourceGroupName", valid_574446
  var valid_574447 = path.getOrDefault("subscriptionId")
  valid_574447 = validateParameter(valid_574447, JString, required = true,
                                 default = nil)
  if valid_574447 != nil:
    section.add "subscriptionId", valid_574447
  var valid_574448 = path.getOrDefault("databaseName")
  valid_574448 = validateParameter(valid_574448, JString, required = true,
                                 default = nil)
  if valid_574448 != nil:
    section.add "databaseName", valid_574448
  var valid_574449 = path.getOrDefault("accountName")
  valid_574449 = validateParameter(valid_574449, JString, required = true,
                                 default = nil)
  if valid_574449 != nil:
    section.add "accountName", valid_574449
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574450 = query.getOrDefault("api-version")
  valid_574450 = validateParameter(valid_574450, JString, required = true,
                                 default = nil)
  if valid_574450 != nil:
    section.add "api-version", valid_574450
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574451: Call_DatabaseAccountsGetGremlinDatabase_574443;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the Gremlin databases under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_574451.validator(path, query, header, formData, body)
  let scheme = call_574451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574451.url(scheme.get, call_574451.host, call_574451.base,
                         call_574451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574451, url, valid)

proc call*(call_574452: Call_DatabaseAccountsGetGremlinDatabase_574443;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; accountName: string): Recallable =
  ## databaseAccountsGetGremlinDatabase
  ## Gets the Gremlin databases under an existing Azure Cosmos DB database account with the provided name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574453 = newJObject()
  var query_574454 = newJObject()
  add(path_574453, "resourceGroupName", newJString(resourceGroupName))
  add(query_574454, "api-version", newJString(apiVersion))
  add(path_574453, "subscriptionId", newJString(subscriptionId))
  add(path_574453, "databaseName", newJString(databaseName))
  add(path_574453, "accountName", newJString(accountName))
  result = call_574452.call(path_574453, query_574454, nil, nil, nil)

var databaseAccountsGetGremlinDatabase* = Call_DatabaseAccountsGetGremlinDatabase_574443(
    name: "databaseAccountsGetGremlinDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}",
    validator: validate_DatabaseAccountsGetGremlinDatabase_574444, base: "",
    url: url_DatabaseAccountsGetGremlinDatabase_574445, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteGremlinDatabase_574469 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsDeleteGremlinDatabase_574471(protocol: Scheme;
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

proc validate_DatabaseAccountsDeleteGremlinDatabase_574470(path: JsonNode;
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
  var valid_574472 = path.getOrDefault("resourceGroupName")
  valid_574472 = validateParameter(valid_574472, JString, required = true,
                                 default = nil)
  if valid_574472 != nil:
    section.add "resourceGroupName", valid_574472
  var valid_574473 = path.getOrDefault("subscriptionId")
  valid_574473 = validateParameter(valid_574473, JString, required = true,
                                 default = nil)
  if valid_574473 != nil:
    section.add "subscriptionId", valid_574473
  var valid_574474 = path.getOrDefault("databaseName")
  valid_574474 = validateParameter(valid_574474, JString, required = true,
                                 default = nil)
  if valid_574474 != nil:
    section.add "databaseName", valid_574474
  var valid_574475 = path.getOrDefault("accountName")
  valid_574475 = validateParameter(valid_574475, JString, required = true,
                                 default = nil)
  if valid_574475 != nil:
    section.add "accountName", valid_574475
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574476 = query.getOrDefault("api-version")
  valid_574476 = validateParameter(valid_574476, JString, required = true,
                                 default = nil)
  if valid_574476 != nil:
    section.add "api-version", valid_574476
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574477: Call_DatabaseAccountsDeleteGremlinDatabase_574469;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB Gremlin database.
  ## 
  let valid = call_574477.validator(path, query, header, formData, body)
  let scheme = call_574477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574477.url(scheme.get, call_574477.host, call_574477.base,
                         call_574477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574477, url, valid)

proc call*(call_574478: Call_DatabaseAccountsDeleteGremlinDatabase_574469;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; accountName: string): Recallable =
  ## databaseAccountsDeleteGremlinDatabase
  ## Deletes an existing Azure Cosmos DB Gremlin database.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574479 = newJObject()
  var query_574480 = newJObject()
  add(path_574479, "resourceGroupName", newJString(resourceGroupName))
  add(query_574480, "api-version", newJString(apiVersion))
  add(path_574479, "subscriptionId", newJString(subscriptionId))
  add(path_574479, "databaseName", newJString(databaseName))
  add(path_574479, "accountName", newJString(accountName))
  result = call_574478.call(path_574479, query_574480, nil, nil, nil)

var databaseAccountsDeleteGremlinDatabase* = Call_DatabaseAccountsDeleteGremlinDatabase_574469(
    name: "databaseAccountsDeleteGremlinDatabase", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}",
    validator: validate_DatabaseAccountsDeleteGremlinDatabase_574470, base: "",
    url: url_DatabaseAccountsDeleteGremlinDatabase_574471, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListGremlinGraphs_574481 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsListGremlinGraphs_574483(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListGremlinGraphs_574482(path: JsonNode;
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
  var valid_574484 = path.getOrDefault("resourceGroupName")
  valid_574484 = validateParameter(valid_574484, JString, required = true,
                                 default = nil)
  if valid_574484 != nil:
    section.add "resourceGroupName", valid_574484
  var valid_574485 = path.getOrDefault("subscriptionId")
  valid_574485 = validateParameter(valid_574485, JString, required = true,
                                 default = nil)
  if valid_574485 != nil:
    section.add "subscriptionId", valid_574485
  var valid_574486 = path.getOrDefault("databaseName")
  valid_574486 = validateParameter(valid_574486, JString, required = true,
                                 default = nil)
  if valid_574486 != nil:
    section.add "databaseName", valid_574486
  var valid_574487 = path.getOrDefault("accountName")
  valid_574487 = validateParameter(valid_574487, JString, required = true,
                                 default = nil)
  if valid_574487 != nil:
    section.add "accountName", valid_574487
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574488 = query.getOrDefault("api-version")
  valid_574488 = validateParameter(valid_574488, JString, required = true,
                                 default = nil)
  if valid_574488 != nil:
    section.add "api-version", valid_574488
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574489: Call_DatabaseAccountsListGremlinGraphs_574481;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Gremlin graph under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_574489.validator(path, query, header, formData, body)
  let scheme = call_574489.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574489.url(scheme.get, call_574489.host, call_574489.base,
                         call_574489.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574489, url, valid)

proc call*(call_574490: Call_DatabaseAccountsListGremlinGraphs_574481;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; accountName: string): Recallable =
  ## databaseAccountsListGremlinGraphs
  ## Lists the Gremlin graph under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574491 = newJObject()
  var query_574492 = newJObject()
  add(path_574491, "resourceGroupName", newJString(resourceGroupName))
  add(query_574492, "api-version", newJString(apiVersion))
  add(path_574491, "subscriptionId", newJString(subscriptionId))
  add(path_574491, "databaseName", newJString(databaseName))
  add(path_574491, "accountName", newJString(accountName))
  result = call_574490.call(path_574491, query_574492, nil, nil, nil)

var databaseAccountsListGremlinGraphs* = Call_DatabaseAccountsListGremlinGraphs_574481(
    name: "databaseAccountsListGremlinGraphs", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/graphs",
    validator: validate_DatabaseAccountsListGremlinGraphs_574482, base: "",
    url: url_DatabaseAccountsListGremlinGraphs_574483, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateGremlinGraph_574506 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsCreateUpdateGremlinGraph_574508(protocol: Scheme;
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

proc validate_DatabaseAccountsCreateUpdateGremlinGraph_574507(path: JsonNode;
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
  var valid_574509 = path.getOrDefault("resourceGroupName")
  valid_574509 = validateParameter(valid_574509, JString, required = true,
                                 default = nil)
  if valid_574509 != nil:
    section.add "resourceGroupName", valid_574509
  var valid_574510 = path.getOrDefault("subscriptionId")
  valid_574510 = validateParameter(valid_574510, JString, required = true,
                                 default = nil)
  if valid_574510 != nil:
    section.add "subscriptionId", valid_574510
  var valid_574511 = path.getOrDefault("databaseName")
  valid_574511 = validateParameter(valid_574511, JString, required = true,
                                 default = nil)
  if valid_574511 != nil:
    section.add "databaseName", valid_574511
  var valid_574512 = path.getOrDefault("graphName")
  valid_574512 = validateParameter(valid_574512, JString, required = true,
                                 default = nil)
  if valid_574512 != nil:
    section.add "graphName", valid_574512
  var valid_574513 = path.getOrDefault("accountName")
  valid_574513 = validateParameter(valid_574513, JString, required = true,
                                 default = nil)
  if valid_574513 != nil:
    section.add "accountName", valid_574513
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574514 = query.getOrDefault("api-version")
  valid_574514 = validateParameter(valid_574514, JString, required = true,
                                 default = nil)
  if valid_574514 != nil:
    section.add "api-version", valid_574514
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

proc call*(call_574516: Call_DatabaseAccountsCreateUpdateGremlinGraph_574506;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB Gremlin graph
  ## 
  let valid = call_574516.validator(path, query, header, formData, body)
  let scheme = call_574516.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574516.url(scheme.get, call_574516.host, call_574516.base,
                         call_574516.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574516, url, valid)

proc call*(call_574517: Call_DatabaseAccountsCreateUpdateGremlinGraph_574506;
          resourceGroupName: string; apiVersion: string;
          createUpdateGremlinGraphParameters: JsonNode; subscriptionId: string;
          databaseName: string; graphName: string; accountName: string): Recallable =
  ## databaseAccountsCreateUpdateGremlinGraph
  ## Create or update an Azure Cosmos DB Gremlin graph
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_574518 = newJObject()
  var query_574519 = newJObject()
  var body_574520 = newJObject()
  add(path_574518, "resourceGroupName", newJString(resourceGroupName))
  add(query_574519, "api-version", newJString(apiVersion))
  if createUpdateGremlinGraphParameters != nil:
    body_574520 = createUpdateGremlinGraphParameters
  add(path_574518, "subscriptionId", newJString(subscriptionId))
  add(path_574518, "databaseName", newJString(databaseName))
  add(path_574518, "graphName", newJString(graphName))
  add(path_574518, "accountName", newJString(accountName))
  result = call_574517.call(path_574518, query_574519, nil, nil, body_574520)

var databaseAccountsCreateUpdateGremlinGraph* = Call_DatabaseAccountsCreateUpdateGremlinGraph_574506(
    name: "databaseAccountsCreateUpdateGremlinGraph", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/graphs/{graphName}",
    validator: validate_DatabaseAccountsCreateUpdateGremlinGraph_574507, base: "",
    url: url_DatabaseAccountsCreateUpdateGremlinGraph_574508,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetGremlinGraph_574493 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsGetGremlinGraph_574495(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsGetGremlinGraph_574494(path: JsonNode;
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
  var valid_574496 = path.getOrDefault("resourceGroupName")
  valid_574496 = validateParameter(valid_574496, JString, required = true,
                                 default = nil)
  if valid_574496 != nil:
    section.add "resourceGroupName", valid_574496
  var valid_574497 = path.getOrDefault("subscriptionId")
  valid_574497 = validateParameter(valid_574497, JString, required = true,
                                 default = nil)
  if valid_574497 != nil:
    section.add "subscriptionId", valid_574497
  var valid_574498 = path.getOrDefault("databaseName")
  valid_574498 = validateParameter(valid_574498, JString, required = true,
                                 default = nil)
  if valid_574498 != nil:
    section.add "databaseName", valid_574498
  var valid_574499 = path.getOrDefault("graphName")
  valid_574499 = validateParameter(valid_574499, JString, required = true,
                                 default = nil)
  if valid_574499 != nil:
    section.add "graphName", valid_574499
  var valid_574500 = path.getOrDefault("accountName")
  valid_574500 = validateParameter(valid_574500, JString, required = true,
                                 default = nil)
  if valid_574500 != nil:
    section.add "accountName", valid_574500
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574501 = query.getOrDefault("api-version")
  valid_574501 = validateParameter(valid_574501, JString, required = true,
                                 default = nil)
  if valid_574501 != nil:
    section.add "api-version", valid_574501
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574502: Call_DatabaseAccountsGetGremlinGraph_574493;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the Gremlin graph under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_574502.validator(path, query, header, formData, body)
  let scheme = call_574502.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574502.url(scheme.get, call_574502.host, call_574502.base,
                         call_574502.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574502, url, valid)

proc call*(call_574503: Call_DatabaseAccountsGetGremlinGraph_574493;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; graphName: string; accountName: string): Recallable =
  ## databaseAccountsGetGremlinGraph
  ## Gets the Gremlin graph under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   graphName: string (required)
  ##            : Cosmos DB graph name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574504 = newJObject()
  var query_574505 = newJObject()
  add(path_574504, "resourceGroupName", newJString(resourceGroupName))
  add(query_574505, "api-version", newJString(apiVersion))
  add(path_574504, "subscriptionId", newJString(subscriptionId))
  add(path_574504, "databaseName", newJString(databaseName))
  add(path_574504, "graphName", newJString(graphName))
  add(path_574504, "accountName", newJString(accountName))
  result = call_574503.call(path_574504, query_574505, nil, nil, nil)

var databaseAccountsGetGremlinGraph* = Call_DatabaseAccountsGetGremlinGraph_574493(
    name: "databaseAccountsGetGremlinGraph", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/graphs/{graphName}",
    validator: validate_DatabaseAccountsGetGremlinGraph_574494, base: "",
    url: url_DatabaseAccountsGetGremlinGraph_574495, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteGremlinGraph_574521 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsDeleteGremlinGraph_574523(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsDeleteGremlinGraph_574522(path: JsonNode;
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
  var valid_574524 = path.getOrDefault("resourceGroupName")
  valid_574524 = validateParameter(valid_574524, JString, required = true,
                                 default = nil)
  if valid_574524 != nil:
    section.add "resourceGroupName", valid_574524
  var valid_574525 = path.getOrDefault("subscriptionId")
  valid_574525 = validateParameter(valid_574525, JString, required = true,
                                 default = nil)
  if valid_574525 != nil:
    section.add "subscriptionId", valid_574525
  var valid_574526 = path.getOrDefault("databaseName")
  valid_574526 = validateParameter(valid_574526, JString, required = true,
                                 default = nil)
  if valid_574526 != nil:
    section.add "databaseName", valid_574526
  var valid_574527 = path.getOrDefault("graphName")
  valid_574527 = validateParameter(valid_574527, JString, required = true,
                                 default = nil)
  if valid_574527 != nil:
    section.add "graphName", valid_574527
  var valid_574528 = path.getOrDefault("accountName")
  valid_574528 = validateParameter(valid_574528, JString, required = true,
                                 default = nil)
  if valid_574528 != nil:
    section.add "accountName", valid_574528
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574529 = query.getOrDefault("api-version")
  valid_574529 = validateParameter(valid_574529, JString, required = true,
                                 default = nil)
  if valid_574529 != nil:
    section.add "api-version", valid_574529
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574530: Call_DatabaseAccountsDeleteGremlinGraph_574521;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB Gremlin graph.
  ## 
  let valid = call_574530.validator(path, query, header, formData, body)
  let scheme = call_574530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574530.url(scheme.get, call_574530.host, call_574530.base,
                         call_574530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574530, url, valid)

proc call*(call_574531: Call_DatabaseAccountsDeleteGremlinGraph_574521;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; graphName: string; accountName: string): Recallable =
  ## databaseAccountsDeleteGremlinGraph
  ## Deletes an existing Azure Cosmos DB Gremlin graph.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   graphName: string (required)
  ##            : Cosmos DB graph name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574532 = newJObject()
  var query_574533 = newJObject()
  add(path_574532, "resourceGroupName", newJString(resourceGroupName))
  add(query_574533, "api-version", newJString(apiVersion))
  add(path_574532, "subscriptionId", newJString(subscriptionId))
  add(path_574532, "databaseName", newJString(databaseName))
  add(path_574532, "graphName", newJString(graphName))
  add(path_574532, "accountName", newJString(accountName))
  result = call_574531.call(path_574532, query_574533, nil, nil, nil)

var databaseAccountsDeleteGremlinGraph* = Call_DatabaseAccountsDeleteGremlinGraph_574521(
    name: "databaseAccountsDeleteGremlinGraph", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/graphs/{graphName}",
    validator: validate_DatabaseAccountsDeleteGremlinGraph_574522, base: "",
    url: url_DatabaseAccountsDeleteGremlinGraph_574523, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateGremlinGraphThroughput_574547 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsUpdateGremlinGraphThroughput_574549(protocol: Scheme;
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

proc validate_DatabaseAccountsUpdateGremlinGraphThroughput_574548(path: JsonNode;
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
  var valid_574550 = path.getOrDefault("resourceGroupName")
  valid_574550 = validateParameter(valid_574550, JString, required = true,
                                 default = nil)
  if valid_574550 != nil:
    section.add "resourceGroupName", valid_574550
  var valid_574551 = path.getOrDefault("subscriptionId")
  valid_574551 = validateParameter(valid_574551, JString, required = true,
                                 default = nil)
  if valid_574551 != nil:
    section.add "subscriptionId", valid_574551
  var valid_574552 = path.getOrDefault("databaseName")
  valid_574552 = validateParameter(valid_574552, JString, required = true,
                                 default = nil)
  if valid_574552 != nil:
    section.add "databaseName", valid_574552
  var valid_574553 = path.getOrDefault("graphName")
  valid_574553 = validateParameter(valid_574553, JString, required = true,
                                 default = nil)
  if valid_574553 != nil:
    section.add "graphName", valid_574553
  var valid_574554 = path.getOrDefault("accountName")
  valid_574554 = validateParameter(valid_574554, JString, required = true,
                                 default = nil)
  if valid_574554 != nil:
    section.add "accountName", valid_574554
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574555 = query.getOrDefault("api-version")
  valid_574555 = validateParameter(valid_574555, JString, required = true,
                                 default = nil)
  if valid_574555 != nil:
    section.add "api-version", valid_574555
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

proc call*(call_574557: Call_DatabaseAccountsUpdateGremlinGraphThroughput_574547;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Gremlin graph
  ## 
  let valid = call_574557.validator(path, query, header, formData, body)
  let scheme = call_574557.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574557.url(scheme.get, call_574557.host, call_574557.base,
                         call_574557.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574557, url, valid)

proc call*(call_574558: Call_DatabaseAccountsUpdateGremlinGraphThroughput_574547;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; updateThroughputParameters: JsonNode;
          graphName: string; accountName: string): Recallable =
  ## databaseAccountsUpdateGremlinGraphThroughput
  ## Update RUs per second of an Azure Cosmos DB Gremlin graph
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_574559 = newJObject()
  var query_574560 = newJObject()
  var body_574561 = newJObject()
  add(path_574559, "resourceGroupName", newJString(resourceGroupName))
  add(query_574560, "api-version", newJString(apiVersion))
  add(path_574559, "subscriptionId", newJString(subscriptionId))
  add(path_574559, "databaseName", newJString(databaseName))
  if updateThroughputParameters != nil:
    body_574561 = updateThroughputParameters
  add(path_574559, "graphName", newJString(graphName))
  add(path_574559, "accountName", newJString(accountName))
  result = call_574558.call(path_574559, query_574560, nil, nil, body_574561)

var databaseAccountsUpdateGremlinGraphThroughput* = Call_DatabaseAccountsUpdateGremlinGraphThroughput_574547(
    name: "databaseAccountsUpdateGremlinGraphThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/graphs/{graphName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateGremlinGraphThroughput_574548,
    base: "", url: url_DatabaseAccountsUpdateGremlinGraphThroughput_574549,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetGremlinGraphThroughput_574534 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsGetGremlinGraphThroughput_574536(protocol: Scheme;
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

proc validate_DatabaseAccountsGetGremlinGraphThroughput_574535(path: JsonNode;
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
  var valid_574537 = path.getOrDefault("resourceGroupName")
  valid_574537 = validateParameter(valid_574537, JString, required = true,
                                 default = nil)
  if valid_574537 != nil:
    section.add "resourceGroupName", valid_574537
  var valid_574538 = path.getOrDefault("subscriptionId")
  valid_574538 = validateParameter(valid_574538, JString, required = true,
                                 default = nil)
  if valid_574538 != nil:
    section.add "subscriptionId", valid_574538
  var valid_574539 = path.getOrDefault("databaseName")
  valid_574539 = validateParameter(valid_574539, JString, required = true,
                                 default = nil)
  if valid_574539 != nil:
    section.add "databaseName", valid_574539
  var valid_574540 = path.getOrDefault("graphName")
  valid_574540 = validateParameter(valid_574540, JString, required = true,
                                 default = nil)
  if valid_574540 != nil:
    section.add "graphName", valid_574540
  var valid_574541 = path.getOrDefault("accountName")
  valid_574541 = validateParameter(valid_574541, JString, required = true,
                                 default = nil)
  if valid_574541 != nil:
    section.add "accountName", valid_574541
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574542 = query.getOrDefault("api-version")
  valid_574542 = validateParameter(valid_574542, JString, required = true,
                                 default = nil)
  if valid_574542 != nil:
    section.add "api-version", valid_574542
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574543: Call_DatabaseAccountsGetGremlinGraphThroughput_574534;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the Gremlin graph throughput under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_574543.validator(path, query, header, formData, body)
  let scheme = call_574543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574543.url(scheme.get, call_574543.host, call_574543.base,
                         call_574543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574543, url, valid)

proc call*(call_574544: Call_DatabaseAccountsGetGremlinGraphThroughput_574534;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; graphName: string; accountName: string): Recallable =
  ## databaseAccountsGetGremlinGraphThroughput
  ## Gets the Gremlin graph throughput under an existing Azure Cosmos DB database account with the provided name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   graphName: string (required)
  ##            : Cosmos DB graph name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574545 = newJObject()
  var query_574546 = newJObject()
  add(path_574545, "resourceGroupName", newJString(resourceGroupName))
  add(query_574546, "api-version", newJString(apiVersion))
  add(path_574545, "subscriptionId", newJString(subscriptionId))
  add(path_574545, "databaseName", newJString(databaseName))
  add(path_574545, "graphName", newJString(graphName))
  add(path_574545, "accountName", newJString(accountName))
  result = call_574544.call(path_574545, query_574546, nil, nil, nil)

var databaseAccountsGetGremlinGraphThroughput* = Call_DatabaseAccountsGetGremlinGraphThroughput_574534(
    name: "databaseAccountsGetGremlinGraphThroughput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/graphs/{graphName}/settings/throughput",
    validator: validate_DatabaseAccountsGetGremlinGraphThroughput_574535,
    base: "", url: url_DatabaseAccountsGetGremlinGraphThroughput_574536,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateGremlinDatabaseThroughput_574574 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsUpdateGremlinDatabaseThroughput_574576(protocol: Scheme;
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

proc validate_DatabaseAccountsUpdateGremlinDatabaseThroughput_574575(
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
  var valid_574577 = path.getOrDefault("resourceGroupName")
  valid_574577 = validateParameter(valid_574577, JString, required = true,
                                 default = nil)
  if valid_574577 != nil:
    section.add "resourceGroupName", valid_574577
  var valid_574578 = path.getOrDefault("subscriptionId")
  valid_574578 = validateParameter(valid_574578, JString, required = true,
                                 default = nil)
  if valid_574578 != nil:
    section.add "subscriptionId", valid_574578
  var valid_574579 = path.getOrDefault("databaseName")
  valid_574579 = validateParameter(valid_574579, JString, required = true,
                                 default = nil)
  if valid_574579 != nil:
    section.add "databaseName", valid_574579
  var valid_574580 = path.getOrDefault("accountName")
  valid_574580 = validateParameter(valid_574580, JString, required = true,
                                 default = nil)
  if valid_574580 != nil:
    section.add "accountName", valid_574580
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574581 = query.getOrDefault("api-version")
  valid_574581 = validateParameter(valid_574581, JString, required = true,
                                 default = nil)
  if valid_574581 != nil:
    section.add "api-version", valid_574581
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

proc call*(call_574583: Call_DatabaseAccountsUpdateGremlinDatabaseThroughput_574574;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Gremlin database
  ## 
  let valid = call_574583.validator(path, query, header, formData, body)
  let scheme = call_574583.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574583.url(scheme.get, call_574583.host, call_574583.base,
                         call_574583.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574583, url, valid)

proc call*(call_574584: Call_DatabaseAccountsUpdateGremlinDatabaseThroughput_574574;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; updateThroughputParameters: JsonNode;
          accountName: string): Recallable =
  ## databaseAccountsUpdateGremlinDatabaseThroughput
  ## Update RUs per second of an Azure Cosmos DB Gremlin database
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   updateThroughputParameters: JObject (required)
  ##                             : The RUs per second of the parameters to provide for the current Gremlin database.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574585 = newJObject()
  var query_574586 = newJObject()
  var body_574587 = newJObject()
  add(path_574585, "resourceGroupName", newJString(resourceGroupName))
  add(query_574586, "api-version", newJString(apiVersion))
  add(path_574585, "subscriptionId", newJString(subscriptionId))
  add(path_574585, "databaseName", newJString(databaseName))
  if updateThroughputParameters != nil:
    body_574587 = updateThroughputParameters
  add(path_574585, "accountName", newJString(accountName))
  result = call_574584.call(path_574585, query_574586, nil, nil, body_574587)

var databaseAccountsUpdateGremlinDatabaseThroughput* = Call_DatabaseAccountsUpdateGremlinDatabaseThroughput_574574(
    name: "databaseAccountsUpdateGremlinDatabaseThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateGremlinDatabaseThroughput_574575,
    base: "", url: url_DatabaseAccountsUpdateGremlinDatabaseThroughput_574576,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetGremlinDatabaseThroughput_574562 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsGetGremlinDatabaseThroughput_574564(protocol: Scheme;
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

proc validate_DatabaseAccountsGetGremlinDatabaseThroughput_574563(path: JsonNode;
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
  var valid_574565 = path.getOrDefault("resourceGroupName")
  valid_574565 = validateParameter(valid_574565, JString, required = true,
                                 default = nil)
  if valid_574565 != nil:
    section.add "resourceGroupName", valid_574565
  var valid_574566 = path.getOrDefault("subscriptionId")
  valid_574566 = validateParameter(valid_574566, JString, required = true,
                                 default = nil)
  if valid_574566 != nil:
    section.add "subscriptionId", valid_574566
  var valid_574567 = path.getOrDefault("databaseName")
  valid_574567 = validateParameter(valid_574567, JString, required = true,
                                 default = nil)
  if valid_574567 != nil:
    section.add "databaseName", valid_574567
  var valid_574568 = path.getOrDefault("accountName")
  valid_574568 = validateParameter(valid_574568, JString, required = true,
                                 default = nil)
  if valid_574568 != nil:
    section.add "accountName", valid_574568
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574569 = query.getOrDefault("api-version")
  valid_574569 = validateParameter(valid_574569, JString, required = true,
                                 default = nil)
  if valid_574569 != nil:
    section.add "api-version", valid_574569
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574570: Call_DatabaseAccountsGetGremlinDatabaseThroughput_574562;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the Gremlin database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_574570.validator(path, query, header, formData, body)
  let scheme = call_574570.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574570.url(scheme.get, call_574570.host, call_574570.base,
                         call_574570.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574570, url, valid)

proc call*(call_574571: Call_DatabaseAccountsGetGremlinDatabaseThroughput_574562;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; accountName: string): Recallable =
  ## databaseAccountsGetGremlinDatabaseThroughput
  ## Gets the RUs per second of the Gremlin database under an existing Azure Cosmos DB database account with the provided name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574572 = newJObject()
  var query_574573 = newJObject()
  add(path_574572, "resourceGroupName", newJString(resourceGroupName))
  add(query_574573, "api-version", newJString(apiVersion))
  add(path_574572, "subscriptionId", newJString(subscriptionId))
  add(path_574572, "databaseName", newJString(databaseName))
  add(path_574572, "accountName", newJString(accountName))
  result = call_574571.call(path_574572, query_574573, nil, nil, nil)

var databaseAccountsGetGremlinDatabaseThroughput* = Call_DatabaseAccountsGetGremlinDatabaseThroughput_574562(
    name: "databaseAccountsGetGremlinDatabaseThroughput",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/settings/throughput",
    validator: validate_DatabaseAccountsGetGremlinDatabaseThroughput_574563,
    base: "", url: url_DatabaseAccountsGetGremlinDatabaseThroughput_574564,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListMongoDBDatabases_574588 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsListMongoDBDatabases_574590(protocol: Scheme;
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

proc validate_DatabaseAccountsListMongoDBDatabases_574589(path: JsonNode;
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
  var valid_574591 = path.getOrDefault("resourceGroupName")
  valid_574591 = validateParameter(valid_574591, JString, required = true,
                                 default = nil)
  if valid_574591 != nil:
    section.add "resourceGroupName", valid_574591
  var valid_574592 = path.getOrDefault("subscriptionId")
  valid_574592 = validateParameter(valid_574592, JString, required = true,
                                 default = nil)
  if valid_574592 != nil:
    section.add "subscriptionId", valid_574592
  var valid_574593 = path.getOrDefault("accountName")
  valid_574593 = validateParameter(valid_574593, JString, required = true,
                                 default = nil)
  if valid_574593 != nil:
    section.add "accountName", valid_574593
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574594 = query.getOrDefault("api-version")
  valid_574594 = validateParameter(valid_574594, JString, required = true,
                                 default = nil)
  if valid_574594 != nil:
    section.add "api-version", valid_574594
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574595: Call_DatabaseAccountsListMongoDBDatabases_574588;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the MongoDB databases under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_574595.validator(path, query, header, formData, body)
  let scheme = call_574595.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574595.url(scheme.get, call_574595.host, call_574595.base,
                         call_574595.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574595, url, valid)

proc call*(call_574596: Call_DatabaseAccountsListMongoDBDatabases_574588;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## databaseAccountsListMongoDBDatabases
  ## Lists the MongoDB databases under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574597 = newJObject()
  var query_574598 = newJObject()
  add(path_574597, "resourceGroupName", newJString(resourceGroupName))
  add(query_574598, "api-version", newJString(apiVersion))
  add(path_574597, "subscriptionId", newJString(subscriptionId))
  add(path_574597, "accountName", newJString(accountName))
  result = call_574596.call(path_574597, query_574598, nil, nil, nil)

var databaseAccountsListMongoDBDatabases* = Call_DatabaseAccountsListMongoDBDatabases_574588(
    name: "databaseAccountsListMongoDBDatabases", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases",
    validator: validate_DatabaseAccountsListMongoDBDatabases_574589, base: "",
    url: url_DatabaseAccountsListMongoDBDatabases_574590, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateMongoDBDatabase_574611 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsCreateUpdateMongoDBDatabase_574613(protocol: Scheme;
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

proc validate_DatabaseAccountsCreateUpdateMongoDBDatabase_574612(path: JsonNode;
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
  var valid_574614 = path.getOrDefault("resourceGroupName")
  valid_574614 = validateParameter(valid_574614, JString, required = true,
                                 default = nil)
  if valid_574614 != nil:
    section.add "resourceGroupName", valid_574614
  var valid_574615 = path.getOrDefault("subscriptionId")
  valid_574615 = validateParameter(valid_574615, JString, required = true,
                                 default = nil)
  if valid_574615 != nil:
    section.add "subscriptionId", valid_574615
  var valid_574616 = path.getOrDefault("databaseName")
  valid_574616 = validateParameter(valid_574616, JString, required = true,
                                 default = nil)
  if valid_574616 != nil:
    section.add "databaseName", valid_574616
  var valid_574617 = path.getOrDefault("accountName")
  valid_574617 = validateParameter(valid_574617, JString, required = true,
                                 default = nil)
  if valid_574617 != nil:
    section.add "accountName", valid_574617
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574618 = query.getOrDefault("api-version")
  valid_574618 = validateParameter(valid_574618, JString, required = true,
                                 default = nil)
  if valid_574618 != nil:
    section.add "api-version", valid_574618
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

proc call*(call_574620: Call_DatabaseAccountsCreateUpdateMongoDBDatabase_574611;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or updates Azure Cosmos DB MongoDB database
  ## 
  let valid = call_574620.validator(path, query, header, formData, body)
  let scheme = call_574620.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574620.url(scheme.get, call_574620.host, call_574620.base,
                         call_574620.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574620, url, valid)

proc call*(call_574621: Call_DatabaseAccountsCreateUpdateMongoDBDatabase_574611;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; createUpdateMongoDBDatabaseParameters: JsonNode;
          accountName: string): Recallable =
  ## databaseAccountsCreateUpdateMongoDBDatabase
  ## Create or updates Azure Cosmos DB MongoDB database
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   createUpdateMongoDBDatabaseParameters: JObject (required)
  ##                                        : The parameters to provide for the current MongoDB database.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574622 = newJObject()
  var query_574623 = newJObject()
  var body_574624 = newJObject()
  add(path_574622, "resourceGroupName", newJString(resourceGroupName))
  add(query_574623, "api-version", newJString(apiVersion))
  add(path_574622, "subscriptionId", newJString(subscriptionId))
  add(path_574622, "databaseName", newJString(databaseName))
  if createUpdateMongoDBDatabaseParameters != nil:
    body_574624 = createUpdateMongoDBDatabaseParameters
  add(path_574622, "accountName", newJString(accountName))
  result = call_574621.call(path_574622, query_574623, nil, nil, body_574624)

var databaseAccountsCreateUpdateMongoDBDatabase* = Call_DatabaseAccountsCreateUpdateMongoDBDatabase_574611(
    name: "databaseAccountsCreateUpdateMongoDBDatabase", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}",
    validator: validate_DatabaseAccountsCreateUpdateMongoDBDatabase_574612,
    base: "", url: url_DatabaseAccountsCreateUpdateMongoDBDatabase_574613,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetMongoDBDatabase_574599 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsGetMongoDBDatabase_574601(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsGetMongoDBDatabase_574600(path: JsonNode;
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
  var valid_574602 = path.getOrDefault("resourceGroupName")
  valid_574602 = validateParameter(valid_574602, JString, required = true,
                                 default = nil)
  if valid_574602 != nil:
    section.add "resourceGroupName", valid_574602
  var valid_574603 = path.getOrDefault("subscriptionId")
  valid_574603 = validateParameter(valid_574603, JString, required = true,
                                 default = nil)
  if valid_574603 != nil:
    section.add "subscriptionId", valid_574603
  var valid_574604 = path.getOrDefault("databaseName")
  valid_574604 = validateParameter(valid_574604, JString, required = true,
                                 default = nil)
  if valid_574604 != nil:
    section.add "databaseName", valid_574604
  var valid_574605 = path.getOrDefault("accountName")
  valid_574605 = validateParameter(valid_574605, JString, required = true,
                                 default = nil)
  if valid_574605 != nil:
    section.add "accountName", valid_574605
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574606 = query.getOrDefault("api-version")
  valid_574606 = validateParameter(valid_574606, JString, required = true,
                                 default = nil)
  if valid_574606 != nil:
    section.add "api-version", valid_574606
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574607: Call_DatabaseAccountsGetMongoDBDatabase_574599;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the MongoDB databases under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_574607.validator(path, query, header, formData, body)
  let scheme = call_574607.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574607.url(scheme.get, call_574607.host, call_574607.base,
                         call_574607.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574607, url, valid)

proc call*(call_574608: Call_DatabaseAccountsGetMongoDBDatabase_574599;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; accountName: string): Recallable =
  ## databaseAccountsGetMongoDBDatabase
  ## Gets the MongoDB databases under an existing Azure Cosmos DB database account with the provided name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574609 = newJObject()
  var query_574610 = newJObject()
  add(path_574609, "resourceGroupName", newJString(resourceGroupName))
  add(query_574610, "api-version", newJString(apiVersion))
  add(path_574609, "subscriptionId", newJString(subscriptionId))
  add(path_574609, "databaseName", newJString(databaseName))
  add(path_574609, "accountName", newJString(accountName))
  result = call_574608.call(path_574609, query_574610, nil, nil, nil)

var databaseAccountsGetMongoDBDatabase* = Call_DatabaseAccountsGetMongoDBDatabase_574599(
    name: "databaseAccountsGetMongoDBDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}",
    validator: validate_DatabaseAccountsGetMongoDBDatabase_574600, base: "",
    url: url_DatabaseAccountsGetMongoDBDatabase_574601, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteMongoDBDatabase_574625 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsDeleteMongoDBDatabase_574627(protocol: Scheme;
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

proc validate_DatabaseAccountsDeleteMongoDBDatabase_574626(path: JsonNode;
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
  var valid_574628 = path.getOrDefault("resourceGroupName")
  valid_574628 = validateParameter(valid_574628, JString, required = true,
                                 default = nil)
  if valid_574628 != nil:
    section.add "resourceGroupName", valid_574628
  var valid_574629 = path.getOrDefault("subscriptionId")
  valid_574629 = validateParameter(valid_574629, JString, required = true,
                                 default = nil)
  if valid_574629 != nil:
    section.add "subscriptionId", valid_574629
  var valid_574630 = path.getOrDefault("databaseName")
  valid_574630 = validateParameter(valid_574630, JString, required = true,
                                 default = nil)
  if valid_574630 != nil:
    section.add "databaseName", valid_574630
  var valid_574631 = path.getOrDefault("accountName")
  valid_574631 = validateParameter(valid_574631, JString, required = true,
                                 default = nil)
  if valid_574631 != nil:
    section.add "accountName", valid_574631
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574632 = query.getOrDefault("api-version")
  valid_574632 = validateParameter(valid_574632, JString, required = true,
                                 default = nil)
  if valid_574632 != nil:
    section.add "api-version", valid_574632
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574633: Call_DatabaseAccountsDeleteMongoDBDatabase_574625;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB MongoDB database.
  ## 
  let valid = call_574633.validator(path, query, header, formData, body)
  let scheme = call_574633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574633.url(scheme.get, call_574633.host, call_574633.base,
                         call_574633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574633, url, valid)

proc call*(call_574634: Call_DatabaseAccountsDeleteMongoDBDatabase_574625;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; accountName: string): Recallable =
  ## databaseAccountsDeleteMongoDBDatabase
  ## Deletes an existing Azure Cosmos DB MongoDB database.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574635 = newJObject()
  var query_574636 = newJObject()
  add(path_574635, "resourceGroupName", newJString(resourceGroupName))
  add(query_574636, "api-version", newJString(apiVersion))
  add(path_574635, "subscriptionId", newJString(subscriptionId))
  add(path_574635, "databaseName", newJString(databaseName))
  add(path_574635, "accountName", newJString(accountName))
  result = call_574634.call(path_574635, query_574636, nil, nil, nil)

var databaseAccountsDeleteMongoDBDatabase* = Call_DatabaseAccountsDeleteMongoDBDatabase_574625(
    name: "databaseAccountsDeleteMongoDBDatabase", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}",
    validator: validate_DatabaseAccountsDeleteMongoDBDatabase_574626, base: "",
    url: url_DatabaseAccountsDeleteMongoDBDatabase_574627, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListMongoDBCollections_574637 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsListMongoDBCollections_574639(protocol: Scheme;
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

proc validate_DatabaseAccountsListMongoDBCollections_574638(path: JsonNode;
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
  var valid_574640 = path.getOrDefault("resourceGroupName")
  valid_574640 = validateParameter(valid_574640, JString, required = true,
                                 default = nil)
  if valid_574640 != nil:
    section.add "resourceGroupName", valid_574640
  var valid_574641 = path.getOrDefault("subscriptionId")
  valid_574641 = validateParameter(valid_574641, JString, required = true,
                                 default = nil)
  if valid_574641 != nil:
    section.add "subscriptionId", valid_574641
  var valid_574642 = path.getOrDefault("databaseName")
  valid_574642 = validateParameter(valid_574642, JString, required = true,
                                 default = nil)
  if valid_574642 != nil:
    section.add "databaseName", valid_574642
  var valid_574643 = path.getOrDefault("accountName")
  valid_574643 = validateParameter(valid_574643, JString, required = true,
                                 default = nil)
  if valid_574643 != nil:
    section.add "accountName", valid_574643
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574644 = query.getOrDefault("api-version")
  valid_574644 = validateParameter(valid_574644, JString, required = true,
                                 default = nil)
  if valid_574644 != nil:
    section.add "api-version", valid_574644
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574645: Call_DatabaseAccountsListMongoDBCollections_574637;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the MongoDB collection under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_574645.validator(path, query, header, formData, body)
  let scheme = call_574645.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574645.url(scheme.get, call_574645.host, call_574645.base,
                         call_574645.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574645, url, valid)

proc call*(call_574646: Call_DatabaseAccountsListMongoDBCollections_574637;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; accountName: string): Recallable =
  ## databaseAccountsListMongoDBCollections
  ## Lists the MongoDB collection under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574647 = newJObject()
  var query_574648 = newJObject()
  add(path_574647, "resourceGroupName", newJString(resourceGroupName))
  add(query_574648, "api-version", newJString(apiVersion))
  add(path_574647, "subscriptionId", newJString(subscriptionId))
  add(path_574647, "databaseName", newJString(databaseName))
  add(path_574647, "accountName", newJString(accountName))
  result = call_574646.call(path_574647, query_574648, nil, nil, nil)

var databaseAccountsListMongoDBCollections* = Call_DatabaseAccountsListMongoDBCollections_574637(
    name: "databaseAccountsListMongoDBCollections", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/collections",
    validator: validate_DatabaseAccountsListMongoDBCollections_574638, base: "",
    url: url_DatabaseAccountsListMongoDBCollections_574639,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateMongoDBCollection_574662 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsCreateUpdateMongoDBCollection_574664(protocol: Scheme;
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

proc validate_DatabaseAccountsCreateUpdateMongoDBCollection_574663(
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
  var valid_574665 = path.getOrDefault("resourceGroupName")
  valid_574665 = validateParameter(valid_574665, JString, required = true,
                                 default = nil)
  if valid_574665 != nil:
    section.add "resourceGroupName", valid_574665
  var valid_574666 = path.getOrDefault("subscriptionId")
  valid_574666 = validateParameter(valid_574666, JString, required = true,
                                 default = nil)
  if valid_574666 != nil:
    section.add "subscriptionId", valid_574666
  var valid_574667 = path.getOrDefault("databaseName")
  valid_574667 = validateParameter(valid_574667, JString, required = true,
                                 default = nil)
  if valid_574667 != nil:
    section.add "databaseName", valid_574667
  var valid_574668 = path.getOrDefault("collectionName")
  valid_574668 = validateParameter(valid_574668, JString, required = true,
                                 default = nil)
  if valid_574668 != nil:
    section.add "collectionName", valid_574668
  var valid_574669 = path.getOrDefault("accountName")
  valid_574669 = validateParameter(valid_574669, JString, required = true,
                                 default = nil)
  if valid_574669 != nil:
    section.add "accountName", valid_574669
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574670 = query.getOrDefault("api-version")
  valid_574670 = validateParameter(valid_574670, JString, required = true,
                                 default = nil)
  if valid_574670 != nil:
    section.add "api-version", valid_574670
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

proc call*(call_574672: Call_DatabaseAccountsCreateUpdateMongoDBCollection_574662;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB MongoDB Collection
  ## 
  let valid = call_574672.validator(path, query, header, formData, body)
  let scheme = call_574672.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574672.url(scheme.get, call_574672.host, call_574672.base,
                         call_574672.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574672, url, valid)

proc call*(call_574673: Call_DatabaseAccountsCreateUpdateMongoDBCollection_574662;
          resourceGroupName: string;
          createUpdateMongoDBCollectionParameters: JsonNode; apiVersion: string;
          subscriptionId: string; databaseName: string; collectionName: string;
          accountName: string): Recallable =
  ## databaseAccountsCreateUpdateMongoDBCollection
  ## Create or update an Azure Cosmos DB MongoDB Collection
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   createUpdateMongoDBCollectionParameters: JObject (required)
  ##                                          : The parameters to provide for the current MongoDB Collection.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   collectionName: string (required)
  ##                 : Cosmos DB collection name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574674 = newJObject()
  var query_574675 = newJObject()
  var body_574676 = newJObject()
  add(path_574674, "resourceGroupName", newJString(resourceGroupName))
  if createUpdateMongoDBCollectionParameters != nil:
    body_574676 = createUpdateMongoDBCollectionParameters
  add(query_574675, "api-version", newJString(apiVersion))
  add(path_574674, "subscriptionId", newJString(subscriptionId))
  add(path_574674, "databaseName", newJString(databaseName))
  add(path_574674, "collectionName", newJString(collectionName))
  add(path_574674, "accountName", newJString(accountName))
  result = call_574673.call(path_574674, query_574675, nil, nil, body_574676)

var databaseAccountsCreateUpdateMongoDBCollection* = Call_DatabaseAccountsCreateUpdateMongoDBCollection_574662(
    name: "databaseAccountsCreateUpdateMongoDBCollection",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/collections/{collectionName}",
    validator: validate_DatabaseAccountsCreateUpdateMongoDBCollection_574663,
    base: "", url: url_DatabaseAccountsCreateUpdateMongoDBCollection_574664,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetMongoDBCollection_574649 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsGetMongoDBCollection_574651(protocol: Scheme;
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

proc validate_DatabaseAccountsGetMongoDBCollection_574650(path: JsonNode;
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
  var valid_574652 = path.getOrDefault("resourceGroupName")
  valid_574652 = validateParameter(valid_574652, JString, required = true,
                                 default = nil)
  if valid_574652 != nil:
    section.add "resourceGroupName", valid_574652
  var valid_574653 = path.getOrDefault("subscriptionId")
  valid_574653 = validateParameter(valid_574653, JString, required = true,
                                 default = nil)
  if valid_574653 != nil:
    section.add "subscriptionId", valid_574653
  var valid_574654 = path.getOrDefault("databaseName")
  valid_574654 = validateParameter(valid_574654, JString, required = true,
                                 default = nil)
  if valid_574654 != nil:
    section.add "databaseName", valid_574654
  var valid_574655 = path.getOrDefault("collectionName")
  valid_574655 = validateParameter(valid_574655, JString, required = true,
                                 default = nil)
  if valid_574655 != nil:
    section.add "collectionName", valid_574655
  var valid_574656 = path.getOrDefault("accountName")
  valid_574656 = validateParameter(valid_574656, JString, required = true,
                                 default = nil)
  if valid_574656 != nil:
    section.add "accountName", valid_574656
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574657 = query.getOrDefault("api-version")
  valid_574657 = validateParameter(valid_574657, JString, required = true,
                                 default = nil)
  if valid_574657 != nil:
    section.add "api-version", valid_574657
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574658: Call_DatabaseAccountsGetMongoDBCollection_574649;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the MongoDB collection under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_574658.validator(path, query, header, formData, body)
  let scheme = call_574658.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574658.url(scheme.get, call_574658.host, call_574658.base,
                         call_574658.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574658, url, valid)

proc call*(call_574659: Call_DatabaseAccountsGetMongoDBCollection_574649;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; collectionName: string; accountName: string): Recallable =
  ## databaseAccountsGetMongoDBCollection
  ## Gets the MongoDB collection under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   collectionName: string (required)
  ##                 : Cosmos DB collection name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574660 = newJObject()
  var query_574661 = newJObject()
  add(path_574660, "resourceGroupName", newJString(resourceGroupName))
  add(query_574661, "api-version", newJString(apiVersion))
  add(path_574660, "subscriptionId", newJString(subscriptionId))
  add(path_574660, "databaseName", newJString(databaseName))
  add(path_574660, "collectionName", newJString(collectionName))
  add(path_574660, "accountName", newJString(accountName))
  result = call_574659.call(path_574660, query_574661, nil, nil, nil)

var databaseAccountsGetMongoDBCollection* = Call_DatabaseAccountsGetMongoDBCollection_574649(
    name: "databaseAccountsGetMongoDBCollection", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/collections/{collectionName}",
    validator: validate_DatabaseAccountsGetMongoDBCollection_574650, base: "",
    url: url_DatabaseAccountsGetMongoDBCollection_574651, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteMongoDBCollection_574677 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsDeleteMongoDBCollection_574679(protocol: Scheme;
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

proc validate_DatabaseAccountsDeleteMongoDBCollection_574678(path: JsonNode;
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
  var valid_574680 = path.getOrDefault("resourceGroupName")
  valid_574680 = validateParameter(valid_574680, JString, required = true,
                                 default = nil)
  if valid_574680 != nil:
    section.add "resourceGroupName", valid_574680
  var valid_574681 = path.getOrDefault("subscriptionId")
  valid_574681 = validateParameter(valid_574681, JString, required = true,
                                 default = nil)
  if valid_574681 != nil:
    section.add "subscriptionId", valid_574681
  var valid_574682 = path.getOrDefault("databaseName")
  valid_574682 = validateParameter(valid_574682, JString, required = true,
                                 default = nil)
  if valid_574682 != nil:
    section.add "databaseName", valid_574682
  var valid_574683 = path.getOrDefault("collectionName")
  valid_574683 = validateParameter(valid_574683, JString, required = true,
                                 default = nil)
  if valid_574683 != nil:
    section.add "collectionName", valid_574683
  var valid_574684 = path.getOrDefault("accountName")
  valid_574684 = validateParameter(valid_574684, JString, required = true,
                                 default = nil)
  if valid_574684 != nil:
    section.add "accountName", valid_574684
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574685 = query.getOrDefault("api-version")
  valid_574685 = validateParameter(valid_574685, JString, required = true,
                                 default = nil)
  if valid_574685 != nil:
    section.add "api-version", valid_574685
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574686: Call_DatabaseAccountsDeleteMongoDBCollection_574677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB MongoDB Collection.
  ## 
  let valid = call_574686.validator(path, query, header, formData, body)
  let scheme = call_574686.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574686.url(scheme.get, call_574686.host, call_574686.base,
                         call_574686.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574686, url, valid)

proc call*(call_574687: Call_DatabaseAccountsDeleteMongoDBCollection_574677;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; collectionName: string; accountName: string): Recallable =
  ## databaseAccountsDeleteMongoDBCollection
  ## Deletes an existing Azure Cosmos DB MongoDB Collection.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   collectionName: string (required)
  ##                 : Cosmos DB collection name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574688 = newJObject()
  var query_574689 = newJObject()
  add(path_574688, "resourceGroupName", newJString(resourceGroupName))
  add(query_574689, "api-version", newJString(apiVersion))
  add(path_574688, "subscriptionId", newJString(subscriptionId))
  add(path_574688, "databaseName", newJString(databaseName))
  add(path_574688, "collectionName", newJString(collectionName))
  add(path_574688, "accountName", newJString(accountName))
  result = call_574687.call(path_574688, query_574689, nil, nil, nil)

var databaseAccountsDeleteMongoDBCollection* = Call_DatabaseAccountsDeleteMongoDBCollection_574677(
    name: "databaseAccountsDeleteMongoDBCollection", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/collections/{collectionName}",
    validator: validate_DatabaseAccountsDeleteMongoDBCollection_574678, base: "",
    url: url_DatabaseAccountsDeleteMongoDBCollection_574679,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateMongoDBCollectionThroughput_574703 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsUpdateMongoDBCollectionThroughput_574705(
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

proc validate_DatabaseAccountsUpdateMongoDBCollectionThroughput_574704(
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
  var valid_574706 = path.getOrDefault("resourceGroupName")
  valid_574706 = validateParameter(valid_574706, JString, required = true,
                                 default = nil)
  if valid_574706 != nil:
    section.add "resourceGroupName", valid_574706
  var valid_574707 = path.getOrDefault("subscriptionId")
  valid_574707 = validateParameter(valid_574707, JString, required = true,
                                 default = nil)
  if valid_574707 != nil:
    section.add "subscriptionId", valid_574707
  var valid_574708 = path.getOrDefault("databaseName")
  valid_574708 = validateParameter(valid_574708, JString, required = true,
                                 default = nil)
  if valid_574708 != nil:
    section.add "databaseName", valid_574708
  var valid_574709 = path.getOrDefault("collectionName")
  valid_574709 = validateParameter(valid_574709, JString, required = true,
                                 default = nil)
  if valid_574709 != nil:
    section.add "collectionName", valid_574709
  var valid_574710 = path.getOrDefault("accountName")
  valid_574710 = validateParameter(valid_574710, JString, required = true,
                                 default = nil)
  if valid_574710 != nil:
    section.add "accountName", valid_574710
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574711 = query.getOrDefault("api-version")
  valid_574711 = validateParameter(valid_574711, JString, required = true,
                                 default = nil)
  if valid_574711 != nil:
    section.add "api-version", valid_574711
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

proc call*(call_574713: Call_DatabaseAccountsUpdateMongoDBCollectionThroughput_574703;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the RUs per second of an Azure Cosmos DB MongoDB collection
  ## 
  let valid = call_574713.validator(path, query, header, formData, body)
  let scheme = call_574713.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574713.url(scheme.get, call_574713.host, call_574713.base,
                         call_574713.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574713, url, valid)

proc call*(call_574714: Call_DatabaseAccountsUpdateMongoDBCollectionThroughput_574703;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; updateThroughputParameters: JsonNode;
          collectionName: string; accountName: string): Recallable =
  ## databaseAccountsUpdateMongoDBCollectionThroughput
  ## Update the RUs per second of an Azure Cosmos DB MongoDB collection
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_574715 = newJObject()
  var query_574716 = newJObject()
  var body_574717 = newJObject()
  add(path_574715, "resourceGroupName", newJString(resourceGroupName))
  add(query_574716, "api-version", newJString(apiVersion))
  add(path_574715, "subscriptionId", newJString(subscriptionId))
  add(path_574715, "databaseName", newJString(databaseName))
  if updateThroughputParameters != nil:
    body_574717 = updateThroughputParameters
  add(path_574715, "collectionName", newJString(collectionName))
  add(path_574715, "accountName", newJString(accountName))
  result = call_574714.call(path_574715, query_574716, nil, nil, body_574717)

var databaseAccountsUpdateMongoDBCollectionThroughput* = Call_DatabaseAccountsUpdateMongoDBCollectionThroughput_574703(
    name: "databaseAccountsUpdateMongoDBCollectionThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/collections/{collectionName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateMongoDBCollectionThroughput_574704,
    base: "", url: url_DatabaseAccountsUpdateMongoDBCollectionThroughput_574705,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetMongoDBCollectionThroughput_574690 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsGetMongoDBCollectionThroughput_574692(protocol: Scheme;
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

proc validate_DatabaseAccountsGetMongoDBCollectionThroughput_574691(
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
  var valid_574693 = path.getOrDefault("resourceGroupName")
  valid_574693 = validateParameter(valid_574693, JString, required = true,
                                 default = nil)
  if valid_574693 != nil:
    section.add "resourceGroupName", valid_574693
  var valid_574694 = path.getOrDefault("subscriptionId")
  valid_574694 = validateParameter(valid_574694, JString, required = true,
                                 default = nil)
  if valid_574694 != nil:
    section.add "subscriptionId", valid_574694
  var valid_574695 = path.getOrDefault("databaseName")
  valid_574695 = validateParameter(valid_574695, JString, required = true,
                                 default = nil)
  if valid_574695 != nil:
    section.add "databaseName", valid_574695
  var valid_574696 = path.getOrDefault("collectionName")
  valid_574696 = validateParameter(valid_574696, JString, required = true,
                                 default = nil)
  if valid_574696 != nil:
    section.add "collectionName", valid_574696
  var valid_574697 = path.getOrDefault("accountName")
  valid_574697 = validateParameter(valid_574697, JString, required = true,
                                 default = nil)
  if valid_574697 != nil:
    section.add "accountName", valid_574697
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574698 = query.getOrDefault("api-version")
  valid_574698 = validateParameter(valid_574698, JString, required = true,
                                 default = nil)
  if valid_574698 != nil:
    section.add "api-version", valid_574698
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574699: Call_DatabaseAccountsGetMongoDBCollectionThroughput_574690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the MongoDB collection under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_574699.validator(path, query, header, formData, body)
  let scheme = call_574699.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574699.url(scheme.get, call_574699.host, call_574699.base,
                         call_574699.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574699, url, valid)

proc call*(call_574700: Call_DatabaseAccountsGetMongoDBCollectionThroughput_574690;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; collectionName: string; accountName: string): Recallable =
  ## databaseAccountsGetMongoDBCollectionThroughput
  ## Gets the RUs per second of the MongoDB collection under an existing Azure Cosmos DB database account with the provided name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   collectionName: string (required)
  ##                 : Cosmos DB collection name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574701 = newJObject()
  var query_574702 = newJObject()
  add(path_574701, "resourceGroupName", newJString(resourceGroupName))
  add(query_574702, "api-version", newJString(apiVersion))
  add(path_574701, "subscriptionId", newJString(subscriptionId))
  add(path_574701, "databaseName", newJString(databaseName))
  add(path_574701, "collectionName", newJString(collectionName))
  add(path_574701, "accountName", newJString(accountName))
  result = call_574700.call(path_574701, query_574702, nil, nil, nil)

var databaseAccountsGetMongoDBCollectionThroughput* = Call_DatabaseAccountsGetMongoDBCollectionThroughput_574690(
    name: "databaseAccountsGetMongoDBCollectionThroughput",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/collections/{collectionName}/settings/throughput",
    validator: validate_DatabaseAccountsGetMongoDBCollectionThroughput_574691,
    base: "", url: url_DatabaseAccountsGetMongoDBCollectionThroughput_574692,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateMongoDBDatabaseThroughput_574730 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsUpdateMongoDBDatabaseThroughput_574732(protocol: Scheme;
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

proc validate_DatabaseAccountsUpdateMongoDBDatabaseThroughput_574731(
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
  var valid_574733 = path.getOrDefault("resourceGroupName")
  valid_574733 = validateParameter(valid_574733, JString, required = true,
                                 default = nil)
  if valid_574733 != nil:
    section.add "resourceGroupName", valid_574733
  var valid_574734 = path.getOrDefault("subscriptionId")
  valid_574734 = validateParameter(valid_574734, JString, required = true,
                                 default = nil)
  if valid_574734 != nil:
    section.add "subscriptionId", valid_574734
  var valid_574735 = path.getOrDefault("databaseName")
  valid_574735 = validateParameter(valid_574735, JString, required = true,
                                 default = nil)
  if valid_574735 != nil:
    section.add "databaseName", valid_574735
  var valid_574736 = path.getOrDefault("accountName")
  valid_574736 = validateParameter(valid_574736, JString, required = true,
                                 default = nil)
  if valid_574736 != nil:
    section.add "accountName", valid_574736
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574737 = query.getOrDefault("api-version")
  valid_574737 = validateParameter(valid_574737, JString, required = true,
                                 default = nil)
  if valid_574737 != nil:
    section.add "api-version", valid_574737
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

proc call*(call_574739: Call_DatabaseAccountsUpdateMongoDBDatabaseThroughput_574730;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of the an Azure Cosmos DB MongoDB database
  ## 
  let valid = call_574739.validator(path, query, header, formData, body)
  let scheme = call_574739.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574739.url(scheme.get, call_574739.host, call_574739.base,
                         call_574739.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574739, url, valid)

proc call*(call_574740: Call_DatabaseAccountsUpdateMongoDBDatabaseThroughput_574730;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; updateThroughputParameters: JsonNode;
          accountName: string): Recallable =
  ## databaseAccountsUpdateMongoDBDatabaseThroughput
  ## Update RUs per second of the an Azure Cosmos DB MongoDB database
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   updateThroughputParameters: JObject (required)
  ##                             : The RUs per second of the parameters to provide for the current MongoDB database.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574741 = newJObject()
  var query_574742 = newJObject()
  var body_574743 = newJObject()
  add(path_574741, "resourceGroupName", newJString(resourceGroupName))
  add(query_574742, "api-version", newJString(apiVersion))
  add(path_574741, "subscriptionId", newJString(subscriptionId))
  add(path_574741, "databaseName", newJString(databaseName))
  if updateThroughputParameters != nil:
    body_574743 = updateThroughputParameters
  add(path_574741, "accountName", newJString(accountName))
  result = call_574740.call(path_574741, query_574742, nil, nil, body_574743)

var databaseAccountsUpdateMongoDBDatabaseThroughput* = Call_DatabaseAccountsUpdateMongoDBDatabaseThroughput_574730(
    name: "databaseAccountsUpdateMongoDBDatabaseThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateMongoDBDatabaseThroughput_574731,
    base: "", url: url_DatabaseAccountsUpdateMongoDBDatabaseThroughput_574732,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetMongoDBDatabaseThroughput_574718 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsGetMongoDBDatabaseThroughput_574720(protocol: Scheme;
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

proc validate_DatabaseAccountsGetMongoDBDatabaseThroughput_574719(path: JsonNode;
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
  var valid_574721 = path.getOrDefault("resourceGroupName")
  valid_574721 = validateParameter(valid_574721, JString, required = true,
                                 default = nil)
  if valid_574721 != nil:
    section.add "resourceGroupName", valid_574721
  var valid_574722 = path.getOrDefault("subscriptionId")
  valid_574722 = validateParameter(valid_574722, JString, required = true,
                                 default = nil)
  if valid_574722 != nil:
    section.add "subscriptionId", valid_574722
  var valid_574723 = path.getOrDefault("databaseName")
  valid_574723 = validateParameter(valid_574723, JString, required = true,
                                 default = nil)
  if valid_574723 != nil:
    section.add "databaseName", valid_574723
  var valid_574724 = path.getOrDefault("accountName")
  valid_574724 = validateParameter(valid_574724, JString, required = true,
                                 default = nil)
  if valid_574724 != nil:
    section.add "accountName", valid_574724
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574725 = query.getOrDefault("api-version")
  valid_574725 = validateParameter(valid_574725, JString, required = true,
                                 default = nil)
  if valid_574725 != nil:
    section.add "api-version", valid_574725
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574726: Call_DatabaseAccountsGetMongoDBDatabaseThroughput_574718;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the MongoDB database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_574726.validator(path, query, header, formData, body)
  let scheme = call_574726.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574726.url(scheme.get, call_574726.host, call_574726.base,
                         call_574726.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574726, url, valid)

proc call*(call_574727: Call_DatabaseAccountsGetMongoDBDatabaseThroughput_574718;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; accountName: string): Recallable =
  ## databaseAccountsGetMongoDBDatabaseThroughput
  ## Gets the RUs per second of the MongoDB database under an existing Azure Cosmos DB database account with the provided name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574728 = newJObject()
  var query_574729 = newJObject()
  add(path_574728, "resourceGroupName", newJString(resourceGroupName))
  add(query_574729, "api-version", newJString(apiVersion))
  add(path_574728, "subscriptionId", newJString(subscriptionId))
  add(path_574728, "databaseName", newJString(databaseName))
  add(path_574728, "accountName", newJString(accountName))
  result = call_574727.call(path_574728, query_574729, nil, nil, nil)

var databaseAccountsGetMongoDBDatabaseThroughput* = Call_DatabaseAccountsGetMongoDBDatabaseThroughput_574718(
    name: "databaseAccountsGetMongoDBDatabaseThroughput",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/settings/throughput",
    validator: validate_DatabaseAccountsGetMongoDBDatabaseThroughput_574719,
    base: "", url: url_DatabaseAccountsGetMongoDBDatabaseThroughput_574720,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListSqlDatabases_574744 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsListSqlDatabases_574746(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListSqlDatabases_574745(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_574747 = path.getOrDefault("resourceGroupName")
  valid_574747 = validateParameter(valid_574747, JString, required = true,
                                 default = nil)
  if valid_574747 != nil:
    section.add "resourceGroupName", valid_574747
  var valid_574748 = path.getOrDefault("subscriptionId")
  valid_574748 = validateParameter(valid_574748, JString, required = true,
                                 default = nil)
  if valid_574748 != nil:
    section.add "subscriptionId", valid_574748
  var valid_574749 = path.getOrDefault("accountName")
  valid_574749 = validateParameter(valid_574749, JString, required = true,
                                 default = nil)
  if valid_574749 != nil:
    section.add "accountName", valid_574749
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574750 = query.getOrDefault("api-version")
  valid_574750 = validateParameter(valid_574750, JString, required = true,
                                 default = nil)
  if valid_574750 != nil:
    section.add "api-version", valid_574750
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574751: Call_DatabaseAccountsListSqlDatabases_574744;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the SQL databases under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_574751.validator(path, query, header, formData, body)
  let scheme = call_574751.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574751.url(scheme.get, call_574751.host, call_574751.base,
                         call_574751.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574751, url, valid)

proc call*(call_574752: Call_DatabaseAccountsListSqlDatabases_574744;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## databaseAccountsListSqlDatabases
  ## Lists the SQL databases under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574753 = newJObject()
  var query_574754 = newJObject()
  add(path_574753, "resourceGroupName", newJString(resourceGroupName))
  add(query_574754, "api-version", newJString(apiVersion))
  add(path_574753, "subscriptionId", newJString(subscriptionId))
  add(path_574753, "accountName", newJString(accountName))
  result = call_574752.call(path_574753, query_574754, nil, nil, nil)

var databaseAccountsListSqlDatabases* = Call_DatabaseAccountsListSqlDatabases_574744(
    name: "databaseAccountsListSqlDatabases", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases",
    validator: validate_DatabaseAccountsListSqlDatabases_574745, base: "",
    url: url_DatabaseAccountsListSqlDatabases_574746, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateSqlDatabase_574767 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsCreateUpdateSqlDatabase_574769(protocol: Scheme;
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

proc validate_DatabaseAccountsCreateUpdateSqlDatabase_574768(path: JsonNode;
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
  var valid_574770 = path.getOrDefault("resourceGroupName")
  valid_574770 = validateParameter(valid_574770, JString, required = true,
                                 default = nil)
  if valid_574770 != nil:
    section.add "resourceGroupName", valid_574770
  var valid_574771 = path.getOrDefault("subscriptionId")
  valid_574771 = validateParameter(valid_574771, JString, required = true,
                                 default = nil)
  if valid_574771 != nil:
    section.add "subscriptionId", valid_574771
  var valid_574772 = path.getOrDefault("databaseName")
  valid_574772 = validateParameter(valid_574772, JString, required = true,
                                 default = nil)
  if valid_574772 != nil:
    section.add "databaseName", valid_574772
  var valid_574773 = path.getOrDefault("accountName")
  valid_574773 = validateParameter(valid_574773, JString, required = true,
                                 default = nil)
  if valid_574773 != nil:
    section.add "accountName", valid_574773
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574774 = query.getOrDefault("api-version")
  valid_574774 = validateParameter(valid_574774, JString, required = true,
                                 default = nil)
  if valid_574774 != nil:
    section.add "api-version", valid_574774
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

proc call*(call_574776: Call_DatabaseAccountsCreateUpdateSqlDatabase_574767;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB SQL database
  ## 
  let valid = call_574776.validator(path, query, header, formData, body)
  let scheme = call_574776.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574776.url(scheme.get, call_574776.host, call_574776.base,
                         call_574776.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574776, url, valid)

proc call*(call_574777: Call_DatabaseAccountsCreateUpdateSqlDatabase_574767;
          createUpdateSqlDatabaseParameters: JsonNode; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; databaseName: string;
          accountName: string): Recallable =
  ## databaseAccountsCreateUpdateSqlDatabase
  ## Create or update an Azure Cosmos DB SQL database
  ##   createUpdateSqlDatabaseParameters: JObject (required)
  ##                                    : The parameters to provide for the current SQL database.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574778 = newJObject()
  var query_574779 = newJObject()
  var body_574780 = newJObject()
  if createUpdateSqlDatabaseParameters != nil:
    body_574780 = createUpdateSqlDatabaseParameters
  add(path_574778, "resourceGroupName", newJString(resourceGroupName))
  add(query_574779, "api-version", newJString(apiVersion))
  add(path_574778, "subscriptionId", newJString(subscriptionId))
  add(path_574778, "databaseName", newJString(databaseName))
  add(path_574778, "accountName", newJString(accountName))
  result = call_574777.call(path_574778, query_574779, nil, nil, body_574780)

var databaseAccountsCreateUpdateSqlDatabase* = Call_DatabaseAccountsCreateUpdateSqlDatabase_574767(
    name: "databaseAccountsCreateUpdateSqlDatabase", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}",
    validator: validate_DatabaseAccountsCreateUpdateSqlDatabase_574768, base: "",
    url: url_DatabaseAccountsCreateUpdateSqlDatabase_574769,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetSqlDatabase_574755 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsGetSqlDatabase_574757(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsGetSqlDatabase_574756(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_574758 = path.getOrDefault("resourceGroupName")
  valid_574758 = validateParameter(valid_574758, JString, required = true,
                                 default = nil)
  if valid_574758 != nil:
    section.add "resourceGroupName", valid_574758
  var valid_574759 = path.getOrDefault("subscriptionId")
  valid_574759 = validateParameter(valid_574759, JString, required = true,
                                 default = nil)
  if valid_574759 != nil:
    section.add "subscriptionId", valid_574759
  var valid_574760 = path.getOrDefault("databaseName")
  valid_574760 = validateParameter(valid_574760, JString, required = true,
                                 default = nil)
  if valid_574760 != nil:
    section.add "databaseName", valid_574760
  var valid_574761 = path.getOrDefault("accountName")
  valid_574761 = validateParameter(valid_574761, JString, required = true,
                                 default = nil)
  if valid_574761 != nil:
    section.add "accountName", valid_574761
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574762 = query.getOrDefault("api-version")
  valid_574762 = validateParameter(valid_574762, JString, required = true,
                                 default = nil)
  if valid_574762 != nil:
    section.add "api-version", valid_574762
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574763: Call_DatabaseAccountsGetSqlDatabase_574755; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the SQL database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_574763.validator(path, query, header, formData, body)
  let scheme = call_574763.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574763.url(scheme.get, call_574763.host, call_574763.base,
                         call_574763.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574763, url, valid)

proc call*(call_574764: Call_DatabaseAccountsGetSqlDatabase_574755;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; accountName: string): Recallable =
  ## databaseAccountsGetSqlDatabase
  ## Gets the SQL database under an existing Azure Cosmos DB database account with the provided name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574765 = newJObject()
  var query_574766 = newJObject()
  add(path_574765, "resourceGroupName", newJString(resourceGroupName))
  add(query_574766, "api-version", newJString(apiVersion))
  add(path_574765, "subscriptionId", newJString(subscriptionId))
  add(path_574765, "databaseName", newJString(databaseName))
  add(path_574765, "accountName", newJString(accountName))
  result = call_574764.call(path_574765, query_574766, nil, nil, nil)

var databaseAccountsGetSqlDatabase* = Call_DatabaseAccountsGetSqlDatabase_574755(
    name: "databaseAccountsGetSqlDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}",
    validator: validate_DatabaseAccountsGetSqlDatabase_574756, base: "",
    url: url_DatabaseAccountsGetSqlDatabase_574757, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteSqlDatabase_574781 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsDeleteSqlDatabase_574783(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsDeleteSqlDatabase_574782(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_574784 = path.getOrDefault("resourceGroupName")
  valid_574784 = validateParameter(valid_574784, JString, required = true,
                                 default = nil)
  if valid_574784 != nil:
    section.add "resourceGroupName", valid_574784
  var valid_574785 = path.getOrDefault("subscriptionId")
  valid_574785 = validateParameter(valid_574785, JString, required = true,
                                 default = nil)
  if valid_574785 != nil:
    section.add "subscriptionId", valid_574785
  var valid_574786 = path.getOrDefault("databaseName")
  valid_574786 = validateParameter(valid_574786, JString, required = true,
                                 default = nil)
  if valid_574786 != nil:
    section.add "databaseName", valid_574786
  var valid_574787 = path.getOrDefault("accountName")
  valid_574787 = validateParameter(valid_574787, JString, required = true,
                                 default = nil)
  if valid_574787 != nil:
    section.add "accountName", valid_574787
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574788 = query.getOrDefault("api-version")
  valid_574788 = validateParameter(valid_574788, JString, required = true,
                                 default = nil)
  if valid_574788 != nil:
    section.add "api-version", valid_574788
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574789: Call_DatabaseAccountsDeleteSqlDatabase_574781;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB SQL database.
  ## 
  let valid = call_574789.validator(path, query, header, formData, body)
  let scheme = call_574789.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574789.url(scheme.get, call_574789.host, call_574789.base,
                         call_574789.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574789, url, valid)

proc call*(call_574790: Call_DatabaseAccountsDeleteSqlDatabase_574781;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; accountName: string): Recallable =
  ## databaseAccountsDeleteSqlDatabase
  ## Deletes an existing Azure Cosmos DB SQL database.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574791 = newJObject()
  var query_574792 = newJObject()
  add(path_574791, "resourceGroupName", newJString(resourceGroupName))
  add(query_574792, "api-version", newJString(apiVersion))
  add(path_574791, "subscriptionId", newJString(subscriptionId))
  add(path_574791, "databaseName", newJString(databaseName))
  add(path_574791, "accountName", newJString(accountName))
  result = call_574790.call(path_574791, query_574792, nil, nil, nil)

var databaseAccountsDeleteSqlDatabase* = Call_DatabaseAccountsDeleteSqlDatabase_574781(
    name: "databaseAccountsDeleteSqlDatabase", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}",
    validator: validate_DatabaseAccountsDeleteSqlDatabase_574782, base: "",
    url: url_DatabaseAccountsDeleteSqlDatabase_574783, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListSqlContainers_574793 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsListSqlContainers_574795(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListSqlContainers_574794(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_574796 = path.getOrDefault("resourceGroupName")
  valid_574796 = validateParameter(valid_574796, JString, required = true,
                                 default = nil)
  if valid_574796 != nil:
    section.add "resourceGroupName", valid_574796
  var valid_574797 = path.getOrDefault("subscriptionId")
  valid_574797 = validateParameter(valid_574797, JString, required = true,
                                 default = nil)
  if valid_574797 != nil:
    section.add "subscriptionId", valid_574797
  var valid_574798 = path.getOrDefault("databaseName")
  valid_574798 = validateParameter(valid_574798, JString, required = true,
                                 default = nil)
  if valid_574798 != nil:
    section.add "databaseName", valid_574798
  var valid_574799 = path.getOrDefault("accountName")
  valid_574799 = validateParameter(valid_574799, JString, required = true,
                                 default = nil)
  if valid_574799 != nil:
    section.add "accountName", valid_574799
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574800 = query.getOrDefault("api-version")
  valid_574800 = validateParameter(valid_574800, JString, required = true,
                                 default = nil)
  if valid_574800 != nil:
    section.add "api-version", valid_574800
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574801: Call_DatabaseAccountsListSqlContainers_574793;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the SQL container under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_574801.validator(path, query, header, formData, body)
  let scheme = call_574801.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574801.url(scheme.get, call_574801.host, call_574801.base,
                         call_574801.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574801, url, valid)

proc call*(call_574802: Call_DatabaseAccountsListSqlContainers_574793;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; accountName: string): Recallable =
  ## databaseAccountsListSqlContainers
  ## Lists the SQL container under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574803 = newJObject()
  var query_574804 = newJObject()
  add(path_574803, "resourceGroupName", newJString(resourceGroupName))
  add(query_574804, "api-version", newJString(apiVersion))
  add(path_574803, "subscriptionId", newJString(subscriptionId))
  add(path_574803, "databaseName", newJString(databaseName))
  add(path_574803, "accountName", newJString(accountName))
  result = call_574802.call(path_574803, query_574804, nil, nil, nil)

var databaseAccountsListSqlContainers* = Call_DatabaseAccountsListSqlContainers_574793(
    name: "databaseAccountsListSqlContainers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/containers",
    validator: validate_DatabaseAccountsListSqlContainers_574794, base: "",
    url: url_DatabaseAccountsListSqlContainers_574795, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateSqlContainer_574818 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsCreateUpdateSqlContainer_574820(protocol: Scheme;
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

proc validate_DatabaseAccountsCreateUpdateSqlContainer_574819(path: JsonNode;
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
  var valid_574821 = path.getOrDefault("resourceGroupName")
  valid_574821 = validateParameter(valid_574821, JString, required = true,
                                 default = nil)
  if valid_574821 != nil:
    section.add "resourceGroupName", valid_574821
  var valid_574822 = path.getOrDefault("containerName")
  valid_574822 = validateParameter(valid_574822, JString, required = true,
                                 default = nil)
  if valid_574822 != nil:
    section.add "containerName", valid_574822
  var valid_574823 = path.getOrDefault("subscriptionId")
  valid_574823 = validateParameter(valid_574823, JString, required = true,
                                 default = nil)
  if valid_574823 != nil:
    section.add "subscriptionId", valid_574823
  var valid_574824 = path.getOrDefault("databaseName")
  valid_574824 = validateParameter(valid_574824, JString, required = true,
                                 default = nil)
  if valid_574824 != nil:
    section.add "databaseName", valid_574824
  var valid_574825 = path.getOrDefault("accountName")
  valid_574825 = validateParameter(valid_574825, JString, required = true,
                                 default = nil)
  if valid_574825 != nil:
    section.add "accountName", valid_574825
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574826 = query.getOrDefault("api-version")
  valid_574826 = validateParameter(valid_574826, JString, required = true,
                                 default = nil)
  if valid_574826 != nil:
    section.add "api-version", valid_574826
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

proc call*(call_574828: Call_DatabaseAccountsCreateUpdateSqlContainer_574818;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB SQL container
  ## 
  let valid = call_574828.validator(path, query, header, formData, body)
  let scheme = call_574828.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574828.url(scheme.get, call_574828.host, call_574828.base,
                         call_574828.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574828, url, valid)

proc call*(call_574829: Call_DatabaseAccountsCreateUpdateSqlContainer_574818;
          createUpdateSqlContainerParameters: JsonNode; resourceGroupName: string;
          apiVersion: string; containerName: string; subscriptionId: string;
          databaseName: string; accountName: string): Recallable =
  ## databaseAccountsCreateUpdateSqlContainer
  ## Create or update an Azure Cosmos DB SQL container
  ##   createUpdateSqlContainerParameters: JObject (required)
  ##                                     : The parameters to provide for the current SQL container.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574830 = newJObject()
  var query_574831 = newJObject()
  var body_574832 = newJObject()
  if createUpdateSqlContainerParameters != nil:
    body_574832 = createUpdateSqlContainerParameters
  add(path_574830, "resourceGroupName", newJString(resourceGroupName))
  add(query_574831, "api-version", newJString(apiVersion))
  add(path_574830, "containerName", newJString(containerName))
  add(path_574830, "subscriptionId", newJString(subscriptionId))
  add(path_574830, "databaseName", newJString(databaseName))
  add(path_574830, "accountName", newJString(accountName))
  result = call_574829.call(path_574830, query_574831, nil, nil, body_574832)

var databaseAccountsCreateUpdateSqlContainer* = Call_DatabaseAccountsCreateUpdateSqlContainer_574818(
    name: "databaseAccountsCreateUpdateSqlContainer", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/containers/{containerName}",
    validator: validate_DatabaseAccountsCreateUpdateSqlContainer_574819, base: "",
    url: url_DatabaseAccountsCreateUpdateSqlContainer_574820,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetSqlContainer_574805 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsGetSqlContainer_574807(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsGetSqlContainer_574806(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_574808 = path.getOrDefault("resourceGroupName")
  valid_574808 = validateParameter(valid_574808, JString, required = true,
                                 default = nil)
  if valid_574808 != nil:
    section.add "resourceGroupName", valid_574808
  var valid_574809 = path.getOrDefault("containerName")
  valid_574809 = validateParameter(valid_574809, JString, required = true,
                                 default = nil)
  if valid_574809 != nil:
    section.add "containerName", valid_574809
  var valid_574810 = path.getOrDefault("subscriptionId")
  valid_574810 = validateParameter(valid_574810, JString, required = true,
                                 default = nil)
  if valid_574810 != nil:
    section.add "subscriptionId", valid_574810
  var valid_574811 = path.getOrDefault("databaseName")
  valid_574811 = validateParameter(valid_574811, JString, required = true,
                                 default = nil)
  if valid_574811 != nil:
    section.add "databaseName", valid_574811
  var valid_574812 = path.getOrDefault("accountName")
  valid_574812 = validateParameter(valid_574812, JString, required = true,
                                 default = nil)
  if valid_574812 != nil:
    section.add "accountName", valid_574812
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574813 = query.getOrDefault("api-version")
  valid_574813 = validateParameter(valid_574813, JString, required = true,
                                 default = nil)
  if valid_574813 != nil:
    section.add "api-version", valid_574813
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574814: Call_DatabaseAccountsGetSqlContainer_574805;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the SQL container under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_574814.validator(path, query, header, formData, body)
  let scheme = call_574814.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574814.url(scheme.get, call_574814.host, call_574814.base,
                         call_574814.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574814, url, valid)

proc call*(call_574815: Call_DatabaseAccountsGetSqlContainer_574805;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; databaseName: string; accountName: string): Recallable =
  ## databaseAccountsGetSqlContainer
  ## Gets the SQL container under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574816 = newJObject()
  var query_574817 = newJObject()
  add(path_574816, "resourceGroupName", newJString(resourceGroupName))
  add(query_574817, "api-version", newJString(apiVersion))
  add(path_574816, "containerName", newJString(containerName))
  add(path_574816, "subscriptionId", newJString(subscriptionId))
  add(path_574816, "databaseName", newJString(databaseName))
  add(path_574816, "accountName", newJString(accountName))
  result = call_574815.call(path_574816, query_574817, nil, nil, nil)

var databaseAccountsGetSqlContainer* = Call_DatabaseAccountsGetSqlContainer_574805(
    name: "databaseAccountsGetSqlContainer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/containers/{containerName}",
    validator: validate_DatabaseAccountsGetSqlContainer_574806, base: "",
    url: url_DatabaseAccountsGetSqlContainer_574807, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteSqlContainer_574833 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsDeleteSqlContainer_574835(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsDeleteSqlContainer_574834(path: JsonNode;
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
  var valid_574836 = path.getOrDefault("resourceGroupName")
  valid_574836 = validateParameter(valid_574836, JString, required = true,
                                 default = nil)
  if valid_574836 != nil:
    section.add "resourceGroupName", valid_574836
  var valid_574837 = path.getOrDefault("containerName")
  valid_574837 = validateParameter(valid_574837, JString, required = true,
                                 default = nil)
  if valid_574837 != nil:
    section.add "containerName", valid_574837
  var valid_574838 = path.getOrDefault("subscriptionId")
  valid_574838 = validateParameter(valid_574838, JString, required = true,
                                 default = nil)
  if valid_574838 != nil:
    section.add "subscriptionId", valid_574838
  var valid_574839 = path.getOrDefault("databaseName")
  valid_574839 = validateParameter(valid_574839, JString, required = true,
                                 default = nil)
  if valid_574839 != nil:
    section.add "databaseName", valid_574839
  var valid_574840 = path.getOrDefault("accountName")
  valid_574840 = validateParameter(valid_574840, JString, required = true,
                                 default = nil)
  if valid_574840 != nil:
    section.add "accountName", valid_574840
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574841 = query.getOrDefault("api-version")
  valid_574841 = validateParameter(valid_574841, JString, required = true,
                                 default = nil)
  if valid_574841 != nil:
    section.add "api-version", valid_574841
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574842: Call_DatabaseAccountsDeleteSqlContainer_574833;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB SQL container.
  ## 
  let valid = call_574842.validator(path, query, header, formData, body)
  let scheme = call_574842.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574842.url(scheme.get, call_574842.host, call_574842.base,
                         call_574842.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574842, url, valid)

proc call*(call_574843: Call_DatabaseAccountsDeleteSqlContainer_574833;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; databaseName: string; accountName: string): Recallable =
  ## databaseAccountsDeleteSqlContainer
  ## Deletes an existing Azure Cosmos DB SQL container.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574844 = newJObject()
  var query_574845 = newJObject()
  add(path_574844, "resourceGroupName", newJString(resourceGroupName))
  add(query_574845, "api-version", newJString(apiVersion))
  add(path_574844, "containerName", newJString(containerName))
  add(path_574844, "subscriptionId", newJString(subscriptionId))
  add(path_574844, "databaseName", newJString(databaseName))
  add(path_574844, "accountName", newJString(accountName))
  result = call_574843.call(path_574844, query_574845, nil, nil, nil)

var databaseAccountsDeleteSqlContainer* = Call_DatabaseAccountsDeleteSqlContainer_574833(
    name: "databaseAccountsDeleteSqlContainer", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/containers/{containerName}",
    validator: validate_DatabaseAccountsDeleteSqlContainer_574834, base: "",
    url: url_DatabaseAccountsDeleteSqlContainer_574835, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateSqlContainerThroughput_574859 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsUpdateSqlContainerThroughput_574861(protocol: Scheme;
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

proc validate_DatabaseAccountsUpdateSqlContainerThroughput_574860(path: JsonNode;
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
  var valid_574862 = path.getOrDefault("resourceGroupName")
  valid_574862 = validateParameter(valid_574862, JString, required = true,
                                 default = nil)
  if valid_574862 != nil:
    section.add "resourceGroupName", valid_574862
  var valid_574863 = path.getOrDefault("containerName")
  valid_574863 = validateParameter(valid_574863, JString, required = true,
                                 default = nil)
  if valid_574863 != nil:
    section.add "containerName", valid_574863
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
  var valid_574866 = path.getOrDefault("accountName")
  valid_574866 = validateParameter(valid_574866, JString, required = true,
                                 default = nil)
  if valid_574866 != nil:
    section.add "accountName", valid_574866
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574867 = query.getOrDefault("api-version")
  valid_574867 = validateParameter(valid_574867, JString, required = true,
                                 default = nil)
  if valid_574867 != nil:
    section.add "api-version", valid_574867
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

proc call*(call_574869: Call_DatabaseAccountsUpdateSqlContainerThroughput_574859;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB SQL container
  ## 
  let valid = call_574869.validator(path, query, header, formData, body)
  let scheme = call_574869.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574869.url(scheme.get, call_574869.host, call_574869.base,
                         call_574869.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574869, url, valid)

proc call*(call_574870: Call_DatabaseAccountsUpdateSqlContainerThroughput_574859;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; databaseName: string;
          updateThroughputParameters: JsonNode; accountName: string): Recallable =
  ## databaseAccountsUpdateSqlContainerThroughput
  ## Update RUs per second of an Azure Cosmos DB SQL container
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_574871 = newJObject()
  var query_574872 = newJObject()
  var body_574873 = newJObject()
  add(path_574871, "resourceGroupName", newJString(resourceGroupName))
  add(query_574872, "api-version", newJString(apiVersion))
  add(path_574871, "containerName", newJString(containerName))
  add(path_574871, "subscriptionId", newJString(subscriptionId))
  add(path_574871, "databaseName", newJString(databaseName))
  if updateThroughputParameters != nil:
    body_574873 = updateThroughputParameters
  add(path_574871, "accountName", newJString(accountName))
  result = call_574870.call(path_574871, query_574872, nil, nil, body_574873)

var databaseAccountsUpdateSqlContainerThroughput* = Call_DatabaseAccountsUpdateSqlContainerThroughput_574859(
    name: "databaseAccountsUpdateSqlContainerThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/containers/{containerName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateSqlContainerThroughput_574860,
    base: "", url: url_DatabaseAccountsUpdateSqlContainerThroughput_574861,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetSqlContainerThroughput_574846 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsGetSqlContainerThroughput_574848(protocol: Scheme;
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

proc validate_DatabaseAccountsGetSqlContainerThroughput_574847(path: JsonNode;
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
  var valid_574849 = path.getOrDefault("resourceGroupName")
  valid_574849 = validateParameter(valid_574849, JString, required = true,
                                 default = nil)
  if valid_574849 != nil:
    section.add "resourceGroupName", valid_574849
  var valid_574850 = path.getOrDefault("containerName")
  valid_574850 = validateParameter(valid_574850, JString, required = true,
                                 default = nil)
  if valid_574850 != nil:
    section.add "containerName", valid_574850
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
  var valid_574853 = path.getOrDefault("accountName")
  valid_574853 = validateParameter(valid_574853, JString, required = true,
                                 default = nil)
  if valid_574853 != nil:
    section.add "accountName", valid_574853
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574854 = query.getOrDefault("api-version")
  valid_574854 = validateParameter(valid_574854, JString, required = true,
                                 default = nil)
  if valid_574854 != nil:
    section.add "api-version", valid_574854
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574855: Call_DatabaseAccountsGetSqlContainerThroughput_574846;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the SQL container under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_574855.validator(path, query, header, formData, body)
  let scheme = call_574855.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574855.url(scheme.get, call_574855.host, call_574855.base,
                         call_574855.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574855, url, valid)

proc call*(call_574856: Call_DatabaseAccountsGetSqlContainerThroughput_574846;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; databaseName: string; accountName: string): Recallable =
  ## databaseAccountsGetSqlContainerThroughput
  ## Gets the RUs per second of the SQL container under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   containerName: string (required)
  ##                : Cosmos DB container name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574857 = newJObject()
  var query_574858 = newJObject()
  add(path_574857, "resourceGroupName", newJString(resourceGroupName))
  add(query_574858, "api-version", newJString(apiVersion))
  add(path_574857, "containerName", newJString(containerName))
  add(path_574857, "subscriptionId", newJString(subscriptionId))
  add(path_574857, "databaseName", newJString(databaseName))
  add(path_574857, "accountName", newJString(accountName))
  result = call_574856.call(path_574857, query_574858, nil, nil, nil)

var databaseAccountsGetSqlContainerThroughput* = Call_DatabaseAccountsGetSqlContainerThroughput_574846(
    name: "databaseAccountsGetSqlContainerThroughput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/containers/{containerName}/settings/throughput",
    validator: validate_DatabaseAccountsGetSqlContainerThroughput_574847,
    base: "", url: url_DatabaseAccountsGetSqlContainerThroughput_574848,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateSqlDatabaseThroughput_574886 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsUpdateSqlDatabaseThroughput_574888(protocol: Scheme;
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

proc validate_DatabaseAccountsUpdateSqlDatabaseThroughput_574887(path: JsonNode;
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
  var valid_574889 = path.getOrDefault("resourceGroupName")
  valid_574889 = validateParameter(valid_574889, JString, required = true,
                                 default = nil)
  if valid_574889 != nil:
    section.add "resourceGroupName", valid_574889
  var valid_574890 = path.getOrDefault("subscriptionId")
  valid_574890 = validateParameter(valid_574890, JString, required = true,
                                 default = nil)
  if valid_574890 != nil:
    section.add "subscriptionId", valid_574890
  var valid_574891 = path.getOrDefault("databaseName")
  valid_574891 = validateParameter(valid_574891, JString, required = true,
                                 default = nil)
  if valid_574891 != nil:
    section.add "databaseName", valid_574891
  var valid_574892 = path.getOrDefault("accountName")
  valid_574892 = validateParameter(valid_574892, JString, required = true,
                                 default = nil)
  if valid_574892 != nil:
    section.add "accountName", valid_574892
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574893 = query.getOrDefault("api-version")
  valid_574893 = validateParameter(valid_574893, JString, required = true,
                                 default = nil)
  if valid_574893 != nil:
    section.add "api-version", valid_574893
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

proc call*(call_574895: Call_DatabaseAccountsUpdateSqlDatabaseThroughput_574886;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB SQL database
  ## 
  let valid = call_574895.validator(path, query, header, formData, body)
  let scheme = call_574895.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574895.url(scheme.get, call_574895.host, call_574895.base,
                         call_574895.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574895, url, valid)

proc call*(call_574896: Call_DatabaseAccountsUpdateSqlDatabaseThroughput_574886;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; updateThroughputParameters: JsonNode;
          accountName: string): Recallable =
  ## databaseAccountsUpdateSqlDatabaseThroughput
  ## Update RUs per second of an Azure Cosmos DB SQL database
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   updateThroughputParameters: JObject (required)
  ##                             : The parameters to provide for the RUs per second of the current SQL database.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574897 = newJObject()
  var query_574898 = newJObject()
  var body_574899 = newJObject()
  add(path_574897, "resourceGroupName", newJString(resourceGroupName))
  add(query_574898, "api-version", newJString(apiVersion))
  add(path_574897, "subscriptionId", newJString(subscriptionId))
  add(path_574897, "databaseName", newJString(databaseName))
  if updateThroughputParameters != nil:
    body_574899 = updateThroughputParameters
  add(path_574897, "accountName", newJString(accountName))
  result = call_574896.call(path_574897, query_574898, nil, nil, body_574899)

var databaseAccountsUpdateSqlDatabaseThroughput* = Call_DatabaseAccountsUpdateSqlDatabaseThroughput_574886(
    name: "databaseAccountsUpdateSqlDatabaseThroughput", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateSqlDatabaseThroughput_574887,
    base: "", url: url_DatabaseAccountsUpdateSqlDatabaseThroughput_574888,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetSqlDatabaseThroughput_574874 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsGetSqlDatabaseThroughput_574876(protocol: Scheme;
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

proc validate_DatabaseAccountsGetSqlDatabaseThroughput_574875(path: JsonNode;
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
  var valid_574877 = path.getOrDefault("resourceGroupName")
  valid_574877 = validateParameter(valid_574877, JString, required = true,
                                 default = nil)
  if valid_574877 != nil:
    section.add "resourceGroupName", valid_574877
  var valid_574878 = path.getOrDefault("subscriptionId")
  valid_574878 = validateParameter(valid_574878, JString, required = true,
                                 default = nil)
  if valid_574878 != nil:
    section.add "subscriptionId", valid_574878
  var valid_574879 = path.getOrDefault("databaseName")
  valid_574879 = validateParameter(valid_574879, JString, required = true,
                                 default = nil)
  if valid_574879 != nil:
    section.add "databaseName", valid_574879
  var valid_574880 = path.getOrDefault("accountName")
  valid_574880 = validateParameter(valid_574880, JString, required = true,
                                 default = nil)
  if valid_574880 != nil:
    section.add "accountName", valid_574880
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574881 = query.getOrDefault("api-version")
  valid_574881 = validateParameter(valid_574881, JString, required = true,
                                 default = nil)
  if valid_574881 != nil:
    section.add "api-version", valid_574881
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574882: Call_DatabaseAccountsGetSqlDatabaseThroughput_574874;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the SQL database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_574882.validator(path, query, header, formData, body)
  let scheme = call_574882.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574882.url(scheme.get, call_574882.host, call_574882.base,
                         call_574882.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574882, url, valid)

proc call*(call_574883: Call_DatabaseAccountsGetSqlDatabaseThroughput_574874;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseName: string; accountName: string): Recallable =
  ## databaseAccountsGetSqlDatabaseThroughput
  ## Gets the RUs per second of the SQL database under an existing Azure Cosmos DB database account with the provided name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseName: string (required)
  ##               : Cosmos DB database name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574884 = newJObject()
  var query_574885 = newJObject()
  add(path_574884, "resourceGroupName", newJString(resourceGroupName))
  add(query_574885, "api-version", newJString(apiVersion))
  add(path_574884, "subscriptionId", newJString(subscriptionId))
  add(path_574884, "databaseName", newJString(databaseName))
  add(path_574884, "accountName", newJString(accountName))
  result = call_574883.call(path_574884, query_574885, nil, nil, nil)

var databaseAccountsGetSqlDatabaseThroughput* = Call_DatabaseAccountsGetSqlDatabaseThroughput_574874(
    name: "databaseAccountsGetSqlDatabaseThroughput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/settings/throughput",
    validator: validate_DatabaseAccountsGetSqlDatabaseThroughput_574875, base: "",
    url: url_DatabaseAccountsGetSqlDatabaseThroughput_574876,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListTables_574900 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsListTables_574902(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListTables_574901(path: JsonNode; query: JsonNode;
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
  var valid_574903 = path.getOrDefault("resourceGroupName")
  valid_574903 = validateParameter(valid_574903, JString, required = true,
                                 default = nil)
  if valid_574903 != nil:
    section.add "resourceGroupName", valid_574903
  var valid_574904 = path.getOrDefault("subscriptionId")
  valid_574904 = validateParameter(valid_574904, JString, required = true,
                                 default = nil)
  if valid_574904 != nil:
    section.add "subscriptionId", valid_574904
  var valid_574905 = path.getOrDefault("accountName")
  valid_574905 = validateParameter(valid_574905, JString, required = true,
                                 default = nil)
  if valid_574905 != nil:
    section.add "accountName", valid_574905
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574906 = query.getOrDefault("api-version")
  valid_574906 = validateParameter(valid_574906, JString, required = true,
                                 default = nil)
  if valid_574906 != nil:
    section.add "api-version", valid_574906
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574907: Call_DatabaseAccountsListTables_574900; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Tables under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_574907.validator(path, query, header, formData, body)
  let scheme = call_574907.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574907.url(scheme.get, call_574907.host, call_574907.base,
                         call_574907.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574907, url, valid)

proc call*(call_574908: Call_DatabaseAccountsListTables_574900;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## databaseAccountsListTables
  ## Lists the Tables under an existing Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574909 = newJObject()
  var query_574910 = newJObject()
  add(path_574909, "resourceGroupName", newJString(resourceGroupName))
  add(query_574910, "api-version", newJString(apiVersion))
  add(path_574909, "subscriptionId", newJString(subscriptionId))
  add(path_574909, "accountName", newJString(accountName))
  result = call_574908.call(path_574909, query_574910, nil, nil, nil)

var databaseAccountsListTables* = Call_DatabaseAccountsListTables_574900(
    name: "databaseAccountsListTables", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/table/tables",
    validator: validate_DatabaseAccountsListTables_574901, base: "",
    url: url_DatabaseAccountsListTables_574902, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateTable_574923 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsCreateUpdateTable_574925(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsCreateUpdateTable_574924(path: JsonNode;
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
  var valid_574926 = path.getOrDefault("resourceGroupName")
  valid_574926 = validateParameter(valid_574926, JString, required = true,
                                 default = nil)
  if valid_574926 != nil:
    section.add "resourceGroupName", valid_574926
  var valid_574927 = path.getOrDefault("subscriptionId")
  valid_574927 = validateParameter(valid_574927, JString, required = true,
                                 default = nil)
  if valid_574927 != nil:
    section.add "subscriptionId", valid_574927
  var valid_574928 = path.getOrDefault("tableName")
  valid_574928 = validateParameter(valid_574928, JString, required = true,
                                 default = nil)
  if valid_574928 != nil:
    section.add "tableName", valid_574928
  var valid_574929 = path.getOrDefault("accountName")
  valid_574929 = validateParameter(valid_574929, JString, required = true,
                                 default = nil)
  if valid_574929 != nil:
    section.add "accountName", valid_574929
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574930 = query.getOrDefault("api-version")
  valid_574930 = validateParameter(valid_574930, JString, required = true,
                                 default = nil)
  if valid_574930 != nil:
    section.add "api-version", valid_574930
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

proc call*(call_574932: Call_DatabaseAccountsCreateUpdateTable_574923;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB Table
  ## 
  let valid = call_574932.validator(path, query, header, formData, body)
  let scheme = call_574932.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574932.url(scheme.get, call_574932.host, call_574932.base,
                         call_574932.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574932, url, valid)

proc call*(call_574933: Call_DatabaseAccountsCreateUpdateTable_574923;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          tableName: string; createUpdateTableParameters: JsonNode;
          accountName: string): Recallable =
  ## databaseAccountsCreateUpdateTable
  ## Create or update an Azure Cosmos DB Table
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   createUpdateTableParameters: JObject (required)
  ##                              : The parameters to provide for the current Table.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574934 = newJObject()
  var query_574935 = newJObject()
  var body_574936 = newJObject()
  add(path_574934, "resourceGroupName", newJString(resourceGroupName))
  add(query_574935, "api-version", newJString(apiVersion))
  add(path_574934, "subscriptionId", newJString(subscriptionId))
  add(path_574934, "tableName", newJString(tableName))
  if createUpdateTableParameters != nil:
    body_574936 = createUpdateTableParameters
  add(path_574934, "accountName", newJString(accountName))
  result = call_574933.call(path_574934, query_574935, nil, nil, body_574936)

var databaseAccountsCreateUpdateTable* = Call_DatabaseAccountsCreateUpdateTable_574923(
    name: "databaseAccountsCreateUpdateTable", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/table/tables/{tableName}",
    validator: validate_DatabaseAccountsCreateUpdateTable_574924, base: "",
    url: url_DatabaseAccountsCreateUpdateTable_574925, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetTable_574911 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsGetTable_574913(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsGetTable_574912(path: JsonNode; query: JsonNode;
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
  var valid_574914 = path.getOrDefault("resourceGroupName")
  valid_574914 = validateParameter(valid_574914, JString, required = true,
                                 default = nil)
  if valid_574914 != nil:
    section.add "resourceGroupName", valid_574914
  var valid_574915 = path.getOrDefault("subscriptionId")
  valid_574915 = validateParameter(valid_574915, JString, required = true,
                                 default = nil)
  if valid_574915 != nil:
    section.add "subscriptionId", valid_574915
  var valid_574916 = path.getOrDefault("tableName")
  valid_574916 = validateParameter(valid_574916, JString, required = true,
                                 default = nil)
  if valid_574916 != nil:
    section.add "tableName", valid_574916
  var valid_574917 = path.getOrDefault("accountName")
  valid_574917 = validateParameter(valid_574917, JString, required = true,
                                 default = nil)
  if valid_574917 != nil:
    section.add "accountName", valid_574917
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574918 = query.getOrDefault("api-version")
  valid_574918 = validateParameter(valid_574918, JString, required = true,
                                 default = nil)
  if valid_574918 != nil:
    section.add "api-version", valid_574918
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574919: Call_DatabaseAccountsGetTable_574911; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Tables under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_574919.validator(path, query, header, formData, body)
  let scheme = call_574919.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574919.url(scheme.get, call_574919.host, call_574919.base,
                         call_574919.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574919, url, valid)

proc call*(call_574920: Call_DatabaseAccountsGetTable_574911;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          tableName: string; accountName: string): Recallable =
  ## databaseAccountsGetTable
  ## Gets the Tables under an existing Azure Cosmos DB database account with the provided name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574921 = newJObject()
  var query_574922 = newJObject()
  add(path_574921, "resourceGroupName", newJString(resourceGroupName))
  add(query_574922, "api-version", newJString(apiVersion))
  add(path_574921, "subscriptionId", newJString(subscriptionId))
  add(path_574921, "tableName", newJString(tableName))
  add(path_574921, "accountName", newJString(accountName))
  result = call_574920.call(path_574921, query_574922, nil, nil, nil)

var databaseAccountsGetTable* = Call_DatabaseAccountsGetTable_574911(
    name: "databaseAccountsGetTable", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/table/tables/{tableName}",
    validator: validate_DatabaseAccountsGetTable_574912, base: "",
    url: url_DatabaseAccountsGetTable_574913, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteTable_574937 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsDeleteTable_574939(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsDeleteTable_574938(path: JsonNode; query: JsonNode;
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
  var valid_574940 = path.getOrDefault("resourceGroupName")
  valid_574940 = validateParameter(valid_574940, JString, required = true,
                                 default = nil)
  if valid_574940 != nil:
    section.add "resourceGroupName", valid_574940
  var valid_574941 = path.getOrDefault("subscriptionId")
  valid_574941 = validateParameter(valid_574941, JString, required = true,
                                 default = nil)
  if valid_574941 != nil:
    section.add "subscriptionId", valid_574941
  var valid_574942 = path.getOrDefault("tableName")
  valid_574942 = validateParameter(valid_574942, JString, required = true,
                                 default = nil)
  if valid_574942 != nil:
    section.add "tableName", valid_574942
  var valid_574943 = path.getOrDefault("accountName")
  valid_574943 = validateParameter(valid_574943, JString, required = true,
                                 default = nil)
  if valid_574943 != nil:
    section.add "accountName", valid_574943
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574944 = query.getOrDefault("api-version")
  valid_574944 = validateParameter(valid_574944, JString, required = true,
                                 default = nil)
  if valid_574944 != nil:
    section.add "api-version", valid_574944
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574945: Call_DatabaseAccountsDeleteTable_574937; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB Table.
  ## 
  let valid = call_574945.validator(path, query, header, formData, body)
  let scheme = call_574945.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574945.url(scheme.get, call_574945.host, call_574945.base,
                         call_574945.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574945, url, valid)

proc call*(call_574946: Call_DatabaseAccountsDeleteTable_574937;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          tableName: string; accountName: string): Recallable =
  ## databaseAccountsDeleteTable
  ## Deletes an existing Azure Cosmos DB Table.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574947 = newJObject()
  var query_574948 = newJObject()
  add(path_574947, "resourceGroupName", newJString(resourceGroupName))
  add(query_574948, "api-version", newJString(apiVersion))
  add(path_574947, "subscriptionId", newJString(subscriptionId))
  add(path_574947, "tableName", newJString(tableName))
  add(path_574947, "accountName", newJString(accountName))
  result = call_574946.call(path_574947, query_574948, nil, nil, nil)

var databaseAccountsDeleteTable* = Call_DatabaseAccountsDeleteTable_574937(
    name: "databaseAccountsDeleteTable", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/table/tables/{tableName}",
    validator: validate_DatabaseAccountsDeleteTable_574938, base: "",
    url: url_DatabaseAccountsDeleteTable_574939, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateTableThroughput_574961 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsUpdateTableThroughput_574963(protocol: Scheme;
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

proc validate_DatabaseAccountsUpdateTableThroughput_574962(path: JsonNode;
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
  var valid_574964 = path.getOrDefault("resourceGroupName")
  valid_574964 = validateParameter(valid_574964, JString, required = true,
                                 default = nil)
  if valid_574964 != nil:
    section.add "resourceGroupName", valid_574964
  var valid_574965 = path.getOrDefault("subscriptionId")
  valid_574965 = validateParameter(valid_574965, JString, required = true,
                                 default = nil)
  if valid_574965 != nil:
    section.add "subscriptionId", valid_574965
  var valid_574966 = path.getOrDefault("tableName")
  valid_574966 = validateParameter(valid_574966, JString, required = true,
                                 default = nil)
  if valid_574966 != nil:
    section.add "tableName", valid_574966
  var valid_574967 = path.getOrDefault("accountName")
  valid_574967 = validateParameter(valid_574967, JString, required = true,
                                 default = nil)
  if valid_574967 != nil:
    section.add "accountName", valid_574967
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574968 = query.getOrDefault("api-version")
  valid_574968 = validateParameter(valid_574968, JString, required = true,
                                 default = nil)
  if valid_574968 != nil:
    section.add "api-version", valid_574968
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

proc call*(call_574970: Call_DatabaseAccountsUpdateTableThroughput_574961;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Table
  ## 
  let valid = call_574970.validator(path, query, header, formData, body)
  let scheme = call_574970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574970.url(scheme.get, call_574970.host, call_574970.base,
                         call_574970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574970, url, valid)

proc call*(call_574971: Call_DatabaseAccountsUpdateTableThroughput_574961;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          tableName: string; updateThroughputParameters: JsonNode;
          accountName: string): Recallable =
  ## databaseAccountsUpdateTableThroughput
  ## Update RUs per second of an Azure Cosmos DB Table
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   updateThroughputParameters: JObject (required)
  ##                             : The parameters to provide for the RUs per second of the current Table.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574972 = newJObject()
  var query_574973 = newJObject()
  var body_574974 = newJObject()
  add(path_574972, "resourceGroupName", newJString(resourceGroupName))
  add(query_574973, "api-version", newJString(apiVersion))
  add(path_574972, "subscriptionId", newJString(subscriptionId))
  add(path_574972, "tableName", newJString(tableName))
  if updateThroughputParameters != nil:
    body_574974 = updateThroughputParameters
  add(path_574972, "accountName", newJString(accountName))
  result = call_574971.call(path_574972, query_574973, nil, nil, body_574974)

var databaseAccountsUpdateTableThroughput* = Call_DatabaseAccountsUpdateTableThroughput_574961(
    name: "databaseAccountsUpdateTableThroughput", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/table/tables/{tableName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateTableThroughput_574962, base: "",
    url: url_DatabaseAccountsUpdateTableThroughput_574963, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetTableThroughput_574949 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsGetTableThroughput_574951(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsGetTableThroughput_574950(path: JsonNode;
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
  var valid_574952 = path.getOrDefault("resourceGroupName")
  valid_574952 = validateParameter(valid_574952, JString, required = true,
                                 default = nil)
  if valid_574952 != nil:
    section.add "resourceGroupName", valid_574952
  var valid_574953 = path.getOrDefault("subscriptionId")
  valid_574953 = validateParameter(valid_574953, JString, required = true,
                                 default = nil)
  if valid_574953 != nil:
    section.add "subscriptionId", valid_574953
  var valid_574954 = path.getOrDefault("tableName")
  valid_574954 = validateParameter(valid_574954, JString, required = true,
                                 default = nil)
  if valid_574954 != nil:
    section.add "tableName", valid_574954
  var valid_574955 = path.getOrDefault("accountName")
  valid_574955 = validateParameter(valid_574955, JString, required = true,
                                 default = nil)
  if valid_574955 != nil:
    section.add "accountName", valid_574955
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574956 = query.getOrDefault("api-version")
  valid_574956 = validateParameter(valid_574956, JString, required = true,
                                 default = nil)
  if valid_574956 != nil:
    section.add "api-version", valid_574956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574957: Call_DatabaseAccountsGetTableThroughput_574949;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the Table under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_574957.validator(path, query, header, formData, body)
  let scheme = call_574957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574957.url(scheme.get, call_574957.host, call_574957.base,
                         call_574957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574957, url, valid)

proc call*(call_574958: Call_DatabaseAccountsGetTableThroughput_574949;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          tableName: string; accountName: string): Recallable =
  ## databaseAccountsGetTableThroughput
  ## Gets the RUs per second of the Table under an existing Azure Cosmos DB database account with the provided name.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   tableName: string (required)
  ##            : Cosmos DB table name.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574959 = newJObject()
  var query_574960 = newJObject()
  add(path_574959, "resourceGroupName", newJString(resourceGroupName))
  add(query_574960, "api-version", newJString(apiVersion))
  add(path_574959, "subscriptionId", newJString(subscriptionId))
  add(path_574959, "tableName", newJString(tableName))
  add(path_574959, "accountName", newJString(accountName))
  result = call_574958.call(path_574959, query_574960, nil, nil, nil)

var databaseAccountsGetTableThroughput* = Call_DatabaseAccountsGetTableThroughput_574949(
    name: "databaseAccountsGetTableThroughput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/table/tables/{tableName}/settings/throughput",
    validator: validate_DatabaseAccountsGetTableThroughput_574950, base: "",
    url: url_DatabaseAccountsGetTableThroughput_574951, schemes: {Scheme.Https})
type
  Call_CollectionListMetricDefinitions_574975 = ref object of OpenApiRestCall_573668
proc url_CollectionListMetricDefinitions_574977(protocol: Scheme; host: string;
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

proc validate_CollectionListMetricDefinitions_574976(path: JsonNode;
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
  var valid_574978 = path.getOrDefault("resourceGroupName")
  valid_574978 = validateParameter(valid_574978, JString, required = true,
                                 default = nil)
  if valid_574978 != nil:
    section.add "resourceGroupName", valid_574978
  var valid_574979 = path.getOrDefault("collectionRid")
  valid_574979 = validateParameter(valid_574979, JString, required = true,
                                 default = nil)
  if valid_574979 != nil:
    section.add "collectionRid", valid_574979
  var valid_574980 = path.getOrDefault("subscriptionId")
  valid_574980 = validateParameter(valid_574980, JString, required = true,
                                 default = nil)
  if valid_574980 != nil:
    section.add "subscriptionId", valid_574980
  var valid_574981 = path.getOrDefault("databaseRid")
  valid_574981 = validateParameter(valid_574981, JString, required = true,
                                 default = nil)
  if valid_574981 != nil:
    section.add "databaseRid", valid_574981
  var valid_574982 = path.getOrDefault("accountName")
  valid_574982 = validateParameter(valid_574982, JString, required = true,
                                 default = nil)
  if valid_574982 != nil:
    section.add "accountName", valid_574982
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574983 = query.getOrDefault("api-version")
  valid_574983 = validateParameter(valid_574983, JString, required = true,
                                 default = nil)
  if valid_574983 != nil:
    section.add "api-version", valid_574983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574984: Call_CollectionListMetricDefinitions_574975;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves metric definitions for the given collection.
  ## 
  let valid = call_574984.validator(path, query, header, formData, body)
  let scheme = call_574984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574984.url(scheme.get, call_574984.host, call_574984.base,
                         call_574984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574984, url, valid)

proc call*(call_574985: Call_CollectionListMetricDefinitions_574975;
          resourceGroupName: string; apiVersion: string; collectionRid: string;
          subscriptionId: string; databaseRid: string; accountName: string): Recallable =
  ## collectionListMetricDefinitions
  ## Retrieves metric definitions for the given collection.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   collectionRid: string (required)
  ##                : Cosmos DB collection rid.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: string (required)
  ##              : Cosmos DB database rid.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_574986 = newJObject()
  var query_574987 = newJObject()
  add(path_574986, "resourceGroupName", newJString(resourceGroupName))
  add(query_574987, "api-version", newJString(apiVersion))
  add(path_574986, "collectionRid", newJString(collectionRid))
  add(path_574986, "subscriptionId", newJString(subscriptionId))
  add(path_574986, "databaseRid", newJString(databaseRid))
  add(path_574986, "accountName", newJString(accountName))
  result = call_574985.call(path_574986, query_574987, nil, nil, nil)

var collectionListMetricDefinitions* = Call_CollectionListMetricDefinitions_574975(
    name: "collectionListMetricDefinitions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/metricDefinitions",
    validator: validate_CollectionListMetricDefinitions_574976, base: "",
    url: url_CollectionListMetricDefinitions_574977, schemes: {Scheme.Https})
type
  Call_CollectionListMetrics_574988 = ref object of OpenApiRestCall_573668
proc url_CollectionListMetrics_574990(protocol: Scheme; host: string; base: string;
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

proc validate_CollectionListMetrics_574989(path: JsonNode; query: JsonNode;
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
  var valid_574992 = path.getOrDefault("resourceGroupName")
  valid_574992 = validateParameter(valid_574992, JString, required = true,
                                 default = nil)
  if valid_574992 != nil:
    section.add "resourceGroupName", valid_574992
  var valid_574993 = path.getOrDefault("collectionRid")
  valid_574993 = validateParameter(valid_574993, JString, required = true,
                                 default = nil)
  if valid_574993 != nil:
    section.add "collectionRid", valid_574993
  var valid_574994 = path.getOrDefault("subscriptionId")
  valid_574994 = validateParameter(valid_574994, JString, required = true,
                                 default = nil)
  if valid_574994 != nil:
    section.add "subscriptionId", valid_574994
  var valid_574995 = path.getOrDefault("databaseRid")
  valid_574995 = validateParameter(valid_574995, JString, required = true,
                                 default = nil)
  if valid_574995 != nil:
    section.add "databaseRid", valid_574995
  var valid_574996 = path.getOrDefault("accountName")
  valid_574996 = validateParameter(valid_574996, JString, required = true,
                                 default = nil)
  if valid_574996 != nil:
    section.add "accountName", valid_574996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574997 = query.getOrDefault("api-version")
  valid_574997 = validateParameter(valid_574997, JString, required = true,
                                 default = nil)
  if valid_574997 != nil:
    section.add "api-version", valid_574997
  var valid_574998 = query.getOrDefault("$filter")
  valid_574998 = validateParameter(valid_574998, JString, required = true,
                                 default = nil)
  if valid_574998 != nil:
    section.add "$filter", valid_574998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574999: Call_CollectionListMetrics_574988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account and collection.
  ## 
  let valid = call_574999.validator(path, query, header, formData, body)
  let scheme = call_574999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574999.url(scheme.get, call_574999.host, call_574999.base,
                         call_574999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574999, url, valid)

proc call*(call_575000: Call_CollectionListMetrics_574988;
          resourceGroupName: string; apiVersion: string; collectionRid: string;
          subscriptionId: string; databaseRid: string; accountName: string;
          Filter: string): Recallable =
  ## collectionListMetrics
  ## Retrieves the metrics determined by the given filter for the given database account and collection.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_575001 = newJObject()
  var query_575002 = newJObject()
  add(path_575001, "resourceGroupName", newJString(resourceGroupName))
  add(query_575002, "api-version", newJString(apiVersion))
  add(path_575001, "collectionRid", newJString(collectionRid))
  add(path_575001, "subscriptionId", newJString(subscriptionId))
  add(path_575001, "databaseRid", newJString(databaseRid))
  add(path_575001, "accountName", newJString(accountName))
  add(query_575002, "$filter", newJString(Filter))
  result = call_575000.call(path_575001, query_575002, nil, nil, nil)

var collectionListMetrics* = Call_CollectionListMetrics_574988(
    name: "collectionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/metrics",
    validator: validate_CollectionListMetrics_574989, base: "",
    url: url_CollectionListMetrics_574990, schemes: {Scheme.Https})
type
  Call_PartitionKeyRangeIdListMetrics_575003 = ref object of OpenApiRestCall_573668
proc url_PartitionKeyRangeIdListMetrics_575005(protocol: Scheme; host: string;
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

proc validate_PartitionKeyRangeIdListMetrics_575004(path: JsonNode;
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
  var valid_575006 = path.getOrDefault("resourceGroupName")
  valid_575006 = validateParameter(valid_575006, JString, required = true,
                                 default = nil)
  if valid_575006 != nil:
    section.add "resourceGroupName", valid_575006
  var valid_575007 = path.getOrDefault("collectionRid")
  valid_575007 = validateParameter(valid_575007, JString, required = true,
                                 default = nil)
  if valid_575007 != nil:
    section.add "collectionRid", valid_575007
  var valid_575008 = path.getOrDefault("subscriptionId")
  valid_575008 = validateParameter(valid_575008, JString, required = true,
                                 default = nil)
  if valid_575008 != nil:
    section.add "subscriptionId", valid_575008
  var valid_575009 = path.getOrDefault("partitionKeyRangeId")
  valid_575009 = validateParameter(valid_575009, JString, required = true,
                                 default = nil)
  if valid_575009 != nil:
    section.add "partitionKeyRangeId", valid_575009
  var valid_575010 = path.getOrDefault("databaseRid")
  valid_575010 = validateParameter(valid_575010, JString, required = true,
                                 default = nil)
  if valid_575010 != nil:
    section.add "databaseRid", valid_575010
  var valid_575011 = path.getOrDefault("accountName")
  valid_575011 = validateParameter(valid_575011, JString, required = true,
                                 default = nil)
  if valid_575011 != nil:
    section.add "accountName", valid_575011
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575012 = query.getOrDefault("api-version")
  valid_575012 = validateParameter(valid_575012, JString, required = true,
                                 default = nil)
  if valid_575012 != nil:
    section.add "api-version", valid_575012
  var valid_575013 = query.getOrDefault("$filter")
  valid_575013 = validateParameter(valid_575013, JString, required = true,
                                 default = nil)
  if valid_575013 != nil:
    section.add "$filter", valid_575013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575014: Call_PartitionKeyRangeIdListMetrics_575003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given partition key range id.
  ## 
  let valid = call_575014.validator(path, query, header, formData, body)
  let scheme = call_575014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575014.url(scheme.get, call_575014.host, call_575014.base,
                         call_575014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575014, url, valid)

proc call*(call_575015: Call_PartitionKeyRangeIdListMetrics_575003;
          resourceGroupName: string; apiVersion: string; collectionRid: string;
          subscriptionId: string; partitionKeyRangeId: string; databaseRid: string;
          accountName: string; Filter: string): Recallable =
  ## partitionKeyRangeIdListMetrics
  ## Retrieves the metrics determined by the given filter for the given partition key range id.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_575016 = newJObject()
  var query_575017 = newJObject()
  add(path_575016, "resourceGroupName", newJString(resourceGroupName))
  add(query_575017, "api-version", newJString(apiVersion))
  add(path_575016, "collectionRid", newJString(collectionRid))
  add(path_575016, "subscriptionId", newJString(subscriptionId))
  add(path_575016, "partitionKeyRangeId", newJString(partitionKeyRangeId))
  add(path_575016, "databaseRid", newJString(databaseRid))
  add(path_575016, "accountName", newJString(accountName))
  add(query_575017, "$filter", newJString(Filter))
  result = call_575015.call(path_575016, query_575017, nil, nil, nil)

var partitionKeyRangeIdListMetrics* = Call_PartitionKeyRangeIdListMetrics_575003(
    name: "partitionKeyRangeIdListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/partitionKeyRangeId/{partitionKeyRangeId}/metrics",
    validator: validate_PartitionKeyRangeIdListMetrics_575004, base: "",
    url: url_PartitionKeyRangeIdListMetrics_575005, schemes: {Scheme.Https})
type
  Call_CollectionPartitionListMetrics_575018 = ref object of OpenApiRestCall_573668
proc url_CollectionPartitionListMetrics_575020(protocol: Scheme; host: string;
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

proc validate_CollectionPartitionListMetrics_575019(path: JsonNode;
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
  var valid_575021 = path.getOrDefault("resourceGroupName")
  valid_575021 = validateParameter(valid_575021, JString, required = true,
                                 default = nil)
  if valid_575021 != nil:
    section.add "resourceGroupName", valid_575021
  var valid_575022 = path.getOrDefault("collectionRid")
  valid_575022 = validateParameter(valid_575022, JString, required = true,
                                 default = nil)
  if valid_575022 != nil:
    section.add "collectionRid", valid_575022
  var valid_575023 = path.getOrDefault("subscriptionId")
  valid_575023 = validateParameter(valid_575023, JString, required = true,
                                 default = nil)
  if valid_575023 != nil:
    section.add "subscriptionId", valid_575023
  var valid_575024 = path.getOrDefault("databaseRid")
  valid_575024 = validateParameter(valid_575024, JString, required = true,
                                 default = nil)
  if valid_575024 != nil:
    section.add "databaseRid", valid_575024
  var valid_575025 = path.getOrDefault("accountName")
  valid_575025 = validateParameter(valid_575025, JString, required = true,
                                 default = nil)
  if valid_575025 != nil:
    section.add "accountName", valid_575025
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575026 = query.getOrDefault("api-version")
  valid_575026 = validateParameter(valid_575026, JString, required = true,
                                 default = nil)
  if valid_575026 != nil:
    section.add "api-version", valid_575026
  var valid_575027 = query.getOrDefault("$filter")
  valid_575027 = validateParameter(valid_575027, JString, required = true,
                                 default = nil)
  if valid_575027 != nil:
    section.add "$filter", valid_575027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575028: Call_CollectionPartitionListMetrics_575018; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given collection, split by partition.
  ## 
  let valid = call_575028.validator(path, query, header, formData, body)
  let scheme = call_575028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575028.url(scheme.get, call_575028.host, call_575028.base,
                         call_575028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575028, url, valid)

proc call*(call_575029: Call_CollectionPartitionListMetrics_575018;
          resourceGroupName: string; apiVersion: string; collectionRid: string;
          subscriptionId: string; databaseRid: string; accountName: string;
          Filter: string): Recallable =
  ## collectionPartitionListMetrics
  ## Retrieves the metrics determined by the given filter for the given collection, split by partition.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_575030 = newJObject()
  var query_575031 = newJObject()
  add(path_575030, "resourceGroupName", newJString(resourceGroupName))
  add(query_575031, "api-version", newJString(apiVersion))
  add(path_575030, "collectionRid", newJString(collectionRid))
  add(path_575030, "subscriptionId", newJString(subscriptionId))
  add(path_575030, "databaseRid", newJString(databaseRid))
  add(path_575030, "accountName", newJString(accountName))
  add(query_575031, "$filter", newJString(Filter))
  result = call_575029.call(path_575030, query_575031, nil, nil, nil)

var collectionPartitionListMetrics* = Call_CollectionPartitionListMetrics_575018(
    name: "collectionPartitionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/partitions/metrics",
    validator: validate_CollectionPartitionListMetrics_575019, base: "",
    url: url_CollectionPartitionListMetrics_575020, schemes: {Scheme.Https})
type
  Call_CollectionPartitionListUsages_575032 = ref object of OpenApiRestCall_573668
proc url_CollectionPartitionListUsages_575034(protocol: Scheme; host: string;
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

proc validate_CollectionPartitionListUsages_575033(path: JsonNode; query: JsonNode;
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
  var valid_575035 = path.getOrDefault("resourceGroupName")
  valid_575035 = validateParameter(valid_575035, JString, required = true,
                                 default = nil)
  if valid_575035 != nil:
    section.add "resourceGroupName", valid_575035
  var valid_575036 = path.getOrDefault("collectionRid")
  valid_575036 = validateParameter(valid_575036, JString, required = true,
                                 default = nil)
  if valid_575036 != nil:
    section.add "collectionRid", valid_575036
  var valid_575037 = path.getOrDefault("subscriptionId")
  valid_575037 = validateParameter(valid_575037, JString, required = true,
                                 default = nil)
  if valid_575037 != nil:
    section.add "subscriptionId", valid_575037
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
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString
  ##          : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575040 = query.getOrDefault("api-version")
  valid_575040 = validateParameter(valid_575040, JString, required = true,
                                 default = nil)
  if valid_575040 != nil:
    section.add "api-version", valid_575040
  var valid_575041 = query.getOrDefault("$filter")
  valid_575041 = validateParameter(valid_575041, JString, required = false,
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

proc call*(call_575042: Call_CollectionPartitionListUsages_575032; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the usages (most recent storage data) for the given collection, split by partition.
  ## 
  let valid = call_575042.validator(path, query, header, formData, body)
  let scheme = call_575042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575042.url(scheme.get, call_575042.host, call_575042.base,
                         call_575042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575042, url, valid)

proc call*(call_575043: Call_CollectionPartitionListUsages_575032;
          resourceGroupName: string; apiVersion: string; collectionRid: string;
          subscriptionId: string; databaseRid: string; accountName: string;
          Filter: string = ""): Recallable =
  ## collectionPartitionListUsages
  ## Retrieves the usages (most recent storage data) for the given collection, split by partition.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_575044 = newJObject()
  var query_575045 = newJObject()
  add(path_575044, "resourceGroupName", newJString(resourceGroupName))
  add(query_575045, "api-version", newJString(apiVersion))
  add(path_575044, "collectionRid", newJString(collectionRid))
  add(path_575044, "subscriptionId", newJString(subscriptionId))
  add(path_575044, "databaseRid", newJString(databaseRid))
  add(path_575044, "accountName", newJString(accountName))
  add(query_575045, "$filter", newJString(Filter))
  result = call_575043.call(path_575044, query_575045, nil, nil, nil)

var collectionPartitionListUsages* = Call_CollectionPartitionListUsages_575032(
    name: "collectionPartitionListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/partitions/usages",
    validator: validate_CollectionPartitionListUsages_575033, base: "",
    url: url_CollectionPartitionListUsages_575034, schemes: {Scheme.Https})
type
  Call_CollectionListUsages_575046 = ref object of OpenApiRestCall_573668
proc url_CollectionListUsages_575048(protocol: Scheme; host: string; base: string;
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

proc validate_CollectionListUsages_575047(path: JsonNode; query: JsonNode;
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
  var valid_575052 = path.getOrDefault("databaseRid")
  valid_575052 = validateParameter(valid_575052, JString, required = true,
                                 default = nil)
  if valid_575052 != nil:
    section.add "databaseRid", valid_575052
  var valid_575053 = path.getOrDefault("accountName")
  valid_575053 = validateParameter(valid_575053, JString, required = true,
                                 default = nil)
  if valid_575053 != nil:
    section.add "accountName", valid_575053
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString
  ##          : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575054 = query.getOrDefault("api-version")
  valid_575054 = validateParameter(valid_575054, JString, required = true,
                                 default = nil)
  if valid_575054 != nil:
    section.add "api-version", valid_575054
  var valid_575055 = query.getOrDefault("$filter")
  valid_575055 = validateParameter(valid_575055, JString, required = false,
                                 default = nil)
  if valid_575055 != nil:
    section.add "$filter", valid_575055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575056: Call_CollectionListUsages_575046; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the usages (most recent storage data) for the given collection.
  ## 
  let valid = call_575056.validator(path, query, header, formData, body)
  let scheme = call_575056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575056.url(scheme.get, call_575056.host, call_575056.base,
                         call_575056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575056, url, valid)

proc call*(call_575057: Call_CollectionListUsages_575046;
          resourceGroupName: string; apiVersion: string; collectionRid: string;
          subscriptionId: string; databaseRid: string; accountName: string;
          Filter: string = ""): Recallable =
  ## collectionListUsages
  ## Retrieves the usages (most recent storage data) for the given collection.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_575058 = newJObject()
  var query_575059 = newJObject()
  add(path_575058, "resourceGroupName", newJString(resourceGroupName))
  add(query_575059, "api-version", newJString(apiVersion))
  add(path_575058, "collectionRid", newJString(collectionRid))
  add(path_575058, "subscriptionId", newJString(subscriptionId))
  add(path_575058, "databaseRid", newJString(databaseRid))
  add(path_575058, "accountName", newJString(accountName))
  add(query_575059, "$filter", newJString(Filter))
  result = call_575057.call(path_575058, query_575059, nil, nil, nil)

var collectionListUsages* = Call_CollectionListUsages_575046(
    name: "collectionListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/usages",
    validator: validate_CollectionListUsages_575047, base: "",
    url: url_CollectionListUsages_575048, schemes: {Scheme.Https})
type
  Call_DatabaseListMetricDefinitions_575060 = ref object of OpenApiRestCall_573668
proc url_DatabaseListMetricDefinitions_575062(protocol: Scheme; host: string;
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

proc validate_DatabaseListMetricDefinitions_575061(path: JsonNode; query: JsonNode;
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
  var valid_575063 = path.getOrDefault("resourceGroupName")
  valid_575063 = validateParameter(valid_575063, JString, required = true,
                                 default = nil)
  if valid_575063 != nil:
    section.add "resourceGroupName", valid_575063
  var valid_575064 = path.getOrDefault("subscriptionId")
  valid_575064 = validateParameter(valid_575064, JString, required = true,
                                 default = nil)
  if valid_575064 != nil:
    section.add "subscriptionId", valid_575064
  var valid_575065 = path.getOrDefault("databaseRid")
  valid_575065 = validateParameter(valid_575065, JString, required = true,
                                 default = nil)
  if valid_575065 != nil:
    section.add "databaseRid", valid_575065
  var valid_575066 = path.getOrDefault("accountName")
  valid_575066 = validateParameter(valid_575066, JString, required = true,
                                 default = nil)
  if valid_575066 != nil:
    section.add "accountName", valid_575066
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575067 = query.getOrDefault("api-version")
  valid_575067 = validateParameter(valid_575067, JString, required = true,
                                 default = nil)
  if valid_575067 != nil:
    section.add "api-version", valid_575067
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575068: Call_DatabaseListMetricDefinitions_575060; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves metric definitions for the given database.
  ## 
  let valid = call_575068.validator(path, query, header, formData, body)
  let scheme = call_575068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575068.url(scheme.get, call_575068.host, call_575068.base,
                         call_575068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575068, url, valid)

proc call*(call_575069: Call_DatabaseListMetricDefinitions_575060;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          databaseRid: string; accountName: string): Recallable =
  ## databaseListMetricDefinitions
  ## Retrieves metric definitions for the given database.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: string (required)
  ##              : Cosmos DB database rid.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575070 = newJObject()
  var query_575071 = newJObject()
  add(path_575070, "resourceGroupName", newJString(resourceGroupName))
  add(query_575071, "api-version", newJString(apiVersion))
  add(path_575070, "subscriptionId", newJString(subscriptionId))
  add(path_575070, "databaseRid", newJString(databaseRid))
  add(path_575070, "accountName", newJString(accountName))
  result = call_575069.call(path_575070, query_575071, nil, nil, nil)

var databaseListMetricDefinitions* = Call_DatabaseListMetricDefinitions_575060(
    name: "databaseListMetricDefinitions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/metricDefinitions",
    validator: validate_DatabaseListMetricDefinitions_575061, base: "",
    url: url_DatabaseListMetricDefinitions_575062, schemes: {Scheme.Https})
type
  Call_DatabaseListMetrics_575072 = ref object of OpenApiRestCall_573668
proc url_DatabaseListMetrics_575074(protocol: Scheme; host: string; base: string;
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

proc validate_DatabaseListMetrics_575073(path: JsonNode; query: JsonNode;
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
  var valid_575075 = path.getOrDefault("resourceGroupName")
  valid_575075 = validateParameter(valid_575075, JString, required = true,
                                 default = nil)
  if valid_575075 != nil:
    section.add "resourceGroupName", valid_575075
  var valid_575076 = path.getOrDefault("subscriptionId")
  valid_575076 = validateParameter(valid_575076, JString, required = true,
                                 default = nil)
  if valid_575076 != nil:
    section.add "subscriptionId", valid_575076
  var valid_575077 = path.getOrDefault("databaseRid")
  valid_575077 = validateParameter(valid_575077, JString, required = true,
                                 default = nil)
  if valid_575077 != nil:
    section.add "databaseRid", valid_575077
  var valid_575078 = path.getOrDefault("accountName")
  valid_575078 = validateParameter(valid_575078, JString, required = true,
                                 default = nil)
  if valid_575078 != nil:
    section.add "accountName", valid_575078
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575079 = query.getOrDefault("api-version")
  valid_575079 = validateParameter(valid_575079, JString, required = true,
                                 default = nil)
  if valid_575079 != nil:
    section.add "api-version", valid_575079
  var valid_575080 = query.getOrDefault("$filter")
  valid_575080 = validateParameter(valid_575080, JString, required = true,
                                 default = nil)
  if valid_575080 != nil:
    section.add "$filter", valid_575080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575081: Call_DatabaseListMetrics_575072; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account and database.
  ## 
  let valid = call_575081.validator(path, query, header, formData, body)
  let scheme = call_575081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575081.url(scheme.get, call_575081.host, call_575081.base,
                         call_575081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575081, url, valid)

proc call*(call_575082: Call_DatabaseListMetrics_575072; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; databaseRid: string;
          accountName: string; Filter: string): Recallable =
  ## databaseListMetrics
  ## Retrieves the metrics determined by the given filter for the given database account and database.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: string (required)
  ##              : Cosmos DB database rid.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  var path_575083 = newJObject()
  var query_575084 = newJObject()
  add(path_575083, "resourceGroupName", newJString(resourceGroupName))
  add(query_575084, "api-version", newJString(apiVersion))
  add(path_575083, "subscriptionId", newJString(subscriptionId))
  add(path_575083, "databaseRid", newJString(databaseRid))
  add(path_575083, "accountName", newJString(accountName))
  add(query_575084, "$filter", newJString(Filter))
  result = call_575082.call(path_575083, query_575084, nil, nil, nil)

var databaseListMetrics* = Call_DatabaseListMetrics_575072(
    name: "databaseListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/metrics",
    validator: validate_DatabaseListMetrics_575073, base: "",
    url: url_DatabaseListMetrics_575074, schemes: {Scheme.Https})
type
  Call_DatabaseListUsages_575085 = ref object of OpenApiRestCall_573668
proc url_DatabaseListUsages_575087(protocol: Scheme; host: string; base: string;
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

proc validate_DatabaseListUsages_575086(path: JsonNode; query: JsonNode;
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
  var valid_575088 = path.getOrDefault("resourceGroupName")
  valid_575088 = validateParameter(valid_575088, JString, required = true,
                                 default = nil)
  if valid_575088 != nil:
    section.add "resourceGroupName", valid_575088
  var valid_575089 = path.getOrDefault("subscriptionId")
  valid_575089 = validateParameter(valid_575089, JString, required = true,
                                 default = nil)
  if valid_575089 != nil:
    section.add "subscriptionId", valid_575089
  var valid_575090 = path.getOrDefault("databaseRid")
  valid_575090 = validateParameter(valid_575090, JString, required = true,
                                 default = nil)
  if valid_575090 != nil:
    section.add "databaseRid", valid_575090
  var valid_575091 = path.getOrDefault("accountName")
  valid_575091 = validateParameter(valid_575091, JString, required = true,
                                 default = nil)
  if valid_575091 != nil:
    section.add "accountName", valid_575091
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString
  ##          : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575092 = query.getOrDefault("api-version")
  valid_575092 = validateParameter(valid_575092, JString, required = true,
                                 default = nil)
  if valid_575092 != nil:
    section.add "api-version", valid_575092
  var valid_575093 = query.getOrDefault("$filter")
  valid_575093 = validateParameter(valid_575093, JString, required = false,
                                 default = nil)
  if valid_575093 != nil:
    section.add "$filter", valid_575093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575094: Call_DatabaseListUsages_575085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the usages (most recent data) for the given database.
  ## 
  let valid = call_575094.validator(path, query, header, formData, body)
  let scheme = call_575094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575094.url(scheme.get, call_575094.host, call_575094.base,
                         call_575094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575094, url, valid)

proc call*(call_575095: Call_DatabaseListUsages_575085; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; databaseRid: string;
          accountName: string; Filter: string = ""): Recallable =
  ## databaseListUsages
  ## Retrieves the usages (most recent data) for the given database.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   databaseRid: string (required)
  ##              : Cosmos DB database rid.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   Filter: string
  ##         : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  var path_575096 = newJObject()
  var query_575097 = newJObject()
  add(path_575096, "resourceGroupName", newJString(resourceGroupName))
  add(query_575097, "api-version", newJString(apiVersion))
  add(path_575096, "subscriptionId", newJString(subscriptionId))
  add(path_575096, "databaseRid", newJString(databaseRid))
  add(path_575096, "accountName", newJString(accountName))
  add(query_575097, "$filter", newJString(Filter))
  result = call_575095.call(path_575096, query_575097, nil, nil, nil)

var databaseListUsages* = Call_DatabaseListUsages_575085(
    name: "databaseListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/usages",
    validator: validate_DatabaseListUsages_575086, base: "",
    url: url_DatabaseListUsages_575087, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsFailoverPriorityChange_575098 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsFailoverPriorityChange_575100(protocol: Scheme;
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

proc validate_DatabaseAccountsFailoverPriorityChange_575099(path: JsonNode;
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
  var valid_575118 = path.getOrDefault("resourceGroupName")
  valid_575118 = validateParameter(valid_575118, JString, required = true,
                                 default = nil)
  if valid_575118 != nil:
    section.add "resourceGroupName", valid_575118
  var valid_575119 = path.getOrDefault("subscriptionId")
  valid_575119 = validateParameter(valid_575119, JString, required = true,
                                 default = nil)
  if valid_575119 != nil:
    section.add "subscriptionId", valid_575119
  var valid_575120 = path.getOrDefault("accountName")
  valid_575120 = validateParameter(valid_575120, JString, required = true,
                                 default = nil)
  if valid_575120 != nil:
    section.add "accountName", valid_575120
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575121 = query.getOrDefault("api-version")
  valid_575121 = validateParameter(valid_575121, JString, required = true,
                                 default = nil)
  if valid_575121 != nil:
    section.add "api-version", valid_575121
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

proc call*(call_575123: Call_DatabaseAccountsFailoverPriorityChange_575098;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Changes the failover priority for the Azure Cosmos DB database account. A failover priority of 0 indicates a write region. The maximum value for a failover priority = (total number of regions - 1). Failover priority values must be unique for each of the regions in which the database account exists.
  ## 
  let valid = call_575123.validator(path, query, header, formData, body)
  let scheme = call_575123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575123.url(scheme.get, call_575123.host, call_575123.base,
                         call_575123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575123, url, valid)

proc call*(call_575124: Call_DatabaseAccountsFailoverPriorityChange_575098;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          failoverParameters: JsonNode; accountName: string): Recallable =
  ## databaseAccountsFailoverPriorityChange
  ## Changes the failover priority for the Azure Cosmos DB database account. A failover priority of 0 indicates a write region. The maximum value for a failover priority = (total number of regions - 1). Failover priority values must be unique for each of the regions in which the database account exists.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   failoverParameters: JObject (required)
  ##                     : The new failover policies for the database account.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575125 = newJObject()
  var query_575126 = newJObject()
  var body_575127 = newJObject()
  add(path_575125, "resourceGroupName", newJString(resourceGroupName))
  add(query_575126, "api-version", newJString(apiVersion))
  add(path_575125, "subscriptionId", newJString(subscriptionId))
  if failoverParameters != nil:
    body_575127 = failoverParameters
  add(path_575125, "accountName", newJString(accountName))
  result = call_575124.call(path_575125, query_575126, nil, nil, body_575127)

var databaseAccountsFailoverPriorityChange* = Call_DatabaseAccountsFailoverPriorityChange_575098(
    name: "databaseAccountsFailoverPriorityChange", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/failoverPriorityChange",
    validator: validate_DatabaseAccountsFailoverPriorityChange_575099, base: "",
    url: url_DatabaseAccountsFailoverPriorityChange_575100,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListConnectionStrings_575128 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsListConnectionStrings_575130(protocol: Scheme;
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

proc validate_DatabaseAccountsListConnectionStrings_575129(path: JsonNode;
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
  var valid_575131 = path.getOrDefault("resourceGroupName")
  valid_575131 = validateParameter(valid_575131, JString, required = true,
                                 default = nil)
  if valid_575131 != nil:
    section.add "resourceGroupName", valid_575131
  var valid_575132 = path.getOrDefault("subscriptionId")
  valid_575132 = validateParameter(valid_575132, JString, required = true,
                                 default = nil)
  if valid_575132 != nil:
    section.add "subscriptionId", valid_575132
  var valid_575133 = path.getOrDefault("accountName")
  valid_575133 = validateParameter(valid_575133, JString, required = true,
                                 default = nil)
  if valid_575133 != nil:
    section.add "accountName", valid_575133
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575134 = query.getOrDefault("api-version")
  valid_575134 = validateParameter(valid_575134, JString, required = true,
                                 default = nil)
  if valid_575134 != nil:
    section.add "api-version", valid_575134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575135: Call_DatabaseAccountsListConnectionStrings_575128;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the connection strings for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_575135.validator(path, query, header, formData, body)
  let scheme = call_575135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575135.url(scheme.get, call_575135.host, call_575135.base,
                         call_575135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575135, url, valid)

proc call*(call_575136: Call_DatabaseAccountsListConnectionStrings_575128;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## databaseAccountsListConnectionStrings
  ## Lists the connection strings for the specified Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575137 = newJObject()
  var query_575138 = newJObject()
  add(path_575137, "resourceGroupName", newJString(resourceGroupName))
  add(query_575138, "api-version", newJString(apiVersion))
  add(path_575137, "subscriptionId", newJString(subscriptionId))
  add(path_575137, "accountName", newJString(accountName))
  result = call_575136.call(path_575137, query_575138, nil, nil, nil)

var databaseAccountsListConnectionStrings* = Call_DatabaseAccountsListConnectionStrings_575128(
    name: "databaseAccountsListConnectionStrings", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/listConnectionStrings",
    validator: validate_DatabaseAccountsListConnectionStrings_575129, base: "",
    url: url_DatabaseAccountsListConnectionStrings_575130, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListKeys_575139 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsListKeys_575141(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListKeys_575140(path: JsonNode; query: JsonNode;
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
  var valid_575142 = path.getOrDefault("resourceGroupName")
  valid_575142 = validateParameter(valid_575142, JString, required = true,
                                 default = nil)
  if valid_575142 != nil:
    section.add "resourceGroupName", valid_575142
  var valid_575143 = path.getOrDefault("subscriptionId")
  valid_575143 = validateParameter(valid_575143, JString, required = true,
                                 default = nil)
  if valid_575143 != nil:
    section.add "subscriptionId", valid_575143
  var valid_575144 = path.getOrDefault("accountName")
  valid_575144 = validateParameter(valid_575144, JString, required = true,
                                 default = nil)
  if valid_575144 != nil:
    section.add "accountName", valid_575144
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575145 = query.getOrDefault("api-version")
  valid_575145 = validateParameter(valid_575145, JString, required = true,
                                 default = nil)
  if valid_575145 != nil:
    section.add "api-version", valid_575145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575146: Call_DatabaseAccountsListKeys_575139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the access keys for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_575146.validator(path, query, header, formData, body)
  let scheme = call_575146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575146.url(scheme.get, call_575146.host, call_575146.base,
                         call_575146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575146, url, valid)

proc call*(call_575147: Call_DatabaseAccountsListKeys_575139;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## databaseAccountsListKeys
  ## Lists the access keys for the specified Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575148 = newJObject()
  var query_575149 = newJObject()
  add(path_575148, "resourceGroupName", newJString(resourceGroupName))
  add(query_575149, "api-version", newJString(apiVersion))
  add(path_575148, "subscriptionId", newJString(subscriptionId))
  add(path_575148, "accountName", newJString(accountName))
  result = call_575147.call(path_575148, query_575149, nil, nil, nil)

var databaseAccountsListKeys* = Call_DatabaseAccountsListKeys_575139(
    name: "databaseAccountsListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/listKeys",
    validator: validate_DatabaseAccountsListKeys_575140, base: "",
    url: url_DatabaseAccountsListKeys_575141, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListMetricDefinitions_575150 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsListMetricDefinitions_575152(protocol: Scheme;
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

proc validate_DatabaseAccountsListMetricDefinitions_575151(path: JsonNode;
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
  var valid_575153 = path.getOrDefault("resourceGroupName")
  valid_575153 = validateParameter(valid_575153, JString, required = true,
                                 default = nil)
  if valid_575153 != nil:
    section.add "resourceGroupName", valid_575153
  var valid_575154 = path.getOrDefault("subscriptionId")
  valid_575154 = validateParameter(valid_575154, JString, required = true,
                                 default = nil)
  if valid_575154 != nil:
    section.add "subscriptionId", valid_575154
  var valid_575155 = path.getOrDefault("accountName")
  valid_575155 = validateParameter(valid_575155, JString, required = true,
                                 default = nil)
  if valid_575155 != nil:
    section.add "accountName", valid_575155
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575156 = query.getOrDefault("api-version")
  valid_575156 = validateParameter(valid_575156, JString, required = true,
                                 default = nil)
  if valid_575156 != nil:
    section.add "api-version", valid_575156
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575157: Call_DatabaseAccountsListMetricDefinitions_575150;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves metric definitions for the given database account.
  ## 
  let valid = call_575157.validator(path, query, header, formData, body)
  let scheme = call_575157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575157.url(scheme.get, call_575157.host, call_575157.base,
                         call_575157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575157, url, valid)

proc call*(call_575158: Call_DatabaseAccountsListMetricDefinitions_575150;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## databaseAccountsListMetricDefinitions
  ## Retrieves metric definitions for the given database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575159 = newJObject()
  var query_575160 = newJObject()
  add(path_575159, "resourceGroupName", newJString(resourceGroupName))
  add(query_575160, "api-version", newJString(apiVersion))
  add(path_575159, "subscriptionId", newJString(subscriptionId))
  add(path_575159, "accountName", newJString(accountName))
  result = call_575158.call(path_575159, query_575160, nil, nil, nil)

var databaseAccountsListMetricDefinitions* = Call_DatabaseAccountsListMetricDefinitions_575150(
    name: "databaseAccountsListMetricDefinitions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/metricDefinitions",
    validator: validate_DatabaseAccountsListMetricDefinitions_575151, base: "",
    url: url_DatabaseAccountsListMetricDefinitions_575152, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListMetrics_575161 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsListMetrics_575163(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListMetrics_575162(path: JsonNode; query: JsonNode;
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
  var valid_575164 = path.getOrDefault("resourceGroupName")
  valid_575164 = validateParameter(valid_575164, JString, required = true,
                                 default = nil)
  if valid_575164 != nil:
    section.add "resourceGroupName", valid_575164
  var valid_575165 = path.getOrDefault("subscriptionId")
  valid_575165 = validateParameter(valid_575165, JString, required = true,
                                 default = nil)
  if valid_575165 != nil:
    section.add "subscriptionId", valid_575165
  var valid_575166 = path.getOrDefault("accountName")
  valid_575166 = validateParameter(valid_575166, JString, required = true,
                                 default = nil)
  if valid_575166 != nil:
    section.add "accountName", valid_575166
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575167 = query.getOrDefault("api-version")
  valid_575167 = validateParameter(valid_575167, JString, required = true,
                                 default = nil)
  if valid_575167 != nil:
    section.add "api-version", valid_575167
  var valid_575168 = query.getOrDefault("$filter")
  valid_575168 = validateParameter(valid_575168, JString, required = true,
                                 default = nil)
  if valid_575168 != nil:
    section.add "$filter", valid_575168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575169: Call_DatabaseAccountsListMetrics_575161; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account.
  ## 
  let valid = call_575169.validator(path, query, header, formData, body)
  let scheme = call_575169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575169.url(scheme.get, call_575169.host, call_575169.base,
                         call_575169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575169, url, valid)

proc call*(call_575170: Call_DatabaseAccountsListMetrics_575161;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string; Filter: string): Recallable =
  ## databaseAccountsListMetrics
  ## Retrieves the metrics determined by the given filter for the given database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  var path_575171 = newJObject()
  var query_575172 = newJObject()
  add(path_575171, "resourceGroupName", newJString(resourceGroupName))
  add(query_575172, "api-version", newJString(apiVersion))
  add(path_575171, "subscriptionId", newJString(subscriptionId))
  add(path_575171, "accountName", newJString(accountName))
  add(query_575172, "$filter", newJString(Filter))
  result = call_575170.call(path_575171, query_575172, nil, nil, nil)

var databaseAccountsListMetrics* = Call_DatabaseAccountsListMetrics_575161(
    name: "databaseAccountsListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/metrics",
    validator: validate_DatabaseAccountsListMetrics_575162, base: "",
    url: url_DatabaseAccountsListMetrics_575163, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsOfflineRegion_575173 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsOfflineRegion_575175(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsOfflineRegion_575174(path: JsonNode; query: JsonNode;
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
  var valid_575176 = path.getOrDefault("resourceGroupName")
  valid_575176 = validateParameter(valid_575176, JString, required = true,
                                 default = nil)
  if valid_575176 != nil:
    section.add "resourceGroupName", valid_575176
  var valid_575177 = path.getOrDefault("subscriptionId")
  valid_575177 = validateParameter(valid_575177, JString, required = true,
                                 default = nil)
  if valid_575177 != nil:
    section.add "subscriptionId", valid_575177
  var valid_575178 = path.getOrDefault("accountName")
  valid_575178 = validateParameter(valid_575178, JString, required = true,
                                 default = nil)
  if valid_575178 != nil:
    section.add "accountName", valid_575178
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575179 = query.getOrDefault("api-version")
  valid_575179 = validateParameter(valid_575179, JString, required = true,
                                 default = nil)
  if valid_575179 != nil:
    section.add "api-version", valid_575179
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

proc call*(call_575181: Call_DatabaseAccountsOfflineRegion_575173; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Offline the specified region for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_575181.validator(path, query, header, formData, body)
  let scheme = call_575181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575181.url(scheme.get, call_575181.host, call_575181.base,
                         call_575181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575181, url, valid)

proc call*(call_575182: Call_DatabaseAccountsOfflineRegion_575173;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          regionParameterForOffline: JsonNode; accountName: string): Recallable =
  ## databaseAccountsOfflineRegion
  ## Offline the specified region for the specified Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   regionParameterForOffline: JObject (required)
  ##                            : Cosmos DB region to offline for the database account.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575183 = newJObject()
  var query_575184 = newJObject()
  var body_575185 = newJObject()
  add(path_575183, "resourceGroupName", newJString(resourceGroupName))
  add(query_575184, "api-version", newJString(apiVersion))
  add(path_575183, "subscriptionId", newJString(subscriptionId))
  if regionParameterForOffline != nil:
    body_575185 = regionParameterForOffline
  add(path_575183, "accountName", newJString(accountName))
  result = call_575182.call(path_575183, query_575184, nil, nil, body_575185)

var databaseAccountsOfflineRegion* = Call_DatabaseAccountsOfflineRegion_575173(
    name: "databaseAccountsOfflineRegion", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/offlineRegion",
    validator: validate_DatabaseAccountsOfflineRegion_575174, base: "",
    url: url_DatabaseAccountsOfflineRegion_575175, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsOnlineRegion_575186 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsOnlineRegion_575188(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsOnlineRegion_575187(path: JsonNode; query: JsonNode;
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
  var valid_575189 = path.getOrDefault("resourceGroupName")
  valid_575189 = validateParameter(valid_575189, JString, required = true,
                                 default = nil)
  if valid_575189 != nil:
    section.add "resourceGroupName", valid_575189
  var valid_575190 = path.getOrDefault("subscriptionId")
  valid_575190 = validateParameter(valid_575190, JString, required = true,
                                 default = nil)
  if valid_575190 != nil:
    section.add "subscriptionId", valid_575190
  var valid_575191 = path.getOrDefault("accountName")
  valid_575191 = validateParameter(valid_575191, JString, required = true,
                                 default = nil)
  if valid_575191 != nil:
    section.add "accountName", valid_575191
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575192 = query.getOrDefault("api-version")
  valid_575192 = validateParameter(valid_575192, JString, required = true,
                                 default = nil)
  if valid_575192 != nil:
    section.add "api-version", valid_575192
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

proc call*(call_575194: Call_DatabaseAccountsOnlineRegion_575186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Online the specified region for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_575194.validator(path, query, header, formData, body)
  let scheme = call_575194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575194.url(scheme.get, call_575194.host, call_575194.base,
                         call_575194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575194, url, valid)

proc call*(call_575195: Call_DatabaseAccountsOnlineRegion_575186;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          regionParameterForOnline: JsonNode; accountName: string): Recallable =
  ## databaseAccountsOnlineRegion
  ## Online the specified region for the specified Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   regionParameterForOnline: JObject (required)
  ##                           : Cosmos DB region to online for the database account.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575196 = newJObject()
  var query_575197 = newJObject()
  var body_575198 = newJObject()
  add(path_575196, "resourceGroupName", newJString(resourceGroupName))
  add(query_575197, "api-version", newJString(apiVersion))
  add(path_575196, "subscriptionId", newJString(subscriptionId))
  if regionParameterForOnline != nil:
    body_575198 = regionParameterForOnline
  add(path_575196, "accountName", newJString(accountName))
  result = call_575195.call(path_575196, query_575197, nil, nil, body_575198)

var databaseAccountsOnlineRegion* = Call_DatabaseAccountsOnlineRegion_575186(
    name: "databaseAccountsOnlineRegion", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/onlineRegion",
    validator: validate_DatabaseAccountsOnlineRegion_575187, base: "",
    url: url_DatabaseAccountsOnlineRegion_575188, schemes: {Scheme.Https})
type
  Call_PercentileListMetrics_575199 = ref object of OpenApiRestCall_573668
proc url_PercentileListMetrics_575201(protocol: Scheme; host: string; base: string;
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

proc validate_PercentileListMetrics_575200(path: JsonNode; query: JsonNode;
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
  var valid_575202 = path.getOrDefault("resourceGroupName")
  valid_575202 = validateParameter(valid_575202, JString, required = true,
                                 default = nil)
  if valid_575202 != nil:
    section.add "resourceGroupName", valid_575202
  var valid_575203 = path.getOrDefault("subscriptionId")
  valid_575203 = validateParameter(valid_575203, JString, required = true,
                                 default = nil)
  if valid_575203 != nil:
    section.add "subscriptionId", valid_575203
  var valid_575204 = path.getOrDefault("accountName")
  valid_575204 = validateParameter(valid_575204, JString, required = true,
                                 default = nil)
  if valid_575204 != nil:
    section.add "accountName", valid_575204
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575205 = query.getOrDefault("api-version")
  valid_575205 = validateParameter(valid_575205, JString, required = true,
                                 default = nil)
  if valid_575205 != nil:
    section.add "api-version", valid_575205
  var valid_575206 = query.getOrDefault("$filter")
  valid_575206 = validateParameter(valid_575206, JString, required = true,
                                 default = nil)
  if valid_575206 != nil:
    section.add "$filter", valid_575206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575207: Call_PercentileListMetrics_575199; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account. This url is only for PBS and Replication Latency data
  ## 
  let valid = call_575207.validator(path, query, header, formData, body)
  let scheme = call_575207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575207.url(scheme.get, call_575207.host, call_575207.base,
                         call_575207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575207, url, valid)

proc call*(call_575208: Call_PercentileListMetrics_575199;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string; Filter: string): Recallable =
  ## percentileListMetrics
  ## Retrieves the metrics determined by the given filter for the given database account. This url is only for PBS and Replication Latency data
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  var path_575209 = newJObject()
  var query_575210 = newJObject()
  add(path_575209, "resourceGroupName", newJString(resourceGroupName))
  add(query_575210, "api-version", newJString(apiVersion))
  add(path_575209, "subscriptionId", newJString(subscriptionId))
  add(path_575209, "accountName", newJString(accountName))
  add(query_575210, "$filter", newJString(Filter))
  result = call_575208.call(path_575209, query_575210, nil, nil, nil)

var percentileListMetrics* = Call_PercentileListMetrics_575199(
    name: "percentileListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/percentile/metrics",
    validator: validate_PercentileListMetrics_575200, base: "",
    url: url_PercentileListMetrics_575201, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListReadOnlyKeys_575222 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsListReadOnlyKeys_575224(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListReadOnlyKeys_575223(path: JsonNode;
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
  var valid_575225 = path.getOrDefault("resourceGroupName")
  valid_575225 = validateParameter(valid_575225, JString, required = true,
                                 default = nil)
  if valid_575225 != nil:
    section.add "resourceGroupName", valid_575225
  var valid_575226 = path.getOrDefault("subscriptionId")
  valid_575226 = validateParameter(valid_575226, JString, required = true,
                                 default = nil)
  if valid_575226 != nil:
    section.add "subscriptionId", valid_575226
  var valid_575227 = path.getOrDefault("accountName")
  valid_575227 = validateParameter(valid_575227, JString, required = true,
                                 default = nil)
  if valid_575227 != nil:
    section.add "accountName", valid_575227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575228 = query.getOrDefault("api-version")
  valid_575228 = validateParameter(valid_575228, JString, required = true,
                                 default = nil)
  if valid_575228 != nil:
    section.add "api-version", valid_575228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575229: Call_DatabaseAccountsListReadOnlyKeys_575222;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the read-only access keys for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_575229.validator(path, query, header, formData, body)
  let scheme = call_575229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575229.url(scheme.get, call_575229.host, call_575229.base,
                         call_575229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575229, url, valid)

proc call*(call_575230: Call_DatabaseAccountsListReadOnlyKeys_575222;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## databaseAccountsListReadOnlyKeys
  ## Lists the read-only access keys for the specified Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575231 = newJObject()
  var query_575232 = newJObject()
  add(path_575231, "resourceGroupName", newJString(resourceGroupName))
  add(query_575232, "api-version", newJString(apiVersion))
  add(path_575231, "subscriptionId", newJString(subscriptionId))
  add(path_575231, "accountName", newJString(accountName))
  result = call_575230.call(path_575231, query_575232, nil, nil, nil)

var databaseAccountsListReadOnlyKeys* = Call_DatabaseAccountsListReadOnlyKeys_575222(
    name: "databaseAccountsListReadOnlyKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/readonlykeys",
    validator: validate_DatabaseAccountsListReadOnlyKeys_575223, base: "",
    url: url_DatabaseAccountsListReadOnlyKeys_575224, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetReadOnlyKeys_575211 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsGetReadOnlyKeys_575213(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsGetReadOnlyKeys_575212(path: JsonNode;
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
  var valid_575214 = path.getOrDefault("resourceGroupName")
  valid_575214 = validateParameter(valid_575214, JString, required = true,
                                 default = nil)
  if valid_575214 != nil:
    section.add "resourceGroupName", valid_575214
  var valid_575215 = path.getOrDefault("subscriptionId")
  valid_575215 = validateParameter(valid_575215, JString, required = true,
                                 default = nil)
  if valid_575215 != nil:
    section.add "subscriptionId", valid_575215
  var valid_575216 = path.getOrDefault("accountName")
  valid_575216 = validateParameter(valid_575216, JString, required = true,
                                 default = nil)
  if valid_575216 != nil:
    section.add "accountName", valid_575216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575217 = query.getOrDefault("api-version")
  valid_575217 = validateParameter(valid_575217, JString, required = true,
                                 default = nil)
  if valid_575217 != nil:
    section.add "api-version", valid_575217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575218: Call_DatabaseAccountsGetReadOnlyKeys_575211;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the read-only access keys for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_575218.validator(path, query, header, formData, body)
  let scheme = call_575218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575218.url(scheme.get, call_575218.host, call_575218.base,
                         call_575218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575218, url, valid)

proc call*(call_575219: Call_DatabaseAccountsGetReadOnlyKeys_575211;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## databaseAccountsGetReadOnlyKeys
  ## Lists the read-only access keys for the specified Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_575220 = newJObject()
  var query_575221 = newJObject()
  add(path_575220, "resourceGroupName", newJString(resourceGroupName))
  add(query_575221, "api-version", newJString(apiVersion))
  add(path_575220, "subscriptionId", newJString(subscriptionId))
  add(path_575220, "accountName", newJString(accountName))
  result = call_575219.call(path_575220, query_575221, nil, nil, nil)

var databaseAccountsGetReadOnlyKeys* = Call_DatabaseAccountsGetReadOnlyKeys_575211(
    name: "databaseAccountsGetReadOnlyKeys", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/readonlykeys",
    validator: validate_DatabaseAccountsGetReadOnlyKeys_575212, base: "",
    url: url_DatabaseAccountsGetReadOnlyKeys_575213, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsRegenerateKey_575233 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsRegenerateKey_575235(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsRegenerateKey_575234(path: JsonNode; query: JsonNode;
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
  var valid_575236 = path.getOrDefault("resourceGroupName")
  valid_575236 = validateParameter(valid_575236, JString, required = true,
                                 default = nil)
  if valid_575236 != nil:
    section.add "resourceGroupName", valid_575236
  var valid_575237 = path.getOrDefault("subscriptionId")
  valid_575237 = validateParameter(valid_575237, JString, required = true,
                                 default = nil)
  if valid_575237 != nil:
    section.add "subscriptionId", valid_575237
  var valid_575238 = path.getOrDefault("accountName")
  valid_575238 = validateParameter(valid_575238, JString, required = true,
                                 default = nil)
  if valid_575238 != nil:
    section.add "accountName", valid_575238
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575239 = query.getOrDefault("api-version")
  valid_575239 = validateParameter(valid_575239, JString, required = true,
                                 default = nil)
  if valid_575239 != nil:
    section.add "api-version", valid_575239
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

proc call*(call_575241: Call_DatabaseAccountsRegenerateKey_575233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates an access key for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_575241.validator(path, query, header, formData, body)
  let scheme = call_575241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575241.url(scheme.get, call_575241.host, call_575241.base,
                         call_575241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575241, url, valid)

proc call*(call_575242: Call_DatabaseAccountsRegenerateKey_575233;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string; keyToRegenerate: JsonNode): Recallable =
  ## databaseAccountsRegenerateKey
  ## Regenerates an access key for the specified Azure Cosmos DB database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   keyToRegenerate: JObject (required)
  ##                  : The name of the key to regenerate.
  var path_575243 = newJObject()
  var query_575244 = newJObject()
  var body_575245 = newJObject()
  add(path_575243, "resourceGroupName", newJString(resourceGroupName))
  add(query_575244, "api-version", newJString(apiVersion))
  add(path_575243, "subscriptionId", newJString(subscriptionId))
  add(path_575243, "accountName", newJString(accountName))
  if keyToRegenerate != nil:
    body_575245 = keyToRegenerate
  result = call_575242.call(path_575243, query_575244, nil, nil, body_575245)

var databaseAccountsRegenerateKey* = Call_DatabaseAccountsRegenerateKey_575233(
    name: "databaseAccountsRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/regenerateKey",
    validator: validate_DatabaseAccountsRegenerateKey_575234, base: "",
    url: url_DatabaseAccountsRegenerateKey_575235, schemes: {Scheme.Https})
type
  Call_CollectionRegionListMetrics_575246 = ref object of OpenApiRestCall_573668
proc url_CollectionRegionListMetrics_575248(protocol: Scheme; host: string;
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

proc validate_CollectionRegionListMetrics_575247(path: JsonNode; query: JsonNode;
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
  var valid_575249 = path.getOrDefault("resourceGroupName")
  valid_575249 = validateParameter(valid_575249, JString, required = true,
                                 default = nil)
  if valid_575249 != nil:
    section.add "resourceGroupName", valid_575249
  var valid_575250 = path.getOrDefault("collectionRid")
  valid_575250 = validateParameter(valid_575250, JString, required = true,
                                 default = nil)
  if valid_575250 != nil:
    section.add "collectionRid", valid_575250
  var valid_575251 = path.getOrDefault("subscriptionId")
  valid_575251 = validateParameter(valid_575251, JString, required = true,
                                 default = nil)
  if valid_575251 != nil:
    section.add "subscriptionId", valid_575251
  var valid_575252 = path.getOrDefault("region")
  valid_575252 = validateParameter(valid_575252, JString, required = true,
                                 default = nil)
  if valid_575252 != nil:
    section.add "region", valid_575252
  var valid_575253 = path.getOrDefault("databaseRid")
  valid_575253 = validateParameter(valid_575253, JString, required = true,
                                 default = nil)
  if valid_575253 != nil:
    section.add "databaseRid", valid_575253
  var valid_575254 = path.getOrDefault("accountName")
  valid_575254 = validateParameter(valid_575254, JString, required = true,
                                 default = nil)
  if valid_575254 != nil:
    section.add "accountName", valid_575254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575255 = query.getOrDefault("api-version")
  valid_575255 = validateParameter(valid_575255, JString, required = true,
                                 default = nil)
  if valid_575255 != nil:
    section.add "api-version", valid_575255
  var valid_575256 = query.getOrDefault("$filter")
  valid_575256 = validateParameter(valid_575256, JString, required = true,
                                 default = nil)
  if valid_575256 != nil:
    section.add "$filter", valid_575256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575257: Call_CollectionRegionListMetrics_575246; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account, collection and region.
  ## 
  let valid = call_575257.validator(path, query, header, formData, body)
  let scheme = call_575257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575257.url(scheme.get, call_575257.host, call_575257.base,
                         call_575257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575257, url, valid)

proc call*(call_575258: Call_CollectionRegionListMetrics_575246;
          resourceGroupName: string; apiVersion: string; collectionRid: string;
          subscriptionId: string; region: string; databaseRid: string;
          accountName: string; Filter: string): Recallable =
  ## collectionRegionListMetrics
  ## Retrieves the metrics determined by the given filter for the given database account, collection and region.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_575259 = newJObject()
  var query_575260 = newJObject()
  add(path_575259, "resourceGroupName", newJString(resourceGroupName))
  add(query_575260, "api-version", newJString(apiVersion))
  add(path_575259, "collectionRid", newJString(collectionRid))
  add(path_575259, "subscriptionId", newJString(subscriptionId))
  add(path_575259, "region", newJString(region))
  add(path_575259, "databaseRid", newJString(databaseRid))
  add(path_575259, "accountName", newJString(accountName))
  add(query_575260, "$filter", newJString(Filter))
  result = call_575258.call(path_575259, query_575260, nil, nil, nil)

var collectionRegionListMetrics* = Call_CollectionRegionListMetrics_575246(
    name: "collectionRegionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/region/{region}/databases/{databaseRid}/collections/{collectionRid}/metrics",
    validator: validate_CollectionRegionListMetrics_575247, base: "",
    url: url_CollectionRegionListMetrics_575248, schemes: {Scheme.Https})
type
  Call_PartitionKeyRangeIdRegionListMetrics_575261 = ref object of OpenApiRestCall_573668
proc url_PartitionKeyRangeIdRegionListMetrics_575263(protocol: Scheme;
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

proc validate_PartitionKeyRangeIdRegionListMetrics_575262(path: JsonNode;
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
  var valid_575264 = path.getOrDefault("resourceGroupName")
  valid_575264 = validateParameter(valid_575264, JString, required = true,
                                 default = nil)
  if valid_575264 != nil:
    section.add "resourceGroupName", valid_575264
  var valid_575265 = path.getOrDefault("collectionRid")
  valid_575265 = validateParameter(valid_575265, JString, required = true,
                                 default = nil)
  if valid_575265 != nil:
    section.add "collectionRid", valid_575265
  var valid_575266 = path.getOrDefault("subscriptionId")
  valid_575266 = validateParameter(valid_575266, JString, required = true,
                                 default = nil)
  if valid_575266 != nil:
    section.add "subscriptionId", valid_575266
  var valid_575267 = path.getOrDefault("partitionKeyRangeId")
  valid_575267 = validateParameter(valid_575267, JString, required = true,
                                 default = nil)
  if valid_575267 != nil:
    section.add "partitionKeyRangeId", valid_575267
  var valid_575268 = path.getOrDefault("region")
  valid_575268 = validateParameter(valid_575268, JString, required = true,
                                 default = nil)
  if valid_575268 != nil:
    section.add "region", valid_575268
  var valid_575269 = path.getOrDefault("databaseRid")
  valid_575269 = validateParameter(valid_575269, JString, required = true,
                                 default = nil)
  if valid_575269 != nil:
    section.add "databaseRid", valid_575269
  var valid_575270 = path.getOrDefault("accountName")
  valid_575270 = validateParameter(valid_575270, JString, required = true,
                                 default = nil)
  if valid_575270 != nil:
    section.add "accountName", valid_575270
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575271 = query.getOrDefault("api-version")
  valid_575271 = validateParameter(valid_575271, JString, required = true,
                                 default = nil)
  if valid_575271 != nil:
    section.add "api-version", valid_575271
  var valid_575272 = query.getOrDefault("$filter")
  valid_575272 = validateParameter(valid_575272, JString, required = true,
                                 default = nil)
  if valid_575272 != nil:
    section.add "$filter", valid_575272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575273: Call_PartitionKeyRangeIdRegionListMetrics_575261;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given partition key range id and region.
  ## 
  let valid = call_575273.validator(path, query, header, formData, body)
  let scheme = call_575273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575273.url(scheme.get, call_575273.host, call_575273.base,
                         call_575273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575273, url, valid)

proc call*(call_575274: Call_PartitionKeyRangeIdRegionListMetrics_575261;
          resourceGroupName: string; apiVersion: string; collectionRid: string;
          subscriptionId: string; partitionKeyRangeId: string; region: string;
          databaseRid: string; accountName: string; Filter: string): Recallable =
  ## partitionKeyRangeIdRegionListMetrics
  ## Retrieves the metrics determined by the given filter for the given partition key range id and region.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_575275 = newJObject()
  var query_575276 = newJObject()
  add(path_575275, "resourceGroupName", newJString(resourceGroupName))
  add(query_575276, "api-version", newJString(apiVersion))
  add(path_575275, "collectionRid", newJString(collectionRid))
  add(path_575275, "subscriptionId", newJString(subscriptionId))
  add(path_575275, "partitionKeyRangeId", newJString(partitionKeyRangeId))
  add(path_575275, "region", newJString(region))
  add(path_575275, "databaseRid", newJString(databaseRid))
  add(path_575275, "accountName", newJString(accountName))
  add(query_575276, "$filter", newJString(Filter))
  result = call_575274.call(path_575275, query_575276, nil, nil, nil)

var partitionKeyRangeIdRegionListMetrics* = Call_PartitionKeyRangeIdRegionListMetrics_575261(
    name: "partitionKeyRangeIdRegionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/region/{region}/databases/{databaseRid}/collections/{collectionRid}/partitionKeyRangeId/{partitionKeyRangeId}/metrics",
    validator: validate_PartitionKeyRangeIdRegionListMetrics_575262, base: "",
    url: url_PartitionKeyRangeIdRegionListMetrics_575263, schemes: {Scheme.Https})
type
  Call_CollectionPartitionRegionListMetrics_575277 = ref object of OpenApiRestCall_573668
proc url_CollectionPartitionRegionListMetrics_575279(protocol: Scheme;
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

proc validate_CollectionPartitionRegionListMetrics_575278(path: JsonNode;
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
  var valid_575280 = path.getOrDefault("resourceGroupName")
  valid_575280 = validateParameter(valid_575280, JString, required = true,
                                 default = nil)
  if valid_575280 != nil:
    section.add "resourceGroupName", valid_575280
  var valid_575281 = path.getOrDefault("collectionRid")
  valid_575281 = validateParameter(valid_575281, JString, required = true,
                                 default = nil)
  if valid_575281 != nil:
    section.add "collectionRid", valid_575281
  var valid_575282 = path.getOrDefault("subscriptionId")
  valid_575282 = validateParameter(valid_575282, JString, required = true,
                                 default = nil)
  if valid_575282 != nil:
    section.add "subscriptionId", valid_575282
  var valid_575283 = path.getOrDefault("region")
  valid_575283 = validateParameter(valid_575283, JString, required = true,
                                 default = nil)
  if valid_575283 != nil:
    section.add "region", valid_575283
  var valid_575284 = path.getOrDefault("databaseRid")
  valid_575284 = validateParameter(valid_575284, JString, required = true,
                                 default = nil)
  if valid_575284 != nil:
    section.add "databaseRid", valid_575284
  var valid_575285 = path.getOrDefault("accountName")
  valid_575285 = validateParameter(valid_575285, JString, required = true,
                                 default = nil)
  if valid_575285 != nil:
    section.add "accountName", valid_575285
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575286 = query.getOrDefault("api-version")
  valid_575286 = validateParameter(valid_575286, JString, required = true,
                                 default = nil)
  if valid_575286 != nil:
    section.add "api-version", valid_575286
  var valid_575287 = query.getOrDefault("$filter")
  valid_575287 = validateParameter(valid_575287, JString, required = true,
                                 default = nil)
  if valid_575287 != nil:
    section.add "$filter", valid_575287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575288: Call_CollectionPartitionRegionListMetrics_575277;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given collection and region, split by partition.
  ## 
  let valid = call_575288.validator(path, query, header, formData, body)
  let scheme = call_575288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575288.url(scheme.get, call_575288.host, call_575288.base,
                         call_575288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575288, url, valid)

proc call*(call_575289: Call_CollectionPartitionRegionListMetrics_575277;
          resourceGroupName: string; apiVersion: string; collectionRid: string;
          subscriptionId: string; region: string; databaseRid: string;
          accountName: string; Filter: string): Recallable =
  ## collectionPartitionRegionListMetrics
  ## Retrieves the metrics determined by the given filter for the given collection and region, split by partition.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_575290 = newJObject()
  var query_575291 = newJObject()
  add(path_575290, "resourceGroupName", newJString(resourceGroupName))
  add(query_575291, "api-version", newJString(apiVersion))
  add(path_575290, "collectionRid", newJString(collectionRid))
  add(path_575290, "subscriptionId", newJString(subscriptionId))
  add(path_575290, "region", newJString(region))
  add(path_575290, "databaseRid", newJString(databaseRid))
  add(path_575290, "accountName", newJString(accountName))
  add(query_575291, "$filter", newJString(Filter))
  result = call_575289.call(path_575290, query_575291, nil, nil, nil)

var collectionPartitionRegionListMetrics* = Call_CollectionPartitionRegionListMetrics_575277(
    name: "collectionPartitionRegionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/region/{region}/databases/{databaseRid}/collections/{collectionRid}/partitions/metrics",
    validator: validate_CollectionPartitionRegionListMetrics_575278, base: "",
    url: url_CollectionPartitionRegionListMetrics_575279, schemes: {Scheme.Https})
type
  Call_DatabaseAccountRegionListMetrics_575292 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountRegionListMetrics_575294(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountRegionListMetrics_575293(path: JsonNode;
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
  var valid_575295 = path.getOrDefault("resourceGroupName")
  valid_575295 = validateParameter(valid_575295, JString, required = true,
                                 default = nil)
  if valid_575295 != nil:
    section.add "resourceGroupName", valid_575295
  var valid_575296 = path.getOrDefault("subscriptionId")
  valid_575296 = validateParameter(valid_575296, JString, required = true,
                                 default = nil)
  if valid_575296 != nil:
    section.add "subscriptionId", valid_575296
  var valid_575297 = path.getOrDefault("region")
  valid_575297 = validateParameter(valid_575297, JString, required = true,
                                 default = nil)
  if valid_575297 != nil:
    section.add "region", valid_575297
  var valid_575298 = path.getOrDefault("accountName")
  valid_575298 = validateParameter(valid_575298, JString, required = true,
                                 default = nil)
  if valid_575298 != nil:
    section.add "accountName", valid_575298
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575299 = query.getOrDefault("api-version")
  valid_575299 = validateParameter(valid_575299, JString, required = true,
                                 default = nil)
  if valid_575299 != nil:
    section.add "api-version", valid_575299
  var valid_575300 = query.getOrDefault("$filter")
  valid_575300 = validateParameter(valid_575300, JString, required = true,
                                 default = nil)
  if valid_575300 != nil:
    section.add "$filter", valid_575300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575301: Call_DatabaseAccountRegionListMetrics_575292;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account and region.
  ## 
  let valid = call_575301.validator(path, query, header, formData, body)
  let scheme = call_575301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575301.url(scheme.get, call_575301.host, call_575301.base,
                         call_575301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575301, url, valid)

proc call*(call_575302: Call_DatabaseAccountRegionListMetrics_575292;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          region: string; accountName: string; Filter: string): Recallable =
  ## databaseAccountRegionListMetrics
  ## Retrieves the metrics determined by the given filter for the given database account and region.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   region: string (required)
  ##         : Cosmos DB region, with spaces between words and each word capitalized.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  var path_575303 = newJObject()
  var query_575304 = newJObject()
  add(path_575303, "resourceGroupName", newJString(resourceGroupName))
  add(query_575304, "api-version", newJString(apiVersion))
  add(path_575303, "subscriptionId", newJString(subscriptionId))
  add(path_575303, "region", newJString(region))
  add(path_575303, "accountName", newJString(accountName))
  add(query_575304, "$filter", newJString(Filter))
  result = call_575302.call(path_575303, query_575304, nil, nil, nil)

var databaseAccountRegionListMetrics* = Call_DatabaseAccountRegionListMetrics_575292(
    name: "databaseAccountRegionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/region/{region}/metrics",
    validator: validate_DatabaseAccountRegionListMetrics_575293, base: "",
    url: url_DatabaseAccountRegionListMetrics_575294, schemes: {Scheme.Https})
type
  Call_PercentileSourceTargetListMetrics_575305 = ref object of OpenApiRestCall_573668
proc url_PercentileSourceTargetListMetrics_575307(protocol: Scheme; host: string;
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

proc validate_PercentileSourceTargetListMetrics_575306(path: JsonNode;
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
  var valid_575308 = path.getOrDefault("resourceGroupName")
  valid_575308 = validateParameter(valid_575308, JString, required = true,
                                 default = nil)
  if valid_575308 != nil:
    section.add "resourceGroupName", valid_575308
  var valid_575309 = path.getOrDefault("sourceRegion")
  valid_575309 = validateParameter(valid_575309, JString, required = true,
                                 default = nil)
  if valid_575309 != nil:
    section.add "sourceRegion", valid_575309
  var valid_575310 = path.getOrDefault("subscriptionId")
  valid_575310 = validateParameter(valid_575310, JString, required = true,
                                 default = nil)
  if valid_575310 != nil:
    section.add "subscriptionId", valid_575310
  var valid_575311 = path.getOrDefault("targetRegion")
  valid_575311 = validateParameter(valid_575311, JString, required = true,
                                 default = nil)
  if valid_575311 != nil:
    section.add "targetRegion", valid_575311
  var valid_575312 = path.getOrDefault("accountName")
  valid_575312 = validateParameter(valid_575312, JString, required = true,
                                 default = nil)
  if valid_575312 != nil:
    section.add "accountName", valid_575312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575313 = query.getOrDefault("api-version")
  valid_575313 = validateParameter(valid_575313, JString, required = true,
                                 default = nil)
  if valid_575313 != nil:
    section.add "api-version", valid_575313
  var valid_575314 = query.getOrDefault("$filter")
  valid_575314 = validateParameter(valid_575314, JString, required = true,
                                 default = nil)
  if valid_575314 != nil:
    section.add "$filter", valid_575314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575315: Call_PercentileSourceTargetListMetrics_575305;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given account, source and target region. This url is only for PBS and Replication Latency data
  ## 
  let valid = call_575315.validator(path, query, header, formData, body)
  let scheme = call_575315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575315.url(scheme.get, call_575315.host, call_575315.base,
                         call_575315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575315, url, valid)

proc call*(call_575316: Call_PercentileSourceTargetListMetrics_575305;
          resourceGroupName: string; apiVersion: string; sourceRegion: string;
          subscriptionId: string; targetRegion: string; accountName: string;
          Filter: string): Recallable =
  ## percentileSourceTargetListMetrics
  ## Retrieves the metrics determined by the given filter for the given account, source and target region. This url is only for PBS and Replication Latency data
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
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
  var path_575317 = newJObject()
  var query_575318 = newJObject()
  add(path_575317, "resourceGroupName", newJString(resourceGroupName))
  add(query_575318, "api-version", newJString(apiVersion))
  add(path_575317, "sourceRegion", newJString(sourceRegion))
  add(path_575317, "subscriptionId", newJString(subscriptionId))
  add(path_575317, "targetRegion", newJString(targetRegion))
  add(path_575317, "accountName", newJString(accountName))
  add(query_575318, "$filter", newJString(Filter))
  result = call_575316.call(path_575317, query_575318, nil, nil, nil)

var percentileSourceTargetListMetrics* = Call_PercentileSourceTargetListMetrics_575305(
    name: "percentileSourceTargetListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sourceRegion/{sourceRegion}/targetRegion/{targetRegion}/percentile/metrics",
    validator: validate_PercentileSourceTargetListMetrics_575306, base: "",
    url: url_PercentileSourceTargetListMetrics_575307, schemes: {Scheme.Https})
type
  Call_PercentileTargetListMetrics_575319 = ref object of OpenApiRestCall_573668
proc url_PercentileTargetListMetrics_575321(protocol: Scheme; host: string;
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

proc validate_PercentileTargetListMetrics_575320(path: JsonNode; query: JsonNode;
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
  var valid_575322 = path.getOrDefault("resourceGroupName")
  valid_575322 = validateParameter(valid_575322, JString, required = true,
                                 default = nil)
  if valid_575322 != nil:
    section.add "resourceGroupName", valid_575322
  var valid_575323 = path.getOrDefault("subscriptionId")
  valid_575323 = validateParameter(valid_575323, JString, required = true,
                                 default = nil)
  if valid_575323 != nil:
    section.add "subscriptionId", valid_575323
  var valid_575324 = path.getOrDefault("targetRegion")
  valid_575324 = validateParameter(valid_575324, JString, required = true,
                                 default = nil)
  if valid_575324 != nil:
    section.add "targetRegion", valid_575324
  var valid_575325 = path.getOrDefault("accountName")
  valid_575325 = validateParameter(valid_575325, JString, required = true,
                                 default = nil)
  if valid_575325 != nil:
    section.add "accountName", valid_575325
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575326 = query.getOrDefault("api-version")
  valid_575326 = validateParameter(valid_575326, JString, required = true,
                                 default = nil)
  if valid_575326 != nil:
    section.add "api-version", valid_575326
  var valid_575327 = query.getOrDefault("$filter")
  valid_575327 = validateParameter(valid_575327, JString, required = true,
                                 default = nil)
  if valid_575327 != nil:
    section.add "$filter", valid_575327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575328: Call_PercentileTargetListMetrics_575319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given account target region. This url is only for PBS and Replication Latency data
  ## 
  let valid = call_575328.validator(path, query, header, formData, body)
  let scheme = call_575328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575328.url(scheme.get, call_575328.host, call_575328.base,
                         call_575328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575328, url, valid)

proc call*(call_575329: Call_PercentileTargetListMetrics_575319;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          targetRegion: string; accountName: string; Filter: string): Recallable =
  ## percentileTargetListMetrics
  ## Retrieves the metrics determined by the given filter for the given account target region. This url is only for PBS and Replication Latency data
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   targetRegion: string (required)
  ##               : Target region to which data is written. Cosmos DB region, with spaces between words and each word capitalized.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   Filter: string (required)
  ##         : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  var path_575330 = newJObject()
  var query_575331 = newJObject()
  add(path_575330, "resourceGroupName", newJString(resourceGroupName))
  add(query_575331, "api-version", newJString(apiVersion))
  add(path_575330, "subscriptionId", newJString(subscriptionId))
  add(path_575330, "targetRegion", newJString(targetRegion))
  add(path_575330, "accountName", newJString(accountName))
  add(query_575331, "$filter", newJString(Filter))
  result = call_575329.call(path_575330, query_575331, nil, nil, nil)

var percentileTargetListMetrics* = Call_PercentileTargetListMetrics_575319(
    name: "percentileTargetListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/targetRegion/{targetRegion}/percentile/metrics",
    validator: validate_PercentileTargetListMetrics_575320, base: "",
    url: url_PercentileTargetListMetrics_575321, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListUsages_575332 = ref object of OpenApiRestCall_573668
proc url_DatabaseAccountsListUsages_575334(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListUsages_575333(path: JsonNode; query: JsonNode;
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
  var valid_575335 = path.getOrDefault("resourceGroupName")
  valid_575335 = validateParameter(valid_575335, JString, required = true,
                                 default = nil)
  if valid_575335 != nil:
    section.add "resourceGroupName", valid_575335
  var valid_575336 = path.getOrDefault("subscriptionId")
  valid_575336 = validateParameter(valid_575336, JString, required = true,
                                 default = nil)
  if valid_575336 != nil:
    section.add "subscriptionId", valid_575336
  var valid_575337 = path.getOrDefault("accountName")
  valid_575337 = validateParameter(valid_575337, JString, required = true,
                                 default = nil)
  if valid_575337 != nil:
    section.add "accountName", valid_575337
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString
  ##          : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575338 = query.getOrDefault("api-version")
  valid_575338 = validateParameter(valid_575338, JString, required = true,
                                 default = nil)
  if valid_575338 != nil:
    section.add "api-version", valid_575338
  var valid_575339 = query.getOrDefault("$filter")
  valid_575339 = validateParameter(valid_575339, JString, required = false,
                                 default = nil)
  if valid_575339 != nil:
    section.add "$filter", valid_575339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575340: Call_DatabaseAccountsListUsages_575332; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the usages (most recent data) for the given database account.
  ## 
  let valid = call_575340.validator(path, query, header, formData, body)
  let scheme = call_575340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575340.url(scheme.get, call_575340.host, call_575340.base,
                         call_575340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575340, url, valid)

proc call*(call_575341: Call_DatabaseAccountsListUsages_575332;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string; Filter: string = ""): Recallable =
  ## databaseAccountsListUsages
  ## Retrieves the usages (most recent data) for the given database account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  ##   Filter: string
  ##         : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  var path_575342 = newJObject()
  var query_575343 = newJObject()
  add(path_575342, "resourceGroupName", newJString(resourceGroupName))
  add(query_575343, "api-version", newJString(apiVersion))
  add(path_575342, "subscriptionId", newJString(subscriptionId))
  add(path_575342, "accountName", newJString(accountName))
  add(query_575343, "$filter", newJString(Filter))
  result = call_575341.call(path_575342, query_575343, nil, nil, nil)

var databaseAccountsListUsages* = Call_DatabaseAccountsListUsages_575332(
    name: "databaseAccountsListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/usages",
    validator: validate_DatabaseAccountsListUsages_575333, base: "",
    url: url_DatabaseAccountsListUsages_575334, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
