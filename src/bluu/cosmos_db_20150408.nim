
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593439 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593439](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593439): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_DatabaseAccountsCheckNameExists_593661 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsCheckNameExists_593663(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsCheckNameExists_593662(path: JsonNode;
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
  var valid_593836 = path.getOrDefault("accountName")
  valid_593836 = validateParameter(valid_593836, JString, required = true,
                                 default = nil)
  if valid_593836 != nil:
    section.add "accountName", valid_593836
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593837 = query.getOrDefault("api-version")
  valid_593837 = validateParameter(valid_593837, JString, required = true,
                                 default = nil)
  if valid_593837 != nil:
    section.add "api-version", valid_593837
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593860: Call_DatabaseAccountsCheckNameExists_593661;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks that the Azure Cosmos DB account name already exists. A valid account name may contain only lowercase letters, numbers, and the '-' character, and must be between 3 and 50 characters.
  ## 
  let valid = call_593860.validator(path, query, header, formData, body)
  let scheme = call_593860.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593860.url(scheme.get, call_593860.host, call_593860.base,
                         call_593860.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593860, url, valid)

proc call*(call_593931: Call_DatabaseAccountsCheckNameExists_593661;
          apiVersion: string; accountName: string): Recallable =
  ## databaseAccountsCheckNameExists
  ## Checks that the Azure Cosmos DB account name already exists. A valid account name may contain only lowercase letters, numbers, and the '-' character, and must be between 3 and 50 characters.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   accountName: string (required)
  ##              : Cosmos DB database account name.
  var path_593932 = newJObject()
  var query_593934 = newJObject()
  add(query_593934, "api-version", newJString(apiVersion))
  add(path_593932, "accountName", newJString(accountName))
  result = call_593931.call(path_593932, query_593934, nil, nil, nil)

var databaseAccountsCheckNameExists* = Call_DatabaseAccountsCheckNameExists_593661(
    name: "databaseAccountsCheckNameExists", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/providers/Microsoft.DocumentDB/databaseAccountNames/{accountName}",
    validator: validate_DatabaseAccountsCheckNameExists_593662, base: "",
    url: url_DatabaseAccountsCheckNameExists_593663, schemes: {Scheme.Https})
type
  Call_OperationsList_593973 = ref object of OpenApiRestCall_593439
proc url_OperationsList_593975(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593974(path: JsonNode; query: JsonNode;
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
  var valid_593976 = query.getOrDefault("api-version")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "api-version", valid_593976
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593977: Call_OperationsList_593973; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Cosmos DB Resource Provider operations.
  ## 
  let valid = call_593977.validator(path, query, header, formData, body)
  let scheme = call_593977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593977.url(scheme.get, call_593977.host, call_593977.base,
                         call_593977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593977, url, valid)

proc call*(call_593978: Call_OperationsList_593973; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Cosmos DB Resource Provider operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  var query_593979 = newJObject()
  add(query_593979, "api-version", newJString(apiVersion))
  result = call_593978.call(nil, query_593979, nil, nil, nil)

var operationsList* = Call_OperationsList_593973(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DocumentDB/operations",
    validator: validate_OperationsList_593974, base: "", url: url_OperationsList_593975,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsList_593980 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsList_593982(protocol: Scheme; host: string; base: string;
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

proc validate_DatabaseAccountsList_593981(path: JsonNode; query: JsonNode;
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
  var valid_593983 = path.getOrDefault("subscriptionId")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "subscriptionId", valid_593983
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593984 = query.getOrDefault("api-version")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "api-version", valid_593984
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593985: Call_DatabaseAccountsList_593980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the Azure Cosmos DB database accounts available under the subscription.
  ## 
  let valid = call_593985.validator(path, query, header, formData, body)
  let scheme = call_593985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593985.url(scheme.get, call_593985.host, call_593985.base,
                         call_593985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593985, url, valid)

proc call*(call_593986: Call_DatabaseAccountsList_593980; apiVersion: string;
          subscriptionId: string): Recallable =
  ## databaseAccountsList
  ## Lists all the Azure Cosmos DB database accounts available under the subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  var path_593987 = newJObject()
  var query_593988 = newJObject()
  add(query_593988, "api-version", newJString(apiVersion))
  add(path_593987, "subscriptionId", newJString(subscriptionId))
  result = call_593986.call(path_593987, query_593988, nil, nil, nil)

var databaseAccountsList* = Call_DatabaseAccountsList_593980(
    name: "databaseAccountsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DocumentDB/databaseAccounts",
    validator: validate_DatabaseAccountsList_593981, base: "",
    url: url_DatabaseAccountsList_593982, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListByResourceGroup_593989 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsListByResourceGroup_593991(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListByResourceGroup_593990(path: JsonNode;
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
  var valid_593992 = path.getOrDefault("resourceGroupName")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "resourceGroupName", valid_593992
  var valid_593993 = path.getOrDefault("subscriptionId")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "subscriptionId", valid_593993
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593994 = query.getOrDefault("api-version")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "api-version", valid_593994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593995: Call_DatabaseAccountsListByResourceGroup_593989;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the Azure Cosmos DB database accounts available under the given resource group.
  ## 
  let valid = call_593995.validator(path, query, header, formData, body)
  let scheme = call_593995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593995.url(scheme.get, call_593995.host, call_593995.base,
                         call_593995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593995, url, valid)

proc call*(call_593996: Call_DatabaseAccountsListByResourceGroup_593989;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## databaseAccountsListByResourceGroup
  ## Lists all the Azure Cosmos DB database accounts available under the given resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  var path_593997 = newJObject()
  var query_593998 = newJObject()
  add(path_593997, "resourceGroupName", newJString(resourceGroupName))
  add(query_593998, "api-version", newJString(apiVersion))
  add(path_593997, "subscriptionId", newJString(subscriptionId))
  result = call_593996.call(path_593997, query_593998, nil, nil, nil)

var databaseAccountsListByResourceGroup* = Call_DatabaseAccountsListByResourceGroup_593989(
    name: "databaseAccountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts",
    validator: validate_DatabaseAccountsListByResourceGroup_593990, base: "",
    url: url_DatabaseAccountsListByResourceGroup_593991, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateOrUpdate_594010 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsCreateOrUpdate_594012(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsCreateOrUpdate_594011(path: JsonNode;
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
  var valid_594013 = path.getOrDefault("resourceGroupName")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "resourceGroupName", valid_594013
  var valid_594014 = path.getOrDefault("subscriptionId")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "subscriptionId", valid_594014
  var valid_594015 = path.getOrDefault("accountName")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "accountName", valid_594015
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594016 = query.getOrDefault("api-version")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "api-version", valid_594016
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

proc call*(call_594018: Call_DatabaseAccountsCreateOrUpdate_594010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an Azure Cosmos DB database account.
  ## 
  let valid = call_594018.validator(path, query, header, formData, body)
  let scheme = call_594018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594018.url(scheme.get, call_594018.host, call_594018.base,
                         call_594018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594018, url, valid)

proc call*(call_594019: Call_DatabaseAccountsCreateOrUpdate_594010;
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
  var path_594020 = newJObject()
  var query_594021 = newJObject()
  var body_594022 = newJObject()
  add(path_594020, "resourceGroupName", newJString(resourceGroupName))
  add(query_594021, "api-version", newJString(apiVersion))
  if createUpdateParameters != nil:
    body_594022 = createUpdateParameters
  add(path_594020, "subscriptionId", newJString(subscriptionId))
  add(path_594020, "accountName", newJString(accountName))
  result = call_594019.call(path_594020, query_594021, nil, nil, body_594022)

var databaseAccountsCreateOrUpdate* = Call_DatabaseAccountsCreateOrUpdate_594010(
    name: "databaseAccountsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}",
    validator: validate_DatabaseAccountsCreateOrUpdate_594011, base: "",
    url: url_DatabaseAccountsCreateOrUpdate_594012, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGet_593999 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsGet_594001(protocol: Scheme; host: string; base: string;
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

proc validate_DatabaseAccountsGet_594000(path: JsonNode; query: JsonNode;
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
  var valid_594002 = path.getOrDefault("resourceGroupName")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "resourceGroupName", valid_594002
  var valid_594003 = path.getOrDefault("subscriptionId")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "subscriptionId", valid_594003
  var valid_594004 = path.getOrDefault("accountName")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "accountName", valid_594004
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594005 = query.getOrDefault("api-version")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "api-version", valid_594005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594006: Call_DatabaseAccountsGet_593999; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the properties of an existing Azure Cosmos DB database account.
  ## 
  let valid = call_594006.validator(path, query, header, formData, body)
  let scheme = call_594006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594006.url(scheme.get, call_594006.host, call_594006.base,
                         call_594006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594006, url, valid)

proc call*(call_594007: Call_DatabaseAccountsGet_593999; resourceGroupName: string;
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
  var path_594008 = newJObject()
  var query_594009 = newJObject()
  add(path_594008, "resourceGroupName", newJString(resourceGroupName))
  add(query_594009, "api-version", newJString(apiVersion))
  add(path_594008, "subscriptionId", newJString(subscriptionId))
  add(path_594008, "accountName", newJString(accountName))
  result = call_594007.call(path_594008, query_594009, nil, nil, nil)

var databaseAccountsGet* = Call_DatabaseAccountsGet_593999(
    name: "databaseAccountsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}",
    validator: validate_DatabaseAccountsGet_594000, base: "",
    url: url_DatabaseAccountsGet_594001, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsPatch_594034 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsPatch_594036(protocol: Scheme; host: string; base: string;
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

proc validate_DatabaseAccountsPatch_594035(path: JsonNode; query: JsonNode;
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
  var valid_594037 = path.getOrDefault("resourceGroupName")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "resourceGroupName", valid_594037
  var valid_594038 = path.getOrDefault("subscriptionId")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "subscriptionId", valid_594038
  var valid_594039 = path.getOrDefault("accountName")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "accountName", valid_594039
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594040 = query.getOrDefault("api-version")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "api-version", valid_594040
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

proc call*(call_594042: Call_DatabaseAccountsPatch_594034; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patches the properties of an existing Azure Cosmos DB database account.
  ## 
  let valid = call_594042.validator(path, query, header, formData, body)
  let scheme = call_594042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594042.url(scheme.get, call_594042.host, call_594042.base,
                         call_594042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594042, url, valid)

proc call*(call_594043: Call_DatabaseAccountsPatch_594034;
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
  var path_594044 = newJObject()
  var query_594045 = newJObject()
  var body_594046 = newJObject()
  add(path_594044, "resourceGroupName", newJString(resourceGroupName))
  add(query_594045, "api-version", newJString(apiVersion))
  add(path_594044, "subscriptionId", newJString(subscriptionId))
  if updateParameters != nil:
    body_594046 = updateParameters
  add(path_594044, "accountName", newJString(accountName))
  result = call_594043.call(path_594044, query_594045, nil, nil, body_594046)

var databaseAccountsPatch* = Call_DatabaseAccountsPatch_594034(
    name: "databaseAccountsPatch", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}",
    validator: validate_DatabaseAccountsPatch_594035, base: "",
    url: url_DatabaseAccountsPatch_594036, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDelete_594023 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsDelete_594025(protocol: Scheme; host: string; base: string;
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

proc validate_DatabaseAccountsDelete_594024(path: JsonNode; query: JsonNode;
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
  var valid_594026 = path.getOrDefault("resourceGroupName")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "resourceGroupName", valid_594026
  var valid_594027 = path.getOrDefault("subscriptionId")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "subscriptionId", valid_594027
  var valid_594028 = path.getOrDefault("accountName")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "accountName", valid_594028
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594029 = query.getOrDefault("api-version")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "api-version", valid_594029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594030: Call_DatabaseAccountsDelete_594023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB database account.
  ## 
  let valid = call_594030.validator(path, query, header, formData, body)
  let scheme = call_594030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594030.url(scheme.get, call_594030.host, call_594030.base,
                         call_594030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594030, url, valid)

proc call*(call_594031: Call_DatabaseAccountsDelete_594023;
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
  var path_594032 = newJObject()
  var query_594033 = newJObject()
  add(path_594032, "resourceGroupName", newJString(resourceGroupName))
  add(query_594033, "api-version", newJString(apiVersion))
  add(path_594032, "subscriptionId", newJString(subscriptionId))
  add(path_594032, "accountName", newJString(accountName))
  result = call_594031.call(path_594032, query_594033, nil, nil, nil)

var databaseAccountsDelete* = Call_DatabaseAccountsDelete_594023(
    name: "databaseAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}",
    validator: validate_DatabaseAccountsDelete_594024, base: "",
    url: url_DatabaseAccountsDelete_594025, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListCassandraKeyspaces_594047 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsListCassandraKeyspaces_594049(protocol: Scheme;
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

proc validate_DatabaseAccountsListCassandraKeyspaces_594048(path: JsonNode;
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
  var valid_594050 = path.getOrDefault("resourceGroupName")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "resourceGroupName", valid_594050
  var valid_594051 = path.getOrDefault("subscriptionId")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "subscriptionId", valid_594051
  var valid_594052 = path.getOrDefault("accountName")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "accountName", valid_594052
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594053 = query.getOrDefault("api-version")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "api-version", valid_594053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594054: Call_DatabaseAccountsListCassandraKeyspaces_594047;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Cassandra keyspaces under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_594054.validator(path, query, header, formData, body)
  let scheme = call_594054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594054.url(scheme.get, call_594054.host, call_594054.base,
                         call_594054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594054, url, valid)

proc call*(call_594055: Call_DatabaseAccountsListCassandraKeyspaces_594047;
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
  var path_594056 = newJObject()
  var query_594057 = newJObject()
  add(path_594056, "resourceGroupName", newJString(resourceGroupName))
  add(query_594057, "api-version", newJString(apiVersion))
  add(path_594056, "subscriptionId", newJString(subscriptionId))
  add(path_594056, "accountName", newJString(accountName))
  result = call_594055.call(path_594056, query_594057, nil, nil, nil)

var databaseAccountsListCassandraKeyspaces* = Call_DatabaseAccountsListCassandraKeyspaces_594047(
    name: "databaseAccountsListCassandraKeyspaces", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces",
    validator: validate_DatabaseAccountsListCassandraKeyspaces_594048, base: "",
    url: url_DatabaseAccountsListCassandraKeyspaces_594049,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateCassandraKeyspace_594070 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsCreateUpdateCassandraKeyspace_594072(protocol: Scheme;
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

proc validate_DatabaseAccountsCreateUpdateCassandraKeyspace_594071(
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
  var valid_594073 = path.getOrDefault("resourceGroupName")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "resourceGroupName", valid_594073
  var valid_594074 = path.getOrDefault("keyspaceName")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "keyspaceName", valid_594074
  var valid_594075 = path.getOrDefault("subscriptionId")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "subscriptionId", valid_594075
  var valid_594076 = path.getOrDefault("accountName")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "accountName", valid_594076
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594077 = query.getOrDefault("api-version")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "api-version", valid_594077
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

proc call*(call_594079: Call_DatabaseAccountsCreateUpdateCassandraKeyspace_594070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB Cassandra keyspace
  ## 
  let valid = call_594079.validator(path, query, header, formData, body)
  let scheme = call_594079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594079.url(scheme.get, call_594079.host, call_594079.base,
                         call_594079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594079, url, valid)

proc call*(call_594080: Call_DatabaseAccountsCreateUpdateCassandraKeyspace_594070;
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
  var path_594081 = newJObject()
  var query_594082 = newJObject()
  var body_594083 = newJObject()
  add(path_594081, "resourceGroupName", newJString(resourceGroupName))
  add(query_594082, "api-version", newJString(apiVersion))
  if createUpdateCassandraKeyspaceParameters != nil:
    body_594083 = createUpdateCassandraKeyspaceParameters
  add(path_594081, "keyspaceName", newJString(keyspaceName))
  add(path_594081, "subscriptionId", newJString(subscriptionId))
  add(path_594081, "accountName", newJString(accountName))
  result = call_594080.call(path_594081, query_594082, nil, nil, body_594083)

var databaseAccountsCreateUpdateCassandraKeyspace* = Call_DatabaseAccountsCreateUpdateCassandraKeyspace_594070(
    name: "databaseAccountsCreateUpdateCassandraKeyspace",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}",
    validator: validate_DatabaseAccountsCreateUpdateCassandraKeyspace_594071,
    base: "", url: url_DatabaseAccountsCreateUpdateCassandraKeyspace_594072,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetCassandraKeyspace_594058 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsGetCassandraKeyspace_594060(protocol: Scheme;
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

proc validate_DatabaseAccountsGetCassandraKeyspace_594059(path: JsonNode;
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
  var valid_594061 = path.getOrDefault("resourceGroupName")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "resourceGroupName", valid_594061
  var valid_594062 = path.getOrDefault("keyspaceName")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "keyspaceName", valid_594062
  var valid_594063 = path.getOrDefault("subscriptionId")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "subscriptionId", valid_594063
  var valid_594064 = path.getOrDefault("accountName")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "accountName", valid_594064
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594065 = query.getOrDefault("api-version")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "api-version", valid_594065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594066: Call_DatabaseAccountsGetCassandraKeyspace_594058;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the Cassandra keyspaces under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_594066.validator(path, query, header, formData, body)
  let scheme = call_594066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594066.url(scheme.get, call_594066.host, call_594066.base,
                         call_594066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594066, url, valid)

proc call*(call_594067: Call_DatabaseAccountsGetCassandraKeyspace_594058;
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
  var path_594068 = newJObject()
  var query_594069 = newJObject()
  add(path_594068, "resourceGroupName", newJString(resourceGroupName))
  add(query_594069, "api-version", newJString(apiVersion))
  add(path_594068, "keyspaceName", newJString(keyspaceName))
  add(path_594068, "subscriptionId", newJString(subscriptionId))
  add(path_594068, "accountName", newJString(accountName))
  result = call_594067.call(path_594068, query_594069, nil, nil, nil)

var databaseAccountsGetCassandraKeyspace* = Call_DatabaseAccountsGetCassandraKeyspace_594058(
    name: "databaseAccountsGetCassandraKeyspace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}",
    validator: validate_DatabaseAccountsGetCassandraKeyspace_594059, base: "",
    url: url_DatabaseAccountsGetCassandraKeyspace_594060, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteCassandraKeyspace_594084 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsDeleteCassandraKeyspace_594086(protocol: Scheme;
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

proc validate_DatabaseAccountsDeleteCassandraKeyspace_594085(path: JsonNode;
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
  var valid_594087 = path.getOrDefault("resourceGroupName")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "resourceGroupName", valid_594087
  var valid_594088 = path.getOrDefault("keyspaceName")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "keyspaceName", valid_594088
  var valid_594089 = path.getOrDefault("subscriptionId")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "subscriptionId", valid_594089
  var valid_594090 = path.getOrDefault("accountName")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "accountName", valid_594090
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594091 = query.getOrDefault("api-version")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "api-version", valid_594091
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594092: Call_DatabaseAccountsDeleteCassandraKeyspace_594084;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB Cassandra keyspace.
  ## 
  let valid = call_594092.validator(path, query, header, formData, body)
  let scheme = call_594092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594092.url(scheme.get, call_594092.host, call_594092.base,
                         call_594092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594092, url, valid)

proc call*(call_594093: Call_DatabaseAccountsDeleteCassandraKeyspace_594084;
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
  var path_594094 = newJObject()
  var query_594095 = newJObject()
  add(path_594094, "resourceGroupName", newJString(resourceGroupName))
  add(query_594095, "api-version", newJString(apiVersion))
  add(path_594094, "keyspaceName", newJString(keyspaceName))
  add(path_594094, "subscriptionId", newJString(subscriptionId))
  add(path_594094, "accountName", newJString(accountName))
  result = call_594093.call(path_594094, query_594095, nil, nil, nil)

var databaseAccountsDeleteCassandraKeyspace* = Call_DatabaseAccountsDeleteCassandraKeyspace_594084(
    name: "databaseAccountsDeleteCassandraKeyspace", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}",
    validator: validate_DatabaseAccountsDeleteCassandraKeyspace_594085, base: "",
    url: url_DatabaseAccountsDeleteCassandraKeyspace_594086,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateCassandraKeyspaceThroughput_594108 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsUpdateCassandraKeyspaceThroughput_594110(
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

proc validate_DatabaseAccountsUpdateCassandraKeyspaceThroughput_594109(
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
  var valid_594111 = path.getOrDefault("resourceGroupName")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "resourceGroupName", valid_594111
  var valid_594112 = path.getOrDefault("keyspaceName")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "keyspaceName", valid_594112
  var valid_594113 = path.getOrDefault("subscriptionId")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "subscriptionId", valid_594113
  var valid_594114 = path.getOrDefault("accountName")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "accountName", valid_594114
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594115 = query.getOrDefault("api-version")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "api-version", valid_594115
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

proc call*(call_594117: Call_DatabaseAccountsUpdateCassandraKeyspaceThroughput_594108;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Cassandra Keyspace
  ## 
  let valid = call_594117.validator(path, query, header, formData, body)
  let scheme = call_594117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594117.url(scheme.get, call_594117.host, call_594117.base,
                         call_594117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594117, url, valid)

proc call*(call_594118: Call_DatabaseAccountsUpdateCassandraKeyspaceThroughput_594108;
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
  var path_594119 = newJObject()
  var query_594120 = newJObject()
  var body_594121 = newJObject()
  add(path_594119, "resourceGroupName", newJString(resourceGroupName))
  add(query_594120, "api-version", newJString(apiVersion))
  add(path_594119, "keyspaceName", newJString(keyspaceName))
  add(path_594119, "subscriptionId", newJString(subscriptionId))
  if updateThroughputParameters != nil:
    body_594121 = updateThroughputParameters
  add(path_594119, "accountName", newJString(accountName))
  result = call_594118.call(path_594119, query_594120, nil, nil, body_594121)

var databaseAccountsUpdateCassandraKeyspaceThroughput* = Call_DatabaseAccountsUpdateCassandraKeyspaceThroughput_594108(
    name: "databaseAccountsUpdateCassandraKeyspaceThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateCassandraKeyspaceThroughput_594109,
    base: "", url: url_DatabaseAccountsUpdateCassandraKeyspaceThroughput_594110,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetCassandraKeyspaceThroughput_594096 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsGetCassandraKeyspaceThroughput_594098(protocol: Scheme;
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

proc validate_DatabaseAccountsGetCassandraKeyspaceThroughput_594097(
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
  var valid_594099 = path.getOrDefault("resourceGroupName")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "resourceGroupName", valid_594099
  var valid_594100 = path.getOrDefault("keyspaceName")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "keyspaceName", valid_594100
  var valid_594101 = path.getOrDefault("subscriptionId")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "subscriptionId", valid_594101
  var valid_594102 = path.getOrDefault("accountName")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "accountName", valid_594102
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594103 = query.getOrDefault("api-version")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "api-version", valid_594103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594104: Call_DatabaseAccountsGetCassandraKeyspaceThroughput_594096;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the Cassandra Keyspace under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_594104.validator(path, query, header, formData, body)
  let scheme = call_594104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594104.url(scheme.get, call_594104.host, call_594104.base,
                         call_594104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594104, url, valid)

proc call*(call_594105: Call_DatabaseAccountsGetCassandraKeyspaceThroughput_594096;
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
  var path_594106 = newJObject()
  var query_594107 = newJObject()
  add(path_594106, "resourceGroupName", newJString(resourceGroupName))
  add(query_594107, "api-version", newJString(apiVersion))
  add(path_594106, "keyspaceName", newJString(keyspaceName))
  add(path_594106, "subscriptionId", newJString(subscriptionId))
  add(path_594106, "accountName", newJString(accountName))
  result = call_594105.call(path_594106, query_594107, nil, nil, nil)

var databaseAccountsGetCassandraKeyspaceThroughput* = Call_DatabaseAccountsGetCassandraKeyspaceThroughput_594096(
    name: "databaseAccountsGetCassandraKeyspaceThroughput",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/settings/throughput",
    validator: validate_DatabaseAccountsGetCassandraKeyspaceThroughput_594097,
    base: "", url: url_DatabaseAccountsGetCassandraKeyspaceThroughput_594098,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListCassandraTables_594122 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsListCassandraTables_594124(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListCassandraTables_594123(path: JsonNode;
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
  var valid_594125 = path.getOrDefault("resourceGroupName")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "resourceGroupName", valid_594125
  var valid_594126 = path.getOrDefault("keyspaceName")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "keyspaceName", valid_594126
  var valid_594127 = path.getOrDefault("subscriptionId")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "subscriptionId", valid_594127
  var valid_594128 = path.getOrDefault("accountName")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "accountName", valid_594128
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594129 = query.getOrDefault("api-version")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "api-version", valid_594129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594130: Call_DatabaseAccountsListCassandraTables_594122;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Cassandra table under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_594130.validator(path, query, header, formData, body)
  let scheme = call_594130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594130.url(scheme.get, call_594130.host, call_594130.base,
                         call_594130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594130, url, valid)

proc call*(call_594131: Call_DatabaseAccountsListCassandraTables_594122;
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
  var path_594132 = newJObject()
  var query_594133 = newJObject()
  add(path_594132, "resourceGroupName", newJString(resourceGroupName))
  add(query_594133, "api-version", newJString(apiVersion))
  add(path_594132, "keyspaceName", newJString(keyspaceName))
  add(path_594132, "subscriptionId", newJString(subscriptionId))
  add(path_594132, "accountName", newJString(accountName))
  result = call_594131.call(path_594132, query_594133, nil, nil, nil)

var databaseAccountsListCassandraTables* = Call_DatabaseAccountsListCassandraTables_594122(
    name: "databaseAccountsListCassandraTables", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/tables",
    validator: validate_DatabaseAccountsListCassandraTables_594123, base: "",
    url: url_DatabaseAccountsListCassandraTables_594124, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateCassandraTable_594147 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsCreateUpdateCassandraTable_594149(protocol: Scheme;
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

proc validate_DatabaseAccountsCreateUpdateCassandraTable_594148(path: JsonNode;
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
  var valid_594150 = path.getOrDefault("resourceGroupName")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "resourceGroupName", valid_594150
  var valid_594151 = path.getOrDefault("keyspaceName")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "keyspaceName", valid_594151
  var valid_594152 = path.getOrDefault("subscriptionId")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "subscriptionId", valid_594152
  var valid_594153 = path.getOrDefault("tableName")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "tableName", valid_594153
  var valid_594154 = path.getOrDefault("accountName")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "accountName", valid_594154
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594155 = query.getOrDefault("api-version")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "api-version", valid_594155
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

proc call*(call_594157: Call_DatabaseAccountsCreateUpdateCassandraTable_594147;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB Cassandra Table
  ## 
  let valid = call_594157.validator(path, query, header, formData, body)
  let scheme = call_594157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594157.url(scheme.get, call_594157.host, call_594157.base,
                         call_594157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594157, url, valid)

proc call*(call_594158: Call_DatabaseAccountsCreateUpdateCassandraTable_594147;
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
  var path_594159 = newJObject()
  var query_594160 = newJObject()
  var body_594161 = newJObject()
  add(path_594159, "resourceGroupName", newJString(resourceGroupName))
  add(query_594160, "api-version", newJString(apiVersion))
  add(path_594159, "keyspaceName", newJString(keyspaceName))
  add(path_594159, "subscriptionId", newJString(subscriptionId))
  add(path_594159, "tableName", newJString(tableName))
  if createUpdateCassandraTableParameters != nil:
    body_594161 = createUpdateCassandraTableParameters
  add(path_594159, "accountName", newJString(accountName))
  result = call_594158.call(path_594159, query_594160, nil, nil, body_594161)

var databaseAccountsCreateUpdateCassandraTable* = Call_DatabaseAccountsCreateUpdateCassandraTable_594147(
    name: "databaseAccountsCreateUpdateCassandraTable", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/tables/{tableName}",
    validator: validate_DatabaseAccountsCreateUpdateCassandraTable_594148,
    base: "", url: url_DatabaseAccountsCreateUpdateCassandraTable_594149,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetCassandraTable_594134 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsGetCassandraTable_594136(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsGetCassandraTable_594135(path: JsonNode;
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
  var valid_594137 = path.getOrDefault("resourceGroupName")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = nil)
  if valid_594137 != nil:
    section.add "resourceGroupName", valid_594137
  var valid_594138 = path.getOrDefault("keyspaceName")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "keyspaceName", valid_594138
  var valid_594139 = path.getOrDefault("subscriptionId")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "subscriptionId", valid_594139
  var valid_594140 = path.getOrDefault("tableName")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "tableName", valid_594140
  var valid_594141 = path.getOrDefault("accountName")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "accountName", valid_594141
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594142 = query.getOrDefault("api-version")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "api-version", valid_594142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594143: Call_DatabaseAccountsGetCassandraTable_594134;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the Cassandra table under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_594143.validator(path, query, header, formData, body)
  let scheme = call_594143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594143.url(scheme.get, call_594143.host, call_594143.base,
                         call_594143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594143, url, valid)

proc call*(call_594144: Call_DatabaseAccountsGetCassandraTable_594134;
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
  var path_594145 = newJObject()
  var query_594146 = newJObject()
  add(path_594145, "resourceGroupName", newJString(resourceGroupName))
  add(query_594146, "api-version", newJString(apiVersion))
  add(path_594145, "keyspaceName", newJString(keyspaceName))
  add(path_594145, "subscriptionId", newJString(subscriptionId))
  add(path_594145, "tableName", newJString(tableName))
  add(path_594145, "accountName", newJString(accountName))
  result = call_594144.call(path_594145, query_594146, nil, nil, nil)

var databaseAccountsGetCassandraTable* = Call_DatabaseAccountsGetCassandraTable_594134(
    name: "databaseAccountsGetCassandraTable", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/tables/{tableName}",
    validator: validate_DatabaseAccountsGetCassandraTable_594135, base: "",
    url: url_DatabaseAccountsGetCassandraTable_594136, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteCassandraTable_594162 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsDeleteCassandraTable_594164(protocol: Scheme;
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

proc validate_DatabaseAccountsDeleteCassandraTable_594163(path: JsonNode;
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
  var valid_594165 = path.getOrDefault("resourceGroupName")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = nil)
  if valid_594165 != nil:
    section.add "resourceGroupName", valid_594165
  var valid_594166 = path.getOrDefault("keyspaceName")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "keyspaceName", valid_594166
  var valid_594167 = path.getOrDefault("subscriptionId")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "subscriptionId", valid_594167
  var valid_594168 = path.getOrDefault("tableName")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "tableName", valid_594168
  var valid_594169 = path.getOrDefault("accountName")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "accountName", valid_594169
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594170 = query.getOrDefault("api-version")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "api-version", valid_594170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594171: Call_DatabaseAccountsDeleteCassandraTable_594162;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB Cassandra table.
  ## 
  let valid = call_594171.validator(path, query, header, formData, body)
  let scheme = call_594171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594171.url(scheme.get, call_594171.host, call_594171.base,
                         call_594171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594171, url, valid)

proc call*(call_594172: Call_DatabaseAccountsDeleteCassandraTable_594162;
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
  var path_594173 = newJObject()
  var query_594174 = newJObject()
  add(path_594173, "resourceGroupName", newJString(resourceGroupName))
  add(query_594174, "api-version", newJString(apiVersion))
  add(path_594173, "keyspaceName", newJString(keyspaceName))
  add(path_594173, "subscriptionId", newJString(subscriptionId))
  add(path_594173, "tableName", newJString(tableName))
  add(path_594173, "accountName", newJString(accountName))
  result = call_594172.call(path_594173, query_594174, nil, nil, nil)

var databaseAccountsDeleteCassandraTable* = Call_DatabaseAccountsDeleteCassandraTable_594162(
    name: "databaseAccountsDeleteCassandraTable", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/tables/{tableName}",
    validator: validate_DatabaseAccountsDeleteCassandraTable_594163, base: "",
    url: url_DatabaseAccountsDeleteCassandraTable_594164, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateCassandraTableThroughput_594188 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsUpdateCassandraTableThroughput_594190(protocol: Scheme;
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

proc validate_DatabaseAccountsUpdateCassandraTableThroughput_594189(
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
  var valid_594191 = path.getOrDefault("resourceGroupName")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "resourceGroupName", valid_594191
  var valid_594192 = path.getOrDefault("keyspaceName")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "keyspaceName", valid_594192
  var valid_594193 = path.getOrDefault("subscriptionId")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "subscriptionId", valid_594193
  var valid_594194 = path.getOrDefault("tableName")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "tableName", valid_594194
  var valid_594195 = path.getOrDefault("accountName")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "accountName", valid_594195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594196 = query.getOrDefault("api-version")
  valid_594196 = validateParameter(valid_594196, JString, required = true,
                                 default = nil)
  if valid_594196 != nil:
    section.add "api-version", valid_594196
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

proc call*(call_594198: Call_DatabaseAccountsUpdateCassandraTableThroughput_594188;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Cassandra table
  ## 
  let valid = call_594198.validator(path, query, header, formData, body)
  let scheme = call_594198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594198.url(scheme.get, call_594198.host, call_594198.base,
                         call_594198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594198, url, valid)

proc call*(call_594199: Call_DatabaseAccountsUpdateCassandraTableThroughput_594188;
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
  var path_594200 = newJObject()
  var query_594201 = newJObject()
  var body_594202 = newJObject()
  add(path_594200, "resourceGroupName", newJString(resourceGroupName))
  add(query_594201, "api-version", newJString(apiVersion))
  add(path_594200, "keyspaceName", newJString(keyspaceName))
  add(path_594200, "subscriptionId", newJString(subscriptionId))
  add(path_594200, "tableName", newJString(tableName))
  if updateThroughputParameters != nil:
    body_594202 = updateThroughputParameters
  add(path_594200, "accountName", newJString(accountName))
  result = call_594199.call(path_594200, query_594201, nil, nil, body_594202)

var databaseAccountsUpdateCassandraTableThroughput* = Call_DatabaseAccountsUpdateCassandraTableThroughput_594188(
    name: "databaseAccountsUpdateCassandraTableThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/tables/{tableName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateCassandraTableThroughput_594189,
    base: "", url: url_DatabaseAccountsUpdateCassandraTableThroughput_594190,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetCassandraTableThroughput_594175 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsGetCassandraTableThroughput_594177(protocol: Scheme;
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

proc validate_DatabaseAccountsGetCassandraTableThroughput_594176(path: JsonNode;
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
  var valid_594178 = path.getOrDefault("resourceGroupName")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "resourceGroupName", valid_594178
  var valid_594179 = path.getOrDefault("keyspaceName")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "keyspaceName", valid_594179
  var valid_594180 = path.getOrDefault("subscriptionId")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "subscriptionId", valid_594180
  var valid_594181 = path.getOrDefault("tableName")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "tableName", valid_594181
  var valid_594182 = path.getOrDefault("accountName")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "accountName", valid_594182
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594183 = query.getOrDefault("api-version")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "api-version", valid_594183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594184: Call_DatabaseAccountsGetCassandraTableThroughput_594175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the Cassandra table under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_594184.validator(path, query, header, formData, body)
  let scheme = call_594184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594184.url(scheme.get, call_594184.host, call_594184.base,
                         call_594184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594184, url, valid)

proc call*(call_594185: Call_DatabaseAccountsGetCassandraTableThroughput_594175;
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
  var path_594186 = newJObject()
  var query_594187 = newJObject()
  add(path_594186, "resourceGroupName", newJString(resourceGroupName))
  add(query_594187, "api-version", newJString(apiVersion))
  add(path_594186, "keyspaceName", newJString(keyspaceName))
  add(path_594186, "subscriptionId", newJString(subscriptionId))
  add(path_594186, "tableName", newJString(tableName))
  add(path_594186, "accountName", newJString(accountName))
  result = call_594185.call(path_594186, query_594187, nil, nil, nil)

var databaseAccountsGetCassandraTableThroughput* = Call_DatabaseAccountsGetCassandraTableThroughput_594175(
    name: "databaseAccountsGetCassandraTableThroughput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/cassandra/keyspaces/{keyspaceName}/tables/{tableName}/settings/throughput",
    validator: validate_DatabaseAccountsGetCassandraTableThroughput_594176,
    base: "", url: url_DatabaseAccountsGetCassandraTableThroughput_594177,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListGremlinDatabases_594203 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsListGremlinDatabases_594205(protocol: Scheme;
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

proc validate_DatabaseAccountsListGremlinDatabases_594204(path: JsonNode;
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
  var valid_594206 = path.getOrDefault("resourceGroupName")
  valid_594206 = validateParameter(valid_594206, JString, required = true,
                                 default = nil)
  if valid_594206 != nil:
    section.add "resourceGroupName", valid_594206
  var valid_594207 = path.getOrDefault("subscriptionId")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "subscriptionId", valid_594207
  var valid_594208 = path.getOrDefault("accountName")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "accountName", valid_594208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594209 = query.getOrDefault("api-version")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = nil)
  if valid_594209 != nil:
    section.add "api-version", valid_594209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594210: Call_DatabaseAccountsListGremlinDatabases_594203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Gremlin databases under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_594210.validator(path, query, header, formData, body)
  let scheme = call_594210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594210.url(scheme.get, call_594210.host, call_594210.base,
                         call_594210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594210, url, valid)

proc call*(call_594211: Call_DatabaseAccountsListGremlinDatabases_594203;
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
  var path_594212 = newJObject()
  var query_594213 = newJObject()
  add(path_594212, "resourceGroupName", newJString(resourceGroupName))
  add(query_594213, "api-version", newJString(apiVersion))
  add(path_594212, "subscriptionId", newJString(subscriptionId))
  add(path_594212, "accountName", newJString(accountName))
  result = call_594211.call(path_594212, query_594213, nil, nil, nil)

var databaseAccountsListGremlinDatabases* = Call_DatabaseAccountsListGremlinDatabases_594203(
    name: "databaseAccountsListGremlinDatabases", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases",
    validator: validate_DatabaseAccountsListGremlinDatabases_594204, base: "",
    url: url_DatabaseAccountsListGremlinDatabases_594205, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateGremlinDatabase_594226 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsCreateUpdateGremlinDatabase_594228(protocol: Scheme;
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

proc validate_DatabaseAccountsCreateUpdateGremlinDatabase_594227(path: JsonNode;
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
  var valid_594229 = path.getOrDefault("resourceGroupName")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "resourceGroupName", valid_594229
  var valid_594230 = path.getOrDefault("subscriptionId")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "subscriptionId", valid_594230
  var valid_594231 = path.getOrDefault("databaseName")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "databaseName", valid_594231
  var valid_594232 = path.getOrDefault("accountName")
  valid_594232 = validateParameter(valid_594232, JString, required = true,
                                 default = nil)
  if valid_594232 != nil:
    section.add "accountName", valid_594232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594233 = query.getOrDefault("api-version")
  valid_594233 = validateParameter(valid_594233, JString, required = true,
                                 default = nil)
  if valid_594233 != nil:
    section.add "api-version", valid_594233
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

proc call*(call_594235: Call_DatabaseAccountsCreateUpdateGremlinDatabase_594226;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB Gremlin database
  ## 
  let valid = call_594235.validator(path, query, header, formData, body)
  let scheme = call_594235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594235.url(scheme.get, call_594235.host, call_594235.base,
                         call_594235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594235, url, valid)

proc call*(call_594236: Call_DatabaseAccountsCreateUpdateGremlinDatabase_594226;
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
  var path_594237 = newJObject()
  var query_594238 = newJObject()
  var body_594239 = newJObject()
  add(path_594237, "resourceGroupName", newJString(resourceGroupName))
  add(query_594238, "api-version", newJString(apiVersion))
  add(path_594237, "subscriptionId", newJString(subscriptionId))
  if createUpdateGremlinDatabaseParameters != nil:
    body_594239 = createUpdateGremlinDatabaseParameters
  add(path_594237, "databaseName", newJString(databaseName))
  add(path_594237, "accountName", newJString(accountName))
  result = call_594236.call(path_594237, query_594238, nil, nil, body_594239)

var databaseAccountsCreateUpdateGremlinDatabase* = Call_DatabaseAccountsCreateUpdateGremlinDatabase_594226(
    name: "databaseAccountsCreateUpdateGremlinDatabase", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}",
    validator: validate_DatabaseAccountsCreateUpdateGremlinDatabase_594227,
    base: "", url: url_DatabaseAccountsCreateUpdateGremlinDatabase_594228,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetGremlinDatabase_594214 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsGetGremlinDatabase_594216(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsGetGremlinDatabase_594215(path: JsonNode;
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
  var valid_594217 = path.getOrDefault("resourceGroupName")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "resourceGroupName", valid_594217
  var valid_594218 = path.getOrDefault("subscriptionId")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "subscriptionId", valid_594218
  var valid_594219 = path.getOrDefault("databaseName")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = nil)
  if valid_594219 != nil:
    section.add "databaseName", valid_594219
  var valid_594220 = path.getOrDefault("accountName")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "accountName", valid_594220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594221 = query.getOrDefault("api-version")
  valid_594221 = validateParameter(valid_594221, JString, required = true,
                                 default = nil)
  if valid_594221 != nil:
    section.add "api-version", valid_594221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594222: Call_DatabaseAccountsGetGremlinDatabase_594214;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the Gremlin databases under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_594222.validator(path, query, header, formData, body)
  let scheme = call_594222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594222.url(scheme.get, call_594222.host, call_594222.base,
                         call_594222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594222, url, valid)

proc call*(call_594223: Call_DatabaseAccountsGetGremlinDatabase_594214;
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
  var path_594224 = newJObject()
  var query_594225 = newJObject()
  add(path_594224, "resourceGroupName", newJString(resourceGroupName))
  add(query_594225, "api-version", newJString(apiVersion))
  add(path_594224, "subscriptionId", newJString(subscriptionId))
  add(path_594224, "databaseName", newJString(databaseName))
  add(path_594224, "accountName", newJString(accountName))
  result = call_594223.call(path_594224, query_594225, nil, nil, nil)

var databaseAccountsGetGremlinDatabase* = Call_DatabaseAccountsGetGremlinDatabase_594214(
    name: "databaseAccountsGetGremlinDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}",
    validator: validate_DatabaseAccountsGetGremlinDatabase_594215, base: "",
    url: url_DatabaseAccountsGetGremlinDatabase_594216, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteGremlinDatabase_594240 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsDeleteGremlinDatabase_594242(protocol: Scheme;
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

proc validate_DatabaseAccountsDeleteGremlinDatabase_594241(path: JsonNode;
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
  var valid_594243 = path.getOrDefault("resourceGroupName")
  valid_594243 = validateParameter(valid_594243, JString, required = true,
                                 default = nil)
  if valid_594243 != nil:
    section.add "resourceGroupName", valid_594243
  var valid_594244 = path.getOrDefault("subscriptionId")
  valid_594244 = validateParameter(valid_594244, JString, required = true,
                                 default = nil)
  if valid_594244 != nil:
    section.add "subscriptionId", valid_594244
  var valid_594245 = path.getOrDefault("databaseName")
  valid_594245 = validateParameter(valid_594245, JString, required = true,
                                 default = nil)
  if valid_594245 != nil:
    section.add "databaseName", valid_594245
  var valid_594246 = path.getOrDefault("accountName")
  valid_594246 = validateParameter(valid_594246, JString, required = true,
                                 default = nil)
  if valid_594246 != nil:
    section.add "accountName", valid_594246
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594247 = query.getOrDefault("api-version")
  valid_594247 = validateParameter(valid_594247, JString, required = true,
                                 default = nil)
  if valid_594247 != nil:
    section.add "api-version", valid_594247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594248: Call_DatabaseAccountsDeleteGremlinDatabase_594240;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB Gremlin database.
  ## 
  let valid = call_594248.validator(path, query, header, formData, body)
  let scheme = call_594248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594248.url(scheme.get, call_594248.host, call_594248.base,
                         call_594248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594248, url, valid)

proc call*(call_594249: Call_DatabaseAccountsDeleteGremlinDatabase_594240;
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
  var path_594250 = newJObject()
  var query_594251 = newJObject()
  add(path_594250, "resourceGroupName", newJString(resourceGroupName))
  add(query_594251, "api-version", newJString(apiVersion))
  add(path_594250, "subscriptionId", newJString(subscriptionId))
  add(path_594250, "databaseName", newJString(databaseName))
  add(path_594250, "accountName", newJString(accountName))
  result = call_594249.call(path_594250, query_594251, nil, nil, nil)

var databaseAccountsDeleteGremlinDatabase* = Call_DatabaseAccountsDeleteGremlinDatabase_594240(
    name: "databaseAccountsDeleteGremlinDatabase", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}",
    validator: validate_DatabaseAccountsDeleteGremlinDatabase_594241, base: "",
    url: url_DatabaseAccountsDeleteGremlinDatabase_594242, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListGremlinGraphs_594252 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsListGremlinGraphs_594254(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListGremlinGraphs_594253(path: JsonNode;
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
  var valid_594255 = path.getOrDefault("resourceGroupName")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = nil)
  if valid_594255 != nil:
    section.add "resourceGroupName", valid_594255
  var valid_594256 = path.getOrDefault("subscriptionId")
  valid_594256 = validateParameter(valid_594256, JString, required = true,
                                 default = nil)
  if valid_594256 != nil:
    section.add "subscriptionId", valid_594256
  var valid_594257 = path.getOrDefault("databaseName")
  valid_594257 = validateParameter(valid_594257, JString, required = true,
                                 default = nil)
  if valid_594257 != nil:
    section.add "databaseName", valid_594257
  var valid_594258 = path.getOrDefault("accountName")
  valid_594258 = validateParameter(valid_594258, JString, required = true,
                                 default = nil)
  if valid_594258 != nil:
    section.add "accountName", valid_594258
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594259 = query.getOrDefault("api-version")
  valid_594259 = validateParameter(valid_594259, JString, required = true,
                                 default = nil)
  if valid_594259 != nil:
    section.add "api-version", valid_594259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594260: Call_DatabaseAccountsListGremlinGraphs_594252;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Gremlin graph under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_594260.validator(path, query, header, formData, body)
  let scheme = call_594260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594260.url(scheme.get, call_594260.host, call_594260.base,
                         call_594260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594260, url, valid)

proc call*(call_594261: Call_DatabaseAccountsListGremlinGraphs_594252;
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
  var path_594262 = newJObject()
  var query_594263 = newJObject()
  add(path_594262, "resourceGroupName", newJString(resourceGroupName))
  add(query_594263, "api-version", newJString(apiVersion))
  add(path_594262, "subscriptionId", newJString(subscriptionId))
  add(path_594262, "databaseName", newJString(databaseName))
  add(path_594262, "accountName", newJString(accountName))
  result = call_594261.call(path_594262, query_594263, nil, nil, nil)

var databaseAccountsListGremlinGraphs* = Call_DatabaseAccountsListGremlinGraphs_594252(
    name: "databaseAccountsListGremlinGraphs", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/graphs",
    validator: validate_DatabaseAccountsListGremlinGraphs_594253, base: "",
    url: url_DatabaseAccountsListGremlinGraphs_594254, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateGremlinGraph_594277 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsCreateUpdateGremlinGraph_594279(protocol: Scheme;
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

proc validate_DatabaseAccountsCreateUpdateGremlinGraph_594278(path: JsonNode;
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
  var valid_594280 = path.getOrDefault("resourceGroupName")
  valid_594280 = validateParameter(valid_594280, JString, required = true,
                                 default = nil)
  if valid_594280 != nil:
    section.add "resourceGroupName", valid_594280
  var valid_594281 = path.getOrDefault("subscriptionId")
  valid_594281 = validateParameter(valid_594281, JString, required = true,
                                 default = nil)
  if valid_594281 != nil:
    section.add "subscriptionId", valid_594281
  var valid_594282 = path.getOrDefault("databaseName")
  valid_594282 = validateParameter(valid_594282, JString, required = true,
                                 default = nil)
  if valid_594282 != nil:
    section.add "databaseName", valid_594282
  var valid_594283 = path.getOrDefault("graphName")
  valid_594283 = validateParameter(valid_594283, JString, required = true,
                                 default = nil)
  if valid_594283 != nil:
    section.add "graphName", valid_594283
  var valid_594284 = path.getOrDefault("accountName")
  valid_594284 = validateParameter(valid_594284, JString, required = true,
                                 default = nil)
  if valid_594284 != nil:
    section.add "accountName", valid_594284
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594285 = query.getOrDefault("api-version")
  valid_594285 = validateParameter(valid_594285, JString, required = true,
                                 default = nil)
  if valid_594285 != nil:
    section.add "api-version", valid_594285
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

proc call*(call_594287: Call_DatabaseAccountsCreateUpdateGremlinGraph_594277;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB Gremlin graph
  ## 
  let valid = call_594287.validator(path, query, header, formData, body)
  let scheme = call_594287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594287.url(scheme.get, call_594287.host, call_594287.base,
                         call_594287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594287, url, valid)

proc call*(call_594288: Call_DatabaseAccountsCreateUpdateGremlinGraph_594277;
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
  var path_594289 = newJObject()
  var query_594290 = newJObject()
  var body_594291 = newJObject()
  add(path_594289, "resourceGroupName", newJString(resourceGroupName))
  add(query_594290, "api-version", newJString(apiVersion))
  if createUpdateGremlinGraphParameters != nil:
    body_594291 = createUpdateGremlinGraphParameters
  add(path_594289, "subscriptionId", newJString(subscriptionId))
  add(path_594289, "databaseName", newJString(databaseName))
  add(path_594289, "graphName", newJString(graphName))
  add(path_594289, "accountName", newJString(accountName))
  result = call_594288.call(path_594289, query_594290, nil, nil, body_594291)

var databaseAccountsCreateUpdateGremlinGraph* = Call_DatabaseAccountsCreateUpdateGremlinGraph_594277(
    name: "databaseAccountsCreateUpdateGremlinGraph", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/graphs/{graphName}",
    validator: validate_DatabaseAccountsCreateUpdateGremlinGraph_594278, base: "",
    url: url_DatabaseAccountsCreateUpdateGremlinGraph_594279,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetGremlinGraph_594264 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsGetGremlinGraph_594266(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsGetGremlinGraph_594265(path: JsonNode;
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
  var valid_594267 = path.getOrDefault("resourceGroupName")
  valid_594267 = validateParameter(valid_594267, JString, required = true,
                                 default = nil)
  if valid_594267 != nil:
    section.add "resourceGroupName", valid_594267
  var valid_594268 = path.getOrDefault("subscriptionId")
  valid_594268 = validateParameter(valid_594268, JString, required = true,
                                 default = nil)
  if valid_594268 != nil:
    section.add "subscriptionId", valid_594268
  var valid_594269 = path.getOrDefault("databaseName")
  valid_594269 = validateParameter(valid_594269, JString, required = true,
                                 default = nil)
  if valid_594269 != nil:
    section.add "databaseName", valid_594269
  var valid_594270 = path.getOrDefault("graphName")
  valid_594270 = validateParameter(valid_594270, JString, required = true,
                                 default = nil)
  if valid_594270 != nil:
    section.add "graphName", valid_594270
  var valid_594271 = path.getOrDefault("accountName")
  valid_594271 = validateParameter(valid_594271, JString, required = true,
                                 default = nil)
  if valid_594271 != nil:
    section.add "accountName", valid_594271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594272 = query.getOrDefault("api-version")
  valid_594272 = validateParameter(valid_594272, JString, required = true,
                                 default = nil)
  if valid_594272 != nil:
    section.add "api-version", valid_594272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594273: Call_DatabaseAccountsGetGremlinGraph_594264;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the Gremlin graph under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_594273.validator(path, query, header, formData, body)
  let scheme = call_594273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594273.url(scheme.get, call_594273.host, call_594273.base,
                         call_594273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594273, url, valid)

proc call*(call_594274: Call_DatabaseAccountsGetGremlinGraph_594264;
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
  var path_594275 = newJObject()
  var query_594276 = newJObject()
  add(path_594275, "resourceGroupName", newJString(resourceGroupName))
  add(query_594276, "api-version", newJString(apiVersion))
  add(path_594275, "subscriptionId", newJString(subscriptionId))
  add(path_594275, "databaseName", newJString(databaseName))
  add(path_594275, "graphName", newJString(graphName))
  add(path_594275, "accountName", newJString(accountName))
  result = call_594274.call(path_594275, query_594276, nil, nil, nil)

var databaseAccountsGetGremlinGraph* = Call_DatabaseAccountsGetGremlinGraph_594264(
    name: "databaseAccountsGetGremlinGraph", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/graphs/{graphName}",
    validator: validate_DatabaseAccountsGetGremlinGraph_594265, base: "",
    url: url_DatabaseAccountsGetGremlinGraph_594266, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteGremlinGraph_594292 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsDeleteGremlinGraph_594294(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsDeleteGremlinGraph_594293(path: JsonNode;
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
  var valid_594295 = path.getOrDefault("resourceGroupName")
  valid_594295 = validateParameter(valid_594295, JString, required = true,
                                 default = nil)
  if valid_594295 != nil:
    section.add "resourceGroupName", valid_594295
  var valid_594296 = path.getOrDefault("subscriptionId")
  valid_594296 = validateParameter(valid_594296, JString, required = true,
                                 default = nil)
  if valid_594296 != nil:
    section.add "subscriptionId", valid_594296
  var valid_594297 = path.getOrDefault("databaseName")
  valid_594297 = validateParameter(valid_594297, JString, required = true,
                                 default = nil)
  if valid_594297 != nil:
    section.add "databaseName", valid_594297
  var valid_594298 = path.getOrDefault("graphName")
  valid_594298 = validateParameter(valid_594298, JString, required = true,
                                 default = nil)
  if valid_594298 != nil:
    section.add "graphName", valid_594298
  var valid_594299 = path.getOrDefault("accountName")
  valid_594299 = validateParameter(valid_594299, JString, required = true,
                                 default = nil)
  if valid_594299 != nil:
    section.add "accountName", valid_594299
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594300 = query.getOrDefault("api-version")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "api-version", valid_594300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594301: Call_DatabaseAccountsDeleteGremlinGraph_594292;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB Gremlin graph.
  ## 
  let valid = call_594301.validator(path, query, header, formData, body)
  let scheme = call_594301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594301.url(scheme.get, call_594301.host, call_594301.base,
                         call_594301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594301, url, valid)

proc call*(call_594302: Call_DatabaseAccountsDeleteGremlinGraph_594292;
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
  var path_594303 = newJObject()
  var query_594304 = newJObject()
  add(path_594303, "resourceGroupName", newJString(resourceGroupName))
  add(query_594304, "api-version", newJString(apiVersion))
  add(path_594303, "subscriptionId", newJString(subscriptionId))
  add(path_594303, "databaseName", newJString(databaseName))
  add(path_594303, "graphName", newJString(graphName))
  add(path_594303, "accountName", newJString(accountName))
  result = call_594302.call(path_594303, query_594304, nil, nil, nil)

var databaseAccountsDeleteGremlinGraph* = Call_DatabaseAccountsDeleteGremlinGraph_594292(
    name: "databaseAccountsDeleteGremlinGraph", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/graphs/{graphName}",
    validator: validate_DatabaseAccountsDeleteGremlinGraph_594293, base: "",
    url: url_DatabaseAccountsDeleteGremlinGraph_594294, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateGremlinGraphThroughput_594318 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsUpdateGremlinGraphThroughput_594320(protocol: Scheme;
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

proc validate_DatabaseAccountsUpdateGremlinGraphThroughput_594319(path: JsonNode;
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
  var valid_594321 = path.getOrDefault("resourceGroupName")
  valid_594321 = validateParameter(valid_594321, JString, required = true,
                                 default = nil)
  if valid_594321 != nil:
    section.add "resourceGroupName", valid_594321
  var valid_594322 = path.getOrDefault("subscriptionId")
  valid_594322 = validateParameter(valid_594322, JString, required = true,
                                 default = nil)
  if valid_594322 != nil:
    section.add "subscriptionId", valid_594322
  var valid_594323 = path.getOrDefault("databaseName")
  valid_594323 = validateParameter(valid_594323, JString, required = true,
                                 default = nil)
  if valid_594323 != nil:
    section.add "databaseName", valid_594323
  var valid_594324 = path.getOrDefault("graphName")
  valid_594324 = validateParameter(valid_594324, JString, required = true,
                                 default = nil)
  if valid_594324 != nil:
    section.add "graphName", valid_594324
  var valid_594325 = path.getOrDefault("accountName")
  valid_594325 = validateParameter(valid_594325, JString, required = true,
                                 default = nil)
  if valid_594325 != nil:
    section.add "accountName", valid_594325
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594326 = query.getOrDefault("api-version")
  valid_594326 = validateParameter(valid_594326, JString, required = true,
                                 default = nil)
  if valid_594326 != nil:
    section.add "api-version", valid_594326
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

proc call*(call_594328: Call_DatabaseAccountsUpdateGremlinGraphThroughput_594318;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Gremlin graph
  ## 
  let valid = call_594328.validator(path, query, header, formData, body)
  let scheme = call_594328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594328.url(scheme.get, call_594328.host, call_594328.base,
                         call_594328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594328, url, valid)

proc call*(call_594329: Call_DatabaseAccountsUpdateGremlinGraphThroughput_594318;
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
  var path_594330 = newJObject()
  var query_594331 = newJObject()
  var body_594332 = newJObject()
  add(path_594330, "resourceGroupName", newJString(resourceGroupName))
  add(query_594331, "api-version", newJString(apiVersion))
  add(path_594330, "subscriptionId", newJString(subscriptionId))
  add(path_594330, "databaseName", newJString(databaseName))
  if updateThroughputParameters != nil:
    body_594332 = updateThroughputParameters
  add(path_594330, "graphName", newJString(graphName))
  add(path_594330, "accountName", newJString(accountName))
  result = call_594329.call(path_594330, query_594331, nil, nil, body_594332)

var databaseAccountsUpdateGremlinGraphThroughput* = Call_DatabaseAccountsUpdateGremlinGraphThroughput_594318(
    name: "databaseAccountsUpdateGremlinGraphThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/graphs/{graphName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateGremlinGraphThroughput_594319,
    base: "", url: url_DatabaseAccountsUpdateGremlinGraphThroughput_594320,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetGremlinGraphThroughput_594305 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsGetGremlinGraphThroughput_594307(protocol: Scheme;
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

proc validate_DatabaseAccountsGetGremlinGraphThroughput_594306(path: JsonNode;
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
  var valid_594308 = path.getOrDefault("resourceGroupName")
  valid_594308 = validateParameter(valid_594308, JString, required = true,
                                 default = nil)
  if valid_594308 != nil:
    section.add "resourceGroupName", valid_594308
  var valid_594309 = path.getOrDefault("subscriptionId")
  valid_594309 = validateParameter(valid_594309, JString, required = true,
                                 default = nil)
  if valid_594309 != nil:
    section.add "subscriptionId", valid_594309
  var valid_594310 = path.getOrDefault("databaseName")
  valid_594310 = validateParameter(valid_594310, JString, required = true,
                                 default = nil)
  if valid_594310 != nil:
    section.add "databaseName", valid_594310
  var valid_594311 = path.getOrDefault("graphName")
  valid_594311 = validateParameter(valid_594311, JString, required = true,
                                 default = nil)
  if valid_594311 != nil:
    section.add "graphName", valid_594311
  var valid_594312 = path.getOrDefault("accountName")
  valid_594312 = validateParameter(valid_594312, JString, required = true,
                                 default = nil)
  if valid_594312 != nil:
    section.add "accountName", valid_594312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594313 = query.getOrDefault("api-version")
  valid_594313 = validateParameter(valid_594313, JString, required = true,
                                 default = nil)
  if valid_594313 != nil:
    section.add "api-version", valid_594313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594314: Call_DatabaseAccountsGetGremlinGraphThroughput_594305;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the Gremlin graph throughput under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_594314.validator(path, query, header, formData, body)
  let scheme = call_594314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594314.url(scheme.get, call_594314.host, call_594314.base,
                         call_594314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594314, url, valid)

proc call*(call_594315: Call_DatabaseAccountsGetGremlinGraphThroughput_594305;
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
  var path_594316 = newJObject()
  var query_594317 = newJObject()
  add(path_594316, "resourceGroupName", newJString(resourceGroupName))
  add(query_594317, "api-version", newJString(apiVersion))
  add(path_594316, "subscriptionId", newJString(subscriptionId))
  add(path_594316, "databaseName", newJString(databaseName))
  add(path_594316, "graphName", newJString(graphName))
  add(path_594316, "accountName", newJString(accountName))
  result = call_594315.call(path_594316, query_594317, nil, nil, nil)

var databaseAccountsGetGremlinGraphThroughput* = Call_DatabaseAccountsGetGremlinGraphThroughput_594305(
    name: "databaseAccountsGetGremlinGraphThroughput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/graphs/{graphName}/settings/throughput",
    validator: validate_DatabaseAccountsGetGremlinGraphThroughput_594306,
    base: "", url: url_DatabaseAccountsGetGremlinGraphThroughput_594307,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateGremlinDatabaseThroughput_594345 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsUpdateGremlinDatabaseThroughput_594347(protocol: Scheme;
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

proc validate_DatabaseAccountsUpdateGremlinDatabaseThroughput_594346(
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
  var valid_594348 = path.getOrDefault("resourceGroupName")
  valid_594348 = validateParameter(valid_594348, JString, required = true,
                                 default = nil)
  if valid_594348 != nil:
    section.add "resourceGroupName", valid_594348
  var valid_594349 = path.getOrDefault("subscriptionId")
  valid_594349 = validateParameter(valid_594349, JString, required = true,
                                 default = nil)
  if valid_594349 != nil:
    section.add "subscriptionId", valid_594349
  var valid_594350 = path.getOrDefault("databaseName")
  valid_594350 = validateParameter(valid_594350, JString, required = true,
                                 default = nil)
  if valid_594350 != nil:
    section.add "databaseName", valid_594350
  var valid_594351 = path.getOrDefault("accountName")
  valid_594351 = validateParameter(valid_594351, JString, required = true,
                                 default = nil)
  if valid_594351 != nil:
    section.add "accountName", valid_594351
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594352 = query.getOrDefault("api-version")
  valid_594352 = validateParameter(valid_594352, JString, required = true,
                                 default = nil)
  if valid_594352 != nil:
    section.add "api-version", valid_594352
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

proc call*(call_594354: Call_DatabaseAccountsUpdateGremlinDatabaseThroughput_594345;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Gremlin database
  ## 
  let valid = call_594354.validator(path, query, header, formData, body)
  let scheme = call_594354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594354.url(scheme.get, call_594354.host, call_594354.base,
                         call_594354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594354, url, valid)

proc call*(call_594355: Call_DatabaseAccountsUpdateGremlinDatabaseThroughput_594345;
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
  var path_594356 = newJObject()
  var query_594357 = newJObject()
  var body_594358 = newJObject()
  add(path_594356, "resourceGroupName", newJString(resourceGroupName))
  add(query_594357, "api-version", newJString(apiVersion))
  add(path_594356, "subscriptionId", newJString(subscriptionId))
  add(path_594356, "databaseName", newJString(databaseName))
  if updateThroughputParameters != nil:
    body_594358 = updateThroughputParameters
  add(path_594356, "accountName", newJString(accountName))
  result = call_594355.call(path_594356, query_594357, nil, nil, body_594358)

var databaseAccountsUpdateGremlinDatabaseThroughput* = Call_DatabaseAccountsUpdateGremlinDatabaseThroughput_594345(
    name: "databaseAccountsUpdateGremlinDatabaseThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateGremlinDatabaseThroughput_594346,
    base: "", url: url_DatabaseAccountsUpdateGremlinDatabaseThroughput_594347,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetGremlinDatabaseThroughput_594333 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsGetGremlinDatabaseThroughput_594335(protocol: Scheme;
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

proc validate_DatabaseAccountsGetGremlinDatabaseThroughput_594334(path: JsonNode;
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
  var valid_594336 = path.getOrDefault("resourceGroupName")
  valid_594336 = validateParameter(valid_594336, JString, required = true,
                                 default = nil)
  if valid_594336 != nil:
    section.add "resourceGroupName", valid_594336
  var valid_594337 = path.getOrDefault("subscriptionId")
  valid_594337 = validateParameter(valid_594337, JString, required = true,
                                 default = nil)
  if valid_594337 != nil:
    section.add "subscriptionId", valid_594337
  var valid_594338 = path.getOrDefault("databaseName")
  valid_594338 = validateParameter(valid_594338, JString, required = true,
                                 default = nil)
  if valid_594338 != nil:
    section.add "databaseName", valid_594338
  var valid_594339 = path.getOrDefault("accountName")
  valid_594339 = validateParameter(valid_594339, JString, required = true,
                                 default = nil)
  if valid_594339 != nil:
    section.add "accountName", valid_594339
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594340 = query.getOrDefault("api-version")
  valid_594340 = validateParameter(valid_594340, JString, required = true,
                                 default = nil)
  if valid_594340 != nil:
    section.add "api-version", valid_594340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594341: Call_DatabaseAccountsGetGremlinDatabaseThroughput_594333;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the Gremlin database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_594341.validator(path, query, header, formData, body)
  let scheme = call_594341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594341.url(scheme.get, call_594341.host, call_594341.base,
                         call_594341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594341, url, valid)

proc call*(call_594342: Call_DatabaseAccountsGetGremlinDatabaseThroughput_594333;
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
  var path_594343 = newJObject()
  var query_594344 = newJObject()
  add(path_594343, "resourceGroupName", newJString(resourceGroupName))
  add(query_594344, "api-version", newJString(apiVersion))
  add(path_594343, "subscriptionId", newJString(subscriptionId))
  add(path_594343, "databaseName", newJString(databaseName))
  add(path_594343, "accountName", newJString(accountName))
  result = call_594342.call(path_594343, query_594344, nil, nil, nil)

var databaseAccountsGetGremlinDatabaseThroughput* = Call_DatabaseAccountsGetGremlinDatabaseThroughput_594333(
    name: "databaseAccountsGetGremlinDatabaseThroughput",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/gremlin/databases/{databaseName}/settings/throughput",
    validator: validate_DatabaseAccountsGetGremlinDatabaseThroughput_594334,
    base: "", url: url_DatabaseAccountsGetGremlinDatabaseThroughput_594335,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListMongoDBDatabases_594359 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsListMongoDBDatabases_594361(protocol: Scheme;
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

proc validate_DatabaseAccountsListMongoDBDatabases_594360(path: JsonNode;
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
  var valid_594362 = path.getOrDefault("resourceGroupName")
  valid_594362 = validateParameter(valid_594362, JString, required = true,
                                 default = nil)
  if valid_594362 != nil:
    section.add "resourceGroupName", valid_594362
  var valid_594363 = path.getOrDefault("subscriptionId")
  valid_594363 = validateParameter(valid_594363, JString, required = true,
                                 default = nil)
  if valid_594363 != nil:
    section.add "subscriptionId", valid_594363
  var valid_594364 = path.getOrDefault("accountName")
  valid_594364 = validateParameter(valid_594364, JString, required = true,
                                 default = nil)
  if valid_594364 != nil:
    section.add "accountName", valid_594364
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594365 = query.getOrDefault("api-version")
  valid_594365 = validateParameter(valid_594365, JString, required = true,
                                 default = nil)
  if valid_594365 != nil:
    section.add "api-version", valid_594365
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594366: Call_DatabaseAccountsListMongoDBDatabases_594359;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the MongoDB databases under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_594366.validator(path, query, header, formData, body)
  let scheme = call_594366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594366.url(scheme.get, call_594366.host, call_594366.base,
                         call_594366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594366, url, valid)

proc call*(call_594367: Call_DatabaseAccountsListMongoDBDatabases_594359;
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
  var path_594368 = newJObject()
  var query_594369 = newJObject()
  add(path_594368, "resourceGroupName", newJString(resourceGroupName))
  add(query_594369, "api-version", newJString(apiVersion))
  add(path_594368, "subscriptionId", newJString(subscriptionId))
  add(path_594368, "accountName", newJString(accountName))
  result = call_594367.call(path_594368, query_594369, nil, nil, nil)

var databaseAccountsListMongoDBDatabases* = Call_DatabaseAccountsListMongoDBDatabases_594359(
    name: "databaseAccountsListMongoDBDatabases", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases",
    validator: validate_DatabaseAccountsListMongoDBDatabases_594360, base: "",
    url: url_DatabaseAccountsListMongoDBDatabases_594361, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateMongoDBDatabase_594382 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsCreateUpdateMongoDBDatabase_594384(protocol: Scheme;
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

proc validate_DatabaseAccountsCreateUpdateMongoDBDatabase_594383(path: JsonNode;
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
  var valid_594385 = path.getOrDefault("resourceGroupName")
  valid_594385 = validateParameter(valid_594385, JString, required = true,
                                 default = nil)
  if valid_594385 != nil:
    section.add "resourceGroupName", valid_594385
  var valid_594386 = path.getOrDefault("subscriptionId")
  valid_594386 = validateParameter(valid_594386, JString, required = true,
                                 default = nil)
  if valid_594386 != nil:
    section.add "subscriptionId", valid_594386
  var valid_594387 = path.getOrDefault("databaseName")
  valid_594387 = validateParameter(valid_594387, JString, required = true,
                                 default = nil)
  if valid_594387 != nil:
    section.add "databaseName", valid_594387
  var valid_594388 = path.getOrDefault("accountName")
  valid_594388 = validateParameter(valid_594388, JString, required = true,
                                 default = nil)
  if valid_594388 != nil:
    section.add "accountName", valid_594388
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594389 = query.getOrDefault("api-version")
  valid_594389 = validateParameter(valid_594389, JString, required = true,
                                 default = nil)
  if valid_594389 != nil:
    section.add "api-version", valid_594389
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

proc call*(call_594391: Call_DatabaseAccountsCreateUpdateMongoDBDatabase_594382;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or updates Azure Cosmos DB MongoDB database
  ## 
  let valid = call_594391.validator(path, query, header, formData, body)
  let scheme = call_594391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594391.url(scheme.get, call_594391.host, call_594391.base,
                         call_594391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594391, url, valid)

proc call*(call_594392: Call_DatabaseAccountsCreateUpdateMongoDBDatabase_594382;
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
  var path_594393 = newJObject()
  var query_594394 = newJObject()
  var body_594395 = newJObject()
  add(path_594393, "resourceGroupName", newJString(resourceGroupName))
  add(query_594394, "api-version", newJString(apiVersion))
  add(path_594393, "subscriptionId", newJString(subscriptionId))
  add(path_594393, "databaseName", newJString(databaseName))
  if createUpdateMongoDBDatabaseParameters != nil:
    body_594395 = createUpdateMongoDBDatabaseParameters
  add(path_594393, "accountName", newJString(accountName))
  result = call_594392.call(path_594393, query_594394, nil, nil, body_594395)

var databaseAccountsCreateUpdateMongoDBDatabase* = Call_DatabaseAccountsCreateUpdateMongoDBDatabase_594382(
    name: "databaseAccountsCreateUpdateMongoDBDatabase", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}",
    validator: validate_DatabaseAccountsCreateUpdateMongoDBDatabase_594383,
    base: "", url: url_DatabaseAccountsCreateUpdateMongoDBDatabase_594384,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetMongoDBDatabase_594370 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsGetMongoDBDatabase_594372(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsGetMongoDBDatabase_594371(path: JsonNode;
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
  var valid_594373 = path.getOrDefault("resourceGroupName")
  valid_594373 = validateParameter(valid_594373, JString, required = true,
                                 default = nil)
  if valid_594373 != nil:
    section.add "resourceGroupName", valid_594373
  var valid_594374 = path.getOrDefault("subscriptionId")
  valid_594374 = validateParameter(valid_594374, JString, required = true,
                                 default = nil)
  if valid_594374 != nil:
    section.add "subscriptionId", valid_594374
  var valid_594375 = path.getOrDefault("databaseName")
  valid_594375 = validateParameter(valid_594375, JString, required = true,
                                 default = nil)
  if valid_594375 != nil:
    section.add "databaseName", valid_594375
  var valid_594376 = path.getOrDefault("accountName")
  valid_594376 = validateParameter(valid_594376, JString, required = true,
                                 default = nil)
  if valid_594376 != nil:
    section.add "accountName", valid_594376
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594377 = query.getOrDefault("api-version")
  valid_594377 = validateParameter(valid_594377, JString, required = true,
                                 default = nil)
  if valid_594377 != nil:
    section.add "api-version", valid_594377
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594378: Call_DatabaseAccountsGetMongoDBDatabase_594370;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the MongoDB databases under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_594378.validator(path, query, header, formData, body)
  let scheme = call_594378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594378.url(scheme.get, call_594378.host, call_594378.base,
                         call_594378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594378, url, valid)

proc call*(call_594379: Call_DatabaseAccountsGetMongoDBDatabase_594370;
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
  var path_594380 = newJObject()
  var query_594381 = newJObject()
  add(path_594380, "resourceGroupName", newJString(resourceGroupName))
  add(query_594381, "api-version", newJString(apiVersion))
  add(path_594380, "subscriptionId", newJString(subscriptionId))
  add(path_594380, "databaseName", newJString(databaseName))
  add(path_594380, "accountName", newJString(accountName))
  result = call_594379.call(path_594380, query_594381, nil, nil, nil)

var databaseAccountsGetMongoDBDatabase* = Call_DatabaseAccountsGetMongoDBDatabase_594370(
    name: "databaseAccountsGetMongoDBDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}",
    validator: validate_DatabaseAccountsGetMongoDBDatabase_594371, base: "",
    url: url_DatabaseAccountsGetMongoDBDatabase_594372, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteMongoDBDatabase_594396 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsDeleteMongoDBDatabase_594398(protocol: Scheme;
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

proc validate_DatabaseAccountsDeleteMongoDBDatabase_594397(path: JsonNode;
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
  var valid_594399 = path.getOrDefault("resourceGroupName")
  valid_594399 = validateParameter(valid_594399, JString, required = true,
                                 default = nil)
  if valid_594399 != nil:
    section.add "resourceGroupName", valid_594399
  var valid_594400 = path.getOrDefault("subscriptionId")
  valid_594400 = validateParameter(valid_594400, JString, required = true,
                                 default = nil)
  if valid_594400 != nil:
    section.add "subscriptionId", valid_594400
  var valid_594401 = path.getOrDefault("databaseName")
  valid_594401 = validateParameter(valid_594401, JString, required = true,
                                 default = nil)
  if valid_594401 != nil:
    section.add "databaseName", valid_594401
  var valid_594402 = path.getOrDefault("accountName")
  valid_594402 = validateParameter(valid_594402, JString, required = true,
                                 default = nil)
  if valid_594402 != nil:
    section.add "accountName", valid_594402
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594403 = query.getOrDefault("api-version")
  valid_594403 = validateParameter(valid_594403, JString, required = true,
                                 default = nil)
  if valid_594403 != nil:
    section.add "api-version", valid_594403
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594404: Call_DatabaseAccountsDeleteMongoDBDatabase_594396;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB MongoDB database.
  ## 
  let valid = call_594404.validator(path, query, header, formData, body)
  let scheme = call_594404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594404.url(scheme.get, call_594404.host, call_594404.base,
                         call_594404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594404, url, valid)

proc call*(call_594405: Call_DatabaseAccountsDeleteMongoDBDatabase_594396;
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
  var path_594406 = newJObject()
  var query_594407 = newJObject()
  add(path_594406, "resourceGroupName", newJString(resourceGroupName))
  add(query_594407, "api-version", newJString(apiVersion))
  add(path_594406, "subscriptionId", newJString(subscriptionId))
  add(path_594406, "databaseName", newJString(databaseName))
  add(path_594406, "accountName", newJString(accountName))
  result = call_594405.call(path_594406, query_594407, nil, nil, nil)

var databaseAccountsDeleteMongoDBDatabase* = Call_DatabaseAccountsDeleteMongoDBDatabase_594396(
    name: "databaseAccountsDeleteMongoDBDatabase", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}",
    validator: validate_DatabaseAccountsDeleteMongoDBDatabase_594397, base: "",
    url: url_DatabaseAccountsDeleteMongoDBDatabase_594398, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListMongoDBCollections_594408 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsListMongoDBCollections_594410(protocol: Scheme;
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

proc validate_DatabaseAccountsListMongoDBCollections_594409(path: JsonNode;
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
  var valid_594411 = path.getOrDefault("resourceGroupName")
  valid_594411 = validateParameter(valid_594411, JString, required = true,
                                 default = nil)
  if valid_594411 != nil:
    section.add "resourceGroupName", valid_594411
  var valid_594412 = path.getOrDefault("subscriptionId")
  valid_594412 = validateParameter(valid_594412, JString, required = true,
                                 default = nil)
  if valid_594412 != nil:
    section.add "subscriptionId", valid_594412
  var valid_594413 = path.getOrDefault("databaseName")
  valid_594413 = validateParameter(valid_594413, JString, required = true,
                                 default = nil)
  if valid_594413 != nil:
    section.add "databaseName", valid_594413
  var valid_594414 = path.getOrDefault("accountName")
  valid_594414 = validateParameter(valid_594414, JString, required = true,
                                 default = nil)
  if valid_594414 != nil:
    section.add "accountName", valid_594414
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594415 = query.getOrDefault("api-version")
  valid_594415 = validateParameter(valid_594415, JString, required = true,
                                 default = nil)
  if valid_594415 != nil:
    section.add "api-version", valid_594415
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594416: Call_DatabaseAccountsListMongoDBCollections_594408;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the MongoDB collection under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_594416.validator(path, query, header, formData, body)
  let scheme = call_594416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594416.url(scheme.get, call_594416.host, call_594416.base,
                         call_594416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594416, url, valid)

proc call*(call_594417: Call_DatabaseAccountsListMongoDBCollections_594408;
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
  var path_594418 = newJObject()
  var query_594419 = newJObject()
  add(path_594418, "resourceGroupName", newJString(resourceGroupName))
  add(query_594419, "api-version", newJString(apiVersion))
  add(path_594418, "subscriptionId", newJString(subscriptionId))
  add(path_594418, "databaseName", newJString(databaseName))
  add(path_594418, "accountName", newJString(accountName))
  result = call_594417.call(path_594418, query_594419, nil, nil, nil)

var databaseAccountsListMongoDBCollections* = Call_DatabaseAccountsListMongoDBCollections_594408(
    name: "databaseAccountsListMongoDBCollections", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/collections",
    validator: validate_DatabaseAccountsListMongoDBCollections_594409, base: "",
    url: url_DatabaseAccountsListMongoDBCollections_594410,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateMongoDBCollection_594433 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsCreateUpdateMongoDBCollection_594435(protocol: Scheme;
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

proc validate_DatabaseAccountsCreateUpdateMongoDBCollection_594434(
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
  var valid_594436 = path.getOrDefault("resourceGroupName")
  valid_594436 = validateParameter(valid_594436, JString, required = true,
                                 default = nil)
  if valid_594436 != nil:
    section.add "resourceGroupName", valid_594436
  var valid_594437 = path.getOrDefault("subscriptionId")
  valid_594437 = validateParameter(valid_594437, JString, required = true,
                                 default = nil)
  if valid_594437 != nil:
    section.add "subscriptionId", valid_594437
  var valid_594438 = path.getOrDefault("databaseName")
  valid_594438 = validateParameter(valid_594438, JString, required = true,
                                 default = nil)
  if valid_594438 != nil:
    section.add "databaseName", valid_594438
  var valid_594439 = path.getOrDefault("collectionName")
  valid_594439 = validateParameter(valid_594439, JString, required = true,
                                 default = nil)
  if valid_594439 != nil:
    section.add "collectionName", valid_594439
  var valid_594440 = path.getOrDefault("accountName")
  valid_594440 = validateParameter(valid_594440, JString, required = true,
                                 default = nil)
  if valid_594440 != nil:
    section.add "accountName", valid_594440
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594441 = query.getOrDefault("api-version")
  valid_594441 = validateParameter(valid_594441, JString, required = true,
                                 default = nil)
  if valid_594441 != nil:
    section.add "api-version", valid_594441
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

proc call*(call_594443: Call_DatabaseAccountsCreateUpdateMongoDBCollection_594433;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB MongoDB Collection
  ## 
  let valid = call_594443.validator(path, query, header, formData, body)
  let scheme = call_594443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594443.url(scheme.get, call_594443.host, call_594443.base,
                         call_594443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594443, url, valid)

proc call*(call_594444: Call_DatabaseAccountsCreateUpdateMongoDBCollection_594433;
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
  var path_594445 = newJObject()
  var query_594446 = newJObject()
  var body_594447 = newJObject()
  add(path_594445, "resourceGroupName", newJString(resourceGroupName))
  if createUpdateMongoDBCollectionParameters != nil:
    body_594447 = createUpdateMongoDBCollectionParameters
  add(query_594446, "api-version", newJString(apiVersion))
  add(path_594445, "subscriptionId", newJString(subscriptionId))
  add(path_594445, "databaseName", newJString(databaseName))
  add(path_594445, "collectionName", newJString(collectionName))
  add(path_594445, "accountName", newJString(accountName))
  result = call_594444.call(path_594445, query_594446, nil, nil, body_594447)

var databaseAccountsCreateUpdateMongoDBCollection* = Call_DatabaseAccountsCreateUpdateMongoDBCollection_594433(
    name: "databaseAccountsCreateUpdateMongoDBCollection",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/collections/{collectionName}",
    validator: validate_DatabaseAccountsCreateUpdateMongoDBCollection_594434,
    base: "", url: url_DatabaseAccountsCreateUpdateMongoDBCollection_594435,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetMongoDBCollection_594420 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsGetMongoDBCollection_594422(protocol: Scheme;
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

proc validate_DatabaseAccountsGetMongoDBCollection_594421(path: JsonNode;
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
  var valid_594423 = path.getOrDefault("resourceGroupName")
  valid_594423 = validateParameter(valid_594423, JString, required = true,
                                 default = nil)
  if valid_594423 != nil:
    section.add "resourceGroupName", valid_594423
  var valid_594424 = path.getOrDefault("subscriptionId")
  valid_594424 = validateParameter(valid_594424, JString, required = true,
                                 default = nil)
  if valid_594424 != nil:
    section.add "subscriptionId", valid_594424
  var valid_594425 = path.getOrDefault("databaseName")
  valid_594425 = validateParameter(valid_594425, JString, required = true,
                                 default = nil)
  if valid_594425 != nil:
    section.add "databaseName", valid_594425
  var valid_594426 = path.getOrDefault("collectionName")
  valid_594426 = validateParameter(valid_594426, JString, required = true,
                                 default = nil)
  if valid_594426 != nil:
    section.add "collectionName", valid_594426
  var valid_594427 = path.getOrDefault("accountName")
  valid_594427 = validateParameter(valid_594427, JString, required = true,
                                 default = nil)
  if valid_594427 != nil:
    section.add "accountName", valid_594427
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594428 = query.getOrDefault("api-version")
  valid_594428 = validateParameter(valid_594428, JString, required = true,
                                 default = nil)
  if valid_594428 != nil:
    section.add "api-version", valid_594428
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594429: Call_DatabaseAccountsGetMongoDBCollection_594420;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the MongoDB collection under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_594429.validator(path, query, header, formData, body)
  let scheme = call_594429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594429.url(scheme.get, call_594429.host, call_594429.base,
                         call_594429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594429, url, valid)

proc call*(call_594430: Call_DatabaseAccountsGetMongoDBCollection_594420;
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
  var path_594431 = newJObject()
  var query_594432 = newJObject()
  add(path_594431, "resourceGroupName", newJString(resourceGroupName))
  add(query_594432, "api-version", newJString(apiVersion))
  add(path_594431, "subscriptionId", newJString(subscriptionId))
  add(path_594431, "databaseName", newJString(databaseName))
  add(path_594431, "collectionName", newJString(collectionName))
  add(path_594431, "accountName", newJString(accountName))
  result = call_594430.call(path_594431, query_594432, nil, nil, nil)

var databaseAccountsGetMongoDBCollection* = Call_DatabaseAccountsGetMongoDBCollection_594420(
    name: "databaseAccountsGetMongoDBCollection", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/collections/{collectionName}",
    validator: validate_DatabaseAccountsGetMongoDBCollection_594421, base: "",
    url: url_DatabaseAccountsGetMongoDBCollection_594422, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteMongoDBCollection_594448 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsDeleteMongoDBCollection_594450(protocol: Scheme;
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

proc validate_DatabaseAccountsDeleteMongoDBCollection_594449(path: JsonNode;
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
  var valid_594451 = path.getOrDefault("resourceGroupName")
  valid_594451 = validateParameter(valid_594451, JString, required = true,
                                 default = nil)
  if valid_594451 != nil:
    section.add "resourceGroupName", valid_594451
  var valid_594452 = path.getOrDefault("subscriptionId")
  valid_594452 = validateParameter(valid_594452, JString, required = true,
                                 default = nil)
  if valid_594452 != nil:
    section.add "subscriptionId", valid_594452
  var valid_594453 = path.getOrDefault("databaseName")
  valid_594453 = validateParameter(valid_594453, JString, required = true,
                                 default = nil)
  if valid_594453 != nil:
    section.add "databaseName", valid_594453
  var valid_594454 = path.getOrDefault("collectionName")
  valid_594454 = validateParameter(valid_594454, JString, required = true,
                                 default = nil)
  if valid_594454 != nil:
    section.add "collectionName", valid_594454
  var valid_594455 = path.getOrDefault("accountName")
  valid_594455 = validateParameter(valid_594455, JString, required = true,
                                 default = nil)
  if valid_594455 != nil:
    section.add "accountName", valid_594455
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594456 = query.getOrDefault("api-version")
  valid_594456 = validateParameter(valid_594456, JString, required = true,
                                 default = nil)
  if valid_594456 != nil:
    section.add "api-version", valid_594456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594457: Call_DatabaseAccountsDeleteMongoDBCollection_594448;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB MongoDB Collection.
  ## 
  let valid = call_594457.validator(path, query, header, formData, body)
  let scheme = call_594457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594457.url(scheme.get, call_594457.host, call_594457.base,
                         call_594457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594457, url, valid)

proc call*(call_594458: Call_DatabaseAccountsDeleteMongoDBCollection_594448;
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
  var path_594459 = newJObject()
  var query_594460 = newJObject()
  add(path_594459, "resourceGroupName", newJString(resourceGroupName))
  add(query_594460, "api-version", newJString(apiVersion))
  add(path_594459, "subscriptionId", newJString(subscriptionId))
  add(path_594459, "databaseName", newJString(databaseName))
  add(path_594459, "collectionName", newJString(collectionName))
  add(path_594459, "accountName", newJString(accountName))
  result = call_594458.call(path_594459, query_594460, nil, nil, nil)

var databaseAccountsDeleteMongoDBCollection* = Call_DatabaseAccountsDeleteMongoDBCollection_594448(
    name: "databaseAccountsDeleteMongoDBCollection", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/collections/{collectionName}",
    validator: validate_DatabaseAccountsDeleteMongoDBCollection_594449, base: "",
    url: url_DatabaseAccountsDeleteMongoDBCollection_594450,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateMongoDBCollectionThroughput_594474 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsUpdateMongoDBCollectionThroughput_594476(
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

proc validate_DatabaseAccountsUpdateMongoDBCollectionThroughput_594475(
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
  var valid_594477 = path.getOrDefault("resourceGroupName")
  valid_594477 = validateParameter(valid_594477, JString, required = true,
                                 default = nil)
  if valid_594477 != nil:
    section.add "resourceGroupName", valid_594477
  var valid_594478 = path.getOrDefault("subscriptionId")
  valid_594478 = validateParameter(valid_594478, JString, required = true,
                                 default = nil)
  if valid_594478 != nil:
    section.add "subscriptionId", valid_594478
  var valid_594479 = path.getOrDefault("databaseName")
  valid_594479 = validateParameter(valid_594479, JString, required = true,
                                 default = nil)
  if valid_594479 != nil:
    section.add "databaseName", valid_594479
  var valid_594480 = path.getOrDefault("collectionName")
  valid_594480 = validateParameter(valid_594480, JString, required = true,
                                 default = nil)
  if valid_594480 != nil:
    section.add "collectionName", valid_594480
  var valid_594481 = path.getOrDefault("accountName")
  valid_594481 = validateParameter(valid_594481, JString, required = true,
                                 default = nil)
  if valid_594481 != nil:
    section.add "accountName", valid_594481
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594482 = query.getOrDefault("api-version")
  valid_594482 = validateParameter(valid_594482, JString, required = true,
                                 default = nil)
  if valid_594482 != nil:
    section.add "api-version", valid_594482
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

proc call*(call_594484: Call_DatabaseAccountsUpdateMongoDBCollectionThroughput_594474;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the RUs per second of an Azure Cosmos DB MongoDB collection
  ## 
  let valid = call_594484.validator(path, query, header, formData, body)
  let scheme = call_594484.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594484.url(scheme.get, call_594484.host, call_594484.base,
                         call_594484.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594484, url, valid)

proc call*(call_594485: Call_DatabaseAccountsUpdateMongoDBCollectionThroughput_594474;
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
  var path_594486 = newJObject()
  var query_594487 = newJObject()
  var body_594488 = newJObject()
  add(path_594486, "resourceGroupName", newJString(resourceGroupName))
  add(query_594487, "api-version", newJString(apiVersion))
  add(path_594486, "subscriptionId", newJString(subscriptionId))
  add(path_594486, "databaseName", newJString(databaseName))
  if updateThroughputParameters != nil:
    body_594488 = updateThroughputParameters
  add(path_594486, "collectionName", newJString(collectionName))
  add(path_594486, "accountName", newJString(accountName))
  result = call_594485.call(path_594486, query_594487, nil, nil, body_594488)

var databaseAccountsUpdateMongoDBCollectionThroughput* = Call_DatabaseAccountsUpdateMongoDBCollectionThroughput_594474(
    name: "databaseAccountsUpdateMongoDBCollectionThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/collections/{collectionName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateMongoDBCollectionThroughput_594475,
    base: "", url: url_DatabaseAccountsUpdateMongoDBCollectionThroughput_594476,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetMongoDBCollectionThroughput_594461 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsGetMongoDBCollectionThroughput_594463(protocol: Scheme;
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

proc validate_DatabaseAccountsGetMongoDBCollectionThroughput_594462(
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
  var valid_594464 = path.getOrDefault("resourceGroupName")
  valid_594464 = validateParameter(valid_594464, JString, required = true,
                                 default = nil)
  if valid_594464 != nil:
    section.add "resourceGroupName", valid_594464
  var valid_594465 = path.getOrDefault("subscriptionId")
  valid_594465 = validateParameter(valid_594465, JString, required = true,
                                 default = nil)
  if valid_594465 != nil:
    section.add "subscriptionId", valid_594465
  var valid_594466 = path.getOrDefault("databaseName")
  valid_594466 = validateParameter(valid_594466, JString, required = true,
                                 default = nil)
  if valid_594466 != nil:
    section.add "databaseName", valid_594466
  var valid_594467 = path.getOrDefault("collectionName")
  valid_594467 = validateParameter(valid_594467, JString, required = true,
                                 default = nil)
  if valid_594467 != nil:
    section.add "collectionName", valid_594467
  var valid_594468 = path.getOrDefault("accountName")
  valid_594468 = validateParameter(valid_594468, JString, required = true,
                                 default = nil)
  if valid_594468 != nil:
    section.add "accountName", valid_594468
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594469 = query.getOrDefault("api-version")
  valid_594469 = validateParameter(valid_594469, JString, required = true,
                                 default = nil)
  if valid_594469 != nil:
    section.add "api-version", valid_594469
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594470: Call_DatabaseAccountsGetMongoDBCollectionThroughput_594461;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the MongoDB collection under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_594470.validator(path, query, header, formData, body)
  let scheme = call_594470.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594470.url(scheme.get, call_594470.host, call_594470.base,
                         call_594470.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594470, url, valid)

proc call*(call_594471: Call_DatabaseAccountsGetMongoDBCollectionThroughput_594461;
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
  var path_594472 = newJObject()
  var query_594473 = newJObject()
  add(path_594472, "resourceGroupName", newJString(resourceGroupName))
  add(query_594473, "api-version", newJString(apiVersion))
  add(path_594472, "subscriptionId", newJString(subscriptionId))
  add(path_594472, "databaseName", newJString(databaseName))
  add(path_594472, "collectionName", newJString(collectionName))
  add(path_594472, "accountName", newJString(accountName))
  result = call_594471.call(path_594472, query_594473, nil, nil, nil)

var databaseAccountsGetMongoDBCollectionThroughput* = Call_DatabaseAccountsGetMongoDBCollectionThroughput_594461(
    name: "databaseAccountsGetMongoDBCollectionThroughput",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/collections/{collectionName}/settings/throughput",
    validator: validate_DatabaseAccountsGetMongoDBCollectionThroughput_594462,
    base: "", url: url_DatabaseAccountsGetMongoDBCollectionThroughput_594463,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateMongoDBDatabaseThroughput_594501 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsUpdateMongoDBDatabaseThroughput_594503(protocol: Scheme;
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

proc validate_DatabaseAccountsUpdateMongoDBDatabaseThroughput_594502(
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
  var valid_594504 = path.getOrDefault("resourceGroupName")
  valid_594504 = validateParameter(valid_594504, JString, required = true,
                                 default = nil)
  if valid_594504 != nil:
    section.add "resourceGroupName", valid_594504
  var valid_594505 = path.getOrDefault("subscriptionId")
  valid_594505 = validateParameter(valid_594505, JString, required = true,
                                 default = nil)
  if valid_594505 != nil:
    section.add "subscriptionId", valid_594505
  var valid_594506 = path.getOrDefault("databaseName")
  valid_594506 = validateParameter(valid_594506, JString, required = true,
                                 default = nil)
  if valid_594506 != nil:
    section.add "databaseName", valid_594506
  var valid_594507 = path.getOrDefault("accountName")
  valid_594507 = validateParameter(valid_594507, JString, required = true,
                                 default = nil)
  if valid_594507 != nil:
    section.add "accountName", valid_594507
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594508 = query.getOrDefault("api-version")
  valid_594508 = validateParameter(valid_594508, JString, required = true,
                                 default = nil)
  if valid_594508 != nil:
    section.add "api-version", valid_594508
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

proc call*(call_594510: Call_DatabaseAccountsUpdateMongoDBDatabaseThroughput_594501;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of the an Azure Cosmos DB MongoDB database
  ## 
  let valid = call_594510.validator(path, query, header, formData, body)
  let scheme = call_594510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594510.url(scheme.get, call_594510.host, call_594510.base,
                         call_594510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594510, url, valid)

proc call*(call_594511: Call_DatabaseAccountsUpdateMongoDBDatabaseThroughput_594501;
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
  var path_594512 = newJObject()
  var query_594513 = newJObject()
  var body_594514 = newJObject()
  add(path_594512, "resourceGroupName", newJString(resourceGroupName))
  add(query_594513, "api-version", newJString(apiVersion))
  add(path_594512, "subscriptionId", newJString(subscriptionId))
  add(path_594512, "databaseName", newJString(databaseName))
  if updateThroughputParameters != nil:
    body_594514 = updateThroughputParameters
  add(path_594512, "accountName", newJString(accountName))
  result = call_594511.call(path_594512, query_594513, nil, nil, body_594514)

var databaseAccountsUpdateMongoDBDatabaseThroughput* = Call_DatabaseAccountsUpdateMongoDBDatabaseThroughput_594501(
    name: "databaseAccountsUpdateMongoDBDatabaseThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateMongoDBDatabaseThroughput_594502,
    base: "", url: url_DatabaseAccountsUpdateMongoDBDatabaseThroughput_594503,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetMongoDBDatabaseThroughput_594489 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsGetMongoDBDatabaseThroughput_594491(protocol: Scheme;
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

proc validate_DatabaseAccountsGetMongoDBDatabaseThroughput_594490(path: JsonNode;
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
  var valid_594492 = path.getOrDefault("resourceGroupName")
  valid_594492 = validateParameter(valid_594492, JString, required = true,
                                 default = nil)
  if valid_594492 != nil:
    section.add "resourceGroupName", valid_594492
  var valid_594493 = path.getOrDefault("subscriptionId")
  valid_594493 = validateParameter(valid_594493, JString, required = true,
                                 default = nil)
  if valid_594493 != nil:
    section.add "subscriptionId", valid_594493
  var valid_594494 = path.getOrDefault("databaseName")
  valid_594494 = validateParameter(valid_594494, JString, required = true,
                                 default = nil)
  if valid_594494 != nil:
    section.add "databaseName", valid_594494
  var valid_594495 = path.getOrDefault("accountName")
  valid_594495 = validateParameter(valid_594495, JString, required = true,
                                 default = nil)
  if valid_594495 != nil:
    section.add "accountName", valid_594495
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594496 = query.getOrDefault("api-version")
  valid_594496 = validateParameter(valid_594496, JString, required = true,
                                 default = nil)
  if valid_594496 != nil:
    section.add "api-version", valid_594496
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594497: Call_DatabaseAccountsGetMongoDBDatabaseThroughput_594489;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the MongoDB database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_594497.validator(path, query, header, formData, body)
  let scheme = call_594497.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594497.url(scheme.get, call_594497.host, call_594497.base,
                         call_594497.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594497, url, valid)

proc call*(call_594498: Call_DatabaseAccountsGetMongoDBDatabaseThroughput_594489;
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
  var path_594499 = newJObject()
  var query_594500 = newJObject()
  add(path_594499, "resourceGroupName", newJString(resourceGroupName))
  add(query_594500, "api-version", newJString(apiVersion))
  add(path_594499, "subscriptionId", newJString(subscriptionId))
  add(path_594499, "databaseName", newJString(databaseName))
  add(path_594499, "accountName", newJString(accountName))
  result = call_594498.call(path_594499, query_594500, nil, nil, nil)

var databaseAccountsGetMongoDBDatabaseThroughput* = Call_DatabaseAccountsGetMongoDBDatabaseThroughput_594489(
    name: "databaseAccountsGetMongoDBDatabaseThroughput",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/mongodb/databases/{databaseName}/settings/throughput",
    validator: validate_DatabaseAccountsGetMongoDBDatabaseThroughput_594490,
    base: "", url: url_DatabaseAccountsGetMongoDBDatabaseThroughput_594491,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListSqlDatabases_594515 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsListSqlDatabases_594517(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListSqlDatabases_594516(path: JsonNode;
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
  var valid_594518 = path.getOrDefault("resourceGroupName")
  valid_594518 = validateParameter(valid_594518, JString, required = true,
                                 default = nil)
  if valid_594518 != nil:
    section.add "resourceGroupName", valid_594518
  var valid_594519 = path.getOrDefault("subscriptionId")
  valid_594519 = validateParameter(valid_594519, JString, required = true,
                                 default = nil)
  if valid_594519 != nil:
    section.add "subscriptionId", valid_594519
  var valid_594520 = path.getOrDefault("accountName")
  valid_594520 = validateParameter(valid_594520, JString, required = true,
                                 default = nil)
  if valid_594520 != nil:
    section.add "accountName", valid_594520
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594521 = query.getOrDefault("api-version")
  valid_594521 = validateParameter(valid_594521, JString, required = true,
                                 default = nil)
  if valid_594521 != nil:
    section.add "api-version", valid_594521
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594522: Call_DatabaseAccountsListSqlDatabases_594515;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the SQL databases under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_594522.validator(path, query, header, formData, body)
  let scheme = call_594522.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594522.url(scheme.get, call_594522.host, call_594522.base,
                         call_594522.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594522, url, valid)

proc call*(call_594523: Call_DatabaseAccountsListSqlDatabases_594515;
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
  var path_594524 = newJObject()
  var query_594525 = newJObject()
  add(path_594524, "resourceGroupName", newJString(resourceGroupName))
  add(query_594525, "api-version", newJString(apiVersion))
  add(path_594524, "subscriptionId", newJString(subscriptionId))
  add(path_594524, "accountName", newJString(accountName))
  result = call_594523.call(path_594524, query_594525, nil, nil, nil)

var databaseAccountsListSqlDatabases* = Call_DatabaseAccountsListSqlDatabases_594515(
    name: "databaseAccountsListSqlDatabases", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases",
    validator: validate_DatabaseAccountsListSqlDatabases_594516, base: "",
    url: url_DatabaseAccountsListSqlDatabases_594517, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateSqlDatabase_594538 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsCreateUpdateSqlDatabase_594540(protocol: Scheme;
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

proc validate_DatabaseAccountsCreateUpdateSqlDatabase_594539(path: JsonNode;
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
  var valid_594541 = path.getOrDefault("resourceGroupName")
  valid_594541 = validateParameter(valid_594541, JString, required = true,
                                 default = nil)
  if valid_594541 != nil:
    section.add "resourceGroupName", valid_594541
  var valid_594542 = path.getOrDefault("subscriptionId")
  valid_594542 = validateParameter(valid_594542, JString, required = true,
                                 default = nil)
  if valid_594542 != nil:
    section.add "subscriptionId", valid_594542
  var valid_594543 = path.getOrDefault("databaseName")
  valid_594543 = validateParameter(valid_594543, JString, required = true,
                                 default = nil)
  if valid_594543 != nil:
    section.add "databaseName", valid_594543
  var valid_594544 = path.getOrDefault("accountName")
  valid_594544 = validateParameter(valid_594544, JString, required = true,
                                 default = nil)
  if valid_594544 != nil:
    section.add "accountName", valid_594544
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594545 = query.getOrDefault("api-version")
  valid_594545 = validateParameter(valid_594545, JString, required = true,
                                 default = nil)
  if valid_594545 != nil:
    section.add "api-version", valid_594545
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

proc call*(call_594547: Call_DatabaseAccountsCreateUpdateSqlDatabase_594538;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB SQL database
  ## 
  let valid = call_594547.validator(path, query, header, formData, body)
  let scheme = call_594547.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594547.url(scheme.get, call_594547.host, call_594547.base,
                         call_594547.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594547, url, valid)

proc call*(call_594548: Call_DatabaseAccountsCreateUpdateSqlDatabase_594538;
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
  var path_594549 = newJObject()
  var query_594550 = newJObject()
  var body_594551 = newJObject()
  if createUpdateSqlDatabaseParameters != nil:
    body_594551 = createUpdateSqlDatabaseParameters
  add(path_594549, "resourceGroupName", newJString(resourceGroupName))
  add(query_594550, "api-version", newJString(apiVersion))
  add(path_594549, "subscriptionId", newJString(subscriptionId))
  add(path_594549, "databaseName", newJString(databaseName))
  add(path_594549, "accountName", newJString(accountName))
  result = call_594548.call(path_594549, query_594550, nil, nil, body_594551)

var databaseAccountsCreateUpdateSqlDatabase* = Call_DatabaseAccountsCreateUpdateSqlDatabase_594538(
    name: "databaseAccountsCreateUpdateSqlDatabase", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}",
    validator: validate_DatabaseAccountsCreateUpdateSqlDatabase_594539, base: "",
    url: url_DatabaseAccountsCreateUpdateSqlDatabase_594540,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetSqlDatabase_594526 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsGetSqlDatabase_594528(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsGetSqlDatabase_594527(path: JsonNode;
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
  var valid_594529 = path.getOrDefault("resourceGroupName")
  valid_594529 = validateParameter(valid_594529, JString, required = true,
                                 default = nil)
  if valid_594529 != nil:
    section.add "resourceGroupName", valid_594529
  var valid_594530 = path.getOrDefault("subscriptionId")
  valid_594530 = validateParameter(valid_594530, JString, required = true,
                                 default = nil)
  if valid_594530 != nil:
    section.add "subscriptionId", valid_594530
  var valid_594531 = path.getOrDefault("databaseName")
  valid_594531 = validateParameter(valid_594531, JString, required = true,
                                 default = nil)
  if valid_594531 != nil:
    section.add "databaseName", valid_594531
  var valid_594532 = path.getOrDefault("accountName")
  valid_594532 = validateParameter(valid_594532, JString, required = true,
                                 default = nil)
  if valid_594532 != nil:
    section.add "accountName", valid_594532
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594533 = query.getOrDefault("api-version")
  valid_594533 = validateParameter(valid_594533, JString, required = true,
                                 default = nil)
  if valid_594533 != nil:
    section.add "api-version", valid_594533
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594534: Call_DatabaseAccountsGetSqlDatabase_594526; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the SQL database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_594534.validator(path, query, header, formData, body)
  let scheme = call_594534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594534.url(scheme.get, call_594534.host, call_594534.base,
                         call_594534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594534, url, valid)

proc call*(call_594535: Call_DatabaseAccountsGetSqlDatabase_594526;
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
  var path_594536 = newJObject()
  var query_594537 = newJObject()
  add(path_594536, "resourceGroupName", newJString(resourceGroupName))
  add(query_594537, "api-version", newJString(apiVersion))
  add(path_594536, "subscriptionId", newJString(subscriptionId))
  add(path_594536, "databaseName", newJString(databaseName))
  add(path_594536, "accountName", newJString(accountName))
  result = call_594535.call(path_594536, query_594537, nil, nil, nil)

var databaseAccountsGetSqlDatabase* = Call_DatabaseAccountsGetSqlDatabase_594526(
    name: "databaseAccountsGetSqlDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}",
    validator: validate_DatabaseAccountsGetSqlDatabase_594527, base: "",
    url: url_DatabaseAccountsGetSqlDatabase_594528, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteSqlDatabase_594552 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsDeleteSqlDatabase_594554(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsDeleteSqlDatabase_594553(path: JsonNode;
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
  var valid_594555 = path.getOrDefault("resourceGroupName")
  valid_594555 = validateParameter(valid_594555, JString, required = true,
                                 default = nil)
  if valid_594555 != nil:
    section.add "resourceGroupName", valid_594555
  var valid_594556 = path.getOrDefault("subscriptionId")
  valid_594556 = validateParameter(valid_594556, JString, required = true,
                                 default = nil)
  if valid_594556 != nil:
    section.add "subscriptionId", valid_594556
  var valid_594557 = path.getOrDefault("databaseName")
  valid_594557 = validateParameter(valid_594557, JString, required = true,
                                 default = nil)
  if valid_594557 != nil:
    section.add "databaseName", valid_594557
  var valid_594558 = path.getOrDefault("accountName")
  valid_594558 = validateParameter(valid_594558, JString, required = true,
                                 default = nil)
  if valid_594558 != nil:
    section.add "accountName", valid_594558
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594559 = query.getOrDefault("api-version")
  valid_594559 = validateParameter(valid_594559, JString, required = true,
                                 default = nil)
  if valid_594559 != nil:
    section.add "api-version", valid_594559
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594560: Call_DatabaseAccountsDeleteSqlDatabase_594552;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB SQL database.
  ## 
  let valid = call_594560.validator(path, query, header, formData, body)
  let scheme = call_594560.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594560.url(scheme.get, call_594560.host, call_594560.base,
                         call_594560.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594560, url, valid)

proc call*(call_594561: Call_DatabaseAccountsDeleteSqlDatabase_594552;
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
  var path_594562 = newJObject()
  var query_594563 = newJObject()
  add(path_594562, "resourceGroupName", newJString(resourceGroupName))
  add(query_594563, "api-version", newJString(apiVersion))
  add(path_594562, "subscriptionId", newJString(subscriptionId))
  add(path_594562, "databaseName", newJString(databaseName))
  add(path_594562, "accountName", newJString(accountName))
  result = call_594561.call(path_594562, query_594563, nil, nil, nil)

var databaseAccountsDeleteSqlDatabase* = Call_DatabaseAccountsDeleteSqlDatabase_594552(
    name: "databaseAccountsDeleteSqlDatabase", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}",
    validator: validate_DatabaseAccountsDeleteSqlDatabase_594553, base: "",
    url: url_DatabaseAccountsDeleteSqlDatabase_594554, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListSqlContainers_594564 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsListSqlContainers_594566(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListSqlContainers_594565(path: JsonNode;
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
  var valid_594567 = path.getOrDefault("resourceGroupName")
  valid_594567 = validateParameter(valid_594567, JString, required = true,
                                 default = nil)
  if valid_594567 != nil:
    section.add "resourceGroupName", valid_594567
  var valid_594568 = path.getOrDefault("subscriptionId")
  valid_594568 = validateParameter(valid_594568, JString, required = true,
                                 default = nil)
  if valid_594568 != nil:
    section.add "subscriptionId", valid_594568
  var valid_594569 = path.getOrDefault("databaseName")
  valid_594569 = validateParameter(valid_594569, JString, required = true,
                                 default = nil)
  if valid_594569 != nil:
    section.add "databaseName", valid_594569
  var valid_594570 = path.getOrDefault("accountName")
  valid_594570 = validateParameter(valid_594570, JString, required = true,
                                 default = nil)
  if valid_594570 != nil:
    section.add "accountName", valid_594570
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594571 = query.getOrDefault("api-version")
  valid_594571 = validateParameter(valid_594571, JString, required = true,
                                 default = nil)
  if valid_594571 != nil:
    section.add "api-version", valid_594571
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594572: Call_DatabaseAccountsListSqlContainers_594564;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the SQL container under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_594572.validator(path, query, header, formData, body)
  let scheme = call_594572.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594572.url(scheme.get, call_594572.host, call_594572.base,
                         call_594572.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594572, url, valid)

proc call*(call_594573: Call_DatabaseAccountsListSqlContainers_594564;
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
  var path_594574 = newJObject()
  var query_594575 = newJObject()
  add(path_594574, "resourceGroupName", newJString(resourceGroupName))
  add(query_594575, "api-version", newJString(apiVersion))
  add(path_594574, "subscriptionId", newJString(subscriptionId))
  add(path_594574, "databaseName", newJString(databaseName))
  add(path_594574, "accountName", newJString(accountName))
  result = call_594573.call(path_594574, query_594575, nil, nil, nil)

var databaseAccountsListSqlContainers* = Call_DatabaseAccountsListSqlContainers_594564(
    name: "databaseAccountsListSqlContainers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/containers",
    validator: validate_DatabaseAccountsListSqlContainers_594565, base: "",
    url: url_DatabaseAccountsListSqlContainers_594566, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateSqlContainer_594589 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsCreateUpdateSqlContainer_594591(protocol: Scheme;
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

proc validate_DatabaseAccountsCreateUpdateSqlContainer_594590(path: JsonNode;
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
  var valid_594592 = path.getOrDefault("resourceGroupName")
  valid_594592 = validateParameter(valid_594592, JString, required = true,
                                 default = nil)
  if valid_594592 != nil:
    section.add "resourceGroupName", valid_594592
  var valid_594593 = path.getOrDefault("containerName")
  valid_594593 = validateParameter(valid_594593, JString, required = true,
                                 default = nil)
  if valid_594593 != nil:
    section.add "containerName", valid_594593
  var valid_594594 = path.getOrDefault("subscriptionId")
  valid_594594 = validateParameter(valid_594594, JString, required = true,
                                 default = nil)
  if valid_594594 != nil:
    section.add "subscriptionId", valid_594594
  var valid_594595 = path.getOrDefault("databaseName")
  valid_594595 = validateParameter(valid_594595, JString, required = true,
                                 default = nil)
  if valid_594595 != nil:
    section.add "databaseName", valid_594595
  var valid_594596 = path.getOrDefault("accountName")
  valid_594596 = validateParameter(valid_594596, JString, required = true,
                                 default = nil)
  if valid_594596 != nil:
    section.add "accountName", valid_594596
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594597 = query.getOrDefault("api-version")
  valid_594597 = validateParameter(valid_594597, JString, required = true,
                                 default = nil)
  if valid_594597 != nil:
    section.add "api-version", valid_594597
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

proc call*(call_594599: Call_DatabaseAccountsCreateUpdateSqlContainer_594589;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB SQL container
  ## 
  let valid = call_594599.validator(path, query, header, formData, body)
  let scheme = call_594599.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594599.url(scheme.get, call_594599.host, call_594599.base,
                         call_594599.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594599, url, valid)

proc call*(call_594600: Call_DatabaseAccountsCreateUpdateSqlContainer_594589;
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
  var path_594601 = newJObject()
  var query_594602 = newJObject()
  var body_594603 = newJObject()
  if createUpdateSqlContainerParameters != nil:
    body_594603 = createUpdateSqlContainerParameters
  add(path_594601, "resourceGroupName", newJString(resourceGroupName))
  add(query_594602, "api-version", newJString(apiVersion))
  add(path_594601, "containerName", newJString(containerName))
  add(path_594601, "subscriptionId", newJString(subscriptionId))
  add(path_594601, "databaseName", newJString(databaseName))
  add(path_594601, "accountName", newJString(accountName))
  result = call_594600.call(path_594601, query_594602, nil, nil, body_594603)

var databaseAccountsCreateUpdateSqlContainer* = Call_DatabaseAccountsCreateUpdateSqlContainer_594589(
    name: "databaseAccountsCreateUpdateSqlContainer", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/containers/{containerName}",
    validator: validate_DatabaseAccountsCreateUpdateSqlContainer_594590, base: "",
    url: url_DatabaseAccountsCreateUpdateSqlContainer_594591,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetSqlContainer_594576 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsGetSqlContainer_594578(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsGetSqlContainer_594577(path: JsonNode;
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
  var valid_594579 = path.getOrDefault("resourceGroupName")
  valid_594579 = validateParameter(valid_594579, JString, required = true,
                                 default = nil)
  if valid_594579 != nil:
    section.add "resourceGroupName", valid_594579
  var valid_594580 = path.getOrDefault("containerName")
  valid_594580 = validateParameter(valid_594580, JString, required = true,
                                 default = nil)
  if valid_594580 != nil:
    section.add "containerName", valid_594580
  var valid_594581 = path.getOrDefault("subscriptionId")
  valid_594581 = validateParameter(valid_594581, JString, required = true,
                                 default = nil)
  if valid_594581 != nil:
    section.add "subscriptionId", valid_594581
  var valid_594582 = path.getOrDefault("databaseName")
  valid_594582 = validateParameter(valid_594582, JString, required = true,
                                 default = nil)
  if valid_594582 != nil:
    section.add "databaseName", valid_594582
  var valid_594583 = path.getOrDefault("accountName")
  valid_594583 = validateParameter(valid_594583, JString, required = true,
                                 default = nil)
  if valid_594583 != nil:
    section.add "accountName", valid_594583
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594584 = query.getOrDefault("api-version")
  valid_594584 = validateParameter(valid_594584, JString, required = true,
                                 default = nil)
  if valid_594584 != nil:
    section.add "api-version", valid_594584
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594585: Call_DatabaseAccountsGetSqlContainer_594576;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the SQL container under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_594585.validator(path, query, header, formData, body)
  let scheme = call_594585.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594585.url(scheme.get, call_594585.host, call_594585.base,
                         call_594585.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594585, url, valid)

proc call*(call_594586: Call_DatabaseAccountsGetSqlContainer_594576;
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
  var path_594587 = newJObject()
  var query_594588 = newJObject()
  add(path_594587, "resourceGroupName", newJString(resourceGroupName))
  add(query_594588, "api-version", newJString(apiVersion))
  add(path_594587, "containerName", newJString(containerName))
  add(path_594587, "subscriptionId", newJString(subscriptionId))
  add(path_594587, "databaseName", newJString(databaseName))
  add(path_594587, "accountName", newJString(accountName))
  result = call_594586.call(path_594587, query_594588, nil, nil, nil)

var databaseAccountsGetSqlContainer* = Call_DatabaseAccountsGetSqlContainer_594576(
    name: "databaseAccountsGetSqlContainer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/containers/{containerName}",
    validator: validate_DatabaseAccountsGetSqlContainer_594577, base: "",
    url: url_DatabaseAccountsGetSqlContainer_594578, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteSqlContainer_594604 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsDeleteSqlContainer_594606(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsDeleteSqlContainer_594605(path: JsonNode;
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
  var valid_594607 = path.getOrDefault("resourceGroupName")
  valid_594607 = validateParameter(valid_594607, JString, required = true,
                                 default = nil)
  if valid_594607 != nil:
    section.add "resourceGroupName", valid_594607
  var valid_594608 = path.getOrDefault("containerName")
  valid_594608 = validateParameter(valid_594608, JString, required = true,
                                 default = nil)
  if valid_594608 != nil:
    section.add "containerName", valid_594608
  var valid_594609 = path.getOrDefault("subscriptionId")
  valid_594609 = validateParameter(valid_594609, JString, required = true,
                                 default = nil)
  if valid_594609 != nil:
    section.add "subscriptionId", valid_594609
  var valid_594610 = path.getOrDefault("databaseName")
  valid_594610 = validateParameter(valid_594610, JString, required = true,
                                 default = nil)
  if valid_594610 != nil:
    section.add "databaseName", valid_594610
  var valid_594611 = path.getOrDefault("accountName")
  valid_594611 = validateParameter(valid_594611, JString, required = true,
                                 default = nil)
  if valid_594611 != nil:
    section.add "accountName", valid_594611
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594612 = query.getOrDefault("api-version")
  valid_594612 = validateParameter(valid_594612, JString, required = true,
                                 default = nil)
  if valid_594612 != nil:
    section.add "api-version", valid_594612
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594613: Call_DatabaseAccountsDeleteSqlContainer_594604;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB SQL container.
  ## 
  let valid = call_594613.validator(path, query, header, formData, body)
  let scheme = call_594613.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594613.url(scheme.get, call_594613.host, call_594613.base,
                         call_594613.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594613, url, valid)

proc call*(call_594614: Call_DatabaseAccountsDeleteSqlContainer_594604;
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
  var path_594615 = newJObject()
  var query_594616 = newJObject()
  add(path_594615, "resourceGroupName", newJString(resourceGroupName))
  add(query_594616, "api-version", newJString(apiVersion))
  add(path_594615, "containerName", newJString(containerName))
  add(path_594615, "subscriptionId", newJString(subscriptionId))
  add(path_594615, "databaseName", newJString(databaseName))
  add(path_594615, "accountName", newJString(accountName))
  result = call_594614.call(path_594615, query_594616, nil, nil, nil)

var databaseAccountsDeleteSqlContainer* = Call_DatabaseAccountsDeleteSqlContainer_594604(
    name: "databaseAccountsDeleteSqlContainer", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/containers/{containerName}",
    validator: validate_DatabaseAccountsDeleteSqlContainer_594605, base: "",
    url: url_DatabaseAccountsDeleteSqlContainer_594606, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateSqlContainerThroughput_594630 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsUpdateSqlContainerThroughput_594632(protocol: Scheme;
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

proc validate_DatabaseAccountsUpdateSqlContainerThroughput_594631(path: JsonNode;
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
  var valid_594633 = path.getOrDefault("resourceGroupName")
  valid_594633 = validateParameter(valid_594633, JString, required = true,
                                 default = nil)
  if valid_594633 != nil:
    section.add "resourceGroupName", valid_594633
  var valid_594634 = path.getOrDefault("containerName")
  valid_594634 = validateParameter(valid_594634, JString, required = true,
                                 default = nil)
  if valid_594634 != nil:
    section.add "containerName", valid_594634
  var valid_594635 = path.getOrDefault("subscriptionId")
  valid_594635 = validateParameter(valid_594635, JString, required = true,
                                 default = nil)
  if valid_594635 != nil:
    section.add "subscriptionId", valid_594635
  var valid_594636 = path.getOrDefault("databaseName")
  valid_594636 = validateParameter(valid_594636, JString, required = true,
                                 default = nil)
  if valid_594636 != nil:
    section.add "databaseName", valid_594636
  var valid_594637 = path.getOrDefault("accountName")
  valid_594637 = validateParameter(valid_594637, JString, required = true,
                                 default = nil)
  if valid_594637 != nil:
    section.add "accountName", valid_594637
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594638 = query.getOrDefault("api-version")
  valid_594638 = validateParameter(valid_594638, JString, required = true,
                                 default = nil)
  if valid_594638 != nil:
    section.add "api-version", valid_594638
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

proc call*(call_594640: Call_DatabaseAccountsUpdateSqlContainerThroughput_594630;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB SQL container
  ## 
  let valid = call_594640.validator(path, query, header, formData, body)
  let scheme = call_594640.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594640.url(scheme.get, call_594640.host, call_594640.base,
                         call_594640.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594640, url, valid)

proc call*(call_594641: Call_DatabaseAccountsUpdateSqlContainerThroughput_594630;
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
  var path_594642 = newJObject()
  var query_594643 = newJObject()
  var body_594644 = newJObject()
  add(path_594642, "resourceGroupName", newJString(resourceGroupName))
  add(query_594643, "api-version", newJString(apiVersion))
  add(path_594642, "containerName", newJString(containerName))
  add(path_594642, "subscriptionId", newJString(subscriptionId))
  add(path_594642, "databaseName", newJString(databaseName))
  if updateThroughputParameters != nil:
    body_594644 = updateThroughputParameters
  add(path_594642, "accountName", newJString(accountName))
  result = call_594641.call(path_594642, query_594643, nil, nil, body_594644)

var databaseAccountsUpdateSqlContainerThroughput* = Call_DatabaseAccountsUpdateSqlContainerThroughput_594630(
    name: "databaseAccountsUpdateSqlContainerThroughput",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/containers/{containerName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateSqlContainerThroughput_594631,
    base: "", url: url_DatabaseAccountsUpdateSqlContainerThroughput_594632,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetSqlContainerThroughput_594617 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsGetSqlContainerThroughput_594619(protocol: Scheme;
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

proc validate_DatabaseAccountsGetSqlContainerThroughput_594618(path: JsonNode;
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
  var valid_594620 = path.getOrDefault("resourceGroupName")
  valid_594620 = validateParameter(valid_594620, JString, required = true,
                                 default = nil)
  if valid_594620 != nil:
    section.add "resourceGroupName", valid_594620
  var valid_594621 = path.getOrDefault("containerName")
  valid_594621 = validateParameter(valid_594621, JString, required = true,
                                 default = nil)
  if valid_594621 != nil:
    section.add "containerName", valid_594621
  var valid_594622 = path.getOrDefault("subscriptionId")
  valid_594622 = validateParameter(valid_594622, JString, required = true,
                                 default = nil)
  if valid_594622 != nil:
    section.add "subscriptionId", valid_594622
  var valid_594623 = path.getOrDefault("databaseName")
  valid_594623 = validateParameter(valid_594623, JString, required = true,
                                 default = nil)
  if valid_594623 != nil:
    section.add "databaseName", valid_594623
  var valid_594624 = path.getOrDefault("accountName")
  valid_594624 = validateParameter(valid_594624, JString, required = true,
                                 default = nil)
  if valid_594624 != nil:
    section.add "accountName", valid_594624
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594625 = query.getOrDefault("api-version")
  valid_594625 = validateParameter(valid_594625, JString, required = true,
                                 default = nil)
  if valid_594625 != nil:
    section.add "api-version", valid_594625
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594626: Call_DatabaseAccountsGetSqlContainerThroughput_594617;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the SQL container under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_594626.validator(path, query, header, formData, body)
  let scheme = call_594626.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594626.url(scheme.get, call_594626.host, call_594626.base,
                         call_594626.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594626, url, valid)

proc call*(call_594627: Call_DatabaseAccountsGetSqlContainerThroughput_594617;
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
  var path_594628 = newJObject()
  var query_594629 = newJObject()
  add(path_594628, "resourceGroupName", newJString(resourceGroupName))
  add(query_594629, "api-version", newJString(apiVersion))
  add(path_594628, "containerName", newJString(containerName))
  add(path_594628, "subscriptionId", newJString(subscriptionId))
  add(path_594628, "databaseName", newJString(databaseName))
  add(path_594628, "accountName", newJString(accountName))
  result = call_594627.call(path_594628, query_594629, nil, nil, nil)

var databaseAccountsGetSqlContainerThroughput* = Call_DatabaseAccountsGetSqlContainerThroughput_594617(
    name: "databaseAccountsGetSqlContainerThroughput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/containers/{containerName}/settings/throughput",
    validator: validate_DatabaseAccountsGetSqlContainerThroughput_594618,
    base: "", url: url_DatabaseAccountsGetSqlContainerThroughput_594619,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateSqlDatabaseThroughput_594657 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsUpdateSqlDatabaseThroughput_594659(protocol: Scheme;
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

proc validate_DatabaseAccountsUpdateSqlDatabaseThroughput_594658(path: JsonNode;
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
  var valid_594660 = path.getOrDefault("resourceGroupName")
  valid_594660 = validateParameter(valid_594660, JString, required = true,
                                 default = nil)
  if valid_594660 != nil:
    section.add "resourceGroupName", valid_594660
  var valid_594661 = path.getOrDefault("subscriptionId")
  valid_594661 = validateParameter(valid_594661, JString, required = true,
                                 default = nil)
  if valid_594661 != nil:
    section.add "subscriptionId", valid_594661
  var valid_594662 = path.getOrDefault("databaseName")
  valid_594662 = validateParameter(valid_594662, JString, required = true,
                                 default = nil)
  if valid_594662 != nil:
    section.add "databaseName", valid_594662
  var valid_594663 = path.getOrDefault("accountName")
  valid_594663 = validateParameter(valid_594663, JString, required = true,
                                 default = nil)
  if valid_594663 != nil:
    section.add "accountName", valid_594663
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594664 = query.getOrDefault("api-version")
  valid_594664 = validateParameter(valid_594664, JString, required = true,
                                 default = nil)
  if valid_594664 != nil:
    section.add "api-version", valid_594664
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

proc call*(call_594666: Call_DatabaseAccountsUpdateSqlDatabaseThroughput_594657;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB SQL database
  ## 
  let valid = call_594666.validator(path, query, header, formData, body)
  let scheme = call_594666.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594666.url(scheme.get, call_594666.host, call_594666.base,
                         call_594666.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594666, url, valid)

proc call*(call_594667: Call_DatabaseAccountsUpdateSqlDatabaseThroughput_594657;
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
  var path_594668 = newJObject()
  var query_594669 = newJObject()
  var body_594670 = newJObject()
  add(path_594668, "resourceGroupName", newJString(resourceGroupName))
  add(query_594669, "api-version", newJString(apiVersion))
  add(path_594668, "subscriptionId", newJString(subscriptionId))
  add(path_594668, "databaseName", newJString(databaseName))
  if updateThroughputParameters != nil:
    body_594670 = updateThroughputParameters
  add(path_594668, "accountName", newJString(accountName))
  result = call_594667.call(path_594668, query_594669, nil, nil, body_594670)

var databaseAccountsUpdateSqlDatabaseThroughput* = Call_DatabaseAccountsUpdateSqlDatabaseThroughput_594657(
    name: "databaseAccountsUpdateSqlDatabaseThroughput", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateSqlDatabaseThroughput_594658,
    base: "", url: url_DatabaseAccountsUpdateSqlDatabaseThroughput_594659,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetSqlDatabaseThroughput_594645 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsGetSqlDatabaseThroughput_594647(protocol: Scheme;
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

proc validate_DatabaseAccountsGetSqlDatabaseThroughput_594646(path: JsonNode;
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
  var valid_594648 = path.getOrDefault("resourceGroupName")
  valid_594648 = validateParameter(valid_594648, JString, required = true,
                                 default = nil)
  if valid_594648 != nil:
    section.add "resourceGroupName", valid_594648
  var valid_594649 = path.getOrDefault("subscriptionId")
  valid_594649 = validateParameter(valid_594649, JString, required = true,
                                 default = nil)
  if valid_594649 != nil:
    section.add "subscriptionId", valid_594649
  var valid_594650 = path.getOrDefault("databaseName")
  valid_594650 = validateParameter(valid_594650, JString, required = true,
                                 default = nil)
  if valid_594650 != nil:
    section.add "databaseName", valid_594650
  var valid_594651 = path.getOrDefault("accountName")
  valid_594651 = validateParameter(valid_594651, JString, required = true,
                                 default = nil)
  if valid_594651 != nil:
    section.add "accountName", valid_594651
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594652 = query.getOrDefault("api-version")
  valid_594652 = validateParameter(valid_594652, JString, required = true,
                                 default = nil)
  if valid_594652 != nil:
    section.add "api-version", valid_594652
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594653: Call_DatabaseAccountsGetSqlDatabaseThroughput_594645;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the SQL database under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_594653.validator(path, query, header, formData, body)
  let scheme = call_594653.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594653.url(scheme.get, call_594653.host, call_594653.base,
                         call_594653.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594653, url, valid)

proc call*(call_594654: Call_DatabaseAccountsGetSqlDatabaseThroughput_594645;
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
  var path_594655 = newJObject()
  var query_594656 = newJObject()
  add(path_594655, "resourceGroupName", newJString(resourceGroupName))
  add(query_594656, "api-version", newJString(apiVersion))
  add(path_594655, "subscriptionId", newJString(subscriptionId))
  add(path_594655, "databaseName", newJString(databaseName))
  add(path_594655, "accountName", newJString(accountName))
  result = call_594654.call(path_594655, query_594656, nil, nil, nil)

var databaseAccountsGetSqlDatabaseThroughput* = Call_DatabaseAccountsGetSqlDatabaseThroughput_594645(
    name: "databaseAccountsGetSqlDatabaseThroughput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/sql/databases/{databaseName}/settings/throughput",
    validator: validate_DatabaseAccountsGetSqlDatabaseThroughput_594646, base: "",
    url: url_DatabaseAccountsGetSqlDatabaseThroughput_594647,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListTables_594671 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsListTables_594673(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListTables_594672(path: JsonNode; query: JsonNode;
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
  var valid_594674 = path.getOrDefault("resourceGroupName")
  valid_594674 = validateParameter(valid_594674, JString, required = true,
                                 default = nil)
  if valid_594674 != nil:
    section.add "resourceGroupName", valid_594674
  var valid_594675 = path.getOrDefault("subscriptionId")
  valid_594675 = validateParameter(valid_594675, JString, required = true,
                                 default = nil)
  if valid_594675 != nil:
    section.add "subscriptionId", valid_594675
  var valid_594676 = path.getOrDefault("accountName")
  valid_594676 = validateParameter(valid_594676, JString, required = true,
                                 default = nil)
  if valid_594676 != nil:
    section.add "accountName", valid_594676
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594677 = query.getOrDefault("api-version")
  valid_594677 = validateParameter(valid_594677, JString, required = true,
                                 default = nil)
  if valid_594677 != nil:
    section.add "api-version", valid_594677
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594678: Call_DatabaseAccountsListTables_594671; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Tables under an existing Azure Cosmos DB database account.
  ## 
  let valid = call_594678.validator(path, query, header, formData, body)
  let scheme = call_594678.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594678.url(scheme.get, call_594678.host, call_594678.base,
                         call_594678.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594678, url, valid)

proc call*(call_594679: Call_DatabaseAccountsListTables_594671;
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
  var path_594680 = newJObject()
  var query_594681 = newJObject()
  add(path_594680, "resourceGroupName", newJString(resourceGroupName))
  add(query_594681, "api-version", newJString(apiVersion))
  add(path_594680, "subscriptionId", newJString(subscriptionId))
  add(path_594680, "accountName", newJString(accountName))
  result = call_594679.call(path_594680, query_594681, nil, nil, nil)

var databaseAccountsListTables* = Call_DatabaseAccountsListTables_594671(
    name: "databaseAccountsListTables", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/table/tables",
    validator: validate_DatabaseAccountsListTables_594672, base: "",
    url: url_DatabaseAccountsListTables_594673, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsCreateUpdateTable_594694 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsCreateUpdateTable_594696(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsCreateUpdateTable_594695(path: JsonNode;
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
  var valid_594697 = path.getOrDefault("resourceGroupName")
  valid_594697 = validateParameter(valid_594697, JString, required = true,
                                 default = nil)
  if valid_594697 != nil:
    section.add "resourceGroupName", valid_594697
  var valid_594698 = path.getOrDefault("subscriptionId")
  valid_594698 = validateParameter(valid_594698, JString, required = true,
                                 default = nil)
  if valid_594698 != nil:
    section.add "subscriptionId", valid_594698
  var valid_594699 = path.getOrDefault("tableName")
  valid_594699 = validateParameter(valid_594699, JString, required = true,
                                 default = nil)
  if valid_594699 != nil:
    section.add "tableName", valid_594699
  var valid_594700 = path.getOrDefault("accountName")
  valid_594700 = validateParameter(valid_594700, JString, required = true,
                                 default = nil)
  if valid_594700 != nil:
    section.add "accountName", valid_594700
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594701 = query.getOrDefault("api-version")
  valid_594701 = validateParameter(valid_594701, JString, required = true,
                                 default = nil)
  if valid_594701 != nil:
    section.add "api-version", valid_594701
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

proc call*(call_594703: Call_DatabaseAccountsCreateUpdateTable_594694;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an Azure Cosmos DB Table
  ## 
  let valid = call_594703.validator(path, query, header, formData, body)
  let scheme = call_594703.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594703.url(scheme.get, call_594703.host, call_594703.base,
                         call_594703.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594703, url, valid)

proc call*(call_594704: Call_DatabaseAccountsCreateUpdateTable_594694;
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
  var path_594705 = newJObject()
  var query_594706 = newJObject()
  var body_594707 = newJObject()
  add(path_594705, "resourceGroupName", newJString(resourceGroupName))
  add(query_594706, "api-version", newJString(apiVersion))
  add(path_594705, "subscriptionId", newJString(subscriptionId))
  add(path_594705, "tableName", newJString(tableName))
  if createUpdateTableParameters != nil:
    body_594707 = createUpdateTableParameters
  add(path_594705, "accountName", newJString(accountName))
  result = call_594704.call(path_594705, query_594706, nil, nil, body_594707)

var databaseAccountsCreateUpdateTable* = Call_DatabaseAccountsCreateUpdateTable_594694(
    name: "databaseAccountsCreateUpdateTable", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/table/tables/{tableName}",
    validator: validate_DatabaseAccountsCreateUpdateTable_594695, base: "",
    url: url_DatabaseAccountsCreateUpdateTable_594696, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetTable_594682 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsGetTable_594684(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsGetTable_594683(path: JsonNode; query: JsonNode;
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
  var valid_594685 = path.getOrDefault("resourceGroupName")
  valid_594685 = validateParameter(valid_594685, JString, required = true,
                                 default = nil)
  if valid_594685 != nil:
    section.add "resourceGroupName", valid_594685
  var valid_594686 = path.getOrDefault("subscriptionId")
  valid_594686 = validateParameter(valid_594686, JString, required = true,
                                 default = nil)
  if valid_594686 != nil:
    section.add "subscriptionId", valid_594686
  var valid_594687 = path.getOrDefault("tableName")
  valid_594687 = validateParameter(valid_594687, JString, required = true,
                                 default = nil)
  if valid_594687 != nil:
    section.add "tableName", valid_594687
  var valid_594688 = path.getOrDefault("accountName")
  valid_594688 = validateParameter(valid_594688, JString, required = true,
                                 default = nil)
  if valid_594688 != nil:
    section.add "accountName", valid_594688
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594689 = query.getOrDefault("api-version")
  valid_594689 = validateParameter(valid_594689, JString, required = true,
                                 default = nil)
  if valid_594689 != nil:
    section.add "api-version", valid_594689
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594690: Call_DatabaseAccountsGetTable_594682; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Tables under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_594690.validator(path, query, header, formData, body)
  let scheme = call_594690.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594690.url(scheme.get, call_594690.host, call_594690.base,
                         call_594690.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594690, url, valid)

proc call*(call_594691: Call_DatabaseAccountsGetTable_594682;
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
  var path_594692 = newJObject()
  var query_594693 = newJObject()
  add(path_594692, "resourceGroupName", newJString(resourceGroupName))
  add(query_594693, "api-version", newJString(apiVersion))
  add(path_594692, "subscriptionId", newJString(subscriptionId))
  add(path_594692, "tableName", newJString(tableName))
  add(path_594692, "accountName", newJString(accountName))
  result = call_594691.call(path_594692, query_594693, nil, nil, nil)

var databaseAccountsGetTable* = Call_DatabaseAccountsGetTable_594682(
    name: "databaseAccountsGetTable", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/table/tables/{tableName}",
    validator: validate_DatabaseAccountsGetTable_594683, base: "",
    url: url_DatabaseAccountsGetTable_594684, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsDeleteTable_594708 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsDeleteTable_594710(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsDeleteTable_594709(path: JsonNode; query: JsonNode;
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
  var valid_594711 = path.getOrDefault("resourceGroupName")
  valid_594711 = validateParameter(valid_594711, JString, required = true,
                                 default = nil)
  if valid_594711 != nil:
    section.add "resourceGroupName", valid_594711
  var valid_594712 = path.getOrDefault("subscriptionId")
  valid_594712 = validateParameter(valid_594712, JString, required = true,
                                 default = nil)
  if valid_594712 != nil:
    section.add "subscriptionId", valid_594712
  var valid_594713 = path.getOrDefault("tableName")
  valid_594713 = validateParameter(valid_594713, JString, required = true,
                                 default = nil)
  if valid_594713 != nil:
    section.add "tableName", valid_594713
  var valid_594714 = path.getOrDefault("accountName")
  valid_594714 = validateParameter(valid_594714, JString, required = true,
                                 default = nil)
  if valid_594714 != nil:
    section.add "accountName", valid_594714
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594715 = query.getOrDefault("api-version")
  valid_594715 = validateParameter(valid_594715, JString, required = true,
                                 default = nil)
  if valid_594715 != nil:
    section.add "api-version", valid_594715
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594716: Call_DatabaseAccountsDeleteTable_594708; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Azure Cosmos DB Table.
  ## 
  let valid = call_594716.validator(path, query, header, formData, body)
  let scheme = call_594716.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594716.url(scheme.get, call_594716.host, call_594716.base,
                         call_594716.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594716, url, valid)

proc call*(call_594717: Call_DatabaseAccountsDeleteTable_594708;
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
  var path_594718 = newJObject()
  var query_594719 = newJObject()
  add(path_594718, "resourceGroupName", newJString(resourceGroupName))
  add(query_594719, "api-version", newJString(apiVersion))
  add(path_594718, "subscriptionId", newJString(subscriptionId))
  add(path_594718, "tableName", newJString(tableName))
  add(path_594718, "accountName", newJString(accountName))
  result = call_594717.call(path_594718, query_594719, nil, nil, nil)

var databaseAccountsDeleteTable* = Call_DatabaseAccountsDeleteTable_594708(
    name: "databaseAccountsDeleteTable", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/table/tables/{tableName}",
    validator: validate_DatabaseAccountsDeleteTable_594709, base: "",
    url: url_DatabaseAccountsDeleteTable_594710, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsUpdateTableThroughput_594732 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsUpdateTableThroughput_594734(protocol: Scheme;
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

proc validate_DatabaseAccountsUpdateTableThroughput_594733(path: JsonNode;
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
  var valid_594735 = path.getOrDefault("resourceGroupName")
  valid_594735 = validateParameter(valid_594735, JString, required = true,
                                 default = nil)
  if valid_594735 != nil:
    section.add "resourceGroupName", valid_594735
  var valid_594736 = path.getOrDefault("subscriptionId")
  valid_594736 = validateParameter(valid_594736, JString, required = true,
                                 default = nil)
  if valid_594736 != nil:
    section.add "subscriptionId", valid_594736
  var valid_594737 = path.getOrDefault("tableName")
  valid_594737 = validateParameter(valid_594737, JString, required = true,
                                 default = nil)
  if valid_594737 != nil:
    section.add "tableName", valid_594737
  var valid_594738 = path.getOrDefault("accountName")
  valid_594738 = validateParameter(valid_594738, JString, required = true,
                                 default = nil)
  if valid_594738 != nil:
    section.add "accountName", valid_594738
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594739 = query.getOrDefault("api-version")
  valid_594739 = validateParameter(valid_594739, JString, required = true,
                                 default = nil)
  if valid_594739 != nil:
    section.add "api-version", valid_594739
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

proc call*(call_594741: Call_DatabaseAccountsUpdateTableThroughput_594732;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update RUs per second of an Azure Cosmos DB Table
  ## 
  let valid = call_594741.validator(path, query, header, formData, body)
  let scheme = call_594741.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594741.url(scheme.get, call_594741.host, call_594741.base,
                         call_594741.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594741, url, valid)

proc call*(call_594742: Call_DatabaseAccountsUpdateTableThroughput_594732;
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
  var path_594743 = newJObject()
  var query_594744 = newJObject()
  var body_594745 = newJObject()
  add(path_594743, "resourceGroupName", newJString(resourceGroupName))
  add(query_594744, "api-version", newJString(apiVersion))
  add(path_594743, "subscriptionId", newJString(subscriptionId))
  add(path_594743, "tableName", newJString(tableName))
  if updateThroughputParameters != nil:
    body_594745 = updateThroughputParameters
  add(path_594743, "accountName", newJString(accountName))
  result = call_594742.call(path_594743, query_594744, nil, nil, body_594745)

var databaseAccountsUpdateTableThroughput* = Call_DatabaseAccountsUpdateTableThroughput_594732(
    name: "databaseAccountsUpdateTableThroughput", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/table/tables/{tableName}/settings/throughput",
    validator: validate_DatabaseAccountsUpdateTableThroughput_594733, base: "",
    url: url_DatabaseAccountsUpdateTableThroughput_594734, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetTableThroughput_594720 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsGetTableThroughput_594722(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsGetTableThroughput_594721(path: JsonNode;
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
  var valid_594723 = path.getOrDefault("resourceGroupName")
  valid_594723 = validateParameter(valid_594723, JString, required = true,
                                 default = nil)
  if valid_594723 != nil:
    section.add "resourceGroupName", valid_594723
  var valid_594724 = path.getOrDefault("subscriptionId")
  valid_594724 = validateParameter(valid_594724, JString, required = true,
                                 default = nil)
  if valid_594724 != nil:
    section.add "subscriptionId", valid_594724
  var valid_594725 = path.getOrDefault("tableName")
  valid_594725 = validateParameter(valid_594725, JString, required = true,
                                 default = nil)
  if valid_594725 != nil:
    section.add "tableName", valid_594725
  var valid_594726 = path.getOrDefault("accountName")
  valid_594726 = validateParameter(valid_594726, JString, required = true,
                                 default = nil)
  if valid_594726 != nil:
    section.add "accountName", valid_594726
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594727 = query.getOrDefault("api-version")
  valid_594727 = validateParameter(valid_594727, JString, required = true,
                                 default = nil)
  if valid_594727 != nil:
    section.add "api-version", valid_594727
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594728: Call_DatabaseAccountsGetTableThroughput_594720;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the RUs per second of the Table under an existing Azure Cosmos DB database account with the provided name.
  ## 
  let valid = call_594728.validator(path, query, header, formData, body)
  let scheme = call_594728.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594728.url(scheme.get, call_594728.host, call_594728.base,
                         call_594728.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594728, url, valid)

proc call*(call_594729: Call_DatabaseAccountsGetTableThroughput_594720;
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
  var path_594730 = newJObject()
  var query_594731 = newJObject()
  add(path_594730, "resourceGroupName", newJString(resourceGroupName))
  add(query_594731, "api-version", newJString(apiVersion))
  add(path_594730, "subscriptionId", newJString(subscriptionId))
  add(path_594730, "tableName", newJString(tableName))
  add(path_594730, "accountName", newJString(accountName))
  result = call_594729.call(path_594730, query_594731, nil, nil, nil)

var databaseAccountsGetTableThroughput* = Call_DatabaseAccountsGetTableThroughput_594720(
    name: "databaseAccountsGetTableThroughput", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/apis/table/tables/{tableName}/settings/throughput",
    validator: validate_DatabaseAccountsGetTableThroughput_594721, base: "",
    url: url_DatabaseAccountsGetTableThroughput_594722, schemes: {Scheme.Https})
type
  Call_CollectionListMetricDefinitions_594746 = ref object of OpenApiRestCall_593439
proc url_CollectionListMetricDefinitions_594748(protocol: Scheme; host: string;
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

proc validate_CollectionListMetricDefinitions_594747(path: JsonNode;
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
  var valid_594749 = path.getOrDefault("resourceGroupName")
  valid_594749 = validateParameter(valid_594749, JString, required = true,
                                 default = nil)
  if valid_594749 != nil:
    section.add "resourceGroupName", valid_594749
  var valid_594750 = path.getOrDefault("collectionRid")
  valid_594750 = validateParameter(valid_594750, JString, required = true,
                                 default = nil)
  if valid_594750 != nil:
    section.add "collectionRid", valid_594750
  var valid_594751 = path.getOrDefault("subscriptionId")
  valid_594751 = validateParameter(valid_594751, JString, required = true,
                                 default = nil)
  if valid_594751 != nil:
    section.add "subscriptionId", valid_594751
  var valid_594752 = path.getOrDefault("databaseRid")
  valid_594752 = validateParameter(valid_594752, JString, required = true,
                                 default = nil)
  if valid_594752 != nil:
    section.add "databaseRid", valid_594752
  var valid_594753 = path.getOrDefault("accountName")
  valid_594753 = validateParameter(valid_594753, JString, required = true,
                                 default = nil)
  if valid_594753 != nil:
    section.add "accountName", valid_594753
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594754 = query.getOrDefault("api-version")
  valid_594754 = validateParameter(valid_594754, JString, required = true,
                                 default = nil)
  if valid_594754 != nil:
    section.add "api-version", valid_594754
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594755: Call_CollectionListMetricDefinitions_594746;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves metric definitions for the given collection.
  ## 
  let valid = call_594755.validator(path, query, header, formData, body)
  let scheme = call_594755.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594755.url(scheme.get, call_594755.host, call_594755.base,
                         call_594755.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594755, url, valid)

proc call*(call_594756: Call_CollectionListMetricDefinitions_594746;
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
  var path_594757 = newJObject()
  var query_594758 = newJObject()
  add(path_594757, "resourceGroupName", newJString(resourceGroupName))
  add(query_594758, "api-version", newJString(apiVersion))
  add(path_594757, "collectionRid", newJString(collectionRid))
  add(path_594757, "subscriptionId", newJString(subscriptionId))
  add(path_594757, "databaseRid", newJString(databaseRid))
  add(path_594757, "accountName", newJString(accountName))
  result = call_594756.call(path_594757, query_594758, nil, nil, nil)

var collectionListMetricDefinitions* = Call_CollectionListMetricDefinitions_594746(
    name: "collectionListMetricDefinitions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/metricDefinitions",
    validator: validate_CollectionListMetricDefinitions_594747, base: "",
    url: url_CollectionListMetricDefinitions_594748, schemes: {Scheme.Https})
type
  Call_CollectionListMetrics_594759 = ref object of OpenApiRestCall_593439
proc url_CollectionListMetrics_594761(protocol: Scheme; host: string; base: string;
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

proc validate_CollectionListMetrics_594760(path: JsonNode; query: JsonNode;
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
  var valid_594763 = path.getOrDefault("resourceGroupName")
  valid_594763 = validateParameter(valid_594763, JString, required = true,
                                 default = nil)
  if valid_594763 != nil:
    section.add "resourceGroupName", valid_594763
  var valid_594764 = path.getOrDefault("collectionRid")
  valid_594764 = validateParameter(valid_594764, JString, required = true,
                                 default = nil)
  if valid_594764 != nil:
    section.add "collectionRid", valid_594764
  var valid_594765 = path.getOrDefault("subscriptionId")
  valid_594765 = validateParameter(valid_594765, JString, required = true,
                                 default = nil)
  if valid_594765 != nil:
    section.add "subscriptionId", valid_594765
  var valid_594766 = path.getOrDefault("databaseRid")
  valid_594766 = validateParameter(valid_594766, JString, required = true,
                                 default = nil)
  if valid_594766 != nil:
    section.add "databaseRid", valid_594766
  var valid_594767 = path.getOrDefault("accountName")
  valid_594767 = validateParameter(valid_594767, JString, required = true,
                                 default = nil)
  if valid_594767 != nil:
    section.add "accountName", valid_594767
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594768 = query.getOrDefault("api-version")
  valid_594768 = validateParameter(valid_594768, JString, required = true,
                                 default = nil)
  if valid_594768 != nil:
    section.add "api-version", valid_594768
  var valid_594769 = query.getOrDefault("$filter")
  valid_594769 = validateParameter(valid_594769, JString, required = true,
                                 default = nil)
  if valid_594769 != nil:
    section.add "$filter", valid_594769
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594770: Call_CollectionListMetrics_594759; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account and collection.
  ## 
  let valid = call_594770.validator(path, query, header, formData, body)
  let scheme = call_594770.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594770.url(scheme.get, call_594770.host, call_594770.base,
                         call_594770.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594770, url, valid)

proc call*(call_594771: Call_CollectionListMetrics_594759;
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
  var path_594772 = newJObject()
  var query_594773 = newJObject()
  add(path_594772, "resourceGroupName", newJString(resourceGroupName))
  add(query_594773, "api-version", newJString(apiVersion))
  add(path_594772, "collectionRid", newJString(collectionRid))
  add(path_594772, "subscriptionId", newJString(subscriptionId))
  add(path_594772, "databaseRid", newJString(databaseRid))
  add(path_594772, "accountName", newJString(accountName))
  add(query_594773, "$filter", newJString(Filter))
  result = call_594771.call(path_594772, query_594773, nil, nil, nil)

var collectionListMetrics* = Call_CollectionListMetrics_594759(
    name: "collectionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/metrics",
    validator: validate_CollectionListMetrics_594760, base: "",
    url: url_CollectionListMetrics_594761, schemes: {Scheme.Https})
type
  Call_PartitionKeyRangeIdListMetrics_594774 = ref object of OpenApiRestCall_593439
proc url_PartitionKeyRangeIdListMetrics_594776(protocol: Scheme; host: string;
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

proc validate_PartitionKeyRangeIdListMetrics_594775(path: JsonNode;
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
  var valid_594777 = path.getOrDefault("resourceGroupName")
  valid_594777 = validateParameter(valid_594777, JString, required = true,
                                 default = nil)
  if valid_594777 != nil:
    section.add "resourceGroupName", valid_594777
  var valid_594778 = path.getOrDefault("collectionRid")
  valid_594778 = validateParameter(valid_594778, JString, required = true,
                                 default = nil)
  if valid_594778 != nil:
    section.add "collectionRid", valid_594778
  var valid_594779 = path.getOrDefault("subscriptionId")
  valid_594779 = validateParameter(valid_594779, JString, required = true,
                                 default = nil)
  if valid_594779 != nil:
    section.add "subscriptionId", valid_594779
  var valid_594780 = path.getOrDefault("partitionKeyRangeId")
  valid_594780 = validateParameter(valid_594780, JString, required = true,
                                 default = nil)
  if valid_594780 != nil:
    section.add "partitionKeyRangeId", valid_594780
  var valid_594781 = path.getOrDefault("databaseRid")
  valid_594781 = validateParameter(valid_594781, JString, required = true,
                                 default = nil)
  if valid_594781 != nil:
    section.add "databaseRid", valid_594781
  var valid_594782 = path.getOrDefault("accountName")
  valid_594782 = validateParameter(valid_594782, JString, required = true,
                                 default = nil)
  if valid_594782 != nil:
    section.add "accountName", valid_594782
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594783 = query.getOrDefault("api-version")
  valid_594783 = validateParameter(valid_594783, JString, required = true,
                                 default = nil)
  if valid_594783 != nil:
    section.add "api-version", valid_594783
  var valid_594784 = query.getOrDefault("$filter")
  valid_594784 = validateParameter(valid_594784, JString, required = true,
                                 default = nil)
  if valid_594784 != nil:
    section.add "$filter", valid_594784
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594785: Call_PartitionKeyRangeIdListMetrics_594774; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given partition key range id.
  ## 
  let valid = call_594785.validator(path, query, header, formData, body)
  let scheme = call_594785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594785.url(scheme.get, call_594785.host, call_594785.base,
                         call_594785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594785, url, valid)

proc call*(call_594786: Call_PartitionKeyRangeIdListMetrics_594774;
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
  var path_594787 = newJObject()
  var query_594788 = newJObject()
  add(path_594787, "resourceGroupName", newJString(resourceGroupName))
  add(query_594788, "api-version", newJString(apiVersion))
  add(path_594787, "collectionRid", newJString(collectionRid))
  add(path_594787, "subscriptionId", newJString(subscriptionId))
  add(path_594787, "partitionKeyRangeId", newJString(partitionKeyRangeId))
  add(path_594787, "databaseRid", newJString(databaseRid))
  add(path_594787, "accountName", newJString(accountName))
  add(query_594788, "$filter", newJString(Filter))
  result = call_594786.call(path_594787, query_594788, nil, nil, nil)

var partitionKeyRangeIdListMetrics* = Call_PartitionKeyRangeIdListMetrics_594774(
    name: "partitionKeyRangeIdListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/partitionKeyRangeId/{partitionKeyRangeId}/metrics",
    validator: validate_PartitionKeyRangeIdListMetrics_594775, base: "",
    url: url_PartitionKeyRangeIdListMetrics_594776, schemes: {Scheme.Https})
type
  Call_CollectionPartitionListMetrics_594789 = ref object of OpenApiRestCall_593439
proc url_CollectionPartitionListMetrics_594791(protocol: Scheme; host: string;
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

proc validate_CollectionPartitionListMetrics_594790(path: JsonNode;
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
  var valid_594792 = path.getOrDefault("resourceGroupName")
  valid_594792 = validateParameter(valid_594792, JString, required = true,
                                 default = nil)
  if valid_594792 != nil:
    section.add "resourceGroupName", valid_594792
  var valid_594793 = path.getOrDefault("collectionRid")
  valid_594793 = validateParameter(valid_594793, JString, required = true,
                                 default = nil)
  if valid_594793 != nil:
    section.add "collectionRid", valid_594793
  var valid_594794 = path.getOrDefault("subscriptionId")
  valid_594794 = validateParameter(valid_594794, JString, required = true,
                                 default = nil)
  if valid_594794 != nil:
    section.add "subscriptionId", valid_594794
  var valid_594795 = path.getOrDefault("databaseRid")
  valid_594795 = validateParameter(valid_594795, JString, required = true,
                                 default = nil)
  if valid_594795 != nil:
    section.add "databaseRid", valid_594795
  var valid_594796 = path.getOrDefault("accountName")
  valid_594796 = validateParameter(valid_594796, JString, required = true,
                                 default = nil)
  if valid_594796 != nil:
    section.add "accountName", valid_594796
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594797 = query.getOrDefault("api-version")
  valid_594797 = validateParameter(valid_594797, JString, required = true,
                                 default = nil)
  if valid_594797 != nil:
    section.add "api-version", valid_594797
  var valid_594798 = query.getOrDefault("$filter")
  valid_594798 = validateParameter(valid_594798, JString, required = true,
                                 default = nil)
  if valid_594798 != nil:
    section.add "$filter", valid_594798
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594799: Call_CollectionPartitionListMetrics_594789; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given collection, split by partition.
  ## 
  let valid = call_594799.validator(path, query, header, formData, body)
  let scheme = call_594799.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594799.url(scheme.get, call_594799.host, call_594799.base,
                         call_594799.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594799, url, valid)

proc call*(call_594800: Call_CollectionPartitionListMetrics_594789;
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
  var path_594801 = newJObject()
  var query_594802 = newJObject()
  add(path_594801, "resourceGroupName", newJString(resourceGroupName))
  add(query_594802, "api-version", newJString(apiVersion))
  add(path_594801, "collectionRid", newJString(collectionRid))
  add(path_594801, "subscriptionId", newJString(subscriptionId))
  add(path_594801, "databaseRid", newJString(databaseRid))
  add(path_594801, "accountName", newJString(accountName))
  add(query_594802, "$filter", newJString(Filter))
  result = call_594800.call(path_594801, query_594802, nil, nil, nil)

var collectionPartitionListMetrics* = Call_CollectionPartitionListMetrics_594789(
    name: "collectionPartitionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/partitions/metrics",
    validator: validate_CollectionPartitionListMetrics_594790, base: "",
    url: url_CollectionPartitionListMetrics_594791, schemes: {Scheme.Https})
type
  Call_CollectionPartitionListUsages_594803 = ref object of OpenApiRestCall_593439
proc url_CollectionPartitionListUsages_594805(protocol: Scheme; host: string;
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

proc validate_CollectionPartitionListUsages_594804(path: JsonNode; query: JsonNode;
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
  var valid_594806 = path.getOrDefault("resourceGroupName")
  valid_594806 = validateParameter(valid_594806, JString, required = true,
                                 default = nil)
  if valid_594806 != nil:
    section.add "resourceGroupName", valid_594806
  var valid_594807 = path.getOrDefault("collectionRid")
  valid_594807 = validateParameter(valid_594807, JString, required = true,
                                 default = nil)
  if valid_594807 != nil:
    section.add "collectionRid", valid_594807
  var valid_594808 = path.getOrDefault("subscriptionId")
  valid_594808 = validateParameter(valid_594808, JString, required = true,
                                 default = nil)
  if valid_594808 != nil:
    section.add "subscriptionId", valid_594808
  var valid_594809 = path.getOrDefault("databaseRid")
  valid_594809 = validateParameter(valid_594809, JString, required = true,
                                 default = nil)
  if valid_594809 != nil:
    section.add "databaseRid", valid_594809
  var valid_594810 = path.getOrDefault("accountName")
  valid_594810 = validateParameter(valid_594810, JString, required = true,
                                 default = nil)
  if valid_594810 != nil:
    section.add "accountName", valid_594810
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString
  ##          : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594811 = query.getOrDefault("api-version")
  valid_594811 = validateParameter(valid_594811, JString, required = true,
                                 default = nil)
  if valid_594811 != nil:
    section.add "api-version", valid_594811
  var valid_594812 = query.getOrDefault("$filter")
  valid_594812 = validateParameter(valid_594812, JString, required = false,
                                 default = nil)
  if valid_594812 != nil:
    section.add "$filter", valid_594812
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594813: Call_CollectionPartitionListUsages_594803; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the usages (most recent storage data) for the given collection, split by partition.
  ## 
  let valid = call_594813.validator(path, query, header, formData, body)
  let scheme = call_594813.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594813.url(scheme.get, call_594813.host, call_594813.base,
                         call_594813.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594813, url, valid)

proc call*(call_594814: Call_CollectionPartitionListUsages_594803;
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
  var path_594815 = newJObject()
  var query_594816 = newJObject()
  add(path_594815, "resourceGroupName", newJString(resourceGroupName))
  add(query_594816, "api-version", newJString(apiVersion))
  add(path_594815, "collectionRid", newJString(collectionRid))
  add(path_594815, "subscriptionId", newJString(subscriptionId))
  add(path_594815, "databaseRid", newJString(databaseRid))
  add(path_594815, "accountName", newJString(accountName))
  add(query_594816, "$filter", newJString(Filter))
  result = call_594814.call(path_594815, query_594816, nil, nil, nil)

var collectionPartitionListUsages* = Call_CollectionPartitionListUsages_594803(
    name: "collectionPartitionListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/partitions/usages",
    validator: validate_CollectionPartitionListUsages_594804, base: "",
    url: url_CollectionPartitionListUsages_594805, schemes: {Scheme.Https})
type
  Call_CollectionListUsages_594817 = ref object of OpenApiRestCall_593439
proc url_CollectionListUsages_594819(protocol: Scheme; host: string; base: string;
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

proc validate_CollectionListUsages_594818(path: JsonNode; query: JsonNode;
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
  var valid_594820 = path.getOrDefault("resourceGroupName")
  valid_594820 = validateParameter(valid_594820, JString, required = true,
                                 default = nil)
  if valid_594820 != nil:
    section.add "resourceGroupName", valid_594820
  var valid_594821 = path.getOrDefault("collectionRid")
  valid_594821 = validateParameter(valid_594821, JString, required = true,
                                 default = nil)
  if valid_594821 != nil:
    section.add "collectionRid", valid_594821
  var valid_594822 = path.getOrDefault("subscriptionId")
  valid_594822 = validateParameter(valid_594822, JString, required = true,
                                 default = nil)
  if valid_594822 != nil:
    section.add "subscriptionId", valid_594822
  var valid_594823 = path.getOrDefault("databaseRid")
  valid_594823 = validateParameter(valid_594823, JString, required = true,
                                 default = nil)
  if valid_594823 != nil:
    section.add "databaseRid", valid_594823
  var valid_594824 = path.getOrDefault("accountName")
  valid_594824 = validateParameter(valid_594824, JString, required = true,
                                 default = nil)
  if valid_594824 != nil:
    section.add "accountName", valid_594824
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString
  ##          : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594825 = query.getOrDefault("api-version")
  valid_594825 = validateParameter(valid_594825, JString, required = true,
                                 default = nil)
  if valid_594825 != nil:
    section.add "api-version", valid_594825
  var valid_594826 = query.getOrDefault("$filter")
  valid_594826 = validateParameter(valid_594826, JString, required = false,
                                 default = nil)
  if valid_594826 != nil:
    section.add "$filter", valid_594826
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594827: Call_CollectionListUsages_594817; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the usages (most recent storage data) for the given collection.
  ## 
  let valid = call_594827.validator(path, query, header, formData, body)
  let scheme = call_594827.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594827.url(scheme.get, call_594827.host, call_594827.base,
                         call_594827.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594827, url, valid)

proc call*(call_594828: Call_CollectionListUsages_594817;
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
  var path_594829 = newJObject()
  var query_594830 = newJObject()
  add(path_594829, "resourceGroupName", newJString(resourceGroupName))
  add(query_594830, "api-version", newJString(apiVersion))
  add(path_594829, "collectionRid", newJString(collectionRid))
  add(path_594829, "subscriptionId", newJString(subscriptionId))
  add(path_594829, "databaseRid", newJString(databaseRid))
  add(path_594829, "accountName", newJString(accountName))
  add(query_594830, "$filter", newJString(Filter))
  result = call_594828.call(path_594829, query_594830, nil, nil, nil)

var collectionListUsages* = Call_CollectionListUsages_594817(
    name: "collectionListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/collections/{collectionRid}/usages",
    validator: validate_CollectionListUsages_594818, base: "",
    url: url_CollectionListUsages_594819, schemes: {Scheme.Https})
type
  Call_DatabaseListMetricDefinitions_594831 = ref object of OpenApiRestCall_593439
proc url_DatabaseListMetricDefinitions_594833(protocol: Scheme; host: string;
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

proc validate_DatabaseListMetricDefinitions_594832(path: JsonNode; query: JsonNode;
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
  var valid_594834 = path.getOrDefault("resourceGroupName")
  valid_594834 = validateParameter(valid_594834, JString, required = true,
                                 default = nil)
  if valid_594834 != nil:
    section.add "resourceGroupName", valid_594834
  var valid_594835 = path.getOrDefault("subscriptionId")
  valid_594835 = validateParameter(valid_594835, JString, required = true,
                                 default = nil)
  if valid_594835 != nil:
    section.add "subscriptionId", valid_594835
  var valid_594836 = path.getOrDefault("databaseRid")
  valid_594836 = validateParameter(valid_594836, JString, required = true,
                                 default = nil)
  if valid_594836 != nil:
    section.add "databaseRid", valid_594836
  var valid_594837 = path.getOrDefault("accountName")
  valid_594837 = validateParameter(valid_594837, JString, required = true,
                                 default = nil)
  if valid_594837 != nil:
    section.add "accountName", valid_594837
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594838 = query.getOrDefault("api-version")
  valid_594838 = validateParameter(valid_594838, JString, required = true,
                                 default = nil)
  if valid_594838 != nil:
    section.add "api-version", valid_594838
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594839: Call_DatabaseListMetricDefinitions_594831; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves metric definitions for the given database.
  ## 
  let valid = call_594839.validator(path, query, header, formData, body)
  let scheme = call_594839.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594839.url(scheme.get, call_594839.host, call_594839.base,
                         call_594839.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594839, url, valid)

proc call*(call_594840: Call_DatabaseListMetricDefinitions_594831;
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
  var path_594841 = newJObject()
  var query_594842 = newJObject()
  add(path_594841, "resourceGroupName", newJString(resourceGroupName))
  add(query_594842, "api-version", newJString(apiVersion))
  add(path_594841, "subscriptionId", newJString(subscriptionId))
  add(path_594841, "databaseRid", newJString(databaseRid))
  add(path_594841, "accountName", newJString(accountName))
  result = call_594840.call(path_594841, query_594842, nil, nil, nil)

var databaseListMetricDefinitions* = Call_DatabaseListMetricDefinitions_594831(
    name: "databaseListMetricDefinitions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/metricDefinitions",
    validator: validate_DatabaseListMetricDefinitions_594832, base: "",
    url: url_DatabaseListMetricDefinitions_594833, schemes: {Scheme.Https})
type
  Call_DatabaseListMetrics_594843 = ref object of OpenApiRestCall_593439
proc url_DatabaseListMetrics_594845(protocol: Scheme; host: string; base: string;
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

proc validate_DatabaseListMetrics_594844(path: JsonNode; query: JsonNode;
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
  var valid_594846 = path.getOrDefault("resourceGroupName")
  valid_594846 = validateParameter(valid_594846, JString, required = true,
                                 default = nil)
  if valid_594846 != nil:
    section.add "resourceGroupName", valid_594846
  var valid_594847 = path.getOrDefault("subscriptionId")
  valid_594847 = validateParameter(valid_594847, JString, required = true,
                                 default = nil)
  if valid_594847 != nil:
    section.add "subscriptionId", valid_594847
  var valid_594848 = path.getOrDefault("databaseRid")
  valid_594848 = validateParameter(valid_594848, JString, required = true,
                                 default = nil)
  if valid_594848 != nil:
    section.add "databaseRid", valid_594848
  var valid_594849 = path.getOrDefault("accountName")
  valid_594849 = validateParameter(valid_594849, JString, required = true,
                                 default = nil)
  if valid_594849 != nil:
    section.add "accountName", valid_594849
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594850 = query.getOrDefault("api-version")
  valid_594850 = validateParameter(valid_594850, JString, required = true,
                                 default = nil)
  if valid_594850 != nil:
    section.add "api-version", valid_594850
  var valid_594851 = query.getOrDefault("$filter")
  valid_594851 = validateParameter(valid_594851, JString, required = true,
                                 default = nil)
  if valid_594851 != nil:
    section.add "$filter", valid_594851
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594852: Call_DatabaseListMetrics_594843; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account and database.
  ## 
  let valid = call_594852.validator(path, query, header, formData, body)
  let scheme = call_594852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594852.url(scheme.get, call_594852.host, call_594852.base,
                         call_594852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594852, url, valid)

proc call*(call_594853: Call_DatabaseListMetrics_594843; resourceGroupName: string;
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
  var path_594854 = newJObject()
  var query_594855 = newJObject()
  add(path_594854, "resourceGroupName", newJString(resourceGroupName))
  add(query_594855, "api-version", newJString(apiVersion))
  add(path_594854, "subscriptionId", newJString(subscriptionId))
  add(path_594854, "databaseRid", newJString(databaseRid))
  add(path_594854, "accountName", newJString(accountName))
  add(query_594855, "$filter", newJString(Filter))
  result = call_594853.call(path_594854, query_594855, nil, nil, nil)

var databaseListMetrics* = Call_DatabaseListMetrics_594843(
    name: "databaseListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/metrics",
    validator: validate_DatabaseListMetrics_594844, base: "",
    url: url_DatabaseListMetrics_594845, schemes: {Scheme.Https})
type
  Call_DatabaseListUsages_594856 = ref object of OpenApiRestCall_593439
proc url_DatabaseListUsages_594858(protocol: Scheme; host: string; base: string;
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

proc validate_DatabaseListUsages_594857(path: JsonNode; query: JsonNode;
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
  var valid_594859 = path.getOrDefault("resourceGroupName")
  valid_594859 = validateParameter(valid_594859, JString, required = true,
                                 default = nil)
  if valid_594859 != nil:
    section.add "resourceGroupName", valid_594859
  var valid_594860 = path.getOrDefault("subscriptionId")
  valid_594860 = validateParameter(valid_594860, JString, required = true,
                                 default = nil)
  if valid_594860 != nil:
    section.add "subscriptionId", valid_594860
  var valid_594861 = path.getOrDefault("databaseRid")
  valid_594861 = validateParameter(valid_594861, JString, required = true,
                                 default = nil)
  if valid_594861 != nil:
    section.add "databaseRid", valid_594861
  var valid_594862 = path.getOrDefault("accountName")
  valid_594862 = validateParameter(valid_594862, JString, required = true,
                                 default = nil)
  if valid_594862 != nil:
    section.add "accountName", valid_594862
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString
  ##          : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594863 = query.getOrDefault("api-version")
  valid_594863 = validateParameter(valid_594863, JString, required = true,
                                 default = nil)
  if valid_594863 != nil:
    section.add "api-version", valid_594863
  var valid_594864 = query.getOrDefault("$filter")
  valid_594864 = validateParameter(valid_594864, JString, required = false,
                                 default = nil)
  if valid_594864 != nil:
    section.add "$filter", valid_594864
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594865: Call_DatabaseListUsages_594856; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the usages (most recent data) for the given database.
  ## 
  let valid = call_594865.validator(path, query, header, formData, body)
  let scheme = call_594865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594865.url(scheme.get, call_594865.host, call_594865.base,
                         call_594865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594865, url, valid)

proc call*(call_594866: Call_DatabaseListUsages_594856; resourceGroupName: string;
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
  var path_594867 = newJObject()
  var query_594868 = newJObject()
  add(path_594867, "resourceGroupName", newJString(resourceGroupName))
  add(query_594868, "api-version", newJString(apiVersion))
  add(path_594867, "subscriptionId", newJString(subscriptionId))
  add(path_594867, "databaseRid", newJString(databaseRid))
  add(path_594867, "accountName", newJString(accountName))
  add(query_594868, "$filter", newJString(Filter))
  result = call_594866.call(path_594867, query_594868, nil, nil, nil)

var databaseListUsages* = Call_DatabaseListUsages_594856(
    name: "databaseListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/databases/{databaseRid}/usages",
    validator: validate_DatabaseListUsages_594857, base: "",
    url: url_DatabaseListUsages_594858, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsFailoverPriorityChange_594869 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsFailoverPriorityChange_594871(protocol: Scheme;
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

proc validate_DatabaseAccountsFailoverPriorityChange_594870(path: JsonNode;
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
  var valid_594889 = path.getOrDefault("resourceGroupName")
  valid_594889 = validateParameter(valid_594889, JString, required = true,
                                 default = nil)
  if valid_594889 != nil:
    section.add "resourceGroupName", valid_594889
  var valid_594890 = path.getOrDefault("subscriptionId")
  valid_594890 = validateParameter(valid_594890, JString, required = true,
                                 default = nil)
  if valid_594890 != nil:
    section.add "subscriptionId", valid_594890
  var valid_594891 = path.getOrDefault("accountName")
  valid_594891 = validateParameter(valid_594891, JString, required = true,
                                 default = nil)
  if valid_594891 != nil:
    section.add "accountName", valid_594891
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594892 = query.getOrDefault("api-version")
  valid_594892 = validateParameter(valid_594892, JString, required = true,
                                 default = nil)
  if valid_594892 != nil:
    section.add "api-version", valid_594892
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

proc call*(call_594894: Call_DatabaseAccountsFailoverPriorityChange_594869;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Changes the failover priority for the Azure Cosmos DB database account. A failover priority of 0 indicates a write region. The maximum value for a failover priority = (total number of regions - 1). Failover priority values must be unique for each of the regions in which the database account exists.
  ## 
  let valid = call_594894.validator(path, query, header, formData, body)
  let scheme = call_594894.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594894.url(scheme.get, call_594894.host, call_594894.base,
                         call_594894.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594894, url, valid)

proc call*(call_594895: Call_DatabaseAccountsFailoverPriorityChange_594869;
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
  var path_594896 = newJObject()
  var query_594897 = newJObject()
  var body_594898 = newJObject()
  add(path_594896, "resourceGroupName", newJString(resourceGroupName))
  add(query_594897, "api-version", newJString(apiVersion))
  add(path_594896, "subscriptionId", newJString(subscriptionId))
  if failoverParameters != nil:
    body_594898 = failoverParameters
  add(path_594896, "accountName", newJString(accountName))
  result = call_594895.call(path_594896, query_594897, nil, nil, body_594898)

var databaseAccountsFailoverPriorityChange* = Call_DatabaseAccountsFailoverPriorityChange_594869(
    name: "databaseAccountsFailoverPriorityChange", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/failoverPriorityChange",
    validator: validate_DatabaseAccountsFailoverPriorityChange_594870, base: "",
    url: url_DatabaseAccountsFailoverPriorityChange_594871,
    schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListConnectionStrings_594899 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsListConnectionStrings_594901(protocol: Scheme;
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

proc validate_DatabaseAccountsListConnectionStrings_594900(path: JsonNode;
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
  var valid_594902 = path.getOrDefault("resourceGroupName")
  valid_594902 = validateParameter(valid_594902, JString, required = true,
                                 default = nil)
  if valid_594902 != nil:
    section.add "resourceGroupName", valid_594902
  var valid_594903 = path.getOrDefault("subscriptionId")
  valid_594903 = validateParameter(valid_594903, JString, required = true,
                                 default = nil)
  if valid_594903 != nil:
    section.add "subscriptionId", valid_594903
  var valid_594904 = path.getOrDefault("accountName")
  valid_594904 = validateParameter(valid_594904, JString, required = true,
                                 default = nil)
  if valid_594904 != nil:
    section.add "accountName", valid_594904
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594905 = query.getOrDefault("api-version")
  valid_594905 = validateParameter(valid_594905, JString, required = true,
                                 default = nil)
  if valid_594905 != nil:
    section.add "api-version", valid_594905
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594906: Call_DatabaseAccountsListConnectionStrings_594899;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the connection strings for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_594906.validator(path, query, header, formData, body)
  let scheme = call_594906.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594906.url(scheme.get, call_594906.host, call_594906.base,
                         call_594906.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594906, url, valid)

proc call*(call_594907: Call_DatabaseAccountsListConnectionStrings_594899;
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
  var path_594908 = newJObject()
  var query_594909 = newJObject()
  add(path_594908, "resourceGroupName", newJString(resourceGroupName))
  add(query_594909, "api-version", newJString(apiVersion))
  add(path_594908, "subscriptionId", newJString(subscriptionId))
  add(path_594908, "accountName", newJString(accountName))
  result = call_594907.call(path_594908, query_594909, nil, nil, nil)

var databaseAccountsListConnectionStrings* = Call_DatabaseAccountsListConnectionStrings_594899(
    name: "databaseAccountsListConnectionStrings", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/listConnectionStrings",
    validator: validate_DatabaseAccountsListConnectionStrings_594900, base: "",
    url: url_DatabaseAccountsListConnectionStrings_594901, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListKeys_594910 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsListKeys_594912(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListKeys_594911(path: JsonNode; query: JsonNode;
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
  var valid_594913 = path.getOrDefault("resourceGroupName")
  valid_594913 = validateParameter(valid_594913, JString, required = true,
                                 default = nil)
  if valid_594913 != nil:
    section.add "resourceGroupName", valid_594913
  var valid_594914 = path.getOrDefault("subscriptionId")
  valid_594914 = validateParameter(valid_594914, JString, required = true,
                                 default = nil)
  if valid_594914 != nil:
    section.add "subscriptionId", valid_594914
  var valid_594915 = path.getOrDefault("accountName")
  valid_594915 = validateParameter(valid_594915, JString, required = true,
                                 default = nil)
  if valid_594915 != nil:
    section.add "accountName", valid_594915
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594916 = query.getOrDefault("api-version")
  valid_594916 = validateParameter(valid_594916, JString, required = true,
                                 default = nil)
  if valid_594916 != nil:
    section.add "api-version", valid_594916
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594917: Call_DatabaseAccountsListKeys_594910; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the access keys for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_594917.validator(path, query, header, formData, body)
  let scheme = call_594917.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594917.url(scheme.get, call_594917.host, call_594917.base,
                         call_594917.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594917, url, valid)

proc call*(call_594918: Call_DatabaseAccountsListKeys_594910;
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
  var path_594919 = newJObject()
  var query_594920 = newJObject()
  add(path_594919, "resourceGroupName", newJString(resourceGroupName))
  add(query_594920, "api-version", newJString(apiVersion))
  add(path_594919, "subscriptionId", newJString(subscriptionId))
  add(path_594919, "accountName", newJString(accountName))
  result = call_594918.call(path_594919, query_594920, nil, nil, nil)

var databaseAccountsListKeys* = Call_DatabaseAccountsListKeys_594910(
    name: "databaseAccountsListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/listKeys",
    validator: validate_DatabaseAccountsListKeys_594911, base: "",
    url: url_DatabaseAccountsListKeys_594912, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListMetricDefinitions_594921 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsListMetricDefinitions_594923(protocol: Scheme;
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

proc validate_DatabaseAccountsListMetricDefinitions_594922(path: JsonNode;
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
  var valid_594924 = path.getOrDefault("resourceGroupName")
  valid_594924 = validateParameter(valid_594924, JString, required = true,
                                 default = nil)
  if valid_594924 != nil:
    section.add "resourceGroupName", valid_594924
  var valid_594925 = path.getOrDefault("subscriptionId")
  valid_594925 = validateParameter(valid_594925, JString, required = true,
                                 default = nil)
  if valid_594925 != nil:
    section.add "subscriptionId", valid_594925
  var valid_594926 = path.getOrDefault("accountName")
  valid_594926 = validateParameter(valid_594926, JString, required = true,
                                 default = nil)
  if valid_594926 != nil:
    section.add "accountName", valid_594926
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594927 = query.getOrDefault("api-version")
  valid_594927 = validateParameter(valid_594927, JString, required = true,
                                 default = nil)
  if valid_594927 != nil:
    section.add "api-version", valid_594927
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594928: Call_DatabaseAccountsListMetricDefinitions_594921;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves metric definitions for the given database account.
  ## 
  let valid = call_594928.validator(path, query, header, formData, body)
  let scheme = call_594928.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594928.url(scheme.get, call_594928.host, call_594928.base,
                         call_594928.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594928, url, valid)

proc call*(call_594929: Call_DatabaseAccountsListMetricDefinitions_594921;
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
  var path_594930 = newJObject()
  var query_594931 = newJObject()
  add(path_594930, "resourceGroupName", newJString(resourceGroupName))
  add(query_594931, "api-version", newJString(apiVersion))
  add(path_594930, "subscriptionId", newJString(subscriptionId))
  add(path_594930, "accountName", newJString(accountName))
  result = call_594929.call(path_594930, query_594931, nil, nil, nil)

var databaseAccountsListMetricDefinitions* = Call_DatabaseAccountsListMetricDefinitions_594921(
    name: "databaseAccountsListMetricDefinitions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/metricDefinitions",
    validator: validate_DatabaseAccountsListMetricDefinitions_594922, base: "",
    url: url_DatabaseAccountsListMetricDefinitions_594923, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListMetrics_594932 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsListMetrics_594934(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListMetrics_594933(path: JsonNode; query: JsonNode;
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
  var valid_594935 = path.getOrDefault("resourceGroupName")
  valid_594935 = validateParameter(valid_594935, JString, required = true,
                                 default = nil)
  if valid_594935 != nil:
    section.add "resourceGroupName", valid_594935
  var valid_594936 = path.getOrDefault("subscriptionId")
  valid_594936 = validateParameter(valid_594936, JString, required = true,
                                 default = nil)
  if valid_594936 != nil:
    section.add "subscriptionId", valid_594936
  var valid_594937 = path.getOrDefault("accountName")
  valid_594937 = validateParameter(valid_594937, JString, required = true,
                                 default = nil)
  if valid_594937 != nil:
    section.add "accountName", valid_594937
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594938 = query.getOrDefault("api-version")
  valid_594938 = validateParameter(valid_594938, JString, required = true,
                                 default = nil)
  if valid_594938 != nil:
    section.add "api-version", valid_594938
  var valid_594939 = query.getOrDefault("$filter")
  valid_594939 = validateParameter(valid_594939, JString, required = true,
                                 default = nil)
  if valid_594939 != nil:
    section.add "$filter", valid_594939
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594940: Call_DatabaseAccountsListMetrics_594932; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account.
  ## 
  let valid = call_594940.validator(path, query, header, formData, body)
  let scheme = call_594940.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594940.url(scheme.get, call_594940.host, call_594940.base,
                         call_594940.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594940, url, valid)

proc call*(call_594941: Call_DatabaseAccountsListMetrics_594932;
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
  var path_594942 = newJObject()
  var query_594943 = newJObject()
  add(path_594942, "resourceGroupName", newJString(resourceGroupName))
  add(query_594943, "api-version", newJString(apiVersion))
  add(path_594942, "subscriptionId", newJString(subscriptionId))
  add(path_594942, "accountName", newJString(accountName))
  add(query_594943, "$filter", newJString(Filter))
  result = call_594941.call(path_594942, query_594943, nil, nil, nil)

var databaseAccountsListMetrics* = Call_DatabaseAccountsListMetrics_594932(
    name: "databaseAccountsListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/metrics",
    validator: validate_DatabaseAccountsListMetrics_594933, base: "",
    url: url_DatabaseAccountsListMetrics_594934, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsOfflineRegion_594944 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsOfflineRegion_594946(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsOfflineRegion_594945(path: JsonNode; query: JsonNode;
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
  var valid_594947 = path.getOrDefault("resourceGroupName")
  valid_594947 = validateParameter(valid_594947, JString, required = true,
                                 default = nil)
  if valid_594947 != nil:
    section.add "resourceGroupName", valid_594947
  var valid_594948 = path.getOrDefault("subscriptionId")
  valid_594948 = validateParameter(valid_594948, JString, required = true,
                                 default = nil)
  if valid_594948 != nil:
    section.add "subscriptionId", valid_594948
  var valid_594949 = path.getOrDefault("accountName")
  valid_594949 = validateParameter(valid_594949, JString, required = true,
                                 default = nil)
  if valid_594949 != nil:
    section.add "accountName", valid_594949
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594950 = query.getOrDefault("api-version")
  valid_594950 = validateParameter(valid_594950, JString, required = true,
                                 default = nil)
  if valid_594950 != nil:
    section.add "api-version", valid_594950
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

proc call*(call_594952: Call_DatabaseAccountsOfflineRegion_594944; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Offline the specified region for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_594952.validator(path, query, header, formData, body)
  let scheme = call_594952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594952.url(scheme.get, call_594952.host, call_594952.base,
                         call_594952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594952, url, valid)

proc call*(call_594953: Call_DatabaseAccountsOfflineRegion_594944;
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
  var path_594954 = newJObject()
  var query_594955 = newJObject()
  var body_594956 = newJObject()
  add(path_594954, "resourceGroupName", newJString(resourceGroupName))
  add(query_594955, "api-version", newJString(apiVersion))
  add(path_594954, "subscriptionId", newJString(subscriptionId))
  if regionParameterForOffline != nil:
    body_594956 = regionParameterForOffline
  add(path_594954, "accountName", newJString(accountName))
  result = call_594953.call(path_594954, query_594955, nil, nil, body_594956)

var databaseAccountsOfflineRegion* = Call_DatabaseAccountsOfflineRegion_594944(
    name: "databaseAccountsOfflineRegion", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/offlineRegion",
    validator: validate_DatabaseAccountsOfflineRegion_594945, base: "",
    url: url_DatabaseAccountsOfflineRegion_594946, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsOnlineRegion_594957 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsOnlineRegion_594959(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsOnlineRegion_594958(path: JsonNode; query: JsonNode;
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
  var valid_594960 = path.getOrDefault("resourceGroupName")
  valid_594960 = validateParameter(valid_594960, JString, required = true,
                                 default = nil)
  if valid_594960 != nil:
    section.add "resourceGroupName", valid_594960
  var valid_594961 = path.getOrDefault("subscriptionId")
  valid_594961 = validateParameter(valid_594961, JString, required = true,
                                 default = nil)
  if valid_594961 != nil:
    section.add "subscriptionId", valid_594961
  var valid_594962 = path.getOrDefault("accountName")
  valid_594962 = validateParameter(valid_594962, JString, required = true,
                                 default = nil)
  if valid_594962 != nil:
    section.add "accountName", valid_594962
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594963 = query.getOrDefault("api-version")
  valid_594963 = validateParameter(valid_594963, JString, required = true,
                                 default = nil)
  if valid_594963 != nil:
    section.add "api-version", valid_594963
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

proc call*(call_594965: Call_DatabaseAccountsOnlineRegion_594957; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Online the specified region for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_594965.validator(path, query, header, formData, body)
  let scheme = call_594965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594965.url(scheme.get, call_594965.host, call_594965.base,
                         call_594965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594965, url, valid)

proc call*(call_594966: Call_DatabaseAccountsOnlineRegion_594957;
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
  var path_594967 = newJObject()
  var query_594968 = newJObject()
  var body_594969 = newJObject()
  add(path_594967, "resourceGroupName", newJString(resourceGroupName))
  add(query_594968, "api-version", newJString(apiVersion))
  add(path_594967, "subscriptionId", newJString(subscriptionId))
  if regionParameterForOnline != nil:
    body_594969 = regionParameterForOnline
  add(path_594967, "accountName", newJString(accountName))
  result = call_594966.call(path_594967, query_594968, nil, nil, body_594969)

var databaseAccountsOnlineRegion* = Call_DatabaseAccountsOnlineRegion_594957(
    name: "databaseAccountsOnlineRegion", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/onlineRegion",
    validator: validate_DatabaseAccountsOnlineRegion_594958, base: "",
    url: url_DatabaseAccountsOnlineRegion_594959, schemes: {Scheme.Https})
type
  Call_PercentileListMetrics_594970 = ref object of OpenApiRestCall_593439
proc url_PercentileListMetrics_594972(protocol: Scheme; host: string; base: string;
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

proc validate_PercentileListMetrics_594971(path: JsonNode; query: JsonNode;
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
  var valid_594973 = path.getOrDefault("resourceGroupName")
  valid_594973 = validateParameter(valid_594973, JString, required = true,
                                 default = nil)
  if valid_594973 != nil:
    section.add "resourceGroupName", valid_594973
  var valid_594974 = path.getOrDefault("subscriptionId")
  valid_594974 = validateParameter(valid_594974, JString, required = true,
                                 default = nil)
  if valid_594974 != nil:
    section.add "subscriptionId", valid_594974
  var valid_594975 = path.getOrDefault("accountName")
  valid_594975 = validateParameter(valid_594975, JString, required = true,
                                 default = nil)
  if valid_594975 != nil:
    section.add "accountName", valid_594975
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594976 = query.getOrDefault("api-version")
  valid_594976 = validateParameter(valid_594976, JString, required = true,
                                 default = nil)
  if valid_594976 != nil:
    section.add "api-version", valid_594976
  var valid_594977 = query.getOrDefault("$filter")
  valid_594977 = validateParameter(valid_594977, JString, required = true,
                                 default = nil)
  if valid_594977 != nil:
    section.add "$filter", valid_594977
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594978: Call_PercentileListMetrics_594970; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account. This url is only for PBS and Replication Latency data
  ## 
  let valid = call_594978.validator(path, query, header, formData, body)
  let scheme = call_594978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594978.url(scheme.get, call_594978.host, call_594978.base,
                         call_594978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594978, url, valid)

proc call*(call_594979: Call_PercentileListMetrics_594970;
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
  var path_594980 = newJObject()
  var query_594981 = newJObject()
  add(path_594980, "resourceGroupName", newJString(resourceGroupName))
  add(query_594981, "api-version", newJString(apiVersion))
  add(path_594980, "subscriptionId", newJString(subscriptionId))
  add(path_594980, "accountName", newJString(accountName))
  add(query_594981, "$filter", newJString(Filter))
  result = call_594979.call(path_594980, query_594981, nil, nil, nil)

var percentileListMetrics* = Call_PercentileListMetrics_594970(
    name: "percentileListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/percentile/metrics",
    validator: validate_PercentileListMetrics_594971, base: "",
    url: url_PercentileListMetrics_594972, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListReadOnlyKeys_594993 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsListReadOnlyKeys_594995(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListReadOnlyKeys_594994(path: JsonNode;
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
  var valid_594996 = path.getOrDefault("resourceGroupName")
  valid_594996 = validateParameter(valid_594996, JString, required = true,
                                 default = nil)
  if valid_594996 != nil:
    section.add "resourceGroupName", valid_594996
  var valid_594997 = path.getOrDefault("subscriptionId")
  valid_594997 = validateParameter(valid_594997, JString, required = true,
                                 default = nil)
  if valid_594997 != nil:
    section.add "subscriptionId", valid_594997
  var valid_594998 = path.getOrDefault("accountName")
  valid_594998 = validateParameter(valid_594998, JString, required = true,
                                 default = nil)
  if valid_594998 != nil:
    section.add "accountName", valid_594998
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594999 = query.getOrDefault("api-version")
  valid_594999 = validateParameter(valid_594999, JString, required = true,
                                 default = nil)
  if valid_594999 != nil:
    section.add "api-version", valid_594999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595000: Call_DatabaseAccountsListReadOnlyKeys_594993;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the read-only access keys for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_595000.validator(path, query, header, formData, body)
  let scheme = call_595000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595000.url(scheme.get, call_595000.host, call_595000.base,
                         call_595000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595000, url, valid)

proc call*(call_595001: Call_DatabaseAccountsListReadOnlyKeys_594993;
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
  var path_595002 = newJObject()
  var query_595003 = newJObject()
  add(path_595002, "resourceGroupName", newJString(resourceGroupName))
  add(query_595003, "api-version", newJString(apiVersion))
  add(path_595002, "subscriptionId", newJString(subscriptionId))
  add(path_595002, "accountName", newJString(accountName))
  result = call_595001.call(path_595002, query_595003, nil, nil, nil)

var databaseAccountsListReadOnlyKeys* = Call_DatabaseAccountsListReadOnlyKeys_594993(
    name: "databaseAccountsListReadOnlyKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/readonlykeys",
    validator: validate_DatabaseAccountsListReadOnlyKeys_594994, base: "",
    url: url_DatabaseAccountsListReadOnlyKeys_594995, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsGetReadOnlyKeys_594982 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsGetReadOnlyKeys_594984(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsGetReadOnlyKeys_594983(path: JsonNode;
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
  var valid_594985 = path.getOrDefault("resourceGroupName")
  valid_594985 = validateParameter(valid_594985, JString, required = true,
                                 default = nil)
  if valid_594985 != nil:
    section.add "resourceGroupName", valid_594985
  var valid_594986 = path.getOrDefault("subscriptionId")
  valid_594986 = validateParameter(valid_594986, JString, required = true,
                                 default = nil)
  if valid_594986 != nil:
    section.add "subscriptionId", valid_594986
  var valid_594987 = path.getOrDefault("accountName")
  valid_594987 = validateParameter(valid_594987, JString, required = true,
                                 default = nil)
  if valid_594987 != nil:
    section.add "accountName", valid_594987
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594988 = query.getOrDefault("api-version")
  valid_594988 = validateParameter(valid_594988, JString, required = true,
                                 default = nil)
  if valid_594988 != nil:
    section.add "api-version", valid_594988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594989: Call_DatabaseAccountsGetReadOnlyKeys_594982;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the read-only access keys for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_594989.validator(path, query, header, formData, body)
  let scheme = call_594989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594989.url(scheme.get, call_594989.host, call_594989.base,
                         call_594989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594989, url, valid)

proc call*(call_594990: Call_DatabaseAccountsGetReadOnlyKeys_594982;
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
  var path_594991 = newJObject()
  var query_594992 = newJObject()
  add(path_594991, "resourceGroupName", newJString(resourceGroupName))
  add(query_594992, "api-version", newJString(apiVersion))
  add(path_594991, "subscriptionId", newJString(subscriptionId))
  add(path_594991, "accountName", newJString(accountName))
  result = call_594990.call(path_594991, query_594992, nil, nil, nil)

var databaseAccountsGetReadOnlyKeys* = Call_DatabaseAccountsGetReadOnlyKeys_594982(
    name: "databaseAccountsGetReadOnlyKeys", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/readonlykeys",
    validator: validate_DatabaseAccountsGetReadOnlyKeys_594983, base: "",
    url: url_DatabaseAccountsGetReadOnlyKeys_594984, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsRegenerateKey_595004 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsRegenerateKey_595006(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsRegenerateKey_595005(path: JsonNode; query: JsonNode;
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
  var valid_595007 = path.getOrDefault("resourceGroupName")
  valid_595007 = validateParameter(valid_595007, JString, required = true,
                                 default = nil)
  if valid_595007 != nil:
    section.add "resourceGroupName", valid_595007
  var valid_595008 = path.getOrDefault("subscriptionId")
  valid_595008 = validateParameter(valid_595008, JString, required = true,
                                 default = nil)
  if valid_595008 != nil:
    section.add "subscriptionId", valid_595008
  var valid_595009 = path.getOrDefault("accountName")
  valid_595009 = validateParameter(valid_595009, JString, required = true,
                                 default = nil)
  if valid_595009 != nil:
    section.add "accountName", valid_595009
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595010 = query.getOrDefault("api-version")
  valid_595010 = validateParameter(valid_595010, JString, required = true,
                                 default = nil)
  if valid_595010 != nil:
    section.add "api-version", valid_595010
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

proc call*(call_595012: Call_DatabaseAccountsRegenerateKey_595004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates an access key for the specified Azure Cosmos DB database account.
  ## 
  let valid = call_595012.validator(path, query, header, formData, body)
  let scheme = call_595012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595012.url(scheme.get, call_595012.host, call_595012.base,
                         call_595012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595012, url, valid)

proc call*(call_595013: Call_DatabaseAccountsRegenerateKey_595004;
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
  var path_595014 = newJObject()
  var query_595015 = newJObject()
  var body_595016 = newJObject()
  add(path_595014, "resourceGroupName", newJString(resourceGroupName))
  add(query_595015, "api-version", newJString(apiVersion))
  add(path_595014, "subscriptionId", newJString(subscriptionId))
  add(path_595014, "accountName", newJString(accountName))
  if keyToRegenerate != nil:
    body_595016 = keyToRegenerate
  result = call_595013.call(path_595014, query_595015, nil, nil, body_595016)

var databaseAccountsRegenerateKey* = Call_DatabaseAccountsRegenerateKey_595004(
    name: "databaseAccountsRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/regenerateKey",
    validator: validate_DatabaseAccountsRegenerateKey_595005, base: "",
    url: url_DatabaseAccountsRegenerateKey_595006, schemes: {Scheme.Https})
type
  Call_CollectionRegionListMetrics_595017 = ref object of OpenApiRestCall_593439
proc url_CollectionRegionListMetrics_595019(protocol: Scheme; host: string;
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

proc validate_CollectionRegionListMetrics_595018(path: JsonNode; query: JsonNode;
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
  var valid_595020 = path.getOrDefault("resourceGroupName")
  valid_595020 = validateParameter(valid_595020, JString, required = true,
                                 default = nil)
  if valid_595020 != nil:
    section.add "resourceGroupName", valid_595020
  var valid_595021 = path.getOrDefault("collectionRid")
  valid_595021 = validateParameter(valid_595021, JString, required = true,
                                 default = nil)
  if valid_595021 != nil:
    section.add "collectionRid", valid_595021
  var valid_595022 = path.getOrDefault("subscriptionId")
  valid_595022 = validateParameter(valid_595022, JString, required = true,
                                 default = nil)
  if valid_595022 != nil:
    section.add "subscriptionId", valid_595022
  var valid_595023 = path.getOrDefault("region")
  valid_595023 = validateParameter(valid_595023, JString, required = true,
                                 default = nil)
  if valid_595023 != nil:
    section.add "region", valid_595023
  var valid_595024 = path.getOrDefault("databaseRid")
  valid_595024 = validateParameter(valid_595024, JString, required = true,
                                 default = nil)
  if valid_595024 != nil:
    section.add "databaseRid", valid_595024
  var valid_595025 = path.getOrDefault("accountName")
  valid_595025 = validateParameter(valid_595025, JString, required = true,
                                 default = nil)
  if valid_595025 != nil:
    section.add "accountName", valid_595025
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595026 = query.getOrDefault("api-version")
  valid_595026 = validateParameter(valid_595026, JString, required = true,
                                 default = nil)
  if valid_595026 != nil:
    section.add "api-version", valid_595026
  var valid_595027 = query.getOrDefault("$filter")
  valid_595027 = validateParameter(valid_595027, JString, required = true,
                                 default = nil)
  if valid_595027 != nil:
    section.add "$filter", valid_595027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595028: Call_CollectionRegionListMetrics_595017; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account, collection and region.
  ## 
  let valid = call_595028.validator(path, query, header, formData, body)
  let scheme = call_595028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595028.url(scheme.get, call_595028.host, call_595028.base,
                         call_595028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595028, url, valid)

proc call*(call_595029: Call_CollectionRegionListMetrics_595017;
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
  var path_595030 = newJObject()
  var query_595031 = newJObject()
  add(path_595030, "resourceGroupName", newJString(resourceGroupName))
  add(query_595031, "api-version", newJString(apiVersion))
  add(path_595030, "collectionRid", newJString(collectionRid))
  add(path_595030, "subscriptionId", newJString(subscriptionId))
  add(path_595030, "region", newJString(region))
  add(path_595030, "databaseRid", newJString(databaseRid))
  add(path_595030, "accountName", newJString(accountName))
  add(query_595031, "$filter", newJString(Filter))
  result = call_595029.call(path_595030, query_595031, nil, nil, nil)

var collectionRegionListMetrics* = Call_CollectionRegionListMetrics_595017(
    name: "collectionRegionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/region/{region}/databases/{databaseRid}/collections/{collectionRid}/metrics",
    validator: validate_CollectionRegionListMetrics_595018, base: "",
    url: url_CollectionRegionListMetrics_595019, schemes: {Scheme.Https})
type
  Call_PartitionKeyRangeIdRegionListMetrics_595032 = ref object of OpenApiRestCall_593439
proc url_PartitionKeyRangeIdRegionListMetrics_595034(protocol: Scheme;
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

proc validate_PartitionKeyRangeIdRegionListMetrics_595033(path: JsonNode;
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
  var valid_595035 = path.getOrDefault("resourceGroupName")
  valid_595035 = validateParameter(valid_595035, JString, required = true,
                                 default = nil)
  if valid_595035 != nil:
    section.add "resourceGroupName", valid_595035
  var valid_595036 = path.getOrDefault("collectionRid")
  valid_595036 = validateParameter(valid_595036, JString, required = true,
                                 default = nil)
  if valid_595036 != nil:
    section.add "collectionRid", valid_595036
  var valid_595037 = path.getOrDefault("subscriptionId")
  valid_595037 = validateParameter(valid_595037, JString, required = true,
                                 default = nil)
  if valid_595037 != nil:
    section.add "subscriptionId", valid_595037
  var valid_595038 = path.getOrDefault("partitionKeyRangeId")
  valid_595038 = validateParameter(valid_595038, JString, required = true,
                                 default = nil)
  if valid_595038 != nil:
    section.add "partitionKeyRangeId", valid_595038
  var valid_595039 = path.getOrDefault("region")
  valid_595039 = validateParameter(valid_595039, JString, required = true,
                                 default = nil)
  if valid_595039 != nil:
    section.add "region", valid_595039
  var valid_595040 = path.getOrDefault("databaseRid")
  valid_595040 = validateParameter(valid_595040, JString, required = true,
                                 default = nil)
  if valid_595040 != nil:
    section.add "databaseRid", valid_595040
  var valid_595041 = path.getOrDefault("accountName")
  valid_595041 = validateParameter(valid_595041, JString, required = true,
                                 default = nil)
  if valid_595041 != nil:
    section.add "accountName", valid_595041
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595042 = query.getOrDefault("api-version")
  valid_595042 = validateParameter(valid_595042, JString, required = true,
                                 default = nil)
  if valid_595042 != nil:
    section.add "api-version", valid_595042
  var valid_595043 = query.getOrDefault("$filter")
  valid_595043 = validateParameter(valid_595043, JString, required = true,
                                 default = nil)
  if valid_595043 != nil:
    section.add "$filter", valid_595043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595044: Call_PartitionKeyRangeIdRegionListMetrics_595032;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given partition key range id and region.
  ## 
  let valid = call_595044.validator(path, query, header, formData, body)
  let scheme = call_595044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595044.url(scheme.get, call_595044.host, call_595044.base,
                         call_595044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595044, url, valid)

proc call*(call_595045: Call_PartitionKeyRangeIdRegionListMetrics_595032;
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
  var path_595046 = newJObject()
  var query_595047 = newJObject()
  add(path_595046, "resourceGroupName", newJString(resourceGroupName))
  add(query_595047, "api-version", newJString(apiVersion))
  add(path_595046, "collectionRid", newJString(collectionRid))
  add(path_595046, "subscriptionId", newJString(subscriptionId))
  add(path_595046, "partitionKeyRangeId", newJString(partitionKeyRangeId))
  add(path_595046, "region", newJString(region))
  add(path_595046, "databaseRid", newJString(databaseRid))
  add(path_595046, "accountName", newJString(accountName))
  add(query_595047, "$filter", newJString(Filter))
  result = call_595045.call(path_595046, query_595047, nil, nil, nil)

var partitionKeyRangeIdRegionListMetrics* = Call_PartitionKeyRangeIdRegionListMetrics_595032(
    name: "partitionKeyRangeIdRegionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/region/{region}/databases/{databaseRid}/collections/{collectionRid}/partitionKeyRangeId/{partitionKeyRangeId}/metrics",
    validator: validate_PartitionKeyRangeIdRegionListMetrics_595033, base: "",
    url: url_PartitionKeyRangeIdRegionListMetrics_595034, schemes: {Scheme.Https})
type
  Call_CollectionPartitionRegionListMetrics_595048 = ref object of OpenApiRestCall_593439
proc url_CollectionPartitionRegionListMetrics_595050(protocol: Scheme;
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

proc validate_CollectionPartitionRegionListMetrics_595049(path: JsonNode;
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
  var valid_595051 = path.getOrDefault("resourceGroupName")
  valid_595051 = validateParameter(valid_595051, JString, required = true,
                                 default = nil)
  if valid_595051 != nil:
    section.add "resourceGroupName", valid_595051
  var valid_595052 = path.getOrDefault("collectionRid")
  valid_595052 = validateParameter(valid_595052, JString, required = true,
                                 default = nil)
  if valid_595052 != nil:
    section.add "collectionRid", valid_595052
  var valid_595053 = path.getOrDefault("subscriptionId")
  valid_595053 = validateParameter(valid_595053, JString, required = true,
                                 default = nil)
  if valid_595053 != nil:
    section.add "subscriptionId", valid_595053
  var valid_595054 = path.getOrDefault("region")
  valid_595054 = validateParameter(valid_595054, JString, required = true,
                                 default = nil)
  if valid_595054 != nil:
    section.add "region", valid_595054
  var valid_595055 = path.getOrDefault("databaseRid")
  valid_595055 = validateParameter(valid_595055, JString, required = true,
                                 default = nil)
  if valid_595055 != nil:
    section.add "databaseRid", valid_595055
  var valid_595056 = path.getOrDefault("accountName")
  valid_595056 = validateParameter(valid_595056, JString, required = true,
                                 default = nil)
  if valid_595056 != nil:
    section.add "accountName", valid_595056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595057 = query.getOrDefault("api-version")
  valid_595057 = validateParameter(valid_595057, JString, required = true,
                                 default = nil)
  if valid_595057 != nil:
    section.add "api-version", valid_595057
  var valid_595058 = query.getOrDefault("$filter")
  valid_595058 = validateParameter(valid_595058, JString, required = true,
                                 default = nil)
  if valid_595058 != nil:
    section.add "$filter", valid_595058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595059: Call_CollectionPartitionRegionListMetrics_595048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given collection and region, split by partition.
  ## 
  let valid = call_595059.validator(path, query, header, formData, body)
  let scheme = call_595059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595059.url(scheme.get, call_595059.host, call_595059.base,
                         call_595059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595059, url, valid)

proc call*(call_595060: Call_CollectionPartitionRegionListMetrics_595048;
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
  var path_595061 = newJObject()
  var query_595062 = newJObject()
  add(path_595061, "resourceGroupName", newJString(resourceGroupName))
  add(query_595062, "api-version", newJString(apiVersion))
  add(path_595061, "collectionRid", newJString(collectionRid))
  add(path_595061, "subscriptionId", newJString(subscriptionId))
  add(path_595061, "region", newJString(region))
  add(path_595061, "databaseRid", newJString(databaseRid))
  add(path_595061, "accountName", newJString(accountName))
  add(query_595062, "$filter", newJString(Filter))
  result = call_595060.call(path_595061, query_595062, nil, nil, nil)

var collectionPartitionRegionListMetrics* = Call_CollectionPartitionRegionListMetrics_595048(
    name: "collectionPartitionRegionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/region/{region}/databases/{databaseRid}/collections/{collectionRid}/partitions/metrics",
    validator: validate_CollectionPartitionRegionListMetrics_595049, base: "",
    url: url_CollectionPartitionRegionListMetrics_595050, schemes: {Scheme.Https})
type
  Call_DatabaseAccountRegionListMetrics_595063 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountRegionListMetrics_595065(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountRegionListMetrics_595064(path: JsonNode;
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
  var valid_595066 = path.getOrDefault("resourceGroupName")
  valid_595066 = validateParameter(valid_595066, JString, required = true,
                                 default = nil)
  if valid_595066 != nil:
    section.add "resourceGroupName", valid_595066
  var valid_595067 = path.getOrDefault("subscriptionId")
  valid_595067 = validateParameter(valid_595067, JString, required = true,
                                 default = nil)
  if valid_595067 != nil:
    section.add "subscriptionId", valid_595067
  var valid_595068 = path.getOrDefault("region")
  valid_595068 = validateParameter(valid_595068, JString, required = true,
                                 default = nil)
  if valid_595068 != nil:
    section.add "region", valid_595068
  var valid_595069 = path.getOrDefault("accountName")
  valid_595069 = validateParameter(valid_595069, JString, required = true,
                                 default = nil)
  if valid_595069 != nil:
    section.add "accountName", valid_595069
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595070 = query.getOrDefault("api-version")
  valid_595070 = validateParameter(valid_595070, JString, required = true,
                                 default = nil)
  if valid_595070 != nil:
    section.add "api-version", valid_595070
  var valid_595071 = query.getOrDefault("$filter")
  valid_595071 = validateParameter(valid_595071, JString, required = true,
                                 default = nil)
  if valid_595071 != nil:
    section.add "$filter", valid_595071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595072: Call_DatabaseAccountRegionListMetrics_595063;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given database account and region.
  ## 
  let valid = call_595072.validator(path, query, header, formData, body)
  let scheme = call_595072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595072.url(scheme.get, call_595072.host, call_595072.base,
                         call_595072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595072, url, valid)

proc call*(call_595073: Call_DatabaseAccountRegionListMetrics_595063;
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
  var path_595074 = newJObject()
  var query_595075 = newJObject()
  add(path_595074, "resourceGroupName", newJString(resourceGroupName))
  add(query_595075, "api-version", newJString(apiVersion))
  add(path_595074, "subscriptionId", newJString(subscriptionId))
  add(path_595074, "region", newJString(region))
  add(path_595074, "accountName", newJString(accountName))
  add(query_595075, "$filter", newJString(Filter))
  result = call_595073.call(path_595074, query_595075, nil, nil, nil)

var databaseAccountRegionListMetrics* = Call_DatabaseAccountRegionListMetrics_595063(
    name: "databaseAccountRegionListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/region/{region}/metrics",
    validator: validate_DatabaseAccountRegionListMetrics_595064, base: "",
    url: url_DatabaseAccountRegionListMetrics_595065, schemes: {Scheme.Https})
type
  Call_PercentileSourceTargetListMetrics_595076 = ref object of OpenApiRestCall_593439
proc url_PercentileSourceTargetListMetrics_595078(protocol: Scheme; host: string;
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

proc validate_PercentileSourceTargetListMetrics_595077(path: JsonNode;
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
  var valid_595079 = path.getOrDefault("resourceGroupName")
  valid_595079 = validateParameter(valid_595079, JString, required = true,
                                 default = nil)
  if valid_595079 != nil:
    section.add "resourceGroupName", valid_595079
  var valid_595080 = path.getOrDefault("sourceRegion")
  valid_595080 = validateParameter(valid_595080, JString, required = true,
                                 default = nil)
  if valid_595080 != nil:
    section.add "sourceRegion", valid_595080
  var valid_595081 = path.getOrDefault("subscriptionId")
  valid_595081 = validateParameter(valid_595081, JString, required = true,
                                 default = nil)
  if valid_595081 != nil:
    section.add "subscriptionId", valid_595081
  var valid_595082 = path.getOrDefault("targetRegion")
  valid_595082 = validateParameter(valid_595082, JString, required = true,
                                 default = nil)
  if valid_595082 != nil:
    section.add "targetRegion", valid_595082
  var valid_595083 = path.getOrDefault("accountName")
  valid_595083 = validateParameter(valid_595083, JString, required = true,
                                 default = nil)
  if valid_595083 != nil:
    section.add "accountName", valid_595083
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595084 = query.getOrDefault("api-version")
  valid_595084 = validateParameter(valid_595084, JString, required = true,
                                 default = nil)
  if valid_595084 != nil:
    section.add "api-version", valid_595084
  var valid_595085 = query.getOrDefault("$filter")
  valid_595085 = validateParameter(valid_595085, JString, required = true,
                                 default = nil)
  if valid_595085 != nil:
    section.add "$filter", valid_595085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595086: Call_PercentileSourceTargetListMetrics_595076;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given account, source and target region. This url is only for PBS and Replication Latency data
  ## 
  let valid = call_595086.validator(path, query, header, formData, body)
  let scheme = call_595086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595086.url(scheme.get, call_595086.host, call_595086.base,
                         call_595086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595086, url, valid)

proc call*(call_595087: Call_PercentileSourceTargetListMetrics_595076;
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
  var path_595088 = newJObject()
  var query_595089 = newJObject()
  add(path_595088, "resourceGroupName", newJString(resourceGroupName))
  add(query_595089, "api-version", newJString(apiVersion))
  add(path_595088, "sourceRegion", newJString(sourceRegion))
  add(path_595088, "subscriptionId", newJString(subscriptionId))
  add(path_595088, "targetRegion", newJString(targetRegion))
  add(path_595088, "accountName", newJString(accountName))
  add(query_595089, "$filter", newJString(Filter))
  result = call_595087.call(path_595088, query_595089, nil, nil, nil)

var percentileSourceTargetListMetrics* = Call_PercentileSourceTargetListMetrics_595076(
    name: "percentileSourceTargetListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/sourceRegion/{sourceRegion}/targetRegion/{targetRegion}/percentile/metrics",
    validator: validate_PercentileSourceTargetListMetrics_595077, base: "",
    url: url_PercentileSourceTargetListMetrics_595078, schemes: {Scheme.Https})
type
  Call_PercentileTargetListMetrics_595090 = ref object of OpenApiRestCall_593439
proc url_PercentileTargetListMetrics_595092(protocol: Scheme; host: string;
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

proc validate_PercentileTargetListMetrics_595091(path: JsonNode; query: JsonNode;
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
  var valid_595093 = path.getOrDefault("resourceGroupName")
  valid_595093 = validateParameter(valid_595093, JString, required = true,
                                 default = nil)
  if valid_595093 != nil:
    section.add "resourceGroupName", valid_595093
  var valid_595094 = path.getOrDefault("subscriptionId")
  valid_595094 = validateParameter(valid_595094, JString, required = true,
                                 default = nil)
  if valid_595094 != nil:
    section.add "subscriptionId", valid_595094
  var valid_595095 = path.getOrDefault("targetRegion")
  valid_595095 = validateParameter(valid_595095, JString, required = true,
                                 default = nil)
  if valid_595095 != nil:
    section.add "targetRegion", valid_595095
  var valid_595096 = path.getOrDefault("accountName")
  valid_595096 = validateParameter(valid_595096, JString, required = true,
                                 default = nil)
  if valid_595096 != nil:
    section.add "accountName", valid_595096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString (required)
  ##          : An OData filter expression that describes a subset of metrics to return. The parameters that can be filtered are name.value (name of the metric, can have an or of multiple names), startTime, endTime, and timeGrain. The supported operator is eq.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595097 = query.getOrDefault("api-version")
  valid_595097 = validateParameter(valid_595097, JString, required = true,
                                 default = nil)
  if valid_595097 != nil:
    section.add "api-version", valid_595097
  var valid_595098 = query.getOrDefault("$filter")
  valid_595098 = validateParameter(valid_595098, JString, required = true,
                                 default = nil)
  if valid_595098 != nil:
    section.add "$filter", valid_595098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595099: Call_PercentileTargetListMetrics_595090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metrics determined by the given filter for the given account target region. This url is only for PBS and Replication Latency data
  ## 
  let valid = call_595099.validator(path, query, header, formData, body)
  let scheme = call_595099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595099.url(scheme.get, call_595099.host, call_595099.base,
                         call_595099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595099, url, valid)

proc call*(call_595100: Call_PercentileTargetListMetrics_595090;
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
  var path_595101 = newJObject()
  var query_595102 = newJObject()
  add(path_595101, "resourceGroupName", newJString(resourceGroupName))
  add(query_595102, "api-version", newJString(apiVersion))
  add(path_595101, "subscriptionId", newJString(subscriptionId))
  add(path_595101, "targetRegion", newJString(targetRegion))
  add(path_595101, "accountName", newJString(accountName))
  add(query_595102, "$filter", newJString(Filter))
  result = call_595100.call(path_595101, query_595102, nil, nil, nil)

var percentileTargetListMetrics* = Call_PercentileTargetListMetrics_595090(
    name: "percentileTargetListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/targetRegion/{targetRegion}/percentile/metrics",
    validator: validate_PercentileTargetListMetrics_595091, base: "",
    url: url_PercentileTargetListMetrics_595092, schemes: {Scheme.Https})
type
  Call_DatabaseAccountsListUsages_595103 = ref object of OpenApiRestCall_593439
proc url_DatabaseAccountsListUsages_595105(protocol: Scheme; host: string;
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

proc validate_DatabaseAccountsListUsages_595104(path: JsonNode; query: JsonNode;
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
  var valid_595106 = path.getOrDefault("resourceGroupName")
  valid_595106 = validateParameter(valid_595106, JString, required = true,
                                 default = nil)
  if valid_595106 != nil:
    section.add "resourceGroupName", valid_595106
  var valid_595107 = path.getOrDefault("subscriptionId")
  valid_595107 = validateParameter(valid_595107, JString, required = true,
                                 default = nil)
  if valid_595107 != nil:
    section.add "subscriptionId", valid_595107
  var valid_595108 = path.getOrDefault("accountName")
  valid_595108 = validateParameter(valid_595108, JString, required = true,
                                 default = nil)
  if valid_595108 != nil:
    section.add "accountName", valid_595108
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2015-04-08.
  ##   $filter: JString
  ##          : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595109 = query.getOrDefault("api-version")
  valid_595109 = validateParameter(valid_595109, JString, required = true,
                                 default = nil)
  if valid_595109 != nil:
    section.add "api-version", valid_595109
  var valid_595110 = query.getOrDefault("$filter")
  valid_595110 = validateParameter(valid_595110, JString, required = false,
                                 default = nil)
  if valid_595110 != nil:
    section.add "$filter", valid_595110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595111: Call_DatabaseAccountsListUsages_595103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the usages (most recent data) for the given database account.
  ## 
  let valid = call_595111.validator(path, query, header, formData, body)
  let scheme = call_595111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595111.url(scheme.get, call_595111.host, call_595111.base,
                         call_595111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595111, url, valid)

proc call*(call_595112: Call_DatabaseAccountsListUsages_595103;
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
  var path_595113 = newJObject()
  var query_595114 = newJObject()
  add(path_595113, "resourceGroupName", newJString(resourceGroupName))
  add(query_595114, "api-version", newJString(apiVersion))
  add(path_595113, "subscriptionId", newJString(subscriptionId))
  add(path_595113, "accountName", newJString(accountName))
  add(query_595114, "$filter", newJString(Filter))
  result = call_595112.call(path_595113, query_595114, nil, nil, nil)

var databaseAccountsListUsages* = Call_DatabaseAccountsListUsages_595103(
    name: "databaseAccountsListUsages", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DocumentDB/databaseAccounts/{accountName}/usages",
    validator: validate_DatabaseAccountsListUsages_595104, base: "",
    url: url_DatabaseAccountsListUsages_595105, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
