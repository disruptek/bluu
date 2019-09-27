
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Bot Service
## version: 2018-07-12
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Bot Service is a platform for creating smart conversational agents.
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

  OpenApiRestCall_593437 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593437](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593437): Option[Scheme] {.used.} =
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
  macServiceName = "botservice"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_EnterpriseChannelsCheckNameAvailability_593659 = ref object of OpenApiRestCall_593437
proc url_EnterpriseChannelsCheckNameAvailability_593661(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_EnterpriseChannelsCheckNameAvailability_593660(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check whether an Enterprise Channel name is available.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593820 = query.getOrDefault("api-version")
  valid_593820 = validateParameter(valid_593820, JString, required = true,
                                 default = nil)
  if valid_593820 != nil:
    section.add "api-version", valid_593820
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the Enterprise Channel check name availability request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593844: Call_EnterpriseChannelsCheckNameAvailability_593659;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check whether an Enterprise Channel name is available.
  ## 
  let valid = call_593844.validator(path, query, header, formData, body)
  let scheme = call_593844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593844.url(scheme.get, call_593844.host, call_593844.base,
                         call_593844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593844, url, valid)

proc call*(call_593915: Call_EnterpriseChannelsCheckNameAvailability_593659;
          apiVersion: string; parameters: JsonNode): Recallable =
  ## enterpriseChannelsCheckNameAvailability
  ## Check whether an Enterprise Channel name is available.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the Enterprise Channel check name availability request.
  var query_593916 = newJObject()
  var body_593918 = newJObject()
  add(query_593916, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_593918 = parameters
  result = call_593915.call(nil, query_593916, nil, nil, body_593918)

var enterpriseChannelsCheckNameAvailability* = Call_EnterpriseChannelsCheckNameAvailability_593659(
    name: "enterpriseChannelsCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.BotService/checkEnterpriseChannelNameAvailability",
    validator: validate_EnterpriseChannelsCheckNameAvailability_593660, base: "",
    url: url_EnterpriseChannelsCheckNameAvailability_593661,
    schemes: {Scheme.Https})
type
  Call_BotsGetCheckNameAvailability_593957 = ref object of OpenApiRestCall_593437
proc url_BotsGetCheckNameAvailability_593959(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BotsGetCheckNameAvailability_593958(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check whether a bot name is available.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593960 = query.getOrDefault("api-version")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = nil)
  if valid_593960 != nil:
    section.add "api-version", valid_593960
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The request body parameters to provide for the check name availability request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593962: Call_BotsGetCheckNameAvailability_593957; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check whether a bot name is available.
  ## 
  let valid = call_593962.validator(path, query, header, formData, body)
  let scheme = call_593962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593962.url(scheme.get, call_593962.host, call_593962.base,
                         call_593962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593962, url, valid)

proc call*(call_593963: Call_BotsGetCheckNameAvailability_593957;
          apiVersion: string; parameters: JsonNode): Recallable =
  ## botsGetCheckNameAvailability
  ## Check whether a bot name is available.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   parameters: JObject (required)
  ##             : The request body parameters to provide for the check name availability request
  var query_593964 = newJObject()
  var body_593965 = newJObject()
  add(query_593964, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_593965 = parameters
  result = call_593963.call(nil, query_593964, nil, nil, body_593965)

var botsGetCheckNameAvailability* = Call_BotsGetCheckNameAvailability_593957(
    name: "botsGetCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.BotService/checkNameAvailability",
    validator: validate_BotsGetCheckNameAvailability_593958, base: "",
    url: url_BotsGetCheckNameAvailability_593959, schemes: {Scheme.Https})
type
  Call_OperationsList_593966 = ref object of OpenApiRestCall_593437
proc url_OperationsList_593968(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593967(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all the available BotService operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593969 = query.getOrDefault("api-version")
  valid_593969 = validateParameter(valid_593969, JString, required = true,
                                 default = nil)
  if valid_593969 != nil:
    section.add "api-version", valid_593969
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593970: Call_OperationsList_593966; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available BotService operations.
  ## 
  let valid = call_593970.validator(path, query, header, formData, body)
  let scheme = call_593970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593970.url(scheme.get, call_593970.host, call_593970.base,
                         call_593970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593970, url, valid)

proc call*(call_593971: Call_OperationsList_593966; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all the available BotService operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var query_593972 = newJObject()
  add(query_593972, "api-version", newJString(apiVersion))
  result = call_593971.call(nil, query_593972, nil, nil, nil)

var operationsList* = Call_OperationsList_593966(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.BotService/operations",
    validator: validate_OperationsList_593967, base: "", url: url_OperationsList_593968,
    schemes: {Scheme.Https})
type
  Call_BotsList_593973 = ref object of OpenApiRestCall_593437
proc url_BotsList_593975(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.BotService/botServices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BotsList_593974(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_593990 = path.getOrDefault("subscriptionId")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "subscriptionId", valid_593990
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593991 = query.getOrDefault("api-version")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "api-version", valid_593991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593992: Call_BotsList_593973; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all the resources of a particular type belonging to a subscription.
  ## 
  let valid = call_593992.validator(path, query, header, formData, body)
  let scheme = call_593992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593992.url(scheme.get, call_593992.host, call_593992.base,
                         call_593992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593992, url, valid)

proc call*(call_593993: Call_BotsList_593973; apiVersion: string;
          subscriptionId: string): Recallable =
  ## botsList
  ## Returns all the resources of a particular type belonging to a subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_593994 = newJObject()
  var query_593995 = newJObject()
  add(query_593995, "api-version", newJString(apiVersion))
  add(path_593994, "subscriptionId", newJString(subscriptionId))
  result = call_593993.call(path_593994, query_593995, nil, nil, nil)

var botsList* = Call_BotsList_593973(name: "botsList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.BotService/botServices",
                                  validator: validate_BotsList_593974, base: "",
                                  url: url_BotsList_593975,
                                  schemes: {Scheme.Https})
type
  Call_BotConnectionListServiceProviders_593996 = ref object of OpenApiRestCall_593437
proc url_BotConnectionListServiceProviders_593998(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.BotService/listAuthServiceProviders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BotConnectionListServiceProviders_593997(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the available Service Providers for creating Connection Settings
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593999 = path.getOrDefault("subscriptionId")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "subscriptionId", valid_593999
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594000 = query.getOrDefault("api-version")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "api-version", valid_594000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594001: Call_BotConnectionListServiceProviders_593996;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the available Service Providers for creating Connection Settings
  ## 
  let valid = call_594001.validator(path, query, header, formData, body)
  let scheme = call_594001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594001.url(scheme.get, call_594001.host, call_594001.base,
                         call_594001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594001, url, valid)

proc call*(call_594002: Call_BotConnectionListServiceProviders_593996;
          apiVersion: string; subscriptionId: string): Recallable =
  ## botConnectionListServiceProviders
  ## Lists the available Service Providers for creating Connection Settings
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_594003 = newJObject()
  var query_594004 = newJObject()
  add(query_594004, "api-version", newJString(apiVersion))
  add(path_594003, "subscriptionId", newJString(subscriptionId))
  result = call_594002.call(path_594003, query_594004, nil, nil, nil)

var botConnectionListServiceProviders* = Call_BotConnectionListServiceProviders_593996(
    name: "botConnectionListServiceProviders", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.BotService/listAuthServiceProviders",
    validator: validate_BotConnectionListServiceProviders_593997, base: "",
    url: url_BotConnectionListServiceProviders_593998, schemes: {Scheme.Https})
type
  Call_BotsListByResourceGroup_594005 = ref object of OpenApiRestCall_593437
proc url_BotsListByResourceGroup_594007(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
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
        value: "/providers/Microsoft.BotService/botServices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BotsListByResourceGroup_594006(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns all the resources of a particular type belonging to a resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594008 = path.getOrDefault("resourceGroupName")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "resourceGroupName", valid_594008
  var valid_594009 = path.getOrDefault("subscriptionId")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "subscriptionId", valid_594009
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594010 = query.getOrDefault("api-version")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "api-version", valid_594010
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594011: Call_BotsListByResourceGroup_594005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all the resources of a particular type belonging to a resource group
  ## 
  let valid = call_594011.validator(path, query, header, formData, body)
  let scheme = call_594011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594011.url(scheme.get, call_594011.host, call_594011.base,
                         call_594011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594011, url, valid)

proc call*(call_594012: Call_BotsListByResourceGroup_594005;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## botsListByResourceGroup
  ## Returns all the resources of a particular type belonging to a resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_594013 = newJObject()
  var query_594014 = newJObject()
  add(path_594013, "resourceGroupName", newJString(resourceGroupName))
  add(query_594014, "api-version", newJString(apiVersion))
  add(path_594013, "subscriptionId", newJString(subscriptionId))
  result = call_594012.call(path_594013, query_594014, nil, nil, nil)

var botsListByResourceGroup* = Call_BotsListByResourceGroup_594005(
    name: "botsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices",
    validator: validate_BotsListByResourceGroup_594006, base: "",
    url: url_BotsListByResourceGroup_594007, schemes: {Scheme.Https})
type
  Call_BotsCreate_594026 = ref object of OpenApiRestCall_593437
proc url_BotsCreate_594028(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.BotService/botServices/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BotsCreate_594027(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a Bot Service. Bot Service is a resource group wide resource type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: JString (required)
  ##               : The name of the Bot resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594029 = path.getOrDefault("resourceGroupName")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "resourceGroupName", valid_594029
  var valid_594030 = path.getOrDefault("subscriptionId")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "subscriptionId", valid_594030
  var valid_594031 = path.getOrDefault("resourceName")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "resourceName", valid_594031
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594032 = query.getOrDefault("api-version")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "api-version", valid_594032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the created bot.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594034: Call_BotsCreate_594026; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Bot Service. Bot Service is a resource group wide resource type.
  ## 
  let valid = call_594034.validator(path, query, header, formData, body)
  let scheme = call_594034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594034.url(scheme.get, call_594034.host, call_594034.base,
                         call_594034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594034, url, valid)

proc call*(call_594035: Call_BotsCreate_594026; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          parameters: JsonNode): Recallable =
  ## botsCreate
  ## Creates a Bot Service. Bot Service is a resource group wide resource type.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the created bot.
  var path_594036 = newJObject()
  var query_594037 = newJObject()
  var body_594038 = newJObject()
  add(path_594036, "resourceGroupName", newJString(resourceGroupName))
  add(query_594037, "api-version", newJString(apiVersion))
  add(path_594036, "subscriptionId", newJString(subscriptionId))
  add(path_594036, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_594038 = parameters
  result = call_594035.call(path_594036, query_594037, nil, nil, body_594038)

var botsCreate* = Call_BotsCreate_594026(name: "botsCreate",
                                      meth: HttpMethod.HttpPut,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}",
                                      validator: validate_BotsCreate_594027,
                                      base: "", url: url_BotsCreate_594028,
                                      schemes: {Scheme.Https})
type
  Call_BotsGet_594015 = ref object of OpenApiRestCall_593437
proc url_BotsGet_594017(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.BotService/botServices/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BotsGet_594016(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a BotService specified by the parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: JString (required)
  ##               : The name of the Bot resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594018 = path.getOrDefault("resourceGroupName")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "resourceGroupName", valid_594018
  var valid_594019 = path.getOrDefault("subscriptionId")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "subscriptionId", valid_594019
  var valid_594020 = path.getOrDefault("resourceName")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "resourceName", valid_594020
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594021 = query.getOrDefault("api-version")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "api-version", valid_594021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594022: Call_BotsGet_594015; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a BotService specified by the parameters.
  ## 
  let valid = call_594022.validator(path, query, header, formData, body)
  let scheme = call_594022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594022.url(scheme.get, call_594022.host, call_594022.base,
                         call_594022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594022, url, valid)

proc call*(call_594023: Call_BotsGet_594015; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string): Recallable =
  ## botsGet
  ## Returns a BotService specified by the parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  var path_594024 = newJObject()
  var query_594025 = newJObject()
  add(path_594024, "resourceGroupName", newJString(resourceGroupName))
  add(query_594025, "api-version", newJString(apiVersion))
  add(path_594024, "subscriptionId", newJString(subscriptionId))
  add(path_594024, "resourceName", newJString(resourceName))
  result = call_594023.call(path_594024, query_594025, nil, nil, nil)

var botsGet* = Call_BotsGet_594015(name: "botsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}",
                                validator: validate_BotsGet_594016, base: "",
                                url: url_BotsGet_594017, schemes: {Scheme.Https})
type
  Call_BotsUpdate_594050 = ref object of OpenApiRestCall_593437
proc url_BotsUpdate_594052(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.BotService/botServices/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BotsUpdate_594051(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a Bot Service
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: JString (required)
  ##               : The name of the Bot resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594053 = path.getOrDefault("resourceGroupName")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "resourceGroupName", valid_594053
  var valid_594054 = path.getOrDefault("subscriptionId")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "subscriptionId", valid_594054
  var valid_594055 = path.getOrDefault("resourceName")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "resourceName", valid_594055
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594056 = query.getOrDefault("api-version")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "api-version", valid_594056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the created bot.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594058: Call_BotsUpdate_594050; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Bot Service
  ## 
  let valid = call_594058.validator(path, query, header, formData, body)
  let scheme = call_594058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594058.url(scheme.get, call_594058.host, call_594058.base,
                         call_594058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594058, url, valid)

proc call*(call_594059: Call_BotsUpdate_594050; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          parameters: JsonNode): Recallable =
  ## botsUpdate
  ## Updates a Bot Service
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the created bot.
  var path_594060 = newJObject()
  var query_594061 = newJObject()
  var body_594062 = newJObject()
  add(path_594060, "resourceGroupName", newJString(resourceGroupName))
  add(query_594061, "api-version", newJString(apiVersion))
  add(path_594060, "subscriptionId", newJString(subscriptionId))
  add(path_594060, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_594062 = parameters
  result = call_594059.call(path_594060, query_594061, nil, nil, body_594062)

var botsUpdate* = Call_BotsUpdate_594050(name: "botsUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}",
                                      validator: validate_BotsUpdate_594051,
                                      base: "", url: url_BotsUpdate_594052,
                                      schemes: {Scheme.Https})
type
  Call_BotsDelete_594039 = ref object of OpenApiRestCall_593437
proc url_BotsDelete_594041(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.BotService/botServices/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BotsDelete_594040(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a Bot Service from the resource group. 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: JString (required)
  ##               : The name of the Bot resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594042 = path.getOrDefault("resourceGroupName")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "resourceGroupName", valid_594042
  var valid_594043 = path.getOrDefault("subscriptionId")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "subscriptionId", valid_594043
  var valid_594044 = path.getOrDefault("resourceName")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "resourceName", valid_594044
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594045 = query.getOrDefault("api-version")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "api-version", valid_594045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594046: Call_BotsDelete_594039; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Bot Service from the resource group. 
  ## 
  let valid = call_594046.validator(path, query, header, formData, body)
  let scheme = call_594046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594046.url(scheme.get, call_594046.host, call_594046.base,
                         call_594046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594046, url, valid)

proc call*(call_594047: Call_BotsDelete_594039; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string): Recallable =
  ## botsDelete
  ## Deletes a Bot Service from the resource group. 
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  var path_594048 = newJObject()
  var query_594049 = newJObject()
  add(path_594048, "resourceGroupName", newJString(resourceGroupName))
  add(query_594049, "api-version", newJString(apiVersion))
  add(path_594048, "subscriptionId", newJString(subscriptionId))
  add(path_594048, "resourceName", newJString(resourceName))
  result = call_594047.call(path_594048, query_594049, nil, nil, nil)

var botsDelete* = Call_BotsDelete_594039(name: "botsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}",
                                      validator: validate_BotsDelete_594040,
                                      base: "", url: url_BotsDelete_594041,
                                      schemes: {Scheme.Https})
type
  Call_BotConnectionCreate_594075 = ref object of OpenApiRestCall_593437
proc url_BotConnectionCreate_594077(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "connectionName" in path, "`connectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.BotService/botServices/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/Connections/"),
               (kind: VariableSegment, value: "connectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BotConnectionCreate_594076(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Register a new Auth Connection for a Bot Service
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: JString (required)
  ##               : The name of the Bot resource.
  ##   connectionName: JString (required)
  ##                 : The name of the Bot Service Connection Setting resource
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594078 = path.getOrDefault("resourceGroupName")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "resourceGroupName", valid_594078
  var valid_594079 = path.getOrDefault("subscriptionId")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "subscriptionId", valid_594079
  var valid_594080 = path.getOrDefault("resourceName")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "resourceName", valid_594080
  var valid_594081 = path.getOrDefault("connectionName")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "connectionName", valid_594081
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594082 = query.getOrDefault("api-version")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "api-version", valid_594082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to provide for creating the Connection Setting.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594084: Call_BotConnectionCreate_594075; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Register a new Auth Connection for a Bot Service
  ## 
  let valid = call_594084.validator(path, query, header, formData, body)
  let scheme = call_594084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594084.url(scheme.get, call_594084.host, call_594084.base,
                         call_594084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594084, url, valid)

proc call*(call_594085: Call_BotConnectionCreate_594075; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          parameters: JsonNode; connectionName: string): Recallable =
  ## botConnectionCreate
  ## Register a new Auth Connection for a Bot Service
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  ##   parameters: JObject (required)
  ##             : The parameters to provide for creating the Connection Setting.
  ##   connectionName: string (required)
  ##                 : The name of the Bot Service Connection Setting resource
  var path_594086 = newJObject()
  var query_594087 = newJObject()
  var body_594088 = newJObject()
  add(path_594086, "resourceGroupName", newJString(resourceGroupName))
  add(query_594087, "api-version", newJString(apiVersion))
  add(path_594086, "subscriptionId", newJString(subscriptionId))
  add(path_594086, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_594088 = parameters
  add(path_594086, "connectionName", newJString(connectionName))
  result = call_594085.call(path_594086, query_594087, nil, nil, body_594088)

var botConnectionCreate* = Call_BotConnectionCreate_594075(
    name: "botConnectionCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/Connections/{connectionName}",
    validator: validate_BotConnectionCreate_594076, base: "",
    url: url_BotConnectionCreate_594077, schemes: {Scheme.Https})
type
  Call_BotConnectionGet_594063 = ref object of OpenApiRestCall_593437
proc url_BotConnectionGet_594065(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "connectionName" in path, "`connectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.BotService/botServices/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/Connections/"),
               (kind: VariableSegment, value: "connectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BotConnectionGet_594064(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get a Connection Setting registration for a Bot Service
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: JString (required)
  ##               : The name of the Bot resource.
  ##   connectionName: JString (required)
  ##                 : The name of the Bot Service Connection Setting resource
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594066 = path.getOrDefault("resourceGroupName")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "resourceGroupName", valid_594066
  var valid_594067 = path.getOrDefault("subscriptionId")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "subscriptionId", valid_594067
  var valid_594068 = path.getOrDefault("resourceName")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "resourceName", valid_594068
  var valid_594069 = path.getOrDefault("connectionName")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "connectionName", valid_594069
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594070 = query.getOrDefault("api-version")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "api-version", valid_594070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594071: Call_BotConnectionGet_594063; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Connection Setting registration for a Bot Service
  ## 
  let valid = call_594071.validator(path, query, header, formData, body)
  let scheme = call_594071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594071.url(scheme.get, call_594071.host, call_594071.base,
                         call_594071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594071, url, valid)

proc call*(call_594072: Call_BotConnectionGet_594063; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          connectionName: string): Recallable =
  ## botConnectionGet
  ## Get a Connection Setting registration for a Bot Service
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  ##   connectionName: string (required)
  ##                 : The name of the Bot Service Connection Setting resource
  var path_594073 = newJObject()
  var query_594074 = newJObject()
  add(path_594073, "resourceGroupName", newJString(resourceGroupName))
  add(query_594074, "api-version", newJString(apiVersion))
  add(path_594073, "subscriptionId", newJString(subscriptionId))
  add(path_594073, "resourceName", newJString(resourceName))
  add(path_594073, "connectionName", newJString(connectionName))
  result = call_594072.call(path_594073, query_594074, nil, nil, nil)

var botConnectionGet* = Call_BotConnectionGet_594063(name: "botConnectionGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/Connections/{connectionName}",
    validator: validate_BotConnectionGet_594064, base: "",
    url: url_BotConnectionGet_594065, schemes: {Scheme.Https})
type
  Call_BotConnectionUpdate_594101 = ref object of OpenApiRestCall_593437
proc url_BotConnectionUpdate_594103(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "connectionName" in path, "`connectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.BotService/botServices/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/Connections/"),
               (kind: VariableSegment, value: "connectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BotConnectionUpdate_594102(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates a Connection Setting registration for a Bot Service
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: JString (required)
  ##               : The name of the Bot resource.
  ##   connectionName: JString (required)
  ##                 : The name of the Bot Service Connection Setting resource
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594104 = path.getOrDefault("resourceGroupName")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "resourceGroupName", valid_594104
  var valid_594105 = path.getOrDefault("subscriptionId")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "subscriptionId", valid_594105
  var valid_594106 = path.getOrDefault("resourceName")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "resourceName", valid_594106
  var valid_594107 = path.getOrDefault("connectionName")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "connectionName", valid_594107
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594108 = query.getOrDefault("api-version")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "api-version", valid_594108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to provide for updating the Connection Setting.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594110: Call_BotConnectionUpdate_594101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Connection Setting registration for a Bot Service
  ## 
  let valid = call_594110.validator(path, query, header, formData, body)
  let scheme = call_594110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594110.url(scheme.get, call_594110.host, call_594110.base,
                         call_594110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594110, url, valid)

proc call*(call_594111: Call_BotConnectionUpdate_594101; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          parameters: JsonNode; connectionName: string): Recallable =
  ## botConnectionUpdate
  ## Updates a Connection Setting registration for a Bot Service
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  ##   parameters: JObject (required)
  ##             : The parameters to provide for updating the Connection Setting.
  ##   connectionName: string (required)
  ##                 : The name of the Bot Service Connection Setting resource
  var path_594112 = newJObject()
  var query_594113 = newJObject()
  var body_594114 = newJObject()
  add(path_594112, "resourceGroupName", newJString(resourceGroupName))
  add(query_594113, "api-version", newJString(apiVersion))
  add(path_594112, "subscriptionId", newJString(subscriptionId))
  add(path_594112, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_594114 = parameters
  add(path_594112, "connectionName", newJString(connectionName))
  result = call_594111.call(path_594112, query_594113, nil, nil, body_594114)

var botConnectionUpdate* = Call_BotConnectionUpdate_594101(
    name: "botConnectionUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/Connections/{connectionName}",
    validator: validate_BotConnectionUpdate_594102, base: "",
    url: url_BotConnectionUpdate_594103, schemes: {Scheme.Https})
type
  Call_BotConnectionDelete_594089 = ref object of OpenApiRestCall_593437
proc url_BotConnectionDelete_594091(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "connectionName" in path, "`connectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.BotService/botServices/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/Connections/"),
               (kind: VariableSegment, value: "connectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BotConnectionDelete_594090(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes a Connection Setting registration for a Bot Service
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: JString (required)
  ##               : The name of the Bot resource.
  ##   connectionName: JString (required)
  ##                 : The name of the Bot Service Connection Setting resource
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594092 = path.getOrDefault("resourceGroupName")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "resourceGroupName", valid_594092
  var valid_594093 = path.getOrDefault("subscriptionId")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "subscriptionId", valid_594093
  var valid_594094 = path.getOrDefault("resourceName")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "resourceName", valid_594094
  var valid_594095 = path.getOrDefault("connectionName")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "connectionName", valid_594095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594096 = query.getOrDefault("api-version")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "api-version", valid_594096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594097: Call_BotConnectionDelete_594089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Connection Setting registration for a Bot Service
  ## 
  let valid = call_594097.validator(path, query, header, formData, body)
  let scheme = call_594097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594097.url(scheme.get, call_594097.host, call_594097.base,
                         call_594097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594097, url, valid)

proc call*(call_594098: Call_BotConnectionDelete_594089; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          connectionName: string): Recallable =
  ## botConnectionDelete
  ## Deletes a Connection Setting registration for a Bot Service
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  ##   connectionName: string (required)
  ##                 : The name of the Bot Service Connection Setting resource
  var path_594099 = newJObject()
  var query_594100 = newJObject()
  add(path_594099, "resourceGroupName", newJString(resourceGroupName))
  add(query_594100, "api-version", newJString(apiVersion))
  add(path_594099, "subscriptionId", newJString(subscriptionId))
  add(path_594099, "resourceName", newJString(resourceName))
  add(path_594099, "connectionName", newJString(connectionName))
  result = call_594098.call(path_594099, query_594100, nil, nil, nil)

var botConnectionDelete* = Call_BotConnectionDelete_594089(
    name: "botConnectionDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/Connections/{connectionName}",
    validator: validate_BotConnectionDelete_594090, base: "",
    url: url_BotConnectionDelete_594091, schemes: {Scheme.Https})
type
  Call_BotConnectionListWithSecrets_594115 = ref object of OpenApiRestCall_593437
proc url_BotConnectionListWithSecrets_594117(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "connectionName" in path, "`connectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.BotService/botServices/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/Connections/"),
               (kind: VariableSegment, value: "connectionName"),
               (kind: ConstantSegment, value: "/listWithSecrets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BotConnectionListWithSecrets_594116(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a Connection Setting registration for a Bot Service
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: JString (required)
  ##               : The name of the Bot resource.
  ##   connectionName: JString (required)
  ##                 : The name of the Bot Service Connection Setting resource
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594118 = path.getOrDefault("resourceGroupName")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "resourceGroupName", valid_594118
  var valid_594119 = path.getOrDefault("subscriptionId")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = nil)
  if valid_594119 != nil:
    section.add "subscriptionId", valid_594119
  var valid_594120 = path.getOrDefault("resourceName")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "resourceName", valid_594120
  var valid_594121 = path.getOrDefault("connectionName")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "connectionName", valid_594121
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594122 = query.getOrDefault("api-version")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "api-version", valid_594122
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594123: Call_BotConnectionListWithSecrets_594115; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Connection Setting registration for a Bot Service
  ## 
  let valid = call_594123.validator(path, query, header, formData, body)
  let scheme = call_594123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594123.url(scheme.get, call_594123.host, call_594123.base,
                         call_594123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594123, url, valid)

proc call*(call_594124: Call_BotConnectionListWithSecrets_594115;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; connectionName: string): Recallable =
  ## botConnectionListWithSecrets
  ## Get a Connection Setting registration for a Bot Service
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  ##   connectionName: string (required)
  ##                 : The name of the Bot Service Connection Setting resource
  var path_594125 = newJObject()
  var query_594126 = newJObject()
  add(path_594125, "resourceGroupName", newJString(resourceGroupName))
  add(query_594126, "api-version", newJString(apiVersion))
  add(path_594125, "subscriptionId", newJString(subscriptionId))
  add(path_594125, "resourceName", newJString(resourceName))
  add(path_594125, "connectionName", newJString(connectionName))
  result = call_594124.call(path_594125, query_594126, nil, nil, nil)

var botConnectionListWithSecrets* = Call_BotConnectionListWithSecrets_594115(
    name: "botConnectionListWithSecrets", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/Connections/{connectionName}/listWithSecrets",
    validator: validate_BotConnectionListWithSecrets_594116, base: "",
    url: url_BotConnectionListWithSecrets_594117, schemes: {Scheme.Https})
type
  Call_ChannelsListByResourceGroup_594127 = ref object of OpenApiRestCall_593437
proc url_ChannelsListByResourceGroup_594129(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.BotService/botServices/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/channels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChannelsListByResourceGroup_594128(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns all the Channel registrations of a particular BotService resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: JString (required)
  ##               : The name of the Bot resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594130 = path.getOrDefault("resourceGroupName")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "resourceGroupName", valid_594130
  var valid_594131 = path.getOrDefault("subscriptionId")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "subscriptionId", valid_594131
  var valid_594132 = path.getOrDefault("resourceName")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "resourceName", valid_594132
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594133 = query.getOrDefault("api-version")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "api-version", valid_594133
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594134: Call_ChannelsListByResourceGroup_594127; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all the Channel registrations of a particular BotService resource
  ## 
  let valid = call_594134.validator(path, query, header, formData, body)
  let scheme = call_594134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594134.url(scheme.get, call_594134.host, call_594134.base,
                         call_594134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594134, url, valid)

proc call*(call_594135: Call_ChannelsListByResourceGroup_594127;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## channelsListByResourceGroup
  ## Returns all the Channel registrations of a particular BotService resource
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  var path_594136 = newJObject()
  var query_594137 = newJObject()
  add(path_594136, "resourceGroupName", newJString(resourceGroupName))
  add(query_594137, "api-version", newJString(apiVersion))
  add(path_594136, "subscriptionId", newJString(subscriptionId))
  add(path_594136, "resourceName", newJString(resourceName))
  result = call_594135.call(path_594136, query_594137, nil, nil, nil)

var channelsListByResourceGroup* = Call_ChannelsListByResourceGroup_594127(
    name: "channelsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/channels",
    validator: validate_ChannelsListByResourceGroup_594128, base: "",
    url: url_ChannelsListByResourceGroup_594129, schemes: {Scheme.Https})
type
  Call_ChannelsCreate_594150 = ref object of OpenApiRestCall_593437
proc url_ChannelsCreate_594152(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "channelName" in path, "`channelName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.BotService/botServices/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/channels/"),
               (kind: VariableSegment, value: "channelName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChannelsCreate_594151(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Creates a Channel registration for a Bot Service
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   channelName: JString (required)
  ##              : The name of the Channel resource.
  ##   resourceName: JString (required)
  ##               : The name of the Bot resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594153 = path.getOrDefault("resourceGroupName")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "resourceGroupName", valid_594153
  var valid_594154 = path.getOrDefault("subscriptionId")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "subscriptionId", valid_594154
  var valid_594168 = path.getOrDefault("channelName")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = newJString("FacebookChannel"))
  if valid_594168 != nil:
    section.add "channelName", valid_594168
  var valid_594169 = path.getOrDefault("resourceName")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "resourceName", valid_594169
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the created bot.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594172: Call_ChannelsCreate_594150; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Channel registration for a Bot Service
  ## 
  let valid = call_594172.validator(path, query, header, formData, body)
  let scheme = call_594172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594172.url(scheme.get, call_594172.host, call_594172.base,
                         call_594172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594172, url, valid)

proc call*(call_594173: Call_ChannelsCreate_594150; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          parameters: JsonNode; channelName: string = "FacebookChannel"): Recallable =
  ## channelsCreate
  ## Creates a Channel registration for a Bot Service
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   channelName: string (required)
  ##              : The name of the Channel resource.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the created bot.
  var path_594174 = newJObject()
  var query_594175 = newJObject()
  var body_594176 = newJObject()
  add(path_594174, "resourceGroupName", newJString(resourceGroupName))
  add(query_594175, "api-version", newJString(apiVersion))
  add(path_594174, "subscriptionId", newJString(subscriptionId))
  add(path_594174, "channelName", newJString(channelName))
  add(path_594174, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_594176 = parameters
  result = call_594173.call(path_594174, query_594175, nil, nil, body_594176)

var channelsCreate* = Call_ChannelsCreate_594150(name: "channelsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/channels/{channelName}",
    validator: validate_ChannelsCreate_594151, base: "", url: url_ChannelsCreate_594152,
    schemes: {Scheme.Https})
type
  Call_ChannelsGet_594138 = ref object of OpenApiRestCall_593437
proc url_ChannelsGet_594140(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "channelName" in path, "`channelName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.BotService/botServices/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/channels/"),
               (kind: VariableSegment, value: "channelName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChannelsGet_594139(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a BotService Channel registration specified by the parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   channelName: JString (required)
  ##              : The name of the Bot resource.
  ##   resourceName: JString (required)
  ##               : The name of the Bot resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594141 = path.getOrDefault("resourceGroupName")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "resourceGroupName", valid_594141
  var valid_594142 = path.getOrDefault("subscriptionId")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "subscriptionId", valid_594142
  var valid_594143 = path.getOrDefault("channelName")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "channelName", valid_594143
  var valid_594144 = path.getOrDefault("resourceName")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "resourceName", valid_594144
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594145 = query.getOrDefault("api-version")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "api-version", valid_594145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594146: Call_ChannelsGet_594138; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a BotService Channel registration specified by the parameters.
  ## 
  let valid = call_594146.validator(path, query, header, formData, body)
  let scheme = call_594146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594146.url(scheme.get, call_594146.host, call_594146.base,
                         call_594146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594146, url, valid)

proc call*(call_594147: Call_ChannelsGet_594138; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; channelName: string;
          resourceName: string): Recallable =
  ## channelsGet
  ## Returns a BotService Channel registration specified by the parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   channelName: string (required)
  ##              : The name of the Bot resource.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  var path_594148 = newJObject()
  var query_594149 = newJObject()
  add(path_594148, "resourceGroupName", newJString(resourceGroupName))
  add(query_594149, "api-version", newJString(apiVersion))
  add(path_594148, "subscriptionId", newJString(subscriptionId))
  add(path_594148, "channelName", newJString(channelName))
  add(path_594148, "resourceName", newJString(resourceName))
  result = call_594147.call(path_594148, query_594149, nil, nil, nil)

var channelsGet* = Call_ChannelsGet_594138(name: "channelsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/channels/{channelName}",
                                        validator: validate_ChannelsGet_594139,
                                        base: "", url: url_ChannelsGet_594140,
                                        schemes: {Scheme.Https})
type
  Call_ChannelsUpdate_594189 = ref object of OpenApiRestCall_593437
proc url_ChannelsUpdate_594191(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "channelName" in path, "`channelName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.BotService/botServices/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/channels/"),
               (kind: VariableSegment, value: "channelName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChannelsUpdate_594190(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates a Channel registration for a Bot Service
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   channelName: JString (required)
  ##              : The name of the Channel resource.
  ##   resourceName: JString (required)
  ##               : The name of the Bot resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594192 = path.getOrDefault("resourceGroupName")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "resourceGroupName", valid_594192
  var valid_594193 = path.getOrDefault("subscriptionId")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "subscriptionId", valid_594193
  var valid_594194 = path.getOrDefault("channelName")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = newJString("FacebookChannel"))
  if valid_594194 != nil:
    section.add "channelName", valid_594194
  var valid_594195 = path.getOrDefault("resourceName")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "resourceName", valid_594195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
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
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the created bot.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594198: Call_ChannelsUpdate_594189; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Channel registration for a Bot Service
  ## 
  let valid = call_594198.validator(path, query, header, formData, body)
  let scheme = call_594198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594198.url(scheme.get, call_594198.host, call_594198.base,
                         call_594198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594198, url, valid)

proc call*(call_594199: Call_ChannelsUpdate_594189; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          parameters: JsonNode; channelName: string = "FacebookChannel"): Recallable =
  ## channelsUpdate
  ## Updates a Channel registration for a Bot Service
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   channelName: string (required)
  ##              : The name of the Channel resource.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the created bot.
  var path_594200 = newJObject()
  var query_594201 = newJObject()
  var body_594202 = newJObject()
  add(path_594200, "resourceGroupName", newJString(resourceGroupName))
  add(query_594201, "api-version", newJString(apiVersion))
  add(path_594200, "subscriptionId", newJString(subscriptionId))
  add(path_594200, "channelName", newJString(channelName))
  add(path_594200, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_594202 = parameters
  result = call_594199.call(path_594200, query_594201, nil, nil, body_594202)

var channelsUpdate* = Call_ChannelsUpdate_594189(name: "channelsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/channels/{channelName}",
    validator: validate_ChannelsUpdate_594190, base: "", url: url_ChannelsUpdate_594191,
    schemes: {Scheme.Https})
type
  Call_ChannelsDelete_594177 = ref object of OpenApiRestCall_593437
proc url_ChannelsDelete_594179(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "channelName" in path, "`channelName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.BotService/botServices/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/channels/"),
               (kind: VariableSegment, value: "channelName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChannelsDelete_594178(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a Channel registration from a Bot Service
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   channelName: JString (required)
  ##              : The name of the Bot resource.
  ##   resourceName: JString (required)
  ##               : The name of the Bot resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594180 = path.getOrDefault("resourceGroupName")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "resourceGroupName", valid_594180
  var valid_594181 = path.getOrDefault("subscriptionId")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "subscriptionId", valid_594181
  var valid_594182 = path.getOrDefault("channelName")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "channelName", valid_594182
  var valid_594183 = path.getOrDefault("resourceName")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "resourceName", valid_594183
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594184 = query.getOrDefault("api-version")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "api-version", valid_594184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594185: Call_ChannelsDelete_594177; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Channel registration from a Bot Service
  ## 
  let valid = call_594185.validator(path, query, header, formData, body)
  let scheme = call_594185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594185.url(scheme.get, call_594185.host, call_594185.base,
                         call_594185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594185, url, valid)

proc call*(call_594186: Call_ChannelsDelete_594177; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; channelName: string;
          resourceName: string): Recallable =
  ## channelsDelete
  ## Deletes a Channel registration from a Bot Service
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   channelName: string (required)
  ##              : The name of the Bot resource.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  var path_594187 = newJObject()
  var query_594188 = newJObject()
  add(path_594187, "resourceGroupName", newJString(resourceGroupName))
  add(query_594188, "api-version", newJString(apiVersion))
  add(path_594187, "subscriptionId", newJString(subscriptionId))
  add(path_594187, "channelName", newJString(channelName))
  add(path_594187, "resourceName", newJString(resourceName))
  result = call_594186.call(path_594187, query_594188, nil, nil, nil)

var channelsDelete* = Call_ChannelsDelete_594177(name: "channelsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/channels/{channelName}",
    validator: validate_ChannelsDelete_594178, base: "", url: url_ChannelsDelete_594179,
    schemes: {Scheme.Https})
type
  Call_ChannelsListWithKeys_594203 = ref object of OpenApiRestCall_593437
proc url_ChannelsListWithKeys_594205(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "channelName" in path, "`channelName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.BotService/botServices/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/channels/"),
               (kind: VariableSegment, value: "channelName"),
               (kind: ConstantSegment, value: "/listChannelWithKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChannelsListWithKeys_594204(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a Channel registration for a Bot Service including secrets
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   channelName: JString (required)
  ##              : The name of the Channel resource.
  ##   resourceName: JString (required)
  ##               : The name of the Bot resource.
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
  var valid_594208 = path.getOrDefault("channelName")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = newJString("FacebookChannel"))
  if valid_594208 != nil:
    section.add "channelName", valid_594208
  var valid_594209 = path.getOrDefault("resourceName")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = nil)
  if valid_594209 != nil:
    section.add "resourceName", valid_594209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594210 = query.getOrDefault("api-version")
  valid_594210 = validateParameter(valid_594210, JString, required = true,
                                 default = nil)
  if valid_594210 != nil:
    section.add "api-version", valid_594210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594211: Call_ChannelsListWithKeys_594203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a Channel registration for a Bot Service including secrets
  ## 
  let valid = call_594211.validator(path, query, header, formData, body)
  let scheme = call_594211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594211.url(scheme.get, call_594211.host, call_594211.base,
                         call_594211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594211, url, valid)

proc call*(call_594212: Call_ChannelsListWithKeys_594203;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; channelName: string = "FacebookChannel"): Recallable =
  ## channelsListWithKeys
  ## Lists a Channel registration for a Bot Service including secrets
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   channelName: string (required)
  ##              : The name of the Channel resource.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  var path_594213 = newJObject()
  var query_594214 = newJObject()
  add(path_594213, "resourceGroupName", newJString(resourceGroupName))
  add(query_594214, "api-version", newJString(apiVersion))
  add(path_594213, "subscriptionId", newJString(subscriptionId))
  add(path_594213, "channelName", newJString(channelName))
  add(path_594213, "resourceName", newJString(resourceName))
  result = call_594212.call(path_594213, query_594214, nil, nil, nil)

var channelsListWithKeys* = Call_ChannelsListWithKeys_594203(
    name: "channelsListWithKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/channels/{channelName}/listChannelWithKeys",
    validator: validate_ChannelsListWithKeys_594204, base: "",
    url: url_ChannelsListWithKeys_594205, schemes: {Scheme.Https})
type
  Call_BotConnectionListByBotService_594215 = ref object of OpenApiRestCall_593437
proc url_BotConnectionListByBotService_594217(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.BotService/botServices/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/connections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BotConnectionListByBotService_594216(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns all the Connection Settings registered to a particular BotService resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: JString (required)
  ##               : The name of the Bot resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594218 = path.getOrDefault("resourceGroupName")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "resourceGroupName", valid_594218
  var valid_594219 = path.getOrDefault("subscriptionId")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = nil)
  if valid_594219 != nil:
    section.add "subscriptionId", valid_594219
  var valid_594220 = path.getOrDefault("resourceName")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "resourceName", valid_594220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
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

proc call*(call_594222: Call_BotConnectionListByBotService_594215; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all the Connection Settings registered to a particular BotService resource
  ## 
  let valid = call_594222.validator(path, query, header, formData, body)
  let scheme = call_594222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594222.url(scheme.get, call_594222.host, call_594222.base,
                         call_594222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594222, url, valid)

proc call*(call_594223: Call_BotConnectionListByBotService_594215;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## botConnectionListByBotService
  ## Returns all the Connection Settings registered to a particular BotService resource
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  var path_594224 = newJObject()
  var query_594225 = newJObject()
  add(path_594224, "resourceGroupName", newJString(resourceGroupName))
  add(query_594225, "api-version", newJString(apiVersion))
  add(path_594224, "subscriptionId", newJString(subscriptionId))
  add(path_594224, "resourceName", newJString(resourceName))
  result = call_594223.call(path_594224, query_594225, nil, nil, nil)

var botConnectionListByBotService* = Call_BotConnectionListByBotService_594215(
    name: "botConnectionListByBotService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/connections",
    validator: validate_BotConnectionListByBotService_594216, base: "",
    url: url_BotConnectionListByBotService_594217, schemes: {Scheme.Https})
type
  Call_EnterpriseChannelsListByResourceGroup_594226 = ref object of OpenApiRestCall_593437
proc url_EnterpriseChannelsListByResourceGroup_594228(protocol: Scheme;
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
        value: "/providers/Microsoft.BotService/enterpriseChannels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnterpriseChannelsListByResourceGroup_594227(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns all the resources of a particular type belonging to a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594231 = query.getOrDefault("api-version")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "api-version", valid_594231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594232: Call_EnterpriseChannelsListByResourceGroup_594226;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns all the resources of a particular type belonging to a resource group.
  ## 
  let valid = call_594232.validator(path, query, header, formData, body)
  let scheme = call_594232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594232.url(scheme.get, call_594232.host, call_594232.base,
                         call_594232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594232, url, valid)

proc call*(call_594233: Call_EnterpriseChannelsListByResourceGroup_594226;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## enterpriseChannelsListByResourceGroup
  ## Returns all the resources of a particular type belonging to a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_594234 = newJObject()
  var query_594235 = newJObject()
  add(path_594234, "resourceGroupName", newJString(resourceGroupName))
  add(query_594235, "api-version", newJString(apiVersion))
  add(path_594234, "subscriptionId", newJString(subscriptionId))
  result = call_594233.call(path_594234, query_594235, nil, nil, nil)

var enterpriseChannelsListByResourceGroup* = Call_EnterpriseChannelsListByResourceGroup_594226(
    name: "enterpriseChannelsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/enterpriseChannels",
    validator: validate_EnterpriseChannelsListByResourceGroup_594227, base: "",
    url: url_EnterpriseChannelsListByResourceGroup_594228, schemes: {Scheme.Https})
type
  Call_EnterpriseChannelsCreate_594247 = ref object of OpenApiRestCall_593437
proc url_EnterpriseChannelsCreate_594249(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.BotService/enterpriseChannels/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnterpriseChannelsCreate_594248(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an Enterprise Channel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: JString (required)
  ##               : The name of the Bot resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594250 = path.getOrDefault("resourceGroupName")
  valid_594250 = validateParameter(valid_594250, JString, required = true,
                                 default = nil)
  if valid_594250 != nil:
    section.add "resourceGroupName", valid_594250
  var valid_594251 = path.getOrDefault("subscriptionId")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = nil)
  if valid_594251 != nil:
    section.add "subscriptionId", valid_594251
  var valid_594252 = path.getOrDefault("resourceName")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = nil)
  if valid_594252 != nil:
    section.add "resourceName", valid_594252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594253 = query.getOrDefault("api-version")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = nil)
  if valid_594253 != nil:
    section.add "api-version", valid_594253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the new Enterprise Channel.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594255: Call_EnterpriseChannelsCreate_594247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an Enterprise Channel.
  ## 
  let valid = call_594255.validator(path, query, header, formData, body)
  let scheme = call_594255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594255.url(scheme.get, call_594255.host, call_594255.base,
                         call_594255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594255, url, valid)

proc call*(call_594256: Call_EnterpriseChannelsCreate_594247;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; parameters: JsonNode): Recallable =
  ## enterpriseChannelsCreate
  ## Creates an Enterprise Channel.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the new Enterprise Channel.
  var path_594257 = newJObject()
  var query_594258 = newJObject()
  var body_594259 = newJObject()
  add(path_594257, "resourceGroupName", newJString(resourceGroupName))
  add(query_594258, "api-version", newJString(apiVersion))
  add(path_594257, "subscriptionId", newJString(subscriptionId))
  add(path_594257, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_594259 = parameters
  result = call_594256.call(path_594257, query_594258, nil, nil, body_594259)

var enterpriseChannelsCreate* = Call_EnterpriseChannelsCreate_594247(
    name: "enterpriseChannelsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/enterpriseChannels/{resourceName}",
    validator: validate_EnterpriseChannelsCreate_594248, base: "",
    url: url_EnterpriseChannelsCreate_594249, schemes: {Scheme.Https})
type
  Call_EnterpriseChannelsGet_594236 = ref object of OpenApiRestCall_593437
proc url_EnterpriseChannelsGet_594238(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.BotService/enterpriseChannels/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnterpriseChannelsGet_594237(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns an Enterprise Channel specified by the parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: JString (required)
  ##               : The name of the Bot resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594239 = path.getOrDefault("resourceGroupName")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "resourceGroupName", valid_594239
  var valid_594240 = path.getOrDefault("subscriptionId")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "subscriptionId", valid_594240
  var valid_594241 = path.getOrDefault("resourceName")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "resourceName", valid_594241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594242 = query.getOrDefault("api-version")
  valid_594242 = validateParameter(valid_594242, JString, required = true,
                                 default = nil)
  if valid_594242 != nil:
    section.add "api-version", valid_594242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594243: Call_EnterpriseChannelsGet_594236; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns an Enterprise Channel specified by the parameters.
  ## 
  let valid = call_594243.validator(path, query, header, formData, body)
  let scheme = call_594243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594243.url(scheme.get, call_594243.host, call_594243.base,
                         call_594243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594243, url, valid)

proc call*(call_594244: Call_EnterpriseChannelsGet_594236;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## enterpriseChannelsGet
  ## Returns an Enterprise Channel specified by the parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  var path_594245 = newJObject()
  var query_594246 = newJObject()
  add(path_594245, "resourceGroupName", newJString(resourceGroupName))
  add(query_594246, "api-version", newJString(apiVersion))
  add(path_594245, "subscriptionId", newJString(subscriptionId))
  add(path_594245, "resourceName", newJString(resourceName))
  result = call_594244.call(path_594245, query_594246, nil, nil, nil)

var enterpriseChannelsGet* = Call_EnterpriseChannelsGet_594236(
    name: "enterpriseChannelsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/enterpriseChannels/{resourceName}",
    validator: validate_EnterpriseChannelsGet_594237, base: "",
    url: url_EnterpriseChannelsGet_594238, schemes: {Scheme.Https})
type
  Call_EnterpriseChannelsUpdate_594271 = ref object of OpenApiRestCall_593437
proc url_EnterpriseChannelsUpdate_594273(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.BotService/enterpriseChannels/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnterpriseChannelsUpdate_594272(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an Enterprise Channel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: JString (required)
  ##               : The name of the Bot resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594274 = path.getOrDefault("resourceGroupName")
  valid_594274 = validateParameter(valid_594274, JString, required = true,
                                 default = nil)
  if valid_594274 != nil:
    section.add "resourceGroupName", valid_594274
  var valid_594275 = path.getOrDefault("subscriptionId")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "subscriptionId", valid_594275
  var valid_594276 = path.getOrDefault("resourceName")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "resourceName", valid_594276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594277 = query.getOrDefault("api-version")
  valid_594277 = validateParameter(valid_594277, JString, required = true,
                                 default = nil)
  if valid_594277 != nil:
    section.add "api-version", valid_594277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to provide to update the Enterprise Channel.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594279: Call_EnterpriseChannelsUpdate_594271; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an Enterprise Channel.
  ## 
  let valid = call_594279.validator(path, query, header, formData, body)
  let scheme = call_594279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594279.url(scheme.get, call_594279.host, call_594279.base,
                         call_594279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594279, url, valid)

proc call*(call_594280: Call_EnterpriseChannelsUpdate_594271;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; parameters: JsonNode): Recallable =
  ## enterpriseChannelsUpdate
  ## Updates an Enterprise Channel.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  ##   parameters: JObject (required)
  ##             : The parameters to provide to update the Enterprise Channel.
  var path_594281 = newJObject()
  var query_594282 = newJObject()
  var body_594283 = newJObject()
  add(path_594281, "resourceGroupName", newJString(resourceGroupName))
  add(query_594282, "api-version", newJString(apiVersion))
  add(path_594281, "subscriptionId", newJString(subscriptionId))
  add(path_594281, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_594283 = parameters
  result = call_594280.call(path_594281, query_594282, nil, nil, body_594283)

var enterpriseChannelsUpdate* = Call_EnterpriseChannelsUpdate_594271(
    name: "enterpriseChannelsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/enterpriseChannels/{resourceName}",
    validator: validate_EnterpriseChannelsUpdate_594272, base: "",
    url: url_EnterpriseChannelsUpdate_594273, schemes: {Scheme.Https})
type
  Call_EnterpriseChannelsDelete_594260 = ref object of OpenApiRestCall_593437
proc url_EnterpriseChannelsDelete_594262(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.BotService/enterpriseChannels/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnterpriseChannelsDelete_594261(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an Enterprise Channel from the resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: JString (required)
  ##               : The name of the Bot resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594263 = path.getOrDefault("resourceGroupName")
  valid_594263 = validateParameter(valid_594263, JString, required = true,
                                 default = nil)
  if valid_594263 != nil:
    section.add "resourceGroupName", valid_594263
  var valid_594264 = path.getOrDefault("subscriptionId")
  valid_594264 = validateParameter(valid_594264, JString, required = true,
                                 default = nil)
  if valid_594264 != nil:
    section.add "subscriptionId", valid_594264
  var valid_594265 = path.getOrDefault("resourceName")
  valid_594265 = validateParameter(valid_594265, JString, required = true,
                                 default = nil)
  if valid_594265 != nil:
    section.add "resourceName", valid_594265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594266 = query.getOrDefault("api-version")
  valid_594266 = validateParameter(valid_594266, JString, required = true,
                                 default = nil)
  if valid_594266 != nil:
    section.add "api-version", valid_594266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594267: Call_EnterpriseChannelsDelete_594260; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Enterprise Channel from the resource group
  ## 
  let valid = call_594267.validator(path, query, header, formData, body)
  let scheme = call_594267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594267.url(scheme.get, call_594267.host, call_594267.base,
                         call_594267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594267, url, valid)

proc call*(call_594268: Call_EnterpriseChannelsDelete_594260;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## enterpriseChannelsDelete
  ## Deletes an Enterprise Channel from the resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  var path_594269 = newJObject()
  var query_594270 = newJObject()
  add(path_594269, "resourceGroupName", newJString(resourceGroupName))
  add(query_594270, "api-version", newJString(apiVersion))
  add(path_594269, "subscriptionId", newJString(subscriptionId))
  add(path_594269, "resourceName", newJString(resourceName))
  result = call_594268.call(path_594269, query_594270, nil, nil, nil)

var enterpriseChannelsDelete* = Call_EnterpriseChannelsDelete_594260(
    name: "enterpriseChannelsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/enterpriseChannels/{resourceName}",
    validator: validate_EnterpriseChannelsDelete_594261, base: "",
    url: url_EnterpriseChannelsDelete_594262, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
