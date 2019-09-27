
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Mixed Reality
## version: 2019-12-02-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Mixed Reality Resource Provider Remote Rendering Resource API
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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  macServiceName = "mixedreality-remote-rendering"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RemoteRenderingAccountsListBySubscription_593646 = ref object of OpenApiRestCall_593424
proc url_RemoteRenderingAccountsListBySubscription_593648(protocol: Scheme;
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
        value: "/providers/Microsoft.MixedReality/remoteRenderingAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemoteRenderingAccountsListBySubscription_593647(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List Remote Rendering Accounts by Subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593808 = path.getOrDefault("subscriptionId")
  valid_593808 = validateParameter(valid_593808, JString, required = true,
                                 default = nil)
  if valid_593808 != nil:
    section.add "subscriptionId", valid_593808
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593809 = query.getOrDefault("api-version")
  valid_593809 = validateParameter(valid_593809, JString, required = true,
                                 default = nil)
  if valid_593809 != nil:
    section.add "api-version", valid_593809
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593836: Call_RemoteRenderingAccountsListBySubscription_593646;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Remote Rendering Accounts by Subscription
  ## 
  let valid = call_593836.validator(path, query, header, formData, body)
  let scheme = call_593836.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593836.url(scheme.get, call_593836.host, call_593836.base,
                         call_593836.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593836, url, valid)

proc call*(call_593907: Call_RemoteRenderingAccountsListBySubscription_593646;
          apiVersion: string; subscriptionId: string): Recallable =
  ## remoteRenderingAccountsListBySubscription
  ## List Remote Rendering Accounts by Subscription
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  var path_593908 = newJObject()
  var query_593910 = newJObject()
  add(query_593910, "api-version", newJString(apiVersion))
  add(path_593908, "subscriptionId", newJString(subscriptionId))
  result = call_593907.call(path_593908, query_593910, nil, nil, nil)

var remoteRenderingAccountsListBySubscription* = Call_RemoteRenderingAccountsListBySubscription_593646(
    name: "remoteRenderingAccountsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MixedReality/remoteRenderingAccounts",
    validator: validate_RemoteRenderingAccountsListBySubscription_593647,
    base: "", url: url_RemoteRenderingAccountsListBySubscription_593648,
    schemes: {Scheme.Https})
type
  Call_RemoteRenderingAccountsListByResourceGroup_593949 = ref object of OpenApiRestCall_593424
proc url_RemoteRenderingAccountsListByResourceGroup_593951(protocol: Scheme;
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
        value: "/providers/Microsoft.MixedReality/remoteRenderingAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemoteRenderingAccountsListByResourceGroup_593950(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List Resources by Resource Group
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
  var valid_593952 = path.getOrDefault("resourceGroupName")
  valid_593952 = validateParameter(valid_593952, JString, required = true,
                                 default = nil)
  if valid_593952 != nil:
    section.add "resourceGroupName", valid_593952
  var valid_593953 = path.getOrDefault("subscriptionId")
  valid_593953 = validateParameter(valid_593953, JString, required = true,
                                 default = nil)
  if valid_593953 != nil:
    section.add "subscriptionId", valid_593953
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593954 = query.getOrDefault("api-version")
  valid_593954 = validateParameter(valid_593954, JString, required = true,
                                 default = nil)
  if valid_593954 != nil:
    section.add "api-version", valid_593954
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593955: Call_RemoteRenderingAccountsListByResourceGroup_593949;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Resources by Resource Group
  ## 
  let valid = call_593955.validator(path, query, header, formData, body)
  let scheme = call_593955.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593955.url(scheme.get, call_593955.host, call_593955.base,
                         call_593955.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593955, url, valid)

proc call*(call_593956: Call_RemoteRenderingAccountsListByResourceGroup_593949;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## remoteRenderingAccountsListByResourceGroup
  ## List Resources by Resource Group
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  var path_593957 = newJObject()
  var query_593958 = newJObject()
  add(path_593957, "resourceGroupName", newJString(resourceGroupName))
  add(query_593958, "api-version", newJString(apiVersion))
  add(path_593957, "subscriptionId", newJString(subscriptionId))
  result = call_593956.call(path_593957, query_593958, nil, nil, nil)

var remoteRenderingAccountsListByResourceGroup* = Call_RemoteRenderingAccountsListByResourceGroup_593949(
    name: "remoteRenderingAccountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MixedReality/remoteRenderingAccounts",
    validator: validate_RemoteRenderingAccountsListByResourceGroup_593950,
    base: "", url: url_RemoteRenderingAccountsListByResourceGroup_593951,
    schemes: {Scheme.Https})
type
  Call_RemoteRenderingAccountsCreate_593970 = ref object of OpenApiRestCall_593424
proc url_RemoteRenderingAccountsCreate_593972(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.MixedReality/remoteRenderingAccounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemoteRenderingAccountsCreate_593971(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creating or Updating a Remote Rendering Account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Name of an Mixed Reality Account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593982 = path.getOrDefault("resourceGroupName")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "resourceGroupName", valid_593982
  var valid_593983 = path.getOrDefault("subscriptionId")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "subscriptionId", valid_593983
  var valid_593984 = path.getOrDefault("accountName")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "accountName", valid_593984
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
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
  ##   remoteRenderingAccount: JObject (required)
  ##                         : Remote Rendering Account parameter.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593987: Call_RemoteRenderingAccountsCreate_593970; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creating or Updating a Remote Rendering Account.
  ## 
  let valid = call_593987.validator(path, query, header, formData, body)
  let scheme = call_593987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593987.url(scheme.get, call_593987.host, call_593987.base,
                         call_593987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593987, url, valid)

proc call*(call_593988: Call_RemoteRenderingAccountsCreate_593970;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          remoteRenderingAccount: JsonNode; accountName: string): Recallable =
  ## remoteRenderingAccountsCreate
  ## Creating or Updating a Remote Rendering Account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   remoteRenderingAccount: JObject (required)
  ##                         : Remote Rendering Account parameter.
  ##   accountName: string (required)
  ##              : Name of an Mixed Reality Account.
  var path_593989 = newJObject()
  var query_593990 = newJObject()
  var body_593991 = newJObject()
  add(path_593989, "resourceGroupName", newJString(resourceGroupName))
  add(query_593990, "api-version", newJString(apiVersion))
  add(path_593989, "subscriptionId", newJString(subscriptionId))
  if remoteRenderingAccount != nil:
    body_593991 = remoteRenderingAccount
  add(path_593989, "accountName", newJString(accountName))
  result = call_593988.call(path_593989, query_593990, nil, nil, body_593991)

var remoteRenderingAccountsCreate* = Call_RemoteRenderingAccountsCreate_593970(
    name: "remoteRenderingAccountsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MixedReality/remoteRenderingAccounts/{accountName}",
    validator: validate_RemoteRenderingAccountsCreate_593971, base: "",
    url: url_RemoteRenderingAccountsCreate_593972, schemes: {Scheme.Https})
type
  Call_RemoteRenderingAccountsGet_593959 = ref object of OpenApiRestCall_593424
proc url_RemoteRenderingAccountsGet_593961(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.MixedReality/remoteRenderingAccounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemoteRenderingAccountsGet_593960(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a Remote Rendering Account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Name of an Mixed Reality Account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593962 = path.getOrDefault("resourceGroupName")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "resourceGroupName", valid_593962
  var valid_593963 = path.getOrDefault("subscriptionId")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "subscriptionId", valid_593963
  var valid_593964 = path.getOrDefault("accountName")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "accountName", valid_593964
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593965 = query.getOrDefault("api-version")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "api-version", valid_593965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593966: Call_RemoteRenderingAccountsGet_593959; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a Remote Rendering Account.
  ## 
  let valid = call_593966.validator(path, query, header, formData, body)
  let scheme = call_593966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593966.url(scheme.get, call_593966.host, call_593966.base,
                         call_593966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593966, url, valid)

proc call*(call_593967: Call_RemoteRenderingAccountsGet_593959;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## remoteRenderingAccountsGet
  ## Retrieve a Remote Rendering Account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Name of an Mixed Reality Account.
  var path_593968 = newJObject()
  var query_593969 = newJObject()
  add(path_593968, "resourceGroupName", newJString(resourceGroupName))
  add(query_593969, "api-version", newJString(apiVersion))
  add(path_593968, "subscriptionId", newJString(subscriptionId))
  add(path_593968, "accountName", newJString(accountName))
  result = call_593967.call(path_593968, query_593969, nil, nil, nil)

var remoteRenderingAccountsGet* = Call_RemoteRenderingAccountsGet_593959(
    name: "remoteRenderingAccountsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MixedReality/remoteRenderingAccounts/{accountName}",
    validator: validate_RemoteRenderingAccountsGet_593960, base: "",
    url: url_RemoteRenderingAccountsGet_593961, schemes: {Scheme.Https})
type
  Call_RemoteRenderingAccountsUpdate_594003 = ref object of OpenApiRestCall_593424
proc url_RemoteRenderingAccountsUpdate_594005(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.MixedReality/remoteRenderingAccounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemoteRenderingAccountsUpdate_594004(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updating a Remote Rendering Account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Name of an Mixed Reality Account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594006 = path.getOrDefault("resourceGroupName")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "resourceGroupName", valid_594006
  var valid_594007 = path.getOrDefault("subscriptionId")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "subscriptionId", valid_594007
  var valid_594008 = path.getOrDefault("accountName")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "accountName", valid_594008
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
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
  ##   remoteRenderingAccount: JObject (required)
  ##                         : Remote Rendering Account parameter.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594011: Call_RemoteRenderingAccountsUpdate_594003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updating a Remote Rendering Account
  ## 
  let valid = call_594011.validator(path, query, header, formData, body)
  let scheme = call_594011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594011.url(scheme.get, call_594011.host, call_594011.base,
                         call_594011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594011, url, valid)

proc call*(call_594012: Call_RemoteRenderingAccountsUpdate_594003;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          remoteRenderingAccount: JsonNode; accountName: string): Recallable =
  ## remoteRenderingAccountsUpdate
  ## Updating a Remote Rendering Account
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   remoteRenderingAccount: JObject (required)
  ##                         : Remote Rendering Account parameter.
  ##   accountName: string (required)
  ##              : Name of an Mixed Reality Account.
  var path_594013 = newJObject()
  var query_594014 = newJObject()
  var body_594015 = newJObject()
  add(path_594013, "resourceGroupName", newJString(resourceGroupName))
  add(query_594014, "api-version", newJString(apiVersion))
  add(path_594013, "subscriptionId", newJString(subscriptionId))
  if remoteRenderingAccount != nil:
    body_594015 = remoteRenderingAccount
  add(path_594013, "accountName", newJString(accountName))
  result = call_594012.call(path_594013, query_594014, nil, nil, body_594015)

var remoteRenderingAccountsUpdate* = Call_RemoteRenderingAccountsUpdate_594003(
    name: "remoteRenderingAccountsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MixedReality/remoteRenderingAccounts/{accountName}",
    validator: validate_RemoteRenderingAccountsUpdate_594004, base: "",
    url: url_RemoteRenderingAccountsUpdate_594005, schemes: {Scheme.Https})
type
  Call_RemoteRenderingAccountsDelete_593992 = ref object of OpenApiRestCall_593424
proc url_RemoteRenderingAccountsDelete_593994(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.MixedReality/remoteRenderingAccounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemoteRenderingAccountsDelete_593993(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a Remote Rendering Account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Name of an Mixed Reality Account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593995 = path.getOrDefault("resourceGroupName")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "resourceGroupName", valid_593995
  var valid_593996 = path.getOrDefault("subscriptionId")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "subscriptionId", valid_593996
  var valid_593997 = path.getOrDefault("accountName")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "accountName", valid_593997
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
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

proc call*(call_593999: Call_RemoteRenderingAccountsDelete_593992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Remote Rendering Account.
  ## 
  let valid = call_593999.validator(path, query, header, formData, body)
  let scheme = call_593999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593999.url(scheme.get, call_593999.host, call_593999.base,
                         call_593999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593999, url, valid)

proc call*(call_594000: Call_RemoteRenderingAccountsDelete_593992;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## remoteRenderingAccountsDelete
  ## Delete a Remote Rendering Account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Name of an Mixed Reality Account.
  var path_594001 = newJObject()
  var query_594002 = newJObject()
  add(path_594001, "resourceGroupName", newJString(resourceGroupName))
  add(query_594002, "api-version", newJString(apiVersion))
  add(path_594001, "subscriptionId", newJString(subscriptionId))
  add(path_594001, "accountName", newJString(accountName))
  result = call_594000.call(path_594001, query_594002, nil, nil, nil)

var remoteRenderingAccountsDelete* = Call_RemoteRenderingAccountsDelete_593992(
    name: "remoteRenderingAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MixedReality/remoteRenderingAccounts/{accountName}",
    validator: validate_RemoteRenderingAccountsDelete_593993, base: "",
    url: url_RemoteRenderingAccountsDelete_593994, schemes: {Scheme.Https})
type
  Call_RemoteRenderingAccountsRegenerateKeys_594027 = ref object of OpenApiRestCall_593424
proc url_RemoteRenderingAccountsRegenerateKeys_594029(protocol: Scheme;
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
        value: "/providers/Microsoft.MixedReality/remoteRenderingAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/keys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemoteRenderingAccountsRegenerateKeys_594028(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate specified Key of a Remote Rendering Account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Name of an Mixed Reality Account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594030 = path.getOrDefault("resourceGroupName")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "resourceGroupName", valid_594030
  var valid_594031 = path.getOrDefault("subscriptionId")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "subscriptionId", valid_594031
  var valid_594032 = path.getOrDefault("accountName")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "accountName", valid_594032
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594033 = query.getOrDefault("api-version")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "api-version", valid_594033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   regenerate: JObject (required)
  ##             : Required information for key regeneration.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594035: Call_RemoteRenderingAccountsRegenerateKeys_594027;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate specified Key of a Remote Rendering Account
  ## 
  let valid = call_594035.validator(path, query, header, formData, body)
  let scheme = call_594035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594035.url(scheme.get, call_594035.host, call_594035.base,
                         call_594035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594035, url, valid)

proc call*(call_594036: Call_RemoteRenderingAccountsRegenerateKeys_594027;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          regenerate: JsonNode; accountName: string): Recallable =
  ## remoteRenderingAccountsRegenerateKeys
  ## Regenerate specified Key of a Remote Rendering Account
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   regenerate: JObject (required)
  ##             : Required information for key regeneration.
  ##   accountName: string (required)
  ##              : Name of an Mixed Reality Account.
  var path_594037 = newJObject()
  var query_594038 = newJObject()
  var body_594039 = newJObject()
  add(path_594037, "resourceGroupName", newJString(resourceGroupName))
  add(query_594038, "api-version", newJString(apiVersion))
  add(path_594037, "subscriptionId", newJString(subscriptionId))
  if regenerate != nil:
    body_594039 = regenerate
  add(path_594037, "accountName", newJString(accountName))
  result = call_594036.call(path_594037, query_594038, nil, nil, body_594039)

var remoteRenderingAccountsRegenerateKeys* = Call_RemoteRenderingAccountsRegenerateKeys_594027(
    name: "remoteRenderingAccountsRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MixedReality/remoteRenderingAccounts/{accountName}/keys",
    validator: validate_RemoteRenderingAccountsRegenerateKeys_594028, base: "",
    url: url_RemoteRenderingAccountsRegenerateKeys_594029, schemes: {Scheme.Https})
type
  Call_RemoteRenderingAccountsGetKeys_594016 = ref object of OpenApiRestCall_593424
proc url_RemoteRenderingAccountsGetKeys_594018(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.MixedReality/remoteRenderingAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/keys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemoteRenderingAccountsGetKeys_594017(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Both of the 2 Keys of a Remote Rendering Account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   accountName: JString (required)
  ##              : Name of an Mixed Reality Account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594019 = path.getOrDefault("resourceGroupName")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "resourceGroupName", valid_594019
  var valid_594020 = path.getOrDefault("subscriptionId")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "subscriptionId", valid_594020
  var valid_594021 = path.getOrDefault("accountName")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "accountName", valid_594021
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594022 = query.getOrDefault("api-version")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "api-version", valid_594022
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594023: Call_RemoteRenderingAccountsGetKeys_594016; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Both of the 2 Keys of a Remote Rendering Account
  ## 
  let valid = call_594023.validator(path, query, header, formData, body)
  let scheme = call_594023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594023.url(scheme.get, call_594023.host, call_594023.base,
                         call_594023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594023, url, valid)

proc call*(call_594024: Call_RemoteRenderingAccountsGetKeys_594016;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## remoteRenderingAccountsGetKeys
  ## Get Both of the 2 Keys of a Remote Rendering Account
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   accountName: string (required)
  ##              : Name of an Mixed Reality Account.
  var path_594025 = newJObject()
  var query_594026 = newJObject()
  add(path_594025, "resourceGroupName", newJString(resourceGroupName))
  add(query_594026, "api-version", newJString(apiVersion))
  add(path_594025, "subscriptionId", newJString(subscriptionId))
  add(path_594025, "accountName", newJString(accountName))
  result = call_594024.call(path_594025, query_594026, nil, nil, nil)

var remoteRenderingAccountsGetKeys* = Call_RemoteRenderingAccountsGetKeys_594016(
    name: "remoteRenderingAccountsGetKeys", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MixedReality/remoteRenderingAccounts/{accountName}/keys",
    validator: validate_RemoteRenderingAccountsGetKeys_594017, base: "",
    url: url_RemoteRenderingAccountsGetKeys_594018, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
