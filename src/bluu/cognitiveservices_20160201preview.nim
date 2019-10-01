
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_569458 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_569458](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_569458): Option[Scheme] {.used.} =
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
  macServiceName = "cognitiveservices"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CognitiveServicesAccountsList_569680 = ref object of OpenApiRestCall_569458
proc url_CognitiveServicesAccountsList_569682(protocol: Scheme; host: string;
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

proc validate_CognitiveServicesAccountsList_569681(path: JsonNode; query: JsonNode;
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
  var valid_569855 = path.getOrDefault("subscriptionId")
  valid_569855 = validateParameter(valid_569855, JString, required = true,
                                 default = nil)
  if valid_569855 != nil:
    section.add "subscriptionId", valid_569855
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-02-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569856 = query.getOrDefault("api-version")
  valid_569856 = validateParameter(valid_569856, JString, required = true,
                                 default = nil)
  if valid_569856 != nil:
    section.add "api-version", valid_569856
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569879: Call_CognitiveServicesAccountsList_569680; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all the resources of a particular type belonging to a subscription.
  ## 
  let valid = call_569879.validator(path, query, header, formData, body)
  let scheme = call_569879.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569879.url(scheme.get, call_569879.host, call_569879.base,
                         call_569879.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569879, url, valid)

proc call*(call_569950: Call_CognitiveServicesAccountsList_569680;
          apiVersion: string; subscriptionId: string): Recallable =
  ## cognitiveServicesAccountsList
  ## Returns all the resources of a particular type belonging to a subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-02-01-preview
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_569951 = newJObject()
  var query_569953 = newJObject()
  add(query_569953, "api-version", newJString(apiVersion))
  add(path_569951, "subscriptionId", newJString(subscriptionId))
  result = call_569950.call(path_569951, query_569953, nil, nil, nil)

var cognitiveServicesAccountsList* = Call_CognitiveServicesAccountsList_569680(
    name: "cognitiveServicesAccountsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CognitiveServices/accounts",
    validator: validate_CognitiveServicesAccountsList_569681, base: "",
    url: url_CognitiveServicesAccountsList_569682, schemes: {Scheme.Https})
type
  Call_CognitiveServicesAccountsListByResourceGroup_569992 = ref object of OpenApiRestCall_569458
proc url_CognitiveServicesAccountsListByResourceGroup_569994(protocol: Scheme;
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

proc validate_CognitiveServicesAccountsListByResourceGroup_569993(path: JsonNode;
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
  var valid_569995 = path.getOrDefault("resourceGroupName")
  valid_569995 = validateParameter(valid_569995, JString, required = true,
                                 default = nil)
  if valid_569995 != nil:
    section.add "resourceGroupName", valid_569995
  var valid_569996 = path.getOrDefault("subscriptionId")
  valid_569996 = validateParameter(valid_569996, JString, required = true,
                                 default = nil)
  if valid_569996 != nil:
    section.add "subscriptionId", valid_569996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-02-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569997 = query.getOrDefault("api-version")
  valid_569997 = validateParameter(valid_569997, JString, required = true,
                                 default = nil)
  if valid_569997 != nil:
    section.add "api-version", valid_569997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569998: Call_CognitiveServicesAccountsListByResourceGroup_569992;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns all the resources of a particular type belonging to a resource group
  ## 
  let valid = call_569998.validator(path, query, header, formData, body)
  let scheme = call_569998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569998.url(scheme.get, call_569998.host, call_569998.base,
                         call_569998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569998, url, valid)

proc call*(call_569999: Call_CognitiveServicesAccountsListByResourceGroup_569992;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## cognitiveServicesAccountsListByResourceGroup
  ## Returns all the resources of a particular type belonging to a resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2016-02-01-preview
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_570000 = newJObject()
  var query_570001 = newJObject()
  add(path_570000, "resourceGroupName", newJString(resourceGroupName))
  add(query_570001, "api-version", newJString(apiVersion))
  add(path_570000, "subscriptionId", newJString(subscriptionId))
  result = call_569999.call(path_570000, query_570001, nil, nil, nil)

var cognitiveServicesAccountsListByResourceGroup* = Call_CognitiveServicesAccountsListByResourceGroup_569992(
    name: "cognitiveServicesAccountsListByResourceGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CognitiveServices/accounts",
    validator: validate_CognitiveServicesAccountsListByResourceGroup_569993,
    base: "", url: url_CognitiveServicesAccountsListByResourceGroup_569994,
    schemes: {Scheme.Https})
type
  Call_CognitiveServicesAccountsCreate_570013 = ref object of OpenApiRestCall_569458
proc url_CognitiveServicesAccountsCreate_570015(protocol: Scheme; host: string;
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

proc validate_CognitiveServicesAccountsCreate_570014(path: JsonNode;
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
  var valid_570033 = path.getOrDefault("resourceGroupName")
  valid_570033 = validateParameter(valid_570033, JString, required = true,
                                 default = nil)
  if valid_570033 != nil:
    section.add "resourceGroupName", valid_570033
  var valid_570034 = path.getOrDefault("subscriptionId")
  valid_570034 = validateParameter(valid_570034, JString, required = true,
                                 default = nil)
  if valid_570034 != nil:
    section.add "subscriptionId", valid_570034
  var valid_570035 = path.getOrDefault("accountName")
  valid_570035 = validateParameter(valid_570035, JString, required = true,
                                 default = nil)
  if valid_570035 != nil:
    section.add "accountName", valid_570035
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-02-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_570036 = query.getOrDefault("api-version")
  valid_570036 = validateParameter(valid_570036, JString, required = true,
                                 default = nil)
  if valid_570036 != nil:
    section.add "api-version", valid_570036
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

proc call*(call_570038: Call_CognitiveServicesAccountsCreate_570013;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create Cognitive Services Account. Accounts is a resource group wide resource type. It holds the keys for developer to access intelligent APIs. It's also the resource type for billing.
  ## 
  let valid = call_570038.validator(path, query, header, formData, body)
  let scheme = call_570038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_570038.url(scheme.get, call_570038.host, call_570038.base,
                         call_570038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_570038, url, valid)

proc call*(call_570039: Call_CognitiveServicesAccountsCreate_570013;
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
  var path_570040 = newJObject()
  var query_570041 = newJObject()
  var body_570042 = newJObject()
  add(path_570040, "resourceGroupName", newJString(resourceGroupName))
  add(query_570041, "api-version", newJString(apiVersion))
  add(path_570040, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_570042 = parameters
  add(path_570040, "accountName", newJString(accountName))
  result = call_570039.call(path_570040, query_570041, nil, nil, body_570042)

var cognitiveServicesAccountsCreate* = Call_CognitiveServicesAccountsCreate_570013(
    name: "cognitiveServicesAccountsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CognitiveServices/accounts/{accountName}",
    validator: validate_CognitiveServicesAccountsCreate_570014, base: "",
    url: url_CognitiveServicesAccountsCreate_570015, schemes: {Scheme.Https})
type
  Call_CognitiveServicesAccountsGetProperties_570002 = ref object of OpenApiRestCall_569458
proc url_CognitiveServicesAccountsGetProperties_570004(protocol: Scheme;
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

proc validate_CognitiveServicesAccountsGetProperties_570003(path: JsonNode;
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
  var valid_570005 = path.getOrDefault("resourceGroupName")
  valid_570005 = validateParameter(valid_570005, JString, required = true,
                                 default = nil)
  if valid_570005 != nil:
    section.add "resourceGroupName", valid_570005
  var valid_570006 = path.getOrDefault("subscriptionId")
  valid_570006 = validateParameter(valid_570006, JString, required = true,
                                 default = nil)
  if valid_570006 != nil:
    section.add "subscriptionId", valid_570006
  var valid_570007 = path.getOrDefault("accountName")
  valid_570007 = validateParameter(valid_570007, JString, required = true,
                                 default = nil)
  if valid_570007 != nil:
    section.add "accountName", valid_570007
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-02-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_570008 = query.getOrDefault("api-version")
  valid_570008 = validateParameter(valid_570008, JString, required = true,
                                 default = nil)
  if valid_570008 != nil:
    section.add "api-version", valid_570008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_570009: Call_CognitiveServicesAccountsGetProperties_570002;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a Cognitive Services account specified by the parameters.
  ## 
  let valid = call_570009.validator(path, query, header, formData, body)
  let scheme = call_570009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_570009.url(scheme.get, call_570009.host, call_570009.base,
                         call_570009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_570009, url, valid)

proc call*(call_570010: Call_CognitiveServicesAccountsGetProperties_570002;
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
  var path_570011 = newJObject()
  var query_570012 = newJObject()
  add(path_570011, "resourceGroupName", newJString(resourceGroupName))
  add(query_570012, "api-version", newJString(apiVersion))
  add(path_570011, "subscriptionId", newJString(subscriptionId))
  add(path_570011, "accountName", newJString(accountName))
  result = call_570010.call(path_570011, query_570012, nil, nil, nil)

var cognitiveServicesAccountsGetProperties* = Call_CognitiveServicesAccountsGetProperties_570002(
    name: "cognitiveServicesAccountsGetProperties", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CognitiveServices/accounts/{accountName}",
    validator: validate_CognitiveServicesAccountsGetProperties_570003, base: "",
    url: url_CognitiveServicesAccountsGetProperties_570004,
    schemes: {Scheme.Https})
type
  Call_CognitiveServicesAccountsUpdate_570054 = ref object of OpenApiRestCall_569458
proc url_CognitiveServicesAccountsUpdate_570056(protocol: Scheme; host: string;
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

proc validate_CognitiveServicesAccountsUpdate_570055(path: JsonNode;
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
  var valid_570057 = path.getOrDefault("resourceGroupName")
  valid_570057 = validateParameter(valid_570057, JString, required = true,
                                 default = nil)
  if valid_570057 != nil:
    section.add "resourceGroupName", valid_570057
  var valid_570058 = path.getOrDefault("subscriptionId")
  valid_570058 = validateParameter(valid_570058, JString, required = true,
                                 default = nil)
  if valid_570058 != nil:
    section.add "subscriptionId", valid_570058
  var valid_570059 = path.getOrDefault("accountName")
  valid_570059 = validateParameter(valid_570059, JString, required = true,
                                 default = nil)
  if valid_570059 != nil:
    section.add "accountName", valid_570059
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-02-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_570060 = query.getOrDefault("api-version")
  valid_570060 = validateParameter(valid_570060, JString, required = true,
                                 default = nil)
  if valid_570060 != nil:
    section.add "api-version", valid_570060
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

proc call*(call_570062: Call_CognitiveServicesAccountsUpdate_570054;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a Cognitive Services account
  ## 
  let valid = call_570062.validator(path, query, header, formData, body)
  let scheme = call_570062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_570062.url(scheme.get, call_570062.host, call_570062.base,
                         call_570062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_570062, url, valid)

proc call*(call_570063: Call_CognitiveServicesAccountsUpdate_570054;
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
  var path_570064 = newJObject()
  var query_570065 = newJObject()
  var body_570066 = newJObject()
  add(path_570064, "resourceGroupName", newJString(resourceGroupName))
  add(query_570065, "api-version", newJString(apiVersion))
  add(path_570064, "subscriptionId", newJString(subscriptionId))
  if body != nil:
    body_570066 = body
  add(path_570064, "accountName", newJString(accountName))
  result = call_570063.call(path_570064, query_570065, nil, nil, body_570066)

var cognitiveServicesAccountsUpdate* = Call_CognitiveServicesAccountsUpdate_570054(
    name: "cognitiveServicesAccountsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CognitiveServices/accounts/{accountName}",
    validator: validate_CognitiveServicesAccountsUpdate_570055, base: "",
    url: url_CognitiveServicesAccountsUpdate_570056, schemes: {Scheme.Https})
type
  Call_CognitiveServicesAccountsDelete_570043 = ref object of OpenApiRestCall_569458
proc url_CognitiveServicesAccountsDelete_570045(protocol: Scheme; host: string;
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

proc validate_CognitiveServicesAccountsDelete_570044(path: JsonNode;
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
  var valid_570046 = path.getOrDefault("resourceGroupName")
  valid_570046 = validateParameter(valid_570046, JString, required = true,
                                 default = nil)
  if valid_570046 != nil:
    section.add "resourceGroupName", valid_570046
  var valid_570047 = path.getOrDefault("subscriptionId")
  valid_570047 = validateParameter(valid_570047, JString, required = true,
                                 default = nil)
  if valid_570047 != nil:
    section.add "subscriptionId", valid_570047
  var valid_570048 = path.getOrDefault("accountName")
  valid_570048 = validateParameter(valid_570048, JString, required = true,
                                 default = nil)
  if valid_570048 != nil:
    section.add "accountName", valid_570048
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-02-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_570049 = query.getOrDefault("api-version")
  valid_570049 = validateParameter(valid_570049, JString, required = true,
                                 default = nil)
  if valid_570049 != nil:
    section.add "api-version", valid_570049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_570050: Call_CognitiveServicesAccountsDelete_570043;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a Cognitive Services account from the resource group. 
  ## 
  let valid = call_570050.validator(path, query, header, formData, body)
  let scheme = call_570050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_570050.url(scheme.get, call_570050.host, call_570050.base,
                         call_570050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_570050, url, valid)

proc call*(call_570051: Call_CognitiveServicesAccountsDelete_570043;
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
  var path_570052 = newJObject()
  var query_570053 = newJObject()
  add(path_570052, "resourceGroupName", newJString(resourceGroupName))
  add(query_570053, "api-version", newJString(apiVersion))
  add(path_570052, "subscriptionId", newJString(subscriptionId))
  add(path_570052, "accountName", newJString(accountName))
  result = call_570051.call(path_570052, query_570053, nil, nil, nil)

var cognitiveServicesAccountsDelete* = Call_CognitiveServicesAccountsDelete_570043(
    name: "cognitiveServicesAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CognitiveServices/accounts/{accountName}",
    validator: validate_CognitiveServicesAccountsDelete_570044, base: "",
    url: url_CognitiveServicesAccountsDelete_570045, schemes: {Scheme.Https})
type
  Call_CognitiveServicesAccountsListKeys_570067 = ref object of OpenApiRestCall_569458
proc url_CognitiveServicesAccountsListKeys_570069(protocol: Scheme; host: string;
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

proc validate_CognitiveServicesAccountsListKeys_570068(path: JsonNode;
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
  var valid_570070 = path.getOrDefault("resourceGroupName")
  valid_570070 = validateParameter(valid_570070, JString, required = true,
                                 default = nil)
  if valid_570070 != nil:
    section.add "resourceGroupName", valid_570070
  var valid_570071 = path.getOrDefault("subscriptionId")
  valid_570071 = validateParameter(valid_570071, JString, required = true,
                                 default = nil)
  if valid_570071 != nil:
    section.add "subscriptionId", valid_570071
  var valid_570072 = path.getOrDefault("accountName")
  valid_570072 = validateParameter(valid_570072, JString, required = true,
                                 default = nil)
  if valid_570072 != nil:
    section.add "accountName", valid_570072
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-02-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_570073 = query.getOrDefault("api-version")
  valid_570073 = validateParameter(valid_570073, JString, required = true,
                                 default = nil)
  if valid_570073 != nil:
    section.add "api-version", valid_570073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_570074: Call_CognitiveServicesAccountsListKeys_570067;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the account keys for the specified Cognitive Services account.
  ## 
  let valid = call_570074.validator(path, query, header, formData, body)
  let scheme = call_570074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_570074.url(scheme.get, call_570074.host, call_570074.base,
                         call_570074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_570074, url, valid)

proc call*(call_570075: Call_CognitiveServicesAccountsListKeys_570067;
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
  var path_570076 = newJObject()
  var query_570077 = newJObject()
  add(path_570076, "resourceGroupName", newJString(resourceGroupName))
  add(query_570077, "api-version", newJString(apiVersion))
  add(path_570076, "subscriptionId", newJString(subscriptionId))
  add(path_570076, "accountName", newJString(accountName))
  result = call_570075.call(path_570076, query_570077, nil, nil, nil)

var cognitiveServicesAccountsListKeys* = Call_CognitiveServicesAccountsListKeys_570067(
    name: "cognitiveServicesAccountsListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CognitiveServices/accounts/{accountName}/listKeys",
    validator: validate_CognitiveServicesAccountsListKeys_570068, base: "",
    url: url_CognitiveServicesAccountsListKeys_570069, schemes: {Scheme.Https})
type
  Call_CognitiveServicesAccountsRegenerateKey_570078 = ref object of OpenApiRestCall_569458
proc url_CognitiveServicesAccountsRegenerateKey_570080(protocol: Scheme;
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

proc validate_CognitiveServicesAccountsRegenerateKey_570079(path: JsonNode;
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
  var valid_570081 = path.getOrDefault("resourceGroupName")
  valid_570081 = validateParameter(valid_570081, JString, required = true,
                                 default = nil)
  if valid_570081 != nil:
    section.add "resourceGroupName", valid_570081
  var valid_570082 = path.getOrDefault("subscriptionId")
  valid_570082 = validateParameter(valid_570082, JString, required = true,
                                 default = nil)
  if valid_570082 != nil:
    section.add "subscriptionId", valid_570082
  var valid_570083 = path.getOrDefault("accountName")
  valid_570083 = validateParameter(valid_570083, JString, required = true,
                                 default = nil)
  if valid_570083 != nil:
    section.add "accountName", valid_570083
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-02-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_570084 = query.getOrDefault("api-version")
  valid_570084 = validateParameter(valid_570084, JString, required = true,
                                 default = nil)
  if valid_570084 != nil:
    section.add "api-version", valid_570084
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

proc call*(call_570086: Call_CognitiveServicesAccountsRegenerateKey_570078;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates the specified account key for the specified Cognitive Services account.
  ## 
  let valid = call_570086.validator(path, query, header, formData, body)
  let scheme = call_570086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_570086.url(scheme.get, call_570086.host, call_570086.base,
                         call_570086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_570086, url, valid)

proc call*(call_570087: Call_CognitiveServicesAccountsRegenerateKey_570078;
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
  var path_570088 = newJObject()
  var query_570089 = newJObject()
  var body_570090 = newJObject()
  add(path_570088, "resourceGroupName", newJString(resourceGroupName))
  add(query_570089, "api-version", newJString(apiVersion))
  add(path_570088, "subscriptionId", newJString(subscriptionId))
  if body != nil:
    body_570090 = body
  add(path_570088, "accountName", newJString(accountName))
  result = call_570087.call(path_570088, query_570089, nil, nil, body_570090)

var cognitiveServicesAccountsRegenerateKey* = Call_CognitiveServicesAccountsRegenerateKey_570078(
    name: "cognitiveServicesAccountsRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CognitiveServices/accounts/{accountName}/regenerateKey",
    validator: validate_CognitiveServicesAccountsRegenerateKey_570079, base: "",
    url: url_CognitiveServicesAccountsRegenerateKey_570080,
    schemes: {Scheme.Https})
type
  Call_CognitiveServicesAccountsListSkus_570091 = ref object of OpenApiRestCall_569458
proc url_CognitiveServicesAccountsListSkus_570093(protocol: Scheme; host: string;
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

proc validate_CognitiveServicesAccountsListSkus_570092(path: JsonNode;
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
  var valid_570094 = path.getOrDefault("resourceGroupName")
  valid_570094 = validateParameter(valid_570094, JString, required = true,
                                 default = nil)
  if valid_570094 != nil:
    section.add "resourceGroupName", valid_570094
  var valid_570095 = path.getOrDefault("subscriptionId")
  valid_570095 = validateParameter(valid_570095, JString, required = true,
                                 default = nil)
  if valid_570095 != nil:
    section.add "subscriptionId", valid_570095
  var valid_570096 = path.getOrDefault("accountName")
  valid_570096 = validateParameter(valid_570096, JString, required = true,
                                 default = nil)
  if valid_570096 != nil:
    section.add "accountName", valid_570096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2016-02-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_570097 = query.getOrDefault("api-version")
  valid_570097 = validateParameter(valid_570097, JString, required = true,
                                 default = nil)
  if valid_570097 != nil:
    section.add "api-version", valid_570097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_570098: Call_CognitiveServicesAccountsListSkus_570091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List available SKUs for the requested Cognitive Services account
  ## 
  let valid = call_570098.validator(path, query, header, formData, body)
  let scheme = call_570098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_570098.url(scheme.get, call_570098.host, call_570098.base,
                         call_570098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_570098, url, valid)

proc call*(call_570099: Call_CognitiveServicesAccountsListSkus_570091;
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
  var path_570100 = newJObject()
  var query_570101 = newJObject()
  add(path_570100, "resourceGroupName", newJString(resourceGroupName))
  add(query_570101, "api-version", newJString(apiVersion))
  add(path_570100, "subscriptionId", newJString(subscriptionId))
  add(path_570100, "accountName", newJString(accountName))
  result = call_570099.call(path_570100, query_570101, nil, nil, nil)

var cognitiveServicesAccountsListSkus* = Call_CognitiveServicesAccountsListSkus_570091(
    name: "cognitiveServicesAccountsListSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CognitiveServices/accounts/{accountName}/skus",
    validator: validate_CognitiveServicesAccountsListSkus_570092, base: "",
    url: url_CognitiveServicesAccountsListSkus_570093, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
