
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567668 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567668](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567668): Option[Scheme] {.used.} =
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
  Call_DatabaseAccountsCheckNameExists_567890 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsCheckNameExists_567892(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsCheckNameExists_567891(path: JsonNode;
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
  var valid_568065 = path.getOrDefault("accountName")
  valid_568065 = validateParameter(valid_568065, JString, required = true,
                                 default = nil)
  if valid_568065 != nil:
    section.add "accountName", valid_568065
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568066 = query.getOrDefault("api-version")
  valid_568066 = validateParameter(valid_568066, JString, required = true,
                                 default = nil)
  if valid_568066 != nil:
    section.add "api-version", valid_568066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568089: Call_DatabaseAccountsCheckNameExists_567890;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks that the Azure Cosmos DB account name already exists. A valid account name may contain only lowercase letters, numbers, and the '-' character, and must be between 3 and 50 characters.
  ## 
  let valid = call_568089.validator(path, query, header, formData, body)
  let scheme = call_568089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568089.url(scheme.get, call_568089.host, call_568089.base,
                         call_568089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568089, url, valid)

proc call*(call_568160: Call_DatabaseAccountsCheckNameExists_567890;
          apiVersion: string; accountName: string): Recallable =
  ## databaseAccountsCheckNameExists
  ## Checks that the Azure Cosmos DB account name already exists. A valid account name may contain only lowercase letters, numbers, and the '-' character, and must be between 3 and 50 characters.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_568161 = newJObject()
  var query_568163 = newJObject()
  add(query_568163, "api-version", newJString(apiVersion))
  add(path_568161, "accountName", newJString(accountName))
  result = call_568160.call(path_568161, query_568163, nil, nil, nil)

var databaseAccountsCheckNameExists* = Call_DatabaseAccountsCheckNameExists_567890(
    name: "databaseAccountsCheckNameExists", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/providers/Microsoft.DocumentDB/databaseAccountNames/{accountName}",
    validator: validate_DatabaseAccountsCheckNameExists_567891, base: "",
    url: url_DatabaseAccountsCheckNameExists_567892, schemes: {Scheme.Https})
type
  Call_OperationsList_568202 = ref object of OpenApiRestCall_567668
proc url_OperationsList_568204(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_568203(path: JsonNode; query: JsonNode;
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
  var valid_568205 = query.getOrDefault("api-version")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "api-version", valid_568205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568206: Call_OperationsList_568202; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Cosmos DB Resource Provider operations.
  ## 
  let valid = call_568206.validator(path, query, header, formData, body)
  let scheme = call_568206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568206.url(scheme.get, call_568206.host, call_568206.base,
                         call_568206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568206, url, valid)

proc call*(call_568207: Call_OperationsList_568202; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Cosmos DB Resource Provider operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  var query_568208 = newJObject()
  add(query_568208, "api-version", newJString(apiVersion))
  result = call_568207.call(nil, query_568208, nil, nil, nil)

var operationsList* = Call_OperationsList_568202(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DocumentDB/operations",
    validator: validate_OperationsList_568203, base: "", url: url_OperationsList_568204,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsList_568209 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsList_568211(protocol: Scheme; host: string; base: string;
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

proc validate_DatabaseAccountsList_568210(path: JsonNode; query: JsonNode;
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
  var valid_568212 = path.getOrDefault("subscriptionId")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "subscriptionId", valid_568212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568213 = query.getOrDefault("api-version")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "api-version", valid_568213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568214: Call_DatabaseAccountsList_568209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the Azure Cosmos DB database accounts available under the subscription.
  ## 
  let valid = call_568214.validator(path, query, header, formData, body)
  let scheme = call_568214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568214.url(scheme.get, call_568214.host, call_568214.base,
                         call_568214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568214, url, valid)

proc call*(call_568215: Call_DatabaseAccountsList_568209; apiVersion: string;
          subscriptionId: string): Recallable =
  ## databaseAccountsList
  ## Lists all the Azure Cosmos DB database accounts available under the subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  var path_568216 = newJObject()
  var query_568217 = newJObject()
  add(query_568217, "api-version", newJString(apiVersion))
  add(path_568216, "subscriptionId", newJString(subscriptionId))
  result = call_568215.call(path_568216, query_568217, nil, nil, nil)

var databaseAccountsList* = Call_DatabaseAccountsList_568209(
    name: "databaseAccountsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DocumentDB/databaseAccounts",
    validator: validate_DatabaseAccountsList_568210, base: "",
    url: url_DatabaseAccountsList_568211, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListByResourceGroup_568218 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsListByResourceGroup_568220(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListByResourceGroup_568219(path: JsonNode;
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
  var valid_568221 = path.getOrDefault("resourceGroupName")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "resourceGroupName", valid_568221
  var valid_568222 = path.getOrDefault("subscriptionId")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "subscriptionId", valid_568222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568223 = query.getOrDefault("api-version")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "api-version", valid_568223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568224: Call_DatabaseAccountsListByResourceGroup_568218;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the Azure Cosmos DB database accounts available under the given resource group.
  ## 
  let valid = call_568224.validator(path, query, header, formData, body)
  let scheme = call_568224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568224.url(scheme.get, call_568224.host, call_568224.base,
                         call_568224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568224, url, valid)

proc call*(call_568225: Call_DatabaseAccountsListByResourceGroup_568218;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## databaseAccountsListByResourceGroup
  ## Lists all the Azure Cosmos DB database accounts available under the given resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  var path_568226 = newJObject()
  var query_568227 = newJObject()
  add(path_568226, "resourceGroupName", newJString(resourceGroupName))
  add(query_568227, "api-version", newJString(apiVersion))
  add(path_568226, "subscriptionId", newJString(subscriptionId))
  result = call_568225.call(path_568226, query_568227, nil, nil, nil)

var databaseAccountsListByResourceGroup* = Call_DatabaseAccountsListByResourceGroup_568218(
    name: "databaseAccountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts",
    validator: validate_DatabaseAccountsListByResourceGroup_568219, base: "",
    url: url_DatabaseAccountsListByResourceGroup_568220, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateOrUpdate_568239 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsCreateOrUpdate_568241(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsCreateOrUpdate_568240(path: JsonNode;
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
  var valid_568242 = path.getOrDefault("resourceGroupName")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "resourceGroupName", valid_568242
  var valid_568243 = path.getOrDefault("subscriptionId")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "subscriptionId", valid_568243
  var valid_568244 = path.getOrDefault("accountName")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "accountName", valid_568244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568245 = query.getOrDefault("api-version")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "api-version", valid_568245
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

proc call*(call_568247: Call_DatabaseAccountsCreateOrUpdate_568239; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an Azure Cosmos DB database account.
  ## 
  let valid = call_568247.validator(path, query, header, formData, body)
  let scheme = call_568247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568247.url(scheme.get, call_568247.host, call_568247.base,
                         call_568247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568247, url, valid)

proc call*(call_568248: Call_DatabaseAccountsCreateOrUpdate_568239;
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
  var path_568249 = newJObject()
  var query_568250 = newJObject()
  var body_568251 = newJObject()
  add(path_568249, "resourceGroupName", newJString(resourceGroupName))
  add(query_568250, "api-version", newJString(apiVersion))
  if createUpdateParameters != nil:
    body_568251 = createUpdateParameters
  add(path_568249, "subscriptionId", newJString(subscriptionId))
  add(path_568249, "accountName", newJString(accountName))
  result = call_568248.call(path_568249, query_568250, nil, nil, body_568251)

var databaseAccountsCreateOrUpdate* = Call_DatabaseAccountsCreateOrUpdate_568239(
    name: "databaseAccountsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}",
    validator: validate_DatabaseAccountsCreateOrUpdate_568240, base: "",
    url: url_DatabaseAccountsCreateOrUpdate_568241, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGet_568228 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsGet_568230(protocol: Scheme; host: string; base: string;
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

proc validate_DatabaseAccountsGet_568229(path: JsonNode; query: JsonNode;
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
  var valid_568231 = path.getOrDefault("resourceGroupName")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "resourceGroupName", valid_568231
  var valid_568232 = path.getOrDefault("subscriptionId")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "subscriptionId", valid_568232
  var valid_568233 = path.getOrDefault("accountName")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "accountName", valid_568233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568234 = query.getOrDefault("api-version")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "api-version", valid_568234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568235: Call_DatabaseAccountsGet_568228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the properties of an existing Azure Cosmos DB database account.
  ## 
  let valid = call_568235.validator(path, query, header, formData, body)
  let scheme = call_568235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568235.url(scheme.get, call_568235.host, call_568235.base,
                         call_568235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568235, url, valid)

proc call*(call_568236: Call_DatabaseAccountsGet_568228; resourceGroupName: string;
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
  var path_568237 = newJObject()
  var query_568238 = newJObject()
  add(path_568237, "resourceGroupName", newJString(resourceGroupName))
  add(query_568238, "api-version", newJString(apiVersion))
  add(path_568237, "subscriptionId", newJString(subscriptionId))
  add(path_568237, "accountName", newJString(accountName))
  result = call_568236.call(path_568237, query_568238, nil, nil, nil)

var databaseAccountsGet* = Call_DatabaseAccountsGet_568228(
    name: "databaseAccountsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}",
    validator: validate_DatabaseAccountsGet_568229, base: "",
    url: url_DatabaseAccountsGet_568230, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsPatch_568263 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsPatch_568265(protocol: Scheme; host: string; base: string;
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

proc validate_DatabaseAccountsPatch_568264(path: JsonNode; query: JsonNode;
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
  var valid_568266 = path.getOrDefault("resourceGroupName")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "resourceGroupName", valid_568266
  var valid_568267 = path.getOrDefault("subscriptionId")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "subscriptionId", valid_568267
  var valid_568268 = path.getOrDefault("accountName")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "accountName", valid_568268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568269 = query.getOrDefault("api-version")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "api-version", valid_568269
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

proc call*(call_568271: Call_DatabaseAccountsPatch_568263; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patches the properties of an existing Azure Cosmos DB database account.
  ## 
  let valid = call_568271.validator(path, query, header, formData, body)
  let scheme = call_568271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568271.url(scheme.get, call_568271.host, call_568271.base,
                         call_568271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568271, url, valid)

proc call*(call_568272: Call_DatabaseAccountsPatch_568263;
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
  var path_568273 = newJObject()
  var query_568274 = newJObject()
  var body_568275 = newJObject()
  add(path_568273, "resourceGroupName", newJString(resourceGroupName))
  add(query_568274, "api-version", newJString(apiVersion))
  add(path_568273, "subscriptionId", newJString(subscriptionId))
  if updateParameters != nil:
    body_568275 = updateParameters
  add(path_568273, "accountName", newJString(accountName))
  result = call_568272.call(path_568273, query_568274, nil, nil, body_568275)

var databaseAccountsPatch* = Call_DatabaseAccountsPatch_568263(
    name: "databaseAccountsPatch", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}",
    validator: validate_DatabaseAccountsPatch_568264, base: "",
    url: url_DatabaseAccountsPatch_568265, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDelete_568252 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsDelete_568254(protocol: Scheme; host: string; base: string;
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

proc validate_DatabaseAccountsDelete_568253(path: JsonNode; query: JsonNode;
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
  var valid_568255 = path.getOrDefault("resourceGroupName")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "resourceGroupName", valid_568255
  var valid_568256 = path.getOrDefault("subscriptionId")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "subscriptionId", valid_568256
  var valid_568257 = path.getOrDefault("accountName")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "accountName", valid_568257
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568258 = query.getOrDefault("api-version")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "api-version", valid_568258
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568259: Call_DatabaseAccountsDelete_568252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB database account.
  ## 
  let valid = call_568259.validator(path, query, header, formData, body)
  let scheme = call_568259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568259.url(scheme.get, call_568259.host, call_568259.base,
                         call_568259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568259, url, valid)

proc call*(call_568260: Call_DatabaseAccountsDelete_568252;
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
  var path_568261 = newJObject()
  var query_568262 = newJObject()
  add(path_568261, "resourceGroupName", newJString(resourceGroupName))
  add(query_568262, "api-version", newJString(apiVersion))
  add(path_568261, "subscriptionId", newJString(subscriptionId))
  add(path_568261, "accountName", newJString(accountName))
  result = call_568260.call(path_568261, query_568262, nil, nil, nil)

var databaseAccountsDelete* = Call_DatabaseAccountsDelete_568252(
    name: "databaseAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}",
    validator: validate_DatabaseAccountsDelete_568253, base: "",
    url: url_DatabaseAccountsDelete_568254, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListCassandraKeyspaces_568276 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsListCassandraKeyspaces_568278(protocol: Scheme;
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

proc validate_DatabaseAccountsListCassandraKeyspaces_568277(path: JsonNode;
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
  var valid_568279 = path.getOrDefault("resourceGroupName")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "resourceGroupName", valid_568279
  var valid_568280 = path.getOrDefault("subscriptionId")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "subscriptionId", valid_568280
  var valid_568281 = path.getOrDefault("accountName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "accountName", valid_568281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568282 = query.getOrDefault("api-version")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "api-version", valid_568282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568283: Call_DatabaseAccountsListCassandraKeyspaces_568276;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Cassandra keyspaces under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_568283.validator(path, query, header, formData, body)
  let scheme = call_568283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568283.url(scheme.get, call_568283.host, call_568283.base,
                         call_568283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568283, url, valid)

proc call*(call_568284: Call_DatabaseAccountsListCassandraKeyspaces_568276;
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
  var path_568285 = newJObject()
  var query_568286 = newJObject()
  add(path_568285, "resourceGroupName", newJString(resourceGroupName))
  add(query_568286, "api-version", newJString(apiVersion))
  add(path_568285, "subscriptionId", newJString(subscriptionId))
  add(path_568285, "accountName", newJString(accountName))
  result = call_568284.call(path_568285, query_568286, nil, nil, nil)

var databaseAccountsListCassandraKeyspaces* = Call_DatabaseAccountsListCassandraKeyspaces_568276(
    name: "databaseAccountsListCassandraKeyspaces", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces",
    validator: validate_DatabaseAccountsListCassandraKeyspaces_568277, base: "",
    url: url_DatabaseAccountsListCassandraKeyspaces_568278,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateCassandraKeyspace_568299 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsCreateUpdateCassandraKeyspace_568301(protocol: Scheme;
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

proc validate_DatabaseAccountsCreateUpdateCassandraKeyspace_568300(
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
  var valid_568302 = path.getOrDefault("resourceGroupName")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "resourceGroupName", valid_568302
  var valid_568303 = path.getOrDefault("keyspaceName")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "keyspaceName", valid_568303
  var valid_568304 = path.getOrDefault("subscriptionId")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "subscriptionId", valid_568304
  var valid_568305 = path.getOrDefault("accountName")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "accountName", valid_568305
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568306 = query.getOrDefault("api-version")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "api-version", valid_568306
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

proc call*(call_568308: Call_DatabaseAccountsCreateUpdateCassandraKeyspace_568299;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB Cassandra keyspace
  ## 
  let valid = call_568308.validator(path, query, header, formData, body)
  let scheme = call_568308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568308.url(scheme.get, call_568308.host, call_568308.base,
                         call_568308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568308, url, valid)

proc call*(call_568309: Call_DatabaseAccountsCreateUpdateCassandraKeyspace_568299;
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
  var path_568310 = newJObject()
  var query_568311 = newJObject()
  var body_568312 = newJObject()
  add(path_568310, "resourceGroupName", newJString(resourceGroupName))
  add(query_568311, "api-version", newJString(apiVersion))
  if createUpdateCassandraKeyspaceParameters != nil:
    body_568312 = createUpdateCassandraKeyspaceParameters
  add(path_568310, "keyspaceName", newJString(keyspaceName))
  add(path_568310, "subscriptionId", newJString(subscriptionId))
  add(path_568310, "accountName", newJString(accountName))
  result = call_568309.call(path_568310, query_568311, nil, nil, body_568312)

var databaseAccountsCreateUpdateCassandraKeyspace* = Call_DatabaseAccountsCreateUpdateCassandraKeyspace_568299(
    name: "databaseAccountsCreateUpdateCassandraKeyspace",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}",
    validator: validate_DatabaseAccountsCreateUpdateCassandraKeyspace_568300,
    base: "", url: url_DatabaseAccountsCreateUpdateCassandraKeyspace_568301,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetCassandraKeyspace_568287 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsGetCassandraKeyspace_568289(protocol: Scheme;
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

proc validate_DatabaseAccountsGetCassandraKeyspace_568288(path: JsonNode;
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
  var valid_568290 = path.getOrDefault("resourceGroupName")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "resourceGroupName", valid_568290
  var valid_568291 = path.getOrDefault("keyspaceName")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "keyspaceName", valid_568291
  var valid_568292 = path.getOrDefault("subscriptionId")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "subscriptionId", valid_568292
  var valid_568293 = path.getOrDefault("accountName")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "accountName", valid_568293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568294 = query.getOrDefault("api-version")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "api-version", valid_568294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568295: Call_DatabaseAccountsGetCassandraKeyspace_568287;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the Cassandra keyspaces under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_568295.validator(path, query, header, formData, body)
  let scheme = call_568295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568295.url(scheme.get, call_568295.host, call_568295.base,
                         call_568295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568295, url, valid)

proc call*(call_568296: Call_DatabaseAccountsGetCassandraKeyspace_568287;
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
  var path_568297 = newJObject()
  var query_568298 = newJObject()
  add(path_568297, "resourceGroupName", newJString(resourceGroupName))
  add(query_568298, "api-version", newJString(apiVersion))
  add(path_568297, "keyspaceName", newJString(keyspaceName))
  add(path_568297, "subscriptionId", newJString(subscriptionId))
  add(path_568297, "accountName", newJString(accountName))
  result = call_568296.call(path_568297, query_568298, nil, nil, nil)

var databaseAccountsGetCassandraKeyspace* = Call_DatabaseAccountsGetCassandraKeyspace_568287(
    name: "databaseAccountsGetCassandraKeyspace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}",
    validator: validate_DatabaseAccountsGetCassandraKeyspace_568288, base: "",
    url: url_DatabaseAccountsGetCassandraKeyspace_568289, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteCassandraKeyspace_568313 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsDeleteCassandraKeyspace_568315(protocol: Scheme;
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

proc validate_DatabaseAccountsDeleteCassandraKeyspace_568314(path: JsonNode;
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
  var valid_568316 = path.getOrDefault("resourceGroupName")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "resourceGroupName", valid_568316
  var valid_568317 = path.getOrDefault("keyspaceName")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "keyspaceName", valid_568317
  var valid_568318 = path.getOrDefault("subscriptionId")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "subscriptionId", valid_568318
  var valid_568319 = path.getOrDefault("accountName")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "accountName", valid_568319
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568320 = query.getOrDefault("api-version")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "api-version", valid_568320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568321: Call_DatabaseAccountsDeleteCassandraKeyspace_568313;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB Cassandra keyspace.
  ## 
  let valid = call_568321.validator(path, query, header, formData, body)
  let scheme = call_568321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568321.url(scheme.get, call_568321.host, call_568321.base,
                         call_568321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568321, url, valid)

proc call*(call_568322: Call_DatabaseAccountsDeleteCassandraKeyspace_568313;
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
  var path_568323 = newJObject()
  var query_568324 = newJObject()
  add(path_568323, "resourceGroupName", newJString(resourceGroupName))
  add(query_568324, "api-version", newJString(apiVersion))
  add(path_568323, "keyspaceName", newJString(keyspaceName))
  add(path_568323, "subscriptionId", newJString(subscriptionId))
  add(path_568323, "accountName", newJString(accountName))
  result = call_568322.call(path_568323, query_568324, nil, nil, nil)

var databaseAccountsDeleteCassandraKeyspace* = Call_DatabaseAccountsDeleteCassandraKeyspace_568313(
    name: "databaseAccountsDeleteCassandraKeyspace", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}",
    validator: validate_DatabaseAccountsDeleteCassandraKeyspace_568314, base: "",
    url: url_DatabaseAccountsDeleteCassandraKeyspace_568315,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateCassandraKeyspaceThroughput_568337 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsUpdateCassandraKeyspaceThroughput_568339(
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

proc validate_DatabaseAccountsUpdateCassandraKeyspaceThroughput_568338(
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
  var valid_568340 = path.getOrDefault("resourceGroupName")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "resourceGroupName", valid_568340
  var valid_568341 = path.getOrDefault("keyspaceName")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "keyspaceName", valid_568341
  var valid_568342 = path.getOrDefault("subscriptionId")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "subscriptionId", valid_568342
  var valid_568343 = path.getOrDefault("accountName")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "accountName", valid_568343
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568344 = query.getOrDefault("api-version")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "api-version", valid_568344
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

proc call*(call_568346: Call_DatabaseAccountsUpdateCassandraKeyspaceThroughput_568337;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Cassandra Keyspace
  ## 
  let valid = call_568346.validator(path, query, header, formData, body)
  let scheme = call_568346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568346.url(scheme.get, call_568346.host, call_568346.base,
                         call_568346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568346, url, valid)

proc call*(call_568347: Call_DatabaseAccountsUpdateCassandraKeyspaceThroughput_568337;
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
  var path_568348 = newJObject()
  var query_568349 = newJObject()
  var body_568350 = newJObject()
  add(path_568348, "resourceGroupName", newJString(resourceGroupName))
  add(query_568349, "api-version", newJString(apiVersion))
  add(path_568348, "keyspaceName", newJString(keyspaceName))
  add(path_568348, "subscriptionId", newJString(subscriptionId))
  if updateThroughputParameters != nil:
    body_568350 = updateThroughputParameters
  add(path_568348, "accountName", newJString(accountName))
  result = call_568347.call(path_568348, query_568349, nil, nil, body_568350)

var databaseAccountsUpdateCassandraKeyspaceThroughput* = Call_DatabaseAccountsUpdateCassandraKeyspaceThroughput_568337(
    name: "databaseAccountsUpdateCassandraKeyspaceThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateCassandraKeyspaceThroughput_568338,
    base: "", url: url_DatabaseAccountsUpdateCassandraKeyspaceThroughput_568339,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetCassandraKeyspaceThroughput_568325 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsGetCassandraKeyspaceThroughput_568327(protocol: Scheme;
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

proc validate_DatabaseAccountsGetCassandraKeyspaceThroughput_568326(
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
  var valid_568328 = path.getOrDefault("resourceGroupName")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "resourceGroupName", valid_568328
  var valid_568329 = path.getOrDefault("keyspaceName")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "keyspaceName", valid_568329
  var valid_568330 = path.getOrDefault("subscriptionId")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "subscriptionId", valid_568330
  var valid_568331 = path.getOrDefault("accountName")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "accountName", valid_568331
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568332 = query.getOrDefault("api-version")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "api-version", valid_568332
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568333: Call_DatabaseAccountsGetCassandraKeyspaceThroughput_568325;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the Cassandra Keyspace under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_568333.validator(path, query, header, formData, body)
  let scheme = call_568333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568333.url(scheme.get, call_568333.host, call_568333.base,
                         call_568333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568333, url, valid)

proc call*(call_568334: Call_DatabaseAccountsGetCassandraKeyspaceThroughput_568325;
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
  var path_568335 = newJObject()
  var query_568336 = newJObject()
  add(path_568335, "resourceGroupName", newJString(resourceGroupName))
  add(query_568336, "api-version", newJString(apiVersion))
  add(path_568335, "keyspaceName", newJString(keyspaceName))
  add(path_568335, "subscriptionId", newJString(subscriptionId))
  add(path_568335, "accountName", newJString(accountName))
  result = call_568334.call(path_568335, query_568336, nil, nil, nil)

var databaseAccountsGetCassandraKeyspaceThroughput* = Call_DatabaseAccountsGetCassandraKeyspaceThroughput_568325(
    name: "databaseAccountsGetCassandraKeyspaceThroughput",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/settings/throughput",
    validator: validate_DatabaseAccountsGetCassandraKeyspaceThroughput_568326,
    base: "", url: url_DatabaseAccountsGetCassandraKeyspaceThroughput_568327,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListCassandraTables_568351 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsListCassandraTables_568353(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListCassandraTables_568352(path: JsonNode;
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
  var valid_568354 = path.getOrDefault("resourceGroupName")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "resourceGroupName", valid_568354
  var valid_568355 = path.getOrDefault("keyspaceName")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "keyspaceName", valid_568355
  var valid_568356 = path.getOrDefault("subscriptionId")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "subscriptionId", valid_568356
  var valid_568357 = path.getOrDefault("accountName")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "accountName", valid_568357
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568358 = query.getOrDefault("api-version")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "api-version", valid_568358
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568359: Call_DatabaseAccountsListCassandraTables_568351;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Cassandra table under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_568359.validator(path, query, header, formData, body)
  let scheme = call_568359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568359.url(scheme.get, call_568359.host, call_568359.base,
                         call_568359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568359, url, valid)

proc call*(call_568360: Call_DatabaseAccountsListCassandraTables_568351;
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
  var path_568361 = newJObject()
  var query_568362 = newJObject()
  add(path_568361, "resourceGroupName", newJString(resourceGroupName))
  add(query_568362, "api-version", newJString(apiVersion))
  add(path_568361, "keyspaceName", newJString(keyspaceName))
  add(path_568361, "subscriptionId", newJString(subscriptionId))
  add(path_568361, "accountName", newJString(accountName))
  result = call_568360.call(path_568361, query_568362, nil, nil, nil)

var databaseAccountsListCassandraTables* = Call_DatabaseAccountsListCassandraTables_568351(
    name: "databaseAccountsListCassandraTables", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/tables",
    validator: validate_DatabaseAccountsListCassandraTables_568352, base: "",
    url: url_DatabaseAccountsListCassandraTables_568353, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateCassandraTable_568376 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsCreateUpdateCassandraTable_568378(protocol: Scheme;
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

proc validate_DatabaseAccountsCreateUpdateCassandraTable_568377(path: JsonNode;
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
  var valid_568379 = path.getOrDefault("resourceGroupName")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "resourceGroupName", valid_568379
  var valid_568380 = path.getOrDefault("keyspaceName")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "keyspaceName", valid_568380
  var valid_568381 = path.getOrDefault("subscriptionId")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "subscriptionId", valid_568381
  var valid_568382 = path.getOrDefault("tableName")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "tableName", valid_568382
  var valid_568383 = path.getOrDefault("accountName")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "accountName", valid_568383
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568384 = query.getOrDefault("api-version")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "api-version", valid_568384
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

proc call*(call_568386: Call_DatabaseAccountsCreateUpdateCassandraTable_568376;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB Cassandra Table
  ## 
  let valid = call_568386.validator(path, query, header, formData, body)
  let scheme = call_568386.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568386.url(scheme.get, call_568386.host, call_568386.base,
                         call_568386.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568386, url, valid)

proc call*(call_568387: Call_DatabaseAccountsCreateUpdateCassandraTable_568376;
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
  var path_568388 = newJObject()
  var query_568389 = newJObject()
  var body_568390 = newJObject()
  add(path_568388, "resourceGroupName", newJString(resourceGroupName))
  add(query_568389, "api-version", newJString(apiVersion))
  add(path_568388, "keyspaceName", newJString(keyspaceName))
  add(path_568388, "subscriptionId", newJString(subscriptionId))
  add(path_568388, "tableName", newJString(tableName))
  if createUpdateCassandraTableParameters != nil:
    body_568390 = createUpdateCassandraTableParameters
  add(path_568388, "accountName", newJString(accountName))
  result = call_568387.call(path_568388, query_568389, nil, nil, body_568390)

var databaseAccountsCreateUpdateCassandraTable* = Call_DatabaseAccountsCreateUpdateCassandraTable_568376(
    name: "databaseAccountsCreateUpdateCassandraTable", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/tables/{tableName}",
    validator: validate_DatabaseAccountsCreateUpdateCassandraTable_568377,
    base: "", url: url_DatabaseAccountsCreateUpdateCassandraTable_568378,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetCassandraTable_568363 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsGetCassandraTable_568365(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsGetCassandraTable_568364(path: JsonNode;
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
  var valid_568366 = path.getOrDefault("resourceGroupName")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "resourceGroupName", valid_568366
  var valid_568367 = path.getOrDefault("keyspaceName")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "keyspaceName", valid_568367
  var valid_568368 = path.getOrDefault("subscriptionId")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = nil)
  if valid_568368 != nil:
    section.add "subscriptionId", valid_568368
  var valid_568369 = path.getOrDefault("tableName")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "tableName", valid_568369
  var valid_568370 = path.getOrDefault("accountName")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "accountName", valid_568370
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568371 = query.getOrDefault("api-version")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "api-version", valid_568371
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568372: Call_DatabaseAccountsGetCassandraTable_568363;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the Cassandra table under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_568372.validator(path, query, header, formData, body)
  let scheme = call_568372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568372.url(scheme.get, call_568372.host, call_568372.base,
                         call_568372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568372, url, valid)

proc call*(call_568373: Call_DatabaseAccountsGetCassandraTable_568363;
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
  var path_568374 = newJObject()
  var query_568375 = newJObject()
  add(path_568374, "resourceGroupName", newJString(resourceGroupName))
  add(query_568375, "api-version", newJString(apiVersion))
  add(path_568374, "keyspaceName", newJString(keyspaceName))
  add(path_568374, "subscriptionId", newJString(subscriptionId))
  add(path_568374, "tableName", newJString(tableName))
  add(path_568374, "accountName", newJString(accountName))
  result = call_568373.call(path_568374, query_568375, nil, nil, nil)

var databaseAccountsGetCassandraTable* = Call_DatabaseAccountsGetCassandraTable_568363(
    name: "databaseAccountsGetCassandraTable", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/tables/{tableName}",
    validator: validate_DatabaseAccountsGetCassandraTable_568364, base: "",
    url: url_DatabaseAccountsGetCassandraTable_568365, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteCassandraTable_568391 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsDeleteCassandraTable_568393(protocol: Scheme;
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

proc validate_DatabaseAccountsDeleteCassandraTable_568392(path: JsonNode;
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
  var valid_568394 = path.getOrDefault("resourceGroupName")
  valid_568394 = validateParameter(valid_568394, JString, required = true,
                                 default = nil)
  if valid_568394 != nil:
    section.add "resourceGroupName", valid_568394
  var valid_568395 = path.getOrDefault("keyspaceName")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "keyspaceName", valid_568395
  var valid_568396 = path.getOrDefault("subscriptionId")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "subscriptionId", valid_568396
  var valid_568397 = path.getOrDefault("tableName")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "tableName", valid_568397
  var valid_568398 = path.getOrDefault("accountName")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "accountName", valid_568398
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568399 = query.getOrDefault("api-version")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "api-version", valid_568399
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568400: Call_DatabaseAccountsDeleteCassandraTable_568391;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB Cassandra table.
  ## 
  let valid = call_568400.validator(path, query, header, formData, body)
  let scheme = call_568400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568400.url(scheme.get, call_568400.host, call_568400.base,
                         call_568400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568400, url, valid)

proc call*(call_568401: Call_DatabaseAccountsDeleteCassandraTable_568391;
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
  var path_568402 = newJObject()
  var query_568403 = newJObject()
  add(path_568402, "resourceGroupName", newJString(resourceGroupName))
  add(query_568403, "api-version", newJString(apiVersion))
  add(path_568402, "keyspaceName", newJString(keyspaceName))
  add(path_568402, "subscriptionId", newJString(subscriptionId))
  add(path_568402, "tableName", newJString(tableName))
  add(path_568402, "accountName", newJString(accountName))
  result = call_568401.call(path_568402, query_568403, nil, nil, nil)

var databaseAccountsDeleteCassandraTable* = Call_DatabaseAccountsDeleteCassandraTable_568391(
    name: "databaseAccountsDeleteCassandraTable", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/tables/{tableName}",
    validator: validate_DatabaseAccountsDeleteCassandraTable_568392, base: "",
    url: url_DatabaseAccountsDeleteCassandraTable_568393, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateCassandraTableThroughput_568417 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsUpdateCassandraTableThroughput_568419(protocol: Scheme;
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

proc validate_DatabaseAccountsUpdateCassandraTableThroughput_568418(
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
  var valid_568420 = path.getOrDefault("resourceGroupName")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "resourceGroupName", valid_568420
  var valid_568421 = path.getOrDefault("keyspaceName")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "keyspaceName", valid_568421
  var valid_568422 = path.getOrDefault("subscriptionId")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "subscriptionId", valid_568422
  var valid_568423 = path.getOrDefault("tableName")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "tableName", valid_568423
  var valid_568424 = path.getOrDefault("accountName")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "accountName", valid_568424
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568425 = query.getOrDefault("api-version")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "api-version", valid_568425
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

proc call*(call_568427: Call_DatabaseAccountsUpdateCassandraTableThroughput_568417;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Cassandra table
  ## 
  let valid = call_568427.validator(path, query, header, formData, body)
  let scheme = call_568427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568427.url(scheme.get, call_568427.host, call_568427.base,
                         call_568427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568427, url, valid)

proc call*(call_568428: Call_DatabaseAccountsUpdateCassandraTableThroughput_568417;
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
  var path_568429 = newJObject()
  var query_568430 = newJObject()
  var body_568431 = newJObject()
  add(path_568429, "resourceGroupName", newJString(resourceGroupName))
  add(query_568430, "api-version", newJString(apiVersion))
  add(path_568429, "keyspaceName", newJString(keyspaceName))
  add(path_568429, "subscriptionId", newJString(subscriptionId))
  add(path_568429, "tableName", newJString(tableName))
  if updateThroughputParameters != nil:
    body_568431 = updateThroughputParameters
  add(path_568429, "accountName", newJString(accountName))
  result = call_568428.call(path_568429, query_568430, nil, nil, body_568431)

var databaseAccountsUpdateCassandraTableThroughput* = Call_DatabaseAccountsUpdateCassandraTableThroughput_568417(
    name: "databaseAccountsUpdateCassandraTableThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/tables/{tableName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateCassandraTableThroughput_568418,
    base: "", url: url_DatabaseAccountsUpdateCassandraTableThroughput_568419,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetCassandraTableThroughput_568404 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsGetCassandraTableThroughput_568406(protocol: Scheme;
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

proc validate_DatabaseAccountsGetCassandraTableThroughput_568405(path: JsonNode;
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
  var valid_568407 = path.getOrDefault("resourceGroupName")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "resourceGroupName", valid_568407
  var valid_568408 = path.getOrDefault("keyspaceName")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "keyspaceName", valid_568408
  var valid_568409 = path.getOrDefault("subscriptionId")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "subscriptionId", valid_568409
  var valid_568410 = path.getOrDefault("tableName")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "tableName", valid_568410
  var valid_568411 = path.getOrDefault("accountName")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "accountName", valid_568411
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568412 = query.getOrDefault("api-version")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "api-version", valid_568412
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568413: Call_DatabaseAccountsGetCassandraTableThroughput_568404;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the Cassandra table under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_568413.validator(path, query, header, formData, body)
  let scheme = call_568413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568413.url(scheme.get, call_568413.host, call_568413.base,
                         call_568413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568413, url, valid)

proc call*(call_568414: Call_DatabaseAccountsGetCassandraTableThroughput_568404;
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
  var path_568415 = newJObject()
  var query_568416 = newJObject()
  add(path_568415, "resourceGroupName", newJString(resourceGroupName))
  add(query_568416, "api-version", newJString(apiVersion))
  add(path_568415, "keyspaceName", newJString(keyspaceName))
  add(path_568415, "subscriptionId", newJString(subscriptionId))
  add(path_568415, "tableName", newJString(tableName))
  add(path_568415, "accountName", newJString(accountName))
  result = call_568414.call(path_568415, query_568416, nil, nil, nil)

var databaseAccountsGetCassandraTableThroughput* = Call_DatabaseAccountsGetCassandraTableThroughput_568404(
    name: "databaseAccountsGetCassandraTableThroughput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/tables/{tableName}/settings/throughput",
    validator: validate_DatabaseAccountsGetCassandraTableThroughput_568405,
    base: "", url: url_DatabaseAccountsGetCassandraTableThroughput_568406,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListGremlinDatabases_568432 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsListGremlinDatabases_568434(protocol: Scheme;
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

proc validate_DatabaseAccountsListGremlinDatabases_568433(path: JsonNode;
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
  var valid_568435 = path.getOrDefault("resourceGroupName")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "resourceGroupName", valid_568435
  var valid_568436 = path.getOrDefault("subscriptionId")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "subscriptionId", valid_568436
  var valid_568437 = path.getOrDefault("accountName")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "accountName", valid_568437
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568438 = query.getOrDefault("api-version")
  valid_568438 = validateParameter(valid_568438, JString, required = true,
                                 default = nil)
  if valid_568438 != nil:
    section.add "api-version", valid_568438
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568439: Call_DatabaseAccountsListGremlinDatabases_568432;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Gremlin databases under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_568439.validator(path, query, header, formData, body)
  let scheme = call_568439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568439.url(scheme.get, call_568439.host, call_568439.base,
                         call_568439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568439, url, valid)

proc call*(call_568440: Call_DatabaseAccountsListGremlinDatabases_568432;
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
  var path_568441 = newJObject()
  var query_568442 = newJObject()
  add(path_568441, "resourceGroupName", newJString(resourceGroupName))
  add(query_568442, "api-version", newJString(apiVersion))
  add(path_568441, "subscriptionId", newJString(subscriptionId))
  add(path_568441, "accountName", newJString(accountName))
  result = call_568440.call(path_568441, query_568442, nil, nil, nil)

var databaseAccountsListGremlinDatabases* = Call_DatabaseAccountsListGremlinDatabases_568432(
    name: "databaseAccountsListGremlinDatabases", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases",
    validator: validate_DatabaseAccountsListGremlinDatabases_568433, base: "",
    url: url_DatabaseAccountsListGremlinDatabases_568434, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateGremlinDatabase_568455 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsCreateUpdateGremlinDatabase_568457(protocol: Scheme;
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

proc validate_DatabaseAccountsCreateUpdateGremlinDatabase_568456(path: JsonNode;
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
  var valid_568458 = path.getOrDefault("resourceGroupName")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "resourceGroupName", valid_568458
  var valid_568459 = path.getOrDefault("subscriptionId")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "subscriptionId", valid_568459
  var valid_568460 = path.getOrDefault("databaseName")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "databaseName", valid_568460
  var valid_568461 = path.getOrDefault("accountName")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "accountName", valid_568461
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568462 = query.getOrDefault("api-version")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "api-version", valid_568462
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

proc call*(call_568464: Call_DatabaseAccountsCreateUpdateGremlinDatabase_568455;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB Gremlin database
  ## 
  let valid = call_568464.validator(path, query, header, formData, body)
  let scheme = call_568464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568464.url(scheme.get, call_568464.host, call_568464.base,
                         call_568464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568464, url, valid)

proc call*(call_568465: Call_DatabaseAccountsCreateUpdateGremlinDatabase_568455;
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
  var path_568466 = newJObject()
  var query_568467 = newJObject()
  var body_568468 = newJObject()
  add(path_568466, "resourceGroupName", newJString(resourceGroupName))
  add(query_568467, "api-version", newJString(apiVersion))
  add(path_568466, "subscriptionId", newJString(subscriptionId))
  if createUpdateGremlinDatabaseParameters != nil:
    body_568468 = createUpdateGremlinDatabaseParameters
  add(path_568466, "databaseName", newJString(databaseName))
  add(path_568466, "accountName", newJString(accountName))
  result = call_568465.call(path_568466, query_568467, nil, nil, body_568468)

var databaseAccountsCreateUpdateGremlinDatabase* = Call_DatabaseAccountsCreateUpdateGremlinDatabase_568455(
    name: "databaseAccountsCreateUpdateGremlinDatabase", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}",
    validator: validate_DatabaseAccountsCreateUpdateGremlinDatabase_568456,
    base: "", url: url_DatabaseAccountsCreateUpdateGremlinDatabase_568457,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetGremlinDatabase_568443 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsGetGremlinDatabase_568445(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsGetGremlinDatabase_568444(path: JsonNode;
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
  var valid_568446 = path.getOrDefault("resourceGroupName")
  valid_568446 = validateParameter(valid_568446, JString, required = true,
                                 default = nil)
  if valid_568446 != nil:
    section.add "resourceGroupName", valid_568446
  var valid_568447 = path.getOrDefault("subscriptionId")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = nil)
  if valid_568447 != nil:
    section.add "subscriptionId", valid_568447
  var valid_568448 = path.getOrDefault("databaseName")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "databaseName", valid_568448
  var valid_568449 = path.getOrDefault("accountName")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "accountName", valid_568449
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568450 = query.getOrDefault("api-version")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "api-version", valid_568450
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568451: Call_DatabaseAccountsGetGremlinDatabase_568443;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the Gremlin databases under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_568451.validator(path, query, header, formData, body)
  let scheme = call_568451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568451.url(scheme.get, call_568451.host, call_568451.base,
                         call_568451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568451, url, valid)

proc call*(call_568452: Call_DatabaseAccountsGetGremlinDatabase_568443;
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
  var path_568453 = newJObject()
  var query_568454 = newJObject()
  add(path_568453, "resourceGroupName", newJString(resourceGroupName))
  add(query_568454, "api-version", newJString(apiVersion))
  add(path_568453, "subscriptionId", newJString(subscriptionId))
  add(path_568453, "databaseName", newJString(databaseName))
  add(path_568453, "accountName", newJString(accountName))
  result = call_568452.call(path_568453, query_568454, nil, nil, nil)

var databaseAccountsGetGremlinDatabase* = Call_DatabaseAccountsGetGremlinDatabase_568443(
    name: "databaseAccountsGetGremlinDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}",
    validator: validate_DatabaseAccountsGetGremlinDatabase_568444, base: "",
    url: url_DatabaseAccountsGetGremlinDatabase_568445, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteGremlinDatabase_568469 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsDeleteGremlinDatabase_568471(protocol: Scheme;
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

proc validate_DatabaseAccountsDeleteGremlinDatabase_568470(path: JsonNode;
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
  var valid_568472 = path.getOrDefault("resourceGroupName")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "resourceGroupName", valid_568472
  var valid_568473 = path.getOrDefault("subscriptionId")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "subscriptionId", valid_568473
  var valid_568474 = path.getOrDefault("databaseName")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = nil)
  if valid_568474 != nil:
    section.add "databaseName", valid_568474
  var valid_568475 = path.getOrDefault("accountName")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "accountName", valid_568475
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568476 = query.getOrDefault("api-version")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = nil)
  if valid_568476 != nil:
    section.add "api-version", valid_568476
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568477: Call_DatabaseAccountsDeleteGremlinDatabase_568469;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB Gremlin database.
  ## 
  let valid = call_568477.validator(path, query, header, formData, body)
  let scheme = call_568477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568477.url(scheme.get, call_568477.host, call_568477.base,
                         call_568477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568477, url, valid)

proc call*(call_568478: Call_DatabaseAccountsDeleteGremlinDatabase_568469;
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
  var path_568479 = newJObject()
  var query_568480 = newJObject()
  add(path_568479, "resourceGroupName", newJString(resourceGroupName))
  add(query_568480, "api-version", newJString(apiVersion))
  add(path_568479, "subscriptionId", newJString(subscriptionId))
  add(path_568479, "databaseName", newJString(databaseName))
  add(path_568479, "accountName", newJString(accountName))
  result = call_568478.call(path_568479, query_568480, nil, nil, nil)

var databaseAccountsDeleteGremlinDatabase* = Call_DatabaseAccountsDeleteGremlinDatabase_568469(
    name: "databaseAccountsDeleteGremlinDatabase", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}",
    validator: validate_DatabaseAccountsDeleteGremlinDatabase_568470, base: "",
    url: url_DatabaseAccountsDeleteGremlinDatabase_568471, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListGremlinGraphs_568481 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsListGremlinGraphs_568483(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListGremlinGraphs_568482(path: JsonNode;
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
  var valid_568484 = path.getOrDefault("resourceGroupName")
  valid_568484 = validateParameter(valid_568484, JString, required = true,
                                 default = nil)
  if valid_568484 != nil:
    section.add "resourceGroupName", valid_568484
  var valid_568485 = path.getOrDefault("subscriptionId")
  valid_568485 = validateParameter(valid_568485, JString, required = true,
                                 default = nil)
  if valid_568485 != nil:
    section.add "subscriptionId", valid_568485
  var valid_568486 = path.getOrDefault("databaseName")
  valid_568486 = validateParameter(valid_568486, JString, required = true,
                                 default = nil)
  if valid_568486 != nil:
    section.add "databaseName", valid_568486
  var valid_568487 = path.getOrDefault("accountName")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "accountName", valid_568487
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568488 = query.getOrDefault("api-version")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "api-version", valid_568488
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568489: Call_DatabaseAccountsListGremlinGraphs_568481;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Gremlin graph under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_568489.validator(path, query, header, formData, body)
  let scheme = call_568489.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568489.url(scheme.get, call_568489.host, call_568489.base,
                         call_568489.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568489, url, valid)

proc call*(call_568490: Call_DatabaseAccountsListGremlinGraphs_568481;
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
  var path_568491 = newJObject()
  var query_568492 = newJObject()
  add(path_568491, "resourceGroupName", newJString(resourceGroupName))
  add(query_568492, "api-version", newJString(apiVersion))
  add(path_568491, "subscriptionId", newJString(subscriptionId))
  add(path_568491, "databaseName", newJString(databaseName))
  add(path_568491, "accountName", newJString(accountName))
  result = call_568490.call(path_568491, query_568492, nil, nil, nil)

var databaseAccountsListGremlinGraphs* = Call_DatabaseAccountsListGremlinGraphs_568481(
    name: "databaseAccountsListGremlinGraphs", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/graphs",
    validator: validate_DatabaseAccountsListGremlinGraphs_568482, base: "",
    url: url_DatabaseAccountsListGremlinGraphs_568483, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateGremlinGraph_568506 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsCreateUpdateGremlinGraph_568508(protocol: Scheme;
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

proc validate_DatabaseAccountsCreateUpdateGremlinGraph_568507(path: JsonNode;
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
  var valid_568509 = path.getOrDefault("resourceGroupName")
  valid_568509 = validateParameter(valid_568509, JString, required = true,
                                 default = nil)
  if valid_568509 != nil:
    section.add "resourceGroupName", valid_568509
  var valid_568510 = path.getOrDefault("subscriptionId")
  valid_568510 = validateParameter(valid_568510, JString, required = true,
                                 default = nil)
  if valid_568510 != nil:
    section.add "subscriptionId", valid_568510
  var valid_568511 = path.getOrDefault("databaseName")
  valid_568511 = validateParameter(valid_568511, JString, required = true,
                                 default = nil)
  if valid_568511 != nil:
    section.add "databaseName", valid_568511
  var valid_568512 = path.getOrDefault("graphName")
  valid_568512 = validateParameter(valid_568512, JString, required = true,
                                 default = nil)
  if valid_568512 != nil:
    section.add "graphName", valid_568512
  var valid_568513 = path.getOrDefault("accountName")
  valid_568513 = validateParameter(valid_568513, JString, required = true,
                                 default = nil)
  if valid_568513 != nil:
    section.add "accountName", valid_568513
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568514 = query.getOrDefault("api-version")
  valid_568514 = validateParameter(valid_568514, JString, required = true,
                                 default = nil)
  if valid_568514 != nil:
    section.add "api-version", valid_568514
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

proc call*(call_568516: Call_DatabaseAccountsCreateUpdateGremlinGraph_568506;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB Gremlin graph
  ## 
  let valid = call_568516.validator(path, query, header, formData, body)
  let scheme = call_568516.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568516.url(scheme.get, call_568516.host, call_568516.base,
                         call_568516.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568516, url, valid)

proc call*(call_568517: Call_DatabaseAccountsCreateUpdateGremlinGraph_568506;
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
  var path_568518 = newJObject()
  var query_568519 = newJObject()
  var body_568520 = newJObject()
  add(path_568518, "resourceGroupName", newJString(resourceGroupName))
  add(query_568519, "api-version", newJString(apiVersion))
  if createUpdateGremlinGraphParameters != nil:
    body_568520 = createUpdateGremlinGraphParameters
  add(path_568518, "subscriptionId", newJString(subscriptionId))
  add(path_568518, "databaseName", newJString(databaseName))
  add(path_568518, "graphName", newJString(graphName))
  add(path_568518, "accountName", newJString(accountName))
  result = call_568517.call(path_568518, query_568519, nil, nil, body_568520)

var databaseAccountsCreateUpdateGremlinGraph* = Call_DatabaseAccountsCreateUpdateGremlinGraph_568506(
    name: "databaseAccountsCreateUpdateGremlinGraph", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/graphs/{graphName}",
    validator: validate_DatabaseAccountsCreateUpdateGremlinGraph_568507, base: "",
    url: url_DatabaseAccountsCreateUpdateGremlinGraph_568508,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetGremlinGraph_568493 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsGetGremlinGraph_568495(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsGetGremlinGraph_568494(path: JsonNode;
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
  var valid_568496 = path.getOrDefault("resourceGroupName")
  valid_568496 = validateParameter(valid_568496, JString, required = true,
                                 default = nil)
  if valid_568496 != nil:
    section.add "resourceGroupName", valid_568496
  var valid_568497 = path.getOrDefault("subscriptionId")
  valid_568497 = validateParameter(valid_568497, JString, required = true,
                                 default = nil)
  if valid_568497 != nil:
    section.add "subscriptionId", valid_568497
  var valid_568498 = path.getOrDefault("databaseName")
  valid_568498 = validateParameter(valid_568498, JString, required = true,
                                 default = nil)
  if valid_568498 != nil:
    section.add "databaseName", valid_568498
  var valid_568499 = path.getOrDefault("graphName")
  valid_568499 = validateParameter(valid_568499, JString, required = true,
                                 default = nil)
  if valid_568499 != nil:
    section.add "graphName", valid_568499
  var valid_568500 = path.getOrDefault("accountName")
  valid_568500 = validateParameter(valid_568500, JString, required = true,
                                 default = nil)
  if valid_568500 != nil:
    section.add "accountName", valid_568500
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568501 = query.getOrDefault("api-version")
  valid_568501 = validateParameter(valid_568501, JString, required = true,
                                 default = nil)
  if valid_568501 != nil:
    section.add "api-version", valid_568501
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568502: Call_DatabaseAccountsGetGremlinGraph_568493;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the Gremlin graph under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_568502.validator(path, query, header, formData, body)
  let scheme = call_568502.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568502.url(scheme.get, call_568502.host, call_568502.base,
                         call_568502.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568502, url, valid)

proc call*(call_568503: Call_DatabaseAccountsGetGremlinGraph_568493;
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
  var path_568504 = newJObject()
  var query_568505 = newJObject()
  add(path_568504, "resourceGroupName", newJString(resourceGroupName))
  add(query_568505, "api-version", newJString(apiVersion))
  add(path_568504, "subscriptionId", newJString(subscriptionId))
  add(path_568504, "databaseName", newJString(databaseName))
  add(path_568504, "graphName", newJString(graphName))
  add(path_568504, "accountName", newJString(accountName))
  result = call_568503.call(path_568504, query_568505, nil, nil, nil)

var databaseAccountsGetGremlinGraph* = Call_DatabaseAccountsGetGremlinGraph_568493(
    name: "databaseAccountsGetGremlinGraph", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/graphs/{graphName}",
    validator: validate_DatabaseAccountsGetGremlinGraph_568494, base: "",
    url: url_DatabaseAccountsGetGremlinGraph_568495, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteGremlinGraph_568521 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsDeleteGremlinGraph_568523(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsDeleteGremlinGraph_568522(path: JsonNode;
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
  var valid_568524 = path.getOrDefault("resourceGroupName")
  valid_568524 = validateParameter(valid_568524, JString, required = true,
                                 default = nil)
  if valid_568524 != nil:
    section.add "resourceGroupName", valid_568524
  var valid_568525 = path.getOrDefault("subscriptionId")
  valid_568525 = validateParameter(valid_568525, JString, required = true,
                                 default = nil)
  if valid_568525 != nil:
    section.add "subscriptionId", valid_568525
  var valid_568526 = path.getOrDefault("databaseName")
  valid_568526 = validateParameter(valid_568526, JString, required = true,
                                 default = nil)
  if valid_568526 != nil:
    section.add "databaseName", valid_568526
  var valid_568527 = path.getOrDefault("graphName")
  valid_568527 = validateParameter(valid_568527, JString, required = true,
                                 default = nil)
  if valid_568527 != nil:
    section.add "graphName", valid_568527
  var valid_568528 = path.getOrDefault("accountName")
  valid_568528 = validateParameter(valid_568528, JString, required = true,
                                 default = nil)
  if valid_568528 != nil:
    section.add "accountName", valid_568528
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568529 = query.getOrDefault("api-version")
  valid_568529 = validateParameter(valid_568529, JString, required = true,
                                 default = nil)
  if valid_568529 != nil:
    section.add "api-version", valid_568529
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568530: Call_DatabaseAccountsDeleteGremlinGraph_568521;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB Gremlin graph.
  ## 
  let valid = call_568530.validator(path, query, header, formData, body)
  let scheme = call_568530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568530.url(scheme.get, call_568530.host, call_568530.base,
                         call_568530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568530, url, valid)

proc call*(call_568531: Call_DatabaseAccountsDeleteGremlinGraph_568521;
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
  var path_568532 = newJObject()
  var query_568533 = newJObject()
  add(path_568532, "resourceGroupName", newJString(resourceGroupName))
  add(query_568533, "api-version", newJString(apiVersion))
  add(path_568532, "subscriptionId", newJString(subscriptionId))
  add(path_568532, "databaseName", newJString(databaseName))
  add(path_568532, "graphName", newJString(graphName))
  add(path_568532, "accountName", newJString(accountName))
  result = call_568531.call(path_568532, query_568533, nil, nil, nil)

var databaseAccountsDeleteGremlinGraph* = Call_DatabaseAccountsDeleteGremlinGraph_568521(
    name: "databaseAccountsDeleteGremlinGraph", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/graphs/{graphName}",
    validator: validate_DatabaseAccountsDeleteGremlinGraph_568522, base: "",
    url: url_DatabaseAccountsDeleteGremlinGraph_568523, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateGremlinGraphThroughput_568547 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsUpdateGremlinGraphThroughput_568549(protocol: Scheme;
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

proc validate_DatabaseAccountsUpdateGremlinGraphThroughput_568548(path: JsonNode;
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
  var valid_568550 = path.getOrDefault("resourceGroupName")
  valid_568550 = validateParameter(valid_568550, JString, required = true,
                                 default = nil)
  if valid_568550 != nil:
    section.add "resourceGroupName", valid_568550
  var valid_568551 = path.getOrDefault("subscriptionId")
  valid_568551 = validateParameter(valid_568551, JString, required = true,
                                 default = nil)
  if valid_568551 != nil:
    section.add "subscriptionId", valid_568551
  var valid_568552 = path.getOrDefault("databaseName")
  valid_568552 = validateParameter(valid_568552, JString, required = true,
                                 default = nil)
  if valid_568552 != nil:
    section.add "databaseName", valid_568552
  var valid_568553 = path.getOrDefault("graphName")
  valid_568553 = validateParameter(valid_568553, JString, required = true,
                                 default = nil)
  if valid_568553 != nil:
    section.add "graphName", valid_568553
  var valid_568554 = path.getOrDefault("accountName")
  valid_568554 = validateParameter(valid_568554, JString, required = true,
                                 default = nil)
  if valid_568554 != nil:
    section.add "accountName", valid_568554
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568555 = query.getOrDefault("api-version")
  valid_568555 = validateParameter(valid_568555, JString, required = true,
                                 default = nil)
  if valid_568555 != nil:
    section.add "api-version", valid_568555
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

proc call*(call_568557: Call_DatabaseAccountsUpdateGremlinGraphThroughput_568547;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Gremlin graph
  ## 
  let valid = call_568557.validator(path, query, header, formData, body)
  let scheme = call_568557.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568557.url(scheme.get, call_568557.host, call_568557.base,
                         call_568557.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568557, url, valid)

proc call*(call_568558: Call_DatabaseAccountsUpdateGremlinGraphThroughput_568547;
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
  var path_568559 = newJObject()
  var query_568560 = newJObject()
  var body_568561 = newJObject()
  add(path_568559, "resourceGroupName", newJString(resourceGroupName))
  add(query_568560, "api-version", newJString(apiVersion))
  add(path_568559, "subscriptionId", newJString(subscriptionId))
  add(path_568559, "databaseName", newJString(databaseName))
  if updateThroughputParameters != nil:
    body_568561 = updateThroughputParameters
  add(path_568559, "graphName", newJString(graphName))
  add(path_568559, "accountName", newJString(accountName))
  result = call_568558.call(path_568559, query_568560, nil, nil, body_568561)

var databaseAccountsUpdateGremlinGraphThroughput* = Call_DatabaseAccountsUpdateGremlinGraphThroughput_568547(
    name: "databaseAccountsUpdateGremlinGraphThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/graphs/{graphName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateGremlinGraphThroughput_568548,
    base: "", url: url_DatabaseAccountsUpdateGremlinGraphThroughput_568549,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetGremlinGraphThroughput_568534 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsGetGremlinGraphThroughput_568536(protocol: Scheme;
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

proc validate_DatabaseAccountsGetGremlinGraphThroughput_568535(path: JsonNode;
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
  var valid_568537 = path.getOrDefault("resourceGroupName")
  valid_568537 = validateParameter(valid_568537, JString, required = true,
                                 default = nil)
  if valid_568537 != nil:
    section.add "resourceGroupName", valid_568537
  var valid_568538 = path.getOrDefault("subscriptionId")
  valid_568538 = validateParameter(valid_568538, JString, required = true,
                                 default = nil)
  if valid_568538 != nil:
    section.add "subscriptionId", valid_568538
  var valid_568539 = path.getOrDefault("databaseName")
  valid_568539 = validateParameter(valid_568539, JString, required = true,
                                 default = nil)
  if valid_568539 != nil:
    section.add "databaseName", valid_568539
  var valid_568540 = path.getOrDefault("graphName")
  valid_568540 = validateParameter(valid_568540, JString, required = true,
                                 default = nil)
  if valid_568540 != nil:
    section.add "graphName", valid_568540
  var valid_568541 = path.getOrDefault("accountName")
  valid_568541 = validateParameter(valid_568541, JString, required = true,
                                 default = nil)
  if valid_568541 != nil:
    section.add "accountName", valid_568541
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568542 = query.getOrDefault("api-version")
  valid_568542 = validateParameter(valid_568542, JString, required = true,
                                 default = nil)
  if valid_568542 != nil:
    section.add "api-version", valid_568542
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568543: Call_DatabaseAccountsGetGremlinGraphThroughput_568534;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the Gremlin graph throughput under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_568543.validator(path, query, header, formData, body)
  let scheme = call_568543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568543.url(scheme.get, call_568543.host, call_568543.base,
                         call_568543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568543, url, valid)

proc call*(call_568544: Call_DatabaseAccountsGetGremlinGraphThroughput_568534;
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
  var path_568545 = newJObject()
  var query_568546 = newJObject()
  add(path_568545, "resourceGroupName", newJString(resourceGroupName))
  add(query_568546, "api-version", newJString(apiVersion))
  add(path_568545, "subscriptionId", newJString(subscriptionId))
  add(path_568545, "databaseName", newJString(databaseName))
  add(path_568545, "graphName", newJString(graphName))
  add(path_568545, "accountName", newJString(accountName))
  result = call_568544.call(path_568545, query_568546, nil, nil, nil)

var databaseAccountsGetGremlinGraphThroughput* = Call_DatabaseAccountsGetGremlinGraphThroughput_568534(
    name: "databaseAccountsGetGremlinGraphThroughput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/graphs/{graphName}/settings/throughput",
    validator: validate_DatabaseAccountsGetGremlinGraphThroughput_568535,
    base: "", url: url_DatabaseAccountsGetGremlinGraphThroughput_568536,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateGremlinDatabaseThroughput_568574 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsUpdateGremlinDatabaseThroughput_568576(protocol: Scheme;
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

proc validate_DatabaseAccountsUpdateGremlinDatabaseThroughput_568575(
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
  var valid_568577 = path.getOrDefault("resourceGroupName")
  valid_568577 = validateParameter(valid_568577, JString, required = true,
                                 default = nil)
  if valid_568577 != nil:
    section.add "resourceGroupName", valid_568577
  var valid_568578 = path.getOrDefault("subscriptionId")
  valid_568578 = validateParameter(valid_568578, JString, required = true,
                                 default = nil)
  if valid_568578 != nil:
    section.add "subscriptionId", valid_568578
  var valid_568579 = path.getOrDefault("databaseName")
  valid_568579 = validateParameter(valid_568579, JString, required = true,
                                 default = nil)
  if valid_568579 != nil:
    section.add "databaseName", valid_568579
  var valid_568580 = path.getOrDefault("accountName")
  valid_568580 = validateParameter(valid_568580, JString, required = true,
                                 default = nil)
  if valid_568580 != nil:
    section.add "accountName", valid_568580
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568581 = query.getOrDefault("api-version")
  valid_568581 = validateParameter(valid_568581, JString, required = true,
                                 default = nil)
  if valid_568581 != nil:
    section.add "api-version", valid_568581
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

proc call*(call_568583: Call_DatabaseAccountsUpdateGremlinDatabaseThroughput_568574;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Gremlin database
  ## 
  let valid = call_568583.validator(path, query, header, formData, body)
  let scheme = call_568583.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568583.url(scheme.get, call_568583.host, call_568583.base,
                         call_568583.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568583, url, valid)

proc call*(call_568584: Call_DatabaseAccountsUpdateGremlinDatabaseThroughput_568574;
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
  var path_568585 = newJObject()
  var query_568586 = newJObject()
  var body_568587 = newJObject()
  add(path_568585, "resourceGroupName", newJString(resourceGroupName))
  add(query_568586, "api-version", newJString(apiVersion))
  add(path_568585, "subscriptionId", newJString(subscriptionId))
  add(path_568585, "databaseName", newJString(databaseName))
  if updateThroughputParameters != nil:
    body_568587 = updateThroughputParameters
  add(path_568585, "accountName", newJString(accountName))
  result = call_568584.call(path_568585, query_568586, nil, nil, body_568587)

var databaseAccountsUpdateGremlinDatabaseThroughput* = Call_DatabaseAccountsUpdateGremlinDatabaseThroughput_568574(
    name: "databaseAccountsUpdateGremlinDatabaseThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateGremlinDatabaseThroughput_568575,
    base: "", url: url_DatabaseAccountsUpdateGremlinDatabaseThroughput_568576,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetGremlinDatabaseThroughput_568562 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsGetGremlinDatabaseThroughput_568564(protocol: Scheme;
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

proc validate_DatabaseAccountsGetGremlinDatabaseThroughput_568563(path: JsonNode;
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
  var valid_568565 = path.getOrDefault("resourceGroupName")
  valid_568565 = validateParameter(valid_568565, JString, required = true,
                                 default = nil)
  if valid_568565 != nil:
    section.add "resourceGroupName", valid_568565
  var valid_568566 = path.getOrDefault("subscriptionId")
  valid_568566 = validateParameter(valid_568566, JString, required = true,
                                 default = nil)
  if valid_568566 != nil:
    section.add "subscriptionId", valid_568566
  var valid_568567 = path.getOrDefault("databaseName")
  valid_568567 = validateParameter(valid_568567, JString, required = true,
                                 default = nil)
  if valid_568567 != nil:
    section.add "databaseName", valid_568567
  var valid_568568 = path.getOrDefault("accountName")
  valid_568568 = validateParameter(valid_568568, JString, required = true,
                                 default = nil)
  if valid_568568 != nil:
    section.add "accountName", valid_568568
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568569 = query.getOrDefault("api-version")
  valid_568569 = validateParameter(valid_568569, JString, required = true,
                                 default = nil)
  if valid_568569 != nil:
    section.add "api-version", valid_568569
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568570: Call_DatabaseAccountsGetGremlinDatabaseThroughput_568562;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the Gremlin database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_568570.validator(path, query, header, formData, body)
  let scheme = call_568570.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568570.url(scheme.get, call_568570.host, call_568570.base,
                         call_568570.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568570, url, valid)

proc call*(call_568571: Call_DatabaseAccountsGetGremlinDatabaseThroughput_568562;
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
  var path_568572 = newJObject()
  var query_568573 = newJObject()
  add(path_568572, "resourceGroupName", newJString(resourceGroupName))
  add(query_568573, "api-version", newJString(apiVersion))
  add(path_568572, "subscriptionId", newJString(subscriptionId))
  add(path_568572, "databaseName", newJString(databaseName))
  add(path_568572, "accountName", newJString(accountName))
  result = call_568571.call(path_568572, query_568573, nil, nil, nil)

var databaseAccountsGetGremlinDatabaseThroughput* = Call_DatabaseAccountsGetGremlinDatabaseThroughput_568562(
    name: "databaseAccountsGetGremlinDatabaseThroughput",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/settings/throughput",
    validator: validate_DatabaseAccountsGetGremlinDatabaseThroughput_568563,
    base: "", url: url_DatabaseAccountsGetGremlinDatabaseThroughput_568564,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListMongoDBDatabases_568588 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsListMongoDBDatabases_568590(protocol: Scheme;
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

proc validate_DatabaseAccountsListMongoDBDatabases_568589(path: JsonNode;
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
  var valid_568591 = path.getOrDefault("resourceGroupName")
  valid_568591 = validateParameter(valid_568591, JString, required = true,
                                 default = nil)
  if valid_568591 != nil:
    section.add "resourceGroupName", valid_568591
  var valid_568592 = path.getOrDefault("subscriptionId")
  valid_568592 = validateParameter(valid_568592, JString, required = true,
                                 default = nil)
  if valid_568592 != nil:
    section.add "subscriptionId", valid_568592
  var valid_568593 = path.getOrDefault("accountName")
  valid_568593 = validateParameter(valid_568593, JString, required = true,
                                 default = nil)
  if valid_568593 != nil:
    section.add "accountName", valid_568593
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568594 = query.getOrDefault("api-version")
  valid_568594 = validateParameter(valid_568594, JString, required = true,
                                 default = nil)
  if valid_568594 != nil:
    section.add "api-version", valid_568594
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568595: Call_DatabaseAccountsListMongoDBDatabases_568588;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the MongoDB databases under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_568595.validator(path, query, header, formData, body)
  let scheme = call_568595.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568595.url(scheme.get, call_568595.host, call_568595.base,
                         call_568595.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568595, url, valid)

proc call*(call_568596: Call_DatabaseAccountsListMongoDBDatabases_568588;
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
  var path_568597 = newJObject()
  var query_568598 = newJObject()
  add(path_568597, "resourceGroupName", newJString(resourceGroupName))
  add(query_568598, "api-version", newJString(apiVersion))
  add(path_568597, "subscriptionId", newJString(subscriptionId))
  add(path_568597, "accountName", newJString(accountName))
  result = call_568596.call(path_568597, query_568598, nil, nil, nil)

var databaseAccountsListMongoDBDatabases* = Call_DatabaseAccountsListMongoDBDatabases_568588(
    name: "databaseAccountsListMongoDBDatabases", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases",
    validator: validate_DatabaseAccountsListMongoDBDatabases_568589, base: "",
    url: url_DatabaseAccountsListMongoDBDatabases_568590, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateMongoDBDatabase_568611 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsCreateUpdateMongoDBDatabase_568613(protocol: Scheme;
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

proc validate_DatabaseAccountsCreateUpdateMongoDBDatabase_568612(path: JsonNode;
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
  var valid_568614 = path.getOrDefault("resourceGroupName")
  valid_568614 = validateParameter(valid_568614, JString, required = true,
                                 default = nil)
  if valid_568614 != nil:
    section.add "resourceGroupName", valid_568614
  var valid_568615 = path.getOrDefault("subscriptionId")
  valid_568615 = validateParameter(valid_568615, JString, required = true,
                                 default = nil)
  if valid_568615 != nil:
    section.add "subscriptionId", valid_568615
  var valid_568616 = path.getOrDefault("databaseName")
  valid_568616 = validateParameter(valid_568616, JString, required = true,
                                 default = nil)
  if valid_568616 != nil:
    section.add "databaseName", valid_568616
  var valid_568617 = path.getOrDefault("accountName")
  valid_568617 = validateParameter(valid_568617, JString, required = true,
                                 default = nil)
  if valid_568617 != nil:
    section.add "accountName", valid_568617
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568618 = query.getOrDefault("api-version")
  valid_568618 = validateParameter(valid_568618, JString, required = true,
                                 default = nil)
  if valid_568618 != nil:
    section.add "api-version", valid_568618
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

proc call*(call_568620: Call_DatabaseAccountsCreateUpdateMongoDBDatabase_568611;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or updates Azure Cosmos DB MongoDB database
  ## 
  let valid = call_568620.validator(path, query, header, formData, body)
  let scheme = call_568620.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568620.url(scheme.get, call_568620.host, call_568620.base,
                         call_568620.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568620, url, valid)

proc call*(call_568621: Call_DatabaseAccountsCreateUpdateMongoDBDatabase_568611;
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
  var path_568622 = newJObject()
  var query_568623 = newJObject()
  var body_568624 = newJObject()
  add(path_568622, "resourceGroupName", newJString(resourceGroupName))
  add(query_568623, "api-version", newJString(apiVersion))
  add(path_568622, "subscriptionId", newJString(subscriptionId))
  add(path_568622, "databaseName", newJString(databaseName))
  if createUpdateMongoDBDatabaseParameters != nil:
    body_568624 = createUpdateMongoDBDatabaseParameters
  add(path_568622, "accountName", newJString(accountName))
  result = call_568621.call(path_568622, query_568623, nil, nil, body_568624)

var databaseAccountsCreateUpdateMongoDBDatabase* = Call_DatabaseAccountsCreateUpdateMongoDBDatabase_568611(
    name: "databaseAccountsCreateUpdateMongoDBDatabase", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}",
    validator: validate_DatabaseAccountsCreateUpdateMongoDBDatabase_568612,
    base: "", url: url_DatabaseAccountsCreateUpdateMongoDBDatabase_568613,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetMongoDBDatabase_568599 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsGetMongoDBDatabase_568601(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsGetMongoDBDatabase_568600(path: JsonNode;
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
  var valid_568602 = path.getOrDefault("resourceGroupName")
  valid_568602 = validateParameter(valid_568602, JString, required = true,
                                 default = nil)
  if valid_568602 != nil:
    section.add "resourceGroupName", valid_568602
  var valid_568603 = path.getOrDefault("subscriptionId")
  valid_568603 = validateParameter(valid_568603, JString, required = true,
                                 default = nil)
  if valid_568603 != nil:
    section.add "subscriptionId", valid_568603
  var valid_568604 = path.getOrDefault("databaseName")
  valid_568604 = validateParameter(valid_568604, JString, required = true,
                                 default = nil)
  if valid_568604 != nil:
    section.add "databaseName", valid_568604
  var valid_568605 = path.getOrDefault("accountName")
  valid_568605 = validateParameter(valid_568605, JString, required = true,
                                 default = nil)
  if valid_568605 != nil:
    section.add "accountName", valid_568605
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568606 = query.getOrDefault("api-version")
  valid_568606 = validateParameter(valid_568606, JString, required = true,
                                 default = nil)
  if valid_568606 != nil:
    section.add "api-version", valid_568606
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568607: Call_DatabaseAccountsGetMongoDBDatabase_568599;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the MongoDB databases under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_568607.validator(path, query, header, formData, body)
  let scheme = call_568607.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568607.url(scheme.get, call_568607.host, call_568607.base,
                         call_568607.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568607, url, valid)

proc call*(call_568608: Call_DatabaseAccountsGetMongoDBDatabase_568599;
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
  var path_568609 = newJObject()
  var query_568610 = newJObject()
  add(path_568609, "resourceGroupName", newJString(resourceGroupName))
  add(query_568610, "api-version", newJString(apiVersion))
  add(path_568609, "subscriptionId", newJString(subscriptionId))
  add(path_568609, "databaseName", newJString(databaseName))
  add(path_568609, "accountName", newJString(accountName))
  result = call_568608.call(path_568609, query_568610, nil, nil, nil)

var databaseAccountsGetMongoDBDatabase* = Call_DatabaseAccountsGetMongoDBDatabase_568599(
    name: "databaseAccountsGetMongoDBDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}",
    validator: validate_DatabaseAccountsGetMongoDBDatabase_568600, base: "",
    url: url_DatabaseAccountsGetMongoDBDatabase_568601, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteMongoDBDatabase_568625 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsDeleteMongoDBDatabase_568627(protocol: Scheme;
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

proc validate_DatabaseAccountsDeleteMongoDBDatabase_568626(path: JsonNode;
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
  var valid_568628 = path.getOrDefault("resourceGroupName")
  valid_568628 = validateParameter(valid_568628, JString, required = true,
                                 default = nil)
  if valid_568628 != nil:
    section.add "resourceGroupName", valid_568628
  var valid_568629 = path.getOrDefault("subscriptionId")
  valid_568629 = validateParameter(valid_568629, JString, required = true,
                                 default = nil)
  if valid_568629 != nil:
    section.add "subscriptionId", valid_568629
  var valid_568630 = path.getOrDefault("databaseName")
  valid_568630 = validateParameter(valid_568630, JString, required = true,
                                 default = nil)
  if valid_568630 != nil:
    section.add "databaseName", valid_568630
  var valid_568631 = path.getOrDefault("accountName")
  valid_568631 = validateParameter(valid_568631, JString, required = true,
                                 default = nil)
  if valid_568631 != nil:
    section.add "accountName", valid_568631
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568632 = query.getOrDefault("api-version")
  valid_568632 = validateParameter(valid_568632, JString, required = true,
                                 default = nil)
  if valid_568632 != nil:
    section.add "api-version", valid_568632
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568633: Call_DatabaseAccountsDeleteMongoDBDatabase_568625;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB MongoDB database.
  ## 
  let valid = call_568633.validator(path, query, header, formData, body)
  let scheme = call_568633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568633.url(scheme.get, call_568633.host, call_568633.base,
                         call_568633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568633, url, valid)

proc call*(call_568634: Call_DatabaseAccountsDeleteMongoDBDatabase_568625;
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
  var path_568635 = newJObject()
  var query_568636 = newJObject()
  add(path_568635, "resourceGroupName", newJString(resourceGroupName))
  add(query_568636, "api-version", newJString(apiVersion))
  add(path_568635, "subscriptionId", newJString(subscriptionId))
  add(path_568635, "databaseName", newJString(databaseName))
  add(path_568635, "accountName", newJString(accountName))
  result = call_568634.call(path_568635, query_568636, nil, nil, nil)

var databaseAccountsDeleteMongoDBDatabase* = Call_DatabaseAccountsDeleteMongoDBDatabase_568625(
    name: "databaseAccountsDeleteMongoDBDatabase", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}",
    validator: validate_DatabaseAccountsDeleteMongoDBDatabase_568626, base: "",
    url: url_DatabaseAccountsDeleteMongoDBDatabase_568627, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListMongoDBCollections_568637 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsListMongoDBCollections_568639(protocol: Scheme;
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

proc validate_DatabaseAccountsListMongoDBCollections_568638(path: JsonNode;
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
  var valid_568640 = path.getOrDefault("resourceGroupName")
  valid_568640 = validateParameter(valid_568640, JString, required = true,
                                 default = nil)
  if valid_568640 != nil:
    section.add "resourceGroupName", valid_568640
  var valid_568641 = path.getOrDefault("subscriptionId")
  valid_568641 = validateParameter(valid_568641, JString, required = true,
                                 default = nil)
  if valid_568641 != nil:
    section.add "subscriptionId", valid_568641
  var valid_568642 = path.getOrDefault("databaseName")
  valid_568642 = validateParameter(valid_568642, JString, required = true,
                                 default = nil)
  if valid_568642 != nil:
    section.add "databaseName", valid_568642
  var valid_568643 = path.getOrDefault("accountName")
  valid_568643 = validateParameter(valid_568643, JString, required = true,
                                 default = nil)
  if valid_568643 != nil:
    section.add "accountName", valid_568643
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568644 = query.getOrDefault("api-version")
  valid_568644 = validateParameter(valid_568644, JString, required = true,
                                 default = nil)
  if valid_568644 != nil:
    section.add "api-version", valid_568644
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568645: Call_DatabaseAccountsListMongoDBCollections_568637;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the MongoDB collection under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_568645.validator(path, query, header, formData, body)
  let scheme = call_568645.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568645.url(scheme.get, call_568645.host, call_568645.base,
                         call_568645.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568645, url, valid)

proc call*(call_568646: Call_DatabaseAccountsListMongoDBCollections_568637;
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
  var path_568647 = newJObject()
  var query_568648 = newJObject()
  add(path_568647, "resourceGroupName", newJString(resourceGroupName))
  add(query_568648, "api-version", newJString(apiVersion))
  add(path_568647, "subscriptionId", newJString(subscriptionId))
  add(path_568647, "databaseName", newJString(databaseName))
  add(path_568647, "accountName", newJString(accountName))
  result = call_568646.call(path_568647, query_568648, nil, nil, nil)

var databaseAccountsListMongoDBCollections* = Call_DatabaseAccountsListMongoDBCollections_568637(
    name: "databaseAccountsListMongoDBCollections", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/collections",
    validator: validate_DatabaseAccountsListMongoDBCollections_568638, base: "",
    url: url_DatabaseAccountsListMongoDBCollections_568639,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateMongoDBCollection_568662 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsCreateUpdateMongoDBCollection_568664(protocol: Scheme;
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

proc validate_DatabaseAccountsCreateUpdateMongoDBCollection_568663(
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
  var valid_568665 = path.getOrDefault("resourceGroupName")
  valid_568665 = validateParameter(valid_568665, JString, required = true,
                                 default = nil)
  if valid_568665 != nil:
    section.add "resourceGroupName", valid_568665
  var valid_568666 = path.getOrDefault("subscriptionId")
  valid_568666 = validateParameter(valid_568666, JString, required = true,
                                 default = nil)
  if valid_568666 != nil:
    section.add "subscriptionId", valid_568666
  var valid_568667 = path.getOrDefault("databaseName")
  valid_568667 = validateParameter(valid_568667, JString, required = true,
                                 default = nil)
  if valid_568667 != nil:
    section.add "databaseName", valid_568667
  var valid_568668 = path.getOrDefault("collectionName")
  valid_568668 = validateParameter(valid_568668, JString, required = true,
                                 default = nil)
  if valid_568668 != nil:
    section.add "collectionName", valid_568668
  var valid_568669 = path.getOrDefault("accountName")
  valid_568669 = validateParameter(valid_568669, JString, required = true,
                                 default = nil)
  if valid_568669 != nil:
    section.add "accountName", valid_568669
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568670 = query.getOrDefault("api-version")
  valid_568670 = validateParameter(valid_568670, JString, required = true,
                                 default = nil)
  if valid_568670 != nil:
    section.add "api-version", valid_568670
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

proc call*(call_568672: Call_DatabaseAccountsCreateUpdateMongoDBCollection_568662;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB MongoDB Collection
  ## 
  let valid = call_568672.validator(path, query, header, formData, body)
  let scheme = call_568672.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568672.url(scheme.get, call_568672.host, call_568672.base,
                         call_568672.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568672, url, valid)

proc call*(call_568673: Call_DatabaseAccountsCreateUpdateMongoDBCollection_568662;
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
  var path_568674 = newJObject()
  var query_568675 = newJObject()
  var body_568676 = newJObject()
  add(path_568674, "resourceGroupName", newJString(resourceGroupName))
  if createUpdateMongoDBCollectionParameters != nil:
    body_568676 = createUpdateMongoDBCollectionParameters
  add(query_568675, "api-version", newJString(apiVersion))
  add(path_568674, "subscriptionId", newJString(subscriptionId))
  add(path_568674, "databaseName", newJString(databaseName))
  add(path_568674, "collectionName", newJString(collectionName))
  add(path_568674, "accountName", newJString(accountName))
  result = call_568673.call(path_568674, query_568675, nil, nil, body_568676)

var databaseAccountsCreateUpdateMongoDBCollection* = Call_DatabaseAccountsCreateUpdateMongoDBCollection_568662(
    name: "databaseAccountsCreateUpdateMongoDBCollection",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/collections/{collectionName}",
    validator: validate_DatabaseAccountsCreateUpdateMongoDBCollection_568663,
    base: "", url: url_DatabaseAccountsCreateUpdateMongoDBCollection_568664,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetMongoDBCollection_568649 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsGetMongoDBCollection_568651(protocol: Scheme;
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

proc validate_DatabaseAccountsGetMongoDBCollection_568650(path: JsonNode;
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
  var valid_568652 = path.getOrDefault("resourceGroupName")
  valid_568652 = validateParameter(valid_568652, JString, required = true,
                                 default = nil)
  if valid_568652 != nil:
    section.add "resourceGroupName", valid_568652
  var valid_568653 = path.getOrDefault("subscriptionId")
  valid_568653 = validateParameter(valid_568653, JString, required = true,
                                 default = nil)
  if valid_568653 != nil:
    section.add "subscriptionId", valid_568653
  var valid_568654 = path.getOrDefault("databaseName")
  valid_568654 = validateParameter(valid_568654, JString, required = true,
                                 default = nil)
  if valid_568654 != nil:
    section.add "databaseName", valid_568654
  var valid_568655 = path.getOrDefault("collectionName")
  valid_568655 = validateParameter(valid_568655, JString, required = true,
                                 default = nil)
  if valid_568655 != nil:
    section.add "collectionName", valid_568655
  var valid_568656 = path.getOrDefault("accountName")
  valid_568656 = validateParameter(valid_568656, JString, required = true,
                                 default = nil)
  if valid_568656 != nil:
    section.add "accountName", valid_568656
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568657 = query.getOrDefault("api-version")
  valid_568657 = validateParameter(valid_568657, JString, required = true,
                                 default = nil)
  if valid_568657 != nil:
    section.add "api-version", valid_568657
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568658: Call_DatabaseAccountsGetMongoDBCollection_568649;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the MongoDB collection under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_568658.validator(path, query, header, formData, body)
  let scheme = call_568658.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568658.url(scheme.get, call_568658.host, call_568658.base,
                         call_568658.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568658, url, valid)

proc call*(call_568659: Call_DatabaseAccountsGetMongoDBCollection_568649;
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
  var path_568660 = newJObject()
  var query_568661 = newJObject()
  add(path_568660, "resourceGroupName", newJString(resourceGroupName))
  add(query_568661, "api-version", newJString(apiVersion))
  add(path_568660, "subscriptionId", newJString(subscriptionId))
  add(path_568660, "databaseName", newJString(databaseName))
  add(path_568660, "collectionName", newJString(collectionName))
  add(path_568660, "accountName", newJString(accountName))
  result = call_568659.call(path_568660, query_568661, nil, nil, nil)

var databaseAccountsGetMongoDBCollection* = Call_DatabaseAccountsGetMongoDBCollection_568649(
    name: "databaseAccountsGetMongoDBCollection", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/collections/{collectionName}",
    validator: validate_DatabaseAccountsGetMongoDBCollection_568650, base: "",
    url: url_DatabaseAccountsGetMongoDBCollection_568651, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteMongoDBCollection_568677 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsDeleteMongoDBCollection_568679(protocol: Scheme;
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

proc validate_DatabaseAccountsDeleteMongoDBCollection_568678(path: JsonNode;
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
  var valid_568680 = path.getOrDefault("resourceGroupName")
  valid_568680 = validateParameter(valid_568680, JString, required = true,
                                 default = nil)
  if valid_568680 != nil:
    section.add "resourceGroupName", valid_568680
  var valid_568681 = path.getOrDefault("subscriptionId")
  valid_568681 = validateParameter(valid_568681, JString, required = true,
                                 default = nil)
  if valid_568681 != nil:
    section.add "subscriptionId", valid_568681
  var valid_568682 = path.getOrDefault("databaseName")
  valid_568682 = validateParameter(valid_568682, JString, required = true,
                                 default = nil)
  if valid_568682 != nil:
    section.add "databaseName", valid_568682
  var valid_568683 = path.getOrDefault("collectionName")
  valid_568683 = validateParameter(valid_568683, JString, required = true,
                                 default = nil)
  if valid_568683 != nil:
    section.add "collectionName", valid_568683
  var valid_568684 = path.getOrDefault("accountName")
  valid_568684 = validateParameter(valid_568684, JString, required = true,
                                 default = nil)
  if valid_568684 != nil:
    section.add "accountName", valid_568684
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568685 = query.getOrDefault("api-version")
  valid_568685 = validateParameter(valid_568685, JString, required = true,
                                 default = nil)
  if valid_568685 != nil:
    section.add "api-version", valid_568685
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568686: Call_DatabaseAccountsDeleteMongoDBCollection_568677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB MongoDB Collection.
  ## 
  let valid = call_568686.validator(path, query, header, formData, body)
  let scheme = call_568686.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568686.url(scheme.get, call_568686.host, call_568686.base,
                         call_568686.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568686, url, valid)

proc call*(call_568687: Call_DatabaseAccountsDeleteMongoDBCollection_568677;
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
  var path_568688 = newJObject()
  var query_568689 = newJObject()
  add(path_568688, "resourceGroupName", newJString(resourceGroupName))
  add(query_568689, "api-version", newJString(apiVersion))
  add(path_568688, "subscriptionId", newJString(subscriptionId))
  add(path_568688, "databaseName", newJString(databaseName))
  add(path_568688, "collectionName", newJString(collectionName))
  add(path_568688, "accountName", newJString(accountName))
  result = call_568687.call(path_568688, query_568689, nil, nil, nil)

var databaseAccountsDeleteMongoDBCollection* = Call_DatabaseAccountsDeleteMongoDBCollection_568677(
    name: "databaseAccountsDeleteMongoDBCollection", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/collections/{collectionName}",
    validator: validate_DatabaseAccountsDeleteMongoDBCollection_568678, base: "",
    url: url_DatabaseAccountsDeleteMongoDBCollection_568679,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateMongoDBCollectionThroughput_568703 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsUpdateMongoDBCollectionThroughput_568705(
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

proc validate_DatabaseAccountsUpdateMongoDBCollectionThroughput_568704(
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
  var valid_568706 = path.getOrDefault("resourceGroupName")
  valid_568706 = validateParameter(valid_568706, JString, required = true,
                                 default = nil)
  if valid_568706 != nil:
    section.add "resourceGroupName", valid_568706
  var valid_568707 = path.getOrDefault("subscriptionId")
  valid_568707 = validateParameter(valid_568707, JString, required = true,
                                 default = nil)
  if valid_568707 != nil:
    section.add "subscriptionId", valid_568707
  var valid_568708 = path.getOrDefault("databaseName")
  valid_568708 = validateParameter(valid_568708, JString, required = true,
                                 default = nil)
  if valid_568708 != nil:
    section.add "databaseName", valid_568708
  var valid_568709 = path.getOrDefault("collectionName")
  valid_568709 = validateParameter(valid_568709, JString, required = true,
                                 default = nil)
  if valid_568709 != nil:
    section.add "collectionName", valid_568709
  var valid_568710 = path.getOrDefault("accountName")
  valid_568710 = validateParameter(valid_568710, JString, required = true,
                                 default = nil)
  if valid_568710 != nil:
    section.add "accountName", valid_568710
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568711 = query.getOrDefault("api-version")
  valid_568711 = validateParameter(valid_568711, JString, required = true,
                                 default = nil)
  if valid_568711 != nil:
    section.add "api-version", valid_568711
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

proc call*(call_568713: Call_DatabaseAccountsUpdateMongoDBCollectionThroughput_568703;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the RUs per second of an Azure Cosmos DB MongoDB collection
  ## 
  let valid = call_568713.validator(path, query, header, formData, body)
  let scheme = call_568713.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568713.url(scheme.get, call_568713.host, call_568713.base,
                         call_568713.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568713, url, valid)

proc call*(call_568714: Call_DatabaseAccountsUpdateMongoDBCollectionThroughput_568703;
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
  var path_568715 = newJObject()
  var query_568716 = newJObject()
  var body_568717 = newJObject()
  add(path_568715, "resourceGroupName", newJString(resourceGroupName))
  add(query_568716, "api-version", newJString(apiVersion))
  add(path_568715, "subscriptionId", newJString(subscriptionId))
  add(path_568715, "databaseName", newJString(databaseName))
  if updateThroughputParameters != nil:
    body_568717 = updateThroughputParameters
  add(path_568715, "collectionName", newJString(collectionName))
  add(path_568715, "accountName", newJString(accountName))
  result = call_568714.call(path_568715, query_568716, nil, nil, body_568717)

var databaseAccountsUpdateMongoDBCollectionThroughput* = Call_DatabaseAccountsUpdateMongoDBCollectionThroughput_568703(
    name: "databaseAccountsUpdateMongoDBCollectionThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/collections/{collectionName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateMongoDBCollectionThroughput_568704,
    base: "", url: url_DatabaseAccountsUpdateMongoDBCollectionThroughput_568705,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetMongoDBCollectionThroughput_568690 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsGetMongoDBCollectionThroughput_568692(protocol: Scheme;
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

proc validate_DatabaseAccountsGetMongoDBCollectionThroughput_568691(
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
  var valid_568693 = path.getOrDefault("resourceGroupName")
  valid_568693 = validateParameter(valid_568693, JString, required = true,
                                 default = nil)
  if valid_568693 != nil:
    section.add "resourceGroupName", valid_568693
  var valid_568694 = path.getOrDefault("subscriptionId")
  valid_568694 = validateParameter(valid_568694, JString, required = true,
                                 default = nil)
  if valid_568694 != nil:
    section.add "subscriptionId", valid_568694
  var valid_568695 = path.getOrDefault("databaseName")
  valid_568695 = validateParameter(valid_568695, JString, required = true,
                                 default = nil)
  if valid_568695 != nil:
    section.add "databaseName", valid_568695
  var valid_568696 = path.getOrDefault("collectionName")
  valid_568696 = validateParameter(valid_568696, JString, required = true,
                                 default = nil)
  if valid_568696 != nil:
    section.add "collectionName", valid_568696
  var valid_568697 = path.getOrDefault("accountName")
  valid_568697 = validateParameter(valid_568697, JString, required = true,
                                 default = nil)
  if valid_568697 != nil:
    section.add "accountName", valid_568697
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568698 = query.getOrDefault("api-version")
  valid_568698 = validateParameter(valid_568698, JString, required = true,
                                 default = nil)
  if valid_568698 != nil:
    section.add "api-version", valid_568698
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568699: Call_DatabaseAccountsGetMongoDBCollectionThroughput_568690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the MongoDB collection under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_568699.validator(path, query, header, formData, body)
  let scheme = call_568699.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568699.url(scheme.get, call_568699.host, call_568699.base,
                         call_568699.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568699, url, valid)

proc call*(call_568700: Call_DatabaseAccountsGetMongoDBCollectionThroughput_568690;
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
  var path_568701 = newJObject()
  var query_568702 = newJObject()
  add(path_568701, "resourceGroupName", newJString(resourceGroupName))
  add(query_568702, "api-version", newJString(apiVersion))
  add(path_568701, "subscriptionId", newJString(subscriptionId))
  add(path_568701, "databaseName", newJString(databaseName))
  add(path_568701, "collectionName", newJString(collectionName))
  add(path_568701, "accountName", newJString(accountName))
  result = call_568700.call(path_568701, query_568702, nil, nil, nil)

var databaseAccountsGetMongoDBCollectionThroughput* = Call_DatabaseAccountsGetMongoDBCollectionThroughput_568690(
    name: "databaseAccountsGetMongoDBCollectionThroughput",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/collections/{collectionName}/settings/throughput",
    validator: validate_DatabaseAccountsGetMongoDBCollectionThroughput_568691,
    base: "", url: url_DatabaseAccountsGetMongoDBCollectionThroughput_568692,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateMongoDBDatabaseThroughput_568730 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsUpdateMongoDBDatabaseThroughput_568732(protocol: Scheme;
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

proc validate_DatabaseAccountsUpdateMongoDBDatabaseThroughput_568731(
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
  var valid_568733 = path.getOrDefault("resourceGroupName")
  valid_568733 = validateParameter(valid_568733, JString, required = true,
                                 default = nil)
  if valid_568733 != nil:
    section.add "resourceGroupName", valid_568733
  var valid_568734 = path.getOrDefault("subscriptionId")
  valid_568734 = validateParameter(valid_568734, JString, required = true,
                                 default = nil)
  if valid_568734 != nil:
    section.add "subscriptionId", valid_568734
  var valid_568735 = path.getOrDefault("databaseName")
  valid_568735 = validateParameter(valid_568735, JString, required = true,
                                 default = nil)
  if valid_568735 != nil:
    section.add "databaseName", valid_568735
  var valid_568736 = path.getOrDefault("accountName")
  valid_568736 = validateParameter(valid_568736, JString, required = true,
                                 default = nil)
  if valid_568736 != nil:
    section.add "accountName", valid_568736
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568737 = query.getOrDefault("api-version")
  valid_568737 = validateParameter(valid_568737, JString, required = true,
                                 default = nil)
  if valid_568737 != nil:
    section.add "api-version", valid_568737
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

proc call*(call_568739: Call_DatabaseAccountsUpdateMongoDBDatabaseThroughput_568730;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of the an Azure Cosmos DB MongoDB database
  ## 
  let valid = call_568739.validator(path, query, header, formData, body)
  let scheme = call_568739.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568739.url(scheme.get, call_568739.host, call_568739.base,
                         call_568739.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568739, url, valid)

proc call*(call_568740: Call_DatabaseAccountsUpdateMongoDBDatabaseThroughput_568730;
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
  var path_568741 = newJObject()
  var query_568742 = newJObject()
  var body_568743 = newJObject()
  add(path_568741, "resourceGroupName", newJString(resourceGroupName))
  add(query_568742, "api-version", newJString(apiVersion))
  add(path_568741, "subscriptionId", newJString(subscriptionId))
  add(path_568741, "databaseName", newJString(databaseName))
  if updateThroughputParameters != nil:
    body_568743 = updateThroughputParameters
  add(path_568741, "accountName", newJString(accountName))
  result = call_568740.call(path_568741, query_568742, nil, nil, body_568743)

var databaseAccountsUpdateMongoDBDatabaseThroughput* = Call_DatabaseAccountsUpdateMongoDBDatabaseThroughput_568730(
    name: "databaseAccountsUpdateMongoDBDatabaseThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateMongoDBDatabaseThroughput_568731,
    base: "", url: url_DatabaseAccountsUpdateMongoDBDatabaseThroughput_568732,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetMongoDBDatabaseThroughput_568718 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsGetMongoDBDatabaseThroughput_568720(protocol: Scheme;
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

proc validate_DatabaseAccountsGetMongoDBDatabaseThroughput_568719(path: JsonNode;
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
  var valid_568721 = path.getOrDefault("resourceGroupName")
  valid_568721 = validateParameter(valid_568721, JString, required = true,
                                 default = nil)
  if valid_568721 != nil:
    section.add "resourceGroupName", valid_568721
  var valid_568722 = path.getOrDefault("subscriptionId")
  valid_568722 = validateParameter(valid_568722, JString, required = true,
                                 default = nil)
  if valid_568722 != nil:
    section.add "subscriptionId", valid_568722
  var valid_568723 = path.getOrDefault("databaseName")
  valid_568723 = validateParameter(valid_568723, JString, required = true,
                                 default = nil)
  if valid_568723 != nil:
    section.add "databaseName", valid_568723
  var valid_568724 = path.getOrDefault("accountName")
  valid_568724 = validateParameter(valid_568724, JString, required = true,
                                 default = nil)
  if valid_568724 != nil:
    section.add "accountName", valid_568724
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568725 = query.getOrDefault("api-version")
  valid_568725 = validateParameter(valid_568725, JString, required = true,
                                 default = nil)
  if valid_568725 != nil:
    section.add "api-version", valid_568725
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568726: Call_DatabaseAccountsGetMongoDBDatabaseThroughput_568718;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the MongoDB database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_568726.validator(path, query, header, formData, body)
  let scheme = call_568726.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568726.url(scheme.get, call_568726.host, call_568726.base,
                         call_568726.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568726, url, valid)

proc call*(call_568727: Call_DatabaseAccountsGetMongoDBDatabaseThroughput_568718;
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
  var path_568728 = newJObject()
  var query_568729 = newJObject()
  add(path_568728, "resourceGroupName", newJString(resourceGroupName))
  add(query_568729, "api-version", newJString(apiVersion))
  add(path_568728, "subscriptionId", newJString(subscriptionId))
  add(path_568728, "databaseName", newJString(databaseName))
  add(path_568728, "accountName", newJString(accountName))
  result = call_568727.call(path_568728, query_568729, nil, nil, nil)

var databaseAccountsGetMongoDBDatabaseThroughput* = Call_DatabaseAccountsGetMongoDBDatabaseThroughput_568718(
    name: "databaseAccountsGetMongoDBDatabaseThroughput",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/settings/throughput",
    validator: validate_DatabaseAccountsGetMongoDBDatabaseThroughput_568719,
    base: "", url: url_DatabaseAccountsGetMongoDBDatabaseThroughput_568720,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListSqlDatabases_568744 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsListSqlDatabases_568746(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListSqlDatabases_568745(path: JsonNode;
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
  var valid_568747 = path.getOrDefault("resourceGroupName")
  valid_568747 = validateParameter(valid_568747, JString, required = true,
                                 default = nil)
  if valid_568747 != nil:
    section.add "resourceGroupName", valid_568747
  var valid_568748 = path.getOrDefault("subscriptionId")
  valid_568748 = validateParameter(valid_568748, JString, required = true,
                                 default = nil)
  if valid_568748 != nil:
    section.add "subscriptionId", valid_568748
  var valid_568749 = path.getOrDefault("accountName")
  valid_568749 = validateParameter(valid_568749, JString, required = true,
                                 default = nil)
  if valid_568749 != nil:
    section.add "accountName", valid_568749
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568750 = query.getOrDefault("api-version")
  valid_568750 = validateParameter(valid_568750, JString, required = true,
                                 default = nil)
  if valid_568750 != nil:
    section.add "api-version", valid_568750
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568751: Call_DatabaseAccountsListSqlDatabases_568744;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the SQL databases under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_568751.validator(path, query, header, formData, body)
  let scheme = call_568751.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568751.url(scheme.get, call_568751.host, call_568751.base,
                         call_568751.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568751, url, valid)

proc call*(call_568752: Call_DatabaseAccountsListSqlDatabases_568744;
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
  var path_568753 = newJObject()
  var query_568754 = newJObject()
  add(path_568753, "resourceGroupName", newJString(resourceGroupName))
  add(query_568754, "api-version", newJString(apiVersion))
  add(path_568753, "subscriptionId", newJString(subscriptionId))
  add(path_568753, "accountName", newJString(accountName))
  result = call_568752.call(path_568753, query_568754, nil, nil, nil)

var databaseAccountsListSqlDatabases* = Call_DatabaseAccountsListSqlDatabases_568744(
    name: "databaseAccountsListSqlDatabases", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases",
    validator: validate_DatabaseAccountsListSqlDatabases_568745, base: "",
    url: url_DatabaseAccountsListSqlDatabases_568746, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateSqlDatabase_568767 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsCreateUpdateSqlDatabase_568769(protocol: Scheme;
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

proc validate_DatabaseAccountsCreateUpdateSqlDatabase_568768(path: JsonNode;
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
  var valid_568770 = path.getOrDefault("resourceGroupName")
  valid_568770 = validateParameter(valid_568770, JString, required = true,
                                 default = nil)
  if valid_568770 != nil:
    section.add "resourceGroupName", valid_568770
  var valid_568771 = path.getOrDefault("subscriptionId")
  valid_568771 = validateParameter(valid_568771, JString, required = true,
                                 default = nil)
  if valid_568771 != nil:
    section.add "subscriptionId", valid_568771
  var valid_568772 = path.getOrDefault("databaseName")
  valid_568772 = validateParameter(valid_568772, JString, required = true,
                                 default = nil)
  if valid_568772 != nil:
    section.add "databaseName", valid_568772
  var valid_568773 = path.getOrDefault("accountName")
  valid_568773 = validateParameter(valid_568773, JString, required = true,
                                 default = nil)
  if valid_568773 != nil:
    section.add "accountName", valid_568773
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568774 = query.getOrDefault("api-version")
  valid_568774 = validateParameter(valid_568774, JString, required = true,
                                 default = nil)
  if valid_568774 != nil:
    section.add "api-version", valid_568774
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

proc call*(call_568776: Call_DatabaseAccountsCreateUpdateSqlDatabase_568767;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB SQL database
  ## 
  let valid = call_568776.validator(path, query, header, formData, body)
  let scheme = call_568776.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568776.url(scheme.get, call_568776.host, call_568776.base,
                         call_568776.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568776, url, valid)

proc call*(call_568777: Call_DatabaseAccountsCreateUpdateSqlDatabase_568767;
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
  var path_568778 = newJObject()
  var query_568779 = newJObject()
  var body_568780 = newJObject()
  if createUpdateSqlDatabaseParameters != nil:
    body_568780 = createUpdateSqlDatabaseParameters
  add(path_568778, "resourceGroupName", newJString(resourceGroupName))
  add(query_568779, "api-version", newJString(apiVersion))
  add(path_568778, "subscriptionId", newJString(subscriptionId))
  add(path_568778, "databaseName", newJString(databaseName))
  add(path_568778, "accountName", newJString(accountName))
  result = call_568777.call(path_568778, query_568779, nil, nil, body_568780)

var databaseAccountsCreateUpdateSqlDatabase* = Call_DatabaseAccountsCreateUpdateSqlDatabase_568767(
    name: "databaseAccountsCreateUpdateSqlDatabase", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}",
    validator: validate_DatabaseAccountsCreateUpdateSqlDatabase_568768, base: "",
    url: url_DatabaseAccountsCreateUpdateSqlDatabase_568769,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetSqlDatabase_568755 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsGetSqlDatabase_568757(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsGetSqlDatabase_568756(path: JsonNode;
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
  var valid_568758 = path.getOrDefault("resourceGroupName")
  valid_568758 = validateParameter(valid_568758, JString, required = true,
                                 default = nil)
  if valid_568758 != nil:
    section.add "resourceGroupName", valid_568758
  var valid_568759 = path.getOrDefault("subscriptionId")
  valid_568759 = validateParameter(valid_568759, JString, required = true,
                                 default = nil)
  if valid_568759 != nil:
    section.add "subscriptionId", valid_568759
  var valid_568760 = path.getOrDefault("databaseName")
  valid_568760 = validateParameter(valid_568760, JString, required = true,
                                 default = nil)
  if valid_568760 != nil:
    section.add "databaseName", valid_568760
  var valid_568761 = path.getOrDefault("accountName")
  valid_568761 = validateParameter(valid_568761, JString, required = true,
                                 default = nil)
  if valid_568761 != nil:
    section.add "accountName", valid_568761
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568762 = query.getOrDefault("api-version")
  valid_568762 = validateParameter(valid_568762, JString, required = true,
                                 default = nil)
  if valid_568762 != nil:
    section.add "api-version", valid_568762
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568763: Call_DatabaseAccountsGetSqlDatabase_568755; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the SQL database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_568763.validator(path, query, header, formData, body)
  let scheme = call_568763.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568763.url(scheme.get, call_568763.host, call_568763.base,
                         call_568763.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568763, url, valid)

proc call*(call_568764: Call_DatabaseAccountsGetSqlDatabase_568755;
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
  var path_568765 = newJObject()
  var query_568766 = newJObject()
  add(path_568765, "resourceGroupName", newJString(resourceGroupName))
  add(query_568766, "api-version", newJString(apiVersion))
  add(path_568765, "subscriptionId", newJString(subscriptionId))
  add(path_568765, "databaseName", newJString(databaseName))
  add(path_568765, "accountName", newJString(accountName))
  result = call_568764.call(path_568765, query_568766, nil, nil, nil)

var databaseAccountsGetSqlDatabase* = Call_DatabaseAccountsGetSqlDatabase_568755(
    name: "databaseAccountsGetSqlDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}",
    validator: validate_DatabaseAccountsGetSqlDatabase_568756, base: "",
    url: url_DatabaseAccountsGetSqlDatabase_568757, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteSqlDatabase_568781 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsDeleteSqlDatabase_568783(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsDeleteSqlDatabase_568782(path: JsonNode;
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
  var valid_568784 = path.getOrDefault("resourceGroupName")
  valid_568784 = validateParameter(valid_568784, JString, required = true,
                                 default = nil)
  if valid_568784 != nil:
    section.add "resourceGroupName", valid_568784
  var valid_568785 = path.getOrDefault("subscriptionId")
  valid_568785 = validateParameter(valid_568785, JString, required = true,
                                 default = nil)
  if valid_568785 != nil:
    section.add "subscriptionId", valid_568785
  var valid_568786 = path.getOrDefault("databaseName")
  valid_568786 = validateParameter(valid_568786, JString, required = true,
                                 default = nil)
  if valid_568786 != nil:
    section.add "databaseName", valid_568786
  var valid_568787 = path.getOrDefault("accountName")
  valid_568787 = validateParameter(valid_568787, JString, required = true,
                                 default = nil)
  if valid_568787 != nil:
    section.add "accountName", valid_568787
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568788 = query.getOrDefault("api-version")
  valid_568788 = validateParameter(valid_568788, JString, required = true,
                                 default = nil)
  if valid_568788 != nil:
    section.add "api-version", valid_568788
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568789: Call_DatabaseAccountsDeleteSqlDatabase_568781;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB SQL database.
  ## 
  let valid = call_568789.validator(path, query, header, formData, body)
  let scheme = call_568789.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568789.url(scheme.get, call_568789.host, call_568789.base,
                         call_568789.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568789, url, valid)

proc call*(call_568790: Call_DatabaseAccountsDeleteSqlDatabase_568781;
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
  var path_568791 = newJObject()
  var query_568792 = newJObject()
  add(path_568791, "resourceGroupName", newJString(resourceGroupName))
  add(query_568792, "api-version", newJString(apiVersion))
  add(path_568791, "subscriptionId", newJString(subscriptionId))
  add(path_568791, "databaseName", newJString(databaseName))
  add(path_568791, "accountName", newJString(accountName))
  result = call_568790.call(path_568791, query_568792, nil, nil, nil)

var databaseAccountsDeleteSqlDatabase* = Call_DatabaseAccountsDeleteSqlDatabase_568781(
    name: "databaseAccountsDeleteSqlDatabase", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}",
    validator: validate_DatabaseAccountsDeleteSqlDatabase_568782, base: "",
    url: url_DatabaseAccountsDeleteSqlDatabase_568783, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListSqlContainers_568793 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsListSqlContainers_568795(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListSqlContainers_568794(path: JsonNode;
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
  var valid_568796 = path.getOrDefault("resourceGroupName")
  valid_568796 = validateParameter(valid_568796, JString, required = true,
                                 default = nil)
  if valid_568796 != nil:
    section.add "resourceGroupName", valid_568796
  var valid_568797 = path.getOrDefault("subscriptionId")
  valid_568797 = validateParameter(valid_568797, JString, required = true,
                                 default = nil)
  if valid_568797 != nil:
    section.add "subscriptionId", valid_568797
  var valid_568798 = path.getOrDefault("databaseName")
  valid_568798 = validateParameter(valid_568798, JString, required = true,
                                 default = nil)
  if valid_568798 != nil:
    section.add "databaseName", valid_568798
  var valid_568799 = path.getOrDefault("accountName")
  valid_568799 = validateParameter(valid_568799, JString, required = true,
                                 default = nil)
  if valid_568799 != nil:
    section.add "accountName", valid_568799
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568800 = query.getOrDefault("api-version")
  valid_568800 = validateParameter(valid_568800, JString, required = true,
                                 default = nil)
  if valid_568800 != nil:
    section.add "api-version", valid_568800
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568801: Call_DatabaseAccountsListSqlContainers_568793;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the SQL container under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_568801.validator(path, query, header, formData, body)
  let scheme = call_568801.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568801.url(scheme.get, call_568801.host, call_568801.base,
                         call_568801.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568801, url, valid)

proc call*(call_568802: Call_DatabaseAccountsListSqlContainers_568793;
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
  var path_568803 = newJObject()
  var query_568804 = newJObject()
  add(path_568803, "resourceGroupName", newJString(resourceGroupName))
  add(query_568804, "api-version", newJString(apiVersion))
  add(path_568803, "subscriptionId", newJString(subscriptionId))
  add(path_568803, "databaseName", newJString(databaseName))
  add(path_568803, "accountName", newJString(accountName))
  result = call_568802.call(path_568803, query_568804, nil, nil, nil)

var databaseAccountsListSqlContainers* = Call_DatabaseAccountsListSqlContainers_568793(
    name: "databaseAccountsListSqlContainers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/containers",
    validator: validate_DatabaseAccountsListSqlContainers_568794, base: "",
    url: url_DatabaseAccountsListSqlContainers_568795, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateSqlContainer_568818 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsCreateUpdateSqlContainer_568820(protocol: Scheme;
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

proc validate_DatabaseAccountsCreateUpdateSqlContainer_568819(path: JsonNode;
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
  var valid_568821 = path.getOrDefault("resourceGroupName")
  valid_568821 = validateParameter(valid_568821, JString, required = true,
                                 default = nil)
  if valid_568821 != nil:
    section.add "resourceGroupName", valid_568821
  var valid_568822 = path.getOrDefault("containerName")
  valid_568822 = validateParameter(valid_568822, JString, required = true,
                                 default = nil)
  if valid_568822 != nil:
    section.add "containerName", valid_568822
  var valid_568823 = path.getOrDefault("subscriptionId")
  valid_568823 = validateParameter(valid_568823, JString, required = true,
                                 default = nil)
  if valid_568823 != nil:
    section.add "subscriptionId", valid_568823
  var valid_568824 = path.getOrDefault("databaseName")
  valid_568824 = validateParameter(valid_568824, JString, required = true,
                                 default = nil)
  if valid_568824 != nil:
    section.add "databaseName", valid_568824
  var valid_568825 = path.getOrDefault("accountName")
  valid_568825 = validateParameter(valid_568825, JString, required = true,
                                 default = nil)
  if valid_568825 != nil:
    section.add "accountName", valid_568825
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568826 = query.getOrDefault("api-version")
  valid_568826 = validateParameter(valid_568826, JString, required = true,
                                 default = nil)
  if valid_568826 != nil:
    section.add "api-version", valid_568826
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

proc call*(call_568828: Call_DatabaseAccountsCreateUpdateSqlContainer_568818;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB SQL container
  ## 
  let valid = call_568828.validator(path, query, header, formData, body)
  let scheme = call_568828.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568828.url(scheme.get, call_568828.host, call_568828.base,
                         call_568828.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568828, url, valid)

proc call*(call_568829: Call_DatabaseAccountsCreateUpdateSqlContainer_568818;
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
  var path_568830 = newJObject()
  var query_568831 = newJObject()
  var body_568832 = newJObject()
  if createUpdateSqlContainerParameters != nil:
    body_568832 = createUpdateSqlContainerParameters
  add(path_568830, "resourceGroupName", newJString(resourceGroupName))
  add(query_568831, "api-version", newJString(apiVersion))
  add(path_568830, "containerName", newJString(containerName))
  add(path_568830, "subscriptionId", newJString(subscriptionId))
  add(path_568830, "databaseName", newJString(databaseName))
  add(path_568830, "accountName", newJString(accountName))
  result = call_568829.call(path_568830, query_568831, nil, nil, body_568832)

var databaseAccountsCreateUpdateSqlContainer* = Call_DatabaseAccountsCreateUpdateSqlContainer_568818(
    name: "databaseAccountsCreateUpdateSqlContainer", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/containers/{containerName}",
    validator: validate_DatabaseAccountsCreateUpdateSqlContainer_568819, base: "",
    url: url_DatabaseAccountsCreateUpdateSqlContainer_568820,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetSqlContainer_568805 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsGetSqlContainer_568807(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsGetSqlContainer_568806(path: JsonNode;
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
  var valid_568808 = path.getOrDefault("resourceGroupName")
  valid_568808 = validateParameter(valid_568808, JString, required = true,
                                 default = nil)
  if valid_568808 != nil:
    section.add "resourceGroupName", valid_568808
  var valid_568809 = path.getOrDefault("containerName")
  valid_568809 = validateParameter(valid_568809, JString, required = true,
                                 default = nil)
  if valid_568809 != nil:
    section.add "containerName", valid_568809
  var valid_568810 = path.getOrDefault("subscriptionId")
  valid_568810 = validateParameter(valid_568810, JString, required = true,
                                 default = nil)
  if valid_568810 != nil:
    section.add "subscriptionId", valid_568810
  var valid_568811 = path.getOrDefault("databaseName")
  valid_568811 = validateParameter(valid_568811, JString, required = true,
                                 default = nil)
  if valid_568811 != nil:
    section.add "databaseName", valid_568811
  var valid_568812 = path.getOrDefault("accountName")
  valid_568812 = validateParameter(valid_568812, JString, required = true,
                                 default = nil)
  if valid_568812 != nil:
    section.add "accountName", valid_568812
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568813 = query.getOrDefault("api-version")
  valid_568813 = validateParameter(valid_568813, JString, required = true,
                                 default = nil)
  if valid_568813 != nil:
    section.add "api-version", valid_568813
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568814: Call_DatabaseAccountsGetSqlContainer_568805;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the SQL container under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_568814.validator(path, query, header, formData, body)
  let scheme = call_568814.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568814.url(scheme.get, call_568814.host, call_568814.base,
                         call_568814.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568814, url, valid)

proc call*(call_568815: Call_DatabaseAccountsGetSqlContainer_568805;
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
  var path_568816 = newJObject()
  var query_568817 = newJObject()
  add(path_568816, "resourceGroupName", newJString(resourceGroupName))
  add(query_568817, "api-version", newJString(apiVersion))
  add(path_568816, "containerName", newJString(containerName))
  add(path_568816, "subscriptionId", newJString(subscriptionId))
  add(path_568816, "databaseName", newJString(databaseName))
  add(path_568816, "accountName", newJString(accountName))
  result = call_568815.call(path_568816, query_568817, nil, nil, nil)

var databaseAccountsGetSqlContainer* = Call_DatabaseAccountsGetSqlContainer_568805(
    name: "databaseAccountsGetSqlContainer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/containers/{containerName}",
    validator: validate_DatabaseAccountsGetSqlContainer_568806, base: "",
    url: url_DatabaseAccountsGetSqlContainer_568807, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteSqlContainer_568833 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsDeleteSqlContainer_568835(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsDeleteSqlContainer_568834(path: JsonNode;
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
  var valid_568836 = path.getOrDefault("resourceGroupName")
  valid_568836 = validateParameter(valid_568836, JString, required = true,
                                 default = nil)
  if valid_568836 != nil:
    section.add "resourceGroupName", valid_568836
  var valid_568837 = path.getOrDefault("containerName")
  valid_568837 = validateParameter(valid_568837, JString, required = true,
                                 default = nil)
  if valid_568837 != nil:
    section.add "containerName", valid_568837
  var valid_568838 = path.getOrDefault("subscriptionId")
  valid_568838 = validateParameter(valid_568838, JString, required = true,
                                 default = nil)
  if valid_568838 != nil:
    section.add "subscriptionId", valid_568838
  var valid_568839 = path.getOrDefault("databaseName")
  valid_568839 = validateParameter(valid_568839, JString, required = true,
                                 default = nil)
  if valid_568839 != nil:
    section.add "databaseName", valid_568839
  var valid_568840 = path.getOrDefault("accountName")
  valid_568840 = validateParameter(valid_568840, JString, required = true,
                                 default = nil)
  if valid_568840 != nil:
    section.add "accountName", valid_568840
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568841 = query.getOrDefault("api-version")
  valid_568841 = validateParameter(valid_568841, JString, required = true,
                                 default = nil)
  if valid_568841 != nil:
    section.add "api-version", valid_568841
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568842: Call_DatabaseAccountsDeleteSqlContainer_568833;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB SQL container.
  ## 
  let valid = call_568842.validator(path, query, header, formData, body)
  let scheme = call_568842.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568842.url(scheme.get, call_568842.host, call_568842.base,
                         call_568842.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568842, url, valid)

proc call*(call_568843: Call_DatabaseAccountsDeleteSqlContainer_568833;
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
  var path_568844 = newJObject()
  var query_568845 = newJObject()
  add(path_568844, "resourceGroupName", newJString(resourceGroupName))
  add(query_568845, "api-version", newJString(apiVersion))
  add(path_568844, "containerName", newJString(containerName))
  add(path_568844, "subscriptionId", newJString(subscriptionId))
  add(path_568844, "databaseName", newJString(databaseName))
  add(path_568844, "accountName", newJString(accountName))
  result = call_568843.call(path_568844, query_568845, nil, nil, nil)

var databaseAccountsDeleteSqlContainer* = Call_DatabaseAccountsDeleteSqlContainer_568833(
    name: "databaseAccountsDeleteSqlContainer", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/containers/{containerName}",
    validator: validate_DatabaseAccountsDeleteSqlContainer_568834, base: "",
    url: url_DatabaseAccountsDeleteSqlContainer_568835, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateSqlContainerThroughput_568859 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsUpdateSqlContainerThroughput_568861(protocol: Scheme;
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

proc validate_DatabaseAccountsUpdateSqlContainerThroughput_568860(path: JsonNode;
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
  var valid_568862 = path.getOrDefault("resourceGroupName")
  valid_568862 = validateParameter(valid_568862, JString, required = true,
                                 default = nil)
  if valid_568862 != nil:
    section.add "resourceGroupName", valid_568862
  var valid_568863 = path.getOrDefault("containerName")
  valid_568863 = validateParameter(valid_568863, JString, required = true,
                                 default = nil)
  if valid_568863 != nil:
    section.add "containerName", valid_568863
  var valid_568864 = path.getOrDefault("subscriptionId")
  valid_568864 = validateParameter(valid_568864, JString, required = true,
                                 default = nil)
  if valid_568864 != nil:
    section.add "subscriptionId", valid_568864
  var valid_568865 = path.getOrDefault("databaseName")
  valid_568865 = validateParameter(valid_568865, JString, required = true,
                                 default = nil)
  if valid_568865 != nil:
    section.add "databaseName", valid_568865
  var valid_568866 = path.getOrDefault("accountName")
  valid_568866 = validateParameter(valid_568866, JString, required = true,
                                 default = nil)
  if valid_568866 != nil:
    section.add "accountName", valid_568866
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568867 = query.getOrDefault("api-version")
  valid_568867 = validateParameter(valid_568867, JString, required = true,
                                 default = nil)
  if valid_568867 != nil:
    section.add "api-version", valid_568867
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

proc call*(call_568869: Call_DatabaseAccountsUpdateSqlContainerThroughput_568859;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB SQL container
  ## 
  let valid = call_568869.validator(path, query, header, formData, body)
  let scheme = call_568869.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568869.url(scheme.get, call_568869.host, call_568869.base,
                         call_568869.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568869, url, valid)

proc call*(call_568870: Call_DatabaseAccountsUpdateSqlContainerThroughput_568859;
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
  var path_568871 = newJObject()
  var query_568872 = newJObject()
  var body_568873 = newJObject()
  add(path_568871, "resourceGroupName", newJString(resourceGroupName))
  add(query_568872, "api-version", newJString(apiVersion))
  add(path_568871, "containerName", newJString(containerName))
  add(path_568871, "subscriptionId", newJString(subscriptionId))
  add(path_568871, "databaseName", newJString(databaseName))
  if updateThroughputParameters != nil:
    body_568873 = updateThroughputParameters
  add(path_568871, "accountName", newJString(accountName))
  result = call_568870.call(path_568871, query_568872, nil, nil, body_568873)

var databaseAccountsUpdateSqlContainerThroughput* = Call_DatabaseAccountsUpdateSqlContainerThroughput_568859(
    name: "databaseAccountsUpdateSqlContainerThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/containers/{containerName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateSqlContainerThroughput_568860,
    base: "", url: url_DatabaseAccountsUpdateSqlContainerThroughput_568861,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetSqlContainerThroughput_568846 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsGetSqlContainerThroughput_568848(protocol: Scheme;
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

proc validate_DatabaseAccountsGetSqlContainerThroughput_568847(path: JsonNode;
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
  var valid_568849 = path.getOrDefault("resourceGroupName")
  valid_568849 = validateParameter(valid_568849, JString, required = true,
                                 default = nil)
  if valid_568849 != nil:
    section.add "resourceGroupName", valid_568849
  var valid_568850 = path.getOrDefault("containerName")
  valid_568850 = validateParameter(valid_568850, JString, required = true,
                                 default = nil)
  if valid_568850 != nil:
    section.add "containerName", valid_568850
  var valid_568851 = path.getOrDefault("subscriptionId")
  valid_568851 = validateParameter(valid_568851, JString, required = true,
                                 default = nil)
  if valid_568851 != nil:
    section.add "subscriptionId", valid_568851
  var valid_568852 = path.getOrDefault("databaseName")
  valid_568852 = validateParameter(valid_568852, JString, required = true,
                                 default = nil)
  if valid_568852 != nil:
    section.add "databaseName", valid_568852
  var valid_568853 = path.getOrDefault("accountName")
  valid_568853 = validateParameter(valid_568853, JString, required = true,
                                 default = nil)
  if valid_568853 != nil:
    section.add "accountName", valid_568853
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568854 = query.getOrDefault("api-version")
  valid_568854 = validateParameter(valid_568854, JString, required = true,
                                 default = nil)
  if valid_568854 != nil:
    section.add "api-version", valid_568854
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568855: Call_DatabaseAccountsGetSqlContainerThroughput_568846;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the SQL container under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_568855.validator(path, query, header, formData, body)
  let scheme = call_568855.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568855.url(scheme.get, call_568855.host, call_568855.base,
                         call_568855.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568855, url, valid)

proc call*(call_568856: Call_DatabaseAccountsGetSqlContainerThroughput_568846;
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
  var path_568857 = newJObject()
  var query_568858 = newJObject()
  add(path_568857, "resourceGroupName", newJString(resourceGroupName))
  add(query_568858, "api-version", newJString(apiVersion))
  add(path_568857, "containerName", newJString(containerName))
  add(path_568857, "subscriptionId", newJString(subscriptionId))
  add(path_568857, "databaseName", newJString(databaseName))
  add(path_568857, "accountName", newJString(accountName))
  result = call_568856.call(path_568857, query_568858, nil, nil, nil)

var databaseAccountsGetSqlContainerThroughput* = Call_DatabaseAccountsGetSqlContainerThroughput_568846(
    name: "databaseAccountsGetSqlContainerThroughput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/containers/{containerName}/settings/throughput",
    validator: validate_DatabaseAccountsGetSqlContainerThroughput_568847,
    base: "", url: url_DatabaseAccountsGetSqlContainerThroughput_568848,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateSqlDatabaseThroughput_568886 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsUpdateSqlDatabaseThroughput_568888(protocol: Scheme;
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

proc validate_DatabaseAccountsUpdateSqlDatabaseThroughput_568887(path: JsonNode;
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
  var valid_568889 = path.getOrDefault("resourceGroupName")
  valid_568889 = validateParameter(valid_568889, JString, required = true,
                                 default = nil)
  if valid_568889 != nil:
    section.add "resourceGroupName", valid_568889
  var valid_568890 = path.getOrDefault("subscriptionId")
  valid_568890 = validateParameter(valid_568890, JString, required = true,
                                 default = nil)
  if valid_568890 != nil:
    section.add "subscriptionId", valid_568890
  var valid_568891 = path.getOrDefault("databaseName")
  valid_568891 = validateParameter(valid_568891, JString, required = true,
                                 default = nil)
  if valid_568891 != nil:
    section.add "databaseName", valid_568891
  var valid_568892 = path.getOrDefault("accountName")
  valid_568892 = validateParameter(valid_568892, JString, required = true,
                                 default = nil)
  if valid_568892 != nil:
    section.add "accountName", valid_568892
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568893 = query.getOrDefault("api-version")
  valid_568893 = validateParameter(valid_568893, JString, required = true,
                                 default = nil)
  if valid_568893 != nil:
    section.add "api-version", valid_568893
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

proc call*(call_568895: Call_DatabaseAccountsUpdateSqlDatabaseThroughput_568886;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB SQL database
  ## 
  let valid = call_568895.validator(path, query, header, formData, body)
  let scheme = call_568895.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568895.url(scheme.get, call_568895.host, call_568895.base,
                         call_568895.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568895, url, valid)

proc call*(call_568896: Call_DatabaseAccountsUpdateSqlDatabaseThroughput_568886;
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
  var path_568897 = newJObject()
  var query_568898 = newJObject()
  var body_568899 = newJObject()
  add(path_568897, "resourceGroupName", newJString(resourceGroupName))
  add(query_568898, "api-version", newJString(apiVersion))
  add(path_568897, "subscriptionId", newJString(subscriptionId))
  add(path_568897, "databaseName", newJString(databaseName))
  if updateThroughputParameters != nil:
    body_568899 = updateThroughputParameters
  add(path_568897, "accountName", newJString(accountName))
  result = call_568896.call(path_568897, query_568898, nil, nil, body_568899)

var databaseAccountsUpdateSqlDatabaseThroughput* = Call_DatabaseAccountsUpdateSqlDatabaseThroughput_568886(
    name: "databaseAccountsUpdateSqlDatabaseThroughput", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateSqlDatabaseThroughput_568887,
    base: "", url: url_DatabaseAccountsUpdateSqlDatabaseThroughput_568888,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetSqlDatabaseThroughput_568874 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsGetSqlDatabaseThroughput_568876(protocol: Scheme;
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

proc validate_DatabaseAccountsGetSqlDatabaseThroughput_568875(path: JsonNode;
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
  var valid_568877 = path.getOrDefault("resourceGroupName")
  valid_568877 = validateParameter(valid_568877, JString, required = true,
                                 default = nil)
  if valid_568877 != nil:
    section.add "resourceGroupName", valid_568877
  var valid_568878 = path.getOrDefault("subscriptionId")
  valid_568878 = validateParameter(valid_568878, JString, required = true,
                                 default = nil)
  if valid_568878 != nil:
    section.add "subscriptionId", valid_568878
  var valid_568879 = path.getOrDefault("databaseName")
  valid_568879 = validateParameter(valid_568879, JString, required = true,
                                 default = nil)
  if valid_568879 != nil:
    section.add "databaseName", valid_568879
  var valid_568880 = path.getOrDefault("accountName")
  valid_568880 = validateParameter(valid_568880, JString, required = true,
                                 default = nil)
  if valid_568880 != nil:
    section.add "accountName", valid_568880
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568881 = query.getOrDefault("api-version")
  valid_568881 = validateParameter(valid_568881, JString, required = true,
                                 default = nil)
  if valid_568881 != nil:
    section.add "api-version", valid_568881
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568882: Call_DatabaseAccountsGetSqlDatabaseThroughput_568874;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the SQL database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_568882.validator(path, query, header, formData, body)
  let scheme = call_568882.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568882.url(scheme.get, call_568882.host, call_568882.base,
                         call_568882.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568882, url, valid)

proc call*(call_568883: Call_DatabaseAccountsGetSqlDatabaseThroughput_568874;
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
  var path_568884 = newJObject()
  var query_568885 = newJObject()
  add(path_568884, "resourceGroupName", newJString(resourceGroupName))
  add(query_568885, "api-version", newJString(apiVersion))
  add(path_568884, "subscriptionId", newJString(subscriptionId))
  add(path_568884, "databaseName", newJString(databaseName))
  add(path_568884, "accountName", newJString(accountName))
  result = call_568883.call(path_568884, query_568885, nil, nil, nil)

var databaseAccountsGetSqlDatabaseThroughput* = Call_DatabaseAccountsGetSqlDatabaseThroughput_568874(
    name: "databaseAccountsGetSqlDatabaseThroughput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/settings/throughput",
    validator: validate_DatabaseAccountsGetSqlDatabaseThroughput_568875, base: "",
    url: url_DatabaseAccountsGetSqlDatabaseThroughput_568876,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListTables_568900 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsListTables_568902(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListTables_568901(path: JsonNode; query: JsonNode;
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
  var valid_568903 = path.getOrDefault("resourceGroupName")
  valid_568903 = validateParameter(valid_568903, JString, required = true,
                                 default = nil)
  if valid_568903 != nil:
    section.add "resourceGroupName", valid_568903
  var valid_568904 = path.getOrDefault("subscriptionId")
  valid_568904 = validateParameter(valid_568904, JString, required = true,
                                 default = nil)
  if valid_568904 != nil:
    section.add "subscriptionId", valid_568904
  var valid_568905 = path.getOrDefault("accountName")
  valid_568905 = validateParameter(valid_568905, JString, required = true,
                                 default = nil)
  if valid_568905 != nil:
    section.add "accountName", valid_568905
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568906 = query.getOrDefault("api-version")
  valid_568906 = validateParameter(valid_568906, JString, required = true,
                                 default = nil)
  if valid_568906 != nil:
    section.add "api-version", valid_568906
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568907: Call_DatabaseAccountsListTables_568900; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Tables under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_568907.validator(path, query, header, formData, body)
  let scheme = call_568907.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568907.url(scheme.get, call_568907.host, call_568907.base,
                         call_568907.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568907, url, valid)

proc call*(call_568908: Call_DatabaseAccountsListTables_568900;
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
  var path_568909 = newJObject()
  var query_568910 = newJObject()
  add(path_568909, "resourceGroupName", newJString(resourceGroupName))
  add(query_568910, "api-version", newJString(apiVersion))
  add(path_568909, "subscriptionId", newJString(subscriptionId))
  add(path_568909, "accountName", newJString(accountName))
  result = call_568908.call(path_568909, query_568910, nil, nil, nil)

var databaseAccountsListTables* = Call_DatabaseAccountsListTables_568900(
    name: "databaseAccountsListTables", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/table/tables",
    validator: validate_DatabaseAccountsListTables_568901, base: "",
    url: url_DatabaseAccountsListTables_568902, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateTable_568923 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsCreateUpdateTable_568925(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsCreateUpdateTable_568924(path: JsonNode;
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
  var valid_568926 = path.getOrDefault("resourceGroupName")
  valid_568926 = validateParameter(valid_568926, JString, required = true,
                                 default = nil)
  if valid_568926 != nil:
    section.add "resourceGroupName", valid_568926
  var valid_568927 = path.getOrDefault("subscriptionId")
  valid_568927 = validateParameter(valid_568927, JString, required = true,
                                 default = nil)
  if valid_568927 != nil:
    section.add "subscriptionId", valid_568927
  var valid_568928 = path.getOrDefault("tableName")
  valid_568928 = validateParameter(valid_568928, JString, required = true,
                                 default = nil)
  if valid_568928 != nil:
    section.add "tableName", valid_568928
  var valid_568929 = path.getOrDefault("accountName")
  valid_568929 = validateParameter(valid_568929, JString, required = true,
                                 default = nil)
  if valid_568929 != nil:
    section.add "accountName", valid_568929
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568930 = query.getOrDefault("api-version")
  valid_568930 = validateParameter(valid_568930, JString, required = true,
                                 default = nil)
  if valid_568930 != nil:
    section.add "api-version", valid_568930
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

proc call*(call_568932: Call_DatabaseAccountsCreateUpdateTable_568923;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB Table
  ## 
  let valid = call_568932.validator(path, query, header, formData, body)
  let scheme = call_568932.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568932.url(scheme.get, call_568932.host, call_568932.base,
                         call_568932.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568932, url, valid)

proc call*(call_568933: Call_DatabaseAccountsCreateUpdateTable_568923;
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
  var path_568934 = newJObject()
  var query_568935 = newJObject()
  var body_568936 = newJObject()
  add(path_568934, "resourceGroupName", newJString(resourceGroupName))
  add(query_568935, "api-version", newJString(apiVersion))
  add(path_568934, "subscriptionId", newJString(subscriptionId))
  add(path_568934, "tableName", newJString(tableName))
  if createUpdateTableParameters != nil:
    body_568936 = createUpdateTableParameters
  add(path_568934, "accountName", newJString(accountName))
  result = call_568933.call(path_568934, query_568935, nil, nil, body_568936)

var databaseAccountsCreateUpdateTable* = Call_DatabaseAccountsCreateUpdateTable_568923(
    name: "databaseAccountsCreateUpdateTable", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/table/tables/{tableName}",
    validator: validate_DatabaseAccountsCreateUpdateTable_568924, base: "",
    url: url_DatabaseAccountsCreateUpdateTable_568925, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetTable_568911 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsGetTable_568913(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsGetTable_568912(path: JsonNode; query: JsonNode;
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
  var valid_568914 = path.getOrDefault("resourceGroupName")
  valid_568914 = validateParameter(valid_568914, JString, required = true,
                                 default = nil)
  if valid_568914 != nil:
    section.add "resourceGroupName", valid_568914
  var valid_568915 = path.getOrDefault("subscriptionId")
  valid_568915 = validateParameter(valid_568915, JString, required = true,
                                 default = nil)
  if valid_568915 != nil:
    section.add "subscriptionId", valid_568915
  var valid_568916 = path.getOrDefault("tableName")
  valid_568916 = validateParameter(valid_568916, JString, required = true,
                                 default = nil)
  if valid_568916 != nil:
    section.add "tableName", valid_568916
  var valid_568917 = path.getOrDefault("accountName")
  valid_568917 = validateParameter(valid_568917, JString, required = true,
                                 default = nil)
  if valid_568917 != nil:
    section.add "accountName", valid_568917
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568918 = query.getOrDefault("api-version")
  valid_568918 = validateParameter(valid_568918, JString, required = true,
                                 default = nil)
  if valid_568918 != nil:
    section.add "api-version", valid_568918
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568919: Call_DatabaseAccountsGetTable_568911; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Tables under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_568919.validator(path, query, header, formData, body)
  let scheme = call_568919.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568919.url(scheme.get, call_568919.host, call_568919.base,
                         call_568919.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568919, url, valid)

proc call*(call_568920: Call_DatabaseAccountsGetTable_568911;
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
  var path_568921 = newJObject()
  var query_568922 = newJObject()
  add(path_568921, "resourceGroupName", newJString(resourceGroupName))
  add(query_568922, "api-version", newJString(apiVersion))
  add(path_568921, "subscriptionId", newJString(subscriptionId))
  add(path_568921, "tableName", newJString(tableName))
  add(path_568921, "accountName", newJString(accountName))
  result = call_568920.call(path_568921, query_568922, nil, nil, nil)

var databaseAccountsGetTable* = Call_DatabaseAccountsGetTable_568911(
    name: "databaseAccountsGetTable", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/table/tables/{tableName}",
    validator: validate_DatabaseAccountsGetTable_568912, base: "",
    url: url_DatabaseAccountsGetTable_568913, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteTable_568937 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsDeleteTable_568939(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsDeleteTable_568938(path: JsonNode; query: JsonNode;
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
  var valid_568940 = path.getOrDefault("resourceGroupName")
  valid_568940 = validateParameter(valid_568940, JString, required = true,
                                 default = nil)
  if valid_568940 != nil:
    section.add "resourceGroupName", valid_568940
  var valid_568941 = path.getOrDefault("subscriptionId")
  valid_568941 = validateParameter(valid_568941, JString, required = true,
                                 default = nil)
  if valid_568941 != nil:
    section.add "subscriptionId", valid_568941
  var valid_568942 = path.getOrDefault("tableName")
  valid_568942 = validateParameter(valid_568942, JString, required = true,
                                 default = nil)
  if valid_568942 != nil:
    section.add "tableName", valid_568942
  var valid_568943 = path.getOrDefault("accountName")
  valid_568943 = validateParameter(valid_568943, JString, required = true,
                                 default = nil)
  if valid_568943 != nil:
    section.add "accountName", valid_568943
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568944 = query.getOrDefault("api-version")
  valid_568944 = validateParameter(valid_568944, JString, required = true,
                                 default = nil)
  if valid_568944 != nil:
    section.add "api-version", valid_568944
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568945: Call_DatabaseAccountsDeleteTable_568937; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB Table.
  ## 
  let valid = call_568945.validator(path, query, header, formData, body)
  let scheme = call_568945.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568945.url(scheme.get, call_568945.host, call_568945.base,
                         call_568945.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568945, url, valid)

proc call*(call_568946: Call_DatabaseAccountsDeleteTable_568937;
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
  var path_568947 = newJObject()
  var query_568948 = newJObject()
  add(path_568947, "resourceGroupName", newJString(resourceGroupName))
  add(query_568948, "api-version", newJString(apiVersion))
  add(path_568947, "subscriptionId", newJString(subscriptionId))
  add(path_568947, "tableName", newJString(tableName))
  add(path_568947, "accountName", newJString(accountName))
  result = call_568946.call(path_568947, query_568948, nil, nil, nil)

var databaseAccountsDeleteTable* = Call_DatabaseAccountsDeleteTable_568937(
    name: "databaseAccountsDeleteTable", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/table/tables/{tableName}",
    validator: validate_DatabaseAccountsDeleteTable_568938, base: "",
    url: url_DatabaseAccountsDeleteTable_568939, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateTableThroughput_568961 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsUpdateTableThroughput_568963(protocol: Scheme;
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

proc validate_DatabaseAccountsUpdateTableThroughput_568962(path: JsonNode;
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
  var valid_568964 = path.getOrDefault("resourceGroupName")
  valid_568964 = validateParameter(valid_568964, JString, required = true,
                                 default = nil)
  if valid_568964 != nil:
    section.add "resourceGroupName", valid_568964
  var valid_568965 = path.getOrDefault("subscriptionId")
  valid_568965 = validateParameter(valid_568965, JString, required = true,
                                 default = nil)
  if valid_568965 != nil:
    section.add "subscriptionId", valid_568965
  var valid_568966 = path.getOrDefault("tableName")
  valid_568966 = validateParameter(valid_568966, JString, required = true,
                                 default = nil)
  if valid_568966 != nil:
    section.add "tableName", valid_568966
  var valid_568967 = path.getOrDefault("accountName")
  valid_568967 = validateParameter(valid_568967, JString, required = true,
                                 default = nil)
  if valid_568967 != nil:
    section.add "accountName", valid_568967
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568968 = query.getOrDefault("api-version")
  valid_568968 = validateParameter(valid_568968, JString, required = true,
                                 default = nil)
  if valid_568968 != nil:
    section.add "api-version", valid_568968
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

proc call*(call_568970: Call_DatabaseAccountsUpdateTableThroughput_568961;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Table
  ## 
  let valid = call_568970.validator(path, query, header, formData, body)
  let scheme = call_568970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568970.url(scheme.get, call_568970.host, call_568970.base,
                         call_568970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568970, url, valid)

proc call*(call_568971: Call_DatabaseAccountsUpdateTableThroughput_568961;
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
  var path_568972 = newJObject()
  var query_568973 = newJObject()
  var body_568974 = newJObject()
  add(path_568972, "resourceGroupName", newJString(resourceGroupName))
  add(query_568973, "api-version", newJString(apiVersion))
  add(path_568972, "subscriptionId", newJString(subscriptionId))
  add(path_568972, "tableName", newJString(tableName))
  if updateThroughputParameters != nil:
    body_568974 = updateThroughputParameters
  add(path_568972, "accountName", newJString(accountName))
  result = call_568971.call(path_568972, query_568973, nil, nil, body_568974)

var databaseAccountsUpdateTableThroughput* = Call_DatabaseAccountsUpdateTableThroughput_568961(
    name: "databaseAccountsUpdateTableThroughput", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/table/tables/{tableName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateTableThroughput_568962, base: "",
    url: url_DatabaseAccountsUpdateTableThroughput_568963, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetTableThroughput_568949 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsGetTableThroughput_568951(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsGetTableThroughput_568950(path: JsonNode;
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
  var valid_568952 = path.getOrDefault("resourceGroupName")
  valid_568952 = validateParameter(valid_568952, JString, required = true,
                                 default = nil)
  if valid_568952 != nil:
    section.add "resourceGroupName", valid_568952
  var valid_568953 = path.getOrDefault("subscriptionId")
  valid_568953 = validateParameter(valid_568953, JString, required = true,
                                 default = nil)
  if valid_568953 != nil:
    section.add "subscriptionId", valid_568953
  var valid_568954 = path.getOrDefault("tableName")
  valid_568954 = validateParameter(valid_568954, JString, required = true,
                                 default = nil)
  if valid_568954 != nil:
    section.add "tableName", valid_568954
  var valid_568955 = path.getOrDefault("accountName")
  valid_568955 = validateParameter(valid_568955, JString, required = true,
                                 default = nil)
  if valid_568955 != nil:
    section.add "accountName", valid_568955
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568956 = query.getOrDefault("api-version")
  valid_568956 = validateParameter(valid_568956, JString, required = true,
                                 default = nil)
  if valid_568956 != nil:
    section.add "api-version", valid_568956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568957: Call_DatabaseAccountsGetTableThroughput_568949;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the Table under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_568957.validator(path, query, header, formData, body)
  let scheme = call_568957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568957.url(scheme.get, call_568957.host, call_568957.base,
                         call_568957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568957, url, valid)

proc call*(call_568958: Call_DatabaseAccountsGetTableThroughput_568949;
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
  var path_568959 = newJObject()
  var query_568960 = newJObject()
  add(path_568959, "resourceGroupName", newJString(resourceGroupName))
  add(query_568960, "api-version", newJString(apiVersion))
  add(path_568959, "subscriptionId", newJString(subscriptionId))
  add(path_568959, "tableName", newJString(tableName))
  add(path_568959, "accountName", newJString(accountName))
  result = call_568958.call(path_568959, query_568960, nil, nil, nil)

var databaseAccountsGetTableThroughput* = Call_DatabaseAccountsGetTableThroughput_568949(
    name: "databaseAccountsGetTableThroughput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/table/tables/{tableName}/settings/throughput",
    validator: validate_DatabaseAccountsGetTableThroughput_568950, base: "",
    url: url_DatabaseAccountsGetTableThroughput_568951, schemes: {Scheme.Https})
type
  Call_CollectionListMetricDefinitions_568975 = ref object of OpenApiRestCall_567668
proc url_CollectionListMetricDefinitions_568977(protocol: Scheme; host: string;
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

proc validate_CollectionListMetricDefinitions_568976(path: JsonNode;
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
  var valid_568978 = path.getOrDefault("resourceGroupName")
  valid_568978 = validateParameter(valid_568978, JString, required = true,
                                 default = nil)
  if valid_568978 != nil:
    section.add "resourceGroupName", valid_568978
  var valid_568979 = path.getOrDefault("collectionRid")
  valid_568979 = validateParameter(valid_568979, JString, required = true,
                                 default = nil)
  if valid_568979 != nil:
    section.add "collectionRid", valid_568979
  var valid_568980 = path.getOrDefault("subscriptionId")
  valid_568980 = validateParameter(valid_568980, JString, required = true,
                                 default = nil)
  if valid_568980 != nil:
    section.add "subscriptionId", valid_568980
  var valid_568981 = path.getOrDefault("databaseRid")
  valid_568981 = validateParameter(valid_568981, JString, required = true,
                                 default = nil)
  if valid_568981 != nil:
    section.add "databaseRid", valid_568981
  var valid_568982 = path.getOrDefault("accountName")
  valid_568982 = validateParameter(valid_568982, JString, required = true,
                                 default = nil)
  if valid_568982 != nil:
    section.add "accountName", valid_568982
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568983 = query.getOrDefault("api-version")
  valid_568983 = validateParameter(valid_568983, JString, required = true,
                                 default = nil)
  if valid_568983 != nil:
    section.add "api-version", valid_568983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568984: Call_CollectionListMetricDefinitions_568975;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves metric definitions for the given collection.
  ## 
  let valid = call_568984.validator(path, query, header, formData, body)
  let scheme = call_568984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568984.url(scheme.get, call_568984.host, call_568984.base,
                         call_568984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568984, url, valid)

proc call*(call_568985: Call_CollectionListMetricDefinitions_568975;
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
  var path_568986 = newJObject()
  var query_568987 = newJObject()
  add(path_568986, "resourceGroupName", newJString(resourceGroupName))
  add(query_568987, "api-version", newJString(apiVersion))
  add(path_568986, "collectionRid", newJString(collectionRid))
  add(path_568986, "subscriptionId", newJString(subscriptionId))
  add(path_568986, "databaseRid", newJString(databaseRid))
  add(path_568986, "accountName", newJString(accountName))
  result = call_568985.call(path_568986, query_568987, nil, nil, nil)

var collectionListMetricDefinitions* = Call_CollectionListMetricDefinitions_568975(
    name: "collectionListMetricDefinitions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/metricDefinitions",
    validator: validate_CollectionListMetricDefinitions_568976, base: "",
    url: url_CollectionListMetricDefinitions_568977, schemes: {Scheme.Https})
type
  Call_CollectionListMetrics_568988 = ref object of OpenApiRestCall_567668
proc url_CollectionListMetrics_568990(protocol: Scheme; host: string; base: string;
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

proc validate_CollectionListMetrics_568989(path: JsonNode; query: JsonNode;
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
  var valid_568992 = path.getOrDefault("resourceGroupName")
  valid_568992 = validateParameter(valid_568992, JString, required = true,
                                 default = nil)
  if valid_568992 != nil:
    section.add "resourceGroupName", valid_568992
  var valid_568993 = path.getOrDefault("collectionRid")
  valid_568993 = validateParameter(valid_568993, JString, required = true,
                                 default = nil)
  if valid_568993 != nil:
    section.add "collectionRid", valid_568993
  var valid_568994 = path.getOrDefault("subscriptionId")
  valid_568994 = validateParameter(valid_568994, JString, required = true,
                                 default = nil)
  if valid_568994 != nil:
    section.add "subscriptionId", valid_568994
  var valid_568995 = path.getOrDefault("databaseRid")
  valid_568995 = validateParameter(valid_568995, JString, required = true,
                                 default = nil)
  if valid_568995 != nil:
    section.add "databaseRid", valid_568995
  var valid_568996 = path.getOrDefault("accountName")
  valid_568996 = validateParameter(valid_568996, JString, required = true,
                                 default = nil)
  if valid_568996 != nil:
    section.add "accountName", valid_568996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568997 = query.getOrDefault("api-version")
  valid_568997 = validateParameter(valid_568997, JString, required = true,
                                 default = nil)
  if valid_568997 != nil:
    section.add "api-version", valid_568997
  var valid_568998 = query.getOrDefault("$filter")
  valid_568998 = validateParameter(valid_568998, JString, required = true,
                                 default = nil)
  if valid_568998 != nil:
    section.add "$filter", valid_568998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568999: Call_CollectionListMetrics_568988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account and collection.
  ## 
  let valid = call_568999.validator(path, query, header, formData, body)
  let scheme = call_568999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568999.url(scheme.get, call_568999.host, call_568999.base,
                         call_568999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568999, url, valid)

proc call*(call_569000: Call_CollectionListMetrics_568988;
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
  var path_569001 = newJObject()
  var query_569002 = newJObject()
  add(path_569001, "resourceGroupName", newJString(resourceGroupName))
  add(query_569002, "api-version", newJString(apiVersion))
  add(path_569001, "collectionRid", newJString(collectionRid))
  add(path_569001, "subscriptionId", newJString(subscriptionId))
  add(path_569001, "databaseRid", newJString(databaseRid))
  add(path_569001, "accountName", newJString(accountName))
  add(query_569002, "$filter", newJString(Filter))
  result = call_569000.call(path_569001, query_569002, nil, nil, nil)

var collectionListMetrics* = Call_CollectionListMetrics_568988(
    name: "collectionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/metrics",
    validator: validate_CollectionListMetrics_568989, base: "",
    url: url_CollectionListMetrics_568990, schemes: {Scheme.Https})
type
  Call_PartitionKeyRangeIdListMetrics_569003 = ref object of OpenApiRestCall_567668
proc url_PartitionKeyRangeIdListMetrics_569005(protocol: Scheme; host: string;
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

proc validate_PartitionKeyRangeIdListMetrics_569004(path: JsonNode;
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
  var valid_569006 = path.getOrDefault("resourceGroupName")
  valid_569006 = validateParameter(valid_569006, JString, required = true,
                                 default = nil)
  if valid_569006 != nil:
    section.add "resourceGroupName", valid_569006
  var valid_569007 = path.getOrDefault("collectionRid")
  valid_569007 = validateParameter(valid_569007, JString, required = true,
                                 default = nil)
  if valid_569007 != nil:
    section.add "collectionRid", valid_569007
  var valid_569008 = path.getOrDefault("subscriptionId")
  valid_569008 = validateParameter(valid_569008, JString, required = true,
                                 default = nil)
  if valid_569008 != nil:
    section.add "subscriptionId", valid_569008
  var valid_569009 = path.getOrDefault("partitionKeyRangeId")
  valid_569009 = validateParameter(valid_569009, JString, required = true,
                                 default = nil)
  if valid_569009 != nil:
    section.add "partitionKeyRangeId", valid_569009
  var valid_569010 = path.getOrDefault("databaseRid")
  valid_569010 = validateParameter(valid_569010, JString, required = true,
                                 default = nil)
  if valid_569010 != nil:
    section.add "databaseRid", valid_569010
  var valid_569011 = path.getOrDefault("accountName")
  valid_569011 = validateParameter(valid_569011, JString, required = true,
                                 default = nil)
  if valid_569011 != nil:
    section.add "accountName", valid_569011
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569012 = query.getOrDefault("api-version")
  valid_569012 = validateParameter(valid_569012, JString, required = true,
                                 default = nil)
  if valid_569012 != nil:
    section.add "api-version", valid_569012
  var valid_569013 = query.getOrDefault("$filter")
  valid_569013 = validateParameter(valid_569013, JString, required = true,
                                 default = nil)
  if valid_569013 != nil:
    section.add "$filter", valid_569013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569014: Call_PartitionKeyRangeIdListMetrics_569003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given partition key range id.
  ## 
  let valid = call_569014.validator(path, query, header, formData, body)
  let scheme = call_569014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569014.url(scheme.get, call_569014.host, call_569014.base,
                         call_569014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569014, url, valid)

proc call*(call_569015: Call_PartitionKeyRangeIdListMetrics_569003;
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
  var path_569016 = newJObject()
  var query_569017 = newJObject()
  add(path_569016, "resourceGroupName", newJString(resourceGroupName))
  add(query_569017, "api-version", newJString(apiVersion))
  add(path_569016, "collectionRid", newJString(collectionRid))
  add(path_569016, "subscriptionId", newJString(subscriptionId))
  add(path_569016, "partitionKeyRangeId", newJString(partitionKeyRangeId))
  add(path_569016, "databaseRid", newJString(databaseRid))
  add(path_569016, "accountName", newJString(accountName))
  add(query_569017, "$filter", newJString(Filter))
  result = call_569015.call(path_569016, query_569017, nil, nil, nil)

var partitionKeyRangeIdListMetrics* = Call_PartitionKeyRangeIdListMetrics_569003(
    name: "partitionKeyRangeIdListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/partitionKeyRangeId/{partitionKeyRangeId}/metrics",
    validator: validate_PartitionKeyRangeIdListMetrics_569004, base: "",
    url: url_PartitionKeyRangeIdListMetrics_569005, schemes: {Scheme.Https})
type
  Call_CollectionPartitionListMetrics_569018 = ref object of OpenApiRestCall_567668
proc url_CollectionPartitionListMetrics_569020(protocol: Scheme; host: string;
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

proc validate_CollectionPartitionListMetrics_569019(path: JsonNode;
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
  var valid_569021 = path.getOrDefault("resourceGroupName")
  valid_569021 = validateParameter(valid_569021, JString, required = true,
                                 default = nil)
  if valid_569021 != nil:
    section.add "resourceGroupName", valid_569021
  var valid_569022 = path.getOrDefault("collectionRid")
  valid_569022 = validateParameter(valid_569022, JString, required = true,
                                 default = nil)
  if valid_569022 != nil:
    section.add "collectionRid", valid_569022
  var valid_569023 = path.getOrDefault("subscriptionId")
  valid_569023 = validateParameter(valid_569023, JString, required = true,
                                 default = nil)
  if valid_569023 != nil:
    section.add "subscriptionId", valid_569023
  var valid_569024 = path.getOrDefault("databaseRid")
  valid_569024 = validateParameter(valid_569024, JString, required = true,
                                 default = nil)
  if valid_569024 != nil:
    section.add "databaseRid", valid_569024
  var valid_569025 = path.getOrDefault("accountName")
  valid_569025 = validateParameter(valid_569025, JString, required = true,
                                 default = nil)
  if valid_569025 != nil:
    section.add "accountName", valid_569025
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569026 = query.getOrDefault("api-version")
  valid_569026 = validateParameter(valid_569026, JString, required = true,
                                 default = nil)
  if valid_569026 != nil:
    section.add "api-version", valid_569026
  var valid_569027 = query.getOrDefault("$filter")
  valid_569027 = validateParameter(valid_569027, JString, required = true,
                                 default = nil)
  if valid_569027 != nil:
    section.add "$filter", valid_569027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569028: Call_CollectionPartitionListMetrics_569018; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given collection, split by partition.
  ## 
  let valid = call_569028.validator(path, query, header, formData, body)
  let scheme = call_569028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569028.url(scheme.get, call_569028.host, call_569028.base,
                         call_569028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569028, url, valid)

proc call*(call_569029: Call_CollectionPartitionListMetrics_569018;
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
  var path_569030 = newJObject()
  var query_569031 = newJObject()
  add(path_569030, "resourceGroupName", newJString(resourceGroupName))
  add(query_569031, "api-version", newJString(apiVersion))
  add(path_569030, "collectionRid", newJString(collectionRid))
  add(path_569030, "subscriptionId", newJString(subscriptionId))
  add(path_569030, "databaseRid", newJString(databaseRid))
  add(path_569030, "accountName", newJString(accountName))
  add(query_569031, "$filter", newJString(Filter))
  result = call_569029.call(path_569030, query_569031, nil, nil, nil)

var collectionPartitionListMetrics* = Call_CollectionPartitionListMetrics_569018(
    name: "collectionPartitionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/partitions/metrics",
    validator: validate_CollectionPartitionListMetrics_569019, base: "",
    url: url_CollectionPartitionListMetrics_569020, schemes: {Scheme.Https})
type
  Call_CollectionPartitionListUsages_569032 = ref object of OpenApiRestCall_567668
proc url_CollectionPartitionListUsages_569034(protocol: Scheme; host: string;
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

proc validate_CollectionPartitionListUsages_569033(path: JsonNode; query: JsonNode;
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
  var valid_569035 = path.getOrDefault("resourceGroupName")
  valid_569035 = validateParameter(valid_569035, JString, required = true,
                                 default = nil)
  if valid_569035 != nil:
    section.add "resourceGroupName", valid_569035
  var valid_569036 = path.getOrDefault("collectionRid")
  valid_569036 = validateParameter(valid_569036, JString, required = true,
                                 default = nil)
  if valid_569036 != nil:
    section.add "collectionRid", valid_569036
  var valid_569037 = path.getOrDefault("subscriptionId")
  valid_569037 = validateParameter(valid_569037, JString, required = true,
                                 default = nil)
  if valid_569037 != nil:
    section.add "subscriptionId", valid_569037
  var valid_569038 = path.getOrDefault("databaseRid")
  valid_569038 = validateParameter(valid_569038, JString, required = true,
                                 default = nil)
  if valid_569038 != nil:
    section.add "databaseRid", valid_569038
  var valid_569039 = path.getOrDefault("accountName")
  valid_569039 = validateParameter(valid_569039, JString, required = true,
                                 default = nil)
  if valid_569039 != nil:
    section.add "accountName", valid_569039
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString
  ##          : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569040 = query.getOrDefault("api-version")
  valid_569040 = validateParameter(valid_569040, JString, required = true,
                                 default = nil)
  if valid_569040 != nil:
    section.add "api-version", valid_569040
  var valid_569041 = query.getOrDefault("$filter")
  valid_569041 = validateParameter(valid_569041, JString, required = false,
                                 default = nil)
  if valid_569041 != nil:
    section.add "$filter", valid_569041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569042: Call_CollectionPartitionListUsages_569032; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the usages (most recent storage data) for the given collection, split by partition.
  ## 
  let valid = call_569042.validator(path, query, header, formData, body)
  let scheme = call_569042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569042.url(scheme.get, call_569042.host, call_569042.base,
                         call_569042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569042, url, valid)

proc call*(call_569043: Call_CollectionPartitionListUsages_569032;
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
  var path_569044 = newJObject()
  var query_569045 = newJObject()
  add(path_569044, "resourceGroupName", newJString(resourceGroupName))
  add(query_569045, "api-version", newJString(apiVersion))
  add(path_569044, "collectionRid", newJString(collectionRid))
  add(path_569044, "subscriptionId", newJString(subscriptionId))
  add(path_569044, "databaseRid", newJString(databaseRid))
  add(path_569044, "accountName", newJString(accountName))
  add(query_569045, "$filter", newJString(Filter))
  result = call_569043.call(path_569044, query_569045, nil, nil, nil)

var collectionPartitionListUsages* = Call_CollectionPartitionListUsages_569032(
    name: "collectionPartitionListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/partitions/usages",
    validator: validate_CollectionPartitionListUsages_569033, base: "",
    url: url_CollectionPartitionListUsages_569034, schemes: {Scheme.Https})
type
  Call_CollectionListUsages_569046 = ref object of OpenApiRestCall_567668
proc url_CollectionListUsages_569048(protocol: Scheme; host: string; base: string;
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

proc validate_CollectionListUsages_569047(path: JsonNode; query: JsonNode;
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
  var valid_569049 = path.getOrDefault("resourceGroupName")
  valid_569049 = validateParameter(valid_569049, JString, required = true,
                                 default = nil)
  if valid_569049 != nil:
    section.add "resourceGroupName", valid_569049
  var valid_569050 = path.getOrDefault("collectionRid")
  valid_569050 = validateParameter(valid_569050, JString, required = true,
                                 default = nil)
  if valid_569050 != nil:
    section.add "collectionRid", valid_569050
  var valid_569051 = path.getOrDefault("subscriptionId")
  valid_569051 = validateParameter(valid_569051, JString, required = true,
                                 default = nil)
  if valid_569051 != nil:
    section.add "subscriptionId", valid_569051
  var valid_569052 = path.getOrDefault("databaseRid")
  valid_569052 = validateParameter(valid_569052, JString, required = true,
                                 default = nil)
  if valid_569052 != nil:
    section.add "databaseRid", valid_569052
  var valid_569053 = path.getOrDefault("accountName")
  valid_569053 = validateParameter(valid_569053, JString, required = true,
                                 default = nil)
  if valid_569053 != nil:
    section.add "accountName", valid_569053
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString
  ##          : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569054 = query.getOrDefault("api-version")
  valid_569054 = validateParameter(valid_569054, JString, required = true,
                                 default = nil)
  if valid_569054 != nil:
    section.add "api-version", valid_569054
  var valid_569055 = query.getOrDefault("$filter")
  valid_569055 = validateParameter(valid_569055, JString, required = false,
                                 default = nil)
  if valid_569055 != nil:
    section.add "$filter", valid_569055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569056: Call_CollectionListUsages_569046; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the usages (most recent storage data) for the given collection.
  ## 
  let valid = call_569056.validator(path, query, header, formData, body)
  let scheme = call_569056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569056.url(scheme.get, call_569056.host, call_569056.base,
                         call_569056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569056, url, valid)

proc call*(call_569057: Call_CollectionListUsages_569046;
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
  var path_569058 = newJObject()
  var query_569059 = newJObject()
  add(path_569058, "resourceGroupName", newJString(resourceGroupName))
  add(query_569059, "api-version", newJString(apiVersion))
  add(path_569058, "collectionRid", newJString(collectionRid))
  add(path_569058, "subscriptionId", newJString(subscriptionId))
  add(path_569058, "databaseRid", newJString(databaseRid))
  add(path_569058, "accountName", newJString(accountName))
  add(query_569059, "$filter", newJString(Filter))
  result = call_569057.call(path_569058, query_569059, nil, nil, nil)

var collectionListUsages* = Call_CollectionListUsages_569046(
    name: "collectionListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/usages",
    validator: validate_CollectionListUsages_569047, base: "",
    url: url_CollectionListUsages_569048, schemes: {Scheme.Https})
type
  Call_DatabaseListMetricDefinitions_569060 = ref object of OpenApiRestCall_567668
proc url_DatabaseListMetricDefinitions_569062(protocol: Scheme; host: string;
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

proc validate_DatabaseListMetricDefinitions_569061(path: JsonNode; query: JsonNode;
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
  var valid_569063 = path.getOrDefault("resourceGroupName")
  valid_569063 = validateParameter(valid_569063, JString, required = true,
                                 default = nil)
  if valid_569063 != nil:
    section.add "resourceGroupName", valid_569063
  var valid_569064 = path.getOrDefault("subscriptionId")
  valid_569064 = validateParameter(valid_569064, JString, required = true,
                                 default = nil)
  if valid_569064 != nil:
    section.add "subscriptionId", valid_569064
  var valid_569065 = path.getOrDefault("databaseRid")
  valid_569065 = validateParameter(valid_569065, JString, required = true,
                                 default = nil)
  if valid_569065 != nil:
    section.add "databaseRid", valid_569065
  var valid_569066 = path.getOrDefault("accountName")
  valid_569066 = validateParameter(valid_569066, JString, required = true,
                                 default = nil)
  if valid_569066 != nil:
    section.add "accountName", valid_569066
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569067 = query.getOrDefault("api-version")
  valid_569067 = validateParameter(valid_569067, JString, required = true,
                                 default = nil)
  if valid_569067 != nil:
    section.add "api-version", valid_569067
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569068: Call_DatabaseListMetricDefinitions_569060; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves metric definitions for the given database.
  ## 
  let valid = call_569068.validator(path, query, header, formData, body)
  let scheme = call_569068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569068.url(scheme.get, call_569068.host, call_569068.base,
                         call_569068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569068, url, valid)

proc call*(call_569069: Call_DatabaseListMetricDefinitions_569060;
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
  var path_569070 = newJObject()
  var query_569071 = newJObject()
  add(path_569070, "resourceGroupName", newJString(resourceGroupName))
  add(query_569071, "api-version", newJString(apiVersion))
  add(path_569070, "subscriptionId", newJString(subscriptionId))
  add(path_569070, "databaseRid", newJString(databaseRid))
  add(path_569070, "accountName", newJString(accountName))
  result = call_569069.call(path_569070, query_569071, nil, nil, nil)

var databaseListMetricDefinitions* = Call_DatabaseListMetricDefinitions_569060(
    name: "databaseListMetricDefinitions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/metricDefinitions",
    validator: validate_DatabaseListMetricDefinitions_569061, base: "",
    url: url_DatabaseListMetricDefinitions_569062, schemes: {Scheme.Https})
type
  Call_DatabaseListMetrics_569072 = ref object of OpenApiRestCall_567668
proc url_DatabaseListMetrics_569074(protocol: Scheme; host: string; base: string;
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

proc validate_DatabaseListMetrics_569073(path: JsonNode; query: JsonNode;
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
  var valid_569075 = path.getOrDefault("resourceGroupName")
  valid_569075 = validateParameter(valid_569075, JString, required = true,
                                 default = nil)
  if valid_569075 != nil:
    section.add "resourceGroupName", valid_569075
  var valid_569076 = path.getOrDefault("subscriptionId")
  valid_569076 = validateParameter(valid_569076, JString, required = true,
                                 default = nil)
  if valid_569076 != nil:
    section.add "subscriptionId", valid_569076
  var valid_569077 = path.getOrDefault("databaseRid")
  valid_569077 = validateParameter(valid_569077, JString, required = true,
                                 default = nil)
  if valid_569077 != nil:
    section.add "databaseRid", valid_569077
  var valid_569078 = path.getOrDefault("accountName")
  valid_569078 = validateParameter(valid_569078, JString, required = true,
                                 default = nil)
  if valid_569078 != nil:
    section.add "accountName", valid_569078
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569079 = query.getOrDefault("api-version")
  valid_569079 = validateParameter(valid_569079, JString, required = true,
                                 default = nil)
  if valid_569079 != nil:
    section.add "api-version", valid_569079
  var valid_569080 = query.getOrDefault("$filter")
  valid_569080 = validateParameter(valid_569080, JString, required = true,
                                 default = nil)
  if valid_569080 != nil:
    section.add "$filter", valid_569080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569081: Call_DatabaseListMetrics_569072; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account and database.
  ## 
  let valid = call_569081.validator(path, query, header, formData, body)
  let scheme = call_569081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569081.url(scheme.get, call_569081.host, call_569081.base,
                         call_569081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569081, url, valid)

proc call*(call_569082: Call_DatabaseListMetrics_569072; resourceGroupName: string;
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
  var path_569083 = newJObject()
  var query_569084 = newJObject()
  add(path_569083, "resourceGroupName", newJString(resourceGroupName))
  add(query_569084, "api-version", newJString(apiVersion))
  add(path_569083, "subscriptionId", newJString(subscriptionId))
  add(path_569083, "databaseRid", newJString(databaseRid))
  add(path_569083, "accountName", newJString(accountName))
  add(query_569084, "$filter", newJString(Filter))
  result = call_569082.call(path_569083, query_569084, nil, nil, nil)

var databaseListMetrics* = Call_DatabaseListMetrics_569072(
    name: "databaseListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/metrics",
    validator: validate_DatabaseListMetrics_569073, base: "",
    url: url_DatabaseListMetrics_569074, schemes: {Scheme.Https})
type
  Call_DatabaseListUsages_569085 = ref object of OpenApiRestCall_567668
proc url_DatabaseListUsages_569087(protocol: Scheme; host: string; base: string;
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

proc validate_DatabaseListUsages_569086(path: JsonNode; query: JsonNode;
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
  var valid_569088 = path.getOrDefault("resourceGroupName")
  valid_569088 = validateParameter(valid_569088, JString, required = true,
                                 default = nil)
  if valid_569088 != nil:
    section.add "resourceGroupName", valid_569088
  var valid_569089 = path.getOrDefault("subscriptionId")
  valid_569089 = validateParameter(valid_569089, JString, required = true,
                                 default = nil)
  if valid_569089 != nil:
    section.add "subscriptionId", valid_569089
  var valid_569090 = path.getOrDefault("databaseRid")
  valid_569090 = validateParameter(valid_569090, JString, required = true,
                                 default = nil)
  if valid_569090 != nil:
    section.add "databaseRid", valid_569090
  var valid_569091 = path.getOrDefault("accountName")
  valid_569091 = validateParameter(valid_569091, JString, required = true,
                                 default = nil)
  if valid_569091 != nil:
    section.add "accountName", valid_569091
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString
  ##          : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569092 = query.getOrDefault("api-version")
  valid_569092 = validateParameter(valid_569092, JString, required = true,
                                 default = nil)
  if valid_569092 != nil:
    section.add "api-version", valid_569092
  var valid_569093 = query.getOrDefault("$filter")
  valid_569093 = validateParameter(valid_569093, JString, required = false,
                                 default = nil)
  if valid_569093 != nil:
    section.add "$filter", valid_569093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569094: Call_DatabaseListUsages_569085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the usages (most recent data) for the given database.
  ## 
  let valid = call_569094.validator(path, query, header, formData, body)
  let scheme = call_569094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569094.url(scheme.get, call_569094.host, call_569094.base,
                         call_569094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569094, url, valid)

proc call*(call_569095: Call_DatabaseListUsages_569085; resourceGroupName: string;
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
  var path_569096 = newJObject()
  var query_569097 = newJObject()
  add(path_569096, "resourceGroupName", newJString(resourceGroupName))
  add(query_569097, "api-version", newJString(apiVersion))
  add(path_569096, "subscriptionId", newJString(subscriptionId))
  add(path_569096, "databaseRid", newJString(databaseRid))
  add(path_569096, "accountName", newJString(accountName))
  add(query_569097, "$filter", newJString(Filter))
  result = call_569095.call(path_569096, query_569097, nil, nil, nil)

var databaseListUsages* = Call_DatabaseListUsages_569085(
    name: "databaseListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/usages",
    validator: validate_DatabaseListUsages_569086, base: "",
    url: url_DatabaseListUsages_569087, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsFailoverPriorityChange_569098 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsFailoverPriorityChange_569100(protocol: Scheme;
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

proc validate_DatabaseAccountsFailoverPriorityChange_569099(path: JsonNode;
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
  var valid_569118 = path.getOrDefault("resourceGroupName")
  valid_569118 = validateParameter(valid_569118, JString, required = true,
                                 default = nil)
  if valid_569118 != nil:
    section.add "resourceGroupName", valid_569118
  var valid_569119 = path.getOrDefault("subscriptionId")
  valid_569119 = validateParameter(valid_569119, JString, required = true,
                                 default = nil)
  if valid_569119 != nil:
    section.add "subscriptionId", valid_569119
  var valid_569120 = path.getOrDefault("accountName")
  valid_569120 = validateParameter(valid_569120, JString, required = true,
                                 default = nil)
  if valid_569120 != nil:
    section.add "accountName", valid_569120
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569121 = query.getOrDefault("api-version")
  valid_569121 = validateParameter(valid_569121, JString, required = true,
                                 default = nil)
  if valid_569121 != nil:
    section.add "api-version", valid_569121
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

proc call*(call_569123: Call_DatabaseAccountsFailoverPriorityChange_569098;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Changes the failover priority for the Azure Cosmos DB database account. A failover priority of 0 indicates a write region. The maximum value for a failover priority = (total number of regions - 1). Failover priority values must be unique for each of the regions in which the database account exists.
  ## 
  let valid = call_569123.validator(path, query, header, formData, body)
  let scheme = call_569123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569123.url(scheme.get, call_569123.host, call_569123.base,
                         call_569123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569123, url, valid)

proc call*(call_569124: Call_DatabaseAccountsFailoverPriorityChange_569098;
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
  var path_569125 = newJObject()
  var query_569126 = newJObject()
  var body_569127 = newJObject()
  add(path_569125, "resourceGroupName", newJString(resourceGroupName))
  add(query_569126, "api-version", newJString(apiVersion))
  add(path_569125, "subscriptionId", newJString(subscriptionId))
  if failoverParameters != nil:
    body_569127 = failoverParameters
  add(path_569125, "accountName", newJString(accountName))
  result = call_569124.call(path_569125, query_569126, nil, nil, body_569127)

var databaseAccountsFailoverPriorityChange* = Call_DatabaseAccountsFailoverPriorityChange_569098(
    name: "databaseAccountsFailoverPriorityChange", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/failoverPriorityChange",
    validator: validate_DatabaseAccountsFailoverPriorityChange_569099, base: "",
    url: url_DatabaseAccountsFailoverPriorityChange_569100,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListConnectionStrings_569128 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsListConnectionStrings_569130(protocol: Scheme;
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

proc validate_DatabaseAccountsListConnectionStrings_569129(path: JsonNode;
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
  var valid_569131 = path.getOrDefault("resourceGroupName")
  valid_569131 = validateParameter(valid_569131, JString, required = true,
                                 default = nil)
  if valid_569131 != nil:
    section.add "resourceGroupName", valid_569131
  var valid_569132 = path.getOrDefault("subscriptionId")
  valid_569132 = validateParameter(valid_569132, JString, required = true,
                                 default = nil)
  if valid_569132 != nil:
    section.add "subscriptionId", valid_569132
  var valid_569133 = path.getOrDefault("accountName")
  valid_569133 = validateParameter(valid_569133, JString, required = true,
                                 default = nil)
  if valid_569133 != nil:
    section.add "accountName", valid_569133
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569134 = query.getOrDefault("api-version")
  valid_569134 = validateParameter(valid_569134, JString, required = true,
                                 default = nil)
  if valid_569134 != nil:
    section.add "api-version", valid_569134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569135: Call_DatabaseAccountsListConnectionStrings_569128;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the connection strings for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_569135.validator(path, query, header, formData, body)
  let scheme = call_569135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569135.url(scheme.get, call_569135.host, call_569135.base,
                         call_569135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569135, url, valid)

proc call*(call_569136: Call_DatabaseAccountsListConnectionStrings_569128;
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
  var path_569137 = newJObject()
  var query_569138 = newJObject()
  add(path_569137, "resourceGroupName", newJString(resourceGroupName))
  add(query_569138, "api-version", newJString(apiVersion))
  add(path_569137, "subscriptionId", newJString(subscriptionId))
  add(path_569137, "accountName", newJString(accountName))
  result = call_569136.call(path_569137, query_569138, nil, nil, nil)

var databaseAccountsListConnectionStrings* = Call_DatabaseAccountsListConnectionStrings_569128(
    name: "databaseAccountsListConnectionStrings", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/listConnectionStrings",
    validator: validate_DatabaseAccountsListConnectionStrings_569129, base: "",
    url: url_DatabaseAccountsListConnectionStrings_569130, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListKeys_569139 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsListKeys_569141(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListKeys_569140(path: JsonNode; query: JsonNode;
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
  var valid_569142 = path.getOrDefault("resourceGroupName")
  valid_569142 = validateParameter(valid_569142, JString, required = true,
                                 default = nil)
  if valid_569142 != nil:
    section.add "resourceGroupName", valid_569142
  var valid_569143 = path.getOrDefault("subscriptionId")
  valid_569143 = validateParameter(valid_569143, JString, required = true,
                                 default = nil)
  if valid_569143 != nil:
    section.add "subscriptionId", valid_569143
  var valid_569144 = path.getOrDefault("accountName")
  valid_569144 = validateParameter(valid_569144, JString, required = true,
                                 default = nil)
  if valid_569144 != nil:
    section.add "accountName", valid_569144
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569145 = query.getOrDefault("api-version")
  valid_569145 = validateParameter(valid_569145, JString, required = true,
                                 default = nil)
  if valid_569145 != nil:
    section.add "api-version", valid_569145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569146: Call_DatabaseAccountsListKeys_569139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the access keys for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_569146.validator(path, query, header, formData, body)
  let scheme = call_569146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569146.url(scheme.get, call_569146.host, call_569146.base,
                         call_569146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569146, url, valid)

proc call*(call_569147: Call_DatabaseAccountsListKeys_569139;
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
  var path_569148 = newJObject()
  var query_569149 = newJObject()
  add(path_569148, "resourceGroupName", newJString(resourceGroupName))
  add(query_569149, "api-version", newJString(apiVersion))
  add(path_569148, "subscriptionId", newJString(subscriptionId))
  add(path_569148, "accountName", newJString(accountName))
  result = call_569147.call(path_569148, query_569149, nil, nil, nil)

var databaseAccountsListKeys* = Call_DatabaseAccountsListKeys_569139(
    name: "databaseAccountsListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/listKeys",
    validator: validate_DatabaseAccountsListKeys_569140, base: "",
    url: url_DatabaseAccountsListKeys_569141, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListMetricDefinitions_569150 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsListMetricDefinitions_569152(protocol: Scheme;
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

proc validate_DatabaseAccountsListMetricDefinitions_569151(path: JsonNode;
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
  var valid_569153 = path.getOrDefault("resourceGroupName")
  valid_569153 = validateParameter(valid_569153, JString, required = true,
                                 default = nil)
  if valid_569153 != nil:
    section.add "resourceGroupName", valid_569153
  var valid_569154 = path.getOrDefault("subscriptionId")
  valid_569154 = validateParameter(valid_569154, JString, required = true,
                                 default = nil)
  if valid_569154 != nil:
    section.add "subscriptionId", valid_569154
  var valid_569155 = path.getOrDefault("accountName")
  valid_569155 = validateParameter(valid_569155, JString, required = true,
                                 default = nil)
  if valid_569155 != nil:
    section.add "accountName", valid_569155
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569156 = query.getOrDefault("api-version")
  valid_569156 = validateParameter(valid_569156, JString, required = true,
                                 default = nil)
  if valid_569156 != nil:
    section.add "api-version", valid_569156
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569157: Call_DatabaseAccountsListMetricDefinitions_569150;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves metric definitions for the given database account.
  ## 
  let valid = call_569157.validator(path, query, header, formData, body)
  let scheme = call_569157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569157.url(scheme.get, call_569157.host, call_569157.base,
                         call_569157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569157, url, valid)

proc call*(call_569158: Call_DatabaseAccountsListMetricDefinitions_569150;
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
  var path_569159 = newJObject()
  var query_569160 = newJObject()
  add(path_569159, "resourceGroupName", newJString(resourceGroupName))
  add(query_569160, "api-version", newJString(apiVersion))
  add(path_569159, "subscriptionId", newJString(subscriptionId))
  add(path_569159, "accountName", newJString(accountName))
  result = call_569158.call(path_569159, query_569160, nil, nil, nil)

var databaseAccountsListMetricDefinitions* = Call_DatabaseAccountsListMetricDefinitions_569150(
    name: "databaseAccountsListMetricDefinitions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/metricDefinitions",
    validator: validate_DatabaseAccountsListMetricDefinitions_569151, base: "",
    url: url_DatabaseAccountsListMetricDefinitions_569152, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListMetrics_569161 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsListMetrics_569163(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListMetrics_569162(path: JsonNode; query: JsonNode;
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
  var valid_569164 = path.getOrDefault("resourceGroupName")
  valid_569164 = validateParameter(valid_569164, JString, required = true,
                                 default = nil)
  if valid_569164 != nil:
    section.add "resourceGroupName", valid_569164
  var valid_569165 = path.getOrDefault("subscriptionId")
  valid_569165 = validateParameter(valid_569165, JString, required = true,
                                 default = nil)
  if valid_569165 != nil:
    section.add "subscriptionId", valid_569165
  var valid_569166 = path.getOrDefault("accountName")
  valid_569166 = validateParameter(valid_569166, JString, required = true,
                                 default = nil)
  if valid_569166 != nil:
    section.add "accountName", valid_569166
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569167 = query.getOrDefault("api-version")
  valid_569167 = validateParameter(valid_569167, JString, required = true,
                                 default = nil)
  if valid_569167 != nil:
    section.add "api-version", valid_569167
  var valid_569168 = query.getOrDefault("$filter")
  valid_569168 = validateParameter(valid_569168, JString, required = true,
                                 default = nil)
  if valid_569168 != nil:
    section.add "$filter", valid_569168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569169: Call_DatabaseAccountsListMetrics_569161; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account.
  ## 
  let valid = call_569169.validator(path, query, header, formData, body)
  let scheme = call_569169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569169.url(scheme.get, call_569169.host, call_569169.base,
                         call_569169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569169, url, valid)

proc call*(call_569170: Call_DatabaseAccountsListMetrics_569161;
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
  var path_569171 = newJObject()
  var query_569172 = newJObject()
  add(path_569171, "resourceGroupName", newJString(resourceGroupName))
  add(query_569172, "api-version", newJString(apiVersion))
  add(path_569171, "subscriptionId", newJString(subscriptionId))
  add(path_569171, "accountName", newJString(accountName))
  add(query_569172, "$filter", newJString(Filter))
  result = call_569170.call(path_569171, query_569172, nil, nil, nil)

var databaseAccountsListMetrics* = Call_DatabaseAccountsListMetrics_569161(
    name: "databaseAccountsListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/metrics",
    validator: validate_DatabaseAccountsListMetrics_569162, base: "",
    url: url_DatabaseAccountsListMetrics_569163, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsOfflineRegion_569173 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsOfflineRegion_569175(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsOfflineRegion_569174(path: JsonNode; query: JsonNode;
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
  var valid_569176 = path.getOrDefault("resourceGroupName")
  valid_569176 = validateParameter(valid_569176, JString, required = true,
                                 default = nil)
  if valid_569176 != nil:
    section.add "resourceGroupName", valid_569176
  var valid_569177 = path.getOrDefault("subscriptionId")
  valid_569177 = validateParameter(valid_569177, JString, required = true,
                                 default = nil)
  if valid_569177 != nil:
    section.add "subscriptionId", valid_569177
  var valid_569178 = path.getOrDefault("accountName")
  valid_569178 = validateParameter(valid_569178, JString, required = true,
                                 default = nil)
  if valid_569178 != nil:
    section.add "accountName", valid_569178
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569179 = query.getOrDefault("api-version")
  valid_569179 = validateParameter(valid_569179, JString, required = true,
                                 default = nil)
  if valid_569179 != nil:
    section.add "api-version", valid_569179
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

proc call*(call_569181: Call_DatabaseAccountsOfflineRegion_569173; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Offline the specified region for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_569181.validator(path, query, header, formData, body)
  let scheme = call_569181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569181.url(scheme.get, call_569181.host, call_569181.base,
                         call_569181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569181, url, valid)

proc call*(call_569182: Call_DatabaseAccountsOfflineRegion_569173;
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
  var path_569183 = newJObject()
  var query_569184 = newJObject()
  var body_569185 = newJObject()
  add(path_569183, "resourceGroupName", newJString(resourceGroupName))
  add(query_569184, "api-version", newJString(apiVersion))
  add(path_569183, "subscriptionId", newJString(subscriptionId))
  if regionParameterForOffline != nil:
    body_569185 = regionParameterForOffline
  add(path_569183, "accountName", newJString(accountName))
  result = call_569182.call(path_569183, query_569184, nil, nil, body_569185)

var databaseAccountsOfflineRegion* = Call_DatabaseAccountsOfflineRegion_569173(
    name: "databaseAccountsOfflineRegion", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/offlineRegion",
    validator: validate_DatabaseAccountsOfflineRegion_569174, base: "",
    url: url_DatabaseAccountsOfflineRegion_569175, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsOnlineRegion_569186 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsOnlineRegion_569188(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsOnlineRegion_569187(path: JsonNode; query: JsonNode;
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
  var valid_569189 = path.getOrDefault("resourceGroupName")
  valid_569189 = validateParameter(valid_569189, JString, required = true,
                                 default = nil)
  if valid_569189 != nil:
    section.add "resourceGroupName", valid_569189
  var valid_569190 = path.getOrDefault("subscriptionId")
  valid_569190 = validateParameter(valid_569190, JString, required = true,
                                 default = nil)
  if valid_569190 != nil:
    section.add "subscriptionId", valid_569190
  var valid_569191 = path.getOrDefault("accountName")
  valid_569191 = validateParameter(valid_569191, JString, required = true,
                                 default = nil)
  if valid_569191 != nil:
    section.add "accountName", valid_569191
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569192 = query.getOrDefault("api-version")
  valid_569192 = validateParameter(valid_569192, JString, required = true,
                                 default = nil)
  if valid_569192 != nil:
    section.add "api-version", valid_569192
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

proc call*(call_569194: Call_DatabaseAccountsOnlineRegion_569186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Online the specified region for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_569194.validator(path, query, header, formData, body)
  let scheme = call_569194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569194.url(scheme.get, call_569194.host, call_569194.base,
                         call_569194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569194, url, valid)

proc call*(call_569195: Call_DatabaseAccountsOnlineRegion_569186;
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
  var path_569196 = newJObject()
  var query_569197 = newJObject()
  var body_569198 = newJObject()
  add(path_569196, "resourceGroupName", newJString(resourceGroupName))
  add(query_569197, "api-version", newJString(apiVersion))
  add(path_569196, "subscriptionId", newJString(subscriptionId))
  if regionParameterForOnline != nil:
    body_569198 = regionParameterForOnline
  add(path_569196, "accountName", newJString(accountName))
  result = call_569195.call(path_569196, query_569197, nil, nil, body_569198)

var databaseAccountsOnlineRegion* = Call_DatabaseAccountsOnlineRegion_569186(
    name: "databaseAccountsOnlineRegion", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/onlineRegion",
    validator: validate_DatabaseAccountsOnlineRegion_569187, base: "",
    url: url_DatabaseAccountsOnlineRegion_569188, schemes: {Scheme.Https})
type
  Call_PercentileListMetrics_569199 = ref object of OpenApiRestCall_567668
proc url_PercentileListMetrics_569201(protocol: Scheme; host: string; base: string;
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

proc validate_PercentileListMetrics_569200(path: JsonNode; query: JsonNode;
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
  var valid_569202 = path.getOrDefault("resourceGroupName")
  valid_569202 = validateParameter(valid_569202, JString, required = true,
                                 default = nil)
  if valid_569202 != nil:
    section.add "resourceGroupName", valid_569202
  var valid_569203 = path.getOrDefault("subscriptionId")
  valid_569203 = validateParameter(valid_569203, JString, required = true,
                                 default = nil)
  if valid_569203 != nil:
    section.add "subscriptionId", valid_569203
  var valid_569204 = path.getOrDefault("accountName")
  valid_569204 = validateParameter(valid_569204, JString, required = true,
                                 default = nil)
  if valid_569204 != nil:
    section.add "accountName", valid_569204
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569205 = query.getOrDefault("api-version")
  valid_569205 = validateParameter(valid_569205, JString, required = true,
                                 default = nil)
  if valid_569205 != nil:
    section.add "api-version", valid_569205
  var valid_569206 = query.getOrDefault("$filter")
  valid_569206 = validateParameter(valid_569206, JString, required = true,
                                 default = nil)
  if valid_569206 != nil:
    section.add "$filter", valid_569206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569207: Call_PercentileListMetrics_569199; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account. This url is only for PBS and Replication Latency data
  ## 
  let valid = call_569207.validator(path, query, header, formData, body)
  let scheme = call_569207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569207.url(scheme.get, call_569207.host, call_569207.base,
                         call_569207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569207, url, valid)

proc call*(call_569208: Call_PercentileListMetrics_569199;
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
  var path_569209 = newJObject()
  var query_569210 = newJObject()
  add(path_569209, "resourceGroupName", newJString(resourceGroupName))
  add(query_569210, "api-version", newJString(apiVersion))
  add(path_569209, "subscriptionId", newJString(subscriptionId))
  add(path_569209, "accountName", newJString(accountName))
  add(query_569210, "$filter", newJString(Filter))
  result = call_569208.call(path_569209, query_569210, nil, nil, nil)

var percentileListMetrics* = Call_PercentileListMetrics_569199(
    name: "percentileListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/percentile/metrics",
    validator: validate_PercentileListMetrics_569200, base: "",
    url: url_PercentileListMetrics_569201, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListReadOnlyKeys_569222 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsListReadOnlyKeys_569224(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListReadOnlyKeys_569223(path: JsonNode;
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
  var valid_569225 = path.getOrDefault("resourceGroupName")
  valid_569225 = validateParameter(valid_569225, JString, required = true,
                                 default = nil)
  if valid_569225 != nil:
    section.add "resourceGroupName", valid_569225
  var valid_569226 = path.getOrDefault("subscriptionId")
  valid_569226 = validateParameter(valid_569226, JString, required = true,
                                 default = nil)
  if valid_569226 != nil:
    section.add "subscriptionId", valid_569226
  var valid_569227 = path.getOrDefault("accountName")
  valid_569227 = validateParameter(valid_569227, JString, required = true,
                                 default = nil)
  if valid_569227 != nil:
    section.add "accountName", valid_569227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569228 = query.getOrDefault("api-version")
  valid_569228 = validateParameter(valid_569228, JString, required = true,
                                 default = nil)
  if valid_569228 != nil:
    section.add "api-version", valid_569228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569229: Call_DatabaseAccountsListReadOnlyKeys_569222;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the read-only access keys for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_569229.validator(path, query, header, formData, body)
  let scheme = call_569229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569229.url(scheme.get, call_569229.host, call_569229.base,
                         call_569229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569229, url, valid)

proc call*(call_569230: Call_DatabaseAccountsListReadOnlyKeys_569222;
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
  var path_569231 = newJObject()
  var query_569232 = newJObject()
  add(path_569231, "resourceGroupName", newJString(resourceGroupName))
  add(query_569232, "api-version", newJString(apiVersion))
  add(path_569231, "subscriptionId", newJString(subscriptionId))
  add(path_569231, "accountName", newJString(accountName))
  result = call_569230.call(path_569231, query_569232, nil, nil, nil)

var databaseAccountsListReadOnlyKeys* = Call_DatabaseAccountsListReadOnlyKeys_569222(
    name: "databaseAccountsListReadOnlyKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/readonlykeys",
    validator: validate_DatabaseAccountsListReadOnlyKeys_569223, base: "",
    url: url_DatabaseAccountsListReadOnlyKeys_569224, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetReadOnlyKeys_569211 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsGetReadOnlyKeys_569213(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsGetReadOnlyKeys_569212(path: JsonNode;
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
  var valid_569214 = path.getOrDefault("resourceGroupName")
  valid_569214 = validateParameter(valid_569214, JString, required = true,
                                 default = nil)
  if valid_569214 != nil:
    section.add "resourceGroupName", valid_569214
  var valid_569215 = path.getOrDefault("subscriptionId")
  valid_569215 = validateParameter(valid_569215, JString, required = true,
                                 default = nil)
  if valid_569215 != nil:
    section.add "subscriptionId", valid_569215
  var valid_569216 = path.getOrDefault("accountName")
  valid_569216 = validateParameter(valid_569216, JString, required = true,
                                 default = nil)
  if valid_569216 != nil:
    section.add "accountName", valid_569216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569217 = query.getOrDefault("api-version")
  valid_569217 = validateParameter(valid_569217, JString, required = true,
                                 default = nil)
  if valid_569217 != nil:
    section.add "api-version", valid_569217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569218: Call_DatabaseAccountsGetReadOnlyKeys_569211;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the read-only access keys for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_569218.validator(path, query, header, formData, body)
  let scheme = call_569218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569218.url(scheme.get, call_569218.host, call_569218.base,
                         call_569218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569218, url, valid)

proc call*(call_569219: Call_DatabaseAccountsGetReadOnlyKeys_569211;
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
  var path_569220 = newJObject()
  var query_569221 = newJObject()
  add(path_569220, "resourceGroupName", newJString(resourceGroupName))
  add(query_569221, "api-version", newJString(apiVersion))
  add(path_569220, "subscriptionId", newJString(subscriptionId))
  add(path_569220, "accountName", newJString(accountName))
  result = call_569219.call(path_569220, query_569221, nil, nil, nil)

var databaseAccountsGetReadOnlyKeys* = Call_DatabaseAccountsGetReadOnlyKeys_569211(
    name: "databaseAccountsGetReadOnlyKeys", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/readonlykeys",
    validator: validate_DatabaseAccountsGetReadOnlyKeys_569212, base: "",
    url: url_DatabaseAccountsGetReadOnlyKeys_569213, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsRegenerateKey_569233 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsRegenerateKey_569235(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsRegenerateKey_569234(path: JsonNode; query: JsonNode;
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
  var valid_569236 = path.getOrDefault("resourceGroupName")
  valid_569236 = validateParameter(valid_569236, JString, required = true,
                                 default = nil)
  if valid_569236 != nil:
    section.add "resourceGroupName", valid_569236
  var valid_569237 = path.getOrDefault("subscriptionId")
  valid_569237 = validateParameter(valid_569237, JString, required = true,
                                 default = nil)
  if valid_569237 != nil:
    section.add "subscriptionId", valid_569237
  var valid_569238 = path.getOrDefault("accountName")
  valid_569238 = validateParameter(valid_569238, JString, required = true,
                                 default = nil)
  if valid_569238 != nil:
    section.add "accountName", valid_569238
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569239 = query.getOrDefault("api-version")
  valid_569239 = validateParameter(valid_569239, JString, required = true,
                                 default = nil)
  if valid_569239 != nil:
    section.add "api-version", valid_569239
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

proc call*(call_569241: Call_DatabaseAccountsRegenerateKey_569233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates an access key for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_569241.validator(path, query, header, formData, body)
  let scheme = call_569241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569241.url(scheme.get, call_569241.host, call_569241.base,
                         call_569241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569241, url, valid)

proc call*(call_569242: Call_DatabaseAccountsRegenerateKey_569233;
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
  var path_569243 = newJObject()
  var query_569244 = newJObject()
  var body_569245 = newJObject()
  add(path_569243, "resourceGroupName", newJString(resourceGroupName))
  add(query_569244, "api-version", newJString(apiVersion))
  add(path_569243, "subscriptionId", newJString(subscriptionId))
  add(path_569243, "accountName", newJString(accountName))
  if keyToRegenerate != nil:
    body_569245 = keyToRegenerate
  result = call_569242.call(path_569243, query_569244, nil, nil, body_569245)

var databaseAccountsRegenerateKey* = Call_DatabaseAccountsRegenerateKey_569233(
    name: "databaseAccountsRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/regenerateKey",
    validator: validate_DatabaseAccountsRegenerateKey_569234, base: "",
    url: url_DatabaseAccountsRegenerateKey_569235, schemes: {Scheme.Https})
type
  Call_CollectionRegionListMetrics_569246 = ref object of OpenApiRestCall_567668
proc url_CollectionRegionListMetrics_569248(protocol: Scheme; host: string;
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

proc validate_CollectionRegionListMetrics_569247(path: JsonNode; query: JsonNode;
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
  var valid_569249 = path.getOrDefault("resourceGroupName")
  valid_569249 = validateParameter(valid_569249, JString, required = true,
                                 default = nil)
  if valid_569249 != nil:
    section.add "resourceGroupName", valid_569249
  var valid_569250 = path.getOrDefault("collectionRid")
  valid_569250 = validateParameter(valid_569250, JString, required = true,
                                 default = nil)
  if valid_569250 != nil:
    section.add "collectionRid", valid_569250
  var valid_569251 = path.getOrDefault("subscriptionId")
  valid_569251 = validateParameter(valid_569251, JString, required = true,
                                 default = nil)
  if valid_569251 != nil:
    section.add "subscriptionId", valid_569251
  var valid_569252 = path.getOrDefault("region")
  valid_569252 = validateParameter(valid_569252, JString, required = true,
                                 default = nil)
  if valid_569252 != nil:
    section.add "region", valid_569252
  var valid_569253 = path.getOrDefault("databaseRid")
  valid_569253 = validateParameter(valid_569253, JString, required = true,
                                 default = nil)
  if valid_569253 != nil:
    section.add "databaseRid", valid_569253
  var valid_569254 = path.getOrDefault("accountName")
  valid_569254 = validateParameter(valid_569254, JString, required = true,
                                 default = nil)
  if valid_569254 != nil:
    section.add "accountName", valid_569254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569255 = query.getOrDefault("api-version")
  valid_569255 = validateParameter(valid_569255, JString, required = true,
                                 default = nil)
  if valid_569255 != nil:
    section.add "api-version", valid_569255
  var valid_569256 = query.getOrDefault("$filter")
  valid_569256 = validateParameter(valid_569256, JString, required = true,
                                 default = nil)
  if valid_569256 != nil:
    section.add "$filter", valid_569256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569257: Call_CollectionRegionListMetrics_569246; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account, collection and region.
  ## 
  let valid = call_569257.validator(path, query, header, formData, body)
  let scheme = call_569257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569257.url(scheme.get, call_569257.host, call_569257.base,
                         call_569257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569257, url, valid)

proc call*(call_569258: Call_CollectionRegionListMetrics_569246;
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
  var path_569259 = newJObject()
  var query_569260 = newJObject()
  add(path_569259, "resourceGroupName", newJString(resourceGroupName))
  add(query_569260, "api-version", newJString(apiVersion))
  add(path_569259, "collectionRid", newJString(collectionRid))
  add(path_569259, "subscriptionId", newJString(subscriptionId))
  add(path_569259, "region", newJString(region))
  add(path_569259, "databaseRid", newJString(databaseRid))
  add(path_569259, "accountName", newJString(accountName))
  add(query_569260, "$filter", newJString(Filter))
  result = call_569258.call(path_569259, query_569260, nil, nil, nil)

var collectionRegionListMetrics* = Call_CollectionRegionListMetrics_569246(
    name: "collectionRegionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/region/{region}/databases/{databaseRid}/collections/{collectionRid}/metrics",
    validator: validate_CollectionRegionListMetrics_569247, base: "",
    url: url_CollectionRegionListMetrics_569248, schemes: {Scheme.Https})
type
  Call_PartitionKeyRangeIdRegionListMetrics_569261 = ref object of OpenApiRestCall_567668
proc url_PartitionKeyRangeIdRegionListMetrics_569263(protocol: Scheme;
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

proc validate_PartitionKeyRangeIdRegionListMetrics_569262(path: JsonNode;
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
  var valid_569264 = path.getOrDefault("resourceGroupName")
  valid_569264 = validateParameter(valid_569264, JString, required = true,
                                 default = nil)
  if valid_569264 != nil:
    section.add "resourceGroupName", valid_569264
  var valid_569265 = path.getOrDefault("collectionRid")
  valid_569265 = validateParameter(valid_569265, JString, required = true,
                                 default = nil)
  if valid_569265 != nil:
    section.add "collectionRid", valid_569265
  var valid_569266 = path.getOrDefault("subscriptionId")
  valid_569266 = validateParameter(valid_569266, JString, required = true,
                                 default = nil)
  if valid_569266 != nil:
    section.add "subscriptionId", valid_569266
  var valid_569267 = path.getOrDefault("partitionKeyRangeId")
  valid_569267 = validateParameter(valid_569267, JString, required = true,
                                 default = nil)
  if valid_569267 != nil:
    section.add "partitionKeyRangeId", valid_569267
  var valid_569268 = path.getOrDefault("region")
  valid_569268 = validateParameter(valid_569268, JString, required = true,
                                 default = nil)
  if valid_569268 != nil:
    section.add "region", valid_569268
  var valid_569269 = path.getOrDefault("databaseRid")
  valid_569269 = validateParameter(valid_569269, JString, required = true,
                                 default = nil)
  if valid_569269 != nil:
    section.add "databaseRid", valid_569269
  var valid_569270 = path.getOrDefault("accountName")
  valid_569270 = validateParameter(valid_569270, JString, required = true,
                                 default = nil)
  if valid_569270 != nil:
    section.add "accountName", valid_569270
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569271 = query.getOrDefault("api-version")
  valid_569271 = validateParameter(valid_569271, JString, required = true,
                                 default = nil)
  if valid_569271 != nil:
    section.add "api-version", valid_569271
  var valid_569272 = query.getOrDefault("$filter")
  valid_569272 = validateParameter(valid_569272, JString, required = true,
                                 default = nil)
  if valid_569272 != nil:
    section.add "$filter", valid_569272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569273: Call_PartitionKeyRangeIdRegionListMetrics_569261;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given partition key range id and region.
  ## 
  let valid = call_569273.validator(path, query, header, formData, body)
  let scheme = call_569273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569273.url(scheme.get, call_569273.host, call_569273.base,
                         call_569273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569273, url, valid)

proc call*(call_569274: Call_PartitionKeyRangeIdRegionListMetrics_569261;
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
  var path_569275 = newJObject()
  var query_569276 = newJObject()
  add(path_569275, "resourceGroupName", newJString(resourceGroupName))
  add(query_569276, "api-version", newJString(apiVersion))
  add(path_569275, "collectionRid", newJString(collectionRid))
  add(path_569275, "subscriptionId", newJString(subscriptionId))
  add(path_569275, "partitionKeyRangeId", newJString(partitionKeyRangeId))
  add(path_569275, "region", newJString(region))
  add(path_569275, "databaseRid", newJString(databaseRid))
  add(path_569275, "accountName", newJString(accountName))
  add(query_569276, "$filter", newJString(Filter))
  result = call_569274.call(path_569275, query_569276, nil, nil, nil)

var partitionKeyRangeIdRegionListMetrics* = Call_PartitionKeyRangeIdRegionListMetrics_569261(
    name: "partitionKeyRangeIdRegionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/region/{region}/databases/{databaseRid}/collections/{collectionRid}/partitionKeyRangeId/{partitionKeyRangeId}/metrics",
    validator: validate_PartitionKeyRangeIdRegionListMetrics_569262, base: "",
    url: url_PartitionKeyRangeIdRegionListMetrics_569263, schemes: {Scheme.Https})
type
  Call_CollectionPartitionRegionListMetrics_569277 = ref object of OpenApiRestCall_567668
proc url_CollectionPartitionRegionListMetrics_569279(protocol: Scheme;
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

proc validate_CollectionPartitionRegionListMetrics_569278(path: JsonNode;
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
  var valid_569280 = path.getOrDefault("resourceGroupName")
  valid_569280 = validateParameter(valid_569280, JString, required = true,
                                 default = nil)
  if valid_569280 != nil:
    section.add "resourceGroupName", valid_569280
  var valid_569281 = path.getOrDefault("collectionRid")
  valid_569281 = validateParameter(valid_569281, JString, required = true,
                                 default = nil)
  if valid_569281 != nil:
    section.add "collectionRid", valid_569281
  var valid_569282 = path.getOrDefault("subscriptionId")
  valid_569282 = validateParameter(valid_569282, JString, required = true,
                                 default = nil)
  if valid_569282 != nil:
    section.add "subscriptionId", valid_569282
  var valid_569283 = path.getOrDefault("region")
  valid_569283 = validateParameter(valid_569283, JString, required = true,
                                 default = nil)
  if valid_569283 != nil:
    section.add "region", valid_569283
  var valid_569284 = path.getOrDefault("databaseRid")
  valid_569284 = validateParameter(valid_569284, JString, required = true,
                                 default = nil)
  if valid_569284 != nil:
    section.add "databaseRid", valid_569284
  var valid_569285 = path.getOrDefault("accountName")
  valid_569285 = validateParameter(valid_569285, JString, required = true,
                                 default = nil)
  if valid_569285 != nil:
    section.add "accountName", valid_569285
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569286 = query.getOrDefault("api-version")
  valid_569286 = validateParameter(valid_569286, JString, required = true,
                                 default = nil)
  if valid_569286 != nil:
    section.add "api-version", valid_569286
  var valid_569287 = query.getOrDefault("$filter")
  valid_569287 = validateParameter(valid_569287, JString, required = true,
                                 default = nil)
  if valid_569287 != nil:
    section.add "$filter", valid_569287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569288: Call_CollectionPartitionRegionListMetrics_569277;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given collection and region, split by partition.
  ## 
  let valid = call_569288.validator(path, query, header, formData, body)
  let scheme = call_569288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569288.url(scheme.get, call_569288.host, call_569288.base,
                         call_569288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569288, url, valid)

proc call*(call_569289: Call_CollectionPartitionRegionListMetrics_569277;
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
  var path_569290 = newJObject()
  var query_569291 = newJObject()
  add(path_569290, "resourceGroupName", newJString(resourceGroupName))
  add(query_569291, "api-version", newJString(apiVersion))
  add(path_569290, "collectionRid", newJString(collectionRid))
  add(path_569290, "subscriptionId", newJString(subscriptionId))
  add(path_569290, "region", newJString(region))
  add(path_569290, "databaseRid", newJString(databaseRid))
  add(path_569290, "accountName", newJString(accountName))
  add(query_569291, "$filter", newJString(Filter))
  result = call_569289.call(path_569290, query_569291, nil, nil, nil)

var collectionPartitionRegionListMetrics* = Call_CollectionPartitionRegionListMetrics_569277(
    name: "collectionPartitionRegionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/region/{region}/databases/{databaseRid}/collections/{collectionRid}/partitions/metrics",
    validator: validate_CollectionPartitionRegionListMetrics_569278, base: "",
    url: url_CollectionPartitionRegionListMetrics_569279, schemes: {Scheme.Https})
type
  Call_DatabaseAccountRegionListMetrics_569292 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountRegionListMetrics_569294(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountRegionListMetrics_569293(path: JsonNode;
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
  var valid_569295 = path.getOrDefault("resourceGroupName")
  valid_569295 = validateParameter(valid_569295, JString, required = true,
                                 default = nil)
  if valid_569295 != nil:
    section.add "resourceGroupName", valid_569295
  var valid_569296 = path.getOrDefault("subscriptionId")
  valid_569296 = validateParameter(valid_569296, JString, required = true,
                                 default = nil)
  if valid_569296 != nil:
    section.add "subscriptionId", valid_569296
  var valid_569297 = path.getOrDefault("region")
  valid_569297 = validateParameter(valid_569297, JString, required = true,
                                 default = nil)
  if valid_569297 != nil:
    section.add "region", valid_569297
  var valid_569298 = path.getOrDefault("accountName")
  valid_569298 = validateParameter(valid_569298, JString, required = true,
                                 default = nil)
  if valid_569298 != nil:
    section.add "accountName", valid_569298
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569299 = query.getOrDefault("api-version")
  valid_569299 = validateParameter(valid_569299, JString, required = true,
                                 default = nil)
  if valid_569299 != nil:
    section.add "api-version", valid_569299
  var valid_569300 = query.getOrDefault("$filter")
  valid_569300 = validateParameter(valid_569300, JString, required = true,
                                 default = nil)
  if valid_569300 != nil:
    section.add "$filter", valid_569300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569301: Call_DatabaseAccountRegionListMetrics_569292;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account and region.
  ## 
  let valid = call_569301.validator(path, query, header, formData, body)
  let scheme = call_569301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569301.url(scheme.get, call_569301.host, call_569301.base,
                         call_569301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569301, url, valid)

proc call*(call_569302: Call_DatabaseAccountRegionListMetrics_569292;
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
  var path_569303 = newJObject()
  var query_569304 = newJObject()
  add(path_569303, "resourceGroupName", newJString(resourceGroupName))
  add(query_569304, "api-version", newJString(apiVersion))
  add(path_569303, "subscriptionId", newJString(subscriptionId))
  add(path_569303, "region", newJString(region))
  add(path_569303, "accountName", newJString(accountName))
  add(query_569304, "$filter", newJString(Filter))
  result = call_569302.call(path_569303, query_569304, nil, nil, nil)

var databaseAccountRegionListMetrics* = Call_DatabaseAccountRegionListMetrics_569292(
    name: "databaseAccountRegionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/region/{region}/metrics",
    validator: validate_DatabaseAccountRegionListMetrics_569293, base: "",
    url: url_DatabaseAccountRegionListMetrics_569294, schemes: {Scheme.Https})
type
  Call_PercentileSourceTargetListMetrics_569305 = ref object of OpenApiRestCall_567668
proc url_PercentileSourceTargetListMetrics_569307(protocol: Scheme; host: string;
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

proc validate_PercentileSourceTargetListMetrics_569306(path: JsonNode;
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
  var valid_569308 = path.getOrDefault("resourceGroupName")
  valid_569308 = validateParameter(valid_569308, JString, required = true,
                                 default = nil)
  if valid_569308 != nil:
    section.add "resourceGroupName", valid_569308
  var valid_569309 = path.getOrDefault("sourceRegion")
  valid_569309 = validateParameter(valid_569309, JString, required = true,
                                 default = nil)
  if valid_569309 != nil:
    section.add "sourceRegion", valid_569309
  var valid_569310 = path.getOrDefault("subscriptionId")
  valid_569310 = validateParameter(valid_569310, JString, required = true,
                                 default = nil)
  if valid_569310 != nil:
    section.add "subscriptionId", valid_569310
  var valid_569311 = path.getOrDefault("targetRegion")
  valid_569311 = validateParameter(valid_569311, JString, required = true,
                                 default = nil)
  if valid_569311 != nil:
    section.add "targetRegion", valid_569311
  var valid_569312 = path.getOrDefault("accountName")
  valid_569312 = validateParameter(valid_569312, JString, required = true,
                                 default = nil)
  if valid_569312 != nil:
    section.add "accountName", valid_569312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569313 = query.getOrDefault("api-version")
  valid_569313 = validateParameter(valid_569313, JString, required = true,
                                 default = nil)
  if valid_569313 != nil:
    section.add "api-version", valid_569313
  var valid_569314 = query.getOrDefault("$filter")
  valid_569314 = validateParameter(valid_569314, JString, required = true,
                                 default = nil)
  if valid_569314 != nil:
    section.add "$filter", valid_569314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569315: Call_PercentileSourceTargetListMetrics_569305;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given account, source and target region. This url is only for PBS and Replication Latency data
  ## 
  let valid = call_569315.validator(path, query, header, formData, body)
  let scheme = call_569315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569315.url(scheme.get, call_569315.host, call_569315.base,
                         call_569315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569315, url, valid)

proc call*(call_569316: Call_PercentileSourceTargetListMetrics_569305;
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
  var path_569317 = newJObject()
  var query_569318 = newJObject()
  add(path_569317, "resourceGroupName", newJString(resourceGroupName))
  add(query_569318, "api-version", newJString(apiVersion))
  add(path_569317, "sourceRegion", newJString(sourceRegion))
  add(path_569317, "subscriptionId", newJString(subscriptionId))
  add(path_569317, "targetRegion", newJString(targetRegion))
  add(path_569317, "accountName", newJString(accountName))
  add(query_569318, "$filter", newJString(Filter))
  result = call_569316.call(path_569317, query_569318, nil, nil, nil)

var percentileSourceTargetListMetrics* = Call_PercentileSourceTargetListMetrics_569305(
    name: "percentileSourceTargetListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sourceRegion/{sourceRegion}/targetRegion/{targetRegion}/percentile/metrics",
    validator: validate_PercentileSourceTargetListMetrics_569306, base: "",
    url: url_PercentileSourceTargetListMetrics_569307, schemes: {Scheme.Https})
type
  Call_PercentileTargetListMetrics_569319 = ref object of OpenApiRestCall_567668
proc url_PercentileTargetListMetrics_569321(protocol: Scheme; host: string;
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

proc validate_PercentileTargetListMetrics_569320(path: JsonNode; query: JsonNode;
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
  var valid_569322 = path.getOrDefault("resourceGroupName")
  valid_569322 = validateParameter(valid_569322, JString, required = true,
                                 default = nil)
  if valid_569322 != nil:
    section.add "resourceGroupName", valid_569322
  var valid_569323 = path.getOrDefault("subscriptionId")
  valid_569323 = validateParameter(valid_569323, JString, required = true,
                                 default = nil)
  if valid_569323 != nil:
    section.add "subscriptionId", valid_569323
  var valid_569324 = path.getOrDefault("targetRegion")
  valid_569324 = validateParameter(valid_569324, JString, required = true,
                                 default = nil)
  if valid_569324 != nil:
    section.add "targetRegion", valid_569324
  var valid_569325 = path.getOrDefault("accountName")
  valid_569325 = validateParameter(valid_569325, JString, required = true,
                                 default = nil)
  if valid_569325 != nil:
    section.add "accountName", valid_569325
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569326 = query.getOrDefault("api-version")
  valid_569326 = validateParameter(valid_569326, JString, required = true,
                                 default = nil)
  if valid_569326 != nil:
    section.add "api-version", valid_569326
  var valid_569327 = query.getOrDefault("$filter")
  valid_569327 = validateParameter(valid_569327, JString, required = true,
                                 default = nil)
  if valid_569327 != nil:
    section.add "$filter", valid_569327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569328: Call_PercentileTargetListMetrics_569319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given account target region. This url is only for PBS and Replication Latency data
  ## 
  let valid = call_569328.validator(path, query, header, formData, body)
  let scheme = call_569328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569328.url(scheme.get, call_569328.host, call_569328.base,
                         call_569328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569328, url, valid)

proc call*(call_569329: Call_PercentileTargetListMetrics_569319;
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
  var path_569330 = newJObject()
  var query_569331 = newJObject()
  add(path_569330, "resourceGroupName", newJString(resourceGroupName))
  add(query_569331, "api-version", newJString(apiVersion))
  add(path_569330, "subscriptionId", newJString(subscriptionId))
  add(path_569330, "targetRegion", newJString(targetRegion))
  add(path_569330, "accountName", newJString(accountName))
  add(query_569331, "$filter", newJString(Filter))
  result = call_569329.call(path_569330, query_569331, nil, nil, nil)

var percentileTargetListMetrics* = Call_PercentileTargetListMetrics_569319(
    name: "percentileTargetListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/targetRegion/{targetRegion}/percentile/metrics",
    validator: validate_PercentileTargetListMetrics_569320, base: "",
    url: url_PercentileTargetListMetrics_569321, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListUsages_569332 = ref object of OpenApiRestCall_567668
proc url_DatabaseAccountsListUsages_569334(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListUsages_569333(path: JsonNode; query: JsonNode;
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
  var valid_569335 = path.getOrDefault("resourceGroupName")
  valid_569335 = validateParameter(valid_569335, JString, required = true,
                                 default = nil)
  if valid_569335 != nil:
    section.add "resourceGroupName", valid_569335
  var valid_569336 = path.getOrDefault("subscriptionId")
  valid_569336 = validateParameter(valid_569336, JString, required = true,
                                 default = nil)
  if valid_569336 != nil:
    section.add "subscriptionId", valid_569336
  var valid_569337 = path.getOrDefault("accountName")
  valid_569337 = validateParameter(valid_569337, JString, required = true,
                                 default = nil)
  if valid_569337 != nil:
    section.add "accountName", valid_569337
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString
  ##          : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569338 = query.getOrDefault("api-version")
  valid_569338 = validateParameter(valid_569338, JString, required = true,
                                 default = nil)
  if valid_569338 != nil:
    section.add "api-version", valid_569338
  var valid_569339 = query.getOrDefault("$filter")
  valid_569339 = validateParameter(valid_569339, JString, required = false,
                                 default = nil)
  if valid_569339 != nil:
    section.add "$filter", valid_569339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569340: Call_DatabaseAccountsListUsages_569332; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the usages (most recent data) for the given database account.
  ## 
  let valid = call_569340.validator(path, query, header, formData, body)
  let scheme = call_569340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569340.url(scheme.get, call_569340.host, call_569340.base,
                         call_569340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569340, url, valid)

proc call*(call_569341: Call_DatabaseAccountsListUsages_569332;
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
  var path_569342 = newJObject()
  var query_569343 = newJObject()
  add(path_569342, "resourceGroupName", newJString(resourceGroupName))
  add(query_569343, "api-version", newJString(apiVersion))
  add(path_569342, "subscriptionId", newJString(subscriptionId))
  add(path_569342, "accountName", newJString(accountName))
  add(query_569343, "$filter", newJString(Filter))
  result = call_569341.call(path_569342, query_569343, nil, nil, nil)

var databaseAccountsListUsages* = Call_DatabaseAccountsListUsages_569332(
    name: "databaseAccountsListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/usages",
    validator: validate_DatabaseAccountsListUsages_569333, base: "",
    url: url_DatabaseAccountsListUsages_569334, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
