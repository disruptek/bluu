
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: EventGridManagementClient
## version: 2017-06-15-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure EventGrid Management Client
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

  OpenApiRestCall_567642 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567642](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567642): Option[Scheme] {.used.} =
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
  macServiceName = "eventgrid-EventGrid"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567864 = ref object of OpenApiRestCall_567642
proc url_OperationsList_567866(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567865(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## List the available operations supported by the Microsoft.EventGrid resource provider
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
  var valid_568025 = query.getOrDefault("api-version")
  valid_568025 = validateParameter(valid_568025, JString, required = true,
                                 default = nil)
  if valid_568025 != nil:
    section.add "api-version", valid_568025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568048: Call_OperationsList_567864; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the available operations supported by the Microsoft.EventGrid resource provider
  ## 
  let valid = call_568048.validator(path, query, header, formData, body)
  let scheme = call_568048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568048.url(scheme.get, call_568048.host, call_568048.base,
                         call_568048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568048, url, valid)

proc call*(call_568119: Call_OperationsList_567864; apiVersion: string): Recallable =
  ## operationsList
  ## List the available operations supported by the Microsoft.EventGrid resource provider
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var query_568120 = newJObject()
  add(query_568120, "api-version", newJString(apiVersion))
  result = call_568119.call(nil, query_568120, nil, nil, nil)

var operationsList* = Call_OperationsList_567864(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.EventGrid/operations",
    validator: validate_OperationsList_567865, base: "", url: url_OperationsList_567866,
    schemes: {Scheme.Https})
type
  Call_TopicTypesList_568160 = ref object of OpenApiRestCall_567642
proc url_TopicTypesList_568162(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TopicTypesList_568161(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## List all registered topic types
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
  var valid_568163 = query.getOrDefault("api-version")
  valid_568163 = validateParameter(valid_568163, JString, required = true,
                                 default = nil)
  if valid_568163 != nil:
    section.add "api-version", valid_568163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568164: Call_TopicTypesList_568160; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all registered topic types
  ## 
  let valid = call_568164.validator(path, query, header, formData, body)
  let scheme = call_568164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568164.url(scheme.get, call_568164.host, call_568164.base,
                         call_568164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568164, url, valid)

proc call*(call_568165: Call_TopicTypesList_568160; apiVersion: string): Recallable =
  ## topicTypesList
  ## List all registered topic types
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var query_568166 = newJObject()
  add(query_568166, "api-version", newJString(apiVersion))
  result = call_568165.call(nil, query_568166, nil, nil, nil)

var topicTypesList* = Call_TopicTypesList_568160(name: "topicTypesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.EventGrid/topicTypes",
    validator: validate_TopicTypesList_568161, base: "", url: url_TopicTypesList_568162,
    schemes: {Scheme.Https})
type
  Call_TopicTypesGet_568167 = ref object of OpenApiRestCall_567642
proc url_TopicTypesGet_568169(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "topicTypeName" in path, "`topicTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.EventGrid/topicTypes/"),
               (kind: VariableSegment, value: "topicTypeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicTypesGet_568168(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about a topic type
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   topicTypeName: JString (required)
  ##                : Name of the topic type
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `topicTypeName` field"
  var valid_568184 = path.getOrDefault("topicTypeName")
  valid_568184 = validateParameter(valid_568184, JString, required = true,
                                 default = nil)
  if valid_568184 != nil:
    section.add "topicTypeName", valid_568184
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568185 = query.getOrDefault("api-version")
  valid_568185 = validateParameter(valid_568185, JString, required = true,
                                 default = nil)
  if valid_568185 != nil:
    section.add "api-version", valid_568185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568186: Call_TopicTypesGet_568167; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about a topic type
  ## 
  let valid = call_568186.validator(path, query, header, formData, body)
  let scheme = call_568186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568186.url(scheme.get, call_568186.host, call_568186.base,
                         call_568186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568186, url, valid)

proc call*(call_568187: Call_TopicTypesGet_568167; topicTypeName: string;
          apiVersion: string): Recallable =
  ## topicTypesGet
  ## Get information about a topic type
  ##   topicTypeName: string (required)
  ##                : Name of the topic type
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var path_568188 = newJObject()
  var query_568189 = newJObject()
  add(path_568188, "topicTypeName", newJString(topicTypeName))
  add(query_568189, "api-version", newJString(apiVersion))
  result = call_568187.call(path_568188, query_568189, nil, nil, nil)

var topicTypesGet* = Call_TopicTypesGet_568167(name: "topicTypesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.EventGrid/topicTypes/{topicTypeName}",
    validator: validate_TopicTypesGet_568168, base: "", url: url_TopicTypesGet_568169,
    schemes: {Scheme.Https})
type
  Call_TopicTypesListEventTypes_568190 = ref object of OpenApiRestCall_567642
proc url_TopicTypesListEventTypes_568192(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "topicTypeName" in path, "`topicTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.EventGrid/topicTypes/"),
               (kind: VariableSegment, value: "topicTypeName"),
               (kind: ConstantSegment, value: "/eventTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicTypesListEventTypes_568191(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List event types for a topic type
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   topicTypeName: JString (required)
  ##                : Name of the topic type
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `topicTypeName` field"
  var valid_568193 = path.getOrDefault("topicTypeName")
  valid_568193 = validateParameter(valid_568193, JString, required = true,
                                 default = nil)
  if valid_568193 != nil:
    section.add "topicTypeName", valid_568193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568194 = query.getOrDefault("api-version")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "api-version", valid_568194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568195: Call_TopicTypesListEventTypes_568190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List event types for a topic type
  ## 
  let valid = call_568195.validator(path, query, header, formData, body)
  let scheme = call_568195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568195.url(scheme.get, call_568195.host, call_568195.base,
                         call_568195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568195, url, valid)

proc call*(call_568196: Call_TopicTypesListEventTypes_568190;
          topicTypeName: string; apiVersion: string): Recallable =
  ## topicTypesListEventTypes
  ## List event types for a topic type
  ##   topicTypeName: string (required)
  ##                : Name of the topic type
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var path_568197 = newJObject()
  var query_568198 = newJObject()
  add(path_568197, "topicTypeName", newJString(topicTypeName))
  add(query_568198, "api-version", newJString(apiVersion))
  result = call_568196.call(path_568197, query_568198, nil, nil, nil)

var topicTypesListEventTypes* = Call_TopicTypesListEventTypes_568190(
    name: "topicTypesListEventTypes", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.EventGrid/topicTypes/{topicTypeName}/eventTypes",
    validator: validate_TopicTypesListEventTypes_568191, base: "",
    url: url_TopicTypesListEventTypes_568192, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListGlobalBySubscription_568199 = ref object of OpenApiRestCall_567642
proc url_EventSubscriptionsListGlobalBySubscription_568201(protocol: Scheme;
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
        value: "/providers/Microsoft.EventGrid/eventSubscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventSubscriptionsListGlobalBySubscription_568200(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all aggregated global event subscriptions under a specific Azure subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568202 = path.getOrDefault("subscriptionId")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "subscriptionId", valid_568202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568203 = query.getOrDefault("api-version")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "api-version", valid_568203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568204: Call_EventSubscriptionsListGlobalBySubscription_568199;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all aggregated global event subscriptions under a specific Azure subscription
  ## 
  let valid = call_568204.validator(path, query, header, formData, body)
  let scheme = call_568204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568204.url(scheme.get, call_568204.host, call_568204.base,
                         call_568204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568204, url, valid)

proc call*(call_568205: Call_EventSubscriptionsListGlobalBySubscription_568199;
          apiVersion: string; subscriptionId: string): Recallable =
  ## eventSubscriptionsListGlobalBySubscription
  ## List all aggregated global event subscriptions under a specific Azure subscription
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568206 = newJObject()
  var query_568207 = newJObject()
  add(query_568207, "api-version", newJString(apiVersion))
  add(path_568206, "subscriptionId", newJString(subscriptionId))
  result = call_568205.call(path_568206, query_568207, nil, nil, nil)

var eventSubscriptionsListGlobalBySubscription* = Call_EventSubscriptionsListGlobalBySubscription_568199(
    name: "eventSubscriptionsListGlobalBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventGrid/eventSubscriptions",
    validator: validate_EventSubscriptionsListGlobalBySubscription_568200,
    base: "", url: url_EventSubscriptionsListGlobalBySubscription_568201,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListRegionalBySubscription_568208 = ref object of OpenApiRestCall_567642
proc url_EventSubscriptionsListRegionalBySubscription_568210(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventGrid/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/eventSubscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventSubscriptionsListRegionalBySubscription_568209(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all event subscriptions from the given location under a specific Azure subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Name of the location
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568211 = path.getOrDefault("subscriptionId")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "subscriptionId", valid_568211
  var valid_568212 = path.getOrDefault("location")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "location", valid_568212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
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

proc call*(call_568214: Call_EventSubscriptionsListRegionalBySubscription_568208;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all event subscriptions from the given location under a specific Azure subscription
  ## 
  let valid = call_568214.validator(path, query, header, formData, body)
  let scheme = call_568214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568214.url(scheme.get, call_568214.host, call_568214.base,
                         call_568214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568214, url, valid)

proc call*(call_568215: Call_EventSubscriptionsListRegionalBySubscription_568208;
          apiVersion: string; subscriptionId: string; location: string): Recallable =
  ## eventSubscriptionsListRegionalBySubscription
  ## List all event subscriptions from the given location under a specific Azure subscription
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Name of the location
  var path_568216 = newJObject()
  var query_568217 = newJObject()
  add(query_568217, "api-version", newJString(apiVersion))
  add(path_568216, "subscriptionId", newJString(subscriptionId))
  add(path_568216, "location", newJString(location))
  result = call_568215.call(path_568216, query_568217, nil, nil, nil)

var eventSubscriptionsListRegionalBySubscription* = Call_EventSubscriptionsListRegionalBySubscription_568208(
    name: "eventSubscriptionsListRegionalBySubscription",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventGrid/locations/{location}/eventSubscriptions",
    validator: validate_EventSubscriptionsListRegionalBySubscription_568209,
    base: "", url: url_EventSubscriptionsListRegionalBySubscription_568210,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListRegionalBySubscriptionForTopicType_568218 = ref object of OpenApiRestCall_567642
proc url_EventSubscriptionsListRegionalBySubscriptionForTopicType_568220(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "topicTypeName" in path, "`topicTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventGrid/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/topicTypes/"),
               (kind: VariableSegment, value: "topicTypeName"),
               (kind: ConstantSegment, value: "/eventSubscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventSubscriptionsListRegionalBySubscriptionForTopicType_568219(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all event subscriptions from the given location under a specific Azure subscription and topic type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   topicTypeName: JString (required)
  ##                : Name of the topic type
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Name of the location
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `topicTypeName` field"
  var valid_568221 = path.getOrDefault("topicTypeName")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "topicTypeName", valid_568221
  var valid_568222 = path.getOrDefault("subscriptionId")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "subscriptionId", valid_568222
  var valid_568223 = path.getOrDefault("location")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "location", valid_568223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568224 = query.getOrDefault("api-version")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "api-version", valid_568224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568225: Call_EventSubscriptionsListRegionalBySubscriptionForTopicType_568218;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all event subscriptions from the given location under a specific Azure subscription and topic type.
  ## 
  let valid = call_568225.validator(path, query, header, formData, body)
  let scheme = call_568225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568225.url(scheme.get, call_568225.host, call_568225.base,
                         call_568225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568225, url, valid)

proc call*(call_568226: Call_EventSubscriptionsListRegionalBySubscriptionForTopicType_568218;
          topicTypeName: string; apiVersion: string; subscriptionId: string;
          location: string): Recallable =
  ## eventSubscriptionsListRegionalBySubscriptionForTopicType
  ## List all event subscriptions from the given location under a specific Azure subscription and topic type.
  ##   topicTypeName: string (required)
  ##                : Name of the topic type
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Name of the location
  var path_568227 = newJObject()
  var query_568228 = newJObject()
  add(path_568227, "topicTypeName", newJString(topicTypeName))
  add(query_568228, "api-version", newJString(apiVersion))
  add(path_568227, "subscriptionId", newJString(subscriptionId))
  add(path_568227, "location", newJString(location))
  result = call_568226.call(path_568227, query_568228, nil, nil, nil)

var eventSubscriptionsListRegionalBySubscriptionForTopicType* = Call_EventSubscriptionsListRegionalBySubscriptionForTopicType_568218(
    name: "eventSubscriptionsListRegionalBySubscriptionForTopicType",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventGrid/locations/{location}/topicTypes/{topicTypeName}/eventSubscriptions", validator: validate_EventSubscriptionsListRegionalBySubscriptionForTopicType_568219,
    base: "", url: url_EventSubscriptionsListRegionalBySubscriptionForTopicType_568220,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListGlobalBySubscriptionForTopicType_568229 = ref object of OpenApiRestCall_567642
proc url_EventSubscriptionsListGlobalBySubscriptionForTopicType_568231(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "topicTypeName" in path, "`topicTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventGrid/topicTypes/"),
               (kind: VariableSegment, value: "topicTypeName"),
               (kind: ConstantSegment, value: "/eventSubscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventSubscriptionsListGlobalBySubscriptionForTopicType_568230(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all global event subscriptions under an Azure subscription for a topic type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   topicTypeName: JString (required)
  ##                : Name of the topic type
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `topicTypeName` field"
  var valid_568232 = path.getOrDefault("topicTypeName")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "topicTypeName", valid_568232
  var valid_568233 = path.getOrDefault("subscriptionId")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "subscriptionId", valid_568233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
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

proc call*(call_568235: Call_EventSubscriptionsListGlobalBySubscriptionForTopicType_568229;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all global event subscriptions under an Azure subscription for a topic type.
  ## 
  let valid = call_568235.validator(path, query, header, formData, body)
  let scheme = call_568235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568235.url(scheme.get, call_568235.host, call_568235.base,
                         call_568235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568235, url, valid)

proc call*(call_568236: Call_EventSubscriptionsListGlobalBySubscriptionForTopicType_568229;
          topicTypeName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## eventSubscriptionsListGlobalBySubscriptionForTopicType
  ## List all global event subscriptions under an Azure subscription for a topic type.
  ##   topicTypeName: string (required)
  ##                : Name of the topic type
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568237 = newJObject()
  var query_568238 = newJObject()
  add(path_568237, "topicTypeName", newJString(topicTypeName))
  add(query_568238, "api-version", newJString(apiVersion))
  add(path_568237, "subscriptionId", newJString(subscriptionId))
  result = call_568236.call(path_568237, query_568238, nil, nil, nil)

var eventSubscriptionsListGlobalBySubscriptionForTopicType* = Call_EventSubscriptionsListGlobalBySubscriptionForTopicType_568229(
    name: "eventSubscriptionsListGlobalBySubscriptionForTopicType",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventGrid/topicTypes/{topicTypeName}/eventSubscriptions",
    validator: validate_EventSubscriptionsListGlobalBySubscriptionForTopicType_568230,
    base: "", url: url_EventSubscriptionsListGlobalBySubscriptionForTopicType_568231,
    schemes: {Scheme.Https})
type
  Call_TopicsListBySubscription_568239 = ref object of OpenApiRestCall_567642
proc url_TopicsListBySubscription_568241(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventGrid/topics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicsListBySubscription_568240(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the topics under an Azure subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568242 = path.getOrDefault("subscriptionId")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "subscriptionId", valid_568242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568243 = query.getOrDefault("api-version")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "api-version", valid_568243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568244: Call_TopicsListBySubscription_568239; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the topics under an Azure subscription
  ## 
  let valid = call_568244.validator(path, query, header, formData, body)
  let scheme = call_568244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568244.url(scheme.get, call_568244.host, call_568244.base,
                         call_568244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568244, url, valid)

proc call*(call_568245: Call_TopicsListBySubscription_568239; apiVersion: string;
          subscriptionId: string): Recallable =
  ## topicsListBySubscription
  ## List all the topics under an Azure subscription
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568246 = newJObject()
  var query_568247 = newJObject()
  add(query_568247, "api-version", newJString(apiVersion))
  add(path_568246, "subscriptionId", newJString(subscriptionId))
  result = call_568245.call(path_568246, query_568247, nil, nil, nil)

var topicsListBySubscription* = Call_TopicsListBySubscription_568239(
    name: "topicsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventGrid/topics",
    validator: validate_TopicsListBySubscription_568240, base: "",
    url: url_TopicsListBySubscription_568241, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListGlobalByResourceGroup_568248 = ref object of OpenApiRestCall_567642
proc url_EventSubscriptionsListGlobalByResourceGroup_568250(protocol: Scheme;
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
        value: "/providers/Microsoft.EventGrid/eventSubscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventSubscriptionsListGlobalByResourceGroup_568249(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all global event subscriptions under a specific Azure subscription and resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568251 = path.getOrDefault("resourceGroupName")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "resourceGroupName", valid_568251
  var valid_568252 = path.getOrDefault("subscriptionId")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "subscriptionId", valid_568252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568253 = query.getOrDefault("api-version")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "api-version", valid_568253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568254: Call_EventSubscriptionsListGlobalByResourceGroup_568248;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all global event subscriptions under a specific Azure subscription and resource group
  ## 
  let valid = call_568254.validator(path, query, header, formData, body)
  let scheme = call_568254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568254.url(scheme.get, call_568254.host, call_568254.base,
                         call_568254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568254, url, valid)

proc call*(call_568255: Call_EventSubscriptionsListGlobalByResourceGroup_568248;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## eventSubscriptionsListGlobalByResourceGroup
  ## List all global event subscriptions under a specific Azure subscription and resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568256 = newJObject()
  var query_568257 = newJObject()
  add(path_568256, "resourceGroupName", newJString(resourceGroupName))
  add(query_568257, "api-version", newJString(apiVersion))
  add(path_568256, "subscriptionId", newJString(subscriptionId))
  result = call_568255.call(path_568256, query_568257, nil, nil, nil)

var eventSubscriptionsListGlobalByResourceGroup* = Call_EventSubscriptionsListGlobalByResourceGroup_568248(
    name: "eventSubscriptionsListGlobalByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/eventSubscriptions",
    validator: validate_EventSubscriptionsListGlobalByResourceGroup_568249,
    base: "", url: url_EventSubscriptionsListGlobalByResourceGroup_568250,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListRegionalByResourceGroup_568258 = ref object of OpenApiRestCall_567642
proc url_EventSubscriptionsListRegionalByResourceGroup_568260(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventGrid/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/eventSubscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventSubscriptionsListRegionalByResourceGroup_568259(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all event subscriptions from the given location under a specific Azure subscription and resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Name of the location
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568261 = path.getOrDefault("resourceGroupName")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "resourceGroupName", valid_568261
  var valid_568262 = path.getOrDefault("subscriptionId")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "subscriptionId", valid_568262
  var valid_568263 = path.getOrDefault("location")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "location", valid_568263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568264 = query.getOrDefault("api-version")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "api-version", valid_568264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568265: Call_EventSubscriptionsListRegionalByResourceGroup_568258;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all event subscriptions from the given location under a specific Azure subscription and resource group
  ## 
  let valid = call_568265.validator(path, query, header, formData, body)
  let scheme = call_568265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568265.url(scheme.get, call_568265.host, call_568265.base,
                         call_568265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568265, url, valid)

proc call*(call_568266: Call_EventSubscriptionsListRegionalByResourceGroup_568258;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          location: string): Recallable =
  ## eventSubscriptionsListRegionalByResourceGroup
  ## List all event subscriptions from the given location under a specific Azure subscription and resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Name of the location
  var path_568267 = newJObject()
  var query_568268 = newJObject()
  add(path_568267, "resourceGroupName", newJString(resourceGroupName))
  add(query_568268, "api-version", newJString(apiVersion))
  add(path_568267, "subscriptionId", newJString(subscriptionId))
  add(path_568267, "location", newJString(location))
  result = call_568266.call(path_568267, query_568268, nil, nil, nil)

var eventSubscriptionsListRegionalByResourceGroup* = Call_EventSubscriptionsListRegionalByResourceGroup_568258(
    name: "eventSubscriptionsListRegionalByResourceGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/locations/{location}/eventSubscriptions",
    validator: validate_EventSubscriptionsListRegionalByResourceGroup_568259,
    base: "", url: url_EventSubscriptionsListRegionalByResourceGroup_568260,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListRegionalByResourceGroupForTopicType_568269 = ref object of OpenApiRestCall_567642
proc url_EventSubscriptionsListRegionalByResourceGroupForTopicType_568271(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "topicTypeName" in path, "`topicTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventGrid/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/topicTypes/"),
               (kind: VariableSegment, value: "topicTypeName"),
               (kind: ConstantSegment, value: "/eventSubscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventSubscriptionsListRegionalByResourceGroupForTopicType_568270(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all event subscriptions from the given location under a specific Azure subscription and resource group and topic type
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   topicTypeName: JString (required)
  ##                : Name of the topic type
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Name of the location
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `topicTypeName` field"
  var valid_568272 = path.getOrDefault("topicTypeName")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "topicTypeName", valid_568272
  var valid_568273 = path.getOrDefault("resourceGroupName")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "resourceGroupName", valid_568273
  var valid_568274 = path.getOrDefault("subscriptionId")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "subscriptionId", valid_568274
  var valid_568275 = path.getOrDefault("location")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "location", valid_568275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568276 = query.getOrDefault("api-version")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "api-version", valid_568276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568277: Call_EventSubscriptionsListRegionalByResourceGroupForTopicType_568269;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all event subscriptions from the given location under a specific Azure subscription and resource group and topic type
  ## 
  let valid = call_568277.validator(path, query, header, formData, body)
  let scheme = call_568277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568277.url(scheme.get, call_568277.host, call_568277.base,
                         call_568277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568277, url, valid)

proc call*(call_568278: Call_EventSubscriptionsListRegionalByResourceGroupForTopicType_568269;
          topicTypeName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## eventSubscriptionsListRegionalByResourceGroupForTopicType
  ## List all event subscriptions from the given location under a specific Azure subscription and resource group and topic type
  ##   topicTypeName: string (required)
  ##                : Name of the topic type
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Name of the location
  var path_568279 = newJObject()
  var query_568280 = newJObject()
  add(path_568279, "topicTypeName", newJString(topicTypeName))
  add(path_568279, "resourceGroupName", newJString(resourceGroupName))
  add(query_568280, "api-version", newJString(apiVersion))
  add(path_568279, "subscriptionId", newJString(subscriptionId))
  add(path_568279, "location", newJString(location))
  result = call_568278.call(path_568279, query_568280, nil, nil, nil)

var eventSubscriptionsListRegionalByResourceGroupForTopicType* = Call_EventSubscriptionsListRegionalByResourceGroupForTopicType_568269(
    name: "eventSubscriptionsListRegionalByResourceGroupForTopicType",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/locations/{location}/topicTypes/{topicTypeName}/eventSubscriptions", validator: validate_EventSubscriptionsListRegionalByResourceGroupForTopicType_568270,
    base: "", url: url_EventSubscriptionsListRegionalByResourceGroupForTopicType_568271,
    schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListGlobalByResourceGroupForTopicType_568281 = ref object of OpenApiRestCall_567642
proc url_EventSubscriptionsListGlobalByResourceGroupForTopicType_568283(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "topicTypeName" in path, "`topicTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventGrid/topicTypes/"),
               (kind: VariableSegment, value: "topicTypeName"),
               (kind: ConstantSegment, value: "/eventSubscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventSubscriptionsListGlobalByResourceGroupForTopicType_568282(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all global event subscriptions under a resource group for a specific topic type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   topicTypeName: JString (required)
  ##                : Name of the topic type
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `topicTypeName` field"
  var valid_568284 = path.getOrDefault("topicTypeName")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "topicTypeName", valid_568284
  var valid_568285 = path.getOrDefault("resourceGroupName")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "resourceGroupName", valid_568285
  var valid_568286 = path.getOrDefault("subscriptionId")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "subscriptionId", valid_568286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568287 = query.getOrDefault("api-version")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "api-version", valid_568287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568288: Call_EventSubscriptionsListGlobalByResourceGroupForTopicType_568281;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all global event subscriptions under a resource group for a specific topic type.
  ## 
  let valid = call_568288.validator(path, query, header, formData, body)
  let scheme = call_568288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568288.url(scheme.get, call_568288.host, call_568288.base,
                         call_568288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568288, url, valid)

proc call*(call_568289: Call_EventSubscriptionsListGlobalByResourceGroupForTopicType_568281;
          topicTypeName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## eventSubscriptionsListGlobalByResourceGroupForTopicType
  ## List all global event subscriptions under a resource group for a specific topic type.
  ##   topicTypeName: string (required)
  ##                : Name of the topic type
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568290 = newJObject()
  var query_568291 = newJObject()
  add(path_568290, "topicTypeName", newJString(topicTypeName))
  add(path_568290, "resourceGroupName", newJString(resourceGroupName))
  add(query_568291, "api-version", newJString(apiVersion))
  add(path_568290, "subscriptionId", newJString(subscriptionId))
  result = call_568289.call(path_568290, query_568291, nil, nil, nil)

var eventSubscriptionsListGlobalByResourceGroupForTopicType* = Call_EventSubscriptionsListGlobalByResourceGroupForTopicType_568281(
    name: "eventSubscriptionsListGlobalByResourceGroupForTopicType",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topicTypes/{topicTypeName}/eventSubscriptions", validator: validate_EventSubscriptionsListGlobalByResourceGroupForTopicType_568282,
    base: "", url: url_EventSubscriptionsListGlobalByResourceGroupForTopicType_568283,
    schemes: {Scheme.Https})
type
  Call_TopicsListByResourceGroup_568292 = ref object of OpenApiRestCall_567642
proc url_TopicsListByResourceGroup_568294(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventGrid/topics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicsListByResourceGroup_568293(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the topics under a resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568295 = path.getOrDefault("resourceGroupName")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "resourceGroupName", valid_568295
  var valid_568296 = path.getOrDefault("subscriptionId")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "subscriptionId", valid_568296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568297 = query.getOrDefault("api-version")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "api-version", valid_568297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568298: Call_TopicsListByResourceGroup_568292; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the topics under a resource group
  ## 
  let valid = call_568298.validator(path, query, header, formData, body)
  let scheme = call_568298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568298.url(scheme.get, call_568298.host, call_568298.base,
                         call_568298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568298, url, valid)

proc call*(call_568299: Call_TopicsListByResourceGroup_568292;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## topicsListByResourceGroup
  ## List all the topics under a resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568300 = newJObject()
  var query_568301 = newJObject()
  add(path_568300, "resourceGroupName", newJString(resourceGroupName))
  add(query_568301, "api-version", newJString(apiVersion))
  add(path_568300, "subscriptionId", newJString(subscriptionId))
  result = call_568299.call(path_568300, query_568301, nil, nil, nil)

var topicsListByResourceGroup* = Call_TopicsListByResourceGroup_568292(
    name: "topicsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics",
    validator: validate_TopicsListByResourceGroup_568293, base: "",
    url: url_TopicsListByResourceGroup_568294, schemes: {Scheme.Https})
type
  Call_TopicsCreateOrUpdate_568313 = ref object of OpenApiRestCall_567642
proc url_TopicsCreateOrUpdate_568315(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventGrid/topics/"),
               (kind: VariableSegment, value: "topicName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicsCreateOrUpdate_568314(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Asynchronously creates a new topic with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   topicName: JString (required)
  ##            : Name of the topic
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568316 = path.getOrDefault("resourceGroupName")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "resourceGroupName", valid_568316
  var valid_568317 = path.getOrDefault("topicName")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "topicName", valid_568317
  var valid_568318 = path.getOrDefault("subscriptionId")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "subscriptionId", valid_568318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568319 = query.getOrDefault("api-version")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "api-version", valid_568319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   topicInfo: JObject (required)
  ##            : Topic information
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568321: Call_TopicsCreateOrUpdate_568313; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Asynchronously creates a new topic with the specified parameters.
  ## 
  let valid = call_568321.validator(path, query, header, formData, body)
  let scheme = call_568321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568321.url(scheme.get, call_568321.host, call_568321.base,
                         call_568321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568321, url, valid)

proc call*(call_568322: Call_TopicsCreateOrUpdate_568313;
          resourceGroupName: string; apiVersion: string; topicName: string;
          subscriptionId: string; topicInfo: JsonNode): Recallable =
  ## topicsCreateOrUpdate
  ## Asynchronously creates a new topic with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   topicName: string (required)
  ##            : Name of the topic
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   topicInfo: JObject (required)
  ##            : Topic information
  var path_568323 = newJObject()
  var query_568324 = newJObject()
  var body_568325 = newJObject()
  add(path_568323, "resourceGroupName", newJString(resourceGroupName))
  add(query_568324, "api-version", newJString(apiVersion))
  add(path_568323, "topicName", newJString(topicName))
  add(path_568323, "subscriptionId", newJString(subscriptionId))
  if topicInfo != nil:
    body_568325 = topicInfo
  result = call_568322.call(path_568323, query_568324, nil, nil, body_568325)

var topicsCreateOrUpdate* = Call_TopicsCreateOrUpdate_568313(
    name: "topicsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}",
    validator: validate_TopicsCreateOrUpdate_568314, base: "",
    url: url_TopicsCreateOrUpdate_568315, schemes: {Scheme.Https})
type
  Call_TopicsGet_568302 = ref object of OpenApiRestCall_567642
proc url_TopicsGet_568304(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventGrid/topics/"),
               (kind: VariableSegment, value: "topicName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicsGet_568303(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Get properties of a topic
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   topicName: JString (required)
  ##            : Name of the topic
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568305 = path.getOrDefault("resourceGroupName")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "resourceGroupName", valid_568305
  var valid_568306 = path.getOrDefault("topicName")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "topicName", valid_568306
  var valid_568307 = path.getOrDefault("subscriptionId")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "subscriptionId", valid_568307
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568308 = query.getOrDefault("api-version")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "api-version", valid_568308
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568309: Call_TopicsGet_568302; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get properties of a topic
  ## 
  let valid = call_568309.validator(path, query, header, formData, body)
  let scheme = call_568309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568309.url(scheme.get, call_568309.host, call_568309.base,
                         call_568309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568309, url, valid)

proc call*(call_568310: Call_TopicsGet_568302; resourceGroupName: string;
          apiVersion: string; topicName: string; subscriptionId: string): Recallable =
  ## topicsGet
  ## Get properties of a topic
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   topicName: string (required)
  ##            : Name of the topic
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568311 = newJObject()
  var query_568312 = newJObject()
  add(path_568311, "resourceGroupName", newJString(resourceGroupName))
  add(query_568312, "api-version", newJString(apiVersion))
  add(path_568311, "topicName", newJString(topicName))
  add(path_568311, "subscriptionId", newJString(subscriptionId))
  result = call_568310.call(path_568311, query_568312, nil, nil, nil)

var topicsGet* = Call_TopicsGet_568302(name: "topicsGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}",
                                    validator: validate_TopicsGet_568303,
                                    base: "", url: url_TopicsGet_568304,
                                    schemes: {Scheme.Https})
type
  Call_TopicsDelete_568326 = ref object of OpenApiRestCall_567642
proc url_TopicsDelete_568328(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventGrid/topics/"),
               (kind: VariableSegment, value: "topicName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicsDelete_568327(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete existing topic
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   topicName: JString (required)
  ##            : Name of the topic
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568329 = path.getOrDefault("resourceGroupName")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "resourceGroupName", valid_568329
  var valid_568330 = path.getOrDefault("topicName")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "topicName", valid_568330
  var valid_568331 = path.getOrDefault("subscriptionId")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "subscriptionId", valid_568331
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
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

proc call*(call_568333: Call_TopicsDelete_568326; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete existing topic
  ## 
  let valid = call_568333.validator(path, query, header, formData, body)
  let scheme = call_568333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568333.url(scheme.get, call_568333.host, call_568333.base,
                         call_568333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568333, url, valid)

proc call*(call_568334: Call_TopicsDelete_568326; resourceGroupName: string;
          apiVersion: string; topicName: string; subscriptionId: string): Recallable =
  ## topicsDelete
  ## Delete existing topic
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   topicName: string (required)
  ##            : Name of the topic
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568335 = newJObject()
  var query_568336 = newJObject()
  add(path_568335, "resourceGroupName", newJString(resourceGroupName))
  add(query_568336, "api-version", newJString(apiVersion))
  add(path_568335, "topicName", newJString(topicName))
  add(path_568335, "subscriptionId", newJString(subscriptionId))
  result = call_568334.call(path_568335, query_568336, nil, nil, nil)

var topicsDelete* = Call_TopicsDelete_568326(name: "topicsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}",
    validator: validate_TopicsDelete_568327, base: "", url: url_TopicsDelete_568328,
    schemes: {Scheme.Https})
type
  Call_TopicsListSharedAccessKeys_568337 = ref object of OpenApiRestCall_567642
proc url_TopicsListSharedAccessKeys_568339(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventGrid/topics/"),
               (kind: VariableSegment, value: "topicName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicsListSharedAccessKeys_568338(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the two keys used to publish to a topic
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   topicName: JString (required)
  ##            : Name of the topic
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568340 = path.getOrDefault("resourceGroupName")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "resourceGroupName", valid_568340
  var valid_568341 = path.getOrDefault("topicName")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "topicName", valid_568341
  var valid_568342 = path.getOrDefault("subscriptionId")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "subscriptionId", valid_568342
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568343 = query.getOrDefault("api-version")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "api-version", valid_568343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568344: Call_TopicsListSharedAccessKeys_568337; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the two keys used to publish to a topic
  ## 
  let valid = call_568344.validator(path, query, header, formData, body)
  let scheme = call_568344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568344.url(scheme.get, call_568344.host, call_568344.base,
                         call_568344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568344, url, valid)

proc call*(call_568345: Call_TopicsListSharedAccessKeys_568337;
          resourceGroupName: string; apiVersion: string; topicName: string;
          subscriptionId: string): Recallable =
  ## topicsListSharedAccessKeys
  ## List the two keys used to publish to a topic
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   topicName: string (required)
  ##            : Name of the topic
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568346 = newJObject()
  var query_568347 = newJObject()
  add(path_568346, "resourceGroupName", newJString(resourceGroupName))
  add(query_568347, "api-version", newJString(apiVersion))
  add(path_568346, "topicName", newJString(topicName))
  add(path_568346, "subscriptionId", newJString(subscriptionId))
  result = call_568345.call(path_568346, query_568347, nil, nil, nil)

var topicsListSharedAccessKeys* = Call_TopicsListSharedAccessKeys_568337(
    name: "topicsListSharedAccessKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}/listKeys",
    validator: validate_TopicsListSharedAccessKeys_568338, base: "",
    url: url_TopicsListSharedAccessKeys_568339, schemes: {Scheme.Https})
type
  Call_TopicsRegenerateKey_568348 = ref object of OpenApiRestCall_567642
proc url_TopicsRegenerateKey_568350(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventGrid/topics/"),
               (kind: VariableSegment, value: "topicName"),
               (kind: ConstantSegment, value: "/regenerateKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicsRegenerateKey_568349(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Regenerate a shared access key for a topic
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   topicName: JString (required)
  ##            : Name of the topic
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568351 = path.getOrDefault("resourceGroupName")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "resourceGroupName", valid_568351
  var valid_568352 = path.getOrDefault("topicName")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "topicName", valid_568352
  var valid_568353 = path.getOrDefault("subscriptionId")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "subscriptionId", valid_568353
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568354 = query.getOrDefault("api-version")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "api-version", valid_568354
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   regenerateKeyRequest: JObject (required)
  ##                       : Request body to regenerate key
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568356: Call_TopicsRegenerateKey_568348; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerate a shared access key for a topic
  ## 
  let valid = call_568356.validator(path, query, header, formData, body)
  let scheme = call_568356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568356.url(scheme.get, call_568356.host, call_568356.base,
                         call_568356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568356, url, valid)

proc call*(call_568357: Call_TopicsRegenerateKey_568348; resourceGroupName: string;
          apiVersion: string; topicName: string; subscriptionId: string;
          regenerateKeyRequest: JsonNode): Recallable =
  ## topicsRegenerateKey
  ## Regenerate a shared access key for a topic
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   topicName: string (required)
  ##            : Name of the topic
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   regenerateKeyRequest: JObject (required)
  ##                       : Request body to regenerate key
  var path_568358 = newJObject()
  var query_568359 = newJObject()
  var body_568360 = newJObject()
  add(path_568358, "resourceGroupName", newJString(resourceGroupName))
  add(query_568359, "api-version", newJString(apiVersion))
  add(path_568358, "topicName", newJString(topicName))
  add(path_568358, "subscriptionId", newJString(subscriptionId))
  if regenerateKeyRequest != nil:
    body_568360 = regenerateKeyRequest
  result = call_568357.call(path_568358, query_568359, nil, nil, body_568360)

var topicsRegenerateKey* = Call_TopicsRegenerateKey_568348(
    name: "topicsRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}/regenerateKey",
    validator: validate_TopicsRegenerateKey_568349, base: "",
    url: url_TopicsRegenerateKey_568350, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsListByResource_568361 = ref object of OpenApiRestCall_567642
proc url_EventSubscriptionsListByResource_568363(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "providerNamespace" in path,
        "`providerNamespace` is a required path parameter"
  assert "resourceTypeName" in path,
        "`resourceTypeName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "providerNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceTypeName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.EventGrid/eventSubscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventSubscriptionsListByResource_568362(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all event subscriptions that have been created for a specific topic
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   providerNamespace: JString (required)
  ##                    : Namespace of the provider of the topic
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : Name of the resource
  ##   resourceTypeName: JString (required)
  ##                   : Name of the resource type
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `providerNamespace` field"
  var valid_568364 = path.getOrDefault("providerNamespace")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "providerNamespace", valid_568364
  var valid_568365 = path.getOrDefault("resourceGroupName")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "resourceGroupName", valid_568365
  var valid_568366 = path.getOrDefault("subscriptionId")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "subscriptionId", valid_568366
  var valid_568367 = path.getOrDefault("resourceName")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "resourceName", valid_568367
  var valid_568368 = path.getOrDefault("resourceTypeName")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = nil)
  if valid_568368 != nil:
    section.add "resourceTypeName", valid_568368
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568369 = query.getOrDefault("api-version")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "api-version", valid_568369
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568370: Call_EventSubscriptionsListByResource_568361;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all event subscriptions that have been created for a specific topic
  ## 
  let valid = call_568370.validator(path, query, header, formData, body)
  let scheme = call_568370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568370.url(scheme.get, call_568370.host, call_568370.base,
                         call_568370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568370, url, valid)

proc call*(call_568371: Call_EventSubscriptionsListByResource_568361;
          providerNamespace: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string; resourceTypeName: string): Recallable =
  ## eventSubscriptionsListByResource
  ## List all event subscriptions that have been created for a specific topic
  ##   providerNamespace: string (required)
  ##                    : Namespace of the provider of the topic
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : Name of the resource
  ##   resourceTypeName: string (required)
  ##                   : Name of the resource type
  var path_568372 = newJObject()
  var query_568373 = newJObject()
  add(path_568372, "providerNamespace", newJString(providerNamespace))
  add(path_568372, "resourceGroupName", newJString(resourceGroupName))
  add(query_568373, "api-version", newJString(apiVersion))
  add(path_568372, "subscriptionId", newJString(subscriptionId))
  add(path_568372, "resourceName", newJString(resourceName))
  add(path_568372, "resourceTypeName", newJString(resourceTypeName))
  result = call_568371.call(path_568372, query_568373, nil, nil, nil)

var eventSubscriptionsListByResource* = Call_EventSubscriptionsListByResource_568361(
    name: "eventSubscriptionsListByResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{providerNamespace}/{resourceTypeName}/{resourceName}/providers/Microsoft.EventGrid/eventSubscriptions",
    validator: validate_EventSubscriptionsListByResource_568362, base: "",
    url: url_EventSubscriptionsListByResource_568363, schemes: {Scheme.Https})
type
  Call_TopicsListEventTypes_568374 = ref object of OpenApiRestCall_567642
proc url_TopicsListEventTypes_568376(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "providerNamespace" in path,
        "`providerNamespace` is a required path parameter"
  assert "resourceTypeName" in path,
        "`resourceTypeName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "providerNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceTypeName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventGrid/eventTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicsListEventTypes_568375(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List event types for a topic
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   providerNamespace: JString (required)
  ##                    : Namespace of the provider of the topic
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : Name of the topic
  ##   resourceTypeName: JString (required)
  ##                   : Name of the topic type
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `providerNamespace` field"
  var valid_568377 = path.getOrDefault("providerNamespace")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "providerNamespace", valid_568377
  var valid_568378 = path.getOrDefault("resourceGroupName")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "resourceGroupName", valid_568378
  var valid_568379 = path.getOrDefault("subscriptionId")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "subscriptionId", valid_568379
  var valid_568380 = path.getOrDefault("resourceName")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "resourceName", valid_568380
  var valid_568381 = path.getOrDefault("resourceTypeName")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "resourceTypeName", valid_568381
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568382 = query.getOrDefault("api-version")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "api-version", valid_568382
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568383: Call_TopicsListEventTypes_568374; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List event types for a topic
  ## 
  let valid = call_568383.validator(path, query, header, formData, body)
  let scheme = call_568383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568383.url(scheme.get, call_568383.host, call_568383.base,
                         call_568383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568383, url, valid)

proc call*(call_568384: Call_TopicsListEventTypes_568374;
          providerNamespace: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string; resourceTypeName: string): Recallable =
  ## topicsListEventTypes
  ## List event types for a topic
  ##   providerNamespace: string (required)
  ##                    : Namespace of the provider of the topic
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : Name of the topic
  ##   resourceTypeName: string (required)
  ##                   : Name of the topic type
  var path_568385 = newJObject()
  var query_568386 = newJObject()
  add(path_568385, "providerNamespace", newJString(providerNamespace))
  add(path_568385, "resourceGroupName", newJString(resourceGroupName))
  add(query_568386, "api-version", newJString(apiVersion))
  add(path_568385, "subscriptionId", newJString(subscriptionId))
  add(path_568385, "resourceName", newJString(resourceName))
  add(path_568385, "resourceTypeName", newJString(resourceTypeName))
  result = call_568384.call(path_568385, query_568386, nil, nil, nil)

var topicsListEventTypes* = Call_TopicsListEventTypes_568374(
    name: "topicsListEventTypes", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{providerNamespace}/{resourceTypeName}/{resourceName}/providers/Microsoft.EventGrid/eventTypes",
    validator: validate_TopicsListEventTypes_568375, base: "",
    url: url_TopicsListEventTypes_568376, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsCreate_568397 = ref object of OpenApiRestCall_567642
proc url_EventSubscriptionsCreate_568399(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "eventSubscriptionName" in path,
        "`eventSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.EventGrid/eventSubscriptions/"),
               (kind: VariableSegment, value: "eventSubscriptionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventSubscriptionsCreate_568398(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Asynchronously creates a new event subscription to the specified scope. Existing event subscriptions cannot be updated with this API and should instead use the Update event subscription API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   eventSubscriptionName: JString (required)
  ##                        : Name of the event subscription to be created. Event subscription names must be between 3 and 64 characters in length and use alphanumeric letters only.
  ##   scope: JString (required)
  ##        : The scope of the resource to which the event subscription needs to be created. The scope can be a subscription, or a resource group, or a top level resource belonging to a resource provider namespace, or an EventGrid topic. For example, use '/subscriptions/{subscriptionId}/' for a subscription, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for a resource group, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}' for a resource, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}' for an EventGrid topic.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `eventSubscriptionName` field"
  var valid_568400 = path.getOrDefault("eventSubscriptionName")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "eventSubscriptionName", valid_568400
  var valid_568401 = path.getOrDefault("scope")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "scope", valid_568401
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568402 = query.getOrDefault("api-version")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "api-version", valid_568402
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   eventSubscriptionInfo: JObject (required)
  ##                        : Event subscription properties containing the destination and filter information
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568404: Call_EventSubscriptionsCreate_568397; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Asynchronously creates a new event subscription to the specified scope. Existing event subscriptions cannot be updated with this API and should instead use the Update event subscription API.
  ## 
  let valid = call_568404.validator(path, query, header, formData, body)
  let scheme = call_568404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568404.url(scheme.get, call_568404.host, call_568404.base,
                         call_568404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568404, url, valid)

proc call*(call_568405: Call_EventSubscriptionsCreate_568397;
          eventSubscriptionInfo: JsonNode; apiVersion: string;
          eventSubscriptionName: string; scope: string): Recallable =
  ## eventSubscriptionsCreate
  ## Asynchronously creates a new event subscription to the specified scope. Existing event subscriptions cannot be updated with this API and should instead use the Update event subscription API.
  ##   eventSubscriptionInfo: JObject (required)
  ##                        : Event subscription properties containing the destination and filter information
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   eventSubscriptionName: string (required)
  ##                        : Name of the event subscription to be created. Event subscription names must be between 3 and 64 characters in length and use alphanumeric letters only.
  ##   scope: string (required)
  ##        : The scope of the resource to which the event subscription needs to be created. The scope can be a subscription, or a resource group, or a top level resource belonging to a resource provider namespace, or an EventGrid topic. For example, use '/subscriptions/{subscriptionId}/' for a subscription, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for a resource group, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}' for a resource, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}' for an EventGrid topic.
  var path_568406 = newJObject()
  var query_568407 = newJObject()
  var body_568408 = newJObject()
  if eventSubscriptionInfo != nil:
    body_568408 = eventSubscriptionInfo
  add(query_568407, "api-version", newJString(apiVersion))
  add(path_568406, "eventSubscriptionName", newJString(eventSubscriptionName))
  add(path_568406, "scope", newJString(scope))
  result = call_568405.call(path_568406, query_568407, nil, nil, body_568408)

var eventSubscriptionsCreate* = Call_EventSubscriptionsCreate_568397(
    name: "eventSubscriptionsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.EventGrid/eventSubscriptions/{eventSubscriptionName}",
    validator: validate_EventSubscriptionsCreate_568398, base: "",
    url: url_EventSubscriptionsCreate_568399, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsGet_568387 = ref object of OpenApiRestCall_567642
proc url_EventSubscriptionsGet_568389(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "eventSubscriptionName" in path,
        "`eventSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.EventGrid/eventSubscriptions/"),
               (kind: VariableSegment, value: "eventSubscriptionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventSubscriptionsGet_568388(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get properties of an event subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   eventSubscriptionName: JString (required)
  ##                        : Name of the event subscription
  ##   scope: JString (required)
  ##        : The scope of the event subscription. The scope can be a subscription, or a resource group, or a top level resource belonging to a resource provider namespace, or an EventGrid topic. For example, use '/subscriptions/{subscriptionId}/' for a subscription, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for a resource group, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}' for a resource, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}' for an EventGrid topic.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `eventSubscriptionName` field"
  var valid_568390 = path.getOrDefault("eventSubscriptionName")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "eventSubscriptionName", valid_568390
  var valid_568391 = path.getOrDefault("scope")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "scope", valid_568391
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568392 = query.getOrDefault("api-version")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "api-version", valid_568392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568393: Call_EventSubscriptionsGet_568387; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get properties of an event subscription
  ## 
  let valid = call_568393.validator(path, query, header, formData, body)
  let scheme = call_568393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568393.url(scheme.get, call_568393.host, call_568393.base,
                         call_568393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568393, url, valid)

proc call*(call_568394: Call_EventSubscriptionsGet_568387; apiVersion: string;
          eventSubscriptionName: string; scope: string): Recallable =
  ## eventSubscriptionsGet
  ## Get properties of an event subscription
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   eventSubscriptionName: string (required)
  ##                        : Name of the event subscription
  ##   scope: string (required)
  ##        : The scope of the event subscription. The scope can be a subscription, or a resource group, or a top level resource belonging to a resource provider namespace, or an EventGrid topic. For example, use '/subscriptions/{subscriptionId}/' for a subscription, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for a resource group, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}' for a resource, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}' for an EventGrid topic.
  var path_568395 = newJObject()
  var query_568396 = newJObject()
  add(query_568396, "api-version", newJString(apiVersion))
  add(path_568395, "eventSubscriptionName", newJString(eventSubscriptionName))
  add(path_568395, "scope", newJString(scope))
  result = call_568394.call(path_568395, query_568396, nil, nil, nil)

var eventSubscriptionsGet* = Call_EventSubscriptionsGet_568387(
    name: "eventSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.EventGrid/eventSubscriptions/{eventSubscriptionName}",
    validator: validate_EventSubscriptionsGet_568388, base: "",
    url: url_EventSubscriptionsGet_568389, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsUpdate_568419 = ref object of OpenApiRestCall_567642
proc url_EventSubscriptionsUpdate_568421(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "eventSubscriptionName" in path,
        "`eventSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.EventGrid/eventSubscriptions/"),
               (kind: VariableSegment, value: "eventSubscriptionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventSubscriptionsUpdate_568420(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Asynchronously updates an existing event subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   eventSubscriptionName: JString (required)
  ##                        : Name of the event subscription to be created
  ##   scope: JString (required)
  ##        : The scope of existing event subscription. The scope can be a subscription, or a resource group, or a top level resource belonging to a resource provider namespace, or an EventGrid topic. For example, use '/subscriptions/{subscriptionId}/' for a subscription, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for a resource group, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}' for a resource, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}' for an EventGrid topic.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `eventSubscriptionName` field"
  var valid_568422 = path.getOrDefault("eventSubscriptionName")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "eventSubscriptionName", valid_568422
  var valid_568423 = path.getOrDefault("scope")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "scope", valid_568423
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568424 = query.getOrDefault("api-version")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "api-version", valid_568424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   eventSubscriptionUpdateParameters: JObject (required)
  ##                                    : Updated event subscription information
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568426: Call_EventSubscriptionsUpdate_568419; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Asynchronously updates an existing event subscription.
  ## 
  let valid = call_568426.validator(path, query, header, formData, body)
  let scheme = call_568426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568426.url(scheme.get, call_568426.host, call_568426.base,
                         call_568426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568426, url, valid)

proc call*(call_568427: Call_EventSubscriptionsUpdate_568419; apiVersion: string;
          eventSubscriptionName: string; scope: string;
          eventSubscriptionUpdateParameters: JsonNode): Recallable =
  ## eventSubscriptionsUpdate
  ## Asynchronously updates an existing event subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   eventSubscriptionName: string (required)
  ##                        : Name of the event subscription to be created
  ##   scope: string (required)
  ##        : The scope of existing event subscription. The scope can be a subscription, or a resource group, or a top level resource belonging to a resource provider namespace, or an EventGrid topic. For example, use '/subscriptions/{subscriptionId}/' for a subscription, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for a resource group, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}' for a resource, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}' for an EventGrid topic.
  ##   eventSubscriptionUpdateParameters: JObject (required)
  ##                                    : Updated event subscription information
  var path_568428 = newJObject()
  var query_568429 = newJObject()
  var body_568430 = newJObject()
  add(query_568429, "api-version", newJString(apiVersion))
  add(path_568428, "eventSubscriptionName", newJString(eventSubscriptionName))
  add(path_568428, "scope", newJString(scope))
  if eventSubscriptionUpdateParameters != nil:
    body_568430 = eventSubscriptionUpdateParameters
  result = call_568427.call(path_568428, query_568429, nil, nil, body_568430)

var eventSubscriptionsUpdate* = Call_EventSubscriptionsUpdate_568419(
    name: "eventSubscriptionsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.EventGrid/eventSubscriptions/{eventSubscriptionName}",
    validator: validate_EventSubscriptionsUpdate_568420, base: "",
    url: url_EventSubscriptionsUpdate_568421, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsDelete_568409 = ref object of OpenApiRestCall_567642
proc url_EventSubscriptionsDelete_568411(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "eventSubscriptionName" in path,
        "`eventSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.EventGrid/eventSubscriptions/"),
               (kind: VariableSegment, value: "eventSubscriptionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventSubscriptionsDelete_568410(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an existing event subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   eventSubscriptionName: JString (required)
  ##                        : Name of the event subscription
  ##   scope: JString (required)
  ##        : The scope of the event subscription. The scope can be a subscription, or a resource group, or a top level resource belonging to a resource provider namespace, or an EventGrid topic. For example, use '/subscriptions/{subscriptionId}/' for a subscription, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for a resource group, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}' for a resource, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}' for an EventGrid topic.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `eventSubscriptionName` field"
  var valid_568412 = path.getOrDefault("eventSubscriptionName")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "eventSubscriptionName", valid_568412
  var valid_568413 = path.getOrDefault("scope")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "scope", valid_568413
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568414 = query.getOrDefault("api-version")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "api-version", valid_568414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568415: Call_EventSubscriptionsDelete_568409; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing event subscription
  ## 
  let valid = call_568415.validator(path, query, header, formData, body)
  let scheme = call_568415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568415.url(scheme.get, call_568415.host, call_568415.base,
                         call_568415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568415, url, valid)

proc call*(call_568416: Call_EventSubscriptionsDelete_568409; apiVersion: string;
          eventSubscriptionName: string; scope: string): Recallable =
  ## eventSubscriptionsDelete
  ## Delete an existing event subscription
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   eventSubscriptionName: string (required)
  ##                        : Name of the event subscription
  ##   scope: string (required)
  ##        : The scope of the event subscription. The scope can be a subscription, or a resource group, or a top level resource belonging to a resource provider namespace, or an EventGrid topic. For example, use '/subscriptions/{subscriptionId}/' for a subscription, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for a resource group, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}' for a resource, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}' for an EventGrid topic.
  var path_568417 = newJObject()
  var query_568418 = newJObject()
  add(query_568418, "api-version", newJString(apiVersion))
  add(path_568417, "eventSubscriptionName", newJString(eventSubscriptionName))
  add(path_568417, "scope", newJString(scope))
  result = call_568416.call(path_568417, query_568418, nil, nil, nil)

var eventSubscriptionsDelete* = Call_EventSubscriptionsDelete_568409(
    name: "eventSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.EventGrid/eventSubscriptions/{eventSubscriptionName}",
    validator: validate_EventSubscriptionsDelete_568410, base: "",
    url: url_EventSubscriptionsDelete_568411, schemes: {Scheme.Https})
type
  Call_EventSubscriptionsGetFullUrl_568431 = ref object of OpenApiRestCall_567642
proc url_EventSubscriptionsGetFullUrl_568433(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "eventSubscriptionName" in path,
        "`eventSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.EventGrid/eventSubscriptions/"),
               (kind: VariableSegment, value: "eventSubscriptionName"),
               (kind: ConstantSegment, value: "/getFullUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventSubscriptionsGetFullUrl_568432(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the full endpoint URL for an event subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   eventSubscriptionName: JString (required)
  ##                        : Name of the event subscription
  ##   scope: JString (required)
  ##        : The scope of the event subscription. The scope can be a subscription, or a resource group, or a top level resource belonging to a resource provider namespace, or an EventGrid topic. For example, use '/subscriptions/{subscriptionId}/' for a subscription, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for a resource group, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}' for a resource, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}' for an EventGrid topic.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `eventSubscriptionName` field"
  var valid_568434 = path.getOrDefault("eventSubscriptionName")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "eventSubscriptionName", valid_568434
  var valid_568435 = path.getOrDefault("scope")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "scope", valid_568435
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568436 = query.getOrDefault("api-version")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "api-version", valid_568436
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568437: Call_EventSubscriptionsGetFullUrl_568431; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the full endpoint URL for an event subscription
  ## 
  let valid = call_568437.validator(path, query, header, formData, body)
  let scheme = call_568437.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568437.url(scheme.get, call_568437.host, call_568437.base,
                         call_568437.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568437, url, valid)

proc call*(call_568438: Call_EventSubscriptionsGetFullUrl_568431;
          apiVersion: string; eventSubscriptionName: string; scope: string): Recallable =
  ## eventSubscriptionsGetFullUrl
  ## Get the full endpoint URL for an event subscription
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   eventSubscriptionName: string (required)
  ##                        : Name of the event subscription
  ##   scope: string (required)
  ##        : The scope of the event subscription. The scope can be a subscription, or a resource group, or a top level resource belonging to a resource provider namespace, or an EventGrid topic. For example, use '/subscriptions/{subscriptionId}/' for a subscription, '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' for a resource group, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}' for a resource, and 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventGrid/topics/{topicName}' for an EventGrid topic.
  var path_568439 = newJObject()
  var query_568440 = newJObject()
  add(query_568440, "api-version", newJString(apiVersion))
  add(path_568439, "eventSubscriptionName", newJString(eventSubscriptionName))
  add(path_568439, "scope", newJString(scope))
  result = call_568438.call(path_568439, query_568440, nil, nil, nil)

var eventSubscriptionsGetFullUrl* = Call_EventSubscriptionsGetFullUrl_568431(
    name: "eventSubscriptionsGetFullUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.EventGrid/eventSubscriptions/{eventSubscriptionName}/getFullUrl",
    validator: validate_EventSubscriptionsGetFullUrl_568432, base: "",
    url: url_EventSubscriptionsGetFullUrl_568433, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
