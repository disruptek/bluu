
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Bot Service
## version: 2017-12-01
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

  OpenApiRestCall_574466 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574466](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574466): Option[Scheme] {.used.} =
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
  macServiceName = "botservice"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BotsGetCheckNameAvailability_574688 = ref object of OpenApiRestCall_574466
proc url_BotsGetCheckNameAvailability_574690(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BotsGetCheckNameAvailability_574689(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check whether a bot name is available.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-12-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574849 = query.getOrDefault("api-version")
  valid_574849 = validateParameter(valid_574849, JString, required = true,
                                 default = nil)
  if valid_574849 != nil:
    section.add "api-version", valid_574849
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

proc call*(call_574873: Call_BotsGetCheckNameAvailability_574688; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check whether a bot name is available.
  ## 
  let valid = call_574873.validator(path, query, header, formData, body)
  let scheme = call_574873.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574873.url(scheme.get, call_574873.host, call_574873.base,
                         call_574873.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574873, url, valid)

proc call*(call_574944: Call_BotsGetCheckNameAvailability_574688;
          apiVersion: string; parameters: JsonNode): Recallable =
  ## botsGetCheckNameAvailability
  ## Check whether a bot name is available.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-12-01
  ##   parameters: JObject (required)
  ##             : The request body parameters to provide for the check name availability request
  var query_574945 = newJObject()
  var body_574947 = newJObject()
  add(query_574945, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_574947 = parameters
  result = call_574944.call(nil, query_574945, nil, nil, body_574947)

var botsGetCheckNameAvailability* = Call_BotsGetCheckNameAvailability_574688(
    name: "botsGetCheckNameAvailability", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.BotService/botServices/checkNameAvailability",
    validator: validate_BotsGetCheckNameAvailability_574689, base: "",
    url: url_BotsGetCheckNameAvailability_574690, schemes: {Scheme.Https})
type
  Call_OperationsList_574986 = ref object of OpenApiRestCall_574466
proc url_OperationsList_574988(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_574987(path: JsonNode; query: JsonNode;
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
  ##              : Version of the API to be used with the client request. Current version is 2017-12-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574989 = query.getOrDefault("api-version")
  valid_574989 = validateParameter(valid_574989, JString, required = true,
                                 default = nil)
  if valid_574989 != nil:
    section.add "api-version", valid_574989
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574990: Call_OperationsList_574986; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available BotService operations.
  ## 
  let valid = call_574990.validator(path, query, header, formData, body)
  let scheme = call_574990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574990.url(scheme.get, call_574990.host, call_574990.base,
                         call_574990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574990, url, valid)

proc call*(call_574991: Call_OperationsList_574986; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all the available BotService operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-12-01
  var query_574992 = newJObject()
  add(query_574992, "api-version", newJString(apiVersion))
  result = call_574991.call(nil, query_574992, nil, nil, nil)

var operationsList* = Call_OperationsList_574986(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.BotService/operations",
    validator: validate_OperationsList_574987, base: "", url: url_OperationsList_574988,
    schemes: {Scheme.Https})
type
  Call_BotsList_574993 = ref object of OpenApiRestCall_574466
proc url_BotsList_574995(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_BotsList_574994(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575010 = path.getOrDefault("subscriptionId")
  valid_575010 = validateParameter(valid_575010, JString, required = true,
                                 default = nil)
  if valid_575010 != nil:
    section.add "subscriptionId", valid_575010
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-12-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575011 = query.getOrDefault("api-version")
  valid_575011 = validateParameter(valid_575011, JString, required = true,
                                 default = nil)
  if valid_575011 != nil:
    section.add "api-version", valid_575011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575012: Call_BotsList_574993; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all the resources of a particular type belonging to a subscription.
  ## 
  let valid = call_575012.validator(path, query, header, formData, body)
  let scheme = call_575012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575012.url(scheme.get, call_575012.host, call_575012.base,
                         call_575012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575012, url, valid)

proc call*(call_575013: Call_BotsList_574993; apiVersion: string;
          subscriptionId: string): Recallable =
  ## botsList
  ## Returns all the resources of a particular type belonging to a subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-12-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_575014 = newJObject()
  var query_575015 = newJObject()
  add(query_575015, "api-version", newJString(apiVersion))
  add(path_575014, "subscriptionId", newJString(subscriptionId))
  result = call_575013.call(path_575014, query_575015, nil, nil, nil)

var botsList* = Call_BotsList_574993(name: "botsList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.BotService/botServices",
                                  validator: validate_BotsList_574994, base: "",
                                  url: url_BotsList_574995,
                                  schemes: {Scheme.Https})
type
  Call_BotConnectionListServiceProviders_575016 = ref object of OpenApiRestCall_574466
proc url_BotConnectionListServiceProviders_575018(protocol: Scheme; host: string;
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

proc validate_BotConnectionListServiceProviders_575017(path: JsonNode;
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
  var valid_575019 = path.getOrDefault("subscriptionId")
  valid_575019 = validateParameter(valid_575019, JString, required = true,
                                 default = nil)
  if valid_575019 != nil:
    section.add "subscriptionId", valid_575019
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-12-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575020 = query.getOrDefault("api-version")
  valid_575020 = validateParameter(valid_575020, JString, required = true,
                                 default = nil)
  if valid_575020 != nil:
    section.add "api-version", valid_575020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575021: Call_BotConnectionListServiceProviders_575016;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the available Service Providers for creating Connection Settings
  ## 
  let valid = call_575021.validator(path, query, header, formData, body)
  let scheme = call_575021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575021.url(scheme.get, call_575021.host, call_575021.base,
                         call_575021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575021, url, valid)

proc call*(call_575022: Call_BotConnectionListServiceProviders_575016;
          apiVersion: string; subscriptionId: string): Recallable =
  ## botConnectionListServiceProviders
  ## Lists the available Service Providers for creating Connection Settings
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-12-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_575023 = newJObject()
  var query_575024 = newJObject()
  add(query_575024, "api-version", newJString(apiVersion))
  add(path_575023, "subscriptionId", newJString(subscriptionId))
  result = call_575022.call(path_575023, query_575024, nil, nil, nil)

var botConnectionListServiceProviders* = Call_BotConnectionListServiceProviders_575016(
    name: "botConnectionListServiceProviders", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.BotService/listAuthServiceProviders",
    validator: validate_BotConnectionListServiceProviders_575017, base: "",
    url: url_BotConnectionListServiceProviders_575018, schemes: {Scheme.Https})
type
  Call_BotsListByResourceGroup_575025 = ref object of OpenApiRestCall_574466
proc url_BotsListByResourceGroup_575027(protocol: Scheme; host: string; base: string;
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

proc validate_BotsListByResourceGroup_575026(path: JsonNode; query: JsonNode;
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
  var valid_575028 = path.getOrDefault("resourceGroupName")
  valid_575028 = validateParameter(valid_575028, JString, required = true,
                                 default = nil)
  if valid_575028 != nil:
    section.add "resourceGroupName", valid_575028
  var valid_575029 = path.getOrDefault("subscriptionId")
  valid_575029 = validateParameter(valid_575029, JString, required = true,
                                 default = nil)
  if valid_575029 != nil:
    section.add "subscriptionId", valid_575029
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-12-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575030 = query.getOrDefault("api-version")
  valid_575030 = validateParameter(valid_575030, JString, required = true,
                                 default = nil)
  if valid_575030 != nil:
    section.add "api-version", valid_575030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575031: Call_BotsListByResourceGroup_575025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all the resources of a particular type belonging to a resource group
  ## 
  let valid = call_575031.validator(path, query, header, formData, body)
  let scheme = call_575031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575031.url(scheme.get, call_575031.host, call_575031.base,
                         call_575031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575031, url, valid)

proc call*(call_575032: Call_BotsListByResourceGroup_575025;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## botsListByResourceGroup
  ## Returns all the resources of a particular type belonging to a resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-12-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_575033 = newJObject()
  var query_575034 = newJObject()
  add(path_575033, "resourceGroupName", newJString(resourceGroupName))
  add(query_575034, "api-version", newJString(apiVersion))
  add(path_575033, "subscriptionId", newJString(subscriptionId))
  result = call_575032.call(path_575033, query_575034, nil, nil, nil)

var botsListByResourceGroup* = Call_BotsListByResourceGroup_575025(
    name: "botsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices",
    validator: validate_BotsListByResourceGroup_575026, base: "",
    url: url_BotsListByResourceGroup_575027, schemes: {Scheme.Https})
type
  Call_BotsCreate_575046 = ref object of OpenApiRestCall_574466
proc url_BotsCreate_575048(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_BotsCreate_575047(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575049 = path.getOrDefault("resourceGroupName")
  valid_575049 = validateParameter(valid_575049, JString, required = true,
                                 default = nil)
  if valid_575049 != nil:
    section.add "resourceGroupName", valid_575049
  var valid_575050 = path.getOrDefault("subscriptionId")
  valid_575050 = validateParameter(valid_575050, JString, required = true,
                                 default = nil)
  if valid_575050 != nil:
    section.add "subscriptionId", valid_575050
  var valid_575051 = path.getOrDefault("resourceName")
  valid_575051 = validateParameter(valid_575051, JString, required = true,
                                 default = nil)
  if valid_575051 != nil:
    section.add "resourceName", valid_575051
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-12-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575052 = query.getOrDefault("api-version")
  valid_575052 = validateParameter(valid_575052, JString, required = true,
                                 default = nil)
  if valid_575052 != nil:
    section.add "api-version", valid_575052
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

proc call*(call_575054: Call_BotsCreate_575046; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Bot Service. Bot Service is a resource group wide resource type.
  ## 
  let valid = call_575054.validator(path, query, header, formData, body)
  let scheme = call_575054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575054.url(scheme.get, call_575054.host, call_575054.base,
                         call_575054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575054, url, valid)

proc call*(call_575055: Call_BotsCreate_575046; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          parameters: JsonNode): Recallable =
  ## botsCreate
  ## Creates a Bot Service. Bot Service is a resource group wide resource type.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-12-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the created bot.
  var path_575056 = newJObject()
  var query_575057 = newJObject()
  var body_575058 = newJObject()
  add(path_575056, "resourceGroupName", newJString(resourceGroupName))
  add(query_575057, "api-version", newJString(apiVersion))
  add(path_575056, "subscriptionId", newJString(subscriptionId))
  add(path_575056, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_575058 = parameters
  result = call_575055.call(path_575056, query_575057, nil, nil, body_575058)

var botsCreate* = Call_BotsCreate_575046(name: "botsCreate",
                                      meth: HttpMethod.HttpPut,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}",
                                      validator: validate_BotsCreate_575047,
                                      base: "", url: url_BotsCreate_575048,
                                      schemes: {Scheme.Https})
type
  Call_BotsGet_575035 = ref object of OpenApiRestCall_574466
proc url_BotsGet_575037(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_BotsGet_575036(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575038 = path.getOrDefault("resourceGroupName")
  valid_575038 = validateParameter(valid_575038, JString, required = true,
                                 default = nil)
  if valid_575038 != nil:
    section.add "resourceGroupName", valid_575038
  var valid_575039 = path.getOrDefault("subscriptionId")
  valid_575039 = validateParameter(valid_575039, JString, required = true,
                                 default = nil)
  if valid_575039 != nil:
    section.add "subscriptionId", valid_575039
  var valid_575040 = path.getOrDefault("resourceName")
  valid_575040 = validateParameter(valid_575040, JString, required = true,
                                 default = nil)
  if valid_575040 != nil:
    section.add "resourceName", valid_575040
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-12-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575041 = query.getOrDefault("api-version")
  valid_575041 = validateParameter(valid_575041, JString, required = true,
                                 default = nil)
  if valid_575041 != nil:
    section.add "api-version", valid_575041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575042: Call_BotsGet_575035; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a BotService specified by the parameters.
  ## 
  let valid = call_575042.validator(path, query, header, formData, body)
  let scheme = call_575042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575042.url(scheme.get, call_575042.host, call_575042.base,
                         call_575042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575042, url, valid)

proc call*(call_575043: Call_BotsGet_575035; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string): Recallable =
  ## botsGet
  ## Returns a BotService specified by the parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-12-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  var path_575044 = newJObject()
  var query_575045 = newJObject()
  add(path_575044, "resourceGroupName", newJString(resourceGroupName))
  add(query_575045, "api-version", newJString(apiVersion))
  add(path_575044, "subscriptionId", newJString(subscriptionId))
  add(path_575044, "resourceName", newJString(resourceName))
  result = call_575043.call(path_575044, query_575045, nil, nil, nil)

var botsGet* = Call_BotsGet_575035(name: "botsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}",
                                validator: validate_BotsGet_575036, base: "",
                                url: url_BotsGet_575037, schemes: {Scheme.Https})
type
  Call_BotsUpdate_575070 = ref object of OpenApiRestCall_574466
proc url_BotsUpdate_575072(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_BotsUpdate_575071(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575073 = path.getOrDefault("resourceGroupName")
  valid_575073 = validateParameter(valid_575073, JString, required = true,
                                 default = nil)
  if valid_575073 != nil:
    section.add "resourceGroupName", valid_575073
  var valid_575074 = path.getOrDefault("subscriptionId")
  valid_575074 = validateParameter(valid_575074, JString, required = true,
                                 default = nil)
  if valid_575074 != nil:
    section.add "subscriptionId", valid_575074
  var valid_575075 = path.getOrDefault("resourceName")
  valid_575075 = validateParameter(valid_575075, JString, required = true,
                                 default = nil)
  if valid_575075 != nil:
    section.add "resourceName", valid_575075
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-12-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575076 = query.getOrDefault("api-version")
  valid_575076 = validateParameter(valid_575076, JString, required = true,
                                 default = nil)
  if valid_575076 != nil:
    section.add "api-version", valid_575076
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

proc call*(call_575078: Call_BotsUpdate_575070; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Bot Service
  ## 
  let valid = call_575078.validator(path, query, header, formData, body)
  let scheme = call_575078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575078.url(scheme.get, call_575078.host, call_575078.base,
                         call_575078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575078, url, valid)

proc call*(call_575079: Call_BotsUpdate_575070; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          parameters: JsonNode): Recallable =
  ## botsUpdate
  ## Updates a Bot Service
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-12-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the created bot.
  var path_575080 = newJObject()
  var query_575081 = newJObject()
  var body_575082 = newJObject()
  add(path_575080, "resourceGroupName", newJString(resourceGroupName))
  add(query_575081, "api-version", newJString(apiVersion))
  add(path_575080, "subscriptionId", newJString(subscriptionId))
  add(path_575080, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_575082 = parameters
  result = call_575079.call(path_575080, query_575081, nil, nil, body_575082)

var botsUpdate* = Call_BotsUpdate_575070(name: "botsUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}",
                                      validator: validate_BotsUpdate_575071,
                                      base: "", url: url_BotsUpdate_575072,
                                      schemes: {Scheme.Https})
type
  Call_BotsDelete_575059 = ref object of OpenApiRestCall_574466
proc url_BotsDelete_575061(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_BotsDelete_575060(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575062 = path.getOrDefault("resourceGroupName")
  valid_575062 = validateParameter(valid_575062, JString, required = true,
                                 default = nil)
  if valid_575062 != nil:
    section.add "resourceGroupName", valid_575062
  var valid_575063 = path.getOrDefault("subscriptionId")
  valid_575063 = validateParameter(valid_575063, JString, required = true,
                                 default = nil)
  if valid_575063 != nil:
    section.add "subscriptionId", valid_575063
  var valid_575064 = path.getOrDefault("resourceName")
  valid_575064 = validateParameter(valid_575064, JString, required = true,
                                 default = nil)
  if valid_575064 != nil:
    section.add "resourceName", valid_575064
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-12-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575065 = query.getOrDefault("api-version")
  valid_575065 = validateParameter(valid_575065, JString, required = true,
                                 default = nil)
  if valid_575065 != nil:
    section.add "api-version", valid_575065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575066: Call_BotsDelete_575059; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Bot Service from the resource group. 
  ## 
  let valid = call_575066.validator(path, query, header, formData, body)
  let scheme = call_575066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575066.url(scheme.get, call_575066.host, call_575066.base,
                         call_575066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575066, url, valid)

proc call*(call_575067: Call_BotsDelete_575059; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string): Recallable =
  ## botsDelete
  ## Deletes a Bot Service from the resource group. 
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-12-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  var path_575068 = newJObject()
  var query_575069 = newJObject()
  add(path_575068, "resourceGroupName", newJString(resourceGroupName))
  add(query_575069, "api-version", newJString(apiVersion))
  add(path_575068, "subscriptionId", newJString(subscriptionId))
  add(path_575068, "resourceName", newJString(resourceName))
  result = call_575067.call(path_575068, query_575069, nil, nil, nil)

var botsDelete* = Call_BotsDelete_575059(name: "botsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}",
                                      validator: validate_BotsDelete_575060,
                                      base: "", url: url_BotsDelete_575061,
                                      schemes: {Scheme.Https})
type
  Call_BotConnectionCreate_575095 = ref object of OpenApiRestCall_574466
proc url_BotConnectionCreate_575097(protocol: Scheme; host: string; base: string;
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

proc validate_BotConnectionCreate_575096(path: JsonNode; query: JsonNode;
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
  var valid_575098 = path.getOrDefault("resourceGroupName")
  valid_575098 = validateParameter(valid_575098, JString, required = true,
                                 default = nil)
  if valid_575098 != nil:
    section.add "resourceGroupName", valid_575098
  var valid_575099 = path.getOrDefault("subscriptionId")
  valid_575099 = validateParameter(valid_575099, JString, required = true,
                                 default = nil)
  if valid_575099 != nil:
    section.add "subscriptionId", valid_575099
  var valid_575100 = path.getOrDefault("resourceName")
  valid_575100 = validateParameter(valid_575100, JString, required = true,
                                 default = nil)
  if valid_575100 != nil:
    section.add "resourceName", valid_575100
  var valid_575101 = path.getOrDefault("connectionName")
  valid_575101 = validateParameter(valid_575101, JString, required = true,
                                 default = nil)
  if valid_575101 != nil:
    section.add "connectionName", valid_575101
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-12-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575102 = query.getOrDefault("api-version")
  valid_575102 = validateParameter(valid_575102, JString, required = true,
                                 default = nil)
  if valid_575102 != nil:
    section.add "api-version", valid_575102
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

proc call*(call_575104: Call_BotConnectionCreate_575095; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Register a new Auth Connection for a Bot Service
  ## 
  let valid = call_575104.validator(path, query, header, formData, body)
  let scheme = call_575104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575104.url(scheme.get, call_575104.host, call_575104.base,
                         call_575104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575104, url, valid)

proc call*(call_575105: Call_BotConnectionCreate_575095; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          parameters: JsonNode; connectionName: string): Recallable =
  ## botConnectionCreate
  ## Register a new Auth Connection for a Bot Service
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-12-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  ##   parameters: JObject (required)
  ##             : The parameters to provide for creating the Connection Setting.
  ##   connectionName: string (required)
  ##                 : The name of the Bot Service Connection Setting resource
  var path_575106 = newJObject()
  var query_575107 = newJObject()
  var body_575108 = newJObject()
  add(path_575106, "resourceGroupName", newJString(resourceGroupName))
  add(query_575107, "api-version", newJString(apiVersion))
  add(path_575106, "subscriptionId", newJString(subscriptionId))
  add(path_575106, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_575108 = parameters
  add(path_575106, "connectionName", newJString(connectionName))
  result = call_575105.call(path_575106, query_575107, nil, nil, body_575108)

var botConnectionCreate* = Call_BotConnectionCreate_575095(
    name: "botConnectionCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/Connections/{connectionName}",
    validator: validate_BotConnectionCreate_575096, base: "",
    url: url_BotConnectionCreate_575097, schemes: {Scheme.Https})
type
  Call_BotConnectionGet_575083 = ref object of OpenApiRestCall_574466
proc url_BotConnectionGet_575085(protocol: Scheme; host: string; base: string;
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

proc validate_BotConnectionGet_575084(path: JsonNode; query: JsonNode;
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
  var valid_575086 = path.getOrDefault("resourceGroupName")
  valid_575086 = validateParameter(valid_575086, JString, required = true,
                                 default = nil)
  if valid_575086 != nil:
    section.add "resourceGroupName", valid_575086
  var valid_575087 = path.getOrDefault("subscriptionId")
  valid_575087 = validateParameter(valid_575087, JString, required = true,
                                 default = nil)
  if valid_575087 != nil:
    section.add "subscriptionId", valid_575087
  var valid_575088 = path.getOrDefault("resourceName")
  valid_575088 = validateParameter(valid_575088, JString, required = true,
                                 default = nil)
  if valid_575088 != nil:
    section.add "resourceName", valid_575088
  var valid_575089 = path.getOrDefault("connectionName")
  valid_575089 = validateParameter(valid_575089, JString, required = true,
                                 default = nil)
  if valid_575089 != nil:
    section.add "connectionName", valid_575089
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-12-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575090 = query.getOrDefault("api-version")
  valid_575090 = validateParameter(valid_575090, JString, required = true,
                                 default = nil)
  if valid_575090 != nil:
    section.add "api-version", valid_575090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575091: Call_BotConnectionGet_575083; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Connection Setting registration for a Bot Service
  ## 
  let valid = call_575091.validator(path, query, header, formData, body)
  let scheme = call_575091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575091.url(scheme.get, call_575091.host, call_575091.base,
                         call_575091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575091, url, valid)

proc call*(call_575092: Call_BotConnectionGet_575083; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          connectionName: string): Recallable =
  ## botConnectionGet
  ## Get a Connection Setting registration for a Bot Service
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-12-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  ##   connectionName: string (required)
  ##                 : The name of the Bot Service Connection Setting resource
  var path_575093 = newJObject()
  var query_575094 = newJObject()
  add(path_575093, "resourceGroupName", newJString(resourceGroupName))
  add(query_575094, "api-version", newJString(apiVersion))
  add(path_575093, "subscriptionId", newJString(subscriptionId))
  add(path_575093, "resourceName", newJString(resourceName))
  add(path_575093, "connectionName", newJString(connectionName))
  result = call_575092.call(path_575093, query_575094, nil, nil, nil)

var botConnectionGet* = Call_BotConnectionGet_575083(name: "botConnectionGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/Connections/{connectionName}",
    validator: validate_BotConnectionGet_575084, base: "",
    url: url_BotConnectionGet_575085, schemes: {Scheme.Https})
type
  Call_BotConnectionUpdate_575121 = ref object of OpenApiRestCall_574466
proc url_BotConnectionUpdate_575123(protocol: Scheme; host: string; base: string;
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

proc validate_BotConnectionUpdate_575122(path: JsonNode; query: JsonNode;
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
  var valid_575124 = path.getOrDefault("resourceGroupName")
  valid_575124 = validateParameter(valid_575124, JString, required = true,
                                 default = nil)
  if valid_575124 != nil:
    section.add "resourceGroupName", valid_575124
  var valid_575125 = path.getOrDefault("subscriptionId")
  valid_575125 = validateParameter(valid_575125, JString, required = true,
                                 default = nil)
  if valid_575125 != nil:
    section.add "subscriptionId", valid_575125
  var valid_575126 = path.getOrDefault("resourceName")
  valid_575126 = validateParameter(valid_575126, JString, required = true,
                                 default = nil)
  if valid_575126 != nil:
    section.add "resourceName", valid_575126
  var valid_575127 = path.getOrDefault("connectionName")
  valid_575127 = validateParameter(valid_575127, JString, required = true,
                                 default = nil)
  if valid_575127 != nil:
    section.add "connectionName", valid_575127
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-12-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575128 = query.getOrDefault("api-version")
  valid_575128 = validateParameter(valid_575128, JString, required = true,
                                 default = nil)
  if valid_575128 != nil:
    section.add "api-version", valid_575128
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

proc call*(call_575130: Call_BotConnectionUpdate_575121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Connection Setting registration for a Bot Service
  ## 
  let valid = call_575130.validator(path, query, header, formData, body)
  let scheme = call_575130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575130.url(scheme.get, call_575130.host, call_575130.base,
                         call_575130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575130, url, valid)

proc call*(call_575131: Call_BotConnectionUpdate_575121; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          parameters: JsonNode; connectionName: string): Recallable =
  ## botConnectionUpdate
  ## Updates a Connection Setting registration for a Bot Service
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-12-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  ##   parameters: JObject (required)
  ##             : The parameters to provide for updating the Connection Setting.
  ##   connectionName: string (required)
  ##                 : The name of the Bot Service Connection Setting resource
  var path_575132 = newJObject()
  var query_575133 = newJObject()
  var body_575134 = newJObject()
  add(path_575132, "resourceGroupName", newJString(resourceGroupName))
  add(query_575133, "api-version", newJString(apiVersion))
  add(path_575132, "subscriptionId", newJString(subscriptionId))
  add(path_575132, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_575134 = parameters
  add(path_575132, "connectionName", newJString(connectionName))
  result = call_575131.call(path_575132, query_575133, nil, nil, body_575134)

var botConnectionUpdate* = Call_BotConnectionUpdate_575121(
    name: "botConnectionUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/Connections/{connectionName}",
    validator: validate_BotConnectionUpdate_575122, base: "",
    url: url_BotConnectionUpdate_575123, schemes: {Scheme.Https})
type
  Call_BotConnectionDelete_575109 = ref object of OpenApiRestCall_574466
proc url_BotConnectionDelete_575111(protocol: Scheme; host: string; base: string;
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

proc validate_BotConnectionDelete_575110(path: JsonNode; query: JsonNode;
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
  var valid_575112 = path.getOrDefault("resourceGroupName")
  valid_575112 = validateParameter(valid_575112, JString, required = true,
                                 default = nil)
  if valid_575112 != nil:
    section.add "resourceGroupName", valid_575112
  var valid_575113 = path.getOrDefault("subscriptionId")
  valid_575113 = validateParameter(valid_575113, JString, required = true,
                                 default = nil)
  if valid_575113 != nil:
    section.add "subscriptionId", valid_575113
  var valid_575114 = path.getOrDefault("resourceName")
  valid_575114 = validateParameter(valid_575114, JString, required = true,
                                 default = nil)
  if valid_575114 != nil:
    section.add "resourceName", valid_575114
  var valid_575115 = path.getOrDefault("connectionName")
  valid_575115 = validateParameter(valid_575115, JString, required = true,
                                 default = nil)
  if valid_575115 != nil:
    section.add "connectionName", valid_575115
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-12-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575116 = query.getOrDefault("api-version")
  valid_575116 = validateParameter(valid_575116, JString, required = true,
                                 default = nil)
  if valid_575116 != nil:
    section.add "api-version", valid_575116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575117: Call_BotConnectionDelete_575109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Connection Setting registration for a Bot Service
  ## 
  let valid = call_575117.validator(path, query, header, formData, body)
  let scheme = call_575117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575117.url(scheme.get, call_575117.host, call_575117.base,
                         call_575117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575117, url, valid)

proc call*(call_575118: Call_BotConnectionDelete_575109; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          connectionName: string): Recallable =
  ## botConnectionDelete
  ## Deletes a Connection Setting registration for a Bot Service
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-12-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  ##   connectionName: string (required)
  ##                 : The name of the Bot Service Connection Setting resource
  var path_575119 = newJObject()
  var query_575120 = newJObject()
  add(path_575119, "resourceGroupName", newJString(resourceGroupName))
  add(query_575120, "api-version", newJString(apiVersion))
  add(path_575119, "subscriptionId", newJString(subscriptionId))
  add(path_575119, "resourceName", newJString(resourceName))
  add(path_575119, "connectionName", newJString(connectionName))
  result = call_575118.call(path_575119, query_575120, nil, nil, nil)

var botConnectionDelete* = Call_BotConnectionDelete_575109(
    name: "botConnectionDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/Connections/{connectionName}",
    validator: validate_BotConnectionDelete_575110, base: "",
    url: url_BotConnectionDelete_575111, schemes: {Scheme.Https})
type
  Call_BotConnectionListWithSecrets_575135 = ref object of OpenApiRestCall_574466
proc url_BotConnectionListWithSecrets_575137(protocol: Scheme; host: string;
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

proc validate_BotConnectionListWithSecrets_575136(path: JsonNode; query: JsonNode;
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
  var valid_575138 = path.getOrDefault("resourceGroupName")
  valid_575138 = validateParameter(valid_575138, JString, required = true,
                                 default = nil)
  if valid_575138 != nil:
    section.add "resourceGroupName", valid_575138
  var valid_575139 = path.getOrDefault("subscriptionId")
  valid_575139 = validateParameter(valid_575139, JString, required = true,
                                 default = nil)
  if valid_575139 != nil:
    section.add "subscriptionId", valid_575139
  var valid_575140 = path.getOrDefault("resourceName")
  valid_575140 = validateParameter(valid_575140, JString, required = true,
                                 default = nil)
  if valid_575140 != nil:
    section.add "resourceName", valid_575140
  var valid_575141 = path.getOrDefault("connectionName")
  valid_575141 = validateParameter(valid_575141, JString, required = true,
                                 default = nil)
  if valid_575141 != nil:
    section.add "connectionName", valid_575141
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-12-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575142 = query.getOrDefault("api-version")
  valid_575142 = validateParameter(valid_575142, JString, required = true,
                                 default = nil)
  if valid_575142 != nil:
    section.add "api-version", valid_575142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575143: Call_BotConnectionListWithSecrets_575135; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Connection Setting registration for a Bot Service
  ## 
  let valid = call_575143.validator(path, query, header, formData, body)
  let scheme = call_575143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575143.url(scheme.get, call_575143.host, call_575143.base,
                         call_575143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575143, url, valid)

proc call*(call_575144: Call_BotConnectionListWithSecrets_575135;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; connectionName: string): Recallable =
  ## botConnectionListWithSecrets
  ## Get a Connection Setting registration for a Bot Service
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-12-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  ##   connectionName: string (required)
  ##                 : The name of the Bot Service Connection Setting resource
  var path_575145 = newJObject()
  var query_575146 = newJObject()
  add(path_575145, "resourceGroupName", newJString(resourceGroupName))
  add(query_575146, "api-version", newJString(apiVersion))
  add(path_575145, "subscriptionId", newJString(subscriptionId))
  add(path_575145, "resourceName", newJString(resourceName))
  add(path_575145, "connectionName", newJString(connectionName))
  result = call_575144.call(path_575145, query_575146, nil, nil, nil)

var botConnectionListWithSecrets* = Call_BotConnectionListWithSecrets_575135(
    name: "botConnectionListWithSecrets", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/Connections/{connectionName}/listWithSecrets",
    validator: validate_BotConnectionListWithSecrets_575136, base: "",
    url: url_BotConnectionListWithSecrets_575137, schemes: {Scheme.Https})
type
  Call_ChannelsListByResourceGroup_575147 = ref object of OpenApiRestCall_574466
proc url_ChannelsListByResourceGroup_575149(protocol: Scheme; host: string;
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

proc validate_ChannelsListByResourceGroup_575148(path: JsonNode; query: JsonNode;
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
  var valid_575150 = path.getOrDefault("resourceGroupName")
  valid_575150 = validateParameter(valid_575150, JString, required = true,
                                 default = nil)
  if valid_575150 != nil:
    section.add "resourceGroupName", valid_575150
  var valid_575151 = path.getOrDefault("subscriptionId")
  valid_575151 = validateParameter(valid_575151, JString, required = true,
                                 default = nil)
  if valid_575151 != nil:
    section.add "subscriptionId", valid_575151
  var valid_575152 = path.getOrDefault("resourceName")
  valid_575152 = validateParameter(valid_575152, JString, required = true,
                                 default = nil)
  if valid_575152 != nil:
    section.add "resourceName", valid_575152
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-12-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575153 = query.getOrDefault("api-version")
  valid_575153 = validateParameter(valid_575153, JString, required = true,
                                 default = nil)
  if valid_575153 != nil:
    section.add "api-version", valid_575153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575154: Call_ChannelsListByResourceGroup_575147; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all the Channel registrations of a particular BotService resource
  ## 
  let valid = call_575154.validator(path, query, header, formData, body)
  let scheme = call_575154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575154.url(scheme.get, call_575154.host, call_575154.base,
                         call_575154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575154, url, valid)

proc call*(call_575155: Call_ChannelsListByResourceGroup_575147;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## channelsListByResourceGroup
  ## Returns all the Channel registrations of a particular BotService resource
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-12-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  var path_575156 = newJObject()
  var query_575157 = newJObject()
  add(path_575156, "resourceGroupName", newJString(resourceGroupName))
  add(query_575157, "api-version", newJString(apiVersion))
  add(path_575156, "subscriptionId", newJString(subscriptionId))
  add(path_575156, "resourceName", newJString(resourceName))
  result = call_575155.call(path_575156, query_575157, nil, nil, nil)

var channelsListByResourceGroup* = Call_ChannelsListByResourceGroup_575147(
    name: "channelsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/channels",
    validator: validate_ChannelsListByResourceGroup_575148, base: "",
    url: url_ChannelsListByResourceGroup_575149, schemes: {Scheme.Https})
type
  Call_ChannelsCreate_575170 = ref object of OpenApiRestCall_574466
proc url_ChannelsCreate_575172(protocol: Scheme; host: string; base: string;
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

proc validate_ChannelsCreate_575171(path: JsonNode; query: JsonNode;
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
  var valid_575173 = path.getOrDefault("resourceGroupName")
  valid_575173 = validateParameter(valid_575173, JString, required = true,
                                 default = nil)
  if valid_575173 != nil:
    section.add "resourceGroupName", valid_575173
  var valid_575174 = path.getOrDefault("subscriptionId")
  valid_575174 = validateParameter(valid_575174, JString, required = true,
                                 default = nil)
  if valid_575174 != nil:
    section.add "subscriptionId", valid_575174
  var valid_575188 = path.getOrDefault("channelName")
  valid_575188 = validateParameter(valid_575188, JString, required = true,
                                 default = newJString("FacebookChannel"))
  if valid_575188 != nil:
    section.add "channelName", valid_575188
  var valid_575189 = path.getOrDefault("resourceName")
  valid_575189 = validateParameter(valid_575189, JString, required = true,
                                 default = nil)
  if valid_575189 != nil:
    section.add "resourceName", valid_575189
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-12-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575190 = query.getOrDefault("api-version")
  valid_575190 = validateParameter(valid_575190, JString, required = true,
                                 default = nil)
  if valid_575190 != nil:
    section.add "api-version", valid_575190
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

proc call*(call_575192: Call_ChannelsCreate_575170; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Channel registration for a Bot Service
  ## 
  let valid = call_575192.validator(path, query, header, formData, body)
  let scheme = call_575192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575192.url(scheme.get, call_575192.host, call_575192.base,
                         call_575192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575192, url, valid)

proc call*(call_575193: Call_ChannelsCreate_575170; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          parameters: JsonNode; channelName: string = "FacebookChannel"): Recallable =
  ## channelsCreate
  ## Creates a Channel registration for a Bot Service
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-12-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   channelName: string (required)
  ##              : The name of the Channel resource.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the created bot.
  var path_575194 = newJObject()
  var query_575195 = newJObject()
  var body_575196 = newJObject()
  add(path_575194, "resourceGroupName", newJString(resourceGroupName))
  add(query_575195, "api-version", newJString(apiVersion))
  add(path_575194, "subscriptionId", newJString(subscriptionId))
  add(path_575194, "channelName", newJString(channelName))
  add(path_575194, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_575196 = parameters
  result = call_575193.call(path_575194, query_575195, nil, nil, body_575196)

var channelsCreate* = Call_ChannelsCreate_575170(name: "channelsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/channels/{channelName}",
    validator: validate_ChannelsCreate_575171, base: "", url: url_ChannelsCreate_575172,
    schemes: {Scheme.Https})
type
  Call_ChannelsGet_575158 = ref object of OpenApiRestCall_574466
proc url_ChannelsGet_575160(protocol: Scheme; host: string; base: string;
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

proc validate_ChannelsGet_575159(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575161 = path.getOrDefault("resourceGroupName")
  valid_575161 = validateParameter(valid_575161, JString, required = true,
                                 default = nil)
  if valid_575161 != nil:
    section.add "resourceGroupName", valid_575161
  var valid_575162 = path.getOrDefault("subscriptionId")
  valid_575162 = validateParameter(valid_575162, JString, required = true,
                                 default = nil)
  if valid_575162 != nil:
    section.add "subscriptionId", valid_575162
  var valid_575163 = path.getOrDefault("channelName")
  valid_575163 = validateParameter(valid_575163, JString, required = true,
                                 default = nil)
  if valid_575163 != nil:
    section.add "channelName", valid_575163
  var valid_575164 = path.getOrDefault("resourceName")
  valid_575164 = validateParameter(valid_575164, JString, required = true,
                                 default = nil)
  if valid_575164 != nil:
    section.add "resourceName", valid_575164
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-12-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575165 = query.getOrDefault("api-version")
  valid_575165 = validateParameter(valid_575165, JString, required = true,
                                 default = nil)
  if valid_575165 != nil:
    section.add "api-version", valid_575165
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575166: Call_ChannelsGet_575158; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a BotService Channel registration specified by the parameters.
  ## 
  let valid = call_575166.validator(path, query, header, formData, body)
  let scheme = call_575166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575166.url(scheme.get, call_575166.host, call_575166.base,
                         call_575166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575166, url, valid)

proc call*(call_575167: Call_ChannelsGet_575158; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; channelName: string;
          resourceName: string): Recallable =
  ## channelsGet
  ## Returns a BotService Channel registration specified by the parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-12-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   channelName: string (required)
  ##              : The name of the Bot resource.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  var path_575168 = newJObject()
  var query_575169 = newJObject()
  add(path_575168, "resourceGroupName", newJString(resourceGroupName))
  add(query_575169, "api-version", newJString(apiVersion))
  add(path_575168, "subscriptionId", newJString(subscriptionId))
  add(path_575168, "channelName", newJString(channelName))
  add(path_575168, "resourceName", newJString(resourceName))
  result = call_575167.call(path_575168, query_575169, nil, nil, nil)

var channelsGet* = Call_ChannelsGet_575158(name: "channelsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/channels/{channelName}",
                                        validator: validate_ChannelsGet_575159,
                                        base: "", url: url_ChannelsGet_575160,
                                        schemes: {Scheme.Https})
type
  Call_ChannelsUpdate_575209 = ref object of OpenApiRestCall_574466
proc url_ChannelsUpdate_575211(protocol: Scheme; host: string; base: string;
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

proc validate_ChannelsUpdate_575210(path: JsonNode; query: JsonNode;
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
  var valid_575212 = path.getOrDefault("resourceGroupName")
  valid_575212 = validateParameter(valid_575212, JString, required = true,
                                 default = nil)
  if valid_575212 != nil:
    section.add "resourceGroupName", valid_575212
  var valid_575213 = path.getOrDefault("subscriptionId")
  valid_575213 = validateParameter(valid_575213, JString, required = true,
                                 default = nil)
  if valid_575213 != nil:
    section.add "subscriptionId", valid_575213
  var valid_575214 = path.getOrDefault("channelName")
  valid_575214 = validateParameter(valid_575214, JString, required = true,
                                 default = newJString("FacebookChannel"))
  if valid_575214 != nil:
    section.add "channelName", valid_575214
  var valid_575215 = path.getOrDefault("resourceName")
  valid_575215 = validateParameter(valid_575215, JString, required = true,
                                 default = nil)
  if valid_575215 != nil:
    section.add "resourceName", valid_575215
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-12-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575216 = query.getOrDefault("api-version")
  valid_575216 = validateParameter(valid_575216, JString, required = true,
                                 default = nil)
  if valid_575216 != nil:
    section.add "api-version", valid_575216
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

proc call*(call_575218: Call_ChannelsUpdate_575209; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Channel registration for a Bot Service
  ## 
  let valid = call_575218.validator(path, query, header, formData, body)
  let scheme = call_575218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575218.url(scheme.get, call_575218.host, call_575218.base,
                         call_575218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575218, url, valid)

proc call*(call_575219: Call_ChannelsUpdate_575209; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          parameters: JsonNode; channelName: string = "FacebookChannel"): Recallable =
  ## channelsUpdate
  ## Updates a Channel registration for a Bot Service
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-12-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   channelName: string (required)
  ##              : The name of the Channel resource.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the created bot.
  var path_575220 = newJObject()
  var query_575221 = newJObject()
  var body_575222 = newJObject()
  add(path_575220, "resourceGroupName", newJString(resourceGroupName))
  add(query_575221, "api-version", newJString(apiVersion))
  add(path_575220, "subscriptionId", newJString(subscriptionId))
  add(path_575220, "channelName", newJString(channelName))
  add(path_575220, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_575222 = parameters
  result = call_575219.call(path_575220, query_575221, nil, nil, body_575222)

var channelsUpdate* = Call_ChannelsUpdate_575209(name: "channelsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/channels/{channelName}",
    validator: validate_ChannelsUpdate_575210, base: "", url: url_ChannelsUpdate_575211,
    schemes: {Scheme.Https})
type
  Call_ChannelsDelete_575197 = ref object of OpenApiRestCall_574466
proc url_ChannelsDelete_575199(protocol: Scheme; host: string; base: string;
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

proc validate_ChannelsDelete_575198(path: JsonNode; query: JsonNode;
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
  var valid_575200 = path.getOrDefault("resourceGroupName")
  valid_575200 = validateParameter(valid_575200, JString, required = true,
                                 default = nil)
  if valid_575200 != nil:
    section.add "resourceGroupName", valid_575200
  var valid_575201 = path.getOrDefault("subscriptionId")
  valid_575201 = validateParameter(valid_575201, JString, required = true,
                                 default = nil)
  if valid_575201 != nil:
    section.add "subscriptionId", valid_575201
  var valid_575202 = path.getOrDefault("channelName")
  valid_575202 = validateParameter(valid_575202, JString, required = true,
                                 default = nil)
  if valid_575202 != nil:
    section.add "channelName", valid_575202
  var valid_575203 = path.getOrDefault("resourceName")
  valid_575203 = validateParameter(valid_575203, JString, required = true,
                                 default = nil)
  if valid_575203 != nil:
    section.add "resourceName", valid_575203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-12-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575204 = query.getOrDefault("api-version")
  valid_575204 = validateParameter(valid_575204, JString, required = true,
                                 default = nil)
  if valid_575204 != nil:
    section.add "api-version", valid_575204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575205: Call_ChannelsDelete_575197; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Channel registration from a Bot Service
  ## 
  let valid = call_575205.validator(path, query, header, formData, body)
  let scheme = call_575205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575205.url(scheme.get, call_575205.host, call_575205.base,
                         call_575205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575205, url, valid)

proc call*(call_575206: Call_ChannelsDelete_575197; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; channelName: string;
          resourceName: string): Recallable =
  ## channelsDelete
  ## Deletes a Channel registration from a Bot Service
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-12-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   channelName: string (required)
  ##              : The name of the Bot resource.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  var path_575207 = newJObject()
  var query_575208 = newJObject()
  add(path_575207, "resourceGroupName", newJString(resourceGroupName))
  add(query_575208, "api-version", newJString(apiVersion))
  add(path_575207, "subscriptionId", newJString(subscriptionId))
  add(path_575207, "channelName", newJString(channelName))
  add(path_575207, "resourceName", newJString(resourceName))
  result = call_575206.call(path_575207, query_575208, nil, nil, nil)

var channelsDelete* = Call_ChannelsDelete_575197(name: "channelsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/channels/{channelName}",
    validator: validate_ChannelsDelete_575198, base: "", url: url_ChannelsDelete_575199,
    schemes: {Scheme.Https})
type
  Call_ChannelsListWithKeys_575223 = ref object of OpenApiRestCall_574466
proc url_ChannelsListWithKeys_575225(protocol: Scheme; host: string; base: string;
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

proc validate_ChannelsListWithKeys_575224(path: JsonNode; query: JsonNode;
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
  var valid_575226 = path.getOrDefault("resourceGroupName")
  valid_575226 = validateParameter(valid_575226, JString, required = true,
                                 default = nil)
  if valid_575226 != nil:
    section.add "resourceGroupName", valid_575226
  var valid_575227 = path.getOrDefault("subscriptionId")
  valid_575227 = validateParameter(valid_575227, JString, required = true,
                                 default = nil)
  if valid_575227 != nil:
    section.add "subscriptionId", valid_575227
  var valid_575228 = path.getOrDefault("channelName")
  valid_575228 = validateParameter(valid_575228, JString, required = true,
                                 default = newJString("FacebookChannel"))
  if valid_575228 != nil:
    section.add "channelName", valid_575228
  var valid_575229 = path.getOrDefault("resourceName")
  valid_575229 = validateParameter(valid_575229, JString, required = true,
                                 default = nil)
  if valid_575229 != nil:
    section.add "resourceName", valid_575229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-12-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575230 = query.getOrDefault("api-version")
  valid_575230 = validateParameter(valid_575230, JString, required = true,
                                 default = nil)
  if valid_575230 != nil:
    section.add "api-version", valid_575230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575231: Call_ChannelsListWithKeys_575223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a Channel registration for a Bot Service including secrets
  ## 
  let valid = call_575231.validator(path, query, header, formData, body)
  let scheme = call_575231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575231.url(scheme.get, call_575231.host, call_575231.base,
                         call_575231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575231, url, valid)

proc call*(call_575232: Call_ChannelsListWithKeys_575223;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; channelName: string = "FacebookChannel"): Recallable =
  ## channelsListWithKeys
  ## Lists a Channel registration for a Bot Service including secrets
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-12-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   channelName: string (required)
  ##              : The name of the Channel resource.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  var path_575233 = newJObject()
  var query_575234 = newJObject()
  add(path_575233, "resourceGroupName", newJString(resourceGroupName))
  add(query_575234, "api-version", newJString(apiVersion))
  add(path_575233, "subscriptionId", newJString(subscriptionId))
  add(path_575233, "channelName", newJString(channelName))
  add(path_575233, "resourceName", newJString(resourceName))
  result = call_575232.call(path_575233, query_575234, nil, nil, nil)

var channelsListWithKeys* = Call_ChannelsListWithKeys_575223(
    name: "channelsListWithKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/channels/{channelName}/listChannelWithKeys",
    validator: validate_ChannelsListWithKeys_575224, base: "",
    url: url_ChannelsListWithKeys_575225, schemes: {Scheme.Https})
type
  Call_BotConnectionListByBotService_575235 = ref object of OpenApiRestCall_574466
proc url_BotConnectionListByBotService_575237(protocol: Scheme; host: string;
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

proc validate_BotConnectionListByBotService_575236(path: JsonNode; query: JsonNode;
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
  var valid_575238 = path.getOrDefault("resourceGroupName")
  valid_575238 = validateParameter(valid_575238, JString, required = true,
                                 default = nil)
  if valid_575238 != nil:
    section.add "resourceGroupName", valid_575238
  var valid_575239 = path.getOrDefault("subscriptionId")
  valid_575239 = validateParameter(valid_575239, JString, required = true,
                                 default = nil)
  if valid_575239 != nil:
    section.add "subscriptionId", valid_575239
  var valid_575240 = path.getOrDefault("resourceName")
  valid_575240 = validateParameter(valid_575240, JString, required = true,
                                 default = nil)
  if valid_575240 != nil:
    section.add "resourceName", valid_575240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-12-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575241 = query.getOrDefault("api-version")
  valid_575241 = validateParameter(valid_575241, JString, required = true,
                                 default = nil)
  if valid_575241 != nil:
    section.add "api-version", valid_575241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575242: Call_BotConnectionListByBotService_575235; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all the Connection Settings registered to a particular BotService resource
  ## 
  let valid = call_575242.validator(path, query, header, formData, body)
  let scheme = call_575242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575242.url(scheme.get, call_575242.host, call_575242.base,
                         call_575242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575242, url, valid)

proc call*(call_575243: Call_BotConnectionListByBotService_575235;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## botConnectionListByBotService
  ## Returns all the Connection Settings registered to a particular BotService resource
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-12-01
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceName: string (required)
  ##               : The name of the Bot resource.
  var path_575244 = newJObject()
  var query_575245 = newJObject()
  add(path_575244, "resourceGroupName", newJString(resourceGroupName))
  add(query_575245, "api-version", newJString(apiVersion))
  add(path_575244, "subscriptionId", newJString(subscriptionId))
  add(path_575244, "resourceName", newJString(resourceName))
  result = call_575243.call(path_575244, query_575245, nil, nil, nil)

var botConnectionListByBotService* = Call_BotConnectionListByBotService_575235(
    name: "botConnectionListByBotService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/connections",
    validator: validate_BotConnectionListByBotService_575236, base: "",
    url: url_BotConnectionListByBotService_575237, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
