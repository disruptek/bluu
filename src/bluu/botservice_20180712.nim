
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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
  Call_EnterpriseChannelsCheckNameAvailability_574688 = ref object of OpenApiRestCall_574466
proc url_EnterpriseChannelsCheckNameAvailability_574690(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_EnterpriseChannelsCheckNameAvailability_574689(path: JsonNode;
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
  ##             : The parameters to provide for the Enterprise Channel check name availability request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574873: Call_EnterpriseChannelsCheckNameAvailability_574688;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check whether an Enterprise Channel name is available.
  ## 
  let valid = call_574873.validator(path, query, header, formData, body)
  let scheme = call_574873.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574873.url(scheme.get, call_574873.host, call_574873.base,
                         call_574873.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574873, url, valid)

proc call*(call_574944: Call_EnterpriseChannelsCheckNameAvailability_574688;
          apiVersion: string; parameters: JsonNode): Recallable =
  ## enterpriseChannelsCheckNameAvailability
  ## Check whether an Enterprise Channel name is available.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the Enterprise Channel check name availability request.
  var query_574945 = newJObject()
  var body_574947 = newJObject()
  add(query_574945, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_574947 = parameters
  result = call_574944.call(nil, query_574945, nil, nil, body_574947)

var enterpriseChannelsCheckNameAvailability* = Call_EnterpriseChannelsCheckNameAvailability_574688(
    name: "enterpriseChannelsCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.BotService/checkEnterpriseChannelNameAvailability",
    validator: validate_EnterpriseChannelsCheckNameAvailability_574689, base: "",
    url: url_EnterpriseChannelsCheckNameAvailability_574690,
    schemes: {Scheme.Https})
type
  Call_BotsGetCheckNameAvailability_574986 = ref object of OpenApiRestCall_574466
proc url_BotsGetCheckNameAvailability_574988(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BotsGetCheckNameAvailability_574987(path: JsonNode; query: JsonNode;
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The request body parameters to provide for the check name availability request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574991: Call_BotsGetCheckNameAvailability_574986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check whether a bot name is available.
  ## 
  let valid = call_574991.validator(path, query, header, formData, body)
  let scheme = call_574991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574991.url(scheme.get, call_574991.host, call_574991.base,
                         call_574991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574991, url, valid)

proc call*(call_574992: Call_BotsGetCheckNameAvailability_574986;
          apiVersion: string; parameters: JsonNode): Recallable =
  ## botsGetCheckNameAvailability
  ## Check whether a bot name is available.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   parameters: JObject (required)
  ##             : The request body parameters to provide for the check name availability request
  var query_574993 = newJObject()
  var body_574994 = newJObject()
  add(query_574993, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_574994 = parameters
  result = call_574992.call(nil, query_574993, nil, nil, body_574994)

var botsGetCheckNameAvailability* = Call_BotsGetCheckNameAvailability_574986(
    name: "botsGetCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.BotService/checkNameAvailability",
    validator: validate_BotsGetCheckNameAvailability_574987, base: "",
    url: url_BotsGetCheckNameAvailability_574988, schemes: {Scheme.Https})
type
  Call_OperationsList_574995 = ref object of OpenApiRestCall_574466
proc url_OperationsList_574997(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_574996(path: JsonNode; query: JsonNode;
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
  var valid_574998 = query.getOrDefault("api-version")
  valid_574998 = validateParameter(valid_574998, JString, required = true,
                                 default = nil)
  if valid_574998 != nil:
    section.add "api-version", valid_574998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574999: Call_OperationsList_574995; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available BotService operations.
  ## 
  let valid = call_574999.validator(path, query, header, formData, body)
  let scheme = call_574999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574999.url(scheme.get, call_574999.host, call_574999.base,
                         call_574999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574999, url, valid)

proc call*(call_575000: Call_OperationsList_574995; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all the available BotService operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var query_575001 = newJObject()
  add(query_575001, "api-version", newJString(apiVersion))
  result = call_575000.call(nil, query_575001, nil, nil, nil)

var operationsList* = Call_OperationsList_574995(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.BotService/operations",
    validator: validate_OperationsList_574996, base: "", url: url_OperationsList_574997,
    schemes: {Scheme.Https})
type
  Call_BotsList_575002 = ref object of OpenApiRestCall_574466
proc url_BotsList_575004(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_BotsList_575003(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575019 = path.getOrDefault("subscriptionId")
  valid_575019 = validateParameter(valid_575019, JString, required = true,
                                 default = nil)
  if valid_575019 != nil:
    section.add "subscriptionId", valid_575019
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
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

proc call*(call_575021: Call_BotsList_575002; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all the resources of a particular type belonging to a subscription.
  ## 
  let valid = call_575021.validator(path, query, header, formData, body)
  let scheme = call_575021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575021.url(scheme.get, call_575021.host, call_575021.base,
                         call_575021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575021, url, valid)

proc call*(call_575022: Call_BotsList_575002; apiVersion: string;
          subscriptionId: string): Recallable =
  ## botsList
  ## Returns all the resources of a particular type belonging to a subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_575023 = newJObject()
  var query_575024 = newJObject()
  add(query_575024, "api-version", newJString(apiVersion))
  add(path_575023, "subscriptionId", newJString(subscriptionId))
  result = call_575022.call(path_575023, query_575024, nil, nil, nil)

var botsList* = Call_BotsList_575002(name: "botsList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.BotService/botServices",
                                  validator: validate_BotsList_575003, base: "",
                                  url: url_BotsList_575004,
                                  schemes: {Scheme.Https})
type
  Call_BotConnectionListServiceProviders_575025 = ref object of OpenApiRestCall_574466
proc url_BotConnectionListServiceProviders_575027(protocol: Scheme; host: string;
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

proc validate_BotConnectionListServiceProviders_575026(path: JsonNode;
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
  var valid_575028 = path.getOrDefault("subscriptionId")
  valid_575028 = validateParameter(valid_575028, JString, required = true,
                                 default = nil)
  if valid_575028 != nil:
    section.add "subscriptionId", valid_575028
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575029 = query.getOrDefault("api-version")
  valid_575029 = validateParameter(valid_575029, JString, required = true,
                                 default = nil)
  if valid_575029 != nil:
    section.add "api-version", valid_575029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575030: Call_BotConnectionListServiceProviders_575025;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the available Service Providers for creating Connection Settings
  ## 
  let valid = call_575030.validator(path, query, header, formData, body)
  let scheme = call_575030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575030.url(scheme.get, call_575030.host, call_575030.base,
                         call_575030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575030, url, valid)

proc call*(call_575031: Call_BotConnectionListServiceProviders_575025;
          apiVersion: string; subscriptionId: string): Recallable =
  ## botConnectionListServiceProviders
  ## Lists the available Service Providers for creating Connection Settings
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_575032 = newJObject()
  var query_575033 = newJObject()
  add(query_575033, "api-version", newJString(apiVersion))
  add(path_575032, "subscriptionId", newJString(subscriptionId))
  result = call_575031.call(path_575032, query_575033, nil, nil, nil)

var botConnectionListServiceProviders* = Call_BotConnectionListServiceProviders_575025(
    name: "botConnectionListServiceProviders", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.BotService/listAuthServiceProviders",
    validator: validate_BotConnectionListServiceProviders_575026, base: "",
    url: url_BotConnectionListServiceProviders_575027, schemes: {Scheme.Https})
type
  Call_BotsListByResourceGroup_575034 = ref object of OpenApiRestCall_574466
proc url_BotsListByResourceGroup_575036(protocol: Scheme; host: string; base: string;
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

proc validate_BotsListByResourceGroup_575035(path: JsonNode; query: JsonNode;
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
  var valid_575037 = path.getOrDefault("resourceGroupName")
  valid_575037 = validateParameter(valid_575037, JString, required = true,
                                 default = nil)
  if valid_575037 != nil:
    section.add "resourceGroupName", valid_575037
  var valid_575038 = path.getOrDefault("subscriptionId")
  valid_575038 = validateParameter(valid_575038, JString, required = true,
                                 default = nil)
  if valid_575038 != nil:
    section.add "subscriptionId", valid_575038
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575039 = query.getOrDefault("api-version")
  valid_575039 = validateParameter(valid_575039, JString, required = true,
                                 default = nil)
  if valid_575039 != nil:
    section.add "api-version", valid_575039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575040: Call_BotsListByResourceGroup_575034; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all the resources of a particular type belonging to a resource group
  ## 
  let valid = call_575040.validator(path, query, header, formData, body)
  let scheme = call_575040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575040.url(scheme.get, call_575040.host, call_575040.base,
                         call_575040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575040, url, valid)

proc call*(call_575041: Call_BotsListByResourceGroup_575034;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## botsListByResourceGroup
  ## Returns all the resources of a particular type belonging to a resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_575042 = newJObject()
  var query_575043 = newJObject()
  add(path_575042, "resourceGroupName", newJString(resourceGroupName))
  add(query_575043, "api-version", newJString(apiVersion))
  add(path_575042, "subscriptionId", newJString(subscriptionId))
  result = call_575041.call(path_575042, query_575043, nil, nil, nil)

var botsListByResourceGroup* = Call_BotsListByResourceGroup_575034(
    name: "botsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices",
    validator: validate_BotsListByResourceGroup_575035, base: "",
    url: url_BotsListByResourceGroup_575036, schemes: {Scheme.Https})
type
  Call_BotsCreate_575055 = ref object of OpenApiRestCall_574466
proc url_BotsCreate_575057(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_BotsCreate_575056(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575058 = path.getOrDefault("resourceGroupName")
  valid_575058 = validateParameter(valid_575058, JString, required = true,
                                 default = nil)
  if valid_575058 != nil:
    section.add "resourceGroupName", valid_575058
  var valid_575059 = path.getOrDefault("subscriptionId")
  valid_575059 = validateParameter(valid_575059, JString, required = true,
                                 default = nil)
  if valid_575059 != nil:
    section.add "subscriptionId", valid_575059
  var valid_575060 = path.getOrDefault("resourceName")
  valid_575060 = validateParameter(valid_575060, JString, required = true,
                                 default = nil)
  if valid_575060 != nil:
    section.add "resourceName", valid_575060
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575061 = query.getOrDefault("api-version")
  valid_575061 = validateParameter(valid_575061, JString, required = true,
                                 default = nil)
  if valid_575061 != nil:
    section.add "api-version", valid_575061
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

proc call*(call_575063: Call_BotsCreate_575055; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Bot Service. Bot Service is a resource group wide resource type.
  ## 
  let valid = call_575063.validator(path, query, header, formData, body)
  let scheme = call_575063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575063.url(scheme.get, call_575063.host, call_575063.base,
                         call_575063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575063, url, valid)

proc call*(call_575064: Call_BotsCreate_575055; resourceGroupName: string;
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
  var path_575065 = newJObject()
  var query_575066 = newJObject()
  var body_575067 = newJObject()
  add(path_575065, "resourceGroupName", newJString(resourceGroupName))
  add(query_575066, "api-version", newJString(apiVersion))
  add(path_575065, "subscriptionId", newJString(subscriptionId))
  add(path_575065, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_575067 = parameters
  result = call_575064.call(path_575065, query_575066, nil, nil, body_575067)

var botsCreate* = Call_BotsCreate_575055(name: "botsCreate",
                                      meth: HttpMethod.HttpPut,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}",
                                      validator: validate_BotsCreate_575056,
                                      base: "", url: url_BotsCreate_575057,
                                      schemes: {Scheme.Https})
type
  Call_BotsGet_575044 = ref object of OpenApiRestCall_574466
proc url_BotsGet_575046(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_BotsGet_575045(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575047 = path.getOrDefault("resourceGroupName")
  valid_575047 = validateParameter(valid_575047, JString, required = true,
                                 default = nil)
  if valid_575047 != nil:
    section.add "resourceGroupName", valid_575047
  var valid_575048 = path.getOrDefault("subscriptionId")
  valid_575048 = validateParameter(valid_575048, JString, required = true,
                                 default = nil)
  if valid_575048 != nil:
    section.add "subscriptionId", valid_575048
  var valid_575049 = path.getOrDefault("resourceName")
  valid_575049 = validateParameter(valid_575049, JString, required = true,
                                 default = nil)
  if valid_575049 != nil:
    section.add "resourceName", valid_575049
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575050 = query.getOrDefault("api-version")
  valid_575050 = validateParameter(valid_575050, JString, required = true,
                                 default = nil)
  if valid_575050 != nil:
    section.add "api-version", valid_575050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575051: Call_BotsGet_575044; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a BotService specified by the parameters.
  ## 
  let valid = call_575051.validator(path, query, header, formData, body)
  let scheme = call_575051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575051.url(scheme.get, call_575051.host, call_575051.base,
                         call_575051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575051, url, valid)

proc call*(call_575052: Call_BotsGet_575044; resourceGroupName: string;
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
  var path_575053 = newJObject()
  var query_575054 = newJObject()
  add(path_575053, "resourceGroupName", newJString(resourceGroupName))
  add(query_575054, "api-version", newJString(apiVersion))
  add(path_575053, "subscriptionId", newJString(subscriptionId))
  add(path_575053, "resourceName", newJString(resourceName))
  result = call_575052.call(path_575053, query_575054, nil, nil, nil)

var botsGet* = Call_BotsGet_575044(name: "botsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}",
                                validator: validate_BotsGet_575045, base: "",
                                url: url_BotsGet_575046, schemes: {Scheme.Https})
type
  Call_BotsUpdate_575079 = ref object of OpenApiRestCall_574466
proc url_BotsUpdate_575081(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_BotsUpdate_575080(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575082 = path.getOrDefault("resourceGroupName")
  valid_575082 = validateParameter(valid_575082, JString, required = true,
                                 default = nil)
  if valid_575082 != nil:
    section.add "resourceGroupName", valid_575082
  var valid_575083 = path.getOrDefault("subscriptionId")
  valid_575083 = validateParameter(valid_575083, JString, required = true,
                                 default = nil)
  if valid_575083 != nil:
    section.add "subscriptionId", valid_575083
  var valid_575084 = path.getOrDefault("resourceName")
  valid_575084 = validateParameter(valid_575084, JString, required = true,
                                 default = nil)
  if valid_575084 != nil:
    section.add "resourceName", valid_575084
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575085 = query.getOrDefault("api-version")
  valid_575085 = validateParameter(valid_575085, JString, required = true,
                                 default = nil)
  if valid_575085 != nil:
    section.add "api-version", valid_575085
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

proc call*(call_575087: Call_BotsUpdate_575079; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Bot Service
  ## 
  let valid = call_575087.validator(path, query, header, formData, body)
  let scheme = call_575087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575087.url(scheme.get, call_575087.host, call_575087.base,
                         call_575087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575087, url, valid)

proc call*(call_575088: Call_BotsUpdate_575079; resourceGroupName: string;
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
  var path_575089 = newJObject()
  var query_575090 = newJObject()
  var body_575091 = newJObject()
  add(path_575089, "resourceGroupName", newJString(resourceGroupName))
  add(query_575090, "api-version", newJString(apiVersion))
  add(path_575089, "subscriptionId", newJString(subscriptionId))
  add(path_575089, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_575091 = parameters
  result = call_575088.call(path_575089, query_575090, nil, nil, body_575091)

var botsUpdate* = Call_BotsUpdate_575079(name: "botsUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}",
                                      validator: validate_BotsUpdate_575080,
                                      base: "", url: url_BotsUpdate_575081,
                                      schemes: {Scheme.Https})
type
  Call_BotsDelete_575068 = ref object of OpenApiRestCall_574466
proc url_BotsDelete_575070(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_BotsDelete_575069(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575071 = path.getOrDefault("resourceGroupName")
  valid_575071 = validateParameter(valid_575071, JString, required = true,
                                 default = nil)
  if valid_575071 != nil:
    section.add "resourceGroupName", valid_575071
  var valid_575072 = path.getOrDefault("subscriptionId")
  valid_575072 = validateParameter(valid_575072, JString, required = true,
                                 default = nil)
  if valid_575072 != nil:
    section.add "subscriptionId", valid_575072
  var valid_575073 = path.getOrDefault("resourceName")
  valid_575073 = validateParameter(valid_575073, JString, required = true,
                                 default = nil)
  if valid_575073 != nil:
    section.add "resourceName", valid_575073
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575074 = query.getOrDefault("api-version")
  valid_575074 = validateParameter(valid_575074, JString, required = true,
                                 default = nil)
  if valid_575074 != nil:
    section.add "api-version", valid_575074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575075: Call_BotsDelete_575068; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Bot Service from the resource group. 
  ## 
  let valid = call_575075.validator(path, query, header, formData, body)
  let scheme = call_575075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575075.url(scheme.get, call_575075.host, call_575075.base,
                         call_575075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575075, url, valid)

proc call*(call_575076: Call_BotsDelete_575068; resourceGroupName: string;
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
  var path_575077 = newJObject()
  var query_575078 = newJObject()
  add(path_575077, "resourceGroupName", newJString(resourceGroupName))
  add(query_575078, "api-version", newJString(apiVersion))
  add(path_575077, "subscriptionId", newJString(subscriptionId))
  add(path_575077, "resourceName", newJString(resourceName))
  result = call_575076.call(path_575077, query_575078, nil, nil, nil)

var botsDelete* = Call_BotsDelete_575068(name: "botsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}",
                                      validator: validate_BotsDelete_575069,
                                      base: "", url: url_BotsDelete_575070,
                                      schemes: {Scheme.Https})
type
  Call_BotConnectionCreate_575104 = ref object of OpenApiRestCall_574466
proc url_BotConnectionCreate_575106(protocol: Scheme; host: string; base: string;
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

proc validate_BotConnectionCreate_575105(path: JsonNode; query: JsonNode;
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
  var valid_575107 = path.getOrDefault("resourceGroupName")
  valid_575107 = validateParameter(valid_575107, JString, required = true,
                                 default = nil)
  if valid_575107 != nil:
    section.add "resourceGroupName", valid_575107
  var valid_575108 = path.getOrDefault("subscriptionId")
  valid_575108 = validateParameter(valid_575108, JString, required = true,
                                 default = nil)
  if valid_575108 != nil:
    section.add "subscriptionId", valid_575108
  var valid_575109 = path.getOrDefault("resourceName")
  valid_575109 = validateParameter(valid_575109, JString, required = true,
                                 default = nil)
  if valid_575109 != nil:
    section.add "resourceName", valid_575109
  var valid_575110 = path.getOrDefault("connectionName")
  valid_575110 = validateParameter(valid_575110, JString, required = true,
                                 default = nil)
  if valid_575110 != nil:
    section.add "connectionName", valid_575110
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575111 = query.getOrDefault("api-version")
  valid_575111 = validateParameter(valid_575111, JString, required = true,
                                 default = nil)
  if valid_575111 != nil:
    section.add "api-version", valid_575111
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

proc call*(call_575113: Call_BotConnectionCreate_575104; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Register a new Auth Connection for a Bot Service
  ## 
  let valid = call_575113.validator(path, query, header, formData, body)
  let scheme = call_575113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575113.url(scheme.get, call_575113.host, call_575113.base,
                         call_575113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575113, url, valid)

proc call*(call_575114: Call_BotConnectionCreate_575104; resourceGroupName: string;
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
  var path_575115 = newJObject()
  var query_575116 = newJObject()
  var body_575117 = newJObject()
  add(path_575115, "resourceGroupName", newJString(resourceGroupName))
  add(query_575116, "api-version", newJString(apiVersion))
  add(path_575115, "subscriptionId", newJString(subscriptionId))
  add(path_575115, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_575117 = parameters
  add(path_575115, "connectionName", newJString(connectionName))
  result = call_575114.call(path_575115, query_575116, nil, nil, body_575117)

var botConnectionCreate* = Call_BotConnectionCreate_575104(
    name: "botConnectionCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/Connections/{connectionName}",
    validator: validate_BotConnectionCreate_575105, base: "",
    url: url_BotConnectionCreate_575106, schemes: {Scheme.Https})
type
  Call_BotConnectionGet_575092 = ref object of OpenApiRestCall_574466
proc url_BotConnectionGet_575094(protocol: Scheme; host: string; base: string;
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

proc validate_BotConnectionGet_575093(path: JsonNode; query: JsonNode;
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
  var valid_575095 = path.getOrDefault("resourceGroupName")
  valid_575095 = validateParameter(valid_575095, JString, required = true,
                                 default = nil)
  if valid_575095 != nil:
    section.add "resourceGroupName", valid_575095
  var valid_575096 = path.getOrDefault("subscriptionId")
  valid_575096 = validateParameter(valid_575096, JString, required = true,
                                 default = nil)
  if valid_575096 != nil:
    section.add "subscriptionId", valid_575096
  var valid_575097 = path.getOrDefault("resourceName")
  valid_575097 = validateParameter(valid_575097, JString, required = true,
                                 default = nil)
  if valid_575097 != nil:
    section.add "resourceName", valid_575097
  var valid_575098 = path.getOrDefault("connectionName")
  valid_575098 = validateParameter(valid_575098, JString, required = true,
                                 default = nil)
  if valid_575098 != nil:
    section.add "connectionName", valid_575098
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575099 = query.getOrDefault("api-version")
  valid_575099 = validateParameter(valid_575099, JString, required = true,
                                 default = nil)
  if valid_575099 != nil:
    section.add "api-version", valid_575099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575100: Call_BotConnectionGet_575092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Connection Setting registration for a Bot Service
  ## 
  let valid = call_575100.validator(path, query, header, formData, body)
  let scheme = call_575100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575100.url(scheme.get, call_575100.host, call_575100.base,
                         call_575100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575100, url, valid)

proc call*(call_575101: Call_BotConnectionGet_575092; resourceGroupName: string;
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
  var path_575102 = newJObject()
  var query_575103 = newJObject()
  add(path_575102, "resourceGroupName", newJString(resourceGroupName))
  add(query_575103, "api-version", newJString(apiVersion))
  add(path_575102, "subscriptionId", newJString(subscriptionId))
  add(path_575102, "resourceName", newJString(resourceName))
  add(path_575102, "connectionName", newJString(connectionName))
  result = call_575101.call(path_575102, query_575103, nil, nil, nil)

var botConnectionGet* = Call_BotConnectionGet_575092(name: "botConnectionGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/Connections/{connectionName}",
    validator: validate_BotConnectionGet_575093, base: "",
    url: url_BotConnectionGet_575094, schemes: {Scheme.Https})
type
  Call_BotConnectionUpdate_575130 = ref object of OpenApiRestCall_574466
proc url_BotConnectionUpdate_575132(protocol: Scheme; host: string; base: string;
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

proc validate_BotConnectionUpdate_575131(path: JsonNode; query: JsonNode;
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
  var valid_575133 = path.getOrDefault("resourceGroupName")
  valid_575133 = validateParameter(valid_575133, JString, required = true,
                                 default = nil)
  if valid_575133 != nil:
    section.add "resourceGroupName", valid_575133
  var valid_575134 = path.getOrDefault("subscriptionId")
  valid_575134 = validateParameter(valid_575134, JString, required = true,
                                 default = nil)
  if valid_575134 != nil:
    section.add "subscriptionId", valid_575134
  var valid_575135 = path.getOrDefault("resourceName")
  valid_575135 = validateParameter(valid_575135, JString, required = true,
                                 default = nil)
  if valid_575135 != nil:
    section.add "resourceName", valid_575135
  var valid_575136 = path.getOrDefault("connectionName")
  valid_575136 = validateParameter(valid_575136, JString, required = true,
                                 default = nil)
  if valid_575136 != nil:
    section.add "connectionName", valid_575136
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575137 = query.getOrDefault("api-version")
  valid_575137 = validateParameter(valid_575137, JString, required = true,
                                 default = nil)
  if valid_575137 != nil:
    section.add "api-version", valid_575137
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

proc call*(call_575139: Call_BotConnectionUpdate_575130; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Connection Setting registration for a Bot Service
  ## 
  let valid = call_575139.validator(path, query, header, formData, body)
  let scheme = call_575139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575139.url(scheme.get, call_575139.host, call_575139.base,
                         call_575139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575139, url, valid)

proc call*(call_575140: Call_BotConnectionUpdate_575130; resourceGroupName: string;
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
  var path_575141 = newJObject()
  var query_575142 = newJObject()
  var body_575143 = newJObject()
  add(path_575141, "resourceGroupName", newJString(resourceGroupName))
  add(query_575142, "api-version", newJString(apiVersion))
  add(path_575141, "subscriptionId", newJString(subscriptionId))
  add(path_575141, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_575143 = parameters
  add(path_575141, "connectionName", newJString(connectionName))
  result = call_575140.call(path_575141, query_575142, nil, nil, body_575143)

var botConnectionUpdate* = Call_BotConnectionUpdate_575130(
    name: "botConnectionUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/Connections/{connectionName}",
    validator: validate_BotConnectionUpdate_575131, base: "",
    url: url_BotConnectionUpdate_575132, schemes: {Scheme.Https})
type
  Call_BotConnectionDelete_575118 = ref object of OpenApiRestCall_574466
proc url_BotConnectionDelete_575120(protocol: Scheme; host: string; base: string;
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

proc validate_BotConnectionDelete_575119(path: JsonNode; query: JsonNode;
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
  var valid_575121 = path.getOrDefault("resourceGroupName")
  valid_575121 = validateParameter(valid_575121, JString, required = true,
                                 default = nil)
  if valid_575121 != nil:
    section.add "resourceGroupName", valid_575121
  var valid_575122 = path.getOrDefault("subscriptionId")
  valid_575122 = validateParameter(valid_575122, JString, required = true,
                                 default = nil)
  if valid_575122 != nil:
    section.add "subscriptionId", valid_575122
  var valid_575123 = path.getOrDefault("resourceName")
  valid_575123 = validateParameter(valid_575123, JString, required = true,
                                 default = nil)
  if valid_575123 != nil:
    section.add "resourceName", valid_575123
  var valid_575124 = path.getOrDefault("connectionName")
  valid_575124 = validateParameter(valid_575124, JString, required = true,
                                 default = nil)
  if valid_575124 != nil:
    section.add "connectionName", valid_575124
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575125 = query.getOrDefault("api-version")
  valid_575125 = validateParameter(valid_575125, JString, required = true,
                                 default = nil)
  if valid_575125 != nil:
    section.add "api-version", valid_575125
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575126: Call_BotConnectionDelete_575118; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Connection Setting registration for a Bot Service
  ## 
  let valid = call_575126.validator(path, query, header, formData, body)
  let scheme = call_575126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575126.url(scheme.get, call_575126.host, call_575126.base,
                         call_575126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575126, url, valid)

proc call*(call_575127: Call_BotConnectionDelete_575118; resourceGroupName: string;
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
  var path_575128 = newJObject()
  var query_575129 = newJObject()
  add(path_575128, "resourceGroupName", newJString(resourceGroupName))
  add(query_575129, "api-version", newJString(apiVersion))
  add(path_575128, "subscriptionId", newJString(subscriptionId))
  add(path_575128, "resourceName", newJString(resourceName))
  add(path_575128, "connectionName", newJString(connectionName))
  result = call_575127.call(path_575128, query_575129, nil, nil, nil)

var botConnectionDelete* = Call_BotConnectionDelete_575118(
    name: "botConnectionDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/Connections/{connectionName}",
    validator: validate_BotConnectionDelete_575119, base: "",
    url: url_BotConnectionDelete_575120, schemes: {Scheme.Https})
type
  Call_BotConnectionListWithSecrets_575144 = ref object of OpenApiRestCall_574466
proc url_BotConnectionListWithSecrets_575146(protocol: Scheme; host: string;
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

proc validate_BotConnectionListWithSecrets_575145(path: JsonNode; query: JsonNode;
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
  var valid_575147 = path.getOrDefault("resourceGroupName")
  valid_575147 = validateParameter(valid_575147, JString, required = true,
                                 default = nil)
  if valid_575147 != nil:
    section.add "resourceGroupName", valid_575147
  var valid_575148 = path.getOrDefault("subscriptionId")
  valid_575148 = validateParameter(valid_575148, JString, required = true,
                                 default = nil)
  if valid_575148 != nil:
    section.add "subscriptionId", valid_575148
  var valid_575149 = path.getOrDefault("resourceName")
  valid_575149 = validateParameter(valid_575149, JString, required = true,
                                 default = nil)
  if valid_575149 != nil:
    section.add "resourceName", valid_575149
  var valid_575150 = path.getOrDefault("connectionName")
  valid_575150 = validateParameter(valid_575150, JString, required = true,
                                 default = nil)
  if valid_575150 != nil:
    section.add "connectionName", valid_575150
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575151 = query.getOrDefault("api-version")
  valid_575151 = validateParameter(valid_575151, JString, required = true,
                                 default = nil)
  if valid_575151 != nil:
    section.add "api-version", valid_575151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575152: Call_BotConnectionListWithSecrets_575144; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Connection Setting registration for a Bot Service
  ## 
  let valid = call_575152.validator(path, query, header, formData, body)
  let scheme = call_575152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575152.url(scheme.get, call_575152.host, call_575152.base,
                         call_575152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575152, url, valid)

proc call*(call_575153: Call_BotConnectionListWithSecrets_575144;
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
  var path_575154 = newJObject()
  var query_575155 = newJObject()
  add(path_575154, "resourceGroupName", newJString(resourceGroupName))
  add(query_575155, "api-version", newJString(apiVersion))
  add(path_575154, "subscriptionId", newJString(subscriptionId))
  add(path_575154, "resourceName", newJString(resourceName))
  add(path_575154, "connectionName", newJString(connectionName))
  result = call_575153.call(path_575154, query_575155, nil, nil, nil)

var botConnectionListWithSecrets* = Call_BotConnectionListWithSecrets_575144(
    name: "botConnectionListWithSecrets", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/Connections/{connectionName}/listWithSecrets",
    validator: validate_BotConnectionListWithSecrets_575145, base: "",
    url: url_BotConnectionListWithSecrets_575146, schemes: {Scheme.Https})
type
  Call_ChannelsListByResourceGroup_575156 = ref object of OpenApiRestCall_574466
proc url_ChannelsListByResourceGroup_575158(protocol: Scheme; host: string;
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

proc validate_ChannelsListByResourceGroup_575157(path: JsonNode; query: JsonNode;
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
  var valid_575159 = path.getOrDefault("resourceGroupName")
  valid_575159 = validateParameter(valid_575159, JString, required = true,
                                 default = nil)
  if valid_575159 != nil:
    section.add "resourceGroupName", valid_575159
  var valid_575160 = path.getOrDefault("subscriptionId")
  valid_575160 = validateParameter(valid_575160, JString, required = true,
                                 default = nil)
  if valid_575160 != nil:
    section.add "subscriptionId", valid_575160
  var valid_575161 = path.getOrDefault("resourceName")
  valid_575161 = validateParameter(valid_575161, JString, required = true,
                                 default = nil)
  if valid_575161 != nil:
    section.add "resourceName", valid_575161
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575162 = query.getOrDefault("api-version")
  valid_575162 = validateParameter(valid_575162, JString, required = true,
                                 default = nil)
  if valid_575162 != nil:
    section.add "api-version", valid_575162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575163: Call_ChannelsListByResourceGroup_575156; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all the Channel registrations of a particular BotService resource
  ## 
  let valid = call_575163.validator(path, query, header, formData, body)
  let scheme = call_575163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575163.url(scheme.get, call_575163.host, call_575163.base,
                         call_575163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575163, url, valid)

proc call*(call_575164: Call_ChannelsListByResourceGroup_575156;
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
  var path_575165 = newJObject()
  var query_575166 = newJObject()
  add(path_575165, "resourceGroupName", newJString(resourceGroupName))
  add(query_575166, "api-version", newJString(apiVersion))
  add(path_575165, "subscriptionId", newJString(subscriptionId))
  add(path_575165, "resourceName", newJString(resourceName))
  result = call_575164.call(path_575165, query_575166, nil, nil, nil)

var channelsListByResourceGroup* = Call_ChannelsListByResourceGroup_575156(
    name: "channelsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/channels",
    validator: validate_ChannelsListByResourceGroup_575157, base: "",
    url: url_ChannelsListByResourceGroup_575158, schemes: {Scheme.Https})
type
  Call_ChannelsCreate_575179 = ref object of OpenApiRestCall_574466
proc url_ChannelsCreate_575181(protocol: Scheme; host: string; base: string;
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

proc validate_ChannelsCreate_575180(path: JsonNode; query: JsonNode;
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
  var valid_575182 = path.getOrDefault("resourceGroupName")
  valid_575182 = validateParameter(valid_575182, JString, required = true,
                                 default = nil)
  if valid_575182 != nil:
    section.add "resourceGroupName", valid_575182
  var valid_575183 = path.getOrDefault("subscriptionId")
  valid_575183 = validateParameter(valid_575183, JString, required = true,
                                 default = nil)
  if valid_575183 != nil:
    section.add "subscriptionId", valid_575183
  var valid_575197 = path.getOrDefault("channelName")
  valid_575197 = validateParameter(valid_575197, JString, required = true,
                                 default = newJString("FacebookChannel"))
  if valid_575197 != nil:
    section.add "channelName", valid_575197
  var valid_575198 = path.getOrDefault("resourceName")
  valid_575198 = validateParameter(valid_575198, JString, required = true,
                                 default = nil)
  if valid_575198 != nil:
    section.add "resourceName", valid_575198
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575199 = query.getOrDefault("api-version")
  valid_575199 = validateParameter(valid_575199, JString, required = true,
                                 default = nil)
  if valid_575199 != nil:
    section.add "api-version", valid_575199
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

proc call*(call_575201: Call_ChannelsCreate_575179; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Channel registration for a Bot Service
  ## 
  let valid = call_575201.validator(path, query, header, formData, body)
  let scheme = call_575201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575201.url(scheme.get, call_575201.host, call_575201.base,
                         call_575201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575201, url, valid)

proc call*(call_575202: Call_ChannelsCreate_575179; resourceGroupName: string;
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
  var path_575203 = newJObject()
  var query_575204 = newJObject()
  var body_575205 = newJObject()
  add(path_575203, "resourceGroupName", newJString(resourceGroupName))
  add(query_575204, "api-version", newJString(apiVersion))
  add(path_575203, "subscriptionId", newJString(subscriptionId))
  add(path_575203, "channelName", newJString(channelName))
  add(path_575203, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_575205 = parameters
  result = call_575202.call(path_575203, query_575204, nil, nil, body_575205)

var channelsCreate* = Call_ChannelsCreate_575179(name: "channelsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/channels/{channelName}",
    validator: validate_ChannelsCreate_575180, base: "", url: url_ChannelsCreate_575181,
    schemes: {Scheme.Https})
type
  Call_ChannelsGet_575167 = ref object of OpenApiRestCall_574466
proc url_ChannelsGet_575169(protocol: Scheme; host: string; base: string;
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

proc validate_ChannelsGet_575168(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575170 = path.getOrDefault("resourceGroupName")
  valid_575170 = validateParameter(valid_575170, JString, required = true,
                                 default = nil)
  if valid_575170 != nil:
    section.add "resourceGroupName", valid_575170
  var valid_575171 = path.getOrDefault("subscriptionId")
  valid_575171 = validateParameter(valid_575171, JString, required = true,
                                 default = nil)
  if valid_575171 != nil:
    section.add "subscriptionId", valid_575171
  var valid_575172 = path.getOrDefault("channelName")
  valid_575172 = validateParameter(valid_575172, JString, required = true,
                                 default = nil)
  if valid_575172 != nil:
    section.add "channelName", valid_575172
  var valid_575173 = path.getOrDefault("resourceName")
  valid_575173 = validateParameter(valid_575173, JString, required = true,
                                 default = nil)
  if valid_575173 != nil:
    section.add "resourceName", valid_575173
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575174 = query.getOrDefault("api-version")
  valid_575174 = validateParameter(valid_575174, JString, required = true,
                                 default = nil)
  if valid_575174 != nil:
    section.add "api-version", valid_575174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575175: Call_ChannelsGet_575167; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a BotService Channel registration specified by the parameters.
  ## 
  let valid = call_575175.validator(path, query, header, formData, body)
  let scheme = call_575175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575175.url(scheme.get, call_575175.host, call_575175.base,
                         call_575175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575175, url, valid)

proc call*(call_575176: Call_ChannelsGet_575167; resourceGroupName: string;
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
  var path_575177 = newJObject()
  var query_575178 = newJObject()
  add(path_575177, "resourceGroupName", newJString(resourceGroupName))
  add(query_575178, "api-version", newJString(apiVersion))
  add(path_575177, "subscriptionId", newJString(subscriptionId))
  add(path_575177, "channelName", newJString(channelName))
  add(path_575177, "resourceName", newJString(resourceName))
  result = call_575176.call(path_575177, query_575178, nil, nil, nil)

var channelsGet* = Call_ChannelsGet_575167(name: "channelsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/channels/{channelName}",
                                        validator: validate_ChannelsGet_575168,
                                        base: "", url: url_ChannelsGet_575169,
                                        schemes: {Scheme.Https})
type
  Call_ChannelsUpdate_575218 = ref object of OpenApiRestCall_574466
proc url_ChannelsUpdate_575220(protocol: Scheme; host: string; base: string;
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

proc validate_ChannelsUpdate_575219(path: JsonNode; query: JsonNode;
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
  var valid_575221 = path.getOrDefault("resourceGroupName")
  valid_575221 = validateParameter(valid_575221, JString, required = true,
                                 default = nil)
  if valid_575221 != nil:
    section.add "resourceGroupName", valid_575221
  var valid_575222 = path.getOrDefault("subscriptionId")
  valid_575222 = validateParameter(valid_575222, JString, required = true,
                                 default = nil)
  if valid_575222 != nil:
    section.add "subscriptionId", valid_575222
  var valid_575223 = path.getOrDefault("channelName")
  valid_575223 = validateParameter(valid_575223, JString, required = true,
                                 default = newJString("FacebookChannel"))
  if valid_575223 != nil:
    section.add "channelName", valid_575223
  var valid_575224 = path.getOrDefault("resourceName")
  valid_575224 = validateParameter(valid_575224, JString, required = true,
                                 default = nil)
  if valid_575224 != nil:
    section.add "resourceName", valid_575224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575225 = query.getOrDefault("api-version")
  valid_575225 = validateParameter(valid_575225, JString, required = true,
                                 default = nil)
  if valid_575225 != nil:
    section.add "api-version", valid_575225
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

proc call*(call_575227: Call_ChannelsUpdate_575218; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Channel registration for a Bot Service
  ## 
  let valid = call_575227.validator(path, query, header, formData, body)
  let scheme = call_575227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575227.url(scheme.get, call_575227.host, call_575227.base,
                         call_575227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575227, url, valid)

proc call*(call_575228: Call_ChannelsUpdate_575218; resourceGroupName: string;
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
  var path_575229 = newJObject()
  var query_575230 = newJObject()
  var body_575231 = newJObject()
  add(path_575229, "resourceGroupName", newJString(resourceGroupName))
  add(query_575230, "api-version", newJString(apiVersion))
  add(path_575229, "subscriptionId", newJString(subscriptionId))
  add(path_575229, "channelName", newJString(channelName))
  add(path_575229, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_575231 = parameters
  result = call_575228.call(path_575229, query_575230, nil, nil, body_575231)

var channelsUpdate* = Call_ChannelsUpdate_575218(name: "channelsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/channels/{channelName}",
    validator: validate_ChannelsUpdate_575219, base: "", url: url_ChannelsUpdate_575220,
    schemes: {Scheme.Https})
type
  Call_ChannelsDelete_575206 = ref object of OpenApiRestCall_574466
proc url_ChannelsDelete_575208(protocol: Scheme; host: string; base: string;
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

proc validate_ChannelsDelete_575207(path: JsonNode; query: JsonNode;
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
  var valid_575209 = path.getOrDefault("resourceGroupName")
  valid_575209 = validateParameter(valid_575209, JString, required = true,
                                 default = nil)
  if valid_575209 != nil:
    section.add "resourceGroupName", valid_575209
  var valid_575210 = path.getOrDefault("subscriptionId")
  valid_575210 = validateParameter(valid_575210, JString, required = true,
                                 default = nil)
  if valid_575210 != nil:
    section.add "subscriptionId", valid_575210
  var valid_575211 = path.getOrDefault("channelName")
  valid_575211 = validateParameter(valid_575211, JString, required = true,
                                 default = nil)
  if valid_575211 != nil:
    section.add "channelName", valid_575211
  var valid_575212 = path.getOrDefault("resourceName")
  valid_575212 = validateParameter(valid_575212, JString, required = true,
                                 default = nil)
  if valid_575212 != nil:
    section.add "resourceName", valid_575212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575213 = query.getOrDefault("api-version")
  valid_575213 = validateParameter(valid_575213, JString, required = true,
                                 default = nil)
  if valid_575213 != nil:
    section.add "api-version", valid_575213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575214: Call_ChannelsDelete_575206; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Channel registration from a Bot Service
  ## 
  let valid = call_575214.validator(path, query, header, formData, body)
  let scheme = call_575214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575214.url(scheme.get, call_575214.host, call_575214.base,
                         call_575214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575214, url, valid)

proc call*(call_575215: Call_ChannelsDelete_575206; resourceGroupName: string;
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
  var path_575216 = newJObject()
  var query_575217 = newJObject()
  add(path_575216, "resourceGroupName", newJString(resourceGroupName))
  add(query_575217, "api-version", newJString(apiVersion))
  add(path_575216, "subscriptionId", newJString(subscriptionId))
  add(path_575216, "channelName", newJString(channelName))
  add(path_575216, "resourceName", newJString(resourceName))
  result = call_575215.call(path_575216, query_575217, nil, nil, nil)

var channelsDelete* = Call_ChannelsDelete_575206(name: "channelsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/channels/{channelName}",
    validator: validate_ChannelsDelete_575207, base: "", url: url_ChannelsDelete_575208,
    schemes: {Scheme.Https})
type
  Call_ChannelsListWithKeys_575232 = ref object of OpenApiRestCall_574466
proc url_ChannelsListWithKeys_575234(protocol: Scheme; host: string; base: string;
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

proc validate_ChannelsListWithKeys_575233(path: JsonNode; query: JsonNode;
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
  var valid_575235 = path.getOrDefault("resourceGroupName")
  valid_575235 = validateParameter(valid_575235, JString, required = true,
                                 default = nil)
  if valid_575235 != nil:
    section.add "resourceGroupName", valid_575235
  var valid_575236 = path.getOrDefault("subscriptionId")
  valid_575236 = validateParameter(valid_575236, JString, required = true,
                                 default = nil)
  if valid_575236 != nil:
    section.add "subscriptionId", valid_575236
  var valid_575237 = path.getOrDefault("channelName")
  valid_575237 = validateParameter(valid_575237, JString, required = true,
                                 default = newJString("FacebookChannel"))
  if valid_575237 != nil:
    section.add "channelName", valid_575237
  var valid_575238 = path.getOrDefault("resourceName")
  valid_575238 = validateParameter(valid_575238, JString, required = true,
                                 default = nil)
  if valid_575238 != nil:
    section.add "resourceName", valid_575238
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
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
  if body != nil:
    result.add "body", body

proc call*(call_575240: Call_ChannelsListWithKeys_575232; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a Channel registration for a Bot Service including secrets
  ## 
  let valid = call_575240.validator(path, query, header, formData, body)
  let scheme = call_575240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575240.url(scheme.get, call_575240.host, call_575240.base,
                         call_575240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575240, url, valid)

proc call*(call_575241: Call_ChannelsListWithKeys_575232;
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
  var path_575242 = newJObject()
  var query_575243 = newJObject()
  add(path_575242, "resourceGroupName", newJString(resourceGroupName))
  add(query_575243, "api-version", newJString(apiVersion))
  add(path_575242, "subscriptionId", newJString(subscriptionId))
  add(path_575242, "channelName", newJString(channelName))
  add(path_575242, "resourceName", newJString(resourceName))
  result = call_575241.call(path_575242, query_575243, nil, nil, nil)

var channelsListWithKeys* = Call_ChannelsListWithKeys_575232(
    name: "channelsListWithKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/channels/{channelName}/listChannelWithKeys",
    validator: validate_ChannelsListWithKeys_575233, base: "",
    url: url_ChannelsListWithKeys_575234, schemes: {Scheme.Https})
type
  Call_BotConnectionListByBotService_575244 = ref object of OpenApiRestCall_574466
proc url_BotConnectionListByBotService_575246(protocol: Scheme; host: string;
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

proc validate_BotConnectionListByBotService_575245(path: JsonNode; query: JsonNode;
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
  var valid_575247 = path.getOrDefault("resourceGroupName")
  valid_575247 = validateParameter(valid_575247, JString, required = true,
                                 default = nil)
  if valid_575247 != nil:
    section.add "resourceGroupName", valid_575247
  var valid_575248 = path.getOrDefault("subscriptionId")
  valid_575248 = validateParameter(valid_575248, JString, required = true,
                                 default = nil)
  if valid_575248 != nil:
    section.add "subscriptionId", valid_575248
  var valid_575249 = path.getOrDefault("resourceName")
  valid_575249 = validateParameter(valid_575249, JString, required = true,
                                 default = nil)
  if valid_575249 != nil:
    section.add "resourceName", valid_575249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575250 = query.getOrDefault("api-version")
  valid_575250 = validateParameter(valid_575250, JString, required = true,
                                 default = nil)
  if valid_575250 != nil:
    section.add "api-version", valid_575250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575251: Call_BotConnectionListByBotService_575244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all the Connection Settings registered to a particular BotService resource
  ## 
  let valid = call_575251.validator(path, query, header, formData, body)
  let scheme = call_575251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575251.url(scheme.get, call_575251.host, call_575251.base,
                         call_575251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575251, url, valid)

proc call*(call_575252: Call_BotConnectionListByBotService_575244;
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
  var path_575253 = newJObject()
  var query_575254 = newJObject()
  add(path_575253, "resourceGroupName", newJString(resourceGroupName))
  add(query_575254, "api-version", newJString(apiVersion))
  add(path_575253, "subscriptionId", newJString(subscriptionId))
  add(path_575253, "resourceName", newJString(resourceName))
  result = call_575252.call(path_575253, query_575254, nil, nil, nil)

var botConnectionListByBotService* = Call_BotConnectionListByBotService_575244(
    name: "botConnectionListByBotService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/botServices/{resourceName}/connections",
    validator: validate_BotConnectionListByBotService_575245, base: "",
    url: url_BotConnectionListByBotService_575246, schemes: {Scheme.Https})
type
  Call_EnterpriseChannelsListByResourceGroup_575255 = ref object of OpenApiRestCall_574466
proc url_EnterpriseChannelsListByResourceGroup_575257(protocol: Scheme;
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

proc validate_EnterpriseChannelsListByResourceGroup_575256(path: JsonNode;
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
  var valid_575258 = path.getOrDefault("resourceGroupName")
  valid_575258 = validateParameter(valid_575258, JString, required = true,
                                 default = nil)
  if valid_575258 != nil:
    section.add "resourceGroupName", valid_575258
  var valid_575259 = path.getOrDefault("subscriptionId")
  valid_575259 = validateParameter(valid_575259, JString, required = true,
                                 default = nil)
  if valid_575259 != nil:
    section.add "subscriptionId", valid_575259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575260 = query.getOrDefault("api-version")
  valid_575260 = validateParameter(valid_575260, JString, required = true,
                                 default = nil)
  if valid_575260 != nil:
    section.add "api-version", valid_575260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575261: Call_EnterpriseChannelsListByResourceGroup_575255;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns all the resources of a particular type belonging to a resource group.
  ## 
  let valid = call_575261.validator(path, query, header, formData, body)
  let scheme = call_575261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575261.url(scheme.get, call_575261.host, call_575261.base,
                         call_575261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575261, url, valid)

proc call*(call_575262: Call_EnterpriseChannelsListByResourceGroup_575255;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## enterpriseChannelsListByResourceGroup
  ## Returns all the resources of a particular type belonging to a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Bot resource group in the user subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_575263 = newJObject()
  var query_575264 = newJObject()
  add(path_575263, "resourceGroupName", newJString(resourceGroupName))
  add(query_575264, "api-version", newJString(apiVersion))
  add(path_575263, "subscriptionId", newJString(subscriptionId))
  result = call_575262.call(path_575263, query_575264, nil, nil, nil)

var enterpriseChannelsListByResourceGroup* = Call_EnterpriseChannelsListByResourceGroup_575255(
    name: "enterpriseChannelsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/enterpriseChannels",
    validator: validate_EnterpriseChannelsListByResourceGroup_575256, base: "",
    url: url_EnterpriseChannelsListByResourceGroup_575257, schemes: {Scheme.Https})
type
  Call_EnterpriseChannelsCreate_575276 = ref object of OpenApiRestCall_574466
proc url_EnterpriseChannelsCreate_575278(protocol: Scheme; host: string;
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

proc validate_EnterpriseChannelsCreate_575277(path: JsonNode; query: JsonNode;
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
  var valid_575279 = path.getOrDefault("resourceGroupName")
  valid_575279 = validateParameter(valid_575279, JString, required = true,
                                 default = nil)
  if valid_575279 != nil:
    section.add "resourceGroupName", valid_575279
  var valid_575280 = path.getOrDefault("subscriptionId")
  valid_575280 = validateParameter(valid_575280, JString, required = true,
                                 default = nil)
  if valid_575280 != nil:
    section.add "subscriptionId", valid_575280
  var valid_575281 = path.getOrDefault("resourceName")
  valid_575281 = validateParameter(valid_575281, JString, required = true,
                                 default = nil)
  if valid_575281 != nil:
    section.add "resourceName", valid_575281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575282 = query.getOrDefault("api-version")
  valid_575282 = validateParameter(valid_575282, JString, required = true,
                                 default = nil)
  if valid_575282 != nil:
    section.add "api-version", valid_575282
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

proc call*(call_575284: Call_EnterpriseChannelsCreate_575276; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an Enterprise Channel.
  ## 
  let valid = call_575284.validator(path, query, header, formData, body)
  let scheme = call_575284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575284.url(scheme.get, call_575284.host, call_575284.base,
                         call_575284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575284, url, valid)

proc call*(call_575285: Call_EnterpriseChannelsCreate_575276;
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
  var path_575286 = newJObject()
  var query_575287 = newJObject()
  var body_575288 = newJObject()
  add(path_575286, "resourceGroupName", newJString(resourceGroupName))
  add(query_575287, "api-version", newJString(apiVersion))
  add(path_575286, "subscriptionId", newJString(subscriptionId))
  add(path_575286, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_575288 = parameters
  result = call_575285.call(path_575286, query_575287, nil, nil, body_575288)

var enterpriseChannelsCreate* = Call_EnterpriseChannelsCreate_575276(
    name: "enterpriseChannelsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/enterpriseChannels/{resourceName}",
    validator: validate_EnterpriseChannelsCreate_575277, base: "",
    url: url_EnterpriseChannelsCreate_575278, schemes: {Scheme.Https})
type
  Call_EnterpriseChannelsGet_575265 = ref object of OpenApiRestCall_574466
proc url_EnterpriseChannelsGet_575267(protocol: Scheme; host: string; base: string;
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

proc validate_EnterpriseChannelsGet_575266(path: JsonNode; query: JsonNode;
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
  var valid_575268 = path.getOrDefault("resourceGroupName")
  valid_575268 = validateParameter(valid_575268, JString, required = true,
                                 default = nil)
  if valid_575268 != nil:
    section.add "resourceGroupName", valid_575268
  var valid_575269 = path.getOrDefault("subscriptionId")
  valid_575269 = validateParameter(valid_575269, JString, required = true,
                                 default = nil)
  if valid_575269 != nil:
    section.add "subscriptionId", valid_575269
  var valid_575270 = path.getOrDefault("resourceName")
  valid_575270 = validateParameter(valid_575270, JString, required = true,
                                 default = nil)
  if valid_575270 != nil:
    section.add "resourceName", valid_575270
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575271 = query.getOrDefault("api-version")
  valid_575271 = validateParameter(valid_575271, JString, required = true,
                                 default = nil)
  if valid_575271 != nil:
    section.add "api-version", valid_575271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575272: Call_EnterpriseChannelsGet_575265; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns an Enterprise Channel specified by the parameters.
  ## 
  let valid = call_575272.validator(path, query, header, formData, body)
  let scheme = call_575272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575272.url(scheme.get, call_575272.host, call_575272.base,
                         call_575272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575272, url, valid)

proc call*(call_575273: Call_EnterpriseChannelsGet_575265;
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
  var path_575274 = newJObject()
  var query_575275 = newJObject()
  add(path_575274, "resourceGroupName", newJString(resourceGroupName))
  add(query_575275, "api-version", newJString(apiVersion))
  add(path_575274, "subscriptionId", newJString(subscriptionId))
  add(path_575274, "resourceName", newJString(resourceName))
  result = call_575273.call(path_575274, query_575275, nil, nil, nil)

var enterpriseChannelsGet* = Call_EnterpriseChannelsGet_575265(
    name: "enterpriseChannelsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/enterpriseChannels/{resourceName}",
    validator: validate_EnterpriseChannelsGet_575266, base: "",
    url: url_EnterpriseChannelsGet_575267, schemes: {Scheme.Https})
type
  Call_EnterpriseChannelsUpdate_575300 = ref object of OpenApiRestCall_574466
proc url_EnterpriseChannelsUpdate_575302(protocol: Scheme; host: string;
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

proc validate_EnterpriseChannelsUpdate_575301(path: JsonNode; query: JsonNode;
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
  var valid_575303 = path.getOrDefault("resourceGroupName")
  valid_575303 = validateParameter(valid_575303, JString, required = true,
                                 default = nil)
  if valid_575303 != nil:
    section.add "resourceGroupName", valid_575303
  var valid_575304 = path.getOrDefault("subscriptionId")
  valid_575304 = validateParameter(valid_575304, JString, required = true,
                                 default = nil)
  if valid_575304 != nil:
    section.add "subscriptionId", valid_575304
  var valid_575305 = path.getOrDefault("resourceName")
  valid_575305 = validateParameter(valid_575305, JString, required = true,
                                 default = nil)
  if valid_575305 != nil:
    section.add "resourceName", valid_575305
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575306 = query.getOrDefault("api-version")
  valid_575306 = validateParameter(valid_575306, JString, required = true,
                                 default = nil)
  if valid_575306 != nil:
    section.add "api-version", valid_575306
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

proc call*(call_575308: Call_EnterpriseChannelsUpdate_575300; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an Enterprise Channel.
  ## 
  let valid = call_575308.validator(path, query, header, formData, body)
  let scheme = call_575308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575308.url(scheme.get, call_575308.host, call_575308.base,
                         call_575308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575308, url, valid)

proc call*(call_575309: Call_EnterpriseChannelsUpdate_575300;
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
  var path_575310 = newJObject()
  var query_575311 = newJObject()
  var body_575312 = newJObject()
  add(path_575310, "resourceGroupName", newJString(resourceGroupName))
  add(query_575311, "api-version", newJString(apiVersion))
  add(path_575310, "subscriptionId", newJString(subscriptionId))
  add(path_575310, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_575312 = parameters
  result = call_575309.call(path_575310, query_575311, nil, nil, body_575312)

var enterpriseChannelsUpdate* = Call_EnterpriseChannelsUpdate_575300(
    name: "enterpriseChannelsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/enterpriseChannels/{resourceName}",
    validator: validate_EnterpriseChannelsUpdate_575301, base: "",
    url: url_EnterpriseChannelsUpdate_575302, schemes: {Scheme.Https})
type
  Call_EnterpriseChannelsDelete_575289 = ref object of OpenApiRestCall_574466
proc url_EnterpriseChannelsDelete_575291(protocol: Scheme; host: string;
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

proc validate_EnterpriseChannelsDelete_575290(path: JsonNode; query: JsonNode;
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
  var valid_575292 = path.getOrDefault("resourceGroupName")
  valid_575292 = validateParameter(valid_575292, JString, required = true,
                                 default = nil)
  if valid_575292 != nil:
    section.add "resourceGroupName", valid_575292
  var valid_575293 = path.getOrDefault("subscriptionId")
  valid_575293 = validateParameter(valid_575293, JString, required = true,
                                 default = nil)
  if valid_575293 != nil:
    section.add "subscriptionId", valid_575293
  var valid_575294 = path.getOrDefault("resourceName")
  valid_575294 = validateParameter(valid_575294, JString, required = true,
                                 default = nil)
  if valid_575294 != nil:
    section.add "resourceName", valid_575294
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575295 = query.getOrDefault("api-version")
  valid_575295 = validateParameter(valid_575295, JString, required = true,
                                 default = nil)
  if valid_575295 != nil:
    section.add "api-version", valid_575295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575296: Call_EnterpriseChannelsDelete_575289; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Enterprise Channel from the resource group
  ## 
  let valid = call_575296.validator(path, query, header, formData, body)
  let scheme = call_575296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575296.url(scheme.get, call_575296.host, call_575296.base,
                         call_575296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575296, url, valid)

proc call*(call_575297: Call_EnterpriseChannelsDelete_575289;
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
  var path_575298 = newJObject()
  var query_575299 = newJObject()
  add(path_575298, "resourceGroupName", newJString(resourceGroupName))
  add(query_575299, "api-version", newJString(apiVersion))
  add(path_575298, "subscriptionId", newJString(subscriptionId))
  add(path_575298, "resourceName", newJString(resourceName))
  result = call_575297.call(path_575298, query_575299, nil, nil, nil)

var enterpriseChannelsDelete* = Call_EnterpriseChannelsDelete_575289(
    name: "enterpriseChannelsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.BotService/enterpriseChannels/{resourceName}",
    validator: validate_EnterpriseChannelsDelete_575290, base: "",
    url: url_EnterpriseChannelsDelete_575291, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
