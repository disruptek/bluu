
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: CognitiveServicesManagementClient
## version: 2016-02-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Cognitive Services Management Client
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

  OpenApiRestCall_593425 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593425](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593425): Option[Scheme] {.used.} =
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
  macServiceName = "cognitiveservices"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CognitiveServicesAccountsList_593647 = ref object of OpenApiRestCall_593425
proc url_CognitiveServicesAccountsList_593649(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.CognitiveServices/accounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CognitiveServicesAccountsList_593648(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns all the resources of a particular type belonging to a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593822 = path.getOrDefault("subscriptionId")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "subscriptionId", valid_593822
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-02-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593823 = query.getOrDefault("api-version")
  valid_593823 = validateParameter(valid_593823, JString, required = true,
                                 default = nil)
  if valid_593823 != nil:
    section.add "api-version", valid_593823
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593846: Call_CognitiveServicesAccountsList_593647; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all the resources of a particular type belonging to a subscription.
  ## 
  let valid = call_593846.validator(path, query, header, formData, body)
  let scheme = call_593846.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593846.url(scheme.get, call_593846.host, call_593846.base,
                         call_593846.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593846, url, valid)

proc call*(call_593917: Call_CognitiveServicesAccountsList_593647;
          apiVersion: string; subscriptionId: string): Recallable =
  ## cognitiveServicesAccountsList
  ## Returns all the resources of a particular type belonging to a subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-02-01-preview
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_593918 = newJObject()
  var query_593920 = newJObject()
  add(query_593920, "api-version", newJString(apiVersion))
  add(path_593918, "subscriptionId", newJString(subscriptionId))
  result = call_593917.call(path_593918, query_593920, nil, nil, nil)

var cognitiveServicesAccountsList* = Call_CognitiveServicesAccountsList_593647(
    name: "cognitiveServicesAccountsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CognitiveServices/accounts",
    validator: validate_CognitiveServicesAccountsList_593648, base: "",
    url: url_CognitiveServicesAccountsList_593649, schemes: {Scheme.Https})
type
  Call_CognitiveServicesAccountsListByResourceGroup_593959 = ref object of OpenApiRestCall_593425
proc url_CognitiveServicesAccountsListByResourceGroup_593961(protocol: Scheme;
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
        value: "/providers/Microsoft.CognitiveServices/accounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CognitiveServicesAccountsListByResourceGroup_593960(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns all the resources of a particular type belonging to a resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-02-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593964 = query.getOrDefault("api-version")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "api-version", valid_593964
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593965: Call_CognitiveServicesAccountsListByResourceGroup_593959;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns all the resources of a particular type belonging to a resource group
  ## 
  let valid = call_593965.validator(path, query, header, formData, body)
  let scheme = call_593965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593965.url(scheme.get, call_593965.host, call_593965.base,
                         call_593965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593965, url, valid)

proc call*(call_593966: Call_CognitiveServicesAccountsListByResourceGroup_593959;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## cognitiveServicesAccountsListByResourceGroup
  ## Returns all the resources of a particular type belonging to a resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-02-01-preview
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_593967 = newJObject()
  var query_593968 = newJObject()
  add(path_593967, "resourceGroupName", newJString(resourceGroupName))
  add(query_593968, "api-version", newJString(apiVersion))
  add(path_593967, "subscriptionId", newJString(subscriptionId))
  result = call_593966.call(path_593967, query_593968, nil, nil, nil)

var cognitiveServicesAccountsListByResourceGroup* = Call_CognitiveServicesAccountsListByResourceGroup_593959(
    name: "cognitiveServicesAccountsListByResourceGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CognitiveServices/accounts",
    validator: validate_CognitiveServicesAccountsListByResourceGroup_593960,
    base: "", url: url_CognitiveServicesAccountsListByResourceGroup_593961,
    schemes: {Scheme.Https})
type
  Call_CognitiveServicesAccountsCreate_593980 = ref object of OpenApiRestCall_593425
proc url_CognitiveServicesAccountsCreate_593982(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.CognitiveServices/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CognitiveServicesAccountsCreate_593981(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create Cognitive Services Account. Accounts is a resource group wide resource type. It holds the keys for developer to access intelligent APIs. It's also the resource type for billing.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   accountName: JString (required)
  ##              : The name of the cognitive services account within the specified resource group. Cognitive Services account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594000 = path.getOrDefault("resourceGroupName")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "resourceGroupName", valid_594000
  var valid_594001 = path.getOrDefault("subscriptionId")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "subscriptionId", valid_594001
  var valid_594002 = path.getOrDefault("accountName")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "accountName", valid_594002
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-02-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594003 = query.getOrDefault("api-version")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "api-version", valid_594003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the created account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594005: Call_CognitiveServicesAccountsCreate_593980;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create Cognitive Services Account. Accounts is a resource group wide resource type. It holds the keys for developer to access intelligent APIs. It's also the resource type for billing.
  ## 
  let valid = call_594005.validator(path, query, header, formData, body)
  let scheme = call_594005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594005.url(scheme.get, call_594005.host, call_594005.base,
                         call_594005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594005, url, valid)

proc call*(call_594006: Call_CognitiveServicesAccountsCreate_593980;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## cognitiveServicesAccountsCreate
  ## Create Cognitive Services Account. Accounts is a resource group wide resource type. It holds the keys for developer to access intelligent APIs. It's also the resource type for billing.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-02-01-preview
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the created account.
  ##   accountName: string (required)
  ##              : The name of the cognitive services account within the specified resource group. Cognitive Services account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_594007 = newJObject()
  var query_594008 = newJObject()
  var body_594009 = newJObject()
  add(path_594007, "resourceGroupName", newJString(resourceGroupName))
  add(query_594008, "api-version", newJString(apiVersion))
  add(path_594007, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594009 = parameters
  add(path_594007, "accountName", newJString(accountName))
  result = call_594006.call(path_594007, query_594008, nil, nil, body_594009)

var cognitiveServicesAccountsCreate* = Call_CognitiveServicesAccountsCreate_593980(
    name: "cognitiveServicesAccountsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CognitiveServices/accounts/{accountName}",
    validator: validate_CognitiveServicesAccountsCreate_593981, base: "",
    url: url_CognitiveServicesAccountsCreate_593982, schemes: {Scheme.Https})
type
  Call_CognitiveServicesAccountsGetProperties_593969 = ref object of OpenApiRestCall_593425
proc url_CognitiveServicesAccountsGetProperties_593971(protocol: Scheme;
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
        value: "/providers/Microsoft.CognitiveServices/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CognitiveServicesAccountsGetProperties_593970(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a Cognitive Services account specified by the parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   accountName: JString (required)
  ##              : The name of the cognitive services account within the specified resource group. Cognitive Services account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593972 = path.getOrDefault("resourceGroupName")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "resourceGroupName", valid_593972
  var valid_593973 = path.getOrDefault("subscriptionId")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "subscriptionId", valid_593973
  var valid_593974 = path.getOrDefault("accountName")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "accountName", valid_593974
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-02-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593975 = query.getOrDefault("api-version")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "api-version", valid_593975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593976: Call_CognitiveServicesAccountsGetProperties_593969;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a Cognitive Services account specified by the parameters.
  ## 
  let valid = call_593976.validator(path, query, header, formData, body)
  let scheme = call_593976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593976.url(scheme.get, call_593976.host, call_593976.base,
                         call_593976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593976, url, valid)

proc call*(call_593977: Call_CognitiveServicesAccountsGetProperties_593969;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## cognitiveServicesAccountsGetProperties
  ## Returns a Cognitive Services account specified by the parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-02-01-preview
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   accountName: string (required)
  ##              : The name of the cognitive services account within the specified resource group. Cognitive Services account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_593978 = newJObject()
  var query_593979 = newJObject()
  add(path_593978, "resourceGroupName", newJString(resourceGroupName))
  add(query_593979, "api-version", newJString(apiVersion))
  add(path_593978, "subscriptionId", newJString(subscriptionId))
  add(path_593978, "accountName", newJString(accountName))
  result = call_593977.call(path_593978, query_593979, nil, nil, nil)

var cognitiveServicesAccountsGetProperties* = Call_CognitiveServicesAccountsGetProperties_593969(
    name: "cognitiveServicesAccountsGetProperties", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CognitiveServices/accounts/{accountName}",
    validator: validate_CognitiveServicesAccountsGetProperties_593970, base: "",
    url: url_CognitiveServicesAccountsGetProperties_593971,
    schemes: {Scheme.Https})
type
  Call_CognitiveServicesAccountsUpdate_594021 = ref object of OpenApiRestCall_593425
proc url_CognitiveServicesAccountsUpdate_594023(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.CognitiveServices/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CognitiveServicesAccountsUpdate_594022(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a Cognitive Services account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   accountName: JString (required)
  ##              : The name of the cognitive services account within the specified resource group. Cognitive Services account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594024 = path.getOrDefault("resourceGroupName")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "resourceGroupName", valid_594024
  var valid_594025 = path.getOrDefault("subscriptionId")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "subscriptionId", valid_594025
  var valid_594026 = path.getOrDefault("accountName")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "accountName", valid_594026
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-02-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594027 = query.getOrDefault("api-version")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "api-version", valid_594027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : The parameters to provide for the created account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594029: Call_CognitiveServicesAccountsUpdate_594021;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a Cognitive Services account
  ## 
  let valid = call_594029.validator(path, query, header, formData, body)
  let scheme = call_594029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594029.url(scheme.get, call_594029.host, call_594029.base,
                         call_594029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594029, url, valid)

proc call*(call_594030: Call_CognitiveServicesAccountsUpdate_594021;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          body: JsonNode; accountName: string): Recallable =
  ## cognitiveServicesAccountsUpdate
  ## Updates a Cognitive Services account
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-02-01-preview
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   body: JObject (required)
  ##       : The parameters to provide for the created account.
  ##   accountName: string (required)
  ##              : The name of the cognitive services account within the specified resource group. Cognitive Services account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_594031 = newJObject()
  var query_594032 = newJObject()
  var body_594033 = newJObject()
  add(path_594031, "resourceGroupName", newJString(resourceGroupName))
  add(query_594032, "api-version", newJString(apiVersion))
  add(path_594031, "subscriptionId", newJString(subscriptionId))
  if body != nil:
    body_594033 = body
  add(path_594031, "accountName", newJString(accountName))
  result = call_594030.call(path_594031, query_594032, nil, nil, body_594033)

var cognitiveServicesAccountsUpdate* = Call_CognitiveServicesAccountsUpdate_594021(
    name: "cognitiveServicesAccountsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CognitiveServices/accounts/{accountName}",
    validator: validate_CognitiveServicesAccountsUpdate_594022, base: "",
    url: url_CognitiveServicesAccountsUpdate_594023, schemes: {Scheme.Https})
type
  Call_CognitiveServicesAccountsDelete_594010 = ref object of OpenApiRestCall_593425
proc url_CognitiveServicesAccountsDelete_594012(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.CognitiveServices/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CognitiveServicesAccountsDelete_594011(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a Cognitive Services account from the resource group. 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   accountName: JString (required)
  ##              : The name of the cognitive services account within the specified resource group. Cognitive Services account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
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
  ##              : Version of the API to be used with the client request. Current version is 2016-02-01-preview
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
  if body != nil:
    result.add "body", body

proc call*(call_594017: Call_CognitiveServicesAccountsDelete_594010;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a Cognitive Services account from the resource group. 
  ## 
  let valid = call_594017.validator(path, query, header, formData, body)
  let scheme = call_594017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594017.url(scheme.get, call_594017.host, call_594017.base,
                         call_594017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594017, url, valid)

proc call*(call_594018: Call_CognitiveServicesAccountsDelete_594010;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## cognitiveServicesAccountsDelete
  ## Deletes a Cognitive Services account from the resource group. 
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-02-01-preview
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   accountName: string (required)
  ##              : The name of the cognitive services account within the specified resource group. Cognitive Services account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_594019 = newJObject()
  var query_594020 = newJObject()
  add(path_594019, "resourceGroupName", newJString(resourceGroupName))
  add(query_594020, "api-version", newJString(apiVersion))
  add(path_594019, "subscriptionId", newJString(subscriptionId))
  add(path_594019, "accountName", newJString(accountName))
  result = call_594018.call(path_594019, query_594020, nil, nil, nil)

var cognitiveServicesAccountsDelete* = Call_CognitiveServicesAccountsDelete_594010(
    name: "cognitiveServicesAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CognitiveServices/accounts/{accountName}",
    validator: validate_CognitiveServicesAccountsDelete_594011, base: "",
    url: url_CognitiveServicesAccountsDelete_594012, schemes: {Scheme.Https})
type
  Call_CognitiveServicesAccountsListKeys_594034 = ref object of OpenApiRestCall_593425
proc url_CognitiveServicesAccountsListKeys_594036(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.CognitiveServices/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CognitiveServicesAccountsListKeys_594035(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the account keys for the specified Cognitive Services account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   accountName: JString (required)
  ##              : The name of the cognitive services account within the specified resource group. Cognitive Services account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.  
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
  ##              : Version of the API to be used with the client request. Current version is 2016-02-01-preview
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
  if body != nil:
    result.add "body", body

proc call*(call_594041: Call_CognitiveServicesAccountsListKeys_594034;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the account keys for the specified Cognitive Services account.
  ## 
  let valid = call_594041.validator(path, query, header, formData, body)
  let scheme = call_594041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594041.url(scheme.get, call_594041.host, call_594041.base,
                         call_594041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594041, url, valid)

proc call*(call_594042: Call_CognitiveServicesAccountsListKeys_594034;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## cognitiveServicesAccountsListKeys
  ## Lists the account keys for the specified Cognitive Services account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-02-01-preview
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   accountName: string (required)
  ##              : The name of the cognitive services account within the specified resource group. Cognitive Services account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.  
  var path_594043 = newJObject()
  var query_594044 = newJObject()
  add(path_594043, "resourceGroupName", newJString(resourceGroupName))
  add(query_594044, "api-version", newJString(apiVersion))
  add(path_594043, "subscriptionId", newJString(subscriptionId))
  add(path_594043, "accountName", newJString(accountName))
  result = call_594042.call(path_594043, query_594044, nil, nil, nil)

var cognitiveServicesAccountsListKeys* = Call_CognitiveServicesAccountsListKeys_594034(
    name: "cognitiveServicesAccountsListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CognitiveServices/accounts/{accountName}/listKeys",
    validator: validate_CognitiveServicesAccountsListKeys_594035, base: "",
    url: url_CognitiveServicesAccountsListKeys_594036, schemes: {Scheme.Https})
type
  Call_CognitiveServicesAccountsRegenerateKey_594045 = ref object of OpenApiRestCall_593425
proc url_CognitiveServicesAccountsRegenerateKey_594047(protocol: Scheme;
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
        value: "/providers/Microsoft.CognitiveServices/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/regenerateKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CognitiveServicesAccountsRegenerateKey_594046(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the specified account key for the specified Cognitive Services account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   accountName: JString (required)
  ##              : The name of the cognitive services account within the specified resource group. Cognitive Services account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.  
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594048 = path.getOrDefault("resourceGroupName")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "resourceGroupName", valid_594048
  var valid_594049 = path.getOrDefault("subscriptionId")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "subscriptionId", valid_594049
  var valid_594050 = path.getOrDefault("accountName")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "accountName", valid_594050
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-02-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594051 = query.getOrDefault("api-version")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "api-version", valid_594051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : regenerate key parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594053: Call_CognitiveServicesAccountsRegenerateKey_594045;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates the specified account key for the specified Cognitive Services account.
  ## 
  let valid = call_594053.validator(path, query, header, formData, body)
  let scheme = call_594053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594053.url(scheme.get, call_594053.host, call_594053.base,
                         call_594053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594053, url, valid)

proc call*(call_594054: Call_CognitiveServicesAccountsRegenerateKey_594045;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          body: JsonNode; accountName: string): Recallable =
  ## cognitiveServicesAccountsRegenerateKey
  ## Regenerates the specified account key for the specified Cognitive Services account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-02-01-preview
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   body: JObject (required)
  ##       : regenerate key parameters.
  ##   accountName: string (required)
  ##              : The name of the cognitive services account within the specified resource group. Cognitive Services account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.  
  var path_594055 = newJObject()
  var query_594056 = newJObject()
  var body_594057 = newJObject()
  add(path_594055, "resourceGroupName", newJString(resourceGroupName))
  add(query_594056, "api-version", newJString(apiVersion))
  add(path_594055, "subscriptionId", newJString(subscriptionId))
  if body != nil:
    body_594057 = body
  add(path_594055, "accountName", newJString(accountName))
  result = call_594054.call(path_594055, query_594056, nil, nil, body_594057)

var cognitiveServicesAccountsRegenerateKey* = Call_CognitiveServicesAccountsRegenerateKey_594045(
    name: "cognitiveServicesAccountsRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CognitiveServices/accounts/{accountName}/regenerateKey",
    validator: validate_CognitiveServicesAccountsRegenerateKey_594046, base: "",
    url: url_CognitiveServicesAccountsRegenerateKey_594047,
    schemes: {Scheme.Https})
type
  Call_CognitiveServicesAccountsListSkus_594058 = ref object of OpenApiRestCall_593425
proc url_CognitiveServicesAccountsListSkus_594060(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.CognitiveServices/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CognitiveServicesAccountsListSkus_594059(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List available SKUs for the requested Cognitive Services account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   accountName: JString (required)
  ##              : The name of the cognitive services account within the specified resource group. Cognitive Services account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.  
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594061 = path.getOrDefault("resourceGroupName")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "resourceGroupName", valid_594061
  var valid_594062 = path.getOrDefault("subscriptionId")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "subscriptionId", valid_594062
  var valid_594063 = path.getOrDefault("accountName")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "accountName", valid_594063
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-02-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594064 = query.getOrDefault("api-version")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "api-version", valid_594064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594065: Call_CognitiveServicesAccountsListSkus_594058;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List available SKUs for the requested Cognitive Services account
  ## 
  let valid = call_594065.validator(path, query, header, formData, body)
  let scheme = call_594065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594065.url(scheme.get, call_594065.host, call_594065.base,
                         call_594065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594065, url, valid)

proc call*(call_594066: Call_CognitiveServicesAccountsListSkus_594058;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## cognitiveServicesAccountsListSkus
  ## List available SKUs for the requested Cognitive Services account
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-02-01-preview
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   accountName: string (required)
  ##              : The name of the cognitive services account within the specified resource group. Cognitive Services account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.  
  var path_594067 = newJObject()
  var query_594068 = newJObject()
  add(path_594067, "resourceGroupName", newJString(resourceGroupName))
  add(query_594068, "api-version", newJString(apiVersion))
  add(path_594067, "subscriptionId", newJString(subscriptionId))
  add(path_594067, "accountName", newJString(accountName))
  result = call_594066.call(path_594067, query_594068, nil, nil, nil)

var cognitiveServicesAccountsListSkus* = Call_CognitiveServicesAccountsListSkus_594058(
    name: "cognitiveServicesAccountsListSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CognitiveServices/accounts/{accountName}/skus",
    validator: validate_CognitiveServicesAccountsListSkus_594059, base: "",
    url: url_CognitiveServicesAccountsListSkus_594060, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
