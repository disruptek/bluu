
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: LogicManagementClient
## version: 2015-08-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## REST API for Azure Logic Apps.
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

  OpenApiRestCall_593421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593421): Option[Scheme] {.used.} =
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
  macServiceName = "logic"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_IntegrationAccountsListBySubscription_593643 = ref object of OpenApiRestCall_593421
proc url_IntegrationAccountsListBySubscription_593645(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountsListBySubscription_593644(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of integration accounts by subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593819 = path.getOrDefault("subscriptionId")
  valid_593819 = validateParameter(valid_593819, JString, required = true,
                                 default = nil)
  if valid_593819 != nil:
    section.add "subscriptionId", valid_593819
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593820 = query.getOrDefault("api-version")
  valid_593820 = validateParameter(valid_593820, JString, required = true,
                                 default = nil)
  if valid_593820 != nil:
    section.add "api-version", valid_593820
  var valid_593821 = query.getOrDefault("$top")
  valid_593821 = validateParameter(valid_593821, JInt, required = false, default = nil)
  if valid_593821 != nil:
    section.add "$top", valid_593821
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593844: Call_IntegrationAccountsListBySubscription_593643;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration accounts by subscription.
  ## 
  let valid = call_593844.validator(path, query, header, formData, body)
  let scheme = call_593844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593844.url(scheme.get, call_593844.host, call_593844.base,
                         call_593844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593844, url, valid)

proc call*(call_593915: Call_IntegrationAccountsListBySubscription_593643;
          apiVersion: string; subscriptionId: string; Top: int = 0): Recallable =
  ## integrationAccountsListBySubscription
  ## Gets a list of integration accounts by subscription.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   Top: int
  ##      : The number of items to be included in the result.
  var path_593916 = newJObject()
  var query_593918 = newJObject()
  add(query_593918, "api-version", newJString(apiVersion))
  add(path_593916, "subscriptionId", newJString(subscriptionId))
  add(query_593918, "$top", newJInt(Top))
  result = call_593915.call(path_593916, query_593918, nil, nil, nil)

var integrationAccountsListBySubscription* = Call_IntegrationAccountsListBySubscription_593643(
    name: "integrationAccountsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Logic/integrationAccounts",
    validator: validate_IntegrationAccountsListBySubscription_593644, base: "",
    url: url_IntegrationAccountsListBySubscription_593645, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsListByResourceGroup_593957 = ref object of OpenApiRestCall_593421
proc url_IntegrationAccountsListByResourceGroup_593959(protocol: Scheme;
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
        value: "/providers/Microsoft.Logic/integrationAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountsListByResourceGroup_593958(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of integration accounts by resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593960 = path.getOrDefault("resourceGroupName")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = nil)
  if valid_593960 != nil:
    section.add "resourceGroupName", valid_593960
  var valid_593961 = path.getOrDefault("subscriptionId")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "subscriptionId", valid_593961
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593962 = query.getOrDefault("api-version")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "api-version", valid_593962
  var valid_593963 = query.getOrDefault("$top")
  valid_593963 = validateParameter(valid_593963, JInt, required = false, default = nil)
  if valid_593963 != nil:
    section.add "$top", valid_593963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593964: Call_IntegrationAccountsListByResourceGroup_593957;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration accounts by resource group.
  ## 
  let valid = call_593964.validator(path, query, header, formData, body)
  let scheme = call_593964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593964.url(scheme.get, call_593964.host, call_593964.base,
                         call_593964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593964, url, valid)

proc call*(call_593965: Call_IntegrationAccountsListByResourceGroup_593957;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0): Recallable =
  ## integrationAccountsListByResourceGroup
  ## Gets a list of integration accounts by resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   Top: int
  ##      : The number of items to be included in the result.
  var path_593966 = newJObject()
  var query_593967 = newJObject()
  add(path_593966, "resourceGroupName", newJString(resourceGroupName))
  add(query_593967, "api-version", newJString(apiVersion))
  add(path_593966, "subscriptionId", newJString(subscriptionId))
  add(query_593967, "$top", newJInt(Top))
  result = call_593965.call(path_593966, query_593967, nil, nil, nil)

var integrationAccountsListByResourceGroup* = Call_IntegrationAccountsListByResourceGroup_593957(
    name: "integrationAccountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts",
    validator: validate_IntegrationAccountsListByResourceGroup_593958, base: "",
    url: url_IntegrationAccountsListByResourceGroup_593959,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountsCreateOrUpdate_593979 = ref object of OpenApiRestCall_593421
proc url_IntegrationAccountsCreateOrUpdate_593981(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountsCreateOrUpdate_593980(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an integration account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593982 = path.getOrDefault("resourceGroupName")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "resourceGroupName", valid_593982
  var valid_593983 = path.getOrDefault("integrationAccountName")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "integrationAccountName", valid_593983
  var valid_593984 = path.getOrDefault("subscriptionId")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "subscriptionId", valid_593984
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593985 = query.getOrDefault("api-version")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "api-version", valid_593985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   integrationAccount: JObject (required)
  ##                     : The integration account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593987: Call_IntegrationAccountsCreateOrUpdate_593979;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account.
  ## 
  let valid = call_593987.validator(path, query, header, formData, body)
  let scheme = call_593987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593987.url(scheme.get, call_593987.host, call_593987.base,
                         call_593987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593987, url, valid)

proc call*(call_593988: Call_IntegrationAccountsCreateOrUpdate_593979;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          integrationAccount: JsonNode): Recallable =
  ## integrationAccountsCreateOrUpdate
  ## Creates or updates an integration account.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   integrationAccount: JObject (required)
  ##                     : The integration account.
  var path_593989 = newJObject()
  var query_593990 = newJObject()
  var body_593991 = newJObject()
  add(path_593989, "resourceGroupName", newJString(resourceGroupName))
  add(query_593990, "api-version", newJString(apiVersion))
  add(path_593989, "integrationAccountName", newJString(integrationAccountName))
  add(path_593989, "subscriptionId", newJString(subscriptionId))
  if integrationAccount != nil:
    body_593991 = integrationAccount
  result = call_593988.call(path_593989, query_593990, nil, nil, body_593991)

var integrationAccountsCreateOrUpdate* = Call_IntegrationAccountsCreateOrUpdate_593979(
    name: "integrationAccountsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}",
    validator: validate_IntegrationAccountsCreateOrUpdate_593980, base: "",
    url: url_IntegrationAccountsCreateOrUpdate_593981, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsGet_593968 = ref object of OpenApiRestCall_593421
proc url_IntegrationAccountsGet_593970(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountsGet_593969(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an integration account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593971 = path.getOrDefault("resourceGroupName")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = nil)
  if valid_593971 != nil:
    section.add "resourceGroupName", valid_593971
  var valid_593972 = path.getOrDefault("integrationAccountName")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "integrationAccountName", valid_593972
  var valid_593973 = path.getOrDefault("subscriptionId")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "subscriptionId", valid_593973
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593974 = query.getOrDefault("api-version")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "api-version", valid_593974
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593975: Call_IntegrationAccountsGet_593968; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account.
  ## 
  let valid = call_593975.validator(path, query, header, formData, body)
  let scheme = call_593975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593975.url(scheme.get, call_593975.host, call_593975.base,
                         call_593975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593975, url, valid)

proc call*(call_593976: Call_IntegrationAccountsGet_593968;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string): Recallable =
  ## integrationAccountsGet
  ## Gets an integration account.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_593977 = newJObject()
  var query_593978 = newJObject()
  add(path_593977, "resourceGroupName", newJString(resourceGroupName))
  add(query_593978, "api-version", newJString(apiVersion))
  add(path_593977, "integrationAccountName", newJString(integrationAccountName))
  add(path_593977, "subscriptionId", newJString(subscriptionId))
  result = call_593976.call(path_593977, query_593978, nil, nil, nil)

var integrationAccountsGet* = Call_IntegrationAccountsGet_593968(
    name: "integrationAccountsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}",
    validator: validate_IntegrationAccountsGet_593969, base: "",
    url: url_IntegrationAccountsGet_593970, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsUpdate_594003 = ref object of OpenApiRestCall_593421
proc url_IntegrationAccountsUpdate_594005(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountsUpdate_594004(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an integration account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594006 = path.getOrDefault("resourceGroupName")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "resourceGroupName", valid_594006
  var valid_594007 = path.getOrDefault("integrationAccountName")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "integrationAccountName", valid_594007
  var valid_594008 = path.getOrDefault("subscriptionId")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "subscriptionId", valid_594008
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594009 = query.getOrDefault("api-version")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "api-version", valid_594009
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   integrationAccount: JObject (required)
  ##                     : The integration account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594011: Call_IntegrationAccountsUpdate_594003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an integration account.
  ## 
  let valid = call_594011.validator(path, query, header, formData, body)
  let scheme = call_594011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594011.url(scheme.get, call_594011.host, call_594011.base,
                         call_594011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594011, url, valid)

proc call*(call_594012: Call_IntegrationAccountsUpdate_594003;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          integrationAccount: JsonNode): Recallable =
  ## integrationAccountsUpdate
  ## Updates an integration account.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   integrationAccount: JObject (required)
  ##                     : The integration account.
  var path_594013 = newJObject()
  var query_594014 = newJObject()
  var body_594015 = newJObject()
  add(path_594013, "resourceGroupName", newJString(resourceGroupName))
  add(query_594014, "api-version", newJString(apiVersion))
  add(path_594013, "integrationAccountName", newJString(integrationAccountName))
  add(path_594013, "subscriptionId", newJString(subscriptionId))
  if integrationAccount != nil:
    body_594015 = integrationAccount
  result = call_594012.call(path_594013, query_594014, nil, nil, body_594015)

var integrationAccountsUpdate* = Call_IntegrationAccountsUpdate_594003(
    name: "integrationAccountsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}",
    validator: validate_IntegrationAccountsUpdate_594004, base: "",
    url: url_IntegrationAccountsUpdate_594005, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsDelete_593992 = ref object of OpenApiRestCall_593421
proc url_IntegrationAccountsDelete_593994(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountsDelete_593993(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an integration account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593995 = path.getOrDefault("resourceGroupName")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "resourceGroupName", valid_593995
  var valid_593996 = path.getOrDefault("integrationAccountName")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "integrationAccountName", valid_593996
  var valid_593997 = path.getOrDefault("subscriptionId")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "subscriptionId", valid_593997
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593998 = query.getOrDefault("api-version")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "api-version", valid_593998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593999: Call_IntegrationAccountsDelete_593992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration account.
  ## 
  let valid = call_593999.validator(path, query, header, formData, body)
  let scheme = call_593999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593999.url(scheme.get, call_593999.host, call_593999.base,
                         call_593999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593999, url, valid)

proc call*(call_594000: Call_IntegrationAccountsDelete_593992;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string): Recallable =
  ## integrationAccountsDelete
  ## Deletes an integration account.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_594001 = newJObject()
  var query_594002 = newJObject()
  add(path_594001, "resourceGroupName", newJString(resourceGroupName))
  add(query_594002, "api-version", newJString(apiVersion))
  add(path_594001, "integrationAccountName", newJString(integrationAccountName))
  add(path_594001, "subscriptionId", newJString(subscriptionId))
  result = call_594000.call(path_594001, query_594002, nil, nil, nil)

var integrationAccountsDelete* = Call_IntegrationAccountsDelete_593992(
    name: "integrationAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}",
    validator: validate_IntegrationAccountsDelete_593993, base: "",
    url: url_IntegrationAccountsDelete_593994, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAgreementsList_594016 = ref object of OpenApiRestCall_593421
proc url_IntegrationAccountAgreementsList_594018(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/agreements")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountAgreementsList_594017(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of integration account agreements.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594019 = path.getOrDefault("resourceGroupName")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "resourceGroupName", valid_594019
  var valid_594020 = path.getOrDefault("integrationAccountName")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "integrationAccountName", valid_594020
  var valid_594021 = path.getOrDefault("subscriptionId")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "subscriptionId", valid_594021
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594022 = query.getOrDefault("api-version")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "api-version", valid_594022
  var valid_594023 = query.getOrDefault("$top")
  valid_594023 = validateParameter(valid_594023, JInt, required = false, default = nil)
  if valid_594023 != nil:
    section.add "$top", valid_594023
  var valid_594024 = query.getOrDefault("$filter")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "$filter", valid_594024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594025: Call_IntegrationAccountAgreementsList_594016;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration account agreements.
  ## 
  let valid = call_594025.validator(path, query, header, formData, body)
  let scheme = call_594025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594025.url(scheme.get, call_594025.host, call_594025.base,
                         call_594025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594025, url, valid)

proc call*(call_594026: Call_IntegrationAccountAgreementsList_594016;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string; Top: int = 0;
          Filter: string = ""): Recallable =
  ## integrationAccountAgreementsList
  ## Gets a list of integration account agreements.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_594027 = newJObject()
  var query_594028 = newJObject()
  add(path_594027, "resourceGroupName", newJString(resourceGroupName))
  add(query_594028, "api-version", newJString(apiVersion))
  add(path_594027, "integrationAccountName", newJString(integrationAccountName))
  add(path_594027, "subscriptionId", newJString(subscriptionId))
  add(query_594028, "$top", newJInt(Top))
  add(query_594028, "$filter", newJString(Filter))
  result = call_594026.call(path_594027, query_594028, nil, nil, nil)

var integrationAccountAgreementsList* = Call_IntegrationAccountAgreementsList_594016(
    name: "integrationAccountAgreementsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements",
    validator: validate_IntegrationAccountAgreementsList_594017, base: "",
    url: url_IntegrationAccountAgreementsList_594018, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAgreementsCreateOrUpdate_594041 = ref object of OpenApiRestCall_593421
proc url_IntegrationAccountAgreementsCreateOrUpdate_594043(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "agreementName" in path, "`agreementName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/agreements/"),
               (kind: VariableSegment, value: "agreementName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountAgreementsCreateOrUpdate_594042(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an integration account agreement.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   agreementName: JString (required)
  ##                : The integration account agreement name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594044 = path.getOrDefault("resourceGroupName")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "resourceGroupName", valid_594044
  var valid_594045 = path.getOrDefault("integrationAccountName")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "integrationAccountName", valid_594045
  var valid_594046 = path.getOrDefault("subscriptionId")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "subscriptionId", valid_594046
  var valid_594047 = path.getOrDefault("agreementName")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "agreementName", valid_594047
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594048 = query.getOrDefault("api-version")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "api-version", valid_594048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   agreement: JObject (required)
  ##            : The integration account agreement.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594050: Call_IntegrationAccountAgreementsCreateOrUpdate_594041;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account agreement.
  ## 
  let valid = call_594050.validator(path, query, header, formData, body)
  let scheme = call_594050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594050.url(scheme.get, call_594050.host, call_594050.base,
                         call_594050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594050, url, valid)

proc call*(call_594051: Call_IntegrationAccountAgreementsCreateOrUpdate_594041;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          agreementName: string; agreement: JsonNode): Recallable =
  ## integrationAccountAgreementsCreateOrUpdate
  ## Creates or updates an integration account agreement.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   agreementName: string (required)
  ##                : The integration account agreement name.
  ##   agreement: JObject (required)
  ##            : The integration account agreement.
  var path_594052 = newJObject()
  var query_594053 = newJObject()
  var body_594054 = newJObject()
  add(path_594052, "resourceGroupName", newJString(resourceGroupName))
  add(query_594053, "api-version", newJString(apiVersion))
  add(path_594052, "integrationAccountName", newJString(integrationAccountName))
  add(path_594052, "subscriptionId", newJString(subscriptionId))
  add(path_594052, "agreementName", newJString(agreementName))
  if agreement != nil:
    body_594054 = agreement
  result = call_594051.call(path_594052, query_594053, nil, nil, body_594054)

var integrationAccountAgreementsCreateOrUpdate* = Call_IntegrationAccountAgreementsCreateOrUpdate_594041(
    name: "integrationAccountAgreementsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}",
    validator: validate_IntegrationAccountAgreementsCreateOrUpdate_594042,
    base: "", url: url_IntegrationAccountAgreementsCreateOrUpdate_594043,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountAgreementsGet_594029 = ref object of OpenApiRestCall_593421
proc url_IntegrationAccountAgreementsGet_594031(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "agreementName" in path, "`agreementName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/agreements/"),
               (kind: VariableSegment, value: "agreementName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountAgreementsGet_594030(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an integration account agreement.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   agreementName: JString (required)
  ##                : The integration account agreement name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594032 = path.getOrDefault("resourceGroupName")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "resourceGroupName", valid_594032
  var valid_594033 = path.getOrDefault("integrationAccountName")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "integrationAccountName", valid_594033
  var valid_594034 = path.getOrDefault("subscriptionId")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "subscriptionId", valid_594034
  var valid_594035 = path.getOrDefault("agreementName")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "agreementName", valid_594035
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594036 = query.getOrDefault("api-version")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "api-version", valid_594036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594037: Call_IntegrationAccountAgreementsGet_594029;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an integration account agreement.
  ## 
  let valid = call_594037.validator(path, query, header, formData, body)
  let scheme = call_594037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594037.url(scheme.get, call_594037.host, call_594037.base,
                         call_594037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594037, url, valid)

proc call*(call_594038: Call_IntegrationAccountAgreementsGet_594029;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          agreementName: string): Recallable =
  ## integrationAccountAgreementsGet
  ## Gets an integration account agreement.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   agreementName: string (required)
  ##                : The integration account agreement name.
  var path_594039 = newJObject()
  var query_594040 = newJObject()
  add(path_594039, "resourceGroupName", newJString(resourceGroupName))
  add(query_594040, "api-version", newJString(apiVersion))
  add(path_594039, "integrationAccountName", newJString(integrationAccountName))
  add(path_594039, "subscriptionId", newJString(subscriptionId))
  add(path_594039, "agreementName", newJString(agreementName))
  result = call_594038.call(path_594039, query_594040, nil, nil, nil)

var integrationAccountAgreementsGet* = Call_IntegrationAccountAgreementsGet_594029(
    name: "integrationAccountAgreementsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}",
    validator: validate_IntegrationAccountAgreementsGet_594030, base: "",
    url: url_IntegrationAccountAgreementsGet_594031, schemes: {Scheme.Https})
type
  Call_IntegrationAccountAgreementsDelete_594055 = ref object of OpenApiRestCall_593421
proc url_IntegrationAccountAgreementsDelete_594057(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "agreementName" in path, "`agreementName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/agreements/"),
               (kind: VariableSegment, value: "agreementName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountAgreementsDelete_594056(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an integration account agreement.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   agreementName: JString (required)
  ##                : The integration account agreement name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594058 = path.getOrDefault("resourceGroupName")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "resourceGroupName", valid_594058
  var valid_594059 = path.getOrDefault("integrationAccountName")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "integrationAccountName", valid_594059
  var valid_594060 = path.getOrDefault("subscriptionId")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "subscriptionId", valid_594060
  var valid_594061 = path.getOrDefault("agreementName")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "agreementName", valid_594061
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594062 = query.getOrDefault("api-version")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "api-version", valid_594062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594063: Call_IntegrationAccountAgreementsDelete_594055;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an integration account agreement.
  ## 
  let valid = call_594063.validator(path, query, header, formData, body)
  let scheme = call_594063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594063.url(scheme.get, call_594063.host, call_594063.base,
                         call_594063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594063, url, valid)

proc call*(call_594064: Call_IntegrationAccountAgreementsDelete_594055;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          agreementName: string): Recallable =
  ## integrationAccountAgreementsDelete
  ## Deletes an integration account agreement.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   agreementName: string (required)
  ##                : The integration account agreement name.
  var path_594065 = newJObject()
  var query_594066 = newJObject()
  add(path_594065, "resourceGroupName", newJString(resourceGroupName))
  add(query_594066, "api-version", newJString(apiVersion))
  add(path_594065, "integrationAccountName", newJString(integrationAccountName))
  add(path_594065, "subscriptionId", newJString(subscriptionId))
  add(path_594065, "agreementName", newJString(agreementName))
  result = call_594064.call(path_594065, query_594066, nil, nil, nil)

var integrationAccountAgreementsDelete* = Call_IntegrationAccountAgreementsDelete_594055(
    name: "integrationAccountAgreementsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}",
    validator: validate_IntegrationAccountAgreementsDelete_594056, base: "",
    url: url_IntegrationAccountAgreementsDelete_594057, schemes: {Scheme.Https})
type
  Call_IntegrationAccountCertificatesList_594067 = ref object of OpenApiRestCall_593421
proc url_IntegrationAccountCertificatesList_594069(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/certificates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountCertificatesList_594068(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of integration account certificates.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594070 = path.getOrDefault("resourceGroupName")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "resourceGroupName", valid_594070
  var valid_594071 = path.getOrDefault("integrationAccountName")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "integrationAccountName", valid_594071
  var valid_594072 = path.getOrDefault("subscriptionId")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "subscriptionId", valid_594072
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594073 = query.getOrDefault("api-version")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "api-version", valid_594073
  var valid_594074 = query.getOrDefault("$top")
  valid_594074 = validateParameter(valid_594074, JInt, required = false, default = nil)
  if valid_594074 != nil:
    section.add "$top", valid_594074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594075: Call_IntegrationAccountCertificatesList_594067;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of integration account certificates.
  ## 
  let valid = call_594075.validator(path, query, header, formData, body)
  let scheme = call_594075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594075.url(scheme.get, call_594075.host, call_594075.base,
                         call_594075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594075, url, valid)

proc call*(call_594076: Call_IntegrationAccountCertificatesList_594067;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string; Top: int = 0): Recallable =
  ## integrationAccountCertificatesList
  ## Gets a list of integration account certificates.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   Top: int
  ##      : The number of items to be included in the result.
  var path_594077 = newJObject()
  var query_594078 = newJObject()
  add(path_594077, "resourceGroupName", newJString(resourceGroupName))
  add(query_594078, "api-version", newJString(apiVersion))
  add(path_594077, "integrationAccountName", newJString(integrationAccountName))
  add(path_594077, "subscriptionId", newJString(subscriptionId))
  add(query_594078, "$top", newJInt(Top))
  result = call_594076.call(path_594077, query_594078, nil, nil, nil)

var integrationAccountCertificatesList* = Call_IntegrationAccountCertificatesList_594067(
    name: "integrationAccountCertificatesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates",
    validator: validate_IntegrationAccountCertificatesList_594068, base: "",
    url: url_IntegrationAccountCertificatesList_594069, schemes: {Scheme.Https})
type
  Call_IntegrationAccountCertificatesCreateOrUpdate_594091 = ref object of OpenApiRestCall_593421
proc url_IntegrationAccountCertificatesCreateOrUpdate_594093(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "certificateName" in path, "`certificateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountCertificatesCreateOrUpdate_594092(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an integration account certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   certificateName: JString (required)
  ##                  : The integration account certificate name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594094 = path.getOrDefault("resourceGroupName")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "resourceGroupName", valid_594094
  var valid_594095 = path.getOrDefault("integrationAccountName")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "integrationAccountName", valid_594095
  var valid_594096 = path.getOrDefault("subscriptionId")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "subscriptionId", valid_594096
  var valid_594097 = path.getOrDefault("certificateName")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "certificateName", valid_594097
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594098 = query.getOrDefault("api-version")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "api-version", valid_594098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   certificate: JObject (required)
  ##              : The integration account certificate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594100: Call_IntegrationAccountCertificatesCreateOrUpdate_594091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account certificate.
  ## 
  let valid = call_594100.validator(path, query, header, formData, body)
  let scheme = call_594100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594100.url(scheme.get, call_594100.host, call_594100.base,
                         call_594100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594100, url, valid)

proc call*(call_594101: Call_IntegrationAccountCertificatesCreateOrUpdate_594091;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          certificate: JsonNode; certificateName: string): Recallable =
  ## integrationAccountCertificatesCreateOrUpdate
  ## Creates or updates an integration account certificate.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   certificate: JObject (required)
  ##              : The integration account certificate.
  ##   certificateName: string (required)
  ##                  : The integration account certificate name.
  var path_594102 = newJObject()
  var query_594103 = newJObject()
  var body_594104 = newJObject()
  add(path_594102, "resourceGroupName", newJString(resourceGroupName))
  add(query_594103, "api-version", newJString(apiVersion))
  add(path_594102, "integrationAccountName", newJString(integrationAccountName))
  add(path_594102, "subscriptionId", newJString(subscriptionId))
  if certificate != nil:
    body_594104 = certificate
  add(path_594102, "certificateName", newJString(certificateName))
  result = call_594101.call(path_594102, query_594103, nil, nil, body_594104)

var integrationAccountCertificatesCreateOrUpdate* = Call_IntegrationAccountCertificatesCreateOrUpdate_594091(
    name: "integrationAccountCertificatesCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates/{certificateName}",
    validator: validate_IntegrationAccountCertificatesCreateOrUpdate_594092,
    base: "", url: url_IntegrationAccountCertificatesCreateOrUpdate_594093,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountCertificatesGet_594079 = ref object of OpenApiRestCall_593421
proc url_IntegrationAccountCertificatesGet_594081(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "certificateName" in path, "`certificateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountCertificatesGet_594080(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an integration account certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   certificateName: JString (required)
  ##                  : The integration account certificate name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594082 = path.getOrDefault("resourceGroupName")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "resourceGroupName", valid_594082
  var valid_594083 = path.getOrDefault("integrationAccountName")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "integrationAccountName", valid_594083
  var valid_594084 = path.getOrDefault("subscriptionId")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "subscriptionId", valid_594084
  var valid_594085 = path.getOrDefault("certificateName")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "certificateName", valid_594085
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594086 = query.getOrDefault("api-version")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "api-version", valid_594086
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594087: Call_IntegrationAccountCertificatesGet_594079;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an integration account certificate.
  ## 
  let valid = call_594087.validator(path, query, header, formData, body)
  let scheme = call_594087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594087.url(scheme.get, call_594087.host, call_594087.base,
                         call_594087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594087, url, valid)

proc call*(call_594088: Call_IntegrationAccountCertificatesGet_594079;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          certificateName: string): Recallable =
  ## integrationAccountCertificatesGet
  ## Gets an integration account certificate.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   certificateName: string (required)
  ##                  : The integration account certificate name.
  var path_594089 = newJObject()
  var query_594090 = newJObject()
  add(path_594089, "resourceGroupName", newJString(resourceGroupName))
  add(query_594090, "api-version", newJString(apiVersion))
  add(path_594089, "integrationAccountName", newJString(integrationAccountName))
  add(path_594089, "subscriptionId", newJString(subscriptionId))
  add(path_594089, "certificateName", newJString(certificateName))
  result = call_594088.call(path_594089, query_594090, nil, nil, nil)

var integrationAccountCertificatesGet* = Call_IntegrationAccountCertificatesGet_594079(
    name: "integrationAccountCertificatesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates/{certificateName}",
    validator: validate_IntegrationAccountCertificatesGet_594080, base: "",
    url: url_IntegrationAccountCertificatesGet_594081, schemes: {Scheme.Https})
type
  Call_IntegrationAccountCertificatesDelete_594105 = ref object of OpenApiRestCall_593421
proc url_IntegrationAccountCertificatesDelete_594107(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "certificateName" in path, "`certificateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountCertificatesDelete_594106(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an integration account certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   certificateName: JString (required)
  ##                  : The integration account certificate name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594108 = path.getOrDefault("resourceGroupName")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "resourceGroupName", valid_594108
  var valid_594109 = path.getOrDefault("integrationAccountName")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "integrationAccountName", valid_594109
  var valid_594110 = path.getOrDefault("subscriptionId")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "subscriptionId", valid_594110
  var valid_594111 = path.getOrDefault("certificateName")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "certificateName", valid_594111
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594112 = query.getOrDefault("api-version")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "api-version", valid_594112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594113: Call_IntegrationAccountCertificatesDelete_594105;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an integration account certificate.
  ## 
  let valid = call_594113.validator(path, query, header, formData, body)
  let scheme = call_594113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594113.url(scheme.get, call_594113.host, call_594113.base,
                         call_594113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594113, url, valid)

proc call*(call_594114: Call_IntegrationAccountCertificatesDelete_594105;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          certificateName: string): Recallable =
  ## integrationAccountCertificatesDelete
  ## Deletes an integration account certificate.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   certificateName: string (required)
  ##                  : The integration account certificate name.
  var path_594115 = newJObject()
  var query_594116 = newJObject()
  add(path_594115, "resourceGroupName", newJString(resourceGroupName))
  add(query_594116, "api-version", newJString(apiVersion))
  add(path_594115, "integrationAccountName", newJString(integrationAccountName))
  add(path_594115, "subscriptionId", newJString(subscriptionId))
  add(path_594115, "certificateName", newJString(certificateName))
  result = call_594114.call(path_594115, query_594116, nil, nil, nil)

var integrationAccountCertificatesDelete* = Call_IntegrationAccountCertificatesDelete_594105(
    name: "integrationAccountCertificatesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates/{certificateName}",
    validator: validate_IntegrationAccountCertificatesDelete_594106, base: "",
    url: url_IntegrationAccountCertificatesDelete_594107, schemes: {Scheme.Https})
type
  Call_IntegrationAccountsListCallbackUrl_594117 = ref object of OpenApiRestCall_593421
proc url_IntegrationAccountsListCallbackUrl_594119(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/listCallbackUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountsListCallbackUrl_594118(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the integration account callback URL.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594120 = path.getOrDefault("resourceGroupName")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "resourceGroupName", valid_594120
  var valid_594121 = path.getOrDefault("integrationAccountName")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "integrationAccountName", valid_594121
  var valid_594122 = path.getOrDefault("subscriptionId")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "subscriptionId", valid_594122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594123 = query.getOrDefault("api-version")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "api-version", valid_594123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The callback URL parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594125: Call_IntegrationAccountsListCallbackUrl_594117;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the integration account callback URL.
  ## 
  let valid = call_594125.validator(path, query, header, formData, body)
  let scheme = call_594125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594125.url(scheme.get, call_594125.host, call_594125.base,
                         call_594125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594125, url, valid)

proc call*(call_594126: Call_IntegrationAccountsListCallbackUrl_594117;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## integrationAccountsListCallbackUrl
  ## Lists the integration account callback URL.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   parameters: JObject (required)
  ##             : The callback URL parameters.
  var path_594127 = newJObject()
  var query_594128 = newJObject()
  var body_594129 = newJObject()
  add(path_594127, "resourceGroupName", newJString(resourceGroupName))
  add(query_594128, "api-version", newJString(apiVersion))
  add(path_594127, "integrationAccountName", newJString(integrationAccountName))
  add(path_594127, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594129 = parameters
  result = call_594126.call(path_594127, query_594128, nil, nil, body_594129)

var integrationAccountsListCallbackUrl* = Call_IntegrationAccountsListCallbackUrl_594117(
    name: "integrationAccountsListCallbackUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/listCallbackUrl",
    validator: validate_IntegrationAccountsListCallbackUrl_594118, base: "",
    url: url_IntegrationAccountsListCallbackUrl_594119, schemes: {Scheme.Https})
type
  Call_IntegrationAccountMapsList_594130 = ref object of OpenApiRestCall_593421
proc url_IntegrationAccountMapsList_594132(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/maps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountMapsList_594131(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of integration account maps.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594133 = path.getOrDefault("resourceGroupName")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "resourceGroupName", valid_594133
  var valid_594134 = path.getOrDefault("integrationAccountName")
  valid_594134 = validateParameter(valid_594134, JString, required = true,
                                 default = nil)
  if valid_594134 != nil:
    section.add "integrationAccountName", valid_594134
  var valid_594135 = path.getOrDefault("subscriptionId")
  valid_594135 = validateParameter(valid_594135, JString, required = true,
                                 default = nil)
  if valid_594135 != nil:
    section.add "subscriptionId", valid_594135
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594136 = query.getOrDefault("api-version")
  valid_594136 = validateParameter(valid_594136, JString, required = true,
                                 default = nil)
  if valid_594136 != nil:
    section.add "api-version", valid_594136
  var valid_594137 = query.getOrDefault("$top")
  valid_594137 = validateParameter(valid_594137, JInt, required = false, default = nil)
  if valid_594137 != nil:
    section.add "$top", valid_594137
  var valid_594138 = query.getOrDefault("$filter")
  valid_594138 = validateParameter(valid_594138, JString, required = false,
                                 default = nil)
  if valid_594138 != nil:
    section.add "$filter", valid_594138
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594139: Call_IntegrationAccountMapsList_594130; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of integration account maps.
  ## 
  let valid = call_594139.validator(path, query, header, formData, body)
  let scheme = call_594139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594139.url(scheme.get, call_594139.host, call_594139.base,
                         call_594139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594139, url, valid)

proc call*(call_594140: Call_IntegrationAccountMapsList_594130;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string; Top: int = 0;
          Filter: string = ""): Recallable =
  ## integrationAccountMapsList
  ## Gets a list of integration account maps.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_594141 = newJObject()
  var query_594142 = newJObject()
  add(path_594141, "resourceGroupName", newJString(resourceGroupName))
  add(query_594142, "api-version", newJString(apiVersion))
  add(path_594141, "integrationAccountName", newJString(integrationAccountName))
  add(path_594141, "subscriptionId", newJString(subscriptionId))
  add(query_594142, "$top", newJInt(Top))
  add(query_594142, "$filter", newJString(Filter))
  result = call_594140.call(path_594141, query_594142, nil, nil, nil)

var integrationAccountMapsList* = Call_IntegrationAccountMapsList_594130(
    name: "integrationAccountMapsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps",
    validator: validate_IntegrationAccountMapsList_594131, base: "",
    url: url_IntegrationAccountMapsList_594132, schemes: {Scheme.Https})
type
  Call_IntegrationAccountMapsCreateOrUpdate_594155 = ref object of OpenApiRestCall_593421
proc url_IntegrationAccountMapsCreateOrUpdate_594157(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "mapName" in path, "`mapName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/maps/"),
               (kind: VariableSegment, value: "mapName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountMapsCreateOrUpdate_594156(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an integration account map.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   mapName: JString (required)
  ##          : The integration account map name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594158 = path.getOrDefault("resourceGroupName")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "resourceGroupName", valid_594158
  var valid_594159 = path.getOrDefault("mapName")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "mapName", valid_594159
  var valid_594160 = path.getOrDefault("integrationAccountName")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "integrationAccountName", valid_594160
  var valid_594161 = path.getOrDefault("subscriptionId")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "subscriptionId", valid_594161
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594162 = query.getOrDefault("api-version")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = nil)
  if valid_594162 != nil:
    section.add "api-version", valid_594162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   map: JObject (required)
  ##      : The integration account map.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594164: Call_IntegrationAccountMapsCreateOrUpdate_594155;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account map.
  ## 
  let valid = call_594164.validator(path, query, header, formData, body)
  let scheme = call_594164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594164.url(scheme.get, call_594164.host, call_594164.base,
                         call_594164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594164, url, valid)

proc call*(call_594165: Call_IntegrationAccountMapsCreateOrUpdate_594155;
          resourceGroupName: string; map: JsonNode; mapName: string;
          apiVersion: string; integrationAccountName: string; subscriptionId: string): Recallable =
  ## integrationAccountMapsCreateOrUpdate
  ## Creates or updates an integration account map.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   map: JObject (required)
  ##      : The integration account map.
  ##   mapName: string (required)
  ##          : The integration account map name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_594166 = newJObject()
  var query_594167 = newJObject()
  var body_594168 = newJObject()
  add(path_594166, "resourceGroupName", newJString(resourceGroupName))
  if map != nil:
    body_594168 = map
  add(path_594166, "mapName", newJString(mapName))
  add(query_594167, "api-version", newJString(apiVersion))
  add(path_594166, "integrationAccountName", newJString(integrationAccountName))
  add(path_594166, "subscriptionId", newJString(subscriptionId))
  result = call_594165.call(path_594166, query_594167, nil, nil, body_594168)

var integrationAccountMapsCreateOrUpdate* = Call_IntegrationAccountMapsCreateOrUpdate_594155(
    name: "integrationAccountMapsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}",
    validator: validate_IntegrationAccountMapsCreateOrUpdate_594156, base: "",
    url: url_IntegrationAccountMapsCreateOrUpdate_594157, schemes: {Scheme.Https})
type
  Call_IntegrationAccountMapsGet_594143 = ref object of OpenApiRestCall_593421
proc url_IntegrationAccountMapsGet_594145(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "mapName" in path, "`mapName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/maps/"),
               (kind: VariableSegment, value: "mapName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountMapsGet_594144(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an integration account map.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   mapName: JString (required)
  ##          : The integration account map name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594146 = path.getOrDefault("resourceGroupName")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "resourceGroupName", valid_594146
  var valid_594147 = path.getOrDefault("mapName")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "mapName", valid_594147
  var valid_594148 = path.getOrDefault("integrationAccountName")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "integrationAccountName", valid_594148
  var valid_594149 = path.getOrDefault("subscriptionId")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "subscriptionId", valid_594149
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594150 = query.getOrDefault("api-version")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "api-version", valid_594150
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594151: Call_IntegrationAccountMapsGet_594143; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account map.
  ## 
  let valid = call_594151.validator(path, query, header, formData, body)
  let scheme = call_594151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594151.url(scheme.get, call_594151.host, call_594151.base,
                         call_594151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594151, url, valid)

proc call*(call_594152: Call_IntegrationAccountMapsGet_594143;
          resourceGroupName: string; mapName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string): Recallable =
  ## integrationAccountMapsGet
  ## Gets an integration account map.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   mapName: string (required)
  ##          : The integration account map name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_594153 = newJObject()
  var query_594154 = newJObject()
  add(path_594153, "resourceGroupName", newJString(resourceGroupName))
  add(path_594153, "mapName", newJString(mapName))
  add(query_594154, "api-version", newJString(apiVersion))
  add(path_594153, "integrationAccountName", newJString(integrationAccountName))
  add(path_594153, "subscriptionId", newJString(subscriptionId))
  result = call_594152.call(path_594153, query_594154, nil, nil, nil)

var integrationAccountMapsGet* = Call_IntegrationAccountMapsGet_594143(
    name: "integrationAccountMapsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}",
    validator: validate_IntegrationAccountMapsGet_594144, base: "",
    url: url_IntegrationAccountMapsGet_594145, schemes: {Scheme.Https})
type
  Call_IntegrationAccountMapsDelete_594169 = ref object of OpenApiRestCall_593421
proc url_IntegrationAccountMapsDelete_594171(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "mapName" in path, "`mapName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/maps/"),
               (kind: VariableSegment, value: "mapName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountMapsDelete_594170(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an integration account map.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   mapName: JString (required)
  ##          : The integration account map name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594172 = path.getOrDefault("resourceGroupName")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = nil)
  if valid_594172 != nil:
    section.add "resourceGroupName", valid_594172
  var valid_594173 = path.getOrDefault("mapName")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "mapName", valid_594173
  var valid_594174 = path.getOrDefault("integrationAccountName")
  valid_594174 = validateParameter(valid_594174, JString, required = true,
                                 default = nil)
  if valid_594174 != nil:
    section.add "integrationAccountName", valid_594174
  var valid_594175 = path.getOrDefault("subscriptionId")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "subscriptionId", valid_594175
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594176 = query.getOrDefault("api-version")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "api-version", valid_594176
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594177: Call_IntegrationAccountMapsDelete_594169; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration account map.
  ## 
  let valid = call_594177.validator(path, query, header, formData, body)
  let scheme = call_594177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594177.url(scheme.get, call_594177.host, call_594177.base,
                         call_594177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594177, url, valid)

proc call*(call_594178: Call_IntegrationAccountMapsDelete_594169;
          resourceGroupName: string; mapName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string): Recallable =
  ## integrationAccountMapsDelete
  ## Deletes an integration account map.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   mapName: string (required)
  ##          : The integration account map name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  var path_594179 = newJObject()
  var query_594180 = newJObject()
  add(path_594179, "resourceGroupName", newJString(resourceGroupName))
  add(path_594179, "mapName", newJString(mapName))
  add(query_594180, "api-version", newJString(apiVersion))
  add(path_594179, "integrationAccountName", newJString(integrationAccountName))
  add(path_594179, "subscriptionId", newJString(subscriptionId))
  result = call_594178.call(path_594179, query_594180, nil, nil, nil)

var integrationAccountMapsDelete* = Call_IntegrationAccountMapsDelete_594169(
    name: "integrationAccountMapsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}",
    validator: validate_IntegrationAccountMapsDelete_594170, base: "",
    url: url_IntegrationAccountMapsDelete_594171, schemes: {Scheme.Https})
type
  Call_IntegrationAccountPartnersList_594181 = ref object of OpenApiRestCall_593421
proc url_IntegrationAccountPartnersList_594183(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/partners")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountPartnersList_594182(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of integration account partners.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594184 = path.getOrDefault("resourceGroupName")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "resourceGroupName", valid_594184
  var valid_594185 = path.getOrDefault("integrationAccountName")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = nil)
  if valid_594185 != nil:
    section.add "integrationAccountName", valid_594185
  var valid_594186 = path.getOrDefault("subscriptionId")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "subscriptionId", valid_594186
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594187 = query.getOrDefault("api-version")
  valid_594187 = validateParameter(valid_594187, JString, required = true,
                                 default = nil)
  if valid_594187 != nil:
    section.add "api-version", valid_594187
  var valid_594188 = query.getOrDefault("$top")
  valid_594188 = validateParameter(valid_594188, JInt, required = false, default = nil)
  if valid_594188 != nil:
    section.add "$top", valid_594188
  var valid_594189 = query.getOrDefault("$filter")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = nil)
  if valid_594189 != nil:
    section.add "$filter", valid_594189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594190: Call_IntegrationAccountPartnersList_594181; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of integration account partners.
  ## 
  let valid = call_594190.validator(path, query, header, formData, body)
  let scheme = call_594190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594190.url(scheme.get, call_594190.host, call_594190.base,
                         call_594190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594190, url, valid)

proc call*(call_594191: Call_IntegrationAccountPartnersList_594181;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string; Top: int = 0;
          Filter: string = ""): Recallable =
  ## integrationAccountPartnersList
  ## Gets a list of integration account partners.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_594192 = newJObject()
  var query_594193 = newJObject()
  add(path_594192, "resourceGroupName", newJString(resourceGroupName))
  add(query_594193, "api-version", newJString(apiVersion))
  add(path_594192, "integrationAccountName", newJString(integrationAccountName))
  add(path_594192, "subscriptionId", newJString(subscriptionId))
  add(query_594193, "$top", newJInt(Top))
  add(query_594193, "$filter", newJString(Filter))
  result = call_594191.call(path_594192, query_594193, nil, nil, nil)

var integrationAccountPartnersList* = Call_IntegrationAccountPartnersList_594181(
    name: "integrationAccountPartnersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners",
    validator: validate_IntegrationAccountPartnersList_594182, base: "",
    url: url_IntegrationAccountPartnersList_594183, schemes: {Scheme.Https})
type
  Call_IntegrationAccountPartnersCreateOrUpdate_594206 = ref object of OpenApiRestCall_593421
proc url_IntegrationAccountPartnersCreateOrUpdate_594208(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "partnerName" in path, "`partnerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/partners/"),
               (kind: VariableSegment, value: "partnerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountPartnersCreateOrUpdate_594207(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an integration account partner.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   partnerName: JString (required)
  ##              : The integration account partner name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594209 = path.getOrDefault("resourceGroupName")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = nil)
  if valid_594209 != nil:
    section.add "resourceGroupName", valid_594209
  var valid_594210 = path.getOrDefault("integrationAccountName")
  valid_594210 = validateParameter(valid_594210, JString, required = true,
                                 default = nil)
  if valid_594210 != nil:
    section.add "integrationAccountName", valid_594210
  var valid_594211 = path.getOrDefault("subscriptionId")
  valid_594211 = validateParameter(valid_594211, JString, required = true,
                                 default = nil)
  if valid_594211 != nil:
    section.add "subscriptionId", valid_594211
  var valid_594212 = path.getOrDefault("partnerName")
  valid_594212 = validateParameter(valid_594212, JString, required = true,
                                 default = nil)
  if valid_594212 != nil:
    section.add "partnerName", valid_594212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594213 = query.getOrDefault("api-version")
  valid_594213 = validateParameter(valid_594213, JString, required = true,
                                 default = nil)
  if valid_594213 != nil:
    section.add "api-version", valid_594213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   partner: JObject (required)
  ##          : The integration account partner.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594215: Call_IntegrationAccountPartnersCreateOrUpdate_594206;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account partner.
  ## 
  let valid = call_594215.validator(path, query, header, formData, body)
  let scheme = call_594215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594215.url(scheme.get, call_594215.host, call_594215.base,
                         call_594215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594215, url, valid)

proc call*(call_594216: Call_IntegrationAccountPartnersCreateOrUpdate_594206;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string; partner: JsonNode;
          partnerName: string): Recallable =
  ## integrationAccountPartnersCreateOrUpdate
  ## Creates or updates an integration account partner.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   partner: JObject (required)
  ##          : The integration account partner.
  ##   partnerName: string (required)
  ##              : The integration account partner name.
  var path_594217 = newJObject()
  var query_594218 = newJObject()
  var body_594219 = newJObject()
  add(path_594217, "resourceGroupName", newJString(resourceGroupName))
  add(query_594218, "api-version", newJString(apiVersion))
  add(path_594217, "integrationAccountName", newJString(integrationAccountName))
  add(path_594217, "subscriptionId", newJString(subscriptionId))
  if partner != nil:
    body_594219 = partner
  add(path_594217, "partnerName", newJString(partnerName))
  result = call_594216.call(path_594217, query_594218, nil, nil, body_594219)

var integrationAccountPartnersCreateOrUpdate* = Call_IntegrationAccountPartnersCreateOrUpdate_594206(
    name: "integrationAccountPartnersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}",
    validator: validate_IntegrationAccountPartnersCreateOrUpdate_594207, base: "",
    url: url_IntegrationAccountPartnersCreateOrUpdate_594208,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountPartnersGet_594194 = ref object of OpenApiRestCall_593421
proc url_IntegrationAccountPartnersGet_594196(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "partnerName" in path, "`partnerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/partners/"),
               (kind: VariableSegment, value: "partnerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountPartnersGet_594195(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an integration account partner.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   partnerName: JString (required)
  ##              : The integration account partner name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594197 = path.getOrDefault("resourceGroupName")
  valid_594197 = validateParameter(valid_594197, JString, required = true,
                                 default = nil)
  if valid_594197 != nil:
    section.add "resourceGroupName", valid_594197
  var valid_594198 = path.getOrDefault("integrationAccountName")
  valid_594198 = validateParameter(valid_594198, JString, required = true,
                                 default = nil)
  if valid_594198 != nil:
    section.add "integrationAccountName", valid_594198
  var valid_594199 = path.getOrDefault("subscriptionId")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "subscriptionId", valid_594199
  var valid_594200 = path.getOrDefault("partnerName")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "partnerName", valid_594200
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594201 = query.getOrDefault("api-version")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "api-version", valid_594201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594202: Call_IntegrationAccountPartnersGet_594194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account partner.
  ## 
  let valid = call_594202.validator(path, query, header, formData, body)
  let scheme = call_594202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594202.url(scheme.get, call_594202.host, call_594202.base,
                         call_594202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594202, url, valid)

proc call*(call_594203: Call_IntegrationAccountPartnersGet_594194;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          partnerName: string): Recallable =
  ## integrationAccountPartnersGet
  ## Gets an integration account partner.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   partnerName: string (required)
  ##              : The integration account partner name.
  var path_594204 = newJObject()
  var query_594205 = newJObject()
  add(path_594204, "resourceGroupName", newJString(resourceGroupName))
  add(query_594205, "api-version", newJString(apiVersion))
  add(path_594204, "integrationAccountName", newJString(integrationAccountName))
  add(path_594204, "subscriptionId", newJString(subscriptionId))
  add(path_594204, "partnerName", newJString(partnerName))
  result = call_594203.call(path_594204, query_594205, nil, nil, nil)

var integrationAccountPartnersGet* = Call_IntegrationAccountPartnersGet_594194(
    name: "integrationAccountPartnersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}",
    validator: validate_IntegrationAccountPartnersGet_594195, base: "",
    url: url_IntegrationAccountPartnersGet_594196, schemes: {Scheme.Https})
type
  Call_IntegrationAccountPartnersDelete_594220 = ref object of OpenApiRestCall_593421
proc url_IntegrationAccountPartnersDelete_594222(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "partnerName" in path, "`partnerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/partners/"),
               (kind: VariableSegment, value: "partnerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountPartnersDelete_594221(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an integration account partner.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   partnerName: JString (required)
  ##              : The integration account partner name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594223 = path.getOrDefault("resourceGroupName")
  valid_594223 = validateParameter(valid_594223, JString, required = true,
                                 default = nil)
  if valid_594223 != nil:
    section.add "resourceGroupName", valid_594223
  var valid_594224 = path.getOrDefault("integrationAccountName")
  valid_594224 = validateParameter(valid_594224, JString, required = true,
                                 default = nil)
  if valid_594224 != nil:
    section.add "integrationAccountName", valid_594224
  var valid_594225 = path.getOrDefault("subscriptionId")
  valid_594225 = validateParameter(valid_594225, JString, required = true,
                                 default = nil)
  if valid_594225 != nil:
    section.add "subscriptionId", valid_594225
  var valid_594226 = path.getOrDefault("partnerName")
  valid_594226 = validateParameter(valid_594226, JString, required = true,
                                 default = nil)
  if valid_594226 != nil:
    section.add "partnerName", valid_594226
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594227 = query.getOrDefault("api-version")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "api-version", valid_594227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594228: Call_IntegrationAccountPartnersDelete_594220;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an integration account partner.
  ## 
  let valid = call_594228.validator(path, query, header, formData, body)
  let scheme = call_594228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594228.url(scheme.get, call_594228.host, call_594228.base,
                         call_594228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594228, url, valid)

proc call*(call_594229: Call_IntegrationAccountPartnersDelete_594220;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          partnerName: string): Recallable =
  ## integrationAccountPartnersDelete
  ## Deletes an integration account partner.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   partnerName: string (required)
  ##              : The integration account partner name.
  var path_594230 = newJObject()
  var query_594231 = newJObject()
  add(path_594230, "resourceGroupName", newJString(resourceGroupName))
  add(query_594231, "api-version", newJString(apiVersion))
  add(path_594230, "integrationAccountName", newJString(integrationAccountName))
  add(path_594230, "subscriptionId", newJString(subscriptionId))
  add(path_594230, "partnerName", newJString(partnerName))
  result = call_594229.call(path_594230, query_594231, nil, nil, nil)

var integrationAccountPartnersDelete* = Call_IntegrationAccountPartnersDelete_594220(
    name: "integrationAccountPartnersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}",
    validator: validate_IntegrationAccountPartnersDelete_594221, base: "",
    url: url_IntegrationAccountPartnersDelete_594222, schemes: {Scheme.Https})
type
  Call_IntegrationAccountSchemasList_594232 = ref object of OpenApiRestCall_593421
proc url_IntegrationAccountSchemasList_594234(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/schemas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountSchemasList_594233(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of integration account schemas.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594235 = path.getOrDefault("resourceGroupName")
  valid_594235 = validateParameter(valid_594235, JString, required = true,
                                 default = nil)
  if valid_594235 != nil:
    section.add "resourceGroupName", valid_594235
  var valid_594236 = path.getOrDefault("integrationAccountName")
  valid_594236 = validateParameter(valid_594236, JString, required = true,
                                 default = nil)
  if valid_594236 != nil:
    section.add "integrationAccountName", valid_594236
  var valid_594237 = path.getOrDefault("subscriptionId")
  valid_594237 = validateParameter(valid_594237, JString, required = true,
                                 default = nil)
  if valid_594237 != nil:
    section.add "subscriptionId", valid_594237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   $top: JInt
  ##       : The number of items to be included in the result.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594238 = query.getOrDefault("api-version")
  valid_594238 = validateParameter(valid_594238, JString, required = true,
                                 default = nil)
  if valid_594238 != nil:
    section.add "api-version", valid_594238
  var valid_594239 = query.getOrDefault("$top")
  valid_594239 = validateParameter(valid_594239, JInt, required = false, default = nil)
  if valid_594239 != nil:
    section.add "$top", valid_594239
  var valid_594240 = query.getOrDefault("$filter")
  valid_594240 = validateParameter(valid_594240, JString, required = false,
                                 default = nil)
  if valid_594240 != nil:
    section.add "$filter", valid_594240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594241: Call_IntegrationAccountSchemasList_594232; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of integration account schemas.
  ## 
  let valid = call_594241.validator(path, query, header, formData, body)
  let scheme = call_594241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594241.url(scheme.get, call_594241.host, call_594241.base,
                         call_594241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594241, url, valid)

proc call*(call_594242: Call_IntegrationAccountSchemasList_594232;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string; Top: int = 0;
          Filter: string = ""): Recallable =
  ## integrationAccountSchemasList
  ## Gets a list of integration account schemas.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   Top: int
  ##      : The number of items to be included in the result.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_594243 = newJObject()
  var query_594244 = newJObject()
  add(path_594243, "resourceGroupName", newJString(resourceGroupName))
  add(query_594244, "api-version", newJString(apiVersion))
  add(path_594243, "integrationAccountName", newJString(integrationAccountName))
  add(path_594243, "subscriptionId", newJString(subscriptionId))
  add(query_594244, "$top", newJInt(Top))
  add(query_594244, "$filter", newJString(Filter))
  result = call_594242.call(path_594243, query_594244, nil, nil, nil)

var integrationAccountSchemasList* = Call_IntegrationAccountSchemasList_594232(
    name: "integrationAccountSchemasList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas",
    validator: validate_IntegrationAccountSchemasList_594233, base: "",
    url: url_IntegrationAccountSchemasList_594234, schemes: {Scheme.Https})
type
  Call_IntegrationAccountSchemasCreateOrUpdate_594257 = ref object of OpenApiRestCall_593421
proc url_IntegrationAccountSchemasCreateOrUpdate_594259(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountSchemasCreateOrUpdate_594258(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an integration account schema.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   schemaName: JString (required)
  ##             : The integration account schema name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594260 = path.getOrDefault("resourceGroupName")
  valid_594260 = validateParameter(valid_594260, JString, required = true,
                                 default = nil)
  if valid_594260 != nil:
    section.add "resourceGroupName", valid_594260
  var valid_594261 = path.getOrDefault("integrationAccountName")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = nil)
  if valid_594261 != nil:
    section.add "integrationAccountName", valid_594261
  var valid_594262 = path.getOrDefault("subscriptionId")
  valid_594262 = validateParameter(valid_594262, JString, required = true,
                                 default = nil)
  if valid_594262 != nil:
    section.add "subscriptionId", valid_594262
  var valid_594263 = path.getOrDefault("schemaName")
  valid_594263 = validateParameter(valid_594263, JString, required = true,
                                 default = nil)
  if valid_594263 != nil:
    section.add "schemaName", valid_594263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594264 = query.getOrDefault("api-version")
  valid_594264 = validateParameter(valid_594264, JString, required = true,
                                 default = nil)
  if valid_594264 != nil:
    section.add "api-version", valid_594264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   schema: JObject (required)
  ##         : The integration account schema.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594266: Call_IntegrationAccountSchemasCreateOrUpdate_594257;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration account schema.
  ## 
  let valid = call_594266.validator(path, query, header, formData, body)
  let scheme = call_594266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594266.url(scheme.get, call_594266.host, call_594266.base,
                         call_594266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594266, url, valid)

proc call*(call_594267: Call_IntegrationAccountSchemasCreateOrUpdate_594257;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string;
          schemaName: string; schema: JsonNode): Recallable =
  ## integrationAccountSchemasCreateOrUpdate
  ## Creates or updates an integration account schema.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   schemaName: string (required)
  ##             : The integration account schema name.
  ##   schema: JObject (required)
  ##         : The integration account schema.
  var path_594268 = newJObject()
  var query_594269 = newJObject()
  var body_594270 = newJObject()
  add(path_594268, "resourceGroupName", newJString(resourceGroupName))
  add(query_594269, "api-version", newJString(apiVersion))
  add(path_594268, "integrationAccountName", newJString(integrationAccountName))
  add(path_594268, "subscriptionId", newJString(subscriptionId))
  add(path_594268, "schemaName", newJString(schemaName))
  if schema != nil:
    body_594270 = schema
  result = call_594267.call(path_594268, query_594269, nil, nil, body_594270)

var integrationAccountSchemasCreateOrUpdate* = Call_IntegrationAccountSchemasCreateOrUpdate_594257(
    name: "integrationAccountSchemasCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}",
    validator: validate_IntegrationAccountSchemasCreateOrUpdate_594258, base: "",
    url: url_IntegrationAccountSchemasCreateOrUpdate_594259,
    schemes: {Scheme.Https})
type
  Call_IntegrationAccountSchemasGet_594245 = ref object of OpenApiRestCall_593421
proc url_IntegrationAccountSchemasGet_594247(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountSchemasGet_594246(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an integration account schema.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   schemaName: JString (required)
  ##             : The integration account schema name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594248 = path.getOrDefault("resourceGroupName")
  valid_594248 = validateParameter(valid_594248, JString, required = true,
                                 default = nil)
  if valid_594248 != nil:
    section.add "resourceGroupName", valid_594248
  var valid_594249 = path.getOrDefault("integrationAccountName")
  valid_594249 = validateParameter(valid_594249, JString, required = true,
                                 default = nil)
  if valid_594249 != nil:
    section.add "integrationAccountName", valid_594249
  var valid_594250 = path.getOrDefault("subscriptionId")
  valid_594250 = validateParameter(valid_594250, JString, required = true,
                                 default = nil)
  if valid_594250 != nil:
    section.add "subscriptionId", valid_594250
  var valid_594251 = path.getOrDefault("schemaName")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = nil)
  if valid_594251 != nil:
    section.add "schemaName", valid_594251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594252 = query.getOrDefault("api-version")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = nil)
  if valid_594252 != nil:
    section.add "api-version", valid_594252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594253: Call_IntegrationAccountSchemasGet_594245; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration account schema.
  ## 
  let valid = call_594253.validator(path, query, header, formData, body)
  let scheme = call_594253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594253.url(scheme.get, call_594253.host, call_594253.base,
                         call_594253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594253, url, valid)

proc call*(call_594254: Call_IntegrationAccountSchemasGet_594245;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string; schemaName: string): Recallable =
  ## integrationAccountSchemasGet
  ## Gets an integration account schema.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   schemaName: string (required)
  ##             : The integration account schema name.
  var path_594255 = newJObject()
  var query_594256 = newJObject()
  add(path_594255, "resourceGroupName", newJString(resourceGroupName))
  add(query_594256, "api-version", newJString(apiVersion))
  add(path_594255, "integrationAccountName", newJString(integrationAccountName))
  add(path_594255, "subscriptionId", newJString(subscriptionId))
  add(path_594255, "schemaName", newJString(schemaName))
  result = call_594254.call(path_594255, query_594256, nil, nil, nil)

var integrationAccountSchemasGet* = Call_IntegrationAccountSchemasGet_594245(
    name: "integrationAccountSchemasGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}",
    validator: validate_IntegrationAccountSchemasGet_594246, base: "",
    url: url_IntegrationAccountSchemasGet_594247, schemes: {Scheme.Https})
type
  Call_IntegrationAccountSchemasDelete_594271 = ref object of OpenApiRestCall_593421
proc url_IntegrationAccountSchemasDelete_594273(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "integrationAccountName" in path,
        "`integrationAccountName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Logic/integrationAccounts/"),
               (kind: VariableSegment, value: "integrationAccountName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationAccountSchemasDelete_594272(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an integration account schema.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   integrationAccountName: JString (required)
  ##                         : The integration account name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id.
  ##   schemaName: JString (required)
  ##             : The integration account schema name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594274 = path.getOrDefault("resourceGroupName")
  valid_594274 = validateParameter(valid_594274, JString, required = true,
                                 default = nil)
  if valid_594274 != nil:
    section.add "resourceGroupName", valid_594274
  var valid_594275 = path.getOrDefault("integrationAccountName")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "integrationAccountName", valid_594275
  var valid_594276 = path.getOrDefault("subscriptionId")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "subscriptionId", valid_594276
  var valid_594277 = path.getOrDefault("schemaName")
  valid_594277 = validateParameter(valid_594277, JString, required = true,
                                 default = nil)
  if valid_594277 != nil:
    section.add "schemaName", valid_594277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594278 = query.getOrDefault("api-version")
  valid_594278 = validateParameter(valid_594278, JString, required = true,
                                 default = nil)
  if valid_594278 != nil:
    section.add "api-version", valid_594278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594279: Call_IntegrationAccountSchemasDelete_594271;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an integration account schema.
  ## 
  let valid = call_594279.validator(path, query, header, formData, body)
  let scheme = call_594279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594279.url(scheme.get, call_594279.host, call_594279.base,
                         call_594279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594279, url, valid)

proc call*(call_594280: Call_IntegrationAccountSchemasDelete_594271;
          resourceGroupName: string; apiVersion: string;
          integrationAccountName: string; subscriptionId: string; schemaName: string): Recallable =
  ## integrationAccountSchemasDelete
  ## Deletes an integration account schema.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationAccountName: string (required)
  ##                         : The integration account name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id.
  ##   schemaName: string (required)
  ##             : The integration account schema name.
  var path_594281 = newJObject()
  var query_594282 = newJObject()
  add(path_594281, "resourceGroupName", newJString(resourceGroupName))
  add(query_594282, "api-version", newJString(apiVersion))
  add(path_594281, "integrationAccountName", newJString(integrationAccountName))
  add(path_594281, "subscriptionId", newJString(subscriptionId))
  add(path_594281, "schemaName", newJString(schemaName))
  result = call_594280.call(path_594281, query_594282, nil, nil, nil)

var integrationAccountSchemasDelete* = Call_IntegrationAccountSchemasDelete_594271(
    name: "integrationAccountSchemasDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}",
    validator: validate_IntegrationAccountSchemasDelete_594272, base: "",
    url: url_IntegrationAccountSchemasDelete_594273, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
